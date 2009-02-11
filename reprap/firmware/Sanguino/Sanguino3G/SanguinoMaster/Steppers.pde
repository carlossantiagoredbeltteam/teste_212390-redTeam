// Yep, this is actually -*- c++ -*-
//initialize our stepper drivers
void init_steppers()
{
  //clear our point buffer
  pointBuffer.clear();

  //pull in our saved values.
  read_range_from_eeprom();

  //prep timer 1 for handling DDA stuff.
  setupTimer1Interrupt();

  //initialize all our pins.
  pinMode(X_STEP_PIN, OUTPUT);
  pinMode(X_DIR_PIN, OUTPUT);
  pinMode(X_ENABLE_PIN, OUTPUT);
  pinMode(X_MIN_PIN, INPUT);
  pinMode(X_MAX_PIN, INPUT);

  pinMode(Y_STEP_PIN, OUTPUT);
  pinMode(Y_DIR_PIN, OUTPUT);
  pinMode(Y_ENABLE_PIN, OUTPUT);
  pinMode(Y_MIN_PIN, INPUT);
  pinMode(Y_MAX_PIN, INPUT);

  pinMode(Z_STEP_PIN, OUTPUT);
  pinMode(Z_DIR_PIN, OUTPUT);
  pinMode(Z_ENABLE_PIN, OUTPUT);
  pinMode(Z_MIN_PIN, INPUT);
  pinMode(Z_MAX_PIN, INPUT);

  //turn them off to start.
  disable_steppers();

  //zero our deltas.
  delta_steps.x = 0;
  delta_steps.y = 0;
  delta_steps.z = 0;
  
  //zero our posison.
  current_steps.x = 0;
  current_steps.y = 0;
  current_steps.z = 0;
  
  //zero our mega position.
  eventual_steps.x = 0;
  eventual_steps.y = 0;
  eventual_steps.z = 0;
  
  //probably not needed, but lets do it anyway.
  x_can_step = false;
  y_can_step = false;
  z_can_step = false;
}

void seek_minimums(boolean find_x, boolean find_y, boolean find_z, unsigned long step_delay, unsigned int timeout_seconds)
{
  unsigned long start = millis();
  unsigned long end = millis() + (timeout_seconds*1000);

  enable_steppers();

  boolean found_x = false;
  boolean found_y = false;
  boolean found_z = false;

  //do it until we time out.
  while (millis() < end)
  {
    //do our steps and check for mins.
    if (find_x && !found_x)
    {
      found_x = find_axis_min(X_STEP_PIN, X_DIR_PIN, X_MIN_PIN);
      current_steps.x = 0;
      eventual_steps.x = 0;
    }
    if (find_y && !found_y)
    {
      found_y = find_axis_min(Y_STEP_PIN, Y_DIR_PIN, Y_MIN_PIN);
      current_steps.y = 0;
      eventual_steps.y = 0;
    }
    if (find_z && !found_z)
    {
      found_z = find_axis_min(Z_STEP_PIN, Z_DIR_PIN, Z_MIN_PIN);
      current_steps.z = 0;
      eventual_steps.z = 0;
    }

    //check to see if we've found all required switches.
    if (find_x && !found_x)
      true;
    else if (find_y && !found_y)
      true;
    else if (find_z && !found_z)
      true;
    //found them all.
    else
      break;

    //do our delay for our axes.
    if (step_delay <= 65535)
      delayMicrosecondsInterruptible(step_delay);
    else
      delay(step_delay/1000);
  }
}

boolean find_axis_min(byte step_pin, byte dir_pin, byte min_pin)
{
  //are we at the minimum?
  if (read_switch(min_pin))
  {
    //move forward until the switch goes open. (slowly)
    digitalWrite(dir_pin, HIGH);
    while (read_switch(min_pin))
    {
      do_step(step_pin);
      delay(500);
    }

    //okay, now move us back one step.
    digitalWrite(dir_pin, LOW);
    do_step(step_pin);

    return true;
  }
  else
  {
    digitalWrite(dir_pin, LOW);
    do_step(step_pin);
  }

  return false;
}

