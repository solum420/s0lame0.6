if not s0lame then return end

local PANEL = {
	Draggable = true,

	HandleY = 0,
	HandleHeight = 20,
	HandleColor = s0lame.Colors.Control,

	Value = 0,
	Min = 0,
	Max = 500
}

--------------------------- Accessors ---------------------------

function PANEL:GetDraggable()
	return self.Draggable
end

function PANEL:GetHandleY()
	return self.HandleY
end

function PANEL:GetHandleHeight()
	return self.HandleHeight
end

function PANEL:GetHandleColor()
	return self.HandleColor
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

--------------------------- Modifiers ---------------------------

function PANEL:SetDraggable(NewState)
	s0lame.CheckValueType(1, NewState, "boolean")

	self.Draggable = NewState
end

function PANEL:GetDragging()
	return s0lame.GetDragging() and s0lame.GetDraggingObject() == self
end

function PANEL:SetHandleY(NewValue)
	s0lame.CheckValueType(1, NewValue, "number")

	self.HandleY = math.Round(NewValue)
end

function PANEL:SetHandleHeight(NewValue)
	s0lame.CheckValueType(1, NewValue, "number")

	self.HandleHeight = math.Round(NewValue)
end

function PANEL:SetHandleColor(NewColor)
	s0lame.CheckValueType(1, NewColor, "Color")

	self.HandleColor = NewColor

	self:OnHandleColorChanged(NewColor)
end

function PANEL:SetValue(NewValue)
	s0lame.CheckValueType(1, NewValue, "number")

	self.Value = math.Clamp(math.Round(NewValue), self:GetMinValue(), self:GetMaxValue())

	self:OnValueChanged(self:GetValue())
end

function PANEL:SetMinValue(NewValue)
	s0lame.CheckValueType(1, NewValue, "number")

	self.Min = math.Round(NewValue)

	self:OnMinMaxChanged(self:GetMinValue(), self:GetMaxValue())
end

function PANEL:SetMaxValue(NewValue)
	s0lame.CheckValueType(1, NewValue, "number")

	self.Max = math.Round(NewValue)

	self:OnMinMaxChanged(self:GetMinValue(), self:GetMaxValue())
end

--------------------------- Uhhh ---------------------------

function PANEL:FixValue()
	local Min = self:GetMinValue()
	local Max = self:GetMaxValue()

	self.Value = math.Clamp(self:GetValue(), Min, Max) -- Avoid stack overflow

	local y = self:GetY()

	self:SetHandleY((self:GetValue() - Min) * (((y + self:GetHeight() - self:GetHandleHeight()) - y) / (Max - Min)))
end

--------------------------- Hooks ---------------------------

function PANEL:PostInit()
	self:SetText("")
	self:SetAutoSize(false)
	self:SetWidth(15)
	self:SetBackgroundColor(s0lame.Colors.ControlMedium)
	self:SetScrollable(false)
	self:SetIgnoreParentBounds(true)
end

function PANEL:ShouldPaint()
	return IsValid(self:GetParent())
end

function PANEL:PaintBackground(x, y, w, h) end
function PANEL:Paint(x, y, w, h) end
function PANEL:PaintOverlay(x, y, w, h) end

function PANEL:NoClipPaint(x, y, w, h) -- Don't clip scrollbars
	-- Background
	surface.SetDrawColor(self:GetBackgroundColor())
	surface.DrawRect(x, y, w, h)

	-- Paint
	surface.SetDrawColor(self:GetOutlineColor())
	surface.DrawOutlinedRect(x, y, w, h)

	-- Overlay
	local hy = self:GetHandleY()
	local hh = self:GetHandleHeight()

	surface.SetDrawColor(self:GetHandleColor())
	surface.DrawRect(x, y + hy, w, hh)

	surface.SetDrawColor(self:GetOutlineColor())
	surface.DrawOutlinedRect(x, y + hy, w, hh)
	
	local step = math.Round(hh / 4)

	for i = 1, 3 do
		local ly = y + hy + (step * i)
		surface.DrawLine(x + 3, ly, x + w - 3, ly)
	end
end

function PANEL:OnParentChanged(OldParent, NewParent)
	if IsValid(OldParent) then
		OldParent.ScrollBar = nil
	end

	if not IsValid(NewParent) then
		self:SetVisible(false)
		return
	end

	local _, offset, _, _ = NewParent:GetMargin()

	self:SetHeight(NewParent:GetHeight() - offset)
	self:SetPos(NewParent:GetWidth() - self:GetWidth(), offset)

	NewParent.ScrollBar = self
end

function PANEL:OnParentSizeChanged(NewWidth, NewHeight)
	local _, offset, _, _ = self:GetParent():GetMargin()

	self:SetHeight(NewHeight - offset)
	self:SetPos(NewWidth - self:GetWidth(), offset)
end

function PANEL:Think()
	if self:GetDragging() then
		local y = self:GetY()

		local min = self:GetMinValue()
		local max = self:GetMaxValue()

		local sLen = self:GetHeight() - self:GetHandleHeight()

		local percent = (((y + sLen) - y) / (max - min))

		local newY = min + ((gui.MouseY() - y) / percent)

		if newY == -0 then newY = 0 end -- Fix jank

		self:SetValue(newY)

		local newHandle = ((self:GetValue() - min) * percent)

		self:SetHandleY(newHandle)
	end
end

function PANEL:OnLeftClick()
	if not self:GetDraggable() then return end

	s0lame.RequestDragging(self)
end

function PANEL:OnValueChanged(NewValue)
	-- For override

	self:GetParent():SetScroll(NewValue)
	self:FixValue()
end

function PANEL:OnHandleColorChanged(NewColor)
	-- For override
end

function PANEL:OnMinMaxChanged(NewMin, NewMax)
	-- For override

	self:FixValue()
end

return s0lame.RegisterElement("sScrollBar", PANEL, "sButton")