-- https://steamcommunity.com/sharedfiles/filedetails/?id=650064006

local ScreenPos = ScrH() - (FCore.HUD.Config.Size.h + FCore.HUD.Config.Margin.y) - 84

local Colors = {}
Colors[ NOTIFY_GENERIC ] = Color( 52, 73, 94 )
Colors[ NOTIFY_ERROR ] = Color( 192, 57, 43 )
Colors[ NOTIFY_UNDO ] = Color( 41, 128, 185 )
Colors[ NOTIFY_HINT ] = Color( 39, 174, 96 )
Colors[ NOTIFY_CLEANUP ] = Color( 243, 156, 18 )

local LoadingColor = Color( 22, 160, 133 )

local Icons = {}
Icons[ NOTIFY_GENERIC ]	= Material( "vgui/notices/generic" )
Icons[ NOTIFY_ERROR ] = Material( "vgui/notices/error" )
Icons[ NOTIFY_UNDO ] = Material( "vgui/notices/undo" )
Icons[ NOTIFY_HINT ] = Material( "vgui/notices/hint" )
Icons[ NOTIFY_CLEANUP ]	= Material( "vgui/notices/cleanup" )

local LoadingIcon = Material( "notifications/loading.png" )

local Notifications = {}

local function DrawNotification( x, y, w, h, text, icon, col )
	draw.RoundedBox( 4, x, y, w, h, FCore.Colors.secondary )

	draw.SimpleText( utf8.char(0xf129), "FCore_FontAwesome_18_300", x + 10, y + h / 2 + 1, FCore.Colors.text,
		TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

	draw.SimpleText( text, "FCore_Open Sans_14_300", x + w - 8, y + h / 2, FCore.Colors.text,
		TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

	surface.SetDrawColor( FCore.Colors.secondary )
end

function notification.AddLegacy( text, type, time )
	surface.SetFont( "FCore_Open Sans_14_300" )

	local w = surface.GetTextSize( text ) + 32
	local h = 48
	local x = -w + 8
	local y = ScreenPos

	table.insert( Notifications, 1, {
		x = x,
		y = y,
		w = w,
		h = h,

		text = text,
		col = Colors[ type ],
		icon = Icons[ type ],
		time = CurTime() + time,

		progress = nil,
	} )
end

function notification.AddProgress( id, text, frac )
	for k, v in ipairs( Notifications ) do
		if v.id == id then
			v.text = text
			v.progress = frac
			return
		end
	end

	surface.SetFont( "FCore_Open Sans_14_300" )

	local w = surface.GetTextSize( text ) + 32
	local h = 48
	local x = ScrW()
	local y = ScreenPos

	table.insert( Notifications, 1, {
		x = x,
		y = y,
		w = w,
		h = h,

		id = id,
		text = text,
		col = LoadingColor,
		icon = LoadingIcon,
		time = math.huge,

		progress = math.Clamp( frac or 0, 0, 1 ),
	})
end

function notification.Kill( id )
	for k, v in ipairs( Notifications ) do
		if v.id == id then v.time = 0 end
	end
end

hook.Add( "HUDPaint", "DrawNotifications", function()
	for k, v in ipairs( Notifications ) do
		DrawNotification( math.floor( v.x ), math.floor( v.y ), v.w, v.h, v.text, v.icon, v.col, v.progress )

		v.x = Lerp( FrameTime() * 10, v.x, v.time > CurTime() and 16 or -v.w )
		v.y = Lerp( FrameTime() * 10, v.y, ScreenPos - ( k - 1 ) * ( v.h + 5 ) )
	end

	for k, v in ipairs( Notifications ) do
		if v.x >= ScrW() and v.time < CurTime() then
			table.remove( Notifications, k )
		end
	end
end )
