local P,V,FS,RS=game:GetService("Players"),game:GetService("VirtualInputManager"),game:GetService("PathfindingService"),game:GetService("ReplicatedStorage")
local UIS=game:GetService("UserInputService")
local L,G,ON,HD=P.LocalPlayer,P.LocalPlayer:WaitForChild("PlayerGui"),true,1.5
local AnimalsData=require(RS:WaitForChild("Datas"):WaitForChild("Animals"))
local RV={["Secret"]=10,["OG"]=9,["Brainrot God"]=8,Mythic=7,Legendary=6,Epic=5,Rare=4,Common=3}
local MIN,lastAFK,AFKi=6,tick(),math.random(20,45)
local Ping;pcall(function() Ping=RS:WaitForChild("UserGenerated",2):WaitForChild("Analytics",2):WaitForChild("ClientKit",2):WaitForChild("Ping",2) end)
pcall(function() if G:FindFirstChild("R") then G.R:Destroy() end end)
local S,F,B,TL=Instance.new("ScreenGui"),Instance.new("Frame"),Instance.new("TextButton"),Instance.new("TextLabel")
S.Name="R";S.Parent=G;F.Parent=S;F.Size=UDim2.new(0,150,0,50);F.Position=UDim2.new(0,50,0.4,0);F.Active=true;F.Draggable=true;F.BackgroundColor3=Color3.new(0,0,0)
B.Parent=F;B.Size=UDim2.new(1,-10,0,30);B.Position=UDim2.new(0,5,0,5);B.Text="LEG+: ON";B.BackgroundColor3=Color3.new(0,0.8,0);B.TextColor3=Color3.new(1,1,1)
TL.Parent=F;TL.Size=UDim2.new(1,-10,0,12);TL.Position=UDim2.new(0,5,0,36);TL.Text="OK";TL.TextColor3=Color3.new(1,1,1);TL.BackgroundTransparency=1;TL.TextSize=10
B.MouseButton1Click:Connect(function() ON=not ON;B.Text=ON and "LEG+: ON" or "OFF";B.BackgroundColor3=ON and Color3.new(0,0.8,0) or Color3.new(0.5,0,0) end)
local LP,SC,IG=Vector3.new(),0,{}
local function gR(n) for k,d in pairs(AnimalsData) do if type(d)=="table" and (n:find(k) or n:find(d.DisplayName or "")) then return d.Rarity,RV[d.Rarity] or 0 end end return "?",0 end
local function antiAFK(H,R)
    local actions={
        function() H.Jump=true end,
        function() pcall(function() if Ping then Ping:FireServer(math.random(400,600),tick()) end end) end,
        function() V:SendKeyEvent(true,Enum.KeyCode.W,false,game);wait(0.1+math.random()*0.2);V:SendKeyEvent(false,Enum.KeyCode.W,false,game) end,
        function() V:SendMouseButtonEvent(math.random(100,500),math.random(100,300),1,true,game,1);wait(0.05);V:SendMouseButtonEvent(0,0,1,false,game,1) end,
        function() local cam=workspace.CurrentCamera;if cam then cam.CFrame=cam.CFrame*CFrame.Angles(0,math.rad(math.random(-15,15)),0) end end
    }
    for i=1,math.random(2,3) do actions[math.random(#actions)]();wait(math.random()*0.3) end
end
spawn(function() while wait(0.1) do if ON then pcall(function()
local C=L.Character;if not C then return end;local H,R=C:FindFirstChild("Humanoid"),C:FindFirstChild("HumanoidRootPart");if not H or not R then return end
if tick()-lastAFK>AFKi then antiAFK(H,R);lastAFK=tick();AFKi=math.random(20,45) end
local BX=workspace:FindFirstChild("RenderedMovingAnimals");if not BX then return end;local BT,BP,BD,BR,BN,BRN=nil,nil,999,0,"",""
for m,t in pairs(IG) do if tick()-t>10 then IG[m]=nil end end
for _,v in pairs(BX:GetChildren()) do if v:IsA("Model") and not IG[v] then local rn,rv=gR(v.Name);if rv>=MIN then local Pos=v.PrimaryPart and v.PrimaryPart.Position or v:FindFirstChild("RootPart") and v.RootPart.Position;if Pos then local D=(R.Position-Pos).Magnitude;if rv>BR or (rv==BR and D<BD) then BD=D;BR=rv;BT=v;BP=Pos;BN=v.Name;BRN=rn end end end end end
if BP then TL.Text="["..BRN.."]"..BN:sub(1,6);local MV=(R.Position-LP).Magnitude;LP=R.Position;if MV<0.2 then SC=SC+1 else SC=0 end
if SC>8 then H.Jump=true;H:MoveTo(R.Position+R.CFrame.RightVector*math.random(-10,10));SC=0;wait(0.3);return else H:MoveTo(BP) end
if BD<5 then TL.Text="BUY..";V:SendKeyEvent(true,Enum.KeyCode.E,false,game);for i=1,20 do if not BT or not BT.Parent then break end;local np=BT.PrimaryPart and BT.PrimaryPart.Position or BP;H:MoveTo(np);wait(0.1) end;V:SendKeyEvent(false,Enum.KeyCode.E,false,game);IG[BT]=tick();if not BT or not BT.Parent then TL.Text="OK!" else TL.Text="MISS" end;wait(0.2);return end
else TL.Text="...";SC=0 end end) end end end)
