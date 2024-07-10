local Players = game:GetService("Players")

function addAnimatior(char: Model)
	local animator = Instance.new("Animator")
	local hum = char:FindFirstChildWhichIsA("Humanoid")

	if not hum then return end
	animator.Parent = hum
end

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(addAnimatior)
end)
