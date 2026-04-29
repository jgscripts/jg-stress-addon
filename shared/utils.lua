local Config = lib.require('config.config')

local function resolveFramework()
    if GetResourceState('qbx_core') == 'started' then
        return 'qbx'
    elseif GetResourceState('qb-core') == 'started' then
        return 'qb'
    elseif GetResourceState('es_extended') == 'started' then
        return 'esx'
    else
        return ''
    end
end

local framework = resolveFramework()

function InitFramework()
    return framework
end

function DebugPrint(fmt, ...)
    if Config.Debug then
        print('[DEBUG]' .. string.format(fmt, ...))
    end
end

function GetPlayer(src)
    if framework == 'qbx' then
        return exports.qbx_core:GetPlayer(src)
    elseif framework == 'qb' then
        return exports['qb-core']:GetPlayer(src)
    elseif framework == 'esx' then
        local ESX = exports.es_extended:getSharedObject()
        return ESX.GetPlayerFromId(src)
    else
        return nil
    end
end
