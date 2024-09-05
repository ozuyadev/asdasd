
if not LPH_OBFUSCATED then
	getfenv().LPH_NO_VIRTUALIZE = function(f) return f end
	getfenv().LPH_JIT_MAX = function(f) return f end
end





LPH_JIT_MAX(function()
	
	local Hooks = {}
	local Targets = {}
	local Whitelisted = {
		{655, 775, 724, 633, 891},
		{760, 760, 771, 665, 898},
		{660, 759, 751, 863, 771},
	}
	
	local function TableEquality(x, y)
		if (#x ~= #y) then
			return false
		end
	
		for i, v in next, x do
			if (y[i] ~= v) then
				return false
			end
		end
	
		return true
	end
	
	LPH_NO_VIRTUALIZE(function()
		for i, v in next, getgc(true) do
			if (type(v) == "function") then
				local ScriptTrace, Line = debug.info(v, "sl")
		
				if string.find(ScriptTrace, "PlayerModule.LocalScript") and table.find({42, 51, 61}, Line) then
					table.insert(Targets, v)
				end
			end
			
			if (type(v) == "table") and (rawlen(v) == 19) and getrawmetatable(v) then
				Targets.__call = rawget(getrawmetatable(v), "__call")
			end
		end
	end)()
	
	
	if not (Targets[1] and Targets[2] and Targets[3] and Targets.__call) then
		warn("Bypass failed to load properly")
		return
	end
	
	local ScriptPath = debug.info(Targets[1], "s")
	
	Hooks.debug_info = hookfunction(debug.info, LPH_NO_VIRTUALIZE(function(...)
		if not checkcaller() and TableEquality({...}, {2, "s"}) then
			return ScriptPath
		end
	
		return Hooks.debug_info(...)
	end))
	
	hookfunction(Targets[1], LPH_NO_VIRTUALIZE(function() end))
	hookfunction(Targets[2], LPH_NO_VIRTUALIZE(function() end))
	hookfunction(Targets[3], LPH_NO_VIRTUALIZE(function() end))
	
	Hooks.__call = hookfunction(Targets.__call, LPH_NO_VIRTUALIZE(function(self, ...)
		if
			TableEquality(Whitelisted[1], {...}) or
			TableEquality(Whitelisted[2], {...}) or
			TableEquality(Whitelisted[3], {...})
		then
			return Hooks.__call(self, ...)
		end
	end))
	
	task.wait(3)
	
end)()
	




    local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/YungPloits/Orionmoible/main/UICode')))()
    local Window = OrionLib:MakeWindow({Name = "Tyrant Hub", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

  
    local Tab = Window:MakeTab({
        Name = "Info",
      Icon = "rbxassetid://4483345998",
      PremiumOnly = false
      })

      Tab:AddSection({Name = "Credits"})
      Tab:AddLabel("Owner: Zyro")
      Tab:AddLabel("CoOwner: Myers")
      Tab:AddLabel("Info: Tyrant Paid")
      Tab:AddSection({Name = "Other"})
      Tab:AddLabel("Version: 1.4")

      Tab:AddButton({
        Name = "CopyDiscord",
        Callback = function()
            setclipboard("https://discord.gg/tyranthub")
            OrionLib:MakeNotification({
                Name = "CopiedDiscord!",
                Content = "Tyrant Hub Has Been Copied Paste In Your Browser!",
                Image = "rbxassetid://4483345998",
                Time = 7
            })
          end    
    })


        local Tab = Window:MakeTab({
          Name = "Catching",
          Icon = "rbxassetid://4483345998",
          PremiumOnly = false
        })
  
     
 Tab:AddSection({Name = "Magnets"})
  
      
 local originalSizes = {}
 local originalTransparencies = {}
 local showTransparencyState = false
 local magEnabled = false
 local customDistance = 0
 local magnetDelayEnabled = false
 local magnetDelay = 0
 
 local magtoggle = Tab:AddToggle({
     Name = "Magnets",
     Default = false,
     Callback = function(value)
         magEnabled = value
     end,
 })
 
 local magslider = Tab:AddSlider({
     Name = "Magnets Range",
     Min = 1,
     Max = 50,
     Default = 0,
     Color = Color3.fromRGB(255, 255, 255),
     Increment = 0.1,
     ValueName = "Range",
     Callback = function(value)
         customDistance = value
     end,
 })
 
local delaytoggle = Tab:AddToggle({
     Name = "Magnets Delay",
     Default = false,
     Callback = function(value)
         magnetDelayEnabled = value
     end,
 })
 
local delayslider = Tab:AddSlider({
     Name = "Magnets Delay",
     Min = 0,
     Max = 1,
     Default = 0,
     Color = Color3.fromRGB(255, 255, 255),
     Increment = 0.1,
     ValueName = "Delay",
     Callback = function(value)
         magnetDelay = value
     end,
 })

 local Section = Tab:AddSection({
	Name = "MagSettings"
})
 
 Tab:AddToggle({
     Name = "ShowHitbox",
     Default = false,
     Callback = function(Value)
         showTransparencyState = Value
     end,
 })


 Tab:AddDropdown({
	Name = "MagPresets",
	Default = "1",
	Options = {"League", "Legit", "Regular", "Blatant"},
	Callback = function(t)
		if t == "League" then

            delaytoggle:Set(true)
            magtoggle:Set(true)
            magslider:Set(7.5)
            delayslider:Set(0.1)             
        elseif t == "Legit" then

            delaytoggle:Set(true)
            magtoggle:Set(true)
            delayslider:Set(0.1)     
            magslider:Set(10)

        elseif t == "Regular" then

            delaytoggle:Set(true)
            magtoggle:Set(true)
            delayslider:Set(0.1)     
            magslider:Set(15)

        elseif t == "Blatant" then
          
            delaytoggle:Set(false)
            magtoggle:Set(true)
            magslider:Set(50)
        end  
	end    
})

 

 local function updateMagnetStatus()
     local player = game:GetService("Players").LocalPlayer
     local character = player.Character
 
     if character then
         local left = character:FindFirstChild("CatchLeft")
         local right = character:FindFirstChild("CatchRight")
 
         if left and right then
             if magEnabled then
                 originalSizes[left] = originalSizes[left] or left.Size
                 originalSizes[right] = originalSizes[right] or right.Size
                 originalTransparencies[left] = originalTransparencies[left] or left.Transparency
                 originalTransparencies[right] = originalTransparencies[right] or right.Transparency
 
                 if magnetDelayEnabled then
                     wait(magnetDelay) 
                 end
 
                 left.Size = Vector3.new(customDistance, customDistance, customDistance)
                 right.Size = Vector3.new(customDistance, customDistance, customDistance)
                 left.Transparency = showTransparencyState and 0.8 or 1
                 right.Transparency = showTransparencyState and 0.8 or 1
             else
                 left.Size = originalSizes[left] or left.Size
                 right.Size = originalSizes[right] or right.Size
                 left.Transparency = originalTransparencies[left] or left.Transparency
                 right.Transparency = originalTransparencies[right] or right.Transparency
             end
         end
     end
 end
 

 spawn(function()
     while true do
         updateMagnetStatus()
         wait(1) 
     end
 end)

 
 local Section = Tab:AddSection({
	Name = "PullVector"
})

  local Configs = {
    PullVector = false,
    PullVectorDistance = 0,
}

  Tab:AddToggle({
	Name = "PullVector",
	Default = false,
	Callback = function(Value)
		Configs.PullVector = Value
        if Value then
            applyPullVector()
        end
	end    
})

Tab:AddSlider({
	Name = "Distance",
	Min = 0,
	Max = 50,
	Default = 35,
	Color = Color3.fromRGB(255,255,255),
	Increment = 0.1,
	ValueName = "Range",
	Callback = function(Value)
		Configs.PullVectorDistance = Value
	end    
})

task.spawn(function()
    game:GetService("RunService").RenderStepped:Connect(function()
        for _, v in workspace:GetChildren() do
            if v.Name == "Football" and v:IsA("BasePart") and game:GetService("Players").LocalPlayer.Character and Configs.PullVector == true then
                local Angle = (v.Position - game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Unit
                local Distance = (v.Position - game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude

                if Distance < Configs.PullVectorDistance then
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Angle * Configs.PullVectorDistance
                end
            end
        end
    end)
end)
 
  
  
                                            local plr = game:GetService("Players").LocalPlayer
                                            local armLengthIncrease = 0 
                                            local armsTransparent = false
                                            local handSizeEnabled = false 
  
                                            local originalSizes = {} 
  
                                            local function onCharacterAdded(character)
                                                local function resizeArms()
                                                    local leftArm = character:FindFirstChild("Left Arm") or character:FindFirstChild("LeftUpperArm")
                                                    local rightArm = character:FindFirstChild("Right Arm") or character:FindFirstChild("RightUpperArm")
  
                                                    if leftArm and rightArm then
                                                        if not originalSizes[character] then
                                                            
                                                            originalSizes[character] = {
                                                                leftArmSize = leftArm.Size,
                                                                rightArmSize = rightArm.Size,
                                                                leftShoulderC0 = leftArm:FindFirstChildOfClass("Motor6D") and leftArm:FindFirstChildOfClass("Motor6D").C0,
                                                                rightShoulderC0 = rightArm:FindFirstChildOfClass("Motor6D") and rightArm:FindFirstChildOfClass("Motor6D").C0
                                                            }
                                                        end
  
                                                        if handSizeEnabled then
                                                            
                                                            local lengthIncrease = Vector3.new(0, armLengthIncrease, 0)
                                                            leftArm.Size = originalSizes[character].leftArmSize + lengthIncrease
                                                            rightArm.Size = originalSizes[character].rightArmSize + lengthIncrease
  
                                                            
                                                            if leftArm:FindFirstChildOfClass("Motor6D") then
                                                                local leftShoulder = leftArm:FindFirstChildOfClass("Motor6D")
                                                                leftShoulder.C0 = originalSizes[character].leftShoulderC0 * CFrame.new(0, armLengthIncrease / 2, 0) 
  
                                                                local rightShoulder = rightArm:FindFirstChildOfClass("Motor6D")
                                                                rightShoulder.C0 = originalSizes[character].rightShoulderC0 * CFrame.new(0, armLengthIncrease / 2, 0) 
                                                            end
  
                                                           
                                                            local transparencyValue = armsTransparent and 1 or 0
                                                            leftArm.Transparency = transparencyValue
                                                            rightArm.Transparency = transparencyValue
                                                        else
                                                          
                                                            leftArm.Size = originalSizes[character].leftArmSize
                                                            rightArm.Size = originalSizes[character].rightArmSize
  
                                                        
                                                            if leftArm:FindFirstChildOfClass("Motor6D") then
                                                                local leftShoulder = leftArm:FindFirstChildOfClass("Motor6D")
                                                                leftShoulder.C0 = originalSizes[character].leftShoulderC0
  
                                                                local rightShoulder = rightArm:FindFirstChildOfClass("Motor6D")
                                                                rightShoulder.C0 = originalSizes[character].rightShoulderC0
                                                            end
  
                                                        
                                                            leftArm.Transparency = 0
                                                            rightArm.Transparency = 0
                                                        end
                                                    end
                                                end
  
                                              
                                                resizeArms()
                                            end
  
                                        
                                            plr.CharacterAdded:Connect(onCharacterAdded)
  
                                           
                                            if plr.Character then
                                                onCharacterAdded(plr.Character)
                                            end
  
                                         
                                            local Section = Tab:AddSection({
                                                Name = "IncreasedHands"
                                            })
  
                                            Tab:AddToggle({
                                                Name = "Increased Hand Size",
                                                Default = false,
                                                Callback = function(Value)
                                                    handSizeEnabled = Value
                                                    if plr.Character then
                                                        onCharacterAdded(plr.Character)
                                                    end
                                                end    
                                            })
  
                                            Tab:AddSlider({
                                                Name = "HandSizeDistance",
                                                Min = 0,
                                                Max = 10,
                                                Default = 0,
                                                Color = Color3.fromRGB(255,255,255),
                                                Increment = 1,
                                                ValueName = "Distance",
                                                Callback = function(Value)
                                                    armLengthIncrease = Value
                                                    if plr.Character and handSizeEnabled then
                                                        onCharacterAdded(plr.Character)
                                                    end
                                                end    
                                            })
  
                                            Tab:AddToggle({
                                                Name = "HideHands",
                                                Default = false,
                                                Callback = function(Value)
                                                    armsTransparent = Value
                                                    if plr.Character then
                                                        onCharacterAdded(plr.Character)
                                                    end
                                                end    
                                            })

  

  local Tab = Window:MakeTab({
    Name = "Player",
  Icon = "rbxassetid://4483345998",
  PremiumOnly = false
  })

  local Section = Tab:AddSection({
    Name = "RegPlayer"
})

local player = game:GetService("Players").LocalPlayer
local humanoidRootPart = player.Character:WaitForChild("HumanoidRootPart")

local jumppowerEnabled = false
local currentJumpPower = 50
local walkspeedEnabled = false
local currentWalkspeed = 20 

local wstoggle = Tab:AddToggle({
    Name = "RegWS",
    Default = false,
    Callback = function(Value)
        walkspeedEnabled = Value
        if walkspeedEnabled then
            player.Character.Humanoid.WalkSpeed = currentWalkspeed
          
            spawn(function()
                while walkspeedEnabled do
                    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
                        player.Character.Humanoid.WalkSpeed = currentWalkspeed
                    end
                    wait(2) 
                end
            end)
        else
            player.Character.Humanoid.WalkSpeed = 20 
        end
    end    
})

local wsslider = Tab:AddSlider({
    Name = "Walkspeed",
    Min = 20,
    Max = 23,
    Default = 20,
    Color = Color3.fromRGB(255,255,255),
    Increment = 0.1,
    ValueName = "Walkspeed",
    Callback = function(Value)
        currentWalkspeed = Value
        if walkspeedEnabled then
            player.Character.Humanoid.WalkSpeed = currentWalkspeed
        end
    end    
})

local jptoggle  = Tab:AddToggle({
    Name = "RegJP",
    Default = false,
    Callback = function(Value)
        jumppowerEnabled = Value
        if jumppowerEnabled then
            player.Character.Humanoid.JumpPower = currentJumpPower
           
            spawn(function()
                while jumppowerEnabled do
                    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
                        player.Character.Humanoid.JumpPower = currentJumpPower
                    end
                    wait(2)
                end
            end)
       
            player.Character.Humanoid.Jumping:Connect(function()
                if jumppowerEnabled then
                    humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, currentJumpPower, 0)
                end
            end)
        else
            player.Character.Humanoid.JumpPower = 50 
            humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0) 
        end
    end
})

local jpslider = Tab:AddSlider({
    Name = "Jumppower",
    Min = 50,
    Max = 60,
    Default = 50,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 0.1,
    ValueName = "JumpPower",
    Callback = function(Value)
        currentJumpPower = Value
        if jumppowerEnabled then
            player.Character.Humanoid.JumpPower = currentJumpPower
        end
    end
})




  local Section = Tab:AddSection({
    Name = "NonSilent"
  })


  _G.Walkspeed = false
  _G.WalkspeedValue = 0.30
  
  local moveConnection
  
  local function startMovement()
      if not _G.Walkspeed then
          return
      end
      _G.Walkspeed = false
  
      moveConnection = task.spawn(function()
          while not _G.Walkspeed do
              local player = game:GetService("Players").LocalPlayer
              local character = player.Character
              if character then
                  local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                  local humanoid = character:FindFirstChild("Humanoid")
                  if humanoidRootPart and humanoid then
                      humanoidRootPart.CFrame = humanoidRootPart.CFrame + humanoid.MoveDirection * _G.WalkspeedValue
                  end
              end
              task.wait()
          end
      end)
  end
  
  local function stopMovement()
      if _G.Walkspeed then
          return
      end
      _G.Walkspeed = true
      if moveConnection then
          moveConnection:cancel()
          moveConnection = nil
      end
  end
  
  Tab:AddToggle({
      Name = "Faster Walkspeed",
      Default = false,
      Callback = function(Value)
          _G.Walkspeed = Value
          if Value then
              startMovement()
          else
              stopMovement()
          end
      end    
  })
  
  Tab:AddSlider({
      Name = "Walkspeed",
      Min = 0,
      Max = 0.45,
      Default = 0,
      Color = Color3.fromRGB(255, 255, 255),
      Increment = 0.01,
      ValueName = "Speed",
      Callback = function(Value)
          _G.WalkspeedValue = Value
      end    
  })
  
  _G.JumpPower = false
  _G.JumpPowerValue = 50 
  
  local jumpConnection
  
  local function startJumpPower()
      if not _G.JumpPower then
          return
      end
      _G.JumpPower = false
  
      jumpConnection = task.spawn(function()
          while not _G.JumpPower do
              local player = game:GetService("Players").LocalPlayer
              local character = player.Character
              if character then
                  local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                  local humanoid = character:FindFirstChild("Humanoid")
                  if humanoidRootPart and humanoid then
                 
                      if humanoid:GetState() == Enum.HumanoidStateType.Jumping then
                          humanoidRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(0, _G.JumpPowerValue / 50, 0)
                      end
                  end
              end
              task.wait()
          end
      end)
  end
  
  local function stopJumpPower()
      if _G.JumpPower then
          return
      end
      _G.JumpPower = true
      if jumpConnection then
          jumpConnection:cancel()
          jumpConnection = nil
      end
  end
  
  Tab:AddToggle({
      Name = "Higher JumpPower",
      Default = false,
      Callback = function(Value)
          _G.JumpPower = Value
          if Value then
              startJumpPower()
          else
              stopJumpPower()
          end
      end    
  })
  
  Tab:AddSlider({
      Name = "Jumppower",
      Min = 50, 
      Max = 300, 
      Default = 50, 
      Color = Color3.fromRGB(255, 255, 255),
      Increment = 1,
      ValueName = "Power",
      Callback = function(Value)
          _G.JumpPowerValue = Value
      end    
  })
  
  local player = game:GetService("Players").LocalPlayer
  local function onCharacterAdded(character)
      character:WaitForChild("HumanoidRootPart")
      if _G.Walkspeed then
          startMovement()
      end
      if _G.JumpPower then
          startJumpPower()
      end
  end
  
  player.CharacterAdded:Connect(onCharacterAdded)
  
  if player.Character then
      onCharacterAdded(player.Character)
  end



local AngleEnhancer = {
    Physics = {
        Enabled = true,
        NormalJumpPower = 50,
        BoostedJumpPower = 70,
    },
    ShiftBoostDuration = 1,
}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local boostActive = false


local function isShiftPressed()
    return UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
end


local function onCharacterMovement(character)
    local humanoid = character:WaitForChild("Humanoid")
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    humanoid.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Jumping and AngleEnhancer.Physics.Enabled then
            task.wait(0.05)
            local currentVelocity = humanoidRootPart.AssemblyLinearVelocity
            local jumpPower = boostActive and AngleEnhancer.Physics.BoostedJumpPower or AngleEnhancer.Physics.NormalJumpPower
            humanoidRootPart.AssemblyLinearVelocity = Vector3.new(currentVelocity.X, jumpPower, currentVelocity.Z)
        end
    end)
end


local function applyJumpBoost()
    if not boostActive then
        boostActive = true
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        onCharacterMovement(character)
        task.delay(AngleEnhancer.ShiftBoostDuration, function()
            boostActive = false
        end)
    end
end

local function initializePlayer(player)
    player.CharacterAdded:Connect(onCharacterMovement)
    if player.Character then
        onCharacterMovement(player.Character)
    end
end


Players.PlayerAdded:Connect(initializePlayer)
for _, player in pairs(Players:GetPlayers()) do
    initializePlayer(player)
end


RunService.RenderStepped:Connect(function()
    if AngleEnhancer.Physics.Enabled and isShiftPressed() then
        applyJumpBoost()
    end
end)


local Section = Tab:AddSection({
    Name = "Angle"
})

Tab:AddToggle({
    Name = "Angle Booster (PC Exclusive)",
    Default = false,
    Callback = function(enabled)
        AngleEnhancer.Physics.Enabled = enabled
    end
})

Tab:AddSlider({
    Name = "JP",
    Min = 50,
    Max = 70,
    Default = 5,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 0.1,
    ValueName = "Angle Enhancer",
    Callback = function(value)
        AngleEnhancer.Physics.BoostedJumpPower = value
    end
})




  



local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local FLYING = false
local flySpeed = 5 


local function startFlying()
    if FLYING then return end
    FLYING = true

    local BG = Instance.new('BodyGyro')
    local BV = Instance.new('BodyVelocity')
    BG.P = 9e4
    BG.Parent = character.PrimaryPart
    BV.Parent = character.PrimaryPart
    BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BG.CFrame = character.PrimaryPart.CFrame
    BV.Velocity = Vector3.new(0, 0, 0)
    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    RunService.RenderStepped:Connect(function()
        if not FLYING then return end

        local camera = workspace.CurrentCamera
        local control = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}

       
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            control.F = flySpeed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            control.B = -flySpeed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            control.L = -flySpeed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            control.R = flySpeed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            control.Q = flySpeed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            control.E = -flySpeed
        end

        BV.Velocity = ((camera.CFrame.LookVector * control.F) + (camera.CFrame.RightVector * control.R) + (camera.CFrame.UpVector * control.Q)) * flySpeed
        BG.CFrame = camera.CFrame
    end)
end


local function stopFlying()
    if not FLYING then return end
    FLYING = false

    for _, v in pairs(character.PrimaryPart:GetChildren()) do
        if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then
            v:Destroy()
        end
    end

    if humanoid then
        humanoid.PlatformStand = false
    end
end

local Section = Tab:AddSection({
	Name = "Fly"
})


Tab:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(Value)
        if Value then
            startFlying()
        else
            stopFlying()
        end
    end    
})


