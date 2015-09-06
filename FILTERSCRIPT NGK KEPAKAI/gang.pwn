/*
Advanced gangs filterscript created by Soumi.
Copyright Soumi 2011.
Admin commands:
You need to be an RCON admin to use these commands.
- /makegangleader [playerid] [gangid]: to make someone a gang leader.
- /resetgang [gangid]: to reset a gang, it will change the gang name to Nothing, leader name to Nobody and everything else to default, it will also kick the online members of this gang.
Regular player commands:
- /gangs: it will show a list of the gangs.
- /acceptgang: When you are invited to join a gang, use this command to accept.
- /loadganginfo: When you join the server, you should use this command to load your gang info (Gang id and rank) and will show the gang MOTD.
Gang Members commands:
- /{g}ang: Gang chat.
- /adjustgang: it is only working for rank 5 and 6, it will show a dialog where you can change the gang name/MOTD/Rank names/Gang Color/Gang skins.
- /giverank: to change a gang member rank, works only for rank 5/6 command.
- /gkick: to kick someone from the gang, works only for rank 5/6 command.
- /ginvite: to invite someone to the gang, works only for rank 5/6 command.
- /gquit: to quit the gang.
- /gclothes: to set change your skin to the gang skin.
- /gmembers: shows a list of current online gang members.
*/

#define filterscript
#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <dini>

#define MAX_GANGS              5


// Colors defines

#define GREY            0xCECECEFF
#define WHITE           0xFFFFFFFF
#define RED             0xAA3333AA
#define GOLD            0xB8860BAA
#define ACTION_COLOR 	0xC2A2DAAA
#define GREEN           0x33AA33AA
#define ORANGE          0xFF9900AA
#define GUARDS_RADIO	0x33CCFFAA
#define DOCTORS_RADIO   0xFFC0CBAA
#define YELLOW          0xFFFF00AA
#define BRONZE          0x800000AA
#define SILVER          0xF5F5F5FF


//Dialogs defines

#define DIALOG_ADJUSTGANG  21
#define DIALOG_GANGNAME    22
#define DIALOG_GANGMOTD    23
#define DIALOG_RANK1NAME   24
#define DIALOG_RANK2NAME   25
#define DIALOG_RANK3NAME   26
#define DIALOG_RANK4NAME   27
#define DIALOG_RANK5NAME   28
#define DIALOG_RANK6NAME   29
#define DIALOG_GANGCOLOR   30
#define DIALOG_RANK1SKIN   31
#define DIALOG_RANK2SKIN   32
#define DIALOG_RANK3SKIN   33
#define DIALOG_RANK4SKIN   34
#define DIALOG_RANK5SKIN   35
#define DIALOG_RANK6SKIN   36

// Player Stats

enum PlayerInfo
{
	 GangID,
	 GangRank,
	 BeingInvitedToGang,

}
new PlayerStat[MAX_PLAYERS][PlayerInfo];

// Gang Stats

enum GangInfo
{
    GangFile[255],
    GangName[255],
    Leader[255],
    Members,
	Rank1[255],
	Rank2[255],
	Rank3[255],
	Rank4[255],
	Rank5[255],
	Rank6[255],
	MOTD[255],
	Color,
	Skin1,
	Skin2,
	Skin3,
	Skin4,
	Skin5,
	Skin6,
}
new GangStat[MAX_GANGS][GangInfo];

#if defined filterscript

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print("     Advanced gang system by Soumi      ");
	print("--------------------------------------\n");
	LoadGangs();
	return 1;
}

