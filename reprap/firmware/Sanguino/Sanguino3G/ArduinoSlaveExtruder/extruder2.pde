

void init_extruder()
{
	
}

void manage_temperature()
{
	
}

void enable_motor_1()
{
	
}

void disable_motor_1()
{
	
}

void enable_motor_2()
{
	
}

void disable_motor_2()
{
	
}
void enable_fan()
{
	
}

void disable_fan()
{
	
}

void open_valve()
{
	
}

void close_valve()
{
	
}

byte is_tool_ready()
{
	//are we within 5% of the temperature?
	if (current_temperature > (int)(target_temperature * 0.95))
		return 1;
	else
		return 0;
}
