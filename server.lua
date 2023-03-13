local Inventory = exports.ox_inventory

RegisterNetEvent('dom_trucking:Reward', function()
    local random = math.random(Config.Reward.AmountMin, Config.Reward.AmountMax)
    Inventory:AddItem(source, Config.Reward.Reward, random)
end)
