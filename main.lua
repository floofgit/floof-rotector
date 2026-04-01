--floof's rotector client
--this is just something i made for fun to make rotector easier to use
--does what it says on the tin it scans whole servers for flagged users
--99.83% AI Written thanks to gemini i would code if i could <3
--but it works yeah it's pretty good it's based around the rotector api
--available at https://roscoe.rotector.com/docs
--the extension they made for your browser is at https://rotector.com/
--lots of love from floof 
--currently at V.1.0 as of april 1st 2026 20:07 BST

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local request = (syn and syn.request) or (http and http.request) or http_request or request

-- // CONFIGURATION
local SHOW_CONSOLE_BUTTON = true
local FILE_NAME = "Roscoe_Config.json"
local DISCORD_TOKEN = ""

-- FILE SAVING LOGIC
local function saveConfig()
    local data = {token = DISCORD_TOKEN}
    local success, encoded = pcall(function() return HttpService:JSONEncode(data) end)
    if success and writefile then
        writefile(FILE_NAME, encoded)
    end
end

local function loadConfig()
    if readfile and isfile and isfile(FILE_NAME) then
        local success, content = pcall(function() return readfile(FILE_NAME) end)
        if success then
            local success2, decoded = pcall(function() return HttpService:JSONDecode(content) end)
            if success2 and decoded.token then
                DISCORD_TOKEN = decoded.token
            end
        end
    end
end

loadConfig()

-- Dimensions (Reduced by 15%)
local WIDTH = 638
local HEIGHT_NORMAL = 552
local MIN_SIZE = UDim2.new(0, 55, 0, 55)

local gui = Instance.new("ScreenGui")
gui.Name = "Roscoe_Ultimate_V7_Small"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.Parent = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, WIDTH, 0, HEIGHT_NORMAL)
main.Position = UDim2.new(0.5, -(WIDTH/2), 0.5, -(HEIGHT_NORMAL/2))
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.Parent = gui

-- Draggable logic
local dragging, dragStart, startPos
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true dragStart = input.Position startPos = main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

-- Header
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 55)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -120, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Floof's Rotector Client V.1.0"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 25
title.Font = Enum.Font.GothamBold
title.TextXAlignment = "Left"
title.Parent = titleBar

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 55, 0, 55)
minBtn.Position = UDim2.new(1, -55, 0, 0)
minBtn.Text = "-"
minBtn.TextSize = 35
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.BorderSizePixel = 0
minBtn.ZIndex = 10
minBtn.Parent = main

local keyBtn = Instance.new("TextButton")
keyBtn.Size = UDim2.new(0, 55, 0, 55)
keyBtn.Position = UDim2.new(1, -110, 0, 0)
keyBtn.Text = "🔑"
keyBtn.TextSize = 24
keyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
keyBtn.TextColor3 = Color3.new(1, 1, 1)
keyBtn.BorderSizePixel = 0
keyBtn.ZIndex = 10
keyBtn.Parent = main

-- Scroll Area
local scroll = Instance.new("ScrollingFrame")
scroll.Size = SHOW_CONSOLE_BUTTON and UDim2.new(1, -30, 1, -220) or UDim2.new(1, -30, 1, -160)
scroll.Position = UDim2.new(0, 15, 0, 75)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 10
scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ZIndex = 5
scroll.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 12)
layout.Parent = scroll

local function updateCanvas()
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 40)
end
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

-- Debug Console
local consoleFrame = Instance.new("Frame")
consoleFrame.Size = UDim2.new(1, -34, 0, 0)
consoleFrame.Position = UDim2.new(0, 17, 1, -17)
consoleFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
consoleFrame.BorderSizePixel = 1
consoleFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
consoleFrame.ClipsDescendants = true
consoleFrame.Parent = main

local debugScroll = Instance.new("ScrollingFrame")
debugScroll.Size = UDim2.new(1, -15, 1, -15)
debugScroll.Position = UDim2.new(0, 8, 0, 8)
debugScroll.BackgroundTransparency = 1
debugScroll.ScrollBarThickness = 5
debugScroll.AutomaticCanvasSize = Enum.AutomaticSize.XY
debugScroll.Parent = consoleFrame

