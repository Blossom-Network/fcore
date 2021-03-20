FCore.Fonts = {}

FCore.Fonts.Create = {
    "FontAwesome",
    "Roboto",
    "Open Sans"
}

FCore.Fonts.Sizes = {
    12,
    14,
    16,
    18,
    24,
    32,
    72
}

FCore.Fonts.Weight = {
    200,
    300,
    400,
    500,
    600,
    700
}

for key,font in ipairs(FCore.Fonts.Create) do
    for _,size in ipairs(FCore.Fonts.Sizes) do
        for __,weight in ipairs(FCore.Fonts.Weight) do
            surface.CreateFont(string.format("FCore_%s_%s_%s", font, size, weight), {
                font = font,
                extended = true,
                size = size,
                weight = weight,
                antialias = true
            })
        end
    end
end