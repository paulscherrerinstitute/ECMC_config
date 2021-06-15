#-d /**
#-d   \brief hardware script for LAB Motion Systems DriveBox
#-d   \details LAB Motion Systems DriveBox (dedivated servo drive for air bearings)
#-d   \details internally this is a Elmo Gold Whistle (https://www.elmomc.com/product/gold-whistle/)
#-d   \author Niko Kivel
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "DriveBox")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x0000009a")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x00030924")

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=false"

${SCRIPTEXEC} ${ecmccfg_DIR}ecmcElmoGW.cmd
