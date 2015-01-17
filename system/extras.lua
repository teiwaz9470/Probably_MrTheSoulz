local fetch = ProbablyEngine.interface.fetchKey
local _PeConfig = ProbablyEngine.config
local logo = "|TInterface\\AddOns\\Probably_MrTheSoulz\\media\\logo.blp:15:15|t"
local dummyStartedTime = 0
local _, minute2 = GetGameTime()
local LastPrint = 0

--[[ UNTESTED
local ranged = {
    62,         -- arcane mage
    63,         -- fire mage
    64,         -- frost mage
    65,         -- holy paladin
    102,        -- balance druid
    105,        -- restoration druid
    253,        -- beast mastery hunter
    254,        -- marksmanship hunter
    255,        -- survival hunter
    256,        -- discipline priest
    257,        -- holy priest
    258,        -- shadow priest
    262,        -- elemental shaman
    263,        -- enhancement shaman
    264,        -- restoration shaman
    265,        -- affliction warlock
    266,        -- demonology warlock
    267,        -- destruction warlock
    270,        -- mistweaver monk
  }

-- Move to unit if distance.
local function mts_MoveTo(unit, name)
	local _SpecID =  GetSpecializationInfo(GetSpecialization())
  	if fetch('mtsconf', 'AutoMove') then
  		if UnitExists(unit) and UnitIsVisible(unit) then
		  	for i=1,#ranged do
			    if FireHack then
			    	local aX, aY, aZ = ObjectPosition(unit)
				        -- If Player is ranged
				        if _SpecID == ranged[i] then
				        	if mts.Distance("player", unit) >= 30 + (UnitCombatReach('player') + UnitCombatReach(unit)) then
				        		mtsAlert:message('Moving to: '..name) 
				            	MoveTo(aX, aY, aZ)
				            end
				        -- If player is melee
				        else
				            if mts.Distance("player", unit) >= 6 + (UnitCombatReach('player') + UnitCombatReach(unit)) then
				            	mtsAlert:message('Moving to: '..name) 
				            	MoveTo(aX, aY, aZ)
				            end
				        end
			    end
			end
	  	end
	end
end]]

-- Move to unit if distance.
local function mts_MoveTo()
	local name = GetUnitName('target', false)
  	if fetch('mtsconf', 'AutoMove') then
  		if UnitExists('target') and UnitIsVisible('target') then
			if FireHack then
			   	local aX, aY, aZ = ObjectPosition('target')
				    if mts.Distance("player", 'target') >= 6 + (UnitCombatReach('player') + UnitCombatReach('target')) then
				        mtsAlert:message('Moving to: '..name) 
				        MoveTo(aX, aY, aZ)
				    end
			end
	  	end
	end
end

-- Face unit.
local function mts_FaceTo()
	local name = GetUnitName('target', false)
	if fetch('mtsconf', 'AutoFace') then
	  	if UnitExists('target') and UnitIsVisible('target') then
	    	if not mts.Infront('target') then
	      		if FireHack then
	      			mtsAlert:message('Facing: '..name) 
	        		FaceUnit('target')
	      		elseif oexecute then
	      			mtsAlert:message('Facing: '..name) 
	        		FaceToUnit('target')
	      		end
	    	end
	  	end
	end
end

--[[-----------------------------------------------
** Automated Targets **
DESC: Checks if unit can/should be targeted.

Build By: MTS & StinkyTwitch
---------------------------------------------------]]
local function mts_autoTarget(unit, name)
	if fetch('mtsconf', 'AutoTarget') then
		if UnitExists("target") and not UnitIsFriend("player", "target") and not UnitIsDeadOrGhost("target") then
			-- Do nothing
		else
		 	for i=1,#mts.unitCache do
	    		if mts.unitCache[i].name ~= UnitName("player") then
			    	mtsAlert:message('Targeting: '..mts.unitCache[i].name) 
			        return Macro("/target "..mts.unitCache[i].key)
			    end
			end
		end
	end
