//You can remove credits and you're allowed to modify it however you like, Just enjoy.

				  /*********************
              ********Includes Database********
                  *********************/
#include <a_samp>
#include <a_mysql>
#include <YSI\y_commands>
#include <YSI\y_master>
#include <foreach>
#include <sscanf2>

//====================================================
                  /*********************
              *********Mysql Database*********
                  *********************/
#define mysql_host 			"localhost"
#define mysql_user 			"root"
#define mysql_password 		""
#define mysql_database 		"vip"

//====================================================
                  /*********************
              ************Dialogs************
                  *********************/
#define D_VIPS    			10001
#define D_VIP    			10002
#define VIP1 				10003
#define VIP2 				10004
#define VIP3 				10005
#define D_NEON 				10006
#define D_TCAR 				10007
#define D_REGISTER			10008
#define D_LOGIN			    10009
#define VSPECIAL			10010
//====================================================
                  /*********************
              ************Colors************
                  *********************/
#define C_RED 				0xFF0000FF
#define C_CYAN 				0x00FFFFFF
#define C_WHITE 			0xFFFFFFFF
#define C_GREEN 			0x15FF00FF
#define C_LIME              0x99FF00FF
#define C_LBLUE 			0x33CCFFFF
#define C_LGREEN 			0x33FF33FF
//====================================================
                  /*********************
              *********Variables**********
                  *********************/
new IsInVHouse[MAX_PLAYERS] 		   = 1;
new VIPFix[MAX_PLAYERS] 			   = 1;
new VIPHeal[MAX_PLAYERS] 			   = 1;
new VIPArmour[MAX_PLAYERS] 			   = 1;
new VIPWeaps[MAX_PLAYERS] 			   = 1;

new LastVIPVehicle[MAX_PLAYERS];

//====================================================
                  /*********************
              ***********ENUM************
                  *********************/
enum pInfo
{
	pVIP,
    Seconds,
    Minutes,
	Hours,
	pKillingspree,
	pLogged,
	pKills,
	pDeaths
}
new PlayerInfo[MAX_PLAYERS][pInfo];


                  /*********************
              *********Callbacks**********
                  *********************/
