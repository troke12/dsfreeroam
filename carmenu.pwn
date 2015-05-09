//==============================================================//
//Authors : Krisna
//Forum   : http://forum.sa-mp.com/member.php?u=192739
//Do not remove my credits
//==============================================================//

//========INCLUDE=====//
#include <a_samp>
#include <mSelection>
#include <zcmd>

//======DEFINE========//
#define carmenu 4450

//====NEW=========//
new Float:X, Float:Y, Float:Z, Float:Angle;
new CurrentSpawnedVehicle[MAX_PLAYERS];
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

//====ONFILTERSCRIPTINIT===//
public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" CARMENU SELECTION BY KRISNA LOADED ");
	print("--------------------------------------\n");
	return 1;
}
//=====ONGAMEMODEINIT===//
public OnGameModeInit()
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
	return 1;
}
//==========COMMANDS=======//
CMD:carmenu(playerid, params[])
{
	ShowPlayerDialog(playerid, carmenu, DIALOG_STYLE_LIST, "Vehicle Selection Menu","Bikes\nCars 1 [A-E]\nCars 2 [F-P]\nCars 3 [P-S]\nCars 4 [S-Z]\nHelicopters\nPlanes\nBoats\nTrains\nTrailers\nRC Vehicles + Vortex", "Select", "Cancel");
	return 1;
}
//=========ONDIALOGRESPONSE====//
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == carmenu) // == Car menu dialog id
	{
        if(response) // If they clicked 'Select' or double-clicked a List
        {
 			if(listitem == 0)
 			{
 				ShowModelSelectionMenu(playerid, bikeslist, "Bikes");
 				return 1;
			}
		 	if(listitem == 1)
			{
				ShowModelSelectionMenu(playerid, car1, "Cars A-E");
				return 1;
			}
		 	if(listitem == 2)
			{
			    ShowModelSelectionMenu(playerid, car2, "Cars F-P");
			    return 1;
			}
		 	if(listitem == 3)
			{
			    ShowModelSelectionMenu(playerid, car3, "Cars P-S");
			    return 1;
			}
		 	if(listitem == 4)
			{
			    ShowModelSelectionMenu(playerid, car4, "Cars S-Z");
			    return 1;
			}
			if(listitem == 5)
			{
			    ShowModelSelectionMenu(playerid, helicopter, "Helicopters");
			    return 1;
			}
			if(listitem == 6)
			{
			    ShowModelSelectionMenu(playerid, planes, "Planes");
			    return 1;
			}
			if(listitem == 7)
			{
			    ShowModelSelectionMenu(playerid, boat, "Boats");
			    return 1;
			}
			if(listitem == 8)
			{
			    ShowModelSelectionMenu(playerid, trains, "Trains");
			    return 1;
			}
			if(listitem == 9)
			{
			    ShowModelSelectionMenu(playerid, trailers, "Trailers");
			    return 1;
			}
			if(listitem == 10)
			{
			    ShowModelSelectionMenu(playerid, rcveh, "RC Vehicles + Vortex");
			    return 1;
			}
		}
		else SendClientMessage(playerid, 0xFF40FF, "Canceled Cars selection");
	}
	return 0;
}
//======ONPLAYERMODELSELECTION======//
public OnPlayerModelSelection(playerid, response, listid, modelid)
{
	if(listid == bikeslist)
	{
	    if(response)
	    {
		    SendClientMessage(playerid, 0xFF0000FF, "Cars Spawned");
	    	CreateVehicleEx(playerid,modelid, X,Y,Z+1, Angle, random(126), random(126), -1);
	    }
	    else SendClientMessage(playerid, 0xFF0000FF, "Canceled Bikes selection");
    	return 1;
	}
	if(listid == car1)
	{
	    if(response)
	    {
		    SendClientMessage(playerid, 0xFF0000FF, "Cars Spawned");
	    	CreateVehicleEx(playerid,modelid, X,Y,Z+1, Angle, random(126), random(126), -1);
	    }
	    else SendClientMessage(playerid, 0xFF0000FF, "Canceled Cars selection");
    	return 1;
	}
	if(listid == car2)
	{
	    if(response)
	    {
		    SendClientMessage(playerid, 0xFF0000FF, "Cars Spawned");
	    	CreateVehicleEx(playerid,modelid, X,Y,Z+1, Angle, random(126), random(126), -1);
	    }
	    else SendClientMessage(playerid, 0xFF0000FF, "Canceled Cars selection");
    	return 1;
	}
	if(listid == car3)
	{
	    if(response)
	    {
		    SendClientMessage(playerid, 0xFF0000FF, "Cars Spawned");
	    	CreateVehicleEx(playerid,modelid, X,Y,Z+1, Angle, random(126), random(126), -1);
	    }
	    else SendClientMessage(playerid, 0xFF0000FF, "Canceled Cars selection");
    	return 1;
	}
	if(listid == car4)
	{
	    if(response)
	    {
		    SendClientMessage(playerid, 0xFF0000FF, "Cars Spawned");
	    	CreateVehicleEx(playerid,modelid, X,Y,Z+1, Angle, random(126), random(126), -1);
	    }
	    else SendClientMessage(playerid, 0xFF0000FF, "Canceled Cars selection");
    	return 1;
	}
	if(listid == helicopter)
	{
	    if(response)
	    {
		    SendClientMessage(playerid, 0xFF0000FF, "Cars Spawned");
	    	CreateVehicleEx(playerid,modelid, X,Y,Z+1, Angle, random(126), random(126), -1);
	    }
	    else SendClientMessage(playerid, 0xFF0000FF, "Canceled Helicopter selection");
    	return 1;
	}
	if(listid == planes)
	{
	    if(response)
	    {
		    SendClientMessage(playerid, 0xFF0000FF, "Cars Spawned");
	    	CreateVehicleEx(playerid,modelid, X,Y,Z+1, Angle, random(126), random(126), -1);
	    }
	    else SendClientMessage(playerid, 0xFF0000FF, "Canceled Planes selection");
    	return 1;
	}
    if(listid == boat)
	{
	    if(response)
	    {
		    SendClientMessage(playerid, 0xFF0000FF, "Cars Spawned");
	    	CreateVehicleEx(playerid,modelid, X,Y,Z+1, Angle, random(126), random(126), -1);
	    }
	    else SendClientMessage(playerid, 0xFF0000FF, "Canceled Boats selection");
    	return 1;
	}
	if(listid == trains)
	{
	    if(response)
	    {
		    SendClientMessage(playerid, 0xFF0000FF, "Cars Spawned");
	    	CreateVehicleEx(playerid,modelid, X,Y,Z+1, Angle, random(126), random(126), -1);
	    }
	    else SendClientMessage(playerid, 0xFF0000FF, "Canceled Trains selection");
    	return 1;
	}
	if(listid == trailers)
	{
	    if(response)
	    {
		    SendClientMessage(playerid, 0xFF0000FF, "Cars Spawned");
	    	CreateVehicleEx(playerid,modelid, X,Y,Z+1, Angle, random(126), random(126), -1);
	    }
	    else SendClientMessage(playerid, 0xFF0000FF, "Canceled Trailers selection");
    	return 1;
	}
	if(listid == rcveh)
	{
	    if(response)
	    {
		    SendClientMessage(playerid, 0xFF0000FF, "Cars Spawned");
	    	CreateVehicleEx(playerid,modelid, X,Y,Z+1, Angle, random(126), random(126), -1);
	    }
	    else SendClientMessage(playerid, 0xFF0000FF, "Canceled Cars selection");
    	return 1;
	}
	return 1;
}
//==============================================================================
stock IsVehicleOccupied(vehicleid)
{
  	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(GetPlayerState(i) == PLAYER_STATE_DRIVER || GetPlayerState(i) == PLAYER_STATE_PASSENGER)
		{
			if(GetPlayerVehicleID(i) == vehicleid)
			{
				return 1;
			}
		}
	}
	return 0;
}
//==============================================================================
stock CreateVehicleEx(playerid, modelid, Float:posX, Float:posY, Float:posZ, Float:angle, Colour1, Colour2, respawn_delay)
{
	new world = GetPlayerVirtualWorld(playerid);
	new interior = GetPlayerInterior(playerid);
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		DestroyVehicle(GetPlayerVehicleID(playerid));
		GetPlayerPos(playerid, posX, posY, posZ);
		GetPlayerFacingAngle(playerid, angle);
		CurrentSpawnedVehicle[playerid] = CreateVehicle(modelid, posX, posY, posZ, angle, Colour1, Colour2, respawn_delay);
        LinkVehicleToInterior(CurrentSpawnedVehicle[playerid], interior);
		SetVehicleVirtualWorld(CurrentSpawnedVehicle[playerid], world);
		SetVehicleZAngle(CurrentSpawnedVehicle[playerid], angle);
		PutPlayerInVehicle(playerid, CurrentSpawnedVehicle[playerid], 0);
		SetPlayerInterior(playerid, interior);
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
	    if(IsVehicleOccupied(CurrentSpawnedVehicle[playerid])) {} else DestroyVehicle(CurrentSpawnedVehicle[playerid]);
		GetPlayerPos(playerid, posX, posY, posZ);
		GetPlayerFacingAngle(playerid, angle);
		CurrentSpawnedVehicle[playerid] = CreateVehicle(modelid, posX, posY, posZ, angle, Colour1, Colour2, respawn_delay);
		LinkVehicleToInterior(CurrentSpawnedVehicle[playerid], interior);
		SetVehicleVirtualWorld(CurrentSpawnedVehicle[playerid], world);
		SetVehicleZAngle(CurrentSpawnedVehicle[playerid], angle);
		PutPlayerInVehicle(playerid, CurrentSpawnedVehicle[playerid], 0);
		SetPlayerInterior(playerid, interior);
	}
	return 1;
}
//==============================================================================
//EOF
