WireToolSetup.setCategory( "Display" )
--Originally by http://forums.facepunchstudios.com/greenarrow
WireToolSetup.open( "textscreen", "Text Screen", "gmod_wire_textscreen", nil, "Text Screens" )

if CLIENT then
	language.Add("tool.wire_textscreen.name", "Text Screen Tool (Wire)" )
	language.Add("tool.wire_textscreen.desc", "Spawns a screen that displays text." )
	language.Add("tool.wire_textscreen.0", "Primary: Create/Update text screen, Secondary: Copy settings" )

	language.Add("Tool_wire_textscreen_tsize", "Text size:")
	language.Add("Tool_wire_textscreen_tjust", "Horizontal alignment:")
	language.Add("Tool_wire_textscreen_valign", "Vertical alignment:")
	language.Add("Tool_wire_textscreen_colour", "Text colour:")
	language.Add("Tool_wire_textscreen_createflat", "Create flat to surface")
	language.Add("Tool_wire_textscreen_text", "Default text:")
end
WireToolSetup.BaseLang()

WireToolSetup.SetupMax( 20, "wire_textscreens", "You've hit sound text screens limit!" )

if SERVER then
	ModelPlug_Register("speaker")

	function TOOL:GetConVars()
		return
			self:GetClientInfo("text"),
			(16 - tonumber(self:GetClientInfo("tsize"))),
			self:GetClientNumber("tjust"),
			self:GetClientNumber("valign"),
			Color(
				math.min(self:GetClientNumber("tred"), 255),
				math.min(self:GetClientNumber("tgreen"), 255),
				math.min(self:GetClientNumber("tblue"), 255)
			),
			Color(0,0,0)
	end

	function TOOL:MakeEnt( ply, model, Ang, trace )
		return MakeWireTextScreen( ply, trace.HitPos, Ang, model, self:GetConVars() )
	end
end

TOOL.ClientConVar = {
	model       = "models/kobilica/wiremonitorbig.mdl",
	tsize       = 10,
	tjust       = 1,
	valign      = 0,
	tred        = 255,
	tblue       = 255,
	tgreen      = 255,
	ninputs     = 3,
	createflat  = 1,
	weld        = 1,
	text        = "",
}

function TOOL:RightClick( trace )
	if not trace.HitPos then return false end
	local ent = trace.Entity
	if ent:IsPlayer() then return false end
	if CLIENT then return true end

	local ply = self:GetOwner()

	if ent:IsValid() && ent:GetClass() == "gmod_wire_textscreen" then
		ply:ConCommand('wire_textscreen_text "'..ent.text..'"')
		return true
	end

end

function TOOL.BuildCPanel(panel)
	WireToolHelpers.MakePresetControl(panel, "wire_textscreen")
	panel:NumSlider("#Tool_wire_textscreen_tsize", "wire_textscreen_tsize", 1, 15, 0)
	panel:NumSlider("#Tool_wire_textscreen_tjust", "wire_textscreen_tjust", 0, 2, 0)
	panel:NumSlider("#Tool_wire_textscreen_valign", "wire_textscreen_valign", 0, 2, 0)
	panel:AddControl("Color", {
		Label = "#Tool_wire_textscreen_colour",
		Red = "wire_textscreen_tred",
		Green = "wire_textscreen_tgreen",
		Blue = "wire_textscreen_tblue",
		ShowAlpha = "0",
		ShowHSV = "1",
		ShowRGB = "1",
		Multiplier = "255"
	})
	WireDermaExts.ModelSelect(panel, "wire_textscreen_model", list.Get( "WireScreenModels" ), 2)
	panel:CheckBox("#Tool_wire_textscreen_createflat", "wire_textscreen_createflat")
	panel:TextEntry("#Tool_wire_textscreen_text", "wire_textscreen_text")

	panel:CheckBox("Weld", "wire_textscreen_weld")
end
