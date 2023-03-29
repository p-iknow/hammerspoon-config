-- hammerspoon config

-- require('luarocks.loader')
-- require('modules.mouse'):init('f16')
require('modules.inputsource_aurora')

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
    -- app_toggle
    { key = ',', mod = '', func = app_toggle('System Preferences'), msg = 'System Preferences' },
    { key = 'n', mod = "", func = app_toggle('Notion') },
    { key = 'a', mod = "", func = app_toggle('Safari Technology Preview')},
    { key = 'm', mod = "", func = app_toggle('Simulator') },
    { key = 'c', mod = "", func = app_toggle('Google Chrome') },
    { key = 'd', mod = "", func = app_toggle('Deepl') },
    { key = 'i', mod = "", func = app_toggle('Figma') },
    { key = 'k', mod = "", func = app_toggle('Keynote') },
    { key = 'p', mod = "", func = app_toggle('PDF Expert') },
    { key = 's', mod = "", func = app_toggle('Slack') },
    { key = 'v', mod = "", func = app_toggle('Visual Studio Code') },
    { key = 't', mod = "", func = app_toggle('TickTick') },

    { key = 'y', mod = "", func = app_toggle('YT Music') },
    { key = 'space', mod = "", func = app_toggle('iTerm') },
}

function event_runner(func_table)
    for i, v in pairs(func_table) do
        -- hs.alert.show(i)
        local key = v['key']
        local mod = v['mod']
        local func = v['func']
        hs.hotkey.bind({ 'option', mod }, key, func)
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
