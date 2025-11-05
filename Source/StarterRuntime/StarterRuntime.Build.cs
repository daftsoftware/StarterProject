// Copyright (c) 2025 Daft Software.

using UnrealBuildTool;

public class StarterRuntime : ModuleRules
{
	public StarterRuntime(ReadOnlyTargetRules Target) : base(Target)
	{
		PCHUsage = PCHUsageMode.UseExplicitOrSharedPCHs;
	
		PublicDependencyModuleNames.AddRange(new string[]
		{
			"Core",
		});

		PrivateDependencyModuleNames.AddRange(new string[]
		{
			"CoreUObject",
			"Engine",
		});
	}
}