local consoleBox = Instance.new("TextBox")
consoleBox.Size = UDim2.new(1, -8, 1, -8)
consoleBox.AutomaticSize = Enum.AutomaticSize.XY 
consoleBox.BackgroundTransparency = 1
consoleBox.Text = ""
consoleBox.TextColor3 = Color3.fromRGB(0, 255, 120) 
consoleBox.TextSize = 12
consoleBox.Font = Enum.Font.Code
consoleBox.TextWrapped = false 
consoleBox.TextXAlignment = Enum.TextXAlignment.Left
consoleBox.TextYAlignment = Enum.TextYAlignment.Top
consoleBox.ClearTextOnFocus = false
consoleBox.TextEditable = false
consoleBox.MultiLine = true 
consoleBox.Parent = debugScroll

local function log(msg)
    local newText = "[" .. os.date("%X") .. "] " .. tostring(msg) .. "\n"
    consoleBox.Text = consoleBox.Text .. newText
    task.defer(function() debugScroll.CanvasPosition = Vector2.new(0, consoleBox.TextBounds.Y) end)
end

-- Control Buttons
local controls = Instance.new("Frame")
controls.Size = SHOW_CONSOLE_BUTTON and UDim2.new(1, 0, 0, 130) or UDim2.new(1, 0, 0, 70)
controls.Position = SHOW_CONSOLE_BUTTON and UDim2.new(0, 0, 1, -135) or UDim2.new(0, 0, 1, -80)
controls.BackgroundTransparency = 1
controls.Parent = main

local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(1, -34, 0, 64)
scanBtn.Position = UDim2.new(0, 17, 0, 0)
scanBtn.Text = "Scan Server"
scanBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
scanBtn.TextColor3 = Color3.new(1, 1, 1)
scanBtn.TextSize = 24
scanBtn.Font = "GothamBold"
scanBtn.Parent = controls

local consoleBtn = Instance.new("TextButton")
if SHOW_CONSOLE_BUTTON then
    consoleBtn.Size = UDim2.new(1, -34, 0, 38)
    consoleBtn.Position = UDim2.new(0, 17, 0, 72)
    consoleBtn.Text = "SHOW COPYABLE LOGS"
    consoleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    consoleBtn.TextColor3 = Color3.new(1, 1, 1)
    consoleBtn.TextSize = 17
    consoleBtn.Parent = controls
end

--- UI LOGIC ---
local consoleOpen = false
if SHOW_CONSOLE_BUTTON then
    consoleBtn.MouseButton1Click:Connect(function()
        consoleOpen = not consoleOpen
        consoleFrame:TweenSize(consoleOpen and UDim2.new(1, -34, 0, 135) or UDim2.new(1, -34, 0, 0), "Out", "Quad", 0.2, true)
        consoleFrame:TweenPosition(consoleOpen and UDim2.new(0, 17, 1, -150) or UDim2.new(0, 17, 1, -17), "Out", "Quad", 0.2, true)
        controls:TweenPosition(consoleOpen and UDim2.new(0, 0, 1, -270) or UDim2.new(0, 0, 1, -135), "Out", "Quad", 0.2, true)
        scroll:TweenSize(consoleOpen and UDim2.new(1, -30, 1, -345) or UDim2.new(1, -30, 1, -220), "Out", "Quad", 0.2, true)
        consoleBtn.Text = consoleOpen and "HIDE COPYABLE LOGS" or "SHOW COPYABLE LOGS"
    end)
end

