/*
||=============================================================================||
||                         RacerX created by darkwatch                         ||
||                        Do NOT remove my credits!              			   ||
\*=============================================================================*/
#define VERSION "v1.04"


#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1

#include <a_samp>
#include <SII>
#include <alar>

#define MAX_RACECHECKPOINTS 128 // Change if you want more room for checkpoints than this
#define MAX_BUILDERS 6 // Change if you want more builderslots than this
#define MAX_CARCOLOURS 13
#define MAX_GAYME_OBJECTS 200

new PlayerFreeze[MAX_PLAYERS]; //Freeze on entry of start CP
new PlayerVehicle[MAX_PLAYERS];
					
forward RefreshMenuHeader(playerid,Menu:menu,text[]);
new Menu:MAdmin, Menu:MBuild, Menu:MLaps, Menu:WheelsMenu;
new Menu:MRace, Menu:MRacemode, Menu:MFee, Menu:MCPsize, Menu:MDelay;


#define COLOUR_RED 0xFF0000AA
#define COLOUR_YELLOW 0xEEEEEEFF
#define COLOUR_GREEN 0xEEEEEEFF
#define COLOUR_ORANGE 0xFF9900AA
#define COLOUR_WHITE 0xFFFFFFAA

// VehicleNames by Betamaster

#define MAX_VEHICLE_MODELS 70

new VehicleNames[212][] = {
	{"Landstalker"},
	{"Bravura"},
	{"Buffalo"},
	{"Linerunner"},
	{"Perrenial"},
	{"Sentinel"},
	{"Dumper"},
	{"Firetruck"},
	{"Trashmaster"},
	{"Stretch"},
	{"Manana"},
	{"Infernus"},
	{"Voodoo"},
	{"Pony"},
	{"Mule"},
	{"Cheetah"},
	{"Ambulance"},
	{"Leviathan"},
	{"Moonbeam"},
	{"Esperanto"},
	{"Taxi"},
	{"Washington"},
	{"Bobcat"},
	{"Mr Whoopee"},
	{"BF Injection"},
	{"Hunter"},
	{"Premier"},
	{"Enforcer"},
	{"Securicar"},
	{"Banshee"},
	{"Predator"},
	{"Bus"},
	{"Rhino"},
	{"Barracks"},
	{"Hotknife"},
	{"Trailer 1"}, //artict1
	{"Previon"},
	{"Coach"},
	{"Cabbie"},
	{"Stallion"},
	{"Rumpo"},
	{"RC Bandit"},
	{"Romero"},
	{"Packer"},
	{"Monster"},
	{"Admiral"},
	{"Squalo"},
	{"Seasparrow"},
	{"Pizzaboy"},
	{"Tram"},
	{"Trailer 2"}, //artict2
	{"Turismo"},
	{"Speeder"},
	{"Reefer"},
	{"Tropic"},
	{"Flatbed"},
	{"Yankee"},
	{"Caddy"},
	{"Solair"},
	{"Berkley's RC Van"},
	{"Skimmer"},
	{"PCJ-600"},
	{"Faggio"},
	{"Freeway"},
	{"RC Baron"},
	{"RC Raider"},
	{"Glendale"},
	{"Oceanic"},
	{"Sanchez"},
	{"Sparrow"},
	{"Patriot"},
	{"Quad"},
	{"Coastguard"},
	{"Dinghy"},
	{"Hermes"},
	{"Sabre"},
	{"Rustler"},
	{"ZR-350"},
	{"Walton"},
	{"Regina"},
	{"Comet"},
	{"BMX"},
	{"Burrito"},
	{"Camper"},
	{"Marquis"},
	{"Baggage"},
	{"Dozer"},
	{"Maverick"},
	{"News Chopper"},
	{"Rancher"},
	{"FBI Rancher"},
	{"Virgo"},
	{"Greenwood"},
	{"Jetmax"},
	{"Hotring"},
	{"Sandking"},
	{"Blista Compact"},
	{"Police Maverick"},
	{"Boxville"},
	{"Benson"},
	{"Mesa"},
	{"RC Goblin"},
	{"Hotring Racer A"}, //hotrina
	{"Hotring Racer B"}, //hotrinb
	{"Bloodring Banger"},
	{"Rancher"},
	{"Super GT"},
	{"Elegant"},
	{"Journey"},
	{"Bike"},
	{"Mountain Bike"},
	{"Beagle"},
	{"Cropdust"},
	{"Stunt"},
	{"Tanker"}, //petro
	{"Roadtrain"},
	{"Nebula"},
	{"Majestic"},
	{"Buccaneer"},
	{"Shamal"},
	{"Hydra"},
	{"FCR-900"},
	{"NRG-500"},
	{"HPV1000"},
	{"Cement Truck"},
	{"Tow Truck"},
	{"Fortune"},
	{"Cadrona"},
	{"FBI Truck"},
	{"Willard"},
	{"Forklift"},
	{"Tractor"},
	{"Combine"},
	{"Feltzer"},
	{"Remington"},
	{"Slamvan"},
	{"Blade"},
	{"Freight"},
	{"Streak"},
	{"Vortex"},
	{"Vincent"},
	{"Bullet"},
	{"Clover"},
	{"Sadler"},
	{"Firetruck LA"}, //firela
	{"Hustler"},
	{"Intruder"},
	{"Primo"},
	{"Cargobob"},
	{"Tampa"},
	{"Sunrise"},
	{"Merit"},
	{"Utility"},
	{"Nevada"},
	{"Yosemite"},
	{"Windsor"},
	{"Monster A"}, //monstera
	{"Monster B"}, //monsterb
	{"Uranus"},
	{"Jester"},
	{"Sultan"},
	{"Stratum"},
	{"Elegy"},
	{"Raindance"},
	{"RC Tiger"},
	{"Flash"},
	{"Tahoma"},
	{"Savanna"},
	{"Bandito"},
	{"Freight Flat"}, //freiflat
	{"Streak Carriage"}, //streakc
	{"Kart"},
	{"Mower"},
	{"Duneride"},
	{"Sweeper"},
	{"Broadway"},
	{"Tornado"},
	{"AT-400"},
	{"DFT-30"},
	{"Huntley"},
	{"Stafford"},
	{"BF-400"},
	{"Newsvan"},
	{"Tug"},
	{"Trailer 3"}, //petrotr
	{"Emperor"},
	{"Wayfarer"},
	{"Euros"},
	{"Hotdog"},
	{"Club"},
	{"Freight Carriage"}, //freibox
	{"Trailer 3"}, //artict3
	{"Andromada"},
	{"Dodo"},
	{"RC Cam"},
	{"Launch"},
	{"Police Car (LSPD)"},
	{"Police Car (SFPD)"},
	{"Police Car (LVPD)"},
	{"Police Ranger"},
	{"Picador"},
	{"S.W.A.T. Van"},
	{"Alpha"},
	{"Phoenix"},
	{"Glendale"},
	{"Sadler"},
	{"Luggage Trailer A"}, //bagboxa
	{"Luggage Trailer B"}, //bagboxb
	{"Stair Trailer"}, //tugstair
	{"Boxville"},
	{"Farm Plow"}, //farmtr1
	{"Utility Trailer"} //utiltr1
};

stock ReturnVehicleName(modelid) {
	new vname[25]="Unknown";
	if((modelid < 400) || (modelid > 611)) return vname;
	memcpy(vname, VehicleNames[modelid - 400], 0, 100);
	return vname;
}

stock ReturnVehicleID(const vname[]) {
	if(vname[0] == '\0') return INVALID_VEHICLE_ID;
	new vid = INVALID_VEHICLE_ID, length = strlen(vname);
	for(new i; i < sizeof(VehicleNames); i++) {
		new pos = strfind(VehicleNames[i], vname, true);
		if(pos == 0 && length == strlen(VehicleNames[i])) return i+400;
		else if(pos != -1) vid = i+400;
	}
	return vid;
}

//
forward RaceFix();
forward RaceRotation();
forward loadnext(); // 60 secs before loading the next race
forward EndTimerR();
forward LockRacers();
forward UnlockRacers();
forward SaveScores();   				// After race, if new best times have been made, saves them.
forward GetRaceTick(playerid);			// Gets amount of ticks the player was racing
forward GetLapTick(playerid); 		 	// Gets amount of ticks the player spend on the lap
forward RaceSound(playerid,sound);      // Plays <sound> for <playerid>
forward BActiveCP(playerid,sele);       // Gives the player selected checkpoint
forward Cendrace();                      // Ends the race, whether it ended normally or by /endrace. Cleans the variables.
forward endraceload();                  // Ends the race and loads a new one.
forward countdown();                    // Handles the countdown
forward SetNextCheckpoint(playerid);    // Gives the next checkpoint for the player during race
forward CheckBestLap(playerid, laptime);	// Check if <laptime> is better than any of the ones in highscore list, and update.
forward CheckBestRace(playerid,racetime);   // Check if <racetime> is better than any of the ones in highscore list, and update.
forward ChangeLap(playerid);            // Change player's lap, print out time and stuff.
forward SetRaceCheckpoint(playerid,target,next);    // Race-mode checkpoint setter
forward SetBRaceCheckpoint(playerid,target,next);   // Builder-mode checkpoint  setter-
forward LoadTimes(playerid,timemode,tmp[]);     // bestlap and bestrace-parameter race loader
forward IsNotAdmin(playerid);          // Is the player admin, if no, return 1 with an error message.
forward GetBuilderSlot(playerid);   // Get next free builderslot, return 0 if none available
forward bb(playerid); 		       // Quick and dirty fix for the BuilderSlots
forward Float:Distance(Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2);
forward Cclearrace(playerid);
forward Cstartrace();
forward LoadRace(tmp[]);
forward CreateRaceMenus();
forward PlayerF(playerid); //Freeze timer
forward MusicStop(playerid); //Stop finish music
forward RaceEnder();
forward TimeTDUpdate(playerid);
forward ScriptRefresh();
forward fdeleteline(filename[], line[]);
forward fcreate(filename[]);

forward strtok(const string[],&index);

new Winnings1;
new Winnings2;
new Winnings3;
new Winnings4;
new Winnings5;
new RunnerUp;
new BuildAdmin;
new JoinFee;
new RaceAdmin;

// General variables
new TimeTimer[MAX_PLAYERS];
new Text:Append1;
new Text:Append2;
new Text:Append3;
new Text:Append4;
new Text:Partici;
new Text:Time;
new Text:TCountdown;
//new Text:Speed[MAX_PLAYERS];
new Text:Position[MAX_PLAYERS];
new Text:TPosition[MAX_PLAYERS];
//new Text:Diff[MAX_PLAYERS];
new PlayerEditing[MAX_PLAYERS];
new Float:xsave[MAX_PLAYERS];//Saves positions before /join so they return there after finish
new Float:ysave[MAX_PLAYERS];
new Float:zsave[MAX_PLAYERS];
new Float:BStartX[MAX_PLAYERS];
new Float:BStartY[MAX_PLAYERS];
new Float:BStartZ[MAX_PLAYERS];
new Float:BStartR[MAX_PLAYERS];
new Float:StartX;
new Float:StartY;
new Float:StartZ;
new Float:StartR;
new AutoFixT;
new ReadyRef;
new Partsave;
new interiorsave[MAX_PLAYERS];
new worldsave[MAX_PLAYERS];
new TBuilder[256];
//new Float:TelePos[MAX_PLAYERS][6];
new RacePosition[MAX_PLAYERS];
new gPlayerProgress[MAX_PLAYERS];
new Float:gRaceCheckpoints[MAX_RACECHECKPOINTS];
new RaceEnd;
new EndingT;
new racevehicle[MAX_PLAYERS];
new iString[256];    // iString
new CBuilder[256], CFile[64], CRaceName[128];        //Creator of the race and the filename, for score changing purposes.
// Racing-related variables
new Ranking;            //Finishing order for prizes
new Countdown;          //Countdown timer
new cd;                 //Countdown time
new RaceActive;         //Is a race active?
new RaceStart;          //Has race started?
new LoadNextRace; //loadnext timer
new Float:RaceCheckpoints[MAX_RACECHECKPOINTS][3];  //Current race CP array
//new Float:RaceConverter[MAX_RACECHECKPOINTS][3];  //Current race CP array
new LCurrentCheckpoint;                             //Current race array pointer
new CurrentCheckpoint[MAX_PLAYERS];                 //Current race array pointer array :V
new CurrentLap[MAX_PLAYERS];                        //Current lap array
new RaceParticipant[MAX_PLAYERS];                   //Has the player /joined the race
  // \_values: 0 - not in race, 1 - joined, 2 - arrived to start CP, 3 - /ready, 4 - racing, 5 - Last CP
new Participants;                                   //Amount of participants
new PlayerVehicles[MAX_PLAYERS];                    //For slapping the player back in their vehicle.
new ORacelaps, ORacemode;   //Saves the laps/mode from file in case they aren't changed
//new OAirrace, Float:OCPsize;
new Racelaps, Racemode;		//If mode/laps has been changed, the new scores won't be saved.
new ScoreChange;            //Flag for new best times, so they are saved.
new RaceTick;               //Startime of the race
new fback;
new RaceNames[1000][64];
new GaymeCountR;
//new FirstTick[MAX_RACECHECKPOINTS][MAX_PLAYERS];              //Time between CP's
//new Difference[MAX_RACECHECKPOINTS][MAX_PLAYERS];
new LastLapTick[MAX_PLAYERS];       //Array that stores the times when players started the lap
new TopRacers[6][256]; // Stores 5 top scores, 6th isn't
new TopRacerTimes[6];              // saved to file, used to simplify
new TopLappers[6][256];// for() loops on CheckBestLap and
new TopLapTimes[6];                // CheckBestRace.
new Float:CPsize;                        // Checkpoint size for the race
new Airrace;                       // Is the race airrace?
new Nitrous;                    //Does the race have nitrous?
new Float:Gravity = 0.008;
new RWeather;                   //Weather id for race
new RaceWorld;                    //Race Virtual World
new Float:RLenght, Float:LLenght; //Lap lenght and race lenght
// Building-related variables
new BCurrentCheckpoints[MAX_BUILDERS];               //Buildrace array pointers
new BSelectedCheckpoint[MAX_BUILDERS];               //Selected checkpoint during building
new RaceBuilders[MAX_PLAYERS];                       //Who is building a race?
new BuilderSlots[MAX_BUILDERS];                      //Stores the racebuilder pids
new Float:BRaceCheckpoints[MAX_BUILDERS][MAX_RACECHECKPOINTS][3]; //Buildrace CP array
new Bracemode[MAX_BUILDERS];
new Blaps[MAX_BUILDERS];
new Float:BCPsize[MAX_BUILDERS];
new Rcar[MAX_BUILDERS];
new Rfix[MAX_BUILDERS];
new Rnos[MAX_BUILDERS];
new Float:Rgravity[MAX_BUILDERS];
new Rweather[MAX_BUILDERS];
new Rworld[MAX_BUILDERS];
new BAirrace[MAX_BUILDERS];
new RaceFixTimer;
new RaceVehicleName[64];
new TempRaceMaker[MAX_PLAYERS];
new loadtick;
new RRot;
new Float:BPickupLocations[MAX_BUILDERS][5][4]; // 5 pickups, 4 floats
new BPickupTypes[MAX_BUILDERS][5];
new BPickupModels[MAX_BUILDERS];
new BPickupVehicles[MAX_BUILDERS][5];
new PickupModel, PickupType[5];
new Pickup0, Pickup1, Pickup2, Pickup3, Pickup4;
new Float:PickupLocations[5][4];
new PickupVehicle0, PickupVehicle1, PickupVehicle2, PickupVehicle3, PickupVehicle4;

// Save objects
new oObjectR[MAX_GAYME_OBJECTS]; // Saves the objects id
new oModelR[MAX_GAYME_OBJECTS];
new Float:oXR[MAX_GAYME_OBJECTS];
new Float:oYR[MAX_GAYME_OBJECTS];
new Float:oZR[MAX_GAYME_OBJECTS];
new Float:oRXR[MAX_GAYME_OBJECTS];
new Float:oRYR[MAX_GAYME_OBJECTS];
new Float:oRZR[MAX_GAYME_OBJECTS];

new CarColours[MAX_CARCOLOURS] = {1,6,951,142,144,146,147,151,157,166,181,252,126};

// Flat tire fix
/*
 * Run-Flat Tires System
 * (c) Copyright 2010, <__Ethan__>
 *
 * created by    : StrickenKid
 * creation date : July 10, 2010
 * verion        : 1.0
 * testing       : []LocalHost[]
 *                 Potassium
 *
 * Compatable only with 0.3a and up.
 */
 
#define __runflat_included

#define _MSG_COLOR 0xFFFFFFFF
 
// bit functions
#define bit_check(%1,%2) ((%1)&(1<<(%2)))
#define bit_flip(%1,%2) ((%1)^=(1<<(%2)))

#define TIRE_BR 0 // back right
#define TIRE_FR 1 // front right
#define TIRE_BL 2 // back left
#define TIRE_FL 3 // front left

new
	runFlat[ MAX_PLAYERS ][ 4 ];

/*
 * Processes tire param to check if each tire bit is set (popped).
 * If a tire bit is set (popped) it will then flip the bit, fixing the tire.
 *
 * Returns: Id of tire fixed, -1 if no tires were fixed.
 */
stock ProcessRunflatTires( playerid, &tires )
{
	if(RaceParticipant[playerid] == 1){
		if ( bit_check( tires, TIRE_BR ) > 0 && runFlat[ playerid ][ TIRE_BR ] )
		{
			bit_flip( tires, TIRE_BR );
			runFlat[ playerid ][ TIRE_BR ] = 0;
			SendClientMessage( playerid, _MSG_COLOR, "Run-Flat: Back Right Tire Popped, Run-Flat Enabled." );
			return TIRE_BR;
		}

		if ( bit_check( tires, TIRE_FR ) > 0 && runFlat[ playerid ][ TIRE_FR ] )
		{
			bit_flip( tires, TIRE_FR );
			runFlat[ playerid ][ TIRE_FR ] = 0;
			SendClientMessage( playerid, _MSG_COLOR, "Run-Flat: Front Right Tire Popped, Run-Flat Enabled." );
			return TIRE_FR;
		}

		if ( bit_check( tires, TIRE_BL ) > 0 && runFlat[ playerid ][ TIRE_BL ] )
		{
			bit_flip( tires, TIRE_BL );
			runFlat[ playerid ][ TIRE_BL ] = 0;
			SendClientMessage( playerid, _MSG_COLOR, "Run-Flat: Back Left Tire Popped, Run-Flat Enabled." );
			return TIRE_BL;
		}

		if ( bit_check( tires, TIRE_FL ) > 0 && runFlat[ playerid ][ TIRE_FL ] )
		{
			bit_flip( tires, TIRE_FL );
			runFlat[ playerid ][ TIRE_FL ] = 0;
			SendClientMessage( playerid, _MSG_COLOR, "Run-Flat: Front Left Tire Popped, Run-Flat Enabled." );
			return TIRE_FL;
		}
	}

 	return -1;
}

/*
 * Gives a player runflat tires.
 *
 * Returns: Nothing.
 */
stock GivePlayerRunflats( playerid )
{
	for( new i = 0; i < 4; i++ )
 		runFlat[ playerid ][ i ] = 1;
}

public OnVehicleDamageStatusUpdate( vehicleid, playerid )
{
    new
		panels,
		doors,
		lights,
		tires;

    GetVehicleDamageStatus( vehicleid, panels, doors, lights, tires );

    ProcessRunflatTires( playerid, tires );

    UpdateVehicleDamageStatus( vehicleid, panels, doors, lights, tires );

    return 1;
}

/* eof */

// END OF FLAT TIRE FIX

public OnFilterScriptInit()
{
	print("\n+-----------------------+");
	printf("| Race Filterscript %s|", VERSION);
	print("+-------LOADED----------+\n");
	
	INI_Open("/iRaces/iConfig.iRf");
	SendClientMessageToAll(COLOUR_ORANGE, "RacerX has been loaded!");
	//AddServerRule("Current Race", "None");
	Winnings1 = INI_ReadInt("Winnings1st");
	Winnings2 = INI_ReadInt("Winnings2nd");
	Winnings3 = INI_ReadInt("Winnings3rd");
	Winnings4 = INI_ReadInt("Winnings4th");
	Winnings5 = INI_ReadInt("Winnings5th");
	RunnerUp = INI_ReadInt("RunnerUp");

	RRot = INI_ReadInt("RaceRotDelay");
	BuildAdmin = INI_ReadInt("BuildAdmin"); //Require admin privileges for building races? 1)  yes, 0) no. (Can be changed ingame in Admin menu)
	RaceAdmin = INI_ReadInt("RaceAdmin");  //Require admin privileges for starting races? 1)  yes, 0) no. (Can be changed ingame in Admin menu)
	JoinFee = INI_ReadInt("JoinFee");       //Amount of $ it costs to /join a race      [Admin menu ingame]
	
	INI_Close();
	SetTimer("ScriptRefresh", 21600000, true);//6hrs
	RaceActive=0;
	Ranking=1;
	LCurrentCheckpoint=0;
	Participants=0;
	CreateText();
	for(new i;i<MAX_BUILDERS;i++)
	{
	    BuilderSlots[i]=MAX_PLAYERS+1;
	}
	CreateRaceMenus();
	RaceRotation();
	return 1;
}

