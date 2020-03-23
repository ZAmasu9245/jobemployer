surface.CreateFont( "rpjs_titleFont", {
	font = "Roboto",
	size = 22,
	weight = 500
} )
surface.CreateFont( "rpjs_jobname", {
	font = "Roboto",
	size = 75,
	weight = 700
} )
surface.CreateFont( "rpjs_salary", {
	font = "Roboto",
	size = 30,
	weight = 500
} )
surface.CreateFont( "rpjs_slots", {
	font = "Roboto",
	size = 20,
	weight = 500
} )
surface.CreateFont( "rpjs_desc", {
	font = "Roboto",
	size = 20,
	weight = 500
} )

local white = Color( 255, 255, 255, 255 )

net.Receive( "rpjs_openmenu", function( len, ply )
	if !IsValid(LocalPlayer()) && !LocalPlayer():IsPlayer() && !LocalPlayer():Alive() then return end

	local title = net.ReadString() or rpjs.config.windowtitle
	local windowtopcolor = rpjs.config.windowtopcolor
	local windowbottomcolor = rpjs.config.windowbottomcolor
	local bgcolor = rpjs.config.bgcolor
	local titlecolor = rpjs.config.titlecolor
	local resumecolor = rpjs.config.resumecolor
	local teamtable = net.ReadTable()

	local JobFrame = vgui.Create( "DFrame" )
	JobFrame:SetSize( 800, 500 )
	JobFrame:SetTitle("")
	JobFrame:Center()
	JobFrame:MakePopup()
	JobFrame:ShowCloseButton( false )
	JobFrame.Paint = function()
		draw.RoundedBox( 0, 0, 0, JobFrame:GetWide(), 25, windowtopcolor )
		draw.RoundedBox( 0, 0, 25, JobFrame:GetWide(), 3, rpjs.config.barscolor )
		draw.RoundedBox( 0, 0, 28, JobFrame:GetWide(), JobFrame:GetTall() - 28, windowbottomcolor )
		draw.SimpleText( title, 'rpjs_titleFont', 10, 2, titlecolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end

	local CloseBtn = vgui.Create( "DButton", JobFrame )
	CloseBtn:SetPos( JobFrame:GetWide() - 40, 0 )
	CloseBtn:SetSize( 30, 25 )
	CloseBtn:SetText("")
	CloseBtn.DoClick = function()
		JobFrame:Remove()
	end
	CloseBtn.Paint = function()
		draw.SimpleText( "✖", 'rpjs_titleFont', 10, 2, rpjs.config.closebtncolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end

	local JobScroll = vgui.Create( "DPanelList", JobFrame )
	JobScroll:SetPos( 10,35 )
	JobScroll:SetSize( 780, 458 )
	JobScroll:SetSpacing( 10 )
	JobScroll:EnableHorizontal( false )
	JobScroll:EnableVerticalScrollbar( true )
	

	for k,v in pairs(RPExtraTeams) do
		if k ~= LocalPlayer():Team() and table.HasValue( teamtable, v.command ) then
			local JobDivisor = vgui.Create( "DPanel", JobScroll )
			JobDivisor:SetSize( 780 , 200)
			JobDivisor:SetPos( 0, 0 )
			JobDivisor.Paint = function() end

			local JobInfos = vgui.Create( "DButton", JobDivisor )
			JobInfos:SetText("")
			JobInfos:SetSize( 760, 200 )
			JobInfos:SetPos( 0, 0 )
			JobInfos.Paint = function( self, w, h)
				draw.RoundedBox( 0, 0, 0, w, h, bgcolor)
				draw.RoundedBox( 0, 0, 0, 5, h, rpjs.config.barscolor )
				draw.SimpleText( v.name, "rpjs_jobname", 20, 10, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				if v.max == 0 then
					draw.SimpleText( team.NumPlayers( v.team ).."/∞", "rpjs_slots", 750, 10, white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
				else
					draw.SimpleText( team.NumPlayers( v.team ).."/"..v.max, "rpjs_slots", 750, 10, white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
				end
				draw.SimpleText( DarkRP.getPhrase("salary", DarkRP.formatMoney( v.money ), ""), "rpjs_salary", 20, 80, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end
			JobInfos.DoClick = function()
				if LocalPlayer():IsPlayer() && IsValid(LocalPlayer()) && LocalPlayer():Alive() then
					net.Start("rpjs_changejob")
					net.WriteInt(k,8)
					net.SendToServer()
					JobFrame:Remove()
				end
			end

			local JobModel = vgui.Create( "DModelPanel", JobDivisor )
			JobModel:SetSize( 600, 600 )
			JobModel:SetPos( 370, -80 )
			if type(v.model) == "table" then
				JobModel:SetModel(table.Random(v.model))
			else
				JobModel:SetModel(v.model)
			end
			function JobModel:LayoutEntity( Entity ) return end
			
			local JobDesc = vgui.Create( "DLabel", JobDivisor )
			JobDesc:SetPos( 20, 110 )
			JobDesc:SetSize( 500, 80 )
			JobDesc:SetText( v.description )
			JobDesc:SetFont( "rpjs_desc" )
			JobDesc:SetContentAlignment( 7 )

			JobScroll:AddItem(JobDivisor)
		end
	end

--[[-------------------------------------------------------------------------
	timer.Create( "RPJS_AutoCloseOnMove", 0.5, 0, function()
		local tr = LocalPlayer():GetEyeTrace()
		if ( IsValid( tr.Entity ) ) && tr.Entity.PrintName == "RolePlayJobSystem Entity Base" then
			-- HEY MAN WASSUP JUST LOOK UI
		else
			JobFrame:Remove()
			timer.Remove( "RPJS_AutoCloseOnMove" )
		end
	end )
---------------------------------------------------------------------------]]
end )


net.Receive( "rpjs_opennpcspawner", function( len, ply )
	local windowtopcolor = rpjs.config.windowtopcolor
	local windowbottomcolor = rpjs.config.windowbottomcolor
	local bgcolor = rpjs.config.bgcolor
	local titlecolor = rpjs.config.titlecolor
	local resumecolor = rpjs.config.resumecolor

	local AdminFrame = vgui.Create( "DFrame" )
	AdminFrame:SetSize( 600, 380 )
	AdminFrame:SetTitle("")
	AdminFrame:Center()
	AdminFrame:MakePopup()
	AdminFrame:ShowCloseButton( false )
	AdminFrame.Paint = function()
		draw.RoundedBox( 0, 0, 0, AdminFrame:GetWide(), 25, windowtopcolor )
		draw.RoundedBox( 0, 0, 25, AdminFrame:GetWide(), 3, rpjs.config.barscolor )
		draw.RoundedBox( 0, 0, 28, AdminFrame:GetWide(), AdminFrame:GetTall() - 28, windowbottomcolor )
		draw.SimpleText( "ADMIN JOB NPC SPAWNER", 'rpjs_titleFont', 10, 2, titlecolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( "Title:", 'rpjs_desc', 27, 50, titlecolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( "Model:", 'rpjs_desc', 27, 130, titlecolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( "Jobs (commands):   (comma-separated)", 'rpjs_desc', 27, 210, titlecolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end
	local CloseBtn = vgui.Create( "DButton", AdminFrame )
	CloseBtn:SetPos( AdminFrame:GetWide() - 40, 0 )
	CloseBtn:SetSize( 30, 25 )
	CloseBtn:SetText("")
	CloseBtn.DoClick = function()
		AdminFrame:Close()
	end
	CloseBtn.Paint = function()
		draw.SimpleText( "✖", 'rpjs_titleFont', 10, 2, rpjs.config.closebtncolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end

	local TextEntry1 = vgui.Create( "DTextEntry", AdminFrame )
	TextEntry1:SetPos( 25, 75 )
	TextEntry1:SetSize( 550, 45 )
	TextEntry1:SetText( "" )
	TextEntry1:SetFont( "rpjs_slots" )

	local TextEntry2 = vgui.Create( "DTextEntry", AdminFrame )
	TextEntry2:SetPos( 25, 155 )
	TextEntry2:SetSize( 550, 45 )
	TextEntry2:SetText( "" )
	TextEntry2:SetFont( "rpjs_slots" )

	local TextEntry3 = vgui.Create( "DTextEntry", AdminFrame )
	TextEntry3:SetPos( 25, 235 )
	TextEntry3:SetSize( 550, 45 )
	TextEntry3:SetText( "" )
	TextEntry3:SetFont( "rpjs_slots" )

	local Validate = vgui.Create( "DButton", AdminFrame )
	Validate:SetText( "" )
	Validate:SetPos( 26, 300 )
	Validate:SetSize( 548, 40 )
	Validate.Paint = function()
		draw.RoundedBox( 0, 0, 0, Validate:GetWide(), Validate:GetTall(), rpjs.config.resumecolor )
		draw.SimpleText( DarkRP.getPhrase("add"), 'rpjs_titleFont', 270, 20, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	Validate.DoClick = function()
		local npctable = {}
		npctable.jobs = TextEntry3:GetValue()
		npctable.model = TextEntry2:GetValue()
		npctable.title = TextEntry1:GetValue()
		net.Start("rpjs_spawnnpc")
		net.WriteTable(npctable)
		net.SendToServer()
	end
end )

hook.Add("PlayerDeath", "CloseJobWindow", function()
	if JobFrame:IsActive() then 
		JobFrame:Remove()
	end
	if AdminFrame:IsActive() then 
		AdminFrame:Remove()
	end
end)