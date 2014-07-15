
-- Info.lua

-- Implements the g_PluginInfo standard plugin description

g_PluginInfo =
{
	Name = "CraftMaker",
	Version = 1,
	Date = "2014-07-15",
	Description = "Allows people to make new recipes easily",
	
	Commands =
	{
		["/craftmaker"] =
		{
			Alias = {"/cm"},
			Permission = "craftmaker.use",
			Handler = HandleCraftMakerCommand,
			HelpString = "Allows people to make new recipes easily.",
		},
	},
}