/*
     // - - - - - - - - - - - -	- - - //
    //   Random Race Generator v1.1  //
   // - - - - - - - - - - - - - - - // 

	Commands:
	 /joinrace
		- opens the race map where you can create
		  new races or join current ones.
	 /startrace		
		- starts the current race.
		  (only works for the creator of the race)
	 /leaverace
		- (if creator) destroys the current race.
		  (if contestant) leaves the current race.
	 /respawninrace
		- respawns the player at the last checkpoint.
		

*/

// ---------------------------------------------
// --- > --- > --- MAIN SETTINGS --- < --- < ---
// ---------------------------------------------


// This is the maximum amount of races shown in the list.
// Note: If this number is too high, it will overlap the "Create", "Join" and "Close" buttons.
// Default: 14
#define MAX_RACES 14


// This is the "maximum" distance a race can be in meters.
// Note: The race won't stop at this exact number, it will try to find a finish point as quickly as possible.
// Default: 30000
#define MAX_RACE_DISTANCE 30000


// This defines the minimal distance a race can be in meters.
// Default: 150
#define MIN_RACE_DISTANCE 150


// This number defines the maximum amount of checkpoints that will be saved into memory.
// Note 1: If a race exceeds this number, it will immediately spawn a finish point at the last checkpoint.
// Note 2: Try to find a good balance between this number and MAX_RACE_DISTANCE.
// Default: 200
#define MAX_CHECKPOINTS 200


// This number is the maximum amount of textdraw icons that will be shown on the /joinrace map.
// Note: The limit seems to be somewhere around 85.
// Default: 80
#define MAX_TEXTDRAW_ICONS 80


// This is the maximum amount of contestans that are allowed to join a race.
// Note 1: This number includes the race starter! 
// Note 2: The higher the number, the more vehicles have to be spawned, the higher the chance that they'll get stuck inside buildings.
// Default: 8
#define MAX_CONTESTANTS 8


// This is the minimum distance between checkpoints. 
// Default: 100.0
#define MINIMAL_DISTANCE_CP 100.0


// This defines whether to remember the old position of a player, before he joins a race.
// Note: When set to true, the player will be spawned at his old position after the race finishes.
// Default: false
#define REMEMBER_OLD_POSITION false


// This defines the virtual world which will be used for the races.
// Default: 0
#define RACE_VIRTUAL_WORLD 0


// This defines the amount of milliseconds before you'll be respawned.
// Default: 2000
#define RESPAWN_TIME 2000


// This is the amount of time it will take before a player gets disqualified for leaving their vehicle.
// Note: Set to 0 if you want to disable this, which allows the player to roam the land on foot and he might annoy other people.
// Default: 25 
#define VEHICLE_LEAVE_TIME 25


// This number defines the maximum amount of map icons on the radar, which will be used to suggest the next checkpoints.
// Note 1: As of 0.3x, the limit is 100 map icons.
// Note 2: If you are using a map icon streamer, these suggested icons might not work properly.
// Default: 2
#define MAX_SUGGESTED_MAPICONS 2



// ------------------------------------------------
// --- > --- > --- VEHICLE SETTINGS --- < --- < ---
// ------------------------------------------------


// This is a list with the available vehicles during the race.
// Note: This is a very error-prone part of the script, be careful with adding other vehicles!
// Example: 415,
new RaceVehicleList[] = {
	415, // Cheetah
	411, // Infernus
	451, // Turismo
	560, // Sultan
	494, // Hotring Racer
	524, // Cement Truck
	407, // Firetruck
	444, // Monster Truck
	423, // Mr. Whoopee
	457, // Golf Caddy
	571, // Go-Kart
	594, // RC Cam
	568, // Bandito
	463, // Freeway
	461, // PCJ-600
	468, // Sanchez
	471, // Quadbike
	510, // Mountain Bike
	530, // Forklift
	539  // Vortex Hovercraft
	// Make sure the last entry doesn't have a comma! (All the other entries require a comma at the end.)
};


// This defines whether the player is allowed to pick any vehicle using their ID.
// Note 1: this only adds an extra option to the vehicle list called "Enter a specific model ID", the above list will still exist.
// Note 2: this allows the player to also spawn airplanes, helicopters or invalid vehicles like trailers!
// Default: false
#define ALLOW_ALL_VEHICLES false


// These values define the vehicle colors used on the model defined at RACE_VEHICLE_MODEL or the vehicle in the race.
// Default: -1 and -1
#define RACE_VEHICLE_COL1 -1
#define RACE_VEHICLE_COL2 -1



// --------------------------------------------------
// --- > --- > --- TECHNICAL SETTINGS --- < --- < ---
// --------------------------------------------------


// This is the PVar-tag that will be used for Player Variables.
// Note: This is used to prevent conflicts with other scripts and their variables.
// Default: "RRG_"
#define PVAR_TAG "RRG_"


// This number is the offset of the ID which will be used for dialogs.
// Note: Use an unique number which doesn't come close to other IDs used in other scripts.
// Default: 1357
#define DIALOG_OFFSET 1357


// This is the offset, which will be used to create the suggested race checkpoints on the radar.
// Note 1: If this number is lower than 0 or higher than 99, the map icons might not show. (Limit of SA-MP 0.3x.)
// Note 2: The map icons IDs will start at this number. If you have 3 suggested icons (see MAX_SUGGESTED_MAPICONS), make sure this number isn't higher than 97 due to limits.
// Default: 80
#define SUGGESTED_MAPICONS_OFFSET 80



// ----------------------------------------------
// --- > --- > --- COLOR SETTINGS --- < --- < ---
// ----------------------------------------------


// This color is used for empty race slots in the /joinrace menu.
// Default: 0xFFFFFFFF (White)
#define COL_MENU_REGULAR 0xFFFFFFFF


// This color is shown when you move your mouse over a race slot in the /joinrace menu.
// Default: 0xDD8080FF (Indian/light red)
#define COL_MENU_MOUSEOVER 0xDD8080FF


// This color is used when you select one of the slots in the /joinrace menu.
// Default: 0xCF2C23FF (Firebrick/dark red)
#define COL_MENU_SELECTED 0xCF2C23FF


// This color is used for a race slot which can't be joined anymore.
// Default: 0x5B0000FF (Very dark red)
#define COL_MENU_STARTED 0x5B0000FF


// This is the color which is used for the regular chat text.
// Default: 0xFFFFFFFF (White)
#define COL_TEXT_REG 0xFFFFFFFF


// This is the color which is used for the winners chat text.
// Default: 0xFF3E3EFF (Just red)
#define COL_TEXT_WIN 0xFF3E3EFF


// This is the color which is used for the chat errors.
// Default: 0xD21313FF (Firebrick/dark red)
#define COL_TEXT_ERROR 0xD21313FF


// This color is used for the (radar) map icons which suggest the next checkpoints.
// Default: 0x5B0000FF (Very dark red)
#define COL_MAP_CP 0x5B0000FF



// -----------------------------------------
// --- > --- > --- CHANGELOG --- < --- < ---
// -----------------------------------------

/* 
	[v 1.1]		13th of August 2013
 - Added: You can use different vehicle models for a race now in a pre-set list. This list is changeable in the settings.
 - Added: There's also an option called "Enter a specific model ID" in the list, but this has to be enabled via the settings.
 - Added: The join menu now has a sidebar on the left, which contains information about the selected race. (vehicle, length, host, contestants etc..)
 - Added: Several new settings in the *.PWN file, like: configurable respawn time, race vehicle list and some internal offsets and limits.
 - Added: When leaving your vehicle, you'll be prompted to return to it. If not, the player will be removed from the race.
 - Added: When waiting for a race to start, the player-list is shown to notify you who's in the race.
 - Changed: The "How to respawn"-message so it will show up when the countdown hits '3' instead of 'GO'.
 - Changed: Default minimum race distance is now 150 instead of 500.
 - Improved: Slightly better route and distance calculation.
 - Improved: Extra UI information during race creation for slower servers. (In case creating a race takes longer than a few seconds.)
 - Fixed: /leaverace doesn't try to remove you from a race anymore, if you aren't in one.
 - Fixed: Your vehicle is locked now so people can't highjack your race vehicle anymore.
 - Fixed: You won't be respawned twice when dying in your exploding vehicle.
 - Fixed: Races which were created in the first slot will start properly now.
 - Fixed: You can now only check checkpoints if you are in your race vehicle.

	[v 1.0]		17th of May 2013
 - First release
 
 */

#include <a_samp>
#include <RouteConnector>

new raceOwners[MAX_RACES] = {INVALID_PLAYER_ID, ...};
new raceFinishedPeople[MAX_RACES char];
new bool: raceStarted[MAX_RACES char];
new raceVehicleModel[MAX_RACES];
new raceEndTimers[MAX_RACES char] = {-1, ...};
new Float: raceDistance[MAX_RACES];
new Float: raceCheckpointList[MAX_RACES][MAX_CHECKPOINTS][3];
new Text: raceMapIcons[MAX_RACES][MAX_TEXTDRAW_ICONS];
//new nodeDisconnecterBuffer[32][4];

new Text: joinMenuButtons[3];
new Text: joinMenuSlots[MAX_RACES];
new Text: joinMenuRaceInfo[MAX_RACES][3];
new Text: joinMenuExtra[4];

#define MENU_X 50.0
#define MENU_Y 145.0

