-- 唐脚本 v7.0（完整修复版）
-- 功能：通用 | MM2 | Peta | 飞行 | 甩飞 | 僵尸塔 | 森林·99夜 | 简介
-- 含：亮度调节 | 人称切换 | 隐身 | 坠落保护 | 穿墙 | 无限跳 | 强制重置 | 反检测 | 鼠标解锁

repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")

-- ============================================================
--  反检测模块
-- ============================================================
local function antiCheatBypass()
    pcall(function()
        if getexecutorname then getexecutorname = function() return "Roblox" end end
        if identifyexecutor then identifyexecutor = function() return "Roblox" end end
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("LocalScript") and obj.Name:lower():find("anti") then
                obj.Disabled = true
            end
        end
    end)
end
task.spawn(function()
    antiCheatBypass()
    while task.wait(60) do antiCheatBypass() end
end)

-- ============================================================
--  启动动画（完整版）
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

-- 主光圈方块
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

-- 外圈小方块
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

-- TANG 字母
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

-- 进度百分比
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

-- 进度条
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

local running = true

-- TANG 字母颜色循环
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

-- 光圈旋转
task.spawn(function()
    while running do
        ringContainer.Rotation = (ringContainer.Rotation + 1.8) % 360
        task.wait(0.02)
    end
end)

-- 方块呼吸动画
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

-- 进度条动画（3.5秒）
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

-- 等待动画完成
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


-- ============================================================
--  主窗口（固定版）
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
mainFrame.Draggable = true  -- 固定，不可拖拽
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

-- ============================================================
--  标题栏（原地缩小到长方形 + 裁剪内容）
-- ============================================================
local titleBar = Instance.new("Frame")
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1,0,0,32)
titleBar.BackgroundColor3 = Color3.fromRGB(18, 22, 42)
titleBar.BackgroundTransparency = 0.1
titleBar.BorderSizePixel = 0
titleBar.Active = false
titleBar.Draggable = false

local titleCorner = Instance.new("UICorner")
titleCorner.Parent = titleBar
titleCorner.CornerRadius = UDim.new(0,8)

-- 标题栏底部光晕
local glowBar = Instance.new("Frame")
glowBar.Parent = titleBar
glowBar.Size = UDim2.new(1,0,0,2)
glowBar.Position = UDim2.new(0,0,1,-2)
glowBar.BackgroundColor3 = Color3.fromRGB(30,200,255)
glowBar.BackgroundTransparency = 0.5
glowBar.BorderSizePixel = 0
local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0,8)
glowCorner.Parent = glowBar

-- 标题文字
local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = titleBar
titleLabel.Size = UDim2.new(0.7,0,1,0)
titleLabel.Position = UDim2.new(0,12,0,0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "✦ 唐脚本 v7.0"
titleLabel.TextColor3 = Color3.fromRGB(255,255,255)
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextTransparency = 0

local btnContainer = Instance.new("Frame")
btnContainer.Parent = titleBar
btnContainer.Size = UDim2.new(0, 60, 1, 0)
btnContainer.Position = UDim2.new(1, -65, 0, 0)
btnContainer.BackgroundTransparency = 1

-- 最小化按钮
local minBtn = Instance.new("TextButton")
minBtn.Parent = btnContainer
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(0, 2, 0.5, -13)
minBtn.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
minBtn.BackgroundTransparency = 0.5
minBtn.Text = "−"
minBtn.TextColor3 = Color3.fromRGB(255,255,255)
minBtn.TextSize = 20
minBtn.Font = Enum.Font.GothamBold
minBtn.BorderSizePixel = 0
local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0,6)
minCorner.Parent = minBtn

minBtn.MouseEnter:Connect(function()
    minBtn.BackgroundColor3 = Color3.fromRGB(60, 70, 100)
    minBtn.BackgroundTransparency = 0.3
end)
minBtn.MouseLeave:Connect(function()
    minBtn.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
    minBtn.BackgroundTransparency = 0.5
end)

-- 关闭按钮
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = btnContainer
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(0, 32, 0.5, -13)
closeBtn.BackgroundColor3 = Color3.fromRGB(65, 35, 35)
closeBtn.BackgroundTransparency = 0.5
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0,6)
closeCorner.Parent = closeBtn

closeBtn.MouseEnter:Connect(function()
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.BackgroundTransparency = 0.3
end)
closeBtn.MouseLeave:Connect(function()
    closeBtn.BackgroundColor3 = Color3.fromRGB(65, 35, 35)
    closeBtn.BackgroundTransparency = 0.5
end)

-- ===== 窗口状态 =====
local isMinimized = false
local normalSize = UDim2.new(0, 600, 0, 350)
local minimizedSize = UDim2.new(0, 600, 0, 32)

-- ===== 启用裁剪 =====
mainFrame.ClipsDescendants = true