public OnFilterScriptExit()
{
	print("+-------------------------+");
	printf("| Race Filterscript %s  |", VERSION);
	print("+------UNLOADED-----------+\n");
	printf("Race Count: %i", GaymeCountR);
	SendClientMessageToAll(COLOUR_ORANGE, "RacerX has been unloaded!");
	TextDrawDestroy(Time);
	TextDrawDestroy(TCountdown);
	TextDrawDestroy(Partici);
	TextDrawDestroy(Append1), TextDrawDestroy(Append2), TextDrawDestroy(Append3), TextDrawDestroy(Append4);
	KillTimer(RaceFixTimer);
	KillTimer(EndingT);
	KillTimer(Countdown);
	KillTimer(LoadNextRace);
	DestroyPickup(Pickup0);
   	DestroyPickup(Pickup1);
   	DestroyPickup(Pickup2);
   	DestroyPickup(Pickup3);
   	DestroyPickup(Pickup4);
	for(new i=0;i<MAX_PLAYERS;i++)
	{
		DestroyVehicle(PlayerVehicle[i]);
		TextDrawDestroy(Position[i]);
		TextDrawDestroy(TPosition[i]);
		//TextDrawDestroy(Diff[i]);
	}
	//TextDrawDestroy(Speed[i]);
	DestroyMenu(MAdmin);
	DestroyMenu(MBuild);
	DestroyMenu(MLaps);
	DestroyMenu(MRace);
	DestroyMenu(MRacemode);
	DestroyMenu(MFee);
	DestroyMenu(MCPsize);
	DestroyMenu(MDelay);
	for(new i=0;i<MAX_PLAYERS;i++){
	if(!IsPlayerConnected(i)) continue;
	DisablePlayerRaceCheckpoint(i);
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(RaceParticipant[playerid] > 0)
	{
		TogglePlayerControllable(playerid, true);
		SetPlayerVirtualWorld(playerid, 0);
		KillTimer(TimeTimer[playerid]);
    	TextDrawHideForPlayer(playerid, Time);
    	TextDrawHideForPlayer(playerid, Partici);
    	TextDrawHideForPlayer(playerid, TCountdown);
    	TextDrawHideForPlayer(playerid, Position[playerid]);
    	TextDrawHideForPlayer(playerid, TPosition[playerid]);
    	//TextDrawHideForPlayer(playerid, Diff[playerid]);
    	TextDrawHideForPlayer(playerid, Append1), TextDrawHideForPlayer(playerid, Append2), TextDrawHideForPlayer(playerid, Append3), TextDrawHideForPlayer(playerid, Append4);
		if(racevehicle[playerid] != 1)
		{
			if(GetVehicleVirtualWorld(PlayerVehicle[playerid]) == RaceWorld)
			{
				DestroyVehicle(PlayerVehicle[playerid]);
			}
		}
		DisablePlayerRaceCheckpoint(playerid);
		RaceParticipant[playerid]=0;
		Participants--;
		SendClientMessage(playerid,COLOUR_YELLOW,"You have died and left the race.");
		SetPlayerInterior(playerid, interiorsave[playerid]);
		SetPlayerVirtualWorld(playerid, worldsave[playerid]);
		SetPlayerPos(playerid, xsave[playerid], ysave[playerid], zsave[playerid]);
		//SetPlayerGravity(playerid, 0.008);
  		if(RaceStart == 1)
  		{
        	if(Participants == 0)
			{
			    new ender;
				for(new i=0;i<MAX_PLAYERS;i++)
				{
				    if(GetPlayerVirtualWorld(i) == RaceWorld) continue;
				    ender = 1;
				}
				if(ender == 1) endraceload();
			}
		}
	}
    return 1;
}


public OnPlayerCommandText(playerid, cmdtext[])
{
	dcmd(racehelp,8,cmdtext);	// Racehelp - there's a lot of commands!
	dcmd(buildcmds,9,cmdtext);	// Buildhelp - building help!
	dcmd(buildhelp,9,cmdtext);	// Buildcmds - there's a lot of commands!
	dcmd(buildrace,9,cmdtext);	// Buildrace - Start building a new race (suprising!)
	dcmd(raceinfo,8,cmdtext);   // RaceInfo - Displays information on a race
	dcmd(nr,2,cmdtext);         // Nextrace -
	dcmd(tcp,3,cmdtext);		// tcp - Add a 1st checkpoint
	dcmd(cp,2,cmdtext);		  	// cp - Add a checkpoint
	dcmd(scp,3,cmdtext);		// scp - Select a checkpoint
	dcmd(rcp,3,cmdtext);		// rcp - Replace the current checkpoint with a new one
	dcmd(mcp,3,cmdtext);		// mcp - Move the selected checkpoint
	dcmd(dcp,3,cmdtext);       	// dcp - Delete the selected waypoint
	dcmd(rpickupmodel,12,cmdtext); // rpickupmodel
	dcmd(rpickup,7,cmdtext);    // rpickup - buildrace pickup
	dcmd(clearrace,9,cmdtext);	// clearrace - Clear the current (new) race.
	dcmd(editrace,8,cmdtext);	// editrace - Load an existing race into the builder
	dcmd(saverace,8,cmdtext);	// saverace - Save the current checkpoints to a file
	dcmd(setlaps,7,cmdtext);	// setlaps - Set amount of laps to drive
	dcmd(racemode,8,cmdtext);	// racemode - Set the current racemode
	dcmd(loadrace,8,cmdtext);	// loadrace - Load a race from file and start it
	dcmd(loadracemenu,12,cmdtext);	// loadracemenu - Load a race from file and display the menu
	dcmd(startrace,9,cmdtext);  // starts the loaded race
	dcmd(quickstart,10,cmdtext);  // starts the loaded race
	dcmd(racelist,8,cmdtext);   // racelist - Displays the created races.
	dcmd(rjoin,5,cmdtext);		// rjoin - Join the announced race.
	dcmd(rleave,6,cmdtext);		// leave - leave the current race.
	dcmd(racemaker,9,cmdtext);  // racemaker - allow non admins to make races.
	dcmd(racing,6,cmdtext);     // racing - displays the name and position of who is currently racing.
	dcmd(building,8,cmdtext);   // building - displays the name of who is currently building.
	dcmd(endrace,7,cmdtext);	// endrace - Complete the current race, clear tables & variables, stop the timer.
	dcmd(rnos,4,cmdtext);        // nos - toggles nitrous being given in races.
	dcmd(rgravity,8,cmdtext);   // rgravity - Race world gravity.
	dcmd(rweather,8,cmdtext);   // rweather - sets the race weather
	dcmd(rworld,6,cmdtext);     // rworld - sets the race world.
	dcmd(rvehicle,8,cmdtext);	// rvehicle - If in buildmode, sets the vehicle you wish to race with.
	dcmd(checkpoint,10,cmdtext);// checkpoint - Returns you to your last checkpoint.
	dcmd(rflip,5,cmdtext);		// rflip - Flips you car over.
	dcmd(bestlap,7,cmdtext);	// bestlap - Display the best lap times for the current race
	dcmd(bestrace,8,cmdtext);	// bestrace - Display the best race times for the current race
	dcmd(deleterace,10,cmdtext);// deleterace - Remove the race from disk
	dcmd(airrace,7,cmdtext);    // airrace - Changes the checkpoints to air CPs and back
	dcmd(cpsize,6,cmdtext);     // cpsize - changes the checkpoint size
	return 0;
}

dcmd_racehelp(playerid, params[])
{
    #pragma unused params
    format(iString, sizeof(iString), "RacerX %s Race Help Guide", VERSION);
	SendClientMessage(playerid, COLOUR_GREEN, iString);
	SendClientMessage(playerid, COLOUR_WHITE, "Races are either auto-loaded, or admins can use '/loadrace'. Players then use /rjoin to enter.");
	SendClientMessage(playerid, COLOUR_WHITE, "A countdown will begin, and after 60 seconds players will be unfrozen, and the race will begin.");
	SendClientMessage(playerid, COLOUR_WHITE, "Use /rLeave to leave the race. Admins can /endrace to abort the race early.");
	SendClientMessage(playerid, COLOUR_WHITE, "/Bestlap and /bestrace can be used to display record times for the races.");
	SendClientMessage(playerid, COLOUR_WHITE, "You can also specify a race to see the times for it, even if the race is not active.");
	SendClientMessage(playerid, COLOUR_WHITE, "Use /rflip to flip your vehicle, and /checkpoint to return to the last visited checkpoint. /raceinfo shows race info.");
	SendClientMessage(playerid, COLOUR_WHITE, "/racelist [name] will show races made by a specific player. /racers shows who is racing, and their position.");
	return 1;
}

dcmd_buildhelp(playerid, params[])
{
    #pragma unused params
	SendClientMessage(playerid, COLOUR_GREEN, "Race Script Building Guide");
	SendClientMessage(playerid, COLOUR_WHITE, "Please read the wiki for a complete guide on building races.");
	SendClientMessage(playerid, COLOUR_WHITE, "You should not build a race unless you have read it in full!");
	SendClientMessage(playerid, COLOUR_WHITE, "Use /BuildCmds to view race building commands.");
	return 1;
}

dcmd_buildcmds(playerid, params[])
{
    #pragma unused params
	SendClientMessage(playerid, COLOUR_GREEN, "Race Script Command Guide");
	SendClientMessage(playerid, COLOUR_WHITE, "/Buildrace - Start building.  /Saverace [name] - Save your race.  /ClearRace - Ends building.  /Editrace - Load a race to editor.");
	SendClientMessage(playerid, COLOUR_WHITE, "/Cp - Set a checkpoint.  /Scp - Select an old checkpoint.  /Dcp - Delete CP.  /Mcp - Move CP.  /Rcp - Replace with a new one.");
	SendClientMessage(playerid, COLOUR_WHITE, "/Tcp - Set the pos you tele to with /rjoin.  /RGravity - Set race gravity (0.008 is default).  /RWeather - Race weather.");
	SendClientMessage(playerid, COLOUR_WHITE, "/Rworld - Set the race world (0 is main, 100 is private).  /Nos - Toggle nitrous being given.  /SetLaps - Race laps. /rvehicle [name/id] - Set vehicle.");
	SendClientMessage(playerid, COLOUR_WHITE, "For additional help and a more detailed guide, view the wiki topic!");
	return 1;
}

dcmd_buildrace(playerid, params[])
{
    #pragma unused params
	if(BuildAdmin == 1 && IsNotAdmin(playerid)) return 1;
	if(RaceBuilders[playerid] != 0)
	{
		SendClientMessage(playerid, COLOUR_YELLOW, "You are already building a race, dork.");
	}
	else if(RaceParticipant[playerid]>0)
	{
	    SendClientMessage(playerid, COLOUR_YELLOW, "You are participating in a race, so can't build a race.");
	}
	else
	{
		new slot;
		slot=GetBuilderSlot(playerid);
		if(slot == 0)
		{
			SendClientMessage(playerid, COLOUR_YELLOW, "No builderslots available!");
			return 1;
		}
		format(iString,sizeof(iString),"You are now building a race (Slot: %d)",slot);
		SendClientMessage(playerid, COLOUR_GREEN, iString);
		SendClientMessage(playerid, COLOUR_YELLOW, "WARNING - Race building has changed, ensure you have read the wiki before continuing!");
		RaceBuilders[playerid]=slot;
		BCurrentCheckpoints[bb(playerid)]=0;
		Bracemode[bb(playerid)]=0;
		Blaps[bb(playerid)]=0;
		BAirrace[bb(playerid)] = 0;
		BCPsize[bb(playerid)] = 8.0;
		Rcar[bb(playerid)] = 1;
		Rfix[bb(playerid)] = 1;
		Rnos[bb(playerid)] = 0;
		Rweather[bb(playerid)] = 0;
		Rworld[bb(playerid)] = 0;
	}
	return 1;
}

dcmd_raceinfo(playerid, params[])
{
    new tmp[256],idx, TempCPs, str[32];
    tmp = strtok(params, idx);
    format(iString,sizeof(iString),"/iRaces/%s.iR",tmp);
    if(!strlen(tmp))
	{
		format(iString,sizeof(iString),"/iRaces/%s.iR",CRaceName);
		tmp = CRaceName;
    }
	if(!fexist(iString)) return SendClientMessage(playerid, COLOUR_RED, "ERROR: Race cannot be found!");
	INI_Open(iString);
	INI_ReadString(str, "Creator");
	format(iString,sizeof(iString),"%s by %s - Race Info:", tmp, str);
	SendClientMessage(playerid, COLOUR_GREEN, iString);
	
	format(iString,sizeof(iString),"Virtual World: %i, Laps: %i, AirRace: %i, CPSize: %f", 150, INI_ReadInt("Laps"), INI_ReadInt("AirRace"), INI_ReadFloat("CPSize"));
	SendClientMessage(playerid,COLOUR_WHITE,iString);
	
	format(iString,sizeof(iString),"Vehicle: %s(%i), Auto-Fix: %i, Nitrous: %i Weather: %i Gravity: %f", ReturnVehicleName(INI_ReadInt("Vehicle")), INI_ReadInt("Vehicle"), INI_ReadInt("AutoFix"), INI_ReadInt("Nos"), INI_ReadInt("Weather"), INI_ReadFloat("Gravity"));
	SendClientMessage(playerid, COLOUR_WHITE, iString);

	new i, Float:q;
	for(new j=0;j<200;j++)
	{
		i = 0;
		TempCPs++;
		format(iString,sizeof(iString), "CPs/%d", TempCPs);
		INI_ReadString(iString, iString);
		q = floatstr(strtok(iString,i));

		if(q > -1 && q < 1) break;

		strtok(iString,i);
		strtok(iString,i);
		#pragma unused q
	}
	TempCPs--;
	format(iString,sizeof(iString),"Checkpoints: %i, Starting checkpoint: %f, %f, %f", TempCPs, INI_ReadFloat("Tcp/1"), INI_ReadFloat("Tcp/2"), INI_ReadFloat("Tcp/3"), INI_ReadFloat("Tcp/4"));
	SendClientMessage(playerid,COLOUR_WHITE,iString);

	INI_Close();
	return 1;
}

dcmd_racing(playerid, params[])
{
	#pragma unused params
	new x;
	SendClientMessage(playerid, COLOUR_GREEN, "Players currently racing: (Name[Position])");
	format(iString, sizeof(iString), "No one is currently racing!");
	new Pname[MAX_PLAYER_NAME];
	for(new i=0;i<MAX_PLAYERS;i++)
	{
		if(RaceParticipant[i])
		{
		    GetPlayerName(i, Pname, sizeof(Pname));
		    RacePosition[playerid]=floatround(gRaceCheckpoints[gPlayerProgress[playerid]],floatround_floor);
    		if(x == 1) format(iString,sizeof(iString),"%s, %s[%i]", iString, Pname, RacePosition[i]);
    		else format(iString,sizeof(iString),"%s[%i]", Pname, RacePosition[i]);
    		x = 1;
		}
	}
	SendClientMessage(playerid, COLOUR_YELLOW, iString);
	format(iString,sizeof(iString),"Participants: %i", Participants);
	SendClientMessage(playerid, COLOUR_YELLOW, iString);
	return 1;
}

dcmd_building(playerid, params[])
{
	#pragma unused params
	new x;
	SendClientMessage(playerid, COLOUR_GREEN, "Players currently building a race: (Name)");
	format(iString, sizeof(iString), "No one is currently building!");
	for(new i=0;i<MAX_PLAYERS;i++)
	{
		if(RaceBuilders[i] != 0)
		{
		    new Pname[MAX_PLAYER_NAME];
		    GetPlayerName(i, Pname, sizeof(Pname));
    		if(x == 1) format(iString,sizeof(iString),"%s, %s", iString, Pname);
    		else format(iString,sizeof(iString),"%s", Pname);
    		x = 1;
		}
	}
	SendClientMessage(playerid, COLOUR_YELLOW, iString);
	return 1;
}

dcmd_nr(playerid, params[])
{
    #pragma unused params
    if(RaceActive == 1)
    {
        SendClientMessage(playerid, COLOUR_RED, "Error: A race is already active!");
        return 1;
    }
    new tick, diff, next;
    tick=GetTickCount();
    diff = tick - loadtick;
    next = (RRot*60*1000) - diff;
    new HumanTime[10], minutes, seconds, secstring[2];
	minutes=next/60000;
	next=next-(minutes*60000);
	seconds=next/1000;
	next=next-(seconds*1000);
	if(seconds <10) format(secstring,sizeof(secstring),"0%d",seconds);
	else format(secstring,sizeof(secstring),"%d",seconds);
	format(HumanTime,sizeof(HumanTime),"%d:%s",minutes,secstring);
    
    format(iString, sizeof(iString), "%s", ReturnServerStringVar("rcon_password"));
    SendClientMessage(playerid, COLOUR_YELLOW, iString);
    return 1;
}

dcmd_racelist(playerid, params[])
{
	#pragma unused params
	new i, File:f, tmp[128];
	new templine[256], race_name[64], string[64], idx, LString[800];
	
	tmp = strtok(params, idx);
	
    if(!strlen(tmp))
	{
		GetPlayerName(playerid, tmp, sizeof(tmp));
    }
	
	f = fopen("iRaces/iList.iRf", io_read);
	format(LString, sizeof(LString), "Races made by %s:", tmp);
	SendClientMessage(playerid, COLOUR_GREEN, LString);
	format(LString, sizeof(LString), "No races made by %s!", tmp);
	new x, racesmade;
	while(fread(f,templine,sizeof(templine),false))
	{
	    i = 0;
	    race_name = strtok(templine,i);
	    string = strtok(templine,i);
	    if(equal(tmp, string, true) == 1)
	    {
	        racesmade++;
	        if(x == 1)format(LString, sizeof(LString), "%s, %s", LString, race_name);
	        else(format(LString, sizeof(LString), "%s", race_name));
	        x = 1;
	    }
	}
	format(LString, sizeof(LString), "%d races: \n %s", racesmade, LString);
	SendWrappedMessageToPlayer(playerid, COLOUR_YELLOW, LString);
	fclose(f);
	return 1;
}

dcmd_quickstart(playerid, params[])
{
    #pragma unused params
    if(IsPlayerScriptAdmin(playerid))
    {
		if(RaceStart == 0 && RaceActive != 0 && cd > 1)
		{
		    new name[MAX_PLAYER_NAME];
		    GetPlayerName(playerid, name, sizeof(name));
		    cd = 5;
			format(iString, sizeof(iString), "%s has quick started the race!", name);
	    	SendClientMessageToAll(COLOUR_ORANGE, iString);
		}
	}
	else SendClientMessage(playerid, COLOUR_RED, "You are not an admin!");
	return 1;
}

dcmd_tcp(playerid, params[])
{
    #pragma unused params
    if(RaceBuilders[playerid] != 0)
    {
    	GetPlayerPos(playerid,BStartX[playerid],BStartY[playerid],BStartZ[playerid]);
    	GetPlayerFacingAngle(playerid, BStartR[playerid]);
		SendClientMessage(playerid, COLOUR_YELLOW, "Starting position set!");
	}
	else
	{
		SendClientMessage(playerid, COLOUR_RED, "You are not building a race!");
	}
	return 1;
}

dcmd_cp(playerid, params[])
{
	#pragma unused params
	if(RaceBuilders[playerid] != 0 && BCurrentCheckpoints[bb(playerid)] < MAX_RACECHECKPOINTS)
	{
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid,x,y,z);
		format(iString,sizeof(iString),"Checkpoint %d created: %f,%f,%f.",BCurrentCheckpoints[bb(playerid)],x,y,z);
		SendClientMessage(playerid, COLOUR_GREEN, iString);
		BRaceCheckpoints[bb(playerid)][BCurrentCheckpoints[bb(playerid)]][0]=x;
		BRaceCheckpoints[bb(playerid)][BCurrentCheckpoints[bb(playerid)]][1]=y;
		BRaceCheckpoints[bb(playerid)][BCurrentCheckpoints[bb(playerid)]][2]=z;
		BSelectedCheckpoint[bb(playerid)]=BCurrentCheckpoints[bb(playerid)];
		SetBRaceCheckpoint(playerid,BCurrentCheckpoints[bb(playerid)],-1);
		BCurrentCheckpoints[bb(playerid)]++;
	}
	else if(RaceBuilders[playerid] != 0 && BCurrentCheckpoints[bb(playerid)] == MAX_RACECHECKPOINTS)
	{
		format(iString,sizeof(iString),"Sorry, maximum amount of checkpoints reached (%d).",MAX_RACECHECKPOINTS);
		SendClientMessage(playerid, COLOUR_YELLOW, iString);
	}
	else
	{
		SendClientMessage(playerid, COLOUR_RED, "You are not building a race!");
	}
	return 1;
}

