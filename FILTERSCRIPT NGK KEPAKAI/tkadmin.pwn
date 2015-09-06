//Started 1st July 6:20 PM by [HiC]TheKiller
//___________________________________________
//Build 1.5 10/10/2011
//This requires G-sTyLeZzZ MySQL plugin.
//This script also requires sscanf2 by Yless, thanks Yless!
//I'm using DCMD instead of ZCMD ;).

//Includes
#include <a_samp>
#include <a_mysql> //http://forum.sa-mp.com/showthread.php?t=56564
#include <sscanf2> //http://forum.sa-mp.com/showthread.php?t=120356
#include <foreach> //http://forum.sa-mp.com/showthread.php?t=92679
#include <zcmd> //http://forum.sa-mp.com/showthread.php?t=91354
native WP_Hash(buffer[], len, const str[]);
//Configure the following variables
#define SQL_HOST "localhost"
#define SQL_USER "root"
#define SQL_PASS ""
#define SQL_DB "grex"
#define DIALOG_REPORTS 1000
#define DIALOG_MUTES 1500
#define DIALOG_ADMINS 2000
#define DIALOG_KICK 2500
#define DIALOG_BAN 3000
#define DIALOG_BANNED 3500
//===============================

//Macro's
#define mysql_fetch_row(%1) mysql_fetch_row_format(%1,"|")
#define GetAdminLevel(%1) GetPVarInt(%1, "AdminLevel")
#define SendErrorMessage(%1,%2) SendClientMessage(%1,0xFF0000AA,%2)
#define levelerror(%1) if(GetAdminLevel(playerid)<%1) return SendErrorMessage(playerid, "Youre admin level is too low to use this command!")
#define stringempty(%1) format(%1,sizeof(%1), "")
//===============================

//Global Vars
new Query[500];
new line[750];
new Pname[24];
new PIP[18];
new escpass[100];
new string[200];
new estring[200];
new largestring[400];
new plid;
new Float:posxx[3];

//Temporary strings
new reports[5][100];
new reportnumber;

public OnFilterScriptInit()
{
    new
        buf[129];
    WP_Hash(buf, sizeof (buf), "The quick brown fox jumps over the lazy dog");
	for(new x = 0; x < 3; x++)
	{
	    if(!mysql_connect(SQL_HOST, SQL_USER, SQL_DB, SQL_PASS)) printf("MySQL connection attempt %d failed!", x);
	    else break;
	}
	mysql_debug(1);
    return 1;
}

public OnFilterScriptExit()
{
	mysql_close();
	return 1;
}

