# ecmccfg

A configuration framework for ECMC Motion Control Module for EPICS.

## License

This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3 of the License, or
   (at your option) any later version.
   
This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software Foundation,
   Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA

## Build
by default this module is only build for RHEL7 and Epics >=R7.0.4
```bash
make [LIBVERSION] [clean] install
```
check the module loads for version `dev`, Epics R7.0.4.1 and ECMC version `poslag`, note `MASTER_ID=1` which runs ECMC in master-less mode.
```bash
iocsh -7.0.4.1 -r "ecmccfg,dev 'ECMC_VER=posLag,MASTER_ID=-1'"
```

## Purpose

The configuration framework contains the necessary files to configure an EPICS IOC for EtherCAT based motion control and DAQ.

## provided common user commands

* addAxis.cmd
* addDataStorage.cmd
* addMaster.cmd
* addSlave.cmd
* addSlaveKL.cmd
* addVirtualAxis.cmd
* applyAxisSynchronization.cmd
* applyConfig.cmd
* applySlaveConfig.cmd
* configureAxis.cmd
* configureSlave.cmd
* configureVirtualAxis.cmd
* loadPLCFile.cmd
* loadPlugin.cmd
* setAppMode.cmd
* setDiagnostics.cmd

## Example IOC

1.  `require` the configuration module with optional version
    ```bash
    require ecmccfg <VERSION>
    ```

2.  add a coupler and slave
    ```bash
      # slave 0 {ecmcEK1100}
      ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "HW_DESC=EK1100"
      # SLAVE_ID is automatically incremented
      # slave 1 {ecmcEL1018}
      ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "HW_DESC=EL1018"
      # skip slaves 2..6
      # slave 7 {ecmcEL2008}, with optional SLAVE_ID
      ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "HW_DESC=E2008, SLAVE_ID=7"
    ```
3.  add more slaves and apply configuration to the slaves
    ```bash
      # slave 8 {ecmcEL7037}, configure slave with optional SLAVE_ID
      ${SCRIPTEXEC} ${ecmccfg_DIR}configureSlave.cmd, "HW_DESC=EL7037, CONFIG=-Motor-Nanotec-ST4118L1804-B, SLAVE_ID=8"
      # slave 9 {ecmcEL7037}, addSlave, with immediate call off applySlaveConfig
      # slave with global configuration
      ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "HW_DESC=EL7037"
      ${SCRIPTEXEC} ${ecmccfg_DIR}applySlaveConfig,   "CONFIG=-Motor-Nanotec-ST4118L1804-B"
      # slave with local configuration, in this case provided by the module `ECMC_AGIR`
      epicsEnvSet("CFG_ROOT", "${ECMC_AGIR_DIR}/")
      ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "HW_DESC=EP7211-0034_ALL"
      ${SCRIPTEXEC} ${ecmccfg_DIR}applySlaveConfig.cmd, "LOCAL_CONFIG=${CFG_ROOT}AM8211_AGIR.cfg"

    ```

4.  apply the configuration
    ```bash
       ${SCRIPTEXEC} ${ecmccfg_DIR}applyConfig.cmd
    ```

5. additional configuration
    ```bash
       ecmcConfigOrDie "Cfg.WriteEcEntryIDString(${ECMC_EC_SLAVE_NUM_DIG_OUT},BO_1,1)"
    ```

6. adding a physical motor axis
   ```bash
      epicsEnvSet("DEV",      "STEST-MYDEVICE")
      ${SCRIPTEXEC} ${ecmccfg_DIR}configureAxis.cmd,            "CONFIG=./cfg/axis_1"
   ```

7. adding a virtual motor axis
   ```bash
      ${SCRIPTEXEC} ${ecmccfg_DIR}configureVirtualAxis.cmd,     "CONFIG=./cfg/axis_11_virt"
   ```

8. adding synchronization
   ```bash
      ${SCRIPTEXEC} ${ecmccfg_DIR}applyAxisSynchronization.cmd, "CONFIG=./cfg/axis_1_sync"
      ${SCRIPTEXEC} ${ecmccfg_DIR}applyAxisSynchronization.cmd, "CONFIG=./cfg/axis_11_sync"
   ```   

9. loading a PLC from file
   ```bash
      ${SCRIPTEXEC} ${ecmccfg_DIR}loadPLCFile.cmd, "PLC_ID=0, FILE=./plc/homeSlit.plc, SAMPLE_RATE_MS=100"
   ```   

10. go active
    ```bash
      ${SCRIPTEXEC} ${ecmccfg_DIR}setAppMode.cmd
    ```