Tab:AddSlider({
    Name = "FlySpeed",
    Min = 0,
    Max = 7,
    Default = 4.5,
    Color = Color3.fromRGB(255,255,255),
    Increment = 0.1,
    ValueName = "Speed",
    Callback = function(Value)
        flySpeed = Value
        print("Fly Speed set to: " .. flySpeed)
    end    
})

  

  local Section = Tab:AddSection({
	Name = "OtherPlayer"
})

local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")


Tab:AddSlider({
    Name = "HipHeight",
    Min = 0,
    Max = 8,
    Default = 0,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 0.1,
    ValueName = "",
    Callback = function(Value)
        humanoid.HipHeight = Value
    end    
})



Tab:AddSlider({
	Name = "Field of View",
	Min = 70,
	Max = 120,
	Default = 70,
	Color = Color3.fromRGB(255, 255, 255),
	Increment = 1,
	ValueName = "view",
	Callback = function(Value)
		game:GetService("Workspace").CurrentCamera.FieldOfView = Value
	end    
})

Tab:AddSlider({
    Name = "Gravity",
    Min = 30,
    Max = 196.2,
    Default = 196.2,
    Color = Color3.fromRGB(255,255,255),
    Increment = 0.2,
    ValueName = "Gravity",
    Callback = function(Value)
        game.Workspace.Gravity = Value
    end    
})