public OnPlayerConnect(playerid)
{
	bancheck(playerid);
	GetPlayerIp(playerid, PIP, 18);
	format(Query, sizeof(Query), "SELECT * FROM `playerinfo` WHERE `user` = '%s' LIMIT 1", escpname(playerid), PIP);
 	mysql_query(Query);
 	mysql_store_result();
 	if(mysql_num_rows() != 0)
	{
 		new PIP2[18];
   		mysql_fetch_field_row(PIP2, "IP");
	    if(!strcmp(PIP, PIP2, true) && strlen(PIP2) != 0)
	    {
    		SetPVarInt(playerid, "Logged", 1);
     		SendClientMessage(playerid, 0x009600AA, "Auto Logged in!");
      		if(mysql_fetch_row(line))
       		{
        		new data[3][55];
         		new data2[5];
          		sscanf(line, "p<|>s[50]s[300]dddds[50]ds[100]", data[0], largestring, data2[0], data2[1], data2[2], data2[3], data[2], data2[4], estring);
			   	stringempty(estring);
			   	stringempty(largestring);
      			SetPVarInt(playerid, "Kills", data2[0]);
      			SetPVarInt(playerid, "Logged", 1);
      			SetPVarInt(playerid, "Deaths", data2[1]);
      			SetPlayerScore(playerid, data2[2]);
      			GivePlayerMoney(playerid, data2[3]);
      			SetPVarInt(playerid, "AdminLevel", data2[4]);
      			mysql_free_result();
   			}
   		}
   		else
  		{
    		SendClientMessage(playerid, 0x009600AA, "This account is registered, please login");
			ShowPlayerDialog(playerid, 15000, DIALOG_STYLE_INPUT , "Login", "This account is registered, please login", "OK", "Cancel");
		}
	}
	else
	{
	    ShowPlayerDialog(playerid, 14600, DIALOG_STYLE_INPUT , "Register", "This account is not registered, please register!", "OK", "Cancel");
		SendClientMessage(playerid, 0x009600AA, "This account is not registered, please register!");
 	}
 	mysql_free_result();
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 14600)
    {
       if(response)
       {
            if(!strlen(inputtext))
            {
                ShowPlayerDialog(playerid, 14600, DIALOG_STYLE_INPUT , "Register", "This account is not registered, please register!", "OK", "Cancel");
                SendClientMessage(playerid, 0xF60000AA, "Please enter a password");
            }
            mysql_real_escape_string(inputtext, escpass);
			WP_Hash(largestring, sizeof(largestring), escpass);
            GetPlayerIp(playerid, PIP, 50); 
            format(Query, sizeof(Query), "INSERT INTO `playerinfo` (`user`, `password`, `kills`, `deaths`, `score`, `money`, `IP`, `adminlvl`) VALUES ('%s', '%s', 0, 0, 0, 0, '%s', 0)", escpname(playerid), largestring, PIP);
            mysql_query(Query); 
            GameTextForPlayer(playerid, "~g~Registered", 2000, 3);
            SendClientMessage(playerid, 0x0000D9AA, "Registered and Logged into your account!");
            SetPVarInt(playerid, "Logged", 1);
        }
    }
    if(dialogid == 15000)
    {
       if(response)
       {
           WP_Hash(largestring, sizeof(largestring), inputtext);
           format(Query, sizeof(Query), "SELECT * FROM `playerinfo` WHERE `user` = '%s' AND `password` = '%s' LIMIT 1", escpname(playerid), largestring);
           mysql_query(Query);
           mysql_store_result();
           new rows = mysql_num_rows();
           if(!rows)
           {
               SendClientMessage(playerid, 0xF60000AA, "Invalid password!");
               SetPVarInt(playerid, "WrongPass", GetPVarInt(playerid, "WrongPass") + 1);
               ShowPlayerDialog(playerid, 15000, DIALOG_STYLE_INPUT , "Login", "This account is registered, please login", "OK", "Cancel");
               if(GetPVarInt(playerid, "WrongPass") == 3)
               {
                   SendClientMessage(playerid, 0xF60000AA, "Max password tries exceeded!!");
                   Kick(playerid);
               }
               mysql_free_result();
           }
           else if(rows > 0)
           {
               if(mysql_fetch_row(line))
               {
                   	new data[3][55];
         			new data2[5];
          			sscanf(line, "p<|>s[50]s[300]dddds[50]ds[100]", data[0], largestring, data2[0], data2[1], data2[2], data2[3], data[2], data2[4], estring);
			   		stringempty(estring);
			   		stringempty(largestring);
      				SetPVarInt(playerid, "Kills", data2[0]);
      				SetPVarInt(playerid, "Logged", 1);
      				SetPVarInt(playerid, "Deaths", data2[1]);
      				SetPlayerScore(playerid, data2[2]);
      				GivePlayerMoney(playerid, data2[3]);
      				SetPVarInt(playerid, "AdminLevel", data2[4]);
                   	SendClientMessage(playerid, 0x0000D9AA, "Logged in!");
                   	mysql_free_result();
                   	GetPlayerIp(playerid, PIP, 18);
                   	format(Query, sizeof(Query), "UPDATE `playerinfo` SET IP = '%s' WHERE user='%s'", PIP, escpname(playerid));
				    mysql_query(Query);
			   }
		   }
       }
    }
    return 1;
}

