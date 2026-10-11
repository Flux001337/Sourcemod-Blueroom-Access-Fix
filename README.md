# [BMS] Crossfire Classic Blue Room Access Fix

This plugin fixes the inaccessible Blue Room on the Black Mesa map
[dm_crossfire_classic_beta](https://steamcommunity.com/sharedfiles/filedetails/?id=2902662539).

Current version: **1.1.0**.

## Description

The fix allows the Blue Room's secret door to open when a player touches it,
making the room accessible without modifying the map file.

It targets `func_door` entities named `secret_door`. Only the **Touch Opens**
spawn flag is changed; all other door spawn flags are preserved.

## Features

- Enable or disable opening the Blue Room door by touch.
- Apply the setting at map start and after configs have loaded.
- Apply ConVar changes immediately once the map is ready.
- No map modifications or additional custom plugins required.

## Requirements

- Black Mesa dedicated server.
- SourceMod with SDK Tools.
- The linked map, or another compatible map containing a `func_door` named `secret_door`.

## Installation

1. Copy `plugins/blueroom_access.smx` to `addons/sourcemod/plugins/`.
2. Restart the server or change the map to load the plugin and apply the fix.
3. Adjust the automatically generated configuration:
   `cfg/sourcemod/plugin.bms_crossfire_blueroom_fix.cfg`.

If you load or reload the plugin during an active map, change the map afterward.
The current implementation applies the fix after its next `OnMapStart` callback.

## ConVars

```text
// 1 = Allow the Blue Room door to open by touch.
// 0 = Disable opening by touch.
// Default: 1
sm_bms_blueroom_enable "1"
```

`sm_bms_blueroomfix_version` displays the plugin version.

Disabling the setting does not close or lock the door. Other map inputs can still
operate it.

## Compatibility

The plugin identifies the door by classname and targetname. It is not restricted
to specific map filenames. Every matching door is affected; maps without a
matching door are left unchanged.

## Compilation

From this directory, using the SourcePawn compiler and SourceMod includes:

```bash
/path/to/spcomp64 scripting/blueroom_access.sp -i/path/to/sourcemod/scripting/include -oplugins/blueroom_access.smx
```

## Project structure

```text
README.md
CHANGELOG.md
.gitignore
scripting/
    blueroom_access.sp
plugins/
    blueroom_access.smx
```

Compiled binaries and release archives are excluded from Git. See [CHANGELOG.md](CHANGELOG.md) for the documented version history.
