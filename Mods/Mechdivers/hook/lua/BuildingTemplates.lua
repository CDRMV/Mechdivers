do
    local inserts = {
	    {
            'T1MDGroundDefense',
            --UEF       AEON      CYBRAN    SERAPHIM
            {false,'UABMD0201','URBMD0105',false},
        },
		{
            'T1MDGroundDefense2',
            --UEF       AEON      CYBRAN    SERAPHIM
            {false,'UABMD0202',false,false},
        },
		{
            'T2MDDronestation',
            --UEF       AEON      CYBRAN    SERAPHIM
            {false,false,'URBMD0102',false},
        },
		{
            'T2MDGroundDefense',
            --UEF       AEON      CYBRAN    SERAPHIM
            {false,false,'URBMD0106',false},
        },
		{
            'T3MDGroundDefense',
            --UEF       AEON      CYBRAN    SERAPHIM
            {false,false,'URBMD0300',false},
        },
		{
            'T3MDGroundDefense2',
            --UEF       AEON      CYBRAN    SERAPHIM
            {false,false,'URBMD0301',false},
        },
		{
            'T3MDAADefense',
            --UEF       AEON      CYBRAN    SERAPHIM
            {false,false,'URBMD0302',false},
        },
		{
            'T3MDAADefense2',
            --UEF       AEON      CYBRAN    SERAPHIM
            {'UEBMD00300',false,false,false},
        },
		{
            'T3MDMortar',
            --UEF       AEON      CYBRAN    SERAPHIM
            {false,false,'URBMD0303',false},
        },
		{
            'T3MDDeimos',
            --UEF       AEON      CYBRAN    SERAPHIM
            {'UEBMD00301',false,false,false},
        },
		{
            'T3MDDeimosStorage',
            --UEF       AEON      CYBRAN    SERAPHIM
            {'UEBMD00302',false,false,false},
        },
		{
            'T3MDAntiOrbitalCannon',
            --UEF       AEON      CYBRAN    SERAPHIM
            {'UEBMD00303','UABMD0303','URBMD0304',false},
        },
		{
            'MDExMissileLauncher',
            --UEF       AEON      CYBRAN    SERAPHIM
            {'UEBMD00400',false,false,false},
        },
        {
            'T1AdvancedLightBotFactory',
            --UEF       AEON      CYBRAN    SERAPHIM
            {false,'UABMD0100','URBMD0103',false},
        },
		{
            'T2AdvancedHeavyFactory',
            --UEF       AEON      CYBRAN    SERAPHIM
            {false,'UABMD0200','URBMD0104',false},
        },
		{
            'T2AdvancedHeavyFactory2',
            --UEF       AEON      CYBRAN    SERAPHIM
            {false,false,'URBMD0203',false},
        },
		{
            'Landingpad',
            --UEF       AEON      CYBRAN    SERAPHIM
            {'UEBMD00100',false,'URBMD00100',false},
        },
    }
    for group, data in inserts do
        for i, id in data[2] do
            if BuildingTemplates[i] and id then-- and __blueprints[id] then
                table.insert(BuildingTemplates[i], {data[1], id})
            end
        end
    end
end