public OnFilterScriptInit()
{
	print("...:::===========================:::...");
	print("...:::DeMoX's V.I.P System Loaded:::...");
	print("...:::===========================:::...");
	
	SetTimer("TimeUpdater",1000,true);
	
	mysql_connect(mysql_host, mysql_user, mysql_database, mysql_password);
  	mysql_query("CREATE TABLE IF NOT EXISTS accounts(user VARCHAR(24), password VARCHAR(41), VIP INT(20), score INT(20), money INT(20), IP VARCHAR(16), kills INT(20), deaths INT(20), seconds INT(20), minutes INT(20), hours INT(20) )");

    if(mysql_ping() == 1)
	{
        mysql_debug(1);
		printf("[MYSQL] Connection with the database: SUCCESS!");
	}
	else
	{
 		printf("[MYSQL] Connection with the database: FAILED!");
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
    PlayerInfo[playerid][pKillingspree] = 0;
    PlayerInfo[playerid][pVIP]          = 0;
    IsInVHouse[playerid]                = 0;
	VIPArmour[playerid]                 = 1;
	VIPFix[playerid]                    = 1;
	VIPHeal[playerid]                   = 1;
	PlayerInfo[playerid][pLogged]       = 0;
	PlayerInfo[playerid][pKills]        = 0;
	PlayerInfo[playerid][pDeaths]       = 0;
	
	if(PlayerInfo[playerid][pLogged] == 1)
	{
		SaveStats(playerid);
		PlayerInfo[playerid][pLogged] = 0;
	}
	
	/*new string[128];
	format(string, sizeof(string), "SELECT IP FROM `accounts` WHERE user = '%s' LIMIT 1", Name(playerid));

	mysql_query(string);
	mysql_store_result();
	new rows = mysql_num_rows();
	if(rows == 0)
	{
		format(string, sizeof(string), "{FFFFFF}Hello {00AAFF}%s{FFFFFF}! This username isn't registered.\n\
		Please type your new password here:", Name(playerid));
		ShowPlayerDialog(playerid, D_REGISTER, DIALOG_STYLE_PASSWORD, "Register", string, "Register", "Kick");
	}
	else if(rows == 1)
	{
	    format(string, sizeof(string), "{FFFFFF}Hello {00AAFF}%s{FFFFFF}! This username is registered.\n\
		Please type your password here:", Name(playerid));
	    ShowPlayerDialog(playerid, D_LOGIN, DIALOG_STYLE_PASSWORD, "Login", string, "Login", "Kick");
	}
	mysql_free_result();*/
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	// == VICTIM ==
	new Float:XYZ[3], deathtext[128];
	GetPlayerPos(playerid, XYZ[0], XYZ[1], XYZ[2]);
	GameTextForPlayer(playerid, "~r~ Owned", 3000, 3);

	PlayerInfo[playerid][pDeaths] ++;

	PlayerInfo[playerid][pKillingspree] = 0;
	VIPHeal[playerid] = 1;
	VIPArmour[playerid] = 1;
	VIPWeaps[playerid] = 1;
	DestroyVehicle(LastVIPVehicle[playerid]);

    new rand = random(5000-1000)+1000;
	format(deathtext, sizeof(deathtext), "{FFFFFF}You died! Lost {FF0000}-$%d{FFFFFF} because of death.", rand);
	SendClientMessage(playerid, C_RED, deathtext);
	GivePlayerMoney(playerid, -rand);

	SendDeathMessage(killerid, playerid, reason);

	if(killerid != INVALID_PLAYER_ID)
	{
	    TogglePlayerSpectating(playerid, 1);
	    if(IsPlayerInAnyVehicle(killerid))
	    {
	        new vehicleid = GetPlayerVehicleID(killerid);
	        PlayerSpectateVehicle(playerid, vehicleid);
		}
		else
		{
	    	PlayerSpectatePlayer(playerid, killerid);
		}

	    SetTimerEx("DeathCameraStop", 1000*6, false, "i", playerid);
	}
	//====================================================

	//====================================================

 	// == KILLER ==
    if(killerid != INVALID_PLAYER_ID)
    {
        GameTextForPlayer(killerid, "~r~An enemy killed\n~g~+3 score and $1500", 3000, 3);

		GivePlayerScore(killerid, 3);
		GivePlayerMoney(killerid, 1500);

		PlayerInfo[killerid][pKillingspree] ++;
		PlayerInfo[killerid][pKills] ++;
	}

	// == KILLING SPREE ==
	new text[128];
	if(PlayerInfo[killerid][pKillingspree] == 3)
	{
	    format(text, sizeof(text), "** %s {99FF00} is on 3 killing spree!", Name(killerid));
		SendClientMessageToAll(C_WHITE, text);
  		SendClientMessage(killerid, C_LBLUE, "You get $1000 and +2 score! (killing spree bonuses)");
  		GivePlayerMoney(playerid, 1000);
  		GivePlayerScore(playerid, 2);
  		if(IsPlayerVIP(playerid))
		{
		   SendClientMessage(playerid,C_GREEN,"[V.BONUSES] You get double bonuses as a V.I.P.");
		   GivePlayerMoney(playerid, 1000);
  		   GivePlayerScore(playerid, 2);
  		}
	}
    else if(PlayerInfo[killerid][pKillingspree] == 5)
	{
	    format(text, sizeof(text), "** %s {99FF00} is on 5 killing spree!", Name(killerid));
		SendClientMessageToAll(C_WHITE, text);
		SendClientMessage(killerid, C_LBLUE, "You get $2000 and +3 score! (killing spree bonus)");
		GivePlayerMoney(playerid, 2000);
  		GivePlayerScore(playerid, 3);
  		if(IsPlayerVIP(playerid))
		{
		   SendClientMessage(playerid,C_GREEN,"[V.BONUSES] You get double bonuses as a V.I.P.");
		   GivePlayerMoney(playerid, 2000);
  		   GivePlayerScore(playerid, 3);
  		}
	}
	else if(PlayerInfo[killerid][pKillingspree] == 10)
	{
	    format(text, sizeof(text), "** %s {99FF00} is on 10 killing spree!", Name(killerid));
		SendClientMessageToAll(C_WHITE, text);
		SendClientMessage(killerid, C_LBLUE, "You get $4000 and +4 score! (killing spree bonus)");
		GivePlayerMoney(playerid, 4000);
  		GivePlayerScore(playerid, 4);
  		if(IsPlayerVIP(playerid))
		{
		   SendClientMessage(playerid,C_GREEN,"[V.BONUSES] You get double bonuses as a V.I.P.");
		   GivePlayerMoney(playerid, 4000);
  		   GivePlayerScore(playerid, 4);
  		}
	}
	else if(PlayerInfo[killerid][pKillingspree] == 15)
	{
	    format(text, sizeof(text), "** %s {99FF00} is on 15 killing spree!", Name(killerid));
		SendClientMessageToAll(C_WHITE, text);
		SendClientMessage(killerid, C_LBLUE, "You get $6000 and +6 score! (killing spree bonus)");
		GivePlayerMoney(playerid, 6000);
  		GivePlayerScore(playerid, 6);
  		if(IsPlayerVIP(playerid))
		{
		   SendClientMessage(playerid,C_GREEN,"[V.BONUSES] You get double bonuses as a V.I.P.");
		   GivePlayerMoney(playerid, 6000);
  		   GivePlayerScore(playerid, 6);
  		}
	}
	else if(PlayerInfo[killerid][pKillingspree] == 20)
	{
	    format(text, sizeof(text), "** %s {99FF00} is on 20 killing spree!", Name(killerid));
		SendClientMessageToAll(C_WHITE, text);
		SendClientMessage(killerid, C_LBLUE, "You get $8000 and +8 score! (killing spree bonus)");
		GivePlayerMoney(playerid, 8000);
  		GivePlayerScore(playerid, 8);
  		if(IsPlayerVIP(playerid))
		{
		   SendClientMessage(playerid,C_GREEN,"[V.BONUSES] You get double bonuses as a V.I.P.");
		   GivePlayerMoney(playerid, 8000);
  		   GivePlayerScore(playerid, 8);
  		}
	}
	else if(PlayerInfo[killerid][pKillingspree] == 25)
	{
	    format(text, sizeof(text), "** %s {99FF00} is on 25 killing spree)!", Name(killerid));
		SendClientMessageToAll(C_WHITE, text);
		SendClientMessage(killerid, C_LBLUE, "You get $10000 and +10 score! (killing spree bonus)");
		GivePlayerMoney(playerid, 10000);
  		GivePlayerScore(playerid, 10);
  		if(IsPlayerVIP(playerid))
		{
		   SendClientMessage(playerid,C_GREEN,"[V.BONUSES] You get double bonuses as a V.I.P.");
		   GivePlayerMoney(playerid, 10000);
  		   GivePlayerScore(playerid, 10);
  		}
	}
	else if(PlayerInfo[killerid][pKillingspree] == 30)
	{
        format(text, sizeof(text), "** %s {99FF00} is on 30 killing spree)!", Name(killerid));
		SendClientMessageToAll(C_WHITE, text);
		SendClientMessage(killerid, C_LBLUE, "You get $12000 and +12 score! (killing spree bonus)");
		GivePlayerMoney(playerid, 12000);
  		GivePlayerScore(playerid, 12);
  		if(IsPlayerVIP(playerid))
		{
		   SendClientMessage(playerid,C_GREEN,"[V.BONUSES] You get double bonuses as a V.I.P.");
		   GivePlayerMoney(playerid, 12000);
  		   GivePlayerScore(playerid, 12);
  		}
    }
    else if(PlayerInfo[killerid][pKillingspree] == 35)
    {
		format(text, sizeof(text), "** %s {99FF00} is on 35 killing spree)!", Name(killerid));
		SendClientMessageToAll(C_WHITE, text);
		SendClientMessage(killerid, C_LBLUE, "You get $14000 and +14 score! (killing spree bonus)");
		GivePlayerMoney(playerid, 14000);
  		GivePlayerScore(playerid, 14);
  		if(IsPlayerVIP(playerid))
		{
		   SendClientMessage(playerid,C_GREEN,"[V.BONUSES] You get double bonuses as a V.I.P.");
		   GivePlayerMoney(playerid, 14000);
  		   GivePlayerScore(playerid, 14);
  		}
	}
	else if(PlayerInfo[killerid][pKillingspree] == 40)
    {
		format(text, sizeof(text), "** %s {99FF00} is on 40 killing spree)!", Name(killerid));
		SendClientMessageToAll(C_WHITE, text);
		SendClientMessage(killerid, C_LBLUE, "You get $16000 and +16 score! (killing spree bonus)");
		GivePlayerMoney(playerid, 16000);
  		GivePlayerScore(playerid, 16);
  		if(IsPlayerVIP(playerid))
		{
		   SendClientMessage(playerid,C_GREEN,"[V.BONUSES] You get double bonuses as a V.I.P.");
		   GivePlayerMoney(playerid, 16000);
  		   GivePlayerScore(playerid, 16);
  		}
	}
	else if(PlayerInfo[killerid][pKillingspree] == 45)
    {
		format(text, sizeof(text), "** %s {99FF00} is on 45 killing spree)!", Name(killerid));
		SendClientMessageToAll(C_WHITE, text);
		SendClientMessage(killerid, C_LBLUE, "You get $18000 and +18 score! (killing spree bonus)");
		GivePlayerMoney(playerid, 18000);
  		GivePlayerScore(playerid, 18);
  		if(IsPlayerVIP(playerid))
		{
		   SendClientMessage(playerid,C_GREEN,"[V.BONUSES] You get double bonuses as a V.I.P.");
		   GivePlayerMoney(playerid, 18000);
  		   GivePlayerScore(playerid, 18);
  		}
	}
	else if(PlayerInfo[killerid][pKillingspree] == 50)
    {
		format(text, sizeof(text), "** %s {99FF00} is on 50 killing spree)!", Name(killerid));
		SendClientMessageToAll(C_WHITE, text);
		SendClientMessage(killerid, C_LBLUE, "You get $20000 and +20 score! (killing spree bonus)");
		GivePlayerMoney(playerid, 20000);
  		GivePlayerScore(playerid, 20);
  		if(IsPlayerVIP(playerid))
		{
		   SendClientMessage(playerid,C_GREEN,"[V.BONUSES] You get double bonuses as a V.I.P.");
		   GivePlayerMoney(playerid, 20000);
  		   GivePlayerScore(playerid, 20);
  		}
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
         /*case D_REGISTER:
	    {
			if(response)
			{
				if(strlen(inputtext) >= 1)
				{
				    new pass[50];
					mysql_real_escape_string(inputtext, pass);
					Register(playerid, pass);
				}
				else
				{
				    new string[128];
				    format(string, sizeof(string), "{FFFFFF}Hello {00AAFF}%s{FFFFFF}! This username isn't registered.\nPlease type your new password here:", Name(playerid));
				    ShowPlayerDialog(playerid, D_REGISTER, DIALOG_STYLE_PASSWORD, "Register", string, "Register", "Kick");
				}
			}
			if(!response)
			{
				return Kick(playerid);
			}
		}
		case D_LOGIN:
		{
		    if(response)
		    {
		        new query[200], pass[50];
		        mysql_real_escape_string(inputtext, pass);
				format(query, sizeof(query), "SELECT `user` FROM `accounts` WHERE user = '%s' AND password = '%s'", Name(playerid), pass);
				mysql_query(query);
				mysql_store_result();
				new rows = mysql_num_rows();
				if(rows == 1)
				{
				    Login(playerid);
				}
				if(!rows)
				{
					new string[150];
					format(string, sizeof(string), "{FFFFFF}Hello {00AAFF}%s{FFFFFF}! This username is registered.\n{FF0000}Please type your correct password here:", Name(playerid));
				    ShowPlayerDialog(playerid, D_LOGIN, DIALOG_STYLE_PASSWORD, "Login", string, "Login", "Kick");
				}
				mysql_free_result();
			}
		    if(!response)
		    {
		        return Kick(playerid);
		    }
		 }*/
		 case D_TCAR:
		 {
		    if(response)
		    {
		        switch(listitem)
		    	{
		            case 0:
	                {
				    	new vid;
				    	if(LastVIPVehicle[playerid] != 0) DestroyVehicle(LastVIPVehicle[playerid]);
	                    GiveVehicle(playerid,558);
	                    vid = GetPlayerVehicleID(playerid);
		    			AddVehicleComponent(vid, 1010); AddVehicleComponent(vid, 1089);	AddVehicleComponent(vid, 1163);
		    		    AddVehicleComponent(vid, 1085);	AddVehicleComponent(vid, 1090);	AddVehicleComponent(vid, 1165);
		    		    AddVehicleComponent(vid, 1087);	AddVehicleComponent(vid, 1091); AddVehicleComponent(vid, 1167);
		    			PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
		    			ChangeVehiclePaintjob(vid,1);
		    			LastVIPVehicle[playerid] = GetPlayerVehicleID(playerid);
		    			SendClientMessage(playerid,C_CYAN,"Castro:{FFFFFF} You have spawned a Tuned Uranus");
	                }
	                case 1:
	                {
	                    new vid;
	                    if(LastVIPVehicle[playerid] != 0) DestroyVehicle(LastVIPVehicle[playerid]);
    	                GiveVehicle(playerid,560);
	                    vid = GetPlayerVehicleID(playerid);
		    			AddVehicleComponent(vid, 1010); AddVehicleComponent(vid, 1033);	AddVehicleComponent(vid, 1138);
			    	    AddVehicleComponent(vid, 1026);	AddVehicleComponent(vid, 1083);	AddVehicleComponent(vid, 1140);
				        AddVehicleComponent(vid, 1028);	AddVehicleComponent(vid, 1087); AddVehicleComponent(vid, 1169);
					    PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
    					ChangeVehiclePaintjob(vid,1);
    					LastVIPVehicle[playerid] = GetPlayerVehicleID(playerid);
    					SendClientMessage(playerid,C_CYAN,"Castro:{FFFFFF} You have spawned a Tuned Sultan");
	                }
	                case 2:
	                {
	                    new vid;
	                    if(LastVIPVehicle[playerid] != 0) DestroyVehicle(LastVIPVehicle[playerid]);
	                    GiveVehicle(playerid,559);
	                    vid = GetPlayerVehicleID(playerid);
		    			AddVehicleComponent(vid, 1010); AddVehicleComponent(vid, 1087);	AddVehicleComponent(vid, 1158);
			    	    AddVehicleComponent(vid, 1065);	AddVehicleComponent(vid, 1085);	AddVehicleComponent(vid, 1160);
				        AddVehicleComponent(vid, 1068);	AddVehicleComponent(vid, 1069); AddVehicleComponent(vid, 1161);
    					PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
	    				ChangeVehiclePaintjob(vid,0);
	    				LastVIPVehicle[playerid] = GetPlayerVehicleID(playerid);
	    				SendClientMessage(playerid,C_CYAN,"Castro:{FFFFFF} You have spawned a Tuned Jester");
	                }
	                case 3:
	                {
    	                new vid;
    	                if(LastVIPVehicle[playerid] != 0) DestroyVehicle(LastVIPVehicle[playerid]);
	                    GiveVehicle(playerid,561);
	                    vid = GetPlayerVehicleID(playerid);
			    		AddVehicleComponent(vid, 1010); AddVehicleComponent(vid, 1061);	AddVehicleComponent(vid, 1156);
				        AddVehicleComponent(vid, 1056);	AddVehicleComponent(vid, 1064);	AddVehicleComponent(vid, 1157);
				        AddVehicleComponent(vid, 1060);	AddVehicleComponent(vid, 1074);
    					PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
	    				ChangeVehiclePaintjob(vid,1);
	    				LastVIPVehicle[playerid] = GetPlayerVehicleID(playerid);
	    				SendClientMessage(playerid,C_CYAN,"Castro:{FFFFFF} You have spawned a Tuned Stratum");
	                }
	                case 4:
				    {
	                    new vid;
	                    if(LastVIPVehicle[playerid] != 0) DestroyVehicle(LastVIPVehicle[playerid]);
	                    GiveVehicle(playerid,561);
	                    vid = GetPlayerVehicleID(playerid);
    					AddVehicleComponent(vid, 1010); AddVehicleComponent(vid, 1058);	AddVehicleComponent(vid, 1087);
	    			    AddVehicleComponent(vid, 1055);	AddVehicleComponent(vid, 1059);	AddVehicleComponent(vid, 1154);
	    			    AddVehicleComponent(vid, 1056);	AddVehicleComponent(vid, 1085); AddVehicleComponent(vid, 1155);
	    				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
		    			ChangeVehiclePaintjob(vid,2);
		    			LastVIPVehicle[playerid] = GetPlayerVehicleID(playerid);
		    			SendClientMessage(playerid,C_CYAN,"Castro:{FFFFFF} You have spawned a Tuned Stratum 2");
		    		}
		    		case 5:
	                {
    	                new vid;
    	                if(LastVIPVehicle[playerid] != 0) DestroyVehicle(LastVIPVehicle[playerid]);
    	                GiveVehicle(playerid,560);
    	                vid = GetPlayerVehicleID(playerid);
	    				AddVehicleComponent(vid, 1010); AddVehicleComponent(vid, 1033);	AddVehicleComponent(vid, 1140);
		    		    AddVehicleComponent(vid, 1029);	AddVehicleComponent(vid, 1079);	AddVehicleComponent(vid, 1169);
			    	    AddVehicleComponent(vid, 1031);	AddVehicleComponent(vid, 1138);
				    	PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
					    ChangeVehiclePaintjob(vid,0);
					    LastVIPVehicle[playerid] = GetPlayerVehicleID(playerid);
					    SendClientMessage(playerid,C_CYAN,"Castro:{FFFFFF} You have spawned an Alien");
    	            }
    	            case 6:
	    			{
	                    new vid;
	                    if(LastVIPVehicle[playerid] != 0) DestroyVehicle(LastVIPVehicle[playerid]);
	                    GiveVehicle(playerid,562);
	                    vid = GetPlayerVehicleID(playerid);
					    AddVehicleComponent(vid, 1010); AddVehicleComponent(vid, 1039);	AddVehicleComponent(vid, 1146);
    				    AddVehicleComponent(vid, 1037);	AddVehicleComponent(vid, 1079);	AddVehicleComponent(vid, 1148);
	    			    AddVehicleComponent(vid, 1038);	AddVehicleComponent(vid, 1087); AddVehicleComponent(vid, 1172);
		    			PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
			    		ChangeVehiclePaintjob(vid,1);
			    		LastVIPVehicle[playerid] = GetPlayerVehicleID(playerid);
			    		SendClientMessage(playerid,C_CYAN,"Castro:{FFFFFF} You have spawned a Tuned Elegy");
				    }
    				case 7:
	    			{
	                    new vid;
	                    if(LastVIPVehicle[playerid] != 0) DestroyVehicle(LastVIPVehicle[playerid]);
	                    GiveVehicle(playerid,565);
	                    vid = GetPlayerVehicleID(playerid);
					    AddVehicleComponent(vid, 1010); AddVehicleComponent(vid, 1050);	AddVehicleComponent(vid, 1087);
	    			    AddVehicleComponent(vid, 1045);	AddVehicleComponent(vid, 1054);	AddVehicleComponent(vid, 1151);
		    		    AddVehicleComponent(vid, 1047);	AddVehicleComponent(vid, 1083); AddVehicleComponent(vid, 1153);
			    		PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				    	ChangeVehiclePaintjob(vid,0);
				    	LastVIPVehicle[playerid] = GetPlayerVehicleID(playerid);
				    	SendClientMessage(playerid,C_CYAN,"Castro:{FFFFFF} You have spawned a Tuned Flash");
				    }
				    case 8:
				    {
	                    new vid;
	                    if(LastVIPVehicle[playerid] != 0) DestroyVehicle(LastVIPVehicle[playerid]);
	                    GiveVehicle(playerid,534);
	                    vid = GetPlayerVehicleID(playerid);
				    	AddVehicleComponent(vid, 1010); AddVehicleComponent(vid, 1100);
				        AddVehicleComponent(vid, 1077);	AddVehicleComponent(vid, 1122);
				        AddVehicleComponent(vid, 1087);	AddVehicleComponent(vid, 1127);
					    PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
					    ChangeVehiclePaintjob(vid,2);
					    LastVIPVehicle[playerid] = GetPlayerVehicleID(playerid);
					    SendClientMessage(playerid,C_CYAN,"Castro:{FFFFFF} You have spawned a Tuned Remington");
				    }
				    case 9:
				    {
	                    new vid;
	                    if(LastVIPVehicle[playerid] != 0) DestroyVehicle(LastVIPVehicle[playerid]);
	                    GiveVehicle(playerid,535);
	                    vid = GetPlayerVehicleID(playerid);
				    	AddVehicleComponent(vid, 1010); AddVehicleComponent(vid, 1109); AddVehicleComponent(vid, 1118);
				        AddVehicleComponent(vid, 1087);	AddVehicleComponent(vid, 1113);
				        AddVehicleComponent(vid, 1098);	AddVehicleComponent(vid, 1115);
				    	PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				    	ChangeVehiclePaintjob(vid,0);
				    	LastVIPVehicle[playerid] = GetPlayerVehicleID(playerid);
				    	SendClientMessage(playerid,C_CYAN,"Castro:{FFFFFF} You have spawned a Tuned Slamvan");
				    }
		        }
		     }
		}
		case D_NEON:
        {
			if(response)
			{
                 switch(listitem)
		    	 {
                        case 0:
                        {
                             SetPVarInt(playerid, "Status", 1);
                             SetPVarInt(playerid, "neon", CreateObject(18648,0,0,0,0,0,0));
                             SetPVarInt(playerid, "neon1", CreateObject(18648,0,0,0,0,0,0));
                             AttachObjectToVehicle(GetPVarInt(playerid, "neon"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                             AttachObjectToVehicle(GetPVarInt(playerid, "neon1"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                             SendClientMessage(playerid,C_GREEN, "Castro:{FFFFFF} Dark bleu neon have been installed.");
                             GivePlayerMoney(playerid,-5000);
                        }
                        case 1:
                        {
                             SetPVarInt(playerid, "Status", 1);
                             SetPVarInt(playerid, "neon2", CreateObject(18647,0,0,0,0,0,0));
                             SetPVarInt(playerid, "neon3", CreateObject(18647,0,0,0,0,0,0));
                             AttachObjectToVehicle(GetPVarInt(playerid, "neon2"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                             AttachObjectToVehicle(GetPVarInt(playerid, "neon3"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                             SendClientMessage(playerid,C_GREEN, "Castro:{FFFFFF} Red neon have been installed, make sure it's night!");
                             GivePlayerMoney(playerid,-5000);

                        }
                        case 2:
                        {
                             SetPVarInt(playerid, "Status", 1);
                             SetPVarInt(playerid, "neon4", CreateObject(18649,0,0,0,0,0,0));
                             SetPVarInt(playerid, "neon5", CreateObject(18649,0,0,0,0,0,0));
                             AttachObjectToVehicle(GetPVarInt(playerid, "neon4"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                             AttachObjectToVehicle(GetPVarInt(playerid, "neon5"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                             SendClientMessage(playerid,C_GREEN, "Castro:{FFFFFF} Green neon have been installed, make sure it's night!");
                             GivePlayerMoney(playerid,-5000);
                        }
                        case 3:
                        {
                            SetPVarInt(playerid, "Status", 1);
                            SetPVarInt(playerid, "neon6", CreateObject(18652,0,0,0,0,0,0));
                            SetPVarInt(playerid, "neon7", CreateObject(18652,0,0,0,0,0,0));
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon6"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon7"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            SendClientMessage(playerid,C_GREEN, "Castro:{FFFFFF} White neon have been installed, make sure it's night!");
                            GivePlayerMoney(playerid,-5000);

                        }
                        case 4:
                        {
                            SetPVarInt(playerid, "Status", 1);
                            SetPVarInt(playerid, "neon8", CreateObject(18651,0,0,0,0,0,0));
                            SetPVarInt(playerid, "neon9", CreateObject(18651,0,0,0,0,0,0));
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon8"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon9"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            SendClientMessage(playerid,C_GREEN, "Castro:{FFFFFF} Violet neon have been installed, make sure it's night!");
                            GivePlayerMoney(playerid,-5000);

                        }
                        case 5:
                        {
                            SetPVarInt(playerid, "Status", 1);
                            SetPVarInt(playerid, "neon10", CreateObject(18650,0,0,0,0,0,0));
                            SetPVarInt(playerid, "neon11", CreateObject(18650,0,0,0,0,0,0));
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon10"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon11"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            SendClientMessage(playerid,C_GREEN, "Castro:{FFFFFF} Yellow neon have been installed, make sure it's night!");
                            GivePlayerMoney(playerid,-5000);

                        }
                        case 6:
                        {
                            SetPVarInt(playerid, "Status", 1);
                            SetPVarInt(playerid, "neon12", CreateObject(18648,0,0,0,0,0,0));
                            SetPVarInt(playerid, "neon13", CreateObject(18648,0,0,0,0,0,0));
                            SetPVarInt(playerid, "neon14", CreateObject(18649,0,0,0,0,0,0));
                            SetPVarInt(playerid, "neon15", CreateObject(18649,0,0,0,0,0,0));
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon12"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon13"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon14"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon15"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            SendClientMessage(playerid,C_GREEN, "Castro:{FFFFFF} Cyan neon have been installed, make sure it's night!");
                            GivePlayerMoney(playerid,-5000);
                        }
                        case 7:
                        {
                            SetPVarInt(playerid, "Status", 1);
                            SetPVarInt(playerid, "neon16", CreateObject(18648,0,0,0,0,0,0));
                            SetPVarInt(playerid, "neon17", CreateObject(18648,0,0,0,0,0,0));
                            SetPVarInt(playerid, "neon18", CreateObject(18652,0,0,0,0,0,0));
                            SetPVarInt(playerid, "neon19", CreateObject(18652,0,0,0,0,0,0));
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon16"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon17"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon18"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon19"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            SendClientMessage(playerid,C_GREEN, "Castro:{FFFFFF} Light bleu neon have been installed, make sure it's night!");
                            GivePlayerMoney(playerid,-5000);
                        }
                        case 8:
                        {
                            SetPVarInt(playerid, "Status", 1);
                            SetPVarInt(playerid, "neon20", CreateObject(18647,0,0,0,0,0,0));
                            SetPVarInt(playerid, "neon21", CreateObject(18647,0,0,0,0,0,0));
                            SetPVarInt(playerid, "neon22", CreateObject(18652,0,0,0,0,0,0));
                            SetPVarInt(playerid, "neon23", CreateObject(18652,0,0,0,0,0,0));
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon20"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon21"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon22"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon23"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            SendClientMessage(playerid,C_GREEN, "Castro:{FFFFFF} Pink neon have been installed, make sure it's night!");
                            GivePlayerMoney(playerid,-5000);

                        }
                        case 9:
                        {
                            SetPVarInt(playerid, "Status", 1);
                            SetPVarInt(playerid, "neon24", CreateObject(18647,0,0,0,0,0,0));
                            SetPVarInt(playerid, "neon25", CreateObject(18647,0,0,0,0,0,0));
                            SetPVarInt(playerid, "neon26", CreateObject(18650,0,0,0,0,0,0));
                            SetPVarInt(playerid, "neon27", CreateObject(18650,0,0,0,0,0,0));
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon24"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon25"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon26"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon27"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            SendClientMessage(playerid,C_GREEN, "Castro:{FFFFFF} Orange neon have been installed, make sure it's night!");
                            GivePlayerMoney(playerid,-5000);
                        }
                        case 10:
                        {
                            SetPVarInt(playerid, "Status", 1);
                            SetPVarInt(playerid, "neon28", CreateObject(18649,0,0,0,0,0,0));
                            SetPVarInt(playerid, "neon29", CreateObject(18649,0,0,0,0,0,0));
                            SetPVarInt(playerid, "neon30", CreateObject(18652,0,0,0,0,0,0));
                            SetPVarInt(playerid, "neon31", CreateObject(18652,0,0,0,0,0,0));
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon28"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon29"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon30"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon31"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            SendClientMessage(playerid,C_GREEN, "Castro:{FFFFFF} Light green neon have been installed, make sure it's night!");
                            GivePlayerMoney(playerid,-5000);
                        }
                        case 11:
                        {
                            SetPVarInt(playerid, "Status", 1);
                            SetPVarInt(playerid, "neon32", CreateObject(18652,0,0,0,0,0,0));
                            SetPVarInt(playerid, "neon33", CreateObject(18652,0,0,0,0,0,0));
                            SetPVarInt(playerid, "neon34", CreateObject(18650,0,0,0,0,0,0));
                            SetPVarInt(playerid, "neon35", CreateObject(18650,0,0,0,0,0,0));
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon32"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon33"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon34"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            AttachObjectToVehicle(GetPVarInt(playerid, "neon35"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                            SendClientMessage(playerid,C_GREEN, "Castro:{FFFFFF} Light yellow neon have been installed, make sure it's night!");
                            GivePlayerMoney(playerid,-5000);
                        }
                        case 12:
			            {
          			    	SetPVarInt(playerid, "Status", 1);
            	            SetPVarInt(playerid, "neon12", CreateObject(18653,0,0,0,0,0,0));
	                        SetPVarInt(playerid, "neon13", CreateObject(18653,0,0,0,0,0,0));
	                        AttachObjectToVehicle(GetPVarInt(playerid, "neon12"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	                        AttachObjectToVehicle(GetPVarInt(playerid, "neon13"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	                        SendClientMessage(playerid,C_GREEN, "Castro:{FFFFFF} Special red neon have been installed, make sure it's night!");
	                        GivePlayerMoney(playerid,-5000);
	    		        }
                        case 13:
			            {
	                        SetPVarInt(playerid, "Status", 1);
	                        SetPVarInt(playerid, "neon14", CreateObject(18654,0,0,0,0,0,0));
	                        SetPVarInt(playerid, "neon15", CreateObject(18654,0,0,0,0,0,0));
	                        AttachObjectToVehicle(GetPVarInt(playerid, "neon14"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	                        AttachObjectToVehicle(GetPVarInt(playerid, "neon15"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	                        SendClientMessage(playerid,C_GREEN, "Castro:{FFFFFF} Special green neon have been installed, make sure it's night!");
	                        GivePlayerMoney(playerid,-10000);

		    	        }
			            case 14:
			            {
  				            SetPVarInt(playerid, "Status", 1);
	                        SetPVarInt(playerid, "neon16", CreateObject(18655,0,0,0,0,0,0));
	                        SetPVarInt(playerid, "neon17", CreateObject(18655,0,0,0,0,0,0));
	                        AttachObjectToVehicle(GetPVarInt(playerid, "neon16"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	                        AttachObjectToVehicle(GetPVarInt(playerid, "neon17"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	                        SendClientMessage(playerid,C_GREEN, "Castro:{FFFFFF} Special bleu neon have been installed, make sure it's night!");
	                        GivePlayerMoney(playerid,-10000);

    			        }
	    		        case 15:
		    			{
					        DestroyObject(GetPVarInt(playerid, "neon")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon1")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon2")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon3"));
			                DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon4")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon5")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon6")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon7"));
			                DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon8")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon9")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon10")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon11"));
			                DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon12")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon13")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon14")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon15"));
			                DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon16")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon17")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon18")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon19"));
			                DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon20")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon21")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon22")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon23"));
			                DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon24")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon25")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon26")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon27"));
			                DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon28")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon29")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon30")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon31"));
			                SendClientMessage(playerid,C_RED, "Castro:{FFFFFF} You have removed the neon from your vehicule."); GivePlayerMoney(playerid,-10000);
		    			}
		    		}
			}
		}
		case VSPECIAL:
		{
		    if(response)
		    {
				 if(listitem == 0)
				 {
					for ( new i = 0; i < 5; i++ )
						if ( IsPlayerAttachedObjectSlotUsed( playerid, i ) )
							RemovePlayerAttachedObject( playerid, i );

					SetPlayerAttachedObject( playerid, 1, 19086, 8, -0.049768, -0.014062, -0.108385, 87.458297, 263.478149, 184.123764, 0.622413, 1.041609, 1.012785 );
					SendClientMessage( playerid, C_CYAN, "Castro:{FFFFFF} You have holded a {00FF00}dick!" );
					SendClientMessage( playerid, C_CYAN, "Castro:{FFFFFF} To stop holding please type {00FF00}/stophold!" );
				 }
				 if(listitem == 1)
				 {
					for ( new i = 0; i < 5; i++ )
						if ( IsPlayerAttachedObjectSlotUsed( playerid, i ) )
							RemovePlayerAttachedObject( playerid, i );

	                SetPlayerAttachedObject( playerid, 0, 1114, 1, 0.138007, 0.002714, -0.157366, 350.942352, 16.794704, 32.683506, 0.791829, 0.471535, 1.032759 );
					SetPlayerAttachedObject( playerid, 1, 1114, 1, 0.138007, 0.002714, 0.064523, 342.729064, 354.099456, 32.369094, 0.791829, 0.471535, 1.032759 );
	                SendClientMessage( playerid, C_CYAN, "Castro:{FFFFFF} You have holded an {00FF00}iron!" );
					SendClientMessage( playerid, C_CYAN, "Castro:{FFFFFF} To stop holding please type {00FF00}/stophold!" );
				 }
				 if(listitem == 2)
				 {
					for ( new i = 0; i < 5; i++ )
						if ( IsPlayerAttachedObjectSlotUsed( playerid, i ) )
							RemovePlayerAttachedObject( playerid, i );

	           		SetPlayerAttachedObject( playerid, 0, 18645, 2, 0.017478, 0.051500, 0.003912, 285.055511, 90.860740, 171.179550, 1.780549, 0.912008, 1.208514 );
					SetPlayerAttachedObject( playerid, 1, 18690, 2, -2.979508, 0.306475, -0.388553, 285.055511, 90.860740, 171.179550, 1.780549, 0.912008, 1.208514 );
					SetPlayerAttachedObject( playerid, 2, 18716, 2, -2.979508, 0.306475, -0.388553, 285.055511, 90.860740, 171.179550, 1.780549, 0.912008, 1.208514 );
	                SendClientMessage( playerid, C_CYAN, "Castro:{FFFFFF} You have holded as {00FF00}Alien!" );
					SendClientMessage( playerid, C_CYAN, "Castro:{FFFFFF} To stop holding please type {00FF00}/stophold!" );
				 }
				 if(listitem == 3)
				 {
					for ( new i = 0; i < 5; i++ )
						if ( IsPlayerAttachedObjectSlotUsed( playerid, i ) )
							RemovePlayerAttachedObject( playerid, i );

	           		SetPlayerAttachedObject( playerid, 0, 18693, 5, 1.983503, 1.558882, -0.129482, 86.705787, 308.978118, 268.198822, 1.500000, 1.500000, 1.500000 );
					SetPlayerAttachedObject( playerid, 1, 18693, 6, 1.983503, 1.558882, -0.129482, 86.705787, 308.978118, 268.198822, 1.500000, 1.500000, 1.500000 );
					SetPlayerAttachedObject( playerid, 2, 18703, 6, 1.983503, 1.558882, -0.129482, 86.705787, 308.978118, 268.198822, 1.500000, 1.500000, 1.500000 );
					SetPlayerAttachedObject( playerid, 3, 18703, 5, 1.983503, 1.558882, -0.129482, 86.705787, 308.978118, 268.198822, 1.500000, 1.500000, 1.500000 );
					SetPlayerAttachedObject( playerid, 4, 18965, 2, 0.111052, 0.021643, -0.000846, 92.280899, 92.752510, 358.071044, 1.200000, 1.283168, 1.200000 );
					SendClientMessage( playerid, C_CYAN, "Castro:{FFFFFF} You have holded as {00FF00}Icread!" );
					SendClientMessage( playerid, C_CYAN, "Castro:{FFFFFF} To stop holding please type {00FF00}/stophold!" );
				 }
			}
		}
		case D_VIP:
		{
		    if(response)
		    {
			    if(listitem == 0)
			    {
					ShowDialogHelp(playerid, VIP1);
				}
				else if(listitem == 1)
				{
	                ShowDialogHelp(playerid, VIP2);
				}
				else if(listitem == 2)
				{
				    ShowDialogHelp(playerid, VIP3);
				}
			}
		}
	}
	return 1;
}
                  /*********************
              ***********Timers************
                  *********************/
                  
forward TimeUpdater(playerid);
public TimeUpdater(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    PlayerInfo[playerid][Seconds]++;
	    if(PlayerInfo[playerid][Seconds] > 59)
		{
			PlayerInfo[playerid][Seconds]= 0;
			PlayerInfo[playerid][Minutes] = PlayerInfo[playerid][Minutes] +1;
	  	}
	  	if(PlayerInfo[playerid][Minutes] > 59)
		{
			PlayerInfo[playerid][Minutes]=0;
			PlayerInfo[playerid][Hours] = PlayerInfo[playerid][Hours] +1;
	  	}
	}
  	return 1;
}

forward VIPFixTimer(playerid);
public VIPFixTimer(playerid)
{
	VIPFix[playerid] = 1;
	GameTextForPlayer(playerid, "~g~Can fix", 1000, 4);
	return 1;
}

forward DeathCameraStop(playerid);
public DeathCameraStop(playerid)
{
	TogglePlayerSpectating(playerid, 0);
	return 1;
}

                  /*********************
              ***********Stocks************
                  *********************/
                  
/*stock Register(playerid, pass[])
{
	new query[512], ip[16],Float:X,Float:Y,Float:Z;
	GetPlayerIp(playerid, ip, sizeof(ip));

	format(query, sizeof(query), "INSERT INTO accounts(user, password, VIP, score, money, IP, kills, deaths, seconds, minutes, hours) VALUES('%s', '%s', 0, 0, 0, 0, 0, '%s', 0, 0, 0, 0, 0)", Name(playerid), pass, ip);
    mysql_query(query);

	PlayerInfo[playerid][pLogged] = 1;
	SendClientMessage(playerid, C_LGREEN, "You are now {15FF00}registered, {FFFFFF}and automatically {00FFFF}logged in.");
	GetPlayerPos(playerid,X,Y,Z);
	PlayerPlaySound(playerid, 1057, X, Y, Z);
 	return 1;
}

stock Login(playerid)
{
	new query[128], string[128], money, score,Float:X,Float:Y,Float:Z;
	format(query, sizeof(query), "SELECT * FROM accounts WHERE user = '%s'", Name(playerid));

	mysql_query(query);
	mysql_store_result();
 	while(mysql_fetch_row_format(query))
	{
	    mysql_fetch_field_row(string, "VIP"); PlayerInfo[playerid][pVIP] = strval(string);
	    mysql_fetch_field_row(string, "score"); score = strval(string);
	    mysql_fetch_field_row(string, "money"); money = strval(string);
	    mysql_fetch_field_row(string, "kills"); PlayerInfo[playerid][pKills] = strval(string);
	    mysql_fetch_field_row(string, "deaths"); PlayerInfo[playerid][pDeaths] = strval(string);
   	 	mysql_fetch_field_row(string, "seconds"); PlayerInfo[playerid][Seconds] = strval(string);
   	 	mysql_fetch_field_row(string, "minutes"); PlayerInfo[playerid][Minutes] = strval(string);
   	 	mysql_fetch_field_row(string, "hours"); PlayerInfo[playerid][Hours] = strval(string);
	}
	mysql_free_result();
	GivePlayerMoney(playerid, money);
	SetPlayerScore(playerid, score);
	PlayerInfo[playerid][pLogged] = 1;
	SendClientMessage(playerid, C_LGREEN, "Castro:{FFFFFF} Successfully {00FFFF}logged in.");
	GetPlayerPos(playerid,X,Y,Z);
	PlayerPlaySound(playerid, 1057, X, Y, Z);
	return 1;
}*/

stock SaveStats(playerid)
{
	new query[512];
 	format(query, sizeof(query), "UPDATE `accounts` SET VIP=%d, score=%d, money=%d, kills=%d, deaths=%d, seconds=%d, minutes=%d, hours=%d WHERE user='%s'", PlayerInfo[playerid][pVIP], GetPlayerScore(playerid), GetPlayerMoney(playerid), PlayerInfo[playerid][pKills], PlayerInfo[playerid][pDeaths], PlayerInfo[playerid][Seconds], PlayerInfo[playerid][Minutes], PlayerInfo[playerid][Hours], Name(playerid));
  	printf("User %s stats saved in database!", Name(playerid));
   	mysql_query(query);
}

stock IsPlayerVIP(playerid)
{
	if(PlayerInfo[playerid][pVIP] > 0)
	{
		return 1;
    }
	else return 0;
}

stock GivePlayerScore(playerid, score)
{
	SetPlayerScore(playerid, GetPlayerScore(playerid)+score);
	return 1;
}
                  
stock GiveVehicle(playerid,vehicleid)
{
	if(!IsPlayerInAnyVehicle(playerid))
	{
	    new Float:x, Float:y, Float:z, Float:angle;
	    if(LastVIPVehicle[playerid] != 0) DestroyVehicle(LastVIPVehicle[playerid]);
		GetPlayerPos(playerid, x, y, z);
	 	GetPlayerFacingAngle(playerid, angle);
	    new veh = CreateVehicle(vehicleid, x, y, z, angle, -1, -1, -1);
		SetVehicleVirtualWorld(veh, GetPlayerVirtualWorld(playerid));
		LinkVehicleToInterior(veh, GetPlayerInterior(playerid));
		PutPlayerInVehicle(playerid, veh, 0);
	}
	return 1;
}
stock Name(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

stock SendAdminMessage(color,string[])
{
    foreach(Player,i)
    {
		if(IsPlayerAdmin(i))//You can change this to your admin variables
		{
		    SendClientMessage(i, color, string);
		}
    }
}

stock GivePlayerMaxAmmo( playerid )
{
	new slot, weap, ammo;
	for (slot = 0; slot < 14; slot++)
	{
    	GetPlayerWeaponData( playerid, slot, weap, ammo );
		if (IsValidWeapon(weap))
		{
		   	GivePlayerWeapon(playerid,weap,99999);
		}
	}
	return 1;
}

stock IsValidWeapon(weaponid)
{
    if ( weaponid > 0 && weaponid < 19 || weaponid > 21 && weaponid < 47 && weaponid != 38) return 1;
    return 0;
}

stock ShowDialogHelp(playerid, helptype)
{
    new dialog[768];
    switch(helptype)
    {
		case VIP1:
		{
		    strcat(dialog,"{FFFFFF}..:: D.V.I.P {C71585}LV.1 commands{FFFFFF} ::..\n");
	        strcat(dialog,"\n");
	        strcat(dialog,"{C71585}V.I.P LV.1 -\n");
	        strcat(dialog,"{FFFFFF}------------------------\n");
	        strcat(dialog,"{99FF00}Use '$' in front of text, to talk in VIP chat.\n");
	        strcat(dialog,"{99FF00}/MyTime : Change your current time.\n");
	        strcat(dialog,"{99FF00}/VSpawn : You get spawned.\n");
	        strcat(dialog,"{99FF00}/VHeal : Get V.I.P Heal (once per death).\n");
	        strcat(dialog,"{99FF00}/Vnrg : Spawn an NRG.\n");
	        strcat(dialog,"{99FF00}/VHouse : Get teleported to V.I.P House (Club).\n");
	        strcat(dialog,"{99FF00}/vhleave : Leave V.I.P House.\n");
            strcat(dialog,"{99FF00}/VHot : Spawn a Hotknife.\n");
            strcat(dialog,"{99FF00}/Vtcars : Spawn tuned vehicles.\n");
            strcat(dialog,"{99FF00}/Vneon : Add neon to your vehicle.\n");
			strcat(dialog,"{99FF00}/VWeaps1 : Spawn the V.I.P LV.1 weapons.\n");
			ShowPlayerDialog(playerid, D_VIP, DIALOG_STYLE_MSGBOX, "-== VIP RANK COMMANDS ==-", dialog, "Close", "");
		}
		case VIP2:
  	    {
			strcat(dialog,"{FFFFFF}..:: D.V.I.P {C71585}LV.2 commands{FFFFFF} ::..\n");
	        strcat(dialog,"\n");
	        strcat(dialog,"{C71585}V.I.P LV.2 -\n");
	        strcat(dialog,"{FFFFFF}------------------------\n");
	        strcat(dialog,"{99FF00}With V.I.P LV.1 Features.\n");
	        strcat(dialog,"{99FF00}/Varmour : Get V.I.P Armour (once per death).\n");
	        strcat(dialog,"{99FF00}/Vinfer+/Vbullet : Spawn an Infernus / Spawns a Bullet.\n");
	        strcat(dialog,"{99FF00}/VNos  : Get V.I.P nos(Nitro).\n");
	        strcat(dialog,"{99FF00}/VJetpack : Spawn a Jetpack.\n");
	        strcat(dialog,"{99FF00}/VJetmax+/Vbmx+/VMonster+/Vsea : Spawn a different models of cars.\n");
	        strcat(dialog,"{99FF00}/Vannounce : Announce a message on players screen.\n");
            strcat(dialog,"{99FF00}/Vsay : Send a message to all players with V.I.P Tag.\n");
			strcat(dialog,"{99FF00}/Venf+/Vquad : Spawns an enfoncer / Spawns a quad.\n");
			strcat(dialog,"{99FF00}/VWeaps2 : Spawns the V.I.P LV.2 weapons package.\n");
			ShowPlayerDialog(playerid, D_VIP, DIALOG_STYLE_MSGBOX, "-== VIP RANK COMMANDS ==-", dialog, "Close", "");
    	}
		case VIP3:
		{
		    strcat(dialog,"{FFFFFF}..:: D.V.I.P {C71585}LV.3 commands{FFFFFF} ::..\n");
		    strcat(dialog,"\n");
	        strcat(dialog,"{C71585}V.I.P LV.3 -\n");
	        strcat(dialog,"{FFFFFF}------------------------\n");
            strcat(dialog,"{99FF00}With V.I.P LV.1 && V.I.P LV.2 Features.\n");
	        strcat(dialog,"{99FF00}/VSpecial : Your skin get a super-awesome look.\n");
	        strcat(dialog,"{99FF00}/VStophold : Remove the 'super-awesome' look.\n");
	        strcat(dialog,"{99FF00}/Vhunter+/Vhydra : Spawn a Hunter / Spawns a Hydra.\n");
	        strcat(dialog,"{99FF00}/Vskin : Change your skin to whatever skin you like.\n");
            strcat(dialog,"{99FF00}/VFix : Fix your damaged car and get full car health.\n");
			strcat(dialog,"{99FF00}/Venf+/Vquad : Spawns an enfoncer / Spawns a quad.\n");
			strcat(dialog,"{99FF00}/vMaxAmmo : Get full ammo of your current weapons.\n");
			strcat(dialog,"{99FF00}/VWeaps3 : Spawns the V.I.P LV.3 weapons package.\n");
	        ShowPlayerDialog(playerid, D_VIP, DIALOG_STYLE_MSGBOX, "-== VIP RANK COMMANDS ==-", dialog, "Close", "");
  		}
	}
	return 1;
}

                  /*********************
              *******V.I.P.Commands********
                  *********************/
                  
YCMD:vips(playerid,params[],help)
{
    new count = 0, dialogstring[576], namestring[96];
    foreach(new i: Player)
    {
        if(PlayerInfo[i][pVIP] > 0)
        {
            format(namestring, sizeof(namestring), "{FF0000}%s [ID: %d] ::{FF9900} VIP level - {FF0000}%d\n", Name(i), playerid, PlayerInfo[i][pVIP]);
            strcat(dialogstring, namestring);
            count ++;
		}
    }
    if(count != 0)
   	{
   		ShowPlayerDialog(playerid, D_VIP, DIALOG_STYLE_MSGBOX, "----==== Online VIPS ====----", dialogstring, "Close", "");
   	}
   	else ShowPlayerDialog(playerid, D_VIP, DIALOG_STYLE_MSGBOX, "----==== Online VIPS ====----", "No online VIPs!", "Close", "");
    return 1;
}

YCMD:setvip(playerid,params[],help)
{
	new targetid, level, string[128], sendername[MAX_PLAYER_NAME], giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "ui", targetid, level)) return SendClientMessage(playerid, C_RED, "[USAGE] /setvip <playerid> <level 0-3>");
	{
	    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, C_RED, "[SERVER] Player not connected.");
	    if(level < 0 || level > 3) return SendClientMessage(playerid, C_RED, "[SERVER] Cannot go under 0 or above 3.");
		if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, C_RED, "[ERROR] You are not authorised to use this command.");//You can change this to your admin variables
		
		PlayerInfo[targetid][pVIP] = level;
   		format(sendername, sizeof(sendername), "%s", Name(playerid));
      	format(giveplayer, sizeof(giveplayer), "%s", Name(targetid));
      	format(string, sizeof(string),"[VIP] %s has promoted %s to VIP level %d.", sendername, giveplayer, level);
		SendAdminMessage(C_CYAN, string);
		format(string, sizeof(string),"[VIP] %s has promoted you to VIP level %d.", sendername, level);
		SendClientMessage(targetid, C_CYAN, string);
	}
	return 1;
}

