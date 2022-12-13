CircularCooldownMixin = {}

function CircularCooldownMixin:UpdateCooldown()
  local start, duration, _, modRate = GetSpellCooldown(self.spell)
  self.cd:SetCooldown(start, duration, modRate)
end

function CircularCooldownMixin:OnLoad()
  -- setup the icon
  local spell = self.spell
  self.iconTexture:SetTexture(GetSpellTexture(spell))

  -- setup the cooldown
  self.cd:SetSwipeTexture('Interface\\AddOns\\CircularCooldownTracker\\circular-mask-alpha')
  self.cd:SetUseCircularEdge(true)

  -- register for events
  self:RegisterEvent('SPELL_UPDATE_COOLDOWN', CircularCooldownMixin.UpdateCooldown)
end

function CircularCooldownMixin:OnEvent(event)
  if event == 'SPELL_UPDATE_COOLDOWN' then
    self:UpdateCooldown()
  end
end
