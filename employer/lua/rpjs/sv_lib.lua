util.AddNetworkString( "rpjs_openmenu" )
util.AddNetworkString( "rpjs_changejob" )
util.AddNetworkString( "rpjs_opennpcspawner" )
util.AddNetworkString( "rpjs_spawnnpc" )

function rpjs_print( msg, state )
	if (state == "error") then
		MsgC(Color(255,0,0),"[RPJS] ",Color(255,255,255),msg .. "\n")
	elseif (state == "success") then
		MsgC(Color(0,255,0),"[RPJS] ",Color(255,255,255),msg .. "\n")
	else
		MsgC(Color(0,255,255),"[RPJS] ",Color(255,255,255),msg .. "\n")
	end
end

concommand.Add("rpjs_spawn", function(ply, cmd, args, argStr )
    if not table.HasValue(rpjs.config.admins, ply:GetUserGroup()) then return end
	RPJS_OpenNPCSpawner(ply)
end)

concommand.Add("rpjs_debug", function(ply, cmd, args, argStr ) -- FOR DEBUG PURPOSE, IF YOU REMOVE THIS, I WILL NOT GIVE YOU ANY SUPPORT
	if not rpjs.config.debug then return end
	print(" ")
    print("+++++++++++++++++++++++++++++++++++")
	print("+     DEBUG RolePlayJobSystem     +")
	print("+    RPJS is Serverside loaded    +")
	print("+                                 +")
	print("+    +        +++++++        +    +")
	print("+                                 +")
	print("+ Player running DEBUG: " .. ply:GetName() )
	print("+                                 +")
    if table.HasValue(rpjs.config.admins, ply:GetUserGroup()) then 
    	print("+      Player is in admin table       +")
	end
	if not table.HasValue(rpjs.config.admins, ply:GetUserGroup()) then
    	print("+      Player is not in admin table       +")
	end
	if rpjs.loaded.tcmds then
		print("+     TeamCommands have been      +")
		print("+      successfully removed       +")
	else
		print("+        There is an error        +")
		print("+      with removing TCMDS        +")
	end
	print("+      Gamemode: " .. GAMEMODE_NAME .. "           +")

	print( "+  VERSION: " .. rpjs.version )

	print("+                                 +")
	print("+++++++++++++++++++++++++++++++++++")
	print(" ")
end)

hook.Add( "PlayerSay", "PlayerSayExample", function( ply, text, team )
	if ( text == "!rpjs" ) then
		ply:ConCommand( "rpjs_spawn" )
		return ""
	end
end )

function RPJS_RolePlayJobSystem( title, jobs, player )
	net.Start( "rpjs_openmenu" )
	local jobs1 = string.gsub(jobs, " ", "")
	local teamtable = string.Split( jobs1, "," )
	net.WriteString( title )
	net.WriteTable( teamtable )
	net.Send(player)
end

function RPJS_OpenNPCSpawner( player )
	net.Start( "rpjs_opennpcspawner" )
	net.Send(player)
end

local function teamvote( ply, team, teaminfos )
	if #player.GetAll( ) > 1 then
        DarkRP.createVote(DarkRP.getPhrase("wants_to_be", ply:Nick(), teaminfos), "rpjs_vote", ply, 20, function(vote, choice)
            if choice >= 0 then
                ply:changeTeam(team)
            else
                DarkRP.notifyAll(1, 4, DarkRP.getPhrase("has_not_been_made_team", ply:Nick(), teaminfos))
            end
        end, nil, nil, nil)
	else
		ply:changeTeam(team)
    end
end

local function checknpc( ply, teamcmd )
	for k,ent in pairs(ents.GetAll()) do
		if ent:GetClass() == "rpjs_base_npc" then
			if ply:GetPos():Distance(ent:GetPos()) < rpjs.config.distance then
				local jobs1 = string.gsub(ent:GetJobss(), " ", "")
				local teamtable = string.Split( jobs1, "," )
				if table.HasValue( teamtable, teamcmd ) then return true end
			end
		end
	end
	return false
end

net.Receive( "rpjs_spawnnpc", function( len, ply )
	if IsValid(ply) && ply:IsPlayer() && ply:Alive() then
		if not table.HasValue(rpjs.config.admins, ply:GetUserGroup()) then return end
		local npctbl = net.ReadTable()
		local model = npctbl.model
		local jobs = npctbl.jobs
		local title = npctbl.title
    	local ent = ents.Create("rpjs_base_npc")
    	ent:SetJobss(jobs)
    	ent:SetTitle(title)
    	ent:SetModel(model)
    	ent:SetPos( ply:GetPos() )
		ent:Spawn()
	end
end )

net.Receive( "rpjs_changejob", function( len, ply )
	if !IsValid(ply) && !ply:IsPlayer() && !ply:Alive() then return end
	local team = net.ReadInt(8)
	local teamname = RPExtraTeams[team].name
	local vote = RPExtraTeams[team].vote
	local cmd = RPExtraTeams[team].command
	if !checknpc(ply, cmd) then return end
	if BWhitelist then
		BWhitelist:IsWhitelisted(ply, team, function()
			if vote == "true" then
				teamvote(ply, team, teamname)
			else
				ply:changeTeam(team)
			end
		end)
	else
		if vote == "true" then
			teamvote(ply, team, teamname)
		else
			ply:changeTeam(team)
		end
	end
end )


-- DISABLE Job Commands (I use SetTeam, so to disable use of the F4 and chat to get Team)
rpjs.loadedtcmds = false
function RPJS_TeamCMDSRemover()
	if rpjs.loadedtcmds then return end
	for k,v in pairs(RPExtraTeams) do
		DarkRP.removeChatCommand(v.command)
		if v.vote or v.RequiresVote then
			DarkRP.removeChatCommand("vote" .. v.command)
		end
	end
	rpjs_print( "Team Commands have been loaded", "success" )
	rpjs.loadedtcmds = true
end
hook.Add("PlayerInitialSpawn","RPJS_HOOK__DARKRP_TCMDSRMV", RPJS_TeamCMDSRemover)
hook.Add("ezJobsLoaded","RPJS_HOOK__EZJOBS_TCMDSRMV", RPJS_TeamCMDSRemover)