YCMD:vhelp(playerid,params[],help) return ShowPlayerDialog(playerid, D_VIP, DIALOG_STYLE_LIST, "-== V.I.P Help ==-", "V.I.P Rank 1\nV.I.P Rank 2\nV.I.P Rank 3", "Select", "Cancel");

// VIP LEVEL 1
//

YCMD:mytime(playerid,params[],help)
{
	new time, string[128];
	if(PlayerInfo[playerid][pVIP] > 0)
	{
    	if (sscanf(params,"d",time)) return SendClientMessage(playerid,C_RED,"[USAGE] /mytime <time>" );
		if ((time < 0) || (time > 24)) return SendClientMessage( playerid, C_RED, "The min value is 0 hours and the max is 24 hours!" );

  	    SetPlayerTime(playerid,time,0);
		format( string, sizeof( string ), "[VIP] Time set to {E60000}%d", time);
		SendClientMessage( playerid,C_CYAN,string);
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:1] command.");
	return 1;
}

YCMD:vspawn(playerid,params[],help)
{
	if(PlayerInfo[playerid][pVIP] > 0)
	{
    	SendClientMessage(playerid,C_CYAN,"[VIP] Spawned successfully.");
		SpawnPlayer(playerid);
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:1] command.");
	return 1;
}

YCMD:vheal(playerid,params[],help)
{
	if(PlayerInfo[playerid][pVIP] > 0)
	{
	    if(VIPHeal[playerid] == 1)
	    {
	        SendClientMessage(playerid, C_LIME, "[VIP] Health refilled!");
	        SetPlayerHealth(playerid, 99);
	        VIPHeal[playerid] = 0;
	    }
	    else return SendClientMessage(playerid, C_RED, "[ERROR] 1 Heal per death.");
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:1] command.");
	return 1;
}