#define MAX_VEHICLE_NAME 25
new const VehicleNames[][MAX_VEHICLE_NAME char] = {
	!"Landstalker", !"Bravura", !"Buffalo", !"Linerunner", !"Perennial", !"Sentinel", !"Dumper", !"Firetruck", !"Trashmaster", !"Stretch", !"Manana", !"Infernus", !"Voodoo", !"Pony", !"Mule",
	!"Cheetah", !"Ambulance", !"Leviathan", !"Moonbeam", !"Esperanto", !"Taxi", !"Washington", !"Bobcat", !"Mr Whoopee", !"BF Injection", !"Hunter", !"Premier", !"Enforcer", !"Securicar", !"Banshee",
	!"Predator", !"Bus", !"Rhino", !"Barracks", !"Hotknife", !"Closed Trailer A", !"Previon", !"Coach", !"Cabbie", !"Stallion", !"Rumpo", !"RC Bandit",	"Romero", !"Packer", !"Monster",
	!"Admiral", !"Squalo", !"Seasparrow", !"Pizzaboy", !"Tram", !"Open Trailer", !"Turismo", !"Speeder", !"Reefer", !"Tropic", !"Flatbed", !"Yankee", !"Caddy", !"Solair", !"Berkley's RC Van",
	!"Skimmer", !"PCJ-600", !"Faggio", !"Freeway", !"RC Baron", !"RC Raider", !"Glendale", !"Oceanic", !"Sanchez", !"Sparrow", !"Patriot", !"Quad", !"Coastguard", !"Dinghy", !"Hermes",
	!"Sabre", !"Rustler", !"ZR-350", !"Walton", !"Regina", !"Comet", !"BMX", !"Burrito", !"Camper", !"Marquis", !"Baggage", !"Dozer", !"Maverick", !"News Chopper", !"Rancher",
	!"FBI Rancher", !"Virgo", !"Greenwood", !"Jetmax", !"Hotring", !"Sandking", !"Blista Compact", !"Police Maverick", !"Boxville", !"Benson", !"Mesa", !"RC Goblin", !"Hotring Racer A", !"Hotring Racer B", !"Bloodring Banger",
	!"Lure Rancher", !"Super GT", !"Elegant", !"Journey", !"Bike", !"Mountain Bike", !"Beagle", !"Cropdust", !"Stuntplane", !"Petrol Trailer", !"Roadtrain", !"Nebula", !"Majestic", !"Buccaneer", !"Shamal",
	!"Hydra", !"FCR-900", !"NRG-500", !"HPV1000", !"Cement Truck", !"Tow Truck", !"Fortune", !"Cadrona", !"FBI Truck", !"Willard", !"Forklift", !"Tractor", !"Combine", !"Feltzer", !"Remington",
	!"Slamvan", !"Blade", !"Freight", !"Brown Streak", !"Vortex", !"Vincent", !"Bullet", !"Clover", !"Sadler", !"Firetruck LA", !"Hustler", !"Intruder", !"Primo", !"Cargobob", !"Tampa", !"Sunrise",
	!"Merit", !"Utility", !"Nevada", !"Yosemite", !"Windsor", !"Monster A", !"Monster B", !"Uranus", !"Jester", !"Sultan", !"Stratum", !"Elegy", !"Raindance", !"RC Tiger", !"Flash", !"Tahoma", !"Savanna",
	!"Bandito", !"Freight Flat", !"Brown Streak Carriage", !"Kart", !"Mower", !"Duneride", !"Sweeper", !"Broadway", !"Tornado", !"AT-400", !"DFT-30", !"Huntley", !"Stafford", !"BF-400", !"Newsvan",
	!"Tug", !"Petrol Trailer", !"Emperor", !"Wayfarer", !"Euros", !"Hotdog", !"Club", !"Freight Carriage", !"Closed Trailer B", !"Andromada", !"Dodo", !"RC Cam", !"Launch", !"LSPD Police", !"SFPD Police",
	!"LVPD Police", !"Police Ranger", !"Picador", !"S.W.A.T. Van", !"Alpha", !"Phoenix", !"Ghost Glendale", !"Ghost Sadler", !"Baggage Trailer A", !"Baggage Trailer B", !"Stairs Trailer", !"Black Boxville",
	!"Farm Plow", !"Utility Trailer"
};
new vehListStr[(sizeof(RaceVehicleList) + 1) * (MAX_VEHICLE_NAME + 2)];


