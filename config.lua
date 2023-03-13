Config = {}

Config.NPC = {
    Location = vec3(68.888, 127.169, 78.205),
    Heading = (158.59)
}

Config.Truck = {
    Location = vec3(71.804, 120.588, 79.078),
    Heading = (160.583)
}

Config.DropOff = {
    Location = {
        vec3(376.299, 322.467, 103.437),
        vec3(1159.387, -325.542, 69.205),
        vec3(29.109, -1348.248, 29.496),
        vec3(-52.216, -1755.597, 29.421),
        vec3(-1226.046, -903.225, 12.338),
        vec3(-1490.124, -382.535, 40.175)
    },
    TargetPoint = {
        vec3(375.514, 334.839, 103.566),
        vec3(1163.135, -313.367, 69.205),
        vec3(25.356, -1339.491, 29.497),
        vec3(-40.682, -1750.848, 29.421),
        vec3(-1222.817, -912.563, 12.326),
        vec3(-1481.55, -377.794, 40.163)
    },
    BoxesMin = 3,
    BoxesMax = 5,
}

Config.Reward = {
    Reward = 'money',
    AmountMin = 1500,
    AmountMax = 3000,
}

Config.Notification = {
    InJob = {
        title = 'Trucking',
        description = 'You already have a job',
        type = 'error',
        position = 'top-right',
    },
    HasBox = {
        title = 'Trucking',
        description = 'You already have a box',
        type = 'error',
        position = 'top-right',
    },
    NoBox = {
        title = 'Trucking',
        description = 'You don\'t have a box',
        type = 'error',
        position = 'top-right',
    },
    ReturnTruck = {
        title = 'Trucking',
        description = 'Return the truck',
        type = 'success',
        position = 'top-right'
    },
    CompletedJob = {
        title = 'Trucking',
        description = 'You have completed the job',
        type = 'success',
        position = 'top-right'
    }
}