--!native

-- 📡internet konekting 📡📡📡
-- 📡internet konekting 📡📡📡
-- 📡internet konekting 📡📡📡
-- ✅konekted:flag_ku::flag_ku: 
-- 💯2000 ping from iraki servir

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local ServerStorage = game:GetService("ServerStorage")

local rootPos: Vector3 = ServerStorage.Root.Value

local rand = Random.new(os.time())

local randomParts: {Instance} = ReplicatedStorage.Assets:WaitForChild("RandomPartSpawn"):GetChildren()

local Timer = require(ReplicatedStorage.Packages.Timer)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Net = require(ReplicatedStorage.Packages.Net)

local event = Net:RemoteEvent("Loaded")

event.OnServerEvent:Wait()

function positiveUnitVector(): Vector3
	return Vector3.new(rand:NextNumber(-1, 1), rand:NextNumber(0.1, 1), rand:NextNumber(-1, 1))
end

function nextColor3(): Color3
	return Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
end

function nextBoolean(): boolean
	return rand:NextNumber() > 0.5
end

local partSpawnTimer = Timer.Simple(3, function()
	local part: BasePart | Model = randomParts[math.random(1, #randomParts)]:Clone()

	local pos: Vector3 = rootPos + positiveUnitVector() * math.random(5, 200) * Vector3.new(1, rand:NextNumber(0.8, 3.5), 1)
	print(rootPos)
	print(pos)
	part.Parent = workspace.Mape.ModelDebris

	for _, v in pairs(part:GetDescendants()) do
		if v:IsA("Script") then
			v.Enabled = true
		end
	end

	if part:IsA("Model") then
		part:MoveTo(pos)
	elseif part:IsA("BasePart") then
		part.Position = pos
		if part:HasTag("RandomlyScale") then
			part.Size = positiveUnitVector():Abs() * math.random(0.8, 10) 
		end
	end

	Debris:AddItem(part, math.random(20, 60))
end, true, RunService.Heartbeat, function()
	return os.time() * math.random(-1, 3)
end)

local explosionTimer = Timer.Simple(5, function()
	local e = Instance.new("Explosion")
	e.BlastPressure = math.random(100000, 10000000)
	e.BlastRadius = math.random(5, 50)
	e.DestroyJointRadiusPercent = 0
	e.ExplosionType = Enum.ExplosionType.NoCraters
	e.TimeScale = rand:NextNumber()
	e.Position = rootPos + (positiveUnitVector() * math.random(50, 100))

	e.Hit:Connect(function(other: BasePart)
		local pHum = other.Parent:FindFirstChildWhichIsA("Humanoid", false)

		if pHum then
			pHum.Health = 0
		end
	end)

	e.Parent = workspace

	Debris:AddItem(e, 2)
end, true, RunService.Heartbeat, function()
	return os.time() + math.random(0.5, 2)
end)

local materialChangeTimer = Timer.Simple(60, function()
	for _, v: BasePart in pairs(workspace.Mape:GetDescendants()) do
		if v:IsA("BasePart") then
			if math.random(1, 8) == 5 then
				v.Color = nextColor3()
				v.Material = Enum.Material:GetEnumItems()[math.random(1, #Enum.Material:GetEnumItems())]
				v.Size = v.Size + rand:NextUnitVector():Abs() * math.random(0.8, 1.2)

				local r = rand:NextInteger(1,6)

				if r == 1 then
					local fire = Instance.new("Fire")
					fire.Parent = v
					fire.Size = math.random(1, 30)
					fire.Color = nextColor3()
					fire.Heat = math.random(2, 1000)
					fire.SecondaryColor = nextColor3()
					fire.TimeScale = rand:NextNumber() 
				elseif r == 2 then
					local sparkles = Instance.new("Sparkles")
					sparkles.Parent = v
					sparkles.SparkleColor = nextColor3()
					sparkles.TimeScale = rand:NextNumber()
				elseif r == 3 then
					local smoke = Instance.new("Smoke")
					smoke.Parent = v
					smoke.Color = nextColor3()
					smoke.Opacity = rand:NextNumber()
					smoke.TimeScale = rand:NextNumber()
					smoke.Size = rand:NextNumber(0.5, 30)
					smoke.RiseVelocity = math.random(1, 50)
				elseif r == 4 then
					local dialog = Instance.new("Dialog")

					-- Possible tones
					local tones = {Enum.DialogTone.Friendly, Enum.DialogTone.Neutral, Enum.DialogTone.Enemy}
					dialog.Tone = tones[math.random(1, #tones)]

					-- Random initial prompt (using placeholders for the example)
					dialog.InitialPrompt = "Random Initial Prompt"

					-- Possible purposes
					local purposes = {Enum.DialogPurpose.Quest, Enum.DialogPurpose.Shop, Enum.DialogPurpose.Help}
					dialog.Purpose = purposes[math.random(1, #purposes)]

					dialog.Parent = v

					-- Random goodbye dialog (using placeholders for the example)
					dialog.GoodbyeDialog = "                                                                                                                                                                                                        "

					-- Random response dialog (using placeholders for the example)
					dialog.ResponseDialog = "                                                                                                                                                                                                                "

					dialog.Name = "Dialog"
					dialog.ConversationDistance = math.random(1, 100)

					-- Possible behavior types
					local behaviorTypes = {Enum.DialogBehaviorType.SinglePlayer, Enum.DialogBehaviorType.MultiplePlayers}
					dialog.BehaviorType = behaviorTypes[math.random(1, #behaviorTypes)]
				elseif r == 5 then
					local pointlight = Instance.new("PointLight")
					pointlight.Parent = v
					pointlight.Color = nextColor3()
					pointlight.Brightness = math.random(1, 100) 
					pointlight.Range = rand:NextNumber(0.5, 60)
					pointlight.Shadows = math.random(1, 50)
				end
			end
		end
	end
end)