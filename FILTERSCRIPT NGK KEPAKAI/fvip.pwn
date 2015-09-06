//fVIP v1.0
//CREATED BY fiki574_CRO
//DO NOT REMOVE THIS LINES

#include <a_samp> //default include
#include <ZCMD> //for commands
#include <Dini> //for file saving
#include <sscanf2> //for some stuff :P
#include <fvip> //some functions

//defines
#define WearVIPtag      true //if true, will set  "VIP" over the player head                                            
#define SaveMoneyScore  true //if true, will save money and score to file                                               
#define SaveKillsDeaths true //if true, will save kills and deaths to file                                              
#define SaveWeapons     true //if true, will save VIPs weapons                                                          
#define ConnectMessages true //if true, will notify player that VIP joined the server           						
#define DCMessages 		true //if true, will notify player that VIP left the server             						
#define Level1Tag       "Trial" //will display this over the players head and in /vips
#define Level2Tag       "Silver" //same as above
#define Level3Tag       "Gold" //same as above
#define Level4Tag       "Premium" //same as above
#define VIPchat         true //if true, will enable VIP chatting  														
#define VIPinChat       true //if true, will put (VIP) after the players name                                           
#define VIPchatSymbol   '!' //define symbol which will be used for VIP chat -> NOTE: '' must stay, dont remove them 	
#define VIPconnectLogs  true //if true, will save connects/disconnects to file                                          
#define UseVIPcolor     true //if true, will enable using of "VIPcolor"                                                 
#if UseVIPcolor == true
#define VIPcolor        0xFF0000AA //VIP-only color
#endif

//colors
#define COLOR_KHAKI 0x999900AA
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_RED 0xFF0000AA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_YELLOW 0xFFFF00AA

//directorys
#if VIPconnectLogs == true
#define VIPconnectLog    "fVIP/Files/VIPconnects.txt"
#define VIPdisconnectLog "fVIP/Files/VIPdisconnects.txt"
#endif

//dialogs (DO NOT CHANGE)
#define ConfigDialog 4444
#define MaxLevelDialog 4445
#define MoneyForJoin 4446
#define ScoreForJoin 4447
#define TotalAccs 4448

//new stuff
new TotalAccounts;
new MoneyAdd;
new ScoreAdd;
new MaxLevel;
new File[100];

enum PlayerInfo
{
	Level,
	AccNum,
	#if SaveKillsDeaths == true
	Kills,
	Deaths,
	#endif
	#if SaveMoneyScore == true
	Score,
	Money,
	#endif
	#if SaveWeapons == true
	Weapon1,
	Weapon1Ammo,
	Weapon2,
	Weapon2Ammo,
	Weapon3,
	Weapon3Ammo,
	Weapon4,
	Weapon4Ammo,
	Weapon5,
	Weapon5Ammo,
	Weapon6,
	Weapon6Ammo
	#endif
}
new PlayerData[MAX_PLAYERS][PlayerInfo];

public OnGameModeInit()
{
    new TAcc[50];
    format(TAcc,sizeof(TAcc),"fVIP/Files/TotalAccounts.txt");
    if(dini_Exists(TAcc))
    {
		TotalAccounts = dini_Int(TAcc,"Accounts");
	}
	
 	new CMS[50];
    format(CMS,sizeof(CMS),"fVIP/Files/Configuration.txt");
    if(dini_Exists(CMS))
    {
        MoneyAdd = dini_Int(CMS,"MoneyForJoin");
        ScoreAdd = dini_Int(CMS,"ScoreForJoin");
        MaxLevel = dini_Int(CMS,"MaxVipLevel");
	}
	
    printf("\n ___________________________________________________");
	printf("");
    printf("                     fVIP v1.0                        ");
   	printf("             --------------------------");
	printf("             Fiki´s advanced VIP system              ");
	printf("				      Loaded!");
	printf("             --------------------------");
	printf("               Total VIP accounts: %d",TotalAccounts);
	printf("                Score for join: %d",ScoreAdd);
	printf("                Money for join: %d",MoneyAdd);
	printf("                Max VIP level: %d",MaxLevel);
	printf(" ___________________________________________________\n");
	return 1;
}

public OnGameModeExit()
{
    printf("\n ___________________________________________________");
	printf("");
    printf("                     fVIP v1.0                        ");
   	printf("             --------------------------");
	printf("             Fiki´s advanced VIP system              ");
    printf("                     Unloaded!");
	printf("             --------------------------");
    printf("");
	printf(" ___________________________________________________\n");
	printf("-> Unloaded!");
	return 1;
}

