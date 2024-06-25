if not s0lame then return end

local PANEL = {
	Key = KEY_NONE
}

--------------------------- Accessors ---------------------------

function PANEL:GetValue()
	return self.Key
end

function PANEL:GetText()
	if s0lame.GetTyping() and s0lame.GetTypingObject() == self then
		return "LISTENING..."
	end

	return input.GetKeyName(self:GetValue()) or "NONE"
end

--------------------------- Modifiers ---------------------------

function PANEL:SetValue(NewValue)
	s0lame.CheckKeyCode(1, NewValue, "number")

	self.Key = NewValue

	self:OnValueChanged(self:GetValue())
end

--------------------------- Hooks ---------------------------

function PANEL:PostInit()
	self:SetText("")
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

	local _, th = surface.GetTextSize(self:GetText())

	draw.DrawText(self:GetText(), self:GetFont(), x + (w / 2), y + (h / 2) - (th / 2), self:GetTextColor(), self:GetTextAlignment())
end

function PANEL:PaintOverlay(x, y, w, h)
	surface.SetDrawColor(self:GetOutlineColor())
	surface.DrawOutlinedRect(x, y, w, h)
end

function PANEL:Think()
	if s0lame.GetTyping() and s0lame.GetTypingObject() == self then
		if not input.IsKeyTrapping() then
			input.StartKeyTrapping()
		end

		local Code = input.CheckKeyTrapping()
		if not Code then return end

		if s0lame.IsHardExitKeyCode(Code) then
			s0lame.ResetTyping()
			return
		end

		self:SetValue(Code)

		s0lame.ResetTyping()
	end
end

function PANEL:OnLeftClick()
	s0lame.RequestTyping(self)
end

function PANEL:OnValueChanged(NewValue)
	-- For overide
end

return s0lame.RegisterElement("sBinder", PANEL, "sButton")