-- ===== 原地缩小动画 =====
minBtn.MouseButton1Click:Connect(function()
    if isMinimized then
        -- 展开
        local tweenInfo = TweenInfo.new(
            0.4,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out,
            0,
            false,
            0
        )
        local properties = {
            Size = normalSize,
            BackgroundTransparency = 0.1
        }
        local tween = tweenService:Create(mainFrame, tweenInfo, properties)
        tween:Play()
        isMinimized = false
        minBtn.Text = "−"
        
        -- 光晕恢复
        glowBar.BackgroundTransparency = 0
        task.wait(0.1)
        local fade = tweenService:Create(glowBar, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.5
        })
        fade:Play()
    else
        -- 缩小：只保留标题栏高度，内容被裁剪掉
        local tweenInfo = TweenInfo.new(
            0.35,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In,
            0,
            false,
            0
        )
        local properties = {
            Size = minimizedSize,
            BackgroundTransparency = 0.85
        }
        local tween = tweenService:Create(mainFrame, tweenInfo, properties)
        tween:Play()
        isMinimized = true
        minBtn.Text = "+"
        
        -- 光晕淡出
        local fade = tweenService:Create(glowBar, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 1
        })
        fade:Play()
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    local tweenInfo = TweenInfo.new(
        0.25,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In,
        0,
        false,
        0
    )
    local properties = {
        Size = UDim2.new(0, 100, 0, 20),
        Position = UDim2.new(0.5, -50, 0.5, -10),
        BackgroundTransparency = 1
    }
    local tween = tweenService:Create(mainFrame, tweenInfo, properties)
    tween:Play()
    task.wait(0.25)
    mainFrame.Visible = false
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

        -- ===== 坠落保护（自然灾害模拟器专用版 - 双方案） =====
    local fallActive = false
    local fallType = "缓落"  -- 可选: "缓落" 或 "暴力"
    local fallConn = nil
    local slowFallBV = nil
    local FallingTime = 0
    local slowFallApplied = false
    local fallThreshold = 0.3
    local slowFallSpeed = Vector3.new(0, -50, 0)
    local slowFallMaxForce = Vector3.new(0, 5000, 0)

    local function setupFallProtection(char)
        if fallConn then
            fallConn:Disconnect()
            fallConn = nil
        end

        if not fallActive or not char then return end

        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end

        -- 清理旧的BodyVelocity
        if slowFallBV then
            slowFallBV:Destroy()
            slowFallBV = nil
        end

        if fallType == "缓落" then
            -- ===== 方案一：缓落版 =====
            FallingTime = 0
            slowFallApplied = false

            slowFallBV = Instance.new("BodyVelocity")
            slowFallBV.Velocity = slowFallSpeed
            slowFallBV.MaxForce = slowFallMaxForce
            slowFallBV.Parent = nil

            fallConn = runService.Heartbeat:Connect(function()
                if not fallActive then return end

                local currentChar = player.Character
                if not currentChar then return end

                local currentHrp = currentChar:FindFirstChild("HumanoidRootPart")
                if not currentHrp then return end

                local velY = currentHrp.AssemblyLinearVelocity.Y

                if velY < -2 then
                    FallingTime = FallingTime + 0.1
                    if FallingTime >= fallThreshold and not slowFallApplied then
                        if slowFallBV then
                            slowFallBV.Parent = currentHrp
                            slowFallApplied = true
                        end
                    end
                else
                    FallingTime = 0
                    if slowFallBV then
                        slowFallBV.Parent = nil
                    end
                    slowFallApplied = false
                end
            end)

        else
            -- ===== 方案二：暴力速度重置版 =====
            fallConn = runService.Heartbeat:Connect(function()
                if not fallActive then return end

                local currentChar = player.Character
                if not currentChar then return end

                local currentHrp = currentChar:FindFirstChild("HumanoidRootPart")
                local currentHum = currentChar:FindFirstChildOfClass("Humanoid")
                if not currentHrp or not currentHum then return end

                -- 记录当前速度
                local v = currentHrp.AssemblyLinearVelocity

                -- 重置速度
                currentHrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                -- 等待一帧后恢复水平速度，保持Y轴速度为0
                runService.RenderStepped:Wait()
                currentHrp.AssemblyLinearVelocity = Vector3.new(v.X, 0, v.Z)

                -- 如果处于下落状态，强制改为跑步
                if currentHum:GetState() == Enum.HumanoidStateType.FallingDown then
                    currentHum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
        end
    end

    -- 角色重生重新绑定
    player.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if fallActive then
            FallingTime = 0
            slowFallApplied = false
            if slowFallBV then
                slowFallBV:Destroy()
                slowFallBV = nil
            end
            setupFallProtection(char)
        end
    end)

    -- 主开关
    addToggle("免除掉落伤害", false, function(s)
        fallActive = s
        if s then
            FallingTime = 0
            slowFallApplied = false
            if slowFallBV then
                slowFallBV:Destroy()
                slowFallBV = nil
            end
            setupFallProtection(player.Character)
            print("✅ 免除掉落伤害已开启（模式: " .. fallType .. "）")
        else
            if fallConn then
                fallConn:Disconnect()
                fallConn = nil
            end
            if slowFallBV then
                slowFallBV:Destroy()
                slowFallBV = nil
            end
            print("❌ 免除掉落伤害已关闭")
        end
    end)

    -- 模式切换
    addDivider()
    addTitle("🎯 坠落保护模式")

    addButton("🌊 缓落模式", Color3.fromRGB(100, 200, 255), function()
        fallType = "缓落"
        print("✅ 已切换为缓落模式")
        if fallActive then
            -- 重新应用
            if fallConn then fallConn:Disconnect() end
            if slowFallBV then slowFallBV:Destroy() end
            setupFallProtection(player.Character)
        end
    end)

    addButton("💥 暴力重置模式", Color3.fromRGB(255, 150, 50), function()
        fallType = "暴力"
        print("✅ 已切换为暴力重置模式")
        if fallActive then
            if fallConn then fallConn:Disconnect() end
            if slowFallBV then slowFallBV:Destroy() end
            setupFallProtection(player.Character)
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
    local forceConn = nil

    local function setCameraMode(mode)
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local head = char:FindFirstChild("Head")

        cameraMode = mode

        if mode == "第一人称" then
            -- 强制第一人称：相机锁定到头部
            if head then
                cam.CameraSubject = head
            else
                cam.CameraSubject = hum
            end
            cam.CameraType = Enum.CameraType.Attach
            hum.CameraOffset = Vector3.new(0, 0, 0)
            -- 禁用鼠标旋转
            userInput.MouseBehavior = Enum.MouseBehavior.Default
            userInput.MouseIconEnabled = true
            print("🎥 已强制切换到: 第一人称")
        elseif mode == "第三人称" then
            cam.CameraType = Enum.CameraType.Custom
            cam.CameraSubject = hum
            hum.CameraOffset = Vector3.new(0, 0, 0)
            userInput.MouseBehavior = Enum.MouseBehavior.Default
            userInput.MouseIconEnabled = true
            print("🎥 已切换到: 第三人称")
        else
            cam.CameraType = Enum.CameraType.Custom
            cam.CameraSubject = hum
            hum.CameraOffset = Vector3.new(0, 0, 0)
            userInput.MouseBehavior = Enum.MouseBehavior.Default
            userInput.MouseIconEnabled = true
            print("🎥 已切换到: 自由模式")
        end
    end

    -- 持续强制第一人称（防止被游戏覆盖）
    local function startForceLoop()
        if forceConn then forceConn:Disconnect() end
        forceConn = runService.Heartbeat:Connect(function()
            if cameraMode == "第一人称" then
                local char = player.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local head = char:FindFirstChild("Head")
                    if hum then
                        if cam.CameraType ~= Enum.CameraType.Attach then
                            cam.CameraType = Enum.CameraType.Attach
                        end
                        if head and cam.CameraSubject ~= head then
                            cam.CameraSubject = head
                        elseif cam.CameraSubject ~= hum then
                            cam.CameraSubject = hum
                        end
                        hum.CameraOffset = Vector3.new(0, 0, 0)
                    end
                end
            end
        end)
    end

    startForceLoop()

    local function onCharAdded(char)
        task.wait(0.5)
        if cameraMode == "第一人称" then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local head = char:FindFirstChild("Head")
            if head then
                cam.CameraSubject = head
            elseif hum then
                cam.CameraSubject = hum
            end
            cam.CameraType = Enum.CameraType.Attach
            if hum then hum.CameraOffset = Vector3.new(0, 0, 0) end
        elseif cameraMode == "第三人称" or cameraMode == "自由" then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                cam.CameraSubject = hum
                cam.CameraType = Enum.CameraType.Custom
                hum.CameraOffset = Vector3.new(0, 0, 0)
            end
        end
    end

    player.CharacterAdded:Connect(onCharAdded)

    local modeLabel = addLabel("当前人称: 第三人称")

    addButton("👤 强制第一人称", Color3.fromRGB(100, 200, 255), function()
        setCameraMode("第一人称")
        modeLabel.Text = "当前人称: 第一人称（强制）"
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

    -- 穿墙
    addTitle("🧱 穿墙")
    local noclipActive = false
    local noclipConn = nil

    addToggle("穿墙 (Noclip)", false, function(s)
        noclipActive = s
        if noclipConn then
            noclipConn:Disconnect()
            noclipConn = nil
        end
        if s then
            noclipConn = runService.Stepped:Connect(function()
                if not noclipActive then return end
                local char = player.Character
                if not char then return end
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
            print("✅ 穿墙已开启")
        else
            local char = player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
            print("❌ 穿墙已关闭")
        end
    end)

    addDivider()

    -- 无限跳
    addTitle("🦘 无限跳")
    addToggle("无限跳", false, function(s)
        userInput.JumpRequest:Connect(function()
            if s and player.Character then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:ChangeState("Jumping")
                end
            end
        end)
    end)

    addDivider()

    -- 强制重置
    addTitle("💀 强制重置")

    addButton("💀 强制角色死亡 (重置)", Color3.fromRGB(255, 50, 50), function()
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.Health = 0
                print("💀 角色已强制死亡")
            else
                char:BreakJoints()
                print("💀 角色已强制死亡 (备用)")
            end
        else
            print("⚠️ 角色不存在")
        end
    end)

    -- 鼠标解锁
    addDivider()
    addTitle("🖱️ 鼠标控制")

    addButton("🔓 强制解锁鼠标", Color3.fromRGB(100, 200, 255), function()
        pcall(function()
            userInput.MouseBehavior = Enum.MouseBehavior.Default
            userInput.MouseIconEnabled = true
            local cam = workspace.CurrentCamera
            if cam then
                cam.CameraType = Enum.CameraType.Custom
            end
            print("🖱️ 鼠标已解锁")
        end)
    end)

    addButton("🔒 锁定鼠标", Color3.fromRGB(200, 100, 100), function()
        pcall(function()
            userInput.MouseBehavior = Enum.MouseBehavior.LockCenter
            userInput.MouseIconEnabled = false
            print("🖱️ 鼠标已锁定")
        end)
    end)

    addButton("🔄 切换鼠标锁定", Color3.fromRGB(150, 150, 150), function()
        pcall(function()
            if userInput.MouseBehavior == Enum.MouseBehavior.Default then
                userInput.MouseBehavior = Enum.MouseBehavior.LockCenter
                userInput.MouseIconEnabled = false
                print("🖱️ 鼠标已锁定")
            else
                userInput.MouseBehavior = Enum.MouseBehavior.Default
                userInput.MouseIconEnabled = true
                print("🖱️ 鼠标已解锁")
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
--  面板：MM2（完整功能版）
-- ============================================================
local function loadMM2()
    clearPanel()
    local targetPlayer = nil

    -- ===== 玩家列表 =====
    addTitle("👥 玩家列表（点击选择）")
    
    local listFrame = Instance.new("Frame")
    listFrame.Parent = panel
    listFrame.Size = UDim2.new(1, -4, 0, 100)
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
    scroll.ScrollBarThickness = 4
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
                b.Size = UDim2.new(0.9, 0, 0, 22)
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
                y = y + 26
            end
        end
        scroll.CanvasSize = UDim2.new(0, 0, 0, y + 4)
    end
    refreshPlayerList()

    addButton("🔄 刷新玩家列表", Color3.fromRGB(40, 80, 120), refreshPlayerList)

    -- ===== 复制操作 =====
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

    addButton("📋 复制目标武器 (装备到手)", Color3.fromRGB(180, 120, 40), function()
        copyWeaponFrom(targetPlayer)
    end)

    addButton("🔍 复制警长/杀手武器 (自动)", Color3.fromRGB(180, 60, 60), function()
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

    -- ===== 全物品获取 =====
    addDivider()
    addTitle("📦 全物品获取")

    addButton("🎯 获取全部武器 (MM2所有)", Color3.fromRGB(255, 200, 50), function()
        pcall(function()
            local DataBase = getrenv()._G.Database
            local PlayerData = getrenv()._G.PlayerData
            if not DataBase then
                DataBase = require(game:GetService("ReplicatedStorage").Database.Sync.Item)
                PlayerData = require(game:GetService("ReplicatedStorage").Modules.ProfileData)
            end
            if not DataBase then
                print("❌ 无法获取武器数据库，请确认在MM2游戏中")
                return
            end
            
            local newOwned = {}
            for i, v in next, DataBase.Item do
                newOwned[i] = math.random(1, 5)
            end
            
            local PlayerWeapons = PlayerData.Weapons
            game:GetService("RunService"):BindToRenderStep("InventoryUpdate", 0, function()
                PlayerWeapons.Owned = newOwned
            end)
            
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.Health = 0
                end
            end
            print("✅ 已获取全部武器，角色已重置")
        end)
    end)

    -- ===== 指定武器生成 =====
    addDivider()
    addTitle("🔧 指定武器生成")
    
    addLabel("💡 输入武器名称（如：Luger、Chroma）")
    
    local weaponBox = Instance.new("TextBox")
    weaponBox.Parent = panel
    weaponBox.Size = UDim2.new(1, -4, 0, 30)
    weaponBox.Position = UDim2.new(0, 2, 0, #panel:GetChildren() * 32 + 4)
    weaponBox.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    weaponBox.BackgroundTransparency = 0.3
    weaponBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    weaponBox.TextSize = 14
    weaponBox.Font = Enum.Font.Gotham
    weaponBox.PlaceholderText = "输入武器名称..."
    weaponBox.Text = ""
    local wc = Instance.new("UICorner")
    wc.CornerRadius = UDim.new(0, 4)
    wc.Parent = weaponBox

    addButton("🔫 生成武器", Color3.fromRGB(50, 150, 255), function()
        local weaponName = weaponBox.Text
        if weaponName == "" then
            print("⚠️ 请输入武器名称")
            return
        end
        pcall(function()
            local DataBase = require(game:GetService("ReplicatedStorage").Database.Sync.Item)
            local PlayerData = require(game:GetService("ReplicatedStorage").Modules.ProfileData)
            
            if not DataBase or not DataBase.Item[weaponName] then
                print("❌ 未找到武器: " .. weaponName)
                return
            end
            
            local newOwned = {}
            newOwned[weaponName] = 1
            local PlayerWeapons = PlayerData.Weapons
            
            game:GetService("RunService"):BindToRenderStep("InventoryUpdate", 0, function()
                PlayerWeapons.Owned = newOwned
            end)
            
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.Health = 0
                end
            end
            print("✅ 已生成武器: " .. weaponName)
        end)
    end)

    -- ===== 从目标复制武器 =====
    addDivider()
    addTitle("📋 从目标复制")

    addButton("📋 复制目标当前武器", Color3.fromRGB(255, 180, 50), function()
        if not targetPlayer then
            print("⚠️ 请先在玩家列表中选择目标")
            return
        end
        pcall(function()
            local targetChar = targetPlayer.Character
            if not targetChar then
                print("❌ 目标角色不存在")
                return
            end
            
            local targetTool = nil
            for _, child in pairs(targetChar:GetChildren()) do
                if child:IsA("Tool") then
                    targetTool = child
                    break
                end
            end
            if not targetTool then
                local backpack = targetPlayer:FindFirstChild("Backpack")
                if backpack then
                    for _, child in pairs(backpack:GetChildren()) do
                        if child:IsA("Tool") then
                            targetTool = child
                            break
                        end
                    end
                end
            end
            
            if not targetTool then
                print("❌ 目标没有武器")
                return
            end
            
            local DataBase = require(game:GetService("ReplicatedStorage").Database.Sync.Item)
            local PlayerData = require(game:GetService("ReplicatedStorage").Modules.ProfileData)
            local weaponName = targetTool.Name
            
            if DataBase and DataBase.Item[weaponName] then
                local newOwned = {}
                newOwned[weaponName] = 1
                game:GetService("RunService"):BindToRenderStep("InventoryUpdate", 0, function()
                    PlayerData.Weapons.Owned = newOwned
                end)
                
                local char = player.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then hum.Health = 0 end
                end
                print("✅ 已复制武器: " .. weaponName .. "（来自 " .. targetPlayer.Name .. "）")
            else
                print("❌ 复制失败，武器名: " .. weaponName)
            end
        end)
    end)

    -- ===== 收音机（修复版） =====
    addDivider()
    addTitle("🎵 收音机")

    addButton("📻 尝试获取收音机", Color3.fromRGB(255, 200, 100), function()
        pcall(function()
            local DataBase = getrenv()._G.Database
            local PlayerData = getrenv()._G.PlayerData
            if not DataBase then
                DataBase = require(game:GetService("ReplicatedStorage").Database.Sync.Item)
                PlayerData = require(game:GetService("ReplicatedStorage").Modules.ProfileData)
            end
            
            -- 方法1：从 GamePass 获取
            if DataBase and DataBase.GamePass then
                for i, v in next, DataBase.GamePass do
                    if tostring(i):lower():find("radio") then
                        local PlayerGamePass = PlayerData.GamePass
                        if PlayerGamePass then
                            PlayerGamePass[i] = true
                            print("✅ 已解锁收音机 GamePass: " .. tostring(i))
                            return
                        end
                    end
                end
            end
            
            -- 方法2：从商店物品获取
            if DataBase and DataBase.Shop then
                for i, v in next, DataBase.Shop do
                    if tostring(i):lower():find("radio") then
                        print("🔄 找到收音机商店物品: " .. tostring(i))
                    end
                end
            end
            
            -- 方法3：直接给背包添加
            local radioTool = game:GetService("ReplicatedStorage"):FindFirstChild("Radio")
            if radioTool then
                local clone = radioTool:Clone()
                clone.Parent = player.Backpack
                print("✅ 已添加收音机到背包")
                return
            end
            
            -- 方法4：遍历查找
            for _, obj in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                if obj:IsA("Tool") and obj.Name:lower():find("radio") then
                    local clone = obj:Clone()
                    clone.Parent = player.Backpack
                    print("✅ 已添加收音机到背包: " .. obj.Name)
                    return
                end
            end
            
            print("⚠️ 未找到收音机，请手动购买 Game Pass")
        end)
    end)

    addButton("🎵 获取所有收音机变体", Color3.fromRGB(200, 180, 100), function()
        pcall(function()
            local DataBase = getrenv()._G.Database
            local PlayerData = getrenv()._G.PlayerData
            if not DataBase then
                DataBase = require(game:GetService("ReplicatedStorage").Database.Sync.Item)
                PlayerData = require(game:GetService("ReplicatedStorage").Modules.ProfileData)
            end
            
            if not DataBase then
                print("❌ 无法获取数据库")
                return
            end
            
            -- 查找所有收音机
            local found = false
            for i, v in next, DataBase.Item do
                local name = tostring(i):lower()
                if name:find("radio") then
                    local newOwned = {}
                    newOwned[i] = math.random(1, 3)
                    local PlayerWeapons = PlayerData.Weapons
                    game:GetService("RunService"):BindToRenderStep("InventoryUpdate", 0, function()
                        PlayerWeapons.Owned = newOwned
                    end)
                    found = true
                    print("✅ 已获取收音机: " .. tostring(i))
                end
            end
            
            if not found then
                print("❌ 未找到收音机变体，尝试从GamePass获取")
                -- 尝试 GamePass
                if DataBase.GamePass then
                    for i, v in next, DataBase.GamePass do
                        if tostring(i):lower():find("radio") then
                            local PlayerGamePass = PlayerData.GamePass
                            if PlayerGamePass then
                                PlayerGamePass[i] = true
                                print("✅ 已解锁收音机 GamePass: " .. tostring(i))
                            end
                        end
                    end
                end
            end
            
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.Health = 0 end
            end
            print("✅ 收音机获取完成")
        end)
    end)

    -- ===== 战斗功能 =====
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

    -- ===== 身份标签 =====
    addDivider()
    addTitle("🏷️ 身份标签")

    local showIdentity = false
    local identityConn = nil

    local function getPlayerIdentity(targetPlayer)
        local char = targetPlayer.Character
        if not char then return "👤 平民"
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

    addButton("刷新身份标签", Color3.fromRGB(30, 150, 200), function()
        if showIdentity then
            clearIdentityLabels()
            updateIdentityLabels()
            print("身份标签已刷新")
        else
            print("请先开启身份标签开关")
        end
    end)

    -- ===== 名字标签 =====
    addDivider()
    addTitle("🏷️ 名字标签")

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

    addButton("刷新名字标签", Color3.fromRGB(30, 150, 200), function()
        if showNameLabels then
            clearNameLabels()
            updateNameLabels()
            print("名字标签已刷新")
        else
            print("请先开启名字标签开关")
        end
    end)

    -- ===== Kill Aura =====
    addDivider()
    addTitle("💀 Kill Aura")

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

    addButton("攻击范围 +5", Color3.fromRGB(60, 180, 60), function()
        killRange = math.min(killRange + 5, 100)
        print("攻击范围已调整为: " .. killRange)
    end)
    addButton("攻击范围 -5", Color3.fromRGB(180, 60, 60), function()
        killRange = math.max(killRange - 5, 10)
        print("攻击范围已调整为: " .. killRange)
    end)
    addLabel("当前攻击范围: " .. killRange .. " 格 (默认30)")

    -- ===== 传送功能 =====
    addDivider()
    addTitle("📍 传送功能")

    addButton("传送到大厅", Color3.fromRGB(30, 120, 180), function()
        local c = player.Character
        if c then
            local h = c:FindFirstChild("HumanoidRootPart")
            if h then h.CFrame = CFrame.new(-108.5, 145, 0.6) end
        end
    end)

    addButton("传送到地图", Color3.fromRGB(30, 120, 180), function()
        for _, obj in pairs(workspace:GetChildren()) do
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

    panel.CanvasSize = UDim2.new(0, 0, 0, #panel:GetChildren() * 32 + 20)
end

-- ============================================================
--  面板：Peta（完整修复版）
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
        local count = 0
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local n = obj.Name:lower()
                for _, kw in ipairs(keywords) do
                    if n:find(kw) then
                        if not obj:FindFirstAncestorOfClass("Model") or
                           not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                            applyHighlight(obj, color)
                            count = count + 1
                        end
                        break
                    end
                end
            end
        end
        print("🔍 已扫描: " .. label .. "，找到 " .. count .. " 个")
        return count
    end

    -- 孩子透视
    local function scanChildrenOnce()
        removeHighlights()
        local childKeywords = {"child","kid","孩子","小孩","baby","婴儿","dino kid","kraken kid","squid kid","koala kid","恐龙小子","海怪小子","鱿鱼小子","考拉小子","npc","villager","村民","boy","girl","男孩","女孩","学生","student","小朋友","儿童"}
        local count = 0
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
                        count = count + 1
                    end
                end
            end
        end
        print("🔍 已扫描: 孩子，找到 " .. count .. " 个")
    end

    -- 五种颜色的娃娃（彩虹色）- 修复版
    local function scanDollOnce()
        removeHighlights()
        local dollKeywords = {"doll","洋娃娃","娃娃","red doll","blue doll","green doll","yellow doll","purple doll","pink doll","doll red","doll blue","doll green","doll yellow","doll purple","doll pink","Doll","DOLL"}
        local count = 0
        local hue = 0
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local n = obj.Name:lower()
                local found = false
                for _, kw in ipairs(dollKeywords) do
                    if n:find(kw) then found = true; break end
                end
                -- 检查父级名称
                if not found and obj.Parent and obj.Parent:IsA("Model") then
                    local pn = obj.Parent.Name:lower()
                    for _, kw in ipairs(dollKeywords) do
                        if pn:find(kw) then found = true; break end
                    end
                end
                if found then
                    if not obj:FindFirstAncestorOfClass("Model") or
                       not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                        hue = (hue + 0.15) % 1
                        applyHighlight(obj, Color3.fromHSV(hue, 1, 1))
                        count = count + 1
                    end
                end
            end
        end
        print("🔍 已扫描: 五种颜色的娃娃（彩虹色），找到 " .. count .. " 个")
    end

    -- 娃娃头透视 - 修复版
    local function scanDollHeadOnce()
        removeHighlights()
        local headKeywords = {"head","头","头部","doll head","娃娃头","洋娃娃头","face","脸","hair","头发","eye","眼睛","Head","HEAD"}
        local count = 0
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local n = obj.Name:lower()
                local found = false
                for _, kw in ipairs(headKeywords) do
                    if n:find(kw) then found = true; break end
                end
                -- 检查父级是否包含娃娃相关名称
                if not found and obj.Parent and obj.Parent:IsA("Model") then
                    local pn = obj.Parent.Name:lower()
                    if pn:find("doll") or pn:find("娃娃") or pn:find("洋娃娃") then
                        for _, kw in ipairs(headKeywords) do
                            if n:find(kw) then found = true; break end
                        end
                    end
                end
                if found then
                    if not obj:FindFirstAncestorOfClass("Model") or
                       not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                        applyHighlight(obj, Color3.fromRGB(255, 200, 100))
                        count = count + 1
                    end
                end
            end
        end
        print("🔍 已扫描: 娃娃头，找到 " .. count .. " 个")
    end

    -- ===== 透视开关 =====

    -- 钥匙透视（增强版）
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

    -- 木制钥匙透视
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

    -- 箱子（增强关键词）
    addToggle("📦 箱子透视", false, function(s)
        if s then
            scanOnce({"chest","crate","箱","箱子","宝箱","FindBox","OpenBox","Box","Chest"}, Color3.fromRGB(255, 180, 50), "箱子")
        else
            removeHighlights()
        end
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
        if s then scanChildrenOnce() else removeHighlights() end
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

    -- 五种颜色的娃娃（彩虹色）- 修复版
    addToggle("🎎 五种颜色的娃娃透视", false, function(s)
        if s then scanDollOnce() else removeHighlights() end
    end)

    -- 娃娃头 - 修复版
    addToggle("👤 娃娃头透视", false, function(s)
        if s then scanDollHeadOnce() else removeHighlights() end
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
        teleportToNearest({"chest","crate","箱","箱子","宝箱","FindBox","OpenBox","Box","Chest"}, "箱子")
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
--  面板：甩飞（完整版）
-- ============================================================
local function loadFlyOff()
    clearPanel()
    addTitle("🌀 静默甩飞")

    local isSilentFlyEnabled = false
    local flyConnections = {}
    local selectedPlayer = nil
    local isTeleportFlying = false
    local originalPosition = nil
    local wasSilentFlyEnabledBefore = false
    local isLoopFlyEnabled = false
    local loopFlyConnections = {}
    local loopTargetPlayer = nil
    local loopAllActive = false
    local loopAllConn = nil
    local playerButtons = {}
    local playerListScrolling = nil
    local statusLabel = nil
    local loopFlyBtn = nil
    local loopAllBtn = nil

    local function SafeGetCharacter(targetPlayer)
        if not targetPlayer then return nil end
        local char = targetPlayer.Character
        if not char or not char.Parent then return nil end
        return char
    end

    local function SafeGetHumanoid(char)
        if not char then return nil end
        return char:FindFirstChildOfClass("Humanoid")
    end

    local function SafeGetHRP(char)
        if not char then return nil end
        return char:FindFirstChild("HumanoidRootPart")
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

    local function flingPlayer(targetPlayer)
        if not targetPlayer then return false end
        local targetChar = SafeGetCharacter(targetPlayer)
        if not targetChar then return false end
        local targetHRP = SafeGetHRP(targetChar)
        if not targetHRP then return false end
        local vel = Instance.new("BodyVelocity")
        vel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        vel.Velocity = Vector3.new(
            math.random(-500, 500),
            math.random(200, 800),
            math.random(-500, 500)
        )
        vel.Parent = targetHRP
        local hum = SafeGetHumanoid(targetChar)
        if hum then
            hum.PlatformStand = true
            hum.Sit = false
        end
        task.delay(0.5, function()
            if vel and vel.Parent then vel:Destroy() end
            if hum then hum.PlatformStand = false end
        end)
        return true
    end

    local function flingAllPlayers()
        local count = 0
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player then
                if flingPlayer(p) then count = count + 1 end
                task.wait(0.05)
            end
        end
        print("🌀 已甩飞 " .. count .. " 名玩家")
        if statusLabel then statusLabel.Text = "✅ 已甩飞 " .. count .. " 人" end
        return count
    end

    local function startLoopFlingAll()
        if loopAllActive then return end
        loopAllActive = true
        print("🔄 开始循环甩飞所有人")
        if statusLabel then statusLabel.Text = "🔄 循环甩飞所有人中..." end
        loopAllConn = runService.Heartbeat:Connect(function()
            if not loopAllActive then
                loopAllConn:Disconnect()
                loopAllConn = nil
                return
            end
            flingAllPlayers()
            task.wait(1)
        end)
        if loopAllBtn then
            loopAllBtn.Text = "🔄 循环甩飞所有人 ON"
            loopAllBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
            loopAllBtn.BorderColor3 = Color3.fromRGB(200, 0, 0)
        end
    end

    local function stopLoopFlingAll()
        loopAllActive = false
        if loopAllConn then
            loopAllConn:Disconnect()
            loopAllConn = nil
        end
        print("⏹️ 已停止循环甩飞所有人")
        if statusLabel then statusLabel.Text = "⏹️ 已停止" end
        if loopAllBtn then
            loopAllBtn.Text = "🔄 循环甩飞所有人 OFF"
            loopAllBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
            loopAllBtn.BorderColor3 = Color3.fromRGB(0, 200, 0)
        end
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
        print(isSilentFlyEnabled and "✅ 静默甩飞已开启" or "❌ 静默甩飞已关闭")
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
        local targetPos = hrp.Position + hrp.CFrame.LookVector * 2
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
                if loopFlyBtn then
                    loopFlyBtn.Text = "🔄 循环甩飞 OFF"
                    loopFlyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
                    loopFlyBtn.BorderColor3 = Color3.fromRGB(0, 200, 0)
                end
                return
            end
            local targetChar = SafeGetCharacter(selectedPlayer)
            if not targetChar then
                print("目标玩家不在游戏中")
                if statusLabel then statusLabel.Text = "⚠️ 目标不在游戏中" end
                isLoopFlyEnabled = false
                if loopFlyBtn then
                    loopFlyBtn.Text = "🔄 循环甩飞 OFF"
                    loopFlyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
                    loopFlyBtn.BorderColor3 = Color3.fromRGB(0, 200, 0)
                end
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
            if loopFlyBtn then
                loopFlyBtn.Text = "🔄 循环甩飞 ON"
                loopFlyBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
                loopFlyBtn.BorderColor3 = Color3.fromRGB(200, 0, 0)
            end
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
            if loopFlyBtn then
                loopFlyBtn.Text = "🔄 循环甩飞 OFF"
                loopFlyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
                loopFlyBtn.BorderColor3 = Color3.fromRGB(0, 200, 0)
            end
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

    -- GUI
    addToggle("静默甩飞", false, function(s)
        ToggleSilentFly(s)
    end)

    addLabel("选择目标玩家（点击列表选中）")
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

    playerListScrolling = Instance.new("ScrollingFrame")
    playerListScrolling.Parent = listFrame
    playerListScrolling.Size = UDim2.new(1, -4, 1, 0)
    playerListScrolling.Position = UDim2.new(0, 2, 0, 0)
    playerListScrolling.BackgroundTransparency = 1
    playerListScrolling.ScrollBarThickness = 4
    playerListScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)

    RefreshPlayerList()
    addButton("刷新玩家列表", Color3.fromRGB(30, 100, 160), RefreshPlayerList)

    addDivider()
    addTitle("🎯 单目标操作")

    addButton("🚀 传送到目标前方", Color3.fromRGB(0, 80, 160), TeleportToPlayer)
    addButton("🔄 传送甩飞 (3秒)", Color3.fromRGB(0, 130, 0), TeleportFlyToPlayer)

    loopFlyBtn = Instance.new("TextButton")
    loopFlyBtn.Parent = panel
    loopFlyBtn.Size = UDim2.new(1, -4, 0, 30)
    loopFlyBtn.Position = UDim2.new(0, 2, 0, #panel:GetChildren() * 32 + 4)
    loopFlyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    loopFlyBtn.BackgroundTransparency = 0.5
    loopFlyBtn.BorderSizePixel = 1
    loopFlyBtn.BorderColor3 = Color3.fromRGB(0, 200, 0)
    loopFlyBtn.Text = "🔄 循环甩飞 OFF"
    loopFlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    loopFlyBtn.TextSize = 12
    loopFlyBtn.Font = Enum.Font.Gotham
    local c = Instance.new("UICorner")
    c.Parent = loopFlyBtn
    c.CornerRadius = UDim.new(0, 4)
    loopFlyBtn.MouseButton1Click:Connect(function()
        isLoopFlyEnabled = not isLoopFlyEnabled
        ToggleLoopFly(isLoopFlyEnabled)
    end)

    addDivider()
    addTitle("🌐 全体操作")

    addButton("🌀 甩飞所有人", Color3.fromRGB(200, 80, 80), function()
        flingAllPlayers()
    end)

    loopAllBtn = Instance.new("TextButton")
    loopAllBtn.Parent = panel
    loopAllBtn.Size = UDim2.new(1, -4, 0, 30)
    loopAllBtn.Position = UDim2.new(0, 2, 0, #panel:GetChildren() * 32 + 4)
    loopAllBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    loopAllBtn.BackgroundTransparency = 0.5
    loopAllBtn.BorderSizePixel = 1
    loopAllBtn.BorderColor3 = Color3.fromRGB(0, 200, 0)
    loopAllBtn.Text = "🔄 循环甩飞所有人 OFF"
    loopAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    loopAllBtn.TextSize = 12
    loopAllBtn.Font = Enum.Font.Gotham
    local c2 = Instance.new("UICorner")
    c2.Parent = loopAllBtn
    c2.CornerRadius = UDim.new(0, 4)
    loopAllBtn.MouseButton1Click:Connect(function()
        if loopAllActive then
            stopLoopFlingAll()
        else
            startLoopFlingAll()
        end
    end)

    statusLabel = Instance.new("TextLabel")
    statusLabel.Parent = panel
    statusLabel.Size = UDim2.new(1, -4, 0, 18)
    statusLabel.Position = UDim2.new(0, 2, 0, #panel:GetChildren() * 32 + 4)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "等待选择玩家..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusLabel.TextSize = 11
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center

    panel.CanvasSize = UDim2.new(0, 0, 0, #panel:GetChildren() * 32 + 20)

    game.Players.PlayerAdded:Connect(RefreshPlayerList)
    game.Players.PlayerRemoving:Connect(function(p)
        RefreshPlayerList()
        if isLoopFlyEnabled and loopTargetPlayer and not game.Players:FindFirstChild(loopTargetPlayer.Name) then
            ToggleLoopFly(false)
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
--  启动（启动动画完整播放 + 弹出特效）
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
    
    -- 设置初始状态：透明且缩小（从中心弹出）
    mainFrame.BackgroundTransparency = 1
    mainFrame.Size = UDim2.new(0, 400, 0, 250)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
    gui.Enabled = true
    mainFrame.Visible = true
    
    -- 弹出动画：缩放 + 淡入 + 弹性
    local tweenInfo = TweenInfo.new(
        0.6,                            -- 持续时间（秒）
        Enum.EasingStyle.Back,          -- 缓动风格（带弹性回弹）
        Enum.EasingDirection.Out,       -- 缓动方向（先快后慢）
        0,                              -- 重复次数
        false,                          -- 是否往返
        0                               -- 延迟
    )
    
    local properties = {
        BackgroundTransparency = 0.15,   -- 最终透明度
        Size = UDim2.new(0, 600, 0, 350), -- 最终大小
        Position = UDim2.new(0.5, -300, 0.5, -175)
    }
    
    local tween = tweenService:Create(mainFrame, tweenInfo, properties)
    tween:Play()
    
    -- 动画结束后销毁启动画面
    tween.Completed:Connect(function()
        splashGui:Destroy()
        print("✅ 唐脚本 v7.0 已加载完成")
    end)
    
    -- 安全保险：2.5秒后强制销毁
    task.wait(2.5)
    if splashGui and splashGui.Parent then
        splashGui:Destroy()
    end
end)