YCMD:vnrg(playerid,params[],help)
{
    if(PlayerInfo[playerid][pVIP] > 0)
    {
        if(LastVIPVehicle[playerid] != 0) DestroyVehicle(LastVIPVehicle[playerid]);
        if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, C_RED, "[ERROR] You have a vehicle already.");

		new Float:XYZ[3], Float:Angle;
        GetPlayerPos(playerid, XYZ[0], XYZ[1], XYZ[2]);
        GetPlayerFacingAngle(playerid, Angle);
        new car = CreateVehicle(522, XYZ[0]+1.0, XYZ[1]+1.0, XYZ[2], Angle, 6, 6, -1);
        PutPlayerInVehicle(playerid, car, 0);
        LastVIPVehicle[playerid] = GetPlayerVehicleID(playerid);
        SendClientMessage(playerid,C_GREEN,"[VIP] NRG-500 spawned successfully");
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:1] command.");
	return 1;
}

YCMD:vhot(playerid,params[],help)
{
    if(PlayerInfo[playerid][pVIP] > 0)
    {
        if(LastVIPVehicle[playerid] != 0) DestroyVehicle(LastVIPVehicle[playerid]);
        if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, C_RED, "[ERROR] You have a vehicle already.");

		new Float:XYZ[3], Float:Angle;
        GetPlayerPos(playerid, XYZ[0], XYZ[1], XYZ[2]);
        GetPlayerFacingAngle(playerid, Angle);
        new car = CreateVehicle(434, XYZ[0]+1.0, XYZ[1]+1.0, XYZ[2], Angle, 6, 6, -1);
        PutPlayerInVehicle(playerid, car, 0);
        LastVIPVehicle[playerid] = GetPlayerVehicleID(playerid);
        SendClientMessage(playerid,C_GREEN,"[VIP] hotring spawned successfully.");
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:1] command.");
	return 1;
}

