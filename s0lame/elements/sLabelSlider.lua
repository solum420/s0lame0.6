if not s0lame then return end

local PANEL = {
	Slider = nil
}

--------------------------- Accessors ---------------------------

function PANEL:GetMinLong()
	return string.format("%." .. self:GetDecimals() .. "f", self:GetMinValue())
end

function PANEL:GetMaxLong()
	return string.format("%." .. self:GetDecimals() .. "f", self:GetMaxValue())
end

function PANEL:GetBigValueWidth()
	surface.SetFont(self:GetFont())

	local MinLong = self:GetMinLong()
	local MaxLong = self:GetMaxLong()

	local MinW, _ = surface.GetTextSize(MinLong)
	local MaxW, _ = surface.GetTextSize(MaxLong)

	return math.max(MinW, MaxW)
end

--------------------------- Uhhh ---------------------------

function PANEL:AdjustForData()
	if not IsValid(self.Slider) then return end

	surface.SetFont(self:GetFont())

	local tw, _ = surface.GetTextSize(self:GetText())

	self.Slider:SetPos(tw + 3, 0)
	self.Slider:SetSize(self:GetWidth() - tw - self:GetBigValueWidth() - 5, self:GetHeight())
end

--------------------------- Hooks ---------------------------

function PANEL:PostInit()
	self:SetSize(200, 15)
	self:SetText("sSlider")
	self:SetAutoSize(false)

	self.Slider = s0lame.Create("sSlider", self)
	self.Slider:SetClickable(false)
	self.Slider:SetVisible(true)

	self.Slider.OnValueChanged = function(_, NewValue)
		self:SetValue(NewValue)
	end

	self:AdjustForData()
end

function PANEL:PaintBackground(x, y, w, h) end

function PANEL:Paint(x, y, w, h)
	surface.SetFont(self:GetFont())

	local tw, th = surface.GetTextSize(self:GetText())

	draw.DrawText(self:GetText(), self:GetFont(), x + 1, y + (h / 2) - (th / 2), self:GetTextColor(), self:GetTextAlignment())

	_, th = surface.GetTextSize(self:GetValue())

	draw.DrawText(tostring(self:GetValue()), self:GetFont(), x + self.Slider:GetWidth() + tw + 5, y + (h / 2) - (th / 2), self:GetTextColor(), self:GetTextAlignment())
end

function PANEL:PaintOverlay(x, y, w, h) end

function PANEL:Think() end

function PANEL:OnLeftClick()
	if not self:GetDraggable() then return end

	s0lame.RequestDragging(self.Slider)
end

function PANEL:OnValueChanged(NewValue)
	-- For override
end

function PANEL:OnMinMaxChanged(NewMin, NewMax)
	self.Slider:SetMinValue(NewMin)
	self.Slider:SetMaxValue(NewMax)
end

function PANEL:OnTextChanged()
	self:AdjustForData()
end

function PANEL:OnSizeChanged()
	self:AdjustForData()
end

function PANEL:OnHandleColorChanged(NewColor)
	self.Slider:SetHandleColor(NewColor)
end

function PANEL:OnLineColorChanged(NewColor)
	self.Slider:SetLineColor(NewColor)
end

return s0lame.RegisterElement("sLabelSlider", PANEL, "sSlider")