-- 唐脚本 v5.0（完整版：通用 | MM2 | Peta | 飞行 | 甩飞 | 僵尸塔 | 简介）
-- 控制图标：黑色背景 + 彩虹描边 + “唐”字 + 可自由拖动（无边界限制）
-- 主窗口完全透明，内部控件半透明暗色框，文字黑色
-- 启动动画保留

repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")

-- ============================================================
--  启动动画（彩虹文字 + 小方块旋转环 + 百分比进度）
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

-- 小方块旋转环
local ringContainer = Instance.new("Frame")
ringContainer.Size = UDim2.new(0, 300, 0, 300)
ringContainer.Position = UDim2.new(0.5, -150, 0.5, -150)
ringContainer.BackgroundTransparency = 1
ringContainer.ZIndex = 0
ringContainer.Parent = container

local blockCount = 20
local radius = 120
local blocks = {}
local blockColors = {
    Color3.fromRGB(255, 255, 255),
    Color3.fromRGB(200, 230, 255),
    Color3.fromRGB(180, 210, 255),
}

for i = 1, blockCount do
    local angle = (i - 1) / blockCount * 2 * math.pi
    local x = radius * math.cos(angle)
    local y = radius * math.sin(angle)

    local block = Instance.new("Frame")
    block.Size = UDim2.new(0, 12, 0, 12)
    block.Position = UDim2.new(0.5, x - 6, 0.5, y - 6)
    block.BackgroundColor3 = blockColors[(i % 3) + 1]
    block.BackgroundTransparency = 0.2
    block.BorderSizePixel = 0
    block.ZIndex = 0
    block.Parent = ringContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 3)
    corner.Parent = block

    block:SetAttribute("Angle", angle)
    table.insert(blocks, block)
end

-- 外圈光晕环
local outerBlocks = {}
for i = 1, 16 do
    local angle = (i - 1) / 16 * 2 * math.pi + 0.3
    local x = (radius + 25) * math.cos(angle)
    local y = (radius + 25) * math.sin(angle)

    local block = Instance.new("Frame")
    block.Size = UDim2.new(0, 6, 0, 6)
    block.Position = UDim2.new(0.5, x - 3, 0.5, y - 3)
    block.BackgroundColor3 = Color3.fromRGB(150, 200, 255)
    block.BackgroundTransparency = 0.7
    block.BorderSizePixel = 0
    block.ZIndex = 0
    block.Parent = ringContainer
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 2)
    corner.Parent = block
    table.insert(outerBlocks, block)
end

-- 内圈光晕
local innerBlocks = {}
for i = 1, 12 do
    local angle = (i - 1) / 12 * 2 * math.pi + 0.6
    local x = (radius - 30) * math.cos(angle)
    local y = (radius - 30) * math.sin(angle)

    local block = Instance.new("Frame")
    block.Size = UDim2.new(0, 4, 0, 4)
    block.Position = UDim2.new(0.5, x - 2, 0.5, y - 2)
    block.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    block.BackgroundTransparency = 0.8
    block.BorderSizePixel = 0
    block.ZIndex = 0
    block.Parent = ringContainer
    table.insert(innerBlocks, block)
end

-- 百分比进度显示
local percentLabel = Instance.new("TextLabel")
percentLabel.Size = UDim2.new(0, 120, 0, 50)
percentLabel.Position = UDim2.new(0.5, -60, 0.5, 30)
percentLabel.BackgroundTransparency = 1
percentLabel.Text = "0%"
percentLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
percentLabel.TextSize = 36
percentLabel.Font = Enum.Font.GothamBold
percentLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
percentLabel.TextStrokeTransparency = 0.3
percentLabel.Parent = container

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 200, 0, 4)
progressBar.Position = UDim2.new(0.5, -100, 0.5, 75)
progressBar.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
progressBar.BorderSizePixel = 0
progressBar.Parent = container
local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(1, 0)
barCorner.Parent = progressBar

