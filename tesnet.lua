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

if args[1]==nil then error("������� ������������� �������!") end
if args[2]==nil then error("������� ��� ��������� � ���� TESNET!") end

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
if header=="TESNET" then --��������� ��������� TESNET
file=io.open(path.."to","r")
to=file:read(99)
file:close()
if to==myname then --��������� ���������� ���������
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
	
	else --���� ��������� �� ��� ���

	dd.eject()
	
	end --��������� ���������� ���������
end --��������� ��������� TESNET
if header=="TESNETRETURN" then --��������� ������������ �������
computer.pushSignal("tesnet_return",from)
end --��������� ������������ �������
b=false
end

info("�������� ������� ���������:")
info(tostring(e.listen("component_added",kostil)))