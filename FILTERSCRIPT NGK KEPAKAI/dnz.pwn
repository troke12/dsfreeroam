/*  		************ Special thanks goes to 'Kid_SnooB' *************

	Credits:
				Me [U]214   - Creating it
				Kid_SnooB   - Nice sscanf Loading tutorial and Map Icon help
				ZeeX 		- ZCMD
			 	Incognito 	- streamer plugin
			 	Y_Less 	- sscanf2 plugin

		Updated =
		* Removed RCON, so you just can now go in game and make them ;P
		* Fixed the 3ds, Thanx jiggy89 for that :P

*/

#include <a_samp>
#include <streamer>
#include <zcmd>
#include <sscanf2>

#define COLOR_GREEN 			0x008000FF
#define COLOR_LIGHTBLUE 		0xADD8E6FF
#define COLOR_RED 				0xFF0000FF
#define COLOR_LIGHTGREEN 		0x90EE90FF

new ForRndColorLabel[] =
{
	COLOR_GREEN,
	COLOR_LIGHTBLUE,
	COLOR_RED,
	COLOR_LIGHTGREEN // last dont have ,
};

// Locations to save: (Default: scriptfiles folder)

#define ICON_FILE_NAME 			"DMapIcons.txt"
#define VEHICLE_FILE_NAME 		"DVehicles.txt"
#define PICKUP_FILE_NAME 		"DPickups.txt"
#define LABEL_FILE_NAME 		"DLabels.txt"

new Msg[128];

public OnFilterScriptInit()
{
	print("=====================================================================");
	new Line[60], Veh, Pickup, Labels;
	Pickup = AddPickupFromFile(PICKUP_FILE_NAME);
	format(Line, sizeof(Line),"** %i\t<->\tPickups Loaded From\t<->\tDPickups.txt **", Pickup);
	printf(Line);

	Veh = AddVehiclesFromFile(VEHICLE_FILE_NAME);
	format(Line, sizeof(Line), "** %i\t<->\tVehicles Loaded From\t<->\tDVehicles.txt **", Veh);
	printf(Line);

	Labels = AddLabelsFromFile(LABEL_FILE_NAME);
	format(Line, sizeof(Line), "** %i\t<->\tLabels Loaded From\t<->\tDLabels.txt **",Labels);
	printf(Line);
	print("=====================================================================\n");
	print("********* Dynamic System By [U]214 Loaded. U-Clan.com *********");
	return 1;
}
// destroying our created mapicons, pickups etc..
public OnFilterScriptExit()
{
	DestroyAllDynamicMapIcons();
	DestroyAllDynamicPickups();
	DestroyAllDynamic3DTextLabels();
	print("********* Dynamic System By [U]214 UnLoaded. U-Clan.com *********");
	return 1;
}

