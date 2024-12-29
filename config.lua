Config = {}

-- Cash reward
Config.EasyPayment = 1000
Config.MediumPayment = 5000
Config.HardPayment = 10000

Config.PoliceCallChance = 100

-- Mission cooldowns can be adjusted in script.js

-- Ped location who gives a mission (can be multiply)
Config.Peds = {
    locations = {
        {x = 693.94, y = -728.67, z = 25.31, h = 5.48, ["hash"] = "a_m_m_og_boss_01"},

    }
}


-- Vehicle spawn zones and specific locations
Config.Zones = {
    {
        center = {x = 363.83, y = 282.85, z = 103.36},
        radius = 300.0, 
        spawns = {
            {x = 470.19, y = 245.33, z = 103.21}, 
            {x = 350.25, y = 270.45, z = 102.8},
            {x = 369.11, y = 358.5, z = 102.86},
            {x = 357.88, y = 283.34, z = 103.42},
        }
    },
    {
        center = {x = -1300.5, y = 265.67, z = 63.58},
        radius = 300.0,
        spawns = {
            {x = -1290.5, y = 260.3, z = 63.5}, 
            {x = -1199.54, y = 325.21, z = 70.81},
            {x = -1098.36, y = 368.02, z = 68.77},
        }
    }, 
    {
        center = {x = 1375.12, y = -732.49, z = 67.21},
        radius = 300.0,
        spawns = {
            {x = 1082.98, y = -793.95, z = 58.28},
            {x = 1365.72, y = -584.31, z = 74.38}, 
            {x = 1365.0, y = -750.0, z = 66.8},
        }
    }, 
    {
        center = {x = -385.03, y = -80.76, z = 54.43},
        radius = 150.0,
        spawns = {
            {x = -385.03, y = -80.76, z = 54.43},
            {x = -352.02, y = -90.07, z = 45.66}, 
        }
    }, 
    {
        center = {x = -2028.07, y = -360.08, z = 48.11},
        radius = 150.0,
        spawns = {
            {x = -2028.07, y = -360.08, z = 48.11},
        }
    }, 
    {
        center = {x = -1200.75, y = -2052.91, z = 13.92},
        radius = 300.0,
        spawns = {
            {x = -1200.75, y = -2052.91, z = 13.92},
            {x = -948.49, y = -2019.04, z = 9.51},

        }
    }, 
    {
        center = {x = -152.91, y = -2679.61, z = 6.01},
        radius = 300.0,
        spawns = {
            {x = -152.91, y = -2679.61, z = 6.01},
            {x = -118.33, y = -2702.59, z = 6.01},
            {x = -296.69, y = -2712.83, z = 6.0},

        }
    }, 
}


Config.MilitaryZones = {
    {
        center = {x = 488.62, y = -3147.95, z = 6.07},
        radius = 300.0,
        spawns = {
            {x = 485.81, y = -3298.32, z = 6.07},
            {x = 488.62, y = -3147.95, z = 6.07},
            {x = 607.45, y = -3171.79, z = 6.07},
        }
    },
    {
        center = {x = 2549.32, y = -386.97, z = 92.99},
        radius = 300.0,
        spawns = {
            {x = 2549.32, y = -386.97, z = 92.99},
            {x = 2480.8, y = -319.68, z = 92.99},
        }
    },
}


-- Coords of delivery locations

Config.deliveryLocations = {
    {x = 349.79, y = 3573.8, z = 33.03},
    {x = 2537.39, y = 2588.43, z = 37.94},
    {x = 1744.46, y = 3044.68, z = 61.57},

} 

-- Enemies amount and their weapons

Config.MediumMaxHostileAmount = 2
Config.HardMaxHostileAmount = 4


Config.WeaponList = {
    medium = {"WEAPON_PISTOL", "WEAPON_BAT", "WEAPON_HAMMER"},
    hard = {"WEAPON_COMBATPISTOL", "WEAPON_MICROSMG", "WEAPON_APPISTOL"}
}


-- Vehicles available for specific mission (hashs)


Config.CivilianVehicles = {
    3469130167, --vigero
    3609690755, -- emperor
    914654722, --mesa
    1348744438, --oracle
    2175389151, -- faction
    2170765704, -- manana
    3412338231, -- nebula
    3863274624, -- panto
    83136452, -- rebla
    3286105550, -- tailgater
    3050505892, -- tailgater2
    1203490606, -- xls
    3862958888, -- xls2
}


Config.GangVehicles = {
    1123216662, -- superd
    108773431, -- coquette
    3249425686, --comet2
    1177543287, -- dubsta
    349315417, --gauntlet2
    3001042683, --impaler2
    196747873, -- elegy
    37348240, -- hotknife
    223258115, -- sabregt2
    2594165727, -- sultan3
    16646064, -- virgo3
    1862507111, -- zion3
    2672523198, -- voltic


}

Config.MilitaryVehicles = {
    3471458123, -- barracks (might be blacklisted on your server, check that when u get a problem)
    1074326203, -- barracks2
    321739290, -- crusader
    121658888, -- boxvile humane labs
    758895617, -- ztype
    2891838741, -- zentorno
    1663218586, -- t20


}

