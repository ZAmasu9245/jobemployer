print(" ")
print("+++++++++++++++++++++++++++++++++++")
print("+    Loading RolePlayJobSystem    +")
print("+    by @NicolasStr_              +")
print("+    +        +++++++        +    +")
print("+                                 +")

if not rpjs then rpjs = {} end

for k, v in pairs(file.Find("rpjs/sv_*.lua", "LUA")) do
	include("rpjs/".. v)
end
for k, v in pairs(file.Find("rpjs/sh_*.lua", "LUA")) do
	AddCSLuaFile("rpjs/".. v)
	include("rpjs/".. v)
end
for k, v in pairs(file.Find("rpjs/cl_*.lua", "LUA")) do
	AddCSLuaFile("rpjs/".. v)
end

print("+                                 +")

if rpjs.config.debug then
	print("+     DEBUG ENABLED               +")
else
	print("+     DEBUG DISABLED              +")
end

print( "+  VERSION: " .. rpjs.version )

print("+                                 +")
print("+++++++++++++++++++++++++++++++++++")
print(" ")