ESX = nil

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "Le.V:GetCles",
    function(source, cb, id)
        MySQL.Async.fetchAll(
            "SELECT id, label, value FROM open_car ORDER BY id ASC",
            {},
            function(result)
                cb(result)
            end
        )
    end
)

RegisterServerEvent("Le.V:Recruter") -- Fonction Repris du KRZ_PersonalMenu [Recruter]
AddEventHandler(
    "Le.V:Recruter",
    function(target, job, grade)
        local sourceXPlayer = ESX.GetPlayerFromId(source)
        local targetXPlayer = ESX.GetPlayerFromId(target)
        targetXPlayer.setJob(job, grade)
        TriggerClientEvent(
            "esx:showNotification",
            sourceXPlayer.source,
            "Vous avez ~g~recruté " .. targetXPlayer.name .. "~s~."
        )
        TriggerClientEvent(
            "esx:showNotification",
            target,
            "Vous avez été ~g~embauché par " .. sourceXPlayer.name .. "~s~."
        )
    end
)

RegisterServerEvent("Le.V:Promouvoir") -- Fonction Repris du KRZ_PersonalMenu [Promouvoir]
AddEventHandler(
    "Le.V:Promouvoir",
    function(target)
        local sourceXPlayer = ESX.GetPlayerFromId(source)
        local targetXPlayer = ESX.GetPlayerFromId(target)

        if (targetXPlayer.job.grade == tonumber(getMaximumGrade(sourceXPlayer.job.name)) - 1) then
            TriggerClientEvent(
                "esx:showNotification",
                sourceXPlayer.source,
                "Vous devez demander une autorisation du ~r~Gouvernement~s~."
            )
        else
            targetXPlayer.setJob(targetXPlayer.job.name, tonumber(targetXPlayer.job.grade) + 1)

            TriggerClientEvent(
                "esx:showNotification",
                sourceXPlayer.source,
                "Vous avez ~g~promu " .. targetXPlayer.name .. "~s~."
            )
            TriggerClientEvent(
                "esx:showNotification",
                target,
                "Vous avez été ~g~promu par " .. sourceXPlayer.name .. "~s~."
            )
            TriggerClientEvent("esx:showNotification", sourceXPlayer.source, "Vous n'avez pas ~r~l'autorisation~s~.")
        end
    end
)

RegisterServerEvent("Le.V:Destiuer") -- Fonction Repris du KRZ_PersonalMenu [Destituer]
AddEventHandler(
    "Le.V:Destiuer",
    function(target)
        local sourceXPlayer = ESX.GetPlayerFromId(source)
        local targetXPlayer = ESX.GetPlayerFromId(target)
        if (targetXPlayer.job.grade == 0) then
            TriggerClientEvent(
                "esx:showNotification",
                sourceXPlayer.source,
                "Vous ne pouvez pas ~r~rétrograder~s~ davantage."
            )
        else
            targetXPlayer.setJob(targetXPlayer.job.name, tonumber(targetXPlayer.job.grade) - 1)
            TriggerClientEvent(
                "esx:showNotification",
                sourceXPlayer.source,
                "Vous avez ~r~rétrogradé " .. targetXPlayer.name .. "~s~."
            )
            TriggerClientEvent(
                "esx:showNotification",
                target,
                "Vous avez été ~r~rétrogradé par " .. sourceXPlayer.name .. "~s~."
            )
        end
    end
)

RegisterServerEvent("Le.V:Licencier") -- Fonction Repris du KRZ_PersonalMenu [Licencier]
AddEventHandler(
    "Le.V:Licencier",
    function(target)
        local sourceXPlayer = ESX.GetPlayerFromId(source)
        local targetXPlayer = ESX.GetPlayerFromId(target)

        targetXPlayer.setJob("unemployed", 0)
        TriggerClientEvent(
            "esx:showNotification",
            sourceXPlayer.source,
            "Vous avez ~r~viré " .. targetXPlayer.name .. "~s~."
        )
        TriggerClientEvent("esx:showNotification", target, "Vous avez été ~g~viré par " .. sourceXPlayer.name .. "~s~.")
        TriggerClientEvent("esx:showNotification", sourceXPlayer.source, "Vous n'avez pas ~r~l'autorisation~s~.")
    end
)

RegisterServerEvent("Le.V:DeleteKey")
AddEventHandler(
    "Le.V:DeleteKey",
    function(id)
        local _src = source

        MySQL.Async.execute(
            "DELETE FROM open_car WHERE id = @id",
            {["id"] = id},
            function(affectedRows)
                TriggerClientEvent("Val:depotDel", _src)
            end
        )
    end
)
