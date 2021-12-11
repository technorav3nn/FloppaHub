local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/kav"))()
local Window = Library.CreateLib("Floppa Hub - Da Hood", "BloodTheme")

local runService = game:GetService("RunService")
local players = game:GetService("Players")

local localPlayer = players.LocalPlayer
local playerChar = localPlayer.Character or localPlayer.Character:Wait()

local flags = {}

function flags:SetFlag(name, value)
    flags[name] = value
end

for i, v in pairs(workspace:GetDescendants()) do
    if v:IsA("Seat") then
        v:Destroy()
    end
end

local mt = getrawmetatable(game)
setreadonly(mt, false)

local oldNameCall = mt.__namecall

mt.__namecall =
    newcclosure(
    function(...)
        local method = getnamecallmethod()
        local args = {...}
        if method == "FireServer" then
            local remote = tostring(args[1])
            if remote == "MainEvent" then
                if
                    args[2] == "TeleportDetect" or args[2] == "TeleportDetect" or args[2] == "CHECKER" or
                        args[2] == "OneMoreTime"
                 then
                    return nil
                end
            end
        end

        return oldNameCall(...)
    end
)

local farmingTab = Window:NewTab("Farming")
local farmingSec = farmingTab:NewSection("Main")
do
    farmingSec:NewToggle(
        "Auto Hosptial Job",
        "Auto farms at the Hosptial Job",
        function(bool)
            flags:SetFlag("autoHosptial", bool)
        end
    )
    farmingSec:NewToggle(
        "Auto Shoe Job",
        "Auto farms at the Shoe Job",
        function(bool)
            flags:SetFlag("autoShoe", bool)
        end
    )
    farmingSec:NewToggle(
        "Auto Rob",
        "Auto Robs ATMs and Registers",
        function(bool)
            -- Credit to Ammnesia for the autofarm
            task.spawn(
                function()
                    local LocalPlayer = game:GetService("Players").LocalPlayer

                    function gettarget()
                        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:wait()
                        local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
                        local maxdistance = math.huge
                        local target
                        for i, v in pairs(game:GetService("Workspace").Cashiers:GetChildren()) do
                            if v:FindFirstChild("Head") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                local distance = (HumanoidRootPart.Position - v.Head.Position).magnitude
                                if distance < maxdistance then
                                    target = v
                                    maxdistance = distance
                                end
                            end
                        end
                        return target
                    end

                    shared.MoneyFarm = bool

                    while shared.MoneyFarm do
                        wait()
                        local Target = gettarget()
                        repeat
                            wait()
                            pcall(
                                function()
                                    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:wait()
                                    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
                                    local Combat =
                                        LocalPlayer.Backpack:FindFirstChild("Combat") or
                                        Character:FindFirstChild("Combat")
                                    if not Combat then
                                        Character:FindFirstChild("Humanoid").Health = 0
                                        return
                                    end
                                    HumanoidRootPart.CFrame = Target.Head.CFrame * CFrame.new(1, -0.7, 3)
                                    Combat.Parent = Character
                                    Combat:Activate()
                                end
                            )
                        until not Target or Target.Humanoid.Health < 0
                        for i, v in pairs(game:GetService("Workspace").Ignored.Drop:GetDescendants()) do
                            if v:IsA("ClickDetector") and v.Parent and v.Parent.Name:find("Money") then
                                local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:wait()
                                local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
                                if (v.Parent.Position - HumanoidRootPart.Position).magnitude <= 18 then
                                    repeat
                                        wait()
                                        fireclickdetector(v)
                                    until not v or not v.Parent.Parent
                                end
                            end
                        end
                        wait(0.6)
                    end
                end
            )
        end
    )
end

runService.Heartbeat:Connect(
    function()
        if flags.autoHosptial then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(112, 25, -479)
            wait(0.3)
            local hospitalJob = game:GetService("Workspace").Ignored.HospitalJob

            local clickDetectors = {
                ["Green"] = game:GetService("Workspace").Ignored.HospitalJob.Green,
                ["Red"] = game:GetService("Workspace").Ignored.HospitalJob.Red,
                ["Blue"] = game:GetService("Workspace").Ignored.HospitalJob.Blue
            }

            for _, v in pairs(hospitalJob:GetChildren()) do
                if string.find(v.Name, "Can") then
                    local chosen
                    if string.find(v.Name, "Red") then
                        chosen = "Red"
                    end
                    if string.find(v.Name, "Blue") then
                        chosen = "Blue"
                    end
                    if string.find(v.Name, "Green") then
                        chosen = "Green"
                    end
                    fireclickdetector(clickDetectors[chosen].ClickDetector, 0)
                    task.wait()
                    fireclickdetector(
                        game:GetService("Workspace").Ignored.HospitalJob:FindFirstChildOfClass("Model").ClickDetector,
                        0
                    )
                end
            end
        end
        if flags.autoShoe then
            local shoeAmount = 0
            local untilSell = 10

            local kicksPath = game:GetService("Workspace").MAP.Map["hood kicks"]
            local drops = game:GetService("Workspace").Ignored.Drop
            local sellPath =
                game:GetService("Workspace").Ignored["Clean the shoes on the floor and come to me for cash"]

            repeat
                if not flags.autoShoe then
                    break
                end
                task.wait()
                for _, drop in pairs(drops:GetChildren()) do
                    if drop:IsA("MeshPart") then
                        local dropCd = drop.ClickDetector
                        playerChar.HumanoidRootPart.CFrame = drop.CFrame
                        task.wait(0.2)
                        fireclickdetector(dropCd, 0)
                        shoeAmount = shoeAmount + 1
                    end
                end
            until shoeAmount == untilSell
            if shoeAmount == untilSell then
                local sellCd = sellPath.ClickDetector
                task.wait(0.3)
                playerChar.HumanoidRootPart.CFrame = sellPath.HumanoidRootPart.CFrame
                task.wait(0.3)
                fireclickdetector(sellCd, 0)
                shoeAmount = 0
            end
        end
    end
)