void seek_maximums(boolean find_x, boolean find_y, boolean find_z, unsigned long step_delay, unsigned int timeout_seconds)
{
  unsigned long start = millis();
  unsigned long end = millis() + (timeout_seconds*1000);

  enable_steppers();

  boolean found_x = false;
  boolean found_y = false;
  boolean found_z = false;

  //do it until we time out.
  while (millis() < end)
  {
    //do our steps and check for mins.
    if (find_x && !found_x)
    {
      found_x = find_axis_max(X_STEP_PIN, X_DIR_PIN, X_MAX_PIN);
      range_steps.x = current_steps.x;
      eventual_steps.x = current_steps.x;
    }
    if (find_y && !found_y)
    {
      found_y = find_axis_max(Y_STEP_PIN, Y_DIR_PIN, Y_MAX_PIN);
      range_steps.y = current_steps.y;
      eventual_steps.y = current_steps.y;
    }
    if (find_z && !found_z)
    {
      found_z = find_axis_max(Z_STEP_PIN, Z_DIR_PIN, Z_MAX_PIN);
      range_steps.z = current_steps.z;
      eventual_steps.z = current_steps.z;
    }

    //check to see if we've found all required switches.
    if (find_x && !found_x)
      true;
    else if (find_y && !found_y)
      true;
    else if (find_z && !found_z)
      true;
    //found them all.
    else
    {
      write_range_to_eeprom();
      break;
    }

    //do our delay for our axes.
    if (step_delay <= 65535)
      delayMicrosecondsInterruptible(step_delay);
    else
      delay(step_delay/1000);
  }
}

boolean find_axis_max(byte step_pin, byte dir_pin, byte max_pin)
{
  //are we at the minimum?
  if (read_switch(max_pin))
  {
    //move forward until the switch goes open. (slowly)
    digitalWrite(dir_pin, LOW);
    while (read_switch(max_pin))
    {
      do_step(step_pin);
      delay(500);
    }

    //okay, now move us back one step.
    digitalWrite(dir_pin, HIGH);
    do_step(step_pin);

    return true;
  }
  else
  {
    digitalWrite(dir_pin, HIGH);
    do_step(step_pin);
  }

  return false;
}


//prepare our variables for a bresenham DDA run.
void prepare_dda()
{
  //whats our target?
  target_steps.x = current_steps.x + delta_steps.x;
  target_steps.y = current_steps.y + delta_steps.y;
  target_steps.z = current_steps.z + delta_steps.z;
  
  /*
  Serial.print("t:");
  Serial.print(target_steps.x, DEC);
  Serial.print(",");
  Serial.print(target_steps.y, DEC);
  Serial.print(",");
  Serial.print(target_steps.z, DEC);
  Serial.print(".");

  Serial.print("c:");
  Serial.print(current_steps.x, DEC);
  Serial.print(",");
  Serial.print(current_steps.y, DEC);
  Serial.print(",");
  Serial.print(current_steps.z, DEC);
  Serial.print(".");
  */
  
  //what is our direction
  x_direction = (target_steps.x >= current_steps.x);
  y_direction = (target_steps.y >= current_steps.y);
  z_direction = (target_steps.z >= current_steps.z);

  //set our direction pins as well
  digitalWrite(X_DIR_PIN, x_direction);
  digitalWrite(Y_DIR_PIN, y_direction);
  digitalWrite(Z_DIR_PIN, z_direction);

  //now get us absolute coords
  delta_steps.x = abs(delta_steps.x);
  delta_steps.y = abs(delta_steps.y);
  delta_steps.z = abs(delta_steps.z);

  //enable our steppers if needed.
  enable_steppers();

  //figure out our deltas
  max_delta = 0;
  max_delta = max(delta_steps.x, delta_steps.y);
  max_delta = max(delta_steps.z, max_delta);
  
  //init stuff.
  x_counter = -max_delta/2;
  y_counter = -max_delta/2;
  z_counter = -max_delta/2;
}

