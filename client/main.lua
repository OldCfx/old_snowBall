local showTextUi = false

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
                duration = Config.timeToPickUp,
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

function snowMan()
    local success = lib.callback.await('old_snowBall:getItemCount', false)
    if success then
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
                    duration = Config.timeToMakeSnowMan,
                    position = 'center',
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        car = true,
                        move = true,
                        combat = true
                    },
                    anim = {
                        dict = 'amb@medic@standing@tendtodead@idle_a',
                        clip = 'idle_a',
                        bone = 76,
                        flag = 1
                    },

                })
            then
                local coords = GetEntityCoords(ped)
                local modelHash = `xm3_prop_xm3_snowman_01b`
                if not HasModelLoaded(modelHash) then
                    RequestModel(modelHash)

                    while not HasModelLoaded(modelHash) do
                        Citizen.Wait(1)
                    end
                end
                local snowMan = CreateObject(modelHash, coords, true, true, true)
                SetEntityHeading(snowMan, GetEntityHeading(ped) - 180.0)
                PlaceObjectOnGroundProperly(snowMan)
                FreezeEntityPosition(snowMan, true)
            else
                return
            end
        else
            lib.notify({
                title = 'OldSnowBall',
                description = 'Vous ne pouvez pas faire un bonhomme de neige en interieur',
                type = 'error'
            })
        end
    else
        lib.notify({
            title = 'OldSnowBall',
            description = 'Il vous faut minimum ' ..
                tostring(Config.needSnowBall) .. ' boules de neige pour faire un bonhomme de neige',
            type = 'error'
        })
    end
end

CreateThread(function()
    while true do
        Wait(0)

        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)


        local interactionDist = 1.0


        local modelHash = `xm3_prop_xm3_snowman_01b`
        local obj = GetClosestObjectOfType(coords, interactionDist, modelHash, false, false, false)

        if obj ~= 0 then
            if not showTextUi then
                showTextUi = true
                lib.showTextUI('E pour détruire le bonhomme de neige')
            end
            if IsControlJustPressed(0, 38) then
                if lib.progressCircle({
                        duration = Config.timeToDestroySnowMan,
                        position = 'center',
                        useWhileDead = false,
                        canCancel = true,
                        disable = {
                            car = true,
                            move = true,
                            combat = true
                        },
                        anim = {
                            dict = 'melee@unarmed@streamed_core',
                            clip = 'ground_attack_-90',
                            bone = 76,
                            flag = 1
                        },

                    })
                then
                    showTextUi = false
                    lib.hideTextUI()

                    local fxDict = "core_snow"
                    local fxName = "bang_snow"


                    if not HasNamedPtfxAssetLoaded(fxDict) then
                        RequestNamedPtfxAsset(fxDict)
                        while not HasNamedPtfxAssetLoaded(fxDict) do
                            Wait(1)
                        end
                    end

                    UseParticleFxAsset(fxDict)


                    local objCoords = GetEntityCoords(obj)
                    StartParticleFxNonLoopedAtCoord(fxName, objCoords.x, objCoords.y, objCoords.z + 1.0,
                        0.0, 0.0, 0.0,
                        1.2, false, false, false)

                    SetEntityAsMissionEntity(obj, true, true)
                    DeleteObject(obj)
                else
                    return
                end
            end
        else
            if showTextUi then
                showTextUi = false
                lib.hideTextUI()
            end
        end
    end
end)


RegisterCommand("snowball", function(source, args)
    pickUpSnowBall()
end, false)

RegisterCommand("snowman", function(source, args)
    snowMan()
end, false)