end

--[[----------------------------------------------- 
    ** Utility - Milling ** 
    DESC: Automatic Draenor herbs milling 
    ToDo: Test it! 

    Build By: CML 
    Modified by: Svs 
    ---------------------------------------------------]] 
local function autoMilling() 
      	if fetch('mtsconf', 'AutoMilling') and IsSpellKnown(51005) then 
		-- Frostweed 
	        if GetItemCount(109124,false,false) >= 5 then 
	          	Cast(51005) 
	          	UseItem(109124) 
	       -- Fireweed 
	        elseif GetItemCount(109125,false,false) >= 5 then 
	          	Cast(51005) 
	          	UseItem(109125)
	        -- Gorgrond Flytrap 
	        elseif GetItemCount(109126,false,false) >= 5 then 
	          	Cast(51005) 
	          	UseItem(109126) 
	        -- Starflower 
	        elseif GetItemCount(109127,false,false) >= 5 then 
	          	Cast(51005) 
	          	UseItem(109127) 
	        -- Nagrand Arrowbloom 
	        elseif GetItemCount(109128,false,false) >= 5 then 
	          	Cast(51005) 
	          	UseItem(109128) 
	        -- Talador Orchid 
	        elseif GetItemCount(109129,false,false) >= 5 then 
	          	Cast(51005) 
	          	UseItem(109129) 
		end 
	end
end

--[[----------------------------------------------- 
    ** Dummy Testing ** 
    DESC: Automatic timer for dummy testing
    ToDo: Test it! 

    Build By: MTS
    ---------------------------------------------------]]
function dummyTest(key)
	local hours, minutes = GetGameTime()
	local TimeRemaning = fetch('mtsconf', 'testDummy') - (minutes-minute2)
	
	-- If Disabled PE while runinga test, abort.
	if dummyStartedTime ~= 0 and not ProbablyEngine.config.read('button_states', 'MasterToggle', false) then
		dummyStartedTime = nil
		message('|r[|cff9482C9MTS|r] You have Disabled PE while running a dummy test. [|cffC41F3BStoped dummy test timer|r].')
	end
	-- If not Calling for refresh, then start it.
	if key ~= 'Refresh' then
		dummyStartedTime = minutes
		message('|r[|cff9482C9MTS|r] Dummy test started! [|cffC41F3BWill end in: '..fetch('mtsconf', 'testDummy').."m|r]")
		-- If PE not enabled, then enable it.
		if not ProbablyEngine.config.read('button_states', 'MasterToggle', false) then
			ProbablyEngine.buttons.toggle('MasterToggle')
		end
	end
	-- Check If time is up.
	if dummyStartedTime ~= 0 and key == 'Refresh' then
		-- Tell the user how many minutes left.
		if LastPrint ~= TimeRemaning then
			LastPrint = TimeRemaning
			print('|r[|cff9482C9MTS|r] Dummy Test minutes remaning: '..TimeRemaning)
		end
		if minutes >= dummyStartedTime + fetch('mtsconf', 'testDummy') then
			dummyStartedTime = 0
			message('|r[|cff9482C9MTS|r] Dummy test ended!')
			-- If PE enabled, then Disable it.
			if ProbablyEngine.config.read('button_states', 'MasterToggle', false) then
				ProbablyEngine.buttons.toggle('MasterToggle')
			end
		end
	end
end

C_Timer.NewTicker(0.5, (function()
	-- If using MTS profies
	if mts.CurrentCR then
		-- Refresh Dummy Testing
		dummyTest('Refresh')
		-- If PE is enabled
	  	if _PeConfig.read('button_states', 'MasterToggle', false) then
			-- If in Combat
		    	if ProbablyEngine.module.player.combat then
				mts_MoveTo()
				mts_FaceTo()
				mts_autoTarget()
	    		end
			-- If not in combat
	    		if not ProbablyEngine.module.player.combat then
	    			autoMilling() 
	    		end
	  	end
	end
end), nil)
