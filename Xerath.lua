local ver = "0.01"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "Xerath" then return end

require("OpenPredict")
require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/Xerath/master/Xerath.lua', SCRIPT_PATH .. 'Xerath.lua', function() PrintChat('<font color = "#00FFFF">Xerath Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/Xerath/master/Xerath.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local XerathR = {delay = .5, range = 6000, width = 250, speed = 1200}

local XerathMenu = Menu("Xerath", "Xerath")

XerathMenu:SubMenu("Combo", "Combo")

XerathMenu.Combo:Boolean("Q", "Use Q in combo", true)
XerathMenu.Combo:Boolean("AA", "Use AA in combo", true)
XerathMenu.Combo:Boolean("W", "Use W in combo", true)
XerathMenu.Combo:Boolean("E", "Use E in combo", true)
XerathMenu.Combo:Boolean("R", "Use R in combo", true)
XerathMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
XerathMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
XerathMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
XerathMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
XerathMenu.Combo:Boolean("RHydra", "Use RHydra", true)
XerathMenu.Combo:Boolean("THydra", "Use THydra", true)
XerathMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
XerathMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
XerathMenu.Combo:Boolean("Randuins", "Use Randuins", true)


XerathMenu:SubMenu("AutoMode", "AutoMode")
XerathMenu.AutoMode:Boolean("Level", "Auto level spells", false)
XerathMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
XerathMenu.AutoMode:Boolean("Q", "Auto Q", false)
XerathMenu.AutoMode:Boolean("W", "Auto W", false)
XerathMenu.AutoMode:Boolean("E", "Auto E", false)
XerathMenu.AutoMode:Boolean("R", "Auto R", false)


XerathMenu:SubMenu("LaneClear", "LaneClear")
XerathMenu.LaneClear:Boolean("Q", "Use Q", true)
XerathMenu.LaneClear:Boolean("W", "Use W", true)
XerathMenu.LaneClear:Boolean("E", "Use E", true)
XerathMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
XerathMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

XerathMenu:SubMenu("Harass", "Harass")
XerathMenu.Harass:Boolean("Q", "Use Q", true)
XerathMenu.Harass:Boolean("W", "Use W", true)

XerathMenu:SubMenu("KillSteal", "KillSteal")
XerathMenu.KillSteal:Boolean("Q", "KS w Q", true)
XerathMenu.KillSteal:Boolean("E", "KS w E", true)
XerathMenu.KillSteal:Boolean("R", "KS w R", true)
XerathMenu.KillSteal:Slider("Rpred", "R Hit Chance", 3,0,10,1)
XerathMenu.KillSteal:Boolean("W", "KS w W", true)

XerathMenu:SubMenu("AutoIgnite", "AutoIgnite")
XerathMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

XerathMenu:SubMenu("Drawings", "Drawings")
XerathMenu.Drawings:Boolean("DQ", "Draw Q Range", true)

XerathMenu:SubMenu("SkinChanger", "SkinChanger")
XerathMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
XerathMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)
        local THydra = GetItemSlot(myHero, 3748)
		
	--AUTO LEVEL UP
	if XerathMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if XerathMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 750) then
				if target ~= nil then 
                                      CastSkillShot2(_Q, enemy)
                                end
            end

            if XerathMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 650) then
				CastTargetSpell(target, _W)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
		
	    if XerathMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 500) and (EnemiesAround(myHeroPos(), 500) >= XerathMenu.Combo.RX:Value()) then
			CastSpell(_R)
            end
			
            if XerathMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if XerathMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if XerathMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if XerathMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

            if XerathMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 1280) then
			 CastSkillShot(_E, target.pos)
	    end

            if XerathMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 650) then
			CastTargetSpell(target, _W)
            end		
			   				    
            if XerathMenu.Combo.AA:Value() and ValidTarget(target, 125) then
                         AttackUnit(target)
            end	
			
	    if XerathMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 750) then
		     if target ~= nil then 
                         CastSkillShot(_Q, target)
                     end
            end	
			
            if XerathMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 750) then
		     if target ~= nil then 
                         CastSkillShot2(_Q, target)
                     end
            end
				  
            if XerathMenu.Combo.AA:Value() and ValidTarget(target, 125) then
                         AttackUnit(target)
            end

            
            if XerathMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if XerathMenu.Combo.AA:Value() and ValidTarget(target, 125) then
                         AttackUnit(target)
            end

            if XerathMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if XerathMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end
				
			
	    if XerathMenu.Combo.THydra:Value() and THydra > 0 and Ready(THydra) and ValidTarget(target, 400) then
			CastSpell(THydra)
            end	

	    	                			
            if XerathMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 6160) and (EnemiesAround(myHeroPos(), 6160) >= XerathMenu.Combo.RX:Value()) then
			CastTargetSpell(target, _R)
            end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 750) and XerathMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         if target ~= nil then 
                                      CastSkillShot2(_Q, target)
		         end
                end 

                if IsReady(_R) and ValidTarget(enemy, 900) and XerathMenu.KillSteal.R:Value() and GetHP(enemy) < getdmg("R",enemy) then
		                      CastSkillShot(_R, target)
  
                end
			
		if IsReady(_W) and ValidTarget(enemy, 650) and XerathMenu.KillSteal.W:Value() and GetHP(enemy) < getdmg("W",enemy) then
		                      CastTargetSpell(target, _W)  
                end	
			
			if IsReady(_E) and ValidTarget(enemy, 325) and XerathMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                       CastSkillShot(_E, target.pos)
                end
                               
                if IsReady(_R) and ValidTarget(enemy, 6160) and XerathMenu.KillSteal.R:Value() and GetHP(enemy) < getdmg("R",enemy) then
		                        local RPred = GetPrediction(target,XerathR)
                       if RPred.hitChance > (XerathMenu.KillSteal.Rpred:Value() * 0.1) then
                                 CastTargetSpell(RPred.castPos, _R)
                       end

                end

      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if XerathMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 750) then
	        	CastSkillShot(_Q, closeminion)
                end	
				
	        if XerathMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 750) then
	        	CastSkillShot2(_Q, closeminion)
                end

                if XerathMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 650) then
	        	CastTargetSpell(closeminion, _W)
	        end

                if XerathMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 1280) then
	        	CastSkillShot(_E, closeminion)
	        end

                if XerathMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if XerathMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if XerathMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 750) then
		      CastSkillShot2(_Q, target)
          end
        end 
        if XerathMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 650) then
	  	      CastTargetSpell(target, _W)
          end
        end
        if XerathMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 1280) then
		      CastSkillShot(_E, target.pos)
	  end
        end
        if XerathMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 6160) then
		     CastTargetSpell(target, _R)
	  end
        end
		
			
	--AUTO GHOST
	if XerathMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if XerathMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 750, 0, 200, GoS.Black)
	end

end)





local function SkinChanger()
	if XerathMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Xerath</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