local Player = game:GetService('Players').LocalPlayer
local UIS = game:GetService('UserInputService')

_G.JumpHeight = 50
local infJumpEnabled = false

function Action(Object, Function) 
    if Object ~= nil then 
        Function(Object) 
    end 
end

UIS.InputBegan:connect(function(UserInput)
    if infJumpEnabled and UserInput.UserInputType == Enum.UserInputType.Keyboard and UserInput.KeyCode == Enum.KeyCode.Space then
        Action(Player.Character.Humanoid, function(self)
            if self:GetState() == Enum.HumanoidStateType.Jumping or self:GetState() == Enum.HumanoidStateType.Freefall then
                Action(self.Parent.HumanoidRootPart, function(self)
                    self.Velocity = Vector3.new(0, _G.JumpHeight, 0)
                end)
            end
        end)
    end
end)

Tab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        infJumpEnabled = Value
    end    
})


  

                                        local playerr = game:GetService("Players").LocalPlayer
  
                                            local Tab = Window:MakeTab({
                                                Name = "Physics",
                                                Icon = "rbxassetid://4483345998",
                                                PremiumOnly = false
                                            })
                                          
  
  
  
                          local Section = Tab:AddSection({
                            Name = "Follow"
                          })
  
  
    repeat wait() until game:IsLoaded()
  
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
  
    local LocalPlayer = Players.LocalPlayer
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
  
    local AutoFollowQb = false
    local followCarrierTask
    local followDelay = 0  
  
    local function FollowCarrier()
        while AutoFollowQb do
            local carrier = ReplicatedStorage.Values.Carrier.Value
            if carrier and carrier:IsDescendantOf(Players) and carrier.Team ~= LocalPlayer.Team then
                local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid and carrier.Character and carrier.Character:FindFirstChild("HumanoidRootPart") then
                    humanoid:MoveTo(carrier.Character.HumanoidRootPart.Position)
                end
            end
            RunService.Heartbeat:Wait()  
            wait(followDelay)  
        end
    end
  
    local function ToggleFollowCarrier(value)
        AutoFollowQb = value
        if value then
            followCarrierTask = task.spawn(FollowCarrier)
        else
            followCarrierTask = nil 
        end
    end
  
    Tab:AddToggle({
        Name = "Follow Ball Carrier",
        Default = false,
        Callback = ToggleFollowCarrier,
    })
  
    Tab:AddSlider({
        Name = "Follow Delay",
        Min = 0,
        Max = 1,
        Default = 0,  
        Color = Color3.fromRGB(255, 255, 255),
        Increment = 0.1,
        ValueName = "Delay",
        Callback = function(Value)
            followDelay = Value
        end    
    })
  
  
      local Section = Tab:AddSection({
          Name = "F To Tp"
      })
  
  
  

  repeat wait() until game:IsLoaded()

  local player = game:GetService("Players").LocalPlayer
  local userInputService = game:GetService("UserInputService")
  

  local teleportEnabled = false
  local teleportDistance = 1 
  

  local function teleportForward()
      local character = player.Character or player.CharacterAdded:Wait()
      local rootPart = character:FindFirstChild("HumanoidRootPart")
      if rootPart then
          local forwardVector = rootPart.CFrame.LookVector
          local newPosition = rootPart.Position + forwardVector * teleportDistance
          rootPart.CFrame = CFrame.new(newPosition, newPosition + forwardVector)
          
      else
          print("Root part not found")
      end
  end
  

  local function onKeyPress(input, gameProcessedEvent)
      if input.KeyCode == Enum.KeyCode.F and not gameProcessedEvent then
          
          if teleportEnabled then
              teleportForward()
          end
      end
  end
  

  userInputService.InputBegan:Connect(onKeyPress)

  Tab:AddToggle({
      Name = "F To Tp",
      Default = false,
      Callback = function(Value)
          teleportEnabled = Value
  
          if teleportEnabled then
            
             local ScreenGui = Instance.new("ScreenGui")
             local TextButton = Instance.new("TextButton")
             local UICorner = Instance.new("UICorner")
 
             ScreenGui.Parent = player:WaitForChild("PlayerGui")
             ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
 
             TextButton.Parent = ScreenGui
             TextButton.BackgroundColor3 = Color3.fromRGB(244, 63, 235)
             TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
             TextButton.BorderSizePixel = 0
             TextButton.Position = UDim2.new(0.47683534, 0, 0.461152881, 0)
             TextButton.Size = UDim2.new(0, 65, 0, 62)
             TextButton.Font = Enum.Font.SourceSans
             TextButton.Text = "F TO TP"
             TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
             TextButton.TextSize = 14.000
 
             UICorner.Parent = TextButton
 
           
             local function dragify(button)
                 local dragging, dragInput, dragStart, startPos
 
                 local function update(input)
                     local delta = input.Position - dragStart
                     button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                 end
 
                 button.InputBegan:Connect(function(input)
                     if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                         dragging = true
                         dragStart = input.Position
                         startPos = button.Position
 
                         input.Changed:Connect(function()
                             if input.UserInputState == Enum.UserInputState.End then
                                 dragging = false
                             end
                         end)
                     end
                 end)
 
                 button.InputChanged:Connect(function(input)
                     if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                         dragInput = input
                     end
                 end)
 
                 userInputService.InputChanged:Connect(function(input)
                     if dragging and input == dragInput then
                         update(input)
                     end
                 end)
             end
 
             dragify(TextButton)
  

              TextButton.MouseButton1Click:Connect(teleportForward)
          else

              local existingGui = player.PlayerGui:FindFirstChild("ScreenGui")
              if existingGui then
                  existingGui:Destroy()
              end
          end
      end
  })
  

  Tab:AddSlider({
      Name = "F To Tp Distance",
      Min = 0,
      Max = 5,
      Default = 1,
      Color = Color3.fromRGB(255, 255, 255),
      Increment = 0.5,
      ValueName = "Range",
      Callback = function(Value)
          teleportDistance = Value
      end
  })
  

  local function setupCharacter()
      local character = player.Character or player.CharacterAdded:Wait()

  end
  

  player.CharacterAdded:Connect(setupCharacter)
  

  setupCharacter()
  
  
  
  
    local swatreachmain = false
    local player = game:GetService("Players").LocalPlayer
    local swatDistance = 7  
    local swatted = false
    local userInputService = game:GetService("UserInputService")
  
    local function isFootball(fb)
        return fb and fb:FindFirstChildWhichIsA("RemoteEvent")
    end
  
    local function getNearestBall(checkFunc)
        local lowestDistance = math.huge
        local lowestFB = nil
        for index, part in pairs(workspace:GetChildren()) do
            if isFootball(part) and not part.Anchored then
                if checkFunc then
                    if not checkFunc(part) then
                        continue
                    end
                end
                local distance = (player.Character.HumanoidRootPart.Position - part.Position).Magnitude
                if distance < lowestDistance then
                    lowestFB = part
                    lowestDistance = distance
                end
            end
        end
        return lowestFB, lowestDistance
    end
  
    local function getNearestPartToPartFromParts(parts, part)
        local lowestMagnitude = math.huge
        local lowestPart = nil
        for index, p in pairs(parts) do
            local dis = (part.Position - p.Position).Magnitude
            if dis < lowestMagnitude then
                lowestMagnitude = dis
                lowestPart = p
            end
        end
        return lowestPart
    end
  
    local function initCharacter(char)
        while swatreachmain do
            task.wait()
            local ball = getNearestBall()
            if ball and swatted then
                local distance = (player.Character.HumanoidRootPart.Position - ball.Position).Magnitude
                if distance < swatDistance then
                    local catch = getNearestPartToPartFromParts({player.Character["CatchLeft"], player.Character["CatchRight"]}, ball)
                    firetouchinterest(ball, catch, 0)
                    firetouchinterest(ball, catch, 1)
                end
            end
        end
    end
  
    userInputService.InputBegan:Connect(function(input, gp)
        if not gp then
            if input.KeyCode == Enum.KeyCode.R and not swatted then
                swatted = true
                task.wait(1.5)
                swatted = false
            end
        end
    end)
  
    local function updateCharacter(character)
        if swatreachmain then
            initCharacter(character)
        end
    end
  
    player.CharacterAdded:Connect(updateCharacter)
  
        local Section = Tab:AddSection({
            Name = "SwatReach"
        })
  

    local swattoggle = Tab:AddToggle({
        Name = "SwatReach",
        Default = false,
        Callback = function(Value)
            swatreachmain = Value
            if Value then
                updateCharacter(player.Character)
            end
        end
    })
  

   Tab:AddSlider({
        Name = "SwatReachDistance",
        Min = 7,
        Max = 25,
        Default = 25,
        Color = Color3.fromRGB(255,255,255),
        Increment = 1,
        ValueName = "Reach",
        Callback = function(Value)
            swatDistance = Value
            
        end    
    })
  
    if swatreachmain then
        initCharacter(player.Character)
    end


    local Section = Tab:AddSection({
        Name = "Blocking"
    })


    ReachDistance = 20

    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    
  
    local workspace = game:GetService("Workspace")
    local playerCharacter = workspace:FindFirstChild(localPlayer.Name)
    
    local showHitboxState = false
    local toggleState = false
    
   
    local function handleToggle(state)
        if playerCharacter then
            local blockPart = playerCharacter:FindFirstChild("BlockPart")
            if blockPart then
                blockPart.CanCollide = false 
                if state then
                    blockPart.Size = Vector3.new(ReachDistance, ReachDistance, ReachDistance)
                    if showHitboxState then
                        blockPart.Transparency = 0.7 
                    else
                        blockPart.Transparency = 1 
                    end
                else
                    blockPart.Size = Vector3.new(0.75, 5, 1.5) 
                    blockPart.Transparency = 1
                end
            end
        end
    end
    
    local AntiBlocktoggle = Tab:AddToggle({
        Name = "BlockReach",
        Default = false,
        Callback = function(Value)
            toggleState = Value
            handleToggle(toggleState)
        end    
    })
    
    Tab:AddSlider({
        Name = "ReachDistance",
        Min = 0,
        Max = 20,
        Default = 20,
        Color = Color3.fromRGB(255,255,255),
        Increment = 0.1,
        ValueName = "Range",
        Callback = function(Value)
            ReachDistance = Value
            if toggleState then
                handleToggle(true)
            end
        end    
    })
    
    Tab:AddToggle({
        Name = "ShowBlockHitbox",
        Default = false,
        Callback = function(Value)
            showHitboxState = Value
            if toggleState then
                handleToggle(true)
            end
        end    
    })
    




