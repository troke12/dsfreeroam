// [FS] Engine System v3
// Made by Joe Torran C
// Credits to JeNkStA for helping me fix some stuff
// DO NOT REMOVE THESE CREDITS

#include <a_samp>
#include <zcmd>

#define colorRed        0xFF0000FF
#define colorYellow 	0xFFFF00FF

forward StartEngine(playerid);
forward DamagedEngine(playerid);

new vehEngine[MAX_VEHICLES];

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if(newstate == PLAYER_STATE_DRIVER)
	{
	    if(vehEngine[vehicleid] == 0)
	    {
	        TogglePlayerControllable(playerid, 0);
	        SendClientMessage(playerid, colorYellow, "Vehicle engine NOT started");
	        SendClientMessage(playerid, colorYellow, "To start the vehicle's engine press \"Shift\" or type \"/engine\"");
		}
		else if(vehEngine[vehicleid] == 1)
		{
		    TogglePlayerControllable(playerid, 1);
		    SendClientMessage(playerid, colorYellow, "Vehicle engine running");
		}
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    new vehicleid = GetPlayerVehicleID(playerid);

	if(IsPlayerInAnyVehicle(playerid))
	{
	    if(vehEngine[vehicleid] == 0)
	    {
	        if(newkeys == KEY_JUMP)
	        {
				vehEngine[vehicleid] = 2;
				SetTimerEx("StartEngine", 3000, 0, "i", playerid);
				SendClientMessage(playerid, colorYellow, "Vehicle engine starting");
			}
		}
		if(newkeys == KEY_SECONDARY_ATTACK)
		{
		    RemovePlayerFromVehicle(playerid);
		    TogglePlayerControllable(playerid, 1);
		}
	}
	return 1;
}

public StartEngine(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    new Float:health;
    new rand = random(2);

    GetVehicleHealth(vehicleid, health);

	if(IsPlayerInAnyVehicle(playerid))
	{
	    if(vehEngine[vehicleid] == 2)
	    {
	        if(health > 300)
			{
			    if(rand == 0)
			    {
					vehEngine[vehicleid] = 1;
  					TogglePlayerControllable(playerid, 1);
  					SetTimerEx("DamagedEngine", 1000, 1, "i", playerid);
	        		SendClientMessage(playerid, colorYellow, "Vehicle engine started");
				}
				if(rand == 1)
				{
				    vehEngine[vehicleid] = 0;
				    TogglePlayerControllable(playerid, 0);
				    SendClientMessage(playerid, colorYellow, "Vehicle engine failed to start");
				}
			}
			else
			{
			    vehEngine[vehicleid] = 0;
			    TogglePlayerControllable(playerid, 0);
			    SendClientMessage(playerid, colorYellow, "Vehicle engine failed to start due to damage");
			}
		}
	}
	return 1;
}

public DamagedEngine(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    new Float:health;

    GetVehicleHealth(vehicleid, health);

	if(IsPlayerInAnyVehicle(playerid))
	{
	    if(vehEngine[vehicleid] == 1)
	    {
	        if(health < 300)
			{
			    vehEngine[vehicleid] = 0;
				TogglePlayerControllable(playerid, 0);
			    SendClientMessage(playerid, colorYellow, "Vehicle engine stopped due to damage");
			}
		}
	}
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	TogglePlayerControllable(playerid, 1);
	return 1;
}

CMD:engine(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, colorRed, "You need to be in a vehicle to use this command");

	if(vehEngine[vehicleid] == 0)
	{
	    vehEngine[vehicleid] = 2;
		SetTimerEx("StartEngine", 3000, 0, "i", playerid);
		SendClientMessage(playerid, colorYellow, "Vehicle engine starting");
	}
	else if(vehEngine[vehicleid] == 1)
	{
	    vehEngine[vehicleid] = 0;
		TogglePlayerControllable(playerid, 0);
		SendClientMessage(playerid, colorYellow, "Vehicle engine stopped");
		SendClientMessage(playerid, colorYellow, "To re-start the vehicle's engine press \"Shift\" or type \"/engine\"");
	}
	return 1;
}

public OnFilterScriptInit()
{
	print("\n  [FS] Engine System v3 by Joe Torran C \n");
	return 1;
}