dcmd_scp(playerid, params[])
{
	new sele, tmp[256], idx;
    tmp = strtok(params, idx);
    if(!strlen(tmp)) {
		SendClientMessage(playerid, COLOUR_WHITE, "USAGE: /scp [checkpoint]");
		return 1;
    }
    sele = strval(tmp);
	if(RaceBuilders[playerid] != 0)
	{
		if(sele>BCurrentCheckpoints[bb(playerid)]-1 || BCurrentCheckpoints[bb(playerid)] < 1 || sele < 0)
		{
			SendClientMessage(playerid, COLOUR_YELLOW, "Invalid checkpoint!");
			return 1;
		}
		format(iString,sizeof(iString),"Selected checkpoint %d.",sele);
		SendClientMessage(playerid, COLOUR_GREEN, iString);
		BActiveCP(playerid,sele);
		BSelectedCheckpoint[bb(playerid)]=sele;
	}
	else
	{
		SendClientMessage(playerid, COLOUR_RED, "You are not building a race!");
	}
	return 1;
}

dcmd_rcp(playerid, params[])
{
	#pragma unused params
	if(RaceBuilders[playerid] == 0)
	{
		SendClientMessage(playerid, COLOUR_RED, "You are not building a race!");
		return 1;
	}
	else if(BCurrentCheckpoints[bb(playerid)] < 1)
	{
		SendClientMessage(playerid, COLOUR_YELLOW, "No checkpoint to replace!");
		return 1;
	}
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
	format(iString,sizeof(iString),"Checkpoint %d replaced: %f,%f,%f.",BSelectedCheckpoint[bb(playerid)],x,y,z);
	SendClientMessage(playerid, COLOUR_GREEN, iString);
	BRaceCheckpoints[bb(playerid)][BSelectedCheckpoint[bb(playerid)]][0]=x;
	BRaceCheckpoints[bb(playerid)][BSelectedCheckpoint[bb(playerid)]][1]=y;
	BRaceCheckpoints[bb(playerid)][BSelectedCheckpoint[bb(playerid)]][2]=z;
	BActiveCP(playerid,BSelectedCheckpoint[bb(playerid)]);
    return 1;
}

dcmd_mcp(playerid, params[])
{
	if(RaceBuilders[playerid] == 0)
	{
		SendClientMessage(playerid, COLOUR_RED, "You are not building a race!");
		return 1;
	}
	else if(BCurrentCheckpoints[bb(playerid)] < 1)
	{
		SendClientMessage(playerid, COLOUR_YELLOW, "No checkpoint to move!");
		return 1;
	}
	new idx, direction, dir[256];
	dir=strtok(params, idx);
	new Float:amount=floatstr(strtok(params,idx));
	if(amount == 0.0 || (dir[0] != 'x' && dir[0]!='y' && dir[0]!='z'))
	{
		SendClientMessage(playerid, COLOUR_WHITE, "USAGE: /mcp [x,y or z] [amount]");
		return 1;
	}
    if(dir[0] == 'x') direction=0;
    else if (dir[0] == 'y') direction=1;
    else if (dir[0] == 'z') direction=2;
    BRaceCheckpoints[bb(playerid)][BSelectedCheckpoint[bb(playerid)]][direction]=BRaceCheckpoints[bb(playerid)][BSelectedCheckpoint[bb(playerid)]][direction]+amount;
	BActiveCP(playerid,BSelectedCheckpoint[bb(playerid)]);
	return 1;
}

dcmd_dcp(playerid, params[])
{
	#pragma unused params
	if(RaceBuilders[playerid] == 0)
	{
		SendClientMessage(playerid, COLOUR_RED, "You are not building a race!");
		return 1;
	}
	else if(BCurrentCheckpoints[bb(playerid)] < 1)
	{
		SendClientMessage(playerid, COLOUR_YELLOW, "No checkpoint to delete!");
		return 1;
	}
	for(new i=BSelectedCheckpoint[bb(playerid)];i<BCurrentCheckpoints[bb(playerid)];i++)
	{
		BRaceCheckpoints[bb(playerid)][i][0]=BRaceCheckpoints[bb(playerid)][i+1][0];
		BRaceCheckpoints[bb(playerid)][i][1]=BRaceCheckpoints[bb(playerid)][i+1][1];
		BRaceCheckpoints[bb(playerid)][i][2]=BRaceCheckpoints[bb(playerid)][i+1][2];
	}
	BCurrentCheckpoints[bb(playerid)]--;
	BSelectedCheckpoint[bb(playerid)]--;
	if(BCurrentCheckpoints[bb(playerid)] < 1)
	{
	    DisablePlayerRaceCheckpoint(playerid);
	    BSelectedCheckpoint[bb(playerid)]=0;
		return 1;
	}
	else if(BSelectedCheckpoint[bb(playerid)] < 0)
	{
	    BSelectedCheckpoint[bb(playerid)]=0;
	}
	BActiveCP(playerid,BSelectedCheckpoint[bb(playerid)]);
	SendClientMessage(playerid,COLOUR_GREEN,"Checkpoint deleted!");
	return 1;
}

dcmd_rpickupmodel(playerid,params[])
{
	new tmp[32], idx, Model;
	tmp = strtok(params, idx);
	Model = strval(tmp);
	if(!strlen(tmp))
	{
		SendClientMessage(playerid, COLOUR_WHITE, "USAGE: /rpickupmodel [value (default 3096)]");
		return 1;
	}
	if(RaceBuilders[playerid] != 0)
	{
	    if(Model == 0) Model = 3096;
		BPickupModels[bb(playerid)] = Model;
		format(iString,sizeof(iString), "Race pickup model has been set to %i.", Model);
		SendClientMessage(playerid, COLOUR_GREEN, iString);
	}
	else SendClientMessage(playerid, COLOUR_RED, "You are not building a race!");
	return 1;
}

dcmd_rpickup(playerid,params[])
{
	new tmp[128], idx, Type, Vehicle[32], pickupids;
	tmp = strtok(params, idx);
	Type = strval(tmp);
	Vehicle = strtok(params, idx);
	if(RaceBuilders[playerid] < 1) return 1;
	if(!strlen(tmp))
	{
		SendClientMessage(playerid, COLOUR_WHITE, "USAGE: /rpickup [type (1 = repair, 2 = change vehicle)] [vehicle (if applicable)]");
		return 1;
	}
	for(new i=0;i<5;i++)
	{
		if(BPickupLocations[bb(playerid)][i][0] == 0)
		{
			pickupids = i;
			break;
		}
	}
	if(Type == 2)
	{
		if(!IsNumeric(Vehicle))
		{
		    new vehicle;
			vehicle = ReturnVehicleID(Vehicle);
			new vname[32]; vname = ReturnVehicleName(vehicle);
			if(vehicle == INVALID_VEHICLE_ID)
			{
			    if(vehicle != 1)
				{
					SendClientMessage(playerid, COLOUR_WHITE, "Invalid vehicle id.");
					return 1;
				}
			}
			else
			{
				format(iString,sizeof(iString), "Race vehicle has been set to %s.", vname);
				SendClientMessage(playerid, COLOUR_GREEN, iString);
				BPickupVehicles[bb(playerid)][pickupids] = vehicle;
				new Float:X, Float:Y, Float:Z;
				GetPlayerPos(playerid, X, Y, Z);
				BPickupLocations[bb(playerid)][pickupids][0] = X;
				BPickupLocations[bb(playerid)][pickupids][1] = Y;
				BPickupLocations[bb(playerid)][pickupids][2] = Z;
				BPickupModels[bb(playerid)] = vehicle;
				BPickupTypes[bb(playerid)][pickupids] = Type;
				format(iString,sizeof(iString), "Race pickup #%i vehicle has been set to %s (%i).", pickupids, ReturnVehicle(vehicle), vehicle);
				SendClientMessage(playerid, COLOUR_GREEN, iString);
				return 1;
			}
		}
		else SendClientMessage(playerid, COLOUR_RED, "Please use vehicle names, not id's!");
	}
	else if(Type == 1)
	{
	    BPickupTypes[bb(playerid)][pickupids] = Type;
	    new Float:X, Float:Y, Float:Z;
		GetPlayerPos(playerid, X, Y, Z);
		BPickupLocations[bb(playerid)][pickupids][0] = X;
		BPickupLocations[bb(playerid)][pickupids][1] = Y;
		BPickupLocations[bb(playerid)][pickupids][2] = Z;
	    format(iString,sizeof(iString), "Race repair pickup #%i has been created!", pickupids);
		SendClientMessage(playerid, COLOUR_GREEN, iString);
	}
	else SendClientMessage(playerid, COLOUR_RED, "Invalid race type! 1 = repair pickup, 2 = vehicle change");
	return 1;
}

dcmd_clearrace(playerid,params[])
{
	#pragma unused params
	if(PlayerEditing[playerid] == 1)
	{
		PlayerEditing[playerid] = false;
		SetPlayerVirtualWorld(playerid, 0);
		//SetPlayerGravity(playerid, 0.008);
		SetPlayerWeather(playerid, 10);
	}
	if(RaceBuilders[playerid] != 0)
	{
	    //SetPlayerGravity(playerid, 0.008);
	    SetPlayerWeather(playerid, 10);
		Cclearrace(playerid);
	}
	else SendClientMessage(playerid, COLOUR_RED, "You are not building a race!");
	return 1;
}

dcmd_editrace(playerid,params[])
{
	if(RaceBuilders[playerid] == 0)
	{
		SendClientMessage(playerid, COLOUR_RED, "You are not building a race!");
		return 1;
	}
	PlayerEditing[playerid] = true;
	if(BCurrentCheckpoints[bb(playerid)]>0) //Clear the old race if there is such.
	{
		for(new i=0;i<BCurrentCheckpoints[bb(playerid)];i++)
		{
			BRaceCheckpoints[bb(playerid)][i][0]=0.0;
			BRaceCheckpoints[bb(playerid)][i][1]=0.0;
			BRaceCheckpoints[bb(playerid)][i][2]=0.0;
		}
		BCurrentCheckpoints[bb(playerid)]=0;
	}
	new tmp[256],idx;
    tmp = strtok(params, idx);
    if(!strlen(tmp))
	{
		SendClientMessage(playerid, COLOUR_WHITE, "USAGE: /editrace [name]");
		return 1;
    }
	
	new race_name[32];
	//format(ERaceName,sizeof(ERaceName), "%s",tmp);
	format(race_name,sizeof(race_name), "/iRaces/%s.iR",tmp);
	if(!fexist(race_name)) return SendClientMessage(playerid, COLOUR_RED, "Error: Race doesn't exist!"); // File doesn't exist
	INI_Open(race_name);
	CFile=race_name;
    BCurrentCheckpoints[bb(playerid)]=-1; RLenght=0; RLenght=0;
    Rnos[bb(playerid)] = INI_ReadInt("Nos"); //Nos true/false
    Rworld[bb(playerid)] = INI_ReadInt("World"); //World id
    SetPlayerVirtualWorld(playerid, Rworld[bb(playerid)]);
	format(iString,sizeof(iString), "Your world has been set to %d.", Rworld[bb(playerid)]);
	SendClientMessage(playerid, COLOUR_YELLOW, iString);
	Rcar[bb(playerid)] = INI_ReadInt("Vehicle"); // Read off vehicle
	Rfix[bb(playerid)] = INI_ReadInt("AutoFix"); // Read off AutoFix
	Rweather[bb(playerid)] = INI_ReadInt("Weather"); // Read off Weather
	Bracemode[bb(playerid)] = INI_ReadInt("RaceMode"); // read off racemode
	Blaps[bb(playerid)] = INI_ReadInt("Laps"); // read off amount of laps
	BAirrace[bb(playerid)] = INI_ReadInt("AirRace");   // read off airrace
	BCPsize[bb(playerid)] = INI_ReadFloat("CPSize");    // read off CP size
	Racemode=ORacemode; Racelaps=ORacelaps; //Allows changing the modes, but disables highscores if they've been changed.
	BStartX[playerid] = INI_ReadFloat("Tcp/1");
	BStartY[playerid] = INI_ReadFloat("Tcp/2");
	BStartZ[playerid] = INI_ReadFloat("Tcp/3");
	BStartR[playerid] = INI_ReadFloat("Tcp/4");
	new i;
	for(new j=0;j<200;j++)
	{
		i = 0;
		BCurrentCheckpoints[bb(playerid)]++;
		format(iString,sizeof(iString), "CPs/%d", BCurrentCheckpoints[bb(playerid)]);
		INI_ReadString(iString, iString);
		BRaceCheckpoints[bb(playerid)][BCurrentCheckpoints[bb(playerid)]][0] = floatstr(strtok(iString,i));

		if(BRaceCheckpoints[bb(playerid)][BCurrentCheckpoints[bb(playerid)]][0] > -1 && BRaceCheckpoints[bb(playerid)][BCurrentCheckpoints[bb(playerid)]][0] < 1)
		{
			j=200;
		}

		BRaceCheckpoints[bb(playerid)][BCurrentCheckpoints[bb(playerid)]][1] = floatstr(strtok(iString,i));
		BRaceCheckpoints[bb(playerid)][BCurrentCheckpoints[bb(playerid)]][2] = floatstr(strtok(iString,i));
	}
	SetPlayerPos(playerid, BStartX[playerid], BStartY[playerid], BStartZ[playerid]);
	BCurrentCheckpoints[bb(playerid)]--; // # of next CP to be created
	format(iString,sizeof(iString),"Race \"%s\" has been loaded for editing. (%d checkpoints, vehicle: %d)",tmp,BCurrentCheckpoints[bb(playerid)], Rcar[bb(playerid)]);
	SendClientMessage(playerid, COLOUR_GREEN,iString);
	
	INI_Close();
    return 1;
}

dcmd_racemaker(playerid, params[])
{
	new id;
	new tmp[256], idx;
	tmp = strtok(params, idx);
	new idname[64], playername[64];

	if(IsNotAdmin(playerid)) return 1;

	if(GetAdminLevel(playerid) < 4)
	{
	    SendClientMessage(playerid, COLOUR_RED, "You need to be level 4 to use this command!");
	    return 1;
	}
	if(!strlen(tmp))
	{
		SendClientMessage(playerid, COLOUR_WHITE, "USAGE: /racemaker [player id/player name]");
		return 1;
	}
	
	if(IsNumeric(tmp)) id = strval(tmp);
	else
	{
    	id = FindPlayer( tmp );
	}
	GetPlayerName(id, idname, 64);
	GetPlayerName(playerid, playername, 64);

    SendClientMessage(playerid, COLOUR_RED, "Please ensure that players know how to build races before giving them admin!");

	if(IsPlayerConnected(id) == 0)
	{
		format(iString, sizeof(iString), "ERROR: %d is not a valid playerid!", id);
		SendClientMessage(playerid, COLOUR_RED, iString);
		return 1;
	}

	if(TempRaceMaker[id] == 1)
	{
	    TempRaceMaker[id] = 0;
	    format(iString, sizeof(iString), "%s has been revoked of temp race making abilities by %s.", idname, playername);
		SendClientMessage(playerid, COLOUR_RED, iString);
		if(playerid != id) SendClientMessage(id, COLOUR_RED, iString);
		AddAdminLogLine(COLOUR_RED, iString);
	}
	else if(TempRaceMaker[id] == 0)
	{
	    TempRaceMaker[id] = 1;
	    format(iString, sizeof(iString), "%s has been given temp race making abilities by %s.", idname, playername);
		SendClientMessage(playerid, COLOUR_GREEN, iString);
		if(playerid != id) SendClientMessage(id, COLOUR_GREEN, iString);
		AddAdminLogLine(COLOUR_YELLOW, iString);
	}
	return 1;
}

dcmd_checkpoint(playerid, params[])
{
	#pragma unused params
	if(RaceParticipant[playerid] < 2) return 0;
	new CheckpointR;
	CheckpointR = (CurrentCheckpoint[playerid]-1);
	if(IsPlayerInAnyVehicle(playerid)) SetVehiclePos(GetPlayerVehicleID(playerid),RaceCheckpoints[CheckpointR][0],RaceCheckpoints[CheckpointR][1],RaceCheckpoints[CheckpointR][2]);
	else if(racevehicle[playerid] != 1)
	{
		DestroyVehicle(GetPlayerVehicleID(playerid));
		PlayerVehicle[playerid] = CreateVehicle(racevehicle[playerid], RaceCheckpoints[CheckpointR][0], RaceCheckpoints[CheckpointR][1], RaceCheckpoints[CheckpointR][2], 0, -1, -1, 9999999);
		new rand = random(MAX_CARCOLOURS);
		new rand2 = random(MAX_CARCOLOURS);
		ChangeVehicleColor(PlayerVehicle[playerid], CarColours[rand], CarColours[rand2]);
		SetVehicleVirtualWorld(PlayerVehicle[playerid], RaceWorld);
		if(Nitrous != 0) AddVehicleComponent(PlayerVehicle[playerid], 1010);
		for(new j;j<MAX_PLAYERS;j++){
		if(!IsPlayerConnected(j)) continue;
		if(j == playerid) continue;
		SetVehicleParamsForPlayer(PlayerVehicle[playerid], j, false, true);
		}
	}
    SetPlayerPos(playerid,RaceCheckpoints[CheckpointR][0],RaceCheckpoints[CheckpointR][1],RaceCheckpoints[CheckpointR][2]);
    PutPlayerInVehicle(playerid, PlayerVehicle[playerid], 0);
    SendClientMessage(playerid, COLOUR_RED, "You have been returned to the previous checkpoint!");
    return 1;
}

dcmd_rflip(playerid, params[])
{
	#pragma unused params
	if(RaceParticipant[playerid] < 2) return 0;
	if(IsPlayerInAnyVehicle(playerid) == 1)
	{
	 	new Float:Angle;
 		GetVehicleZAngle(GetPlayerVehicleID(playerid), Angle);
		SetVehicleZAngle(GetPlayerVehicleID(playerid), Angle);
	}
	else
	{
		SendClientMessage(playerid, COLOUR_RED, "You have to be in a vehicle to flip!");
	}
	return 1;
}

dcmd_rnos(playerid, params[])
{
	#pragma unused params
	if(RaceBuilders[playerid] != 0)
	{
		if(Rnos[bb(playerid)] == 0)
		{
            if(IsNosVehicleInvalid(Rcar[bb(playerid)])) return SendClientMessage(playerid, COLOUR_YELLOW, "Nitrous cannot be applied to the current race vehicle!");
			Rnos[bb(playerid)] = 1;
			SendClientMessage(playerid, COLOUR_YELLOW, "Nitrous has been turned on for the current race!");
		}
		else if(Rnos[bb(playerid)] == 1)
		{
			Rnos[bb(playerid)] = 0;
			SendClientMessage(playerid, COLOUR_YELLOW, "Nitrous has been turned on for the current race!");
		}
	}
	else SendClientMessage(playerid, COLOUR_RED, "You are not building a race!");
	return 1;
}

dcmd_rgravity(playerid, params[])
{
	new Float:grav;
	new tmp[256], idx;
	tmp = strtok(params, idx);
	grav = floatstr(tmp);
	if(!strlen(tmp))
	{
		SendClientMessage(playerid, COLOUR_WHITE, "USAGE: /rgravity [value (default 0.008)]");
		return 1;
	}
	
	if(RaceBuilders[playerid] != 0)
	{
		//SetPlayerGravity(playerid, grav);
		Rgravity[bb(playerid)] = grav;
		format(iString,sizeof(iString), "Race gravity set to %f.", grav);
		SendClientMessage(playerid, COLOUR_GREEN, iString);
	}
	else SendClientMessage(playerid, COLOUR_RED, "You are not building a race!");
	return 1;
}