stock LoadGangs()
{
    for(new i = 1; i < MAX_GANGS; i++)
    {
        format(GangStat[i][GangFile], 60, "Gangs/Gang %d.ini", i);
        if(fexist(GangStat[i][GangFile]))
		{

           GangStat[i][Leader] = dini_Get(GangStat[i][GangFile], "Leader");
           GangStat[i][GangName] = dini_Get(GangStat[i][GangFile], "Name");
           GangStat[i][MOTD] = dini_Get(GangStat[i][GangFile], "MOTD");

           GangStat[i][Rank1] = dini_Get(GangStat[i][GangFile], "Rank1");
           GangStat[i][Rank2] = dini_Get(GangStat[i][GangFile], "Rank2");
           GangStat[i][Rank3] = dini_Get(GangStat[i][GangFile], "Rank3");
           GangStat[i][Rank4] = dini_Get(GangStat[i][GangFile], "Rank4");
           GangStat[i][Rank5] = dini_Get(GangStat[i][GangFile], "Rank5");
           GangStat[i][Rank6] = dini_Get(GangStat[i][GangFile], "Rank6");

           GangStat[i][Skin1] = dini_Int(GangStat[i][GangFile], "Skin1");
           GangStat[i][Skin2] = dini_Int(GangStat[i][GangFile], "Skin2");
           GangStat[i][Skin3] = dini_Int(GangStat[i][GangFile], "Skin3");
           GangStat[i][Skin4] = dini_Int(GangStat[i][GangFile], "Skin4");
           GangStat[i][Skin5] = dini_Int(GangStat[i][GangFile], "Skin5");
           GangStat[i][Skin6] = dini_Int(GangStat[i][GangFile], "Skin6");

           GangStat[i][Members] = dini_Int(GangStat[i][GangFile], "Members");

           GangStat[i][Color] = dini_Int(GangStat[i][GangFile], "Color");

        }
    }
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

#else

main()
{
	print("\n--------------------------------------");
	print("     Advanced gang system by Soumi      ");
	print("--------------------------------------\n");
}

#endif

//-----------------------------------------------------------------------[Gang members Commands]------------------------------------------------------------------------------

COMMAND:g(playerid, params[])
{
	new message[128], str[128];
	if(PlayerStat[playerid][GangID] < 1) return SendClientMessage(playerid, GREY, "You must be in a gang to use this command.");
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /g{ang} [message]");
	switch(PlayerStat[playerid][GangRank])
	{
	    case 1:
        {
            format(str, sizeof(str), "(( %s (1) %s: %s ))", GangStat[PlayerStat[playerid][GangID]][Rank1], GetName(playerid), message);
        }
        case 2:
        {
            format(str, sizeof(str), "(( %s (2) %s: %s ))", GangStat[PlayerStat[playerid][GangID]][Rank2], GetName(playerid), message);
        }
        case 3:
        {
            format(str, sizeof(str), "(( %s (3) %s: %s ))", GangStat[PlayerStat[playerid][GangID]][Rank3], GetName(playerid), message);
        }
        case 4:
        {
            format(str, sizeof(str), "(( %s (4) %s: %s ))", GangStat[PlayerStat[playerid][GangID]][Rank4], GetName(playerid), message);
        }
        case 5:
        {
            format(str, sizeof(str), "(( %s (5) %s: %s ))", GangStat[PlayerStat[playerid][GangID]][Rank5], GetName(playerid), message);
        }
        case 6:
        {
            format(str, sizeof(str), "(( %s (6) %s: %s ))", GangStat[PlayerStat[playerid][GangID]][Rank6], GetName(playerid), message);
        }
	}
	SendGangMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
    return 1;
}

COMMAND:gang(playerid, params[])
{
	new message[128], str[128];
	if(PlayerStat[playerid][GangID] < 1) return SendClientMessage(playerid, GREY, "You must be in a gang to use this command.");
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /g{ang} [message]");
	switch(PlayerStat[playerid][GangRank])
	{
	    case 1:
        {
            format(str, sizeof(str), "(( %s (1) %s: %s ))", GangStat[PlayerStat[playerid][GangID]][Rank1], GetName(playerid), message);
        }
        case 2:
        {
            format(str, sizeof(str), "(( %s (2) %s: %s ))", GangStat[PlayerStat[playerid][GangID]][Rank2], GetName(playerid), message);
        }
        case 3:
        {
            format(str, sizeof(str), "(( %s (3) %s: %s ))", GangStat[PlayerStat[playerid][GangID]][Rank3], GetName(playerid), message);
        }
        case 4:
        {
            format(str, sizeof(str), "(( %s (4) %s: %s ))", GangStat[PlayerStat[playerid][GangID]][Rank4], GetName(playerid), message);
        }
        case 5:
        {
            format(str, sizeof(str), "(( %s (5) %s: %s ))", GangStat[PlayerStat[playerid][GangID]][Rank5], GetName(playerid), message);
        }
        case 6:
        {
            format(str, sizeof(str), "(( %s (6) %s: %s ))", GangStat[PlayerStat[playerid][GangID]][Rank6], GetName(playerid), message);
        }
	}
	SendGangMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
    return 1;
}

COMMAND:adjustgang(playerid, params[])
{
	if(PlayerStat[playerid][GangID] < 1) return SendClientMessage(playerid, GREY, "You must be in a gang to use this command.");
	if(PlayerStat[playerid][GangRank] < 5) return SendClientMessage(playerid, GREY, "You must be rank 5/6 to use this command.");
	ShowPlayerDialog(playerid, DIALOG_ADJUSTGANG, DIALOG_STYLE_LIST, "What are you going to adjust?", "Gang Name\nGang MOTD\nRank 1 name\nRank 2 name\nRank 3 name\nRank 4 name\nRank 5 name\nRank 6 name\nColor\nRank 1 Skin\nRank 2 Skin\nRank 3 Skin\nRank 4 Skin\nRank 5 Skin\nRank 6 Skin", "Select", "Quit");
    return 1;
}

COMMAND:giverank(playerid, params[])
{
	new targetid, rank, str[128];
	if(PlayerStat[playerid][GangID] < 1) return SendClientMessage(playerid, GREY, "You must be in a gang to use this command.");
	if(PlayerStat[playerid][GangRank] < 5) return SendClientMessage(playerid, GREY, "You must be rank 5/6 to use this command.");
    if(sscanf(params,"ud", targetid, rank))return SendClientMessage(playerid, GREY, "USAGE: /giverank [playerid] [rank]");
    if(playerid == targetid) return SendClientMessage(playerid, GREY, "You can't change your rank.");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    if(PlayerStat[playerid][GangID] != PlayerStat[targetid][GangID]) return SendClientMessage(playerid, GREY, "Target ID isn't in your gang.");
    if(PlayerStat[playerid][GangRank] <= PlayerStat[targetid][GangRank]) return SendClientMessage(playerid, GREY, "Target ID has same or higher rank.");
    PlayerStat[targetid][GangRank] = rank;
    format(str, sizeof(str), "%s has gave rank %d to %s.", GetName(playerid), rank, GetName(targetid));
    SendGangMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
    SavePlayerGangInfo(targetid);
    return 1;
}

COMMAND:ginvite(playerid, params[])
{
	new targetid, str[128];
	if(PlayerStat[playerid][GangID] < 1) return SendClientMessage(playerid, GREY, "You must be in a gang to use this command.");
	if(PlayerStat[playerid][GangRank] < 5) return SendClientMessage(playerid, GREY, "You must be rank 5/6 to use this command.");
    if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /ginvite [playerid]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    if(PlayerStat[targetid][GangID] >= 1) return SendClientMessage(playerid, GREY, "Target ID is already in a Gang/Faction.");
    PlayerStat[targetid][BeingInvitedToGang] = PlayerStat[playerid][GangID];
    format(str, sizeof(str), "%s has invited %s to join %s.", GetName(playerid), GetName(targetid), GangStat[PlayerStat[playerid][GangID]][GangName]);
    SendGangMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
    format(str, sizeof(str), "%s has invited you to join %s, use /acceptgang to join!");
    SendClientMessage(targetid, GangStat[PlayerStat[playerid][GangID]][GangName], str);
    return 1;
}

COMMAND:gkick(playerid, params[])
{
	new targetid, str[128];
	if(PlayerStat[playerid][GangID] < 1) return SendClientMessage(playerid, GREY, "You must be in a gang to use this command.");
	if(PlayerStat[playerid][GangRank] < 5) return SendClientMessage(playerid, GREY, "You must be rank 5/6 to use this command.");
    if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /gkick [playerid]");
    if(playerid == targetid) return SendClientMessage(playerid, GREY, "You can't kick yourself, use /gquit.");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    if(PlayerStat[playerid][GangID] != PlayerStat[targetid][GangID]) return SendClientMessage(playerid, GREY, "Target ID isn't in your gang.");
    if(PlayerStat[playerid][GangRank] <= PlayerStat[targetid][GangRank]) return SendClientMessage(playerid, GREY, "Target ID has same or higher rank.");
    format(str, sizeof(str), "%s has kicked %s from the gang.", GetName(playerid), GetName(targetid));
    SendGangMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
    GangStat[PlayerStat[playerid][GangID]][Members] -= 1;
    PlayerStat[targetid][GangID] = 0;
	PlayerStat[targetid][GangRank] = 0;
	SaveGang(PlayerStat[playerid][GangID]);
	SavePlayerGangInfo(targetid);
    return 1;
}

COMMAND:gquit(playerid, params[])
{
	new str[128];
	if(PlayerStat[playerid][GangID] < 1) return SendClientMessage(playerid, GREY, "You must be in a gang to use this command.");
    format(str, sizeof(str), "%s has quited the gang.", GetName(playerid));
    SendGangMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
	GangStat[PlayerStat[playerid][GangID]][Members] -= 1;
	SaveGang(PlayerStat[playerid][GangID]);
    PlayerStat[playerid][GangID] = 0;
	PlayerStat[playerid][GangRank] = 0;
    return 1;
}

COMMAND:gclothes(playerid, params[])
{
    if(PlayerStat[playerid][GangID] < 1) return SendClientMessage(playerid, GREY, "You must be in a gang to use this command.");
	if(PlayerStat[playerid][GangRank] == 1) return SetPlayerSkin(playerid, GangStat[PlayerStat[playerid][GangID]][Skin1]);
	else if(PlayerStat[playerid][GangRank] == 2) return SetPlayerSkin(playerid, GangStat[PlayerStat[playerid][GangID]][Skin2]);
	else if(PlayerStat[playerid][GangRank] == 3) return SetPlayerSkin(playerid, GangStat[PlayerStat[playerid][GangID]][Skin3]);
	else if(PlayerStat[playerid][GangRank] == 4) return SetPlayerSkin(playerid, GangStat[PlayerStat[playerid][GangID]][Skin4]);
	else if(PlayerStat[playerid][GangRank] == 5) return SetPlayerSkin(playerid, GangStat[PlayerStat[playerid][GangID]][Skin5]);
	else if(PlayerStat[playerid][GangRank] == 6) return SetPlayerSkin(playerid, GangStat[PlayerStat[playerid][GangID]][Skin6]);
    return 1;
}


COMMAND:gmembers(playerid, params[])
{
	new str[128];
	if(PlayerStat[playerid][GangID] < 1) return SendClientMessage(playerid, GREY, "You must be in a gang to use this command.");
	SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], "Online Gang Members:");
	for(new i = 0; i < MAX_PLAYERS; i++)
    {
		if(IsPlayerConnected(i) && PlayerStat[playerid][GangID] == PlayerStat[i][GangID])
		{
            format(str, sizeof(str), "%s, Rank %d.", GetName(i), PlayerStat[i][GangRank]);
            SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
        }
    }
    SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], "--------------------------------");
    return 1;
}

