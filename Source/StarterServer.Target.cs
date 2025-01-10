// Copyright (c) 2025 Daft Software.

using UnrealBuildTool;
using System.Collections.Generic;

[SupportedPlatforms(UnrealPlatformClass.Server)]
public class StarterServerTarget : TargetRules
{
	public StarterServerTarget(TargetInfo Target) : base(Target)
	{
		Type = TargetType.Server;
		DefaultBuildSettings = BuildSettingsVersion.Latest;
		IncludeOrderVersion = EngineIncludeOrderVersion.Latest;
		ExtraModuleNames.Add("StarterRuntime");
		//BuildEnvironment = TargetBuildEnvironment.Unique;

		//bCompilePython = false;
	}
}
