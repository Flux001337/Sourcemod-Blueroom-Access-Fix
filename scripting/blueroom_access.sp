///////////////////////////////////////////////////////////////////////////////
// Blueroom Access Plugin for BMS // www.keks-brigarde.net
///////////////////////////////////////////////////////////////////////////////
#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>

#define PLUGIN_VERSION "1.1.0"
#define DOOR_TOUCH_OPENS (1 << 10)

ConVar g_BlueRoomEnabled;
bool g_MapReady;

public Plugin myinfo =
{
    name = "Crossfire Blueroom Fix",
    author = "HSFighter",
    description = "Crossfire Classic Blueroom Access Fix",
    version = PLUGIN_VERSION,
    url = "http://keks-brigarde.net"
};

public void OnPluginStart()
{
    CreateConVar("sm_bms_blueroomfix_version", PLUGIN_VERSION, "BMS Blueroom Fix Version", FCVAR_SPONLY | FCVAR_REPLICATED | FCVAR_NOTIFY);
    g_BlueRoomEnabled = CreateConVar("sm_bms_blueroom_enable", "1", "Enable/Disable opening the Blue Room door by touch", 0, true, 0.0, true, 1.0);
    g_BlueRoomEnabled.AddChangeHook(OnBlueRoomChanged);
    AutoExecConfig(true, "plugin.bms_crossfire_blueroom_fix");
}

public void OnMapStart()
{
    g_MapReady = true;
    ApplyBlueRoomAccess();
}

public void OnConfigsExecuted()
{
    // Apply even when the configured value equals the existing ConVar value.
    // In that case no change callback is fired.
    ApplyBlueRoomAccess();
}

public void OnMapEnd()
{
    g_MapReady = false;
}

public void OnBlueRoomChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
    ApplyBlueRoomAccess();
}

void ApplyBlueRoomAccess()
{
    if (!g_MapReady) return;
    bool enabled = g_BlueRoomEnabled.BoolValue;
    int entity = -1;
    char name[128];
    while ((entity = FindEntityByClassname(entity, "func_door")) != -1)
    {
        GetEntPropString(entity, Prop_Data, "m_iName", name, sizeof(name));
        if (!StrEqual(name, "secret_door")) continue;
        if (!HasEntProp(entity, Prop_Data, "m_spawnflags"))
        {
            LogError("Blue Room door %d has no m_spawnflags property.", entity);
            continue;
        }
        int flags = GetEntProp(entity, Prop_Data, "m_spawnflags");
        int updated = enabled ? (flags | DOOR_TOUCH_OPENS) : (flags & ~DOOR_TOUCH_OPENS);
        // Preserve all unrelated map flags. No Close or Lock inputs are sent.
        if (updated != flags) SetEntProp(entity, Prop_Data, "m_spawnflags", updated);
    }
}
