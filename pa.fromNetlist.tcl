
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name CPU -dir "E:/Thinpand/CPU/project/CPU/CPU/planAhead_run_3" -part xc3s1200efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "E:/Thinpand/CPU/project/CPU/CPU/CPU.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {E:/Thinpand/CPU/project/CPU/CPU} }
set_param project.pinAheadLayout  yes
set_param project.paUcfFile  "CPU.ucf"
add_files "CPU.ucf" -fileset [get_property constrset [current_run]]
open_netlist_design
