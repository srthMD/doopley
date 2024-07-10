local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Timer = require(ReplicatedStorage.Packages.Timer)

local rand = Random.new(os.time())

local SponebobBalloon = Component.new({Tag = "SponebobBalloon", Ancestors = {workspace}})

SponebobBalloon.Started:Connect(function(component)
    local instance: MeshPart = component.Instance

    local forceTimer = Timer.Simple(5, function()
        instance:ApplyImpulse(rand:NextUnitVector() * (math.random(500, 5000) * instance.Mass))
    end)
    
    component["timer"] = forceTimer
end)

SponebobBalloon.Stopped:Connect(function(component)
    component["timer"]:Disconnect()
end)
