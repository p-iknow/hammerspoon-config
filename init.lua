-- hammerspoon config

-- require('luarocks.loader')
-- require('modules.mouse'):init('f16')
local inputEnglish = "com.apple.nlayout.ABC"
local inputKorean = "com.apple.keylayout.2SetHangul"

local app_man = require('modules.appman')
local app_mode = hs.hotkey.modal.new()

hs.window.animationDuration = 0

function app_toggle(name, secondName)
    if secondName == nil then
        -- FIXME: uuid 말고 대책을 마련하라
        secondName = '85ED2184-ABF5-4924-AE3F-B702622B858D'
    end
    return function()
        local activated = hs.application.frontmostApplication()
        local path = string.lower(activated:path())

        if string.match(path, string.lower(name) .. '%.app$') or string.match(path, string.lower(secondName) .. '%.app$') then
            activated:hide()
            return
        end

        if not hs.application.launchOrFocus(name) then
            hs.application.launchOrFocus(secondName)
        end

        local screen = hs.window.focusedWindow():frame()
        local pt = hs.geometry.rectMidPoint(screen)
        hs.mouse.setAbsolutePosition(pt)
    end
end

hs.hints.hintChars = {
    'q', 'w', 'e', 'r',
    'a', 's', 'd', 'f',
    'z', 'x', 'c', 'v',
    '1', '2', '3', '4',
    'j', 'k',
    'i', 'o',
    'm', ','
}



local event_map = {
    -- hammerspoon 관리
    { key = 'r', mod = { 'shift' }, func = hs.reload },
    -- app_toggle
    { key = 'n', mod = {}, func = app_toggle('Notion') },
    { key = 'm', mod = {}, func = app_toggle('Google Meet') },
    { key = 'c', mod = {}, func = app_toggle('Google Chrome') },
    { key = 'd', mod = {}, func = app_toggle('discord') },
    { key = 'f', mod = {}, func = app_toggle('Finder') },
    { key = 'k', mod = {}, func = app_toggle('KakaoTalk') },
    { key = 'p', mod = {}, func = app_toggle('PDF Expert') },
    { key = 'r', mod = {}, func = app_toggle('draw.io') },
    { key = 's', mod = {}, func = app_toggle('Slack') },
    { key = 'v', mod = {}, func = app_toggle('Visual Studio Code') },
    { key = 'space', mod = {}, func = app_toggle('iTerm') },
    { key = 'tab', mod = {}, func = hs.hints.windowHints },
    { key = 'tab', mod = { 'shift' }, func = hs.window._timed_allWindows },
}

do
    local event_runner = require('modules.event_runner')
    event_runner:init('f4', event_map)
end


-- spoon plugins
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = false

function plugInstall()
    local Install = spoon.SpoonInstall
    Install:updateRepo('default')

    hs.alert.show('plugin installed')
end

require('modules.inputsource_aurora')

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

hs.alert.show('loaded')