public OnPlayerConnect(playerid)
{
	AddMapIconFromFile(ICON_FILE_NAME); // Loading icons
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

CMD:addicon(playerid, params[])
{
//	if(!IsPlayerAdmin(playerid)) return 0;
	new MType, Float:MX, Float:MY, Float:MZ, MColor;
	if(unformat(params, "ih", MType, MColor)) return SendClientMessage(playerid, COLOR_RED,"[USAGE] /AddIcon < Icon ID > < Icon Color >");
	GetPlayerPos(playerid, MX, MY, MZ);

	AddMapIconToFile(ICON_FILE_NAME, MX, MY, MZ, MType, MColor);

	for(new PID; PID < MAX_PLAYERS; PID++) if(IsPlayerConnected(PID))
	{
		CreateDynamicMapIcon(MX, MY, MZ, MType, MColor, -1, -1, -1, 100.0);
	}
	format(Msg,sizeof(Msg),"A new map icon has beed dynamically added. Model: (%d) Color: (%d).",MType, MColor);
	return SendClientMessage(playerid, COLOR_GREEN, Msg);
}

CMD:addvehicle(playerid, params[])
{
//	if(!IsPlayerAdmin(playerid)) return 0;
	new vModel, Float:VX, Float:VY, Float:VZ, Float:VA;
	if(IsPlayerInAnyVehicle(playerid))
	{
		GetPlayerPos(playerid, VX, VY, VZ);
		GetVehicleZAngle(GetPlayerVehicleID(playerid), VA);
		vModel = GetVehicleModel(GetPlayerVehicleID(playerid));

		AddVehicleToFile(VEHICLE_FILE_NAME, VX, VY, VZ, VA, vModel);
		format(Msg,sizeof(Msg),"A new vehicle has been dynamically added. Model: (%d).",vModel);
		return SendClientMessage(playerid, COLOR_GREEN, Msg);
	}
	else return SendClientMessage(playerid, COLOR_RED, "You must be in a vehicle to use this command!");
}

CMD:addpickup(playerid, params[])
{
//	if(!IsPlayerAdmin(playerid)) return 0;
	new PModel, PType, Float:PX, Float:PY, Float:PZ;
	if(unformat(params, "ih", PModel, PType)) return SendClientMessage(playerid, COLOR_RED,"[USAGE] /AddPickup < Pickup ID > < Spawn Type >");
	GetPlayerPos(playerid, PX, PY, PZ);

	AddPickupToFile(PICKUP_FILE_NAME, PX, PY, PZ, PModel, PType);
	CreateDynamicPickup(PModel, PType, PX, PY, PZ, -1, -1, -1, 100.0);
	format(Msg,sizeof(Msg),"A New Pickup Has Been Added. Model: \"%d\" - Spawn Type: \"%d\"",PModel, PType);
	return SendClientMessage(playerid, COLOR_GREEN, Msg);
}

CMD:add3dlabel(playerid, params[])
{
//	if(!IsPlayerAdmin(playerid)) return 0;
	new Float:X, Float:Y, Float:Z;
	if(unformat(params, "s[128]",params)) return SendClientMessage(playerid, COLOR_RED, "[USAGE] /Add3DLabel < Description >");
	GetPlayerPos(playerid, X, Y, Z);

	AddLabelToFile(LABEL_FILE_NAME, params, X, Y, Z);
	CreateDynamic3DTextLabel(params, ForRndColorLabel[random(sizeof(ForRndColorLabel))], X, Y, Z, 100.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 100.0);
	format(Msg, sizeof(Msg), "A new 3D Text Label has been dynamically added. Description: \"%s\".",params);
	return SendClientMessage(playerid, COLOR_GREEN, Msg);
}
//==============================================================================
// Dynamic Map Icons
//==============================================================================
stock AddMapIconFromFile(DFileName[])
{
	if(!fexist(DFileName)) return 0;

	new File:MapFile, MType, Float:MX, Float:MY, Float:MZ, MColor, Line[128];

	MapFile = fopen(DFileName, io_read);
	while(fread(MapFile, Line))
	{
	    if(Line[0] == '/' || isnull(Line)) continue;
	    unformat(Line, "fffii", MX, MY, MZ, MType, MColor);
	    CreateDynamicMapIcon(MX, MY, MZ, MType, MColor, -1, -1, -1, 100.0);
	}
	fclose(MapFile);
	return 1;
}

stock AddMapIconToFile(DFileName[], Float:MX, Float:MY, Float:MZ, MType, MColor)
{
	new File:MapFile, Line[128];

	format(Line, sizeof(Line), "%f %f %f %i %i\r\n", MX, MY, MZ, MType, MColor);
	MapFile = fopen(DFileName, io_append);
	fwrite(MapFile, Line);
	fclose(MapFile);
	return 1;
}
//==============================================================================
// Dynamic Vehicles
//==============================================================================
stock AddVehiclesFromFile(DFileName[])
{
	if(!fexist(DFileName)) return 0;

	new File:VehicleFile, vModel, Float:VX, Float:VY, Float:VZ, Float:VA, vTotal, Line[128];

	VehicleFile = fopen(DFileName, io_read);
	while(fread(VehicleFile, Line))
	{
	    if(Line[0] == '/' || isnull(Line)) continue;
	    unformat(Line, "ffffi", VX, VY, VZ, VA, vModel);
	    AddStaticVehicleEx(vModel, VX, VY, VZ, VA, -1, -1, (30*60));
	    vTotal++;
	}
	fclose(VehicleFile);
	return vTotal;
}

stock AddVehicleToFile(DFileName[], Float:VX, Float:VY, Float:VZ, Float:VA, vModel)
{
	new File:VehicleFile, Line[128];

	format(Line, sizeof(Line), "%f %f %f %f %i\r\n", VX, VY, VZ, VA, vModel);
	VehicleFile = fopen(DFileName, io_append);
	fwrite(VehicleFile, Line);
	fclose(VehicleFile);
	return 1;
}
//==============================================================================
// Dynamic Pickups
//==============================================================================
stock AddPickupFromFile(DFileName[])
{
	if(!fexist(DFileName)) return 0;

	new File:PickupFile, PType, PModel, Float:PX, Float:PY, Float:PZ, pTotal, Line[128];

	PickupFile = fopen(DFileName, io_read);
	while(fread(PickupFile, Line))
	{
	    if(Line[0] == '/' || isnull(Line)) continue;
	    unformat(Line, "fffii", PX, PY, PZ, PModel, PType);
	    CreateDynamicPickup(PModel, PType, PX, PY, PZ, -1, -1, -1, 100.0);
	    pTotal++;
	}
	fclose(PickupFile);
	return pTotal;
}

stock AddPickupToFile(DFileName[], Float:PX, Float:PY, Float:PZ, PModel, PType)
{
	new File:PickupFile, Line[128];

	format(Line, sizeof(Line), "%f %f %f %i %i\r\n", PX, PY, PZ, PModel, PType);
	PickupFile = fopen(DFileName, io_append);
	fwrite(PickupFile, Line);
	fclose(PickupFile);
	return 1;
}
//==============================================================================
// Dynamic 3D TextLabels
//==============================================================================
stock AddLabelsFromFile(LFileName[])
{
	if(!fexist(LFileName)) return 0;

	new File:LFile, Line[128], LabelInfo[128], Float:LX, Float:LY, Float:LZ, lTotal = 0;

	LFile = fopen(LFileName, io_read);
	while(fread(LFile, Line))
	{
	    if(Line[0] == '/' || isnull(Line)) continue;
	    unformat(Line, "p<,>s[128]fff", LabelInfo,LX,LY,LZ);
		//CreateDynamic3DTextLabel(LabelInfo, COLOR_LIGHTGREEN, LX, LY, LZ, 100.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 100.0);
//ForRndColorLabel
        CreateDynamic3DTextLabel(LabelInfo, ForRndColorLabel[random(sizeof(ForRndColorLabel))], LX, LY, LZ, 100.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 100.0);
		lTotal++;
	}
	fclose(LFile);
	return lTotal;
}

stock AddLabelToFile(LFileName[], LabelInfo[], Float:LX, Float:LY, Float:LZ)
{
	new File:LFile, Line[128];

	format(Line, sizeof(Line), "%s,%.2f,%.2f,%.2f\r\n",LabelInfo, LX, LY, LZ);
	LFile = fopen(LFileName, io_append);
	fwrite(LFile, Line);
	fclose(LFile);
	return 1;
}
