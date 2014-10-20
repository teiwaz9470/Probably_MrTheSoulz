--[[ ///---INFO---////
//General Lib//
Thank You For Using My ProFiles
I Hope Your Enjoy Them
MTS
]]

local mtsLib = { wisp = false, alert = true, sound = true, taunt = false }
local _media = "Interface\\AddOns\\Probably_MrTheSoulz\\media\\"
local _playerClass, _englishClass, _idClass = UnitClass("player");
local _playerSpec = GetSpecialization();
local mts_Dummies = {31146,67127,46647,32546,31144,32667,32542,32666,32545,32541}
local _cc = {49203,6770,1776,51514,9484,118,28272,28271,61305,61025,61721,61780,3355,19386,20066,90337,2637,82676,115078,76780,9484,1513,115268}
local ignoreDebuffs = {'Mark of Arrogance','Displaced Energy'}
mtsLib.darkSimSpells = {
-- siege of orgrimmar
"Froststorm Bolt","Arcane Shock","Rage of the Empress","Chain Lightning",
-- pvp
"Hex","Mind Control","Cyclone","Polymorph","Pyroblast","Tranquility","Divine Hymn","Hymn of Hope","Ring of Frost","Entangling Roots"
}

function mtsLib.GetWisp()
	return mtsLib.wisp
end

function mtsLib.GetAlert()
	return mtsLib.alert
end

function mtsLib.GetSound()
	return mtsLib.sound
end

function mtsLib.GetTaunt()
	return mtsLib.taunt
end

ProbablyEngine.command.register('mts', function(msg, box)
local command, text = msg:match("^(%S*)%s*(.-)$")
		
	-- Dispaly Version
	if command == 'ver' or command == 'version' then
		mtsLib.ConfigAlertSound()
		mtsAlert:message('MrTheSoulz Version: 0.0.11')
	end
	
	if command == 'wisp' or command == 'wsp' or command == 'w' then
	mtsLib.wisp = not mtsLib.wisp
		if mtsLib.wisp then
			mtsAlert:message('*Whispers Enabled.*')
		else
			mtsAlert:message('*Whispers Disabled*.')
		end
	end
	
	if command == 'alerts' or command == 'notifications' or command == 'a' then
	mtsLib.alert = not mtsLib.alert
		if mtsLib.alert then
			mtsAlert:message('*Alerts Enabled.*')
		else
			mtsAlert:message('*Alerts Disabled*.')
		end
	end
	
	if command == 'sounds' or command == 'sound' or command == 's' then
	mtsLib.sound = not mtsLib.sound
		if mtsLib.sound then
			mtsAlert:message('*Sounds Enabled.*')
		else
			mtsAlert:message('*Sounds Disabled*.')
		end
	end

	if command == 'taunts' or command == 'taunt' or command == 't' then
	mtsLib.taunt = not mtsLib.taunt
		if mtsLib.taunt then
			mtsAlert:message('*Taunts Enabled.*')
		else
			mtsAlert:message('*Taunts Disabled*.')
		end
	end
			
end)

ProbablyEngine.listener.register("COMBAT_LOG_EVENT_UNFILTERED", function(...)
local event = select(2, ...)
local source = select(4, ...)
local spellId = select(12, ...)
local tname = UnitName("target")
if source ~= UnitGUID("player") then return false end

	if event == "SPELL_CAST_SUCCESS" then	

    -- Paladin

		if spellId == 114158 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Light´s Hammer*")
		end
		if spellId == 633 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigWhisper(tname.." MSG: Casted Lay On Hands on you.")
			mtsLib.ConfigAlert("*Casted Lay on Hands*")
		end
		if spellId == 1044 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigWhisper(tname.." MSG: Casted Hand of Freedom on you.")
			mtsLib.ConfigAlert("*Casted Hand of Freedom*")
		end
		if spellId == 6940 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Hand of Sacrifice*")
			mtsLib.ConfigWhisper("/w "..tname.." MSG: Casted Hand of Sacrifice on you.")
		end
		if spellId == 105593 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Stunned Target*")
		end
		if spellId == 853 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Stunned Target*")
		end
		if spellId == 31821 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Devotion Aura*")
		end
		if spellId == 31884 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Avenging Wrath*")
		end
		if spellId == 105809 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Guardian of Ancient Kings*")
		end
		if spellId == 31850 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Ardent Defender*")
		end
		if spellId == 86659 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Holy Avenger*")
		end
		if spellId == 86669 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Guardian of Ancient Kings*")
		end
		if spellId == 31842 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Divine Favor*")
		end

    -- DeathKnight

		if spellId == 43265 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Death and Decay*")
		end
		if spellId == 48707 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Anti-Magic Shell*")
		end
		if spellId == 49028 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Dancing Rune Weapon*")
		end
		if spellId == 55233 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Vampiric Blood*")
		end
		if spellId == 48792 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Icebound Fortitude*")
		end
		if spellId == 42650 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casting Army of the Dead*")
		end

	end
end)

function mtsLib.StopIfBoss()
if UnitExists("boss1") then
local npcId = tonumber(UnitGUID("target"):sub(6,10), 16)
	if npcId == 71543 -- Immersus
	or npcId == 72276 -- Norushen
	or npcId == 71734 -- Sha of Pride
	or npcId == 72249 -- Galakras
	or npcId == 71466 -- Iron Juggernaut
	or npcId == 71859 -- Kor'kron Dark Shaman
	or npcId == 71515 -- General Nazgrim
	or npcId == 71454 -- Malkorok
	or npcId == 71529 -- Thok the Bloodsthirsty
	or npcId == 71504 -- Siegecrafter Blackfuse
	or npcId == 71865 -- Garrosh Hellscream
	then return false end
