print(" ")
print("+++++++++++++++++++++++++++++++++++")
print("+    Loading RolePlayJobSystem    +")
print("+    by @NicolasStr_              +")
print("+    +        +++++++        +    +")
print("+                                 +")

if not rpjs then rpjs = {} end

for k, v in pairs(file.Find("rpjs/cl_*.lua", "LUA")) do
	include("rpjs/".. v)
end
for k, v in pairs(file.Find("rpjs/sh_*.lua", "LUA")) do
	include("rpjs/".. v)
end

print( "+  VERSION: " .. rpjs.version )

print("+                                 +")
print("+++++++++++++++++++++++++++++++++++")
print(" ")