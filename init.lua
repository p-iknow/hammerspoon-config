-- hammerspoon config

-- require('luarocks.loader')
-- require('modules.mouse'):init('f16')
local inputEnglish = "com.apple.nlayout.ABC"
local inputKorean = "com.apple.keylayout.2SetHangul"



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

local event_map = {
    { key = 'r', mod = 'option', func = hs.reload },
    -- app_toggle
    { key = ',', mod = '', func = app_toggle('System Preferences'), msg = 'System Preferences' },
    { key = 'n', mod = "", func = app_toggle('Notion') },
    { key = 'm', mod = "", func = app_toggle('Google Chat') },
    { key = 'c', mod = "", func = app_toggle('Google Chrome') },
    { key = 'd', mod = "", func = app_toggle('discord') },
    { key = 'f', mod = "", func = app_toggle('Figma') },
    { key = 'f', mod = "option", func = app_toggle('Finder') },
    { key = 'k', mod = "", func = app_toggle('KakaoTalk') },
    { key = 'p', mod = "", func = app_toggle('PDF Expert') },
    { key = 'r', mod = "", func = app_toggle('draw.io') },
    { key = 's', mod = "", func = app_toggle('Slack') },
    { key = 'v', mod = "", func = app_toggle('Visual Studio Code') },
    { key = 'space', mod = "", func = app_toggle('iTerm') },
}

function event_runner(func_table)
    for i, v in pairs(func_table) do
        -- hs.alert.show(i)
        local key = v['key']
        local mod = v['mod']
        local func = v['func']
        hs.hotkey.bind({ 'cmd', 'shift', mod }, key, func)
    end
end

event_runner(event_map)

function reloadConfig(files)
    doReload = false
    for _, file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end

myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")
