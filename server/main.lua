RegisterNetEvent('old_snowBall:giveSnowBall', function()
    local src = source
    exports.ox_inventory:AddItem(src, 'WEAPON_SNOWBALL', 1)
end)


lib.callback.register('old_snowBall:getItemCount', function(source, item)
    local snowBall = exports.ox_inventory:GetItem(source, "WEAPON_SNOWBALL", nil, true)
    if snowBall < Config.needSnowBall then
        return false
    end
    local success = exports.ox_inventory:RemoveItem(source, "WEAPON_SNOWBALL", Config.needSnowBall)
    return true
end)