public OnPlayerRequestSpawn(playerid)
{
    if(GetPVarInt(playerid, "Logged") == 0)
    {
        format(Query, sizeof(Query), "SELECT `user` FROM `playerinfo` WHERE `user` = '%s' LIMIT 1" , escpname(playerid));
        mysql_query(Query); 
        mysql_store_result(); 
        if(!mysql_num_rows()) ShowPlayerDialog(playerid, 14600, DIALOG_STYLE_INPUT , "Register", "This account is not registered, please register!", "OK", "Cancel"); 
        else ShowPlayerDialog(playerid, 15000, DIALOG_STYLE_INPUT , "Login", "This account is registered, please login", "OK", "Cancel");
        return 0; 
    }
    return 1;
}

public OnPlayerSpawn(playerid)
{
    if(GetPVarInt(playerid, "Logged") == 1 && GetPVarInt(playerid, "MoneyGiven") > 0)
    {
        GivePlayerMoney(playerid, GetPVarInt(playerid, "MoneyGiven"));
        SetPVarInt(playerid, "MoneyGiven", 0);
    }
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    SetPVarInt(playerid, "Deaths", GetPVarInt(playerid, "Deaths") + 1);
    if(killerid != INVALID_PLAYER_ID) SetPVarInt(playerid, "Kills", GetPVarInt(playerid, "Kills") + 1); 
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if(GetPVarInt(playerid, "Logged") == 1) 
    {
        format(Query, sizeof(Query), "UPDATE `playerinfo` SET `score` = '%d',`money` = '%d', `kills` = '%d', `deaths` = '%d'  WHERE `user` = '%s'", GetPlayerScore(playerid), GetPlayerMoney(playerid), GetPVarInt(playerid, "Kills"), GetPVarInt(playerid, "Deaths"), escpname(playerid));
		mysql_query(Query);
    }
    return 1;
}

CMD:admins(playerid, params[])
{
    new count;
   	foreach(Player, i)
    {
	    if(!PlayerAdmin(i)) continue;
		count++;
		if(strlen(largestring) != 0) format(largestring, sizeof(largestring), "%s \r\n%s(%d) - Level (%d)", largestring, PlayerName(i), i, GetAdminLevel(i));
		else format(largestring, sizeof(largestring), "%s(%d) - Level (%d)", PlayerName(i), i, GetAdminLevel(i));
	}
	if(count == 0) return SendClientMessage(playerid, 0xFF0000, "No admins online!");
	else ShowPlayerDialog(playerid, DIALOG_ADMINS, DIALOG_STYLE_MSGBOX, "Admins", largestring, "Ok", "Cancel");
	stringempty(largestring);
	return 1;
}

CMD:makeadmin(playerid, params[])
{
    if(GetPVarInt(playerid, "AdminLevel") == 5) return SendErrorMessage(playerid, "You are already max level!");
	format(Query, sizeof(Query), "UPDATE `playerinfo` SET `adminlvl` = 5  WHERE `user` = '%s'", escpname(playerid));
	mysql_query(Query);
	mysql_free_result();
	SetPVarInt(playerid, "AdminLevel", 5);
	SendClientMessage(playerid, 0xCC00FF, "You have set {CC00FF}yourself{FFFFFF} to level 5 admin");
	return 1;
}

CMD:score(playerid, params[])
{
	SetPlayerScore(playerid, 10000);
	GivePlayerMoney(playerid, 1000000);
	return 1;
}

CMD:reports(playerid, params[])
{
	levelerror(1);
	if(!strlen(reports[0])) return SendClientMessage(playerid, 0xFF0000AA, "There have been no reports");
	for(new x; x<5; x++)
	{
	    if(strlen(reports[x]) != 0)
	    {
	        format(largestring, sizeof(largestring), "%s \r\n%s", largestring, reports[x][7]);
	    }
	}
	ShowPlayerDialog(playerid, DIALOG_REPORTS, DIALOG_STYLE_MSGBOX, "Last five reported Players", largestring, "Ok", "Cancel");
 	stringempty(largestring);
  	return 1;
}

CMD:muted(playerid, params[])
{
	levelerror(1);
	foreach(Player, i)
	{
		if(GetPVarInt(i, "Muted") == 1)
		plid++;
		format(largestring, sizeof(largestring), "%s \r\n %s(%d)", largestring, PlayerName(i), i);
	}
	if(plid == 0) return SendErrorMessage(playerid, "Nobody is currently muted!");
	else ShowPlayerDialog(playerid, DIALOG_MUTES, DIALOG_STYLE_MSGBOX, "Muted Players", largestring, "Ok", "Cancel");
	stringempty(largestring);
	return 1;
}

