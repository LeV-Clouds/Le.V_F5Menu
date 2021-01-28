ESX = nil
Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
            Citizen.Wait(10)
        end
        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end
        if ESX.IsPlayerLoaded() then
            RestartMenuPerso()
            ESX.PlayerData = ESX.GetPlayerData()
        end
        RefreshMoney()
    end
)
Citizen.CreateThread(
    function()
        RMenu.Add(
          "menuf5", 
          "main", RageUI.CreateMenu("Le.V", "Menu personnel")) -- [Dépendance du Menu Crée] -- Tuto bientôt sur ma chaine ! : )
        RMenu:Get(
          "menuf5", 
          "main"):SetRectangleBanner(255, 255, 255, 100) -- [Couleur du Menu] (RageUI)
        RMenu.Add(
          "menuf5", 
          "inventaire", 
          RageUI.CreateSubMenu(RMenu:Get("menuf5", "main"), "Inventaire", "Liste"))
        RMenu.Add(
          "menuf5", 
          "cles", 
          RageUI.CreateSubMenu(RMenu:Get("menuf5", "main"), "Clés - Plaque", "Liste"))
        RMenu.Add(
            "menuf5",
            "portefeuille",
            RageUI.CreateSubMenu(RMenu:Get("menuf5", "main"), "Portefeuille", "Actions")
        )
        RMenu.Add(
            "menuf5",
            "menuvehicule",
            RageUI.CreateSubMenu(RMenu:Get("menuf5", "main"), "Intéraction - Veh", "Catégories")
        )

        LeV.WeaponData = ESX.GetWeaponList()
        for i = 1, #LeV.WeaponData, 1 do
            if LeV.WeaponData[i].name == "WEAPON_UNARMED" then
                LeV.WeaponData[i] = nil
            else
                LeV.WeaponData[i].hash = GetHashKey(LeV.WeaponData[i].name)
            end
        end
    end
)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler(
    "esx:playerLoaded",
    function(xPlayer)
        ESX.PlayerData = xPlayer
    end
)
AddEventHandler(
    "esx:onPlayerDeath",
    function()
        Player.isDead = true
        RageUI.CloseAll()
        ESX.UI.Menu.CloseAll()
    end
)
RegisterNetEvent("esx:setJob")
AddEventHandler(
    "esx:setJob",
    function(job)
        ESX.PlayerData.job = job
        RefreshMoney()
    end
)
RegisterNetEvent("esx:setJob2")
AddEventHandler(
    "esx:setJob2",
    function(job2)
        ESX.PlayerData.job2 = job2
        RefreshMoney2()
    end
)
RegisterNetEvent("esx_addonaccount:setMoney")
AddEventHandler(
    "esx_addonaccount:setMoney",
    function(society, money)
        if
            ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == "boss" and
                "society_" .. ESX.PlayerData.job.name == society
         then
            societymoney = ESX.Math.GroupDigits(money)
        end

        if
            ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == "boss" and
                "society_" .. ESX.PlayerData.job2.name == society
         then
            societymoney2 = ESX.Math.GroupDigits(money)
        end
    end
)
function RefreshMoney()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == "boss" then
        ESX.TriggerServerCallback(
            "esx_society:getSocietyMoney",
            function(money)
                societymoney = ESX.Math.GroupDigits(money)
            end,
            ESX.PlayerData.job.name
        )
    end
end
function RefreshMoney2()
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == "boss" then
        ESX.TriggerServerCallback(
            "esx_society:getSocietyMoney",
            function(money)
                societymoney2 = ESX.Math.GroupDigits(money)
            end,
            ESX.PlayerData.job2.name
        )
    end
