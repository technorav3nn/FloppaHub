-- // Flag System
local flags = {
    sleighColor = Color3.fromRGB(255, 0, 0),
    cashColor = Color3.fromRGB(21, 255, 0)
}
function flags:SetFlag(name, value)
    flags[name] = value
end

-- // Variables
local bought = 0

-- // Services
local players = game:GetService("Players")
local runService = game:GetService("RunService")

-- // RunService Variables
local renderStepped = runService.RenderStepped
local heartBeat = runService.Heartbeat
local stepped = runService.Stepped

-- // Player Variables
local localPlayer = players.LocalPlayer
local playerChar = localPlayer.Character or localPlayer.Character:Wait()

-- // Dependencies
local Library = loadstring(game:HttpGet("https://pastebin.com/raw/PTrFUueU"))()
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
local NotifyLibrary =
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))()

local NotifyFunc = NotifyLibrary.Notify

-- // UI Theme
Library.theme.accentcolor = Color3.new(0.011764, 0.521568, 1)
Library.theme.background = "rbxassetid://2151741365"
Library.theme.tilesize = 0.77
Library.theme.accentcolor2 = Color3.new(0.011764, 0.521568, 1)
Library.theme.backgroundcolor = Color3.fromRGB(20, 20, 20)

-- // ESP Object Listeners
if game:GetService("Workspace").Ignored:FindFirstChild("WinterMAP") then
    ESP:AddObjectListener(
        game:GetService("Workspace").Ignored.WinterMAP.Sleigh,
        {
            ColorDynamic = function()
                return flags.sleighColor
            end,
            Name = "MeshPart",
            CustomName = "Sleigh",
            IsEnabled = "Sleigh"
        }
    )
end

ESP:AddObjectListener(
    game:GetService("Workspace").Ignored.Drop,
    {
        ColorDynamic = function()
            return flags.cashColor
        end,
        Validator = function(obj)
            return obj.Name == "MeshPart" or obj.Name == "MoneyDrop"
        end,
        PrimaryPart = function(obj)
            local hrp = obj
            return hrp
        end,
        CustomName = function(obj)
            return "Dropped Cash"
        end,
        IsEnabled = "Cash"
    }
)

-- // Disable ESP Players and other stuff on load
ESP.Players = false
ESP.Tracers = false
ESP.Boxes = true
ESP.Names = true

ESP:Toggle(true)

-- // Aiming (Credit to Stefanuk12!)

-- // Remove annoying messagebox (I credited you dw)
hookfunction(
    messagebox,
    function()
    end
)

-- // Load Aiming Module
local Aiming = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/Aiming/main/Load.lua"))()()
Aiming.ShowCredits = false
Aiming.Settings.Enabled = false
Aiming.Settings.FOVSettings.ShowFOV = false

local AimingSelected = Aiming.Selected
local AimingChecks = Aiming.Checks

-- // Hook
local __index
__index =
    hookmetamethod(
    game,
    "__index",
    function(t, k)
        -- // Check if it trying to get our mouse's hit or target
        if (t:IsA("Mouse") and (k == "Hit" or k == "Target")) then
            -- // If we can use the silent aim
            if (AimingChecks.IsAvailable()) then
                -- // Vars
                local TargetPart = AimingSelected.Part

                -- // Return modded val
                if Library.flags.silentAimEnabled then
                    return (k == "Hit" and TargetPart.CFrame or TargetPart)
                else
                    return __index(t, k)
                end
            end
        end

        -- // Return
        return __index(t, k)
    end
)

