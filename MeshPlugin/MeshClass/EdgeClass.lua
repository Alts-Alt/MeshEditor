local Edge = {}
Edge.__index = Edge

local plugin_Settings = require(script.Parent.Parent.Settings)

function Edge.new(mesh)
	local self = setmetatable({}, Edge)
	
	self.mesh = mesh
	self.line = nil
	
	self.vertices = {}
	self.faces = {}
	
	return self	
end

function Edge:CreateLine()
	self.line = Instance.new('CylinderHandleAdornment')
	self.line.Radius = .005
	self.line.Color3 = plugin_Settings['EDGE_COLOR']--Color3.fromRGB(200,160,90)
	self.line.Transparency = 0
	self.line.Adornee = game.Workspace.Terrain
	self.line.Visible = false
	--self.line.Parent = _edgeGui
end

function Edge:Render(parent)
	if not self.line then
		self:CreateLine()
	end
	local vert1,vert2 = self.vertices[1],self.vertices[2]
	if vert1 and vert2 then
		local pos1,pos2 = vert1:GetPosition(),vert2:GetPosition()
		self.line.CFrame = CFrame.new((pos1+pos2)*.5,pos2)
		self.line.Height = (pos1-pos2).Magnitude
		self.line.Visible = true
		
		if parent then
			if not parent:FindFirstChild('Edges') then
				local _folder = Instance.new('Folder')
				_folder.Name = 'Edges'
				_folder.Parent = parent
			end
			self.line.Parent = parent['Edges']
		end
	end
end

function Edge:FindEdgeBetweenVertices(vertice1,vertice2)
	if not vertice1 or not vertice2 then return end
	local edges = vertice1:GetEdges()
	for i,edge in ipairs(vertice2:GetEdges()) do
		if table.find(edges,edge) then
			return edge
		end
	end
end

function Edge:AddVertice(vertice)
	if not vertice then return end
	table.insert(self.vertices, vertice)
end

function Edge:AddVertices(vertices)
	if not vertices then return end
	for i,vertice in ipairs(vertices) do
		self:AddVertice(vertice)
	end
end

function Edge:GetVertices()
	return self.vertiecs
end

function Edge:AddFace(face)
	if not face then return end
	table.insert(self.faces, face)
end

function Edge:AddFaces(faces)
	if not faces then return end
	for i,face in ipairs(faces) do
		self:AddFace(face)
	end
end

function Edge:GetFaces()
	return self.faces
end

return Edge