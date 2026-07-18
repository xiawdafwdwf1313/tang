-- 唐脚本 v5.0（完整整合版）
-- 功能：通用 | MM2 | Peta | 飞行 | 甩飞 | 僵尸塔 | 森林·99夜 | 简介
-- 窗口控制：右上角 — + × | 点击—缩小到左上角标题栏 | 点击+展开

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
    block.Size, block.Position, block.BackgroundColor3, block.BackgroundTransparency = UDim2.new(0,12,0,12), UDim2.new(0.5,x-6,0.5,y-6), blockColors[(i%3)+1], 0.2
    block.BorderSizePixel = 0
    block.ZIndex = 0
    block.Parent = ringContainer
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0,3); corner.Parent = block
    block:SetAttribute("Angle", angle)
    table.insert(blocks, block)
end

local outerBlocks, innerBlocks = {}, {}
for i=1,16 do
    local angle = (i-1)/16*2*math.pi + 0.3
    local x,y = (radius+25)*math.cos(angle), (radius+25)*math.sin(angle)
    local block = Instance.new("Frame")
    block.Size, block.Position, block.BackgroundColor3, block.BackgroundTransparency = UDim2.new(0,6,0,6), UDim2.new(0.5,x-3,0.5,y-3), Color3.fromRGB(150,200,255), 0.7
    block.BorderSizePixel = 0
    block.ZIndex = 0
    block.Parent = ringContainer
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0,2); corner.Parent = block
    table.insert(outerBlocks, block)
end
for i=1,12 do
    local angle = (i-1)/12*2*math.pi + 0.6
    local x,y = (radius-30)*math.cos(angle), (radius-30)*math.sin(angle)
    local block = Instance.new("Frame")
    block.Size, block.Position, block.BackgroundColor3, block.BackgroundTransparency = UDim2.new(0,4,0,4), UDim2.new(0.5,x-2,0.5,y-2), Color3.fromRGB(255,255,255), 0.8
    block.BorderSizePixel = 0
    block.ZIndex = 0
    block.Parent = ringContainer
    table.insert(innerBlocks, block)
end

local percentLabel = Instance.new("TextLabel")
percentLabel.Size, percentLabel.Position, percentLabel.BackgroundTransparency, percentLabel.Text = UDim2.new(0,120,0,50), UDim2.new(0.5,-60,0.5,30), 1, "0%"
percentLabel.TextColor3, percentLabel.TextSize, percentLabel.Font, percentLabel.TextStrokeColor3, percentLabel.TextStrokeTransparency = Color3.fromRGB(255,255,255), 36, Enum.Font.GothamBold, Color3.fromRGB(0,0,0), 0.3
percentLabel.Parent = container

local progressBar = Instance.new("Frame")
progressBar.Size, progressBar.Position, progressBar.BackgroundColor3, progressBar.BorderSizePixel = UDim2.new(0,200,0,4), UDim2.new(0.5,-100,0.5,75), Color3.fromRGB(60,60,80), 0
progressBar.Parent = container
local barCorner = Instance.new("UICorner"); barCorner.CornerRadius = UDim.new(1,0); barCorner.Parent = progressBar
local fill = Instance.new("Frame")
fill.Size, fill.BackgroundColor3, fill.BorderSizePixel = UDim2.new(0,0,1,0), Color3.fromRGB(100,200,255), 0
fill.Parent = progressBar
local fillCorner = Instance.new("UICorner"); fillCorner.CornerRadius = UDim.new(1,0); fillCorner.Parent = fill

local letters, labels, hueOffsets = {"T","A","N","G"}, {}, {0,0.15,0.30,0.45}
for i, char in ipairs(letters) do
    local lbl = Instance.new("TextLabel")
    lbl.Size, lbl.Position, lbl.BackgroundTransparency, lbl.Text = UDim2.new(0,80,0,100), UDim2.new(0,(i-1)*100+30,0,55), 1, char
    lbl.TextColor3, lbl.TextSize, lbl.Font, lbl.TextScaled, lbl.TextStrokeColor3, lbl.TextStrokeTransparency, lbl.TextTransparency = Color3.fromHSV((i-1)/4,1,1), 80, Enum.Font.GothamBold, true, Color3.fromRGB(0,0,0), 0, 0
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
--  主窗口（右上角控制栏：— + ×）
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "TangScript"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Enabled = false  -- 启动动画期间隐藏

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
mainFrame.Visible = true

local corner = Instance.new("UICorner")
corner.Parent = mainFrame
corner.CornerRadius = UDim.new(0,8)

-- 彩虹边框
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

-- ============================================================
--  标题栏（右上角控制栏）
-- ============================================================
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

