if not s0lame then return end

local PANEL = {}

--------------------------- Hooks ---------------------------

function PANEL:PostInit()
	self:SetText("sButton")
	self:SetTextAlignment(TEXT_ALIGN_CENTER)

	self:SetAutoSize(false)
	self:SetSize(100, 15)
end

function PANEL:PaintBackground(x, y, w, h)
	surface.SetDrawColor(self:GetBackgroundColor())
	surface.DrawRect(x, y, w, h)
end

function PANEL:Paint(x, y, w, h)
	surface.SetFont(self:GetFont())

	local _, th = surface.GetTextSize(self:GetText()) -- draw.DrawText doesn't have yAlign for whatever retarded reason

	draw.DrawText(self:GetText(), self:GetFont(), x + (w / 2), y + (h / 2) - (th / 2), self:GetTextColor(), self:GetTextAlignment())
end

function PANEL:PaintOverlay(x, y, w, h)
	surface.SetDrawColor(self:GetOutlineColor())
	surface.DrawOutlinedRect(x, y, w, h)
end

return s0lame.RegisterElement("sButton", PANEL, "sLabel")