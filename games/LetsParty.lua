local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/kav"))()
local Window = Library.CreateLib("Floppa Hub - Lets Party", "BloodTheme")

local runService = game:GetService("RunService")
local players = game:GetService("Players")

local localPlayer = players.LocalPlayer
local playerChar = localPlayer.Character or localPlayer.Character:Wait()

local flags = {}

function flags:SetFlag(name, value)
    flags[name] = value
end

local rawMetatable = getrawmetatable(game)
setreadonly(rawMetatable, false)

local oldIndex = rawMetatable.__index

setreadonly(rawMetatable, false)

rawMetatable.__index =
    newcclosure(
    function(self, key)
        if tostring(self) == "Humanoid" and (key == "Walkspeed" or key == "JumpPower") then
            return nil
        end
        return oldIndex(self, key)
    end
)

setreadonly(rawMetatable, true)

local mainTab = Window:NewTab("Main")
do
    local giversSection = mainTab:NewSection("Givers")
    do
        giversSection:NewButton(
            "Give F3X",
            "Gives you F3X tools",
            function()
                task.spawn(
                    function()
                        local hrp = localPlayer.Character.HumanoidRootPart

                        for _, v in pairs(game:GetService("Workspace").SafePlate:GetDescendants()) do
                            if v.Name == "Bar" then
                                local barCf = v.CFrame
                                local oldCf = hrp.CFrame

                                hrp.CFrame = barCf + Vector3.new(-3, 0, 0)
                                task.wait(0.5)
                                hrp.CFrame = oldCf
                            end
                        end
                    end
                )
            end
        )
        giversSection:NewDropdown(
            "Give Gear",
            "Gives you a gear with the dropdown",
            {"Magic Carpet"},
            function(selected)
                task.spawn(
                    function()
                        if selected == "Magic Carpet" then
                            local magicCarpet =
                                game:GetService("Workspace")["made by FoxBinMK4"].Model.Dispenser.Dispenser.Buttons.Powerup[
                                "Golden Magic Carpet"
                            ]
                            local dropPoint =
                                game:GetService("Workspace")["made by FoxBinMK4"].Model.Dispenser.Dispenser.DropPoint1
                            local oldCf = playerChar.HumanoidRootPart.CFrame

                            playerChar.HumanoidRootPart.CFrame = magicCarpet.CFrame
                            task.wait(0.1)
                            fireclickdetector(magicCarpet.ClickDetector, math.huge)
                            task.wait(1)
                            playerChar.HumanoidRootPart.CFrame = oldCf
                        end
                    end
                )
            end
        )
    end
    local playerSection = mainTab:NewSection("Player")
    do
        playerSection:NewSlider(
            "WalkSpeed",
            "Walkspeed changer",
            500,
            16,
            function(v)
                playerChar.Humanoid.WalkSpeed = v
            end
        )
        playerSection:NewSlider(
            "JumpPower",
            "JumpPower changer",
            500,
            50,
            function(v)
                playerChar.Humanoid.JumpPower = v
            end
        )
        playerSection:NewToggle(
            "Click TP",
            "Click TP",
            function(bool)
                flags:SetFlag("clickTp", bool)
            end
        )
        playerSection:NewKeybind(
            "Click TP Bind",
            "Click TP Bind lol",
            Enum.KeyCode.F,
            function()
                local mouse = localPlayer:GetMouse()
                if flags.clickTp then
                    playerChar.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0, 5, 0))
                end
            end
        )
    end
    local teleportsSection = mainTab:NewSection("Teleports")
    do
        teleportsSection:NewDropdown(
            "Teleports",
            "Teleport to a place",
            {"ID Giver", "Giver 1", "Giver 2", "Giver 3", "Giver 4", "Giver 5"},
            function(value)
                if value == "ID Giver" then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                        CFrame.new(
                        -453.09375,
                        3.19999933,
                        -110.969109,
                        0.999964535,
                        0,
                        -0.00842310488,
                        0,
                        1,
                        0,
                        0.00842310488,
                        0,
                        0.999964535
                    )
                end
                if value == "Giver 1" then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                        CFrame.new(
                        -90.2027969,
                        3.19999933,
                        -112.912003,
                        0.138957351,
                        -8.52711608e-08,
                        -0.99029839,
                        9.04618815e-08,
                        1,
                        -7.34130481e-08,
                        0.99029839,
                        -7.93829713e-08,
                        0.138957351
                    )
                end
                if value == "Giver 2" then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                        CFrame.new(
                        -152.011124,
                        3.19999933,
                        -117.632446,
                        0.999375761,
                        -4.91843224e-08,
                        -0.0353276134,
                        4.70897987e-08,
                        1,
                        -6.01206054e-08,
                        0.0353276134,
                        5.84195092e-08,
                        0.999375761
                    )
                end
                if value == "Giver 3" then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                        CFrame.new(
                        -235.153366,
                        3.19999933,
                        -111.911964,
                        0.767343342,
                        0,
                        -0.641236484,
                        0,
                        1,
                        0,
                        0.641236484,
                        0,
                        0.767343342
                    )
                end
                if value == "Giver 4" then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                        CFrame.new(
                        -315.649689,
                        3.19999933,
                        -109.911896,
                        0.961304545,
                        0,
                        -0.27548784,
                        0,
                        1,
                        0,
                        0.27548784,
                        0,
                        0.961304545
                    )
                end
                if value == "Giver 5" then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                        CFrame.new(
                        -396.297302,
                        3.19999933,
                        -113.119431,
                        0.972505867,
                        0,
                        0.232878312,
                        0,
                        1,
                        0,
                        -0.232878312,
                        0,
                        0.972505867
                    )
                end
            end
        )
    end

    local miscSection = mainTab:NewSection("Miscellaneous")
    do
        miscSection:NewButton(
            "Equip all tools",
            "Equips all your tools",
            function()
                for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    v.Parent = game.Players.LocalPlayer.Character
                end
            end
        )
    end
end

-- ID giver game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-453.09375, 3.19999933, -110.969109, 0.999964535, 0, -0.00842310488, 0, 1, 0, 0.00842310488, 0, 0.999964535)
-- Giver 5 game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-396.297302, 3.19999933, -113.119431, 0.972505867, 0, 0.232878312, 0, 1, 0, -0.232878312, 0, 0.972505867)
-- Giver 4 game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-315.649689, 3.19999933, -109.911896, 0.961304545, 0, -0.27548784, 0, 1, 0, 0.27548784, 0, 0.961304545)
-- Giver 3 game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-235.153366, 3.19999933, -111.911964, 0.767343342, 0, -0.641236484, 0, 1, 0, 0.641236484, 0, 0.767343342)
-- Giver 2 game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-152.011124, 3.19999933, -117.632446, 0.999375761, -4.91843224e-08, -0.0353276134, 4.70897987e-08, 1, -6.01206054e-08, 0.0353276134, 5.84195092e-08, 0.999375761)
-- Giver 1 game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-90.2027969, 3.19999933, -112.912003, 0.138957351, -8.52711608e-08, -0.99029839, 9.04618815e-08, 1, -7.34130481e-08, 0.99029839, -7.93829713e-08, 0.138957351)

playerChar.Humanoid.Died:Connect(
    function()
        playerChar = game.Players.LocalPlayer.Character
        localPlayer = game.Players.LocalPlayer
    end
)
