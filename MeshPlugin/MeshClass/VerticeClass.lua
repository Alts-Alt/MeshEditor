local Vertice = {}
Vertice.__index = Vertice

local plugin_Settings = require(script.Parent.Parent.Settings)

function Vertice.new(mesh)
	local self = setmetatable({}, Vertice)
	
	self.mesh = mesh
	self.position = Vector3.new()
	self.node = nil
	
	self.edges = {}
	self.faces = {}
	
	return self	
end

function Vertice:CreateNode()
	self.node = Instance.new('SphereHandleAdornment')
	self.node.Radius = .02
	self.node.Color3 = plugin_Settings['VERTICE_COLOR']--Color3.fromRGB(190,116,35)
	self.node.Transparency = 0
	self.node.Adornee = game.Workspace.Terrain
	self.node.Visible = false
	--self.node.Parent = _verticeGui
end

function Vertice:Render(parent)
	if not self.node then
		self:CreateNode()
	end
	
	self.node.CFrame = CFrame.new(self:GetPosition())
	self.node.Visible = true
	
	if parent then
		if not parent:FindFirstChild('Vertices') then
			local _folder = Instance.new('Folder')
			_folder.Name = 'Vertices'
			_folder.Parent = parent
		end
		self.node.Parent = parent['Vertices']
	end
end

function Vertice:Move(position)
	if not position then return end
	self:SetPosition(position)
	self:Render()
	for i,edge in ipairs(self.edges) do
		edge:Render()
	end
	for i, face in ipairs(self.faces) do
		face:Render()
	end
end

function Vertice:SetPosition(position)
	self.position = position
end

function Vertice:GetPosition()
	return (self.mesh.origin * CFrame.new(self.position*self.mesh.scale)).p
end

function Vertice:AddFace(face)
	if not face then return end
	table.insert(self.faces, face)
end

function Vertice:AddFaces(faces)
	if not faces then return end
	for i,face in ipairs(faces) do
		self:AddFace(face)
	end
end

function Vertice:GetFaces()
	return self.faces
end

function Vertice:AddEdge(edge)
	if not edge then return end
	table.insert(self.edges, edge)
end

function Vertice:AddEdges(edges)
	if not edges then return end
	for i,edge in ipairs(edges) do
		self:AddEdge(edge)
	end
end

function Vertice:GetEdges()
	return self.edges
end

return Vertice
