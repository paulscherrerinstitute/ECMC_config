# Directory for CSP configuration for EL7037
Note 1: EL7037 have no real CSP mode but is configured to run in "Position Control" mode instead

Note 2: This config still results in some jumps in position now and then when enabling/disabling the drive.
Same happend both when using ecmc axis and running direct from ethercat entries. Need to try with twincat to compare.

Note 3: Homing still not working.

Note 4: Next step should be to test with EL7201 series (since "real" CSP)

## Nice to know (WIP)
1. Important to use the 32 bit encoder since position setpoint is also 32 bit 
2. Seems there could be a need to reset the encoder before start (the reset encooder bit and value a re linked in TC), eventhough ecmc is already offsettinng the value
3. 

## Possible solution
Since the control works fine when enabling at position 0. A workareound would be to zero the encoder for each enable. This is probably how it's solved in TwinCAT since the reset bit and value is lin ked to NC.
This is a rather wierd and specific case so probbaly not worth putting more time in to CSP on el7037.

CSP works well for EL7211 which have the "real" CSP mode.

