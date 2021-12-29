--First define the library
local Library = loadstring(game:HttpGet("https://pastebin.com/raw/4AtpQ0W0", true))()
--To close/open the UI (after it's been initialized) use Library:Close() to toggle it, use the keybind option to quickly make a toggle for it without hassle (there is an example below)

-- ORIGINAL PASTEBIN: https://pastebin.com/raw/4AtpQ0W0

local MainWindow = Library:CreateWindow "Floppa Hub"

local AudioLag = false
local LoopSkipping = false
local AutoDJ = false
local scrubValue = nil

for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "ScreenGui" then
        v:Destroy()
    end
end

game:GetService("Players").LocalPlayer.Functions.SetTextNotification:Fire(
    "FLOPPA HUB HAS LOADED! ENJOY THE SCRIPT! - Death_Blows",
    10
)

--- @type Sound
local Audio = game:GetService("Workspace")["GLOBAL_SOUND"]
local Main = MainWindow:AddFolder("Main")

local ConnectionEnum = {
    GetDJ = 6,
    AddSong = 4,
    SearchSong = 2
}

Main:AddToggle(
    {
        text = "Make Audio Lag",
        flag = "toggle",
        state = false,
        callback = function(a)
            AudioLag = a
            print(a)
        end
    }
)
Main:AddToggle(
    {
        text = "Loop Skip",
        flag = "toggle",
        state = false,
        callback = function(b)
            LoopSkipping = b
            task.spawn(
                function()
                    while LoopSkipping and task.wait() do
                        local djText = game:GetService("Workspace").DJBar.SurfaceGui.Container.TimeLeft.Text
                        local splitted = djText:split("DJ: ")[2]
                        local currentDj = splitted:split(" -")[1]

                        if currentDj == game.Players.LocalPlayer.Name then
                            return
                        end

                        local ab = Audio.TimeLength
                        Audio.TimePosition = ab
                        task.wait(0.2)
                        Audio.TimePosition = 0
                    end
                end
            )
        end
    }
)
Main:AddToggle(
    {
        text = "Auto DJ",
        flag = "toggle",
        state = false,
        callback = function(c)
            AutoDJ = c
            print(c)
        end
    }
)
local scrubber
scrubber =
    Main:AddSlider(
    {
        text = "Scrub song",
        flag = "slider",
        callback = function(val)
            task.wait(0.1)
            if val == Audio.TimeLength then
                scrubber:SetValue(1)
            end
            Audio.TimePosition = val
        end,
        min = 0,
        max = Audio.TimeLength,
        value = Audio.TimePosition
    }
)

local lbl =
    Main:AddLabel(
    {
        text = "Current Position" .. tostring(Audio.TimePosition)
    }
)

Main:AddButton(
    {
        text = "Skip",
        flag = "button",
        callback = function()
            Audio.TimePosition = Audio.TimeLength + 1
        end
    }
)
Main:AddButton(
    {
        text = "Nuke",
        flag = "button",
        callback = function()
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                "[BOT] Nuke initialized. Created by Death_Blows. Use Floppa Hub!",
                "All"
            )
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                "[BOT] Nuke initialized. Created by Death_Blows. Use Floppa Hub!",
                "All"
            )
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                "[BOT] Nuke initialized. Created by Death_Blows. Use Floppa Hub!",
                "All"
            )
            local testArray = {
                "1/5 votes for the nuke!",
                "2/5 votes for the nuke!",
                "3/5 votes for the nuke!",
                "4/5 votes for the nuke!",
                "5/5 votes, starting nuke."
            }
            local active = true

            coroutine.wrap(
                function()
                    while task.wait(5) do
                        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                            "This server will be nuked! Type !nuke to nuke it!!!This server will be nuked! Type !nuke to nuke it!!!This server will be nuked! Type !nuke to nuke it!!! Type !nuke to nuke it!!!",
                            "All"
                        )
                        if not active then
                            coroutine.yield()
                        end
                    end
                end
            )()

            local alreadyVoted = {}

            game.Players.PlayerChatted:Connect(
                function(_, player, msg)
                    if msg == "!nuke" then
                        local playerName = player.Name
                        if (alreadyVoted[playerName]) then
                            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                                "Hey " .. playerName .. ", you've already voted you noob!",
                                "All"
                            )
                            return
                        else
                            alreadyVoted[playerName] = playerName
                        end

                        local A_1 = (testArray[1])
                        local A_2 = "All"
                        local Event = game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest
                        Event:FireServer(A_1, A_2)
                        table.remove(testArray, 1)

                        if #testArray == 0 then
                            game:GetService("RunService").Heartbeat:Connect(
                                function()
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                                        CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position) *
                                        CFrame.Angles(0, math.rad(180), 0)
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                                        CFrame.new(
                                        27.7239628,
                                        10.0660343,
                                        67.0371628,
                                        0.999975085,
                                        -0.00207312847,
                                        0.00674481038,
                                        -0.000199317801,
                                        0.947186291,
                                        0.320683837,
                                        -0.00705341063,
                                        -0.320677191,
                                        0.947162271
                                    )

                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                                        CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position) *
                                        CFrame.Angles(0, math.rad(180), 0)

                                    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                                        "SERVER NUKED BY FLOPPA HUB",
                                        "All"
                                    )

                                    task.wait()
                                    game:GetService("Workspace")["GLOBAL_SOUND"].TimePosition = math.random(1, 100)
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                                        CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position) *
                                        CFrame.Angles(0, math.rad(180), 0)
                                end
                            )
                        end
                    end
                end
            )
        end
    }
)

local SongUtilFolder = MainWindow:AddFolder("Song Utils")

SongUtilFolder:AddBox(
    {
        text = "Search song and add",
        flag = "box",
        callback = function(v)
            local songs = {}
            if v:gsub("^%s*(.-)%s*$", "%1") == "" then
                return
            end
            local result = game:GetService("ReplicatedStorage").Connection:InvokeServer(2, v)
            for i, v in ipairs(result) do
                if type(v) == "table" then
                    songs[i] = v
                end
            end
            local randomSong = songs[math.random(1, #songs)]
            print(randomSong.SoundId)
            game:GetService("ReplicatedStorage").Connection:InvokeServer(4, randomSong.SoundId)
        end
    }
)

local function roundNumber(num, div)
    div = div or 1
    return (math.floor((num / div) + 0.5) * div)
end

Library:Init()
task.spawn(
    function()
        game:GetService("RunService").Heartbeat:Connect(
            function()
                Audio = game:GetService("Workspace")["GLOBAL_SOUND"]
                if AutoDJ then
                    local A_1 = 6
                    local Event = game:GetService("ReplicatedStorage").Connection
                    Event:InvokeServer(A_1)
                end
                if AudioLag then
                    game:GetService("Workspace")["GLOBAL_SOUND"].TimePosition = math.random(1, 100)
                end
                if not Audio.IsLoaded then
                    scrubber:SetValue(1)
                end
                scrubber.max = Audio.TimeLength
                lbl.Text = "Current Position: " .. tostring(roundNumber(Audio.TimePosition))
            end
        )
    end
)
