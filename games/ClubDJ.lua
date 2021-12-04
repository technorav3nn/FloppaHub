--First define the library
local Library = loadstring(game:HttpGet("https://pastebin.com/raw/4AtpQ0W0", true))()
--To close/open the UI (after it's been initialized) use Library:Close() to toggle it, use the keybind option to quickly make a toggle for it without hassle (there is an example below)

-- ORIGINAL PASTEBIN: https://pastebin.com/raw/4AtpQ0W0

local MainWindow = Library:CreateWindow "Floppa Hub"

local AudioLag = false
local LoopSkipping = false
local AutoDJ = false

for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "ScreenGui" then
        v:Destroy()
    end
end

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
            while wait() do
                if LoopSkipping then
                    local djText = game:GetService("Workspace").DJBar.SurfaceGui.Container.TimeLeft.Text
                    local splitted = thetext:split("DJ: ")[2]
                    local currentDj = splitted:split(" -")[1]

                    if currentDj == game.Players.LocalPlayer.Name then
                        return
                    end

                    local ab = Audio.TimeLength
                    Audio.TimePosition = ab
                    wait(0.2)
                    Audio.TimePosition = 0
                end
            end
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
Main:AddSlider(
    {
        text = "Scrub song",
        flag = "slider",
        callback = function(val)
            wait(0.1)
            Audio.TimePosition = val
        end,
        min = 0,
        max = Audio.TimeLength,
        value = Audio.TimePosition
    }
)
Main:AddButton(
    {
        text = "Skip",
        flag = "button",
        callback = function()
            print "pressed"
        end
    }
)
Main:AddButton(
    {
        text = "Nuke",
        flag = "button",
        callback = function()
            local testArray = {
                "1/5 votes for the nuke!",
                "2/5 votes for the nuke!",
                "3/5 votes for the nuke!",
                "4/5 votes for the nuke!",
                "5/5 votes, starting nuke."
            }
            local active = true

            local coro =
                coroutine.wrap(
                function()
                    while true do
                        wait(5)
                        local A_1 =
                            "This server will be nuked! Type !nuke to nuke it!!!This server will be nuked! Type !nuke to nuke it!!!This server will be nuked! Type !nuke to nuke it!!! Type !nuke to nuke it!!!"

                        local A_2 = "All"
                        local Event = game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest
                        Event:FireServer(A_1, A_2)
                        if not active then
                            coroutine.yield()
                        end
                    end
                end
            )()

            local alreadyVoted = {}

            game.Players.PlayerChatted:Connect(
                function(chattype, player, msg)
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

                        if (#testArray == 0) then
                            while wait() do
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                                    CFrame.new(27.751092910767, 10.22109889941, 66.054611206055)
                                local A_1 = "SERVER NUKED BY FLOPPA HUB"
                                local A_2 = "All"
                                local Event =
                                    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest
                                Event:FireServer(A_1, A_2)

                                game:GetService("RunService").RenderStepped:wait()
                                game:GetService("Workspace")["GLOBAL_SOUND"].TimePosition = math.random(1, 100)
                            end
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

Library:Init()

while true do
    Audio = game:GetService("Workspace")["GLOBAL_SOUND"]
    wait()
    if AutoDJ then
        wait()
        local A_1 = 6
        local Event = game:GetService("ReplicatedStorage").Connection
        Event:InvokeServer(A_1)
    end
    if AudioLag then
        game:GetService("Workspace")["GLOBAL_SOUND"].TimePosition = math.random(1, 100)
    end
end
