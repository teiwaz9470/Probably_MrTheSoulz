local fetch = ProbablyEngine.interface.fetchKey

mts_unitCache = {}
mts_unitFriendlyCache = {}

local function mts_unitCacheFun()
  -- Wipe Chace before refresh otherwise it just adds to the cache...
  wipe(mts_unitCache)
  wipe(mts_unitFriendlyCache)
  unitCacheTotal = 0
  unitCacheFriendlyTotal = 0
  
	-- If we're using FireHack...  
		if FireHack and fetch("cacheInfo", "AC") then
			local totalObjects = ObjectCount()
				for i=1, totalObjects do
					local object = ObjectWithIndex(i)
						if ObjectExists(object) then
							if ObjectIsType(object, ObjectTypes.Unit) and ProbablyEngine.condition["alive"](object) then
								local distance = mts_Distance('player', object)
								local health = UnitHealth(object)
								local name = GetUnitName(object, false)
									if distance <= (fetch("cacheInfo", "CD") or 40) then
										-- Friendly Cache
										if UnitIsFriend("player", object) then
											-- Enabled on GUI
											if fetch("cacheInfo", "FU") then
												-- Cache only Players
												if fetch("cacheInfo", "FU2") == 'Players' then
													if UnitIsPlayer(object) then
														unitCacheFriendlyTotal = unitCacheFriendlyTotal + 1
														table.insert(mts_unitFriendlyCache, {key=object, value=distance, health=health, friend=friend, name=name})
														table.sort(mts_unitFriendlyCache, function(a,b) return a.value < b.value end)
													end
												-- Cache Only Party/Raid
                                                elseif fetch("cacheInfo", "FU2") == 'PR' then
                                                    if UnitIsPlayer(object) and (UnitInParty(object) or UnitInRaid(object)) then
                                                        unitCacheFriendlyTotal = unitCacheFriendlyTotal + 1
                                                        table.insert(mts_unitFriendlyCache, {key=object, value=distance, health=health, friend=friend, name=name})
                                                        table.sort(mts_unitFriendlyCache, function(a,b) return a.value < b.value end)
													end
                                                -- Cache All
                                                else
													unitCacheFriendlyTotal = unitCacheFriendlyTotal + 1
													table.insert(mts_unitFriendlyCache, {key=object, value=distance, health=health, friend=friend, name=name})
													table.sort(mts_unitFriendlyCache, function(a,b) return a.value < b.value end)
												end
											end
										-- All Other units cache
										else
											-- Enabled on GUI and unit affecting combat
											if fetch("cacheInfo", "EU") and not mts_immuneEvents(object) then
                                                if fetch("cacheInfo", "EU2") == 'Combat' then 
                                                    if UnitAffectingCombat(object) then
                                                        unitCacheTotal = unitCacheTotal + 1
                                                        table.insert(mts_unitCache, {key=object, value=distance, health=health, friend=friend, name=name})
                                                        table.sort(mts_unitCache, function(a,b) return a.value < b.value end)
                                                    end
                                                else
    											     unitCacheTotal = unitCacheTotal + 1
    											     table.insert(mts_unitCache, {key=object, value=distance, health=health, friend=friend, name=name})
    											     table.sort(mts_unitCache, function(a,b) return a.value < b.value end)
											    end
											end
										end
									end
							end
						end
					end
			-- Cache Raid/Party Targets
			else
				local groupType = IsInRaid() and "raid" or "party"
					for i = 1, GetNumGroupMembers() do
						local object = groupType..i.."target"
							if distance <= (fetch("cacheInfo", "CD") or 40) then
										-- Friendly Cache
										if UnitIsFriend("player", object) then
											-- Enabled on GUI
											if fetch("cacheInfo", "FU") then
												-- Cache only Players
												if fetch("cacheInfo", "FU2") == 'Players' then
													if UnitIsPlayer(object) then
														unitCacheFriendlyTotal = unitCacheFriendlyTotal + 1
														table.insert(mts_unitFriendlyCache, {key=object, value=distance, health=health, friend=friend, name=name})
														table.sort(mts_unitFriendlyCache, function(a,b) return a.value < b.value end)
													end
												-- Cache All
												else
													unitCacheFriendlyTotal = unitCacheFriendlyTotal + 1
													table.insert(mts_unitFriendlyCache, {key=object, value=distance, health=health, friend=friend, name=name})
													table.sort(mts_unitFriendlyCache, function(a,b) return a.value < b.value end)
												end
											end
										-- All Other units cache
										else
											-- Enabled on GUI
											if fetch("cacheInfo", "EU") then
												unitCacheTotal = unitCacheTotal + 1
												table.insert(mts_unitCache, {key=object, value=distance, health=health, friend=friend, name=name})
												table.sort(mts_unitCache, function(a,b) return a.value < b.value end)
											end
										end
									end
					end
			end
end

