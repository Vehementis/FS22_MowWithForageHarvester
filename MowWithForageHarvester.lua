MowWithForageHarvester = {};

function MowWithForageHarvester:loadMap(name)
	print("MowWithForageHarvester:loadMap")
    MissionManager.getIsMissionWorkAllowed = Utils.overwrittenFunction(MissionManager.getIsMissionWorkAllowed, MowWithForageHarvester.getIsMissionWorkAllowed);
	MowWithForageHarvester.addFruitTypeToCategory("MEADOW", "DIRECTCUTTER")
	MowWithForageHarvester.literPerSqmFix("GRASS")
	MowWithForageHarvester.literPerSqmFix("MEADOW")
	MowWithForageHarvester.addFruitTypeConversion("FORAGEHARVESTER", "MEADOW", "GRASS_WINDROW", 1.0, 1.0)
	print("MowWithForageHarvester:loadMap DONE")
end; 

function MowWithForageHarvester:getIsMissionWorkAllowed(superFunc, farmId, x, z, workAreaType)
    return superFunc(self, farmId, x, z, workAreaType) or (workAreaType == WorkAreaType.CUTTER and superFunc(self, farmId, x, z, WorkAreaType.MOWER)) or (workAreaType == WorkAreaType.FORAGEWAGON and superFunc(self, farmId, x, z, WorkAreaType.BALER));
end

function MowWithForageHarvester.literPerSqmFix (fruitTypeName)
	print("MowWithForageHarvester:literPerSqmFix "..fruitTypeName)
	local fruitType = g_fruitTypeManager:getFruitTypeByName(fruitTypeName)
	if fruitType ~= nil then
		fruitType.literPerSqm = fruitType.windrowLiterPerSqm
        print("MowWithForageHarvester:literPerSqmFix setting "..fruitTypeName.." literPerSqm to "..fruitType.literPerSqm)
    end
end

function MowWithForageHarvester.addFruitTypeToCategory(fruitTypeName, categoryName)
	print("MowWithForageHarvester:addFruitTypeToCategory "..fruitTypeName.." "..categoryName)
    local categoryIndex = g_fruitTypeManager.categories[categoryName]
	local fruitType = g_fruitTypeManager:getFruitTypeByName(fruitTypeName)
    if fruitType ~= nil and categoryIndex ~= nil then
        if g_fruitTypeManager:addFruitTypeToCategory(fruitType.index, categoryIndex) then
            print("MowWithForageHarvester:addFruitTypeToCategory added "..fruitTypeName.." to "..categoryName)
		else 
			print("MowWithForageHarvester:addFruitTypeToCategory Error "..fruitTypeName.." "..categoryName)
        end
    end
end

function MowWithForageHarvester.addFruitTypeConversion(converterName, fruitTypeName, fillTypeName, conversionFactor, windrowConversionFactor)
	print("MowWithForageHarvester:addFruitTypeConversion "..converterName.." "..fruitTypeName.." "..fillTypeName)
	local converterIndex = g_fruitTypeManager.converterNameToIndex[converterName]
	local fruitType = g_fruitTypeManager:getFruitTypeByName(fruitTypeName)
	local fillType = g_fillTypeManager:getFillTypeByName(fillTypeName)
	if fruitType ~= nil and fillType ~= nil and converterIndex ~= nil then
		g_fruitTypeManager:addFruitTypeConversion(converterIndex, fruitType.index, fillType.index, conversionFactor, windrowConversionFactor)
	else
		print("MowWithForageHarvester:addFruitTypeConversion Error "..converterIndex.." "..fruitType.index.." "..fillType.index)
	end
end

function MowWithForageHarvester.init()
	addModEventListener(MowWithForageHarvester);
end

MowWithForageHarvester.init()