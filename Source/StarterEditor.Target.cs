// Copyright (c) 2025 Daft Software.

using UnrealBuildTool;
using System.Collections.Generic;

public class StarterEditorTarget : TargetRules
{
	public StarterEditorTarget( TargetInfo Target) : base(Target)
	{
		Type = TargetType.Editor;
		DefaultBuildSettings = BuildSettingsVersion.V5;
		IncludeOrderVersion = EngineIncludeOrderVersion.Unreal5_5;
		//BuildEnvironment = TargetBuildEnvironment.Unique;

		//bCompilePython = false;

		ExtraModuleNames.AddRange(new string[]
		{
			"StarterRuntime",
			"StarterEditor"
		});
	}
}
