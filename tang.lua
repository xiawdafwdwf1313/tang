-- 唐脚本 v7.0（完整修复版）
-- 功能：通用 | MM2 | Peta | 飞行 | 甩飞 | 僵尸塔 | 森林·99夜 | 简介

repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")

-- ============================================================
--  启动动画
-- ============================================================
local splashGui = Instance.new("ScreenGui")
splashGui.Name = "SplashScreen"
splashGui.ResetOnSpawn = false
splashGui.Parent = player:WaitForChild("PlayerGui")
splashGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local container = Instance.new("Frame")
container.Size = UDim2.new(0, 420, 0, 240)
container.Position = UDim2.new(0.5, -210, 0.5, -120)
container.BackgroundTransparency = 1
container.Parent = splashGui

local ringContainer = Instance.new("Frame")
ringContainer.Size = UDim2.new(0, 300, 0, 300)
ringContainer.Position = UDim2.new(0.5, -150, 0.5, -150)
ringContainer.BackgroundTransparency = 1
ringContainer.ZIndex = 0
ringContainer.Parent = container

local blockCount, radius = 20, 120
local blocks, blockColors = {}, {Color3.fromRGB(255,255,255), Color3.fromRGB(200,230,255), Color3.fromRGB(180,210,255)}
for i=1, blockCount do
    local angle = (i-1)/blockCount*2*math.pi
    local x, y = radius*math.cos(angle), radius*math.sin(angle)
    local block = Instance.new("Frame")
    block.Size = UDim2.new(0,12,0,12)
    block.Position = UDim2.new(0.5,x-6,0.5,y-6)
    block.BackgroundColor3 = blockColors[(i%3)+1]
    block.BackgroundTransparency = 0.2
    block.BorderSizePixel = 0
    block.ZIndex = 0
    block.Parent = ringContainer
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,3)
    corner.Parent = block
    block:SetAttribute("Angle", angle)
    table.insert(blocks, block)
end

local outerBlocks, innerBlocks = {}, {}
for i=1,16 do
    local angle = (i-1)/16*2*math.pi + 0.3
    local x,y = (radius+25)*math.cos(angle), (radius+25)*math.sin(angle)
    local block = Instance.new("Frame")
    block.Size = UDim2.new(0,6,0,6)
    block.Position = UDim2.new(0.5,x-3,0.5,y-3)
    block.BackgroundColor3 = Color3.fromRGB(150,200,255)
    block.BackgroundTransparency = 0.7
    block.BorderSizePixel = 0
    block.ZIndex = 0
    block.Parent = ringContainer
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,2)
    corner.Parent = block
    table.insert(outerBlocks, block)
end
for i=1,12 do
    local angle = (i-1)/12*2*math.pi + 0.6
    local x,y = (radius-30)*math.cos(angle), (radius-30)*math.sin(angle)
    local block = Instance.new("Frame")
    block.Size = UDim2.new(0,4,0,4)
    block.Position = UDim2.new(0.5,x-2,0.5,y-2)
    block.BackgroundColor3 = Color3.fromRGB(255,255,255)
    block.BackgroundTransparency = 0.8
    block.BorderSizePixel = 0
    block.ZIndex = 0
    block.Parent = ringContainer
    table.insert(innerBlocks, block)
end

local percentLabel = Instance.new("TextLabel")
percentLabel.Size = UDim2.new(0,120,0,50)
percentLabel.Position = UDim2.new(0.5,-60,0.5,30)
percentLabel.BackgroundTransparency = 1
percentLabel.Text = "0%"
percentLabel.TextColor3 = Color3.fromRGB(255,255,255)
percentLabel.TextSize = 36
percentLabel.Font = Enum.Font.GothamBold
percentLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
percentLabel.TextStrokeTransparency = 0.3
percentLabel.Parent = container

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0,200,0,4)
progressBar.Position = UDim2.new(0.5,-100,0.5,75)
progressBar.BackgroundColor3 = Color3.fromRGB(60,60,80)
progressBar.BorderSizePixel = 0
progressBar.Parent = container
local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(1,0)
barCorner.Parent = progressBar
local fill = Instance.new("Frame")
fill.Size = UDim2.new(0,0,1,0)
fill.BackgroundColor3 = Color3.fromRGB(100,200,255)
fill.BorderSizePixel = 0
fill.Parent = progressBar
local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1,0)
fillCorner.Parent = fill

local letters, labels, hueOffsets = {"T","A","N","G"}, {}, {0,0.15,0.30,0.45}
for i, char in ipairs(letters) do
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0,80,0,100)
    lbl.Position = UDim2.new(0,(i-1)*100+30,0,55)
    lbl.BackgroundTransparency = 1
    lbl.Text = char
    lbl.TextColor3 = Color3.fromHSV((i-1)/4,1,1)
    lbl.TextSize = 80
    lbl.Font = Enum.Font.GothamBold
    lbl.TextScaled = true
    lbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    lbl.TextStrokeTransparency = 0
    lbl.TextTransparency = 0
    lbl.Parent = container
    table.insert(labels, lbl)
end

local running = true
task.spawn(function()
    local t = 0
    while running do
        t = t + 0.02
        for i, lbl in ipairs(labels) do
            local hue = (t + hueOffsets[i]) % 1
            lbl.TextColor3 = Color3.fromHSV(hue, 1, 1)
        end
        task.wait(0.03)
    end
end)
task.spawn(function()
    while running do
        ringContainer.Rotation = (ringContainer.Rotation + 1.8) % 360
        task.wait(0.02)
    end
end)
task.spawn(function()
    local time = 0
    while running do
        time = time + 0.04
        for i, block in ipairs(blocks) do
            local scale = 0.8 + 0.4 * math.sin(time + i * 0.5)
            block.Size = UDim2.new(0, 12 * scale, 0, 12 * scale)
            local alpha = 0.2 + 0.3 * math.sin(time * 0.8 + i)
            block.BackgroundTransparency = 1 - alpha
        end
        for i, block in ipairs(outerBlocks) do
            local alpha = 0.6 + 0.3 * math.sin(time * 1.2 + i * 0.7)
            block.BackgroundTransparency = 1 - alpha
        end
        task.wait(0.05)
    end
end)
task.spawn(function()
    local duration, startTime = 3.5, tick()
    while running do
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / duration, 1)
        local percent = math.floor(progress * 100)
        percentLabel.Text = percent .. "%"
        fill.Size = UDim2.new(progress, 0, 1, 0)
        local hue = 0.6 - progress * 0.3
        percentLabel.TextColor3 = Color3.fromHSV(hue, 0.8, 1)
        if progress >= 1 then break end
        task.wait(0.05)
    end
end)

-- ============================================================
--  主窗口
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "TangScript"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Enabled = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = gui
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(50, 150, 255)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -175)
mainFrame.Size = UDim2.new(0, 600, 0, 350)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false

local corner = Instance.new("UICorner")
corner.Parent = mainFrame
corner.CornerRadius = UDim.new(0,8)

local borderStroke = Instance.new("UIStroke")
borderStroke.Thickness = 2
borderStroke.Parent = mainFrame
task.spawn(function()
    local hue = 0
    while borderStroke and borderStroke.Parent do
        hue = (hue + 0.005) % 1
        borderStroke.Color = Color3.fromHSV(hue, 1, 1)
        task.wait(0.05)
    end
end)

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1,0,0,28)
titleBar.BackgroundColor3 = Color3.fromRGB(18, 22, 42)
titleBar.BackgroundTransparency = 0.15
titleBar.BorderSizePixel = 0
titleBar.Active = true
titleBar.Draggable = true

local titleCorner = Instance.new("UICorner")
titleCorner.Parent = titleBar
titleCorner.CornerRadius = UDim.new(0,6)

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = titleBar
titleLabel.Size = UDim2.new(0.6,0,1,0)
titleLabel.Position = UDim2.new(0,10,0,0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "唐脚本 v7.0"
titleLabel.TextColor3 = Color3.fromRGB(30,200,255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local minBtn = Instance.new("TextButton")
minBtn.Parent = titleBar
minBtn.Size = UDim2.new(0, 22, 0, 22)
minBtn.Position = UDim2.new(1, -75, 0.5, -11)
minBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
minBtn.BackgroundTransparency = 0.3
minBtn.Text = "−"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextSize = 18
minBtn.Font = Enum.Font.GothamBold
minBtn.BorderSizePixel = 0
local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(1,0)
minCorner.Parent = minBtn

local maxBtn = Instance.new("TextButton")
maxBtn.Parent = titleBar
maxBtn.Size = UDim2.new(0, 22, 0, 22)
maxBtn.Position = UDim2.new(1, -50, 0.5, -11)
maxBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
maxBtn.BackgroundTransparency = 0.3
maxBtn.Text = "+"
maxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
maxBtn.TextSize = 18
maxBtn.Font = Enum.Font.GothamBold
maxBtn.BorderSizePixel = 0
local maxCorner = Instance.new("UICorner")
maxCorner.CornerRadius = UDim.new(1,0)
maxCorner.Parent = maxBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = titleBar
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -25, 0.5, -11)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1,0)
closeCorner.Parent = closeBtn