//do a single step on our DDA line!
inline void dda_step()
{
  //check endstops, position, etc.
  x_can_step = can_step(X_MIN_PIN, X_MAX_PIN, current_steps.x, target_steps.x, x_direction);
  y_can_step = can_step(Y_MIN_PIN, Y_MAX_PIN, current_steps.y, target_steps.y, y_direction);
  z_can_step = can_step(Z_MIN_PIN, Z_MAX_PIN, current_steps.z, target_steps.z, z_direction);

  //increment our x counter, and take steps if required.
  if (x_can_step)
  {
    x_counter += delta_steps.x;

    if (x_counter > 0)
    {
      do_step(X_STEP_PIN);
      x_counter -= max_delta;

      if (x_direction)
        current_steps.x++;
      else
        current_steps.x--;
    }
  }

  //increment our y counter, and take steps if required.
  if (y_can_step)
  {
    y_counter += delta_steps.y;

    if (y_counter > 0)
    {
      do_step(Y_STEP_PIN);
      y_counter -= max_delta;

      if (y_direction)
        current_steps.y++;
      else
        current_steps.y--;
    }
  }

  //increment our z counter, and take steps if required.
  if (z_can_step)
  {
    z_counter += delta_steps.z;

    if (z_counter > 0)
    {
      do_step(Z_STEP_PIN);
      z_counter -= max_delta;

      if (z_direction)
        current_steps.z++;
      else
        current_steps.z--;
    }
  }        

  //we're either at our target, or we're stuck.
  if (!x_can_step && !y_can_step && !z_can_step)
  {
    finishedPoints++;
    Serial.print("Finished:");
    Serial.println(finishedPoints, DEC);
    
    //set us to be at our target.
    current_steps.x = target_steps.x;
    current_steps.y = target_steps.y;
    current_steps.z = target_steps.z;

    //where to next, boss?
    grab_next_point();
  }
}

void grab_next_point()
{
  //can we even step to this?
  if (pointBuffer.size() >= POINT_SIZE)
  {
    //grab our new target
    delta_steps.x = (int)pointBuffer.remove_16();
    delta_steps.y = (int)pointBuffer.remove_16();
    delta_steps.z = (int)pointBuffer.remove_16();

    //figure out stuff for the move.
    prepare_dda();

    //start the move!
    setTimer1Resolution(pointBuffer.remove_8());
    setTimer1Ceiling(pointBuffer.remove_16());
  }
  //no more points?  why not bail.
  else
    disableTimer1Interrupt();
}

bool can_step(byte min_pin, byte max_pin, long current, long target, byte direction)
{
  //stop us if we're on target
  if (target == current)
    return false;
  //stop us if we're at home and still going 
//  else if (read_switch(min_pin) && !direction)
//    return false;
  //stop us if we're at max and still going
//  else if (read_switch(max_pin) && direction)
//    return false;

  //default to being able to step
  return true;
}

//actually send a step signal.
void do_step(byte step_pin)
{
  digitalWrite(step_pin, HIGH);
#ifdef STEP_DELAY
  delayMicrosecondsInterruptible(STEP_DELAY);
#endif
  digitalWrite(step_pin, LOW);
}

//figure out if we're at a switch or not
bool read_switch(byte pin)
{
  //dual read as crude debounce
  if (SENSORS_INVERTING)
    return !digitalRead(pin) && !digitalRead(pin);
  else
    return digitalRead(pin) && digitalRead(pin);
}

//enable our steppers so we can move them.
void enable_steppers()
{
  if (delta_steps.x > 0)
    digitalWrite(X_ENABLE_PIN, STEPPER_ENABLE);
  if (delta_steps.y > 0)
    digitalWrite(Y_ENABLE_PIN, STEPPER_ENABLE);
  if (delta_steps.z > 0)
    digitalWrite(Z_ENABLE_PIN, STEPPER_ENABLE);
}

//turn off steppers to save juice / keep things cool.
void disable_steppers()
{
  //disable our steppers
  digitalWrite(X_ENABLE_PIN, STEPPER_DISABLE);
  digitalWrite(Y_ENABLE_PIN, STEPPER_DISABLE);
  digitalWrite(Z_ENABLE_PIN, STEPPER_DISABLE);
}

