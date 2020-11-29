
-- Created by RussEfarmer on 11/26/2020 for Dinklebergs Gmod
-- These commands are adapted from the votemute, votegag and pgag commands in cobalt77's "Custom-ULX-Commands" package (https://github.com/cobalt77/Custom-ULX-Commands)

--Hook to gag players
if SERVER then
	hook.Remove("PlayerCanHearPlayersVoice", "tgaghook")
	hook.Add("PlayerCanHearPlayersVoice", "tgaghook", function(listener, talker)
		if talker.tgagged then return false end
	end)
end

--Hook to handle player reconnects
hook.Remove("PlayerAuthed", "tgagretryhook")
hook.Add("PlayerAuthed", "tgagretryhook", function(ply)
	if ply:GetPData("tgagged") then
		ply.tgagged = true
	end
end)

--ULX tgag command
function ulx.tgag( calling_ply, target_ply, minutes)
	minutes = math.ceil(minutes)
	target_ply:SetPData("tgagged", minutes)
	target_ply.tgagged = true
	ulx.fancyLogAdmin( calling_ply, "#A has gagged #T for #i minute(s)", target_ply, minutes )
end
local tgag = ulx.command( "Chat", "ulx tgag", ulx.tgag, "!tgag" )
tgag:defaultAccess( ULib.ACCESS_ADMIN )
tgag:addParam{ type=ULib.cmds.PlayerArg }
tgag:addParam{ type=ULib.cmds.NumArg, min=1, max=60, default=3, hint="minutes", ULib.cmds.optional, ULib.cmds.round }
tgag:help( "Gags a player for a number of minutes." )

--Timed gag logic
timer.Create( "tgagtimer", 60, 0, function()
	for k,v in pairs( player.GetAll() ) do
	if ( not v or not IsValid(v) ) then return end
		local gag = v:GetPData( "tgagged" ) 
		if ( gag and gag != "0") then
			if ( not v.tgagged ) then
				v.tgagged = true
			end
			v:SetPData( "tgagged", tonumber( gag ) - 1 )
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
			v:RemovePData( "tgagged" )
			v.tgagged = nil
		end
	end
end
local untgag = ulx.command( "Chat", "ulx untgag", ulx.untgag, "!untgag", false)
untgag:addParam{ type=ULib.cmds.PlayersArg }
untgag:defaultAccess( ULib.ACCESS_ADMIN )
untgag:help( "Ungag the player" )

--ULX printtgags command
function ulx.printtgags(calling_ply)
	local timedGaggedPlayers = {}
	
	for k,v in pairs(player.GetHumans()) do
		if v:GetPData("tgagged") then
			table.insert(timedGaggedPlayers, v:Nick())
		end
	end
	local message = table.concat(timedGaggedPlayers, ", ")
	ulx.fancyLog({calling_ply}, "Players currently with gags: #s", message)
end
local printtgags = ulx.command( "Chat", "ulx printtgags", ulx.printtgags, "!printtgags", true )
printtgags:defaultAccess( ULib.ACCESS_ADMIN )
printtgags:help("Lists players who are connected and have gags.")