//-----------------------------------------------------------------------[Admin Commands]------------------------------------------------------------------------------

COMMAND:makegangleader(playerid, params[])
{
	new targetid, Gang, str[128];
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, GREY, "You can't use this command.");
    if(sscanf(params,"ud", targetid, Gang))return SendClientMessage(playerid, GREY, "USAGE: /makegangleader [playerid] [gangid]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    if(Gang <= 0) return SendClientMessage(playerid, GREY, "Invalid Gang ID.");
    if(Gang >= MAX_GANGS) return SendClientMessage(playerid, GREY, "Invalid Gang ID.");
    format(str, sizeof(str), "Admin %s has made %s leader of Gang ID %d.", GetName(playerid), GetName(targetid), Gang);
    SendClientMessageToAll(RED, str);
    PlayerStat[targetid][GangID] = Gang;
    PlayerStat[targetid][GangRank] = 6;
    format(GangStat[PlayerStat[targetid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[targetid][GangID]);
    format(GangStat[PlayerStat[targetid][GangID]][Leader], 60, "%s", GetName(targetid));
    SaveGang(Gang);
    SavePlayerGangInfo(targetid);
    return 1;
}

COMMAND:resetgang(playerid, params[])
{
	new Gang, str[128];
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, GREY, "You can't use this command.");
    if(sscanf(params,"d", Gang))return SendClientMessage(playerid, GREY, "USAGE: /resetgang [gangid]");
    if(Gang <= 0) return SendClientMessage(playerid, GREY, "Invalid Gang ID.");
    if(Gang >= MAX_GANGS) return SendClientMessage(playerid, GREY, "Invalid Gang ID.");
    format(GangStat[Gang][GangFile], 60, "Gangs/Gang %d.ini", Gang);
    if(fexist(GangStat[Gang][GangFile]))
    {
		format(GangStat[Gang][Leader], 60, "Nobody");
		format(GangStat[Gang][GangName], 60, "Nothing");
		format(GangStat[Gang][Rank1], 60, "None");
		format(GangStat[Gang][Rank2], 60, "None");
		format(GangStat[Gang][Rank3], 60, "None");
		format(GangStat[Gang][Rank4], 60, "None");
		format(GangStat[Gang][Rank5], 60, "None");
		format(GangStat[Gang][Rank6], 60, "None");
		format(GangStat[Gang][MOTD], 128, "Welcome Back to BPRP.");
		GangStat[Gang][Skin1] = 50;
		GangStat[Gang][Skin2] = 50;
		GangStat[Gang][Skin3] = 50;
		GangStat[Gang][Skin4] = 50;
		GangStat[Gang][Skin5] = 50;
		GangStat[Gang][Skin6] = 50;
		GangStat[Gang][Members] = 0;

		SaveGang(Gang);

		format(str, sizeof(str), "Admin %s has re-setted Gang ID %d.", GetName(playerid), Gang);
        SendClientMessageToAll(RED, str);

		for(new i = 0; i < MAX_PLAYERS; i++)
	    {
			if(IsPlayerConnected(i) && PlayerStat[i][GangID] == Gang)
			{
				SendClientMessage(i, RED, "You have been kicked from your gang by an admin");
			    PlayerStat[i][GangID] = 0;
                PlayerStat[i][GangRank] = 0;
                SavePlayerGangInfo(i);
            }
        }

	}
    return 1;
}


//-----------------------------------------------------------------------[Regular Players Commands]------------------------------------------------------------------------------


COMMAND:gangs(playerid, params[])
{
	new str[128];
	SendClientMessage(playerid, WHITE, "----------------------------------------------------------------------------------------------------------");
	for(new i = 1; i < MAX_GANGS; i++)
    {
        format(str, sizeof(str), "Gang Name: %s, Leader: %s, Members: %d.", GangStat[i][GangName], GangStat[i][Leader], GangStat[i][Members]);
        SendClientMessage(playerid, GangStat[i][Color], str);
    }
    SendClientMessage(playerid, WHITE, "----------------------------------------------------------------------------------------------------------");
    return 1;
}

COMMAND:acceptgang(playerid, params[])
{
    new str[128];
	if(PlayerStat[playerid][BeingInvitedToGang] == 0) return SendClientMessage(playerid, GREY, "Nobody invited you to join a gang.");
	PlayerStat[playerid][GangID] = PlayerStat[playerid][BeingInvitedToGang];
    PlayerStat[playerid][GangRank] = 1;
	PlayerStat[playerid][BeingInvitedToGang] = 0;
	format(str, sizeof(str), "%s has accepted to join %s, Welcome!", GetName(playerid), GangStat[PlayerStat[playerid][GangID]][GangName]);
    SendGangMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
    GangStat[PlayerStat[playerid][GangID]][Members] += 1;
    format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
    SaveGang(GangStat[PlayerStat[playerid][GangID]][GangFile]);
    SavePlayerGangInfo(playerid);
    return 1;
}

COMMAND:loadganginfo(playerid, params[])
{
    LoadPlayerGangInfo(playerid);
    new str[128];
    format(str, sizeof(str), "Gang info loaded, Gang: %s (ID: %d), Rank: %s (%d).", GetGangName(playerid), PlayerStat[playerid][GangID], GetGangRank(playerid), PlayerStat[playerid][GangRank]);
    SendClientMessage(playerid, GREEN, str);
    if(PlayerStat[playerid][GangID] >= 1)
    {
        format(str, sizeof(str), "Gang MOTD: %s", GangStat[PlayerStat[playerid][GangID]][MOTD]);
		SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
	}
    return 1;
}

//-----------------------------------------------------------------------[Functions]------------------------------------------------------------------------------

stock GetName(playerid)
{
    new Name[MAX_PLAYER_NAME];
    if(IsPlayerConnected(playerid))
    {
		GetPlayerName(playerid, Name, sizeof(Name));
	}
	else
	{
	    Name = "None";
	}

	return Name;
}


stock SendGangMessage(playerid, color, str[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && PlayerStat[playerid][GangID] == PlayerStat[i][GangID])
		{
            SendClientMessage(i, color, str);
        }
    }
    GangChatLog(str);
	return 1;
}

