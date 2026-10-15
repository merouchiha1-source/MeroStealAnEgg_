-- ====================================================
-- سكربت السرعة والقفز اللانهائي | Mero Uchiha Hub
-- المطور: مـــيـــرو اوتـــــــــشيها (Mero Uchiha)
-- ====================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

-- نسخ رابط الديسكورد تلقائياً للحافظة
pcall(function()
    if setclipboard then
        setclipboard("https://discord.gg/E7BTbVBsGy")
    end
    StarterGui:SetCore("SendNotification", {
        Title = "📋 Discord Copied!",
        Text = "تم نسخ رابط سيرفر الديسكورد تلقائياً!",
        Duration = 5
    })
end)

local SpeedActive = false
local InfJumpActive = false
local SpeedMultiplier = 1.5

-- بناء الواجهة
if CoreGui:FindFirstChild("MeroSpeedHub") then
    CoreGui.MeroSpeedHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MeroSpeedHub"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -110)
MainFrame.Size = UDim2.new(0, 280, 0, 210)
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(138, 43, 226)
MainStroke.Thickness = 2

local TitleFrame = Instance.new("Frame")
TitleFrame.Parent = MainFrame
TitleFrame.BackgroundColor3 = Color3.fromRGB(30, 33, 45)
TitleFrame.Size = UDim2.new(1, 0, 0, 40)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TitleFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Size = UDim2.new(1, -30, 1, 0)
TitleLabel.Font = Enum.Font.FredokaOne
TitleLabel.Text = "⚡ Mero Uchiha Hub"
TitleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
TitleLabel.TextSize = 15
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- زر السرعة الخارقة
local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Parent = MainFrame
SpeedBtn.BackgroundColor3 = Color3.fromRGB(35, 38, 52)
SpeedBtn.Position = UDim2.new(0, 15, 0, 55)
SpeedBtn.Size = UDim2.new(1, -30, 0, 45)
SpeedBtn.Font = Enum.Font.GothamBold
SpeedBtn.Text = "  سرعة خارقة ⚡"
SpeedBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
SpeedBtn.TextSize = 14
SpeedBtn.TextXAlignment = Enum.TextXAlignment.Left

local BtnUICorner1 = Instance.new("UICorner")
BtnUICorner1.CornerRadius = UDim.new(0, 8)
BtnUICorner1.Parent = SpeedBtn

SpeedBtn.MouseButton1Click:Connect(function()
    SpeedActive = not SpeedActive
    if SpeedActive then
        SpeedBtn.TextColor3 = Color3.fromRGB(0, 255, 128)
        SpeedBtn.Text = "  سرعة خارقة [شغال] ⚡"
    else
        SpeedBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
        SpeedBtn.Text = "  سرعة خارقة [متوقف] ⚡"
    end
end)

-- زر القفز اللانهائي
local InfJumpBtn = Instance.new("TextButton")
InfJumpBtn.Parent = MainFrame
InfJumpBtn.BackgroundColor3 = Color3.fromRGB(35, 38, 52)
InfJumpBtn.Position = UDim2.new(0, 15, 0, 115)
InfJumpBtn.Size = UDim2.new(1, -30, 0, 45)
InfJumpBtn.Font = Enum.Font.GothamBold
InfJumpBtn.Text = "  قفز لانهائي 🦘"
InfJumpBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
InfJumpBtn.TextSize = 14
InfJumpBtn.TextXAlignment = Enum.TextXAlignment.Left

local BtnUICorner2 = Instance.new("UICorner")
BtnUICorner2.CornerRadius = UDim.new(0, 8)
BtnUICorner2.Parent = InfJumpBtn

InfJumpBtn.MouseButton1Click:Connect(function()
    InfJumpActive = not InfJumpActive
    if InfJumpActive then
        InfJumpBtn.TextColor3 = Color3.fromRGB(0, 255, 128)
        InfJumpBtn.Text = "  قفز لانهائي [شغال] 🦘"
    else
        InfJumpBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
        InfJumpBtn.Text = "  قفز لانهائي [متوقف] 🦘"
    end
end)

-- تنفيذ السرعة
RunService.Heartbeat:Connect(function()
    if SpeedActive then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                if hum and root and hum.MoveDirection.Magnitude > 0 then
                    root.CFrame = root.CFrame + (hum.MoveDirection * SpeedMultiplier * 0.5)
                end
            end
        end)
    end
end)

-- تنفيذ القفز اللانهائي عند الضغط على زر المسافة (Space)
UserInputService.JumpRequest:Connect(function()
    if InfJumpActive then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    end
end)
