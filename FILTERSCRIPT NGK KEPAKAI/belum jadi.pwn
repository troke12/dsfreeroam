#include <a_samp>
#include <ladmin>
#include <zcmd>
#include <mSelection>
#define VIPMENU 	11

new god[MAX_PLAYERS];
//new infammo[MAX_PLAYERS];
/*enum PlayerData
{
	InfiniteAmmoData
}
new Info[MAX_PLAYERS][PlayerInfo];*/

new bikeslist = mS_INVALID_LISTID;
new car1 = mS_INVALID_LISTID;
new car2 = mS_INVALID_LISTID;
new car3 = mS_INVALID_LISTID;
new car4 = mS_INVALID_LISTID;
new helicopter = mS_INVALID_LISTID;
new planes = mS_INVALID_LISTID;
new boat = mS_INVALID_LISTID;
new trains = mS_INVALID_LISTID;
new trailers = mS_INVALID_LISTID;
new rcveh = mS_INVALID_LISTID;

public OnFilterScriptInit()
{
	bikeslist = LoadModelSelectionMenu("bikes.txt");
	car1 = LoadModelSelectionMenu("car1.txt");
	car2 = LoadModelSelectionMenu("car2.txt");
	car3 = LoadModelSelectionMenu("car3.txt");
	car4 = LoadModelSelectionMenu("car4.txt");
	helicopter = LoadModelSelectionMenu("helicopter.txt");
	planes = LoadModelSelectionMenu("planes.txt");
	boat = LoadModelSelectionMenu("boat.txt");
	trains = LoadModelSelectionMenu("trains.txt");
	trailers = LoadModelSelectionMenu("trailers.txt");
	rcveh = LoadModelSelectionMenu("rcveh.txt");
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
	return 1;
}
public OnPlayerConnect(playerid)
{
	return 1;
}
public OnPlayerModelSelection(playerid, response, listid, modelid)
{
	if(listid == bikeslist)
	{
	    if(response)
	    {
		    SendClientMessage(playerid, 0xFF0000FF, "Bikes Spawned");
	    	new Float:pos[3]; GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	    	CreateVehicle(modelid, pos[0] + 2.5, pos[1], pos[2] + 2.5, 0.0, random(128), random(128), -1);
	    }
	    else SendClientMessage(playerid, 0xFF0000FF, "Canceled Bikes selection");
    	return 1;
	}
	if(listid == car1)
	{
	    if(response)
	    {
		    SendClientMessage(playerid, 0xFF0000FF, "Cars Spawned");
	    	new Float:pos[3]; GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	    	CreateVehicle(modelid, pos[0] + 2.5, pos[1], pos[2] + 2.5, 0.0, random(128), random(128), -1);
	    }
	    else SendClientMessage(playerid, 0xFF0000FF, "Canceled Cars selection");
    	return 1;
	}
	if(listid == car2)
	{
	    if(response)
	    {
		    SendClientMessage(playerid, 0xFF0000FF, "Cars Spawned");
	    	new Float:pos[3]; GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	    	CreateVehicle(modelid, pos[0] + 2.5, pos[1], pos[2] + 2.5, 0.0, random(128), random(128), -1);
	    }
	    else SendClientMessage(playerid, 0xFF0000FF, "Canceled Cars selection");
    	return 1;
	}
	if(listid == car3)
	{
	    if(response)
	    {
		    SendClientMessage(playerid, 0xFF0000FF, "Cars Spawned");
	    	new Float:pos[3]; GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	    	CreateVehicle(modelid, pos[0] + 2.5, pos[1], pos[2] + 2.5, 0.0, random(128), random(128), -1);
	    }
	    else SendClientMessage(playerid, 0xFF0000FF, "Canceled Cars selection");
    	return 1;
	}
	if(listid == car4)
	{
	    if(response)
	    {
		    SendClientMessage(playerid, 0xFF0000FF, "Cars Spawned");
	    	new Float:pos[3]; GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	    	CreateVehicle(modelid, pos[0] + 2.5, pos[1], pos[2] + 2.5, 0.0, random(128), random(128), -1);
	    }
	    else SendClientMessage(playerid, 0xFF0000FF, "Canceled Cars selection");
    	return 1;
	}
	if(listid == helicopter)
	{
	    if(response)
	    {
		    SendClientMessage(playerid, 0xFF0000FF, "Helicopter Spawned");
	    	new Float:pos[3]; GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	    	CreateVehicle(modelid, pos[0] + 2.5, pos[1], pos[2] + 2.5, 0.0, random(128), random(128), -1);
	    }
	    else SendClientMessage(playerid, 0xFF0000FF, "Canceled Helicopter selection");
    	return 1;
	}
	if(listid == planes)
	{
	    if(response)
	    {
		    SendClientMessage(playerid, 0xFF0000FF, "Planes Spawned");
	    	new Float:pos[3]; GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	    	CreateVehicle(modelid, pos[0] + 2.5, pos[1], pos[2] + 2.5, 0.0, random(128), random(128), -1);
	    }
	    else SendClientMessage(playerid, 0xFF0000FF, "Canceled Planes selection");
    	return 1;
	}
    if(listid == boat)
	{
	    if(response)
	    {
		    SendClientMessage(playerid, 0xFF0000FF, "Boats Spawned");
	    	new Float:pos[3]; GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	    	CreateVehicle(modelid, pos[0] + 2.5, pos[1], pos[2] + 2.5, 0.0, random(128), random(128), -1);
	    }
	    else SendClientMessage(playerid, 0xFF0000FF, "Canceled Boats selection");
    	return 1;
	}
	if(listid == trains)
	{
	    if(response)
	    {
		    SendClientMessage(playerid, 0xFF0000FF, "Trains Spawned");
	    	new Float:pos[3]; GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	    	CreateVehicle(modelid, pos[0] + 2.5, pos[1], pos[2] + 2.5, 0.0, random(128), random(128), -1);
	    }
	    else SendClientMessage(playerid, 0xFF0000FF, "Canceled Trains selection");
    	return 1;
	}
	if(listid == trailers)
	{
	    if(response)
	    {
		    SendClientMessage(playerid, 0xFF0000FF, "Trailers Spawned");
	    	new Float:pos[3]; GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	    	CreateVehicle(modelid, pos[0] + 2.5, pos[1], pos[2] + 2.5, 0.0, random(128), random(128), -1);
	    }
	    else SendClientMessage(playerid, 0xFF0000FF, "Canceled Trailers selection");
    	return 1;
	}
	if(listid == rcveh)
	{
	    if(response)
	    {
		    SendClientMessage(playerid, 0xFF0000FF, "Cars Spawned");
	    	new Float:pos[3]; GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	    	CreateVehicle(modelid, pos[0] + 2.5, pos[1], pos[2] + 2.5, 0.0, random(128), random(128), -1);
	    }
	    else SendClientMessage(playerid, 0xFF0000FF, "Canceled Cars selection");
    	return 1;
	}
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
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
	if(dialogid == VIPMENU) // == Car options
	{
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
				if(god[playerid] == 0) {
				SendClientMessage(playerid, 0xFFFFFFFF, "GOD: {00FF00}Activated.");
				god[playerid] = 1;
				SetPlayerHealth(playerid,100000);
				} else {
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
				ShowPlayerDialog(playerid, 445, DIALOG_STYLE_LIST, "Vehicle Selection Menu","Bikes\nCars 1 [A-E]\nCars 2 [F-P]\nCars 3 [P-S]\nCars 4 [S-Z]\nHelicopters\nPlanes\nBoats\nTrains\nTrailers\nRC Vehicles + Vortex", "Select", "Cancel");
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
				GameTextForPlayer(playerid, "]]]]]Coming Soon]]]]]]", 3000, 3);
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
	}
	if(dialogid == 445) // == Car Menu
	{
		switch(listitem)//wich listitem is chosen
		{
			case 0://Bikes
			{
 				ShowModelSelectionMenu(playerid, bikeslist, "Bikes");
			}
			case 1:
			{
				ShowModelSelectionMenu(playerid, car1, "Car 1[A-E]");
			}
			case 2:
			{
			    ShowModelSelectionMenu(playerid, car2, "Car 2[F-P]");
			}
			case 3:
			{
			    ShowModelSelectionMenu(playerid, car3, "Car 3[P-S]");
			}
			case 4:
			{
			    ShowModelSelectionMenu(playerid, car4, "Car 4[S-Z]");
			}
			case 5:
			{
			    ShowModelSelectionMenu(playerid, helicopter, "Helicopters");
			}
			case 6:
			{
			    ShowModelSelectionMenu(playerid, planes, "Planes");
			}
			case 7:
			{
			    ShowModelSelectionMenu(playerid, boat, "Boats");
			}
			case 8:
			{
			    ShowModelSelectionMenu(playerid, trains, "Trains");
			}
			case 9:
			{
			    ShowModelSelectionMenu(playerid, trailers, "Trailers");
			}
			case 10:
			{
			    ShowModelSelectionMenu(playerid, rcveh, "RC Vehicles + Vortex");
			}
		}
	}
	return 1;
}
