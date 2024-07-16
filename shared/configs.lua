Config = {}

Config.Debug = true 

function debug(msg)
    if Config.Debug then 
        print("[^6esx_multijobs^0] " .. msg)
    end
end

Config.OpenCommand = "jobs"
Config.GroupPermissions = "admin"

Config.Lang = {
    notify_nojobs = "You dont have a multiple jobs",
    admin_command_desc = "This command is used to give multiple jobs to one person.",
    notify_jobapply = "You changed your job with the multijob system.",
}