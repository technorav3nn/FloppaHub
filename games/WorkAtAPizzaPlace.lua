local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/kav"))()
local Window = Library.CreateLib("Floppa Hub - Work At A Pizza Place", "BloodTheme")
local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("Farming")

local players = game:GetService("Players")
local client = players.LocalPlayer

local playerChar = client.Character or client.Character:Wait()

local flags = {}
function flags:SetFlag(name, value)
    flags[name] = value
end

local houses = game:GetService("Workspace").Houses

local boxes = {}

local function tpBack()
    task.wait(1)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(63, 7, -9)
end

local function getPizzaBox(box)
    if box:IsA("Tool") and box:FindFirstChild("House") then
        local boxCf = box.Handle.CFrame
        playerChar.HumanoidRootPart.CFrame = boxCf + Vector3.new(0, 3, 0)
        task.wait(0.3)
    end
end

local function populatePizzaBoxes()
    for _, v in pairs(client.Backpack:GetChildren()) do
        if v:FindFirstChild("House") then
            table.insert(boxes, v)
        end
    end
    for _, v in pairs(playerChar:GetChildren()) do
        if v:FindFirstChild("House") then
            table.insert(boxes, v)
        end
    end
end

local function deliverPizzaToHouse(address)
    for _, v in pairs(houses:GetChildren()) do
        if v.Address.Value == address then
            local housePart = v.Upgrades:GetChildren()[1]:FindFirstChild("GivePizza")
            if housePart then
                local tool = client.Backpack:FindFirstChild(address)
                if tool then
                    playerChar.Humanoid:EquipTool(tool)
                end
                task.wait()
                playerChar.HumanoidRootPart.CFrame = housePart.CFrame
                task.wait(5)
            end
        end
    end
end

Section:NewToggle(
    "Auto Delivery",
    "ToggleInfo",
    function(bool)
        flags:SetFlag("autoDelivery", bool)
        if flags.autoDelivery then
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v:FindFirstChild("House") then
                    getPizzaBox(v)
                end
            end

            populatePizzaBoxes()
            if #boxes == 0 then
                tpBack()
            end

            for _, pizza in ipairs(boxes) do
                deliverPizzaToHouse(pizza.Name)
            end
            game.Workspace.ChildAdded:Connect(
                function(child)
                    if child:FindFirstChild("House") and flags.autoDelivery then
                        getPizzaBox(child)
                        populatePizzaBoxes()
                        deliverPizzaToHouse(child.Name)
                    end
                end
            )
        end
    end
)
