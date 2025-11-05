// Copyright (c) 2025 Daft Software.

using UnrealBuildTool;
using System.Collections.Generic;

public class StarterEditorTarget : TargetRules
{
	public StarterEditorTarget( TargetInfo Target) : base(Target)
	{
		Type = TargetType.Editor;
		DefaultBuildSettings = BuildSettingsVersion.Latest;
		IncludeOrderVersion = EngineIncludeOrderVersion.Latest;

		ExtraModuleNames.AddRange(new string[]
		{
			"StarterRuntime",
			"StarterEditor"
		});
	}
}
