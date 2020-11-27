
-- Created by RussEfarmer on 11/26/2020 for Dinklebergs Gmod
-- These commands are adapted from the votemute and votegag commands in cobalt77's "Custom-ULX-Commands" package (https://github.com/cobalt77/Custom-ULX-Commands)

--ULX tmute command
function ulx.tmute( calling_ply, target_ply, minutes)
	minutes = math.ceil(minutes)
	target_ply:SetPData("tmuted", minutes)
	target_ply.tmuted = true
	ulx.fancyLogAdmin( calling_ply, "#A has muted #T for #i minute(s)", target_ply, minutes )
end
local tmute = ulx.command( "Chat", "ulx tmute", ulx.tmute, "!tmute" )
tmute:defaultAccess( ULib.ACCESS_ADMIN )
tmute:addParam{ type=ULib.cmds.PlayerArg }
tmute:addParam{ type=ULib.cmds.NumArg, min=0, max-30, default=3, hint="minutes", ULib.cmds.optional, ULib.cmds.round }
tmute:help( "Mutes a player for a number of minutes." )

--Timed mute logic
timer.Create( "tmutetimer", 60, 0, function()
	for k,v in pairs( player.GetAll() ) do
		if ( not v or not IsValid(v) ) then return end
			if ( v:GetPData( "tmuted" ) and v:GetPData( "tmuted" ) ~= 0 and v:GetPData( "tmuted" ) ~= "0" ) then
			v:SetPData( "tmuted", tonumber( v:GetPData( "tmuted" ) ) - 1 )	
			timer.Simple( 0.5, function()
				if v:GetPData( "tmuted" ) == 0 or v:GetPData( "tmuted" ) == "0" then	
					v:RemovePData( "tmuted" )	
					ULib.tsay( nil, v:Nick() .. " was auto-unmuted." )	
				end	
			end )
		end
	end
end )

--ULX Untmute Command
function ulx.untmute( calling_ply, target_plys )
	ulx.fancyLogAdmin( calling_ply, "#A unmuted #T", target_plys )
	for k,v in pairs( target_plys ) do
		if ( v:GetPData( "tmuted" ) and v:GetPData( "tmuted" ) ~= 0 and v:GetPData( "tmuted" ) ~= "0" ) then
			v:RemovePData( "tmuted" )
		end
	end
end
local untmute = ulx.command( "Chat", "ulx untmute", ulx.untmute, "!untmute" )
untmute:addParam{ type=ULib.cmds.PlayersArg }
untmute:defaultAccess( ULib.ACCESS_ADMIN )
untmute:help( "Unmute the player" )

--Hook to mute player
hook.Add( "PlayerSay", "tmutehook", function(ply)
	if (ply:GetPData( "tmuted" ) and ply:GetPData( "tmuted" ) ~= 0 and ply:GetPData( "tmuted" ) ~= "0" ) then
		return ""
	end
end)