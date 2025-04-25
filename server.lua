local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

local zonasPorJogador = {}

RegisterCommand("perimetro", function(source, args)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Police") then
            local acao = args[1]
            local nome = args[2]
            local raio = tonumber(args[3])

            if acao and nome then
                if acao == "add" and raio then
                    local ped = GetPlayerPed(source)
                    local coords = GetEntityCoords(ped)

                    TriggerClientEvent("perimetro:add", -1, nome, coords, raio)
                    TriggerClientEvent("Notify", source, "verde", "Perímetro criado com sucesso: " .. nome .. " com raio de " .. raio, 5000)
                elseif acao == "remover" then
                    TriggerClientEvent("perimetro:remove", -1, nome)
                    TriggerClientEvent("Notify", source, "verde", "Perímetro removido com sucesso: " .. nome, 5000)
                else
                    TriggerClientEvent("Notify", source, "vermelho", "Uso incorreto. /perimetro [add|remover] [nome] [raio]", 5000)
                end
            else
                TriggerClientEvent("Notify", source, "vermelho", "Uso incorreto. /perimetro [add|remover] [nome] [raio]", 5000)
            end
        else
            TriggerClientEvent("Notify", source, "vermelho", "Você não tem permissão para isso.", 5000)
        end
    else
        TriggerClientEvent("Notify", source, "vermelho", "Você não possui um passaporte válido.", 5000)
    end
end)

RegisterCommand("perimetros", function(source)
    local Passport = vRP.Passport(source)
    if Passport and vRP.HasGroup(Passport, "Police") then
        zonasPorJogador[source] = false
        TriggerClientEvent("perimetro:requisitarZonas", source)

        SetTimeout(500, function()
            local zonas = zonasPorJogador[source]
            if zonas and #zonas > 0 then
                TriggerClientEvent("Notify", source, "azul", "Zonas ativas: " .. table.concat(zonas, ", "), 10000)
            else
                TriggerClientEvent("Notify", source, "amarelo", "Nenhuma zona ativa encontrada.", 5000)
            end
        end)
    end
end)

RegisterNetEvent("perimetro:respostaZonas")
AddEventHandler("perimetro:respostaZonas", function(zonas)
    zonasPorJogador[source] = zonas
end)
