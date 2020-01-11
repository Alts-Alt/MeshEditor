local Mesh = {}
Mesh.__index = Mesh

local Face = require(script.FaceClass)
local Edge = require(script.EdgeClass)
local Vertice = require(script.VerticeClass)

local ObjDecoder = require(script.ObjDecode)

function Mesh.new()
	local self = setmetatable({}, Mesh)
	
	self.folder = Instance.new('Folder')
	self.folder.Name = 'Mesh'
	self.folder.Parent = game.Workspace
	
	self.vertices = {}
	self.faces = {}
	self.edges = {}
	
	self.scale = 1
	self.origin = CFrame.new()
	
	return self
end

function Mesh:CreateVertice(position)
	if not position then warn('Failed To Create Vertice, No Position Given!') return end
	--assert(position, 'Failed To Create Vertice, No Position Given!')
	local vertice = Vertice.new(self)
	vertice:SetPosition(position)
	table.insert(self.vertices, vertice)
	return vertice
end

function Mesh:CreateEdge(vertice1,vertice2)
	if not vertice1 or not vertice2 then warn('Failed To Create Edge, Vertice(s) Missing!') return end
	--assert(vertice1 and vertice2, 'Failed To Create Edge, Vertice(s) Missing!')
	local edge = Edge:FindEdgeBetweenVertices(vertice1,vertice2)
	if not edge then
		edge = Edge.new(self)
		edge:AddVertices({vertice1,vertice2})
		vertice1:AddEdge(edge)
		vertice2:AddEdge(edge)
		table.insert(self.edges, edge)
	end
	return edge
end

function Mesh:CreateFace(vertices)
	if not vertices or #vertices < 3 then warn('Failed To Create Face, Not Enough Vertices Given! (n<3)') return end
	--assert(vertices and #vertices>2, 'Failed To Create Face, Not Enough Vertices Given! (n<3)')
	
	local face = Face.new(self)
	face:AddVertices(vertices)
	
	for _,vertice in ipairs(vertices) do
		vertice:AddFace(face)
	end
	table.insert(self.faces, face)
	return face
end

function Mesh:CreateFaceEdge(vertices)
	if not vertices or #vertices<2 then warn('Failed to Create Edge And Face, Vertice(s) Missing!') return end
	--assert(vertices and #vertices>1, 'Failed To Create Edge And Face, Vertice(s) Missing!')
	
	local face = self:CreateFace(vertices)
	local edges = {}
	for i,vertice in ipairs(vertices) do
		local v = i<#vertices and i+1 or 1
		table.insert(edges, self:CreateEdge(vertice, vertices[v]))
	end
	if face then
		for i,edge in ipairs(edges) do
			edge:AddFace(face)
			face:AddEdge(edge)
		end
	end
	
	return face, edges
end

function Mesh:LoadFromSource(sourceObj)
	local data = ObjDecoder:Decode(sourceObj)
	local vertCount = #self.vertices
	
	for i,line in ipairs(data['v']) do
		local vertice = self:CreateVertice(Vector3.new(
			tonumber(line.values[1]),
			tonumber(line.values[2]),
			tonumber(line.values[3])
		))
	end
	
	for i,line in ipairs(data['f']) do
		local vertices = {}
		for _,d in ipairs(line.values) do
			table.insert(vertices, 
				self.vertices[vertCount+tonumber(d[1])]
			)
		end
		
		local face, edges = self:CreateFaceEdge(vertices)
		--face:CreateTriangles()
	end
end

function Mesh:Render()
	print('Render')
	for i,vertice in ipairs(self.vertices) do
		vertice:Render(self.folder)
	end
	for i, face in ipairs(self.faces) do
		face:Render(self.folder)
	end
	for i, edge in ipairs(self.edges) do
		edge:Render(self.folder)
	end
end


return Mesh
