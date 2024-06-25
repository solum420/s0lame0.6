if not s0lame then return end

local PANEL = {
	Deleted = false,

	X = 0,
	Y = 0,
	Width = 0,
	Height = 0,

	Margin = nil,
	IgnoreParentBounds = false,
	HasStencil = false,

	Visible = false,

	Parent = nil,

	Children = nil,

	Font = "fontUI",

	BackgroundColor = s0lame.Colors.Control,
	OutlineColor = s0lame.Colors.Black,

	Clickable = true,

	Scroll = 0,
	ScrollBar = nil,
	Scrollable = true -- Kinda deceiving, actually controls if something should move when its parent is scrolled
}

--------------------------- Accessors ---------------------------

function PANEL:GetX()
	return self.X
end

function PANEL:GetY()
	return self.Y
end

function PANEL:GetPos()
	return self.X, self.Y
end

function PANEL:GetWidth()
	return self.Width
end

function PANEL:GetHeight()
	return self.Height
end

function PANEL:GetMargin()
	return self.Margin[1], self.Margin[2], self.Margin[3], self.Margin[4]
end

function PANEL:GetIgnoreParentBounds()
	return self.IgnoreParentBounds
end

function PANEL:GetHasStencil()
	return self.HasStencil
end

function PANEL:GetHasHiddenStencil() -- This isn't checked by the drawing hook
	-- For override
	return false
end

function PANEL:GetParentHasStencil()
	local Parent = self:GetParent()
	return IsValid(Parent) and (Parent:GetHasStencil() or Parent:GetHasHiddenStencil()) or false
end

function PANEL:GetSize()
	return self.Width, self.Height
end

function PANEL:GetVisible()
	return self.Visible
end

function PANEL:GetChildren()
	return self.Children
end

function PANEL:GetParent()
	return self.Parent
end

function PANEL:GetFont()
	return self.Font
end

function PANEL:GetBackgroundColor() -- Make a copy?
	return self.BackgroundColor
end

function PANEL:GetOutlineColor()
	return self.OutlineColor
end

function PANEL:GetClickable()
	return self.Clickable
end

function PANEL:GetScroll()
	return self.Scroll
end

function PANEL:GetScrollable()
	return self.Scrollable
end

--------------------------- Modifiers ---------------------------

function PANEL:SetX(x)
	s0lame.CheckValueType(1, x, "number")

	local OldX = self:GetX()

	local Parent = self:GetParent()
	local ParentX = IsValid(Parent) and Parent:GetX() or 0

	self.X = math.Round(x + ParentX)

	self:OnPositionChanged(OldX, self:GetY(), self:GetX(), self:GetY())
end

function PANEL:SetY(y)
	s0lame.CheckValueType(1, y, "number")

	local OldY = self:GetY()

	local Parent = self:GetParent()
	local ParentY = IsValid(Parent) and Parent:GetY() + Parent:GetScroll() or 0

	self.Y = math.Round(y + ParentY)

	self:OnPositionChanged(self:GetX(), OldY, self:GetX(), self:GetY())
end

function PANEL:SetPos(x, y)
	s0lame.CheckValueType(1, x, "number")
	s0lame.CheckValueType(2, y, "number")

	local OldX = self:GetX()
	local OldY = self:GetY()

	local Parent = self:GetParent()
	local ParentX = IsValid(Parent) and Parent:GetX() or 0
	local ParentY = IsValid(Parent) and Parent:GetY() + Parent:GetScroll() or 0

	self.X = math.Round(x + ParentX)
	self.Y = math.Round(y + ParentY)

	self:OnPositionChanged(OldX, OldY, self:GetX(), self:GetY())
end

function PANEL:SetWidth(w)
	s0lame.CheckValueType(1, w, "number")

	local OldWidth = self:GetWidth()

	self.Width = math.Round(w)

	self:OnSizeChanged(OldWidth, self:GetHeight(), self:GetWidth(), self:GetHeight())
end

function PANEL:SetHeight(h)
	s0lame.CheckValueType(1, h, "number")

	local OldHeight = self:GetHeight()

	self.Height = math.Round(h)

	self:OnSizeChanged(self:GetWidth(), OldHeight, self:GetWidth(), self:GetHeight())
end

function PANEL:SetSize(w, h)
	s0lame.CheckValueType(1, w, "number")
	s0lame.CheckValueType(2, h, "number")

	local OldWidth = self:GetWidth()
	local OldHeight = self:GetHeight()

	self.Width = math.Round(w)
	self.Height = math.Round(h)

	self:OnSizeChanged(OldWidth, OldHeight, self:GetWidth(), self:GetHeight())
end

function PANEL:SetMargin(a, b, c, d)
	s0lame.CheckValueType(1, a, "number")
	s0lame.CheckValueType(2, b, "number")
	s0lame.CheckValueType(3, c, "number")
	s0lame.CheckValueType(4, d, "number")

	self.Margin[1] = math.Round(a)
	self.Margin[2] = math.Round(b)
	self.Margin[3] = math.Round(c)
	self.Margin[4] = math.Round(d)
end

function PANEL:SetIgnoreParentBounds(NewState)
	s0lame.CheckValueType(1, NewState, "boolean")

	self.IgnoreParentBounds = NewState
end

