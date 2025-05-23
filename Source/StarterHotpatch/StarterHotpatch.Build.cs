// Copyright (c) 2025 Daft Software.

using UnrealBuildTool;

public class StarterHotpatch : ModuleRules
{
	public StarterHotpatch(ReadOnlyTargetRules Target) : base(Target)
	{
		PCHUsage = PCHUsageMode.UseExplicitOrSharedPCHs;

		PrivateDependencyModuleNames.AddRange(new string[]
		{
			"Core",
			"Engine",
			"UnrealEd"
		});
	}
}