CMD:acmds(playerid, params[])
{
	levelerror(1);
	if(GetAdminLevel(playerid) == 1) SendClientMessage(playerid, 0xCC00FF, "Level 1: {FFFFFF} /reports, /muted, /acmds, admin chat (#)");
	if(GetAdminLevel(playerid) == 2)
	{
 		SendClientMessage(playerid, 0xCC00FF, "Level 1: {FFFFFF} /reports, /muted, /acmds, admin chat (#)");
   		SendClientMessage(playerid, 0xCC00FF, "Level 2: {FFFFFF} /ip, /akill, /slap, /mute, /unmute");
	}
	if(GetAdminLevel(playerid) == 3)
	{
	    SendClientMessage(playerid, 0xCC00FF, "Level 1: {FFFFFF} /reports, /muted, /acmds, admin chat (#)");
	    SendClientMessage(playerid, 0xCC00FF, "Level 2: {FFFFFF} /ip, /akill, /slap, /mute, /unmute");
     	SendClientMessage(playerid, 0xCC00FF, "Level 3: {FFFFFF} /explode, /goto, /freeze, /unfreeze, /vkill, /kick");
	}
	if(GetAdminLevel(playerid) == 4)
	{
 		SendClientMessage(playerid, 0xCC00FF, "Level 1: {FFFFFF} /reports, /muted, /acmds, admin chat (#)");
 		SendClientMessage(playerid, 0xCC00FF, "Level 2: {FFFFFF} /ip, /akill, /slap, /mute, /unmute");
 		SendClientMessage(playerid, 0xCC00FF, "Level 3: {FFFFFF} /explode, /goto, /freeze, /unfreeze, /vkill, /kick");
 		SendClientMessage(playerid, 0xCC00FF, "Level 4: {FFFFFF} /get, /ban, /unban");
	}
	if(GetAdminLevel(playerid) == 5)
	{
 		SendClientMessage(playerid, 0xCC00FF, "Level 1: {FFFFFF} /reports, /muted, /acmds, admin chat (#)");
 		SendClientMessage(playerid, 0xCC00FF, "Level 2: {FFFFFF} /ip, /akill, /slap, /mute, /unmute");
 		SendClientMessage(playerid, 0xCC00FF, "Level 3: {FFFFFF} /explode, /goto, /freeze, /unfreeze, /vkill, /kick");
 		SendClientMessage(playerid, 0xCC00FF, "Level 4: {FFFFFF} /get, /ban, /unban");
 		SendClientMessage(playerid, 0xCC00FF, "Level 5: {FFFFFF} /setlevel");
	}
	return 1;
}


public OnPlayerText(playerid, text[])
{
	if(PlayerAdmin(playerid) && text[0] == '#')
	{
	    format(string, sizeof(string), "%s(%d): %s", PlayerName(playerid), playerid, text[1]);
	    SendMessageToAllAdmins(string, 0xCC00FF);
	    return 0;
	}
	if(GetPVarInt(playerid, "muted") == 1)
	{
	    SendErrorMessage(playerid, "You are muted, you cannot talk.");
	    return 0;
	}
	return 1;
}

CMD:changepass(playerid, params[])
{
	if (!strlen(params)) return SendErrorMessage(playerid, "Usage: /changepass <password>");
	if (GetPVarInt(playerid, "Logged") != 1) return SendErrorMessage(playerid, "You are not logged in!");
	if (strlen(params) > 99) return SendErrorMessage(playerid, "Password must be between 1 - 100 characters!");
	WP_Hash(largestring, sizeof(largestring), params);
	format(Query, sizeof(Query), "UPDATE `playerinfo` SET `password` = '%s'  WHERE `user` = '%s'", largestring , escpname(playerid));
	mysql_query(Query);
 	mysql_free_result();
 	SendClientMessage(playerid, 0xFFFFFF, "Password has been saved!");
	return 1;
}

