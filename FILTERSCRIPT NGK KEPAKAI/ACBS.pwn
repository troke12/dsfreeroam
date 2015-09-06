/* =======================[READ ME | READ INSTALATION.TXT]=============================
--------------[24.12.2011 - 17.2.2012]--------------
Credits:
Mihail_Vukota - Help with testing AC (on version v0.1/v0.2)
Gamestar - AntiSwear
Gagi_Corleone(Mr.Gagi) - Help with foreach, anti health hack and with checking animations
[FG]Snich_Wolf - explanation of how to remove the second "OK" button
PLEASE DON'T CHANGE ANTICHEAT'S NAME!!! | SORRY FOR MY BAD ENGLISH!!
===================[v0.1]==[24.12.2011]===================
Scripted Anti: Speed Hack, High Ping, Jet Pack and Bad Weapons
===================[v0.2]==[24.12.2011 && 25.12.2011]=====
NEW: Anti Drive By, Anti Swear, Anti BunnyHop, RCON Protection, Anti AirBreake (beta test)
Script fully optimized, removed timer for each player, and all check put in 1 timer.
Now you can turn on/off some detection in AntiCHeat, over command /anticheat (RCON)
===================[v0.3]==[26.12.2011 && 29.12.2011-19:15]====
Optimized Script
NEW: Now anticheat can ignore admins, over command /adminduty in your mode(just need to set wef pvars)
Now there is kick log, when player is kicked, his name, time, and reason will be in log.
NEW BETA ANTICHEATS: Anti Money Hack
FIXED AND UPGRADED: Anti AirBrake, Anti BunnyHop
Happy New Year, 2012!!! :)
===================[v0.4]==[31.12.2011 && 2.1.2012]======
FIXED AND UPGRADED: Anti Money Cheat, Anti AirBrake, fixed few little bugs with log files.
NEW(BETA): Anti Health and Anti Armour Hack
Now kicked player get's dialog with message that he is kicked/banned, with his name, reason, and ip adress.
===================[v0.5]==[4.1.2012 && 8.1.2012]========
Optimized Script, and fixed some little bugs.
From now and reseting money is going over AntiCheat.
NEW: Anti Teleport[INT] - anit teleport in INTERIOR , Anti Fly Hack - if player is using Fly hack, anticheat will kick him.
From now, you don't put stock funciton in mode, now you have include file!!
"Printing" weapon names in text on bad weapon kick is now autimatic!
===================[v0.6]==[13.2.2012]========
Optimized Script
FIXED: Anti Money Cheat, Anti Teleport[INT]
FIX AND UPGRADE: Anti Health Hack,  Anti Armour Hack
===================[v0.7]==[15.2.2012-17.2.2012]========
NEW: Scripted new Anti AirBrake, detection is now perfect!
Scripted Anti Teleport, teleport over menu and over map, there are 2 type of teleport, first type is when you press in s0beit f11 > teleports > some place, and that teleport on kick is flaged as Teleport Hack[1]
And there is Map teleport, press esc > map > right click somvere on the map, and that teleport on kick is flaged as Teleport Hack[2].
Scripted Anti Vehicle Repair.
There are more changes, but tehy are not so important..
---[v0.7 R1]--
FIXED: Old bugs with Anti Drive By,  and bug with sprunk on Health Hack
===================[v0.8]==[23.4.2012]========
NEW: AntiSpam, Anti AFK
Anti Teleport is now more secure, Anti Teleport[INT] is now Anti Interior Hack
Fixed bug with Anti AirBrake, when you enter to building or come back from afk, you get kick, now that is fixed.
Fixed bug with player name in Anti Vehicle repair
//-----------[V0.8 R1 - 27.3.2012]-----------
Fixed bug from v0.8 , v0.8 has made big lag on server, now that's fixed, Gigi_Falcone has found what's problem...
*/
#define FILTERSCRIPT

#include <a_samp>
#include <float>
#include <zcmd>
#include <foreach>
#include <AC_Balkan_Security>

#define YELLOW 0xDABB3EAA
#define BELA 0xFFFFFFAA
#define RED 0xFF0000FF
#define MAX_LEN 32
#define MAX_ENTRY 120
#define forum "www.driftstunting.com"//type here your forum adress
#define MAXAFK 900 // change this if you want more/less than 15 minutes (1 minute = 60 seconds | 15 minutes = 900 seconds)



static reci[MAX_ENTRY][MAX_LEN];

new ime[MAX_PLAYER_NAME]; // player's name
new Zastita[MAX_PLAYERS]; // protection for player
new Skakuce[MAX_PLAYERS]; // how much time he has buny jumping
new Pokusaji[MAX_PLAYERS];// how much time player is tried to login as rcon
new Novac1[MAX_PLAYERS]; // player's money, if player have more money then it is in this variable, ac wil react
new OpomenaNovca[MAX_PLAYERS]; // if he get 3 warning, player will be kicked
new FlyOpomena[MAX_PLAYERS];// if it's on 1, player will get kick
new Spawnovan[MAX_PLAYERS]; // help for protecting player
new Float:Pozicija[MAX_PLAYERS][3]; // position on player is
new Float:AutoHelti[MAX_PLAYERS]; // vehicel health
new kikovan[MAX_PLAYER_NAME];
new MuteIgraca[MAX_PLAYER_NAME]; // check if player is muted
new IgracSpamuje[MAX_PLAYER_NAME]; // is player spamming
new PrvaSpamOpomena[MAX_PLAYER_NAME]; // does player have alerdy spam warning
new AFK[MAX_PLAYER_NAME]; // is player afk
new AFK2[MAX_PLAYER_NAME]; // is player afk
new VP = 1; // you change this ingame, over command /anticheat - too high ping (ON = 1 | OFF = 0)
new PJP = 1; // you change this ingame, over command /anticheat - anti jet pack (ON = 1 | OFF = 0)
new PB = 1; // you change this ingame, over command /anticheat - anti speed hack (ON = 1 | OFF = 0)
new ZO = 1; // you change this ingame, over command /anticheat - bad weapons (ON = 1 | OFF = 0)
new RCONZ = 1; // you change this ingame, over command /anticheat - rcon protection (ON = 1 | OFF = 0)
new ZR = 1; // you change this ingame, over command /anticheat - anti swear (ON = 1 | OFF = 0)
new DBP = 1; // you change this ingame, over command /anticheat - Anti Drive BY (ON = 1 | OFF = 0)
new BHP = 1; // you change this ingame, over command /anticheat - anti bunny hop (ON = 1 | OFF = 0)
new MPing = 700; //this is max ping, change this if you want!
new Float:MBrzina = 235.0; //this is max speed, chage this if you want!
new PAB = 1; // you change this ingame, over command /anticheat - anti airbrake (ON = 1 | OFF = 0)
new NN = 1; // you change this ingame, over command /anticheat - anti money hack (ON = 1 | OFF = 0)
new NH = 1; // you change this ingame, over command /anticheat - anti health hack (ON = 1 | OFF = 0)
new NA = 1; // you change this ingame, over command /anticheat - anti armour hack (ON = 1 | OFF = 0)
new NT = 1; // you change this ingame, over command /anticheat - anti interior teleport (ON = 1 | OFF = 0)
new FP = 1; // you change this ingame, over command /anticheat - anti fly hack (ON = 1 | OFF = 0)
new ANT = 1; // you change this ingame, over command /anticheat - anti teleport[1] (s0beit menu) (ON = 1 | OFF = 0)
new ANT2 = 1; // you change this ingame, over command /anticheat - anti teleport[2] (map) (ON = 1 | OFF = 0)
new AVR = 1; // you change this ingame, over command /anticheat - anti vehicle repair (ON = 1 | OFF = 0)
new AS = 1; // you change this ingame, over command /anticheat - anti spam (ON = 1 | OFF = 0)
new AAFK = 1; // you change this ingame, over command /anticheat -  anti afk (ON = 1 | OFF = 0)
new y, m, d; new h,mi,s; new ipadresa[400]; new string2[600]; new Sekunde = 0;

forward AntiCheat();
forward split(const strsrc[], strdest[][], delimiter);
forward kick(playerid);
forward nanula(playerid);