public OnPlayerConnect(playerid)
{
    new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,sizeof(name));
	format(File,sizeof(File),"fVIP/Accounts/%s.txt",name);
	if(dini_Exists(File))
	{
	    PlayerData[playerid][Level] = dini_Int(File,"Level");
	    PlayerData[playerid][AccNum] = dini_Int(File,"AccountNumber");
	    #if SaveKillsDeaths == true
	    PlayerData[playerid][Kills] = dini_Int(File,"Kills");
		PlayerData[playerid][Deaths] = dini_Int(File,"Deaths");
		#endif
		#if SaveMoneyScore == true
		ResetPlayerMoney(playerid);
		SetPlayerScore(playerid,0);
		PlayerData[playerid][Money] = dini_Int(File,"Money");
		PlayerData[playerid][Score] = dini_Int(File,"Score");
		#endif
	}
	else
	{
	    dini_Create(File);
	    dini_IntSet(File,"Level",0);
	    dini_Set(File,"AccountNumber","N/A");
	    #if SaveKillsDeaths == true
	    dini_IntSet(File,"Kills",0);
	    dini_IntSet(File,"Deaths",0);
	    #endif
	    #if SaveMoneyScore == true
	    dini_IntSet(File,"Money",0);
	    dini_IntSet(File,"Score",0);
	    #endif
	}
	
	if(PlayerData[playerid][Level] >= 1)
	{
		GivePlayerMoney(playerid,MoneyAdd);
		SetPlayerScore(playerid,GetPlayerScore(playerid)+ScoreAdd);
		#if UseVIPcolor == true
	 	SetPlayerColor(playerid,VIPcolor);
	 	#endif
	}
	
    if(PlayerData[playerid][Level] >= 1)
    {
    	#if ConnectMessages == true
		new ConnectMessage[256];
		format(ConnectMessage,sizeof(ConnectMessage),"* VIP %s (ID:%d) has joined the server *", name, playerid);
		SendClientMessageToAll(COLOR_GREY,ConnectMessage);
		new File:Log = fopen(VIPconnectLog, io_append);
	 	new	logData[128];
		new fTime[6];
		getdate(fTime[0], fTime[1], fTime[2]);
		gettime(fTime[3], fTime[4], fTime[5]);
		format(logData, sizeof logData, "[%02d/%02d/%04d || %02d:%02d:%02d]VIP %s(%d) connected!\r\n", fTime[2], fTime[1], fTime[0], fTime[3], fTime[4], fTime[5], name, playerid);
		fwrite(Log, logData);
		fclose(Log);
		#endif
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if(PlayerData[playerid][Level] >= 1)
    {
        #if DCMessages == true
	    new LeaveMessage[256];
	    new name[MAX_PLAYER_NAME];
		GetPlayerName(playerid,name,sizeof(name));
	    switch(reason)
	    {
	        case 0: format(LeaveMessage,sizeof(LeaveMessage), "* VIP %s (ID:%d) left the server! (Reason: Timeout) *", name,playerid);
	        case 1: format(LeaveMessage,sizeof(LeaveMessage), "* VIP %s (ID:%d) left the server! (Reason: Leaving) *", name,playerid);
	        case 2: format(LeaveMessage,sizeof(LeaveMessage), "* VIP %s (ID:%d) left the server! (Reason: Kicked/Banned) *", name,playerid);
	    }
	    SendClientMessageToAll(COLOR_GREY, LeaveMessage);
	    new File:Log = fopen(VIPdisconnectLog, io_append);
	 	new	logData[128];
		new fTime[6];
		getdate(fTime[0], fTime[1], fTime[2]);
		gettime(fTime[3], fTime[4], fTime[5]);
		format(logData, sizeof logData, "[%02d/%02d/%04d || %02d:%02d:%02d]VIP %s(%d) disconnected!\r\n", fTime[2], fTime[1], fTime[0], fTime[3], fTime[4], fTime[5], name, playerid);
		fwrite(Log, logData);
		fclose(Log);
		#endif
    }
	return 1;
}