//read all of our states into a single byte.
byte get_endstop_states()
{
  byte state = 0;

  //each one is its own bit in the byte.
  state |= read_switch(Z_MAX_PIN) << 5;
  state |= read_switch(Z_MIN_PIN) << 4;
  state |= read_switch(Y_MAX_PIN) << 3;
  state |= read_switch(Y_MIN_PIN) << 2;
  state |= read_switch(X_MAX_PIN) << 1;
  state |= read_switch(X_MIN_PIN);

  return state;
}

//TODO: make me work!
void write_range_to_eeprom()
{

}

//TODO: make me work!
void read_range_from_eeprom()
{

}

//queue a point for us to move to
void queue_incremental_point(int x, int y, int z, byte prescaler, unsigned int count)
{
  eventual_steps.x += x;
  eventual_steps.y += y;
  eventual_steps.z += z;

  //wait until we have free space
  while (pointBuffer.remainingCapacity() < POINT_SIZE)
    delay(1);

  //okay, add in our points.
  pointBuffer.append_16(x);
  pointBuffer.append_16(y);
  pointBuffer.append_16(z);

  Serial.print("Queued:");
  Serial.print(x, DEC);
  Serial.print(",");
  Serial.print(y, DEC);
  Serial.print(",");
  Serial.print(z, DEC);
  Serial.print(",");
  Serial.print(prescaler, DEC);
  Serial.print(",");
  Serial.print(count, DEC);
  Serial.println(".");
  
  // prescaler
  pointBuffer.append(prescaler);

  // counter
  pointBuffer.append_16(count);

  //turn our interrupt on.
  enableTimer1Interrupt();
}

//TODO: make this proportional based on the delta proportions.
//queue a point for us to move to
void queue_absolute_point(long x, long y, long z, byte prescaler, unsigned int count)
{
  //calculate our total travel in steps
  unsigned long delta_x = abs(x - eventual_steps.x);
  unsigned long delta_y = abs(y - eventual_steps.y);
  unsigned long delta_z = abs(z - eventual_steps.z);
  
  Serial.print("Deltas:");
  Serial.print(delta_x, DEC);
  Serial.print(",");
  Serial.print(delta_y, DEC);
  Serial.print(",");
  Serial.print(delta_z, DEC);
  Serial.println(".");

  //which is our longest?
  unsigned long max_delta = max(delta_x, delta_y);
  max_delta = max(max_delta, delta_z);

  //zero movement?  bail.
  if (max_delta == 0)
    return;

  //figure our ratios
  double x_ratio = delta_x / max_delta;
  double y_ratio = delta_y / max_delta;
  double z_ratio = delta_z / max_delta;

  //setup some variables.
  int x_inc, y_inc, z_inc;

  //keep queueing points while we can.
  int segments = 0;
  while (delta_x > 0 || delta_y > 0 || delta_z > 0)
  {
    //figure out our incremental points.
    x_inc = get_increment_from_absolute(delta_x, x_ratio, current_steps.x, x);
    y_inc = get_increment_from_absolute(delta_y, y_ratio, current_steps.y, y);
    z_inc = get_increment_from_absolute(delta_z, z_ratio, current_steps.z, z);

    //remove them from our deltas.
    delta_x -= abs(x_inc);
    delta_y -= abs(y_inc);
    delta_z -= abs(z_inc);

    //how many have we done?
    segments++;
    //Serial.print("Segments: ");
    //Serial.println(segments, DEC);

    //queue our point.
    queue_incremental_point(x_inc, y_inc, z_inc, prescaler, count);
  }
}

int get_increment_from_absolute(long delta, double ratio, long current, long target)
{
  //get a proportional point.
  int increment = ceil(ratio * 32767);

  //make sure its within the proper range.
  increment = min(delta, increment);

  //which direction?
  if (target < current)
    return -increment;
  else
    return increment;
}

boolean is_point_buffer_empty()
{
  //okay, we got points in the buffer.
  if (pointBuffer.size() > 0)
    return false;

  //still working on a point.
  if (current_steps.x != target_steps.x && current_steps.y != target_steps.y && current_steps.z != target_steps.z)
    return false;

  //nope, we're done.
  return true;
}

inline void wait_until_target_reached()
{
  while(!is_point_buffer_empty())
    delayMicrosecondsInterruptible(500);
}
