-- ====================================================
-- سكربت سرقة البيض النظيف | Steal An Egg
-- المطور: مـــيـــرو اوتـــــــــشيها (Mero Uchiha)
-- ====================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local PromptService = game:GetService("ProximityPromptService")
local StarterGui = game:GetService("StarterGui")

-- نسخ رابط الديسكورد تلقائياً للحافظة عند التشغيل
pcall(function()
    if setclipboard then
        setclipboard("https://discord.gg/E7BTbVBsGy")
    end
    StarterGui:SetCore("SendNotification", {
        Title = "📋 Discord Copied!",
        Text = "تم نسخ رابط سيرفر الديسكورد إلى الحافظة تلقائياً!",
        Duration = 5
    })
end)

local SilentSleepActive = false
local SavedHoldDurations = {}
local ActiveConnections = {}

-- وظيفة تعديل الـ Prompts لتصير الفورية بدون تأخير
local function PatchPrompt(Prompt)
    if not (Prompt and typeof(Prompt) == "Instance" and Prompt:IsA("ProximityPrompt")) then
        return
    end
    if SilentSleepActive then
        if SavedHoldDurations[Prompt] == nil then
            SavedHoldDurations[Prompt] = Prompt.HoldDuration
        end
        Prompt.HoldDuration = 0
        Prompt.RequiresLineOfSight = false
    elseif SavedHoldDurations[Prompt] ~= nil then
        Prompt.HoldDuration = SavedHoldDurations[Prompt]
        SavedHoldDurations[Prompt] = nil
    end
end

local function SetPromptPatch(enabled)
    if enabled then
        for _, item in ipairs(Workspace:GetDescendants()) do
            PatchPrompt(item)
        end
        table.insert(ActiveConnections, Workspace.DescendantAdded:Connect(PatchPrompt))
        table.insert(ActiveConnections, PromptService.PromptShown:Connect(PatchPrompt))
    else
        for _, Connection in ipairs(ActiveConnections) do
            if Connection then Connection:Disconnect() end
        end
        ActiveConnections = {}
        for Prompt, duration in pairs(SavedHoldDurations) do
            if Prompt and Prompt.Parent then
                Prompt.HoldDuration = duration
            end
        end
        SavedHoldDurations = {}
    end
end

local function ToggleSilentSleep(state)
    SilentSleepActive = state
    SetPromptPatch(state)
end

-- ====================================================
-- بناء الواجهة الخفيفة والمرتبة
-- ====================================================

if CoreGui:FindFirstChild("MeroEggHub") then
    CoreGui.MeroEggHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MeroEggHub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -110)
MainFrame.Size = UDim2.new(0, 280, 0, 180)
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(138, 43, 226)
MainStroke.Thickness = 2

local TitleFrame = Instance.new("Frame")
TitleFrame.Name = "TitleFrame"
TitleFrame.Parent = MainFrame
TitleFrame.BackgroundColor3 = Color3.fromRGB(30, 33, 45)
TitleFrame.BorderSizePixel = 0
TitleFrame.Size = UDim2.new(1, 0, 0, 45)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = TitleFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Size = UDim2.new(1, -30, 1, 0)
TitleLabel.Font = Enum.Font.FredokaOne
TitleLabel.Text = "🥚 Steal An Egg | Mero"
TitleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
TitleLabel.TextSize = 15
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- زر الإخفاء والإظهار العائم
local OpenCloseBtn = Instance.new("TextButton")
OpenCloseBtn.Name = "OpenCloseBtn"
OpenCloseBtn.Parent = ScreenGui
OpenCloseBtn.BackgroundColor3 = Color3.fromRGB(30, 33, 45)
OpenCloseBtn.Position = UDim2.new(0, 10, 0.5, -25)
OpenCloseBtn.Size = UDim2.new(0, 45, 0, 45)
OpenCloseBtn.Font = Enum.Font.FredokaOne
OpenCloseBtn.Text = "🥚"
OpenCloseBtn.TextSize = 22
OpenCloseBtn.Draggable = true

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 22)
BtnCorner.Parent = OpenCloseBtn

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Parent = OpenCloseBtn
BtnStroke.Color = Color3.fromRGB(138, 43, 226)
BtnStroke.Thickness = 2

OpenCloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- سحب الواجهة
local dragging, dragInput, dragStart, startPos
TitleFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- زر التفعيل وتغيير الاسم
local Button = Instance.new("TextButton")
Button.Name = "ToggleBtn"
Button.Parent = MainFrame
Button.BackgroundColor3 = Color3.fromRGB(35, 38, 52)
Button.BorderSizePixel = 0
Button.Position = UDim2.new(0, 15, 0, 65)
Button.Size = UDim2.new(1, -30, 0, 50)
Button.AutoButtonColor = false
Button.Font = Enum.Font.GothamBold
Button.Text = "  إبقاء الحيوان نائم 😴⚡"
Button.TextColor3 = Color3.fromRGB(220, 220, 220)
Button.TextSize = 14
Button.TextXAlignment = Enum.TextXAlignment.Left

local BtnUICorner = Instance.new("UICorner")
BtnUICorner.CornerRadius = UDim.new(0, 8)
BtnUICorner.Parent = Button

local StatusBox = Instance.new("Frame")
StatusBox.Name = "StatusBox"
StatusBox.Parent = Button
StatusBox.AnchorPoint = Vector2.new(1, 0.5)
StatusBox.Position = UDim2.new(1, -12, 0.5, 0)
StatusBox.Size = UDim2.new(0, 45, 0, 24)
StatusBox.BackgroundColor3 = Color3.fromRGB(255, 60, 60)

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 12)
StatusCorner.Parent = StatusBox

-- نقطة التفعيل
local Dot = Instance.new("Frame")
Dot.Name = "Dot"
Dot.Parent = StatusBox
Dot.AnchorPoint = Vector2.new(0, 0.5)
Dot.Position = UDim2.new(0, 3, 0.5, 0)
Dot.Size = UDim2.new(0, 18, 0, 18)
Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

local DotCorner = Instance.new("UICorner")
DotCorner.CornerRadius = UDim.new(0, 9)
DotCorner.Parent = Dot

local isToggled = false

Button.MouseButton1Click:Connect(function()
    isToggled = not isToggled
    
    if isToggled then
        TweenService:Create(StatusBox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 255, 128)}):Play()
        TweenService:Create(Dot, TweenInfo.new(0.2), {Position = UDim2.new(1, -21, 0.5, 0)}):Play()
    else
        TweenService:Create(StatusBox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 60, 60)}):Play()
        TweenService:Create(Dot, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, 0)}):Play()
    end

    ToggleSilentSleep(isToggled)
end)
