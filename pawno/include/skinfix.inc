/*
This include prevents skin setting bug which occurs when you set's player skin while in vehicle.
It also fixes OnPlayerSpawn where if you set player skin. Then on next spawn you use the previous skin.
*/

#include <YSI\y_hooks>

enum E_PLAYER_DATA
{
	Float:pPos[3],
	pVehicle,
	pSeat,
	pSkin
}
new gSkinData[MAX_PLAYERS][E_PLAYER_DATA];

Hook:skinfix_OnPlayerConnect(playerid)
{
	gSkinData[playerid][pSkin] = 0;
	return 1;
}

Hook:skinfix_OnPlayerRequestClass(playerid, classid)
{
	gSkinData[playerid][pSkin] = GetPlayerSkin(playerid);
	return 1;
}

Hook:skinfix_OnPlayerSpawn(playerid)
{
	SetPlayerSkin(playerid, gSkinData[playerid][pSkin]);
	return 1;
}

stock skinfix_SetPlayerSkin(playerid, skinid)
{
	GetPlayerPos(playerid, gSkinData[playerid][pPos][0], gSkinData[playerid][pPos][1], gSkinData[playerid][pPos][2]);
	gSkinData[playerid][pSkin] = skinid;
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
	{
		gSkinData[playerid][pSeat] = GetPlayerVehicleSeat(playerid);
		gSkinData[playerid][pVehicle] = GetPlayerVehicleID(playerid);
		SetPlayerPos(playerid, gSkinData[playerid][pPos][0], gSkinData[playerid][pPos][1], gSkinData[playerid][pPos][2]+2);
		SetPlayerSkin(playerid, skinid);
		PutPlayerInVehicle(playerid, gSkinData[playerid][pVehicle], gSkinData[playerid][pSeat]);
	}
	else
		SetPlayerSkin(playerid, skinid);
	return 1;
}

#if defined _ALS_SetPlayerSkin
	#undef SetPlayerSkin
#else
	#define _ALS_SetPlayerSkin
#endif
#define SetPlayerSkin skinfix_SetPlayerSkin