-- // Get Player From String Function
local function getPlayerFromString(str, useDisplayName)
    for _, v in pairs(players:GetPlayers()) do
        if useDisplayName then
            if v.DisplayName:lower():sub(1, #str) == str:lower() then
                return v
            end
        else
            if v.Name:lower():sub(1, #str) == str:lower() then
                return v
            end
        end
    end
end

-- // Notification Function
local function notify(args)
    NotifyFunc(args)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://6432593850"
    sound.Parent = game:GetService("SoundService")
    sound:Play()
end

-- // Auto Rob Functions
local function getCashiers()
    local filteredCashiers = {}
    for _, cashier in ipairs(game:GetService("Workspace").Cashiers:GetChildren()) do
        if (cashier.Humanoid.Health > 0) and cashier:FindFirstChild("Head") then
            table.insert(filteredCashiers, cashier)
        end
    end
    return filteredCashiers
end

local function collectNearbyCash()
    local droppedCash = game:GetService("Workspace").Ignored.Drop
    for _, v in ipairs(droppedCash:GetDescendants()) do
        if
            v:IsA("ClickDetector") and
                (v.Parent.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 18
         then
            repeat
                task.wait()
                fireclickdetector(v)
            until not v or not v.Parent.Parent
        end
    end
end

-- // Functions
local function getToolName(name)
    for i = 1, 100000 do
        if game:GetService("Workspace").Ignored.Shop:FindFirstChild("[" .. name .. "] - $" .. i) then
            return tostring("[" .. name .. "] - $" .. i)
        end
    end
end

local function getAmmoName(name)
    for i = 1, 250 do
        for i2 = 1, 250 do
            if game:GetService("Workspace").Ignored.Shop:FindFirstChild(i .. " [" .. name .. " Ammo] - $" .. i2) then
                return tostring(i .. " [" .. name .. " Ammo] - $" .. i2)
            end
        end
    end
end

local function buyItem(name, amount, rpDelay)
    if not amount then
        amount = 1
    end

    pcall(
        function()
            if workspace.Ignored.Shop:FindFirstChild(name) then
                local oldCf = localPlayer.Character.HumanoidRootPart.CFrame
                task.wait(0.2)
                localPlayer.Character.HumanoidRootPart.CFrame =
                    game.Workspace.Ignored.Shop[name].Head.CFrame * CFrame.new(0, 4, 0)
                task.wait(0.3)
                fireclickdetector(game.Workspace.Ignored.Shop[name].ClickDetector)
                task.wait(0.4)
                localPlayer.Character.HumanoidRootPart.CFrame = oldCf
            end
        end
    )
end

local function tpPlayer(cf)
    localPlayer.Character.HumanoidRootPart.CFrame = cf
end

local function isCop()
    return localPlayer.DataFolder:WaitForChild("Officer").Value == 1
end

-- // Player Target Functions
local Targeter = {}

function Targeter:BagPlayer(playerName)
    local targetPlayer = game.Players[playerName]
    if targetPlayer then
        if not localPlayer.Character:FindFirstChild("[BrownBag]") then
            buyItem(getToolName("BrownBag"), 1)
        end
        local tool =
            localPlayer.Backpack:FindFirstChild("[BrownBag]") or localPlayer.Character:FindFirstChild("[BrownBag]")

        tool.Parent = localPlayer.Character
        repeat
            localPlayer.Character["[BrownBag]"]:Activate()
            targetPlayer.Character.HumanoidRootPart.CFrame = localPlayer.Character.HumanoidRootPart.CFrame
            task.wait()
        until targetPlayer.Character:FindFirstChild("Christmas_Sock")
    end
end

local lastArrestMade = 0

function Targeter:KillPlayer(player, stomp, arrest)
    local rightHand = localPlayer.Character:FindFirstChild("RightHand")
    local leftHand = localPlayer.Character:FindFirstChild("LeftHand")

    local rightWrist = rightHand:FindFirstChild("RightWrist")
    local leftWrist = leftHand:FindFirstChild("LeftWrist")

    local oldWrists = {}

    local oldCf = localPlayer.Character.HumanoidRootPart.CFrame

    local combat = localPlayer.Character:FindFirstChild("Combat") or localPlayer.Backpack:FindFirstChild("Combat")
    if combat.Parent == localPlayer.Backpack then
        combat.Parent = localPlayer.Character
    end
    local cuffs =
        isCop() and localPlayer.Backpack:FindFirstChild("Cuff") or localPlayer.Character:FindFirstChild("Cuff")
    if cuffs.Parent == localPlayer.Character then
        cuffs.Parent = localPlayer.Backpack
    end

    if player and not player.Character.BodyEffects["K.O"].Value then
        workspace.CurrentCamera.CameraSubject = player.Character:FindFirstChildWhichIsA("Humanoid")

        if rightWrist and leftWrist then
            oldWrists.Right = rightWrist:Clone()
            oldWrists.Left = leftWrist:Clone()

            oldWrists.Right.Parent = nil
            oldWrists.Left.Parent = nil

            rightWrist:Destroy()
            leftWrist:Destroy()
        end
        workspace.CurrentCamera.CameraSubject = player.Character:FindFirstChildWhichIsA("Humanoid")
        local disconnected = false
        local connection
        connection =
            heartBeat:Connect(
            function()
                tpPlayer(player.Character.Head.CFrame * CFrame.new(0, -15, 0))
                combat:Activate()
                rightHand.CFrame = player.Character.Head.CFrame
                leftHand.CFrame = player.Character.Head.CFrame

                if player.Character.BodyEffects["K.O"].Value or not player or not localPlayer then
                    disconnected = true
                    connection:Disconnect()
                end
            end
        )

        repeat
            task.wait()
        until disconnected

        leftHand.CFrame = localPlayer.Character.LeftLowerArm.CFrame
        rightHand.CFrame = localPlayer.Character.RightLowerArm.CFrame

        rightHand.Size = Vector3.new(0.5, 0.5, 0.5)
        leftHand.Size = Vector3.new(0.5, 0.5, 0.5)

        oldWrists.Right.Parent = rightHand
        oldWrists.Left.Parent = leftHand

        workspace.CurrentCamera.CameraSubject = localPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if stomp and isCop() then
            notify({Title = "Floppa Hub", Description = "You cannot enable stomp if you're a cop!", Duration = 5})
            return
        elseif arrest and not isCop() then
            notify({Title = "Floppa Hub", Description = "You cannot enable arrest if you're not a cop!", Duration = 5})
            return
        elseif arrest and stomp then
            notify({Title = "Floppa Hub", Description = "You cannot enable arrest and stomp!", Duration = 5})
            return
        end

        tpPlayer(CFrame.new(player.Character.UpperTorso.Position) * CFrame.new(0, 2.5, 0))

        if
            arrest and player and player.Character:FindFirstChild("Humanoid") and
                player.Character.BodyEffects["K.O"].Value and
                not player.Character:FindFirstChild("GRABBING_CONSTRAINT")
         then
            cuffs.Parent = localPlayer.Character
            if os.clock() - lastArrestMade > 5 then
                for _ = 1, 250 do
                    if player.leaderstats.Wanted.Value <= 0 or player.DataFolder.Officer.Value ~= 0 then
                        tpPlayer(oldCf)
                        break
                    end
                    tpPlayer(CFrame.new(player.Character.UpperTorso.Position) * CFrame.new(0, 2.5, 0))
                    task.wait(0.75)
                    cuffs:Activate()
                    task.wait()
                    lastArrestMade = os.clock()
                    if os.clock() - lastArrestMade > 5 then
                        break
                    end
                end
            end
        end
        if
            stomp and player and player.Character:FindFirstChild("Humanoid") and
                player.Character.BodyEffects["K.O"].Value and
                not player.Character:FindFirstChild("GRABBING_CONSTRAINT")
         then
            tpPlayer(player.Character.HumanoidRootPart.CFrame)
            task.wait(0.3)
            repeat
                task.wait()
                tpPlayer(player.Character.Head.CFrame)
                game:GetService("ReplicatedStorage").MainEvent:FireServer("Stomp")
            until player.Character.BodyEffects.Dead.Value
            task.wait(0.1)
            localPlayer.Character.HumanoidRootPart.CFrame = oldCf
        end
    end
end

-- // Util Functions
local function __genOrderedIndex(t)
    local orderedIndex = {}
    for key in pairs(t) do
        table.insert(orderedIndex, key)
    end
    table.sort(orderedIndex)
    return orderedIndex
end

local function orderedNext(t, state)
    -- Equivalent of the next function, but returns the keys in the alphabetic
    -- order. We use a temporary ordered key table that is stored in the
    -- table being iterated.

    local key = nil
    --print("orderedNext: state = "..tostring(state) )
    if state == nil then
        -- the first time, generate the index
        t.__orderedIndex = __genOrderedIndex(t)
        key = t.__orderedIndex[1]
    else
        -- fetch the next value
        for i = 1, table.getn(t.__orderedIndex) do
            if t.__orderedIndex[i] == state then
                key = t.__orderedIndex[i + 1]
            end
        end
    end

    if key then
        return key, t[key]
    end

    -- no more value to return, cleanup
    t.__orderedIndex = nil
    return
end

local function orderedPairs(t)
    -- Equivalent of the pairs() function on tables. Allows to iterate
    -- in order
    return orderedNext, t, nil
end

local function forceResetPlayer()
    for _, v in pairs(localPlayer.Character:GetChildren()) do
        if v:IsA("BasePart") or v:IsA("Part") or v:IsA("MeshPart") then
            if v.Name ~= "HumanoidRootPart" then
                v:Destroy()
            end
        end
    end
end

local function initGodMode()
    localPlayer.Character.RagdollConstraints:Destroy()
    local newFolder = Instance.new("Folder", localPlayer.Character)
    newFolder.Name = "FULLY_LOADED_CHAR"
    task.wait()
    game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
end

local function getAllItemsInBackpackAndCharacter()
    local ret = {}
    local retNames = {}
    for _, tool in ipairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name ~= "Combat" then
            if not tool:FindFirstChild("CantStore") then
                table.insert(ret, tool)
                table.insert(retNames, tool.Name)
            end
        end
    end
    for _, v in ipairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if v:IsA("Tool") and v.Name ~= "Combat" then
            if not v:FindFirstChild("CantStore") then
                table.insert(ret, v)
                table.insert(retNames, v.Name)
            end
        end
    end
    return ret, retNames
end

local function getDrop(name, amount)
    local itemDrops = game:GetService("Workspace").Ignored.ItemsDrop
    local validNames = {"[Knife]", "[LockPicker]"}
    if not table.find(validNames, name) then
        messagebox("Invalid name of tool!", "Invalid name", 0)
    else
        local collected = 0
        for _, drop in ipairs(itemDrops:GetChildren()) do
            if drop:FindFirstChild(name) then
                if collected == amount then
                    break
                end
                firetouchinterest(
                    localPlayer.Character.HumanoidRootPart,
                    drop:FindFirstChildWhichIsA("TouchTransmitter", true).Parent,
                    0
                )
                collected = collected + 1
            end
        end
    end
end

local function calculateTax(money)
    assert(type(money) == "number", "money is not a number | at calculateTax")
    return math.floor((money / 100) * 70)
end

local function refreshDropdown(dropdown, newValues)
    for _, v in ipairs(dropdown.values) do
        dropdown:Remove(v)
    end
    for _, v in ipairs(newValues) do
        dropdown:Remove(v)
        dropdown:Add(v)
    end
end

local items, itemNames = getAllItemsInBackpackAndCharacter()

-- // Data
local teleports = {
    AGuns = {
        "Glock",
        "SMG",
        "Silencer",
        "TacticalShotgun",
        "P90",
        "AUG",
        "Shotgun",
        "RPG",
        "AR",
        "Double-Barrel SG",
        "Flamethrower",
        "Revolver",
        "LMG",
        "AK47",
        "DrumGun",
        "Silencer",
        "GrenadeLauncher",
        "Taser",
        "SilencerAR",
        "Grenade"
    },
    Armor = {
        "High-Medium Armor",
        "Medium Armor"
    },
    Food = {
        "Cranberry",
        "Donut",
        "Pizza",
        "Chicken",
        "Popcorn",
        "Hamburger",
        "Taco",
        "Starblox Latte",
        "Lettuce",
        "Lemonade"
    },
    Masks = {
        "Ninja Mask",
        "Surgeon Mask",
        "Riot Mask",
        "Hockey Mask",
        "Breathing Mask",
        "Pumpkin Mask",
        "Skull Mask",
        "Paintball Mask"
    },
    Weights = {
        "Weights",
        "HeavyWeights"
    },
    Melees = {
        "Shovel",
        "Bat",
        "Knife",
        "Pencil",
        "StopSign",
        "Pitchfork"
    },
    Phones = {
        "iPhone",
        "iPhoneB",
        "iPhoneG",
        "iPhoneP",
        "Old Phone",
        "Orange Phone",
        "Original Phone"
    },
    Bikes = {
        "DuoBike",
        "Solo Bike"
    },
    Extras = {
        "PepperSpray",
        "LockPicker",
        "Flashlight",
        "Flowers",
        "Anti Bodies",
        "Money Gun",
        "Brown Bag",
        "Firework"
    },
    Sets = {
        ["DB Shotgun + Revolver"] = {["Double-Barrel SG"] = 5, ["Revolver"] = 5},
        ["Food Set"] = {"Pizza", "Chicken", "Popcorn"}
    }
}

local locations = {
    "Bank",
    "Boxing Place",
    "Police Station",
    "Admin Base",
    "Sewers",
    "Hood Kicks",
    "Hospital",
    "Phone Store",
    "Taco Shack",
    "Casino",
    "UFO",
    "Fire Station",
    "Church",
    "Downhill Gun Shop",
    "Uphill Gun Shop",
    "Carnival",
    "School",
    "Sewer Runoff",
    "Trailer",
    "Radioactive Area"
}

local allAnimations = {
    "Default",
    "Astronaut",
    "Zombie",
    "Bubbly",
    "Cartoony",
    "Elder",
    "Ghost",
    "Knight",
    "Levitation",
    "Mage",
    "Ninja",
    "OldSchool",
    "Pirate",
    "Popstar",
    "Princess",
    "Robot",
    "Stylish",
    "Superhero",
    "Toy",
    "Vampire",
    "Werewolf",
    "Confindent",
    "Cowboy",
    "Rthro",
    "Sneaky",
    "Patrol"
}

local animationTbl = {
    Default = {
        "http://www.roblox.com/asset/?id=507766666",
        "http://www.roblox.com/asset/?id=507766951",
        "http://www.roblox.com/asset/?id=507777826",
        "http://www.roblox.com/asset/?id=507767714",
        "http://www.roblox.com/asset/?id=507765000",
        "http://www.roblox.com/asset/?id=507765644",
        "http://www.roblox.com/asset/?id=507767968"
    },
    Elder = {
        "rbxassetid://845397899",
        "rbxassetid://845400520",
        "rbxassetid://845403856",
        "rbxassetid://845386501",
        "rbxassetid://845398858",
        "rbxassetid://845392038",
        "rbxassetid://845396048"
    },
    Ghost = {
        "rbxassetid://616006778",
        "rbxassetid://616008087",
        "rbxassetid://616013216",
        "rbxassetid://616013216",
        "rbxassetid://616008936",
        "rbxassetid://616005863",
        "rbxassetid://616012453",
        "rbxassetid://616011509"
    },
    Astronaut = {
        "rbxassetid://891621366",
        "rbxassetid://891633237",
        "rbxassetid://891667138",
        "rbxassetid://891636393",
        "rbxassetid://891627522",
        "rbxassetid://891609353",
        "rbxassetid://891617961"
    },
    Bubbly = {
        "rbxassetid://910004836",
        "rbxassetid://910009958",
        "rbxassetid://910034870",
        "rbxassetid://910025107",
        "rbxassetid://910016857",
        "rbxassetid://910001910",
        "rbxassetid://910030921",
        "rbxassetid://910028158"
    },
    Cartoony = {
        "rbxassetid://742637544",
        "rbxassetid://742638445",
        "rbxassetid://742640026",
        "rbxassetid://742638842",
        "rbxassetid://742637942",
        "rbxassetid://742636889",
        "rbxassetid://742637151"
    },
    Confindent = {
        "rbxassetid://1069977950",
        "rbxassetid://1069987858",
        "rbxassetid://1070017263",
        "rbxassetid://1070001516",
        "rbxassetid://1069984524",
        "rbxassetid://1069946257",
        "rbxassetid://1069973677"
    },
    Cowboy = {
        "rbxassetid://1014390418",
        "rbxassetid://1014398616",
        "rbxassetid://1014421541",
        "rbxassetid://1014401683",
        "rbxassetid://1014394726",
        "rbxassetid://1014380606",
        "rbxassetid://1014384571"
    },
    Knight = {
        "rbxassetid://657595757",
        "rbxassetid://657568135",
        "rbxassetid://657552124",
        "rbxassetid://657564596",
        "rbxassetid://658409194",
        "rbxassetid://658360781",
        "rbxassetid://657600338"
    },
    Levitation = {
        "rbxassetid://616006778",
        "rbxassetid://616008087",
        "rbxassetid://616013216",
        "rbxassetid://616010382",
        "rbxassetid://616008936",
        "rbxassetid://616003713",
        "rbxassetid://616005863"
    },
    Mage = {
        "rbxassetid://707742142",
        "rbxassetid://707855907",
        "rbxassetid://707897309",
        "rbxassetid://707861613",
        "rbxassetid://707853694",
        "rbxassetid://707826056",
        "rbxassetid://707829716"
    },
    Ninja = {
        "rbxassetid://656117400",
        "rbxassetid://656118341",
        "rbxassetid://656121766",
        "rbxassetid://656118852",
        "rbxassetid://656117878",
        "rbxassetid://656114359",
        "rbxassetid://656115606"
    },
    OldSchool = {
        "rbxassetid://5319828216",
        "rbxassetid://5319831086",
        "rbxassetid://5319847204",
        "rbxassetid://5319844329",
        "rbxassetid://5319841935",
        "rbxassetid://5319839762",
        "rbxassetid://5319852613",
        "rbxassetid://5319850266"
    },
    Patrol = {
        "rbxassetid://1149612882",
        "rbxassetid://1150842221",
        "rbxassetid://1151231493",
        "rbxassetid://1150967949",
        "rbxassetid://1148811837",
        "rbxassetid://1148811837",
        "rbxassetid://1148863382"
    },
    Pirtate = {
        "rbxassetid://750781874",
        "rbxassetid://750782770",
        "rbxassetid://750785693",
        "rbxassetid://750783738",
        "rbxassetid://750782230",
        "rbxassetid://750779899",
        "rbxassetid://750780242"
    },
    Popstar = {
        "rbxassetid://1212900985",
        "rbxassetid://1150842221",
        "rbxassetid://1212980338",
        "rbxassetid://1212980348",
        "rbxassetid://1212954642",
        "rbxassetid://1213044953",
        "rbxassetid://1212900995"
    },
    Princess = {
        "rbxassetid://941003647",
        "rbxassetid://941013098",
        "rbxassetid://941028902",
        "rbxassetid://941015281",
        "rbxassetid://941008832",
        "rbxassetid://940996062",
        "rbxassetid://941000007"
    },
    Robot = {
        "rbxassetid://616088211",
        "rbxassetid://616089559",
        "rbxassetid://616095330",
        "rbxassetid://616091570",
        "rbxassetid://616090535",
        "rbxassetid://616086039",
        "rbxassetid://616087089"
    },
    Rthro = {
        "rbxassetid://2510196951",
        "rbxassetid://2510197257",
        "rbxassetid://2510202577",
        "rbxassetid://2510198475",
        "rbxassetid://2510197830",
        "rbxassetid://2510195892",
        "rbxassetid://02510201162",
        "rbxassetid://2510199791",
        "rbxassetid://2510192778"
    },
    Sneaky = {
        "rbxassetid://1132473842",
        "rbxassetid://1132477671",
        "rbxassetid://1132510133",
        "rbxassetid://1132494274",
        "rbxassetid://1132489853",
        "rbxassetid://1132461372",
        "rbxassetid://1132469004"
    },
    Stylish = {
        "rbxassetid://616136790",
        "rbxassetid://616138447",
        "rbxassetid://616146177",
        "rbxassetid://616140816",
        "rbxassetid://616139451",
        "rbxassetid://616133594",
        "rbxassetid://616134815"
    },
    Superhero = {
        "rbxassetid://782841498",
        "rbxassetid://782845736",
        "rbxassetid://782843345",
        "rbxassetid://782842708",
        "rbxassetid://782847020",
        "rbxassetid://782843869",
        "rbxassetid://782846423"
    },
    Toy = {
        "rbxassetid://782841498",
        "rbxassetid://782845736",
        "rbxassetid://782843345",
        "rbxassetid://782842708",
        "rbxassetid://782847020",
        "rbxassetid://782843869",
        "rbxassetid://782846423"
    },
    Vampire = {
        "rbxassetid://1083445855",
        "rbxassetid://1083450166",
        "rbxassetid://1083473930",
        "rbxassetid://1083462077",
        "rbxassetid://1083455352",
        "rbxassetid://1083439238",
        "rbxassetid://1083443587"
    },
    Werewolf = {
        "rbxassetid://1083195517",
        "rbxassetid://1083214717",
        "rbxassetid://1083178339",
        "rbxassetid://1083216690",
        "rbxassetid://1083218792",
        "rbxassetid://1083182000",
        "rbxassetid://1083189019"
    },
    Zombie = {
        "rbxassetid://616158929",
        "rbxassetid://616160636",
        "rbxassetid://616168032",
        "rbxassetid://616163682",
        "rbxassetid://616161997",
        "rbxassetid://616156119",
        "rbxassetid://616157476"
    }
}

--[[
local animationValues = {
    idle = "Default",
    walk = "Default",
    run = "Default",
    jump = "Default",
    climb = "Default",
    fall = "Default"
}
]]
local selectedSets = {}
local oldToolSizes = {}

-- // UI Components
local Window = Library:CreateWindow("Floppa Hub", Vector2.new(492, 598), Enum.KeyCode.RightShift)
do
    local playerTab = Window:CreateTab("Player")
    do
        local movementSection = playerTab:CreateSector("Movement", "left")
        do
            movementSection:AddToggle(
                "Fly",
                false,
                function(bool)
                    local plr = game.Players.LocalPlayer
                    local mouse = plr:GetMouse()

                    if workspace:FindFirstChild("Core") then
                        workspace.Core:Destroy()
                    end

                    local Core = Instance.new("Part")
                    Core.Name = "Core"
                    Core.Size = Vector3.new(0.05, 0.05, 0.05)

                    spawn(
                        function()
                            Core.Parent = workspace
                            local Weld = Instance.new("Weld", Core)
                            Weld.Part0 = Core
                            Weld.Part1 = localPlayer.Character.LowerTorso
                            Weld.C0 = CFrame.new(0, 0, 0)
                        end
                    )

                    workspace:WaitForChild("Core")

                    local torso = workspace.Core
                    flying = bool
                    local speed = 50
                    local keys = {a = false, d = false, w = false, s = false}
                    local e1
                    local e2
                    local function start()
                        local pos = Instance.new("BodyPosition", torso)
                        local gyro = Instance.new("BodyGyro", torso)
                        pos.Name = "EPIXPOS"
                        pos.maxForce = Vector3.new(math.huge, math.huge, math.huge)
                        pos.position = torso.Position
                        gyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                        gyro.cframe = torso.CFrame
                        repeat
                            wait()
                            localPlayer.Character.Humanoid.PlatformStand = true
                            local new = gyro.cframe - gyro.cframe.p + pos.position
                            if not keys.w and not keys.s and not keys.a and not keys.d then
                                speed = 50
                            end
                            if keys.w then
                                new = new + workspace.CurrentCamera.CoordinateFrame.lookVector * speed
                                speed = speed + 0
                            end
                            if keys.s then
                                new = new - workspace.CurrentCamera.CoordinateFrame.lookVector * speed
                                speed = speed + 0
                            end
                            if keys.d then
                                new = new * CFrame.new(speed, 0, 0)
                                speed = speed + 0
                            end
                            if keys.a then
                                new = new * CFrame.new(-speed, 0, 0)
                                speed = speed + 0
                            end
                            if speed > 10 then
                                speed = 50
                            end
                            pos.position = new.p
                            if keys.w then
                                gyro.cframe =
                                    workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad(speed * 0), 0, 0)
                            elseif keys.s then
                                gyro.cframe =
                                    workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(math.rad(speed * 0), 0, 0)
                            else
                                gyro.cframe = workspace.CurrentCamera.CoordinateFrame
                            end
                        until flying == false
                        if gyro then
                            gyro:Destroy()
                        end
                        if pos then
                            pos:Destroy()
                        end
                        flying = false
                        localPlayer.Character.Humanoid.PlatformStand = false
                        speed = 50
                    end
                    e1 =
                        mouse.KeyDown:Connect(
                        function(key)
                            if not torso or not torso.Parent then
                                e1:Disconnect()
                                e2:Disconnect()
                                return
                            end
                            if key == "w" then
                                keys.w = true
                            elseif key == "s" then
                                keys.s = true
                            elseif key == "a" then
                                keys.a = true
                            elseif key == "d" then
                                keys.d = true
                            end
                        end
                    )
                    e2 =
                        mouse.KeyUp:Connect(
                        function(key)
                            if key == "w" then
                                keys.w = false
                            elseif key == "s" then
                                keys.s = false
                            elseif key == "a" then
                                keys.a = false
                            elseif key == "d" then
                                keys.d = false
                            end
                        end
                    )
                    if bool then
                        flying = true
                        start()
                    else
                        flying = false
                    end
                end
            ):AddKeybind(Enum.KeyCode.X)
            movementSection:AddToggle(
                "Noclip",
                false,
                function()
                end
            ):AddKeybind(Enum.KeyCode.V)
        end

        local godSection = playerTab:CreateSector("God", "right")
        do
            godSection:AddDropdown(
                "Choose God Mode",
                {"Only Guns", "Only Melee", "God Block", "No Ragdoll"},
                "Only Guns",
                false,
                function()
                end,
                "godChosen"
            )
            godSection:AddButton(
                "Apply",
                function()
                    local value = Library.flags.godChosen
                    if not value then
                        return
                    end
                    pcall(
                        function()
                            if value == "Only Melee" then
                                flags.onlyMeleeGod = true
                                forceResetPlayer()
                            elseif value == "Only Guns" then
                                flags.onlyGunsGod = true
                                forceResetPlayer()
                            elseif value == "God Block" then
                                localPlayer.Character.BodyEffects.Defense.CurrentTimeBlock:Destroy()
                            elseif value == "No Ragdoll" then
                                flags.noRagdoll = true
                                forceResetPlayer()
                            end
                        end
                    )
                end
            )
        end

        local playerEffectsSection = playerTab:CreateSector("Visual Effects", "left")
        do
            playerEffectsSection:AddToggle(
                "Anti Flashbang",
                false,
                function(bool)
                    flags.antiFlash = bool
                    local function onChildAdded(child)
                        if flags.antiFlash and child.Name == "whiteScreen" then
                            child:Destroy()
                        end
                    end
                    localPlayer.PlayerGui.MainScreenGui.ChildAdded:Connect(onChildAdded)
                end
            )
            playerEffectsSection:AddToggle(
                "Anti Pepper Spray",
                false,
                function(bool)
                    flags.antiPepper = bool
                    local function onChildAdded(child)
                        if flags.antiPepper and child.Name == "PepperSpray" then
                            child:Destroy()
                        end
                    end
                    localPlayer.PlayerGui.MainScreenGui.ChildAdded:Connect(onChildAdded)
                end
            )
            playerEffectsSection:AddToggle(
                "Anti Snowball Effect",
                false,
                function(bool)
                    flags.antiSnow = bool
                    local function onChildAdded(child)
                        if flags.antiSnow and child.Name == "SNOWBALLFRAME" then
                            child:Destroy()
                        end
                    end
                    localPlayer.PlayerGui.MainScreenGui.ChildAdded:Connect(onChildAdded)
                end
            )
        end

        local animationsSection = playerTab:CreateSector("Animations", "right")
        do
            animationsSection:AddDropdown(
                "Select Animation Pack",
                allAnimations,
                allAnimations[1],
                false,
                function()
                end,
                "selectedAnim"
            )
            animationsSection:AddButton(
                "Apply Animation",
                function()
                    local anims = animationTbl[Library.flags.selectedAnim]
                    if anims then
                        localPlayer.Character.Animate.idle.Animation1.AnimationId = anims[1]
                        localPlayer.Character.Animate.idle.Animation2.AnimationId = anims[2]
                        localPlayer.Character.Animate.walk.WalkAnim.AnimationId = anims[3]
                        localPlayer.Character.Animate.run.RunAnim.AnimationId = anims[4]
                        localPlayer.Character.Animate.jump.JumpAnim.AnimationId = anims[5]
                        localPlayer.Character.Animate.climb.ClimbAnim.AnimationId = anims[6]
                        localPlayer.Character.Animate.fall.FallAnim.AnimationId = anims[7]
                    end
                end
            )
        end
        local jailSec = playerTab:CreateSector("Jail", "left")
        do
            jailSec:AddButton(
                "Unban",
                function()
                    forceResetPlayer()
                end
            )
            jailSec:AddButton(
                "Unjail",
                function()
                    local keyTool = game:GetService("Workspace").Ignored.Shop["[Key] - $125"]

                    localPlayer.Character.HumanoidRootPart.CFrame = keyTool.Head.CFrame + Vector3.new(0, 2, 0)
                    task.wait(0.4)
                    fireclickdetector(keyTool.ClickDetector, math.huge)
                    task.wait(0.1)
                    if localPlayer.Backpack:FindFirstChild("[Key]") then
                        localPlayer.Character.Humanoid:EquipTool(localPlayer.Backpack:FindFirstChild("[Key]"))
                    end
                end
            )
        end
    end

    local selectionBox = Instance.new("SelectionBox")
    selectionBox.LineThickness = 0.15
    selectionBox.Color3 = Color3.new(1, 0, 0)

    local toolReachBox = Instance.new("SelectionBox")
    selectionBox.LineThickness = 0.15
    selectionBox.Color3 = Color3.new(0, 0.466666, 1)

    local combatTab = Window:CreateTab("Combat")
    do
        local mainSection = combatTab:CreateSector("Combat", "left")
        do
            mainSection:AddToggle(
                "Auto Stomp",
                false,
                function()
                end,
                "autoStomp"
            )
            mainSection:AddToggle(
                "Auto Block",
                false,
                function()
                    if Library.flags.autoBlock then
                        local Loop
                        local loopFunction = function()
                            local forbidden = {
                                "[RPG]",
                                "[SMG]",
                                "[TacticalShotgun]",
                                "[AK47]",
                                "[AUG]",
                                "[Glock]",
                                "[Shotgun]",
                                "[Flamethrower]",
                                "[Silencer]",
                                "[AR]",
                                "[Revolver]",
                                "[SilencerAR]",
                                "[LMG]",
                                "[P90]",
                                "[DrumGun]",
                                "[Double-Barrel SG]",
                                "[Hamburger]",
                                "[Chicken]",
                                "[Pizza]",
                                "[Cranberry]",
                                "[Donut]",
                                "[Taco]",
                                "[Starblox Latte]",
                                "[BrownBag]",
                                "[Weights]",
                                "[HeavyWeights]"
                            }
                            local Found = false
                            for _, v in ipairs(game.Workspace.Players:GetChildren()) do
                                if
                                    (v.UpperTorso.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <=
                                        15
                                 then
                                    if
                                        v.BodyEffects.Attacking.Value == true and
                                            not table.find(forbidden, v:FindFirstChildWhichIsA("Tool").Name) and
                                            v.Name ~= localPlayer.Name
                                     then
                                        Found = true
                                        game:GetService("ReplicatedStorage").MainEvent:FireServer(
                                            "Block",
                                            localPlayer.Name
                                        )
                                    end
                                end
                            end
                            if not Found then
                                if localPlayer.Character.BodyEffects:FindFirstChild("Block") then
                                    localPlayer.Character.BodyEffects.Block:Destroy()
                                end
                            end
                        end
                        local Start = function()
                            Loop = game:GetService("RunService").Heartbeat:Connect(loopFunction)
                        end
                        local Pause = function()
                            Loop:Disconnect()
                        end
                        Start()
                        repeat
                            wait()
                        until not Library.flags.autoBlock
                        Pause()
                    end
                end,
                "autoBlock"
            )
            renderStepped:Connect(
                function()
                    if Library.flags.autoStomp then
                        task.wait()
                        game:GetService("ReplicatedStorage").MainEvent:FireServer("Stomp")
                    end
                end
            )
        end
        local reachSection = combatTab:CreateSector("Reach", "left")
        do
            reachSection:AddToggle(
                "Fist Reach",
                false,
                function(bool)
                    if bool then
                        for _, v in ipairs(game.Workspace:GetDescendants()) do
                            if v:IsA("Seat") then
                                v:Destroy()
                            end
                        end
                        localPlayer.Character.LeftHand.Size = Vector3.new(50, 50, 50)
                        localPlayer.Character.RightHand.Size = Vector3.new(50, 50, 50)
                        localPlayer.Character.RightHand.Massless = true
                        localPlayer.Character.LeftHand.Massless = true
                        localPlayer.Character.RightHand.Transparency = 1
                        localPlayer.Character.LeftHand.Transparency = 1

                        selectionBox.Adornee = localPlayer.Character.LeftHand
                        selectionBox.Parent = localPlayer.Character.LeftHand
                    else
                        localPlayer.Character.LeftHand.Size = Vector3.new(0.5, 0.5, 0.5)
                        localPlayer.Character.RightHand.Size = Vector3.new(0.5, 0.5, 0.5)
                        localPlayer.Character.RightHand.Massless = false
                        localPlayer.Character.LeftHand.Massless = false
                        localPlayer.Character.RightHand.Transparency = 0
                        localPlayer.Character.LeftHand.Transparency = 0
                    end
                end
            ):AddColorpicker(
                selectionBox.Color3,
                function(color)
                    selectionBox.Color3 = color
                end
            )

            local reachToggle =
                reachSection:AddToggle(
                "Tool Reach",
                false,
                function(bool)
                    pcall(
                        function()
                            local toolToReach = Library.flags.selectedReachTool

                            local tool =
                                localPlayer.Backpack:FindFirstChild(toolToReach) or
                                localPlayer.Character:FindFirstChild(toolToReach)
                            if toolToReach == "" then
                                tool = localPlayer.Character:FindFirstChildWhichIsA("Tool")
                            end
                            if tool then
                                print("found tool")
                                if bool then
                                    local newBox = toolReachBox:Clone()
                                    newBox.Parent = tool.Handle
                                    newBox.Adornee = tool.Handle

                                    if not oldToolSizes[tool.Name] then
                                        oldToolSizes[tool.Name] = tool.Handle.Size
                                    end

                                    tool.Handle.Size = Vector3.new(50, 50, 50)
                                    if tool.Handle.Transparency ~= 1 then
                                        tool.Handle.Transparency = 1
                                    end
                                else
                                    local oldSize = oldToolSizes[tool.Name]
                                    if oldSize then
                                        print(oldSize)
                                        tool.Handle.Size = oldSize
                                        tool.Handle:FindFirstChildWhichIsA("SelectionBox"):Destroy()
                                        if tool.Handle.Transparency ~= 0 then
                                            tool.Handle.Transparency = 0
                                        end
                                    end
                                end
                            end
                        end
                    )
                end
            )

            local reachDrop =
                reachToggle:AddDropdown(
                itemNames,
                itemNames[1],
                false,
                function()
                end,
                "selectedReachTool"
            )
            localPlayer.Backpack.ChildRemoved:Connect(
                function()
                    items, itemNames = getAllItemsInBackpackAndCharacter()
                    refreshDropdown(reachDrop, itemNames)
                end
            )
            localPlayer.Backpack.ChildAdded:Connect(
                function()
                    items, itemNames = getAllItemsInBackpackAndCharacter()
                    refreshDropdown(reachDrop, itemNames)
                end
            )
            localPlayer.Character.ChildRemoved:Connect(
                function()
                    items, itemNames = getAllItemsInBackpackAndCharacter()
                    refreshDropdown(reachDrop, itemNames)
                end
            )
            localPlayer.Character.ChildAdded:Connect(
                function()
                    items, itemNames = getAllItemsInBackpackAndCharacter()
                    refreshDropdown(reachDrop, itemNames)
                end
            )
            --[[
            task.spawn(
                function()
                    local function update()
                        items, itemNames = getAllItemsInBackpackAndCharacter()
                        refreshDropdown(reachDrop, itemNames)
                    end
                    while task.wait(10) do
                        local success, err = pcall(update)
                        if not success then
                            error(err)
                        end
                    end
                end
            )
            --]]
        end

        local toolsSection = combatTab:CreateSector("Drops", "right")
        do
            toolsSection:AddDropdown(
                "Drop Chosen",
                {"[Knife]", "[LockPicker]"},
                "[Knife]",
                false,
                function()
                end,
                "chosenDrop"
            )
            toolsSection:AddSlider(
                "Amount To Get",
                1,
                1,
                10,
                1,
                function()
                end,
                "amountOfDrop"
            )
            toolsSection:AddButton(
                "Get Drop",
                function()
                    local dropToGet = Library.flags.chosenDrop
                    local dropAmount = Library.flags.amountOfDrop
                    getDrop(dropToGet, dropAmount)
                end
            )
        end
        local defenseSection = combatTab:CreateSector("Defense", "left")
        do
            defenseSection:AddToggle(
                "Anti Jump Cooldown",
                false,
                function(bool)
                    if bool then
                        playerChar:FindFirstChildWhichIsA("Humanoid").Name = "Humz"
                        playerChar:FindFirstChildWhichIsA("Humanoid").WalkSpeed = 17
                    else
                        playerChar:FindFirstChildWhichIsA("Humanoid").Name = "Humanoid"
                        playerChar:FindFirstChildWhichIsA("Humanoid").WalkSpeed = 16
                    end
                end
            )
            defenseSection:AddToggle(
                "Anti Slow",
                false,
                function(bool)
                    flags.antiSlow = bool
                    localPlayer.Character.BodyEffects.Movement.ChildAdded:Connect(
                        function(child)
                            if flags.antiSlow then
                                child:Destroy()
                            end
                        end
                    )
                end
            )
            defenseSection:AddToggle(
                "Anti Grab",
                false,
                function(bool)
                    flags.antiGrab = bool
                    local function onChildAdded()
                        if game.Players.LocalPlayer.Character:FindFirstChild("GRABBING_CONSTRAINT") and flags.antiGrab then
                            game.Players.LocalPlayer.Character.GRABBING_CONSTRAINT:Destroy()
                        end
                    end
                    if flags.antiGrab then
                        onChildAdded()
                    end
                    playerChar.ChildAdded:Connect(onChildAdded)
                end
            )
        end
        local gunSection = combatTab:CreateSector("Guns", "left")
        do
            gunSection:AddToggle(
                "Auto Reload",
                false,
                function(bool)
                    for _, v in ipairs(localPlayer.Character:GetChildren()) do
                        --- @type NumberValue
                        local ammoValue = v:FindFirstChild("Ammo")
                        if ammoValue then
                            if ammoValue.Value == 0 and bool then
                                game:GetService("ReplicatedStorage").MainEvent:FireServer("Reload", v)
                            end
                        end
                    end
                end
            )
        end
        local toolsSection = combatTab:CreateSector("Tools", "right")
        do
            toolsSection:AddButton(
                "Equip All Tools",
                function()
                    for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                        if v:IsA("Tool") then
                            v.Parent = game.Players.LocalPlayer.Character
                        end
                    end
                end
            )
            toolsSection:AddSeperator("Tool Trolling")
            toolsSection:AddButton(
                "Katana",
                function()
                    getDrop("[Knife]", 1)
                    local knife = localPlayer.Backpack["[Knife]"]
                    knife.GripPos = Vector3.new(2, -5, -1.5)
                    knife.GripForward = Vector3.new(0, 0, 0)
                    knife.GripRight = Vector3.new(1, 0, -3)
                    knife.GripUp = Vector3.new(0, 0, 0)
                    knife.Parent = localPlayer.Character
                end
            )
        end
        local silentAimSection = combatTab:CreateSector("Silent Aim", "left")
        do
            silentAimSection:AddToggle(
                "Enabled",
                false,
                function(bool)
                    Aiming.Settings.Enabled = bool
                end,
                "silentAimEnabled"
            )
            silentAimSection:AddSeperator("FOV Settings")
            silentAimSection:AddToggle(
                "Show FOV",
                false,
                function(bool)
                    Aiming.Settings.FOVSettings.Enabled = bool
                end,
                "fieldOfViewEnabled"
            ):AddColorpicker(
                Aiming.Settings.FOVSettings.Colour,
                function(color)
                    Aiming.Settings.FOVSettings.Colour = color
                end
            )
            silentAimSection:AddSlider(
                "FOV Sides",
                tonumber(Aiming.Settings.FOVSettings.Sides),
                0,
                40,
                1,
                function(value)
                    Aiming.Settings.FOVSettings.Sides = value
                end,
                "fieldOfViewSides"
            )
            silentAimSection:AddSlider(
                "FOV Size",
                tonumber(Aiming.Settings.FOVSettings.Scale),
                5,
                300,
                1,
                function(value)
                    Aiming.Settings.FOVSettings.Scale = value
                end,
                "fieldOfViewSides"
            )
        end
        local targetSec = combatTab:CreateSector("Targeter", "right")
        do
            local currentTarget = targetSec:AddLabel("Target - None")

            targetSec:AddTextbox(
                "Target Name",
                players:GetPlayers()[math.random(1, #players:GetPlayers())].Name,
                function(value)
                    local target = getPlayerFromString(value, Library.flags.useDisplayName)
                    flags.target = target
                    if target then
                        currentTarget:Set("Target - " .. target.Name)
                    end
                end,
                "targetPlayer"
            )
            targetSec:AddToggle(
                "Use Display Name",
                false,
                function()
                end,
                "useDisplayName"
            )
            targetSec:AddSeperator("Target Functions")
            targetSec:AddButton(
                "Bag",
                function()
                    local target = flags.target
                    if target then
                        Targeter:BagPlayer(target.Name)
                    end
                end
            )
            targetSec:AddButton(
                "Goto",
                function()
                    local target = flags.target
                    if target and target.Character:FindFirstChild("HumanoidRootPart") then
                        tpPlayer(target.Character:FindFirstChild("HumanoidRootPart").CFrame)
                    end
                end
            )
            targetSec:AddButton(
                "Knock",
                function()
                    local target = flags.target
                    if target then
                        Targeter:KillPlayer(target, Library.flags.stompTarget, Library.flags.arrestTarget)
                    end
                end
            )
            targetSec:AddSeperator("Knock Options")

            targetSec:AddToggle(
                "Stomp Target",
                false,
                function()
                end,
                "stompTarget"
            )
            targetSec:AddToggle(
                "Arrest Target",
                false,
                function()
                end,
                "arrestTarget"
            )
        end
    end

    local farmingTab = Window:CreateTab("Farming")
    do
        local moneyFarmingSec = farmingTab:CreateSector("Money Farming", "left")
        do
            moneyFarmingSec:AddToggle(
                "ATM Farm",
                false,
                function()
                    if Library.flags.autoRob then
                        repeat
                            if not Library.flags.autoRob then
                                break
                            end
                            task.wait()
                            local cashiers = getCashiers()
                            if #cashiers == 0 then
                                repeat
                                    cashiers = getCashiers()

                                    task.wait()
                                until #cashiers ~= 0
                            end

                            local randomCashier = cashiers[math.random(1, #cashiers)]

                            local combatTool = nil
                            tpPlayer(randomCashier.Head.CFrame * CFrame.new(1, -0.7, 3))
                            if localPlayer.Backpack:FindFirstChild("Combat") then
                                playerChar.Humanoid:EquipTool(localPlayer.Backpack.Combat)
                                combatTool = playerChar.Combat
                            elseif playerChar:FindFirstChild("Combat") then
                                combatTool = playerChar.Combat
                            end
                            repeat
                                task.wait()
                                tpPlayer(randomCashier.Head.CFrame * CFrame.new(1, -0.7, 3))
                                combatTool:Activate()
                            until randomCashier.Humanoid.Health < 0 or not randomCashier
                            collectNearbyCash()
                            task.wait(0.4)
                        until not Library.flags.autoRob
                    end
                end,
                "autoRob"
            )
            moneyFarmingSec:AddToggle(
                "Hospital Farm",
                false,
                function()
                end,
                "autoHospital"
            )
            moneyFarmingSec:AddToggle(
                "Shoe Farm",
                false,
                function()
                end,
                "autoShoe"
            )
            moneyFarmingSec:AddSlider(
                "Sell Shoes At",
                1,
                5,
                20,
                1,
                function()
                end,
                "untilSell"
            )
        end
        local statFarmingSec = farmingTab:CreateSector("Money Farming", "right")
        do
            statFarmingSec:AddToggle(
                "Auto Lettuce",
                false,
                function()
                end,
                "autoLettuce"
            )
            statFarmingSec:AddToggle(
                "Box Farm",
                false,
                function()
                end,
                "boxFarm"
            ):AddKeybind(Enum.KeyCode.B)
            statFarmingSec:AddToggle(
                "Muscle Farm",
                false,
                function()
                    if not Library.flags.muscleFarm then
                        bought = 0
                    end
                end,
                "muscleFarm"
            ):AddDropdown(
                teleports.Weights,
                teleports.Weights[2],
                false,
                function()
                end,
                "selectedWeight"
            )
        end
    end

    local visualsTab = Window:CreateTab("Visuals")
    do
        local espSec = visualsTab:CreateSector("ESP", "left")
        do
            espSec:AddToggle(
                "Player ESP",
                false,
                function(bool)
                    ESP.Players = bool
                end
            ):AddColorpicker(
                ESP.Color,
                function(color)
                    ESP.Color = color
                end
            )
            espSec:AddToggle(
                "Cash ESP",
                false,
                function(bool)
                    ESP.Cash = bool
                end
            ):AddColorpicker(
                flags.cashColor,
                function(color)
                    flags.cashColor = color
                end
            )
            if game:GetService("Workspace").Ignored:FindFirstChild("WinterMAP") then
                espSec:AddToggle(
                    "Sleigh ESP",
                    false,
                    function(bool)
                        ESP.Sleigh = bool
                    end
                ):AddColorpicker(
                    flags.sleighColor,
                    function(color)
                        flags.sleighColor = color
                    end
                )
            end

            espSec:AddSeperator("ESP Options")

            espSec:AddToggle(
                "Team Color",
                true,
                function(bool)
                    ESP.TeamColor = bool
                end
            )
            espSec:AddToggle(
                "Tracers",
                false,
                function(bool)
                    ESP.Tracers = bool
                end
            )
            espSec:AddToggle(
                "Boxes",
                true,
                function(bool)
                    ESP.Boxes = bool
                end
            )
            espSec:AddToggle(
                "Names",
                true,
                function(bool)
                    ESP.Names = bool
                end
            )
        end
        local buyingTab = Window:CreateTab("Buying")
        do
            local i = 1

            for teleportName, teleportTbl in orderedPairs(teleports) do
                local isEven = i % 2 == 0
                if teleportName ~= "Locations" then
                    if teleportName == "AGuns" then
                        teleportName = teleportName:sub(2)
                    end

                    local sector = buyingTab:CreateSector(teleportName .. " Buys", isEven and "right" or "left")

                    if teleportName == "Sets" then
                        for set, _ in pairs(teleportTbl) do
                            sector:AddToggle(
                                set,
                                false,
                                function(bool)
                                    local isSetInTbl = table.find(selectedSets, set)
                                    if bool and not isSetInTbl then
                                        print("True toggle, set isnt in table")
                                        table.insert(selectedSets, set)
                                    elseif not bool and isSetInTbl then
                                        print("False toggle, set is in table")
                                        local idx = table.find(selectedSets, set)
                                        if idx then
                                            selectedSets[idx] = nil
                                        end
                                    end
                                end
                            )
                        end
                        sector:AddButton(
                            "Buy Toggled Sets",
                            function()
                                for _, setName in ipairs(selectedSets) do
                                    local set = teleports.Sets[setName]
                                    for itemName, ammo in pairs(set) do
                                        print("Buying " .. itemName)
                                        if type(itemName) == "number" then
                                            buyItem(getToolName(ammo), 1, 0.1)
                                        end

                                        if type(ammo) == "number" then
                                            buyItem(getAmmoName(itemName), ammo, 0.4)
                                        end
                                        task.wait(0.1)
                                    end
                                end
                            end
                        )
                    end

                    if teleportTbl and teleportName ~= "Sets" then
                        sector:AddDropdown(
                            "Item to buy",
                            teleportTbl,
                            teleportTbl[1],
                            false,
                            function()
                            end,
                            teleportName .. "Item"
                        )
                        sector:AddButton(
                            "Buy Chosen",
                            function()
                                buyItem(getToolName(Library.flags[teleportName .. "Item"]))
                            end
                        )
                        if teleportName == "Guns" then
                            sector:AddSeperator("Ammo")
                            sector:AddSlider(
                                "Amount To Buy",
                                1,
                                1,
                                25,
                                1,
                                function()
                                end,
                                "amountOfAmmo"
                            )
                            sector:AddButton(
                                "Buy Ammo For Gun",
                                function()
                                    local ammoFlag = tonumber(Library.flags.amountOfAmmo) or 1
                                    if Library.flags["GunsItem"] then
                                        task.spawn(
                                            function()
                                                for _ = 0, ammoFlag do
                                                    buyItem(getAmmoName(Library.flags["GunsItem"]), ammoFlag)
                                                    task.wait(0.3)
                                                end
                                            end
                                        )
                                    end
                                end
                            )
                        end
                    end
                    i = i + 1
                end
            end
        end
    end
    local miscTab = Window:CreateTab("Misc")
    do
        local cashDropperSection = miscTab:CreateSector("Cash Dropper", "left")
        do
            local cashTaxLabel =
                cashDropperSection:AddLabel(
                "Cash Tax: " .. tostring(calculateTax(Library.flags.cashDropperAmount or 100))
            )
            cashDropperSection:AddSlider(
                "Drop Amount",
                100,
                100,
                10000,
                1,
                function(value)
                    cashTaxLabel:Set("Cash Tax: " .. tostring(calculateTax(Library.flags.cashDropperAmount or 100)))
                end,
                "cashDropperAmount"
            )
            cashDropperSection:AddToggle(
                "Start Dropper",
                false,
                function()
                    task.spawn(
                        function()
                            while Library.flags.cashDropperToggle do
                                local dropAmount =
                                    Library.flags.cashDropperAmount or localPlayer.DataFolder.Currency.Value
                                local args = {
                                    "DropMoney",
                                    dropAmount
                                }
                                game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))
                                task.wait(6)
                            end
                        end
                    )
                end,
                "cashDropperToggle"
            )
        end
    end

    local settingsTab = Window:CreateTab("Settings")
    do
        if syn then
            settingsTab:CreateConfigSystem("left")
        else
            print("Your exploit doesnt support this.")
        end
        local creditsSection = settingsTab:CreateSector("Credits", "right")
        do
            creditsSection:AddLabel("Death_Blows - Creator")
            creditsSection:AddLabel("Stefanuk12 - Aiming Module / AC Bypass")
        end
    end
end

-- // Loops
task.spawn(
    function()
        while task.wait(1) do
            if Library.flags.muscleFarm then
                local muscleToolName = getToolName(Library.flags.selectedWeight or teleports.Weights[1])
                local name = "[" .. Library.flags.selectedWeight .. "]"
                if not localPlayer.Backpack:FindFirstChild(name) and bought ~= 1 then
                    buyItem(muscleToolName, 1)
                    bought = 1
                end
                if localPlayer.Backpack:FindFirstChild(name) then
                    localPlayer.Character.Humanoid:EquipTool(localPlayer.Backpack[name])
                end
                localPlayer.Character[name]:Activate()
            end
        end
    end
)

task.spawn(
    function()
        while task.wait(1) do
            if Library.flags.autoLettuce then
                pcall(
                    function()
                        buyItem(getToolName("Lettuce"), 1)
                        if localPlayer.Backpack:FindFirstChild("[Lettuce]") then
                            localPlayer.Character.Humanoid:EquipTool(localPlayer.Backpack["[Lettuce]"])
                        end
                        task.wait(0.3)
                        localPlayer.Character["[Lettuce]"]:Activate()
                    end
                )
            end
        end
    end
)

task.spawn(
    function()
        while task.wait(0.2) do
            if Library.flags.boxFarm then
                tpPlayer(
                    game.Workspace.MAP.Map.ArenaBOX.PunchingBagInGame["pretty ransom"].CFrame * CFrame.new(0, -1, 2)
                )

                if localPlayer.Backpack:FindFirstChild("Combat") then
                    localPlayer.Backpack.Combat.Parent = localPlayer.Character
                end
                mouse1click()
            end
        end
    end
)

-- // Event Listeners
localPlayer.CharacterAdded:Connect(
    function()
        task.wait(0.6)
        if localPlayer.Character:FindFirstChild("BodyEffects") then
            if flags.onlyGunsGod then
                initGodMode()
                flags.onlyGunsGod = false
                localPlayer.Character.BodyEffects.BreakingParts:Destroy()
            end
            if flags.onlyMeleeGod then
                initGodMode()
                flags.onlyMeleeGod = false
                localPlayer.Character.BodyEffects.Armor:Destroy()
                localPlayer.Character.BodyEffects.Defense:Destroy()
            end
            if flags.noRagdoll then
                initGodMode()
                flags.noRagdoll = false
            end
        end
    end
)

for _, v in ipairs(localPlayer.Character:GetChildren()) do
    --- @type NumberValue
    local ammoValue = v:FindFirstChild("Ammo")
    if ammoValue then
        if ammoValue.Value == 0 and Library.flags.autoReload then
            game:GetService("ReplicatedStorage").MainEvent:FireServer("Reload", v)
        end
        ammoValue.Changed:Connect(
            function()
                print("Ammo is value")
                if ammoValue.Value == 0 and Library.flags.autoReload then
                    print("Value is 0")

                    game:GetService("ReplicatedStorage").MainEvent:FireServer("Reload", v)
                end
            end
        )
    end
end

localPlayer.Character.ChildAdded:Connect(
    function(v)
        --- @type NumberValue
        local ammoValue = v:FindFirstChild("Ammo")
        if ammoValue then
            if ammoValue.Value == 0 and Library.flags.autoReload then
                game:GetService("ReplicatedStorage").MainEvent:FireServer("Reload", v)
            end
            ammoValue.Changed:Connect(
                function()
                    print("Ammo is value")
                    if ammoValue.Value == 0 and Library.flags.autoReload then
                        print("Value is 0")

                        game:GetService("ReplicatedStorage").MainEvent:FireServer("Reload", v)
                    end
                end
            )
        end
    end
)

runService.Heartbeat:Connect(
    function()
        if Library.flags.autoHospital then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(112, 25, -479)
            task.wait(0.3)
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
        if Library.flags.autoShoe then
            local shoeAmount = 0
            local untilSell = Library.flags.untilSell or 5

            local drops = game:GetService("Workspace").Ignored.Drop
            local sellPath =
                game:GetService("Workspace").Ignored["Clean the shoes on the floor and come to me for cash"]

            repeat
                if not Library.flags.autoShoe then
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

notify({Title = "Floppa Hub", Description = "Floppa Hub has loaded. Enjoy!", Duration = 8})

-- // Remove gradient
if game:GetService("CoreGui")["Floppa Hub"].main.top:FindFirstChild("UIGradient") then
    game:GetService("CoreGui")["Floppa Hub"].main.top.UIGradient:Destroy()
end
game:GetService("CoreGui")["Floppa Hub"].main.top.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
