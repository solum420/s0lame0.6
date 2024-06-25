if not s0lame then return end

local PANEL = {
	Hue = 0
}

--------------------------- Accessors ---------------------------

function PANEL:GetColorPicker()
	return self.ColorPicker
end

function PANEL:GetHue()
	return self.Hue
end

function PANEL:GetDragging()
	return s0lame.GetDragging() and s0lame.GetDraggingObject() == self
end

--------------------------- Modifiers ---------------------------

function PANEL:SetColorPicker(NewPicker)
	s0lame.CheckValueType(1, NewPicker, s0lame.GetType())

	self.ColorPicker = NewPicker
end

function PANEL:SetHue(NewHue)
	s0lame.CheckValueType(1, NewHue, "number")

	self.Hue = NewHue

	self:OnHueChanged(NewHue)
end

--------------------------- Hooks ---------------------------

function PANEL:PostInit()
	self:SetAutoSize(false)
	self:SetSize(20, 75)
end

function PANEL:Paint(x, y, w, h)
	local Max = 360
	local C = Max
	local Step = Max / h

	Max = math.floor(Max / Step) - 1

	for i = 1, Max do
		C = C - Step

		surface.SetDrawColor(HSVToColor(C, 1, 1))
		surface.DrawLine(x, y + i, x + w, y + i)
	end

	local HY = h - math.Remap(self:GetHue(), 0, 360, 0, h)

	surface.SetDrawColor(self:GetOutlineColor())
	surface.DrawLine(x, y + HY, x + w, y + HY)
end

function PANEL:Think()
	if self:GetDragging() then
		local TopBottom = math.Clamp((gui.MouseY() - self:GetY()) / self:GetHeight(), 0, 1)

		self:SetHue(math.Round(360 - math.Remap(TopBottom, 0, 1, 0, 360)))
	end
end

function PANEL:OnLeftClick()
	s0lame.RequestDragging(self)
end

function PANEL:OnHueChanged(NewHue)
	if IsValid(self.ColorPicker) then
		local _, Saturation, Value = ColorToHSV(self.ColorPicker:GetColor())
		
		self.ColorPicker:SetColor(ColorAlpha(setmetatable(HSVToColor(NewHue, Saturation, Value), s0lame.Registry.Color), self.ColorPicker:GetAlpha()))
	end
end

return s0lame.RegisterElement("sColorHueBar", PANEL, "sButton")