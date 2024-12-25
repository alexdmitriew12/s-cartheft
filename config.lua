Config = {}


Config.Payment = 5000
Config.MediumMaxHostileAmount = 2
Config.HardMaxHostileAmount = 4


Config.PoliceCallChance = 100


-- peds locations where u can take a mission
Config.Peds = {
    locations = {
        {x = 693.94, y = -728.67, z = 25.31, h = 5.48, ["hash"] = "a_m_m_og_boss_01"},

    }
}


-- vehicle spawn locations
Config.Zones = {
    {
        center = {x = 363.83, y = 282.85, z = 103.36},
        radius = 300.0,
        spawns = {
            {x = 470.19, y = 245.33, z = 103.21}, 
            {x = 350.25, y = 270.45, z = 102.8},
            {x = 236.24, y = 118.71, z = 102.61},
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
}
-- coords of delivery locations

Config.deliveryLocations = {
    {x = 349.79, y = 3573.8, z = 33.03},
    {x = 2537.39, y = 2588.43, z = 37.94},
    {x = 1744.46, y = 3044.68, z = 61.57},

} 

-- Peds weapons
Config.WeaponList = {
    medium = {"WEAPON_PISTOL", "WEAPON_BAT", "WEAPON_HAMMER"},
    hard = {"WEAPON_COMBATPISTOL", "WEAPON_MICROSMG", "WEAPON_APPISTOL"}
}


-- Vehicle Hash


Config.CivilianVehicles = {
    3469130167, --vigero
    3609690755, -- emperor
    914654722, --mesa
    1348744438, --oracle
}


Config.GangVehicles = {
    1123216662, -- superd
    108773431, -- coquette
    3249425686, --comet2
    1177543287, -- dubsta
    349315417, --gauntlet2
    3001042683, --impaler2

}

Config.MilitaryVehicles = {


}

