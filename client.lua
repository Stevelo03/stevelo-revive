
local reviveTimer = 15
local reviveColor = "~y~"
local chatColor = "~b~" 

timerCount1 = reviveTimer
isDead = false



AddEventHandler('onClientMapStart', function()
	exports.spawnmanager:spawnPlayer()
	Citizen.Wait(2500)
	exports.spawnmanager:setAutoSpawn(false)
end)


function revivePed(ped)
	isDead = false
	timerCount1 = reviveTimer
	local playerPos = GetEntityCoords(ped, true)
	NetworkResurrectLocalPlayer(playerPos, true, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)
end

function ShowInfoRevive(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentSubstringPlayerName(text)
	DrawNotification(true, true)
end

Citizen.CreateThread(function()
    while true do
    	Citizen.Wait(0)
		ped = GetPlayerPed(-1)
        if IsEntityDead(ped) then
			isDead = true
            SetPlayerInvincible(ped, true)
            SetEntityHealth(ped, 1)
			ShowInfoRevive(chatColor .. 'Du bist verletzt/ohnmächtig. Nutze ' .. reviveColor .. 'E ' .. chatColor ..'zum aufstehen.')
            if IsControlJustReleased(0, 38) and GetLastInputMethod(0) then
                if timerCount1 == 0 or cHavePerms then
                    revivePed(ped)
				else
					TriggerEvent('chat:addMessage', {args = {'^1^*' .. timerCount1 .. ' | Simuliere deine Verletzung'}})
                end	
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if isDead then
			if timerCount1 ~= 0 then
				timerCount1 = timerCount1 - 1
			end
        end
        Citizen.Wait(1000)          
    end
end)