CMD:setlevel(playerid, params[])
{
	new Level;
	levelerror(5);
	if(sscanf(params, "ud", plid, Level)) return SendErrorMessage(playerid, "Usage: /setlevel <id> <level>");
	if (Level < 0 || Level > 5) return SendErrorMessage(playerid, "Admin levels are between 1 - 5");
	format(Query, sizeof(Query), "UPDATE `playerinfo` SET `adminlvl` = %d  WHERE `user` = '%s'", Level, escpname(plid));
	mysql_query(Query);
 	mysql_free_result();
 	format(string, sizeof(string), "You have set {FF00AA}%s(%d){FFFFFF} admin level to %d", PlayerName(plid), plid, Level);
 	SendClientMessage(playerid, 0xFFFFFF, string);
	if(GetPVarInt(plid, "AdminLevel") < Level) format(string, sizeof(string), "You have been {CC00FF}promoted{FFFFFF} to level %d admin by admin %s(%d)", Level, PlayerName(playerid), playerid);
    if(GetPVarInt(plid, "AdminLevel") > Level) format(string, sizeof(string), "You have been {FF00AA}demoted{FFFFFF} to level %d admin by admin %s(%d)", Level, PlayerName(playerid), playerid);
	SendClientMessage(plid, 0xFFFFFF, string);
	SetPVarInt(plid, "AdminLevel", Level);
	return 1;
}

CMD:setemail(playerid, params[])
{
	if (!strlen(params)) return SendErrorMessage(playerid, "Usage: /setemail <email>");
	if (GetPVarInt(playerid, "Logged") != 1) return SendErrorMessage(playerid, "You are not logged in!");
	if (strlen(params) > 149 || strlen(params) < 5) return SendErrorMessage(playerid, "Email must be between 5 - 150 characters!");
	format(Query, sizeof(Query), "UPDATE `playerinfo` SET `email` = '%s'  WHERE `user` = '%s'", escstring(params) , escpname(playerid));
	mysql_query(Query);
 	mysql_free_result();
 	SendClientMessage(playerid, 0xFFFFFF, "Email has been saved!");
	return 1;
}

CMD:ip(playerid, params[])
{
	levelerror(2);
	if (!strlen(params)) return SendErrorMessage(playerid, "Usage: /ip <id>");
	plid = strval(params);
	if (!IsPlayerConnected(plid)) return SendErrorMessage(playerid, "Player Not Connected!");
	GetPlayerIp(plid, PIP, sizeof(PIP));
	format(string, sizeof(string), "IP of %s: {FFFFFF}%s", PlayerName(plid), PIP);
	SendClientMessage(playerid, 0x66FF33, string);
	return 1;
}

CMD:akill(playerid, params[])
{
	levelerror(2);
	if (!strlen(params)) return SendErrorMessage(playerid, "Usage: /kill <id>");
	plid = strval(params);
	if (!IsPlayerConnected(plid)) return SendErrorMessage(playerid, "Player Not Connected!");
	SetPlayerHealth(plid, 0);
	format(string, sizeof(string), "You have been killed by admin {FFFFFF}%s(%d)", PlayerName(playerid), playerid);
	SendErrorMessage(plid, string);
	format(string, sizeof(string), "You have killed {FFFFFF}%s(%d)", PlayerName(plid), plid);
	SendClientMessage(playerid, 0x66FF33, string);
	return 1;
}

CMD:vkill(playerid, params[])
{
	levelerror(3);
	if (!strlen(params)) return SendErrorMessage(playerid, "Usage: /vkill <vid>");
	plid = strval(params);
	format(string, sizeof(string), "You have destroyed vehicle ID {FFFFFF}%d", plid);
	SendClientMessage(playerid, 0x66FF33, string);
	DestroyVehicle(plid);
	return 1;
}

CMD:explode(playerid, params[])
{
	levelerror(3);
	if (!strlen(params)) return SendErrorMessage(playerid, "Usage: /explode <id>");
	plid = strval(params);
	if (!IsPlayerConnected(plid)) return SendErrorMessage(playerid, "Player Not Connected!");
	format(string, sizeof(string), "You have exploded {FFFFFF}%s(%d)", PlayerName(plid), plid);
	SendClientMessage(playerid, 0x66FF33, string);
	GetPlayerPos(plid, posxx[0], posxx[1], posxx[2]);
	CreateExplosion(posxx[0], posxx[1], posxx[2], 1, 2);
	return 1;
}

