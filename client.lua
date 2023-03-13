local Target = exports.ox_target
local Input = lib.inputDialog
local Zone = lib.zones

local inJob = false
local completedJob = false

local function CreateZones(locationRandom, truck)
    local function StoreonEnter()
        local hasBox = false
        local boxesDropped = 0
        RemoveBlip(locationBlip)

        local boxesRandom = math.random(Config.DropOff.BoxesMin, Config.DropOff.BoxesMax)

        DropOffZone = Target:addSphereZone({
            coords = Config.DropOff.TargetPoint[locationRandom],
            radius = 1,
            debug = false,
            options = {{
                name = 'ox:option1',
                icon = 'fa-solid fa-truck-ramp-box',
                label = 'Dropoff Box',
                onSelect = function()
                    if hasBox then 
                        DeleteEntity(prop)
                        ClearPedTasks(PlayerPedId())
                        boxesDropped = boxesDropped + 1
                        hasBox = false

                        lib.notify({
                            title = 'Trucking',
                            description = ('Boxes dropped off: '..boxesDropped..'/'..boxesRandom),
                            type = 'inform',
                            position = 'top-right'
                        })
                    else 
                        lib.notify(Config.Notification.NoBox)
                    end 

                    if boxesDropped == boxesRandom then 
                        TriggerEvent('dom_trucking:removeStoreZones')
                        lib.notify(Config.Notification.ReturnTruck)
                    end 
                end 
            }}
        })

        local truckOptions = {{
            name = 'ox:option1',
            icon = 'fa-solid fa-truck-ramp-box',
            label = 'Grab Box',
            bones = {'door_dside_r'},
            onSelect = function()
                if not hasBox then 
                    RequestAnimDict('anim@heists@box_carry@')
                    while not HasAnimDictLoaded('anim@heists@box_carry@') do 
                        Wait(500)
                    end 
                    TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 2.0, 2.5, -1, 49, 0, 0, 0, 0)

                    RequestModel('prop_cs_cardbox_01')
                    while not HasModelLoaded('prop_cs_cardbox_01') do 
                        Wait(500)
                    end
                    prop = CreateObject(GetHashKey('prop_cs_cardbox_01'), x, y, z, true, true, true)
                    AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0x60F2), -0.1, 0.4, 0, 0, 90.0, 0, true, true, false, true, 5, true)
                    hasBox = true
                else 
                    lib.notify(Config.Notification.HasBox)
                end 
            end 
        }}
        Target:addLocalEntity(truck, truckOptions)

        TriggerEvent('dom_trucking:removeZone')
    end 

    local Storebox = Zone.box({
        coords = Config.DropOff.Location[locationRandom],
        size = vec3(15, 25, 10),
        rotation = -20,
        debug = false,
        onEnter = StoreonEnter,
    })

    RegisterNetEvent('dom_trucking:removeZone', function()
        Storebox:remove()
    end)

    RegisterNetEvent('dom_trucking:removeStoreZones', function()
        Target:removeZone(DropOffZone)
        Target:removeLocalEntity(truck, truckOptions)
        completedJob = true

        npcBlip = AddBlipForCoord(68.888, 127.169, 78.205)
        SetBlipColour(npcBlip, 3)
        SetBlipHiddenOnLegend(npcBlip, true)
        SetBlipRoute(npcBlip, true)
        SetBlipDisplay(npcBlip, 8)
        SetBlipRouteColour(npcBlip, 3)
    end)
end 

local function GetDropOff(truck)
    local locationRandom = math.random(1, #Config.DropOff.Location)
    locationBlip = AddBlipForCoord(Config.DropOff.Location[locationRandom])
        SetBlipColour(locationBlip, 3)
        SetBlipHiddenOnLegend(locationBlip, true)
        SetBlipRoute(locationBlip, true)
        SetBlipDisplay(locationBlip, 8)
        SetBlipRouteColour(locationBlip, 3)
    CreateZones(locationRandom, truck)
end 

local function NPConEnter()
    if lib.requestModel('s_m_m_postal_02', 1000) then 
        npc = CreatePed(1, GetHashKey('s_m_m_postal_02'), Config.NPC.Location, Config.NPC.Heading, false, false)
        FreezeEntityPosition(npc, true)
        SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)

        local options = {{
            name = 'ox:option1',
            icon = 'fa-solid fa-car',
            label = 'Get a job',
            onSelect = function()
                if not inJob then 
                    if lib.requestModel('boxville2', 1000) then 
                        inJob = true
                        truck = CreateVehicle(GetHashKey('boxville2'), Config.Truck.Location, Config.Truck.Heading, true, false)
                        GetDropOff(truck)
                    else 
                        print('Couldn\'t load vehicle')
                    end 
                else 
                    lib.notify(Config.Notification.InJob)
                end 
            end 
        }}
        Target:addLocalEntity(npc, options)
    else 
        print('Couldn\'t load npc')
    end 

    if inJob and completedJob then 
        local finishOptions = {{
            name = 'ox:option1',
            icon = 'fa-solid fa-car',
            label = 'Return Truck',
            onSelect = function()
                DeleteEntity(truck)
                RemoveBlip(npcBlip)
                TriggerServerEvent('dom_trucking:Reward')
                lib.notify(Config.Notification.CompletedJob)
                inJob = false
                completedJob = false
            end 
        }}
        Target:addLocalEntity(truck, finishOptions)
    end 
end 

local function NPConExit()
    DeleteEntity(npc)
end

local NPCbox = Zone.box({
    coords = vec3(65.692, 117.731, 79.159),
    size = vec3(20, 25, 10),
    rotation = -20,
    debug = false,
    onEnter = NPConEnter,
    onExit = NPConExit
})