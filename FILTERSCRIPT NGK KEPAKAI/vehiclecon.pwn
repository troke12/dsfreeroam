#define FILTERSCRIPT
#include <a_samp>
#include <zcmd>
#define red 0xAA3333AA //Change this to the error color you want.
#define COLOR_PURPLE 0xC2A2DAAA //prox detector color
new gLastCar[MAX_PLAYERS];



stock IsPlayerDriver(playerid)
{
 if(IsPlayerConnected(playerid) && GetPlayerState(playerid)==PLAYER_STATE_DRIVER)
 {
  return 1;
 }
 return 0;
}


public OnFilterScriptInit()
{
	print("\n--------------------------------------------");
	print("| Vehicle Control System - By Jack_Leslie |");
	print("--------------------------------------------\n");
	ManualVehicleEngineAndLights();
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
return 1;
}

/*CMD:objective(playerid, params[])
{
	new lights,alarm,doors,bonnet,boot,objective;
    GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
	if(!IsPlayerDriver(playerid))
	{
		SendClientMessage(playerid,red,"[Vehicle Control] You're not in a Vehicle to control the lights!");
		return 1;
	}
		else if(IsPlayerDriver(playerid))
			{
    			if(objective != 1)
				{
				    objective = 1;
					SetVehicleParamsEx(GetPlayerVehicleID(playerid),engine,lights,alarm,doors,bonnet,boot,VEHICLE_PARAMS_ON);
					SendClientMessage(playerid, 0xFFFFFFAA, "[Vehicle Control] You've turned the vehicle's objective {2F991A}on!");
				    return 1;
				}
				else
				{
				    objective = 0;
					SetVehicleParamsEx(GetPlayerVehicleID(playerid),engine,lights,alarm,doors,bonnet,boot,VEHICLE_PARAMS_OFF);
					SendClientMessage(playerid, 0xFFFFFFAA, "[Vehicle Control] You've turned the vehicle's objective {E31919}off!");
				    return 1;
				}
		}
  	return objective;
}*/ // Commented due to Non-RP on Roleplay Servers, feel free to un-comment if you wish to use it.