YCMD:vhouse(playerid,params[], help)
{
    if(PlayerInfo[playerid][pVIP] > 0)
    {
		if(IsInVHouse[playerid] == 0)
		{
            SetPlayerPos( playerid, -2637.69,1404.24,906.46 );
       	    SetPlayerInterior(playerid, 3);
    	    SendClientMessage( playerid, C_CYAN, "[VIP] Teleported to V.I.P club successfully. You can leave it (/vhleave)" );
    	    IsInVHouse[playerid] = 1;
    	}
    	else return SendClientMessage(playerid,C_RED,"[ERROR] You are already in Vhouse.");
    }
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:1] command.");
	return 1;
}

YCMD:vhleave(playerid,params[], help)
{
    if(PlayerInfo[playerid][pVIP] > 0)
    {
		if(IsInVHouse[playerid] == 1)
		{
            SpawnPlayer(playerid);
       	    SetPlayerInterior(playerid, 0);
    	    SendClientMessage( playerid, C_CYAN, "[VIP] left V.I.P club successfully." );
    	    IsInVHouse[playerid] = 0;
    	}
    	else return SendClientMessage(playerid,C_RED,"[ERROR] You are not in Vhouse.");
    }
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:1] command.");
	return 1;
}


YCMD:vneon(playerid,params[], help)
{
    if(PlayerInfo[playerid][pVIP] > 0)
    {
	  if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, C_RED, "[ERROR] You must be in vehicle to use this command.");
	  ShowPlayerDialog(playerid, D_NEON, DIALOG_STYLE_LIST, " .:: Neon Types ::.", "DarkBlue\nRed\nGreen\nWhite\nViolet\nYellow\nCyan\nLightBlue\nPink\nOrange\nLightGreen\nLightYellow\nNeonSpecial[Red]\nSpecial[Green]\nSpecial[Blue]\nDellete Neon", "Select", "Cancel");
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:1] command.");
	return 1;
}

