local Main
repeat
    for i, v in next, getgc(true) do
        if typeof(v) == 'table' and rawget(v, 'StartupHighlight') then
            Main = v
        end
    end
    wait()
until Main and Main.StartupHighlight
--------------------- These are the configs.
_G.DelayDodgeNormal = 0.15
_G.DelayDodgeHeavy = 0.3
_G.activateRange = 10
---------------------
local plr = game:GetService('Players').LocalPlayer
local States = workspace.States:FindFirstChild(plr.Name)
local Occupied = States.Occupied
local LockedOn = Occupied.LockedOn
-- Setup main
local function getDistance()
    if plr and plr.Character and plr.Character.HumanoidRootPart then
        local charRoot = plr.Character.HumanoidRootPart
        if LockedOn and LockedOn.Value and LockedOn.Value.HumanoidRootPart then
            local EnemyCharRoot = LockedOn.Value.HumanoidRootPart
            local distance =
                (charRoot.Position - EnemyCharRoot.Position).Magnitude
            return distance <= _G.activateRange
        end
    end
    return false
end
local oldf = Main.StartupHighlight
local oldf2 = Main.DashHighlight
--Dodge function inputActivation
local Dodge = function()
    task.spawn(function()
        keypress(0x41)
        wait(0.1)
        keyrelease(0x41)
    end)
    keypress(0x20)
    task.wait()
    keyrelease(0x20)
end

local Block = function()
    keypress(0x46)
    task.wait(1)
    keyrelease(0x46)
end
rconsoleclear()
rconsoleprint('Starting')
Main.StartupHighlight = function(v326)
    local v327 = {
        Character = v326[2],
        IsHeavy = v326[3],
        IsCharge = v326[4],
        IsUltimate = v326[5],
        StartupScale = v326[6],
        IsFeint = v326[7],
    }
    if LockedOn.Value and v327.Character == LockedOn.Value then
        if getDistance() then
            task.spawn(function()
                if v327.IsFeint then
                    keyrelease(0x46)
                    mouse1press()
                    task.wait()
                    mouse1release()
                elseif v327.IsHeavy then
                    keyrelease(0x46)
                    mouse1press()
                    task.wait()
                    mouse1release()
                elseif v327.IsUltimate then
                    Block()
                else
                    task.wait(_G.DelayDodgeNormal)
                    task.spawn(Dodge)
                end
            end)
        end
    end
    return oldf(v326)
end
Main.DashHighlight = function(v312)
    local Character = v312[2]
    if LockedOn.Value and LockedOn.Value == Character then
        if getDistance() then
            keyrelease(0x46)
            mouse1press()
            task.wait()
            mouse1release()
            rconsoleprint('UserDodgingPremature')
        end
    end
    return oldf2(v312)
end