stock SaveGang(gangid)
{
    format(GangStat[gangid][GangFile], 20, "Gangs/Gang %d.ini", gangid);
    if(fexist(GangStat[gangid][GangFile]))
    {

        dini_Set(GangStat[gangid][GangFile], "Leader", GangStat[gangid][Leader]);
		dini_Set(GangStat[gangid][GangFile], "Name", GangStat[gangid][GangName]);
		dini_Set(GangStat[gangid][GangFile], "MOTD", GangStat[gangid][MOTD]);

		dini_Set(GangStat[gangid][GangFile], "Rank1", GangStat[gangid][Rank1]);
		dini_Set(GangStat[gangid][GangFile], "Rank2", GangStat[gangid][Rank2]);
		dini_Set(GangStat[gangid][GangFile], "Rank3", GangStat[gangid][Rank3]);
		dini_Set(GangStat[gangid][GangFile], "Rank4", GangStat[gangid][Rank4]);
		dini_Set(GangStat[gangid][GangFile], "Rank5", GangStat[gangid][Rank5]);
		dini_Set(GangStat[gangid][GangFile], "Rank6", GangStat[gangid][Rank6]);

		dini_IntSet(GangStat[gangid][GangFile], "Skin1", GangStat[gangid][Skin1]);
		dini_IntSet(GangStat[gangid][GangFile], "Skin2", GangStat[gangid][Skin2]);
		dini_IntSet(GangStat[gangid][GangFile], "Skin3", GangStat[gangid][Skin3]);
		dini_IntSet(GangStat[gangid][GangFile], "Skin4", GangStat[gangid][Skin4]);
		dini_IntSet(GangStat[gangid][GangFile], "Skin5", GangStat[gangid][Skin5]);
		dini_IntSet(GangStat[gangid][GangFile], "Skin6", GangStat[gangid][Skin6]);

		dini_IntSet(GangStat[gangid][GangFile], "Members", GangStat[gangid][Members]);

		dini_IntSet(GangStat[gangid][GangFile], "Color", GangStat[gangid][Color]);
    }
	return 1;
}

