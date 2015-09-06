#if defined J_L_A_D_M_I_N
______________________________________________________________________________________
JL administration system v1.0 beta
=======================================================================================
Released Date: 02/04/2013
Last updated: 03/04/2013 
----------- (patch applied)------------------
* Improved the dialogs performance.
* Improved the anti crash system in Gametext.
---------------------------------------------

=======================================================================================
_____________Please vist following Thread for more informations__________________

* Updates, Bugs and suggestions - http://forum.sa-mp.com/showthread.php?t=427582
_______________________________________________________________________________________
#endif

#include <a_samp>
#include <YSI\y_ini> //Thanks to Y_Less
#include <sscanf2>   //Thanks to Y_Less
#include <foreach>   //Thanks to Y_Less
#define FILTERSCRIPT
#include <zcmd>      //Thanks to Zeex


#define ACCOUNTS_PATH "JLadmin/Users/%s.ini"
#define LOGS_PATH "JLadmin/Logs/%s.txt"
#define SETTING_PATH "JLadmin/Settings/%s.ini"
#define MAX_LOGIN_ATTEMPTS  3

#define WEBSITE "YourWebsiteHere"      // Type your server website here
/*____________________________________
-------Choose your settings-----------
======================================*/
//------------------------------------
#define LoginTextDraw         true     //Login textdraw( The buttons you see when login) set'false' to disable.
//------------------------------------
#define SpecTextDraw          true     //Spetating textdraw. set 'false' to disable.
//------------------------------------
#define PauseDetectSystem     true     //Automatically pausers detect system. set 'false' to disable.
//------------------------------------
#define MoveSystem            false     //Move system is similar as airbrek. set 'true' to enable.
//------------------------------------

#define MAX_WARNS 		      3 	   // Server Maximum Warnings per player.
#define MaxPingExceeds        2        // Maximum ping exceeds per each player. NOTE: You can change Server Max ping from Settings.cfg file
#define MAX_ILLEGAL_WEAPONS   20       // Maximum illegal/forbidden weapons IDs
#define MAX_FORBIDDEN_NAMES   30       // Maximum forbidden names
#define MAX_BADNICKS_PARTS    20       // Maximum forbidden part nick names
#define MAX_BAD_WORDS         50       // Maximum bad words amount
#define MAX_CHAT_MSGS_STORE   15       // Maximum chat lines store ( working with RCON chat command)
#define MAX_REPORTS_STORE     6        // Maximum reports store ( /reports)
#define MAX_SPAM_WARNS        2        // Maximum spam warrings
#define AUTO_MUTE_TIME        60       // Automatically mute time for spam
#define MaxVipLevel           3        // Maximum V.I.P level
#define MAX_TELEPORTS         50       // Maxium teleports (teleports.ini)
//-----------------------------------

/*Admin level names*/
#define ADMIN_LEVEL_1 "Moderator"
#define ADMIN_LEVEL_2 "Administrator"         
#define ADMIN_LEVEL_3 "Head Administrator"    
#define ADMIN_LEVEL_4 "Global Administrator"  
#define ADMIN_LEVEL_5 "Master Administrator"  
#define ADMIN_LEVEL_6 "Server Owner"          //Administrator level 6+ name
//-----------------------------------

/*V.I.P levels names*/
#define VIP_LEVEL_1 "Bronze"                  //V.I.P level 1 name
#define VIP_LEVEL_2 "Silver"                  //V.I.P level 2 name
#define VIP_LEVEL_3 "Gold"                    //V.I.P level 3 name
//-----------------------------------

/*Admin level Colours*/
#define LEVEL_1_COLOR "{09F7DF}"              //Administrator Level 1 colour
#define LEVEL_2_COLOR "{F2F20D}"              //Administrator Level 2 colour
#define LEVEL_3_COLOR "{FF8000}"              //Administrator Level 3 colour
#define LEVEL_4_COLOR "{0000FF}"              //Administrator Level 4 colour
#define LEVEL_5_COLOR "{00FF1A}"              //Administrator Level 5 colour
#define LEVEL_6_COLOR "{FF1A00}"              //Administrator Level 6+ colour
//-----------------------------------

/*V.I.P level Colours*/
#define VIP_1_COLOR "{C48D3C}"                //V.I.P Level 1 colour
#define VIP_2_COLOR "{DDDDDD}"                //V.I.P Level 2 colour
#define VIP_3_COLOR "{F7C709}"                //V.I.P Level 3 colour
//-----------------------------------

#define ADMCHATKEY   '@'         //Administrators chat key
#define DONATORCHATKEY '$'       //Donator(V.I.P) chat key
#define START_SCORE   0          //Player Score when register an new account on JLadmin
#define START_CASH    0          //Player Money when register an new account on JLadmin
#define MAX_CAR_SPAWNS  20       //Maximum vehicle spawns for each admin (To prevent car food on server) Use /destroycars to destroy cars which created with /spawncar (or they will automatically get destroy when the admin disconnected)
//-----------------------------------

/*Dialogs ID(s)*/
#define DIALOG_REGISTER 1995
#define DIALOG_LOGIN    1996
#define JDIALOGS        2000
#define DIALOG_PRIVATE_MESSAGE 1997
//-----------------------------------

/*Colours*/
#define green        0x1AFF00C8
#define red          0xFF0000C8
#define blue         0x0080C0C8
#define lighterblue  0x09F7DFC8
#define yellow       0xFFFF00C8
#define orange       0xFF8000C8
#define pink         0xFF00FFC8
#define purple       0x8000FFC8
#define black        0x000000C8
#define white        0xFFFFFFC8
#define brown        0x800000C8
#define cream        0xFFFF80C8
#define Cmdcolor     0xCCCCCCC8
#define Admchat      0x00FF80C8    //Administrators chat colour
//-----------------------------------

forward GetPassword(playerid, name[], value[]);
forward LoginPlayer(playerid, name[], value[]);
forward LoadServerSetttings(name[], value[]);
forward GiveVehicle(playerid,vehicleid);
forward SpawnVehicle(playerid,vehicleid);
forward GetPlayerInfo(playerid, name[], value[]);
forward BanPlayer(playerid,reasonid);
forward KickPlayer(playerid);
forward Kickallplayers(playerid);
forward StoreChatLine(playerid,text[]);
forward StoreReport(playerid,reported,reason[]);
forward CountDown();
forward Unfreeze(playerid);
forward UnmutePlayer(playerid);
forward Specoff(playerid);
forward GetAkaLog(name[], value[]);
forward AccountsEditor(name[], value[]);
forward HidePlayer(playerid);
forward Unjail(playerid);
forward JailPlayer(playerid);
forward PlayerCheker();
forward OnPrivateMessage(sender, recieverid, Message[]);
forward OnPlayerVirtualWorldChange(playerid, newwordid, oldworldid);
forward LoadTeleports();
forward PlayerLevel(playerid);
forward VipLevel(playerid);

native WP_Hash(buffer[], len, const str[]);

enum PlayerInfo
{
	Registered,
	Logged,
	pLevel,
	Banned,
	Kills,
	Deaths,
	Jailed,
	Muted,
	GodMode,
	VGod,
	Frozen,
	Donator,
	Spawned,
	Password[130],
	Score,
	Cash,
	Skin,
	pAutoLogin,
	LoginAttempts,
	PingExceeds,
	Spec,
	#if MoveSystem == true
	Move,
	#endif
	Locked,
	Warns,
	Hidden,
	AHide,
	VWorld,
	NameTagHidden,
	Clicked,
	SpamWarns,
	AntiCheatWarns,
	TempBan,
	TotalSecs,
	ConnectedTime,
	Cars[MAX_CAR_SPAWNS],
	SpawnedCars,
	LastSpawnedCar,
	IP[16],
};

new
	AutoLogin,
	MustRegister,
    DetectPausers,
	MaxPing,
	AntiSpam,
	AntiWeaponHack,
	AntiCheatBans,
	MaxAdminLevel,
	ForbiddenNamesKick,
	KickPartNicks,
	AntiForbiddenWords,
	AntiAdv,
	AntiBanEvade,
	AdminImmunity,
	AllowChangeNick,
	PmDialog,
	ShowPmstoAdmins,
	ReadCommands,
	IsDisabledChat,
	LTimer,
	IllegalWeaponsCount,
	IllegalWeapons[MAX_ILLEGAL_WEAPONS],
	ForbiddeNicksCount,
	ForbiddeNicks[MAX_FORBIDDEN_NAMES][20],
	BadPartNicksCount,BadPartID,
	BadNickParts[MAX_BADNICKS_PARTS][20],
	BadWordsCount,WordSt,WordEn,
	ForbiddenWords[MAX_BAD_WORDS][20],
	ChatMessages[MAX_CHAT_MSGS_STORE][128],
	Reports[MAX_REPORTS_STORE][128],
	reconnect[MAX_PLAYERS],
	Ftimer[MAX_PLAYERS],      //Unfreeze timmer
	Jtimer[MAX_PLAYERS],      //Unjail timmer
	JPlayer[MAX_PLAYERS],     //Jail timmer
	Mtimer[MAX_PLAYERS],      //Unmute timmer
	pHideTimer[MAX_PLAYERS];  //This timmer start when an admin use /hideme (raderhide) or /hidename to keep him hide

new Float:TeleCoords[MAX_TELEPORTS][3],
    Teleinfo[MAX_TELEPORTS][2],
    TeleName[MAX_TELEPORTS][30],TeleCount;
    
new cd_seconds, cd_freeze, cd_started = 0, cd_timer, cdstr[10];

new pInfo[MAX_PLAYERS][PlayerInfo],
    Jstring[128],JLstring[500],
	LevelName[30],LevelColor[20],
	Specid[MAX_PLAYERS],playerIP[16],
	aka[256],Cmdstr[128],CTMSG[128],
	AdmName[24],VLstring[850];
	
/*---------------Account Editor -----------------*/
new RegisteredDate[50],RegisteredIP[16],
    LastLoggedIP[16],AdminLevel,
	DonatorLevel,AccBanned,AccMuted,
	AccScore,AccCash,AccKills,AccDeaths,
	AccSkin,AccAutologin,AccTotalSecs,LastSeen[50],AccPlayedTime[50];


new VehicleNames[212][] =
{
   "Landstalker", "Bravura", "Buffalo", "Linerunner", "Pereniel", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus","Voodoo", "Pony",
   "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", "Mr Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer",
   "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero",
   "Packer", "Monster", "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer 2", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy",
   "Solair", "Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic", "Sanchez", "Sparrow", "Patriot", "Quad",
   "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR3 50", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick",
   "News Chopper", "Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick", "Boxville", "Benson", "Mesa",
   "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher", "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropdust",
   "Stunt", "Tanker", "RoadTrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune",
   "Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight", "Streak", "Vortex", "Vincent", "Bullet",
   "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster A",
   "Monster B", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito", "Freight", "Trailer", "Kart", "Mower",
   "Duneride", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "Newsvan", "Tug", "Trailer A", "Emperor", "Wayfarer", "Euros",
   "Hotdog", "Club", "Trailer B", "Trailer C", "Andromada", "Dodo", "RC Cam", "Launch", "Police Car (LSPD)", "Police Car (SFPD)", "Police Car (LVPD)", "Police Ranger",
   "Picador", "S.W.A.T. Van", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage Trailer A", "Luggage Trailer B", "Stair Trailer", "Boxville", "Farm Plow", "Utility Trailer"
};


/*---------TextDraws-------*/
#if LoginTextDraw == true
new Text:TEXT_PASSWORD,Text:TEXT_REGISTER,Text:TEXT_REGISTERED;
#endif
#if SpecTextDraw == true
new Text:SpecGTD,PlayerText:SpecPTD,JLspec[200];
#endif
#if PauseDetectSystem == true
new IsPaused[MAX_PLAYERS], pTick[MAX_PLAYERS], IsWorldChanged[MAX_PLAYERS];
#endif
new Text3D:vLocked3DT[MAX_PLAYERS];

public OnFilterScriptInit()
{
    #if LoginTextDraw == true
    CreateLoginTextDraw();
    #endif
    
    #if SpecTextDraw == true
    SpecGTD = TextDrawCreate(477.000000, 262.000000, "~R~<Prv~W~~G~(LMB)   (RMB)~R~Next>");
	TextDrawBackgroundColor(SpecGTD, 255);
	TextDrawFont(SpecGTD, 1);
	TextDrawLetterSize(SpecGTD, 0.349999, 1.600000);
	TextDrawColor(SpecGTD, -1);
	TextDrawSetOutline(SpecGTD, 0);
	TextDrawSetProportional(SpecGTD, 1);
	TextDrawSetShadow(SpecGTD, 1);
    #endif
    
	LoadSettings();
	
	print("\n ____________________________________________________\n");
	print("|**         J.L. SA:MP Server Administration       **|\n");
	print("                    System V 1.0                     \n");
	PrintConfiguration();
	
	LoadIllegalWeaps();
	LoadForbiddenNicks();
	LoadBadNickParts();
	LoadBadWords();
	LoadTeleports();
	
	LTimer = SetTimer("PlayerCheker",1000,true);
	
	foreach(Player, i)
	OnPlayerConnect(i);
	return 1;
}

public OnFilterScriptExit()
{
    #if LoginTextDraw == true
    TextDrawHideForAll(TEXT_PASSWORD);
	TextDrawDestroy(TEXT_PASSWORD);
	TextDrawHideForAll(TEXT_REGISTER);
	TextDrawDestroy(TEXT_REGISTER);
	TextDrawHideForAll(TEXT_REGISTERED);
	TextDrawDestroy(TEXT_REGISTERED);
    #endif

    #if SpecTextDraw == true
    TextDrawHideForAll(SpecGTD);
	TextDrawDestroy(SpecGTD);
	foreach(Player, i)
	{
		PlayerTextDrawHide(i, SpecPTD);
		PlayerTextDrawDestroy(i, SpecPTD);
	}
    #endif
/*------------------------------------------*/
    KillTimer(LTimer);
/*------------------------------------------*/
    foreach(Player, i)
    {
	   OnPlayerDisconnect(i,1);
	   if (IsWorldChanged[i] == 1)
	   SetPlayerVirtualWorld(i, 0);
	}
	
	return 1;
}


public OnPlayerConnect(playerid)
{
    if(IsPlayerNPC(playerid)) return 1;
    #if SpecTextDraw == true
    CreateSpecTD(playerid);
    #endif
    new Jfile[100],pIP[16],Jstr[128];
    strdel(aka,0,256);
    GetPlayerIp(playerid,pIP,16);
    GetPlayerIp(playerid,playerIP,16);
    format(Jfile,sizeof(Jfile),"JLadmin/Logs/aka.ini");
    INI_ParseFile(Jfile,"GetAkaLog");
    ResetVariables(playerid);
    if(strlen(aka) < 3)
    {
	    format(Jfile,sizeof(Jfile),"JLadmin/Logs/aka.ini");
	    new INI:AKA = INI_Open(Jfile);
		INI_WriteString(AKA, pIP, GetName(playerid));
		INI_Close(AKA);
    }
    else if(strfind(aka, GetName(playerid), true) == -1)
	{
        format(Jfile,sizeof(Jfile),"JLadmin/Logs/aka.ini");
		format(Jstr,sizeof(Jstr),"%s,%s", aka, GetName(playerid));
		new INI:AKA = INI_Open(Jfile);
		INI_WriteString(AKA, pIP, Jstr);
		INI_Close(AKA);
	}
    if(strlen(aka) > 70)
	{
        strmid(Jstring,aka,0,70);
        format(Jstr, sizeof(Jstr),"Sign in >> Player: %s - IP: %s - AKA: %s", GetName(playerid),playerIP , Jstring);
        SendToAdmins(Cmdcolor,Jstr);
		strmid(Jstring,aka,70,sizeof(aka));
		format(Jstr, sizeof(Jstr),"%s", Jstring);
		SendToAdmins(Cmdcolor,Jstr);
	}
	else
	{
        if(strlen(aka) > 2) format(Jstr, sizeof(Jstr),"Sign in >> Player: %s - IP: %s - AKA: %s", GetName(playerid),playerIP , aka);
		else format(Jstr, sizeof(Jstr),"Sign in >> Player: %s - IP: %s - AKA: No aka found!", GetName(playerid),playerIP);
        SendToAdmins(Cmdcolor,Jstr);
    }
    format(Jfile, 100, ACCOUNTS_PATH, GetName(playerid));
    if(!fexist(Jfile))
    {
        format(Jstring, sizeof(Jstring),"Nick name \"%s\" isn't registered. Please register your nick name to save your status\nEnter the password:", GetName(playerid));
        if(MustRegister == 1) ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,"Register an account!", Jstring, "Register", "Kick");
        SendClientMessage(playerid,red,"Nick name isn't registered!");
		SendClientMessage(playerid,lighterblue,"Please register to create an account (/register)");
    }
    else
	{
        pInfo[playerid][Registered] = 1;
		format(Jfile, 100, ACCOUNTS_PATH, GetName(playerid));
		INI_ParseFile(Jfile, "GetPlayerInfo", .bExtra = true, .extra = playerid);
        if(AutoLogin == 1 && (!strcmp(pIP, pInfo[playerid][IP],true) && pInfo[playerid][pAutoLogin] == 1))
        {
            format(Jfile, 100, ACCOUNTS_PATH, GetName(playerid));
            INI_ParseFile(Jfile, "LoginPlayer", .bExtra = true, .extra = playerid);
            SetPlayerScore(playerid, pInfo[playerid][Score]);
			GivePlayerMoney(playerid, pInfo[playerid][Cash]);
			pInfo[playerid][Logged] = 1;
			if(pInfo[playerid][pLevel] >= 1)
			{
                switch(pInfo[playerid][pLevel])
			    {
		              case 1: LevelName = ADMIN_LEVEL_1;
					  case 2: LevelName = ADMIN_LEVEL_2;
					  case 3: LevelName = ADMIN_LEVEL_4;
					  case 4: LevelName = ADMIN_LEVEL_3;
					  case 5: LevelName = ADMIN_LEVEL_5;
					  default: LevelName = ADMIN_LEVEL_6;
                }
                format(Jstring, sizeof(Jstring),"Welcome back, You have been automatically logged in! | Level: %d (%s)", pInfo[playerid][pLevel], LevelName);
                SendClientMessage(playerid,lighterblue,Jstring);
			}
			else
			SendClientMessage(playerid,lighterblue,"Welcome back, You have been automatically logged in!");
        }
		else
		{
			#if LoginTextDraw == false
	        format(Jstring, sizeof(Jstring),"Nick name \"%s\" registered.\nPlease enter your password to login", GetName(playerid));
	        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,"Account Login", Jstring, "Login", "Quit");
	        #endif
	        SendClientMessage(playerid,lighterblue,"Nick name is registered!");
			SendClientMessage(playerid,red,"Please '/login' access your account");
        }
    }
    if(ForbiddenNamesKick == 1 && IsForbiddenNick(playerid) == 1)
    {
        format(Jstring, sizeof(Jstring),"{FB0404}Your nick name \"%s\" is in blacklist. please relog\nwith a new nick name", GetName(playerid));
        ShowPlayerDialog(playerid, JDIALOGS+45, DIALOG_STYLE_MSGBOX,"     {FB0404}Forbidden nick", Jstring, "Ok", "");
        SetTimerEx("KickPlayer",200,false,"d", playerid);
        format(Jstring, sizeof(Jstring),"\"%s\" has been automatically kicked | reason: 'Forbidden Name'", GetName(playerid));
        SendToAdmins(orange,Jstring);
        WriteToLog(Jstring,"KickLog");
    }
    if(KickPartNicks == 1 && IsBadNickPart(playerid) == 1)
    {
        format(Jstring, sizeof(Jstring),"{FB0404}Your nick name part \"%s\" is in Forbidden part nick names list.\nplease relog with a new nick name", BadNickParts[BadPartID]);
        ShowPlayerDialog(playerid, JDIALOGS+45, DIALOG_STYLE_MSGBOX,"     {FB0404}Forbidden part nick", Jstring, "Ok", "");
        SetTimerEx("KickPlayer",200,false,"d", playerid);
        format(Jstring, sizeof(Jstring),"\"%s\" has been automatically kicked | reason: 'Forbidden part nick (%s)'", GetName(playerid),BadNickParts[BadPartID]);
        SendToAdmins(orange,Jstring);
        WriteToLog(Jstring,"KickLog");
    }
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
    #if LoginTextDraw == true
    TextDrawHideForPlayer(playerid, TEXT_PASSWORD);
	TextDrawHideForPlayer(playerid, TEXT_REGISTER);
	TextDrawHideForPlayer(playerid, TEXT_REGISTERED);
    #endif
    #if SpecTextDraw == true
	PlayerTextDrawHide(playerid, SpecPTD);
	PlayerTextDrawDestroy(playerid, SpecPTD);
    #endif
    if(GetPVarInt(playerid,"MapHidden") == 1 || pInfo[playerid][NameTagHidden] == 1)
		KillTimer(pHideTimer[playerid]);
		
	if(pInfo[playerid][Jailed] == 1)
		KillTimer(Jtimer[playerid]);
		
	if(pInfo[playerid][Frozen] == 1)
		KillTimer(Ftimer[playerid]);
		
	if(pInfo[playerid][Muted] == 1)
		KillTimer(Mtimer[playerid]);
	
    if(pInfo[playerid][SpawnedCars] > 0)
	{
       for(new i=0; i<pInfo[playerid][SpawnedCars]; i++)
	   {
           DestroyVehicle(pInfo[playerid][Cars][i]);
       }
 	   pInfo[playerid][SpawnedCars] = 0;
	}
	
	if(pInfo[playerid][Locked] == 1)
	{
	   foreach(Player, i)
	   SetVehicleParamsForPlayer(GetPVarInt(playerid,"CarID"),i,false,false);
	   pInfo[playerid][Locked]   =    0;
	   Delete3DTextLabel(vLocked3DT[playerid]);
	}
	if(pInfo[playerid][Registered] == 1 && pInfo[playerid][Logged] == 1)
    	SaveStatus(playerid);
    	
    if(reason == 0) format(Jstring, sizeof(Jstring), ">> %s(%d) has signed out [Reason: Crashed/Timeout]", GetName(playerid), playerid);
    
    else if(reason == 2) format(Jstring, sizeof(Jstring), ">> %s(%d) has signed out [Reason: Kicked]", GetName(playerid), playerid);
    
	else format(Jstring, sizeof(Jstring), ">> %s(%d) has signed out", GetName(playerid), playerid);
	
	SendToAdmins(white,Jstring);
	
	if(reconnect[playerid] == 1)
    {
        new
			ip[16],
			string[50]
		;

        GetPVarString(playerid, "MYIP", ip, 16);
        format(string,sizeof(string),"unbanip %s", ip);
        SendRconCommand(string);
        reconnect[playerid] = 0;
    }
    
    foreach(Player, i)
	{
		if (Specid[i] == playerid && pInfo[i][Spec] == 1)
		{
			SpecNext(playerid);
			GameTextForPlayerEx(playerid,"~G~Player ~R~Disconnected",2000,3);
		}
	}
	
	return 1;
}
public OnPlayerRequestClass(playerid,classid)
{
    #if LoginTextDraw == true
    if(pInfo[playerid][Registered] == 1 && pInfo[playerid][Logged] == 0)
    {
		TextDrawShowForPlayer(playerid, TEXT_PASSWORD);
		TextDrawShowForPlayer(playerid, TEXT_REGISTER);
		TextDrawShowForPlayer(playerid, TEXT_REGISTERED);
		SelectTextDraw(playerid, 0x00FF00C8);
    }
    #endif
    if(pInfo[playerid][Banned] == 1 && pInfo[playerid][Logged] == 1 && AntiBanEvade == 1)
    {
		ShowPlayerDialog(playerid,JDIALOGS+200,DIALOG_STYLE_MSGBOX,"           {FF0000}You are evading your ban","{FF0000}You have been banned by the server for: \"Ban evading\"\n\nVisit "WEBSITE" for more informations","OK","");
        SetTimerEx("BanPlayer",200,false,"ud", playerid,1);
        format(Jstring, sizeof(Jstring),"\"%s\" has been automatically banned | reason: 'Ban evading'", GetName(playerid));
        SendToAdmins(orange,Jstring);
        format(Jstring,sizeof(Jstring),"[SYSTEM BAN] %s has been banned | Reason: Ban evading",GetName(playerid));
		WriteToLog(Jstring,"Bans");
    }
    else if(pInfo[playerid][Banned] == 1 && AntiBanEvade == 0)
    {
		ShowPlayerDialog(playerid,JDIALOGS+200,DIALOG_STYLE_MSGBOX,"{FF0000}WARRING: This Name is Banned from the server","{FF0000}You have been kicked from the server | REASON : \"Name banned\"","OK","");
        SetTimerEx("KickPlayer",200,false,"u", playerid);
        format(Jstring, sizeof(Jstring),"\"%s\" has been automatically kicked | reason: 'Name Banned'", GetName(playerid));
        SendToAdmins(orange,Jstring);
        format(Jstring,sizeof(Jstring),"[SYSTEM KICK] %s has been kicked | Reason: Name banned",GetName(playerid));
		WriteToLog(Jstring,"KickLog");
    }
    if(pInfo[playerid][TempBan] >= gettime())
    {
		new minu, hour ,day, sec = pInfo[playerid][TempBan] - gettime();
        format(Jstring, sizeof(Jstring), "You are temporarily banned more %s",ConvertTime(sec,minu,hour,day));
        ShowPlayerDialog(playerid, JDIALOGS+45, DIALOG_STYLE_MSGBOX,"     {FB0404}You are temp baned", Jstring, "Ok", "");
        SetTimerEx("KickPlayer",100,false,"d", playerid);
        format(Jstring, sizeof(Jstring),"\"%s\" has been automatically kick | reason: 'Player is Temporarily banned'", GetName(playerid));
        SendToAdmins(orange,Jstring);
    }
    else if(pInfo[playerid][TempBan] > 0)
    {
		new Jfile[100],year,month,day;
		getdate(year,month,day);
		SendClientMessage(playerid,green,"Your tempbanned period has been expired! welcome back");
        format(Jstring,sizeof(Jstring),"[EXPIRED on %d/%d/%d]",year,month,day);
        format(Jfile, 100, ACCOUNTS_PATH, GetName(playerid));
		new INI:ACCOUNT = INI_Open(Jfile);
		INI_WriteString(ACCOUNT, "TempBan", Jstring);
		INI_Close(ACCOUNT);
		pInfo[playerid][TempBan] = 0;
    }
    pInfo[playerid][Spawned]    = 0;
    return 1;
}
public OnPlayerSpawn(playerid)
{
    pInfo[playerid][Spawned]    = 1;
    if(pInfo[playerid][Registered] == 1 && pInfo[playerid][Logged] == 0)
    {
       ShowPlayerDialog(playerid, JDIALOGS+45, DIALOG_STYLE_MSGBOX,"     {FB0404}Kicked", "You have been kicked | Reason: \"You must be logged before spawn\"", "Ok", "");
       SetTimerEx("KickPlayer",100,false,"d", playerid);
       return 0;
    }
    if(GetPVarInt(playerid,"Useskin") == 1)
    {
        SetPlayerSkin(playerid, pInfo[playerid][Skin]);
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    pInfo[playerid][Spawned]    = 0;
    pInfo[playerid][Deaths]++;
	if(IsPlayerConnected(killerid) && killerid != INVALID_PLAYER_ID)
	{
		pInfo[killerid][Kills]++;
	}
	return 1;
}

public OnPlayerText(playerid, text[])
{
    CallLocalFunction("StoreChatLine", "ds", playerid, text);
    if(text[0] == ADMCHATKEY && pInfo[playerid][pLevel] >= 1)
	{
		format(Jstring,sizeof(Jstring),"|Admin Chat| %s: %s",GetName(playerid),text[1]);
		foreach(Player, i) if(pInfo[i][pLevel] >= 1) SendClientMessage(i,Admchat,Jstring);
		WriteToLog(Jstring,"AdminChat");
	    return 0;
	}
    if(pInfo[playerid][Muted] == 1)
	{
		SendClientMessage(playerid,red,"You are muted, you are not allowed to talk!");
		return 0;
	}
	if(text[0] == DONATORCHATKEY && pInfo[playerid][pLevel] >= 1)
	{
		format(Jstring,sizeof(Jstring),"|V.I.P Chat| %s: %s",GetName(playerid),text[1]);
		foreach(Player, i) if(pInfo[i][pLevel] >= 1) SendClientMessage(i,Admchat,Jstring);
		WriteToLog(Jstring,"VIPChatLog");
	    return 0;
	}
	if(IsDisabledChat == 1)
	{
		format(Jstring,sizeof(Jstring),"***Chat is disabled by Admin %s",AdmName);
		SendClientMessage(playerid,red,Jstring);
	    return 0;
	}
	if(AntiSpam == 1 && pInfo[playerid][Muted] == 0)
	{
           GetPVarString(playerid, "ChatMsg",CTMSG,128);
           if(!strcmp(CTMSG, text,  false))
           {
              pInfo[playerid][SpamWarns]++;
              if(pInfo[playerid][SpamWarns] < MAX_SPAM_WARNS)SendClientMessage(playerid,red,"WARNING: Do not repeat or you will be muted!");
              if(pInfo[playerid][SpamWarns] >= MAX_SPAM_WARNS)
              {
		          format(Jstring,sizeof(Jstring),"%s(%d) has been automatically muted for %d seconds | REASON: \"Spam\"",GetName(playerid),playerid,AUTO_MUTE_TIME);
				  SendClientMessageToAll(red, Jstring);
				  pInfo[playerid][Muted] = 1;
				  SetTimerEx("UnmutePlayer",AUTO_MUTE_TIME*1000,false,"d",playerid);
				  return 0;
			  }
		   }
		   else pInfo[playerid][SpamWarns] = 0;
		   SetPVarString(playerid,"ChatMsg",text);
	}
	if(AntiForbiddenWords == 1 && IsBadWord(text))
	for(new i = WordSt, l = WordSt + WordEn; i < l; i++) text[i] = '•';
	if(AntiAdv == 1)
	{
	    if(IsAdvertisement(text))
	    {
           if(AdminImmunity == 1 && pInfo[playerid][pLevel] >= 2) return 1;
           ShowPlayerDialog(playerid,JDIALOGS+200,DIALOG_STYLE_MSGBOX,"{FF0000}Advertising is NOT allowed on this server","{FF0000}You have been kicked from the server | REASON : \"Advertising\"","OK","");
		   SetTimerEx("KickPlayer",100,false,"d",playerid);
		   format(Jstring,sizeof(Jstring),"%s(%d) has been kicked | REASON: \"Advertising\"",GetName(playerid),playerid);
		   SendClientMessageToAll(red, Jstring);
		   format(Jstring,sizeof(Jstring),"%s(%d) has been automatically kicked for 'Advertising' (%s)",GetName(playerid),playerid,text);
		   SendToAdmins(orange,Jstring);
		   format(Jstring,sizeof(Jstring),"[SYSTEM KICK] %s has been kicked for 'Advertising' (%s)",GetName(playerid),text);
		   WriteToLog(Jstring,"KickLog");
		   return 0;
		}
	}
	return 1;
}

public OnPlayerCommandReceived(playerid, cmdtext[])
{
	if(pInfo[playerid][Jailed] == 1 && pInfo[playerid][pLevel] == 0)
    {
	  SendClientMessage(playerid,red,"You can not use commands in Jail");
	  return 0;
	}
	if(ReadCommands == 1)
	{
      format(Cmdstr, sizeof(Cmdstr), ">>> %s(%d) Used command: %s", GetName(playerid),playerid,cmdtext);
      foreach(Player, i)
	  {
		if(pInfo[i][pLevel] >= 1 && pInfo[i][pLevel] > pInfo[playerid][pLevel] && i != playerid)
		{
		   SendClientMessage(i, Cmdcolor, Cmdstr);
		}
	  }
	}
	return 1;
}
    
public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER)
    {
        if(pInfo[playerid][VGod] == 1)
        {
           RepairVehicle(GetPlayerVehicleID(playerid));
		   SetVehicleHealth(GetPlayerVehicleID(playerid),20000);
		   SendClientMessage(playerid,yellow,"You are no vehicle damage mode on, if you want to turn off it type /godcar again!");
        }
        foreach(Player, i)
		{
            if(pInfo[i][Spec] == 1 && GetPlayerState(i) == PLAYER_STATE_SPECTATING && Specid[i] == playerid)
            {
                SetPlayerInterior(i,GetPlayerInterior(playerid));
				SetPlayerVirtualWorld(i, GetPlayerVirtualWorld(playerid));
				#if SpecTextDraw == true
				UpdteSpecTD(i,playerid);
				#endif
  		        PlayerSpectateVehicle(i, GetPlayerVehicleID(playerid));
		    }
	    }
    }
    if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT)
    {
        foreach(Player, i)
		{
			if (Specid[i] == playerid && pInfo[i][Spec] == 1 && GetPlayerState(i) == PLAYER_STATE_SPECTATING)
			{
				SetPlayerInterior(i,GetPlayerInterior(playerid));
				SetPlayerVirtualWorld(i, GetPlayerVirtualWorld(playerid));
				#if SpecTextDraw == true
				UpdteSpecTD(i,playerid);
				#endif
				TogglePlayerSpectating(i, 1);
				PlayerSpectatePlayer(i, playerid);
			}
		}
    }
    if(pInfo[playerid][VGod] == 1 && oldstate == PLAYER_STATE_DRIVER)
	{
		SetVehicleHealth(GetPVarInt(playerid,"CarID"),1000);
	}
	if(pInfo[playerid][Locked] == 1 && oldstate == PLAYER_STATE_DRIVER)
	{
	   foreach(Player, i)
	   SetVehicleParamsForPlayer(GetPVarInt(playerid,"CarID"),i,false,false);
	   pInfo[playerid][Locked]   =    0;
	   Delete3DTextLabel(vLocked3DT[playerid]);
	}
	return 1;
}

public OnRconCommand(cmd[])
{
    if(strcmp(cmd,"cmds",true) == 0)
	{
        print("_____J.L Admin system RCON commands_____");
    	print("- /admins, /achat, /announce, /asay, /pm\n");
    	print("- /warn, /warp, /unban, /banname, /aka\n");
    	print("- /delaka, /chat, /reconnect\n");
	    return 1;
	}
    if(strcmp(cmd,"admins",true) == 0)
	{
		new count;
        print("_____Online Admins_____");
        foreach(Player, i)
		{
		    if (pInfo[i][pLevel] >= 1)
			{
			    count++;
			    if (IsPlayerAdmin(i))
		     	printf("%s (%d) Level: %d (RCON ADMIN)" ,GetName(i),i,pInfo[i][pLevel]);
		     	else printf("%s (%d) Level: %d" ,GetName(i),i,pInfo[i][pLevel]);
	     	}
    	}
    	if(count==0) print("No admins are online ");
    	else printf("%d admins online",count);
	    return 1;
	}
    if(!strcmp(cmd, "achat", .length = 5))
	{
		if(sscanf(cmd[5], "s[128]",Jstring)) return
		print("- CONSOLE: achat <Text> (Admin chat)");
		format(Jstring,sizeof(Jstring),"|Admin Chat| Message from console: %s",Jstring);
		foreach(Player, i) if(pInfo[i][pLevel] >= 1) SendClientMessage(i,Admchat,Jstring);
    	print(Jstring);
	    return 1;
	}
	if(!strcmp(cmd, "announce", .length = 8))
	{
		if(sscanf(cmd[8], "s[128]",Jstring)) return
		print("- CONSOLE: ann <Text> (Announce)");
     	GametextForAllEx(Jstring,3000,3);
     	printf("- ANNOUNCE: %s", Jstring);
	    return 1;
	}
	if(!strcmp(cmd, "pm", .length = 2))
	{
		new id;
		if(sscanf(cmd[2], "us[128]",id,Jstring)) return
		print("CONSOLE: pm <ID> <Message> will send a message to online RCON admins");
		if(IsPlayerConnected(id))
		{
			format(Jstring, sizeof(Jstring), "Private message (From console): %s", Jstring);
		    SendClientMessage(id, lighterblue, Jstring);
	    	printf("- Message sent to %s(%d)\n-%s",GetName(id) , id ,Jstring);
	    	return 1;
		}
		else return print("CONSOLE: Player is not connected");
	}
	if(!strcmp(cmd, "asay", .length = 4))
	{
	    if(sscanf(cmd[4], "s[128]",Jstring)) return
		print("CONSOLE: asay <Message>");
     	format(Jstring,sizeof(Jstring),"{FF0000}Message from console:{FFFF00} %s",Jstring);
	    SendClientMessageToAll(-1, Jstring);
        printf("- Message Sent: %s", Jstring);
	    return true;
	}
	if(!strcmp(cmd, "getid", .length = 5))
	{
	     new Nick[24],count=0;
		 if(sscanf(cmd[5], "s[24]",Nick)) return print("CONSOLE: getid <Part of nick>");
		 printf("____Seach result for \"%s\"____",Nick);
		 foreach(Player, i)
		 {
              if(strfind(GetName(i),Nick,true) != -1 )
			  {
                   count++;
				   format(Jstring,sizeof(Jstring),"%d - %s(ID: %d)",count,GetName(i),i);
				   print(Jstring);
		      }
	     }
	   	 if(count==0)
		 print("No resuilt found!");
		 return 1;
	}
	if(!strcmp(cmd, "warn", .length = 4))
    {
        new id,reason[50];
        if(sscanf(cmd[4], "us[50]", id,reason)) return print("CONSOLE: warn <PlayerID> <Reason> ");
        if(IsPlayerConnected(id))
		{
		    pInfo[id][Warns]++;
		    if(pInfo[id][Warns] >= 3)
			{
                 format(Jstring,sizeof(Jstring),"'%s' has been kicked by console for %s |Warnings: %d/%d|",GetName(id),reason,pInfo[id][Warns],MAX_WARNS);
				 SendClientMessageToAll(red,Jstring);
				 print(Jstring);
			     Kick(id);
			     return 1;
			}
			format(Jstring,sizeof(Jstring),"'%s' has been warned by console | Reason: %s |Warnings: %d/%d|",GetName(id),reason,pInfo[id][Warns],MAX_WARNS);
			SendClientMessageToAll(red,Jstring);
			print(Jstring);
			return 1;
		}
		else return print("CONSOLE: Player is not connected");
	}
	if(!strcmp(cmd, "warp", .length = 4))
	{
			new id,id2;
		    if(sscanf(cmd[4], "uu",id,id2)) return print("CONSOLE: /Warp <Player ID/Nick> <Player ID 2/Nick>");
		 	if(IsPlayerConnected(id) && IsPlayerConnected(id2))
		    {
				new Float:Pos[3];
				GetPlayerPos(id2,Pos[0],Pos[1],Pos[2]);
				SetPlayerInterior(id,GetPlayerInterior(id2));
				SetPlayerVirtualWorld(id,GetPlayerVirtualWorld(id2));
				if(GetPlayerState(id) == PLAYER_STATE_DRIVER)
				{
	   			new Veh = GetPlayerVehicleID(id);
				SetVehiclePos(Veh,Pos[0]+3,Pos[1],Pos[2]);
				LinkVehicleToInterior(Veh,GetPlayerInterior(id2));
				SetVehicleVirtualWorld(Veh,GetPlayerVirtualWorld(id2));
				}
				else SetPlayerPos(id,Pos[0]+3,Pos[1],Pos[2]);
				format(Jstring,sizeof(Jstring),"[Teleported by console] You have been teleported you to %s!",GetName(id2));
				SendClientMessage(id,yellow,Jstring);
				format(Jstring,sizeof(Jstring),"CONSOLE: You have Teleported '%s' to %s's Position", GetName(id), GetName(id2));
				return print(Jstring);
			}
			else return print("CONSOLE: Player is not connected");
    }
    if(!strcmp(cmd, "aka", .length = 3))
    {
        new id,Jfile[100],string[128];
	    if(sscanf(cmd[3], "u", id)) return print("CONSOLE: /aka <Player ID/Part of Nick>");
	 	if(IsPlayerConnected(id))
	    {
            strdel(aka,0,256);
  		  	GetPlayerIp(id,playerIP,16);
  		  	format(Jfile,sizeof(Jfile),"JLadmin/Logs/aka.ini");
  		  	INI_ParseFile(Jfile,"GetAkaLog");
			format(Jstring,sizeof(Jstring),"__Player %s(ID: %d)'s Nick names__", GetName(id), id);
   	        print(Jstring);
		    if(strlen(aka) > 70)
			{
		        strmid(string,aka,0,75);
		        format(Jstring,sizeof(Jstring),"IP: %s - Nicks: %s", playerIP , string);
				print(Jstring);
				strmid(string,aka,75,sizeof(aka));
				format(Jstring, sizeof(Jstring),"%s", string);
				print(Jstring);
			}
			else
			{
			    format(string,sizeof(string),"IP: %s - Nicks: %s", playerIP, aka);
				print(string);
		    }
	        return 1;
 	    }
		else return print("CONSOLE: Player is not connected");
	}
	if(!strcmp(cmd, "delaka", .length = 6))
    {
	    new id,ip[16],Jfile[100];
	    if(sscanf(cmd[6], "u", id)) return print("CONSOLE:: /delaka <Player ID/Part of Nick>");
	 	if(IsPlayerConnected(id))
	    {
            strdel(aka,0,256);
  		  	GetPlayerIp(id,ip,16);
  		  	format(Jfile,sizeof(Jfile),"JLadmin/Logs/aka.ini");
  		  	new INI:AKA = INI_Open(Jfile);
			INI_RemoveEntry(AKA, ip);
			INI_Close(AKA);
			format(Jstring,sizeof(Jstring),"You have deleted Player %s(ID: %d)'s all nick names from the aka log", GetName(id), id);
   	        print(Jstring);
	        return 1;
		}
		else return print("CONSOLE: Player is not connected");
	}
	if(!strcmp(cmd, "chat", .length = 4))
	{
	    new count;
		for(new i = 0; i < MAX_CHAT_MSGS_STORE; i++)
		{
		   if(strlen(ChatMessages[i]) > 0)
		   {
              print(ChatMessages[i]);
		      count++;
		   }
		}
		if(count == 0) print("No messages found on main chat!");
		return 1;
	}
	if(!strcmp(cmd, "reconnect", .length = 9))
    {
	    new id,reason[30],string[50],ip[16];
		if(sscanf(cmd[9], "us[30]", id, reason)) return print("CONSOLE: /reconnect <playerid> <reason>");
        if(IsPlayerConnected(id))
        {
		   GetPlayerIp(id, ip, sizeof(ip));
		   format(string, sizeof(string), "banip %s", ip);
		   SendRconCommand(string);
		   SetPVarString(id,"MYIP",ip);
		   reconnect[id] = 1;
		   format(Jstring, sizeof(Jstring), "%s has been forced to reconnect by console - Reason: %s", GetName(id), reason);
		   SendClientMessageToAll(red, Jstring);
		   print(Jstring);
		   return 1;
	    }
	    else return print("CONSOLE: Player is not connected");
	}
	if(!strcmp(cmd, "unban", .length = 5))
	{
		new Name[25],file[100];
		if(sscanf(cmd[6], "s[25]", Name)) return print("CONSOLE: /unban <Nick Name>");
		format(file, 100, ACCOUNTS_PATH, Name);
        if (!fexist(file)) return print("Error: This player doesn't have an account!");
		new INI:ACCOUNT = INI_Open(file);
		INI_WriteInt(ACCOUNT, "Banned", 0);
		INI_WriteInt(ACCOUNT, "TempBan", 0);
		INI_Close(ACCOUNT);
        format(Jstring, sizeof(Jstring),"You have successfully unbanned '%s'",Name);
        print(Jstring);
        format(Jstring,sizeof(Jstring),"[CONSOLE UNBAN] %s has been unbanned by console",Name);
		WriteToLog(Jstring,"Unbanlog");
		return 1;
	}
	if(!strcmp(cmd, "banname", .length = 7))
	{
		new Name[25],file[100];
		if(sscanf(cmd[8], "s[25]", Name)) return print("CONSOLE: /banname <Nick Name>");
		format(file, 100, ACCOUNTS_PATH, Name);
        if (!fexist(file)) return print("Error: This player doesn't have an account!");
		new INI:ACCOUNT = INI_Open(file);
		INI_WriteInt(ACCOUNT, "Banned", 1);
		INI_Close(ACCOUNT);
        format(Jstring, sizeof(Jstring),"You have successfully banned '%s'",Name);
        print(Jstring);
        format(Jstring,sizeof(Jstring),"[CONSOLE BAN] %s has been unbanned by console",Name);
		WriteToLog(Jstring,"Bans");
		return 1;
	}
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
    if(pInfo[playerid][Registered] == 1 && pInfo[playerid][Logged] == 0)
    {
       SendClientMessage(playerid,red,"Error: You must be logged first!");
       return 0;
    }
	return 1;
}

public OnPlayerVirtualWorldChange(playerid, newwordid, oldworldid)
{
    foreach(Player, i)
	{
		if (Specid[i] == playerid && pInfo[i][Spec] == 1)
		{
			SetPlayerInterior(i,GetPlayerInterior(playerid));
			SetPlayerVirtualWorld(i, newwordid);
			#if SpecTextDraw == true
			UpdteSpecTD(i,playerid);
			#endif
			if (IsPlayerInAnyVehicle(playerid))
			{
		        TogglePlayerSpectating(i, 1);
				PlayerSpectateVehicle(i, GetPlayerVehicleID(playerid));

		    }
			else
			{
		        TogglePlayerSpectating(i, 1);
				PlayerSpectatePlayer(i, playerid);
			}
		}
	}
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
    foreach(Player, i)
	{
		if (Specid[i] == playerid && pInfo[i][Spec] == 1)
		{
			SetPlayerInterior(i,newinteriorid);
			SetPlayerVirtualWorld(i, GetPlayerVirtualWorld(playerid));
			#if SpecTextDraw == true
			UpdteSpecTD(i,playerid);
			#endif
			if (IsPlayerInAnyVehicle(playerid))
			{
		        TogglePlayerSpectating(i, 1);
				PlayerSpectateVehicle(i, GetPlayerVehicleID(playerid));

		    }
			else
			{
		        TogglePlayerSpectating(i, 1);
				PlayerSpectatePlayer(i, playerid);
			}
		}
	}
	return 1;
}
public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
    if(pInfo[playerid][VGod] == 1)
    {
	   RepairVehicle(GetPlayerVehicleID(playerid));
	   SetVehicleHealth(GetPlayerVehicleID(playerid),20000);
    }
    return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(pInfo[playerid][Spec] == 1)
	{
	   if(newkeys == KEY_FIRE) SpecNext(playerid);
	   else if(newkeys == KEY_HANDBRAKE) SpecPrv(playerid);
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
    if(success)
    {
       new pIP[16];
	   foreach(Player, i)
	   {
	       GetPlayerIp(i,pIP,16);
	       if(!strcmp(pIP,ip,true) && pInfo[i][pLevel] >= 1)
	       {
      		   SendClientMessage(i, -1, "[JLADMIN] Type /rcon cmds to see JLadmin RCON commands list");
      		   break;
	       }
	   }
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_REGISTER)
	{
       if(response)
	   {
		      new Jfile[100],pIP[16],string[40],str[60],buf[145],year,month,day,hour,mins,sec;
		      new seconds = gettime() - pInfo[playerid][ConnectedTime] + pInfo[playerid][TotalSecs];
			  if(strlen(inputtext) < 3 || strlen(inputtext) > 20)
			  {
			  if(MustRegister == 1) return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,"Registration Error", "Enter the password:\n{FF0000}*Password length must be between 3 - 20 characters", "Register", "Kick");
			  else return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,"Registration Error", "Enter the password:\n{FF0000}*Password length must be between 3 - 20 characters", "Register", "No Thanks");
			  }
		      getdate(year, month, day);
		      gettime(hour,mins,sec);
		      GetPlayerIp(playerid,pIP,16);
		      format(string, 40,"%d/%d/%d at %d:%d:%d", day,month,year,hour,mins,sec);
		      format(str, 60,"%d/%d/%d at %d:%d:%d", day,month,year,hour,mins,sec);
			  format(Jfile, 100, ACCOUNTS_PATH, GetName(playerid));
			  WP_Hash(buf, sizeof(buf),inputtext);
			  new INI:ACCOUNT = INI_Open(Jfile);
			  INI_WriteString(ACCOUNT, "RegisteredOn", string);
			  INI_WriteString(ACCOUNT, "RegisteredIP", pIP);
			  INI_WriteString(ACCOUNT, "LastLoggedIP", pIP);
			  INI_WriteString(ACCOUNT, "Password",buf);
			  INI_WriteInt(ACCOUNT, "Level", 0);
			  INI_WriteInt(ACCOUNT, "Banned", 0);
			  INI_WriteInt(ACCOUNT, "Donator", 0);
			  INI_WriteInt(ACCOUNT, "Score", START_SCORE);
			  INI_WriteInt(ACCOUNT, "Cash", START_CASH);
			  INI_WriteInt(ACCOUNT, "Kills", 0);
			  INI_WriteInt(ACCOUNT, "Deaths", 0);
			  INI_WriteInt(ACCOUNT, "Skin", 0);
			  INI_WriteInt(ACCOUNT, "Muted", 0);
			  INI_WriteInt(ACCOUNT, "Autologin", 1);
			  INI_WriteInt(ACCOUNT, "TotalSeconds", seconds);
			  INI_WriteString(ACCOUNT, "TotalSpentTime", ConvertTime(seconds,mins,hour,day));
			  INI_WriteString(ACCOUNT, "LastSeen", str);
			  INI_Close(ACCOUNT);
			  pInfo[playerid][Registered] = 1;
			  pInfo[playerid][Logged] = 1;
			  #if LoginTextDraw == true
			  TextDrawHideForPlayer(playerid, TEXT_PASSWORD);
			  TextDrawHideForPlayer(playerid, TEXT_REGISTER);
			  TextDrawHideForPlayer(playerid, TEXT_REGISTERED);
			  CancelSelectTextDraw(playerid);
			  #endif
			  format(Jstring, 125, "Your nickname has been successfully registered!  |  Account: \"%s\"  |  Password: %s", GetName(playerid), inputtext);
			  return SendClientMessage(playerid,0x008000C8,Jstring);
	   }
	   else if(MustRegister == 1)
	   {
	   		ShowPlayerDialog(playerid, JDIALOGS+45, DIALOG_STYLE_MSGBOX,"     {FB0404}You must register an account", "You must register an account if you wish to play on this server!", "Ok", "");
	  		SetTimerEx("KickPlayer",200,false,"d", playerid);
	   }
	}
	if(dialogid == DIALOG_LOGIN)
	{
       if(response)
	   {
		      new Jfile[100],pIP[16],buf[145];
			  format(Jfile, 60, ACCOUNTS_PATH, GetName(playerid));
			  INI_ParseFile(Jfile, "GetPassword", .bExtra = true, .extra = playerid);
			  WP_Hash(buf, sizeof(buf),inputtext);
			  if(strcmp(pInfo[playerid][Password], buf, false) == 0)
			  {
                   format(Jfile, 100, ACCOUNTS_PATH, GetName(playerid));
                   INI_ParseFile(Jfile, "LoginPlayer", .bExtra = true, .extra = playerid);
			       SendClientMessage(playerid,green,"You have been succesfully logged In!");
			       SetPlayerScore(playerid, pInfo[playerid][Score]);
			       GivePlayerMoney(playerid, pInfo[playerid][Cash]);
			       pInfo[playerid][Logged] = 1;
			       GetPlayerIp(playerid,pIP,16);
			       format(Jfile, 100, ACCOUNTS_PATH, GetName(playerid));
				   new INI:ACCOUNT = INI_Open(Jfile);
				   INI_WriteString(ACCOUNT, "LastLoggedIP", pIP);
				   INI_Close(ACCOUNT);
				   #if LoginTextDraw == true
				   TextDrawHideForPlayer(playerid, TEXT_PASSWORD);
				   TextDrawHideForPlayer(playerid, TEXT_REGISTER);
				   TextDrawHideForPlayer(playerid, TEXT_REGISTERED);
				   CancelSelectTextDraw(playerid);
				   #endif
              }
              else
			  {
	              pInfo[playerid][LoginAttempts]++;
				  if(pInfo[playerid][LoginAttempts] >= MAX_LOGIN_ATTEMPTS)
				  {
	                  format(Jstring, sizeof(Jstring),"%s has been automatically kicked | Reason: 'Incorrect password'", GetName(playerid));
	                  SendToAdmins(orange,Jstring);
	                  ShowPlayerDialog(playerid, JDIALOGS+45, DIALOG_STYLE_MSGBOX, "WARRING","You have been automatically kicked | Reason: 'Incorrect password'", "Ok", "");
				      SetTimerEx("KickPlayer",100,false,"d",playerid);
				      return 1;
				  }
				  format(Jstring, sizeof(Jstring),"Account \"%s\"\nEnter your password to login\n{FF0000}*Incorrect password", GetName(playerid));
				  ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Account Login error",Jstring, "Login", "Quit");
			  }
	   }
	   #if LoginTextDraw == false
	   else SetTimerEx("KickPlayer",100,false,"d",playerid);
	   #endif
	}
	if (dialogid == DIALOG_PRIVATE_MESSAGE)
	{
 		if(response)
	    {
            new id;
            id = pInfo[playerid][Clicked];
     		if (strlen(inputtext) < 1) return ShowPlayerDialog(playerid,DIALOG_PRIVATE_MESSAGE,DIALOG_STYLE_INPUT,"Private Message","Type your message:\n{FF0000}*Message can NOT be empty","Send","Cancel");
            return OnPrivateMessage(playerid, id, inputtext);
		}
		return 1;
	}
	if(dialogid == JDIALOGS+201)
	{
       if(response)
	   {
            new string[128];
            GetPVarString(playerid, "SpamMsg", string, 128);
            CommandToAdmins(playerid,"Spam");
            switch(listitem)
            {
               case 0: for(new msg; msg < 50; msg++) SendClientMessageToAll(yellow,string);
               case 1: for(new msg; msg < 50; msg++) SendClientMessageToAll(white,string);
               case 2: for(new msg; msg < 50; msg++) SendClientMessageToAll(blue,string);
               case 3: for(new msg; msg < 50; msg++) SendClientMessageToAll(red,string);
               case 4: for(new msg; msg < 50; msg++) SendClientMessageToAll(green,string);
               case 5: for(new msg; msg < 50; msg++) SendClientMessageToAll(orange,string);
               case 6: for(new msg; msg < 50; msg++) SendClientMessageToAll(purple,string);
               case 7: for(new msg; msg < 50; msg++) SendClientMessageToAll(pink,string);
               case 8: for(new msg; msg < 50; msg++) SendClientMessageToAll(brown,string);
               case 9: for(new msg; msg < 50; msg++) SendClientMessageToAll(black,string);
            }
	   }
	}
	if(dialogid == JDIALOGS+202)
	{
       if(response)
	   {
            new string[128];
            GetPVarString(playerid, "SpamMsg", string, 128);
            CommandToAdmins(playerid,"Write");
            switch(listitem)
            {
               case 0: SendClientMessageToAll(yellow,string);
               case 1: SendClientMessageToAll(white,string);
               case 2: SendClientMessageToAll(blue,string);
               case 3: SendClientMessageToAll(red,string);
               case 4: SendClientMessageToAll(green,string);
               case 5: SendClientMessageToAll(orange,string);
               case 6: SendClientMessageToAll(purple,string);
               case 7: SendClientMessageToAll(pink,string);
               case 8: SendClientMessageToAll(brown,string);
               case 9:SendClientMessageToAll(black,string);
            }
	   }
	}
	if(dialogid == JDIALOGS+203)
	{
       if(response)
	   {
          switch(listitem)
          {
	            case 0:
	            {
	               SetPlayerFightingStyle (GetPVarInt(playerid,"player"), FIGHT_STYLE_NORMAL);
	               format(Jstring,sizeof(Jstring),"You have set %s's fighting style to Nomal fighting style",GetName(GetPVarInt(playerid,"player")));
	               SendClientMessage(playerid,yellow,Jstring);
	               format(Jstring,sizeof(Jstring),"Admin '%s' has set your fighting style to Nomal fighting style",GetName(playerid));
	               if(playerid != GetPVarInt(playerid,"player"))SendClientMessage(GetPVarInt(playerid,"player"),orange,Jstring);
	            }
	            case 1:
	            {
	               SetPlayerFightingStyle (GetPVarInt(playerid,"player"), FIGHT_STYLE_BOXING);
	               format(Jstring,sizeof(Jstring),"You have set %s's fighting style to Boxing fighting style",GetName(GetPVarInt(playerid,"player")));
	               SendClientMessage(playerid,yellow,Jstring);
	               format(Jstring,sizeof(Jstring),"Admin '%s' has set your fighting style to Boxing fighting style",GetName(playerid));
	               if(playerid != GetPVarInt(playerid,"player"))SendClientMessage(GetPVarInt(playerid,"player"),orange,Jstring);
	            }
	            case 2:
	            {
	               SetPlayerFightingStyle (GetPVarInt(playerid,"player"), FIGHT_STYLE_KUNGFU);
	               format(Jstring,sizeof(Jstring),"You have set %s's fighting style to KungFu fighting style",GetName(GetPVarInt(playerid,"player")));
	               SendClientMessage(playerid,yellow,Jstring);
	               format(Jstring,sizeof(Jstring),"Admin '%s' has set your fighting style to KungFu fighting style",GetName(playerid));
	               if(playerid != GetPVarInt(playerid,"player"))SendClientMessage(GetPVarInt(playerid,"player"),orange,Jstring);
	            }
	            case 3:
	            {
	               SetPlayerFightingStyle (GetPVarInt(playerid,"player"), FIGHT_STYLE_KNEEHEAD);
	               format(Jstring,sizeof(Jstring),"You have set %s's fighting style to Kneehead fighting style",GetName(GetPVarInt(playerid,"player")));
	               SendClientMessage(playerid,yellow,Jstring);
	               format(Jstring,sizeof(Jstring),"Admin '%s' has set your fighting style to Kneehead fighting style",GetName(GetPVarInt(playerid,"player")));
	               if(playerid != GetPVarInt(playerid,"player"))SendClientMessage(GetPVarInt(playerid,"player"),orange,Jstring);
	            }
	            case 4:
				{
	               SetPlayerFightingStyle (GetPVarInt(playerid,"player"), FIGHT_STYLE_GRABKICK);
	               format(Jstring,sizeof(Jstring),"You have set '%s' fighting style to Grabkick fighting style",GetName(playerid));
	               SendClientMessage(playerid,yellow,Jstring);
	               format(Jstring,sizeof(Jstring),"Admin '%s' has set your fighting style to Grabkick fighting style",GetName(GetPVarInt(playerid,"player")));
	               if(playerid != GetPVarInt(playerid,"player"))SendClientMessage(GetPVarInt(playerid,"player"),orange,Jstring);
				}
				case 5:
				{
				   SetPlayerFightingStyle (GetPVarInt(playerid,"player"), FIGHT_STYLE_ELBOW);
				   format(Jstring,sizeof(Jstring),"You have set %s's fighting style to Elbow fighting style",GetName(GetPVarInt(playerid,"player")));
	               SendClientMessage(playerid,yellow,Jstring);
	               format(Jstring,sizeof(Jstring),"Admin %s's has set your fighting style to Elbow fighting style",GetName(playerid));
	               if(playerid != GetPVarInt(playerid,"player"))SendClientMessage(GetPVarInt(playerid,"player"),orange,Jstring);
				}
		   }
	   }
	}
	if(dialogid == JDIALOGS+205)
	{
       if(response)
	   {
           new id = GetPVarInt(playerid, "TargetID");
           switch(listitem)
           {
	            case 0:
	            {
	               SetPlayerColor(id,yellow);
	               format(Jstring,sizeof(Jstring),"You have set %s' colour to 'YELLOW'",GetName(id));
	               SendClientMessage(playerid,yellow,Jstring);
	               format(Jstring,sizeof(Jstring),"Admin '%s' has set your colour to 'YELLOW'",GetName(playerid));
	               if(playerid != id)SendClientMessage(id,orange,Jstring);
	            }
	            case 1:
	            {
	               SetPlayerColor(id,white);
	               format(Jstring,sizeof(Jstring),"You have set %s' colour to 'WHITE'",GetName(id));
	               SendClientMessage(playerid,yellow,Jstring);
	               format(Jstring,sizeof(Jstring),"Admin '%s' has set your colour to 'WHITE'",GetName(playerid));
	               if(playerid != id)SendClientMessage(id,orange,Jstring);
	            }
	            case 2:
	            {
	               SetPlayerColor(id,blue);
	               format(Jstring,sizeof(Jstring),"You have set %s' colour to 'BLUE'",GetName(id));
	               SendClientMessage(playerid,yellow,Jstring);
	               format(Jstring,sizeof(Jstring),"Admin '%s' has set your colour to 'BLUE'",GetName(playerid));
	               if(playerid != id)SendClientMessage(id,orange,Jstring);
	            }
	            case 3:
	            {
	               SetPlayerColor(id,red);
	               format(Jstring,sizeof(Jstring),"You have set %s' colour to 'RED'",GetName(id));
	               SendClientMessage(playerid,yellow,Jstring);
	               format(Jstring,sizeof(Jstring),"Admin '%s' has set your colour to 'RED'",GetName(playerid));
	               if(playerid != id)SendClientMessage(id,orange,Jstring);
	            }
	            case 4:
	            {
	               SetPlayerColor(id,green);
	               format(Jstring,sizeof(Jstring),"You have set %s' colour to 'GREEN'",GetName(id));
	               SendClientMessage(playerid,yellow,Jstring);
	               format(Jstring,sizeof(Jstring),"Admin '%s' has set your colour to 'GREEN'",GetName(playerid));
	               if(playerid != id)SendClientMessage(id,orange,Jstring);
	            }
	            case 5:
	            {
	               SetPlayerColor(id,orange);
	               format(Jstring,sizeof(Jstring),"You have set %s' colour to 'ORANGE'",GetName(id));
	               SendClientMessage(playerid,yellow,Jstring);
	               format(Jstring,sizeof(Jstring),"Admin '%s' has set your colour to 'ORANGE'",GetName(playerid));
	               if(playerid != id)SendClientMessage(id,orange,Jstring);
	            }
	            case 6:
	            {
	               SetPlayerColor(id,purple);
	               format(Jstring,sizeof(Jstring),"You have set %s' colour to 'PURPLE'",GetName(id));
	               SendClientMessage(playerid,yellow,Jstring);
	               format(Jstring,sizeof(Jstring),"Admin '%s' has set your colour to 'PURPLE'",GetName(playerid));
	               if(playerid != id)SendClientMessage(id,orange,Jstring);
	            }
	            case 7:
	            {
	               SetPlayerColor(id,pink);
	               format(Jstring,sizeof(Jstring),"You have set %s' colour to 'PINK'",GetName(id));
	               SendClientMessage(playerid,yellow,Jstring);
	               format(Jstring,sizeof(Jstring),"Admin '%s' has set your colour to 'PINK'",GetName(playerid));
	               if(playerid != id)SendClientMessage(id,orange,Jstring);
	            }
	            case 8:
	            {
	               SetPlayerColor(id,brown);
	               format(Jstring,sizeof(Jstring),"You have set %s' colour to 'BROWN'",GetName(id));
	               SendClientMessage(playerid,yellow,Jstring);
	               format(Jstring,sizeof(Jstring),"Admin '%s' has set your colour to 'BROWN'",GetName(playerid));
	               if(playerid != id)SendClientMessage(id,orange,Jstring);
	            }
	            case 9:
	            {
	               SetPlayerColor(id,black);
	               format(Jstring,sizeof(Jstring),"You have set %s' colour to 'BLACK'",GetName(id));
	               SendClientMessage(playerid,yellow,Jstring);
	               format(Jstring,sizeof(Jstring),"Admin '%s' has set your colour to 'BLACK'",GetName(playerid));
	               if(playerid != id)SendClientMessage(id,orange,Jstring);
	            }
		   }
	   }
	}
	if(dialogid == JDIALOGS+1)
	{
       if(response)
	   {
         new file[256],pIP[16];
         if(InvalidNick(inputtext)) return ShowPlayerDialog(playerid, JDIALOGS+1, DIALOG_STYLE_INPUT,"Registration error", "Please enter a another nick\n{FF0000}*Unacceptable NickName. Please only use (0-9, a-z, [], (), $, @, ., _ and =)", "Next", "No Thanks");
         format(file, 128, ACCOUNTS_PATH, inputtext);
         if(!fexist(file))
		 {
            SetPlayerName(playerid,inputtext);
            ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,"Register an account!", "Enter password:", "Register", "No Thanks");
            GetPlayerIp(playerid,pIP,16);
            format(file,sizeof(file),"JLadmin/Logs/aka.ini");
			INI_ParseFile(file,"GetAkaLog");
			if(strfind(aka, GetName(playerid), true) == -1)
			{
                    format(file,sizeof(file),"JLadmin/Logs/aka.ini");
					format(Jstring,sizeof(Jstring),"%s,%s", aka, GetName(playerid));
					new INI:AKA = INI_Open(file);
					INI_WriteString(AKA, pIP, Jstring);
					INI_Close(AKA);
		    }
		 }
		 else return ShowPlayerDialog(playerid, JDIALOGS+1, DIALOG_STYLE_INPUT,"Registration error", "Please enter a another nick\n{FF0000}*You entered nick name is already using someone else", "Next", "No Thanks");
	   }
	}
	if(dialogid == JDIALOGS+4)
	{
       if(response)
	   {
         new file[128];
         format(file, 128, ACCOUNTS_PATH, GetName(playerid));
         if(fexist(file))
		 {
            switch(listitem)
			{
	            case 0:
	            {
	                new INI:ACCOUNT = INI_Open(file);
		            INI_WriteInt(ACCOUNT, "Autologin", 1);
				    INI_Close(ACCOUNT);
				    return ShowPlayerDialog(playerid, JDIALOGS+204, DIALOG_STYLE_MSGBOX,"Auto login enabled!", "{00FFFF}You have successfully enabled your account auto login system by IP!", "Ok", "");
				}
				case 1:
	            {
	                new INI:ACCOUNT = INI_Open(file);
		            INI_WriteInt(ACCOUNT, "Autologin", 0);
				    INI_Close(ACCOUNT);
				    return ShowPlayerDialog(playerid, JDIALOGS+204, DIALOG_STYLE_MSGBOX,"Auto login disabled!", "{00FFFF}You have disabled your account auto login system!", "Ok", "");
				}
			}
		 }
		 else return ShowPlayerDialog(playerid, JDIALOGS+204, DIALOG_STYLE_MSGBOX,"Error", "{FF0000}You are not registered", "Ok", "");
	   }
	}
	if(dialogid == JDIALOGS+5)
	{
       if(response)
	   {
            switch(listitem)
			{
	            case 0:
	            {
			        new id;
			        id = pInfo[playerid][Clicked];
					if(IsPlayerConnected(id))
					{
					     format(Jstring,sizeof(Jstring),"PM To %s(ID: %d) Type your message:", GetName(id), id);
			             return ShowPlayerDialog(playerid,DIALOG_PRIVATE_MESSAGE,DIALOG_STYLE_INPUT,"Private Message",Jstring,"Send","Cancel");
					}
					else return ShowMessage(playerid, red, 2);
	            }
	            case 1:
	            {
	                new id, h, m, d;
	                id = pInfo[playerid][Clicked];
					if(IsPlayerConnected(id))
					{
	                     new seconds = gettime() - pInfo[id][ConnectedTime] + pInfo[id][TotalSecs];
			             format(Jstring, sizeof(Jstring), "_Statistics for '%s'_",GetName(id));
						 SendClientMessage(playerid, green, Jstring);
			             format(Jstring, sizeof(Jstring), "Score: %d | Money: $%d | Kills: %d | Deaths: %d | Ratio: %0.2f | Total spent Time: %s", GetPlayerScore(id), GetPlayerMoney(id), pInfo[id][Kills], pInfo[id][Deaths], Float:pInfo[id][Kills]/Float:pInfo[id][Deaths], ConvertTime(seconds,m,h,d));
						 return SendClientMessage(playerid, yellow, Jstring);
				    }
		            else return ShowMessage(playerid, red, 2);
	            }
	            case 2:
	            {
	               new id, WeapName[32], slot, weap, ammo, model , Float:Health , Float:Armour,Float:Vheath,Count = 0;
	               id = pInfo[playerid][Clicked];
	               if(IsPlayerConnected(id))
				   {
	                    GetPlayerArmour(id,Armour);
						GetPlayerHealth(id,Health);
						format(Jstring, sizeof(Jstring), "__Informations for: %s(%d)__",GetName(id) ,id);
						SendClientMessage(playerid, green, Jstring);
						if(IsPlayerInAnyVehicle(id))
						{
						GetVehicleHealth(GetPlayerVehicleID(id), Vheath);
						model = GetVehicleModel(GetPlayerVehicleID(id));
						format(Jstring, sizeof(Jstring), "Health: %0.1f | Armour: %0.1f | Ratio: %0.2f | Ping: %d | Current vehicle: %s(Model: %d) | Vehicle health: %0.1f", Health , Armour,   Float:pInfo[id][Kills]/Float:pInfo[id][Deaths],GetPlayerPing(id),VehicleNames[model-400],model,Vheath);
						}
						else
						format(Jstring, sizeof(Jstring), "Health: %0.1f | Armour: %0.1f | Kills: %d | Deaths: %d |Ratio: %0.2f | Ping: %d", Health , Armour, pInfo[id][Kills],pInfo[id][Deaths], Float:pInfo[id][Kills]/Float:pInfo[id][Deaths],GetPlayerPing(id));
						SendClientMessage(playerid, orange, Jstring);
						for(slot = 0; slot < 13; slot++)
						{
				            GetPlayerWeaponData(id, slot, weap, ammo);
							if( ammo != 0 && weap != 0)
							Count++;
						}
						if(Count == 0)
						{
							format(Jstring, sizeof(Jstring), "%s has no weapons!",GetName(id));
							return SendClientMessage(playerid,green,Jstring);
						}
						else
						{
							format(Jstring, sizeof(Jstring), "__%s's weapons__",GetName(id));
							SendClientMessage(playerid,red,Jstring);
						}
						if(Count >= 1)
						{
						   for (slot = 0; slot < 13; slot++)
						   {
						       GetPlayerWeaponData(id, slot, weap, ammo);
							   if( ammo != 0 && weap != 0)
							   {
					               GetWeaponName(weap, WeapName, sizeof(WeapName));
								   format(Jstring,sizeof(Jstring),"%s (%d)", WeapName, ammo);
								   SendClientMessage(playerid, orange, Jstring);
							   }
						   }
			            }
						return 1;
			       }
			       else return ShowMessage(playerid, red, 2);
	            }
	            case 3:
	            {
	               ShowPlayerDialog(playerid,JDIALOGS+46,DIALOG_STYLE_INPUT,"Report","Enter the reason:","Report","Close");
	            }
	            case 4:
				{
	               if(pInfo[playerid][pLevel] >= 1)
				   {
	                   new id,Float:P[3],Float:H,Float:A;
	                   id = pInfo[playerid][Clicked];
					   if(!IsPlayerConnected(id) || playerid == id) return ShowMessage(playerid, red, 3);
					   #if SpecTextDraw == true
					   TextDrawShowForPlayer(playerid, SpecGTD);
					   PlayerTextDrawShow(playerid, SpecPTD);
					   UpdteSpecTD(playerid,id);
					   #endif
					   if (pInfo[playerid][Spec] == 0)
					   {
					       GetPlayerHealth(playerid, H);
						   GetPlayerArmour(playerid,A);
						   SetPVarInt(playerid,"Int",GetPlayerInterior(playerid));
						   SetPVarInt(playerid,"vworld",GetPlayerVirtualWorld(playerid));
						   GetPlayerPos(playerid,P[0],P[1],P[2]);
						   SetPVarFloat(playerid,"JX",P[0]);
						   SetPVarFloat(playerid,"JY",P[1]);
						   SetPVarFloat(playerid,"JZ",P[2]);
						   SetPVarFloat(playerid,"Health",H);
						   SetPVarFloat(playerid,"Armour",A);
						   StoreWeaponsData(playerid);
			           }
					   pInfo[playerid][Spec] = 1;
					   Specid[playerid] = id;
					   SetPlayerInterior(playerid,GetPlayerInterior(id));
					   SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(id));
					   if (IsPlayerInAnyVehicle(id))
					   {
					      TogglePlayerSpectating(playerid, 1);
						  PlayerSpectateVehicle(playerid, GetPlayerVehicleID(id));
					   }
					   else
					   {
					      TogglePlayerSpectating(playerid, 1);
						  PlayerSpectatePlayer(playerid, id);
					   }
			           SendClientMessage(playerid,lighterblue,"You are now spectating!");
	               }
	            }
				case 5:
				{
				   new id,Float:Pos[3];
				   id = pInfo[playerid][Clicked];
		           if(IsPlayerConnected(id) && id != playerid)
		           {
				         GetPlayerPos(id,Pos[0],Pos[1],Pos[2]);
						 SetPlayerInterior(playerid,GetPlayerInterior(id));
						 SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(id));
						 if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
						 {
						    SetVehiclePos(GetPlayerVehicleID(playerid),Pos[0]+3,Pos[1],Pos[2]);
							LinkVehicleToInterior(GetPlayerVehicleID(playerid),GetPlayerInterior(id));
							SetVehicleVirtualWorld(GetPlayerVehicleID(playerid),GetPlayerVirtualWorld(id));
					     }
					     else SetPlayerPos(playerid,Pos[0]+3,Pos[1],Pos[2]);
					     format(Jstring,sizeof(Jstring),"You have been Teleported to '%s'", GetName(id));
					     SendClientMessage(playerid,yellow,Jstring);
						 return 1;
				   }
				   else return ShowMessage(playerid, red, 3);
				}
				case 6:
				{
			        new id,Ffile[128],string[128];
			        id = pInfo[playerid][Clicked];
				 	if(IsPlayerConnected(id))
				    {
			            strdel(aka,0,256);
	            		CommandToAdmins(playerid,"aka");
			  		  	GetPlayerIp(id,playerIP,16);
			  		  	format(Ffile,sizeof(Ffile),"JLadmin/Logs/aka.ini");
			  		  	INI_ParseFile(Ffile,"GetAkaLog");
						format(Jstring,sizeof(Jstring),"__Player %s(ID: %d)'s Nick names__", GetName(id), id);
			   	        SendClientMessage(playerid,green,Jstring);
					    if(strlen(aka) > 70)
						{
					        strmid(string,aka,0,75);
					        format(Jstring,sizeof(Jstring),"IP: %s - Nicks: %s", playerIP , string);
							SendClientMessage(playerid,yellow,Jstring);
							strmid(string,aka,75,sizeof(aka));
							format(Jstring, sizeof(Jstring),"%s", string);
							SendClientMessage(playerid,yellow,Jstring);
						}
						else
						{
						    format(string,sizeof(string),"IP: %s - Nicks: %s", playerIP, aka);
							SendClientMessage(playerid,yellow,string);
					    }
				        return 1;
					}
					else return ShowMessage(playerid, red, 2);
				}
				case 7:
				{
			        new id;
			        id = pInfo[playerid][Clicked];
			        if(IsPlayerConnected(id) && id != playerid)
			        {
			            if(pInfo[id][Muted] == 1) return SendClientMessage(playerid,red,"This player is already muted. see /muted");
			            if(pInfo[playerid][pLevel] <= pInfo[id][pLevel]) return ShowMessage(playerid, red, 6);
						format(Jstring,sizeof(Jstring),"Administrator %s has muted '%s'",GetName(playerid),GetName(id));
					    SendClientMessageToAll(red,Jstring);
					    pInfo[id][Muted] = 1;
						return 1;
					}
					else return ShowMessage(playerid, red, 3);
				}
				case 8:
				{
			        new id;
			        id = pInfo[playerid][Clicked];
			        if(IsPlayerConnected(id))
			        {
			            if(pInfo[id][Muted] == 0) return SendClientMessage(playerid,red,"This player is not muted muted");
			            format(Jstring,sizeof(Jstring),"You have unmuted '%s'",GetName(id));
						SendClientMessage(playerid,yellow,Jstring);
						format(Jstring,sizeof(Jstring),"Administrator %s has unmuted you!",GetName(playerid));
						SendClientMessage(id,yellow,Jstring);
					    pInfo[id][Muted] = 0;
						KillTimer(Mtimer[id]);
						CommandToAdmins(playerid,"unmute");
						return 1;
					}
					else return ShowMessage(playerid, red, 3);
				}
				case 9:
				{
			        new id,ip[16], WeapName[32], slot, weap, ammo, model , seconds, Float:x,Float:y,Float:z, Float:Health ,Float:Ratio, Float:Armour,Float:Vheath,Count,Logg[5],Reg[5],pMuted[5],pJailed[5],pFrozen[5],Jfile[100],PlayerState[40],Seat[25];
			        id = pInfo[playerid][Clicked];
				 	if(IsPlayerConnected(id))
				    {
			            GetPlayerArmour(id,Armour);
						GetPlayerHealth(id,Health);
						GetPlayerIp(id, ip, sizeof(ip));
						GetPlayerPos(id,x,y,z);
						seconds = gettime() - pInfo[playerid][ConnectedTime] + pInfo[playerid][TotalSecs];
						format(Jfile, sizeof(Jfile), ACCOUNTS_PATH, GetName(id));
			            if(fexist(Jfile))
			            INI_ParseFile(Jfile,"AccountsEditor");
			            else
						{
			            	RegisteredDate = "None"; RegisteredIP = "None"; LastSeen = "None";
			            }
						if(pInfo[playerid][Deaths] > 0)
						{
							Ratio = Float:pInfo[id][Kills]/ Float:pInfo[id][Deaths];
						}
						else
						{
							Ratio = Float:pInfo[id][Kills]/ Float:pInfo[id][Deaths]+1;
						}
						if(pInfo[id][Registered] == 1) Reg = "Yes"; else Reg = "No";
						if(pInfo[id][Logged] == 1) Logg = "Yes"; else Logg = "No";
						if(pInfo[id][Muted] == 1) pMuted = "Yes"; else pMuted = "No";
						if(pInfo[id][Jailed] == 1) pJailed = "Yes"; else pJailed = "No";
						if(pInfo[id][Frozen] == 1) pFrozen = "Yes"; else pFrozen = "No";
						if (IsPlayerConnected(id))
				        {
			 		      switch(pInfo[id][pLevel])
			              {
			                  case 0: {
							  LevelName = "Player Stauts";
							  LevelColor = "{FFFFFF}";
							  }
						      case 1: {
							  LevelName = ADMIN_LEVEL_1;
							  LevelColor = LEVEL_1_COLOR;
							  }
							  case 2: {
							  LevelName = ADMIN_LEVEL_2;
							  LevelColor = LEVEL_2_COLOR;
							  }
							  case 3: {
							  LevelName = ADMIN_LEVEL_4;
							  LevelColor = LEVEL_3_COLOR;
							  }
							  case 4: {
							  LevelName = ADMIN_LEVEL_3;
							  LevelColor = LEVEL_4_COLOR;
							  }
							  case 5: {
							  LevelName = ADMIN_LEVEL_5;
							  LevelColor = LEVEL_5_COLOR;
							  }
							  default: {
							  LevelName = ADMIN_LEVEL_6;
							  LevelColor = LEVEL_6_COLOR;
							  }
				          }
				          switch(GetPlayerState(id))
			              {
			                  case 0: {
							  PlayerState = "Empty (while initializing)";
							  }
						      case 1: {
							  PlayerState = "Player is on foot";
							  }
							  case 2: {
							  PlayerState = "Player is driver of a vehicle";
							  }
							  case 3: {
							  PlayerState = "Player is passenger of a vehicle";
							  }
							  case 4: {
							  PlayerState = "Player exits a vehicle";
							  }
							  case 5: {
							  PlayerState = "Player enters a vehicle as driver";
							  }
							  case 6: {
							  PlayerState = "Player enters a vehicle as passenger";
							  }
							  case 7: {
							  PlayerState = "Player is wasted or on class selection";
							  }
							  case 8: {
							  PlayerState = "Player is spawned";
							  }
							  case 9: {
							  PlayerState = "Player is spectating";
							  }
				          }
				          switch(GetPlayerVehicleSeat(id))
			              {
			                  case 0: {
							  Seat = "Driver";
							  }
						      case 1: {
							  Seat = "Front Passenger";
							  }
							  case 2: {
							  Seat = "Back left passenger";
							  }
							  case 3: {
							  Seat = "Back right passenger";
							  }
							  case 4: {
							  Seat = "Passenger seats";
							  }
				          }
					    }
						strdel(VLstring,0,850);
			            format(Jstring, sizeof(Jstring), "{0000FF}Nick name: %s (ID: %d) | IP: %s | Score: %d | Cash: $ %d | Kills: %d | Deaths: %d | Ratio: %0.1f\n\n",GetName(id) ,id,ip,GetPlayerScore(id),GetPlayerMoney(id),pInfo[id][Kills], pInfo[id][Deaths],Ratio);
			            strcat(VLstring, Jstring, sizeof(VLstring));
			            format(Jstring, sizeof(Jstring), "{0DF224}Health: %0.1f | Armour: %0.1f | Ping: %d | Admin level:%s %s (%d) | Donator Level(V.I.P): %d\n\n",Health ,Armour,GetPlayerPing(id),LevelColor,LevelName,pInfo[id][pLevel],pInfo[id][Donator],GetPlayerWantedLevel(id));
						strcat(VLstring, Jstring, sizeof(VLstring));
						format(Jstring, sizeof(Jstring), "{C837B9}Interior: %d | Virtual World: %d | Position: X = %0.3f, Y = %0.3f, Z = %0.3f | Skin: %d | Wanted Level: %d\n\n",GetPlayerInterior(id) ,GetPlayerVirtualWorld(id),x,y,z,GetPlayerSkin(id),GetPlayerWantedLevel(id));
						strcat(VLstring, Jstring, sizeof(VLstring));
						format(Jstring, sizeof(Jstring), "{F79709}Registered: %s | Logged: %s | Muted: %s | Jailed: %s | Frozen: %s | Last seen: %s\n\n",Reg ,Logg,pMuted,pJailed,pFrozen,LastSeen);
						strcat(VLstring, Jstring, sizeof(VLstring));
						format(Jstring, sizeof(Jstring), "{59A661}Registered Date: %s | Registered IP: %s | Time spent: %s\n\n",RegisteredDate ,RegisteredIP,ConvertTime(seconds,slot,weap,ammo));
			            strcat(VLstring, Jstring, sizeof(VLstring));
			            if(IsPlayerInAnyVehicle(id))
						{
							GetVehicleHealth(GetPlayerVehicleID(id), Vheath);
							model = GetVehicleModel(GetPlayerVehicleID(id));
							format(Jstring, sizeof(Jstring), "{FFFF80}Current vehicle: %s (Model ID: %d) | Vehicle health: %0.1f | Seat: %s\n\n", VehicleNames[model-400],model,Vheath,Seat);
							strcat(VLstring, Jstring, sizeof(VLstring));
						}
						for(slot = 0; slot < 13; slot++)
						{
						   GetPlayerWeaponData(id, slot, weap, ammo);
						   if( ammo != 0 && weap != 0)
						   Count++;
						}
				        if(Count >= 1)
					    {
			                format(Jstring, sizeof(Jstring), "{FF0000}Player weapons: ",GetName(id));
			                strcat(VLstring, Jstring, sizeof(VLstring));
							for (slot = 0; slot < 13; slot++)
							{
							     GetPlayerWeaponData(id, slot, weap, ammo);
							     if( ammo != 0 && weap != 0)
							     {
							        GetWeaponName(weap, WeapName, sizeof(WeapName));
							        format(Jstring,sizeof(Jstring),"| %s (%d) ", WeapName, ammo);
							        strcat(VLstring, Jstring, sizeof(VLstring));
				                 }
			                }
			            }
			            format(Jstring, sizeof(Jstring), "\n\nPlayer state: %s", PlayerState);
						strcat(VLstring, Jstring, sizeof(VLstring));
						ShowPlayerDialog(playerid, JDIALOGS+45, DIALOG_STYLE_MSGBOX,"     {FB0404}Player Informations", VLstring, "Ok", "");
						strdel(VLstring,0,850);
			            return 1;
					}
					else return ShowMessage(playerid, red, 2);
				}
				case 10:
				{
			        return ShowPlayerDialog(playerid,JDIALOGS+117,DIALOG_STYLE_INPUT,"Warn","Enter the reason:","Kick","Cancel");
				}
				case 11:
				{
			        return ShowPlayerDialog(playerid,JDIALOGS+47,DIALOG_STYLE_INPUT,"Kick Player","Enter the reason:","Kick","Cancel");
				}
				case 12:
				{
			        return ShowPlayerDialog(playerid,JDIALOGS+48,DIALOG_STYLE_INPUT,"Ban Player","Enter the reason:","Ban","Cancel");
				}
			}
	   }
	}
	new string[128],NickName[24],Jfile[100];
	if(dialogid == JDIALOGS+7)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 GetPVarString(playerid, "AccountName", NickName, 24);
	                 format(Jstring, 128, "%s: Rename", NickName);
	                 ShowPlayerDialog(playerid,JDIALOGS+110,DIALOG_STYLE_INPUT,"Rename Account","Enter the new nick name:","Change","Back");
	            }
	            case 1:
				{
					 GetPVarString(playerid, "AccountName", NickName, 24);
					 format(Jfile, 100, ACCOUNTS_PATH, NickName);
					 INI_ParseFile(Jfile,"AccountsEditor");
					 format(Jstring, 128, "%s: Registered Date", NickName);
					 format(string, 128, "Player Registered on %s", RegisteredDate);
		  			 ShowPlayerDialog(playerid,JDIALOGS+9,DIALOG_STYLE_MSGBOX,Jstring,string,"Back","");
				}
				case 2:
				{
					 GetPVarString(playerid, "AccountName", NickName, 24);
					 format(Jfile, 100, ACCOUNTS_PATH, NickName);
					 INI_ParseFile(Jfile,"AccountsEditor");
					 format(Jstring, 128, "%s: Registered IP", NickName);
					 format(string, 128, "Player Registered with IP: %s", RegisteredIP);
		  			 ShowPlayerDialog(playerid,JDIALOGS+10,DIALOG_STYLE_MSGBOX,Jstring,string,"Back","");
				}
				case 3:
				{
					 GetPVarString(playerid, "AccountName", NickName, 24);
					 format(Jfile, 100, ACCOUNTS_PATH, NickName);
					 INI_ParseFile(Jfile,"AccountsEditor");
					 format(Jstring, 128, "%s: Last logged IP", NickName);
					 format(string, 128, "Player last time used(logged in) IP: %s", LastLoggedIP);
		  			 ShowPlayerDialog(playerid,JDIALOGS+11,DIALOG_STYLE_MSGBOX,Jstring,string,"Back","");
				}
				case 4:
				{
	                 GetPVarString(playerid, "AccountName", NickName, 24);
	                 format(Jstring, 128, "%s: Change level", NickName);
		  			 ShowPlayerDialog(playerid,JDIALOGS+12,DIALOG_STYLE_LIST,Jstring,"Level 0\n"LEVEL_1_COLOR"Level 1\n"LEVEL_2_COLOR"Level 2\n"LEVEL_3_COLOR"Level 3\n"LEVEL_4_COLOR"Level 4\n"LEVEL_5_COLOR"Level 5\n{FF0000}>>Enter level","Select","Back");
				}
				case 5:
				{
	                 GetPVarString(playerid, "AccountName", NickName, 24);
	                 format(Jstring, 128, "%s: Donator level", NickName);
					 ShowPlayerDialog(playerid,JDIALOGS+13,DIALOG_STYLE_LIST,Jstring,"Donator(V.I.P) Level 0\nDonator(V.I.P) Level 1\nDonator(V.I.P) Level 2\nDonator(V.I.P) Level 3","Select","Back");
				}
				case 6:
				{
	                 GetPVarString(playerid, "AccountName", NickName, 24);
	                 format(Jstring, 128, "%s: Ban/Unban", NickName);
					 ShowPlayerDialog(playerid,JDIALOGS+14,DIALOG_STYLE_LIST,Jstring,"{0000FF}UNBAN\n{FF0000}BAN","Select","Back");
				}
				case 7:
				{
	                 GetPVarString(playerid, "AccountName", NickName, 24);
	                 format(Jstring, 128, "%s: Mute/Unmute level", NickName);
					 ShowPlayerDialog(playerid,JDIALOGS+15,DIALOG_STYLE_LIST,Jstring,"{0000FF}Unmute\n{FF0000}Mute","Select","Back");
				}
				case 8:
				{
	                 GetPVarString(playerid, "AccountName", NickName, 24);
	                 format(Jstring, 128, "%s: Score", NickName);
					 ShowPlayerDialog(playerid,JDIALOGS+16,DIALOG_STYLE_INPUT,Jstring,"Enter new Score:","Done","Back");
				}
				case 9:
				{
	                 GetPVarString(playerid, "AccountName", NickName, 24);
	                 format(Jstring, 128, "%s: Cash", NickName);
					 ShowPlayerDialog(playerid,JDIALOGS+17,DIALOG_STYLE_INPUT,Jstring,"Enter new Cash:","Done","Back");
				}
				case 10:
				{
	                 GetPVarString(playerid, "AccountName", NickName, 24);
	                 format(Jstring, 128, "%s: Kills", NickName);
					 ShowPlayerDialog(playerid,JDIALOGS+18,DIALOG_STYLE_INPUT,Jstring,"Enter new Kills:","Done","Back");
				}
				case 11:
				{
	                 GetPVarString(playerid, "AccountName", NickName, 24);
	                 format(Jstring, 128, "%s: Kills", NickName);
					 ShowPlayerDialog(playerid,JDIALOGS+19,DIALOG_STYLE_INPUT,Jstring,"Enter new Deaths:","Done","Back");
				}
				case 12:
				{
					 GetPVarString(playerid, "AccountName", NickName, 24);
					 format(Jfile, 100, ACCOUNTS_PATH, NickName);
					 INI_ParseFile(Jfile,"AccountsEditor");
					 format(Jstring, 128, "%s: Ratio", NickName);
					 format(string, 128, "Player Kills: %d\nPlayer deaths: %d\nPlayer Ratio: %0.2f", AccKills,AccDeaths,Float:AccKills/Float:AccDeaths);
		  			 ShowPlayerDialog(playerid,JDIALOGS+20,DIALOG_STYLE_MSGBOX,Jstring,string,"Back","");
				}
				case 13:
				{
					 GetPVarString(playerid, "AccountName", NickName, 24);
					 format(Jfile, 100, ACCOUNTS_PATH, NickName);
					 INI_ParseFile(Jfile,"AccountsEditor");
					 format(Jstring, 128, "%s: Favorite skin", NickName);
					 format(string, 128, "Player favorite Skin is %d", AccSkin);
		  			 ShowPlayerDialog(playerid,JDIALOGS+21,DIALOG_STYLE_MSGBOX,Jstring,string,"Edit","Back");
				}
				case 14:
				{
	                 GetPVarString(playerid, "AccountName", NickName, 24);
	                 format(Jstring, 128, "%s: Auto login", NickName);
					 ShowPlayerDialog(playerid,JDIALOGS+22,DIALOG_STYLE_LIST,Jstring,"{0000FF}Enable\n{FF0000}Disable","Select","Back");
				}
				case 15:
				{
					 GetPVarString(playerid, "AccountName", NickName, 24);
					 format(Jfile, 100, ACCOUNTS_PATH, NickName);
					 INI_ParseFile(Jfile,"AccountsEditor");
					 format(Jstring, 128, "%s: total played secs", NickName);
					 format(string, 128, "Player total played seconds: %d\n{FF0000}*Not recommend to edit.", AccTotalSecs);
		  			 ShowPlayerDialog(playerid,JDIALOGS+23,DIALOG_STYLE_MSGBOX,Jstring,string,"Edit","Back");
				}
				case 16:
				{
					 GetPVarString(playerid, "AccountName", NickName, 24);
					 format(Jfile, 100, ACCOUNTS_PATH, NickName);
					 INI_ParseFile(Jfile,"AccountsEditor");
					 format(Jstring, 128, "%s: Last seen", NickName);
					 format(string, 128, "Last seen on %s", LastSeen);
		  			 ShowPlayerDialog(playerid,JDIALOGS+24,DIALOG_STYLE_MSGBOX,Jstring,string,"Back","");
				}
				case 17:
				{
					 GetPVarString(playerid, "AccountName", NickName, 24);
					 format(Jfile, 100, ACCOUNTS_PATH, NickName);
					 INI_ParseFile(Jfile,"AccountsEditor");
					 format(Jstring, 128, "%s: Total Spent time", NickName);
					 format(string, 128, "Player Total ingame spent time: %s", AccPlayedTime);
		  			 ShowPlayerDialog(playerid,JDIALOGS+25,DIALOG_STYLE_MSGBOX,Jstring,string,"Back","");
				}
				case 18:
				{
					 GetPVarString(playerid, "AccountName", NickName, 24);
	                 format(Jstring, 128, "%s: PassWord", NickName);
					 ShowPlayerDialog(playerid,JDIALOGS+109,DIALOG_STYLE_INPUT,Jstring,"Enter the new password:","Change","Back");
				}
			}
   		}
	}
	if(dialogid == JDIALOGS+9)
	{
		if(response)
		{
           return AccountEditor(playerid);
		}
	}
	if(dialogid == JDIALOGS+10)
	{
		if(response)
		{
           return AccountEditor(playerid);
		}
	}
	if(dialogid == JDIALOGS+11)
	{
		if(response)
		{
           return AccountEditor(playerid);
		}
	}
	if(dialogid == JDIALOGS+12)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 GetPVarString(playerid, "AccountName", NickName, 24);
	                 format(Jfile, 100, ACCOUNTS_PATH, NickName);
					 new INI:ACCOUNT = INI_Open(Jfile);
					 INI_WriteInt(ACCOUNT, "Level", 0);
					 INI_Close(ACCOUNT);
					 return AccountEditor(playerid);
	            }
	            case 1:
				{
	                 GetPVarString(playerid, "AccountName", NickName, 24);
					 format(Jfile, 100, ACCOUNTS_PATH, NickName);
					 new INI:ACCOUNT = INI_Open(Jfile);
					 INI_WriteInt(ACCOUNT, "Level", 1);
					 INI_Close(ACCOUNT);
					 return AccountEditor(playerid);
				}
				case 2:
				{
					 GetPVarString(playerid, "AccountName", NickName, 24);
					 format(Jfile, 100, ACCOUNTS_PATH, NickName);
					 new INI:ACCOUNT = INI_Open(Jfile);
					 INI_WriteInt(ACCOUNT, "Level", 2);
					 INI_Close(ACCOUNT);
					 return AccountEditor(playerid);
				}
				case 3:
				{
					 GetPVarString(playerid, "AccountName", NickName, 24);
					 format(Jfile, 100, ACCOUNTS_PATH, NickName);
					 new INI:ACCOUNT = INI_Open(Jfile);
					 INI_WriteInt(ACCOUNT, "Level", 3);
					 INI_Close(ACCOUNT);
					 return AccountEditor(playerid);
				}
				case 4:
				{
	                 GetPVarString(playerid, "AccountName", NickName, 24);
					 format(Jfile, 100, ACCOUNTS_PATH, NickName);
					 new INI:ACCOUNT = INI_Open(Jfile);
					 INI_WriteInt(ACCOUNT, "Level", 4);
					 INI_Close(ACCOUNT);
					 return AccountEditor(playerid);
				}
				case 5:
				{
	                 GetPVarString(playerid, "AccountName", NickName, 24);
					 format(Jfile, 100, ACCOUNTS_PATH, NickName);
					 new INI:ACCOUNT = INI_Open(Jfile);
					 INI_WriteInt(ACCOUNT, "Level", 5);
					 INI_Close(ACCOUNT);
					 return AccountEditor(playerid);
				}
				case 6:
				{
	                 GetPVarString(playerid, "AccountName", NickName, 24);
	                 format(Jstring, 128, "%s: Change level", NickName);
					 ShowPlayerDialog(playerid,JDIALOGS+26,DIALOG_STYLE_INPUT,Jstring,"{FF0000}Enter new level:","Change","Back");
				}
			}
		}
		else return AccountEditor(playerid);
	}
	if(dialogid == JDIALOGS+13)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 GetPVarString(playerid, "AccountName", NickName, 24);
	                 format(Jfile, 100, ACCOUNTS_PATH, NickName);
					 new INI:ACCOUNT = INI_Open(Jfile);
					 INI_WriteInt(ACCOUNT, "Donator", 0);
					 INI_Close(ACCOUNT);
					 return AccountEditor(playerid);
	            }
	            case 1:
				{
	                 GetPVarString(playerid, "AccountName", NickName, 24);
					 format(Jfile, 100, ACCOUNTS_PATH, NickName);
					 new INI:ACCOUNT = INI_Open(Jfile);
					 INI_WriteInt(ACCOUNT, "Donator", 1);
					 INI_Close(ACCOUNT);
					 return AccountEditor(playerid);
				}
				case 2:
				{
					 GetPVarString(playerid, "AccountName", NickName, 24);
					 format(Jfile, 100, ACCOUNTS_PATH, NickName);
					 new INI:ACCOUNT = INI_Open(Jfile);
					 INI_WriteInt(ACCOUNT, "Donator", 2);
					 INI_Close(ACCOUNT);
					 return AccountEditor(playerid);
				}
				case 3:
				{
					 GetPVarString(playerid, "AccountName", NickName, 24);
					 format(Jfile, 100, ACCOUNTS_PATH, NickName);
					 new INI:ACCOUNT = INI_Open(Jfile);
					 INI_WriteInt(ACCOUNT, "Donator", 3);
					 INI_Close(ACCOUNT);
					 return AccountEditor(playerid);
				}
		    }
		}
		else return AccountEditor(playerid);
	}
	if(dialogid == JDIALOGS+14)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 GetPVarString(playerid, "AccountName", NickName, 24);
	                 format(Jfile, 100, ACCOUNTS_PATH, NickName);
					 new INI:ACCOUNT = INI_Open(Jfile);
					 INI_WriteInt(ACCOUNT, "Banned", 0);
					 INI_Close(ACCOUNT);
					 return AccountEditor(playerid);
	            }
	            case 1:
				{
	                 GetPVarString(playerid, "AccountName", NickName, 24);
					 format(Jfile, 100, ACCOUNTS_PATH, NickName);
					 new INI:ACCOUNT = INI_Open(Jfile);
					 INI_WriteInt(ACCOUNT, "Banned", 1);
					 INI_Close(ACCOUNT);
					 return AccountEditor(playerid);
				}
		    }
		}
		else return AccountEditor(playerid);
	}
	if(dialogid == JDIALOGS+15)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 GetPVarString(playerid, "AccountName", NickName, 24);
	                 format(Jfile, 100, ACCOUNTS_PATH, NickName);
					 new INI:ACCOUNT = INI_Open(Jfile);
					 INI_WriteInt(ACCOUNT, "Muted", 0);
					 INI_Close(ACCOUNT);
					 return AccountEditor(playerid);
	            }
	            case 1:
				{
	                 GetPVarString(playerid, "AccountName", NickName, 24);
					 format(Jfile, 100, ACCOUNTS_PATH, NickName);
					 new INI:ACCOUNT = INI_Open(Jfile);
					 INI_WriteInt(ACCOUNT, "Muted", 1);
					 INI_Close(ACCOUNT);
					 return AccountEditor(playerid);
				}
			}
		}
		else return AccountEditor(playerid);
	}
	if(dialogid == JDIALOGS+16)
	{
		if(response)
		{
            if(!IsNumeric(inputtext) || strlen(inputtext) == 0)
			{
                 GetPVarString(playerid, "AccountName", NickName, 24);
                 format(Jstring, 128, "%s: Score", NickName);
				 return ShowPlayerDialog(playerid,JDIALOGS+16,DIALOG_STYLE_INPUT,Jstring,"Enter new Score:\n{FF0000}*Score must be a nemeric value","Save","Back");
	        }
		    GetPVarString(playerid, "AccountName", NickName, 24);
			format(Jfile, 100, ACCOUNTS_PATH, NickName);
			new INI:ACCOUNT = INI_Open(Jfile);
			INI_WriteInt(ACCOUNT, "Score", strval(inputtext));
			INI_Close(ACCOUNT);
			return AccountEditor(playerid);
		}
		else return AccountEditor(playerid);
	}
	if(dialogid == JDIALOGS+17)
	{
		if(response)
		{
            if(!IsNumeric(inputtext) || strlen(inputtext) == 0)
			{
                 GetPVarString(playerid, "AccountName", NickName, 24);
                 format(Jstring, 128, "%s: Cash", NickName);
				 return ShowPlayerDialog(playerid,JDIALOGS+17,DIALOG_STYLE_INPUT,Jstring,"Enter new Cash:\n{FF0000}*Cash must be a nemeric value","Save","Back");
	        }
		    GetPVarString(playerid, "AccountName", NickName, 24);
			format(Jfile, 100, ACCOUNTS_PATH, NickName);
			new INI:ACCOUNT = INI_Open(Jfile);
			INI_WriteInt(ACCOUNT, "Cash", strval(inputtext));
			INI_Close(ACCOUNT);
			return AccountEditor(playerid);
		}
		else return AccountEditor(playerid);
	}
	if(dialogid == JDIALOGS+18)
	{
		if(response)
		{
            if(!IsNumeric(inputtext) || strlen(inputtext) == 0)
			{
                 GetPVarString(playerid, "AccountName", NickName, 24);
                 format(Jstring, 128, "%s: Kills", NickName);
				 return ShowPlayerDialog(playerid,JDIALOGS+18,DIALOG_STYLE_INPUT,Jstring,"Enter new Kills:\n{FF0000}*Kills must be a nemeric value","Save","Back");
	        }
		    GetPVarString(playerid, "AccountName", NickName, 24);
			format(Jfile, 100, ACCOUNTS_PATH, NickName);
			new INI:ACCOUNT = INI_Open(Jfile);
			INI_WriteInt(ACCOUNT, "Kills", strval(inputtext));
			INI_Close(ACCOUNT);
			return AccountEditor(playerid);
		}
		else return AccountEditor(playerid);
	}
	if(dialogid == JDIALOGS+19)
	{
		if(response)
		{
            if(!IsNumeric(inputtext) || strlen(inputtext) == 0)
			{
                 GetPVarString(playerid, "AccountName", NickName, 24);
                 format(Jstring, 128, "%s: Death", NickName);
				 return ShowPlayerDialog(playerid,JDIALOGS+19,DIALOG_STYLE_INPUT,Jstring,"Enter new Deaths:\n{FF0000}*Deaths must be a nemeric value","Save","Back");
	        }
		    GetPVarString(playerid, "AccountName", NickName, 24);
			format(Jfile, 100, ACCOUNTS_PATH, NickName);
			new INI:ACCOUNT = INI_Open(Jfile);
			INI_WriteInt(ACCOUNT, "Deaths", strval(inputtext));
			INI_Close(ACCOUNT);
			return AccountEditor(playerid);
		}
		else return AccountEditor(playerid);
	}
	if(dialogid == JDIALOGS+20)
	{
		if(response)
		{
			return AccountEditor(playerid);
		}
	}
	if(dialogid == JDIALOGS+21)
	{
		if(response)
		{
            GetPVarString(playerid, "AccountName", NickName, 24);
            format(Jstring, 128, "%s: Change skin", NickName);
			return ShowPlayerDialog(playerid,JDIALOGS+27,DIALOG_STYLE_INPUT,Jstring,"Enter new skinID:","Save","Back");
		}
		else return AccountEditor(playerid);
	}
	if(dialogid == JDIALOGS+27)
	{
		if(response)
		{
            if(!IsNumeric(inputtext) || strlen(inputtext) == 0 || strval(inputtext) < 0 || strval(inputtext) > 299)
			{
                 GetPVarString(playerid, "AccountName", NickName, 24);
                 format(Jstring, 128, "%s: Change skin", NickName);
				 return ShowPlayerDialog(playerid,JDIALOGS+27,DIALOG_STYLE_INPUT,Jstring,"Enter new skinID:\n{FF0000}*Please enter a valid SkinID (0 - 299)","Save","Back");
	        }
		    GetPVarString(playerid, "AccountName", NickName, 24);
			format(Jfile, 100, ACCOUNTS_PATH, NickName);
			new INI:ACCOUNT = INI_Open(Jfile);
			INI_WriteInt(ACCOUNT, "Skin", strval(inputtext));
			INI_Close(ACCOUNT);
			return AccountEditor(playerid);
		}
		else return AccountEditor(playerid);
	}
	if(dialogid == JDIALOGS+22)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 GetPVarString(playerid, "AccountName", NickName, 24);
	                 format(Jfile, 100, ACCOUNTS_PATH, NickName);
					 new INI:ACCOUNT = INI_Open(Jfile);
					 INI_WriteInt(ACCOUNT, "Autologin", 1);
					 INI_Close(ACCOUNT);
					 return AccountEditor(playerid);
	            }
	            case 1:
				{
	                 GetPVarString(playerid, "AccountName", NickName, 24);
					 format(Jfile, 100, ACCOUNTS_PATH, NickName);
					 new INI:ACCOUNT = INI_Open(Jfile);
					 INI_WriteInt(ACCOUNT, "Autologin", 0);
					 INI_Close(ACCOUNT);
					 return AccountEditor(playerid);
				}
			}
		}
		else return AccountEditor(playerid);
	}
	if(dialogid == JDIALOGS+23)
	{
		if(response)
		{
            GetPVarString(playerid, "AccountName", NickName, 24);
            format(Jstring, 128, "%s: Total Played Seconds", NickName);
			return ShowPlayerDialog(playerid,JDIALOGS+28,DIALOG_STYLE_INPUT,Jstring,"Enter new played seconds:","Save","Back");
		}
		else return AccountEditor(playerid);
	}
	if(dialogid == JDIALOGS+28)
	{
		if(response)
		{
            if(!IsNumeric(inputtext) || strlen(inputtext) == 0)
			{
                 GetPVarString(playerid, "AccountName", NickName, 24);
                 format(Jstring, 128, "%s: Total Played Seconds", NickName);
				 return ShowPlayerDialog(playerid,JDIALOGS+28,DIALOG_STYLE_INPUT,Jstring,"Enter new played seconds:\n{FF0000}Seconds must be a nemeric value","Save","Back");
	        }
		    GetPVarString(playerid, "AccountName", NickName, 24);
			format(Jfile, 100, ACCOUNTS_PATH, NickName);
			new INI:ACCOUNT = INI_Open(Jfile);
			INI_WriteInt(ACCOUNT, "TotalSeconds", strval(inputtext));
			INI_Close(ACCOUNT);
			return AccountEditor(playerid);
		}
		else return AccountEditor(playerid);
	}
	if(dialogid == JDIALOGS+109)
	{
		if(response)
		{
            if(strlen(inputtext) < 3)
			{
                 GetPVarString(playerid, "AccountName", NickName, 24);
                 format(Jstring, 128, "%s: PassWord", NickName);
				 return ShowPlayerDialog(playerid,JDIALOGS+109,DIALOG_STYLE_INPUT,Jstring,"Enter the new Password:\n{FF0000}*Password lenght must be between 3 - 20 chracters","Change","Back");
	        }
	        new buf[145];
		    GetPVarString(playerid, "AccountName", NickName, 24);
			format(Jfile, 100, ACCOUNTS_PATH, NickName);
			WP_Hash(buf, sizeof(buf), inputtext);
			new INI:ACCOUNT = INI_Open(Jfile);
			INI_WriteString(ACCOUNT, "Password", buf);
			INI_Close(ACCOUNT);
			format(Jstring, sizeof(Jstring),"You have changed %s's password to '%s'",NickName,inputtext);
			SendClientMessage(playerid,yellow,Jstring);
			return AccountEditor(playerid);
		}
		else return AccountEditor(playerid);
	}
	if(dialogid == JDIALOGS+110)
	{
		if(response)
		{
            if(strlen(inputtext) < 3 || strlen(inputtext) > MAX_PLAYER_NAME)
			{
                 GetPVarString(playerid, "AccountName", NickName, 24);
                 format(Jstring, 128, "%s: PassWord", NickName);
				 return ShowPlayerDialog(playerid,JDIALOGS+110,DIALOG_STYLE_INPUT,"Rename Account","Enter the new nick name:\n{FF0000}*Name lenght must be between 3 - 20 chracters","Change","Back");
	        }
		    GetPVarString(playerid, "AccountName", NickName, 24);
			format(Jfile, 100, ACCOUNTS_PATH, inputtext);
			if(fexist(Jfile)) return SendClientMessage(playerid,red,"Error: You entered nick name is already in use, please try something else!");
            if(InvalidNick(inputtext)) return SendClientMessage(playerid,red,"Unacceptable NickName. Please only use (0-9, a-z, [], (), $, @, ., _ and =)");
            format(Jstring, sizeof(Jstring),"You have changed Account %s name to '%s'",NickName,inputtext);
			SendClientMessage(playerid,yellow,Jstring);
			format(Jfile, 100, ACCOUNTS_PATH, NickName);
			JLrename(Jfile,inputtext);
			SetPVarString(playerid,"AccountName",inputtext);
            foreach(Player, i)
            {
	            if(strcmp(NickName,GetName(i),true) == 0)
				{
		            format(Jstring, sizeof(Jstring),"Admin '%s' has renamed your account name to '%s'",GetName(playerid),inputtext);
		            SendClientMessage(i,yellow,Jstring);
		            SetPlayerName(i,inputtext);
	            }
            }
			return AccountEditor(playerid);
		}
		else return AccountEditor(playerid);
	}
	if(dialogid == JDIALOGS+24)
	{
		if(response)
		{
           return AccountEditor(playerid);
		}
	}
	if(dialogid == JDIALOGS+25)
	{
		if(response)
		{
           return AccountEditor(playerid);
		}
	}
	if(dialogid == JDIALOGS+26)
	{
		if(response)
		{
            if(!IsNumeric(inputtext) || strlen(inputtext) == 0)
			{
                 GetPVarString(playerid, "AccountName", NickName, 24);
                 format(Jstring, 128, "%s: Change level", NickName);
				 return ShowPlayerDialog(playerid,JDIALOGS+26,DIALOG_STYLE_INPUT,Jstring,"Enter new Level:\n{FF0000}*Level must be a nemeric value","Save","Back");
	        }
	        format(Jstring, 128, "%s: Change level", NickName);
	        format(string, 128, "Enter new Level:\n{FF0000}*Error: Server maximum admin level is %d", MaxAdminLevel);
	        if(strval(inputtext) > MaxAdminLevel) return ShowPlayerDialog(playerid,JDIALOGS+26,DIALOG_STYLE_INPUT,Jstring,string,"Save","Back");
		    GetPVarString(playerid, "AccountName", NickName, 24);
			format(Jfile, 100, ACCOUNTS_PATH, NickName);
			new INI:ACCOUNT = INI_Open(Jfile);
			INI_WriteInt(ACCOUNT, "Level", strval(inputtext));
			INI_Close(ACCOUNT);
			return AccountEditor(playerid);
		}
		else return AccountEditor(playerid);
	}
	if(dialogid == JDIALOGS+38)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                return ShowPlayerDialog(playerid,JDIALOGS+39,DIALOG_STYLE_MSGBOX,"Clear ban log","Are you sure you want to clear the ban log ?","Yes","No");
	            }
	            case 1:
				{
				    return ShowPlayerDialog(playerid,JDIALOGS+40,DIALOG_STYLE_MSGBOX,"Clear kick log","Are you sure you want to clear the kick log ?","Yes","No");
				}
				case 2:
				{
					 return ShowPlayerDialog(playerid,JDIALOGS+41,DIALOG_STYLE_MSGBOX,"Clear AC log","Are you sure you want to clear the anti cheats records ?","Yes","No");
				}
				case 3:
				{
					 return ShowPlayerDialog(playerid,JDIALOGS+42,DIALOG_STYLE_MSGBOX,"Clear PM(s) log","Are you sure you want to clear the private messages log ?","Yes","No");
				}
				case 4:
				{
					 return ShowPlayerDialog(playerid,JDIALOGS+43,DIALOG_STYLE_MSGBOX,"Clear Crash log","Are you sure you want to clear the crash log ?","Yes","No");
				}
			}
		}
	}
	if(dialogid == JDIALOGS+39)
	{
		if(response)
		{
            format(Jfile, 100, LOGS_PATH, "Bans");
            if(!fexist(Jfile)) return ShowPlayerDialog(playerid,JDIALOGS+44,DIALOG_STYLE_MSGBOX,"Error","{FF0000}Could not clear the ban log (Could not find the file)","Ok","");
            fremove(Jfile);
            ShowPlayerDialog(playerid,JDIALOGS+44,DIALOG_STYLE_MSGBOX,"Ban log cleared","You have successfully cleared the ban log","Ok","");
		}
	}
	if(dialogid == JDIALOGS+40)
	{
		if(response)
		{
            format(Jfile, 100, LOGS_PATH, "KickLog");
            if(!fexist(Jfile)) return ShowPlayerDialog(playerid,JDIALOGS+44,DIALOG_STYLE_MSGBOX,"Error","{FF0000}Could not clear the kick log(Could not find the file)","Ok","");
            fremove(Jfile);
            ShowPlayerDialog(playerid,JDIALOGS+44,DIALOG_STYLE_MSGBOX,"Kick log cleared","You have successfully cleared the kick log","Ok","");
		}
	}
	if(dialogid == JDIALOGS+41)
	{
		if(response)
		{
            format(Jfile, 100, LOGS_PATH, "AntiCheatLog");
            if(!fexist(Jfile)) return ShowPlayerDialog(playerid,JDIALOGS+44,DIALOG_STYLE_MSGBOX,"Error","{FF0000}Could not clear the anti cheat log(Could not find the file)","Ok","");
            fremove(Jfile);
            ShowPlayerDialog(playerid,JDIALOGS+44,DIALOG_STYLE_MSGBOX,"AC log cleared","You have successfully cleared the anti cheat log","Ok","");
		}
	}
	if(dialogid == JDIALOGS+42)
	{
		if(response)
		{
            format(Jfile, 100, LOGS_PATH, "PrivateMessages");
            if(!fexist(Jfile)) return ShowPlayerDialog(playerid,JDIALOGS+44,DIALOG_STYLE_MSGBOX,"Error","{FF0000}Could not clear the private messages log(Could not find the file)","Ok","");
            fremove(Jfile);
            ShowPlayerDialog(playerid,JDIALOGS+44,DIALOG_STYLE_MSGBOX,"PM(s) log cleared","You have successfully cleared the private message log","Ok","");
		}
	}
	if(dialogid == JDIALOGS+43)
	{
		if(response)
		{
            format(Jfile, 100, LOGS_PATH, "Crash");
            if(!fexist(Jfile)) return ShowPlayerDialog(playerid,JDIALOGS+44,DIALOG_STYLE_MSGBOX,"Error","{FF0000}Could not clear the crash log(Could not find the file)","Ok","");
            fremove(Jfile);
            ShowPlayerDialog(playerid,JDIALOGS+44,DIALOG_STYLE_MSGBOX,"Crash log cleared","You have successfully cleared the crash log","Ok","");
		}
	}
	if(dialogid == JDIALOGS+46)
	{
		if(response)
		{
               new id = pInfo[playerid][Clicked];
               if(!IsPlayerConnected(id)) return ShowMessage(playerid, red, 2);
               if(strlen(inputtext) < 2 || strlen(inputtext) > 80) return ShowPlayerDialog(playerid,JDIALOGS+46,DIALOG_STYLE_INPUT,"Report","Enter the reason:\n{FF0000}*Please enter a valid reason","Report","Close");
			   format(Jstring,sizeof(Jstring),"{FF0000}[REPORT:]{FFFFFF} %s(ID: %d) Reported %s(ID: %d) |{FF0000} REASON: %s",GetName(playerid),playerid,GetName(id),id,inputtext);
			   SendToAdmins(-1,Jstring);
			   format(Jstring,sizeof(Jstring),"%s Has Reported %s | REASON: %s",GetName(playerid),GetName(id),inputtext);
			   WriteToLog(Jstring,"Reports");
			   StoreReport(playerid,id,inputtext);
		}
	}
	if(dialogid == JDIALOGS+47)
	{
		if(response)
		{
		        if(pInfo[playerid][pLevel] >= 1)
		        {
		             new id;
		             id = pInfo[playerid][Clicked];
		             if(strlen(inputtext) < 2 || strlen(inputtext) > 80) return ShowPlayerDialog(playerid,JDIALOGS+47,DIALOG_STYLE_INPUT,"Kick Player","Enter the reason:\n{FF0000}*Please enter a valid reason","Kick","Cancel");
		             if(IsPlayerConnected(id) && id != playerid)
		             {
		                if(pInfo[playerid][pLevel] <= pInfo[id][pLevel]) return ShowMessage(playerid, red, 6);
					    format(Jstring,sizeof(Jstring),"'%s' has been kicked by administrator %s Reason: %s",GetName(id),GetName(playerid),inputtext);
						SendClientMessageToAll(red,Jstring);
						format(Jstring,sizeof(Jstring),"[INGAME KICK] %s has kicked %s - %s ",GetName(playerid),GetName(id),inputtext);
						WriteToLog(Jstring,"KickLog");
						return SetTimerEx("KickPlayer",200,false,"d", id);
					 }
					 else return ShowMessage(playerid, red, 3);
				}
				else return ShowMessage(playerid, red, 1);
		}
	}
	if(dialogid == JDIALOGS+48)
	{
		if(response)
		{
			    if(pInfo[playerid][pLevel] >= 2)
				{
			       new id, file[200];
				   new year, month, day, hour, minuite, second;
				   id = pInfo[playerid][Clicked];
				   if(strlen(inputtext) < 2 || strlen(inputtext) > 80) return ShowPlayerDialog(playerid,JDIALOGS+48,DIALOG_STYLE_INPUT,"Ban Player","Enter the reason:\n{FF0000}*Please enter a valid reason","Ban","Cancel");
				   if(IsPlayerConnected(id) && id != playerid)
				   {
			          if(pInfo[playerid][pLevel] <= pInfo[id][pLevel]) return ShowMessage(playerid, red, 6);
			          getdate(year, month, day);
					  gettime(hour,minuite,second);
				      format(Jstring,sizeof(Jstring),"%s has been Banned by Administrator %s | Reason: %s <Date: %d/%d/%d> <Time: %d:%d>",GetName(id),GetName(playerid),inputtext,day,month,year,hour,minuite);
					  SendClientMessageToAll(red,Jstring);
					  format(JLstring,sizeof(JLstring),"{37C8C8}Administrator %s has banned you for: \"%s\"\n\nVisit "WEBSITE" for more informations", GetName(playerid),inputtext);
					  ShowPlayerDialog(id,JDIALOGS+200,DIALOG_STYLE_MSGBOX,"                     {FF0000}You are BANNED",JLstring,"OK","");
					  if(pInfo[id][Logged] == 1)
					  {
						  format(file, 200, ACCOUNTS_PATH, GetName(id));
						  new INI:ACCOUNT = INI_Open(file);
						  INI_WriteInt(ACCOUNT, "Banned", 1);
						  INI_Close(ACCOUNT);
					  }
					  format(Jstring,sizeof(Jstring),"Ban by %s  Reason: %s",GetName(playerid),inputtext);
					  SetPVarString(id,"Banreason",Jstring);
					  format(Jstring,sizeof(Jstring),"[INGAME BAN] %s has banned %s - %s",GetName(playerid),GetName(id),inputtext);
					  WriteToLog(Jstring,"Bans");
					  return SetTimerEx("BanPlayer",200,false,"dd", id,0);
					}
					else return ShowMessage(playerid, red, 3);
			    }
				return 1;
		}
	}
	if(dialogid == JDIALOGS+29)
	{
       if(response)
	   {
            switch(listitem)
			{
	            case 0:
	            {
	                if(IsDisabledChat == 0) return SendClientMessage(playerid,red,"Main chat is not disabled!");
	                format(Jstring,sizeof(Jstring),"Admin %s has enabled the main chat",GetName(playerid));
	                SendClientMessageToAll(orange,Jstring);
	                IsDisabledChat = 0;
				}
				case 1:
	            {
	                if(IsDisabledChat == 1) return SendClientMessage(playerid,red,"Main chat is already disabled!");
	                format(Jstring,sizeof(Jstring),"Admin %s has disabled the main chat",GetName(playerid));
	                SendClientMessageToAll(orange,Jstring);
	                AdmName = GetName(playerid);
	                IsDisabledChat = 1;
				}
			}
		 }
    }
    if(dialogid == JDIALOGS+50)
	{
       if(response)
	   {
            if (IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,red,"You have a vehicle already");
            switch(listitem)
			{
	            case 0:
	            {
					new vid;
	                GiveVehicle(playerid,558);
	                vid = GetPlayerVehicleID(playerid);
					AddVehicleComponent(vid, 1010); AddVehicleComponent(vid, 1089);	AddVehicleComponent(vid, 1163);
				    AddVehicleComponent(vid, 1085);	AddVehicleComponent(vid, 1090);	AddVehicleComponent(vid, 1165);
				    AddVehicleComponent(vid, 1087);	AddVehicleComponent(vid, 1091); AddVehicleComponent(vid, 1167);
					PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
					ChangeVehiclePaintjob(vid,1);
	            }
	            case 1:
	            {
	                new vid;
	                GiveVehicle(playerid,560);
	                vid = GetPlayerVehicleID(playerid);
					AddVehicleComponent(vid, 1010); AddVehicleComponent(vid, 1033);	AddVehicleComponent(vid, 1138);
				    AddVehicleComponent(vid, 1026);	AddVehicleComponent(vid, 1083);	AddVehicleComponent(vid, 1140);
				    AddVehicleComponent(vid, 1028);	AddVehicleComponent(vid, 1087); AddVehicleComponent(vid, 1169);
					PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
					ChangeVehiclePaintjob(vid,1);
	            }
	            case 2:
	            {
	                new vid;
	                GiveVehicle(playerid,559);
	                vid = GetPlayerVehicleID(playerid);
					AddVehicleComponent(vid, 1010); AddVehicleComponent(vid, 1087);	AddVehicleComponent(vid, 1158);
				    AddVehicleComponent(vid, 1065);	AddVehicleComponent(vid, 1085);	AddVehicleComponent(vid, 1160);
				    AddVehicleComponent(vid, 1068);	AddVehicleComponent(vid, 1069); AddVehicleComponent(vid, 1161);
					PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
					ChangeVehiclePaintjob(vid,0);
	            }
	            case 3:
	            {
	                new vid;
	                GiveVehicle(playerid,561);
	                vid = GetPlayerVehicleID(playerid);
					AddVehicleComponent(vid, 1010); AddVehicleComponent(vid, 1061);	AddVehicleComponent(vid, 1156);
				    AddVehicleComponent(vid, 1056);	AddVehicleComponent(vid, 1064);	AddVehicleComponent(vid, 1157);
				    AddVehicleComponent(vid, 1060);	AddVehicleComponent(vid, 1074);
					PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
					ChangeVehiclePaintjob(vid,1);
	            }
	            case 4:
				{
	                new vid;
	                GiveVehicle(playerid,561);
	                vid = GetPlayerVehicleID(playerid);
					AddVehicleComponent(vid, 1010); AddVehicleComponent(vid, 1058);	AddVehicleComponent(vid, 1087);
				    AddVehicleComponent(vid, 1055);	AddVehicleComponent(vid, 1059);	AddVehicleComponent(vid, 1154);
				    AddVehicleComponent(vid, 1056);	AddVehicleComponent(vid, 1085); AddVehicleComponent(vid, 1155);
					PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
					ChangeVehiclePaintjob(vid,2);
				}
				case 5:
	            {
	                new vid;
	                GiveVehicle(playerid,560);
	                vid = GetPlayerVehicleID(playerid);
					AddVehicleComponent(vid, 1010); AddVehicleComponent(vid, 1033);	AddVehicleComponent(vid, 1140);
				    AddVehicleComponent(vid, 1029);	AddVehicleComponent(vid, 1079);	AddVehicleComponent(vid, 1169);
				    AddVehicleComponent(vid, 1031);	AddVehicleComponent(vid, 1138);
					PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
					ChangeVehiclePaintjob(vid,0);
	            }
	            case 6:
				{
	                new vid;
	                GiveVehicle(playerid,562);
	                vid = GetPlayerVehicleID(playerid);
					AddVehicleComponent(vid, 1010); AddVehicleComponent(vid, 1039);	AddVehicleComponent(vid, 1146);
				    AddVehicleComponent(vid, 1037);	AddVehicleComponent(vid, 1079);	AddVehicleComponent(vid, 1148);
				    AddVehicleComponent(vid, 1038);	AddVehicleComponent(vid, 1087); AddVehicleComponent(vid, 1172);
					PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
					ChangeVehiclePaintjob(vid,1);
				}
				case 7:
				{
	                new vid;
	                GiveVehicle(playerid,565);
	                vid = GetPlayerVehicleID(playerid);
					AddVehicleComponent(vid, 1010); AddVehicleComponent(vid, 1050);	AddVehicleComponent(vid, 1087);
				    AddVehicleComponent(vid, 1045);	AddVehicleComponent(vid, 1054);	AddVehicleComponent(vid, 1151);
				    AddVehicleComponent(vid, 1047);	AddVehicleComponent(vid, 1083); AddVehicleComponent(vid, 1153);
					PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
					ChangeVehiclePaintjob(vid,0);
				}
				case 8:
				{
	                new vid;
	                GiveVehicle(playerid,534);
	                vid = GetPlayerVehicleID(playerid);
					AddVehicleComponent(vid, 1010); AddVehicleComponent(vid, 1100);
				    AddVehicleComponent(vid, 1077);	AddVehicleComponent(vid, 1122);
				    AddVehicleComponent(vid, 1087);	AddVehicleComponent(vid, 1127);
					PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
					ChangeVehiclePaintjob(vid,2);
				}
				case 9:
				{
	                new vid;
	                GiveVehicle(playerid,535);
	                vid = GetPlayerVehicleID(playerid);
					AddVehicleComponent(vid, 1010); AddVehicleComponent(vid, 1109); AddVehicleComponent(vid, 1118);
				    AddVehicleComponent(vid, 1087);	AddVehicleComponent(vid, 1113);
				    AddVehicleComponent(vid, 1098);	AddVehicleComponent(vid, 1115);
					PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
					ChangeVehiclePaintjob(vid,0);
				}
		   }
	   }
	}
	if(dialogid == JDIALOGS+51)
	{
       if(response)
	   {
            new id = GetPVarInt(playerid, "TargetID");
            switch(listitem)
			{
	            case 0:
	            {
	                format(Jstring,sizeof(Jstring),"You have set %s' maker colour to 'yellow'",GetName(id));
	                SendClientMessage(playerid,yellow,Jstring);
	                foreach(Player, i)
				    {
	                    SetPlayerMarkerForPlayer(i,id,yellow);
				    }
	            }
	            case 1:
	            {
	               format(Jstring,sizeof(Jstring),"You have set %s' maker colour to 'white'",GetName(id));
	               SendClientMessage(playerid,yellow,Jstring);
	               foreach(Player, i)
				   {
	                    SetPlayerMarkerForPlayer(i,id,white);
	               }
	            }
	            case 2:
	            {
	               format(Jstring,sizeof(Jstring),"You have set %s' maker colour to 'blue'",GetName(id));
	               SendClientMessage(playerid,yellow,Jstring);
	               foreach(Player, i)
				   {
	                    SetPlayerMarkerForPlayer(i,id,blue);
	               }
	            }
	            case 3:
	            {
	               format(Jstring,sizeof(Jstring),"You have set %s' maker colour to 'red'",GetName(id));
	               SendClientMessage(playerid,yellow,Jstring);
	               foreach(Player, i)
				   {
	                    SetPlayerMarkerForPlayer(i,id,red);
	               }
	            }
	            case 4:
	            {
	               format(Jstring,sizeof(Jstring),"You have set %s' maker colour to 'green'",GetName(id));
	               SendClientMessage(playerid,yellow,Jstring);
	               foreach(Player, i)
				   {
	                    SetPlayerMarkerForPlayer(i,id,green);
	               }
	            }
	            case 5:
	            {
	               format(Jstring,sizeof(Jstring),"You have set %s' maker colour to 'orange'",GetName(id));
	               SendClientMessage(playerid,yellow,Jstring);
	               foreach(Player, i)
				   {
	                    SetPlayerMarkerForPlayer(i,id,orange);
	               }
	            }
	            case 6:
	            {
	               format(Jstring,sizeof(Jstring),"You have set %s' maker colour to 'purple'",GetName(id));
	               SendClientMessage(playerid,yellow,Jstring);
	               foreach(Player, i)
				   {
	                    SetPlayerMarkerForPlayer(i,id,purple);
	               }
	            }
	            case 7:
	            {
	               format(Jstring,sizeof(Jstring),"You have set %s' maker colour to 'PINK'",GetName(id));
	               SendClientMessage(playerid,yellow,Jstring);
	               foreach(Player, i)
				   {
	                    SetPlayerMarkerForPlayer(i,id,pink);
	               }
	            }
	            case 8:
	            {
	               format(Jstring,sizeof(Jstring),"You have set %s' maker colour to 'BROWN'",GetName(id));
	               SendClientMessage(playerid,yellow,Jstring);
	               foreach(Player, i)
				   {
	                    SetPlayerMarkerForPlayer(i,id,brown);
	               }
	            }
	            case 9:
	            {
	               format(Jstring,sizeof(Jstring),"You have set %s' maker colour to 'BLACK'",GetName(id));
	               SendClientMessage(playerid,yellow,Jstring);
	               foreach(Player, i)
				   {
	                    SetPlayerMarkerForPlayer(i,id,black);
	               }
	            }
            }
	   }
	}
	if(dialogid == JDIALOGS+52)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 ShowPlayerDialog(playerid,JDIALOGS+53,DIALOG_STYLE_LIST,"SERVER AUTO LOGIN","{0000FF}Enable\n{FF0000}Disable","Select","Back");
	            }
	            case 1:
				{
					 ShowPlayerDialog(playerid,JDIALOGS+54,DIALOG_STYLE_LIST,"DETECT PAUSE","{0000FF}Enable\n{FF0000}Disable","Select","Back");
				}
				case 2:
				{
					 ShowPlayerDialog(playerid,JDIALOGS+55,DIALOG_STYLE_LIST,"MUST REGISTER","{0000FF}Enable\n{FF0000}Disable","Select","Back");
				}
				case 3:
				{
					 ShowPlayerDialog(playerid,JDIALOGS+56,DIALOG_STYLE_INPUT,"SERVER MAX PING ALLOWED","Please enter the server new max ping","Ok","Back");
				}
				case 4:
				{
	                 ShowPlayerDialog(playerid,JDIALOGS+57,DIALOG_STYLE_LIST,"ANTI SPAM","{0000FF}Enable\n{FF0000}Disable","Select","Back");
				}
				case 5:
				{
	                 ShowPlayerDialog(playerid,JDIALOGS+58,DIALOG_STYLE_LIST,"ANTI WEAPON HACK","{0000FF}Enable\n{FF0000}Disable","Select","Back");
				}
				case 6:
				{
	                 ShowPlayerDialog(playerid,JDIALOGS+59,DIALOG_STYLE_LIST,"ANTI BAD WORDS","{0000FF}Enable\n{FF0000}Disable","Select","Back");
				}
				case 7:
				{
	                 ShowPlayerDialog(playerid,JDIALOGS+60,DIALOG_STYLE_LIST,"FORBIDDEN NAMES KICK","{0000FF}Enable\n{FF0000}Disable","Select","Back");
				}
				case 8:
				{
	                 ShowPlayerDialog(playerid,JDIALOGS+61,DIALOG_STYLE_LIST,"FORBIDDEN PART NAMES KICK","{0000FF}Enable\n{FF0000}Disable","Select","Back");
				}
				case 9:
				{
	                 ShowPlayerDialog(playerid,JDIALOGS+62,DIALOG_STYLE_LIST,"ANTI ADVERTISEMENTS","{0000FF}Enable\n{FF0000}Disable","Select","Back");
				}
				case 10:
				{
	                 ShowPlayerDialog(playerid,JDIALOGS+63,DIALOG_STYLE_LIST,"ANTI BAN EVADE","{0000FF}Enable\n{FF0000}Disable","Select","Back");
				}
				case 11:
				{
	                 ShowPlayerDialog(playerid,JDIALOGS+64,DIALOG_STYLE_INPUT,"MAX ADMIN LEVEL","Please enter the new max admin level","Ok","Back");
				}
				case 12:
				{
					 ShowPlayerDialog(playerid,JDIALOGS+65,DIALOG_STYLE_LIST,"ADMIN IMMUNITY","{0000FF}Enable\n{FF0000}Disable","Select","Back");
				}
				case 13:
				{
					 ShowPlayerDialog(playerid,JDIALOGS+66,DIALOG_STYLE_LIST,"ADMIN READ PM(S)","{0000FF}Enable\n{FF0000}Disable","Select","Back");
				}
				case 14:
				{
	                 ShowPlayerDialog(playerid,JDIALOGS+67,DIALOG_STYLE_LIST,"ADMIN READ CMDS","{0000FF}Enable\n{FF0000}Disable","Select","Back");
				}
				case 15:
				{
					 ShowPlayerDialog(playerid,JDIALOGS+68,DIALOG_STYLE_LIST,"PM DIALOG","{0000FF}Enable\n{FF0000}Disable","Select","Back");
				}
				case 16:
				{
					 ShowPlayerDialog(playerid,JDIALOGS+69,DIALOG_STYLE_LIST,"ADMIN CHEAT BANS","{0000FF}Enable\n{FF0000}Disable","Select","Back");
				}
				case 17:
				{
					 ShowPlayerDialog(playerid,JDIALOGS+70,DIALOG_STYLE_LIST,"ALLOW CHANGE NICK","{0000FF}Enable\n{FF0000}Disable","Select","Back");
				}
				case 18:
				{
	                 ShowPlayerDialog(playerid,JDIALOGS+71,DIALOG_STYLE_LIST,"FORBIDDEN WEAPON","View Forbidden weapons list\nAdd new weapon\nClear Forbidden weapons list","Select","Back");
				}
				case 19:
				{
					 ShowPlayerDialog(playerid,JDIALOGS+76,DIALOG_STYLE_LIST,"FORBIDDEN NAMES","View Forbidden names list\nAdd new forbidden name\nClear Forbidden names list","Select","Back");
				}
				case 20:
				{
					 ShowPlayerDialog(playerid,JDIALOGS+79,DIALOG_STYLE_LIST,"FORBIDDEN PART NAMES","View Forbidden Part Nick list\nAdd new forbidden nick part\nClear Forbidden part nicks list","Select","Back");
				}
				case 21:
				{
					 ShowPlayerDialog(playerid,JDIALOGS+82,DIALOG_STYLE_LIST,"BAD WORDS","View bad word list\nAdd new bad word\nClear bad word list","Select","Back");
				}
				case 22:
				{
					 LoadSettings();
					 LoadIllegalWeaps();
					 LoadForbiddenNicks();
					 LoadBadNickParts();
					 LoadBadWords();
					 LoadTeleports();
					 SendClientMessage( playerid, yellow, "You have re-loaded JLadmin system settings!" );
				}
			}
   		}
	}
	if(dialogid == JDIALOGS+53)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "AutoLogin", 1);
					 INI_Close(SETTING);
					 AutoLogin = 1;
					 return ServSettings(playerid);
	            }
	            case 1:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "AutoLogin", 0);
					 INI_Close(SETTING);
					 AutoLogin = 0;
					 return ServSettings(playerid);
				}
			}
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+54)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "DetectPausers", 1);
					 INI_Close(SETTING);
					 DetectPausers = 1;
					 return ServSettings(playerid);
	            }
	            case 1:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "DetectPausers", 0);
					 INI_Close(SETTING);
					 DetectPausers = 0;
					 return ServSettings(playerid);
				}
			}
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+55)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "MustRegister", 1);
					 INI_Close(SETTING);
					 MustRegister = 1;
					 return ServSettings(playerid);
	            }
	            case 1:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "MustRegister", 0);
					 INI_Close(SETTING);
					 MustRegister = 0;
					 return ServSettings(playerid);
				}
			}
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+56)
	{
		if(response)
		{
            if(!IsNumeric(inputtext) || strlen(inputtext) == 0 || strval(inputtext) < 0)
			return ShowPlayerDialog(playerid,JDIALOGS+56,DIALOG_STYLE_INPUT,"SERVER MAX PING ALLOWED","Enter the server new max ping\n{FF0000}*Please enter a Numeric value","Save","Back");
            format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
			new INI:SETTING = INI_Open(Jfile);
			INI_WriteInt(SETTING, "MaxPing", strval(inputtext));
			INI_Close(SETTING);
			MaxPing = strval(inputtext);
			return ServSettings(playerid);
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+57)
	{
		if(response)
		{
            switch(listitem)
			{
		        case 0:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "AntiSpam", 1);
					 INI_Close(SETTING);
					 AntiSpam = 1;
					 return ServSettings(playerid);
	            }
                case 1:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "AntiSpam", 0);
					 INI_Close(SETTING);
					 AntiSpam = 0;
					 return ServSettings(playerid);
				}
			}
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+58)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "AntiWeaponHack", 1);
					 INI_Close(SETTING);
					 AntiWeaponHack = 1;
					 return ServSettings(playerid);
	            }
	            case 1:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "AntiWeaponHack", 0);
					 INI_Close(SETTING);
					 AntiWeaponHack = 0;
					 return ServSettings(playerid);
				}
			}
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+59)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "AntiBadWords", 1);
					 INI_Close(SETTING);
					 AntiForbiddenWords = 1;
					 return ServSettings(playerid);
	            }
	            case 1:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "AntiBadWords", 0);
					 INI_Close(SETTING);
					 AntiForbiddenWords = 0;
					 return ServSettings(playerid);
				}
			}
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+60)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "ForbiddenNamesKick", 1);
					 INI_Close(SETTING);
					 ForbiddenNamesKick = 1;
					 return ServSettings(playerid);
	            }
	            case 1:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "ForbiddenNamesKick", 0);
					 INI_Close(SETTING);
					 ForbiddenNamesKick = 0;
					 return ServSettings(playerid);
				}
			}
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+61)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "PartNamesKick", 1);
					 INI_Close(SETTING);
					 KickPartNicks = 1;
					 return ServSettings(playerid);
	            }
	            case 1:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "PartNamesKick", 0);
					 INI_Close(SETTING);
					 KickPartNicks = 0;
					 return ServSettings(playerid);
				}
			}
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+62)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "AntiAdvertisements", 1);
					 INI_Close(SETTING);
					 AntiAdv = 1;
					 return ServSettings(playerid);
	            }
	            case 1:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "AntiAdvertisements", 0);
					 INI_Close(SETTING);
					 AntiAdv = 0;
					 return ServSettings(playerid);
				}
			}
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+63)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "AntiBanEvade", 1);
					 INI_Close(SETTING);
					 AntiBanEvade = 1;
					 return ServSettings(playerid);
	            }
	            case 1:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "AntiBanEvade", 0);
					 INI_Close(SETTING);
					 AntiBanEvade = 0;
					 return ServSettings(playerid);
				}
			}
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+64)
	{
		if(response)
		{
            if(!IsNumeric(inputtext) || strlen(inputtext) == 0 || strval(inputtext) < 0)
			return ShowPlayerDialog(playerid,JDIALOGS+64,DIALOG_STYLE_INPUT,"SERVER MAX ADMIN LEVEL","Enter the new max admin level\n{FF0000}*Please enter a Numeric value","Save","Back");
            format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
			new INI:SETTING = INI_Open(Jfile);
			INI_WriteInt(SETTING, "MaxLevels", strval(inputtext));
			INI_Close(SETTING);
			MaxAdminLevel = strval(inputtext);
			return ServSettings(playerid);
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+65)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "AdminImmunity", 1);
					 INI_Close(SETTING);
					 AdminImmunity = 1;
					 return ServSettings(playerid);
	            }
	            case 1:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "AdminImmunity", 0);
					 INI_Close(SETTING);
					 AdminImmunity = 0;
					 return ServSettings(playerid);
				}
			}
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+66)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "AdminReadPms", 1);
					 INI_Close(SETTING);
					 ShowPmstoAdmins = 1;
					 return ServSettings(playerid);
	            }
	            case 1:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "AdminReadPms", 0);
					 INI_Close(SETTING);
					 ShowPmstoAdmins = 0;
					 return ServSettings(playerid);
				}
			}
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+67)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "AdminReadCmds", 1);
					 INI_Close(SETTING);
					 ReadCommands = 1;
					 return ServSettings(playerid);
	            }
	            case 1:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "AdminReadCmds", 0);
					 INI_Close(SETTING);
					 ReadCommands = 0;
					 return ServSettings(playerid);
				}
			}
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+68)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "PmDialog", 1);
					 INI_Close(SETTING);
					 PmDialog = 1;
					 return ServSettings(playerid);
	            }
	            case 1:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "PmDialog", 0);
					 INI_Close(SETTING);
					 PmDialog = 0;
					 return ServSettings(playerid);
				}
			}
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+69)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "AntiCheatbans", 1);
					 INI_Close(SETTING);
					 AntiCheatBans = 1;
					 return ServSettings(playerid);
	            }
	            case 1:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "AntiCheatbans", 0);
					 INI_Close(SETTING);
					 AntiCheatBans = 0;
					 return ServSettings(playerid);
				}
			}
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+70)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "AllowChangeName", 1);
					 INI_Close(SETTING);
					 AllowChangeNick = 1;
					 return ServSettings(playerid);
	            }
	            case 1:
				{
	                 format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
					 new INI:SETTING = INI_Open(Jfile);
					 INI_WriteInt(SETTING, "AllowChangeName", 0);
					 INI_Close(SETTING);
					 AllowChangeNick = 0;
					 return ServSettings(playerid);
				}
			}
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+71)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 format(Jfile,sizeof(Jfile), SETTING_PATH, "Illegalweapons");
					 if(!fexist(Jfile)) return ShowPlayerDialog(playerid,JDIALOGS+72,DIALOG_STYLE_MSGBOX,"Error","{FF0000}Could not find the file/Path","Ok","");
	                 new temp[7];
	                 strdel(VLstring,0,850);
					 new File:JLfile = fopen(Jfile, io_read);
					 while(fread(JLfile, temp))
					 {
	                    strcat(VLstring, temp);
		             }
					 fclose(JLfile);
					 ShowPlayerDialog(playerid,JDIALOGS+72,DIALOG_STYLE_MSGBOX,"Forbidden Weapons(List)", VLstring ,"Ok","");
					 if(strlen(VLstring) == 0)ShowPlayerDialog(playerid,JDIALOGS+72,DIALOG_STYLE_MSGBOX,"Forbidden Weapons(List)", "No forbidden weapons found!" ,"Ok","");
					 strdel(VLstring,0,850);
					 return 1;
	            }
	            case 1:
				{
					 ShowPlayerDialog(playerid,JDIALOGS+73,DIALOG_STYLE_INPUT,"ADD NEW FORBIDDEN WEAPON","Enter the ID of the weapon you want to add the forbidden list","Add","Back");
				}
				case 2:
				{
					 return ShowPlayerDialog(playerid,JDIALOGS+74,DIALOG_STYLE_MSGBOX,"Clear forbidden weapons","Are you sure you want to clear the forbidden weapons list ?","Yes","No");
				}
			}
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+72)
	{
		if(response)
		{
              return ServSettings(playerid);
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+73)
	{
		if(response)
		{
            if(!IsNumeric(inputtext) || strlen(inputtext) == 0 || strval(inputtext) < 1 || strval(inputtext) > 46)
			return ShowPlayerDialog(playerid,JDIALOGS+73,DIALOG_STYLE_INPUT,"ADD NEW FORBIDDEN WEAPON","Enter the ID of the weapon you want to add the forbidden list\n{FF0000}*Invalid weapon ID","Add","Back");
			if(IllegalWeaps(strval(inputtext))) return ShowPlayerDialog(playerid,JDIALOGS+72,DIALOG_STYLE_MSGBOX,"Error","You entered weapon ID is already in forbidden weapons list","Ok","");
            new str[20];
            format(Jfile,sizeof(Jfile), SETTING_PATH, "Illegalweapons");
			format(str, 10, "%d\r\n", strval(inputtext));
			new File:JLlog = fopen(Jfile,io_append);
			fwrite(JLlog,str);
			fclose(JLlog);
			GetWeaponName(strval(inputtext), str, sizeof(str));
			format(Jstring,sizeof(Jstring),"%s has added \"%s(%d)\" to forbidden weapons list!",GetName(playerid),str,strval(inputtext));
			AlertToAdmins(playerid,red,Jstring);
			format(Jstring,sizeof(Jstring),"You have add \"%s(%d)\" to forbidden weapons list!",str,strval(inputtext));
			SendClientMessage(playerid, yellow, Jstring );
			LoadIllegalWeaps();
			return ServSettings(playerid);
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+74)
	{
		if(response)
		{
            format(Jfile,sizeof(Jfile), SETTING_PATH, "Illegalweapons");
            if(!fexist(Jfile)) return ShowPlayerDialog(playerid,JDIALOGS+72,DIALOG_STYLE_MSGBOX,"Error","{FF0000}Could not find the file/Path","Ok","");
            fremove(Jfile);
            new File:JLnew = fopen(Jfile, io_write);
			if(JLnew)
			{
	            fclose(JLnew);
	        }
            ShowPlayerDialog(playerid,JDIALOGS+72,DIALOG_STYLE_MSGBOX,"forbidden weapons list cleared","You have successfully cleared the forbidden weapons log","Ok","");
            format(Jstring,sizeof(Jstring),"%s has cleared the forbidden weapons list",GetName(playerid));
			AlertToAdmins(playerid,red,Jstring);
		}
	}
	if(dialogid == JDIALOGS+76)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 format(Jfile,sizeof(Jfile), SETTING_PATH, "ForbiddeNicks");
					 if(!fexist(Jfile)) return ShowPlayerDialog(playerid,JDIALOGS+72,DIALOG_STYLE_MSGBOX,"Error","{FF0000}Could not find the file/Path","Ok","");
	                 new temp[30];
	                 strdel(VLstring,0,850);
					 new File:JLfile = fopen(Jfile, io_read);
					 while(fread(JLfile, temp))
					 {
	                    strcat(VLstring, temp);
		             }
					 fclose(JLfile);
					 ShowPlayerDialog(playerid,JDIALOGS+72,DIALOG_STYLE_MSGBOX,"Forbidden names(List)", VLstring ,"Ok","");
					 if(strlen(VLstring) == 0)ShowPlayerDialog(playerid,JDIALOGS+72,DIALOG_STYLE_MSGBOX,"Forbidden names(List)", "No forbidden names found!" ,"Ok","");
					 strdel(VLstring,0,850);
					 return 1;
	            }
	            case 1:
				{
					 ShowPlayerDialog(playerid,JDIALOGS+77,DIALOG_STYLE_INPUT,"ADD NEW FORBIDDEN NAME","Enter the new forbidden name you want to add the forbidden list","Add","Back");
				}
				case 2:
				{
					 return ShowPlayerDialog(playerid,JDIALOGS+78,DIALOG_STYLE_MSGBOX,"Clear forbidden names list","Are you sure you want to clear the forbidden names list ?","Yes","No");
				}
			}
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+77)
	{
		if(response)
		{
            if(strlen(inputtext) < 3 || strlen(inputtext) > MAX_PLAYER_NAME || InvalidNick(inputtext))
			return ShowPlayerDialog(playerid,JDIALOGS+77,DIALOG_STYLE_INPUT,"ADD NEW FORBIDDEN NAME","Enter the new forbidden name you want to add the forbidden list\n{FF0000}*Invalid name","Add","Back");
            new str[30];
            format(Jfile,sizeof(Jfile), SETTING_PATH, "ForbiddeNicks");
			format(str, 10, "%s\r\n", inputtext);
			new File:JLlog = fopen(Jfile,io_append);
			fwrite(JLlog,str);
			fclose(JLlog);
			format(Jstring,sizeof(Jstring),"%s has added \"%s\" to forbidden names list",GetName(playerid),inputtext);
			AlertToAdmins(playerid,red,Jstring);
			format(Jstring,sizeof(Jstring),"You have add \"%s\" to forbidden names list!",inputtext);
			SendClientMessage(playerid, yellow, Jstring );
			LoadForbiddenNicks();
			return ServSettings(playerid);
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+78)
	{
		if(response)
		{
            format(Jfile,sizeof(Jfile), SETTING_PATH, "ForbiddeNicks");
            if(!fexist(Jfile)) return ShowPlayerDialog(playerid,JDIALOGS+72,DIALOG_STYLE_MSGBOX,"Error","{FF0000}Could not find the file/Path","Ok","");
            fremove(Jfile);
            new File:JLnew = fopen(Jfile, io_write);
			if(JLnew)
			{
	            fclose(JLnew);
	        }
            ShowPlayerDialog(playerid,JDIALOGS+72,DIALOG_STYLE_MSGBOX,"forbidden names list cleared","You have successfully cleared the forbidden names list","Ok","");
            format(Jstring,sizeof(Jstring),"%s has cleared the forbidden names list",GetName(playerid));
			AlertToAdmins(playerid,red,Jstring);
		}
	}
	if(dialogid == JDIALOGS+79)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 format(Jfile,sizeof(Jfile), SETTING_PATH, "ForbiddeNickParts");
					 if(!fexist(Jfile)) return ShowPlayerDialog(playerid,JDIALOGS+72,DIALOG_STYLE_MSGBOX,"Error","{FF0000}Could not find the file/Path","Ok","");
	                 new temp[30];
	                 strdel(VLstring,0,850);
					 new File:JLfile = fopen(Jfile, io_read);
					 while(fread(JLfile, temp))
					 {
	                    strcat(VLstring, temp);
		             }
					 fclose(JLfile);
					 ShowPlayerDialog(playerid,JDIALOGS+72,DIALOG_STYLE_MSGBOX,"Forbidden part nicks(List)", VLstring ,"Ok","");
					 if(strlen(VLstring) == 0)ShowPlayerDialog(playerid,JDIALOGS+72,DIALOG_STYLE_MSGBOX,"Forbidden names(List)", "No forbidden part nicks found!" ,"Ok","");
					 strdel(VLstring,0,850);
					 return 1;
	            }
	            case 1:
				{
					 ShowPlayerDialog(playerid,JDIALOGS+80,DIALOG_STYLE_INPUT,"ADD NEW FORBIDDEN PART NICK","Enter the new forbidden part nick you want to add the forbidden list","Add","Back");
				}
				case 2:
				{
					 return ShowPlayerDialog(playerid,JDIALOGS+81,DIALOG_STYLE_MSGBOX,"Clear forbidden part nick list","Are you sure you want to clear the forbidden part nick list ?","Yes","No");
				}
			}
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+80)
	{
		if(response)
		{
            if(strlen(inputtext) < 3 || strlen(inputtext) > MAX_PLAYER_NAME || InvalidNick(inputtext))
			return ShowPlayerDialog(playerid,JDIALOGS+80,DIALOG_STYLE_INPUT,"ADD NEW FORBIDDEN PART NICK","Enter the new forbidden part nick you want to add the forbidden list\n{FF0000}*Invalid name","Add","Back");
            new str[30];
            format(Jfile,sizeof(Jfile), SETTING_PATH, "ForbiddeNickParts");
			format(str, 10, "%s\r\n", inputtext);
			new File:JLlog = fopen(Jfile,io_append);
			fwrite(JLlog,str);
			fclose(JLlog);
			format(Jstring,sizeof(Jstring),"%s has added \"%s\" to forbidden part nicks list",GetName(playerid),inputtext);
			AlertToAdmins(playerid,red,Jstring);
			format(Jstring,sizeof(Jstring),"You have add \"%s\" to forbidden part names list!",inputtext);
			SendClientMessage(playerid, yellow, Jstring );
			LoadBadNickParts();
			return ServSettings(playerid);
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+81)
	{
		if(response)
		{
            format(Jfile,sizeof(Jfile), SETTING_PATH, "ForbiddeNickParts");
            if(!fexist(Jfile)) return ShowPlayerDialog(playerid,JDIALOGS+72,DIALOG_STYLE_MSGBOX,"Error","{FF0000}Could not find the file/Path","Ok","");
            fremove(Jfile);
            new File:JLnew = fopen(Jfile, io_write);
			if(JLnew)
			{
	            fclose(JLnew);
	        }
            ShowPlayerDialog(playerid,JDIALOGS+72,DIALOG_STYLE_MSGBOX,"forbidden part nicks list cleared","You have successfully cleared the forbidden part nick names list","Ok","");
            format(Jstring,sizeof(Jstring),"%s has cleared the forbidden part nicks list",GetName(playerid));
			AlertToAdmins(playerid,red,Jstring);
		}
	}
	if(dialogid == JDIALOGS+82)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 format(Jfile,sizeof(Jfile), SETTING_PATH, "BadWords");
					 if(!fexist(Jfile)) return ShowPlayerDialog(playerid,JDIALOGS+72,DIALOG_STYLE_MSGBOX,"Error","{FF0000}Could not find the file/Path","Ok","");
	                 new temp[30];
	                 strdel(VLstring,0,850);
					 new File:JLfile = fopen(Jfile, io_read);
					 while(fread(JLfile, temp))
					 {
	                    strcat(VLstring, temp);
		             }
					 fclose(JLfile);
					 ShowPlayerDialog(playerid,JDIALOGS+72,DIALOG_STYLE_MSGBOX,"Bad words(List)", VLstring ,"Ok","");
					 if(strlen(VLstring) == 0)ShowPlayerDialog(playerid,JDIALOGS+72,DIALOG_STYLE_MSGBOX,"Bad word(List)", "No bad words found!" ,"Ok","");
					 strdel(VLstring,0,850);
					 return 1;
	            }
	            case 1:
				{
					 ShowPlayerDialog(playerid,JDIALOGS+83,DIALOG_STYLE_INPUT,"ADD NEW BAD WORD","Enter the new bad word you want to add the bad word list","Add","Back");
				}
				case 2:
				{
					 return ShowPlayerDialog(playerid,JDIALOGS+84,DIALOG_STYLE_MSGBOX,"Clear bad word list","Are you sure you want to clear the bad words list ?","Yes","No");
				}
			}
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+83)
	{
		if(response)
		{
            if(strlen(inputtext) < 3 || InvalidNick(inputtext))
			return ShowPlayerDialog(playerid,JDIALOGS+80,DIALOG_STYLE_INPUT,"ADD NEW BAD WORD","Enter the new bad word you want to add the bad word list\n{FF0000}*Invalid word","Add","Back");
            new str[30];
            format(Jfile,sizeof(Jfile), SETTING_PATH, "BadWords");
			format(str, 10, "%s\r\n", inputtext);
			new File:JLlog = fopen(Jfile,io_append);
			fwrite(JLlog,str);
			fclose(JLlog);
			format(Jstring,sizeof(Jstring),"%s has added \"%s\" to bad words list",GetName(playerid),inputtext);
			AlertToAdmins(playerid,red,Jstring);
			format(Jstring,sizeof(Jstring),"You have add \"%s\" to bad words list!",inputtext);
			SendClientMessage(playerid, yellow, Jstring );
			LoadBadNickParts();
			return ServSettings(playerid);
		}
		else return ServSettings(playerid);
	}
	if(dialogid == JDIALOGS+84)
	{
		if(response)
		{
            format(Jfile,sizeof(Jfile), SETTING_PATH, "BadWords");
            if(!fexist(Jfile)) return ShowPlayerDialog(playerid,JDIALOGS+72,DIALOG_STYLE_MSGBOX,"Error","{FF0000}Could not find the file/Path","Ok","");
            fremove(Jfile);
            new File:JLnew = fopen(Jfile, io_write);
			if(JLnew)
			{
	            fclose(JLnew);
	        }
            ShowPlayerDialog(playerid,JDIALOGS+72,DIALOG_STYLE_MSGBOX,"bad words list cleared","You have successfully cleared the bad words list","Ok","");
            format(Jstring,sizeof(Jstring),"%s has cleared the bad words list",GetName(playerid));
			AlertToAdmins(playerid,red,Jstring);
		}
	}
	if(dialogid == JDIALOGS+85)
	{
        if(response)
		{
            switch(listitem)
			{
			    case 0:
		    	{
		           ShowPlayerDialog(playerid,JDIALOGS+86,DIALOG_STYLE_INPUT,"LOAD FILTERSCRIPT","Enter the filterscript name you want to load","Load","Cancel");
		        }
		        case 1:
		    	{
		           ShowPlayerDialog(playerid,JDIALOGS+87,DIALOG_STYLE_INPUT,"RELOAD FILTERSCRIPT","Enter the filterscript name you want to reload","Reload","Cancel");
		        }
		        case 2:
		    	{
		           ShowPlayerDialog(playerid,JDIALOGS+88,DIALOG_STYLE_INPUT,"UNLOAD FILTERSCRIPT","Enter the filterscript name you want to unload","Unload","Cancel");
		        }
		        case 3:
		    	{
		        	ShowPlayerDialog(playerid,JDIALOGS+89,DIALOG_STYLE_INPUT,"CHANGE GAMOMODE","Enter the Gamemode name you want to change","Change","Cancel");
		        }
		        case 4:
		    	{
		           ShowPlayerDialog(playerid,JDIALOGS+90,DIALOG_STYLE_INPUT,"CHANGE GAMEMODE TEXT","Enter the new Gammode text","Change","Cancel");
		        }
		        case 5:
		    	{
		           ShowPlayerDialog(playerid,JDIALOGS+91,DIALOG_STYLE_INPUT,"CHANGE HOSTNAME","Enter the new host name","Change","Cancel");
		        }

		        case 6:
		    	{
		           ShowPlayerDialog(playerid,JDIALOGS+92,DIALOG_STYLE_INPUT,"CHANGE MAP NAME","Enter the new map name","Change","Cancel");
		        }
		        case 7:
		    	{
		           ShowPlayerDialog(playerid,JDIALOGS+93,DIALOG_STYLE_INPUT,"CHANGE WEB SITE","Enter the new web URL","Change","bacl");
		        }
		        case 8:
		    	{
		           ShowPlayerDialog(playerid,JDIALOGS+94,DIALOG_STYLE_INPUT,"BAN IP","Enter the IP below you want to ban","Ban","back");
		        }
		        case 9:
		    	{
		           ShowPlayerDialog(playerid,JDIALOGS+95,DIALOG_STYLE_INPUT,"UNBAN IP:","Enter the IP below you want to unban","unban","back");
		        }
		        case 10:
		    	{
				   ShowPlayerDialog(playerid,JDIALOGS+96,DIALOG_STYLE_INPUT,"BAN PLAYER","Enter the player ID you want to ban","ban","back");
		        }
		        case 11:
		    	{
				   ShowPlayerDialog(playerid,JDIALOGS+97,DIALOG_STYLE_INPUT,"KICK PLAYER:","Enter the player ID you want to kick","kick","back");
		        }
		        case 12:
		    	{
		           SendRconCommand("reloadbans");
				   SendClientMessage(playerid,-1,"{69EE11}SERVER:{69EE11} Bans reloaded!");
		        }
		        case 13:
		    	{
		           SendRconCommand("reloadlog");
				   SendClientMessage(playerid,-1,"{69EE11}SERVER:{69EE11} Server Log reloaded!");
		        }
		        case 14:
		    	{
		           ShowPlayerDialog(playerid,JDIALOGS+98,DIALOG_STYLE_INPUT,"CHANGE GRAVITY:","Enter the new gravity\n(standard gravity is 0.008)","Change","Cancel");
		        }
		        case 15:
		    	{
		           ShowPlayerDialog(playerid,JDIALOGS+99,DIALOG_STYLE_INPUT,"CHANGE WEATHER","Enter the weather ID","Change","back");
		        }
		        case 16:
		    	{
		           ShowPlayerDialog(playerid,JDIALOGS+100,DIALOG_STYLE_INPUT,"CHANGE PASSWORD","Type new RCON password","Change","back");
		        }
		        case 17:
		    	{
		           ShowPlayerDialog(playerid,JDIALOGS+101,DIALOG_STYLE_INPUT,"EXECUTE FILE","Type filename you want to nExecute\n(example: blah.cfg)","nExecute","Cancel");
		        }
		        case 18:
		    	{
		           ShowPlayerDialog(playerid,JDIALOGS+102,DIALOG_STYLE_INPUT,"ECHO MESSAGE","Enter the echo message","Send","back");
		        }
		        case 19:
		    	{
	               strdel(VLstring, 0, 850);
		           GetServerVarAsString("hostname", Jstring, sizeof(Jstring));
				   format(Jstring, sizeof(Jstring), "Host Name: %s\n",Jstring);
				   strcat(VLstring, Jstring, sizeof(VLstring));
				   GetServerVarAsString("gamemode0", Jstring, sizeof(Jstring));
				   format(Jstring, sizeof(Jstring), "gamemode: %s\n",Jstring);
				   strcat(VLstring, Jstring, sizeof(VLstring));
				   GetServerVarAsString("gamemodetext", Jstring, sizeof(Jstring));
				   format(Jstring, sizeof(Jstring), "Gamemode Text: %s\n",Jstring);
				   strcat(VLstring, Jstring, sizeof(VLstring));
				   GetServerVarAsString("mapname", Jstring, sizeof(Jstring));
				   format(Jstring, sizeof(Jstring), "Map Name: %s\n",Jstring);
				   strcat(VLstring, Jstring, sizeof(VLstring));
				   GetServerVarAsString("filterscripts", Jstring, sizeof(Jstring));
				   format(Jstring, sizeof(Jstring), "Filterscripts: %s\n",Jstring);
				   strcat(VLstring, Jstring, sizeof(VLstring));
				   GetServerVarAsString("weburl", Jstring, sizeof(Jstring));
				   format(Jstring, sizeof(Jstring), "Website: %s\n",Jstring);
				   strcat(VLstring, Jstring, sizeof(VLstring));
				   GetServerVarAsString("plugins", Jstring, sizeof(Jstring));
				   format(Jstring, sizeof(Jstring), "plugins: %s\n",Jstring);
				   strcat(VLstring, Jstring, sizeof(VLstring));
				   format(Jstring, sizeof(Jstring), "Max Players: %d\n",GetServerVarAsInt("maxplayers"));
				   strcat(VLstring, Jstring, sizeof(VLstring));
				   format(Jstring, sizeof(Jstring), "Port: %d\n",GetServerVarAsInt("port"));
				   strcat(VLstring, Jstring, sizeof(VLstring));
				   format(Jstring, sizeof(Jstring), "announce: %d\n",GetServerVarAsInt("announce"));
				   strcat(VLstring, Jstring, sizeof(VLstring));
				   format(Jstring, sizeof(Jstring), "Query: %d\n",GetServerVarAsInt("query"));
				   strcat(VLstring, Jstring, sizeof(VLstring));
				   format(Jstring, sizeof(Jstring), "chatlogging: %d\n",GetServerVarAsInt("chatlogging"));
				   strcat(VLstring, Jstring, sizeof(VLstring));
				   format(Jstring, sizeof(Jstring), "Onfoot Rate: %d\n",GetServerVarAsInt("onfoot_rate"));
				   strcat(VLstring, Jstring, sizeof(VLstring));
				   format(Jstring, sizeof(Jstring), "Incar Rate: %d\n",GetServerVarAsInt("incar_rate"));
				   strcat(VLstring, Jstring, sizeof(VLstring));
				   format(Jstring, sizeof(Jstring), "Weapon Rate: %d\n",GetServerVarAsInt("weapon_rate"));
				   strcat(VLstring, Jstring, sizeof(VLstring));
				   format(Jstring, sizeof(Jstring), "Stream Rate: %d\n",GetServerVarAsInt("stream_rate"));
				   strcat(VLstring, Jstring, sizeof(VLstring));
				   format(Jstring, sizeof(Jstring), "maxnpc: %d\n",GetServerVarAsInt("maxnpc"));
				   strcat(VLstring, Jstring, sizeof(VLstring));
				   ShowPlayerDialog(playerid, JDIALOGS+103, DIALOG_STYLE_MSGBOX, "{FFFFFF}Varlist", VLstring, "OK", "");
				   strdel(VLstring, 0, 850);
		        }
		        case 20:
		    	{
				   ShowPlayerDialog(playerid,JDIALOGS+104,DIALOG_STYLE_MSGBOX,"Confirm:","Are you sure you want to restart the server ?","Yes","No");
		        }
		        case 21:
		    	{
				   ShowPlayerDialog(playerid,JDIALOGS+105,DIALOG_STYLE_MSGBOX,"Confirm: (Close the server)","Are you sure you want to CLOSE the server ?","Yes","No");
		        }
	        }
	    }
	}
	if(dialogid == JDIALOGS+86)
	{
	   if(response)
	   {
           if(strlen(inputtext) == 0 ) return ShowPlayerDialog(playerid,JDIALOGS+86,DIALOG_STYLE_INPUT,"LOAD FILTERSCRIPT","Enter the filterscript name you want to load","Load","back");
		   format(Jstring,sizeof(Jstring),"loadfs %s",inputtext);
		   SendRconCommand(Jstring);
		   SendClientMessage(playerid,-1,"{F75009}SERVER: {98FB04}Filterscript loaded!");
		   return JLconsole(playerid);
	   }
	   else return JLconsole(playerid);
	}
	if(dialogid == JDIALOGS+87)
	{
       if(response)
	   {
           if(strlen(inputtext) == 0 ) return ShowPlayerDialog(playerid,JDIALOGS+87,DIALOG_STYLE_INPUT,"RELOAD FILTERSCRIPT","Enter the filterscript name you want to reload","Reload","Cancel");
		   format(Jstring,sizeof(Jstring),"reloadfs %s",inputtext);
		   SendRconCommand(Jstring);
		   SendClientMessage(playerid,-1,"{F75009}SERVER: {22A5DD}Filterscript re-loaded!");
		   return JLconsole(playerid);
	   }
	   else return JLconsole(playerid);
	}
	if(dialogid == JDIALOGS+88)
	{
       if(response)
	   {
           if(strlen(inputtext) == 0 ) return ShowPlayerDialog(playerid,JDIALOGS+88,DIALOG_STYLE_INPUT,"UNLOAD FILTERSCRIPT","Enter the filterscript name you want to unload","Unload","Cancel");
		   format(Jstring,sizeof(Jstring),"unloadfs %s",inputtext);
		   SendRconCommand(Jstring);
		   SendClientMessage(playerid,-1,"{F75009}SERVER: {F79709}Filterscript unloaded!");
		   return JLconsole(playerid);
	   }
       else return JLconsole(playerid);
	}
	if(dialogid == JDIALOGS+89)
	{
	   if(response)
	   {
           if(strlen(inputtext) == 0 ) return ShowPlayerDialog(playerid,JDIALOGS+89,DIALOG_STYLE_INPUT,"CHANGE GAMOMODE","Enter the Gamemode name you want to change","Change","Cancel");
		   format(Jstring,sizeof(Jstring),"changemode %s",inputtext);
		   SendRconCommand(Jstring);
		   SendClientMessage(playerid,-1,"{F75009}SERVER: {98FB04}Gamemode is changing..(will only work if you entered a correct gamemode name)!");
		   return JLconsole(playerid);
	   }
	   else return JLconsole(playerid);
	}
	if(dialogid == JDIALOGS+90)
	{
       if(response)
	   {
           if(strlen(inputtext) == 0 ) return ShowPlayerDialog(playerid,JDIALOGS+90,DIALOG_STYLE_INPUT,"CHANGE GAMEMODE TEXT","Enter the new Gammode text","Change","Cancel");
		   format(Jstring,sizeof(Jstring),"gamemodetext %s",inputtext);
		   SendRconCommand(Jstring);
		   SendClientMessage(playerid,-1,"{F75009}SERVER: {22A5DD}Gamode text is changed!");
		   return JLconsole(playerid);
	   }
	   else return JLconsole(playerid);
	}
	if(dialogid == JDIALOGS+91)
	{
       if(response)
	   {
           if(strlen(inputtext) == 0 ) return ShowPlayerDialog(playerid,JDIALOGS+91,DIALOG_STYLE_INPUT,"CHANGE HOSTNAME","Enter the new host name","Change","Cancel");
		   format(Jstring,sizeof(Jstring),"hostname %s",inputtext);
		   SendRconCommand(Jstring);
		   SendClientMessage(playerid,-1,"{F75009}SERVER: {F79709}Host name is changed!");
		   return JLconsole(playerid);
	   }
       else return JLconsole(playerid);
	}
	if(dialogid == JDIALOGS+92)
	{
       if(response)
	   {
           if(strlen(inputtext) == 0 ) return ShowPlayerDialog(playerid,JDIALOGS+92,DIALOG_STYLE_INPUT,"CHANGE MAP NAME","Enter the new map name","Change","Cancel");
		   format(Jstring,sizeof(Jstring),"mapname %s",inputtext);
		   SendRconCommand(Jstring);
		   SendClientMessage(playerid,-1,"{F75009}SERVER: {F79709}Map name is changed!");
		   return JLconsole(playerid);
	   }
       else return JLconsole(playerid);
	}
	if(dialogid == JDIALOGS+93)
	{
       if(response)
	   {
		   format(Jstring,sizeof(Jstring),"weburl %s",inputtext);
		   SendRconCommand(Jstring);
		   SendClientMessage(playerid,-1,"{F75009}SERVER: {F79709}web url is changed!");
		   return JLconsole(playerid);
	   }
       else return JLconsole(playerid);
	}
	if(dialogid == JDIALOGS+94)
	{
       if(response)
	   {
           if(IsNumeric(inputtext) || strlen(inputtext) > 20 || strlen(inputtext) < 5) return ShowPlayerDialog(playerid,JDIALOGS+94,DIALOG_STYLE_INPUT,"BAN IP","Enter the IP you want to ban\n{F70909}*Please enter a real IP","Ban","back");
		   format(Jstring,sizeof(Jstring),"banip %s",inputtext);
		   SendRconCommand(Jstring);
		   format(Jstring,sizeof(Jstring),"{F70909}SERVER: {E6D11A}IP {F23A0D}%s{E6D11A} has been banned!",inputtext);
		   SendClientMessage(playerid,-1,Jstring);
		   return JLconsole(playerid);
	   }
       else return JLconsole(playerid);
	}
	if(dialogid == JDIALOGS+95)
	{
       if(response)
	   {
           if(IsNumeric(inputtext) || strlen(inputtext) > 20 || strlen(inputtext) < 5) return ShowPlayerDialog(playerid,JDIALOGS+95,DIALOG_STYLE_INPUT,"UNBAN IP","Enter the IP you want to unban\n{F70909}*Please enter a real IP","unban","back");
		   format(Jstring,sizeof(Jstring),"unbanip %s",inputtext);
		   SendRconCommand(Jstring);
		   format(Jstring,sizeof(Jstring),"{68BB44}SERVER: {E6D11A}IP {F23A0D}%s{E6D11A} has been unbanned!",inputtext);
		   SendClientMessage(playerid,-1,Jstring);
		   return JLconsole(playerid);
	   }
       else return JLconsole(playerid);
	}
	if(dialogid == JDIALOGS+96)
	{
       if(response)
	   {
           new id;
           if(sscanf(inputtext, "i", id)) return ShowPlayerDialog(playerid,JDIALOGS+96,DIALOG_STYLE_INPUT,"BAN PLAYER","Enter the player ID you want ot ban\n{FB0404}*Playerid is not connected or invalid ID","ban","back");
		   format(Jstring,sizeof(Jstring),"ban %d",id);
		   SendRconCommand(Jstring);
		   format(Jstring,sizeof(Jstring),"{EA4015}SERVER: {E6D11A}ID{F23A0D}%d{E6D11A} has been banned!",id);
		   SendClientMessage(playerid,-1,Jstring);
		   return JLconsole(playerid);
	   }
       else return JLconsole(playerid);
	}
	if(dialogid == JDIALOGS+97)
	{
       if(response)
	   {
           new id;
           if(sscanf(inputtext, "i", id)) return ShowPlayerDialog(playerid,JDIALOGS+97,DIALOG_STYLE_INPUT,"KICK PLAYER","Enter the player ID you want to kick\n{FB0404}*You entered playerid is not connected or invalid ID","kick","back");
		   format(Jstring,sizeof(Jstring),"kick %d",id);
		   SendRconCommand(Jstring);
		   format(Jstring,sizeof(Jstring),"SERVER: {E6D11A}ID {F23A0D}%d{E6D11A} has been kicked!",id);
		   SendClientMessage(playerid,-1,Jstring);
		   return JLconsole(playerid);
	   }
       else return JLconsole(playerid);
	}
	if(dialogid == JDIALOGS+98)
	{
       if(response)
	   {
           new Float:gravity;
           if(sscanf(inputtext, "f", gravity)) return ShowPlayerDialog(playerid,JDIALOGS+98,DIALOG_STYLE_INPUT,"CHANGE GRAVITY","Enter the new Gravity","Change","Cancel");
           SetGravity(gravity);
		   format(Jstring,sizeof(Jstring),"SERVER: {E6D11A}Server Gravity is changed to '%0.3f'",gravity);
		   SendClientMessage(playerid,-1,Jstring);
		   return JLconsole(playerid);
	   }
       else return JLconsole(playerid);
	}
	if(dialogid == JDIALOGS+99)
	{
       if(response)
	   {
           new wid;
           if(sscanf(inputtext, "i", wid)) return ShowPlayerDialog(playerid,JDIALOGS+99,DIALOG_STYLE_INPUT,"CHANGE WEATHER","Enter the weather ID","Change","back");
		   format(Jstring,sizeof(Jstring),"weather %d",wid);
		   SendRconCommand(Jstring);
		   format(Jstring,sizeof(Jstring),"SERVER: {E6D11A}Weather is changed to '%d'",wid);
		   SendClientMessage(playerid,-1,Jstring);
		   return JLconsole(playerid);
	   }
       else return JLconsole(playerid);
	}
	if(dialogid == JDIALOGS+100)
	{
       if(response)
	   {
           if(strlen(inputtext) == 0) return ShowPlayerDialog(playerid,JDIALOGS+100,DIALOG_STYLE_INPUT,"CHANGE PASSWORD","Type the new RCON password\n{FB0404}*password can NOT be blank","Change","back");
		   format(Jstring,sizeof(Jstring),"rcon_password %s",inputtext);
		   SendRconCommand(Jstring);
		   format(Jstring,sizeof(Jstring),"SERVER: {E6D11A}RCON password is {EA4015}changed to \"%s\"",inputtext);
		   SendClientMessage(playerid,-1,Jstring);
		   return JLconsole(playerid);
	   }
       else return JLconsole(playerid);
	}
	if(dialogid == JDIALOGS+101)
	{
       if(response)
	   {
           if(strlen(inputtext) == 0) return ShowPlayerDialog(playerid,JDIALOGS+101,DIALOG_STYLE_INPUT,"EXECUTE FILE","Type filename you want to nExecute\n(example: blah.cfg)","nExecute","Cancel");
		   format(Jstring,sizeof(Jstring),"exec %s",inputtext);
		   SendRconCommand(Jstring);
		   format(Jstring,sizeof(Jstring),"SERVER: {E6D11A}File Executed (%s)",inputtext);
		   SendClientMessage(playerid,-1,Jstring);
		   return JLconsole(playerid);
	   }
       else return JLconsole(playerid);
	}
	if(dialogid == JDIALOGS+102)
	{
       if(response)
	   {
           if(strlen(inputtext) == 0) return ShowPlayerDialog(playerid,JDIALOGS+102,DIALOG_STYLE_INPUT,"ECHO MESSAGE","Enter the echo message","Send","back");
		   format(Jstring,sizeof(Jstring),"echo %s",inputtext);
		   SendRconCommand(Jstring);
		   format(Jstring,sizeof(Jstring),"SERVER: {E6D11A}echo message has been sent (%s)",inputtext);
		   SendClientMessage(playerid,-1,Jstring);
		   return JLconsole(playerid);
	   }
       else return JLconsole(playerid);
	}
	if(dialogid == JDIALOGS+104)
	{
       if(response)
	   {
           format(Jstring,sizeof(Jstring),"%s has restarted the Server!",GetName(playerid));
		   SendClientMessageToAll(red,Jstring);
		   SendClientMessage(playerid,-1,"{F75009}SERVER: {98FB04}Gamemode is restarting..");
		   SendRconCommand("gmx");
		   return JLconsole(playerid);
	   }
       else return JLconsole(playerid);
	}
	if(dialogid == JDIALOGS+105)
	{
       if(response)
	   {
		   format(Jstring,sizeof(Jstring),"%s has closed the Server!",GetName(playerid));
		   SendClientMessageToAll(red,Jstring);
		   SendRconCommand("exit");
		   return JLconsole(playerid);
	   }
       else return JLconsole(playerid);
	}
	if(dialogid == JDIALOGS+106)
	{
       if(response)
	   {
		   return ShowPlayerDialog(playerid,JDIALOGS+107,DIALOG_STYLE_MSGBOX,"Weapon id(s)",
		   "{80FFFF}ID 22  -  9mm\nID 23  -  Silenced 9mm\nID 24  -  Desert Eagle\nID 25  -  Shotgun\nID 26  -  Sawnoff Shotgun\nID 27  -  Combat Shotgun\nID 28  -  Micro SMG(Uzi)\nID 29  -  MP5\nID 30  -  AK-47\nID 31  -  M4\nID 32  -  Tec-9\nID 33  -  Country Rifle\nID 34  -  Sniper Rifle\nID 35  -  RPG\nID 36  -  HS Rocket"
		   ,"Next","");
	   }
	}
	if(dialogid == JDIALOGS+107)
	{
       if(response)
	   {
           return ShowPlayerDialog(playerid,JDIALOGS+108,DIALOG_STYLE_MSGBOX,"Weapon id(s)",
		   "{80FFFF}ID 37  -  Flamethrower\nID 38  -  Minigun\nID 39  -  Satchel Charge\nID 40  -  Detonator\nID 41  -  Spraycan\nID 42  -  Fire Extinguisher\nID 43  -  Camera\nID 44  -  Night Vis Goggles\nID 45  -  Thermal Goggles\nID 46  -  Parachute","Ok","");
	   }
	}
	if(dialogid == JDIALOGS+112)
	{
		if(response)
		{
            switch(listitem)
			{
	      		case 0:
				{
	                 if(pInfo[playerid][pLevel] >= 1)
	                 return ShowLevelCommands(playerid,1);
	            }
	            case 1:
				{
	                 if(pInfo[playerid][pLevel] >= 2)
				     return ShowLevelCommands(playerid,2);
				}
				case 2:
				{
	                 if(pInfo[playerid][pLevel] >= 3)
					 return ShowLevelCommands(playerid,3);
				}
				case 3:
				{
	                 if(pInfo[playerid][pLevel] >= 4)
					 return ShowLevelCommands(playerid,4);
				}
				case 4:
				{
	                 if(pInfo[playerid][pLevel] >= 5)
					 return ShowLevelCommands(playerid,5);
				}
			}
		}
	}
	if(dialogid == JDIALOGS+111)
	{
       if(response)
	   {
		   return ShowPlayerDialog(playerid,JDIALOGS+112,DIALOG_STYLE_LIST,"J.L. Admin System V1.0 Copyright(c), JewelL",""LEVEL_1_COLOR"Level 1\n"LEVEL_2_COLOR"Level 2\n"LEVEL_3_COLOR"Level 3\n"LEVEL_4_COLOR"Level 4\n"LEVEL_5_COLOR"Level 5","Select","Close");
	   }
	}
	if(dialogid == JDIALOGS+114)
	{
       if(response)
	   {
		   for(new i = 0; i <= TeleCount; i++)
		   {
	           if(listitem == i)
	           {
                    if(IsPlayerInAnyVehicle(playerid))
					{
					    
					    SetVehiclePos(GetPlayerVehicleID(playerid), TeleCoords[i][0], TeleCoords[i][1], TeleCoords[i][2]);
						LinkVehicleToInterior(GetPlayerVehicleID(playerid), Teleinfo[i][1]);
						SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), Teleinfo[i][0]);
						SetPlayerVirtualWorld(playerid, Teleinfo[i][0]);
						SetPlayerInterior(playerid, Teleinfo[i][1]);
					}
					else
					{
                        SetPlayerPos(playerid, TeleCoords[i][0], TeleCoords[i][1], TeleCoords[i][2]);
					    SetPlayerInterior(playerid, Teleinfo[i][1]);
					    SetPlayerVirtualWorld(playerid, Teleinfo[i][0]);
					}
					format(string,sizeof(string),"~G~%s",TeleName[i]);
					GameTextForPlayerEx(playerid,string,2000,5);
					format(string,sizeof(string),"You have been successfully teleported to \"%s\"",TeleName[i]);
					SendClientMessage(i,yellow,string);
					break;
	           }
		   }
	   }
	}
	if(dialogid == JDIALOGS+115)
	{
       if(response)
	   {
            if(strlen(inputtext) < 3 || strlen(inputtext) > 20) return ShowPlayerDialog(playerid, JDIALOGS+115, DIALOG_STYLE_INPUT, "Create Teleport","Enter the new teleport name\n{FF0000}*Name length must be between 3 - 20 characters", "Create", "Close");
		    new file[100],name[30],SName[40];
			if(sscanf(inputtext, "s[30]",name)) return ShowPlayerDialog(playerid, JDIALOGS+115, DIALOG_STYLE_INPUT, "Create Teleport","Enter the new teleport name\n{FF0000}*Name length must be between 3 - 20 characters", "Create", "Close");
			new Float:X, Float:Y, Float:Z;
			GetPlayerPos(playerid, X, Y, Z);
			SName = name;
			if(strfind(SName," ",true) != -1 )
	        {
	            new i = 0;
			    while (SName[i])
			    {
			        if (SName[i] == ' ')
					SName[i] = '_';
			        i++;
			    }
	        }
			format(string,sizeof(string),"%s %f %f %f %d %d\r\n",SName, X, Y, Z, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
			format(file, 100, SETTING_PATH, "Teleports");
			new File:JLlog = fopen(file,io_append);
			fwrite(JLlog,string);
			fclose(JLlog);
			TeleName[TeleCount]      = name;
			TeleCoords[TeleCount][0] = X;
			TeleCoords[TeleCount][1] = Y;
			TeleCoords[TeleCount][2] = Z;
			Teleinfo[TeleCount][0]   = GetPlayerVirtualWorld(playerid);
			Teleinfo[TeleCount][1]   = GetPlayerInterior(playerid);
			TeleCount++;
			format(string,sizeof(string),"Teleport created | Name: %s | Positon - X:%0.3f Y: %0.3f Z: %0.3f | Virtual World: %d | Interior: %d",name, X, Y, Z, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
			SendClientMessage(playerid,yellow,string);
	   }
	}
	if(dialogid == JDIALOGS+116)
	{
       if(response)
	   {
		   return ShowPlayerDialog(playerid, JDIALOGS+115, DIALOG_STYLE_INPUT, "Create Teleport", "Enter the new teleport name", "Create", "Close");
	   }
	}
	if(dialogid == JDIALOGS+117)
	{
		if(response)
		{
            new id;
	        id = pInfo[playerid][Clicked];
	        if(strlen(inputtext) < 2 || strlen(inputtext) > 80) return ShowPlayerDialog(playerid,JDIALOGS+117,DIALOG_STYLE_INPUT,"Warn","Enter the reason:\n{FF0000}*Please enter a valid reason","Kick","Cancel");
	        if(id == playerid) return SendClientMessage(playerid, red, "You can not warn yourself!");
	        if(IsPlayerConnected(id))
			{
			    pInfo[id][Warns]++;
			    CommandToAdmins(playerid,"warn");
			    if(pInfo[id][Warns] > 2)
				{
	                 format(Jstring,sizeof(Jstring),"Administrator '%s' has kicked '%s' for %s | Warnings: %d/%d |",GetName(playerid),GetName(id),inputtext,pInfo[id][Warns],MAX_WARNS);
					 SendClientMessageToAll(red,Jstring);
				     SetTimerEx("KickPlayer",200,false,"d", id);
				     return 1;
				}
				format(Jstring,sizeof(Jstring),"Administrator '%s' has given '%s' a Warning | Reason: %s |Warnings: %d/%d|",GetName(playerid),GetName(id),inputtext,pInfo[id][Warns],MAX_WARNS);
				SendClientMessageToAll(red,Jstring);
				GameTextForPlayerEx(id,"~R~Warning", 5000, 3);
				return 1;
			}
			else return ShowMessage(playerid, red, 2);
		}
	}
	return 0;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
    if(pInfo[playerid][Registered] == 1 && pInfo[playerid][Logged] == 1)
    {
       pInfo[playerid][Clicked] = clickedplayerid;
       if(pInfo[playerid][pLevel] >= 2)
	   ShowPlayerDialog(playerid,JDIALOGS+5,DIALOG_STYLE_LIST,"Options","Private Message\nStatus\nInformations\nReport\nSpectate\nGoto\nAka\nMute\nUnmute\nTrack\nWarn\nKick\nBan","Ok","Cancel");
	   else ShowPlayerDialog(playerid,JDIALOGS+5,DIALOG_STYLE_LIST,"Options","Private Message\nStatus\nInformations\nReport","Ok","Cancel");
	   return 1;
	}
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    #if LoginTextDraw == true
    if(_:clickedid != INVALID_TEXT_DRAW)
    {
        if(clickedid == TEXT_PASSWORD)
        {
            format(Jstring, sizeof(Jstring),"Account \"%s\"\nPlease enter your password to login", GetName(playerid));
			ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,"Account Access", Jstring, "Login", "Quit");
            return 1;
        }
        if(clickedid == TEXT_REGISTER)
        {
			ShowPlayerDialog(playerid, JDIALOGS+1, DIALOG_STYLE_INPUT,"Register an account!", "Enter your new nick name to register an account", "Next", "No Thanks");
	        return 1;
        }
	}
	#endif
    return 1;
}

stock GetName(playerid)
{
	new JName[MAX_PLAYER_NAME];
	GetPlayerName(playerid,JName,MAX_PLAYER_NAME);
	return JName;
}

SaveStatus(playerid)
{
    new Jfile[100],str[60],year,month,day,hour,mins,sec;
    new seconds = gettime() - pInfo[playerid][ConnectedTime] + pInfo[playerid][TotalSecs];
    getdate(year, month, day);
    gettime(hour,mins,sec);
    format(str, 60,"%d/%d/%d at %d:%d:%d", day,month,year,hour,mins,sec);
	format(Jfile, 100, ACCOUNTS_PATH, GetName(playerid));
	new INI:ACCOUNT = INI_Open(Jfile);
	INI_WriteInt(ACCOUNT, "Score", GetPlayerScore(playerid));
	INI_WriteInt(ACCOUNT, "Cash", GetPlayerMoney(playerid));
	INI_WriteInt(ACCOUNT, "Kills", pInfo[playerid][Kills]);
	INI_WriteInt(ACCOUNT, "Deaths", pInfo[playerid][Deaths]);
	INI_WriteInt(ACCOUNT, "TotalSeconds", seconds);
	INI_WriteString(ACCOUNT, "TotalSpentTime", ConvertTime(seconds,mins,hour,day));
	INI_WriteString(ACCOUNT, "LastSeen", str);
	INI_Close(ACCOUNT);
}

ResetVariables(playerid)
{
    pInfo[playerid][Registered]    = 0;
    pInfo[playerid][Logged]        = 0;
    pInfo[playerid][pLevel]        = 0;
    pInfo[playerid][Kills]         = 0;
    pInfo[playerid][Deaths]        = 0;
    pInfo[playerid][Jailed]        = 0;
    pInfo[playerid][Muted]         = 0;
    pInfo[playerid][GodMode]       = 0;
    pInfo[playerid][Frozen]        = 0;
    pInfo[playerid][Donator]       = 0;
    pInfo[playerid][Banned]        = 0;
    pInfo[playerid][Score]         = 0;
	pInfo[playerid][Cash]          = 0;
	pInfo[playerid][Spawned]       = 0;
	pInfo[playerid][Locked]        = 0;
    pInfo[playerid][LoginAttempts] = 0;
    pInfo[playerid][PingExceeds]   = 0;
    pInfo[playerid][Skin]          = 0;
    pInfo[playerid][VGod]          = 0;
    pInfo[playerid][pAutoLogin]    = 0;
    pInfo[playerid][Spec]          = 0;
    pInfo[playerid][Warns]         = 0;
    pInfo[playerid][Hidden]        = 0;
    pInfo[playerid][AHide]         = 0;
    pInfo[playerid][NameTagHidden] = 0;
    pInfo[playerid][Clicked]       = -1;
    pInfo[playerid][SpamWarns]     = 0;
    pInfo[playerid][VWorld]        = 0;
    pInfo[playerid][AntiCheatWarns]= 0;
    pInfo[playerid][TempBan]       = 0;
    pInfo[playerid][TotalSecs]     = 0;
    pInfo[playerid][SpawnedCars]   = 0;
    pInfo[playerid][LastSpawnedCar]= -1;
    SetPVarString(playerid,"ChatMsg","|None|");
    SetPVarInt(playerid, "OldScore", 0);
    SetPVarInt(playerid, "OldCash", 0);
    SetPVarInt(playerid,"Interior", 0);
    SetPVarInt(playerid, "world", 0);
    IsPaused[playerid]             = 0;
    IsWorldChanged[playerid]       = 0;
    pInfo[playerid][ConnectedTime] = gettime();
    ResetPlayerMoney(playerid);
    SetPlayerScore(playerid,0);
    #if MoveSystem == true
    pInfo[playerid][Move]          = 0;
    #endif
    
}

public GetAkaLog(name[], value[])
{
    INI_String(playerIP,aka,256);
    return 1;
}

public GetPlayerInfo(playerid, name[], value[])
{
    INI_String("LastLoggedIP", pInfo[playerid][IP], 16);
    INI_Int("Autologin", pInfo[playerid][pAutoLogin]);
    INI_Int("Banned", pInfo[playerid][Banned]);
    INI_Int("TempBan", pInfo[playerid][TempBan]);
    return 1;
}

public GetPassword(playerid, name[], value[])
{
    INI_String("Password", pInfo[playerid][Password],130);
    return 1;
}

public LoginPlayer(playerid, name[], value[])
{
    INI_Int("Level", pInfo[playerid][pLevel]);
    INI_Int("Donator", pInfo[playerid][Donator]);
    INI_Int("Banned", pInfo[playerid][Banned]);
    INI_Int("Kills", pInfo[playerid][Kills]);
    INI_Int("Deaths", pInfo[playerid][Deaths]);
    INI_Int("Muted", pInfo[playerid][Muted]);
    INI_Int("Score", pInfo[playerid][Score]);
    INI_Int("Cash", pInfo[playerid][Cash]);
    INI_Int("Skin", pInfo[playerid][Skin]);
    INI_String("LastLoggedIP", pInfo[playerid][IP], 16);
    INI_Int("TotalSeconds", pInfo[playerid][TotalSecs]);
    return 1;
}

public LoadServerSetttings(name[], value[])
{
    INI_Int("AutoLogin", AutoLogin);
    INI_Int("DetectPausers", DetectPausers);
    INI_Int("MustRegister", MustRegister);
    INI_Int("MaxPing", MaxPing);
    INI_Int("AntiSpam", AntiSpam);
    INI_Int("PmDialog", PmDialog);
    INI_Int("AntiWeaponHack", AntiWeaponHack);
    INI_Int("MaxLevels", MaxAdminLevel);
    INI_Int("ForbiddenNamesKick", ForbiddenNamesKick);
    INI_Int("PartNamesKick", KickPartNicks);
    INI_Int("AntiBadWords", AntiForbiddenWords);
    INI_Int("AntiAdvertisements", AntiAdv);
    INI_Int("AntiBanEvade", AntiBanEvade);
    INI_Int("AdminImmunity", AdminImmunity);
    INI_Int("AdminReadPms", ShowPmstoAdmins);
    INI_Int("AdminReadCmds", ReadCommands);
    INI_Int("AntiCheatbans", AntiCheatBans);
    INI_Int("AllowChangeName", AllowChangeNick);
    return 1;
}

public AccountsEditor(name[], value[])
{
    INI_String("RegisteredOn", RegisteredDate, 50);
    INI_String("RegisteredIP", RegisteredIP, 16);
    INI_String("LastLoggedIP", LastLoggedIP, 16);
    INI_Int("Level", AdminLevel);
    INI_Int("Donator", DonatorLevel);
    INI_Int("Banned", AccBanned);
    INI_Int("Muted", AccMuted);
    INI_Int("Score", AccScore);
    INI_Int("Cash", AccCash);
    INI_Int("Kills", AccKills);
    INI_Int("Deaths", AccDeaths);
    INI_Int("Skin", AccSkin);
    INI_Int("Autologin", AccAutologin);
    INI_Int("TotalSeconds", AccTotalSecs);
    INI_String("LastSeen", LastSeen, 50);
    INI_String("TotalSpentTime", AccPlayedTime, 50);
    return 1;
}

CMD:register(playerid,params[])
{
	if(pInfo[playerid][Logged] == 1) return SendClientMessage(playerid,red,"You are already registered and logged in!");
	format(Jstring, 128, ACCOUNTS_PATH, GetName(playerid));
	if(fexist(Jstring))
    {
        SendClientMessage(playerid,red,"Error - This nick name is already in use!");
		SendClientMessage(playerid,lighterblue,"Please '/login' to access the account");
		return 1;
    }
	ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,"Register an account!", "{00FFFF}Please Enter the password to register an account:", "Register", "No Thanks");
	return 1;
}

CMD:login(playerid,params[])
{
    if (pInfo[playerid][Logged] == 1) return SendClientMessage(playerid,lighterblue,"You are already logged in");
    format(Jstring, 128, ACCOUNTS_PATH, GetName(playerid));
    if(!fexist(Jstring))
    {
        SendClientMessage(playerid,red,"Nick name isn't registered!");
		SendClientMessage(playerid,lighterblue,"Please '/register' to create your account");
		return 1;
    }
	format(Jstring, sizeof(Jstring),"Account \"%s\"\nPlease enter the password to login", GetName(playerid));
	ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,"Account Access", Jstring, "Login", "Quit");
	return 1;
}

CMD:admins(playerid,params[])
{
   new IsOnline = 0;
   strdel(JLstring,0,500);
   foreach(Player, i)
   {
      if (pInfo[i][pLevel] >= 1 && pInfo[i][AHide] == 0)
	  {
 		      switch(pInfo[i][pLevel])
              {
			      case 1: {
				  LevelName = ADMIN_LEVEL_1;
				  LevelColor = LEVEL_1_COLOR;
				  }
				  case 2: {
				  LevelName = ADMIN_LEVEL_2;
				  LevelColor = LEVEL_2_COLOR;
				  }
				  case 3: {
				  LevelName = ADMIN_LEVEL_4;
				  LevelColor = LEVEL_3_COLOR;
				  }
				  case 4: {
				  LevelName = ADMIN_LEVEL_3;
				  LevelColor = LEVEL_4_COLOR;
				  }
				  case 5: {
				  LevelName = ADMIN_LEVEL_5;
				  LevelColor = LEVEL_5_COLOR;
				  }
				  default: {
				  LevelName = ADMIN_LEVEL_6;
				  LevelColor = LEVEL_6_COLOR;
				  }
	          }
	          if (IsPlayerAdmin(i)) format(Jstring, 128, "{FF0000}%s - Level: %d (RCON Administrator)\n",GetName(i),pInfo[i][pLevel]);
	          else format(Jstring, 128, "%s%s - Level: %d (%s)\n",LevelColor,GetName(i),pInfo[i][pLevel],LevelName);
			  strcat(JLstring, Jstring, sizeof(JLstring));
			  IsOnline++;
		}
   }
   if (IsOnline == 0)
   ShowPlayerDialog(playerid,JDIALOGS+165,DIALOG_STYLE_MSGBOX,"{00FFE6}Online admins","{FF0000}No admins are online!" ,"OK","");
   else
   {
       if(IsOnline == 1) ShowPlayerDialog(playerid,JDIALOGS+165,DIALOG_STYLE_MSGBOX,"{00FFE6}1 admin online",JLstring ,"OK","");
	   else format(Jstring, 128, "{00FFE6}%d admins online",IsOnline), ShowPlayerDialog(playerid,JDIALOGS+165,DIALOG_STYLE_MSGBOX,Jstring,JLstring ,"OK","");
   }
   strdel(JLstring,0,500);
   return 1;
}

CMD:settemplevel(playerid,params[])
{
   if(pInfo[playerid][pLevel] >= 4 || IsPlayerAdmin(playerid))
   {
	    new id,level,year,month,day,hour,minute,second;
	    if(sscanf(params, "ui", id, level)) return
		SendClientMessage(playerid, 0xFFFF00C8, "Usage: /SetTemplevel <PlayerID> <Level>") ;
		if(level < 0 ) return SendClientMessage(playerid,red,"Invalid level(level must be greater than -1)");
        if(IsPlayerConnected(id))
		{
           if(level == pInfo[id][pLevel])
		   return SendClientMessage(playerid,red,"Player is already in this level!");
		   if(level > MaxAdminLevel)
		   {
		   		format(Jstring,sizeof(Jstring),"Error: Maximum admin level is %d",MaxAdminLevel); return SendClientMessage(playerid,red,Jstring);
		   }
		   getdate(year, month, day);
		   gettime(hour,minute,second);
		   CommandToAdmins(playerid,"settemplevel");
		   switch(level)
		   {
              case 0: LevelName = "Player Status";
              case 1: LevelName = ADMIN_LEVEL_1;
			  case 2: LevelName = ADMIN_LEVEL_2;
			  case 3: LevelName = ADMIN_LEVEL_4;
			  case 4: LevelName = ADMIN_LEVEL_3;
			  case 5: LevelName = ADMIN_LEVEL_5;
			  default: LevelName = ADMIN_LEVEL_6;
           }
		   format(Jstring,sizeof(Jstring),"You have given '%s' Temporarily level: %d (%s) , Date: %d/%d/%d at %d:%d:%d ",GetName(id), level, LevelName, day, month, year ,hour, minute, second);
		   SendClientMessage(playerid,blue,Jstring);
		   if(level> pInfo[id][pLevel])
		   format(Jstring,sizeof(Jstring),"Administrator %s has set you Temporarily level: %d (%s) <Temporarily Promoted on %d/%d/%d at %d:%d:%d>",GetName(playerid), level, LevelName ,day, month, year,hour, minute, second),GameTextForPlayerEx(id,"~B~Temporarily!~N~~G~Promoted", 2000, 3);
		   else format(Jstring,sizeof(Jstring),"Administrator %s has set you Temporarily level: %d <Temporarily Demoted on %d/%d/%d at %d:%d:%d>",GetName(playerid), level,day, month, year,hour, minute, second),GameTextForPlayerEx(id,"~R~Temporarily~N~Demoted", 2000, 3);
		   SendClientMessage(id,yellow,Jstring);
		   format(Jstring,sizeof(Jstring),"%s has Temporarily changed %s's level from %d to %d (%s)",GetName(playerid),GetName(id),pInfo[id][pLevel], level, LevelName);
		   WriteToLog(Jstring,"TempLevelChanges");
		   pInfo[id][pLevel] = level;
           return 1;
		}
		else return ShowMessage(playerid, red, 2);
   }
   else return ShowMessage(playerid, red, 1);
}

CMD:setlevel(playerid,params[])
{
   if(pInfo[playerid][pLevel] >= 5 || IsPlayerAdmin(playerid))
   {
	    new id,level,Jfile[100],year,month,day,hour,minute,second;
	    if(sscanf(params, "ui", id, level)) return
		SendClientMessage(playerid, 0xFFFF00C8, "Usage: /Setlevel <PlayerID> <Level>") ;
		if(level < 0) return SendClientMessage(playerid,red,"Invalid level(level must be greater than -1)");
        if(IsPlayerConnected(id))
		{
           if(level == pInfo[id][pLevel])
		   return SendClientMessage(playerid,red,"Player is already in this level!");
		   if(level > MaxAdminLevel)
		   {
		   		format(Jstring,sizeof(Jstring),"Error: Maximum admin level is %d",MaxAdminLevel); return SendClientMessage(playerid,red,Jstring);
		   }
		   if(pInfo[id][Logged] == 0) return SendClientMessage(playerid,red,"Error: This player is not loggedIn or not registered!");
		   CommandToAdmins(playerid,"setlevel");
		   getdate(year, month, day);
		   gettime(hour,minute,second);
		   switch(level)
		   {
              case 0: LevelName = "Player Status";
              case 1: LevelName = ADMIN_LEVEL_1;
			  case 2: LevelName = ADMIN_LEVEL_2;
			  case 3: LevelName = ADMIN_LEVEL_4;
			  case 4: LevelName = ADMIN_LEVEL_3;
			  case 5: LevelName = ADMIN_LEVEL_5;
			  default: LevelName = ADMIN_LEVEL_6;
           }
		   format(Jstring,sizeof(Jstring),"You have given %s level: %d (%s) , Date: %d/%d/%d at %d:%d:%d",GetName(id), level, LevelName, day, month, year ,hour, minute, second);
		   SendClientMessage(playerid,blue,Jstring);
		   if(level> pInfo[id][pLevel])
		   {
			   format(Jstring,sizeof(Jstring),"Administrator %s has given you administrator level: %d (%s) <Promoted on %d/%d/%d at %d:%d:%d>",GetName(playerid), level, LevelName ,day, month, year,hour, minute, second),GameTextForPlayerEx(id,"~B~congratulations!~N~~G~Promoted", 2000, 3);
			   SendClientMessage(id,lighterblue,Jstring);
			   format(Jstring,sizeof(Jstring),"[PROMOTED] %s has changed %s's level from %d to %d (%s)",GetName(playerid),GetName(id),pInfo[id][pLevel], level, LevelName);
			   WriteToLog(Jstring,"LevelChanges");
		   }
		   else
		   {
		   format(Jstring,sizeof(Jstring),"Administrator %s has set you level: %d <Demoted on %d/%d/%d at %d:%d:%d>",GetName(playerid), level,day, month, year,hour, minute, second),GameTextForPlayerEx(id,"~R~Demoted", 2000, 3);
		   SendClientMessage(id,red,Jstring);
		   format(Jstring,sizeof(Jstring),"[DEMOTED] %s has changed %s's level from %d to %d (%s)",GetName(playerid),GetName(id),pInfo[id][pLevel], level, LevelName);
		   WriteToLog(Jstring,"LevelChanges");
		   }
		   pInfo[id][pLevel] = level;
		   format(Jfile, 100, ACCOUNTS_PATH, GetName(id));
		   new INI:ACCOUNT = INI_Open(Jfile);
		   INI_WriteInt(ACCOUNT, "Level", pInfo[id][pLevel]);
		   INI_Close(ACCOUNT);
           return 1;
		}
		else return ShowMessage(playerid, red, 2);
   }
   else return ShowMessage(playerid, red, 1);
}

CMD:makeadmin(playerid,params[])
{
   return cmd_setlevel(playerid,params);
}

CMD:settempvip(playerid,params[])
{
   if(pInfo[playerid][pLevel] >= 3 || IsPlayerAdmin(playerid))
   {
	    new id,level;
	    if(sscanf(params, "ui", id, level)) return
		SendClientMessage(playerid, 0xFFFF00C8, "Usage: /SetTempVip <PlayerID> <Level>") ;
		if(level < 0 ) return SendClientMessage(playerid,red,"Invalid level(level must be greater than -1)");
        if(IsPlayerConnected(id))
		{
           if(level == pInfo[id][Donator])
		   return SendClientMessage(playerid,red,"Player is already in this V.I.P level!");
		   if(level > MaxVipLevel)
		   {
		   		format(Jstring,sizeof(Jstring),"Error: Maximum V.I.P level is %d",MaxVipLevel);
		        return SendClientMessage(playerid,red,Jstring);
		   }
		   CommandToAdmins(playerid,"SetTempVip");
		   switch(level)
		   {
              case 0: LevelName = "Player Status";
              case 1: LevelName = VIP_LEVEL_1;
			  case 2: LevelName = VIP_LEVEL_2;
			  default: LevelName = VIP_LEVEL_3;
           }
		   format(Jstring,sizeof(Jstring),"You have given '%s' Temporarily V.I.P level: %d (%s)",GetName(id), level, LevelName);
		   SendClientMessage(playerid,blue,Jstring);
		   if(level> pInfo[id][Donator])
		   format(Jstring,sizeof(Jstring),"Administrator %s has set you Temporarily V.I.P level: %d (%s)",GetName(playerid), level, LevelName),GameTextForPlayerEx(id,"~B~congratulations!", 2000, 3);
		   else format(Jstring,sizeof(Jstring),"Administrator %s has set you Temporarily V.I.P level: %d",GetName(playerid), level);
		   SendClientMessage(id,yellow,Jstring);
		   format(Jstring,sizeof(Jstring),"%s has Temporarily changed %s's V.I.P level from %d to %d (%s)",GetName(playerid),GetName(id),pInfo[id][Donator], level, LevelName);
		   WriteToLog(Jstring,"VipLevels");
		   pInfo[id][Donator] = level;
           return 1;
		}
		else return ShowMessage(playerid, red, 2);
   }
   else return ShowMessage(playerid, red, 1);
}

CMD:setvip(playerid,params[])
{
   if(pInfo[playerid][pLevel] >= 4 || IsPlayerAdmin(playerid))
   {
	    new id,level,Jfile[100],year,month,day,hour,minute,second;
	    if(sscanf(params, "ui", id, level)) return
		SendClientMessage(playerid, 0xFFFF00C8, "Usage: /SetVip <PlayerID> <Level>") ;
		if(level < 0) return SendClientMessage(playerid,red,"Invalid level(level must be greater than -1)");
        if(IsPlayerConnected(id))
		{
           if(level == pInfo[id][Donator])
		   return SendClientMessage(playerid,red,"Player is already in this level!");
		   if(level > MaxVipLevel)
		   {
		   		format(Jstring,sizeof(Jstring),"Error: Maximum V.I.P level is %d",MaxVipLevel); return SendClientMessage(playerid,red,Jstring);
		   }
		   if(pInfo[id][Logged] == 0) return SendClientMessage(playerid,red,"Error: This player is not loggedIn or doesn't have an account!");
		   CommandToAdmins(playerid,"SetVip");
		   getdate(year, month, day);
		   gettime(hour,minute,second);
		   switch(level)
		   {
              case 0: LevelName = "Player Status";
              case 1: LevelName = VIP_LEVEL_1;
			  case 2: LevelName = VIP_LEVEL_2;
			  default: LevelName = VIP_LEVEL_3;
           }
		   format(Jstring,sizeof(Jstring),"You have given %s V.I.P level: %d (%s) , Date: %d/%d/%d at %d:%d:%d",GetName(id), level, LevelName, day, month, year ,hour, minute, second);
		   SendClientMessage(playerid,blue,Jstring);
		   if(level> pInfo[id][Donator])
		   {
			   format(Jstring,sizeof(Jstring),"Administrator %s has set you V.I.P level: %d (%s) <Promoted on %d/%d/%d at %d:%d:%d>",GetName(playerid), level, LevelName ,day, month, year,hour, minute, second),GameTextForPlayerEx(id,"~B~congratulations!", 2000, 3);
			   SendClientMessage(id,yellow,Jstring);
			   format(Jstring,sizeof(Jstring),"%s has changed %s's V.I.P level from %d to %d (%s)",GetName(playerid),GetName(id),pInfo[id][Donator], level, LevelName);
			   WriteToLog(Jstring,"VipLevels");
		   }
		   else
		   {
		   format(Jstring,sizeof(Jstring),"Administrator %s has set you V.I.P level: %d ( %s )",GetName(playerid), level, LevelName);
		   SendClientMessage(id,yellow,Jstring);
		   format(Jstring,sizeof(Jstring),"%s has changed %s's V.I.P level from %d to %d (%s)",GetName(playerid),GetName(id),pInfo[id][Donator], level, LevelName);
		   WriteToLog(Jstring,"VipLevels");
		   }
		   pInfo[id][Donator] = level;
		   format(Jfile, 100, ACCOUNTS_PATH, GetName(id));
		   new INI:ACCOUNT = INI_Open(Jfile);
		   INI_WriteInt(ACCOUNT, "Donator", pInfo[id][Donator]);
		   INI_Close(ACCOUNT);
           return 1;
		}
		else return ShowMessage(playerid, red, 2);
   }
   else return ShowMessage(playerid, red, 1);
}

CMD:vips(playerid,params[])
{
   new IsOnline = 0;
   strdel(JLstring,0,500);
   foreach(Player, i)
   {
      if (pInfo[i][Donator] >= 1)
	  {
 		      switch(pInfo[i][Donator])
              {
			      case 1:
				  {
					  LevelName = VIP_LEVEL_1;
					  LevelColor = VIP_1_COLOR;
				  }
				  case 2:
				  {
					  LevelName = VIP_LEVEL_2;
					  LevelColor = VIP_2_COLOR;
				  }
				  default:
				  {
					  LevelName = VIP_LEVEL_3;
					  LevelColor = VIP_3_COLOR;
				  }
	          }
			  format(Jstring, 128, "%s%s - Level: %d (%s)\n",LevelColor,GetName(i),pInfo[i][Donator],LevelName);
			  strcat(JLstring, Jstring, sizeof(JLstring));
			  IsOnline++;
		}
   }
   if (IsOnline == 0)
   ShowPlayerDialog(playerid,JDIALOGS+165,DIALOG_STYLE_MSGBOX,"{00FFE6}Online V.I.P members","{FF0000}No V.I.P members online!" ,"OK","");
   else
   {
       if(IsOnline == 1) ShowPlayerDialog(playerid,JDIALOGS+165,DIALOG_STYLE_MSGBOX,"{00FFE6}1 V.I.P member online",JLstring ,"OK","");
	   else format(Jstring, 128, "{00FFE6}%d V.I.P members online",IsOnline), ShowPlayerDialog(playerid,JDIALOGS+165,DIALOG_STYLE_MSGBOX,Jstring,JLstring ,"OK","");
   }
   strdel(JLstring,0,500);
   return 1;
}

CMD:jcmds(playerid, params[])
{
	if(pInfo[playerid][pLevel] >= 1)
	{
        ShowPlayerDialog(playerid,JDIALOGS+112,DIALOG_STYLE_LIST,"J.L. Admin System V1.0 Copyright(c), JewelL",""LEVEL_1_COLOR"Level 1\n"LEVEL_2_COLOR"Level 2\n"LEVEL_3_COLOR"Level 3\n"LEVEL_4_COLOR"Level 4\n"LEVEL_5_COLOR"Level 5","Select","Close");
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:acmds(playerid, params[])
{
   return cmd_jcmds(playerid, params);
}

CMD:setscore(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 2)
	{
        new id,score;
	    if(sscanf(params, "ui", id, score)) return
		SendClientMessage(playerid, 0xFFFF00C8, "Usage: /Setscore <PlayerID> <New score>") ;
        if(IsPlayerConnected(id))
		{
			format(Jstring,sizeof(Jstring),"You have set %s's score to '%d'", GetName(id), score);
			SendClientMessage(playerid,yellow,Jstring);
			format(Jstring, sizeof(Jstring), "Admin %s has set your score to '%d'",GetName(playerid),score);
			SendClientMessage(id,yellow,Jstring);
			CommandToAdmins(playerid,"setscore");
   			return SetPlayerScore(id, score);
	    }
		else return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:setcash(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 2)
	{
        new id,cash;
	    if(sscanf(params, "ui", id, cash)) return
		SendClientMessage(playerid, 0xFFFF00C8, "Usage: /Setcash <PlayerID> <New score>") ;
        if(IsPlayerConnected(id))
		{
			format(Jstring, sizeof(Jstring), "Admin %s has set your cash to '%d'",GetName(playerid),cash);
			SendClientMessage(id,yellow,Jstring);
			format(Jstring,sizeof(Jstring),"You have set %s's cash to %d", GetName(id), cash);
			SendClientMessage(playerid,yellow,Jstring);
			ResetPlayerMoney(id);
			CommandToAdmins(playerid,"setcash");
   			return GivePlayerMoney(id, cash);
	    }
		else return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:setskin(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 1)
	{
        new id,skinid;
	    if(sscanf(params, "ui", id, skinid)) return
		SendClientMessage(playerid, yellow, "Usage: /Setskin <PlayerID> <skin ID>") ;
        if(IsPlayerConnected(id))
		{
            if(skinid < 0 || skinid > 299) return SendClientMessage(playerid, red, "Invaild Skin ID!");
            format(Jstring,sizeof(Jstring),"You have set %s's skin to %d", GetName(id), skinid);
			SendClientMessage(playerid,yellow,Jstring);
			format(Jstring, sizeof(Jstring), "Admin %s has given you a new skin (SkinID: %d)",GetName(playerid),skinid);
			SendClientMessage(id,lighterblue,Jstring);
			CommandToAdmins(playerid,"setskin");
   			return SetPlayerSkin(id, skinid);
	    }
		else return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:myskin(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 1)
	{
        new skinid,Jfile[100];
	    if(sscanf(params, "i", skinid)) return
		SendClientMessage(playerid, yellow, "Usage: /Myskin <skin ID>") ;
		if(skinid < 0 || skinid > 299) return SendClientMessage(playerid, red, "Invaild Skin ID!");
		format(Jstring,sizeof(Jstring),"You have set skin '%d' as your favorite skin!", skinid);
		SendClientMessage(playerid,yellow,Jstring);
		format(Jfile, 100, ACCOUNTS_PATH, GetName(playerid));
		new INI:ACCOUNT = INI_Open(Jfile);
		INI_WriteInt(ACCOUNT, "Skin", skinid);
		INI_Close(ACCOUNT);
		pInfo[playerid][Skin] = skinid;
		SetPVarInt(playerid,"Useskin",1);
		CommandToAdmins(playerid,"myskin");
		return SetPlayerSkin(playerid, skinid);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:favskin(playerid,params[])
{
	return cmd_myskin(playerid,params);
}

CMD:stopuseskin(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 1)
	{
		SendClientMessage(playerid,yellow,"You have stopped using your custom skin!");
		SetPVarInt(playerid,"Useskin",0);
		CommandToAdmins(playerid,"stopuseskin");
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:useskin(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 1)
	{
		SendClientMessage(playerid,yellow,"You have favorite skin is now in use!");
		SetPVarInt(playerid,"Useskin",1);
		SetPlayerSkin(playerid, pInfo[playerid][Skin]);
		CommandToAdmins(playerid,"useskin");
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:givescore(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 3)
	{
        new id,amount;
	    if(sscanf(params, "ui", id, amount)) return
		SendClientMessage(playerid, 0xFFFF00C8, "Usage: /Givescore <PlayerID> <ammount>") ;
        if(IsPlayerConnected(id))
		{
			format(Jstring,sizeof(Jstring),"You have given '%d' score to %s",amount,GetName(id));
			SendClientMessage(playerid,yellow,Jstring);
			format(Jstring, sizeof(Jstring), "Admin %s has given you '%d' score",GetName(playerid),amount);
			SendClientMessage(id,lighterblue,Jstring);
			CommandToAdmins(playerid,"givescore");
   			return SetPlayerScore(id, GetPlayerScore(id)+ amount);
	    }
		else return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:givemoney(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 2)
	{
        new id,amount;
	    if(sscanf(params, "ui", id, amount)) return
		SendClientMessage(playerid, 0xFFFF00C8, "Usage: /Givemoney <PlayerID> <ammount>") ;
        if(IsPlayerConnected(id))
		{
			format(Jstring,sizeof(Jstring),"You have given $%d to '%s'",amount,GetName(id));
			SendClientMessage(playerid,yellow,Jstring);
			format(Jstring, sizeof(Jstring), "Admin '%s' has given you $%d",GetName(playerid),amount);
			SendClientMessage(id,lighterblue,Jstring);
			CommandToAdmins(playerid,"givemoney");
   			return GivePlayerMoney(id, amount);
	    }
		else return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:giveallscore(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 4)
	{
        new amount;
	    if(sscanf(params, "i", amount)) return
		SendClientMessage(playerid, 0xFFFF00C8, "Usage: /Giveallscore <ammount>") ;
		CommandToAdmins(playerid,"giveallscore");
		foreach(Player, i)
		{
            SetPlayerScore(i, GetPlayerScore(i)+ amount);
		}
		format(Jstring, sizeof(Jstring), "Admin %s has given '%d' score to all players",GetName(playerid),amount);
		SendClientMessageToAll(lighterblue,Jstring);
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:giveallcash(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 3)
	{
        new amount;
	    if(sscanf(params, "i", amount)) return
		SendClientMessage(playerid, 0xFFFF00C8, "Usage: /Giveallcash <Amount>") ;
		CommandToAdmins(playerid,"giveallcash");
		foreach(Player, i)
		{
		     GivePlayerMoney(i, amount);
		}
		format(Jstring, sizeof(Jstring), "Admin %s has given '$ %d' cash to all players",GetName(playerid),amount);
		SendClientMessageToAll(lighterblue,Jstring);
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:resetscore(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 3)
	{
        new id, reason[50];
	    if(isnull(params)) return
		SendClientMessage(playerid, 0xFFFF00C8, "Usage: /Resetscore <PlayerID> <reason>") ;
		sscanf(params, "us[50]", id,reason);
        if(IsPlayerConnected(id))
		{
			if(isnull(reason))
			format(Jstring, sizeof(Jstring), "Admin %s has set your score to '0'",GetName(playerid));
			else format(Jstring, sizeof(Jstring), "Admin %s has set your score to '0' [Reason: %s]",GetName(playerid), reason);
			SendClientMessage(id,red,Jstring);
			format(Jstring,sizeof(Jstring),"You set %s's score to '0'",GetName(id));
			SendClientMessage(playerid,yellow,Jstring);
			CommandToAdmins(playerid,"resetscore");
   			return SetPlayerScore(id, 0);
	    }
		else return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:bike(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 1)
	{
		if (IsPlayerInAnyVehicle(playerid)) return ShowMessage(playerid, red, 7);
		GiveVehicle(playerid,522);
		CommandToAdmins(playerid,"abike");
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:car(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 1)
	{
		if (IsPlayerInAnyVehicle(playerid)) return ShowMessage(playerid, red, 7);
		GiveVehicle(playerid,560);
		CommandToAdmins(playerid,"car");
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:boat(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 1)
	{
		if (IsPlayerInAnyVehicle(playerid)) return ShowMessage(playerid, red, 7);
		GiveVehicle(playerid,493);
		CommandToAdmins(playerid,"boat");
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:heli(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 1)
	{
		if (IsPlayerInAnyVehicle(playerid)) return ShowMessage(playerid, red, 7);
		GiveVehicle(playerid,487);
		CommandToAdmins(playerid,"heli");
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:plane(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 1)
	{
		if (IsPlayerInAnyVehicle(playerid)) return ShowMessage(playerid, red, 7);
		GiveVehicle(playerid,511);
		CommandToAdmins(playerid,"plane");
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:jet(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 1)
	{
		if (IsPlayerInAnyVehicle(playerid)) return ShowMessage(playerid, red, 7);
		GiveVehicle(playerid,520);
		CommandToAdmins(playerid,"jet");
		return 1;

	}
	else return ShowMessage(playerid, red, 1);
}

CMD:vehicle(playerid, params[])
{
    if(pInfo[playerid][pLevel] >= 1)
    {
        new veh[30],vehid;
        if(sscanf(params, "s[30]", veh)) return SendClientMessage(playerid, yellow, "Usage: /vehicle <Model ID/Vehicle Name>");
        if (IsPlayerInAnyVehicle(playerid)) return ShowMessage(playerid, red, 7);
        if(IsNumeric(veh)) vehid = strval(veh);
        else vehid = ReturnVehicleModelID(veh);
        if(vehid < 400 || vehid > 611) return SendClientMessage(playerid, red, "Invalid vehicle model!");
		GiveVehicle(playerid,vehid);
		CommandToAdmins(playerid,"vehicle");
		return 1;
    }
	else return ShowMessage(playerid, red, 1);
}

CMD:spawncar(playerid, params[])
{
    if(pInfo[playerid][pLevel] >= 2)
    {
	    new veh[30],vehid;
		if(sscanf(params, "s[30]", veh)) return SendClientMessage(playerid, yellow, "Usage: /spawncar <Model ID/Vehicle Name>");
		if(IsNumeric(veh)) vehid = strval(veh);
		else vehid = ReturnVehicleModelID(veh);
		if(vehid < 400 || vehid > 611) return SendClientMessage(playerid, red, "Invalid vehicle model!");
		SpawnVehicle(playerid,vehid);
		CommandToAdmins(playerid,"spawncar");
		return 1;
    }
	else return ShowMessage(playerid, red, 1);
}

CMD:givecar(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 2)
	{
        new id;
        if(sscanf(params, "u", id)) return SendClientMessage(playerid, yellow, "Usage: /givecar <Player ID>");
        if(!IsPlayerConnected(id)) return ShowMessage(playerid, red, 2);
        if (IsPlayerInAnyVehicle(id)) return SendClientMessage(playerid,red,"Error: player is inside a vehicle!");
		GiveVehicle(id,560);
		CommandToAdmins(playerid,"givecar");
		format(Jstring,sizeof(Jstring),"Admin '%s' has given you a Car!",GetName(playerid));
		SendClientMessage(id,lighterblue,Jstring);
		format(Jstring,sizeof(Jstring),"You have given '%s' a Car!", GetName(id));
		return SendClientMessage(playerid, yellow,Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:giveveh(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 3)
	{
        new id,veh[30],vehid;
        if(sscanf(params, "us[30]", id ,veh)) return SendClientMessage(playerid, yellow, "Usage: /giveveh <Player ID> <VehicleID/Name>");
        if(!IsPlayerConnected(id)) return ShowMessage(playerid, red, 2);
        if (IsPlayerInAnyVehicle(id)) return SendClientMessage(playerid,red,"Error: player is inside a vehicle!");
		if(IsNumeric(veh)) vehid = strval(veh);
		else vehid = ReturnVehicleModelID(veh);
		if(vehid < 400 || vehid > 611) return SendClientMessage(playerid, red, "Invalid vehicle model!");
		GiveVehicle(id,vehid);
		CommandToAdmins(playerid,"giveveh");
		format(Jstring,sizeof(Jstring),"Admin '%s' has given you a vehicle!",GetName(playerid));
		SendClientMessage(id,lighterblue,Jstring);
		format(Jstring,sizeof(Jstring),"You have given '%s' a vehicle!", GetName(id));
		return SendClientMessage(playerid, yellow,Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:setalltime(playerid, params[])
{
    if(pInfo[playerid][pLevel] >= 3)
	{
        new time;
        if(sscanf(params, "i", time)) return SendClientMessage(playerid, yellow, "Usage: /settime <Time>");
        if(time > 24 || time < 0) return SendClientMessage(playerid, red, "Error: Invalid Time!");
        CommandToAdmins(playerid,"setalltime");
		format(Jstring,sizeof(Jstring),"%s has changed time to '%d'",GetName(playerid),time);
		SendClientMessageToAll(yellow,Jstring);
		SetWorldTime(time);
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:setallweather(playerid, params[])
{
     if(pInfo[playerid][pLevel] >= 3)
     {
           new weather;
           if(sscanf(params, "i", weather)) return SendClientMessage(playerid, yellow, "Usage: /setallweather <weather ID>");
           CommandToAdmins(playerid,"setallweather");
		   format(Jstring,sizeof(Jstring),"%s has changed weather to '%d'",GetName(playerid),weather);
		   SendClientMessageToAll(yellow,Jstring);
		   SetWeather(weather);
		   return 1;
     }
     else return ShowMessage(playerid, red, 1);
}

CMD:settime(playerid, params[])
{
    if(pInfo[playerid][pLevel] >= 2)
    {
       new id,time;
       if(sscanf(params, "ui", id, time)) return SendClientMessage(playerid, yellow, "Usage: /settime <Player ID> <Time>");
       if(!IsPlayerConnected(id)) return ShowMessage(playerid, red, 2);
       if(time > 24 || time < 0) return SendClientMessage(playerid, red, "Error: Invalid Time!");
       CommandToAdmins(playerid,"settime");
       format(Jstring,sizeof(Jstring),"You have set %s's time to '%d'",GetName(id),time);
	   SendClientMessage(playerid,yellow,Jstring);
	   format(Jstring,sizeof(Jstring),"Admin %s has changed your time to '%d'",GetName(playerid),time);
	   SendClientMessage(id,yellow,Jstring);
	   return SetPlayerTime(id, time, 0);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:setweather(playerid, params[])
{
    if(pInfo[playerid][pLevel] >= 2)
    {
       new id, weather;
       if(sscanf(params, "ui", id, weather)) return SendClientMessage(playerid, yellow, "Usage: /setallweather <Player ID> <weather ID>");
       if(!IsPlayerConnected(id)) return ShowMessage(playerid, red, 2);
       CommandToAdmins(playerid,"setweather");
       format(Jstring,sizeof(Jstring),"You have set %s's weater to '%d'",GetName(id),weather);
	   SendClientMessage(playerid,yellow,Jstring);
	   format(Jstring,sizeof(Jstring),"Admin %s has changed your weater to '%d'",GetName(playerid),weather);
	   SendClientMessage(id,yellow,Jstring);
	   SetPlayerWeather(id,weather);
	   return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:setwanted(playerid,params[])
{
      if(pInfo[playerid][pLevel] >= 2)
      {
           new id, level;
           if(sscanf(params, "ui", id, level)) return SendClientMessage(playerid, yellow, "Usage: /setwanted <Player ID> <wanted level>");
           if(!IsPlayerConnected(id)) return ShowMessage(playerid, red, 2);
           if(level < 0 || level > 6) return SendClientMessage(playerid, red, "Invalid wanted level!");
           CommandToAdmins(playerid,"setwanted");
           format(Jstring,sizeof(Jstring),"You have set %s's wanted level to '%d'",GetName(id),level);
		   SendClientMessage(playerid,yellow,Jstring);
		   format(Jstring,sizeof(Jstring),"Admin %s has set your wanted level to '%d'",GetName(playerid),level);
		   SendClientMessage(id,yellow,Jstring);
		   SetPlayerWantedLevel(id,level);
		   return 1;
      }
      else return ShowMessage(playerid, red, 1);
}

CMD:setallwanted(playerid, params[], help)
{
    if(pInfo[playerid][pLevel] >= 3)
    {
       new level;
       if(sscanf(params, "i", level)) return SendClientMessage(playerid, yellow, "Usage: /setallwanted <wanted level>");
       CommandToAdmins(playerid,"setallwanted");
	   format(Jstring,sizeof(Jstring),"%s has set your wanted level to '%d'",GetName(playerid),level);
	   SendClientMessageToAll(yellow,Jstring);
	   foreach(Player, i) SetPlayerWantedLevel(i,level);
	   return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:goto(playerid, params[])
{
    if(pInfo[playerid][pLevel] >= 1)
    {
       new id,Float:Pos[3];
	   if(sscanf(params, "u", id)) return SendClientMessage(playerid, yellow, "Usage: /goto <Player ID>");
       if(IsPlayerConnected(id) && id != playerid)
       {
	         GetPlayerPos(id,Pos[0],Pos[1],Pos[2]);
			 SetPlayerInterior(playerid,GetPlayerInterior(id));
			 SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(id));
			 if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			 {
			    SetVehiclePos(GetPlayerVehicleID(playerid),Pos[0]+3,Pos[1],Pos[2]);
				LinkVehicleToInterior(GetPlayerVehicleID(playerid),GetPlayerInterior(id));
				SetVehicleVirtualWorld(GetPlayerVehicleID(playerid),GetPlayerVirtualWorld(id));
		     }
		     else SetPlayerPos(playerid,Pos[0]+3,Pos[1],Pos[2]);
		     CommandToAdmins(playerid,"goto");
		     format(Jstring,sizeof(Jstring),"You have been Teleported to '%s'", GetName(id));
		     SendClientMessage(playerid,yellow,Jstring);
			 return 1;
	   }
	   else return ShowMessage(playerid, red, 3);
    }
    else return ShowMessage(playerid, red, 1);
}

CMD:get(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 1)
	{
		new id;
	    if(sscanf(params, "u",id)) return SendClientMessage(playerid, yellow, "Usage: /Get <Part of Nick/Player ID>");
	 	if(IsPlayerConnected(id) && id != playerid)
	    {
            if(pInfo[playerid][pLevel] < pInfo[id][pLevel]) return ShowMessage(playerid, red, 6);
			new Float:Pos[3];
			GetPlayerPos(playerid,Pos[0],Pos[1],Pos[2]);
			SetPlayerInterior(id,GetPlayerInterior(playerid));
			SetPlayerVirtualWorld(id,GetPlayerVirtualWorld(playerid));
			if(GetPlayerState(id) == PLAYER_STATE_DRIVER)
			{
   			new Veh = GetPlayerVehicleID(id);
			SetVehiclePos(Veh,Pos[0]+3,Pos[1],Pos[2]);
			LinkVehicleToInterior(Veh,GetPlayerInterior(playerid));
			SetVehicleVirtualWorld(Veh,GetPlayerVirtualWorld(playerid));
			}
			else SetPlayerPos(id,Pos[0]+3,Pos[1],Pos[2]);
			format(Jstring,sizeof(Jstring),"Administrator '%s' has teleported you!", GetName(playerid));
			SendClientMessage(id,yellow,Jstring);
			format(Jstring,sizeof(Jstring),"You have Teleported '%s' to your Position", GetName(id));
			CommandToAdmins(playerid,"get");
			return SendClientMessage(playerid,yellow,Jstring);
		}
		else return ShowMessage(playerid, red, 3);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:sget(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 3)
	{
		new id;
	    if(sscanf(params, "u",id)) return SendClientMessage(playerid, yellow, "Usage: /sget <Part of Nick/Player ID>");
	 	if(IsPlayerConnected(id) && id != playerid)
	    {
            if(pInfo[playerid][pLevel] < pInfo[id][pLevel]) return ShowMessage(playerid, red, 6);
			new Float:Pos[3];
			GetPlayerPos(playerid,Pos[0],Pos[1],Pos[2]);
			SetPlayerInterior(id,GetPlayerInterior(playerid));
			SetPlayerVirtualWorld(id,GetPlayerVirtualWorld(playerid));
			if(GetPlayerState(id) == PLAYER_STATE_DRIVER)
			{
   			new Veh = GetPlayerVehicleID(id);
			SetVehiclePos(Veh,Pos[0]+3,Pos[1],Pos[2]);
			LinkVehicleToInterior(Veh,GetPlayerInterior(playerid));
			SetVehicleVirtualWorld(Veh,GetPlayerVirtualWorld(playerid));
			}
			else SetPlayerPos(id,Pos[0]+3,Pos[1],Pos[2]);
			format(Jstring,sizeof(Jstring),"You have Teleported '%s' to your Position", GetName(id));
			CommandToAdmins(playerid,"sget");
			return SendClientMessage(playerid,yellow,Jstring);
		}
		else return ShowMessage(playerid, red, 3);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:getid(playerid,params[])
{
     new Nick[24],count=0;
	 if(sscanf(params, "s[24]",Nick)) return SendClientMessage(playerid, 0xFFFF00C8, "Usage: /getid <Part of nick>");
	 format(Jstring,sizeof(Jstring),"____Seach result for \"%s\"____",Nick);
	 SendClientMessage(playerid,lighterblue,Jstring);
	 foreach(Player, i)
	 {
	          if(strfind(GetName(i),Nick,true) != -1 )
			  {
	              count++;
				  format(Jstring,sizeof(Jstring),"%d - %s(ID: %d)",count,GetName(i),i);
				  SendClientMessage(playerid,green,Jstring);
	          }
     }
   	 if(count==0)
	 SendClientMessage(playerid,red,"No resuilt found!");
	 return 1;
}

CMD:kick(playerid, params[], help)
{
    if(pInfo[playerid][pLevel] >= 1)
    {
         new id, reason[50];
         if(isnull(params)) return SendClientMessage(playerid, yellow, "Usage: /kick <Player ID> <Reason>");
         sscanf(params, "us[50]", id, reason);
         if(IsPlayerConnected(id) && id != playerid)
         {
            if(pInfo[playerid][pLevel] <= pInfo[id][pLevel]) return ShowMessage(playerid, red, 6);
            if(!isnull(reason))
		    format(Jstring,sizeof(Jstring),"'%s' has been kicked by administrator %s Reason: %s",GetName(id),GetName(playerid),reason);
		    else format(Jstring,sizeof(Jstring),"'%s' has been kicked by administrator %s",GetName(id),GetName(playerid));
			SendClientMessageToAll(red,Jstring);
			format(Jstring,sizeof(Jstring),"[INGAME KICK] %s has kicked %s | %s ",GetName(playerid),GetName(id),reason);
			WriteToLog(Jstring,"KickLog");
			CommandToAdmins(playerid,"kick");
			return SetTimerEx("KickPlayer",200,false,"d", id);
		 }
		 else return ShowMessage(playerid, red, 3);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:ban(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 2)
	{
       new id, reason[50], Jfile[100];
	   new year, month, day, hour, minuite, second;
       if(sscanf(params, "us[50]", id, reason)) return SendClientMessage(playerid, yellow, "Usage: /ban <Player ID> <Reason>");
	   if(IsPlayerConnected(id) && id != playerid)
	   {
          if(pInfo[playerid][pLevel] <= pInfo[id][pLevel]) return ShowMessage(playerid, red, 6);
          getdate(year, month, day);
		  gettime(hour,minuite,second);
	      format(Jstring,sizeof(Jstring),"%s has been Banned by Administrator %s | Reason: %s <Date: %d/%d/%d> <Time: %d:%d>",GetName(id),GetName(playerid),reason,day,month,year,hour,minuite);
		  SendClientMessageToAll(red,Jstring);
		  format(JLstring,sizeof(JLstring),"{37C8C8}Administrator %s has banned you for: \"%s\"\n\nVisit "WEBSITE" for more informations", GetName(playerid),reason);
		  ShowPlayerDialog(id,JDIALOGS+200,DIALOG_STYLE_MSGBOX,"                     {FF0000}You are BANNED",JLstring,"OK","");
		  if(pInfo[id][Logged] == 1)
		  {
			  format(Jfile, 100, ACCOUNTS_PATH, GetName(id));
			  new INI:ACCOUNT = INI_Open(Jfile);
			  INI_WriteInt(ACCOUNT, "Banned", 1);
			  INI_Close(ACCOUNT);
		  }
		  format(Jstring,sizeof(Jstring),"Ban by %s  Reason: %s",GetName(playerid),reason);
		  SetPVarString(id,"Banreason",Jstring);
		  format(Jstring,sizeof(Jstring),"[INGAME BAN] %s has banned %s | %s",GetName(playerid),GetName(id),reason);
		  WriteToLog(Jstring,"Bans");
		  CommandToAdmins(playerid,"ban");
		  return SetTimerEx("BanPlayer",200,false,"dd", id,0);
		}
		else return ShowMessage(playerid, red, 3);
    }
	else return ShowMessage(playerid, red, 1);
}

CMD:rban(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 4)
	{
       new id, reason[50], Jfile[100],ip[30];
	   new year, month, day, hour, minuite, second;
       if(sscanf(params, "us[50]", id, reason)) return SendClientMessage(playerid, yellow, "Usage: /rban <Player ID> <Reason>");
	   if(IsPlayerConnected(id) && id != playerid)
	   {
          if(pInfo[playerid][pLevel] <= pInfo[id][pLevel]) return ShowMessage(playerid, red, 6);
          getdate(year, month, day);
		  gettime(hour,minuite,second);
	      format(Jstring,sizeof(Jstring),"%s has been Banned by Administrator %s | Reason: %s <Date: %d/%d/%d> <Time: %d:%d>",GetName(id),GetName(playerid),params[2],day,month,year,hour,minuite);
		  SendClientMessageToAll(red,Jstring);
		  printf("%s",Jstring);
		  format(JLstring,sizeof(JLstring),"{FF0000}Administrator %s has RANGE banned you for: \"%s\"\n\nVisit "WEBSITE" for more informations", GetName(playerid),reason);
		  ShowPlayerDialog(id,JDIALOGS+200,DIALOG_STYLE_MSGBOX,"                     {FF0000}You are RANGE BANNED",JLstring,"OK","");
		  if(pInfo[id][Logged] == 1)
		  {
			  format(Jfile, 100, ACCOUNTS_PATH, GetName(id));
			  new INI:ACCOUNT = INI_Open(Jfile);
			  INI_WriteInt(ACCOUNT, "Banned", 1);
			  INI_Close(ACCOUNT);
		  }
		  GetPlayerIp(id,ip,sizeof(ip));
		  strdel(ip,strlen(ip)-2,strlen(ip));
		  format(ip,30,"%s**",ip);
		  format(ip,30,"banip %s",ip);
		  SendRconCommand(ip);
		  GetPlayerIp(id,ip,sizeof(ip));
		  format(Jstring,sizeof(Jstring),"range ban by %s  Reason: %s",GetName(playerid),reason);
		  SetPVarString(id,"Banreason",Jstring);
		  format(Jstring,sizeof(Jstring),"[INGAME RANGE BAN] %s has RANGE banned %s | %s (IP: %s)",GetName(playerid),GetName(id),reason, ip);
		  WriteToLog(Jstring,"Bans");
		  CommandToAdmins(playerid,"rban");
		  return SetTimerEx("BanPlayer",200,false,"dd", id,0);
		}
		else return ShowMessage(playerid, red, 3);
    }
	else return ShowMessage(playerid, red, 1);
}

CMD:rangeban(playerid,params[])
{
  return cmd_rban(playerid,params);
}

CMD:tempban(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 2)
	{
       new id, reason[50], Jfile[100];
	   new year,month,day,hour,minuite,second,Hours,BanTime,d,h,m,Temp;
       if(sscanf(params, "uis[50]", id, Hours, reason)) return SendClientMessage(playerid, yellow, "Usage: /tempban <Player ID> <Hours> <Reason>");
	   if(IsPlayerConnected(id) && id != playerid)
	   {
          if(pInfo[playerid][pLevel] <= pInfo[id][pLevel]) return ShowMessage(playerid, red, 6);
          getdate(year, month, day);
		  gettime(hour,minuite,second);
		  BanTime = gettime() + (Hours*60*60);
		  if(pInfo[id][Logged] == 1)
		  {
			  format(Jfile, 100, ACCOUNTS_PATH, GetName(id));
			  new INI:ACCOUNT = INI_Open(Jfile);
			  INI_WriteInt(ACCOUNT, "TempBan", BanTime);
			  INI_Close(ACCOUNT);
		  }
		  Temp = BanTime - gettime();
		  format(Jstring,sizeof(Jstring),"%s has been Temporarily Banned by Administrator %s for %s | Reason: %s <Date: %d/%d/%d> <Time: %d:%d>",GetName(id),GetName(playerid),ConvertTime(Temp,m,h,d),reason,day,month,year,hour,minuite);
		  SendClientMessageToAll(red,Jstring);
		  Temp = BanTime - gettime();
		  format(JLstring,sizeof(JLstring),"{37C8C8}Administrator %s has Temp banned you for %s REASON |: \"%s\"\n\nVisit "WEBSITE" for more informations", GetName(playerid),ConvertTime(Temp,m,h,d),reason);
		  ShowPlayerDialog(id,JDIALOGS+200,DIALOG_STYLE_MSGBOX,"                     {FF0000}You are BANNED",JLstring,"OK","");
		  format(Jstring,sizeof(Jstring),"[TEMP BAN] %s has Temp banned %s for %s | reason: ",GetName(playerid),GetName(id),ConvertTime(BanTime,m,h,d),reason);
		  WriteToLog(Jstring,"Bans");
		  CommandToAdmins(playerid,"tempban");
		  return SetTimerEx("KickPlayer",100,false,"d", id);
		}
		else return ShowMessage(playerid, red, 3);
    }
	else return ShowMessage(playerid, red, 1);
}

CMD:countdown(playerid, params[])
{
     if(pInfo[playerid][pLevel] >= 2)
	 {
           if(sscanf(params, "dd", cd_seconds, cd_freeze)) return SendClientMessage(playerid, yellow, "Usage: /countdown <Seconds> <Freeze (0 , 1)>");
		   if(cd_started == 1) return SendClientMessage(playerid, yellow, "The countdown has already started!");
		   if(cd_seconds < 1 || cd_seconds > 600) return SendClientMessage(playerid,red,"Seconds must be between 1-600 (1 sec - 10 mins)");
		   if(cd_freeze != 1 && cd_freeze != 0) return SendClientMessage(playerid,red,"Invalid freeze option! must be between 0 or 1 (1 freeze - 0 no freeze)");
		   cd_timer = SetTimer("CountDown",1000,true);
		   cd_started = 1;
		   if(cd_freeze == 1)
		   {
		       foreach(Player, i)
			   {
				       TogglePlayerControllable(i, 0);
				       pInfo[i][Frozen]=1;
		       }
		   }
		   CommandToAdmins(playerid,"countdown");
		   return 1;
	 }
	 else return ShowMessage(playerid, red, 1);
}

CMD:clearchat(playerid, params[])
{
     if(pInfo[playerid][pLevel] >= 1)
	 {
	     for(new i = 0; i < 15; i++)
	     SendClientMessageToAll(-1," ");
	     format(Jstring, sizeof(Jstring),"'%s' has cleared the main chat (/clearchat)",GetName(playerid));
		 SendToAdmins(orange,Jstring);
		 return 1;
	 }
	 else return ShowMessage(playerid, red, 1);
}

CMD:clearallchat(playerid, params[])
{
     if(pInfo[playerid][pLevel] >= 2)
	 {
	     for(new i = 0; i < 90; i++)
	     SendClientMessageToAll(-1," ");
	     format(Jstring, sizeof(Jstring),"'%s' has cleared all messages on main chat (/clearallchat)",GetName(playerid));
		 SendToAdmins(orange,Jstring);
		 return 1;
	 }
	 else return ShowMessage(playerid, red, 1);
}

CMD:clearplayerchat(playerid, params[])
{
     if(pInfo[playerid][pLevel] >= 1)
	 {
		 new id;
         if(sscanf(params, "u", id)) return SendClientMessage(playerid, yellow, "Usage: /claerplayerchat <Player ID>");
	     for(new i = 0; i < 40; i++)
	     SendClientMessage(id,-1," ");
	     format(Jstring,sizeof(Jstring),"You have cleared %s's chat!",GetName(id));
	     SendClientMessage(playerid,yellow,Jstring);
	     CommandToAdmins(playerid,"clearplayerchat");
	     return 1;
	 }
	 else return ShowMessage(playerid, red, 1);
	 
}

CMD:cpc(playerid, params[])
{
return cmd_clearplayerchat(playerid,params);
}

CMD:setarmour(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 2)
	{
		new id,amount;
        if(sscanf(params, "ui",id,amount)) return SendClientMessage(playerid, yellow, "Usage: /Setarmour <Player ID/Part of nick> <Amount> (1-100)!");
        if(IsPlayerConnected(id))
		{
            if(amount < 0 ) return SendClientMessage(playerid, red, "Invalid amount!");
			format(Jstring, sizeof(Jstring), "You have set %s's Armour to '%d'", GetName(id), amount);
			SendClientMessage(playerid,yellow,Jstring);
			format(Jstring,sizeof(Jstring),"Admin '%s' has set your Armour to '%d'", GetName(playerid), amount);
			SendClientMessage(id,yellow,Jstring);
			SetPlayerArmour(id, amount);
			CommandToAdmins(playerid,"setarmour");
			return 1;
	    }
		else return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:sethealth(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 2)
	{
		new id,amount;
        if(sscanf(params, "ui",id,amount)) return SendClientMessage(playerid, yellow, "Usage: /Sethealth <Player ID/Part of nick> <Amount> (1-100)!");
        if(IsPlayerConnected(id))
		{
            if(amount < 0 ) return SendClientMessage(playerid, red, "Invalid amount!");
			format(Jstring, sizeof(Jstring), "You have set %s's Health to '%d'", GetName(id), amount);
			SendClientMessage(playerid,yellow,Jstring);
			format(Jstring,sizeof(Jstring),"Admin '%s' has set your Health to '%d'", GetName(playerid), amount);
			SendClientMessage(id,yellow,Jstring);
			SetPlayerHealth(id, amount);
			CommandToAdmins(playerid,"sethealth");
			return 1;
	    }
		else return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:setallhealth(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 3)
	{
	    new hp;
		if(sscanf(params, "i", hp)) return SendClientMessage(playerid, yellow, "Usage: /setallhealth <Health>");
		if(hp > 100 || hp < 0) return SendClientMessage(playerid, red, "Invalid Ammount!");
		CommandToAdmins(playerid,"setallhealth");
		foreach(Player, i)
		{
		      SetPlayerHealth(i,hp);
		}
		format(Jstring,sizeof(Jstring),"You have set everyone's health to '%d'", hp);
		SendClientMessage(playerid,yellow,Jstring);
		format(Jstring,sizeof(Jstring),"Admin '%s' has set everyone's health to '%d'", GetName(playerid), hp);
		return SendClientMessageToAll(yellow, Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:setallarmour(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 3)
	{
	    new armour;
		if(sscanf(params, "i", armour)) return SendClientMessage(playerid, yellow, "Usage: /setallarmour <Armour>");
		if(armour > 100 || armour < 0) return SendClientMessage(playerid, red, "Invalid Ammount!");
		CommandToAdmins(playerid,"setallarmour");
		foreach(Player, i)
		{
		      SetPlayerArmour(i,armour);
		}
		format(Jstring,sizeof(Jstring),"You have set everyone's armour to '%d'", armour);
		SendClientMessage(playerid,yellow,Jstring);
		format(Jstring,sizeof(Jstring),"Admin '%s' has set everyone's armour to '%d'", GetName(playerid), armour);
		return SendClientMessageToAll(yellow, Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:mute(playerid, params[])
{
    if(pInfo[playerid][pLevel] >= 1)
    {
        new id, reason[50];
        if(isnull(params)) return SendClientMessage(playerid, yellow, "Usage: /mute <Player ID> <Reason>");
        sscanf(params, "us[50]", id, reason);
        if(IsPlayerConnected(id))
        {
            if(pInfo[id][Muted] == 1) return SendClientMessage(playerid,red,"This player is already muted. see /muted");
            if(pInfo[playerid][pLevel] < pInfo[id][pLevel]) return ShowMessage(playerid, red, 6);
            if(!isnull(reason))
		    format(Jstring,sizeof(Jstring),"Administrator %s has muted player '%s' | Reason: %s",GetName(playerid),GetName(id),reason);
		    else format(Jstring,sizeof(Jstring),"Administrator %s has muted '%s'",GetName(playerid),GetName(id));
		    SendClientMessageToAll(red,Jstring);
		    pInfo[id][Muted] = 1;
		    CommandToAdmins(playerid,"mute");
			return 1;
		}
		else return ShowMessage(playerid, red, 2);
    }
    else return ShowMessage(playerid, red, 1);
}

CMD:pmute(playerid, params[])
{
    if(pInfo[playerid][pLevel] >= 4)
    {
        new id, reason[50], Jfile[100];
        if(isnull(params)) return SendClientMessage(playerid, yellow, "Usage: /pmute <Player ID> <Reason> will mute a player permanently");
        sscanf(params, "us[50]", id, reason);
        if(IsPlayerConnected(id))
        {
            if(pInfo[id][Muted] == 1) return SendClientMessage(playerid,red,"This player is already muted. see /muted");
            if(pInfo[playerid][pLevel] < pInfo[id][pLevel]) return ShowMessage(playerid, red, 6);
            if(!isnull(reason))
		    format(Jstring,sizeof(Jstring),"Administrator %s has permanently muted player '%s' | Reason: %s",GetName(playerid),GetName(id),reason);
		    else format(Jstring,sizeof(Jstring),"Administrator %s has permanently muted '%s'",GetName(playerid),GetName(id));
		    SendClientMessageToAll(red,Jstring);
		    pInfo[id][Muted] = 1;
		    if(pInfo[id][Logged] == 1)
			{
				format(Jfile, sizeof(Jfile), ACCOUNTS_PATH, GetName(id));
				new INI:ACCOUNT = INI_Open(Jfile);
				INI_WriteInt(ACCOUNT, "Muted", 1);
				INI_Close(ACCOUNT);
			}
			CommandToAdmins(playerid,"pmute");
			return 1;
		}
		else return ShowMessage(playerid, red, 2);
    }
    else return ShowMessage(playerid, red, 1);
}

CMD:unmute(playerid, params[])
{
    if(pInfo[playerid][pLevel] >= 1)
    {
        new id, reason[50],Jfile[100];
        if(isnull(params)) return SendClientMessage(playerid, yellow, "Usage: /unmute <Player ID> <Reason>");
        sscanf(params, "us[50]", id, reason);
        if(IsPlayerConnected(id))
        {
            if(pInfo[id][Muted] == 0) return SendClientMessage(playerid,red,"This player is not muted!");
            if(!isnull(reason))
		    format(Jstring,sizeof(Jstring),"You have been unmuted by admin '%s' | Reason: %s",GetName(playerid),reason);
		    else format(Jstring,sizeof(Jstring),"You have been unmuted by admin '%s'",GetName(playerid));
		    SendClientMessage(id,yellow,Jstring);
		    format(Jstring,sizeof(Jstring),"You have unmuted '%s'",GetName(id));
			SendClientMessage(playerid,yellow,Jstring);
		    pInfo[id][Muted] = 0;
		    if(pInfo[id][Logged] == 1)
			{
				format(Jfile, sizeof(Jfile), ACCOUNTS_PATH, GetName(id));
				new INI:ACCOUNT = INI_Open(Jfile);
				INI_WriteInt(ACCOUNT, "Muted", 0);
				INI_Close(ACCOUNT);
			}
			KillTimer(Mtimer[id]);
			CommandToAdmins(playerid,"unmute");
			return 1;
		}
		else return ShowMessage(playerid, red, 2);
    }
    else return ShowMessage(playerid, red, 1);
}

CMD:muted(playerid,params[])
{
   if(pInfo[playerid][pLevel] >= 1)
   {
	   new IsMuted = 0;
	   strdel(JLstring,0,500);
	   foreach(Player, i)
	   {
	      if (pInfo[i][Muted] == 1)
		  {
		       format(Jstring, 128, "%s(ID: %d)\n",GetName(i),i);
			   strcat(JLstring, Jstring, sizeof(JLstring));
			   IsMuted++;
	      }
	   }
	   if (IsMuted == 0)
	   ShowPlayerDialog(playerid,JDIALOGS+165,DIALOG_STYLE_MSGBOX,"{00FFE6}Muted Players","{FF0000}No one  is muted!" ,"OK","");
	   else
	   {
	        if(IsMuted == 1) ShowPlayerDialog(playerid,JDIALOGS+165,DIALOG_STYLE_MSGBOX,"{00FFE6}1 player is muted",JLstring ,"OK","");
			else format(Jstring, 128, "{00FFE6}%d players are muted",IsMuted), ShowPlayerDialog(playerid,JDIALOGS+165,DIALOG_STYLE_MSGBOX,Jstring,JLstring ,"OK","");
	   }
	   strdel(JLstring,0,500);
	   return 1;
   }
   else return ShowMessage(playerid, red, 1);
}

CMD:freeze(playerid, params[], help)
{
    if(pInfo[playerid][pLevel] >= 2)
    {
        new id, time = 0, reason[50];
        if(isnull(params)) return SendClientMessage(playerid, yellow, "Usage: /freeze <Player ID> <Minutes> <Reason>");
        sscanf(params, "uis[50]", id, time, reason);
        if(IsPlayerConnected(id))
        {
            if(pInfo[id][Frozen] == 1) return SendClientMessage(playerid,red,"This player is already frozen. see /frozen");
            if(pInfo[playerid][pLevel] < pInfo[id][pLevel]) return ShowMessage(playerid, red, 6);
            if(!isnull(reason) && time == 0)
		    format(Jstring,sizeof(Jstring),"Administrator %s has frozen player '%s' | Reason: %s",GetName(playerid),GetName(id),reason);
		    else if(!isnull(reason) && time >= 1) format(Jstring,sizeof(Jstring),"Administrator %s has frozen '%s' for %d minutes (reason: %s)",GetName(playerid),GetName(id), time, reason);
		    else if(isnull(reason) && time >= 1) format(Jstring,sizeof(Jstring),"Administrator %s has frozen '%s' for %d minutes",GetName(playerid),GetName(id), time);
		    else format(Jstring,sizeof(Jstring),"Administrator %s has frozen '%s'",GetName(playerid),GetName(id));
		    SendClientMessageToAll(red,Jstring);
		    pInfo[id][Frozen] = 1;
		    TogglePlayerControllable(id, false);
		    if(time >= 1)
			{
		    	Ftimer[id] = SetTimerEx("Unfreeze",time*1000*60,0,"u",id);
		    }
		    CommandToAdmins(playerid,"freeze");
			return 1;
		}
		else return ShowMessage(playerid, red, 2);
    }
    else return ShowMessage(playerid, red, 1);
}

CMD:unfreeze(playerid, params[])
{
    if(pInfo[playerid][pLevel] >= 2)
    {
        new id, reason[50];
        if(isnull(params)) return SendClientMessage(playerid, yellow, "Usage: /unfreeze <Player ID/Part of Name> <Reason>");
        sscanf(params, "us[50]", id, reason);
        if(IsPlayerConnected(id))
        {
            if(pInfo[id][Frozen] == 0) return SendClientMessage(playerid,red,"This player is not frozen!");
            if(!isnull(reason))
		    format(Jstring,sizeof(Jstring),"You have been unfrozen by admin '%s' | Reason: %s",GetName(playerid),reason);
		    else format(Jstring,sizeof(Jstring),"You have been unfrozen by admin '%s'",GetName(playerid));
		    SendClientMessage(id,yellow,Jstring);
		    CommandToAdmins(playerid,"unfreeze");
		    format(Jstring,sizeof(Jstring),"You have unfrozen '%s'",GetName(id));
			SendClientMessage(playerid,yellow,Jstring);
		    pInfo[id][Frozen] = 0;
		    TogglePlayerControllable(id, true);
		    KillTimer(Ftimer[id]);
			return 1;
		}
		else return ShowMessage(playerid, red, 2);
    }
    else return ShowMessage(playerid, red, 1);
}

CMD:frozen(playerid,params[])
{
   if(pInfo[playerid][pLevel] >= 1)
   {
	   new IsFrozen = 0;
	   strdel(JLstring,0,500);
	   foreach(Player, i)
	   {
	      if (pInfo[i][Frozen] == 1)
		  {
		       format(Jstring, 128, "%s(ID: %d)\n",GetName(i),i);
			   strcat(JLstring, Jstring, sizeof(JLstring));
			   IsFrozen++;
	      }
	   }
	   if (IsFrozen == 0)
	   ShowPlayerDialog(playerid,JDIALOGS+165,DIALOG_STYLE_MSGBOX,"{00FFE6}Frozen Players","{FF0000}No one  is frozen!" ,"OK","");
	   else
	   {
	        if(IsFrozen == 1) ShowPlayerDialog(playerid,JDIALOGS+165,DIALOG_STYLE_MSGBOX,"{00FFE6}1 player is frozen",JLstring ,"OK","");
			else format(Jstring, 128, "{00FFE6}%d players are frozen",IsFrozen), ShowPlayerDialog(playerid,JDIALOGS+165,DIALOG_STYLE_MSGBOX,Jstring,JLstring ,"OK","");
	   }
	   strdel(JLstring,0,500);
	   return 1;
   }
   else return ShowMessage(playerid, red, 1);
}

CMD:spec(playerid, params[])
{
   if(pInfo[playerid][pLevel] >= 1)
   {
        new id,Float:P[3],Float:H,Float:A;
        if(sscanf(params, "u", id)) return SendClientMessage(playerid, yellow, "Usage: /Spec <Player ID/Part of Name>");
        if(!IsPlayerConnected(id) || playerid == id) return ShowMessage(playerid, red, 3);
        CommandToAdmins(playerid,"spec");
		#if SpecTextDraw == true
        TextDrawShowForPlayer(playerid, SpecGTD);
		PlayerTextDrawShow(playerid, SpecPTD);
		UpdteSpecTD(playerid,id);
		#endif
        if (pInfo[playerid][Spec] == 0)
        {
           GetPlayerHealth(playerid, H);
		   GetPlayerArmour(playerid,A);
           SetPVarInt(playerid,"Int",GetPlayerInterior(playerid));
		   SetPVarInt(playerid,"vworld",GetPlayerVirtualWorld(playerid));
		   GetPlayerPos(playerid,P[0],P[1],P[2]);
		   SetPVarFloat(playerid,"JX",P[0]);
		   SetPVarFloat(playerid,"JY",P[1]);
		   SetPVarFloat(playerid,"JZ",P[2]);
		   SetPVarFloat(playerid,"Health",H);
		   SetPVarFloat(playerid,"Armour",A);
		   StoreWeaponsData(playerid);
		}
		pInfo[playerid][Spec] = 1;
		Specid[playerid] = id;
		SetPlayerInterior(playerid,GetPlayerInterior(id));
		SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(id));
		if (IsPlayerInAnyVehicle(id))
		{
		    TogglePlayerSpectating(playerid, 1);
			PlayerSpectateVehicle(playerid, GetPlayerVehicleID(id));
			
		}
		else
		{
            TogglePlayerSpectating(playerid, 1);
		    PlayerSpectatePlayer(playerid, id);
		}
		SendClientMessage(playerid,lighterblue,"You are now spectating!");
   }
   return ShowMessage(playerid, red, 1);
}

CMD:specoff(playerid, params[], help)
{
   if(pInfo[playerid][pLevel] >= 1)
   {
     if(pInfo[playerid][Spec] >= 1 || GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	 {
        CommandToAdmins(playerid,"specoff");
		TogglePlayerSpectating(playerid, 0);
		pInfo[playerid][Spec] = 0;
		SetTimerEx("Specoff",500,0,"u",playerid);
		#if SpecTextDraw == true
		TextDrawHideForPlayer(playerid, SpecGTD);
		PlayerTextDrawHide(playerid, SpecPTD);
		#endif
        return 1;
	 }
	 else return SendClientMessage(playerid,red,"You are NOT spectating!");
   }
   else return ShowMessage(playerid, red, 1);
}

CMD:akill(playerid, params[], help)
{
    if(pInfo[playerid][pLevel] >= 2)
	{
        new id;
        if(sscanf(params, "u", id)) return SendClientMessage(playerid, yellow, "Usage: /akill <Player ID/Part of Nick>");
        if(pInfo[playerid][pLevel] <= pInfo[id][pLevel]) return ShowMessage(playerid, red, 6);
        if(!IsPlayerConnected(id)) return ShowMessage(playerid, red, 2);
        CommandToAdmins(playerid,"akill");
		SetPlayerHealth(id,0);
		format(Jstring,sizeof(Jstring),"Admin '%s' has Killed you",GetName(playerid));
		SendClientMessage(id,red,Jstring);
		format(Jstring,sizeof(Jstring),"You have Killed '%s'",GetName(id));
		SendClientMessage(playerid,yellow,Jstring);
		return 1;
    }
    else return ShowMessage(playerid, red, 1);
}

CMD:aka(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 2)
	{
		new id,Ffile[128],string[128];
	    if(sscanf(params, "u", id)) return SendClientMessage(playerid, yellow, "Usage: /aka <Player ID/Part of Nick>");
	 	if(IsPlayerConnected(id))
	    {
            strdel(aka,0,256);
            CommandToAdmins(playerid,"aka");
  		  	GetPlayerIp(id,playerIP,16);
  		  	format(Ffile,sizeof(Ffile),"JLadmin/Logs/aka.ini");
  		  	INI_ParseFile(Ffile,"GetAkaLog");
			format(Jstring,sizeof(Jstring),"__Player %s(ID: %d)'s Nick names__", GetName(id), id);
   	        SendClientMessage(playerid,green,Jstring);
		    if(strlen(aka) > 70)
			{
		        strmid(string,aka,0,75);
		        format(Jstring,sizeof(Jstring),"IP: %s - Nicks: %s", playerIP , string);
				SendClientMessage(playerid,yellow,Jstring);
				strmid(string,aka,75,sizeof(aka));
				format(Jstring, sizeof(Jstring),"%s", string);
				SendClientMessage(playerid,yellow,Jstring);
			}
			else
			{
			    format(string,sizeof(string),"IP: %s - Nicks: %s", playerIP, aka);
				SendClientMessage(playerid,yellow,string);
		    }
	        return 1;
		}
		else return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:delaka(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 4)
	{
		new id,ip[16],Ffile[128];
	    if(sscanf(params, "u", id)) return SendClientMessage(playerid, yellow, "Usage: /delaka <Player ID/Part of Nick>");
	 	if(IsPlayerConnected(id))
	    {
            CommandToAdmins(playerid,"delaka");
            strdel(aka,0,256);
  		  	GetPlayerIp(id,ip,16);
  		  	format(Ffile,sizeof(Ffile),"JLadmin/Logs/aka.ini");
  		  	new INI:AKA = INI_Open(Ffile);
			INI_RemoveEntry(AKA, ip);
			INI_Close(AKA);
			format(Jstring,sizeof(Jstring),"You have deleted Player %s(ID: %d)'s all nick names from the aka log", GetName(id), id);
   	        SendClientMessage(playerid,orange,Jstring);
	        return 1;
		}
		else return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:resetaka(playerid,params[])
{
   return cmd_delaka(playerid,params);
}

CMD:setworld(playerid,params[])
{
      if(pInfo[playerid][pLevel] >= 2)
      {
           new id, world;
           if(sscanf(params, "ui", id, world)) return SendClientMessage(playerid, yellow, "Usage: /setworld <Player ID> <Virtual world ID>");
           CommandToAdmins(playerid,"setworld");
           format(Jstring,sizeof(Jstring),"You have set %s's virtual world to '%d'",GetName(id),world);
		   SendClientMessage(playerid,yellow,Jstring);
		   format(Jstring,sizeof(Jstring),"Admin %s has set your virtual world to '%d'",GetName(playerid),world);
		   SendClientMessage(id,yellow,Jstring);
		   SetPlayerVirtualWorld(id,world);
		   return 1;
      }
      else return ShowMessage(playerid, red, 1);
}

CMD:setinterior(playerid,params[])
{
      if(pInfo[playerid][pLevel] >= 2)
      {
           new id, int;
           if(sscanf(params, "ui",id,int)) return SendClientMessage(playerid, yellow, "Usage: /setinterior <Player ID> <Interior ID>");
           CommandToAdmins(playerid,"setinterior");
           format(Jstring,sizeof(Jstring),"You have set %s's Interior to '%d'",GetName(id),int);
		   SendClientMessage(playerid,yellow,Jstring);
		   format(Jstring,sizeof(Jstring),"Admin %s has set your interior to '%d'",GetName(playerid),int);
		   SendClientMessage(id,yellow,Jstring);
		   SetPlayerInterior(id,int);
		   return 1;
      }
      else return ShowMessage(playerid, red, 1);
}

CMD:setgravity(playerid, params[])
{
        if(pInfo[playerid][pLevel] >= 4)
        {
           new Float:gravity;
           if(sscanf(params, "f", gravity)) return SendClientMessage(playerid, yellow, "Usage: /setgravity <Gravity>(standard 0.008)");
           CommandToAdmins(playerid,"Setgravity");
		   format(Jstring,sizeof(Jstring),"Admin %s has changed server Gravity to '%0.3f'",GetName(playerid),gravity);
		   SendClientMessageToAll(yellow,Jstring);
		   SetGravity(gravity);
		   return 1;
		}
		else return ShowMessage(playerid, red, 1);
}

CMD:eject(playerid, params[], help)
{
    if(pInfo[playerid][pLevel] >= 3)
	{
        new id,Float:x, Float:y, Float:z;
        if(sscanf(params, "u", id)) return SendClientMessage(playerid, yellow, "Usage: /eject <Player ID/Part of Nick>");
        if(!IsPlayerConnected(id)) return ShowMessage(playerid, red, 2);
        if(!IsPlayerInAnyVehicle(id)) return ShowMessage(playerid, red, 5);
        if(pInfo[playerid][pLevel] <= pInfo[id][pLevel] && playerid != id) return ShowMessage(playerid, red, 6);
        CommandToAdmins(playerid,"eject");
		GetPlayerPos(id,x,y,z);
		format(Jstring,sizeof(Jstring),"You ejected '%s' from vehicle",GetName(id));
		SendClientMessage(playerid,yellow,Jstring);
		SetPlayerPos(id,x,y,z+3);
		return 1;
    }
    else return ShowMessage(playerid, red, 1);
}

CMD:force(playerid,params[])
{
      if(pInfo[playerid][pLevel] >= 3)
      {
           new id;
           if(sscanf(params, "u", id)) return SendClientMessage(playerid, yellow, "Usage: /force <Player ID>  will force a player to the class selection!");
           if(!IsPlayerConnected(id)) return ShowMessage(playerid, red, 2);
           if(pInfo[playerid][pLevel] <= pInfo[id][pLevel] && playerid != id) return ShowMessage(playerid, red, 6);
           CommandToAdmins(playerid,"force");
           format(Jstring,sizeof(Jstring),"You have forced '%s' to class selection",GetName(id));
		   SendClientMessage(playerid,yellow,Jstring);
		   format(Jstring,sizeof(Jstring),"Admin '%s' has forced you to class selection",GetName(playerid));
		   SendClientMessage(id,yellow,Jstring);
		   SetPlayerHealth(id,0);
		   ForceClassSelection(id);
		   return 1;
      }
      else return ShowMessage(playerid, red, 1);
}

CMD:burn(playerid,params[])
{
	  if(pInfo[playerid][pLevel] >= 1)
      {
           new id,Float:x, Float:y, Float:z;
           if(sscanf(params, "u", id)) return SendClientMessage(playerid, yellow, "Usage: /burn <Player ID>");
           if(!IsPlayerConnected(id)) return ShowMessage(playerid, red, 2);
           if(pInfo[playerid][pLevel] <= pInfo[id][pLevel] && playerid != id) return ShowMessage(playerid, red, 6);
           CommandToAdmins(playerid,"burn");
           format(Jstring,sizeof(Jstring),"You have burnt '%s'",GetName(id));
		   SendClientMessage(playerid,yellow,Jstring);
		   GetPlayerPos(id, x, y, z);
		   CreateExplosion(x, y , z + 2, 1, 10);
		   return 1;
      }
      else return ShowMessage(playerid, red, 1);
}

CMD:burnall(playerid,params[])
{
	  if(pInfo[playerid][pLevel] >= 4)
	  {
	       new Float:x, Float:y, Float:z;
	       format(Jstring,sizeof(Jstring),"Admin '%s' has burnet all players",GetName(playerid));
		   SendClientMessageToAll(yellow,Jstring);
		   CommandToAdmins(playerid,"burnall");
		   foreach(Player, i)
		   {
			   if (playerid != i && pInfo[i][pLevel] <= pInfo[playerid][pLevel])
			   {
				   GetPlayerPos(i, x, y, z);
				   CreateExplosion(x, y , z + 2, 1, 10);
			   }
		   }
		   return 1;
	  }
	  else return ShowMessage(playerid, red, 1);
}

CMD:slap(playerid,params[])
{
	  if(pInfo[playerid][pLevel] >= 1)
      {
           new id,Float:x, Float:y, Float:z, Float:Health;
           if(sscanf(params, "u", id)) return SendClientMessage(playerid, yellow, "Usage: /slap <Player ID>");
           if(!IsPlayerConnected(id)) return ShowMessage(playerid, red, 2);
           if(pInfo[playerid][pLevel] <= pInfo[id][pLevel] && playerid != id) return ShowMessage(playerid, red, 6);
           CommandToAdmins(playerid,"slap");
           format(Jstring,sizeof(Jstring),"You have slapped '%s'",GetName(id));
		   SendClientMessage(playerid,yellow,Jstring);
		   GetPlayerHealth(id,Health);
		   SetPlayerHealth(id,Health-15);
		   GetPlayerPos(id, x, y, z);
		   SetPlayerPos(id,x,y,z+6);
		   return 1;
      }
      else return ShowMessage(playerid, red, 1);
}

CMD:slapall(playerid,params[])
{
	  if(pInfo[playerid][pLevel] >= 4)
      {
           new Float:x, Float:y, Float:z, Float:Health;
           format(Jstring,sizeof(Jstring),"Admin '%s' has slapped all players",GetName(playerid));
		   SendClientMessageToAll(yellow,Jstring);
		   CommandToAdmins(playerid,"slapall");
		   foreach(Player, i)
		   {
			   if (playerid != i && pInfo[i][pLevel] < pInfo[playerid][pLevel])
			   {
				   GetPlayerHealth(i,Health);
				   SetPlayerHealth(i,Health-15);
				   GetPlayerPos(i, x, y, z);
				   SetPlayerPos(i,x,y,z+6);
			   }
		   }
		   return 1;
      }
      else return ShowMessage(playerid, red, 1);
}

CMD:explode(playerid,params[])
{
	  if(pInfo[playerid][pLevel] >= 1)
      {
           new id,Float:x, Float:y, Float:z;
           if(pInfo[playerid][pLevel] <= pInfo[id][pLevel] && playerid != id) return ShowMessage(playerid, red, 6);
           if(sscanf(params, "u", id)) return SendClientMessage(playerid, yellow, "Usage: /explode <Player ID>");
           if(!IsPlayerConnected(id)) return ShowMessage(playerid, red, 2);
           CommandToAdmins(playerid,"explode");
           format(Jstring,sizeof(Jstring),"You have exploded '%s'",GetName(id));
		   SendClientMessage(playerid,yellow,Jstring);
		   GetPlayerPos(id, x, y, z);
		   CreateExplosion(x, y , z, 4,10.0);
		   return 1;
      }
      else return ShowMessage(playerid, red, 1);
}

CMD:explodeall(playerid,params[])
{
	  if(pInfo[playerid][pLevel] >= 4)
      {
           new Float:x, Float:y, Float:z;
           format(Jstring,sizeof(Jstring),"Admin '%s' has exploded all players",GetName(playerid));
		   SendClientMessageToAll(yellow,Jstring);
		   CommandToAdmins(playerid,"explodeall");
		   foreach(Player, i)
		   {
			   if (playerid != i && pInfo[i][pLevel] < pInfo[playerid][pLevel])
			   {
				   GetPlayerPos(i, x, y, z);
				   CreateExplosion(x, y , z , 7,10.0);
			   }
		   }
		   return 1;
      }
      else return ShowMessage(playerid, red, 1);
}

CMD:explodecars(playerid,params[])
{
	  if(pInfo[playerid][pLevel] >= 5)
      {
           new Float:x, Float:y, Float:z;
           format(Jstring,sizeof(Jstring),"Admin '%s' has exploded all vehicles",GetName(playerid));
		   SendClientMessageToAll(yellow,Jstring);
		   CommandToAdmins(playerid,"explodecars");
		   for(new i=0; i<MAX_VEHICLES; i++)
		   {
			   GetVehiclePos(i,x,y,z);
			   CreateExplosion(x, y , z + 2, 0,10.0);
		   }
		   return 1;
      }
      else return ShowMessage(playerid, red, 1);
}

CMD:killall(playerid,params[])
{
	  if(pInfo[playerid][pLevel] >= 5)
      {
           format(Jstring,sizeof(Jstring),"Admin '%s' has killed all players",GetName(playerid));
		   SendClientMessageToAll(yellow,Jstring);
		   CommandToAdmins(playerid,"killall");
		   foreach(Player, i)
		   {
			   if (playerid != i && pInfo[i][pLevel] <= pInfo[playerid][pLevel])
			   {
			   		SetPlayerHealth(i,0);
			   }
		   }
		   return 1;
      }
      else return ShowMessage(playerid, red, 1);
}

CMD:god(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 2)
	{
    	if(pInfo[playerid][GodMode] == 0)
		{
   	    	pInfo[playerid][GodMode] = true;
    	    SetPlayerHealth(playerid,0x7F800000);
    	    CommandToAdmins(playerid,"god (Turned on)");
           	SendClientMessage(playerid,lighterblue,"God Mode ON");
		}
		else
		{
   	        pInfo[playerid][GodMode] = false;
       	    SendClientMessage(playerid,red,"God Mode OFF");
        	SetPlayerHealth(playerid, 99);
        	CommandToAdmins(playerid,"god (Turned off)");
		}
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:godcar(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 2)
	{
    	if(pInfo[playerid][VGod] == 0)
		{
            if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,red,"You can only use this command if you are inside a vehicle!");
   	    	pInfo[playerid][VGod] = true;
   	    	SetPVarInt(playerid,"CarID",GetPlayerVehicleID(playerid));
   	    	RepairVehicle(GetPlayerVehicleID(playerid));
    	    SetVehicleHealth(GetPlayerVehicleID(playerid),20000);
           	SendClientMessage(playerid,lighterblue,"Vehicle no damage Mode ON");
		}
		else
		{
   	        pInfo[playerid][VGod] = false;
       	    SendClientMessage(playerid,red,"Vehicle no damage Mode OFF");
        	SetVehicleHealth(GetPlayerVehicleID(playerid),990);
		}
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:flip(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 2)
	{
        new id, Veh, Float:X, Float:Y, Float:Z, Float:A;
		sscanf(params, "u", id);
	    if (isnull(params))
		{
		    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,red,"You need to be inside a vehicle to use this command!");
		    CommandToAdmins(playerid,"flip");
			GetPlayerPos(playerid, X, Y, Z);
			Veh = GetPlayerVehicleID(playerid);
			GetVehicleZAngle(Veh, A);
			SetVehiclePos(Veh, X, Y, Z);
			SetVehicleZAngle(Veh, A);
			SetVehicleHealth(Veh,1000.0);
			return SendClientMessage(playerid, yellow,"Vehicle Flipped! /flip <PlayerID> to flip players vehicle");
		}
		else if(IsPlayerConnected(id))
		{
                if(!IsPlayerInAnyVehicle(id)) return ShowMessage(playerid, red, 5);
                CommandToAdmins(playerid,"flip");
			    GetPlayerPos(id, X, Y, Z);
				Veh = GetPlayerVehicleID(id);
				GetVehicleZAngle(Veh, A);
				SetVehiclePos(Veh, X, Y, Z);
				SetVehicleZAngle(Veh, A);
				SetVehicleHealth(Veh,1000.0);
				format(Jstring,sizeof(Jstring),"Admin '%s' has Flipped your Vehicle",GetName(playerid));
				SendClientMessage(id,lighterblue,Jstring);
				format(Jstring,sizeof(Jstring),"You have Flipped %s's Vehicle", GetName(id));
				return SendClientMessage(playerid, yellow,Jstring);
		}
		return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:jetpack(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 2)
	{
        new id;
		sscanf(params, "u", id);
	    if (isnull(params))
		{
            SetPlayerSpecialAction(playerid, 2);
            CommandToAdmins(playerid,"jetpack");
			return SendClientMessage(playerid, yellow,"Jetpack spawned! /Jetpack <PlayerID>");
		}
		else if(IsPlayerConnected(id))
		{
                SetPlayerSpecialAction(id, 2);
                CommandToAdmins(playerid,"jetpack");
				format(Jstring,sizeof(Jstring),"Admin '%s' has given you a Jetpack",GetName(playerid));
				SendClientMessage(id,lighterblue,Jstring);
				format(Jstring,sizeof(Jstring),"You have given '%s' a Jetpack", GetName(id));
				return SendClientMessage(playerid, yellow,Jstring);
		}
		return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:givejetpack(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 2)
	{
        new id;
        if(sscanf(params, "u", id)) return SendClientMessage(playerid, yellow, "Usage: /Givejetpack <Player ID>");
        if(!IsPlayerConnected(id)) return ShowMessage(playerid, red, 2);
        SetPlayerSpecialAction(id, 2);
        CommandToAdmins(playerid,"givejetpack");
		format(Jstring,sizeof(Jstring),"Admin '%s' has given you a Jetpack",GetName(playerid));
		SendClientMessage(id,lighterblue,Jstring);
		format(Jstring,sizeof(Jstring),"You have given '%s' a Jetpack", GetName(id));
		return SendClientMessage(playerid, yellow,Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:asay(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 1)
    {
        if(sscanf(params, "s[128]",Jstring)) return SendClientMessage(playerid,yellow,"USAGE: /asay <text>");
        CommandToAdmins(playerid,"asay");
		format(Jstring,sizeof(Jstring),"{FF0000}Admin %s(%d):{00FFFF} %s",GetName(playerid),playerid,Jstring);
		return SendClientMessageToAll(-1,Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}
CMD:vget(playerid,params[])
{
	return cmd_getvehicle(playerid,params);
}

CMD:getvehicle(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 2)
	{
	    new vid, Float:x, Float:y, Float:z;
		if(sscanf(params, "i", vid)) return SendClientMessage(playerid, yellow, "Usage: /Getvehicle <VehicleID>");
		CommandToAdmins(playerid,"getvehicle");
		GetPlayerPos(playerid,x,y,z);
		SetVehiclePos(vid,x+3,y,z);
		SetPlayerVirtualWorld(playerid,GetVehicleVirtualWorld(vid));
		format(Jstring,sizeof(Jstring),"You have teleported Vehicle ID '%d's to your Position!", vid);
		return SendClientMessage(playerid,yellow,Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:vgoto(playerid,params[])
{
	return cmd_gotovehicle(playerid,params);
}

CMD:gotovehicle(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 2)
	{
	    new vid, Float:x, Float:y, Float:z;
		if(sscanf(params, "i", vid)) return SendClientMessage(playerid, yellow, "Usage: /Gototvehicle <VehicleID>");
		CommandToAdmins(playerid,"gotovehicle");
		GetVehiclePos(vid,x,y,z);
		SetPlayerPos(playerid,x+3,y,z);
		format(Jstring,sizeof(Jstring),"You have been teleported Vehicle ID '%d' Position!", vid);
		return SendClientMessage(playerid,yellow,Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:fakechat(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 3)
	{
		new id;
	    if(sscanf(params, "us[128]", id, Jstring)) return SendClientMessage(playerid, yellow, "Usage: /fakechat <PlayerID/Part of Nick> <Chat Message>");
        if(IsPlayerConnected(id))
		{
			CallRemoteFunction("OnPlayerText", "is", id, Jstring);
			CommandToAdmins(playerid,"fakechat");
			return SendClientMessage(playerid,yellow,"-Fake chat has been message sent!-");
	    }
		else return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:fakecmd(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 4)
	{
		new id;
	    if(sscanf(params, "us[128]", id, Jstring)) return SendClientMessage(playerid, yellow, "Usage: /fakechat <PlayerID/Part of Nick> <Chat Message> will send a fake chat message!");
        if(IsPlayerConnected(id))
		{
            if(!strcmp(Jstring, "/", .length = 1))
            {
				CallRemoteFunction("OnPlayerCommandText", "is", id, Jstring);
				CommandToAdmins(playerid,"fakecmd");
				return SendClientMessage(playerid,yellow,"-Fake command has been message sent!-");
			}
			else return SendClientMessage(playerid,red,"Error: The command must include the ' / '");
	    }
		else return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:fakekill(playerid,params[])
{
	return cmd_fakedeath(playerid,params);
}
CMD:fakedeath(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 3)
	{
		new id,killed,reason;
	    if(sscanf(params, "uui", id, killed, reason)) return SendClientMessage(playerid, yellow, "Usage: /fakekill <Killer ID/Part of Nick> <Killed ID/Part of Nick> <Reson ID/weapon>");
        if(IsPlayerConnected(id))
		{
            if (reason > 0 && reason < 19 || reason > 21 && reason < 47)
            {
            if(!IsPlayerConnected(killed)) return SendClientMessage(playerid, red, "Killed id not connected!");
			SendDeathMessage(id,killed,reason);
			CommandToAdmins(playerid,"fakedeath");
			return SendClientMessage(playerid,yellow,"-Fake death message has been message sent!-");
			}
			else return SendClientMessage(playerid,red,"Invalid Reason ID");
	    }
		else return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:healall(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 4)
	{
		foreach(Player, i)
		{
		PlayerPlaySound(i,1057,0.0,0.0,0.0);
		SetPlayerHealth(i,99.0);
		}
		CommandToAdmins(playerid,"healall");
		format(Jstring,sizeof(Jstring),"Admin '%s' has Healed all players", GetName(playerid));
		return SendClientMessageToAll(yellow, Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}


CMD:spawnall(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 4)
	{
		foreach(Player, i)
		{
		if(playerid != i && pInfo[playerid][Spawned] == 1)
		{
		PlayerPlaySound(i,1057,0.0,0.0,0.0);
		SetPlayerPos(i, 0.0, 0.0, 0.0);
		SpawnPlayer(i);
		}
		}
		CommandToAdmins(playerid,"spawnall");
		format(Jstring,sizeof(Jstring),"Admin '%s' has spawned all players", GetName(playerid));
		return SendClientMessageToAll(yellow, Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:armourall(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 4)
	{
		foreach(Player, i)
		{
		PlayerPlaySound(i,1057,0.0,0.0,0.0);
		SetPlayerArmour(i,99.0);
		}
		CommandToAdmins(playerid,"armourall");
		format(Jstring,sizeof(Jstring),"Admin '%s' has armoured all players", GetName(playerid));
		return SendClientMessageToAll(yellow, Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:freezeall(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 4)
	{
		foreach(Player, i)
		{
		if(playerid != i)
		{
			TogglePlayerControllable(i,false);
			pInfo[i][Frozen] = 1;
		}
		}
		CommandToAdmins(playerid,"freezeall");
		format(Jstring,sizeof(Jstring),"Admin '%s' has frozen all players", GetName(playerid));
		return SendClientMessageToAll(yellow, Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:unfreezeall(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 4)
	{
		foreach(Player, i)
		{
		TogglePlayerControllable(i,true);
		pInfo[i][Frozen] = 0;
		}
		CommandToAdmins(playerid,"unfreezeall");
		format(Jstring,sizeof(Jstring),"Admin '%s' has unfrozen all players", GetName(playerid));
		return SendClientMessageToAll(yellow, Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:kickall(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 5)
	{
        new year,month,day,hour,mins,sec;
		getdate(year, month, day);
		gettime(hour,mins,sec);
		CommandToAdmins(playerid,"kickall");
        format(Jstring,sizeof(Jstring),"Admin '%s' has kicked all players", GetName(playerid));
		SendClientMessageToAll(yellow, Jstring);
		format(Jstring,sizeof(Jstring),"[IMPORTANT] %s has kicked ALL PLAYERS on %d/%d/%d at %d:%d:%d",GetName(playerid),day, month, year,hour, mins, sec);
		WriteToLog(Jstring,"KickLog");
		SetTimerEx("Kickallplayers",200,false,"d", playerid);
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:setallskin(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 4)
	{
	    new id;
		if(sscanf(params, "i", id)) return SendClientMessage(playerid, yellow, "Usage: /Setallskin <SkinID>");
		if(id < 0 || id > 299) return SendClientMessage(playerid, red, "Invaild Skin ID");
		foreach(Player, i)
		{
		    SetPVarInt(i, "OldSkin", GetPlayerSkin(i));
			SetPlayerSkin(i,id);
		}
		CommandToAdmins(playerid,"setallskin");
		format(Jstring,sizeof(Jstring),"You have set everyone's Skin to '%d'. also you can use /unsetallskin to set their nomal skins back!", id);
		SendClientMessage(playerid,yellow,Jstring);
		format(Jstring,sizeof(Jstring),"Admin '%s' has set everyone's Skin to '%d'", GetName(playerid), id);
		return SendClientMessageToAll(yellow, Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:unsetallskin(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 4)
	{
		foreach(Player, i)
		{
		     SetPlayerSkin(i,GetPVarInt(i,"OldSkin"));
		}
		CommandToAdmins(playerid,"unsetallskin");
		format(Jstring,sizeof(Jstring),"Admin '%s' has set all players to default skins!", GetName(playerid));
		return SendClientMessageToAll(yellow, Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:ejectall(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 4)
	{
        CommandToAdmins(playerid,"ejectall");
        format(Jstring,sizeof(Jstring),"Admin '%s' has ejected all players from vehicles!", GetName(playerid));
		SendClientMessageToAll(yellow, Jstring);
		new Float:x, Float:y, Float:z;
		foreach(Player, i)
		{
		if(pInfo[playerid][pLevel] > pInfo[i][pLevel])
		{
		    GetPlayerPos(i,x,y,z);
			SetPlayerPos(i,x,y,z+3);
		}
		}
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:setallworld(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 4)
	{
	    new id;
		if(sscanf(params, "i", id)) return SendClientMessage(playerid, yellow, "Usage: /Setallworld <WorldID>");
		CommandToAdmins(playerid,"setallworld");
		foreach(Player, i)
		{
		      SetPlayerVirtualWorld(i,id);
		}
		format(Jstring,sizeof(Jstring),"You have set every players Virtual world to '%d'", id);
		SendClientMessage(playerid,yellow,Jstring);
		format(Jstring,sizeof(Jstring),"Admin '%s' has set everyone's virtual world to '%d'", GetName(playerid), id);
		return SendClientMessageToAll(yellow, Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:setallinterior(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 4)
	{
	    new id;
		if(sscanf(params, "i", id)) return SendClientMessage(playerid, yellow, "Usage: /Setallinterior <Interiror ID>");
		CommandToAdmins(playerid,"setallinterior");
		foreach(Player, i)
		{
		      SetPlayerInterior(i,id);
		}
		format(Jstring,sizeof(Jstring),"You have set every players interior to '%d'", id);
		SendClientMessage(playerid,yellow,Jstring);
		format(Jstring,sizeof(Jstring),"Admin '%s' has set everyone's interior to '%d'", GetName(playerid), id);
		return SendClientMessageToAll(yellow, Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:setallscore(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 5)
	{
	    new score;
		if(sscanf(params, "i", score)) return SendClientMessage(playerid, yellow, "Usage: /Setallscore <Score>");
		CommandToAdmins(playerid,"setallscore");
		foreach(Player, i)
		{
               SetPVarInt(i, "OldScore", GetPlayerScore(i));
			   SetPlayerScore(i,score);
		}
		format(Jstring,sizeof(Jstring),"You have set every players score to '%d'. if you want give their scores back you can use /setallscoreback", score);
		SendClientMessage(playerid,yellow,Jstring);
		format(Jstring,sizeof(Jstring),"Admin '%s' has set all players score to '%d'", GetName(playerid), score);
		return SendClientMessageToAll(yellow, Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:setallcash(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 4)
	{
	    new cash;
		if(sscanf(params, "i", cash)) return SendClientMessage(playerid, yellow, "Usage: /Setallcash <Cash>");
		CommandToAdmins(playerid,"setallcash");
		foreach(Player, i)
		{
                SetPVarInt(i, "OldCash", GetPlayerMoney(i));
                ResetPlayerMoney(i);
				GivePlayerMoney(i, cash);
		}
		format(Jstring,sizeof(Jstring),"You have set every players cash to '%d'. if you want give their cash back you can use /setallcashback", cash);
		SendClientMessage(playerid,yellow,Jstring);
		format(Jstring,sizeof(Jstring),"Admin '%s' has set all players cash to '%d'", GetName(playerid), cash);
		return SendClientMessageToAll(yellow, Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:setallscoreback(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 5)
	{
		foreach(Player, i)
		{
			if(GetPVarInt(i,"OldScore") > 0)
			{
				SetPlayerScore(i,GetPVarInt(i,"OldScore"));
				SetPVarInt(i, "OldScore", 0);
			}
		}
		CommandToAdmins(playerid,"setallscoreback");
		format(Jstring,sizeof(Jstring),"Admin '%s' has restored all players score back!", GetName(playerid));
		return SendClientMessageToAll(yellow, Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:setallcashback(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 4)
	{
		foreach(Player, i)
		{
			if(GetPVarInt(i,"OldCash") > 0)
			{
                ResetPlayerMoney(i);
				GivePlayerMoney(i,GetPVarInt(i,"OldCash"));
				SetPVarInt(i, "OldCash", 0);
			}
		}
		CommandToAdmins(playerid,"setallcashback");
		format(Jstring,sizeof(Jstring),"Admin '%s' has restored all players cash!", GetName(playerid));
		return SendClientMessageToAll(yellow, Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:muteall(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 4)
	{
		foreach(Player, i)
		{
		if(playerid != i)
		{
		pInfo[i][Muted] = 1;
		}
		}
		CommandToAdmins(playerid,"muteall");
		format(Jstring,sizeof(Jstring),"Admin '%s' has muted all players", GetName(playerid));
		return SendClientMessageToAll(yellow, Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:unmuteall(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 4)
	{
		foreach(Player, i)
		{
		if(playerid != i)
		{
		pInfo[i][Muted] = 0;
		}
		}
		CommandToAdmins(playerid,"unmuteall");
		format(Jstring,sizeof(Jstring),"Admin '%s' has unmuted all players", GetName(playerid));
		return SendClientMessageToAll(yellow, Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:hide(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 1)
	{
    	if(pInfo[playerid][AHide] == 0)
		{
   	    	pInfo[playerid][AHide] = true;
           	SendClientMessage(playerid,lighterblue,"You have been hidden from the administrators list. Type /hide again to visible on admin list");
		}
		else
		{
   	        pInfo[playerid][AHide] = false;
       	    SendClientMessage(playerid,lighterblue,"You are now visible on administrators list");
		}
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:hideme(playerid, params[])
{
  if(pInfo[playerid][pLevel] >= 2)
  {
    if(GetPVarInt(playerid,"MapHidden") == 1) return SendClientMessage(playerid, lighterblue, "You are already hidden from the rader!");
    CommandToAdmins(playerid,"hideme");
    SetPVarInt(playerid, "pColor", GetPlayerColor(playerid));
    SetPlayerColor(playerid, GetPVarInt(playerid,"pColor"));
    SendClientMessage(playerid, lighterblue, "You are now hidden from the rader!");
    if(pInfo[playerid][NameTagHidden] == 0 && GetPVarInt(playerid,"MapHidden") == 0) pHideTimer[playerid] = SetTimerEx("HidePlayer", 5000, true, "i", playerid);
    SetPVarInt(playerid, "MapHidden", 1);
    foreach(Player, i)
    {
             SetPlayerMarkerForPlayer(i,playerid,(GetPlayerColor(playerid)& 0xFFFFFF00));
    }
    return 1;
  }
  else return ShowMessage(playerid, red, 1);
}

CMD:unhideme(playerid, params[])
{
  if(pInfo[playerid][pLevel] >= 2)
  {
    if(GetPVarInt(playerid,"MapHidden") == 0) return SendClientMessage(playerid, lighterblue, "You are not hidden from the rader. use /hideme to hide from the rader");
    CommandToAdmins(playerid,"unhideme");
    SetPlayerColor(playerid, GetPVarInt(playerid,"pColor"));
    SendClientMessage(playerid, lighterblue, "You are now visible on rader!");
    SetPVarInt(playerid, "MapHidden", 0);
    KillTimer(pHideTimer[playerid]);
    return 1;
   }
   else return ShowMessage(playerid, red, 1);
}

CMD:spam(playerid,params[])
{
		if(pInfo[playerid][pLevel] >= 4)
		{
		    if(sscanf(params, "s[128]", Jstring)) return SendClientMessage(playerid, yellow, "Usage: /Spam <Message>");
			SetPVarString(playerid,"SpamMsg",Jstring);
			ShowPlayerDialog(playerid, JDIALOGS+201, DIALOG_STYLE_LIST, "Select Messgae Color","Yellow\nWhite\nBlue\nRed\nGreen\nOrange\nPurple\nPink\nBrown\nBlack" , "Select", "Close");
			return 1;
		}
		else return ShowMessage(playerid, red, 1);
}

CMD:write(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 2)
	{
	    if(sscanf(params, "s[128]",Jstring)) return SendClientMessage(playerid, yellow, "Usage: /write <Message>");
		SetPVarString(playerid,"SpamMsg",Jstring);
		ShowPlayerDialog(playerid, JDIALOGS+202, DIALOG_STYLE_LIST, "Select Messgae Color","Yellow\nWhite\nBlue\nRed\nGreen\nOrange\nPurple\nPink\nBrown\nBlack" , "Select", "Close");
        return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:apm(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 1)
	{
			new id;
			if(sscanf(params, "us[32]", id, Jstring)) return SendClientMessage(playerid, yellow, "USAGE: /apm <playerid> <message> (Privet message as admin)");
			if(IsPlayerConnected(id))
			{
			CommandToAdmins(playerid,"apm");
			format(Jstring,sizeof(Jstring),"Admin PM: %s",Jstring);
			SendClientMessage(id, yellow, Jstring);
			format(Jstring,sizeof(Jstring),"Admin PM sent to %s(%d): %s",GetName(id),id,Jstring);
			SendClientMessage(playerid, yellow, Jstring);
			return 1;
			}
			else return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:ip(playerid, params[])
{
   return cmd_getip(playerid,params);
}

CMD:respawncars(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 2)
	{
		for(new i=0; i<MAX_VEHICLES; i++)
		{
			if(UnoccupiedVehicle(i))
			{
				SetVehicleToRespawn(i);
			}
		}
		CommandToAdmins(playerid,"respawncars");
		return SendClientMessage(playerid,yellow,"You have respawned all vehicles!");
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:fix(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 1)
	{
		if (IsPlayerInAnyVehicle(playerid))
		{
            CommandToAdmins(playerid,"fix");
			SetVehicleHealth(GetPlayerVehicleID(playerid),1000.0);
			return GameTextForPlayerEx(playerid,"Vehicle Fixed!",3000,3);
		}
		else return SendClientMessage(playerid, red, "You are not in a vehicle!");
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:repair(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 1)
	{
        new id;
		sscanf(params, "u", id);
	    if (isnull(params))
		{
		    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,red,"You need to be inside a vehicle to use this command!");
		    RepairVehicle(GetPlayerVehicleID(playerid));
		    GameTextForPlayerEx(playerid,"~G~Vehicle Repaired!",3000,3);
		    CommandToAdmins(playerid,"repair");
			return SendClientMessage(playerid, yellow,"Vehicle repaired! /repair <PlayerID/Nick> to repair players vehicle");
		}
		else if(IsPlayerConnected(id))
		{
                if(!IsPlayerInAnyVehicle(id)) return ShowMessage(playerid, red, 5);
			    RepairVehicle(GetPlayerVehicleID(id));
			    GameTextForPlayerEx(id,"~G~Vehicle Repaired!",3000,3);
				format(Jstring,sizeof(Jstring),"Admin '%s' has repaired your Vehicle",GetName(playerid));
				SendClientMessage(id,lighterblue,Jstring);
				format(Jstring,sizeof(Jstring),"You have repaired %s's Vehicle", GetName(id));
				CommandToAdmins(playerid,"repair");
				return SendClientMessage(playerid, yellow,Jstring);
		}
		return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

#if MoveSystem == true
CMD:move(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 3)
	{
		if(pInfo[playerid][Move] == 0)
		{
			TogglePlayerControllable(playerid,false);
			CommandToAdmins(playerid,"move (Turned on)");
			SetCameraBehindPlayer(playerid);
			pInfo[playerid][Move] = 1;
			SendClientMessage(playerid, yellow, "Move system turned On!");
			SendClientMessage(playerid, yellow, "Use UP/DOWN keys to move forward/back, LEFT/RIGHT key to trun Left/Right and Sprint/Jump keys to move UP/Down!");
		}
		else
		{
			TogglePlayerControllable(playerid,true);
			CommandToAdmins(playerid,"move (Turned off)");
			SetCameraBehindPlayer(playerid);
			pInfo[playerid][Move] = 0;
			SendClientMessage(playerid, yellow, "Move system turned off");
		}
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}
#endif

CMD:setkills(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 3)
	{
        new id,kill;
	    if(sscanf(params, "ui", id, kill)) return
		SendClientMessage(playerid, 0xFFFF00C8, "Usage: /Setkills <PlayerID> <kills>") ;
        if(IsPlayerConnected(id))
		{
            CommandToAdmins(playerid,"setkills");
			format(Jstring, sizeof(Jstring), "Admin %s has set your kills to '%d'",GetName(playerid),kill);
			SendClientMessage(id,lighterblue,Jstring);
			format(Jstring,sizeof(Jstring),"You have set %s's kills to %d", GetName(id), kill);
			SendClientMessage(playerid,yellow,Jstring);
   			return pInfo[id][Kills] = kill;
	    }
		else return SendClientMessage(playerid,lighterblue,"Player is NOT connected!");
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:setdeaths(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 3)
	{
        new id,dea;
	    if(sscanf(params, "ui", id, dea)) return
		SendClientMessage(playerid, 0xFFFF00C8, "Usage: /Setdeaths <PlayerID> <Deaths>") ;
        if(IsPlayerConnected(id))
		{
            CommandToAdmins(playerid,"setdeaths");
			format(Jstring, sizeof(Jstring), "Admin %s has set your Deaths to '%d'",GetName(playerid),dea);
			SendClientMessage(id,lighterblue,Jstring);
			format(Jstring,sizeof(Jstring),"You have set %s's Deaths to %d", GetName(id), dea);
			SendClientMessage(playerid,yellow,Jstring);
   			return pInfo[id][Deaths] = dea;
	    }
		else return SendClientMessage(playerid,lighterblue,"Player is NOT connected!");
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:jail(playerid, params[])
{
    if(pInfo[playerid][pLevel] >= 1)
    {
        new id, time = 0, reason[50];
        if(isnull(params)) return SendClientMessage(playerid, yellow, "Usage: /Jail <Player ID> <Minutes> <Reason>");
        sscanf(params, "uis[50]", id, time, reason);
        if(IsPlayerConnected(id) && id != playerid)
        {
            if(pInfo[id][Jailed] == 1) return SendClientMessage(playerid,red,"This player is already jailed. see /jailed");
            if(pInfo[playerid][pLevel] <= pInfo[id][pLevel]) return ShowMessage(playerid, red, 6);
            if(!isnull(reason) && time == 0)
		    format(Jstring,sizeof(Jstring),"Administrator %s has jailed player '%s' | Reason: %s",GetName(playerid),GetName(id),reason);
		    else if(!isnull(reason) && time >= 1) format(Jstring,sizeof(Jstring),"Administrator %s has jailed '%s' for %d minutes (reason: %s)",GetName(playerid),GetName(id), time, reason);
		    else if(isnull(reason) && time >= 1) format(Jstring,sizeof(Jstring),"Administrator %s has jailed '%s' for %d minutes",GetName(playerid),GetName(id), time);
		    else format(Jstring,sizeof(Jstring),"Administrator %s has jailed '%s'",GetName(playerid),GetName(id));
		    CommandToAdmins(playerid,"jail");
		    SendClientMessageToAll(red,Jstring);
		    pInfo[id][Jailed] = 1;
		    TogglePlayerControllable(id, false);
		    new Float:x, Float:y, Float:z;
			GetPlayerPos(id,x,y,z);
			SetPlayerCameraPos(id,x+7,y,z+5);
			SetPlayerCameraLookAt(id,x,y,z);
			JPlayer[id] = SetTimerEx("JailPlayer",3000,0,"d",id);
			if(GetPlayerState(id) == PLAYER_STATE_ONFOOT) SetPlayerSpecialAction(id,SPECIAL_ACTION_HANDSUP);
		    if(time >= 1)
			{
		    	Jtimer[id] = SetTimerEx("Unjail",time*1000*60,0,"u",id);
		    }
			return 1;
		}
		else return ShowMessage(playerid, red, 3);
    }
    else return ShowMessage(playerid, red, 1);
}

CMD:unjail(playerid, params[])
{
    if(pInfo[playerid][pLevel] >= 1)
    {
        new id, reason[50];
        if(isnull(params)) return SendClientMessage(playerid, yellow, "Usage: /unjail <Player ID/Part of Name> <Reason>");
        sscanf(params, "us[50]", id, reason);
        if(IsPlayerConnected(id))
        {
            if(pInfo[id][Jailed] == 0) return SendClientMessage(playerid,red,"This player is not jailed!");
            if(!isnull(reason))
		    format(Jstring,sizeof(Jstring),"You have been unjailed by admin '%s' | Reason: %s",GetName(playerid),reason);
		    else format(Jstring,sizeof(Jstring),"You have been unjailed by admin '%s'",GetName(playerid));
		    SendClientMessage(id,yellow,Jstring);
		    CommandToAdmins(playerid,"unjail");
		    format(Jstring,sizeof(Jstring),"You have unjailed '%s'",GetName(id));
			SendClientMessage(playerid,yellow,Jstring);
		    pInfo[id][Jailed] = 0;
		    TogglePlayerControllable(id, true);
		    SpawnPlayer(id);
		    KillTimer(Jtimer[id]);
			return 1;
		}
		else return ShowMessage(playerid, red, 2);
    }
    else return ShowMessage(playerid, red, 1);
}

CMD:jailed(playerid,params[])
{
   if(pInfo[playerid][pLevel] >= 1)
   {
	   new IsFrozen = 0;
	   strdel(JLstring,0,500);
	   foreach(Player, i)
	   {
	      if (pInfo[i][Jailed] == 1)
		  {
		       format(Jstring, 128, "%s(ID: %d)\n",GetName(i),i);
			   strcat(JLstring, Jstring, sizeof(JLstring));
			   IsFrozen++;
	      }
	   }
	   if (IsFrozen == 0)
	   ShowPlayerDialog(playerid,JDIALOGS+165,DIALOG_STYLE_MSGBOX,"{00FFE6}Jailed Players","{FF0000}No one  is Jailed!" ,"OK","");
	   else
	   {
	        if(IsFrozen == 1) ShowPlayerDialog(playerid,JDIALOGS+165,DIALOG_STYLE_MSGBOX,"{00FFE6}1 player is Jailed",JLstring ,"OK","");
			else format(Jstring, 128, "{00FFE6}%d players are Jailed",IsFrozen), ShowPlayerDialog(playerid,JDIALOGS+165,DIALOG_STYLE_MSGBOX,Jstring,JLstring ,"OK","");
	   }
	   strdel(JLstring,0,500);
	   return 1;
   }
   else return ShowMessage(playerid, red, 1);
}

CMD:weaponids(playerid, params[])
{
	if(pInfo[playerid][pLevel] >= 1 || IsPlayerAdmin(playerid))
	{
		ShowPlayerDialog(playerid,JDIALOGS+106,DIALOG_STYLE_MSGBOX,"Weapon id(s)",
		"{80FFFF}\nID 1  -  Brass Knuckles\nID 2  -  Golf Club\nID 3  -  Nightstick\nID 4  -  Knife\nID 5  -  Baseball Bat\nID 6  -  Shovel\nID 7  -  Pool Cue\nID 8  -  Katana\nID 9  -  Chainsaw\nID 10  -  Double ended Dildo\nID 11  -  Dildo\nID 12  -  Vibrator\nID 13  -  Silver Vibrator\nID 14  -  Flowers\nID 15  -  Grenade\nID 17  -  Tear Gas\nID 18  -  Molotov Cocktail\n"
		,"Next","");
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:nitro(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 1)
	{
		if (IsPlayerInAnyVehicle(playerid))
		{
			switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
			{
				case 417,425,430,432,441,446,435,448,449,452,453,454,457,460,461,462,463,468,469,471,472,473,476,481,487,
				488,497,509,510,511,512,513,519,520,521,522,523,537,538,539,548,553,563,569,570,577,581,586,592,593,595:
				return SendClientMessage(playerid,red,"You can not add nitro to this vehicle!");
			}
			if(GetVehicleComponentInSlot(GetPlayerVehicleID(playerid),GetVehicleComponentType(1010)) == 1010)
			return SendClientMessage(playerid,red,"You have nitro already!");
			CommandToAdmins(playerid,"nitro");
	        AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
			return PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
		}
		else return SendClientMessage(playerid, red, "You are not in a vehicle!");
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:vhealth(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 1)
	{
		new id,amount;
        if(sscanf(params, "ui",id,amount)) return SendClientMessage(playerid, yellow, "Usage: /vhealth <Player ID/Part of nick> <Amount> (0-1000)");
        if(IsPlayerConnected(id))
		{
            if(amount < 0 ) return SendClientMessage(playerid, red, "Invalid amount!");
            if(!IsPlayerInAnyVehicle(id)) return ShowMessage(playerid, red, 5);
			format(Jstring, sizeof(Jstring), "You have set %s's Vehicle Health to '%d'", GetName(id), amount);
			SendClientMessage(playerid,yellow,Jstring);
			format(Jstring,sizeof(Jstring),"Admin '%s' has set your Vehicle's Health to '%d'", GetName(playerid), amount);
			SendClientMessage(id,yellow,Jstring);
			SetVehicleHealth(GetPlayerVehicleID(id), amount);
			CommandToAdmins(playerid,"vhealth");
			return 1;
	    }
		else return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:carhealth(playerid,params[])
{
    return cmd_vhealth(playerid,params);
}

CMD:vehiclehealth(playerid,params[])
{
    return cmd_carhealth(playerid,params);
}

CMD:fixcarint(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 1)
	{
	    if(IsPlayerInAnyVehicle(playerid))
	    {
    	  LinkVehicleToInterior(GetPlayerVehicleID(playerid),GetPlayerInterior(playerid));
    	  SendClientMessage(playerid,yellow, "Your have set your vehicle Interior to your current Interior");
    	  CommandToAdmins(playerid,"fixcarint");
	      return 1;
	    }
	    else return ShowMessage(playerid, red, 5);
    }
    else return ShowMessage(playerid, red, 1);
}

CMD:warn(playerid, params[])
{
    if(pInfo[playerid][pLevel] >= 1)
    {
        new id,reason[50];
        if(sscanf(params, "us[50]", id,reason)) return SendClientMessage(playerid, yellow, "Usage: /warn <Player ID/Part of Name> <Reason>");
        if(id == playerid) return SendClientMessage(playerid, red, "You can not warn yourself!");
        if(IsPlayerConnected(id))
		{
		    pInfo[id][Warns]++;
		    CommandToAdmins(playerid,"warn");
		    if(pInfo[id][Warns] > 2)
			{
                 format(Jstring,sizeof(Jstring),"Administrator '%s' has kicked '%s' for %s | Warnings: %d/%d |",GetName(playerid),GetName(id),reason,pInfo[id][Warns],MAX_WARNS);
				 SendClientMessageToAll(red,Jstring);
			     SetTimerEx("KickPlayer",200,false,"d", id);
			     return 1;
			}
			format(Jstring,sizeof(Jstring),"Administrator '%s' has given '%s' a Warning | Reason: %s |Warnings: %d/%d|",GetName(playerid),GetName(id),reason,pInfo[id][Warns],MAX_WARNS);
			SendClientMessageToAll(red,Jstring);
			GameTextForPlayerEx(id,"~R~Warning", 5000, 3);
			return 1;
		}
		else return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:warned(playerid,params[])
{
   if(pInfo[playerid][pLevel] >= 1)
   {
	   new Count = 0;
	   strdel(JLstring,0,500);
	   foreach(Player, i)
	   {
	      if (pInfo[i][Warns] >= 1)
		  {
		       format(Jstring, 128, "%s(ID: %d) | Warnings (%d/%d)\n",GetName(i),i,pInfo[i][Warns],MAX_WARNS);
			   strcat(JLstring, Jstring, sizeof(JLstring));
			   Count++;
	      }
	   }
	   if (Count == 0)
	   ShowPlayerDialog(playerid,JDIALOGS+165,DIALOG_STYLE_MSGBOX,"{00FFE6}Warned Players","{FF0000}No one  is Warned!" ,"OK","");
	   else
	   {
	        if(Count == 1) ShowPlayerDialog(playerid,JDIALOGS+165,DIALOG_STYLE_MSGBOX,"{00FFE6}1 player is Warned",JLstring ,"OK","");
			else format(Jstring, 128, "{00FFE6}%d players are Warned",Count), ShowPlayerDialog(playerid,JDIALOGS+165,DIALOG_STYLE_MSGBOX,Jstring,JLstring ,"OK","");
	   }
	   strdel(JLstring,0,500);
	   return 1;
   }
   else return ShowMessage(playerid, red, 1);
}


CMD:stats(playerid,params[])
{
     new id, h, m, d;
	 sscanf(params, "u", id);
	 if (isnull(params))
	 {
		new seconds = gettime() - pInfo[playerid][ConnectedTime] + pInfo[playerid][TotalSecs];
		format(Jstring, sizeof(Jstring), "_Statistics for '%s'_",GetName(playerid));
		SendClientMessage(playerid, green, Jstring);
		format(Jstring, sizeof(Jstring), "Score: %d | Money: $%d | Kills: %d | Deaths: %d | Ratio: %0.2f | Total spent Time: %s", GetPlayerScore(playerid), GetPlayerMoney(playerid), pInfo[playerid][Kills], pInfo[playerid][Deaths], Float:pInfo[playerid][Kills]/Float:pInfo[playerid][Deaths], ConvertTime(seconds,m,h,d));
		return SendClientMessage(playerid, yellow, Jstring);
     }
	 else if(IsPlayerConnected(id))
	 {
        new seconds = gettime() - pInfo[id][ConnectedTime] + pInfo[id][TotalSecs];
		format(Jstring, sizeof(Jstring), "_Statistics for '%s'_",GetName(id));
		SendClientMessage(playerid, green, Jstring);
		format(Jstring, sizeof(Jstring), "Score: %d | Money: $%d | Kills: %d | Deaths: %d | Ratio: %0.2f | Total spent Time: %s", GetPlayerScore(id), GetPlayerMoney(id), pInfo[id][Kills], pInfo[id][Deaths], Float:pInfo[id][Kills]/Float:pInfo[id][Deaths], ConvertTime(seconds,m,h,d));
		return SendClientMessage(playerid, yellow, Jstring);
     }
	 else return ShowMessage(playerid, red, 2);
}

CMD:status(playerid,params[])
{
  return cmd_stats(playerid,params);
}

CMD:changepassword(playerid,params[])
{
	if(pInfo[playerid][Logged] == 1)
	{
		new pass[25],file[256], buf[145];
		if(sscanf(params, "s[25]", pass)) return SendClientMessage(playerid, yellow, "Usage: /Changepassword <New Password>");
		if(strlen(pass) < 3 || strlen(pass) > 20) return SendClientMessage(playerid,red,"Error: Password lenght must be between 3 - 20 chracters!");
        WP_Hash(buf, sizeof(buf), pass);
        format(file, 256, ACCOUNTS_PATH, GetName(playerid));
		new INI:ACCOUNT = INI_Open(file);
		INI_WriteString(ACCOUNT, "Password", buf);
		INI_Close(ACCOUNT);
        format(Jstring, sizeof(Jstring),"Your password has been successfully changed to '%s'",pass);
		return SendClientMessage(playerid,yellow,Jstring);
	}
	else return ShowMessage(playerid, red, 4);
}

CMD:changepass(playerid,params[])
{
	return cmd_changepassword(playerid,params);
}

CMD:setpassword(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 4)
	{
		new id, pass[25],file[256], buf[145];
		if(sscanf(params, "us[25]", id,pass)) return SendClientMessage(playerid, yellow, "Usage: /Setpassword <Player ID/Part of Name> <New Password>");
		if(pInfo[id][Logged] == 0) return SendClientMessage(playerid, yellow, "Error: Player is NOT logged in!");
		if(strlen(pass) < 3 || strlen(pass) > 20) return SendClientMessage(playerid,red,"Error: Password lenght must be between 3 - 20 chracters!");
		CommandToAdmins(playerid,"setpassword");
        WP_Hash(buf, sizeof(buf), pass);
        format(file, 256, ACCOUNTS_PATH, GetName(id));
		new INI:ACCOUNT = INI_Open(file);
		INI_WriteString(ACCOUNT, "Password", buf);
		INI_Close(ACCOUNT);
		format(Jstring, sizeof(Jstring),"You have changed %s's password to '%s'",GetName(id),pass);
		SendClientMessage(playerid,yellow,Jstring);
        format(Jstring, sizeof(Jstring),"Admin '%s' has changed your password to '%s'",GetName(playerid),pass);
		return SendClientMessage(id,yellow,Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:setpass(playerid,params[])
{
	return cmd_setpassword(playerid,params);
}

CMD:setname2(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 4)
	{
		new id, name[25],file[256];
		if(sscanf(params, "us[25]", id,name)) return SendClientMessage(playerid, yellow, "Usage: /Setname2 <Player ID/Part of Name> <Name>") &&
		                                             SendClientMessage(playerid, yellow, "function will change player ingame name and account name!");
		if(pInfo[id][Logged] == 0) return SendClientMessage(playerid, yellow, "Error: Player is NOT logged in!");
		if(strlen(name) < 3 || strlen(name) > MAX_PLAYER_NAME) return SendClientMessage(playerid,red,"Invalid name length!");
		if(pInfo[playerid][pLevel] < pInfo[id][pLevel]) return ShowMessage(playerid, red, 6);
		format(file, 256, ACCOUNTS_PATH, GetName(id));
		if (!fexist(file)) return SendClientMessage(playerid,red,"This player doesn't have an account!");
		format(file, 256, ACCOUNTS_PATH, name);
		if (fexist(file)) return SendClientMessage(playerid,red,"Error: You entered nick name is already in use, please try something else!");
		if(InvalidNick(name)) return SendClientMessage(playerid,red,"Unacceptable NickName. Please only use (0-9, a-z, [], (), $, @, ., _ and =)");
		CommandToAdmins(playerid,"setname2");
		format(Jstring, sizeof(Jstring),"You have changed %s's name to '%s'",GetName(id),name);
		SendClientMessage(playerid,yellow,Jstring);
        format(Jstring, sizeof(Jstring),"Admin '%s' has renamed your account to '%s'",GetName(playerid),name);
        SendClientMessage(id,yellow,Jstring);
        SaveStatus(id);
        format(file, 256, ACCOUNTS_PATH, GetName(id));
        JLrename(file,name);
        pInfo[id][Registered] = 0;
		pInfo[id][Logged] = 0;
		OnPlayerDisconnect(id,1);
		SetPlayerName(id,name);
		return OnPlayerConnect(id);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:setname(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 2 || IsPlayerAdmin(playerid))
	{
		new id, name[25];
		if(sscanf(params, "us[25]", id,name)) return SendClientMessage(playerid, yellow, "Usage: /Setname <Player ID/Part of Name> <Name>") &&
		                                             SendClientMessage(playerid, yellow, "function will only change player ingame name!");
		if(strlen(name) < 3 || strlen(name) > MAX_PLAYER_NAME) return SendClientMessage(playerid,red,"Invalid name length!");
		if(pInfo[playerid][pLevel] < pInfo[id][pLevel]) return ShowMessage(playerid, red, 6);
		if(InvalidNick(name)) return SendClientMessage(playerid,red,"Unacceptable NickName. Please only use (0-9, a-z, [], (), $, @, ., _ and =)");
		CommandToAdmins(playerid,"setname");
		format(Jstring, sizeof(Jstring),"You have changed %s's name to '%s'",GetName(id),name);
		SendClientMessage(playerid,yellow,Jstring);
        format(Jstring, sizeof(Jstring),"Admin '%s' has changed your name to '%s'",GetName(playerid),name);
        SendClientMessage(id,yellow,Jstring);
        SaveStatus(id);
        pInfo[id][Registered] = 0;
		pInfo[id][Logged] = 0;
		OnPlayerDisconnect(id,1);
		SetPlayerName(id,name);
		return OnPlayerConnect(id);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:changename(playerid,params[])
{
	if(AllowChangeNick == 1)
	{
		new name[25],file[256];
		if(sscanf(params, "s[25]", name)) return SendClientMessage(playerid, yellow, "Usage: /Changename <New Name>");
		if(pInfo[playerid][Registered] == 0 ||pInfo[playerid][Logged] == 0) return SendClientMessage(playerid,red,"You must be registered and loggedin!");
		if(strlen(name) < 3 || strlen(name) > MAX_PLAYER_NAME) return SendClientMessage(playerid,red,"Invalid name length!");
		if(InvalidNick(name)) return SendClientMessage(playerid,red,"Unacceptable NickName. Please only use (0-9, a-z, [], (), $, @, ., _ and =)");
		format(file, 256, ACCOUNTS_PATH, name);
		if (fexist(file)) return SendClientMessage(playerid,red,"Error: You entered nick name is already in use, please try something else!");
		format(Jstring, sizeof(Jstring),"Your name has been successfully changed to '%s'",GetName(playerid),name);
		SendClientMessage(playerid,yellow,Jstring);
        format(Jstring, sizeof(Jstring),"'%s' has changed their name to '%s'",GetName(playerid),name);
        SendToAdmins(orange,Jstring);
        SaveStatus(playerid);
        format(file, 256, ACCOUNTS_PATH, GetName(playerid));
        JLrename(file,name);
        pInfo[playerid][Registered] = 0;
		pInfo[playerid][Logged] = 0;
		OnPlayerDisconnect(playerid,1);
		SetPlayerName(playerid,name);
		return OnPlayerConnect(playerid);
	}
	else return SendClientMessage(playerid,red,"This command has been disabled!");
}

CMD:unban(playerid, params[])
{
    if(pInfo[playerid][pLevel] >= 4)
	{
		new Name[25],file[256];
		if(sscanf(params, "s[25]", Name)) return SendClientMessage(playerid, yellow, "Usage: /Unban <Player Name>");
		format(file, 256, ACCOUNTS_PATH, Name);
        if (!fexist(file)) return SendClientMessage(playerid,red,"Error: This player doesn't have an account!");
        CommandToAdmins(playerid,"unban");
		new INI:ACCOUNT = INI_Open(file);
		INI_WriteInt(ACCOUNT, "Banned", 0);
		INI_WriteInt(ACCOUNT, "TempBan", 0);
		INI_Close(ACCOUNT);
        format(Jstring, sizeof(Jstring),"You have successfully unbanned '%s'",Name);
        SendClientMessage(playerid,yellow,Jstring);
        format(Jstring, sizeof(Jstring),"'%s' has unbanned '%s'",GetName(playerid),Name);
        AlertToAdmins(playerid,orange,Jstring);
        format(Jstring,sizeof(Jstring),"[NAME UNBAN] %s has UNBANNED Nick name: %s",GetName(playerid),Name);
		WriteToLog(Jstring,"Unbanlog");
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:banname(playerid, params[])
{
    if(pInfo[playerid][pLevel] >= 4)
	{
		new Name[25],file[100];
		if(sscanf(params, "s[25]", Name)) return SendClientMessage(playerid, yellow, "Usage: /Banname <Player Name>");
		format(file, 100, ACCOUNTS_PATH, Name);
        if (!fexist(file)) return SendClientMessage(playerid,red,"Error: This player doesn't have an account!");
        CommandToAdmins(playerid,"banname");
		new INI:ACCOUNT = INI_Open(file);
		INI_WriteInt(ACCOUNT, "Banned", 1);
		INI_Close(ACCOUNT);
        format(Jstring, sizeof(Jstring),"Account '%s has been successfully banned!",Name);
        SendClientMessage(playerid,yellow,Jstring);
        format(Jstring, sizeof(Jstring),"'%s' has banned account '%s'",GetName(playerid),Name);
        AlertToAdmins(playerid,orange,Jstring);
        format(Jstring,sizeof(Jstring),"[NAME BAN] %s has banned nick name %s",GetName(playerid),Name);
		WriteToLog(Jstring,"Bans");
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:bannick(playerid, params[])
{
	return cmd_banname(playerid,params);
}

CMD:banip(playerid, params[])
{
    if(pInfo[playerid][pLevel] >= 4)
    {
        new ip[20],str[50];
        if(sscanf(params, "s[20]", ip)) return SendClientMessage(playerid, yellow, "Usage: /banip <IP>");
        CommandToAdmins(playerid,"banip");
		format(str, sizeof(str),"banip %s", ip);
		SendRconCommand(str);
		format(Jstring, sizeof(Jstring), "You have banned IP %s", ip);
		SendClientMessage(playerid,yellow,Jstring);
		format(Jstring, sizeof(Jstring), " %s has banned IP %s",GetName(playerid) , ip);
		AlertToAdmins(playerid,orange,Jstring);
		format(Jstring,sizeof(Jstring),"[IP BAN] %s has banned IP: %s",GetName(playerid),ip);
		WriteToLog(Jstring,"Bans");
		return 1;
    }
    else return ShowMessage(playerid, red, 1);
}

CMD:unbanip(playerid, params[])
{
    if(pInfo[playerid][pLevel] >= 4)
    {
        new ip[20],str[50];
        if(sscanf(params, "s[20]", ip)) return SendClientMessage(playerid, yellow, "Usage: /unbanip <IP>");
        CommandToAdmins(playerid,"unbanip");
		format(str, sizeof(str),"unbanip %s", ip);
		SendRconCommand(str);
		format(Jstring, sizeof(Jstring), "You have successfully unbanned IP %s", ip);
		SendClientMessage(playerid,yellow,Jstring);
		format(Jstring, sizeof(Jstring), " %s has unbanned IP %s",GetName(playerid) , ip);
		AlertToAdmins(playerid,orange,Jstring);
		format(Jstring,sizeof(Jstring),"[IP UNBAN] %s has UNBANNED IP: %s",GetName(playerid),ip);
		WriteToLog(Jstring,"Unbanlog");
		return 1;
    }
    else return ShowMessage(playerid, red, 1);
}

CMD:hidename(playerid,params[])
{
    if(pInfo[playerid][pLevel] >=3)
	{
        SendClientMessage(playerid,yellow,"Your name tag and health/armour bar has been disabled. /unhidename to enabled it back");
        CommandToAdmins(playerid,"hidename");
        SetCameraBehindPlayer(playerid);
        if(pInfo[playerid][NameTagHidden] == 0 && GetPVarInt(playerid,"MapHidden") == 0) pHideTimer[playerid] = SetTimerEx("HidePlayer", 5000, true, "i", playerid);
        pInfo[playerid][NameTagHidden] = 1;
	   	foreach(Player, i)
    	{
     	ShowPlayerNameTagForPlayer(i, playerid, false);
    	}
    	GameTextForPlayerEx(playerid, "~R~Nametag Disabled", 5000, 3);
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:unhidename(playerid,params[])
{
    if(pInfo[playerid][pLevel] >=3)
	{
        if(pInfo[playerid][NameTagHidden] == 0) return SendClientMessage(playerid, red, "Error: Your name tag is not hidden. Use /hidename if want to hide it!");
        CommandToAdmins(playerid,"unhidename");
        SendClientMessage(playerid,orange,"Your name tag has been enabled!");
        SetCameraBehindPlayer(playerid);
        pInfo[playerid][NameTagHidden] = 0;
        KillTimer(pHideTimer[playerid]);
	   	foreach(Player, i)
    	{
     	ShowPlayerNameTagForPlayer(i, playerid, true);
    	}
    	GameTextForPlayerEx(playerid, "~R~Nametag enabled", 5000, 3);
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:crash(playerid,params[])
{
	if(pInfo[playerid][pLevel] >=4)
	{
	    new id;
		if(sscanf(params, "u", id)) return SendClientMessage(playerid, red, "Usage: /Crash <Player ID>") &&
        SendClientMessage(playerid, red, "IMPORTANT: This function will crash the game of a specific player");
        if(IsPlayerConnected(id))
		{
            if(pInfo[playerid][pLevel] <= pInfo[id][pLevel]) return SendClientMessage(playerid,red,"You cannot perform this command on this admin!");
            CommandToAdmins(playerid,"crash");
	   		GameTextForPlayer(id, "~~555~~J#~~L",6000, 3);
	   		GameTextForPlayer(id, "%%$#@1~555#",6000, 3);
	   		GameTextForPlayer(id, "%%$#@1~555#",6000, 6);
			format(Jstring, sizeof(Jstring), "You have Crashed %s's Game! Please note command was logged!", GetName(id) );
			SendClientMessage(playerid,red, Jstring);
			format(Jstring, sizeof(Jstring), " %s has crashed %s's game",GetName(playerid) , GetName(id));
			WriteToLog(Jstring,"Crash");
			return AlertToAdmins(playerid,orange,Jstring);
	    }
		else return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:giveweapon(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 2)
	{
        new id,weap[32],ammo, wname[50],weapid;
	    if(sscanf(params, "us[32]i",id,weap,ammo)) return SendClientMessage(playerid, 0xFFFF00C8, "Usage: /Giveweapon <PlayerID> <Weapon ID> <Ammo>") ;
	    CommandToAdmins(playerid,"giveweapon");
	    if(IsNumeric(weap)) weapid = strval(weap);
	    else weapid = GetWeaponID(weap);
	    if(weapid < 1 || weapid > 46) return SendClientMessage(playerid, red, "Invalid weapon ID/Name!");
	    GetWeaponName(weapid, wname, sizeof(wname));
	    if(IllegalWeaps(weapid) == 1)
		{
			format(Jstring, sizeof(Jstring), "%s has given %s a Illegal weapon : %s(%d) with '%d' of ammo",GetName(playerid),GetName(id),wname,weapid,ammo);
			SendToAdmins(orange,Jstring);
			format(Jstring, sizeof(Jstring), "%s has given %s a Illegal weapon : %s(%d) with '%d' of ammo",GetName(playerid),GetName(id),wname,weapid,ammo);
			WriteToLog(Jstring,"BadWeaponUsage");
	    }
        if(IsPlayerConnected(id))
		{
			format(Jstring, sizeof(Jstring), "%s has given you a '%s' with '%d' ammo",GetName(playerid),wname,ammo);
			SendClientMessage(id,yellow,Jstring);
			format(Jstring,sizeof(Jstring),"You given '%s' weapon '%s' with '%d' ammo",GetName(id),wname,ammo);
			SendClientMessage(playerid,yellow,Jstring);
   			return GivePlayerWeapon(id, weapid, ammo);
	    }
		else return SendClientMessage(playerid,lighterblue,"Player is NOT connected!");
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:giveallweapon(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 3)
	{
        new weap[32], ammo, wname[50],weapid;
	    if(sscanf(params, "s[32]i", weap,ammo)) return SendClientMessage(playerid, yellow, "Usage: /Giveallweapon <Weapon ID> <Ammo>");
	    if(IsNumeric(weap)) weapid = strval(weap);
	    else weapid = GetWeaponID(weap);
	    if(weapid < 1 || weapid > 46) return SendClientMessage(playerid, red, "Invalid weapon ID/Name!");
		GetWeaponName(weapid, wname, sizeof(wname));
		if(IllegalWeaps(weapid) == 1)
		{
			format(Jstring, sizeof(Jstring), "Error: %s(%d) is in Illegal weapon list",wname,weapid);
		    return SendClientMessage(playerid, red, Jstring);
	    }
	    CommandToAdmins(playerid,"giveallweapon");
		foreach(Player, i)
		{
           GivePlayerWeapon(i, weapid, ammo);
	    }
		format(Jstring, sizeof(Jstring), "%s has given you a '%s with '%d' ammo'",GetName(playerid),wname,ammo);
		SendClientMessageToAll(lighterblue,Jstring);
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:setfstyle(playerid,params[])
{
    if(pInfo[playerid][pLevel] >=2)
	{
	    new id;
		if(sscanf(params, "u", id)) return SendClientMessage(playerid, yellow, "Usage: /setfstyle <Player ID>")&&
		                                   SendClientMessage(playerid, yellow, "Will change fighting style of a player");
		if(pInfo[playerid][pLevel] < pInfo[id][pLevel]) return SendClientMessage(playerid,red,"You cannot perform this command on this admin!");
        if(IsPlayerConnected(id))
		{
			SetPVarInt(playerid,"player",id);
			CommandToAdmins(playerid,"setfstyle");
	   		return ShowPlayerDialog(playerid,JDIALOGS+203,DIALOG_STYLE_LIST,"Choose a fighting style","Normal style\nBoxing style\nKungFu style\nKneehead style \nGrabkick style \nElbow style", "Change", "Cancel");
	    }
		else return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:heal(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 1)
	{
        new id;
		sscanf(params, "u", id);
	    if (isnull(params))
		{
			SetPlayerHealth(playerid,99);
			SendClientMessage(playerid, yellow,"You have healded yourself. also you can /heal <PlayerID>");
			return 1;
		}
		else if(IsPlayerConnected(id))
		{
                SetPlayerHealth(id,99);
                CommandToAdmins(playerid,"heal");
				format(Jstring,sizeof(Jstring),"Admin '%s' has healded you!",GetName(playerid));
				SendClientMessage(id,lighterblue,Jstring);
				format(Jstring,sizeof(Jstring),"You have healded '%s'", GetName(id));
				return SendClientMessage(playerid, yellow,Jstring);
		}
		return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:setcarcolour(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 1)
	{
	    new id,color1,color2;
		if(sscanf(params, "uii", id,color1,color2))return SendClientMessage(playerid, yellow, "Usage: /setcarcolour <PlayerID> <Colour1> <Colour2>");
        if(IsPlayerConnected(id))
		{
            if(IsPlayerInAnyVehicle(id))
			{
                CommandToAdmins(playerid,"setcarcolour");
				format(Jstring, sizeof(Jstring), "You have Changed %s vehicle's colour to '%d,%d' -|", GetName(id),  color1, color2);
				SendClientMessage(playerid,yellow,Jstring);
				format(Jstring,sizeof(Jstring),"Admin %s has changed your vehicle colour to '%d,%d'' -|", GetName(playerid),color1, color2 );
				SendClientMessage(id,yellow,Jstring);
   				return ChangeVehicleColor(GetPlayerVehicleID(id), color1, color2);
			}
			else return ShowMessage(playerid, red, 5);
	    }
		else return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:carcolour(playerid,params[])
{
  return cmd_carcolour(playerid,params);
}

CMD:announce(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 3)
	{
	    new string[128];
	    if(sscanf(params, "s[128]",string)) return SendClientMessage(playerid, yellow, "Usage: /announce <Message>");
	    format(Jstring,sizeof(Jstring),"%s has announced message '%s'",GetName(playerid),string);
		WriteToLog(Jstring,"Announcements");
		CommandToAdmins(playerid,"announce");
		return GametextForAllEx(string,8000,3);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:ann(playerid,params[])
{
	return cmd_announce(playerid,params);
}

CMD:gametext(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 4)
	{
        new style,time,string[128];
	    if(sscanf(params, "iis[128]",style,time,string)) return SendClientMessage(playerid, yellow, "Usage: /gametext <Style (0,1,3,4,5 and 6)> <Miliseconds> <Text>");
		if(style < 0 || style > 6 || style == 2 ) return SendClientMessage(playerid,red,"Invalid Style!");
		CommandToAdmins(playerid,"gametext");
		return GametextForAllEx(string, time, style);
    }
	else return ShowMessage(playerid, red, 1);
}

CMD:screenmessage(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 2)
	{
        new id,string[128];
	    if(sscanf(params, "us[128]",id,string)) return SendClientMessage(playerid, yellow, "Usage: /screenmessage <PlayerID> <Message> will announce a message on the player's screen");
	    CommandToAdmins(playerid,"screenmessage");
		return GameTextForPlayerEx(id,string, 5000, 3);
    }
	else return ShowMessage(playerid, red, 1);
}

CMD:spawn(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 1)
	{
		new id;
	    if(sscanf(params, "u",id)) return SendClientMessage(playerid, yellow, "Usage: /Spawn <Part of Nick/Player ID>");
	 	if(IsPlayerConnected(id))
	    {
			SetPlayerPos(id,0,0,0);
			CommandToAdmins(playerid,"spawn");
			SpawnPlayer(id);
			format(Jstring,sizeof(Jstring),"Administrator '%s' has spawned you!", GetName(playerid));
			SendClientMessage(id,lighterblue,Jstring);
			format(Jstring,sizeof(Jstring),"You have spawned '%s'!", GetName(id));
			return SendClientMessage(playerid,lighterblue,Jstring);
		}
		else return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

#if PauseDetectSystem == true
CMD:pausers(playerid)
{
    new count=0;
	new temp[50];
	strdel(JLstring,0,500);
	strcat(JLstring, "{33FF00}");
	foreach(Player, i)
	{
	      if(IsPaused[i] == 1)
		  {
	          format(temp, 60, "%s(Id:%i)\n",GetName(i),i);
			  strcat(JLstring, temp);
			  count++;
          }
	}
	format(temp, 60, "{00FFE6}%d Players AFK",count);
	if (count == 0) ShowPlayerDialog(playerid,3222,DIALOG_STYLE_MSGBOX,"{00FFE6}AFK Players","{FF0000}none is afk" ,"OK","");
	else
	{
       if(count == 1) ShowPlayerDialog(playerid,3222,DIALOG_STYLE_MSGBOX,"{00FFE6}1 Player AFK","{FF0000}none is afk" ,"OK","");
	   else ShowPlayerDialog(playerid,3221,DIALOG_STYLE_MSGBOX,temp,JLstring ,"OK","");
	}
	strdel(JLstring,0,500);
	return 1;
}
#endif

CMD:disarm(playerid,params[])
{
	  if(pInfo[playerid][pLevel] >= 1)
      {
           new id;
           if(sscanf(params, "u", id)) return SendClientMessage(playerid, yellow, "Usage: /disarm <Player ID>");
           if(!IsPlayerConnected(id)) return ShowMessage(playerid, red, 2);
           CommandToAdmins(playerid,"disarm");
           format(Jstring,sizeof(Jstring),"You have disarmed '%s'",GetName(id));
		   SendClientMessage(playerid,yellow,Jstring);
		   format(Jstring,sizeof(Jstring),"Admin '%s' has disarmed you'",GetName(playerid));
		   SendClientMessage(id,yellow,Jstring);
		   ResetPlayerWeapons(id);
		   return 1;
      }
      else return ShowMessage(playerid, red, 1);
}

CMD:disarmall(playerid,params[])
{
	  if(pInfo[playerid][pLevel] >= 4)
      {
           CommandToAdmins(playerid,"disarmall");
           format(Jstring,sizeof(Jstring),"Admin '%s' has disarmed all players",GetName(playerid));
		   SendClientMessageToAll(yellow,Jstring);
		   foreach(Player, i)
		   {
   		         ResetPlayerWeapons(i);
		   }
		   return 1;
      }
      else return ShowMessage(playerid, red, 1);
}

CMD:resetcash(playerid,params[])
{
	  if(pInfo[playerid][pLevel] >= 3)
      {
           new id;
           if(sscanf(params, "u", id)) return SendClientMessage(playerid, yellow, "Usage: /resetcash <Player ID>");
           if(!IsPlayerConnected(id)) return ShowMessage(playerid, red, 2);
           CommandToAdmins(playerid,"resetcash");
           format(Jstring,sizeof(Jstring),"You have reset %s's cash",GetName(id));
		   SendClientMessage(playerid,yellow,Jstring);
		   format(Jstring,sizeof(Jstring),"Admin '%s' has reset your cash'",GetName(playerid));
		   SendClientMessage(id,yellow,Jstring);
		   ResetPlayerMoney(id);
		   return 1;
      }
      else return ShowMessage(playerid, red, 1);
}

CMD:time(playerid,params[])
{
	new h,m;
	gettime(h,m);
	format(Jstring, sizeof(Jstring), "~r~]~w~%d:%d~r~]", h, m);
	return GameTextForPlayerEx(playerid, Jstring, 5000, 1);
}

CMD:date(playerid,params[])
{
	new y,m,d;
	getdate(y,m,d);
	format(Jstring, sizeof(Jstring), "~r~]~w~%d/%d/%d~r~]", d, m, y);
	return GameTextForPlayerEx(playerid, Jstring, 5000, 1);
}

CMD:autologin(playerid,params[])
{
	if(pInfo[playerid][Logged] == 1 && pInfo[playerid][Registered] == 1)
	{
		return ShowPlayerDialog(playerid, JDIALOGS+4, DIALOG_STYLE_LIST, "Account setting(Auto login)","Enable auto login\nDisable auto login" , "Select", "Close");
	}
	else return ShowMessage(playerid, red, 4);
}

CMD:info(playerid,params[])
{
		new id, WeapName[32], slot, weap, ammo, model , Float:Health , Float:Armour,Float:Vheath,Count = 0;
	    if(sscanf(params, "u",id)) return SendClientMessage(playerid, yellow, "Usage: /Info <Part of Nick/Player ID>");
	 	if(IsPlayerConnected(id))
	    {
            GetPlayerArmour(id,Armour);
			GetPlayerHealth(id,Health);
			CommandToAdmins(playerid,"info");
            format(Jstring, sizeof(Jstring), "__Informations for: %s(%d)__",GetName(id) ,id);
			SendClientMessage(playerid, green, Jstring);
			if(IsPlayerInAnyVehicle(id))
			{
				GetVehicleHealth(GetPlayerVehicleID(id), Vheath);
				model = GetVehicleModel(GetPlayerVehicleID(id));
				format(Jstring, sizeof(Jstring), "Health: %0.1f | Armour: %0.1f | Ratio: %0.2f | Ping: %d | Current vehicle: %s(Model: %d) | Vehicle health: %0.1f", Health , Armour,   Float:pInfo[id][Kills]/Float:pInfo[id][Deaths],GetPlayerPing(id),VehicleNames[model-400],model,Vheath);
			}
			else
			format(Jstring, sizeof(Jstring), "Health: %0.1f | Armour: %0.1f | Kills: %d | Deaths: %d |Ratio: %0.2f | Ping: %d", Health , Armour, pInfo[id][Kills],pInfo[id][Deaths], Float:pInfo[id][Kills]/Float:pInfo[id][Deaths],GetPlayerPing(id));
			SendClientMessage(playerid, orange, Jstring);
			for(slot = 0; slot < 13; slot++)
			{
			   GetPlayerWeaponData(id, slot, weap, ammo);
			   if( ammo != 0 && weap != 0)
			   Count++;
			}
	        if(Count == 0)
			{
				format(Jstring, sizeof(Jstring), "%s has no weapons!",GetName(id));
				return SendClientMessage(playerid,green,Jstring);
			}
			else
			{
				format(Jstring, sizeof(Jstring), "__%s's weapons__",GetName(id));
		        SendClientMessage(playerid,red,Jstring);
			}
	        if(Count >= 1)
		    {
				for (slot = 0; slot < 13; slot++)
				{
				     GetPlayerWeaponData(id, slot, weap, ammo);
				     if( ammo != 0 && weap != 0)
				     {
				        GetWeaponName(weap, WeapName, sizeof(WeapName));
				        format(Jstring,sizeof(Jstring),"%s (%d)", WeapName, ammo);
				        SendClientMessage(playerid, orange, Jstring);
	                 }
                }
            }
            return 1;
		}
		else return ShowMessage(playerid, red, 2);
}

CMD:report(playerid,params[])
{
	 new id,reason[80];
     if(sscanf(params, "us[80]",id ,reason)) return SendClientMessage(playerid,yellow,"USAGE: /report <PlayerID/Part of Nick> <Reason>");
     if(strlen(reason) < 2 || strlen(reason) > 80) return SendClientMessage(playerid,red,"Please enter a valid reason");
     if(!IsPlayerConnected(id)) return ShowMessage(playerid, red, 2);
     CommandToAdmins(playerid,"report");
	 format(Jstring,sizeof(Jstring),"{FF0000}[REPORT:]{FFFFFF} %s(ID: %d) Reported %s(ID: %d) |{FF0000} REASON: %s",GetName(playerid),playerid,GetName(id),id,reason);
	 SendToAdmins(-1,Jstring);
	 format(Jstring,sizeof(Jstring),"%s Has Reported %s | REASON: %s",GetName(playerid),GetName(id),reason);
	 WriteToLog(Jstring,"Reports");
	 CallLocalFunction("StoreReport", "dds",playerid, id, reason);
	 return SendClientMessage(playerid,yellow,"Your report has been sent to online administrators!");
}

CMD:lock(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 1)
	{
        new id;
		sscanf(params, "u", id);
	    if (isnull(params))
		{
		    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,red,"You need to be inside a vehicle to use this command!");
		    CommandToAdmins(playerid,"lock");
		    foreach(Player, i)
		    SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid),i,false,true);
		    GameTextForPlayerEx(playerid,"~w~Vehicle Locked!",3000,3);
		    SetPVarInt(playerid,"CarID",GetPlayerVehicleID(playerid));
			if(pInfo[playerid][Locked] == 0)
			{
               format(Jstring,sizeof(Jstring),"Vehicle is Locked by Admin %s!", GetName(playerid));
			   vLocked3DT[playerid] = Create3DTextLabel(Jstring, 0xFF0000C8, 0, 0, 0, 50.0, 0, 0 );
			   Attach3DTextLabelToVehicle(vLocked3DT[playerid] , GetPlayerVehicleID(playerid), 0.0, 1.0, 1.0);
			}
			pInfo[playerid][Locked]   =    1;
			return SendClientMessage(playerid, orange,"Vehicle Locked! /lock <PlayerID/Part of Nick> to lock players vehicle");
		}
		else if(IsPlayerConnected(id))
		{
                if(!IsPlayerInAnyVehicle(id)) return ShowMessage(playerid, red, 5);
                CommandToAdmins(playerid,"lock");
                foreach(Player, i)
				SetVehicleParamsForPlayer(GetPlayerVehicleID(id),i,false,true);
				SetPVarInt(id,"CarID",GetPlayerVehicleID(id));
				if(pInfo[id][Locked] == 0)
				{
					format(Jstring,sizeof(Jstring),"Vehicle is Locked by Admin %s!", GetName(playerid));
					vLocked3DT[id] = Create3DTextLabel(Jstring, 0xFF0000C8, 0,0,0, 50.0, 0, 0 );
					Attach3DTextLabelToVehicle(vLocked3DT[id],GetPlayerVehicleID(id), 0.0, 0.0, 1.0);
				}
				pInfo[id][Locked]   =    1;
			    GameTextForPlayerEx(id,"~w~Vehicle Locked!",3000,3);
				format(Jstring,sizeof(Jstring),"Admin '%s' has Locked your Vehicle",GetName(playerid));
				SendClientMessage(id,lighterblue,Jstring);
				format(Jstring,sizeof(Jstring),"You have Locked %s's Vehicle", GetName(id));
				return SendClientMessage(playerid, yellow,Jstring);
		}
		return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:unlock(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 1)
	{
        new id;
		sscanf(params, "u", id);
	    if (isnull(params))
		{
		    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,red,"You need to be inside a vehicle to use this command!");
		    if(pInfo[playerid][Locked] == 0) return SendClientMessage(playerid,red,"Your vehicle is not locked!");
		    CommandToAdmins(playerid,"unlock");
		    foreach(Player, i)
		    SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid),i,false,false);
		    GameTextForPlayerEx(playerid,"~w~Vehicle Unlocked!",3000,3);
			Delete3DTextLabel(vLocked3DT[playerid]);
			pInfo[playerid][Locked]   =    0;
			return SendClientMessage(playerid, orange,"Vehicle unLocked! /unlock <PlayerID/Part of Nick> to unlock players vehicle");
		}
		else if(IsPlayerConnected(id))
		{
                if(!IsPlayerInAnyVehicle(id)) return ShowMessage(playerid, red, 5);
                if(pInfo[id][Locked] == 0) return SendClientMessage(playerid,red,"This player's vehicle is not Locked!");
                CommandToAdmins(playerid,"unlock");
                foreach(Player, i)
				SetVehicleParamsForPlayer(GetPlayerVehicleID(id),i,false,false);
				Delete3DTextLabel(vLocked3DT[id]);
				pInfo[id][Locked]   =    0;
			    GameTextForPlayerEx(id,"~w~Vehicle Unlocked!",3000,3);
				format(Jstring,sizeof(Jstring),"Admin '%s' has Unlocked your Vehicle",GetName(playerid));
				SendClientMessage(id,lighterblue,Jstring);
				format(Jstring,sizeof(Jstring),"You have Unlocked %s's Vehicle", GetName(id));
				return SendClientMessage(playerid, yellow,Jstring);
		}
		return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:setcolor(playerid, params[])
{
    if(pInfo[playerid][pLevel] >= 2)
	{
        new id;
        if(sscanf(params, "u", id)) return SendClientMessage(playerid, yellow, "Usage: /Setcolor <Player ID/Part of Name>");
        if(IsPlayerConnected(id))
		{
           CommandToAdmins(playerid,"setcolor");
           SetPVarInt(playerid,"TargetID",id);
		   ShowPlayerDialog(playerid, JDIALOGS+205, DIALOG_STYLE_LIST, "Select Messgae Color","Yellow\nWhite\nBlue\nRed\nGreen\nOrange\nPurple\nPink\nBrown\nBlack" , "Select", "Close");
		   return 1;
		}
		else return ShowMessage(playerid, red, 2);
    }
    else return ShowMessage(playerid, red, 1);
}

CMD:pm(playerid,params[])
{
	if(PmDialog == 1)
	{
        new id;
        if(sscanf(params, "u", id)) return SendClientMessage(playerid, lighterblue, "Usage: /pm <PlayerID/Part of Nick>");
		if(IsPlayerConnected(id))
		{
             pInfo[playerid][Clicked] = id;
		     format(Jstring,sizeof(Jstring),"PM To %s(ID: %d) Type you message:", GetName(id), id);
             return ShowPlayerDialog(playerid,DIALOG_PRIVATE_MESSAGE,DIALOG_STYLE_INPUT,"Private Message",Jstring,"Send","Cancel");
		}
		else return ShowMessage(playerid, red, 2);
	}
	else
	{
        new id,Message[128];
        if(sscanf(params, "us[128]",id, Message)) return SendClientMessage(playerid, lighterblue, "Usage: /pm <PlayerID/Part of Nick> <Message>");
		if(IsPlayerConnected(id))
		{
             return OnPrivateMessage(playerid, id, Message);
		}
		else return ShowMessage(playerid, red, 2);
	}
}

CMD:account(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 5)
	{
		new Name[24];
        if(sscanf(params, "s[24]", Name)) return SendClientMessage(playerid, yellow, "Angel: /account <Account Name>");
        SetPVarString(playerid,"AccountName",Name);
		return AccountEditor(playerid);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:destroycars(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 3)
	{
	    for(new i=0; i<pInfo[playerid][SpawnedCars]; i++)
		{
	        DestroyVehicle(pInfo[playerid][Cars][i]);
		}
		pInfo[playerid][SpawnedCars] = 0;
		CommandToAdmins(playerid,"destroycars");
		SendClientMessage(playerid,yellow,"You have deleted all cars that you created!");
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:print(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 1)
	{
		new Text[256];
        if(sscanf(params, "s[256]", Text)) return SendClientMessage(playerid, yellow, "Angel: /print <Text> will print a message on console");
        CommandToAdmins(playerid,"print");
		print(Text);
		format(Jstring,sizeof(Jstring),"Message has been printed on console: %s", Text);
		SendClientMessage(playerid, -1, Jstring);
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:clearlogs(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 5)
	{
        CommandToAdmins(playerid,"clearlogs");
        return ShowPlayerDialog(playerid,JDIALOGS+38,DIALOG_STYLE_LIST,"Clear Logs","Clear Ban Log\nClear Kick log\nClear Anti cheats log\nClear PM(s) Log\nClear Crash log","Select","Cancel");
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:clearlog(playerid,params[])
{
    return cmd_clearlog(playerid,params);
}

CMD:showclock(playerid, params[])
{
    if(pInfo[playerid][pLevel] >= 1)
    {
       new id;
	   if(sscanf(params, "u", id)) return SendClientMessage(playerid, yellow, "Usage: /showclock <Player ID>");
       if(IsPlayerConnected(id))
       {
             CommandToAdmins(playerid,"showclock");
		     format(Jstring,sizeof(Jstring),"You have enabled the in-game clock of '%s'", GetName(id));
		     SendClientMessage(playerid,yellow,Jstring);
		     TogglePlayerClock(id, 1);
			 return 1;
	   }
	   else return ShowMessage(playerid, red, 2);
    }
    else return ShowMessage(playerid, red, 1);
}

CMD:hideclock(playerid, params[])
{
    if(pInfo[playerid][pLevel] >= 1)
    {
       new id;
	   if(sscanf(params, "u", id)) return SendClientMessage(playerid, yellow, "Usage: /hideclock <Player ID>");
       if(IsPlayerConnected(id))
       {
             CommandToAdmins(playerid,"hideclock");
		     format(Jstring,sizeof(Jstring),"You have disabled the in-game clock of '%s'", GetName(id));
		     SendClientMessage(playerid,yellow,Jstring);
		     TogglePlayerClock(id, 0);
			 return 1;
	   }
	   else return ShowMessage(playerid, red, 2);
    }
    else return ShowMessage(playerid, red, 1);
}

CMD:removebounds(playerid, params[])
{
    if(pInfo[playerid][pLevel] >= 2)
    {
       new id;
	   if(sscanf(params, "u", id)) return SendClientMessage(playerid, yellow, "Usage: /removebounds <Player ID>");
       if(IsPlayerConnected(id))
       {
             CommandToAdmins(playerid,"removebounds");
		     format(Jstring,sizeof(Jstring),"You have removed %s's world bounds!", GetName(id));
		     SendClientMessage(playerid,yellow,Jstring);
		     SetPlayerWorldBounds(id, 20000.0000, -20000.0000, 20000.0000, -20000.0000);
			 return 1;
	   }
	   else return ShowMessage(playerid, red, 2);
    }
    else return ShowMessage(playerid, red, 1);
}

CMD:jlcredits(playerid,params[])
{
    SendClientMessage(playerid, green, "|________| J.L. Administration system Credits |_______|");
    SendClientMessage(playerid, lighterblue, " ");
	SendClientMessage(playerid, lighterblue, "J.L Administration system V1.0 - created by JewelL");
	SendClientMessage(playerid, lighterblue, "---------------------------------------------------------------------------");
	return 1;
}

CMD:addforbidname(playerid,params[])
{
     if(pInfo[playerid][pLevel] >= 4)
	 {
	     new Nick[30],file[130];
		 if(sscanf(params, "s[24]",Nick)) return SendClientMessage(playerid, yellow, "Usage: /addforbidname <NickName>");
		 CommandToAdmins(playerid,"addforbidname");
		 format(file, 130, SETTING_PATH, "ForbiddeNicks");
		 format(Nick, 30, "%s\r\n", Nick);
		 new File:JLlog = fopen(file,io_append);
		 fwrite(JLlog,Nick);
		 fclose(JLlog);
		 strdel(Nick,strlen(Nick)-2,strlen(Nick));
		 format(Jstring,sizeof(Jstring),"%s has added \"%s\" to forbidden nick names list",GetName(playerid),Nick);
		 SendToAdmins(red,Jstring);
		 LoadForbiddenNicks();
		 return 1;
	 }
	 else return ShowMessage(playerid, red, 1);
}

CMD:addforbiddenname(playerid,params[])
{
	 return cmd_addforbidname(playerid,params);
}

CMD:addforbidpartname(playerid,params[])
{
     if(pInfo[playerid][pLevel] >= 5)
	 {
	     new Nick[30],file[130];
		 if(sscanf(params, "s[30]",Nick)) return SendClientMessage(playerid, yellow, "Usage: /addforbidpartname <Part Nick>");
         CommandToAdmins(playerid,"addforbidpartnick");
		 format(file, 130, SETTING_PATH, "ForbiddeNickParts");
		 format(Nick, 30, "%s\r\n", Nick);
		 new File:JLlog = fopen(file,io_append);
		 fwrite(JLlog,Nick);
		 fclose(JLlog);
         strdel(Nick,strlen(Nick)-2,strlen(Nick));
		 format(Jstring,sizeof(Jstring),"%s has added \"%s\" to forbidden part nick names list",GetName(playerid),Nick);
		 SendToAdmins(red,Jstring);
		 LoadBadNickParts();
	     return 1;
     }
	 else return ShowMessage(playerid, red, 1);
}

CMD:addforbiddenpartname(playerid,params[])
{
	 return cmd_addforbidpartname(playerid,params);
}

CMD:addbadword(playerid,params[])
{
     if(pInfo[playerid][pLevel] >= 5)
	 {
	     new Word[30],file[130];
		 if(sscanf(params, "s[30]",Word)) return SendClientMessage(playerid, yellow, "Usage: /addbadword <NickName>");
		 CommandToAdmins(playerid,"addbadword");
		 format(file, 130, SETTING_PATH, "BadWords");
		 format(Word, 30, "%s\r\n", Word);
		 new File:JLlog = fopen(file,io_append);
		 fwrite(JLlog,Word);
		 fclose(JLlog);
         strdel(Word,strlen(Word)-2,strlen(Word));
		 format(Jstring,sizeof(Jstring),"%s has added \"%s\" to bad words list",GetName(playerid),Word);
		 SendToAdmins(red,Jstring);
		 LoadBadWords();
		 return 1;
	 }
	 else return ShowMessage(playerid, red, 1);
}

CMD:reports(playerid,params[])
{
   	if(pInfo[playerid][pLevel] >= 1)
	{
		new count;
		for(new i = 0; i < MAX_REPORTS_STORE; i++)
		{
		   if(strlen(Reports[i]) > 0)
		   {
              SendClientMessage(playerid,-1,Reports[i]);
		      count++;
		   }
		}
		if(count == 0)
		SendClientMessage(playerid,green,"No reports found!");
		CommandToAdmins(playerid,"reports");
		return 1;
 	}
	else return ShowMessage(playerid, red, 1);
}

CMD:reconnect(playerid, params[])
{
    if(pInfo[playerid][pLevel] >= 1)
    {
        new id,reason[30],string[50],ip[16];
		if(sscanf(params, "us[30]", id, reason)) return SendClientMessage(playerid, yellow, "Usage: /reconnect <playerid> <reason>");
        if(IsPlayerConnected(id))
        {
           CommandToAdmins(playerid,"reconnect");
		   GetPlayerIp(id, ip, sizeof(ip));
		   format(string, sizeof(string), "banip %s", ip);
		   SendRconCommand(string);
		   SetPVarString(id,"MYIP",ip);
		   reconnect[id] = 1;
		   format(string, sizeof(string), "You have forced %s to reconnect | Reason: %s", GetName(id), reason);
		   SendClientMessage(playerid,yellow, string);
		   format(string, sizeof(string), "Admin %s has forced you to reconnect | Reason: %s", GetName(playerid), reason);
		   SendClientMessage(id,red, string);
		   return 1;
	    }
	    else return ShowMessage(playerid, red, 2);
    }
    else return ShowMessage(playerid, red, 1);
}

CMD:setping(playerid, params[], help)
{
    if(pInfo[playerid][pLevel] >= 4)
    {
           new ping;
           if(sscanf(params, "i", ping)) return SendClientMessage(playerid, yellow, "Usage: /setping <PING> ('0' to disable)");
           CommandToAdmins(playerid,"setping");
           if(ping == 0)
		   {
              if(MaxPing == 0) return SendClientMessage(playerid, red, "Ping Kicker is already disabled!");
              MaxPing = ping;
		      format(Jstring,sizeof(Jstring),"Administrator %s  has disabled ping kicker!",GetName(playerid));
	          SendClientMessageToAll(orange,Jstring);
		   }
		   else if(ping < 50)
		   {
	          return SendClientMessage(playerid, red, "Maxium ping must be higher than '50'");
		   }
		   else
		   {
              MaxPing = ping;
		      format(Jstring,sizeof(Jstring),"Administrator %s has  set maximum ping to '%d'!",GetName(playerid),ping);
	          SendClientMessageToAll(orange,Jstring);
		   }
		   new file[256];
		   format(file,sizeof(file),"JLadmin/Settings/settings.cfg");
		   new INI:SETTING = INI_Open(file);
		   INI_WriteInt(SETTING, "MaxPing", ping);
		   INI_Close(SETTING);
		   return 1;
     }
	 else return ShowMessage(playerid, red, 1);
}

CMD:forbiddenweaps(playerid,params[])
{  
    if(pInfo[playerid][pLevel] >= 1)
	{
		new Count,slot, weap, ammo, weapname[32];
		CommandToAdmins(playerid,"forbiddenweaps");
		foreach(Player, i)
		{
			  for(slot = 0; slot < 13; slot++)
			  {
			       GetPlayerWeaponData(i, slot, weap, ammo);
			       GetWeaponName(weap, weapname, sizeof(weapname));
			       if(IllegalWeaps(weap) == 1)
			       {
		 	          Count++;
			          format(Jstring, sizeof(Jstring), "%s(%d) Weapon: %s(%d) with %d of ammo", GetName(i), i,weapname,weap, ammo);
			          SendClientMessage(playerid,orange,Jstring);
				   }
			  }
		}
		if(Count == 0) return SendClientMessage(playerid,green,"No One has Forbidden weapons!");
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:forbidweaps(playerid,params[])
{
	return cmd_forbiddenweaps(playerid,params);
}

CMD:illegalweapons(playerid,params[])
{
	return cmd_forbiddenweaps(playerid,params);
}

CMD:illegalweaps(playerid,params[])
{
	return cmd_forbiddenweaps(playerid,params);
}

CMD:vspec(playerid, params[])
{
   if(pInfo[playerid][pLevel] >= 1)
   {
        new id,Float:P[3],Float:H,Float:A;
        if(sscanf(params, "i", id)) return SendClientMessage(playerid, yellow, "Usage: /VSpec <VehicleID>");
        if (pInfo[playerid][Spec] == 0)
        {
           GetPlayerHealth(playerid, H);
		   GetPlayerArmour(playerid,A);
           SetPVarInt(playerid,"Int",GetPlayerInterior(playerid));
		   SetPVarInt(playerid,"vworld",GetPlayerVirtualWorld(playerid));
		   GetPlayerPos(playerid,P[0],P[1],P[2]);
		   SetPVarFloat(playerid,"JX",P[0]);
		   SetPVarFloat(playerid,"JY",P[1]);
		   SetPVarFloat(playerid,"JZ",P[2]);
		   SetPVarFloat(playerid,"Health",H);
		   SetPVarFloat(playerid,"Armour",A);
		   StoreWeaponsData(playerid);
		}
		CommandToAdmins(playerid,"vspec");
        pInfo[playerid][Spec] = 2;
		TogglePlayerSpectating(playerid, 1);
		PlayerSpectateVehicle(playerid, id);
		SendClientMessage(playerid,lighterblue,"You are now spectating!");
		return 1;
   }
   else return ShowMessage(playerid, red, 1);
}

CMD:specvehicle(playerid,params[])
{
	return cmd_vspec(playerid,params);
}

CMD:mainchat(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 4)
	{
        CommandToAdmins(playerid,"mainchat");
		return ShowPlayerDialog(playerid, JDIALOGS+29, DIALOG_STYLE_LIST, "chat settings","Enable chat\nDisable chat" , "Select", "Close");
 	}
	else return ShowMessage(playerid, red, 1);
}

CMD:cal(playerid,params[])
{
	if(pInfo[playerid][pLevel] >= 1)
	{
		new Num1,Num2,mark[10];
	    if(sscanf(params, "is[10]i",Num1,mark,Num2)) return SendClientMessage(playerid, yellow, "Usage: /cal <Number 1> <*|/|+|-> <Number 2>");
		if(strcmp(mark,"*",true) == 0)
		{
	        format(Jstring, sizeof(Jstring), "[ANSWER] %d X %d = %d", Num1, Num2, Num1*Num2);
			SendClientMessage(playerid, lighterblue, Jstring);
		}
		else if(strcmp(mark,"/",true) == 0)
		{
			format(Jstring, sizeof(Jstring), "[ANSWER] %d / %d = %0.2f", Num1, Num2, Float:Num1/Float:Num2);
			SendClientMessage(playerid, lighterblue, Jstring);
		}
		else if(strcmp(mark,"+",true) == 0)
		{
			format(Jstring, sizeof(Jstring), "[ANSWER] %d + %d = %d", Num1, Num2, Num1+Num2);
			SendClientMessage(playerid, lighterblue, Jstring);
		}
		else if(strcmp(mark,"-",true) == 0)
		{
			format(Jstring, sizeof(Jstring), "[ANSWER] %d - %d = %d", Num1, Num2, Num1-Num2);
			SendClientMessage(playerid, lighterblue, Jstring);
		}
		else return SendClientMessage(playerid, yellow, "Usage: /cal <Number 1> <*|/|+|-> <Number 2>");
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:getip(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 2)
	{
		new id,ip[16];
	    if(sscanf(params, "u", id)) return SendClientMessage(playerid, yellow, "Usage: /getip <Player ID/Part of Nick>");
	 	if(IsPlayerConnected(id))
	    {
            CommandToAdmins(playerid,"getip");
  		  	GetPlayerIp(id,ip,16);
			format(Jstring,sizeof(Jstring),"Player Name: %s(ID: %d)  |  IP: %s", GetName(id),id, ip);
   	        SendClientMessage(playerid,green,Jstring);
   	        return 1;
		}
		else return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:track(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 1)
	{
		new id,ip[16], WeapName[32], slot, weap, ammo, model , seconds, Float:x,Float:y,Float:z, Float:Health ,Float:Ratio, Float:Armour,Float:Vheath,Count,Logg[5],Reg[5],pMuted[5],pJailed[5],pFrozen[5],Jfile[100],PlayerState[40],Seat[25];
	    if(sscanf(params, "u",id)) return SendClientMessage(playerid, yellow, "Usage: /Track <Part of Nick/Player ID>");
	 	if(IsPlayerConnected(id))
	    {
            CommandToAdmins(playerid,"track");
            GetPlayerArmour(id,Armour);
			GetPlayerHealth(id,Health);
			GetPlayerIp(id, ip, sizeof(ip));
			GetPlayerPos(id,x,y,z);
			seconds = gettime() - pInfo[playerid][ConnectedTime] + pInfo[playerid][TotalSecs];
			format(Jfile, sizeof(Jfile), ACCOUNTS_PATH, GetName(id));
            if(fexist(Jfile))
            INI_ParseFile(Jfile,"AccountsEditor");
            else
			{
            	RegisteredDate = "None"; RegisteredIP = "None"; LastSeen = "None";
            }
			if(pInfo[playerid][Deaths] > 0)
			{
				Ratio = Float:pInfo[id][Kills]/ Float:pInfo[id][Deaths];
			}
			else
			{
				Ratio = Float:pInfo[id][Kills]/ Float:pInfo[id][Deaths]+1;
			}
			if(pInfo[id][Registered] == 1) Reg = "Yes"; else Reg = "No";
			if(pInfo[id][Logged] == 1) Logg = "Yes"; else Logg = "No";
			if(pInfo[id][Muted] == 1) pMuted = "Yes"; else pMuted = "No";
			if(pInfo[id][Jailed] == 1) pJailed = "Yes"; else pJailed = "No";
			if(pInfo[id][Frozen] == 1) pFrozen = "Yes"; else pFrozen = "No";
			if (IsPlayerConnected(id))
	        {
 		      switch(pInfo[id][pLevel])
              {
                  case 0: {
				  LevelName = "Player Stauts";
				  LevelColor = "{FFFFFF}";
				  }
			      case 1: {
				  LevelName = ADMIN_LEVEL_1;
				  LevelColor = LEVEL_1_COLOR;
				  }
				  case 2: {
				  LevelName = ADMIN_LEVEL_2;
				  LevelColor = LEVEL_2_COLOR;
				  }
				  case 3: {
				  LevelName = ADMIN_LEVEL_4;
				  LevelColor = LEVEL_3_COLOR;
				  }
				  case 4: {
				  LevelName = ADMIN_LEVEL_3;
				  LevelColor = LEVEL_4_COLOR;
				  }
				  case 5: {
				  LevelName = ADMIN_LEVEL_5;
				  LevelColor = LEVEL_5_COLOR;
				  }
				  default: {
				  LevelName = ADMIN_LEVEL_6;
				  LevelColor = LEVEL_6_COLOR;
				  }
	          }
	          switch(GetPlayerState(id))
              {
                  case 0: {
				  PlayerState = "Empty (while initializing)";
				  }
			      case 1: {
				  PlayerState = "Player is on foot";
				  }
				  case 2: {
				  PlayerState = "Player is driver of a vehicle";
				  }
				  case 3: {
				  PlayerState = "Player is passenger of a vehicle";
				  }
				  case 4: {
				  PlayerState = "Player exits a vehicle";
				  }
				  case 5: {
				  PlayerState = "Player enters a vehicle as driver";
				  }
				  case 6: {
				  PlayerState = "Player enters a vehicle as passenger";
				  }
				  case 7: {
				  PlayerState = "Player is wasted or on class selection";
				  }
				  case 8: {
				  PlayerState = "Player is spawned";
				  }
				  case 9: {
				  PlayerState = "Player is spectating";
				  }
	          }
	          switch(GetPlayerVehicleSeat(id))
              {
                  case 0: {
				  Seat = "Driver";
				  }
			      case 1: {
				  Seat = "Front Passenger";
				  }
				  case 2: {
				  Seat = "Back left passenger";
				  }
				  case 3: {
				  Seat = "Back right passenger";
				  }
				  case 4: {
				  Seat = "Passenger seats";
				  }
	          }
		    }
			strdel(VLstring,0,850);
            format(Jstring, sizeof(Jstring), "{0000FF}Nick name: %s (ID: %d) | IP: %s | Score: %d | Cash: $ %d | Kills: %d | Deaths: %d | Ratio: %0.1f\n\n",GetName(id) ,id,ip,GetPlayerScore(id),GetPlayerMoney(id),pInfo[id][Kills], pInfo[id][Deaths],Ratio);
            strcat(VLstring, Jstring, sizeof(VLstring));
            format(Jstring, sizeof(Jstring), "{0DF224}Health: %0.1f | Armour: %0.1f | Ping: %d | Admin level:%s %s (%d) | Donator Level(V.I.P): %d\n\n",Health ,Armour,GetPlayerPing(id),LevelColor,LevelName,pInfo[id][pLevel],pInfo[id][Donator],GetPlayerWantedLevel(id));
			strcat(VLstring, Jstring, sizeof(VLstring));
			format(Jstring, sizeof(Jstring), "{C837B9}Interior: %d | Virtual World: %d | Position: X = %0.3f, Y = %0.3f, Z = %0.3f | Skin: %d | Wanted Level: %d\n\n",GetPlayerInterior(id) ,GetPlayerVirtualWorld(id),x,y,z,GetPlayerSkin(id),GetPlayerWantedLevel(id));
			strcat(VLstring, Jstring, sizeof(VLstring));
			format(Jstring, sizeof(Jstring), "{F79709}Registered: %s | Logged: %s | Muted: %s | Jailed: %s | Frozen: %s | Last seen: %s\n\n",Reg ,Logg,pMuted,pJailed,pFrozen,LastSeen);
			strcat(VLstring, Jstring, sizeof(VLstring));
			format(Jstring, sizeof(Jstring), "{59A661}Registered Date: %s | Registered IP: %s | Time spent: %s\n\n",RegisteredDate ,RegisteredIP,ConvertTime(seconds,slot,weap,ammo));
            strcat(VLstring, Jstring, sizeof(VLstring));
            if(IsPlayerInAnyVehicle(id))
			{
				GetVehicleHealth(GetPlayerVehicleID(id), Vheath);
				model = GetVehicleModel(GetPlayerVehicleID(id));
				format(Jstring, sizeof(Jstring), "{FFFF80}Current vehicle: %s (Model ID: %d) | Vehicle health: %0.1f | Seat: %s\n\n", VehicleNames[model-400],model,Vheath,Seat);
				strcat(VLstring, Jstring, sizeof(VLstring));
			}
			for(slot = 0; slot < 13; slot++)
			{
			   GetPlayerWeaponData(id, slot, weap, ammo);
			   if( ammo != 0 && weap != 0)
			   Count++;
			}
	        if(Count >= 1)
		    {
                format(Jstring, sizeof(Jstring), "{FF0000}Player weapons: ",GetName(id));
                strcat(VLstring, Jstring, sizeof(VLstring));
				for (slot = 0; slot < 13; slot++)
				{
				     GetPlayerWeaponData(id, slot, weap, ammo);
				     if( ammo != 0 && weap != 0)
				     {
				        GetWeaponName(weap, WeapName, sizeof(WeapName));
				        format(Jstring,sizeof(Jstring),"| %s (%d) ", WeapName, ammo);
				        strcat(VLstring, Jstring, sizeof(VLstring));
	                 }
                }
            }
            format(Jstring, sizeof(Jstring), "\n\nPlayer state: %s", PlayerState);
			strcat(VLstring, Jstring, sizeof(VLstring));
			ShowPlayerDialog(playerid, JDIALOGS+45, DIALOG_STYLE_MSGBOX,"     {FB0404}Player Informations", VLstring, "Ok", "");
			strdel(VLstring,0,850);
            return 1;
		}
		else return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:tunedcars(playerid, params[])
{
    if(pInfo[playerid][pLevel] >= 1)
	{
        CommandToAdmins(playerid,"Tunedcars");
        ShowPlayerDialog(playerid, JDIALOGS+50, DIALOG_STYLE_LIST, "Tuned Cars (List)","Tuned Uranus\nTuned Sultan\nTuned Jester\nTuned Stratum\nTuned Stratum 2\nAlien\nTuned Elegy\nTuned Flash\nTuned Remington\nTuned Slamvan" , "Select", "Close");
		return 1;
    }
    else return ShowMessage(playerid, red, 1);
}

CMD:tcars(playerid,params[])
{
	return cmd_tunedcars(playerid,params);
}

CMD:setmarker(playerid, params[])
{
    if(pInfo[playerid][pLevel] >= 2)
	{
        new id;
        if(sscanf(params, "u", id)) return SendClientMessage(playerid, yellow, "Usage: /setmarker <Player ID/Part of Name>");
        if(IsPlayerConnected(id))
		{
           CommandToAdmins(playerid,"setmarker");
           SetPVarInt(playerid,"TargetID",id);
		   ShowPlayerDialog(playerid, JDIALOGS+51, DIALOG_STYLE_LIST, "Select Messgae Color","Yellow\nWhite\nBlue\nRed\nGreen\nOrange\nPurple\nPink\nBrown\nBlack" , "Select", "Close");
		   return 1;
		}
		else return ShowMessage(playerid, red, 2);
    }
    else return ShowMessage(playerid, red, 1);
}

CMD:addforbidweapon(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 5)
	{
	     new weap,file[130],str[20];
		 if(sscanf(params, "i",weap)) return SendClientMessage(playerid, yellow, "Usage: /addforbidweapon <Weapon ID>");
		 if(weap < 1 || weap > 46) return SendClientMessage(playerid, red, "Invalid weapon ID");
		 CommandToAdmins(playerid,"addforbidweapon");
		 format(file, 130, SETTING_PATH, "Illegalweapons");
		 format(str, 20, "%d\r\n", weap);
		 new File:JLlog = fopen(file,io_append);
		 fwrite(JLlog,str);
		 fclose(JLlog);
		 GetWeaponName(weap, str, sizeof(str));
		 format(Jstring,sizeof(Jstring),"%s has added \"%s(%d)\" to forbidden weapons list",GetName(playerid),str,weap);
		 SendToAdmins(red,Jstring);
		 LoadIllegalWeaps();
		 return 1;
    }
    else return ShowMessage(playerid, red, 1);
}

CMD:settings(playerid,params[])
{
     if(pInfo[playerid][pLevel] >= 5)
	 {
        CommandToAdmins(playerid,"settings");
     	ServSettings(playerid);
     	return 1;
	 }
	 else return ShowMessage(playerid, red, 1);
}

CMD:console(playerid,params[])
{
     if(pInfo[playerid][pLevel] >= 5)
	 {
        CommandToAdmins(playerid,"console");
     	JLconsole(playerid);
     	return 1;
	 }
     else return ShowMessage(playerid, red, 1);
}

CMD:jlcmds(playerid,params[])
{
    SendClientMessage(playerid, green, "|_____________| J.L. Administration system Commands |_____________|");
	SendClientMessage(playerid, lighterblue, "/Register, /Login, /Autologin, /Changepass, /Report, /Getid, /Pm");
	SendClientMessage(playerid, lighterblue, "/Admins, /Changename, /Vips, /Stats, /Info, /Pausers, /Time, /Date");
	return 1;
}

CMD:warp(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 3)
	{
		new id,id2;
	    if(sscanf(params, "uu",id,id2)) return SendClientMessage(playerid, yellow, "Usage: /Warp <Player ID/Nick> <Player ID 2/Nick>");
	 	if(IsPlayerConnected(id) && IsPlayerConnected(id2))
	    {
            if(pInfo[playerid][pLevel] < pInfo[id][pLevel]) return ShowMessage(playerid, red, 6);
			new Float:Pos[3];
			GetPlayerPos(id2,Pos[0],Pos[1],Pos[2]);
			SetPlayerInterior(id,GetPlayerInterior(id2));
			SetPlayerVirtualWorld(id,GetPlayerVirtualWorld(id2));
			if(GetPlayerState(id) == PLAYER_STATE_DRIVER)
			{
   			new Veh = GetPlayerVehicleID(id);
			SetVehiclePos(Veh,Pos[0]+3,Pos[1],Pos[2]);
			LinkVehicleToInterior(Veh,GetPlayerInterior(id2));
			SetVehicleVirtualWorld(Veh,GetPlayerVirtualWorld(id2));
			}
			else SetPlayerPos(id,Pos[0]+3,Pos[1],Pos[2]);
			format(Jstring,sizeof(Jstring),"Administrator '%s' has teleported you to %s!", GetName(playerid),GetName(id2));
			SendClientMessage(id,yellow,Jstring);
			format(Jstring,sizeof(Jstring),"You have Teleported '%s' to %s's Position", GetName(id), GetName(id2));
			CommandToAdmins(playerid,"warp");
			return SendClientMessage(playerid,yellow,Jstring);
		}
		else return ShowMessage(playerid, red, 2);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:forbidnames(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 1)
	{
		new Jfile[100];
		format(Jfile,sizeof(Jfile), SETTING_PATH, "ForbiddeNicks");
		if(!fexist(Jfile)) return ShowPlayerDialog(playerid,JDIALOGS+45,DIALOG_STYLE_MSGBOX,"Error","{FF0000}Could not find the file/Path","Ok","");
		new temp[24];
		strdel(VLstring,0,850);
		new File:JLfile = fopen(Jfile, io_read);
		while(fread(JLfile, temp))
		{
		   strcat(VLstring, temp);
		}
		fclose(JLfile);
        ShowPlayerDialog(playerid,JDIALOGS+45,DIALOG_STYLE_MSGBOX,"Forbidden Names(List)", VLstring ,"Ok","");
		if(strlen(VLstring) == 0)ShowPlayerDialog(playerid,JDIALOGS+45,DIALOG_STYLE_MSGBOX,"Forbidden Weapons(List)", "No forbidden nick names found!" ,"Ok","");
		strdel(VLstring,0,850);
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:getall(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 4)
	{
        new Float:Pos[3];
		GetPlayerPos(playerid,Pos[0],Pos[1],Pos[2]);
		foreach(Player, i)
		{
			if(playerid != i && pInfo[playerid][Spawned] == 1)
			{
				PlayerPlaySound(i,1057,0.0,0.0,0.0);
				SetPlayerPos(i, Pos[0], Pos[1], Pos[2]);
			}
		}
        CommandToAdmins(playerid,"getall");
		format(Jstring,sizeof(Jstring),"Admin '%s' has teleported all players", GetName(playerid));
		return SendClientMessageToAll(yellow, Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}
CMD:hostname(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 5)
    {
		new string[128];
        if(sscanf(params, "s[128]",string)) return SendClientMessage(playerid,yellow,"Usage: /Hostname <New Host Name>");
		format(string,sizeof(string),"hostname %s",string);
		SendRconCommand(string);
		format(string,sizeof(string),"%s has changed the server host name to \"%s\"",GetName(playerid),params);
		CommandToAdmins(playerid,"hostname");
		return SendToAdmins(orange,string);
	}
	else return ShowMessage(playerid, red, 1);
}
CMD:mapname(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 5)
    {
		new string[128];
        if(sscanf(params, "s[128]",string)) return SendClientMessage(playerid,yellow,"USAGE: /Mapname <New Map Name>");
		format(string,sizeof(string),"mapname %s",string);
		SendRconCommand(string);
		format(string,sizeof(string),"%s has changed the server map name to \"%s\"",GetName(playerid),params);
		CommandToAdmins(playerid,"mapname");
		return SendToAdmins(orange,string);
	}
	else return ShowMessage(playerid, red, 1);
}
CMD:gmtext(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 5)
    {
		new string[128];
        if(sscanf(params, "s[128]",string)) return SendClientMessage(playerid,yellow,"USAGE: /Gmtext <New Gamemode Name>");
		format(string,sizeof(string),"gamemodetext %s",string);
		SendRconCommand(string);
		format(string,sizeof(string),"%s has changed the gamemode name to \"%s\"",GetName(playerid),params);
		CommandToAdmins(playerid,"gmtext");
		return SendToAdmins(orange,string);
	}
	else return ShowMessage(playerid, red, 1);
}
CMD:varlist(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 5)
	{
        strdel(VLstring, 0, 850);
        GetServerVarAsString("hostname", Jstring, sizeof(Jstring));
		format(Jstring, sizeof(Jstring), "Host Name: %s\n",Jstring);
		strcat(VLstring, Jstring, sizeof(VLstring));
		GetServerVarAsString("gamemode0", Jstring, sizeof(Jstring));
		format(Jstring, sizeof(Jstring), "gamemode: %s\n",Jstring);
		strcat(VLstring, Jstring, sizeof(VLstring));
		GetServerVarAsString("gamemodetext", Jstring, sizeof(Jstring));
		format(Jstring, sizeof(Jstring), "Gamemode Text: %s\n",Jstring);
		strcat(VLstring, Jstring, sizeof(VLstring));
		GetServerVarAsString("mapname", Jstring, sizeof(Jstring));
		format(Jstring, sizeof(Jstring), "Map Name: %s\n",Jstring);
		strcat(VLstring, Jstring, sizeof(VLstring));
		GetServerVarAsString("filterscripts", Jstring, sizeof(Jstring));
		format(Jstring, sizeof(Jstring), "Filterscripts: %s\n",Jstring);
		strcat(VLstring, Jstring, sizeof(VLstring));
		GetServerVarAsString("weburl", Jstring, sizeof(Jstring));
		format(Jstring, sizeof(Jstring), "Website: %s\n",Jstring);
		strcat(VLstring, Jstring, sizeof(VLstring));
		GetServerVarAsString("plugins", Jstring, sizeof(Jstring));
		format(Jstring, sizeof(Jstring), "plugins: %s\n",Jstring);
		strcat(VLstring, Jstring, sizeof(VLstring));
		format(Jstring, sizeof(Jstring), "Max Players: %d\n",GetServerVarAsInt("maxplayers"));
		strcat(VLstring, Jstring, sizeof(VLstring));
		format(Jstring, sizeof(Jstring), "Port: %d\n",GetServerVarAsInt("port"));
		strcat(VLstring, Jstring, sizeof(VLstring));
		format(Jstring, sizeof(Jstring), "announce: %d\n",GetServerVarAsInt("announce"));
		strcat(VLstring, Jstring, sizeof(VLstring));
		format(Jstring, sizeof(Jstring), "Query: %d\n",GetServerVarAsInt("query"));
		strcat(VLstring, Jstring, sizeof(VLstring));
		format(Jstring, sizeof(Jstring), "chatlogging: %d\n",GetServerVarAsInt("chatlogging"));
		strcat(VLstring, Jstring, sizeof(VLstring));
		format(Jstring, sizeof(Jstring), "Onfoot Rate: %d\n",GetServerVarAsInt("onfoot_rate"));
		strcat(VLstring, Jstring, sizeof(VLstring));
		format(Jstring, sizeof(Jstring), "Incar Rate: %d\n",GetServerVarAsInt("incar_rate"));
		strcat(VLstring, Jstring, sizeof(VLstring));
		format(Jstring, sizeof(Jstring), "Weapon Rate: %d\n",GetServerVarAsInt("weapon_rate"));
		strcat(VLstring, Jstring, sizeof(VLstring));
		format(Jstring, sizeof(Jstring), "Stream Rate: %d\n",GetServerVarAsInt("stream_rate"));
		strcat(VLstring, Jstring, sizeof(VLstring));
		format(Jstring, sizeof(Jstring), "maxnpc: %d\n",GetServerVarAsInt("maxnpc"));
		strcat(VLstring, Jstring, sizeof(VLstring));
		ShowPlayerDialog(playerid, JDIALOGS+103, DIALOG_STYLE_MSGBOX, "{FFFFFF}Varlist", VLstring, "OK", "");
		strdel(VLstring, 0, 850);
		CommandToAdmins(playerid,"varlist");
		return 1;
    }
	else return ShowMessage(playerid, red, 1);
}

CMD:serverinfo(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 4)
	{
        strdel(VLstring, 0, 850);
        GetServerVarAsString("hostname", Jstring, sizeof(Jstring));
		format(Jstring, sizeof(Jstring), "Host Name: %s\n",Jstring);
		strcat(VLstring, Jstring, sizeof(VLstring));
		GetServerVarAsString("gamemodetext", Jstring, sizeof(Jstring));
		format(Jstring, sizeof(Jstring), "Gamemode Text: %s\n",Jstring);
		strcat(VLstring, Jstring, sizeof(VLstring));
		GetServerVarAsString("mapname", Jstring, sizeof(Jstring));
		format(Jstring, sizeof(Jstring), "Map Name: %s\n",Jstring);
		strcat(VLstring, Jstring, sizeof(VLstring));
		GetServerVarAsString("weburl", Jstring, sizeof(Jstring));
		format(Jstring, sizeof(Jstring), "Website: %s\n",Jstring);
		strcat(VLstring, Jstring, sizeof(VLstring));
		format(Jstring, sizeof(Jstring), "Port: %d\n",GetServerVarAsInt("port"));
		strcat(VLstring, Jstring, sizeof(VLstring));
		format(Jstring, sizeof(Jstring), "Online Players: %d\n",OnlinePlayersCount());
		strcat(VLstring, Jstring, sizeof(VLstring));
		format(Jstring, sizeof(Jstring), "Online admins: %d\n",OnlineAdminsCount());
		strcat(VLstring, Jstring, sizeof(VLstring));
		format(Jstring, sizeof(Jstring), "Vehicles: %d\n",ServerVehiclesCount());
		strcat(VLstring, Jstring, sizeof(VLstring));
		format(Jstring, sizeof(Jstring), "Objects: %d\n",ServerObjetsCount());
		strcat(VLstring, Jstring, sizeof(VLstring));
		format(Jstring, sizeof(Jstring), "Pickups: %d\n",ServerPickupsCount());
		strcat(VLstring, Jstring, sizeof(VLstring));
		format(Jstring, sizeof(Jstring), "Gang Zones: %d\n",ServerGangZonesCount());
		strcat(VLstring, Jstring, sizeof(VLstring));
		ShowPlayerDialog(playerid, JDIALOGS+103, DIALOG_STYLE_MSGBOX, "{FFFFFF}Server informations", VLstring, "OK", "");
		strdel(VLstring, 0, 850);
		CommandToAdmins(playerid,"serverinfo");
		return 1;
    }
	else return ShowMessage(playerid, red, 1);
}
CMD:pickup(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 4)
	{
		new type,id, pickupid, Float:X, Float:Y, Float:Z, Float:A;
	    if(sscanf(params, "ii",type,id)) return SendClientMessage(playerid,yellow,"Usage: /Pickup <Type> <Pickup ID>");
	    CommandToAdmins(playerid,"pickup");
	    GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid, A);
		X += (2 * floatsin(-A, degrees));
		Y += (2 * floatcos(-A, degrees));
	    switch(type)
		{
	        case 0,1,2,3,4,5,8,11,12,13,14,15,19,22: printf("[JLADMIN] Pickup created! Position - X: %0.3f, Y: %0.3f, Z: %0.3f", id, X, Y, Z);
	        default: return SendClientMessage(playerid,red,"Invalid pickup type!");
	    }
		pickupid = CreatePickup(id, type, X, Y, Z);
		format(Jstring, sizeof(Jstring), "Pickup Created | ID: %d | Model ID: %d | Pickup Position - X: %0.3f, Y: %0.3f, Z: %0.3f", pickupid, id, X, Y, Z);
		return SendClientMessage(playerid,yellow, Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:delpickup(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 4)
	{
		new id;
	    if(sscanf(params, "i",id)) return SendClientMessage(playerid,yellow,"Usage: /delpickup <Pickup ID>");
	    DestroyPickup(id);
	    CommandToAdmins(playerid,"delpickup");
		format(Jstring, sizeof(Jstring), "You have deteled the Pickup ID: '%d'", id);
		return SendClientMessage(playerid,yellow, Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:object(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 4)
	{
		new id, objectid, Float:X, Float:Y, Float:Z, Float:A;
	    if(sscanf(params, "i",id)) return SendClientMessage(playerid,yellow,"Usage: /Object <Object Model>");
	    CommandToAdmins(playerid,"object");
		GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid, A);
		X += (2 * floatsin(-A, degrees)); //Thanks to Y_Less
		Y += (2 * floatcos(-A, degrees));
	    objectid = CreateObject(id, X, Y, Z, 0.0, 0.0, A);
		format(Jstring, sizeof(Jstring), "Object Created | ID: %d | Object model: %d | Object Position - X: %0.3f, Y: %0.3f, Z: %0.3f", objectid, id, X, Y, Z);
		return SendClientMessage(playerid,yellow, Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:editobject(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 4)
	{
		new id, Float:X, Float:Y, Float:Z;
	    if(sscanf(params, "i",id)) return SendClientMessage(playerid,yellow,"Usage: /Editobject <Object ID>");
	    if(!IsValidObject(id)) return SendClientMessage(playerid,red, "Error: Invalid object!");
	    GetObjectPos(id,X,Y,Z);
	    if(!IsPlayerInRangeOfPoint(playerid, 20.0,X,Y,Z)) return SendClientMessage(playerid,red, "Error: You must go close of the object. try /gotoobject");
	    CommandToAdmins(playerid,"editobject");
		EditObject(playerid, id);
		format(Jstring, sizeof(Jstring), "You are editing the Object: %d, /Stopedit to stop editing.", id);
		return SendClientMessage(playerid,yellow, Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:stopedit(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 4)
	{
		CancelEdit(playerid);
        CommandToAdmins(playerid,"stopedit");
		return SendClientMessage(playerid, yellow, "You stopped editing the object!");
	}
	else return ShowMessage(playerid, red, 1);
}


CMD:gotoobject(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 4)
	{
		new id, Float:X, Float:Y, Float:Z;
	    if(sscanf(params, "i",id)) return SendClientMessage(playerid,yellow,"Usage: /Gotoobject <Object ID>");
	    if(!IsValidObject(id)) return SendClientMessage(playerid,red, "Error: Invalid object!");
	    GetObjectPos(id,X,Y,Z);
	    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		SetVehiclePos(GetPlayerVehicleID(playerid),X+3,Y,Z);
        else SetPlayerPos(playerid,X+3,Y,Z);
        CommandToAdmins(playerid,"gotoobject");
		format(Jstring, sizeof(Jstring), "You have been teleported to Object ID: '%d' | Position - X: %0.2f, Y: %0.2f, Z: %0.2f ", id, X, Y, Z);
		return SendClientMessage(playerid,yellow, Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:delobject(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 4)
	{
		new id;
	    if(sscanf(params, "i",id)) return SendClientMessage(playerid,yellow,"Usage: /delobject <Object ID>");
	    if(!IsValidObject(id)) return SendClientMessage(playerid,red, "Error: Invalid object!");
	    DestroyObject(id);
	    CommandToAdmins(playerid,"delobject");
		format(Jstring, sizeof(Jstring), "You have deteled the Object ID: '%d'", id);
		return SendClientMessage(playerid,yellow, Jstring);
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:ctele(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 4)
	{
		ShowPlayerDialog(playerid, JDIALOGS+115, DIALOG_STYLE_INPUT, "Create Teleport", "Enter the new teleport name", "Create", "Close");
		CommandToAdmins(playerid,"ctele");
		return 1;
    }
	else return ShowMessage(playerid, red, 1);
}

CMD:createtele(playerid,params[])
{
   return cmd_ctele(playerid,params);
}

CMD:reloadteles(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 5)
	{
        LoadTeleports();
        CommandToAdmins(playerid,"reloadteles");
        SendClientMessage(playerid,yellow,"You have re-loaded the teleports!");
		return 1;
    }
	else return ShowMessage(playerid, red, 1);
}

CMD:clearteles(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 5)
	{
        new file[100];
        format(file, 100, SETTING_PATH, "Teleports");
		if(!fexist(file)) return ShowPlayerDialog(playerid,JDIALOGS+44,DIALOG_STYLE_MSGBOX,"Error","{FF0000}Could not clear the teleports (Could not find the file)","Ok","");
		fremove(file);
		for(new i = 0; i < MAX_TELEPORTS; i++)
		strdel(TeleName[i],0,30);
		ShowPlayerDialog(playerid,JDIALOGS+44,DIALOG_STYLE_MSGBOX,"Teleports cleared","You have successfully cleared the teleports","Ok","");
		CommandToAdmins(playerid,"clearteles");
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:teles(playerid,params[])
{
    if(pInfo[playerid][pLevel] >= 1)
	{
		new string[128];
        strdel(VLstring, 0, 850);
        for(new i = 0; i <= TeleCount; i++)
        {
           format(string,sizeof(string),"%s\n",TeleName[i]);
           strcat(VLstring, string, sizeof(VLstring));
		}
		ShowPlayerDialog(playerid, JDIALOGS+114, DIALOG_STYLE_LIST, "Teleports", VLstring, "Teleport", "Close");
		CommandToAdmins(playerid,"teles");
		if(strlen(VLstring) <= 1) ShowPlayerDialog(playerid, JDIALOGS+116, DIALOG_STYLE_MSGBOX, "Teleports", "No teleports found! Hit create to make a new teleport", "Create", "Close");
		strdel(VLstring, 0, 850);
		return 1;
    }
	else return ShowMessage(playerid, red, 1);
}

CMD:teleports(playerid,params[])
{
   return cmd_teles(playerid,params);
}

CMD:setskill(playerid,params[])
{
      if(pInfo[playerid][pLevel] >= 3)
      {
           new id, type, level;
           if(sscanf(params, "uii", id,type, level)) return SendClientMessage(playerid, yellow, "Usage: /setskill <Player ID> <Weapon Type(0 - 10)> <skill level(0 - 999)>");
           if(!IsPlayerConnected(id)) return ShowMessage(playerid, red, 2);
           if(type < 0 || type > 10) return SendClientMessage(playerid, red, "Invalid Type!");
           if(level < 0 || level > 999) return SendClientMessage(playerid, red, "Invalid skill level!");
           CommandToAdmins(playerid,"setskill");
           switch(type)
		   {
              case 0: LevelName = "Pistol";
              case 1: LevelName = "Silenced pistol";
			  case 2: LevelName = "Desert eagle";
			  case 3: LevelName = "Shotgun";
			  case 4: LevelName = "Sawnoff shotgun";
			  case 5: LevelName = "Spas12 shotgun";
			  case 6: LevelName = "Micro UZI";
			  case 7: LevelName = "MP5";
			  case 8: LevelName = "AK-47";
			  case 9: LevelName = "M4";
			  default: LevelName = "Sniperriffle";
           }
           format(Jstring,sizeof(Jstring),"You have set %s's %s skill level to '%d'",GetName(id),LevelName,level);
		   SendClientMessage(playerid,yellow,Jstring);
		   format(Jstring,sizeof(Jstring),"Admin %s has set your %s skill level to '%d'",GetName(playerid),LevelName,level);
		   SendClientMessage(id,yellow,Jstring);
		   SetPlayerSkillLevel(playerid, type, level);
		   return 1;
      }
      else return ShowMessage(playerid, red, 1);
}

CMD:setdrunk(playerid,params[])
{
      if(pInfo[playerid][pLevel] >= 3)
      {
           new id, level;
           if(sscanf(params, "ui", id, level)) return SendClientMessage(playerid, yellow, "Usage: /setdrunk <Player ID> <drunk level> (2000 to make the player drunk!)");
           if(!IsPlayerConnected(id)) return ShowMessage(playerid, red, 2);
           if(level < 0 || level > 50000) return SendClientMessage(playerid, red, "Invalid drunk level!");
           CommandToAdmins(playerid,"setdrunk");
           format(Jstring,sizeof(Jstring),"You have set %s's drunk level to '%d'",GetName(id),level);
		   SendClientMessage(playerid,yellow,Jstring);
		   format(Jstring,sizeof(Jstring),"Admin %s has set your drunk level to '%d'",GetName(playerid),level);
		   SendClientMessage(id,yellow,Jstring);
		   SetPlayerDrunkLevel(id,level);
		   return 1;
      }
      else return ShowMessage(playerid, red, 1);
}

CMD:delaccount(playerid, params[])
{
    if(pInfo[playerid][pLevel] >= 5)
	{
		new Name[25],file[100];
		if(sscanf(params, "s[25]", Name)) return SendClientMessage(playerid, yellow, "Usage: /delaccount <Account Name>");
		format(file, 100, ACCOUNTS_PATH, Name);
        if (!fexist(file)) return SendClientMessage(playerid,red,"Error: No account found!!");
        CommandToAdmins(playerid,"delaccount");
        fremove(file);
        format(Jstring, sizeof(Jstring),"You have deleted the account '%s'",Name);
        SendClientMessage(playerid,yellow,Jstring);
        format(Jstring, sizeof(Jstring),"'%s' has deleted the account '%s'",GetName(playerid),Name);
        AlertToAdmins(playerid,orange,Jstring);
        format(Jstring,sizeof(Jstring),"%s has deleted the account: %s",GetName(playerid),Name);
		WriteToLog(Jstring,"AccountsLog");
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:newaccount(playerid, params[])
{
    if(pInfo[playerid][pLevel] >= 5)
	{
		new Name[25],file[100],pass[30],pIP[16],string[40],str[60],buf[145],year,month,day,hour,mins,sec;
		if(sscanf(params, "s[25]s[30]", Name, pass)) return SendClientMessage(playerid, yellow, "Usage: /newaccount <Account Name> <Password> will register a new account!");
		format(file, 100, ACCOUNTS_PATH, Name);
        if (fexist(file)) return SendClientMessage(playerid,red,"Error: That nick name is already in use!");
        if(InvalidNick(Name)) return SendClientMessage(playerid,red,"Unacceptable NickName. Please only use (0-9, a-z, [], (), $, @, ., _ and =)");
		if(strlen(pass) < 3 || strlen(pass) > 20) return SendClientMessage(playerid,red,"Error: Password lengh must be between 3 - 20 characters!");
		CommandToAdmins(playerid,"newaccount");
		getdate(year, month, day);
		gettime(hour,mins,sec);
		GetPlayerIp(playerid,pIP,16);
		format(string, 40,"%d/%d/%d at %d:%d:%d", day,month,year,hour,mins,sec);
		format(str, 60,"%d/%d/%d at %d:%d:%d", day,month,year,hour,mins,sec);
		format(file, 100, ACCOUNTS_PATH, Name);
		WP_Hash(buf, sizeof(buf),pass);
		new INI:ACCOUNT = INI_Open(file);
		INI_WriteString(ACCOUNT, "RegisteredOn", string);
		INI_WriteString(ACCOUNT, "RegisteredIP", pIP);
		INI_WriteString(ACCOUNT, "LastLoggedIP", "None");
		INI_WriteString(ACCOUNT, "Password",buf);
		INI_WriteInt(ACCOUNT, "Level", 0);
		INI_WriteInt(ACCOUNT, "Banned", 0);
		INI_WriteInt(ACCOUNT, "Donator", 0);
		INI_WriteInt(ACCOUNT, "Score", START_SCORE);
		INI_WriteInt(ACCOUNT, "Cash", START_CASH);
		INI_WriteInt(ACCOUNT, "Kills", 0);
		INI_WriteInt(ACCOUNT, "Deaths", 0);
		INI_WriteInt(ACCOUNT, "Skin", 0);
		INI_WriteInt(ACCOUNT, "Muted", 0);
		INI_WriteInt(ACCOUNT, "Autologin", 1);
		INI_WriteInt(ACCOUNT, "TotalSeconds", 0);
		INI_WriteString(ACCOUNT, "TotalSpentTime", "None");
		INI_WriteString(ACCOUNT, "LastSeen", "Never Seen");
		INI_Close(ACCOUNT);
        format(Jstring, sizeof(Jstring),"You have successfully created the new account '%s' on database",Name);
        SendClientMessage(playerid,yellow,Jstring);
        format(Jstring, sizeof(Jstring),"'%s' has created the new account '%s' on database",GetName(playerid),Name);
        AlertToAdmins(playerid,orange,Jstring);
        format(Jstring,sizeof(Jstring),"%s has created the new account: %s",GetName(playerid),Name);
		WriteToLog(Jstring,"AccountsLog");
		return 1;
	}
	else return ShowMessage(playerid, red, 1);
}

CMD:hidecar(playerid,params[])
{
      if(pInfo[playerid][pLevel] >= 3)
      {
		  if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		  {
              CommandToAdmins(playerid,"hidecar");
			  SetPVarInt(playerid,"Interior", GetPlayerInterior(playerid));
              LinkVehicleToInterior(GetPlayerVehicleID(playerid),GetPlayerInterior(playerid)+2);
              GameTextForPlayerEx(playerid, "~G~Car Invisibled",2000,3);
              SendClientMessage(playerid,yellow,"Your vehicle has been set to an another interior. No one can see it!");
              return 1;
          }
		  else return SendClientMessage(playerid,red,"You must be in vehicle driver seat to use this command!");
      }
      else return ShowMessage(playerid, red, 1);
}

CMD:unhidecar(playerid,params[])
{
      if(pInfo[playerid][pLevel] >= 3)
      {
		  if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		  {
              CommandToAdmins(playerid,"unhidecar");
			  SetPVarInt(playerid,"Interior", GetPlayerInterior(playerid));
              LinkVehicleToInterior(GetPlayerVehicleID(playerid),GetPVarInt(playerid,"Interior"));
              GameTextForPlayerEx(playerid, "~b~Car visibled",2000,3);
              return 1;
          }
	      else return SendClientMessage(playerid,red,"You must be in vehicle driver seat to use this command!");
      }
      else return ShowMessage(playerid, red, 1);
}


public GiveVehicle(playerid,vehicleid)
{
	if(!IsPlayerInAnyVehicle(playerid))
	{
	    new Float:x, Float:y, Float:z, Float:angle;
	    if(pInfo[playerid][LastSpawnedCar] >= 0 || pInfo[playerid][LastSpawnedCar] != INVALID_VEHICLE_ID )
		{
	    	DestroyVehicle(pInfo[playerid][LastSpawnedCar]);
		}
		GetPlayerPos(playerid, x, y, z);
	 	GetPlayerFacingAngle(playerid, angle);
	    new veh = CreateVehicle(vehicleid, x, y, z, angle, -1, -1, -1);
		SetVehicleVirtualWorld(veh, GetPlayerVirtualWorld(playerid));
		LinkVehicleToInterior(veh, GetPlayerInterior(playerid));
		PutPlayerInVehicle(playerid, veh, 0);
		pInfo[playerid][LastSpawnedCar] = veh;
		format(Jstring,sizeof(Jstring),"You have spawned a '%s' (Model ID: %d)", VehicleNames[vehicleid-400],vehicleid);
		return SendClientMessage(playerid, lighterblue, Jstring);
	}
	return 1;
}

public SpawnVehicle(playerid,vehicleid)
{
    new Float:x, Float:y, Float:z, Float:angle;
    if(pInfo[playerid][SpawnedCars] >= MAX_CAR_SPAWNS) return SendClientMessage(playerid, lighterblue, "You have reach the maximum car spawns amount. please /destroycars if you wish to created more cars!");
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);
	pInfo[playerid][Cars][pInfo[playerid][SpawnedCars]] = CreateVehicle(vehicleid, x+3, y, z, angle, -1, -1, -1);
	SetVehicleVirtualWorld(pInfo[playerid][Cars][pInfo[playerid][SpawnedCars]], GetPlayerVirtualWorld(playerid));
	LinkVehicleToInterior(pInfo[playerid][Cars][pInfo[playerid][SpawnedCars]], GetPlayerInterior(playerid));
	pInfo[playerid][SpawnedCars]++;
	format(Jstring,sizeof(Jstring),"You have spawned a '%s' (Model ID: %d) [%d/%d]", VehicleNames[vehicleid-400],vehicleid,pInfo[playerid][SpawnedCars],MAX_CAR_SPAWNS);
	return SendClientMessage(playerid, lighterblue, Jstring);
}

public CountDown()
{
    if(cd_seconds >= 1)
	{
		SoundForAll(1057);
		format(cdstr,256,"~g~%d",cd_seconds);
		GametextForAllEx(cdstr,1000,3);
	}
	else
	{
	    if(cd_freeze >= 1)
		{
		  foreach(Player, i)
		  {
			       TogglePlayerControllable(i, 1);
			       pInfo[i][Frozen]=0;
          }
          cd_freeze = 0;
        }
		SoundForAll(1058);
		GametextForAllEx("~B~Go!",1000,3);
		cd_started = 0;
		KillTimer(cd_timer);
	}
	cd_seconds--;
	return 1;
}

stock LoadSettings()
{
	new file[100];
	format(file,sizeof(file),"JLadmin/Settings/settings.cfg");
	if(!fexist(file))
    {
        print("\n WARNING: No setting.cfg File found!\n\n - Creating a new file..");
        format(file,sizeof(file),"JLadmin/Settings/settings.cfg");
        new INI:SETTING = INI_Open(file);
		INI_WriteInt(SETTING, "AutoLogin", 1);
		INI_WriteInt(SETTING, "DetectPausers", 1);
		INI_WriteInt(SETTING, "MustRegister", 0);
		INI_WriteInt(SETTING, "MaxPing", 8000);
		INI_WriteInt(SETTING, "PmDialog", 1);
		INI_WriteInt(SETTING, "AntiSpam", 1);
		INI_WriteInt(SETTING, "AntiWeaponHack", 1);
		INI_WriteInt(SETTING, "MaxLevels", 6);
		INI_WriteInt(SETTING, "AntiBadWords", 1);
		INI_WriteInt(SETTING, "ForbiddenNamesKick", 1);
		INI_WriteInt(SETTING, "PartNamesKick", 1);
		INI_WriteInt(SETTING, "AntiAdvertisements", 1);
		INI_WriteInt(SETTING, "AntiBanEvade", 1);
		INI_WriteInt(SETTING, "AdminImmunity", 1);
		INI_WriteInt(SETTING, "AdminReadPms", 1);
		INI_WriteInt(SETTING, "AdminReadCmds", 1);
		INI_WriteInt(SETTING, "AntiCheatbans", 1);
		INI_WriteInt(SETTING, "AllowChangeName", 1);
		INI_Close(SETTING);
		print("\n - JLadmin/Settings/settings.cfg file successfully created!");
    }
	format(file,sizeof(file),"JLadmin/Settings/settings.cfg");
	INI_ParseFile(file, "LoadServerSetttings");
	print("\n -J.L Admin system Configurations Successfully Loaded!");
}

stock ShowMessage(playerid, color, msgid)
{
  switch(msgid)
  {
     case 1: SendClientMessage(playerid,color,"Your level is not high to use this command");
	 case 2: SendClientMessage(playerid,color,"Player is not connected");
	 case 3: SendClientMessage(playerid,color,"Player not connected or it's Yourself");
	 case 4: SendClientMessage(playerid,color,"You must be logged in to use this command");
	 case 5: SendClientMessage(playerid,color,"Player is not in a vehicle");
	 case 6: SendClientMessage(playerid,color,"You can not perform command on this admin");
	 case 7: SendClientMessage(playerid,color,"You have a vehicle already!");
  }
  return 1;
}

stock SoundForAll(soundid)
{
    foreach(Player, i)
	PlayerPlaySound(i, soundid, 0, 0, 0);
	return 1;
}

stock SpecNext(playerid)
{
   if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && Specid[playerid] != INVALID_PLAYER_ID && pInfo[playerid][Spec] == 1)
   {
       if(OnlinePlayersCount() <= 2)
	   {
           TogglePlayerSpectating(playerid, 0);
		   pInfo[playerid][Spec] = 0;
		   SetTimerEx("Specoff",500,0,"d",playerid);
		   #if SpecTextDraw == true
		   TextDrawHideForPlayer(playerid, SpecGTD);
		   PlayerTextDrawHide(playerid, SpecPTD);
		   #endif
		   return 1;
       }
       if(Specid[playerid] >= MaxPlayerID() || Specid[playerid] < 0) Specid[playerid] = -1;
	   for(new i=Specid[playerid]+1; i<=MaxPlayerID(); i++)
	   {
          if(!IsPlayerConnected(i) || i == playerid || GetPlayerState(i) == PLAYER_STATE_SPECTATING || i == INVALID_PLAYER_ID || i == Specid[playerid])
		  {
			  Specid[playerid]++;
			  if(Specid[playerid] >= MaxPlayerID() || Specid[playerid] < 0)
			  {
			     SpecNext(playerid);
			     break;
			  }
			  else
			  continue;
		  }
          SetPlayerInterior(playerid,GetPlayerInterior(i));
          SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(i));
		  if(IsPlayerInAnyVehicle(Specid[playerid]))
		  PlayerSpectateVehicle(playerid, GetPlayerVehicleID(i));
		  else
		  PlayerSpectatePlayer(playerid, i);
		  #if SpecTextDraw == true
		  UpdteSpecTD(playerid,i);
		  #endif
		  Specid[playerid]=i;
		  break;
	   }
   }
   return 1;
}

stock SpecPrv(playerid)
{
   if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && Specid[playerid] != INVALID_PLAYER_ID && pInfo[playerid][Spec] == 1)
   {
       if(OnlinePlayersCount() <= 2)
	   {
           TogglePlayerSpectating(playerid, 0);
		   pInfo[playerid][Spec] = 0;
		   SetTimerEx("Specoff",500,0,"d",playerid);
		   #if SpecTextDraw == true
		   TextDrawHideForPlayer(playerid, SpecGTD);
		   PlayerTextDrawHide(playerid, SpecPTD);
		   #endif
		   return 1;
       }
       if(Specid[playerid] > MaxPlayerID() || Specid[playerid] <= 0) Specid[playerid] = MaxPlayerID()+1;
	   for(new i=Specid[playerid]-1; i>=0; i--)
	   {
          if(!IsPlayerConnected(i) || i == playerid || GetPlayerState(i) == PLAYER_STATE_SPECTATING || i == INVALID_PLAYER_ID || i == Specid[playerid])
          {
              Specid[playerid]--;
              if(Specid[playerid] > MaxPlayerID() || Specid[playerid] <= 0)
			  {
			     SpecPrv(playerid);
			     break;
			  }
			  else
			  continue;
          }
          SetPlayerInterior(playerid,GetPlayerInterior(i));
          SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(i));
		  if(IsPlayerInAnyVehicle(Specid[playerid]))
		  PlayerSpectateVehicle(playerid, GetPlayerVehicleID(i));
		  else
		  PlayerSpectatePlayer(playerid, i);
		  #if SpecTextDraw == true
		  UpdteSpecTD(playerid,i);
		  #endif
		  Specid[playerid]=i;
		  break;
	   }
   }
   return 1;
}

#if SpecTextDraw == true
stock UpdteSpecTD(playerid,spectatingID)
{
   new Float:Health,Float:Armour;
   GetPlayerHealth(spectatingID, Health);
   GetPlayerArmour(spectatingID,Armour);
   format(JLspec,sizeof(JLspec),"~G~Name : ~W~%s~N~~G~Health   :     ~W~%0.1f~N~~G~Armour  :     ~W~%0.1f~N~~G~World    :     ~W~%d~N~~G~Interior  :     ~W~%d~N~~G~Score    :     ~W~%d~N~~B~Cash     :     ~W~%d~N~_",GetName(spectatingID), Health , Armour, GetPlayerVirtualWorld(spectatingID), GetPlayerInterior(spectatingID), GetPlayerScore(spectatingID), GetPlayerMoney(spectatingID));
   PlayerTextDrawSetString(playerid, SpecPTD, JLspec);
   return 1;
}
#endif
stock MaxPlayerID()
{
	new maxid=0;
	foreach(Player, i)
	maxid=i;
	return maxid;
}

stock OnlinePlayersCount()
{
	new count=0;
	foreach(Player, i)
	count++;
	return count;
}

stock OnlineAdminsCount()
{
	new count=0;
	foreach(Player, i)
	if(pInfo[i][pLevel] >= 1)
	count++;
	return count;
}

stock ServerObjetsCount()
{
	new count;
	count = CreateObject(987, 0, 0, 0, 0, 0, 0);
	DestroyObject(count);
	count = count - 1;
	return count;
}

stock ServerPickupsCount()
{
	new count;
	count = CreatePickup(2914,2,0,0,0);
	DestroyPickup(count);
	if(count != 0) count = count - 1;
	return count;
}

stock ServerVehiclesCount()
{
	new count;
	count = CreateVehicle(560, 0, 0, 0, 0, -1, -1, -1);
	DestroyVehicle(count);
	count = count - 1;
	return count;
}

stock ServerGangZonesCount()
{
	new count;
	count = GangZoneCreate(2,2,4,4);
	GangZoneDestroy(count);
	if(count != 0) count = count - 1;
	return count;
}

/*---------------------------------*/
/*---send message to all admins----*/
/*---------------------------------*/
stock SendToAdmins(color,Message[])
{
	foreach(Player, i)
	{
	if(pInfo[i][pLevel] >= 1)
	SendClientMessage(i, color, Message);
	}
	return 1;
}
/*----------------------------------------------------------------------------*/
/*---send message to high level admins and same level admins with playerid----*/
/*----------------------------------------------------------------------------*/
stock AlertToAdmins(playerid,color,Message[])
{
	foreach(Player, i)
	{
	if(pInfo[i][pLevel] >= 1 && pInfo[i][pLevel] >= pInfo[playerid][pLevel] && playerid != i)
	SendClientMessage(i, color, Message);
	}
	return 1;
}

stock CommandToAdmins(playerid,cmd[])
{
	format(Cmdstr,sizeof(Cmdstr),"** %s has used Command /%s",GetName(playerid),cmd);
	foreach(Player, i)
	{
		if(pInfo[i][pLevel] >= 1 && playerid != i)
		SendClientMessage(i, cream, Cmdstr);
	}
	return 1;
}
public BanPlayer(playerid,reasonid)
{
	if(reasonid == 0)
	{
       GetPVarString(playerid, "Banreason", Jstring, 500);
	   return BanEx(playerid,Jstring);
	}
	if(reasonid == 1)
	{
	   return BanEx(playerid,"ban evading");
	}
	if(reasonid == 2)
	{
	   return BanEx(playerid,"Weapon hack");
	}
	return 1;
}

public OnPrivateMessage(sender, recieverid, Message[])
{
    if(pInfo[sender][Muted] == 1)
	{
		SendClientMessage(sender,red,"WARNING: You are muted! You can't send PMs");
		return 1;
	}
	format(Jstring,sizeof(Jstring),"PM sent to %s(%d): %s",GetName(recieverid),recieverid,Message);
	SendClientMessage(sender,lighterblue,Jstring);
	format(Jstring, sizeof(Jstring),"Private Message from: %s(%d): %s",GetName(sender),sender,Message);
	SendClientMessage(recieverid,lighterblue,Jstring);
	if(ShowPmstoAdmins == 1)
	{
	   foreach(Player, i)
	   {
	      if(pInfo[i][pLevel] >= 5 && i != sender && i != recieverid && pInfo[i][pLevel] > pInfo[sender][pLevel])
	      {
	         format(Jstring,sizeof(Jstring),"PM from %s(%d) to %s(%d): %s",GetName(sender),sender,GetName(recieverid),recieverid,Message);
		     SendClientMessage(i,0x7A9966C8,Jstring);
		  }
	   }
	}
	format(Jstring,sizeof(Jstring),"Private Message from '%s' to '%s': %s",GetName(sender),GetName(recieverid),Message);
	WriteToLog(Jstring,"PrivateMessages");
	return 1;
}

public KickPlayer(playerid)
{
	if(IsPlayerConnected(playerid))
		Kick(playerid);
		
	return 1;
}

public Kickallplayers(playerid)
{
	foreach(Player, i)
	{
		if(playerid != i && pInfo[i][pLevel] < pInfo[playerid][pLevel])
		{
		    Kick(i);
		}
	}
	
	return 1;
}

public Unfreeze(playerid)
{
	KillTimer(Ftimer[playerid]);
	if(IsPlayerConnected(playerid))
	{
		TogglePlayerControllable(playerid,true);
		pInfo[playerid][Frozen] = 0;
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		GameTextForPlayerEx(playerid,"~G~unfrozen",3000,3);
	}
}

public UnmutePlayer(playerid)
{
	KillTimer(Mtimer[playerid]);
	if(IsPlayerConnected(playerid))
	{
		pInfo[playerid][Muted] = 0;
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		GameTextForPlayerEx(playerid,"~G~Unmuted",3000,3);
	}
}

public Unjail(playerid)
{
	KillTimer(Jtimer[playerid]);
	if(IsPlayerConnected(playerid))
	{
		TogglePlayerControllable(playerid,true);
		pInfo[playerid][Jailed] = 0;
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		SpawnPlayer(playerid);
		GameTextForPlayerEx(playerid,"~G~Unjailed!",3000,3);
	}
}

public JailPlayer(playerid)
{
    if(IsPlayerConnected(playerid))
    {
		KillTimer(JPlayer[playerid]);
		TogglePlayerControllable(playerid,true);
		SetPlayerPos(playerid,197.6661,173.8179,1003.0234);
		SetPlayerInterior(playerid,3);
		SetCameraBehindPlayer(playerid);
	}
}

public Specoff(playerid)
{
	SetPlayerPos(playerid,GetPVarFloat(playerid,"JX"),GetPVarFloat(playerid,"JY"),GetPVarFloat(playerid,"JZ"));
	SetPlayerInterior(playerid,GetPVarInt(playerid,"Int"));
	SetPlayerVirtualWorld(playerid, GetPVarInt(playerid,"vworld"));
	SetPlayerHealth(playerid, GetPVarFloat(playerid,"Health"));
	SetPlayerArmour(playerid, GetPVarFloat(playerid,"Armour"));
	SetPlayerWeapons(playerid);
	SendClientMessage(playerid,lighterblue,"You are NOT spectating now, You have returned to where you started spectating!");
}

public HidePlayer(playerid)
{
    if(GetPVarInt(playerid,"MapHidden") == 1)
    {
	   foreach(Player, i)
       {
             SetPlayerMarkerForPlayer(i,playerid,(GetPlayerColor(playerid)& 0xFFFFFF00));
       }
	}
    if(pInfo[playerid][NameTagHidden] == 1)
    {
        foreach(Player, i)
    	{
     	ShowPlayerNameTagForPlayer(i, playerid, false);
    	}
    }
	return 1;
}

stock UnoccupiedVehicle(vehicleid)
{
  foreach(Player, i)
  {
      if(IsPlayerInVehicle(i,vehicleid)) return 0;
  }
  return 1;
}

stock IsNumeric(string[])
{
	for (new i = 0, j = strlen(string);
	i < j; i++)
	{
	if (string[i] > '9' || string[i] < '0')
	return 0;
	}
	return 1;
}


stock InvalidNick(string[])
{
  new i = 0;
  while (string[i])
  {
      switch(string[i])
	  {
           case '!': return 1;
		   case '#': return 1;
		   case '%': return 1;
		   case '^': return 1;
		   case '&': return 1;
		   case '*': return 1;
		   case '/': return 1;
		   case ':': return 1;
		   case '-': return 1;
		   case ';': return 1;
		   case '+': return 1;
		   case '<': return 1;
		   case '>': return 1;
		   case '?': return 1;
		   case ',': return 1;
		   case '`': return 1;
		   case ' ': return 1;
		   case '~': return 1;
		   case '}': return 1;
		   case '{': return 1;
      }
      i++;
  }
  return 0;
}

stock GetWeaponID(Name[])
{
    new weapname[40];
	for(new w = 1; w <= 46; w++)
	{
	   if(w == 0 || w ==  19 || w == 20 || w == 21 || w ==44|| w == 45) continue;
       GetWeaponName(w, weapname, sizeof(weapname));
	   if(strfind(weapname,Name,true) != -1)
	   return w;
	}
	return false;
}

stock JLrename(file[],newname[])
{
    new string[600],temp[145],Jfile[100];
    if(!fexist(file)) return printf("-WARNING: Couldn't rename the file %s\n File/Path not found!",file);
    new File:JLfile = fopen(file, io_read);
    while(fread(JLfile, temp))
    {
        strcat(string, temp);
    }
    fclose(JLfile);
    fremove(file);
	format(Jfile, sizeof(Jfile), ACCOUNTS_PATH, newname);
    new File:JLnew = fopen(Jfile, io_write);
    if(JLnew)
    {
        fwrite(JLnew, string);
        fclose(JLnew);
    }
    return 1;
}

WriteToLog(string[], Logname[])
{
	new file[256];
	new y,m,d,hour,mint,sec;
	getdate(y,m,d);
	gettime(hour,mint,sec);
	format(file, 128, LOGS_PATH, Logname);
	format(JLstring,sizeof(JLstring),"%d/%d/%d @ %d:%d:%d %s\r\n",d,m,y,hour,mint,sec,string);
	new File:JLlog = fopen(file,io_append);
	fwrite(JLlog,JLstring);
	fclose(JLlog);
	return 1;
}

stock LoadIllegalWeaps()
{
    new weap[20],tfile[128],name[128];
    name= "Illegalweapons";
    IllegalWeaponsCount=0;
    format(tfile, 128, SETTING_PATH, name);
    if(!fexist(tfile))
	{
		print("\n-couldn't find illegal weapons file-  Creating a new file..");
		new File:JLnew = fopen(tfile, io_write);
		if(JLnew)
		{
            fclose(JLnew);
        }
        printf("\nIllegal weapons file successfully created\n-Path- %s\n", tfile);
    }
    new File:JLfile = fopen(tfile, io_read); 
    while(fread(JLfile, weap))
    {
        if(IllegalWeaponsCount >= MAX_ILLEGAL_WEAPONS)
        {
             printf("-NOTE: Exceeded Maximum illegal weapons (%d)\nPlease delete some illgel weapon ID((s) Illegalweapons.INI file", MAX_ILLEGAL_WEAPONS);
		     break;
        }
		IllegalWeapons[IllegalWeaponsCount] = strval(weap);
		IllegalWeaponsCount++;
    }
    fclose(JLfile);
    if(IllegalWeaponsCount == 0) print("\n-- No Illegal Weapons Loaded! --\n");
    else printf("\n-- %d Illegal weapons successfully loaded --\n", IllegalWeaponsCount);
    return 1;
}

stock IllegalWeaps(WeaponID)
{
	for(new i = 0; i <= IllegalWeaponsCount; i++)
	{
       if(IllegalWeapons[i] == 0) continue;
	   if(IllegalWeapons[i] == WeaponID)
	   return true;
	}
	return false;
}

stock LoadForbiddenNicks()
{
    new Nicks[20],tfile[128];
    ForbiddeNicksCount=0;
    format(tfile, 128, SETTING_PATH, "ForbiddeNicks");
    if(!fexist(tfile))
	{
		print("\n-couldn't find Forbidden nicks file-  Creating a new file..");
		new File:JLnew = fopen(tfile, io_write);
		if(JLnew)
		{
            fclose(JLnew);
        }
        printf("\nIllegal Forbidden nicks file successfully created\n-Path- %s\n", tfile);
    }
    new File:JLfile = fopen(tfile, io_read);
    while(fread(JLfile, Nicks))
    {
        if(ForbiddeNicksCount >= MAX_FORBIDDEN_NAMES)
		{
		    printf("-NOTE: Exceeded Maximum Forbidden Nick Names Ammout (%d)\nPlease delete extra Forbidden nicks from ForbiddeNicks.INI file", MAX_FORBIDDEN_NAMES);
		    break;
		}
		ForbiddeNicks[ForbiddeNicksCount]=Nicks;
		if(strfind(ForbiddeNicks[ForbiddeNicksCount], "\r\n") != -1)
		strdel(ForbiddeNicks[ForbiddeNicksCount],strlen(ForbiddeNicks[ForbiddeNicksCount])-2,strlen(ForbiddeNicks[ForbiddeNicksCount]));
		ForbiddeNicksCount++;
    }
    fclose(JLfile);
    if(ForbiddeNicksCount == 0) print("\n-- No Forbidden nick names Loaded! --\n");
    else printf("\n-- %d Forbidden nick names successfully loaded --\n", ForbiddeNicksCount);
    return 1;
}

stock IsForbiddenNick(playerid)
{
	for(new i = 0; i <= ForbiddeNicksCount; i++)
	{
       if(strlen(ForbiddeNicks[i]) < 3) continue; 
	   if(strcmp(GetName(playerid),ForbiddeNicks[i],true) == 0)
	   return 1;
	}
	return 0;
}

stock LoadBadNickParts()
{
    new Parts[20],tfile[128];
    BadPartNicksCount=0;
    format(tfile, 128, SETTING_PATH, "ForbiddeNickParts");
    if(!fexist(tfile))
	{
		print("\n-couldn't find Forbidden Part nick file-  Creating a new file..");
		new File:JLnew = fopen(tfile, io_write);
		if(JLnew)
		{
            fclose(JLnew);
        }
        printf("\nIllegal Forbidden part nick file successfully created\n-Path- %s\n", tfile);
    }
    new File:JLfile = fopen(tfile, io_read);
    while(fread(JLfile, Parts))
    {
        if(BadPartNicksCount >= MAX_BADNICKS_PARTS)
		{
		    printf("-NOTE: Exceeded Maximum Forbidden Part Nicks Ammout (%d)\nPlease delete extra Forbidden Part nicks from ForbiddeNickParts.INI file", MAX_BADNICKS_PARTS);
		    break;
		}
		BadNickParts[BadPartNicksCount]=Parts;
		if(strfind(BadNickParts[BadPartNicksCount], "\r\n") != -1)
		strdel(BadNickParts[BadPartNicksCount],strlen(BadNickParts[BadPartNicksCount])-2,strlen(BadNickParts[BadPartNicksCount]));
		BadPartNicksCount++;
    }
    fclose(JLfile);
    if(BadPartNicksCount == 0) print("\n-- No Forbidden Part nicks Loaded! --\n");
    else printf("\n-- %d Forbidden Part nicks successfully loaded --\n", BadPartNicksCount);
    return 1;
}

stock IsBadNickPart(playerid)
{
	for(new i = 0; i <= BadPartNicksCount; i++)
	{
       if(strlen(BadNickParts[i]) < 2) continue;
	   if(strfind(GetName(playerid), BadNickParts[i], true) != -1)
	   {
		   BadPartID = i;
		   return 1;
	   }
	}
	return 0;
}

stock LoadBadWords()
{
    new Word[20],tfile[128];
    BadWordsCount=0;
    format(tfile, 128, SETTING_PATH, "BadWords");
    if(!fexist(tfile))
	{
		print("\n-couldn't find Bad words file-  Creating a new file..");
		new File:JLnew = fopen(tfile, io_write);
		if(JLnew)
		{
            fclose(JLnew);
        }
        printf("\nBad words file successfully created\n-Path- %s\n", tfile);
    }
    new File:JLfile = fopen(tfile, io_read); 
    while(fread(JLfile, Word)) 
    {
        if(BadWordsCount >= MAX_BAD_WORDS)
		{
		    printf("-NOTE: Exceeded Maximum Bad words Ammout (%d)\nPlease delete extra Bad words from BadWords.INI file", MAX_BAD_WORDS);
		    break;
		}
		ForbiddenWords[BadWordsCount]=Word;
		if(strfind(ForbiddenWords[BadWordsCount], "\r\n") != -1)
		strdel(ForbiddenWords[BadWordsCount],strlen(ForbiddenWords[BadWordsCount])-2,strlen(ForbiddenWords[BadWordsCount]));
		BadWordsCount++;
    }
    fclose(JLfile);
    if(BadWordsCount == 0) print("\n-- No Bad words Loaded! --\n");
    else printf("\n-- %d Bad words successfully loaded --\n", BadWordsCount);
    return 1;
}

public LoadTeleports()
{
	new temp[200],file[100];
	format(file, 100, SETTING_PATH, "Teleports");
	if(!fexist(file))
	{
		  printf("--No Teleports File/Path Found!--\nCreating a new file..");
		  new File:JLnew = fopen(file, io_write);
		  if(JLnew)
		  {
            fclose(JLnew);
          }
   	      printf("\n Teleports file successfully created: %s\n", file);
   	      return 1;
	}
	TeleCount = 0;
	new File:Jfile = fopen(file, io_read);
	while(fread(Jfile,temp,sizeof(temp),false))
	{
        if(strlen(temp) < 10) continue;
        if(TeleCount >= MAX_TELEPORTS -1)
		{
		   printf("[JLADMIN] WARNING: Exceeded maximum teleports amount. Please delete some\n teleports from %s !",file);
		   break;
		}
        if(sscanf(temp, "s[30]fffii",TeleName[TeleCount], TeleCoords[TeleCount][0], TeleCoords[TeleCount][1], TeleCoords[TeleCount][2], Teleinfo[TeleCount][0], Teleinfo[TeleCount][1])) continue;
        if(strfind(TeleName[TeleCount],"_",true) != -1 )
        {
            new i = 0;
		    while (TeleName[TeleCount][i])
		    {
		        if (TeleName[TeleCount][i] == '_')
				TeleName[TeleCount][i] = ' ';
		        i++;
		    }
        }
        TeleCount++;
	}
	fclose(Jfile);
	if(TeleCount == 0) printf("--No Teleports loaded!--");
	else printf("--%d Teleports loaded!--",TeleCount);
	return 1;
}

stock IsBadWord(text[])
{
	for(new i = 0; i <= BadWordsCount; i++)
	{
       if((WordEn = strlen(ForbiddenWords[i])) < 2) continue;
	   if((WordSt = strfind(text, ForbiddenWords[i], true)) != -1)return 1;
	}
	return 0;
}

stock IsAdvertisement(text[])
{
	new NuCnt,DotCnt;
	for (new i = 0, l = strlen(text); i < l; i++)
	{
	  if ('0' <= text[i] <= '9'){
	  NuCnt++; continue;}
	  if(text[i] == '.' || text[i] == ':' || text[i] == '_')
	  if(text[i+1] != '.' && text[i+1] != ':' && text[i+1] != '_')
	  DotCnt++;
	  if (NuCnt >= 7 && DotCnt >= 3)
	  return true;
	}
	return false;
}

stock IsValidTag(text)
{
  switch(text)
  {
       case 'G': return 1;
	   case 'P': return 1;
	   case 'B': return 1;
	   case 'R': return 1;
	   case 'Y': return 1;
	   case 'H': return 1;
	   case 'W': return 1;
	   case 'N': return 1;
	   case 'g': return 1;
	   case 'p': return 1;
	   case 'b': return 1;
	   case 'r': return 1;
	   case 'y': return 1;
	   case 'h': return 1;
	   case 'w': return 1;
	   case 'n': return 1;
  }
  return 0;
}

stock IsBadTags(text[])
{
    new i = 0;
    while (text[i])
	{
        if(strfind(text[i],"~",true) != -1)
        {
	       if(text[i] == '~' && IsValidTag(text[i+1]) && text[i+2] == '~')
	       i = i+2;
	       else
		   if(text[i] == '~')
		   return true;
		}
		i++;
	}
	return false;
}

stock GametextForAllEx(text[], time, style)
{
    new i = 0, len;
    while (text[i])
	{
        if((len = strfind(text[i],"~",true)) != -1)
        {
	       if(text[i] == '~' && IsValidTag(text[i+1]) && text[i+2] == '~')
	       i = i+2;
	       else
		   if(text[i] == '~')
		   {
		   strdel(text[i],len,len+1);
		   continue;
		   }
		}
		i++;
	}
	return GameTextForAll(text, time, style);
}

stock GameTextForPlayerEx(playerid, text[], time, style)
{
    new i = 0, len;
    while (text[i])
	{
        if((len = strfind(text[i],"~",true)) != -1)
        {
	       if(text[i] == '~' && IsValidTag(text[i+1]) && text[i+2] == '~')
	       i = i+2;
	       else
		   if(text[i] == '~')
		   {
		   strdel(text[i],len,len+1);
		   continue;
		   }
		}
		i++;
	}
	return GameTextForPlayer(playerid, text, time, style);
}


public StoreChatLine(playerid,text[])
{
	 for(new i = 0; i < MAX_CHAT_MSGS_STORE-1; i++)
	 ChatMessages[i] = ChatMessages[i+1];
	 format(Jstring,sizeof(Jstring),"%s(ID: %d): %s",GetName(playerid),playerid,text);
	 ChatMessages[MAX_CHAT_MSGS_STORE-1] = Jstring;
}

public StoreReport(playerid,reported,reason[])
{
     new hour,minute,second;
	 gettime(hour,minute,second);
	 for(new i = 0; i < MAX_REPORTS_STORE-1; i++)
	 Reports[i] = Reports[i+1];
	 format(Jstring,sizeof(Jstring),"%d:%d:%d - %s(ID: %d) Has Reported %s(ID: %d) |{FF0000} REASON: %s ",hour,minute,second,GetName(playerid),playerid,GetName(reported),reported,reason);
	 Reports[MAX_REPORTS_STORE-1] = Jstring;
}

stock PrintConfiguration()
{
    printf(" [JLADMIN] Auto login         %d",AutoLogin);
	printf(" [JLADMIN] Must register      %d",MustRegister);
	printf(" [JLADMIN] Detect pausers     %d",DetectPausers);
	printf(" [JLADMIN] MaxPing            %d",MaxPing);
	printf(" [JLADMIN] AntiSpam           %d",AntiSpam);
	printf(" [JLADMIN] PM Dialog          %d",PmDialog);
	printf(" [JLADMIN] AntiWeaponHack     %d",AntiWeaponHack);
	printf(" [JLADMIN] MaxAdminLevel      %d",MaxAdminLevel);
	printf(" [JLADMIN] Anti Bad Words     %d",AntiForbiddenWords);
	printf(" [JLADMIN] AntiBanEvade       %d",AntiBanEvade);
	printf(" [JLADMIN] Anti Advertise     %d",AntiAdv);
	printf(" [JLADMIN] AdminImmunity      %d",AdminImmunity);
	printf(" [JLADMIN] ShowPmstoAdmins    %d",ShowPmstoAdmins);
	printf(" [JLADMIN] ReadCommands       %d",ReadCommands);
	printf(" [JLADMIN] AntiCheatBans      %d",AntiCheatBans);
	printf(" [JLADMIN] Allow changename   %d",AllowChangeNick);
	printf(" [JLADMIN] ForbiddenNamesKick %d",ForbiddenNamesKick);
	printf(" [JLADMIN] PartNamesKick      %d",KickPartNicks);
	return 1;
}


stock CreateSpecTD(playerid)
{
    SpecPTD = CreatePlayerTextDraw(playerid, 457.000000, 169.000000, "JLadmin");
	PlayerTextDrawBackgroundColor(playerid, SpecPTD, 255);
	PlayerTextDrawFont(playerid,SpecPTD, 1);
	PlayerTextDrawLetterSize(playerid, SpecPTD, 0.309998, 1.499999);
	PlayerTextDrawColor(playerid, SpecPTD, -1);
	PlayerTextDrawSetOutline(playerid,SpecPTD, 0);
	PlayerTextDrawSetProportional(playerid,SpecPTD, 1);
	PlayerTextDrawSetShadow(playerid, SpecPTD, 1);
	PlayerTextDrawUseBox(playerid, SpecPTD, 1);
	PlayerTextDrawBoxColor(playerid, SpecPTD, 60);
	PlayerTextDrawTextSize(playerid, SpecPTD, 631.000000, 0.000000);
	return 1;
}

stock CreateLoginTextDraw()
{
	TEXT_PASSWORD = TextDrawCreate(191.000000, 281.000000, "enter~N~password");
	TextDrawBackgroundColor(TEXT_PASSWORD, 255);
	TextDrawFont(TEXT_PASSWORD, 3);
	TextDrawLetterSize(TEXT_PASSWORD, 0.709998, 2.299998);
	TextDrawColor(TEXT_PASSWORD, -286331649);
	TextDrawSetOutline(TEXT_PASSWORD, 0);
	TextDrawSetProportional(TEXT_PASSWORD, 1);
	TextDrawSetShadow(TEXT_PASSWORD, 1);
	TextDrawUseBox(TEXT_PASSWORD, 1);
	TextDrawBoxColor(TEXT_PASSWORD, 70);
	TextDrawTextSize(TEXT_PASSWORD, 321.000000, 50.000000);
	TextDrawSetSelectable(TEXT_PASSWORD, 1);

	TEXT_REGISTER = TextDrawCreate(328.000000, 281.000000, "register a~N~new account");
	TextDrawBackgroundColor(TEXT_REGISTER, 255);
	TextDrawFont(TEXT_REGISTER, 3);
	TextDrawLetterSize(TEXT_REGISTER, 0.629998, 2.299999);
	TextDrawColor(TEXT_REGISTER, -286331156);
	TextDrawSetOutline(TEXT_REGISTER, 0);
	TextDrawSetProportional(TEXT_REGISTER, 1);
	TextDrawSetShadow(TEXT_REGISTER, 1);
	TextDrawUseBox(TEXT_REGISTER, 1);
	TextDrawBoxColor(TEXT_REGISTER, 70);
	TextDrawTextSize(TEXT_REGISTER, 469.000000, 50.000000);
	TextDrawSetSelectable(TEXT_REGISTER, 1);

	TEXT_REGISTERED = TextDrawCreate(220.000000, 222.000000, "~R~nick name is ~Y~~H~registered!");
	TextDrawBackgroundColor(TEXT_REGISTERED, 255);
	TextDrawFont(TEXT_REGISTERED, 3);
	TextDrawLetterSize(TEXT_REGISTERED, 0.579999, 2.700002);
	TextDrawColor(TEXT_REGISTERED, -1);
	TextDrawSetOutline(TEXT_REGISTERED, 0);
	TextDrawSetProportional(TEXT_REGISTERED, 1);
	TextDrawSetShadow(TEXT_REGISTERED, 1);
}

stock ShowLevelCommands(playerid,cmdlevel)
{
    strdel(VLstring,0,850);
	if(cmdlevel == 1)
	{
        strcat(VLstring,""LEVEL_1_COLOR"________________________Administrator Level 1 ("ADMIN_LEVEL_1")_________________________\n\n", sizeof(VLstring));
        strcat(VLstring,"{FFFF80}/Setskin, /myskin, /useskin, /stopuseskin, /goto, /get, /warn, /kick,/reports, /Spec, /Specoff\n", sizeof(VLstring));
        strcat(VLstring,"/Slap, /Explode, /Burn, /Clearchat, /Clearplayerchat(cpc), /flip, /Fix, /repair, /Nitro, /apm \n", sizeof(VLstring));
        strcat(VLstring,"/Showclock, /Hideclock, /Cal(calculator), /Forbidnames,  /Tunedcars, /lock /unlock, /Car\n", sizeof(VLstring));
        strcat(VLstring,"/Bike, /heli, /Boat, /Plane, /Vehicle, /Asay, /Mute, /Unmute, /Muted, /Jail, /Unjail, /Jailed\n", sizeof(VLstring));
        strcat(VLstring,"/Heal /Vspec, /Print, /Setcarcolour, /Track, /Vhealth, /Fixcarint, /Spawn, /Disarm, /Frozen\n", sizeof(VLstring));
        strcat(VLstring,"/reconnect, /teles(teleports), /Forbidweaps, /Weaponids /Hide, /warned\n", sizeof(VLstring));
        strcat(VLstring,"Use @ for admin chat\n\n", sizeof(VLstring));
	}
    if(cmdlevel == 2)
	{
        strcat(VLstring,""LEVEL_2_COLOR"________________________Administrator Level 2 ("ADMIN_LEVEL_2")______________________\n\n", sizeof(VLstring));
        strcat(VLstring,"{FFFF80}/Setscore, /Setcash, /Givemoney, /Spawncar, /Destroycars, /Givecar, /Settime, /Setweather\n", sizeof(VLstring));
        strcat(VLstring,"/Ban, /Tempban, /Countdown, /Clearallchat, /aka, /akill, /Fixcarint, /Setworld, /Setinteriror\n", sizeof(VLstring));
        strcat(VLstring,"/Vget, /Jetpack, /Givejetpack, /Givecar,  /Vgoto, /God, /Godcar, /Setarmour, /sethealth\n", sizeof(VLstring));
        strcat(VLstring,"/Giveweapon, /Getip, /Write, /respawncars, /Setcolor, /Setmarker, /removebounds\n", sizeof(VLstring));
        strcat(VLstring,"/Setfstyle /Setname, /Setwanted, /Freeze, /Unfreeze, /Hideme, /Unhideme, /Screenmessage\n\n", sizeof(VLstring));
	}
	if(cmdlevel == 3)
	{
        strcat(VLstring,""LEVEL_3_COLOR"________________________Administrator Level 3 ("ADMIN_LEVEL_3")______________________\n\n", sizeof(VLstring));
        strcat(VLstring,"{FFFF80}/Givescore, /Giveallcash, /resetscore, /Giveveh, /Setalltime, /Setallweather, /Setallwanted\n", sizeof(VLstring));
        strcat(VLstring,"/Sget, /Eject, /Force, /Fakechat, /Fakekill, /Move, /Setkills, /Setdaeths, /Crash, /Hidename\n", sizeof(VLstring));
        strcat(VLstring,"/Unhidename, /Giveallweapon, /Announce, /resetcash,  /Warp, /Settempvip, /setskill, /setdrunk\n\n", sizeof(VLstring));
        strcat(VLstring,"/Hidecar, /Unhidecar, /Setallhealth, /Setallarmour\n\n", sizeof(VLstring));
	}
	if(cmdlevel == 4)
	{
        strcat(VLstring,""LEVEL_4_COLOR"________________________Administrator Level 4 ("ADMIN_LEVEL_4")______________________\n\n", sizeof(VLstring));
        strcat(VLstring,"{FFFF80}/Settemplevel, /Setvip,/Giveallscore, /rban, /Pmute, /Delaka, /Setgravity, /Explodeall,/Slapall\n", sizeof(VLstring));
        strcat(VLstring,"/Burnall, /Fakecmd, /Spawnall, /Healall, /Armourall, /Freezeall, /Unfreezeall, /Setallskin\n", sizeof(VLstring));
        strcat(VLstring,"/Unsetallskin, /Ejectall, /Setallworld, /Setallinterior, /Muteall, /Unmuteall, /Spam, /Setpass\n", sizeof(VLstring));
        strcat(VLstring,"/Setallcash, /Setallcashback, /Setname2, /Unban, /Banname, /banip, /Unbanip, /Setping\n", sizeof(VLstring));
        strcat(VLstring,"/Mainchat, /Disarmalll, /Gametext, /addforbidname, /Getall, /serverinfo, /Pickup, /delpickup\n", sizeof(VLstring));
        strcat(VLstring,"/object, /Editobject, /stopedit, /gotoobject, /delobject, /ctele (createtele)\n\n", sizeof(VLstring));
	}
	if(cmdlevel == 5)
	{
        strcat(VLstring,""LEVEL_5_COLOR"________________________Administrator Level 5 ("ADMIN_LEVEL_5")______________________\n\n", sizeof(VLstring));
        strcat(VLstring,"{FFFF80}/Setlevel, /Settings, /Account, /Console, /Clearlogs, /Killall, /addforbidpartname, /addforbidweapon\n", sizeof(VLstring));
        strcat(VLstring,"/addbadword, /Hostname, /mapname, /Gmtext, /varlist, /reloadteles, /clearteles, /delaccount, /newaccount\n\n", sizeof(VLstring));
        strcat(VLstring,"NOTE: As an level 5 Administrator you have access to commands\n\n", sizeof(VLstring));
	}
	ShowPlayerDialog(playerid,JDIALOGS+111,DIALOG_STYLE_MSGBOX,"                {FF0000}J.L. Admin System V1.0 Copyright(c), JewelL",VLstring,"Ok","");
	return 1;
}

StoreWeaponsData(playerid)
{
    new slot, weap, ammo;
    for (slot = 0; slot < 13; slot++)
	{
        GetPlayerWeaponData(playerid, slot, weap, ammo);
        if(weap != 0)
        {
            switch(slot)
			{
               case 0:
               {
                   SetPVarInt(playerid, "slot0weap",weap);
                   SetPVarInt(playerid, "slot0ammo",ammo);
               }
               case 1:
               {
                   SetPVarInt(playerid, "slot1weap",weap);
                   SetPVarInt(playerid, "slot1ammo",ammo);
               }
               case 2:
               {
                   SetPVarInt(playerid, "slot2weap",weap);
                   SetPVarInt(playerid, "slot2ammo",ammo);
               }
               case 3:
               {
                   SetPVarInt(playerid, "slot3weap",weap);
                   SetPVarInt(playerid, "slot3ammo",ammo);
               }
               case 4:
               {
                   SetPVarInt(playerid, "slot4weap",weap);
                   SetPVarInt(playerid, "slot4ammo",ammo);
               }
               case 5:
               {
                   SetPVarInt(playerid, "slot5weap",weap);
                   SetPVarInt(playerid, "slot5ammo",ammo);
               }
               case 6:
               {
                   SetPVarInt(playerid, "slot6weap",weap);
                   SetPVarInt(playerid, "slot6ammo",ammo);
               }
               case 7:
               {
                   SetPVarInt(playerid, "slot7weap",weap);
                   SetPVarInt(playerid, "slot7ammo",ammo);
               }
               case 8:
               {
                   SetPVarInt(playerid, "slot8weap",weap);
                   SetPVarInt(playerid, "slot8ammo",ammo);
               }
               case 9:
               {
                   SetPVarInt(playerid, "slot9weap",weap);
                   SetPVarInt(playerid, "slot9ammo",ammo);
               }
               case 10:
               {
                   SetPVarInt(playerid, "slot10weap",weap);
                   SetPVarInt(playerid, "slot10ammo",ammo);
               }
               case 11:
               {
                   SetPVarInt(playerid, "slot11weap",weap);
                   SetPVarInt(playerid, "slot11ammo",ammo);
               }
               case 12:
               {
                   SetPVarInt(playerid, "slot12weap",weap);
                   SetPVarInt(playerid, "slot12ammo",ammo);
               }
			}
        }
    }
}

SetPlayerWeapons(playerid)
{
    ResetPlayerWeapons(playerid);
    if(GetPVarInt(playerid, "slot0weap") != 0)
    {
		GivePlayerWeapon(playerid,GetPVarInt(playerid, "slot0weap"),GetPVarInt(playerid, "slot0ammo"));
    }
    if(GetPVarInt(playerid, "slot1weap") != 0)
    {
		GivePlayerWeapon(playerid,GetPVarInt(playerid, "slot1weap"),GetPVarInt(playerid, "slot1ammo"));
    }
    if(GetPVarInt(playerid, "slot2weap") != 0)
    {
		GivePlayerWeapon(playerid,GetPVarInt(playerid, "slot2weap"),GetPVarInt(playerid, "slot2ammo"));
    }
    if(GetPVarInt(playerid, "slot3weap") != 0)
    {
		GivePlayerWeapon(playerid,GetPVarInt(playerid, "slot3weap"),GetPVarInt(playerid, "slot3ammo"));
    }
    if(GetPVarInt(playerid, "slot4weap") != 0)
    {
		GivePlayerWeapon(playerid,GetPVarInt(playerid, "slot4weap"),GetPVarInt(playerid, "slot4ammo"));
    }
    if(GetPVarInt(playerid, "slot5weap") != 0)
    {
		GivePlayerWeapon(playerid,GetPVarInt(playerid, "slot5weap"),GetPVarInt(playerid, "slot5ammo"));
    }
    if(GetPVarInt(playerid, "slot6weap") != 0)
    {
		GivePlayerWeapon(playerid,GetPVarInt(playerid, "slot6weap"),GetPVarInt(playerid, "slot6ammo"));
    }
    if(GetPVarInt(playerid, "slot7weap") != 0)
    {
		GivePlayerWeapon(playerid,GetPVarInt(playerid, "slot7weap"),GetPVarInt(playerid, "slot7ammo"));
    }
    if(GetPVarInt(playerid, "slot8weap") != 0)
    {
		GivePlayerWeapon(playerid,GetPVarInt(playerid, "slot8weap"),GetPVarInt(playerid, "slot8ammo"));
    }
    if(GetPVarInt(playerid, "slot9weap") != 0)
    {
		GivePlayerWeapon(playerid,GetPVarInt(playerid, "slot9weap"),GetPVarInt(playerid, "slot9ammo"));
    }
    if(GetPVarInt(playerid, "slot10weap") != 0)
    {
		GivePlayerWeapon(playerid,GetPVarInt(playerid, "slot10weap"),GetPVarInt(playerid, "slot10ammo"));
    }
    if(GetPVarInt(playerid, "slot11weap") != 0)
    {
		GivePlayerWeapon(playerid,GetPVarInt(playerid, "slot11weap"),GetPVarInt(playerid, "slot11ammo"));
    }
    if(GetPVarInt(playerid, "slot12weap") != 0)
    {
		GivePlayerWeapon(playerid,GetPVarInt(playerid, "slot12weap"),GetPVarInt(playerid, "slot12ammo"));
    }
}
/*------------------------------------------------------------------------------*/
/*--------Ping Kicker,Weapon checker,pause detect and update player data--------*/
/*------------------------------------------------------------------------------*/
public PlayerCheker()
{
	foreach(Player, i)
	{
		if(MaxPing > 49)
		{
           if(GetPlayerPing(i) > MaxPing && pInfo[i][Spawned] == 1)
		   {
               if(AdminImmunity == 1 && pInfo[i][pLevel] >= 1) continue;
		       pInfo[i][PingExceeds]++;
		       if(pInfo[i][PingExceeds] > MaxPingExceeds)
			   {
		          format(Jstring,sizeof(Jstring),"[Ping kicker:] Kicking Player %s(ID:%d) Reason: %d Ping | Server Max Allowed: %d", GetName(i),i, GetPlayerPing(i), MaxPing);
				  SendClientMessageToAll(yellow,Jstring);
				  pInfo[i][PingExceeds]     =     0;
				  SetTimerEx("KickPlayer",200,false,"d", i);
			   }
		   }
		}
        #if PauseDetectSystem == true
	    if(DetectPausers == 1)
		{
           if(GetTickCount() - pTick[i] > 1500 )
		   {
                if(IsPaused[i] == 0 && pInfo[i][Spawned] == 1)
				{
			       IsPaused[i] = 1;
			    }
           }
           else
		   {
               if(IsWorldChanged[i] == 1) SetPlayerVirtualWorld(i,GetPVarInt(i, "world"));
               IsPaused[i] = 0;
               IsWorldChanged[i] = 0;
           }
           if(GetTickCount() - pTick[i] > 5000 && pInfo[i][Spawned] == 1)
		   {
               if(IsWorldChanged[i] == 0)
			   {
	               IsWorldChanged[i] = 1;
	               SetPVarInt(i, "world", GetPlayerVirtualWorld(i));
	               SetPlayerVirtualWorld(i,107);
               }
           }
        }
        #endif
		if(AntiWeaponHack == 1)
		{
           if(IllegalWeaps(GetPlayerWeapon(i)) == 1)
		   {
               if(AdminImmunity == 1 && pInfo[i][pLevel] >= 1) continue;
               new weapon,slot , ammo, weaponname[32],day,month,year,hour,minuite;
               slot = GetWeaponSlot(GetPlayerWeapon(i));
               GetPlayerWeaponData(i, slot, weapon, ammo);
               GetWeaponName(weapon,weaponname,sizeof(weaponname));
               pInfo[i][AntiCheatWarns]++;
               if(OnlineAdminsCount() > 0 && pInfo[i][AntiCheatWarns] < 2)
			   {
                    format(Jstring, sizeof(Jstring),"Suspected player '%s'(ID: %d) using weapon cheats '%s' with '%d' of ammo. /spec %d",GetName(i),i, weaponname , ammo, i);
					SendToAdmins(orange,Jstring);
                    format(Jstring, sizeof(Jstring),"[WEAPON CHEAT] '%s' has used weapon cheats '%s' with '%d' of ammo",GetName(i), weaponname , ammo);
                    WriteToLog(Jstring,"AntiCheatLog");
               }
               else if(pInfo[i][AntiCheatWarns] > 10)
			   {
                    pInfo[i][AntiCheatWarns] = 0;
                    if(AntiCheatBans == 1)
                    {
	                    getdate(year, month, day);
						gettime(hour,minuite);
				        format(Jstring,sizeof(Jstring),"%s has Been banned by JLadmin | Reason: 'Weapon cheats' <Date: %d/%d/%d> <Time: %d:%d>",GetName(i),day,month,year,hour,minuite);
			            SendClientMessageToAll(red,Jstring);
			            format(Jstring,sizeof(Jstring),"JLadmin has banned %s | Reason: Weapon cheats",GetName(i));
			            WriteToLog(Jstring,"Bans");
			            format(Jstring,sizeof(Jstring),"{FF0000}You have been banned by the server for: \"Weapon Cheats(%s)\"\n\nVisit "WEBSITE" for more informations",weaponname);
			            ShowPlayerDialog(i,JDIALOGS+200,DIALOG_STYLE_MSGBOX,"           {FF0000}You are banned",Jstring,"OK","");
			            SetTimerEx("BanPlayer",200,false,"dd", i,2);
		            }
	           }
		   }
        }
        if(pInfo[i][VWorld] != GetPlayerVirtualWorld(i))
		{
            CallLocalFunction("OnPlayerVirtualWorldChange", "dii", i, GetPlayerVirtualWorld(i), pInfo[i][VWorld]);
            pInfo[i][VWorld] = GetPlayerVirtualWorld(i);
        }
    }
}

public OnPlayerUpdate(playerid)
{
    #if PauseDetectSystem == true
    pTick[playerid] = GetTickCount();
    #endif
    #if MoveSystem == true
    if(pInfo[playerid][Move] == 1)
    GetPlayerHoldingKey(playerid);
    #endif
    return 1;
}

#if MoveSystem == true
new Float:MX, Float:MY, Float:MZ, Float:MA, MKeys, Mupdown, Mleftright;
stock GetPlayerHoldingKey(playerid)
{
    if(pInfo[playerid][Move] == 1)
	{
	   GetPlayerKeys(playerid, MKeys, Mupdown, Mleftright);
       GetPlayerPos(playerid,MX,MY,MZ);
       GetPlayerFacingAngle(playerid, MA);
       if(MKeys == KEY_SPRINT)
       {
		  SetPlayerPos(playerid,MX,MY,MZ-3);
       }
       if(MKeys == KEY_JUMP)
       {
		  SetPlayerPos(playerid,MX,MY,MZ+3);
       }
       if(Mupdown == KEY_UP)
       {
          GetPlayerPos(playerid,MX,MY,MZ);
          MX += (5 * floatsin(-MA, degrees));
	      MY += (5 * floatcos(-MA, degrees));
		  SetPlayerPos(playerid,MX,MY,MZ);
       }
       if(Mupdown == KEY_DOWN)
       {
          GetPlayerPos(playerid,MX,MY,MZ);
          MX -= (5 * floatsin(-MA, degrees));
	      MY -= (5 * floatcos(-MA, degrees));
		  SetPlayerPos(playerid,MX,MY,MZ);
       }
       if(Mleftright == KEY_RIGHT)
       {
          SetPlayerFacingAngle(playerid, MA - 5);
          SetCameraBehindPlayer(playerid);
       }
       if(Mleftright == KEY_LEFT)
       {
          SetPlayerFacingAngle(playerid, MA + 5);
          SetCameraBehindPlayer(playerid);
       }
    }
    return 1;
}
#endif

stock GetWeaponSlot(weapon)
{
    new slot;
    switch (weapon)
    {
        case 0: slot = 0;
        case 1: slot = 0;
        case 2: slot = 1;
        case 3: slot = 1;
        case 4: slot = 1;
        case 5: slot = 1;
        case 6: slot = 1;
        case 7: slot = 1;
        case 8: slot = 1;
        case 9: slot = 1;
        case 22: slot = 2;
        case 23: slot = 2;
        case 24: slot = 2;
        case 25: slot = 3;
        case 26: slot = 3;
        case 27: slot = 3;
        case 28: slot = 4;
        case 29: slot = 4;
        case 32: slot = 4;
        case 30: slot = 5;
        case 31: slot = 5;
        case 33: slot = 6;
        case 34: slot = 6;
        case 35: slot = 7;
        case 36: slot = 7;
        case 37: slot = 7;
        case 38: slot = 7;
        case 16: slot = 8;
        case 17: slot = 8;
        case 18: slot = 8;
        case 39: slot = 8;
        case 41: slot = 9;
        case 42: slot = 9;
        case 43: slot = 9;
        case 10: slot = 10;
        case 11: slot = 10;
        case 12: slot = 10;
        case 13: slot = 10;
        case 14: slot = 10;
        case 15: slot = 10;
        case 44: slot = 11;
        case 45: slot = 11;
        case 46: slot = 11;
        case 40: slot = 12;
    }
    return slot;
}

stock AccountEditor(playerid)
{
   new string[400],NickName[24],temp[150];
   new Jfile[100];
   GetPVarString(playerid, "AccountName", NickName, 24);
   format(Jfile, sizeof(Jfile), ACCOUNTS_PATH, NickName);
   if(!fexist(Jfile)) return SendClientMessage( playerid, red, "This player doesnt have an account!" );
   INI_ParseFile(Jfile,"AccountsEditor");
   format(temp,sizeof(temp),"Name: %s\nRegistered Date: %s\nRegistered Ip: %s\nLast Logged IP: %s\nAdmin Level: %d\nV.I.P level: %d",NickName,RegisteredDate,RegisteredIP,LastLoggedIP,AdminLevel,DonatorLevel);
   strcat(string, temp, sizeof(string));
   format(temp,sizeof(temp),"\nBanned: %d\nMuted: %d\nScore: %d\nCash: %d\nKills: %d\nDeaths: %d\nRatio: %0.2f\nFavorite Skin: %d\nAuto login: %d\nTotal played seconds: %d",AccBanned,AccMuted,AccScore,AccCash,AccKills,AccDeaths,Float:AccKills/Float:AccDeaths,AccSkin,AccAutologin,AccTotalSecs);
   strcat(string, temp, sizeof(string));
   format(temp,sizeof(temp),"\nLast seen: %s\nTotal spent Time: %s\nChange Password",LastSeen,AccPlayedTime);
   strcat(string, temp, sizeof(string));
   format(temp, sizeof(temp), "ACCOUNT EDITOR: %s", NickName);
   ShowPlayerDialog(playerid,JDIALOGS+7,DIALOG_STYLE_LIST,temp,string,"Select","Cancel");
   CommandToAdmins(playerid,"account");
   return 1;
}

stock ServSettings(playerid)
{
   new temp[140],Jfile[100];
   format(Jfile,sizeof(Jfile),"JLadmin/Settings/settings.cfg");
   if(!fexist(Jfile)) return SendClientMessage( playerid, red, "No file/Path found!" );
   strdel(VLstring,0,850);
   format(temp,sizeof(temp),"Server AutoLogin: %d\nDetect pausers: %d\nMust register: %d\nServer Max Ping: %d\nAnti spam: %d\nAnti weapon hack: %d\n",AutoLogin,DetectPausers,MustRegister,MaxPing,AntiSpam,AntiWeaponHack);
   strcat(VLstring, temp, sizeof(VLstring));
   format(temp,sizeof(temp),"Anti bad words: %d\nForbidden names kick: %d\nPart names Kick: %d\nAnti Advertisements: %d\nAnti ban evade: %d\n",AntiForbiddenWords,ForbiddenNamesKick,KickPartNicks,AntiAdv,AntiBanEvade);
   strcat(VLstring, temp, sizeof(VLstring));
   format(temp,sizeof(temp),"Max Admin Levels: %d\nAdmin Immunity: %d\nAdmin Read PMs: %d\nAdmin Read cmds: %d\nPM dialog: %d\nAnti Cheat Bans: %d\nAllow Change Nick: %d\n",MaxAdminLevel,AdminImmunity,ShowPmstoAdmins,ReadCommands,PmDialog,AntiCheatBans,AllowChangeNick);
   strcat(VLstring, temp, sizeof(VLstring));
   format(temp,sizeof(temp),"Forbidden Weapons\nForbidden Names\nForbidden Part Nicks\nBad words\nReload Settings");
   strcat(VLstring, temp, sizeof(VLstring));
   ShowPlayerDialog(playerid,JDIALOGS+52,DIALOG_STYLE_LIST,"Server Settings",VLstring,"Select","Cancel");
   strdel(VLstring,0,850);
   return 1;
}

stock JLconsole(playerid)
{
   return ShowPlayerDialog(playerid,JDIALOGS+85,DIALOG_STYLE_LIST,"RCON CONSOLE:","Load filterscript\nReload filterscript\nUnload filterscript\nChange gamemode\nChange Gamemode Text\nChange host name\nChange Map Name\nChanged Web URL\nBan IP\nUnban IP\nBan player\nkick player\nReload Bans\nReload server_log\nChange Gravity\nChange Weather\nChange RCON Password\nExecute .cfg File\nEcho Message\nVarible List(varlist)\nRestart Server\nClose Server","Select","Cancel");
}

ReturnVehicleModelID(Name[])
{
    for(new i; i != 211; i++) if(strfind(VehicleNames[i], Name, true) != -1) return i + 400;
    return INVALID_VEHICLE_ID;
}
/*----------------------------------------------------------------------------*/
/*---------------------------Thanks to Kyosaur--------------------------------*/
/*----------------------------------------------------------------------------*/
stock ConvertTime(&cts, &ctm=-1,&cth=-1,&ctd=-1,&ctw=-1,&ctmo=-1,&cty=-1)
{
    #define PLUR(%0,%1,%2) (%0),((%0) == 1)?((#%1)):((#%2))

    #define CTM_cty 31536000
    #define CTM_ctmo 2628000
    #define CTM_ctw 604800
    #define CTM_ctd 86400
    #define CTM_cth 3600
    #define CTM_ctm 60

    #define CT(%0) %0 = cts / CTM_%0; cts %= CTM_%0

    new strii[128];

    if(cty != -1 && (cts/CTM_cty))
    {
        CT(cty); CT(ctmo); CT(ctw); CT(ctd); CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s, %d %s, %d %s, %d %s, %d %s, %d %s, and %d %s",PLUR(cty,"year","years"),PLUR(ctmo,"month","months"),PLUR(ctw,"week","weeks"),PLUR(ctd,"day","days"),PLUR(cth,"hour","hours"),PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    if(ctmo != -1 && (cts/CTM_ctmo))
    {
        cty = 0; CT(ctmo); CT(ctw); CT(ctd); CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s, %d %s, %d %s, %d %s, %d %s, and %d %s",PLUR(ctmo,"month","months"),PLUR(ctw,"week","weeks"),PLUR(ctd,"day","days"),PLUR(cth,"hour","hours"),PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    if(ctw != -1 && (cts/CTM_ctw))
    {
        cty = 0; ctmo = 0; CT(ctw); CT(ctd); CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s, %d %s, %d %s, %d %s, and %d %s",PLUR(ctw,"week","weeks"),PLUR(ctd,"day","days"),PLUR(cth,"hour","hours"),PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    if(ctd != -1 && (cts/CTM_ctd))
    {
        cty = 0; ctmo = 0; ctw = 0; CT(ctd); CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s, %d %s, %d %s, and %d %s",PLUR(ctd,"day","days"),PLUR(cth,"hour","hours"),PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    if(cth != -1 && (cts/CTM_cth))
    {
        cty = 0; ctmo = 0; ctw = 0; ctd = 0; CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s, %d %s, and %d %s",PLUR(cth,"hour","hours"),PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    if(ctm != -1 && (cts/CTM_ctm))
    {
        cty = 0; ctmo = 0; ctw = 0; ctd = 0; cth = 0; CT(ctm);
        format(strii, sizeof(strii), "%d %s, and %d %s",PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    cty = 0; ctmo = 0; ctw = 0; ctd = 0; cth = 0; ctm = 0;
    format(strii, sizeof(strii), "%d %s", PLUR(cts,"second","seconds"));
    return strii;
}

/*----------------------------------------------------------------------------*/
/*--------------Check player level in other filterscripts---------------------*/
/*----------------------------------------------------------------------------*/
public PlayerLevel(playerid)
{
     if(pInfo[playerid][pLevel] >= 1)
     return pInfo[playerid][pLevel];
     else
     return 0;
}

/*----------------------------------------------------------------------------*/
/*--------------Check V.I.P level in other filterscripts----------------------*/
/*----------------------------------------------------------------------------*/
public VipLevel(playerid)
{
     if(pInfo[playerid][Donator] >= 1)
     return pInfo[playerid][Donator];
     else
     return 0;
}
