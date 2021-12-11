local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/kav"))()
local Window = Library.CreateLib("Floppa Hub - Work At A Pizza Place", "BloodTheme")
local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("Farming")

local players = game:GetService("Players")
local client = players.LocalPlayer

local playerChar = client.Character or client.Character:Wait()

local function FindFirstCustomer()
    for _, customer in pairs(workspace.Customers:GetChildren()) do
        if customer:FindFirstChild("Head") and customer:FindFirstChild("Humanoid") and customer.Head.CFrame.Z < 100 then
            return c
        end
    end
end

local flags = {}
function flags:SetFlag(name, value)
    flags[name] = value
end
local ffc = game.FindFirstChild
local function getHousePart(address)
    local houses = workspace.Houses:GetChildren()
    for i = 1, #houses do
        local h = houses[i]
        if
            ffc(h, "Address") and h.Address.Value == address and ffc(h, "Upgrades") and h.Upgrades:GetChildren()[1] and
                ffc(h.Upgrades:GetChildren()[1], "GivePizza")
         then
            return h.Upgrades:GetChildren()[1].GivePizza
        end
    end
end

Section:NewToggle(
    "Auto Delivery",
    "ToggleInfo",
    function(bool)
        task.spawn(
            function()
                _G.deliveryToggle = bool
                while _G.deliveryToggle do
                    wait()
                    for _, child in pairs(game.Workspace:GetChildren()) do
                        if child:IsA("Tool") and child:FindFirstChild("House") then
                            local childCf = child.Handle.CFrame
                            playerChar.HumanoidRootPart.CFrame = childCf
                            game.Players.LocalPlayer.Character.ChildAdded:Connect(
                                function(item)
                                    if item:findFirstChild("House") then
                                        local house = item.House.Value
                                        local door = house:GetDescendants()
                                        for i = 1, #door do
                                            if door[i].Name == "GivePizza" then
                                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                                                    door[i].CFrame
                                            end
                                        end
                                    end
                                end
                            )
                            game.Players.LocalPlayer.Backpack.ChildAdded:Connect(
                                function(item)
                                    if item:FindFirstChild("House") then
                                        item:EquipTool()
                                    end
                                end
                            )
                        end
                    end
                end
            end
        )

        flags:SetFlag("autoDelivery", value)
    end
)
