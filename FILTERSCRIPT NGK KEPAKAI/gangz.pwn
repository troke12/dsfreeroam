/*==============================================================================


			================                    ==============
			|               \                   |
			|                \                  |
			|                 \                 |
			|                  |     --         |       =======
			|                 /                 |       |     |
			|                /                  |             |
			=================                   ===============

Script Name:- -=Dar[K]Lords=- Gang System!
Script Owner:- -=Dar[K]Lord=-

--------------------------------------------------------------------------------\
ChangeLogs 1.0:-
The Gang System Was Created.
Commands:-
/gangcreate
/ganginvite
/gangleave
/gangmakeadmin
/gangremoveadmin
/gangstats

ChangeLogs 1.1v:-

Manager Security [ Gang Manager ] Increased by almost 30%
As i added a dynamic gang manager pass which can be changed by rcon admins only

Commands Were added and some were updated
/gangstats - Advanced now , wont compare files as it might take time so it compares variables
/addgangbase - adds a base to gang so gang members can tele to /base
/base - default command for teleproting to their gang base.
/removegangbase - Ofcouse the opposite happens,i.e. it removes the base of gang
/changegangmanagerpass - Changes the manager pass

For Gang Members Were Added

Main Commands like:-
/gangmanagerlogin - Password can be changed in game now
/removegang - removes a gang you need the id!
/gangstatus - will check the gang is valid or not so that gang manager feels it easy

This Script Was Originally Made by -=Dar[K]Lord=-.
Testers:-
Jake_Hero

You Can Edit This Script But You Have To Keep The Credits Of The Gang System.
CopyRight. All Right Reserved!
===============================================================================*/
#include <a_samp>
#include <dini>
#include <ZCMD>
#include <sscanf>

#define         White       0xFFFFFFFF
#define         LightRed    0xF00000FF
#define         LightRed2   0xFF4848FF
#define         Gang_Chat_Color 0x8080FFFF
#define         Red         0xFF0000FF
#define         Green       0x00FF00FF
#define 		LightBlue   0xF6BB0AA
#define			LightBlue1 	0x5555EE33

#define         DefaultPass "DEFAULT_PASS"

#define         ERROR_DIALOG    5100
#define         DIALOG    4150

#define MAX_GANGS 2000

#define INVALID_GANG_ID     -1
#define INVALID_GANG_NAME   "No-Gang"
#define INVALID_GANG_ADMIN  "No-Admin"

#define 	SERVER_NAME     "Drift Stunting Indonesia"

#define     GANG_SCORE_NEEDED   2000
#define     GANG_MONEY_NEEDED   2000000

native WP_Hash(buffer[],len,const str[]);

enum pDat
{
	GangID,
	RecentGangCall,
	InGang,
	FPS,
	DLlast
}
enum gDat
{
	GangKills,
	GangDeaths,
	bool:FileExists,
	Float:BASE_X,
	Float:BASE_Y,
	Float:BASE_Z,
	Float:BASE_Angle,
	GangCash
}
new GangDat[MAX_GANGS][gDat];
new PlayerDat[MAX_PLAYERS][pDat],
	FPSTimer[MAX_PLAYERS],
	GangManager[MAX_PLAYERS],
	UpdateText[MAX_PLAYERS];

new PlayerText:FPSCount;

