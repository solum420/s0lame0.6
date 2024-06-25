if not s0lame then return end

local PANEL = {
	Draggable = true,

	Value = 0,
	Min = 0,
	Max = 100,
	Decimals = 0,

	HandleX = 0,
	HandleWidth = 3,
	HandleColor = s0lame.Colors.Control,
	BackgroundColor = s0lame.Colors.ControlDark,

	LineColor = s0lame.Colors.Control
}

--------------------------- Accessors ---------------------------

function PANEL:GetDraggable()
	return self.Draggable
end

function PANEL:GetDragging()
	return s0lame.GetDragging() and s0lame.GetDraggingObject() == self
end

function PANEL:GetValue()
	return self.Value
end

function PANEL:GetMinValue()
	return self.Min
end

function PANEL:GetMaxValue()
	return self.Max
end

function PANEL:GetDecimals()
	return self.Decimals
end

function PANEL:GetHandleX() -- Internal
	return self.HandleX
end

function PANEL:GetHandleWidth() -- Internal
	return self.HandleWidth
end

function PANEL:GetHandleColor()
	return self.HandleColor
end

function PANEL:GetLineColor()
	return self.LineColor
end

--------------------------- Modifiers ---------------------------

function PANEL:SetDraggable(NewState)
	s0lame.CheckValueType(1, NewState, "boolean")

	self.Draggable = NewState
end

function PANEL:SetValue(NewValue)
	s0lame.CheckValueType(1, NewValue, "number")

	self.Value = math.Clamp(math.Round(NewValue, self:GetDecimals()), self:GetMinValue(), self:GetMaxValue())

	self:OnValueChanged(self:GetValue())
end

function PANEL:SetMinValue(NewValue)
	s0lame.CheckValueType(1, NewValue, "number")

	local NewMin = math.Round(NewValue, self:GetDecimals())

	if NewMin > self:GetMaxValue() then
		return s0lame.Error("Bad argument #1 to 'SetMinValue' (Min can't be greater than max)")
	end

	self.Min = NewMin

	self:OnMinMaxChanged(self:GetMinValue(), self:GetMaxValue())
end

function PANEL:SetMaxValue(NewValue)
	s0lame.CheckValueType(1, NewValue, "number")

	local NewMax = math.Round(NewValue, self:GetDecimals())

	if NewMax < self:GetMinValue() then
		return s0lame.Error("Bad argument #1 to 'SetMaxValue' (Max can't be less than min)")
	end

	self.Max = NewMax

	self:OnMinMaxChanged(self:GetMinValue(), self:GetMaxValue())
end

function PANEL:SetDecimals(NewValue)
	s0lame.CheckValueType(1, NewValue, "number")

	self.Decimals = math.Round(NewValue)
end

function PANEL:SetHandleX(NewValue) -- Internal
	s0lame.CheckValueType(1, NewValue, "number")

	self.HandleX = math.Round(NewValue)
end

function PANEL:SetHandleWidth(NewValue) -- Internal
	s0lame.CheckValueType(1, NewValue, "number")

	self.HandleWidth = math.Round(NewValue)
end

function PANEL:SetHandleColor(NewColor)
	s0lame.CheckValueType(1, NewColor, "Color")

	self.HandleColor = NewColor

	self:OnHandleColorChanged(NewColor)
end

function PANEL:SetLineColor(NewColor)
	s0lame.CheckValueType(1, NewColor, "Color")

	self.LineColor = NewColor

	self:OnLineColorChanged(NewColor)
end

--------------------------- Uhhh ---------------------------

function PANEL:FixValue()
	local Min = self:GetMinValue()
	local Max = self:GetMaxValue()

	self.Value = math.Clamp(math.Round(self:GetValue(), self:GetDecimals()), Min, Max) -- Avoid stack overflow

	local x = self:GetX()

	self:SetHandleX((self:GetValue() - Min) * (((x + self:GetWidth() - self:GetHandleWidth()) - x) / (Max - Min)))
end

--------------------------- Hooks ---------------------------

function PANEL:PostInit()
	self:SetSize(100, 15)
	self:SetHandleX(0)
	self:SetHandleWidth(3)
	self:SetText("")
	self:SetAutoSize(false)
end

function PANEL:PaintBackground(x, y, w, h)
	--surface.SetDrawColor(self:GetBackgroundColor())
	--surface.DrawRect(x, y, w, h)

	surface.SetDrawColor(self:GetLineColor())
	surface.DrawLine(x, y + (h / 2), x + w, y + (h / 2))
end

function PANEL:Paint(x, y, w, h) end

function PANEL:PaintOverlay(x, y, w, h) -- Basically PANEL:PaintHandle, you can use it as such.
	surface.SetDrawColor(self:GetHandleColor())
	surface.DrawRect(x + self:GetHandleX(), y, self:GetHandleWidth(), h)

	surface.SetDrawColor(self:GetOutlineColor())
	surface.DrawOutlinedRect(x + self:GetHandleX(), y, self:GetHandleWidth(), h)
end

function PANEL:Think()
	if self:GetDragging() then
		local x = self:GetX()

		local min = self:GetMinValue()
		local max = self:GetMaxValue()

		local sLen = self:GetWidth() - self:GetHandleWidth()

		local percent = (((x + sLen) - x) / (max - min))

		local newX = min + ((gui.MouseX() - x) / percent)

		if newX == -0 then newX = 0 end -- Fix jank

		self:SetValue(newX)

		local newHandle = ((self:GetValue() - min) * percent)

		self:SetHandleX(newHandle)
	end
end

function PANEL:OnLeftClick()
	if not self:GetDraggable() then return end

	s0lame.RequestDragging(self)
end

function PANEL:OnValueChanged(NewValue)
	-- For override

	self:FixValue()
end

function PANEL:OnHandleColorChanged(NewColor)
	-- For override
end

function PANEL:OnLineColorChanged(NewColor)
	-- For override
end

function PANEL:OnMinMaxChanged(NewMin, NewMax)
	-- For override

	self:FixValue()
end

return s0lame.RegisterElement("sSlider", PANEL, "sButton")