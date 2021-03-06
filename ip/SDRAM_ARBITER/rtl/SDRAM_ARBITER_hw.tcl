# Copyright 2018 ARDUINO SA (http://www.arduino.cc/)
# This file is part of Vidor IP.
# Copyright (c) 2018
# Authors: Dario Pennisi
#
# This software is released under:
# The GNU General Public License, which covers the main part of 
# Vidor IP
# The terms of this license can be found at:
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# You can be released from the requirements of the above licenses by purchasing
# a commercial license. Buying such a license is mandatory if you want to modify or
# otherwise use the software for commercial activities involving the Arduino
# software without disclosing the source code of your own applications. To purchase
# a commercial license, send an email to license@arduino.cc.

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module SDRAM_ARBITER
# 
set_module_property DESCRIPTION ""
set_module_property NAME SDRAM_ARBITER
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP ipTronix
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "SDRAM Arbiter"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property ELABORATION_CALLBACK elaborate


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL SDRAM_ARBITER
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file SDRAM_ARBITER.v VERILOG PATH SDRAM_ARBITER.v TOP_LEVEL_FILE


# 
# parameters
# 
add_parameter pBURST_SIZE INTEGER 64
set_parameter_property pBURST_SIZE DEFAULT_VALUE 64
set_parameter_property pBURST_SIZE DISPLAY_NAME BURST_SIZE
set_parameter_property pBURST_SIZE TYPE INTEGER
set_parameter_property pBURST_SIZE UNITS None
set_parameter_property pBURST_SIZE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property pBURST_SIZE HDL_PARAMETER true
add_parameter pCAM_OFFSET_A INTEGER 0
set_parameter_property pCAM_OFFSET_A DEFAULT_VALUE 0
set_parameter_property pCAM_OFFSET_A DISPLAY_NAME CAM_OFFSET
set_parameter_property pCAM_OFFSET_A TYPE INTEGER
set_parameter_property pCAM_OFFSET_A UNITS None
set_parameter_property pCAM_OFFSET_A ALLOWED_RANGES -2147483648:2147483647
set_parameter_property pCAM_OFFSET_A HDL_PARAMETER true
add_parameter pCAM_OFFSET_B INTEGER 307200
set_parameter_property pCAM_OFFSET_B DEFAULT_VALUE 307200
set_parameter_property pCAM_OFFSET_B DISPLAY_NAME CAM_OFFSET
set_parameter_property pCAM_OFFSET_B TYPE INTEGER
set_parameter_property pCAM_OFFSET_B UNITS None
set_parameter_property pCAM_OFFSET_B ALLOWED_RANGES -2147483648:2147483647
set_parameter_property pCAM_OFFSET_B HDL_PARAMETER true
add_parameter pFB_OFFSET INTEGER 614400
set_parameter_property pFB_OFFSET DEFAULT_VALUE 614400
set_parameter_property pFB_OFFSET DISPLAY_NAME FB_OFFSET
set_parameter_property pFB_OFFSET TYPE INTEGER
set_parameter_property pFB_OFFSET UNITS None
set_parameter_property pFB_OFFSET ALLOWED_RANGES -2147483648:2147483647
set_parameter_property pFB_OFFSET HDL_PARAMETER true
add_parameter pFB_SIZE INTEGER 307200
set_parameter_property pFB_SIZE DEFAULT_VALUE 307200
set_parameter_property pFB_SIZE DISPLAY_NAME FB_SIZE
set_parameter_property pFB_SIZE TYPE INTEGER
set_parameter_property pFB_SIZE UNITS None
set_parameter_property pFB_SIZE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property pFB_SIZE HDL_PARAMETER true
add_parameter pADDRESS_BITS INTEGER 22
set_parameter_property pADDRESS_BITS DEFAULT_VALUE 22
set_parameter_property pADDRESS_BITS DISPLAY_NAME ADDRESS_BITS
set_parameter_property pADDRESS_BITS TYPE INTEGER
set_parameter_property pADDRESS_BITS UNITS None
set_parameter_property pADDRESS_BITS ALLOWED_RANGES -2147483648:2147483647
set_parameter_property pADDRESS_BITS HDL_PARAMETER true


# 
# display items
# 


# 
# connection point sdram
# 
add_interface sdram avalon start
set_interface_property sdram addressUnits WORDS
set_interface_property sdram associatedClock clock
set_interface_property sdram associatedReset reset
set_interface_property sdram bitsPerSymbol 8
set_interface_property sdram burstOnBurstBoundariesOnly false
set_interface_property sdram burstcountUnits WORDS
set_interface_property sdram doStreamReads false
set_interface_property sdram doStreamWrites false
set_interface_property sdram holdTime 0
set_interface_property sdram linewrapBursts false
set_interface_property sdram maximumPendingReadTransactions 0
set_interface_property sdram maximumPendingWriteTransactions 0
set_interface_property sdram readLatency 0
set_interface_property sdram readWaitTime 1
set_interface_property sdram setupTime 0
set_interface_property sdram timingUnits Cycles
set_interface_property sdram writeWaitTime 0
set_interface_property sdram ENABLED true
set_interface_property sdram EXPORT_OF ""
set_interface_property sdram PORT_NAME_MAP ""
set_interface_property sdram CMSIS_SVD_VARIABLES ""
set_interface_property sdram SVD_ADDRESS_GROUP ""

