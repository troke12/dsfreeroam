#include <a_samp>
#define COLOR_RED 0xAA3333AA
#define COLOR_YELLOW 0xFFFF00AA
new GetinBank;
new GetoutBank;

public OnFilterScriptInit()
{
print("\n**************");
print("*Sfpd Loaded*");
print("**************\n");
}
public OnGameModeInit()
{
GetinBank = CreatePickup(1318, 1, -1605.3510742188, 711.13134765625, 13.8671875, 0);
GetoutBank = CreatePickup(1318, 1, 238.728179, 138.871765, 1003.023437, 0);
return 1;
}
public OnPlayerSpawn(playerid)
{
SendClientMessage(playerid, -1, "Yang Baca Maho");
return 1;
}
public OnPlayerPickUpPickup(playerid, pickupid)
{
if(pickupid == GetinBank)
{
SetPlayerPos(playerid,238.167221,142.382202, 1003.023437);
SetPlayerInterior(playerid, 3);
SetCameraBehindPlayer(playerid);
return 1;
}
if(pickupid == GetoutBank)
{
SetPlayerPos(playerid,-1605.1893310547,715.59698486328, 12.217748641968);
SetPlayerFacingAngle(playerid,0.0);
SetCameraBehindPlayer(playerid);
return 1;
}
return 1;
}
