e=require("event")
c=require("component")
gpu=c.gpu
shell=require("shell")
io=require("io")
computer=require("computer")
dd=c.disk_drive
args=shell.parse(...)
local os=require("os")

b=false

i=1

if args[1]==nil then error("Укажите идентификатор дискеты!") end
if args[2]==nil then error("Укажите имя компютера в сети TESNET!") end

path="/mnt/"..args[1].."/"
myname=args[2]

function kostil()
e.listen("signalo",read)
if b==false then
computer.pushSignal("signalo")
b=true
end
end


function info(text)
gpu.set(30,i,text)
i=i+1
end

function read()
file=io.open(path.."header","r")
header=file:read(20)
file:close()
if header=="TESNET" then --Обработка сообщения TESNET
file=io.open(path.."to","r")
to=file:read(99)
file:close()
if to==myname then --Обработка пришедшего сообщения
file=io.open(path.."from","r")
from=file:read(999)
file:close()
file=io.open(path.."msg","r")
msg=file:read(9999)
file:close()
computer.pushSignal("tesnet_message",from,msg)
file=io.open(path.."to","w")
file:write(from)
 file:close()
	file=io.open(path.."from","w")
	file:write(myname)
file:close()
file=io.open(path.."header","w")
file:write("TESNETRETURN")
file:close()
	dd.eject()
	
	else --Если сообщение не для нас

	dd.eject()
	
	end --Обработка пришедшего сообщения
end --Обработка сообщения TESNET
if header=="TESNETRETURN" then --Обработка возвращённой дискеты
computer.pushSignal("tesnet_return",from)
end --Обработка возвращённой дискеты
b=false
end

info("Начинаем слушать сообщения:")
info(tostring(e.listen("component_added",kostil)))