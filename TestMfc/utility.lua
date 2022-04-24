
--序列化
--[[
function serialize_table(obj, lvl)
  local lua = {}
  local t = type(obj)
  if t == "number" then
    table.insert(lua, obj)
  elseif t == "boolean" then
    table.insert(lua, tostring(obj))
  elseif t == "string" then
    table.insert(lua, string.format("%q", obj))
  elseif t == "table" then
    lvl = lvl or 0
    local lvls = ('  '):rep(lvl)
    local lvls2 = ('  '):rep(lvl + 1)
    table.insert(lua, "{\r\n")
    for k, v in pairs(obj) do
      table.insert(lua, lvls2)
      table.insert(lua, "[")
      table.insert(lua, serialize_table(k,lvl+1))
      table.insert(lua, "]=")
      table.insert(lua, serialize_table(v,lvl+1))
      table.insert(lua, ",\r\n")
    end
    local metatable = getmetatable(obj)
    if metatable ~= nil and type(metatable.__index) == "table" then
      for k, v in pairs(metatable.__index) do
        table.insert(lua, "[")
        table.insert(lua, serialize_table(k, lvl + 1))
        table.insert(lua, "]=")
        table.insert(lua, serialize_table(v, lvl + 1))
        table.insert(lua, ",\r\n")
      end
    end
    table.insert(lua, lvls)
    table.insert(lua, "}")
  elseif t == "nil" then
    return nil
  else
    print("can not serialize a " .. t .. " type.")
  end
  return table.concat(lua, "")
end
--]]

function prettystring(obj)
    local tinsert = table.insert
    local uniqueTable = {}
    local function prettyOneString(data,tab,path)
        tab = tab or 0
        path = path or "@/"
        local retTable  = {}    --存储最后的结果

        if type(data) ~= 'table'  then   --处理非table
            tinsert(retTable ,tostring(data))
            if tab ~= 0 then
                tinsert(retTable,",")
            end
        else    --处理table
            if uniqueTable[tostring(data)] == nil then
                tinsert(retTable,"{\r\n")
            end
            if next(data) ~= nil and uniqueTable[tostring(data)] == nil then
                uniqueTable[tostring(data)] = path
                for key, value in pairs(data) do
                    tinsert(retTable,string.rep("  ",tab))
                    if type(key)  == 'string' then
                        local tmpString = string.format('["%s"] = ',tostring(key))    --string.format可读性会比较好点，性能略微损失
                        tinsert(retTable,tmpString)
                    else
                        local tmpString = string.format("[%s] = ",tostring(key))
                        tinsert(retTable,tmpString)
                    end
                    tinsert(retTable,prettyOneString(value,tab+1,path..tostring(key)..'/' ))
                    tinsert(retTable,"\r\n")
                end
                local tmpString = string.format("%s},",string.rep("  ",tab))
                tinsert(retTable,tmpString)
            else
				if uniqueTable[tostring(data)] ~= nil then 
					local tmpString = string.format("%s",uniqueTable[tostring(data)])
					tinsert(retTable,tmpString)
				else 
					local tmpString = string.format("%s},",string.rep("  ",tab))
					tinsert(retTable,tmpString)
				end
            end
        end
        return table.concat(retTable)
    end
    
	return prettyOneString(obj)
end

function ToStringEx(value)
    if type(value)=='table' then
        return TableToStr(value)
    elseif type(value)=='string' then
        return "\'"..value.."\'"
    else
        return tostring(value)
    end
end

function TableToStr(t)
    if t == nil then return "" end
    local retstr= "{"

    local i = 1
    for key,value in pairs(t) do
        local signal = ","
        if i==1 then
            signal = ""
        end

        if key == i then
            retstr = retstr..signal..ToStringEx(value)
        else
            if type(key)=='number' or type(key) == 'string' then
                retstr = retstr..signal..'['..ToStringEx(key).."]="..ToStringEx(value)
            else
                if type(key)=='userdata' then
                    retstr = retstr..signal.."*s"..TableToStr(getmetatable(key)).."*e".."="..ToStringEx(value)
                else
                    retstr = retstr..signal..key.."="..ToStringEx(value)
                end
            end
        end

        i = i+1
    end

    retstr = retstr.."}"
    return retstr
end


--反序列化
function unserialize_table(lua)
  local t = type(lua)
  if t == "nil" or lua == "" then
    return nil
  elseif t == "number" or t == "string" or t == "boolean" then
    lua = tostring(lua)
  else
    print("can not unserialize a " .. t .. " type.")
  end
  lua = "return " .. lua
  local func = load(lua)
  if func == nil then
    return nil
  end
  return func()
end

function pretty_table(str, n)
	local tb = unserialize_table(str)
	local ret = prettystring(tb)
	return ret
end

function line_table(str)
	local tb = unserialize_table(str)
	local str = TableToStr(tb)
	return str
end