function PANEL:SetHasStencil(NewState)
	s0lame.CheckValueType(1, NewState, "boolean")

	self.HasStencil = NewState
end

function PANEL:SetVisible(v)
	s0lame.CheckValueType(1, v, "boolean")

	self.Visible = v

	if not IsValid(self:GetParent()) then -- Makes visibility relative to parent as well
		s0lame.UpdateRenderState(self, v)
	end
end

function PANEL:SetParent(NewParent)
	if NewParent ~= nil then
		s0lame.CheckValueType(1, NewParent, s0lame.GetType())
	end

	local CurParent = self:GetParent()

	if IsValid(CurParent) then
		local CurParentChildren = CurParent:GetChildren()
		
		local selfIndex = table.KeyFromValue(CurParentChildren, self)

		if selfIndex then
			table.remove(CurParentChildren, selfIndex)
		end
	end

	self.Parent = NewParent

	if IsValid(NewParent) then
		local NewChildren = NewParent:GetChildren()

		if NewChildren then
			NewChildren[#NewChildren + 1] = self
		end
	end

	self:OnParentChanged(CurParent, NewParent)
end

function PANEL:SetFont(NewFont)
	s0lame.CheckValueType(1, NewFont, "string")

	self.Font = NewFont
end

function PANEL:SetBackgroundColor(NewColor)
	s0lame.CheckValueType(1, NewColor, "Color")

	self.BackgroundColor = NewColor
end

function PANEL:SetOutlineColor(NewColor)
	s0lame.CheckValueType(1, NewColor, "Color")

	self.OutlineColor = NewColor
end

function PANEL:SetClickable(NewState)
	s0lame.CheckValueType(1, NewState, "boolean")

	self.Clickable = NewState
end

function PANEL:SetScroll(NewValue)
	s0lame.CheckValueType(1, NewValue, "number")

	local OldScroll = self:GetScroll()

	self.Scroll = math.Round(NewValue)

	self:OnScroll(OldScroll - self:GetScroll())
end

function PANEL:SetScrollable(NewState)
	s0lame.CheckValueType(1, NewState, "boolean")

	self.Scrollable = NewState
end

--------------------------- Uhhh ---------------------------

function PANEL:IsValid()
	return self ~= nil and not self.Deleted
end

function PANEL:Remove() -- This needs improved
	if not IsValid(self) then return end

	self:SetVisible(false)
	
	self.Deleted = true

	for _, v in ipairs(self:GetChildren()) do
		v:Remove()
	end
end

function PANEL:UpdateChildrenPositions(OldX, OldY, IsScroll)
	for _, v in ipairs(self:GetChildren()) do
		if IsScroll and not v:GetScrollable() then continue end

		local ox, oy = v:GetPos()
		if IsScroll then oy = oy - self:GetScroll() end

		local OffsetX = ox - OldX
		local OffsetY = oy - OldY

		v:SetPos(OffsetX, OffsetY)
	end
end

function PANEL:BroadcastSizeChange(NewWidth, NewHeight)
	for _, v in ipairs(self:GetChildren()) do
		v:OnParentSizeChanged(NewWidth, NewHeight)
	end
end

function PANEL:LocalToScreen(x, y)
	return self:GetX() + x, self:GetY() + y
end

--------------------------- Hooks ---------------------------

function PANEL:Init()
	-- Gay

	self.Children = {}

	self.Margin = {
		0, -- Left
		0, -- Top
		0, -- Right
		0 -- Bottom
	}
end

function PANEL:PostInit()
	-- For internal override
end

function PANEL:PostParentInit()
	-- For internal override
end

function PANEL:OnPositionChanged(OldX, OldY, NewX, NewY)
	-- For override

	self:UpdateChildrenPositions(OldX, OldY)
end

function PANEL:OnSizeChanged(OldWidth, OldHeight, NewWidth, NewHeight)
	-- For override

	self:BroadcastSizeChange(NewWidth, NewHeight)
end

function PANEL:OnParentSizeChanged(NewWidth, NewHeight)
	-- For override
end

function PANEL:ShouldPaint()
	-- For override

	return true
end

function PANEL:PaintBackground(x, y, w, h)
	-- For override

	surface.SetDrawColor(self:GetBackgroundColor())
	surface.DrawRect(x, y, w, h)
end

function PANEL:Paint(x, y, w, h)
	-- For override
end

function PANEL:PaintOverlay(x, y, w, h)
	-- For override

	surface.SetDrawColor(self:GetOutlineColor())
	surface.DrawOutlinedRect(x, y, w, h)
end

function PANEL:Think(x, y, w, h)
	-- For override
end

function PANEL:NoClipPaint(x, y, w, h)
	-- For override
	-- Allows painting outside of the panel's clipping box
end

function PANEL:OnLeftClick()
	-- For override
end

function PANEL:OnRightClick()
	-- For override
end

function PANEL:OnScroll(Delta)
	-- For override

	self:UpdateChildrenPositions(self:GetX(), self:GetY() - Delta, true)
end

function PANEL:OnParentChanged(OldParent, NewParent)
	-- For override
end

function PANEL:PushStencil()
	-- For override
end

function PANEL:PopStencil()
	-- For override
end

return s0lame.RegisterElement("sPanel", PANEL)