local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ev: RemoteEvent = ReplicatedStorage.Signals.Server.Silence

ev.OnServerEvent:Once(function(plr: Player)
	plr.Character.HumanoidRootPart.Position = plr.Character.HumanoidRootPart.Position - Vector3.new(400000, 0, 400000)
end)