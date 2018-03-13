local component=require("component")
local dd=component.disk_drive
local shell=require("shell")
local io=require("io")
args=shell.parse(...)

if args[1]==nil then
error("УКАЖИТЕ АРГУМЕНТЫ!1-ид дискеты,2-кому,3-от кого,4-файл")
end

path="/mnt/"..args[1].."/"

file=io.open(path.."to","w")
file:write(args[2])
file:close()

file=io.open(path.."from","w")
file:write(args[3])
file:close()

file=io.open(path.."","r")
text=file:read(99999)
file:close()

file=io.open(path.."msg","w")
file:write(text)
file:close()

file=io.open(path.."header","w")
file:write("TESNET)
file:close()
