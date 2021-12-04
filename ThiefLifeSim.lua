local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/kav"))()
local Window = Library.CreateLib("TITLE", "BloodTheme")
local Tab = Window:NewTab("TabName")
local Section = Tab:NewSection("Section Name")
Section:NewButton(
    "ButtonText",
    "ButtonInfo",
    function()
        print("Clicked")
    end
)
button:UpdateButton("New Text")
Section:NewToggle(
    "ToggleText",
    "ToggleInfo",
    function(state)
        if state then
            print("Toggle On")
        else
            print("Toggle Off")
        end
    end
)