public OnPlayerSpawn(playerid)
{
	#if WearVIPtag == true
	if(PlayerData[playerid][Level] >= 1)
	{
	    new Text3D:VIPtag = Create3DTextLabel("Server VIP", COLOR_RED, 30.0, 40.0, 50.0, 40.0, 0);
		Attach3DTextLabelToPlayer(VIPtag, playerid, 0.0, 0.0, 0.7);
	}
	#endif
	
	#if SaveWeapons == true
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,sizeof(name));
	format(File,sizeof(File),"/fAdmin/Players/%s.txt",name);
	if(PlayerData[playerid][Level] >= 1)
	{
		if(dini_Exists(File))
		{
			GivePlayerWeapon(playerid,dini_Int(File, "Weapon1"),dini_Int(File, "Weapon1Ammo"));
			GivePlayerWeapon(playerid,dini_Int(File, "Weapon2"),dini_Int(File, "Weapon2Ammo"));
		 	GivePlayerWeapon(playerid,dini_Int(File, "Weapon3"),dini_Int(File, "Weapon3Ammo"));
		 	GivePlayerWeapon(playerid,dini_Int(File, "Weapon4"),dini_Int(File, "Weapon4Ammo"));
		 	GivePlayerWeapon(playerid,dini_Int(File, "Weapon5"),dini_Int(File, "Weapon5Ammo"));
		 	GivePlayerWeapon(playerid,dini_Int(File, "Weapon6"),dini_Int(File, "Weapon6Ammo"));
		}
	}
	#endif
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	#if SaveKillsDeaths == true
	if(killerid != playerid)
	{
	    PlayerData[playerid][Deaths]++;
	    PlayerData[killerid][Deaths]++;
	}
	#endif
	return 1;
}

public OnPlayerText(playerid, text[])
{
	#if VIPchat == true
    if(text[0] == VIPchatSymbol)
  	{
  	    if(PlayerData[playerid][Level] >= 1)
  	    {
		    new str[128], name[24];
		    GetPlayerName(playerid, name, 24);
		    format(str, 128, "[VIP CHAT] %s(%d): %s", name,playerid, text[1]);
    		SendMessageToVIP(COLOR_KHAKI,str);
		    return 0;
		}
	}
	#endif
	
	#if VIPinChat == true
	if(PlayerData[playerid][Level] >= 1)
	{
		new string[128];
	 	format(string, sizeof(string), "{00FF00}(VIP){FFFF00}(%i) {FFFFFF}%s", playerid, text); //with player ID in chat
	  	SendPlayerMessageToAll(playerid, string);
	   	return 0;
	}
	#endif
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}