stock GangChatLog(str[])
{
    new File:lFile = fopen("Gangs/Gang Chat Log.txt", io_append);
    new logData[178];
    new Hour, Minute, Second;
    new Day, Month, Year;

    gettime(Hour, Minute, Second);
    getdate(Year, Month, Day);

    format(logData, sizeof(logData),"[%02d/%02d/%02d %02d:%02d:%02d] %s \r\n", Day, Month, Year, Hour, Minute, Second, str);
    fwrite(lFile, logData);

    fclose(lFile);
    return 1;
}

stock LoadPlayerGangInfo(playerid)
{
    if(fexist(Accounts(playerid)))
	{
		PlayerStat[playerid][GangID] = dini_Int(Accounts(playerid), "GangID");
        PlayerStat[playerid][GangRank] = dini_Int(Accounts(playerid), "GangRank");
	}
    return 1;
}

stock GetGangName(playerid)
{
	new Gang[60];
    if(PlayerStat[playerid][GangID] >= 1)
    {
       format(Gang, sizeof(Gang), "%s", GangStat[PlayerStat[playerid][GangID]][GangName]);
	}
	else
	{
	    Gang = "None";
	}
	return Gang;
}

stock GetGangRank(playerid)
{
	new Rank[60];
    if(PlayerStat[playerid][GangID] >= 1)
    {
       if(PlayerStat[playerid][GangRank] == 1) format(Rank, sizeof(Rank), "%s", GangStat[PlayerStat[playerid][GangID]][Rank1]);
       if(PlayerStat[playerid][GangRank] == 2) format(Rank, sizeof(Rank), "%s", GangStat[PlayerStat[playerid][GangID]][Rank2]);
       if(PlayerStat[playerid][GangRank] == 3) format(Rank, sizeof(Rank), "%s", GangStat[PlayerStat[playerid][GangID]][Rank3]);
       if(PlayerStat[playerid][GangRank] == 4) format(Rank, sizeof(Rank), "%s", GangStat[PlayerStat[playerid][GangID]][Rank4]);
       if(PlayerStat[playerid][GangRank] == 5) format(Rank, sizeof(Rank), "%s", GangStat[PlayerStat[playerid][GangID]][Rank5]);
       if(PlayerStat[playerid][GangRank] == 6) format(Rank, sizeof(Rank), "%s", GangStat[PlayerStat[playerid][GangID]][Rank6]);
	}
	else
	{
	    Rank = "None";
	}
	return Rank;
}

stock SavePlayerGangInfo(playerid)
{
	if(!fexist(Accounts(playerid)))
	{
		dini_Create(Accounts(playerid));
		dini_IntSet(Accounts(playerid), "GangID",PlayerStat[playerid][GangID]);
        dini_IntSet(Accounts(playerid), "GangRank",PlayerStat[playerid][GangRank]);
	}
	else
	{
		dini_IntSet(Accounts(playerid), "GangID",PlayerStat[playerid][GangID]);
        dini_IntSet(Accounts(playerid), "GangRank",PlayerStat[playerid][GangRank]);
	}
    return 1;
}

