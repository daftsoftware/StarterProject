
# DaftSoftware Minimal Project

## Important
By using this repository you agree to the Epic EULA.
https://www.unrealengine.com/en-US/eula/unreal

This project may not be used outside of Unreal projects, the code source is MIT, and any file with the daftsoftware copyright you are free to use it as such but any content belonging to Epic applies the EULA and if I haven't marked the copyright as such, you can assume the copyright belongs to Epic.

## About

**Currently supported version is Unreal 5.5**, It's possible to backport to 5.4 or earlier but you will need to replace the Custom Engine Content yourself which is described later in this readme.

This uproject uses a few tricks to drastically reduce the size of packaged builds, and essentially disables all plugins in the entire engine (even the ones that aren't able to be turned off by default). Disabling all plugins essentially cuts the legs off the engine and you will have considerable loss in functionality with the benefit of a huge increase of speed in the editor load times for assets and startup, however it can be treated more like an opt-in model where the things you need can be turned back on.

As is suggested by Epic there are things in this project that are an **advanced workflow** and I do not recommend using this project unless you absolutely know what you are doing. It's not reasonable to assume that Epic has tested internally having some of these core engine plugins disabled and therefore you may get crashes upon using certain features with some plugins disabled, therefore in these scenarios debugging and some educated guessing is usually required to figure out which dependency from the engine you need to turn back on.

This project also defaultly kills the vast majority of the stock engine content. It is very important to identify what you use from the engine content because *this content will be missing in your builds by default and cause errors*. In this project the world grid and a few other essential default materials have been moved out of Engine content into Project content, but you will need to do this to any additional content from the engine you use and there is very important process around this, you can't just copy the content - More on this later.

**Disclaimer** - This project is also primarily targeting **Win64** platform, other platforms (eg MacOS or Android) have not been tested and probably crash due to missing plugin dependencies or required content, if you enable new platforms you will likely need to debug missing dependencies or unsupported settings.

## Plugin Dependencies

A few plugins from the engine, while you can turn off, it's not a good idea to do so because you basically chop the arms and legs off the engine, or otherwise cause instability. The following plugins are:

**EngineAssetDefinitions** - *Required* for describing all the core asset factories and types the engine uses, without this you will be missing literally almost every core asset type in the engine and the editor will not understand what a Level, Blueprint, Material or other primitive asset type is, opening them will be treated like a data asset and they won't function as expected.

**ContentBrowserAssetDataSource** - *Required*, Without this the content browser is lobotomized and doesn't understand what an asset is, it will just show empty results on everything, so pretty much required.

**AnimationData** - *Required temporary workaround*, to open Blueprints assets. Without this plugin enabled you will get a crash when Unreal scans the Blueprint skeleton type, as it will try to determine if said asset is an animation blueprint and crash on the spot when expected nodes are missing. Should imagine Epic will fix this one if anyone can be bothered to PR it or if they find out for themselves.

**PluginBrowser** - *Not required*, you can turn this one off if you like, but honestly it makes working with Game Features or any other plugin a nightmare since you have to manually describe your configuration in the .uproject - and it's editor only anyway. Maybe useful turning it off if your artists are really annoying and turn on plugins lol.

**TraceUtilities** - *Not required*, you can turn this one off but you will lose a lot of the nice functionality to do with Insights and a large part of the QoL that was built around the trace server in recent versions. Maybe if you never use insights this one can be turned off, but I thought it was too handy to be turned off personally.

**Niagara** - *Not required*, can be turned off for a small speed boost on the Game Thread and improved editor startup time at the cost of entirely losing FX from the engine, while it's still possible to use Cascade I absolutely don't recommend this and probably the only people that are going to want this off are people rocking custom FX systems or people with no FX in their games, which I figure probably doesn't cover most people.

**EnhancedInput** - *Not required*, can be turned off if you just prefer to use the legacy input system or a custom one, however I don't recommend using legacy input in UE5 as Epic no longer supports it.

*How do we disable all the plugins if the uproject is almost empty?*

`"DisableEnginePluginsByDefault": true`

This setting essentially instructs the engine to operate on an IYWU basis for plugins, disabling all engine and editor plugins, even the ones hidden in the plugin browser. These plugins can be found under [YourEngineInstall/Engine/Plugins](https://github.com/EpicGames/UnrealEngine/tree/release/Engine/Plugins), a large amount of which are under the [YourEngineInstall/Engine/Plugins/Editor](https://github.com/EpicGames/UnrealEngine/tree/release/Engine/Plugins/Editor) directory. It is advisable to look at these plugins top to bottom to understand exactly what you are disabling by using the project, as most people are going to immediately need to turn some things back on, which you can do by finding the name of their .uplugin and adding them manually in your .uproject file, e.g:
```json
{
  "Name": "EngineAssetDefinitions",
  "Enabled": true
},
```

## Package Size

**Disclaimer** - It is possible to get the size of a project much smaller than this project offers out of the box. However the goal of this project is to min-max rendering, cpu and IO performance at runtime and improve editor startup times where possible. While the package can be made much smaller using compression, shared shaders, DX11 / OpenGL, or otherwise eliminating the global shader cache (which would kill around 60MB out the box) doing so would generally result in performance reduction or an unsatisfactory or reduced experience for players, however may be desirable for some projects like game jams. Therefore I won't be doing this mods myself but they are easy to do. By default this project also does not use CryptoKeys, PAK or IOStore - 211.8MB is the uncompressed size of the project, and with the equivalent size of a blank project package without PAK or IOStore the size would be 621.9MB.

It's worth noting that most of the mods that have been done in this uproject are highly opinionated, suited primarily for the needs of Daft Software, and not suitable for many projects, especially those in AAA where content pipelines aren't controlled, anarchy reigns, and artists may place engine content into levels, but hopefully should still provide a good jumping off point for your own projects or game jams.

As of Unreal 5.5.2:
The current size of a brand new blank project being packaged is **457.3MB**
The current size of the DaftSoftware Minimal Project is **211.8MB**

Uncompressed Daft Minimal Project is **2.16x smaller than compressed blank template and 2.94x smaller than uncompressed blank template.**

Blank Template (No PAK, No IOStore) - 621.9 MB
![image](https://github.com/user-attachments/assets/b1f8c3fb-ada3-4c5e-8e7e-4b92baaca903)

Blank Template (PAK + IOStore) - 457.3 MB
![image](https://github.com/user-attachments/assets/d503eaac-4911-4485-82c5-616cc94b2d9e)

Daft Minimal Project **Default** (No PAK, No IOStore) - 211.8 MB
![image](https://github.com/user-attachments/assets/aba17a5a-6eb4-42d1-a39a-661286c8bb34)

Daft Minimal Project (PAK + IOStore) - 181.6MB
![image](https://github.com/user-attachments/assets/cda65650-5a70-4834-a821-de0789a0348e)

Performance / savings of using PAK and IOStore may vary per project, by default it is disabled, however it's very easily to enable in Project Settings > Packaging:

![image](https://github.com/user-attachments/assets/fde482b4-1c4e-4dc6-be6b-0c5bc2be8b4c)

If you need to change how the engine / editor content is excluded from the cook, it is done in DefaultGame.ini under packaging settings, eg:
```ini
[/Script/UnrealEd.ProjectPackagingSettings]
+DirectoriesToNeverCook=(Path="/Engine/EngineMaterials")
```

## Editor Speed

If we measure in Development Editor config from the start of LaunchEngineLoop to when the Engine Tick Loop starts, which doesn't necessarily represent real world speed of pressing compile to seeing the editor open, but does provide a technical basis to measure the editor speed. We can see that Daft Minimal Project offers a significant speedup to the Editor startup times.

Epic's default "Blank" C++ Template comes in at around **10.9 Seconds** from Init to First Tick.
![image](https://github.com/user-attachments/assets/11a5346e-d66f-42fb-8231-776dd5a72acc)

Daft Minimal Project comes in around **6.9 Seconds** from Init to First Tick.
![image](https://github.com/user-attachments/assets/a75394bd-a131-4a76-b7b2-d2c29dd7ac6a)

## Project Engine Content

As described earlier, in this project we deploy a bit of a cheeky trick to move important Engine content into Project level so that it's more managable and you can IWYU. The engine itself has the concept of "Special Engine Materials", if you ever tried opening the world grid material in the Engine Content for example, then you will be familiar with the warning where Epic tells you basically don't modify these unless you know what you're doing.

![image](https://github.com/user-attachments/assets/2231744a-becc-4f69-92d6-549c63ca83fa)


This is essentially because these are materials loaded into globals which are used by all systems in the entire engine, including Nanite, Niagara, Static Meshes, basically everything that might at any time be able to display a null material. However because of this they are particularly tricky to edit, since you are modifying stuff that is actively always in VRAM or being utilized, so editing these directly usually causes a crash.

You can find a total list of all of these engine contents in BaseEngine.ini and in our case the ones that have been overridden inside DefaultEngine.ini like so:
```ini
[/Script/Engine.Engine]
DefaultMaterialName=/Game/Engine/Materials/WorldGridMaterial.WorldGridMaterial
```

One very nice benefit this affords us is that we can actually directly change the world grid material to look however we like, and even reduce it's shader instructions if we find it too expensive or make it a bright color like purple to identify missing materials or content. When editing these materials, you should comment them out in the ini to fallback to the engine material, make your edits, then uncomment. Just remember to uncomment because the engine materials are killed in package builds
```ini
[/Script/Engine.Engine]
;DefaultMaterialName=/Game/Engine/Materials/WorldGridMaterial.WorldGridMaterial
```

When adding additional content from Engine Materials to Project Content, you cannot just directly copy the assets across and add them in the ini. This is because internally Epic has a flag which is not trivial to set by accident and it is required for any of these global materials to function correctly, when you copy engine content to project level Epic automatically removes this flag because they assume you're just using the material business as usual and wanted to use it like a normal material.

You can enable this flag on assets you add to the project with a console command:
`Daft.MakeMaterialSpecial /Game/Engine/Materials/WorldGridMaterial`

You can find the correct path you need by locating the material asset you copied, then right clicking and doing "Copy Package Path" or pressing Ctrl+Alt+C while selecting it.
![image](https://github.com/user-attachments/assets/4c200498-1102-41ee-8dd7-0386e4e7d89e)

Then you must locate the ini to override from BaseEngine.ini and add it into your DefaultEngine.ini with the project level path rather than the engine one it defaults to.

## Rendering Features

Defaultly disabled rendering features which were disabled for speed or my opinions but you may want to enable include:
- Nanite
- Lumen
- RT Reflections
- VSM
- Path Tracing
- Local Fog Volumes
- Heterogenous Volumes
- Auto Exposure
- Motion Blur

Defaulty enabled rendering features which were enabled for speed or my opinions but you may want to disable include:
- Virtual Texturing
- VT Anisotropic Filtering
- VT Post Processing
- Screen Space Reflections
- FXAA
- CSM
- Custom Depth + Stencil Buffer

## Thanks
- Siliex for showing me the cool trick to disable all engine / editor plugins
- Zeblote / Brickadia team for inspiring me to do this in the first place
- BarronKane for sharing his own research into small uprojects
- Vori for moral support and for bringing significant attention to this project
