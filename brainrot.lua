local BrainrotAlerts = {
    OG = true,
    Dragon = true,
    Secret = true,
    HighTier = false
}

local function NotifyBrainrot(category, playerName, brainrotName)
    if not BrainrotAlerts[category] then
        return
    end

    print(string.format(
        "[Brainrot Alert] %s: %s (%s)",
        playerName,
        brainrotName,
        category
    ))
end

-- Example alert, using sample data:
NotifyBrainrot("OG", "ExamplePlayer", "Example OG")

-- Change filters whenever you want:
BrainrotAlerts.OG = true
BrainrotAlerts.Dragon = true
BrainrotAlerts.Secret = true
BrainrotAlerts.HighTier = true