stock Accounts(playerid)
{
  new PlayerAcc[128];
  format(PlayerAcc,128,"Gangs/Players/%s.ini",GetName(playerid));
  return PlayerAcc;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_ADJUSTGANG)
    {
        if(!response) return 1;
        else if(response)
        {
            switch(listitem)
        	{
				case 0:
				{
					ShowPlayerDialog(playerid, DIALOG_GANGNAME, DIALOG_STYLE_INPUT, "Gang Name", "Please input your new gang name below.", "Done", "Quit");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_GANGMOTD, DIALOG_STYLE_INPUT, "Gang MOTD", "Please input your new gang MOTD below.", "Done", "Quit");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, DIALOG_RANK1NAME, DIALOG_STYLE_INPUT, "Rank 1 Name", "Please input the new rank 1 name below.", "Done", "Quit");
				}
				case 3:
				{
					ShowPlayerDialog(playerid, DIALOG_RANK2NAME, DIALOG_STYLE_INPUT, "Rank 2 Name", "Please input the new rank 2 name below.", "Done", "Quit");
				}
				case 4:
				{
					ShowPlayerDialog(playerid, DIALOG_RANK3NAME, DIALOG_STYLE_INPUT, "Rank 3 Name", "Please input the new rank 3 name below.", "Done", "Quit");
				}
				case 5:
				{
					ShowPlayerDialog(playerid, DIALOG_RANK4NAME, DIALOG_STYLE_INPUT, "Rank 4 Name", "Please input the new rank 4 name below.", "Done", "Quit");
				}
				case 6:
				{
					ShowPlayerDialog(playerid, DIALOG_RANK5NAME, DIALOG_STYLE_INPUT, "Rank 5 Name", "Please input the new rank 5 name below.", "Done", "Quit");
				}
				case 7:
				{
					ShowPlayerDialog(playerid, DIALOG_RANK6NAME, DIALOG_STYLE_INPUT, "Rank 6 Name", "Please input the new rank 6 name below.", "Done", "Quit");
				}
				case 8:
				{
					ShowPlayerDialog(playerid, DIALOG_GANGCOLOR, DIALOG_STYLE_LIST, "Gang Color", "Green\nRed\nLight Blue\nYellow\nBrown\nBlack\nOrange", "Done", "Quit");
				}
				case 9:
				{
					ShowPlayerDialog(playerid, DIALOG_RANK1SKIN, DIALOG_STYLE_INPUT, "Rank 1 Skin", "Input the new rank 1 skin ID below.", "Done", "Quit");
				}
				case 10:
				{
					ShowPlayerDialog(playerid, DIALOG_RANK2SKIN, DIALOG_STYLE_INPUT, "Rank 2 Skin", "Input the new rank 2 skin ID below.", "Done", "Quit");
				}
				case 11:
				{
					ShowPlayerDialog(playerid, DIALOG_RANK3SKIN, DIALOG_STYLE_INPUT, "Rank 3 Skin", "Input the new rank 3 skin ID below.", "Done", "Quit");
				}
				case 12:
				{
					ShowPlayerDialog(playerid, DIALOG_RANK4SKIN, DIALOG_STYLE_INPUT, "Rank 4 Skin", "Input the new rank 4 skin ID below.", "Done", "Quit");
				}
				case 13:
				{
					ShowPlayerDialog(playerid, DIALOG_RANK5SKIN, DIALOG_STYLE_INPUT, "Rank 5 Skin", "Input the new rank 5 skin ID below.", "Done", "Quit");
				}
				case 14:
				{
					ShowPlayerDialog(playerid, DIALOG_RANK6SKIN, DIALOG_STYLE_INPUT, "Rank 6 Skin", "Input the new rank 6 skin ID below.", "Done", "Quit");
				}
			}
        }
    }
    if(dialogid == DIALOG_GANGNAME)
    {
        if(!response) return 1;
        else if(response)
        {
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "Invalid Gang Name.");
			}
			else if(strlen(inputtext) < 5)
			{
                SendClientMessage(playerid, GREY, "Your new gang name mustn't be under 3 characters.");
			}
			else if(strlen(inputtext) > 20)
			{
                SendClientMessage(playerid, GREY, "Your new gang name mustn't be more than 20 characters.");
			}
            else
			{
                format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                if(fexist(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                {
				    new str[128];
				    format(str, sizeof(str), "You have successfully changed your gang name to %s", inputtext);
                    SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    format(GangStat[PlayerStat[playerid][GangID]][GangName], 128, "%s", inputtext);
                    SaveGang(PlayerStat[playerid][GangID]);
                }
            }
        }
	}
	if(dialogid == DIALOG_GANGMOTD)
    {
        if(!response) return 1;
        else if(response)
        {
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "Invalid Gang MOTD.");
			}
			else if(strlen(inputtext) < 15)
			{
                SendClientMessage(playerid, GREY, "Your new gang MOTD mustn't be under 15 characters.");
			}
			else if(strlen(inputtext) > 128)
			{
                SendClientMessage(playerid, GREY, "Your new gang MOTD mustn't be more than 128 characters.");
			}
            else
			{
                format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                if(fexist(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                {
				    new str[128];
				    format(str, sizeof(str), "New gang MOTD: to %s", inputtext);
                    SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    format(GangStat[PlayerStat[playerid][GangID]][MOTD], 128, "%s", inputtext);
                    SaveGang(PlayerStat[playerid][GangID]);
                }
            }
        }
	}
	if(dialogid == DIALOG_RANK1NAME)
    {
        if(!response) return 1;
        else if(response)
        {
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "Invalid Rank name.");
			}
			else if(strlen(inputtext) < 3)
			{
                SendClientMessage(playerid, GREY, "The new rank 1 name mustn't be under 3 characters.");
			}
			else if(strlen(inputtext) > 10)
			{
                SendClientMessage(playerid, GREY, "The new rank 1 name mustn't be more than 10 characters.");
			}
            else
			{
                format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                if(fexist(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                {
				    new str[128];
				    format(str, sizeof(str), "You have successfully changed the rank 1 name to %s", inputtext);
                    SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    format(GangStat[PlayerStat[playerid][GangID]][Rank1], 128, "%s", inputtext);
                    SaveGang(PlayerStat[playerid][GangID]);
                }
            }
        }
	}
	if(dialogid == DIALOG_RANK2NAME)
    {
        if(!response) return 1;
        else if(response)
        {
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "Invalid Rank name.");
			}
			else if(strlen(inputtext) < 3)
			{
                SendClientMessage(playerid, GREY, "The new rank 2 name mustn't be under 3 characters.");
			}
			else if(strlen(inputtext) > 10)
			{
                SendClientMessage(playerid, GREY, "The new rank 2 name mustn't be more than 10 characters.");
			}
            else
			{
                format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                if(fexist(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                {
				    new str[128];
				    format(str, sizeof(str), "You have successfully changed the rank 2 name to %s", inputtext);
                    SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    format(GangStat[PlayerStat[playerid][GangID]][Rank2], 128, "%s", inputtext);
                    SaveGang(PlayerStat[playerid][GangID]);
                }
            }
        }
	}
	if(dialogid == DIALOG_RANK3NAME)
    {
        if(!response) return 1;
        else if(response)
        {
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "Invalid Rank name.");
			}
			else if(strlen(inputtext) < 3)
			{
                SendClientMessage(playerid, GREY, "The new rank 3 name mustn't be under 3 characters.");
			}
			else if(strlen(inputtext) > 10)
			{
                SendClientMessage(playerid, GREY, "the new rank 3 name mustn't be more than 10 characters.");
			}
            else
			{
                format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                if(fexist(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                {
				    new str[128];
				    format(str, sizeof(str), "You have successfully changed the rank 3 name to %s", inputtext);
                    SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    format(GangStat[PlayerStat[playerid][GangID]][Rank3], 128, "%s", inputtext);
                    SaveGang(PlayerStat[playerid][GangID]);
                }
            }
        }
	}
	if(dialogid == DIALOG_RANK4NAME)
    {
        if(!response) return 1;
        else if(response)
        {
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "Invalid Rank name.");
			}
			else if(strlen(inputtext) < 3)
			{
                SendClientMessage(playerid, GREY, "The new rank 4 name mustn't be under 3 characters.");
			}
			else if(strlen(inputtext) > 10)
			{
                SendClientMessage(playerid, GREY, "The new rank 4 name mustn't be more than 10 characters.");
			}
            else
			{
                format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                if(fexist(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                {
				    new str[128];
				    format(str, sizeof(str), "You have successfully changed the rank 4 name to %s", inputtext);
                    SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    format(GangStat[PlayerStat[playerid][GangID]][Rank4], 128, "%s", inputtext);
                    SaveGang(PlayerStat[playerid][GangID]);
                }
            }
        }
	}
	if(dialogid == DIALOG_RANK5NAME)
    {
        if(!response) return 1;
        else if(response)
        {
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "Invalid Rank name.");
			}
			else if(strlen(inputtext) < 3)
			{
                SendClientMessage(playerid, GREY, "The new rank 5 name mustn't be under 3 characters.");
			}
			else if(strlen(inputtext) > 10)
			{
                SendClientMessage(playerid, GREY, "The new rank 5 name mustn't be more than 10 characters.");
			}
            else
			{
                format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                if(fexist(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                {
				    new str[128];
				    format(str, sizeof(str), "You have successfully changed the rank 5 name to %s", inputtext);
                    SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    format(GangStat[PlayerStat[playerid][GangID]][Rank5], 128, "%s", inputtext);
                    SaveGang(PlayerStat[playerid][GangID]);
                }
            }
        }
	}
	if(dialogid == DIALOG_RANK6NAME)
    {
        if(!response) return 1;
        else if(response)
        {
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "Invalid Rank name.");
			}
			else if(strlen(inputtext) < 3)
			{
                SendClientMessage(playerid, GREY, "The new rank 6 name mustn't be under 3 characters.");
			}
			else if(strlen(inputtext) > 10)
			{
                SendClientMessage(playerid, GREY, "The new rank 6 name mustn't be more than 10 characters.");
			}
            else
			{
                format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                if(fexist(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                {
				    new str[128];
				    format(str, sizeof(str), "You have successfully changed the rank 6 name to %s", inputtext);
                    SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    format(GangStat[PlayerStat[playerid][GangID]][Rank6], 128, "%s", inputtext);
                    SaveGang(PlayerStat[playerid][GangID]);
                }
            }
        }
	}
	if(dialogid == DIALOG_GANGCOLOR)
    {
        if(!response) return 1;
        else if(response)
        {
            switch(listitem)
        	{
				case 0:
				{
					format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(fexist(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][Color] = 0x33AA33AA;
                        SaveGang(PlayerStat[playerid][GangID]);
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], "You have successfully changed the gang color to Green");
                    }
				}
	        	case 1:
				{
					format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(fexist(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][Color] = 0xAA3333AA;
                        SaveGang(PlayerStat[playerid][GangID]);
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], "You have successfully changed the gang color to Red");
                    }
				}
				case 2:
				{
					format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(fexist(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][Color] = 0x33CCFFAA;
                        SaveGang(PlayerStat[playerid][GangID]);
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], "You have successfully changed the gang color to Light Blue");
                    }
				}
				case 3:
				{
					format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(fexist(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][Color] = 0xFFFF00AA;
                        SaveGang(PlayerStat[playerid][GangID]);
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], "You have successfully changed the gang color to Yellow");
                    }
				}
				case 4:
				{
					format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(fexist(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][Color] = 0xA52A2AAA;
                        SaveGang(PlayerStat[playerid][GangID]);
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], "You have successfully changed the gang color to Brown");
                    }
				}
				case 5:
				{
					format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(fexist(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][Color] = 0x000000AA;
                        SaveGang(PlayerStat[playerid][GangID]);
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], "You have successfully changed the gang color to Black");
                    }
				}
                case 6:
				{
					format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(fexist(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][Color] = 0xFF9900AA;
                        SaveGang(PlayerStat[playerid][GangID]);
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], "You have successfully changed the gang color to Orange");
                    }
				}
			}
        }
    }
    if(dialogid == DIALOG_RANK1SKIN)
    {
        if(!response) return 1;
        if(response)
        {
            if(!strval(inputtext))
            {
                SendClientMessage(playerid, GREY, "You have entered an Invalid Skin ID.");
            }
            else if(strval(inputtext))
		    {
		        if(0 < strval(inputtext) < 299)
				{
					new str[128];
                    format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(fexist(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][Skin1] = strval(inputtext);
                        SaveGang(PlayerStat[playerid][GangID]);
                        format(str, sizeof(str), "You have successfully changed rank 1 skin to %d", GangStat[PlayerStat[playerid][GangID]][Skin1]);
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    }
                }
                else
				{
				    SendClientMessage(playerid, GREY, "Skins IDs are between 0 and 299.");
				}
            }
        }
	}
	if(dialogid == DIALOG_RANK2SKIN)
    {
        if(!response) return 1;
        if(response)
        {
            if(!strval(inputtext))
            {
                SendClientMessage(playerid, GREY, "You have entered an Invalid Skin ID.");
            }
            else if(strval(inputtext))
		    {
		        if(0 < strval(inputtext) < 299)
				{
					new str[128];
					format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(fexist(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][Skin2] = strval(inputtext);
                        SaveGang(PlayerStat[playerid][GangID]);
                        format(str, sizeof(str), "You have successfully changed rank 2 skin to %d", GangStat[PlayerStat[playerid][GangID]][Skin2]);
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    }
                }
                else
				{
				    SendClientMessage(playerid, GREY, "Skins IDs are between 0 and 299.");
				}
            }
        }
	}
	if(dialogid == DIALOG_RANK3SKIN)
    {
        if(!response) return 1;
        if(response)
        {
            if(!strval(inputtext))
            {
                SendClientMessage(playerid, GREY, "You have entered an Invalid Skin ID.");
            }
            else if(strval(inputtext))
		    {
		        if(0 < strval(inputtext) < 299)
				{
					new str[128];
					format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(fexist(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][Skin3] = strval(inputtext);
                        SaveGang(PlayerStat[playerid][GangID]);
                        format(str, sizeof(str), "You have successfully changed rank 3 skin to %d", GangStat[PlayerStat[playerid][GangID]][Skin3]);
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    }
                }
                else
				{
				    SendClientMessage(playerid, GREY, "Skins IDs are between 0 and 299.");
				}
            }
        }
	}
	if(dialogid == DIALOG_RANK4SKIN)
    {
        if(!response) return 1;
        if(response)
        {
            if(!strval(inputtext))
            {
                SendClientMessage(playerid, GREY, "You have entered an Invalid Skin ID.");
            }
            else if(strval(inputtext))
		    {
		        if(0 < strval(inputtext) < 299)
				{
					new str[128];
					format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(fexist(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][Skin4] = strval(inputtext);
                        SaveGang(PlayerStat[playerid][GangID]);
                        format(str, sizeof(str), "You have successfully changed rank 4 skin to %d", GangStat[PlayerStat[playerid][GangID]][Skin4]);
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    }
                }
                else
				{
				    SendClientMessage(playerid, GREY, "Skins IDs are between 0 and 299.");
				}
            }
        }
	}
	if(dialogid == DIALOG_RANK5SKIN)
    {
        if(!response) return 1;
        if(response)
        {
            if(!strval(inputtext))
            {
                SendClientMessage(playerid, GREY, "You have entered an Invalid Skin ID.");
            }
            else if(strval(inputtext))
		    {
		        if(0 < strval(inputtext) < 299)
				{
					new str[128];
					format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(fexist(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][Skin5] = strval(inputtext);
                        SaveGang(PlayerStat[playerid][GangID]);
                        format(str, sizeof(str), "You have successfully changed rank 5 skin to %d", GangStat[PlayerStat[playerid][GangID]][Skin5]);
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    }
                }
                else
				{
				    SendClientMessage(playerid, GREY, "Skins IDs are between 0 and 299.");
				}
            }
        }
	}
	if(dialogid == DIALOG_RANK6SKIN)
    {
        if(!response) return 1;
        if(response)
        {
            if(!strval(inputtext))
            {
                SendClientMessage(playerid, GREY, "You have entered an Invalid Skin ID.");
            }
            else if(strval(inputtext))
		    {
		        if(0 < strval(inputtext) < 299)
				{
					new str[128];
					format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(fexist(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][Skin6] = strval(inputtext);
                        SaveGang(PlayerStat[playerid][GangID]);
                        format(str, sizeof(str), "You have successfully changed rank 6 skin to %d", GangStat[PlayerStat[playerid][GangID]][Skin6]);
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    }
                }
                else
				{
				    SendClientMessage(playerid, GREY, "Skins IDs are between 0 and 299.");
				}
            }
        }
    }
	return 1;
}

//----------------------------------------------------------