public OnFilterScriptInit()
{
	SetTimer("AntiCheat", 1000, 1); // DON'T CHANGE THIS, OR ANTICHEAT WILL NOT WORK
	UcitajAC();
	if(fexist("AC-BS/words.txt"))
	{
		new File:myFile,
			line[MAX_LEN],
			index=0;

		myFile=fopen("AC-BS/words.txt",filemode:io_read);

		while(fread(myFile,line,sizeof line) && (index != MAX_ENTRY))
		{
			if(strlen(line)>MAX_LEN) continue;
			StripNewLine(line);
			strmid(reci[index],line,0,strlen(line),sizeof line);
			index++;
		}
	}
	print("\n--------------------------------------");
	print(" AntiCheat by: Maki187 (Marko_Dimitrijevic)");
	print(" AntiCheat v0.8 R1");
	print(" Balkan Rising - www.balkan-rising.info");
	print(" -------------[REKLAMA]------------");
	print(" Bestbalkandj.com - www.bestbalkandj.com");
	print(" Serbian Warez - www.serbian-warez.in.rs");
	print("--------------------------------------\n");
	return 1;
}
public OnPlayerConnect(playerid)
{
	Zastita[playerid] = 1; kikovan[playerid] = 0; AFK[playerid] = 0; AFK2[playerid] = 0;
	AutoHelti[playerid] = 1000; OpomenaNovca[playerid] = 0;
	MuteIgraca[playerid] = 0; IgracSpamuje[playerid] = 0;
	SetPVarInt(playerid, "SafeTeleport", 1); ACCREDITS PrvaSpamOpomena[playerid] = 0;
    return 1;
}
public split(const strsrc[], strdest[][], delimiter)
{
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc)){
	    if(strsrc[i]==delimiter || i==strlen(strsrc)){
	        len = strmid(strdest[aNum], strsrc, li, i, 128);
	        strdest[aNum][len] = 0;
	        li = i+1;
	        aNum++;
		}
		i++;
	}
	return 1;
}
stock GetPlayerSpeed(playerid,bool:kmh) // by misco
{
    new Float:Vx,Float:Vy,Float:Vz,Float:rtn;
    if(IsPlayerInAnyVehicle(playerid)) GetVehicleVelocity(GetPlayerVehicleID(playerid),Vx,Vy,Vz); else GetPlayerVelocity(playerid,Vx,Vy,Vz);
    rtn = floatsqroot(floatabs(floatpower(Vx + Vy + Vz,2)));
    return kmh?floatround(rtn * 100 * 1.61):floatround(rtn * 100);
}
stock GetDistanceToPoint(playerid,Float:x2,Float:y2,Float:z2)
{
	new Float:dis;
	new Float:x1,Float:y1,Float:z1;
	if (!IsPlayerConnected(playerid)) return -1;
	GetPlayerPos(playerid,x1,y1,z1);
	dis = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
	return floatround(dis);
}
stock KodSprunk(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 4, -2420.219, 984.578, 44.297)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, -2420.180, 985.945, 44.297)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 2225.203, -1153.422, 1025.906)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 2576.703, -1284.430, 1061.094)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 2155.906, 1606.773, 1000.055)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 2209.906, 1607.195, 1000.055)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 2222.203, 1606.773, 1000.055)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 495.969, -24.320, 1000.734)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 501.828, -1.430, 1000.734)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 373.828, -178.141, 1000.734)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 330.680, 178.500, 1020.070)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 331.922, 178.500, 1020.070)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 350.906, 206.086, 1008.477)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 361.563, 158.617, 1008.477)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 371.594, 178.453, 1020.070)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 374.891, 188.977, 1008.477)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 2155.844, 1607.875, 1000.063)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 2202.453, 1617.008, 1000.063)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 2209.242, 1621.211, 1000.063)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 2222.367, 1602.641, 1000.063)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 500.563, -1.367, 1000.734)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 379.039, -178.883, 1000.734)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 2480.86,-1959.27,12.9609)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 1634.11,-2237.53,12.8906)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 2139.52,-1161.48,23.3594)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 2153.23,-1016.15,62.2344)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, -1350.12,493.859,10.5859)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, -2229.19,286.414,34.7031)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 1659.46,1722.86,10.2188)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 2647.7,1129.66,10.2188)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 2845.73,1295.05,10.7891)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 1398.84,2222.61,10.4219)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, -1455.12,2591.66,55.2344)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, -76.0312,1227.99,19.125)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 662.43,-552.164,15.7109)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, -253.742,2599.76,62.2422)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 2271.73,-76.4609,25.9609)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 1789.21,-1369.27,15.1641)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 1729.79,-1943.05,12.9453)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 2060.12,-1897.64,12.9297)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 1928.73,-1772.45,12.9453)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 2325.98,-1645.13,14.2109)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 2352.18,-1357.16,23.7734)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 1154.73,-1460.89,15.1562)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, -1350.12,492.289,10.5859)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, -2118.97,-423.648,34.7266)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, -2118.62,-422.414,34.7266)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, -2097.27,-398.336,34.7266)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, -2092.09,-490.055,34.7266)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, -2063.27,-490.055,34.7266)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, -2005.65,-490.055,34.7266)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, -2034.46,-490.055,34.7266)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, -2068.56,-398.336,34.7266)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, -2039.85,-398.336,34.7266)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, -2011.14,-398.336,34.7266)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, -1980.79,142.664,27.0703)) return 1;
 	else if(IsPlayerInRangeOfPoint(playerid, 4, 2319.99,2532.85,10.2188)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 1520.15,1055.27,10.00)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 2503.14,1243.7,10.2188)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 2085.77,2071.36,10.4531)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, -862.828,1536.61,21.9844)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, -14.7031,1175.36,18.9531)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, -253.742,2597.95,62.2422)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 201.016,-107.617,0.898438)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid, 4, 1277.84,372.516,18.9531)) return 1;
	else return 0;
}
//-------------------[ANTI BUNNY HOP]------------------
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
new string[128];
GetPlayerIp(playerid, ipadresa, sizeof(ipadresa));
if(BHP == 1)
{
if(GetPVarInt(playerid, "AdminProtect") == 0)
{
if((newkeys & KEY_UP && newkeys & KEY_JUMP) || (newkeys & KEY_UP && newkeys & KEY_SPRINT && newkeys & KEY_JUMP))
	{
			if(!IsPlayerInAnyVehicle(playerid))
			{
                    Skakuce[playerid] ++;
				    if(Skakuce[playerid] == 30)
					{
					    SendClientMessage(playerid,YELLOW, "[AC-Balkan Security]: First warning for Bunny Hop, after 4 warnings, you will be kicked!");
					}
					else if(Skakuce[playerid] == 45)
					{
						SendClientMessage(playerid,YELLOW, "[AC-Balkan Security]: First warning for Bunny Hop, after 4 warnings, you will be kicked!");
					}
					else if(Skakuce[playerid] == 65)
					{
						SendClientMessage(playerid,YELLOW, "[AC-Balkan Security]: First warning for Bunny Hop, after 4 warnings, you will be kicked!");
						SetTimerEx("nanula",180000, false, "i", playerid);
					}
					else if(Skakuce[playerid] == 80)
					{
						SendClientMessage(playerid,YELLOW, "[AC-Balkan Security]: First warning for Bunny Hop, after 4 warnings, you will be kicked!");
						SetTimerEx("nanula",180000, false, "i", playerid);
					}
					else if(Skakuce[playerid] == 100)
					{
					if(kikovan[playerid] == 0)
    				{
    			    	kikovan[playerid] = 1;
						GetPlayerName(playerid, ime, sizeof(ime));
						GetPlayerIp(playerid, ipadresa, sizeof(ipadresa));
						format(string, sizeof(string), "%s %s has been kicked for 4/4 Bunny hop warnings.",acime, ime);
						SendClientMessageToAll(RED, string);
						SendClientMessage(playerid,YELLOW, "[AC-Balkan Security]: You are kicked for 4/4 Bunny Hop warnings.");
						format(string2, sizeof(string2),"{CD0000}Kicked!\n{FFF8DC}Name:{CD0000} %s\n{FFF8DC}Reason:{CD0000} 4/4 Bunny HOp warnings\n{FFF8DC}IP:{CD0000} %s\n \n{CD0000}If you think that you are kicked for no reason,\n press F8 and report mistake on forums.\n Web Site: %s",ime,ipadresa,forum);
						ShowPlayerDialog(playerid, 20000, DIALOG_STYLE_MSGBOX, "{FFF8DC}[AC - Balkan Security]",string2, "Ok", "Ok");
						getdate(y,m,d);
						gettime(h,mi,s);
						format(string,sizeof(string), "[%d/%d/%d]-[%d:%d:%d] [AC - Balkan Security] has kicked %s for Bunny Hop",d,m,y,h,mi,s,ime);
						log(string);
						SetTimerEx("kick",10, false, "i", playerid);
					}
					}
			}
	}
}
}
return 1;
}
//---------------------------[ANTI DRIVE BY]-----------------------
public OnPlayerDeath(playerid, killerid, reason)
{
	new string[128];
	if(DBP == 1)
	{
		if(GetPVarInt(playerid, "AdminProtect") == 0)
		{
			if(GetPlayerState(killerid) == PLAYER_STATE_DRIVER)
    		{
    			if(GetVehicleModel(GetPlayerVehicleID(killerid)) != 425 || GetVehicleModel(GetPlayerVehicleID(killerid)) != 520 || GetVehicleModel(GetPlayerVehicleID(killerid)) != 432)
    			{
    				if(kikovan[killerid] == 0)
    				{
    			   		kikovan[killerid] = 1;
    					GetPlayerName(killerid, ime, sizeof(ime));
    					GetPlayerIp(killerid, ipadresa, sizeof(ipadresa));
						format(string, sizeof(string), "%s %s has been kicked for DB-Drive By",acime, ime);
						SendClientMessageToAll(RED, string);
						format(string2, sizeof(string2),"{CD0000}Kicked!\n{FFF8DC}Name:{CD0000} %s\n{FFF8DC}Reason:{CD0000} Drive By\n{FFF8DC}IP:{CD0000} %s\n \n{CD0000}If you think that you are kicked for no reason,\n press F8 and report mistake on forums.\n Web Site: %s",ime,ipadresa,forum);
						ShowPlayerDialog(killerid, 20000, DIALOG_STYLE_MSGBOX, "{FFF8DC}[AC - Balkan Security]",string2, "Ok", "Ok");
						getdate(y,m,d);
						gettime(h,mi,s);
						format(string,sizeof(string), "[%d/%d/%d]-[%d:%d:%d] [AC - Balkan Security] has kicked %s for DriveBy",d,m,y,h,mi,s,ime);
						log(string);
						SetTimerEx("kick",10, false, "i", killerid);
					}
				}
			}
		}
	}
	return 1;
}
//------------------------------[RCON PROTECTION]-------------------
public OnRconLoginAttempt(ip[], password[], success)
{
	if(RCONZ == 1)
	{
    	if(!success)
    	{
 			new p2[16]; new string[176];
    		foreach(Player, i)
			{
        		if(GetPVarInt(i, "AdminProtect") == 0)
				{
	    			GetPlayerIp(i, p2, sizeof(p2));
     				if(!strcmp(ip, p2, true))
	    			{
						GetPlayerName(i, ime, sizeof(ime));
	        			if(Pokusaji[i] != 3)
	        			{
							Pokusaji[i] ++;
							SendClientMessage(i,RED, "[AC-Balkan Security]: Wrong Password ! If you type wrong password for more that 3 time, you will be baned!!");
						}
						else
						{
							if(kikovan[i] == 0)
    						{
    			    			kikovan[i] = 1;
								GetPlayerName(i, ime, sizeof(ime));
								GetPlayerIp(i, ipadresa, sizeof(ipadresa));
								format(string, sizeof(string), "%s %s has been banned because 3/3 warning for Bad RCON password",acime, ime);
								SendClientMessageToAll(RED, string);
								format(string2, sizeof(string2),"{CD0000}Banned!\n{FFF8DC}Name:{CD0000} %s\n{FFF8DC}Reason:{CD0000} 3/3 RCON Warnings\n{FFF8DC}IP:{CD0000} %s\n \n{CD0000}If you think that you are banned for no reason,\n press F8 and report mistake on forums.\n Web Site: %s",ime,ipadresa,forum);
								ShowPlayerDialog(i, 20000, DIALOG_STYLE_MSGBOX, "{FFF8DC}[AC - Balkan Security]",string2, "Ok", "");
								getdate(y,m,d);
								gettime(h,mi,s);
								format(string,sizeof(string), "[%d/%d/%d]-[%d:%d:%d] [AC - Balkan Security] has banned %s because 3/3 RCON bad password warnings.",d,m,y,h,mi,s,ime);
								log(string);
								Ban(i);
							}
						}
	            	}
				}
        	}
        }
	}
    return 1;
}
public OnPlayerSpawn(playerid)
{
	Spawnovan[playerid] = 1;
	Skakuce[playerid] = 0;
	Novac1[playerid] = GetPlayerMoney(playerid);
	OpomenaNovca[playerid] = 0;
	SetPVarInt(playerid, "SafeTeleport", 1);
	SetPVarInt(playerid, "SafeInt", GetPlayerInterior(playerid));
	SetPVarInt(playerid, "SafeVW", GetPlayerVirtualWorld(playerid));
	return 1;
}