public OnFilterScriptInit()
{
	print("=============================================\n");
	print("DGang 1.1v System Made By -=Dar[K]Lord=- Loaded");
	printf("ChangeLogs:-\n>. Little Modification in /topgangs");
	printf(">.Manager Pass Now Can Be Changed!");
	print("\n=============================================");
	for(new i = 0; i < MAX_PLAYERS; i++)
	if(IsPlayerConnected(i))
	OnPlayerConnect(i);
	LoadGangs();
	if(!dini_Exists(GMPassFile()))
	{
	    new buf[129];
		WP_Hash(buf, sizeof(buf),DefaultPass);
	    dini_Create(GMPassFile());
	    dini_Set(GMPassFile(),"Password",buf);
	    return 1;
	}
	return 1;
}
public OnFilterScriptExit()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	if(IsPlayerConnected(i))
	PlayerTextDrawHide(i,FPSCount);
	return 1;
}
stock LoadGangs()
{
	for(new i = 0; i < MAX_GANGS; i++)
	{
		if(dini_Exists(gFileId(i)))
		{
			GangDat[i][GangKills] = dini_Int(gFileId(i),"Kills");
            GangDat[i][GangDeaths] = dini_Int(gFileId(i),"Deaths");
            GangDat[i][GangCash] = dini_Int(gFileId(i),"GangCash");
            GangDat[i][FileExists] = true;
		}
	}
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if(text[0] == '$' && PlayerDat[playerid][InGang] == 1)
	{
 		new string[256];
		format(string,sizeof(string),"[{FFFFFF}GANGCHAT{8080FF}] %s(%d): %s",pName(playerid),playerid,text[1]);
		SendMessageToGangMembers(PlayerDat[playerid][GangID],Gang_Chat_Color,string);
	    return 0;
	}
	return 1;
}
public OnPlayerConnect(playerid)
{
	new string[256];
	format(string,sizeof(string),"FPS: %d Ping: %d",GetPlayerFPS(playerid),GetPlayerPing(playerid));
	FPSCount = CreatePlayerTextDraw(playerid,500.000000, 6.000000,string);
	PlayerTextDrawAlignment(playerid,FPSCount,0);
	PlayerTextDrawBackgroundColor(playerid,FPSCount, 255);
	PlayerTextDrawFont(playerid,FPSCount, 1);
 	PlayerTextDrawLetterSize(playerid,FPSCount,  0.34567, 1.1452);
	PlayerTextDrawColor(playerid,FPSCount, -1);
	PlayerTextDrawSetOutline(playerid,FPSCount, 1);
	PlayerTextDrawUseBox(playerid,FPSCount,1);
	PlayerTextDrawBoxColor(playerid,FPSCount,0x00000054);
	PlayerTextDrawShow(playerid,FPSCount);
    GangManager[playerid] = 0;
	if(dini_Exists(pFile(playerid)))
	{
	    LoginPlayer(playerid);
	}
	else
	{
	    CreateFile(playerid);
	}
 	FPSTimer[playerid] = SetTimerEx("GetPlayerFPS",100,1,"d",playerid);
 	UpdateText[playerid] = SetTimerEx("FPSPingUpdate",99,1,"d",playerid);
	return 1;
}
forward FPSPingUpdate(playerid);
public FPSPingUpdate(playerid)
{
	if(GetPlayerPing(playerid) < 201)
	{
		new string[256];
		format(string,sizeof(string),"FPS: %d Ping: %d",GetPlayerFPS(playerid),GetPlayerPing(playerid));
		PlayerTextDrawSetString(playerid,FPSCount,string);
	}
	else if(GetPlayerPing(playerid) > 200 && GetPlayerPing(playerid) < 301)
	{
		new string[256];
		format(string,sizeof(string),"FPS: %d ~r~~h~~h~Ping: %d",GetPlayerFPS(playerid),GetPlayerPing(playerid));
		PlayerTextDrawSetString(playerid,FPSCount,string);
	}
	else if(GetPlayerPing(playerid) > 300 && GetPlayerPing(playerid) < 401)
	{
		new string[256];
		format(string,sizeof(string),"FPS: %d ~r~~h~Ping: %d",GetPlayerFPS(playerid),GetPlayerPing(playerid));
		PlayerTextDrawSetString(playerid,FPSCount,string);
	}
	else if(GetPlayerPing(playerid) > 400 && GetPlayerPing(playerid) < 501)
	{
		new string[256];
		format(string,sizeof(string),"FPS: %d ~r~Ping: %d",GetPlayerFPS(playerid),GetPlayerPing(playerid));
		PlayerTextDrawSetString(playerid,FPSCount,string);
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(PlayerDat[playerid][InGang] == 1)
	{
		dini_IntSet(gFileId(PlayerDat[playerid][GangID]),"Deaths",dini_Int(gFileId(PlayerDat[playerid][GangID]),"Deaths")+1);
	}
	if(PlayerDat[playerid][InGang] == 1)
	{
		dini_IntSet(gFileId(PlayerDat[killerid][GangID]),"Kills",dini_Int(gFileId(PlayerDat[killerid][GangID]),"Kills")+1);
	}
	return 1;
}
CMD:gangcmds(playerid,params[])
{
	new string[256];
	format(string,sizeof(string),"\t{FFFFFF}%s{FE0000}Gang Commands!\n\n{FFFFFF}/creategang - Needs %d Score And $%d Money\n/ganginvite - For Owners/Admins of gang To invite players to join gang\n/leavegang - To leave the existing gang\n/makegangadmin - Only for admins\n/gangjoin - Join A gang who invited you",SERVER_NAME,GANG_SCORE_NEEDED,GANG_MONEY_NEEDED);
	ShowPlayerDialog(playerid,5199,DIALOG_STYLE_MSGBOX,"Gang Commands!",string,"Ok","");
	return 1;
}
CMD:investgangcash(playerid,params[])
{
	new cash = strval(params);
	if(sscanf(params,"i",cash))return ShowPlayerDialog(playerid,ERROR_DIALOG+10,DIALOG_STYLE_MSGBOX,"ERROR!","{FFFFFF}[Usage]:- {EA0000}/investgangcash [money]","Ok","");
	if(PlayerDat[playerid][InGang] == 0) return SendClientMessage(playerid,White,"[ERROR]:- {EA0000}You Aren't in a gang!");
	if(!strcmp(pName(playerid),dini_Get(gFile(dini_Get(pFile(playerid),"GangName")),"GangAdmin_3"),false) || !strcmp(pName(playerid),dini_Get(gFile(dini_Get(pFile(playerid),"GangName")),"GangAdmin_2"),true) ||  !strcmp(pName(playerid),dini_Get(gFile(dini_Get(pFile(playerid),"GangName")),"GangAdmin_4"),true) || !strcmp(pName(playerid),dini_Get(gFile(dini_Get(pFile(playerid),"GangName")),"Owner"),true))
	{
		if(cash < 1 ) return SendClientMessage(playerid,White,"[ERROR]:- {EA0000}Wrong Value!");
		GangDat[PlayerDat[playerid][GangID]][GangCash] += cash;
		GivePlayerMoney(playerid,-cash);
		dini_IntSet(gFileId(PlayerDat[playerid][GangID]),"GangCash",GangDat[PlayerDat[playerid][GangID]][GangCash]);
		return 1;
	}
	else return SendClientMessage(playerid,White,"[ERROR]: {EA0000}You Aren't a Admin or owner of this gang");
}
CMD:withdrawgangcash(playerid,params[])
{
	new cash = strval(params);
	if(sscanf(params,"i",cash))return ShowPlayerDialog(playerid,ERROR_DIALOG+10,DIALOG_STYLE_MSGBOX,"ERROR!","{FFFFFF}[Usage]:- {EA0000}/investgangcash [money]","Ok","");
	if(PlayerDat[playerid][InGang] == 0) return SendClientMessage(playerid,White,"[ERROR]:- {EA0000}You Aren't in a gang!");
	if(!strcmp(pName(playerid),dini_Get(gFile(dini_Get(pFile(playerid),"GangName")),"GangAdmin_3"),false) || !strcmp(pName(playerid),dini_Get(gFile(dini_Get(pFile(playerid),"GangName")),"GangAdmin_2"),true) ||  !strcmp(pName(playerid),dini_Get(gFile(dini_Get(pFile(playerid),"GangName")),"GangAdmin_4"),true) || !strcmp(pName(playerid),dini_Get(gFile(dini_Get(pFile(playerid),"GangName")),"Owner"),true))
	{
		if(cash < 1 ) return SendClientMessage(playerid,White,"[ERROR]:- {EA0000}Wrong Value!");
		GangDat[PlayerDat[playerid][GangID]][GangCash] -= cash;
		GivePlayerMoney(playerid,cash);
		dini_IntSet(gFileId(PlayerDat[playerid][GangID]),"GangCash",GangDat[PlayerDat[playerid][GangID]][GangCash]);
		return 1;
	}
	else return SendClientMessage(playerid,White,"[ERROR]: {EA0000}You Aren't a Admin or owner of this gang");
}
CMD:addgangbase(playerid,params[])
{
	new gangid = strval(params);
	if(GangManager[playerid] == 0)return SendClientMessage(playerid,White,"[ERROR]:- {EA0000}You Arent A GangManager to use this command!");
	if(sscanf(params,"i",gangid))return ShowPlayerDialog(playerid,ERROR_DIALOG+9,DIALOG_STYLE_MSGBOX,"ERROR!","{FFFFFF}[Usage]:- {EA0000}/addgangbase [gangid]","Ok","");
	if(!dini_Exists(gFileId(gangid)))return SendClientMessage(playerid,White,"[ERROR]:- {EA0000}There is no such gang!");
	new Float:X,Float:Y,Float:Z,Float:Angle;
	GetPlayerPos(playerid,X,Y,Z);
	GetPlayerFacingAngle(playerid,Angle);
	dini_IntSet(gFileId(gangid),"GangHasABase",1);
	dini_FloatSet(gFileId(gangid),"Base_X",X);
	dini_FloatSet(gFileId(gangid),"Base_Y",Y);
	dini_FloatSet(gFileId(gangid),"Base_Z",Z);
	dini_FloatSet(gFileId(gangid),"Base_Angle",Angle);
	new string[256];
	format(string,sizeof(string),"[GANG] {FF9900}%d(%s)'s Gang Base Position Has Been Set To X:%f, Y:%f, Z:%f, Angle:%f",gangid,dini_Get(gFileId(gangid),"GangName"),X,Y,Z,Angle);
	SendClientMessage(playerid,White,string);
	return 1;
}
CMD:removegangbase(playerid,params[])
{
	new gangid = strval(params);
	if(GangManager[playerid] == 0)return SendClientMessage(playerid,White,"[ERROR]:- {EA0000}You Arent A GangManager to use this command!");
	if(sscanf(params,"i",gangid))return ShowPlayerDialog(playerid,ERROR_DIALOG+9,DIALOG_STYLE_MSGBOX,"ERROR!","{FFFFFF}[Usage]:- {EA0000}/removegangbase [gangid]","Ok","");
	if(!dini_Exists(gFileId(gangid)))return SendClientMessage(playerid,White,"[ERROR]:- {EA0000}There is no such gang!");
	dini_IntSet(gFileId(gangid),"GangHasABase",0);
	dini_FloatSet(gFileId(gangid),"Base_X",0.0);
	dini_FloatSet(gFileId(gangid),"Base_Y",0.0);
	dini_FloatSet(gFileId(gangid),"Base_Z",0.0);
	dini_FloatSet(gFileId(gangid),"Base_Angle",0.0);
	new string[256];
	format(string,sizeof(string),"[GANG] {FF9900}%d(%s)'s Gang Base Has Been Removed",gangid,dini_Get(gFileId(gangid),"GangName"));
	SendClientMessage(playerid,White,string);
	return 1;
}
CMD:base(playerid,params[])
{
	if(PlayerDat[playerid][InGang] == 1)
	{
		if(dini_Int(gFileId(PlayerDat[playerid][GangID]),"GangHasABase") == 1)
		{
			SetPlayerPos(playerid,dini_Float(gFileId(PlayerDat[playerid][GangID]),"Base_X"),dini_Float(gFileId(PlayerDat[playerid][GangID]),"Base_Y"),dini_Float(gFileId(PlayerDat[playerid][GangID]),"Base_Z"));
			SetPlayerFacingAngle(playerid,dini_Float(gFileId(PlayerDat[playerid][GangID]),"Base_Angle"));
		  	new string[256];
			format(string,sizeof(string),"[GANG] {FF9900}You Have Teleported To Your Gang Base!");
			SendClientMessage(playerid,White,string);
			return 1;
		}
		else return SendClientMessage(playerid,White,"[ERROR]:- {EA0000}Your Gang Doesnt Have A Base!");
	}
	else return SendClientMessage(playerid,White,"[ERROR]:- {EA0000}You Arent In A Gang");
}
CMD:cgmp(playerid,params[])
{
	cmd_changegangmanagerpass(playerid,params);
	return 1;
}
CMD:changegangmanagerpass(playerid,params[])
{
	if(!IsPlayerAdmin(playerid))return SendClientMessage(playerid,White,"[ERROR]:- {EA0000}You Arent A Rcon Admin to use this command!");
	if(sscanf(params,"c",params))return ShowPlayerDialog(playerid,ERROR_DIALOG+8,DIALOG_STYLE_MSGBOX,"ERROR!","{FFFFFF}[Usage]:- {EA0000}/changegangmanagerpassword [newpass]","Ok","");
	new buf[129];
	WP_Hash(buf,sizeof(buf),params);
	if(!dini_Exists(GMPassFile()))
	{
	    dini_Create(GMPassFile());
	    dini_Set(GMPassFile(),"Password",buf);
	}
	else
	{
	    dini_Set(GMPassFile(),"Password",buf);
	}
	new string[256];
	format(string,sizeof(string),">> [ManagerPasschange]:- You Have Changed the Gang Manager Password To %s",params);
	SendClientMessage(playerid,0xEA0000,string);
	return 1;
}
CMD:creategang(playerid,params[])
{
	if(sscanf(params,"c",params))return ShowPlayerDialog(playerid,ERROR_DIALOG+1,DIALOG_STYLE_MSGBOX,"ERROR!","{FFFFFF}[Usage]:- {EA0000}/creategang [gangname]","Ok","");
	if(PlayerDat[playerid][InGang] == 1)return SendClientMessage(playerid,White,"[ERROR]:- {EA0000}You Are Already In A Gang");
	if(GetPlayerScore(playerid) < GANG_SCORE_NEEDED) return SendClientMessage(playerid,White,"[ERROR]:- {EA0000}You Need 2000 Score for creating a gang!");
	if(GetPlayerMoney(playerid) < GANG_MONEY_NEEDED)return SendClientMessage(playerid,White,"[ERROR]:- {EA0000}You Need $2,000,000 Score for creating a gang!");
	if(dini_Exists(gFile(params)))return SendClientMessage(playerid,White,"[ERROR]:- {EA0000}This Gang Name Has Already Been Taken!");
	new Gangid = random(2000);
	dini_Create(gFile(params));
	dini_Set(gFile(params),"GangOwner",pName(playerid));
	dini_Set(gFile(params),"GangAdmin_1",pName(playerid));
	dini_Set(gFile(params),"GangAdmin_2",INVALID_GANG_ADMIN);
	dini_Set(gFile(params),"GangAdmin_3",INVALID_GANG_ADMIN);
	dini_Set(gFile(params),"GangAdmin_4",INVALID_GANG_ADMIN);
	dini_IntSet(gFile(params),"GangID",Gangid);
/*==============================================================================
	Gang Creation By ID
==============================================================================*/
	dini_Create(gFileId(Gangid));
	dini_Set(gFileId(Gangid),"GangName",params);
	dini_IntSet(gFileId(Gangid),"Kills",0);
	dini_IntSet(gFileId(Gangid),"Deaths",0);
	dini_IntSet(gFileId(Gangid),"GangHasABase",0);
	dini_FloatSet(gFileId(Gangid),"Base_X",0.0);
	dini_FloatSet(gFileId(Gangid),"Base_Y",0.0);
	dini_FloatSet(gFileId(Gangid),"Base_Z",0.0);
	dini_FloatSet(gFileId(Gangid),"Base_Angle",0.0);
	dini_IntSet(gFileId(Gangid),"GangCash",0);
/*==============================================================================
	Setting The Players Gang
==============================================================================*/
	dini_Set(pFile(playerid),"GangName",params);
	dini_IntSet(pFile(playerid),"GangID",Gangid);
	dini_IntSet(pFile(playerid),"InAGang",1);
	GivePlayerMoney(playerid,-GANG_MONEY_NEEDED);
	new string[256];
	format(string,sizeof(string),"***Player %s(%d) Has Created A Gang %s[GANGID:- %d]",pName(playerid),playerid,params,Gangid);
	SendClientMessageToAll(Green,string);
	PlayerDat[playerid][InGang] = 1;
	GangDat[Gangid][FileExists] = true;
	LoginPlayerAgain(playerid);
	return 1;
}

CMD:fps(playerid,params[])
{
	new player1 = strval(params);
	if(sscanf(params,"u",player1))return ShowPlayerDialog(playerid,ERROR_DIALOG+2,DIALOG_STYLE_MSGBOX,"ERROR!","{FFFFFF}[Usage]:- {EA0000}/fps [playerid]","Ok","");
	if(!IsPlayerConnected(player1))return SendClientMessage(playerid,0xFF0000FF,"[ERROR]:- {FFFFFF}Player Not Connected!");
	new string[256];
	format(string,sizeof(string),"PlayerName: {FFFFFF}%s[%d] , {00F311}FPS:- {FFFFFF}%d",pName(player1),player1,GetPlayerFPS(player1));
	SendClientMessage(playerid,Green,string);
	return 1;
}
CMD:topgangs(playerid,params[])
{

	new string[1000], Slot1 = -1, Slot2 = -1, Slot3 = -1, Slot4 = -1,Slot5 = -1;
 	new Kills = -9999;
	for(new x=0; x<2000; x++)
	if(GangDat[x][FileExists] == true)
	if(GangDat[x][GangKills] >= Kills)
	{
		Kills = dini_Int(gFileId(x),"Kills");
		Slot1 = x;
	}
	Kills = -9999;
	for(new x=0; x<2000; x++)
	if(GangDat[x][FileExists] == true && x != Slot1)
	if(GangDat[x][GangKills] >= Kills)
	{
		Kills = dini_Int(gFileId(x),"Kills");
		Slot2 = x;
	}
	Kills = -9999;
	for(new x=0; x<2000; x++)
	if(GangDat[x][FileExists] == true && x != Slot1 && x != Slot2)
	if(GangDat[x][GangKills] >= Kills)
	{
		Kills = dini_Int(gFileId(x),"Kills");
		Slot3 = x;
	}
	Kills = -9999;
	for(new x=0; x<2000; x++)
	if(GangDat[x][FileExists] == true && x != Slot1 && x != Slot2 && x != Slot3)
	if(GangDat[x][GangKills] >= Kills)
	{
		Kills = dini_Int(gFileId(x),"Kills");
		Slot4 = x;
	}
	Kills = -9999;
	for(new x=0; x<2000; x++)
	if(GangDat[x][FileExists] == true && x != Slot1 && x != Slot2 && x != Slot3 && x != Slot4)
	if(GangDat[x][GangKills] >= Kills)
	{
		Kills = dini_Int(gFileId(x),"Kills");
		Slot5 = x;
	}
	if(Slot1 != -1)
	{
		format(string, sizeof(string), "{FFFFFF}\t|_%s Top 5 Gangs_|\n{FF0000}1st. Gang %s[GangID %d] Kills: %d , Deaths: %d",SERVER_NAME,dini_Get(gFileId(Slot1),"GangName"),Slot1,dini_Int(gFileId(Slot1),"Kills"),dini_Int(gFileId(Slot1),"Deaths"));
	}
	if(Slot2 != -1)
	{
		format(string, sizeof(string), "%s\n{EE0000}2nd.  Gang %s[GangID %d] Kills: %d , Deaths: %d",string,dini_Get(gFileId(Slot2),"GangName"),Slot2,dini_Int(gFileId(Slot2),"Kills"),dini_Int(gFileId(Slot2),"Deaths"));
	}
	if(Slot3 != -1)
	{
		format(string, sizeof(string), "%s\n{FF4848}3rd. Gang %s[GangID %d] Kills: %d , Deaths: %d",string,dini_Get(gFileId(Slot3),"GangName"),Slot3,dini_Int(gFileId(Slot3),"Kills"),dini_Int(gFileId(Slot3),"Deaths"));

	}
	if(Slot4 != -1)
	{
		format(string, sizeof(string), "%s\n{8080FF}4th. Gang %s[GangID %d] Kills: %d , Deaths: %d",string,dini_Get(gFileId(Slot4),"GangName"),Slot4,dini_Int(gFileId(Slot4),"Kills"),dini_Int(gFileId(Slot4),"Deaths"));
	}
	if(Slot5 != -1)
	{
		format(string, sizeof(string), "%s\n{F0EEBB}5th. Gang %s[GangID %d] Kills: %d , Deaths: %d",string,dini_Get(gFileId(Slot5),"GangName"),Slot5,dini_Int(gFileId(Slot5),"Kills"),dini_Int(gFileId(Slot5),"Deaths"));
	}
	ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_MSGBOX,"Top 10 Gangs",string,"Ok","");
	if(Slot1 == -1) ShowPlayerDialog(playerid,DIALOG+1,DIALOG_STYLE_MSGBOX,"Top 10 Gangs","\n{FFFFFF}Server\n{FF0000}No Top Gangs Yet!\n\n","Ok","");
	return 1;
}
CMD:ganginvite(playerid,params[])
{
	new player1 = strval(params);
	if(sscanf(params,"u",player1))return ShowPlayerDialog(playerid,ERROR_DIALOG+3,DIALOG_STYLE_MSGBOX,"ERROR!","{FFFFFF}[Usage]:- {EA0000}/ganginvite [playerid]","Ok","");
	if(PlayerDat[playerid][InGang] == 0)return SendClientMessage(playerid,Red,"[ERROR]:- {EA0000}You Are Not In A Gang");
	if(!strcmp(pName(playerid),dini_Get(gFile(dini_Get(pFile(playerid),"GangName")),"GangAdmin_3"),false) || !strcmp(pName(playerid),dini_Get(gFile(dini_Get(pFile(playerid),"GangName")),"GangAdmin_2"),true) ||  !strcmp(pName(playerid),dini_Get(gFile(dini_Get(pFile(playerid),"GangName")),"GangAdmin_4"),true) || !strcmp(pName(playerid),dini_Get(gFile(dini_Get(pFile(playerid),"GangName")),"Owner"),true))
	{
		if(PlayerDat[player1][InGang] == 1)return SendClientMessage(playerid,Red,"[ERROR]:- {EA0000}The Player Is Already In A Gang");
		new string[256];
		format(string,sizeof(string),"***Admin Of Gang %s Has Requested %s To Join the Gang.Waiting Him/Her To Do /gangjoin",pName(playerid),pName(player1));
		SendMessageToGangMembers(PlayerDat[playerid][GangID],LightRed2,string);
		format(string,sizeof(string),"***Admin Of Gang %s Has Requested You To Join the Gang %s",pName(playerid),dini_Get(pFile(playerid),"GangName"));
		SendClientMessage(player1,LightRed,string);
		dini_Set(pFile(player1),"RecentGangCallName",dini_Get(pFile(playerid),"GangName"));
		return PlayerDat[player1][RecentGangCall] = PlayerDat[playerid][GangID];
	}
	else return SendClientMessage(playerid,Red,"[ERROR]:- {EA0000}You Are Not A Gang Owner");
}
CMD:gangjoin(playerid,params[])
{
	if(PlayerDat[playerid][RecentGangCall] == -1) return SendClientMessage(playerid,Red,"[ERROR]:- {EA0000}You Arent Invited By A Gang!");
	if(PlayerDat[playerid][InGang] == 1)return SendClientMessage(playerid,Red,"[ERROR]:- {EA0000}You Are Already In A Gang");
	dini_Set(pFile(playerid),"GangName",dini_Get(pFile(playerid),"RecentGangCallName"));
	dini_IntSet(pFile(playerid),"GangID",PlayerDat[playerid][RecentGangCall]);
	dini_IntSet(pFile(playerid),"InAGang",1);
	dini_Set(pFile(playerid),"RecentGangCallName","NO-GANG-CALLED");
	PlayerDat[playerid][GangID] = PlayerDat[playerid][RecentGangCall];
	PlayerDat[playerid][InGang] = 1;
	new string[256];
	format(string,sizeof(string),"[GANG]{FF9900} Player %s Has Joined the Gang.Welcome!",pName(playerid));
	SendMessageToGangMembers(PlayerDat[playerid][GangID],LightRed2,string);
	LoginPlayerAgain(playerid);
	return 1;
}
CMD:gangmanagerlogin(playerid,params[])
{
	new buf[129];
	if(sscanf(params,"c",params))return ShowPlayerDialog(playerid,ERROR_DIALOG+4,DIALOG_STYLE_MSGBOX,"ERROR!","{FFFFFF}[Usage]:- {EA0000}/gangmanagerlogin [password]","Ok","");
	WP_Hash(buf,sizeof(buf),params);
	if(!strcmp(dini_Get(GMPassFile(),"Password"),buf,false))
	{
	    if(GangManager[playerid] == 1) return 1;
		GangManager[playerid] = 1;
		SendClientMessage(playerid,0x00F000FF,"You Have Logged In As A Gang Manager!");
		return 1;
	}
	else return SendClientMessage(playerid,Red,"[ERROR]:- {EA0000}Wrong Pass!");
}
CMD:removegangadmin(playerid,params[])
{
	new slot = strval(params);
	if(sscanf(params,"i",slot))ShowPlayerDialog(playerid,ERROR_DIALOG+4,DIALOG_STYLE_MSGBOX,"ERROR!","{FFFFFF}[Usage]:- {EA0000}/removegangadmin [slot]","Ok","");
	if(PlayerDat[playerid][InGang] == 0)return SendClientMessage(playerid,Red,"[ERROR]:- {EA0000}You Are Not In A Gang");
	if(!strcmp(pName(playerid),dini_Get(gFile(dini_Get(pFile(playerid),"GangName")),"GangOwner"),false))
	{
		if(slot < 0 || slot > 3) return SendClientMessage(playerid,Red,"[ERROR]:- {EA0000}Invalid Slot! Slots Available 1 - 3");
	    if(slot == 1)
	    {

			dini_Set(gFile(dini_Get(pFile(playerid),"GangName")),"GangAdmin_2",INVALID_GANG_ADMIN);
			new string[256];
			format(string,sizeof(string),"[GANG] {FF9900}GangAdmin %s Has Removed A Gang Admin!",pName(playerid));
			SendMessageToGangMembers(PlayerDat[playerid][GangID],LightRed2,string);
			return 1;
		}
		else if(slot == 2)
	    {
			dini_Set(gFile(dini_Get(pFile(playerid),"GangName")),"GangAdmin_3",INVALID_GANG_ADMIN);
			new string[256];
			format(string,sizeof(string),"[GANG] {FF9900}GangAdmin %s Has Removed A Gang Admin!",pName(playerid));
			SendMessageToGangMembers(PlayerDat[playerid][GangID],LightRed2,string);
			return 1;
		}
		else if(slot == 3)
	    {
			dini_Set(gFile(dini_Get(pFile(playerid),"GangName")),"GangAdmin_4",INVALID_GANG_ADMIN);
			new string[256];
			format(string,sizeof(string),"[GANG] {FF9900}GangAdmin %s Has Removed A Gang Admin!",pName(playerid));
			SendMessageToGangMembers(PlayerDat[playerid][GangID],LightRed2,string);
			return 1;
		}
		return 1;
	}
	else return SendClientMessage(playerid,Red,"[ERROR]:- {EA0000}You Are Not A Gang Owner");
}
CMD:makegangadmin(playerid,params[])
{
	new player1 = strval(params);
	new slot = strval(params);
	if(sscanf(params,"ui",player1,slot))return ShowPlayerDialog(playerid,ERROR_DIALOG+5,DIALOG_STYLE_MSGBOX,"ERROR!","{FFFFFF}[Usage]:- {EA0000}/makegangadmin [playerid] [slot]","Ok","");
	if(PlayerDat[playerid][InGang] == 0)return SendClientMessage(playerid,Red,"[ERROR]:- {EA0000}You Are Not In A Gang");
	if(PlayerDat[player1][InGang] == 0)return SendClientMessage(playerid,Red,"[ERROR]:- {EA0000}The Player Is Not In A Gang");
	if(!IsPlayerConnected(player1))return SendClientMessage(playerid,Red,"[ERROR]:- {EA0000}Player Not Connected!");
	if(player1 == playerid) return SendClientMessage(playerid,Red,"[ERROR]:- {EA0000}You Are Already The Owner Of This Gang!");
	if(strcmp(dini_Get(pFile(player1),"GangName"),dini_Get(pFile(playerid),"GangName"),true))return SendClientMessage(playerid,Red,"[ERROR]:- {EA0000}Player Isnt In your gang");
	new string[256];
	if(!strcmp(pName(playerid),dini_Get(gFile(dini_Get(pFile(playerid),"GangName")),"GangOwner"),false))
	{
		if(slot < 1 || slot > 3) return SendClientMessage(playerid,Red,"[ERROR]:- {EA0000}Invalid Slot! Slots Available 1 - 3");
	    if(slot == 1)
	    {
		    if(strcmp(dini_Get(gFile(dini_Get(pFile(playerid),"GangName")),"GangAdmin_2"),INVALID_GANG_ADMIN,true)) return SendClientMessage(playerid,Red,"[ERROR]:- {EA0000}Slot Is Full!");
        	dini_Set(gFile(dini_Get(pFile(playerid),"GangName")),"GangAdmin_2",pName(player1));
			format(string,sizeof(string),"[GANG] {FF9900}GangAdmin %s Has Made %s the Gang Admin!",pName(playerid),pName(player1));
			SendMessageToGangMembers(PlayerDat[playerid][GangID],LightRed2,string);
			return 1;
		}
		else if(slot == 2)
	    {
		    if(strcmp(dini_Get(gFile(dini_Get(pFile(playerid),"GangName")),"GangAdmin_3"),INVALID_GANG_ADMIN,true)) return SendClientMessage(playerid,Red,"[ERROR]:- {EA0000}Slot Is Full!");
			dini_Set(gFile(dini_Get(pFile(playerid),"GangName")),"GangAdmin_4",pName(player1));
			format(string,sizeof(string),"[GANG] {FF9900}GangAdmin %s Has Made %s the Gang Admin!",pName(playerid),pName(player1));
			SendMessageToGangMembers(PlayerDat[playerid][GangID],LightRed2,string);
			return 1;
		}
		else if(slot == 3)
	    {
		    if(strcmp(dini_Get(gFile(dini_Get(pFile(playerid),"GangName")),"GangAdmin_4"),INVALID_GANG_ADMIN,true)) return SendClientMessage(playerid,Red,"[ERROR]:- {EA0000}Slot Is Full!");
   			dini_Set(gFile(dini_Get(pFile(playerid),"GangName")),"GangAdmin_4",pName(player1));
			format(string,sizeof(string),"[GANG] {FF9900}GangAdmin %s Has Made %s the Gang Admin!",pName(playerid),pName(player1));
			SendMessageToGangMembers(PlayerDat[playerid][GangID],LightRed2,string);
			return 1;
		}
		return 1;
	}
	else return SendClientMessage(playerid,Red,"[ERROR]:- {EA0000}You Are Not A Gang Owner");
}
CMD:gangstats(playerid,params[])
{
	new slot = strval(params);
	if(sscanf(params,"i",slot))return ShowPlayerDialog(playerid,ERROR_DIALOG+6,DIALOG_STYLE_MSGBOX,"ERROR!","{FFFFFF}[Usage]:- {EA0000}/gangstats [gangid]","Ok","");
	if(!dini_Exists(gFileId(slot)))return SendClientMessage(playerid,White,"[ERROR]:- {EA0000}No Such gang ID!");
	new string[256];
	format(string,sizeof(string),"\t{FFFFFF}%s\n{F00000}Kills: {FFFFFF}%d\n{F00000}Deaths: {FFFFFF}%d",dini_Get(gFileId(slot),"GangName"),dini_Int(gFileId(slot),"Kills"),dini_Int(gFileId(slot),"Deaths"));
	ShowPlayerDialog(playerid,DIALOG+50,DIALOG_STYLE_MSGBOX,"Gang Stats!",string,"Ok","");
	return 1;
}
CMD:gangstatus(playerid,params[])
{
	if(GangManager[playerid] == 1)
	{
		new slot = strval(params);
		if(sscanf(params,"i",slot))return ShowPlayerDialog(playerid,ERROR_DIALOG+6,DIALOG_STYLE_MSGBOX,"ERROR!","{FFFFFF}[Usage]:- {EA0000}/gangstatus [gangid]","Ok","");
		if(dini_Exists(gFileId(slot)))
		{
			new string[256];
			format(string,sizeof(string),"{00F000}GangName:{FFFFFF}%s\n{00F100}GangId:{FFFFFF}%d\n{00F200}GangOwner:{FFFFFF}%s\n{00F200}Kills:{FFFFFF}%d\n{00F200}Deaths:{FFFFFF}%d",dini_Get(gFileId(slot),"GangName"),slot,dini_Get(gFile(dini_Get(gFileId(slot),"GangName")),"GangOwner"),GangDat[slot][GangKills],GangDat[slot][GangDeaths]);
			ShowPlayerDialog(playerid,DIALOG+51,DIALOG_STYLE_MSGBOX,"Gang Status",string,"ok","");
			return 1;
		}
		else return SendClientMessage(playerid,Red,"[ERROR]:- {EA0000}No Such Gang Id Exists!");
	}
	else return SendClientMessage(playerid,Red,"[ERROR]:- {EA0000}You Arent A Gang Manager!");
}
CMD:removegang(playerid,params[])
{
	if(GangManager[playerid] == 1)
	{
		new slot = strval(params);
		if(sscanf(params,"i",slot))return ShowPlayerDialog(playerid,ERROR_DIALOG+6,DIALOG_STYLE_MSGBOX,"ERROR!","{FFFFFF}[Usage]:- {EA0000}/removegang [gangid]","Ok","");
		if(dini_Exists(gFileId(slot)))
		{
			new string[256];
			format(string,sizeof(string),"You Have Deleted %s[%d] Gang!",dini_Get(gFileId(slot),"GangName"),slot);
		 	SendClientMessage(playerid,Red,string);
		 	GangDat[slot][FileExists] = false;
 			dini_Remove(dini_Get(gFileId(slot),"GangName"));
   			dini_Remove(gFileId(slot));
			return 1;
		}
		else return SendClientMessage(playerid,Red,"[ERROR]:- {EA0000}No Such Gang Id Exists!");
	}
	else return SendClientMessage(playerid,Red,"[ERROR]:- {EA0000}You Arent A Gang Manager!");
}
CMD:pgang(playerid,params[])
{
	new player = strval(params);
	if(sscanf(params,"i",player))return ShowPlayerDialog(playerid,ERROR_DIALOG+7,DIALOG_STYLE_MSGBOX,"ERROR!","{FFFFFF}[Usage]:- {EA0000}/pgang [playerid]","Ok","");
	new string[256];
	format(string,sizeof(string),"\t{FFFFFF}%s\n{F00000}Gang ID: {FFFFFF}%d",pName(player),PlayerDat[player][GangID]);
	ShowPlayerDialog(playerid,DIALOG+100,DIALOG_STYLE_MSGBOX,"Player Stats!",string,"Ok","");
	return 1;
}
CMD:leavegang(playerid,params[])
{
	if(PlayerDat[playerid][InGang] == 0)return SendClientMessage(playerid,Red,"[ERROR]:- {EA0000}You Are Not In A Gang");
	GangCheckLeave(playerid);
	dini_Set(pFile(playerid),"GangName",INVALID_GANG_NAME);
	dini_IntSet(pFile(playerid),"GangID",INVALID_GANG_ID);
	dini_IntSet(pFile(playerid),"InAGang",0);
	new string[256];
	format(string,sizeof(string),"[GANG] {FF9900}You Have Left The Gang");
	SendClientMessage(playerid,White,string);
	PlayerDat[playerid][InGang] = 0;
	return 1;
}
stock GangCheckLeave(playerid)
{
	if(!strcmp(pName(playerid),dini_Get(gFile(dini_Get(pFile(playerid),"GangName")),"GangOwner"),false))
	{
        GangDat[PlayerDat[playerid][GangID]][FileExists] = false;
		dini_Remove(gFileId(dini_Int(pFile(playerid),"GangID")));
	    dini_Remove(gFile(dini_Get(pFile(playerid),"GangName")));
		return 1;
	}
	else if(!strcmp(pName(playerid),dini_Get(gFile(dini_Get(pFile(playerid),"GangName")),"GangAdmin_2"),false))
	{
 		if(dini_Exists(dini_Get(pFile(playerid),"GangName")))
		{
			dini_Set(gFile(dini_Get(pFile(playerid),"GangName")),"GangAdmin_2",INVALID_GANG_ADMIN);
		}
		else
		{
 			dini_Set(pFile(playerid),"GangName",INVALID_GANG_NAME);
			dini_IntSet(pFile(playerid),"GangID",INVALID_GANG_ID);
			dini_IntSet(pFile(playerid),"InAGang",0);
		}
	}
	else if(!strcmp(pName(playerid),dini_Get(gFile(dini_Get(pFile(playerid),"GangName")),"GangAdmin_3"),false))
	{
 		if(dini_Exists(dini_Get(pFile(playerid),"GangName")))
		{
			dini_Set(gFile(dini_Get(pFile(playerid),"GangName")),"GangAdmin_3",INVALID_GANG_ADMIN);

		}
		else
		{
 			dini_Set(pFile(playerid),"GangName",INVALID_GANG_NAME);
			dini_IntSet(pFile(playerid),"GangID",INVALID_GANG_ID);
			dini_IntSet(pFile(playerid),"InAGang",0);
		}
	}
	else if(!strcmp(pName(playerid),dini_Get(gFile(dini_Get(pFile(playerid),"GangName")),"GangAdmin_4"),false))
	{
 		if(dini_Exists(dini_Get(pFile(playerid),"GangName")))
		{
			dini_Set(gFile(dini_Get(pFile(playerid),"GangName")),"GangAdmin_4",INVALID_GANG_ADMIN);
		}
		else
		{
 			dini_Set(pFile(playerid),"GangName",INVALID_GANG_NAME);
			dini_IntSet(pFile(playerid),"GangID",INVALID_GANG_ID);
			dini_IntSet(pFile(playerid),"InAGang",0);
		}
	}
	else
	{
	    if(dini_Exists(dini_Get(pFile(playerid),"GangName")))
		{
			dini_IntSet(gFileId(PlayerDat[playerid][GangID]),"Members",dini_Int(gFileId(PlayerDat[playerid][GangID]),"Members")-1);
		}
		else
		{
 			dini_Set(pFile(playerid),"GangName",INVALID_GANG_NAME);
			dini_IntSet(pFile(playerid),"GangID",INVALID_GANG_ID);
			dini_IntSet(pFile(playerid),"InAGang",0);
		}
	}
	return 1;
}