CMD:lights(playerid, params[])
{
	new string[128];
	new sendername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, sendername, sizeof(sendername));
	new engine,lights,alarm,doors,bonnet,boot,objective;
    GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
	if(!IsPlayerDriver(playerid))
	{
		SendClientMessage(playerid,red,"[Vehicle Control] You're not in a Vehicle to control the lights!");
		return 1;
	}
		else if(IsPlayerDriver(playerid))
			{
    			if(lights != 1)
				{
				    lights = 1;
					SetVehicleParamsEx(GetPlayerVehicleID(playerid),engine,VEHICLE_PARAMS_ON,alarm,doors,bonnet,boot,objective);
					SendClientMessage(playerid, 0xFFFFFFAA, "[Vehicle Control] You've turned the vehicle's lights {2F991A}on!");
					format(string, sizeof(string), "* %s flicks a switch on the dashboard, switching on their lights.", sendername);
				    ProxDetector(20.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				    return 1;
				}
				else
				{
				    lights = 0;
					SetVehicleParamsEx(GetPlayerVehicleID(playerid),engine,VEHICLE_PARAMS_OFF,alarm,doors,bonnet,boot,objective);
					SendClientMessage(playerid, 0xFFFFFFAA, "[Vehicle Control] You've turned the vehicle's lights {E31919}off!");
					format(string, sizeof(string), "* %s flicks a switch on the dashboard, switching off their lights.", sendername);
				    ProxDetector(20.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				    return 1;
				}
		}
  	return lights;
}

CMD:hood(playerid, params[])
{
	new string[128];
	new sendername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, sendername, sizeof(sendername));
	new engine,lights,alarm,doors,bonnet,boot,objective;
    new oldcar = gLastCar[playerid];
	new Float:cX, Float:cY, Float:cZ;
	GetVehicleParamsEx(oldcar, engine, lights, alarm, doors, bonnet, boot, objective);
	GetVehiclePos(oldcar, cX, cY, cZ);
	new vehicleid = GetPlayerVehicleID(playerid);
	if(!IsAPlane(vehicleid) || !IsAHelicopter(vehicleid) || !IsABike(vehicleid) || !IsATrain(vehicleid) || !IsABoat(vehicleid))
	{
		if(IsPlayerDriver(playerid) || IsPlayerInRangeOfPoint(playerid, 5, cX-2, cY, cZ))
			{
    			if(bonnet != 1)
				{
				    bonnet = 1;
					SetVehicleParamsEx(oldcar,engine,lights,alarm,doors,VEHICLE_PARAMS_ON,boot,objective);
					SendClientMessage(playerid, 0xFFFFFFAA, "[Vehicle Control] You've opened the hood!");
					format(string, sizeof(string), "* %s opens up the hood of the car.", sendername);
				    ProxDetector(20.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				    return 1;
				}
				else
				{
				    bonnet = 0;
					SetVehicleParamsEx(oldcar,engine,lights,alarm,doors,VEHICLE_PARAMS_OFF,boot,objective);
					SendClientMessage(playerid, 0xFFFFFFAA, "[Vehicle Control] You've shut the hood!");
					format(string, sizeof(string), "* %s closes the hood of the car.", sendername);
				    ProxDetector(20.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				    return 1;
				}
		}
	}
  	return bonnet;
}

CMD:trunk(playerid, params[])
{
	new string[128];
	new sendername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, sendername, sizeof(sendername));
	new engine,lights,alarm,doors,bonnet,boot,objective;
    new oldcar = gLastCar[playerid];
	new Float:cX, Float:cY, Float:cZ;
	GetVehicleParamsEx(oldcar, engine, lights, alarm, doors, bonnet, boot, objective);
	GetVehiclePos(oldcar, cX, cY, cZ);
	new vehicleid = GetPlayerVehicleID(playerid);
	if(!IsAPlane(vehicleid) || !IsAHelicopter(vehicleid) || !IsABike(vehicleid) || !IsATrain(vehicleid) || !IsABoat(vehicleid))
	{
		if(IsPlayerDriver(playerid) || IsPlayerInRangeOfPoint(playerid, 5, cX+2, cY, cZ))
				{
    				if(boot != 1)
					{
				    	boot = 1;
						SetVehicleParamsEx(oldcar,engine,lights,alarm,doors,bonnet,VEHICLE_PARAMS_ON,objective);
						SendClientMessage(playerid, 0xFFFFFFAA, "[Vehicle Control] You've opened the trunk!");
						format(string, sizeof(string), "* %s opens up the trunk of the car.", sendername);
				    	ProxDetector(20.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				    	return 1;
					}
					else
					{
				    	boot = 0;
						SetVehicleParamsEx(oldcar,engine,lights,alarm,doors,bonnet,VEHICLE_PARAMS_OFF,objective);
						SendClientMessage(playerid, 0xFFFFFFAA, "[Vehicle Control] You've shut the trunk!");
						format(string, sizeof(string), "* %s closes the trunk of the car.", sendername);
				    	ProxDetector(20.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				    	return 1;
					}
			}
		}
  	return boot;
}

/*CMD:lockv(playerid, params[])
{
    new oldcar = gLastCar[playerid];
	new Float:cX, Float:cY, Float:cZ;
	GetVehiclePos(oldcar, cX, cY, cZ);
	new string[128];
	new sendername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, sendername, sizeof(sendername));
	new engine,lights,alarm,doors,bonnet,boot,objective;
    GetVehicleParamsEx(oldcar, engine, lights, alarm, doors, bonnet, boot, objective);
	if(!IsPlayerInRangeOfPoint(playerid, 4, cX, cY, cZ))
	{
		SendClientMessage(playerid,red,"[Vehicle Control] You're not in range/in the Vehicle you last drove!");
		return 1;
	}
		else if(IsPlayerInRangeOfPoint(playerid, 4, cX, cY, cZ))
			{
    			if(doors != 1)
				{
				    doors = 1;
					SetVehicleParamsEx(oldcar,engine,lights,alarm,VEHICLE_PARAMS_ON,bonnet,boot,objective);
					SendClientMessage(playerid, 0xFFFFFFAA, "[Vehicle Control] You've locked the vehicle!");
					format(string, sizeof(string), "* %s locks their vehicle.", sendername);
				    ProxDetector(20.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				    return 1;
				}
				else
				{
				    doors = 0;
					SetVehicleParamsEx(oldcar,engine,lights,alarm,VEHICLE_PARAMS_OFF,bonnet,boot,objective);
					SendClientMessage(playerid, 0xFFFFFFAA, "[Vehicle Control] You've unlocked the vehicle!");
					format(string, sizeof(string), "* %s unlocks his vehicle.", sendername);
				    ProxDetector(20.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				    return 1;
				}
		}
  	return doors;
}*/
