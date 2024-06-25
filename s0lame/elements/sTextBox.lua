if not s0lame then return end

local PANEL = {}

--------------------------- Hooks ---------------------------

function PANEL:PostInit()
	self:SetText("")
	self:SetAutoSize(false)
	self:SetSize(100, 15)
	self:SetBackgroundColor(s0lame.Colors.ControlMedium)
end

function PANEL:PaintBackground(x, y, w, h)
	surface.SetDrawColor(self:GetBackgroundColor())
	surface.DrawRect(x, y, w, h)
end

function PANEL:Paint(x, y, w, h)
	surface.SetFont(self:GetFont())

	local tw, th = surface.GetTextSize(self:GetText())

	-- Cheat to essentially get a 2nd scissor rect to clip the text
	self:PushStencil()
	surface.SetDrawColor(self:GetOutlineColor())

	local ty = y + (h / 2) - (th / 2)

	draw.DrawText(self:GetText(), self:GetFont(), x + 2, ty, self:GetTextColor(), TEXT_ALIGN_LEFT)

	if s0lame.GetTyping() and s0lame.GetTypingObject() == self then
		local lx = x + 2 + tw + 1

		surface.DrawLine(lx, ty, lx, ty + th)
	end

	self:PopStencil()
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

		if s0lame.IsExitKeyCode(Code) then
			s0lame.ResetTyping()
			return
		end

		local Text = self:GetText()

		if Code == KEY_BACKSPACE then
			self:SetText(string.sub(Text, 1, #Text - 1))
		else
			local KeyValue = s0lame.GetKeyCode(Code)

			self:SetText(Text .. KeyValue)
		end
	end
end

function PANEL:OnLeftClick()
	s0lame.RequestTyping(self)
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

	draw.NoTexture()
	surface.SetDrawColor(s0lame.Colors.White)
	surface.DrawRect(self:GetX(), self:GetY(), self:GetWidth(), self:GetHeight())

	render.SetStencilCompareFunction(STENCIL_EQUAL)
	render.SetStencilFailOperation(STENCIL_KEEP)
end

function PANEL:PopStencil()
	render.SetStencilEnable(false)
end

return s0lame.RegisterElement("sTextBox", PANEL, "sButton")