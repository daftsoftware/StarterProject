
# DaftSoftware Starter Project

## Legal
By using this repository you agree to the Epic EULA.
https://www.unrealengine.com/en-US/eula/unreal

This project may not be used outside of Unreal projects, any content belonging to Epic Games is protected by Unreal Engine's EULA.

## About

**Currently supported versions include:**
- Unreal 5.5
- Unreal 5.6

This uproject uses a few tricks to drastically reduce the size of packaged builds, primarily by disabling all plugins in the engine. This makes the engine work in more of an opt-in IYWU model, meaning if you are missing a plugin or engine feature, you must explicitly turn on both the plugin and it's dependencies. `"DisableEnginePluginsByDefault": true` is the setting responsible for enabling opt-in and you can find this in the uproject file.

**Disclaimer** - This project targets the **Win64** platform, other platforms such as mac, android, consoles have not been tested and may crash due to missing plugin dependencies or incompatible settings, while it's easily possible to add support for other platforms, that is not within the scope of this template as it's often project specific. The goal is primarily to offer a very compact starting point with no junk, no bullshit, a small footprint and runs fast.

## Mobile Rendering

You can access faster rendering for Windows using DirectX Mobile on the 5.6-mobile branch which consists of very aggressive optimizations and stripped rendering features yielding high performance.
[Look here for a full list of which features are available / unavailable for mobile rendering](https://dev.epicgames.com/documentation/en-us/unreal-engine/rendering-features-for-mobile-games-in-unreal-engine).

## The Benchmarks

### Package Size

Blank UProject 5.6 Size - **473MB**

Daft Starter Project 5.6 Size - **201MB** (2.4x Smaller)

Daft Starter Project 5.6-Mobile Size - **154MB** (3x Smaller)

### Editor Startup Times

Since 5.6, project load times relating to plugins have been improved, however the engine slowed down in other places, specifically around shader and DDC initialization - the gains from this project on editor startup times are mostly nullified by the speedup of the base engine which nets around a 1 second decrease in startup time from 5.5. However overall the shader & DDC initialization time has drastically increased, meaning that Daft Starter Project no longer sees significant benefit in this avenue and sees slower times against 5.5.

Blank UProject 5.6 - **9.6 Seconds**

Daft Starter Project 5.6 - **8.9 Seconds**

Daft Starter Project 5.6-Mobile - **8.9 Seconds**

## Rendering Features

**Important Note**:

While Volumetric Clouds themselves have not been disabled, the default materials have as by default they consume nearly 20MB! When using Volumetric Clouds, set them to use a custom material, copy the default cloud materials to project level, or just remove the following line from DefaultGame.ini if you want to use the base engine sky materials at the cost of 20MB package size:
```ini
+DirectoriesToNeverCook=(Path="/Engine/EngineSky/VolumetricClouds")
```

For the list of disabled features and content, please reference DefaultEngine.ini and DefaultGame.ini

## Thanks
- Siliex for showing me the cool trick to disable all engine / editor plugins
- Zeblote / Brickadia team for inspiring me to do this in the first place
- 0lento for sharing his expertise in Unreal's mobile rendering
- BarronKane for sharing his own research into small uprojects
- Vori for moral support and for bringing significant attention to this project
- Alex Nye for finding solution to startup crash on MacOS
