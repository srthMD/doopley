--services
local ContentProvider = game:GetService("ContentProvider")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

local timers = {}

local M = 1

local soundEffects = require(ReplicatedStorage.Source.SoundEffectData)
local animations = ReplicatedStorage.Assets.Animations:GetChildren()

local silenceEvent: BindableEvent = ReplicatedStorage.Signals.Client.Silence

local Timer = require(ReplicatedStorage.Packages.Timer)
local Shake = require(ReplicatedStorage.Packages.Shake)
local Net = require(ReplicatedStorage.Packages.Net)

local loadedEvent = Net:RemoteEvent("Loaded")

local randomTxt = ReplicatedStorage.Assets.Random
local randomTexts = require(ReplicatedStorage.Source.RandomTexts)

local lPlr = Players.LocalPlayer
local camera = workspace.CurrentCamera

local text = ReplicatedStorage.Assets.Text:Clone()
text.Parent = lPlr.PlayerGui:WaitForChild("Images")

local priority = Enum.RenderPriority.Last.Value

local rand = Random.new(os.time())

local Shaker = Shake.new()
Shaker.Sustain = false

local ath: Atmosphere = Lighting.Atmosphere
local bloom: BloomEffect = Lighting.Bloom
local cc: ColorCorrectionEffect = Lighting.ColorCorrection
local blur: BlurEffect = Lighting.Blur
local sr: SunRaysEffect = Lighting.SunRays
local clouds: Clouds = workspace.Terrain.Clouds

local imageUi: ScreenGui = lPlr.PlayerGui:WaitForChild("Images")
local txtUi: ScreenGui = lPlr.PlayerGui:WaitForChild("Text")

local sounds: {Instance} = ReplicatedStorage.Assets.Sounds.EffectChange:GetChildren()
local images: {Instance} = ReplicatedStorage.Assets.ImageLabels:GetChildren()

bloom.Enabled = true
cc.Enabled = true
blur.Enabled = true
sr.Enabled = true

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Captures, false)

math.randomseed(os.time())

local animTimer = Timer.new(3)
local textTimer = Timer.new(5)
local soundGroupTimer = Timer.new(7)
local screenShakeTimer = Timer.new(1.8)
local imageTimer = Timer.new(7)
local soundTimer = Timer.new(5)
local dopplerTimer = Timer.new(0.5)
local fxTimer = Timer.new(1)

table.insert(timers, animTimer)
table.insert(timers, textTimer)
table.insert(timers, soundGroupTimer)
table.insert(timers, screenShakeTimer)
table.insert(timers, soundTimer)
table.insert(timers, imageTimer)
table.insert(timers, dopplerTimer)
table.insert(timers, fxTimer)

local insts = {
	ReplicatedStorage.Assets.ImageLabels:GetChildren(),
	ReplicatedStorage.Assets.Sounds:GetChildren()
}

local loaded = 0
for _, inst in pairs(insts) do
	ContentProvider:PreloadAsync(inst, function()
		text.Text = `loadi g all the Funnies😀 ({loaded} loaded)`
		loaded += 1
	end)
end

loadedEvent:FireServer()
text:Destroy()

function nextColor3(): Color3
	return Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
end

function filterTables(tbl: {Instance}, instanceName: string)
	for i, inst in pairs(tbl) do
		if inst:IsA(instanceName) then
			table.remove(tbl, i)
		end
	end
end

function nextBoolean(): boolean
	return rand:NextNumber() > 0.5
end

function nextColorSequence(passes: number?): ColorSequence
	if not passes then 
		passes = math.random(2, 5) 
	end

	local keypoints: {ColorSequenceKeypoint} = {}

	for i = 0, passes, 1 do
		table.insert(keypoints, ColorSequenceKeypoint.new(i/passes, nextColor3()))
	end

	return ColorSequence.new(keypoints)   
end

filterTables(sounds, "Sound")
filterTables(images, "ImageLabel")


--###############################
--         DOPPLER SCALE
--###############################

dopplerTimer.Tick:Connect(function()
	SoundService.DopplerScale = math.random(250, 2500)
	SoundService.DistanceFactor = math.random(1.1, 7.5)
	print(math.random())
end)

dopplerTimer.TimeFunction = function()
	return os.time() + rand:NextNumber()
end

