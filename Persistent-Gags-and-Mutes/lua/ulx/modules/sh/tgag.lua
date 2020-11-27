
-- Created by RussEfarmer on 11/26/2020 for Dinklebergs Gmod
-- These commands are adapted from the votemute and votegag commands in cobalt77's "Custom-ULX-Commands" package (https://github.com/cobalt77/Custom-ULX-Commands)

--Hook to gag players
hook.Add("PlayerCanHearPlayersVoice", "tgaghook", function(listener, talker)
	local gag = talker.tgagged
	if gag then return false end
end)

--ULX tgag command
function ulx.tgag( calling_ply, target_ply, minutes)
	minutes = math.ceil(minutes)
	print(minutes)
	target_ply:SetPData("tgagged", minutes)
	print(tostring(target_ply:GetPData("tgagged")))
	ulx.fancyLogAdmin( calling_ply, "#A has gagged #T for #i minute(s)", target_ply, minutes )
end
local tgag = ulx.command( "Chat", "ulx tgag", ulx.tgag, "!tgag" )
tgag:defaultAccess( ULib.ACCESS_ADMIN )
tgag:addParam{ type=ULib.cmds.PlayerArg }
tgag:addParam{ type=ULib.cmds.NumArg, min=1, max=30, default=3, hint="minutes", ULib.cmds.optional, ULib.cmds.round }
tgag:help( "Gags a player for a number of minutes." )

--Timed gag logic
timer.Create( "tgagtimer", 60, 0, function()
	print("tgagtimer has fired")
	for k,v in pairs( player.GetAll() ) do
	if ( not v or not IsValid(v) ) then return end
		local gag = v:GetPData( "tgagged" ) 
		if ( gag and gag != "0") then
			if ( not v.tgagged ) then
				v.tgagged = true
			end
			print(tostring(v:GetPData("tgagged")))
			v:SetPData( "tgagged", tonumber( gag ) - 1 )
			print(tostring(v:GetPData("tgagged")))
			timer.Simple( 0.5, function()
				local gag = v:GetPData( "tgagged" )
				if gag == "0" then
					v:RemovePData( "tgagged" )
					v.tgagged = nil
					ULib.tsay( nil, v:Nick() .. " was auto-ungagged." )
				end
			end )
		end
	end
end )

--ULX untgag command
function ulx.untgag( calling_ply, target_plys )
	ulx.fancyLogAdmin( calling_ply, "#A ungagged #T", target_plys )
	for k,v in pairs( target_plys ) do
		if ( v:GetPData( "tgagged" ) and v:GetPData( "tgagged" ) ~= 0 and v:GetPData( "tgagged" ) ~= "0" ) then
			print(tostring(v:GetPData("tgagged")))
			v:RemovePData( "tgagged" )
			v.tgagged = nil
			print(tostring(v:GetPData("tgagged")))
		end
	end
end
local untgag = ulx.command( "Chat", "ulx untgag", ulx.untgag, "!untgag", false)
untgag:addParam{ type=ULib.cmds.PlayersArg }
untgag:defaultAccess( ULib.ACCESS_ADMIN )
untgag:help( "Ungag the player" )