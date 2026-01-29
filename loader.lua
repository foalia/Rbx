--[[
  BRAINROT LOADER
  Paste this 2-line script into your executor.
  It will fetch the latest version from GitHub.
  
  UPDATE THE URL BELOW WITH YOUR GITHUB RAW URL!
]]

-- === CONFIGURATION ===
-- Replace with your actual GitHub raw URL after creating repo
local SCRIPT_URL = "https://raw.githubusercontent.com/foalia/Rbx/main/working_walk_secret.lua"

-- === LOADER ===
local success, err = pcall(function()
    loadstring(game:HttpGet(SCRIPT_URL .. "?t=" .. os.time()))()
end)

if not success then
    warn("Failed to load script: " .. tostring(err))
    warn("Check if URL is correct and repo is PUBLIC")
end