dcmd_rweather(playerid, params[])
{
	if(RaceBuilders[playerid] != 0)
	{
		new tmp[256], idx;
	    tmp = strtok(params, idx);
	    if(strfind(tmp, "rain", true) != -1)
	    {
            Rweather[bb(playerid)] = 8;
            SendClientMessage(playerid, COLOUR_GREEN, "Race weather set to rain.");
            SetPlayerWeather(playerid, 8);
	    }
	    else if(strfind(tmp, "clear", true) != -1 || strfind(tmp, "sunny", true) != -1)
	    {
            Rweather[bb(playerid)] = 1;
            SendClientMessage(playerid, COLOUR_GREEN, "Race weather set to clear.");
            SetPlayerWeather(playerid, 0);
	    }
	    else if(strfind(tmp, "foggy", true) != -1 || strfind(tmp, "fog", true) != -1)
	    {
            Rweather[bb(playerid)] = 9;
            SendClientMessage(playerid, COLOUR_GREEN, "Race weather set to foggy.");
            SetPlayerWeather(playerid, 9);
	    }
	    else if(strfind(tmp, "hurricane", true) != -1 || strfind(tmp, "storm", true) != -1)
	    {
            Rweather[bb(playerid)] = -68;
            SendClientMessage(playerid, COLOUR_GREEN, "Race weather set to hurricane.");
            SetPlayerWeather(playerid, -68);
	    }
	    else if(strfind(tmp, "drawdist", true) != -1)
	    {
            Rweather[bb(playerid)] = 1337;
            SendClientMessage(playerid, COLOUR_GREEN, "Race weather set to massive draw distance.");
            SetPlayerWeather(playerid, 1337);
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOUR_RED, "Error: Invalid weather name: Use 'clear', 'rain', 'hurricane', 'fog' or 'drawdist'");
	        return 1;
	    }
	}
	else SendClientMessage(playerid, COLOUR_RED, "You are not building a race!");
	return 1;
}

dcmd_rworld(playerid, params[])
{
	if(RaceBuilders[playerid] != 0)
	{
		new worldid;
		new tmp[256], idx, str[64];
	    tmp = strtok(params, idx);
	    worldid = strval(tmp);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOUR_WHITE, "USAGE: /rworld [worldid]");
			return 1;
		}
		if(worldid != 0) if(worldid > 110 || worldid < 100) return SendClientMessage(playerid, COLOUR_RED, "Error: The world id must be 0, or between 100 and 110");
		Rworld[bb(playerid)] = worldid;
		format(str,sizeof(str), "Race world & your current world have been set to %d.", worldid);
		SetPlayerVirtualWorld(playerid, worldid);
		SendClientMessage(playerid, COLOUR_GREEN, str);
	}
	else
	{
		SendClientMessage(playerid, COLOUR_RED, "You are not building a race!");
	}
	return 1;
}

dcmd_rvehicle(playerid, params[])
{
	if(RaceBuilders[playerid] != 0)
	{
		new carid;
		new tmp[256], idx, str[64], vehicle;
	    tmp = strtok(params, idx);
	    carid = strval(tmp);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOUR_WHITE, "USAGE: /car [car id]");
			return 1;
		}
		if(!IsNumeric(tmp))
		{
			vehicle = ReturnVehicleID(tmp);
			new vname[32]; vname = ReturnVehicleName(vehicle);
			if(vehicle == INVALID_VEHICLE_ID)
			{
			    SendClientMessage(playerid, COLOUR_WHITE, "Invalid vehicle id.");
				return 1;
			}
			else
			{
				format(str,sizeof(str), "Race vehicle has been set to %s.", vname);
				if(IsNosVehicleInvalid(Rcar[bb(playerid)]) && Rnos[bb(playerid)] == 1)
				{
				    SendClientMessage(playerid, COLOUR_WHITE, "Nitrous will not work with this race vehicle, so it has been disabled.");
                    Rnos[bb(playerid)] = 0;
				}
				SendClientMessage(playerid, COLOUR_GREEN, str);
				Rcar[bb(playerid)] = vehicle;
				return 1;
			}
		}
		if(carid != INVALID_VEHICLE_ID)
		{
			format(str,sizeof(str), "Vehicle has been set to %d.",carid);
			SendClientMessage(playerid, COLOUR_GREEN, str);
			Rcar[bb(playerid)] = carid;
			if(IsNosVehicleInvalid(Rcar[bb(playerid)]) && Rnos[bb(playerid)] == 1)
			{
   				SendClientMessage(playerid, COLOUR_WHITE, "Nitrous will not work with this race vehicle, so it has been disabled.");
                Rnos[bb(playerid)] = 0;
			}
		}
		else SendClientMessage(playerid, COLOUR_RED, "Invalid car id!");
	}
	else
	{
		SendClientMessage(playerid, COLOUR_RED, "You are not building a race!");
	}
	return 1;
}

dcmd_saverace(playerid, params[])
{
	if(BStartX[playerid] == 0 && PlayerEditing[playerid] == 0)
	{
	    SendClientMessage(playerid, COLOUR_RED, "You have not set the start point with /tcp!");
	    return 1;
	}
	if(RaceBuilders[playerid] != 0)
	{
		new tmp[256], idx;
	    tmp = strtok(params, idx);
	    if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOUR_WHITE, "USAGE: /saverace [name]");
			return 1;
	    }
	    if(BCurrentCheckpoints[bb(playerid)] < 2)
	    {
	        SendClientMessage(playerid, COLOUR_YELLOW, "You need atleast 2 checkpoints to save!");
	        return 1;
	    }
		new race_name[32],templine[42];
		format(race_name, 32, "/iRaces/%s.iR",tmp);
		if(fexist(race_name) && PlayerEditing[playerid] == 0)
		{
			format(iString,sizeof(iString), "Race \"%s\" already exists.",tmp);
			SendClientMessage(playerid, COLOUR_RED, iString);
			return 1;
  		}

		format(race_name, 32, "/iRaces/%s.iR",tmp);
		new Bcreator[MAX_PLAYER_NAME];
		GetPlayerName(playerid, Bcreator, MAX_PLAYER_NAME);
		format(iString, sizeof(iString), "%s has created the race %s!", Bcreator, tmp);
		SendClientMessageToAll(COLOUR_GREEN, iString);
		
		INI_Open(race_name);
		INI_WriteInt("Vehicle", Rcar[bb(playerid)]);
		INI_WriteInt("AutoFix", Rfix[bb(playerid)]);
		INI_WriteString("Creator", Bcreator);
		INI_WriteInt("Nos", Rnos[bb(playerid)]);
		INI_WriteInt("World", Rworld[bb(playerid)]);
		INI_WriteInt("Weather", Rweather[bb(playerid)]);
		INI_WriteInt("RaceMode", Bracemode[bb(playerid)]);
		INI_WriteInt("Laps", Blaps[bb(playerid)]);
		INI_WriteInt("AirRace", BAirrace[bb(playerid)]);
		INI_WriteFloat("CPSize", BCPsize[bb(playerid)]);
		INI_WriteString("RaceName", tmp);
		INI_WriteFloat("Gravity", Rgravity[bb(playerid)]);

		// Pickups
		if(BPickupModels[bb(playerid)] == 0) BPickupModels[bb(playerid)] = 3096;
		//INI_WriteInt("PickupModel", BPickupModels[bb(playerid)]);
		INI_WriteInt("PickupModel", 3096);
		
		format(iString, sizeof(iString), "%f %f %f", BPickupLocations[bb(playerid)][0][0], BPickupLocations[bb(playerid)][0][1], BPickupLocations[bb(playerid)][0][2]);
		INI_WriteString("PickupLocations0", iString);
		format(iString, sizeof(iString), "%f %f %f", BPickupLocations[bb(playerid)][1][0], BPickupLocations[bb(playerid)][1][1], BPickupLocations[bb(playerid)][1][2]);
		INI_WriteString("PickupLocations1", iString);
		format(iString, sizeof(iString), "%f %f %f", BPickupLocations[bb(playerid)][2][0], BPickupLocations[bb(playerid)][2][1], BPickupLocations[bb(playerid)][2][2]);
		INI_WriteString("PickupLocations2", iString);
		format(iString, sizeof(iString), "%f %f %f", BPickupLocations[bb(playerid)][3][0], BPickupLocations[bb(playerid)][3][1], BPickupLocations[bb(playerid)][3][2]);
		INI_WriteString("PickupLocations3", iString);
		format(iString, sizeof(iString), "%f %f %f", BPickupLocations[bb(playerid)][4][0], BPickupLocations[bb(playerid)][4][1], BPickupLocations[bb(playerid)][4][2]);
		INI_WriteString("PickupLocations4", iString);
		
		INI_WriteInt("PickupType0", BPickupTypes[bb(playerid)][0]);
		INI_WriteInt("PickupType1", BPickupTypes[bb(playerid)][1]);
		INI_WriteInt("PickupType2", BPickupTypes[bb(playerid)][2]);
		INI_WriteInt("PickupType3", BPickupTypes[bb(playerid)][3]);
		INI_WriteInt("PickupType4", BPickupTypes[bb(playerid)][4]);
		
		INI_WriteInt("PickupVehicle0", BPickupVehicles[bb(playerid)][0]);
		INI_WriteInt("PickupVehicle1", BPickupVehicles[bb(playerid)][1]);
		INI_WriteInt("PickupVehicle2", BPickupVehicles[bb(playerid)][2]);
		INI_WriteInt("PickupVehicle3", BPickupVehicles[bb(playerid)][3]);
		INI_WriteInt("PickupVehicle4", BPickupVehicles[bb(playerid)][4]);
		
		INI_WriteString("RaceTimesName/0", "A");
		INI_WriteInt("RaceTimesTime/0", 0);
		INI_WriteString("RaceTimesName/1", "A");
		INI_WriteInt("RaceTimesTime/1", 0);
		INI_WriteString("RaceTimesName/2", "A");
		INI_WriteInt("RaceTimesTime/2", 0);
		INI_WriteString("RaceTimesName/3", "A");
		INI_WriteInt("RaceTimesTime/3", 0);
		INI_WriteString("RaceTimesName/4", "A");
		INI_WriteInt("RaceTimesTime/4", 0);

        INI_WriteString("LapTimesName/0", "A");
		INI_WriteInt("LapTimesTime/0", 0);
		INI_WriteString("LapTimesName/1", "A");
		INI_WriteInt("LapTimesTime/1", 0);
		INI_WriteString("LapTimesName/2", "A");
		INI_WriteInt("LapTimesTime/2", 0);
		INI_WriteString("LapTimesName/3", "A");
		INI_WriteInt("LapTimesTime/3", 0);
		INI_WriteString("LapTimesName/4", "A");
		INI_WriteInt("LapTimesTime/4", 0);
		
		INI_WriteFloat("Tcp/1", BStartX[playerid]);
		INI_WriteFloat("Tcp/2", BStartY[playerid]);
		INI_WriteFloat("Tcp/3", BStartZ[playerid]);
		INI_WriteFloat("Tcp/4", BStartR[playerid]);
		for(new i = 0; i < BCurrentCheckpoints[bb(playerid)]+1;i++)
		{
		    if(BRaceCheckpoints[bb(playerid)][i][0] == 0) break;
			format(iString,sizeof(iString),"%f %f %f",BRaceCheckpoints[bb(playerid)][i][0], BRaceCheckpoints[bb(playerid)][i][1], BRaceCheckpoints[bb(playerid)][i][2]);
  			format(templine,sizeof(templine),"CPs/%d",i);
			INI_WriteString(templine, iString);
		}
		
		INI_Save();
		INI_Close();
		
		format(iString,sizeof(iString),"Your race \"%s\" has been saved.",tmp);
   		SendClientMessage(playerid, COLOUR_GREEN, iString);

		if(!PlayerEditing[playerid])
		{
 			new File:f;
			f = fopen("iRaces/iList.iRf",io_append);
			format(iString, sizeof(iString), "%s %s\n", tmp, Bcreator);
			fwrite(f,iString);
			fclose(f);
		}
		SetPlayerWeather(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
	}
	else
	{
		SendClientMessage(playerid, COLOUR_RED, "You are not building a race!");
	}
	return 1;
}

dcmd_setlaps(playerid,params[])
{
	new tmp[256], idx;
    tmp = strtok(params, idx);
    if(!strlen(tmp) || strval(tmp) <= 0)
	{
		SendClientMessage(playerid, COLOUR_WHITE, "USAGE: /setlaps [amount of laps (min: 1)]");
		return 1;
   	}
	if(RaceBuilders[playerid] != 0)
    {
		Blaps[bb(playerid)] = strval(tmp);
		format(tmp,sizeof(tmp),"Amount of laps set to %d.", Blaps[bb(playerid)]);
		SendClientMessage(playerid, COLOUR_GREEN, tmp);
        return 1;
    }
	if(RaceAdmin == 1 && IsNotAdmin(playerid)) return 1;
	if(RaceActive == 1 || RaceStart == 1) SendClientMessage(playerid, COLOUR_RED, "Race already in progress!");
	else if(LCurrentCheckpoint == 0) SendClientMessage(playerid, COLOUR_YELLOW, "No race loaded.");
	else
	{
	    Racelaps=strval(tmp);
		format(tmp,sizeof(tmp),"Amount of laps set to %d for current race.", Racelaps);
		SendClientMessage(playerid, COLOUR_GREEN, tmp);
	}
	return 1;
}

dcmd_racemode(playerid,params[])
{
	new tmp[256], idx, tempmode;
    tmp = strtok(params, idx);
    if(!strlen(tmp))
	{
		SendClientMessage(playerid, COLOUR_WHITE, "USAGE: /racemode [0/1/2/3]");
		return 1;
   	}
	if(tmp[0] == 'd') tempmode=0;
	else if(tmp[0] == 'r') tempmode=1;
	else if(tmp[0] == 'y') tempmode=2;
	else if(tmp[0] == 'm') tempmode=3;
	else tempmode=strval(tmp);

	if (0 > tempmode || tempmode > 3)
   	{
   	    SendClientMessage(playerid, COLOUR_YELLOW, "Invalid racemode!");
		return 1;
   	}
	if(RaceBuilders[playerid] != 0)
    {
		if(tempmode == 2 && BCurrentCheckpoints[bb(playerid)] < 3)
		{
		    SendClientMessage(playerid, COLOUR_YELLOW, "Can't set racemode 2 on races with only 2 CPs. Changing to mode 1 instead.");
		    Bracemode[bb(playerid)] = 1;
		    return 1;
		}
		Bracemode[bb(playerid)] = tempmode;
		format(tmp,sizeof(tmp),"Racemode set to %d.", Bracemode[bb(playerid)]);
		SendClientMessage(playerid, COLOUR_GREEN, tmp);
        return 1;
    }
	if(RaceAdmin == 1 && IsNotAdmin(playerid)) return 1;
	if(RaceActive == 1 || RaceStart == 1) SendClientMessage(playerid, COLOUR_RED, "Race already in progress!");
	else if(LCurrentCheckpoint == 0) SendClientMessage(playerid, COLOUR_YELLOW, "No race loaded.");
	else
	{
		if(tempmode == 2 && LCurrentCheckpoint < 2)
		{
		    SendClientMessage(playerid, COLOUR_YELLOW, "Can't set racemode 2 on races with only 2 CPs. Changing to mode 1 instead.");
		    Racemode = 1;
		    return 1;
		}
	    Racemode=tempmode;
		format(tmp,sizeof(tmp),"Racemode set to %d.", Racemode);
		SendClientMessage(playerid, COLOUR_GREEN, tmp);
	}
	return 1;
}

dcmd_loadrace(playerid, params[])
{
	if(RaceAdmin == 1 && IsNotAdmin(playerid)) return 1;
	Racemode = 0; Racelaps = 1;
	new tmp[128], idx;
    tmp = strtok(params, idx);
    if(!strlen(tmp))
	{
		SendClientMessage(playerid, COLOUR_WHITE, "USAGE: /loadrace [name]");
		return 1;
    }
    Cendrace();
    new name[32];
    GetPlayerName(playerid, name, 32);
    if(strcmp(tmp, "rand", true, 4) == 0 || strcmp(tmp, "random", true, 6) == 0)
    {
		LoadRandom();
		
		format(iString,sizeof(iString),"%s has loaded a random race: %s", name, CRaceName);
		SendClientMessageToAll(COLOUR_ORANGE, iString);
		AddAdminLogLine(COLOUR_YELLOW, iString);
    }
    else
	{
		fback=LoadRace(tmp);
		if(fback < 0)
		{
			format(iString,sizeof(iString),"Race \'%s\' doesn't exist!",tmp);
			SendClientMessage(playerid, COLOUR_RED, iString);
			printf("error: %s", tmp);
			return 1;
		}
        format(iString,sizeof(iString),"%s has used the race command /loadrace to load %s", name, tmp);
    	AddAdminLogLine(COLOUR_YELLOW, iString);
    	SendClientMessageToAll(COLOUR_ORANGE,iString);
	}
	if(LCurrentCheckpoint<2 && Racemode == 2)
	{
	    Racemode = 1; // Racemode 2 doesn't work well with only 2CPs, and mode 1 is just the same when playing with 2 CPs.
	}                 // Setting racemode 2 is prevented from racebuilder so this shouldn't happen anyways.
	Cstartrace();
	return 1;
}

dcmd_loadracemenu(playerid, params[])
{
	if(RaceAdmin == 1 && IsNotAdmin(playerid)) return 1;
	Racemode = 0; Racelaps = 1;
	new tmp[128], idx;
    tmp = strtok(params, idx);
    if(!strlen(tmp))
	{
		SendClientMessage(playerid, COLOUR_WHITE, "USAGE: /loadracemenu [name]");
		return 1;
    }
    if(RaceActive == 1)
    {
		SendClientMessage(playerid, COLOUR_RED, "A race is already active!");
		return 1;
    }
	fback=LoadRace(tmp);
	if(fback == -1) format(iString,sizeof(iString),"Race \'%s\' doesn't exist!",tmp);
	else if (fback == -2) format(iString,sizeof(iString),"Race \'%s\' is created with a newer version of RacerX, cannot load.",tmp);
	if(fback < 0)
	{
	    SendClientMessage(playerid,COLOUR_RED,iString);
	    return 1;
	}
	new name[64], str[128];
    GetPlayerName(playerid, name, 32);
    format(iString,sizeof(iString),"%s has used the race command /loadrace", name);
    AddAdminLogLine(COLOUR_YELLOW, iString);
	GetPlayerName(playerid, name, 64);
	format(str,sizeof(str),"%s has loaded a race!",name);
	SendClientMessageToAll(COLOUR_GREEN,str);
	//format(iString,sizeof(iString),"Race \'%s\' loaded, /startrace to start it. You can change laps and mode before that.",CRaceName);
	//SendClientMessage(playerid,COLOUR_GREEN,iString);
	if(LCurrentCheckpoint<2 && Racemode == 2)
	{
	    Racemode = 1; // Racemode 2 doesn't work well with only 2CPs, and mode 1 is just the same when playing with 2 CPs.
	}                 // Setting racemode 2 is prevented from racebuilder so this shouldn't happen anyways.
	if(!IsValidMenu(MRace)) CreateRaceMenus();
	if(Airrace == 0) SetMenuColumnHeader(MRace,0,"Air race: off");
	else SetMenuColumnHeader(MRace,0,"Air race: ON");
	TogglePlayerControllable(playerid,0);
	ShowMenuForPlayer(MRace,playerid);
	return 1;
}

dcmd_startrace(playerid, params[])
{
	#pragma unused params
    if(RaceAdmin == 1 && IsNotAdmin(playerid)) return 1;
	if(LCurrentCheckpoint == 0) SendClientMessage(playerid,COLOUR_YELLOW,"No race loaded!");
	else if (RaceActive == 1) SendClientMessage(playerid,COLOUR_YELLOW,"Race is already active!");
	else Cstartrace();
	return 1;
}


dcmd_deleterace(playerid, params[])
{
	if((RaceAdmin == 1 || BuildAdmin == 1) && IsNotAdmin(playerid)) return 1;
	new filename[128], idx, fname[128];
	filename = strtok(params,idx);
	fname = filename;
	if(!(strlen(filename)))
	{
	    SendClientMessage(playerid, COLOUR_WHITE, "USAGE: /deleterace [race]");
	    return 1;
	}
	format(filename,sizeof(filename),"iRaces/%s.iR",filename);
	if(!fexist(filename))
	{
		format(iString,sizeof(iString), "The race \"%s\" doesn't exist.",filename);
		SendClientMessage(playerid, COLOUR_RED, iString);
		return 1;
	}
	fremove(filename);
	if(fdeleteline("/iRaces/iList.iRf", fname))
	{
		SendClientMessage(playerid, COLOUR_GREEN, "iList line removed!");
	}
	else
	{
		SendClientMessage(playerid, COLOUR_GREEN, "iList line not removed!");
	}
	format(iString,sizeof(iString), "The race \"%s\" has been deleted.",fname);
	SendClientMessage(playerid, COLOUR_GREEN, iString);
	return 1;
}