end
local menuf5 = {menu = false}
local filter = {filtre = {"Aucun", "Objet", "Armes"}, index = 1}
local actionIt = {select = {"Donner", "Utiliser", "Jeter"}, index = 1}
local actionWe = {select = {"Donner", "Jeter"}, index = 1}
local actionCles = {select = {"Prêter", "Détruire"}, index = 1}
local actionPatron = {select = {"Recruter", "Promouvoir", "Destituer", "Licencier"}, index = 1}
local actionporte = {
    select = {
        "Porte avant gauche",
        "Porte avant droite",
        "Porte arrière gauche",
        "Porte arrière droite",
        "Capot",
        "Coffre",
        FrontLeft = false,
        FrontRight = false,
        BackLeft = false,
        BackRight = false,
        Hood = false,
        Trunk = false
    },
    index = 1
}
local IdPed = GetPlayerPed(-1)
LeV = {WeaponData = {}, ObjetSelect = {}, ArmesSelect = {}, ArgentSelect = {}}
function RestartMenuPerso()
    while true do
        Wait(1)
        if IsControlJustPressed(1, 166) then
            RageUI.Visible(RMenu:Get("menuf5", "main"), true)
            MenuF5()
        end
    end
end

function MenuF5()
    if menuf5.menu then
        return
    end
    menuf5.menu = true
    RageUI.Visible(RMenu:Get("menuf5", "main"), true)
    Citizen.CreateThread(
        function()
            while menuf5.menu do
                Wait(1)
                RageUI.IsVisible(
                    RMenu:Get("menuf5", "main"),
                    true,
                    true,
                    true,
                    function()
                        RageUI.Button(
                            "Mes poches",
                            nil,
                            {RightLabel = "→"},
                            true,
                            function(Hovered, Active, Selected)
                            end,
                            RMenu:Get("menuf5", "inventaire")
                        )
                        RageUI.Button(
                            "Portefeuille",
                            nil,
                            {RightLabel = "→"},
                            true,
                            function(Hovered, Active, Selected)
                            end,
                            RMenu:Get("menuf5", "portefeuille")
                        )
                        if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                            RageUI.Button(
                                "Gestion du modèle",
                                nil,
                                {RightLabel = "→"},
                                true,
                                function(Hovered, Active, Selected)
                                end,
                                RMenu:Get("menuf5", "menuvehicule")
                            )
                        else
                            RageUI.Button(
                                "~c~Gestion du modèle",
                                nil,
                                {RightBadge = RageUI.BadgeStyle.Lock},
                                true,
                                function(Hovered, Active, Selected)
                                end
                            )
                        end
                    end
                )

                RageUI.IsVisible(
                    RMenu:Get("menuf5", "menuvehicule"),
                    true,
                    true,
                    true,
                    function()
                        if not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then -- [Retour sur le menu "main" si l'on n'est pas dans un véhicule]
                            RageUI.GoBack()
                        end
                        RageUI.List(
                            "Portes ",
                            actionporte.select,
                            actionporte.index,
                            nil,
                            {},
                            true,
                            function(Hovered, Active, Selected, Index)
                                if (Selected) then
                                    local ValPed = PlayerPedId()
                                    if not IsPedSittingInAnyVehicle(ValPed) then
                                    elseif IsPedSittingInAnyVehicle(ValPed) then
                                        local plyVeh = GetVehiclePedIsIn(ValPed, false)
                                        if Index == 1 then
                                            if not actionporte.select.FrontLeft then
                                                actionporte.select.FrontLeft = true
                                                SetVehicleDoorOpen(plyVeh, 0, false, false)
                                            elseif actionporte.select.FrontLeft then
                                                actionporte.select.FrontLeft = false
                                                SetVehicleDoorShut(plyVeh, 0, false, false)
                                            end
                                        elseif Index == 2 then
                                            if not actionporte.select.FrontRight then
                                                actionporte.select.FrontRight = true
                                                SetVehicleDoorOpen(plyVeh, 1, false, false)
                                            elseif actionporte.select.FrontRight then
                                                actionporte.select.FrontRight = false
                                                SetVehicleDoorShut(plyVeh, 1, false, false)
                                            end
                                        elseif Index == 3 then
                                            if not actionporte.select.BackLeft then
                                                actionporte.select.BackLeft = true
                                                SetVehicleDoorOpen(plyVeh, 2, false, false)
                                            elseif actionporte.select.BackLeft then
                                                actionporte.select.BackLeft = false
                                                SetVehicleDoorShut(plyVeh, 2, false, false)
                                            end
                                        elseif Index == 4 then
                                            if not actionporte.select.BackRight then
                                                actionporte.select.BackRight = true
                                                SetVehicleDoorOpen(plyVeh, 3, false, false)
                                            elseif actionporte.select.BackRight then
                                                actionporte.select.BackRight = false
                                                SetVehicleDoorShut(plyVeh, 3, false, false)
                                            end
                                        elseif Index == 5 then
                                            if not actionporte.select.Hood then
                                                actionporte.select.Hood = true
                                                SetVehicleDoorOpen(plyVeh, 4, false, false)
                                            elseif actionporte.select.Hood then
                                                actionporte.select.Hood = false
                                                SetVehicleDoorShut(plyVeh, 4, false, false)
                                            end
                                        elseif Index == 6 then
                                            if not actionporte.select.Trunk then
                                                actionporte.select.Trunk = true
                                                SetVehicleDoorOpen(plyVeh, 5, false, false)
                                            elseif actionporte.select.Trunk then
                                                actionporte.select.Trunk = false
                                                SetVehicleDoorShut(plyVeh, 5, false, false)
                                            end
                                        end
                                    end
                                end
                                actionporte.index = Index
                            end,
                            RMenu:Get("Val", "gestionveh")
                        )

                        RageUI.Button(
                            "Allumer/Eteindre le moteur",
                            nil,
                            {LeftBadge = nil, RightBadge = nil, RightLabel = ">"},
                            true,
                            function(Hovered, Active, Selected)
                                if Selected then
                                    Id = GetPlayerPed(-1)
                                    vehicle = GetVehiclePedIsIn(Id, false)
                                    if GetIsVehicleEngineRunning(vehicle) then
                                        SetVehicleEngineOn(vehicle, false, false, true)
                                        SetVehicleUndriveable(vehicle, true)
                                    elseif not GetIsVehicleEngineRunning(vehicle) then
                                        SetVehicleEngineOn(vehicle, true, false, true)
                                        SetVehicleUndriveable(vehicle, false)
                                    end
                                end
                            end
                        )
                        Id = GetPlayerPed(-1)
                        vehicle = GetVehiclePedIsIn(Id, false)
                        vievehicule = GetVehicleEngineHealth(vehicle) / 10
                        local vievehicule = math.floor(vievehicule)
                        local label = "~s~/100"
                        RageUI.Button(
                            "Etat du moteur : ~g~" .. vievehicule .. label,
                            nil,
                            {},
                            true,
                            function(Hovered, Active, Selected)
                                if Selected then
                                end
                            end
                        )
                    end
                )
                RageUI.IsVisible(
                    RMenu:Get("menuf5", "inventaire"),
                    true,
                    true,
                    true,
                    function()
                        RageUI.Button(
                            "Clés",
                            nil,
                            {RightLabel = "→"},
                            true,
                            function(Hovered, Active, Selected)
                                if Selected then
                                    RefreshCles()
                                end
                            end,
                            RMenu:Get("menuf5", "cles")
                        )
                        RageUI.Separator("↓ ~b~Inventaire~s~ ↓")
                        RageUI.List(
                            "Filtre :",
                            filter.filtre,
                            filter.index,
                            nil,
                            {},
                            true,
                            function(Hovered, Active, Selected, Index)
                                if Active then
                                    if Index == 1 then
                                        aucun = true
                                        inv = true
                                        arms = true
                                    elseif Index == 2 then
                                        aucun = false
                                        inv = true
                                        arms = false
                                    elseif Index == 3 then
                                        aucun = false
                                        inv = false
                                        arms = true
                                    end
                                end
                                filter.index = Index
                            end
                        )
                        if aucun then
                            for i = 1, #ESX.PlayerData.inventory, 1 do
                                if ESX.PlayerData.inventory[i].count > 0 then
                                    local invCount = {}

                                    for i = 1, ESX.PlayerData.inventory[i].count, 1 do
                                        table.insert(invCount, i)
                                    end
                                    RageUI.List(
                                        ESX.PlayerData.inventory[i].label ..
                                            " - (Contenue) : [~b~" .. ESX.PlayerData.inventory[i].count .. "~s~]",
                                        actionIt.select,
                                        actionIt.index,
                                        nil,
                                        {},
                                        true,
                                        function(Hovered, Active, Selected, Index)
                                            if Selected then
                                                if Index == 1 then
                                                    LeV.ObjetSelect = ESX.PlayerData.inventory[i]
                                                    actionitem.donner()
                                                elseif Index == 2 then
                                                    LeV.ObjetSelect = ESX.PlayerData.inventory[i]
                                                    actionitem.utiliser()
                                                elseif Index == 3 then
                                                    LeV.ObjetSelect = ESX.PlayerData.inventory[i]
                                                    actionitem.jeter2()
                                                end
                                            end
                                            actionIt.index = Index
                                        end
                                    )
                                end
                            end
                            RageUI.Separator("↓ ~r~Armes~s~ ↓")
                            for i = 1, #LeV.WeaponData, 1 do
                                if HasPedGotWeapon(PlayerPedId(), LeV.WeaponData[i].hash, false) then
                                    local ammo = GetAmmoInPedWeapon(PlayerPedId(), LeV.WeaponData[i].hash)

                                    RageUI.List(
                                        LeV.WeaponData[i].label .. " - (Munitions) : [~y~" .. ammo .. "~s~]",
                                        actionWe.select,
                                        actionWe.index,
                                        nil,
                                        {},
                                        true,
                                        function(Hovered, Active, Selected, Index)
                                            if Selected then
                                                if Index == 1 then
                                                    LeV.ArmesSelect = LeV.WeaponData[i]
                                                    actionArmes.donner()
                                                elseif Index == 2 then
                                                    LeV.ArmesSelect = LeV.WeaponData[i]
                                                    actionArmes.jeter2()
                                                end
                                            end
                                            actionWe.index = Index
                                        end
                                    )
                                end
                            end
                        elseif inv then
                            for i = 1, #ESX.PlayerData.inventory, 1 do
                                if ESX.PlayerData.inventory[i].count > 0 then
                                    local invCount = {}

                                    for i = 1, ESX.PlayerData.inventory[i].count, 1 do
                                        table.insert(invCount, i)
                                    end
                                    RageUI.List(
                                        ESX.PlayerData.inventory[i].label ..
                                            " - (Contenue) : [~b~" .. ESX.PlayerData.inventory[i].count .. "~s~]",
                                        actionIt.select,
                                        actionIt.index,
                                        nil,
                                        {},
                                        true,
                                        function(Hovered, Active, Selected, Index)
                                            if Selected then
                                                if Index == 1 then
                                                    LeV.ObjetSelect = ESX.PlayerData.inventory[i]
                                                    actionitem.donner()
                                                elseif Index == 2 then
                                                    LeV.ObjetSelect = ESX.PlayerData.inventory[i]
                                                    actionitem.utiliser()
                                                elseif Index == 3 then
                                                    LeV.ObjetSelect = ESX.PlayerData.inventory[i]
                                                    actionitem.jeter2()
                                                end
                                            end
                                            actionIt.index = Index
                                        end
                                    )
                                end
                            end
                        elseif arms then
                            for i = 1, #LeV.WeaponData, 1 do
                                if HasPedGotWeapon(PlayerPedId(), LeV.WeaponData[i].hash, false) then
                                    local ammo = GetAmmoInPedWeapon(PlayerPedId(), LeV.WeaponData[i].hash)
                                    RageUI.List(
                                        LeV.WeaponData[i].label .. " - (Munitions) : [~y~" .. ammo .. "~s~]",
                                        actionWe.select,
                                        actionWe.index,
                                        nil,
                                        {},
                                        true,
                                        function(Hovered, Active, Selected, Index)
                                            if Selected then
                                                if Index == 1 then
                                                    LeV.ArmesSelect = LeV.WeaponData[i]
                                                    actionArmes.donner()
                                                elseif Index == 2 then
                                                    LeV.ArmesSelect = LeV.WeaponData[i]
                                                    actionArmes.jeter2()
                                                end
                                            end
                                            actionWe.index = Index
                                        end
                                    )
                                end
                            end
                        end
                    end
                )
                RageUI.IsVisible(
                    RMenu:Get("menuf5", "cles"),
                    true,
                    true,
                    true,
                    function()
                        for k, v in ipairs(getCles) do
                            RageUI.List(
                                "Clés Numéro : [~g~" .. v.id .. "~s~] - [~b~" .. v.value .. "~s~]",
                                actionCles.select,
                                actionCles.index,
                                nil,
                                {},
                                true,
                                function(Hovered, Active, Selected, Index)
                                    if Selected then
                                        if Index == 1 then
                                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                            if closestDistance ~= -1 and closestDistance <= 3 then
                                                TriggerServerEvent(
                                                    "esx_vehiclelock:preterkey",
                                                    GetPlayerServerId(player),
                                                    v.value,
                                                    v.label,
                                                    GetPlayerServerId(PlayerId())
                                                )
                                                Wait(250)
                                                RefreshCles()
                                            else
                                                ESX.ShowNotification("Aucun ~b~individus~s~ près de vous.")
                                            end
                                        elseif Index == 2 then
                                            TriggerServerEvent("Le.V:DeleteKey", v.id)
                                            Wait(250)
                                            RefreshCles()
                                            ESX.ShowNotification(
                                                "- Clés ~r~détruite~s~\n- Plaque : ~y~" ..
                                                    v.value .. "~s~\n- Numéro : ~g~" .. v.id
                                            )
                                        end
                                    end
                                    actionCles.index = Index
                                end
                            )
                        end
                    end
                )
                RageUI.IsVisible(
                    RMenu:Get("menuf5", "portefeuille"),
                    true,
                    true,
                    true,
                    function()
                        RageUI.Separator(
                            "Emploi : ~b~" .. ESX.PlayerData.job.label .. "~s~ - ~b~" .. ESX.PlayerData.job.grade_label
                        )
                        RageUI.Separator(
                            "Crew : ~b~" .. ESX.PlayerData.job2.label .. "~s~ - ~b~" .. ESX.PlayerData.job2.grade_label
                        )
                        for i = 1, #ESX.PlayerData.accounts, 1 do
                            if ESX.PlayerData.accounts[i].name == "money" then
                                RageUI.Separator(
                                    "Argent liquide : ~g~" .. ESX.Math.GroupDigits(ESX.PlayerData.money .. "$")
                                )
                            end
                            if ESX.PlayerData.accounts[i].name == "black_money" then
                                RageUI.Separator(
                                    "Argent Sale : ~r~" .. ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money .. "$")
                                )
                            end
                        end
                        if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == "boss" then
                            RageUI.CenterButton(
                                "↓ ~y~Action sur l'entreprise~s~ ↓",
                                nil,
                                {},
                                true,
                                function(Hovered, Active, Selected)
                                end
                            )
                            RageUI.List(
                                "Action sur l'individus",
                                actionPatron.select,
                                actionPatron.index,
                                nil,
                                {},
                                true,
                                function(Hovered, Active, Selected, Index)
                                    if Selected then
                                        if Index == 1 then
                                            actionPatrons.recruter()
                                        elseif Index == 2 then
                                            actionPatrons.promouvoir()
                                        elseif Index == 3 then
                                            actionPatrons.destituer()
                                        elseif Index == 4 then
                                            actionPatrons.licencier()
                                        end
                                    end
                                    actionPatron.index = Index
                                end
                            )
                        end
                    end
                )
            end
        end
    )
