
--输出日志--
function log(str)
    Util.Log(str);
end

--错误日志--
function logError(str) 
	Util.LogError(str);
end

--警告日志--
function logWarn(str) 
	Util.LogWarning(str);
end

--查找对象--
function find(str)
	return GameObject.Find(str);
end

function destroy(obj)
	GameObject.Destroy(obj);
end

function newObject(prefab)
	return GameObject.Instantiate(prefab);
end

--创建面板--
function createPanel(name)
	PanelManager:CreatePanel(name);
end

--查找子类物体
function child(obj,str)
	return obj.transform:Find(str).gameObject;
end

function subGet(childNode, typeName)		
	return child(childNode):GetComponent(typeName);
end

function findPanel(str) 
	local obj = find(str);
	if obj == nil then
		error(str.." is null");
		return nil;
	end
	return obj:GetComponent("BaseLua");
end

-- 判断一个 C# 对象是否为 null
function IsNil(obj)
	return obj == nil or (type(obj) == "userdata" and obj:Equals(nil));
end

function table.nums(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end

local function dump_value_(v)
    if type(v) == "string" then
        v = "\"" .. v .. "\""
    end
    return tostring(v)
end

function dump(value, desciption, nesting)

    if type(nesting) ~= "number" then
        nesting = 3
    end

    local lookupTable = { }
    local result = { }

    local traceback = string.split(debug.traceback("", 2), "\n")
    local ret = ("dump from: " .. string.trim(traceback[3]))

    local function dump_(value, desciption, indent, nest, keylen)
        desciption = desciption or "<var>"
        local spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(dump_value_(desciption)))
        end
        if type(value) ~= "table" then
            result[#result + 1] = string.format("%s%s%s = %s", indent, dump_value_(desciption), spc, dump_value_(value))
        elseif lookupTable[tostring(value)] then
            result[#result + 1] = string.format("%s%s%s = *REF*", indent, dump_value_(desciption), spc)
        else
            lookupTable[tostring(value)] = true
            if nest > nesting then
                result[#result + 1] = string.format("%s%s = *MAX NESTING*", indent, dump_value_(desciption))
            else
                result[#result + 1] = string.format("%s%s = {", indent, dump_value_(desciption))
                local indent2 = indent .. "    "
                local keys = { }
                local keylen = 0
                local values = { }
                for k, v in pairs(value) do
                    keys[#keys + 1] = k
                    local vk = dump_value_(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then
                        keylen = vkl
                    end
                    values[k] = v
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for i, k in ipairs(keys) do
                    dump_(values[k], k, indent2, nest + 1, keylen)
                end
                result[#result + 1] = string.format("%s}", indent)
            end
        end
    end
    dump_(value, desciption, "- ", 1)

    for i, line in ipairs(result) do
        ret = ret .. "\n" .. line
    end
    print(ret)

end

function string.ltrim(input)
    return string.gsub(input, "^[ \t\n\r]+", "")
end

function string.rtrim(input)
    return string.gsub(input, "[ \t\n\r]+$", "")
end

function string.trim(input)
    input = string.gsub(input, "^[ \t\n\r]+", "")
    return string.gsub(input, "[ \t\n\r]+$", "")
end

function IsTable(obj)
    return type(obj)=="table" and true or false;
end

function IsUserdata(obj)
    return type(obj)=="userdata" and true or false;
end

function IsNumber(obj)
    return type(obj)=="number" and true or false;
end

function IsString(obj)
    return type(obj)=="string" and true or false;
end

function IsFunction(obj)
    return type(obj)=="function" and true or false;
end