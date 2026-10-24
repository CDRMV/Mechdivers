do 
skins = table.merged( skins, {
    terminids = {
        default = "uef",
        texturesPath = "/textures/ui/seraphim",
        imagerMesh = "/mods/Mechdivers/meshes/game/map-border_squ_term_mesh",
        imagerMeshDetails = "",
        imagerMeshHorz = "",
        imagerMeshDetailsHorz = "",
        buttonFont = "Zeroes Three",
	    factionFont = "Zeroes Three",
        bodyFont = "Arial",
        fixedFont = "Arial",
        titleFont = "Zeroes Three",
        fontColor = "FFDB9257",
        bodyColor = "FFDB9257",
        factionFontOverColor = "FFDB9257",
        factionFontDownColor = "FF967A64",
	    dialogCaptionColor = "FFDB9257",
        dialogColumnColor = "FFDB9257",
        dialogButtonColor = "FFDB9257",
        dialogButtonFont = "Zeroes Three",
        highlightColor = "FFDB9257",
        disabledColor = "FF967A64",
        tooltipBorderColor = "FF98531B",
        tooltipTitleColor = "FF864A19",
        tooltipBackgroundColor = "#FF000000",
        menuFontSize = 18,
        layouts = {
            "bottom",
            "left",
            "right"
        },
    },
})

local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then

else
for k, v in skins do
    local default = skins[v.default]
    while default do
        -- Copy the entire default chain into the toplevel skin.
        table.assimilate(v, default)

        default = skins[default.default]
    end
end	
end
end	
