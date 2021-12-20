local Flux = loadstring(game:HttpGet "https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/fluxlib.txt")()

local win = Flux:Window("Floppa Hub", "Floppys Playtime", Color3.fromRGB(255, 110, 48), Enum.KeyCode.LeftControl)
local tab = win:Tab("Main", "http://www.roblox.com/asset/?id=6023426915")

tab:Button(
    "Win",
    "Just win lol",
    function()
        repeat
            task.wait()
        until game:IsLoaded()
        local currentWins = game:GetService("Players").LocalPlayer.leaderstats.Wins.Value
        repeat
            task.wait()
        until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart", true)
        firetouchinterest(
            game.Players.LocalPlayer.Character.HumanoidRootPart,
            game:GetService("Workspace").Events.Triggers.BeatChapter,
            0
        )
        firetouchinterest(
            game.Players.LocalPlayer.Character.HumanoidRootPart,
            game:GetService("Workspace").Events.Triggers.BeatChapter,
            1
        )
        repeat
            task.wait()
        until currentWins ~= game:GetService("Players").LocalPlayer.leaderstats.Wins.Value
    end
)
win:Tab("Tab 2", "http://www.roblox.com/asset/?id=6022668888")
