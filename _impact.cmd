setMode -bs
setMode -bs
setMode -bs
addDevice -p 1 -file "E:/Thinpand/CPU/project/CPU/CPU/cpu.bit"
addDevice -p 2 -file "E:/Thinpand/CPU/project/exe/flashram.bit"
addDevice -p 2 -file "E:/Thinpand/CPU/controllerSynthesis/controller.bit"
setCable -port auto
Program -p 1 
Program -p 1 
cutDevice -p 2
cutDevice -p 2
Program -p 1 
setMode -bs
setMode -bs
deleteDevice -position 1
setMode -bs
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acecf
setMode -acempm
setMode -pff
ect.ipf"
setMode -bs
setMode -bs
deleteDevice -position 1
setMode -bs
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acecf
setMode -acempm
setMode -pff
