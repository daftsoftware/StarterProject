// Copyright (c) 2025 Daft Software.

using UnrealBuildTool;
using System.Collections.Generic;

public class StarterGameTarget : TargetRules
{
	public StarterGameTarget(TargetInfo Target) : base(Target)
	{
		Type = TargetType.Game;
		DefaultBuildSettings = BuildSettingsVersion.Latest;
		IncludeOrderVersion = EngineIncludeOrderVersion.Latest;
		ExtraModuleNames.Add("StarterRuntime");

		//if (Target.Type != TargetType.Editor)
		//{
			//Target.DisablePlugins.Add("OpenImageDenoise");
			//Target.DisablePlugins.Add("MeshModelingTools");
		//}
	}
}
