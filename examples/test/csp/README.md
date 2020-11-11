# Directory for CSP configuration

## Tested hardware
### EL7211:
Seems to work well. See dedicated README in subdir.

### EL7037 (not real CSP mode, called  "Position control")
Works only if enable at raw encoder value equal to zero. Otherwise stange jumps will appear.
TwinCAT probablly resets encoder raw position before every enable cmd (by trigger write to encoder value and the corresponding cmd bit)

## Important things to consider:
 1. CSP needs special PDO mapping (since "position target" needs to be mapped instead of velocity setpoint)
 2. Scaling needs to be same for both encoder and drv object in the axis cfg file.
 3. Only link the SET_POSITION PDO if you want to run CSP. If VELOCITY_SETPOINT is also linked, then ecmc will default to CSV, generating velocity setpoints instead.
 4. In CSP-mode, the position loop is executed in the drive. Therefore, all position control loop params needs to be set in the drive locally (by SDO). Setting of ecmc position loop control parameters will result in an warning message at validation. Set all ecmc controller params to 0 to avaid warning message:
```
#Controller: THESE ARE NOT USED SINCE IN CSP.. SET TO 0 to avoid warning!
epicsEnvSet("ECMC_CNTRL_KP",              "0")
epicsEnvSet("ECMC_CNTRL_KI",              "0")
epicsEnvSet("ECMC_CNTRL_KD",              "0")
epicsEnvSet("ECMC_CNTRL_KFF",             "0")
```