local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, v in pairs(main:GetChildren()) do if v ~= minBtn and v ~= keyBtn then v.Visible = not minimized end end
    if minimized then
        main:TweenSize(MIN_SIZE, "Out", "Quad", 0.2, true)
        minBtn.Position = UDim2.new(0, 0, 0, 0)
        minBtn.Text = "+"
        keyBtn.Visible = false
    else
        main:TweenSize(UDim2.new(0, WIDTH, 0, HEIGHT_NORMAL), "Out", "Quad", 0.2, true)
        minBtn.Position = UDim2.new(1, -55, 0, 0)
        minBtn.Text = "-"
        keyBtn.Visible = true
    end
end)

--- TOKEN SETTINGS POPUP ---
keyBtn.MouseButton1Click:Connect(function()
    local setGui = Instance.new("ScreenGui")
    setGui.DisplayOrder = 1010
    setGui.Parent = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

    local setMain = Instance.new("Frame")
    setMain.Size = UDim2.new(0, 380, 0, 210)
    setMain.Position = UDim2.new(0.5, -190, 0.5, -105)
    setMain.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    setMain.BorderSizePixel = 1
    setMain.BorderColor3 = Color3.fromRGB(100, 100, 100)
    setMain.Active = true
    setMain.Parent = setGui

    local sDragging, sDragStart, sStartPos
    setMain.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sDragging = true sDragStart = input.Position sStartPos = setMain.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - sDragStart
            setMain.Position = UDim2.new(sStartPos.X.Scale, sStartPos.X.Offset + delta.X, sStartPos.Y.Scale, sStartPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sDragging = false end end)

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 35)
    header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    header.Parent = setMain

    local titleS = Instance.new("TextLabel")
    titleS.Size = UDim2.new(1, -12, 1, 0)
    titleS.Position = UDim2.new(0, 12, 0, 0)
    titleS.BackgroundTransparency = 1
    titleS.Text = "API Settings"
    titleS.TextColor3 = Color3.new(1, 1, 1)
    titleS.Font = "GothamBold"
    titleS.TextSize = 14
    titleS.TextXAlignment = "Left"
    titleS.Parent = header

    local disclaimer = Instance.new("TextLabel")
    disclaimer.Size = UDim2.new(1, -30, 0, 50)
    disclaimer.Position = UDim2.new(0, 15, 0, 45)
    disclaimer.BackgroundTransparency = 1
    disclaimer.Text = "Discord Integration: Enter Bot Token below to fetch usernames. This is saved to workspace."
    disclaimer.TextColor3 = Color3.fromRGB(200, 200, 200)
    disclaimer.TextWrapped = true
    disclaimer.Font = "Gotham"
    disclaimer.TextSize = 12
    disclaimer.TextXAlignment = "Left"
    disclaimer.Parent = setMain

    local tokenInput = Instance.new("TextBox")
    tokenInput.Size = UDim2.new(1, -30, 0, 34)
    tokenInput.Position = UDim2.new(0, 15, 0, 105)
    tokenInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tokenInput.Text = DISCORD_TOKEN
    tokenInput.PlaceholderText = "Paste Bot Token Here..."
    tokenInput.TextColor3 = Color3.new(1, 1, 1)
    tokenInput.Font = "Gotham"
    tokenInput.TextSize = 10
    tokenInput.ClearTextOnFocus = false
    tokenInput.Parent = setMain

    local saveBtn = Instance.new("TextButton")
    saveBtn.Size = UDim2.new(1, -30, 0, 34)
    saveBtn.Position = UDim2.new(0, 15, 0, 155)
    saveBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    saveBtn.Text = "SAVE & CLOSE"
    saveBtn.TextColor3 = Color3.new(1, 1, 1)
    saveBtn.Font = "GothamBold"
    saveBtn.TextSize = 14
    saveBtn.Parent = setMain

    saveBtn.MouseButton1Click:Connect(function()
        DISCORD_TOKEN = tokenInput.Text
        saveConfig()
        log("SYSTEM: Discord API Token Updated.")
        setGui:Destroy()
    end)
end)

