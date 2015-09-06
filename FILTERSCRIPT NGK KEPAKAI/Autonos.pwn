// Simple automatic nitro filterscript by Adas...
#include <a_samp>

new bool:AutoNOS[MAX_PLAYERS];

public OnFilterScriptInit()
{
print(" ");
print("[ -|- ] Automatic Nitro System by Adas [ -|- ]");
print(" ");
return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
if(!strcmp(cmdtext, "/autonos", true))
{
if(AutoNOS[playerid])
{
SendClientMessage(playerid, 0x924161FF, "[ ! ] Automatic nitro deactivated.");
AutoNOS[playerid] = false;
}
else
{
SendClientMessage(playerid, 0x924161FF, "[ ! ] Automatic nitro activated!");
AutoNOS[playerid] = true;
}
return 1;
}
return 0;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && AutoNOS[playerid] && (newkeys & KEY_ACTION || newkeys & KEY_FIRE)) AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
return 1;
}
