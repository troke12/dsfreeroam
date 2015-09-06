#include <a_samp>
#include <ladmin>
#include <zcmd>
#define VIPMENU 	11
// Colors //
#define COLOR_YELLOW 0xF6F600AA // Yellow
#define COLOR_RED 0xF60000AA // Red
new god[MAX_PLAYERS];

forward InfiniteAmmo(playerid); // Infinite Ammo

enum Data
{
    InfiniteAmmoData
}

new PlayerData[MAX_PLAYERS][Data];

new InfiniteAmmoTimer[MAX_PLAYERS];
new infammo[MAX_PLAYERS];

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" VIP System for LuxAdmin Loaded");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	print("\n--------------------------------------");
	print(" VIP System for LuxAdmin Un-Loaded");
	print("--------------------------------------\n");
	return 1;
}

public OnGameModeInit()
{
	return 1;
}

public OnGameModeExit()
{
	return 1;
}
public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}
public OnPlayerConnect(playerid)
{
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public InfiniteAmmo(playerid) // Infinite Ammo
{
    new weapon = GetPlayerWeapon(playerid);
    GivePlayerWeapon(playerid, weapon, 999999999);
	InfiniteAmmoTimer[playerid] = SetTimerEx("InfiniteAmmo", 100, 0, "i", playerid);
	return 1;
}

CMD:vmenu(playerid, params[])
{
	if(IsPlayerVipMember(playerid))
	{
	ShowPlayerDialog(playerid, VIPMENU, DIALOG_STYLE_LIST, "VIP Menu", "Heal\nArmour\nJetpack\nGod\nWeapons\nVehicle\nSkin\nRepair\nGoto\nInfinity Ammo\nSet Time\nSet Weather", "Use", "Close");
	}
	else SendClientMessage(playerid, 0xFF0A00FF, "ERROR: You are not VIP members!");
	return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == VIPMENU)
	{
	}
	switch(listitem)//wich listitem is chosen
	{
		case 0://heal
		{
			SetPlayerHealth(playerid, 100.0);
			SendClientMessage(playerid, 0x0FFF00FF, "You Healed");
			new str[256], playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playername, sizeof(playername));
			format(str, sizeof(str), "[VIP]%s Has use Heal", playername);
			SendClientMessageToAll(0xFFD700AA, str);
		}
		case 1://armour
		{
			SetPlayerArmour(playerid, 100.0);
			SendClientMessage(playerid, 0x0FFF00FF, "You have armour");
			new str[256], playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playername, sizeof(playername));
			format(str, sizeof(str), "[VIP]%s Has use Armour", playername);
			SendClientMessageToAll(0xFFD700AA, str);
		}
		case 2://jetpack
		{
			SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USEJETPACK);
			SendClientMessage(playerid, 0x0FFF00FF, "You are using jetpack now");
			new str[256], playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playername, sizeof(playername));
			format(str, sizeof(str), "[VIP]%s Has use Jetpack", playername);
			SendClientMessageToAll(0xFFD700AA, str);
		}
		case 3://god
		{
			if(god[playerid] == 0)
			{
				SendClientMessage(playerid, 0xFFFFFFFF, "GOD: {00FF00}Activated.");
				god[playerid] = 1;
				SetPlayerHealth(playerid,100000);
			}
			else
			{
				SendClientMessage(playerid, 0xFFFFFFFF, "GOD: {FF0000}Turned Off.");
				god[playerid] = 0;
				SetPlayerHealth(playerid, 100);
			}
		}
		case 4://weapons
		{
			ShowPlayerDialog(playerid, 12, DIALOG_STYLE_LIST, "VIP Weapons", "Chainsaw \nKnife \nKatana \nDeagle \nTec9 \nMicro SMG \nSawnOff-SG \nCombat-SG \nM4 \nSniper \nGrenade \nNightvision \nThermaGoogles \nCamera \nHeatSeek \nFlame Tower \nRocket\nNightStick \nGolfClub \nBat \nColt \nSilenced \nShotgun \nAK47 \nRifel \nMP-5 \nFire Extinguisher \nParachute", "Use", "Close");
		}
		case 5://vehicle
		{
			//ShowPlayerDialog(playerid, CARMENU, DIALOG_STYLE_LIST, "Vehicle Selection Menu","Bikes\nCars 1 [A-E]\nCars 2 [F-P]\nCars 3 [P-S]\nCars 4 [S-Z]\nHelicopters\nPlanes\nBoats\nTrains\nTrailers\nRC Vehicles + Vortex", "Select", "Cancel");
		}
		case 6://skin
		{
			ShowPlayerDialog(playerid, 183, DIALOG_STYLE_INPUT, "Change Skin", "Enter a skin ID below to get started", "Confirm", "Cancel");
		}
		case 7://Repair
		{
		if (IsPlayerInAnyVehicle(playerid))
		{
			new VehicleID = GetPlayerVehicleID(playerid);
			RepairVehicle(VehicleID);
			GameTextForPlayer(playerid,"~w~~n~~n~~n~~n~~n~~n~Vehicle ~g~Repaired!",3000,3);
			return SetVehicleHealth(VehicleID, 1000);
			}
		}
		case 8://goto
		{
			ShowPlayerDialog(playerid, 188, DIALOG_STYLE_INPUT, "GOTO", "Enter Player id to Teleport", "Goto", "Cancel");
		}
		case 9://invinity ammo
		{
			if(infammo[playerid] == 0)
			{
				SendClientMessage(playerid, 0xFFFFFFFF, "Infinity Ammo: {00FF00}Activated.");
				infammo[playerid] = 1;
			}
			if(PlayerData[playerid][InfiniteAmmoData] == 0)
			{
				InfiniteAmmoTimer[playerid] = SetTimerEx("InfiniteAmmo", 100, 0, "i", playerid);
				PlayerData[playerid][InfiniteAmmoData] = 1;
				return 1;
			}
				else SendClientMessage(playerid, COLOR_RED, "You already have infinite ammo turned on.");
				return 1;
			}else {
				SendClientMessage(playerid, 0xFFFFFFFF, "Infinity Ammo: {FF0000}Turned Off.");
				infammo[playerid] = 0;
				if(PlayerData[playerid][InfiniteAmmoData] == 1)
				{
				KillTimer(InfiniteAmmoTimer[playerid]);
				PlayerData[playerid][InfiniteAmmoData] = 0;
				ResetPlayerWeapons(playerid);
				return 1;
				}
				else SendClientMessage(playerid, COLOR_RED, "You already have infinite ammo turned on.");
				return 1;
			}
		}
		case 10:
		{
			ShowPlayerDialog(playerid, 189, DIALOG_STYLE_INPUT, "Set Time", "Choose your Time", "Ok", "Close");
		}
		case 11:
		{
			ShowPlayerDialog(playerid, 190, DIALOG_STYLE_INPUT, "Set Weather", "Choose your Weather ID", "Ok", "Close");
		}
	}
	if(dialogid == 188) // goto
	{
	    SetPlayerPos(playerid);
 	}
	return 1;
}