-- 标题文字
local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = titleBar
titleLabel.Size = UDim2.new(0.6,0,1,0)
titleLabel.Position = UDim2.new(0,10,0,0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "唐脚本 v5.0"
titleLabel.TextColor3 = Color3.fromRGB(30,200,255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- 控制按钮容器（右上角）
local btnContainer = Instance.new("Frame")
btnContainer.Parent = titleBar
btnContainer.Size = UDim2.new(0, 70, 1, 0)
btnContainer.Position = UDim2.new(1, -75, 0, 0)
btnContainer.BackgroundTransparency = 1

-- 最小化按钮（—）
local minBtn = Instance.new("TextButton")
minBtn.Parent = btnContainer
minBtn.Size = UDim2.new(0, 22, 0, 22)
minBtn.Position = UDim2.new(0, 2, 0.5, -11)
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

-- 展开按钮（+）
local maxBtn = Instance.new("TextButton")
maxBtn.Parent = btnContainer
maxBtn.Size = UDim2.new(0, 22, 0, 22)
maxBtn.Position = UDim2.new(0, 25, 0.5, -11)
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

-- 关闭按钮（×）
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = btnContainer
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(0, 48, 0.5, -11)
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

-- 窗口状态
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
    isMinimized = false
    minBtn.Text = "−"
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

local function addLabel(text, color)
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
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lbl.TextStrokeTransparency = 0.3
end

-- ============================================================
--  面板：通用
-- ============================================================
local function loadGeneral()
    clearPanel()
    addTitle("⚙️ 通用设置")
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
        else
            if fallConn then fallConn:Disconnect() end
            if charAddedConn then charAddedConn:Disconnect() end
        end
    end)
    addDivider()
    addLabel("更多通用功能开发中...")
    panel.CanvasSize = UDim2.new(0,0,0,#panel:GetChildren()*32+20)
end

-- ============================================================
--  面板：MM2
-- ============================================================
local function loadMM2()
    clearPanel()
    local targetPlayer = nil

    addTitle("🔫 武器复制 - 选择目标")
    addLabel("点击下方玩家选择目标（高亮显示），然后复制武器")

    local listFrame = Instance.new("Frame")
    listFrame.Parent = panel
    listFrame.Size = UDim2.new(1,-4,0,80)
    listFrame.Position = UDim2.new(0,2,0,#panel:GetChildren()*32+4)
    listFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 40)
    listFrame.BackgroundTransparency = 0.5
    listFrame.BorderSizePixel = 1
    listFrame.BorderColor3 = Color3.fromRGB(40,45,65)
    listFrame.ClipsDescendants = true
    local lc = Instance.new("UICorner")
    lc.Parent = listFrame
    lc.CornerRadius = UDim.new(0,4)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Parent = listFrame
    scroll.Size = UDim2.new(1,-4,1,0)
    scroll.Position = UDim2.new(0,2,0,0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 2
    scroll.CanvasSize = UDim2.new(0,0,0,0)

    local function refreshPlayerList()
        for _,v in pairs(scroll:GetChildren()) do
            if v:IsA("TextButton") then v:Destroy() end
        end
        local y = 4
        for _,p in pairs(game.Players:GetPlayers()) do
            if p ~= player then
                local b = Instance.new("TextButton")
                b.Parent = scroll
                b.Size = UDim2.new(0.9,0,0,20)
                b.Position = UDim2.new(0.05,0,0,y)
                b.Text = p.Name
                b.BackgroundColor3 = Color3.fromRGB(30,30,45)
                b.BackgroundTransparency = 0.5
                b.TextColor3 = Color3.fromRGB(255, 255, 255)
                b.TextSize = 11
                b.Font = Enum.Font.Gotham
                b.BorderSizePixel = 1
                b.BorderColor3 = Color3.fromRGB(40,45,65)
                local bc = Instance.new("UICorner")
                bc.Parent = b
                bc.CornerRadius = UDim.new(0,2)
                b.MouseButton1Click:Connect(function()
                    for _,v in pairs(scroll:GetChildren()) do
                        if v:IsA("TextButton") then
                            v.BackgroundColor3 = Color3.fromRGB(30,30,45)
                            v.BackgroundTransparency = 0.5
                            v.BorderColor3 = Color3.fromRGB(40,45,65)
                        end
                    end
                    b.BackgroundColor3 = Color3.fromRGB(30,200,255)
                    b.BackgroundTransparency = 0.5
                    b.BorderColor3 = Color3.fromRGB(30,200,255)
                    targetPlayer = p
                    print("已选择目标: " .. p.Name)
                end)
                y = y + 24
            end
        end
        scroll.CanvasSize = UDim2.new(0,0,0,y+4)
    end
    refreshPlayerList()

    addButton("刷新玩家列表", Color3.fromRGB(40,80,120), refreshPlayerList)
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

    addButton("复制目标武器 (装备到手)", Color3.fromRGB(180,120,40), function()
        copyWeaponFrom(targetPlayer)
    end)

    addButton("复制警长/杀手武器 (自动)", Color3.fromRGB(180,60,60), function()
        local found = nil
        for _,p in pairs(game.Players:GetPlayers()) do
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

    addButton("瞬移到所有人身后", Color3.fromRGB(200,40,40), function()
        local myChar = player.Character
        if not myChar then
            print("你的角色不存在")
            return
        end
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then
            print("你的 HumanoidRootPart 不存在")
            return
        end

        local count = 0
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player then
                local targetChar = p.Character
                if targetChar then
                    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                    if targetHRP then
                        local behind = targetHRP.CFrame * CFrame.new(0, 0, 2)
                        myHRP.CFrame = behind
                        task.wait(0.05)
                        count = count + 1
                    end
                end
            end
        end
        print("已瞬移到 " .. count .. " 名玩家身后")
    end)

    addButton("瞬移到杀手身后", Color3.fromRGB(200,100,40), function()
        local myChar = player.Character
        if not myChar then
            print("你的角色不存在")
            return
        end
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then
            print("你的 HumanoidRootPart 不存在")
            return
        end

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

    local showIdentity = false
    local identityConn = nil

    local function getPlayerIdentity(targetPlayer)
        local char = targetPlayer.Character
        if not char then return "平民"
        end
        for _, child in pairs(char:GetChildren()) do
            if child:IsA("Tool") then
                local name = child.Name:lower()
                if name:find("knife") or name:find("刀") then
                    return "🔪 杀手"
                elseif name:find("gun") or name:find("枪") or name:find("pistol") then
                    return "🔫 警长"
                else
                    return "⚔️ 武器持有者"
                end
            end
        end
        local backpack = targetPlayer:FindFirstChild("Backpack")
        if backpack then
            for _, child in pairs(backpack:GetChildren()) do
                if child:IsA("Tool") then
                    local name = child.Name:lower()
                    if name:find("knife") or name:find("刀") then
                        return "🔪 杀手"
                    elseif name:find("gun") or name:find("枪") or name:find("pistol") then
                        return "🔫 警长"
                    else
                        return "⚔️ 武器持有者"
                    end
                end
            end
        end
        return "👤 平民"
    end

    local function clearIdentityLabels()
        for _, p in pairs(game.Players:GetPlayers()) do
            local char = p.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local label = hrp:FindFirstChild("IdentityESP")
                    if label then label:Destroy() end
                end
            end
        end
    end

    local function updateIdentityLabels()
        if not showIdentity then return end
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player then
                local char = p.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local old = hrp:FindFirstChild("IdentityESP")
                        if old then old:Destroy() end
                        local identity = getPlayerIdentity(p)
                        local bg = Instance.new("BillboardGui")
                        bg.Name = "IdentityESP"
                        bg.Size = UDim2.new(0, 150, 0, 30)
                        bg.AlwaysOnTop = true
                        bg.StudsOffset = Vector3.new(0, 3.5, 0)
                        bg.Parent = hrp
                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.Text = identity
                        label.TextColor3 = identity:find("杀手") and Color3.fromRGB(255, 50, 50) or identity:find("警长") and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(200, 200, 200)
                        label.TextScaled = true
                        label.Font = Enum.Font.GothamBold
                        label.Parent = bg
                    end
                end
            end
        end
    end

    addToggle("显示身份标签", false, function(s)
        showIdentity = s
        if s then
            clearIdentityLabels()
            updateIdentityLabels()
            identityConn = runService.Heartbeat:Connect(function()
                if not showIdentity then
                    identityConn:Disconnect()
                    identityConn = nil
                    clearIdentityLabels()
                    return
                end
                updateIdentityLabels()
                task.wait(2)
            end)
            print("身份标签已开启")
        else
            if identityConn then
                identityConn:Disconnect()
                identityConn = nil
            end
            clearIdentityLabels()
            print("身份标签已关闭")
        end
    end)

    addButton("刷新身份标签", Color3.fromRGB(30,150,200), function()
        if showIdentity then
            clearIdentityLabels()
            updateIdentityLabels()
            print("身份标签已刷新")
        else
            print("请先开启身份标签开关")
        end
    end)

    local showNameLabels = false
    local nameLabelConn = nil
    local function clearNameLabels()
        for _, p in pairs(game.Players:GetPlayers()) do
            local char = p.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local label = hrp:FindFirstChild("NameLabelESP")
                    if label then label:Destroy() end
                end
            end
        end
    end
    local function updateNameLabels()
        if not showNameLabels then return end
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player then
                local char = p.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local old = hrp:FindFirstChild("NameLabelESP")
                        if old then old:Destroy() end
                        local bg = Instance.new("BillboardGui")
                        bg.Name = "NameLabelESP"
                        bg.Size = UDim2.new(0, 200, 0, 40)
                        bg.AlwaysOnTop = true
                        bg.StudsOffset = Vector3.new(0, 4, 0)
                        bg.Parent = hrp
                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.Text = p.Name
                        label.TextColor3 = Color3.fromRGB(255, 255, 255)
                        label.TextScaled = true
                        label.Font = Enum.Font.GothamBold
                        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        label.TextStrokeTransparency = 0.3
                        label.Parent = bg
                    end
                end
            end
        end
    end

    addToggle("显示玩家名字标签", false, function(s)
        showNameLabels = s
        if s then
            clearNameLabels()
            updateNameLabels()
            nameLabelConn = runService.Heartbeat:Connect(function()
                if not showNameLabels then
                    nameLabelConn:Disconnect()
                    nameLabelConn = nil
                    clearNameLabels()
                    return
                end
                updateNameLabels()
                task.wait(2)
            end)
            print("玩家名字标签已开启")
        else
            if nameLabelConn then
                nameLabelConn:Disconnect()
                nameLabelConn = nil
            end
            clearNameLabels()
            print("玩家名字标签已关闭")
        end
    end)

    addButton("刷新名字标签", Color3.fromRGB(30,150,200), function()
        if showNameLabels then
            clearNameLabels()
            updateNameLabels()
            print("名字标签已刷新")
        else
            print("请先开启名字标签开关")
        end
    end)

    local killAuraActive = false
    local killAuraConn = nil
    local killRange = 30

    addToggle("Kill Aura (攻击范围)", false, function(s)
        killAuraActive = s
        if s then
            print("Kill Aura 已开启，范围: " .. killRange .. " 格")
            killAuraConn = runService.Heartbeat:Connect(function()
                if not killAuraActive then return end
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
                                local dist = (myHRP.Position - targetHRP.Position).Magnitude
                                if dist <= killRange then
                                    targetChar:BreakJoints()
                                    print("Kill Aura 击杀: " .. p.Name)
                                end
                            end
                        end
                    end
                end
            end)
        else
            if killAuraConn then
                killAuraConn:Disconnect()
                killAuraConn = nil
            end
            print("Kill Aura 已关闭")
        end
    end)

    addButton("攻击范围 +5", Color3.fromRGB(60,180,60), function()
        killRange = math.min(killRange + 5, 100)
        print("攻击范围已调整为: " .. killRange)
    end)
    addButton("攻击范围 -5", Color3.fromRGB(180,60,60), function()
        killRange = math.max(killRange - 5, 10)
        print("攻击范围已调整为: " .. killRange)
    end)
    addLabel("当前攻击范围: " .. killRange .. " 格 (默认30)")

    addDivider()
    addTitle("📍 传送功能")
    addButton("传送到大厅", Color3.fromRGB(30,120,180), function()
        local c = player.Character
        if c then
            local h = c:FindFirstChild("HumanoidRootPart")
            if h then h.CFrame = CFrame.new(-108.5,145,0.6) end
        end
    end)
    addButton("传送到地图", Color3.fromRGB(30,120,180), function()
        for _,obj in pairs(workspace:GetChildren()) do
            local sp = obj:FindFirstChild("Spawns")
            if sp then
                local s = sp:FindFirstChild("Spawn")
                if s then
                    local c = player.Character
                    if c then
                        local h = c:FindFirstChild("HumanoidRootPart")
                        if h then h.CFrame = CFrame.new(s.Position) end
                    end
                    return
                end
            end
        end
    end)

    addDivider()
    addTitle("🎮 玩家辅助")
    local flyOn = false
    addToggle("简易飞行 (WASD)", false, function(s)
        flyOn = s
        local c = player.Character
        if not c then return end
        local h = c:FindFirstChild("HumanoidRootPart")
        if not h then return end
        if flyOn then
            local bg = Instance.new("BodyGyro", h)
            local bv = Instance.new("BodyVelocity", h)
            bg.P = 9e4
            bg.maxTorque = Vector3.new(9e9,9e9,9e9)
            bg.cframe = h.CFrame
            bv.velocity = Vector3.new(0,0.1,0)
            bv.maxForce = Vector3.new(9e9,9e9,9e9)
            c.Humanoid.PlatformStand = true
            local conn
            conn = runService.Heartbeat:Connect(function()
                if not flyOn then
                    bg:Destroy()
                    bv:Destroy()
                    c.Humanoid.PlatformStand = false
                    conn:Disconnect()
                    return
                end
                local cam = workspace.CurrentCamera
                if not cam then return end
                local f = 0
                local l = 0
                if userInput:IsKeyDown(Enum.KeyCode.W) then f = 1 end
                if userInput:IsKeyDown(Enum.KeyCode.S) then f = -1 end
                if userInput:IsKeyDown(Enum.KeyCode.A) then l = -1 end
                if userInput:IsKeyDown(Enum.KeyCode.D) then l = 1 end
                if f ~= 0 or l ~= 0 then
                    bv.velocity = ((cam.CoordinateFrame.lookVector * f) + ((cam.CoordinateFrame * CFrame.new(l, f*0.2, 0).p) - cam.CoordinateFrame.p)) * 50
                else
                    bv.velocity = Vector3.new(0,0,0)
                end
                bg.cframe = cam.CoordinateFrame
            end)
        else
            if c then
                c.Humanoid.PlatformStand = false
            end
        end
    end)
    addToggle("穿墙", false, function(s)
        runService.Stepped:Connect(function()
            if s and player.Character then
                player.Character.Humanoid:ChangeState(11)
            end
        end)
    end)
    addToggle("无限跳", false, function(s)
        userInput.JumpRequest:Connect(function()
            if s and player.Character then
                player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end)
    end)

    panel.CanvasSize = UDim2.new(0,0,0,#panel:GetChildren()*32+20)
end

-- ============================================================
--  面板：Peta（完整优化版 - 10秒扫描）
--  包含：钥匙、箱子、保险箱、代码、盘子、打火机、
--        器官、传送门、灵魂火焰、怪物、药水、书籍、木偶、
--        五种颜色的娃娃、娃娃头、画作、孩子
-- ============================================================
local function loadPeta()
    clearPanel()
    addTitle("🧬 Peta 透视辅助 (10秒扫描)")

    local function applyHighlight(instance, color, name)
        if not instance or not instance:IsA("BasePart") then return end
        for _, child in pairs(instance:GetChildren()) do
            if child:IsA("Highlight") then child:Destroy() end
        end
        local hl = Instance.new("Highlight")
        hl.Name = "PetaHighlight"
        hl.FillColor = color
        hl.FillTransparency = 0.7
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

    local function teleportToPosition(targetPos)
        local char = player.Character
        if not char then return false end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        hrp.CFrame = CFrame.new(targetPos)
        return true
    end

    local function teleportToNearest(partNames, displayName)
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local nearest, minDist = nil, math.huge
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local n = obj.Name:lower()
                local matched = false
                for _, name in ipairs(partNames) do
                    if n:find(name) then matched = true; break end
                end
                if matched then
                    if not obj:FindFirstAncestorOfClass("Model") or
                       not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                        local dist = (hrp.Position - obj.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            nearest = obj
                        end
                    end
                end
            end
        end

        if nearest then
            teleportToPosition(nearest.Position)
            print("✅ 已传送到最近的" .. displayName .. ": " .. nearest.Name)
        else
            print("⚠️ 未找到任何" .. displayName)
        end
    end

    -- 状态变量
    local keyActive, chestActive, safeActive, codeActive = false, false, false, false
    local plateActive, lighterActive = false, false
    local childActive = false  -- 新增：孩子透视
    local organActive, portalActive, soulActive = false, false, false
    local potionActive, bookActive, puppetActive, monsterActive = false, false, false, false
    local dollActive, dollHeadActive, paintingActive = false, false, false

    local keyThread, chestThread, safeThread, codeThread = nil, nil, nil, nil
    local plateThread, lighterThread = nil, nil
    local childThread = nil  -- 新增
    local organThread, portalThread, soulThread = nil, nil, nil
    local potionThread, bookThread, puppetThread, monsterThread = nil, nil, nil, nil
    local dollThread, dollHeadThread, paintingThread = nil, nil, nil

    local correctPortal, correctPortalHL = nil, nil

    -- ====== 所有透视开关（10秒扫描） ======

    -- 🔑 钥匙
    addToggle("🔑 钥匙透视描边", false, function(s)
        keyActive = s
        if keyThread then task.cancel(keyThread); keyThread = nil end
        if not s then removeHighlights() return end
        keyThread = task.spawn(function()
            while keyActive do
                task.wait(10)
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local n = obj.Name:lower()
                        if n:find("key") or n:find("钥匙") then
                            if not obj:FindFirstAncestorOfClass("Model") or
                               not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                                applyHighlight(obj, Color3.fromRGB(255, 220, 50), "Key")
                            end
                        end
                    end
                end
            end
        end)
    end)

    -- 📦 箱子
    addToggle("📦 箱子透视描边", false, function(s)
        chestActive = s
        if chestThread then task.cancel(chestThread); chestThread = nil end
        if not s then removeHighlights() return end
        chestThread = task.spawn(function()
            while chestActive do
                task.wait(10)
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local n = obj.Name:lower()
                        if n:find("chest") or n:find("箱") or n:find("箱子") or n:find("crate") then
                            if not obj:FindFirstAncestorOfClass("Model") or
                               not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                                applyHighlight(obj, Color3.fromRGB(255, 180, 50), "Chest")
                            end
                        end
                    end
                end
            end
        end)
    end)

    -- 🔒 保险箱
    addToggle("🔒 保险箱透视描边", false, function(s)
        safeActive = s
        if safeThread then task.cancel(safeThread); safeThread = nil end
        if not s then removeHighlights() return end
        safeThread = task.spawn(function()
            while safeActive do
                task.wait(10)
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local n = obj.Name:lower()
                        if n:find("safe") or n:find("保险箱") or n:find("vault") or n:find("金库") then
                            if not obj:FindFirstAncestorOfClass("Model") or
                               not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                                applyHighlight(obj, Color3.fromRGB(50, 255, 150), "Safe")
                            end
                        end
                    end
                end
            end
        end)
    end)

    -- 💻 代码
    addToggle("💻 代码透视描边", false, function(s)
        codeActive = s
        if codeThread then task.cancel(codeThread); codeThread = nil end
        if not s then removeHighlights() return end
        codeThread = task.spawn(function()
            while codeActive do
                task.wait(10)
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local n = obj.Name:lower()
                        if n:find("code") or n:find("密码") or n:find("数字") or n:find("号码") or n:find("keypad") or n:find("键盘") then
                            if not obj:FindFirstAncestorOfClass("Model") or
                               not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                                applyHighlight(obj, Color3.fromRGB(100, 200, 255), "Code")
                            end
                        end
                    end
                end
            end
        end)
    end)

    -- 🍽️ 盘子
    addToggle("🍽️ 盘子透视描边", false, function(s)
        plateActive = s
        if plateThread then task.cancel(plateThread); plateThread = nil end
        if not s then removeHighlights() return end
        plateThread = task.spawn(function()
            while plateActive do
                task.wait(10)
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local n = obj.Name:lower()
                        if n:find("plate") or n:find("盘子") or n:find("碟子") or n:find("dish") then
                            if not obj:FindFirstAncestorOfClass("Model") or
                               not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                                applyHighlight(obj, Color3.fromRGB(255, 200, 100), "Plate")
                            end
                        end
                    end
                end
            end
        end)
    end)

    -- 🔥 打火机
    addToggle("🔥 打火机透视描边", false, function(s)
        lighterActive = s
        if lighterThread then task.cancel(lighterThread); lighterThread = nil end
        if not s then removeHighlights() return end
        lighterThread = task.spawn(function()
            while lighterActive do
                task.wait(10)
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local n = obj.Name:lower()
                        if n:find("lighter") or n:find("打火机") or n:find("火机") or n:find("点火器") then
                            if not obj:FindFirstAncestorOfClass("Model") or
                               not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                                applyHighlight(obj, Color3.fromRGB(255, 150, 50), "Lighter")
                            end
                        end
                    end
                end
            end
        end)
    end)

    -- 👶 孩子透视（新增）
    addToggle("👶 孩子透视描边", false, function(s)
        childActive = s
        if childThread then task.cancel(childThread); childThread = nil end
        if not s then removeHighlights() return end
        childThread = task.spawn(function()
            local childKeywords = {"child","kid","孩子","小孩","儿子","女儿","baby","婴儿","dino kid","kraken kid","squid kid","koala kid","恐龙小子","海怪小子","鱿鱼小子","考拉小子"}
            while childActive do
                task.wait(10)
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
                        end
                        if found then
                            if not obj:FindFirstAncestorOfClass("Model") or
                               not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                                applyHighlight(obj, Color3.fromRGB(255, 100, 200), "Child")
                            end
                        end
                    end
                end
            end
        end)
    end)

    -- ❤️ 器官
    addToggle("❤️ 器官透视描边 (增强)", false, function(s)
        organActive = s
        if organThread then task.cancel(organThread); organThread = nil end
        if not s then removeHighlights() return end
        organThread = task.spawn(function()
            local organKeywords = {"heart","心脏","kidney","肾脏","liver","肝脏","lung","肺","brain","脑","organ","器官","stomach","胃","intestine","肠","bladder","膀胱","pancreas","胰腺","spleen","脾","gallbladder","胆囊","bone","骨头","muscle","肌肉","skin","皮肤","tissue","组织","vein","静脉","artery","动脉","nerve","神经","spinal","脊柱","rib","肋骨","pelvis","骨盆","skull","头骨","jaw","下颌"}
            while organActive do
                task.wait(10)
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local n = obj.Name:lower()
                        local found = false
                        for _, kw in ipairs(organKeywords) do
                            if n:find(kw) then found = true; break end
                        end
                        if not found and obj.Parent and obj.Parent:IsA("Model") then
                            local model = obj.Parent
                            local sphereCount, hasOrganName = 0, false
                            local mname = model.Name:lower()
                            for _, kw in ipairs(organKeywords) do
                                if mname:find(kw) then hasOrganName = true; break end
                            end
                            for _, child in pairs(model:GetChildren()) do
                                if child:IsA("BasePart") then
                                    if child:IsA("Part") and child.Shape == Enum.PartType.Ball then
                                        sphereCount = sphereCount + 1
                                    end
                                    local cn = child.Name:lower()
                                    for _, kw in ipairs(organKeywords) do
                                        if cn:find(kw) then hasOrganName = true; break end
                                    end
                                end
                            end
                            if sphereCount >= 2 or hasOrganName then found = true end
                        end
                        if found then
                            if not obj:FindFirstAncestorOfClass("Model") or
                               not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                                applyHighlight(obj, Color3.fromRGB(255, 80, 80), "Organ")
                            end
                        end
                    end
                end
            end
        end)
    end)

    -- 🚪 传送门
    addToggle("🚪 传送门透视描边", false, function(s)
        portalActive = s
        if portalThread then task.cancel(portalThread); portalThread = nil end
        if not s then removeHighlights() return end
        portalThread = task.spawn(function()
            while portalActive do
                task.wait(10)
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local n = obj.Name:lower()
                        local isPortal = false
                        if n:find("vortex") or n:find("portal") or n:find("传送门") or n:find("teleport") or n:find("gate") or n:find("door") then isPortal = true end
                        if obj:IsA("Part") and obj.Shape == Enum.PartType.Cylinder then
                            if n:find("portal") or n:find("vortex") then isPortal = true end
                        end
                        if not isPortal then
                            for _, child in pairs(obj:GetChildren()) do
                                if child:IsA("BasePart") then
                                    local cn = child.Name:lower()
                                    if cn:find("vortex") or cn:find("portal") then isPortal = true; break end
                                end
                            end
                        end
                        if isPortal then
                            if not obj:FindFirstAncestorOfClass("Model") or
                               not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                                if not obj:GetAttribute("_isCorrectPortal") then
                                    applyHighlight(obj, Color3.fromRGB(100, 200, 255), "Portal")
                                end
                            end
                        end
                    end
                end
            end
        end)
    end)

    -- 🔥 灵魂火焰
    addToggle("🔥 灵魂火焰描边", false, function(s)
        soulActive = s
        if soulThread then task.cancel(soulThread); soulThread = nil end
        if not s then removeHighlights() return end
        soulThread = task.spawn(function()
            local soulNames = {"fire","flame","soul","spirit","火焰","灵魂","火","灵"}
            while soulActive do
                task.wait(10)
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local n = obj.Name:lower()
                        local found = false
                        for _, name in ipairs(soulNames) do
                            if n:find(name) then found = true; break end
                        end
                        if found then
                            if not obj:FindFirstAncestorOfClass("Model") or
                               not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                                applyHighlight(obj, Color3.fromRGB(255, 150, 50), "Soul")
                            end
                        end
                    end
                end
            end
        end)
    end)

    -- 🧟 怪物
    addToggle("🧟 怪物透视 (红色描边)", false, function(s)
        monsterActive = s
        if monsterThread then task.cancel(monsterThread); monsterThread = nil end
        if not s then removeHighlights() return end
        monsterThread = task.spawn(function()
            local monsterKeywords = {"monster","zombie","enemy","creature","ghost","demon","skeleton","怪物","僵尸","敌人","生物","鬼","恶魔","骷髅","boss","守卫","guard","spider","狼","wolf","bear","熊","mummy","木乃伊","vampire","吸血鬼","werewolf","狼人","golem","魔像"}
            while monsterActive do
                task.wait(10)
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local n = obj.Name:lower()
                        local found = false
                        for _, kw in ipairs(monsterKeywords) do
                            if n:find(kw) then found = true; break end
                        end
                        if not found and obj.Parent and obj.Parent:IsA("Model") then
                            local mname = obj.Parent.Name:lower()
                            for _, kw in ipairs(monsterKeywords) do
                                if mname:find(kw) then found = true; break end
                            end
                            if not found and obj.Parent:FindFirstChildOfClass("Humanoid") then
                                local model = obj.Parent
                                if model ~= player.Character then found = true end
                            end
                        end
                        if found then
                            if not obj:FindFirstAncestorOfClass("Model") or
                               not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                                applyHighlight(obj, Color3.fromRGB(255, 0, 0), "Monster")
                            end
                        end
                    end
                end
            end
        end)
    end)

    -- 🧪 药水
    addToggle("🧪 药水瓶子透视", false, function(s)
        potionActive = s
        if potionThread then task.cancel(potionThread); potionThread = nil end
        if not s then removeHighlights() return end
        potionThread = task.spawn(function()
            local potionKeywords = {"potion","药水","bottle","瓶子","flask","vial","drink","health","mana","cyl","cone"}
            while potionActive do
                task.wait(10)
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local n = obj.Name:lower()
                        local found = false
                        for _, kw in ipairs(potionKeywords) do
                            if n:find(kw) then found = true; break end
                        end
                        if not found and obj.Parent and obj.Parent:IsA("Model") then
                            local model = obj.Parent
                            local hasCylinder = false
                            for _, child in pairs(model:GetChildren()) do
                                if child:IsA("BasePart") then
                                    local cname = child.Name:lower()
                                    if cname:find("cylinder") or cname:find("cone") or cname:find("瓶") then hasCylinder = true end
                                    if child:IsA("Part") and child.Shape == Enum.PartType.Cylinder then hasCylinder = true end
                                end
                            end
                            if hasCylinder then
                                local mname = model.Name:lower()
                                for _, kw in ipairs(potionKeywords) do
                                    if mname:find(kw) then found = true; break end
                                end
                                if not found then
                                    for _, child in pairs(model:GetChildren()) do
                                        if child:IsA("BasePart") then
                                            local cn = child.Name:lower()
                                            for _, kw in ipairs(potionKeywords) do
                                                if cn:find(kw) then found = true; break end
                                            end
                                            if found then break end
                                        end
                                    end
                                end
                            end
                        end
                        if found then
                            if not obj:FindFirstAncestorOfClass("Model") or
                               not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                                applyHighlight(obj, Color3.fromRGB(180, 80, 255), "Potion")
                            end
                        end
                    end
                end
            end
        end)
    end)

    -- 📖 书籍
    addToggle("📖 书籍透视", false, function(s)
        bookActive = s
        if bookThread then task.cancel(bookThread); bookThread = nil end
        if not s then removeHighlights() return end
        bookThread = task.spawn(function()
            local bookNames = {"book","书籍","page","纸","note","笔记","日记","diary"}
            while bookActive do
                task.wait(10)
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local n = obj.Name:lower()
                        local found = false
                        for _, name in ipairs(bookNames) do
                            if n:find(name) then found = true; break end
                        end
                        if found then
                            if not obj:FindFirstAncestorOfClass("Model") or
                               not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                                applyHighlight(obj, Color3.fromRGB(50, 180, 255), "Book")
                            end
                        end
                    end
                end
            end
        end)
    end)

    -- 🪆 木偶
    addToggle("🪆 木偶透视", false, function(s)
        puppetActive = s
        if puppetThread then task.cancel(puppetThread); puppetThread = nil end
        if not s then removeHighlights() return end
        puppetThread = task.spawn(function()
            local puppetNames = {"puppet","木偶","doll","娃娃","marionette","提线"}
            while puppetActive do
                task.wait(10)
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local n = obj.Name:lower()
                        local found = false
                        for _, name in ipairs(puppetNames) do
                            if n:find(name) then found = true; break end
                        end
                        if found then
                            if not obj:FindFirstAncestorOfClass("Model") or
                               not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                                applyHighlight(obj, Color3.fromRGB(255, 100, 180), "Puppet")
                            end
                        end
                    end
                end
            end
        end)
    end)

    -- 🎎 五种颜色的娃娃
    addToggle("🎎 五种颜色的娃娃透视", false, function(s)
        dollActive = s
        if dollThread then task.cancel(dollThread); dollThread = nil end
        if not s then removeHighlights() return end
        dollThread = task.spawn(function()
            local dollKeywords = {"doll","洋娃娃","娃娃","red doll","blue doll","green doll","yellow doll","purple doll","pink doll","白色娃娃","黑色娃娃","红色娃娃","蓝色娃娃","绿色娃娃","黄色娃娃","紫色娃娃","五色","color doll","rainbow doll"}
            while dollActive do
                task.wait(10)
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
                                local hue = (tick() * 0.1) % 1
                                applyHighlight(obj, Color3.fromHSV(hue, 1, 1), "Doll")
                            end
                        end
                    end
                end
            end
        end)
    end)

    -- 👤 娃娃头
    addToggle("👤 洋娃娃的头透视", false, function(s)
        dollHeadActive = s
        if dollHeadThread then task.cancel(dollHeadThread); dollHeadThread = nil end
        if not s then removeHighlights() return end
        dollHeadThread = task.spawn(function()
            local headKeywords = {"head","头","头部","doll head","娃娃头","洋娃娃头","face","脸","hair","头发","eye","眼睛"}
            while dollHeadActive do
                task.wait(10)
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local n = obj.Name:lower()
                        local found = false
                        for _, kw in ipairs(headKeywords) do
                            if n:find(kw) then found = true; break end
                        end
                        if not found and obj.Parent and obj.Parent:IsA("Model") then
                            local mname = obj.Parent.Name:lower()
                            if mname:find("doll") or mname:find("娃娃") then
                                for _, kw in ipairs(headKeywords) do
                                    if n:find(kw) then found = true; break end
                                end
                            end
                        end
                        if found then
                            if not obj:FindFirstAncestorOfClass("Model") or
                               not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                                applyHighlight(obj, Color3.fromRGB(255, 200, 100), "DollHead")
                            end
                        end
                    end
                end
            end
        end)
    end)

    -- 🖼️ 画作
    addToggle("🖼️ 画作透视 (识别所有画)", false, function(s)
        paintingActive = s
        if paintingThread then task.cancel(paintingThread); paintingThread = nil end
        if not s then removeHighlights() return end
        paintingThread = task.spawn(function()
            local paintingKeywords = {"painting","画","画作","picture","图片","canvas","油画","art","艺术品","frame","画框","portrait","肖像","landscape","风景画","abstract","抽象画"}
            while paintingActive do
                task.wait(10)
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local n = obj.Name:lower()
                        local found = false
                        for _, kw in ipairs(paintingKeywords) do
                            if n:find(kw) then found = true; break end
                        end
                        if found then
                            if not obj:FindFirstAncestorOfClass("Model") or
                               not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                                applyHighlight(obj, Color3.fromRGB(255, 200, 255), "Painting")
                            end
                        end
                    end
                end
            end
        end)
    end)

    -- ====== 传送功能 ======
    addDivider()
    addTitle("📍 传送功能")

    addButton("🗝️ 传送至最近钥匙", Color3.fromRGB(255, 200, 50), function()
        teleportToNearest({"key","钥匙"}, "钥匙")
    end)
    addButton("📦 传送至最近箱子", Color3.fromRGB(255, 180, 80), function()
        teleportToNearest({"chest","箱","箱子","crate"}, "箱子")
    end)
    addButton("🔒 传送至最近保险箱", Color3.fromRGB(50, 255, 150), function()
        teleportToNearest({"safe","保险箱","vault","金库"}, "保险箱")
    end)
    addButton("💻 传送至最近代码", Color3.fromRGB(100, 200, 255), function()
        teleportToNearest({"code","密码","数字","号码","keypad","键盘"}, "代码")
    end)
    addButton("🍽️ 传送至最近盘子", Color3.fromRGB(255, 200, 100), function()
        teleportToNearest({"plate","盘子","碟子","dish"}, "盘子")
    end)
    addButton("🔥 传送至最近打火机", Color3.fromRGB(255, 150, 50), function()
        teleportToNearest({"lighter","打火机","火机","点火器"}, "打火机")
    end)
    addButton("👶 传送至最近孩子", Color3.fromRGB(255, 100, 200), function()
        teleportToNearest({"child","kid","孩子","小孩","儿子","女儿","baby","婴儿","dino kid","kraken kid","squid kid","koala kid","恐龙小子","海怪小子","鱿鱼小子","考拉小子"}, "孩子")
    end)
    addButton("🧪 传送至最近药水", Color3.fromRGB(180, 80, 255), function()
        teleportToNearest({"potion","药水","bottle","瓶子","flask","vial","drink"}, "药水")
    end)
    addButton("📖 传送至最近书籍", Color3.fromRGB(50, 180, 255), function()
        teleportToNearest({"book","书籍","note","笔记","diary"}, "书籍")
    end)
    addButton("🪆 传送至最近木偶", Color3.fromRGB(255, 100, 180), function()
        teleportToNearest({"puppet","木偶","doll","娃娃"}, "木偶")
    end)
    addButton("🎎 传送至最近洋娃娃", Color3.fromRGB(255, 100, 200), function()
        teleportToNearest({"doll","洋娃娃","娃娃"}, "洋娃娃")
    end)
    addButton("👤 传送至最近娃娃头", Color3.fromRGB(255, 200, 100), function()
        teleportToNearest({"doll head","娃娃头","洋娃娃头","head"}, "娃娃头")
    end)
    addButton("🖼️ 传送至最近画作", Color3.fromRGB(200, 100, 255), function()
        teleportToNearest({"painting","画","画作","picture"}, "画作")
    end)

    -- 特殊功能：正确传送门
    addDivider()
    addTitle("🎯 特殊功能")

    local function findCorrectPortal()
        if correctPortalHL then correctPortalHL:Destroy(); correctPortalHL = nil end
        correctPortal = nil
        local portals = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local n = obj.Name:lower()
                local isPortal = false
                if n:find("vortex") or n:find("portal") or n:find("传送门") or n:find("teleport") or n:find("gate") then isPortal = true end
                if obj:IsA("Part") and obj.Shape == Enum.PartType.Cylinder then
                    if n:find("portal") or n:find("vortex") then isPortal = true end
                end
                if not isPortal then
                    for _, child in pairs(obj:GetChildren()) do
                        if child:IsA("BasePart") then
                            local cn = child.Name:lower()
                            if cn:find("vortex") or cn:find("portal") then isPortal = true; break end
                        end
                    end
                end
                if isPortal then
                    if not obj:FindFirstAncestorOfClass("Model") or
                       not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                        table.insert(portals, obj)
                    end
                end
            end
        end
        if #portals == 0 then print("⚠️ 未找到任何传送门") return end
        local bestPortal, bestScore = nil, 0
        for _, portal in ipairs(portals) do
            local score = 0
            if portal.BrickColor then
                local bc = portal.BrickColor.Name:lower()
                if bc:find("green") or bc:find("blue") or bc:find("yellow") or bc:find("cyan") then score = score + 3 end
                if bc:find("purple") or bc:find("violet") or bc:find("magenta") then score = score + 2 end
            end
            if portal:GetAttribute("Correct") or portal:GetAttribute("True") or portal:GetAttribute("正确") then score = score + 10 end
            if portal.Position.Y > 0 and portal.Position.Y < 50 then score = score + 2 end
            local n = portal.Name:lower()
            if n:find("correct") or n:find("true") or n:find("正") or n:find("真") then score = score + 8 end
            if n:find("vortex") then score = score + 5 end
            if portal:IsA("Part") and portal.Shape == Enum.PartType.Cylinder then score = score + 4 end
            if score > bestScore then bestScore, bestPortal = score, portal end
        end
        if not bestPortal and #portals > 0 then
            for _, portal in ipairs(portals) do
                if portal.Name:lower():find("vortex") then bestPortal = portal; break end
            end
            if not bestPortal then bestPortal = portals[1] end
        end
        if bestPortal then
            correctPortal = bestPortal
            correctPortalHL = applyHighlight(bestPortal, Color3.fromRGB(0, 255, 100), "CorrectPortal")
            if correctPortalHL then
                correctPortalHL.FillTransparency = 0.4
                correctPortalHL.OutlineTransparency = 0
                correctPortalHL.OutlineColor = Color3.fromRGB(0, 255, 100)
            end
            bestPortal:SetAttribute("_isCorrectPortal", true)
            print("✅ 已标记正确传送门: " .. bestPortal.Name)
        end
    end

    addButton("🎯 找正确的传送门", Color3.fromRGB(0, 180, 80), function()
        findCorrectPortal()
    end)

    addButton("🧹 清除所有高亮", Color3.fromRGB(180, 40, 40), function()
        keyActive, chestActive, safeActive, codeActive = false, false, false, false
        plateActive, lighterActive = false, false
        childActive = false
        organActive, portalActive, soulActive = false, false, false
        potionActive, bookActive, puppetActive, monsterActive = false, false, false, false
        dollActive, dollHeadActive, paintingActive = false, false, false
        if keyThread then task.cancel(keyThread); keyThread = nil end
        if chestThread then task.cancel(chestThread); chestThread = nil end
        if safeThread then task.cancel(safeThread); safeThread = nil end
        if codeThread then task.cancel(codeThread); codeThread = nil end
        if plateThread then task.cancel(plateThread); plateThread = nil end
        if lighterThread then task.cancel(lighterThread); lighterThread = nil end
        if childThread then task.cancel(childThread); childThread = nil end
        if organThread then task.cancel(organThread); organThread = nil end
        if portalThread then task.cancel(portalThread); portalThread = nil end
        if soulThread then task.cancel(soulThread); soulThread = nil end
        if potionThread then task.cancel(potionThread); potionThread = nil end
        if bookThread then task.cancel(bookThread); bookThread = nil end
        if puppetThread then task.cancel(puppetThread); puppetThread = nil end
        if monsterThread then task.cancel(monsterThread); monsterThread = nil end
        if dollThread then task.cancel(dollThread); dollThread = nil end
        if dollHeadThread then task.cancel(dollHeadThread); dollHeadThread = nil end
        if paintingThread then task.cancel(paintingThread); paintingThread = nil end
        removeHighlights()
        if correctPortalHL then correctPortalHL:Destroy(); correctPortalHL = nil end
        correctPortal = nil
        print("🧹 已清除所有高亮")
    end)

    addDivider()
    addLabel("💡 钥匙: 金色 | 箱子: 橙色 | 保险箱: 亮绿 | 代码: 淡蓝")
    addLabel("💡 盘子: 淡黄 | 打火机: 橙色 | 孩子: 粉红 | 器官: 红色")
    addLabel("💡 传送门: 蓝色 | 灵魂火焰: 橙色 | 怪物: 红色")
    addLabel("💡 药水: 紫色 | 书籍: 蓝色 | 木偶: 粉色")
    addLabel("💡 五种颜色的娃娃: 彩虹色 | 娃娃头: 淡黄色 | 画作: 淡紫色")
    addLabel("💡 所有透视每10秒扫描一次，不卡顿")

    panel.CanvasSize = UDim2.new(0, 0, 0, #panel:GetChildren() * 32 + 20)
end
-- ============================================================
--  面板：甩飞
-- ============================================================
local function loadFlyOff()
    clearPanel()
    addTitle("🌀 静默甩飞")

    local isSilentFlyEnabled = false
    local flyConnections = {}
    local isLoopFlyEnabled = false
    local loopFlyConnections = {}
    local selectedPlayer = nil
    local isTeleportFlying = false
    local originalPosition = nil
    local wasSilentFlyEnabledBefore = false
    local loopTargetPlayer = nil
    local playerButtons = {}
    local playerListScrolling = nil
    local statusLabel = nil

    local function SafeGetCharacter(targetPlayer)
        if not targetPlayer then return nil end
        local char = targetPlayer.Character
        if not char or not char.Parent then return nil end
        return char
    end

    local function SafeGetHRP(char)
        if not char then return nil end
        return char:FindFirstChild("HumanoidRootPart")
    end

    local function SafeGetHumanoid(char)
        if not char then return nil end
        return char:FindFirstChildOfClass("Humanoid")
    end

    local function IsPlayerFlying(targetPlayer)
        if not targetPlayer then return false end
        local char = SafeGetCharacter(targetPlayer)
        if not char then return false end
        local hrp = SafeGetHRP(char)
        if not hrp then return false end
        local hum = SafeGetHumanoid(char)
        if not hum then return false end
        local vel = hrp.AssemblyLinearVelocity
        if vel.Magnitude > 30 then return true end
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.FallingDown or
           state == Enum.HumanoidStateType.Ragdoll then
            return true
        end
        return false
    end

    local function ToggleSilentFly(state)
        isSilentFlyEnabled = state
        for _, conn in pairs(flyConnections) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
        flyConnections = {}
        if isSilentFlyEnabled then
            local stepConn = runService.Stepped:Connect(function()
                if not isSilentFlyEnabled then return end
                local char = SafeGetCharacter(player)
                local hum = SafeGetHumanoid(char)
                local hrp = SafeGetHRP(char)
                if hum and hrp then
                    pcall(function()
                        hum.PlatformStand = false
                        hum.Sit = false
                        hum.AutoRotate = true
                        local state = hum:GetState()
                        if state == Enum.HumanoidStateType.Physics or
                           state == Enum.HumanoidStateType.FallingDown or
                           state == Enum.HumanoidStateType.Ragdoll then
                            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                        end
                    end)
                end
                if isSilentFlyEnabled then
                    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
                        if otherPlayer ~= player then
                            local otherChar = SafeGetCharacter(otherPlayer)
                            if otherChar then
                                for _, part in pairs(otherChar:GetDescendants()) do
                                    if part:IsA("BasePart") then
                                        pcall(function() part.CanCollide = false end)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            table.insert(flyConnections, stepConn)

            local heartbeatConn = runService.Heartbeat:Connect(function()
                if not isSilentFlyEnabled then return end
                local char = SafeGetCharacter(player)
                local hrp = SafeGetHRP(char)
                local hum = SafeGetHumanoid(char)
                if hum and hrp then
                    pcall(function()
                        local currentVel = hrp.AssemblyLinearVelocity
                        hum:ChangeState(Enum.HumanoidStateType.Running)
                        local safeY = currentVel.Y
                        if safeY > 40 then safeY = 40 end
                        if safeY < -40 then safeY = -40 end
                        hrp.AssemblyAngularVelocity = Vector3.new(50000, 50000, 50000)
                        hrp.AssemblyLinearVelocity = Vector3.new(
                            currentVel.X * 1.1,
                            safeY,
                            currentVel.Z * 1.1
                        )
                        runService.RenderStepped:Wait()
                        if hrp and hrp.Parent then
                            hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        end
                    end)
                end
            end)
            table.insert(flyConnections, heartbeatConn)
        end
        if statusLabel then
            statusLabel.Text = isSilentFlyEnabled and "静默甩飞: ON" or "静默甩飞: OFF"
        end
    end

    local function TeleportToPlayer()
        if not selectedPlayer then
            print("请先选择一名玩家")
            if statusLabel then statusLabel.Text = "⚠️ 未选择玩家" end
            return
        end
        local char = SafeGetCharacter(selectedPlayer)
        if not char then
            print("目标玩家不在游戏中")
            if statusLabel then statusLabel.Text = "⚠️ 目标不在游戏中" end
            return
        end
        local hrp = SafeGetHRP(char)
        if not hrp then
            print("目标玩家没有角色")
            if statusLabel then statusLabel.Text = "⚠️ 目标无角色" end
            return
        end
        local myChar = SafeGetCharacter(player)
        local myHrp = SafeGetHRP(myChar)
        if not myHrp then
            print("自己没有角色")
            return
        end
        local lookVector = hrp.CFrame.LookVector
        local targetPos = hrp.Position + lookVector * 5
        myHrp.CFrame = CFrame.new(targetPos)
        print("已传送到 " .. selectedPlayer.Name .. " 前方")
        if statusLabel then statusLabel.Text = "✅ 已传送" end
    end

    local function TeleportFlyToPlayer()
        if isTeleportFlying then
            print("传送甩飞正在执行中...")
            return
        end
        if not selectedPlayer then
            print("请先选择一名玩家")
            if statusLabel then statusLabel.Text = "⚠️ 未选择玩家" end
            return
        end
        local targetChar = SafeGetCharacter(selectedPlayer)
        if not targetChar then
            print("目标玩家不在游戏中")
            if statusLabel then statusLabel.Text = "⚠️ 目标不在游戏中" end
            return
        end
        local targetHrp = SafeGetHRP(targetChar)
        if not targetHrp then
            print("目标玩家没有角色")
            if statusLabel then statusLabel.Text = "⚠️ 目标无角色" end
            return
        end
        local myChar = SafeGetCharacter(player)
        local myHrp = SafeGetHRP(myChar)
        if not myHrp then
            print("自己没有角色")
            return
        end

        isTeleportFlying = true
        originalPosition = myHrp.Position
        wasSilentFlyEnabledBefore = isSilentFlyEnabled
        if not isSilentFlyEnabled then
            ToggleSilentFly(true)
        end

        print("开始传送甩飞 " .. selectedPlayer.Name .. "（3秒）")
        if statusLabel then statusLabel.Text = "⏳ 传送甩飞中..." end

        local startTime = tick()
        local direction = 1
        local lastSwitch = tick()
        local detected = false

        while tick() - startTime < 3 do
            local currentTargetChar = SafeGetCharacter(selectedPlayer)
            if not currentTargetChar then
                print("目标已离开")
                if statusLabel then statusLabel.Text = "⚠️ 目标已离开" end
                break
            end
            local currentTargetHrp = SafeGetHRP(currentTargetChar)
            if not currentTargetHrp then break end
            if tick() - lastSwitch > 0.15 then
                direction = direction * -1
                lastSwitch = tick()
            end
            local myChar2 = SafeGetCharacter(player)
            local myHrp2 = SafeGetHRP(myChar2)
            if myHrp2 then
                local offset = direction * 2
                local targetPos = currentTargetHrp.Position + currentTargetHrp.CFrame.LookVector * offset
                myHrp2.CFrame = CFrame.new(targetPos)
            end
            if IsPlayerFlying(selectedPlayer) and not detected then
                detected = true
                if statusLabel then statusLabel.Text = "🟢 已甩飞该玩家" end
                print("✅ " .. selectedPlayer.Name .. " 已被甩飞")
            end
            task.wait(0.05)
        end

        if not detected and SafeGetCharacter(selectedPlayer) then
            if statusLabel then statusLabel.Text = "🔴 甩飞无效" end
            print("⚠️ " .. selectedPlayer.Name .. " 甩飞无效")
        end

        local myChar3 = SafeGetCharacter(player)
        local myHrp3 = SafeGetHRP(myChar3)
        if myHrp3 and originalPosition then
            myHrp3.Position = originalPosition
            myHrp3.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            myHrp3.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            print("已回到初始位置")
        end

        if not wasSilentFlyEnabledBefore then
            ToggleSilentFly(false)
        end
        isTeleportFlying = false
        if statusLabel then statusLabel.Text = "✅ 传送甩飞完成" end
        print("传送甩飞完成")
    end

    local function ToggleLoopFly(state)
        isLoopFlyEnabled = state
        for _, conn in pairs(loopFlyConnections) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
        loopFlyConnections = {}
        if isLoopFlyEnabled then
            if not selectedPlayer then
                print("请先选择一名玩家")
                if statusLabel then statusLabel.Text = "⚠️ 未选择玩家" end
                isLoopFlyEnabled = false
                return
            end
            local targetChar = SafeGetCharacter(selectedPlayer)
            if not targetChar then
                print("目标玩家不在游戏中")
                if statusLabel then statusLabel.Text = "⚠️ 目标不在游戏中" end
                isLoopFlyEnabled = false
                return
            end
            local myChar = SafeGetCharacter(player)
            local myHrp = SafeGetHRP(myChar)
            if not myHrp then
                print("自己没有角色")
                isLoopFlyEnabled = false
                return
            end
            loopTargetPlayer = selectedPlayer
            originalPosition = myHrp.Position
            wasSilentFlyEnabledBefore = isSilentFlyEnabled
            if not isSilentFlyEnabled then
                ToggleSilentFly(true)
            end
            print("开启循环甩飞: " .. loopTargetPlayer.Name)
            if statusLabel then statusLabel.Text = "🔄 循环甩飞中..." end

            local loopConn = runService.Heartbeat:Connect(function()
                if not isLoopFlyEnabled then return end
                local currentTargetChar = SafeGetCharacter(loopTargetPlayer)
                if not currentTargetChar then
                    print("目标已离开，停止循环")
                    if statusLabel then statusLabel.Text = "⚠️ 目标已离开" end
                    ToggleLoopFly(false)
                    return
                end
                local currentTargetHrp = SafeGetHRP(currentTargetChar)
                if not currentTargetHrp then return end
                local direction = math.sin(tick() * 6)
                local offset = direction * 2.5
                local myChar2 = SafeGetCharacter(player)
                local myHrp2 = SafeGetHRP(myChar2)
                if myHrp2 then
                    local targetPos = currentTargetHrp.Position + currentTargetHrp.CFrame.LookVector * offset
                    myHrp2.CFrame = CFrame.new(targetPos)
                end
                if IsPlayerFlying(loopTargetPlayer) then
                    if statusLabel then statusLabel.Text = "🟢 已甩飞该玩家" end
                else
                    if statusLabel then statusLabel.Text = "🔴 甩飞无效" end
                end
            end)
            table.insert(loopFlyConnections, loopConn)

            local leaveConn = game.Players.PlayerRemoving:Connect(function(p)
                if p == loopTargetPlayer and isLoopFlyEnabled then
                    print("目标已离开，停止循环")
                    if statusLabel then statusLabel.Text = "⚠️ 目标已离开" end
                    ToggleLoopFly(false)
                end
            end)
            table.insert(loopFlyConnections, leaveConn)
        else
            print("关闭循环甩飞")
            if statusLabel then statusLabel.Text = "⏸️ 已停止" end
            local myChar = SafeGetCharacter(player)
            local myHrp = SafeGetHRP(myChar)
            if myHrp and originalPosition then
                myHrp.Position = originalPosition
                myHrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                myHrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                print("已回到初始位置")
            end
            if not wasSilentFlyEnabledBefore then
                ToggleSilentFly(false)
            end
            loopTargetPlayer = nil
            originalPosition = nil
        end
    end

    local function RefreshPlayerList()
        if not playerListScrolling then return end
        for _, btn in pairs(playerButtons) do
            pcall(function() btn:Destroy() end)
        end
        playerButtons = {}
        local players = {}
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player then
                table.insert(players, p)
            end
        end
        table.sort(players, function(a, b) return a.Name < b.Name end)
        local yPos = 5
        for _, p in pairs(players) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.9, 0, 0, 22)
            btn.Position = UDim2.new(0.05, 0, 0, yPos)
            btn.Text = p.Name
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            btn.BackgroundTransparency = 0.5
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.SourceSans
            btn.TextSize = 12
            btn.BorderSizePixel = 0
            btn.Parent = playerListScrolling
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 4)
            corner.Parent = btn
            btn.MouseButton1Click:Connect(function()
                for _, b in pairs(playerButtons) do
                    b.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                    b.BackgroundTransparency = 0.5
                end
                btn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
                btn.BackgroundTransparency = 0.5
                selectedPlayer = p
                if statusLabel then statusLabel.Text = "已选: " .. p.Name end
                print("已选择玩家: " .. p.Name)
            end)
            table.insert(playerButtons, btn)
            yPos = yPos + 27
        end
        playerListScrolling.CanvasSize = UDim2.new(0, 0, 0, yPos + 5)
    end

    addToggle("静默甩飞", false, function(s)
        ToggleSilentFly(s)
    end)

    addLabel("选择目标玩家（点击列表选中）")
    local listFrame = Instance.new("Frame")
    listFrame.Parent = panel
    listFrame.Size = UDim2.new(1,-4,0,80)
    listFrame.Position = UDim2.new(0,2,0,#panel:GetChildren()*32+4)
    listFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 40)
    listFrame.BackgroundTransparency = 0.5
    listFrame.BorderSizePixel = 1
    listFrame.BorderColor3 = Color3.fromRGB(40,45,65)
    listFrame.ClipsDescendants = true
    local lc = Instance.new("UICorner")
    lc.Parent = listFrame
    lc.CornerRadius = UDim.new(0,4)

    playerListScrolling = Instance.new("ScrollingFrame")
    playerListScrolling.Parent = listFrame
    playerListScrolling.Size = UDim2.new(1,-4,1,0)
    playerListScrolling.Position = UDim2.new(0,2,0,0)
    playerListScrolling.BackgroundTransparency = 1
    playerListScrolling.ScrollBarThickness = 4
    playerListScrolling.CanvasSize = UDim2.new(0,0,0,0)

    RefreshPlayerList()
    addButton("刷新玩家列表", Color3.fromRGB(30,100,160), RefreshPlayerList)
    addDivider()
    addTitle("🎯 操作")
    addButton("🚀 传送 (前方5m)", Color3.fromRGB(0,80,160), TeleportToPlayer)
    addButton("🔄 传送甩飞 (3秒)", Color3.fromRGB(0,130,0), TeleportFlyToPlayer)

    local loopBtn = Instance.new("TextButton")
    loopBtn.Parent = panel
    loopBtn.Size = UDim2.new(1,-4,0,30)
    loopBtn.Position = UDim2.new(0,2,0,#panel:GetChildren()*32+4)
    loopBtn.BackgroundColor3 = Color3.fromRGB(0,180,0)
    loopBtn.BackgroundTransparency = 0.5
    loopBtn.BorderSizePixel = 1
    loopBtn.BorderColor3 = Color3.fromRGB(0,200,0)
    loopBtn.Text = "🔄 循环甩飞 OFF"
    loopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    loopBtn.TextSize = 12
    loopBtn.Font = Enum.Font.Gotham
    local c = Instance.new("UICorner")
    c.Parent = loopBtn
    c.CornerRadius = UDim.new(0,4)
    loopBtn.MouseButton1Click:Connect(function()
        isLoopFlyEnabled = not isLoopFlyEnabled
        ToggleLoopFly(isLoopFlyEnabled)
        if isLoopFlyEnabled then
            loopBtn.Text = "🔄 循环甩飞 ON"
            loopBtn.BackgroundColor3 = Color3.fromRGB(180,0,0)
            loopBtn.BorderColor3 = Color3.fromRGB(200,0,0)
        else
            loopBtn.Text = "🔄 循环甩飞 OFF"
            loopBtn.BackgroundColor3 = Color3.fromRGB(0,180,0)
            loopBtn.BorderColor3 = Color3.fromRGB(0,200,0)
        end
    end)

    statusLabel = Instance.new("TextLabel")
    statusLabel.Parent = panel
    statusLabel.Size = UDim2.new(1,-4,0,18)
    statusLabel.Position = UDim2.new(0,2,0,#panel:GetChildren()*32+4)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "等待选择玩家..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusLabel.TextSize = 11
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center

    panel.CanvasSize = UDim2.new(0,0,0,#panel:GetChildren()*32+20)

    game.Players.PlayerAdded:Connect(RefreshPlayerList)
    game.Players.PlayerRemoving:Connect(function(p)
        RefreshPlayerList()
        if isLoopFlyEnabled and loopTargetPlayer and not game.Players:FindFirstChild(loopTargetPlayer.Name) then
            ToggleLoopFly(false)
            loopBtn.Text = "🔄 循环甩飞 OFF"
            loopBtn.BackgroundColor3 = Color3.fromRGB(0,180,0)
            loopBtn.BorderColor3 = Color3.fromRGB(0,200,0)
        end
    end)
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
                { headHitbox, headHitbox.Position, Vector3.new(0,0,0) }
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
        local hitSound = char:FindFirstChild("HitSound") or Instance.new("Sound")
        if not hitSound.Parent then
            hitSound.SoundId = "rbxassetid://8679627751"
            hitSound.Volume = 1
            hitSound.Parent = char
        end
        hitSound:Play()
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
            print("杀戮光环已开启")
        else
            print("杀戮光环已关闭")
        end
    end)

    local infAmmoActive = false
    local infAmmoConnections = {}
    local statusLabel = addLabel("无限子弹: OFF", Color3.fromRGB(255, 255, 255))

    local function lockAmmoInTool(tool)
        if not tool or not tool:IsA("Tool") then return end
        for _, child in pairs(tool:GetChildren()) do
            if child:IsA("NumberValue") or child:IsA("IntValue") then
                local name = child.Name:lower()
                if name:find("ammo") or name:find("bullet") or name:find("magazine") or name:find("子弹") or name:find("弹药") then
                    child.Value = 999
                    if not child:GetAttribute("_ammoLocked") then
                        child:SetAttribute("_ammoLocked", true)
                        local conn = child.Changed:Connect(function()
                            if infAmmoActive then
                                child.Value = 999
                            end
                        end)
                        table.insert(infAmmoConnections, conn)
                    end
                end
            end
        end
    end

    local function lockAllTools()
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            for _, tool in pairs(backpack:GetChildren()) do
                lockAmmoInTool(tool)
            end
        end
        local char = player.Character
        if char then
            for _, tool in pairs(char:GetChildren()) do
                lockAmmoInTool(tool)
            end
        end
    end

    local function cleanAmmoConnections()
        for _, conn in pairs(infAmmoConnections) do
            pcall(function() conn:Disconnect() end)
        end
        infAmmoConnections = {}
    end

    local function setupBackpackListener()
        local backpack = player:FindFirstChild("Backpack")
        if not backpack then return end
        local conn = backpack.ChildAdded:Connect(function(tool)
            if infAmmoActive then
                lockAmmoInTool(tool)
            end
        end)
        table.insert(infAmmoConnections, conn)
    end

    local function setupCharacterListener()
        local function onCharAdded(char)
            local conn = char.ChildAdded:Connect(function(tool)
                if infAmmoActive then
                    lockAmmoInTool(tool)
                end
            end)
            table.insert(infAmmoConnections, conn)
            for _, tool in pairs(char:GetChildren()) do
                lockAmmoInTool(tool)
            end
        end
        if player.Character then
            onCharAdded(player.Character)
        end
        local charConn = player.CharacterAdded:Connect(onCharAdded)
        table.insert(infAmmoConnections, charConn)
    end

    local function initAmmoSystem()
        cleanAmmoConnections()
        setupBackpackListener()
        setupCharacterListener()
        lockAllTools()
    end

    addToggle("无限子弹（改进版）", false, function(s)
        infAmmoActive = s
        if s then
            initAmmoSystem()
            statusLabel.Text = "无限子弹: ON (改进)"
            statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            print("无限子弹已开启（改进版）")
        else
            cleanAmmoConnections()
            statusLabel.Text = "无限子弹: OFF"
            statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            print("无限子弹已关闭")
        end
    end)

    addDivider()
    addLabel("💡 杀戮光环自动攻击最近僵尸")
    addLabel("💡 无限子弹自动识别弹药属性并锁定")
    panel.CanvasSize = UDim2.new(0,0,0,#panel:GetChildren()*32+20)
end

-- ============================================================
--  面板：森林·99夜（优化版）
-- ============================================================
local function loadForest()
    clearPanel()
    addTitle("🌲 森林 · 99夜")

    -- ---- 伐木光环 ----
    addTitle("🪓 伐木光环 (优化)")
    local chopActive = false
    local chopRange = 30
    local chopConn = nil
    local chopInterval = 0.3  -- 检查间隔（秒）

    local function getTrees()
        -- 优先使用专门的容器
        local treeContainer = workspace:FindFirstChild("Trees") or workspace:FindFirstChild("Tree")
        if treeContainer then
            local results = {}
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return {} end
            for _, obj in pairs(treeContainer:GetChildren()) do
                if obj:IsA("BasePart") and (hrp.Position - obj.Position).Magnitude <= chopRange then
                    table.insert(results, obj)
                end
            end
            return results
        end

        -- 回退方案：全搜索但限制距离
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
        else
            local clickDetector = tree:FindFirstChildOfClass("ClickDetector")
            if clickDetector then
                clickDetector:FireClick()
            end
        end
    end

    addToggle("🌲 伐木光环 (砍树)", false, function(s)
        chopActive = s
        if chopConn then chopConn:Disconnect(); chopConn = nil end
        if s then
            print("🪓 伐木光环已开启，范围: " .. chopRange .. " 格，检查间隔 " .. chopInterval .. "秒")
            chopConn = runService.Heartbeat:Connect(function()
                if not chopActive then return end
                -- 限频
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
    addButton("伐木范围 +5", Color3.fromRGB(60,180,60), function()
        chopRange = math.min(chopRange + 5, 100)
        chopRangeLabel.Text = "当前伐木范围: " .. chopRange .. " 格"
    end)
    addButton("伐木范围 -5", Color3.fromRGB(180,60,60), function()
        chopRange = math.max(chopRange - 5, 10)
        chopRangeLabel.Text = "当前伐木范围: " .. chopRange .. " 格"
    end)

    addDivider()

    -- ---- 生物杀戮光环 ----
    addTitle("⚔️ 生物杀戮光环 (优化)")
    local killActive = false
    local killRange = 30
    local killCooldown = 0.3
    local killConn = nil
    local lastAttackTime = 0
    local killInterval = 0.2

    local function getMonsters()
        -- 优先查找怪物容器
        local monsterContainer = workspace:FindFirstChild("Monsters") or workspace:FindFirstChild("Enemies") or workspace:FindFirstChild("Zombies")
        if monsterContainer then
            local results = {}
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return {} end
            for _, obj in pairs(monsterContainer:GetChildren()) do
                if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
                    local root = obj:FindFirstChild("HumanoidRootPart")
                    if root and (hrp.Position - root.Position).Magnitude <= killRange then
                        table.insert(results, root)
                    end
                end
            end
            return results
        end

        -- 回退全搜索
        local char = player.Character
        if not char then return {} end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return {} end
        local found = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local n = obj.Name:lower()
                local matched = false
                local keywords = {"monster","zombie","enemy","creature","ghost","demon","skeleton","怪物","僵尸","敌人","生物"}
                for _, kw in ipairs(keywords) do
                    if n:find(kw) then matched = true break end
                end
                if not matched and obj.Parent and obj.Parent:IsA("Model") then
                    local mname = obj.Parent.Name:lower()
                    for _, kw in ipairs(keywords) do
                        if mname:find(kw) then matched = true break end
                    end
                    if not matched and obj.Parent:FindFirstChildOfClass("Humanoid") then
                        local model = obj.Parent
                        if model ~= player.Character then matched = true end
                    end
                end
                if matched then
                    if not obj:FindFirstAncestorOfClass("Model") or
                       not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                        local dist = (hrp.Position - obj.Position).Magnitude
                        if dist <= killRange then
                            table.insert(found, obj)
                        end
                    end
                end
            end
        end
        return found
    end

    local function attackMonster(monster)
        local char = player.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then pcall(function() tool:Activate() end) end
        if monster:IsA("BasePart") then
            for _, child in pairs(monster:GetDescendants()) do
                if child:IsA("ClickDetector") then child:FireClick() break end
            end
        end
        local model = monster
        if monster.Parent and monster.Parent:IsA("Model") then model = monster.Parent end
        local hum = model:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Attack")
            if remote then pcall(function() remote:FireServer(model) end) end
        end
    end

    addToggle("⚔️ 生物杀戮光环", false, function(s)
        killActive = s
        if killConn then killConn:Disconnect(); killConn = nil end
        if s then
            print("⚔️ 生物杀戮光环已开启，范围: " .. killRange .. " 格，攻击间隔 " .. killCooldown .. "s")
            killConn = runService.Heartbeat:Connect(function()
                if not killActive then return end
                if tick() - lastAttackTime < killCooldown then return end
                -- 限频检查
                if not killConn._lastCheck then killConn._lastCheck = 0 end
                if tick() - killConn._lastCheck < killInterval then return end
                killConn._lastCheck = tick()

                local monsters = getMonsters()
                for _, mon in ipairs(monsters) do
                    attackMonster(mon)
                end
                lastAttackTime = tick()
            end)
        else
            print("⚔️ 生物杀戮光环已关闭")
        end
    end)

    local killRangeLabel = addLabel("当前杀戮范围: " .. killRange .. " 格")
    addButton("杀戮范围 +5", Color3.fromRGB(255,150,50), function()
        killRange = math.min(killRange + 5, 100)
        killRangeLabel.Text = "当前杀戮范围: " .. killRange .. " 格"
    end)
    addButton("杀戮范围 -5", Color3.fromRGB(255,80,80), function()
        killRange = math.max(killRange - 5, 10)
        killRangeLabel.Text = "当前杀戮范围: " .. killRange .. " 格"
    end)

    local speedLabel = addLabel("当前攻击间隔: " .. (math.floor(killCooldown * 1000)) .. "ms")
    addButton("⚡ 攻速 + (间隔-50ms)", Color3.fromRGB(60,180,60), function()
        killCooldown = math.max(killCooldown - 0.05, 0.05)
        speedLabel.Text = "当前攻击间隔: " .. (math.floor(killCooldown * 1000)) .. "ms"
    end)
    addButton("⚡ 攻速 - (间隔+50ms)", Color3.fromRGB(180,60,60), function()
        killCooldown = math.min(killCooldown + 0.05, 1.0)
        speedLabel.Text = "当前攻击间隔: " .. (math.floor(killCooldown * 1000)) .. "ms"
    end)

    addDivider()

    -- ---- 物品透视与传送（优化ESP更新频率） ----
    local espEnabled = false
    local espConn = nil
    local espInterval = 0.5  -- 每0.5秒更新一次高亮

    -- 这里保留原有 keyword 列表（略，与之前相同）
    local WEAPON_KEYWORDS = {"chainsaw","cultist king mace","good axe","ice axe","ice sword","infernal sword","katana","laser sword","morningstar","obsidiron hammer","old axe","poison spear","scythe","spear","strong axe","trident","admin axe","blowpipe","bouncing blade","crossbow","flamethrower","frozen shuriken","infernal crossbow","kunai","laser cannon","ray gun","revolver","rifle","snowball","tactical shotgun","wildfire","witch potion","admin gun","friendly gun","电锯","冰剑","武士刀","激光剑","晨星","锤","斧","枪","步枪","左轮","霰弹枪","喷火器","弩","矛","三叉戟"}
    local CURRENCY_KEYWORDS = {"coin","coins","gold","gold bar","diamond","gems","金币","沃伦金币","神秘纽扣","钻石","宝石","coin stack","currency"}
    local TOOL_KEYWORDS = {"sack","axe","flute","fishing rod","flashlight","pickaxe","old sack","good sack","infernal sack","giant sack","admin sack","old axe","good axe","ice axe","strong axe","admin axe","old rod","good rod","麻袋","背包","手电筒","鱼竿","镐","斧头"}
    local MATERIAL_KEYWORDS = {"wood","log","plank","stone","iron","ore","scrap","metal","fuel","gas","seed","food","pelt","leather","fiber","rope","木头","原木","木板","石头","铁","矿石","废料","金属","燃料","种子","食物","皮毛","皮革","绳子"}
    local CHILD_KEYWORDS = {"dino kid","kraken kid","squid kid","koala kid","恐龙小子","海怪小子","鱿鱼小子","考拉小子","child","kid","孩子","小孩"}
    local ALL_ITEM_KEYWORDS = {}
    for _, v in ipairs(WEAPON_KEYWORDS) do table.insert(ALL_ITEM_KEYWORDS, v) end
    for _, v in ipairs(CURRENCY_KEYWORDS) do table.insert(ALL_ITEM_KEYWORDS, v) end
    for _, v in ipairs(TOOL_KEYWORDS) do table.insert(ALL_ITEM_KEYWORDS, v) end
    for _, v in ipairs(MATERIAL_KEYWORDS) do table.insert(ALL_ITEM_KEYWORDS, v) end

    local function isItemMatch(obj, keywords)
        if not obj or not obj:IsA("BasePart") then return false end
        local name = obj.Name:lower()
        if obj:FindFirstAncestorOfClass("Model") and obj:FindFirstAncestorOfClass("Model") == player.Character then
            return false
        end
        for _, kw in ipairs(keywords) do
            if name:find(kw:lower()) then return true end
        end
        return false
    end

    local function getItemsByKeywords(keywords)
        local results = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and isItemMatch(obj, keywords) then
                table.insert(results, obj)
            end
        end
        return results
    end

    local function teleportItemsToPlayer(items)
        local char = player.Character
        if not char then print("⚠️ 角色不存在"); return 0 end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then print("⚠️ HumanoidRootPart 不存在"); return 0 end
        local count = 0
        local targetPos = hrp.Position + hrp.CFrame.LookVector * 3 + Vector3.new(0, 1, 0)
        for i, obj in ipairs(items) do
            local offset = Vector3.new(math.random(-2,2), math.random(0,1), math.random(-2,2))
            obj.Position = targetPos + offset
            obj.AssemblyLinearVelocity = Vector3.new(0,0,0)
            obj.AssemblyAngularVelocity = Vector3.new(0,0,0)
            count = count + 1
            if i % 5 == 0 then task.wait(0.01) end
        end
        return count
    end

    -- ESP 创建函数（略，与原相同）
    local function createESP(obj, color, label)
        if not obj or not obj:IsA("BasePart") then return end
        for _, child in pairs(obj:GetChildren()) do
            if child.Name == "ItemESP" or child.Name == "ItemLabel" then child:Destroy() end
        end
        local hl = Instance.new("Highlight")
        hl.Name = "ItemESP"
        hl.FillColor = color
        hl.FillTransparency = 0.6
        hl.OutlineColor = color
        hl.OutlineTransparency = 0.1
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = obj
        local bg = Instance.new("BillboardGui")
        bg.Name = "ItemLabel"
        bg.Size = UDim2.new(0, 150, 0, 25)
        bg.AlwaysOnTop = true
        bg.StudsOffset = Vector3.new(0, 3, 0)
        bg.Parent = obj
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = label or obj.Name
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.TextScaled = true
        lbl.Font = Enum.Font.GothamBold
        lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        lbl.TextStrokeTransparency = 0.3
        lbl.Parent = bg
    end

    local function clearESP()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Highlight") and obj.Name == "ItemESP" then obj:Destroy() end
            if obj:IsA("BillboardGui") and obj.Name == "ItemLabel" then obj:Destroy() end
        end
    end

    local function updateESP()
        clearESP()
        if not espEnabled then return end
        local weapons = getItemsByKeywords(WEAPON_KEYWORDS)
        for _, obj in ipairs(weapons) do createESP(obj, Color3.fromRGB(255,50,50), "🔫 "..obj.Name) end
        local coins = getItemsByKeywords(CURRENCY_KEYWORDS)
        for _, obj in ipairs(coins) do createESP(obj, Color3.fromRGB(255,215,0), "💰 "..obj.Name) end
        local tools = getItemsByKeywords(TOOL_KEYWORDS)
        for _, obj in ipairs(tools) do createESP(obj, Color3.fromRGB(50,150,255), "🔧 "..obj.Name) end
        local materials = getItemsByKeywords(MATERIAL_KEYWORDS)
        for _, obj in ipairs(materials) do createESP(obj, Color3.fromRGB(50,255,100), "📦 "..obj.Name) end
        local children = getItemsByKeywords(CHILD_KEYWORDS)
        for _, obj in ipairs(children) do createESP(obj, Color3.fromRGB(255,100,200), "👶 "..obj.Name) end
    end

    addToggle("🟢 物品透视 (高亮所有物品)", false, function(s)
        espEnabled = s
        if espConn then espConn:Disconnect(); espConn = nil end
        if s then
            updateESP()
            espConn = runService.Heartbeat:Connect(function()
                if not espEnabled then return end
                if not espConn._lastESP or tick() - espConn._lastESP >= espInterval then
                    espConn._lastESP = tick()
                    updateESP()
                end
            end)
            print("🟢 物品透视已开启 (更新间隔 " .. espInterval .. "s)")
        else
            clearESP()
            print("🔴 物品透视已关闭")
        end
    end)

    addDivider()
    addTitle("📦 传送功能")
    addButton("🔫 传送所有武器到身边", Color3.fromRGB(255,80,80), function()
        local items = getItemsByKeywords(WEAPON_KEYWORDS)
        local count = teleportItemsToPlayer(items)
        print("✅ 已传送 " .. count .. " 件武器到身边")
    end)
    addButton("💰 传送所有金币到身边", Color3.fromRGB(255,215,0), function()
        local items = getItemsByKeywords(CURRENCY_KEYWORDS)
        local count = teleportItemsToPlayer(items)
        print("✅ 已传送 " .. count .. " 个金币/货币到身边")
    end)
    addButton("🔧 传送所有工具到身边", Color3.fromRGB(50,150,255), function()
        local items = getItemsByKeywords(TOOL_KEYWORDS)
        local count = teleportItemsToPlayer(items)
        print("✅ 已传送 " .. count .. " 件工具到身边")
    end)
    addButton("📦 传送所有物品到身边", Color3.fromRGB(100,200,255), function()
        local items = getItemsByKeywords(ALL_ITEM_KEYWORDS)
        local count = teleportItemsToPlayer(items)
        print("✅ 已传送 " .. count .. " 个物品到身边")
    end)
    addButton("👶 传送所有孩子到身边", Color3.fromRGB(255,100,200), function()
        local items = getItemsByKeywords(CHILD_KEYWORDS)
        local count = teleportItemsToPlayer(items)
        print("✅ 已传送 " .. count .. " 个孩子到身边")
    end)

    addDivider()
    addTitle("🌱 自动种植 (优化)")
    local plantActive = false
    local plantRadius = 8
    local plantCount = 16
    local plantDelay = 0.5
    local plantConn = nil
    local isPlanting = false
    local plantInterval = 60  -- 每60秒自动种植一次

    local function getSaplings()
        local backpack = player:FindFirstChild("Backpack")
        if not backpack then return {} end
        local saplings = {}
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") and item.Name:lower():find("sapling") then
                table.insert(saplings, item)
            end
        end
        return saplings
    end

    local function getCampfirePosition()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("campfire") then
                return obj.Position
            end
        end
        local char = player.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then return hrp.Position end
        end
        return nil
    end

    local function performCirclePlanting()
        if isPlanting then return end
        isPlanting = true

        local saplings = getSaplings()
        if #saplings == 0 then
            print("⚠️ 背包中没有树苗 (Sapling)")
            isPlanting = false
            return
        end

        local center = getCampfirePosition()
        if not center then
            print("⚠️ 未找到篝火位置")
            isPlanting = false
            return
        end

        local char = player.Character
        if not char then isPlanting = false; return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then isPlanting = false; return end

        local planted = 0
        for i = 1, math.min(plantCount, #saplings) do
            local angle = (i / plantCount) * 2 * math.pi
            local x = center.X + plantRadius * math.cos(angle)
            local z = center.Z + plantRadius * math.sin(angle)
            local targetPos = Vector3.new(x, center.Y + 1, z)

            hrp.CFrame = CFrame.new(targetPos)
            task.wait(0.1)

            local sapling = saplings[i]
            if sapling and sapling.Parent == player.Backpack then
                sapling.Parent = char
                task.wait(0.1)
                pcall(function() sapling:Activate() end)
                task.wait(plantDelay)
                planted = planted + 1
            end
        end

        print("🌱 已种植 " .. planted .. " 棵树苗（圆形，半径 " .. plantRadius .. "）")
        isPlanting = false
    end

    addToggle("🌱 自动种植 (圆形)", false, function(s)
        plantActive = s
        if plantConn then plantConn:Disconnect(); plantConn = nil end
        if s then
            print("🌱 自动种植已开启（每 " .. plantInterval .. " 秒执行一次）")
            task.spawn(performCirclePlanting)
            plantConn = runService.Heartbeat:Connect(function()
                if not plantActive then return end
                if not plantConn._lastPlant then plantConn._lastPlant = 0 end
                if tick() - plantConn._lastPlant >= plantInterval then
                    plantConn._lastPlant = tick()
                    task.spawn(performCirclePlanting)
                end
            end)
        else
            print("🌱 自动种植已关闭")
        end
    end)

    local radiusLabel = addLabel("种植半径: " .. plantRadius .. " 格")
    addButton("半径 +2", Color3.fromRGB(60,180,60), function()
        plantRadius = math.min(plantRadius + 2, 20)
        radiusLabel.Text = "种植半径: " .. plantRadius .. " 格"
    end)
    addButton("半径 -2", Color3.fromRGB(180,60,60), function()
        plantRadius = math.max(plantRadius - 2, 3)
        radiusLabel.Text = "种植半径: " .. plantRadius .. " 格"
    end)

    local countLabel = addLabel("树苗数量: " .. plantCount .. " 棵")
    addButton("数量 +4", Color3.fromRGB(60,180,60), function()
        plantCount = math.min(plantCount + 4, 40)
        countLabel.Text = "树苗数量: " .. plantCount .. " 棵"
    end)
    addButton("数量 -4", Color3.fromRGB(180,60,60), function()
        plantCount = math.max(plantCount - 4, 4)
        countLabel.Text = "树苗数量: " .. plantCount .. " 棵"
    end)

    addButton("🌱 立即种植一次", Color3.fromRGB(50,200,100), function()
        task.spawn(performCirclePlanting)
    end)

    addDivider()
    addLabel("💡 优化说明：光环检查间隔已降低，减少CPU占用")
    addLabel("💡 伐木/杀戮/ESP 现在每 0.2~0.5 秒检测一次，不再每帧执行")

    panel.CanvasSize = UDim2.new(0, 0, 0, #panel:GetChildren() * 32 + 20)
end

-- ============================================================
--  面板：简介（完整版）
-- ============================================================
local function loadIntro()
    clearPanel()
    addTitle("📋 关于本脚本")

    local card = Instance.new("Frame")
    card.Parent = panel
    card.Size = UDim2.new(1,-4,0,200)
    card.Position = UDim2.new(0,2,0,#panel:GetChildren()*32+8)
    card.BackgroundColor3 = Color3.fromRGB(20, 22, 40)
    card.BackgroundTransparency = 0.5
    card.BorderSizePixel = 1
    card.BorderColor3 = Color3.fromRGB(30, 200, 255)
    local cardCorner = Instance.new("UICorner")
    cardCorner.Parent = card
    cardCorner.CornerRadius = UDim.new(0,6)

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
    titleLbl.Text = "唐脚本 v5.0"
    titleLbl.TextColor3 = Color3.fromRGB(30, 200, 255)
    titleLbl.TextSize = 22
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Center
    titleLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    titleLbl.TextStrokeTransparency = 0.3

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
            b.BackgroundColor3 = Color3.fromRGB(20,40,60)
            b.BorderColor3 = Color3.fromRGB(50,50,70)
        end
        btn.BackgroundColor3 = Color3.fromRGB(30,200,255)
        btn.BorderColor3 = Color3.fromRGB(30,200,255)
        if panelFunctions[i] then
            panelFunctions[i]()
        end
    end)
end

-- ============================================================
--  等待启动动画完成后再显示主界面（带弹出特效）
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
    
    -- 设置初始状态：透明且缩小
    mainFrame.BackgroundTransparency = 1
    mainFrame.Size = UDim2.new(0, 400, 0, 250)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
    gui.Enabled = true
    mainFrame.Visible = true
    
    -- 创建 Tween 动画（淡入 + 放大）
    local tweenInfo = TweenInfo.new(
        0.8,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out,
        0,
        false,
        0
    )
    
    local properties = {
        BackgroundTransparency = 0.15,
        Size = UDim2.new(0, 600, 0, 350),
        Position = UDim2.new(0.5, -300, 0.5, -175)
    }
    
    local tween = tweenService:Create(mainFrame, tweenInfo, properties)
    tween:Play()
    
    tween.Completed:Connect(function()
        splashGui:Destroy()
        print("✅ 唐脚本 v5.0 已加载完成")
    end)
    
    task.wait(2)
    if splashGui and splashGui.Parent then
        splashGui:Destroy()
    end
end)
