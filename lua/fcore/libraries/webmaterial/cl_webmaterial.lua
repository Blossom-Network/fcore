FCore.WebMaterial = {}
FCore.WebMaterial.List = {}

function FCore.WebMaterial.Get(url, w, h)
    if not url or not w or not h then return Material("error") end
    if FCore.WebMaterial.List[url] then return FCore.WebMaterial.List[url] end

    local WebPanel = vgui.Create("HTML")
    WebPanel:SetAlpha(0)
    WebPanel:SetSize(tonumber(w), tonumber(h))
	WebPanel:SetHTML([[<html>
		<head>
			<style>
				* { overflow: hidden; }
				body { margin: 0; padding: 0; background: transparent; }
			</style>
		</head>
		<body>
			<img src="]] .. url .. [[" width="]] .. w .. [[px" height="]] .. h .. [[px">
		</body>
	</html>]])

    WebPanel.Paint = function(self)
        if not FCore.WebMaterial.List[url] and self:GetHTMLMaterial() then
            FCore.WebMaterial.List[url] = self:GetHTMLMaterial()
        end
    end

    return Material("error")
end