//VIP SYSTEM FOR GAMEMODE
#include <a_samp>
#include <ladmin>
#include <zcmd>
#include <mSelection>
#define VIPMENU 	11

new god[MAX_PLAYERS];

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

forward InfiniteAmmo(playerid); // Infinite Ammo

enum Data
{
    InfiniteAmmoData
}

new PlayerData[MAX_PLAYERS][Data];

new InfiniteAmmoTimer[MAX_PLAYERS];

public InfiniteAmmo(playerid) // Infinite Ammo
{
    new weapon = GetPlayerWeapon(playerid);
    GivePlayerWeapon(playerid, weapon, 999999999);
	InfiniteAmmoTimer[playerid] = SetTimerEx("InfiniteAmmo", 100, 0, "i", playerid);
	return 1;
}
public OnFilterScriptInit()
{
	bikeslist 	= LoadModelSelectionMenu("bikes.txt");
	car1 		= LoadModelSelectionMenu("car1.txt");
	car2 		= LoadModelSelectionMenu("car2.txt");
	car3 		= LoadModelSelectionMenu("car3.txt");
	car4 		= LoadModelSelectionMenu("car4.txt");
	helicopter 	= LoadModelSelectionMenu("helicopter.txt");
	planes 		= LoadModelSelectionMenu("planes.txt");
	boat 		= LoadModelSelectionMenu("boat.txt");
	trains 		= LoadModelSelectionMenu("trains.txt");
	trailers 	= LoadModelSelectionMenu("trailers.txt");
	rcveh 		= LoadModelSelectionMenu("rcveh.txt");
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
		ShowPlayerDialog(playerid, VIPMENU, DIALOG_STYLE_LIST, "VIP Menu", "Heal\nArmour\nJetpack\nGod\nWeapons\nVehicle\nSkin\nRepair\nInfinity Ammo\nSet Time\nSet Weather", "Use", "Close");
	}
	else SendClientMessage(playerid, 0xFF0A00FF, "ERROR: You are not VIP members!");
	return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == VIPMENU) // == VIPMENU
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
				return 1;
			}
			case 1://armour
			{
				SetPlayerArmour(playerid, 100.0);
				SendClientMessage(playerid, 0x0FFF00FF, "You have armour");
				new str[256], playername[MAX_PLAYER_NAME];
				GetPlayerName(playerid, playername, sizeof(playername));
				format(str, sizeof(str), "[VIP]%s Has use Armour", playername);
				SendClientMessageToAll(0xFFD700AA, str);
				return 1;
			}
			case 2://jetpack
			{
				SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USEJETPACK);
				SendClientMessage(playerid, 0x0FFF00FF, "You are using jetpack now");
				new str[256], playername[MAX_PLAYER_NAME];
				GetPlayerName(playerid, playername, sizeof(playername));
				format(str, sizeof(str), "[VIP]%s Has use Jetpack", playername);
				SendClientMessageToAll(0xFFD700AA, str);
				return 1;
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
				return 1;
			}
			case 4://weapons = inget kalau mau nambahin weapon tambahin aja disamping contoh M4\n << harus ada gituan ya
			{
				ShowPlayerDialog(playerid, 12, DIALOG_STYLE_LIST, "{FFFFFF}VIP Weapon", "Sawnoff\nM4\nSMG\nCamera\nMolotov\n9MM", "Buy", "Close");
				return 1;
			}
			case 5://vehicle
			{
				ShowPlayerDialog(playerid, 445, DIALOG_STYLE_LIST, "Vehicle Selection Menu","Bikes\nCars 1 [A-E]\nCars 2 [F-P]\nCars 3 [P-S]\nCars 4 [S-Z]\nHelicopters\nPlanes\nBoats\nTrains\nTrailers\nRC Vehicles + Vortex", "Select", "Cancel");
				return 1;
			}
			case 6://skin
			{
				ShowPlayerDialog(playerid, 183, DIALOG_STYLE_INPUT, "Change Skin", "Enter a skin ID below to get started", "Confirm", "Cancel");
				return 1;
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
				return 1;
			}
			case 8://invinity ammo
			{
				if(PlayerData[playerid][InfiniteAmmoData] == 0)
				{
            		InfiniteAmmoTimer[playerid] = SetTimerEx("InfiniteAmmo", 100, 0, "i", playerid);
            		SendClientMessage(playerid, 0xFFD700AA, "You have turned infinite ammo on.");
           			PlayerData[playerid][InfiniteAmmoData] = 1;
            		return 1;
        		}
				else
				{
            		KillTimer(InfiniteAmmoTimer[playerid]);
            		SendClientMessage(playerid, 0xFFD700AA, "You have turned infinite ammo off.");
            		PlayerData[playerid][InfiniteAmmoData] = 0;
           	    	return 1;
        		}
			}
			case 9:
			{
				ShowPlayerDialog(playerid, 189, DIALOG_STYLE_INPUT, "Set Time", "Choose your Time", "Ok", "Close");
				return 1;
			}
			case 10:
			{
				ShowPlayerDialog(playerid, 190, DIALOG_STYLE_INPUT, "Set Weather", "Choose your Weather ID", "Ok", "Close");
                return 1;
			}
		}
		return 1;
	}
	if(dialogid == 12) //== Weapons = ini juga tergantung urutan
	{
		if(listitem == 0)
  		{
    		GivePlayerWeapon(playerid, 26, 40);
		    SendClientMessage(playerid, 0x33AA33AA, "Congratulations!");
			return 1;
		}
		if(listitem == 1)
		{
		 	GivePlayerWeapon(playerid, 31, 100);
		 	SendClientMessage(playerid, 0x33AA33AA, "Congratulations!");
			return 1;
		}
		if(listitem == 2)
		{
		  	GivePlayerWeapon(playerid, 29, 70);
		  	SendClientMessage(playerid, 0x33AA33AA, "Congratulations!");
			return 1;
		}
		if(listitem == 3)
		{
		 	GivePlayerWeapon(playerid, 43, 70);
		 	SendClientMessage(playerid, 0x33AA33AA, "Congratulations!");
		    return 1;
		}
		if(listitem == 4)
		{
			GivePlayerWeapon(playerid, 18, 15);
			SendClientMessage(playerid, 0x33AA33AA, "Congratulations!");
		    return 1;
 		}
		if(listitem == 5)
		{
			GivePlayerWeapon(playerid, 23, 100);
			SendClientMessage(playerid, 0x33AA33AA, "Congratulations!");
		    return 1;
		}
	}
	if(dialogid == 183)
	{
        if(response)
        {
            new skinid, message[64];
            skinid = strval(inputtext);
            if(skinid < 1 || skinid > 299)
            {
                SendClientMessage(playerid, 0x33FF33AA, "Error: Choose a Skin between 1 and 299.");
            }
            else
            {
                SetPlayerSkin(playerid, skinid);
                format(message, sizeof(message), "You have successfully changed your skin to %d.", skinid);
                SendClientMessage(playerid, 0x33FF33AA, message);
            }
        }
        return 1;
    }
	if(dialogid == 189)
	{
        if(response)
        {
            new timej, message[64];
            timej = strval(inputtext);
            if(timej < 1 || timej > 23)
            {
                SendClientMessage(playerid, 0x33FF33AA, "Error: Choose a Time between 1 and 23.");
            }
            else
            {
                SetPlayerTime(playerid,timej,0);
                format(message, sizeof(message), "You have successfully changed your time to %d.", timej);
                SendClientMessage(playerid, 0x33FF33AA, message);
            }
        }
        return 1;
    }
   	if(dialogid == 190)
	{
        if(response)
        {
            new weatherid, message[64];
            weatherid = strval(inputtext);
            if(weatherid < 1 || weatherid > 1000)
            {
                SendClientMessage(playerid, 0x33FF33AA, "Error: Choose a Time between 1 and 1000.");
            }
            else
            {
                SetPlayerWeather(playerid,weatherid);
                format(message, sizeof(message), "You have successfully changed your weather to %d.", weatherid);
                SendClientMessage(playerid, 0x33FF33AA, message);
            }
        }
        return 1;
    }
	if(dialogid == 445) // == Car Menu
	{
		switch(listitem)//wich listitem is chosen
		{
			case 0://Bikes
			{
 				ShowModelSelectionMenu(playerid, bikeslist, "Bikes");
 				return 1;
			}
			case 1:
			{
				ShowModelSelectionMenu(playerid, car1, "Cars A-E");
				return 1;
			}
			case 2:
			{
			    ShowModelSelectionMenu(playerid, car2, "Cars F-P");
			    return 1;
			}
			case 3:
			{
			    ShowModelSelectionMenu(playerid, car3, "Cars P-S");
			    return 1;
			}
			case 4:
			{
			    ShowModelSelectionMenu(playerid, car4, "Cars S-Z");
			    return 1;
			}
			case 5:
			{
			    ShowModelSelectionMenu(playerid, helicopter, "Helicopters");
			    return 1;
			}
			case 6:
			{
			    ShowModelSelectionMenu(playerid, planes, "Planes");
			    return 1;
			}
			case 7:
			{
			    ShowModelSelectionMenu(playerid, boat, "Boats");
			    return 1;
			}
			case 8:
			{
			    ShowModelSelectionMenu(playerid, trains, "Trains");
			    return 1;
			}
			case 9:
			{
			    ShowModelSelectionMenu(playerid, trailers, "Trailers");
			    return 1;
			}
			case 10:
			{
			    ShowModelSelectionMenu(playerid, rcveh, "RC Vehicles + Vortex");
			    return 1;
			}
		}
		return 1;
	}
	return 0;
}