dcmd_rjoin(playerid,params[])
{
	#pragma unused params
	//TogglePlayerSpectating(playerid, false);
	SetPlayerVirtualWorld(playerid, 0);
	if(RaceBuilders[playerid] != 0)
	{
	    SendClientMessage(playerid, COLOUR_YELLOW, "You are currently building a race, can't join. Use /clearrace to exit build mode.");
	    return 1;
	}
	if(RaceParticipant[playerid]>0)
	{
	    SendClientMessage(playerid, COLOUR_YELLOW, "You've already joined the race!");
	}
	else if(RaceActive==1 && RaceStart==0)
	{
		if(GetPlayerMoney(playerid) < JoinFee)
		{
			format(iString,sizeof(iString),"You don't have enough money to join the race! (Join fee: %d$)",JoinFee);
			SendClientMessage(playerid, COLOUR_YELLOW, iString);
			return 1;
		}
		CurrentCheckpoint[playerid]=0;
		if(Racemode == 3)
		{
		    SetPlayerVirtualWorld(playerid, 0);
			SetRaceCheckpoint(playerid,LCurrentCheckpoint,LCurrentCheckpoint-1);
			CurrentCheckpoint[playerid]=LCurrentCheckpoint;
		}
		else GetPlayerPos(playerid, xsave[playerid], ysave[playerid], zsave[playerid]);
		SendClientMessage(playerid, COLOUR_YELLOW, "Use /flip to flip your vehicle, and /checkpoint to return to the previous checkpoint!");
		interiorsave[playerid] = GetPlayerInterior(playerid);
		worldsave[playerid] = GetPlayerVirtualWorld(playerid);
		SetPlayerVirtualWorld(playerid, 0);
		SetRaceCheckpoint(playerid,0,1);
		RaceParticipant[playerid]=1;
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid,StartX,StartY,StartZ);
		SetPlayerWeather(playerid, RWeather);
		SetPlayerFacingAngle(playerid, StartR);
		SetPlayerFacingAngle(playerid, atan2(RaceCheckpoints[0][0] - RaceCheckpoints[1][0], RaceCheckpoints[1][1] - RaceCheckpoints[0][1]));
		CurrentLap[playerid]=0;
		SetCameraBehindPlayer(playerid);
		Participants++;
	}
	else if(RaceActive==1 && RaceStart==1)
	{
	    SendClientMessage(playerid, COLOUR_YELLOW, "The race has already started, can't join.");
	}
	else
	{
	    SendClientMessage(playerid, COLOUR_YELLOW, "There is no race you can join.");
	}
	return 1;
}

dcmd_rleave(playerid,params[])
{
	#pragma unused params
	if(RaceParticipant[playerid] > 0)
	{
		TogglePlayerControllable(playerid, true);
		SetPlayerVirtualWorld(playerid, 0);
		KillTimer(TimeTimer[playerid]);
    	TextDrawHideForPlayer(playerid, Time);
    	TextDrawHideForPlayer(playerid, Partici);
    	TextDrawHideForPlayer(playerid, TCountdown);
    	TextDrawHideForPlayer(playerid, Position[playerid]);
    	TextDrawHideForPlayer(playerid, TPosition[playerid]);
    	//TextDrawHideForPlayer(playerid, Diff[playerid]);
    	TextDrawHideForPlayer(playerid, Append1), TextDrawHideForPlayer(playerid, Append2), TextDrawHideForPlayer(playerid, Append3), TextDrawHideForPlayer(playerid, Append4);
		if(racevehicle[playerid] != 1)
		{
			if(GetVehicleVirtualWorld(PlayerVehicle[playerid]) == RaceWorld)
			{
				DestroyVehicle(PlayerVehicle[playerid]);
			}
		}
		DisablePlayerRaceCheckpoint(playerid);
		RaceParticipant[playerid]=0;
		Participants--;
		SendClientMessage(playerid,COLOUR_YELLOW,"You have left the race.");
		SetPlayerInterior(playerid, interiorsave[playerid]);
		SetPlayerVirtualWorld(playerid, worldsave[playerid]);
		SetPlayerPos(playerid, xsave[playerid], ysave[playerid], zsave[playerid]);
		//SetPlayerGravity(playerid, 0.008);
  		if(RaceStart == 1)
  		{
        	if(Participants == 0)
			{
			    new ender;
				for(new i=0;i<MAX_PLAYERS;i++)
				{
				    if(GetPlayerVirtualWorld(i) == RaceWorld) continue;
				    ender = 1;
				}
				if(ender == 1) endraceload();
			}
		}
	}
	else SendClientMessage(playerid, COLOUR_YELLOW, "You aren't in a race.");
    return 1;
}

dcmd_endrace(playerid, params[])
{
	#pragma unused params
	if(RaceAdmin == 1 && IsNotAdmin(playerid)) return 1;
    if(RaceActive==0)
    {
        SendClientMessage(playerid, COLOUR_YELLOW, "There is no race active.");
		return 1;
    }
    new Name[32];
    GetPlayerName(playerid, Name, 32);
    format(iString,sizeof(iString),"%s has used the race command /endrace", Name);
    AddAdminLogLine(COLOUR_YELLOW, iString);
    Cendrace();
	return 1;
}

dcmd_bestlap(playerid,params[])
{
	new tmp[64], idx;
    tmp = strtok(params, idx);
	if(LoadTimes(playerid,1,tmp)) return 1;
	if(TopLapTimes[0] == 0)
	{
	    SendClientMessage(playerid,COLOUR_YELLOW,"No scores available.");
		return 1;
	}
	else if(ORacemode == 0)
	{
	    SendClientMessage(playerid,COLOUR_YELLOW,"This race doesn't have any laps.");
		return 1;
	}
	format(iString,sizeof(iString),"%s by %s - Best Laps:",CRaceName,CBuilder);
	SendClientMessage(playerid,COLOUR_GREEN,iString);
	for(new i;i<5;i++)
	{
		if(TopLapTimes[i] == 0)
		{
		    format(iString,sizeof(iString),"%d. None yet",i+1);
			i=6;
		}
		else
		{
	 	   format(iString,sizeof(iString),"%d. %s - %s",i+1,BeHumanR(TopLapTimes[i]),TopLappers[i]);
	    }
	    SendClientMessage(playerid,COLOUR_GREEN,iString);
	}
    return 1;
}

dcmd_bestrace(playerid,params[])
{
	new tmp[64], idx;
    tmp = strtok(params, idx);
	if(LoadTimes(playerid,0,tmp)) return 1;
	if(TopRacerTimes[0] == 0)
	{
	    SendClientMessage(playerid,COLOUR_YELLOW,"No scores available.");
		return 1;
	}
	format(iString,sizeof(iString),"%s by %s - Best Race times:",CRaceName,CBuilder);
	SendClientMessage(playerid,COLOUR_GREEN,iString);
	for(new i;i<5;i++)
	{
		if(TopRacerTimes[i] == 0)
		{
		    format(iString,sizeof(iString),"%d. None yet",i+1);
			i=6;
		}
		else
		{
	 	   format(iString,sizeof(iString),"%d. %s - %s",i+1,BeHumanR(TopRacerTimes[i]),TopRacers[i]);
	    }
	    SendClientMessage(playerid,COLOUR_GREEN,iString);
	}
    return 1;
}

dcmd_airrace(playerid,params[])
{
	#pragma unused params
	if(RaceBuilders[playerid] != 0)
	{
	    if(BAirrace[bb(playerid)] == 0)
	    {
	        SendClientMessage(playerid,COLOUR_GREEN,"Air race enabled.");
			BAirrace[bb(playerid)]=1;
	    }
	    else
	    {
	        SendClientMessage(playerid,COLOUR_GREEN,"Air race disabled.");
			BAirrace[bb(playerid)]=0;
	    }
		return 1;
	}
	if(RaceAdmin == 1 && IsNotAdmin(playerid)) return 1;
	if(RaceActive == 1 || RaceStart == 1) SendClientMessage(playerid, COLOUR_YELLOW, "Race is already in progress!");
	else if(LCurrentCheckpoint == 0) SendClientMessage(playerid, COLOUR_YELLOW, "No race loaded!");
	else if(Airrace == 0)
    {
        SendClientMessage(playerid,COLOUR_GREEN,"Air race enabled.");
		Airrace = 1;
    }
    else if(Airrace == 1)
    {
        SendClientMessage(playerid,COLOUR_GREEN,"Air race disabled.");
		Airrace = 0;
    }
    else printf("Error in /airrace detected. RaceActive: %d, RaceStart: %d LCurrentCheckpoint: %d, Airrace: %d", RaceActive,RaceStart,LCurrentCheckpoint,Airrace);
	return 1;
}

dcmd_cpsize(playerid,params[])
{
	new idx, tmp[32];
	tmp = strtok(params,idx);
	if(!(strlen(tmp)) || floatstr(tmp) <= 0.0)
	{
	    SendClientMessage(playerid,COLOUR_WHITE,"USAGE: /cpsize [size]");
	    return 1;
	}
	if(RaceBuilders[playerid] != 0)
	{
	    BCPsize[bb(playerid)] = floatstr(tmp);
	    format(iString,sizeof(iString),"Checkpoint size set to %f",floatstr(tmp));
		SendClientMessage(playerid,COLOUR_GREEN,iString);
	    return 1;
	}
	if(RaceAdmin == 1 && IsNotAdmin(playerid)) return 1;
	if(RaceActive == 1) SendClientMessage(playerid, COLOUR_YELLOW, "Race has already been activated!");
	else if(LCurrentCheckpoint == 0) SendClientMessage(playerid, COLOUR_YELLOW, "No race loaded!");
	else
	{
	    CPsize = floatstr(tmp);
	    format(iString,sizeof(iString),"Checkpoint size set to %f",floatstr(tmp));
		SendClientMessage(playerid,COLOUR_GREEN,iString);
	}
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	if(GetVehicleVirtualWorld(vehicleid) == RaceWorld) SetVehicleVirtualWorld(vehicleid, 0);
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	printf("pickup pickedup: %i, %i, %f, %f, %f", RaceParticipant[playerid], RaceStart, PickupLocations[0][0], PickupLocations[0][1], PickupLocations[0][2]);
	if(RaceParticipant[playerid] > 0 && RaceStart == 1)
	{
	    new pickupids = -1;
	    if(IsPlayerInRangeOfPoint(playerid, 30, PickupLocations[0][0], PickupLocations[0][1], PickupLocations[0][2])) pickupids = 0;
	    else if(IsPlayerInRangeOfPoint(playerid, 30, PickupLocations[1][0], PickupLocations[1][1], PickupLocations[1][2])) pickupids = 1;
	    else if(IsPlayerInRangeOfPoint(playerid, 30, PickupLocations[2][0], PickupLocations[2][1], PickupLocations[2][2])) pickupids = 2;
	    else if(IsPlayerInRangeOfPoint(playerid, 30, PickupLocations[3][0], PickupLocations[3][1], PickupLocations[3][2])) pickupids = 3;
	    else if(IsPlayerInRangeOfPoint(playerid, 30, PickupLocations[4][0], PickupLocations[4][1], PickupLocations[4][2])) pickupids = 4;
	    if(PickupType[pickupids] == 2)
	    {
	        if(!IsPlayerInAnyVehicle(playerid))
	        {
	            SendClientMessage(playerid, COLOUR_RED, "Error: You must be in a vehicle to pickup the pickup!");
	            return 1;
		 	}
	    	new Float:tX, Float:tY, Float:tZ, Float:tR, Float:vXR, Float:vYR, Float:vZR;
			new vehicleid = GetPlayerVehicleID(playerid);
			GetVehiclePos(vehicleid, tX, tY, tZ);
	    	GetVehicleZAngle(vehicleid, tR);
			GetVehicleVelocity(vehicleid, vXR, vYR, vZR);
			DestroyVehicle(vehicleid);
			switch (pickupids)
			{
			    case 0: PlayerVehicle[playerid] = CreateVehicle(PickupVehicle0, tX, tY, tZ, tR, -1, -1, 60);
			    case 1: PlayerVehicle[playerid] = CreateVehicle(PickupVehicle1, tX, tY, tZ, tR, -1, -1, 60);
			    case 2: PlayerVehicle[playerid] = CreateVehicle(PickupVehicle2, tX, tY, tZ, tR, -1, -1, 60);
			    case 3: PlayerVehicle[playerid] = CreateVehicle(PickupVehicle3, tX, tY, tZ, tR, -1, -1, 60);
			    case 4: PlayerVehicle[playerid] = CreateVehicle(PickupVehicle4, tX, tY, tZ, tR, -1, -1, 60);
			}
			SetVehicleZAngle(PlayerVehicle[playerid], tR);
			new Float:Angle;
			GetVehicleZAngle(GetPlayerVehicleID(playerid), Angle);
			SetVehicleZAngle(GetPlayerVehicleID(playerid), Angle);
			SetVehicleVirtualWorld(PlayerVehicle[playerid], 150);
			PutPlayerInVehicle(playerid, PlayerVehicle[playerid], 0);
			racevehicle[playerid] = GetVehicleModel(PlayerVehicle[playerid]);
			SetVehicleVelocity(PlayerVehicle[playerid], vXR, vYR, vZR);
		}
		else if(PickupType[pickupids] == 1)
		{
			RepairVehicle(GetPlayerVehicleID(playerid));
			xPlayerPlaySound(playerid, 1133);
		}
	}
	return 1;
}

public OnPlayerDisconnect(playerid,reason)
{
	print("Race disconnect");
	if(PlayerEditing[playerid] == 1) PlayerEditing[playerid] = false;
    TempRaceMaker[playerid] = 0;
	if(RaceParticipant[playerid]>=1)
	{
	    KillTimer(TimeTimer[playerid]);
    	TextDrawHideForPlayer(playerid, Time);
    	TextDrawHideForPlayer(playerid, Partici);
    	TextDrawHideForPlayer(playerid, TCountdown);
    	TextDrawHideForPlayer(playerid, Position[playerid]);
    	TextDrawHideForPlayer(playerid, TPosition[playerid]);
    	//TextDrawHideForPlayer(playerid, Diff[playerid]);
    	TextDrawHideForPlayer(playerid, Append1), TextDrawHideForPlayer(playerid, Append2), TextDrawHideForPlayer(playerid, Append3), TextDrawHideForPlayer(playerid, Append4);
    	Participants--;
	    RaceParticipant[playerid]=0;
		if(Participants == 0) //Last participant leaving, ending race.
		{
			endraceload();
		}
	    DisablePlayerRaceCheckpoint(playerid);
	}
	if(RaceBuilders[playerid] != 0)
	{
   	    DisablePlayerRaceCheckpoint(playerid);
	    for(new i;i<BCurrentCheckpoints[bb(playerid)];i++)
	    {
	        BRaceCheckpoints[bb(playerid)][i][0]=0.0;
   	        BRaceCheckpoints[bb(playerid)][i][1]=0.0;
	        BRaceCheckpoints[bb(playerid)][i][2]=0.0;
		}
		BuilderSlots[bb(playerid)] = MAX_PLAYERS+1;
		RaceBuilders[playerid] = 0;
	} 
}

public UnlockRacers()
{
	for(new i;i<MAX_PLAYERS;i++)
	{
		if(RaceParticipant[i]>0)
		{
			TogglePlayerControllable(i,true);
			if(PlayerVehicles[i] != 0)
			{
				if(racevehicle[i] != 1) PutPlayerInVehicle(i,PlayerVehicles[i],0);
				PlayerVehicles[i]=0;
			}
		}
	}
}

public countdown()
{
	if(cd<5) RaceStart=1;
	if(cd>0)
	{
	    for(new i=0;i<MAX_PLAYERS;i++){
	    if(IsPlayerInAnyVehicle(i)) PlayerVehicles[i]=GetPlayerVehicleID(i);
		else PlayerVehicles[i]=0;
		
		if(RaceParticipant[i]>1) TextDrawShowForPlayer(i, TCountdown);
	    if(RaceParticipant[i] == 3)
		{
			TogglePlayerControllable(i, false);
	    	if(!IsPlayerInAnyVehicle(i)) PutPlayerInVehicle(i, PlayerVehicle[i], 0);
		}
	    }
		format(iString, sizeof(iString), "%d",cd);
		for(new i=0;i<MAX_PLAYERS;i++)
		{
			if(RaceParticipant[i]>1)
			{
			    new string[32];
				if(cd<10)RaceSound(i,1056);
                format(string, sizeof(string), "%i", cd);
				TextDrawSetString(TCountdown, string);
				if(cd<6)
				{
					GameTextForPlayer(i, string, 1000, 3);
				}
		    }
	    }
	}
	else if(cd == 0)
	{
		format(iString, sizeof(iString), "~g~GO!",cd);
		SendClientMessageToAll(COLOUR_GREEN, "The race has begun!");
		if(Participants == 0) endraceload();
	    KillTimer(Countdown);
	    RaceStart=1;
	    TextDrawHideForAll(TCountdown);
		for(new i=0;i<MAX_PLAYERS;i++)
		{
			if(RaceParticipant[i]>1)
			{
			    if(!IsPlayerInAnyVehicle(i))
				{
				    DestroyVehicle(PlayerVehicle[i]);
					PlayerF(i);
					TogglePlayerControllable(i, true);
					GivePlayerRunflats( i );
					KillTimer(PlayerFreeze[i]);
				}
				HideMenuForPlayer(WheelsMenu, i);
				RaceSound(i,1057);
			    GameTextForPlayer(i,iString,3000,3);
			    TogglePlayerControllable(i, true);
				RaceParticipant[i]=4;
				CurrentLap[i]=1;
				TextDrawShowForPlayer(i, Time);
				TextDrawHideForPlayer(i, TCountdown);
				TextDrawShowForPlayer(i, Partici);
   				TextDrawShowForPlayer(i, Position[i]);
   				TextDrawShowForPlayer(i, TPosition[i]);
   				//TextDrawShowForPlayer(i, Speed[i]);
   				KillTimer(TimeTimer[i]);
				TimeTimer[i] = SetTimerEx("TimeTDUpdate", 999, true, "i", i);
				if(Racemode == 3) SetRaceCheckpoint(i,LCurrentCheckpoint,LCurrentCheckpoint-1);
				else SetRaceCheckpoint(i,0,1);
		    }
	    }
		UnlockRacers();
		RaceTick=GetTickCount();
	}
	cd--;
}