YCMD:vtcars(playerid,params[], help)
{
    if(PlayerInfo[playerid][pVIP] > 0)
    {
	  if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, C_RED, "[ERROR] You have a vehicle already.");
	  else ShowPlayerDialog(playerid, D_TCAR, DIALOG_STYLE_LIST, " .:: Tuned Cars ::.", "Tuned Uranus\nTuned Sultan\nTuned Jester\nTuned Stratum\nTuned Stratum 2\nAlien\nTuned Elegy\nTuned Flash\nTuned Remington\nTuned Slamvan" , "Select", "Close");
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:1] command.");
	return 1;
}

YCMD:vweaps1(playerid,params[],help)
{
    if(PlayerInfo[playerid][pVIP] > 0)
    {
	  if(VIPWeaps[playerid] == 1)
		{
		  SendClientMessage(playerid, C_CYAN, "[VIP] LEVEL 1 V.I.P Weapons package spawned successfully");
		  GivePlayerWeapon(playerid,35 ,10);
		  GivePlayerWeapon(playerid,8 ,10);
		  GivePlayerWeapon(playerid,16 ,10);
		  GivePlayerWeapon(playerid,23 ,350);
		  GivePlayerWeapon(playerid,25 ,200);
		  GivePlayerWeapon(playerid,29 ,300);
		  GivePlayerWeapon(playerid,30 ,200);
		  GivePlayerWeapon(playerid,33 ,150);
		  GivePlayerWeapon(playerid,46 ,10);
		  VIPWeaps[playerid] = 0;
		}
      else return SendClientMessage(playerid, C_RED, "[ERROR] One weapons package per death.");
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:1] command.");
	return 1;
}

