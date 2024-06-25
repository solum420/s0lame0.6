if not s0lame then return end

local PANEL = {
	Text = "sLabel",
	TextColor = s0lame.Colors.White,
	TextAlignment = TEXT_ALIGN_LEFT,
	
	AutoSize = true
}

--------------------------- Accessors ---------------------------

function PANEL:GetText()
	return self.Text
end

function PANEL:GetTextColor()
	return self.TextColor
end

function PANEL:GetAutoSize()
	return self.AutoSize
end

function PANEL:GetTextAlignment()
	return self.TextAlignment
end

--------------------------- Modifiers ---------------------------

function PANEL:SetText(NewText)
	local OldText = self.Text

	self.Text = tostring(NewText)
	self:OnTextChanged(OldText, NewText)
end

function PANEL:SetTextColor(NewColor)
	s0lame.CheckValueType(1, NewColor, "Color")

	self.TextColor = NewColor
end

function PANEL:SetAutoSize(NewState)
	s0lame.CheckValueType(1, NewState, "boolean")

	self.AutoSize = NewState
end

function PANEL:SetTextAlignment(NewAlignment)
	s0lame.CheckValueType(1, NewAlignment, "number")

	self.TextAlignment = NewAlignment
end

--------------------------- Hooks ---------------------------

function PANEL:PostInit()
	surface.SetFont(self:GetFont())
	self:SetSize(surface.GetTextSize(self:GetText()))
end

function PANEL:OnTextChanged(OldText, NewText)
	-- For override

	if self:GetAutoSize() then
		surface.SetFont(self:GetFont())
		self:SetSize(surface.GetTextSize(NewText))
	end
end

function PANEL:PaintBackground() end

function PANEL:Paint(x, y, w, h)
	draw.DrawText(self:GetText(), self:GetFont(), x + 1, y, self:GetTextColor(), self:GetTextAlignment()) -- surface.DrawText doesn't support newlines :(
end

function PANEL:PaintOverlay() end

return s0lame.RegisterElement("sLabel", PANEL, "sPanel")