end

function RefreshCles()
    getCles = {}
    ESX.TriggerServerCallback(
        "Le.V:GetCles",
        function(cles)
            for k, v in pairs(cles) do
                table.insert(getCles, {id = v.id, label = v.label, value = v.value})
            end
        end
    )
end

actionitem = {
    utiliser = function()
        TriggerServerEvent("esx:useItem", LeV.ObjetSelect.name)
    end,
    donner = function()
        local drop, quantity = CheckQuantity(KeyboardInput("Quantité à donner :", "", 30))
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

        if drop then
            if closestDistance ~= -1 and closestDistance <= 3 then
                local closestPed = GetPlayerPed(closestPlayer)
                if IsPedonFoot(closestPed) then
                    TriggerServerEvent(
                        "esx:giveInventoryItem",
                        GetPlayerServerId(closestPlayer),
                        "item_standard",
                        LeV.ObjetSelect.name,
                        quantity
                    )
                else
                    ESX.ShowNotification("Vous ne pouvez pas donner ~b~d'item~s~ depuis une voiture.")
                end
            else
                ESX.ShowNotification("Aucun ~b~individus~s~ près de vous.")
            end
        end
    end,
    jeter2 = function()
        local jeter, quantity = CheckQuantity(KeyboardInput("Quantité à jeter :", "", 30))
        if jeter then
            if not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                TriggerServerEvent("esx:removeInventoryItem", "item_standard", LeV.ObjetSelect.name, quantity)
            end
        end
    end
}

