local Target = exports.ox_target
local Input = lib.inputDialog
local Zone = lib.zones

local inJob = false

local function CreateZones(locationRandom, truck)
    local function StoreonEnter()
        local hasBox = false
        local truckOptions = {{
            name = 'ox:option1',
            icon = 'fa-solid fa-truck-ramp-box',
            label = 'Grab Box',
            bones = {'door_dside_r'},
            onSelect = function()
                print('Grab Box')
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
end 

local function GetDropOff(truck)
    local locationRandom = math.random(1, #Config.DropOff.Location)
    local locationBlip = AddBlipForCoord(Config.DropOff.Location[locationRandom])
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
                        local truck = CreateVehicle(GetHashKey('boxville2'), Config.Truck.Location, Config.Truck.Heading, true, false)
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