if not s0lame then return end

local PANEL = {
	Checked = false
}

--------------------------- Accessors ---------------------------

function PANEL:GetChecked()
	return self.Checked
end

--------------------------- Modifiers ---------------------------

function PANEL:SetChecked(NewState)
	s0lame.CheckValueType(1, NewState, "boolean")

	self.Checked = NewState

	self:OnValueChanged(NewState)
end

--------------------------- Hooks ---------------------------

function PANEL:PostInit()
	self:SetText("sCheckBox")
	self:SetAutoSize(true)

	surface.SetFont(self:GetFont())
	
	local tw, _ = surface.GetTextSize(self:GetText())

	self:SetSize(tw + 18, 15)
end

function PANEL:OnTextChanged(_, NewText)
	if self:GetAutoSize() then
		surface.SetFont(self:GetFont())

		local tw, _ = surface.GetTextSize(self:GetText())

		self:SetSize(tw + 18, 15)
	end
end

function PANEL:PaintBackground(x, y, w, h)
	surface.SetDrawColor(self:GetBackgroundColor())
	surface.DrawOutlinedRect(x, y, h, h)
end

function PANEL:Paint(x, y, w, h)
	surface.SetFont(self:GetFont())

	local _, th = surface.GetTextSize(self:GetText())

	draw.DrawText(self:GetText(), self:GetFont(), x + h + 3, y + (h / 2) - (th / 2), self:GetTextColor(), self:GetTextAlignment())

	self:PaintCheck(x, y, w, h)
end

function PANEL:PaintCheck(x, y, w, h)
	-- For override

	surface.SetDrawColor(s0lame.Colors.ControlDark)
	surface.DrawRect(x, y, h, h)

	if self:GetChecked() then
		surface.SetDrawColor(s0lame.Colors.White)
	surface.DrawRect(x + 3, y + 3, h - 6, h - 6)
	end
end

function PANEL:PaintOverlay(x, y, w, h)
	surface.SetDrawColor(self:GetOutlineColor())
	surface.DrawOutlinedRect(x, y, h, h)
end

function PANEL:OnLeftClick()
	self:SetChecked(not self:GetChecked())
end

function PANEL:OnValueChanged(NewValue)
	-- For override
end

return s0lame.RegisterElement("sCheckBox", PANEL, "sButton")