spawn(function()
    while true do
        wait(1) 
        if playerCharacter then
            local blockPart = playerCharacter:FindFirstChild("BlockPart")
            if blockPart then
                blockPart.CanCollide = false 
                handleToggle(toggleState)
            end
        end
    end
end)


  
  
    local Section = Tab:AddSection({
        Name = "OtherPhysics"
    })
  
    local isAntiJamEnabled = false
  
    local function updateCollisionState()
        while true do
            if isAntiJamEnabled then
                if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Head") and game:GetService("Players").LocalPlayer.Character.Head.CanCollide then
                    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                        if player ~= game:GetService("Players").LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                            pcall(function()
                                player.Character.Torso.CanCollide = false
                                player.Character.Head.CanCollide = false
                            end)
                        end
                    end
                end
            else
                if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Head") and not game:GetService("Players").LocalPlayer.Character.Head.CanCollide then
                    game:GetService("Players").LocalPlayer.Character.Torso.CanCollide = true
                    game:GetService("Players").LocalPlayer.Character.Head.CanCollide = true
                end
            end
            task.wait()
        end
    end

    Tab:AddToggle({
        Name = "AntiJam",
        Default = false,
        Callback = function(Value)
            isAntiJamEnabled = Value
            print(Value)
        end
    })
  
 
    spawn(updateCollisionState)
  
  
    local removeJumpCooldownConnection
  
    Tab:AddToggle({
        Name = "NoJumpCooldown",
        Default = false,
        Callback = function(Value)
            if Value then
                removeJumpCooldownConnection = userInputService.JumpRequest:Connect(function()
                    if Value then
                        player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                    end
                end)
            else
                if removeJumpCooldownConnection then
                    removeJumpCooldownConnection:Disconnect()
                end
            end
        end    
    })


    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    local playerCharacter = workspace:FindFirstChild(localPlayer.Name)
    local Torso = playerCharacter:FindFirstChild("Torso")
    
    local antiBlockActive = false
    
    local function destroyFFMover()
        while antiBlockActive do
            local ffmover = Torso:FindFirstChild("FFmover")
            if ffmover then
                ffmover:Destroy()
            end
            wait(0.1) 
        end
    end
    
    Tab:AddToggle({
        Name = "AntiBlock",
        Default = false,
        Callback = function(Value)
            antiBlockActive = Value
            if antiBlockActive then
                spawn(destroyFFMover)
            end
        end    
    })
    
  
  
  
    
    local TackleReachToggle = false
  
    Tab:AddToggle({
        Name = "TackleReach",
        Default = false,
        Callback = function(Value)
            TackleReachToggle = Value
    
            
            while TackleReachToggle do
                local args = {
                    [1] = "Game",
                    [2] = "TackleTouch",
                    [3] = "Left Leg",
                    [4] = "Right Leg"
                }
    
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CharacterSoundEvent"):FireServer(unpack(args))
                
                
                wait(0.1)
            end
        end    
    })
    
    
  
 
    
  

  
  
  local Tab = Window:MakeTab({
    Name = "Automatics",
  Icon = "rbxassetid://4483345998",
  PremiumOnly = false
  })
  
  local Players = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))