end
	return true 
end
	
function mtsLib.Dispell(text)
local prefix = (IsInRaid() and 'raid') or 'party'
	for i = -1, GetNumGroupMembers() - 1 do
	local unit = (i == -1 and 'target') or (i == 0 and 'player') or prefix .. i
		if IsSpellInRange(text, unit) then
			for j = 1, 40 do
			local debuffName, _, _, _, dispelType, duration, expires, _, _, _, spellID, _, isBossDebuff, _, _, _ = UnitDebuff(unit, j)
				if dispelType and dispelType == 'Magic' or dispelType == 'Poison' or dispelType == 'Disease' then
				local ignore = false
				for k = 1, #ignoreDebuffs do
					if debuffName == ignoreDebuffs[k] then
						ignore = true
						break
					end
				end
					if not ignore then
						ProbablyEngine.dsl.parsedTarget = unit
						return true
					end
				end
				if not debuffName then
					break
				end
			end
		end
	end
		return false
end

function mtsLib.shouldStop(unit)
	if not UnitAffectingCombat(unit) then return false end
	if mtsLib.hasDebuffTable(unit, _cc) then return false end
	if UnitAura(unit,GetSpellInfo(116994))
		or UnitAura(unit,GetSpellInfo(122540))
		or UnitAura(unit,GetSpellInfo(123250))
		or UnitAura(unit,GetSpellInfo(106062))
		or UnitAura(unit,GetSpellInfo(110945))
		or UnitAura(unit,GetSpellInfo(143593)) -- General Nazgrim: Defensive Stance
		or UnitAura(unit,GetSpellInfo(143574)) -- Heroic Immerseus: Swelling Corruption
		then return false 
	end
		return true
end

function mtsLib.HealthPot()
	if GetItemCount(76097) > 1
	and GetItemCooldown(76097) == 0 then 
		return true
	end
	return false
end

function mtsLib.KafaPress()
	if GetItemCount(86125) > 0
	and GetItemCooldown(86125) == 0 then 
		return true
	end
	return false
end

function mtsLib.shoulDarkSimUnit(unit)
	for index,spellName in pairs(mtsLib.darkSimSpells) do
		if ProbablyEngine.condition["casting"](unit, spellName) then return true end
	end
		return false
end

function mtsLib.canCastPlagueLeech(timeLeft)
local frostFeverApplied, _, ffExpires, ffCaster = UnitDebuff("target","Frost Fever","player")
local bloodPlagueApplied, _, bpExpires, bpCaster = UnitDebuff("target","Blood Plague","player")
local durationFF = 0
local durationBP = 0
	if ffExpires and ffCaster == "player" then
		durationFF = (ffExpires - (GetTime()-(ProbablyEngine.lag/1000)))
	end
	if bpExpires and bpCaster == "player" then
		durationBP = (bpExpires - (GetTime()-(ProbablyEngine.lag/1000)))
	end
		
	if not frostFeverApplied or not bloodPlagueApplied then return false end
	if durationFF <= timeLeft then
		return true
	end
	if durationBP <= timeLeft then
		return true
	end
		return false
end

function mtsLib.gotBloodRunes()
	if GetRuneType(1) ~= 4 and GetRuneType(2) ~= 4 then
		return true
	end 
	return false
end

function mtsLib.hasGhoul()
	if ProbablyEngine.module.player.specName == "Unholy" then
		if UnitExists("pet") == nil then return false end
	else
		if select(1,GetTotemInfo(1)) == false then return false end
	end
		return true
end


function mtsLib.ConfigWhisper(txt)
	if mtsLib.GetWisp() then
		return RunMacroText("/w "..txt)
	end
	return false
end

function mtsLib.ConfigAlert(txt)
	if mtsLib.GetAlert() then
		return mtsAlert:message(txt)
	end
end

function mtsLib.ConfigAlertSound()
	if mtsLib.GetSound() then
		PlaySoundFile(_media .. "beep.mp3", "master")
	end
end

function mtsLib.dummy()	
	for i=1, #mts_Dummies do
		if UnitExists("target") then
			mts_Dummies_ID = tonumber(UnitGUID("target"):sub(-13, -9), 16)
		else
			mts_Dummies_ID = 0
		end
		if mts_Dummies_ID == mts_Dummies[i] then
			return false
		else
			return true
		end	
	end
end

function mtsLib.ShouldTaunt()
	if UnitIsTappedByPlayer("target") 
	and mtsLib.GetTaunt()
	and not mtsLib.dummy() then
		return true
	else
		return false
	end
end

--[[ function mtsLib.FHFriendlyCheck(unit, distance)
    if FireHack then
        local total = 0
        local totalObjects = ObjectCount()
        local onUnit = UnitExists(unit)
        for i = 1, totalObjects do
            local object = ObjectWithIndex(i)
            if UnitIsPlayer(object) then
            	if not UnitIsUnit(unit, object) then
	                local reaction = UnitReaction("player", object)
	                local combat = UnitAffectingCombat(object)
	                if reaction and reaction > 4 then
	                    if onUnit then
	                        local objDistance = Distance(object, unit)
	                        if objDistance <= distance then
	                        	print(ObjectName(object), " distance:", objDistance)
	                            total = total + 1
	                        end
	                    end
	                end
	            end
            end
        end
        return total + 1
    else
        return 0
    end
end]]--Its broken


ProbablyEngine.library.register('mtsLib', mtsLib)