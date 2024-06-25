if not s0lame then return end

local PANEL = {
	Color = Color(255, 255, 255, 255)
}

--------------------------- Accessors ---------------------------

function PANEL:GetColor()
	return self.Color
end

function PANEL:GetAlpha()
	return IsValid(self.AlphaBar) and self.AlphaBar:GetAlpha() or 255
end

function PANEL:GetDragging()
	return s0lame.GetDragging() and s0lame.GetDraggingObject() == self
end

--------------------------- Modifiers ---------------------------

function PANEL:SetColorButton(NewButton)
	s0lame.CheckValueType(1, NewButton, s0lame.GetType())

	self.ColorButton = NewButton
end

function PANEL:SetColor(NewColor)
	s0lame.CheckValueType(1, NewColor, "Color")

	self.Color = NewColor

	self:OnColorChanged(NewColor)
end

--------------------------- Hooks ---------------------------

function PANEL:PostInit()
	self:SetAutoSize(false)
end

function PANEL:PostParentInit(Parent)
	self.HueBar = s0lame.Create("sColorHueBar", Parent)
	self.HueBar:SetVisible(true)
	self.HueBar:SetColorPicker(self)

	self.AlphaBar = s0lame.Create("sColorAlphaBar", Parent)
	self.AlphaBar:SetVisible(true)
	self.AlphaBar:SetColorPicker(self)
	self.AlphaBar:SetAlpha(self:GetColor().a)

	self:SetSize(75, 75)
end

function PANEL:Paint(x, y, w, h)
	x = x + 1 -- Make room for outline
	y = y + 1
	w = w - 2
	h = h - 2

	surface.SetDrawColor(HSVToColor(self.HueBar:GetHue(), 1, 1))
	surface.DrawRect(x, y, w, h)

	surface.SetDrawColor(s0lame.Colors.White)
	surface.SetMaterial(s0lame.Materials.Gradients.Right)
	surface.DrawTexturedRect(x, y, w, h)

	surface.SetDrawColor(s0lame.Colors.Black)
	surface.SetMaterial(s0lame.Materials.Gradients.Down)
	surface.DrawTexturedRect(x, y, w, h)
end

function PANEL:Think()
	local Focused = s0lame.GetFocusedObject()

	if Focused ~= self and Focused ~= self.HueBar and Focused ~= self.AlphaBar and Focused ~= self:GetParent() then
		self:GetParent():SetVisible(false)
		return
	end

	if self:GetDragging() then
		local X, Y = self:GetPos()
		
		local LeftRight = math.Clamp((gui.MouseX() - X) / self:GetWidth(), 0, 1)
		local TopBottom = math.Clamp((gui.MouseY() - Y) / self:GetHeight(), 0, 1)

		self:SetColor(ColorAlpha(setmetatable(HSVToColor(IsValid(self.HueBar) and self.HueBar:GetHue() or 0, 1 - LeftRight, 1 - TopBottom), s0lame.Registry.Color), self:GetAlpha()))
	end
end

function PANEL:OnLeftClick()
	s0lame.RequestDragging(self)
end

function PANEL:OnSizeChanged(NewWidth, NewHeight)
	if IsValid(self.HueBar) then
		self.HueBar:SetHeight(NewHeight)

		self.HueBar:SetX(self:GetX() + NewWidth + 10)
		self.HueBar:SetY(self:GetY() + 5)

		self.AlphaBar:SetHeight(NewHeight)

		self.AlphaBar:SetX(self.HueBar:GetX() + self.HueBar:GetWidth() + 5)
		self.AlphaBar:SetY(self:GetY() + 5)
	end

	self:BroadcastSizeChange(NewWidth, NewHeight)
end

function PANEL:OnColorChanged(NewColor)
	if IsValid(self.ColorButton) then
		self.ColorButton.Color = NewColor -- Avoid stack overflow
		self.ColorButton:OnColorChanged(NewColor)
	end
end

return s0lame.RegisterElement("sColorPicker", PANEL, "sButton")