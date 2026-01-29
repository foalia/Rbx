# Brainrot Scripts

Auto-farm scripts for Steal A Brainrot game.

## Scripts Available

| Script | Description |
|--------|-------------|
| `working_walk_secret.lua` | Targets SECRET + OG rarity only (highest priority) |
| `working_walk_rarity.lua` | Targets Legendary+ (Legendary, Mythic, God, OG, Secret) |
| `working_walk_price.lua` | Targets by price (> $1000) |
| `working_walk_simple.lua` | Basic auto-farm (all rarities) |
| `webhook_dump.lua` | Utility: dumps all brainrot data to Discord |

## How to Use

### Quick Start (Paste into executor):
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/brainrot-scripts/main/working_walk_secret.lua"))()
```

### With Cache Bypass:
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/brainrot-scripts/main/working_walk_secret.lua?t=" .. os.time()))()
```

## Update Instructions

1. Edit the script file on GitHub
2. Commit changes
3. All accounts will get the new version automatically

## Files

- `loader.lua` - Template loader script
- `brainrot_database.lua` - Reference data (156 Secret, 3 OG items)
