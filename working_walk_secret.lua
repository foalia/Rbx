local P,V,FS,RS=game:GetService("Players"),game:GetService("VirtualInputManager"),game:GetService("PathfindingService"),game:GetService("ReplicatedStorage")
local L,G,ON,HD=P.LocalPlayer,P.LocalPlayer:WaitForChild("PlayerGui"),true,1
local AnimalsData=require(RS:WaitForChild("Datas"):WaitForChild("Animals"))
local RV={["Secret"]=10,["OG"]=9,["Brainrot God"]=8,Mythic=7,Legendary=6,Epic=5,Rare=4,Common=3}
local MIN,lastAFK,AFKi=9,tick(),math.random(30,60)
local Ping;pcall(function() Ping=RS:WaitForChild("UserGenerated",2):WaitForChild("Analytics",2):WaitForChild("ClientKit",2):WaitForChild("Ping",2) end)
pcall(function() if G:FindFirstChild("S") then G.S:Destroy() end end)
local S,F,B,TL=Instance.new("ScreenGui"),Instance.new("Frame"),Instance.new("TextButton"),Instance.new("TextLabel")
S.Name="S";S.Parent=G;F.Parent=S;F.Size=UDim2.new(0,150,0,50);F.Position=UDim2.new(0,50,0.4,0);F.Active=true;F.Draggable=true;F.BackgroundColor3=Color3.fromRGB(100,0,150)
B.Parent=F;B.Size=UDim2.new(1,-10,0,30);B.Position=UDim2.new(0,5,0,5);B.Text="SEC: ON";B.BackgroundColor3=Color3.new(1,0,1);B.TextColor3=Color3.new(1,1,1)
TL.Parent=F;TL.Size=UDim2.new(1,-10,0,12);TL.Position=UDim2.new(0,5,0,36);TL.Text="OK";TL.TextColor3=Color3.new(1,1,1);TL.BackgroundTransparency=1;TL.TextSize=10
B.MouseButton1Click:Connect(function() ON=not ON;B.Text=ON and "SEC: ON" or "OFF";B.BackgroundColor3=ON and Color3.new(1,0,1) or Color3.new(0.5,0,0) end)
local IG,LP,SC,IT={},Vector3.new(),0,0
local function gR(n) for k,d in pairs(AnimalsData) do if type(d)=="table" and (n:find(k) or n:find(d.DisplayName or "")) then return d.Rarity,RV[d.Rarity] or 0 end end return "?",0 end
spawn(function() while wait(0.1) do if ON then pcall(function()
local C=L.Character;if not C then return end;local H,R=C:FindFirstChild("Humanoid"),C:FindFirstChild("HumanoidRootPart");if not H or not R then return end
if tick()-lastAFK>AFKi then H.Jump=true;pcall(function() if Ping then Ping:FireServer(math.random(400,600),tick()) end end);lastAFK=tick();AFKi=math.random(30,60) end
local BX=workspace:FindFirstChild("RenderedMovingAnimals");if not BX then return end;local BT,BP,BD,BR,BN,BRN=nil,nil,999,0,"",""
for m,t in pairs(IG) do if tick()-t>15 then IG[m]=nil end end
for _,v in pairs(BX:GetChildren()) do if v:IsA("Model") and not IG[v] then local rn,rv=gR(v.Name);if rv>=MIN then local Pos=v.PrimaryPart and v.PrimaryPart.Position or v:FindFirstChild("RootPart") and v.RootPart.Position;if Pos then local D=(R.Position-Pos).Magnitude;if rv>BR or (rv==BR and D<BD) then BD=D;BR=rv;BT=v;BP=Pos;BN=v.Name;BRN=rn end end end end end
if BP then TL.Text="["..BRN.."]"..BN:sub(1,6);local MV=(R.Position-LP).Magnitude;LP=R.Position;if MV<0.2 then SC=SC+1 else SC=0 end
if SC>6 then pcall(function() local PTH=FS:CreatePath({AgentRadius=4});PTH:ComputeAsync(R.Position,BP);if PTH.Status==Enum.PathStatus.Success then H:MoveTo(PTH:GetWaypoints()[2].Position) else H:MoveTo(R.Position-R.CFrame.LookVector*10) end end);SC=0;return else H:MoveTo(BP) end
if BD<6 then IT=IT+1;if IT>25 then H:MoveTo(R.Position-R.CFrame.LookVector*8);IT=0;wait(0.5);return end;H:MoveTo(R.Position);V:SendKeyEvent(true,Enum.KeyCode.E,false,game);wait(HD);V:SendKeyEvent(false,Enum.KeyCode.E,false,game);if BT then IG[BT]=tick() end;TL.Text="OK!";wait(0.2) else IT=0 end
else TL.Text="...";SC=0;IT=0 end end) end end end)