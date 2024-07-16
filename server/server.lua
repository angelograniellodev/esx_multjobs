---@diagnostic disable: undefined-global
local ESX = exports["es_extended"]:getSharedObject()

function saveJobs(license, jobs)
    local jobsJson = json.encode(jobs)
    MySQL.Async.execute('REPLACE INTO multijobs (license, jobs) VALUES (@license, @jobs)', {
        ['@license'] = license,
        ['@jobs'] = jobsJson
    }, function(rowsChanged)
        if rowsChanged > 0 then
            debug("Jobs saved in Database correctly, , license: " .. license )
        else
           debug("There was a problem saving jobs, license: " .. license )
        end
    end)
end

function updateJobs(license, jobs)
    MySQL.Async.execute('UPDATE multijobs SET jobs = @jobs WHERE license = @license', {
        ['@jobs'] = json.encode(jobs),
        ['@license'] = license
    })
end

RegisterServerEvent('esx_multijobs:deleteJob')
AddEventHandler('esx_multijobs:deleteJob', function(job, grade)
    local xPlayer = ESX.GetPlayerFromId(source)
    local license = xPlayer.getIdentifier()

    MySQL.Async.fetchAll('SELECT jobs FROM multijobs WHERE license = @license', {
        ['@license'] = license
    }, function(result)
        local jobs = {}

        if result[1] then
            jobs = json.decode(result[1].jobs)
        end
        if jobs[job] then
            jobs[job] = nil 
            updateJobs(license, jobs)
        else
            debug("Job not found")
        end
    end)
end)

RegisterServerEvent('esx_multijobs:setjob')
AddEventHandler('esx_multijobs:setjob', function(job, grade, exp)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not exp then 
        debug("THE PERSON WITH THE FOLLOWING IDENTIFIER IS USING EXTERNAL PROGRAMS TO USE THIS EVENT: " .. xPlayer.getIdentifier())
        debug("THE PERSON WITH THE FOLLOWING IDENTIFIER IS USING EXTERNAL PROGRAMS TO USE THIS EVENT: " .. xPlayer.getIdentifier())
        debug("THE PERSON WITH THE FOLLOWING IDENTIFIER IS USING EXTERNAL PROGRAMS TO USE THIS EVENT: " .. xPlayer.getIdentifier())
        return
    end

    xPlayer.setJob(job, grade)
    debug("a job was placed for: " .. xPlayer.getIdentifier() .. " job: " .. job .. " grade: " .. grade)
end)

ESX.RegisterServerCallback('esx_multijobs:getJobs', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local license = xPlayer.getIdentifier()

        MySQL.Async.fetchAll('SELECT jobs FROM multijobs WHERE license = @license', {
            ['@license'] = license
        }, function(result)
            if result[1] then
                local jobs = json.decode(result[1].jobs)
                cb(jobs)
            else
                cb(nil)
            end
        end)
    else
        cb(nil)
    end
end)

RegisterServerEvent('esx_multijobs:setjob:export')
AddEventHandler('esx_multijobs:setjob:export', function(job, grade, exp)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not exp then 
        debug("THE PERSON WITH THE FOLLOWING IDENTIFIER IS USING EXTERNAL PROGRAMS TO USE THIS EVENT: " .. xPlayer.getIdentifier())
        debug("THE PERSON WITH THE FOLLOWING IDENTIFIER IS USING EXTERNAL PROGRAMS TO USE THIS EVENT: " .. xPlayer.getIdentifier())
        debug("THE PERSON WITH THE FOLLOWING IDENTIFIER IS USING EXTERNAL PROGRAMS TO USE THIS EVENT: " .. xPlayer.getIdentifier())
        return
    end

    local targetId = xPlayer
    local jobName = job
    local jobGrade = grade

    if targetId and jobName and jobGrade then
        local xPlayer = ESX.GetPlayerFromId(targetId)
        if xPlayer then
            local license = xPlayer.getIdentifier()

            MySQL.Async.fetchAll('SELECT jobs FROM multijobs WHERE license = @license', {
                ['@license'] = license
            }, function(result)
                local jobs = {}

                if result[1] then
                    jobs = json.decode(result[1].jobs)
                end

                jobs[jobName] = { name = jobName, grade = jobGrade }

                saveJobs(license, jobs)
            end)
        else
            debug("Player does not exist")
        end
    else
        debug("Incorrect command usage. Usage: /givejob [id] [job] [grade]")
    end

    xPlayer.setJob(job, grade)
    debug("EXPORT USED")
    debug("a job was placed for: " .. xPlayer.getIdentifier() .. " job: " .. job .. " grade: " .. grade)
end)

RegisterCommand('givejob', function(source, args, rawCommand)
    local targetId = tonumber(args[1])
    local jobName = args[2]
    local jobGrade = tonumber(args[3])

    if targetId and jobName and jobGrade then
        local xPlayer = ESX.GetPlayerFromId(targetId)
        if xPlayer then
            local license = xPlayer.getIdentifier()

            MySQL.Async.fetchAll('SELECT jobs FROM multijobs WHERE license = @license', {
                ['@license'] = license
            }, function(result)
                local jobs = {}

                if result[1] then
                    jobs = json.decode(result[1].jobs)
                end

                jobs[jobName] = { name = jobName, grade = jobGrade }

                saveJobs(license, jobs)
            end)
        else
            debug("Player does not exist")
        end
    else
        debug("Incorrect command usage. Usage: /givejob [id] [job] [grade]")
    end
end)

