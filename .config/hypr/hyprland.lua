-- monitor

hl.monitor({
    output = "",
    mode = "highrr",
    position = "auto",
    scale = 1,
})


-- programs

local home = os.getenv("HOME")

local defaults = {
    terminal = "kitty",
    fileManager = "dolphin",
    menu = "rofi -show drun -show-icons",
    browser = "firefox",
    notifications = "mako",
    bar = "waybar",
}


-- autostart

local system_autostart = {
    defaults.bar,
    defaults.notifications,
    "systemctl --user start hyprpolkitagent",
    "mpvpaper -o 'no-audio --loop-playlist --hwdec=auto' '*' " .. home .. "/.config/hypr/wallpaper.mp4",
    "sh -c 'for _ in $(seq 30); do wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.65 2>/dev/null && exit; sleep 0.2; done'",
}

local user_autostart = {
    "Telegram",
    "discord",
    "happ",
}

local function exec_all(list)
    for _, cmd in ipairs(list) do
        hl.exec_cmd(cmd)
    end
end

hl.on("hyprland.start", function ()
    exec_all(system_autostart)
    exec_all(user_autostart)
end)


-- environment variables

hl.env("XCURSOR_SIZE", "18")
hl.env("HYPRCURSOR_SIZE", "18")


-- look and feel

hl.config({
    general = {
        gaps_in = 8,
        gaps_out = 16,
        border_size = 2,
        col = {
            active_border = {
                colors = { "rgba(1793d1ee)", "rgba(38bdf8ee)" },
                angle = 45,
            },
            inactive_border = "rgba(18223088)",
        },
        resize_on_border = true,
        allow_tearing = false,
        layout = "scrolling",
    },

    scrolling = {
        column_width = 0.75,
        direction = "right",
        fullscreen_on_one_column = false,
        focus_fit_method = 0,
        follow_focus = true,
        explicit_column_widths = "0.5, 0.75, 1.0",
        wrap_focus = true,
        wrap_swapcol = true,
    },

    decoration = {
        rounding = 12,
        rounding_power = 2,
        active_opacity = 0.88,
        inactive_opacity = 0.72,
        shadow = {
            enabled = true,
            range = 26,
            render_power = 3,
            color = 0x77060d18,
        },
        blur = {
            enabled = true,
            size = 8,
            passes = 4,
            noise = 0.02,
            contrast = 0.98,
            brightness = 0.90,
            vibrancy = 0.35,
            vibrancy_darkness = 0.1,
            new_optimizations = true,
            popups = true,
        },
    },

    animations = {
        enabled = true,
    },
})


-- curves & springs

hl.curve("snapOut", {
    type = "bezier",
    points = {
        { 0.16, 1 },
        { 0.3, 1 },
    },
})

hl.curve("bouncyFluid", {
    type = "spring",
    mass = 0.75,
    stiffness = 190,
    dampening = 14,
})

hl.curve("snappyPop", {
    type = "spring",
    mass = 0.55,
    stiffness = 240,
    dampening = 15,
})

hl.curve("spaceSpring", {
    type = "spring",
    mass = 0.9,
    stiffness = 170,
    dampening = 16,
})

hl.curve("fastSpring", {
    type = "spring",
    mass = 0.55,
    stiffness = 290,
    dampening = 22,
})


-- animations

hl.animation({
    leaf = "global",
    enabled = true,
    speed = 4.0,
    bezier = "snapOut",
})

hl.animation({
    leaf = "border",
    enabled = true,
    speed = 2.0,
    bezier = "snapOut",
})

hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 4.2,
    spring = "bouncyFluid",
})

hl.animation({
    leaf = "windowsMove",
    enabled = true,
    speed = 4.4,
    spring = "bouncyFluid",
})

hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 3.8,
    spring = "snappyPop",
    style = "popin 75%",
})

hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 2.0,
    bezier = "snapOut",
    style = "popin 80%",
})

hl.animation({
    leaf = "fadeIn",
    enabled = true,
    speed = 2.0,
    bezier = "snapOut",
})

hl.animation({
    leaf = "fadeOut",
    enabled = true,
    speed = 1.6,
    bezier = "snapOut",
})

hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 5.0,
    spring = "fastSpring",
    style = "slidevert",
})

-- input

hl.config({
    input = {
        kb_layout = "us,ru",
        kb_variant = "",
        kb_options = "grp:alt_shift_toggle",
        follow_mouse = 1,
        sensitivity = 0,
        
        touchpad = {
            natural_scroll = false,
        },
    },
})


-- keybindings

local mainMod = "SUPER"

-- default
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(defaults.terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(defaults.fileManager))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(defaults.menu))
hl.bind(mainMod .. " + J", hl.dsp.exec_cmd(defaults.browser))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))


-- навигация стрелками
hl.bind(mainMod .. " + left", hl.dsp.layout("focus l"))
hl.bind(mainMod .. " + right", hl.dsp.layout("focus r"))
hl.bind(mainMod .. " + up", hl.dsp.layout("focus u"))
hl.bind(mainMod .. " + down", hl.dsp.layout("focus d"))

-- навигация колесиком
hl.bind(mainMod .. " + mouse_down", hl.dsp.layout("move +col"))
hl.bind(mainMod .. " + mouse_up", hl.dsp.layout("move -col"))

-- перемещение/ресайз мышью
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- перемещение/ресайз стрелками
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.layout("swapcol r"))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.swap({ direction = "down" }))
hl.bind(mainMod .. " + equal", hl.dsp.layout("colresize +conf"))
hl.bind(mainMod .. " + minus", hl.dsp.layout("colresize -conf"))

-- распределение окон
hl.bind(mainMod .. " + CONTROL + down", hl.dsp.layout("consume"))
hl.bind(mainMod .. " + CONTROL + up", hl.dsp.layout("expel"))
hl.bind(mainMod .. " + Space", hl.dsp.layout("consume_or_expel next"))

-- воркспейсы
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + " .. key, hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/workspace_anim.sh " .. i))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("grimblast --notify --freeze copysave area"))

-- медиа
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })


-- windows and workspaces

hl.layer_rule({
    match = { namespace = "waybar" },
    blur = true,
    ignore_alpha = 0.2
})
hl.layer_rule({
    match = { namespace = "rofi" },
    blur = true,
    ignore_alpha = 0.2,
    animation = "slide bottom",
})
hl.layer_rule({
    match = { namespace = "notifications" },
    blur = true,
    ignore_alpha = 0.2
})

hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})
hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})