--- POPUP CREATOR (INFRACTIONS) ---
local function createDetailsPopup(playerName, details)
    local popupGui = Instance.new("ScreenGui")
    popupGui.DisplayOrder = 1005
    popupGui.Parent = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

    local popupMain = Instance.new("Frame")
    popupMain.Size = UDim2.new(0, 440, 0, 270)
    popupMain.Position = UDim2.new(0.5, -220, 0.5, -135)
    popupMain.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    popupMain.BorderSizePixel = 1
    popupMain.BorderColor3 = Color3.fromRGB(200, 50, 50)
    popupMain.Active = true
    popupMain.Parent = popupGui
    
    local pDragging, pDragStart, pStartPos
    popupMain.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            pDragging = true pDragStart = input.Position pStartPos = popupMain.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if pDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - pDragStart
            popupMain.Position = UDim2.new(pStartPos.X.Scale, pStartPos.X.Offset + delta.X, pStartPos.Y.Scale, pStartPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then pDragging = false end end)

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 35)
    header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    header.Parent = popupMain

    local titleP = Instance.new("TextLabel")
    titleP.Size = UDim2.new(1, -50, 1, 0)
    titleP.Position = UDim2.new(0, 12, 0, 0)
    titleS.BackgroundTransparency = 1 -- Corrected variable reference
    titleP.Text = "Infractions: " .. playerName
    titleP.TextColor3 = Color3.new(1, 1, 1)
    titleP.Font = Enum.Font.GothamBold
    titleP.TextSize = 14
    titleP.TextXAlignment = Enum.TextXAlignment.Left
    titleP.Parent = header

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -35, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.Parent = header
    closeBtn.MouseButton1Click:Connect(function() popupGui:Destroy() end)

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -16, 1, -45)
    scrollFrame.Position = UDim2.new(0, 8, 0, 40)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 5
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.Parent = popupMain

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = scrollFrame

    local fullText = ""
    local reasons = details.reasons or {}
    for category, data in pairs(reasons) do
        if type(data) == "table" then
            local msg = data.message or ""
            local evidenceStr = (data.evidence and type(data.evidence) == "table" and #data.evidence > 0) and (", " .. table.concat(data.evidence, ", ")) or ""
            fullText = fullText .. msg .. evidenceStr .. "\n\n"
        else
            fullText = fullText .. tostring(data) .. "\n\n"
        end
    end

    if details.isReportable ~= nil then fullText = fullText .. "Reportable: " .. (details.isReportable and "YES" or "NO") .. "\n" end
    if details.confidence ~= nil then fullText = fullText .. "Confidence: " .. (details.confidence * 100) .. "%" end

    local overLabel = Instance.new("TextBox")
    overLabel.Size = UDim2.new(1, -8, 0, 0)
    overLabel.AutomaticSize = Enum.AutomaticSize.Y
    overLabel.BackgroundTransparency = 1
    overLabel.Text = fullText
    overLabel.TextColor3 = Color3.fromRGB(220, 220, 220) 
    overLabel.Font = Enum.Font.GothamMedium
    overLabel.TextSize = 13
    overLabel.TextWrapped = true
    overLabel.TextXAlignment = Enum.TextXAlignment.Left
    overLabel.TextYAlignment = Enum.TextYAlignment.Top
    overLabel.TextEditable = false
    overLabel.ClearTextOnFocus = false
    overLabel.Parent = scrollFrame

    if DISCORD_TOKEN ~= "" then
        local discordId = string.match(fullText, "Discord User ID:%s*(%d+)")
        if discordId then
            task.spawn(function()
                local success, response = pcall(function()
                    return request({
                        Url = "https://discord.com/api/v10/users/" .. discordId,
                        Method = "GET",
                        Headers = { ["Authorization"] = "Bot " .. DISCORD_TOKEN }
                    })
                end)
                if success and response.StatusCode == 200 then
                    local d = HttpService:JSONDecode(response.Body)
                    local ts = (tonumber(discordId) / 2^22) + 1420070400000
                    local ds = os.date("!%Y-%m-%d UTC", ts / 1000)
                    local block = "--- DISCORD DATA ---\n" .. "User: @" .. (d.username or "N/A") .. " | ID: " .. discordId .. "\nCreated: " .. ds .. "\n\n"
                    overLabel.Text = block .. fullText
                end
            end)
        end
    end
end

--- PLAYER ROW CREATOR ---
local function createEntry(name, display, id, status, color, details)
    local entry = Instance.new("Frame")
    entry.Size = UDim2.new(1, -16, 0, 100)
    entry.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    entry.BorderSizePixel = 0
    entry.ClipsDescendants = true
    entry.Parent = scroll
    
    local thumb = Instance.new("ImageLabel")
    thumb.Size = UDim2.new(0, 85, 0, 85)
    thumb.Position = UDim2.new(0, 8, 0, 8)
    thumb.Image = "rbxthumb://type=AvatarHeadShot&id=" .. id .. "&w=150&h=150"
    thumb.BackgroundTransparency = 1
    thumb.Parent = entry

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -280, 0, 40)
    nameLabel.Position = UDim2.new(0, 105, 0, 12)
    nameLabel.Text = display .. "\n(@" .. name .. ")"
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextSize = 18 
    nameLabel.TextXAlignment = "Left"
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = "GothamMedium"
    nameLabel.Parent = entry

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0, 150, 0, 40)
    statusLabel.Position = UDim2.new(1, -160, 0, 12)
    statusLabel.Text = status
    statusLabel.TextColor3 = color
    statusLabel.TextSize = 22
    statusLabel.Font = "GothamBold"
    statusLabel.BackgroundTransparency = 1
    statusLabel.Parent = entry

    if status == "FLAGGED" then
        local viewBtn = Instance.new("TextButton")
        viewBtn.Size = UDim2.new(0, 150, 0, 38)
        viewBtn.Position = UDim2.new(1, -160, 0, 52)
        viewBtn.Text = "VIEW DETAILS"
        viewBtn.TextSize = 17
        viewBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        viewBtn.TextColor3 = Color3.new(1, 1, 1)
        viewBtn.ZIndex = 10 
        viewBtn.Parent = entry
        viewBtn.MouseButton1Click:Connect(function() createDetailsPopup(display .. " (@" .. name .. ")", details) end)
    end