CMD:slap(playerid, params[])
{
	levelerror(2);
	if (!strlen(params)) return SendErrorMessage(playerid, "Usage: /slap <id>");
	plid = strval(params);
	if (!IsPlayerConnected(plid)) return SendErrorMessage(playerid, "Player Not Connected!");
	format(string, sizeof(string), "You have slapped {FFFFFF}%s(%d)", PlayerName(plid), plid);
	SendClientMessage(playerid, 0x66FF33, string);
	GetPlayerPos(plid, posxx[0], posxx[1], posxx[2]);
	SetPlayerPos(plid, posxx[0], posxx[1], posxx[2]+40);
	return 1;
}

CMD:goto(playerid, params[])
{
	levelerror(3);
	if (!strlen(params)) return SendErrorMessage(playerid, "Usage: /goto <id>");
	plid = strval(params);
	if (!IsPlayerConnected(plid)) return SendErrorMessage(playerid, "Player Not Connected!");
	format(string, sizeof(string), "You have teleported to {FFFFFF}%s(%d)", PlayerName(plid), plid);
	SendClientMessage(playerid, 0x66FF33, string);
	SendPlayerToAnother(playerid, plid);
	return 1;
}

CMD:get(playerid, params[])
{
	levelerror(4);
	if (!strlen(params)) return SendErrorMessage(playerid, "Usage: /get <id>");
	plid = strval(params);
	if (!IsPlayerConnected(plid)) return SendErrorMessage(playerid, "Player Not Connected!");
	format(string, sizeof(string), "You have teleported {FFFFFF}%s(%d){66FF33} to you", PlayerName(plid), plid);
	SendClientMessage(playerid, 0x66FF33, string);
	format(string, sizeof(string), "You have been teleported to {FFFFFF}%s(%d)", PlayerName(playerid), playerid);
	SendPlayerToAnother(plid, playerid);
	return 1;
}

CMD:kick(playerid, params[])
{
	levelerror(3);
	if(sscanf(params, "us[200]", plid, estring)) return SendErrorMessage(playerid, "Usage: /kick <id> <reason>");
	if (!IsPlayerConnected(plid)) return SendErrorMessage(playerid, "Player Not Connected!");
	format(string, sizeof(string), "You have kicked {FFFFFF}%s(%d)", PlayerName(plid), plid);
	SendClientMessage(playerid, 0x66FF33, string);
	format(largestring, sizeof(largestring), "You have been kicked from the server by admin %s(%d) \r\nReason:%s", escpname(playerid), playerid, estring);
	ShowPlayerDialog(plid, DIALOG_KICK, DIALOG_STYLE_MSGBOX, "You have been kicked", largestring, "Ok", "Cancel");
	Kick(plid);
	return 1;
}

CMD:freeze(playerid, params[])
{
	levelerror(3);
	if (!strlen(params)) return SendErrorMessage(playerid, "Usage: /freeze <id>");
	plid = strval(params);
	if (!IsPlayerConnected(plid)) return SendErrorMessage(playerid, "Player Not Connected!");
	format(string, sizeof(string), "You have frozen {FFFFFF}%s(%d)", PlayerName(plid), plid);
	SendClientMessage(playerid, 0x66FF33, string);
	format(string, sizeof(string), "You have been frozen by admin %s(%d)", PlayerName(playerid), playerid);
	SendErrorMessage(plid, string);
	TogglePlayerControllable(plid, false);
	return 1;
}

CMD:unfreeze(playerid, params[])
{
	levelerror(3);
	if (!strlen(params)) return SendErrorMessage(playerid, "Usage: /unfreeze <id>");
	plid = strval(params);
	if (!IsPlayerConnected(plid)) return SendErrorMessage(playerid, "Player Not Connected!");
	format(string, sizeof(string), "You have unfrozen {FFFFFF}%s(%d)", PlayerName(plid), plid);
	SendClientMessage(playerid, 0x66FF33, string);
	format(string, sizeof(string), "You have been unfrozen by {FFFFFF}admin %s(%d)", PlayerName(playerid), playerid);
	SendClientMessage(plid, 0x66FF33, string);
	TogglePlayerControllable(plid, true);
	return 1;
}