stock SetPlayerSpawn(playerid)
{
	Skakuce[playerid] = 0;
	OpomenaNovca[playerid] = 0;
	Novac1[playerid] = GetPlayerMoney(playerid);
	SetPVarInt(playerid, "SafeTeleport", 1);
	SetPVarInt(playerid, "SafeInt", GetPlayerInterior(playerid));
	SetPVarInt(playerid, "SafeVW", GetPlayerVirtualWorld(playerid));
	return 1;
}
public OnPlayerText(playerid,text[])
{
    new string[128];
	if(ZR == 1)
	{
		if(GetPVarInt(playerid, "AdminProtect") == 0)
		{
 			for(new i=0; i<MAX_ENTRY; i++)
 			{
 	    		if(!reci[i][0]) continue;
				Cenzura(text,reci[i]);
			}
		}
	}
	if(AS == 1)
	{
	    if(MuteIgraca[playerid] != 0)
	    {
	    	format(string, sizeof(string), "%s You can't talk, you are muted for %d seconds.",acime,MuteIgraca[playerid]);
			SendClientMessage(playerid, RED, string);
			return 0;
		}
	    IgracSpamuje[playerid]++;
		if(IgracSpamuje[playerid] >= 7)
		{
		    if(PrvaSpamOpomena[playerid] == 0)
		    {
		        PrvaSpamOpomena[playerid] = 1; IgracSpamuje[playerid] = 0;
		        format(string, sizeof(string), "%s You will be muted if you don't stop with spam/",acime,MuteIgraca[playerid]);
				SendClientMessage(playerid, RED, string);
				return 1;
			}
		    MuteIgraca[playerid] = 120; IgracSpamuje[playerid] = 0;
		    format(string, sizeof(string), "%s You are muted on 120 seconds for spaming",acime);
			SendClientMessage(playerid, RED, string);
			return 0;
		}
	}
	return 1;
}
stock Letelica(carid)// here are all airplanes and vehicles what will anti speed hack ignore
{
    new v = GetVehicleModel(carid);
    if(v == 593 || v == 592 || v == 577 || v == 553 || v == 520 || v == 519 || v == 511|| v == 460 || v == 563 || v == 548 || v == 497 || v == 488 || v == 487 || v == 469 || v == 447 || v == 417)
	{
		return 1;
	}
	return 0;
}
stock StripNewLine(str[])
{
	new l = strlen(str);
	while (l-- && str[l] <= ' ') str[l] = '\0';
}

stock Cenzura(string[],word[],destch='*')
{
	new start_index=(-1),
	    end_index=(-1);

	start_index=strfind(string,word,true);
	if(start_index==(-1)) return false;
	end_index=(start_index+strlen(word));

	for( ; start_index<end_index; start_index++)
		string[start_index]=destch;

	return true;
}
public kick(playerid)
{
	ResetPlayerWeapons(playerid);
	Kick(playerid);
	return 1;
}