public OnPlayerUpdate(playerid)
{
    new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,sizeof(name));
	format(File,sizeof(File),"fVIP/Accounts/%s.txt",name);
	if(dini_Exists(File))
	{
	    dini_IntSet(File,"Level",PlayerData[playerid][Level]);
	    #if SaveKillsDeaths == true
	    dini_IntSet(File,"Kills",PlayerData[playerid][Kills]);
	    dini_IntSet(File,"Deaths",PlayerData[playerid][Deaths]);
	    #endif
	    #if SaveMoneyScore == true
	    dini_IntSet(File,"Money",GetPlayerMoney(playerid));
	    dini_IntSet(File,"Score",GetPlayerScore(playerid));
	    #endif
	    #if SaveWeapons == true
		if(PlayerData[playerid][Level] >= 1)
		{
			new weap1, ammo1, weap2, ammo2, weap3, ammo3, weap4, ammo4, weap5, ammo5, weap6, ammo6;
			GetPlayerWeaponData(playerid,2,weap1,ammo1);
			GetPlayerWeaponData(playerid,3,weap2,ammo2);
			GetPlayerWeaponData(playerid,4,weap3,ammo3);
			GetPlayerWeaponData(playerid,5,weap4,ammo4);
			GetPlayerWeaponData(playerid,6,weap5,ammo5);
			GetPlayerWeaponData(playerid,7,weap6,ammo6);
			dini_IntSet(File, "Weapon1",weap1);
		 	dini_IntSet(File, "Weapon1Ammo",ammo1);
			dini_IntSet(File, "Weapon2",weap2);
			dini_IntSet(File, "Weapon2Ammo",ammo2);
			dini_IntSet(File, "Weapon3",weap3);
			dini_IntSet(File, "Weapon3Ammo",ammo3);
			dini_IntSet(File, "Weapon4",weap4);
			dini_IntSet(File, "Weapon4Ammo",ammo4);
			dini_IntSet(File, "Weapon5",weap5);
			dini_IntSet(File, "Weapon5Ammo",ammo5);
			dini_IntSet(File, "Weaponn6",weap6);
			dini_IntSet(File, "Weapon6Ammo",ammo6);
		}
		#endif
	}
	
	new TAcc[50];
    format(TAcc,sizeof(TAcc),"fVIP/Files/TotalAccounts.txt");
    if(dini_Exists(TAcc))
    {
        dini_IntSet(TAcc,"Accounts",TotalAccounts);
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid == ConfigDialog)
	{
	    case 1:
	    {
           	switch(listitem)
        	{
        	    case 0:
        	    {
        	        if(response)
        	        {
        	        	ShowPlayerDialog(playerid,MaxLevelDialog,DIALOG_STYLE_INPUT,"Change max. VIP level:","Insert your new max. VIP level!","Change","Back");
					}
					else
					{
					    return 0;
					}
				}
		        case 1:
		        {
		            if(response)
        	        {
		            	ShowPlayerDialog(playerid,MoneyForJoin,DIALOG_STYLE_INPUT,"Change money for join:","Insert your new ammount of money which\nwill VIP player receive when they connect!","Change","Back");
                    }
					else
					{
					    return 0;
					}
				}
				case 2:
				{
				    if(response)
        	        {
				    	ShowPlayerDialog(playerid,ScoreForJoin,DIALOG_STYLE_INPUT,"Change score for join:","Insert your new ammount of score which\nwill VIP player receive when they connect!","Change","Back");
                    }
					else
					{
					    return 0;
					}
				}
		        case 3:
		        {
		            if(response)
        	        {
			            SendClientMessage(playerid,COLOR_RED,"{FF0000}ERROR: {FFFFFF}You cant change ammount of total VIP accounts!");
			            new cfg[500];
					    format(cfg,sizeof(cfg),"{FFFFFF}Max VIP Level:\t\t{FFFF00}%d\n{FFFFFF}Money for join:\t\t{FFFF00}%d$\n{FFFFFF}Score for join:\t\t{FFFF00}%d\n{FFFFFF}Total accounts:\t\t{FFFF00}%d",MaxLevel,MoneyAdd,ScoreAdd,TotalAccounts);
					    ShowPlayerDialog(playerid,ConfigDialog,DIALOG_STYLE_LIST,"{00FF40}VIP System Configuration:",cfg,"Select","Close");
					}
					else
					{
					    return 0;
					}
				}
			}
		}
	}
	switch(dialogid == MaxLevelDialog)
	{
	    case 1:
	    {
	        if(response)
	        {
	            new MAX_LVL[50];
	            new lvl = strval(inputtext);
			    format(MAX_LVL,sizeof(MAX_LVL),"fVIP/Files/Configuration.txt");
			    if(dini_Exists(MAX_LVL))
			    {
			        dini_IntSet(MAX_LVL,"MaxVipLevel",lvl);
				}
				new cfg[500];
	    		format(cfg,sizeof(cfg),"{FFFFFF}Max VIP Level:\t\t{FFFF00}%d\n{FFFFFF}Money for join:\t\t{FFFF00}%d$\n{FFFFFF}Score for join:\t\t{FFFF00}%d\n{FFFFFF}Total accounts:\t\t{FFFF00}%d",MaxLevel,MoneyAdd,ScoreAdd,TotalAccounts);
	    		ShowPlayerDialog(playerid,ConfigDialog,DIALOG_STYLE_LIST,"{00FF40}VIP System Configuration:",cfg,"Select","Close");
	        }
	        else if(!response)
	        {
	            new cfg[500];
	    		format(cfg,sizeof(cfg),"{FFFFFF}Max VIP Level:\t\t{FFFF00}%d\n{FFFFFF}Money for join:\t\t{FFFF00}%d$\n{FFFFFF}Score for join:\t\t{FFFF00}%d\n{FFFFFF}Total accounts:\t\t{FFFF00}%d",MaxLevel,MoneyAdd,ScoreAdd,TotalAccounts);
	    		ShowPlayerDialog(playerid,ConfigDialog,DIALOG_STYLE_LIST,"{00FF40}VIP System Configuration:",cfg,"Select","Close");
			}
		}
 	}
 	switch(dialogid == MoneyForJoin)
	{
	    case 1:
	    {
	        if(response)
	        {
	            new MONEY_JOIN[50];
	            new money = strval(inputtext);
			    format(MONEY_JOIN,sizeof(MONEY_JOIN),"fVIP/Files/Configuration.txt");
			    if(dini_Exists(MONEY_JOIN))
			    {
			        dini_IntSet(MONEY_JOIN,"MoneyForJoin",money);
				}
				new cfg[500];
	    		format(cfg,sizeof(cfg),"{FFFFFF}Max VIP Level:\t\t{FFFF00}%d\n{FFFFFF}Money for join:\t\t{FFFF00}%d$\n{FFFFFF}Score for join:\t\t{FFFF00}%d\n{FFFFFF}Total accounts:\t\t{FFFF00}%d",MaxLevel,MoneyAdd,ScoreAdd,TotalAccounts);
	    		ShowPlayerDialog(playerid,ConfigDialog,DIALOG_STYLE_LIST,"{00FF40}VIP System Configuration:",cfg,"Select","Close");
	        }
	        else if(!response)
	        {
	            new cfg[500];
	    		format(cfg,sizeof(cfg),"{FFFFFF}Max VIP Level:\t\t{FFFF00}%d\n{FFFFFF}Money for join:\t\t{FFFF00}%d$\n{FFFFFF}Score for join:\t\t{FFFF00}%d\n{FFFFFF}Total accounts:\t\t{FFFF00}%d",MaxLevel,MoneyAdd,ScoreAdd,TotalAccounts);
	    		ShowPlayerDialog(playerid,ConfigDialog,DIALOG_STYLE_LIST,"{00FF40}VIP System Configuration:",cfg,"Select","Close");
			}
		}
 	}
 	switch(dialogid == ScoreForJoin)
	{
	    case 1:
	    {
	        if(response)
	        {
	            new SCORE_JOIN[50];
	            new score = strval(inputtext);
			    format(SCORE_JOIN,sizeof(SCORE_JOIN),"fVIP/Files/Configuration.txt");
			    if(dini_Exists(SCORE_JOIN))
			    {
			        dini_IntSet(SCORE_JOIN,"ScoreForJoin",score);
				}
				new cfg[500];
	    		format(cfg,sizeof(cfg),"{FFFFFF}Max VIP Level:\t\t{FFFF00}%d\n{FFFFFF}Money for join:\t\t{FFFF00}%d$\n{FFFFFF}Score for join:\t\t{FFFF00}%d\n{FFFFFF}Total accounts:\t\t{FFFF00}%d",MaxLevel,MoneyAdd,ScoreAdd,TotalAccounts);
	    		ShowPlayerDialog(playerid,ConfigDialog,DIALOG_STYLE_LIST,"{00FF40}VIP System Configuration:",cfg,"Select","Close");
	        }
	        else if(!response)
	        {
	            new cfg[500];
	    		format(cfg,sizeof(cfg),"{FFFFFF}Max VIP Level:\t\t{FFFF00}%d\n{FFFFFF}Money for join:\t\t{FFFF00}%d$\n{FFFFFF}Score for join:\t\t{FFFF00}%d\n{FFFFFF}Total accounts:\t\t{FFFF00}%d",MaxLevel,MoneyAdd,ScoreAdd,TotalAccounts);
	    		ShowPlayerDialog(playerid,ConfigDialog,DIALOG_STYLE_LIST,"{00FF40}VIP System Configuration:",cfg,"Select","Close");
			}
		}
 	}
	return 1;
}

