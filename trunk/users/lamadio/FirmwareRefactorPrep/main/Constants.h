
// Observed Event
const uint32_t ObservedEvent_None = 0;
const uint32_t ObservedEvent_Attached = 1;
const uint32_t ObservedEvent_Detached = 2;
const uint32_t ObservedEvent_Destroyed = 3;

// ThermisterEvent
const uint32_t ThermisterEvent_Change = 4;

// StepperEvent
const uint32_t StepperEvent_Start = 5;
const uint32_t StepperEvent_Stop = 6;
const uint32_t StepperEvent_Complete = 7;

// OpticalInterrupt
const uint32_t OpticalInterrupt_Interrupted = 8;

// LinearActuator
const uint32_t LinearActuator_CompletedMove = 9;
const uint32_t LinearActuator_Extent = 10;
const uint32_t LinearActuator_Homed = 11;

// ExtruderDevice
const uint32_t ExtruderDevice_AtTemp = 12;
const uint32_t ExtruderDevice_OutOfTemp = 13;
const uint32_t ExtruderDevice_Extruding = 14;
const uint32_t ExtruderDevice_Stopped = 15;

// CartesianDevice
const uint32_t CartesianDevice_Homed = 16;
const uint32_t CartesianDevice_MovingToNewPosition = 17;
const uint32_t CartesianDevice_ReachedNewPosition = 18;
const uint32_t CartesianDevice_PositionError = 19;



// Interfaces
const uint32_t IDevice = 0;