public SetNextCheckpoint(playerid)
{
	if(Racemode == 0) // Default Mode
	{
		CurrentCheckpoint[playerid]++;
		if(CurrentCheckpoint[playerid] == LCurrentCheckpoint)
		{
			SetRaceCheckpoint(playerid,CurrentCheckpoint[playerid],-1);
			RaceParticipant[playerid]=6;
		}
		else SetRaceCheckpoint(playerid,CurrentCheckpoint[playerid],CurrentCheckpoint[playerid]+1);
	}
	else if(Racemode == 1) // Ring Mode
	{
		CurrentCheckpoint[playerid]++;
		if(CurrentCheckpoint[playerid] == LCurrentCheckpoint+1 && CurrentLap[playerid] == Racelaps)
		{
			SetRaceCheckpoint(playerid,0,-1);
			RaceParticipant[playerid]=6;
		}
		else if (CurrentCheckpoint[playerid] == LCurrentCheckpoint+1 && CurrentLap[playerid] != Racelaps)
		{
			CurrentCheckpoint[playerid]=0;
			SetRaceCheckpoint(playerid,0,1);
			RaceParticipant[playerid]=5;
		}
		else if(CurrentCheckpoint[playerid] == 1 && RaceParticipant[playerid]==5)
		{
			ChangeLap(playerid);
			if(LCurrentCheckpoint==1)
			{
				SetRaceCheckpoint(playerid,CurrentCheckpoint[playerid],0);
			}
			else
			{
				SetRaceCheckpoint(playerid,CurrentCheckpoint[playerid],2);
            }
  		    RaceParticipant[playerid]=4;
		}
		else
		{
			if(LCurrentCheckpoint==1 || CurrentCheckpoint[playerid] == LCurrentCheckpoint) SetRaceCheckpoint(playerid,CurrentCheckpoint[playerid],0);
			else SetRaceCheckpoint(playerid,CurrentCheckpoint[playerid],CurrentCheckpoint[playerid]+1);
		}
	}
	else if(Racemode == 2) // Yoyo-mode
	{
		if(RaceParticipant[playerid]==4)
		{
			if(CurrentCheckpoint[playerid] == LCurrentCheckpoint) // @ Last CP, trigger last-1
			{
			    RaceParticipant[playerid]=5;
				CurrentCheckpoint[playerid]=LCurrentCheckpoint-1;
				SetRaceCheckpoint(playerid,CurrentCheckpoint[playerid],CurrentCheckpoint[playerid]-1);
			}
			else if(CurrentCheckpoint[playerid] == LCurrentCheckpoint-1) // Second last CP, set next accordingly
			{
				CurrentCheckpoint[playerid]++;
				SetRaceCheckpoint(playerid,CurrentCheckpoint[playerid],CurrentCheckpoint[playerid]-1);
			}
			else
			{
				CurrentCheckpoint[playerid]++;
				SetRaceCheckpoint(playerid,CurrentCheckpoint[playerid],CurrentCheckpoint[playerid]+1);
			}
		}
		else if(RaceParticipant[playerid]==5)
		{
			if(CurrentCheckpoint[playerid] == 1 && CurrentLap[playerid] == Racelaps) //Set the finish line
			{
				SetRaceCheckpoint(playerid,0,-1);
				RaceParticipant[playerid]=6;
			}
			else if(CurrentCheckpoint[playerid] == 0) //At finish line, change lap.
			{
				ChangeLap(playerid);
				if(LCurrentCheckpoint==1)
				{
					SetRaceCheckpoint(playerid,1,0);
				}
				else
				{
					SetRaceCheckpoint(playerid,1,2);
	            }
	  		    RaceParticipant[playerid]=4;
			}
			else if(CurrentCheckpoint[playerid] == 1)
			{
				CurrentCheckpoint[playerid]--;
				SetRaceCheckpoint(playerid,0,1);
			}
			else
			{
				CurrentCheckpoint[playerid]--;
				SetRaceCheckpoint(playerid,CurrentCheckpoint[playerid],CurrentCheckpoint[playerid]-1);
			}
		}
	}
	else if(Racemode == 3) // Mirror Mode
	{
		CurrentCheckpoint[playerid]--;
		if(CurrentCheckpoint[playerid] == 0)
		{
			SetRaceCheckpoint(playerid,CurrentCheckpoint[playerid],-1);
			RaceParticipant[playerid]=6;
		}
		else
		{
			 SetRaceCheckpoint(playerid,CurrentCheckpoint[playerid],CurrentCheckpoint[playerid]-1);
	    }
	}
}

public SetRaceCheckpoint(playerid,target,next)
{
	if(next == -1 && Airrace == 0) SetPlayerRaceCheckpoint(playerid,1,RaceCheckpoints[target][0],RaceCheckpoints[target][1],RaceCheckpoints[target][2],0.0,0.0,0.0,CPsize);
	else if(next == -1 && Airrace == 1) SetPlayerRaceCheckpoint(playerid,4,RaceCheckpoints[target][0],RaceCheckpoints[target][1],RaceCheckpoints[target][2],0.0,0.0,0.0,CPsize);
	else if(Airrace == 1) SetPlayerRaceCheckpoint(playerid,3,RaceCheckpoints[target][0],RaceCheckpoints[target][1],RaceCheckpoints[target][2],RaceCheckpoints[next][0],
							RaceCheckpoints[next][1],RaceCheckpoints[next][2],CPsize);
	else {
		 SetPlayerRaceCheckpoint(playerid,0,RaceCheckpoints[target][0],RaceCheckpoints[target][1],RaceCheckpoints[target][2],RaceCheckpoints[next][0],RaceCheckpoints[next][1],RaceCheckpoints[next][2],CPsize);
		 }
}
public SetBRaceCheckpoint(playerid,target,next)
{
	new ar = BAirrace[bb(playerid)];
	if(next == -1 && ar == 0) SetPlayerRaceCheckpoint(playerid,1,BRaceCheckpoints[bb(playerid)][target][0],BRaceCheckpoints[bb(playerid)][target][1],
								BRaceCheckpoints[bb(playerid)][target][2],0.0,0.0,0.0,BCPsize[bb(playerid)]);
	else if(next == -1 && ar == 1) SetPlayerRaceCheckpoint(playerid,4,BRaceCheckpoints[bb(playerid)][target][0],
				BRaceCheckpoints[bb(playerid)][target][1],BRaceCheckpoints[bb(playerid)][target][2],0.0,0.0,0.0,
				BCPsize[bb(playerid)]);
	else if(ar == 1) SetPlayerRaceCheckpoint(playerid,3,BRaceCheckpoints[bb(playerid)][target][0],BRaceCheckpoints[bb(playerid)][target][1],BRaceCheckpoints[bb(playerid)][target][2],
						BRaceCheckpoints[bb(playerid)][next][0],BRaceCheckpoints[bb(playerid)][next][1],BRaceCheckpoints[bb(playerid)][next][2],BCPsize[bb(playerid)]);
	else SetPlayerRaceCheckpoint(playerid,0,BRaceCheckpoints[bb(playerid)][target][0],BRaceCheckpoints[bb(playerid)][target][1],BRaceCheckpoints[bb(playerid)][target][2],
			BRaceCheckpoints[bb(playerid)][next][0],BRaceCheckpoints[bb(playerid)][next][1],BRaceCheckpoints[bb(playerid)][next][2],BCPsize[bb(playerid)]);
}

public GetLapTick(playerid)
{
	new tick, lap;
	tick=GetTickCount();
	if(CurrentLap[playerid]==1)
	{
		lap=tick-RaceTick;
		LastLapTick[playerid]=tick;
	}
	else
	{
		lap=tick-LastLapTick[playerid];
		LastLapTick[playerid]=tick;
	}
	return lap;
}

public GetRaceTick(playerid)
{
	new tick, race;
	tick=GetTickCount();
	race=tick-RaceTick;
	return race;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	if(RaceParticipant[playerid]>=1) // See if the player is participating in a race, allows race builders to do their stuff in peace.
	{
	    if(RaceStart == 1)
		{
		    new playerstate = GetPlayerState(playerid);
			if(playerstate != PLAYER_STATE_ONFOOT && GetVehicleModel(GetPlayerVehicleID(playerid)) != racevehicle[playerid])
			{
			    SendClientMessage(playerid,COLOUR_RED, "You need to be the driver of the appropriate race vehicle!");
				return 0;
   			}
			if(racevehicle[playerid] != 1) if(playerstate != PLAYER_STATE_DRIVER && playerstate != PLAYER_STATE_ONFOOT)
			{
			    SendClientMessage(playerid,COLOUR_RED, "You need to be the driver of the appropriate race vehicle!");
				return 0;
			}

			gPlayerProgress[playerid]++;
    		gRaceCheckpoints[gPlayerProgress[playerid]]++;
    		RacePosition[playerid]=floatround(gRaceCheckpoints[gPlayerProgress[playerid]],floatround_floor);
    		format(iString, sizeof(iString), "%i", RacePosition[playerid]);
			TextDrawSetString(TPosition[playerid], iString); //Set the race textdraws
			TextDrawHideForPlayer(playerid, Append1), TextDrawHideForPlayer(playerid, Append2), TextDrawHideForPlayer(playerid, Append3), TextDrawHideForPlayer(playerid, Append4);

			switch (RacePosition[playerid])
			{
				case 1,21,31,41,51,61,71,81,91:	TextDrawShowForPlayer(playerid, Append1);
				case 2,22,32,42,52,62,72,82,92:	TextDrawShowForPlayer(playerid, Append2);
				case 3,23,33,43,53,63,73,83,93: TextDrawShowForPlayer(playerid, Append3);
				default: TextDrawShowForPlayer(playerid, Append4);
			}
			/*new NewTick;
			TextDrawShowForPlayer(playerid, Diff[playerid]);
			if(RacePosition[playerid] == 1)
			{
				FirstTick[CurrentCheckpoint[playerid]][playerid]=GetTickCount();//Get the time at the latest checkpoint
			}
			else
			{
				NewTick = GetTickCount();//Get time current tick
				Difference[CurrentCheckpoint[playerid]][playerid] = NewTick - FirstTick[CurrentCheckpoint[playerid]][playerid];//Get the difference between before and now
				format(iString, sizeof(iString), "+%s", BeHumanR(Difference[CurrentCheckpoint[playerid]][playerid]));//Convert into a readable format
				TextDrawSetString(Diff[playerid], iString);
			}*/
		}
		if(RaceParticipant[playerid] == 6) // Player reaches the checkered flag.
		{
		    new RaceString[10];
		    SetPlayerVirtualWorld(playerid, 0);
		    KillTimer(TimeTimer[playerid]);
    		TextDrawHideForPlayer(playerid, Time);
    		TextDrawHideForPlayer(playerid, Partici);
	    	TextDrawHideForPlayer(playerid, Position[playerid]);
	    	TextDrawHideForPlayer(playerid, TPosition[playerid]);
	    	//TextDrawHideForPlayer(playerid, Diff[playerid]);
	    	TextDrawHideForPlayer(playerid, Append1), TextDrawHideForPlayer(playerid, Append2), TextDrawHideForPlayer(playerid, Append3), TextDrawHideForPlayer(playerid, Append4);
	    	//TextDrawHideForPlayer(playerid, Speed[playerid]);
		    if(racevehicle[playerid] != 1) DestroyVehicle(GetPlayerVehicleID(playerid));
			new name[MAX_PLAYER_NAME], LapTime, RaceTime;
			LapTime=GetLapTick(playerid);
			RaceTime=GetRaceTick(playerid);
			GetPlayerName(playerid, name, MAX_PLAYER_NAME);
			RaceParticipant[playerid]=0;
			RaceSound(playerid,1138);
			RaceString=BeHumanR(RaceTime);
			format(iString,sizeof(iString),"%s has finished %s in position %d, Time: %s", name, CRaceName, Ranking,RaceString);
			SendClientMessageToAll(COLOUR_GREEN,iString);
			SetPlayerInterior(playerid, interiorsave[playerid]);
			SetPlayerVirtualWorld(playerid, worldsave[playerid]);
			SetPlayerPos(playerid, xsave[playerid], ysave[playerid], zsave[playerid]);
			//SetPlayerGravity(playerid, 0.008);
			SetPlayerWeather(playerid, 0);
			if(Racemode == ORacemode && ORacelaps == Racelaps)
			{
				new	LapString[10], laprank, racerank;
				LapString=BeHumanR(LapTime);
				RaceString=BeHumanR(RaceTime);
				format(iString,sizeof(iString),"~w~Racetime: %s",RaceString);
				if(ORacemode!=0) format(iString,sizeof(iString),"%s~n~Laptime: %s",iString,LapString);
				laprank=CheckBestLap(playerid,LapTime);
				if(laprank == 1)
				{
				    format(iString,sizeof(iString),"%s~n~~y~LAP RECORD!",iString);
				    GameTextForPlayer(playerid,iString,13000,3);
				}
				racerank=CheckBestRace(playerid,RaceTime);
				if(racerank == 1)
				{
				    format(iString,sizeof(iString),"%s~n~~y~TRACK RECORD!",iString);
				    GameTextForPlayer(playerid,iString,13000,3);
				    format(iString,sizeof(iString),"%s has set a new top race record on %s: %s", name, CRaceName, RaceString);
					SendClientMessageToAll(COLOUR_YELLOW, iString);
				}
		    }
			new winrar;
			if(Ranking == 1)
			{
				winrar = Winnings1;
				EndingT = SetTimer("EndTimerR", 60000, false);
			}
			else if(Ranking == 2) winrar = Winnings2;
			else if(Ranking == 3) winrar = Winnings3;
			else if(Ranking == 4) winrar = Winnings4;
			else if(Ranking == 5) winrar = Winnings5;
			else if(Ranking > 5) winrar = RunnerUp;
			GivePlayerMoney(playerid, winrar);
			/*if(Ranking == 1) GivePlayerXp(playerid, 5);
			else if(Ranking == 2) GivePlayerXp(playerid, 4);
			else if(Ranking == 3) GivePlayerXp(playerid, 3);
			else if(Ranking == 4) GivePlayerXp(playerid, 2);
			else if(Ranking == 5) GivePlayerXp(playerid, 1);*/
			format(iString,sizeof(iString),"You have earned $%d from the race!",winrar);
			SendClientMessage(playerid,COLOUR_GREEN,iString);
			
   			Ranking++;
			Participants--;
	        DisablePlayerRaceCheckpoint(playerid);
	        if(Participants == 0)
			{
			    new ender;
				for(new i=0;i<MAX_PLAYERS;i++)
				{
				    if(GetPlayerVirtualWorld(i) == RaceWorld) continue;
				    ender = 1;
				}
				if(ender == 1) endraceload();
			}
            //RaceSound(playerid,1183);
  			//SetTimerEx("MusicStop", 10000, false, "i", playerid);
	    }
	    else if (RaceStart == 0 && RaceParticipant[playerid]==1) // Player arrives to the start CP for 1st time
	    {
   			PlayerFreeze[playerid] = SetTimerEx("PlayerF", 5000, false, "i", playerid);
			SendClientMessage(playerid,COLOUR_YELLOW,"NOTE: You will be frozen in 5 seconds, get into position!");
			RaceParticipant[playerid]=1;
			CurrentLap[playerid]=0;
	    }
	    else if (RaceStart == 0 && RaceParticipant[playerid]==0)
	    {
	    	SendClientMessage(playerid, COLOUR_YELLOW, "You need to type /rjoin to enter the race!");
		}
	    else if (RaceStart==1) // Otherwise switch to the next race CP.
	    {
			RaceSound(playerid,1138);
			SetNextCheckpoint(playerid);
	    }
	}
	return 1;
}

public Cendrace()
{
    //SetServerRule("Current Race", "None");
    SaveScores(); //If the race had already started, and mode & laps are as originally, save the lapscores and racescores.
    ReadyRef = 0;
    Partsave = 0;
	for(new i=0;i<LCurrentCheckpoint;i++)
	{
	    RaceCheckpoints[i][0]=0.0;
	    RaceCheckpoints[i][1]=0.0;
	    RaceCheckpoints[i][2]=0.0;
	}
	LCurrentCheckpoint=0;
	TextDrawHideForAll(Append1), TextDrawHideForAll(Append2), TextDrawHideForAll(Append3), TextDrawHideForAll(Append4);
    TextDrawHideForAll(Time);
    TextDrawHideForAll(Partici);
    KillTimer(EndingT);
    KillTimer(LoadNextRace);
    

    if(PickupType[Pickup0] != 0)DestroyPickup(Pickup0);
    if(PickupType[Pickup1] != 0)DestroyPickup(Pickup1);
    if(PickupType[Pickup2] != 0)DestroyPickup(Pickup2);
    if(PickupType[Pickup3] != 0)DestroyPickup(Pickup3);
    if(PickupType[Pickup4] != 0)DestroyPickup(Pickup4);
    
    PickupVehicle0 = -1;
    PickupVehicle1 = -1;
    PickupVehicle2 = -1;
    PickupVehicle3 = -1;
    PickupVehicle4 = -1;
    
    PickupType[0] = -1;
    PickupType[1] = -1;
    PickupType[2] = -1;
    PickupType[3] = -1;
    PickupType[4] = -1;

    format(iString, sizeof(iString), "/iRaces/%s.iRo", CRaceName);
	if(fexist(iString)) for(new i=0;i<MAX_GAYME_OBJECTS;i++) DestroyObject(oObjectR[i]); // File doesn't exist

    for(new i=0;i<MAX_PLAYERS;i++)
    {
        KillTimer(PlayerFreeze[i]);
        KillTimer(TimeTimer[i]);
        if(GetVehicleVirtualWorld(PlayerVehicle[i]) == RaceWorld) DestroyVehicle(PlayerVehicle[i]);
        gPlayerProgress[i] = 0;
		if(i < MAX_RACECHECKPOINTS) gRaceCheckpoints[i] = 0;
    	RacePosition[i] = 0;
        KillTimer(TimeTimer[i]);
    	TextDrawHideForPlayer(i, Position[i]);
    	TextDrawHideForPlayer(i, TPosition[i]);
    	//TextDrawHideForPlayer(i, Diff[i]);
    	//TextDrawHideForPlayer(i, Speed[i]);
		LastLapTick[i]=0;
		if(RaceParticipant[i]>0 && RaceBuilders[i] == 0)
		{
		    //SetPlayerGravity(i, 0.008);
		    DisablePlayerRaceCheckpoint(i);
		    SetPlayerInterior(i, interiorsave[i]);
		    SetPlayerPos(i, xsave[i], ysave[i], zsave[i]);
			SetPlayerVirtualWorld(i, worldsave[i]);
			TogglePlayerControllable(i,1);
		    if(PlayerVehicles[i] != 0)
		    {
		        PlayerVehicles[i]=0;
		    }
		}
        RaceParticipant[i]=0;
    }
	RaceActive=0;
	RaceStart=0;
	Participants=0;
    KillTimer(RaceEnd);
    KillTimer(RaceFixTimer);
    KillTimer(Countdown);
	return 1;
}

public endraceload()
{
    //SetServerRule("Current Race", "None");
    SaveScores(); //If the race had already started, and mode & laps are as originally, save the lapscores and racescores.
    ReadyRef = 0;
    Partsave = 0;
	for(new i=0;i<LCurrentCheckpoint;i++)
	{
	    RaceCheckpoints[i][0]=0.0;
	    RaceCheckpoints[i][1]=0.0;
	    RaceCheckpoints[i][2]=0.0;
	}
	LCurrentCheckpoint=0;
	TextDrawHideForAll(Append1), TextDrawHideForAll(Append2), TextDrawHideForAll(Append3), TextDrawHideForAll(Append4);
    TextDrawHideForAll(Time);
    TextDrawHideForAll(Partici);
    KillTimer(EndingT);
    KillTimer(LoadNextRace);
    
    DestroyPickup(Pickup0);
    DestroyPickup(Pickup1);
    DestroyPickup(Pickup2);
    DestroyPickup(Pickup3);
    DestroyPickup(Pickup4);

    PickupVehicle0 = -1;
    PickupVehicle1 = -1;
    PickupVehicle2 = -1;
    PickupVehicle3 = -1;
    PickupVehicle4 = -1;

    PickupType[0] = -1;
    PickupType[1] = -1;
    PickupType[2] = -1;
    PickupType[3] = -1;
    PickupType[4] = -1;

    for(new i=0;i<MAX_GAYME_OBJECTS;i++) DestroyObject(oObjectR[i]);
    
    for(new i=0;i<MAX_PLAYERS;i++)
    {
        KillTimer(PlayerFreeze[i]);
        KillTimer(TimeTimer[i]);
        if(GetVehicleVirtualWorld(PlayerVehicle[i]) == RaceWorld) DestroyVehicle(PlayerVehicle[i]);
        gPlayerProgress[i] = 0;
		if(i < MAX_RACECHECKPOINTS) gRaceCheckpoints[i] = 0;
    	RacePosition[i] = 0;
        KillTimer(TimeTimer[i]);
    	TextDrawHideForPlayer(i, Position[i]);
    	TextDrawHideForPlayer(i, TPosition[i]);
    	//TextDrawHideForPlayer(i, Diff[i]);
    	//TextDrawHideForPlayer(i, Speed[i]);
		LastLapTick[i]=0;
		if(RaceParticipant[i]>0 && RaceBuilders[i] == 0)
		{
		    //SetPlayerGravity(i, 0.008);
		    DisablePlayerRaceCheckpoint(i);
		    SetPlayerInterior(i, interiorsave[i]);
		    SetPlayerPos(i, xsave[i], ysave[i], zsave[i]);
			SetPlayerVirtualWorld(i, worldsave[i]);
			TogglePlayerControllable(i,1);
		    if(PlayerVehicles[i] != 0)
		    {
		        PlayerVehicles[i]=0;
		    }
		}
        RaceParticipant[i]=0;
    }
	RaceActive=0;
	RaceStart=0;
	Participants=0;
    SendClientMessageToAll(COLOUR_YELLOW, "The current race has been finished. The next race will begin in 60 seconds.");
    KillTimer(RaceEnd);
    KillTimer(RaceFixTimer);
    KillTimer(Countdown);
	KillTimer(LoadNextRace);
    LoadNextRace = SetTimer("loadnext", 60000, false);
	return 1;
}

public loadnext()
{
    RaceRotation();
	return 1;
}

public BActiveCP(playerid,sele)
{
	if(BCurrentCheckpoints[bb(playerid)]-1 == sele) SetBRaceCheckpoint(playerid,sele,-1);
	else SetBRaceCheckpoint(playerid,sele,sele+1);
}

public RaceSound(playerid,sound)
{
	xPlayerPlaySound(playerid,sound);
}