actionArmes = {
    donner = function()
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

        if closestDistance ~= -1 and closestDistance <= 3 then
            local closestPed = GetPlayerPed(closestPlayer)

            if IsPedOnFoot(closestPed) then
                local ammo = GetAmmoInPedWeapon(plyPed, LeV.ArmesSelect.hash)
                TriggerServerEvent(
                    "esx:giveInventoryItem",
                    GetPlayerServerId(closestPlayer),
                    "item_weapon",
                    LeV.ArmesSelect.name,
                    ammo
                )
                RageUI.CloseAll()
            else
                ESX.ShowNotification("Vous ne pouvez pas donner ~r~d'arme(s)~s~ depuis une voiture.")
            end
        else
            ESX.ShowNotification("Aucun ~b~individus~s~ près de vous.")
        end
    end,
    jeter2 = function()
        if not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
            TriggerServerEvent("esx:removeInventoryItem", "item_weapon", LeV.ArmesSelect.name)
            RageUI.CloseAll()
        else
            ESX.ShowNotification("Vous ne pouvez pas jeter ~r~d'arme(s)~s~ depuis une voiture.")
        end
    end
}

actionPatrons = {
    recruter = function()
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer == -1 or closestDistance > 3.0 then
            ESX.ShowNotification("Aucun ~b~individus~s~ près de vous.")
        else
            TriggerServerEvent("Le.V:Recruter", GetPlayerServerId(closestPlayer), ESX.PlayerData.job.name, 0)
        end
    end,
    promouvoir = function()
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer == -1 or closestDistance > 3.0 then
            ESX.ShowNotification("Aucun ~b~individus~s~ près de vous.")
        else
            TriggerServerEvent("Le.V:Promouvoir", GetPlayerServerId(closestPlayer))
        end
    end,
    destituer = function()
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer == -1 or closestDistance > 3.0 then
            ESX.ShowNotification("Aucun ~b~individus~s~ près de vous.")
        else
            TriggerServerEvent("Le.V:Destiuer", GetPlayerServerId(closestPlayer))
        end
    end,
    licencier = function()
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer == -1 or closestDistance > 3.0 then
            ESX.ShowNotification("Aucun ~b~individus~s~ près de vous.")
        else
            TriggerServerEvent("Le.V:Licencier", GetPlayerServerId(closestPlayer))
        end
    end
}