//
// VIP LEVEL 2
//


YCMD:varmour(playerid,params[],help)
{
    if(PlayerInfo[playerid][pVIP] > 1)
    {
		    if(VIPArmour[playerid] == 1)
	    	{
		        SendClientMessage(playerid, C_LIME, "[VIP] Armour refilled.");
		        SetPlayerArmour(playerid, 99);
		        VIPArmour[playerid] = 0;
	    	}
	    	else return SendClientMessage(playerid, C_RED, "[ERROR] One armour per death.");
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:2] command.");
	return 1;
}

YCMD:vinfer(playerid,params[],help)
{
    if(PlayerInfo[playerid][pVIP] > 1)
    {
        if(LastVIPVehicle[playerid] != 0) DestroyVehicle(LastVIPVehicle[playerid]);
        if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, C_RED,"[ERROR] You have a vehicle already.");

		new Float:XYZ[3], Float:Angle;
        GetPlayerPos(playerid, XYZ[0], XYZ[1], XYZ[2]);
        GetPlayerFacingAngle(playerid, Angle);
        new car = CreateVehicle(411, XYZ[0]+1.0, XYZ[1]+1.0, XYZ[2], Angle, 6, 6, -1);
        PutPlayerInVehicle(playerid, car, 0);
        LastVIPVehicle[playerid] = GetPlayerVehicleID(playerid);
        SendClientMessage(playerid,C_GREEN,"[VIP] Infernus spawned Successfully.");
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:2] command.");
	return 1;
}

YCMD:vbullet(playerid,params[],help)
{
    if(PlayerInfo[playerid][pVIP] > 1)
    {
        if(LastVIPVehicle[playerid] != 0) DestroyVehicle(LastVIPVehicle[playerid]);
        if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, C_RED, "[ERROR] You have a vehicle already.");

		new Float:XYZ[3], Float:Angle;
        GetPlayerPos(playerid, XYZ[0], XYZ[1], XYZ[2]);
        GetPlayerFacingAngle(playerid, Angle);
        new car = CreateVehicle(541, XYZ[0]+1.0, XYZ[1]+1.0, XYZ[2], Angle, 6, 6, -1);
        PutPlayerInVehicle(playerid, car, 0);
        LastVIPVehicle[playerid] = GetPlayerVehicleID(playerid);
        SendClientMessage(playerid,C_GREEN,"[VIP] Bullet spawned Successfully.");
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:2] command.");
	return 1;
}

YCMD:vnos(playerid,params[], help)
{
	if(PlayerInfo[playerid][pVIP] > 1)
	{
		new string[128];
		if (IsPlayerInAnyVehicle(playerid))
		{
			switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
			{
				case 417,425,430,432,441,446,435,448,449,452,453,454,457,460,461,462,463,468,469,471,472,473,476,481,487,
				488,497,509,510,511,512,513,519,520,521,522,523,537,538,539,548,553,563,569,570,577,581,586,592,593,595:
				return SendClientMessage(playerid,C_RED,"[ERROR] You can't add nitro to this types of vehicles.");
			}
			if(GetVehicleComponentInSlot(GetPlayerVehicleID(playerid),GetVehicleComponentType(1010)) == 1010)
			return SendClientMessage(playerid,C_RED,"[ERROR] You have nitro already.");
			format(string, sizeof(string),"[VIP] %s has added nitro to his vehicle.",Name(playerid));
			SendAdminMessage(C_CYAN,string);
	        AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
		    PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
		}
		else return SendClientMessage(playerid, C_RED,"[ERROR] You must be inside a vehicle to use this command.");
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:2] command.");
	return 1;
}

YCMD:vjetmax(playerid,params[], help)
{
    if(PlayerInfo[playerid][pVIP] > 1)
    {
        if(LastVIPVehicle[playerid] != 0) DestroyVehicle(LastVIPVehicle[playerid]);
        if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, C_RED, "[ERROR] You have a vehicle already.");

		new Float:XYZ[3], Float:Angle;
        GetPlayerPos(playerid, XYZ[0], XYZ[1], XYZ[2]);
        GetPlayerFacingAngle(playerid, Angle);
        new car = CreateVehicle(493, XYZ[0]+1.0, XYZ[1]+1.0, XYZ[2], Angle, 6, 6, -1);
        PutPlayerInVehicle(playerid, car, 0);
        LastVIPVehicle[playerid] = GetPlayerVehicleID(playerid);
        SendClientMessage(playerid,C_GREEN,"[VIP] Jetmax spawned successfully.");
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:2] command.");
	return 1;
}

YCMD:vjetpack(playerid,params[], help)
{
    if(PlayerInfo[playerid][pVIP] > 1)
    {
		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USEJETPACK);
        SendClientMessage(playerid,C_GREEN,"[VIP] Jet-Pack spawned successfully.");
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:2] command.");
	return 1;
}

YCMD:vbmx(playerid,params[], help)
{
    if(PlayerInfo[playerid][pVIP] > 1)
    {
        if(LastVIPVehicle[playerid] != 0) DestroyVehicle(LastVIPVehicle[playerid]);
        if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, C_RED, "[ERROR] You have a vehicle already.");

		new Float:XYZ[3], Float:Angle;
        GetPlayerPos(playerid, XYZ[0], XYZ[1], XYZ[2]);
        GetPlayerFacingAngle(playerid, Angle);
        new car = CreateVehicle(493, XYZ[0]+1.0, XYZ[1]+1.0, XYZ[2], Angle, 6, 6, -1);
        PutPlayerInVehicle(playerid, car, 0);
        LastVIPVehicle[playerid] = GetPlayerVehicleID(playerid);
        SendClientMessage(playerid,C_GREEN,"[VIP] BMX spawned successfully.");
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:2] command.");
	return 1;
}

YCMD:vmonster(playerid,params[], help)
{
    if(PlayerInfo[playerid][pVIP] > 1)
    {
        if(LastVIPVehicle[playerid] != 0) DestroyVehicle(LastVIPVehicle[playerid]);
        if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, C_RED, "[ERROR] You have a vehicle already.");

		new Float:XYZ[3], Float:Angle;
        GetPlayerPos(playerid, XYZ[0], XYZ[1], XYZ[2]);
        GetPlayerFacingAngle(playerid, Angle);
        new car = CreateVehicle(557, XYZ[0]+1.0, XYZ[1]+1.0, XYZ[2], Angle, 6, 6, -1);
        PutPlayerInVehicle(playerid, car, 0);
        LastVIPVehicle[playerid] = GetPlayerVehicleID(playerid);
        SendClientMessage(playerid,C_GREEN,"[VIP] Monster spawned successfully.");
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:2] command.");
	return 1;
}

YCMD:vsea(playerid,params[], help)
{
    if(PlayerInfo[playerid][pVIP] > 1)
    {
        if(LastVIPVehicle[playerid] != 0) DestroyVehicle(LastVIPVehicle[playerid]);
        if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, C_RED, "[ERROR] You have a vehicle already.");

		new Float:XYZ[3], Float:Angle;
        GetPlayerPos(playerid, XYZ[0], XYZ[1], XYZ[2]);
        GetPlayerFacingAngle(playerid, Angle);
        new car = CreateVehicle(447, XYZ[0]+1.0, XYZ[1]+1.0, XYZ[2], Angle, 6, 6, -1);
        PutPlayerInVehicle(playerid, car, 0);
        LastVIPVehicle[playerid] = GetPlayerVehicleID(playerid);
        SendClientMessage(playerid,C_GREEN,"[VIP] Seasporrow spawned successfully.");
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:2] command.");
	return 1;
}

YCMD:vannounce(playerid,params[],help)
{
    if(PlayerInfo[playerid][pVIP] > 1)
    {
        new string[128], message[64], targetid;
        if(sscanf(params, "us[128]", targetid, message)) return SendClientMessage(playerid, C_RED, "[USAGE] /vannounce <playerid> <message>");
        format(string, sizeof(string),"~r~VIP~w~]%s: %s", Name(playerid), message);
	    GameTextForPlayer(targetid, string, 2500, 3);
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:2] command.");
	return 1;
}

YCMD:vsay(playerid,params[],help)
{
    if(PlayerInfo[playerid][pVIP] > 1)
    {
        new string[128];
        if(isnull(params)) return SendClientMessage(playerid, C_RED, "[USAGE] /vsay <Text>");
        format(string, sizeof(string), "|**~~V.I.P %s ~~**| %s", Name(playerid), params[0] );
        SendClientMessageToAll(C_CYAN,string);
    }
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:2] command.");
	return 1;
}


YCMD:venf(playerid,params[],help)
{
    if(PlayerInfo[playerid][pVIP] > 1)
    {
        if(LastVIPVehicle[playerid] != 0) DestroyVehicle(LastVIPVehicle[playerid]);
        if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, C_RED, "[ERROR] You have a vehicle already.");

		new Float:XYZ[3], Float:Angle;
        GetPlayerPos(playerid, XYZ[0], XYZ[1], XYZ[2]);
        GetPlayerFacingAngle(playerid, Angle);
        new car = CreateVehicle(427, XYZ[0]+1.0, XYZ[1]+1.0, XYZ[2], Angle, 6, 6, -1);
        PutPlayerInVehicle(playerid, car, 0);
        LastVIPVehicle[playerid] = GetPlayerVehicleID(playerid);
        SendClientMessage(playerid,C_GREEN,"[VIP] Enfoncer spawned successfully.");
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:2] command.");
	return 1;
}

