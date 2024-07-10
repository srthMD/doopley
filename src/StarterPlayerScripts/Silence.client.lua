local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TextChatService = game:GetService("TextChatService")
local TweenService = game:GetService("TweenService")

local defaults = require(ReplicatedStorage.Source.Defaults)

local event: BindableEvent = ReplicatedStorage.Signals.Client.Silence
local moveEv = ReplicatedStorage.Signals.Server.Silence
local sound: Sound = SoundService.silence

local lPlr = Players.LocalPlayer
local plrGui = lPlr.PlayerGui

local c do
	c = TextChatService.SendingMessage:Connect(function(textChatMessage)
        if textChatMessage.Text == "SILENCE!" then 
            event:Fire()

            SoundService.AmbientReverb = Enum.ReverbType.NoReverb
			sound:Play()
			
			for _, v in pairs(lPlr.Character.Head:GetChildren()) do
				if v:IsA("Sound") then
					v:Destroy()
				end
			end
			
			task.spawn(function()
				sound.Ended:Wait()
				sound:Destroy()
			end)

            plrGui.Text:ClearAllChildren()
			plrGui.Images:ClearAllChildren()
			
			moveEv:FireServer()
			
			SoundService.EffectChange:ClearAllChildren()
			
			local hum: Humanoid = lPlr.Character.Humanoid
			local anim = hum:FindFirstChildWhichIsA("Animator")
			
			for _, track: AnimationTrack in pairs(anim:GetPlayingAnimationTracks()) do
				track:Stop()
			end
			
			hum.WalkSpeed = 16
			hum.JumpPower = 50
			
			workspace.CurrentCamera.FieldOfView = 70
			
			SoundService.DopplerScale = 1
			SoundService.DistanceFactor = 3.33

			for _, tbl: table in pairs(defaults) do
                local ref = tbl["Ref"]
				for k: string, v in pairs(tbl) do
					if k == "Ref" then continue end
                    ref[k] = v
                end
			end
			
			game.Lighting.Changed:Connect(function(prop)
				if prop == "TimeOfDay" then return end
				game.Lighting[prop] = defaults["Lighting"][prop]
			end)
			
			game.Lighting.Atmosphere.Changed:Connect(function(prop)
				game.Lighting.Atmosphere[prop] = defaults["Atmosphere"][prop]
			end)
			
			workspace.Mape.ModelDebris:ClearAllChildren()
			workspace.Mape.ModelDebris.ChildAdded:Connect(function(inst)
				inst:Destroy()
			end)
			
			task.delay(8, function()
				SoundService.ambience:Play()
				TweenService:Create(SoundService.ambience, TweenInfo.new(10, Enum.EasingStyle.Linear), 
					{
						Volume = 0.8;
					}
				):Play()
			end)

            c:Disconnect()
            c = nil
        end
    end)
end