local fill = Instance.new("Frame")
fill.Size = UDim2.new(0, 0, 1, 0)
fill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
fill.BorderSizePixel = 0
fill.Parent = progressBar
local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = fill

-- 四个字母 (T A N G)
local letters = {"T", "A", "N", "G"}
local labels = {}
local hueOffsets = {0, 0.15, 0.30, 0.45}

for i, char in ipairs(letters) do
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 80, 0, 100)
    lbl.Position = UDim2.new(0, (i-1)*100 + 30, 0, 55)
    lbl.BackgroundTransparency = 1
    lbl.Text = char
    lbl.TextColor3 = Color3.fromHSV((i-1)/4, 1, 1)
    lbl.TextSize = 80
    lbl.Font = Enum.Font.GothamBold
    lbl.TextScaled = true
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lbl.TextStrokeTransparency = 0
    lbl.TextTransparency = 0
    lbl.Parent = container
    table.insert(labels, lbl)
end

-- 启动动画控制变量
local running = true

-- 颜色循环
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

-- 主环旋转
task.spawn(function()
    while running do
        ringContainer.Rotation = (ringContainer.Rotation + 1.8) % 360
        task.wait(0.02)
    end
end)

-- 方块呼吸
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

-- 百分比进度更新
task.spawn(function()
    local duration = 3.5
    local startTime = tick()
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
--  控制图标（黑色背景 + 彩虹描边 + “唐”字 + 自由拖动）
--  始终显示“唐”，点击仅切换主窗口，图标不改变外观
-- ============================================================
local controlGui = Instance.new("ScreenGui")
controlGui.Name = "ControlIconGui"
controlGui.Parent = player:WaitForChild("PlayerGui")
controlGui.ResetOnSpawn = false

local controlIcon = Instance.new("TextButton")
controlIcon.Name = "ControlIcon"
controlIcon.Size = UDim2.new(0, 50, 0, 50)
controlIcon.Position = UDim2.new(1, -65, 0, 15)   -- 初始右上角
controlIcon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- 纯黑
controlIcon.BackgroundTransparency = 0              -- 完全不透明
controlIcon.Text = "唐"
controlIcon.TextColor3 = Color3.fromRGB(255, 255, 255)  -- 白色文字
controlIcon.TextSize = 28
controlIcon.Font = Enum.Font.GothamBold
controlIcon.BorderSizePixel = 0
controlIcon.AutoButtonColor = false
controlIcon.Parent = controlGui
controlIcon.ZIndex = 10

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(1, 0)            -- 圆形
iconCorner.Parent = controlIcon

-- 彩虹描边（动态变色）
local iconStroke = Instance.new("UIStroke")
iconStroke.Thickness = 2
iconStroke.Parent = controlIcon
task.spawn(function()
    local hue = 0
    while iconStroke and iconStroke.Parent do
        hue = (hue + 0.008) % 1
        iconStroke.Color = Color3.fromHSV(hue, 1, 1)
        task.wait(0.05)
    end
end)

-- 图标拖动（无边界限制）
local isDraggingIcon = false
local dragIconStartX, dragIconStartY
local iconStartPosX, iconStartPosY

controlIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingIcon = true
        dragIconStartX = input.Position.X
        dragIconStartY = input.Position.Y
        iconStartPosX = controlIcon.Position.X.Offset
        iconStartPosY = controlIcon.Position.Y.Offset
    end
end)

controlIcon.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingIcon = false
    end
end)

userInput.InputChanged:Connect(function(input)
    if isDraggingIcon and input.UserInputType == Enum.UserInputType.MouseMovement then
        local deltaX = input.Position.X - dragIconStartX
        local deltaY = input.Position.Y - dragIconStartY
        local newX = iconStartPosX + deltaX
        local newY = iconStartPosY + deltaY
        -- 无边界限制，可拖到任意位置
        controlIcon.Position = UDim2.new(0, newX, 0, newY)
    end
end)