add_interface_port sdram oSDRAM_ADDRESS address Output pADDRESS_BITS
add_interface_port sdram oSDRAM_WRITE write Output 1
add_interface_port sdram oSDRAM_READ read Output 1
add_interface_port sdram oSDRAM_WRITE_DATA writedata Output 16
add_interface_port sdram iSDRAM_READ_DATA readdata Input 16
add_interface_port sdram iSDRAM_WAIT_REQUEST waitrequest Input 1
add_interface_port sdram iSDRAM_READ_DATA_VALID readdatavalid Input 1
add_interface_port sdram oSDRAM_BYTE_ENABLE byteenable Output 2


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock iMEM_CLK clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset iRESET reset Input 1


# 
# connection point fb
# 
add_interface fb conduit end
set_interface_property fb associatedClock clock
set_interface_property fb associatedReset ""
set_interface_property fb ENABLED true
set_interface_property fb EXPORT_OF ""
set_interface_property fb PORT_NAME_MAP ""
set_interface_property fb CMSIS_SVD_VARIABLES ""
set_interface_property fb SVD_ADDRESS_GROUP ""

add_interface_port fb iFB_CLK clk Input 1
add_interface_port fb iFB_READY rdy Input 1
add_interface_port fb oFB_DATA data Output 31
add_interface_port fb oFB_DATA_VALID dv Output 1
add_interface_port fb oFB_START start Output 1


# 
# connection point mipi
# 
add_interface mipi conduit end
set_interface_property mipi associatedClock clock
set_interface_property mipi associatedReset ""
set_interface_property mipi ENABLED true
set_interface_property mipi EXPORT_OF ""
set_interface_property mipi PORT_NAME_MAP ""
set_interface_property mipi CMSIS_SVD_VARIABLES ""
set_interface_property mipi SVD_ADDRESS_GROUP ""

add_interface_port mipi iMIPI_CLK clk Input 1
add_interface_port mipi iMIPI_DATA data Input 15
add_interface_port mipi iMIPI_DATA_VALID dv Input 1
add_interface_port mipi iMIPI_START start Input 1


# 
# connection point avl
# 
add_interface avl avalon end
set_interface_property avl addressUnits WORDS
set_interface_property avl associatedClock clock
set_interface_property avl associatedReset reset
set_interface_property avl bitsPerSymbol 8
set_interface_property avl ENABLED true

add_interface_port avl oAVL_READ_DATA readdata Output 16
add_interface_port avl oAVL_READ_DATA_VALID readdatavalid Output 1
add_interface_port avl iAVL_WRITE_DATA writedata Input 16
add_interface_port avl oAVL_WAIT_REQUEST waitrequest Output 1
add_interface_port avl iAVL_ADDRESS address Input pADDRESS_BITS
add_interface_port avl iAVL_BURST_COUNT burstcount Input 6
add_interface_port avl iAVL_READ read Input 1
add_interface_port avl iAVL_WRITE write Input 1
add_interface_port avl iAVL_BYTE_ENABLE byteenable Input 2
set_interface_property avl burstOnBurstBoundariesOnly {0}
set_interface_property avl burstcountUnits {WORDS}
set_interface_property avl constantBurstBehavior {0}
set_interface_property avl explicitAddressSpan 8388608
set_interface_property avl holdTime {0}
set_interface_property avl interleaveBursts {0}
set_interface_property avl isBigEndian {0}
set_interface_property avl isFlash {0}
set_interface_property avl isMemoryDevice {1}
set_interface_property avl isNonVolatileStorage {0}
set_interface_property avl linewrapBursts {0}
set_interface_property avl maximumPendingReadTransactions {1}
set_interface_property avl minimumUninterruptedRunLength {1}
set_interface_property avl printableDevice {0}
set_interface_property avl readLatency 0
set_interface_property avl readWaitStates {0}
set_interface_property avl readWaitTime {0}
set_interface_property avl registerIncomingSignals {0}
set_interface_property avl registerOutgoingSignals {0}
set_interface_property avl setupTime {0}
set_interface_property avl timingUnits {Cycles}
set_interface_property avl transparentBridge {0}
set_interface_property avl wellBehavedWaitrequest {0}
set_interface_property avl writeLatency {0}
set_interface_property avl writeWaitStates {0}
set_interface_property avl writeWaitTime {0}

set_interface_assignment avl embeddedsw.configuration.isFlash {0}
set_interface_assignment avl embeddedsw.configuration.isMemoryDevice {1}
set_interface_assignment avl embeddedsw.configuration.isNonVolatileStorage {0}
set_interface_assignment avl embeddedsw.configuration.isPrintableDevice {0}


proc elaborate {} {
    set_module_assignment embeddedsw.CMacro.FB_OFFSET [get_parameter_value pFB_OFFSET]u
    set_module_assignment embeddedsw.CMacro.CAM_OFFSET_A [get_parameter_value pCAM_OFFSET_A]u
    set_module_assignment embeddedsw.CMacro.CAM_OFFSET_B [get_parameter_value pCAM_OFFSET_B]u

}
