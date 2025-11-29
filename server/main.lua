RegisterNetEvent('old_snowBall:giveSnowBall', function()
    local src = source
    exports.ox_inventory:AddItem(src, 'WEAPON_SNOWBALL', 1)
end)
