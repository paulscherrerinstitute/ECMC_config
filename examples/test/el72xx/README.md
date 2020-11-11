# Directory EL72XX drives

## Notes
1. Seems different firmware reviosn need different configs. See comment in config files
2. 

## Trouble shooting

### trying to enable but nothing happends (eventually goes into error state with DS402 timeout)
Make sure the EL72XX have dc power, both for motor and 24 logic (the power contacts on the sides). The two bottom leds should light green.
If 24V logic voltage is missing the terminal will look OK (no red leds) and No error seems to be possible to detect over ethercat. However, an enable command will result in a DS402 timeout after some seconds. In order to ensure that the motor have 24V dc, it needs to be placed beside a terminal that feeds it with this voltage (some terminals do not feed power in the side contacts, then a el9410 can be installed).


### Terminal refuses to go online
The EL72XX terminals are a bit sensitve in the startup phase when the dc clock are beeing syncronized. It often helps to have a proper rt patched and rt-configured system.
