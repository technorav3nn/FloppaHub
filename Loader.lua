local ScreenGui = Instance.new("ScreenGui")
local ImageLabel = Instance.new("ImageLabel")
local UICorner = Instance.new("UICorner")
local TextLabel = Instance.new("TextLabel")
local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

ScreenGui.Parent = game.CoreGui

ImageLabel.Parent = ScreenGui
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel.BackgroundTransparency = 1.000
ImageLabel.BorderSizePixel = 0
ImageLabel.Position = UDim2.new(0.423824966, 0, 0.337096781, 0)
ImageLabel.Size = UDim2.new(0.162074551, 0, 0.322580636, 0)
ImageLabel.Image = "http://www.roblox.com/asset/?id=6468533391"

UICorner.CornerRadius = UDim.new(0, 1000)
UICorner.Parent = ImageLabel

TextLabel.Parent = ImageLabel
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.Position = UDim2.new(0, 0, -0.25, 0)
TextLabel.Size = UDim2.new(1.00406837, 0, 0.25, 0)
TextLabel.Font = Enum.Font.RobotoMono
TextLabel.Text = "Floppa Hub"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 42.000
TextLabel.TextTransparency = 1.000

UIAspectRatioConstraint.Parent = ScreenGui
UIAspectRatioConstraint.AspectRatio = 1.990

local function EKHBDII_fake_script() -- ScreenGui.GUIHandler
    local script = Instance.new("LocalScript", ScreenGui)

    -- // Services
    local tweenService = game:GetService("TweenService")

    -- // Variables
    local gui = script.Parent
    local image = gui.ImageLabel
    local textLabel = image.TextLabel

    image.ImageTransparency = 1

    -- // Tweening
    local tween = tweenService:Create(image, TweenInfo.new(0.5), {ImageTransparency = 0})
    local tween2 = tweenService:Create(textLabel, TweenInfo.new(0.5), {TextTransparency = 0})

    tween:Play()
    tween2:Play()

    local blur = Instance.new("BlurEffect", game.Workspace.CurrentCamera)
    blur.Name = "BlurTwo"
    blur.Size = 0

    for i = 0, 100, 1 do
        print(i)
        blur.Size = i
        task.wait()
    end

    task.wait(2)

    local tween3 = tweenService:Create(image, TweenInfo.new(0.1), {ImageTransparency = 1})

    local tween4 = tweenService:Create(textLabel, TweenInfo.new(0.1), {TextTransparency = 1})

    for i = 100, 0, -3 do
        print(i)
        blur.Size = i
        task.wait()
    end

    tween3:Play()
    tween4:Play()

    blur:Destroy()
end
coroutine.wrap(EKHBDII_fake_script)()

local gamesTbl = {
    [1504680449] = "ClubDJ",
    [4958040666] = "SewerCity",
    [1537690962] = "BeeSwarmSim",
    [3527629287] = "BigPaintball",
    [5901346231] = "BoogaBoogaHybrid",
    [648362523] = "BreakingPoint",
    [4913581664] = "CartRideIntoRdite",
    [26838733] = "CatalogHeaven",
    [5490351219] = "ClickerMadness",
    [2788229376] = "DaHoodRemake",
    [361591023] = "DeadWinter",
    [6653967414] = "FloppyPlaytime",
    [4872321990] = "Islands",
    [112420803] = "KohlsAdminNBC",
    [391104146] = "LetsParty",
    [4169490976] = "MortemMetallum",
    [142823291] = "MurderMystery2",
    [3956818381] = "NinjaLegends",
    [6284583030] = "PetSimulatorX",
    [17541193] = "PinewoodComputerCore",
    [402122991] = "RedwoodPrison",
    [155382109] = "SAKTK.lua",
    [3725149043] = "SuperDoomspire",
    [192800] = "WorkAtAPizzaPlace"
}

local function httpGet(url)
    if syn then
        local req = syn.request({Url = url})
        return tostring(req.Body)
    else
        local httpService = game:GetService("HttpService")
        local req = httpService:RequestAsync({Url = url, Method = "GET"})
        return tostring(req.Body)
    end
end

local url = "https://raw.githubusercontent.com/technorav3nn/FloppaHub/master/games/%s.lua"
local game = gamesTbl[game.PlaceId]

url = string.format(url, game)

local success, src = pcall(httpGet, url)
if success then
    task.wait(4)
    loadstring(src)()
end
