if not s0lame then return end

local PANEL = {
	Color = Color(255, 255, 255, 255)
}

--------------------------- Accessors ---------------------------

function PANEL:GetColor()
	return self.ColorPicker:GetColor()
end

--------------------------- Modifiers ---------------------------

function PANEL:SetColor(NewColor)
	s0lame.CheckValueType(1, NewColor, "Color")

	self.ColorPicker:SetColor(NewColor)
end

--------------------------- Hooks ---------------------------

function PANEL:PostInit()
	self:SetAutoSize(false)
	self:SetSize(15, 15)
	self:SetBackgroundColor(s0lame.Colors.ControlDark)

	self.ColorPickerPanel = s0lame.Create("sPanel")
	self.ColorPickerPanel:SetSize(135, 85)

	self.ColorPicker = s0lame.Create("sColorPicker", self.ColorPickerPanel)
	self.ColorPicker:SetSize(75, 75)
	self.ColorPicker:SetPos(5, 5)
	self.ColorPicker:SetVisible(true)
	self.ColorPicker:SetColorButton(self)
end

function PANEL:Paint(x, y, w, h)
	surface.SetDrawColor(self:GetColor())
	surface.DrawRect(x, y, w, h)
end

function PANEL:OnLeftClick()
	if self.ColorPickerPanel:GetVisible() then
		s0lame.SetFocusedObject(self:GetParent())
	else
		s0lame.SetFocusedObject(self.ColorPickerPanel)
		self.ColorPickerPanel:SetPos(self:GetX(), self:GetY() + self:GetHeight() + 5)
		self.ColorPickerPanel:SetVisible(true)
	end
end

function PANEL:OnColorChanged(NewColor)
	-- For override
end

return s0lame.RegisterElement("sColorButton", PANEL, "sButton")