local Player = Players.LocalPlayer
local autodist = 10
local AS_Enabled = false
local autoswatdist = 30

local function autoCatch()
    while true do
        task.wait()
        local ball = workspace:FindFirstChild("Football")
        if ball and ball.ClassName == "BasePart" then
            local distance = (ball.Position - Player.Character.HumanoidRootPart.Position).Magnitude
            if distance < autodist then
                ReplicatedStorage.Remotes.CharacterSoundEvent:FireServer("PlayerActions", "catch")
                task.wait(1.5)
            end
        end
    end
end

task.spawn(function()
    while task.wait() do
        if AS_Enabled then
            local HRP = Player.Character:FindFirstChild("HumanoidRootPart")
            for _, v in pairs(workspace:GetChildren()) do
                if v.Name == "Football" and v:IsA("BasePart") and ((v.Position - HRP.Position).Magnitude <= autoswatdist) then
                    keypress(0x52)
                    keyrelease(0x52)
                end
            end
        end
    end
end)


local Section = Tab:AddSection({
    Name = "AutoCatch"
})

Tab:AddToggle({
    Name = "Auto Catch",
    Default = false,
    Callback = function(Value)
        if Value then
            autoCatch()
        end
    end
})

Tab:AddSlider({
    Name = "Auto Catch Distance",
    Min = 0,
    Max = 20,
    Default = 10,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Distance",
    Callback = function(Value)
        autodist = Value
    end    
})

