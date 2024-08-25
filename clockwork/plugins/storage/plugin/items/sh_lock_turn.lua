local ITEM = Clockwork.item:New();
	ITEM.name = "Кодовый замок с Поворотным Механизмом";
	ITEM.model = "models/props_wasteland/prison_padlock001a.mdl";
	ITEM.weight = 0.5;
	ITEM.category = "Locks";
	ITEM.description = "Обычный поворотный кодовый замок с цифрами от 0 до 50.";
	ITEM.lockType = "turn";

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local trace = player:GetEyeTraceNoCursor();
		local entity = trace.Entity;
		
		if (IsValid(entity)) then
			cwStorage:ApplyLock(player, self, entity);
		end;
		
		return false;
	end;
ITEM:Register();