end

--- SCAN LOGIC ---
scanBtn.MouseButton1Click:Connect(function()
    log("SYSTEM: Initializing Scan...")
    scanBtn.Text = "WORKING..."
    scanBtn.Active = false
    for _, v in pairs(scroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    local pList = Players:GetPlayers()
    local ids, infoMap = {}, {}
    for _, p in pairs(pList) do
        table.insert(ids, p.UserId)
        infoMap[tostring(p.UserId)] = {n = p.Name, d = p.DisplayName}
    end
    task.spawn(function()
        for i = 1, #ids, 20 do
            local batch = {}
            for j = i, math.min(i + 19, #ids) do table.insert(batch, ids[j]) end
            local success, response = pcall(function()
                return request({
                    Url = "https://roscoe.rotector.com/v1/lookup/roblox/user",
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode({ids = batch, excludeInfo = false})
                })
            end)
            if success and response.StatusCode == 200 then
                local res = HttpService:JSONDecode(response.Body)
                
                -- NEW DUMP LOGIC: Dumps full API data to copyable log
                log("API_DATA DUMP: " .. HttpService:JSONEncode(res))
                
                for id, det in pairs(res.data) do
                    local p = infoMap[tostring(id)]
                    if p then
                        local f = det.flagType
                        local flagged = f and (f ~= 0 and f ~= 3 and f ~= 6)
                        createEntry(p.n, p.d, id, flagged and "FLAGGED" or "CLEAN", flagged and Color3.new(1, 0.2, 0.2) or Color3.new(0.2, 1, 0.4), det)
                    end
                end
            end
            task.wait(0.2)
        end
        log("SCAN COMPLETE.")
        updateCanvas()
        scanBtn.Text = "Scan Server"
        scanBtn.Active = true
    end)
end)
