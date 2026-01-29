local Players = game:GetService("Players")
local VIM = game:GetService("VirtualInputManager")
local Player = Players.LocalPlayer

local ENABLED = false
local HOLD_DURATION = 1.0 -- Tekan E selama 1 detik (biar pasti ke-buy)

local RARITY = {Common=1, Rare=2, Epic=3, Legendary=4, Mythic=5, ["Brainrot God"]=6}
local MIN_RARITY = 3 -- Epic+

local DATA = {
    ["Noobini Pizzanini"] = "Common", ["Tim Cheese"] = "Common",
    ["Trippi Troppi"] = "Rare", ["Gangster Footera"] = "Rare", ["Bambini Crostini"] = "Rare", ["Talpa Di Fero"] = "Rare",
    ["Cappuccino Assassino"] = "Epic", ["Brr Brr Patapim"] = "Epic", ["Trulimero Trulicina"] = "Epic", ["Bananita Dolphinita"] = "Epic",
    ["Chimpanzini Bananini"] = "Legendary", ["Ballerina Cappuccina"] = "Legendary", ["Sigma Boy"] = "Legendary",
    ["Bombardiro Crocodilo"] = "Mythic", ["Tralalero Tralala"] = "Brainrot God",
}

-- GUI SIMPLE (Pasti muncul)
local gui = Instance.new("ScreenGui")
gui.Name = "WalkerSimple"
gui.ResetOnSpawn = false
gui.Parent = Player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 50)
frame.Position = UDim2.new(0, 50, 0.5, 0)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -10, 1, -10)
btn.Position = UDim2.new(0, 5, 0, 5)
btn.Text = "FARM: OFF"
btn.BackgroundColor3 = Color3.new(0.8, 0, 0)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 20
btn.Parent = frame

btn.MouseButton1Click:Connect(function()
    ENABLED = not ENABLED
    btn.Text = ENABLED and "FARM: ON" or "FARM: OFF"
    btn.BackgroundColor3 = ENABLED and Color3.new(0, 0.8, 0) or Color3.new(0.8, 0, 0)
end)

-- Logic
local function check(name)
    local r = DATA[name]
    if not r then return true end
    return (RARITY[r] or 0) >= MIN_RARITY
end

local function farm()
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    
    local box = workspace:FindFirstChild("RenderedMovingAnimals")
    if not box then return end
    
    local best = nil
    local bestPos = nil
    local bestDist = 200
    
    for _, m in pairs(box:GetChildren()) do
        if m:IsA("Model") and check(m.Name) then
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
                end
            end
        end
    end
    
    if bestPos then
        -- Jalan ke target
        hum:MoveTo(bestPos)
        
        -- Kalau dekat (<6 stud), berhenti dan HOLD E
        if bestDist < 6 then
            hum:MoveTo(hrp.Position) -- Stop
            
            -- Hold E
            mouse1click() -- Click sekali buat focus (optional)
            VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(HOLD_DURATION)
            VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            
            task.wait(0.5) -- Delay dikit abis beli
        end
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
