-- BASE: working_walk_simple.lua (TIDAK DIUBAH LOGIC BUY NYA)
-- TAMBAHAN: webhook, AnimalsData rarity, anti-AFK

local Players = game:GetService("Players")
local VIM = game:GetService("VirtualInputManager")
local RS = game:GetService("ReplicatedStorage")
local HS = game:GetService("HttpService")
local Player = Players.LocalPlayer

local ENABLED = true
local HOLD_DURATION = 1.0
local WEBHOOK = "https://discord.com/api/webhooks/1466006066092441775/8DsnvmDiEUFr3wCq0hb2cgOSrSoZs9-EaLDF128AGBgCNhvVRACFJnZVnjZRJ_Ce06Xx"

-- Rarity dari game data
local AnimalsData = require(RS:WaitForChild("Datas"):WaitForChild("Animals"))
local RV = {["Secret"]=10,["OG"]=9,["Brainrot God"]=8,Mythic=7,Legendary=6,Epic=5,Rare=4,Common=3}
local MIN_RARITY = 6 -- Legendary+

-- Anti-AFK
local lastAFK, AFKi = tick(), math.random(30,60)
local Ping; pcall(function() Ping = RS:WaitForChild("UserGenerated",2):WaitForChild("Analytics",2):WaitForChild("ClientKit",2):WaitForChild("Ping",2) end)

-- Webhook dedup
local lastWH = ""
local function sendWH(msg)
    if msg == lastWH then return end
    lastWH = msg
    pcall(function()
        request({Url=WEBHOOK, Method="POST", Headers={["Content-Type"]="application/json"}, Body=HS:JSONEncode({content="**["..Player.Name.."]** "..msg})})
    end)
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "LegPlus"
gui.ResetOnSpawn = false
gui.Parent = Player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 50)
frame.Position = UDim2.new(0, 50, 0.4, 0)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -10, 0, 30)
btn.Position = UDim2.new(0, 5, 0, 5)
btn.Text = "LEG+: ON"
btn.BackgroundColor3 = Color3.new(0, 0.8, 0)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -10, 0, 15)
status.Position = UDim2.new(0, 5, 0, 35)
status.Text = "Ready"
status.TextColor3 = Color3.new(1, 1, 1)
status.BackgroundTransparency = 1
status.TextSize = 10
status.Parent = frame

btn.MouseButton1Click:Connect(function()
    ENABLED = not ENABLED
    btn.Text = ENABLED and "LEG+: ON" or "OFF"
    btn.BackgroundColor3 = ENABLED and Color3.new(0, 0.8, 0) or Color3.new(0.8, 0, 0)
end)

-- Rarity check dari AnimalsData
local function getRarity(name)
    for key, data in pairs(AnimalsData) do
        if type(data) == "table" then
            if string.find(name, key) or string.find(name, data.DisplayName or "") then
                return data.Rarity, RV[data.Rarity] or 0
            end
        end
    end
    return "?", 0
end

-- LOGIC FARM (SAMA PERSIS DENGAN working_walk_simple.lua)
local function farm()
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    
    -- Anti-AFK
    if tick() - lastAFK > AFKi then
        hum.Jump = true
        pcall(function() if Ping then Ping:FireServer(math.random(400,600), tick()) end end)
        lastAFK = tick()
        AFKi = math.random(30, 60)
    end
    
    local box = workspace:FindFirstChild("RenderedMovingAnimals")
    if not box then return end
    
    local best = nil
    local bestPos = nil
    local bestDist = 200
    local bestName = ""
    local bestRarity = ""
    
    for _, m in pairs(box:GetChildren()) do
        if m:IsA("Model") then
            local rarityName, rarityVal = getRarity(m.Name)
            if rarityVal >= MIN_RARITY then
                local pos = nil
                if m.PrimaryPart then pos = m.PrimaryPart.Position end
                if not pos then
                    local r = m:FindFirstChild("RootPart") or m:FindFirstChildOfClass("BasePart")
                    if r then pos = r.Position end
                end
                
                if pos then
                    local d = (hrp.Position - pos).Magnitude
                    if d < bestDist then
                        bestDist = d
                        best = m
                        bestPos = pos
                        bestName = m.Name
                        bestRarity = rarityName
                    end
                end
            end
        end
    end
    
    if bestPos then
        status.Text = "["..bestRarity.."] "..string.sub(bestName, 1, 8)
        
        -- Jalan ke target
        hum:MoveTo(bestPos)
        
        -- Kalau dekat (<6 stud), berhenti dan HOLD E (LOGIC ASLI)
        if bestDist < 6 then
            hum:MoveTo(hrp.Position) -- Stop
            status.Text = "BUY.."
            
            -- Hold E (SAMA PERSIS)
            VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(HOLD_DURATION)
            VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            
            task.wait(0.5) -- Delay abis beli
            
            -- Webhook kalau berhasil (target hilang)
            if not best or not best.Parent then
                status.Text = "OK!"
                sendWH("Bought: "..bestName.." ["..bestRarity.."]")
            end
        end
    else
        status.Text = "Scanning..."
        lastWH = "" -- Reset dedup
    end
end

spawn(function()
    while true do
        task.wait(0.1)
        if ENABLED then
            pcall(farm)
        end
    end
end)

sendWH("Script started!")
