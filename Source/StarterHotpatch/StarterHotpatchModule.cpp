// Copyright (c) 2025 Daft Software.

#include "Modules/ModuleManager.h"
#include "Editor.h"
#include "Editor/EditorEngine.h"

/**
 * @HACK!!! BIG STINKY HACK. As of UE5.5 there's no project level extensions for platforms
 * read : https://forums.unrealengine.com/t/attention-platform-changes-ahead/126005
 *
 * What this means is that because we use ES31 feature level on this project, but we don't
 * use a custom engine (for now), we hotpatch the engine install to enable distance field
 * support for DirectX 11 Mobile support.
 *
 * This is done by essentially directly editing the engine ini which defines the platform
 * properties for windows, there is no consequence for doing so as there is actually an
 * editor preview for mobile which has SDF enabled, however for whatever reason they made
 * no actual shippable version of this when setting prefer RHI to ES31.
 */
class FStarterHotpatchModule : public IModuleInterface
{
    virtual void StartupModule() override
    {
        // Hotpatch Engine/Config/Windows/DataDrivenPlatformInfo.ini, we find section
        // [ShaderPlatform PCD3D_ES3_1] and then look for bSupportsDistanceFields = false
        // and patch the value onto true, otherwise our lighting will be black due to no mobile DF support.
        FString IniPath = FPaths::Combine(FPaths::EngineDir(), TEXT("Config/Windows/DataDrivenPlatformInfo.ini"));
        FString FileContent;

        if (FPaths::FileExists(IniPath) && FFileHelper::LoadFileToString(FileContent, *IniPath))
        {
            const FString SectionHeader = TEXT("[ShaderPlatform PCD3D_ES3_1]");
            const FString Key = TEXT("bSupportsDistanceFields");
            const FString OldLine = Key + TEXT(" = false");
            const FString NewLine = Key + TEXT(" = true");

            int32 SectionStart = FileContent.Find(SectionHeader, ESearchCase::IgnoreCase);
            if (SectionStart != INDEX_NONE)
            {
                int32 KeyStart = FileContent.Find(OldLine, ESearchCase::IgnoreCase, ESearchDir::FromStart, SectionStart);
                if (KeyStart != INDEX_NONE)
                {
                    FileContent = FileContent.Replace(*OldLine, *NewLine, ESearchCase::IgnoreCase);
                    FFileHelper::SaveStringToFile(FileContent, *IniPath, FFileHelper::EEncodingOptions::ForceUTF8WithoutBOM);
                }
            }
        }

        // Hook to map changes to toggle back to the mobile preview.
        FEditorDelegates::MapChange.AddRaw(this, &FStarterHotpatchModule::OnMapChange);
    }

    virtual void ShutdownModule() override
    {
        FEditorDelegates::MapChange.RemoveAll(this);
    }

    void OnMapChange(uint32)
    {
        check(GEditor);

        // Force the editor into DirectX Mobile Preview on ES31
        // Stole these settings from Engine/Config/Windows/DataDrivenPlatformInfo.ini
        const FPreviewPlatformInfo PreviewPlatform(
            ERHIFeatureLevel::ES3_1,
            EShaderPlatform::SP_PCD3D_ES3_1,
            FName("PC"),
            FName("PCD3D_ES31"),
            FName("Windows_Preview_ES31"),
            true,
            FName("PCD3D_ES3_1_Preview")
            );
        
        GEditor->SetPreviewPlatform(PreviewPlatform, false);
    }
};

IMPLEMENT_MODULE(FStarterHotpatchModule, StarterHotpatch);
