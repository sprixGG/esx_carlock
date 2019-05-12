ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

end)



Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
	if (IsControlJustPressed(1, 303)) then
		local coords = GetEntityCoords(GetPlayerPed(-1))
		local hasAlreadyLocked = false
		cars = ESX.Game.GetVehiclesInArea(coords, 30)
		local carstrie = {}
		local cars_dist = {}		
		notowned = 0
		if #cars == 0 then
			ESX.ShowNotification("Il n'y a pas de véhicule vous appartenant à proximité.")
		else
			for j=1, #cars, 1 do
				local coordscar = GetEntityCoords(cars[j])
				local distance = Vdist(coordscar.x, coordscar.y, coordscar.z, coords.x, coords.y, coords.z)
				table.insert(cars_dist, {cars[j], distance})
			end
			for k=1, #cars_dist, 1 do
				local z = -1
				local distance, car = 999
				for l=1, #cars_dist, 1 do
					if cars_dist[l][2] < distance then
						distance = cars_dist[l][2]
						car = cars_dist[l][1]
						z = l
					end
				end
				if z ~= -1 then
					table.remove(cars_dist, z)
					table.insert(carstrie, car)
				end
			end
			for i=1, #carstrie, 1 do
				local plate = ESX.Math.Trim(GetVehicleNumberPlateText(carstrie[i]))
				ESX.TriggerServerCallback('carlock:isVehicleOwner', function(owner)
					if owner and hasAlreadyLocked ~= true then
						local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(carstrie[i]))
						vehicleLabel = GetLabelText(vehicleLabel)
						local lock = GetVehicleDoorLockStatus(carstrie[i])
						if lock == 1 or lock == 0 then
							SetVehicleDoorShut(carstrie[i], 0, false)
							SetVehicleDoorShut(carstrie[i], 1, false)
							SetVehicleDoorShut(carstrie[i], 2, false)
							SetVehicleDoorShut(carstrie[i], 3, false)
							SetVehicleDoorsLocked(carstrie[i], 2)
							PlayVehicleDoorCloseSound(carstrie[i], 1)
							ESX.ShowNotification('Vous avez ~r~verrouillé~s~ votre ~y~'..vehicleLabel..'~s~.')
							hasAlreadyLocked = true
						elseif lock == 2 then
							SetVehicleDoorsLocked(carstrie[i], 1)
							PlayVehicleDoorOpenSound(carstrie[i], 0)
							ESX.ShowNotification('Vous avez ~g~déverrouillé~s~ votre ~y~'..vehicleLabel..'~s~.')
							hasAlreadyLocked = true
						end
					else
						notowned = notowned + 1
					end
					if notowned == #carstrie then
						ESX.ShowNotification("Il n'y a pas de véhicule vous appartenant à proximité.")
					end	
				end, plate)
			end			
		end
	end
  end
end)