local Section = Tab:AddSection({
    Name = "AutoSwat"
})

Tab:AddToggle({
    Name = "Auto Swat",
    Default = false,
    Callback = function(Value)
        AS_Enabled = Value
    end
})



Tab:AddSlider({
    Name = "Auto Swat Distance",
    Min = 0,
    Max = 40,
    Default = 30,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Distance",
    Callback = function(Value)
        autoswatdist = Value
    end    
})

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local TeleportOffset = Vector3.new(0, 3, 0)
local TeleportKey = Enum.KeyCode.P

local JumpTeleportEnabled = false
local MinDistanceThreshold = 50

local function findNearestPlayer()
    local player = Players.LocalPlayer
    local minDistance = math.huge
    local nearestPlayer = nil

    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (otherPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).magnitude
            if distance < minDistance and distance < MinDistanceThreshold then
                minDistance = distance
                nearestPlayer = otherPlayer
            end
        end
    end

    return nearestPlayer
end

local function teleportToNearestPlayerHead()
    local nearestPlayer = findNearestPlayer()
    if nearestPlayer then
        local targetHeadPosition = nearestPlayer.Character.Head.Position
        local humanoidRootPart = Players.LocalPlayer.Character.HumanoidRootPart

        humanoidRootPart.CFrame = CFrame.new(targetHeadPosition + TeleportOffset)
    end
