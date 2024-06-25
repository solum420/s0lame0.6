if not s0lame then return end

local PANEL = {
	Alpha = 255
}

--------------------------- Accessors ---------------------------

function PANEL:GetColorPicker()
	return self.ColorPicker
end

function PANEL:GetAlpha()
	return self.Alpha
end

function PANEL:GetDragging()
	return s0lame.GetDragging() and s0lame.GetDraggingObject() == self
end

--------------------------- Modifiers ---------------------------

function PANEL:SetColorPicker(NewPicker)
	s0lame.CheckValueType(1, NewPicker, s0lame.GetType())

	self.ColorPicker = NewPicker
end

function PANEL:SetAlpha(NewAlpha)
	s0lame.CheckValueType(1, NewAlpha, "number")

	self.Alpha = NewAlpha

	self:OnAlphaChanged(NewAlpha)
end

--------------------------- Hooks ---------------------------

function PANEL:PostInit()
	self:SetAutoSize(false)
	self:SetSize(20, 75)
end

function PANEL:Paint(x, y, w, h)
	local Max = 255
	local C = Max
	local Step = Max / h

	Max = math.floor(Max / Step) - 1

	for i = 1, Max do
		C = C - Step

		surface.SetDrawColor(0, 0, 0, C)
		surface.DrawLine(x, y + i, x + w, y + i)
	end

	local HY = h - math.Remap(self:GetAlpha(), 0, 255, 0, h)

	surface.SetDrawColor(self:GetOutlineColor())
	surface.DrawLine(x, y + HY, x + w, y + HY)
end

function PANEL:Think()
	if self:GetDragging() then
		local TopBottom = 1 - math.Clamp((gui.MouseY() - self:GetY()) / self:GetHeight(), 0, 1)

		self:SetAlpha(math.Round(math.Remap(TopBottom, 0, 1, 0, 255)))
	end
end

function PANEL:OnLeftClick()
	s0lame.RequestDragging(self)
end

function PANEL:OnAlphaChanged(NewAlpha)
	if IsValid(self.ColorPicker) then
		self.ColorPicker:SetColor(ColorAlpha(self.ColorPicker:GetColor(), self:GetAlpha()))
	end
end

return s0lame.RegisterElement("sColorAlphaBar", PANEL, "sButton")