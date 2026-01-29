--[[
  STEAL A BRAINROT LOADER
  
  Available scripts:
  - rarity      : Legendary+ (without webhook)
  - rarity_wh   : Legendary+ (with Discord webhook)
  - secret      : Secret/OG only (without webhook)
  - secret_wh   : Secret/OG only (with Discord webhook)
  
  Usage: Change SCRIPT_TYPE below
]]

local SCRIPT_TYPE = "rarity" -- Options: "rarity", "rarity_wh", "secret", "secret_wh"

local URLS = {
    rarity = "https://raw.githubusercontent.com/foalia/Rbx/main/working_walk_rarity.lua",
    rarity_wh = "https://raw.githubusercontent.com/foalia/Rbx/main/working_walk_rarity_webhook.lua",
    secret = "https://raw.githubusercontent.com/foalia/Rbx/main/working_walk_secret.lua",
    secret_wh = "https://raw.githubusercontent.com/foalia/Rbx/main/working_walk_secret_webhook.lua"
}

loadstring(game:HttpGet(URLS[SCRIPT_TYPE] .. "?t=" .. os.time()))()
