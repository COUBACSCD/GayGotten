--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

local COMMAND = Clockwork.command:New("ContFill")
COMMAND.tip = "Заполните контейнер случайными предметами."
COMMAND.text = "<Плотность чисел: 1-5> [Выберите Категорию]"
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "s"
COMMAND.arguments = 1
COMMAND.optionalArguments = 1

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor()
	local scale = tonumber(arguments[1])

	if (scale) then
		scale = math.Clamp(math.Round(scale), 1, 5)

		if (IsValid(trace.Entity)) then
			if (Clockwork.entity:IsPhysicsEntity(trace.Entity)) then
				local model = string.lower(trace.Entity:GetModel())

				if (cwStorage.containerList[model]) then
					if (!trace.Entity.cwInventory) then
						cwStorage.storage[trace.Entity] = trace.Entity

						trace.Entity.cwInventory = {}
					end

					local containerWeight = cwStorage.containerList[model][1] / (6 - scale)
					local weight = Clockwork.inventory:CalculateWeight(trace.Entity.cwInventory)

					if (!arguments[2] or cwStorage:CategoryExists(arguments[2])) then
						while (weight < containerWeight) do
							local randomItem = cwStorage:GetRandomItem(arguments[2])

							if (randomItem) then
								Clockwork.inventory:AddInstance(
									trace.Entity.cwInventory, item.CreateInstance(randomItem[1])
								)

								weight = weight + randomItem[2]
							end
						end

						cwStorage:SaveStorage()

						Schema:EasyText(player, "cornflowerblue", "["..self.name.."] Теперь этот контейнер заполнен случайными предметами!")
						return
					else
						Schema:EasyText(player, "grey", "["..self.name.."] Такой категории не существует!")
						return
					end
				end

				Schema:EasyText(player, "grey", "["..self.name.."] Это недействительный контейнер!")
			else
				Schema:EasyText(player, "grey", "["..self.name.."] Это недействительный контейнер!")
			end
		else
			Schema:EasyText(player, "grey", "["..self.name.."] Это недействительный контейнер!")
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] Это недействительная шкала!")
	end
end

COMMAND:Register()

local COMMAND = Clockwork.command:New("ContClear")
COMMAND.tip = "Убрать предметы из контейнера."
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "s"

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor()

	if (IsValid(trace.Entity)) then
		if (Clockwork.entity:IsPhysicsEntity(trace.Entity)) then
			local model = string.lower(trace.Entity:GetModel())

			if (cwStorage.containerList[model]) then
				if (trace.Entity.cwCash) then
					trace.Entity.cwCash = 0;
				end
			
				if (trace.Entity.cwInventory) then
					trace.Entity.cwInventory = {}
				end
				
				Schema:EasyText(player, "grey", "Теперь этот контейнер пуст!");

				return;
			end

			Schema:EasyText(player, "grey", "["..self.name.."] Это недействительный контейнер!")
		else
			Schema:EasyText(player, "grey", "["..self.name.."] Это недействительный контейнер!")
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] Это недействительный контейнер!")
	end
end

COMMAND:Register()