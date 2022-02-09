-- // Destroy excess GUIS
for _, v in ipairs(game.CoreGui:GetChildren()) do
    if v.Name == "ScreenGui" then
        v:Destroy()
    end
end

-- // Dependencies
local Library =
    loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/uwuware-ui/main/main.lua", true))()
local Maid =
    loadstring(
    game:HttpGet(
        "https://raw.githubusercontent.com/Quenty/NevermoreEngine/a8a2d2c1ffcf6288ec8d66f65cea593061ba2cf0/Modules/Shared/Events/Maid.lua"
    )
)()

-- // Modules
local eggs = require(game:GetService("ReplicatedStorage").EggModule)

-- // Script Environments
local mainEnv = getsenv(game:GetService("Players").LocalPlayer.PlayerGui.mainUI.LocalScript)

-- // Services
local runService = game:GetService("RunService")
local players = game:GetService("Players")

-- // Variables
local maid = Maid.new()
local localPlayer = players.LocalPlayer

-- // RunService Variables
local heartBeat = runService.Heartbeat

-- // Functions
local doCleaning = maid.DoCleaning

local function refreshDropdown(dropdown, newValues)
    for _, v in ipairs(dropdown.values) do
        dropdown:RemoveValue(v)
    end
    for _, v in ipairs(newValues) do
        dropdown:RemoveValue(v)
        dropdown:AddValue(v)
    end

    dropdown:Close()
    dropdown:SetValue("")
end

local function buyEgg(area, name)
    local areaName = "Basic"
    local arguments = {
        [1] = {
            [1] = name,
            [2] = 1,
            [3] = false,
            [4] = false
        }
    }

    game:GetService("ReplicatedStorage").Bindable.Client.eggOpened:Fire(areaName, arguments, false, false, false)
end

-- // UI
local mainWindow = Library:CreateWindow("Floppa Hub")
do
    local farmingFolder = mainWindow:AddFolder("Farming")
    do
        farmingFolder:AddToggle(
            {
                text = "Auto Click",
                flag = "autoClick"
            }
        )
        farmingFolder:AddToggle({text = "Auto Sell", flag = "autoSell", callback = doCleaning})
    end
    local petsFolder = mainWindow:AddFolder("Pets")
    do
        local selectedPet = ""
        local areas = {}
        local eggsForArea = {}
        local dropdown = nil

        for areaName, area in pairs(eggs.Eggs) do
            --[[local pets = area.Pets
            local values = {}

            for _, pet in pairs(pets) do
                local petName = pet.Name
                table.insert(values, petName)
            end

            petsFolder:AddList({text = areaName, values, flag = "selectedEgg"})
            ]]
            table.insert(areas, areaName)
        end
        local selfDrop
        selfDrop =
            petsFolder:AddList(
            {
                text = "Choose Area",
                flag = "selectedArea",
                values = areas,
                callback = function()
                    eggsForArea = {}
                    local area = eggs.Eggs[Library.flags.selectedArea]
                    if area then
                        local pets = area.Pets

                        for _, pet in pairs(pets) do
                            local petName = pet.Name
                            table.insert(eggsForArea, petName)
                        end
                        selfDrop:Close()
                        refreshDropdown(dropdown, eggsForArea)
                    end
                end
            }
        )
        dropdown =
            petsFolder:AddList(
            {
                text = "Eggs For Area Selected",
                flag = "eggForArea",
                values = eggsForArea
            }
        )
        petsFolder:AddButton(
            {
                text = "Buy Chosen Egg",
                callback = function()
                    local area = Library.flags.selectedArea
                    local egg = Library.flags.eggForArea
                    buyEgg(area, egg)
                end
            }
        )
    end
end

-- // Loops
task.spawn(
    function()
        while true do
            mainEnv = getsenv(game:GetService("Players").LocalPlayer.PlayerGui.mainUI.LocalScript)
            task.wait(0.1)
        end
    end
)

-- // Listeners
maid:DoCleaning()
maid:GiveTask(
    heartBeat:Connect(
        function()
            if Library.flags.autoClick then
                mainEnv.activateClick()
            end
        end
    )
)

--[[
local ohString1 = "Basic"
local ohTable2 = {
	[1] = {
		[1] = "Bunny",
		[2] = 1,
		[3] = false,
		[4] = false
	}
}
local ohBoolean3 = false
local ohBoolean4 = false
local ohBoolean5 = false

game:GetService("ReplicatedStorage").Bindable.Client.eggOpened:Fire(ohString1, ohTable2, ohBoolean3, ohBoolean4, ohBoolean5)
]]
-- // Init UI
Library:Init()
