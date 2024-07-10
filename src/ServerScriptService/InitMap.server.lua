local map: Model = workspace.Mape
local clone: Model = map:Clone()
clone:PivotTo(CFrame.new(game.ServerStorage.Root.Value))
clone.Parent = workspace
map.Parent = game.ServerStorage
map.Name = "tempmap"

map:PivotTo(map:GetPivot() * CFrame.Angles(0, math.rad(180), 0))

for _, v: SpawnLocation in pairs(map["spawn locations"]:GetChildren()) do
    if v:IsA("SpawnLocation") then
        v.Enabled = false
    end
end

map.Parent = workspace

for _, v in pairs(game.Players:GetPlayers()) do
	v:LoadCharacter()
end

script:Destroy() 