public OnGameModeInit() return onScriptInit();
public OnFilterScriptInit() return onScriptInit();
public OnGameModeExit() return onScriptExit();
public OnFilterScriptExit() return onScriptExit();
new bool: scriptLoaded = false;

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stock onScriptInit()
{
	if (scriptLoaded == true) return 0;
	scriptLoaded = true;
	
	joinMenuExtra[0] = TextDrawCreate(MENU_X, MENU_Y, "_");
	TextDrawUseBox(joinMenuExtra[0], true);
	TextDrawLetterSize(joinMenuExtra[0], 1.0, 30.0);
	TextDrawBoxColor(joinMenuExtra[0], 0x77);
	TextDrawTextSize(joinMenuExtra[0], MENU_X + 540.0, MENU_Y + 255.0);

	joinMenuExtra[1] = TextDrawCreate(MENU_X + 150.0, MENU_Y + 10.0, "samaps:map");
	TextDrawFont(joinMenuExtra[1], 4);
	TextDrawTextSize(joinMenuExtra[1], 250.0, 250.0);
	
	joinMenuExtra[2] = TextDrawCreate(320.0, MENU_Y - 18.0, "Random Race Generator");
	TextDrawFont(joinMenuExtra[2], 0);
	TextDrawLetterSize(joinMenuExtra[2], 1.3, 3.5); // 1.0, 2.75
	TextDrawSetOutline(joinMenuExtra[2], 2);
	TextDrawAlignment(joinMenuExtra[2], 2);
	
	joinMenuExtra[3] = TextDrawCreate(MENU_X + 410.0, MENU_Y + 19.0, \
		"Welcome to the...~n~Random Race Generator!~n~~n~"\
		"You can create or join a race by selecting one of the slots on the left.~n~~n~"\
		"Each race is randomly generated along the roads of San Andreas; no race is the same as the last one.~n~~n~"\
		"The map will show you the current race track of each slot and more information about each race will be shown in this box."\
		" ______________________________ Have fun!");
	TextDrawColor(joinMenuExtra[3], COL_MENU_REGULAR);
	TextDrawTextSize(joinMenuExtra[3], MENU_X + 530.0, 500.0);
	TextDrawLetterSize(joinMenuExtra[3], 0.25, 1.2);
	TextDrawSetOutline(joinMenuExtra[3], 1);
	
	joinMenuButtons[0] = TextDrawCreate(MENU_X + 10.0, MENU_Y + 245.0, " Create");
	joinMenuButtons[1] = TextDrawCreate(MENU_X + 10.0, MENU_Y + 245.0, " Join");
	joinMenuButtons[2] = TextDrawCreate(MENU_X + 80.0, MENU_Y + 245.0, " Close");
	
	for (new b; b != sizeof(joinMenuButtons); b++)
	{
		TextDrawColor(joinMenuButtons[b], COL_MENU_REGULAR);
		TextDrawLetterSize(joinMenuButtons[b], 0.4, 1.5);
		TextDrawSetOutline(joinMenuButtons[b], 1);
		TextDrawUseBox(joinMenuButtons[b], true);
		TextDrawBoxColor(joinMenuButtons[b], 0x55);
		if (b == 2)
		{
			TextDrawTextSize(joinMenuButtons[b], MENU_X + 140.0, 12.0);
		}
		else
		{
			TextDrawTextSize(joinMenuButtons[b], MENU_X + 70.0, 12.0);
		}
		TextDrawSetSelectable(joinMenuButtons[b], true);
	}

	for (new s; s != MAX_RACES; s++)
	{
		joinMenuSlots[s] = TextDrawCreate(MENU_X + 10.0, MENU_Y + 19.0 + float(s * 15), "<Empty> Create a race!");
		TextDrawColor(joinMenuSlots[s], COL_MENU_REGULAR);
		TextDrawLetterSize(joinMenuSlots[s], 0.25, 1.2);
		TextDrawSetOutline(joinMenuSlots[s], 1);
		TextDrawTextSize(joinMenuSlots[s], MENU_X + 155.0, 12.0);
		TextDrawSetSelectable(joinMenuSlots[s], true);
		
		for (new i; i != MAX_TEXTDRAW_ICONS; i++)
		{
			raceMapIcons[s][i] = Text: INVALID_TEXT_DRAW;		
		}
		
		joinMenuRaceInfo[s][0] = TextDrawCreate(MENU_X + 390.0, MENU_Y - 5.0, "_"); // Vehicle model
		TextDrawFont(joinMenuRaceInfo[s][0], TEXT_DRAW_FONT_MODEL_PREVIEW);
		TextDrawUseBox(joinMenuRaceInfo[s][0], 1);
		TextDrawBackgroundColor(joinMenuRaceInfo[s][0], 0);
		TextDrawTextSize(joinMenuRaceInfo[s][0], 170.0, 130.0);
		TextDrawSetOutline(joinMenuRaceInfo[s][0], 2);
		TextDrawSetPreviewVehCol(joinMenuRaceInfo[s][0], RACE_VEHICLE_COL1, RACE_VEHICLE_COL2);
		TextDrawSetPreviewRot(joinMenuRaceInfo[s][0], 345.0, 0.0, 325.0, 1.0);
		
		joinMenuRaceInfo[s][1] = TextDrawCreate(MENU_X + 410.0, MENU_Y + 95.0, "_"); // Race stats
		TextDrawColor(joinMenuRaceInfo[s][1], COL_MENU_REGULAR);
		TextDrawLetterSize(joinMenuRaceInfo[s][1], 0.25, 1.2);
		TextDrawSetOutline(joinMenuRaceInfo[s][1], 1);
		
		joinMenuRaceInfo[s][2] = TextDrawCreate(MENU_X + 410.0, MENU_Y + 150.0, "_"); // Contestants list
		TextDrawColor(joinMenuRaceInfo[s][2], COL_MENU_REGULAR);
		TextDrawLetterSize(joinMenuRaceInfo[s][2], 0.25, 1.2);
		TextDrawSetOutline(joinMenuRaceInfo[s][2], 1);
	}
	
	/*for (new d; d != sizeof(nodeDisconnecterBuffer); d++)
	{
		nodeDisconnecterBuffer[d][0] = -1;
		nodeDisconnecterBuffer[d][1] = -1;
		nodeDisconnecterBuffer[d][2] = -1;
	}*/
	
	for (new v; v != sizeof(RaceVehicleList); v++)
	{
		strcat(vehListStr, VehicleNames[RaceVehicleList[v] - 400]);
		strcat(vehListStr, "\n");
	}	
	#if ALLOW_ALL_VEHICLES == true
	strcat(vehListStr, "Enter a specific model ID");
	#endif
	return 1;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stock onScriptExit()
{
	scriptLoaded = false;
	for (new b; b != sizeof(joinMenuButtons); b++)
	{
		TextDrawHideForAll(joinMenuButtons[b]);
		TextDrawDestroy(joinMenuButtons[b]);
	}
	for (new e; e != sizeof(joinMenuExtra); e++)
	{
		TextDrawHideForAll(joinMenuExtra[e]);
		TextDrawDestroy(joinMenuExtra[e]);
	}
	for (new s; s != MAX_RACES; s++)
	{
		cleanRace(s);
		TextDrawHideForAll(joinMenuSlots[s]);
		TextDrawDestroy(joinMenuSlots[s]);
		
		for (new r; r != sizeof(joinMenuRaceInfo[]); r++)
		{
			TextDrawHideForAll(joinMenuRaceInfo[s][r]);
			TextDrawDestroy(joinMenuRaceInfo[s][r]);
		}
		
		for (new i; i != MAX_TEXTDRAW_ICONS; i++)
		{
			if (raceMapIcons[s][i] != Text: INVALID_TEXT_DRAW)
			{
				TextDrawHideForAll(raceMapIcons[s][i]);
				TextDrawDestroy(raceMapIcons[s][i]);
				raceMapIcons[s][i] = Text: INVALID_TEXT_DRAW;
			}
		}
	}
	for (new p, m = GetMaxPlayers(); p != m; p++)
	{
		removeText(p);
		DeletePVar(p, PVAR_TAG"exitVehTimer");
	}
	return 1;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

public OnPlayerSpawn(playerid)
{
	new race = GetPVarInt(playerid, PVAR_TAG"currentRaceID");
	if (race)
	{
		race -= 2;
		if (raceOwners[race] != INVALID_PLAYER_ID)
		{
			respawnPlayer(playerid, race);
		}
	}
	return 1;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

public OnPlayerDisconnect(playerid, reason)
{
	#if REMEMBER_OLD_POSITION == true
	removePlayerFromRace(playerid, false);
	#else
	removePlayerFromRace(playerid);
	#endif
	return 1;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

public OnVehicleDeath(vehicleid, killerid)
{
	for (new p, mp = GetMaxPlayers(); p != mp; p++)
	{
		if (IsPlayerConnected(p) && !IsPlayerNPC(p))
		{
			new race = GetPVarInt(p, PVAR_TAG"currentRaceID");
			if (race)
			{
				race -= 2;
				if (raceOwners[race] != INVALID_PLAYER_ID)
				{
					if (GetPVarInt(p, PVAR_TAG"currentVehID") == vehicleid)
					{
						new Float: health;
						GetPlayerHealth(p, health);
						if (health > 0)
						{
							respawnPlayer(p, race);
						}
						break;
					}
				}
			}
		}
	}
	return 1;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (!strcmp(cmdtext, "/joinrace", true))
	{
		showJoinMenu(playerid);
		return 1;
	}
	
	if (!strcmp(cmdtext, "/startrace", true))
	{
		new race = GetPVarInt(playerid, PVAR_TAG"currentRaceID");
		if (race && raceOwners[race - 2] == playerid)
		{
			startRace(race - 2);
		}
		else
		{
			if (race)
			{
				SendClientMessage(playerid, COL_TEXT_ERROR, " [!] ERROR: You have not created this race.");
			}
			else
			{
				SendClientMessage(playerid, COL_TEXT_ERROR, " [!] ERROR: You have not created a race yet.");
			}
		}
		return 1;
	}
	
	if (!strcmp(cmdtext, "/leaverace", true))
	{
		new race = GetPVarInt(playerid, PVAR_TAG"currentRaceID");
		if (race && raceOwners[race - 2] == playerid)
		{
			SendClientMessage(playerid, COL_TEXT_REG, " [!] NOTE: You have called the race off.");
		}
		else
		{
			if (race)
			{
				SendClientMessage(playerid, COL_TEXT_REG, " [!] NOTE: You have left the race.");
			}
			else
			{
				return SendClientMessage(playerid, COL_TEXT_ERROR, " [!] ERROR: You are currently not in a race.");
			}
		}
		removePlayerFromRace(playerid);
		return 1;
	}
	
	if (!strcmp(cmdtext, "/respawninrace", true))
	{
		new race = GetPVarInt(playerid, PVAR_TAG"currentRaceID");
		if (race)
		{
			race -= 2;
			if (raceStarted{race} == false)
			{
				return SendClientMessage(playerid, COL_TEXT_ERROR, " [!] ERROR: You can't respawn right now! The race hasn't started yet.");
			}
			new cp = GetPVarInt(playerid, PVAR_TAG"currentCPID");
			if (!raceCheckpointList[race][cp][0] && !raceCheckpointList[race][cp][1] && !raceCheckpointList[race][cp][2])
			{
				return SendClientMessage(playerid, COL_TEXT_ERROR, " [!] ERROR: You can't respawn anymore! You have already finished.");
			}
			respawnPlayer(playerid, race);
		}
		else
		{
			SendClientMessage(playerid, COL_TEXT_ERROR, " [!] ERROR: You are not om a race right now!");
		}
		return 1;	
	}
	return 0;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	new menuopen = GetPVarInt(playerid, PVAR_TAG"joinMenuOpen");
	if (menuopen)
	{
		menuopen -= 2;
		if (clickedid == Text: INVALID_TEXT_DRAW || clickedid == Text: joinMenuButtons[2])
		{
			hideJoinMenu(playerid);	
			return 1;
		}
		if (clickedid == Text: joinMenuButtons[0] && raceOwners[menuopen] == INVALID_PLAYER_ID)
		{
			CancelSelectTextDraw(playerid);
			createRace(playerid, menuopen);
			return 1;
		}
		if (clickedid == Text: joinMenuButtons[1] && raceOwners[menuopen] != INVALID_PLAYER_ID)
		{
			CancelSelectTextDraw(playerid);
			joinRace(playerid, menuopen);
			return 1;
		}
		
		
		for (new i; i != MAX_RACES; i++)
		{
			if (clickedid == joinMenuSlots[i])
			{
				SetPVarInt(playerid, PVAR_TAG"joinMenuOpen", i + 2);
				TextDrawColor(joinMenuSlots[i], COL_MENU_SELECTED);
				TextDrawShowForPlayer(playerid, joinMenuSlots[i]);
				
				if (raceOwners[i] == INVALID_PLAYER_ID)
				{
					TextDrawShowForPlayer(playerid, joinMenuButtons[0]);
					TextDrawHideForPlayer(playerid, joinMenuButtons[1]);
					TextDrawShowForPlayer(playerid, joinMenuExtra[3]);
				}
				else
				{
					TextDrawHideForPlayer(playerid, joinMenuButtons[0]);
					TextDrawShowForPlayer(playerid, joinMenuButtons[1]);
					TextDrawHideForPlayer(playerid, joinMenuExtra[3]);
					for (new t; t != sizeof(joinMenuRaceInfo[]); t++)
					{
						TextDrawShowForPlayer(playerid, joinMenuRaceInfo[i][t]);
					}	
					
					for (new c; c != MAX_TEXTDRAW_ICONS; c++)
					{
						if (raceMapIcons[i][c] != Text: INVALID_TEXT_DRAW)
						{
							TextDrawShowForPlayer(playerid, raceMapIcons[i][c]);
						}
					}
				}
			}
			else
			{
				if (raceStarted{i} == true)
				{
					TextDrawColor(joinMenuSlots[i], COL_MENU_STARTED);
				}
				else
				{
					TextDrawColor(joinMenuSlots[i], COL_MENU_REGULAR);
				}
				TextDrawShowForPlayer(playerid, joinMenuSlots[i]);
				
				for (new t; t != sizeof(joinMenuRaceInfo[]); t++)
				{
					TextDrawHideForPlayer(playerid, joinMenuRaceInfo[i][t]);
				}
				
				for (new c; c != MAX_TEXTDRAW_ICONS; c++)
				{
					if (raceMapIcons[i][c] != Text: INVALID_TEXT_DRAW)
					{
						TextDrawHideForPlayer(playerid, raceMapIcons[i][c]);
					}
				}
			}
		}
	}
	return 0;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch (dialogid)
	{
		case DIALOG_OFFSET: // Choose a length
		{
			if (!response) 
			{
				DeletePVar(playerid, PVAR_TAG"closestNode");
				DeletePVar(playerid, PVAR_TAG"currentRaceID");
				DeletePVar(playerid, PVAR_TAG"selectedVehicle");
				return 1;
			}
			new closestNode = GetPVarInt(playerid, PVAR_TAG"closestNode");
			if (closestNode == -1)
			{
				SendClientMessage(playerid, COL_TEXT_ERROR, " [!] ERROR: An error occured during the calculation. (Reference ID: 001) The race has been reset.");
				DeletePVar(playerid, PVAR_TAG"closestNode");
				DeletePVar(playerid, PVAR_TAG"currentRaceID");
				DeletePVar(playerid, PVAR_TAG"selectedVehicle");
				return 1;
			}
			
			new value = strval(inputtext);
			if (MIN_RACE_DISTANCE > value || value > MAX_RACE_DISTANCE)
			{
				return ShowPlayerDialog(playerid, DIALOG_OFFSET, 1, "Maximum length", "Please input the maximum length of the race in meters.\n\nERROR: The number must be between "#MIN_RACE_DISTANCE" and "#MAX_RACE_DISTANCE"!", "Generate", "Cancel");		
			}
			
			new slot = GetPVarInt(playerid, PVAR_TAG"currentRaceID");
			if (slot)
			{
				if (raceOwners[slot - 2] != INVALID_PLAYER_ID)
				{
					new freeRace = -1;
					for (new r; r != MAX_RACES; r++)
					{
						if (raceOwners[r] == INVALID_PLAYER_ID)
						{
							freeRace = r;
							break;
						}			
					}
					if (freeRace == -1)
					{
						SendClientMessage(playerid, COL_TEXT_ERROR, " [!] ERROR: It's not possible to create more races at the moment!");
						DeletePVar(playerid, PVAR_TAG"closestNode");
						DeletePVar(playerid, PVAR_TAG"currentRaceID");
						DeletePVar(playerid, PVAR_TAG"selectedVehicle");
						return 1;
					}
					slot = freeRace + 2;
					SetPVarInt(playerid, PVAR_TAG"currentRaceID", slot);
				}
			}
			else
			{
				SendClientMessage(playerid, COL_TEXT_ERROR, " [!] ERROR: An error occured during the calculation. (Reference ID: 003) The race has been reset.");
				DeletePVar(playerid, PVAR_TAG"closestNode");
				DeletePVar(playerid, PVAR_TAG"currentRaceID");
				DeletePVar(playerid, PVAR_TAG"selectedVehicle");
				return 1;
			}
			
			SetPVarFloat(playerid, PVAR_TAG"totalRaceDistance", float(value));
			
			raceOwners[slot - 2] = playerid;
			new Float: curPos[3];
			GetNodePos(closestNode, curPos[0], curPos[1], curPos[2]);
			calculateNextRacePart(slot - 2, closestNode, -1, curPos[0], curPos[1], curPos[0], curPos[1]);
			
			//new anotherNode = NearestNodeFromPoint(float(random(6000) - 3000), float(random(6000) - 3000), 25.0, .IgnoreNodeID = closestNode);
			//CalculatePath(closestNode, anotherNode, slot - 2, .GrabNodePositions = true);
			return 1;
		}
		case DIALOG_OFFSET + 1: // Pick a vehicle (list)
		{
			if (!response) 
			{
				DeletePVar(playerid, PVAR_TAG"closestNode");
				DeletePVar(playerid, PVAR_TAG"currentRaceID");
				return 1;
			}
			
			#if ALLOW_ALL_VEHICLES == true
			if (listitem == sizeof(RaceVehicleList))
			{
				ShowPlayerDialog(playerid, DIALOG_OFFSET + 2, 1, "Vehicle model", "Please input a vehicle model ID ranging from 400 to 611.", "Pick", "Cancel");
				return 1;
			}
			#endif
			
			SetPVarInt(playerid, PVAR_TAG"selectedVehicle", RaceVehicleList[listitem]);		
			
			ShowPlayerDialog(playerid, DIALOG_OFFSET, 1, "Maximum length", "Please input the maximum length of the race in meters.", "Generate", "Cancel");
			return 1;
		}
		#if ALLOW_ALL_VEHICLES == true
		case DIALOG_OFFSET + 2: // Pick a vehicle (model id)
		{
			if (!response) 
			{
				DeletePVar(playerid, PVAR_TAG"closestNode");
				DeletePVar(playerid, PVAR_TAG"currentRaceID");
				return 1;
			}
			for (new c; inputtext[c] != EOS; c++)
			{
				switch (inputtext[c])
				{
					case '0' .. '9', ' ', '\0': continue;
					default:
					{
						ShowPlayerDialog(playerid, DIALOG_OFFSET + 2, 1, "Vehicle model", "Please input a vehicle model ID ranging from 400 to 611.\n\nERROR: This input is not a valid vehicle model ID.", "Pick", "Cancel");
						return 1;
					}
				}
			}
			new model = strval(inputtext);
			if (400 <= model <= 611)
			{	
				new str[128], vname[MAX_VEHICLE_NAME];
				strunpack(vname, VehicleNames[model - 400]);
				format(str, sizeof(str), " [!] NOTE: You have picked the %s!", vname);
				SendClientMessage(playerid, COL_TEXT_REG, str);
				SetPVarInt(playerid, PVAR_TAG"selectedVehicle", model);
				
				ShowPlayerDialog(playerid, DIALOG_OFFSET, 1, "Maximum length", "Please input the maximum length of the race in meters.", "Generate", "Cancel");
			}
			else
			{
				ShowPlayerDialog(playerid, DIALOG_OFFSET + 2, 1, "Vehicle model", "Please input a vehicle model ID ranging from 400 to 611.\n\nERROR: This input is not a valid vehicle model ID.", "Pick", "Cancel");
			}			
			return 1;
		}
		#endif
	}
	return 0;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

public GPS_WhenRouteIsCalculated(routeid, node_id_array[], amount_of_nodes, Float:distance, Float:Polygon[], Polygon_Size, Float:NodePosX[], Float:NodePosY[], Float:NodePosZ[])
{
	if (0 <= routeid < MAX_RACES && raceOwners[routeid] != INVALID_PLAYER_ID)
	{
		new playerid = raceOwners[routeid];
		if (!amount_of_nodes || distance == -1) 
		{
			SendClientMessage(playerid, COL_TEXT_ERROR, " [!] ERROR: An error occured during the calculation. (Reference ID: 004) The race has been reset.");
			return cleanRace(routeid);
		}
		
		new lastIntersection, Float: distIntersection, curCPSlot = getFirstEmptyCPSlot(routeid), Float: maxDistance = GetPVarFloat(playerid, PVAR_TAG"totalRaceDistance"), i = 1, lastNode, beforeLastNode;
		
		if (curCPSlot == 0)
		{
			raceCheckpointList[routeid][0][0] = NodePosX[0];
			raceCheckpointList[routeid][0][1] = NodePosY[0];
			raceCheckpointList[routeid][0][2] = NodePosZ[0];
			raceCheckpointList[routeid][1][0] = NodePosX[1];
			raceCheckpointList[routeid][1][1] = NodePosY[1];
			raceCheckpointList[routeid][1][2] = NodePosZ[1];
			
			curCPSlot += 2;
		}
		for (; i != amount_of_nodes; i++)
		{
			distIntersection += GetDistanceBetweenNodes(node_id_array[i - 1], node_id_array[i]);
			
			if (IsNodeIntersection(node_id_array[i]) == 1)
			{
				if (distIntersection > MINIMAL_DISTANCE_CP * 0.333)
				{
					new Float: averageDist = distIntersection / float(floatround(distIntersection / MINIMAL_DISTANCE_CP, floatround_floor)), Float: curDist, bool: limitreached;
					
					for(new n = lastIntersection + 1; n != i; n++) // add all nodes between last and current intersection
					{
						curDist += GetDistanceBetweenNodes(node_id_array[n - 1], node_id_array[n]);
						
						if (curDist >= averageDist)
						{
							raceCheckpointList[routeid][curCPSlot][0] = NodePosX[n];
							raceCheckpointList[routeid][curCPSlot][1] = NodePosY[n];
							raceCheckpointList[routeid][curCPSlot][2] = NodePosZ[n];
							curCPSlot++;
							
							raceDistance[routeid] += curDist;
							curDist = 0.0;
							
							if (curCPSlot == MAX_CHECKPOINTS || raceDistance[routeid] >= maxDistance) // limit reached
							{
								limitreached = true;
								break;
							}
						}
					}
					
					if (limitreached == false) // add current intersection
					{
						raceCheckpointList[routeid][curCPSlot][0] = NodePosX[i];
						raceCheckpointList[routeid][curCPSlot][1] = NodePosY[i];
						raceCheckpointList[routeid][curCPSlot][2] = NodePosZ[i];
						curCPSlot++;
						beforeLastNode = node_id_array[i - 1];
						lastNode = node_id_array[i];
				
						lastIntersection = i;
						distIntersection = 0.0;
					}
									
					if (curCPSlot == MAX_CHECKPOINTS || raceDistance[routeid] >= maxDistance) // race creation finishing touch
					{
						/*for (new d; d != sizeof(nodeDisconnecterBuffer); d++)
						{
							if (nodeDisconnecterBuffer[d][0] == routeid)
							{
								ConnectNodes(nodeDisconnecterBuffer[d][1], nodeDisconnecterBuffer[d][2], true, nodeDisconnecterBuffer[d][3]);
								nodeDisconnecterBuffer[d][0] = -1;
								nodeDisconnecterBuffer[d][1] = -1;
								nodeDisconnecterBuffer[d][2] = -1;
								nodeDisconnecterBuffer[d][3] = -1;
							}
						}*/
	
						new str[48], pName[MAX_PLAYER_NAME], len;
						len = GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
						switch (pName[len - 1])
						{
							case 's', 'z', 'S', 'Z': format(str, sizeof(str), "%s' race (%.1fm)", pName, raceDistance[routeid]);
							default: format(str, sizeof(str), "%s's race (%.1fm)", pName, raceDistance[routeid]);
						}
						TextDrawSetString(joinMenuSlots[routeid], str);
						
						new interval = (curCPSlot >= MAX_TEXTDRAW_ICONS) ? floatround(float(curCPSlot - 1) / float(MAX_TEXTDRAW_ICONS), floatround_ceil) : 1;
						
						for (new c = 1, cp = 2; cp < curCPSlot && cp <= MAX_CHECKPOINTS && c != MAX_TEXTDRAW_ICONS - 2; cp += interval)
						{
							if ((!raceCheckpointList[routeid][cp][0] && !raceCheckpointList[routeid][cp][1])) continue;
							
							raceMapIcons[routeid][c] = TextDrawCreate(MENU_X + 148.0 + ((raceCheckpointList[routeid][cp][0] + 3000.0) / 6000.0) * 250.0, MENU_Y + 257.0 - ((raceCheckpointList[routeid][cp][1] + 3000.0) / 6000.0) * 250.0, "hud:radar_light");
							TextDrawFont(raceMapIcons[routeid][c], 4);
							TextDrawTextSize(raceMapIcons[routeid][c], 6.0, 6.0);
							c++;
						}
						
						raceMapIcons[routeid][0] = TextDrawCreate(MENU_X + 148.0 + ((raceCheckpointList[routeid][0][0] + 3000.0) / 6000.0) * 250.0, MENU_Y + 255.0 - ((raceCheckpointList[routeid][0][1] + 3000.0) / 6000.0) * 250.0, "hud:radar_impound");
						raceMapIcons[routeid][MAX_TEXTDRAW_ICONS - 1] = TextDrawCreate(MENU_X + 148.0 + ((raceCheckpointList[routeid][curCPSlot - 1][0] + 3000.0) / 6000.0) * 250.0, MENU_Y + 255.0 - ((raceCheckpointList[routeid][curCPSlot - 1][1] + 3000.0) / 6000.0) * 250.0, "hud:radar_Flag");

						TextDrawFont(raceMapIcons[routeid][0], 4);
						TextDrawTextSize(raceMapIcons[routeid][0], 10.0, 10.0);
						TextDrawFont(raceMapIcons[routeid][MAX_TEXTDRAW_ICONS - 1], 4);
						TextDrawTextSize(raceMapIcons[routeid][MAX_TEXTDRAW_ICONS - 1], 10.0, 10.0);
						
						raceVehicleModel[routeid] = GetPVarInt(playerid, PVAR_TAG"selectedVehicle");
						DeletePVar(playerid, PVAR_TAG"selectedVehicle");
						TextDrawSetPreviewModel(joinMenuRaceInfo[routeid][0], raceVehicleModel[routeid]);
						
						new text[128];
						strunpack(str, VehicleNames[raceVehicleModel[routeid] - 400]);
						
						format(text, sizeof(text), "~r~Vehicle: ~w~%s~n~~r~Length: ~w~%.1f meters~n~~r~Checkpoints: ~w~%i~n~~r~Host: ~w~%s", str, raceDistance[routeid], curCPSlot, pName);
						TextDrawSetString(joinMenuRaceInfo[routeid][1], text);
						
						spawnInRace(raceOwners[routeid], routeid, 0);
						updateContestantList(routeid);
						DeletePVar(playerid, PVAR_TAG"createRouteTick");
						
						format(text, sizeof(text), " [!] NOTE: %s has started a new race with a length of %.1f meters! Use /joinrace to join this race.", pName, raceDistance[routeid]);
						SendClientMessageToAll(COL_TEXT_REG, text);
						SendClientMessage(playerid, COL_TEXT_REG, " [!] NOTE: You can use /startrace to start the countdown or /leaverace to call the race off.");
						return 1;
					}
				}
			}
		}
		/*if (raceDistance[routeid] < maxDistance)
		{
			for (new d; d != sizeof(nodeDisconnecterBuffer); d++)
			{
				if (nodeDisconnecterBuffer[d][0] == -1)
				{
					nodeDisconnecterBuffer[d][0] = routeid;
					nodeDisconnecterBuffer[d][1] = beforeLastNode;
					nodeDisconnecterBuffer[d][2] = lastNode;
					nodeDisconnecterBuffer[d][3] = GetNodeDirectionToConnect(beforeLastNode, lastNode);
					printf("nodes: %i & %i", beforeLastNode, lastNode);
					printf("check 1: %i", IsNodeConnectedToNode(lastNode, beforeLastNode));
					printf("check 2: %i", IsNodeConnectedToNode(beforeLastNode, lastNode));
					printf("disconnected: %i", DisconnectNodeFromNode(beforeLastNode, lastNode));
					printf("check 3: %i", IsNodeConnectedToNode(beforeLastNode, lastNode));
					break;
				}
			}
		}*/
		
		new lastsec = GetPVarInt(playerid, PVAR_TAG"createRouteTick"), cursec = gettime();
		if (lastsec + 1 < cursec)
		{
			if (lastsec != 0)
			{
				new text[128];
				format(text, sizeof(text), " [!] NOTE: Calculating race... %i per cent done!", floatround(100.0 * raceDistance[routeid] / maxDistance));
				SendClientMessage(raceOwners[routeid], COL_TEXT_REG, text);
			}
			SetPVarInt(playerid, PVAR_TAG"createRouteTick", cursec);
		}
			
		calculateNextRacePart(routeid, lastNode, beforeLastNode, NodePosX[0], NodePosY[0], raceCheckpointList[routeid][curCPSlot - 1][0], raceCheckpointList[routeid][curCPSlot - 1][1]);
	}
	return 1;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*stock IsNodeConnectedToNode(node1, node2)
{
	for (new i; i != MAX_CONNECTIONS; i++)
	{
		if (GetConnectedNodeID(node1, i) == node2)
		{
			return i;
		}
	}
	return -1;
}*/

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stock Float:GetAngleToPos(Float: PX, Float: PY, Float:X, Float:Y)
{
	new Float:Angle = floatabs(atan((Y-PY)/(X-PX)));
	Angle = (X<=PX && Y>=PY) ? floatsub(180.0, Angle) : (X<PX && Y<PY) ? floatadd(Angle, 180.0) : (X>=PX && Y<=PY) ? floatsub(360.0, Angle) : Angle;
	Angle = floatsub(Angle, 90.0);
	Angle = (Angle >= 360.0) ? floatsub(Angle, 360.0) : Angle;
	Angle = (Angle <= 0.0) ? floatadd(Angle, 360.0) : Angle;
	return Angle;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stock calculateNextRacePart(routeid, lastNode, beforeLastNode, Float: lastStartX, Float: lastStartY, Float: lastEndX, Float: lastEndY)
{
	new Float: newpos[2];
	if (beforeLastNode == -1)
	{
		newpos[0] = float((random(6000) - 3000));
		newpos[1] = float((random(6000) - 3000));
	}
	else
	{
		new startcorner, endcorner, calX, calY;
		startcorner = (lastStartX >= 0 && lastStartY >= 0) ? 1 : (lastStartX >= 0 && lastStartY < 0) ? 2 : (lastStartX < 0 && lastStartY < 0) ? 3 : 4;
		endcorner = (lastEndX >= 0 && lastEndY >= 0) ? 1 : (lastEndX >= 0 && lastEndY < 0) ? 2 : (lastEndX < 0 && lastEndY < 0) ? 3 : 4;
		
		if (startcorner == endcorner)
		{
			if (random(2))
			{
				startcorner++;
			}
			else
			{
				startcorner--;
			}
			startcorner = (startcorner < 1) ? 4 : (startcorner > 4) ? 1 : startcorner;
		}
		if (startcorner + 1 == endcorner || (startcorner == 4 && endcorner == 1))
		{
			switch (endcorner)
			{
				case 1: calX = 1, calY = -1;
				case 2: calX = -1, calY = -1;
				case 3: calX = -1, calY = 1;
				case 4: calX = 1, calY = 1;
			}
		}
		else 
		{
			switch (endcorner)
			{
				case 1: calX = -1, calY = 1;
				case 2: calX = 1, calY = 1;
				case 3: calX = 1, calY = -1;
				case 4: calX = -1, calY = -1;
			}
		}

		newpos[0] = float((random(3000) + 1) * calX);
		newpos[1] = float((random(3000) + 1) * calY);
	}
	
	new newNode = NearestNodeFromPoint(newpos[0], newpos[1], 25.0, .IgnoreNodeID = lastNode);
	if (newNode == -1)
	{
		SendClientMessage(raceOwners[routeid], COL_TEXT_ERROR, " [!] ERROR: An error occured during the calculation. (Reference ID: 002)  The race has been reset.");
		cleanRace(routeid);
		return 1;
	}
	CalculatePath(lastNode, newNode, routeid, .GrabNodePositions = true);
	return 1;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stock createRace(playerid, slot)
{
	for (new r; r != MAX_RACES; r++)
	{
		if (raceOwners[r] == playerid)
		{
			return SendClientMessage(playerid, COL_TEXT_ERROR, " [!] ERROR: You have already started a race!");
		}
	}
	
	new oldrace = GetPVarInt(playerid, PVAR_TAG"currentRaceID");
	if (oldrace)
	{
		return SendClientMessage(playerid, COL_TEXT_ERROR, " [!] ERROR: You are already in a race! Use /leaverace to leave that race.");
	}
	
	new closestNode = NearestPlayerNode(playerid, 50.0, 1);
	if (closestNode == -1)
	{
		return SendClientMessage(playerid, COL_TEXT_ERROR, " [!] ERROR: You need to move closer to a road!");
	}
	SetPVarInt(playerid, PVAR_TAG"closestNode", closestNode);
	SetPVarInt(playerid, PVAR_TAG"currentRaceID", slot + 2);
	
	ShowPlayerDialog(playerid, DIALOG_OFFSET + 1, 2, "Race Vehicle", vehListStr, "Select", "Cancel");
	return 1;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stock cleanRace(race, checkowner = false)
{
	new playerid = raceOwners[race];
	DeletePVar(playerid, PVAR_TAG"closestNode");
	DeletePVar(playerid, PVAR_TAG"totalRaceDistance");
	
	raceOwners[race] = INVALID_PLAYER_ID;
	raceDistance[race] = 0.0;
	raceFinishedPeople{race} = 0;
	raceVehicleModel[race] = 0;
	raceStarted{race} = false;
	if (raceEndTimers{race} >= 0)
	{
		KillTimer(raceEndTimers{race});
	}
	raceEndTimers{race} = -1;
	
	for (new c; c != MAX_CHECKPOINTS; c++)
	{
		raceCheckpointList[race][c][0] = 0.0;
		raceCheckpointList[race][c][1] = 0.0;
		raceCheckpointList[race][c][2] = 0.0;
	}
	/*for (new d; d != sizeof(nodeDisconnecterBuffer); d++)
	{
		if (nodeDisconnecterBuffer[d][0] == race)
		{
			ConnectNodes(nodeDisconnecterBuffer[d][1], nodeDisconnecterBuffer[d][2], true, nodeDisconnecterBuffer[d][3]);
			nodeDisconnecterBuffer[d][0] = -1;
			nodeDisconnecterBuffer[d][1] = -1;
			nodeDisconnecterBuffer[d][2] = -1;
			nodeDisconnecterBuffer[d][3] = -1;
		}
	}*/
	for (new i; i != MAX_TEXTDRAW_ICONS; i++)
	{
		TextDrawHideForAll(raceMapIcons[race][i]);
		TextDrawDestroy(raceMapIcons[race][i]);
		raceMapIcons[race][i] = Text: INVALID_TEXT_DRAW;
	}
	
	TextDrawSetString(joinMenuRaceInfo[race][1], "_");
	TextDrawSetString(joinMenuRaceInfo[race][2], "_");
	
	for (new p, mp = GetMaxPlayers(); p != mp; p++)
	{
		if (IsPlayerConnected(p) && !IsPlayerNPC(p))
		{
			new pRace = GetPVarInt(p, PVAR_TAG"currentRaceID");
			if (pRace && pRace - 2 == race)
			{
				if (!checkowner || (checkowner && p != playerid))
				{
					removePlayerFromRace(p);
				}
			}
		}
	}
	
	TextDrawSetString(joinMenuSlots[race], "<Empty> Create a race!");
	return 1;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#if REMEMBER_OLD_POSITION == true
stock removePlayerFromRace(playerid, bool: oldspawn = true)
#else
stock removePlayerFromRace(playerid)
#endif
{
	new veh = GetPVarInt(playerid, PVAR_TAG"currentVehID");
	DestroyVehicle(veh);
	DeletePVar(playerid, PVAR_TAG"currentVehID");
	DisablePlayerRaceCheckpoint(playerid);
	DeletePVar(playerid, PVAR_TAG"currentCPID");
	new timer = GetPVarInt(playerid, PVAR_TAG"respawnTimer");
	if (timer)
	{
		KillTimer(timer);
	}
	DeletePVar(playerid, PVAR_TAG"respawnTimer");
	
	for (new ci, icon = SUGGESTED_MAPICONS_OFFSET; ci != MAX_SUGGESTED_MAPICONS; ci++, icon++)
	{
		RemovePlayerMapIcon(playerid, icon);
	}
	
	#if REMEMBER_OLD_POSITION == true
	if (oldspawn == true)
	{
		new Float: oldpos[4], oldint;
		oldpos[0] = GetPVarFloat(playerid, PVAR_TAG"oldX");
		oldpos[1] = GetPVarFloat(playerid, PVAR_TAG"oldY");
		oldpos[2] = GetPVarFloat(playerid, PVAR_TAG"oldZ");
		oldpos[3] = GetPVarFloat(playerid, PVAR_TAG"oldR");
		oldint = GetPVarInt(playerid, PVAR_TAG"oldInt");
		SetPlayerPos(playerid, oldpos[0], oldpos[1], oldpos[2]);
		SetPlayerFacingAngle(playerid, oldpos[3]);
		SetPlayerInterior(playerid, oldint);
	}
	DeletePVar(playerid, PVAR_TAG"oldX");
	DeletePVar(playerid, PVAR_TAG"oldY");
	DeletePVar(playerid, PVAR_TAG"oldZ");
	DeletePVar(playerid, PVAR_TAG"oldR");
	DeletePVar(playerid, PVAR_TAG"oldInt");
	#endif
	TogglePlayerControllable(playerid, true);
	
	new race = GetPVarInt(playerid, PVAR_TAG"currentRaceID");
	if (race)
	{
		race -= 2;
		
		new bool: updatelist = true;
		for (new r; r != MAX_RACES; r++)
		{
			if (raceOwners[r] == playerid)
			{
				cleanRace(r, true);
				if (r == race)
				{
					updatelist = false;
				}
			}
		}
		if (updatelist == true)
		{
			updateContestantList(race);
		}
	}
	DeletePVar(playerid, PVAR_TAG"currentRaceID");
	return 1;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stock showJoinMenu(playerid)
{
	SetPVarInt(playerid, PVAR_TAG"joinMenuOpen", 1);
	for (new e; e != sizeof(joinMenuExtra); e++)
	{
		TextDrawShowForPlayer(playerid, joinMenuExtra[e]);
	}
	for (new s; s != MAX_RACES; s++)
	{
		if (raceStarted{s} == true)
		{
			TextDrawColor(joinMenuSlots[s], COL_MENU_STARTED);
		}
		else
		{
			TextDrawColor(joinMenuSlots[s], COL_MENU_REGULAR);
		}
		TextDrawShowForPlayer(playerid, joinMenuSlots[s]);
	}
	TextDrawShowForPlayer(playerid, joinMenuButtons[2]);
	SelectTextDraw(playerid, COL_MENU_MOUSEOVER);
	
	for (new d; d != 5; d++)
	{
		SendDeathMessage(-1, MAX_PLAYERS, -1);
	}
	return 1;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stock hideJoinMenu(playerid)
{
	CancelSelectTextDraw(playerid);
	DeletePVar(playerid, PVAR_TAG"joinMenuOpen");
	for (new b; b != sizeof(joinMenuButtons); b++)
	{
		TextDrawHideForPlayer(playerid, joinMenuButtons[b]);
	}
	for (new e; e != sizeof(joinMenuExtra); e++)
	{
		TextDrawHideForPlayer(playerid, joinMenuExtra[e]);
	}
	for (new s; s != MAX_RACES; s++)
	{
		TextDrawHideForPlayer(playerid, joinMenuSlots[s]);
		
		for (new i; i != MAX_TEXTDRAW_ICONS; i++)
		{
			TextDrawHideForPlayer(playerid, raceMapIcons[s][i]);
		}
		for (new v; v != sizeof(joinMenuRaceInfo[]); v++)
		{
			TextDrawHideForPlayer(playerid, joinMenuRaceInfo[s][v]);
		}
	}
	return 1;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stock joinRace(playerid, race)
{
	new oldrace = GetPVarInt(playerid, PVAR_TAG"currentRaceID");
	if (oldrace)
	{
		if (oldrace - 2 == race)
		{
			return SendClientMessage(playerid, COL_TEXT_ERROR, " [!] ERROR: You are already in this race!");
		}
		else
		{
			return SendClientMessage(playerid, COL_TEXT_ERROR, " [!] ERROR: You are already in another race! Use /leaverace to leave that race.");
		}
	}
	
	for (new r; r != MAX_RACES; r++)
	{
		if (raceOwners[r] == playerid)
		{
			return SendClientMessage(playerid, COL_TEXT_ERROR, " [!] ERROR: You have already started another race! You can't join this one.");
		}
	}
	
	if (raceStarted{race} == true)
	{
		return SendClientMessage(playerid, COL_TEXT_ERROR, " [!] ERROR: This race has already started! You can't join anymore.");	
	}
	
	new currentcontestants;
	for (new p, mp = GetMaxPlayers(); p != mp; p++)
	{
		if (IsPlayerConnected(p) && !IsPlayerNPC(p))
		{
			new pRace = GetPVarInt(p, PVAR_TAG"currentRaceID");
			if (pRace && pRace - 2 == race)
			{
				currentcontestants++;
			}
		}
	}
	if (currentcontestants > MAX_CONTESTANTS)
	{
		SendClientMessage(playerid, COL_TEXT_ERROR, " [!] ERROR: You can't join this race anymore! There's no room.");
		return 1;
	}
	SetPVarInt(playerid, PVAR_TAG"currentRaceID", race + 2);
	spawnInRace(playerid, race, currentcontestants);
	updateContestantList(race);
	SendClientMessage(playerid, COL_TEXT_REG, " [!] NOTE: You can use /leaverace to leave this race.");
	return 1;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stock spawnInRace(playerid, race, spot = -1)
{
	#if REMEMBER_OLD_POSITION == true
	new Float: oldpos[4], oldint;
	GetPlayerPos(playerid, oldpos[0], oldpos[1], oldpos[2]);
	GetPlayerFacingAngle(playerid, oldpos[3]);
	oldint = GetPlayerInterior(playerid);
	SetPVarFloat(playerid, PVAR_TAG"oldX", oldpos[0]);
	SetPVarFloat(playerid, PVAR_TAG"oldY", oldpos[1]);
	SetPVarFloat(playerid, PVAR_TAG"oldZ", oldpos[2]);
	SetPVarFloat(playerid, PVAR_TAG"oldR", oldpos[3]);
	SetPVarInt(playerid, PVAR_TAG"oldInt", oldint);
	#endif
	
	if (spot == -1)
	{
		spot = 0;
		for (new p, mp = GetMaxPlayers(); p != mp; p++)
		{
			if (IsPlayerConnected(p) && !IsPlayerNPC(p))
			{
				new pRace = GetPVarInt(playerid, PVAR_TAG"currentRaceID");
				if (pRace && pRace - 2 == race)
				{
					spot++;
				}
			}
		}
	}
	
	new Float: spos[3], Float: size[3], Float: offset[2], Float: angle = GetAngleToPos(raceCheckpointList[race][0][0], raceCheckpointList[race][0][1], raceCheckpointList[race][1][0], raceCheckpointList[race][1][1]), Float: temp;
	GetVehicleModelInfo(raceVehicleModel[race], VEHICLE_MODEL_INFO_SIZE, size[0], size[1], size[2]);
	offset[0] = (spot & 1) ? (size[0] * 0.75) : -(size[0] * 0.75);
	offset[1] = -float((spot / 2) * floatround((size[1] * 1.2), floatround_ceil));
		
	// Thanks to Mauzen for offset calculation! ( http://forum.sa-mp.com/showthread.php?t=270427 )
	new Float: flSin = floatsin(-angle, degrees), Float: flCos = floatcos(-angle, degrees);
	spos[0] = flSin * offset[1] + flCos * offset[0] + raceCheckpointList[race][0][0];
	spos[1] = flCos * offset[1] - flSin * offset[0] + raceCheckpointList[race][0][1];
	GetNodePos(NearestNodeFromPoint(spos[0], spos[1], raceCheckpointList[race][0][2] + 1.5, 50.0, -1, 1), temp, temp, spos[2]);
	
	new veh = CreateVehicle(raceVehicleModel[race], spos[0], spos[1], spos[2] + 2.5, angle, RACE_VEHICLE_COL1, RACE_VEHICLE_COL2, 0);
	SetVehicleVirtualWorld(veh, RACE_VIRTUAL_WORLD);
	SetVehicleParamsEx(veh, true, false, false, false, false, false, false);
	
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, RACE_VIRTUAL_WORLD);
	PutPlayerInVehicle(playerid, veh, 0);
	TogglePlayerControllable(playerid, false);
	
	SetPVarInt(playerid, PVAR_TAG"currentVehID", veh);
	SetPVarInt(playerid, PVAR_TAG"currentCPID", 1);
	TextDrawShowForPlayer(playerid, joinMenuRaceInfo[race][2]);
	return 1;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stock startRace(race)
{
	SetTimerEx("countdownTimer", 1000, false, "ii", race, 3);
	return 1;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

forward countdownTimer(race, count);
public countdownTimer(race, count)
{
	new str[2];
	str[0] = '0' + count;

	for (new p, mp = GetMaxPlayers(); p != mp; p++)
	{
		if (IsPlayerConnected(p) && !IsPlayerNPC(p))
		{
			new pRace = GetPVarInt(p, PVAR_TAG"currentRaceID");
			if (pRace && pRace - 2 == race)
			{
				switch (count)
				{
					case 0:
					{
						GameTextForPlayer(p, "GO!", 1250, 3);
						TogglePlayerControllable(p, true);
						PlayerPlaySound(p, 1057, 0.0, 0.0, 0.0);
					}
					case 1, 2:
					{
						GameTextForPlayer(p, str, 1250, 3);
						TogglePlayerControllable(p, false);
						PlayerPlaySound(p, 1056, 0.0, 0.0, 0.0);
					}
					case 3:
					{
						GameTextForPlayer(p, str, 1250, 3);
						PlayerPlaySound(p, 1056, 0.0, 0.0, 0.0);
						TogglePlayerControllable(p, false);
						
						SetCameraBehindPlayer(p);
						setCheckpoint(p, pRace - 2, 2);
						SendClientMessage(p, COL_TEXT_REG, " [!] NOTE: If you get stuck, you can respawn at the last checkpoint by using /respawninrace.");
						TextDrawHideForPlayer(p, joinMenuRaceInfo[race][2]);
					}
				}
			}
		}
	}
	if (count) 
	{
		SetTimerEx("countdownTimer", 1000, false, "ii", race, count - 1);
	}
	else
	{
		raceStarted{race} = true;
	}
	return 1;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

public OnPlayerEnterRaceCheckpoint(playerid)
{
	new race = GetPVarInt(playerid, PVAR_TAG"currentRaceID");
	if (race && IsPlayerInVehicle(playerid, GetPVarInt(playerid, PVAR_TAG"currentVehID")))
	{
		race -= 2;
		new cp = GetPVarInt(playerid, PVAR_TAG"currentCPID") + 1;
		setCheckpoint(playerid, race, cp);
		PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
	}	
	return 1;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	for (new p, e = GetMaxPlayers(); p != e; p++)
	{
		if (!IsPlayerNPC(p) && IsPlayerConnected(p))
		{
			new race =  GetPVarInt(p, PVAR_TAG"currentRaceID"), veh = GetPVarInt(p, PVAR_TAG"currentVehID");
			if (race && veh == vehicleid)
			{
				SetVehicleParamsEx(veh, true, false, false, true, false, false, false);
				SetVehicleParamsForPlayer(veh, p, false, false);
				break;
			}
		}	
	}
	return 1;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#if VEHICLE_LEAVE_TIME != 0
public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_ONFOOT && oldstate == PLAYER_STATE_DRIVER) 
    {
		if (!GetPVarInt(playerid, PVAR_TAG"exitVehTimer"))
		{
			new race = GetPVarInt(playerid, PVAR_TAG"currentRaceID");
			if (!race) return 1;
			
			race -= 2;
			new cp = GetPVarInt(playerid, PVAR_TAG"currentCPID");
			if (!raceCheckpointList[race][cp][0] && !raceCheckpointList[race][cp][1] && !raceCheckpointList[race][cp][2]) return 1;
			
			new veh = GetPVarInt(playerid, PVAR_TAG"currentVehID");
			if (!veh) return 1;
			
			new Float: health;
			GetPlayerHealth(playerid, health);
			if (health <= 0) return 1;

			SetPVarInt(playerid, PVAR_TAG"exitVehTimer", VEHICLE_LEAVE_TIME + 1);
			CallLocalFunction("exitVehTimer", "i", playerid);
			SetVehicleParamsForPlayer(veh, playerid, false, false);
		}
	}
	return 1;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

forward exitVehTimer(playerid);
public exitVehTimer(playerid)
{
	if (!IsPlayerConnected(playerid)) return 0;
	
	new veh = GetPVarInt(playerid, PVAR_TAG"currentVehID");
	if (!(IsPlayerInVehicle(playerid, veh) && !GetPlayerVehicleSeat(playerid)))
	{
		new time = GetPVarInt(playerid, PVAR_TAG"exitVehTimer") - 1;
		if (time == 0)
		{
			SendClientMessage(playerid, COL_TEXT_REG, " [!] NOTE: You have been disqualified for leaving your vehicle.");
			removePlayerFromRace(playerid);
		}
		else
		{
			new str[128];
			if (time == 1)
			{
				format(str, sizeof(str), "~s~You have %i second to return to your ~y~vehicle ~s~before you are disqualified.", time);
			}
			else
			{
				format(str, sizeof(str), "~s~You have %i seconds to return to your ~y~vehicle ~s~before you are disqualified.", time);
			}
			showText(playerid, str, 1500);
			SetPVarInt(playerid, PVAR_TAG"exitVehTimer", time);
			SetTimerEx("exitVehTimer", 1000, false, "i", playerid);
			return 1;
		}
	}
	DeletePVar(playerid, PVAR_TAG"exitVehTimer");
	return 1;
}
#endif

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stock setCheckpoint(playerid, race, cp)
{
	if (cp == MAX_CHECKPOINTS || (!raceCheckpointList[race][cp][0] && !raceCheckpointList[race][cp][1] && !raceCheckpointList[race][cp][2]))
	{
		DisablePlayerRaceCheckpoint(playerid);
		raceFinishedPeople{race}++;
		
		new nmb[3];
		switch (raceFinishedPeople{race})
		{
			case 1: GameTextForPlayer(playerid, "1st place!", 3500, 3), nmb = "st";
			case 2: GameTextForPlayer(playerid, "2nd place!", 3500, 3), nmb = "nd";
			case 3: GameTextForPlayer(playerid, "3rd place!", 3500, 3), nmb = "rd";
			default:
			{
				new str[12];
				format(str, sizeof(str), "%ith place!", raceFinishedPeople{race});
				GameTextForPlayer(playerid, str, 3500, 3);
				nmb = "th";
			}
		}
		new text[128], pName[MAX_PLAYER_NAME], oName[MAX_PLAYER_NAME], len;
		GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
		len = GetPlayerName(raceOwners[race], oName, MAX_PLAYER_NAME);
		
		switch (oName[len - 1])
		{
			case 's', 'z': format(text, sizeof(text), " [!] FINISH: %s finished %i%s place in %s' race!", pName, raceFinishedPeople{race}, nmb, oName);
			default: format(text, sizeof(text), " [!] FINISH: %s finished %i%s place in %s's race!", pName, raceFinishedPeople{race}, nmb, oName);
		}
		SendClientMessageToAll(COL_TEXT_WIN, text);
		
		if (raceFinishedPeople{race} == 1)
		{
			raceEndTimers{race} = SetTimerEx("raceEndingTimer", 60000, false, "i", race);
			
			for (new p, mp = GetMaxPlayers(); p != mp; p++)
			{
				if (IsPlayerConnected(p) && !IsPlayerNPC(p))
				{
					new pRace = GetPVarInt(p, PVAR_TAG"currentRaceID");
					if (pRace && pRace - 2 == race)
					{
						SendClientMessage(p, COL_TEXT_REG, " [!] NOTE: The race will end in 60 seconds.");
					}
				}
			}
		}
		
		SendClientMessage(playerid, COL_TEXT_REG, " [!] NOTE: You can leave the race by using /leaverace or wait until the race ends.");
	}
	else if (cp + 1 < MAX_CHECKPOINTS && (raceCheckpointList[race][cp + 1][0] || raceCheckpointList[race][cp + 1][1] || raceCheckpointList[race][cp + 1][2]))
	{
		SetPlayerRaceCheckpoint(playerid, 0, raceCheckpointList[race][cp][0], raceCheckpointList[race][cp][1], raceCheckpointList[race][cp][2], raceCheckpointList[race][cp + 1][0], raceCheckpointList[race][cp + 1][1], raceCheckpointList[race][cp + 1][2], 15.0);
	}
	else
	{
		SetPlayerRaceCheckpoint(playerid, 1, raceCheckpointList[race][cp][0], raceCheckpointList[race][cp][1], raceCheckpointList[race][cp][2], 0.0, 0.0, 0.0, 15.0);
	}
	
	for (new ci, icon = SUGGESTED_MAPICONS_OFFSET; ci != MAX_SUGGESTED_MAPICONS; ci++, icon++)
	{
		new cin = cp + 1 + ci;
		if (cin < MAX_CHECKPOINTS && (raceCheckpointList[race][cin][0] || raceCheckpointList[race][cin][1] || raceCheckpointList[race][cin][2]))
		{
			SetPlayerMapIcon(playerid, icon, raceCheckpointList[race][cin][0], raceCheckpointList[race][cin][1], raceCheckpointList[race][cin][2], 0, COL_MAP_CP, 0);
		}
		else 
		{
			RemovePlayerMapIcon(playerid, icon);
		}
	}
	SetPVarInt(playerid, PVAR_TAG"currentCPID", cp);
	return 1;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

forward raceEndingTimer(race);
public raceEndingTimer(race)
{
	for (new p, mp = GetMaxPlayers(); p != mp; p++)
	{
		if (IsPlayerConnected(p) && !IsPlayerNPC(p))
		{
			new pRace = GetPVarInt(p, PVAR_TAG"currentRaceID");
			if (pRace && pRace - 2 == race)
			{
				new cp = GetPVarInt(p, PVAR_TAG"currentCPID");
				if (cp == MAX_CHECKPOINTS || raceCheckpointList[race][cp][0] || raceCheckpointList[race][cp][1] || raceCheckpointList[race][cp][2])
				{
					SendClientMessage(p, COL_TEXT_REG, " [!] NOTE: Too slow! You didn't finished before the race ended.");
				}
				else
				{
					#if REMEMBER_OLD_POSITION == true
					SendClientMessage(p, COL_TEXT_REG, " [!] NOTE: The race has been ended. You have been respawned at your old position.");
					#else
					SendClientMessage(p, COL_TEXT_REG, " [!] NOTE: The race has been ended.");
					#endif
				}
			}
		}
	}
	cleanRace(race);
	return 1;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stock respawnPlayer(playerid, race)
{		
	new veh = GetPVarInt(playerid, PVAR_TAG"currentVehID"), cp = GetPVarInt(playerid, PVAR_TAG"currentCPID") - 1, 
		Float: angle = GetAngleToPos(raceCheckpointList[race][cp][0], raceCheckpointList[race][cp][1], raceCheckpointList[race][cp + 1][0], raceCheckpointList[race][cp + 1][1]);
	
	if (veh)
	{
		DestroyVehicle(veh);
	}
	
	veh = CreateVehicle(raceVehicleModel[race], raceCheckpointList[race][cp][0], raceCheckpointList[race][cp][1], raceCheckpointList[race][cp][2] + 3.5, angle, RACE_VEHICLE_COL1, RACE_VEHICLE_COL2, 0);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	SetVehicleParamsEx(veh, true, false, false, true, false, false, false);
	PutPlayerInVehicle(playerid, veh, 0);
	SetPVarInt(playerid, PVAR_TAG"currentVehID", veh);
	
	TogglePlayerControllable(playerid, false);
	SetPVarInt(playerid, PVAR_TAG"respawnTimer", SetTimerEx("respawnUnfreeze", RESPAWN_TIME, false, "i", playerid));
	GameTextForPlayer(playerid, "Respawning", RESPAWN_TIME + 200, 3);
	SendClientMessage(playerid, COL_TEXT_REG, " [!] NOTE: You have been respawned in the race.");
	return 1;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

forward respawnUnfreeze(playerid);
public respawnUnfreeze(playerid)
{
	if (!IsPlayerConnected(playerid)) return 1;
	TogglePlayerControllable(playerid, true);
	return 1;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stock getFirstEmptyCPSlot(race)
{
	if (0 <= race < MAX_RACES && raceOwners[race] != INVALID_PLAYER_ID)
	{
		for (new c; c != MAX_CHECKPOINTS; c++)
		{
			if (raceCheckpointList[race][c][0] || raceCheckpointList[race][c][1] || raceCheckpointList[race][c][2]) continue;
			return c;
		}
	}
	return MAX_CHECKPOINTS;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stock updateContestantList(race)
{
	new list[255], amount, curlen = 35, bool: stopadding = false;
	for (new p, m = GetMaxPlayers(); p != m; p++)
	{
		if (!IsPlayerNPC(p) && IsPlayerConnected(p))
		{
			new pRace = GetPVarInt(p, PVAR_TAG"currentRaceID");
			if (pRace && pRace - 2 == race)
			{
				new pName[MAX_PLAYER_NAME];
				curlen += GetPlayerName(p, pName, MAX_PLAYER_NAME);
				
				if (curlen < 205)
				{
					strcat(list, "~n~ - ");
					strcat(list, pName);
				}
				else if (stopadding == false)
				{
					stopadding = true;
					strcat(list, "~n~ - and more!");
				}
				amount++;
			}
		}
	}
	format(list, 255, "~r~Contestants (%i of "#MAX_CONTESTANTS"):~w~%s", amount, list);
	TextDrawSetString(joinMenuRaceInfo[race][2], list);
	return 1;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stock showText(playerid, text[], time)
{
	new PlayerText: textitem = PlayerText: GetPVarInt(playerid, PVAR_TAG"SubTextID");
	if (textitem)
	{
		PlayerTextDrawHide(playerid, textitem - PlayerText: 1);
		PlayerTextDrawDestroy(playerid, textitem - PlayerText: 1);
	}
	
	textitem = CreatePlayerTextDraw(playerid, 380.0, 350.0, text);
	PlayerTextDrawLetterSize(playerid, textitem, 0.5, 2.0);
	PlayerTextDrawAlignment(playerid, textitem, 2);
	PlayerTextDrawTextSize(playerid, textitem, 300.0, 450.0);
	PlayerTextDrawShow(playerid, textitem);
	SetPVarInt(playerid, PVAR_TAG"SubTextID", _:textitem + 1);

	new timer = GetPVarInt(playerid, PVAR_TAG"SubTextTimer");
	if (timer)
	{
		KillTimer(timer);
	}
	SetPVarInt(playerid, PVAR_TAG"SubTextTimer", SetTimerEx("removeText", time, false, "i", playerid));
	return 1;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

forward removeText(playerid);
public removeText(playerid)
{
	new PlayerText: textitem = PlayerText: GetPVarInt(playerid, PVAR_TAG"SubTextID");
	if (textitem)
	{
		PlayerTextDrawHide(playerid, textitem - PlayerText: 1);
		PlayerTextDrawDestroy(playerid, textitem - PlayerText: 1);
	}
	DeletePVar(playerid, PVAR_TAG"SubTextID");
	
	new timer = GetPVarInt(playerid, PVAR_TAG"SubTextTimer");
	if (timer)
	{
		KillTimer(timer);
	}
	DeletePVar(playerid, PVAR_TAG"SubTextTimer");
	return 1;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
