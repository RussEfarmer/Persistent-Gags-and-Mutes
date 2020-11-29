
-- Created by RussEfarmer on 11/26/2020 for Dinklebergs Gmod
-- These commands are adapted from the votemute and votegag commands in cobalt77's "Custom-ULX-Commands" package (https://github.com/cobalt77/Custom-ULX-Commands)

--Hook to mute player
hook.Add( "PlayerSay", "pmutehook", function(ply)
	if (ply:GetPData( "pmuted" ) and ply:GetPData( "pmuted" ) ~= 0 and ply:GetPData( "pmuted" ) ~= "0" ) then
		return ""
	end
end)

--ULX pmute command
function ulx.pmute( calling_ply, target_ply)
	target_ply:SetPData("pmuted", true)
	ulx.fancyLogAdmin( calling_ply, "#A permanently muted #T", target_ply )
end
local pmute = ulx.command( "Chat", "ulx pmute", ulx.pmute, "!pmute" )
pmute:defaultAccess( ULib.ACCESS_ADMIN )
pmute:addParam{ type=ULib.cmds.PlayerArg }
pmute:help( "Mutes a player for a number of minutes." )

--ULX Unpmute Command
function ulx.unpmute( calling_ply, target_plys )
	ulx.fancyLogAdmin( calling_ply, "#A unmuted #T", target_plys )
	for k,v in pairs( target_plys ) do
		if ( v:GetPData( "pmuted" ) and v:GetPData( "pmuted" ) == true) then
			v:RemovePData( "pmuted" )
		end
	end
end
local unpmute = ulx.command( "Chat", "ulx unpmute", ulx.unpmute, "!unpmute" )
unpmute:addParam{ type=ULib.cmds.PlayersArg }
unpmute:defaultAccess( ULib.ACCESS_ADMIN )
unpmute:help( "Unmute the player" )