public nanula(playerid)
{
	if(Skakuce[playerid] >= 65 && Skakuce[playerid] < 76)
	{
		Skakuce[playerid] = 0;
	}
	return 1;
}
stock log(string[])
{
	new entry[200];
	format(entry, sizeof(entry), "%s\r\n",string);
	new File:hFile;
	hFile = fopen("AC-BS/log.log", io_append);
	fwrite(hFile, entry);
	fclose(hFile);
}
stock SnimiAC()
{
	new string[228];
	format(string, sizeof(string), "%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d",VP,PJP,PB,ZO,RCONZ,ZR,DBP,BHP,PAB,NN,NH,NA,NT,FP,ANT,ANT2,AVR,AS,AAFK);
	new File: file2 = fopen("AC-BS/anticheat.ini", io_write);
	fwrite(file2, string);
	fclose(file2);
	return 1;
}
stock UcitajAC()
{
	new arrCoords[19][64];
	new strFromFile2[128];
	new File: file = fopen("AC-BS/anticheat.ini", io_read);
	if (file)
	{
		fread(file, strFromFile2);
		split(strFromFile2, arrCoords, ',');
		VP = strval(arrCoords[0]);
		PJP = strval(arrCoords[1]);
		PB = strval(arrCoords[2]);
		ZO = strval(arrCoords[3]);
		RCONZ = strval(arrCoords[4]);
		ZR = strval(arrCoords[5]);
		DBP = strval(arrCoords[6]);
		BHP = strval(arrCoords[7]);
		PAB = strval(arrCoords[8]);
		NN = strval(arrCoords[9]);
		NH = strval(arrCoords[10]);
		NA = strval(arrCoords[11]);
		NT = strval(arrCoords[12]);
		FP = strval(arrCoords[13]);
		ANT = strval(arrCoords[14]);
		ANT2 = strval(arrCoords[15]);
		AVR  = strval(arrCoords[16]);
		AS = strval(arrCoords[17]);
		AAFK  = strval(arrCoords[18]);
		fclose(file);
	}
	else
	{
		fopen("AC/anticheat.ini", io_write);
		print("Sothing is not ok");
		SnimiAC();
		fclose(file);
	}
	return 1;
}
public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new Float:vhelti; Zastita[playerid] = 2;
	 	GetVehicleHealth(GetPlayerVehicleID(playerid), vhelti);
     	AutoHelti[playerid] = vhelti;
	}
	return 1;
}
public OnPlayerUpdate(playerid)
{
	if(AFK[playerid] > 2)
	{
    	AFK[playerid] = 0;
    	AFK2[playerid] = 0;
    	return 1;
	}
	return 1;
}
//=====================[START OF ALL OTHER DETECTIONS]=====================
public AntiCheat()
{
new string[428];
foreach(Player, i)
{
	if(Spawnovan[i] == 1)
	{
		if(Zastita[i] != 0)
		{
	    	Zastita[i]++; Novac1[i] = GetPlayerMoney(i);
			SetPVarInt(i, "SafeVW", GetPlayerVirtualWorld(i));
			SetPVarInt(i, "SafeInt", GetPlayerInterior(i));
			SetPVarInt(i, "SafeTeleport", 0);
			new Float:Helti; new Float:Armor;
			GetPlayerHealth(i,Helti);
			SetPVarFloat(i,"SafeHealth",Helti+2);
			GetPlayerArmour(i, Armor);
			SetPVarFloat(i,"SafeArmour",Armor+2);
			new Float:TelX; new Float:TelY; new Float:TelZ;
			GetPlayerPos(i, TelX, TelY, TelZ);
			Pozicija[i][0] = TelX; Pozicija[i][1] = TelY; Pozicija[i][2] = TelZ;
			new Float:vhelti;
	 		GetVehicleHealth(GetPlayerVehicleID(i), vhelti);
     		if(GetPlayerState(i) == PLAYER_STATE_DRIVER)
			{
	    		AutoHelti[i] = vhelti;
			}
	    	if(Zastita[i] == 3)
	    	{
	    		Zastita[i] = 0;
			}
		}
	}
	Sekunde++;
	if(Sekunde == 3)
	{
	    new Float:TelX; new Float:TelY; new Float:TelZ;
	    GetPlayerPos(i, TelX, TelY, TelZ);
		Pozicija[i][0] = TelX;
    	Pozicija[i][1] = TelY;
     	Pozicija[i][2] = TelZ;
     	new Float:vhelti;
	 	GetVehicleHealth(GetPlayerVehicleID(i), vhelti);
     	if(GetPlayerState(i) == PLAYER_STATE_DRIVER)
		{
	    	AutoHelti[i] = vhelti;
		}
		if(MuteIgraca[i] == 0)
		{
			IgracSpamuje[i] = 0;
		}
     	Sekunde = 0;
	}
 	if(MuteIgraca[i] != 0)
 	{
 	    MuteIgraca[i]--;
 	    if(PrvaSpamOpomena[i] != 0)
 	    {
 	    	PrvaSpamOpomena[i] = 0;
		}
	}
	//=====================[ANTI SPEED HACK]=============================
	if(PB == 1)
	{
		if(GetPVarInt(i, "AdminProtect") == 0)
		{
	 		if(GetPlayerState(i) == PLAYER_STATE_DRIVER)
		    {
     			new Float:X, Float:Y, Float:Z, Float:km;
     			GetVehicleVelocity(GetPlayerVehicleID(i), X, Y, Z);
     			km = floatmul(floatsqroot(floatadd(floatadd(floatpower(X, 2), floatpower(Y, 2)),  floatpower(Z, 2))), 135.0); // PROMENI ME PO POTREBI - SPEED2 (135.0)
     			new Brzina2 = floatround(floatdiv(km, 0.75), floatround_floor);
				if(Brzina2 > MBrzina)
				{
					new vozilo = GetPlayerVehicleID(i);
					GetPlayerName(i, ime, sizeof(ime));
					GetPlayerIp(i, ipadresa, sizeof(ipadresa));
					if(!Letelica(vozilo) && kikovan[i] == 0)
					{
    			    	kikovan[i] = 1;
						format(string, sizeof(string), "%s %s has been kicked for Speed Hack-a (%d km/h).",acime, ime, Brzina2);
						SendClientMessageToAll(RED, string);
						format(string2, sizeof(string2),"{CD0000}Kicked!\n{FFF8DC}Name:{CD0000} %s\n{FFF8DC}Reason:{CD0000} Speed Hack [%d km/h]\n{FFF8DC}IP:{CD0000} %s\n \n{CD0000}If you think that you are kicked for no reason,\n press F8 and report mistake on forums.\n Web Site: %s",ime,Brzina2,ipadresa,forum);
						ShowPlayerDialog(i, 20000, DIALOG_STYLE_MSGBOX, "{FFF8DC}[AC - Balkan Security]",string2, "Ok", "");
						getdate(y,m,d);
						gettime(h,mi,s);
						format(string,sizeof(string), "[%d/%d/%d]-[%d:%d:%d] [AC - Balkan Security] has kicked %s for Speed Hack-a",d,m,y,h,mi,s,ime);
						log(string);
						SetTimerEx("kick",10, false, "i", i);
					}
				}
			}
		}
	}
//=====================[TOO HIGH PING]=====================
	if(GetPVarInt(i, "AdminProtect") == 0)
	{
		if(VP == 0)
		{
			new ping = GetPlayerPing(i);
			if(ping > MPing)
	    	{
	    		if(Zastita[i] == 0 && kikovan[i] == 0)
	    		{
	    		    kikovan[i] = 1;
			    	GetPlayerName(i, ime, sizeof(ime));
			    	GetPlayerIp(i, ipadresa, sizeof(ipadresa));
					format(string, sizeof(string), "%s %s has been kicked for Too High Ping : [%d/%d]",acime, ime,ping,MPing);
					SendClientMessageToAll(RED, string);
					format(string2, sizeof(string2),"{CD0000}Kicked!\n{FFF8DC}Name:{CD0000} %s\n{FFF8DC}Reason:{CD0000} Too High Ping [%d/%d]\n{FFF8DC}IP:{CD0000} %s\n \n{CD0000}If you think that you are kicked for no reason,\n press F8 and report mistake on forums.\n Web Site: %s",ime,ping,MPing,ipadresa,forum);
					ShowPlayerDialog(i, 20000, DIALOG_STYLE_MSGBOX, "{FFF8DC}[AC - Balkan Security]",string2, "Ok", "");
					getdate(y,m,d);
					gettime(h,mi,s);
					format(string,sizeof(string), "[%d/%d/%d]-[%d:%d:%d] [AC - Balkan Security] has kicked %s for Too High Ping [%d/%d]",d,m,y,h,mi,s,ime,ping,MPing);
					log(string);
					SetTimerEx("kick",10, false, "i", i);
				}
			}
		}
	}
//=====================[BAD WEAPON CHECK]=====================
	new oruzije; new municija;
	if(ZO == 1)
	{
		if(GetPVarInt(i, "AdminProtect") == 0)
		{
			for (new c = 0; c < 13; c++)
			{
				GetPlayerWeaponData(i, c, oruzije, municija);
				if (oruzije != 0 && municija != 0 && kikovan[i] == 0)
				{
					new o = GetPlayerWeapon(i);
					GetPlayerName(i, ime, sizeof(ime));
					GetPlayerIp(i, ipadresa, sizeof(ipadresa));
					if(o == 1||o == 8||o == 9||o == 16||o == 17||o == 18||o == 39||o == 40||o == 35||o == 36||o == 37||o == 38) // CHANGE IF YOU WANT
					{
            			new oru = GetPlayerWeapon(i); new imeoruzija[24]; kikovan[i] = 1;
						GetWeaponName(oru,imeoruzija, sizeof(imeoruzija));
						format(string, sizeof(string), "%s %s has been kicked for possession of: %s",acime,ime,imeoruzija);
						SendClientMessageToAll(RED, string);
						format(string2, sizeof(string2),"{CD0000}Kicked!\n{FFF8DC}Name:{CD0000} %s\n{FFF8DC}Reason:{CD0000} %s\n{FFF8DC}IP:{CD0000} %s\n \n{CD0000}If you think that you are kicked for no reason,\n press F8 and report mistake on forums.\n Web Site: %s",ime,imeoruzija,ipadresa,forum);
						ShowPlayerDialog(i, 20000, DIALOG_STYLE_MSGBOX, "{FFF8DC}[AC - Balkan Security]",string2, "Ok", "");
						getdate(y,m,d);
						gettime(h,mi,s);
						format(string,sizeof(string), "[%d/%d/%d]-[%d:%d:%d] [AC - Balkan Security] has kicked %s for possession of Bad Weapons: %s",d,m,y,h,mi,s,ime,imeoruzija);
						log(string);
						ResetPlayerWeapons(i);
						SetTimerEx("kick",10, false, "i", i);
					}
				}
			}
		}
	}
//=====================[ANTI JETPACK]=====================
	if(PJP == 1)
	{
		if(GetPVarInt(i, "AdminProtect") == 0)
		{
			new jp = GetPlayerSpecialAction(i);
			if (jp == SPECIAL_ACTION_USEJETPACK && kikovan[i] == 0)
			{
				GetPlayerName(i, ime, sizeof(ime)); kikovan[i] = 1;
				GetPlayerIp(i, ipadresa, sizeof(ipadresa));
				format(string, sizeof(string), "%s %s je has been kicked for using JetPack",acime, ime);
				SendClientMessageToAll(RED, string);
				format(string2, sizeof(string2),"{CD0000}Kicked!\n{FFF8DC}Name:{CD0000} %s\n{FFF8DC}Reason:{CD0000} JetPack\n{FFF8DC}IP:{CD0000} %s\n \n{CD0000}If you think that you are kicked for no reason,\n press F8 and report mistake on forums.\n Web Site: %s",ime,ipadresa,forum);
				ShowPlayerDialog(i, 20000, DIALOG_STYLE_MSGBOX, "{FFF8DC}[AC - Balkan Security]",string2, "Ok", "");
				getdate(y,m,d);
				gettime(h,mi,s);
				format(string,sizeof(string), "[%d/%d/%d]-[%d:%d:%d] [AC - Balkan Security] has kicked %s for using JetPack",d,m,y,h,mi,s,ime);
				log(string);
				SetTimerEx("kick",10, false, "i", i);
			}
		}
	}
//=====================[ANTI AIR BRAKE]=====================
	if(PAB == 1)
	{
		if(GetPVarInt(i, "AdminProtect") == 0)
		{
			if(GetDistanceToPoint(i,Pozicija[i][0],Pozicija[i][1],Pozicija[i][2]) > 220 && Zastita[i] == 0 && GetPlayerInterior(i) == 0 && kikovan[i] == 0 && GetPVarInt(i, "SafeTeleport") == 0 && AFK2[i] == 0)
			{
			new ankategorija[320]; new anime[320];
    		GetAnimationName(GetPlayerAnimationIndex(i),ankategorija,320,anime,320);
    		GetPlayerName(i, ime, sizeof(ime));
			GetPlayerIp(i, ipadresa, sizeof(ipadresa));
			if(strcmp(anime,"RUN_PLAYER", false ) == 0 && strcmp(ankategorija,"PED", false ) == 0)
			{
				format(string, sizeof(string), "%s %s has been kicked for AirBrake.",acime, ime);
				SendClientMessageToAll(RED, string); kikovan[i] = 1;
				format(string2, sizeof(string2),"{CD0000}Kicked!\n{FFF8DC}Name:{CD0000} %s\n{FFF8DC}Reason:{CD0000} AirBrake\n{FFF8DC}IP:{CD0000} %s\n \n{CD0000}If you think that you are kicked for no reason,\n press F8 and report mistake on forums.\n Web Site: %s",ime,ipadresa,forum);
				ShowPlayerDialog(i, 20000, DIALOG_STYLE_MSGBOX, "{FFF8DC}[AC - Balkan Security]",string2, "Ok", "");
				getdate(y,m,d);
				gettime(h,mi,s);
				format(string,sizeof(string), "[%d/%d/%d]-[%d:%d:%d] [AC - Balkan Security] has kicked %s for AirBrake",d,m,y,h,mi,s,ime);
				log(string);
				SetTimerEx("kick",10, false, "i", i);
			}
			if(strcmp(anime,"WALK_PLAYER", false ) == 0 && strcmp(ankategorija,"PED", false ) == 0)
			{
			    format(string, sizeof(string), "%s %s has been kicked for AirBrake",acime, ime);
				SendClientMessageToAll(RED, string); kikovan[i] = 1;
				format(string2, sizeof(string2),"{CD0000}Kicked!\n{FFF8DC}Name:{CD0000} %s\n{FFF8DC}Reason:{CD0000} AirBrake\n{FFF8DC}IP:{CD0000} %s\n \n{CD0000}If you think that you are kicked for no reason,\n press F8 and report mistake on forums.\n Web Site: %s",ime,ipadresa,forum);
				ShowPlayerDialog(i, 20000, DIALOG_STYLE_MSGBOX, "{FFF8DC}[AC - Balkan Security]",string2, "Ok", "");
				getdate(y,m,d);
				gettime(h,mi,s);
				format(string,sizeof(string), "[%d/%d/%d]-[%d:%d:%d] [AC - Balkan Security] has kicked %s for AirBrake",d,m,y,h,mi,s,ime);
				log(string);
				SetTimerEx("kick",10, false, "i", i);
			}
			}
		}
	}
//=====================[ANTI MONEY HACK]=====================
	if(NN == 1)
	{
		if(GetPVarInt(i, "AdminProtect") == 0)
		{
			new novac = GetPlayerMoney(i);
			if(GetPVarInt(i, "SafeMoney") == 0 && novac > Novac1[i] && Zastita[i] == 0 && kikovan[i] == 0)
			{
            	GetPlayerName(i, ime, sizeof(ime));
				SendClientMessage(i,YELLOW, "[AC-Balkan Security]: Your money has been reseted on normal value, because you are using Money Cheats");
				ResetPlayerMoney (i);
				AC_BS_GivePlayerMoney (i, Novac1[i]);
				getdate(y,m,d);
				gettime(h,mi,s);
				format(string,sizeof(string), "[%d/%d/%d]-[%d:%d:%d] [AC - Balkan Security] has reseted %s money for using Money Hack-a",d,m,y,h,mi,s,ime);
				log(string);
				OpomenaNovca[i]++;
				if(OpomenaNovca[i] == 3)
				{
					ResetPlayerMoney (i); kikovan[i] = 1;
					AC_BS_GivePlayerMoney (i, Novac1[i]);
					GetPlayerName(i, ime, sizeof(ime));
		    		GetPlayerIp(i, ipadresa, sizeof(ipadresa));
		    		format(string, sizeof(string), "%s %s has been kicked for Money Hack-a(3/3 warnings).",acime, ime);
					SendClientMessageToAll(RED, string);
		    		format(string2, sizeof(string2),"{CD0000}Kicked!\n{FFF8DC}Name:{CD0000} %s\n{FFF8DC}Reason:{CD0000} 3/3 Money Hack Warnings\n{FFF8DC}IP:{CD0000} %s\n \n{CD0000}If you think that you are kicked for no reason,\n press F8 and report mistake on forums.\n Web Site: %s",ime,ipadresa,forum);
					ShowPlayerDialog(i, 20000, DIALOG_STYLE_MSGBOX, "{FFF8DC}[AC - Balkan Security]",string2, "Ok", "");
                	getdate(y,m,d);
					gettime(h,mi,s);
					format(string,sizeof(string), "[%d/%d/%d]-[%d:%d:%d] [AC - Balkan Security] has kicked %s for max Money Hack warnings (3x money hacking)",d,m,y,h,mi,s,ime);
					log(string);
					SetTimerEx("kick",10, false, "i", i);
				}
			}
			if(GetPVarInt(i, "SafeMoney") == 1)
			{
				Zastita[i] = 1;
				Novac1[i] = GetPlayerMoney(i);
				SetPVarInt(i, "SafeMoney", 0);
			}
		}
	}
//=====================[ANTI HEALTH HACK]=====================
	if(NH == 1)
	{
		if(GetPVarInt(i, "AdminProtect") == 0)
		{
			new Float:Helti;
			GetPlayerHealth(i,Helti);
			if(Helti < GetPVarFloat(i, "SafeHealth"))
			{
			    SetPVarFloat(i,"SafeHealth",Helti+2);
			}
			if(GetPVarFloat(i, "HealthProtection") == 1)
			{
				Zastita[i] = 1;
				SetPVarFloat(i,"HealthProtection",0);
			}
			if(KodSprunk(i))
			{
			    SetPVarFloat(i,"SafeHealth",Helti+2);
			}
			if(Helti > GetPVarFloat(i, "SafeHealth") && Zastita[i] == 0 && kikovan[i] == 0 && !KodSprunk(i))
			{
		    	GetPlayerName(i, ime, sizeof(ime)); kikovan[i] = 1;
		    	GetPlayerIp(i, ipadresa, sizeof(ipadresa));
				format(string, sizeof(string), "%s %s has been kicked for Health Hack.",acime, ime);
				SendClientMessageToAll(RED, string);
				format(string2, sizeof(string2),"{CD0000}Kicked!\n{FFF8DC}Name:{CD0000} %s\n{FFF8DC}Reason:{CD0000} Health Hack\n{FFF8DC}IP:{CD0000} %s\n \n{CD0000}If you think that you are kicked for no reason,\n press F8 and report mistake on forums.\n Web Site: %s",ime,ipadresa,forum);
				ShowPlayerDialog(i, 20000, DIALOG_STYLE_MSGBOX, "{FFF8DC}[AC - Balkan Security]",string2, "Ok", "");
				getdate(y,m,d);
				gettime(h,mi,s);
				format(string,sizeof(string), "[%d/%d/%d]-[%d:%d:%d] [AC - Balkan Security] has kicked %s for Health Hack",d,m,y,h,mi,s,ime);
				log(string);
				SetTimerEx("kick",10, false, "i", i);
			}
		}
	}
//=====================[ANTI ARMOUR HACK]================
	if(NA == 1)
	{
		if(GetPVarInt(i, "AdminProtect") == 0)
		{
			new Float:Armor;
			GetPlayerArmour(i, Armor);
			if(Armor < GetPVarFloat(i, "SafeArmour"))
			{
			    SetPVarFloat(i,"SafeArmour",Armor+2);
			}
			if(GetPVarFloat(i, "ArmourProtection") == 1)
			{
				Zastita[i] = 1;
				SetPVarFloat(i,"ArmourProtection",0);
			}
			if(Armor > GetPVarFloat(i, "SafeArmour") && Zastita[i] == 0 && kikovan[i] == 0)
			{
		    	GetPlayerName(i, ime, sizeof(ime)); kikovan[i] = 1;
		    	GetPlayerIp(i, ipadresa, sizeof(ipadresa));
				format(string, sizeof(string), "%s %s has been kicked for Armour Hack.",acime, ime);
				SendClientMessageToAll(RED, string);
				format(string2, sizeof(string2),"{CD0000}Kicked!\n{FFF8DC}Name:{CD0000} %s\n{FFF8DC}Reason:{CD0000} Armour Hack\n{FFF8DC}IP:{CD0000} %s\n \n{CD0000}If you think that you are kicked for no reason,\n press F8 and report mistake on forums.\n Web Site: %s",ime,ipadresa,forum);
				ShowPlayerDialog(i, 20000, DIALOG_STYLE_MSGBOX, "{FFF8DC}[AC - Balkan Security]",string2, "Ok", "");
				getdate(y,m,d);
				gettime(h,mi,s);
				format(string,sizeof(string), "[%d/%d/%d]-[%d:%d:%d] [AC - Balkan Security] has kicked %s for Armour Hack",d,m,y,h,mi,s,ime);
				log(string);
				SetTimerEx("kick",10, false, "i", i);
			}
		}
	}
//====================[ANTI INTERIOR HACK]======================
	if(NT == 1)
	{
		if(GetPVarInt(i, "AdminProtect") == 0)
		{
		    if(GetPVarInt(i, "SafeTeleport") == 1)
			{
			    Zastita[i] = 1;
			    SetPVarInt(i, "SafeVW", GetPlayerVirtualWorld(i));
			    SetPVarInt(i, "SafeInt", GetPlayerInterior(i));
				SetPVarInt(i, "SafeTeleport", 0);
			}
	 		if(Zastita[i] == 0 && GetPVarInt(i, "SafeTeleport") == 0 && GetPVarInt(i, "SafeInt") != GetPlayerInterior(i))
			{
				GetPlayerName(i, ime, sizeof(ime));
  				GetPlayerIp(i, ipadresa, sizeof(ipadresa));
		    	if(kikovan[i] == 0)
		    	{
		    	    kikovan[i] = 1;
					format(string, sizeof(string), "%s %s je kikovan zbog Interior Hack-a.",acime, ime);
					SendClientMessageToAll(RED, string);
					format(string2, sizeof(string2),"{CD0000}Kicked!\n{FFF8DC}Name:{CD0000} %s\n{FFF8DC}Reason:{CD0000} Interior Hack\n{FFF8DC}IP:{CD0000} %s\n \n{CD0000}If you think that you are kicked for no reason,\n press F8 and report mistake on forums.\n Web Site: %s",ime,ipadresa,forum);
					ShowPlayerDialog(i, 20000, DIALOG_STYLE_MSGBOX, "{FFF8DC}[AC - Balkan Security]",string2, "Ok", "");
					getdate(y,m,d);
					gettime(h,mi,s);
					format(string,sizeof(string), "[%d/%d/%d]-[%d:%d:%d] [AC - Balkan Security] has kicked %s for Interior Hack",d,m,y,h,mi,s,ime);
					log(string);
					SetTimerEx("kick",10, false, "i", i);
            	}
			}
		}
	}
//=====================[ANTI FLY HACK]=====================
	if(FP == 1)
	{
		if(GetPVarInt(i, "AdminProtect") == 0)
		{
			new Float:FlyPozicijaZ; new Float:FlyPozicijaY; new Float:FlyPozicijaX;
			new ankategorija[320]; new anime[320]; new Float:helti2;
    		GetAnimationName(GetPlayerAnimationIndex(i),ankategorija,320,anime,320);
			GetPlayerPos(i, FlyPozicijaX, FlyPozicijaY, FlyPozicijaZ);
			GetPlayerName(i, ime, sizeof(ime)); GetPlayerHealth(i,helti2);
			GetPlayerIp(i, ipadresa, sizeof(ipadresa));
			if(strcmp(anime,"SWIM_CRAWL", false ) == 0 && strcmp(ankategorija,"SWIM", false ) == 0)
			{
				if(!IsPlayerInAnyVehicle(i) && FlyPozicijaZ > 100 && helti2 > 2 && Zastita[i] == 0)
				{
					FlyOpomena[i] = 1;
				}
			}
			if(strcmp(anime,"SWIM_BREAST", false ) == 0 && strcmp(ankategorija,"SWIM", false ) == 0)
			{
				if(!IsPlayerInAnyVehicle(i) && FlyPozicijaZ > 100 && helti2 > 2 && Zastita[i] == 0)
				{
					FlyOpomena[i] = 1;
				}
			}
			if(strcmp(anime,"SWIM_TREAD", false ) == 0 && strcmp(ankategorija,"SWIM", false ) == 0)
			{
				if(!IsPlayerInAnyVehicle(i) && FlyPozicijaZ > 100 && helti2 > 2 && Zastita[i] == 0)
				{
					FlyOpomena[i] = 1;
				}
			}
			if(FlyOpomena[i]== 1 && kikovan[i] == 0)
			{
			    kikovan[i] = 1;
				format(string, sizeof(string), "%s %s has been kicked for Fly Hack",acime, ime);
				SendClientMessageToAll(RED, string);
				format(string2, sizeof(string2),"{CD0000}Kicked!\n{FFF8DC}Name:{CD0000} %s\n{FFF8DC}Reason:{CD0000} Fly Hack\n{FFF8DC}IP:{CD0000} %s\n \n{CD0000}If you think that you are kicked for no reason,\n press F8 and report mistake on forums.\n Web Site: %s",ime,ipadresa,forum);
				ShowPlayerDialog(i, 20000, DIALOG_STYLE_MSGBOX, "{FFF8DC}[AC - Balkan Security]",string2, "Ok", "");
				getdate(y,m,d);
				gettime(h,mi,s);
				format(string,sizeof(string), "[%d/%d/%d]-[%d:%d:%d] [AC - Balkan Security] has kicked %s for Fly Hack",d,m,y,h,mi,s,ime);
				log(string);
				FlyOpomena[i] = 0;
				SetTimerEx("kick",5, false, "i", i);
			}
		}
	}
//======================================[ANTI TELEPORT]==============================
 	if(ANT == 1)
	{
		if(GetPVarInt(i, "AdminProtect") == 0)
		{
		    new Float:TePoZ; new Float:TePoY; new Float:TePoX;
			GetPlayerPos(i, TePoX, TePoY, TePoZ);
			if(GetDistanceToPoint(i,Pozicija[i][0],Pozicija[i][1],Pozicija[i][2]) > 220 && Zastita[i] == 0 && GetPlayerInterior(i) == 0 && TePoZ >= 1 && !IsPlayerInRangeOfPoint(i, 35, 131.7287,-67.8546,1.5781) && kikovan[i] == 0 && GetPVarInt(i, "SafeTeleport") == 0 && AFK2[i] == 0)
			{
			    new ankategorija[320]; new anime[320];
    			GetAnimationName(GetPlayerAnimationIndex(i),ankategorija,320,anime,320);
				if(strcmp(anime,"FALL_FALL", false ) == 0 && strcmp(ankategorija,"PED", false ) == 0)
				{
					return 1;
				}
				if(strcmp(anime,"RUN_PLAYER", false ) == 0 && strcmp(ankategorija,"PED", false ) == 0)
				{
					return 1;
				}
				if(strcmp(anime,"WALK_PLAYER", false ) == 0 && strcmp(ankategorija,"PED", false ) == 0)
				{
					return 1;
				}
    			if(IsPlayerInRangeOfPoint(i, 5, -1935.77, 228.79, 34.16)||IsPlayerInRangeOfPoint(i, 5, -2707.48, 218.65, 4.9)||IsPlayerInRangeOfPoint(i, 5, 2645.61, -2029.15, 14.28)||IsPlayerInRangeOfPoint(i, 5, 1041.26, -1036.77, 32.48)||
				IsPlayerInRangeOfPoint(i, 5, 2387.55, 1035.70, 11.56)||IsPlayerInRangeOfPoint(i, 5, 1836.93, -1856.28, 14.13)||IsPlayerInRangeOfPoint(i, 5, 2006.11, 2292.87, 11.57)||IsPlayerInRangeOfPoint(i, 5, -1787.25, 1202.00, 25.84)||
				IsPlayerInRangeOfPoint(i, 5, 720.10, -470.93, 17.07)||IsPlayerInRangeOfPoint(i, 5, -1420.21, 2599.45, 56.43)||IsPlayerInRangeOfPoint(i, 5, -100.16, 1100.79, 20.34)||IsPlayerInRangeOfPoint(i, 5, 2078.44, -1831.44, 14.13)||
				IsPlayerInRangeOfPoint(i, 5, -2426.89, 1036.61, 51.14)||IsPlayerInRangeOfPoint(i, 5, 1957.96, 2161.96, 11.56)||IsPlayerInRangeOfPoint(i, 5, 488.29, -1724.85, 12.01)||IsPlayerInRangeOfPoint(i, 5, 1025.08, -1037.28, 32.28)||
				IsPlayerInRangeOfPoint(i, 5, 2393.70, 1472.80, 11.42)||IsPlayerInRangeOfPoint(i, 5, -1904.97, 268.51, 41.04)||IsPlayerInRangeOfPoint(i, 5, 403.58, 2486.33, 17.23)||IsPlayerInRangeOfPoint(i, 5, 1578.24, 1245.20, 11.57)||
				IsPlayerInRangeOfPoint(i, 5, -2105.79, 905.11, 77.07)||IsPlayerInRangeOfPoint(i, 5, 423.69, 2545.99, 17.07)||IsPlayerInRangeOfPoint(i, 5, 785.79, -513.12, 17.44)||IsPlayerInRangeOfPoint(i, 5, -2027.34, 141.02, 29.57)||
    			IsPlayerInRangeOfPoint(i, 5, 1698.10, -2095.88, 14.29)||IsPlayerInRangeOfPoint(i, 5, -361.10, 1185.23, 20.49)||IsPlayerInRangeOfPoint(i, 5, -2463.27, -124.86, 26.41)||IsPlayerInRangeOfPoint(i, 5, 2505.64, -1683.72, 14.25)||
				IsPlayerInRangeOfPoint(i, 5, 1350.76, -615.56, 109.88)||IsPlayerInRangeOfPoint(i, 5, 2231.64, 156.93, 27.63)
				)
				{
				    kikovan[i] = 1;
	    			format(string, sizeof(string), "%s %s has been kicked for Teleport Hack[1]",acime, ime);
					SendClientMessageToAll(RED, string);
					format(string2, sizeof(string2),"{CD0000}Kicked!\n{FFF8DC}Name:{CD0000} %s\n{FFF8DC}Reason:{CD0000} Teleport Hack[1]\n{FFF8DC}IP:{CD0000} %s\n \n{CD0000}If you think that you are kicked for no reason,\n press F8 and report mistake on forums.\n Web Site: %s",ime,ipadresa,forum);
					ShowPlayerDialog(i, 20000, DIALOG_STYLE_MSGBOX, "{FFF8DC}[AC - Balkan Security]",string2, "Ok", "");
					getdate(y,m,d);
					gettime(h,mi,s);
					format(string,sizeof(string), "[%d/%d/%d]-[%d:%d:%d] [AC - Balkan Security] has kicked %s for Teleport Hack[1]",d,m,y,h,mi,s,ime);
					log(string);
					SetTimerEx("kick",5, false, "i", i);
				}
				if(IsPlayerInRangeOfPoint(i, 5, -2695.51, 810.70, 50.57) || IsPlayerInRangeOfPoint(i, 5, 1293.61, 2529.54, 11.42)||IsPlayerInRangeOfPoint(i, 5, 1401.34, 1903.08, 11.99)||IsPlayerInRangeOfPoint(i, 5, 2436.50, 698.43, 11.60)||
				IsPlayerInRangeOfPoint(i, 5, 322.65, -1780.30, 5.55)||IsPlayerInRangeOfPoint(i, 5, 917.46, 2012.14, 11.65)||IsPlayerInRangeOfPoint(i, 5, 1641.14, -1526.87, 14.30)||IsPlayerInRangeOfPoint(i, 5, -1617.58, 688.69, -4.50)||
				IsPlayerInRangeOfPoint(i, 5, 837.05, -1101.93, 23.98)||IsPlayerInRangeOfPoint(i, 5, 2338.32, -1180.61, 1027.98)||IsPlayerInRangeOfPoint(i, 5, -975.5766, 1061.1312, 1345.6719)||IsPlayerInRangeOfPoint(i, 5, -750.80, 491.00, 1371.70)||
				IsPlayerInRangeOfPoint(i, 5, -1400.2138, 106.8926, 1032.2779)||IsPlayerInRangeOfPoint(i, 5, -2015.6638, 147.2069, 29.3127)||IsPlayerInRangeOfPoint(i, 5, 2220.26, -1148.01, 1025.80)||IsPlayerInRangeOfPoint(i, 5, -2660.6185, 1426.8320, 907.3626)||
				IsPlayerInRangeOfPoint(i, 5, -1394.20, 987.62, 1023.96)||IsPlayerInRangeOfPoint(i, 5, -1410.72, 1591.16, 1052.53)||IsPlayerInRangeOfPoint(i, 5, 315.8561, 1024.4964, 1949.7973)||IsPlayerInRangeOfPoint(i, 5, 2536.08, -1632.98, 13.79)||
				IsPlayerInRangeOfPoint(i, 5, 1992.93, 1047.31, 10.82)||IsPlayerInRangeOfPoint(i, 5, 2033.00, -1416.02, 16.99)||IsPlayerInRangeOfPoint(i, 5, -2653.11, 634.78, 14.45)||IsPlayerInRangeOfPoint(i, 5, 1580.22, 1768.93, 10.82)||
				IsPlayerInRangeOfPoint(i, 5, -1550.73, 99.29, 17.33)||IsPlayerInRangeOfPoint(i, 5, -2057.8000, 229.9000, 35.6204)||IsPlayerInRangeOfPoint(i, 5, -2366.0000, -1667.4000, 484.1011)||IsPlayerInRangeOfPoint(i, 5, 2503.7000, -1705.8000, 13.5480)||
				IsPlayerInRangeOfPoint(i, 5, 1997.9000, 1056.3000, 10.8203)||IsPlayerInRangeOfPoint(i, 5, -2872.7000, 2712.6001, 275.2690)||IsPlayerInRangeOfPoint(i, 5, 904.1000, 608.0000, -32.3281)||IsPlayerInRangeOfPoint(i, 5, -236.9000, 2663.8000, 73.6513)
				)
				{
				    kikovan[i] = 1;
					format(string, sizeof(string), "%s %s has been kicked for Teleport Hack[1]",acime, ime);
					SendClientMessageToAll(RED, string);
					format(string2, sizeof(string2),"{CD0000}Kicked!\n{FFF8DC}Name:{CD0000} %s\n{FFF8DC}Reason:{CD0000} Teleport Hack[1]\n{FFF8DC}IP:{CD0000} %s\n \n{CD0000}If you think that you are kicked for no reason,\n press F8 and report mistake on forums.\n Web Site: %s",ime,ipadresa,forum);
					ShowPlayerDialog(i, 20000, DIALOG_STYLE_MSGBOX, "{FFF8DC}[AC - Balkan Security]",string2, "Ok", "");
					getdate(y,m,d);
					gettime(h,mi,s);
					format(string,sizeof(string), "[%d/%d/%d]-[%d:%d:%d] [AC - Balkan Security] has kicked %s for Teleport Hack[1]",d,m,y,h,mi,s,ime);
					log(string);
					SetTimerEx("kick",5, false, "i", i);
				}
				if(ANT2 == 1)
				{
				    kikovan[i] = 1;
					format(string, sizeof(string), "%s %s has been kicked for Teleport Hack[2]",acime, ime);
					SendClientMessageToAll(RED, string);
					format(string2, sizeof(string2),"{CD0000}Kicked!\n{FFF8DC}Name:{CD0000} %s\n{FFF8DC}Reason:{CD0000} Teleport Hack[2]\n{FFF8DC}IP:{CD0000} %s\n \n{CD0000}If you think that you are kicked for no reason,\n press F8 and report mistake on forums.\n Web Site: %s",ime,ipadresa,forum);
					ShowPlayerDialog(i, 20000, DIALOG_STYLE_MSGBOX, "{FFF8DC}[AC - Balkan Security]",string2, "Ok", "");
					getdate(y,m,d);
					gettime(h,mi,s);
					format(string,sizeof(string), "[%d/%d/%d]-[%d:%d:%d] [AC - Balkan Security] has kicked %s for Teleport Hack[2]",d,m,y,h,mi,s,ime);
					log(string);
					SetTimerEx("kick",5, false, "i", i);
				}
			}
		}
	}
	//======================[ANTI VEHICLE REPAIR]=============================
	if(AVR == 1)
	{
		if(GetPVarInt(i, "AdminProtect") == 0)
		{
			new Float:vhelti; GetVehicleHealth(GetPlayerVehicleID(i), vhelti);
			if(GetPlayerState(i) == PLAYER_STATE_DRIVER)
			{
				if(vhelti < AutoHelti[i])
				{
	    			AutoHelti[i] = vhelti;
				}
				if(GetPVarInt(i, "VehicleRepair") == 1)
				{
				    AutoHelti[i] = vhelti;
				    SetPVarInt(i, "VehicleRepair", 0);
				}
				if(IsPlayerInRangeOfPoint(i, 15, 719.9484,-457.3498,16.4282) || IsPlayerInRangeOfPoint(i, 15, -1420.6052,2584.6243,55.9356) || IsPlayerInRangeOfPoint(i, 15, -99.7463,1116.9677,19.8340)|| IsPlayerInRangeOfPoint(i, 15, 2063.4375,-1831.9276,13.6391)||
       				IsPlayerInRangeOfPoint(i, 15, -2425.9333,1022.5239,50.4900) || IsPlayerInRangeOfPoint(i, 15, 1974.0004,2162.5266,11.1561) || IsPlayerInRangeOfPoint(i, 15, 487.5558,-1739.5125,11.2265)|| IsPlayerInRangeOfPoint(i, 15, 1025.3940,-1024.2563,32.1938)||
   					IsPlayerInRangeOfPoint(i, 15, 2393.6174,1489.2686,10.9246)||IsPlayerInRangeOfPoint(i, 15, -1905.1163,283.4408,41.1392))
				{
				    AutoHelti[i] = vhelti;
				    SetPVarInt(i, "VehicleRepair", 1);
				}
 				if(vhelti > AutoHelti[i] && Zastita[i] == 0 && GetPlayerInterior(i) == 0 && kikovan[i] == 0 && GetPVarInt(i, "VehicleRepair") == 0)
 				{
 		    		if(!IsPlayerInRangeOfPoint(i, 15, 719.9484,-457.3498,16.4282) || !IsPlayerInRangeOfPoint(i, 15, -1420.6052,2584.6243,55.9356) || !IsPlayerInRangeOfPoint(i, 15, -99.7463,1116.9677,19.8340)|| !IsPlayerInRangeOfPoint(i, 15, 2063.4375,-1831.9276,13.6391)||
       				!IsPlayerInRangeOfPoint(i, 15, -2425.9333,1022.5239,50.4900) || !IsPlayerInRangeOfPoint(i, 15, 1974.0004,2162.5266,11.1561) || !IsPlayerInRangeOfPoint(i, 15, 487.5558,-1739.5125,11.2265)|| !IsPlayerInRangeOfPoint(i, 15, 1025.3940,-1024.2563,32.1938)||
   					!IsPlayerInRangeOfPoint(i, 15, 2393.6174,1489.2686,10.9246)||!IsPlayerInRangeOfPoint(i, 15, -1905.1163,283.4408,41.1392))
   					{
 	    				kikovan[i] = 1;
						format(string, sizeof(string), "%s %s has been kicked for Vehicle Repair(Cheat)",acime, ime);
						SendClientMessageToAll(RED, string);
						format(string2, sizeof(string2),"{CD0000}Kicked!\n{FFF8DC}Name:{CD0000} %s\n{FFF8DC}Reason:{CD0000} Vehicle Repair\n{FFF8DC}IP:{CD0000} %s\n \n{CD0000}If you think that you are kicked for no reason,\n press F8 and report mistake on forums.\n Web Site: %s",ime,ipadresa,forum);
						ShowPlayerDialog(i, 20000, DIALOG_STYLE_MSGBOX, "{FFF8DC}[AC - Balkan Security]",string2, "Ok", "");
						getdate(y,m,d);
						gettime(h,mi,s);
						format(string,sizeof(string), "[%d/%d/%d]-[%d:%d:%d] [AC - Balkan Security] has kicked %s for Vehicle Repair",d,m,y,h,mi,s,ime);
						log(string);
						SetTimerEx("kick",5, false, "i", i);
					}
 				}
			}
		}
	}
	//==================================[ANTI AFK]=======================
	if(AAFK == 1)
	{
		if(GetPVarInt(i, "AdminProtect") == 0)
		{
		    if(AFK[i] >= 13 && AFK2[i] == 0)
		    {
		        AFK2[i] = 1;
			}
			if(AFK[i] > MAXAFK)
			{
			    if(kikovan[i] == 0)
				{
		    		kikovan[i] = 1;
					format(string, sizeof(string), "%s %s has been kicked for AFK (%d minutes)",acime, ime, MAXAFK/60);
					SendClientMessageToAll(RED, string);
					format(string2, sizeof(string2),"{CD0000}Kicked!\n{FFF8DC}Name:{CD0000} %s\n{FFF8DC}Reason:{CD0000} AFK (%d minutes)\n{FFF8DC}IP:{CD0000} %s\n \n{CD0000}If you think that you are kicked for no reason,\n press F8 and report mistake on forums.\n Web Site: %s",ime,MAXAFK/60,ipadresa,forum);
					ShowPlayerDialog(i, 20000, DIALOG_STYLE_MSGBOX, "{FFF8DC}[AC - Balkan Security]",string2, "Ok", "");
					getdate(y,m,d);
					gettime(h,mi,s);
					format(string,sizeof(string), "[%d/%d/%d]-[%d:%d:%d] [AC - Balkan Security] has kicked %s for AFK",d,m,y,h,mi,s,ime);
					log(string);
					SetTimerEx("kick",10, false, "i", i);
				}
			}
		}
	}
//------[end of foreach]
}
//------[end of timer]
return 1;
}
//------------------[ANTICHEAT COMMANDS]---------------------
CMD:anticheat(playerid, params[])
{
	if(!IsPlayerAdmin(playerid))
	{
		SendClientMessage(playerid, BELA, "Nisi ovlascen da koristis ovu komandu!");
		return 1;
	}
	new string[900];
	new komande[] = "1. Turn ON/OFF: Too High Ping\n2. Turn ON/OFF: Anti JetPack-a\n3. Turn ON/OFF: Anti Speed Hack\n4. Turn ON/OFF: Bad Weapons\n5. Turn ON/OFF: Anti RCON Hack\n6. Turn ON/OFF: Anti Swear\n7. Turn ON/OFF: Anti Drive By\n8. Turn ON/OFF: Anti Bunny Hop\n9. Turn ON/OFF: Anti AirBrake\n10. Turn ON/OFF: Anti Money Hack";
	new komande2[] = "\n11. Turn ON/OFF: Anti Health Hack\n12. Turn ON/OFF: Anti Armour Hack\n13. Turn ON/OFF: Anti Interior Hack\n14. Turn ON/OFF: Anti Fly Hack\n15. Turn ON/OFF: Anti Teleport[1]\n16. Turn ON/OFF: Anti Teleport[2] \n17. Turn ON/OFF: Anti Vehicle Repair\n18. Turn ON/OFF: Anti Spam\n19. Turn ON/OFF: Anti AFK";
	format(string, sizeof(string),"%s %s",komande,komande2);
	ShowPlayerDialog(playerid, 19999, DIALOG_STYLE_LIST, "[Setting AntiCheat]",string, "Ok", "Cancle");
	return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
		if(dialogid == 19999)
		{
			if(response)
			{
				if(listitem == 0) // too high ping
				{
				if(VP == 1)
				    {
				        SendClientMessage(playerid, BELA, "You have turned off High Ping Detection");
				        VP = 0;
					}
					else if(VP == 0)
					{
					    SendClientMessage(playerid, BELA, "You have turned on High Ping Detection");
				        VP = 1;
					}
				}
				else if(listitem == 1) // anti jetpack
				{
				    if(PJP == 1)
				    {
				        SendClientMessage(playerid, BELA, "You have turned off Anti JetPack");
				        PJP = 0;
					}
					else if(PJP == 0)
				    {
				        SendClientMessage(playerid, BELA, "You have turned on Anti JetPack");
				        PJP = 1;
					}
				}
				else if(listitem == 2)// anti speed
				{
				    if(PB == 1)
				    {
				        SendClientMessage(playerid, BELA, "You have turned off Anti Speed Hack");
				        PB = 0;
					}
					else if(PB == 0)
				    {
				        SendClientMessage(playerid, BELA, "You have turned on Anti Speed Hack");
				        PB = 1;
					}
				}
				else if(listitem == 3)// bad weapons
				{
				    if(ZO == 1)
				    {
				        SendClientMessage(playerid, BELA, "You have turned off Bad Weapons Detection");
				        ZO = 0;
					}
					else if(ZO == 0)
				    {
				        SendClientMessage(playerid, BELA, "You have turned on Bad Weapons Detection!");
				        ZO = 1;
					}
				}
				else if(listitem == 4) // rcon protection
				{
				    if(RCONZ == 1)
				    {
				        RCONZ = 0;
				        SendClientMessage(playerid, BELA, "You have turned off Anti RCON Hack!");
					}
					else if(RCONZ == 0)
				    {
                        RCONZ = 1;
						SendClientMessage(playerid, BELA, "You have turned on Atni RCON Hack");
					}
				}
				else if(listitem == 5) // Anti Swear
				{
				    if(ZR == 1)
				    {
				        ZR = 0;
				        SendClientMessage(playerid, BELA, "You have turned off Anti Swear!");
					}
					else if(ZR == 0)
				    {
                        ZR = 1;
						SendClientMessage(playerid, BELA, "You have turned on Anti Swear");
					}
				}
				else if(listitem == 6)// drive by
				{
				    if(DBP == 1)
				    {
				        SendClientMessage(playerid, BELA, "You have turned off Atni Drive By!");
				        DBP = 0;
					}
					else if(DBP == 0)
				    {
				        SendClientMessage(playerid, BELA, "You have turned on Anti Drive By!");
				        DBP = 1;
					}
				}
				else if(listitem == 7)// bunny hop
				{
				    if(BHP == 1)
				    {
				        SendClientMessage(playerid, BELA, "You have turned off Anti Bunny Hop!");
				        BHP = 0;
					}
					else if(BHP == 0)
				    {
				        SendClientMessage(playerid, BELA, "You have turned on Anti Bunny Hop!");
				        BHP = 1;
					}
				}
				else if(listitem == 8)// air brake
				{
				    if(PAB == 1)
				    {
				        SendClientMessage(playerid, BELA, "You have turned off Anti AirBrake!");
				        PAB = 0;
					}
					else if(PAB == 0)
				    {
				        SendClientMessage(playerid, BELA, "You have turned on Anti AirBrake!");
				        PAB = 1;
					}
				}
				else if(listitem == 9)// anty money
				{
				    if(NN == 1)
				    {
				        SendClientMessage(playerid, BELA, "You have turned off Anti Money Hack!");
				        NN = 0;
					}
					else if(NN == 0)
				    {
				        SendClientMessage(playerid, BELA, "You have turned on Anti Money Hack!");
				        NN = 1;
					}
				}
				else if(listitem == 10)// anti health
				{
				    if(NH == 1)
				    {
				        SendClientMessage(playerid, BELA, "You have turned off Anti Health Hack!");
				        NH = 0;
					}
					else if(NH == 0)
				    {
				        SendClientMessage(playerid, BELA, "You have turned on Anti Health Hack!");
				        NH = 1;
					}
				}
				else if(listitem == 11)// anti armour
				{
				    if(NA == 1)
				    {
				        SendClientMessage(playerid, BELA, "You have turned off Anti Armour Hack!");
				        NA = 0;
					}
					else if(NA == 0)
				    {
				        SendClientMessage(playerid, BELA, "You have turned on Anti Armour Hack!");
				        NA = 1;
					}
				}
				else if(listitem == 12)// anti interior teleport
				{
				    if(NT == 1)
				    {
				        SendClientMessage(playerid, BELA, "You have turned off Anti Teleport[INT]!!!");
				        NT = 0;
					}
					else if(NT == 0)
				    {
				        SendClientMessage(playerid, BELA, "You have turned on Anti Teleport[INT]!!!");
				        NT = 1;
					}
				}
				else if(listitem == 13)// anti fly hack
				{
				    if(FP == 1)
				    {
				        SendClientMessage(playerid, BELA, "You have turned off Anti Fly Hack!");
				        FP = 0;
					}
					else if(FP == 0)
				    {
				        SendClientMessage(playerid, BELA, "You have turned on Anti Fly Hack!");
				        FP = 1;
					}
				}
				else if(listitem == 14)// anti teleport[1]
				{
				    if(ANT == 1)
				    {
				        SendClientMessage(playerid, BELA, "You have turned off Anti Teleport[1]");
				        ANT = 0;
					}
					else if(ANT == 0)
				    {
				        SendClientMessage(playerid, BELA, "You have turned on Anti Teleport[1]!");
				        ANT = 1;
					}
				}
				else if(listitem == 15)// anti teleport[2]
				{
				    if(ANT2 == 1)
				    {
				        SendClientMessage(playerid, BELA, "You have turned off Anti Teleport[2]");
				        ANT2 = 0;
					}
					else if(ANT2 == 0)
				    {
				        SendClientMessage(playerid, BELA, "You have turned on Anti Teleport[2]!");
				        ANT2 = 1;
					}
				}
				else if(listitem == 16)// anti vehicle repair
				{
				    if(AVR == 1)
				    {
				        SendClientMessage(playerid, BELA, "You have turned off Anti Vehicle Repair");
				        AVR = 0;
					}
					else if(AVR == 0)
				    {
				        SendClientMessage(playerid, BELA, "You have turned on Anti Vehicle Repair!");
				        AVR = 1;
					}
				}
				else if(listitem == 17)// anti spam
				{
				    if(AS == 1)
				    {
				        SendClientMessage(playerid, BELA, "You have turned off Anti Spam");
				        AS = 0;
					}
					else if(AS == 0)
				    {
				        SendClientMessage(playerid, BELA, "You have turned on Anti Spam!");
				        AS = 1;
					}
				}
				else if(listitem == 18)// anti afk
				{
				    if(AAFK == 1)
				    {
				        SendClientMessage(playerid, BELA, "You have turned off Anti AFK");
				        AAFK = 0;
					}
					else if(AAFK == 0)
				    {
				        SendClientMessage(playerid, BELA, "You have turned on Anti AFK!");
				        AAFK = 1;
					}
				}
			}
			SnimiAC();
		}
		return 1;
}
#error READ INSTALATION.TXT FOR SECOND TIME