CMD:ban(playerid, params[])
{
	levelerror(4);
	if (sscanf(params, "us[200]", plid, estring)) return SendErrorMessage(playerid, "Usage: /ban <id> <reason>");
	if (!IsPlayerConnected(plid)) return SendErrorMessage(playerid, "Player Not Connected!");
	format(string, sizeof(string), "You have banned {FFFFFF}%s(%d)", PlayerName(plid), plid);
	SendClientMessage(playerid, 0x66FF33, string);
	format(largestring, sizeof(largestring), "Admin %s banned you from the server\r\nReason:%s", PlayerName(playerid), estring);
	ShowPlayerDialog(plid, DIALOG_KICK, DIALOG_STYLE_MSGBOX, "You have been banned", largestring, "Ok", "Cancel");
	GetPlayerIp(plid, PIP, 50);
	new Hour, Minute, Second, Year, Month, Day;
	gettime(Hour, Minute, Second);
	getdate(Year, Month, Day);
	format(string, sizeof(string), "%02d:%02d:%02d on %02d/%02d/%d", Hour, Minute, Second, Day, Month, Year);
    format(Query, sizeof(Query), "INSERT INTO `banlog` (`time`, `name`, `ip`, `reason`, `admin`, `banned`) VALUES ('%s', '%s', '%s', '%s', '%s', 1)", string, escpname(plid), PIP, escstring(estring), escpname(playerid));
	mysql_query(Query);
	mysql_free_result();
	Kick(plid);
	return 1;
}

CMD:unban(playerid, params[])
{
	levelerror(4);
	if (!strlen(params)) return SendErrorMessage(playerid, "Usage: /unban <name>");
	format(Query, sizeof(Query), "SELECT `name` FROM `banlog` WHERE name = '%s' AND banned = 1 LIMIT 1", escstring(params));
	mysql_query(Query);
	mysql_store_result();
	if(!mysql_num_rows())
	{
    	format(string, sizeof(string), "Nobody under the name of %s is banned!", params);
		mysql_free_result();
		return SendErrorMessage(playerid, string);
	}
	else if(mysql_num_rows() != 0)
	{
	    format(Query, sizeof(Query), "UPDATE `banlog` SET `banned` = 0 WHERE name = '%s'", escstring(params));
		mysql_query(Query);
		mysql_store_result();
		format(string, sizeof(string), "%s has been unbanned!", params);
		SendClientMessage(playerid, 0x66FF33, string);
	}
	return 1;
}

CMD:mute(playerid, params[])
{
    levelerror(2);
	if (!strlen(params)) return SendErrorMessage(playerid, "Usage: /mute <id>");
	plid = strval(params);
	if (!IsPlayerConnected(plid)) return SendErrorMessage(playerid, "Player Not Connected!");
	if (GetPVarInt(playerid, "muted") == 1) return SendErrorMessage(playerid, "Player is already muted");
	if (plid == playerid) return SendErrorMessage(playerid, "You cannot mute yourself");
	SetPVarInt(plid, "muted", 1);
	format(string, sizeof(string), "You have muted player %s(%d)", PlayerName(plid), plid);
	SendClientMessage(playerid, 0x66FF33, string);
	format(string, sizeof(string), "Admin %s(%d) has {FF00AA}muted {FFFFFF}you", PlayerName(playerid), playerid);
	SendClientMessage(plid, 0xFFFFFF, string);
	return 1;
}

