local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Timer = require(ReplicatedStorage.Packages.Timer)

local GlitchedPart = Component.new({Tag = "GlitchedPart", Ancestors = {workspace}})

GlitchedPart.Started:Connect(function(component)
    local instance: BasePart = component.Instance

    local forceTimer = Timer.Simple(0.05, function()
        instance.Position = instance.Position + Vector3.new(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1)) -- Randomize position
		instance.Rotation = instance.Rotation + Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)) -- Randomize rotation
		instance.Size = instance.Size + Vector3.new(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1)) -- Randomize size
    end)
    
    component["timer"] = forceTimer
end)

GlitchedPart.Stopped:Connect(function(component)
    component["timer"]:Disconnect()
end)
