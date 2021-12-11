local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/kav"))()
local Window = Library.CreateLib("Floppa Hub - Dead Winter", "BloodTheme")
local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("Main")

local path = game.Lighting.assets.itemModels
local itemKeys = {}

local sliderValue = nil
local chosenGun = nil

local function populateItemKeys()
    for _, v in pairs(path:GetChildren()) do
        table.insert(itemKeys, v.Name)
    end
end
populateItemKeys()

table.sort(itemKeys)

Section:NewDropdown(
    "Choose Item",
    "Spawns an item with the list",
    itemKeys,
    function(value)
        print(value)

        chosenGun = value
    end
)
Section:NewSlider(
    "Quantity",
    "Amount of Items to Spawn",
    100,
    1,
    function(value)
        sliderValue = value
    end
)
Section:NewButton(
    "Start Spawning",
    "Start Spawning the item",
    function()
        if sliderValue ~= nil and chosenGun ~= nil then
            local idx = 0
            repeat
                wait()
                game.Workspace.resources.events.createItemInWorld:FireServer(
                    49,
                    chosenGun,
                    game.Workspace[game.Players.LocalPlayer.Name].Torso.CFrame,
                    100
                )
                idx = idx + 1
            until idx == tonumber(sliderValue)
        end
    end
)
