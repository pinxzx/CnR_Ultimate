local default_appearance = {
    model = "mp_m_freemode_01",
    
    faceFeatures = {
        chinHole = 0,
        cheeksWidth = 0,
        jawBoneWidth = 0,
        nosePeakHigh = 0,
        cheeksBoneWidth = 0,
        cheeksBoneHigh = 0,
        nosePeakSize = 0,
        chinBoneSize = 0,
        chinBoneLowering = 0,
        eyesOpening = 0,
        noseWidth = 0,
        noseBoneTwist = 0,
        chinBoneLenght = 0,
        eyeBrownHigh = 0,
        noseBoneHigh = 0,
        neckThickness = 0,
        jawBoneBackSize = 0,
        eyeBrownForward = 0,
        lipsThickness = 0,
        nosePeakLowering = 0
    },

    headOverlays = {
        sunDamage = {style = 0, opacity = 0, color = 0},
        moleAndFreckles = {style = 0, opacity = 0, color = 0},
        complexion = {style = 0, opacity = 0, color = 0},
        eyebrows = {style = 0, opacity = 0, color = 0},
        chestHair = {style = 0, opacity = 0, color = 0},
        bodyBlemishes = {style = 0, opacity = 0, color = 0},
        blemishes = {style = 0, opacity = 0, color = 0},
        blush = {style = 0, opacity = 0, color = 0},
        beard = {style = 0, opacity = 0, color = 0},
        lipstick = {style = 0, opacity = 0, color = 0},
        makeUp = {style = 0, opacity = 0, color = 0},
        ageing = {style = 0, opacity = 0, color = 0}
    },

    eyeColor = -1,
    tattoos = {},

    components = {
        {component_id = 0, texture = 0, drawable = 0},
        {component_id = 1, texture = 0, drawable = 0},
        {component_id = 2, texture = 0, drawable = 0},
        {component_id = 3, texture = 0, drawable = 0},
        {component_id = 4, texture = 0, drawable = 0},
        {component_id = 5, texture = 0, drawable = 0},
        {component_id = 6, texture = 0, drawable = 0},
        {component_id = 7, texture = 0, drawable = 0},
        {component_id = 8, texture = 0, drawable = 0},
        {component_id = 9, texture = 0, drawable = 0},
        {component_id = 10, texture = 0, drawable = 0},
        {component_id = 11, texture = 0, drawable = 0}
    },

    props = {
        {prop_id = 0, drawable = -1, texture = -1},
        {prop_id = 1, drawable = -1, texture = -1},
        {prop_id = 2, drawable = -1, texture = -1},
        {prop_id = 6, drawable = -1, texture = -1},
        {prop_id = 7, drawable = -1, texture = -1}
    },

    hair = {style = 0, color = 0, highlight = 0},

    headBlend = {
        shapeFirst = 0,
        shapeSecond = 0,
        shapeMix = 0,
        skinFirst = 0,
        skinSecond = 0,
        skinMix = 0
    }
}

local config = {
        ped = true,
        headBlend = false,
        faceFeatures = true,
        headOverlays = true,
        components = false,
        props = false,
        allowExit = false,
        tattoos = false
}

function LoadAnim(dict)
  while not HasAnimDictLoaded(dict) do
    RequestAnimDict(dict)
    Wait(10)
  end
end

local function StartCharacterCreator()

    DoScreenFadeOut(500)
    Citizen.Wait(3000)
    local playerPed = PlayerPedId()
    exports.spawnmanager:spawnPlayer({
        x = 405.59,
        y =  -997.18,
        z =  -99.00,
        heading = 90,
        skipFade = true
    })
    exports["fivem-appearance"]:setPlayerAppearance(default_appearance)
    --
    LoadAnim("mp_character_creation@customise@male_a")
    Citizen.Wait(1000)
    TaskPlayAnim(PlayerPedId(), "mp_character_creation@customise@male_a", "intro", 1.0, 1.0, 4050, 0, 1, 0, 0, 0)
    DoScreenFadeIn(500)
    Citizen.Wait(4500)

  exports['fivem-appearance']:startPlayerCustomization(function (appearance)
    if (appearance) then
        TriggerServerEvent("characterhandler:SavePlayerCharacter", appearance)
        exports.spawnresource:spawnPlayer()
    else
        print("canceled")
    end
  end, config)
end
exports("StartCharacterCreator", StartCharacterCreator)

-- Loads the saved player character
local function LoadPlayerCharacter()
    TriggerServerEvent("characterhandler:requestLoadCharacter")
end
exports("LoadPlayerCharacter", LoadPlayerCharacter)

RegisterNetEvent("characterhandler:sendCharacterLoad", function(normal_appearance, after_appearance)
    after_appearance = after_appearance or nil
    exports["fivem-appearance"]:setPlayerAppearance(json.decode(normal_appearance.appearance)) -- coco
    if after_appearance then 
        exports["fivem-appearance"]:setPlayerAppearance(json.decode(after_appearance.appearance))
    end
    Citizen.Wait(3000)
    DoScreenFadeIn(1000)
end)

local function LoadPlayerCopCharacter()
    TriggerServerEvent("characterhandler:server:requestLoadCopCharacter")
end

exports("LoadPlayerCopCharacter", LoadPlayerCopCharacter)
