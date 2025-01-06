// Copyright (c) 2025 Daft Software.

#include "Modules/ModuleManager.h"
#include "Materials/Material.h"
#include "Misc/Paths.h"
#include "Misc/Parse.h"
#include "Logging/StructuredLog.h"

namespace Daft
{
    FAutoConsoleCommandWithArgsAndOutputDevice MakeMaterialSpecialCmd(
        TEXT("Daft.MakeMaterialSpecial"),
        TEXT("Write the special engine material flag into the material at the given path."),
        FConsoleCommandWithArgsAndOutputDeviceDelegate::CreateStatic([](const TArray<FString>& Params, FOutputDevice& Out)
        {
            FString Path;
            if (Params.Num() == 1)
            {
                Path = Params[0];
            }
            else
            {
                Out.Logf(TEXT("Usage: Daft.MakeMaterialSpecial <path>"));
                return;
            }

            UMaterial* Material = Cast<UMaterial>(StaticLoadObject(UMaterial::StaticClass(), nullptr, *Path));
            if (Material)
            {
                Material->bUsedAsSpecialEngineMaterial = true;
                Material->PostEditChange();
                Material->MarkPackageDirty();

                UE_LOGFMT(LogTemp, Log, "Material at path {0} is now a special engine material.", *Path);
            }
            else
            {
                UE_LOGFMT(LogTemp, Error, "Material not found at path: {0}", *Path);
            }
        }
    ));
}

IMPLEMENT_PRIMARY_GAME_MODULE( FDefaultGameModuleImpl, StarterEditor, "StarterEditor" );
