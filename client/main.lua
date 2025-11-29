function pickUpSnowBall()
    local ped = PlayerPedId()
    local isInInterior = GetInteriorFromEntity(ped)
    if isInInterior == 0 then
        if lib.progressActive() then
            return lib.notify({
                title = 'OldSnowBall',
                description = 'Stop spam !',
                type = 'error'
            })
        end
        if lib.progressCircle({
                duration = 2000,
                position = 'center',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                    move = true,
                    combat = true
                },
                anim = {
                    dict = 'missheist_agency2aig_13',
                    clip = 'pickup_briefcase',
                    bone = 75
                },

            })
        then
            TriggerServerEvent('old_snowBall:giveSnowBall')
        else
            return
        end
    else
        lib.notify({
            title = 'OldSnowBall',
            description = 'Vous ne pouvez pas ramasser une boule de neige en intérieur',
            type = 'error'
        })
    end
end

RegisterCommand("snowball", function(source, args)
    pickUpSnowBall()
end, false)
