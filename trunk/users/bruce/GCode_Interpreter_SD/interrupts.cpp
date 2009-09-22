#if 0
volatile uint16_t stepcounter;

// Stepper interrupt. Will step the primary axis each time it's executed and
// use DDA to step the secondary axes.
ISR(TIMER1_COMPA_vect)
{
  // We will always step the primary axis, but we count it anyway
  // so we don't have to calculate which one is primary.
  for (uint8_t i=0;i<3;i++) {
    if (CAN_STEP(i)) {
      counter[i] += delta_steps[i];
      if (counter[i] > 0) {
        counter[i] -= max_delta;
        do_step(STEP_PIN(i));
        // Update current position
        if (direction[i]) current_steps[i]++;
        else current_steps[i]--;
      }
    }
  }
  stepcounter--;
  if (stepcounter == 0) {
    // stop interrupt
    TCCR1B &= ~(_BV(CS12) | _BV(CS11) | _BV(CS10));
    // signal main loop to dequeue next command
  }
}

void startLineSegment(Command cmd)
{
  uint16_t abs_delta_steps[3];
  bool direction[3];
  uint32_t maxstepdelay_us;
  // FIXME: Decode cmd into above variables
  max_delta = max(delta_steps[0], delta_steps[1]);
  max_delta = max(delta_steps[2], max_delta);
  
  int16_t counter[3];
  counter[0] = -max_delta/2;
  counter[1] = -max_delta/2;
  counter[2] = -max_delta/2;
  
  stepcounter = max_delta;

  // init interrupt parameters

  /*
    Timer resolution notes (@16MHz)
    Prescaler     16-bits timeout (us)
    1             4096
    8             32768
    64            256K
    256           1024K
    1024          4096K
  */

  // CTC mode
  TCCR1A &= ~(_BV(WGM11) | _BV(WGM10));
  TCCR1B &= ~_BV(WGM13);
  TCCR1B |= _BV(CTC1);
  
  // Calculate prescaler
  uint16_t prescaler;
  uint8_t prescaleflags = 0;
  if (maxstepdelay_us < 4096) {
    prescaleflags = _BV(CS10); // 1
    prescalebits = 0;
  }
  else if (maxstepdelay_us < 32768) {
    prescaleflags = _BV(CS11); // 8
    prescalebits = 3;
  }
  else if (maxstepdelay_us < 256*1024) {
    prescaleflags = _BV(CS11) | _BV(CS10); // 64
    prescalebits = 6;
  }
  else {
    prescaleflags = _BV(CS12) | _BV(CS10); // 256
    prescalebits = 8;
  }

  // Init CTC and timer values
  uint16_t topval = (maxstepdelay_us * (F_CPU/1000000)) >> (prescalebits + 1) - 1;
  OCR1A = topval;
  TCNT1 = 0;

  // start interrupt
  TCCR1B &= ~(_BV(CS12) | _BV(CS11) | _BV(CS10));
  TCCR1B |= prescaleflags;
}
#endif
