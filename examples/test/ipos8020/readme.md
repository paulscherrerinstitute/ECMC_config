# Test dir for ipos8020
Two example setups are available:

1. Open loop

2. Closed loop (resolver connected to EL7201)


# Notes on drive scaling

A raw velocity setpoint of 2^16 corresponds to 1000microsteps/second (for ESS generic stepper configuration).

So scaling for degrees would then be:
```
Based on (51200 microsteps/rev):
* 256microsteps/step*
* 200fullsteps

VeloSetScale = 2^16/1000.0*51200/360 = 9320.6755 (corresponds to 1 deg/s)

```

## Open loop

### Scaling (degrees)

Example of scaling of encoder for unit motor deg:

```
epicsEnvSet("ECMC_ENC_SCALE_NUM"          "360")    # One rev is 360deg
epicsEnvSet("ECMC_ENC_SCALE_DENOM"        "51200")  # Open loop counter scaled in micro steps (256levels per fullstep, 256*200=51200 counts/rev)  
```

Example of scaling of drive for unit motor deg:

```
epicsEnvSet("ECMC_DRV_SCALE_NUM"          "1")
epicsEnvSet("ECMC_DRV_SCALE_DENOM"        "9320.7")   # 9320.7 raw velocity setpoint corresponds to 1deg/s (based on the generic setup of the drive)
```

### Scaling (mm)

Example of scaling of encoder for unit mm (10mm/rev):

```
epicsEnvSet("ECMC_ENC_SCALE_NUM"          "10")       # One rev is 10 mm
epicsEnvSet("ECMC_ENC_SCALE_DENOM"        "51200")    # Open loop counter scaled in micro steps (256levels per fullstep, 256*200=51200)
```

Example of scaling of drive for unit mm (10mm/rev):

```
epicsEnvSet("ECMC_DRV_SCALE_NUM"          "1")
epicsEnvSet("ECMC_DRV_SCALE_DENOM"        "335544.3")   # 9320.7*360/10=335544.3 (335544.3 raw velocity setpoint to the drive corresponds to 1mm/s)  
```

## Closed loop

Closed loop example. Encoder is a resolver connected to an EL7201 (single turn resolution is 2^20).

### Scaling (degrees)

Example of scaling of encoder for unit motor deg:

```
epicsEnvSet("ECMC_ENC_SCALE_NUM"          "-360")     # 360deg/rev (- sign just because the combination of resolver and EL7201 have different positive direction than IPOS8020)
epicsEnvSet("ECMC_ENC_SCALE_DENOM"        "1048576")  # Single turn resolution of EL7201 (2^20) 
```

Example of scaling of drive for unit motor deg:

```
epicsEnvSet("ECMC_DRV_SCALE_NUM"          "1")
epicsEnvSet("ECMC_DRV_SCALE_DENOM"        "9320.7")   # 9320.7 raw velocity setpoint corresponds to 1deg/s (based on the generic setup of the drive)
```

### Scaling (mm)

Example of scaling of encoder for unit mm (10mm/rev):

```
epicsEnvSet("ECMC_ENC_SCALE_NUM"          "-10")     # 10mm/rev (- sign just because the combination of resolver and EL7201 have different positive direction than IPOS8020)
epicsEnvSet("ECMC_ENC_SCALE_DENOM"        "1048576")  # Single turn resolution of EL7201 (2^20) 
```

Example of scaling of drive for unit mm (10mm/rev):

```
epicsEnvSet("ECMC_DRV_SCALE_NUM"          "1")
epicsEnvSet("ECMC_DRV_SCALE_DENOM"        "335544.3")   # 9320.7*360/10=335544.3 (335544.3 raw velocity setpoint to the drive corresponds to 1mm/s)  

```

# Notes on TwinCAT

## Encoder scaling
Same encoder scaling as in ecmc in can be used

## Velocity scaling (CSV mode)

The iPOS8020 is a ds402 drive which means that the velocity scaling factor should be used (and not reference velocity).

The TwinCAT NC is setup for the AX2000 as a reference. Even if you know the scalings of the drive velocity setpoint it's hard to deduce the twicat NC velocity scaling factor since this drive needs to be compared to AX2000. This makes it hard to find the correct velocity scaling factor. 
Also the velocity scaling is wheighted with the encoder scaling denominator (or encoder mask).  The ecmc velocity scaling factor can NOT be used.

By trail and error some settings that works for open and closed loop have been identified.

### Open loop
For open loop with units deg/s an velocity scaling factor of 8190 can be used.
Note: This is based on the generic ess ipos EasySetup config.

### Closed loop resolver
For closed loop with resolver connected to EL7201 the velocity scaling factor needs to be recalulated:
```
VelocityScalingFactor=8190*51200/1048576=399,9

```
So, basically the velocity scaling factor needs to linearly scaled with the encoder denominator (or encoder mask abs).







