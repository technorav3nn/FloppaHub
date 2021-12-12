-- // Libraries
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/uwuware-ui/main/main.lua"))()
local EspLibrary = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()

-- // Destroy excess GUIS
for _, v in ipairs(game.CoreGui:GetChildren()) do
    if v.Name == "ScreenGui" then
        v:Destroy()
    end
end

-- // Carts and Cart spawners
local cartPaths = {}
for _, v in ipairs(game.Workspace:GetChildren()) do
    if v.Name == "Carts" and v:IsA("Folder") then
        table.insert(cartPaths, v)
    end
end

local allCarts, cartSpawners = unpack(cartPaths)

-- // Services
local players = game:GetService("Players")
local runService = game:GetService("RunService")

-- // Variables
local localPlayer = players.LocalPlayer
local playerChar = localPlayer.Character or localPlayer.Character:Wait()

-- // UI Components
local window = Library:CreateWindow("Floppa Hub - CRIRD")
local mainFolder = window:AddFolder("Main")

-- // ESP Object Listener for carts
EspLibrary:AddObjectListener(
    allCarts,
    {
        Color = Color3.new(1, 0, 0),
        Type = "Model",
        PrimaryPart = function(obj)
            local hrp = obj:FindFirstChild("On")
            return hrp
        end,
        CustomName = function(obj)
            return obj.Name
        end,
        IsEnabled = "Carts"
    }
)

do
    mainFolder:AddToggle(
        {
            text = "Spam Speed Up Carts",
            flag = "spamSpeed",
            callback = function()
                task.spawn(
                    function()
                        while Library.flags.spamSpeed and task.wait(0.1) do
                            for _, descendant in pairs(allCarts:GetDescendants()) do
                                if descendant:IsA("ClickDetector") and descendant.Parent.Name == "Up" then
                                    fireclickdetector(descendant, math.huge)
                                end
                            end
                        end
                    end
                )
            end
        }
    )
    mainFolder:AddToggle(
        {
            text = "Spam Slow Down Carts",
            flag = "spamSlow",
            callback = function()
                task.spawn(
                    function()
                        while Library.flags.spamSlow and task.wait(0.1) do
                            for _, descendant in pairs(allCarts:GetDescendants()) do
                                if descendant:IsA("ClickDetector") and descendant.Parent.Name == "Down" then
                                    fireclickdetector(descendant, math.huge)
                                end
                            end
                        end
                    end
                )
            end
        }
    )
    mainFolder:AddToggle(
        {
            text = "Spam Toggle Carts",
            flag = "spamToggle",
            callback = function()
                task.spawn(
                    function()
                        while Library.flags.spamToggle and task.wait(0.1) do
                            for _, descendant in pairs(allCarts:GetDescendants()) do
                                if descendant:IsA("ClickDetector") and descendant.Parent.Name == "On" then
                                    fireclickdetector(descendant, math.huge)
                                end
                            end
                        end
                    end
                )
            end
        }
    )
    mainFolder:AddToggle(
        {
            text = "Spam Cart Spawners",
            flag = "spamSpawn",
            callback = function()
                task.spawn(
                    function()
                        while Library.flags.spamSpawn and task.wait(0.1) do
                            --- @type Instance
                            for _, spawner in pairs(cartSpawners:GetChildren()) do
                                if spawner:IsA("BasePart") and spawner:FindFirstChildWhichIsA("ClickDetector") then
                                    fireclickdetector(spawner.Click, math.huge)
                                end
                            end
                        end
                    end
                )
            end
        }
    )
    mainFolder:AddButton(
        {
            text = "Turn On All Carts",
            callback = function()
                for _, cart in pairs(allCarts:GetChildren()) do
                    if cart:IsA("Model") and string.find(cart.Name, "Cart") then
                        local cartConfig = cart.Configuration
                        local isCartOn = cartConfig.CarOn.Value and true or false
                        if not isCartOn then
                            fireclickdetector(cart.On.Click, math.huge)
                        end
                    end
                end
            end
        }
    )
    mainFolder:AddButton(
        {
            text = "Turn Off All Carts",
            callback = function()
                for _, cart in pairs(allCarts:GetChildren()) do
                    if cart:IsA("Model") and string.find(cart.Name, "Cart") then
                        local cartConfig = cart.Configuration
                        local isCartOn = cartConfig.CarOn.Value and true or false
                        if isCartOn then
                            fireclickdetector(cart.On.Click, math.huge)
                        end
                    end
                end
            end
        }
    )
end

local playerFolder = window:AddFolder("Player")
do
    playerFolder:AddToggle(
        {
            text = "Click TP",
            flag = "clickTp"
        }
    )
    playerFolder:AddBind(
        {
            text = "Click TP Bind",
            key = Enum.KeyCode.F,
            callback = function()
                local mouse = localPlayer:GetMouse()
                if Library.flags.clickTp then
                    playerChar.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0, 5, 0))
                end
            end
        }
    )
    playerFolder:AddDivider()
    playerFolder:AddSlider(
        {
            text = "WalkSpeed",
            min = 16,
            max = 400,
            default = 16,
            callback = function(v)
                playerChar.Humanoid.WalkSpeed = v
            end
        }
    )

    playerFolder:AddSlider(
        {
            text = "JumpPower",
            min = 50,
            max = 400,
            default = 50,
            callback = function(v)
                playerChar.Humanoid.JumpPower = v
            end
        }
    )
end

EspLibrary:Toggle(false)
EspLibrary.Players = false

local visualsFolder = window:AddFolder("Visuals")
do
    visualsFolder:AddToggle(
        {
            text = "Player ESP",
            callback = function(bool)
                EspLibrary:Toggle(true)
                EspLibrary.Players = bool
            end
        }
    )
    visualsFolder:AddToggle(
        {
            text = "Cart ESP",
            callback = function(bool)
                EspLibrary:Toggle(true)
                EspLibrary.Carts = bool
            end
        }
    )
end

Library:Init()
