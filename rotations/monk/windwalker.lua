--[[ ///---INFO---////
// Monk WindWalker //
!Originaly made by Tao!
Thank You For Using My ProFiles
I Hope Your Enjoy Them
MTS
]]

local n,r = GetSpellInfo(137639)
local fetch = ProbablyEngine.interface.fetchKey

local exeOnLoad = function()
mts_Splash("|cff9482C9[MTS]-|cffFFFFFF"..(select(2, GetSpecializationInfo(GetSpecialization())) or "Error").."-|cff9482C9Loaded", 5.0)

	ProbablyEngine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist')
	ProbablyEngine.toggle.create('autosef', 'Interface\\Icons\\spell_sandstorm', 'Auto SEF', 'Automatically cast SEF on mouseover targets')
	
end

local inCombat = {

	-- Keybinds
		{ "pause", "modifier.shift" },
		{ "119381", "modifier.control" }, -- Leg Sweep
		{ "122470", "modifier.alt" }, -- Touch of Karma

	-- SEF on mouseover // Needs Futher Logic...
  		{ "137639",  {"toggle.autosef","!mouseover.debuff(138130)","!player.buff(137639).count = 2", "@mtsLib.mouseNotEqualTarget()"} , "mouseover" },
  		{ "/cancelaura "..n, { "target.debuff(137639)", "toggle.autosef" }, "target"}, -- Storm, Earth, and Fire

	-- Auto Target
		{ "/cleartarget", {
			"toggle.autotarget", 
			(function() return UnitIsFriend("player","target") end)
			}},
		{ "/target [target=focustarget, harm, nodead]", {"target.range > 40", "!target.exists","toggle.autotarget"} },
		{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" }},
   		{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" }},

	-- Survival
		{ "115072", { "player.health <= 80", "player.chi < 4" }}, -- Expel Harm
		{ "115098", "player.health <= 75" }, -- Chi Wave
		{ "115203", { -- Forifying Brew at < 30% health and when DM & DH buff is not up
		  "player.health < 30",
		  "!player.buff(122783)", -- Diffuse Magic
		  "!player.buff(122278)"}}, -- Dampen Harm
		{ "#5512", "player.health < 40" }, -- Healthstone

	-- Interrupts
	  	{ "115078", { -- Paralysis when SHS, and Quaking Palm are all on CD
	     	"!target.debuff(116705)", -- Spear Hand Strike
	     	"player.spell(116705).cooldown > 0", -- Spear Hand Strike
	     	"player.spell(107079).cooldown > 0", -- Quaking Palm
	     	"!modifier.last(116705)", -- Spear Hand Strike
	     	"target.interruptsAt(50)", 
	     	"modifier.interrupts"}},
	  	{ "116844", { -- Ring of Peace when SHS is on CD
	     	"!target.debuff(116705)", -- Spear Hand Strike
	     	"player.spell(116705).cooldown > 0", -- Spear Hand Strike
	     	"!modifier.last(116705)", -- Spear Hand Strike
	     	"target.interruptsAt(50)", 
	     	"modifier.interrupts"}},
	  	{ "119381", { -- Leg Sweep when SHS is on CD
	     	"player.spell(116705).cooldown > 0",
	     	"target.range <= 5",
	     	"!modifier.last(116705)",
	     	"target.interruptsAt(50)", 
	     	"modifier.interrupts"}},
	  	{ "119392", { -- Charging Ox Wave when SHS is on CD
	     	"player.spell(116705).cooldown > 0",
	     	"target.range <= 30",
	     	"!modifier.last(116705)",
	     	"target.interruptsAt(50)", 
	     	"modifier.interrupts"}},
	  	{ "107079", { -- Quaking Palm when SHS is on CD
	     	"!target.debuff(116705)", -- Spear Hand Strike
	     	"player.spell(116705).cooldown > 0", -- Spear Hand Strike
	     	"!modifier.last(116705)", -- Spear Hand Strike
	     	"target.interruptsAt(50)",
	     	"modifier.interrupts"}},
	  	{ "116705", {"target.interruptsAt(50)", "modifier.interrupts"} }, -- Spear Hand Strike

	-- Cooldowns
		{ "115288", {"player.energy <= 30","modifier.cooldowns"} }, -- Energizing Brew
		{ "123904", "modifier.cooldowns" }, -- Invoke Xuen, the White Tiger

	-- FREEDOOM!
		{ "137562", "player.state.disorient" }, -- Nimble Brew = 137562
		{ "137562", "player.state.fear" },
		{ "137562", "player.state.stun" },
		{ "137562", "player.state.root" },
		{ "137562", "player.state.horror" },
		{ "137562", "player.state.snare" },
		{ "116841", "player.state.disorient" }, -- Tiger's Lust = 116841
		{ "116841", "player.state.stun" },
		{ "116841", "player.state.root" },
		{ "116841", "player.state.snare" },

	-- Ranged
		{ "116841", { "target.range >= 15", "player.moving" }},-- Tiger's Lust if the target is at least 15 yards away and we are moving
		{ "124081", {"!target.debuff(124081)","target.range >= 15"} }, -- Zen Sphere. 40 yard range!
		{ "115098", "target.range >= 15" }, -- Chi Wave (40yrd range!)
		{ "123986", "target.range >= 15" }, -- Chi Burst (40yrd range!)
		{ "117952", { "target.range > 5", "target.range <= 40", "!player.moving" }}, -- Crackling Jade Lightning
		{ "115072", {"player.chi < 4", "target.range >= 15"} }, -- Expel Harm
		

	-- buffs
		{ "115080", "player.buff(121125)" }, -- Touch of Death, Death Note
		{ "116740", {"player.buff(125195).count >= 10", "!player.buff(116740)"} }, -- Tigereye Brew

	-- Procs
		{ "100784", "player.buff(116768)"},-- Blackout Kick w/tCombo Breaker: Blackout Kick
		{ "100787", "player.buff(118864)"}, -- Tiger Palm w/t Combo Breaker: Tiger Palm

	-- Rotation
		{ "107428", "target.debuff(130320).duration < 3" }, -- Rising Sun Kick
		{ "113656", "!player.moving" },-- Fists of Fury

		{{-- can use FH

			-- AoE smart
				{ "101546","player.area(8).enemies >= 3"}, -- Spinning Crane Kick // FH Smarth

		}, (function() return fetch('mtsconf','Firehack') end) },
			
		-- AoE
			{ "101546", "modifier.multitarget" }, -- Spinning Crane Kick

		{ "100784", "player.chi >= 3" }, -- Blackout Kick
		{ "100787", "!player.buff(125359)"}, -- Tiger Palm if not w/t Tiger Power
		{ "115698", "player.chi <= 3" }, -- Jab
		  
}

local outCombat = {

 	{ "116781", { -- Legacy of the White Tiger
	  	"!player.buff(116781).any", -- Legacy of the White Tiger
	  	"!player.buff(17007).any", -- Leader of the Pack
	  	"!player.buff(1459).any", -- Arcane Brilliance
	  	"!player.buff(61316).any", -- Dalaran Brilliance
	  	"!player.buff(97229).any", -- Bellowing Roar
	  	"!player.buff(24604).any", -- Furious Howl
	  	"!player.buff(90309).any", -- Terrifying Roar
	  	"!player.buff(126373).any", -- Fearless Roar
	  	"!player.buff(126309).any"}}, -- Still Water
  	{ "115921", { -- Legacy of the Emperor
  		"!player.buff(115921).any", -- Legacy of the Emperor
  		"!player.buff(1126).any", -- Mark of the Wild
  		"!player.buff(20217).any", -- Blessing of Kings
  		"!player.buff(90363).any", -- Embrace of the Shale Spider
  		"!player.buff(Blessing of the Forgotten Kings).any"}}
  
}

ProbablyEngine.rotation.register_custom(269, mts_Icon.."|r[|cff9482C9MTS|r][|cff00FF96Monk-WindWalker|r]", inCombat, outCombat, exeOnLoad)