local isMinimized = false
local normalSize = UDim2.new(0, 600, 0, 350)
local minimizedSize = UDim2.new(0, 200, 0, 28)
local normalPos = UDim2.new(0.5, -300, 0.5, -175)
local minimizedPos = UDim2.new(0, 10, 0, 10)

minBtn.MouseButton1Click:Connect(function()
    if isMinimized then
        mainFrame.Size = normalSize
        mainFrame.Position = normalPos
        mainFrame.BackgroundTransparency = 0.15
        isMinimized = false
        minBtn.Text = "−"
    else
        mainFrame.Size = minimizedSize
        mainFrame.Position = minimizedPos
        mainFrame.BackgroundTransparency = 0.8
        isMinimized = true
        minBtn.Text = "+"
    end
end)

maxBtn.MouseButton1Click:Connect(function()
    if isMinimized then
        mainFrame.Size = normalSize
        mainFrame.Position = normalPos
        mainFrame.BackgroundTransparency = 0.15
        isMinimized = false
        minBtn.Text = "−"
    else
        mainFrame.Size = minimizedSize
        mainFrame.Position = minimizedPos
        mainFrame.BackgroundTransparency = 0.8
        isMinimized = true
        minBtn.Text = "+"
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if titleBar:GetAttribute("LastClick") and tick() - titleBar:GetAttribute("LastClick") < 0.3 then
            if isMinimized then
                mainFrame.Size = normalSize
                mainFrame.Position = normalPos
                mainFrame.BackgroundTransparency = 0.15
                isMinimized = false
                minBtn.Text = "−"
            else
                mainFrame.Size = minimizedSize
                mainFrame.Position = minimizedPos
                mainFrame.BackgroundTransparency = 0.8
                isMinimized = true
                minBtn.Text = "+"
            end
            titleBar:SetAttribute("LastClick", 0)
        else
            titleBar:SetAttribute("LastClick", tick())
        end
    end
end)

-- ============================================================
--  侧栏与内容区域
-- ============================================================
local contentFrame = Instance.new("Frame")
contentFrame.Parent = mainFrame
contentFrame.Size = UDim2.new(1,0,1,-28)
contentFrame.Position = UDim2.new(0,0,0,28)
contentFrame.BackgroundTransparency = 1

local sideBar = Instance.new("Frame")
sideBar.Parent = contentFrame
sideBar.Size = UDim2.new(0,70,1,0)
sideBar.Position = UDim2.new(0,0,0,0)
sideBar.BackgroundColor3 = Color3.fromRGB(10,14,28)
sideBar.BackgroundTransparency = 0.5
sideBar.BorderSizePixel = 0

local panelContainer = Instance.new("Frame")
panelContainer.Parent = contentFrame
panelContainer.Size = UDim2.new(1,-70,1,0)
panelContainer.Position = UDim2.new(0,70,0,0)
panelContainer.BackgroundTransparency = 1

local panel = Instance.new("ScrollingFrame")
panel.Parent = panelContainer
panel.Size = UDim2.new(1,-8,1,-4)
panel.Position = UDim2.new(0,4,0,2)
panel.BackgroundTransparency = 1
panel.CanvasSize = UDim2.new(0,0,0,0)
panel.ScrollBarThickness = 2

local btnNames = {"通用","MM2","Peta","飞行","甩飞","僵尸塔","森林·99夜","简介"}
local btnList = {}

for i,name in ipairs(btnNames) do
    local btn = Instance.new("TextButton")
    btn.Parent = sideBar
    btn.Size = UDim2.new(0.8,0,0,26)
    btn.Position = UDim2.new(0.1,0,0.03+(i-1)*0.10,0)
    btn.BackgroundColor3 = (i==1) and Color3.fromRGB(30,200,255) or Color3.fromRGB(20,40,60)
    btn.BackgroundTransparency = 0.6
    btn.BorderSizePixel = 1
    btn.BorderColor3 = (i==1) and Color3.fromRGB(30,200,255) or Color3.fromRGB(50,50,70)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamSemibold
    local c = Instance.new("UICorner")
    c.Parent = btn
    c.CornerRadius = UDim.new(0,2)
    btnList[i] = btn
end

-- ============================================================
--  辅助函数
-- ============================================================
local function clearPanel()
    for _,v in pairs(panel:GetChildren()) do
        v:Destroy()
    end
    panel.CanvasSize = UDim2.new(0,0,0,0)
end

local function addToggle(text, default, cb)
    local state = default
    local y = #panel:GetChildren() * 32 + 4
    local bg = Instance.new("Frame")
    bg.Parent = panel
    bg.Size = UDim2.new(1,-4,0,30)
    bg.Position = UDim2.new(0,2,0,y)
    bg.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
    bg.BackgroundTransparency = 0.5
    bg.BorderSizePixel = 1
    bg.BorderColor3 = state and Color3.fromRGB(30,200,255) or Color3.fromRGB(40,45,65)
    local bgc = Instance.new("UICorner")
    bgc.Parent = bg
    bgc.CornerRadius = UDim.new(0,4)

    local lbl = Instance.new("TextLabel")
    lbl.Parent = bg
    lbl.Size = UDim2.new(0.65,0,1,0)
    lbl.Position = UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local track = Instance.new("Frame")
    track.Parent = bg
    track.Size = UDim2.new(0,34,0,18)
    track.Position = UDim2.new(1,-44,0.5,-9)
    track.BackgroundColor3 = state and Color3.fromRGB(30,200,255) or Color3.fromRGB(40,45,65)
    track.BackgroundTransparency = 0.3
    track.BorderSizePixel = 1
    track.BorderColor3 = state and Color3.fromRGB(30,200,255) or Color3.fromRGB(50,55,75)
    local tc = Instance.new("UICorner")
    tc.Parent = track
    tc.CornerRadius = UDim.new(1,0)

    local ball = Instance.new("Frame")
    ball.Parent = track
    ball.Size = UDim2.new(0,12,0,12)
    ball.Position = state and UDim2.new(1,-14,0.5,-6) or UDim2.new(0,2,0.5,-6)
    ball.BackgroundColor3 = state and Color3.fromRGB(30,200,255) or Color3.fromRGB(80,90,120)
    ball.BackgroundTransparency = 0.2
    ball.BorderSizePixel = 0
    local bc = Instance.new("UICorner")
    bc.Parent = ball
    bc.CornerRadius = UDim.new(1,0)

    local click = Instance.new("TextButton")
    click.Parent = bg
    click.Size = UDim2.new(1,0,1,0)
    click.BackgroundTransparency = 1
    click.Text = ""
    click.MouseButton1Click:Connect(function()
        state = not state
        bg.BorderColor3 = state and Color3.fromRGB(30,200,255) or Color3.fromRGB(40,45,65)
        track.BackgroundColor3 = state and Color3.fromRGB(30,200,255) or Color3.fromRGB(40,45,65)
        track.BorderColor3 = state and Color3.fromRGB(30,200,255) or Color3.fromRGB(50,55,75)
        ball.Position = state and UDim2.new(1,-14,0.5,-6) or UDim2.new(0,2,0.5,-6)
        ball.BackgroundColor3 = state and Color3.fromRGB(30,200,255) or Color3.fromRGB(80,90,120)
        cb(state)
    end)
end

local function addButton(text, color, cb)
    local y = #panel:GetChildren() * 32 + 4
    local bg = Instance.new("Frame")
    bg.Parent = panel
    bg.Size = UDim2.new(1,-4,0,30)
    bg.Position = UDim2.new(0,2,0,y)
    bg.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
    bg.BackgroundTransparency = 0.5
    bg.BorderSizePixel = 1
    bg.BorderColor3 = color or Color3.fromRGB(40,45,65)
    local bgc = Instance.new("UICorner")
    bgc.Parent = bg
    bgc.CornerRadius = UDim.new(0,4)

    local btn = Instance.new("TextButton")
    btn.Parent = bg
    btn.Size = UDim2.new(1,0,1,0)
    btn.Position = UDim2.new(0,0,0,0)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    btn.MouseButton1Click:Connect(cb)
