if CLIENT then
	local ld_enable = CreateClientConVar("pp_ldistortion", "0", true, false)
	local ld_refract = CreateClientConVar("pp_ldistortion_refract", "0", true, false)
	local ld_tex = CreateClientConVar("pp_ldistortion_tex", "overlay/barrellens", true, false)

	list.Set("PostProcess", "Lens Distortion", {
		icon = "gui/postprocess/bloom.png",
		convar = "pp_ldistortion",
		category = "#shaders_pp",
		cpanel = function(CPanel)
			
			local params = {
				Options = {},
              	CVars = {},
              	MenuButton = "1",
				Folder = "lensdistortion"
			}

			params.Options["#preset.default"] = {
				pp_ldistortion_refract = "0"
			}				
				
			params.CVars = table.GetKeys(params.Options["#preset.default"])
			CPanel:AddControl("ComboBox", params)
			
			CPanel:AddControl("CheckBox", { 
				Label = "Enable", 
				Command = "pp_ldistortion" 
			})

			CPanel:AddControl("Slider", {
				Label = "Refract",
				Command = "pp_ldistortion_refract",
				Type = "Float",
				Min = "-0.1",
				Max = "0"
			})
			
			local combobox, label = CPanel:ComboBox("Texture", "pp_ldistortion_tex")
				combobox:AddChoice("V1", "overlay/barrellens")
				combobox:AddChoice("V2", "overlay/barrellensV2")

		end
	})
	
	--local texoverlay = Material("overlay/barrellens")
	local texoverlay = Material(ld_tex:GetString())
	cvars.AddChangeCallback("pp_ldistortion_tex", function (_, __, ___)
		texoverlay = Material(ld_tex:GetString())
		--texoverlay:SetTexture ("$normalmap", ld_tex:GetString())
	end)
	local w, h = ScrW(), ScrH()
	
	hook.Add( "RenderScreenspaceEffects", "RenderDistortion", function()
		if not ld_enable:GetBool() then return end
		local refractamount = ld_refract:GetFloat()

		render.UpdateScreenEffectTexture()	
		texoverlay:SetFloat( "$envmap", 0 )
		texoverlay:SetFloat( "$envmaptint", 0 )
		texoverlay:SetFloat( "$refractamount", refractamount )
		texoverlay:SetInt( "$ignorez", 1)

		render.SetMaterial( texoverlay )
		render.DrawScreenQuadEx( -1, -1, w+2 ,h+2)
	end)
end