stock LoginPlayer(playerid)
{
	if(dini_Int(pFile(playerid),"InAGang") == 1)
	{
		PlayerDat[playerid][GangID] = dini_Int(pFile(playerid),"GangID");
		PlayerDat[playerid][InGang] = 1;
		dini_Set(pFile(playerid),"RecentGangCallName","NO-GANG-CALLED");
		PlayerDat[playerid][RecentGangCall] = -1;
		new string[256];
		format(string,sizeof(string),"{EA0000}[GANG]:- {FFFFFF}LoggedIn To Gang Account Of Gang %s[GangID: %d]",dini_Get(pFile(playerid),"GangName"),PlayerDat[playerid][GangID]);
		SendClientMessage(playerid,LightRed,string);
	}
	else
	{
		PlayerDat[playerid][GangID] = dini_Int(pFile(playerid),"GangID");
		PlayerDat[playerid][InGang] = dini_Int(pFile(playerid),"InAGang");
		dini_Set(pFile(playerid),"RecentGangCallName","NO-GANG-CALLED");
		PlayerDat[playerid][RecentGangCall] = -1;
		new string[256];
		format(string,sizeof(string),"{EA0000}[GANG]:- {FFFFFF}LoggedIn To Gang Account. You Arent In A Gang!");
		SendClientMessage(playerid,LightRed,string);
	}
	return 1;
}
stock LoginPlayerAgain(playerid)
{
	PlayerDat[playerid][GangID] = dini_Int(pFile(playerid),"GangID");
	PlayerDat[playerid][InGang] = 1;
	dini_Set(pFile(playerid),"RecentGangCallName","NO-GANG-CALLED");
	PlayerDat[playerid][RecentGangCall] = -1;
	new string[256];
	format(string,sizeof(string),"{00FD00}LoggedIn To Gang Account Of Gang %s[GangID: %d]",dini_Get(pFile(playerid),"GangName"),PlayerDat[playerid][GangID]);
	SendClientMessage(playerid,LightRed,string);
	return 1;
}
stock CreateFile(playerid)
{
	dini_Create(pFile(playerid));
	dini_Set(pFile(playerid),"GangName",INVALID_GANG_NAME);
	dini_IntSet(pFile(playerid),"GangID",INVALID_GANG_ID);
	dini_IntSet(pFile(playerid),"InAGang",0);
	PlayerDat[playerid][RecentGangCall] = -1;
	return 1;
}
stock pFile(playerid)
{
	new file[256];
	format(file,sizeof(file),"DGang/Accounts/%s.ini",pName(playerid));
	return file;
}
stock pName(playerid)
{
	new name[24];
	GetPlayerName(playerid,name,sizeof(name));
	return name;
}
stock gFile(const gangname[])
{
	new gfile[256];
	format(gfile,sizeof(gfile),"DGang/Gangs/%s.ini",gangname);
	return gfile;
}
stock gFileId(gangid)
{
	new gfile[256];
	format(gfile,sizeof(gfile),"DGang/GangsID/%d.ini",gangid);
	return gfile;
}
stock GMPassFile()
{
	new file[256];
	format(file,sizeof(file),"DGang/GangManagerPass.ini");
	return file;
}
forward SendMessageToGangMembers(gangid,color,const string[]);
public SendMessageToGangMembers(gangid,color,const string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) == 1)
		if(PlayerDat[i][InGang] == 1)
		if(PlayerDat[i][GangID] == gangid)
		SendClientMessage(i, color, string);
	}
	return 1;
}
forward GetPlayerFPS(playerid);
public GetPlayerFPS(playerid)
{
	new drunk2 = GetPlayerDrunkLevel(playerid);
	if(drunk2 < 100)
	{
	    SetPlayerDrunkLevel(playerid,2000);
	}
	else
	{
 	   if(PlayerDat[playerid][DLlast] != drunk2)
		{
	        new fps = PlayerDat[playerid][DLlast] - drunk2;
	        if((fps > 0) && (fps < 200))
   			PlayerDat[playerid][FPS] = fps;
			PlayerDat[playerid][DLlast] = drunk2;
		}
	}
	return PlayerDat[playerid][FPS];
}
