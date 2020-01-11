--[[local decode = require(script.Parent.MeshClass.ObjDecode)
decode:Decode(script.Parent.MeshFiles.Plane)]]

local Mesh = require(script.Parent.MeshClass)

local mesh = Mesh.new()
mesh.scale = 1--Vector3.new(5,10,5)--5
mesh.origin = CFrame.new(0,5,0)-- * CFrame.Angles(0,0,math.rad(90))
--mesh:LoadFromSource(script.Parent.MeshFiles.Monkey)
mesh:LoadFromSource(script.Parent.MeshFiles.PlaneModule)
mesh:Render()

--[[
local _vertices = mesh.vertices


for i = 0,20 do
	wait(1)
	local _vert = mesh.vertices[math.random(1,#_vertices)]
	_vert:Move(_vert.position + Vector3.new(0,math.random(-10,10)/10,0))
end

]]


for l = 1,10 do
	wait(.5)
for i,vertice in pairs(mesh.vertices) do
	vertice:Move(vertice.position + Vector3.new(0,1,0))
end

end

--[[repeat
	mesh.scale = math.clamp(mesh.scale + math.random(-10,10)/10,1,5)
	mesh.origin = mesh.origin * CFrame.new(math.random(),math.random(),math.random())
	mesh:Render()
	wait(1)
until 1==0]]