end

local function handleOtherPlayerJumps(player)
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid.StateChanged:Connect(function(oldState, newState)
            if newState == Enum.HumanoidStateType.Jumping and JumpTeleportEnabled then
                teleportToNearestPlayerHead()
            end
        end)
    end
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        handleOtherPlayerJumps(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= Players.LocalPlayer then
        handleOtherPlayerJumps(player)
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == TeleportKey then
        teleportToNearestPlayerHead()
    end
end)

local function updateMinDistanceThreshold(value)
    MinDistanceThreshold = value
end


local Section = Tab:AddSection({
    Name = "AutoJam"
})

Tab:AddToggle({
  Name = "AutoJam",
  Default = false,
  Callback = function(enabled)
      JumpTeleportEnabled = enabled
  end    
})


Tab:AddSlider({
  Name = "Range",
  Min = 0,
  Max = 15,
  Default = 5,
  Color = Color3.fromRGB(255,255,255),
  Increment = 0.1,
  ValueName = "Range",
  Callback = function(value)
      updateMinDistanceThreshold(value)
  end    
})

  
  local Tab = Window:MakeTab({
         Name = "Trolling",
       Icon = "rbxassetid://4483345998",
       PremiumOnly = false
       })
  
  local Section = Tab:AddSection({
      Name = "ClickTackleTP"
  })
  
  local connection
  
  Tab:AddToggle({
      Name = "ClickTackleTP",
      Default = false,
      Callback = function(v)
          if v then
              connection = game:GetService("Players").LocalPlayer:GetMouse().Button1Down:Connect(function()
                  for i, v in pairs(game.workspace:GetDescendants()) do
                      if v.Name == "Football" and v:IsA("Tool") then
                          local toolPosition = v.Parent.HumanoidRootPart.Position
                          local playerPosition = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position
                          if (toolPosition - playerPosition).Magnitude <= tprange then
                              game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.Parent.HumanoidRootPart.CFrame + Vector3.new(1, 1, 1)
                          end
                      end
                  end
              end)
          else
              if connection then
                  connection:Disconnect() 
              end
          end
      end    
  })
  
  Tab:AddSlider({
      Name = "Range",
      Min = 0,
      Max = 15,
      Default = 0,
      Color = Color3.fromRGB(255, 255, 255),
      Increment = 1,
      ValueName = "ClickTackleTpRange",
      Callback = function(v)
          tprange = v
      end    
  })
  
  local Section = Tab:AddSection({
    Name = "Hump"
})

local currentSpeed = 5 