--###############################
--            EFFECTS
--###############################
fxTimer.Tick:Connect(function()
	TweenService:Create(ath, 
		TweenInfo.new(math.random(0.1, 2), rand:NextNumber()*10, math.random(0, 2), math.random(1, 3), nextBoolean()), {
			Decay = nextColor3(),
			Color = nextColor3(),
			Glare = rand:NextNumber()*10,
			Haze = rand:NextNumber()*10
		}):Play()

	TweenService:Create(cc,  
		TweenInfo.new(math.random(0.1, 2), rand:NextNumber()*10, math.random(0, 2), math.random(1, 3), nextBoolean()), {
			Brightness = math.random(0.1, 0.85),
			Contrast = math.random(0.1, 0.85),
			Saturation = math.random(0, 100),
			TintColor = nextColor3()

		}):Play()

	TweenService:Create(bloom,  
		TweenInfo.new(math.random(0.1, 2), rand:NextNumber()*10, math.random(0, 2), math.random(1, 3), nextBoolean()), {
			Intensity = math.random(0, 20),
			Size = math.random(1, 56),
			Threshold = math.random(0.1, 5)
		}):Play()

	TweenService:Create(blur,  
		TweenInfo.new(math.random(0.1, 2), rand:NextNumber()*10, math.random(0, 2), math.random(1, 3), nextBoolean()), {
			Size = math.random(0, 8),
		}):Play()

	TweenService:Create(sr,  
		TweenInfo.new(math.random(0.1, 2), rand:NextNumber()*10, math.random(0, 2), math.random(1, 3), nextBoolean()), {
			Intensity = math.random(0, 5),
			Spread = rand:NextNumber()
		}):Play()

	TweenService:Create(clouds,  
		TweenInfo.new(math.random(0.1, 2), rand:NextNumber()*10, math.random(0, 2), math.random(1, 3), nextBoolean()), {
			Cover = rand:NextNumber(),
			Density = rand:NextNumber(),
			Color = nextColor3()
		}):Play()

	TweenService:Create(Lighting,  
		TweenInfo.new(math.random(0.1, 2), rand:NextNumber()*10, math.random(0, 2), math.random(1, 3), nextBoolean()), {
			ClockTime = math.random(0, 24),
			ExposureCompensation = math.random(-2, 3),
			GeographicLatitude = rand:NextNumber()*100,
			EnvironmentDiffuseScale = math.random(),
			EnvironmentSpecularScale = math.random(),
			OutdoorAmbient = nextColor3(),
			Ambient = nextColor3()
		}):Play()

	task.spawn(function()
		local sound: Sound = sounds[math.random(1, #sounds)]:Clone()

		sound.PlaybackSpeed = math.random(0.3, 4)
		sound.Volume = math.random(0.3, 10)
		sound.Parent = SoundService.EffectChange
		sound:Play()

		sound.Ended:Wait()
		sound:Destroy()
	end)

	workspace.Gravity = math.random(100, 500)
	workspace.GlobalWind = rand:NextUnitVector() * math.random(2, 100)
end)

fxTimer.TimeFunction = function()
	return os.time() + math.random(0, 1.3)
end

--###############################
--            SOUNDS
--###############################
soundTimer.Tick:Connect(function()
	local sound: Sound = sounds[math.random(1, #sounds)]:Clone()

	local doEffects = math.random(0, 2)

	if doEffects == 1 then
		local ds = Instance.new("DistortionSoundEffect")
		ds.Level = math.random(0.1, 0.7)
		ds.Parent = sound

		local rev = Instance.new("ReverbSoundEffect")
		rev.Density = math.random(0.1, 1)
		rev.DecayTime = math.random(0.1, 20)
		rev.Diffusion = math.random(0.1, 1)
		rev.DryLevel = math.random(-10, 10)
		rev.WetLevel = math.random(-10, 10)
		rev.Parent = sound
	end

	sound.Parent = lPlr.Character.Head or SoundService.EffectChange

	sound.PlaybackSpeed = math.random(0.3, 2.4)
	sound.Volume =math.random(0.3, 10)
	sound:Play()

	sound.Ended:Wait()
	sound:Destroy()
end)

soundTimer.TimeFunction = function()
	return os.time() + math.random(0, 6)
end

--###############################
--            IMAGES
--###############################
imageTimer.Tick:Connect(function()
	local image: ImageLabel = images[rand:NextInteger(1, #images)]:Clone()

	local info = TweenInfo.new(math.random(0.3, 2), rand:NextNumber()*10, math.random(0, 2), math.random(0, 1), nextBoolean())

	local tween = TweenService:Create(image, info, {ImageTransparency = 1})
	image.Parent = imageUi
	image.ImageTransparency = math.random(0, 0.2)

	local sound = image:FindFirstAncestorWhichIsA("Sound")

	if sound then
		local s = sound:Clone()
		s.Parent = SoundService.EffectChange

		s.PlaybackSpeed = math.random(0.3, 2.4)
		s.Volume = math.random(0.3, 10)

		local ds = Instance.new("DistortionSoundEffect")
		ds.Level = math.random(0.1, 0.7)
		ds.Parent = s

		local rev = Instance.new("ReverbSoundEffect")
		rev.Density = math.random(0.1, 1)
		rev.DecayTime = math.random(0.1, 20)
		rev.Diffusion = math.random(0.1, 1)
		rev.DryLevel = math.random(-10, 10)
		rev.WetLevel = math.random(-10, 10)
		rev.Parent = s

		s:Play()
	end

	task.spawn(function()
		task.wait(math.random(0.2, 0.4))

		tween:Play()
		tween.Completed:Wait()
		image:Destroy()
	end)

	TweenService:Create(camera, info, {FieldOfView = math.random(30, 120)}):Play()

	SoundService.AmbientReverb = math.random(0, 23)
end)

imageTimer.TimeFunction = function()
	return os.time() + math.random(0, 8)
end

--###############################
--         SCREEN SHAKE
--###############################
screenShakeTimer.Tick:Connect(function()
	Shaker.Amplitude = math.random(0.5, 4)
	Shaker.FadeInTime = math.random(0.1, 1.8)
	Shaker.FadeOutTime = math.random(0.1, 1.8)
	Shaker.Frequency = math.random(0.5, 10)
	Shaker.PositionInfluence = rand:NextUnitVector() * math.random(0.1, 20)
	Shaker.RotationInfluence = rand:NextUnitVector() * math.random(0.1, 20)

	Shaker:Start()
	Shaker:BindToRenderStep(Shake.NextRenderName(), priority, function(pos, rot, isDone)
		camera.CFrame *= CFrame.new(pos) * CFrame.Angles(rot.X, rot.Y, rot.Z)
	end)

	local hum = lPlr.Character.Humanoid

	if hum then
		hum.WalkSpeed = rand:NextNumber(6, 50)
		hum.JumpPower = rand:NextNumber(1, 50)
	end

	task.delay(math.random(0.5, 1) * Shaker.Amplitude/2, function()
		Shaker:Stop()
	end)

end)

screenShakeTimer.TimeFunction = function()
	return os.time() + math.random(0, 2.6)
end

--###############################
--      SOUND GROUP EFFECTS
--###############################
soundGroupTimer.Tick:Connect(function()
	local effect = soundEffects[math.random(1, #soundEffects)]
	print(effect)

	local instEffect = Instance.new(effect.Name)

	for k, v in pairs(effect) do
		if type(v) == "table" then
			instEffect[k] = math.random(v[1], v[2])
		end
	end

	instEffect.Parent = SoundService.EffectChange

	SoundService.EffectChange.Volume = math.random(0.5, 3)

	Debris:AddItem(instEffect, math.random(0.2, 4))
end)

soundGroupTimer.TimeFunction = function()
	return os.time() + math.random(0, 8)
end

--###############################
--             TEXT
--###############################
textTimer.Tick:Connect(function()
	local txt: TextLabel = randomTxt:Clone()
	txt.Text = randomTexts[math.random(1, #randomTexts)]
	txt.Size = UDim2.new(math.random(0.5, 1.3), math.random(300, 600), math.random(0.5, 1.3), math.random(300, 600))
	txt.Position = UDim2.new(rand:NextNumber(0, 1), 0, rand:NextNumber(0, 1) ,0)
	txt.TextScaled = true
	txt.TextColor3 = nextColor3()

	if nextBoolean() then
		txt.Rotation = math.random(0, 360)
	end

	if nextBoolean() then
		local gradient = Instance.new("UIGradient")
		gradient.Parent = txt
		gradient.Color = nextColorSequence()
		gradient.Transparency = NumberSequence.new(rand:NextNumber())
		txt.BackgroundTransparency = rand:NextNumber()
	else
		txt.BackgroundTransparency = 1
	end

	if nextBoolean() then
		local info = TweenInfo.new(math.random(0.2, 2), rand:NextNumber()*10, math.random(0, 2), math.random(0, 2), nextBoolean())

		TweenService:Create(txt, info, {
			Size = txt.Size + UDim2.fromScale(txt.Size.X.Scale * 1.2, txt.Size.Y.Scale * 1.2),
			BackgroundTransparency = rand:NextNumber(),
			TextTransparency = rand:NextNumber(0.7, 1),
			Rotation = math.random(0, 360*2)
		}):Play()
	end

	txt.Parent = txtUi

	Debris:AddItem(txt, math.random(1, 3))
end)

textTimer.TimeFunction = function()
	return os.time() + math.random(0.2, 0.9)
end


--###############################
--     CHARACTER ANIMATIONS
--###############################
animTimer.Tick:Connect(function()
	local char = lPlr.Character
	if not char then return end

	local hum = char:FindFirstChildWhichIsA("Humanoid", false)
	if not hum then return end

	local animator = hum:FindFirstChildWhichIsA("Animator")
	if not animator then return end

	local anim: Animation = animations[math.random(1, #animations)]

	local track = animator:LoadAnimation(anim)

	track:Play()

	local c = coroutine.create(function()
		while true do
			task.wait(math.random(0.2, 1))
			track:AdjustSpeed(math.random(-1.5, 4))
			track:AdjustWeight(math.random(0.5, 1.5), math.random(0.1, 1.1))
		end
	end)

	coroutine.resume(c)

	track.Ended:Once(function()
		coroutine.close(c)
	end)
end)

animTimer.TimeFunction = function()
	return os.time() + rand:NextNumber(1, 3)
end

-- END OF TIMERS

for _, timr in pairs(timers) do
	if Timer.Is(timr) then
		timr:StartNow()
	end
end

silenceEvent.Event:Once(function()
	for _, timer in pairs(timers) do
		if Timer.Is(timer) then
			timer:Stop()
		end
	end
	

	Shaker:Stop()
	
	lPlr.Humanoid.Died:Once(function()
		for _, timr in pairs(timers) do
			if Timer.Is(timr) then
				timr:Start()
			end
		end
	end)
end)