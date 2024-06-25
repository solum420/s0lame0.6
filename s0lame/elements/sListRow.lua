if not s0lame then return end

local PANEL = {}

--------------------------- Accessors ---------------------------

function PANEL:GetColumnText(Index)
	s0lame.CheckValueType(1, Index, "number")

	return self.ColumnText[Index] or ""
end

function PANEL:GetRowIndex()
	return self.RowIndex
end

--------------------------- Modifiers ---------------------------

function PANEL:SetColumnText(Index, NewText)
	s0lame.CheckValueType(1, Index, "number")

	self.ColumnText = self.ColumnText or {}
	self.ColumnText[Index] = tostring(NewText)
end

function PANEL:SetRowIndex(NewIndex)
	s0lame.CheckValueType(1, NewIndex, "number")

	self.RowIndex = NewIndex

	self:SetPos(0, 19 + ((NewIndex - 1) * 15))
end

function PANEL:SetList(NewList)
	s0lame.CheckValueType(1, NewList, s0lame.GetType())

	self.List = NewList

	if self:GetParent() ~= NewList then
		self:SetParent(NewList)
	end
end

--------------------------- Hooks ---------------------------

function PANEL:PostInit()
	self:SetText("")
	self:SetTextAlignment(TEXT_ALIGN_LEFT)
	self:SetAutoSize(false)

	self.ColumnText = {}
	self.RowIndex = 1
end

function PANEL:Paint(x, y, w, h)
	local NumCols = self:GetParent():GetColumnCount()
	local _, _, right, _ = self:GetMargin()

	local Step = (w - right) / NumCols

	for i = 1, NumCols do
		surface.DrawLine(x + (Step * i), y, x + (Step * i), y + 20)
		draw.SimpleText(self.ColumnText[i], self:GetFont(), x + (Step * i) - (Step / 2), y + 10, self:GetTextColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function PANEL:OnParentChanged(_, NewParent)
	self:SetSize(NewParent:GetWidth() - (IsValid(NewParent.ScrollBar) and NewParent.ScrollBar:GetWidth() or 0), 15)
end

function PANEL:OnParentSizeChanged(NewWidth, _)
	local Parent = self:GetParent()
	self:SetSize(NewWidth - (IsValid(Parent.ScrollBar) and Parent.ScrollBar:GetWidth() or 0), 15)
end

function PANEL:OnLeftClick()
	if IsValid(self.List) then
		self.List:OnRowLeftClicked(self)
	end
end

function PANEL:OnRightClick()
	if IsValid(self.List) then
		self.List:OnRowRightClicked(self)
	end
end

return s0lame.RegisterElement("sListRow", PANEL, "sButton")