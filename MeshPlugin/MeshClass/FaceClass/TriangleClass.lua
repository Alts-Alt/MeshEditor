local Triangle = {}
Triangle.__index = Triangle

local plugin_Settings = require(script.Parent.Parent.Parent.Settings)

local Wedge = Instance.new('WedgePart')
Wedge.Color = plugin_Settings['FACE_COLOR']--Color3.fromRGB(160,160,160)
Wedge.Material = Enum.Material.SmoothPlastic
Wedge.Reflectance = 0
Wedge.Transparency = 0
Wedge.Name = 'Wedge'
Wedge.Anchored = true
Wedge.CanCollide = true
Wedge.BottomSurface = Enum.SurfaceType.Smooth
Wedge.TopSurface = Enum.SurfaceType.Smooth
local Mesh = Instance.new('SpecialMesh')
Mesh.MeshType = Enum.MeshType.Wedge
Mesh.Scale = Vector3.new(0,1,1)
Mesh.Parent = Wedge

function Triangle.new()
	local self = setmetatable({}, Triangle)
	
	self.vertices = {}
	
	self.wedge1 = Wedge:Clone()
	self.wedge2 = Wedge:Clone()
	
	return self
end

function Triangle:AddVertice(vertice)
	if not vertice then return end
	table.insert(self.vertices,vertice)
end

function Triangle:AddVertices(vertices)
	if not vertices then return end
	for i,vertice in ipairs(vertices) do
		self:AddVertice(vertice)
	end
end

function Triangle:GetVertices()
	return self.vertices
end

function Triangle:Render(parent)
	if #self.vertices < 3 then return end
	local vertA,vertB,vertC = self.vertices[1],self.vertices[2],self.vertices[3]
	
	
	local posA,posB,posC = vertA:GetPosition(),vertB:GetPosition(),vertC:GetPosition()
	
	local difAB,difAC,difBC = (posB - posA), (posC - posA), (posC - posB)
	local lenAB,lenAC,lenBC = difAB.Magnitude, difAC.Magnitude, difBC.Magnitude
	
	if lenAB > lenAC and lenAB > lenBC then
		posA, posC = posC, posA
	elseif lenAC > lenBC and lenAC > lenAB then
		posA, posB = posB, posA
	end
	difAB,difAC,difBC = (posB - posA), (posC - posA), (posC - posB)
	
	local out = difAC:Cross(difAB).Unit
	local biDir = difBC:Cross(out).Unit
	local biLen = math.abs(difAB:Dot(biDir))
	local norm = difBC.Magnitude
	
	self.wedge1.Size = Vector3.new(0, math.abs(difAB:Dot(difBC))/norm, biLen)
	self.wedge2.Size = Vector3.new(0, biLen, math.abs(difAC:Dot(difBC))/norm)
	difBC = -difBC.Unit
	
	local fromAxes = function(p, x, y, z) 
		return CFrame.new(
			p.X,p.Y,p.Z,
			x.X,y.X,z.X,
			x.Y,y.Y,z.Y,
			x.Z,y.Z,z.Z
		)
	end
	
	self.wedge1.CFrame = fromAxes((posA+posB)*.5, -out, difBC, -biDir)
	self.wedge2.CFrame = fromAxes((posA+posC)*.5, -out, biDir, difBC)
	
	if parent then
		self.wedge1.Parent = parent
		self.wedge2.Parent = parent
	end
end

return Triangle
