
//==============================================================================
//LUXADMIN EDIT BY KRISNA
//==============================================================================
// Includes
//==============================================================================
#include <a_samp>
#include <ldudb>
#include <lfuncs>

native WP_Hash(buffer[], len, const str[]);
#pragma dynamic 145000
//==============================================================================
//------------------------------------------------------------------------------
//                      	CONxGURATION
//------------------------------------------------------------------------------
//==============================================================================
//==============================================================================
// AdminScript Defines Config
// Only Numbers!
//==============================================================================
#define MAX_WARNINGS 		3 		// Max Warnings
#define MAX_RCON_ATTEMPS    5 		// Max Rcon Attemps
#define MAX_REPORTS 		7   	// Number Max of Reports per Player
#define MAX_CHAT_LINES 		100   	// Number of chat lines to view in Sv Console
#define SPAM_MAX_MSGS 		5  		// Max Spam Messages
#define SPAM_TIMELIMIT		8  		// In seconds
#define PING_MAX_EXCEEDS	4   	// Max Ping Exceeds
#define PING_TIMELIMIT 		60		// In seconds
#define MAX_FAIL_LOGINS     3 		// Max Login Attempts
#define MAX_ADV_WARNINGS    3 		// Max Warnings per Advertisements
#define ANNOUNCES_TIME      6000 	// Duration(Miliseconds) of every message in announcements (Only if "Announcements" is enabled) (Default: 6 secs)
//==============================================================================
// -> Disable/Enable
// true = Enable | false = Disable
//==============================================================================
#define EnableSpec         	true 	// Enable/Disable Spectating System (If you already using disable it. Set to 'false')
#define SaveLogs           	true    // Set 'false' if your server runs Linux (Logs wont be Saved!)
#define PM_CHAT_LOG         true 	// Enable/Disable to save PMs in Log
#define ADM_CHAT_LOG        true    // Enable/Disable to save AdmChat in Log
#define USE_DIALOGS 		true 	// Enable/Disable All Dialogs (Not Disable SERVER PASSWORD DIALOG)
#define USE_STATS           true 	// Enable/Disable Statistics
#define ADM_InMSG          	false 	// Put 'admin' in all messages sent by administrators (Ex: David(Admin): Welcome...)
#define SaveScore           true 	// Enable/Disable to save Player's Score
#define GpsCheckPoint      	true  	// Enable/Disable use RaceCheckpoints for indicate players In GPS.
#define GpsOnlyCity         true 	// True = Gps Show Only player City | False = Gps Show Player City and Zone.
#define ConfigInConsole     true    // Enable/Disable to Show Basic AdmScript Configuration in Console (When start the AdmScript)
#define EnableTwoRcon 		true    // Enable/Disable Two Rcon Passwords (2 Rcon passwords for more security!)
#define EnableCamHack 		true    // Enable/Disable LuxCam System - Administrators can move the camera! (Original By Sandra, modified by Me)
#define EnablePM_Cmd 		true    // Enable/Disable PM Command

//==============================================================================
// -> Only SA-MP Keys (Use 0 to disable)
//==============================================================================
#define ExecuteCmdKey 0 // Enable/Disable dialog for execute commands open with pressed Key!
//==============================================================================
// -> Use Two Rcon Passwords (Only if 'EnableTwoRcon' is enabled(True) !)
//==============================================================================
#define TwoRconPass "krisna12" //Define the Second RCON Password
//==============================================================================
// -> Account Commands
// WARNING: Not exceed 20 characters and is not recommended to use spaces!
//==============================================================================
#define RegisterCommand    register    // Define the Register Command
#define LoginCommand  	   login       // Define the Login Command
#define ChangePassCommand  changepass  // Define the ChangePassword Command
//==============================================================================
// -> Admin Name COLOR (In command /ADMINS) (Default: LIGHTBLUE2 and Orange)
//==============================================================================
#define Color_Basic_Moderator       orange  //Level 1
#define Color_Moderator             orange  //Level 2
#define Color_Master_Moderator      orange  //Level 3
#define Color_Administrator         orange  //Level 4
#define Color_Master_Administrator  orange  //Level 5
#define Color_Professional_Admin    orange  //Level +5 (ex:6,7,8...)
#define Color_RCON_Administrator  	LIGHTBLUE2  //Rcon Admin
//==============================================================================
// -> CamHack Configurations
// WARNING: Not modify if you not have experience!
//==============================================================================
#if EnableCamHack == true
#define SPEED_ROTATE_LEFTRIGHT_SLOW 0.5
#define SPEED_ROTATE_LEFTRIGHT_FAST 2.0
#define SPEED_ROTATE_UPDOWN_SLOW 0.05
#define SPEED_ROTATE_UPDOWN_FAST 0.15
#define SPEED_MOVE_UPDOWN_SLOW 0.25
#define SPEED_MOVE_UPDOWN_FAST 1.0
#define SPEED_MOVE_FORWARDBACKWARD_SLOW 0.4
#define SPEED_MOVE_FORWARDBACKWARD_FAST 2.0
#define SPEED_MOVE_LEFTRIGHT_SLOW 0.4
#define SPEED_MOVE_LEFTRIGHT_FAST 2.0
#endif
//==============================================================================
//CONFIG END!
//-----------
//==============================================================================
// Colours
//==============================================================================
#define LIGHTGREEN 	 0x38FF06FF
#define LIGHTBLUE2   0xF6BB0AA
#define LIGHTBLUE    0x0BBF6AA
#define COLOR_GREEN  0x33AA33AA
#define COLOR_PINK   0xFF66FFAA
#define COLOR_BLUE 	 0xB9C9BFF
#define COLOR_PURPLE 0x800080AA
#define COLOR_BLACK  0x000000AA
#define COLOR_WHITE  0xFFFFFFAA
#define COLOR_GREEN1 0x33AA33AA
#define COLOR_BROWN	 0xA52A2AAA
#define blue 		 0x375FFFFF
#define BlueMsg      0x0BBF6AA
#define white        0xFFFFFFAA
#define red 		 0xFF0000AA
#define lightred     0xFB0000AA
#define green 		 0x33FF33AA
#define yellow 		 0xFFFF00AA
#define grey 		 0xC0C0C0AA
#define Green1 		 0x129E12FF
#define Green2 	 	 0x53D212FF
#define blue1 		 0x2641FEAA
#define orange 		 0xFF9900AA
#define black 		 0x2C2727AA
//==============================================================================
// DCMD
//==============================================================================
#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
#define dcmd2(%1,%2,%3) if ((strcmp((%3)[1], %1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
//==============================================================================
// CapsLock
//==============================================================================
#define UpperToLower(%1) for(new ToLowerChar; ToLowerChar < strlen( %1 ); ToLowerChar ++ ) if ( %1[ ToLowerChar ]> 64 && %1[ ToLowerChar ] < 91 ) %1[ ToLowerChar ] += 32
//==============================================================================
// Spectator
//==============================================================================
#define ADMIN_SPEC_TYPE_NONE	0
#define ADMIN_SPEC_TYPE_PLAYER 	1
#define ADMIN_SPEC_TYPE_VEHICLE 2
//==============================================================================
// Dialogs
//==============================================================================
#define DIALOGID 909
#define DIALOG_TYPE_SERVLOCK    	790
#define DIALOG_TYPE_SERVUNLOCK      791
#define DIALOG_TYPE_SERVPASS    	792
#define DIALOG_TYPE_RCON2           793
#define DIALOG_TYPE_QUESTION        794
#define DIALOG_TYPE_PM		        795
//==============================================================================
// Zones
//==============================================================================
#define MAX_ZONE_NAME 28
//==============================================================================
// Variables
//==============================================================================

//==============================================================================
// -> Random Messages (Announcements)
//(Only if "Announcements" is enable in Config file)
//==============================================================================
new RandomMessages[][] =
{
    " ",
    " ",
    " ",
    " "
};
//==============================================================================


#if EnablePM_Cmd == true
new PMplayer1;
#endif

enum e_Register {
	sCommand[12],
	CommandLen
}

new RegisterCommands[3][e_Register]= {
	{""#RegisterCommand"",-1},{""#LoginCommand"",-1},{""#ChangePassCommand"",-1}
};

#define CMD_REGISTER \
	RegisterCommands[0][sCommand]
#define CMD_REGISTER_LEN \
	RegisterCommands[0][CommandLen]

#define CMD_LOGIN \
	RegisterCommands[1][sCommand]
#define CMD_LOGIN_LEN \
	RegisterCommands[1][CommandLen]

#define CMD_CHANGEPASS \
	RegisterCommands[2][sCommand]
#define CMD_CHANGEPASS_LEN \
	RegisterCommands[2][CommandLen]


#if EnableCamHack == true


new Float:PCP[MAX_PLAYERS][3]; // PCP = PlayerCameraPosition
new Float:PCL[MAX_PLAYERS][3]; // PCL = PlayerCameraLookat
new Float:PCA[MAX_PLAYERS];    // PCA = PlayerCameraAngle

new KeyTimer[MAX_PLAYERS];
new KeyState[MAX_PLAYERS];
new FollowOn[MAX_PLAYERS];
#endif


new cd_f,cd_sec,cd_timer, CdStated = 0, cdt[MAX_PLAYERS] = -1;

new Text:Announcements;

new AdminArea[6] = { 377,170,1008,90,3,0 //X,Y,Z,Angle,Interior,VirtualWorld
};

new LVersion[] = "v1.6 Beta";

enum PlayerData
{
	Registered,
	LoggedIn,
	pVip,
	Level,
	Muted,
	SpamCount,
	MaxAdv,
	#if EnableTwoRcon == true
	MaxRcon,
	#endif
	SpamTime,
	Caps,
	Kills,
	Deaths,
	God,
	Spawned,
	TimesSpawned,
	hours,
	mins,
	secs,
	MuteWarnings,
	Warnings,
	TotalTime,
	ConnectTime,
	GodCar,
	pColour,
	pCar,
	DoorsLocked,
	Frozen,
	FreezeTime,
	PingTime,
	PingCount,
	pPing[PING_MAX_EXCEEDS],
	BotPing,
	Hide,
	OnDuty,
	Jailed,
	JailTime,
	blipS,
	blip,
	SpecType,
	SpecID,
	FailLogin,
	bool:AllowedIn,
	pCaged,
	pInvis,
	pCageTime,
	pGps,
	NoQuestion,
	#if EnableCamHack == true
	InCamMod,
	LockedCam,
	#endif
};
enum ServerData
{
 	AntiSwear,
 	AntiSpam,
	MaxAdminLevel,
	MaxPing,
	ReadPMs,
	Locked,
	Password[128],
	ReadCmds,
 	NoCaps,
	AntiBot,
	AdminOnlySkins,
	AdminSkin,
	AdminSkin2,
	NameKick,
	PartNameKick,
	ConnectMessages,
	DisableChat,
	AdminCmdMsg,
	GiveMoney,
	GiveWeap,
	AutoLogin,
	MustLogin,
	MustRegister,
	ForbiddenWeaps,
	MaxMuteWarnings,
	AntiAds,
	Announce,
};


new AccInfo[MAX_PLAYERS][PlayerData],
	ServerInfo[ServerData],
	AdmRank[128],
	AdmDuty[128],
	AccType[128],
	ServerLockPass[128],
	BadWords[100][100], BadWordsCount = 0,
	Float:Pos[MAX_PLAYERS][4],
	Chat[MAX_CHAT_LINES][128],
	PingTimer,
	GodTimer,
	BlockedPartName[100][100], BlockedPartNameCount = 0,
	Float:LPosX[MAX_PLAYERS],
	Float:LPosY[MAX_PLAYERS],
	Float:LPosZ[MAX_PLAYERS],
	PingPos,
	IsDisable[MAX_PLAYERS],
	pColor;

//new Text:GpsTD[MAX_PLAYERS];

new VehicleNames[212][] = {
{"Landstalker"},{"Bravura"},{"Buffalo"},{"Linerunner"},{"Perrenial"},{"Sentinel"},{"Dumper"},
{"Firetruck"},{"Trashmaster"},{"Stretch"},{"Manana"},{"Infernus"},{"Voodoo"},{"Pony"},{"Mule"},
{"Cheetah"},{"Ambulance"},{"Leviathan"},{"Moonbeam"},{"Esperanto"},{"Taxi"},{"Washington"},
{"Bobcat"},{"Mr Whoopee"},{"BF Injection"},{"Hunter"},{"Premier"},{"Enforcer"},{"Securicar"},
{"Banshee"},{"Predator"},{"Bus"},{"Rhino"},{"Barracks"},{"Hotknife"},{"Trailer 1"},{"Previon"},
{"Coach"},{"Cabbie"},{"Stallion"},{"Rumpo"},{"RC Bandit"},{"Romero"},{"Packer"},{"Monster"},
{"Admiral"},{"Squalo"},{"Seasparrow"},{"Pizzaboy"},{"Tram"},{"Trailer 2"},{"Turismo"},
{"Speeder"},{"Reefer"},{"Tropic"},{"Flatbed"},{"Yankee"},{"Caddy"},{"Solair"},{"Berkley's RC Van"},
{"Skimmer"},{"PCJ-600"},{"Faggio"},{"Freeway"},{"RC Baron"},{"RC Raider"},{"Glendale"},{"Oceanic"},
{"Sanchez"},{"Sparrow"},{"Patriot"},{"Quad"},{"Coastguard"},{"Dinghy"},{"Hermes"},{"Sabre"},
{"Rustler"},{"ZR-350"},{"Walton"},{"Regina"},{"Comet"},{"BMX"},{"Burrito"},{"Camper"},{"Marquis"},
{"Baggage"},{"Dozer"},{"Maverick"},{"News Chopper"},{"Rancher"},{"FBI Rancher"},{"Virgo"},{"Greenwood"},
{"Jetmax"},{"Hotring"},{"Sandking"},{"Blista Compact"},{"Police Maverick"},{"Boxville"},{"Benson"},
{"Mesa"},{"RC Goblin"},{"Hotring Racer A"},{"Hotring Racer B"},{"Bloodring Banger"},{"Rancher"},
{"Super GT"},{"Elegant"},{"Journey"},{"Bike"},{"Mountain Bike"},{"Beagle"},{"Cropdust"},{"Stunt"},
{"Tanker"}, {"Roadtrain"},{"Nebula"},{"Majestic"},{"Buccaneer"},{"Shamal"},{"Hydra"},{"FCR-900"},
{"NRG-500"},{"HPV1000"},{"Cement Truck"},{"Tow Truck"},{"Fortune"},{"Cadrona"},{"FBI Truck"},
{"Willard"},{"Forklift"},{"Tractor"},{"Combine"},{"Feltzer"},{"Remington"},{"Slamvan"},
{"Blade"},{"Freight"},{"Streak"},{"Vortex"},{"Vincent"},{"Bullet"},{"Clover"},{"Sadler"},
{"Firetruck LA"},{"Hustler"},{"Intruder"},{"Primo"},{"Cargobob"},{"Tampa"},{"Sunrise"},{"Merit"},
{"Utility"},{"Nevada"},{"Yosemite"},{"Windsor"},{"Monster A"},{"Monster B"},{"Uranus"},{"Jester"},
{"Sultan"},{"Stratum"},{"Elegy"},{"Raindance"},{"RC Tiger"},{"Flash"},{"Tahoma"},{"Savanna"},
{"Bandito"},{"Freight Flat"},{"Streak Carriage"},{"Kart"},{"Mower"},{"Duneride"},{"Sweeper"},
{"Broadway"},{"Tornado"},{"AT-400"},{"DFT-30"},{"Huntley"},{"Stafford"},{"BF-400"},{"Newsvan"},
{"Tug"},{"Trailer 3"},{"Emperor"},{"Wayfarer"},{"Euros"},{"Hotdog"},{"Club"},{"Freight Carriage"},
{"Trailer 3"},{"Andromada"},{"Dodo"},{"RC Cam"},{"Launch"},{"Police Car (LSPD)"},{"Police Car (SFPD)"},
{"Police Car (LVPD)"},{"Police Ranger"},{"Picador"},{"S.W.A.T. Van"},{"Alpha"},{"Phoenix"},{"Glendale"},
{"Sadler"},{"Luggage Trailer A"},{"Luggage Trailer B"},{"Stair Trailer"},{"Boxville"},{"Farm Plow"},
{"Utility Trailer"}
};

new BlockedNames[100][100],
	BlockedNamesCount = 0,
	BlipTimer[MAX_PLAYERS],
	JailTimer[MAX_PLAYERS],
	FreezeTimer[MAX_PLAYERS],
	LockKickTimer[MAX_PLAYERS],
	InDuel[MAX_PLAYERS],
	Reports[MAX_REPORTS][128];

new cage[MAX_PLAYERS],
	cage2[MAX_PLAYERS],
	cage3[MAX_PLAYERS],
	cage4[MAX_PLAYERS];

//==============================================================================
// Forwards
//==============================================================================
forward ConnectedPlayers();
forward Jail1(player1);
forward RandomMessage();
forward VehicleOccupied(vehicleid);
forward WeaponCheck(playerid);
forward CheckKeyPress(playerid);
forward Duel(player1, player2);
forward FollowPlayer(playerid);
forward CagePlayer(playerid);
forward UnCagePlayer(playerid);
forward CagePrevent(playerid);
forward AutoKick(playerid);
forward DelayKillPlayer(playerid);
forward HighLight(playerid);
forward ReturnPosition(playerid);
forward LoadForbiddenWeapons();
forward CarSpawner(playerid,model);
forward VehRes(vehicleid);
forward EraseVeh(vehicleid);
forward Jail2(player1);
forward SaveTeleport();
forward Jail3(player1);
forward JailPlayer(player1);
forward UnjailPlayer(player1);
forward UnFreezeMe(player1);
forward PingKick();
forward UnloadFS();
forward RestartGM();
forward GodModUp();
forward BotCheck(playerid);
forward JailedPlayers();
forward FrozenPlayers();
forward MutedPlayers();
forward InVehTotal();
forward InCarCount();
forward OnBikeCount();
forward SaveIn(filename[],text[]);
forward RconAdminTotal();
forward LuxGpsSys(playerid);
forward PutAtPos(playerid);
forward AdminTotal();
forward CountDown(playerid);
forward PutAtDisconectPos(playerid);
forward MessageToAdmins(color,const string[]);
forward MessageToPlayerVIP(color,const string[]);
forward OnPlayerPrivmsg(playerid, recieverid, text[]);

//==============================================================================
//-------------------------------------------------
// FilterScript
//-------------------------------------------------
//==============================================================================


public OnFilterScriptInit()
{

	if (!fexist("LuxAdmin/Config/TempBans.ban")){
	new File:open = fopen("LuxAdmin/Config/TempBans.ban",io_write);
	if (open) fclose(open);
	}

	print("\n ___________________________________________________");
	print(" ");
    printf("                   L.A.S %s                         ",LVersion);
   	print("                 ---------------");
	print("             LuX Administration System               ");
	print(" ___________________________________________________\n");
	print(" -> Loading...");

    CheckFolders();
	UpdateConfig();
	ReadTextDraws();
	LoadCreatedTeles();

	for(new i = 0; i < MAX_PLAYERS; i++)
	if(IsPlayerConnected(i))
	OnPlayerConnect(i);

	for(new i = 1; i < MAX_CHAT_LINES; i++)
	Chat[i] = "[NONE]";

	for(new i = 1; i < MAX_REPORTS; i++)
	Reports[i] = "[NONE]";

	PingTimer = SetTimer("PingKick",5000,1);
	GodTimer = SetTimer("GodModUp",2000,1);
	SetTimer("WeaponCheck",800,true);
	SetTimer("SaveTeleport",CTELE_TIMER,1);
	SetTimer("LuxGpsSys",500,true);
	SetTimer("RandomMessage",ANNOUNCES_TIME,1);
	ShowConfigInConsole();

	new year,month,day;
	getdate(year, month, day);
	new hour,minute,second;
	gettime(hour,minute,second);


	for(new i = 0; i < sizeof(RegisterCommands) ; i++ )
	RegisterCommands[i][CommandLen]=strlen(RegisterCommands[i][sCommand]);


    print(" -> Loaded Successfully!\n");
	printf(" Date: %d/%d/%d - Time: %d:%d:%d",day,month,year,hour, minute, second);
	print(" ___________________________________________________\n");
	return 1;
}

//==============================================================================
public OnFilterScriptExit()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
    TextDrawHideForPlayer(i, Announcements);

	KillTimer(PingTimer); KillTimer(GodTimer);
	SaveTeleport();

	print("\n ___________________________________________________");
	print(" ");
    printf("                   L.A.S %s                         ",LVersion);
   	print("                 -------------");
	print("             LuX Administration System               ");
	print(" ___________________________________________________\n");
	print(" -> Unload!");
	return 1;
}
//==============================================================================
//-------------------------------------------------
// Player Connected
//-------------------------------------------------
//==============================================================================
public OnPlayerConnect(playerid)
{
    #if EnableCamHack == true
    KeyState[playerid] = 0;
    FollowOn[playerid] = 0;
    AccInfo[playerid][InCamMod] 	= 0;
    AccInfo[playerid][LockedCam] 	= 0;
    #endif
	AccInfo[playerid][Deaths] 		= 0;
	AccInfo[playerid][Kills] 		= 0;
	AccInfo[playerid][Jailed]		= 0;
	AccInfo[playerid][Frozen]		= 0;
	AccInfo[playerid][Level] 		= 0;
	AccInfo[playerid][pVip]         = 0;

	AccInfo[playerid][LoggedIn] 	= 0;
	AccInfo[playerid][Registered] 	= 0;
	AccInfo[playerid][God] 			= 0;
	AccInfo[playerid][GodCar]		= 0;
	AccInfo[playerid][TimesSpawned]	= 0;
	AccInfo[playerid][Muted] 		= 0;
	AccInfo[playerid][MuteWarnings]	= 0;
	AccInfo[playerid][Warnings] 	= 0;
	AccInfo[playerid][Caps]			= 0;
	AccInfo[playerid][DoorsLocked] 	= 0;
	AccInfo[playerid][pCar]			= -1;
	AccInfo[playerid][SpamCount] 	= 0;
	AccInfo[playerid][MaxAdv] 		= 0;
	AccInfo[playerid][SpamTime] 	= 0;
	AccInfo[playerid][PingCount] 	= 0;
	AccInfo[playerid][PingTime]		= 0;
	AccInfo[playerid][FailLogin] 	= 0;
	AccInfo[playerid][Hide] 		= 0;
	AccInfo[playerid][pInvis]   	= 0;
	AccInfo[playerid][OnDuty]   	= 0;
	AccInfo[playerid][pGps] 		= -1;

	#if EnableTwoRcon == true
	AccInfo[playerid][MaxRcon] = 0;
	#endif

	AccInfo[playerid][ConnectTime] = gettime();
    for(new i; i<PING_MAX_EXCEEDS; i++)
	AccInfo[playerid][pPing][i] = 0;
	//------------------------------------------------------
	new string[128];
    //new str[128];
	new file[256];
	new PlayerName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, PlayerName, MAX_PLAYER_NAME);
	new tmp3[50]; GetPlayerIp(playerid,tmp3,50);

	ResetForbiddenWeaponsForPlayer(playerid);
	TempBanCheck(playerid);
//==============================================================================
// Connect Messages
//==============================================================================
	/*if(ServerInfo[ConnectMessages] == 1)
	{
	    new pAKA[256];
		pAKA = dini_Get("LuxAdmin/Config/aka.txt",tmp3);
		if (strlen(pAKA) < 3)
		format(str,sizeof(str),"*{A8A8A8}Player %s (Id:%d) has {00C100}joined {A8A8A8}the server", PlayerName,playerid);
		else if (!strcmp(pAKA,PlayerName,true))
		format(str,sizeof(str),"*{A8A8A8}Player %s (Id:%d) has {00C100}joined {A8A8A8}the server", PlayerName,playerid);
		else format(str,sizeof(str),"{A8A8A8}Player %s (Id:%d) has {00C100}joined {A8A8A8}the server",PlayerName,playerid);

		for(new i = 0; i < MAX_PLAYERS; i++)
		if(IsPlayerConnected(i) && playerid != i)
		{
		if(AccInfo[i][Level] > 2)
		SendClientMessage(i,grey,str);
		else
		{
		format(string,sizeof(string),"*{A8A8A8}Player %s (Id:%d) has {00C100}joined {A8A8A8}the server", PlayerName, playerid);
 	    SendClientMessage(i,grey,string);
		}
		}
	}*/
//==============================================================================
// If PlayerName is Banned
//==============================================================================
    if (dUserINT(PlayerName2(playerid)).("Banned") == 1)
    {
        SendClientMessage(playerid, red, "ATTENTION: This name is banned from this server!");
		format(string,sizeof(string),"|- Player %s (Id:%d) has beenAutomatically  Kicked. | Reason: Name Banned! -|",PlayerName,playerid);
		SendClientMessageToAll(red, string);  print(string);
		SaveIn("KickLog",string);  Kick(playerid);
    }
//==============================================================================
// Kick Forbidden Name
//==============================================================================
	if(ServerInfo[NameKick] == 1)
	{
		for(new s = 0; s < BlockedNamesCount; s++)
		{
  			if(!strcmp(BlockedNames[s],PlayerName,true))
			{
			SendClientMessage(playerid,red, "ATTENTION: Your name is on our Black List, you have been Kicked.");
			format(string,sizeof(string),"|- Player %s (Id:%d) has been Automatically Kicked. | Reason: Forbidden Name -|",PlayerName,playerid);
			SendClientMessageToAll(red, string);
			print(string);
			SaveIn("KickLog",string);
			Kick(playerid);
			return 1;
			}
		}
	}
//==============================================================================
// Kick Forbidden Part of Name
//==============================================================================
	if(ServerInfo[PartNameKick] == 1)
	{
		for(new s = 0; s < BlockedPartNameCount; s++)
		{
			new pos;
			while((pos = strfind(PlayerName,BlockedPartName[s],true)) != -1)
			for(new i = pos, j = pos + strlen(BlockedPartName[s]); i < j; i++)
			{
			SendClientMessage(playerid,red, "ATTENTION: Your name is not Allowed on this server, you have been Kicked!.");
			format(string,sizeof(string),"|- Player %s (Id:%d) has been Automatically Kicked. | Reason: Forbidden Name -|",PlayerName,playerid);
			SendClientMessageToAll(red, string);  print(string);
			SaveIn("KickLog",string);  Kick(playerid);
			return 1;
			}
		}
	}
//==============================================================================
// Server Locked
//==============================================================================
	if(ServerInfo[Locked] == 1)
	{
		AccInfo[playerid][AllowedIn] = false;
		SendClientMessage(playerid,red,"|- Server is Locked! -|");
		SendClientMessage(playerid,red,"|- You have 40 seconds to enter the server Password! -|");
		LockKickTimer[playerid] = SetTimerEx("AutoKick", 40000, 0, "i", playerid);
	}
 	if (ServerInfo[Locked] == 1 && AccInfo[playerid][AllowedIn] == false)
    {
        ShowPlayerDialog(playerid, DIALOG_TYPE_SERVPASS, DIALOG_STYLE_INPUT,
		"Server Locked!.", "Enter the password to Access it:", "Access", "Exit");
	}
//==============================================================================
// Register & Login
//==============================================================================
	if(strlen(dini_Get("LuxAdmin/Config/aka.txt", tmp3)) == 0)
	dini_Set("LuxAdmin/Config/aka.txt", tmp3, PlayerName);
 	else
	{
	    if( strfind( dini_Get("LuxAdmin/Config/aka.txt", tmp3), PlayerName, true) == -1 )
		{
  		format(string,sizeof(string),"%s,%s", dini_Get("LuxAdmin/Config/aka.txt",tmp3), PlayerName);
	   	dini_Set("LuxAdmin/Config/aka.txt", tmp3, string);
		}
 	}
	if(!udb_Exists(PlayerName2(playerid)))
	SendClientMessage(playerid,orange, "SERVER: Your account isn't registered. Please register (/"#RegisterCommand")");
	else
	{
 	AccInfo[playerid][Registered] = 1;
	format(file,sizeof(file),"/LuxAdmin/Accounts/%s.sav",udb_encode(PlayerName));
	new tmp2[256]; tmp2 = dini_Get(file,"Ip");

	if( (!strcmp(tmp3,tmp2,true)) && (ServerInfo[AutoLogin] == 1))
	{
		LoginPlayer(playerid);
		if(AccInfo[playerid][Level] > 0)
		{
			switch(AccInfo[playerid][Level])
			{
				case 1: AdmRank = "Basic Moderator";
				case 2: AdmRank = "Moderator";
				case 3: AdmRank = "Master Moderator";
				case 4: AdmRank = "Administrator";
				case 5: AdmRank = "Master Administrator";
			}
			if(AccInfo[playerid][Level] > 5)
			{
				AdmRank = "Professional Admin";
			}
			if(AccInfo[playerid][pVip] > 0)
			{
				switch(AccInfo[playerid][pVip])
				{
					case 1: AccType = "Silver";
					case 2: AccType = "Gold";
					case 3: AccType = "Platinum";
				}
				format(string,sizeof(string),"|- You have been Automatically Logged in | Account: %s | Level %d - %s -|", AccType, AccInfo[playerid][Level],AdmRank);
				SendClientMessage(playerid,0x00C378AA,string);
			}
			else
			{
				format(string,sizeof(string),"|- You have been Automatically Logged in | Level %d - %s -|", AccInfo[playerid][Level],AdmRank);
				SendClientMessage(playerid,green,string);
			}
//==============================================================================
		}
		else
		{
			if(AccInfo[playerid][pVip] > 0)
			{
				switch(AccInfo[playerid][pVip])
				{
					case 1: AccType = "Silver";
					case 2: AccType = "Gold";
					case 3: AccType = "Platinum";
				}
				format(string,sizeof(string),"|- You have been Automatically Logged in - Account Type: %s", AccType);
				SendClientMessage(playerid,0x00C896AA,string);
			}
			else
			{
				format(string,sizeof(string),"|- You have been Automatically Logged in");
				SendClientMessage(playerid,green,string);
   			}
		}
  	}
 	else SendClientMessage(playerid, white, "That account is registered!") &&
	SendClientMessage(playerid, orange, "Please login to access your Account (/"#LoginCommand")");
	}
 	return 1;
}
//==============================================================================
// Automatic Kick
//==============================================================================
public AutoKick(playerid)
{
	if( IsPlayerConnected(playerid) && ServerInfo[Locked] == 1 && AccInfo[playerid][AllowedIn] == false)
	{
	new string[128];
	SendClientMessage(playerid,grey,"|- You have been Automatically Kicked. | Reason: Server Locked -|");
	format(string,sizeof(string),"|- Player %s (Id:%d) has been Automatically Kicked. | Reason: Server Locked -|",PlayerName2(playerid),playerid);
	SaveIn("KickLog",string);
	Kick(playerid);
	SendClientMessageToAll(red, string);
	print(string);
	}
	return 1;
}
//==============================================================================
//-------------------------------------------------
// Player Disconnect
//-------------------------------------------------
//==============================================================================
public OnPlayerDisconnect(playerid, reason)
{
	new PlayerName[MAX_PLAYER_NAME], str[128];
	GetPlayerName(playerid, PlayerName, sizeof(PlayerName));

	if(AccInfo[playerid][LoggedIn] == 1)
	SavePlayerStats(playerid);

	if(udb_Exists(PlayerName2(playerid))) dUserSetINT(PlayerName2(playerid)).("Loggedin",0);
  	AccInfo[playerid][LoggedIn] = 0;
	AccInfo[playerid][Level] 	= 0;
	AccInfo[playerid][pVip] 	= 0;
	AccInfo[playerid][Jailed] 	= 0;
	AccInfo[playerid][pCaged]   = 0;
	AccInfo[playerid][MaxAdv]   = 0;
	AccInfo[playerid][Frozen] 	= 0;
	AccInfo[playerid][Hide]   	= 0;
	AccInfo[playerid][OnDuty]  	= 0;
	AccInfo[playerid][pInvis]  	= 0;
	AccInfo[playerid][pGps]		= -1;

	#if EnableTwoRcon == true
	AccInfo[playerid][MaxRcon] 	= 0;
	#endif

	if(AccInfo[playerid][Jailed] == 1)
	KillTimer( JailTimer[playerid] );

	if(AccInfo[playerid][Frozen] == 1)
	KillTimer( FreezeTimer[playerid] );

	if(ServerInfo[Locked] == 1)
	KillTimer( LockKickTimer[playerid] );

	if(AccInfo[playerid][pCar] != -1) EraseVeh(AccInfo[playerid][pCar]);
//------------------------------------------------------------------------------
// Spectating
//------------------------------------------------------------------------------
	for(new x=0; x<MAX_PLAYERS; x++)
    if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && AccInfo[x][SpecID] == playerid)
	AdvanceSpectate(x);
//------------------------------------------------------------------------------
	if(ServerInfo[ConnectMessages] == 1)
	{
	switch (reason)
	{
	case 0:
	format(str, sizeof(str), "*{A8A8A8}Player %s (Id:%d) has {FF0000}left {A8A8A8}the Server (Timeout)", PlayerName, playerid);
 	case 1:
	format(str, sizeof(str), "*{A8A8A8}Player %s (Id:%d) has {FF0000}left {A8A8A8}the Server (Leaving)", PlayerName, playerid);
	case 2:
	format(str, sizeof(str), "*{A8A8A8}Player %s (Id:%d) has {FF0000}left {A8A8A8}the Server (Kicked/Banned)", PlayerName, playerid);
	}
	SendClientMessageToAll(grey, str);
    }
    #if EnableCamHack == true
   	if(AccInfo[playerid][InCamMod] == 1)
	{
	    KillTimer(KeyTimer[playerid]);
		AccInfo[playerid][InCamMod] = 0;
	}
	#endif
 	return 1;
}
public DelayKillPlayer(playerid)
{
	SetPlayerHealth(playerid,0.0);
	ForceClassSelection(playerid);
}

stock GetServerHostName()
{
new gString[256];
GetServerVarAsString("hostname", gString, sizeof(gString));
return gString;
}


public OnPlayerRequestSpawn(playerid)
{
	// Request Register
	if(AccInfo[playerid][Registered] == 0 && ServerInfo[MustRegister] == 1 && (!IsPlayerNPC(playerid))){
	SendClientMessage(playerid,lightred,"SERVER: Your account isn't registered. Please Register! | /"#RegisterCommand" [Password]");
	return 0;
	}
	// Request Login
	if(ServerInfo[MustLogin] == 1 && AccInfo[playerid][Registered] == 1 && AccInfo[playerid][LoggedIn] == 0 && (!IsPlayerNPC(playerid))){
 	SendClientMessage(playerid,lightred,"SERVER: Your account is registered. Please Login! | /"#LoginCommand" [Password]");
	return 0;
	}
	return 1;
	}
//==============================================================================
public OnPlayerRequestClass(playerid)
{
//==============================================================================
// Request Register
//==============================================================================
	if(AccInfo[playerid][Registered] == 0 && ServerInfo[MustRegister] == 1)
	{
		#if USE_DIALOGS == false
		new rstring[256];
		format(rstring,256,"Welcome to the '%s'\n\nAccount '%s' is not registred!\n\nEnter the password to Register your Account:",GetServerHostName(),pName(playerid));
		ShowPlayerDialog(playerid,DIALOGID+66,DIALOG_STYLE_PASSWORD,"Register Account",rstring,"Register","Quit");
		#endif
		return 1;
	}
//==============================================================================
// Request Login
//==============================================================================
	if(ServerInfo[MustLogin] == 1 && AccInfo[playerid][Registered] == 1 && AccInfo[playerid][LoggedIn] == 0)
	{
		#if USE_DIALOGS == false
		new lstring[256];
		format(lstring,256,"That account '%s 'is Registered!\n\n Login to access your Account:",pName(playerid));
		ShowPlayerDialog(playerid,DIALOGID+67,DIALOG_STYLE_PASSWORD,"Login Account",lstring,"Login","Quit");
		#endif
		return 1;
	}
	return 1;
}
//-------------------------------------------------
// Player Spawn
//-------------------------------------------------
//==============================================================================
public OnPlayerSpawn(playerid)
{
//==============================================================================
// Player Frozen (Prevent scape)
//==============================================================================
	AccInfo[playerid][Spawned] = 1;

	if(AccInfo[playerid][Frozen] == 1) {
		TogglePlayerControllable(playerid,false);
		return SendClientMessage(playerid,red,"|- You cant escape your punishment. You Are Still Frozen -|");
	}
//==============================================================================
// Player Jail (Prevent scape)
//==============================================================================
	if(AccInfo[playerid][Jailed] == 1) {
	    SetTimerEx("JailPlayer",3000,0,"d",playerid);
		return SendClientMessage(playerid,red,"|- You cant escape your punishment. You Are Still In Jail -|");
	}
//==============================================================================
// Administrators Skins/Prevent players to use
//==============================================================================
	if(ServerInfo[AdminOnlySkins] == 1)
	{
		if( (GetPlayerSkin(playerid) == ServerInfo[AdminSkin]) || (GetPlayerSkin(playerid) == ServerInfo[AdminSkin2]))
		{
			if(AccInfo[playerid][Level] >= 1)
			GameTextForPlayer(playerid,"~b~Welcome~n~~w~Admin",3000,1);
			else
			{
			GameTextForPlayer(playerid,"~r~This Skin Is For~n~Administrators~n~Only",4000,1);
			SetTimerEx("DelayKillPlayer", 2500,0,"d",playerid);
			return 1;
			}
		}
	}
	if((dUserINT(PlayerName2(playerid)).("UseSkin")) == 1)
		if((AccInfo[playerid][Level] >= 1) && (AccInfo[playerid][LoggedIn] == 1))
		SetPlayerSkin(playerid,(dUserINT(PlayerName2(playerid)).("FavSkin")) );

//==============================================================================
// Verify player in CAGE
//==============================================================================
	if(AccInfo[playerid][pCaged] == 1)
	{
 	SetTimerEx("CagePrevent", 300, 0, "i", playerid);
 	}
	if(ServerInfo[Announce] == 1)
 	TextDrawShowForPlayer(playerid, Announcements);
//==============================================================================
// Weapons
//==============================================================================
	if(ServerInfo[GiveWeap] == 1)
	{
		if(AccInfo[playerid][LoggedIn] == 1)
		{
			AccInfo[playerid][TimesSpawned]++;
			if(AccInfo[playerid][TimesSpawned] == 1)
			{
			GivePlayerWeapon(playerid,dUserINT(PlayerName2(playerid)).("Weapon1"),dUserINT(PlayerName2(playerid)).("Weapon1Ammo"));
			GivePlayerWeapon(playerid,dUserINT(PlayerName2(playerid)).("Weapon2"),dUserINT(PlayerName2(playerid)).("Weapon2Ammo"));
			GivePlayerWeapon(playerid,dUserINT(PlayerName2(playerid)).("Weapon3"),dUserINT(PlayerName2(playerid)).("Weapon3Ammo"));
			GivePlayerWeapon(playerid,dUserINT(PlayerName2(playerid)).("Weapon4"),dUserINT(PlayerName2(playerid)).("Weapon4Ammo"));
			GivePlayerWeapon(playerid,dUserINT(PlayerName2(playerid)).("Weapon5"),dUserINT(PlayerName2(playerid)).("Weapon5Ammo"));
			GivePlayerWeapon(playerid,dUserINT(PlayerName2(playerid)).("Weapon6"),dUserINT(PlayerName2(playerid)).("Weapon6Ammo"));
			}
		}
	}
	return 1;
}

//==============================================================================
//-------------------------------------------------
// Player Death
//-------------------------------------------------
//==============================================================================
public OnPlayerDeath(playerid, killerid, reason)
{
	#if USE_STATS == true
    AccInfo[playerid][Deaths]++;
	#endif
    InDuel[playerid] = 0;

    if(AccInfo[playerid][pCaged] == 1)
    {
   	cage[playerid] 	= DestroyObject(cage[playerid]);
	cage2[playerid] = DestroyObject(cage2[playerid]);
	cage3[playerid] = DestroyObject(cage3[playerid]);
	cage4[playerid] = DestroyObject(cage4[playerid]);
	}

	if(IsPlayerConnected(killerid) && killerid != INVALID_PLAYER_ID)
	{
		#if USE_STATS == true
		AccInfo[killerid][Kills]++;
	    #endif
//==============================================================================
// In Duel
//==============================================================================
		if(InDuel[playerid] == 1 && InDuel[killerid] == 1)
		{
		GameTextForPlayer(playerid,"Loser!",3000,3);
		GameTextForPlayer(killerid,"Winner!",3000,3);
		InDuel[killerid] = 0;
		SetPlayerPos(killerid, 0.0, 0.0, 0.0);
		SpawnPlayer(killerid);
		}
		else if(InDuel[playerid] == 1 && InDuel[killerid] == 0)
		{
		GameTextForPlayer(playerid,"Loser !",3000,3);
		}
	}
//==============================================================================
// Spectate
//==============================================================================
	for(new x=0; x<MAX_PLAYERS; x++)
	    if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && AccInfo[x][SpecID] == playerid)
     	AdvanceSpectate(x);
	return 1;
}
//==============================================================================
//-------------------------------------------------
// Player Text
//-------------------------------------------------
//==============================================================================
public OnPlayerText(playerid, text[])
{
//==============================================================================
// Vip Chat
//==============================================================================
	if(text[0] == '*' && AccInfo[playerid][pVip] >= 1)
	{
	    new string[128]; GetPlayerName(playerid,string,sizeof(string));
		format(string,sizeof(string),"|DSPD/CIA| %s: %s",string,text[1]);
		MessageToPlayerVIP(0xFF00FFFF,string);
		SaveIn("ChatVipLog",string);
	    return 0;
	}
//==============================================================================
// Administration Chat
//==============================================================================
	if(text[0] == '#' && AccInfo[playerid][Level] >= 1)
	{
	    new string[128]; GetPlayerName(playerid,string,sizeof(string));
		format(string,sizeof(string),"Admin Chat: %s: %s",string,text[1]);
		MessageToAdmins(green,string);
		#if ADM_CHAT_LOG == true
		SaveIn("AdmChatLog",string);
		#endif
	    return 0;
	}
//==============================================================================
// Chat Disabled
//==============================================================================
	if(ServerInfo[DisableChat] == 1)
	{
		SendClientMessage(playerid,red,"|- Chat has been Disabled! -|");
	 	return 0;
	}
//==============================================================================
// Player Muted
//==============================================================================
 	if(AccInfo[playerid][Muted] == 1)
	{
 		AccInfo[playerid][MuteWarnings]++;
 		new string[128];
		if(AccInfo[playerid][MuteWarnings] < ServerInfo[MaxMuteWarnings])
		{
		format(string, sizeof(string),"|- ATTENTION: You are Muted! Cannot talk (Warnings: %d/%d) -|",AccInfo[playerid][MuteWarnings],ServerInfo[MaxMuteWarnings]);
		SendClientMessage(playerid,red,string);
		}
		else
		{
		SendClientMessage(playerid,red,"|- You have been Automatically Kicked. | Reason: Exceeding Mute Warnings -|");
		format(string, sizeof(string),"|- Player %s (Id:%d) has been Automatically Kicked. | Reason: Exceeding Mute Warnings -|",PlayerName2(playerid),playerid);
		SendClientMessageToAll(grey,string);
		SaveIn("KickLog",string); Kick(playerid);
		} return 0;
	}
//==============================================================================
// Flood/Spam Protection
//==============================================================================
	if(ServerInfo[AntiSpam] == 1 && (AccInfo[playerid][Level] == 0 && !IsPlayerAdmin(playerid)))
	{
		if(AccInfo[playerid][SpamCount] == 0) AccInfo[playerid][SpamTime] = TimeStamp();

	    AccInfo[playerid][SpamCount]++;
		if(TimeStamp() - AccInfo[playerid][SpamTime] > SPAM_TIMELIMIT) { // Its OK your messages were far enough apart
			AccInfo[playerid][SpamCount] = 0;
			AccInfo[playerid][SpamTime] = TimeStamp();
		}
		else if(AccInfo[playerid][SpamCount] == SPAM_MAX_MSGS) {
			new string[64]; format(string,sizeof(string),"|- Player %s (Id:%d) has been Automatically Kicked. | Reason: Flood/Spam Protection", PlayerName2(playerid),playerid);
			SendClientMessageToAll(grey,string); print(string);
			SaveIn("KickLog",string);
			Kick(playerid);
		}
		else if(AccInfo[playerid][SpamCount] == SPAM_MAX_MSGS-1) {
			SendClientMessage(playerid,red,"ATTENTION: Anti Spam Warning! Next is a Kick!");
			return 0;
		}
	}
//==============================================================================
// Send Admin in front of name
//==============================================================================
	#if ADM_InMSG == true
	if (AccInfo[playerid][Hide] == 0)
	{
	if(AccInfo[playerid][Level] > 0)
	{
	new str3[256];
	format(str3, 256, "(Admin): %s", text);
	for(new gz=0;gz<200;gz++)
	if(IsPlayerConnected(gz))
	SendPlayerMessageToPlayer(gz, playerid, str3);
	else SendPlayerMessageToPlayer(gz, playerid, text);
	}
	return 0;
	}
	#endif
//==============================================================================
// Forbidden Words
//==============================================================================
	if(ServerInfo[AntiSwear] == 1 && AccInfo[playerid][Level] < ServerInfo[MaxAdminLevel])
	for(new s = 0; s < BadWordsCount; s++)
	{
	new pos;
	while((pos = strfind(text,BadWords[s],true)) != -1)
	for(new i = pos, j = pos + strlen(BadWords[s]); i < j; i++) text[i] = '*';
	}
//==============================================================================
// Anti Advertisements
//==============================================================================
	if(ServerInfo[AntiAds] == 1)
	{
		if(AdvertisementCheck(text) && AccInfo[playerid][Level] < 3)
		{
			AccInfo[playerid][MaxAdv]++;
			new string[128];
			format(string,sizeof(string),"|- Warning! Suspected ads in your message! (Warnings: %d/%d)",AccInfo[playerid][MaxAdv], MAX_ADV_WARNINGS);
			SendClientMessage(playerid, grey,string);

			if(AccInfo[playerid][MaxAdv] == MAX_ADV_WARNINGS)
			{
				format(string,sizeof(string),"|- You is Automatically Kicked. | Reason: Many ads in your Messages (%d/%d) -|",AccInfo[playerid][MaxAdv], MAX_ADV_WARNINGS);
 				SendClientMessage(playerid, lightred,string);

 				format(string,sizeof(string),"|- Player %s (Id:%d) has beenAutomatically  Kicked. | Reason: Many Advertisements! (%d) -|",PlayerName2(playerid),playerid, MAX_ADV_WARNINGS);
 				SaveIn("KickLog",string); Kick(playerid);
				SendClientMessageToAll(lightred, string);
				print(string);
			}
			return 0;
		}
	}
//==============================================================================
// Block CapsLock
//==============================================================================
	if(AccInfo[playerid][Caps] == 1)
	UpperToLower(text);
	if(ServerInfo[NoCaps] == 1)
	UpperToLower(text);

//==============================================================================
// Chat Lines (Console)
//==============================================================================
	for(new i = 1; i < MAX_CHAT_LINES-1; i++)
	Chat[i] = Chat[i+1];
	new ChatSTR[128];
	GetPlayerName(playerid,ChatSTR,sizeof(ChatSTR));
	format(ChatSTR,128,"[CHAT]%s: %s",ChatSTR, text[0]);
	Chat[MAX_CHAT_LINES-1] = ChatSTR;
	return 1;
}
//==============================================================================
//-------------------------------------------------
// Private Message (PM)
//-------------------------------------------------
//==============================================================================
public OnPlayerPrivmsg(playerid, recieverid, text[])
{
	if(ServerInfo[ReadPMs] == 1 && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
	{
//==============================================================================
// Send PM
//==============================================================================
    	new string[128];
		new pReciever[MAX_PLAYER_NAME];
		GetPlayerName(playerid, string, sizeof(string));
		GetPlayerName(recieverid, pReciever, sizeof(pReciever));
		format(string, sizeof(string), "|- PM: %s To %s: %s", string, pReciever, text);
  		for (new a = 0; a < MAX_PLAYERS; a++)
		if(IsPlayerConnected(a) && (AccInfo[a][Level] >= ServerInfo[MaxAdminLevel]) && a != playerid)
		SendClientMessage(a, grey, string);
		#if PM_CHAT_LOG == true
		SaveIn("AdmChatLog",string);
		#endif
	}
//==============================================================================
// Muted
//==============================================================================
 	if(AccInfo[playerid][Muted] == 1)
	{
		new string[128];
 		AccInfo[playerid][MuteWarnings]++;
		if(AccInfo[playerid][MuteWarnings] < ServerInfo[MaxMuteWarnings])
		{
		format(string, sizeof(string),"|- ATTENTION: You are Muted! Cannot talk (Warnings: %d/%d) -|",AccInfo[playerid][MuteWarnings],ServerInfo[MaxMuteWarnings]);
		SendClientMessage(playerid,red,string);
		}
		else
		{
		SendClientMessage(playerid,red,"|- You have been Automatically Kicked. | Reason: Exceeding Mute Warnings -|");
		GetPlayerName(playerid, string, sizeof(string));
		format(string, sizeof(string),"|- Player %s (Id:%d) has been Automatically Kicked. | Reason: Exceeding Mute Warnings -|", string, playerid);
		SendClientMessageToAll(lightred,string);
		SaveIn("KickLog",string);
		Kick(playerid);
		}
		return 0;
	}
	#if EnablePM_Cmd == true
	new string[128];
	GetPlayerName(playerid, string, sizeof(string));
	format(string,256,"|- {FF0000}PM: {00FF40}Message to {FFFFFF}'%s(%d)': \"%s\" -|",string,PMplayer1,text);
	SendClientMessage(playerid,0x00A765AA,string);

	GetPlayerName(playerid, string, sizeof(string));
	format(string, sizeof(string),"|- {FF0000}PM: {00FF40}Message from: {FFFFFF}%s: \"%s\" -|",string,text);
	SendClientMessage(recieverid,0x00A765AA,string);
	
	#endif
	return 1;
}
//==============================================================================
//-------------------------------------------------
// ERROR Messages
//-------------------------------------------------
//==============================================================================
stock ErrorMessages(playerid, errorID)
{
if(errorID == 1)  return SendClientMessage(playerid,red,"ERROR: You are not a high enough level to use this command");
if(errorID == 2)  return SendClientMessage(playerid,red,"ERROR: Player is not connected");
if(errorID == 3)  return SendClientMessage(playerid,red,"ERROR: Player is not connected or is yourself or is the highest level admin");
if(errorID == 4)  return SendClientMessage(playerid,red,"ERROR: Player is not connected or is yourself");
if(errorID == 5)  return SendClientMessage(playerid,red,"ERROR: You need to be Level 4 to use this Command");
if(errorID == 6)  return SendClientMessage(playerid,red,"ERROR: You need to be Level 3 to use this Command");
if(errorID == 7)  return SendClientMessage(playerid,red,"ERROR: You need to be Level 2 to use this Command");
if(errorID == 8)  return SendClientMessage(playerid,red,"ERROR: You need to be Level 1 to use this Command");
if(errorID == 9)  return SendClientMessage(playerid,red,"ERROR: You need to be Level 5 to use this Command");
if(errorID == 10) return SendClientMessage(playerid,red,"ERROR: You are not in a vehicle");
return 1;
}
//==============================================================================
//-------------------------------------------------
// HighLight
//-------------------------------------------------
//==============================================================================
public HighLight(playerid)
{
	if(!IsPlayerConnected(playerid))
	return 1;

	if(AccInfo[playerid][blipS] == 0)
	{
	SetPlayerColor(playerid, 0xFF0000AA);
	AccInfo[playerid][blipS] = 1;
	}
	else
	{
	SetPlayerColor(playerid, 0xFFFF00AA);
	AccInfo[playerid][blipS] = 0;
	}
	return 0;
}

//==============================================================================
//-------------------------------------------------
// COMMANDS
//-------------------------------------------------
//==============================================================================

#if USE_DIALOGS == true
dcmd_CMD_REGISTER(playerid,params[])
{
    #pragma unused params

	if (AccInfo[playerid][LoggedIn] == 1)
	return SendClientMessage(playerid,red,"ERROR: You are already registered and logged in.");

	if (udb_Exists(PlayerName2(playerid)))
	return SendClientMessage(playerid,red,"ERROR: This account already exists") &&
    SendClientMessage(playerid,orange,"Login to access your account ('/"#LoginCommand"').");

	new rs2tring[256];
	format(rs2tring,256,"Register new Account: '%s'\n\nEnter the password to Register your Account:",pName(playerid));
	ShowPlayerDialog(playerid,DIALOGID+66,DIALOG_STYLE_PASSWORD,"Register Account",rs2tring,"Register","Quit");
	return 1;
}
dcmd_CMD_LOGIN(playerid,params[])
{
    #pragma unused params

   	new file[128];
	format(file,sizeof(file),"/LuxAdmin/Accounts/%s.sav",udb_encode(PlayerName2(playerid)) );

    if (AccInfo[playerid][LoggedIn] == 1)
	return SendClientMessage(playerid,red,"ERROR: You are already logged in!.");

    if (!udb_Exists(PlayerName2(playerid))) return
	SendClientMessage(playerid,red,"ERROR: Account doesn't exist!") &&
    SendClientMessage(playerid,orange,"Register to create your account ('/"#RegisterCommand" [Password]').");

	new lstring[256];
	format(lstring,256,"Access Account: %s\n\nTo access your Account, enter your Password below:",pName(playerid));
	ShowPlayerDialog(playerid,DIALOGID+67,DIALOG_STYLE_PASSWORD,"Login Account",lstring,"Login","Quit");
	return 1;
}
#else
dcmd_CMD_REGISTER(playerid,params[])
{
	if (AccInfo[playerid][LoggedIn] == 1)
	return SendClientMessage(playerid,red,"ERROR: You are already registered and logged in.");

    if (udb_Exists(PlayerName2(playerid)))
	return SendClientMessage(playerid,red,"ERROR: This account already exists") &&
    SendClientMessage(playerid,orange,"Login to access your account ('/"#LoginCommand" [password]').");

    if (strlen(params) == 0)
	return SendClientMessage(playerid,orange,"Usage: '/"#RegisterCommand" [password]'");

    if (strlen(params) < 4 || strlen(params) > 20)
	return SendClientMessage(playerid,red,"ERROR: Your password length must be greater than 3 characters");

    if (udb_Create(PlayerName2(playerid)))
	{
     	new file[256],name[MAX_PLAYER_NAME], buf[145],tmp3[100];
    	new strdate[20], year,month,day;
		getdate(year, month, day);
        WP_Hash(buf, sizeof(buf), params);
		GetPlayerName(playerid,name,sizeof(name));

		format(file,sizeof(file),"/LuxAdmin/Accounts/%s.sav",udb_encode(name));
     	GetPlayerIp(playerid,tmp3,100);
     	dini_Set(file,"Password",buf);
	    dini_Set(file,"Ip",tmp3);
	    dUserSetINT(PlayerName2(playerid)).("Registered",1);
   		format(strdate, sizeof(strdate), "%d/%d/%d",day,month,year);
		dini_Set(file,"RegisteredDate",strdate);
		dUserSetINT(PlayerName2(playerid)).("Loggedin",1);
		dUserSetINT(PlayerName2(playerid)).("Banned",0);
		dUserSetINT(PlayerName2(playerid)).("Level",0);
		dUserSetINT(PlayerName2(playerid)).("AccountType",0);
	    dUserSetINT(PlayerName2(playerid)).("LastOn",0);
    	dUserSetINT(PlayerName2(playerid)).("Money",0);
    	dUserSetINT(PlayerName2(playerid)).("Kills",0);
	   	dUserSetINT(PlayerName2(playerid)).("Deaths",0);
      	dUserSetINT(PlayerName2(playerid)).("WantedLevel",0);
      	#if SaveScore == true
      	dUserSetINT(PlayerName2(playerid)).("Score",0);
      	#endif
	   	dUserSetINT(PlayerName2(playerid)).("Hours",0);
	   	dUserSetINT(PlayerName2(playerid)).("Minutes",0);
	   	dUserSetINT(PlayerName2(playerid)).("Seconds",0);
	    AccInfo[playerid][LoggedIn] = 1;
	    AccInfo[playerid][Registered] = 1;
	    SendClientMessage(playerid, green, "|- You are now Registered, and have been automaticaly Logged in! -|");
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		return 1;
	}
    return 1;
}
dcmd_CMD_LOGIN(playerid,params[])
{
	new file[128], Pass[256];
	format(file,sizeof(file),"/LuxAdmin/Accounts/%s.sav",udb_encode(PlayerName2(playerid)) );

    if (AccInfo[playerid][LoggedIn] == 1)
	return SendClientMessage(playerid,red,"ERROR: You are already logged in!.");

    if (!udb_Exists(PlayerName2(playerid))) return
	SendClientMessage(playerid,red,"ERROR: Account doesn't exist!") &&
    SendClientMessage(playerid,orange,"Register to create your account ('/"#RegisterCommand" [Password]').");

    if (strlen(params)==0) return
	SendClientMessage(playerid,orange,"Usage: '/"#LoginCommand" [Password]'");

	Pass = dini_Get(file, "Password");
 	new buf[145];
 	WP_Hash(buf, sizeof(buf), params);

    if(strcmp(Pass, buf, false) == 0)
	{
    new tmp3[100], string[128];
   	format(file,sizeof(file),"/LuxAdmin/Accounts/%s.sav",udb_encode(PlayerName2(playerid)) );
	GetPlayerIp(playerid,tmp3,100);
	dini_Set(file,"Ip",tmp3);
	LoginPlayer(playerid);
	PlayerPlaySound(playerid,1057,0.0,0.0,0.0);

	if(AccInfo[playerid][Level] > 0)
	{
		switch(AccInfo[playerid][Level])
		{
		case 1: AdmRank = "Basic Moderator";
		case 2: AdmRank = "Moderator";
		case 3: AdmRank = "Master Moderator";
		case 4: AdmRank = "Administrator";
		case 5: AdmRank = "Master Administrator";
		}
		if(AccInfo[playerid][Level] > 5)
		{
			AdmRank = "Professional Admin";
		}
		if(AccInfo[playerid][pVip] > 0)
		{
			switch(AccInfo[playerid][pVip])
			{
			case 1: AccType = "Silver";
			case 2: AccType = "Gold";
			case 3: AccType = "Platinum";
			}
			format(string,sizeof(string),"|- You have Successfully Logged! | Account: %s | Level %d - %s -|", AccType, AccInfo[playerid][Level], AdmRank);
			return SendClientMessage(playerid,0x00C378AA,string);
		}
		else
		{
			format(string,sizeof(string),"|- You have Successfully Logged! | Level %d - %s -|", AccInfo[playerid][Level], AdmRank);
			return SendClientMessage(playerid,green,string);
		}
	}
	else
	{
		if(AccInfo[playerid][pVip] > 0)
		{
			switch(AccInfo[playerid][pVip])
			{
			case 1: AccType = "Silver";
			case 2: AccType = "Gold";
			case 3: AccType = "Platinum";
			}
			format(string,sizeof(string),"|- You have Successfully logged! | Account: %s -|", AccType);
			return SendClientMessage(playerid,0x00C896AA,string);
		}
		else return SendClientMessage(playerid,green,"|- You have Successfully logged! -|");
		}
	}
	else
	{
		AccInfo[playerid][FailLogin]++;
		printf("LOGIN: Failed Login: %s. Wrong password (%s) (%d)", PlayerName2(playerid), params, AccInfo[playerid][FailLogin] );
		if(AccInfo[playerid][FailLogin] == MAX_FAIL_LOGINS)
		{
		new string[128]; format(string, sizeof(string), "|- Player %s has been automatically kicked (Reason: Many attempts Incorrect Passwords) -|", PlayerName2(playerid) );
		SendClientMessageToAll(red, string);
		print(string);
		Kick(playerid);
		}
		return SendClientMessage(playerid,red,"ERROR: Login failed! Incorrect Password.");
	}
}
#endif
//==============================================================================
// Stats
//==============================================================================
#if USE_STATS == true
dcmd_resetstats(playerid,params[])
{
    #pragma unused params
	if(AccInfo[playerid][LoggedIn] == 1)
	{
	   	dUserSetINT(PlayerName2(playerid)).("oldkills",AccInfo[playerid][Kills]);
	   	dUserSetINT(PlayerName2(playerid)).("olddeaths",AccInfo[playerid][Deaths]);
		AccInfo[playerid][Kills] = 0;
		AccInfo[playerid][Deaths] = 0;
		dUserSetINT(PlayerName2(playerid)).("Kills",AccInfo[playerid][Kills]);
	   	dUserSetINT(PlayerName2(playerid)).("Deaths",AccInfo[playerid][Deaths]);
        PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		return SendClientMessage(playerid,yellow,"|- You have Successfully reset your Stats! -|");
	}
	else return SendClientMessage(playerid,red, "ERROR: You must have an account to use this command");
}
#endif
#if USE_STATS == true
dcmd_stats(playerid,params[])
{
	new string[128];
	new pDeaths;
	new player1, h, m, s;

	if(!strlen(params)) player1 = playerid;
	else player1 = strval(params);

	if(IsPlayerConnected(player1))
	{
    TotalGameTime(player1, h, m, s);
	if(AccInfo[player1][Deaths] == 0) pDeaths = 1;
	else pDeaths = AccInfo[player1][Deaths];
	format(string, sizeof(string), "|- %s's Statistics -|",PlayerName2(player1));
	SendClientMessage(playerid, green, string);
	format(string, sizeof(string), "Kills: [%d] | Deaths: [%d] | Ratio: [%0.2f] | Money: [$%d] | Time: [%d] hrs [%d] mins [%d] secs |", AccInfo[player1][Kills], AccInfo[player1][Deaths], Float:AccInfo[player1][Kills]/Float:pDeaths,GetPlayerMoney(player1), h, m, s);
	return SendClientMessage(playerid, green, string);
	} else
	return SendClientMessage(playerid, red, "ERROR: Player Not Connected!");
}
#endif

//==============================================================================
// Password Cmds
//==============================================================================
dcmd_CMD_CHANGEPASS(playerid,params[])
{
	if(AccInfo[playerid][LoggedIn] == 1)
	{
		if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /"#ChangePassCommand" [NewPassword]")
		&& SendClientMessage(playerid, orange, "Function: Will modify your account password");
		if(strlen(params) < 4) return SendClientMessage(playerid,red,"ERROR: Incorrect password length!");
		new string[128];
		new file[128], Pass[256];
    	format(file,sizeof(file),"/LuxAdmin/Accounts/%s.sav",udb_encode(PlayerName2(playerid)) );
  		new buf[145];
        WP_Hash(buf, sizeof(buf), params);
		Pass = dini_Get(file, "Password");
		dini_Set(file, "Password", buf);
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
        format(string, sizeof(string),"|- You have successfully changed your account Password to \"%s\" -|",params);
		return SendClientMessage(playerid,yellow,string);
	} else return SendClientMessage(playerid,red, "ERROR: You must have an account to use this command");
}

dcmd_setpass(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 3)
	{
	    new string[128], tmp[256], tmp2[256], Index;

		tmp = strtok(params,Index);
		tmp2 = strtok(params,Index);

	    if(!strlen(tmp) || !strlen(tmp2)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /setpass [playername] [new password]") &&
		SendClientMessage(playerid, orange, "Function: Will modify account password of specified player");

		if(strlen(tmp2) < 4 || strlen(tmp2) > MAX_PLAYER_NAME)
		return SendClientMessage(playerid,red,"ERROR: Incorrect password length");
		if(udb_Exists(tmp))
		{
			new file[128], Pass[256];
    	    format(file,sizeof(file),"/LuxAdmin/Accounts/%s.sav",udb_encode(PlayerName2(playerid)));
  		    new buf[145];
            WP_Hash(buf, sizeof(buf), tmp2);
	    	Pass = dini_Get(file, "Password");
		    dini_Set(file, "Password", buf);
			PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
    	    format(string, sizeof(string),"|- You have successfully set \"%s's\" account password to \"%s\" -|", tmp, tmp2);
			return SendClientMessage(playerid,yellow,string);
		} else return SendClientMessage(playerid,red, "ERROR: This player doesnt have an account");
	}
	else return ErrorMessages(playerid, 1);
}


//==============================================================================
// Flying Cam System (Original by Sandra - Modified By Me)
//==============================================================================

//==========================
// ENABLE/DISABLE CAM
//==========================
#if EnableCamHack == true
dcmd_lcam(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][Level] >= 3)
	{
		if(AccInfo[playerid][Spawned] == 1)
	 	{
			if(AccInfo[playerid][InCamMod] == 0)
			{
	  			if(AccInfo[playerid][pGps] != -1)
				return SendClientMessage(playerid, red, "ERROR: First Disable the Gps System! (/gps off)");

				if(AccInfo[playerid][SpecType] != ADMIN_SPEC_TYPE_NONE)
				return SendClientMessage(playerid, red, "ERROR: First Disable the Spectating System! (/lspecoff)");

				SendClientMessage(playerid, 0x199B00AA, " ");
				SendClientMessage(playerid, 0x199B00AA, "|- LuX CamSystem - Commands & Controlls -| ");
				SendClientMessage(playerid, 0x47CCB7AA, "*/lcam: Start/Stop Flying Camera Mode");
				SendClientMessage(playerid, 0x47CCB7AA, "*/lockcam: Locks/Unlock the camera and player is free to move.");
				SendClientMessage(playerid, 0x47CCB7AA, "*/follow: Locks the camera and keeps looking at player.");
    			SendClientMessage(playerid, 0xFA8072AA, "*Arrow-keys*: Move camera forward/backward/left/right");
            	SendClientMessage(playerid, 0xFA8072AA, "*Walk-key + Arrow-keys*: *Move camera up/down");
            	SendClientMessage(playerid, 0xFA8072AA, "*Crouch-key + Arrow-keys*: *Rotate camera up/down/left/right");
            	SendClientMessage(playerid, 0xFA8072AA, "*Sprint-key*: Speeds up every movement");

				TogglePlayerControllable(playerid, 0);
				AccInfo[playerid][LockedCam] = 0;
				AccInfo[playerid][InCamMod] = 1;
				FollowOn[playerid] = 0;
				GetPlayerPos(playerid, PCP[playerid][0], PCP[playerid][1], PCP[playerid][2]);
				GetPlayerFacingAngle(playerid, PCA[playerid]);

				GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~w~~g~Cam System ~y~Enabled!",1000,3);

				if(IsPlayerInAnyVehicle(playerid))
				{
					GetVehicleZAngle(GetPlayerVehicleID(playerid), PCA[playerid]);
				}
				PCL[playerid][0] = PCP[playerid][0];
				PCL[playerid][1] = PCP[playerid][1];
				PCL[playerid][2] = PCP[playerid][2];
				PCP[playerid][0] = PCP[playerid][0] - (5.0 * floatsin(-PCA[playerid], degrees));
				PCP[playerid][1] = PCP[playerid][1] - (5.0 * floatcos(-PCA[playerid], degrees));
				PCP[playerid][2] = PCP[playerid][2]+2.0;
				SetPlayerCameraPos(playerid, PCP[playerid][0], PCP[playerid][1], PCP[playerid][2]);
				SetPlayerCameraLookAt(playerid, PCL[playerid][0], PCL[playerid][1], PCL[playerid][2]);
			 	KeyTimer[playerid] = SetTimerEx("CheckKeyPress", 50, 1, "i", playerid);
			}
			else
			{
				TogglePlayerControllable(playerid, 1);
				KillTimer(KeyTimer[playerid]);
				AccInfo[playerid][InCamMod] = 0;
				SetCameraBehindPlayer(playerid);
				GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~w~~g~Cam System ~r~Disabled!",1000,3);
			}
			return 1;
		}
		else return SendClientMessage(playerid, 0xFF0000AA, "ERROR: Please Spawn First!");
	}
	else return ErrorMessages(playerid, 1);
}
//==================================
// LOCK/UNLOCK CAM/PLAYER POSITION
//==================================
dcmd_lockcam(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][Level] >= 3)
	{
		if(AccInfo[playerid][Spawned] == 1)
	    {
			if(AccInfo[playerid][InCamMod] == 1)
			{
			    if(FollowOn[playerid] == 0)
			    {
				    if(AccInfo[playerid][LockedCam] == 0)
				    {
					    AccInfo[playerid][LockedCam] = 1;
					    KillTimer(KeyTimer[playerid]);
					    TogglePlayerControllable(playerid, 1);
					    SendClientMessage(playerid, 0x00FF00AA, "|- Camera Locked | Player Unlocked! -| ");
					}
					else
					{
					    AccInfo[playerid][LockedCam] = 0;
					    KeyTimer[playerid] = SetTimerEx("CheckKeyPress", 50, 1, "i", playerid);
					    TogglePlayerControllable(playerid, 0);
					    SendClientMessage(playerid, 0x00FF00AA, "|- Camera Unlocked | Player Locked! -| ");
					}
					return 1;
				}
				else return SendClientMessage(playerid, 0xFF0000AA, "ERROR: Please turn the Follow-Mode off First! (/follow)");
			}
			else return SendClientMessage(playerid, 0xFF0000AA, "ERROR: You're not in the Flying Camera Mode!");
		}
		else return SendClientMessage(playerid, 0xFF0000AA, "ERROR: Please Spawn First!");
	}
	else return ErrorMessages(playerid, 1);
}
//==========================
// FOLLOW THE PLAYER
//==========================
dcmd_follow(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][Level] >= 3)
	{
	    if(AccInfo[playerid][Spawned] == 1)
	    {
			if(AccInfo[playerid][InCamMod] == 1)
			{
			    if(AccInfo[playerid][LockedCam] == 0)
				{
				    if(FollowOn[playerid] == 0)
				    {
				        FollowOn[playerid] = 1;
					    TogglePlayerControllable(playerid, 1);
				        KillTimer(KeyTimer[playerid]);
					    KeyTimer[playerid] = SetTimerEx("FollowPlayer", 70, 1, "i", playerid);
					    SendClientMessage(playerid, 0x00FF00AA, "Following player toggled on!");
					}
					else
					{
				        FollowOn[playerid] = 0;
					    TogglePlayerControllable(playerid, 0);
					    KillTimer(KeyTimer[playerid]);
					    KeyTimer[playerid] = SetTimerEx("CheckKeyPress", 50, 1, "i", playerid);
					    SendClientMessage(playerid, 0x00FF00AA, "Following player toggled off!");
					}
					return 1;
				}
				else return SendClientMessage(playerid, 0xFF0000AA, "ERROR: Please unlock the camera first! (/lockCam)");
			}
			else return SendClientMessage(playerid, 0xFF0000AA, "ERROR: You're not in the Flying Camera Mode!");
		}
		else return SendClientMessage(playerid, 0xFF0000AA, "ERROR: Please Spawn First!");
	}
	else return ErrorMessages(playerid, 1);
}
#endif
//==============================================================================
// GPS
//==============================================================================

dcmd_gps(playerid,params[])
{
	if(AccInfo[playerid][pVip] < 1)
	return ErrorMessages(playerid, 6);

	if(AccInfo[playerid][SpecType] != ADMIN_SPEC_TYPE_NONE)
	return SendClientMessage(playerid, red, "ERROR: First Disable the Spectating System! (/lspecoff)");

	if(!strlen(params))
	return SendClientMessage(playerid, LIGHTBLUE2, "Usage: /gps [PlayerID/Off]") &&
	SendClientMessage(playerid, orange, "Function: Will enable GPS do find a specified Player (If you is in a Race, not use)");

	if(strcmp(params,"off",true) == 0)
	{
		GameTextForPlayer(playerid,"~w~Gps ~r~Off!",3000,3);
		IsDisable[playerid] = 0;
		AccInfo[playerid][pGps] = -1;
		return 1;
	}
	new player1;
	new string2[128];
 	player1 = strval(params);
	if(player1 == playerid)
	return SendClientMessage(playerid,red,"ERROR: You can not Find yourself!");

 	if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
	return SendClientMessage(playerid,red,"ERROR: You can not localize an Administrator!");

	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
	{
		new playername[MAX_PLAYER_NAME];
		GetPlayerName(player1, playername, sizeof(playername));
		format(string2, sizeof(string2),"<LuxGps> System Enabled in the Player - '%s'", playername);
		SendClientMessage(playerid, 0xDC686BAA, string2);
		GameTextForPlayer(playerid,"~w~Gps ~g~On!",3000,3);
		AccInfo[playerid][pGps] = player1;
		}
	else return ErrorMessages(playerid, 2);
	return 1;
	}


//==============================================================================
// Visible/Invisible
//==============================================================================
dcmd_invisible(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][Level] >= 3)
	{
		if(AccInfo[playerid][Hide] == 0)
		{
		    pColor = GetPlayerColor(playerid);
			SetPlayerColor(playerid, 0xFFFFFF00);
   			GameTextForPlayer(playerid, "~n~~n~~n~~n~~g~Invisible!",2500,3);
   			AccInfo[playerid][Hide] = 1;
   			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
   			{
   	    		new int1 = GetPlayerInterior(playerid);
   	    		LinkVehicleToInterior(GetPlayerVehicleID(playerid),int1+1);
    		}
    		return 1;
		}
		else return SendClientMessage(playerid, lightred,"ERROR: You is already Invisible!");
	}
	else return  ErrorMessages(playerid, 1);
}


dcmd_visible(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][Level] >= 3)
	{
		if(AccInfo[playerid][Hide] == 1)
		{
			SetPlayerColor(playerid, pColor);
   			GameTextForPlayer(playerid, "~n~~n~~n~~n~~b~Visible!",2500,3);
   			AccInfo[playerid][Hide] = 0;
   			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
   			{
   	    		new int1 = GetPlayerInterior(playerid);
   	    		LinkVehicleToInterior(GetPlayerVehicleID(playerid),int1);
   			}
   			return 1;
		}
		else return SendClientMessage(playerid, lightred,"ERROR: You is already Visible!");
	}
	else return  ErrorMessages(playerid, 1);
}
//==============================================================================
// Cage
//==============================================================================

dcmd_cage(playerid,params[])
{
	if(AccInfo[playerid][Level] < 4)
	return ErrorMessages(playerid, 5);

	new Index;
	new tmp[256];  tmp  = strtok(params, Index);
  	new tmp2[256]; tmp2 = strtok(params, Index);
	new player1 = ReturnUser(tmp);
	new time = strval(tmp2);

 	if(!strlen(tmp)) return
 	SendClientMessage(playerid, LIGHTBLUE2, "Usage: /cage [PlayerID] [Time]") &&
	SendClientMessage(playerid, orange, "Function: Will hold player in a Cage by specified Time");

	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid && (AccInfo[player1][Level]))
	{

	if(!strlen(tmp2))
	return SendClientMessage(playerid, red, "ERROR: Not specified Time!");

	if(time < 10)
	return SendClientMessage(playerid, red, "ERROR: Time must be greater than 10 Seconds!");

    if(AccInfo[player1][pCaged] == 1)
	return SendClientMessage(playerid, red, "ERROR: Player is already in Cage!");

	new string[128];
	new playername[MAX_PLAYER_NAME];
	new adminname [MAX_PLAYER_NAME];
	SendCommandToAdmins(playerid,"Cage");
 	GetPlayerName(player1, playername, sizeof(playername));
	GetPlayerName(playerid, adminname, sizeof(adminname));
	format(string, sizeof(string), "|- Administrator %s has been Caged \"%s\" for \"%d\" Seconds! -|",adminname, playername, time);
	SendClientMessageToAll(blue, string);
    TogglePlayerControllable(player1, 0);
    AccInfo[player1][pCageTime] = time;
    AccInfo[player1][pCaged] = 1;
    GetPlayerPos(playerid, LPosX[player1], LPosY[player1], LPosZ[player1]);
    SetTimerEx("CagePlayer", 1000, 0, "i", player1);
    SetTimerEx("UnCagePlayer", AccInfo[player1][pCageTime]*1000, 0, "i", player1);
	}
	else return ErrorMessages(playerid, 3);
	return 1;
	}

//==============================================================================
// Help
//==============================================================================
dcmd_ahelp(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][LoggedIn] && AccInfo[playerid][Level] >= 1)
	{
		SendClientMessage(playerid, white, "___________ |- DS Admin System - Help -| ___________");
		SendClientMessage(playerid,Green1, ". Admin: /level [1/2/3/4/5] - See Admin Commands of Level");
		SendClientMessage(playerid,Green2, ". Credits: /lcredits");
		SendClientMessage(playerid,Green1, ". Account: /"#RegisterCommand", /"#LoginCommand", /"#ChangePassCommand"");
		SendClientMessage(playerid,Green2, ". Stats: /stats, /resetstats");
		SendClientMessage(playerid,Green1, ". Players: /"#RegisterCommand", /"#LoginCommand", /report, /stats, /time, /"#ChangePassCommand", /resetstats, /getid");
		SendClientMessage(playerid,Green2, ". IMPORTANT: /observations");
		}
		else if(AccInfo[playerid][LoggedIn] && AccInfo[playerid][Level] < 1)
		{
		SendClientMessage(playerid, white, "___________ |- DS Admin System - Help -| ___________");
	 	SendClientMessage(playerid,Green1, "Player Commands:");
		SendClientMessage(playerid,Green2, "/"#RegisterCommand", /"#LoginCommand", /report, /stats, /time, /"#ChangePassCommand", /resetstats, /getid");
		}
		else if(AccInfo[playerid][LoggedIn] == 0)
	{
	SendClientMessage(playerid, white, "___________ |- DS Admin System - Help -| ___________");
	SendClientMessage(playerid,lightred, "ERROR:");
	SendClientMessage(playerid,lightred, "You are not logged in! Log in for see help");
	}
	return 1;
}
//==============================================================================
// Observations
//==============================================================================
dcmd_observations(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][Level] > 0)
	{
		SendClientMessage(playerid, white, "___________ |- DS Admin System - Observations -| ___________");
		SendClientMessage(playerid,0x7DACACFF,". If you change your GameMode in the game, reload the AdminScript");
		SendClientMessage(playerid,0x7DACACFF,". Administrators Level 5 are totally immune to any command");
		SendClientMessage(playerid,0x7DACACFF,". Bans/Kicks/Reports/..., Is saved in file with Date and Time.");
	}
	return 1;
}
dcmd_level(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 1)
	{
	    if(!strlen(params))
		{
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /level [1/2/3/4/5]");
		return SendClientMessage(playerid, orange, "Function: Will see commands of specified level");
		}
 		//======================================================================
  		// Level 1
		//======================================================================
		if(strcmp(params,"1",true) == 0)
		{
		if(AccInfo[playerid][Level] >= 1)
		{
		SendClientMessage(playerid, white, "___________ |- DS Admin - Basic Moderator (Level 1) -| ___________");
		SendClientMessage(playerid,0x53D212FF,"Player: getinfo, weaps, ping, ip, ");
		SendClientMessage(playerid,0x33F666FF,"Vehicle: fix, repair, addnos, tcar");
		SendClientMessage(playerid,0x53D212FF,"Tele: saveplacae, gotoplace");
		SendClientMessage(playerid,0x33F666FF,"Adm: onduty, saveskin, useskin, dontuseskin, setmytime, adminarea");
		SendClientMessage(playerid,0x53D212FF,"Other: lconfig, viplist, morning, reports, richlist, miniguns");
		}
			else return ErrorMessages(playerid, 8);
		}
 		//======================================================================
  		// Level 2
		//======================================================================
		else if(strcmp(params,"2",true) == 0)
		{
		if(AccInfo[playerid][Level] >= 2)
		{
		SendClientMessage(playerid, white, "___________ |- DS Admin System - Moderator (Level 2) -| ___________");
		SendClientMessage(playerid, orange, "+ Level 1 commands.");
		SendClientMessage(playerid,0x53D212FF,"Player: giveweapon, setcolour, burn, spawn, disarm, highlight, jetpack, flip, fu");
		SendClientMessage(playerid,0x33F666FF,"Player: warn, slap, (un)mute, laston, lspec, lspecoff");
		SendClientMessage(playerid,0x53D212FF,"Vehicle: acar, abike, aheli, aboat, aplane, lspecvehicle");
		SendClientMessage(playerid,0x33F666FF,"Tele: goto, vgoto, lgoto");
		SendClientMessage(playerid,0x53D212FF,"Adm: lmenu, clearchat, write, announce, announce2, screen, (un)lockcar");
		SendClientMessage(playerid,0x33F666FF,"Other: wanted, jailed, frozen, muted, fstyles");
		}
			else return ErrorMessages(playerid, 7);
		}
 		//======================================================================
  		// Level 3
		//======================================================================
		else if(strcmp(params,"3",true) == 0)
		{
		if(AccInfo[playerid][Level] >= 3)
		{
		SendClientMessage(playerid, white, "___________ |- LuxAdmin - Master Moderator (Level 3) -| ___________");
		SendClientMessage(playerid, orange, "+ Level 1 and 2 commands.");
		SendClientMessage(playerid,0x53D212FF,"Set: set(health/armour/cash/score/skin/wanted/name/weather/time/world/interior/ping/gravity)");
		SendClientMessage(playerid,0x33F666FF,"All: setallskin, armourall, setallskin, setallwanted, setallweather, setalltime, setallworld");
		SendClientMessage(playerid,0x53D212FF,"All: setallscore, setallcash, giveallcash, giveallweapon, clearallchat, healall, disablechat");
		SendClientMessage(playerid,0x33F666FF,"Player: ubound, duel, akill, aka, caps,(un)freeze, kick, explode,(un)jail, force, eject, (s)removecash");
		SendClientMessage(playerid,0x53D212FF,"Vehicle: car, carhealth, carcolour, destroycar, vget, givecar");
		SendClientMessage(playerid,0x33F666FF,"Tele: teleplayer, gethere, get, move, moveplayer");
		SendClientMessage(playerid,0x53D212FF,"Other: gps, lcam, setpass, lammo, countdown, aweaps, invisible, visible");
		}
			else return ErrorMessages(playerid, 6);
		}
 		//======================================================================
  		// Level 4
		//======================================================================
		else if(strcmp(params,"4",true) == 0)
 		{
		if(AccInfo[playerid][Level] >= 4)
		{
        SendClientMessage(playerid, white, "___________ |- LuxAdmin - Administrator (Level 4) -| ___________");
        SendClientMessage(playerid, orange, "+ Level 1,2 and 3 commands.");
		SendClientMessage(playerid,0x53D212FF,"All: spawnall, muteall, unmuteall, getall, killall, freezeall, unfreezeall");
		SendClientMessage(playerid,0x33F666FF,"All: kickall, slapalll, explodeall, disarmall, ejectall");
		SendClientMessage(playerid,0x53D212FF,"Player: cage, ban, rban, tempban, settemplevel, crash");
		SendClientMessage(playerid,0x33F666FF,"Adm: ctele, lockserver, enable, disable, spam, god, godcar, botcheck, forbidname, forbidword, fakedeath");
		SendClientMessage(playerid,0x53D212FF,"Other: uconfig, die, hide, unhide");
		}
			else return ErrorMessages(playerid, 5);
		}
 		//======================================================================
  		// Level 5
		//======================================================================
		else if(strcmp(params,"5",true) == 0)
		{
		if(AccInfo[playerid][Level] >= 5)
		{
		SendClientMessage(playerid, white, "___________ |- LuxAdmin - Master Administrator (Level 5) -| ___________");
		SendClientMessage(playerid, orange, "+ Level 1,2,3 and 4 commands.");
		SendClientMessage(playerid, orange, "+ Level 5 is Immune for all commands");
		SendClientMessage(playerid,0x53D212FF,"Player: setlevel, fakechat, fakedeath, fakecmd");
		SendClientMessage(playerid,0x33F666FF,"Adm: god, sgod, console");
 		SendClientMessage(playerid,0x53D212FF,"Other: pickup, object, respawncars");
 		SendClientMessage(playerid,0x53D212FF,"Rcon: lrcon (Only Rcon Admins) (Use: /rcon lrcon)");
		}
			else return ErrorMessages(playerid, 9);
		}
 		//======================================================================
		else
		{
  		SendClientMessage(playerid, red, "ERROR: Invalid Level! (1-5)");
		}
		return 1;
 	}
	else return ErrorMessages(playerid, 1);
}

dcmd_setarmour(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
	    new Index;
	    new tmp[256];  tmp  = strtok(params,Index);
	    new tmp2[256]; tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /setarmour [PlayerID] [Value]") &&
		SendClientMessage(playerid, orange, "Function: Will set Armour of specified player!");

		if(strval(tmp2) < 0 || strval(tmp2) > 100 && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid, red, "ERROR: Invaild Armour Amount!");
		new player1 = strval(tmp);
		new armour = strval(tmp2);
		new string[128];
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
			SendCommandToAdmins(playerid,"SetArmour");
			format(string, sizeof(string), "|- You have set \"%s's\" Armour to '%d' -|", pName(player1), armour);
			SendClientMessage(playerid,BlueMsg,string);
			if(player1 != playerid)
			{
			format(string,sizeof(string),"|- Administrator \"%s\" has set your Armour to '%d' -|", pName(playerid), armour);
			SendClientMessage(player1,blue,string);
			}
   			return SetPlayerArmour(player1, armour);
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_sethealth(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
	    new Index;
	    new tmp[256];  tmp  = strtok(params,Index);
	    new tmp2[256]; tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /sethealth [PlayerID] [Value]") &&
		SendClientMessage(playerid, orange, "Function: Will set Armour of specified player!");

		if(strval(tmp2) < 0 || strval(tmp2) > 100 && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return
		SendClientMessage(playerid, red, "ERROR: Invaild Health amount!");
		new player1 = strval(tmp);
		new health = strval(tmp2);
		new string[128];
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return
		SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			SendCommandToAdmins(playerid,"SetHealth");
			format(string, sizeof(string), "|- You have set \"%s's\" Health to '%d' -|", pName(player1), health);
			SendClientMessage(playerid,BlueMsg,string);
			if(player1 != playerid)
			{
			format(string,sizeof(string),"|- Administrator \"%s\" has set your Health to '%d' -|", pName(playerid), health);
			SendClientMessage(player1,blue,string);
			}
   			return SetPlayerHealth(player1, health);
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_setscore(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
	    new Index;
	    new tmp[256];  tmp  = strtok(params,Index);
	    new tmp2[256]; tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /setscore [PlayerID] [Score]") &&
		SendClientMessage(playerid, orange, "Function: Will set Score of specified player!");
		new player1 = strval(tmp);
		new score = strval(tmp2);
		new string[128];
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
			SendCommandToAdmins(playerid,"SetScore");
			format(string, sizeof(string), "|- You have set \"%s's\" Score to '%d' -|",pName(player1),score);
			SendClientMessage(playerid,BlueMsg,string);
			if(player1 != playerid)
			{
			format(string,sizeof(string),"|- Administrator \"%s\" has set your Score to '%d' -|", pName(playerid), score);
			SendClientMessage(player1,blue,string);
			}
   			return SetPlayerScore(player1, score);
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_setskin(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
	    new Index;
	    new tmp[256];  tmp  = strtok(params,Index);
	    new tmp2[256]; tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /setskin [PlayerID] [SkinID]") &&
		SendClientMessage(playerid, orange, "Function: Will set Skin of specified player!");
		new player1 = strval(tmp);
		new skin = strval(tmp2);
		new string[128];
		if(!IsValidSkin(skin))
		return SendClientMessage(playerid, red, "ERROR: Invaild Skin ID!");
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
			SendCommandToAdmins(playerid,"SetSkin");
			format(string, sizeof(string), "|- You have set \"%s's\" Skin to '%d -|", pName(player1), skin);
			SendClientMessage(playerid,BlueMsg,string);
			if(player1 != playerid)
			{
			format(string,sizeof(string),"|- Administrator \"%s\" has set your Skin to '%d' -|", pName(playerid), skin);
			SendClientMessage(player1,blue,string);
			}
   			return SetPlayerSkin(player1, skin);
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_setwanted(playerid,params[])
{
	if(AccInfo[playerid][pVip] >= 1)
	{
	    new Index;
	    new tmp[256];  tmp  = strtok(params,Index);
	    new tmp2[256]; tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /setwanted [PlayerID] [WantedLevel(0-6)]") &&
		SendClientMessage(playerid, orange, "Function: Will set Wanted Level of specified player!");
		new player1 = strval(tmp);
		new wanted = strval(tmp2);
		new string[128];
		if(wanted > 6)
		return SendClientMessage(playerid, red, "ERROR: Invalid Wanted Level! (0-6)");
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
			SendCommandToAdmins(playerid,"SetWanted");
			format(string, sizeof(string), "|- You have set \"%s's\" Wanted Level to '%d -|", pName(player1), wanted);
			SendClientMessage(playerid,BlueMsg,string);
			if(player1 != playerid)
			{
			format(string,sizeof(string),"|- Administrator \"%s\" has set your Wanted Level to '%d' -|", pName(playerid), wanted);
			SendClientMessage(player1,blue,string);
			}
   			return SetPlayerWantedLevel(player1, wanted);
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_setinterior(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
	    new Index;
	    new tmp[256];  tmp  = strtok(params,Index);
	    new tmp2[256]; tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return
  		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /setinterior [PlayerID] [InteriorID]") &&
		SendClientMessage(playerid, orange, "Function: Will set the Interior of specified player!");
		new player1 = strval(tmp);
		new time = strval(tmp2);
		new string[128];
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
			SendCommandToAdmins(playerid,"SetInterior");
			format(string, sizeof(string), "|- You have set \"%s's\" Interior to '%d' -|",pName(player1),time);
			SendClientMessage(playerid,BlueMsg,string);
			if(player1 != playerid)
			{
			format(string,sizeof(string),"|- Administrator \"%s\" has set your Interior to '%d' -|",pName(playerid),time);
			SendClientMessage(player1,blue,string);
			}
			PlayerPlaySound(player1,1057,0.0,0.0,0.0);
   			return SetPlayerInterior(player1, time);
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_setcash(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
	    new Index;
	    new tmp[256];  tmp  = strtok(params,Index);
	    new tmp2[256]; tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /setcash [PlayerID] [Value]") &&
		SendClientMessage(playerid, orange, "Function: Will set Cash of specified player!");
		new player1 = strval(tmp);
		new cash = strval(tmp2);
		new string[128];
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
			SendCommandToAdmins(playerid,"SetCash");
			format(string, sizeof(string), "|- You have set \"%s's\" cash to '$%d' -|", pName(player1), cash);
			SendClientMessage(playerid,BlueMsg,string);
			if(player1 != playerid)
			{
			format(string,sizeof(string),"|- Administrator \"%s\" has set your cash to '$%d' -|", pName(playerid), cash);
			SendClientMessage(player1,blue,string);
			}
			ResetPlayerMoney(player1);
   			return GivePlayerMoney(player1, cash);
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_setcolour(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 2)
	{
	    new Index;
	    new tmp[256];  tmp  = strtok(params,Index);
	    new tmp2[256]; tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2))
		{

		SendClientMessage(playerid, orange, "Usage: /setcolour [PlayerID] [Colour]");
		SendClientMessage(playerid, orange, "Colours: [0]Black, [1]White, [2]Red, [3]Orange, [4]Yellow, [5]Green, [6]Blue, [7]Purple, [8]Brown, [9]Pink");
  		return SendClientMessage(playerid, orange, "Function: Send message in a specified colour");
		}
		new player1 = strval(tmp), Colour = strval(tmp2), string[128], colour[24];
		if(Colour > 9)
		return SendClientMessage(playerid, red, "ERROR: Inavlid Colour! (/setcolour)");
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
	        SendCommandToAdmins(playerid,"SetColour");
			switch (Colour)
			{
			    case 0: { SetPlayerColor(player1,black); 			colour = "Black";
				}
			    case 1: { SetPlayerColor(player1,COLOR_WHITE);  	colour = "White";
				}
			    case 2: { SetPlayerColor(player1,red); 				colour = "Red";
				}
			    case 3: { SetPlayerColor(player1,orange); 			colour = "Orange";
				}
				case 4: { SetPlayerColor(player1,orange);		 	colour = "Yellow";
				}
				case 5: { SetPlayerColor(player1,COLOR_GREEN1);  	colour = "Green";
				}
				case 6: { SetPlayerColor(player1,COLOR_BLUE); 	 	colour = "Blue";
				}
				case 7: { SetPlayerColor(player1,COLOR_PURPLE); 	colour = "Purple";
			 	}
				case 8: { SetPlayerColor(player1,COLOR_BROWN); 		colour = "Brown";
				}
				case 9: { SetPlayerColor(player1,COLOR_PINK); 		colour = "Pink";
				}
			}
			if(player1 != playerid)
			{
			format(string,sizeof(string),"|- Administrator \"%s\" has set your Colour to '%s' -|", pName(playerid), colour);
			SendClientMessage(player1,blue,string); }
			format(string, sizeof(string), "|- You have set \"%s's\" Colour to '%s' -|", pName(player1), colour);
   			return SendClientMessage(playerid,BlueMsg,string);
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_settime(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
		new Index;
	    new tmp[256];  tmp  = strtok(params,Index);
	    new tmp2[256]; tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /settime [PlayerID] [Time(Hour)]") &&
		SendClientMessage(playerid, orange, "Function: Will set the Time of specified player!");
		new player1 = strval(tmp);
		new time = strval(tmp2);
		new string[128];
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
			SendCommandToAdmins(playerid,"SetTime");
			format(string, sizeof(string), "|- You have set \"%s's\" Time to %d:00 -|", pName(player1), time);
			SendClientMessage(playerid,BlueMsg,string);
			if(player1 != playerid)
			{
			format(string,sizeof(string),"|- Administrator \"%s\" has set your Time to %d:00 -|", pName(playerid), time);
			SendClientMessage(player1,blue,string);
			}
			PlayerPlaySound(player1,1057,0.0,0.0,0.0);
   			return SetPlayerTime(player1, time, 0);
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_setmytime(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 1)
	{
	    if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /setmytime [Time(Hour)]") &&
		SendClientMessage(playerid, orange, "Function: Will set your Time");
		new time = strval(params);
		new string[128];
		SendCommandToAdmins(playerid,"SetMyTime");
		format(string,sizeof(string),"|- His time has set to: %d:00 -|", time);
		SendClientMessage(playerid,yellow,string);
		return SetPlayerTime(playerid, time, 0);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_setweather(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
	    new Index;
	    new tmp[256];  tmp  = strtok(params,Index);
	    new tmp2[256]; tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /setweather [PlayerID] [WeatherID]") &&
		SendClientMessage(playerid, orange, "Function: Will set the Weather of specified player!");
		new player1 = strval(tmp), weather = strval(tmp2), string[128];
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
			SendCommandToAdmins(playerid,"SetWeather");
			format(string, sizeof(string), "|- You have set \"%s's\" weather to '%d -|", pName(player1), weather);
			SendClientMessage(playerid,BlueMsg,string);
			if(player1 != playerid)
			{
			format(string,sizeof(string),"|- Administrator \"%s\" has set your weather to '%d' -|", pName(playerid), weather);
			SendClientMessage(player1,blue,string);
			}
			SetPlayerWeather(player1,weather);
			PlayerPlaySound(player1,1057,0.0,0.0,0.0);
   			return PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}
dcmd_setlevel(playerid,params[])
{
	if(AccInfo[playerid][LoggedIn] == 1)
	{
		if(AccInfo[playerid][Level] >= 5 || IsPlayerAdmin(playerid))
		{
		    new tmp [256];
			new tmp2[256];
			new Index;
			tmp  = strtok(params,Index);
			tmp2 = strtok(params,Index);
		    if(!strlen(params))
		    {
		    new string[128];
   			format(string,sizeof(string),"Usage: /setlevel [PlayerID] [Level (0-%d)]", ServerInfo[MaxAdminLevel]);
			SendClientMessage(playerid,LIGHTBLUE2,string);
			return SendClientMessage(playerid, orange, "Function: Will set the Level of Administration of the Specific Player");
			}
	    	new player1, level, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);
			if(!strlen(tmp2)) return
			SendClientMessage(playerid, LIGHTBLUE2, "Usage: /setlevel [PlayerID] [Level (0/5)]") &&
			SendClientMessage(playerid, orange, "Function: Will set the Level of Administration of the Specific Player");
			level = strval(tmp2);

			if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
				if(AccInfo[player1][LoggedIn] == 1)
				{
				if(level > ServerInfo[MaxAdminLevel])
				return SendClientMessage(playerid,red,"ERROR: Invalid Level");
				if(level == AccInfo[player1][Level])
				return SendClientMessage(playerid,red,"ERROR: Player is already this level");
	       		SendCommandToAdmins(playerid,"SetLevel");
				GetPlayerName(player1, playername, sizeof(playername));
				GetPlayerName(playerid, adminname, sizeof(adminname));
		       	new year,month,day;
		   		new hour,minute,second;
		  		getdate(year, month, day);
		  		gettime(hour,minute,second);

				if(level > 5)
				{
				AdmRank = "Professional Admin";
				}
 				switch(level)
				{
				case 1: AdmRank = "Basic Moderator";
				case 2: AdmRank = "Moderator";
				case 3: AdmRank = "Master Moderator";
				case 4: AdmRank = "Administrator";
				case 5: AdmRank = "Master Administrator";
				}
				if(level > 0)
				format(string,sizeof(string),"|- Administrator %s has set you to Administrator Status | Level: %d - %s -|",adminname, level, AdmRank);
				else
				format(string,sizeof(string),"|- Administrator %s has set you to Player Status | Level: %d -|",adminname, level);
				SendClientMessage(player1,LIGHTBLUE,string);
				if(level > AccInfo[player1][Level])
				GameTextForPlayer(player1,"Promoted", 2000, 3);
				else GameTextForPlayer(player1,"Demoted", 2000, 3);

				format(string,sizeof(string),"You have given %s Level %d on '%d/%d/%d' at '%d:%d:%d'", playername, level, day, month, year, hour, minute, second);
				SendClientMessage(playerid,yellow,string);
				format(string,sizeof(string),"Administrator %s has made %s Level %d",adminname, playername, level);
				SaveIn("AdminLog",string);
				dUserSetINT(PlayerName2(player1)).("Level",(level));
				AccInfo[player1][Level] = level;
				return PlayerPlaySound(player1,1057,0.0,0.0,0.0);
				}
				else return SendClientMessage(playerid,red,"ERROR: This player is not Registred or Logged!");
			}
			else return ErrorMessages(playerid, 2);
		}
		else return ErrorMessages(playerid, 1);
	}
	else return SendClientMessage(playerid,red,"ERROR: You must be logged in to use this commands");
}

dcmd_setvip(playerid,params[])
{
	if(AccInfo[playerid][LoggedIn] == 1)
	{
		if(AccInfo[playerid][Level] >= 5 || IsPlayerAdmin(playerid))
		{
		    new tmp [256];
			new tmp2[256];
			new Index;
			tmp  = strtok(params,Index);
			tmp2 = strtok(params,Index);
		    if(!strlen(params)) return
   			SendClientMessage(playerid, LIGHTBLUE2, "Usage: /setvip [PlayerID] [AccountType (0-3)]") &&
			SendClientMessage(playerid, orange, "Function: Will set the Account Type of the Specific Player (0-NormalAcc,1-Silver,2-Gold,3-Premium)");

	    	new player1, type, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);
			if(!strlen(tmp2)) return
			SendClientMessage(playerid, LIGHTBLUE2, "Usage: /setvip [PlayerID] [AccountType (0-3)]") &&
			SendClientMessage(playerid, orange, "Function: Will set the Account Type of the Specific Player (1-Silver,2-Gold,3-Premium)");
			type = strval(tmp2);

			if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
			{
				if(AccInfo[player1][LoggedIn] == 1)
				{
				if(type > 3)
				return SendClientMessage(playerid,red,"ERROR: Invalid Account Type!");
				if(type == AccInfo[player1][pVip])
				return SendClientMessage(playerid,red,"ERROR: Player is already have this Account Type!");
	       		SendCommandToAdmins(playerid,"SetVip");
				GetPlayerName(player1, playername, sizeof(playername));
				GetPlayerName(playerid, adminname, sizeof(adminname));
		       	new year,month,day;
		   		new hour,minute,second;
		  		getdate(year, month, day);
		  		gettime(hour,minute,second);

 				switch(type)
				{
					case 1: AccType = "Silver";
					case 2: AccType = "Gold";
					case 3: AccType = "Premium";
				}
				if(type > 0)
				format(string,sizeof(string),"|- Administrator %s has set your Account Type to: %s",adminname,AccType);
				else
				format(string,sizeof(string),"|- Administrator %s has set your Account Type to: 'Normal Account!",adminname);
				SendClientMessage(player1,0x66C178AA,string);
				if(type > AccInfo[player1][pVip])
				GameTextForPlayer(player1,"Promoted", 2000, 3);
				else GameTextForPlayer(player1,"Demoted", 2000, 3);

				format(string,sizeof(string),"You have given %s Account Type: %s on '%d/%d/%d' at '%d:%d:%d'", playername, AccType, day, month, year, hour, minute, second);
				SendClientMessage(playerid,0x00C378AA,string);
				format(string,sizeof(string),"Administrator %s has made %s Account Type: %s",adminname, playername, AccType);
				SaveIn("AdminLog",string);
				dUserSetINT(PlayerName2(player1)).("AccountType",(type));
				AccInfo[player1][pVip] = type;
				return PlayerPlaySound(player1,1057,0.0,0.0,0.0);
				}
				else return SendClientMessage(playerid,red,"ERROR: This player is not Registred or Logged!");
			}
			else return ErrorMessages(playerid, 2);
		}
		else return ErrorMessages(playerid, 1);
	}
	else return SendClientMessage(playerid,red,"ERROR: You must be logged in to use this commands");
}

dcmd_settemplevel(playerid,params[])
{
	if(AccInfo[playerid][LoggedIn] == 1)
	{
		if(AccInfo[playerid][Level] >= 4 || IsPlayerAdmin(playerid))
		{
		    new tmp [256];
			new tmp2[256];
			new Index;
			tmp  = strtok(params,Index);
			tmp2 = strtok(params,Index);
		    if(!strlen(tmp) || !strlen(tmp2)) return
			SendClientMessage(playerid, LIGHTBLUE2, "Usage: /settemplevel [PlayerID] [Level]") &&
			SendClientMessage(playerid, orange, "Function:  Will set the Temporary level of administration of the Specific Player");
	    	new player1, level, string[128];
			player1 = strval(tmp);
			level = strval(tmp2);

			if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
			{
				if(AccInfo[player1][LoggedIn] == 1)
				{
				if(level > ServerInfo[MaxAdminLevel])
				return SendClientMessage(playerid,red,"ERROR: Invalid Level!");
				if(level == AccInfo[player1][Level])
				return SendClientMessage(playerid,red,"ERROR: Player is already this Level");
 				SendCommandToAdmins(playerid,"SetTempLevel");
   				new year,month,day;
		        new hour,minute,second;
      		    getdate(year, month, day);
				gettime(hour,minute,second);

				if(level > 5)
				{
				AdmRank = "Professional Admin";
				}
 				switch(level)
				{
				case 1: AdmRank = "Basic Moderator";
				case 2: AdmRank = "Moderator";
				case 3: AdmRank = "Master Moderator";
				case 4: AdmRank = "Administrator";
				case 5: AdmRank = "Master Administrator";
				}
				if(level > 0)
				format(string,sizeof(string),"|- Administrator %s has Temporarily set you to Administrator Status | Level: %d - %s -|", pName(playerid), level, AdmRank);
				else
				format(string,sizeof(string),"|- Administrator %s has temporarily set you to Player Status | Level: %d -|", pName(playerid), level);
				SendClientMessage(player1,blue,string);

				if(level > AccInfo[player1][Level])
				GameTextForPlayer(player1,"Promoted", 2000, 3);
				else GameTextForPlayer(player1,"Demoted", 2000, 3);

				format(string,sizeof(string),"|- You have given %s Temp Level %d on '%d/%d/%d' at '%d:%d:%d' -|", pName(player1), level, day, month, year, hour, minute, second);
				SendClientMessage(playerid,BlueMsg,string);
				format(string,sizeof(string),"Administrator %s has made %s temp Level %d",pName(playerid), pName(player1), level);
				SaveIn("TempAdminLog",string);
				AccInfo[player1][Level] = level;
				return PlayerPlaySound(player1,1057,0.0,0.0,0.0);
				}
				else return SendClientMessage(playerid,red,"ERROR: Player must be registered and logged in to be admin");
			}
			else return ErrorMessages(playerid, 2);
		}
		else return ErrorMessages(playerid, 1);
	}
	else return SendClientMessage(playerid,red,"ERROR: You must be logged in to use this commands");
}
dcmd_setworld(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
 		new Index;
	    new tmp[256];  tmp  = strtok(params,Index);
	    new tmp2[256]; tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /setworld [PlayerID] [VirtualWorldID]") &&
		SendClientMessage(playerid, orange, "Function: Will set the Virtual World of specified player!");
		new player1 = strval(tmp);
		new time = strval(tmp2);
		new string[128];
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
			SendCommandToAdmins(playerid,"SetWorld");
			format(string, sizeof(string), "|- You have set \"%s's\" Virtual World to '%d' -|", pName(player1), time);
			SendClientMessage(playerid,BlueMsg,string);
			if(player1 != playerid)
			{
			format(string,sizeof(string),"|- Administrator \"%s\" has set your Virtual World to '%d' -|", pName(playerid), time);
			SendClientMessage(player1,blue,string);
			}
			PlayerPlaySound(player1,1057,0.0,0.0,0.0);
   			return SetPlayerVirtualWorld(player1, time);
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}
dcmd_setname(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3 || IsPlayerAdmin(playerid))
	{
	    new Index;
	    new tmp[256];  tmp  = strtok(params,Index);
	    new tmp2[256]; tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /setname [PlayerID] [NewName]") &&
		SendClientMessage(playerid, orange, "Function: Will set Name of specified player!");
		new player1 = strval(tmp);
		new length = strlen(tmp2);
		new string[128];
		if(length < 3 || length > MAX_PLAYER_NAME) return
		SendClientMessage(playerid,red,"ERROR: Incorrect Name Length");
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
			SendCommandToAdmins(playerid,"SetName");
			format(string, sizeof(string), "|- You have set \"%s's\" Name to \"%s\" -|", pName(player1), tmp2);
			SendClientMessage(playerid,BlueMsg,string);
			if(player1 != playerid)
			{
			format(string,sizeof(string),"|- Administrator \"%s\" has set your Name to \"%s\" -|", pName(playerid), tmp2);
			SendClientMessage(player1,blue,string);
			}
			SetPlayerName(player1, tmp2);
   			return OnPlayerConnect(player1);
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_setgravity(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
	    if(!strlen(params)||!(strval(params)<=50&&strval(params)>=-50)) return
		SendClientMessage(playerid,red,"USAGE: /setgravity <-50.0 - 50.0>");
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /setgravity [<-50.0 - 50.0->]") &&
		SendClientMessage(playerid, orange, "Function: Will set the server Gravity");
        SendCommandToAdmins(playerid,"SetGravity");
		new string[128],adminname[MAX_PLAYER_NAME];
		GetPlayerName(playerid, adminname, sizeof(adminname));
		new Float:Gravity = floatstr(params);
		format(string,sizeof(string),"|- Admnistrator %s has set the Server Gravity to %f -|",adminname,Gravity);
		SetGravity(Gravity);
		return SendClientMessageToAll(blue,string);
	}
	else return ErrorMessages(playerid, 1);
}
dcmd_eject(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
	    if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /eject [PlayerID]") &&
		SendClientMessage(playerid, orange, "Function: Will Ejected from vehicle a specified player");
		new player1 = strval(params);
		new string[128];
		new Float:x, Float:y, Float:z;
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
			if(IsPlayerInAnyVehicle(player1))
			{
		       	SendCommandToAdmins(playerid,"Eject");
				if(player1 != playerid)
				{
				format(string,sizeof(string),"|- Administrator \"%s\" has Ejected you from your Vehicle -|", pName(playerid));
				SendClientMessage(player1,blue,string);
				}
				format(string,sizeof(string)," |- You have ejected \"%s\" from their Vehicle -|", pName(player1));
				SendClientMessage(playerid,BlueMsg,string);
    		   	GetPlayerPos(player1,x,y,z);
				return SetPlayerPos(player1,x,y,z+3);
			}
			else return SendClientMessage(playerid,red,"ERROR: Player is not in a vehicle");
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_force(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
	    if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /force [PlayerID]") &&
		SendClientMessage(playerid, orange, "Function: Will Force return to class selection a specified Player");
		new player1 = strval(params);
		new string[128];
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
			SendCommandToAdmins(playerid,"Force");
			if(player1 != playerid)
		 	{
			format(string,sizeof(string),"|- Administrator \"%s\" has forced you into class selection -|", pName(playerid));
			SendClientMessage(player1,blue,string);
			}
			format(string,sizeof(string),"|- You have forced \"%s\" into class selection -|", pName(player1));
			SendClientMessage(playerid,BlueMsg,string);
			ForceClassSelection(player1);
			return SetPlayerHealth(player1,0.0);
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_burn(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 2)
	{
	    if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /burn [PlayerID]") &&
		SendClientMessage(playerid, orange, "Function: Will Burn a specified player (With explosion)");

		new player1 = strval(params);
		new string[128];
		new Float:x, Float:y, Float:z;
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
			SendCommandToAdmins(playerid,"Burn");
			format(string, sizeof(string), "You have burnt \"%s\" ", pName(player1));
			SendClientMessage(playerid,BlueMsg,string);
			if(player1 != playerid)
			{
			format(string,sizeof(string),"|- Administrator \"%s\" has burnt you", pName(playerid));
			SendClientMessage(player1,blue,string);
			}
			GetPlayerPos(player1, x, y, z);
			return CreateExplosion(x, y , z + 3, 1, 10);
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_lockcar(playerid,params[])
{
	#pragma unused params
    if(AccInfo[playerid][Level] >= 2)
	{
	    if(IsPlayerInAnyVehicle(playerid))
		{
		 	for(new i = 0; i < MAX_PLAYERS; i++)
			 SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid),i,false,true);
			SendCommandToAdmins(playerid,"LockCar");
			AccInfo[playerid][DoorsLocked] = 1;
			new string[128];
			format(string,sizeof(string),"|- Administrator \"%s\" has Locked his car -|", pName(playerid));
			return SendClientMessageToAll(blue,string);
		}
		else return SendClientMessage(playerid,red,"ERROR: You need to be in a vehicle to lock the doors");
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_unlockcar(playerid,params[])
{
	#pragma unused params
    if(AccInfo[playerid][Level] >= 2) {
	    if(IsPlayerInAnyVehicle(playerid))
		{
		 	for(new i = 0; i < MAX_PLAYERS; i++)
		  	SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid),i,false,false);
			SendCommandToAdmins(playerid,"UnlockCar");
			AccInfo[playerid][DoorsLocked] = 0;
			new string[128];
			format(string,sizeof(string),"|- Administrator \"%s\" has Unlocked his car -|", pName(playerid));
			return SendClientMessageToAll(blue,string);
		}
		else return SendClientMessage(playerid,red,"ERROR: You need to be in a vehicle to lock the doors");
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_crash(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 4)
	{
	    if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /crash [PlayerID]") &&
		SendClientMessage(playerid, orange, "Function: Will Crash a specified player");

		new player1 = strval(params), string[128], Float:X,Float:Y,Float:Z;
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
   			SendCommandToAdmins(playerid,"Crash");
	        GetPlayerPos(player1,X,Y,Z);
	   		new CrashObj = CreatePlayerObject(player1,11111111,X,Y,Z,0,0,0);
			DestroyObject(CrashObj);
			format(string, sizeof(string), "|- You have Crashed \"%s's\" -|", pName(player1));
			return SendClientMessage(playerid,blue, string);
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_spawn(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 2)
	{
	    if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /spawn [PlayerID]") &&
		SendClientMessage(playerid, orange, "Function: Will Spawn a specified player");
		new player1 = strval(params);
		new string[128];
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
			SendCommandToAdmins(playerid,"Spawn");
			format(string, sizeof(string), "|- You have Spawned \"%s\" -|", pName(player1));
			SendClientMessage(playerid,BlueMsg,string);
			if(player1 != playerid)
			{
			format(string,sizeof(string),"|- Administrator \"%s\" has Spawned you -|", pName(playerid));
			SendClientMessage(player1,blue,string);
			}
			SetPlayerPos(player1, 0.0, 0.0, 0.0);
			return SpawnPlayer(player1);
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}
dcmd_spawnplayer(playerid,params[])
{
	return dcmd_spawn(playerid,params);
}


dcmd_giveweapon(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 2)
	{
		new Index;
	    new tmp[256];  tmp  = strtok(params,Index);
		new tmp2[256]; tmp2 = strtok(params,Index);
		new tmp3[256]; tmp3 = strtok(params,Index);

	    if(!strlen(tmp) || !strlen(tmp2)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /giveweapon [PlayerID] [Weapon ID/Name] [Ammo]") &&
		SendClientMessage(playerid, orange, "Function: Will Crash a specified player");
		new player1 = strval(tmp);
		new weap, ammo, WeapName[32];
		new string[128];
		if(!strlen(tmp3) || !IsNumeric(tmp3) || strval(tmp3) <= 0 || strval(tmp3) > 99999) ammo = 500;
		else ammo = strval(tmp3);
		if(!IsNumeric(tmp2)) weap = GetWeaponIDFromName(tmp2);
		else weap = strval(tmp2);
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
        	if(!IsValidWeapon(weap))
			return SendClientMessage(playerid,red,"ERROR: Invalid Weapon ID");
			SendCommandToAdmins(playerid,"GiveWeapon");
			GetWeaponName(weap,WeapName,32);
			format(string, sizeof(string), "|- You have given \"%s\" a %s (%d) with %d rounds of Ammo -|", PlayerName2(player1), WeapName, weap, ammo);
			SendClientMessage(playerid,BlueMsg,string);
			if(player1 != playerid)
			{
			format(string,sizeof(string),"|- Administrator \"%s\" has given you a %s (%d) with %d rounds of Ammo -|", PlayerName2(playerid), WeapName, weap, ammo);
			SendClientMessage(player1,blue,string);
			}
   			return GivePlayerWeapon(player1, weap, ammo);
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_disarm(playerid,params[])
{
	if(AccInfo[playerid][pVip] >= 1)
	{
	    if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /disarm [PlayerID]") &&
		SendClientMessage(playerid, orange, "Function: Will disarm a specified player");
		new player1 = strval(params);
		new string[128];
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
			SendCommandToAdmins(playerid,"Disarm");
			PlayerPlaySound(player1,1057,0.0,0.0,0.0);
			format(string, sizeof(string), "|- You have disarmed \"%s\" -|", pName(player1));
			SendClientMessage(playerid,BlueMsg,string);
			if(player1 != playerid)
			{
			format(string,sizeof(string),"|- Administrator \"%s\" has Disarmed you -|", pName(playerid));
			SendClientMessage(player1,blue,string);
			}
			ResetPlayerWeapons(player1);
			return PlayerPlaySound(player1,1057,0.0,0.0,0.0);
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return SendClientMessage(playerid, red, "ERROR: Your Are Not an Officers");
}
dcmd_aweaps(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][Level] >= 3)
	{
		GivePlayerWeapon(playerid,31,1000); GivePlayerWeapon(playerid,16,1000);
	 	GivePlayerWeapon(playerid,34,1000); GivePlayerWeapon(playerid,28,1000);
		GivePlayerWeapon(playerid,38,1000); GivePlayerWeapon(playerid,24,1000);
		GivePlayerWeapon(playerid,26,1000); GivePlayerWeapon(playerid,42,1000);
		GivePlayerWeapon(playerid,14,1000); GivePlayerWeapon(playerid,46,1000);
		GivePlayerWeapon(playerid,9,1);
		return 1;
	}
	else return ErrorMessages(playerid, 6);
}
dcmd_sremovecash(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
	    if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /sremovecash [PlayerID]") &&
		SendClientMessage(playerid, orange, "Function: Will silently remove Cash of specified player");
		new player1 = strval(params);
		new string[128];
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
			SendCommandToAdmins(playerid,"SRemoveCash");
			format(string, sizeof(string), "|- You have Silently reset \"%s's\" Cash -|", pName(player1));
			SendClientMessage(playerid,BlueMsg,string);
   			return ResetPlayerMoney(player1);
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}
dcmd_removecash(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
	    if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /removecash [PlayerID]") &&
		SendClientMessage(playerid, orange, "Function: Will remove Cash of specified player");
	    new player1 = strval(params);
		new string[128];

		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
			SendCommandToAdmins(playerid,"RemoveCash");
			format(string, sizeof(string), "You have reset \"%s's\" Cash!", pName(player1));
			SendClientMessage(playerid,BlueMsg,string);
			if(player1 != playerid)
			{
			format(string,sizeof(string),"|- Administrator \"%s\" has reset your Cash' -|", pName(playerid));
			SendClientMessage(player1,blue,string);
			}
   			return ResetPlayerMoney(player1);
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_ubound(playerid,params[])
{
 	if(AccInfo[playerid][Level] >= 3)
	{
		if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /ubound [PlayerID]") &&
		SendClientMessage(playerid, orange, "Function: Will removed World Boundaries of specified player");
	    new string[128], player1 = strval(params);

	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
			SendCommandToAdmins(playerid,"Ubound");
			SetPlayerWorldBounds(player1, 9999.9, -9999.9, 9999.9, -9999.9 );
			format(string, sizeof(string), "|- Administrator %s has removed your World Boundaries -|", PlayerName2(playerid));
			if(player1 != playerid)
			SendClientMessage(player1,blue,string);
			format(string,sizeof(string),"|- You have removed %s's World Boundaries -|", PlayerName2(player1));
			return SendClientMessage(playerid,BlueMsg,string);
		}
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}
dcmd_ip(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 1)
	{
	    if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /ip [PlayerID]") &&
		SendClientMessage(playerid, orange, "Function: Will see Ip of specified player");
		new player1 = strval(params);
		new string[128];
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
			SendCommandToAdmins(playerid,"Ip");
			new tmp3[50];
			GetPlayerIp(player1,tmp3,50);
			format(string,sizeof(string),"PlayerName: %s | IP: %s", pName(player1), tmp3);
			return SendClientMessage(playerid,yellow,string);
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}
dcmd_lconfig(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][Level] > 0)
	{
	    new string[128];

	    new rAutoLogin  [4],rReadCmds   [4],rReadPMs  [4],rAntiSpam  [4],rNameKick   [4],rAntiBot [4];
	    new rLocked     [4],rConnectMsg [4], rACmdMsg [4],rAntiSwear [4],rSaveWeapon [4],rASkins  [4];
	    new rDisableChat[4],rMustLogin  [4],rMustReg  [4],rNoCaps    [4],rSaveMoney  [4],rFWeaps  [4];
		new rAntiAds    [4];

	    if(ServerInfo[AutoLogin] 	 	== 1) rAutoLogin 	= "Yes"; else rAutoLogin 	 = "No";
	    if(ServerInfo[ReadCmds] 	 	== 1) rReadCmds  	= "Yes"; else rReadCmds  	 = "No";
	    if(ServerInfo[ReadPMs] 	 	 	== 1) rReadPMs  	= "Yes"; else rReadPMs     	 = "No";
	    if(ServerInfo[AntiSpam]		 	== 1) rAntiSpam 	= "Yes"; else rAntiSpam		 = "No";
	    if(ServerInfo[NameKick]  	 	== 1) rNameKick		= "Yes"; else rNameKick		 = "No";
	    if(ServerInfo[AdminOnlySkins]  	== 1) rASkins		= "Yes"; else rASkins		 = "No";
	    if(ServerInfo[AntiBot] 			== 1) rAntiBot 		= "Yes"; else rAntiBot	 	 = "No";
	    if(ServerInfo[AntiSwear] 	 	== 1) rAntiSwear	= "Yes"; else rAntiSwear 	 = "No";
	    if(ServerInfo[Locked] 	  	 	== 1) rLocked 	    = "Yes"; else rLocked      	 = "No";
	    if(ServerInfo[ConnectMessages]  == 1) rConnectMsg   = "Yes"; else rConnectMsg    = "No";
	    if(ServerInfo[AdminCmdMsg]      == 1) rACmdMsg   	= "Yes"; else rACmdMsg		 = "No";
	    if(ServerInfo[DisableChat] 		== 1) rDisableChat  = "Yes"; else rDisableChat   = "No";
	    if(ServerInfo[MustLogin] 		== 1) rMustLogin    = "Yes"; else rMustLogin 	 = "No";
	    if(ServerInfo[MustRegister]		== 1) rMustReg	    = "Yes"; else rMustReg		 = "No";
	    if(ServerInfo[NoCaps]			== 1) rNoCaps	    = "Yes"; else rNoCaps		 = "No";
	    if(ServerInfo[GiveWeap]			== 1) rSaveWeapon   = "Yes"; else rSaveWeapon    = "No";
	    if(ServerInfo[GiveMoney] 		== 1) rSaveMoney    = "Yes"; else rSaveMoney     = "No";
	    if(ServerInfo[ForbiddenWeaps] 	== 1) rFWeaps    	= "Yes"; else rFWeaps     	 = "No";
	    if(ServerInfo[ForbiddenWeaps] 	== 1) rFWeaps    	= "Yes"; else rFWeaps     	 = "No";
	    if(ServerInfo[AntiAds] 			== 1) rAntiAds    	= "Yes"; else rAntiAds     	 = "No";

		SendClientMessage(playerid, orange, " ");
		SendClientMessage(playerid, LIGHTBLUE, "___________ |- LuxAdmin System - Configuration -| ___________");
		format(string, sizeof(string), "AutoLogin: %s | ReadCmds: %s | ReadPms: %s | Max Admin Level: %d | AntiSpam: %s", rAutoLogin,  rReadCmds, rReadPMs,  ServerInfo[MaxAdminLevel],rAntiSpam);
		SendClientMessage(playerid,white,string);
		format(string, sizeof(string), "AdmSkins: %s | AdminSkin1: %d | AdminSkin2: %d | NameKick: %s | AntiBot: %s",rASkins, ServerInfo[AdminSkin], ServerInfo[AdminSkin2], rNameKick, rAntiBot);
		SendClientMessage(playerid,white,string);
		format(string, sizeof(string), "AntiSwear: %s | Locked: %s | Pass: %s | ConnectMessages: %s | AdminCmdMsgs: %s",rAntiSwear, rLocked, ServerInfo[Password], rConnectMsg, rACmdMsg);
		SendClientMessage(playerid,white,string);
		format(string, sizeof(string), "Max Ping: %dms |  ChatDisabled: %s | MaxMuteWarnings: %d | MustLogin: %s | Anti Ads: %s", ServerInfo[MaxPing],rDisableChat, ServerInfo[MaxMuteWarnings], rMustLogin, rAntiAds);
		SendClientMessage(playerid,white,string);
		format(string, sizeof(string), "MustRegister: %s | NoCaps: %s | SaveWeaps: %s | SaveMoney: %s | Forbidden Weapons: %s",rMustReg, rNoCaps,rSaveWeapon, rSaveMoney, rFWeaps);
		SendClientMessage(playerid,white,string);
	}
	return 1;
}

dcmd_time(playerid,params[])
{
	#pragma unused params
	new string[64];
	new hour,minuite,second;
	gettime(hour,minuite,second);
	format(string, sizeof(string), "~g~|~w~%d:%d~g~|", hour, minuite);
	return GameTextForPlayer(playerid, string, 5000, 1);
}

dcmd_getinfo(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 1 || IsPlayerAdmin(playerid))
	{
	    if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /getinfo [PlayerID] ") &&
		SendClientMessage(playerid, orange, "Function: Will see Informations of specified player");
	    new player1;
		new string[128];
	    player1 = strval(params);

	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		 {
			new TimesOn;
			new pIP[128];
		    new Float:pHealth;
			new Float:pArmour;
			new year,month,day;
			new pn,Sum, Average;
			new tmp2[256],file[256];
			new Float:x,Float:y,Float:z;
			new pRegister[4],RegDate[256];
			new pJailed[4],pFrozen[4];
			new pInCage[4], pLogged[4];
			new LuX_GpsZone[MAX_ZONE_NAME] = "Undetected Zone!";

			GetPlayerArmour(player1,pArmour);
			GetPlayerHealth(player1,pHealth);
	    	GetPlayerIp(player1, pIP, sizeof(pIP));
	    	getdate(year, month, day);
	    	GetPlayerPos(player1,x,y,z);
			GetPlayerInZone(player1, LuX_GpsZone, MAX_ZONE_NAME);

			format(file,sizeof(file),"/LuxAdmin/Accounts/%s.sav",udb_encode(PlayerName2(player1)));

			if(AccInfo[player1][Jailed] == 1)   pJailed   = "Yes"; else pJailed   = "No";
			if(AccInfo[player1][Frozen] == 1) 	pFrozen   = "Yes"; else pFrozen   = "No";
			if(AccInfo[player1][pCaged] == 1) 	pInCage   = "Yes"; else pInCage   = "No";
			if(AccInfo[player1][LoggedIn] == 1) pLogged   = "Yes"; else pLogged   = "No";
			if(fexist(file))				    pRegister = "Yes"; else pRegister = "No";

			if(dUserINT(PlayerName2(player1)).("LastOn")==0)
			tmp2 = "Never";
			else tmp2 = dini_Get(file,"LastOn");

			if(strlen(dini_Get(file,"RegisteredDate")) < 3)
			RegDate = "n/a";
			else RegDate = dini_Get(file,"RegisteredDate");

			TimesOn = dUserINT(PlayerName2(player1)).("TimesOnServer");

			while (pn < PING_MAX_EXCEEDS){
			Sum += AccInfo[player1][pPing][pn]; pn++;
			}
			Average = (Sum / PING_MAX_EXCEEDS);
 			if(IsPlayerAdmin(player1)) AdmRank = "RCON Administrator";
	    	else
 			switch(AccInfo[player1][Level])
			{
			case 1: AdmRank = "Basic Moderator";
			case 2: AdmRank = "Moderator";
			case 3: AdmRank = "Master Moderator";
			case 4: AdmRank = "Administrator";
			case 5: AdmRank = "Master Administrator";
			}
			if(AccInfo[playerid][Level] > 5)
			{
			AdmRank = "Professional Admin";
			}
			SendClientMessage(playerid, orange, " ");
 			SendClientMessage(playerid, orange, "___________ |- Player Information -| ___________");
	  		format(string, sizeof(string),"Name: %s | ID: %d | Ip: %s | Health: %d | Armour: %d | Cash: %d", PlayerName2(player1),player1,pIP,floatround(pHealth),floatround(pArmour),GetPlayerMoney(player1));
			SendClientMessage(playerid,LIGHTGREEN,string);
		  	format(string, sizeof(string),"Score: %d | Skin: %d | Ping: %d (Average: %d) | Wanted Level: %d", GetPlayerScore(player1),GetPlayerSkin(player1),GetPlayerPing(player1),Average,GetPlayerWantedLevel(player1));
			SendClientMessage(playerid,0x33F666FF,string);
			format(string, sizeof(string),"Interior: %d | Virtual World: %d | Pos: X: %0.1f, Y: %0.1f, Z: %0.1f | In: %s", GetPlayerInterior(player1), GetPlayerVirtualWorld(player1), Float:x,Float:y,Float:z,LuX_GpsZone);
			SendClientMessage(playerid,0x53D266FF,string);
			format(string, sizeof(string),"Kills: %d | Deaths: %d | Ratio: %0.2f | Admin Level: %d - %s | In Cage: %s", AccInfo[player1][Kills],AccInfo[player1][Deaths],Float:AccInfo[player1][Kills]/Float:AccInfo[player1][Deaths],AccInfo[player1][Level],AdmRank,pInCage);
			SendClientMessage(playerid,0x53D212FF,string);
			format(string, sizeof(string),"Registered: %s | Logged In: %s | In Jail: %s | Frozen: %s | On Server: %d",pRegister,pLogged,pJailed,pFrozen,TimesOn);
			SendClientMessage(playerid,0x53BB12FF,string);
			format(string, sizeof(string),"Last On Server: %s | Register Date: %s | Todays Date: %d/%d/%d",tmp2,RegDate,day,month,year);
			SendClientMessage(playerid,0x129E12FF,string);

			if(IsPlayerInAnyVehicle(player1))
			{
			new Float:VHealth, carid = GetPlayerVehicleID(playerid);
			GetVehicleHealth(carid,VHealth);
			format(string, sizeof(string),"Vehicle Name: %s | VehicleID: %d | Model: %d | Vehicle Health: %d",VehicleNames[GetVehicleModel(carid)-400],carid,GetVehicleModel(carid),floatround(VHealth));
			SendClientMessage(playerid,0x12B281FF,string);
			}

			new slot, ammo, weap, Count, WeapName[24], WeapSTR[128], p; WeapSTR = "Weapons: ";
			for (slot = 0; slot < 14; slot++)
			{
			GetPlayerWeaponData(player1, slot, weap, ammo);
			if( ammo != 0 && weap != 0)
			Count++;
			}
			if(Count < 1)
			return SendClientMessage(playerid,0x6BF686FF,"Player has no weapons");
			else
			{
				for (slot = 0; slot < 14; slot++)
				{
					GetPlayerWeaponData(player1, slot, weap, ammo);
					if (ammo > 0 && weap > 0)
					{
						GetWeaponName(weap, WeapName, sizeof(WeapName) );
						if (ammo == 65535 || ammo == 1)
						format(WeapSTR,sizeof(WeapSTR),"%s%s (1)",WeapSTR, WeapName);
						else format(WeapSTR,sizeof(WeapSTR),"%s%s (%d)",WeapSTR, WeapName, ammo);
						p++;
						if(p >= 5)
						{
						SendClientMessage(playerid, 0x6BF686FF, WeapSTR); format(WeapSTR, sizeof(WeapSTR), "Weapons: "); p = 0;
						}
						else format(WeapSTR, sizeof(WeapSTR), "%s,  ", WeapSTR);
					}
				}
				if(p <= 4 && p > 0)
				{
					string[strlen(string)-3] = '.';
				    SendClientMessage(playerid, 0x6BF686FF, WeapSTR);
				}
			}
			return 1;
		}
		else return ErrorMessages(playerid, 2);
	}
	else return  ErrorMessages(playerid, 7);
}

dcmd_disable(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 4 || IsPlayerAdmin(playerid))
	{
	    if(!strlen(params))
		{
			SendClientMessage(playerid, LIGHTBLUE2, "Usage: /disable [AntiSwear/NameKick/AntiSpam/Ping/ReadCmds/ReadPms/Caps/AdminCmdMsgs/ConnectMsgs/AntiAds/AutoLogin/Antiweaps]");
			return SendClientMessage(playerid, orange, "Function: Will disable a specified Function (Some functions are only in Enable/Disable Dialog)");
		}
	    new string[128], file[256]; format(file,sizeof(file),"LuxAdmin/Config/Config.ini");
		if(strcmp(params,"antiswear",true) == 0) {
			ServerInfo[AntiSwear] = 0;
			dini_IntSet(file,"AntiSwear",0);
			format(string,sizeof(string),"|- Administrator %s has disabled AntiSwear", PlayerName2(playerid));
			SendClientMessageToAll(blue,string);
		}
		else if(strcmp(params,"namekick",true) == 0) {
			ServerInfo[NameKick] = 0;
			dini_IntSet(file,"NameKick",0);
			format(string,sizeof(string),"|- Administrator %s has disabled NameKick", PlayerName2(playerid));
			SendClientMessageToAll(blue,string);
	 	}
		else if(strcmp(params,"antispam",true) == 0)	{
			ServerInfo[AntiSpam] = 0;
			dini_IntSet(file,"AntiSpam",0);
			format(string,sizeof(string),"|- Administrator %s has disabled AntiSpam", PlayerName2(playerid));
			SendClientMessageToAll(blue,string);
		}
		else if(strcmp(params,"ping",true) == 0)	{
			ServerInfo[MaxPing] = 0;
			dini_IntSet(file,"MaxPing",0);
			format(string,sizeof(string),"|- Administrator %s has disabled Ping Kick", PlayerName2(playerid));
			SendClientMessageToAll(blue,string);
		}
		else if(strcmp(params,"readcmds",true) == 0) {
			ServerInfo[ReadCmds] = 0;
			dini_IntSet(file,"ReadCmds",0);
			format(string,sizeof(string),"|- Administrator %s has disabled Reading Commands", PlayerName2(playerid));
			MessageToAdmins(blue,string);
		}
		else if(strcmp(params,"readpms",true) == 0) {
			ServerInfo[ReadPMs] = 0;
			dini_IntSet(file,"ReadPMs",0);
			format(string,sizeof(string),"|- Administrator %s has disabled Reading Pms", PlayerName2(playerid));
			MessageToAdmins(blue,string);
  		}
	  	else if(strcmp(params,"caps",true) == 0)	{
			ServerInfo[NoCaps] = 0;
			dini_IntSet(file,"NoCaps",0);
			format(string,sizeof(string),"|- Administrator %s has prevented	CapsLock in chat", PlayerName2(playerid));
			SendClientMessageToAll(blue,string);
		}
		else if(strcmp(params,"antiweaps",true) == 0)	{
			ServerInfo[ForbiddenWeaps] = 0;
			dini_IntSet(file,"ForbiddenWeapons",0);
			format(string,sizeof(string),"|- Administrator %s has prevented Anti Forbidden Weapons", PlayerName2(playerid));
			SendClientMessageToAll(0x00A700FF,string);
			SendClientMessage(playerid, orange, "|- To update Forbidden Weapons File use: /uconfig -|");
		}
	 	else if(strcmp(params,"admincmdmsgs",true) == 0) {
			ServerInfo[AdminCmdMsg] = 0;
			dini_IntSet(file,"AdminCMDMessages",0);
			format(string,sizeof(string),"|- Administrator %s has disabled Administration Command Messages", PlayerName2(playerid));
			MessageToAdmins(green,string);
		}
		else if(strcmp(params,"connectmsgs",true) == 0)	{
			ServerInfo[ConnectMessages] = 0;
			dini_IntSet(file,"ConnectMessages",0);
			format(string,sizeof(string),"|- Administrator %s has disabled Connect and Disconnect Messages", PlayerName2(playerid));
			MessageToAdmins(green,string);
		}
		else if(strcmp(params,"antiads",true) == 0)	{
			ServerInfo[AntiAds] = 0;
			dini_IntSet(file,"AntiAdvertisements",0);
			format(string,sizeof(string),"|- Administrator %s has disabled Anti Advertisements", PlayerName2(playerid));
			MessageToAdmins(green,string);
		}
		else if(strcmp(params,"autologin",true) == 0)	{
			ServerInfo[AutoLogin] = 0;
			dini_IntSet(file,"AutoLogin",0);
			format(string,sizeof(string),"|- Administrator %s has disabled Auto Login", PlayerName2(playerid));
			MessageToAdmins(green,string);
		}
		else {
			SendClientMessage(playerid, LIGHTBLUE2, "Usage: /disable [AntiSwear/NameKick/AntiSpam/Ping/ReadCmds/ReadPms/Caps/AdminCmdMsgs/ConnectMsgs/AntiAds/AutoLogin/Antiweaps]");
			SendClientMessage(playerid, orange, "Function: Will disable a specified Function (Some functions are only in Enable/Disable Dialog)");
		} return 1;
 }
	else return ErrorMessages(playerid, 1);
}

dcmd_enable(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 4 || IsPlayerAdmin(playerid))
	{
	    if(!strlen(params))
		{
			SendClientMessage(playerid, LIGHTBLUE2, "Usage: /enable [AntiSwear/NameKick/AntiSpam/Ping/ReadCmds/ReadPms/Caps/AdminCmdMsgs/ConnectMsgs/AntiAds/AutoLogin/Antiweaps]");
			return SendClientMessage(playerid, orange, "Function: Will enable a specified Function (Some functions are only in Enable/Disable Dialog)");
		}
	    new string[128], file[256]; format(file,sizeof(file),"LuxAdmin/Config/Config.ini");
		if(strcmp(params,"antiswear",true) == 0) {
			ServerInfo[AntiSwear] = 1;
			dini_IntSet(file,"AntiSwear",1);
			format(string,sizeof(string),"|- Administrator %s has enabled AntiSwear", PlayerName2(playerid));
			SendClientMessageToAll(0x00A700FF,string);
		}
		else if(strcmp(params,"namekick",true) == 0) {
			ServerInfo[NameKick] = 1;
			format(string,sizeof(string),"|- Administrator %s has enabled NameKick", PlayerName2(playerid));
			SendClientMessageToAll(0x00A700FF,string);
 		}
		else if(strcmp(params,"antispam",true) == 0)	{
			ServerInfo[AntiSpam] = 1;
			dini_IntSet(file,"AntiSpam",1);
			format(string,sizeof(string),"|- Administrator %s has enabled AntiSpam", PlayerName2(playerid));
			SendClientMessageToAll(0x00A700FF,string);
		}
		else if(strcmp(params,"ping",true) == 0)	{
			ServerInfo[MaxPing] = 800;
			dini_IntSet(file,"MaxPing",800);
			format(string,sizeof(string),"|- Administrator %s has enabled Ping Kick", PlayerName2(playerid));
			SendClientMessageToAll(0x00A700FF,string);
		}
		else if(strcmp(params,"readcmds",true) == 0)	{
			ServerInfo[ReadCmds] = 1;
			dini_IntSet(file,"ReadCmds",1);
			format(string,sizeof(string),"|- Administrator %s has enabled Reading Commands", PlayerName2(playerid));
			MessageToAdmins(orange,string);
		}
		else if(strcmp(params,"readpms",true) == 0) {
			ServerInfo[ReadPMs] = 1;
			dini_IntSet(file,"ReadPMs",1);
			format(string,sizeof(string),"|- Administrator %s has enabled Reading Pms", PlayerName2(playerid));
			MessageToAdmins(orange,string);
		}
		else if(strcmp(params,"caps",true) == 0)	{
			ServerInfo[NoCaps] = 1;
			dini_IntSet(file,"NoCaps",1);
			format(string,sizeof(string),"|- Administrator %s has allowed CaPsLoCk in chat", PlayerName2(playerid));
			SendClientMessageToAll(0x00A700FF,string);
		}
		else if(strcmp(params,"antiweaps",true) == 0)	{
			ServerInfo[ForbiddenWeaps] = 1;
			dini_IntSet(file,"ForbiddenWeapons",1);
			format(string,sizeof(string),"|- Administrator %s has allowed Anti Forbidden Weapons", PlayerName2(playerid));
			SendClientMessageToAll(0x00A700FF,string);
			SendClientMessage(playerid, orange, "|- To update Forbidden Weapons File use: /uconfig -|");
		}
		else if(strcmp(params,"admincmdmsgs",true) == 0)	{
			ServerInfo[AdminCmdMsg] = 1;
			dini_IntSet(file,"AdminCmdMessages",1);
			format(string,sizeof(string),"|- Administrator %s has enabled Administration Command Messages", PlayerName2(playerid));
			MessageToAdmins(orange,string);
		}
		else if(strcmp(params,"connectmsgs",true) == 0) {
			ServerInfo[ConnectMessages] = 1;
			dini_IntSet(file,"ConnectMessages",1);
			format(string,sizeof(string),"|- Administrator %s has enabled Connect and Disconnect Messages", PlayerName2(playerid));
			MessageToAdmins(orange,string);
		}
		else if(strcmp(params,"antiads",true) == 0)	{
			ServerInfo[AntiAds] = 1;
			dini_IntSet(file,"AntiAdvertisements",1);
			format(string,sizeof(string),"|- Administrator %s has enabled Anti Advertisements", PlayerName2(playerid));
			MessageToAdmins(green,string);
		}
		else if(strcmp(params,"autologin",true) == 0) {
			ServerInfo[AutoLogin] = 1;
			dini_IntSet(file,"AutoLogin",1);
			format(string,sizeof(string),"|- Administrator %s has enabled Auto Login", PlayerName2(playerid));
			MessageToAdmins(orange,string);
		}
		else {
			SendClientMessage(playerid, LIGHTBLUE2, "Usage: /enable [AntiSwear/NameKick/AntiSpam/Ping/ReadCmds/ReadPms/Caps/AdminCmdMsgs/ConnectMsgs/AntiAds/AutoLogin/Antiweaps]");
			SendClientMessage(playerid, orange, "Function: Will enable a specified Function (Some functions are only in Enable/Disable Dialog)");
		}
		return 1;
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_kill(playerid,params[])
{
	#pragma unused params
	return SetPlayerHealth(playerid,0.0);
}

dcmd_lammo(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][Level] >= 3)
	{
	MaxAmmo(playerid);
	return SendCommandToAdmins(playerid,"LAmmo");
	}
	else return ErrorMessages(playerid, 6);
}

dcmd_setping(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3 || IsPlayerAdmin(playerid))
	{
 		if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /setping [Ping] (Disable: '0')") &&
		SendClientMessage(playerid, orange, "Function: Will set specified value of maximum Ping allowed in Server!");
	    new string[128], ping = strval(params);
		ServerInfo[MaxPing] = ping;
		SendCommandToAdmins(playerid,"SetPing");
		new file[256]; format(file,sizeof(file),"LuxAdmin/Config/Config.ini");
		dini_IntSet(file,"MaxPing",ping);
		for(new i = 0; i <= MAX_PLAYERS; i++)
		if(IsPlayerConnected(i))
		PlayerPlaySound(i,1057,0.0,0.0,0.0);
		if(ping == 0)
		format(string,sizeof(string),"|- Administrator %s has Disabled maximum Ping -|", PlayerName2(playerid), ping);
		else format(string,sizeof(string),"|- Administrator %s has set the Maximum Ping to: %d -|", PlayerName2(playerid), ping);
		return SendClientMessageToAll(yellow,string);
	}
	else return ErrorMessages(playerid, 6);
}

dcmd_ping(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 1)
	{
	    if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /ping [PlayerID]") &&
		SendClientMessage(playerid, orange, "Function: Will see the Ping Informations of the specified player");
		new player1 = strval(params), string[128];
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
		    new Sum, Average, x;
			while (x < PING_MAX_EXCEEDS)
			{
				Sum += AccInfo[player1][pPing][x];
				x++;
			}
			Average = (Sum / PING_MAX_EXCEEDS);
			format(string, sizeof(string), "|- \"%s\" (Id: %d) Average Ping: %d - Last Readings: %d, %d, %d, %d", PlayerName2(player1), player1, Average, AccInfo[player1][pPing][0], AccInfo[player1][pPing][1], AccInfo[player1][pPing][2], AccInfo[player1][pPing][3] );
			return SendClientMessage(playerid,blue,string);
		}
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}
dcmd_fix(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][Level] >= 0)
	{
	new playerState = GetPlayerState(playerid);
	if(playerState == PLAYER_STATE_DRIVER)
	{
	RepairVehicle(GetPlayerVehicleID(playerid));
 	return SendClientMessage(playerid,blue,"|- Vehicle Fixed! -|");
		}
		else return ErrorMessages(playerid, 10);
	}
	else return ErrorMessages(playerid, 8);
}
dcmd_repair(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][Level] >= 0)
	{
		if (IsPlayerInAnyVehicle(playerid))
		{
		    new VehicleID = GetPlayerVehicleID(playerid);
			RepairVehicle(VehicleID);
			GameTextForPlayer(playerid,"~w~~n~~n~~n~~n~~n~~n~Vehicle ~g~Repaired!",3000,3);
			return SetVehicleHealth(VehicleID, 1000);
		}
		else return ErrorMessages(playerid, 10);
	}
	else return ErrorMessages(playerid, 8);
}

dcmd_acar(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][Level] >= 2)
	{
		if (!IsPlayerInAnyVehicle(playerid))
		{
			CarSpawner(playerid,411);
			SendCommandToAdmins(playerid,"ACar");
			return SendClientMessage(playerid,yellow,"|- Car Successfully Created! -|");
		}
		else return SendClientMessage(playerid,red,"Error: You already have a vehicle");
	}
	else return ErrorMessages(playerid, 7);
}
dcmd_aheli(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][Level] >= 2)
	{
		if (!IsPlayerInAnyVehicle(playerid))
		{
			CarSpawner(playerid,487);
			SendCommandToAdmins(playerid,"AHeli");
			return SendClientMessage(playerid,yellow,"|- Helicopter Successfully Created! -|");
		}
		else return SendClientMessage(playerid,red,"Error: You already have a vehicle");
	}
	else return ErrorMessages(playerid, 7);
}
dcmd_aboat(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][Level] >= 2)
	{
		if (!IsPlayerInAnyVehicle(playerid))
		{
			CarSpawner(playerid,493);
			SendCommandToAdmins(playerid,"ABoat");
			return SendClientMessage(playerid,yellow,"|- Bot Successfully Created! -|");
		}
		else return SendClientMessage(playerid,red,"Error: You already have a vehicle");
	}
	else return ErrorMessages(playerid, 7);
}
dcmd_aplane(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][Level] >= 2)
	{
		if (!IsPlayerInAnyVehicle(playerid))
		{
			CarSpawner(playerid,513);
			SendCommandToAdmins(playerid,"APlane");
			return SendClientMessage(playerid,yellow,"|- Plane Successfully Created! -|");
		}
		else return SendClientMessage(playerid,red,"ERROR: You already have a vehicle");
	}
	else return ErrorMessages(playerid, 7);
}

dcmd_abike(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][Level] >= 2)
	{
		if (!IsPlayerInAnyVehicle(playerid))
		{
			CarSpawner(playerid,522);
			SendCommandToAdmins(playerid,"ABike");
			return SendClientMessage(playerid,yellow,"|- Bike Successfully Created! -|");
		}
		else return SendClientMessage(playerid,red,"Error: You already have a vehicle");
	}
	else return ErrorMessages(playerid, 7);
}
dcmd_addnos(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][Level] >= 1)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
	        switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
			{
				case 448,461,462,463,468,471,509,510,521,522,523,581,586,449:
				return SendClientMessage(playerid,red,"ERROR: You can not tune this vehicle!");
			}
	        AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
			return StartTuneSound(playerid);
		}
		else return SendClientMessage(playerid,red,"ERROR: You must be in a vehicle.");
	}
	else return ErrorMessages(playerid, 1);
}




/*

{
	if(AccInfo[playerid][Level] >= 3)
	{
	    new Index;
	    new tmp[256];  tmp  = strtok(params,Index);
		new tmp2[256]; tmp2 = strtok(params,Index);
		new tmp3[256]; tmp3 = strtok(params,Index);

	    if(!strlen(tmp) || !strlen(tmp2) || !strlen(tmp3) || !IsNumeric(tmp2)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /carcolour [PlayerID] [Colour1] [Colour2]") &&
   	    SendClientMessage(playerid, orange, "Function: Will change vehicle colour of specified player");

		new player1 = strval(tmp), colour1, colour2, string[128];
		if(!strlen(tmp2)) colour1 = random(126);
		else colour1 = strval(tmp2);
		if(!strlen(tmp3)) colour2 = random(126);
		else colour2 = strval(tmp3);

		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
            if(IsPlayerInAnyVehicle(player1))
			{
		       	SendCommandToAdmins(playerid,"CarColour");
				format(string, sizeof(string), "|- You have Changed the colour of \"%s's\" %s to '%d,%d' -|", pName(player1), VehicleNames[GetVehicleModel(GetPlayerVehicleID(player1))-400], colour1, colour2);
				SendClientMessage(playerid,BlueMsg,string);
				if(player1 != playerid)
				{
				format(string,sizeof(string),"|- Administrator \"%s\" has changed the Colour of your %s to '%d,%d'' -|", pName(playerid), VehicleNames[GetVehicleModel(GetPlayerVehicleID(player1))-400], colour1, colour2 );
				SendClientMessage(player1,blue,string);
				}
   				return ChangeVehicleColor(GetPlayerVehicleID(player1), colour1, colour2);
			}
			else return SendClientMessage(playerid,red,"ERROR: Player is not in a vehicle");
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}
*/
dcmd_countdown(playerid,params[])
{
	#pragma unused params
    if(AccInfo[playerid][Level] >= 3)
	{
	    if(CdStated == 0)
	    {
	 		new Index;
		    new tmp[256];  tmp  = strtok(params,Index);
			new tmp2[256]; tmp2 = strtok(params,Index);

			if(!strlen(tmp))
			return SendClientMessage(playerid, LIGHTBLUE2, "Usage: /countdown [Seconds] [Freeze 1/0]") &&
	   	    SendClientMessage(playerid, orange, "Function: Will create a CountDown for all Players! (1-Freeze, 0-NoFreeze)");

			cd_sec = strval(tmp);
			if(cd_sec < 1 || cd_sec > 1000)
			return SendClientMessage(playerid,COLOR_WHITE,"ERROR: Seconds between 1-1000");

			if(!strlen(tmp2))
			return SendClientMessage(playerid, LIGHTBLUE2, "Usage: /countdown [Seconds] [Freeze 1/0]") &&
	   	    SendClientMessage(playerid, orange, "Function: Will create a CountDown for all Players! (1-Freeze, 0-NoFreeze)");

			cd_f = strval(tmp2);
			if(cd_f < 0 || cd_f > 1)
			return SendClientMessage(playerid,red,"ERROR: Use only 0(NoFreeze) and 1(Freeze)!");
			CdStated = 1;
			if(cd_f == 1)
			for(new i=0;i<MAX_PLAYERS;i++)
			{
				if(IsPlayerConnected(i))
				TogglePlayerControllable(i, 0);
			}
			cd_timer = SetTimer("CountDown",1000,3);
			return 1;
		}
		else return SendClientMessage(playerid,red,"ERROR: Countdown already in Progress!");
	}
	else return ErrorMessages(playerid, 1);
}


dcmd_givecar(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 3 || IsPlayerAdmin(playerid))
	{
	    if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /givecar [PlayerID]") &&
		SendClientMessage(playerid, orange, "Function: Will give a Car for specified player");
	    new player1 = strval(params);
		new string[128];
		new playername[MAX_PLAYER_NAME];
		new adminname[MAX_PLAYER_NAME];
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
	    if(IsPlayerInAnyVehicle(player1))
	 	return SendClientMessage(playerid,red,"ERROR: Player already has a vehicle");
	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid)
		 {
			SendCommandToAdmins(playerid,"GiveCar");
			new Float:x, Float:y, Float:z;
			GetPlayerPos(player1,x,y,z);
			CarSpawner(player1,415);
			GetPlayerName(player1, playername, sizeof(playername));
			GetPlayerName(playerid, adminname, sizeof(adminname));
			format(string,sizeof(string),"|- Administrator %s has given you a car",adminname);
			SendClientMessage(player1,blue,string);
			format(string,sizeof(string),"You have given %s a car", playername);
			return SendClientMessage(playerid,BlueMsg,string);
		}
		else return ErrorMessages(playerid, 4);
	}
	else return ErrorMessages(playerid, 1);
}
//==============================================================================
// PM Command
//==============================================================================
#if EnablePM_Cmd == true
dcmd_pm(playerid,params[])
{
	new tmp[256], idx;
	tmp = strtok(params, idx);
	if(!strlen(params)) return SendClientMessage(playerid, orange, "Usage: /pm [PlayerID] [text]");
	if(!(IsPlayerConnected(PMplayer1) && PMplayer1 != INVALID_PLAYER_ID)) return SendClientMessage(playerid, red, "ERROR: Player not Connected!");
	OnPlayerPrivmsg(playerid, PMplayer1, params[strlen(tmp) + 1]);
 	return 1;
}
#endif
//==============================================================================
//==============================================================================
//Respawn all Unoccupied Vehicles
//==============================================================================

dcmd_respawncars(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][Level] >= 5 || IsPlayerAdmin(playerid))
	{
		SendClientMessage(playerid, green, "|- Your have Successfully Respawned all Vehicles! -|");
		GameTextForAll("~n~~n~~n~~n~~n~~n~~r~Vehicles ~g~Respawned!", 3000,3);

		for(new cars=0; cars<MAX_VEHICLES; cars++)
		{
			if(!VehicleOccupied(cars))
			{
				SetVehicleToRespawn(cars);
			}
		}
		return 1;
	}
	else return ErrorMessages(playerid, 1);
}

//==============================================================================
//Respawn all Vehicles
//==============================================================================
/*
dcmd_respawncars(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][Level] >= 5 || IsPlayerAdmin(playerid))
	{
		SendClientMessage(playerid, green, "|- Your have Successfully Respawned all Vehicles! -|");
		GameTextForAll("~n~~n~~n~~n~~n~~n~~r~Vehicles ~g~Respawned!", 3000,3);
		SendCommandToAdmins(playerid,"RespawnCars");
	    for(new i = 0; i < MAX_PLAYERS; i++)
		{
 			for(new v = 0; v < MAX_VEHICLES; v++)
			{
			if(!IsPlayerInVehicle(i,v))
			SetVehicleToRespawn(v);
			}
			break;
		}
		return 1;
	}
	else return ErrorMessages(playerid, 1);
}
*/
//==============================================================================

dcmd_carcolour(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
	    new Index;
	    new tmp[256];  tmp  = strtok(params,Index);
		new tmp2[256]; tmp2 = strtok(params,Index);
		new tmp3[256]; tmp3 = strtok(params,Index);

	    if(!strlen(tmp) || !strlen(tmp2) || !strlen(tmp3) || !IsNumeric(tmp2)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /carcolour [PlayerID] [Colour1] [Colour2]") &&
   	    SendClientMessage(playerid, orange, "Function: Will change vehicle colour of specified player");

		new player1 = strval(tmp), colour1, colour2, string[128];
		if(!strlen(tmp2)) colour1 = random(126);
		else colour1 = strval(tmp2);
		if(!strlen(tmp3)) colour2 = random(126);
		else colour2 = strval(tmp3);

		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
            if(IsPlayerInAnyVehicle(player1))
			{
		       	SendCommandToAdmins(playerid,"CarColour");
				format(string, sizeof(string), "|- You have Changed the colour of \"%s's\" %s to '%d,%d' -|", pName(player1), VehicleNames[GetVehicleModel(GetPlayerVehicleID(player1))-400], colour1, colour2);
				SendClientMessage(playerid,BlueMsg,string);
				if(player1 != playerid)
				{
				format(string,sizeof(string),"|- Administrator \"%s\" has changed the Colour of your %s to '%d,%d'' -|", pName(playerid), VehicleNames[GetVehicleModel(GetPlayerVehicleID(player1))-400], colour1, colour2 );
				SendClientMessage(player1,blue,string);
				}
   				return ChangeVehicleColor(GetPlayerVehicleID(player1), colour1, colour2);
			}
			else return SendClientMessage(playerid,red,"ERROR: Player is not in a vehicle");
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}
dcmd_car(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 0)
	{
		new Index;
	    new tmp[256];  tmp  = strtok(params,Index);
		new tmp2[256]; tmp2 = strtok(params,Index);
		new tmp3[256]; tmp3 = strtok(params,Index);
	    if(!strlen(tmp)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /car [ModelID/Name] [Colour1] [Colour2]") &&
   	    SendClientMessage(playerid, orange, "Function: Will create a Car with specified Colours");
		new car;
		new string[128];
		new colour1, colour2;
   		if(!IsNumeric(tmp))
	 	car = GetVehicleModelIDFromName(tmp);
  		else car = strval(tmp);
		if(car < 400 || car > 611) return  SendClientMessage(playerid, red, "ERROR: Invalid Vehicle Model ID!");
		if(!strlen(tmp2)) colour1 = random(126); else colour1 = strval(tmp2);
		if(!strlen(tmp3)) colour2 = random(126); else colour2 = strval(tmp3);

		if(AccInfo[playerid][pCar] != -1 && !IsPlayerAdmin(playerid))
		EraseVeh(AccInfo[playerid][pCar]);
		new LVehicleID;
		new Float:X,Float:Y,Float:Z;
		new Float:Angle,int1;
		GetPlayerPos(playerid, X,Y,Z);
		GetPlayerFacingAngle(playerid,Angle);
		int1 = GetPlayerInterior(playerid);
		LVehicleID = CreateVehicle(car, X+3,Y,Z, Angle, colour1, colour2, -1);
		LinkVehicleToInterior(LVehicleID,int1);
		AccInfo[playerid][pCar] = LVehicleID;
		SendCommandToAdmins(playerid,"Car");
		format(string, sizeof(string), "%s Spawned a \"%s\" (Model:%d) Colours (%d, %d), Pos: X:%0.2f, Y:%0.2f, Z:%0.2f", pName(playerid), VehicleNames[car-400], car, colour1, colour2, X, Y, Z);
        SaveIn("CarSpawns",string);
		format(string, sizeof(string), "|- You have Spawned a \"%s\" (Model: %d) with Colours: %d,%d -|", VehicleNames[car-400], car, colour1, colour2);
		return SendClientMessage(playerid,LIGHTBLUE, string);
	}
	return SendClientMessage(playerid, orange, "homo");
}
dcmd_carhealth(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
	    new Index;
	    new tmp[256];  tmp  = strtok(params,Index);
		new tmp2[256]; tmp2 = strtok(params,Index);

	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /carhealth [PlayerID] [Amount]") &&
   	    SendClientMessage(playerid, orange, "Function: Will set Car Health of specified player");
		new string[128];
		new player1 = strval(tmp);
		new health  = strval(tmp2);
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
            if(IsPlayerInAnyVehicle(player1))
			{
  			SendCommandToAdmins(playerid,"CarHealth");
			format(string, sizeof(string), "|- You have set \"%s's\" Vehicle Health to '%d -|", pName(player1), health);
			SendClientMessage(playerid,yellow,string);
			if(player1 != playerid) { format(string,sizeof(string),"|- Administrator \"%s\" has set your Vehicle's Health to '%d' -|", pName(playerid), health); SendClientMessage(player1,blue,string);
			}
			return SetVehicleHealth(GetPlayerVehicleID(player1), health);
			}
			else return SendClientMessage(playerid,red,"ERROR: Player is not in a vehicle");
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}
dcmd_linkcar(playerid,params[])
{
	#pragma unused params
	if(IsPlayerInAnyVehicle(playerid))
	{
    	LinkVehicleToInterior(GetPlayerVehicleID(playerid),GetPlayerInterior(playerid));
	    SetVehicleVirtualWorld(GetPlayerVehicleID(playerid),GetPlayerVirtualWorld(playerid));
	    return SendClientMessage(playerid,LIGHTBLUE, "|- Your vehicle is now in your Virtual World and Interior! -|");
	}
	else return SendClientMessage(playerid,red,"ERROR: You must be in a vehicle.");
 }
dcmd_god(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][Level] >= 0)
	{
    	if(AccInfo[playerid][God] == 0)
		{
   	    	AccInfo[playerid][God] = 1;
    	    SetPlayerHealth(playerid,100000);
           	SendClientMessage(playerid,green,"|- GodMod ON -|");
			return SendCommandToAdmins(playerid,"God");
			}
			else
			{
   	        AccInfo[playerid][God] = 0;
       	    SendClientMessage(playerid,red,"|- GodMod OFF -|");
        	SetPlayerHealth(playerid, 100);
		}
		return GivePlayerWeapon(playerid,35,0);
	}
	else return ErrorMessages(playerid, 6);
}

dcmd_godcar(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][Level] >= 4 || IsPlayerAdmin(playerid))
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
	    	if(AccInfo[playerid][GodCar] == 0)
			{
        		AccInfo[playerid][GodCar] = 1;
   				SendCommandToAdmins(playerid,"GodCar");
            	return SendClientMessage(playerid,green,"|- Vehicle GodMod ON -|");
				}
				else
				{
	            AccInfo[playerid][GodCar] = 0;
    	        return SendClientMessage(playerid,red,"|- Vehicle GodMod OFF -|");
				}
		}
		else return SendClientMessage(playerid,red,"ERROR: You need to be in a car to use this command");
	}
	else return ErrorMessages(playerid, 5);
}

dcmd_sgod(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][Level] >= 5 || IsPlayerAdmin(playerid))
	{
   		if(AccInfo[playerid][God] == 0)
		   {
        	AccInfo[playerid][God] = 1;
	        SetPlayerHealth(playerid,100000);
			GivePlayerWeapon(playerid,16,50000);
			GivePlayerWeapon(playerid,26,50000);
            return SendClientMessage(playerid,green,"|- GodMod ON -|");
			}
			else
			{
   	        AccInfo[playerid][God] = 0;
            SendClientMessage(playerid,red,"|- GodMod OFF -|");
	        SetPlayerHealth(playerid, 100);
			return GivePlayerWeapon(playerid,35,0);
			}
	}
	else return ErrorMessages(playerid, 9);
}

dcmd_asay(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][Level] >= 1)
	{
 		if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /asay [Text] ") &&
		SendClientMessage(playerid, orange, "Function: Will send specified message as Admin!");
		new string[128];
		format(string, sizeof(string), "|- Admin %s: %s", PlayerName2(playerid), params[0]);
		return SendClientMessageToAll(LIGHTBLUE,string);
	}
	else return ErrorMessages(playerid, 7);
}

dcmd_highlight(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 2 || IsPlayerAdmin(playerid))
	{
	    if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /highlight [PlayerID]") &&
		SendClientMessage(playerid, orange, "Function: Will Highlight the specified player! (Blinking)");
	    new player1;
		new playername[MAX_PLAYER_NAME];
		new string[128];
	    player1 = strval(params);

	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		 {
		 	GetPlayerName(player1, playername, sizeof(playername));
	 	    if(AccInfo[player1][blip] == 0) {
				SendCommandToAdmins(playerid,"HighLight");
				AccInfo[player1][pColour] = GetPlayerColor(player1);
				AccInfo[player1][blip] = 1;
				BlipTimer[player1] = SetTimerEx("HighLight", 1000, 1, "i", player1);
				format(string,sizeof(string),"|- You have Highlighted %s's marker -|", playername);
				}
				else
				{
				KillTimer( BlipTimer[player1]);
				AccInfo[player1][blip] = 0;
				SetPlayerColor(player1, AccInfo[player1][pColour]);
				format(string,sizeof(string),"|- You have Stopped Highlighting %s's marker -|", playername);
			}
			return SendClientMessage(playerid,yellow,string);
		}
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}
dcmd_getid(playerid,params[])
{
	if(!strlen(params)) return
	SendClientMessage(playerid, LIGHTBLUE2, "Usage: /getid [PartOfName] ") &&
	SendClientMessage(playerid, orange, "Function: Will see Id of specified Player");
	new found, string[128], playername[MAX_PLAYER_NAME];
	format(string,sizeof(string),"|- Searched for: \"%s\" -|",params);
	SendClientMessage(playerid,white,string);
	for(new i=0; i <= MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
	  		GetPlayerName(i, playername, MAX_PLAYER_NAME);
			new namelen = strlen(playername);
			new bool:searched=false;
	    	for(new pos=0; pos <= namelen; pos++)
			{
				if(searched != true)
				{
					if(strfind(playername,params,true) == pos)
					{
     				found++;
					format(string,sizeof(string),"%d. %s (ID: %d)",found,playername,i);
					SendClientMessage(playerid, green ,string);
					searched = true;
					}
				}
			}
		}
	}
	if(found == 0)
	SendClientMessage(playerid, LIGHTBLUE, "No Players Localized!");
	return 1;
}
dcmd_die(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][Level] >= 4 || IsPlayerAdmin(playerid))
	{
		new Float:x, Float:y, Float:z ;
		GetPlayerPos( playerid, Float:x, Float:y, Float:z );
		CreateExplosion(Float:x+10, Float:y, Float:z, 8,10.0);
		CreateExplosion(Float:x-10, Float:y, Float:z, 8,10.0);
		CreateExplosion(Float:x, Float:y+10, Float:z, 8,10.0);
		CreateExplosion(Float:x, Float:y-10, Float:z, 8,10.0);
		CreateExplosion(Float:x+10, Float:y+10, Float:z, 8,10.0);
		CreateExplosion(Float:x-10, Float:y+10, Float:z, 8,10.0);
		return CreateExplosion(Float:x-10, Float:y-10, Float:z, 8,10.0);
	}
	else return ErrorMessages(playerid, 5);
}

dcmd_serverinfo(playerid,params[])
{
	#pragma unused params
	new numo = CreateObject(1245,0,0,1000,0,0,0);
	DestroyObject(numo);
    new VehTotal = CreateVehicle(411, 0, 0, 0, 0, 0, 0, 1000);
	DestroyVehicle(VehTotal);
	new gz = GangZoneCreate(3,3,5,5);
	GangZoneDestroy(gz);
	new nump = CreatePickup(371,2,0,0,1000);
	DestroyPickup(nump);

	new nummodel;
	new model[250];
	for(new i=1;i<VehTotal;i++)
	model[GetVehicleModel(i)-400]++;
	for(new i=0;i<250;i++)
	if(model[i]!=0)	nummodel++;
	new string[256];

	SendClientMessage(playerid, green, " ");
 	SendClientMessage(playerid, green, "___________ |- Server Information -| ___________");
	SendClientMessage(playerid, green, " ");
	format(string,sizeof(string),"Player: Connected: %d || Maximum: %d  || Ratio: %0.2f",ConnectedPlayers(),GetMaxPlayers(),Float:ConnectedPlayers() / Float:GetMaxPlayers());
	SendClientMessage(playerid,white,string);
	format(string,sizeof(string),"Vehicles: Total: %d || Models: %d || In Vehicle: %d (InCar: %d | OnBike: %d)",VehTotal-1,nummodel, InVehTotal(),InCarCount(),OnBikeCount());
	SendClientMessage(playerid,white,string);
	format(string,sizeof(string),"Other: Objects: %d || Pickups: %d || Gangzones: %d",numo-1, nump, gz);
	SendClientMessage(playerid,white,string);
	format(string,sizeof(string),"Players Stats: In Jail %d || Frozen %d || Muted %d",JailedPlayers(),FrozenPlayers(), MutedPlayers());
 	SendClientMessage(playerid,white,string);
	return SendClientMessage(playerid, green, "___________________________________________");
}
dcmd_lcredits(playerid,params[])
 {
	#pragma unused params
	new string[120];
	SendClientMessage(playerid, green, " ");
 	SendClientMessage(playerid, green, "___________ |- Credits -| ___________");
	SendClientMessage(playerid, green, " ");
	format(string,sizeof(string)," L.A.S - LuX Administration System™ %s",LVersion);
	SendClientMessage(playerid,orange,string);
 	SendMessageToCMD(playerid);
	return SendClientMessage(playerid,green,"________________________________");
}
dcmd_announce2(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 2 || IsPlayerAdmin(playerid))
	{
		new Index;
        new tmp[256];  tmp  = strtok(params,Index);
		new tmp2[256]; tmp2 = strtok(params,Index);
		new tmp3[256]; tmp3 = strtok(params,Index);
	    if(!strlen(tmp)||!strlen(tmp2)||!strlen(tmp3)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /announce2 [Style (0-6)] [Time(Miliseconds)] [Text]") &&
		SendClientMessage(playerid, orange, "Function:  Will Announce the specified Message in screen for specified Time");
		if(!(strval(tmp) >= 0 && strval(tmp) <= 6) || strval(tmp) == 2)
		return SendClientMessage(playerid,red,"ERROR: Invalid Style! (0-6)");
		SendCommandToAdmins(playerid,"Announce2");
		return GameTextForAll(params[(strlen(tmp)+strlen(tmp2)+2)], strval(tmp2), strval(tmp));
    }
	else return ErrorMessages(playerid, 7);
}
dcmd_announce(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 2 || IsPlayerAdmin(playerid))
	{
    	if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /announce [Text]") &&
		SendClientMessage(playerid, orange, "Function: Will Announce the specified Message in screen");
    	SendCommandToAdmins(playerid,"Announce");
		return GameTextForAll(params,4000,3);
    }
	else return ErrorMessages(playerid, 7);
}

dcmd_duel(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
	    new Index;
 		new tmp[256];  tmp  = strtok(params,Index);
		new tmp2[256]; tmp2 = strtok(params,Index);
		new tmp3[256]; tmp3 = strtok(params,Index);

	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp) || !IsNumeric(tmp2))
		{
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /duel [PlayerID 1] [PlayerID 2] [Location (1,2,3)]");
		return SendClientMessage(playerid, orange, "Function: Will start a duel per two Players in specified Location!");
		}
		new player1 = strval(tmp);
		new player2 = strval(tmp2);
		new location, string[128];
		if(!strlen(tmp3))
		location = 0;
		else location = strval(tmp3);

		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return
		SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
		if(AccInfo[player2][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return
		SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");

		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
 		 	if(IsPlayerConnected(player2) && player2 != INVALID_PLAYER_ID)
			  {
				if(InDuel[player1] == 1) return SendClientMessage(playerid,red,"ERROR: Player One is already in a Duel!");
				if(InDuel[player2] == 1) return SendClientMessage(playerid,red,"ERROR: Player Two is already in a Duel!");

				if(location == 1) {
					SetPlayerInterior(player1,16);
					SetPlayerPos(player1,-1404.067,1270.3706,1042.8672);
					SetPlayerInterior(player2,16);
					SetPlayerPos(player2,-1395.067,1261.3706,1042.8672);
				}
				else if(location == 2) {
					SetPlayerInterior(player1,0);
					SetPlayerPos(player1,1353.407,2188.155,11.02344);
					SetPlayerInterior(player2,0);
					SetPlayerPos(player2,1346.255,2142.843,11.01563);
				}
				else if(location == 3) {
					SetPlayerInterior(player1,10);
					SetPlayerPos(player1,-1041.037,1078.729,1347.678);
					SetPlayerFacingAngle(player1,135);
					SetPlayerInterior(player2,10);
					SetPlayerPos(player2,-1018.061,1052.502,1346.327);
					SetPlayerFacingAngle(player2,45);
				}
				InDuel[player1] = 1;
				InDuel[player2] = 1;
				SendCommandToAdmins(playerid,"Duel");
				cdt[player1] = 6;
				SetTimerEx("Duel",1000,0,"dd", player1, player2);
				format(string, sizeof(string), "|- Administrator \"%s\" has started a duel Between \"%s\" and \"%s\" -|",pName(playerid),pName(player1),pName(player2));
				SendClientMessage(player1, blue, string); SendClientMessage(player2, blue, string);
				return SendClientMessage(playerid, blue, string);
 		 	}
			  else return SendClientMessage(playerid, red, "ERROR: Player Two is not connected");
		}
		else return SendClientMessage(playerid, red, "ERROR: Player One is not connected");
	}
	else return ErrorMessages(playerid, 1);
}
dcmd_lslowmo(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][Level] >= 1)
	{
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		CreatePickup(1241, 4, x, y, z);
		return SendCommandToAdmins(playerid,"LsLowMo");
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_jetpack(playerid,params[])
{
    if(!strlen(params))
	{
    	if(AccInfo[playerid][Level] >= 2 || IsPlayerAdmin(playerid))
		{
			SendClientMessage(playerid,blue,"|- Jetpack Spawned! -|");
			SendCommandToAdmins(playerid,"Jetpack");
			return SetPlayerSpecialAction(playerid, 2);
			}
			else return ErrorMessages(playerid, 1);
 			}
			else
	 		{
	    	new player1;
			new string[128];
			new playername[MAX_PLAYER_NAME];
			new adminname[MAX_PLAYER_NAME];
    		player1 = strval(params);
			if(AccInfo[playerid][Level] >= 4)
			{
		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid)
			{
				SendCommandToAdmins(playerid,"Jetpack");
				SetPlayerSpecialAction(player1, 2);
				GetPlayerName(player1, playername, sizeof(playername));
				GetPlayerName(playerid, adminname, sizeof(adminname));
				format(string,sizeof(string),"|- Administrator \"%s\" has given you a Jetpack -|",adminname);
				SendClientMessage(player1,blue,string);
				format(string,sizeof(string),"You have Given %s a Jetpack", playername);
				return SendClientMessage(playerid,BlueMsg,string);
			}
			else return ErrorMessages(playerid, 4);
			}
			else return ErrorMessages(playerid, 1);
		}
}
dcmd_destroycar(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][Level] >= 3)
	return DelVehicle(GetPlayerVehicleID(playerid));
	else return ErrorMessages(playerid, 1);
}
dcmd_tcar(playerid,params[])
{
	#pragma unused params
    if(AccInfo[playerid][Level] >= 1)
	{
		if(IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, red, "ERROR: You already have a Vehicle");

	    if(!strlen(params))
		{
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /tcar [1-10]");
		return SendClientMessage(playerid, orange, "Function: Will create a Tuned vehicle");
		}
 		//======================================================================
  		// Level 1
		//======================================================================
		if(strcmp(params,"1",true) == 0)
		{
		if(AccInfo[playerid][pCar] != -1)
		EraseVeh(AccInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,LVehicleIDt;
		GetPlayerPos(playerid,X,Y,Z);
		GetPlayerFacingAngle(playerid,Angle);
        LVehicleIDt = CreateVehicle(560,X,Y,Z,Angle,1,-1,-1);
		PutPlayerInVehicle(playerid,LVehicleIDt,0);
		SendCommandToAdmins(playerid,"LTunedCar");
		AddVehicleComponent(LVehicleIDt, 1028);	AddVehicleComponent(LVehicleIDt, 1030);	AddVehicleComponent(LVehicleIDt, 1031);	AddVehicleComponent(LVehicleIDt, 1138);	AddVehicleComponent(LVehicleIDt, 1140);  AddVehicleComponent(LVehicleIDt, 1170);
	    AddVehicleComponent(LVehicleIDt, 1028);	AddVehicleComponent(LVehicleIDt, 1030);	AddVehicleComponent(LVehicleIDt, 1031);	AddVehicleComponent(LVehicleIDt, 1138);	AddVehicleComponent(LVehicleIDt, 1140);  AddVehicleComponent(LVehicleIDt, 1170);
	    AddVehicleComponent(LVehicleIDt, 1080);	AddVehicleComponent(LVehicleIDt, 1086); AddVehicleComponent(LVehicleIDt, 1087); AddVehicleComponent(LVehicleIDt, 1010);
		StartTuneSound(playerid);
		ChangeVehiclePaintjob(LVehicleIDt,1);
	   	SetVehicleVirtualWorld(LVehicleIDt, GetPlayerVirtualWorld(playerid));
        LinkVehicleToInterior(LVehicleIDt, GetPlayerInterior(playerid));
		AccInfo[playerid][pCar] = LVehicleIDt;
		}
 		//======================================================================
  		// Level 2
		//======================================================================
		else if(strcmp(params,"2",true) == 0)
		{
		if(AccInfo[playerid][pCar] != -1)
		EraseVeh(AccInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,LVehicleIDt;
		GetPlayerPos(playerid,X,Y,Z);
		GetPlayerFacingAngle(playerid,Angle);
        LVehicleIDt = CreateVehicle(560,X,Y,Z,Angle,1,-1,-1);
		PutPlayerInVehicle(playerid,LVehicleIDt,0);
		SendCommandToAdmins(playerid,"LTunedCar");
		AddVehicleComponent(LVehicleIDt, 1028);	AddVehicleComponent(LVehicleIDt, 1030);	AddVehicleComponent(LVehicleIDt, 1031);	AddVehicleComponent(LVehicleIDt, 1138);	AddVehicleComponent(LVehicleIDt, 1140);  AddVehicleComponent(LVehicleIDt, 1170);
	    AddVehicleComponent(LVehicleIDt, 1080);	AddVehicleComponent(LVehicleIDt, 1086); AddVehicleComponent(LVehicleIDt, 1087); AddVehicleComponent(LVehicleIDt, 1010);
		StartTuneSound(playerid);
		ChangeVehiclePaintjob(LVehicleIDt,2);
	   	SetVehicleVirtualWorld(LVehicleIDt, GetPlayerVirtualWorld(playerid));
 		LinkVehicleToInterior(LVehicleIDt, GetPlayerInterior(playerid));
		AccInfo[playerid][pCar] = LVehicleIDt;
		}
 		//======================================================================
  		// Level 3
		//======================================================================
		else if(strcmp(params,"3",true) == 0)
		{
		if(AccInfo[playerid][pCar] != -1)
		EraseVeh(AccInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;
		GetPlayerPos(playerid,X,Y,Z);
		GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(559,X,Y,Z,Angle,1,-1,-1);
		PutPlayerInVehicle(playerid,carid,0);
		SendCommandToAdmins(playerid,"LTunedCar");
    	AddVehicleComponent(carid,1065); AddVehicleComponent(carid,1067); AddVehicleComponent(carid,1162);
		AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073);
		ChangeVehiclePaintjob(carid,1);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid));
  		LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		AccInfo[playerid][pCar] = carid;
		}
 		//======================================================================
  		// Level 4
		//======================================================================
		else if(strcmp(params,"4",true) == 0)
 		{
		if(AccInfo[playerid][pCar] != -1)
		EraseVeh(AccInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;
		GetPlayerPos(playerid,X,Y,Z);
		GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(565,X,Y,Z,Angle,1,-1,-1);
		PutPlayerInVehicle(playerid,carid,0);
		SendCommandToAdmins(playerid,"LTunedCar");
	    AddVehicleComponent(carid,1046);
		AddVehicleComponent(carid,1049); AddVehicleComponent(carid,1053);
		AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073);
		ChangeVehiclePaintjob(carid,1);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid));
  		LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		AccInfo[playerid][pCar] = carid;
		}
		//======================================================================
  		// Level 5
		//======================================================================
		else if(strcmp(params,"5",true) == 0)
 		{
		if(AccInfo[playerid][pCar] != -1)
		EraseVeh(AccInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;
		GetPlayerPos(playerid,X,Y,Z);
		GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(558,X,Y,Z,Angle,1,-1,-1);
		PutPlayerInVehicle(playerid,carid,0);
		SendCommandToAdmins(playerid,"LTunedCar");
    	AddVehicleComponent(carid,1088); AddVehicleComponent(carid,1092);
		AddVehicleComponent(carid,1139); AddVehicleComponent(carid,1010);
		AddVehicleComponent(carid,1073);
		ChangeVehiclePaintjob(carid,1);
 	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid));
		LinkVehicleToInterior(carid,
		GetPlayerInterior(playerid));
		AccInfo[playerid][pCar] = carid;
		}
 		//======================================================================
  		// Level 6
		//======================================================================
		else if(strcmp(params,"6",true) == 0)
 		{
		if(AccInfo[playerid][pCar] != -1)
		EraseVeh(AccInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,LVehicleIDt;
		GetPlayerPos(playerid,X,Y,Z);
		GetPlayerFacingAngle(playerid,Angle);
   		LVehicleIDt = CreateVehicle(560,X,Y,Z,Angle,1,-1,-1);
		PutPlayerInVehicle(playerid,LVehicleIDt,0);
		SendCommandToAdmins(playerid,"LTunedCar");
		AddVehicleComponent(LVehicleIDt, 1087); AddVehicleComponent(LVehicleIDt, 1010);
		AddVehicleComponent(LVehicleIDt, 1138); AddVehicleComponent(LVehicleIDt, 1170);
		AddVehicleComponent(LVehicleIDt, 1030); AddVehicleComponent(LVehicleIDt, 1028);
		AddVehicleComponent(LVehicleIDt, 1170); AddVehicleComponent(LVehicleIDt, 1031);
   		AddVehicleComponent(LVehicleIDt, 1080); AddVehicleComponent(LVehicleIDt, 1140);
		AddVehicleComponent(LVehicleIDt, 1086); AddVehicleComponent(LVehicleIDt, 1028);
		AddVehicleComponent(LVehicleIDt, 1030);	AddVehicleComponent(LVehicleIDt, 1031);
		AddVehicleComponent(LVehicleIDt, 1140); AddVehicleComponent(LVehicleIDt, 1138);
		StartTuneSound(playerid);
		ChangeVehiclePaintjob(LVehicleIDt,0);
		SetVehicleVirtualWorld(LVehicleIDt,GetPlayerVirtualWorld(playerid));
   		LinkVehicleToInterior(LVehicleIDt,GetPlayerInterior(playerid));
		AccInfo[playerid][pCar] = LVehicleIDt;
		}
 		//======================================================================
  		// Level 7
		//======================================================================
		else if(strcmp(params,"7",true) == 0)
 		{
		if(AccInfo[playerid][pCar] != -1)
		EraseVeh(AccInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;
		GetPlayerPos(playerid,X,Y,Z);
		GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(562,X,Y,Z,Angle,1,-1,-1);
		PutPlayerInVehicle(playerid,carid,0);
		SendCommandToAdmins(playerid,"LTunedCar");
	    AddVehicleComponent(carid,1034); AddVehicleComponent(carid,1038);
		AddVehicleComponent(carid,1147); AddVehicleComponent(carid,1010);
		AddVehicleComponent(carid,1073);
		ChangeVehiclePaintjob(carid,1);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid));
  		LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		AccInfo[playerid][pCar] = carid;
		}
 		//======================================================================
  		// Level 8
		//======================================================================
		else if(strcmp(params,"8",true) == 0)
 		{
		if(AccInfo[playerid][pCar] != -1)
		EraseVeh(AccInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;
		GetPlayerPos(playerid,X,Y,Z);
		GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(535,X,Y,Z,Angle,1,-1,-1);
		PutPlayerInVehicle(playerid,carid,0);
		SendCommandToAdmins(playerid,"LTunedCar");
		ChangeVehiclePaintjob(carid,1); AddVehicleComponent(carid,1109);
		AddVehicleComponent(carid,1115); AddVehicleComponent(carid,1117);
		AddVehicleComponent(carid,1073); AddVehicleComponent(carid,1010);
	    AddVehicleComponent(carid,1087); AddVehicleComponent(carid,1114);
		AddVehicleComponent(carid,1081); AddVehicleComponent(carid,1119);
		AddVehicleComponent(carid,1121);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid));
  		LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		AccInfo[playerid][pCar] = carid;
		}
 		//======================================================================
  		// Level 9
		//======================================================================
		else if(strcmp(params,"9",true) == 0)
 		{
		if(AccInfo[playerid][pCar] != -1)
		EraseVeh(AccInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;
		GetPlayerPos(playerid,X,Y,Z);
		GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(558,X,Y,Z,Angle,1,-1,-1);
		PutPlayerInVehicle(playerid,carid,0);
		SendCommandToAdmins(playerid,"LTunedCar");
   		AddVehicleComponent(carid,1092); AddVehicleComponent(carid,1166);
  		AddVehicleComponent(carid,1165); AddVehicleComponent(carid,1090);
	    AddVehicleComponent(carid,1094); AddVehicleComponent(carid,1010);
		AddVehicleComponent(carid,1087); AddVehicleComponent(carid,1163);
	    AddVehicleComponent(carid,1091);
		ChangeVehiclePaintjob(carid,2);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid));
  		LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		AccInfo[playerid][pCar] = carid;
		}
 		//======================================================================
  		// Level 10
		//======================================================================
		else if(strcmp(params,"10",true) == 0)
		{
		if(AccInfo[playerid][pCar] != -1)
		EraseVeh(AccInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;
		GetPlayerPos(playerid,X,Y,Z);
		GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(562,X,Y,Z,Angle,1,-1,-1);
		PutPlayerInVehicle(playerid,carid,0);
		SendCommandToAdmins(playerid,"LTunedCar");
  		AddVehicleComponent(carid,1034); AddVehicleComponent(carid,1038);
  		AddVehicleComponent(carid,1147); AddVehicleComponent(carid,1010);
  		AddVehicleComponent(carid,1073);
  		ChangeVehiclePaintjob(carid,0);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid));
	    LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		AccInfo[playerid][pCar] = carid;
		}
 		//======================================================================
		else
		{
  		SendClientMessage(playerid, red, "ERROR: Invalid Tuned Vehicle (1-10)");
		}
		return 1;
 	}
	else return ErrorMessages(playerid, 1);
}

//==============================================================================
// Chat Commands
//==============================================================================
dcmd_clearchat(playerid,params[])
{
    #pragma unused params
	if(AccInfo[playerid][Level] >= 2)
	{
	SendCommandToAdmins(playerid,"ClearChat");
	for(new i = 0; i < 11; i++)
	SendClientMessageToAll(green," ");
	return 1;
 	}
 	else return ErrorMessages(playerid, 7);
}
dcmd_disablechat(playerid,params[])
{
    #pragma unused params
	if(AccInfo[playerid][Level] >= 3)
	{
		SendCommandToAdmins(playerid,"DisableChat");
		new string[128];
		if(ServerInfo[DisableChat] == 0)
		{
		ServerInfo[DisableChat] = 1;
		format(string,sizeof(string),"|- Administrator \"%s\" has Disabled Chat -|", pName(playerid));
		}
	 	else
	 	{
		ServerInfo[DisableChat] = 0;
		format(string,sizeof(string),"|- Administrator \"%s\" has Enabled Chat", pName(playerid));
		}
		return SendClientMessageToAll(blue,string);
 	}
	else return ErrorMessages(playerid, 6);
}
dcmd_caps(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 3)
	{
	    new tmp [256];
		new tmp2[256];
		new Index;
		tmp  = strtok(params,Index);
		tmp2 = strtok(params,Index);

	    if(!strlen(tmp) || !strlen(tmp2) || IsNumeric(tmp2)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /caps [PlayerID] [on/off]") &&
		SendClientMessage(playerid, orange, "Function: Will enable/disable CapsLock for specified Player");

		new player1 = strval(tmp), string[128];
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
			if(strcmp(tmp2,"on",true) == 0)
			{
				SendCommandToAdmins(playerid,"Caps");
				AccInfo[player1][Caps] = 0;
				if(player1 != playerid)
				{
				format(string,sizeof(string),"|- Administrator \"%s\" has Allowed you to use CapsLock in chat -|", pName(playerid));
				SendClientMessage(playerid,blue,string);
				}
				format(string,sizeof(string),"|- You have Allowed \"%s\" to use CapsLock in Chat -|", pName(player1));
				return SendClientMessage(playerid,BlueMsg,string);
				}
				else if(strcmp(tmp2,"off",true) == 0)
				{
				SendCommandToAdmins(playerid,"Caps");
				AccInfo[player1][Caps] = 1;
				if(player1 != playerid)
				{
				format(string,sizeof(string),"|- Administrator \"%s\" has Prevented you from using CapsLock in chat -|", pName(playerid));
				SendClientMessage(playerid,blue,string);
				}
				format(string,sizeof(string),"|- You have Prevented \"%s\" from using CapsLock in chat -|", pName(player1));
				return SendClientMessage(playerid,BlueMsg,string);
				}
				else return
				SendClientMessage(playerid, LIGHTBLUE2, "Usage: /caps [PlayerID] [on/off]") &&
				SendClientMessage(playerid, orange, "Function: Will enable/disable CapsLock for specified Player");
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}
dcmd_clearallchat(playerid,params[])
{
    #pragma unused params
	if(AccInfo[playerid][Level] >= 3)
	{
	SendCommandToAdmins(playerid,"ClearAllChat");
	for(new i = 0; i < 50; i++)
 	SendClientMessageToAll(green," ");
	return 1;
 	}
	else return ErrorMessages(playerid, 5);
}
//==============================================================================
dcmd_warp(playerid,params[])
{
	return dcmd_teleplayer(playerid,params);
}
dcmd_teleplayer(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 3 || IsPlayerAdmin(playerid))
	{
		new Index;
	    new tmp[256];  tmp  = strtok(params,Index);
		new tmp2[256]; tmp2 = strtok(params,Index);

	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp) || !IsNumeric(tmp2)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /teleplayer [PlayerID] to [PlayerID]") &&
		SendClientMessage(playerid, orange, "Function: Will Teleport the specified player to the other specified player");
		new string[128];
		new player1 = strval(tmp), player2 = strval(tmp2);
		new Float:plocx,Float:plocy,Float:plocz;

		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		 {
 		 	if(IsPlayerConnected(player2) && player2 != INVALID_PLAYER_ID)
			  {
	 		 	SendCommandToAdmins(playerid,"TelePlayer");
				GetPlayerPos(player2, plocx, plocy, plocz);
				new intid = GetPlayerInterior(player2);
				SetPlayerInterior(player1,intid);
				SetPlayerVirtualWorld(player1,GetPlayerVirtualWorld(player2));
				if (GetPlayerState(player1) == PLAYER_STATE_DRIVER)
				{
				new VehicleID = GetPlayerVehicleID(player1);
				SetVehiclePos(VehicleID, plocx, plocy+4, plocz); LinkVehicleToInterior(VehicleID,intid);
				SetVehicleVirtualWorld(VehicleID, GetPlayerVirtualWorld(player2));
				}
				else SetPlayerPos(player1,plocx,plocy+2, plocz);
				format(string,sizeof(string),"|- Administrator \"%s\" has Teleported \"%s\" to \"%s's\" Position! -|", pName(playerid), pName(player1), pName(player2));
				SendClientMessage(player1,blue,string); SendClientMessage(player2,blue,string);
				format(string,sizeof(string),"You have Teleported \"%s\" to \"%s's\" Position!", pName(player1), pName(player2));
 		 	    return SendClientMessage(playerid,BlueMsg,string);
 		 	}
			  else return SendClientMessage(playerid, red, "ERROR: Player Two is not connected");
		}
		else return SendClientMessage(playerid, red, "ERROR: Player One is not connected");
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_vget(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 3 || IsPlayerAdmin(playerid))
	{
	    if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /vget [VehicleID]") &&
		SendClientMessage(playerid, orange, "Function: Will Bring the specified Vehicle to your Position");
	    new player1;
		new string[128];
	    player1 = strval(params);
		SendCommandToAdmins(playerid,"VGet");
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid,x,y,z);
		SetVehiclePos(player1,x+3,y,z);
		SetVehicleVirtualWorld(player1,GetPlayerVirtualWorld(playerid));
		format(string,sizeof(string),"|- You brought the Vehicle ID '%d' to your Position -|", player1);
		return SendClientMessage(playerid,BlueMsg,string);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_vgoto(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 2 || IsPlayerAdmin(playerid))
	{
	    if(!strlen(params)) return
    	SendClientMessage(playerid, LIGHTBLUE2, "Usage: /vgoto [VehicleID]") &&
		SendClientMessage(playerid, orange, "Function: Will Go to specified vehicle");
	    new player1;
		new string[128];
	    player1 = strval(params);
		SendCommandToAdmins(playerid,"VGoto");
		new Float:x, Float:y, Float:z;
		GetVehiclePos(player1,x,y,z);
		SetPlayerVirtualWorld(playerid,GetVehicleVirtualWorld(player1));
		if(GetPlayerState(playerid) == 2)
		{
		SetVehiclePos(GetPlayerVehicleID(playerid),x+3,y,z);
		SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), GetVehicleVirtualWorld(player1));
		}
		else SetPlayerPos(playerid,x+2,y,z);
		format(string,sizeof(string),"|- You have teleported to Vehicle ID: %d -|", player1);
		return SendClientMessage(playerid,BlueMsg,string);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_gotoid(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 2 || IsPlayerAdmin(playerid))
	{
	    if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /gotoid [PlayerID]") &&
		SendClientMessage(playerid, orange, "Function: Will Go to specified player");
	    new player1;
		new string[128];
		if(!IsNumeric(params))
		player1 = ReturnPlayerID(params);
	   	else player1 = strval(params);
	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid)
		 {
			SendCommandToAdmins(playerid,"gotoid");
			new Float:x, Float:y, Float:z;	GetPlayerPos(player1,x,y,z);
			SetPlayerInterior(playerid,GetPlayerInterior(player1));
			SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(player1));
			if(GetPlayerState(playerid) == 2)
			{
			SetVehiclePos(GetPlayerVehicleID(playerid),x+3,y,z);
			LinkVehicleToInterior(GetPlayerVehicleID(playerid),GetPlayerInterior(player1));
			SetVehicleVirtualWorld(GetPlayerVehicleID(playerid),GetPlayerVirtualWorld(player1));
			}
			else SetPlayerPos(playerid,x+2,y,z);
			format(string,sizeof(string),"|- You have Teleported to \"%s\" -|", pName(player1));
			return SendClientMessage(playerid,BlueMsg,string);
		}
		else return ErrorMessages(playerid, 4);
	}
	else return ErrorMessages(playerid, 1);
}
dcmd_lgoto(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 2 || IsPlayerAdmin(playerid))
	{
		new Float:x, Float:y, Float:z;
		new string[128], Index;
        new tmp[256];  tmp  = strtok(params,Index);
		new tmp2[256]; tmp2 = strtok(params,Index);
		new tmp3[256]; tmp3 = strtok(params,Index);
    	if(!strlen(tmp) || !strlen(tmp2) || !strlen(tmp3)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /lgoto [PosX] [PosY] [PosZ]") &&
		SendClientMessage(playerid, orange, "Function: Will Go in specified position (X,Y,Z)");
	    x = strval(tmp);
		y = strval(tmp2);
		z = strval(tmp3);
		SendCommandToAdmins(playerid,"LGoto");
		if(GetPlayerState(playerid) == 2)
		SetVehiclePos(GetPlayerVehicleID(playerid),x,y,z);
		else SetPlayerPos(playerid,x,y,z);
		format(string,sizeof(string),"|- You have teleported to - X: %f, Y: %f, Z: %f -|", x,y,z);
		return SendClientMessage(playerid,green,string);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_get(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 3|| IsPlayerAdmin(playerid))
	{
	    if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /get [PlayerID]") &&
		SendClientMessage(playerid, orange, "Function: Will get to you the specified player");
    	new player1;
		new string[128];
		if(!IsNumeric(params))
		player1 = ReturnPlayerID(params);
	   	else player1 = strval(params);
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid)
		 {
			SendCommandToAdmins(playerid,"Get");
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid,x,y,z);
			SetPlayerInterior(player1,GetPlayerInterior(playerid));
			SetPlayerVirtualWorld(player1,GetPlayerVirtualWorld(playerid));
			if(GetPlayerState(player1) == 2)
			{
   			new VehicleID = GetPlayerVehicleID(player1);
			SetVehiclePos(VehicleID,x+3,y,z);
			LinkVehicleToInterior(VehicleID,GetPlayerInterior(playerid));
			SetVehicleVirtualWorld(GetPlayerVehicleID(player1),GetPlayerVirtualWorld(playerid));
			}
			else SetPlayerPos(player1,x+2,y,z);
			format(string,sizeof(string),"|- You have been Teleported to Administrator \"%s's\" position! -|", pName(playerid));
			SendClientMessage(player1,blue,string);
			format(string,sizeof(string),"|- You have Teleported \"%s\" to your Position -|", pName(player1));
			return SendClientMessage(playerid,BlueMsg,string);
		}
		else return ErrorMessages(playerid, 4);
	}
	else return ErrorMessages(playerid, 1);
}
dcmd_move(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
	    if(!strlen(params)) return
	    SendClientMessage(playerid, LIGHTBLUE2, "Usage: /move [Up/Down/+X/-X/+Y/-Y/off]") &&
		SendClientMessage(playerid, orange, "Function: Will move you for a certain Position (Up/Down/Left/Right)");
		new Float:X, Float:Y, Float:Z;
		if(strcmp(params,"Up",true) == 0)
		{
			TogglePlayerControllable(playerid,false);
			GetPlayerPos(playerid,X,Y,Z);
			SetPlayerPos(playerid,X,Y,Z+5);
			SetCameraBehindPlayer(playerid);
			}
			else if(strcmp(params,"Down",true) == 0){
			TogglePlayerControllable(playerid,false);
			GetPlayerPos(playerid,X,Y,Z);
			SetPlayerPos(playerid,X,Y,Z-5);
			SetCameraBehindPlayer(playerid);
			}
			else if(strcmp(params,"+X",true) == 0){
			TogglePlayerControllable(playerid,false);
			GetPlayerPos(playerid,X,Y,Z);
			SetPlayerPos(playerid,X+5,Y,Z);
			}
			else if(strcmp(params,"-X",true) == 0){
			TogglePlayerControllable(playerid,false);
			GetPlayerPos(playerid,X,Y,Z);
			SetPlayerPos(playerid,X-5,Y,Z);
			}
			else if(strcmp(params,"+Y",true) == 0){
			TogglePlayerControllable(playerid,false);
			GetPlayerPos(playerid,X,Y,Z);
			SetPlayerPos(playerid,X,Y+5,Z);
			}
			else if(strcmp(params,"-Y",true) == 0){
			TogglePlayerControllable(playerid,false);
			GetPlayerPos(playerid,X,Y,Z);
			SetPlayerPos(playerid,X,Y-5,Z);
			}
		    else if(strcmp(params,"off",true) == 0){
			TogglePlayerControllable(playerid,true);
			}
			else return
			SendClientMessage(playerid, LIGHTBLUE2, "Usage: /move [Up/Down/+X/-X/+Y/-Y/off]") &&
			SendClientMessage(playerid, orange, "Function: Will move you for a certain Position (Up/Down/Left/Right)");
		return 1;
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_gethere(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 3)
	{
	    if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /gethere [PlayerID]") &&
		SendClientMessage(playerid, orange, "Function: Will get to you the specified player");
    	new player1;
    	new string[128];
		new playername[MAX_PLAYER_NAME];
		new adminname[MAX_PLAYER_NAME];
		player1 = strval(params);
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid)
		 {
			SendCommandToAdmins(playerid,"GetHere");
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid,x,y,z);
			SetPlayerInterior(player1,GetPlayerInterior(playerid));
			SetPlayerVirtualWorld(player1,GetPlayerVirtualWorld(playerid));
			if(GetPlayerState(player1) == 2)
			{
   			new VehicleID = GetPlayerVehicleID(player1);
			SetVehiclePos(VehicleID,x+3,y,z);
			LinkVehicleToInterior(VehicleID,GetPlayerInterior(playerid));
			SetVehicleVirtualWorld(GetPlayerVehicleID(player1),GetPlayerVirtualWorld(playerid));
			}
			else SetPlayerPos(player1,x+2,y,z);
			GetPlayerName(player1, playername, sizeof(playername));
			GetPlayerName(playerid, adminname, sizeof(adminname));
			format(string,sizeof(string),"|- You have been Teleported to Administrator %s's Location -|",adminname);
			SendClientMessage(player1,blue,string);
			format(string,sizeof(string),"|- You have Teleported %s to your Location -|", playername);
			return SendClientMessage(playerid,BlueMsg,string);
		}
		else return ErrorMessages(playerid, 4);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_moveplayer(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
	    new tmp [256];
		new tmp2[256];
		new Index;
		tmp  = strtok(params,Index);
		tmp2 = strtok(params,Index);

	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /moveplayer [PlayerID] [Up/Down/+X/-X/+Y/-Y/off]") &&
		SendClientMessage(playerid, orange, "Function: Will move a specified Player for a certain Position (Up/Down/Left/Right)");

	    new Float:X, Float:Y, Float:Z;
		new player1 = strval(tmp);
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
			if(strcmp(tmp2,"Up",true) == 0)
			{
				GetPlayerPos(player1,X,Y,Z); SetPlayerPos(player1,X,Y,Z+5); SetCameraBehindPlayer(player1);
				}
				else if(strcmp(tmp2,"Down",true) == 0)
				{
				GetPlayerPos(player1,X,Y,Z); SetPlayerPos(player1,X,Y,Z-5); SetCameraBehindPlayer(player1);
				}
				else if(strcmp(tmp2,"+X",true) == 0)
				{
				GetPlayerPos(player1,X,Y,Z); SetPlayerPos(player1,X+5,Y,Z);
				}
				else if(strcmp(tmp2,"-X",true) == 0)
				{
				GetPlayerPos(player1,X,Y,Z); SetPlayerPos(player1,X-5,Y,Z);
				}
				else if(strcmp(tmp2,"+Y",true) == 0)
				{
				GetPlayerPos(player1,X,Y,Z); SetPlayerPos(player1,X,Y+5,Z);
				}
				else if(strcmp(tmp2,"-Y",true) == 0)
				{
				GetPlayerPos(player1,X,Y,Z); SetPlayerPos(player1,X,Y-5,Z);
				}
				else SendClientMessage(playerid, LIGHTBLUE2, "Usage: /moveplayer [PlayerID] [Up/Down/+X/-X/+Y/-Y/off]") &&
				SendClientMessage(playerid, orange, "Function: Will move a specified Player for a certain Position (Up/Down/Left/Right)");
			return 1;
		}
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}
dcmd_warn(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 2)
	{
	    new Index;
	    new tmp[256];  tmp  = strtok(params,Index);
		new tmp2[256]; tmp2 = strtok(params,Index);

	    if(!strlen(tmp) || !strlen(tmp2)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /warn [PlayerID] [Reason]") &&
		SendClientMessage(playerid, orange, "Function: Will give a Warning in specified player");
    	new warned = strval(tmp);
		new str[128];
		if(AccInfo[warned][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
	 	if(IsPlayerConnected(warned) && warned != INVALID_PLAYER_ID)
		 {
 	    	if(warned != playerid)
			 {
			    SendCommandToAdmins(playerid,"Warn");
				AccInfo[warned][Warnings]++;
				if( AccInfo[warned][Warnings] == MAX_WARNINGS)
				{
				format(str, sizeof (str), "|- Administrator \"%s\" has kicked \"%s\". | Reason: %s (Warnings: %d/%d) -|", pName(playerid), pName(warned), params[1+strlen(tmp)], AccInfo[warned][Warnings], MAX_WARNINGS);
				SendClientMessageToAll(lightred, str);
				SaveIn("KickLog",str);
				Kick(warned);
				return AccInfo[warned][Warnings] = 0;
				}
				else
				{
				format(str, sizeof (str), "|- Administrator \"%s\" has given \"%s\" a Warning. | Reason: %s (Warnings: %d/%d) -|", pName(playerid), pName(warned), params[1+strlen(tmp)], AccInfo[warned][Warnings], MAX_WARNINGS);
				return SendClientMessageToAll(yellow, str);
				}
			}
			else return SendClientMessage(playerid, red, "ERROR: You cannot warn yourself");
		}
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_kick(playerid,params[])
{
	if(AccInfo[playerid][LoggedIn] == 1)

	{
	    if(AccInfo[playerid][Level] >= 3)
		{
      		new Index;
		    new tmp[256];  tmp  = strtok(params,Index);
			new tmp2[256]; tmp2 = strtok(params,Index);
		    if(!strlen(params)) return
			SendClientMessage(playerid, LIGHTBLUE2, "Usage: /kick [PlayerID] [Reason]") &&
			SendClientMessage(playerid, orange, "Function: Will Kick the specified player");
	    	new player1;
	    	new string[128];
			new playername[MAX_PLAYER_NAME];
		 	new adminname [MAX_PLAYER_NAME];
			player1 = strval(tmp);

		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid && (AccInfo[player1][Level] != ServerInfo[MaxAdminLevel]))
			 {
				GetPlayerName(player1, playername, sizeof(playername));
				GetPlayerName(playerid, adminname, sizeof(adminname));
				SendCommandToAdmins(playerid,"Kick");
				if(!strlen(tmp2))
				{
				format(string,sizeof(string),"|- %s has been kicked by Administrator %s | Reason: Not Specified -|",playername,adminname);
				SendClientMessageToAll(grey,string);
				SaveIn("KickLog",string);
				print(string);
				return Kick(player1);
				}
				else
				{
				format(string,sizeof(string),"|- %s has been kicked by Administrator %s | Reason: %s -|",playername,adminname,params[2]);
				SendClientMessageToAll(grey,string);
				SaveIn("KickLog",string); print(string);
				return Kick(player1);
				}
			}
			else return ErrorMessages(playerid, 3);
		}
		else return ErrorMessages(playerid, 1);
	}
	else return SendClientMessage(playerid,red,"ERROR: You must be logged in to use this commands");
}
//==============================================================================
dcmd_ban(playerid,params[])
{
	if(AccInfo[playerid][LoggedIn] == 1)
	{
		if(AccInfo[playerid][Level] >= 4)
		{
			new Index;
		    new tmp[256];  tmp  = strtok(params,Index);
			new tmp2[256]; tmp2 = strtok(params,Index);

		    if(!strlen(params)) return
			SendClientMessage(playerid, LIGHTBLUE2, "Usage: /ban [PlayerID] [Reason]") &&
			SendClientMessage(playerid, orange, "Function: Will Ban the specified player");
			if(!strlen(tmp2))
			return SendClientMessage(playerid, red, "ERROR: Reason unspecified!");
			new player1;
	    	new string[128];
			new playername[MAX_PLAYER_NAME];
		 	new adminname [MAX_PLAYER_NAME];
			player1 = strval(tmp);

		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid && (AccInfo[player1][Level] != ServerInfo[MaxAdminLevel]))
			{
				GetPlayerName(player1, playername, sizeof(playername));
				GetPlayerName(playerid, adminname, sizeof(adminname));
				new year,month,day; getdate(year, month, day);
				new hour,minuite,second; gettime(hour,minuite,second);
				SendCommandToAdmins(playerid,"Ban");
				format(string,sizeof(string),"|- %s has been Banned by Administrator %s | Reason: %s [Date: %d/%d/%d] [Time: %d:%d]",playername,adminname,params[2],day,month,year,hour,minuite);
				SendClientMessageToAll(lightred,string);
    			new str[128];
				format(str,sizeof(str),"%s has been Banned by Administrator %s | Reason: %s",playername,adminname,params[2]);
				SaveIn("BanLog",str);
				print(string);
				if(udb_Exists(PlayerName2(player1)) && AccInfo[player1][LoggedIn] == 1)
				dUserSetINT(PlayerName2(player1)).("Banned",1);
				format(string,sizeof(string),"Banned by Administrator %s. | Reason: %s",adminname,params[2]);
				return BanEx(player1, string);
			}
			else return SendClientMessage(playerid, red, "ERRPR: Player is not connected or is yourself or is the highest level admin");
		}
		else return ErrorMessages(playerid, 1);
	}
	else return SendClientMessage(playerid,red,"ERROR: You must be logged in to use this commands");
}
dcmd_fu(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 2)
	{
	    if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /warn [PlayerID] [Reason]") &&
		SendClientMessage(playerid, orange, "Function: Will f*ck the specified player");
    	new player1 = strval(params);
		new NewName[MAX_PLAYER_NAME];
		new string[128];
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		 {
			SendCommandToAdmins(playerid,"Fu");

			SetPlayerArmour(player1,0.0);    SetPlayerColor(player1,COLOR_PINK);
			SetPlayerHealth(player1,1.0);    ResetPlayerMoney(player1);
			ResetPlayerWeapons(player1);     GivePlayerWeapon(player1,12,1);
			SetPlayerWantedLevel(player1,6); SetPlayerSkin(player1, 137);
			SetPlayerScore(player1, 0);      SetPlayerWeather(player1,19);

			format(NewName,sizeof(NewName),"[N00B]%s", pName(player1));
			SetPlayerName(player1,NewName);
			if(IsPlayerInAnyVehicle(player1))
			DelVehicle(GetPlayerVehicleID(player1));

			if(player1 != playerid)
			{
			format(string,sizeof(string),"~w~%s: ~r~Fuck You!", pName(playerid));
			GameTextForPlayer(player1, string, 2500, 3);
			}
			format(string,sizeof(string),"Fuck you \"%s\"", pName(player1));
			return SendClientMessage(playerid,blue,string);
		}
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}
dcmd_rban(playerid,params[])
{
	if(AccInfo[playerid][LoggedIn] == 1)
	{
		if(AccInfo[playerid][Level] >= 4)
		{
		    new ip[128], Index;
		    new tmp[256];  tmp  = strtok(params,Index);
			new tmp2[256]; tmp2 = strtok(params,Index);

		    if(!strlen(params)) return
			SendClientMessage(playerid, LIGHTBLUE2, "Usage: /rban [PlayerID] [Reason]") &&
			SendClientMessage(playerid, orange, "Function: Will Range Ban the specified player");
			if(!strlen(tmp2)) return
			SendClientMessage(playerid, red, "ERROR: Reason unspecified!");
			new player1;
	    	new string[128];
			new playername[MAX_PLAYER_NAME];
		 	new adminname [MAX_PLAYER_NAME];
			player1 = strval(tmp);

		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid && (AccInfo[player1][Level] != ServerInfo[MaxAdminLevel]))
			 {
				GetPlayerName(player1, playername, sizeof(playername));
				GetPlayerName(playerid, adminname, sizeof(adminname));
				new year,month,day; getdate(year, month, day);
				new hour,minuite,second; gettime(hour,minuite,second);
				SendCommandToAdmins(playerid,"RBan");
				format(string,sizeof(string),"|- %s has been Range Banned by Administrator %s | Reason: %s [Date: %d/%d/%d] [Time: %d:%d] -|",playername,adminname,params[2],day,month,year,hour,minuite);
				SendClientMessageToAll(lightred,string);
    			new str[128];
				format(str,sizeof(str),"%s has been Range Banned by Administrator %s | Reason: %s",playername,adminname,params[2]);
				SaveIn("BanLog",str);
				print(string);
				if(udb_Exists(PlayerName2(player1)) && AccInfo[player1][LoggedIn] == 1)
				dUserSetINT(PlayerName2(player1)).("Banned",1);
				GetPlayerIp(player1,ip,sizeof(ip));
	            strdel(ip,strlen(ip)-2,strlen(ip));
    	        format(ip,128,"%s**",ip);
				format(ip,128,"banip %s",ip);
            	SendRconCommand(ip);
				return 1;
			}
			else return ErrorMessages(playerid, 3);
		}
		else return ErrorMessages(playerid, 1);
	}
	else return SendClientMessage(playerid,red,"ERROR: You must be logged in to use this commands");
}
dcmd_forbidname(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 4)
	{
		if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /forbidname [Name]") &&
		SendClientMessage(playerid, orange, "Function: Will block a specified Name");
		new File:BLfile, string[128];
		BLfile = fopen("LuxAdmin/Config/ForbiddenNames.cfg",io_append);
		format(string,sizeof(string),"%s\r\n",params[1]);
		fwrite(BLfile,string);
		fclose(BLfile);
		UpdateConfig();
		SendCommandToAdmins(playerid,"ForbidName");
		format(string, sizeof(string), "|- Administrator \"%s\" has added the Name \"%s\" to the Bad Name List", pName(playerid), params);
		return MessageToAdmins(green,string);
	}
	else return ErrorMessages(playerid, 5);
}

dcmd_forbidword(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 4)
	{
		if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /forbidword [Word]") &&
		SendClientMessage(playerid, orange, "Function: Will block a specified Word");
		new File:BLfile, string[128];
		BLfile = fopen("LuxAdmin/Config/ForbiddenWords.cfg",io_append);
		format(string,sizeof(string),"%s\r\n",params[1]);
		fwrite(BLfile,string);
		fclose(BLfile);
		UpdateConfig();
		SendCommandToAdmins(playerid,"ForbidWord");
		format(string, sizeof(string), "|- Administrator \"%s\" has added the Word \"%s\" to the Bad Word List -|", pName(playerid), params);
		return MessageToAdmins(green,string);
	}
	else return ErrorMessages(playerid, 5);
}
dcmd_explode(playerid,params[])
{
	if(AccInfo[playerid][LoggedIn] == 1)
	{
		if(AccInfo[playerid][Level] >= 3)
		{
			new Index;
		    new tmp[256];  tmp  = strtok(params,Index);
			new tmp2[256]; tmp2 = strtok(params,Index);

		    if(!strlen(params)) return
			SendClientMessage(playerid, LIGHTBLUE2, "Usage: /explode [PlayerID] [Reason]") &&
			SendClientMessage(playerid, orange, "Function: Will Explode the specified player");
	    	new player1;
	    	new string[128];
			new playername[MAX_PLAYER_NAME];
		 	new adminname [MAX_PLAYER_NAME];
			player1 = strval(tmp);

		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && (AccInfo[player1][Level] != ServerInfo[MaxAdminLevel]))
			 {
				GetPlayerName(player1, playername, sizeof(playername));
				GetPlayerName(playerid, adminname, sizeof(adminname));
				SendCommandToAdmins(playerid,"Explode");
				new Float:burnx, Float:burny, Float:burnz;
				GetPlayerPos(player1,burnx, burny, burnz);
				CreateExplosion(burnx, burny , burnz, 7,10.0);

				if(strlen(tmp2))
				{
				format(string,sizeof(string),"|- You have been exploded by Administrator %s | Reason: %s -|",adminname,params[2]);
				SendClientMessage(player1,blue,string);
				format(string,sizeof(string),"|- You have exploded %s | Reason: %s -|", playername,params[2]);
				return SendClientMessage(playerid,BlueMsg,string);
				}
				else
				{
				format(string,sizeof(string),"|- You have been exploded by Administrator %s | Reason: Not Specified! -|",adminname);
				SendClientMessage(player1,blue,string);
				format(string,sizeof(string),"|- You have Exploded %s -|", playername);
				return SendClientMessage(playerid,BlueMsg,string);
				}
			}
			else return SendClientMessage(playerid, red, "ERROR: Player is not connected or is the highest level admin");
		}
		else return ErrorMessages(playerid, 1);
	}
	else return SendClientMessage(playerid,red,"ERROR: You must be logged in to use this commands");
}

dcmd_jail(playerid,params[])
{
	if(AccInfo[playerid][LoggedIn] == 1)
	{
		if(AccInfo[playerid][pVip] >= 1)
		{
			new Index;
		    new tmp[256];  tmp  = strtok(params,Index);
			new tmp2[256]; tmp2 = strtok(params,Index);
			new tmp3[256]; tmp3 = strtok(params,Index);

		    if(!strlen(params)) return
			SendClientMessage(playerid, LIGHTBLUE2, "Usage: /jail [PlayerID] [Minutes] [Reason]") &&
			SendClientMessage(playerid, orange, "Function: Will Jailed the specified player");
	    	new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);

		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && (AccInfo[player1][Level]))
			 {
				if(AccInfo[player1][Jailed] == 0)
				{
					GetPlayerName(player1, playername, sizeof(playername));
					GetPlayerName(playerid, adminname, sizeof(adminname));
					new jtime = strval(tmp2);
					if(jtime == 0) jtime = 9999;

			       	SendCommandToAdmins(playerid,"Jail");
					AccInfo[player1][JailTime] = jtime*1000*60;
    			    SetTimerEx("JailPlayer",5000,0,"d",player1);
		    	    SetTimerEx("Jail1",1000,0,"d",player1);
		        	AccInfo[player1][Jailed] = 1;

					if(jtime == 9999)
					{
					if(!strlen(params[strlen(tmp2)+1])) format(string,sizeof(string),"|- Officers %s has Jailed %s -|",adminname,playername);
					else format(string,sizeof(string),"|- Officers %s has Jailed %s | Reason: %s -|",adminname,playername,params[strlen(tmp)+1]);
   					}
				    else
				    {
					if(!strlen(tmp3)) format(string,sizeof(string),"|- Officers %s has Jailed %s for %d Minutes -|",adminname,playername, jtime);
					else format(string,sizeof(string),"|- Officers %s has Jailed %s for %d Minutes | Reason: %s -|",adminname,playername,jtime,params[strlen(tmp2)+strlen(tmp)+1]);
					}
	    			return SendClientMessageToAll(blue,string);
				}
				else return SendClientMessage(playerid, red, "ERROR: Player is already in jail");
			}
			else return SendClientMessage(playerid, red, "ERROR: Invalid Playerid");
		}
		else return SendClientMessage(playerid, red, "ERROR: Your Are Not an Officers");
	}
	else return SendClientMessage(playerid,red,"ERROR: You must be logged in to use this commands");
}

dcmd_unjail(playerid,params[])
{
	if(AccInfo[playerid][LoggedIn] == 1)
	{
		if(AccInfo[playerid][pVip] >= 0)
		{
		    new tmp[256];
			new Index;
			tmp = strtok(params,Index);

		    if(!strlen(params)) return
			SendClientMessage(playerid, LIGHTBLUE2, "Usage: /unjail [PlayerID]") &&
			SendClientMessage(playerid, orange, "Function: Will Unjailed the specified player");
	    	new player1;
			new string[128];
			new playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME];
			player1 = strval(tmp);

		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && (AccInfo[player1][Level]))
			 {
				if(AccInfo[player1][Jailed] == 1)
				{
					GetPlayerName(player1, playername, sizeof(playername));
					GetPlayerName(playerid, adminname, sizeof(adminname));
					format(string,sizeof(string),"|- Officers %s has Unjailed you -|",adminname);
					SendClientMessage(player1,blue,string);
					format(string,sizeof(string),"|- Officers %s has Unjailed %s -|",adminname, playername);
					UnjailPlayer(player1);
					return SendClientMessageToAll(blue,string);
				}
				else return SendClientMessage(playerid, red, "ERROR: Player is not in jail");
			}
			else return SendClientMessage(playerid, red, "ERROR: Invalid Playerid");
		}
		else return SendClientMessage(playerid, red, "ERROR: Your Are Not an Officers");
	}
	else return SendClientMessage(playerid,red,"ERROR: You must be logged in to use this commands");
}

dcmd_freeze(playerid,params[])
{
	if(AccInfo[playerid][LoggedIn] == 1)
	{
		if(AccInfo[playerid][Level] >= 3)
		{
		    new tmp[256],tmp2[256],tmp3[256],Index;
			tmp  = strtok(params,Index);
			tmp2 = strtok(params,Index);
			tmp3 = strtok(params,Index);

		    if(!strlen(params)) return
			SendClientMessage(playerid, LIGHTBLUE2, "Usage: /freeze [PlayerID]") &&
			SendClientMessage(playerid, orange, "Function: Will Freeze the specified player");
	    	new player1;
			new string[128];
			new playername[MAX_PLAYER_NAME];
			new adminname[MAX_PLAYER_NAME];

			player1 = ReturnUser(tmp, playerid);
		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
			 {
				if(AccInfo[player1][Frozen] == 0)
				{
					GetPlayerName(player1, playername, sizeof(playername));
					GetPlayerName(playerid, adminname, sizeof(adminname));
					new ftime = strval(tmp2);
					if(ftime == 0) ftime = 9999;

			       	SendCommandToAdmins(playerid,"Freeze");
					TogglePlayerControllable(player1,false); AccInfo[player1][Frozen] = 1;
					PlayerPlaySound(player1,1057,0.0,0.0,0.0);
					AccInfo[player1][FreezeTime] = ftime*1000*60;
			        FreezeTimer[player1] = SetTimerEx("UnFreezeMe",AccInfo[player1][FreezeTime],0,"d",player1);

					if(ftime == 9999)
					{
					if(!strlen(params[strlen(tmp2)+1]))
					format(string,sizeof(string),"|- Administrator %s has Frozen %s -|",adminname,playername);
					else format(string,sizeof(string),"|- Administrator %s has Frozen %s | Reason: %s -|",adminname,playername,params[strlen(tmp)+1]);
	   				}
 				    else
				    {
					if(!strlen(tmp3)) format(string,sizeof(string),"|- Administrator %s has Frozen %s for %d Minutes",adminname,playername,ftime);
					else format(string,sizeof(string),"|- Administrator %s has Frozen %s for %d Minutes | Reason: %s",adminname,playername,ftime,params[strlen(tmp2)+strlen(tmp)+1]);
					}
		    		return SendClientMessageToAll(blue,string);
				}
				else return SendClientMessage(playerid, red, "ERROR: Player is already Frozen");
			}
			else return SendClientMessage(playerid, red, "ERROR: Player is not connected or is the highest level admin");
		}
		else return ErrorMessages(playerid, 1);
	}
	else return SendClientMessage(playerid,red,"ERROR: You must be logged in to use this commands");
}

dcmd_unfreeze(playerid,params[])
{
	if(AccInfo[playerid][LoggedIn] == 1)
	{
	    if(AccInfo[playerid][Level] >= 3|| IsPlayerAdmin(playerid))
		{
		    if(!strlen(params)) return
			SendClientMessage(playerid, LIGHTBLUE2, "Usage: /unfreeze [PlayerID]") &&
			SendClientMessage(playerid, orange, "Function: Will unfreeze the specified player");
	    	new player1, string[128];
			player1 = strval(params);

		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
			 {
		 	    if(AccInfo[player1][Frozen] == 1)
				{
    			SendCommandToAdmins(playerid,"Unfreeze");
				UnFreezeMe(player1);
				format(string,sizeof(string),"|- Administrator %s has Unfrozen you -|", PlayerName2(playerid));
				SendClientMessage(player1,blue,string);
				format(string,sizeof(string),"|- Administrator %s has Unfrozen %s -|", PlayerName2(playerid), PlayerName2(player1));
   				return SendClientMessageToAll(blue,string);
				}
				else return SendClientMessage(playerid, red, "ERROR: Player is not Frozen");
			}
			else return SendClientMessage(playerid, red, "ERROR: Player is not connected or is the highest level admin");
		}
		else return ErrorMessages(playerid, 1);
	}
	else return SendClientMessage(playerid,red,"ERROR: You must be logged in to use this commands");
}


//==============================================================================
// Wanted Level List
//==============================================================================
dcmd_wanted(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][LoggedIn] == 1)
	{
		if(AccInfo[playerid][pVip] >= 0)
		{
		    new
				InWanted,
				string[64],
				playername[MAX_PLAYER_NAME],
				pWanted;

		    for(new i=0;i<MAX_PLAYERS;i++)
		    {
		        if(IsPlayerConnected(i) && GetPlayerWantedLevel(i) >= 1)
		        {
		            if(InWanted == 0)
		            {
       				 	SendClientMessage(playerid, yellow, "___________ |- Wanted Players (List) -| ___________");
      					InWanted = 1;
		            }
					pWanted = GetPlayerWantedLevel(i);
		            GetPlayerName(i, playername, sizeof(playername));
		            format(string, sizeof(string), "Player: %s(%d) - Wanted Level: %d", playername,i, pWanted);
	             	SendClientMessage(playerid, 0xD9954EAA, string);
          		}
   			}
		    if(InWanted == 0)
		    {
  	 	 	SendClientMessage(playerid, red, "|-No players have WantedLevel! -|");
  	 	 	}
  	 	 	return 1;
   		}
   		else return ErrorMessages(playerid, 1);
	}
	else return SendClientMessage(playerid,red,"ERROR: You must be logged in to use this commands");
}


dcmd_jailed(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][LoggedIn] == 1)
	{
		if(AccInfo[playerid][pVip] >= 0)
		{
	 		new bool:First2 = false;
	 		new Count, i;
		    new string[128];
			new adminname[MAX_PLAYER_NAME];
		    for(i = 0; i < MAX_PLAYERS; i++)
			if(IsPlayerConnected(i) && AccInfo[i][Jailed])
			Count++;
			if(Count == 0)
			return SendClientMessage(playerid,red, "No players are Jailed!");

		    for(i = 0; i < MAX_PLAYERS; i++)
			if(IsPlayerConnected(i) && AccInfo[i][Jailed])
			{
 			GetPlayerName(i, adminname, sizeof(adminname));
			if(!First2)
			{
			format(string, sizeof(string), "Jailed Players: (%d)%s", i,adminname); First2 = true;
			}
   			else format(string,sizeof(string),"%s, (%d)%s ",string,i,adminname);
	        }
		    return SendClientMessage(playerid,yellow,string);
		}
		else return ErrorMessages(playerid, 1);
	}
	else return SendClientMessage(playerid,red,"ERROR: You must be logged in to use this commands");
}

dcmd_viplist(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][LoggedIn] == 1)
	{
		if(AccInfo[playerid][Level] >= 1)
		{
	 		new bool:First2 = false;
	 		new Count, i;
		    new string[128];
			new adminname[MAX_PLAYER_NAME];
		    for(i = 0; i < MAX_PLAYERS; i++)
			if(IsPlayerConnected(i) && AccInfo[i][pVip] > 0)
			Count++;

			if(Count == 0)
			return SendClientMessage(playerid,red, "No players have VIP Account!");

		    for(i = 0; i < MAX_PLAYERS; i++)
			if(IsPlayerConnected(i) && AccInfo[i][pVip] > 0)
			{
				if(AccInfo[i][pVip] > 0)
				{
					switch(AccInfo[i][pVip])
    				{
					case 1: AccType = "Silver";
					case 2: AccType = "Gold";
					case 3: AccType = "Platinum";
					}
				}
 				GetPlayerName(i, adminname, sizeof(adminname));
				if(!First2)
				{
					format(string, sizeof(string), "VIP Players: %d(%s)", i,AccType);
					First2 = true;
				}
   					else format(string,sizeof(string),"%s, %d(%s)",string,i,AccType);
	        }
		    return SendClientMessage(playerid,yellow,string);
		}
		else return ErrorMessages(playerid, 1);
	}
	else return SendClientMessage(playerid,red,"ERROR: You must be logged in to use this commands");
}

dcmd_frozen(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][LoggedIn] == 1)
	{
		if(AccInfo[playerid][Level] >= 2)
		{
	 		new bool:First2 = false;
			new Count,string[128], i;
			new adminname[MAX_PLAYER_NAME];

		    for(i = 0; i < MAX_PLAYERS; i++)
			if(IsPlayerConnected(i) && AccInfo[i][Frozen])
			Count++;
			if(Count == 0)
			return SendClientMessage(playerid,red, "No players are Frozen!");

		    for(i = 0; i < MAX_PLAYERS; i++)
			if(IsPlayerConnected(i) && AccInfo[i][Frozen])
			{
	    		GetPlayerName(i, adminname, sizeof(adminname));
				if(!First2)
				{
				format(string, sizeof(string), "Frozen Players: (%d)%s", i,adminname);
				First2 = true;
				}
		        else format(string,sizeof(string),"%s, (%d)%s ",string,i,adminname);
	        }
		    return SendClientMessage(playerid,yellow,string);
		}
		else return ErrorMessages(playerid, 1);
	}
	else return SendClientMessage(playerid,red,"ERROR: You must be logged in to use this commands");
}

dcmd_muted(playerid,params[])
{
	#pragma unused params
	if(AccInfo[playerid][LoggedIn] == 1)
	{
		if(AccInfo[playerid][Level] >= 2)
		{
	 		new bool:First2 = false, Count, adminname[MAX_PLAYER_NAME], string[128], i;
		    for(i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && AccInfo[i][Muted]) Count++;
			if(Count == 0) return SendClientMessage(playerid,red, "ERROR: No players are Muted!");

		    for(i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && AccInfo[i][Muted])
			{
 			GetPlayerName(i, adminname, sizeof(adminname));
			if(!First2)
			{
			format(string, sizeof(string), "Muted Players: (%d)%s", i,adminname);
			First2 = true;
			}
  			else format(string,sizeof(string),"%s, (%d)%s ",string,i,adminname);
	        }
		    return SendClientMessage(playerid,yellow,string);
		}
		else return ErrorMessages(playerid, 1);
	}
	else return SendClientMessage(playerid,red,"ERROR: You must be logged in to use this commands");
}

dcmd_mute(playerid,params[])
{
	if(AccInfo[playerid][LoggedIn] == 1)
	{
		if(AccInfo[playerid][Level] >= 2)
		{
		    new tmp[256];
			new tmp2[256];
			new Index;
			tmp = strtok(params,Index);
			tmp2 = strtok(params,Index);
		    if(!strlen(params)) return
			SendClientMessage(playerid, LIGHTBLUE2, "Usage: /mute [PlayerID] [Reason]") &&
			SendClientMessage(playerid, orange, "Function: Will mute the specified player");
			new playername[MAX_PLAYER_NAME];
			new adminname [MAX_PLAYER_NAME];
	    	new player1, string[128];
			player1 = strval(tmp);
		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && (AccInfo[player1][Level] != ServerInfo[MaxAdminLevel]) )
			 {
		 	    if(AccInfo[player1][Muted] == 0)
		 	    {
					GetPlayerName(player1, playername, sizeof(playername));
					GetPlayerName(playerid, adminname, sizeof(adminname));
					SendCommandToAdmins(playerid,"Mute");
					PlayerPlaySound(player1,1057,0.0,0.0,0.0);
					AccInfo[player1][Muted] = 1;
					AccInfo[player1][MuteWarnings] = 0;
					if(strlen(tmp2))
					{
					format(string,sizeof(string),"|- You have been Muted by Administrator %s | Reason: %s -|",adminname,params[2]);
					SendClientMessage(player1,blue,string);
					format(string,sizeof(string),"|-  You have Muted %s | Reason: %s -|", playername,params[2]);
					return SendClientMessage(playerid,BlueMsg,string);
					}
					else
					{
					format(string,sizeof(string),"|- You have been muted by Administrator %s | No Specified Reason! -|",adminname);
					SendClientMessage(player1,blue,string);
					format(string,sizeof(string),"|- You have Muted %s -|", playername);
					return SendClientMessage(playerid,BlueMsg,string);
					}
				}
				else return SendClientMessage(playerid, red, "ERROR: Player is already muted");
			}
			else return SendClientMessage(playerid, red, "ERROR: Player is not connected or is the highest level admin");
		}
		else return ErrorMessages(playerid, 1);
	}
	else return SendClientMessage(playerid,red,"ERROR: You must be logged in to use this commands");
}

dcmd_unmute(playerid,params[])
{
	if(AccInfo[playerid][LoggedIn] == 1)
	{
		if(AccInfo[playerid][Level] >= 2)
		{
		    if(!strlen(params)) return
			SendClientMessage(playerid, LIGHTBLUE2, "Usage: /unmute [PlayerID]") &&
			SendClientMessage(playerid, orange, "Function: Will unmute the specified player");
	    	new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(params);
		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && (AccInfo[player1][Level] != ServerInfo[MaxAdminLevel]))
			 {
		 	    if(AccInfo[player1][Muted] == 1)
				 {
					GetPlayerName(player1, playername, sizeof(playername));
					GetPlayerName(playerid, adminname, sizeof(adminname));
					SendCommandToAdmins(playerid,"Unmute");
					PlayerPlaySound(player1,1057,0.0,0.0,0.0);
					AccInfo[player1][Muted] = 0;
					AccInfo[player1][MuteWarnings] = 0;
					format(string,sizeof(string),"|- You have been Unmuted by Administrator %s -|",adminname);
					SendClientMessage(player1,blue,string);
					format(string,sizeof(string),"|- You have unmuted %s -|", playername);
					return SendClientMessage(playerid,BlueMsg,string);
				}
				else return SendClientMessage(playerid, red, "ERROR: Player is not muted!");
			}
			else return SendClientMessage(playerid, red, "ERROR: Player is not connected or is the highest level admin");
		}
		else return ErrorMessages(playerid, 1);
	}
	else return SendClientMessage(playerid,red,"ERROR: You must be logged in to use this commands");
}
dcmd_slap(playerid,params[])
{
	if(AccInfo[playerid][LoggedIn] == 1)
	{
		if(AccInfo[playerid][Level] >= 2)
		{
			new Index;
		    new tmp[256];  tmp  = strtok(params,Index);
			new tmp2[256]; tmp2 = strtok(params,Index);

		    if(!strlen(params)) return
			SendClientMessage(playerid, LIGHTBLUE2, "Usage: /slap [PlayerID/PartOfName] [Reason]") &&
			SendClientMessage(playerid, orange, "Function: Will Slap the specified player");
  			new player1;
	    	new string[128];
			new playername[MAX_PLAYER_NAME];
		 	new adminname [MAX_PLAYER_NAME];
			player1 = strval(tmp);

		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && (AccInfo[player1][Level] != ServerInfo[MaxAdminLevel]))
			 {
				GetPlayerName(player1, playername, sizeof(playername));
				GetPlayerName(playerid, adminname, sizeof(adminname));
				SendCommandToAdmins(playerid,"Slap");
		        new Float:Health;
				new Float:x, Float:y, Float:z;
				GetPlayerHealth(player1,Health);
				SetPlayerHealth(player1,Health-25);
				GetPlayerPos(player1,x,y,z);
				SetPlayerPos(player1,x,y,z+5);
				PlayerPlaySound(playerid,1190,0.0,0.0,0.0);
				PlayerPlaySound(player1,1190,0.0,0.0,0.0);

				if(strlen(tmp2))
				{
				format(string,sizeof(string),"|- You have been Slapped by Administrator %s | Reason: %s -|",adminname,params[2]);
				SendClientMessage(player1,red,string);
				format(string,sizeof(string),"|- You have slapped %s | Reason: %s -|",playername,params[2]);
				return SendClientMessage(playerid,BlueMsg,string);
				}
				else
				{
				format(string,sizeof(string),"|- You have been slapped by Administrator %s | Reason: Not Specified -|",adminname);
				SendClientMessage(player1,red,string);
				format(string,sizeof(string),"|- You have slapped %s -|",playername);
				return SendClientMessage(playerid,BlueMsg,string);
				}
			}
			else return SendClientMessage(playerid, red, "ERROR: Player is not connected or is the highest level admin");
		}
		else return ErrorMessages(playerid, 1);
	}
	else return SendClientMessage(playerid,red,"ERROR: You must be logged in to use this commands");
}
dcmd_akill(playerid,params[])
{
	if(AccInfo[playerid][LoggedIn] == 1)
	{
	    if(AccInfo[playerid][Level] >= 3|| IsPlayerAdmin(playerid))
		{
		    if(!strlen(params)) return
			SendClientMessage(playerid, LIGHTBLUE2, "Usage: /akill [PlayerID]") &&
			SendClientMessage(playerid, orange, "Function: Will Kill a specified player");
	    	new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(params);

		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		  	{
				if((AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel]))
				return SendClientMessage(playerid, red, "ERROR: You cannot akill the highest level admin");
				SendCommandToAdmins(playerid,"AKIll");
				GetPlayerName(player1, playername, sizeof(playername));
				GetPlayerName(playerid, adminname, sizeof(adminname));
				format(string,sizeof(string),"|- Administrator %s has Killed you -|",adminname);
				SendClientMessage(player1,blue,string);
				format(string,sizeof(string),"|- You have Killed %s -|",playername);
   				SendClientMessage(playerid,BlueMsg,string);
				return SetPlayerHealth(player1,0.0);
			}
			else return ErrorMessages(playerid, 2);
		}
		else return ErrorMessages(playerid, 1);
	}
	else return SendClientMessage(playerid,red,"ERROR: You must be logged in to use this commands");
}
dcmd_aka(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 3 || IsPlayerAdmin(playerid))
	{
	    if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /aka [PlayerID]") &&
		SendClientMessage(playerid, orange, "Function: Will see other names used per specified player (AKA)");
    	new player1, playername[MAX_PLAYER_NAME], str[128], pIP[50];
		player1 = strval(params);
	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		 {
  		  	GetPlayerIp(player1,pIP,50);
			GetPlayerName(player1, playername, sizeof(playername));
			format(str,sizeof(str),"|- %s's AKA -|", playername);
   	        SendClientMessage(playerid,blue,str);
		    format(str,sizeof(str),"|- Id: %d | Ip: %s | Names: %s -|", player1, pIP, dini_Get("LuxAdmin/Config/aka.txt",pIP));
	        return SendClientMessage(playerid,blue,str);
		}
		else return SendClientMessage(playerid, red, "Player is not connected or is yourself");
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_screen(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 2)
	{
	    new tmp [256];
		new tmp2[256], Index;
		tmp  = strtok(params,Index);
		tmp2 = strtok(params,Index);
	    if(!strlen(params)) return
  		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /screen [PlayerID] [Text]") &&
		SendClientMessage(playerid, orange, "Function: Will sending a Text in screen for specified Player");
    	new playername[MAX_PLAYER_NAME];
		new adminname [MAX_PLAYER_NAME], player1;
		new string[128];
		player1 = strval(params);

	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid && (AccInfo[player1][Level] != ServerInfo[MaxAdminLevel]))
		 {
			GetPlayerName(player1, playername, sizeof(playername));
			GetPlayerName(playerid, adminname, sizeof(adminname));
			SendCommandToAdmins(playerid,"Screen");
			format(string,sizeof(string),"|- Administrator %s has Sent you a Screen Message -|",adminname);
			SendClientMessage(player1,blue,string);
			format(string,sizeof(string),"|- You have sent %s a Screen Message: %s -|", playername, params[2]);
			SendClientMessage(playerid,BlueMsg,string);
			return GameTextForPlayer(player1, params[2],4000,3);
		}
		else return ErrorMessages(playerid, 3);
	}
	else return ErrorMessages(playerid, 1);
}
dcmd_laston(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 2)
	{
	    new player1;
        new playername[MAX_PLAYER_NAME];
		new adminname [MAX_PLAYER_NAME];
		new str[128];
		new file[256];
 	    new tmp2[256];
		GetPlayerName(playerid, adminname, sizeof(adminname));
	    if(!strlen(params))
		{
		format(file,sizeof(file),"/LuxAdmin/Accounts/%s.sav",udb_encode(adminname));
		if(!fexist(file))
		return SendClientMessage(playerid, red, "ERROR: File not found, Player is not registered!");
		if(dUserINT(PlayerName2(playerid)).("LastOn")==0)
		{
		format(str, sizeof(str),"Never"); tmp2 = str;
		}
		else
		{
		tmp2 = dini_Get(file,"LastOn"); }
		format(str, sizeof(str),"|- Your last Time on Server was: %s -|",tmp2);
		return SendClientMessage(playerid, red, str);
		}
		player1 = strval(params);
 		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid)
		{
		SendCommandToAdmins(playerid,"LastON");
 		GetPlayerName(player1,playername,sizeof(playername));
		format(file,sizeof(file),"/LuxAdmin/Accounts/%s.sav",udb_encode(playername));
		if(!fexist(file)) return SendClientMessage(playerid, red, "ERROR: File not found, Player is not registered!");
		if(dUserINT(PlayerName2(player1)).("LastOn")==0)
		{
		format(str, sizeof(str),"Never"); tmp2 = str;
		} else {
		tmp2 = dini_Get(file,"LastOn");
		}
		format(str, sizeof(str),"|- The last time of '%s' in server was: %s -|",playername,tmp2);
		return SendClientMessage(playerid, red, str);
		}
		else return ErrorMessages(playerid, 4);
	}
	else return ErrorMessages(playerid, 1);
}
dcmd_adminarea(playerid,params[])
{
	#pragma unused params
    if(AccInfo[playerid][Level] >= 1)
	{
        SendCommandToAdmins(playerid,"AdminArea");
	    SetPlayerPos(playerid, AdminArea[0], AdminArea[1], AdminArea[2]);
	    SetPlayerFacingAngle(playerid, AdminArea[3]);
	    SetPlayerInterior(playerid, AdminArea[4]);
		SetPlayerVirtualWorld(playerid, AdminArea[5]);
		return GameTextForPlayer(playerid,"Welcome in Admin Area",1000,3);
	    }
		else
		{
	   	SetPlayerHealth(playerid,1.0);
   		new string[100];
  		format(string, sizeof(string),"ATTENTION: %s has used AdminArea (Not is Admin)", PlayerName2(playerid));
	   	MessageToAdmins(red,string);
	}
	return SendClientMessage(playerid,red, "ERROR: You must be an administrator to use this command.");
}


dcmd_hide(playerid,params[])
{
    #pragma unused params
	if (AccInfo[playerid][Level] >= 4)
	{
	    if (AccInfo[playerid][Hide] == 1)
 		return SendClientMessage(playerid,red,"ERROR: You are already have Hidden in the Admin List!");

 		AccInfo[playerid][Hide] = 1;
   		return SendClientMessage(playerid,green,"|- You are now Hidden from the Admin List -|");
	}
	return ErrorMessages(playerid, 5);
}
dcmd_unhide(playerid,params[])
{
    #pragma unused params
	if(AccInfo[playerid][Level] >= 4)
	{
 		if (AccInfo[playerid][Hide] != 1)
 		return SendClientMessage(playerid,red,"ERROR: You are not Hidden in the Admin List!");
  		AccInfo[playerid][Hide] = 0;
   		return SendClientMessage(playerid,green,"|- You are now Visible in the Admin List -|");
	}
 	return ErrorMessages(playerid, 5);
}


//==============================================================================
// Duty System
//==============================================================================
dcmd_onduty(playerid,params[])
{
    #pragma unused params
	if (AccInfo[playerid][Level] >= 1)
	{
	    if(AccInfo[playerid][OnDuty] == 0)
	    {
 			AccInfo[playerid][OnDuty] = 1;
 			return SendClientMessage(playerid,green,"|- You are now in \"Duty Mode\" -|");
		}
		else
		{
			AccInfo[playerid][OnDuty] = 0;
 			return SendClientMessage(playerid,orange,"|- You are now in \"Playing Mode\"-|");
		}
	}
	return ErrorMessages(playerid, 5);
}
dcmd_admins(playerid,params[])
{
    #pragma unused params
        new count = 0;
        new string[128];
        new ChangeColor;
  		SendClientMessage(playerid, green, " ");
        SendClientMessage(playerid, green, "___________ |- Online Admins -| ___________");
		SendClientMessage(playerid, green, " ");
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
	 		if (IsPlayerConnected(i))
 			{
				if(AccInfo[i][Level] >= 1 && AccInfo[i][Hide] == 0)
 				{
					if(AccInfo[i][Level] > 5)
					{
						AdmRank = "Professional Admin";
						ChangeColor = Color_Professional_Admin;
					}
 					if(IsPlayerAdmin(i))
				  	{
				  		AdmRank = "RCON Administrator";
				  		ChangeColor = Color_RCON_Administrator;
				  	}
				    else
				    {
				 		switch(AccInfo[i][Level])
						{
							case 1: {
							AdmRank = "Basic Moderator";
							ChangeColor = Color_Basic_Moderator;
							}
							case 2: {
							AdmRank = "Moderator";
							ChangeColor = Color_Moderator;
							}
							case 3: {
							AdmRank = "Master Moderator";
							ChangeColor = Color_Master_Moderator;
							}
							case 4: {
							AdmRank = "Administrator";
							ChangeColor = Color_Administrator;
							}
							case 5: {
							AdmRank = "Master Administrator";
							ChangeColor = Color_Master_Administrator;
							}
						}
					}
		 			switch(AccInfo[i][OnDuty])
					{
						case 0: AdmDuty = "Playing!";
						case 1: AdmDuty = "On Duty!";
					}
					format(string, 128, "Level: %d - %s (Id:%i) | %s | %s",AccInfo[i][Level], PlayerName2(i),i,AdmRank,AdmDuty);
					SendClientMessage(playerid, ChangeColor, string);
					count++;
				}
			}
		}
		if (count == 0)
		SendClientMessage(playerid,red,"No admin online in the list");
		SendClientMessage(playerid, green, " _______________________________________");
		return 1;
}



dcmd_weaps(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 1 || IsPlayerAdmin(playerid))
	{
	    if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /weaps [PlayerID]") &&
		SendClientMessage(playerid, orange, "Function: See weapons of specified player");

    	new player1;
		new Count, x;
		new string[128], string2[64];
		new WeapName[24], slot, weap, ammo;
		player1 = strval(params);
	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		 {
			format(string2,sizeof(string2),"_______|- (%d)%s Weapons -|_______", player1,PlayerName2(player1));
			SendClientMessage(playerid,yellow,string2);
			for(slot = 0; slot < 14; slot++)
			{
			GetPlayerWeaponData(player1, slot, weap, ammo);
			if( ammo != 0 && weap != 0)
			Count++;
			}
			if(Count < 1)
			return SendClientMessage(playerid,blue,"No Weapons found!");

			if(Count >= 1)
			{
				for (slot = 0; slot < 14; slot++)
				{
				GetPlayerWeaponData(player1, slot, weap, ammo);

				if( ammo != 0 && weap != 0)
				{
				GetWeaponName(weap, WeapName, sizeof(WeapName));
				if(ammo == 65535 || ammo == 1)
				format(string,sizeof(string),"%s%s (1)",string, WeapName);
				else format(string,sizeof(string),"%s%s (%d)",string, WeapName, ammo);
				x++;
				if(x >= 5)
				{
	 			SendClientMessage(playerid, blue, string);
	 			x = 0;
				format(string, sizeof(string), "");
				}
				else format(string, sizeof(string), "%s,  ", string);
				}
			    }
				if(x <= 4 && x > 0)
				{
				string[strlen(string)-3] = '.';
    			SendClientMessage(playerid, blue, string);
				}
		    }
		    return 1;
		}
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_morning(playerid,params[])
{
    #pragma unused params
    if(AccInfo[playerid][Level] >= 1)
	{
 	SendCommandToAdmins(playerid,"Morning");
  	return SetPlayerTime(playerid,7,0);
    }
	else return ErrorMessages(playerid, 8);
}

dcmd_reports(playerid,params[])
{
    #pragma unused params
   	if(AccInfo[playerid][Level] >= 1)
	{
		new ReportCount;
		for(new i = 1; i < MAX_REPORTS; i++)
		{
		if(strcmp( Reports[i], "[NONE]", true) != 0)
		{
		ReportCount++; SendClientMessage(playerid,COLOR_WHITE,Reports[i]);
		}
		}
		if(ReportCount == 0)
		SendClientMessage(playerid,COLOR_WHITE,"|- No reports Found! -|");
 	}
	else ErrorMessages(playerid, 8);
	return 1;
}

dcmd_report(playerid,params[])
{
    new reported;
	new tmp[256];
	new tmp2[256];
	new Index;
	tmp = strtok(params,Index);
	tmp2 = strtok(params,Index);
    if(!strlen(params)) return
	SendClientMessage(playerid, LIGHTBLUE2, "Usage: /report [PlayerID] [Reason]") &&
	SendClientMessage(playerid, orange, "Attention: Not report anyone without Reason!");
	reported = strval(tmp);

 	if(IsPlayerConnected(reported) && reported != INVALID_PLAYER_ID)
	 {
		if(AccInfo[reported][Level] == ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot report this Administrator");
		if(playerid == reported)
		return SendClientMessage(playerid,red,"ERROR: You Cannot report Yourself");
		if(strlen(params) > 7)
		{
			new reportedname[MAX_PLAYER_NAME], reporter[MAX_PLAYER_NAME], str[128];
			new hour,minute,second;
			gettime(hour,minute,second);
			GetPlayerName(reported, reportedname, sizeof(reportedname));
			GetPlayerName(playerid, reporter, sizeof(reporter));
			format(str, sizeof(str), "REPORT: %s(Id:%d) Reported %s(Id:%d) Reason: %s |Time: %d:%d:%d|", reporter,playerid, reportedname, reported, params[strlen(tmp)+1], hour,minute,second);
			MessageToAdmins(COLOR_WHITE,str);
			SaveIn("ReportLog",str);
			format(str, sizeof(str), "(%d:%d:%d): %s(Id:%d) Reported %s(Id:%d) Reason: %s", hour,minute,second, reporter,playerid, reportedname, reported, params[strlen(tmp)+1]);
			for(new i = 1; i < MAX_REPORTS-1; i++) Reports[i] = Reports[i+1];
			Reports[MAX_REPORTS-1] = str;
			return SendClientMessage(playerid,yellow, "|- Your report has been sent to Online Administrators and saved in File! -|");
		}
		else return SendClientMessage(playerid,red,"ERROR: Invalid Reason!");
	}
	else return ErrorMessages(playerid, 2);
}

dcmd_miniguns(playerid,params[])
{
    #pragma unused params
    if(AccInfo[playerid][Level] >= 1)
	{
		new bool:First2 = false;
		new Count, string[128];
		new i, slot, weap, ammo;
		for(i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
			for(slot = 0; slot < 14; slot++)
			{
			GetPlayerWeaponData(i, slot, weap, ammo);
			if(ammo != 0 && weap == 38)
			{
		 	Count++;
			if(!First2)
			{
			format(string, sizeof(string), "Minigun: (%d)%s(ammo%d)", i, PlayerName2(i), ammo);
			First2 = true;
		 	}
		  	else format(string,sizeof(string),"%s, (%d)%s(ammo%d) ",string, i, PlayerName2(i), ammo);
			}
			}
    	    }
		}
		if(Count == 0)
		return SendClientMessage(playerid,COLOR_WHITE,"No player has Minigun!");
		else return SendClientMessage(playerid,COLOR_WHITE,string);
	}
	else return ErrorMessages(playerid, 1);
}
dcmd_richlist(playerid,params[])
{
    #pragma unused params
    if(AccInfo[playerid][Level] >= 1)
	{
 		new string[128], Slot1 = -1, Slot2 = -1, Slot3 = -1, Slot4 = -1;
        new HighestCash = -9999;
 		SendClientMessage(playerid,green,"|- Rich List: -|");

		for(new x=0; x<MAX_PLAYERS; x++)
		if(IsPlayerConnected(x))
		if(GetPlayerMoney(x) >= HighestCash)
		{
		HighestCash = GetPlayerMoney(x);
		Slot1 = x;
		}
		HighestCash = -9999;
		for(new x=0; x<MAX_PLAYERS; x++)
		if(IsPlayerConnected(x) && x != Slot1)
		if(GetPlayerMoney(x) >= HighestCash)
		{
		HighestCash = GetPlayerMoney(x);
		Slot2 = x;
		}
		HighestCash = -9999;
		for(new x=0; x<MAX_PLAYERS; x++)
		if(IsPlayerConnected(x) && x != Slot1 && x != Slot2)
		if(GetPlayerMoney(x) >= HighestCash)
		{
		HighestCash = GetPlayerMoney(x);
		Slot3 = x;
		}
		HighestCash = -9999;
		for(new x=0; x<MAX_PLAYERS; x++)
		if(IsPlayerConnected(x) && x != Slot1 && x != Slot2 && x != Slot3)
		if(GetPlayerMoney(x) >= HighestCash)
		{
		HighestCash = GetPlayerMoney(x);
		Slot4 = x;
		}
		format(string, sizeof(string), "(%d) Player %s - $%d", Slot1,PlayerName2(Slot1),GetPlayerMoney(Slot1));
		SendClientMessage(playerid,COLOR_WHITE,string);
		if(Slot2 != -1){
		format(string, sizeof(string), "(%d) Player %s - $%d", Slot2,PlayerName2(Slot2),GetPlayerMoney(Slot2));
		SendClientMessage(playerid,COLOR_WHITE,string);
		}
		if(Slot3 != -1){
		format(string, sizeof(string), "(%d) Player %s - $%d", Slot3,PlayerName2(Slot3),GetPlayerMoney(Slot3));
		SendClientMessage(playerid,COLOR_WHITE,string);
		}
		if(Slot4 != -1){
		format(string, sizeof(string), "(%d) Player %s - $%d", Slot4,PlayerName2(Slot4),GetPlayerMoney(Slot4));
		SendClientMessage(playerid,COLOR_WHITE,string);
		}
		return 1;
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_botcheck(playerid,params[])
{
    #pragma unused params
	if(AccInfo[playerid][Level] >= 4)
	{
		for(new i=0; i<MAX_PLAYERS; i++)
		BotCheck(i);
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		return SendCommandToAdmins(playerid,"BotCheck");
	}
	else return ErrorMessages(playerid, 5);
}
dcmd_unlockserver(playerid,params[])
{
    #pragma unused params
	if(AccInfo[playerid][Level] >= 4 || IsPlayerAdmin(playerid))
	{
 		if(ServerInfo[Locked] == 1)
		{
        return ShowPlayerDialog(playerid, DIALOG_TYPE_SERVUNLOCK, DIALOG_STYLE_MSGBOX, "Unlock Server","You are sure to want unlock the server?", "Yes", "No");
		}
		else return SendClientMessage(playerid,red,"ERROR: Server is not Locked");
	}
	else return ErrorMessages(playerid, 1);
}
dcmd_lockserver(playerid,params[])
{
    new string[156];
	if(AccInfo[playerid][Level] >= 4 || IsPlayerAdmin(playerid))
	{
		if(ServerInfo[Locked] == 0)
		{
		if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /lockserver [Pssword]") &&
		SendClientMessage(playerid, orange, "Function: Will server lock with specified Password");
		strmid(ServerInfo[Password], params[0], 0, strlen(params[0]), 128);
		format(string, 128, "Server Password: '%s'", params);
		return ShowPlayerDialog(playerid, DIALOG_TYPE_SERVLOCK, DIALOG_STYLE_MSGBOX, "Lock/Unlock Server", string, "Yes", "No");
		}
 		else return SendClientMessage(playerid,red,"ERROR: Server is Locked!");
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_uconfig(playerid,params[])
{
    #pragma unused params
	if(AccInfo[playerid][Level] >= 4)
	{
		UpdateConfig();
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		return SendCommandToAdmins(playerid,"UConfig");
	}
	else return ErrorMessages(playerid, 5);
}

//==============================================================================
// Spectating Commands - I have changed. More it is not my
//==============================================================================

dcmd_lspec(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 2 || IsPlayerAdmin(playerid))
	{
		if(AccInfo[playerid][pGps] != -1)
		return SendClientMessage(playerid, red, "ERROR: First Disable the Gps System! (/gps off)");

	    if(!strlen(params) || !IsNumeric(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /lspec [PlayerID]") &&
		SendClientMessage(playerid, orange, "Function: Will spec a specified Player");

		new specplayerid = ReturnUser(params);
		if(AccInfo[specplayerid][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");

        if(IsPlayerConnected(specplayerid) && specplayerid != INVALID_PLAYER_ID)
		{
			if(specplayerid == playerid)
			return SendClientMessage(playerid, red, "ERROR: You cannot spectate Yourself");

			if(GetPlayerState(specplayerid) == PLAYER_STATE_SPECTATING && AccInfo[specplayerid][SpecID] != INVALID_PLAYER_ID)
			return SendClientMessage(playerid, red, "ERROR: Player spectating someone else");

			if(GetPlayerState(specplayerid) != 1 && GetPlayerState(specplayerid) != 2 && GetPlayerState(specplayerid) != 3)
			return SendClientMessage(playerid, red, "ERROR: Player not Spawned");

			if((AccInfo[specplayerid][Level] != ServerInfo[MaxAdminLevel]) || (AccInfo[specplayerid][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] == ServerInfo[MaxAdminLevel]))
			{
				GetPlayerPos(playerid,Pos[playerid][0],Pos[playerid][1],Pos[playerid][2]);
				GetPlayerFacingAngle(playerid,Pos[playerid][3]);
				SendCommandToAdmins(playerid,"LSpec");
				SendClientMessage(playerid,blue,"|- Spectating On -|");
			 	return StartSpectate(playerid, specplayerid);
			}
			else return SendClientMessage(playerid,red,"ERROR: You cannot spectate the highest level admin");
		}
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 7);
}

dcmd_lspecvehicle(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 2 || IsPlayerAdmin(playerid))
	{
	    if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /lspecvehicle [VehicleID]") &&
		SendClientMessage(playerid, orange, "Function: Will spec a specified Vehicle");
		new specvehicleid = strval(params);
		if(specvehicleid < MAX_VEHICLES)
		{
			TogglePlayerSpectating(playerid, 1);
			PlayerSpectateVehicle(playerid, specvehicleid);
			AccInfo[playerid][SpecID]	= specvehicleid;
			AccInfo[playerid][SpecType] = ADMIN_SPEC_TYPE_VEHICLE;

			SendCommandToAdmins(playerid,"LSpecVehicle");
			GetPlayerPos(playerid,Pos[playerid][0],Pos[playerid][1],Pos[playerid][2]);
			GetPlayerFacingAngle(playerid,Pos[playerid][3]);
			return SendClientMessage(playerid,blue,"|- Vehicle Spectating On -|");
		}
		else return SendClientMessage(playerid,red, "ERROR: Invalid Vehicle ID");
	}
	else return ErrorMessages(playerid, 7);
}
dcmd_lspecoff(playerid,params[])
{
	#pragma unused params
    if(AccInfo[playerid][Level] >= 2 || IsPlayerAdmin(playerid))
	{
        if(AccInfo[playerid][SpecType] != ADMIN_SPEC_TYPE_NONE)
		{
			StopSpectate(playerid);
  			TogglePlayerControllable(playerid, 0);
			SetTimerEx("ReturnPosition",1000,0,"d",playerid);
			return SendClientMessage(playerid,blue,"|- Spectating Off -|");
		}
		else return SendClientMessage(playerid,red,"ERROR: You are not spectating");
	}
	else return ErrorMessages(playerid, 7);
}


//==============================================================================
// Pickups and Objects
//==============================================================================
dcmd_object(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 5 || IsPlayerAdmin(playerid))
	{
	    if(!strlen(params)) return
	    SendClientMessage(playerid, LIGHTBLUE2, "Usage: /object [ObjectID]") &&
		SendClientMessage(playerid, orange, "Function: Will created a specified Object");

	    new ObjID = strval(params), string[128];
		new Float:X, Float:Y, Float:Z, Float:Ang;
	    SendCommandToAdmins(playerid,"Object");
		GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid, Ang);
		X += (3 * floatsin(-Ang, degrees));
		Y += (3 * floatcos(-Ang, degrees));
		CreateObject(ObjID, X, Y, Z, 0.0, 0.0, Ang);
		format(string, sizeof(string), "CreateObject(%d, %0.2f, %0.2f, %0.2f, 0.00, 0.00, %0.2f);", ObjID, X, Y, Z, Ang);
       	SaveIn("CreatedObjects",string);
		format(string, sizeof(string), "|- Object Created: (Id: %d) (Position: X: %0.2f, Y: %0.2f, Z: %0.2f) (Angle: %0.2f) -|", ObjID, X, Y, Z, Ang);
		return SendClientMessage(playerid,yellow, string);
	}
	else return ErrorMessages(playerid, 1);
}
dcmd_pickup(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 5 || IsPlayerAdmin(playerid))
	{
	    if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /pickup [PickupID]") &&
		SendClientMessage(playerid, orange, "Function: Will created a specified Pickup");

	    new PickupID = strval(params), string[128];
		new Float:X, Float:Y, Float:Z, Float:Ang;
	    SendCommandToAdmins(playerid,"Pickup");
		GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid, Ang);
		X += (3 * floatsin(-Ang, degrees));
		Y += (3 * floatcos(-Ang, degrees));
		CreatePickup(PickupID, 2, X+2, Y, Z);
		format(string, sizeof(string), "CreatePickup(%d, 2, %0.2f, %0.2f, %0.2f);", PickupID, X+2, Y, Z);
       	SaveIn("CreatedPickups",string);
		format(string, sizeof(string), "|- Pickup Created: (Id: %d) (Position: X: %0.2f, Y: %0.2f, Z: %0.2f) -|", PickupID, X+2, Y, Z);
		return SendClientMessage(playerid,yellow, string);
	}
	else return ErrorMessages(playerid, 1);
}
//==============================================================================
// Fake Commands
//==============================================================================

dcmd_fakecmd(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 5)
	{
	    new tmp[256], tmp2[256], Index;
		tmp = strtok(params,Index);
		tmp2 = strtok(params,Index);

	    if(!strlen(tmp) || !strlen(tmp2)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /fakecmd [PlayerID] [Command]") &&
		SendClientMessage(playerid, orange, "Function: Will sending a false Command used per Specified player");

		new player1 = strval(tmp);
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
	        SendCommandToAdmins(playerid,"FakeCmd");
	        CallRemoteFunction("OnPlayerCommandText", "is", player1, tmp2);
			return SendClientMessage(playerid,blue,"|- Fake command sent! -|");
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}
//--------------------------
dcmd_fakechat(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 5)
	{
	    new tmp[256], tmp2[256], Index;
		tmp = strtok(params,Index);
		tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /fakechat [PlayerID] [Message]") &&
		SendClientMessage(playerid, orange, "Function: Will sending a false message typed per Specified player");

		new player1 = strval(tmp);
		if(AccInfo[player1][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
	        SendCommandToAdmins(playerid,"FakeChat");
			SendPlayerMessageToAll(player1, params[strlen(tmp)+1]);
			return SendClientMessage(playerid,blue,"|- Fake message sent! -|");
	    }
		else return ErrorMessages(playerid, 2);
	}
	else return ErrorMessages(playerid, 1);
}
//--------------------------
dcmd_fakedeath(playerid,params[])
{
    if(AccInfo[playerid][Level] >= 4)
	{
	    new Index;
	    new tmp	[256];
		new tmp2[256];
		new tmp3[256];
		tmp  = strtok(params,Index);
		tmp2 = strtok(params,Index);
		tmp3 = strtok(params,Index);

	    if(!strlen(tmp) || !strlen(tmp2) || !strlen(tmp3)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /fakedeath [KillerID] [KilledID] [WeaponID]") &&
		SendClientMessage(playerid, orange, "Function: Will cause a false death per specified player (FakeKill)");

		new killer = strval(tmp);
		new killee = strval(tmp2);
		new weap = strval(tmp3);
		if(!IsValidWeapon(weap))
		return SendClientMessage(playerid,red,"ERROR: Invalid Weapon ID");
		if(AccInfo[killer][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
		return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");
		if(AccInfo[killee][Level] == ServerInfo[MaxAdminLevel] && AccInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
	 	return SendClientMessage(playerid,red,"ERROR: You cannot use this command on this admin");

        if(IsPlayerConnected(killer) && killer != INVALID_PLAYER_ID)
		{
	        if(IsPlayerConnected(killee) && killee != INVALID_PLAYER_ID)
			{
	    	  	SendCommandToAdmins(playerid,"FakeDeath");
				SendDeathMessage(killer,killee,weap);
				return SendClientMessage(playerid,blue,"Fake death message sent");
		    }
			else return SendClientMessage(playerid,red,"ERROR: Fake Killed is not connected");
	    }
		else return SendClientMessage(playerid,red,"ERROR: Fake Killer is not connected");
	}
	else return ErrorMessages(playerid, 1);
}

//==============================================================================
//-------------------------------------------------
// All (Commands)
//-------------------------------------------------
//==============================================================================

dcmd_healall(playerid,params[])
{
    #pragma unused params
	if(AccInfo[playerid][Level] >= 3)
	{
		SendCommandToAdmins(playerid,"HealAll");
	   	for(new i = 0; i < MAX_PLAYERS; i++)
		{
		if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel])
		{
		PlayerPlaySound(i,1057,0.0,0.0,0.0);
		SetPlayerHealth(i,100.0);
		}
		}
		new string[128];
		format(string,sizeof(string),"|- Administrator \"%s\" has Healed all players -|", pName(playerid));
		return SendClientMessageToAll(blue, string);
	}
	else return ErrorMessages(playerid, 6);
}
dcmd_spawnall(playerid,params[])
{
    #pragma unused params
	if(AccInfo[playerid][Level] >= 4)
	{
		SendCommandToAdmins(playerid,"SpawnAll");
	   	for(new i = 0; i < MAX_PLAYERS; i++)
  		{
		if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel])
		{
		PlayerPlaySound(i,1057,0.0,0.0,0.0);
		SetPlayerPos(i, 0.0, 0.0, 0.0); SpawnPlayer(i);
		}
		}
		new string[128];
		format(string,sizeof(string),"|- Administrator \"%s\" has Spawned all players -|", pName(playerid));
		return SendClientMessageToAll(blue, string);
	}
	else return ErrorMessages(playerid, 5);
}
dcmd_armourall(playerid,params[])
{
    #pragma unused params
	if(AccInfo[playerid][Level] >= 3)
	{
		SendCommandToAdmins(playerid,"ArmourAll");
	   	for(new i = 0; i < MAX_PLAYERS; i++)
  		{
		if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel])
		{
		PlayerPlaySound(i,1057,0.0,0.0,0.0);
		SetPlayerArmour(i,100.0);
		}
		}
		new string[128];
		format(string,sizeof(string),"|- Administrator \"%s\" has Restored all players armour -|", pName(playerid));
		return SendClientMessageToAll(blue, string);
	}
	else return ErrorMessages(playerid, 6);
}

dcmd_slapall(playerid,params[])
{
    #pragma unused params
	if(AccInfo[playerid][Level] >= 4)
	{
		SendCommandToAdmins(playerid,"SlapAll");
		new Float:x, Float:y, Float:z;
	   	for(new i = 0; i < MAX_PLAYERS; i++)
  		{
		if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel])
		{
		PlayerPlaySound(i,1190,0.0,0.0,0.0);
		GetPlayerPos(i,x,y,z);
		SetPlayerPos(i,x,y,z+4);
		}
		}
		new string[128];
		format(string,sizeof(string),"|- Administrator \"%s\" has Slapped all players -|", pName(playerid));
		return SendClientMessageToAll(blue, string);
	}
	else return ErrorMessages(playerid, 5);
}

dcmd_freezeall(playerid,params[])
 {
    #pragma unused params
	if(AccInfo[playerid][Level] >= 4)
	{
		SendCommandToAdmins(playerid,"FreezeAll");
	   	for(new i = 0; i < MAX_PLAYERS; i++) {
		if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel])
		{
		PlayerPlaySound(i,1057,0.0,0.0,0.0);
		TogglePlayerControllable(playerid,false);
		AccInfo[i][Frozen] = 1;
        }
		}
		new string[128];
		format(string,sizeof(string),"|- Administrator \"%s\" has Frozen all players -|", pName(playerid));
		return SendClientMessageToAll(blue, string);
	}
	else return ErrorMessages(playerid, 5);
}

dcmd_unfreezeall(playerid,params[])
{
    #pragma unused params
	if(AccInfo[playerid][Level] >= 4)
	{
		SendCommandToAdmins(playerid,"UnfreezeAll");
	   	for(new i = 0; i < MAX_PLAYERS; i++)
  		{
		if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel])
		{
		PlayerPlaySound(i,1057,0.0,0.0,0.0);
		TogglePlayerControllable(playerid,true);
		AccInfo[i][Frozen] = 0;
		}
		}
		new string[128];
		format(string,sizeof(string),"|- Administrator \"%s\" has Unfrozen all players -|", pName(playerid));
		return SendClientMessageToAll(blue, string);
	}
	else return ErrorMessages(playerid, 5);
}

dcmd_killall(playerid,params[])
{
    #pragma unused params
	if(AccInfo[playerid][Level] >= 4)
	{
		SendCommandToAdmins(playerid,"KillAll");
	   	for(new i = 0; i < MAX_PLAYERS; i++)
  		{
		if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel])
		{
		PlayerPlaySound(i,1057,0.0,0.0,0.0);
		SetPlayerHealth(i,0.0);
		}
		}
		new string[128];
		format(string,sizeof(string),"|- Administrator \"%s\" has Killed all players -|", pName(playerid));
		return SendClientMessageToAll(blue, string);
	}
	else return ErrorMessages(playerid, 5);
}

dcmd_kickall(playerid,params[])
{
    #pragma unused params
	if(AccInfo[playerid][Level] >= 4)
	{
		SendCommandToAdmins(playerid,"KickAll");
	   	for(new i = 0; i < MAX_PLAYERS; i++) {
		if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel])
		{
		PlayerPlaySound(i,1057,0.0,0.0,0.0);
		Kick(i);
		}
		}
		new string[128];
		format(string,sizeof(string),"|- Administrator \"%s\" has Kicked all players -|", pName(playerid));
		SaveIn("KickLog",string);
		return SendClientMessageToAll(blue, string);
	}
	else return ErrorMessages(playerid, 5);
}

dcmd_explodeall(playerid,params[])
{
    #pragma unused params
	if(AccInfo[playerid][Level] >= 4)
	{
		SendCommandToAdmins(playerid,"ExplodeAll");
		new Float:x, Float:y, Float:z;
	   	for(new i = 0; i < MAX_PLAYERS; i++)
  		{
		if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel])
		{
		PlayerPlaySound(i,1190,0.0,0.0,0.0);
		GetPlayerPos(i,x,y,z);
		CreateExplosion(x,y,z,7,10.0);
		}
		}
		new string[128]; format(string,sizeof(string),"|- Administrator \"%s\" has Exploded all players -|", pName(playerid));
		return SendClientMessageToAll(blue, string);
	}
	else return ErrorMessages(playerid, 5);
}

dcmd_setallwanted(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
	    if(!strlen(params)) return
	    SendClientMessage(playerid, LIGHTBLUE2, "Usage: /setallwanted [WantedLevel]") &&
		SendClientMessage(playerid, orange, "Function: Will set a specified Weather for all players");
		new var = strval(params), string[128];
       	SendCommandToAdmins(playerid,"SetAllWanted");
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				PlayerPlaySound(i,1057,0.0,0.0,0.0);
				SetPlayerWantedLevel(i,var);
			}
		}
		format(string,sizeof(string),"|- Administrator \"%s\" has set all players wanted level to '%d' -|", pName(playerid), var );
		return SendClientMessageToAll(blue, string);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_setallskin(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
	    if(!strlen(params)) return
	    SendClientMessage(playerid, LIGHTBLUE2, "Usage: /setallskin [SkinID]") &&
		SendClientMessage(playerid, orange, "Function: Will set a specified Skin for all players");
		new var = strval(params), string[128];
		if(!IsValidSkin(var)) return SendClientMessage(playerid, red, "ERROR: Invaild Skin ID");
       	SendCommandToAdmins(playerid,"SetAllSkin");
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				PlayerPlaySound(i,1057,0.0,0.0,0.0);
				SetPlayerSkin(i,var);
			}
		}
		format(string,sizeof(string),"|- Administrator \"%s\" has set all players Skin to '%d' -|", pName(playerid), var );
		return SendClientMessageToAll(blue, string);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_setallweather(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
	    if(!strlen(params)) return
	    SendClientMessage(playerid, LIGHTBLUE2, "Usage: /setallweather [WeatherID]") &&
		SendClientMessage(playerid, orange, "Function: Will set a specified Weather for all players");
		new var = strval(params), string[128];
       	SendCommandToAdmins(playerid,"SetAllWeather");
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				PlayerPlaySound(i,1057,0.0,0.0,0.0);
				SetPlayerWeather(i, var);
			}
		}
		format(string,sizeof(string),"|- Administrator \"%s\" has set all players Weather to '%d' -|", pName(playerid), var );
		return SendClientMessageToAll(blue, string);
	}
    else return ErrorMessages(playerid, 1);
}

dcmd_disarmall(playerid,params[])
{
    #pragma unused params
	if(AccInfo[playerid][Level] >= 4)
	{
		SendCommandToAdmins(playerid,"DisarmAll");
	   	for(new i = 0; i < MAX_PLAYERS; i++)
	   	{
		if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel])
		{
		PlayerPlaySound(i,1057,0.0,0.0,0.0);
		ResetPlayerWeapons(i);
		}
		}
		new string[128];
		format(string,sizeof(string),"|- Administrator \"%s\" has Disarmed all Players -|", pName(playerid));
		return SendClientMessageToAll(blue, string);
	}
	else return ErrorMessages(playerid, 5);
}

dcmd_ejectall(playerid,params[])
{
    #pragma unused params
	if(AccInfo[playerid][Level] >= 4)
	{
    	SendCommandToAdmins(playerid,"EjectAll");
        new Float:x, Float:y, Float:z;
	   	for(new i = 0; i < MAX_PLAYERS; i++)
 	   	{
		if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel])
		{
		if(IsPlayerInAnyVehicle(i))
		{
		PlayerPlaySound(i,1057,0.0,0.0,0.0);
		GetPlayerPos(i,x,y,z);
		SetPlayerPos(i,x,y,z+3);
		}
		}
		}
		new string[128];
		format(string,sizeof(string),"|- Administrator \"%s\" has Ejected all Players -|", pName(playerid));
		return SendClientMessageToAll(blue, string);
	}
	else return ErrorMessages(playerid, 5);
}

dcmd_setalltime(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
	    if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /setalltime [Time(Hour)]") &&
		SendClientMessage(playerid, orange, "Function: Will set a specified Hour for all players");

		new var = strval(params), string[128];
		if(var > 24) return SendClientMessage(playerid, red, "ERROR: Invalid Hour!");
       	SendCommandToAdmins(playerid,"SetAllTime");
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				PlayerPlaySound(i,1057,0.0,0.0,0.0);
				SetPlayerTime(i, var, 0);
			}
		}
		format(string,sizeof(string),"|- Administrator \"%s\" has set all players Time to '%d:00' -|", pName(playerid), var );
		return SendClientMessageToAll(blue, string);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_setallcash(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
	    if(!strlen(params)) return
	    SendClientMessage(playerid, LIGHTBLUE2, "Usage: /setallcash [Value]") &&
		SendClientMessage(playerid, orange, "Function: Will set a specified value in Money for all players");
		new var = strval(params), string[128];
       	SendCommandToAdmins(playerid,"SetAllCash");
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				PlayerPlaySound(i,1057,0.0,0.0,0.0);
				ResetPlayerMoney(i);
				GivePlayerMoney(i,var);
			}
		}
		format(string,sizeof(string),"|- Administrator \"%s\" has set all Players Cash to '$%d' -|", pName(playerid), var );
		return SendClientMessageToAll(blue, string);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_setallworld(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
	    if(!strlen(params)) return
	    SendClientMessage(playerid, LIGHTBLUE2, "Usage: /setallworld [VirtualWorld]") &&
		SendClientMessage(playerid, orange, "Function: Will set a specified Virtual World for all players");
		new var = strval(params), string[128];
       	SendCommandToAdmins(playerid,"SetAllWorld");
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				PlayerPlaySound(i,1057,0.0,0.0,0.0);
				SetPlayerVirtualWorld(i,var);
			}
		}
		format(string,sizeof(string),"|- Administrator \"%s\" has set all players Virtual Worlds to '%d' -|", pName(playerid), var );
		return SendClientMessageToAll(blue, string);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_setallscore(playerid,params[])
 {
	if(AccInfo[playerid][Level] >= 3)
	{
	    if(!strlen(params)) return
	    SendClientMessage(playerid, LIGHTBLUE2, "Usage: /setallscore [Score]") &&
		SendClientMessage(playerid, orange, "Function: Will set a score value for all players");
		new var = strval(params), string[128];
       	SendCommandToAdmins(playerid,"SetAllScore");
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i)) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0);
				SetPlayerScore(i,var);
			}
		}
		format(string,sizeof(string),"|- Administrator \"%s\" has set all Players Scores to '%d' -|", pName(playerid), var );
		return SendClientMessageToAll(blue, string);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_getall(playerid,params[])
{
    #pragma unused params
	if(AccInfo[playerid][Level] >= 4)
	{
		SendCommandToAdmins(playerid,"GetAll");
		new Float:x,Float:y,Float:z, interior = GetPlayerInterior(playerid);
    	GetPlayerPos(playerid,x,y,z);
	   	for(new i = 0; i < MAX_PLAYERS; i++)
  		{
		if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel])
		{
		PlayerPlaySound(i,1057,0.0,0.0,0.0);
		SetPlayerPos(i,x+(playerid/4)+1,y+(playerid/4),z);
		SetPlayerInterior(i,interior);
		}
		}
		new string[128];
		format(string,sizeof(string),"|- Administrator \"%s\" has Teleported all players -|", pName(playerid));
		return SendClientMessageToAll(blue, string);
	}
	else return ErrorMessages(playerid, 5);
}

dcmd_muteall(playerid,params[])
{
    #pragma unused params
	if(AccInfo[playerid][Level] >= 4)
	{
		SendCommandToAdmins(playerid,"MuteAll");
	   	for(new i = 0; i < MAX_PLAYERS; i++)
  		{
		if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel])
		{
		PlayerPlaySound(i,1057,0.0,0.0,0.0);
		AccInfo[i][Muted] = 1;
		AccInfo[i][MuteWarnings] = 0;
		}
		}
		new string[128];
		format(string,sizeof(string),"|- Administrator \"%s\" has Muted all players -|", pName(playerid));
		return SendClientMessageToAll(blue, string);
	}
	else return ErrorMessages(playerid, 5);
}

dcmd_unmuteall(playerid,params[])
{
    #pragma unused params
	if(AccInfo[playerid][Level] >= 4)
	{
		SendCommandToAdmins(playerid,"UnmuteAll");
	   	for(new i = 0; i < MAX_PLAYERS; i++)
  		{
		if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel])
		{
		PlayerPlaySound(i,1057,0.0,0.0,0.0);
	 	AccInfo[i][Muted] = 0;
		AccInfo[i][MuteWarnings] = 0;
		}
		}
		new string[128];
		format(string,sizeof(string),"|- Administrator \"%s\" has Unmuted all players -|", pName(playerid));
		return SendClientMessageToAll(blue, string);
	}
	else return ErrorMessages(playerid, 5);
}

dcmd_giveallcash(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
	    if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /giveallcash [Value]") &&
		SendClientMessage(playerid, orange, "Function: Will give a specified value in Money for all players");
		new var = strval(params), string[128];
       	SendCommandToAdmins(playerid,"GiveAllCash");
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				PlayerPlaySound(i,1057,0.0,0.0,0.0);
				GivePlayerMoney(i,var);
			}
		}
		format(string,sizeof(string),"|- Administrator \"%s\" has given all Players '$%d' -|", pName(playerid), var );
		return SendClientMessageToAll(blue, string);
	}
	else return ErrorMessages(playerid, 1);
}

dcmd_giveallweapon(playerid,params[])
{
	if(AccInfo[playerid][Level] >= 3)
	{
	    new tmp[256], tmp2[256], Index;
		new ammo, weap, WeapName[32];
		new string[128];
		tmp = strtok(params,Index); tmp2 = strtok(params,Index);
	    if(!strlen(tmp)) return
	    SendClientMessage(playerid, LIGHTBLUE2, "Usage: /giveallweapon [WeaponID or WeaponName] [Ammo]") &&
		SendClientMessage(playerid, orange, "Function: Will give a specified weapon and ammo for all players");

		if(!strlen(tmp2) || !IsNumeric(tmp2) || strval(tmp2) <= 0 || strval(tmp2) > 99999) ammo = 500;
		if(!IsNumeric(tmp))
		weap = GetWeaponIDFromName(tmp);
		else weap = strval(tmp);
	  	if(!IsValidWeapon(weap))
  		return SendClientMessage(playerid,red,"ERROR: Invalid Weapon ID");
      	SendCommandToAdmins(playerid,"GiveAllWeapon");
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
			PlayerPlaySound(i,1057,0.0,0.0,0.0);
			GivePlayerWeapon(i,weap,ammo);
			}
		}
		GetWeaponName(weap, WeapName, sizeof(WeapName));
		format(string,sizeof(string),"|- Administrator \"%s\" has Given all Players a %'s' (%d) with %d rounds of Ammo -|", pName(playerid), WeapName, weap, ammo);
		return SendClientMessageToAll(blue, string);
	}
	else return ErrorMessages(playerid, 1);
}
//==============================================================================
// Position
//==============================================================================
dcmd_gotoplace(playerid,params[])
{
    #pragma unused params
	if(AccInfo[playerid][LoggedIn] == 1 && AccInfo[playerid][Level] >= 1)
	{
	    if (dUserINT(PlayerName2(playerid)).("x")!=0)
		{
		    PutAtPos(playerid);
			SetPlayerVirtualWorld(playerid, (dUserINT(PlayerName2(playerid)).("world")) );
			return SendClientMessage(playerid,yellow,"|- You have been teleported to your saved position -|");
		}
		else return SendClientMessage(playerid,red,"ERROR: You not have a saved Position! (/gotoplace)");
	}
	else return SendClientMessage(playerid,red, "ERROR: You must be an administrator to use this command");
}

dcmd_saveplace(playerid,params[])
{
    #pragma unused params
	if(AccInfo[playerid][LoggedIn] == 1 && AccInfo[playerid][Level] >= 1)
	{
		new Float:x,Float:y,Float:z, interior;
		GetPlayerPos(playerid,x,y,z);
		interior = GetPlayerInterior(playerid);

		dUserSetINT(PlayerName2(playerid)).("x",floatround(x));
		dUserSetINT(PlayerName2(playerid)).("y",floatround(y));
		dUserSetINT(PlayerName2(playerid)).("z",floatround(z));
		dUserSetINT(PlayerName2(playerid)).("interior",interior);
		dUserSetINT(PlayerName2(playerid)).("world", (GetPlayerVirtualWorld(playerid)));
		return SendClientMessage(playerid,yellow,"|- Coordinates of your position successfully saved! -|");
	}
	else return SendClientMessage(playerid,red, "ERROR: You must be an administrator to use this command");
}
//==============================================================================
//==============================================================================
// Dialog Menu
//==============================================================================
#if USE_DIALOGS == true
dcmd_lmenu(playerid,params[])
{
    #pragma unused params
    if(AccInfo[playerid][Level] >= 2)
	{
        if(IsPlayerInAnyVehicle(playerid))
		{
        TogglePlayerControllable(playerid,false);
		return ShowPlayerDialog(playerid, DIALOGID+1, DIALOG_STYLE_LIST, "Velixion Gaming Main Menu",
		"Enable\nDisable\nServer Weather\nServer Time\nVehicles\nTuning Menu\nWeapons\nTeleports", "Select", "Cancel");
        }
		else return ShowPlayerDialog(playerid, DIALOGID+1, DIALOG_STYLE_LIST, "Velixion Gaming Main Menu",
		"Enable\nDisable\nServer Weather\nServer Time\nVehicles\nTuning Menu\nWeapons\nTeleports", "Select", "Cancel");
    }
    else return ErrorMessages(playerid, 1);
}
dcmd_execcmd(playerid,params[])
{
    #pragma unused params
    if(AccInfo[playerid][Level] >= 2)
	{
		return ShowPlayerDialog(playerid, DIALOGID+80, DIALOG_STYLE_INPUT, "Velixion Gaming - Execute Command",
		"Simple type a Command! \n\nFor LuxAdmin, for your GameMode, and for any other Filterscript! \n\nExemple: 'ban 0 cheats' (Without '/')", "Exec Cmd", "Cancel");
    }
    else return ErrorMessages(playerid, 1);
}


dcmd_fstyles(playerid,params[])
{
    #pragma unused params
    if(AccInfo[playerid][Level] >= 0)
	{
	    new tmp[128];
	    new FightName[30];
	    new Float:FStyle;
	    FStyle = GetPlayerFightingStyle(playerid);

	    if(FStyle == FIGHT_STYLE_ELBOW) 	FightName = "Elbow";
	    if(FStyle == FIGHT_STYLE_BOXING) 	FightName = "Boxing";
	    if(FStyle == FIGHT_STYLE_GRABKICK) 	FightName = "Grabkick";
	    if(FStyle == FIGHT_STYLE_KNEEHEAD) 	FightName = "Kneehead";
	    if(FStyle == FIGHT_STYLE_KUNGFU) 	FightName = "Kungfu";
	    if(FStyle == FIGHT_STYLE_NORMAL) 	FightName = "Normal";

   		format(tmp,sizeof(tmp),"Fighting Styles (Current: %s)",FightName);
		return ShowPlayerDialog(playerid,DIALOGID+81,DIALOG_STYLE_LIST,tmp,"Elbow\nBoxing\nGrabkick\nKneehead\nKungfu\nNormal", "Change", "Cancel");
    }
    else return ErrorMessages(playerid, 1);
}

dcmd_console(playerid,params[])
{
    #pragma unused params
    if(AccInfo[playerid][Level] >= 5)
	{
 		return ShowPlayerDialog(playerid, DIALOGID+61, DIALOG_STYLE_LIST, "LuxAdmin - Console",
		"Load Filterscript\nUnload Filterscript\nChange Mode\nRestart (Gmx)\nLoad LuxAdmin\nUnload LuxAdmin\nReload LuxAdmin\nUnban IP\nReload Bans\nExecute Command", "Select", "Cancel");
    }
    else return ErrorMessages(playerid, 1);
}

dcmd_ctele(playerid,params[])
{
    #pragma unused params
    if(AccInfo[playerid][Level] >= 4)
	{
 		return ShowPlayerDialog(playerid,DIALOGID+70,DIALOG_STYLE_LIST,"LuxAdmin - Teleport System:","Create Tele\nDelete Tele\nTeleport","Ok","Cancel");
    }
    else return ErrorMessages(playerid, 1);
}
#endif
//==============================================================================
// Skin
//==============================================================================
dcmd_useskin(playerid,params[])
{
    #pragma unused params
	if(AccInfo[playerid][Level] >= 1 && AccInfo[playerid][LoggedIn] == 1)
	{
	    dUserSetINT(PlayerName2(playerid)).("UseSkin",1);
    	SetPlayerSkin(playerid,dUserINT(PlayerName2(playerid)).("FavSkin"));
		return SendClientMessage(playerid,yellow,"|- Ready! Skin in use -|");
	} else return SendClientMessage(playerid,red,"ERROR: You must be an administrator to use this command");
}

dcmd_saveskin(playerid,params[])
{
 	if(AccInfo[playerid][Level] >= 1 && AccInfo[playerid][LoggedIn] == 1)
	 {
		if(!strlen(params)) return
		SendClientMessage(playerid, LIGHTBLUE2, "Usage: /saveskin [SkinID]") &&
		SendClientMessage(playerid, orange, "Function: Save your favorite Skin");

		new string[128];
		new SkinID = strval(params);

		if((SkinID == 0) ||(SkinID == 7)
		||(SkinID >= 9   && SkinID <= 41)  ||(SkinID >= 43  && SkinID <= 64)  ||(SkinID >= 66 && SkinID <= 73)
		||(SkinID >= 75  && SkinID <= 85)  ||(SkinID >= 87  && SkinID <= 118) ||(SkinID >= 120 && SkinID <= 148)
		||(SkinID >= 150 && SkinID <= 207) ||(SkinID >= 209 && SkinID <= 264) ||(SkinID >= 274 && SkinID <= 288)
		||(SkinID >= 290 && SkinID <= 299))
		{
		dUserSetINT(PlayerName2(playerid)).("FavSkin",SkinID);
 		format(string, sizeof(string), "|- You have Successfully Saved your favorite Skin (Id:%d) -|",SkinID);
 		SendClientMessage(playerid,yellow,string);
		SendClientMessage(playerid,yellow,"|- Usage: /useskin to use this skin | /dontuseskin to stop using skin! -|");
		dUserSetINT(PlayerName2(playerid)).("UseSkin",1);
 	    return SendCommandToAdmins(playerid,"SaveSkin");
		}
		else return SendClientMessage(playerid, green, "ERROR: Invalid Skin Id!");
	}
	else return SendClientMessage(playerid,red,"ERROR: You must be an administrator to use this command");
}

dcmd_dontuseskin(playerid,params[])
{
    #pragma unused params
	if(AccInfo[playerid][Level] >= 1 && AccInfo[playerid][LoggedIn] == 1)
	{
	    dUserSetINT(PlayerName2(playerid)).("UseSkin",0);
		return SendClientMessage(playerid,yellow,"|- Skin will no longer be used -|");
	} else
	return SendClientMessage(playerid,red,"ERROR: You must be an administrator to use this command");
}


//==============================================================================
// Login Player
//==============================================================================
LoginPlayer(playerid)
{
	if(ServerInfo[GiveMoney] == 1)
	{
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, dUserINT(PlayerName2(playerid)).("Money"));
	}
	SetPlayerWantedLevel(playerid,dUserINT(PlayerName2(playerid)).("WantedLevel"));
	#if SaveScore == true
	SetPlayerScore(playerid,dUserINT(PlayerName2(playerid)).("Score"));
	#endif
	dUserSetINT(PlayerName2(playerid)).("Loggedin",1);
	AccInfo[playerid][Deaths] 		= (dUserINT(PlayerName2(playerid)).("Deaths"));
	AccInfo[playerid][Kills] 		= (dUserINT(PlayerName2(playerid)).("Kills"));
 	AccInfo[playerid][Level] 		= (dUserINT(PlayerName2(playerid)).("Level"));
 	AccInfo[playerid][pVip] 		= (dUserINT(PlayerName2(playerid)).("AccountType"));
   	AccInfo[playerid][hours]		= dUserINT(PlayerName2(playerid)).("Hours");
   	AccInfo[playerid][mins] 		= dUserINT(PlayerName2(playerid)).("Minutes");
   	AccInfo[playerid][secs] 		= dUserINT(PlayerName2(playerid)).("Seconds");
	AccInfo[playerid][Registered]	= 1;
 	AccInfo[playerid][LoggedIn] 	= 1;
}

//==============================================================================
//-------------------------------------------------
// OnPlayerCommandText
//-------------------------------------------------
//==============================================================================
public OnPlayerCommandText(playerid, cmdtext[])
{
    if(AccInfo[playerid][Jailed] == 1 && AccInfo[playerid][Level] < 1)
	return SendClientMessage(playerid,red,"ERROR: You cannot use commands in Jail!");

	new cmd[256];
	new string[128];
	new tmp[256];
	new idx;

	cmd = strtok(cmdtext, idx);

//============================
// Register & Login
//============================
    dcmd2(CMD_REGISTER,CMD_REGISTER_LEN,cmdtext);
    dcmd2(CMD_LOGIN,CMD_LOGIN_LEN,cmdtext);
//============================
// Password
//============================
	dcmd(setpass,7,cmdtext);
 	dcmd2(CMD_CHANGEPASS,CMD_CHANGEPASS_LEN,cmdtext);
//============================
// Reports
//============================
	dcmd(report,6,cmdtext);
	dcmd(reports,7,cmdtext);
//============================
// Stats
//============================
	#if USE_STATS == true
	dcmd(stats,5,cmdtext);
	dcmd(resetstats,10,cmdtext);
	#endif

//=============================
// Clear kill list
//=============================
  	if (strcmp("/cdw", cmdtext, true) == 0)
    {
		if(AccInfo[playerid][Level] >= 2)
		{
			new adminname [MAX_PLAYER_NAME];
    		SendDeathMessage(5000, 5000, 5000);
    		SendDeathMessage(5000, 5000, 5000);
    		SendDeathMessage(5000, 5000, 5000);
    		SendDeathMessage(5000, 5000, 5000);
    		SendDeathMessage(5000, 5000, 5000);
    		SendDeathMessage(5000, 5000, 5000);
    		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
   			GetPlayerName(playerid, adminname, sizeof(adminname));
			format(string, sizeof(string), "|- Administrator %s has been Cleared Death List -|",adminname);
			SendClientMessageToAll(blue, string);
			return 1;
		}
		else return ErrorMessages(playerid, 7);
 	}
//==============================================================================
// Read Commands (View commands typed per players)
//==============================================================================
	if(ServerInfo[ReadCmds] == 1)
	{
		format(string, sizeof(string), "*** %s (%d) Command: %s", pName(playerid),playerid,cmdtext);
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				if( (AccInfo[i][Level] > AccInfo[playerid][Level]) && (AccInfo[i][Level] > 1) && (i != playerid))
				{
					SendClientMessage(i, grey, string);
				}
			}
		}
	}
	dcmd(disablechat,19,cmdtext);
	dcmd(clearchat,9,cmdtext);
	dcmd(clearallchat,12,cmdtext);
	dcmd(caps,4,cmdtext);
	#if EnablePM_Cmd == true
	dcmd(pm,2,cmdtext);
	#endif
//============================
// Vehicle
//============================
    	dcmd(tcar,4,cmdtext);
		dcmd(linkcar,7,cmdtext);
 		dcmd(acar,4,cmdtext);
    	dcmd(abike,5,cmdtext);
    	dcmd(aplane,6,cmdtext);
    	dcmd(aheli,5,cmdtext);
		dcmd(aboat,5,cmdtext);
		dcmd(car,3,cmdtext);
		dcmd(respawncars,11,cmdtext);
		dcmd(carcolour,9,cmdtext);
		dcmd(destroycar,10,cmdtext);
		dcmd(carhealth,9,cmdtext);
    	dcmd(fix,3,cmdtext);
    	dcmd(repair,6,cmdtext);
    	dcmd(addnos,6,cmdtext);
   		dcmd(vgoto,5,cmdtext);
   		dcmd(lockcar,7,cmdtext);
		dcmd(unlockcar,9,cmdtext);
    	dcmd(vget,4,cmdtext);
    	dcmd(givecar,7,cmdtext);
//==	==========================
// P	layer
//============================
		dcmd(sethealth,9,cmdtext);
		dcmd(setarmour,9,cmdtext);
		dcmd(setcolour,9,cmdtext);
		dcmd(setname,7,cmdtext);
		dcmd(setskin,7,cmdtext);
		dcmd(settime,7,cmdtext);
		dcmd(setweather,10,cmdtext);
		dcmd(setscore,8,cmdtext);
		dcmd(setcash,7,cmdtext);
 		dcmd(gotoid,6,cmdtext);
  		dcmd(lgoto,5,cmdtext);
    	dcmd(gethere,7,cmdtext);
    	dcmd(get,3,cmdtext);
		dcmd(removecash,10,cmdtext);
		dcmd(sremovecash,11,cmdtext);
		dcmd(setworld,8,cmdtext);
		dcmd(setinterior,11,cmdtext);
    	dcmd(ubound,6,cmdtext);
		dcmd(setwanted,9,cmdtext);
		dcmd(spawn,5,cmdtext);
 		dcmd(weaps,5,cmdtext);
    	dcmd(screen,2,cmdtext);
    	dcmd(highlight,9,cmdtext);
		dcmd(spawnplayer,11,cmdtext);
		dcmd(disarm,6,cmdtext);
		dcmd(eject,5,cmdtext);
 		dcmd(crash,5,cmdtext);
		dcmd(giveweapon,10,cmdtext);
		dcmd(warp,4,cmdtext);
		dcmd(teleplayer,10,cmdtext);
    	dcmd(setlevel,8,cmdtext);
    	dcmd(setvip,6,cmdtext);
    	dcmd(settemplevel,12,cmdtext);
    	dcmd(warn,4,cmdtext);
    	dcmd(kick,4,cmdtext);
   		dcmd(ip,2,cmdtext);
		dcmd(aka,3,cmdtext);
    	dcmd(ban,3,cmdtext);
    	dcmd(rban,4,cmdtext);
    	dcmd(slap,4,cmdtext);
		dcmd(force,5,cmdtext);
		dcmd(burn,4,cmdtext);
    	dcmd(explode,7,cmdtext);
    	dcmd(fu,2,cmdtext);
    	dcmd(jail,4,cmdtext);
    	dcmd(unjail,6,cmdtext);
    	dcmd(cage,4,cmdtext);
    	dcmd(gps,3,cmdtext);
   		dcmd(freeze,6,cmdtext);
    	dcmd(unfreeze,8,cmdtext);
    	dcmd(mute,4,cmdtext);
    	dcmd(unmute,6,cmdtext);
    	dcmd(akill,5,cmdtext);
    	dcmd(frozen,6,cmdtext);
    	dcmd(muted,5,cmdtext);
    	dcmd(jailed,6,cmdtext);
    	dcmd(wanted,6,cmdtext);
    	dcmd(viplist,7,cmdtext);
//==	==========================
// Spectate
//============================
		#if EnableSpec == true
		dcmd(lspec,5,cmdtext);
		dcmd(lspecoff,8,cmdtext);
		dcmd(lspecvehicle,12,cmdtext);
		#endif
//==	==========================
// C	ommands (ALL)
//==	==========================
		dcmd(freezeall,9,cmdtext);
		dcmd(unfreezeall,11,cmdtext);
		dcmd(setallcash,10,cmdtext);
		dcmd(setalltime,10,cmdtext);
		dcmd(setallskin,10,cmdtext);
		dcmd(setallscore,11,cmdtext);
		dcmd(setallwanted,12,cmdtext);
		dcmd(setallweather,13,cmdtext);
		dcmd(setallworld,11,cmdtext);
		dcmd(giveallcash,11,cmdtext);
		dcmd(giveallweapon,13,cmdtext);
		dcmd(spawnall,8,cmdtext);
		dcmd(killall,7,cmdtext);
		dcmd(getall,6,cmdtext);
		dcmd(explodeall,10,cmdtext);
		dcmd(kickall,7,cmdtext);
		dcmd(healall,7,cmdtext);
		dcmd(armourall,9,cmdtext);
		dcmd(muteall,7,cmdtext);
		dcmd(unmuteall,9,cmdtext);
		dcmd(slapall,7,cmdtext);
		dcmd(ejectall,8,cmdtext);
		dcmd(disarmall,9,cmdtext);
//============================
// Configuration
//============================
    	dcmd(disable,7,cmdtext);
    	dcmd(enable,6,cmdtext);
    	dcmd(setping,7,cmdtext);
		dcmd(setgravity,10,cmdtext);
    	dcmd(uconfig,7,cmdtext);
    	dcmd(lconfig,7,cmdtext);
    	dcmd(forbidname,10,cmdtext);
    	dcmd(forbidword,10,cmdtext);
//==	==========================
// F	ake Cmds
//==	==========================
    	dcmd(fakedeath,9,cmdtext);
		dcmd(fakechat,8,cmdtext);
		dcmd(fakecmd,7,cmdtext);
//==	==========================
// M	isc
//==	==========================
    	dcmd(admins,6,cmdtext);
    	dcmd(hide,4,cmdtext);
    	dcmd(onduty,6,cmdtext);
    	dcmd(unhide,6,cmdtext);
		dcmd(setmytime,9,cmdtext);
 		dcmd(announce,8,cmdtext);
    	dcmd(announce2,9,cmdtext);
		dcmd(kill,4,cmdtext);
		dcmd(ahelp,5,cmdtext);
		dcmd(level,5,cmdtext);
		dcmd(observations,12,cmdtext);
 		dcmd(lcredits,8,cmdtext);
 		dcmd(serverinfo,10,cmdtext);
    	dcmd(countdown,9,cmdtext);
    	dcmd(duel,4,cmdtext);
    	dcmd(asay,4,cmdtext);
   		dcmd(time,4,cmdtext);
    	dcmd(saveplace,9,cmdtext);
		dcmd(gotoplace,9,cmdtext);
		dcmd(lockserver,10,cmdtext);
		dcmd(unlockserver,12,cmdtext);
    	dcmd(adminarea,9,cmdtext);
    	dcmd(moveplayer,10,cmdtext);
    	dcmd(move,4,cmdtext);
   		dcmd(saveskin,8,cmdtext);
		dcmd(dontuseskin,11,cmdtext);
		dcmd(useskin,7,cmdtext);
 		dcmd(getid,5,cmdtext);
		dcmd(getinfo,7,cmdtext);
   		dcmd(laston,6,cmdtext);
		dcmd(ping,4,cmdtext);
    	dcmd(botcheck,8,cmdtext);
    	dcmd(object,6,cmdtext);
    	dcmd(pickup,6,cmdtext);
    	dcmd(miniguns,8,cmdtext);
    	dcmd(richlist,8,cmdtext);
    	dcmd(aweaps,6,cmdtext);
   		dcmd(lslowmo,7,cmdtext);
    	dcmd(godcar,6,cmdtext);
    	dcmd(die,3,cmdtext);
    	dcmd(lammo,5,cmdtext);
    	dcmd(god,3,cmdtext);
    	dcmd(sgod,4,cmdtext);
    	dcmd(morning,7,cmdtext);
    	dcmd(jetpack,7,cmdtext);
    	dcmd(visible,7,cmdtext);
    	dcmd(invisible,9,cmdtext);
//==	==========================
// D	ialog
//==	==========================
		#if USE_DIALOGS == true
    	dcmd(lmenu,5,cmdtext);
    	dcmd(execcmd,7,cmdtext);
   		dcmd(console,7,cmdtext);
   		dcmd(ctele,5,cmdtext);
   		dcmd(fstyles,7,cmdtext);
		#endif
//============================
// Cam System
//============================
		#if EnableCamHack == true
 		dcmd(lcam,4,cmdtext);
 		dcmd(lockcam,7,cmdtext);
 		dcmd(follow,6,cmdtext);
 		#endif

//==============================================================================
// Commands
//==============================================================================
 	if(strcmp(cmd, "/spam", true) == 0)
	 {
		if(AccInfo[playerid][Level] >= 5)
		{
		    tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, LIGHTBLUE2, "Usage: /spam [Colour] [Text]");
				SendClientMessage(playerid, orange, "Colours: [0]Black, [1]White, [2]Red, [3]Orange, [4]Yellow, [5]Green, [6]Blue, [7]Purple, [8]Brown, [9]Pink");
                SendClientMessage(playerid, orange, "Function: Will sending many messages in chat in specified Colour");
				return 1;
			}
			new Colour = strval(tmp);
			if(Colour > 9 )
			return SendClientMessage(playerid, red, "Colours: [0]Black, [1]White, [2]Red, [3]Orange, [4]Yellow, [5]Green, [6]Blue, [7]Purple, [8]Brown, [9]Pink");
			tmp = strtok(cmdtext, idx);

			format(string,sizeof(string),"%s",cmdtext[8]);

	        if(Colour == 0) 	 for(new i; i < 50; i++) SendClientMessageToAll(black,string);
	        else if(Colour == 1) for(new i; i < 50; i++) SendClientMessageToAll(COLOR_WHITE,string);
	        else if(Colour == 2) for(new i; i < 50; i++) SendClientMessageToAll(red,string);
	        else if(Colour == 3) for(new i; i < 50; i++) SendClientMessageToAll(orange,string);
	        else if(Colour == 4) for(new i; i < 50; i++) SendClientMessageToAll(yellow,string);
	        else if(Colour == 5) for(new i; i < 50; i++) SendClientMessageToAll(COLOR_GREEN1,string);
	        else if(Colour == 6) for(new i; i < 50; i++) SendClientMessageToAll(COLOR_BLUE,string);
	        else if(Colour == 7) for(new i; i < 50; i++) SendClientMessageToAll(COLOR_PURPLE,string);
	        else if(Colour == 8) for(new i; i < 50; i++) SendClientMessageToAll(COLOR_BROWN,string);
	        else if(Colour == 9) for(new i; i < 50; i++) SendClientMessageToAll(COLOR_PINK,string);
			return 1;
		}
		else return ErrorMessages(playerid, 9);
	}


//----------------------------

	if(strcmp(cmd, "/tempban", true) == 0)
	{
		new name[MAX_PLAYER_NAME];
		new giveplayer[MAX_PLAYER_NAME];
		new giveplayerid;

		if(AccInfo[playerid][Level] >= 4)
		{
			tmp = strtok(cmdtext,idx);
			if(!strlen(tmp))
			{
  				SendClientMessage(playerid, LIGHTBLUE2, "Usage: /tempban [PlayerID] [Day(s)] [Reason]");
				SendClientMessage(playerid, orange, "Function: Temporarily bans a player for specified Days");
				return 1;
			}
			giveplayerid = ReturnUser(tmp);
			if(IsPlayerConnected(giveplayerid))
			{
			    tmp = strtok(cmdtext, idx);
			    if (!strlen(tmp))
			    {
				SendClientMessage(playerid, LIGHTBLUE2, "Usage: /tempban [PlayerID] [Day(s)] [Reason]");
				SendClientMessage(playerid, orange, "Function: Temporarily bans a player for specified Days");
				return 1;
				}
				new days = strval(tmp);
				if(!IsNumeric(tmp))
				return SendClientMessage(playerid, lightred, "ERROR: Invalid Day! Only Numbers!");

				if(strval(tmp) <= 0 || strval(tmp) > 1000)
				return SendClientMessage(playerid, lightred, "ERROR: Invalid Day! (1-1000)");

				new reason[128];
				reason = strtok2(cmdtext,idx);
				if (!strlen(reason))
				return SendClientMessage(playerid, lightred, "ERROR: Reason not Specified!");

				if (strlen(reason) <= 0 || strlen(reason) > 100)
				return SendClientMessage(playerid, lightred, "ERROR: Invalid Reason length!");

				new ip[15];
				GetPlayerIp(giveplayerid,ip,15);
				GetPlayerName(playerid, name, sizeof name);
				GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
				new File:tempban = fopen("LuxAdmin/Config/TempBans.ban", io_append);
				if (tempban)
				{
				    new year,month,day;
				    getdate(year, month, day);
				    day += days;
				    if (IsMonth31(month))
				    {
				        if (day > 31)
				        {
				            month += 1;
				            if (month > 12)
				            {
				                year += 1;
				                while(day > 31) day -= 31;
				            }
				            else while(day > 31) day -= 31;
				        }
				    }
				    else if (!IsMonth31(month))
				    {
				        if (day > 30)
				        {
				            month += 1;
				            if (month > 12)
				            {
				                year += 1;
				                while(day > 30) day -= 30;
				            }
				            else while(day > 30) day -= 30;
				        }
				    }
				    else if (!IsMonth31(month) && IsMonth29(year) && month == 2)
				    {
				        if (day > 29)
				        {
				            month += 1;
				            if (month > 12)
				            {
				                year += 1;
				                while(day > 29) day -= 29;
				            }
				            else while(day > 29) day -= 29;
				        }
				    }
				    else if (!IsMonth31(month) && !IsMonth29(year) && month == 2)
				    {
				        if (day > 28)
				        {
				            month += 1;
				            if (month > 12)
				            {
				                year += 1;
				                while(day > 28) day -= 28;
				            }
				            else while(day > 28) day -= 28;
				        }
				    }
				    format(string, sizeof string, "%d|%d|%d|%s\n", day, month, year, ip);
				    fwrite(tempban, string);
				    fclose(tempban);
				}
				format(string,128,"|- Administrator %s Temporarily Banned %s for %d Day(s) | Reason: %s -|",name,giveplayer,days,reason);
				SendClientMessageToAll(lightred,string);
				Kick(giveplayerid);

    			format(string, sizeof string, "Admin %s Temporarily Banned %s for %d Day(s) | Reason: %s",name,giveplayer,days,reason);
			    SaveIn("TempBansLog",string);
			}
			else
			{
			ErrorMessages(playerid, 2);
			}
		}
		else return ErrorMessages(playerid, 1);
		return true;
	}
//------------------------------------------------------------------------------
 	if(strcmp(cmd, "/write", true) == 0)
	 {
	if(AccInfo[playerid][Level] >= 2)
	{
	    tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, LIGHTBLUE2, "Usage: /write [Colour] [Text]");
			SendClientMessage(playerid, orange, "Colours: [0]Black, [1]White, [2]Red, [3]Orange, [4]Yellow, [5]Green, [6]Blue, [7]Purple, [8]Brown, [9]Pink");
            return SendClientMessage(playerid, orange, "Function: Send message in a specified colour");
		 }
		new Colour;
		Colour = strval(tmp);
		if(Colour > 9 )
		{
			SendClientMessage(playerid, LIGHTBLUE2, "Usage: /write [Colour] [Text]");
			SendClientMessage(playerid, orange, "Colours: [0]Black, [1]White, [2]Red, [3]Orange, [4]Yellow, [5]Green, [6]Blue, [7]Purple, [8]Brown, [9]Pink");
            return SendClientMessage(playerid, orange, "Function: Send message in a specified colour");
		}
		tmp = strtok(cmdtext, idx);
        SendCommandToAdmins(playerid,"Write");

        if(Colour == 0) {	format(string,sizeof(string),"%s",cmdtext[9]); SendClientMessageToAll(black,string);return 1;}
        else if(Colour == 1) {
		format(string,sizeof(string),"%s",cmdtext[9]);SendClientMessageToAll(COLOR_WHITE,string); return 1;}
        else if(Colour == 2) {
		format(string,sizeof(string),"%s",cmdtext[9]);SendClientMessageToAll(red,string); return 1;}
        else if(Colour == 3) {
		format(string,sizeof(string),"%s",cmdtext[9]);SendClientMessageToAll(orange,string); return 1;}
        else if(Colour == 4) {
		format(string,sizeof(string),"%s",cmdtext[9]);SendClientMessageToAll(yellow,string); return 1;}
        else if(Colour == 5) {
		format(string,sizeof(string),"%s",cmdtext[9]);SendClientMessageToAll(COLOR_GREEN1,string); return 1;}
        else if(Colour == 6) {
		format(string,sizeof(string),"%s",cmdtext[9]);SendClientMessageToAll(COLOR_BLUE,string); return 1;}
        else if(Colour == 7) {
		format(string,sizeof(string),"%s",cmdtext[9]);SendClientMessageToAll(COLOR_PURPLE,string); return 1;}
        else if(Colour == 8) {
		format(string,sizeof(string),"%s",cmdtext[9]);SendClientMessageToAll(COLOR_BROWN,string); return 1;}
        else if(Colour == 9) {
		format(string,sizeof(string),"%s",cmdtext[9]);SendClientMessageToAll(COLOR_PINK,string); return 1;}
        return 1;
	}
	else return ErrorMessages(playerid, 8);
	}
	return 0;
}

//==============================================================================
// ReturnUser (By Y_Less)
//==============================================================================
ReturnUser(text[], playerid = INVALID_PLAYER_ID)
{
	new pos = 0;
	while (text[pos] < 0x21)
	{
		if (text[pos] == 0) return INVALID_PLAYER_ID;
		pos++;
	}
	new userid = INVALID_PLAYER_ID;
	if (IsNumeric(text[pos]))
	{
		userid = strval(text[pos]);
		if (userid >=0 && userid < MAX_PLAYERS)
		{
			if(!IsPlayerConnected(userid))
				userid = INVALID_PLAYER_ID;
			else return userid;
		}
	}
	new len = strlen(text[pos]);
	new count = 0;
	new pname[MAX_PLAYER_NAME];
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i))
		{
			GetPlayerName(i, pname, sizeof (pname));
			if (strcmp(pname, text[pos], true, len) == 0)
			{
				if (len == strlen(pname)) return i;
				else
				{
					count++;
					userid = i;
				}
			}
		}
	}
	if (count != 1)
	{
		if (playerid != INVALID_PLAYER_ID)
		{
			if (count) SendClientMessage(playerid, red, "ERROR: There are multiple users, enter full playername.");
		}
		userid = INVALID_PLAYER_ID;
	}
	return userid;
}

//==============================================================================
// Server Info
//==============================================================================

//------------
//Players ON
//------------
public ConnectedPlayers()
{
	new Connected;
	for(new i = 0; i < MAX_PLAYERS; i++)
	if(IsPlayerConnected(i))
	Connected++;
	return Connected;
}
//------------
//Players Jailed
//------------
public JailedPlayers()
{
	new JailedCount;
	for(new i = 0; i < MAX_PLAYERS; i++)
	if(IsPlayerConnected(i) && AccInfo[i][Jailed] == 1)
	JailedCount++;
	return JailedCount;
}
//------------
//Players Muted
//------------
public MutedPlayers()
{
	new Count; for(new i = 0; i < MAX_PLAYERS; i++)
	if(IsPlayerConnected(i) && AccInfo[i][Muted] == 1)
	Count++;
	return Count;
}
//------------
//Players Freezed
//------------
public FrozenPlayers()
{
	new FrozenCount; for(new i = 0; i < MAX_PLAYERS; i++)
	if(IsPlayerConnected(i) && AccInfo[i][Frozen] == 1)
	FrozenCount++;
	return FrozenCount;
}
//------------
//In Vehicle Total
//------------
public InVehTotal()
{
	new InVeh; for(new i = 0; i < MAX_PLAYERS; i++)
	if(IsPlayerConnected(i) && IsPlayerInAnyVehicle(i))
	InVeh++;
	return InVeh;
}
//------------
//In Bike
//------------
public OnBikeCount()
{
	new BikeCount;
	for(new i = 0; i < MAX_PLAYERS; i++)
	if(IsPlayerConnected(i) && IsPlayerInAnyVehicle(i))
	{
	new LModel = GetVehicleModel(GetPlayerVehicleID(i));
	switch(LModel)
	{
	case 448,461,462,463,468,471,509,510,521,522,523,581,586:
	BikeCount++;
	}
	}
	return BikeCount;
}

//------------
//In Car
//------------
public InCarCount()
{
	new PInCarCount;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && IsPlayerInAnyVehicle(i))
		{
		new LModel = GetVehicleModel(GetPlayerVehicleID(i));
		switch(LModel)
		{
		case 448,461,462,463,468,471,509,510,521,522,523,581,586:
		{
		}
		default: PInCarCount++;
		}
		}
	}
	return PInCarCount;
}
//------------
//Rcon Admins
//------------
public RconAdminTotal()
{
	new rAdminTotal;
	for(new i = 0; i < MAX_PLAYERS; i++)
	if(IsPlayerConnected(i) && IsPlayerAdmin(i))
	rAdminTotal++;
	return rAdminTotal;
}
//------------
//Admins
//------------
public AdminTotal()
{
	new AdminsCount;
	for(new i = 0; i < MAX_PLAYERS; i++)
	if(IsPlayerConnected(i) && AccInfo[i][Level] >= 1)
	AdminsCount++;
	return AdminsCount;
}
//==============================================================================
//-------------------------------------------------
// RCON Commands
//-------------------------------------------------
//==============================================================================
public OnRconCommand(cmd[])
{
	if( strlen(cmd) > 50 || strlen(cmd) == 1 )
	return print("ERROR: You can not exceed 50 characters!");

//===============================
// (Command) Commands
//===============================
	if(strcmp(cmd, "lrcon", true)==0)
	{
    	print("______________________");
    	print("                      ");
		print(" Rcon Commands        ");
		print(" -------------        ");
		print(" info, execcmd, pm, 	 ");
		print(" asay, uconfig, chat, ");
		print(" aka, ann			 ");
    	print("______________________");
		return true;
	}
//===============================
// (Command) Server Infomation
//===============================
	if(strcmp(cmd, "info", true)==0)
	{
	    new VehTotal = CreateVehicle(411,0,0,0,0,0,0,1000); DestroyVehicle(VehTotal);
		new numo = CreateObject(1245,0,0,1000,0,0,0); 		DestroyObject(numo);
		new nump = CreatePickup(371,2,0,0,1000);       		DestroyPickup(nump);
		new gz = GangZoneCreate(3,3,5,5); 					GangZoneDestroy(gz);

		new model[250], nummodel;
		for(new i=1;i<VehTotal;i++) model[GetVehicleModel(i)-400]++;

		for(new i=0;i<250;i++){
		if(model[i]!=0){
		nummodel++; }
		}
		new string[256];
	    print(" ________________________________________________________________\n");
	    print("                       Server Information                        ");
  	    print("                      --------------------\n");

		format(string,sizeof(string)," Player:\n Connected[%d], Maximum[%d], Ratio[%0.2f]\n",ConnectedPlayers(),GetMaxPlayers(),Float:ConnectedPlayers() / Float:GetMaxPlayers() );
		printf(string);
		format(string,sizeof(string)," Vehicles:\n Total[%d], Models[%d], In Vehicle[%d] (InCar[%d], OnBike[%d])\n",VehTotal-1,nummodel, InVehTotal(), InCarCount(),OnBikeCount());
		printf(string);
		format(string,sizeof(string)," Total:\n Objects[%d], Pickups[%d], GangZones[%d]\n",numo-1, nump, gz);
		printf(string);
		format(string,sizeof(string)," Player Stats:\n Jailed[%d], Frozen[%d], Muted[%d]\n",JailedPlayers(),FrozenPlayers(), MutedPlayers() );
		printf(string);
	    format(string,sizeof(string)," Administration:\n Rcon[%d], Online[%d]\n",AdminTotal(), RconAdminTotal() );
		printf(string);
	    print(" ________________________________________________________________\n");
		return true;
	}

//===============================
// (Command) Player/All execute cmd
//===============================

	if(!strcmp(cmd, "execcmd", .length = 3))
	{
		new	arg_1 = argpos(cmd);
		new arg_2 = argpos(cmd, arg_1);
		new targetid = strval(cmd[arg_1]);

		if (!strcmp(cmd[arg_1], "all", .length = 3) && cmd[arg_2])
		{
			if (cmd[arg_2] == '/')
			{
				for(new i = 0; i <= MAX_PLAYERS; i++)
				if (IsPlayerConnected(i))
				CallRemoteFunction("OnPlayerCommandText", "is", i, cmd[arg_2]);
			}
			else
			{
				for(new i = 0; i <= MAX_PLAYERS; i++)
				if (IsPlayerConnected(i))
				SendPlayerMessageToAll(i, cmd[arg_2]);
			}
			printf("\nRCON: Command \"%s\" executed on all players!\n", cmd[arg_2]);
		}

        else if(!cmd[arg_2] || cmd[arg_1] < '0' || cmd[arg_1] > '9' || targetid > MAX_PLAYERS || targetid < 0)

        print("\n--------------------------") 					 					||
		printf("Usage: \"execcmd (PlayerID(0-%d)/All) (Command)\"",MAX_PLAYERS) 	||
		print("Function: Will force specified player execute command") 				||
		print("--------------------------\n");

		else if ( !IsPlayerConnected(targetid) )
		print("\nERROR: This player is not connected!\n");

		else
		{
			if (cmd[arg_2] == '/')
			CallRemoteFunction("OnPlayerCommandText", "is", targetid, cmd[arg_2]);

			else
			SendPlayerMessageToAll(targetid, cmd[arg_2]);

			new targetname[24];
			GetPlayerName(targetid, targetname, 24);
			printf("Command \"%s\" executed on %s(%d)!",cmd[arg_2], targetname, targetid);
		}

		return true;
	}
//===============================
// (Command) Announce a Message
//===============================
	if(!strcmp(cmd, "ann", .length = 3))
	{
	    new arg_1 = argpos(cmd);
		new message[128];

    	if (!cmd[arg_1] || cmd[arg_1] < '0')
        print("\n--------------------------") 					 		 ||
		print("Usage: \"ann  (Message)\"") 								 ||
		print("Function: Will Send a message in screen for all Players") ||
		print("--------------------------\n");
	    else
	    {
     	format(message, sizeof(message), "[RCON]: %s", cmd[arg_1]);
     	GameTextForAll(message,3000,3);
     	printf("Screen Message '%s' Sent!", cmd[arg_1] );
    	}
	    return true;
	}
//===============================
// (Command) Send Admnistration Msg
//===============================
	if(!strcmp(cmd, "asay", .length = 4))
	{
	    new arg_1 = argpos(cmd);
		new message[128];

    	if (!cmd[arg_1] || cmd[arg_1] < '0')
        print("\n--------------------------") 					 ||
		print("Usage: \"asay  (Message)\"") 					 ||
		print("Function: Will Send a message for online Admins") ||
		print("--------------------------\n");
	    else
		{
     	format(message, sizeof(message), "[RCON] MessageToAdmins: %s", cmd[arg_1]);
      	MessageToAdmins(COLOR_WHITE, message);
        printf("Admin Message '%s' Sent!", cmd[arg_1] );
    	}
	    return true;
	}
//===============================
// (Command) Send Private Message
//===============================
	if(!strcmp(cmd, "pm", .length = 2))
	{
        new arg_1 = argpos(cmd);
		new arg_2 = argpos(cmd, arg_1);
		new targetid = strval(cmd[arg_1]);
		new message[128];

    	if (!cmd[arg_1] || cmd[arg_1] < '0' || cmd[arg_1] > '9' || targetid > MAX_PLAYERS || targetid < 0 || !cmd[arg_2])
        print("\n--------------------------") 								||
		print("Usage: \"pm (PlayerID) (Message)\"") 						||
		print("Function: Will Send a private message for specified player") ||
		print("--------------------------\n");

	    else if(!IsPlayerConnected(targetid)) print("ERROR: Player not connected!");
    	else
	    {
     	format(message, sizeof(message), "[RCON] PM: %s", cmd[arg_2]);
   	 	SendClientMessage(targetid, COLOR_WHITE, message);
     	printf("Rcon PM '%s' Sent!", cmd[arg_1]);
    	}
	    return true;
	}
//===============================
// (Command) Verify player AKA
//===============================
	if(!strcmp(cmd, "aka", .length = 3))
	{
	    new arg_1 = argpos(cmd);
		new targetid = strval(cmd[arg_1]);

    	if (!cmd[arg_1] || cmd[arg_1] < '0' || cmd[arg_1] > '9' || targetid > MAX_PLAYERS || targetid < 0)
        print("\n--------------------------") 					 		   ||
		print("Usage: \"aka  (PlayerID)\"") 							   ||
		print("Function: Will show other names used per Specified Player") ||
		print("--------------------------\n");

	    else if (!IsPlayerConnected(targetid) )
		print("ERROR: Player not Connected!");
    	else
	    {
		new tmp3[50], playername[MAX_PLAYER_NAME];
	  	GetPlayerIp(targetid,tmp3,50);
		GetPlayerName(targetid, playername, sizeof(playername));
		printf("AKA: [%s id:%d] [%s] %s", playername, targetid, tmp3, dini_Get("LuxAdmin/Config/aka.txt",tmp3));
    	}
	    return true;
	}
//===============================
// (Command) Update Configuration
//===============================
	if(strcmp(cmd, "uconfig", true)==0)
	{
		UpdateConfig();
		print("Configuration Successfully Updated!");
		return true;
	}
//===============================
// (Command) Send RCON Message
//===============================
	if(!strcmp(cmd, "msg", .length = 3))
	{
	    new arg_1 = argpos(cmd);
		new message[128];

    	if (!cmd[arg_1] || cmd[arg_1] < '0')
        print("\n--------------------------") 					 		 ||
		print("Usage: \"msg  (Message)\"") 								 ||
		print("Function: Will Send a message in Chat for all Players")   ||
		print("--------------------------\n");
	    else
	    {
     	format(message, sizeof(message), "[RCON]: %s", cmd[arg_1]);
      	SendClientMessageToAll(COLOR_WHITE, message);
      	printf("Message to All '%s' Sent!", cmd[arg_1] );
    	}
	    return true;
	}
//===============================
// (Command) View Game Chat
//===============================
	if(!strcmp(cmd, "chat", .length = 4))
	{
	for(new i = 1; i < MAX_CHAT_LINES; i++) print(Chat[i]);
    return true;
	}
	return 0;
}
//==============================================================================
// Spectate
//==============================================================================
#if EnableSpec == true

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	new x = 0;
	while(x!=MAX_PLAYERS)
	{
    if( IsPlayerConnected(x) &&	GetPlayerState(x) == PLAYER_STATE_SPECTATING &&
	AccInfo[x][SpecID] == playerid && AccInfo[x][SpecType] == ADMIN_SPEC_TYPE_PLAYER)
	{
    SetPlayerInterior(x,newinteriorid);
	}
	x++;
	}
}
//==============================================================================
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	#if ExecuteCmdKey != 0
	if(newkeys == ExecuteCmdKey && AccInfo[playerid][Level] >= 2)
	{
	    return ShowPlayerDialog(playerid, DIALOGID+80, DIALOG_STYLE_INPUT, "LuxAdmin - Execute Command",
		"Simple type a Command! \n\nFor LuxAdmin, for your GameMode, and for any other Filterscript! \n\nExemple: 'ban 0 cheats' (Without '/')", "Exec Cmd", "Cancel");
 	}
 	#endif
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && AccInfo[playerid][SpecID] != INVALID_PLAYER_ID)
	{
	if(newkeys == KEY_JUMP) AdvanceSpectate(playerid);
	else if(newkeys == KEY_SPRINT) ReverseSpectate(playerid);
	}
	#if EnableCamHack == true
	if(AccInfo[playerid][InCamMod] == 1)
	{
		if(newkeys == KEY_CROUCH)
		{
		    KeyState[playerid] = 1;
		}
		else if(newkeys == KEY_SPRINT)
		{
		    KeyState[playerid] = 2;
		}
		else if(newkeys == (KEY_CROUCH+KEY_SPRINT))
		{
		    KeyState[playerid] = 3;
		}
		else if(newkeys == KEY_WALK)
		{
		    KeyState[playerid] = 4;
		}
		else if(newkeys == (KEY_WALK+KEY_SPRINT))
		{
		    KeyState[playerid] = 5;
		}
		else
		{
		    KeyState[playerid] = 0;
		}
	}
	#endif
	return 1;
}

//==============================================================================
public OnPlayerEnterVehicle(playerid, vehicleid)
{
	for(new x=0; x<MAX_PLAYERS; x++)
	{
	    if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && AccInfo[x][SpecID] == playerid)
		{
  		TogglePlayerSpectating(x, 1);
  		PlayerSpectateVehicle(x, vehicleid);
  		AccInfo[x][SpecType] = ADMIN_SPEC_TYPE_VEHICLE;
		}
	}
	return 1;
}

//==============================================================================
public OnPlayerStateChange(playerid, newstate, oldstate)
{
	switch(newstate)
	{
		case PLAYER_STATE_ONFOOT:
		{
		switch(oldstate)
		{
			case PLAYER_STATE_DRIVER: OnPlayerExitVehicle(playerid,255);
			case PLAYER_STATE_PASSENGER: OnPlayerExitVehicle(playerid,255);
			}
		}
	}
	return 1;
}
#endif

//==============================================================================
public OnPlayerExitVehicle(playerid, vehicleid)
{
	if(AccInfo[playerid][DoorsLocked] == 1)
	SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid),playerid,false,false);

	#if EnableSpec == true
	for(new x=0; x<MAX_PLAYERS; x++)
	{
	if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && AccInfo[x][SpecID] == playerid && AccInfo[x][SpecType] == ADMIN_SPEC_TYPE_VEHICLE)
	{
	TogglePlayerSpectating(x, 1);
 	PlayerSpectatePlayer(x, playerid);
 	AccInfo[x][SpecType] = ADMIN_SPEC_TYPE_PLAYER;
	}
	}
	#endif
	return 1;
}

//==============================================================================

#if EnableSpec == true

stock StartSpectate(playerid, specplayerid)
{
	for(new x=0; x<MAX_PLAYERS; x++)
	{
	    if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && AccInfo[x][SpecID] == playerid)
		{
  	     AdvanceSpectate(x);
		}
	}
	SetPlayerInterior(playerid,GetPlayerInterior(specplayerid));
	TogglePlayerSpectating(playerid, 1);

	if(IsPlayerInAnyVehicle(specplayerid))
	{
		PlayerSpectateVehicle(playerid, GetPlayerVehicleID(specplayerid));
		AccInfo[playerid][SpecID] = specplayerid;
		AccInfo[playerid][SpecType] = ADMIN_SPEC_TYPE_VEHICLE;
	}
	else
	{
		PlayerSpectatePlayer(playerid, specplayerid);
		AccInfo[playerid][SpecID] = specplayerid;
		AccInfo[playerid][SpecType] = ADMIN_SPEC_TYPE_PLAYER;
	}
	new string[128], Float:hp, Float:ar;
	GetPlayerName(specplayerid,string,sizeof(string));
	GetPlayerHealth(specplayerid, hp);
	GetPlayerArmour(specplayerid, ar);

	/*for(new i=0; i<MAX_PLAYERS; i++)
	{
		format(string, 256, "~w~- %s(%d) -~n~~n~~y~Health: ~w~%0.1f ~l~- ~y~Armour: ~w~%0.1f ~l~- ~y~Money: ~w~$%d~n~~n~~r~< Sprint - Jump >", string,specplayerid,hp,ar,GetPlayerMoney(specplayerid));
 		TextDrawSetString(GpsTD[i], string);
 		return TextDrawShowForPlayer(playerid,GpsTD[i]);
 	}*/
	return 1;
}

stock StopSpectate(playerid)
{
	TogglePlayerSpectating(playerid, 0);
	AccInfo[playerid][SpecID] = INVALID_PLAYER_ID;
	AccInfo[playerid][SpecType] = ADMIN_SPEC_TYPE_NONE;
	GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~w~~g~Spectate ~w~mode ~r~Ended",1000,3);
	//for(new x=0; x<MAX_PLAYERS; x++) TextDrawHideForPlayer(playerid,GpsTD[x]);
	return 1;
}

stock AdvanceSpectate(playerid)
{
    if(ConnectedPlayers() == 2) { StopSpectate(playerid); return 1; }
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && AccInfo[playerid][SpecID] != INVALID_PLAYER_ID)
	{
	    for(new x=AccInfo[playerid][SpecID]+1; x<=MAX_PLAYERS; x++)
		{
	    	if(x == MAX_PLAYERS) x = 0;
	        if(IsPlayerConnected(x) && x != playerid)
			{
				if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && AccInfo[x][SpecID] != INVALID_PLAYER_ID || (GetPlayerState(x) != 1 && GetPlayerState(x) != 2 && GetPlayerState(x) != 3))
				{
					continue;
				}
				else
				{
					StartSpectate(playerid, x);
					break;
				}
			}
		}
	}
	return 1;
}

stock ReverseSpectate(playerid)
{
    if(ConnectedPlayers() == 2) { StopSpectate(playerid); return 1; }
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && AccInfo[playerid][SpecID] != INVALID_PLAYER_ID)
	{
	    for(new x=AccInfo[playerid][SpecID]-1; x>=0; x--)
		{
	    	if(x == 0) x = MAX_PLAYERS;
	        if(IsPlayerConnected(x) && x != playerid)
			{
				if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && AccInfo[x][SpecID] != INVALID_PLAYER_ID || (GetPlayerState(x) != 1 && GetPlayerState(x) != 2 && GetPlayerState(x) != 3))
				{
					continue;
				}
				else
				{
					StartSpectate(playerid, x);
					break;
				}
			}
		}
	}
	return 1;
}
//-------------------------------------------
public ReturnPosition(playerid)
{
	TogglePlayerControllable(playerid, 1);
	SetPlayerPos(playerid,Pos[playerid][0],Pos[playerid][1],Pos[playerid][2]);
	SetPlayerFacingAngle(playerid,Pos[playerid][3]);
	PlayerPlaySound(playerid,1137,0.0,0.0,0.0);
}
#endif

GetVehicleModelIDFromName(vname[])
{
	for(new i = 0; i < 211; i++)
	{
	if ( strfind(VehicleNames[i], vname, true) != -1 )
	return i + 400;
	}
	return -1;
}
//==============================================================================
// Vehicle Spawn/Delete
//==============================================================================
DelVehicle(vehicleid)
{
    for(new players=0;players<=MAX_PLAYERS;players++)
    {
        new Float:X,Float:Y,Float:Z;
        if (IsPlayerInVehicle(players,vehicleid))
        {
        GetPlayerPos(players,X,Y,Z);
        SetPlayerPos(players,X,Y,Z+2);
        SetVehicleToRespawn(vehicleid);
        }
        SetVehicleParamsForPlayer(vehicleid,players,0,1);
    }
    SetTimerEx("VehRes",3000,0,"d",vehicleid);
    return 1;
}


public CarSpawner(playerid,model)
{
	if(IsPlayerInAnyVehicle(playerid))
	SendClientMessage(playerid, red, "ERROR: You already have a car!");
	else
	{
	    new Float:x, Float:y, Float:z, Float:angle;
		GetPlayerPos(playerid, x, y, z);
	 	GetPlayerFacingAngle(playerid, angle);

		if(AccInfo[playerid][pCar] != -1)
		EraseVeh(AccInfo[playerid][pCar]);
	    new vehicleid=CreateVehicle(model, x, y, z, angle, -1, -1, -1);
		PutPlayerInVehicle(playerid, vehicleid, 0);
		SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
		LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
		ChangeVehicleColor(vehicleid,0,3);
        AccInfo[playerid][pCar] = vehicleid;
	}
	return 1;
}


public EraseVeh(vehicleid)
{
    for(new i=0;i<MAX_PLAYERS;i++)
	{
        new Float:X,Float:Y,Float:Z;
    	if(IsPlayerInVehicle(i, vehicleid))
		{
  		RemovePlayerFromVehicle(i);
  		GetPlayerPos(i,X,Y,Z);
 		SetPlayerPos(i,X,Y+3,Z);
	    }
	    SetVehicleParamsForPlayer(vehicleid,i,0,1);
	}
    SetTimerEx("VehRes",1500,0,"i",vehicleid);
}
public VehRes(vehicleid)
{
    DestroyVehicle(vehicleid);
}

public OnVehicleSpawn(vehicleid)
{
	for(new i=0;i<MAX_PLAYERS;i++)
	{
        if(vehicleid==AccInfo[i][pCar])
		{
		    EraseVeh(vehicleid);
	        AccInfo[i][pCar]=-1;
        }
	}
	return 1;
}

//==============================================================================

//==============================================================================
//-------------------------------------------------
// Dialog Response
//-------------------------------------------------
//==============================================================================
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
#if USE_DIALOGS == true
//==============================================================================
//---------------
// Dialog - SAFETY QUESTION
//---------------
//==============================================================================
	if (dialogid == DIALOG_TYPE_QUESTION)
	{
		if(response == 0)
		{
	 	AccInfo[playerid][NoQuestion] = dUserSetINT(PlayerName2(playerid)).("NoQuestion",1);
	 	}
 		if(response)
	    {
     		if (strlen(inputtext) < 1 || strlen(inputtext) > 60)
			return ShowPlayerDialog(playerid,DIALOG_TYPE_QUESTION,DIALOG_STYLE_INPUT,"LuxAdmin - Account Safety Question","Type a security question, for when you forget\n your password, you just answer this Question.","Next","End");

			new file[256],name[MAX_PLAYER_NAME];
			AccInfo[playerid][NoQuestion] = dUserSetINT(PlayerName2(playerid)).("NoQuestion",0);
			GetPlayerName(playerid,name,sizeof(name));
			format(file,sizeof(file),"/LuxAdmin/Accounts/%s.sav",udb_encode(name));
			dini_Set(file,"Question",inputtext);
			new rstring[256];
			format(rstring,256,"Type a RESPONSE for your Safety Question: \"%s\"",inputtext);
			ShowPlayerDialog(playerid,DIALOG_TYPE_QUESTION+1,DIALOG_STYLE_INPUT,"LuxAdmin - Account Safety Question - RESPONSE",rstring,"Confirm","End");
            PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		}
		return 1;
	}

//==============================================================================
//---------------
// Dialog - SAFETY QUESTION (RESPONSE)
//---------------
//==============================================================================
	if (dialogid == DIALOG_TYPE_QUESTION+1)
	{
		if(response == 0)
		{
 		AccInfo[playerid][NoQuestion] = dUserSetINT(PlayerName2(playerid)).("NoQuestion",1);
	 	}

 		if(response)
	    {
	        if(strlen(inputtext) < 1 || strlen(inputtext) > 40)
	        {
			new rstring[256];
			new file[256],name[MAX_PLAYER_NAME];
			GetPlayerName(playerid,name,sizeof(name));
			new tmp[256];
			dini_Get(file,"Question");
			AccInfo[playerid][NoQuestion] = dUserSetINT(PlayerName2(playerid)).("NoQuestion",0);
			format(rstring,256,"Type a RESPONSE for your Safety Question: \"%s\"",tmp);
			return ShowPlayerDialog(playerid,DIALOG_TYPE_QUESTION+1,DIALOG_STYLE_INPUT,"LuxAdmin - Account Safety Question - RESPONSE",rstring,"Confirm","End");
			}

			new file[256],name[MAX_PLAYER_NAME];
			GetPlayerName(playerid,name,sizeof(name));
			format(file,sizeof(file),"/LuxAdmin/Accounts/%s.sav",udb_encode(name));
			new hashq[145];
			WP_Hash(hashq, sizeof(hashq), inputtext);
			dini_Set(file,"QuestionR",hashq);
			PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		}
		return 1;
	}
//==============================================================================
//---------------
// Dialog - REGISTER
//---------------
//==============================================================================
	if (dialogid == DIALOGID+66)
	{
 		if(response == 0 && ServerInfo[MustRegister] == 1)
		{
			Kick(playerid);
		}
 		if(response)
	    {
			if (strlen(inputtext) < 4 || strlen(inputtext) > 20)
			{
				new rstring[256];
				format(rstring,256,"Sorry %s\n\nThe length of your password should contain more \nthan 3 characters and less than 20 characters! \n\n Please, re-enter the Password:",pName(playerid));
				return ShowPlayerDialog(playerid,DIALOGID+68,DIALOG_STYLE_PASSWORD,"Register Error!",rstring,"Register","Quit");
			}
 			if (udb_Create(PlayerName2(playerid)))
			{
			    ShowPlayerDialog(playerid,DIALOG_TYPE_QUESTION,DIALOG_STYLE_INPUT,"LuxAdmin - Account Safety Question","Type a security question, for when you forget\n your password, you just answer this Question.","Next","End");
				new file[256],name[MAX_PLAYER_NAME], buf[145],tmp3[100];
	 			new strdate[20], year,month,day;
				getdate(year, month, day);
	  			WP_Hash(buf, sizeof(buf), inputtext);
				GetPlayerName(playerid,name,sizeof(name));
				format(file,sizeof(file),"/LuxAdmin/Accounts/%s.sav",udb_encode(name));
				GetPlayerIp(playerid,tmp3,100);
				dini_Set(file,"Password",buf);
				dini_Set(file,"Ip",tmp3);
				dUserSetINT(PlayerName2(playerid)).("Registered",1);
				format(strdate, sizeof(strdate), "%d/%d/%d",day,month,year);
				dini_Set(file,"RegisteredDate",strdate);
				dUserSetINT(PlayerName2(playerid)).("Loggedin",1);
				dUserSetINT(PlayerName2(playerid)).("Banned",0);
				dUserSetINT(PlayerName2(playerid)).("Level",0);
				dUserSetINT(PlayerName2(playerid)).("AccountType",0);
				dUserSetINT(PlayerName2(playerid)).("LastOn",0);
				dUserSetINT(PlayerName2(playerid)).("Money",0);
				dUserSetINT(PlayerName2(playerid)).("Kills",0);
				dUserSetINT(PlayerName2(playerid)).("Deaths",0);
				dUserSetINT(PlayerName2(playerid)).("WantedLevel",0);
				#if SaveScore == true
				dUserSetINT(PlayerName2(playerid)).("Score",0);
				#endif
				dUserSetINT(PlayerName2(playerid)).("Hours",0);
				dUserSetINT(PlayerName2(playerid)).("Minutes",0);
				dUserSetINT(PlayerName2(playerid)).("Seconds",0);
				AccInfo[playerid][LoggedIn] = 1;
				AccInfo[playerid][Registered] = 1;
				SendClientMessage(playerid, green, "|- You are now Registered, and have been automaticaly Logged in! -|");
				PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
				return 1;
			}
		}
		return 1;
	}
//==============================================================================
//---------------
// Dialog - LOGIN
//---------------
//==============================================================================
	if (dialogid == DIALOGID+67)
	{
 		if(response == 0 && ServerInfo[MustLogin] == 1)
		{
			Kick(playerid);
		}
 		if(response)
		{
		    new lstring[256];
			new file[128], Pass[256];
			format(file,sizeof(file),"/LuxAdmin/Accounts/%s.sav",udb_encode(PlayerName2(playerid)));

			Pass = dini_Get(file, "Password");
		 	new buf[145];
		 	WP_Hash(buf, sizeof(buf), inputtext);

		 	AccInfo[playerid][NoQuestion] = dUserINT(PlayerName2(playerid)).("NoQuestion");

		    if(strcmp(Pass, buf, false) == 0)
			{
			    new tmp3[100], string[128];
			   	format(file,sizeof(file),"/LuxAdmin/Accounts/%s.sav",udb_encode(PlayerName2(playerid)));
				GetPlayerIp(playerid,tmp3,100);
				dini_Set(file,"Ip",tmp3);
				LoginPlayer(playerid);
				PlayerPlaySound(playerid,1057,0.0,0.0,0.0);

				if(AccInfo[playerid][Level] > 0)
				{
					switch(AccInfo[playerid][Level])
					{
					case 1: AdmRank = "Basic Moderator";
					case 2: AdmRank = "Moderator";
					case 3: AdmRank = "Master Moderator";
					case 4: AdmRank = "Administrator";
					case 5: AdmRank = "Master Administrator";
					}
					if(AccInfo[playerid][Level] > 5)
					{
						AdmRank = "Professional Admin";
					}
					if(AccInfo[playerid][pVip] > 0)
					{
						switch(AccInfo[playerid][pVip])
						{
						case 1: AccType = "Silver";
						case 2: AccType = "Gold";
						case 3: AccType = "Platinum";
						}
						format(string,sizeof(string),"|- You have Successfully Logged! | Account: %s | Level %d - %s -|", AccType, AccInfo[playerid][Level], AdmRank);
						return SendClientMessage(playerid,0x00C378AA,string);
					}
					else
					{
						format(string,sizeof(string),"|- You have Successfully Logged! | Level %d - %s -|", AccInfo[playerid][Level], AdmRank);
						return SendClientMessage(playerid,green,string);
					}
				}
				else
				{
					if(AccInfo[playerid][pVip] > 0)
					{
						switch(AccInfo[playerid][pVip])
						{
						case 1: AccType = "Silver";
						case 2: AccType = "Gold";
						case 3: AccType = "Platinum";
						}
						format(string,sizeof(string),"|- You have Successfully logged! | Account: %s -|", AccType);
						return SendClientMessage(playerid,0x00C896AA,string);
					}
					else return SendClientMessage(playerid,green,"|- You have Successfully logged! -|");
				}
			}
			else
			{
				AccInfo[playerid][FailLogin]++;
				printf("LOGIN: Failed Login: %s. Wrong password (%s) (%d)", PlayerName2(playerid), inputtext, AccInfo[playerid][FailLogin] );
				if(AccInfo[playerid][FailLogin] == MAX_FAIL_LOGINS)
				{
					new string[128]; format(string, sizeof(string), "|- Player %s has been automatically kicked (Reason: Many attempts Incorrect Passwords) -|", PlayerName2(playerid) );
					SendClientMessageToAll(red, string);
					print(string);
					Kick(playerid);
				}
				if(AccInfo[playerid][NoQuestion] == 1)
				{
					format(lstring,256,"Sorry '%s'\n\nYour entered password is Incorrect!\nPlease, re-enter the Correct Password:",pName(playerid));
					return ShowPlayerDialog(playerid,DIALOGID+69,DIALOG_STYLE_INPUT,"Login Error",lstring,"Login","Quit");
				}
			 	if(AccInfo[playerid][NoQuestion] == 0)
				{
					format(lstring,256,"Sorry '%s'\n\nYour entered password is Incorrect!\nPlease, re-enter the Correct Password:\n\nOr type the response of your security question:\n\n \"%s\"",pName(playerid),dini_Get(file, "Question"));
					return  ShowPlayerDialog(playerid,DIALOGID+69,DIALOG_STYLE_INPUT,"Login Error",lstring,"Login","Quit");
				}
			}
		}
	}
//==============================================================================
//---------------
// Dialog - ERROR PASSWORD
//---------------
//==============================================================================
	if (dialogid == DIALOGID+68)
	{
 		if(response == 0 && ServerInfo[MustRegister] == 1)
		{
			Kick(playerid);
		}
 		if(response)
	    {
			if (strlen(inputtext) < 4 || strlen(inputtext) > 20)
			{
				new rstring[256];
				format(rstring,256,"Sorry %s\n\nThe length of your password should contain more \nthan 3 characters and less than 20 characters! \n\n Please, re-enter the Password:",pName(playerid));
				return ShowPlayerDialog(playerid,DIALOGID+68,DIALOG_STYLE_PASSWORD,"Register Error!",rstring,"Register","Quit");
			}
   			if (udb_Create(PlayerName2(playerid)))
			{
			    ShowPlayerDialog(playerid,DIALOG_TYPE_QUESTION,DIALOG_STYLE_INPUT,"LuxAdmin - Account Safety Question","Type a security question, for when you forget\n your password, you just answer this Question.","Next","End");
	     		new file[256],name[MAX_PLAYER_NAME], buf[145],tmp3[100];
	    		new strdate[20], year,month,day;
				getdate(year, month, day);
	        	WP_Hash(buf, sizeof(buf), inputtext);
				GetPlayerName(playerid,name,sizeof(name));

				format(file,sizeof(file),"/LuxAdmin/Accounts/%s.sav",udb_encode(name));
	     		GetPlayerIp(playerid,tmp3,100);
	     		dini_Set(file,"Password",buf);
		    	dini_Set(file,"Ip",tmp3);
			    dUserSetINT(PlayerName2(playerid)).("Registered",1);
		   		format(strdate, sizeof(strdate), "%d/%d/%d",day,month,year);
				dini_Set(file,"RegisteredDate",strdate);
				dUserSetINT(PlayerName2(playerid)).("Loggedin",1);
				dUserSetINT(PlayerName2(playerid)).("Banned",0);
				dUserSetINT(PlayerName2(playerid)).("Level",0);
				dUserSetINT(PlayerName2(playerid)).("AccountType",0);
			    dUserSetINT(PlayerName2(playerid)).("LastOn",0);
		    	dUserSetINT(PlayerName2(playerid)).("Money",0);
		    	dUserSetINT(PlayerName2(playerid)).("Kills",0);
			   	dUserSetINT(PlayerName2(playerid)).("Deaths",0);
	            dUserSetINT(PlayerName2(playerid)).("WantedLevel",0);
	            #if SaveScore == true
	            dUserSetINT(PlayerName2(playerid)).("Score",0);
	            #endif
			   	dUserSetINT(PlayerName2(playerid)).("Hours",0);
			   	dUserSetINT(PlayerName2(playerid)).("Minutes",0);
			   	dUserSetINT(PlayerName2(playerid)).("Seconds",0);
			    AccInfo[playerid][LoggedIn] = 1;
			    AccInfo[playerid][Registered] = 1;
			    SendClientMessage(playerid, green, "|- You are now Registered, and have been automaticaly Logged in! -|");
				PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
				return 1;
			}
		}
    	return 1;
	}
//==============================================================================
//---------------
// Dialog - INCORRECT PASSWORD
//---------------
//==============================================================================
	if (dialogid == DIALOGID+69)
	{
 		if(response == 0 && ServerInfo[MustLogin] == 1)
		{
			Kick(playerid);
		}
 		if(response)
		{
			new file[128], Pass[256], Question[256];
			new lstring[256];
			format(file,sizeof(file),"/LuxAdmin/Accounts/%s.sav",udb_encode(PlayerName2(playerid)));

			Pass = dini_Get(file, "Password");
		 	new buf[145];
		 	WP_Hash(buf, sizeof(buf), inputtext);

		 	Question = dini_Get(file, "QuestionR");
		 	new buf2[145];
		 	WP_Hash(buf2, sizeof(buf2), inputtext);

		 	AccInfo[playerid][NoQuestion] = dUserINT(PlayerName2(playerid)).("NoQuestion");

            if(AccInfo[playerid][NoQuestion] == 1)
			{
			    if(strcmp(Pass, buf, false) == 0)
				{
				    new tmp3[100], string[128];
				   	format(file,sizeof(file),"/LuxAdmin/Accounts/%s.sav",udb_encode(PlayerName2(playerid)));
					GetPlayerIp(playerid,tmp3,100);
					dini_Set(file,"Ip",tmp3);
					LoginPlayer(playerid);
					PlayerPlaySound(playerid,1057,0.0,0.0,0.0);

					if(AccInfo[playerid][Level] > 0)
					{
						switch(AccInfo[playerid][Level])
						{
						case 1: AdmRank = "Basic Moderator";
						case 2: AdmRank = "Moderator";
						case 3: AdmRank = "Master Moderator";
						case 4: AdmRank = "Administrator";
						case 5: AdmRank = "Master Administrator";
						}
						if(AccInfo[playerid][Level] > 5)
						{
							AdmRank = "Professional Admin";
						}
						if(AccInfo[playerid][pVip] > 0)
						{
							switch(AccInfo[playerid][pVip])
							{
							case 1: AccType = "Silver";
							case 2: AccType = "Gold";
							case 3: AccType = "Platinum";
							}
							format(string,sizeof(string),"|- You have Successfully Logged! | Account: %s | Level %d - %s -|", AccType, AccInfo[playerid][Level], AdmRank);
							return SendClientMessage(playerid,0x00C378AA,string);
						}
						else
						{
							format(string,sizeof(string),"|- You have Successfully Logged! | Level %d - %s -|", AccInfo[playerid][Level], AdmRank);
							return SendClientMessage(playerid,green,string);
						}
					}
					else
					{
						if(AccInfo[playerid][pVip] > 0)
						{
							switch(AccInfo[playerid][pVip])
							{
							case 1: AccType = "Silver";
							case 2: AccType = "Gold";
							case 3: AccType = "Platinum";
       						}
							format(string,sizeof(string),"|- You have Successfully logged! | Account: %s -|", AccType);
							return SendClientMessage(playerid,0x00C896AA,string);
						}
						else return SendClientMessage(playerid,green,"|- You have Successfully logged! -|");
					}
				}
				else
				{
					AccInfo[playerid][FailLogin]++;
					printf("LOGIN: Failed Login: %s. Wrong password (%s) (%d)", PlayerName2(playerid), inputtext, AccInfo[playerid][FailLogin] );
					if(AccInfo[playerid][FailLogin] == MAX_FAIL_LOGINS)
					{
						new string[128]; format(string, sizeof(string), "|- Player %s has been automatically kicked (Reason: Many attempts Incorrect Passwords) -|", PlayerName2(playerid) );
						SendClientMessageToAll(red, string);
						print(string);
						Kick(playerid);
					}
					if(AccInfo[playerid][NoQuestion] == 1)
					{
						format(lstring,256,"Sorry '%s'\n\nYour entered password is Incorrect!\nPlease, re-enter the Correct Password:",pName(playerid));
						return ShowPlayerDialog(playerid,DIALOGID+69,DIALOG_STYLE_INPUT,"Login Error",lstring,"Login","Quit");
					}
					else if(AccInfo[playerid][NoQuestion] == 0)
					{
						format(lstring,256,"Sorry '%s'\n\nYour entered password is Incorrect!\nPlease, re-enter the Correct Password:\n\nOr type the response of your security question:\n\n \"%s\"",pName(playerid),dini_Get(file, "Question"));
						return  ShowPlayerDialog(playerid,DIALOGID+69,DIALOG_STYLE_INPUT,"Login Error",lstring,"Login","Quit");
					}
				}
			}
		 	else
			{
				if(strcmp(Pass, buf, false) == 0 || strcmp(Question, buf2, false) == 0)
				{
				    new tmp3[100], string[128];
				   	format(file,sizeof(file),"/LuxAdmin/Accounts/%s.sav",udb_encode(PlayerName2(playerid)));
					GetPlayerIp(playerid,tmp3,100);
					dini_Set(file,"Ip",tmp3);
					LoginPlayer(playerid);
					PlayerPlaySound(playerid,1057,0.0,0.0,0.0);

					if(AccInfo[playerid][Level] > 0)
					{
						switch(AccInfo[playerid][Level])
						{
						case 1: AdmRank = "Basic Moderator";
						case 2: AdmRank = "Moderator";
						case 3: AdmRank = "Master Moderator";
						case 4: AdmRank = "Administrator";
						case 5: AdmRank = "Master Administrator";
						}
						if(AccInfo[playerid][Level] > 5)
						{
							AdmRank = "Professional Admin";
						}
						if(AccInfo[playerid][pVip] > 0)
						{
							switch(AccInfo[playerid][pVip])
							{
							case 1: AccType = "Silver";
							case 2: AccType = "Gold";
							case 3: AccType = "Platinum";
							}
							format(string,sizeof(string),"|- You have Successfully Logged! | Account: %s | Level %d - %s -|", AccType, AccInfo[playerid][Level], AdmRank);
							return SendClientMessage(playerid,0x00C378AA,string);
						}
						else
						{
							format(string,sizeof(string),"|- You have Successfully Logged! | Level %d - %s -|", AccInfo[playerid][Level], AdmRank);
							return SendClientMessage(playerid,green,string);
						}
					}
					else
					{
						if(AccInfo[playerid][pVip] > 0)
						{
							switch(AccInfo[playerid][pVip])
							{
							case 1: AccType = "Silver";
							case 2: AccType = "Gold";
							case 3: AccType = "Platinum";
							}
							format(string,sizeof(string),"|- You have Successfully logged! | Account: %s -|", AccType);
							return SendClientMessage(playerid,0x00C896AA,string);
						}
						else return SendClientMessage(playerid,green,"|- You have Successfully logged! -|");
					}
				}
				else
				{
     				AccInfo[playerid][FailLogin]++;
					printf("LOGIN: Failed Login: %s. Wrong password (%s) (%d)", PlayerName2(playerid), inputtext, AccInfo[playerid][FailLogin] );
					if(AccInfo[playerid][FailLogin] == MAX_FAIL_LOGINS)
					{
						new string[128]; format(string, sizeof(string), "|- Player %s has been automatically kicked (Reason: Many attempts Incorrect Passwords) -|", PlayerName2(playerid) );
						SendClientMessageToAll(red, string);
						print(string);
						Kick(playerid);
					}
					if(AccInfo[playerid][NoQuestion] == 1)
					{
						format(lstring,256,"Sorry '%s'\n\nYour entered password is Incorrect!\nPlease, re-enter the Correct Password:",pName(playerid));
						return ShowPlayerDialog(playerid,DIALOGID+69,DIALOG_STYLE_INPUT,"Login Error",lstring,"Login","Quit");
					}
					else if(AccInfo[playerid][NoQuestion] == 0)
					{
						format(lstring,256,"Sorry '%s'\n\nYour entered password is Incorrect!\nPlease, re-enter the Correct Password:\n\nOr type the response of your security question:\n\n \"%s\"",pName(playerid),dini_Get(file, "Question"));
						return  ShowPlayerDialog(playerid,DIALOGID+69,DIALOG_STYLE_INPUT,"Login Error",lstring,"Login","Quit");
					}
				}
			}
		}
	}
#endif
//==============================================================================
	new string[128];
	new adminname[MAX_PLAYER_NAME];
	new file[256];
	GetPlayerName(playerid, adminname, sizeof(adminname));
	format(file,sizeof(file),"LuxAdmin/Config/Config.ini");
//==============================================================================
#if USE_DIALOGS == true
//==============================================================================
//Teleport Main
//==============================================================================
	if (dialogid == DIALOGID+70)
	{
		if(response)
 		{
 			if(listitem == 0){ ShowPlayerDialog(playerid,DIALOGID+72,DIALOG_STYLE_INPUT,"Teleport System - Create Teleport","Put in Box the name of new Teleport","Create","Back");}
//-------------------------------------------
			if(listitem == 1)
		  	{
			  	new tcount = 0, tp=0,numrow = 0;
				for(new t=0;t<MAX_CTELES;t++)
				{
				if(CTeleInfo[t][TValid] == 1)
				{
	 			numrow++;
				}
				}
				if(numrow > 0)
				{
				for(new t=0;t<MAX_CTELES;t++)
				{
				if(CTeleInfo[t][TValid] == 1)
				{
				format(string,sizeof(string),"%s %s,",string,CTeleInfo[t][TName]);
				tp++;
				if(tp == CTELE_LINE || tcount == numrow-1)
				{
				strdel(string,strlen(string)-1,strlen(string));
				ShowPlayerDialog(playerid,DIALOGID+73,DIALOG_STYLE_INPUT,"Teleport System - Delete Teleport",string,"Delete","Back");
				format(string,sizeof(string),"%s,\n",string,CTeleInfo[t][TName]);
				tp = 0;
				}
				tcount++;
				}
				}
				} else {
 				GameTextForPlayer(playerid,"~w~~n~~n~~n~~n~~n~There is ~r~no ~w~Teleport created",3000,5);
 				ShowPlayerDialog(playerid,DIALOGID+70,DIALOG_STYLE_LIST,"LuxAdmin - Teleport System:","Create Tele\nDelete Tele\nTeleport","Ok","Cancel");
 				}
 			}
//-------------------------------------------
		  	if(listitem == 2)
	  		{
			  	new tcount = 0, tp=0,numrow = 0;
				for(new t=0;t<MAX_CTELES;t++)
				{
				if(CTeleInfo[t][TValid] == 1)
				{
	 			numrow++;
				}
				}
				if(numrow > 0)
				{
				for(new t=0;t<MAX_CTELES;t++)
				{
				if(CTeleInfo[t][TValid] == 1)
				{
				format(string,sizeof(string),"%s %s,",string,CTeleInfo[t][TName]);
				tp++;
				if(tp == CTELE_LINE || tcount == numrow-1)
				{
				strdel(string,strlen(string)-1,strlen(string));
				ShowPlayerDialog(playerid,DIALOGID+71,DIALOG_STYLE_INPUT,"Teleport System - Teleport:",string,"Tele","Back");
				format(string,sizeof(string),"%s,\n",string,CTeleInfo[t][TName]);
				tp = 0;
				}
				tcount++;
				}
				}
				} else {
				GameTextForPlayer(playerid,"~w~~n~~n~~n~~n~~n~There is ~r~no ~w~Teleport created",3000,5);
				ShowPlayerDialog(playerid,DIALOGID+70,DIALOG_STYLE_LIST,"LuxAdmin - Teleport System:","Create Tele\nDelete Tele\nTeleport","Ok","Cancel");
				}
 				}
			}
		return 1;
	}
//==============================================================================
//Go To Teleport
//==============================================================================
	if (dialogid == DIALOGID+71)
	{
		if(response == 0)
		{
			ShowPlayerDialog(playerid,DIALOGID+70,DIALOG_STYLE_LIST,"LuxAdmin - Teleport System:","Create Tele\nDelete Tele\nTeleport","Ok","Cancel");
		}
 		if(response)
	    {
  			for(new t=0;t<MAX_CTELES;t++)
			{
	    		if(!strlen(inputtext)) return
	    		SendClientMessage(playerid,lightred,"ERROR: Invalid Telepot!");

				if(CTeleInfo[t][TValid] == 0) return
   				SendClientMessage(playerid,lightred,"ERROR: Invalid Telepot!");

				if(strcmp(inputtext,CTeleInfo[t][TName],true) == 0)
	  			{
					if(IsPlayerInAnyVehicle(playerid))
					{
					    SetPlayerInterior(playerid, CTeleInfo[t][PosInt]);
						LinkVehicleToInterior(GetPlayerVehicleID(playerid), CTeleInfo[t][PosInt]);
						SetVehiclePos(GetPlayerVehicleID(playerid),CTeleInfo[t][PosX],CTeleInfo[t][PosY],CTeleInfo[t][PosZ]);
						SetVehicleZAngle(GetPlayerVehicleID(playerid),CTeleInfo[t][PosA]);
					}
					else
					{
					    SetPlayerInterior(playerid, CTeleInfo[t][PosInt]);
						SetPlayerPos(playerid,CTeleInfo[t][PosX],CTeleInfo[t][PosY],CTeleInfo[t][PosZ]);
						SetPlayerFacingAngle(playerid,CTeleInfo[t][PosA]);
					}
					format(string,sizeof(string),"~w~Welcome to ~g~%s",CTeleInfo[t][TName]);
					GameTextForPlayer(playerid,string,2000,5);
					return 1;
				}
			}
		}
		return 1;
	}
//==============================================================================
//Create Teleport
//==============================================================================
	if (dialogid == DIALOGID+72)
	{
		if(response == 0)
		{
		ShowPlayerDialog(playerid,DIALOGID+70,DIALOG_STYLE_LIST,"LuxAdmin - Teleport System:","Create Tele\nDelete Tele\nTeleport","Ok","Cancel");
		}
 		if(response)
	    {
  			for(new t=0;t<MAX_CTELES;t++)
			{
	    	if(!strlen(inputtext)) return
    		SendClientMessage(playerid,lightred,"ERROR: Invalid Telepot!");

            if(CTeleInfo[t][TValid] == 1)
			{
			    if(strcmp(inputtext,CTeleInfo[t][TName],true) == 0)
			    {
       			SendClientMessage(playerid,lightred,"ERROR: Teleportation already exist!");
		        return 1;
		    	}
			}
			new Float:x,Float:y,Float:z,Float:a;
			GetPlayerPos(playerid,x,y,z);
			GetPlayerFacingAngle(playerid,a);

			if(CTeleInfo[t][TValid] == 0)
  			{
				CTeleInfo[t][PosX] 	 = x;
		        CTeleInfo[t][PosY] 	 = y;
		        CTeleInfo[t][PosZ] 	 = z;
		        CTeleInfo[t][PosA] 	 = a;
		        CTeleInfo[t][PosInt] = GetPlayerInterior(playerid);
		        CTeleInfo[t][TValid] = 1;
		        strmid(CTeleInfo[t][TName],inputtext,0,strlen(inputtext),30);
		        GameTextForPlayer(playerid,"~w~~n~~n~~n~~n~~n~Teleport ~g~Created!",3000,5);
		        SaveTeleport();
		        ShowPlayerDialog(playerid,DIALOGID+70,DIALOG_STYLE_LIST,"LuxAdmin - Teleport System:","Create Tele\nDelete Tele\nTeleport","Ok","Cancel");

				new sstring[256];
				format(sstring, sizeof(sstring), "(Created) Tele: %s, Pos: X: %f,Y: %f,Z: %f,Ang:%f,Interior:%d",CTeleInfo[t][TName],CTeleInfo[t][PosX],CTeleInfo[t][PosY],CTeleInfo[t][PosZ],CTeleInfo[t][PosA],CTeleInfo[t][PosInt]);
				SaveIn("TelesLog",sstring);
				return 1;
				}
			}
		}
		return 1;
	}
//==============================================================================
//Delete Teleport
//==============================================================================
	if (dialogid == DIALOGID+73)
	{
		if(response == 0)
		{
		ShowPlayerDialog(playerid,DIALOGID+70,DIALOG_STYLE_LIST,"LuxAdmin - Teleport System:","Create Tele\nDelete Tele\nTeleport","Ok","Cancel");
		}
 		if(response)
	    {
  			for(new t=0;t<MAX_CTELES;t++)
			{
	    		if(!strlen(inputtext)) return
    			SendClientMessage(playerid,lightred,"ERROR: Invalid Telepot!");

	            if(CTeleInfo[t][TValid] == 1)
				{
				    if(strcmp(inputtext,CTeleInfo[t][TName],true) == 0)
				    {
	       				CTeleInfo[t][TValid] = 0;
			        	CTeleInfo[t][PosX] = 0;
			        	CTeleInfo[t][PosY] = 0;
			        	CTeleInfo[t][PosZ] = 0;
				        CTeleInfo[t][PosA] = 0;
				        CTeleInfo[t][PosInt] = 0;
				        GameTextForPlayer(playerid,"~w~~n~~n~~n~~n~~n~Teleport ~r~Deleted!",3000,5);
				        SaveTeleport();
				        ShowPlayerDialog(playerid,DIALOGID+70,DIALOG_STYLE_LIST,"LuxAdmin - Teleport System:","Create Tele\nDelete Tele\nTeleport","Ok","Cancel");

	       				new sstring[256];
						format(sstring, sizeof(sstring), "(Deleted) Tele: %s",CTeleInfo[t][TName]);
						SaveIn("TelesLog",sstring);
			        	return 1;
	    			}
				}
			}
		}
		return 1;
	}
#endif
//==============================================================================
//---------------
// Dialog - Server Password
//---------------
//==============================================================================
	if (dialogid == DIALOG_TYPE_SERVUNLOCK)
	{
 		if(response)
	    {
			format(ServerLockPass, sizeof ServerLockPass, "%s", ServerInfo[Password]);
			ServerInfo[Locked] = 0;
			strmid(ServerInfo[Password], "", 0, strlen(""), 128);
			format(string, sizeof(string), "|- Administrator \"%s\" has Unlocked the Server -|",adminname);
			SendClientMessageToAll(green,string);
			for(new i = 0; i <= MAX_PLAYERS; i++)
			if(IsPlayerConnected(i))
			{
				PlayerPlaySound(i,1057,0.0,0.0,0.0);
				AccInfo[i][AllowedIn] = true;
			}
			SendCommandToAdmins(playerid,"(Only Dialog)UnlockServer");
		}
  		return 1;
	}
//==============================================================================
	if (dialogid == DIALOG_TYPE_SERVLOCK)
	{
 		if(response)
	    {
			format(ServerLockPass, sizeof ServerLockPass, "%s", ServerInfo[Password]);
			ServerInfo[Locked] = 1;
			format(string, sizeof(string), "|- Administrator \"%s\" has Locked the Server -|",adminname);
			SendClientMessageToAll(red,string);
			for(new i = 0; i <= MAX_PLAYERS; i++)
			if(IsPlayerConnected(i))
			{
			PlayerPlaySound(i,1057,0.0,0.0,0.0);
			AccInfo[i][AllowedIn] = true;
			}
			SendCommandToAdmins(playerid,"(Only Dialog)LockServer");
			format(string, sizeof(string), "|- Administrator \"%s\" has set the Server Password to '%s' -|",adminname, ServerInfo[Password]);
		 	MessageToAdmins(COLOR_WHITE, string);
		}
        return 1;
	}
//==============================================================================

	if(dialogid == DIALOG_TYPE_SERVPASS)
	{
	    if (response)
	    {
        	if (!strcmp(ServerLockPass, inputtext) && !(!strlen(inputtext)))
			{
			KillTimer( LockKickTimer[playerid]);
			AccInfo[playerid][AllowedIn] = true;
			SendClientMessage(playerid,COLOR_WHITE,"SERVER: You have successsfully entered the server Password and may now Spawn! ");
			format(string, sizeof(string), "|- %s has Successfully entered server Password -|",PlayerName2(playerid));
		    MessageToAdmins(COLOR_WHITE, string);
			} else {
	  		SendClientMessage(playerid, red, "|- Invalid server password, try again or cancel -|");
	  		ShowPlayerDialog(playerid, DIALOG_TYPE_SERVPASS, DIALOG_STYLE_INPUT, "Server is currently locked.", "Enter the password to access it:", "Enter", "Cancel");
			}
		    } else {
			SendClientMessage(playerid, red, "You have no business here, then.");
	    	Kick(playerid);
	    }
	    return 1;
	}
 //=============================================================================
//---------------
// Dialog - SERVER TWO RCON
//---------------
//==============================================================================
#if EnableTwoRcon == true
	if(dialogid == DIALOG_TYPE_RCON2)
	{
	    if (response)
	    {
        	if (!strcmp(TwoRconPass, inputtext) && !(!strlen(inputtext)))
			{
				GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~g~Authorized ~w~Access!~n~~y~Welcome Administrator!",3000,3);
			}
			else
			{
				if(AccInfo[playerid][MaxRcon] == 3)
				{
					SendClientMessage(playerid, red, "|- You has been Automatically Kicked! Reason: Maximum number of 'TwoRcon' attempts has reached -|");
				 	Kick(playerid);
				}
				AccInfo[playerid][MaxRcon]++;
				new tmp[140];
	  			SendClientMessage(playerid, red, "|- Invalid Rcon Password! -|");
   				format(tmp,sizeof(tmp),"Invalid Password!. \n\nFor access the account, you must enter the CORRECT second password RCON.\n\nAttempts: %d/3", AccInfo[playerid][MaxRcon]);
				ShowPlayerDialog(playerid, DIALOG_TYPE_RCON2, DIALOG_STYLE_INPUT, "LuxAdmin - RCON!",tmp, "Enter", "Exit");
			}
   		}
		else
		{
			SendClientMessage(playerid, red, "|- ERROR: Kicked! -|");
	    	return Kick(playerid);
	    }
	    return 1;
	}
#endif

#if USE_DIALOGS == true
 //=============================================================================
//---------------
// Dialog - Main
//---------------
//==============================================================================
	if(dialogid == DIALOGID+1)
    {
        if(response == 0)
		{
		TogglePlayerControllable(playerid,true);
		}
		if(response)
		{

		    //---------------------------------------------------
		    // Enable
		    //---------------------------------------------------
		    if(listitem == 0) // Enable
			{
			if(AccInfo[playerid][Level] >= 4)
			ShowPlayerDialog(playerid, DIALOGID+2, DIALOG_STYLE_LIST,
			"Enable", "AntiSwear\nNameKick\nAntiSpam\nMaxPing\nReadCmds\nReadPMs\nNoCaps\nConnectMessages\nAdminCmdMessages\nAutoLogin\nAnti Forbidden Weaps\nAnti Advertisements\nAnnouncements", "Select", "Back") && TogglePlayerControllable(playerid,true);
   			else
			{
			ErrorMessages(playerid, 1);
			TogglePlayerControllable(playerid,true);
			}
			}
			//---------------------------------------------------
		    // Disable
		    //---------------------------------------------------
			if(listitem == 1) // Disable
			{
  	  	  	if(AccInfo[playerid][Level] >= 4)
			ShowPlayerDialog(playerid, DIALOGID+3, DIALOG_STYLE_LIST,
			"Disable", "AntiSwear\nNameKick\nAntiSpam\nMaxPing\nReadCmds\nReadPMs\nNoCaps\nConnectMessages\nAdminCmdMessages\nAutoLogin\nAnti Forbidden Weaps\nAnti Advertisements\nAnnouncements", "Select", "Back") && TogglePlayerControllable(playerid,true);
	        else
            {
			ErrorMessages(playerid, 1);
			TogglePlayerControllable(playerid,true);
			}
			}
			//---------------------------------------------------
		    // Server Weather
		    //---------------------------------------------------
			if(listitem == 2) //Server Weather
			{
			if(AccInfo[playerid][Level] >= 3)
			{
        	if(IsPlayerInAnyVehicle(playerid))
			{
			return ShowPlayerDialog(playerid, DIALOGID+16, DIALOG_STYLE_LIST,
			"Server Weather", "Blue Sky\nSand Storm\nThunderstorm\nFoggy\nCloudy\nHigh Tide\nPurple Sky\nBlack/White Sky\nDark, Green Sky\nHeatwave", "Select", "Back") &&
			TogglePlayerControllable(playerid,true);
        	}
			else
			return ShowPlayerDialog(playerid, DIALOGID+16, DIALOG_STYLE_LIST,
			"Server Weather", "Blue Sky\nSand Storm\nThunderstorm\nFoggy\nCloudy\nHigh Tide\nPurple Sky\nBlack/White Sky\nDark, Green Sky\nHeatwave", "Select", "Back") &&
			TogglePlayerControllable(playerid,true);
        	}
    		else return ErrorMessages(playerid, 1) && TogglePlayerControllable(playerid,true);
			}
			//---------------------------------------------------
		    // Server Time
		    //---------------------------------------------------
			if(listitem == 3) //Server Time
			{
			if(AccInfo[playerid][Level] >= 3)
			{
            if(IsPlayerInAnyVehicle(playerid))
		    {
            TogglePlayerControllable(playerid,true);
			return ShowPlayerDialog(playerid, DIALOGID+17, DIALOG_STYLE_LIST,
			"Server Time", "Morning\nMid day\nAfternoon\nEvening\nMidnight", "Select", "Back") &&
			TogglePlayerControllable(playerid,true);
            }
		    else
			return ShowPlayerDialog(playerid, DIALOGID+17, DIALOG_STYLE_LIST,
			"Server Time", "Morning\nMid day\nAfternoon\nEvening\nMidnight", "Select", "Back");
    		}
			else
			return ErrorMessages(playerid, 1) && TogglePlayerControllable(playerid,true);
			}
			//---------------------------------------------------
		    // Vehicles
		    //---------------------------------------------------
			if(listitem == 4) //Vehicles
			{
     	  	if(AccInfo[playerid][Level] >= 2)
			{
 			if(IsPlayerInAnyVehicle(playerid))
	   	    return TogglePlayerControllable(playerid,true) && SendClientMessage(playerid,red,"ERROR: You already have a car.");
        	else
			{
			ShowPlayerDialog(playerid, DIALOGID+40, DIALOG_STYLE_LIST,
			"LuX Vehicles","Bicycles\nBikes\nMonster Trucks\nBoats\nHelicopters\nPlanes\nCars\nVehicles RC","Select", "Cancel");
			}
   			}
			else return ErrorMessages(playerid, 1);
            }
			//---------------------------------------------------
		    // Tune Menu
		    //---------------------------------------------------
			if(listitem == 5) //Tuning Menu
		    {
		 	if(AccInfo[playerid][Level] >= 2)
			{
			if(IsPlayerInAnyVehicle(playerid))
			{
			new LVehicleID = GetPlayerVehicleID(playerid), LModel = GetVehicleModel(LVehicleID);
		    switch(LModel)
			{
			case 448,461,462,463,468,471,509,510,521,522,523,581,586,449:
			{
			SendClientMessage(playerid,red,"ERROR: You can not tune this vehicle");
			TogglePlayerControllable(playerid,true);
			return 1;
			}
			}
			TogglePlayerControllable(playerid,true);
            ShowPlayerDialog(playerid, DIALOGID+13, DIALOG_STYLE_LIST, "Tune Menu",
	  	    "Nitrox\nHydraulics\nWheels\nPaint Jobs\nColours", "Select", "Back");
		    }
			else
			{
			SendClientMessage(playerid,red,"ERROR: You do not have a vehicle to tune");
			TogglePlayerControllable(playerid,true);
			}
    	    }
			else
			{
			ErrorMessages(playerid, 1);
			TogglePlayerControllable(playerid,true);
			}
			}
			//---------------------------------------------------
		    // Choose Weapon
		    //---------------------------------------------------
			if(listitem == 6) //Choose Weapon
			{
		    if(AccInfo[playerid][Level] >= 3)
		    {
        	if(IsPlayerInAnyVehicle(playerid))
			{
        	TogglePlayerControllable(playerid,true);
			return ShowPlayerDialog(playerid, DIALOGID+20, DIALOG_STYLE_LIST,
			"Weapons", "Machine Guns\nPistols\nRifles\nShotguns\nHeavy Assault\nSpecial Weapons\nHand Held\nMelee \nProjectile", "Select", "Back");
        	}
			else
			return ShowPlayerDialog(playerid, DIALOGID+20, DIALOG_STYLE_LIST, "Weapons", "Machine Guns\nPistols\nRifles\nShotguns\nHeavy Assault\nSpecial Weapons\nHand Held\nMelee \nProjectile", "Select", "Back") && TogglePlayerControllable(playerid,true);
    		} else
			return
			ErrorMessages(playerid, 1) && TogglePlayerControllable(playerid,true);
			}
			//---------------------------------------------------
		    // Teleports
		    //---------------------------------------------------
			if(listitem == 7) //Teleports
			{
		    if(AccInfo[playerid][Level] >= 2)
		    {
        	if(IsPlayerInAnyVehicle(playerid))
			{
        	TogglePlayerControllable(playerid,true);
			return ShowPlayerDialog(playerid, DIALOGID+30, DIALOG_STYLE_LIST,
			"Select City", "Los Santos\nSan Fierro\nLas Venturas", "Select", "Back");
        	}
			else
			return ShowPlayerDialog(playerid, DIALOGID+30, DIALOG_STYLE_LIST, "Select City", "Los Santos\nSan Fierro\nLas Venturas", "Select", "Back") && TogglePlayerControllable(playerid,true);
    		}
			else
			return
			ErrorMessages(playerid, 1) && TogglePlayerControllable(playerid,true);
			}
   		}
		return 1;
  	}
//===============================
//---------------
// Dialog - Enable
//---------------
//===============================
	if(dialogid == DIALOGID+2)
	{
	    if(response == 0)
		{
        ShowPlayerDialog(playerid, DIALOGID+1, DIALOG_STYLE_LIST, "LuxAdmin Main Menu",
  		"Enable\nDisable\nServer Weather\nServer Time\nVehicles\nTuning Menu\nWeapons\nTeleports", "Select", "Cancel");
		}

		if(response)
		{
      		if(listitem == 0) // AntiSwear
			{
 	 			 ServerInfo[AntiSwear] = 1;
 	 			 dini_IntSet(file,"AntiSwear",1);
 	 			 format(string,sizeof(string),"|- Administrator %s has enabled AntiSwear -|",adminname);
 	             SendClientMessageToAll(0x00A700FF,string);
            }
            if(listitem == 1) // NameKick
			{
	  			 ServerInfo[NameKick] = 1;
		 		 dini_IntSet(file,"NameKick",1);
	  			 format(string,sizeof(string),"|- Administrator %s has enabled NameKick -|",adminname);
	  			 SendClientMessageToAll(0x00A700FF,string);
			}
			if(listitem == 2) //AntiSpam
			{
				 ServerInfo[AntiSpam] = 1;
				 dini_IntSet(file,"AntiSpam",1);
				 format(string,sizeof(string),"|- Administrator %s has enabled AntiSpam -|",adminname);
				 SendClientMessageToAll(0x00A700FF,string);
			}
			if(listitem == 3) //MaxPing
			{
				 ServerInfo[MaxPing] = 1000;
				 dini_IntSet(file,"MaxPing",1000);
			     format(string,sizeof(string),"|- Administrator %s has enabled Ping Kick -|",adminname);
				 SendClientMessageToAll(0x00A700FF,string);
			}
			if(listitem == 4) //Read Commands
			{
                 ServerInfo[ReadCmds] = 1;
				 dini_IntSet(file,"ReadCmds",1);
				 format(string,sizeof(string),"|- Administrator %s has enabled Reading Commands -|",adminname);
				 MessageToAdmins(orange,string);
			}
			if(listitem == 5) //Read PM's
			{
				 ServerInfo[ReadPMs] = 1;
				 dini_IntSet(file,"ReadPMs",1);
				 format(string,sizeof(string),"|- Administrator %s has enabled Reading Pms -|",adminname);
				 MessageToAdmins(orange,string);
			}
			if(listitem == 6) //Permit CapsLock
			{
				 ServerInfo[NoCaps] = 0;
				 dini_IntSet(file,"NoCaps",0);
				 format(string,sizeof(string),"|- Administrator %s has allowed Captial Letters in Chat -|",adminname);
				 SendClientMessageToAll(0x00A700FF,string);
			}
			if(listitem == 7) //Connect/Disconnect Messages
			{
				 ServerInfo[ConnectMessages] = 1;
				 dini_IntSet(file,"ConnectMessages",1);
				 format(string,sizeof(string),"|- Administrator %s has enabled Connect Messages -|",adminname);
				 SendClientMessageToAll(0x00A700FF,string);
			}
			if(listitem == 8) //Command Messages
			{
				 ServerInfo[AdminCmdMsg] = 1;
				 dini_IntSet(file,"AdminCmdMessages",1);
				 format(string,sizeof(string),"|- Administrator %s has enabled Admin Command messages -|",adminname);
				 MessageToAdmins(orange,string);
			}
			if(listitem == 9) //Auto Login
			{
				 ServerInfo[AutoLogin] = 1;
				 dini_IntSet(file,"AutoLogin",1);
				 format(string,sizeof(string),"|- Administrator %s has enabled Auto Login -|",adminname);
				 SendClientMessageToAll(0x00A700FF,string);
			}
  			if(listitem == 10) //Anti Forbidden Weapons
			{
				 ServerInfo[ForbiddenWeaps] = 1;
				 dini_IntSet(file,"ForbiddenWeapons",1);
				 format(string,sizeof(string),"|- Administrator %s has enabled Anti Forbidden Weapons -|",adminname);
				 SendClientMessageToAll(0x00A700FF,string);
				 SendClientMessage(playerid, orange, "|- To update Forbidden Weapons File use: /uconfig -|");
			}
  			if(listitem == 11) //Anti Advertisements
			{
				 ServerInfo[AntiAds] = 1;
				 dini_IntSet(file,"AntiAdvertisements",1);
				 format(string,sizeof(string),"|- Administrator %s has enabled Anti Advertisements -|",adminname);
			     MessageToAdmins(orange,string);
			}
  			if(listitem == 12) //Announcements
			{
				 ServerInfo[AntiAds] = 1;
				 dini_IntSet(file,"Announcements",1);
				 format(string,sizeof(string),"|- Administrator %s has enabled Announcements! -|",adminname);
			     MessageToAdmins(orange,string);
			     OnPlayerCommandText(playerid,"/uconfig");
			     SetTimer("RandomMessage",ANNOUNCES_TIME,1);
			     for(new i = 0; i < MAX_PLAYERS; i++)
				 TextDrawShowForPlayer(i, Announcements);
			}
   		}
		return 1;
  	}
//===============================
//---------------
// Dialog - Console
//---------------
//===============================
	if(dialogid == DIALOGID+61)
	{
		if(response)
		{
  		if(listitem == 0) { ShowPlayerDialog(playerid,DIALOGID+62,DIALOG_STYLE_INPUT,"LuxAdmin Console","Load FilterScript:\n","Load!","Back");}
    	if(listitem == 1) { ShowPlayerDialog(playerid,DIALOGID+63,DIALOG_STYLE_INPUT,"LuxAdmin Console","Unload FilterScript:\n","Unload!","Back");}
    	if(listitem == 2) { ShowPlayerDialog(playerid,DIALOGID+64,DIALOG_STYLE_INPUT,"LuxAdmin Console","Changemode:\n","Unload!","Back");}
		if(listitem == 3) { OnFilterScriptExit(); SetTimer("RestartGM",5000,0); SendClientMessage(playerid,orange,"|- Console Command Sent! -|"); format(string,sizeof(string),"|- %s has been Restarted Server",pName(playerid),inputtext); SaveIn("ConsoleLog",string);}
		if(listitem == 4){  SendRconCommand("loadfs LuxAdmin"); return SendClientMessage(playerid,orange,"|- Console Command Sent! -|");}
		if(listitem == 5){  SendRconCommand("unloadfs LuxAdmin"); return SendClientMessage(playerid,orange,"|- Console Command Sent! -|");}
		if(listitem == 6){  SendRconCommand("reloadfs LuxAdmin"); return SendClientMessage(playerid,orange,"|- Console Command Sent! -|");}
		if(listitem == 7){  return ShowPlayerDialog(playerid,DIALOGID+65,DIALOG_STYLE_INPUT,"LuxAdmin Console","Unban IP:\n","Unban!","Back");}
		if(listitem == 8){  SendRconCommand("reloadbans"); SendClientMessage(playerid,orange,"|- Console Command Sent! -|"); }
		if(listitem == 9){  ShowPlayerDialog(playerid, DIALOGID+80, DIALOG_STYLE_INPUT, "LuxAdmin - Execute Command","Simple type a Command! \n\nFor LuxAdmin, for your GameMode, and for any other Filterscript! \n\nExemple: 'ban 0 cheats' (Without '/')", "Exec Cmd", "Cancel"); }
  		}
		return 1;
  	}
//===============================
// Dialog - LOADFS
//===============================
	if(dialogid == DIALOGID+62)
	{
 		if(response == 0) { ShowPlayerDialog(playerid, DIALOGID+61, DIALOG_STYLE_LIST, "LuxAdmin - Console", "Load Filterscript\nUnload Filterscript\nChange Mode\nRestart (Gmx)\nLoad LuxAdmin\nUnload LuxAdmin\nReload LuxAdmin\nUnban IP\nReload Bans\nExecute Command", "Select", "Cancel"); }
		if(response){
	 	new str[256];
		format(string,sizeof(string),"%s has been Loaded '%s' Filterscript",pName(playerid),inputtext); SaveIn("ConsoleLog",string);
	 	format(str,sizeof(string),"loadfs %s",inputtext);
	 	SendRconCommand(str);
	 	SendClientMessage(playerid,orange,"|- Console Command Sent! -|");
	 	ShowPlayerDialog(playerid, DIALOGID+61, DIALOG_STYLE_LIST, "LuxAdmin - Console", "Load Filterscript\nUnload Filterscript\nChange Mode\nRestart (Gmx)\nLoad LuxAdmin\nUnload LuxAdmin\nReload LuxAdmin\nUnban IP\nReload Bans\nExecute Command", "Select", "Cancel");
	 	}
		return 1;
  	}
 //===============================
// Dialog - UNLOADFS
//===============================
	if(dialogid == DIALOGID+63)
	{
  		if(response == 0) { ShowPlayerDialog(playerid, DIALOGID+61, DIALOG_STYLE_LIST, "LuxAdmin - Console", "Load Filterscript\nUnload Filterscript\nChange Mode\nRestart (Gmx)\nLoad LuxAdmin\nUnload LuxAdmin\nReload LuxAdmin\nUnban IP\nReload Bans\nExecute Command", "Select", "Cancel"); }
		if(response) {
	 	new str[256];
	 	format(string,sizeof(string),"%s has been Unloaded '%s' Filterscript",pName(playerid),inputtext); SaveIn("ConsoleLog",string);
	 	format(str,sizeof(string),"unloadfs %s",inputtext);
	 	SendRconCommand(str);
	 	SendClientMessage(playerid,orange,"|- Console Command Sent! -|");
	 	ShowPlayerDialog(playerid, DIALOGID+61, DIALOG_STYLE_LIST, "LuxAdmin - Console", "Load Filterscript\nUnload Filterscript\nChange Mode\nRestart (Gmx)\nLoad LuxAdmin\nUnload LuxAdmin\nReload LuxAdmin\nUnban IP\nReload Bans\nExecute Command", "Select", "Cancel");
	 	}
		return 1;
  	}
 //===============================
// Dialog - CHANGEMODE
//===============================
	if(dialogid == DIALOGID+64)
	{
 		if(response == 0) { ShowPlayerDialog(playerid, DIALOGID+61, DIALOG_STYLE_LIST, "LuxAdmin - Console", "Load Filterscript\nUnload Filterscript\nChange Mode\nRestart (Gmx)\nLoad LuxAdmin\nUnload LuxAdmin\nReload LuxAdmin\nUnban IP\nReload Bans\nExecute Command", "Select", "Cancel"); }
		if(response) {
	 	new str[256];
	 	format(string,sizeof(string),"%s has been Changed '%s' GameMode",pName(playerid),inputtext); SaveIn("ConsoleLog",string);
	 	format(str,sizeof(string),"changemode %s",inputtext);
	 	SendRconCommand(str);
	 	SendClientMessage(playerid,orange,"|- Console Command Sent! -|");
	 	}
		return 1;
  	}
//===============================
// Dialog - EXECUTE COMMAND
//===============================
	if(dialogid == DIALOGID+80)
	{
		if(response)
		{
		new str[128];
		format(str,sizeof(str),"/%s",inputtext);
		CallRemoteFunction("OnPlayerCommandText", "is",playerid, str);
	 	}
		return 1;
  	}
//===============================
// Dialog - UNBANIP
//===============================
	if(dialogid == DIALOGID+65)
	{
 		if(response == 0) { ShowPlayerDialog(playerid, DIALOGID+61, DIALOG_STYLE_LIST, "LuxAdmin - Console", "Load Filterscript\nUnload Filterscript\nChange Mode\nRestart (Gmx)\nLoad LuxAdmin\nUnload LuxAdmin\nReload LuxAdmin\nUnban IP\nReload Bans\nExecute Command", "Select", "Cancel"); }
		if(response) {
	 	new str[256];
		format(string,sizeof(string),"%s has been Unbaned '%s' Ip",pName(playerid),inputtext); SaveIn("ConsoleLog",string);
	 	format(str,sizeof(string),"unbanip %s",inputtext);
	 	SendRconCommand(str);
	 	SendClientMessage(playerid,orange,"|- Console Command Sent! -|");
		ShowPlayerDialog(playerid, DIALOGID+61, DIALOG_STYLE_LIST, "LuxAdmin - Console", "Load Filterscript\nUnload Filterscript\nChange Mode\nRestart (Gmx)\nLoad LuxAdmin\nUnload LuxAdmin\nReload LuxAdmin\nUnban IP\nReload Bans\nExecute Command", "Select", "Cancel");
	 	}
		return 1;
  	}

//===============================
//---------------
// Dialog - Fight Styles
//---------------
//===============================
	if(dialogid == DIALOGID+81)
	{
		if(response)
		{
			if(listitem == 0)
			{
				SetPlayerFightingStyle (playerid, FIGHT_STYLE_ELBOW);
				GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~g~Elbow ~w~Style Changed!",2000,3);
			}
			if(listitem == 1)
			{
				SetPlayerFightingStyle (playerid, FIGHT_STYLE_BOXING);
				GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~g~Boxing ~w~Style Changed!",2000,3);
			}
			if(listitem == 2)
			{
			    SetPlayerFightingStyle (playerid, FIGHT_STYLE_GRABKICK);
			    GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~g~Grabkick ~w~Style Changed!",2000,3);
			}
			if(listitem == 3)
			{
				SetPlayerFightingStyle (playerid, FIGHT_STYLE_KNEEHEAD);
				GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~g~Nheehead ~w~Style Changed!",2000,3);
			}
			if(listitem == 4)
			{
			    SetPlayerFightingStyle (playerid, FIGHT_STYLE_KUNGFU);
			    GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~g~KungFu ~w~Style Changed!",2000,3);
			}
			if(listitem == 5)
			{
				SetPlayerFightingStyle (playerid, FIGHT_STYLE_NORMAL);
				GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~g~Normal ~w~Style Changed!",2000,3);
			}
		}
		return 1;
	}
//===============================
//---------------
// Dialog - Disable
//---------------
//===============================
	if(dialogid == DIALOGID+3)
	{
	    if(response == 0)
		{
        ShowPlayerDialog(playerid, DIALOGID+1, DIALOG_STYLE_LIST, "LuxAdmin Main Menu",
  		"Enable\nDisable\nServer Weather\nServer Time\nVehicles\nTuning Menu\nWeapons\nTeleports", "Select", "Cancel");
		}

		if(response)
		{
		    if(listitem == 0) // AntiSwear
		    {
            	ServerInfo[AntiSwear] = 0;
				dini_IntSet(file,"AntiSwear",0);
            	format(string,sizeof(string),"|- Administrator %s has disabled AntiSwear",adminname);
				SendClientMessageToAll(0x21DD00FF,string);
            }
            if(listitem == 1) // NameKick
			{
			    ServerInfo[NameKick] = 0;
				dini_IntSet(file,"NameKick",0);
				format(string,sizeof(string),"|- Administrator %s has disabled NameKick -|",adminname);
				SendClientMessageToAll(0x21DD00FF,string);
			}
			if(listitem == 2) //AntiSpam
			{
				 ServerInfo[AntiSpam] = 0;
				 dini_IntSet(file,"AntiSpam",0);
				 format(string,sizeof(string),"|- Administrator %s has disabled AntiSpam -|",adminname);
				 SendClientMessageToAll(0x21DD00FF,string);
			}
			if(listitem == 3) //MaxPing
			{
				 ServerInfo[MaxPing] = 0;
				 dini_IntSet(file,"MaxPing",0);
			     format(string,sizeof(string),"|- Administrator %s has disabled Ping Kick -|",adminname);
				 SendClientMessageToAll(0x21DD00FF,string);
			}
			if(listitem == 4) //Read Commands
			{
                 ServerInfo[ReadCmds] = 0;
				 dini_IntSet(file,"ReadCmds",0);
				 format(string,sizeof(string),"|- Administrator %s has disabled Reading Commands -|",adminname);
				 MessageToAdmins(orange,string);
			}
			if(listitem == 5) //Read PM's
			{
				 ServerInfo[ReadPMs] = 0;
				 dini_IntSet(file,"ReadPMs",0);
				 format(string,sizeof(string),"|- Administrator %s has disabled Reading Pms -|",adminname);
				 MessageToAdmins(orange,string);
			}
			if(listitem == 6) //Permit CapsLock
			{
				 ServerInfo[NoCaps] = 1;
				 dini_IntSet(file,"NoCaps",1);
				 format(string,sizeof(string),"|- Administrator %s has prevented Captial Letters in Chat -|",adminname);
				 SendClientMessageToAll(0x21DD00FF,string);
			}
			if(listitem == 7) //Connect/Disconnect Messages
			{
				 ServerInfo[ConnectMessages] = 0;
				 dini_IntSet(file,"ConnectMessages",0);
				 format(string,sizeof(string),"|- Administrator %s has disabled Connect Messages -|",adminname);
				 SendClientMessageToAll(0x21DD00FF,string);
			}
			if(listitem == 8) //Command Messages
			{
				 ServerInfo[AdminCmdMsg] = 0;
				 dini_IntSet(file,"AdminCmdMessages",0);
				 format(string,sizeof(string),"|- Administrator %s has disabled Admin Command nessages -|",adminname);
				 MessageToAdmins(orange,string);
			}
			if(listitem == 9) //Auto Login
			{
				 ServerInfo[AutoLogin] = 0;
				 dini_IntSet(file,"AutoLogin",0);
				 format(string,sizeof(string),"|- Administrator %s has disabled Auto Kogin -|",adminname);
				 SendClientMessageToAll(0x21DD00FF,string);
			}
  			if(listitem == 10) //Anti Forbidden Weapons
			{
				 ServerInfo[ForbiddenWeaps] = 0;
				 dini_IntSet(file,"ForbiddenWeapons",0);
				 format(string,sizeof(string),"|- Administrator %s has disabled Anti Forbidden Weapons -|",adminname);
				 SendClientMessageToAll(0x00A700FF,string);
			}
  			if(listitem == 11) //Anti Advertisements
			{
				 ServerInfo[AntiAds] = 0;
				 dini_IntSet(file,"AntiAdvertisements",0);
				 format(string,sizeof(string),"|- Administrator %s has disabled Anti Advertisements -|",adminname);
				 MessageToAdmins(orange,string);
			}
  			if(listitem == 12) //Announcements
			{
				 ServerInfo[AntiAds] = 0;
				 dini_IntSet(file,"Announcements",0);
				 format(string,sizeof(string),"|- Administrator %s has disabled Announcements! -|",adminname);
				 for(new i = 0; i < MAX_PLAYERS; i++)
				 TextDrawHideForPlayer(i, Announcements);

				 MessageToAdmins(orange,string);
			}
		}
		return 1;
  	}
//==============================================================================
//---------------
// VEHICLES
//---------------
//==============================================================================

	if(dialogid == DIALOGID+40)
	{
	    if(response == 0){
		ShowPlayerDialog(playerid, DIALOGID+1, DIALOG_STYLE_LIST, "LuxAdmin Main Menu","Enable\nDisable\nServer Weather\nServer Time\nVehicles\nTuning Menu\nWeapons\nTeleports", "Select", "Cancel");}
		if(response)
        {
		if(listitem == 0){ ShowPlayerDialog(playerid, DIALOGID+41, DIALOG_STYLE_LIST, "Bicycles", "Bike\nBMX\nMountain Bike", "Select", "Back");}
		if(listitem == 1){ ShowPlayerDialog(playerid, DIALOGID+42, DIALOG_STYLE_LIST, "Bikes", "NRG-500\nFaggio\nFCR-900\nPCJ-600\nFreeway\nBF-400\nPizzaBoy\nWayfarer\nCop Bike\nSanchez\nQuad", "Select", "Back");}
		if(listitem == 2){ ShowPlayerDialog(playerid, DIALOGID+43, DIALOG_STYLE_LIST, "Monster Trucks", "Dumper\nDuneride\nMonster\nMonster A\nMonster B", "Select", "Back");}
 		if(listitem == 3){ ShowPlayerDialog(playerid, DIALOGID+44, DIALOG_STYLE_LIST, "Boats", "Coastguard\nDinghy\nJetmax\nLaunch\nMarquis\nPredator\nReefer\nSpeeder\nSqualo\nTropic", "Select", "Back");}
		if(listitem == 4){ ShowPlayerDialog(playerid, DIALOGID+45, DIALOG_STYLE_LIST, "Helicopters", "Cargobob\nHunter\nLeviathn\nMaverick\nPolmav\nRaindanc\nSeasparr\nSparrow\nVCN Helicopter", "Select", "Back");}
		if(listitem == 5){ ShowPlayerDialog(playerid, DIALOGID+46, DIALOG_STYLE_LIST, "Planes", "Hydra\nRustler\nDodo\nNevada\nSuntplane\nCropdust\nAT-400\nAndromeda\nBeagle\nVortex\nSkimmer\nShamal", "Select", "Back");}
		if(listitem == 6){ ShowPlayerDialog(playerid, DIALOGID+47, DIALOG_STYLE_LIST, "Cars", "Lowriders\nStreet Racers\nMuscle cars\nSuvs & Wagons\nSport Cars\nRecreational\nCivil\nGovernment\n4 door luxury\n2 door sedans\nHeavy trucks\nLight trucks", "Select", "Back");}
		if(listitem == 7){ ShowPlayerDialog(playerid, DIALOGID+48, DIALOG_STYLE_LIST, "Vehicles RC","RC Goblin\nRC Raider\nRC Barron \nRC Bandit\nRC Cam\nRC Tiger", "Select", "Back");}
		}
		return 1;
	}
//=====================
//-----------------
// Bicycles
//-----------------
//=====================
	if(dialogid == DIALOGID+41)
	{
	    if(response == 0){
	    ShowPlayerDialog(playerid, DIALOGID+40, DIALOG_STYLE_LIST, "LuX Vehicles","Bicycles\nBikes\nMonster Trucks\nBoats\nHelicopters\nPlanes\nCars\nVehicles RC","Select", "Cancel");}
		if(response)
		{
		if(listitem == 0){ CarSpawner(playerid,509);}
		if(listitem == 1){ CarSpawner(playerid,481);}
		if(listitem == 2){ CarSpawner(playerid,510);}
		}
		return 1;
	}
//=====================
//-----------------
// Bikes
//-----------------
//=====================
	if(dialogid == DIALOGID+42)
	{
        if(response == 0){
	    ShowPlayerDialog(playerid, DIALOGID+40, DIALOG_STYLE_LIST, "LuX Vehicles","Bicycles\nBikes\nMonster Trucks\nBoats\nHelicopters\nPlanes\nCars\nVehicles RC","Select", "Cancel");}
		if(response)
		{

  		if(listitem == 0){CarSpawner(playerid,522);}
  		if(listitem == 1){CarSpawner(playerid,462);}
  		if(listitem == 2){CarSpawner(playerid,521);}
  		if(listitem == 3){CarSpawner(playerid,461);}
  		if(listitem == 4){CarSpawner(playerid,463);}
  		if(listitem == 5){CarSpawner(playerid,581);}
  		if(listitem == 6){CarSpawner(playerid,448);}
  		if(listitem == 7){CarSpawner(playerid,586);}
  		if(listitem == 8){CarSpawner(playerid,523);}
  		if(listitem == 9){CarSpawner(playerid,468);}
  		if(listitem == 10){CarSpawner(playerid,471);}
		}
		return 1;
	}
//=====================
//-----------------
// Monster Trucks
//-----------------
//=====================
	if(dialogid == DIALOGID+43)
	{
        if(response == 0){
	    ShowPlayerDialog(playerid, DIALOGID+40, DIALOG_STYLE_LIST, "LuX Vehicles","Bicycles\nBikes\nMonster Trucks\nBoats\nHelicopters\nPlanes\nCars\nVehicles RC","Select", "Cancel");}
		if(response)
		{
  		if(listitem == 0){ CarSpawner(playerid,406);}
  		if(listitem == 1){ CarSpawner(playerid,573);}
  		if(listitem == 2){ CarSpawner(playerid,444);}
  		if(listitem == 3){ CarSpawner(playerid,556);}
  		if(listitem == 4){ CarSpawner(playerid,557);}
		}
		return 1;
	}

//=====================
//-----------------
// Boats
//-----------------
//=====================
	if(dialogid == DIALOGID+44)
	{
	    if(response == 0){
	    ShowPlayerDialog(playerid, DIALOGID+40, DIALOG_STYLE_LIST, "LuX Vehicles","Bicycles\nBikes\nMonster Trucks\nBoats\nHelicopters\nPlanes\nCars\nVehicles RC","Select", "Cancel");}
		if(response)
		{
  		if(listitem == 0){ CarSpawner(playerid,472);}
    	if(listitem == 1){ CarSpawner(playerid,473);}
    	if(listitem == 2){ CarSpawner(playerid,493);}
    	if(listitem == 3){ CarSpawner(playerid,595);}
    	if(listitem == 4){ CarSpawner(playerid,484);}
    	if(listitem == 5){ CarSpawner(playerid,430);}
    	if(listitem == 6){ CarSpawner(playerid,453);}
    	if(listitem == 7){ CarSpawner(playerid,452);}
    	if(listitem == 8){ CarSpawner(playerid,446);}
    	if(listitem == 9){ CarSpawner(playerid,454);}
		}
		return 1;
	}
//=====================
//-----------------
// Helicopters
//-----------------
//=====================
	if(dialogid == DIALOGID+45)
	{
	    if(response == 0){
	    ShowPlayerDialog(playerid, DIALOGID+40, DIALOG_STYLE_LIST, "LuX Vehicles","Bicycles\nBikes\nMonster Trucks\nBoats\nHelicopters\nPlanes\nCars\nVehicles RC","Select", "Cancel");}
		if(response)
		{
  		if(listitem == 0){ CarSpawner(playerid,548);}
  		if(listitem == 1){ CarSpawner(playerid,425);}
  		if(listitem == 2){ CarSpawner(playerid,417);}
	    if(listitem == 3){ CarSpawner(playerid,487);}
	    if(listitem == 4){ CarSpawner(playerid,497);}
  		if(listitem == 5){ CarSpawner(playerid,563);}
  		if(listitem == 6){ CarSpawner(playerid,447);}
  		if(listitem == 7){ CarSpawner(playerid,469);}
		if(listitem == 8){ CarSpawner(playerid,488);}
		}
		return 1;
	}
//=====================
//-----------------
// Planes
//-----------------
//=====================
	if(dialogid == DIALOGID+46)
	{
	    if(response == 0){
	    ShowPlayerDialog(playerid, DIALOGID+40, DIALOG_STYLE_LIST, "LuX Vehicles","Bicycles\nBikes\nMonster Trucks\nBoats\nHelicopters\nPlanes\nCars\nVehicles RC","Select", "Cancel");}
		if(response)
		{
        if(listitem == 0){ CarSpawner(playerid,520);}
        if(listitem == 1){ CarSpawner(playerid,476);}
        if(listitem == 2){ CarSpawner(playerid,593);}
        if(listitem == 3){ CarSpawner(playerid,553);}
        if(listitem == 4){ CarSpawner(playerid,513);}
        if(listitem == 5){ CarSpawner(playerid,512);}
        if(listitem == 6){ CarSpawner(playerid,577);}
        if(listitem == 7){ CarSpawner(playerid,592);}
        if(listitem == 8){ CarSpawner(playerid,511);}
        if(listitem == 9){ CarSpawner(playerid,539);}
        if(listitem == 10){ CarSpawner(playerid,460);}
        if(listitem == 11){ CarSpawner(playerid,519);}
		}
		return 1;
	}
//=====================
//-----------------
// Vehicles RC
//-----------------
//=====================
	if(dialogid == DIALOGID+48)
	{
	    if(response == 0){
	    ShowPlayerDialog(playerid, DIALOGID+40, DIALOG_STYLE_LIST, "LuX Vehicles","Bicycles\nBikes\nMonster Trucks\nBoats\nHelicopters\nPlanes\nCars\nVehicles RC","Select", "Cancel");}
		if(response)
		{
	    if(listitem == 0){ CarSpawner(playerid,501);}
     	if(listitem == 0){ CarSpawner(playerid,465);}
     	if(listitem == 0){ CarSpawner(playerid,464);}
     	if(listitem == 0){ CarSpawner(playerid,441);}
     	if(listitem == 0){ CarSpawner(playerid,594);}
     	if(listitem == 0){ CarSpawner(playerid,564);}
		}
		return 1;
	}
//=====================
//-----------------
// Cars
//-----------------
//=====================
	if(dialogid == DIALOGID+47)
	{
		if(response == 0){
	    ShowPlayerDialog(playerid, DIALOGID+40, DIALOG_STYLE_LIST, "LuX Vehicles","Bicycles\nBikes\nMonster Trucks\nBoats\nHelicopters\nPlanes\nCars\nVehicles RC","Select", "Cancel");}
		if(response)
        {
		if(listitem == 0){ ShowPlayerDialog(playerid, DIALOGID+4, DIALOG_STYLE_LIST, "Lowriders", "Blade\nBroadway\nRemmington\nSavanna\nSlamvan\nTornado\nVoodoo", "Select", "Back");}
		if(listitem == 1){ ShowPlayerDialog(playerid, DIALOGID+5, DIALOG_STYLE_LIST, "Street Racers","Elegy\nFlash\nJester\nStratum\nSultan\nUranus", "Select", "Back");}
		if(listitem == 2){ ShowPlayerDialog(playerid, DIALOGID+6, DIALOG_STYLE_LIST, "Muscle Cars", "Buffalo\nClover\nPhoenix\nSabre", "Select", "Back");}
 		if(listitem == 3){ ShowPlayerDialog(playerid, DIALOGID+7, DIALOG_STYLE_LIST, "Suvs & Wagons", "Huntley\nLandstalker\nPerenial\nRancher\nRegina\nRomero\nSolair", "Select", "Back");}
		if(listitem == 4){ ShowPlayerDialog(playerid, DIALOGID+8, DIALOG_STYLE_LIST, "Sport Cars", "Banshee\nBullet\nCheetah\nComet\nHotknife\nHotring Racer\nInfernus\nSuper GT\nTurismo\nWindsor\nZR-350", "Select", "Back");}
		if(listitem == 5){ ShowPlayerDialog(playerid, DIALOGID+9, DIALOG_STYLE_LIST, "Recreational", "Bandito\nBF Injection\nBloodring Banger\nCaddy\nCamper\nJourney\nKart\nMesa\nSandking\nVortex", "Select", "Back");}
		if(listitem == 6){ ShowPlayerDialog(playerid, DIALOGID+10, DIALOG_STYLE_LIST, "Civil", "Baggage\nBus\nCabbie\nCoach\nSweeper\nTaxi\nTowtruck\nTrashmaster\nUtiliy van", "Select", "Back");}
		if(listitem == 7){ ShowPlayerDialog(playerid, DIALOGID+11, DIALOG_STYLE_LIST, "Government", "Ambulance\nBarracks\nEnforcer\nFBI Rancher\nFBI Truck\nFiretruck\nPatriot\nPolite Car SF\nRanger\nSecuricar\nS.W.A.T", "Select", "Back");}
		if(listitem == 8){ ShowPlayerDialog(playerid, DIALOGID+12, DIALOG_STYLE_LIST, "4 Door Luxury", "Admiral\nElegant\nEmperor\nEuros\nGlendale\nGreenwood\nIntruder\nMerit\nNebula\nOceanic\nPremier\nPrimo\nSentinel\nStretch\nSunrise\nTahoma\nVincent\nWashington\nWillard", "Select", "Back");}
		if(listitem == 9){ ShowPlayerDialog(playerid, DIALOGID+58, DIALOG_STYLE_LIST, "2 Door Sedans", "Alpha\nBlista Compact\nBravura\nBaccaneer\nCadrona\nClub\nEsperanto\nFeltzer\nFortune\nHermer\nHustler\nMagestic\nManana\nPicador\nPrevion\nStafford\nStallion\nTampa\nVirgo", "Select", "Back");}
		if(listitem == 10){ ShowPlayerDialog(playerid, DIALOGID+59, DIALOG_STYLE_LIST, "Heavy trucks", "Benson\nBoxville\nCement truck\nCombine Harvester\nDFT-30\nDozer\nFlatbed\nHotdog\nLinerunner\nMr Whoopee\nMule\nPacker\nRoadtrain\nTanker\nTractor\nYankee", "Select", "Back");}
 		if(listitem == 11){ ShowPlayerDialog(playerid, DIALOGID+60, DIALOG_STYLE_LIST, "Light trucks", "Berkley's RC van\nBobcat\nBurrito\nForklift\nMoonbeam\nMower\nNewsvan\nNext page\nPony\nRumpo\nSadler\nTug\nWalton\nYosemite", "Select", "Back");}
		}
		return 1;
	}
//=====================
//-----------------
// Lowriders
//-----------------
//=====================
	if(dialogid == DIALOGID+4)
	{
	    if(response == 0){
	    ShowPlayerDialog(playerid, DIALOGID+47, DIALOG_STYLE_LIST, "Cars", "Lowriders\nStreet Racers\nMuscle cars\nSuvs & Wagons\nSport Cars\nRecreational\nCivil\nGovernment\n4 door luxury\n2 door sedans\nHeavy trucks\nLight trucks", "Select", "Back");}
		if(response)
		{
	        if(listitem == 0){ CarSpawner(playerid,536);}
	        if(listitem == 1){ CarSpawner(playerid,575);}
	        if(listitem == 2){ CarSpawner(playerid,534);}
	        if(listitem == 3){ CarSpawner(playerid,567);}
	        if(listitem == 4){ CarSpawner(playerid,535);}
	        if(listitem == 5){ CarSpawner(playerid,576);}
	        if(listitem == 6){ CarSpawner(playerid,412);}
		}
		return 1;
	}
//=====================
//-----------------
// Street Racers
//-----------------
//=====================
	if(dialogid == DIALOGID+5)
	{
	    if(response == 0){
	    ShowPlayerDialog(playerid, DIALOGID+47, DIALOG_STYLE_LIST, "Cars", "Lowriders\nStreet Racers\nMuscle cars\nSuvs & Wagons\nSport Cars\nRecreational\nCivil\nGovernment\n4 door luxury\n2 door sedans\nHeavy trucks\nLight trucks", "Select", "Back");}
		if(response)
		{
	        if(listitem == 0){ CarSpawner(playerid,562);}
	        if(listitem == 1){ CarSpawner(playerid,565);}
	        if(listitem == 2){ CarSpawner(playerid,559);}
	        if(listitem == 3){ CarSpawner(playerid,561);}
	        if(listitem == 4){ CarSpawner(playerid,560);}
	        if(listitem == 5){ CarSpawner(playerid,558);}
		}
		return 1;
	}
//=====================
//-----------------
// Muscle Cars
//-----------------
//=====================
	if(dialogid == DIALOGID+6)
	{
	    if(response == 0){
	    ShowPlayerDialog(playerid, DIALOGID+47, DIALOG_STYLE_LIST, "Cars", "Lowriders\nStreet Racers\nMuscle cars\nSuvs & Wagons\nSport Cars\nRecreational\nCivil\nGovernment\n4 door luxury\n2 door sedans\nHeavy trucks\nLight trucks", "Select", "Back");}
		if(response)
		{
	        if(listitem == 0){ CarSpawner(playerid,402);}
	        if(listitem == 1){ CarSpawner(playerid,542);}
	        if(listitem == 2){ CarSpawner(playerid,603);}
	        if(listitem == 3){ CarSpawner(playerid,475);}
		}
		return 1;
	}
//=====================
//-----------------
// Suvs & Wagons
//-----------------
//=====================
	if(dialogid == DIALOGID+7)
	{
	    if(response == 0){
	    ShowPlayerDialog(playerid, DIALOGID+47, DIALOG_STYLE_LIST, "Cars", "Lowriders\nStreet Racers\nMuscle cars\nSuvs & Wagons\nSport Cars\nRecreational\nCivil\nGovernment\n4 door luxury\n2 door sedans\nHeavy trucks\nLight trucks", "Select", "Back");}
		if(response)
		{
	        if(listitem == 0){ CarSpawner(playerid,579);}
	        if(listitem == 1){ CarSpawner(playerid,400);}
	        if(listitem == 2){ CarSpawner(playerid,404);}
	        if(listitem == 3){ CarSpawner(playerid,489);}
	        if(listitem == 4){ CarSpawner(playerid,479);}
	        if(listitem == 5){ CarSpawner(playerid,442);}
	        if(listitem == 6){ CarSpawner(playerid,458);}
		}
		return 1;
	}
//=====================
//-----------------
// Sport Cars
//-----------------
//=====================
	if(dialogid == DIALOGID+8)
	{
	    if(response == 0){
	    ShowPlayerDialog(playerid, DIALOGID+47, DIALOG_STYLE_LIST, "Cars", "Lowriders\nStreet Racers\nMuscle cars\nSuvs & Wagons\nSport Cars\nRecreational\nCivil\nGovernment\n4 door luxury\n2 door sedans\nHeavy trucks\nLight trucks", "Select", "Back");}
		if(response)
		{
	        if(listitem == 0){ CarSpawner(playerid,429);}
	        if(listitem == 1){ CarSpawner(playerid,541);}
	        if(listitem == 2){ CarSpawner(playerid,415);}
	        if(listitem == 3){ CarSpawner(playerid,480);}
	        if(listitem == 4){ CarSpawner(playerid,434);}
	        if(listitem == 5){ CarSpawner(playerid,494);}
	        if(listitem == 6){ CarSpawner(playerid,411);}
	        if(listitem == 7){ CarSpawner(playerid,506);}
	        if(listitem == 8){ CarSpawner(playerid,451);}
	        if(listitem == 9){ CarSpawner(playerid,555);}
	        if(listitem == 10){ CarSpawner(playerid,477);}
		}
		return 1;
	}
//=====================
//-----------------
// Recreation
//-----------------
//=====================
	if(dialogid == DIALOGID+9)
	{
	    if(response == 0){
	    ShowPlayerDialog(playerid, DIALOGID+47, DIALOG_STYLE_LIST, "Cars", "Lowriders\nStreet Racers\nMuscle cars\nSuvs & Wagons\nSport Cars\nRecreational\nCivil\nGovernment\n4 door luxury\n2 door sedans\nHeavy trucks\nLight trucks", "Select", "Back");}
		if(response)
		{
	        if(listitem == 0){ CarSpawner(playerid,568);}
	        if(listitem == 1){ CarSpawner(playerid,424);}
	        if(listitem == 2){ CarSpawner(playerid,504);}
	        if(listitem == 3){ CarSpawner(playerid,457);}
	        if(listitem == 4){ CarSpawner(playerid,483);}
	        if(listitem == 5){ CarSpawner(playerid,508);}
	        if(listitem == 6){ CarSpawner(playerid,571);}
	        if(listitem == 7){ CarSpawner(playerid,500);}
	        if(listitem == 8){ CarSpawner(playerid,495);}
	        if(listitem == 9){ CarSpawner(playerid,539);}
		}
		return 1;
	}
//=====================
//-----------------
// Civil
//-----------------
//=====================
	if(dialogid == DIALOGID+10)
	{
	    if(response == 0){
	    ShowPlayerDialog(playerid, DIALOGID+47, DIALOG_STYLE_LIST, "Cars", "Lowriders\nStreet Racers\nMuscle cars\nSuvs & Wagons\nSport Cars\nRecreational\nCivil\nGovernment\n4 door luxury\n2 door sedans\nHeavy trucks\nLight trucks", "Select", "Back");}
		if(response)
		{
	        if(listitem == 0){ CarSpawner(playerid,485);}
	        if(listitem == 1){ CarSpawner(playerid,431);}
	        if(listitem == 2){ CarSpawner(playerid,438);}
	        if(listitem == 3){ CarSpawner(playerid,437);}
	        if(listitem == 4){ CarSpawner(playerid,574);}
	        if(listitem == 5){ CarSpawner(playerid,420);}
	        if(listitem == 6){ CarSpawner(playerid,525);}
	        if(listitem == 7){ CarSpawner(playerid,408);}
	        if(listitem == 8){ CarSpawner(playerid,552);}
		}
		return 1;
	}
//=====================
//-----------------
// Governament
//-----------------
//=====================
	if(dialogid == DIALOGID+11)
	{
	    if(response == 0){
	    ShowPlayerDialog(playerid, DIALOGID+47, DIALOG_STYLE_LIST, "Cars", "Lowriders\nStreet Racers\nMuscle cars\nSuvs & Wagons\nSport Cars\nRecreational\nCivil\nGovernment\n4 door luxury\n2 door sedans\nHeavy trucks\nLight trucks", "Select", "Back");}
		if(response)
		{
	        if(listitem == 0){ CarSpawner(playerid,416);}
	        if(listitem == 1){ CarSpawner(playerid,433);}
	        if(listitem == 2){ CarSpawner(playerid,427);}
	        if(listitem == 3){ CarSpawner(playerid,490);}
	        if(listitem == 4){ CarSpawner(playerid,528);}
	        if(listitem == 5){ CarSpawner(playerid,407);}
	        if(listitem == 6){ CarSpawner(playerid,570);}
	        if(listitem == 7){ CarSpawner(playerid,597);}
	        if(listitem == 8){ CarSpawner(playerid,599);}
	        if(listitem == 9){ CarSpawner(playerid,428);}
	        if(listitem == 10){ CarSpawner(playerid,601);}
		}
		return 1;
	}
//=====================
//-----------------
// 4 doors
//-----------------
//=====================
	if(dialogid == DIALOGID+12)
	{

	    if(response == 0){
	    ShowPlayerDialog(playerid, DIALOGID+47, DIALOG_STYLE_LIST, "Cars", "Lowriders\nStreet Racers\nMuscle cars\nSuvs & Wagons\nSport Cars\nRecreational\nCivil\nGovernment\n4 door luxury\n2 door sedans\nHeavy trucks\nLight trucks", "Select", "Back");}
		if(response)
		{
	        if(listitem == 0){ CarSpawner(playerid,445);}
	        if(listitem == 1){ CarSpawner(playerid,507);}
	        if(listitem == 2){ CarSpawner(playerid,585);}
	        if(listitem == 3){ CarSpawner(playerid,587);}
	        if(listitem == 4){ CarSpawner(playerid,466);}
	        if(listitem == 5){ CarSpawner(playerid,492);}
	        if(listitem == 6){ CarSpawner(playerid,546);}
	        if(listitem == 7){ CarSpawner(playerid,551);}
	        if(listitem == 8){ CarSpawner(playerid,516);}
	        if(listitem == 9){ CarSpawner(playerid,467);}
	        if(listitem == 10){ CarSpawner(playerid,426);}
	        if(listitem == 11){ CarSpawner(playerid,547);}
	        if(listitem == 12){ CarSpawner(playerid,405);}
	        if(listitem == 13){ CarSpawner(playerid,409);}
	        if(listitem == 14){ CarSpawner(playerid,550);}
	        if(listitem == 15){ CarSpawner(playerid,566);}
	        if(listitem == 16){ CarSpawner(playerid,540);}
	        if(listitem == 17){ CarSpawner(playerid,421);}
	        if(listitem == 18){ CarSpawner(playerid,529);}
		}
		return 1;
	}
//=====================
//-----------------
// 2 doors
//-----------------
//=====================
	if(dialogid == DIALOGID+58)
	{
	    if(response == 0){
	    ShowPlayerDialog(playerid, DIALOGID+47, DIALOG_STYLE_LIST, "Cars", "Lowriders\nStreet Racers\nMuscle cars\nSuvs & Wagons\nSport Cars\nRecreational\nCivil\nGovernment\n4 door luxury\n2 door sedans\nHeavy trucks\nLight trucks", "Select", "Back");}
		if(response)
		{
            if(listitem == 0){ CarSpawner(playerid,602);}
	        if(listitem == 1){ CarSpawner(playerid,496);}
	        if(listitem == 2){ CarSpawner(playerid,401);}
	        if(listitem == 3){ CarSpawner(playerid,518);}
	        if(listitem == 4){ CarSpawner(playerid,527);}
	        if(listitem == 5){ CarSpawner(playerid,589);}
	        if(listitem == 6){ CarSpawner(playerid,419);}
	        if(listitem == 7){ CarSpawner(playerid,533);}
	        if(listitem == 8){ CarSpawner(playerid,526);}
	        if(listitem == 9){ CarSpawner(playerid,474);}
	        if(listitem == 10){ CarSpawner(playerid,545);}
	        if(listitem == 11){ CarSpawner(playerid,517);}
	        if(listitem == 12){ CarSpawner(playerid,410);}
	        if(listitem == 13){ CarSpawner(playerid,600);}
	        if(listitem == 14){ CarSpawner(playerid,436);}
	        if(listitem == 15){ CarSpawner(playerid,580);}
	        if(listitem == 16){ CarSpawner(playerid,439);}
	        if(listitem == 17){ CarSpawner(playerid,549);}
	        if(listitem == 18){ CarSpawner(playerid,491);}
		}
		return 1;
	}
//=====================
//-----------------
// Heavy Trucks
//-----------------
//=====================
	if(dialogid == DIALOGID+59)
	{
	    if(response == 0){
	    ShowPlayerDialog(playerid, DIALOGID+47, DIALOG_STYLE_LIST, "Cars", "Lowriders\nStreet Racers\nMuscle cars\nSuvs & Wagons\nSport Cars\nRecreational\nCivil\nGovernment\n4 door luxury\n2 door sedans\nHeavy trucks\nLight trucks", "Select", "Back");}
		if(response)
		{
            if(listitem == 0){ CarSpawner(playerid,499);}
	        if(listitem == 1){ CarSpawner(playerid,498);}
	        if(listitem == 2){ CarSpawner(playerid,524);}
	        if(listitem == 3){ CarSpawner(playerid,532);}
	        if(listitem == 4){ CarSpawner(playerid,578);}
	        if(listitem == 5){ CarSpawner(playerid,486);}
	        if(listitem == 6){ CarSpawner(playerid,455);}
	        if(listitem == 7){ CarSpawner(playerid,588);}
	        if(listitem == 8){ CarSpawner(playerid,403);}
	        if(listitem == 9){ CarSpawner(playerid,423);}
	        if(listitem == 10){ CarSpawner(playerid,414);}
	        if(listitem == 11){ CarSpawner(playerid,443);}
	        if(listitem == 12){ CarSpawner(playerid,515);}
	        if(listitem == 13){ CarSpawner(playerid,514);}
	        if(listitem == 14){ CarSpawner(playerid,531);}
	        if(listitem == 15){ CarSpawner(playerid,456);}
		}
		return 1;
	}
//=====================
//-----------------
// Light Trucks
//-----------------
//=====================
	if(dialogid == DIALOGID+60)
	{
	    if(response == 0){
	    ShowPlayerDialog(playerid, DIALOGID+47, DIALOG_STYLE_LIST, "Cars", "Lowriders\nStreet Racers\nMuscle cars\nSuvs & Wagons\nSport Cars\nRecreational\nCivil\nGovernment\n4 door luxury\n2 door sedans\nHeavy trucks\nLight trucks", "Select", "Back");}
		if(response)
		{
            if(listitem == 0){ CarSpawner(playerid,459);}
	        if(listitem == 1){ CarSpawner(playerid,422);}
	        if(listitem == 2){ CarSpawner(playerid,482);}
	        if(listitem == 3){ CarSpawner(playerid,530);}
	        if(listitem == 4){ CarSpawner(playerid,418);}
	        if(listitem == 5){ CarSpawner(playerid,572);}
	        if(listitem == 6){ CarSpawner(playerid,582);}
	        if(listitem == 7){ CarSpawner(playerid,413);}
	        if(listitem == 8){ CarSpawner(playerid,440);}
	        if(listitem == 9){ CarSpawner(playerid,543);}
	        if(listitem == 10){ CarSpawner(playerid,583);}
	        if(listitem == 11){ CarSpawner(playerid,478);}
	        if(listitem == 12){ CarSpawner(playerid,554);}
		}
		return 1;
	}
//==============================================================================
//---------------
// TUNING
//---------------
//==============================================================================

//===============================
//---------------
// Tune Main
//---------------
//===============================
	if(dialogid == DIALOGID+13)
    {
	    if(response == 0)
		{
        ShowPlayerDialog(playerid, DIALOGID+1, DIALOG_STYLE_LIST, "LuxAdmin Main Menu",
		"Enable\nDisable\nServer Weather\nServer Time\nVehicles\nTuning Menu\nWeapons\nTeleports", "Select", "Cancel");
		}
		if(response)
		{
		    if(listitem == 0){ AddVehicleComponent(GetPlayerVehicleID(playerid),1010); StartTuneSound(playerid); SendClientMessage(playerid,blue,"Hydraulics Added to your Vehicle");}
            if(listitem == 1){ AddVehicleComponent(GetPlayerVehicleID(playerid),1087); StartTuneSound(playerid); SendClientMessage(playerid,blue,"Nitrox Added to your Vehicle");
            }
			if(listitem == 2){ ShowPlayerDialog(playerid, DIALOGID+14, DIALOG_STYLE_LIST, "Wheels","Wire\nTwist\nAccess\nMega\nImport\nAtomic\nOfTwistfroad\nClassic", "Select", "Back");}
			if(listitem == 3){ ShowPlayerDialog(playerid, DIALOGID+15, DIALOG_STYLE_LIST, "Paint Jobs","Style 1\nStyle 2\nStyle 3\nStyle 4\nStyle 5", "Select", "Back");}
			if(listitem == 4){ ShowPlayerDialog(playerid, DIALOGID+19, DIALOG_STYLE_LIST, "Vehicle Colours","Black \nWhite \nDark Blue \nLight Blue \nGreen \nRed \nYellow \nPink", "Select", "Back");}
		}
 		return 1;
  	}
//===============================
//---------------
// Wheels
//---------------
//===============================
	if(dialogid == DIALOGID+14)
    {
	    if(response == 0)
		{
        ShowPlayerDialog(playerid, DIALOGID+13, DIALOG_STYLE_LIST, "Tune Menu",
        "Nitrox\nHydraulics\nWheels\nPaint Jobs\nColours", "Select", "Back");
		}
		if(response)
		{
		    if(listitem == 0){ AddVehicleComponent(GetPlayerVehicleID(playerid),1081); StartTuneSound(playerid); SendClientMessage(playerid,blue,"Wire Wheels to your Vehicle");}
            if(listitem == 1){ AddVehicleComponent(GetPlayerVehicleID(playerid),1078); StartTuneSound(playerid); SendClientMessage(playerid,blue,"Twist Wheels Added to your Vehicle");}
			if(listitem == 2){ AddVehicleComponent(GetPlayerVehicleID(playerid),1098); StartTuneSound(playerid); SendClientMessage(playerid,blue,"Access Wheels Added to your Vehicle");}
			if(listitem == 3){ AddVehicleComponent(GetPlayerVehicleID(playerid),1074); StartTuneSound(playerid); SendClientMessage(playerid,blue,"Mega Wheels Added to your Vehicle");}
			if(listitem == 4){ AddVehicleComponent(GetPlayerVehicleID(playerid),1082); StartTuneSound(playerid); SendClientMessage(playerid,blue,"Import Wheels Added to your Vehicle");}
 			if(listitem == 5){ AddVehicleComponent(GetPlayerVehicleID(playerid),1085); StartTuneSound(playerid); SendClientMessage(playerid,blue,"Atomic Wheels Added to your Vehicle");}
			if(listitem == 6){ AddVehicleComponent(GetPlayerVehicleID(playerid),1025); StartTuneSound(playerid); SendClientMessage(playerid,blue,"OfTwistfroad Wheels Added to your Vehicle");}
 			if(listitem == 7){ AddVehicleComponent(GetPlayerVehicleID(playerid),1077); StartTuneSound(playerid); SendClientMessage(playerid,blue,"Classic Wheels Added to your Vehicle");}
		}
 		return 1;
  	}
//===============================
//---------------
// Paint Jobs
//---------------
//===============================
	if(dialogid == DIALOGID+15)
	{
	    if(response == 0)
		{
        ShowPlayerDialog(playerid, DIALOGID+13, DIALOG_STYLE_LIST, "Tune Menu",
        "Nitrox\nHydraulics\nWheels\nPaint Jobs\nColours", "Select", "Back");
		}
		if(response)
		{
		    if(listitem == 0){ ChangeVehiclePaintjob(GetPlayerVehicleID(playerid),0); StartTuneSound(playerid); SendClientMessage(playerid,blue,"Vehicle Paint Job changed to Paint Job Style 1"); }
            if(listitem == 1){ ChangeVehiclePaintjob(GetPlayerVehicleID(playerid),1); StartTuneSound(playerid); SendClientMessage(playerid,blue,"Vehicle Paint Job changed to Paint Job Style 2"); }
			if(listitem == 2){ ChangeVehiclePaintjob(GetPlayerVehicleID(playerid),2); StartTuneSound(playerid); SendClientMessage(playerid,blue,"Vehicle Paint Job changed to Paint Job Style 3"); }
			if(listitem == 3){ ChangeVehiclePaintjob(GetPlayerVehicleID(playerid),3); StartTuneSound(playerid); SendClientMessage(playerid,blue,"Vehicle Paint Job changed to Paint Job Style 4"); }
			if(listitem == 4){ ChangeVehiclePaintjob(GetPlayerVehicleID(playerid),4); StartTuneSound(playerid); SendClientMessage(playerid,blue,"Vehicle Paint Job changed to Paint Job Style 5"); }
		}
 		return 1;
  	}
//===============================
//---------------
// Vehicle Colours
//---------------
//===============================
	if(dialogid == DIALOGID+19)
    {
	    if(response == 0)
		{
        ShowPlayerDialog(playerid, DIALOGID+13, DIALOG_STYLE_LIST, "Tune Menu",
        "Nitrox\nHydraulics\nWheels\nPaint Jobs\nColours", "Select", "Back");
		}
		if(response)
		{
			if(listitem == 0){ ChangeVehicleColor(GetPlayerVehicleID(playerid),0,0);     StartTuneSound(playerid); SendClientMessage(playerid,blue,"Vehicle Paint changed to Black");      }
			if(listitem == 1){ ChangeVehicleColor(GetPlayerVehicleID(playerid),1,1);     StartTuneSound(playerid); SendClientMessage(playerid,blue,"Vehicle Paint changed to White");      }
			if(listitem == 2){ ChangeVehicleColor(GetPlayerVehicleID(playerid),425,425); StartTuneSound(playerid); SendClientMessage(playerid,blue,"Vehicle Paint changed to Dark Blue");  }
			if(listitem == 3){ ChangeVehicleColor(GetPlayerVehicleID(playerid),2,2);     StartTuneSound(playerid); SendClientMessage(playerid,blue,"Vehicle Paint changed to Light Blue"); }
			if(listitem == 4){ ChangeVehicleColor(GetPlayerVehicleID(playerid),16,16);   StartTuneSound(playerid); SendClientMessage(playerid,blue,"Vehicle Paint changed to Green");      }
			if(listitem == 5){ ChangeVehicleColor(GetPlayerVehicleID(playerid),3,3);     StartTuneSound(playerid); SendClientMessage(playerid,blue,"Vehicle Paint changed to Red");		 }
			if(listitem == 6){ ChangeVehicleColor(GetPlayerVehicleID(playerid),6,6);     StartTuneSound(playerid); SendClientMessage(playerid,blue,"Vehicle Paint changed to Yellow");	 }
			if(listitem == 7){ ChangeVehicleColor(GetPlayerVehicleID(playerid),146,146); StartTuneSound(playerid); SendClientMessage(playerid,blue,"Vehicle Paint changed to Pink");		 }
		}
 		return 1;
  	}
//===============================
//---------------
// Server Weather
//---------------
//===============================
	if(dialogid == DIALOGID+16)
    {
	    if(response == 0)
		{
        ShowPlayerDialog(playerid, DIALOGID+1, DIALOG_STYLE_LIST, "LuxAdmin Main Menu",
		"Enable\nDisable\nServer Weather\nServer Time\nVehicles\nTuning Menu\nWeapons\nTeleports", "Select", "Cancel");
		}
		if(response)
		{
		    if(listitem == 0)
		    {
				 SetWeather(5);
		 		 PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
				 SendCommandToAdmins(playerid,"SetWeather");
				 format(string,sizeof(string),"|- Administrator %s has changed the weather to 'Blue Sky' -|",adminname);
				 SendClientMessageToAll(blue,string);
            }
            if(listitem == 1)
			{
 	        	 SetWeather(19);
		 		 PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
				 SendCommandToAdmins(playerid,"SetWeather");
				 format(string,sizeof(string),"|- Administrator %s has changed the weather to 'Sand Storm' -|",adminname);
				 SendClientMessageToAll(blue,string);
            }
			if(listitem == 2)
			{
				 SetWeather(8);
		 		 PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
				 SendCommandToAdmins(playerid,"SetWeather");
				 format(string,sizeof(string),"|- Administrator %s has changed the weather to 'Thunderstorm' -|",adminname);
				 SendClientMessageToAll(blue,string);
            }

			if(listitem == 3)
			{
 	             SetWeather(20);
		 		 PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
				 SendCommandToAdmins(playerid,"SetWeather");
				 format(string,sizeof(string),"|- Administrator %s has changed the weather to 'Foggy' -|",adminname);
				 SendClientMessageToAll(blue,string);
            }
			if(listitem == 4)
			{
 	             SetWeather(9);
		 		 PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
				 SendCommandToAdmins(playerid,"SetWeather");
				 format(string,sizeof(string),"|- Administrator %s has changed the weather to 'Cloudy' -|",adminname);
				 SendClientMessageToAll(blue,string);
            }
 			if(listitem == 5)
			{
 	             SetWeather(16);
		 		 PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
				 SendCommandToAdmins(playerid,"SetWeather");
				 format(string,sizeof(string),"|- Administrator %s has changed the weather to 'High Tide' -|",adminname);
				 SendClientMessageToAll(blue,string);
            }
			if(listitem == 6)
			{
 	             SetWeather(45);
		 		 PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
				 SendCommandToAdmins(playerid,"SetWeather");
				 format(string,sizeof(string),"|- Administrator %s has changed the weather to 'Purple Sky' -|",adminname);
				 SendClientMessageToAll(blue,string);
            }
 			if(listitem == 7)
			{
 	             SetWeather(44);
		 		 PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
				 SendCommandToAdmins(playerid,"SetWeather");
				 format(string,sizeof(string),"|- Administrator %s has changed the weather to 'Black/White Sky' -|",adminname);
				 SendClientMessageToAll(blue,string);
            }
  			if(listitem == 8)
			{
 	             SetWeather(22);
		 		 PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
				 SendCommandToAdmins(playerid,"SetWeather");
				 format(string,sizeof(string),"|- Administrator %s has changed the weather to 'Dark, Green Sky' -|",adminname);
				 SendClientMessageToAll(blue,string);
            }
            if(listitem == 9)
			{
 	             SetWeather(11);
		 		 PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
				 SendCommandToAdmins(playerid,"SetWeather");
				 format(string,sizeof(string),"|- Administrator %s has changed the weather to 'Heatwave' -|",adminname);
				 SendClientMessageToAll(blue,string);
            }
		}
 		return 1;
  	}

//===============================
//---------------
// Server Time
//---------------
//===============================
	if(dialogid == DIALOGID+17)
    {
	    if(response == 0)
		{
        ShowPlayerDialog(playerid, DIALOGID+1, DIALOG_STYLE_LIST, "LuxAdmin Main Menu",
		"Enable\nDisable\nServer Weather\nServer Time\nVehicles\nTuning Menu\nWeapons\nTeleports", "Select", "Cancel");
		}
		if(response)
		{
		    if(listitem == 0)
			{
				 for(new i = 0; i < MAX_PLAYERS; i++)
				 if(IsPlayerConnected(i))
				 SetPlayerTime(i,7,0);
				 PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		   		 format(string,sizeof(string),"|- Administrator %s has changed the Time -|",adminname);
				 SendClientMessageToAll(blue,string);
            }

            if(listitem == 1)
			{
 	        	 for(new i = 0; i < MAX_PLAYERS; i++)
		   		 if(IsPlayerConnected(i))
		  		 SetPlayerTime(i,12,0);
		   		 PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		   		 format(string,sizeof(string),"|- Administrator %s has changed the Time -|",adminname);
		   		 SendClientMessageToAll(blue,string);
            }
			if(listitem == 2)
			{
				 for(new i = 0; i < MAX_PLAYERS; i++)
		   		 if(IsPlayerConnected(i))
		  		 SetPlayerTime(i,16,0);
		   		 PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		   		 format(string,sizeof(string),"|- Administrator %s has changed the Time -|",adminname);
		   		 SendClientMessageToAll(blue,string);
            }
			if(listitem == 3)
			{
 	             for(new i = 0; i < MAX_PLAYERS; i++)
		   		 if(IsPlayerConnected(i))
		  		 SetPlayerTime(i,20,0);
		   		 PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		   		 format(string,sizeof(string),"|- Administrator %s has changed the Time -|",adminname);
		   		 SendClientMessageToAll(blue,string);
		   	 }
			if(listitem == 4)
			{
 	             for(new i = 0; i < MAX_PLAYERS; i++)
		   		 if(IsPlayerConnected(i))
		  		 SetPlayerTime(i,0,0);
		   		 PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		   		 format(string,sizeof(string),"|- Administrator %s has changed the Time -|",adminname);
		   		 SendClientMessageToAll(blue,string);
            }
		}
 		return 1;
  	}


//=====================
//-----------------
// Teles (Main)
//-----------------
//=====================
	if(dialogid == DIALOGID+30)
    {
        if(response == 0){ ShowPlayerDialog(playerid, DIALOGID+1, DIALOG_STYLE_LIST, "LuxAdmin Main Menu","Enable\nDisable\nServer Weather\nServer Time\nVehicles\nTuning Menu\nWeapons\nTeleports", "Select", "Cancel"); }
		if(response)
		{
		if(listitem == 0){ ShowPlayerDialog(playerid, DIALOGID+31, DIALOG_STYLE_LIST, "Los Santos", "Los Santos Airport \nPershing Square \nVinewood \nGrove Street \nRichman \nSanta Maria Beach \nOcean Docks \nDillimore \nPalomino Creek \nBlueBerry \nMontGomery", "Select", "Back");}
		if(listitem == 1){ ShowPlayerDialog(playerid, DIALOGID+32, DIALOG_STYLE_LIST, "San Fierro", "San Fierro Airport \nGolden Gate Bridge \nMt. Chilliad \nCJ's garage \nSan Fierro Stadium \nOcean Flats \nMissionary Hill", "Select", "Back");}
		if(listitem == 2){ ShowPlayerDialog(playerid, DIALOGID+33, DIALOG_STYLE_LIST, "Las Venturas", "Las Venturas Airport \nArea51 \nFour Dragons Casino \nLas Venturas Police Department \nBayside \nBig Jump \nLas Barrancas \nFort Carson \nLas Venturas Stadium \nNorthern Las Venturas \nStarfish Casino", "Select", "Back");}
		}
		return 1;
	}
//=====================
//-----------------
// Teles (Los Santos)
//-----------------
//=====================
	if(dialogid == DIALOGID+31)
    {
		if(response == 0){ ShowPlayerDialog(playerid, DIALOGID+30, DIALOG_STYLE_LIST, "Select City", "Los Santos\nSan Fierro\nLas Venturas", "Select", "Back");}
		if(response)
		{
		if(listitem == 0){  SetPlayerInterior(playerid, 0); SetPlayerPos(playerid, 1642.3022,-2333.6287,13.5469); }
		if(listitem == 1){  SetPlayerInterior(playerid, 0); SetPlayerPos(playerid, 1511.8770,-1661.2853,13.5469); }
		if(listitem == 2){  SetPlayerInterior(playerid, 0); SetPlayerPos(playerid, 1382.6194,-888.5532,38.0863);  }
		if(listitem == 3){  SetPlayerInterior(playerid, 0); SetPlayerPos(playerid, 2485.2546,-1684.7223,13.5096); }
		if(listitem == 4){  SetPlayerInterior(playerid, 0); SetPlayerPos(playerid, 597.6629,-1241.3900,18.1275);  }
		if(listitem == 5){  SetPlayerInterior(playerid, 0); SetPlayerPos(playerid, 491.7868,-1823.2258,5.5028);   }
		if(listitem == 6){  SetPlayerInterior(playerid, 0); SetPlayerPos(playerid, 2771.1060,-2417.5828,13.6405); }
		if(listitem == 7){  SetPlayerInterior(playerid, 0); SetPlayerPos(playerid, 661.0361,-573.5891,16.3359);   }
		if(listitem == 8){  SetPlayerInterior(playerid, 0); SetPlayerPos(playerid, 2269.6877,-75.0973,26.7724);   }
		if(listitem == 9){  SetPlayerInterior(playerid, 0); SetPlayerPos(playerid, 198.4328,-252.1696,1.5781);    }
 	    if(listitem == 10){ SetPlayerInterior(playerid, 0); SetPlayerPos(playerid, 1242.2875,328.5506,19.7555);   }
		}
 	    return 1;
	}
//=====================
//-----------------
// Teles (San Fierro)
//-----------------
//=====================
	if(dialogid == DIALOGID+32)
    {
        if(response == 0){ ShowPlayerDialog(playerid, DIALOGID+30, DIALOG_STYLE_LIST, "Select City", "Los Santos\nSan Fierro\nLas Venturas", "Select", "Back");}
		if(response)
		{
		if(listitem == 0){ SetPlayerInterior(playerid, 0);SetPlayerPos(playerid, -1422.8820,-287.4992,14.1484);   }
		if(listitem == 1){ SetPlayerInterior(playerid, 0);SetPlayerPos(playerid, -2672.6116,1268.4943,55.9456);   }
		if(listitem == 2){ SetPlayerInterior(playerid, 0);SetPlayerPos(playerid, -2305.6143,-1626.0594,483.7662); }
		if(listitem == 3){ SetPlayerInterior(playerid, 0);SetPlayerPos(playerid, -2026.2843,156.4974,29.0391);    }
		if(listitem == 4){ SetPlayerInterior(playerid, 0);SetPlayerPos(playerid, -2159.3616,-407.8362,35.3359);   }
		if(listitem == 5){ SetPlayerInterior(playerid, 0);SetPlayerPos(playerid, -2648.7498,14.2868,6.1328);      }
		if(listitem == 6){ SetPlayerInterior(playerid, 0);SetPlayerPos(playerid, -2521.4055,-623.5245,132.7727);  }
		}
     	return 1;
	}
//=====================
//-----------------
// Teles (Las Venturas)
//-----------------
//=====================
	if(dialogid == DIALOGID+33)
    {
        if(response == 0){ ShowPlayerDialog(playerid, DIALOGID+30, DIALOG_STYLE_LIST, "Select City", "Los Santos\nSan Fierro\nLas Venturas", "Select", "Back");}
		if(response)
		{
		if(listitem == 0)  {SetPlayerInterior(playerid, 0); SetPlayerPos(playerid, 1679.3361,1448.6248,10.7744);  }
		if(listitem == 1)  {SetPlayerInterior(playerid, 0); SetPlayerPos(playerid, 95.7283,1920.3488,18.1163);    }
		if(listitem == 2)  {SetPlayerInterior(playerid, 0); SetPlayerPos(playerid, 2027.5721,1008.2877,10.8203);  }
		if(listitem == 3)  {SetPlayerInterior(playerid, 0); SetPlayerPos(playerid, 2287.0313,2431.0276,10.8203);  }
		if(listitem == 4)  {SetPlayerInterior(playerid, 0); SetPlayerPos(playerid, -2241.4238,2327.4290,4.9844);  }
		if(listitem == 5)  {SetPlayerInterior(playerid, 0); SetPlayerPos(playerid, -670.6358,2306.0559,135.2990); }
		if(listitem == 6)  {SetPlayerInterior(playerid, 0); SetPlayerPos(playerid, -761.5192,1552.1647,26.9609);  }
		if(listitem == 7)  {SetPlayerInterior(playerid, 0); SetPlayerPos(playerid, -143.5370,1217.8855,19.7352);  }
		if(listitem == 8)  {SetPlayerInterior(playerid, 0); SetPlayerPos(playerid, 1099.1533,1384.3300,10.8203);  }
		if(listitem == 9)  {SetPlayerInterior(playerid, 0); SetPlayerPos(playerid, 1614.2190,2334.9338,10.8203);  }
		if(listitem == 10) {SetPlayerInterior(playerid, 0); SetPlayerPos(playerid, 2572.6560,1818.1030,10.8203);  }
		}
		return 1;
    }
//==============================================================================
//----------------------------
// Weapons Main
//----------------------------
//==============================================================================
	if(dialogid == DIALOGID+20)
    {
	    if(response == 0)
		{
        ShowPlayerDialog(playerid, DIALOGID+1, DIALOG_STYLE_LIST, "LuxAdmin Main Menu",
		"Enable\nDisable\nServer Weather\nServer Time\nVehicles\nTuning Menu\nWeapons\nTeleports", "Select", "Cancel");
		}
		if(response)
		{
			if(listitem == 0){ShowPlayerDialog(playerid, DIALOGID+21, DIALOG_STYLE_LIST, "Machine Guns", "Micro SMG \nSMG \nAK47 \nM4 \nTec9", "Select", "Back");}
			if(listitem == 1){ShowPlayerDialog(playerid, DIALOGID+22, DIALOG_STYLE_LIST, "Pistols", "9mm \nSilenced 9mm \nDeagle", "Select", "Back");}
			if(listitem == 2){ShowPlayerDialog(playerid, DIALOGID+23, DIALOG_STYLE_LIST, "Rifles", "Country Rifle \nSniper Rifle", "Select", "Back");}
   			if(listitem == 3){ShowPlayerDialog(playerid, DIALOGID+24, DIALOG_STYLE_LIST, "Shotguns", "Shotgun \nSawnoff Shotgun \nCombat Shotgun", "Select", "Back");}
   			if(listitem == 4){ShowPlayerDialog(playerid, DIALOGID+25, DIALOG_STYLE_LIST, "Heavy Assaults", "Rocket Launcher \nHS Rocket Launcher \nFlamethrower \nMinigun", "Select", "Back");}
   		    if(listitem == 5){ShowPlayerDialog(playerid, DIALOGID+26, DIALOG_STYLE_LIST, "Special", "Camera \nNightvision Goggles \nInfared Vision \nParachute", "Select", "Back");}
   			if(listitem == 6){ShowPlayerDialog(playerid, DIALOGID+27, DIALOG_STYLE_LIST, "Hand Held", "Spraycan \nFire Extinguisher", "Select", "Back");}
   			if(listitem == 7){ShowPlayerDialog(playerid, DIALOGID+28, DIALOG_STYLE_LIST, "Melee","Brass Knuckles \nGolf Club \nNite Stick \nKnife \nBaseball Bat \nShovel \nPool Cue \nKatana \nChainsaw \nPurple Dildo \nSmall White Vibrator \nLarge White Vibrator \nSilver Vibrator \nFlowers \nCane", "Select", "Back");}
   			if(listitem == 8){ShowPlayerDialog(playerid, DIALOGID+29, DIALOG_STYLE_LIST, "Projetile", "Grenade \nTear Gas \nMolotov Cocktail \nSatchel Charge \nDetonator", "Select", "Back");}
			   }
		return 1;
  	}
//=====================
//-----------------
// Machine Guns
//-----------------
//=====================
	if(dialogid == DIALOGID+21)
	    {
        if(response == 0)
		{
        ShowPlayerDialog(playerid, DIALOGID+20, DIALOG_STYLE_LIST,
		"Weapons", "Machine Guns\nPistols\nRifles\nShotguns\nHeavy Assault\nSpecial Weapons\nHand Held\nMelee \nProjectile", "Select", "Back");
		}
		if(response)
		{
	 	if(listitem == 0){GivePlayerWeapon(playerid,28, 300);}
	 	if(listitem == 1){GivePlayerWeapon(playerid,29, 300);}
  		if(listitem == 2){GivePlayerWeapon(playerid,30, 300);}
		if(listitem == 3){GivePlayerWeapon(playerid,31, 300);}
		if(listitem == 4){GivePlayerWeapon(playerid,32, 300);}
   		}
		return 1;
  	}
//=====================
//-----------------
// Pistols
//-----------------
//=====================
	if(dialogid == DIALOGID+22)
	    {
        if(response == 0)
		{
        ShowPlayerDialog(playerid, DIALOGID+20, DIALOG_STYLE_LIST,
		"Weapons", "Machine Guns\nPistols\nRifles\nShotguns\nHeavy Assault\nSpecial Weapons\nHand Held\nMelee \nProjectile", "Select", "Back");
		}
		if(response)
		{
		if(listitem == 0){GivePlayerWeapon(playerid,22, 300);}
		if(listitem == 1){GivePlayerWeapon(playerid,23, 300);}
		if(listitem == 2){GivePlayerWeapon(playerid,24, 300);}
  		}
		return 1;
  	}
//=====================
//-----------------
// Rifles
//-----------------
//=====================
	if(dialogid == DIALOGID+23)
	    {
        if(response == 0)
		{
        ShowPlayerDialog(playerid, DIALOGID+20, DIALOG_STYLE_LIST,
		"Weapons", "Machine Guns\nPistols\nRifles\nShotguns\nHeavy Assault\nSpecial Weapons\nHand Held\nMelee \nProjectile", "Select", "Back");
		}
		if(response)
		{
		if(listitem == 0){GivePlayerWeapon(playerid,33, 300);}
		if(listitem == 1){GivePlayerWeapon(playerid,34, 300);}
  		}
		return 1;
  	}
//=====================
//-----------------
// Shotguns
//-----------------
//=====================
	if(dialogid == DIALOGID+24)
	    {
        if(response == 0)
		{
        ShowPlayerDialog(playerid, DIALOGID+20, DIALOG_STYLE_LIST,
		"Weapons", "Machine Guns\nPistols\nRifles\nShotguns\nHeavy Assault\nSpecial Weapons\nHand Held\nMelee \nProjectile", "Select", "Back");
		}
		if(response)
		{
		if(listitem == 0){GivePlayerWeapon(playerid,25, 300);}
		if(listitem == 1){GivePlayerWeapon(playerid,26, 300);}
		if(listitem == 2){GivePlayerWeapon(playerid,27, 300);}
	    }
		return 1;
  	}
//=====================
//-----------------
// Heavy Assalts
//-----------------
//=====================
	if(dialogid == DIALOGID+25)
	    {
        if(response == 0)
		{
        ShowPlayerDialog(playerid, DIALOGID+20, DIALOG_STYLE_LIST,
 		"Weapons", "Machine Guns\nPistols\nRifles\nShotguns\nHeavy Assault\nSpecial Weapons\nHand Held\nMelee \nProjectile", "Select", "Back");
		}
		if(response)
		{
		if(listitem == 0){GivePlayerWeapon(playerid,35, 300);}
		if(listitem == 1){GivePlayerWeapon(playerid,36, 300);}
		if(listitem == 2){GivePlayerWeapon(playerid,37, 300);}
		if(listitem == 3){GivePlayerWeapon(playerid,38, 300);}
  		}
		return 1;
  	}
//=====================
//-----------------
// Special
//-----------------
//=====================
	if(dialogid == DIALOGID+26)
	    {
        if(response == 0)
		{
        ShowPlayerDialog(playerid, DIALOGID+20, DIALOG_STYLE_LIST,
		"Weapons", "Machine Guns\nPistols\nRifles\nShotguns\nHeavy Assault\nSpecial Weapons\nHand Held\nMelee \nProjectile", "Select", "Back");
		}
		if(response)
		{
		if(listitem == 0){GivePlayerWeapon(playerid,43, 300);}
		if(listitem == 1){GivePlayerWeapon(playerid,44, 300);}
		if(listitem == 2){GivePlayerWeapon(playerid,45, 300);}
		if(listitem == 3){GivePlayerWeapon(playerid,46, 300);}
  		}
		return 1;
  	}
//=====================
//-----------------
// Hand Held
//-----------------
//=====================
	if(dialogid == DIALOGID+27)
	    {
        if(response == 0)
		{
        ShowPlayerDialog(playerid, DIALOGID+20, DIALOG_STYLE_LIST,
		"Weapons", "Machine Guns\nPistols\nRifles\nShotguns\nHeavy Assault\nSpecial Weapons\nHand Held\nMelee \nProjectile", "Select", "Back");
		}
		if(response)
		{
		if(listitem == 0){GivePlayerWeapon(playerid,41, 300);}
		if(listitem == 1){GivePlayerWeapon(playerid,42, 300);}
  		}
		return 1;
  	}
//=====================
//-----------------
// Melee
//-----------------
//=====================
	if(dialogid == DIALOGID+28)
	    {
        if(response == 0)
		{
        ShowPlayerDialog(playerid, DIALOGID+20, DIALOG_STYLE_LIST,
		"Weapons", "Machine Guns\nPistols\nRifles\nShotguns\nHeavy Assault\nSpecial Weapons\nHand Held\nMelee \nProjectile", "Select", "Back");
		}
		if(response)
		{
		if(listitem == 0){GivePlayerWeapon(playerid,1, 300);}
		if(listitem == 1){GivePlayerWeapon(playerid,2, 300);}
		if(listitem == 2){GivePlayerWeapon(playerid,3, 300);}
		if(listitem == 3){GivePlayerWeapon(playerid,4, 300);}
		if(listitem == 4){GivePlayerWeapon(playerid,5, 300);}
		if(listitem == 5){GivePlayerWeapon(playerid,6, 300);}
		if(listitem == 6){GivePlayerWeapon(playerid,7, 300);}
		if(listitem == 7){GivePlayerWeapon(playerid,8, 300);}
		if(listitem == 8){GivePlayerWeapon(playerid,9, 300);}
		if(listitem == 9){GivePlayerWeapon(playerid,10, 300);}
		if(listitem == 10){GivePlayerWeapon(playerid,11, 300);}
		if(listitem == 11){GivePlayerWeapon(playerid,12, 300);}
		if(listitem == 12){GivePlayerWeapon(playerid,13, 300);}
		if(listitem == 13){GivePlayerWeapon(playerid,14, 300);}
		if(listitem == 14){GivePlayerWeapon(playerid,15, 300);}
		if(listitem == 15){GivePlayerWeapon(playerid,16, 300);}
 		}
		return 1;
  	}
//=====================
//-----------------
// Projectile
//-----------------
//=====================
	if(dialogid == DIALOGID+29)
 	   {
        if(response == 0)
		{
        ShowPlayerDialog(playerid, DIALOGID+20, DIALOG_STYLE_LIST,
		"Weapons", "Machine Guns\nPistols\nRifles\nShotguns\nHeavy Assault\nSpecial Weapons\nHand Held\nMelee \nProjectile", "Select", "Back");
		}
		if(response)
		{
			if(listitem == 0){GivePlayerWeapon(playerid,16, 300);}
			if(listitem == 1){GivePlayerWeapon(playerid,17, 300);}
			if(listitem == 2){GivePlayerWeapon(playerid,18, 300);}
			if(listitem == 3){GivePlayerWeapon(playerid,39, 300);}
			if(listitem == 4){ GivePlayerWeapon(playerid,40, 300);
			}
		}
		return 1;
	}
#endif
return 0;
}

public Duel(player1, player2)
{
	if(cdt[player1]==6) {
		GameTextForPlayer(player1,"~p~Duel Starting...",1000,6); GameTextForPlayer(player2,"~p~Duel Starting...",1000,6);
	}

	cdt[player1]--;
	if(cdt[player1]==0)
	{
		TogglePlayerControllable(player1,1); TogglePlayerControllable(player2,1);
		PlayerPlaySound(player1, 1057, 0.0, 0.0, 0.0); PlayerPlaySound(player2, 1057, 0.0, 0.0, 0.0);
		GameTextForPlayer(player1,"~g~GO~ r~!",1000,6); GameTextForPlayer(player2,"~g~GO~ r~!",1000,6);
		return 0;
	}
	else
	{
		new text[7]; format(text,sizeof(text),"~w~%d",cdt[player1]);
		PlayerPlaySound(player1, 1056, 0.0, 0.0, 0.0); PlayerPlaySound(player2, 1056, 0.0, 0.0, 0.0);
		TogglePlayerControllable(player1,0); TogglePlayerControllable(player2,0);
		GameTextForPlayer(player1,text,1000,6); GameTextForPlayer(player2,text,1000,6);
	}

	SetTimerEx("Duel",1000,0,"dd", player1, player2);
	return 0;
}
//============================ [ Timers ]=======================================

public PingKick()
{
	if(ServerInfo[MaxPing] != 0)
	{
	    PingPos++; if(PingPos > PING_MAX_EXCEEDS) PingPos = 0;

		for(new i=0; i<MAX_PLAYERS; i++)
		{
			AccInfo[i][pPing][PingPos] = GetPlayerPing(i);

		    if(GetPlayerPing(i) > ServerInfo[MaxPing])
			{
				if(AccInfo[i][PingCount] == 0) AccInfo[i][PingTime] = TimeStamp();

	   			AccInfo[i][PingCount]++;
				if(TimeStamp() - AccInfo[i][PingTime] > PING_TIMELIMIT)
				{
	    			AccInfo[i][PingTime] = TimeStamp();
					AccInfo[i][PingCount] = 1;
				}
				else if(AccInfo[i][PingCount] >= PING_MAX_EXCEEDS)
				{
				    new Sum, Average, x, string[128];
					while (x < PING_MAX_EXCEEDS) {
						Sum += AccInfo[i][pPing][x];
						x++;
					}
					Average = (Sum / PING_MAX_EXCEEDS);
					format(string,sizeof(string),"|- Player %s (Id:%d) has been Automatically Kicked. | Reason: High Ping - %d (Average - %d | Max Allowed - %d)", PlayerName2(i),i, GetPlayerPing(i), Average, ServerInfo[MaxPing]);
  		    		SendClientMessageToAll(grey,string);
					SaveIn("KickLog",string);
					Kick(i);
				}
			}
			else if(GetPlayerPing(i) < 1 && ServerInfo[AntiBot] == 1)
		    {
				AccInfo[i][BotPing]++;
				if(AccInfo[i][BotPing] >= 3) BotCheck(i);
		    }
		    else
			{
				AccInfo[i][BotPing] = 0;
			}
		}
	}
}
//==============================================================================

public GodModUp()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && AccInfo[i][God] == 1)
		{
			SetPlayerHealth(i,100000);
		}
		if(IsPlayerConnected(i) && AccInfo[i][GodCar] == 1 && IsPlayerInAnyVehicle(i))
		{
			SetVehicleHealth(GetPlayerVehicleID(i),10000);
		}
	}
}

//==============================================================================
// Console
//==============================================================================
public RestartGM() { SendRconCommand("gmx");
}
public UnloadFS() { SendRconCommand("unloadfs LuxAdmin");
}
//==============================================================================
// Time in Game
//==============================================================================
TotalGameTime(playerid, &h=0, &m=0, &s=0)
{
    AccInfo[playerid][TotalTime] = ( (gettime() - AccInfo[playerid][ConnectTime]) + (AccInfo[playerid][hours]*60*60) + (AccInfo[playerid][mins]*60) + (AccInfo[playerid][secs]) );

    h = floatround(AccInfo[playerid][TotalTime] / 3600, floatround_floor);
    m = floatround(AccInfo[playerid][TotalTime] / 60,   floatround_floor) % 60;
    s = floatround(AccInfo[playerid][TotalTime] % 60,   floatround_floor);

    return AccInfo[playerid][TotalTime];
}
//==============================================================================
//-------------------------------------
// Anti WeaponsHack
//-------------------------------------
//==============================================================================
public LoadForbiddenWeapons()
{
	if(dini_Exists("LuxAdmin/Config/ForbiddenWeapons.cfg"))
	{
	    new File:f=fopen("LuxAdmin/Config/ForbiddenWeapons.cfg", io_read),c,string[32];
	    while(fread(f,string,sizeof(string)) && c<MAX_FORBIDDEN_WEAPONS)
	    {
   			L_NewLine(string);
   			if(strlen(string))
       		{
       		ForbiddenWeapons[c]=strval(string);
       		c++;
	        }
	    }
	    fclose(f);
	    ForbiddenWeaponsCount=c;
	    return 1;
	}
	print("\nForbidden Weapons File NOT Loaded!\n");
	return 0;
}
public WeaponCheck(playerid)
{
	for(new i=0;i<MAX_PLAYERS;i++)
	{
		new lbweapon[64];
		new string[128];
		new var;
		new PlayerName[MAX_PLAYER_NAME];
		GetPlayerName(playerid, PlayerName, MAX_PLAYER_NAME);

		var=GetPlayerWeapon(i);
		if(IsForbiddenWeapon(var) && WeaponForbiddenForPlayer[i][var] && AccInfo[i][Level] == 0 && ServerInfo[ForbiddenWeaps] == 1)
		{
			SendClientMessage(i,lightred, "|- You have been Automatically Banned. | Reason: WeaponHack -| ");

			GetWeaponName(var,lbweapon,sizeof(lbweapon));
			format(lbweapon,sizeof(lbweapon),"Weapon Cheat (%s)",lbweapon);
			BanEx(i,lbweapon);

			format(string,sizeof(string),"|- Player %s (Id:%d) has been Automatically Banned. | Reason: Weapon Hack -|",PlayerName,i);
			SendClientMessageToAll(lightred, string);

	        new str[128];
			format(str,sizeof(str),"%s has been Automatically Banned. | Reason: WeaponHack",PlayerName);
			SaveIn("BanLog",str);
		}
	}
	return 1;
}
//==============================================================================
// Check Bot
//==============================================================================
public BotCheck(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(GetPlayerPing(playerid) < 1)
		{
			new string[128], ip[20];  GetPlayerIp(playerid,ip,sizeof(ip));
			format(string,sizeof(string),"BOT: %s id:%d ip: %s ping: %d",PlayerName2(playerid),playerid,ip,GetPlayerPing(playerid));
			SaveIn("BotKickLog",string);
		    SaveIn("KickLog",string);
			printf("[ADMIN] Possible bot has been detected (Kicked %s ID:%d)", PlayerName2(playerid), playerid);
			Kick(playerid);
		}
	}
}
//==============================================================================
// Position
//==============================================================================
public PutAtPos(playerid)
{
	if (dUserINT(PlayerName2(playerid)).("x")!=0)
	{
     	SetPlayerPos(playerid, float(dUserINT(PlayerName2(playerid)).("x")), float(dUserINT(PlayerName2(playerid)).("y")), float(dUserINT(PlayerName2(playerid)).("z")) );
 		SetPlayerInterior(playerid,	(dUserINT(PlayerName2(playerid)).("interior"))	);
	}
}
public PutAtDisconectPos(playerid)
{
	if (dUserINT(PlayerName2(playerid)).("x1")!=0) {
    	SetPlayerPos(playerid, float(dUserINT(PlayerName2(playerid)).("x1")), float(dUserINT(PlayerName2(playerid)).("y1")), float(dUserINT(PlayerName2(playerid)).("z1")) );
		SetPlayerInterior(playerid,	(dUserINT(PlayerName2(playerid)).("interior1"))	);
	}
}
//==============================================================================
// Freeze
//==============================================================================
public UnFreezeMe(player1)
{
	KillTimer( FreezeTimer[player1] );
	TogglePlayerControllable(player1,true);
	AccInfo[player1][Frozen] = 0;
	PlayerPlaySound(player1,1057,0.0,0.0,0.0);
	GameTextForPlayer(player1,"~g~Unfrozen",3000,3);
}
//==============================================================================
// Jail
//==============================================================================
public Jail1(player1)
{
	TogglePlayerControllable(player1,false);
	new Float:x, Float:y, Float:z;
	GetPlayerPos(player1,x,y,z);
	SetPlayerCameraPos(player1,x+10,y,z+10);
	SetPlayerCameraLookAt(player1,x,y,z);
	SetTimerEx("Jail2",1000,0,"d",player1);
}
public Jail2(player1)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(player1,x,y,z);
	SetPlayerCameraPos(player1,x+7,y,z+5);
	SetPlayerCameraLookAt(player1,x,y,z);
	if(GetPlayerState(player1) == PLAYER_STATE_ONFOOT) SetPlayerSpecialAction(player1,SPECIAL_ACTION_HANDSUP);
	GameTextForPlayer(player1,"~r~Busted By Officers",3000,3);
	SetTimerEx("Jail3",1000,0,"d",player1);
}
public Jail3(player1)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(player1,x,y,z);
	SetPlayerCameraPos(player1,x+3,y,z);
	SetPlayerCameraLookAt(player1,x,y,z);
}
public JailPlayer(player1)
{
	TogglePlayerControllable(player1,true);
	SetPlayerPos(player1,197.6661,173.8179,1003.0234);
	SetPlayerInterior(player1,3);
	SetCameraBehindPlayer(player1);
	JailTimer[player1] = SetTimerEx("UnjailPlayer",AccInfo[player1][JailTime],0,"d",player1);
	AccInfo[player1][Jailed] = 1;
}

public UnjailPlayer(player1)
{
	KillTimer( JailTimer[player1] );
	AccInfo[player1][JailTime] = 0;
	AccInfo[player1][Jailed] = 0;
	SetPlayerInterior(player1,0);
	SetPlayerPos(player1, 0.0, 0.0, 0.0);
	SpawnPlayer(player1);
	PlayerPlaySound(player1,1057,0.0,0.0,0.0);
	GameTextForPlayer(player1,"~g~Released ~n~From Jail",3000,3);
}
//==============================================================================
MaxAmmo(playerid)
{
	new slot, weap, ammo;
	for (slot = 0; slot < 14; slot++)
	{
    	GetPlayerWeaponData(playerid, slot, weap, ammo);
		if(IsValidWeapon(weap))
		{
		   	GivePlayerWeapon(playerid, weap, 99999);
		}
	}
	return 1;
}
stock DisableWord(const badword[], text[])
{
   	for(new i=0; i<256; i++)
   	{
		if (strfind(text[i], badword, true) == 0)
		{
			for(new a=0; a<256; a++)
			{
				if (a >= i && a < i+strlen(badword)) text[a]='*';
			}
		}
	}
}

argpos(const string[], idx = 0, sep = ' ')// (by yom)
{
    for(new i = idx, j = strlen(string); i < j; i++)
        if (string[i] == sep && string[i+1] != sep)
            return i+1;

    return -1;
}

//==============================================================================
public MessageToAdmins(color,const string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	if(IsPlayerConnected(i) == 1)
	if(AccInfo[i][Level] >= 1)
	SendClientMessage(i, color, string);
	}
	return 1;
}


public MessageToPlayerVIP(color,const string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	if(IsPlayerConnected(i) == 1)
	if(AccInfo[i][pVip] >= 1)
	SendClientMessage(i, color, string);
	}
	return 1;
}

stock SendCommandToAdmins(playerid,command[])
{
	if(ServerInfo[AdminCmdMsg] == 0)
	return 1;

	new string[128];
	GetPlayerName(playerid,string,sizeof(string));
	format(string,sizeof(string),"(DS) '%s' (Level: %d) | Command: %s",string,AccInfo[playerid][Level],command);
	return MessageToAdmins(blue,string);
}

stock StartTuneSound(playerid)
{
PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
return 1;
}

//==============================================================================
SavePlayerStats(playerid)
{
   	dUserSetINT(PlayerName2(playerid)).("Money",GetPlayerMoney(playerid));
   	dUserSetINT(PlayerName2(playerid)).("Kills",AccInfo[playerid][Kills]);
   	dUserSetINT(PlayerName2(playerid)).("Deaths",AccInfo[playerid][Deaths]);
    dUserSetINT(PlayerName2(playerid)).("WantedLevel",GetPlayerWantedLevel(playerid));
	#if SaveScore == true
	dUserSetINT(PlayerName2(playerid)).("Score",GetPlayerScore(playerid));
  	#endif

	new h, m, s;
    TotalGameTime(playerid, h, m, s);

	dUserSetINT(PlayerName2(playerid)).("Hours", h);
	dUserSetINT(PlayerName2(playerid)).("Minutes", m);
	dUserSetINT(PlayerName2(playerid)).("Seconds", s);

   	new Float:x,Float:y,Float:z, interior;
   	GetPlayerPos(playerid,x,y,z);
    interior = GetPlayerInterior(playerid);

    dUserSetINT(PlayerName2(playerid)).("x1",floatround(x));
	dUserSetINT(PlayerName2(playerid)).("y1",floatround(y));
	dUserSetINT(PlayerName2(playerid)).("z1",floatround(z));
    dUserSetINT(PlayerName2(playerid)).("interior1",interior);

	new weap1, ammo1, weap2, ammo2, weap3, ammo3, weap4, ammo4, weap5, ammo5, weap6, ammo6;

	GetPlayerWeaponData(playerid,2,weap1,ammo1);
	GetPlayerWeaponData(playerid,3,weap2,ammo2);
	GetPlayerWeaponData(playerid,4,weap3,ammo3);
	GetPlayerWeaponData(playerid,5,weap4,ammo4);
	GetPlayerWeaponData(playerid,6,weap5,ammo5);
	GetPlayerWeaponData(playerid,7,weap6,ammo6);

   	dUserSetINT(PlayerName2(playerid)).("Weapon1",weap1);
    dUserSetINT(PlayerName2(playerid)).("Weapon1Ammo",ammo1);
  	dUserSetINT(PlayerName2(playerid)).("Weapon2",weap2);
    dUserSetINT(PlayerName2(playerid)).("Weapon2Ammo",ammo2);
  	dUserSetINT(PlayerName2(playerid)).("Weapon3",weap3);
 	dUserSetINT(PlayerName2(playerid)).("Weapon3Ammo",ammo3);
	dUserSetINT(PlayerName2(playerid)).("Weapon4",weap4);
	dUserSetINT(PlayerName2(playerid)).("Weapon4Ammo",ammo4);
  	dUserSetINT(PlayerName2(playerid)).("Weapon5",weap5);
 	dUserSetINT(PlayerName2(playerid)).("Weapon5Ammo",ammo5);
	dUserSetINT(PlayerName2(playerid)).("Weapon6",weap6);
	dUserSetINT(PlayerName2(playerid)).("Weapon6Ammo",ammo6);

	new	Float:health;
	GetPlayerHealth(playerid, Float:health);
	new	Float:armour;
	GetPlayerArmour(playerid, Float:armour);
	new year,month,day;
	getdate(year, month, day);
	new strdate[20];
	format(strdate, sizeof(strdate), "%d.%d.%d",day,month,year);
	new file[256];
	format(file,sizeof(file),"/LuxAdmin/Accounts/%s.sav",udb_encode(PlayerName2(playerid)) );

	dUserSetINT(PlayerName2(playerid)).("Health",floatround(health));
    dUserSetINT(PlayerName2(playerid)).("Armour",floatround(armour));
	dini_Set(file,"LastOn",strdate);
	dUserSetINT(PlayerName2(playerid)).("Loggedin",0);
	dUserSetINT(PlayerName2(playerid)).("TimesOnServer",(dUserINT(PlayerName2(playerid)).("TimesOnServer"))+1);
}


//==============================================================================
//-------------------------------------
// Save Created Teleports
//-------------------------------------
//==============================================================================
public SaveTeleport()
{
	new File:TPFile = fopen("LuxAdmin/Config/CreatedTeles.cfg", io_write);
	new tpstring[256];
	for(new t=0;t<MAX_CTELES;t++)
	{
	if(CTeleInfo[t][TValid] == 1)
	{
		format(tpstring, sizeof(tpstring), "%s,%f,%f,%f,%f,%d\r\n",CTeleInfo[t][TName],CTeleInfo[t][PosX],CTeleInfo[t][PosY],CTeleInfo[t][PosZ],CTeleInfo[t][PosA],CTeleInfo[t][PosInt]);
		fwrite(TPFile, tpstring);
		}
	}
	fclose(TPFile);
}


//==============================================================================
//-------------------------------------
// Read TextDraws
//-------------------------------------
//==============================================================================
stock ReadTextDraws()
{
	Announcements = TextDrawCreate(7.000000, 432.000000, " ");
	TextDrawAlignment(Announcements,0);
	TextDrawBackgroundColor(Announcements, 255);
	TextDrawFont(Announcements, 1);
	TextDrawLetterSize(Announcements, 0.280000, 0.899999);
	TextDrawColor(Announcements, -1);
	TextDrawSetOutline(Announcements, 1);
	/*for(new l=0; l<130; l++)
	{
	GpsTD[l] = TextDrawCreate(326.000000, 362.000000, " ");
	TextDrawAlignment(GpsTD[l], 2);
	TextDrawBackgroundColor(GpsTD[l], 255);
	TextDrawFont(GpsTD[l], 1);
	TextDrawLetterSize(GpsTD[l], 0.300000, 1.100000);
	TextDrawColor(GpsTD[l], -1587871574);
	TextDrawSetOutline(GpsTD[l], 0);
	TextDrawSetProportional(GpsTD[l], 1);
	TextDrawSetShadow(GpsTD[l], 1);
	}*/
	return 1;
}
//==============================================================================
//-------------------------------------
// Configuration
//-------------------------------------
//==============================================================================
stock UpdateConfig()
{
	new file[256];

	format(file,sizeof(file),"LuxAdmin/Config/Config.ini");

	BadWordsCount = 0;
	BlockedNamesCount = 0;
	BlockedPartNameCount = 0;
	LoadForbiddenWeapons();

	if(!dini_Exists("LuxAdmin/Config/aka.txt")) dini_Create("LuxAdmin/Config/aka.txt");

	if(!dini_Exists(file))
	{
		dini_Create(file);
		print("\n Configuration File 'Config.ini' Successfully Created!");
	}

	if(!dini_Isset(file,"MaxPing"))
	dini_IntSet(file,"MaxPing",1200);
	if(!dini_Isset(file,"ReadPms"))
	dini_IntSet(file,"ReadPMs",1);
	if(!dini_Isset(file,"ReadCmds"))
	dini_IntSet(file,"ReadCmds",1);
	if(!dini_Isset(file,"MaxAdminLevel"))
	dini_IntSet(file,"MaxAdminLevel",5);
	if(!dini_Isset(file,"AdminOnlySkins"))
	dini_IntSet(file,"AdminOnlySkins",0);
	if(!dini_Isset(file,"AdminSkin"))
	dini_IntSet(file,"AdminSkin",217);
	if(!dini_Isset(file,"AdminSkin2"))
	dini_IntSet(file,"AdminSkin2",214);
	if(!dini_Isset(file,"AntiBot"))
	dini_IntSet(file,"AntiBot",1);
	if(!dini_Isset(file,"AntiSpam"))
	dini_IntSet(file,"AntiSpam",1);
	if(!dini_Isset(file,"AntiSwear"))
	dini_IntSet(file,"AntiSwear",1);
	if(!dini_Isset(file,"NameKick"))
	dini_IntSet(file,"NameKick",1);
 	if(!dini_Isset(file,"PartNameKick"))
	 dini_IntSet(file,"PartNameKick",1);
	if(!dini_Isset(file,"NoCaps"))
	dini_IntSet(file,"NoCaps",0);
	if(!dini_Isset(file,"Locked"))
	dini_IntSet(file,"Locked",0);
	if(!dini_Isset(file,"SaveWeap"))
	dini_IntSet(file,"SaveWeap",1);
	if(!dini_Isset(file,"SaveMoney"))
	dini_IntSet(file,"SaveMoney",1);
	if(!dini_Isset(file,"ConnectMessages"))
	dini_IntSet(file,"ConnectMessages",1);
	if(!dini_Isset(file,"AdminCmdMessages"))
	dini_IntSet(file,"AdminCmdMessages",1);
	if(!dini_Isset(file,"AutoLogin"))
	dini_IntSet(file,"AutoLogin",1);
	if(!dini_Isset(file,"MaxMuteWarnings"))
	dini_IntSet(file,"MaxMuteWarnings",4);
	if(!dini_Isset(file,"MustLogin"))
	dini_IntSet(file,"MustLogin",0);
	if(!dini_Isset(file,"MustRegister"))
	dini_IntSet(file,"MustRegister",0);
	if(!dini_Isset(file,"ForbiddenWeapons"))
	dini_IntSet(file,"ForbiddenWeapons",0);
	if(!dini_Isset(file,"AntiAdvertisements"))
	dini_IntSet(file,"AntiAdvertisements",0);
	if(!dini_Isset(file,"Announcements"))
	dini_IntSet(file,"Announcements",0);

	if(dini_Exists(file))
	{
	ServerInfo[MaxPing]          = dini_Int(file, "MaxPing"       		);
	ServerInfo[ReadPMs]          = dini_Int(file, "ReadPMs"        		);
	ServerInfo[ReadCmds]		 = dini_Int(file, "ReadCmds"			);
	ServerInfo[MaxAdminLevel]	 = dini_Int(file, "MaxAdminLevel"		);
	ServerInfo[AdminOnlySkins]	 = dini_Int(file, "AdminOnlySkins"		);
	ServerInfo[AdminSkin] 		 = dini_Int(file, "AdminSkin"			);
	ServerInfo[AdminSkin2]		 = dini_Int(file, "AdminSkin2"			);
	ServerInfo[AntiBot] 		 = dini_Int(file, "AntiBot"				);
	ServerInfo[AntiSpam] 		 = dini_Int(file, "AntiSpam"			);
	ServerInfo[AntiSwear] 		 = dini_Int(file, "AntiSwear"			);
	ServerInfo[NameKick]		 = dini_Int(file, "NameKick"			);
	ServerInfo[PartNameKick]	 = dini_Int(file, "PartNameKick"		);
	ServerInfo[NoCaps]			 = dini_Int(file, "NoCaps"				);
	ServerInfo[Locked]			 = dini_Int(file, "Locked"				);
	ServerInfo[GiveWeap] 		 = dini_Int(file, "SaveWeap"			);
	ServerInfo[GiveMoney]		 = dini_Int(file, "SaveMoney"			);
	ServerInfo[ConnectMessages]	 = dini_Int(file, "ConnectMessages"		);
	ServerInfo[AdminCmdMsg]		 = dini_Int(file, "AdminCmdMessages"	);
	ServerInfo[AutoLogin] 		 = dini_Int(file, "AutoLogin"			);
	ServerInfo[MaxMuteWarnings]	 = dini_Int(file, "MaxMuteWarnings"		);
	ServerInfo[MustLogin] 		 = dini_Int(file, "MustLogin"			);
	ServerInfo[MustRegister]	 = dini_Int(file, "MustRegister"		);
	ServerInfo[ForbiddenWeaps]	 = dini_Int(file, "ForbiddenWeapons"    );
	ServerInfo[AntiAds]	 		 = dini_Int(file, "AntiAdvertisements"  );
	ServerInfo[Announce]	 	 = dini_Int(file, "Announcements"  		);

	print("\n -Current Configurations Successfully Loaded!");
	}
}



//==============================================================================
// Cage/UnCage Function
//==============================================================================

public CagePrevent(playerid)
{
SetPlayerPos(playerid,LPosX[playerid],LPosY[playerid],LPosZ[playerid]);
TogglePlayerControllable(playerid, 0);
SendClientMessage(playerid,red,"|- You cant escape your punishment. You Are Still in Cage -|");
SetTimerEx("CagePlayer", 500, 0, "i", playerid);
SetTimerEx("UnCagePlayer", AccInfo[playerid][pCageTime]*1000, 0, "i", playerid);
return 1;
}

public CagePlayer(playerid)
{
	if(IsPlayerConnected(playerid))
	{
    	new Float:X, Float:Y, Float:Z;
    	GetPlayerPos(playerid, X, Y, Z);
    	cage[playerid]  = CreateObject(985, X, Y+4, Z, 0.0, 0.0, 0.0);
    	cage2[playerid] = CreateObject(985, X+4, Y, Z, 0.0, 0.0, 90.0);
    	cage3[playerid] = CreateObject(985, X-4, Y, Z, 0.0, 0.0, 270.0);
    	cage4[playerid] = CreateObject(985, X, Y-4, Z, 0.0, 0.0, 180.0);
    	TogglePlayerControllable(playerid, 1);
    	PlayerPlaySound(playerid,1137,0.0,0.0,0.0);
	   	GameTextForPlayer(playerid,"~w~~n~~n~~n~~n~~n~~n~~n~~n~~r~Caged",3000, 3);
	}
}
public UnCagePlayer(playerid)
{
	cage[playerid] 	= DestroyObject(cage[playerid]);
	cage2[playerid] = DestroyObject(cage2[playerid]);
	cage3[playerid] = DestroyObject(cage3[playerid]);
	cage4[playerid] = DestroyObject(cage4[playerid]);
	AccInfo[playerid][pCaged] = 0;
	AccInfo[playerid][pCageTime] = 0;
}

//==============================================================================
// Gps
//==============================================================================
public LuxGpsSys(playerid)
for(new g = 0;g < MAX_PLAYERS; g++)
if(IsPlayerConnected(g))
{
	if(AccInfo[g][pGps] != -1)
	{
		if(IsPlayerConnected(AccInfo[g][pGps]))
		{
			new Float:X,
				Float:Y,
				Float:Z;

			new Float:X2,
				Float:Y2,
				Float:Z2;

			new Distance,
			 	LuX_GpsCity[MAX_ZONE_NAME] = "Undetected City!",
			 	LuX_GpsZone[MAX_ZONE_NAME] = "Undetected Zone!";

			GetPlayerInCity(AccInfo[g][pGps], LuX_GpsCity, MAX_ZONE_NAME);
			GetPlayerInZone(AccInfo[g][pGps], LuX_GpsZone, MAX_ZONE_NAME);
			GetPlayerPos(g, X, Y, Z);
			GetPlayerPos(AccInfo[g][pGps], X2, Y2, Z2);

			Distance = floatround(floatsqroot(floatadd(floatadd(floatpower(floatabs(floatsub(X,X2)),2),floatpower(floatabs(floatsub(Y,Y2)),2)),floatpower(floatabs(floatsub(Z,Z2)),2))));
			if(Distance > 6.0)
			{
				//new str[256];
				new pname[256];

				#if GpsCheckPoint == true
				SetPlayerRaceCheckpoint(g, 0, X2, Y2, Z2+2, X2, Y2, Z2-10, 5.0);
				#endif
				//TextDrawShowForPlayer(g, GpsTD[g]);

				pname = pName(AccInfo[g][pGps]);
				pname = strreplace("[", "(", pname); pname = strreplace("[", "(", pname);
				pname = strreplace("]", ")", pname); pname = strreplace("]", ")", pname);

				#if GpsOnlyCity == true
				//format(str, 256, "~w~- %s -~n~~n~~b~Distance: ~w~%d ~l~- ~b~Radar: ~w~%s", pname,Distance, LuX_GpsCity);
				///TextDrawSetString(GpsTD[g], str);
				#else
				//format(str, 256, "~w~- %s -~n~~n~~b~Distance: ~w~%d ~l~- ~b~Radar: ~w~%s (%s)", pname,Distance, LuX_GpsZone, LuX_GpsCity);
				//TextDrawSetString(GpsTD[g], str);
				#endif
			}
			else
			{
			    #if GpsCheckPoint == true
			    DisablePlayerRaceCheckpoint(g);
			    #endif
			}
		}
		else
		{
  		AccInfo[g][pGps] = -1;
  		GameTextForPlayer(g,"~r~Gps Off~n~~g~The Player you used GPS on has left the Server!",3000,3);
		}
	}
	else
	{
		//TextDrawHideForPlayer(g, GpsTD[g]);
		if(IsDisable[g] == 0)
        #if GpsCheckPoint == true
		DisablePlayerRaceCheckpoint(g);
		#endif
		IsDisable[g] = 1;
	}
}


//==============================================================================
// Advertisement Check
//==============================================================================
stock AdvertisementCheck(string[])
{
	if(string[0])
	{
		if(!strfind(string,"www.",false) || !strfind(string,"http://",false)
		|| !strfind(string,".com",false) || !strfind(string,".net",false)
		|| !strfind(string,".de",false)  || !strfind(string,".org",false))
  		return true;

		new c=1,idx,tmp[32],ip[4];
		for(new i=0;i<strlen(string);i++)
  		if(string[i]==' ')
  		c++;

		for(new i=0;i<c;i++)
		{
		    idx=0;
		    tmp = L_strtok(string,idx);
		    idx=0;
		    tmp = L_strtok(tmp,idx,':');
			ip=SplitIP(tmp);
			if(ip[0] && ip[1] && ip[2] && ip[3]) // We have found and IP :o
   			return true;
		}
	}
	return false;
}
//==============================================================================
// Verify if Vehicle if Occupied
//==============================================================================
public VehicleOccupied(vehicleid)
{
for(new i=0;i<MAX_PLAYERS;i++)
{
if(IsPlayerInVehicle(i,vehicleid)) return 1;
}
return 0;
}
//==============================================================================
//-------------------------------------
// RCON Attempts
//-------------------------------------
//==============================================================================
public OnRconLoginAttempt(ip[], password[], success)
{
//====================================
// INCORRECT RCON
//====================================
	if(!success)
	{
		if(!dini_Exists("LuxAdmin/Config/BadRconLogins.txt"))
			dini_Create("LuxAdmin/Config/BadRconLogins.txt");

		new attempts=dini_Int("LuxAdmin/Config/BadRconLogins.txt",ip);
		attempts++;
		if(attempts>=MAX_RCON_ATTEMPS)
		{
			new cmd[32];
			format(cmd,sizeof(cmd),"banip %s",ip);
			SendRconCommand(cmd);
		}
		dini_IntSet("LuxAdmin/Config/BadRconLogins.txt",ip,attempts);
	}
//====================================
// CORRECT RCON
//====================================
	#if EnableTwoRcon == true
	else
	{
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
  			if(IsPlayerConnected(i))
  			{
  			    new pIP[16];
				GetPlayerIp(i, pIP, 16);
				if(!strcmp(pIP,ip,true))
				{
					new string[128];
					format(string,sizeof(string),"This server uses a system of two RCON passwords. \n\nFor access the account, you must enter the second password RCON.");
					ShowPlayerDialog(i, DIALOG_TYPE_RCON2, DIALOG_STYLE_INPUT,"LuxAdmin - RCON!",string, "Enter", "Exit");
				}
			}
		}
	}
	#endif
}
//==============================================================================
//-------------------------------------
// Save In File
//-------------------------------------
//==============================================================================

public SaveIn(filename[],text[])
{
	#if SaveLogs == true
	new File:Lfile;
	new filepath[256];
	new string[256];
	new year,month,day;
	new hour,minute,second;

	getdate(year,month,day);
	gettime(hour,minute,second);
	format(filepath,sizeof(filepath),"LuxAdmin/Logs/%s.txt",filename);
	Lfile = fopen(filepath,io_append);
	format(string,sizeof(string),"[%02d/%02d/%02d | %02d:%02d:%02d] %s\r\n",day,month,year,hour,minute,second,text);
	fwrite(Lfile,string);
	fclose(Lfile);
	#endif
	return 1;
}
//==============================================================================
//-------------------------------------
// CountDown
//-------------------------------------
//==============================================================================
public CountDown(playerid)
{
	if(cd_sec == 0)
	{
	    for(new i; i < MAX_PLAYERS; i++)
	    {
	    	if(AccInfo[i][Frozen] == 0)
	    	{
				TogglePlayerControllable(i, 1);
			}
		}
		PlaySound(playerid, 1058);
		GameTextForAll("~r~Go!",1000,3);
		CdStated = 0;
		KillTimer(cd_timer);
	}
	else
	{
		new string[256];
		PlaySound(playerid, 1057);
		format(string,256,"~g~%d",cd_sec);
		GameTextForAll(string,1000,3);
	}
	cd_sec = cd_sec-1;
	return 1;
}
stock PlaySound (playerid,sound)
{
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	PlayerPlaySound(playerid, sound, X, Y, Z);
	return sound;
}

//==============================================================================
//-------------------------------------
// Announcements
//-------------------------------------
//==============================================================================
public RandomMessage()
{
	if(ServerInfo[Announce] == 1)
 	TextDrawSetString(Announcements, RandomMessages[random(sizeof(RandomMessages))]);
 	return 1;
}

//=============================================================================================================
stock ShowConfigInConsole()
{
		#if ConfigInConsole == true
	    new rAutoLogin  [9],rReadCmds   [9],rReadPMs  [9],rAntiSpam  [9],rNameKick   [9],rAntiBot [9];
	    new rLocked     [9],rConnectMsg [9], rACmdMsg [9],rAntiSwear [9],rSaveWeapon [9],rASkins  [9];
	    new rDisableChat[9],rMustLogin  [9],rMustReg  [9],rNoCaps    [9],rSaveMoney  [9],rFWeaps  [9];
		new rAntiAds    [9];

	    if(ServerInfo[AutoLogin] 	 	== 1) rAutoLogin 	= "Enabled!"; else rAutoLogin 	 = "Disabled";
	    if(ServerInfo[ReadCmds] 	 	== 1) rReadCmds  	= "Enabled!"; else rReadCmds  	 = "Disabled";
	    if(ServerInfo[ReadPMs] 	 	 	== 1) rReadPMs  	= "Enabled!"; else rReadPMs    	 = "Disabled";
	    if(ServerInfo[AntiSpam]		 	== 1) rAntiSpam 	= "Enabled!"; else rAntiSpam	 = "Disabled";
	    if(ServerInfo[NameKick]  	 	== 1) rNameKick		= "Enabled!"; else rNameKick	 = "Disabled";
	    if(ServerInfo[AdminOnlySkins]  	== 1) rASkins		= "Enabled!"; else rASkins		 = "Disabled";
	    if(ServerInfo[AntiBot] 			== 1) rAntiBot 		= "Enabled!"; else rAntiBot	 	 = "Disabled";
	    if(ServerInfo[AntiSwear] 	 	== 1) rAntiSwear	= "Enabled!"; else rAntiSwear 	 = "Disabled";
	    if(ServerInfo[Locked] 	  	 	== 1) rLocked 	    = "Enabled!"; else rLocked     	 = "Disabled";
	    if(ServerInfo[ConnectMessages]  == 1) rConnectMsg   = "Enabled!"; else rConnectMsg   = "Disabled";
	    if(ServerInfo[AdminCmdMsg]      == 1) rACmdMsg   	= "Enabled!"; else rACmdMsg		 = "Disabled";
	    if(ServerInfo[DisableChat] 		== 1) rDisableChat  = "Enabled!"; else rDisableChat  = "Disabled";
	    if(ServerInfo[MustLogin] 		== 1) rMustLogin    = "Enabled!"; else rMustLogin 	 = "Disabled";
	    if(ServerInfo[MustRegister]		== 1) rMustReg	    = "Enabled!"; else rMustReg		 = "Disabled";
	    if(ServerInfo[NoCaps]			== 1) rNoCaps	    = "Enabled!"; else rNoCaps		 = "Disabled";
	    if(ServerInfo[GiveWeap]			== 1) rSaveWeapon   = "Enabled!"; else rSaveWeapon   = "Disabled";
	    if(ServerInfo[GiveMoney] 		== 1) rSaveMoney    = "Enabled!"; else rSaveMoney    = "Disabled";
	    if(ServerInfo[ForbiddenWeaps] 	== 1) rFWeaps    	= "Enabled!"; else rFWeaps     	 = "Disabled";
	    if(ServerInfo[ForbiddenWeaps] 	== 1) rFWeaps    	= "Enabled!"; else rFWeaps     	 = "Disabled";
	    if(ServerInfo[AntiAds] 			== 1) rAntiAds    	= "Enabled!"; else rAntiAds      = "Disabled";

		print(" -> L.A.S Basic Loaded Configurations:\n");

		printf(" AutoLogin:    [%s]  ReadCmds:  [%s]", 		rAutoLogin,  rReadCmds);
		printf(" AntiSwear:    [%s]  AntiSpam:  [%s]", 		rAntiSwear, rAntiSpam);
		printf(" NameKick:     [%s]  AntiBot:   [%s]",		rNameKick, rAntiBot);
		printf(" ConnectMsgs:  [%s]  NoCaps:    [%s]",		rConnectMsg, rNoCaps);
		printf(" AdminCmdMsgs: [%s]  Anti Ads:  [%s]",		rACmdMsg, rAntiAds);
		printf(" SaveMoney:    [%s]  MustLogin  [%s]", 		rSaveMoney, rMustLogin);
        printf(" Forbid Weaps: [%s]  AdmSkins:  [%s]",		rFWeaps, rASkins,rMustReg);
        printf(" ReadPms:      [%s]  MaxLevel:  [%d]", 		rReadPMs, ServerInfo[MaxAdminLevel]);
        printf(" SaveWeaps     [%s]  Max Ping:  [%dms]",	rSaveWeapon,ServerInfo[MaxPing]);
        printf(" ChatDisabled: [%s]  MuteWarns: [%d]",		rDisableChat,ServerInfo[MaxMuteWarnings]);
        printf(" MustRegister: [%s]  AdmSkins   [%d, %d]\n",rMustReg, ServerInfo[AdminSkin], ServerInfo[AdminSkin2]);
        #endif
		return 1;
}

#if EnableCamHack == true
//==================================================
//ROTATING CAMERA
//==================================================
public CheckKeyPress(playerid)
{
    new keys, updown, leftright;
    GetPlayerKeys(playerid, keys, updown, leftright);

    if(AccInfo[playerid][InCamMod] == 1)
	{
	    if(KeyState[playerid] == 1 || KeyState[playerid] == 3)
	    {
			if(leftright == KEY_RIGHT)
			{
			    if(KeyState[playerid] == 3)
			    {
			        PCA[playerid] = (PCA[playerid]-SPEED_ROTATE_LEFTRIGHT_FAST);
			    }
			    else
			    {
			    	PCA[playerid] = (PCA[playerid]-SPEED_ROTATE_LEFTRIGHT_SLOW);
				}
				if(PCA[playerid] <= 0)
				{
				    PCA[playerid] = (360-PCA[playerid]);
				}
				MovePlayerCamera(playerid);
			}
			if(leftright == KEY_LEFT)
			{
			    if(KeyState[playerid] == 3)
			    {
			        PCA[playerid] = (PCA[playerid]+SPEED_ROTATE_LEFTRIGHT_FAST);
			    }
			    else
			    {
			    	PCA[playerid] = (PCA[playerid]+SPEED_ROTATE_LEFTRIGHT_SLOW);
				}
				if(PCA[playerid] >= 360)
				{
				    PCA[playerid] = (PCA[playerid]-360);
				}
				MovePlayerCamera(playerid);
			}
			if(updown == KEY_UP)
			{
			    if(PCL[playerid][2] < (PCP[playerid][2]+5))
			    {
					if(KeyState[playerid] == 3)
					{
					    PCL[playerid][2] = PCL[playerid][2]+SPEED_ROTATE_UPDOWN_FAST;
					}
					else
					{
					    PCL[playerid][2] = PCL[playerid][2]+SPEED_ROTATE_UPDOWN_SLOW;
					}
				}
				MovePlayerCamera(playerid);
			}
			if(updown == KEY_DOWN)
			{
			    if(PCL[playerid][2] > (PCP[playerid][2]-5))
			    {
					if(KeyState[playerid] == 3)
					{
					    PCL[playerid][2] = PCL[playerid][2]-SPEED_ROTATE_UPDOWN_FAST;
					}
					else
					{
					    PCL[playerid][2] = PCL[playerid][2]-SPEED_ROTATE_UPDOWN_SLOW;
					}
				}
				MovePlayerCamera(playerid);
			}
		}

		//==================================================
	    //MOVING CAMERA UP/DOWN
	    //==================================================
		if(KeyState[playerid] == 4 || KeyState[playerid] == 5)
		{
			if(updown == KEY_UP)
			{
			    if(KeyState[playerid] == 4)  //Slow Up
			    {
			        PCP[playerid][2] = (PCP[playerid][2]+SPEED_MOVE_UPDOWN_SLOW);
			        PCL[playerid][2] = (PCL[playerid][2]+SPEED_MOVE_UPDOWN_SLOW);
	                SetPlayerCameraPos(playerid, PCP[playerid][0], PCP[playerid][1], PCP[playerid][2]);
					SetPlayerCameraLookAt(playerid, PCL[playerid][0], PCL[playerid][1], PCL[playerid][2]);
				}
				else if(KeyState[playerid] == 5)  //Fast Up
			    {
			        PCP[playerid][2] = (PCP[playerid][2]+SPEED_MOVE_UPDOWN_FAST);
			        PCL[playerid][2] = (PCL[playerid][2]+SPEED_MOVE_UPDOWN_FAST);
	                SetPlayerCameraPos(playerid, PCP[playerid][0], PCP[playerid][1], PCP[playerid][2]);
					SetPlayerCameraLookAt(playerid, PCL[playerid][0], PCL[playerid][1], PCL[playerid][2]);
				}
			}
			if(updown == KEY_DOWN)
			{
			    if(KeyState[playerid] == 4)  //Slow Down
			    {
			        PCP[playerid][2] = (PCP[playerid][2]-SPEED_MOVE_UPDOWN_SLOW);
			        PCL[playerid][2] = (PCL[playerid][2]-SPEED_MOVE_UPDOWN_SLOW);
	                SetPlayerCameraPos(playerid, PCP[playerid][0], PCP[playerid][1], PCP[playerid][2]);
					SetPlayerCameraLookAt(playerid, PCL[playerid][0], PCL[playerid][1], PCL[playerid][2]);
				}
				else if(KeyState[playerid] == 5)  //Fast Down
			    {
			        PCP[playerid][2] = (PCP[playerid][2]-SPEED_MOVE_UPDOWN_FAST);
			        PCL[playerid][2] = (PCL[playerid][2]-SPEED_MOVE_UPDOWN_FAST);
	                SetPlayerCameraPos(playerid, PCP[playerid][0], PCP[playerid][1], PCP[playerid][2]);
					SetPlayerCameraLookAt(playerid, PCL[playerid][0], PCL[playerid][1], PCL[playerid][2]);
				}
			}
		}



		//==================================================
	    //MOVING CAMERA
	    //==================================================
		else if(KeyState[playerid] == 2 || KeyState[playerid] == 0)
		{
		    if(leftright == KEY_RIGHT)
			{
	            new Float:Angle;
				Angle = PCA[playerid];
				Angle -= 90.0;
			    if(KeyState[playerid] == 2)
				{

			        PCP[playerid][0] = PCP[playerid][0] + floatmul(floatsin(-Angle, degrees), SPEED_MOVE_LEFTRIGHT_FAST);
					PCP[playerid][1] = PCP[playerid][1] + floatmul(floatcos(-Angle, degrees), SPEED_MOVE_LEFTRIGHT_FAST);
					PCL[playerid][0] = PCL[playerid][0] + floatmul(floatsin(-Angle, degrees), SPEED_MOVE_LEFTRIGHT_FAST);
					PCL[playerid][1] = PCL[playerid][1] + floatmul(floatcos(-Angle, degrees), SPEED_MOVE_LEFTRIGHT_FAST);
			    }
			    else
				{
			    	PCP[playerid][0] = PCP[playerid][0] + floatmul(floatsin(-Angle, degrees), SPEED_MOVE_LEFTRIGHT_SLOW);
					PCP[playerid][1] = PCP[playerid][1] + floatmul(floatcos(-Angle, degrees), SPEED_MOVE_LEFTRIGHT_SLOW);
					PCL[playerid][0] = PCL[playerid][0] + floatmul(floatsin(-Angle, degrees), SPEED_MOVE_LEFTRIGHT_SLOW);
					PCL[playerid][1] = PCL[playerid][1] + floatmul(floatcos(-Angle, degrees), SPEED_MOVE_LEFTRIGHT_SLOW);
				}
				SetPlayerCameraPos(playerid, PCP[playerid][0], PCP[playerid][1], PCP[playerid][2]);
				SetPlayerCameraLookAt(playerid, PCL[playerid][0], PCL[playerid][1], PCL[playerid][2]);
			}
			if(leftright == KEY_LEFT)
			{
			    new Float:Angle;
				Angle = PCA[playerid];
				Angle += 90.0;
			    if(KeyState[playerid] == 2)
				{
			        PCP[playerid][0] = PCP[playerid][0] + floatmul(floatsin(-Angle, degrees), SPEED_MOVE_LEFTRIGHT_FAST);
					PCP[playerid][1] = PCP[playerid][1] + floatmul(floatcos(-Angle, degrees), SPEED_MOVE_LEFTRIGHT_FAST);
					PCL[playerid][0] = PCL[playerid][0] + floatmul(floatsin(-Angle, degrees), SPEED_MOVE_LEFTRIGHT_FAST);
					PCL[playerid][1] = PCL[playerid][1] + floatmul(floatcos(-Angle, degrees), SPEED_MOVE_LEFTRIGHT_FAST);
			    }
			    else
				{
			    	PCP[playerid][0] = PCP[playerid][0] + floatmul(floatsin(-Angle, degrees), SPEED_MOVE_LEFTRIGHT_SLOW);
					PCP[playerid][1] = PCP[playerid][1] + floatmul(floatcos(-Angle, degrees), SPEED_MOVE_LEFTRIGHT_SLOW);
					PCL[playerid][0] = PCL[playerid][0] + floatmul(floatsin(-Angle, degrees), SPEED_MOVE_LEFTRIGHT_SLOW);
					PCL[playerid][1] = PCL[playerid][1] + floatmul(floatcos(-Angle, degrees), SPEED_MOVE_LEFTRIGHT_SLOW);
				}
				SetPlayerCameraPos(playerid, PCP[playerid][0], PCP[playerid][1], PCP[playerid][2]);
				SetPlayerCameraLookAt(playerid, PCL[playerid][0], PCL[playerid][1], PCL[playerid][2]);
			}

			if(updown == KEY_UP)
			{
			    new Float:X, Float:Y, Float:Z;
	      		if(KeyState[playerid] == 2)
				{
				    GetCoordsOnLine3D(PCP[playerid][0], PCP[playerid][1], PCP[playerid][2], PCL[playerid][0], PCL[playerid][1], PCL[playerid][2], SPEED_MOVE_FORWARDBACKWARD_FAST, X, Y, Z);
				    PCP[playerid][0] = X;
				    PCP[playerid][1] = Y;
				    PCP[playerid][2] = Z;
					X = 0.0; Y=0.0; Z=0.0;
				    GetCoordsOnLine3D(PCP[playerid][0], PCP[playerid][1], PCP[playerid][2], PCL[playerid][0], PCL[playerid][1], PCL[playerid][2], 5.0, X, Y, Z);
				    PCL[playerid][0] = X;
				    PCL[playerid][1] = Y;
				    PCL[playerid][2] = Z;
				    SetPlayerCameraPos(playerid, PCP[playerid][0], PCP[playerid][1], PCP[playerid][2]);
					SetPlayerCameraLookAt(playerid, PCL[playerid][0], PCL[playerid][1], PCL[playerid][2]);
				}
				else
				{
				    GetCoordsOnLine3D(PCP[playerid][0], PCP[playerid][1], PCP[playerid][2], PCL[playerid][0], PCL[playerid][1], PCL[playerid][2], SPEED_MOVE_FORWARDBACKWARD_SLOW, X, Y, Z);
				    PCP[playerid][0] = X;
				    PCP[playerid][1] = Y;
				    PCP[playerid][2] = Z;
					X = 0.0; Y=0.0; Z=0.0;
				    GetCoordsOnLine3D(PCP[playerid][0], PCP[playerid][1], PCP[playerid][2], PCL[playerid][0], PCL[playerid][1], PCL[playerid][2], 5.0, X, Y, Z);
				    PCL[playerid][0] = X;
				    PCL[playerid][1] = Y;
				    PCL[playerid][2] = Z;
				    SetPlayerCameraPos(playerid, PCP[playerid][0], PCP[playerid][1], PCP[playerid][2]);
					SetPlayerCameraLookAt(playerid, PCL[playerid][0], PCL[playerid][1], PCL[playerid][2]);
				}
			}

			if(updown == KEY_DOWN)
			{
			    new Float:X, Float:Y, Float:Z;
				if(KeyState[playerid] == 2)
				{
				    GetCoordsOnLine3D(PCP[playerid][0], PCP[playerid][1], PCP[playerid][2], PCL[playerid][0], PCL[playerid][1], PCL[playerid][2], -SPEED_MOVE_FORWARDBACKWARD_FAST, X, Y, Z);
				    PCP[playerid][0] = X;
				    PCP[playerid][1] = Y;
				    PCP[playerid][2] = Z;
				    X = 0.0; Y=0.0; Z=0.0;
				    GetCoordsOnLine3D(PCP[playerid][0], PCP[playerid][1], PCP[playerid][2], PCL[playerid][0], PCL[playerid][1], PCL[playerid][2], 5.0, X, Y, Z);
				    PCL[playerid][0] = X;
				    PCL[playerid][1] = Y;
				    PCL[playerid][2] = Z;
				    SetPlayerCameraPos(playerid, PCP[playerid][0], PCP[playerid][1], PCP[playerid][2]);
					SetPlayerCameraLookAt(playerid, PCL[playerid][0], PCL[playerid][1], PCL[playerid][2]);
				}
				else
				{
				    GetCoordsOnLine3D(PCP[playerid][0], PCP[playerid][1], PCP[playerid][2], PCL[playerid][0], PCL[playerid][1], PCL[playerid][2], -SPEED_MOVE_FORWARDBACKWARD_SLOW, X, Y, Z);
				    PCP[playerid][0] = X;
				    PCP[playerid][1] = Y;
				    PCP[playerid][2] = Z;
				    X = 0.0; Y=0.0; Z=0.0;
				    GetCoordsOnLine3D(PCP[playerid][0], PCP[playerid][1], PCP[playerid][2], PCL[playerid][0], PCL[playerid][1], PCL[playerid][2], 5.0, X, Y, Z);
				    PCL[playerid][0] = X;
				    PCL[playerid][1] = Y;
				    PCL[playerid][2] = Z;
				    SetPlayerCameraPos(playerid, PCP[playerid][0], PCP[playerid][1], PCP[playerid][2]);
					SetPlayerCameraLookAt(playerid, PCL[playerid][0], PCL[playerid][1], PCL[playerid][2]);
				}
			}
		}
	}
}

stock MovePlayerCamera(playerid)
{
	PCL[playerid][0] = PCP[playerid][0] + (floatmul(5.0, floatsin(-PCA[playerid], degrees)));
	PCL[playerid][1] = PCP[playerid][1] + (floatmul(5.0, floatcos(-PCA[playerid], degrees)));
	SetPlayerCameraPos(playerid, PCP[playerid][0], PCP[playerid][1], PCP[playerid][2]);
	SetPlayerCameraLookAt(playerid, PCL[playerid][0], PCL[playerid][1], PCL[playerid][2]);
}

GetCoordsOnLine3D(Float:startX, Float:startY, Float:startZ, Float:endX, Float:endY, Float:endZ, Float:length, &Float:RX, &Float:RY, &Float:RZ) //Original function by Nubotron. Slightly edited by me.
{
    RX = startX - endX;
    RY = startY - endY;
    RZ = startZ - endZ;
    new Float:sqrt = floatsqroot((RX * RX) + (RY * RY) + (RZ * RZ));
    if (sqrt < 0.01)
        sqrt = 0.01;
    RX = -length * (RX / sqrt) + startX;
    RY = -length * (RY / sqrt) + startY;
    RZ = -length * (RZ / sqrt) + startZ;
}

stock Float:GetAngle(playerid, Float:x, Float:y)
{
	new Float: Pa;
	Pa = floatabs(atan((y-PCP[playerid][1])/(x-PCP[playerid][0])));
	if (x <= PCP[playerid][0] && y >= PCP[playerid][1]) Pa = floatsub(180, Pa);
	else if (x < PCP[playerid][0] && y < PCP[playerid][1]) Pa = floatadd(Pa, 180);
	else if (x >= PCP[playerid][0] && y <= PCP[playerid][1]) Pa = floatsub(360.0, Pa);
	Pa = floatsub(Pa, 90.0);
	if (Pa >= 360.0) Pa = floatsub(Pa, 360.0);
	return Pa;
}

public FollowPlayer(playerid)
{
	new Float:PX, Float:PY, Float:PZ;
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, PX, PY, PZ);
	GetCoordsOnLine3D(PCP[playerid][0], PCP[playerid][1], PCP[playerid][2], PX, PY, PZ, 5.0, X, Y, Z);
	PCL[playerid][0] = X;
    PCL[playerid][1] = Y;
    PCL[playerid][2] = Z;
    PCA[playerid] = GetAngle(playerid, PX, PY);
	SetPlayerCameraLookAt(playerid, PCL[playerid][0], PCL[playerid][1], PCL[playerid][2]);
}
#endif

// © LuxurioN 2010 - All rights Reserved
