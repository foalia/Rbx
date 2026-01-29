-- WEBHOOK DUMPER V3: SECRET FOCUS + SPLIT MESSAGES
local WEBHOOK_URL = "https://discord.com/api/webhooks/1466006066092441775/8DsnvmDiEUFr3wCq0hb2cgOSrSoZs9-EaLDF128AGBgCNhvVRACFJnZVnjZRJ_Ce06Xx"

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AnimalsModule = ReplicatedStorage:WaitForChild("Datas"):WaitForChild("Animals")
local brainrots = require(AnimalsModule)

local function sendToWebhook(content)
    local ok, err = pcall(function()
        local data = {content = content, username = "Brainrot Dumper V3"}
        local body = HttpService:JSONEncode(data)
        if request then
            request({Url=WEBHOOK_URL, Method="POST", Headers={["Content-Type"]="application/json"}, Body=body})
        elseif syn and syn.request then
            syn.request({Url=WEBHOOK_URL, Method="POST", Headers={["Content-Type"]="application/json"}, Body=body})
        elseif http_request then
            http_request({Url=WEBHOOK_URL, Method="POST", Headers={["Content-Type"]="application/json"}, Body=body})
        elseif fluxus and fluxus.request then
            fluxus.request({Url=WEBHOOK_URL, Method="POST", Headers={["Content-Type"]="application/json"}, Body=body})
        end
    end)
    if not ok then print("Webhook Error: " .. tostring(err)) end
end

print("==================== BRAINROT DUMPER V3 ====================")
sendToWebhook("**🔴 STARTING SECRET DUMP...**")

if brainrots then
    local byRarity = {}
    
    for name, data in pairs(brainrots) do
        if type(data) == "table" then
            local rarity = data.Rarity or "Unknown"
            if not byRarity[rarity] then byRarity[rarity] = {} end
            table.insert(byRarity[rarity], {
                name = name, 
                price = data.Price or 0, 
                display = data.DisplayName or name
            })
        end
    end
    
    -- SECRET FIRST
    local secretList = byRarity["Secret"]
    if secretList and #secretList > 0 then
        table.sort(secretList, function(a,b) return a.price > b.price end)
        
        sendToWebhook("**=== SECRET (" .. #secretList .. " ITEMS) ===**")
        wait(1)
        
        -- SPLIT INTO CHUNKS OF 10
        local chunk = ""
        local count = 0
        for i, item in ipairs(secretList) do
            chunk = chunk .. item.display .. " | $" .. item.price .. "\n"
            count = count + 1
            
            if count >= 10 or i == #secretList then
                sendToWebhook("```\n" .. chunk .. "```")
                chunk = ""
                count = 0
                wait(1.5)
            end
        end
    else
        sendToWebhook("**NO SECRET FOUND IN DATABASE!**")
    end
    
    sendToWebhook("**✅ SECRET DUMP COMPLETE!**")
end

print("==================== DUMP DONE ====================")
