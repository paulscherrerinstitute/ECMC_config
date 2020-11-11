# EL72XX-XXXX Example


## Issue
Sometimes the slave will not go online at startup:

´´´
.....
2020/09/08 09:49:21.384 Starting up EtherCAT bus: 22 second(s). Max wait time 30 second(s).
2020/09/08 09:49:22.384 Starting up EtherCAT bus: 23 second(s). Max wait time 30 second(s).
2020/09/08 09:49:23.384 Starting up EtherCAT bus: 24 second(s). Max wait time 30 second(s).
2020/09/08 09:49:24.384 Starting up EtherCAT bus: 25 second(s). Max wait time 30 second(s).
2020/09/08 09:49:25.384 Starting up EtherCAT bus: 26 second(s). Max wait time 30 second(s).
2020/09/08 09:49:26.385 Starting up EtherCAT bus: 27 second(s). Max wait time 30 second(s).
2020/09/08 09:49:27.385 Starting up EtherCAT bus: 28 second(s). Max wait time 30 second(s).
2020/09/08 09:49:28.385 Starting up EtherCAT bus: 29 second(s). Max wait time 30 second(s).
2020/09/08 09:49:29.385 Timeout error: EtherCAT bus did not start correctly in 30s.
2020/09/08 09:49:29.400 ECMC command "Cfg.SetAppMode(1)" returned error: ERROR_EC_STATUS_NOT_OK (0x26013)

´´´

In the file /var/log/messages the following error can be seen:

´´´
Sep  8 09:54:21 mcag-epics4 kernel: EtherCAT ERROR 0-40: SDO download 0x1C32:01 (2 bytes) aborted.

´´´

or:

´´´
Sep  8 09:54:21 mcag-epics4 kernel: EtherCAT ERROR 0-40: SDO download 0x1C33:01 (2 bytes) aborted.

´´´

## Solution Workaround

Seems for certain slaves, maybe firmware related, that it's not allowed to write to the sync mode entries ("0x1C32:01" and "0x1C33:01").
If these SDO writes are excluded from the hardware configuration snippet the slave will normally go to OP..

´´´
# NOTE: Sometimes the EL7211-0010 will not go to op with the following error in /var/log/messages: 
# Sep  8 09:54:21 mcag-epics4 kernel: EtherCAT ERROR 0-40: SDO download 0x1C32:01 (2 bytes) aborted.
# Then if the below command is not executed the slave will go online abnd work. Could be related to firmware versions.. Also see below 0x1c33
#- Sync mode
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C32,0x1,3,2)"

´´´

and:

´´´
# NOTE: Sometimes the EL7211-0010 will not go to op with the following error in /var/log/messages: 
# Sep  8 09:54:21 mcag-epics4 kernel: EtherCAT ERROR 0-40: SDO download 0x1C33:01 (2 bytes) aborted.
# Then if the below command is not executed the slave will go online abnd work. Could be related to firmware versions.. Also see above 0x1c32
#- Sync mode
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C33,0x1,3,2)"
´´´

## Permanant solution
1. Need to figure out when the sync mode settings are needed or can be excluded. 

2. In the manuals it states that these objects are RW (read/Write) so it should be correct to have them in the snippet.

3. Maybe a firmware upgrade is needed for slaves with this issue?!

4. Work in progress..
 



