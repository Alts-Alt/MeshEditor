local Face = {}
Face.__index = Face

local Triangle = require(script.TriangleClass)

function Face.new(mesh)
	local self = setmetatable({}, Face)
	
	self.mesh = mesh
	self.triangles = nil
	
	self.vertices = {}
	self.edges = {}
	
	return self
end

function Face:AddVertice(vertice)
	if not vertice then return end
	table.insert(self.vertices, vertice)
end

function Face:AddVertices(vertices)
	if not vertices then return end
	for i,vertice in ipairs(vertices) do
		self:AddVertice(vertice)
	end
end

function Face:GetVertices()
	return self.vertices
end

function Face:AddEdge(edge)
	if not edge then return end
	table.insert(self.edges, edge)
end

function Face:AddEdges(edges)
	if not edges then return end
	for i,edge in ipairs(edges) do
		self:AddEdge(edge)
	end
end

function Face:GetEdges()
	return self.edges
end

function Face:CreateTriangles()
	if #self.vertices < 3 then return end
	self.triangles = self.triangles or {}
	for i = 3,#self.vertices do
		local vertA,vertB,vertC = self.vertices[1], self.vertices[i-1], self.vertices[i]
		local triangle = Triangle.new()
		triangle:AddVertices({vertA, vertB, vertC})
		table.insert(self.triangles, triangle)
	end
end

function Face:Render(parent)
	if not self.triangles then 
		self:CreateTriangles() 
	end
	
	if parent then
		if not parent:FindFirstChild('Faces') then
			local _folder = Instance.new('Folder')
			_folder.Name = 'Faces'
			_folder.Parent = parent
		end
	end
	
	for i,triangle in ipairs(self.triangles) do
		triangle:Render(parent and parent['Faces'])
	end
end

return Face