local function findNearestPlayer()
    local P = game:GetService('Players').LocalPlayer
    local nearestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(game:GetService('Players'):GetPlayers()) do
        if player ~= P and player.Character and player.Character:FindFirstChild('HumanoidRootPart') then
            local distance = (player.Character.HumanoidRootPart.Position - P.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestPlayer = player
            end
        end
    end
    return nearestPlayer
end



local function startJumping()
    local A = Instance.new('Animation')
    A.AnimationId = 'rbxassetid://148840371'
    local P = game:GetService('Players').LocalPlayer
    local C = P.Character or P.CharacterAdded:Wait()
    H = C:WaitForChild('Humanoid'):LoadAnimation(A)
    H:Play()
    H:AdjustSpeed(currentSpeed)
    
    _G.running = true
    
    game:GetService('RunService').Stepped:Connect(function()
        if not _G.running then return end
        local nearestPlayer = findNearestPlayer()
        if nearestPlayer and nearestPlayer.Character and nearestPlayer.Character:FindFirstChild('HumanoidRootPart') then
            C:WaitForChild('HumanoidRootPart').CFrame = CFrame.new(nearestPlayer.Character.HumanoidRootPart.Position)
        end
    end)
end

local function stopJumping()
    _G.running = false 
    local P = game:GetService('Players').LocalPlayer
    local C = P.Character or P.CharacterAdded:Wait()
    local H = C:WaitForChild('Humanoid')
    for _, animTrack in pairs(H:GetPlayingAnimationTracks()) do
        animTrack:Stop()
    end
end

Tab:AddToggle({
    Name = "Hump Nearest Player",
    Default = false,
    Callback = function(Value)
        if Value then
            startJumping()
        else
            stopJumping()
        end
    end    
})

Tab:AddSlider({
    Name = "Speed",
    Min = 0,
    Max = 20,
    Default = 5,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        currentSpeed = Value
        if H then
            H:AdjustSpeed(currentSpeed)
        end
        
    end    
})


local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local tackleActive = false
local maxRange = 5 

local function bruteTackle()
    while tackleActive do
        local carrier = ReplicatedStorage.Values.Carrier.Value
        if carrier and carrier:IsDescendantOf(Players) and carrier.Team ~= LocalPlayer.Team then
            local character = LocalPlayer.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            local carrierCharacter = carrier.Character
            local carrierHrp = carrierCharacter and carrierCharacter:FindFirstChild("HumanoidRootPart")

            if hrp and carrierHrp then
                local distance = (hrp.Position - carrierHrp.Position).Magnitude
                if distance <= maxRange then
                    hrp.CFrame = carrierHrp.CFrame * CFrame.new(0, -3, 0) 
                    
                end
            end
        end
        wait(1) 
    end
end

local Section = Tab:AddSection({
    Name = "Brute Tackle"
})

Tab:AddToggle({
	Name = "Brute Tackle",
	Default = false,
	Callback = function(Value)
		tackleActive = Value
        if tackleActive then
            spawn(bruteTackle)
        end
	end    
})

Tab:AddSlider({
	Name = "Max Range",
	Min = 0,
	Max = 25,
	Default = 5,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "studs",
	Callback = function(Value)
		maxRange = Value
		
	end    
})



  
                                             local Tab = Window:MakeTab({
                                             Name = "Other",
                                           Icon = "rbxassetid://4483345998",
                                           PremiumOnly = false
                                           })
  
  
                                            local boostfps = false
                                            local originalMaterials = {}
  
                                            Tab:AddToggle({
                                                Name = "FPS BOOST/LOW GRAPHICS",
                                                Default = false,
                                                Callback = function(Value)
                                                    boostfps = Value
                                                    if Value then
                                                        for i, v in next, workspace:GetDescendants() do
                                                            if v:IsA("Part") and v.Material then
                                                                originalMaterials[v] = v.Material
                                                                v.Material = Enum.Material.SmoothPlastic
                                                            end
                                                        end
                                                    else
                                                        for i, v in next, workspace:GetDescendants() do
                                                            if v:IsA("Part") and originalMaterials[v] then
                                                                v.Material = originalMaterials[v]
                                                                originalMaterials[v] = nil
                                                            end
                                                        end
                                                    end
                                                end
                                            })


  local Section = Tab:AddSection({
	Name = "Anti"
})








Tab:AddToggle({
	Name = "AntiAdmin",
	Default = false,
	Callback = function(state)
        _G.Admin = state
        local moderators = {
            "2618937233503944727",
            "209187780079648778",
            "265544447129812992",
            "677964655821324329",
            "469043698110562304",
            "792145568586792979",
            "490537796940070915",
            "678699048844132362",
            "837514415480897607",
            "417141199564963840",
            "580140563295109148",
            "231225289718497281",
            "719258236930228346",
            "345362950380322829",
            "513196564236468226",
            "241945212463742986",
            "153379470164623360",
            "1170439264"
        }
    
        local players = game:GetService("Players"):GetPlayers()
        for _, player in ipairs(players) do
            if table.find(moderators, player.UserId) and _G.Admin == true then
                player:Kick("Admin Joined TYRANT SAVED YOU WWW")
            end
        end
	end    
})

  

Tab:AddButton({
	Name = "AntiBench",
	Callback = function()
      		    
    local AntiBench = game:GetService("Players").LocalPlayer:FindFirstChild("BenchTag")


    if AntiBench then
        AntiBench:Destroy()
    end


    OrionLib:MakeNotification({
        Name = "AntiBench IS Active",
        Content = "Tyrant ON TOP",
        Image = "rbxassetid://4483345998",
        Time = 3
    })

  	end    
})
  
  
  
  
  local Tab = Window:MakeTab({
      Name = "Custom",
      Icon = "rbxassetid://4483345998",
      PremiumOnly = false
  })
  
  local Section = Tab:AddSection({
      Name = "ZYRO"
  })
  
  Tab:AddToggle({
      Name = "ZyroConfig",
      Default = false,
      Callback = function(Value)
          magEnabled = Value
          if Value then
            
            OrionLib:MakeNotification({
                Name = "ZyroConfig",
                Content = "ZyroConfig Hes Been Loaded And Ready To Go!!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })


            magtoggle:Set(true)
            magslider:Set(13)
            delaytoggle:Set(true)
            delayslider:Set(0.1)
            jptoggle:Set(true)
            jpslider:Set(50.4)
            AntiBlocktoggle:Set(true)
           
            swattoggle:Set(true)


        

            

            local AntiBench = game:GetService("Players").LocalPlayer:FindFirstChild("BenchTag")

           
            if AntiBench then
                AntiBench:Destroy()
            end

         

          else
   
            magtoggle:Set(false)
            magslider:Set(0)
            delaytoggle:Set(false)
            delayslider:Set(0)
            jptoggle:Set(false)
            jpslider:Set(50)
            AntiBlocktoggle:Set(false)
            swattoggle:Set(false)




          end
      end    
  })
  

  
  local Section = Tab:AddSection({
      Name = "Kronxx"
  })
  
  Tab:AddToggle({
      Name = "KronxxMainLeague",
      Default = false,
      Callback = function(Value)
          magEnabled = Value
          if Value then
              customDistance = 5
              magnetDelay = 0.1
              magnetDelayEnabled = true
                  game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = 20.3
                  game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = 52
                  swatDistance = 25  
                  initCharacter(player.Character)
          else
              customDistance = 0
              magnetDelay = 0
              magnetDelayEnabled = false
                  game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = 20
                  game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = 50
                  swatDistance = 1  
                  initCharacter(player.Character)
          end
      end    
  })
  
  Tab:AddToggle({
      Name = "KronxxSideLeague",
      Default = false,
      Callback = function(Value)
          magEnabled = Value
          if Value then
              customDistance = 14
              magnetDelay = 0.1
              magnetDelayEnabled = true
                  game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = 20.3
                  game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = 53
                  swatDistance = 25  
                  initCharacter(player.Character)
          else
              customDistance = 0
              magnetDelay = 0
              magnetDelayEnabled = false
                  game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = 20
                  game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = 50
                  swatDistance = 1 
                  initCharacter(player.Character)
          end
      end    
  })
  
  
  local Section = Tab:AddSection({
      Name = "Zen"
  })
  
  Tab:AddToggle({
      Name = "ZenBlatant",
      Default = false,
      Callback = function(Value)
        magEnabled = Value
        if Value then
          
          OrionLib:MakeNotification({
              Name = "ZenConfig",
              Content = "ZenBlatant Hes Been Loaded And Ready To Go!!",
              Image = "rbxassetid://4483345998",
              Time = 3
          })


          magtoggle:Set(true)
          magslider:Set(25)
          delaytoggle:Set(false)
          jptoggle:Set(true)
          jpslider:Set(53)
          wstoggle:Set(true)
          wsslider:Set(20.5)
          swattoggle:Set(true)


      

          

       

        else
 
          magtoggle:Set(false)
          magslider:Set(0)
          delaytoggle:Set(false)
          delayslider:Set(0)
          jptoggle:Set(false)
          jpslider:Set(50)
          swattoggle:Set(false)




        end
      end    
  })
  
  Tab:AddToggle({
      Name = "ZenLeague",
      Default = false,
      Callback = function(Value)
        magEnabled = Value
        if Value then
          
          OrionLib:MakeNotification({
              Name = "ZenConfig",
              Content = "ZenLeague Hes Been Loaded And Ready To Go!!",
              Image = "rbxassetid://4483345998",
              Time = 3
          })


          magtoggle:Set(true)
          magslider:Set(10)
          delaytoggle:Set(false)
          jptoggle:Set(true)
          jpslider:Set(53)
          wstoggle:Set(true)
          wsslider:Set(20.3)
          swattoggle:Set(true)


      

          

       

        else
 
          magtoggle:Set(false)
          magslider:Set(0)
          delaytoggle:Set(false)
          delayslider:Set(0)
          jptoggle:Set(false)
          jpslider:Set(50)
          swattoggle:Set(false)




        end
      end    
  })