--[[ actionArgents = {
        donner = function()
        local post, quantity = CheckQuantity(KeyboardInput("Quantité d'argent à donner :", "", 8))
        if post then
          local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

          if closestDistance ~= -1 and closestDistance <= 3 then
            local closestPed = GetPlayerPed(closestPlayer)

            if not IsPedSittingInAnyVehicle(closestPed) then
              TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', LeV.ArgentSelected, quantity) // Fonction pour Jeter ou "Donner" de l'"argent" si vous voulez l'utiliser
            else
              ESX.ShowNotification("Vous ne pouvez pas donner de ~g~l'argent~s~ dans un véhicule.")
            end
          else
            ESX.ShowNotification("Aucun ~b~individus~s~ près de vous.")
          end
        else
          ESX.ShowNotification("~r~Montant invalide")
        end
        end,
        jeter2 = function ()
        local post, quantity = CheckQuantity(KeyboardInput("Quantité d'argent à donner :", "", 8))

        if post then
          if not IsPedSittingInAnyVehicle(plyPed) then
            TriggerServerEvent('esx:removeInventoryItem', 'item_account', LeV.ArgentSelected, quantity)
            RageUI.CloseAll()
          else
            ESX.ShowNotification("Vous ne pouvez pas jeter de ~g~l'argent~s~ dans un véhicule.")
          end
        else
          ESX.ShowNotification("~r~Montant invalide")
        end
      end
    }]]
function CheckQuantity(number)
    number = tonumber(number)

    if type(number) == "number" then
        number = ESX.Math.Round(number)

        if number > 0 then
            return true, number
        end
    end

    return false, number
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLength)
    AddTextEntry("FMMC_KEY_TIP1", TextEntry .. "")
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
    blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end
