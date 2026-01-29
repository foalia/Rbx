local P,V,FS=game:GetService("Players"),game:GetService("VirtualInputManager"),game:GetService("PathfindingService")
local RS=game:GetService("ReplicatedStorage")
local L,G=P.LocalPlayer,P.LocalPlayer:WaitForChild("PlayerGui")
local ON,HD=true,1

-- LOAD GAME DATABASE
local AnimalsData = require(RS:WaitForChild("Datas"):WaitForChild("Animals"))

-- RARITY PRIORITY
local RARITY_VALUE = {
    ["Secret"] = 10,
    ["OG"] = 9,
    ["Brainrot God"] = 8,
    ["Mythic"] = 7,
    ["Legendary"] = 6,
    ["Epic"] = 5,
    ["Rare"] = 4,
    ["Common"] = 3
}

-- CONFIG: Secret + OG only (9 and above)
local MIN_RARITY = 9

-- ANTI-AFK CONFIG
local lastAntiAFK = tick()
local ANTI_AFK_INTERVAL = math.random(30, 60)

pcall(function() if G:FindFirstChild("SECRET") then G.SECRET:Destroy() end end)
local S,F,B,TL=Instance.new("ScreenGui"),Instance.new("Frame"),Instance.new("TextButton"),Instance.new("TextLabel")
S.Name="SECRET";S.Parent=G;F.Parent=S;F.Size=UDim2.new(0,160,0,55);F.Position=UDim2.new(0,50,0.4,0);F.Active=true;F.Draggable=true;F.BackgroundColor3=Color3.fromRGB(150,0,200)
B.Parent=F;B.Size=UDim2.new(1,-10,0,28);B.Position=UDim2.new(0,5,0,5);B.Text="SECRET HUNT: ON";B.BackgroundColor3=Color3.new(1,0,1);B.TextColor3=Color3.new(1,1,1)
TL.Parent=F;TL.Size=UDim2.new(1,-10,0,15);TL.Position=UDim2.new(0,5,0,35);TL.Text="Ready";TL.TextColor3=Color3.new(1,1,1);TL.BackgroundTransparency=1;TL.TextSize=10
B.Activated:Connect(function() ON=not ON;B.Text=ON and "SECRET HUNT: ON" or "OFF";B.BackgroundColor3=ON and Color3.new(1,0,1) or Color3.new(0.5,0,0) end)

local IGNORED={}
local LP,SC,IT=Vector3.new(),0,0

local function getRarity(name)
    for key, data in pairs(AnimalsData) do
        if type(data) == "table" then
            if string.find(name, key) or string.find(name, data.DisplayName or "") then
                return data.Rarity, RARITY_VALUE[data.Rarity] or 0
            end
        end
    end
    return "Unknown", 0
end

-- ANTI-AFK FUNCTION
local function doAntiAFK(H, R)
    if tick() - lastAntiAFK > ANTI_AFK_INTERVAL then
        -- Random jump
        if H then H.Jump = true end
        
        -- Random small movement
        if R then
            local randomOffset = Vector3.new(math.random(-3,3), 0, math.random(-3,3))
            H:MoveTo(R.Position + randomOffset)
        end
        
        -- Random camera rotation
        pcall(function()
            local cam = workspace.CurrentCamera
            cam.CFrame = cam.CFrame * CFrame.Angles(0, math.rad(math.random(-45, 45)), 0)
        end)
        
        -- Reset timer
        lastAntiAFK = tick()
        ANTI_AFK_INTERVAL = math.random(30, 60)
        TL.Text = "Anti-AFK!"
    end
end

spawn(function()
 while wait(0.1) do
  if ON then
   pcall(function()
    local C=L.Character;if not C then return end
    local H,R=C:FindFirstChild("Humanoid"),C:FindFirstChild("HumanoidRootPart")
    if not H or not R then return end
    
    -- ANTI-AFK CHECK
    doAntiAFK(H, R)
    
    local BX=workspace:FindFirstChild("RenderedMovingAnimals")
    if not BX then return end
    local BT,BP,BD,BR,BN,BRN=nil,nil,999,0,"",""
    
    for m,t in pairs(IGNORED) do if tick()-t>15 then IGNORED[m]=nil end end
    
    for _,v in pairs(BX:GetChildren()) do
     if v:IsA("Model") and not IGNORED[v] then
      local rarityName, rarityVal = getRarity(v.Name)
      if rarityVal >= MIN_RARITY then
       local Pos=v.PrimaryPart and v.PrimaryPart.Position or (v:FindFirstChild("RootPart") and v.RootPart.Position)
       if Pos then 
        local Dist=(R.Position-Pos).Magnitude
        if rarityVal > BR or (rarityVal == BR and Dist < BD) then
         BD=Dist;BR=rarityVal;BT=v;BP=Pos;BN=v.Name;BRN=rarityName
        end
       end
      end
     end
    end
    
    if BP then
     TL.Text="["..BRN.."] "..string.sub(BN,1,8)
     local MV=(R.Position-LP).Magnitude;LP=R.Position
     if MV<0.2 then SC=SC+1 else SC=0 end
     if SC>6 then
      local PTH=FS:CreatePath({AgentRadius=4,AgentCanJump=false})
      pcall(function() 
       PTH:ComputeAsync(R.Position,BP)
       if PTH.Status==Enum.PathStatus.Success then H:MoveTo(PTH:GetWaypoints()[2].Position) 
       else H:MoveTo(R.Position+Vector3.new(math.random(-15,15),0,math.random(-15,15))) end 
      end)
      SC=0;return
     else H:MoveTo(BP) end
     if BD<6 then
      IT=IT+1
      if IT>25 then R.CFrame=R.CFrame*CFrame.new(math.random(-5,5),2,math.random(-5,5));IT=0;return end
      H:MoveTo(R.Position);V:SendKeyEvent(true,Enum.KeyCode.E,false,game);wait(HD);V:SendKeyEvent(false,Enum.KeyCode.E,false,game)
      if BT then IGNORED[BT]=tick() end;TL.Text="Bought!";wait(0.2)
     else IT=0 end
    else TL.Text="Scanning...";SC=0;IT=0 end
   end)
  end
 end
end)

print("Secret/OG Hunter v2.0 with Anti-AFK loaded!")