end

local function addLabel(text)
    local y = #panel:GetChildren() * 32 + 4
    local lbl = Instance.new("TextLabel")
    lbl.Parent = panel
    lbl.Size = UDim2.new(1,-4,0,20)
    lbl.Position = UDim2.new(0,2,0,y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return lbl
end

local function addDivider()
    local y = #panel:GetChildren() * 32 + 4
    local d = Instance.new("Frame")
    d.Parent = panel
    d.Size = UDim2.new(1,-20,0,1)
    d.Position = UDim2.new(0,10,0,y)
    d.BackgroundColor3 = Color3.fromRGB(30,200,255)
    d.BackgroundTransparency = 0.6
    d.BorderSizePixel = 0
end

local function addTitle(text)
    local y = #panel:GetChildren() * 32 + 4
    local lbl = Instance.new("TextLabel")
    lbl.Parent = panel
    lbl.Size = UDim2.new(1,-4,0,20)
    lbl.Position = UDim2.new(0,2,0,y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return lbl
end

-- ============================================================
--  面板：通用（完整功能）
-- ============================================================
local function loadGeneral()
    clearPanel()
    addTitle("⚙️ 通用设置")

    -- 坠落保护
    local fallDamageOff = false
    local fallConn = nil
    local charAddedConn = nil

    local function setupFallProtection(character)
        if fallConn then fallConn:Disconnect() end
        if not fallDamageOff then return end
        local hum = character and character:FindFirstChildOfClass("Humanoid")
        if hum then
            fallConn = hum.StateChanged:Connect(function(oldState, newState)
                if newState == Enum.HumanoidStateType.FallingDown then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
        end
    end

    addToggle("取消坠落伤害", false, function(s)
        fallDamageOff = s
        if s then
            setupFallProtection(player.Character)
            if not charAddedConn then
                charAddedConn = player.CharacterAdded:Connect(function(newChar)
                    setupFallProtection(newChar)
                end)
            end
            print("✅ 坠落保护已开启")
        else
            if fallConn then fallConn:Disconnect() end
            if charAddedConn then charAddedConn:Disconnect() end
            print("❌ 坠落保护已关闭")
        end
    end)

    addDivider()

    -- 飞行系统
    addTitle("✈️ 飞行系统")

    local flying = false
    local flyspeed = 80
    local default_flyspeed = 80
    local bv = nil
    local bg = nil
    local flyConn = nil

    local function startFly()
        local c = player.Character
        if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        c.Humanoid.PlatformStand = true
        c.Humanoid.WalkSpeed = 0
        c.Humanoid.JumpPower = 0
        bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(9e4, 9e4, 9e4)
        bv.Velocity = Vector3.new(0, 0, 0)
        bg = Instance.new("BodyGyro", hrp)
        bg.MaxTorque = Vector3.new(9e4, 9e4, 9e4)
        bg.P = 9e4
        bg.CFrame = hrp.CFrame
        flying = true
        flyConn = runService.Stepped:Connect(function()
            if not flying then
                flyConn:Disconnect()
                if bv then bv:Destroy(); bv = nil end
                if bg then bg:Destroy(); bg = nil end
                return
            end
            local c2 = player.Character
            if not c2 then return end
            local hrp2 = c2:FindFirstChild("HumanoidRootPart")
            if not hrp2 then return end
            local cam = workspace.CurrentCamera
            if not cam then return end
            local f = userInput:IsKeyDown(Enum.KeyCode.W) and 1 or 0
            local b = userInput:IsKeyDown(Enum.KeyCode.S) and 1 or 0
            local r = userInput:IsKeyDown(Enum.KeyCode.D) and 1 or 0
            local l = userInput:IsKeyDown(Enum.KeyCode.A) and 1 or 0
            local u = userInput:IsKeyDown(Enum.KeyCode.Space) and 1 or 0
            local d = userInput:IsKeyDown(Enum.KeyCode.LeftControl) and 1 or 0
            local camLook = cam.CFrame.LookVector
            local camRight = cam.CFrame.RightVector
            local camUp = cam.CFrame.UpVector
            bv.Velocity = (camLook * ((f - b) * flyspeed)) + (camRight * ((r - l) * flyspeed)) + (camUp * ((u - d) * flyspeed))
            bg.CFrame = cam.CFrame
        end)
    end

    local function stopFly()
        flying = false
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        if bv then bv:Destroy(); bv = nil end
        if bg then bg:Destroy(); bg = nil end
        local c = player.Character
        if c then
            c.Humanoid.PlatformStand = false
            c.Humanoid.WalkSpeed = 16
            c.Humanoid.JumpPower = 50
        end
    end

    addToggle("飞行模式 (WASD/空格/Shift)", false, function(s)
        if s then startFly() else stopFly() end
    end)

    local speedLabel = addLabel("当前速度: 80")
    addButton("速度 +25", Color3.fromRGB(60, 180, 60), function()
        flyspeed = math.min(flyspeed + 25, 500)
        speedLabel.Text = "当前速度: " .. flyspeed
    end)
    addButton("速度 -25", Color3.fromRGB(180, 60, 60), function()
        flyspeed = math.max(flyspeed - 25, 1)
        speedLabel.Text = "当前速度: " .. flyspeed
    end)
    addButton("重置速度", Color3.fromRGB(60, 120, 180), function()
        flyspeed = default_flyspeed
        speedLabel.Text = "当前速度: " .. flyspeed
    end)

    addDivider()

    -- 隐身模式
    addTitle("👻 隐身模式")

    local invisible_enabled = false
    local random = Random.new()
    local invisModel = nil
    local invisPart = nil
    local invisBg = nil
    local invisBv = nil
    local invisConn = nil
    local invisHum = nil

    local function startInvisible()
        local c = player.Character
        if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local hum = c:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        invisible_enabled = true
        invisModel = Instance.new("Model")
        invisPart = Instance.new("Part")
        invisHum = Instance.new("Humanoid")

        invisPart.CFrame = hrp.CFrame
        invisPart.Transparency = 0.5
        invisPart.BrickColor = BrickColor.new("Really red")
        invisPart.Material = Enum.Material.ForceField
        invisPart.Size = hrp.Size
        invisPart.CanCollide = false
        invisPart.Name = "HumanoidRootPart"
        invisPart.Parent = invisModel
        invisHum.Parent = invisModel
        invisModel.Parent = workspace
        workspace.CurrentCamera.CameraSubject = invisHum

        invisBv = Instance.new("BodyVelocity", invisPart)
        invisBv.MaxForce = Vector3.new(9e4, 9e4, 9e4)
        invisBv.Velocity = Vector3.new(0, 0, 0)

        invisBg = Instance.new("BodyGyro", invisPart)
        invisBg.MaxTorque = Vector3.new(9e4, 9e4, 9e4)
        invisBg.P = 9e4
        invisBg.CFrame = hrp.CFrame

        local hiddenPos = Vector3.new(
            random:NextNumber(-999999, 999999),
            random:NextNumber(0, 999999),
            random:NextNumber(-999999, 999999)
        )
        hrp.CFrame = CFrame.new(hiddenPos)
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

        invisConn = runService.Stepped:Connect(function()
            if not invisible_enabled then
                invisConn:Disconnect()
                if invisPart then
                    hrp.CFrame = invisPart.CFrame
                    hrp.AssemblyLinearVelocity = invisPart.AssemblyLinearVelocity
                    invisModel:Destroy()
                end
                workspace.CurrentCamera.CameraSubject = player.Character:FindFirstChildOfClass("Humanoid")
                return
            end
            local cam = workspace.CurrentCamera
            if not cam then return end
            local f = userInput:IsKeyDown(Enum.KeyCode.W) and 1 or 0
            local b = userInput:IsKeyDown(Enum.KeyCode.S) and 1 or 0
            local r = userInput:IsKeyDown(Enum.KeyCode.D) and 1 or 0
            local l = userInput:IsKeyDown(Enum.KeyCode.A) and 1 or 0
            local u = userInput:IsKeyDown(Enum.KeyCode.Space) and 1 or 0
            local d = userInput:IsKeyDown(Enum.KeyCode.LeftControl) and 1 or 0
            local camLook = cam.CFrame.LookVector
            local camRight = cam.CFrame.RightVector
            local camUp = cam.CFrame.UpVector
            invisBv.Velocity = (camLook * ((f - b) * flyspeed)) + (camRight * ((r - l) * flyspeed)) + (camUp * ((u - d) * flyspeed))
            invisBg.CFrame = cam.CFrame
        end)
    end

    local function stopInvisible()
        invisible_enabled = false
        if invisConn then invisConn:Disconnect(); invisConn = nil end
        if invisBv then invisBv:Destroy(); invisBv = nil end
        if invisBg then invisBg:Destroy(); invisBg = nil end
        local c = player.Character
        if c and invisPart then
            local hrp = c:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = invisPart.CFrame
                hrp.AssemblyLinearVelocity = invisPart.AssemblyLinearVelocity
            end
        end
        if invisModel then invisModel:Destroy(); invisModel = nil end
        invisPart = nil
        invisHum = nil
        local c2 = player.Character
        if c2 then
            local hum = c2:FindFirstChildOfClass("Humanoid")
            if hum then
                workspace.CurrentCamera.CameraSubject = hum
            end
        end
    end

    addToggle("隐身模式 (假身替身)", false, function(s)
        if s then startInvisible() else stopInvisible() end
    end)

    -- ===== 人称切换（强制版） =====
    addDivider()
    addTitle("🎥 人称控制")

    local cameraMode = "第三人称"
    local cam = workspace.CurrentCamera

    local function setCameraMode(mode)
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local head = char:FindFirstChild("Head")

        cameraMode = mode

        if mode == "第一人称" then
            cam.CameraType = Enum.CameraType.Attach
            cam.CameraSubject = head or hum
            hum.CameraOffset = Vector3.new(0, 0, 0)
            print("🎥 已切换到: 第一人称")
        elseif mode == "第三人称" then
            cam.CameraType = Enum.CameraType.Custom
            cam.CameraSubject = hum
            hum.CameraOffset = Vector3.new(0, 0, 0)
            print("🎥 已切换到: 第三人称")
        else
            cam.CameraType = Enum.CameraType.Custom
            cam.CameraSubject = hum
            hum.CameraOffset = Vector3.new(0, 0, 0)
            print("🎥 已切换到: 自由模式")
        end
    end

    -- 角色重生后保持
    local function onCharAdded(char)
        task.wait(0.5)
        if cameraMode == "第一人称" then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local head = char:FindFirstChild("Head")
            cam.CameraType = Enum.CameraType.Attach
            cam.CameraSubject = head or hum
        elseif cameraMode == "第三人称" then
            local hum = char:FindFirstChildOfClass("Humanoid")
            cam.CameraType = Enum.CameraType.Custom
            cam.CameraSubject = hum
        end
    end

    player.CharacterAdded:Connect(onCharAdded)

    local modeLabel = addLabel("当前人称: 第三人称")

    addButton("👤 强制第一人称", Color3.fromRGB(100, 200, 255), function()
        setCameraMode("第一人称")
        modeLabel.Text = "当前人称: 第一人称"
    end)

    addButton("👥 强制第三人称", Color3.fromRGB(100, 200, 255), function()
        setCameraMode("第三人称")
        modeLabel.Text = "当前人称: 第三人称"
    end)

    addButton("🔄 自由模式", Color3.fromRGB(150, 150, 150), function()
        setCameraMode("自由")
        modeLabel.Text = "当前人称: 自由模式"
    end)

    addDivider()
    addTitle("🧱 其他功能")

    addToggle("穿墙", false, function(s)
        if s then
            runService.Stepped:Connect(function()
                if s and player.Character then
                    player.Character.Humanoid:ChangeState(11)
                end
            end)
        end
    end)

    addToggle("无限跳", false, function(s)
        userInput.JumpRequest:Connect(function()
            if s and player.Character then
                player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end)
    end)

    panel.CanvasSize = UDim2.new(0, 0, 0, #panel:GetChildren() * 32 + 20)
end

-- ============================================================
--  面板：飞行（已合并到通用）
-- ============================================================
local function loadFlight()
    clearPanel()
    addTitle("✈️ 飞行功能已迁移")
    addLabel("飞行功能已移至【通用】面板")
    panel.CanvasSize = UDim2.new(0, 0, 0, #panel:GetChildren() * 32 + 20)
end
-- ============================================================
--  面板：Peta（完整增强版）
-- ============================================================
local function loadPeta()
    clearPanel()
    addTitle("🧬 Peta 透视辅助")

    local function applyHighlight(instance, color)
        if not instance or not instance:IsA("BasePart") then return end
        for _, child in pairs(instance:GetChildren()) do
            if child:IsA("Highlight") then child:Destroy() end
        end
        local hl = Instance.new("Highlight")
        hl.Name = "PetaHighlight"
        hl.FillColor = color
        hl.FillTransparency = 0.6
        hl.OutlineColor = color
        hl.OutlineTransparency = 0.2
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = instance
        return hl
    end

    local function removeHighlights()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Highlight") and obj.Name == "PetaHighlight" then
                obj:Destroy()
            end
        end
    end

    local function scanOnce(keywords, color, label)
        removeHighlights()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local n = obj.Name:lower()
                for _, kw in ipairs(keywords) do
                    if n:find(kw) then
                        if not obj:FindFirstAncestorOfClass("Model") or
                           not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                            applyHighlight(obj, color)
                        end
                        break
                    end
                end
            end
        end
        print("🔍 已扫描: " .. label)
    end

    -- 🔑 钥匙透视（增强版）
    addToggle("🔑 钥匙透视（全部）", false, function(s)
        if s then
            removeHighlights()
            local keyKeywords = {
                "key", "keys", "key_", "key-", "keychain", "keyring",
                "wooden", "metal", "gold", "silver", "rusty", "old",
                "master", "skeleton", "lock", "door", "gate", "chest",
                "GetKey", "KeyItem", "KeyObject", "KeyPart",
                "钥匙", "钥匙串", "钥匙扣", "门钥匙", "宝箱钥匙",
                "木制钥匙", "木质钥匙", "金属钥匙", "金钥匙", "银钥匙",
                "铜钥匙", "铁钥匙", "生锈钥匙", "旧钥匙", "万能钥匙",
                "任务钥匙", "神秘钥匙", "古老钥匙", "魔法钥匙",
                "木钥匙", "钥", "匙",
                "woodenkey", "metalkey", "goldkey", "silverkey",
                "rustykey", "oldkey", "masterkey", "skeletonkey"
            }
            local count = 0
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local n = obj.Name:lower()
                    local found = false
                    for _, kw in ipairs(keyKeywords) do
                        if n:find(kw) then found = true; break end
                    end
                    if not found and obj.Parent and obj.Parent:IsA("Model") then
                        local pn = obj.Parent.Name:lower()
                        for _, kw in ipairs(keyKeywords) do
                            if pn:find(kw) then found = true; break end
                        end
                    end
                    if not found then
                        local name = obj.Name
                        if name:sub(1,3):lower() == "key" or name:sub(1,2):lower() == "ky" then
                            found = true
                        end
                    end
                    if found then
                        if not obj:FindFirstAncestorOfClass("Model") or
                           not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                            applyHighlight(obj, Color3.fromRGB(255, 215, 0))
                            count = count + 1
                        end
                    end
                end
            end
            print("🔍 已扫描: 全部钥匙，找到 " .. count .. " 个")
        else
            removeHighlights()
        end
    end)

    -- 🪵 木制钥匙透视
    addToggle("🪵 木制钥匙透视", false, function(s)
        if s then
            removeHighlights()
            local woodKeyKeywords = {"wooden key","木制钥匙","木质钥匙","wood key","木钥匙","WoodenKey","木头钥匙"}
            local count = 0
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local n = obj.Name:lower()
                    local found = false
                    for _, kw in ipairs(woodKeyKeywords) do
                        if n:find(kw) then found = true; break end
                    end
                    if not found and obj.Parent and obj.Parent:IsA("Model") then
                        local pn = obj.Parent.Name:lower()
                        for _, kw in ipairs(woodKeyKeywords) do
                            if pn:find(kw) then found = true; break end
                        end
                    end
                    if found then
                        if not obj:FindFirstAncestorOfClass("Model") or
                           not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                            applyHighlight(obj, Color3.fromRGB(200, 180, 100))
                            count = count + 1
                        end
                    end
                end
            end
            print("🔍 已扫描: 木制钥匙，找到 " .. count .. " 个")
        else
            removeHighlights()
        end
    end)

    -- 箱子
    addToggle("📦 箱子透视", false, function(s)
        if s then scanOnce({"chest","crate","箱","箱子","宝箱","FindBox","OpenBox"}, Color3.fromRGB(255, 180, 50), "箱子") else removeHighlights() end
    end)

    -- 保险箱
    addToggle("🔒 保险箱透视", false, function(s)
        if s then scanOnce({"safe","vault","保险柜","金库","保险箱","FindSafe","OpenSafe"}, Color3.fromRGB(50, 255, 150), "保险箱") else removeHighlights() end
    end)

    -- 代码
    addToggle("💻 代码透视", false, function(s)
        if s then scanOnce({"code","密码","数字","号码","keypad","键盘","FindCode","Code"}, Color3.fromRGB(100, 200, 255), "代码") else removeHighlights() end
    end)

    -- 盘子
    addToggle("🍽️ 盘子透视", false, function(s)
        if s then scanOnce({"plate","dish","盘","碟","餐具","bowl","碗","Plate"}, Color3.fromRGB(255, 200, 100), "盘子") else removeHighlights() end
    end)

    -- 打火机
    addToggle("🔥 打火机透视", false, function(s)
        if s then scanOnce({"lighter","fire","flame","打火","火机","点火","ignite","Lighter"}, Color3.fromRGB(255, 150, 50), "打火机") else removeHighlights() end
    end)

    -- 孩子
    addToggle("👶 孩子透视", false, function(s)
        if s then
            removeHighlights()
            local childKeywords = {"child","kid","孩子","小孩","baby","婴儿","dino kid","kraken kid","squid kid","koala kid","恐龙小子","海怪小子","鱿鱼小子","考拉小子","npc","villager","村民","boy","girl","男孩","女孩","学生","student","小朋友","儿童"}
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local n = obj.Name:lower()
                    local found = false
                    for _, kw in ipairs(childKeywords) do
                        if n:find(kw) then found = true; break end
                    end
                    if not found and obj.Parent and obj.Parent:IsA("Model") then
                        local mname = obj.Parent.Name:lower()
                        for _, kw in ipairs(childKeywords) do
                            if mname:find(kw) then found = true; break end
                        end
                        if not found and obj.Parent:FindFirstChildOfClass("Humanoid") and obj.Parent ~= player.Character then
                            found = true
                        end
                    end
                    if found then
                        if not obj:FindFirstAncestorOfClass("Model") or
                           not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                            applyHighlight(obj, Color3.fromRGB(255, 100, 200))
                        end
                    end
                end
            end
            print("🔍 已扫描: 孩子")
        else
            removeHighlights()
        end
    end)

    -- 器官
    addToggle("❤️ 器官透视", false, function(s)
        if s then scanOnce({"heart","心脏","kidney","肾脏","liver","肝脏","lung","肺","brain","脑","organ","器官"}, Color3.fromRGB(255, 80, 80), "器官") else removeHighlights() end
    end)

    -- 传送门
    addToggle("🚪 传送门透视", false, function(s)
        if s then scanOnce({"vortex","portal","传送门","teleport","gate","Portal"}, Color3.fromRGB(100, 200, 255), "传送门") else removeHighlights() end
    end)

    -- 怪物
    addToggle("🧟 怪物透视", false, function(s)
        if s then scanOnce({"monster","zombie","enemy","creature","ghost","demon","skeleton","怪物","僵尸","敌人","生物"}, Color3.fromRGB(255, 0, 0), "怪物") else removeHighlights() end
    end)

    -- 药水
    addToggle("🧪 药水透视", false, function(s)
        if s then scanOnce({"potion","药水","bottle","瓶子","flask","vial","drink","health","mana"}, Color3.fromRGB(180, 80, 255), "药水") else removeHighlights() end
    end)

    -- 书籍
    addToggle("📖 书籍透视", false, function(s)
        if s then scanOnce({"book","书籍","page","纸","note","笔记","日记","diary"}, Color3.fromRGB(50, 180, 255), "书籍") else removeHighlights() end
    end)

    -- 木偶
    addToggle("🪆 木偶透视", false, function(s)
        if s then scanOnce({"puppet","木偶","doll","娃娃","marionette"}, Color3.fromRGB(255, 100, 180), "木偶") else removeHighlights() end
    end)

    -- 五种颜色的娃娃（彩虹色）
    addToggle("🎎 五种颜色的娃娃透视", false, function(s)
        if s then
            removeHighlights()
            local dollKeywords = {"doll","洋娃娃","娃娃","red doll","blue doll","green doll","yellow doll","purple doll","pink doll","doll red","doll blue","doll green","doll yellow","doll purple","doll pink"}
            local hue = 0
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local n = obj.Name:lower()
                    local found = false
                    for _, kw in ipairs(dollKeywords) do
                        if n:find(kw) then found = true; break end
                    end
                    if found then
                        if not obj:FindFirstAncestorOfClass("Model") or
                           not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                            hue = (hue + 0.15) % 1
                            applyHighlight(obj, Color3.fromHSV(hue, 1, 1))
                        end
                    end
                end
            end
            print("🔍 已扫描: 五种颜色的娃娃（彩虹色）")
        else
            removeHighlights()
        end
    end)

    -- 娃娃头
    addToggle("👤 娃娃头透视", false, function(s)
        if s then scanOnce({"head","头","头部","doll head","娃娃头","洋娃娃头","face","脸","hair","头发"}, Color3.fromRGB(255, 200, 100), "娃娃头") else removeHighlights() end
    end)

    -- 画作
    addToggle("🖼️ 画作透视", false, function(s)
        if s then scanOnce({"painting","画","画作","picture","canvas","油画","art","frame","画框"}, Color3.fromRGB(255, 200, 255), "画作") else removeHighlights() end
    end)

    -- 清除高亮
    addDivider()
    addButton("🧹 清除所有高亮", Color3.fromRGB(180, 40, 40), function()
        removeHighlights()
        print("🧹 已清除所有高亮")
    end)

    -- ===== 传送功能 =====
    addDivider()
    addTitle("📍 传送功能")

    addButton("🗝️ 传送至最近钥匙", Color3.fromRGB(255, 215, 0), function()
        teleportToNearest({"key","keys","钥匙","钥匙串","GetKey","KeyItem"}, "钥匙")
    end)

    addButton("🪵 传送至最近木制钥匙", Color3.fromRGB(200, 180, 100), function()
        teleportToNearest({"wooden key","木制钥匙","木质钥匙","wood key","木钥匙","WoodenKey","木头钥匙"}, "木制钥匙")
    end)

    addButton("📦 传送至最近箱子", Color3.fromRGB(255, 180, 50), function()
        teleportToNearest({"chest","crate","箱","箱子","宝箱","FindBox","OpenBox"}, "箱子")
    end)

    addButton("🔒 传送至最近保险箱", Color3.fromRGB(50, 255, 150), function()
        teleportToNearest({"safe","vault","保险柜","金库","保险箱","FindSafe","OpenSafe"}, "保险箱")
    end)

    addButton("💻 传送至最近代码", Color3.fromRGB(100, 200, 255), function()
        teleportToNearest({"code","密码","数字","号码","keypad","键盘","FindCode","Code"}, "代码")
    end)

    addButton("🍽️ 传送至最近盘子", Color3.fromRGB(255, 200, 100), function()
        teleportToNearest({"plate","dish","盘","碟","餐具","bowl","碗","Plate"}, "盘子")
    end)

    addButton("🔥 传送至最近打火机", Color3.fromRGB(255, 150, 50), function()
        teleportToNearest({"lighter","fire","flame","打火","火机","点火","ignite","Lighter"}, "打火机")
    end)

    addButton("👶 传送至最近孩子", Color3.fromRGB(255, 100, 200), function()
        teleportToNearest({"child","kid","孩子","小孩","baby","婴儿","dino kid","kraken kid","squid kid","koala kid","恐龙小子","海怪小子","鱿鱼小子","考拉小子","npc","villager","村民","boy","girl","男孩","女孩","学生","student","小朋友","儿童"}, "孩子")
    end)

    addButton("🧪 传送至最近药水", Color3.fromRGB(180, 80, 255), function()
        teleportToNearest({"potion","药水","bottle","瓶子","flask","vial","drink"}, "药水")
    end)

    addButton("📖 传送至最近书籍", Color3.fromRGB(50, 180, 255), function()
        teleportToNearest({"book","书籍","page","纸","note","笔记","日记","diary"}, "书籍")
    end)

    addButton("🪆 传送至最近木偶", Color3.fromRGB(255, 100, 180), function()
        teleportToNearest({"puppet","木偶","doll","娃娃","marionette"}, "木偶")
    end)

    addButton("🎎 传送至最近娃娃", Color3.fromRGB(255, 100, 200), function()
        teleportToNearest({"doll","洋娃娃","娃娃","red doll","blue doll","green doll","yellow doll","purple doll","pink doll","doll red","doll blue","doll green","doll yellow","doll purple","doll pink"}, "娃娃")
    end)

    addButton("👤 传送至最近娃娃头", Color3.fromRGB(255, 200, 100), function()
        teleportToNearest({"doll head","娃娃头","洋娃娃头","head","头"}, "娃娃头")
    end)

    addButton("🖼️ 传送至最近画作", Color3.fromRGB(255, 200, 255), function()
        teleportToNearest({"painting","画","画作","picture","canvas","油画","art","frame","画框"}, "画作")
    end)

    -- ===== 亮度/时间调节 =====
    addDivider()
    addTitle("☀️ 亮度/时间调节")

    local function getBrightness()
        return game:GetService("Lighting").Brightness
    end

    local function setBrightness(val)
        val = math.clamp(val, 0, 10)
        game:GetService("Lighting").Brightness = val
        return val
    end

    local function setTime(hour)
        hour = math.clamp(hour, 0, 24)
        game:GetService("Lighting").ClockTime = hour
        return hour
    end

    local function getTime()
        return game:GetService("Lighting").ClockTime
    end

    local brightLabel = addLabel("当前亮度: " .. string.format("%.1f", getBrightness()) .. " | 时间: " .. string.format("%.1f", getTime()) .. ":00")

    addButton("☀️ 亮度 +0.5", Color3.fromRGB(255, 200, 50), function()
        local v = setBrightness(getBrightness() + 0.5)
        brightLabel.Text = "当前亮度: " .. string.format("%.1f", v) .. " | 时间: " .. string.format("%.1f", getTime()) .. ":00"
    end)

    addButton("☀️ 亮度 -0.5", Color3.fromRGB(200, 150, 50), function()
        local v = setBrightness(getBrightness() - 0.5)
        brightLabel.Text = "当前亮度: " .. string.format("%.1f", v) .. " | 时间: " .. string.format("%.1f", getTime()) .. ":00"
    end)

    addButton("🔄 重置亮度 (1.0)", Color3.fromRGB(100, 150, 200), function()
        local v = setBrightness(1)
        brightLabel.Text = "当前亮度: " .. string.format("%.1f", v) .. " | 时间: " .. string.format("%.1f", getTime()) .. ":00"
    end)

    addDivider()
    addTitle("⏰ 时间控制")

    addButton("☀️ 强制白天 (正午)", Color3.fromRGB(255, 220, 100), function()
        local t = setTime(12)
        local b = setBrightness(10)
        brightLabel.Text = "当前亮度: " .. string.format("%.1f", b) .. " | 时间: " .. string.format("%.1f", t) .. ":00"
        print("☀️ 已强制白天")
    end)

    addButton("🌙 强制黑夜 (午夜)", Color3.fromRGB(50, 50, 100), function()
        local t = setTime(0)
        local b = setBrightness(0.5)
        brightLabel.Text = "当前亮度: " .. string.format("%.1f", b) .. " | 时间: " .. string.format("%.1f", t) .. ":00"
        print("🌙 已强制黑夜")
    end)

    addButton("🌅 黄昏 (18:00)", Color3.fromRGB(255, 150, 50), function()
        local t = setTime(18)
        local b = setBrightness(3)
        brightLabel.Text = "当前亮度: " .. string.format("%.1f", b) .. " | 时间: " .. string.format("%.1f", t) .. ":00"
        print("🌅 已切换到黄昏")
    end)

    addButton("🌄 清晨 (6:00)", Color3.fromRGB(255, 200, 150), function()
        local t = setTime(6)
        local b = setBrightness(5)
        brightLabel.Text = "当前亮度: " .. string.format("%.1f", b) .. " | 时间: " .. string.format("%.1f", t) .. ":00"
        print("🌄 已切换到清晨")
    end)

    addButton("🔄 恢复默认", Color3.fromRGB(100, 150, 200), function()
        local t = setTime(12)
        local b = setBrightness(1)
        brightLabel.Text = "当前亮度: " .. string.format("%.1f", b) .. " | 时间: " .. string.format("%.1f", t) .. ":00"
        print("🔄 已恢复默认")
    end)

    addDivider()
    addLabel("💡 亮度: 0~10 | 时间: 0~24小时")
    addLabel("💡 钥匙: 金色 | 木制钥匙: 深金色 | 箱子: 橙色 | 保险箱: 亮绿 | 代码: 淡蓝")
    addLabel("💡 盘子: 淡黄 | 打火机: 橙色 | 孩子: 粉红 | 器官: 红色")
    addLabel("💡 五种颜色的娃娃: 彩虹色 | 娃娃头: 淡黄色 | 画作: 淡紫色")

    panel.CanvasSize = UDim2.new(0, 0, 0, #panel:GetChildren() * 32 + 20)
end
-- ============================================================
--  面板：MM2
-- ============================================================
local function loadMM2()
    clearPanel()
    local targetPlayer = nil

    addTitle("🔫 武器复制")
    addLabel("点击下方玩家选择目标")

    local listFrame = Instance.new("Frame")
    listFrame.Parent = panel
    listFrame.Size = UDim2.new(1, -4, 0, 80)
    listFrame.Position = UDim2.new(0, 2, 0, #panel:GetChildren() * 32 + 4)
    listFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 40)
    listFrame.BackgroundTransparency = 0.5
    listFrame.BorderSizePixel = 1
    listFrame.BorderColor3 = Color3.fromRGB(40, 45, 65)
    listFrame.ClipsDescendants = true
    local lc = Instance.new("UICorner")
    lc.Parent = listFrame
    lc.CornerRadius = UDim.new(0, 4)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Parent = listFrame
    scroll.Size = UDim2.new(1, -4, 1, 0)
    scroll.Position = UDim2.new(0, 2, 0, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 2
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

    local function refreshPlayerList()
        for _, v in pairs(scroll:GetChildren()) do
            if v:IsA("TextButton") then v:Destroy() end
        end
        local y = 4
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player then
                local b = Instance.new("TextButton")
                b.Parent = scroll
                b.Size = UDim2.new(0.9, 0, 0, 20)
                b.Position = UDim2.new(0.05, 0, 0, y)
                b.Text = p.Name
                b.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
                b.BackgroundTransparency = 0.5
                b.TextColor3 = Color3.fromRGB(255, 255, 255)
                b.TextSize = 11
                b.Font = Enum.Font.Gotham
                b.BorderSizePixel = 1
                b.BorderColor3 = Color3.fromRGB(40, 45, 65)
                local bc = Instance.new("UICorner")
                bc.Parent = b
                bc.CornerRadius = UDim.new(0, 2)
                b.MouseButton1Click:Connect(function()
                    for _, v in pairs(scroll:GetChildren()) do
                        if v:IsA("TextButton") then
                            v.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
                            v.BackgroundTransparency = 0.5
                            v.BorderColor3 = Color3.fromRGB(40, 45, 65)
                        end
                    end
                    b.BackgroundColor3 = Color3.fromRGB(30, 200, 255)
                    b.BackgroundTransparency = 0.5
                    b.BorderColor3 = Color3.fromRGB(30, 200, 255)
                    targetPlayer = p
                    print("已选择目标: " .. p.Name)
                end)
                y = y + 24
            end
        end
        scroll.CanvasSize = UDim2.new(0, 0, 0, y + 4)
    end
    refreshPlayerList()

    addButton("刷新玩家列表", Color3.fromRGB(40, 80, 120), refreshPlayerList)
    addDivider()
    addTitle("📋 复制操作")

    local function copyWeaponFrom(target)
        if not target then
            print("请先选择一个目标")
            return false
        end
        local targetChar = target.Character
        if not targetChar then
            print("目标角色不存在")
            return false
        end
        local tool = nil
        for _, child in pairs(targetChar:GetChildren()) do
            if child:IsA("Tool") then
                tool = child
                break
            end
        end
        if not tool then
            local backpack = target:FindFirstChild("Backpack")
            if backpack then
                for _, child in pairs(backpack:GetChildren()) do
                    if child:IsA("Tool") then
                        tool = child
                        break
                    end
                end
            end
        end
        if not tool then
            print("目标没有武器")
            return false
        end

        local clone = tool:Clone()
        clone.Parent = player.Backpack
        task.wait()
        local char = player.Character
        if char then
            clone.Parent = char
        end
        print("已复制并装备武器: " .. tool.Name)
        return true
    end

    addButton("复制目标武器 (装备到手)", Color3.fromRGB(180, 120, 40), function()
        copyWeaponFrom(targetPlayer)
    end)

    addButton("复制警长/杀手武器 (自动)", Color3.fromRGB(180, 60, 60), function()
        local found = nil
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player then
                local char = p.Character
                if char then
                    local hasWeapon = false
                    for _, child in pairs(char:GetChildren()) do
                        if child:IsA("Tool") then
                            hasWeapon = true
                            break
                        end
                    end
                    if hasWeapon then
                        found = p
                        break
                    end
                end
            end
        end
        if found then
            targetPlayer = found
            print("自动选中: " .. found.Name)
            copyWeaponFrom(found)
        else
            print("未找到持有武器的玩家")
        end
    end)

    addDivider()
    addTitle("⚔️ 战斗功能")

    addButton("瞬移到所有人身后", Color3.fromRGB(200, 40, 40), function()
        local myChar = player.Character
        if not myChar then return end
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player then
                local targetChar = p.Character
                if targetChar then
                    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                    if targetHRP then
                        myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 2)
                        task.wait(0.05)
                    end
                end
            end
        end
        print("已瞬移到所有玩家身后")
    end)

    addButton("瞬移到杀手身后", Color3.fromRGB(200, 100, 40), function()
        local myChar = player.Character
        if not myChar then return end
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end

        local nearestKiller = nil
        local minDist = math.huge
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player then
                local char = p.Character
                if char then
                    local isKiller = false
                    for _, child in pairs(char:GetChildren()) do
                        if child:IsA("Tool") then
                            local name = child.Name:lower()
                            if name:find("knife") or name:find("刀") then
                                isKiller = true
                                break
                            end
                        end
                    end
                    if not isKiller then
                        local backpack = p:FindFirstChild("Backpack")
                        if backpack then
                            for _, child in pairs(backpack:GetChildren()) do
                                if child:IsA("Tool") then
                                    local name = child.Name:lower()
                                    if name:find("knife") or name:find("刀") then
                                        isKiller = true
                                        break
                                    end
                                end
                            end
                        end
                    end
                    if isKiller then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local dist = (myHRP.Position - hrp.Position).Magnitude
                            if dist < minDist then
                                minDist = dist
                                nearestKiller = p
                            end
                        end
                    end
                end
            end
        end
        if nearestKiller then
            local targetChar = nearestKiller.Character
            if targetChar then
                local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                if targetHRP then
                    myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 2)
                    print("已瞬移到杀手 " .. nearestKiller.Name .. " 身后")
                end
            end
        else
            print("未找到杀手")
        end
    end)

    panel.CanvasSize = UDim2.new(0, 0, 0, #panel:GetChildren() * 32 + 20)
end
-- ============================================================
--  面板：僵尸塔
-- ============================================================
local function loadZombieTower()
    clearPanel()
    addTitle("🧟 僵尸塔辅助")

    local storage = game:GetService("ReplicatedStorage")
    local fireRemote = nil

    local function getFireRemote()
        if fireRemote then return fireRemote end
        local events = storage:FindFirstChild("Events")
        if events then
            local actions = events:FindFirstChild("Actions")
            if actions then
                fireRemote = actions:FindFirstChild("Fire")
            end
        end
        return fireRemote
    end

    local killAuraConn = nil
    local killAuraActive = false
    local lastAttack = 0
    local cooldown = 0.12

    local function getNearestZombie()
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        local activeZombies = workspace:FindFirstChild("ActiveZombies")
        if not activeZombies then return nil end
        local nearest, minDist = nil, math.huge
        for _, zombie in pairs(activeZombies:GetChildren()) do
            local head = zombie:FindFirstChild("HeadHitbox")
            local hum = zombie:FindFirstChildOfClass("Humanoid")
            if head and hum and hum.Health > 0 then
                local dist = (root.Position - head.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearest = zombie
                end
            end
        end
        return nearest
    end

    local function attack()
        if os.clock() - lastAttack < cooldown then return end
        local char = player.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if not tool then return end
        local exit = tool:FindFirstChild("Exit")
        if not exit then return end
        local zombie = getNearestZombie()
        if not zombie then return end
        local headHitbox = zombie:FindFirstChild("HeadHitbox")
        if not headHitbox then return end
        local remote = getFireRemote()
        if not remote then return end

        local toolName = tool.Name
        local args = {
            toolName,
            {
                { headHitbox, headHitbox.Position, Vector3.new(0, 0, 0) }
            },
            {
                {
                    toolName,
                    exit.Position,
                    headHitbox.Position,
                    headHitbox.Position,
                    true,
                    headHitbox,
                    false,
                    false,
                    "Default",
                    exit
                }
            }
        }
        remote:FireServer(unpack(args))
        lastAttack = os.clock()
    end

    addToggle("杀戮光环（自动攻击）", false, function(s)
        killAuraActive = s
        if killAuraConn then
            killAuraConn:Disconnect()
            killAuraConn = nil
        end
        if s then
            killAuraConn = runService.Heartbeat:Connect(attack)
            print("✅ 杀戮光环已开启")
        else
            print("❌ 杀戮光环已关闭")
        end
    end)

    addDivider()
    addLabel("💡 自动攻击最近的僵尸")
    panel.CanvasSize = UDim2.new(0, 0, 0, #panel:GetChildren() * 32 + 20)
end
-- ============================================================
--  面板：森林·99夜
-- ============================================================
local function loadForest()
    clearPanel()
    addTitle("🌲 森林 · 99夜")

    addTitle("🪓 伐木光环")
    local chopActive = false
    local chopRange = 30
    local chopConn = nil
    local chopInterval = 0.3

    local function getTrees()
        local char = player.Character
        if not char then return {} end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return {} end
        local found = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local n = obj.Name:lower()
                if n:find("tree") or n:find("wood") or n:find("log") or n:find("树干") or n:find("木") then
                    if not obj:FindFirstAncestorOfClass("Model") or
                       not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                        local dist = (hrp.Position - obj.Position).Magnitude
                        if dist <= chopRange then
                            table.insert(found, obj)
                        end
                    end
                end
            end
        end
        return found
    end

    local function chopTree(tree)
        local char = player.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            pcall(function() tool:Activate() end)
            if tree:IsA("BasePart") and tree.Parent and tree.Parent:IsA("Model") then
                for _, child in pairs(tree.Parent:GetDescendants()) do
                    if child:IsA("ClickDetector") then
                        child:FireClick()
                        break
                    end
                end
            end
        end
    end

    addToggle("🌲 伐木光环 (砍树)", false, function(s)
        chopActive = s
        if chopConn then chopConn:Disconnect(); chopConn = nil end
        if s then
            print("🪓 伐木光环已开启，范围: " .. chopRange .. " 格")
            chopConn = runService.Heartbeat:Connect(function()
                if not chopActive then return end
                if not chopConn._lastTime then chopConn._lastTime = 0 end
                if tick() - chopConn._lastTime < chopInterval then return end
                chopConn._lastTime = tick()
                local trees = getTrees()
                for _, tree in ipairs(trees) do
                    chopTree(tree)
                end
            end)
        else
            print("🪓 伐木光环已关闭")
        end
    end)

    local chopRangeLabel = addLabel("当前伐木范围: " .. chopRange .. " 格")
    addButton("伐木范围 +5", Color3.fromRGB(60, 180, 60), function()
        chopRange = math.min(chopRange + 5, 100)
        chopRangeLabel.Text = "当前伐木范围: " .. chopRange .. " 格"
    end)
    addButton("伐木范围 -5", Color3.fromRGB(180, 60, 60), function()
        chopRange = math.max(chopRange - 5, 10)
        chopRangeLabel.Text = "当前伐木范围: " .. chopRange .. " 格"
    end)

    addDivider()
    addTitle("⚔️ 生物杀戮光环")

    local killActive = false
    local killRange = 30
    local killConn = nil

    local function getMonsters()
        local char = player.Character
        if not char then return {} end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return {} end
        local found = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Parent and obj.Parent:IsA("Model") then
                local model = obj.Parent
                if model ~= player.Character and model:FindFirstChildOfClass("Humanoid") then
                    local root = model:FindFirstChild("HumanoidRootPart")
                    if root and (hrp.Position - root.Position).Magnitude <= killRange then
                        table.insert(found, root)
                    end
                end
            end
        end
        return found
    end

    addToggle("⚔️ 生物杀戮光环", false, function(s)
        killActive = s
        if killConn then killConn:Disconnect(); killConn = nil end
        if s then
            print("⚔️ 杀戮光环已开启，范围: " .. killRange .. " 格")
            killConn = runService.Heartbeat:Connect(function()
                if not killActive then return end
                local monsters = getMonsters()
                for _, mon in ipairs(monsters) do
                    if mon and mon.Parent then
                        mon.Parent:BreakJoints()
                    end
                end
            end)
        else
            print("⚔️ 杀戮光环已关闭")
        end
    end)

    addDivider()
    addTitle("📦 物品传送")

    local function teleportItemsToPlayer(items)
        local char = player.Character
        if not char then return 0 end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return 0 end
        local count = 0
        local targetPos = hrp.Position + hrp.CFrame.LookVector * 3 + Vector3.new(0, 1, 0)
        for i, obj in ipairs(items) do
            if obj:IsA("BasePart") then
                local offset = Vector3.new(math.random(-2, 2), math.random(0, 1), math.random(-2, 2))
                obj.Position = targetPos + offset
                obj.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                count = count + 1
                if i % 5 == 0 then task.wait(0.01) end
            end
        end
        return count
    end

    local function getItemsByKeywords(keywords)
        local results = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local n = obj.Name:lower()
                for _, kw in ipairs(keywords) do
                    if n:find(kw:lower()) then
                        if obj:FindFirstAncestorOfClass("Model") then
                            local model = obj:FindFirstAncestorOfClass("Model")
                            if model ~= player.Character and not model:FindFirstChildOfClass("Humanoid") then
                                table.insert(results, obj)
                            end
                        end
                        break
                    end
                end
            end
        end
        return results
    end

    local itemKeywords = {"coin","gold","diamond","gem","wood","log","stone","iron","ore","seed","food","potion","axe","sword","spear","gun","rifle","bow","arrow","craft","material"}
    addButton("📦 传送附近物品到身边", Color3.fromRGB(100, 200, 255), function()
        local items = getItemsByKeywords(itemKeywords)
        local count = teleportItemsToPlayer(items)
        print("✅ 已传送 " .. count .. " 个物品到身边")
    end)

    panel.CanvasSize = UDim2.new(0, 0, 0, #panel:GetChildren() * 32 + 20)
end
-- ============================================================
--  面板：简介
-- ============================================================
local function loadIntro()
    clearPanel()
    addTitle("📋 关于本脚本")

    local card = Instance.new("Frame")
    card.Parent = panel
    card.Size = UDim2.new(1, -4, 0, 200)
    card.Position = UDim2.new(0, 2, 0, #panel:GetChildren() * 32 + 8)
    card.BackgroundColor3 = Color3.fromRGB(20, 22, 40)
    card.BackgroundTransparency = 0.5
    card.BorderSizePixel = 1
    card.BorderColor3 = Color3.fromRGB(30, 200, 255)
    local cardCorner = Instance.new("UICorner")
    cardCorner.Parent = card
    cardCorner.CornerRadius = UDim.new(0, 6)

    local icon = Instance.new("TextLabel")
    icon.Parent = card
    icon.Size = UDim2.new(0, 60, 0, 60)
    icon.Position = UDim2.new(0.5, -30, 0, 8)
    icon.BackgroundTransparency = 1
    icon.Text = "📜"
    icon.TextSize = 40
    icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    icon.Font = Enum.Font.GothamBold
    icon.TextXAlignment = Enum.TextXAlignment.Center

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Parent = card
    titleLbl.Size = UDim2.new(1, 0, 0, 30)
    titleLbl.Position = UDim2.new(0, 0, 0, 68)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "唐脚本 v7.0"
    titleLbl.TextColor3 = Color3.fromRGB(30, 200, 255)
    titleLbl.TextSize = 22
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Center

    local line = Instance.new("Frame")
    line.Parent = card
    line.Size = UDim2.new(0.6, 0, 0, 1)
    line.Position = UDim2.new(0.2, 0, 0, 100)
    line.BackgroundColor3 = Color3.fromRGB(30, 200, 255)
    line.BackgroundTransparency = 0.5
    line.BorderSizePixel = 0

    local authorLbl = Instance.new("TextLabel")
    authorLbl.Parent = card
    authorLbl.Size = UDim2.new(1, 0, 0, 22)
    authorLbl.Position = UDim2.new(0, 0, 0, 108)
    authorLbl.BackgroundTransparency = 1
    authorLbl.Text = "👤 作者：kkcmjf"
    authorLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    authorLbl.TextSize = 14
    authorLbl.Font = Enum.Font.Gotham
    authorLbl.TextXAlignment = Enum.TextXAlignment.Center

    local versionLbl = Instance.new("TextLabel")
    versionLbl.Parent = card
    versionLbl.Size = UDim2.new(1, 0, 0, 20)
    versionLbl.Position = UDim2.new(0, 0, 0, 132)
    versionLbl.BackgroundTransparency = 1
    versionLbl.Text = "⚡ 支持：MM2 / Peta / 飞行 / 甩飞 / 僵尸塔 / 森林·99夜"
    versionLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    versionLbl.TextSize = 11
    versionLbl.Font = Enum.Font.Gotham
    versionLbl.TextXAlignment = Enum.TextXAlignment.Center

    local tipLbl = Instance.new("TextLabel")
    tipLbl.Parent = card
    tipLbl.Size = UDim2.new(1, 0, 0, 18)
    tipLbl.Position = UDim2.new(0, 0, 0, 155)
    tipLbl.BackgroundTransparency = 1
    tipLbl.Text = "💡 点击右上角 — 最小化 | + 展开 | ✕ 关闭"
    tipLbl.TextColor3 = Color3.fromRGB(150, 180, 200)
    tipLbl.TextSize = 10
    tipLbl.Font = Enum.Font.Gotham
    tipLbl.TextXAlignment = Enum.TextXAlignment.Center

    local bottomLbl = Instance.new("TextLabel")
    bottomLbl.Parent = card
    bottomLbl.Size = UDim2.new(1, 0, 0, 16)
    bottomLbl.Position = UDim2.new(0, 0, 0, 178)
    bottomLbl.BackgroundTransparency = 1
    bottomLbl.Text = "⚠️ 仅供学习交流使用，请勿用于非法用途"
    bottomLbl.TextColor3 = Color3.fromRGB(255, 100, 100)
    bottomLbl.TextSize = 10
    bottomLbl.Font = Enum.Font.Gotham
    bottomLbl.TextXAlignment = Enum.TextXAlignment.Center

    panel.CanvasSize = UDim2.new(0, 0, 0, #panel:GetChildren() * 32 + 20)
end

-- ============================================================
--  侧栏按钮事件绑定
-- ============================================================
local panelFunctions = {
    loadGeneral,
    loadMM2,
    loadPeta,
    loadFlight,
    loadFlyOff,
    loadZombieTower,
    loadForest,
    loadIntro
}

for i, btn in ipairs(btnList) do
    btn.MouseButton1Click:Connect(function()
        for _, b in ipairs(btnList) do
            b.BackgroundColor3 = Color3.fromRGB(20, 40, 60)
            b.BorderColor3 = Color3.fromRGB(50, 50, 70)
        end
        btn.BackgroundColor3 = Color3.fromRGB(30, 200, 255)
        btn.BorderColor3 = Color3.fromRGB(30, 200, 255)
        if panelFunctions[i] then
            panelFunctions[i]()
        end
    end)
end

-- ============================================================
--  启动
-- ============================================================
local function waitForSplashComplete()
    while running do
        local progress = fill.Size.X.Scale
        if progress >= 1 then
            break
        end
        task.wait(0.05)
    end
    task.wait(0.3)
end

task.spawn(function()
    waitForSplashComplete()
    loadGeneral()
    gui.Enabled = true
    mainFrame.Visible = true
    splashGui:Destroy()
    print("✅ 唐脚本 v7.0 已加载完成")
end)
