if not s0lame then return end

local PANEL = {
	Options = nil,
	Index = 0,

	OriginalHeight = 15,

	Open = false
}

--------------------------- Accessors ---------------------------

function PANEL:GetOptions()
	return self.Options
end

function PANEL:GetSelectedIndex()
	return self.Index
end

function PANEL:GetSelectedOption()
	return self:GetOptions()[self:GetSelectedIndex()]
end

function PANEL:GetOpen()
	return self.Open
end

function PANEL:GetOriginalHeight()
	return self.OriginalHeight
end

function PANEL:GetOption(OptionIndex)
	s0lame.CheckValueType(1, OptionIndex, "number")

	return self:GetOptions()[math.Round(OptionIndex)]
end

--------------------------- Modifiers ---------------------------

function PANEL:AddOption(NewOption, OptionIndex)
	s0lame.Assert(NewOption ~= nil, "Bad argument #1 to 'AddOption' (any expected, got nil)")

	if OptionIndex == nil then
		OptionIndex = #self:GetOptions() + 1
	else
		s0lame.CheckValueType(2, OptionIndex, "number")
	end

	self.Options[math.Round(OptionIndex)] = NewOption

	if #self.Options == 1 then
		self:SelectOption(1)
	end
end

function PANEL:RemoveOption(OptionIndex)
	s0lame.CheckValueType(1, OptionIndex, "number")

	table.remove(self.Options, math.Round(OptionIndex))
end

function PANEL:SelectOption(OptionIndex)
	s0lame.CheckValueType(1, OptionIndex, "number")

	local OldIndex = self:GetSelectedIndex()

	self.Index = math.Round(OptionIndex)

	self:OnSelectionChanged(OldIndex, self:GetSelectedIndex())
end

function PANEL:SetOpen(NewState)
	s0lame.CheckValueType(1, NewState, "boolean")

	self.Open = NewState
end

function PANEL:SetOriginalHeight(NewHeight)
	s0lame.CheckValueType(1, NewHeight, "number")

	self.OriginalHeight = math.Round(NewHeight)
end

--------------------------- Hooks ---------------------------

function PANEL:PostInit()
	self.Options = {}

	self:SetBackgroundColor(s0lame.Colors.ControlDark)
	self:SetText("")
	self:SetTextAlignment(TEXT_ALIGN_CENTER)
	self:SetAutoSize(false)
	self:SetSize(100, 15)
end

function PANEL:PaintBackground(x, y, w, h)
	h = self:GetOriginalHeight()
	
	surface.SetDrawColor(self:GetBackgroundColor())
	surface.DrawRect(x, y, w, h)
end

function PANEL:Paint(x, y, w, h)
	h = self:GetOriginalHeight()

	surface.SetFont(self:GetFont())

	local tw, th = surface.GetTextSize(self:GetText())

	draw.DrawText(tostring(self:GetSelectedOption()), self:GetFont(), x + (w / 2), y + (h / 2) - (th / 2), self:GetTextColor(), self:GetTextAlignment())
end

function PANEL:PaintOverlay(x, y, w, h)
	h = self:GetOriginalHeight()

	surface.SetDrawColor(self:GetOutlineColor())
	surface.DrawOutlinedRect(x, y, w, h)
end

function PANEL:OnLeftClick()
	local x, y = self:GetPos()
	local w = self:GetWidth()
	local h = self:GetOriginalHeight()

	local num = #self:GetOptions()

	self:SetOpen(not self:GetOpen())

	if self:GetOpen() then -- Avoid OnSizeChanged calls
		self.Height = h + (num * 15)
	else
		self.Height = h
	end

	local BaseY = y + h
	
	if s0lame.CursorInBounds(x, y + h, x + w, y + h * (num * 15)) then
		self:SelectOption(math.floor(((gui.MouseY() - BaseY) / 15) + 1))
	end
end

function PANEL:NoClipPaint(x, y, w, h)
	if not self:GetOpen() then return end

	local oh = self:GetOriginalHeight()

	surface.SetFont(self:GetFont())

	local Options = self:GetOptions()

	surface.SetDrawColor(self:GetTextColor())--(self:GetBackgroundColor())
	surface.DrawRect(x, y + oh, w, #Options * 15)

	surface.SetDrawColor(self:GetOutlineColor())
	surface.DrawOutlinedRect(x, y + oh, w, #Options * 15)

	for i = 1, #Options do
		local thisOffset = (i - 1) * 15

		local ty = y + oh + thisOffset
		surface.DrawLine(x, ty, x + w, ty)

		local oI = tostring(Options[i])

		local _, th = surface.GetTextSize(oI)

		draw.DrawText(oI, self:GetFont(), x + (w / 2), y + oh + 7.5 - (th / 2) + thisOffset, self:GetBackgroundColor(), self:GetTextAlignment())
	end
end

function PANEL:OnSelectionChanged(OldIndex, NewIndex)
	-- For override
end

function PANEL:OnSizeChanged(_, _, _, NewHeight)
	self:SetOriginalHeight(NewHeight)
end

return s0lame.RegisterElement("sDropDown", PANEL, "sButton")