COMMAND:vips(playerid,params[])
{
	new count = 0;
	new string[128];
	new VIPType[20];
	SendClientMessage(playerid,-1,"");
	SendClientMessage(playerid,COLOR_GREEN,"________________|ONLINE VIPS|________________");
	SendClientMessage(playerid,-1,"");
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerData[i][Level] > 0)
			{
				if(PlayerData[i][Level] == 1)
				{
					VIPType = Level1Tag;
				}
				else if(PlayerData[i][Level] == 2)
				{
					VIPType = Level2Tag;
				}
				else if(PlayerData[i][Level] == 3)
				{
					VIPType = Level3Tag;
				}
				else if(PlayerData[i][Level] == 4)
				{
					VIPType = Level4Tag;
				}
				new Name[MAX_PLAYER_NAME];
				GetPlayerName(i,Name,sizeof(Name));
				format(string, sizeof(string), "Level: %d | Name: %s (ID:%i) | Rank: %s ", PlayerData[i][Level], Name,i,VIPType);
				SendClientMessage(playerid,COLOR_YELLOW,string);
				count++;
			}
		}
	}
	if(count == 0)
	SendClientMessage(playerid,COLOR_RED,"No VIPs online!");
	SendClientMessage(playerid,COLOR_GREEN,"______________________________________________");
	return 1;
}

