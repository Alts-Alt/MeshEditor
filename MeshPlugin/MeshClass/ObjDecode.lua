local ObjDecode = {}

function ObjDecode:GetSource(sourceObj)
	if type(sourceObj) == 'string' then
		return sourceObj
	elseif sourceObj:IsA('ModuleScript') then
		return sourceObj.Source
	elseif sourceObj:IsA('ValueBase') then
		return sourceObj.Value
	end
end

function ObjDecode:DecodeLine(line)
	local split = string.split(line, ' ')
	local _type = split[1]
	table.remove(split,1)
	local _data = split
	
	if _type == 'f' then
		_data = {}
		for i,value in ipairs(split) do
			if value ~= '' and value ~= '\n' then
				table.insert(_data, string.split(value,'/'))
			end
		end
	end
	
	return _type, _data
end

function ObjDecode:Decode(sourceObj)
	local data = {}
	
	local source = ObjDecode:GetSource(sourceObj)
	assert(source, 'Failed To Load Source!',sourceObj)
	
	local lines = string.split(source,'\n')
	for i,line in ipairs(lines) do
		if type(line) == 'string' then
			local lineType, lineValues = ObjDecode:DecodeLine(line)
			
			
			data[lineType] = data[lineType] or {}
			
			
			table.insert(data[lineType],{
				string = line,
				line = i,
				values = lineValues or {}
			})
		end
	end
	print('Lines:',#lines)
	
--	for _type,values in pairs(data) do
--		print('Type:',_type)
--		if _type == 'v' or _type == 'f' then
--			for i,v in ipairs(values) do
--				print(i,v.line,v.string,unpack(v.values))
--			end
--		end
--	end
	
	
	return data
end

return ObjDecode
