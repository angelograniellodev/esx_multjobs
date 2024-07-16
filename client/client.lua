local ESX = exports["es_extended"]:getSharedObject()

RegisterCommand(Config.OpenCommand, function()
    ESX.TriggerServerCallback('esx_multijobs:getJobs', function(jobs)
        if jobs then
            local elements = {}

            for jobName, jobData in pairs(jobs) do
                table.insert(elements, {
                    label = jobData.name .. ' - Grado: ' .. jobData.grade,
                    value = jobName,
                    grade = jobData.grade,
                })
            end

            SendNUIMessage({
                type = 'showJobs',
                jobs = elements
            })

            SetNuiFocus(true, true)
        else
            ESX.ShowNotification(Config.Lang.notify_nojobs)
        end
    end)
end, false)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('selectjob', function(data, cb)
    SetNuiFocus(false, false)
    debug("Callback NUI, JOB: " .. data.job .. " Grade: " .. data.grade )
    TriggerServerEvent("esx_multijobs:setjob", data.job, data.grade, true)
    ESX.ShowNotification(Config.Lang.notify_jobapply)
    cb('ok')
end)

RegisterNUICallback('deletejob', function(data, cb)
    TriggerServerEvent('esx_multijobs:deleteJob', data.job, data.grade)
    Wait(150)
    ESX.TriggerServerCallback('esx_multijobs:getJobs', function(jobs)
        if jobs then
            local elements = {}

            for jobName, jobData in pairs(jobs) do
                table.insert(elements, {
                    label = jobData.name .. ' - Grado: ' .. jobData.grade,
                    value = jobName,
                    grade = jobData.grade,
                })
            end
            SendNUIMessage({
                type = 'showJobs',
                jobs = elements
            })

            SetNuiFocus(true, true)
        else
            ESX.ShowNotification(Config.Lang.notify_nojobs)
        end
    end)
    cb('ok')
end)