CMD:unmute(playerid, params[])
{
    levelerror(2);
	if (!strlen(params)) return SendErrorMessage(playerid, "Usage: /unmute <id>");
	plid = strval(params);
	if (!IsPlayerConnected(plid)) return SendErrorMessage(playerid, "Player Not Connected!");
	if (GetPVarInt(plid, "muted") == 0) return SendErrorMessage(playerid, "Player isn't muted");
	SetPVarInt(plid, "muted", 0);
	format(string, sizeof(string), "You have unmuted player %s(%d)", PlayerName(plid), plid);
	SendClientMessage(playerid, 0x66FF33, string);
	format(string, sizeof(string), "Admin %s(%d) has {00FF33}unmuted {FFFFFF}you", PlayerName(playerid), playerid);
	SendClientMessage(plid, 0xFFFFFF, string);
	return 1;
}

CMD:report(playerid, params[])
{
	if (sscanf(params, "us[200]", plid, estring)) return SendClientMessage(playerid, 0xFF0000AA, "Usage: /report <playerid> <reason>");
	if (!IsPlayerConnected(plid)) return SendClientMessage(playerid, 0xFF0000AA, "The player you have tried to report is not connected!");
	if (plid == playerid) return SendClientMessage(playerid, 0xFF0000AA, "You cannot report yourself!");
	format(string, sizeof(string), "REPORT: %s(%d) has reported %s(%d) for %s", PlayerName(playerid), playerid, PlayerName(plid), plid, estring);
    SendMessageToAllAdmins(string, 0xFF0000AA);
    SendClientMessage(playerid, 0x99FF66, "Your report has been sent.");
	if(reportnumber != 5)
	{
	    format(reports[reportnumber], 100, "%s", string);
	    reportnumber++;
	    return 1;
	}
	if(reportnumber == 5)
	{
	    reportnumber = 0;
	    format(reports[reportnumber], 100, "%s", string);
	    reportnumber ++;
	}
	return 1;
}

stock escpname(playerid)
{
	new escname[24];
    GetPlayerName(playerid, Pname, 24);
	mysql_real_escape_string(Pname, escname);
	return escname;
}

stock escstring(stri[])
{
	new escstr[200];
	mysql_real_escape_string(stri, escstr);
	return escstr;
}

stock PlayerName(pid)
{
	GetPlayerName(pid, Pname, 24);
 	return Pname;
}

stock SendMessageToAllAdmins(message[], color)
{
	foreach(Player, i)
	{
		if(PlayerAdmin(i))
		{
	 	    SendClientMessage(i, color, message);
	 	}
 	}
	return 1;
}

stock SendPlayerToAnother(sendingplayer, receivingplayer)
{
	GetPlayerPos(receivingplayer, posxx[0], posxx[1], posxx[2]);
	SetPlayerPos(sendingplayer, posxx[0], posxx[1]+2, posxx[2]);
	SetPlayerVirtualWorld(sendingplayer, GetPlayerVirtualWorld(receivingplayer));
	SetPlayerInterior(sendingplayer, GetPlayerInterior(receivingplayer));
	return 1;
}

stock bancheck(playerid)
{
    GetPlayerIp(playerid, PIP, sizeof(PIP));
    format(Query, sizeof(Query), "SELECT * FROM `banlog` WHERE (`name` = '%s' OR `ip` = '%s')  AND `banned` = 1 LIMIT 1", escpname(playerid), PIP);
    mysql_query(Query);
    mysql_store_result();
    if(mysql_num_rows() != 0)
	{
	    new Name2[24];
	    while(mysql_fetch_row(Query))
	    {
				mysql_fetch_field_row(string, "reason");
				mysql_fetch_field_row(Pname, "admin");
				mysql_fetch_field_row(estring, "time");
				mysql_fetch_field_row(PIP, "ip");
				mysql_fetch_field_row(Name2, "name");
		}
		format(largestring, sizeof(largestring), "You are currently banned from this server. \r\nUser:%s \r\nIP:%s  \r\nTime:%s \r\nAdmin:%s\r\nReason:%s", Name2, PIP, estring, Pname, string);
		ShowPlayerDialog(plid, DIALOG_BANNED, DIALOG_STYLE_MSGBOX, "You are banned from this server", largestring, "Ok", "Cancel");
		Kick(playerid);
	}
    mysql_free_result();
	return 1;
}


stock PlayerAdmin(pid)
{
	if( GetPVarInt(pid, "AdminLevel" ) > 0) return 1;
	return 0;
}
