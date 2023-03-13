if mods["space-exploration"] then 
    table.insert(data.raw.technology["teleportation-equipment"].prerequisites, {"se-teleportation"})
end

if mods["power-armour-replacer"] then 
    table.insert(data.raw.technology["teleportation-equipment"].prerequistes, {"solar_1"})
end