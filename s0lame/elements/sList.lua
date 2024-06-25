if not s0lame then return end

local PANEL = {}

--------------------------- Accessors ---------------------------

function PANEL:GetHasHiddenStencil()
	return true
end

function PANEL:GetColumnCount()
	return #self.Columns
end

--------------------------- Modifiers ---------------------------

function PANEL:AddRow(...)
	local NewRow = s0lame.Create("sListRow", self)
	NewRow:SetVisible(true)

	for k, v in ipairs({...}) do
		NewRow:SetColumnText(k, v)
	end

	local NextIndex = #self.Rows + 1

	self.Rows[NextIndex] = NewRow
	self.ScrollBar:SetMaxValue(math.max((#self.Rows - math.Round((self:GetHeight() - 19) / 15)) * 15), 0)

	NewRow:SetRowIndex(NextIndex)
end

function PANEL:AddColumn(Label, Index)
	if Index == nil then
		Index = #self.Columns + 1
	else
		s0lame.CheckValueType(2, Index, "number")
	end

	table.insert(self.Columns, Index, tostring(Label))
end

function PANEL:ClearRows()
	for i = 1, #self.Rows do
		if IsValid(self.Rows[i]) then
			self.Rows[i]:Remove()
		end
	end

	table.Empty(self.Rows)

	self:SetScroll(0)
end

--------------------------- Hooks ---------------------------

function PANEL:PostInit()
	self:SetText("")
	self:SetAutoSize(false)
	self:SetSize(150, 150)

	self.Columns = {}
	self.Rows = {}
	
	self.ScrollBar = s0lame.Create("sScrollBar", self)
	self.ScrollBar:SetVisible(true)
	self.ScrollBar:SetMaxValue(0)

	self:SetMargin(0, 0, self.ScrollBar:GetWidth(), 0)
end

function PANEL:Paint(x, y, w, h)
	local _, _, right, _ = self:GetMargin()

	surface.SetDrawColor(self:GetOutlineColor())
	surface.DrawLine(x, y + 19, x + w - right, y + 19)

	local Step = (w - right) / #self.Columns

	for i = 1, #self.Columns do
		surface.DrawLine(x + (Step * i), y, x + (Step * i), y + 20)
		draw.SimpleText(self.Columns[i], self:GetFont(), x + (Step * i) - (Step / 2), y + 10, self:GetTextColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function PANEL:OnRowLeftClicked(Row)
	-- For override
end

function PANEL:OnRowRightClicked(Row)
	-- For override
end

function PANEL:PushStencil()
	render.SetStencilWriteMask(0xFF)
	render.SetStencilTestMask(0xFF)
	render.SetStencilReferenceValue(0)
	render.SetStencilPassOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.ClearStencil()

	render.SetStencilEnable(true)
	render.SetStencilReferenceValue(1)
	render.SetStencilCompareFunction(STENCIL_NEVER)
	render.SetStencilFailOperation(STENCIL_REPLACE)

	local Left, Top, Right, Bottom = self:GetMargin()
	Top = 19 -- Cheat code easter egg glitch

	draw.NoTexture()
	surface.SetDrawColor(s0lame.Colors.White)
	surface.DrawRect(self:GetX() + Left, self:GetY() + Top, self:GetWidth() - Right - Left, self:GetHeight() - Bottom - Top)

	render.SetStencilCompareFunction(STENCIL_EQUAL)
	render.SetStencilFailOperation(STENCIL_KEEP)
end

function PANEL:PopStencil()
	render.SetStencilEnable(false)
end

return s0lame.RegisterElement("sList", PANEL, "sButton")