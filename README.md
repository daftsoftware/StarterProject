
# DaftSoftware Minimal Project

## Important
By using this repository you agree to the Epic EULA.
https://www.unrealengine.com/en-US/eula/unreal

This project may not be used outside of Unreal projects, the code source is MIT, and any file with the daftsoftware copyright you are free to use it as such but any content belonging to Epic applies the EULA and if I haven't marked the copyright as such, you can assume the copyright belongs to Epic.

## About

This uproject uses a few tricks to drastically reduce the size of packaged builds, and essentially disables all plugins in the entire engine (even the ones that aren't able to be turned off by default). Disabling all plugins essentially cuts the legs off the engine and you will have considerable loss in functionality with the benefit of a huge increase of speed in the editor load times for assets and startup, however it can be treated more like an opt-in model where the things you need can be turned back on.

As is suggested by Epic there are things in this project that are an **advanced workflow** and I do not recommend using this project unless you absolutely know what you are doing. It's not reasonable to assume that Epic has tested internally having some of these core engine plugins disabled and therefore you may get crashes upon using certain features with some plugins disabled, therefore in these scenarios debugging and some educated guessing is usually required to figure out which dependency from the engine you need to turn back on.

This project also defaultly kills the vast majority of the stock engine content. It is very important to identify what you use from the engine content because *this content will be missing in your builds by default and cause errors*. In this project the world grid and a few other essential default materials have been moved out of Engine content into Project content, but you will need to do this to any additional content from the engine you use and there is very important process around this, you can't just copy the content - More on this later.

## Plugin Dependencies

A few plugins from the engine, while you can turn off, it's not a good idea to do so because you basically chop the arms and legs off the engine, or otherwise cause instability. The following plugins are:

**EngineAssetDefinitions** - *Required* for describing all the core asset factories and types the engine uses, without this you will be missing literally almost every core asset type in the engine and the editor will not understand what a Level, Blueprint, Material or other primitive asset type is, opening them will be treated like a data asset and they won't function as expected.

**ContentBrowserAssetDataSource** - *Required*, Without this the content browser is lobotomized and doesn't understand what an asset is, it will just show empty results on everything, so pretty much required.

**AnimationData** - *Required temporary workaround*, to open Blueprints assets. Without this plugin enabled you will get a crash when Unreal scans the Blueprint skeleton type, as it will try to determine if said asset is an animation blueprint and crash on the spot when expected nodes are missing. Should imagine Epic will fix this one if anyone can be bothered to PR it or if they find out for themselves.

**PluginBrowser** - *Not required*, you can turn this one off if you like, but honestly it makes working with Game Features or any other plugin a nightmare since you have to manually describe your configuration in the .uproject - and it's editor only anyway. Maybe useful turning it off if your artists are really annoying and turn on plugins lol.

**TraceUtilities** - *Not required*, you can turn this one off but you will lose a lot of the nice functionality to do with Insights and a large part of the QoL that was built around the trace server in recent versions. Maybe if you never use insights this one can be turned off, but I thought it was too handy to be turned off personally.

**Niagara** - *Not required*, can be turned off for a small speed boost on the Game Thread and improved editor startup time at the cost of entirely losing FX from the engine, while it's still possible to use Cascade I absolutely don't recommend this and probably the only people that are going to want this off are people rocking custom FX systems or people with no FX in their games, which I figure probably doesn't cover most people.

**EnhancedInput** - *Not required*, can be turned off if you just prefer to use the legacy input system or a custom one, however I don't recommend using legacy input in UE5 as Epic no longer supports it.


## Project Engine Content

As described earlier, in this project we deploy a bit of a cheeky trick to move important Engine content into Project level so that it's more managable and you can IWYU. The engine itself has the concept of "Special Engine Materials", if you ever tried opening the world grid material in the Engine Content for example, then you will be familiar with the warning where Epic tells you basically don't modify these unless you know what you're doing.

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

When adding additional content from Engine Materials to Project Contnet, you cannot just directly copy the assets across and add them in the ini. This is because internally Epic has a flag which is not trivial to set by accident and it is required for any of these global materials to function correctly, when you copy engine content to project level Epic automatically removes this flag because they assume you're just using the material business as usual and wanted to use it like a normal material.

You can enable this flag on assets you add to the project with a console command:
`Daft.MakeMaterialSpecial /Game/Engine/Materials/WorldGridMaterial`

You can find the correct path you need by locating the material asset you copied, then right clicking and doing "Copy Package Path" or pressing Ctrl+Alt+C while selecting it.

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
- Siliex for showing me the cool trick to disable all plugins <3
- BarronKane for sharing his own research into small uprojects
- Vori for moral support and for bringing significant attention to this project
