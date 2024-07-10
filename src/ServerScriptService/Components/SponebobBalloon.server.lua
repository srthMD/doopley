local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Component = require(ReplicatedStorage.Packages.Component)
local Timer = require(ReplicatedStorage.Packages.Timer)

local rand = Random.new(os.time())

local SponebobBalloon = Component.new({Tag = "SponebobBalloon", Ancestors = {workspace}})

function UpdateForce(bf: BodyForce, mass: number, dir: Vector3)
	bf.Force = Vector3.new(0.1 * dir.X, mass * workspace.Gravity - 5, 0.1 * dir.Z)
end

SponebobBalloon.Started:Connect(function(component)
    local instance: MeshPart = component.Instance
    local bf = instance:FindFirstChildWhichIsA("BodyForce")

    local forceTimer = Timer.Simple(5, function()
        UpdateForce(bf, instance:GetMass(), rand:NextUnitVector() * math.random(0.8, 1.5))
    end)
    
    component["timer"] = forceTimer
end)

SponebobBalloon.Stopped:Connect(function(component)
    component["timer"]:Disconnect()
end)
