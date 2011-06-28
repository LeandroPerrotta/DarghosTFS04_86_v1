luaGlobal = {}

function luaGlobal.getVar(name)
	local result = db.getResult("SELECT `value` FROM `lua_global` WHERE `var` = '" .. name .. "';")
	local value = nil
	
	if(result:getID() ~= -1) then
		value = result:getDataString("value")
	end
	result:free()
	
	local json = require("json")
	value = json.decode(value)	
	
	return value
end

function luaGlobal.setVar(var, value)

	local result = db.getResult("SELECT `value` FROM `lua_global` WHERE `var` = '" .. name .. "';")

	local json = require("json")
	value = json.encode(value)		
	
	if(result:getID() ~= -1) then
		db.executeQuery("UPDATE `lua_global` SET `value` = '" .. value .. "' WHERE `var` = " .. var .. ";")
	else
		db.executeQuery("INSERT INTO `lua_global` VALUES ('" .. var .. "', '" .. value .. "');")
	end
end