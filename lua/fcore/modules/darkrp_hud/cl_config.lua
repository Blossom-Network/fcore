FCore.HUD = FCore.HUD or {}
FCore.HUD.Config = {}

FCore.HUD.Config.Size = {
    w = 325,
    h = 150
}

FCore.HUD.Config.Margin = {
    x = 8,
    y = 8
}

FCore.HUD.Config.Icons = {
    heart = {
        text = utf8.char(0xf004),
        margin = {
            x = 0,
            y = 0
        }
    },
    armor = {
        text = utf8.char(0xf132),
        margin = {
            x = 0,
            y = 0
        }
    },
    suitcase = {
        text = utf8.char(0xf0f2),
        margin = {
            x = 0,
            y = 0
        }
    },
    cash = {
        text = utf8.char(0xf19c),
        margin = {
            x = 0,
            y = 0
        }
    },
    dollar = {
        text = utf8.char(0xf0d6),
        margin = {
            x = 0,
            y = 0
        }
    },
    user = {
        text = utf8.char(0xf007),
        margin = {
            x = 0,
            y = 0
        }
    },
    users = {
        text = utf8.char(0xf0c0),
        margin = {
            x = 0,
            y = 0
        }
    }
}

FCore.HUD.Config.Colors = {
    main = Color(64,64,64,255),
    secondary = Color(48,48,48,255),
    text = Color(192,192,192,255),
    health = Color(255,64,64,255),
    armor = Color(84,84,84,255),
    white = Color(255,255,255,255),
    transparent = Color(255,255,255,0)
}