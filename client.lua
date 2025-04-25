local zonasAtivas = {}

RegisterNetEvent("perimetro:add")
AddEventHandler("perimetro:add", function(nome, coords, raio)
    if zonasAtivas[nome] then
        RemoveBlip(zonasAtivas[nome])
    end

    local blip = AddBlipForRadius(coords.x, coords.y, coords.z, raio + 0.0)
    SetBlipAlpha(blip, 150)
    SetBlipColour(blip, 1) -- 1 = vermelho
    zonasAtivas[nome] = blip
end)

RegisterNetEvent("perimetro:remove")
AddEventHandler("perimetro:remove", function(nome)
    if zonasAtivas[nome] then
        RemoveBlip(zonasAtivas[nome])
        zonasAtivas[nome] = nil
    end
end)

RegisterNetEvent("perimetro:requisitarZonas")
AddEventHandler("perimetro:requisitarZonas", function()
    local nomes = {}
    for nome, _ in pairs(zonasAtivas) do
        table.insert(nomes, nome)
    end
    TriggerServerEvent("perimetro:respostaZonas", nomes)
end)
    