COMMAND:vcfg(playerid,params[])
{
	if(IsPlayerAdmin(playerid))
	{
	    new cfg[500];
	    format(cfg,sizeof(cfg),"{FFFFFF}Max VIP Level:\t\t{FFFF00}%d\n{FFFFFF}Money for join:\t\t{FFFF00}%d$\n{FFFFFF}Score for join:\t\t{FFFF00}%d\n{FFFFFF}Total accounts:\t\t{FFFF00}%d",MaxLevel,MoneyAdd,ScoreAdd,TotalAccounts);
	    ShowPlayerDialog(playerid,ConfigDialog,DIALOG_STYLE_LIST,"{00FF40}VIP System Configuration:",cfg,"Select","Close");
	}
	else SendClientMessage(playerid,COLOR_RED,"{FF0000}ERROR: {FFFFFF}You are not RCON Administrator!");
	return 1;
}

COMMAND:delvip(playerid,params[])
{
	if(IsPlayerAdmin(playerid))
	{
	    	new AccName[100];
		    if(!sscanf(params, "s[50]", AccName))
		    {
				format(File,sizeof(File),"/fVIP/Accounts/%s.txt",AccName);
				if(dini_Exists(File))
				{
					TotalAccounts--;
					new dastring[256];
					format(dastring,sizeof(dastring),"{00FF40}SUCCES: {FFFFFF}You have deleted account {FFFF00}%s!",AccName);
					SendClientMessage(playerid,COLOR_GREEN,dastring);
					dini_Remove(File);
				}
				else SendClientMessage(playerid,COLOR_RED,"{FF0000}ERROR: {FFFFFF}Account with that name does not exist!");
			}
			else SendClientMessage(playerid, COLOR_YELLOW, "{FF0000}USAGE: {FFFFFF}/delvip <vip-account-name>");
	}
	else SendClientMessage(playerid,COLOR_RED,"{FF0000}ERROR: {FFFFFF}You are not RCON Administrator!");
	return 1;
}

COMMAND:setvips(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		new Target;
		new VLevel;
		new levelerror[100];
		format(levelerror,sizeof(levelerror),"{FF0000}ERROR: {FFFFFF}Maximum level is {FFFF00}%d!",MaxLevel);
		if(!sscanf(params, "ui",Target,VLevel))
		{
			if(VLevel > MaxLevel) return SendClientMessage(playerid, COLOR_RED, levelerror);
			if(Target == INVALID_PLAYER_ID) return SendClientMessage(playerid,COLOR_RED,"{FF0000}ERROR: {FFFFFF}Wrong player ID!");
			PlayerData[Target][Level] = VLevel;
			new tname[MAX_PLAYER_NAME];
			GetPlayerName(Target,tname,sizeof(tname));
			new pname[MAX_PLAYER_NAME];
			GetPlayerName(playerid,pname,sizeof(pname));
			new MyString[128];
			format(MyString, sizeof(MyString), "{00FF40}SUCCES: {FFFFFF}You have set {FFFF00}%s {FFFFFF}VIP Level to {FFFF00}%i!", tname, VLevel);
			SendClientMessage(playerid,COLOR_GREEN,MyString);
			if(PlayerData[Target][Level] > 0)
			{
				TotalAccounts++;
				format(File,sizeof(File),"/fVIP/Accounts/%s.txt",tname);
				if(dini_Exists(File))
				{
					dini_IntSet(File,"AccountNumber",TotalAccounts);
				}
			}
			else if(PlayerData[playerid][Level] == 0)
			{
				TotalAccounts--;
				format(File,sizeof(File),"/fVIP/Accounts/%s.txt",tname);
				if(dini_Exists(File))
				{
					dini_Set(File,"AccountNumber","N/A");
				}
			}
		}
		else SendClientMessage(playerid, COLOR_YELLOW, "{FF0000}USAGE: {FFFFFF}/setvips <playerid> <vip-level>");
	}
	else SendClientMessage(playerid,COLOR_RED,"{FF0000}ERROR: {FFFFFF}You are not RCON Administrator!");
	return 1;
}

stock SendMessageToVIP(color,const string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) == 1)
		if(PlayerData[i][Level] >= 1)
		SendClientMessage(i, color, string);
	}
	return 1;
}