-- 双击图标重置位置到右下角（如果图标丢失，可双击恢复）
local lastClickTime = 0
controlIcon.MouseButton1Click:Connect(function()
    local now = tick()
    if now - lastClickTime < 0.3 then  -- 双击检测
        -- 重置到屏幕右下角（距边缘 65 像素）
        controlIcon.Position = UDim2.new(1, -65, 0, 15)
        print("🔄 控制图标已重置位置")
        lastClickTime = 0
        return
    end
    lastClickTime = now
    -- 单击切换主窗口
    mainFrame.Visible = not mainFrame.Visible
    -- 仅改变图标背景色表示状态（但文字和描边不变）
    if mainFrame.Visible then
        controlIcon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)      -- 黑色
    else
        controlIcon.BackgroundColor3 = Color3.fromRGB(180, 40, 40)  -- 暗红色（表示主窗口隐藏）
    end
end)

-- 主窗口关闭时同步图标状态（由 closeBtn 触发）
local function UpdateControlIcon(visible)
    if visible then
        controlIcon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    else
        controlIcon.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    end
end
-- ============================================================
--  主窗口（横长方形 600x350）- 背景完全透明
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "TangScript"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = gui
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 30, 50)
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -175)
mainFrame.Size = UDim2.new(0, 600, 0, 350)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false

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

-- 标题栏（完全透明）
local titleBar = Instance.new("Frame")
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1,0,0,28)
titleBar.BackgroundColor3 = Color3.fromRGB(18, 22, 42)
titleBar.BackgroundTransparency = 1
titleBar.BorderSizePixel = 0

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = titleBar
titleLabel.Size = UDim2.new(0.5,0,1,0)
titleLabel.Position = UDim2.new(0,10,0,0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "唐脚本 v5.0"
titleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextStrokeTransparency = 0.5

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = titleBar
closeBtn.Size = UDim2.new(0,22,0,22)
closeBtn.Position = UDim2.new(1,-28,0,3)
closeBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
local closeCorner = Instance.new("UICorner")
closeCorner.Parent = closeBtn
closeCorner.CornerRadius = UDim.new(1,0)

-- 控制图标联动（点击开关主窗口）
local function UpdateControlIcon(visible)
    if visible then
        controlIcon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        controlIcon.Text = "唐"
        controlIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        controlIcon.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        controlIcon.Text = "◉"
        controlIcon.TextColor3 = Color3.fromRGB(255, 200, 200)
    end
end

controlIcon.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    UpdateControlIcon(mainFrame.Visible)
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    UpdateControlIcon(false)
end)

-- 侧栏（完全透明）
local sideBar = Instance.new("Frame")
sideBar.Parent = mainFrame
sideBar.Size = UDim2.new(0,70,1,-28)
sideBar.Position = UDim2.new(0,0,0,28)
sideBar.BackgroundColor3 = Color3.fromRGB(15, 20, 38)
sideBar.BackgroundTransparency = 1
sideBar.BorderSizePixel = 0

local btnNames = {"通用","MM2","Peta","飞行","甩飞","僵尸塔","简介"}
local btnList = {}
local contentFrame = Instance.new("Frame")
contentFrame.Parent = mainFrame
contentFrame.Size = UDim2.new(1,-70,1,-28)
contentFrame.Position = UDim2.new(0,70,0,28)
contentFrame.BackgroundTransparency = 1

local panel = Instance.new("ScrollingFrame")
panel.Parent = contentFrame
panel.Size = UDim2.new(1,-8,1,-4)
panel.Position = UDim2.new(0,4,0,2)
panel.BackgroundTransparency = 1
panel.CanvasSize = UDim2.new(0,0,0,0)
panel.ScrollBarThickness = 2

for i,name in ipairs(btnNames) do
    local btn = Instance.new("TextButton")
    btn.Parent = sideBar
    btn.Size = UDim2.new(0.8,0,0,26)
    btn.Position = UDim2.new(0.1,0,0.03+(i-1)*0.12,0)
    btn.BackgroundColor3 = (i==1) and Color3.fromRGB(30,200,255) or Color3.fromRGB(20,40,60)
    btn.BackgroundTransparency = 0.6
    btn.BorderSizePixel = 1
    btn.BorderColor3 = (i==1) and Color3.fromRGB(30,200,255) or Color3.fromRGB(50,50,70)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamSemibold
    local c = Instance.new("UICorner")
    c.Parent = btn
    c.CornerRadius = UDim.new(0,2)
    btnList[i] = btn
