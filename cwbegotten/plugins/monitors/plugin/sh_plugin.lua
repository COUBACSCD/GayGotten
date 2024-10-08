PLUGIN:SetGlobalAlias("cas");

Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

if (SERVER) then
	concommand.Add("forceraise", function(player, cmd, args)
		if (player:IsAdmin()) then
			local target = Clockwork.player:FindByID(args[1])
			
			if (target) then
				target:SetWeaponRaised(true);
			end;
		end;
	end);

	concommand.Add("forcelower", function(player, cmd, args)
		if (player:IsAdmin()) then
			local target = Clockwork.player:FindByID(args[1]);
			
			if (target) then
				target:SetWeaponRaised(false);
			end;
		end;
	end);
end;

local COMMAND = Clockwork.command:New("ToggleAFKKicker");
	COMMAND.tip = "Toggle the AFK Kicker.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "s";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if cas.afkKickerEnabled ~= false then
			cas.afkKickerEnabled = false;
			Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." отключил автоматический кик за АФК.");
		else
			cas.afkKickerEnabled = true;
			Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." включил автоматический кик за АФК.");
			
			local curTime = CurTime();
			local playerCount = _player.GetCount();
			
			if player.lastNotInitialized then
				player.lastNotInitialized = curTime + 360;
			end
		end
	end;
COMMAND:Register();