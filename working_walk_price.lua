local P,V,FS=game:GetService("Players"),game:GetService("VirtualInputManager"),game:GetService("PathfindingService")
local L,G=P.LocalPlayer,P.LocalPlayer:WaitForChild("PlayerGui")
local ON,HD=true,1

-- CONFIG: PRICE >= 1000
local MIN_PRICE = 1000 

-- IGNORE SYSTEM (Blacklist logic)
local IGNORED = {} 

-- DATABASE HARGA (Manual Update)
local D={
-- RARE (Mahal)
["Trippi"]=2000, ["Ta Ta Ta"]=7500, ["Gangster"]=4000, ["Bambini"]=1200, ["Talpa"]=1500, ["Cacto"]=6500,
-- COMMON (Yg > 1k kalo ada)
["Pipi Kiwi"]=1500, 
-- EPIC+
["Cappuccino"]=10000, ["Patapim"]=15000, ["Trulimero"]=20000, ["Bananita"]=25000, ["Salamino"]=40000, ["Ti Ti Ti"]=37500,
["Chimpanzini"]=50000, ["Ballerina"]=100000, ["Sigma"]=325000,
["Bombardiro"]=500000, ["Bombombini"]=1000000, ["Cavallo"]=2500000, ["Te Te Te"]=4000000,
["Tralalero"]=10000000, ["Odin"]=15000000
}

pcall(function() if G:FindFirstChild("PRICE_V2") then G.PRICE_V2:Destroy() end end)
local S,F,B,TL=Instance.new("ScreenGui"),Instance.new("Frame"),Instance.new("TextButton"),Instance.new("TextLabel")
S.Name="PRICE_V2";S.Parent=G;F.Parent=S;F.Size=UDim2.new(0,140,0,50);F.Position=UDim2.new(0,50,0.4,0);F.Active=true;F.Draggable=true;F.BackgroundColor3=Color3.fromRGB(0,50,0)
B.Parent=F;B.Size=UDim2.new(1,-10,0,25);B.Position=UDim2.new(0,5,0,5);B.Text="PRICE > 1K: ON";B.BackgroundColor3=Color3.new(0,1,0)
TL.Parent=F;TL.Size=UDim2.new(1,-10,0,15);TL.Position=UDim2.new(0,5,0,32);TL.Text="Scan...";TL.TextColor3=Color3.new(1,1,1);TL.BackgroundTransparency=1;TL.TextSize=10
B.Activated:Connect(function() ON=not ON;B.Text=ON and "PRICE > 1K: ON" or "OFF";B.BackgroundColor3=ON and Color3.new(0,1,0) or Color3.new(1,0,0) end)

local LP,SC,IT=Vector3.new(),0,0
spawn(function()
 while wait(0.1) do
  if ON then
   pcall(function()
    local C=L.Character;if not C then return end
    local H,R=C:FindFirstChild("Humanoid"),C:FindFirstChild("HumanoidRootPart")
    if not H or not R then return end
    local BX=workspace:FindFirstChild("RenderedMovingAnimals")
    if not BX then return end
    local BT,BP,BD,BN=nil,nil,999,""
    
    -- CLEANUP
    for m,t in pairs(IGNORED) do if tick()-t > 15 then IGNORED[m]=nil end end
    
    for _,v in pairs(BX:GetChildren()) do
     if v:IsA("Model") and not IGNORED[v] then
      for k,price in pairs(D) do
       if string.find(v.Name,k) then
        -- LOGIC
        if price >= MIN_PRICE then
         local P=v.PrimaryPart and v.PrimaryPart.Position or (v:FindFirstChild("RootPart") and v.RootPart.Position)
         if P then local Dist=(R.Position-P).Magnitude;if Dist<BD then BD=Dist;BT=v;BP=P;BN=v.Name end end
        end
        break
       end
      end
     end
    end
    
    if BP then
     TL.Text="$"..D[string.match(BN,"(%a+)") or ""].." | "..string.sub(BN,1,5)
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
      if BT then IGNORED[BT]=tick() end; TL.Text="Bought->Next"; wait(0.2)
     else IT=0 end
    else TL.Text="Scanning...";SC=0;IT=0 end
   end)
  end
 end
end)