public CheckBestLap(playerid,laptime)
{
	if(TopLapTimes[4]<laptime && TopLapTimes[4] != 0 || Racemode == 0)
	{
		return 0;  // If the laptime is more than the previous 5th on the top list, skip to end
	}              // Or the race is gamemode 0 where laps don't really apply
	for(new i;i<5;i++)
	{
	    if(TopLapTimes[i] == 0)
	    {
			new playername[MAX_PLAYER_NAME];
	        GetPlayerName(playerid,playername,MAX_PLAYER_NAME);
	        TopLappers[i]=playername;
	        TopLapTimes[i]=laptime;
			ScoreChange=1;
			return i+1;
	    }
		else if(TopLapTimes[i] > laptime)
		{
		    for(new j=4;j>=i;j--)
		    {
		        TopLapTimes[j+1]=TopLapTimes[j];
		        TopLappers[j+1]=TopLappers[j];
		    }
			new playername[MAX_PLAYER_NAME];
	        GetPlayerName(playerid,playername,MAX_PLAYER_NAME);
		    TopLapTimes[i]=laptime;
			TopLappers[i]=playername;
			ScoreChange=1;
			return i+1;
		}
	}
	return -1; //Shouldn't get here.
}

public RaceEnder()
{
if(RaceActive==1) endraceload();
return 1;
}

public CheckBestRace(playerid,racetime)
{
	if(TopRacerTimes[4]<racetime && TopRacerTimes[4] != 0) return 0;
	for(new i;i<5;i++)
	{
	    if(TopRacerTimes[i] == 0)
	    {
			new playername[MAX_PLAYER_NAME];
	        GetPlayerName(playerid,playername,MAX_PLAYER_NAME);
	        TopRacers[i]=playername;
	        TopRacerTimes[i]=racetime;
			ScoreChange=1;
			return i+1;
	    }
		else if(TopRacerTimes[i] > racetime)
		{
		    for(new j=4;j>=i;j--)
		    {
		        TopRacerTimes[j+1]=TopRacerTimes[j];
		        TopRacers[j+1]=TopRacers[j];
		    }
			new playername[MAX_PLAYER_NAME];
	        GetPlayerName(playerid,playername,MAX_PLAYER_NAME);
		    TopRacerTimes[i]=racetime;
			TopRacers[i]=playername;
			ScoreChange=1;
			return i+1;
		}
	}
	return -1; //Shouldn't get here.
}

public SaveScores()
{
	if(ScoreChange == 1)
	{
		/*Float:x,Float:y,Float:z,
		format(templine,sizeof(templine),"iRace %d %d %s %d %d %d %f\n", RACEFILE_VERSION, racevehicle, CBuilder, ORacemode, ORacelaps, OAirrace, OCPsize);
		format(templine,sizeof(templine),"%s %d %s %d %s %d %s %d %s %d\n",
				TopRacers[0],TopRacerTimes[0],TopRacers[1], TopRacerTimes[1], TopRacers[2],TopRacerTimes[2],
	 			TopRacers[3],TopRacerTimes[3],TopRacers[4], TopRacerTimes[4]);*/
	 	INI_Open(CFile);
	 			
		INI_WriteString("RaceTimesName/0", TopRacers[0]);
		INI_WriteInt("RaceTimesTime/0", TopRacerTimes[0]);
		INI_WriteString("RaceTimesName/1", TopRacers[1]);
		INI_WriteInt("RaceTimesTime/1", TopRacerTimes[1]);
		INI_WriteString("RaceTimesName/2", TopRacers[2]);
		INI_WriteInt("RaceTimesTime/2", TopRacerTimes[2]);
		INI_WriteString("RaceTimesName/3", TopRacers[3]);
		INI_WriteInt("RaceTimesTime/3", TopRacerTimes[3]);
		INI_WriteString("RaceTimesName/4", TopRacers[4]);
		INI_WriteInt("RaceTimesTime/4", TopRacerTimes[4]);

        INI_WriteString("LapTimesName/0", TopLappers[0]);
		INI_WriteInt("LapTimesTime/0", TopLapTimes[0]);
		INI_WriteString("LapTimesName/1", TopLappers[1]);
		INI_WriteInt("LapTimesTime/1", TopLapTimes[1]);
		INI_WriteString("LapTimesName/2", TopLappers[2]);
		INI_WriteInt("LapTimesTime/2", TopLapTimes[2]);
		INI_WriteString("LapTimesName/3", TopLappers[3]);
		INI_WriteInt("LapTimesTime/3", TopLapTimes[3]);
		INI_WriteString("LapTimesName/4", TopLappers[4]);
		INI_WriteInt("LapTimesTime/4", TopLapTimes[4]);
		
		INI_Save();
		INI_Close();
	}
	ScoreChange=0;
}
public ChangeLap(playerid)
{
	new LapTime, TimeString[10], checklap;
	LapTime=GetLapTick(playerid);
	TimeString=BeHumanR(LapTime);
	format(iString,sizeof(iString),"~w~Lap %d/%d - time: %s", CurrentLap[playerid], Racelaps, TimeString);
	if(Racemode == ORacemode && ORacelaps == Racelaps)
	{
		checklap=CheckBestLap(playerid,LapTime);
		if(checklap==1) format(iString,sizeof(iString),"%s~n~~y~LAP RECORD!",iString);
	}
	CurrentLap[playerid]++;
	if(CurrentLap[playerid] == Racelaps) format(iString,sizeof(iString),"%s~n~~g~Final lap!",iString);
	GameTextForPlayer(playerid,iString,6000,3);
}

BeHumanR(ticks)
{
	new HumanTime[10], minutes, seconds, secstring[3], msecstring[3];
	minutes=ticks/60000;
	ticks=ticks-(minutes*60000);
	seconds=ticks/1000;
	ticks=ticks-(seconds*1000);
	if(seconds <10) format(secstring,sizeof(secstring),"0%d",seconds);
	else format(secstring,sizeof(secstring),"%d",seconds);
	format(HumanTime,sizeof(HumanTime),"%d:%s",minutes,secstring);
	if(ticks < 10) format(msecstring,sizeof(msecstring),"00%d", ticks);
	else if(ticks < 100) format(msecstring,sizeof(msecstring),"0%d",ticks);
	else format(msecstring,sizeof(msecstring),"%d",ticks);
	format(HumanTime,sizeof(HumanTime),"%s.%s",HumanTime,msecstring);
	return HumanTime;
}

BeHumanCP(ticks)
{
	new HumanTime[10], minutes, seconds, secstring[3];
	minutes=ticks/60000;
	ticks=ticks-(minutes*60000);
	seconds=ticks/1000;
	ticks=ticks-(seconds*1000);
	if(seconds <10) format(secstring,sizeof(secstring),"0%d",seconds);
	else format(secstring,sizeof(secstring),"%d",seconds);
	format(HumanTime,sizeof(HumanTime),"%d:%s",minutes,secstring);
	return HumanTime;
}

public LoadTimes(playerid,timemode,tmp[])
{
	new temprace[67];
	format(temprace,sizeof(temprace),"iRaces/%s.iR",tmp);
    if(strlen(tmp))
    {
		if(!fexist(temprace))
		{
			format(iString,sizeof(iString),"Race \'%s\' doesn't exist!",tmp);
			SendClientMessage(playerid,COLOUR_YELLOW,iString);
			return 1;
		}
		
		else
		{
			new TempLapper[256], TempLap;
			INI_Open(temprace);
			INI_ReadString(TBuilder, "Creator");
			if(timemode == 0) format(iString,sizeof(iString),"%s by %s - Best race times:",tmp,TBuilder);
			else if(timemode == 1) format(iString,sizeof(iString),"%s by %s - Best laps:",tmp,TBuilder);
			else return 1;
			SendClientMessage(playerid,COLOUR_GREEN,iString);
			
			if(timemode == 0){
				for(new i;i < 5; i++)
				{
					format(iString, sizeof(iString), "RaceTimesName/%d", i);
					INI_ReadString(iString, iString);
					format(TempLapper, sizeof(TempLapper), "RaceTimesTime/%d", i);
					TempLap = INI_ReadInt(TempLapper);
					if(TempLap != 0)
					{
						format(iString,sizeof(iString),"%d. %s - %s",i+1, BeHumanR(TempLap), iString);
						SendClientMessage(playerid,COLOUR_GREEN,iString);
					}
					if(TempLap == 0)
					{
					    format(iString,sizeof(iString),"%d. None yet",i+1);
						i=6;
					}
				}
			}
			
			if(timemode == 1){
				for(new i;i < 5; i++)
				{
					format(iString, sizeof(iString), "LapTimesName/%d", i);
					INI_ReadString(iString, iString);
					format(TempLapper, sizeof(TempLapper), "LapTimesTime/%d", i);
					TempLap = INI_ReadInt(TempLapper);
					if(TempLap != 0)
					{
						format(iString,sizeof(iString),"%d. %s - %s",i+1, BeHumanR(TempLap), iString);
						SendClientMessage(playerid,COLOUR_GREEN,iString);
					}
					if(TempLap == 0)
					{
					    format(iString,sizeof(iString),"%d. None yet",i+1);
						i=6;
					}
				}
			}
			INI_Save();
			INI_Close();
		}
		return 1;
		}
 	else return 0;
}

public IsNotAdmin(playerid)
{
	if (TempRaceMaker[playerid] == 1) return 0;
    if (!IsPlayerScriptAdmin(playerid))
	{
	    SendClientMessage(playerid, COLOUR_RED, "You need to be an admin to use this command!");
	    return 1;
    }
    return 0;
}

public GetBuilderSlot(playerid)
{
	for(new i;i < MAX_BUILDERS; i++)
	{
	    if(!(BuilderSlots[i] < MAX_PLAYERS+1))
	    {
	        BuilderSlots[i] = playerid;
	        RaceBuilders[playerid] = i+1;
			return i+1;
	    }
	}
	return 0;
}

public bb(playerid) return RaceBuilders[playerid]-1;

public Float:Distance(Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2)
{
	new Float:temp=floatsqroot((x1-x2) * (x1-x2) + (y1-y2) * (y1-y2) + (z1-z2) * (z1-z2));
	if(temp < 0) temp=temp*(-1);
	return temp;
}

public Cclearrace(playerid)
{
	for(new i=0;i<BCurrentCheckpoints[bb(playerid)];i++)
	{
		BRaceCheckpoints[bb(playerid)][i][0]=0.0;
		BRaceCheckpoints[bb(playerid)][i][1]=0.0;
		BRaceCheckpoints[bb(playerid)][i][2]=0.0;
	}
	BCurrentCheckpoints[bb(playerid)]=0;
	DisablePlayerRaceCheckpoint(playerid);
	SendClientMessage(playerid, COLOUR_GREEN, "Your race has been cleared! Use /buildrace to start a new one.");
	BuilderSlots[bb(playerid)] = MAX_PLAYERS+1;
	RaceBuilders[playerid]=0;
}

public Cstartrace()
{
	format(iString,128,"Race \'%s\' by %s is about to start, type /RJOIN to enter!",CRaceName, CBuilder);
	SendClientMessageToAll(COLOUR_YELLOW,iString);
	format(iString,128,"Race \'%s\' by %s is about to start, type /RJOIN to enter!",CRaceName, CBuilder);
	SendClientMessageToAll(COLOUR_YELLOW,iString);
	format(iString,128,"Race \'%s\' by %s is about to start, type /RJOIN to enter!",CRaceName, CBuilder);
	SendClientMessageToAll(COLOUR_YELLOW,iString);
	if(Racemode == 0) format(iString,sizeof(iString),"Sprint");
	else if(Racemode == 1) format(iString,sizeof(iString),"Ring");
	else if(Racemode == 2) format(iString,sizeof(iString),"Yoyo");
	else if(Racemode == 3) format(iString,sizeof(iString),"Mirror");
	format(iString,sizeof(iString),"Mode: %s Laps: %d",iString,Racelaps);
	format(iString,sizeof(iString),"%s Vehicle: %s",iString,RaceVehicleName);
	format(iString,sizeof(iString),"%s Gravity: %.3f",iString, Gravity);
	
	if(RWeather == 8) format(iString,sizeof(iString),"%s Weather: Rain",iString);
	else if(RWeather == 9) format(iString,sizeof(iString),"%s Weather: Foggy",iString);
	else if(RWeather == -68) format(iString,sizeof(iString),"%s Weather: Hurricane",iString);
	else if(RWeather == 1337) format(iString,sizeof(iString),"%s Weather: DD",iString);
	else format(iString,sizeof(iString),"%s Weather: Sunny",iString);

	if(Airrace == 1) format(iString,sizeof(iString),"%s AIR RACE",iString);
	if(Racemode == 0 || Racemode == 3) format(iString,sizeof(iString),"%s Track lenght: %0.2fkm", iString, RLenght/1000);
	else if(Racemode == 1) format(iString,sizeof(iString),"%s Lap lenght: %.2fkm, Total: %.2fkm", iString, LLenght/1000, LLenght * Racelaps / 1000);
	SendClientMessageToAll(COLOUR_GREEN,iString);
	RaceStart=0;
	ScoreChange=0;
	RaceActive=1;
	Ranking=1;
}

public LoadRace(tmp[])
{
    KillTimer(EndingT);
    KillTimer(RaceEnd);
    KillTimer(LoadNextRace);
    RaceEnd = SetTimer("RaceEnder", 760000, false);
	new race_name[64],templine[512];
	new File:f, templine2[64], Count, idx;
   	format(iString, sizeof(iString), "iRaces/iList.iRf");
   	if(!fexist(iString)) return -1; // File doesn't exist
	f = fopen(iString, io_read);
	while(fread(f,templine2,sizeof(templine2),false))
	{
		for(new i, x = strlen(templine2); i < x; i++)
		{
			if(templine2[i] == '\r') templine2[i] = '\0';
			//break;
		}
		idx = 0;
		RaceNames[Count] = strtok(templine2, idx);
		//printf("%s", RaceNames[Count]);
		Count++;
		GaymeCountR++;
	}
	for(new j=0;j<GaymeCountR-1;j++)
	{
	    if(strfind(RaceNames[j], tmp, true) != -1)
	    {
	        format(race_name,sizeof(race_name), "iRaces/%s.iR", RaceNames[j]);
	        printf("race load: %s", race_name);
	        format(CRaceName,sizeof(CRaceName), "%s", RaceNames[j]);
	        break;
	    }
	}
	//SetServerRule("Current Race", tmp);
	if(!fexist(race_name)) return -1; // File doesn't exist
	CFile=race_name;
    LCurrentCheckpoint=-1; RLenght=0; RLenght=0;
    INI_Open(race_name);
    new racevehicle2;
	racevehicle2 = INI_ReadInt("Vehicle"); // Read off vehicle
	for(new j=0;j<MAX_PLAYERS;j++)  racevehicle[j] = racevehicle2;
	AutoFixT = INI_ReadInt("AutoFix");
	if(AutoFixT == 1) RaceFixTimer = SetTimer("RaceFix", 3000, true);
	INI_ReadString(CBuilder, "Creator"); // read off RACEBUILDER
	ORacemode = INI_ReadInt("RaceMode"); // read off racemode
	ORacelaps = INI_ReadInt("Laps"); // read off amount of laps
	Nitrous = INI_ReadInt("Nos");
	Gravity = INI_ReadFloat("Gravity");
	if(Gravity == 0) Gravity = 0.008;
	INI_WriteFloat("Gravity", Gravity);
	RWeather = INI_ReadInt("Weather");
	//INI_WriteInt("Weather", RWeather);
	RaceWorld = INI_ReadInt("World");
	if(RaceWorld < 100){
		RaceWorld = 150;
	}
	//RaceWorld = 150;
	Airrace = INI_ReadInt("AirRace");   // read off airrace
	CPsize = INI_ReadFloat("CPSize");    // read off CP size
	Racemode=ORacemode; Racelaps=ORacelaps; //Allows changing the modes, but disables highscores if they've been changed.
	new tempstring[48];
	idx = 0;
	PickupModel = INI_ReadInt("PickupModel"); // read pickup model
	
	if(INI_ReadString(tempstring, "PickupLocations0")) // read pickup xyz
	{
		
		PickupLocations[0][0] = floatstr(strtok(tempstring, idx));
		PickupLocations[0][1] = floatstr(strtok(tempstring, idx));
		PickupLocations[0][2] = floatstr(strtok(tempstring, idx));
		
		PickupType[0] = INI_ReadInt("PickupType0");
		
		if(PickupType[0] != 0) Pickup0 = CreatePickup(PickupModel, 14, PickupLocations[0][0], PickupLocations[0][1], PickupLocations[0][2], 150);
		
		if(PickupType[0] == 2) PickupVehicle0 = INI_ReadInt("PickupVehicle0");
	}
	
	if(INI_ReadString(tempstring, "PickupLocations1"))
	{
	    idx = 0;
	    PickupLocations[1][0] = floatstr(strtok(tempstring, idx));
		PickupLocations[1][1] = floatstr(strtok(tempstring, idx));
		PickupLocations[1][2] = floatstr(strtok(tempstring, idx));
		PickupType[1] = INI_ReadInt("PickupType1");
		if(PickupType[1] != 0) Pickup1 = CreatePickup(PickupModel, 14, PickupLocations[1][0], PickupLocations[1][1], PickupLocations[1][2], 150);
		if(PickupType[1] == 2) PickupVehicle1 = INI_ReadInt("PickupVehicle1");
	}
	if(INI_ReadString(tempstring, "PickupLocations2"))
	{
	    idx = 0;
	    PickupLocations[2][0] = floatstr(strtok(tempstring, idx));
		PickupLocations[2][1] = floatstr(strtok(tempstring, idx));
		PickupLocations[2][2] = floatstr(strtok(tempstring, idx));
		PickupType[2] = INI_ReadInt("PickupType2");
		if(PickupType[2] != 0) Pickup2 = CreatePickup(PickupModel, 14, PickupLocations[2][0], PickupLocations[2][1], PickupLocations[2][2], 150);
		if(PickupType[2] == 2) PickupVehicle2 = INI_ReadInt("PickupVehicle2");
	}
	if(INI_ReadString(tempstring, "PickupLocations3"))
	{
	    idx = 0;
	    PickupLocations[3][0] = floatstr(strtok(tempstring, idx));
		PickupLocations[3][1] = floatstr(strtok(tempstring, idx));
		PickupLocations[3][2] = floatstr(strtok(tempstring, idx));
		PickupType[3] = INI_ReadInt("PickupType3");
		if(PickupType[3] != 0) Pickup3 = CreatePickup(PickupModel, 14, PickupLocations[3][0], PickupLocations[3][1], PickupLocations[3][2], 150);
		if(PickupType[3] == 2) PickupVehicle3 = INI_ReadInt("PickupVehicle3");
	}
	if(INI_ReadString(tempstring, "PickupLocations4"))
	{
	    idx = 0;
	    PickupLocations[4][0] = floatstr(strtok(tempstring, idx));
		PickupLocations[4][1] = floatstr(strtok(tempstring, idx));
		PickupLocations[4][2] = floatstr(strtok(tempstring, idx));
		PickupType[4] = INI_ReadInt("PickupType4");
		if(PickupType[4] != 0) Pickup4 = CreatePickup(PickupModel, 14, PickupLocations[4][0], PickupLocations[4][1], PickupLocations[4][2], 150);
		if(PickupType[4] == 2) PickupVehicle4 = INI_ReadInt("PickupVehicle4");
	}
	printf("type: %i location: %f, %f, %f", PickupType[0], PickupLocations[0][0], PickupLocations[0][1], PickupLocations[0][2]);
	printf("type: %i location: %f, %f, %f", PickupType[1], PickupLocations[1][0], PickupLocations[1][1], PickupLocations[1][2]);
	printf("type: %i location: %f, %f, %f", PickupType[2], PickupLocations[2][0], PickupLocations[2][1], PickupLocations[2][2]);
	printf("type: %i location: %f, %f, %f", PickupType[3], PickupLocations[3][0], PickupLocations[3][1], PickupLocations[3][2]);
	printf("type: %i location: %f, %f, %f", PickupType[4], PickupLocations[4][0], PickupLocations[4][1], PickupLocations[4][2]);
	for(new j=0;j<5;j++)
	{
	    format(templine,sizeof(templine), "RaceTimes1/%d",j);
	    format(iString,sizeof(iString), "RaceTimes2/%d",j);
	    INI_ReadString(TopRacers[j], templine);
	    TopRacerTimes[j]=INI_ReadInt(iString);
	}
	for(new j=0;j<5;j++)
	{
	    format(templine,sizeof(templine), "LapTimes1/%d",j);
	    format(iString,sizeof(iString), "LapTimes2/%d",j);
	    INI_ReadString(TopLappers[j], templine);
	    TopLapTimes[j]=INI_ReadInt(iString);
	}
 	INI_ReadString(TopRacers[0], "RaceTimesName/0");
	TopRacerTimes[0] = INI_ReadInt("RaceTimesTime/0");
 	INI_ReadString(TopRacers[1], "RaceTimesName/1");
	TopRacerTimes[1] = INI_ReadInt("RaceTimesTime/1");
 	INI_ReadString(TopRacers[2], "RaceTimesName/2");
	TopRacerTimes[2] = INI_ReadInt("RaceTimesTime/2");
	INI_ReadString(TopRacers[3], "RaceTimesName/3");
	TopRacerTimes[3] = INI_ReadInt("RaceTimesTime/3");
	INI_ReadString(TopRacers[4], "RaceTimesName/4");
	TopRacerTimes[4] = INI_ReadInt("RaceTimesTime/4");

	INI_ReadString(TopLappers[0], "LapTimesName/0");
	TopLapTimes[0] = INI_ReadInt("LapTimesTime/0");
	INI_ReadString(TopLappers[1], "LapTimesName/1");
	TopLapTimes[1] = INI_ReadInt("LapTimesTime/1");
	INI_ReadString(TopLappers[2], "LapTimesName/2");
	TopLapTimes[2] = INI_ReadInt("LapTimesTime/2");
	INI_ReadString(TopLappers[3], "LapTimesName/3");
	TopLapTimes[3] = INI_ReadInt("LapTimesTime/3");
	INI_ReadString(TopLappers[4], "LapTimesName/4");
	TopLapTimes[4] = INI_ReadInt("LapTimesTime/4");
	
	StartX = INI_ReadFloat("Tcp/1");
	StartY = INI_ReadFloat("Tcp/2");
	StartZ = INI_ReadFloat("Tcp/3");
	StartR = INI_ReadFloat("Tcp/4");
    LCurrentCheckpoint = -1;
    new i;
	for(new j=0;j<200;j++)
	{
	    i = 0;
		LCurrentCheckpoint++;
		format(iString,sizeof(iString), "CPs/%d", LCurrentCheckpoint);
		INI_ReadString(iString, iString);
		RaceCheckpoints[LCurrentCheckpoint][0] = floatstr(strtok(iString,i));
		if(RaceCheckpoints[LCurrentCheckpoint][0] > -1 && RaceCheckpoints[LCurrentCheckpoint][0] < 1)
		{
		    LCurrentCheckpoint=j-1;
			break;
		}
		
		RaceCheckpoints[LCurrentCheckpoint][1] = floatstr(strtok(iString,i));
		RaceCheckpoints[LCurrentCheckpoint][2] = floatstr(strtok(iString,i));
		if(LCurrentCheckpoint >= 1)
		{
		    RLenght+=Distance(RaceCheckpoints[LCurrentCheckpoint][0],RaceCheckpoints[LCurrentCheckpoint][1],
								RaceCheckpoints[LCurrentCheckpoint][2],RaceCheckpoints[LCurrentCheckpoint-1][0],
								RaceCheckpoints[LCurrentCheckpoint-1][1],RaceCheckpoints[LCurrentCheckpoint-1][2]);
		}
	}
	LLenght = RLenght + Distance(RaceCheckpoints[LCurrentCheckpoint][0],RaceCheckpoints[LCurrentCheckpoint][1],
								RaceCheckpoints[LCurrentCheckpoint][2],RaceCheckpoints[0][0],RaceCheckpoints[0][1],
								RaceCheckpoints[0][2]);
	RaceVehicleName = ReturnVehicle(racevehicle[0]);
	INI_Save();
	INI_Close();
	// Preload objects
	format(iString, sizeof(iString), "/iRaces/%s.iRo", CRaceName);
	if(!fexist(iString)) printf("No object data"); // File doesn't exist
	else
	{
        f = fopen(iString, io_read);
        new Counter, fileline[128];
		while(fread(f,fileline,sizeof(fileline),false))
		{
		    idx = 0;
   			oModelR[Counter] = strval(strtok(fileline, idx));
   			oXR[Counter] = floatstr(strtok(fileline, idx));
   			oYR[Counter] = floatstr(strtok(fileline, idx));
   			oZR[Counter] = floatstr(strtok(fileline, idx));
   			oRXR[Counter] = floatstr(strtok(fileline, idx));
   			oRYR[Counter] = floatstr(strtok(fileline, idx));
   			oRZR[Counter] = floatstr(strtok(fileline, idx));
			oObjectR[Counter] = CreateObject(oModelR[Counter], oXR[Counter], oYR[Counter], oZR[Counter], oRXR[Counter], oRYR[Counter], oRZR[Counter]);
			Counter++;
		}
		fclose(f);
	}
	return 1;
}