--[[
    This shit is completly broken -.-
    The plan: to Display the cache on a GUI
    so we can keep track of all units LIVE.
    Error atm: Only displays the last unit in the cache...
]]
--
local mts_cacheInfo = {
    key = "cacheInfo",
    title = "MrTheSoulz cache",
    subtitle = "mts cache",
    color = "9482C9",
    width = 210,
    height = 350,
    config = {
	
				{ 
					type = 'text', 
					text = "|cff9482C9Cache Options:", 
					size = 20, 
					offset = 0 
				},
					{ 
						type = "checkbox", 
						text = "Use Advanced Object Manager", 
						key = "AC", 
						default = true, 
					},
					{ 
						type = "checkbox", 
						text = "Cache Friendly Units", 
						key = "FU", 
						default = true, 
					},
                    { 
                        type = "checkbox", 
                        text = "Cache Enemie Units", 
                        key = "EU", 
                        default = true, 
                    },
					{ 
						type = "dropdown",
						text = "Friendly Units", 
						key = "FU2", 
						list = {
							{
							  text = "All",
							  key = "All"
							},
							{
							  text = "Players",
							  key = "Players"
							},
                            {
                              text = "Party/Raid",
                              key = "PR"
                            },
						}, 
						default = "PR" 
					},
                    { 
                        type = "dropdown",
                        text = "Enemie Units", 
                        key = "EU2", 
                        list = {
                            {
                              text = "All",
                              key = "All"
                            },
                            {
                              text = "Combat",
                              key = "Combat"
                            },
                        }, 
                        default = "Combat" 
                    },
					{
						type = "spinner",
						text = "Cache distance",
						key = "CD",
						width = 50,
						min = 10,
						max = 80,
						default = 40,
						step = 5
					},
				{ type = 'rule' },{ type = 'spacer' },
				{ 
					type = 'text', 
					text = "|cff9482C9Unit Cache:", 
					size = 20, 
					offset = 0 
				},
					{ 
						key = 'current_Cache1Total', 
						type = "text", 
						text = "Random", 
						size = 11, 
						offset = 0 
					},
					{ 
						type = 'text', 
						text = " ---> |cff0070DEUnits:|r <---", 
						size = 11, 
						offset = 0 
					},
					{ 
						key = 'current_Cache1', 
						type = "text", 
						text = "Random", 
						size = 11, 
						offset = 36 
					},
				{ type = 'rule' },{ type = 'spacer' },
				{ 
					type = 'text', 
					text = "|cff9482C9Friendly Unit Cache:", 
					size = 20, 
					offset = 0 
				},
					{ 
						key = 'current_Cache2Total', 
						type = "text", 
						text = "Random", 
						size = 11, 
						offset = 0 
					},
					{ 
						type = 'text', 
						text = " ---> |cff0070DEUnits:|r <---", 
						size = 11, 
						offset = 0 
					},
					{ 
						key = 'current_Cache2', 
						type = "text", 
						text = "Random", 
						size = 11, 
						offset = 36 
					},

        
    }
}
local mts_cacheWindow
local mts_OpenCacheWindow = false
local mts_ShowingCacheWindow = false
local mts_cacheWindowUpdating = false

local function mts_updateCacheInfo()
    for i=1,#mts_unitCache do
		mts_cacheWindow.elements.current_Cache1Total:SetText("|cff0070DETotal:|r "..unitCacheTotal)
        mts_cacheWindow.elements.current_Cache1:SetText("|cff00FF96NAME:|r "..mts_unitCache[i].name.."\n |--> |cff0070DEGUID:|r "..mts_unitCache[i].key.."\n |--> |cff0070DEDistance:|r "..mts_unitCache[i].value.."\n |--> |cff0070DEHealth:|r "..mts_unitCache[i].health)
    end
	for s=1,#mts_unitFriendlyCache do
		mts_cacheWindow.elements.current_Cache2Total:SetText("|cff0070DETotal:|r "..unitCacheFriendlyTotal)
        mts_cacheWindow.elements.current_Cache2:SetText("|cff00FF96NAME:|r "..mts_unitFriendlyCache[s].name.."\n |--> |cff0070DEGUID:|r "..mts_unitFriendlyCache[s].key.."\n |--> |cff0070DEDistance:|r "..mts_unitFriendlyCache[s].value.."\n |--> |cff0070DEHealth:|r "..mts_unitFriendlyCache[s].health)
    end
end

function mts_cacheGUI()
    if not mts_OpenCacheWindow then
        mts_cacheWindow = ProbablyEngine.interface.buildGUI(mts_cacheInfo)
        mts_cacheWindowUpdating = true
        mts_OpenCacheWindow = true
        mts_ShowingCacheWindow = true
        mts_cacheWindow.parent:SetEventListener('OnClose', function()
            mts_OpenCacheWindow = false
            mts_ShowingCacheWindow = false
        end)
    
    elseif mts_OpenCacheWindow == true and mts_ShowingCacheWindow == true then
        mts_cacheWindowUpdating = false
        mts_cacheWindow.parent:Hide()
        mts_ShowingCacheWindow = false
    
    elseif mts_OpenCacheWindow == true and mts_ShowingCacheWindow == false then
        mts_cacheWindowUpdating = true
        mts_cacheWindow.parent:Show()
        mts_ShowingCacheWindow = true
    end

    if mts_cacheWindowUpdating then
        C_Timer.NewTicker(1.00, mts_updateCacheInfo, nil)
    end

end

C_Timer.NewTicker(0.1, (function()
    mts_unitCacheFun()
end), nil)