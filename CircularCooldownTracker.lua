local pp = DevTools_Dump;

-- get refs to Ace libs

local configDialog = LibStub('AceConfigDialog-3.0')

-- register the addon with Ace

CircularCooldownTracker = LibStub('AceAddon-3.0'):NewAddon('CircularCooldownTracker', 'AceConsole-3.0');

-- register slash commands

CircularCooldownTracker:RegisterChatCommand('cct', 'ToggleOptionsDialog')

function CircularCooldownTracker:ToggleOptionsDialog()
  if configDialog.OpenFrames['CircularCooldownTracker'] then
    configDialog:Close('CircularCooldownTracker')
  else
    configDialog:Open('CircularCooldownTracker')
  end
end

-- register addon config

local getTableLength = function (t)
  local count = 0
  for k, v in pairs(t) do
    count = count + 1
  end
  return count
end
local trackedSpells = {}
local spellToTrack = ''
local selectedSpell
local optionsConfig = {
  name = 'CircularCooldownTracker',
  handler = CircularCooldownTracker,
  type = 'group',
  args = {
    borderColor = {
      name = 'Border color',
      type = 'color',
      order = 20,
      hasAlpha = true,
      get = function() return 0, 0, 0, 1 end
    },
    trackedSpells = {
      name = 'Tracked spells',
      type = 'select',
      values = trackedSpells,
      order = 30,
      disabled = function()
        local numTrackedSpells = getTableLength(trackedSpells);
        return numTrackedSpells == 0
      end,
      get = function() return selectedSpell end,
      set = function(info, val) selectedSpell = val end
    },
    addSpellName = {
      name = 'Spell to track',
      type = 'input',
      usage = 'Mortal Strike',
      order = 40,
      get = function() return spellToTrack end,
      set = function(info, val) spellToTrack = val end
    },
    addSpellNameButton = {
      name = 'Add spell',
      type = 'execute',
      order = 41,
      disabled = function() return spellToTrack == '' end,
      func = function()
        trackedSpells[spellToTrack] = spellToTrack
      end
    }
  },
}
LibStub('AceConfig-3.0'):RegisterOptionsTable('CircularCooldownTracker', optionsConfig, nil)

local optionsDefaults = {
  global = {
    vigorLock = true,
    vigorScale = 1
  }
}

-- main code

function CircularCooldownTracker:OnInitialize()
  -- register DB / persistent storage
  self.db = LibStub("AceDB-3.0"):New("CCTDB", optionsDefaults)
  --pp(CircularCooldownTracker.db)
end


-- local f = CreateFrame('Frame', 'blah', UIParent, 'CircularCooldownTemplate')
-- f:SetPoint('CENTER', UIParent, 'CENTER', -200, 0)