YCMD:vquad(playerid,params[],help)
{
    if(PlayerInfo[playerid][pVIP] > 1)
    {
        if(LastVIPVehicle[playerid] != 0) DestroyVehicle(LastVIPVehicle[playerid]);
        if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, C_RED, "[ERROR] You have a vehicle already.");

		new Float:XYZ[3], Float:Angle;
        GetPlayerPos(playerid, XYZ[0], XYZ[1], XYZ[2]);
        GetPlayerFacingAngle(playerid, Angle);
        new car = CreateVehicle(471, XYZ[0]+1.0, XYZ[1]+1.0, XYZ[2], Angle, 6, 6, -1);
        PutPlayerInVehicle(playerid, car, 0);
        LastVIPVehicle[playerid] = GetPlayerVehicleID(playerid);
        SendClientMessage(playerid,C_GREEN,"[VIP] Enfoncer spawned successfully.");
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:2] command.");
	return 1;
}

YCMD:vweaps2(playerid,params[],help)
{
    if(PlayerInfo[playerid][pVIP] > 1)
    {
	  if(VIPWeaps[playerid] == 1)
		{
		  SendClientMessage(playerid, C_CYAN, "[VIP] LEVEL 2 V.I.P Weapons package spawned successfully.");
		  GivePlayerWeapon(playerid,9 ,10);
		  GivePlayerWeapon(playerid,18 ,10);
		  GivePlayerWeapon(playerid,24 ,200);
		  GivePlayerWeapon(playerid,27 ,250);
		  GivePlayerWeapon(playerid,28 ,300);
		  GivePlayerWeapon(playerid,31 ,200);
		  GivePlayerWeapon(playerid,34 ,100);
		  GivePlayerWeapon(playerid,35 ,100);
		  GivePlayerWeapon(playerid,41 ,200);
		  GivePlayerWeapon(playerid,46 ,10);
		  VIPWeaps[playerid] = 0;
		}
      else return SendClientMessage(playerid, C_RED, "[ERROR] One weapons package per death.");
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:2] command.");
	return 1;
}

//
// VIP LEVEL 3
//

YCMD:changename(playerid,params[],help)
{
    if(PlayerInfo[playerid][pVIP] > 2)
    {
        new newname[24],reason[105];
        if(sscanf(params, "s[24]s[105]",newname,reason)) return SendClientMessage(playerid,C_RED,"[USAGE] /changename [New Name] [Reason]");
        new escapename[24], Query[128];
        mysql_real_escape_string(newname, escapename);
        format(Query, sizeof(Query), "SELECT `user` FROM `accounts` WHERE `user` = '%s' LIMIT 1", escapename);
        mysql_query(Query);
        mysql_store_result();
        new rows = mysql_num_rows();
        if(!rows)
        {
			new zmstring[128];
			format(Query, sizeof(Query), "UPDATE `accounts` SET `user`= '%s' WHERE `user` ='%s'",escapename,Name(playerid));
            mysql_query(Query);
            SetPlayerName(playerid,escapename);
            format(zmstring,sizeof(zmstring),"[VIP] {FF0000}%s {FFFFFF}has changed {FFFFFF}his name to {FFFFFF}%s [Reason: %s]",Name(playerid),newname, reason);
            SendClientMessage(playerid,-1,zmstring);
        }
        else if(rows == 1)
        {
            SendClientMessage(playerid, C_RED, "[ERROR] This name already exists!");
        }
        mysql_free_result();
    }
    else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:2] command.");
    return 1;
}

YCMD:vspecial(playerid,params[], help)
{
	if(PlayerInfo[playerid][pVIP] > 2)
    {
        ShowPlayerDialog( playerid, VSPECIAL, DIALOG_STYLE_LIST, "V.I.P Special Actions!", "Hold: Dick!\nHold: Iron!\nHold: Alien!\nHold: Incred!", "Select", "Cancel" );
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:3] command.");
	return 1;
}

YCMD:stophold(playerid,params[], help)
{
	if(PlayerInfo[playerid][pVIP] > 2)
    {
        if( !IsPlayerAttachedObjectSlotUsed( playerid, 0  ) &&
    	    !IsPlayerAttachedObjectSlotUsed( playerid, 1  ) &&
	        !IsPlayerAttachedObjectSlotUsed( playerid, 2  ) &&
	        !IsPlayerAttachedObjectSlotUsed( playerid, 3  ) &&
	        !IsPlayerAttachedObjectSlotUsed( playerid, 4  ) )
	    	return SendClientMessage( playerid, C_RED, "[ERROR] Not holding any object." );

    	for ( new i = 0; i < 5; i ++ )
	    {
    		if ( IsPlayerAttachedObjectSlotUsed( playerid, i ) )
    		{
    			RemovePlayerAttachedObject( playerid, i );
    			SendClientMessage( i, C_CYAN, "[VIP] Stopped holding object(s)." );
    		}
    	}
    }
 	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:3] command.");
	return 1;
}


YCMD:vhunter(playerid,params[], help)
{
    if(PlayerInfo[playerid][pVIP] > 2)
    {
        if(LastVIPVehicle[playerid] != 0) DestroyVehicle(LastVIPVehicle[playerid]);
        if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, C_RED, "[ERROR] You have a vehicle already.");

		new Float:XYZ[3], Float:Angle;
        GetPlayerPos(playerid, XYZ[0], XYZ[1], XYZ[2]);
        GetPlayerFacingAngle(playerid, Angle);
        new car = CreateVehicle(425, XYZ[0]+1.0, XYZ[1]+1.0, XYZ[2], Angle, 6, 6, -1);
        PutPlayerInVehicle(playerid, car, 0);
        LastVIPVehicle[playerid] = GetPlayerVehicleID(playerid);
        SendClientMessage(playerid,C_GREEN,"[VIP] Hunter spawned successfully.");
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:3] command.");
	return 1;
}

YCMD:vhydra(playerid,params[], help)
{
    if(PlayerInfo[playerid][pVIP] > 2)
    {
        if(LastVIPVehicle[playerid] != 0) DestroyVehicle(LastVIPVehicle[playerid]);
        if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, C_RED, "[ERROR] You have a vehicle already.");

		new Float:XYZ[3], Float:Angle;
        GetPlayerPos(playerid, XYZ[0], XYZ[1], XYZ[2]);
        GetPlayerFacingAngle(playerid, Angle);
        new car = CreateVehicle(520, XYZ[0]+1.0, XYZ[1]+1.0, XYZ[2], Angle, 6, 6, -1);
        PutPlayerInVehicle(playerid, car, 0);
        LastVIPVehicle[playerid] = GetPlayerVehicleID(playerid);
        SendClientMessage(playerid,C_GREEN,"[VIP] Hydra spawned successfully.");
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:3] command.");
	return 1;
}


YCMD:vskin(playerid,params[],help)
{
	if(PlayerInfo[playerid][pVIP] > 2)
	{
		new string[128], skinid;
		if(sscanf(params, "i", skinid)) return SendClientMessage(playerid, C_RED, "[USAGE] /dskin <Skin-ID>");
		if(skinid < 0 || skinid > 299) return SendClientMessage(playerid, C_RED, "[ERROR] Skins ID 0-299 only.");

		SetPlayerSkin(playerid, skinid);
		format(string, sizeof(string), "[VIP] Skin changed to ID: %d!", skinid);
		SendClientMessage(playerid, C_LIME, string);
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:3] command.");
	return 1;
}

YCMD:vfix(playerid,params[],help)
{
    if(PlayerInfo[playerid][pVIP] > 2)
    {
        if(VIPFix[playerid] == 1)
        {
        	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, C_RED, "[ERROR] You are not in any vehicle.");
        	RepairVehicle(GetPlayerVehicleID(playerid));
        	SendClientMessage(playerid, C_LIME, "[VIP] Car repaired.");
            SetTimerEx("VIPFixTimer", 1000*60*5, false, "i", playerid);
        	VIPFix[playerid] = 0;
		}
		else
		{
		    SendClientMessage(playerid, C_RED, "[ERROR] Wait for 5 mins.");
		}
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:3] command.");
	return 1;
}

YCMD:vweaps3(playerid,params[],help)
{
    if(PlayerInfo[playerid][pVIP] > 2)
    {
	  if(VIPWeaps[playerid] == 1)
		{
		  SendClientMessage(playerid, C_CYAN, "[VIP] LEVEL 3 V.I.P Weapons package spawned successfully.");
          GivePlayerWeapon(playerid,1 ,10);
		  GivePlayerWeapon(playerid,24 ,300);
		  GivePlayerWeapon(playerid,39 ,50);
		  GivePlayerWeapon(playerid,26 ,500);
		  GivePlayerWeapon(playerid,31 ,700);
		  GivePlayerWeapon(playerid,34 ,500);
		  GivePlayerWeapon(playerid,35 ,300);
		  GivePlayerWeapon(playerid,28 ,400);
		  GivePlayerWeapon(playerid,41 ,200);
		  GivePlayerWeapon(playerid,46 ,10);
		  VIPWeaps[playerid] = 0;
		}
        else return SendClientMessage(playerid, C_RED, "[ERROR] One weapons package per death.");
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:3] command.");
	return 1;
}

YCMD:vmaxammo(playerid,params[], help)
{
	if(PlayerInfo[playerid][pVIP] > 2)
    {
	   GivePlayerMaxAmmo(playerid);
	   SendClientMessage(playerid,C_CYAN,"[VIP] Max-Ammo was spawned successfully.");
	}
	else return SendClientMessage(playerid,C_RED,"[ERROR] This is V.I.P's[LV:3] command.");
	return 1;
}

//Hey, you've just used my script you're welcomed to join our forums, http://bfww-samp.tk