end

-- ============================================================
--  辅助函数（通用）- 每个功能用暗色长条框独立框住，文字黑色
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
    lbl.TextColor3 = Color3.fromRGB(0, 0, 0)
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
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
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
    lbl.TextColor3 = Color3.fromRGB(0, 0, 0)
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
    lbl.TextColor3 = Color3.fromRGB(0, 0, 0)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextStrokeTransparency = 0.3
end

-- ============================================================
--  面板：简介
-- ============================================================
local function loadIntro()
    clearPanel()
    addTitle("📋 关于本脚本")

    local card = Instance.new("Frame")
    card.Parent = panel
    card.Size = UDim2.new(1,-4,0,180)
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
    icon.Size = UDim2.new(0, 50, 0, 50)
    icon.Position = UDim2.new(0.5, -25, 0, 10)
    icon.BackgroundTransparency = 1
    icon.Text = "📜"
    icon.TextSize = 36
    icon.TextColor3 = Color3.fromRGB(0, 0, 0)
    icon.Font = Enum.Font.GothamBold
    icon.TextXAlignment = Enum.TextXAlignment.Center

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Parent = card
    titleLbl.Size = UDim2.new(1, 0, 0, 30)
    titleLbl.Position = UDim2.new(0, 0, 0, 55)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "唐脚本 v5.0"
    titleLbl.TextColor3 = Color3.fromRGB(0, 0, 0)
    titleLbl.TextSize = 20
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Center
    titleLbl.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    titleLbl.TextStrokeTransparency = 0.4

    local line = Instance.new("Frame")
    line.Parent = card
    line.Size = UDim2.new(0.6, 0, 0, 1)
    line.Position = UDim2.new(0.2, 0, 0, 88)
    line.BackgroundColor3 = Color3.fromRGB(30, 200, 255)
    line.BackgroundTransparency = 0.5
    line.BorderSizePixel = 0

    local authorLbl = Instance.new("TextLabel")
    authorLbl.Parent = card
    authorLbl.Size = UDim2.new(1, 0, 0, 24)
    authorLbl.Position = UDim2.new(0, 0, 0, 95)
    authorLbl.BackgroundTransparency = 1
    authorLbl.Text = "👤 作者：kkcmjf"
    authorLbl.TextColor3 = Color3.fromRGB(0, 0, 0)
    authorLbl.TextSize = 14
    authorLbl.Font = Enum.Font.Gotham
    authorLbl.TextXAlignment = Enum.TextXAlignment.Center

    local feelingLbl = Instance.new("TextLabel")
    feelingLbl.Parent = card
    feelingLbl.Size = UDim2.new(1, 0, 0, 24)
    feelingLbl.Position = UDim2.new(0, 0, 0, 120)
    feelingLbl.BackgroundTransparency = 1
    feelingLbl.Text = "💭 感想：没有一个源代码我只能用ai了 😭"
    feelingLbl.TextColor3 = Color3.fromRGB(0, 0, 0)
    feelingLbl.TextSize = 13
    feelingLbl.Font = Enum.Font.Gotham
    feelingLbl.TextXAlignment = Enum.TextXAlignment.Center

    local versionLbl = Instance.new("TextLabel")
    versionLbl.Parent = card
    versionLbl.Size = UDim2.new(1, 0, 0, 20)
    versionLbl.Position = UDim2.new(0, 0, 0, 148)
    versionLbl.BackgroundTransparency = 1
    versionLbl.Text = "⚡ 仅限学习交流使用 · 请勿用于商业用途"
    versionLbl.TextColor3 = Color3.fromRGB(0, 0, 0)
    versionLbl.TextSize = 11
    versionLbl.Font = Enum.Font.Gotham
    versionLbl.TextXAlignment = Enum.TextXAlignment.Center

    addDivider()
    addTitle("📦 功能列表")

    local functionsText = {
        "• 通用：取消坠落伤害",
        "• MM2：武器复制、身份标签、Kill Aura、传送",
        "• Peta：钥匙/器官/传送门/灵魂火焰透视描边",
        "• 飞行：无敌少侠飞行模式（WASD/空格/Shift）",
        "• 甩飞：静默甩飞、传送甩飞、循环甩飞",
        "• 僵尸塔：杀戮光环、无限子弹"
    }

    for _, text in ipairs(functionsText) do
        addLabel(text, Color3.fromRGB(0, 0, 0))
    end

    panel.CanvasSize = UDim2.new(0,0,0,#panel:GetChildren()*32+20)
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
--  面板：MM2（完整功能）
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
                b.TextColor3 = Color3.fromRGB(0, 0, 0)
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

    -- 显示身份标签
    local showIdentity = false
    local identityConn = nil

    local function getPlayerIdentity(targetPlayer)
        local char = targetPlayer.Character
        if not char then return "平民" end

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
                        label.TextColor3 = identity:find("杀手") and Color3.fromRGB(255, 50, 50)
                                        or identity:find("警长") and Color3.fromRGB(50, 150, 255)
                                        or Color3.fromRGB(200, 200, 200)
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

    addButton("刷新身份标签", Color3.fromRGB(30,120,180), function()
        if showIdentity then
            clearIdentityLabels()
            updateIdentityLabels()
            print("身份标签已刷新")
        else
            print("请先开启身份标签开关")
        end
    end)

    -- Kill Aura（玩家）
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
--  面板：Peta（器官透视 + 传送门标记 + 钥匙描边 + 灵魂火焰）
-- ============================================================
local function loadPeta()
    clearPanel()
    addTitle("🧬 Peta 透视辅助")

    -- ========== 工具函数：创建高亮描边 ==========
    local function applyHighlight(instance, color, name)
        if not instance or not instance:IsA("BasePart") then return end
        for _, child in pairs(instance:GetChildren()) do
            if child:IsA("Highlight") then
                child:Destroy()
            end
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

    -- ========== 功能状态 ==========
    local keyActive = false
    local organActive = false
    local portalActive = false
    local soulActive = false

    local keyThread = nil
    local organThread = nil
    local portalThread = nil
    local soulThread = nil

    local correctPortal = nil
    local correctPortalHL = nil

    -- ========== 1. 钥匙透视描边 ==========
    addToggle("🔑 钥匙透视描边", false, function(s)
        keyActive = s
        if keyThread then task.cancel(keyThread); keyThread = nil end
        if not s then
            removeHighlights()
            return
        end
        keyThread = task.spawn(function()
            while keyActive do
                task.wait(0.5)
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
                task.wait(1)
            end
        end)
    end)

    -- ========== 2. 器官透视描边 ==========
    addToggle("❤️ 器官透视描边", false, function(s)
        organActive = s
        if organThread then task.cancel(organThread); organThread = nil end
        if not s then
            removeHighlights()
            return
        end
        organThread = task.spawn(function()
            local organNames = {"heart", "kidney", "liver", "lung", "brain", "organ", "心脏", "肾脏", "肝脏", "肺", "脑", "器官"}
            while organActive do
                task.wait(0.5)
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local n = obj.Name:lower()
                        local found = false
                        for _, name in ipairs(organNames) do
                            if n:find(name) then
                                found = true
                                break
                            end
                        end
                        if found then
                            if not obj:FindFirstAncestorOfClass("Model") or
                               not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                                applyHighlight(obj, Color3.fromRGB(255, 80, 80), "Organ")
                            end
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end)

    -- ========== 3. 传送门透视描边（漩涡状） ==========
    addToggle("🚪 传送门透视描边", false, function(s)
        portalActive = s
        if portalThread then task.cancel(portalThread); portalThread = nil end
        if not s then
            removeHighlights()
            return
        end
        portalThread = task.spawn(function()
            while portalActive do
                task.wait(0.5)
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local n = obj.Name:lower()
                        local isPortal = false

                        if n:find("vortex") or n:find("portal") or n:find("传送门") or
                           n:find("teleport") or n:find("gate") or n:find("door") then
                            isPortal = true
                        end

                        if obj:IsA("Part") and obj.Shape == Enum.PartType.Cylinder then
                            if n:find("portal") or n:find("vortex") then
                                isPortal = true
                            end
                        end

                        if not isPortal then
                            for _, child in pairs(obj:GetChildren()) do
                                if child:IsA("BasePart") then
                                    local cn = child.Name:lower()
                                    if cn:find("vortex") or cn:find("portal") then
                                        isPortal = true
                                        break
                                    end
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
                task.wait(1)
            end
        end)
    end)

    -- ========== 4. 灵魂火焰描边 ==========
    addToggle("🔥 灵魂火焰描边", false, function(s)
        soulActive = s
        if soulThread then task.cancel(soulThread); soulThread = nil end
        if not s then
            removeHighlights()
            return
        end
        soulThread = task.spawn(function()
            local soulNames = {"fire", "flame", "soul", "spirit", "火焰", "灵魂", "火", "灵"}
            while soulActive do
                task.wait(0.5)
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local n = obj.Name:lower()
                        local found = false
                        for _, name in ipairs(soulNames) do
                            if n:find(name) then
                                found = true
                                break
                            end
                        end
                        if found then
                            if not obj:FindFirstAncestorOfClass("Model") or
                               not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                                applyHighlight(obj, Color3.fromRGB(255, 150, 50), "Soul")
                            end
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end)

    addDivider()
    addTitle("🎯 特殊功能")

    -- ========== 5. 找正确的传送门 ==========
    local function findCorrectPortal()
        if correctPortalHL then
            correctPortalHL:Destroy()
            correctPortalHL = nil
        end
        correctPortal = nil

        local portals = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local n = obj.Name:lower()
                local isPortal = false

                if n:find("vortex") or n:find("portal") or n:find("传送门") or
                   n:find("teleport") or n:find("gate") then
                    isPortal = true
                end

                if obj:IsA("Part") and obj.Shape == Enum.PartType.Cylinder then
                    if n:find("portal") or n:find("vortex") then
                        isPortal = true
                    end
                end

                if not isPortal then
                    for _, child in pairs(obj:GetChildren()) do
                        if child:IsA("BasePart") then
                            local cn = child.Name:lower()
                            if cn:find("vortex") or cn:find("portal") then
                                isPortal = true
                                break
                            end
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

        if #portals == 0 then
            print("⚠️ 未找到任何传送门")
            return
        end

        local bestPortal = nil
        local bestScore = 0

        for _, portal in ipairs(portals) do
            local score = 0
            if portal.BrickColor then
                local bc = portal.BrickColor.Name:lower()
                if bc:find("green") or bc:find("blue") or bc:find("yellow") or bc:find("cyan") then
                    score = score + 3
                end
                if bc:find("purple") or bc:find("violet") or bc:find("magenta") then
                    score = score + 2
                end
            end
            if portal:GetAttribute("Correct") or portal:GetAttribute("True") or portal:GetAttribute("正确") then
                score = score + 10
            end
            if portal.Position.Y > 0 and portal.Position.Y < 50 then
                score = score + 2
            end
            local n = portal.Name:lower()
            if n:find("correct") or n:find("true") or n:find("正") or n:find("真") then
                score = score + 8
            end
            if n:find("vortex") then
                score = score + 5
            end
            if portal:IsA("Part") and portal.Shape == Enum.PartType.Cylinder then
                score = score + 4
            end

            if score > bestScore then
                bestScore = score
                bestPortal = portal
            end
        end

        if not bestPortal and #portals > 0 then
            for _, portal in ipairs(portals) do
                if portal.Name:lower():find("vortex") then
                    bestPortal = portal
                    break
                end
            end
            if not bestPortal then
                bestPortal = portals[1]
            end
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

    -- ========== 6. 清除所有高亮 ==========
    addButton("🧹 清除所有高亮", Color3.fromRGB(180, 40, 40), function()
        keyActive = false
        organActive = false
        portalActive = false
        soulActive = false

        if keyThread then task.cancel(keyThread); keyThread = nil end
        if organThread then task.cancel(organThread); organThread = nil end
        if portalThread then task.cancel(portalThread); portalThread = nil end
        if soulThread then task.cancel(soulThread); soulThread = nil end

        removeHighlights()

        if correctPortalHL then
            correctPortalHL:Destroy()
            correctPortalHL = nil
        end
        correctPortal = nil

        print("🧹 已清除所有高亮")
    end)

    addDivider()
    addLabel("💡 钥匙: 金色 | 器官: 红色 | 传送门: 蓝色")
    addLabel("💡 灵魂火焰: 橙色 | 正确传送门: 亮绿色")
    addLabel("💡 点击「找正确的传送门」自动识别漩涡传送门")

    panel.CanvasSize = UDim2.new(0,0,0,#panel:GetChildren()*32+20)
end

-- ============================================================
--  面板：飞行（无敌少侠飞行）
-- ============================================================
local function loadFlight()
    clearPanel()
    addTitle("✈️ 无敌少侠飞行 (稳定版)")
    local flying = false
    local flySpeed = 80
    local bv = nil
    local bg = nil
    local conn = nil

    local function startFly()
        local c = player.Character
        if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        c.Humanoid.PlatformStand = true
        c.Humanoid.WalkSpeed = 0
        c.Humanoid.JumpPower = 0

        bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.new(0,0,0)

        bg = Instance.new("BodyGyro", hrp)
        bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        bg.P = 1e5
        bg.CFrame = hrp.CFrame

        flying = true
        conn = runService.Heartbeat:Connect(function()
            if not flying then return end
            local c2 = player.Character
            if not c2 then return end
            local hrp2 = c2:FindFirstChild("HumanoidRootPart")
            if not hrp2 then return end
            local move = Vector3.new(0,0,0)
            local cam = workspace.CurrentCamera
            if not cam then return end

            if userInput:IsKeyDown(Enum.KeyCode.W) then
                move = move + cam.CFrame.LookVector * Vector3.new(1,0,1)
            end
            if userInput:IsKeyDown(Enum.KeyCode.S) then
                move = move - cam.CFrame.LookVector * Vector3.new(1,0,1)
            end
            if userInput:IsKeyDown(Enum.KeyCode.A) then
                move = move - cam.CFrame.RightVector * Vector3.new(1,0,1)
            end
            if userInput:IsKeyDown(Enum.KeyCode.D) then
                move = move + cam.CFrame.RightVector * Vector3.new(1,0,1)
            end
            if userInput:IsKeyDown(Enum.KeyCode.Space) then
                move = move + Vector3.new(0,1,0)
            end
            if userInput:IsKeyDown(Enum.KeyCode.LeftShift) then
                move = move - Vector3.new(0,1,0)
            end

            if move.Magnitude > 0 then
                move = move.Unit * flySpeed
            end
            bv.Velocity = move

            if move.Magnitude > 1 then
                bg.CFrame = CFrame.new(hrp2.Position, hrp2.Position + move)
            end
        end)
    end

    local function stopFly()
        flying = false
        if conn then conn:Disconnect() end
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
        local c = player.Character
        if c then
            c.Humanoid.PlatformStand = false
            c.Humanoid.WalkSpeed = 16
            c.Humanoid.JumpPower = 50
        end
    end

    addToggle("飞行模式 (WASD/空格/Shift)", false, function(s)
        if s then
            startFly()
        else
            stopFly()
        end
    end)

    addDivider()
    addTitle("🚀 速度调节")
    local spLabel = addLabel("当前: 80 m/s")
    addButton("+5", Color3.fromRGB(60,180,60), function()
        flySpeed = math.min(flySpeed+5, 300)
        spLabel.Text = "当前: " .. flySpeed .. " m/s"
    end)
    addButton("-5", Color3.fromRGB(180,60,60), function()
        flySpeed = math.max(flySpeed-5, 20)
        spLabel.Text = "当前: " .. flySpeed .. " m/s"
    end)

    addDivider()
    addLabel("WASD 水平 | 空格上升 | Shift下降")
    panel.CanvasSize = UDim2.new(0,0,0,#panel:GetChildren()*32+20)
end

-- ============================================================
--  面板：甩飞（静默甩飞 + 传送 + 传送甩飞 + 循环甩飞）
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
            btn.TextColor3 = Color3.fromRGB(0, 0, 0)
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
    loopBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
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
    statusLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
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
--  面板：僵尸塔（杀戮光环 + 无限子弹改进版）
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
    local statusLabel = addLabel("无限子弹: OFF", Color3.fromRGB(0, 0, 0))

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
            statusLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
            print("无限子弹已开启（改进版）")
        else
            cleanAmmoConnections()
            statusLabel.Text = "无限子弹: OFF"
            statusLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
            print("无限子弹已关闭")
        end
    end)

    addDivider()
    addLabel("💡 杀戮光环自动攻击最近僵尸")
    addLabel("💡 无限子弹自动识别弹药属性并锁定")
    panel.CanvasSize = UDim2.new(0,0,0,#panel:GetChildren()*32+20)
end

-- ============================================================
--  标签切换
-- ============================================================
for i,btn in ipairs(btnList) do
    local idx = i
    btn.MouseButton1Click:Connect(function()
        for j,b in ipairs(btnList) do
            b.BackgroundColor3 = (j==idx) and Color3.fromRGB(30,200,255) or Color3.fromRGB(20,40,60)
            b.BackgroundTransparency = 0.6
            b.BorderColor3 = (j==idx) and Color3.fromRGB(30,200,255) or Color3.fromRGB(50,50,70)
            b.TextColor3 = Color3.fromRGB(0, 0, 0)
        end
        if idx == 1 then loadGeneral()
        elseif idx == 2 then loadMM2()
        elseif idx == 3 then loadPeta()
        elseif idx == 4 then loadFlight()
        elseif idx == 5 then loadFlyOff()
        elseif idx == 6 then loadZombieTower()
        elseif idx == 7 then loadIntro()
        end
    end)
end

loadGeneral()

-- ============================================================
--  启动动画结束后销毁并渐现主界面
-- ============================================================
task.wait(3.8)
running = false
task.wait(0.2)
splashGui:Destroy()

-- 主窗口显示并渐现控件
mainFrame.Visible = false
task.wait(0.1)

mainFrame.Visible = true

-- 对文字和边框做渐现
local function fadeInControls()
    local tweens = {}
    local function collect(obj)
        if obj:IsA("GuiObject") then
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                obj.TextTransparency = 1
                local t = tweenService:Create(obj, TweenInfo.new(1.2, Enum.EasingStyle.Linear), {TextTransparency = 0})
                table.insert(tweens, t)
            end
            if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                obj.ImageTransparency = 1
                local t = tweenService:Create(obj, TweenInfo.new(1.2, Enum.EasingStyle.Linear), {ImageTransparency = 0})
                table.insert(tweens, t)
            end
            for _, stroke in pairs(obj:GetChildren()) do
                if stroke:IsA("UIStroke") then
                    stroke.Transparency = 1
                    local t = tweenService:Create(stroke, TweenInfo.new(1.2, Enum.EasingStyle.Linear), {Transparency = 0})
                    table.insert(tweens, t)
                end
            end
        end
        for _, child in pairs(obj:GetChildren()) do
            collect(child)
        end
    end
    collect(mainFrame)
    for _, tween in pairs(tweens) do
        tween:Play()
    end
end

fadeInControls()

print("✅ 唐脚本 v5.0 完整加载成功！")