public EndTimerR()
{
	endraceload();
	return 1;
}

public RaceRotation()
{
	if(!fexist("iRaces/iList.iRf"))
	{
	    printf("ERROR in  RacerX (iList.iRf): File doesn't exist!");
	    return -1;
	}

	if(Participants > 0) return 1; // A race is still active.

	new File:f, templine[32], rotfile[]="iRaces/iList.iRf", rraces=-1, rracenames[32], idx, mmk, rand;
	f = fopen(rotfile, io_read);
	while(fread(f,templine,sizeof(templine),false))
	{
	    rraces++;
	}
	fclose(f);
	f = fopen(rotfile, io_read);
	mmk = random(rraces);
	while(fread(f,templine,sizeof(templine),false))
	{
	    rand++;
		if(rand == mmk+1) rracenames=strtok(templine,idx);
	}
	fclose(f);
	fback = LoadRace(rracenames);
	if(fback == -1)
	{
		printf("ERROR in RacerX (iList.iRf): Race \'%s\' doesn't exist!",rracenames);
		RaceRotation();
	}
	else Cstartrace();
	return 1;
}

public PlayerF(playerid)
{
	if(!IsPlayerInAnyVehicle(playerid)){
	new Float:x2, Float:y2, Float:z2, Float:rott;
	GetPlayerPos(playerid, x2, y2, z2);
	GetPlayerFacingAngle(playerid, rott);
	//SetPlayerGravity(playerid, Gravity);
	if(racevehicle[playerid] != 1)
	{
		PlayerVehicle[playerid] = CreateVehicle(racevehicle[playerid], x2, y2, z2, rott, -1, -1, -1);
		new rand = random(MAX_CARCOLOURS);
		new rand2 = random(MAX_CARCOLOURS);
		ChangeVehicleColor(PlayerVehicle[playerid], CarColours[rand], CarColours[rand2]);
		SetVehicleNumberPlate(PlayerVehicle[playerid], "RacerX");
		SetVehicleVirtualWorld(PlayerVehicle[playerid], RaceWorld);
		PutPlayerInVehicle(playerid, PlayerVehicle[playerid], 0);
		if(!IsNosVehicleInvalid(racevehicle[playerid])) ShowMenuForPlayer(WheelsMenu, playerid);
		if(Nitrous != 0) AddVehicleComponent(PlayerVehicle[playerid], 1010);
		for(new j;j<MAX_PLAYERS;j++){
		if(!IsPlayerConnected(j)) continue;
		if(j == playerid) continue;
		SetVehicleParamsForPlayer(PlayerVehicle[playerid], j, false, true);
		}
		}
	}
	TogglePlayerControllable(playerid, false);
	RaceParticipant[playerid]=3;
	
	if(ReadyRef == 0)
	{
	    ReadyRef = 1;
		KillTimer(Countdown);
		Countdown = SetTimer("countdown", 1000, true);
		cd=60;
		SendClientMessageToAll(COLOUR_YELLOW, "Race will start in 60 seconds!");
	}
}

public MusicStop(playerid) RaceSound(playerid,0);

/*public OnPlayerExitedMenu(playerid)
{
	if(!IsValidMenu(GetPlayerMenu(playerid))) return 1;
	ShowMenuForPlayer(GetPlayerMenu(playerid), playerid);
	return 1;
}*/

public OnPlayerSelectedMenuRow(playerid, row)
{
	new Menu:Current = GetPlayerMenu(playerid);
	if(Current == WheelsMenu)
	{
	    switch(row)
	    {
	        case 0: AddVehicleComponent(GetPlayerVehicleID(playerid), 1074), HideMenuForPlayer(WheelsMenu, playerid);
			case 1: AddVehicleComponent(GetPlayerVehicleID(playerid), 1075), HideMenuForPlayer(WheelsMenu, playerid);
			case 2: AddVehicleComponent(GetPlayerVehicleID(playerid), 1077), HideMenuForPlayer(WheelsMenu, playerid);
			case 3: AddVehicleComponent(GetPlayerVehicleID(playerid), 1078), HideMenuForPlayer(WheelsMenu, playerid);
			case 4: AddVehicleComponent(GetPlayerVehicleID(playerid), 1079), HideMenuForPlayer(WheelsMenu, playerid);
			case 5: AddVehicleComponent(GetPlayerVehicleID(playerid), 1080), HideMenuForPlayer(WheelsMenu, playerid);
			case 6: AddVehicleComponent(GetPlayerVehicleID(playerid), 1081), HideMenuForPlayer(WheelsMenu, playerid);
			case 7: AddVehicleComponent(GetPlayerVehicleID(playerid), 1082), HideMenuForPlayer(WheelsMenu, playerid);
			case 8: AddVehicleComponent(GetPlayerVehicleID(playerid), 1025), HideMenuForPlayer(WheelsMenu, playerid);
			case 9: AddVehicleComponent(GetPlayerVehicleID(playerid), 1083), HideMenuForPlayer(WheelsMenu, playerid);
			case 10: AddVehicleComponent(GetPlayerVehicleID(playerid), 1085), HideMenuForPlayer(WheelsMenu, playerid);
		}
	}
	return 1;
}

public RefreshMenuHeader(playerid,Menu:menu,text[])
{
	SetMenuColumnHeader(menu,0,text);
	ShowMenuForPlayer(menu,playerid);
}

stock CreateRaceMenus()
{
	WheelsMenu = CreateMenu("Select Rims!", 1, 25, 170, 220, 25);
	AddMenuItem(WheelsMenu, 0, "Mega");
	AddMenuItem(WheelsMenu, 0, "RimShine");
	AddMenuItem(WheelsMenu, 0, "Classic");
	AddMenuItem(WheelsMenu, 0, "Twist");
	AddMenuItem(WheelsMenu, 0, "Cutter");
	AddMenuItem(WheelsMenu, 0, "Switch");
	AddMenuItem(WheelsMenu, 0, "Grove");
	AddMenuItem(WheelsMenu, 0, "Import");
	AddMenuItem(WheelsMenu, 0, "OffRoad");
	AddMenuItem(WheelsMenu, 0, "Dollar");
	AddMenuItem(WheelsMenu, 0, "Atomic");
}

stock ReturnVehicle(modelid)
{
	new vname[25]="Unknown";
	new foot[25]="On Foot";
	if(modelid == 1) return foot;
	else if((modelid < 400) || (modelid > 611)) return vname;
	memcpy(vname, VehicleNames[modelid - 400], 0, 100);
	return vname;
}

stock CreateText()
{
	TCountdown = TextDrawCreate(511, 95, " ");
	TextDrawLetterSize(TCountdown, 1.7, 3.8);
	TextDrawSetProportional(TCountdown, true);
	TextDrawFont(TCountdown, 1);
	TextDrawColor(TCountdown, COLOUR_YELLOW);
	Partici = TextDrawCreate(590, 360, "Par");
	Time = TextDrawCreate(550, 300, "Time");
	Append1 = TextDrawCreate(590, 335, "ST");
	TextDrawLetterSize(Append1, 0.5, 2.5);
	Append2 = TextDrawCreate(590, 335, "ND");
	TextDrawLetterSize(Append2, 0.5, 2.5);
	Append3 = TextDrawCreate(590, 335, "RD");
	TextDrawLetterSize(Append3, 0.5, 2.5);
	Append4 = TextDrawCreate(590, 335, "TH");
	TextDrawLetterSize(Append4, 0.5, 2.5);
	
	for(new i=0;i<MAX_PLAYERS;i++){
	Position[i] = TextDrawCreate(550, 310, "Checkpoints");
	//Diff[i] = TextDrawCreate(511, 95, " ");
	TPosition[i] = TextDrawCreate(560, 330, " ");
	TextDrawLetterSize(TPosition[i], 1.2, 6.2);
//	Speed[i] = TextDrawCreate(525, 310, "Speed");
	}
}

public RaceFix()
{
	new Float:Health;
    for(new i=0;i<MAX_PLAYERS;i++){
    if(!IsPlayerInAnyVehicle(i)) continue;
    GetVehicleHealth(PlayerVehicle[i], Float:Health);
 	if(RaceParticipant[i] > 1 && Health < 400)
 	{
 	    SetVehicleHealth(PlayerVehicle[i], 1000);
		RepairVehicle(PlayerVehicle[i]);
 	    xPlayerPlaySound(i, 1133);
 	}
 	}
}

stock LoadRandom()
{
	new File:f, templine[32], rotfile[]="iRaces/iList.iRf", rraces=-1, rracenames[32], mmk, rand, idx;
	f = fopen(rotfile, io_read);
	while(fread(f,templine,sizeof(templine),false))
	{
	    rraces++;
	}
	fclose(f);
	f = fopen(rotfile, io_read);
	mmk = random(rraces);
	while(fread(f,templine,sizeof(templine),false))
	{
	    rand++;
		if(rand == mmk+1) rracenames=strtok(templine,idx);
	}
	fclose(f);
	fback = LoadRace(rracenames);
	if(fback == -1)
	{
		printf("ERROR in RacerX's Random Load: Race \'%s\' doesn't exist!",rracenames);
		LoadRandom();
	}
	return 1;
}

public TimeTDUpdate(playerid)
{
	//Pos
	new string[32];
	if(Partsave < Participants)
	{
	    Partsave = Participants;
		format(string, sizeof(string), "/%i", Participants);
		TextDrawSetString(Partici, string);
	}
	
	for(new i=0;i<MAX_PLAYERS;i++){
	format(string, sizeof(string), "%i/%i", CurrentCheckpoint[i]-1, LCurrentCheckpoint);
	TextDrawSetString(Position[i], string);
	
/*	if(IsPlayerConnected(i) == 1)
	{
		GetPlayerPos(i, TelePos[i][3], TelePos[i][4], TelePos[i][5]);
		if(TelePos[i][5] > 550.0)
		{
			TelePos[i][0] = 0.0;
			TelePos[i][1] = 0.0;
		}
		if(TelePos[i][0] != 0.0)
		{
			new Float:xdist = TelePos[i][3]-TelePos[i][0];
			new Float:ydist = TelePos[i][4]-TelePos[i][1];
			new Float:sqxdist = xdist*xdist;
			new Float:sqydist = ydist*ydist;
			new Float:distance = (sqxdist+sqydist)/31;
			format(string, sizeof(string), "%.0f", distance);
			TextDrawSetString(Speed[i], string);
		}
		if(TelePos[i][5] < 550.0 && TelePos[i][3] != 0.0)
		{
			TelePos[i][0] = TelePos[i][3];
			TelePos[i][1] = TelePos[i][4];
		}
	}*/
	}
	//Time
	new	RaceString[10], RaceTime;
	RaceTime=GetRaceTick(playerid);
	RaceString=BeHumanCP(RaceTime);
	
	if(TopRacerTimes[0] == 0)
	{
        format(RaceString, sizeof(RaceString), "~y~%s", RaceString);
		TextDrawSetString(Time, RaceString);
	}
	else if(TopRacerTimes[0] < RaceTime)
	{
        format(RaceString, sizeof(RaceString), "~r~%s", RaceString);
		TextDrawSetString(Time, RaceString);
	}
	else if(TopRacerTimes[0] > RaceTime)
	{
        format(RaceString, sizeof(RaceString), "~g~%s", RaceString);
		TextDrawSetString(Time, RaceString);
	}
}

stock IsNumeric(const string[]) {
	new length=strlen(string);
	if (length==0) return false;
	for (new i = 0; i < length; i++) {
		if (
		(string[i] > '9' || string[i] < '0' && string[i]!='-' && string[i]!='+') // Not a number,'+' or '-'
		|| (string[i]=='-' && i!=0)                                             // A '-' but not at first.
		|| (string[i]=='+' && i!=0)                                             // A '+' but not at first.
		) return false;
	}
	if (length==1 && (string[0]=='-' || string[0]=='+')) return false;
	return true;
}

ReturnServerStringVar(const varname[])
{
    new str[64];
    GetServerVarAsString(varname, str, sizeof(str));
    return str;
}

stock xPlayerPlaySound(playerid, soundid)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
    PlayerPlaySound(playerid, soundid, x, y, z);
}

stock IsNosVehicleInvalid(modelid)
{
    #define MAX_INVALID_NOS_VEHICLES 29

    new InvalidNosVehicles[MAX_INVALID_NOS_VEHICLES] =
    {
        581,523,462,521,463,522,461,448,468,586,
        509,481,510,472,473,493,595,484,430,453,
        452,446,454,590,569,537,538,570,449
    };

    for(new i = 0; i < MAX_INVALID_NOS_VEHICLES; i++)
    {
        if(modelid == InvalidNosVehicles[i])
        {
            return true;
        }
	}
	return false;
}

public fdeleteline(filename[], line[]){
	if(fexist(filename)){
		new temp[256];
		new File:fhandle = fopen(filename,io_read);
		fread(fhandle,temp,sizeof(temp),false);
		if(strfind(temp,line,true)==-1){return 0;}
		else{
			fclose(fhandle);
			fremove(filename);
			for(new i=0;i<strlen(temp);i++){
				new templine[256];
				strmid(templine,temp,i,i+strlen(line));
				if(equal(templine,line,true)){
					strdel(temp,i,i+strlen(line));
					fcreate(filename);
					fhandle = fopen(filename,io_write);
					fwrite(fhandle,temp);
					fclose(fhandle);
					return 1;
				}
			}
		}
	}
	return 0;
}

public fcreate(filename[]) {
	if (fexist(filename)){return false;}
	new File:fhandle = fopen(filename,io_write);
	fclose(fhandle);
	return true;
}

stock equal(str1[],str2[],bool:ignorecase) {
    if (strlen(str1)!=strlen(str2)) return false;
    if (strcmp(str1,str2,ignorecase)==0) return true;
    return false;
}

stock SendWrappedMessageToPlayer(playerid, colour, const msg[], maxlength=85, const prefix[]="    ")
{
	new length = strlen(msg);
	if(length <= maxlength) {
		SendClientMessage(playerid, colour, msg);
		return 1;
	}
	new string[256], idx, space, plen, bool:useprefix;
	for(new i;i<length;i++) {
		if(i-idx+plen >= maxlength) {
			if(idx == space || i-space >= 20) {
				strmid(string, msg, idx, i);
				idx = i;
			}
			else {
				strmid(string, msg, idx, space);
				idx = space+1;
			}
			if(useprefix) strins(string, prefix, 0);
			else {
				plen = strlen(prefix);
				useprefix = true;
			}
			SendClientMessage(playerid, colour, string);
		}
		else if(msg[i]==' ') space = i;
	}
	if(idx < length) {
		strmid(string, msg, idx, length);
		strins(string, prefix, 0);
		SendClientMessage(playerid, colour, string);
	}
	return true;
}

stock FindPlayer(const string[])
{
	new id = strval(string);
	if(isAllNumeric(string) && id >= 0 && id < GetMaxPlayers()) {
		return IsPlayerConnected(id) ? id : INVALID_PLAYER_ID;
	}
	return ReturnPlayerID(string);
}

stock isAllNumeric(const string[])
{
	if(string[0] == '\0') return false;
	for(new i; string[i] != '\0'; i++) if(string[i] > '9' || string[i] < '0') return false;
	return true;
}

stock ReturnPlayerID(const playername[])
{
	if(playername[0] == 0) return INVALID_PLAYER_ID;
	new pid = INVALID_PLAYER_ID;
	for(new i, maxp = GetMaxPlayers(), bool:found, pname[MAX_PLAYER_NAME], length = strlen(playername); i < maxp; i++) {
		if(!IsPlayerConnected(i)) continue;
		GetPlayerName(i, pname, sizeof(pname));
		new j = strfind(pname, playername, true);
		if((j == 0) && (strlen(pname) == length)) return i;
		if(!found) {
			if(j == 0) {
				pid = i;
				found = true;
			}
			else if(j != -1 && pid == INVALID_PLAYER_ID) {
				pid = i;
			}
		}
	}
	return pid;
}

stock strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

