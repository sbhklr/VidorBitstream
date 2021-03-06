# TCL File Generated by Component Editor 17.1
# Wed Apr 18 17:45:34 CEST 2018
# DO NOT MODIFY


# 
# FBST "Streaming Frame Buffer" v1.0
#  2018.04.18.17:45:34
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module FBST
# 
set_module_property DESCRIPTION ""
set_module_property NAME FBST
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP ipTronix
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "Streaming Frame Buffer"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL FBST
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file FBST.v VERILOG PATH FBST.v TOP_LEVEL_FILE


# 
# parameters
# 
add_parameter pHRES INTEGER 1280
set_parameter_property pHRES DEFAULT_VALUE 1280
set_parameter_property pHRES DISPLAY_NAME pHRES
set_parameter_property pHRES TYPE INTEGER
set_parameter_property pHRES UNITS None
set_parameter_property pHRES ALLOWED_RANGES -2147483648:2147483647
set_parameter_property pHRES HDL_PARAMETER true
add_parameter pVRES INTEGER 720
set_parameter_property pVRES DEFAULT_VALUE 720
set_parameter_property pVRES DISPLAY_NAME pVRES
set_parameter_property pVRES TYPE INTEGER
set_parameter_property pVRES UNITS None
set_parameter_property pVRES ALLOWED_RANGES -2147483648:2147483647
set_parameter_property pVRES HDL_PARAMETER true
add_parameter pHTOTAL INTEGER 1354
set_parameter_property pHTOTAL DEFAULT_VALUE 1354
set_parameter_property pHTOTAL DISPLAY_NAME pHTOTAL
set_parameter_property pHTOTAL TYPE INTEGER
set_parameter_property pHTOTAL UNITS None
set_parameter_property pHTOTAL ALLOWED_RANGES -2147483648:2147483647
set_parameter_property pHTOTAL HDL_PARAMETER true
add_parameter pVTOTAL INTEGER 910
set_parameter_property pVTOTAL DEFAULT_VALUE 910
set_parameter_property pVTOTAL DISPLAY_NAME pVTOTAL
set_parameter_property pVTOTAL TYPE INTEGER
set_parameter_property pVTOTAL UNITS None
set_parameter_property pVTOTAL ALLOWED_RANGES -2147483648:2147483647
set_parameter_property pVTOTAL HDL_PARAMETER true
add_parameter pHSS INTEGER 1300
set_parameter_property pHSS DEFAULT_VALUE 1300
set_parameter_property pHSS DISPLAY_NAME pHSS
set_parameter_property pHSS TYPE INTEGER
set_parameter_property pHSS UNITS None
set_parameter_property pHSS ALLOWED_RANGES -2147483648:2147483647
set_parameter_property pHSS HDL_PARAMETER true
add_parameter pHSE INTEGER 1340
set_parameter_property pHSE DEFAULT_VALUE 1340
set_parameter_property pHSE DISPLAY_NAME pHSE
set_parameter_property pHSE TYPE INTEGER
set_parameter_property pHSE UNITS None
set_parameter_property pHSE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property pHSE HDL_PARAMETER true
add_parameter pVSS INTEGER 778
set_parameter_property pVSS DEFAULT_VALUE 778
set_parameter_property pVSS DISPLAY_NAME pVSS
set_parameter_property pVSS TYPE INTEGER
set_parameter_property pVSS UNITS None
set_parameter_property pVSS ALLOWED_RANGES -2147483648:2147483647
set_parameter_property pVSS HDL_PARAMETER true
add_parameter pVSE INTEGER 782
set_parameter_property pVSE DEFAULT_VALUE 782
set_parameter_property pVSE DISPLAY_NAME pVSE
set_parameter_property pVSE TYPE INTEGER
set_parameter_property pVSE UNITS None
set_parameter_property pVSE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property pVSE HDL_PARAMETER true


# 
# display items
# 


# 
# connection point vport
# 
add_interface vport conduit end
set_interface_property vport associatedClock vid_clk
set_interface_property vport associatedReset ""
set_interface_property vport ENABLED true
set_interface_property vport EXPORT_OF ""
set_interface_property vport PORT_NAME_MAP ""
set_interface_property vport CMSIS_SVD_VARIABLES ""
set_interface_property vport SVD_ADDRESS_GROUP ""

add_interface_port vport oBLU blu Output 8
add_interface_port vport oDE de Output 1
add_interface_port vport oGRN grn Output 8
add_interface_port vport oHS hs Output 1
add_interface_port vport oVS vs Output 1
add_interface_port vport oRED red Output 8


# 
# connection point vid_clk
# 
add_interface vid_clk clock end
set_interface_property vid_clk clockRate 0
set_interface_property vid_clk ENABLED true
set_interface_property vid_clk EXPORT_OF ""
set_interface_property vid_clk PORT_NAME_MAP ""
set_interface_property vid_clk CMSIS_SVD_VARIABLES ""
set_interface_property vid_clk SVD_ADDRESS_GROUP ""

add_interface_port vid_clk iCLK clk Input 1


# 
# connection point stream
# 
add_interface stream conduit end
set_interface_property stream associatedClock ""
set_interface_property stream associatedReset ""
set_interface_property stream ENABLED true
set_interface_property stream EXPORT_OF ""
set_interface_property stream PORT_NAME_MAP ""
set_interface_property stream CMSIS_SVD_VARIABLES ""
set_interface_property stream SVD_ADDRESS_GROUP ""

add_interface_port stream iFB_START start Input 1
add_interface_port stream iFB_DATA data Input 31
add_interface_port stream iFB_DATAVALID dv Input 1
add_interface_port stream oFB_READY ready Output 1

set_module_property ELABORATION_CALLBACK elaborate
proc elaborate {} {
    set_module_assignment embeddedsw.CMacro.HRES [get_parameter_value pHRES]u
    set_module_assignment embeddedsw.CMacro.VRES [get_parameter_value pVRES]u

}