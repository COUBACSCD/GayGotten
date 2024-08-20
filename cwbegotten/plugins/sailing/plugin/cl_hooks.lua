--[[
	Begotten III: Jesus Wept
--]]

local cwSailing = cwSailing;

function cwSailing:GetProgressBarInfoAction(action, percentage)
	if (action == "burn_longship") then
		return {text = "You are setting the longship alight. Click to cancel.", percentage = percentage, flash = percentage < 10};
	elseif (action == "extinguish_longship") then
		return {text = "You are trying to put out the flames. Click to cancel.", percentage = percentage, flash = percentage < 10};
	elseif (action == "repair_longship") then
		return {text = "You are making repairs to the longship. Click to cancel.", percentage = percentage, flash = percentage < 10};
	elseif (action == "repair_alarm") then
		return {text = "You are repairing the Gorewatch alarm. Click to cancel.", percentage = percentage, flash = percentage < 10};
	end
end

-- Called when the local player's item menu should be adjusted.
function cwSailing:PlayerAdjustItemMenu(itemTable, menuPanel, itemFunctions)
	if (itemTable.uniqueID == "scroll_longship") then
		if Clockwork.Client:GetFaction() == "Goreic Warrior" and Clockwork.Client:GetZone() == "gore" then
			if (game.GetMap() != "rp_begotten3") then
				return;
			end;
			
			menuPanel:AddOption("Dock", function()
				Clockwork.inventory:InventoryAction("dock", itemTable.uniqueID, itemTable.itemID);
			end);

			menuPanel:AddOption("Undock", function()
				Clockwork.inventory:InventoryAction("undock", itemTable.uniqueID, itemTable.itemID);
			end);
			
			menuPanel:AddOption("Rename", function()
				Clockwork.inventory:InventoryAction("rename", itemTable.uniqueID, itemTable.itemID);
			end);
		end
	end
end;

function cwSailing:SubModifyItemMarkupTooltip(category, maximumWeight, weight, condition, percentage, name, itemTable, x, y, width, height, frame, bShowWeight)
	if category == "Naval" then
		local health = itemTable:GetData("health");
		
		if health then
			frame:AddText("Longship Health: "..tostring(health), Color(180, 20, 20), "nov_IntroTextSmallDETrooper", 1.15);
		end
	end
end

function cwSailing:CreateMenu(ignitable, ignited, repairable, sailable, destination, cargoholdopenable)
	if (IsValid(menu)) then
		menu:Remove();
	end;
	
	local scrW = ScrW();
	local scrH = ScrH();
	local menu = DermaMenu();
	local isAdmin = Clockwork.Client:IsAdmin();
	local zone = Clockwork.Client:GetZone();
		
	menu:SetMinimumWidth(150);
	
	if ignitable then
		if !ignited and !destination then
			if Clockwork.Client:GetFaction() ~= "Goreic Warrior" then
				local activeWeapon = Clockwork.Client:GetActiveWeapon();
				
				if IsValid(activeWeapon) and activeWeapon:GetClass() == "cw_lantern" and Clockwork.Client:IsWeaponRaised(activeWeapon) then
					local oil = Clockwork.Client:GetNetVar("oil", 0);
				
					--if oil >= 75 then
					if oil >= 1 then
						menu:AddOption("Burn", function() Clockwork.Client:ConCommand("cw_BurnShip") end);
					end
				end
			end
		end
	end
	
	if isAdmin or cargoholdopenable then
		menu:AddOption("Cargo Hold", function() Clockwork.Client:ConCommand("cw_CargoHold") end);
	end
	
	menu:AddOption("Examine", function() Clockwork.Client:ConCommand("cw_CheckShipStatus") end);
	
	if ignited then
		menu:AddOption("Extinguish", function() Clockwork.Client:ConCommand("cw_ExtinguishShip") end);
	end
	
	if repairable then
		menu:AddOption("Repair", function() Clockwork.Client:ConCommand("cw_RepairShip") end);
	end
	
	if sailable or (isAdmin and !destination) then
		local submenu = menu:AddSubMenu("Sail", function() end);
			
		if zone ~= "gore" then
			submenu:AddOption("Sail through the High Seas to the Goreic Forest", function() Clockwork.Client:ConCommand("cw_MoveShipGoreForest") end);
		end
			
		if zone ~= "wasteland" then
			submenu:AddOption("Sail through the High Seas to the Glazic Wasteland", function() Clockwork.Client:ConCommand("cw_MoveShipWasteland") end);
			submenu:AddOption("Sail through the River Styx to the Lava Coast", function() Clockwork.Client:ConCommand("cw_MoveShipLava") end);
		end
			
		if zone ~= "hell" then
			submenu:AddOption("Sail through the River Styx to Hell", function() Clockwork.Client:ConCommand("cw_MoveShipHell") end);
		end
	end
	
	if isAdmin then
		menu:AddOption("(ADMIN) Toggle River Styx Enchantment", function() Clockwork.Client:ConCommand("cw_ShipToggleEnchantment") end);
	
		if zone == "sea_calm" or zone == "sea_rough" or zone == "sea_styx" then
			menu:AddOption("(ADMIN) Speed to Destination", function() Clockwork.Client:ConCommand("cw_ShipTimerSpeed") end);
			menu:AddOption("(ADMIN) Toggle Timer", function() Clockwork.Client:ConCommand("cw_ShipTimerPause") end);
		end
	end
	
	menu:Open();
	
	menu:SetPos(scrW / 2 - (menu:GetWide() / 2), scrH / 2 - (menu:GetTall() / 2));
end

netstream.Hook("OpenAlarmMenu", function(alarmEnt)
	if IsValid(alarmEnt) then
		if (IsValid(menu)) then
			menu:Remove();
		end;
		
		local scrW = ScrW();
		local scrH = ScrH();
		local menu = DermaMenu();
		
		menu:SetMinimumWidth(150);
		
		menu:AddOption("Examine", function()
			Schema:EasyText("skyblue", "A jury-rigged alarm system with seismic sensors set to activate an alarm should a Goreic longship arrive. Note that the alarm is not powerful enough to be heard from the Tower of Light, and will only sound if Gorewatch has an occupying garrison.");
		end);
		
		if alarmEnt:GetNWBool("broken") then
			menu:AddOption("Repair", function() Clockwork.Client:ConCommand("cw_RepairGorewatchAlarm") end);
		end
		
		menu:Open();
		menu:SetPos(scrW / 2 - (menu:GetWide() / 2), scrH / 2 - (menu:GetTall() / 2));
	end
end);

netstream.Hook("OpenLongshipMenu", function(ignitable, ignited, repairable, sailable, destination, cargoholdopenable)
	cwSailing:CreateMenu(ignitable, ignited, repairable, sailable, destination, cargoholdopenable);
end);

netstream.Hook("DrowningCutscene", function(data)
	CreateSound(Clockwork.Client, "begotten/score5.mp3"):PlayEx(1, 100);
end);