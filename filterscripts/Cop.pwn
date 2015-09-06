#include <a_samp>
#include <dini>
#include <foreach>
#include <OPSP>

#define DISTANCE_BETWEEN_PLAYERS 5
#define COLOR_ROB 0x00FFFFFF
#define COLOR_FAIL 0x00FFFFFF
#define COLOR_ERROR 0xFF0000FF
#define ROB_TIME 300000
#define SECONDS 10
#define TAZE_MS 400

#define FILTERSCRIPT
#define dcmd(%1,%2,%3) if (!strcmp((%3)[1], #%1, true, (%2)) && ((((%3)[(%2) + 1] == '\0') && (dcmd_%1(playerid, ""))) || (((%3)[(%2) + 1] == ' ') && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
#pragma unused ret_memcpy

#define COP_COLOR 	0x375FFFFF
#define RED         0xF00000FF

#define DIALOG_TICKET 1
#define DIALOG_COP_HELP 2

#define NORMAL_PLAYER 0
#define COP_RANK_1 1
#define COP_RANK_2 2
#define COP_RANK_3 3
#define COP_RANK_4 4
#define COP_RANK_5 5
#define COP_RANK_6 6
#define COP_RANK_7 7
#define COP_RANK_8 8

new gTeam[MAX_PLAYERS];
new CopDuty[MAX_PLAYERS];
new JailTimer[MAX_PLAYERS];
new robtime[MAX_PLAYERS];
new ID;
new pTazed[MAX_PLAYERS];
new CountTimer[MAX_PLAYERS];
new Count;

enum Statistics
{
	Arrests,
	Tickets,
	Suspected_Players,
	TicketingCop[MAX_PLAYERS],
	Jailed,
	JailTime,
};
new Info[MAX_PLAYERS][Statistics];

forward TeamChat(string[]);
forward robtimer(id);
forward Jail1(player1);
forward Jail2(player1);
forward Jail3(player1);
forward JailPlayer(player1);
forward UnjailPlayer(player1);
forward Unfreeze(playerid);
forward Tazed(playerid);
forward CountDown(playerid);

public OnPlayerConnect(playerid)
{
	gTeam[playerid] = 0;
	CopDuty[playerid] = 0;
	Info[playerid][Jailed] = 0;
	Info[playerid][JailTime] = 0;
	new string[128], Playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, Playername, sizeof(Playername));
	format(string, sizeof(string), "Police System/%s.ini", Playername);
	if(fexist(string))
	{
		gTeam[playerid] = dini_Int(string, "Team");
		Info[playerid][Jailed] = dini_Int(string, "Jailed");
		Info[playerid][JailTime] = dini_Int(string, "Jail Timer");
		SetPlayerWantedLevel(playerid, dini_Int(string, "Wanted Level"));
		if((gTeam[playerid] <= 8) && (gTeam[playerid] > 0))
		{
			Info[playerid][Arrests] = dini_Int(string, "Arrests");
			Info[playerid][Tickets] = dini_Int(string, "Tickets");
			Info[playerid][Suspected_Players] = dini_Int(string, "Suspected Players");
		}
	}
	else
	{
		dini_Create(string);
		dini_IntSet(string, "Team", gTeam[playerid]);
		dini_IntSet(string, "Jailed", Info[playerid][Jailed]);
		dini_IntSet(string, "Jail Timer", Info[playerid][JailTime]);
		dini_IntSet(string, "Wanted Level", GetPlayerWantedLevel(playerid));
		dini_IntSet(string, "Arrests", Info[playerid][Arrests]);
		dini_IntSet(string, "Tickets", Info[playerid][Tickets]);
		dini_IntSet(string, "Suspected Players", Info[playerid][Suspected_Players]);
	}
	if(Info[playerid][Jailed] == 1)
	{
	    SendClientMessage(playerid, RED, "You can't escape your punishment, you are still in jail!");
		SetTimerEx("JailPlayer",3000,0,"d",playerid);
		JailTimer[playerid] = SetTimerEx("UnjailPlayer",Info[playerid][JailTime],0,"d",playerid);
	}
}
public OnPlayerRequestSpawn(playerid)
{
    if(GetPlayerWantedLevel(playerid) > 0)
	{
		new string[256], name[MAX_PLAYER_NAME]; GetPlayerName(playerid, name, sizeof(name));
    	format(string, sizeof(string), "Police Radio: Suspect %s has joined the server (Wanted Level: %i)", name, GetPlayerWantedLevel(playerid));
    	return TeamChat(string);
	}
    return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	new string[128], Playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, Playername, sizeof(Playername));
	format(string, sizeof(string), "Police System/%s.ini", Playername);
	if(fexist(string))
	{
		dini_IntSet(string, "Team", gTeam[playerid]);
        dini_IntSet(string, "Jailed", Info[playerid][Jailed]);
		dini_IntSet(string, "Jail Timer", Info[playerid][JailTime]);
		dini_IntSet(string, "Wanted Level", GetPlayerWantedLevel(playerid));
		if((gTeam[playerid] <= 8) && (gTeam[playerid] > 0))
		{
			dini_IntSet(string, "Arrests", Info[playerid][Arrests]);
			dini_IntSet(string, "Tickets", Info[playerid][Tickets]);
			dini_IntSet(string, "Suspected Players", Info[playerid][Suspected_Players]);
		}
	}
	else
	{
		dini_Create(string);
		dini_IntSet(string, "Team", gTeam[playerid]);
		dini_IntSet(string, "Jailed", Info[playerid][Jailed]);
		dini_IntSet(string, "Jail Timer", Info[playerid][JailTime]);
		dini_IntSet(string, "Wanted Level", GetPlayerWantedLevel(playerid));
		if((gTeam[playerid] <= 8) && (gTeam[playerid] > 0))
		{
			dini_IntSet(string, "Arrests", Info[playerid][Arrests]);
			dini_IntSet(string, "Tickets", Info[playerid][Tickets]);
			dini_IntSet(string, "Suspected Players", Info[playerid][Suspected_Players]);
		}
	}
	if(CopDuty[playerid] == 1)
	{
		ResetPlayerWeapons(playerid);
		CopDuty[playerid] = 0;
		return 1;
	}
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if(Info[playerid][Jailed] == 1) return SendClientMessage(playerid, RED, "ERROR: You can't use commands in jail!");
	dcmd(lvpd,4,cmdtext);
	dcmd(sfpd,4,cmdtext);
	dcmd(lspd,4,cmdtext);
    dcmd(invite,6,cmdtext);
    dcmd(uninvite,8,cmdtext);
    dcmd(setrank,7,cmdtext);
    dcmd(arrest,6,cmdtext);
    dcmd(release,7,cmdtext);
    dcmd(ticket,6,cmdtext);
    dcmd(r,1,cmdtext);
    dcmd(copduty,7,cmdtext);
    dcmd(wlist,5,cmdtext);
    dcmd(su,2,cmdtext);
    dcmd(cops,4,cmdtext);
    dcmd(backup,6,cmdtext);
    dcmd(rob,3,cmdtext);
    dcmd(cstats,6,cmdtext);
    dcmd(eject,5,cmdtext);
    dcmd(cgoto,5,cmdtext);
    dcmd(cophelp,7,cmdtext);
    return 0;
}
dcmd_lvpd(playerid,params[])
{
	#pragma unused params
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	new string[100];
	format(string, sizeof(string),"%s has teleported to Las Venturas Police Department (/lvpd)", name, playerid);
	SetPlayerPos(playerid, 238.6504,140.9647,1003.0234);
	SetPlayerInterior(playerid, 3);
	return SendClientMessageToAll(0xF5D20AFF, string);
}
dcmd_sfpd(playerid,params[])
{
    #pragma unused params
    new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	new string[100];
	format(string, sizeof(string),"%s has teleported to San Fierro Police Department (/sfpd)", name, playerid);
	SetPlayerPos(playerid, 246.4131,114.0250,1003.2188);
	SetPlayerInterior(playerid, 10);
	return SendClientMessageToAll(0xF5D20AFF, string);
}
dcmd_lspd(playerid,params[])
{
    #pragma unused params
   	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	new string[100];
	format(string, sizeof(string),"%s has teleported to Los Santos Police Department (/lspd)", name, playerid);
	SetPlayerPos(playerid, 246.783996,63.900199,1003.640625);
	SetPlayerInterior(playerid, 6);
	return SendClientMessageToAll(0xF5D20AFF, string);
}
dcmd_invite(playerid,params[])
{
	if((gTeam[playerid] == 8) || (IsPlayerAdmin(playerid)))
	{
	    if((CopDuty[playerid] == 1) || (IsPlayerAdmin(playerid)))
	    {
		    if(!strlen(params)) return SendClientMessage(playerid, RED, "Usage: /invite [Player Id]");
	    	new player1, playername[MAX_PLAYER_NAME], copname[MAX_PLAYER_NAME], string[128];
			player1 = strval(params);
		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		 	{
		 	    if(gTeam[player1] == 0)
			 	{
					GetPlayerName(player1, playername, sizeof(playername));
					GetPlayerName(playerid, copname, sizeof(copname));
					gTeam[player1] = 1;
					format(string,sizeof(string),"Police Commissioner %s has invited %s to the Police Team", copname, playername);
					return SendClientMessageToAll(COP_COLOR,string);
				}
				else return SendClientMessage(playerid, RED, "ERROR: This player is already in the Police Team");
			}
			else return SendClientMessage(playerid, RED, "ERROR: Player not found");
		}
		else return SendClientMessage(playerid, RED, "ERROR: You have to be on cop duty!");
	}
	else return SendClientMessage(playerid, RED, "ERROR: You need to be a Police Commissioner to use this command");
}
dcmd_uninvite(playerid,params[])
{
    if((gTeam[playerid] == 8) || (IsPlayerAdmin(playerid)))
	{
	    if((CopDuty[playerid] == 1) || (IsPlayerAdmin(playerid)))
	    {
		    if(!strlen(params)) return SendClientMessage(playerid, RED, "Usage: /uninvite [Player Id]");
	    	new player1, playername[MAX_PLAYER_NAME], copname[MAX_PLAYER_NAME], string[128];
			player1 = strval(params);
		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		 	{
		 	    if((gTeam[player1] <= 8) && (gTeam[player1] > 0))
			 	{
					GetPlayerName(player1, playername, sizeof(playername));
					GetPlayerName(playerid, copname, sizeof(copname));
					gTeam[player1] = 0;
					format(string,sizeof(string),"Police Commissioner %s has uninvited %s from the Police Team", copname, playername);
					return SendClientMessageToAll(COP_COLOR,string);
				}
				else return SendClientMessage(playerid, RED, "ERROR: You can't uninvite a player who is not in the Police Team");
			}
			else return SendClientMessage(playerid, RED, "ERROR: Player not found");
        }
		else return SendClientMessage(playerid, RED, "ERROR: You have to be on cop duty!");
	}
	else return SendClientMessage(playerid, RED, "ERROR: You need to be a Police Commissioner to use this command");
}
dcmd_setrank(playerid,params[])
{
	if((gTeam[playerid] == 8) || (IsPlayerAdmin(playerid)))
	{
	    if((CopDuty[playerid] == 1) || (IsPlayerAdmin(playerid)))
	    {
		    new tmp [256];
			new tmp2[256];
			new Index;
			tmp  = strtok(params,Index);
			tmp2 = strtok(params,Index);
		    if(!strlen(params))
		    {
				return SendClientMessage(playerid,RED,"Usage: /setrank [Player Id][Rank 1-8]");
			}
		   	new player1, rank, playername[MAX_PLAYER_NAME], copname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);
			if(!strlen(tmp2)) return SendClientMessage(playerid,RED,"Usage: /setrank [Player Id][Rank 1-8]");
			rank = strval(tmp2);
			if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
			{
			    if((gTeam[player1] <= 8) && (gTeam[player1] > 0))
			    {
					if(rank > 8 || rank < 1)
					return SendClientMessage(playerid,RED,"ERROR: Invalid rank [1-8]");
					if(rank == gTeam[player1]) return SendClientMessage(playerid,RED,"ERROR: Player is already this rank");
					GetPlayerName(player1, playername, sizeof(playername));
					GetPlayerName(playerid, copname, sizeof(copname));
					gTeam[player1] = rank;
					new Rank[64];
					if(gTeam[player1] == 1) { Rank = "Police Officer"; }
					else if(gTeam[player1] == 2) { Rank = "Investigator"; }
					else if(gTeam[player1] == 3) { Rank = "Sergeant"; }
					else if(gTeam[player1] == 4) { Rank = "Lieutenant"; }
					else if(gTeam[player1] == 5) { Rank = "Major"; }
					else if(gTeam[player1] == 6) { Rank = "Captain"; }
					else if(gTeam[player1] == 7) { Rank = "Commander"; }
					else if(gTeam[player1] == 8) { Rank = "Commissioner"; }
	   				if(rank > 0 && rank < 9)
					format(string,sizeof(string),"Police Radio: Commissioner %s has set %s's rank to %i [%s]",copname, playername, rank, Rank);
					TeamChat(string);
					return PlayerPlaySound(player1,1057,0.0,0.0,0.0);
				}
				else return SendClientMessage(playerid, RED, "ERROR: This player is not in the Police Team!");
			}
			else return SendClientMessage(playerid, RED, "ERROR: Player not found!");
		}
		else return SendClientMessage(playerid, RED, "ERROR: You have to be on cop duty!");
	}
	else return SendClientMessage(playerid, RED, "ERROR: You need to be a Police Commissioner to use this command");
}
dcmd_arrest(playerid,params[])
{
	if((gTeam[playerid] <= 8) && (gTeam[playerid] > 0))
	{
		if(CopDuty[playerid] == 1)
		{
			if(!strlen(params)) return SendClientMessage(playerid, RED, "Usage: /arrest [Player Id]");
			new player1, playername[MAX_PLAYER_NAME], copname[MAX_PLAYER_NAME], string[128];
			player1 = strval(params);
			if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
			{
				if(GetPlayerWantedLevel(player1) >= 2)
				{
					if(!IsPlayerInAnyVehicle(player1))
					{
						if(GetDistanceBetweenPlayers(playerid, player1) < 10)
						{
							GetPlayerName(player1, playername, sizeof(playername));
							GetPlayerName(playerid, copname, sizeof(copname));
							new jtime;
							new reward;
							reward = GetPlayerWantedLevel(player1);
							jtime = GetPlayerWantedLevel(player1);
							Info[player1][JailTime] = jtime*1000*60;
							Info[player1][Jailed] = 1;
							SetTimerEx("Jail1",1000,0,"d",player1);
							SetTimerEx("JailPlayer",5000,0,"d",player1);
							GivePlayerMoney(playerid, reward*1000);
							SetPlayerWantedLevel(player1, 0);
							SetPlayerScore(playerid, GetPlayerScore(playerid) +reward*5);
      		 				JailTimer[player1] = SetTimerEx("UnjailPlayer",Info[player1][JailTime],0,"d",player1);
							format(string,sizeof(string),"Officer %s has arrested %s for %i minutes", copname, playername, jtime);
							SendClientMessageToAll(COP_COLOR,string);
							Info[playerid][Arrests]++;
							new string2[256];
							format(string2,sizeof(string2), "Congratulations, Officer %s, you received $%i and %i score for arresting a %i-star wanted criminal!", copname, reward*1000, reward*5, reward);
							return SendClientMessage(playerid, RED, string2);
						}
						else return SendClientMessage(playerid, RED, "ERROR: You need to be close to the player to arrest him.");
					}
					else return SendClientMessage(playerid, RED, "ERROR: Player is in a vehicle!");
				}
				else return SendClientMessage(playerid, RED, "ERROR: This player doesn't have 2+ stars, you can't arrest him.");
			}
			else return SendClientMessage(playerid, RED, "ERROR: Player not found");
		}
		else return SendClientMessage(playerid, RED, "ERROR: You have to be on cop duty!");
	}
	else return SendClientMessage(playerid, RED, "ERROR: You have to be a Cop to use this command");
}
dcmd_release(playerid,params[])
{
	if((gTeam[playerid] <= 8) && (gTeam[playerid] > 0))
	{
	    if((gTeam[playerid] > 3) && (gTeam[playerid] <=8))
	    {
			if(CopDuty[playerid] == 1)
			{
				if(!strlen(params)) return SendClientMessage(playerid, RED, "Usage: /release [Player Id]");
				new player1, playername[MAX_PLAYER_NAME], copname[MAX_PLAYER_NAME], string[128];
				player1 = strval(params);
				if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
				{
					if(Info[player1][Jailed] == 1)
					{
					    KillTimer(JailTimer[player1]);
						GetPlayerName(player1, playername, sizeof(playername));
						GetPlayerName(playerid, copname, sizeof(copname));
						Info[player1][Jailed] = 1;
						SetTimerEx("UnjailPlayer",1,0,"d",player1);
						format(string,sizeof(string),"Officer %s has released %s from jail", copname, playername);
						SendClientMessageToAll(COP_COLOR,string);
						new string2[256];
						format(string2,sizeof(string2), "Officer %s has released you from jail!", copname);
						return SendClientMessage(player1, RED, string2);
					}
					else return SendClientMessage(playerid, RED, "ERROR: This player is not jailed!");
				}
				else return SendClientMessage(playerid, RED, "ERROR: Player not found!");
			}
			else return SendClientMessage(playerid, RED, "ERROR: You have to be on cop duty!");
		}
		else return SendClientMessage(playerid, RED, "ERROR: Only Ranks 4 and higher can use the /release command!");
	}
	else return SendClientMessage(playerid, RED, "ERROR: You have to be a Cop to use this command!");
}
dcmd_ticket(playerid,params[])
{
	if((gTeam[playerid] <= 8) && (gTeam[playerid] > 0))
	{
	    if(CopDuty[playerid] == 1)
		{
			if(!strlen(params)) return SendClientMessage(playerid, RED, "Usage: /ticket [Player Id]");
			new player1, playername[MAX_PLAYER_NAME], copname[MAX_PLAYER_NAME], string[128];
			player1 = strval(params);
			if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
			{
				if(GetPlayerWantedLevel(player1) == 1)
				{
				    if(GetPlayerMoney(player1) >= 1000)
				    {
						if(!IsPlayerInAnyVehicle(player1))
						{
			                if (GetDistanceBetweenPlayers(playerid, player1) < 10)
			                {
			                    KillTimer(CountTimer[player1]);
								GetPlayerName(player1, playername, sizeof(playername));
								GetPlayerName(playerid, copname, sizeof(copname));
			                    format(string,sizeof(string),"Officer %s has given you a ticket.",copname);
								ShowPlayerDialog(player1, DIALOG_TICKET, DIALOG_STYLE_MSGBOX, string, "You can choose to pay or NOT to pay the ticket: \n•If you choose to pay (Costs 1000$), your wanted level \nwill decrease to zero. \n•If you choose NOT to pay, your wanted level \nwill increase to 2 stars. \n \n{F00000}Note: {FFFFFF}You have only 10 seconds to choose between these \noptions, otherwise your will sutomatically get an additional star!", "Pay", "Don't pay");
								format(string, sizeof(string), "Officer %s has given %s a ticket", copname, playername);
								Info[playerid][Tickets]++;
								Info[player1][TicketingCop] = playerid;
								Count = 10;
								CountTimer[player1] = SetTimerEx("CountDown",1000,1,"i",player1);
								GameTextForPlayer(player1, "~r~10", 1000, 4);
								return SendClientMessageToAll(COP_COLOR, string);
							}
							else return SendClientMessage(playerid, RED, "ERROR: You need to be close to the player to give him a ticket.");
						}
						else return SendClientMessage(playerid, RED, "ERROR: Player is in a vehicle!");
					}
					else return SendClientMessage(playerid, RED, "ERROR: This player does not have $1000!");
				}
				else return SendClientMessage(playerid, RED, "ERROR: This player does not have 1 star wanted level!");
			}
			else return SendClientMessage(playerid, RED, "ERROR: Player not found");
		}
		else return SendClientMessage(playerid, RED, "ERROR: You have to be on cop duty!");
	}
	else return SendClientMessage(playerid, RED, "ERROR: You have to be a Cop to use this command");
}
dcmd_r(playerid,params[])
{
	if((gTeam[playerid] <= 8) && (gTeam[playerid] > 0))
	{
	    if(CopDuty[playerid] == 1)
		{
		    new copname[MAX_PLAYER_NAME],formatted[156];
		    if(!strlen(params)) return SendClientMessage(playerid,RED,"Usage: /r [text]");
		    GetPlayerName(playerid,copname,sizeof(copname));
		    new CopRank[64];
			if(gTeam[playerid] == 1) { CopRank = "Police Officer"; }
			else if(gTeam[playerid] == 2) { CopRank = "Investigator"; }
			else if(gTeam[playerid] == 3) { CopRank = "Sergeant"; }
			else if(gTeam[playerid] == 4) { CopRank = "Lieutenant"; }
			else if(gTeam[playerid] == 5) { CopRank = "Major"; }
			else if(gTeam[playerid] == 6) { CopRank = "Captain"; }
			else if(gTeam[playerid] == 7) { CopRank = "Commander"; }
			else if(gTeam[playerid] == 8) { CopRank = "Commissioner"; }
		    format(formatted,sizeof(formatted),"Police Radio: %s %s: %s, over.",CopRank,copname,params);
		    return TeamChat(formatted);
		}
		else return SendClientMessage(playerid, RED, "ERROR: You have to be on cop duty!");
	}
	else return SendClientMessage(playerid, RED, "ERROR: You have to be a Cop to use this command!");
}
dcmd_copduty(playerid,params[])
{
	#pragma unused params
	if((gTeam[playerid] <= 8) && (gTeam[playerid] > 0))
	{
	    new cop[MAX_PLAYER_NAME];
	    new string[256];
		if(((IsPlayerInRangeOfPoint(playerid, 150, 238.6504,140.9647,1003.0234)) && (GetPlayerInterior(playerid) == 3)) || ((IsPlayerInRangeOfPoint(playerid, 150, 246.4131,114.0250,1003.2188)) && (GetPlayerInterior(playerid) == 10)) || ((IsPlayerInRangeOfPoint(playerid, 150, 246.783996,63.900199,1003.640625)) && (GetPlayerInterior(playerid) == 6)))
		{
		    if(CopDuty[playerid] == 0)
		    {
		        CopDuty[playerid] = 1;
				new copskin;
				if(gTeam[playerid] == 1) { copskin = 280; }
				else if (gTeam[playerid] == 2) { copskin = 165; }
				else if (gTeam[playerid] == 3) { copskin = 163; }
				else if (gTeam[playerid] == 4) { copskin = 164; }
				else if (gTeam[playerid] == 5) { copskin = 282; }
				else if (gTeam[playerid] == 6) { copskin = 285; }
				else if (gTeam[playerid] == 7) { copskin = 286; }
				else if (gTeam[playerid] == 8) { copskin = 287; }
				SetPlayerSkin(playerid, copskin);
		        GivePlayerWeapon(playerid, 17, 25);
		        GivePlayerWeapon(playerid, 3, 1);
		        GivePlayerWeapon(playerid, 28, 1000);
		        GivePlayerWeapon(playerid, 31, 1000);
		        GivePlayerWeapon(playerid, 34, 100);
		        GivePlayerWeapon(playerid, 41, 1000);
		        GivePlayerWeapon(playerid, 26, 200);
		        GivePlayerWeapon(playerid, 23, 100);
		        GetPlayerName(playerid, cop, sizeof(cop));
		        format(string, sizeof(string), "Police Radio: Officer %s is now on duty!", cop);
				return TeamChat(string);
		    }
			if(CopDuty[playerid] == 1)
			{
			    CopDuty[playerid] = 0;
			    ResetPlayerWeapons(playerid);
		        GetPlayerName(playerid, cop, sizeof(cop));
		        format(string, sizeof(string), "Police Radio: Officer %s is now off duty!", cop);
				return TeamChat(string);
			}
			else return 1;
		}
		else return SendClientMessage(playerid, RED, "ERROR: You have to be in a Police HQ (/lvpd, /sfpd or /lspd)");
	}
	else return SendClientMessage(playerid, RED, "ERROR: You have to be a Cop to use this command");
}
dcmd_wlist(playerid,params[])
{
    #pragma unused params
    if((gTeam[playerid] <= 8) && (gTeam[playerid] > 0))
    {
        if(CopDuty[playerid] == 1)
        {
		    new count = 0;
		    new string[128];
			SendClientMessage(playerid, 0x00FF00FF, " ");
			SendClientMessage(playerid, 0x00FF00FF, "___________{F00000} |- Online Criminals -| {00FF00}___________");
			SendClientMessage(playerid, 0x00FF00FF, " ");
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if (IsPlayerConnected(i))
		 		{
					if (GetPlayerWantedLevel(i) >= 1)
					{
					    new name[MAX_PLAYER_NAME];
					    GetPlayerName(i,name,sizeof(name));
						format(string, 128, "%s [%d] | Wanted Level: %i",name,playerid,GetPlayerWantedLevel(i));
						SendClientMessage(playerid, COP_COLOR, string);
						count++;
					}
				}
			}
			if (count == 0)
			SendClientMessage(playerid,RED,"There are currently no criminals online");
			return SendClientMessage(playerid, 0x00FF00FF, " _______________________________________");
		}
		else return SendClientMessage(playerid, RED, "ERROR: You have to be on cop duty!");
	}
	else return SendClientMessage(playerid, RED, "ERROR: You have to be a Cop to use this command!");
}
dcmd_su(playerid, params[])
{
    if((gTeam[playerid] <= 8) && (gTeam[playerid] > 0))
    {
        if((gTeam[playerid] > 2) && ((gTeam[playerid] <= 8) && (gTeam[playerid] > 0)))
        {
	    	if(CopDuty[playerid] == 1)
	        {
			    new
			        player1,
			        gWantedLevel,
			        string[128],
			        copname[MAX_PLAYER_NAME],
			        playername[MAX_PLAYER_NAME],
			        tmp [256],
			        tmp2 [256],
			        Index
			    ;
				tmp  = strtok(params,Index);
				tmp2 = strtok(params,Index);
			    if(!strlen(params)) return SendClientMessage(playerid, RED, "USAGE: /su [Player Id][Reason]");
			    if(!strlen(tmp2)) return SendClientMessage(playerid, RED, "ERROR: Reason unspecified!");
			    GetPlayerName(playerid, copname, sizeof(copname));
			    GetPlayerName(player1, playername, sizeof(playername));
			    player1 = strval(tmp);
			    format(string, sizeof(string), "Officer %s has suspected %s. [Reason: %s]", copname, playername, params[2]);
			    SendClientMessageToAll(COP_COLOR, string);
			    Info[playerid][Suspected_Players]++;
			    gWantedLevel = GetPlayerWantedLevel(player1);
			    return SetPlayerWantedLevel(player1, gWantedLevel + 1);
			}
			else return SendClientMessage(playerid, RED, "ERROR: You have to be on cop duty!");
		}
		else return SendClientMessage(playerid, RED, "ERROR: Only Ranks 3 and higher can use the /su command!");
	}
	else return SendClientMessage(playerid, RED, "ERROR: You have to be a Cop to use this command!");
}
dcmd_cops(playerid,params[])
{
	#pragma unused params
    new count = 0;
    new string[128];
	SendClientMessage(playerid, 0x00FF00FF, " ");
	SendClientMessage(playerid, 0x00FF00FF, "___________{375FFF} |- Online Cops -| {00FF00}___________");
	SendClientMessage(playerid, 0x00FF00FF, " ");
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i))
		{
			if((gTeam[i] <= 8) && (gTeam[i] > 0))
			{
			    new name[MAX_PLAYER_NAME];
			    new CopRank[64];
				if(gTeam[i] == 1) { CopRank = "Police Officer"; }
				else if(gTeam[i] == 2) { CopRank = "Investigator"; }
				else if(gTeam[i] == 3) { CopRank = "Sergeant"; }
				else if(gTeam[i] == 4) { CopRank = "Lieutenant"; }
				else if(gTeam[i] == 5) { CopRank = "Major"; }
				else if(gTeam[i] == 6) { CopRank = "Captain"; }
				else if(gTeam[i] == 7) { CopRank = "Commander"; }
				else if(gTeam[i] == 8) { CopRank = "Commissioner"; }
			    GetPlayerName(i,name,sizeof(name));
				format(string, 128, "%s %s (%d)",CopRank,name,i);
				SendClientMessage(playerid, COP_COLOR, string);
				count++;
			}
		}
	}
	if (count == 0)
	SendClientMessage(playerid,RED,"There are currently no cops online");
	return SendClientMessage(playerid, 0x00FF00FF, " _______________________________________");
}
dcmd_backup(playerid,params[])
{
	#pragma unused params
	if((gTeam[playerid] <= 8) && (gTeam[playerid] > 0))
	{
	    if(CopDuty[playerid] == 1)
	    {
	        SetPlayerColor(playerid, 0xF00000FF);
	        new name[MAX_PLAYER_NAME];
	        new string[256];
	        GetPlayerName(playerid, name, sizeof(name));
	        format(string,sizeof(string),"Police Radio: Officer %s [%d] is requesting for backup! (To help Officer %s type /cgoto %d)",name, playerid, name, playerid);
	        TeamChat(string);
	        return TeamChat("Police Radio: Marker has been set to red");
	    }
	    else return SendClientMessage(playerid, RED, "ERROR: You have to be on cop duty!");
	}
	else return SendClientMessage(playerid, RED, "ERROR: You have to be a cop to use this command!");
}
dcmd_rob(playerid, params[])
{
		new pname[MAX_PLAYER_NAME];
		GetPlayerName(playerid, pname, sizeof(pname));
		if(!strlen(params))
	 	{
			SendClientMessage(playerid, COLOR_ERROR, "Usage: /rob [ID]");
		}
		else
		{
			ID = strval(params);
			if(robtime[playerid] == 0)
			{
				if(ID != playerid)
				{
					if(IsPlayerConnected(ID))
					{
						new oname[MAX_PLAYER_NAME];
						GetPlayerName(ID, oname, sizeof(oname));
						if(GetDistanceBetweenPlayers(playerid, ID) <= DISTANCE_BETWEEN_PLAYERS)
						{
								if(GetPlayerMoney(ID) > 0)
								{
									new rob = random(11);
									if(rob == 1 || rob == 2 || rob == 10 || rob == 11)
									{
										new string[256];
										format(string, sizeof(string), "%s (%i) noticed you trying to rob him. Attempt failed!",oname, ID);
										SendClientMessage(playerid, COLOR_ROB, string);
										format(string, sizeof(string), "~w~%s Noticed you trying to rob him.~n~Attempt failed!.",oname, ID);
										GameTextForPlayer(playerid, string, 5000, 4);
										GetPlayerName(playerid,pname,sizeof(pname));
										format(string, sizeof(string), "You noticed %s (%i) trying to rob you. His attempt has failed!", pname, playerid);
										SendClientMessage(ID, COLOR_ROB, string);
										format(string, sizeof(string), "~w~You noticed %s trying to rob you.~n~His attempt has failed!", pname, playerid);
										GameTextForPlayer(ID, string, 5000, 4);
										SetPlayerWantedLevel(playerid, GetPlayerWantedLevel(playerid) + 1);
										format(string, sizeof(string), "Police Radio: %s [%d] failed to rob %s [%d]", pname, playerid, oname, ID);
										TeamChat(string);
									}
									else if(rob == 3)
									{
										new pcash = GetPlayerMoney(ID);
										new robcash = random(pcash);
    									GivePlayerMoney(ID, -robcash);
										GivePlayerMoney(playerid, robcash);
										GetPlayerName(playerid, pname, sizeof(pname));
										new string[256];
										format(string, sizeof(string), "You have robbed $%i from %s (%i).", robcash, oname, ID);
										SendClientMessage(playerid, COLOR_ROB, string);
										format(string, sizeof(string), "~w~Robbed $%i from %s.", robcash, oname);
										GameTextForPlayer(playerid, string, 5000, 4);
										format(string, sizeof(string), "%s (%i) has robbed $%i from you.", pname, playerid, robcash);
										SendClientMessage(ID, COLOR_ROB, string);
										format(string, sizeof(string), "~w~%s has robbed $%i from you.", pname, robcash);
										GameTextForPlayer(ID, string, 5000, 4);
										SetPlayerWantedLevel(playerid, GetPlayerWantedLevel(playerid) + 1);
										format(string, sizeof(string), "Police Radio: %s [%d] robbed $%i from %s [%d]", pname, playerid, robcash, oname, ID);
										TeamChat(string);
									}
									else if(rob == 4 || rob == 5 || rob == 8)
									{
										new pcash = GetPlayerMoney(ID);
										new robcash = random(pcash);
										new robcash2 = robcash-random(robcash);
    									GivePlayerMoney(ID, -robcash2);
										GivePlayerMoney(playerid, robcash2);
										new string[256];
										GetPlayerName(playerid, pname, sizeof(pname));
										format(string, sizeof(string), "You have robbed $%i from %s (%i).", robcash2, oname, ID);
										SendClientMessage(playerid, COLOR_ROB, string);
										format(string, sizeof(string), "~w~Robbed $%i from %s.", robcash2, oname);
										GameTextForPlayer(playerid, string, 5000, 4);
										format(string, sizeof(string), "%s (%i) has robbed $%i from you.", pname, playerid, robcash2);
										SendClientMessage(ID, COLOR_ROB, string);
										format(string, sizeof(string), "~w~%s has robbed $%i from you.", pname, robcash2);
										GameTextForPlayer(ID, string, 5000, 4);
										SetPlayerWantedLevel(playerid, GetPlayerWantedLevel(playerid) + 1);
										format(string, sizeof(string), "Police Radio: %s [%d] robbed $%i from %s [%d]", pname, playerid, robcash2, oname, ID);
										TeamChat(string);
									}
									else if(rob == 6 || rob == 7)
									{
										new pcash = GetPlayerMoney(ID);
										new robcash = random(pcash);
										new robcash2 = robcash-random(robcash);
										new robcash3 = robcash2-random(robcash2);
    									GivePlayerMoney(ID, -robcash3);
										GivePlayerMoney(playerid, robcash3);
										new string[256];
										GetPlayerName(playerid, pname, sizeof(pname));
										format(string, sizeof(string), "You have robbed $%i from %s (%i).", robcash3, oname, ID);
										SendClientMessage(playerid, COLOR_ROB, string);
										format(string, sizeof(string), "%s (%i) has robbed $%i from you.", pname, playerid, robcash3);
										SendClientMessage(ID, COLOR_ROB, string);
										format(string, sizeof(string), "~w~Robbed $%i from %s.", robcash3, oname);
										GameTextForPlayer(playerid, string, 5000, 4);
										format(string, sizeof(string), "~w~%s has robbed $%i from you.", pname, robcash3);
										GameTextForPlayer(ID, string, 5000, 4);
										SetPlayerWantedLevel(playerid, GetPlayerWantedLevel(playerid) + 1);
										format(string, sizeof(string), "Police Radio: %s [%d] robbed $%i from %s [%d]", pname, playerid, robcash3, oname, ID);
										TeamChat(string);
									}
									else
									{
										SetPlayerHealth(playerid, -69);
										new string[256];
										GetPlayerName(playerid, pname, sizeof(pname));
										format(string, sizeof(string), "Your hand has stuck to %s's (%i) pocket. ", oname, ID);
										SendClientMessage(playerid, COLOR_FAIL, string);
										SendClientMessage(playerid, COLOR_FAIL, "He noticed it and ripped your arms off.");
										format(string, sizeof(string), "%s's (%i) hand has stuck to your pocket while trying to rob you.", pname, playerid);
										SendClientMessage(ID, COLOR_FAIL, string);
										SendClientMessage(ID, COLOR_FAIL, "You noticed it and ripped his arms off.");
										format(string, sizeof(string), "*** %s (%i) has bled to death.", pname, playerid);
										SendClientMessageToAll(0x880000FF, string);
										format(string, sizeof(string), "~w~%s (%d) has ripped your arms off.", oname, ID);
										GameTextForPlayer(playerid, string, 5000, 4);
										format(string, sizeof(string), "~w~Ripped %s's (%d) arms off.", oname, ID);
										GameTextForPlayer(ID, string, 5000, 4);
										SetPlayerWantedLevel(playerid, GetPlayerWantedLevel(playerid) + 1);
										format(string, sizeof(string), "Police Radio: %s [%d] has ripped %s's [%d] arms off", oname, ID, pname, playerid);
										TeamChat(string);
									}
									robtime[playerid] = 1;
									SetTimerEx("robtimer", ROB_TIME, false, "i", playerid);
								}
								else
								{
									new string[256];
									format(string, sizeof(string), "ERROR: %s (%i) has no money to rob!", oname, ID);
									SendClientMessage(playerid, COLOR_ERROR, string);
								}
						}
						else
						{
							new string[256];
							format(string, sizeof(string), "ERROR: %s (%i) is not close enough to rob.", oname, ID);
							SendClientMessage(playerid, COLOR_ERROR, string);
						}
					}
					else return SendClientMessage(playerid, COLOR_ERROR, "ERROR: Player not found!");
				}
				else return SendClientMessage(playerid, COLOR_ERROR, "ERROR: You cannot rob yourself!");
			}
			else return SendClientMessage(playerid, COLOR_ERROR, "Please wait before robbing someone again.");
		}
		return 1;
}
dcmd_cstats(playerid,params[])
{
	new string[128];
	new player1;
	new name[MAX_PLAYER_NAME];
	if(!strlen(params)) player1 = playerid;
	else player1 = strval(params);
	if(IsPlayerConnected(player1))
	{
	    if((gTeam[player1] <= 8) && (gTeam[player1] > 0))
	    {
	        GetPlayerName(player1, name, sizeof(name));
			format(string, sizeof(string), "|- %s's Police Statistics -|",name);
			SendClientMessage(playerid, 0x00FF00FF, string);
			format(string, sizeof(string), "Arrested players: %d | Tickets given: %d | Suspected players: %d", Info[player1][Arrests], Info[player1][Tickets], Info[player1][Suspected_Players]);
			return SendClientMessage(playerid, 0x00FF00FF, string);
		}
		else if(!strlen(params)) return SendClientMessage(playerid, RED, "ERROR: You are not a Cop!");
		else return SendClientMessage(playerid, RED, "ERROR: This player is not a Cop!");
	}
	else return SendClientMessage(playerid, RED, "ERROR: Player not found!");
}
dcmd_eject(playerid, params[])
{
	new player1;
	player1 = strval(params);
    if((gTeam[playerid] <= 8) && (gTeam[playerid] > 0))
    {
        if((gTeam[playerid] > 1) && ((gTeam[playerid] <= 8) && (gTeam[playerid] > 0)))
        {
	    	if(CopDuty[playerid] == 1)
	        {
	            if(!strlen(params)) return SendClientMessage(playerid, RED, "USAGE: /eject [Player Id]");
 				if(GetPlayerWantedLevel(player1) > 0)
 				{
 				    if(IsPlayerInAnyVehicle(player1))
					{
					    if(GetDistanceBetweenPlayers(playerid,player1) < 10)
					    {
						    new copname[MAX_PLAYER_NAME];
						    new playername[MAX_PLAYER_NAME];
						    new string[256];
	                        new Float:x, Float:y, Float:z;
						    GetPlayerName(playerid, copname, sizeof(copname));
						    GetPlayerName(player1, playername, sizeof(playername));
						    new CopRank[64];
							if(gTeam[playerid] == 1) { CopRank = "Police Officer"; }
							else if(gTeam[playerid] == 2) { CopRank = "Investigator"; }
							else if(gTeam[playerid] == 3) { CopRank = "Sergeant"; }
							else if(gTeam[playerid] == 4) { CopRank = "Lieutenant"; }
							else if(gTeam[playerid] == 5) { CopRank = "Major"; }
							else if(gTeam[playerid] == 6) { CopRank = "Captain"; }
							else if(gTeam[playerid] == 7) { CopRank = "Commander"; }
							else if(gTeam[playerid] == 8) { CopRank = "Commissioner"; }
						    format(string, sizeof(string), "Police Radio: %s %s has ejected %s [%d] from his vehicle.",CopRank, copname, playername, player1);
						    TeamChat(string);
						    format(string, sizeof(string), "~r~Officer %s has ejected you from your vehicle.", copname);
						    GameTextForPlayer(player1, string, 2000, 3);
						    GetPlayerPos(player1,x,y,z);
						    return SetPlayerPos(player1,x,y,z+3);
						}
						else return SendClientMessage(playerid, RED, "ERROR: You have to be close to the player!");
					}
					else return SendClientMessage(playerid, RED, "ERROR: Player is not in a vehicle!");
				}
				else return SendClientMessage(playerid, RED, "ERROR: The player you want to eject from his vehicle has no wanted level!");
			}
			else return SendClientMessage(playerid, RED, "ERROR: You have to be on cop duty!");
		}
		else return SendClientMessage(playerid, RED, "ERROR: Only Ranks 2 and higher can use the /eject command!");
	}
	else return SendClientMessage(playerid, RED, "ERROR: You have to be a Cop to use this command!");
}
dcmd_cgoto(playerid,params[])
{
    if((gTeam[playerid] <= 8) && (gTeam[playerid] > 0))
	{
	    if(CopDuty[playerid] == 1)
	    {
		    if(!strlen(params)) return SendClientMessage(playerid, RED, "Usage: /cgoto [Cop ID]");
		    new player1;
			new string[128];
		   	player1 = strval(params);
		   	if(player1 == playerid) return SendClientMessage(playerid, RED, "ERROR: You can't teleport to yourself!");
		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid)
		 	{
		 	    if((gTeam[player1] <= 8) && (gTeam[playerid] > 0))
		 	    {
					new Float:x, Float:y, Float:z;	GetPlayerPos(player1,x,y,z);
					SetPlayerInterior(playerid,GetPlayerInterior(player1));
					SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(player1));
					if(GetPlayerState(playerid) == 2)
					{
						SetVehiclePos(GetPlayerVehicleID(playerid),x+5,y,z);
						LinkVehicleToInterior(GetPlayerVehicleID(playerid),GetPlayerInterior(player1));
						SetVehicleVirtualWorld(GetPlayerVehicleID(playerid),GetPlayerVirtualWorld(player1));
					}
					else SetPlayerPos(playerid,x+2,y,z);
					new CopRank[64];
					if(gTeam[playerid] == 1) { CopRank = "Police Officer"; }
					else if(gTeam[playerid] == 2) { CopRank = "Investigator"; }
					else if(gTeam[playerid] == 3) { CopRank = "Sergeant"; }
					else if(gTeam[playerid] == 4) { CopRank = "Lieutenant"; }
					else if(gTeam[playerid] == 5) { CopRank = "Major"; }
					else if(gTeam[playerid] == 6) { CopRank = "Captain"; }
					else if(gTeam[playerid] == 7) { CopRank = "Commander"; }
					else if(gTeam[playerid] == 8) { CopRank = "Commissioner"; }
					new Rank[64];
					if(gTeam[player1] == 1) { Rank = "Police Officer"; }
					else if(gTeam[player1] == 2) { Rank = "Investigator"; }
					else if(gTeam[player1] == 3) { Rank = "Sergeant"; }
					else if(gTeam[player1] == 4) { Rank = "Lieutenant"; }
					else if(gTeam[player1] == 5) { Rank = "Major"; }
					else if(gTeam[player1] == 6) { Rank = "Captain"; }
					else if(gTeam[player1] == 7) { Rank = "Commander"; }
					else if(gTeam[player1] == 8) { Rank = "Commissioner"; }
					format(string,sizeof(string),"Police Radio: %s %s has teleported to %s %s", CopRank, playerid, Rank, player1);
					return TeamChat(string);
				}
				else return SendClientMessage(playerid, RED, "ERROR: This player is not a Cop!");
			}
			else return SendClientMessage(playerid, RED, "ERROR: Player not found!");
		}
		else return SendClientMessage(playerid, RED, "ERROR: You have to be on cop duty!");
	}
	else return SendClientMessage(playerid, RED, "ERROR: You have to be a Cop to use this command!");
}
dcmd_cophelp(playerid,params[])
{
	#pragma unused params
	new string[1500] = "{00FF00}/lvpd{FFFFFF} - The place where to turn Cop Duty on or off \n{00FF00}/sfpd{FFFFFF} - Alternate of /lvpd \n{00FF00}/lspd{FFFFFF} - Same as above \n{F00000}/copduty{FFFFFF} - Turn Cop Duty on or off \n{F00000}/wlist{FFFFFF} - See the full list of wanted players online \n{F00000}/arrest [ID]{FFFFFF} - Arrest a player if he has more than 2 stars wanted level \n{F00000}/ticket [ID]{FFFFFF} - Give a ticket to a player is he has 1 star wanted level";
	strcat(string," \n{F00000}/su [ID][Reason]{FFFFFF} - Give an additional star wanted level to a player [Reason required](Only for Rank 3 or higher) \n{F00000}/eject [ID]{FFFFFF} - Eject a wanted player from his vehicle (Only for Rank 2 or higher) \n{F00000}/r [Text]{FFFFFF} - Police Chat \n{F00000}/cgoto [Cop ID]{FFFFFF} - Teleport to another Cop \n{F00000}/backup{FFFFFF} - Request backup to other Cops \n{00FF00}/cstats [Cop ID]{FFFFFF} - See the archievements of a specific Cop");
	strcat(string," \n{00FF00}/cops{FFFFFF} - See the full list of Cops online \n{00FF00}/cophelp{FFFFFF} - Opens this dialog \n\n{F00000}/invite [ID]{FFFFFF} - Invite a player into the Police Team (Only for Rank 8 [Police Commissioner]) \n{F00000}/uninvite [ID]{FFFFFF} - Uninvites a Cop from the Police Team (Only for Rank 8 [Police Commissioner]) \n{F00000}/setrank [ID][Rank]{FFFFFF} - Set a Cop's Rank (Only for Rank 8 [Police Commissioner])");
	strcat(string," \n\n{FF8000}Note{FFFFFF}:\t{F00000}Red{FFFFFF} color defines commands used only by Cops \n\t{00FF00}Green{FFFFFF} color defines commands used by all players");
	ShowPlayerDialog(playerid,5,0, "{0080C0}Available Cop Commands",string,"Close","");
	return 1;
}
public OnPlayerShootPlayer(Shooter,Target,Float:HealthLost,Float:ArmourLost)
{
    if((gTeam[Shooter] <= 8) && (gTeam[Shooter] > 0))
    {
        if(GetPlayerWeapon(Shooter) == 23)
        {
            if(CopDuty[Shooter] == 1)
            {
                if(GetPlayerWantedLevel(Target) > 0)
                {
                    if(!IsPlayerInAnyVehicle(Target))
                    {
                        new copname[MAX_PLAYER_NAME];
                        new tazedname[MAX_PLAYER_NAME];
                        new string[256];
                        GetPlayerName(Shooter, copname, sizeof(copname));
                        GetPlayerName(Target, tazedname, sizeof(tazedname));
                        GameTextForPlayer(Target, "~r~Being Tazed", 8000, 3);
                        GameTextForPlayer(Shooter, "Tazing", 8000, 3);
                        format(string, sizeof(string), "Officer %s aims with his tazer at %s and shoots...", copname, tazedname);
                        SendClientMessageToAll(0xFF8000FF, string);
            			TogglePlayerControllable(Target, false);
				        ApplyAnimation(Target,"CRACK","crckdeth2",4.1,1,1,1,1,1);
				        ApplyAnimation(Target,"CRACK","crckdeth2",4.1,1,1,1,1,1);
				        pTazed[Target] = 1;
			            SetTimerEx("Tazed", 8000, 0, "d", Target);
					}
					else return SendClientMessage(Shooter, RED, "ERROR: The player you want to taze is in a vehicle!");
				}
				else return SendClientMessage(Shooter, RED, "ERROR: The player you want to taze has no wanted level!");
			}
        }
    }
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_TICKET)
    {
        new name[MAX_PLAYER_NAME];
        GetPlayerName(playerid, name, sizeof(name));
        new string[256];
        if(response)
        {
            KillTimer(CountTimer[playerid]);
			SetPlayerWantedLevel(playerid, 0);
			GivePlayerMoney(playerid, -1000);
            format(string, sizeof(string), "%s has paid the ticket.", name);
            SendClientMessageToAll(COP_COLOR, string);
			SetPlayerScore(Info[playerid][TicketingCop], GetPlayerScore(Info[playerid][TicketingCop]) + 5);
			GivePlayerMoney(Info[playerid][TicketingCop], 1000);
			new copname[MAX_PLAYER_NAME];
			GetPlayerName(Info[playerid][TicketingCop], copname, sizeof(copname));
			format(string, sizeof(string), "Congratulations, Officer %s, you received $1000 and 5 score for a paid ticket!", copname);
			SendClientMessage(Info[playerid][TicketingCop], RED, string);
			return KillTimer(CountTimer[playerid]);
        }
        if(!response)
        {
            KillTimer(CountTimer[playerid]);
			SetPlayerWantedLevel(playerid, 2);
            format(string, sizeof(string), "%s did NOT pay the ticket.", name);
            SendClientMessageToAll(COP_COLOR, string);
			return KillTimer(CountTimer[playerid]);
        }
        return 1;
    }
    return 0;
}

public OnPlayerSpawn(playerid)
{
	if(Info[playerid][Jailed] == 1)
	{
	    SetTimerEx("JailPlayer",1000,0,"d",playerid);
		new name[MAX_PLAYER_NAME];
		new string[256];
		GetPlayerName(playerid, name, sizeof(name));
		format(string, sizeof(string), "%s has automatically been jailed (Trying to escape punishment)", name);
		SendClientMessageToAll(0xFF8000FF, string);
	}
	if((gTeam[playerid] <= 8) && (gTeam[playerid] > 0))
	{
	    if(CopDuty[playerid] == 1)
	    {
			new copskin;
			if(gTeam[playerid] == 1) { copskin = 280; }
			else if (gTeam[playerid] == 2) { copskin = 165; }
			else if (gTeam[playerid] == 3) { copskin = 163; }
			else if (gTeam[playerid] == 4) { copskin = 164; }
			else if (gTeam[playerid] == 5) { copskin = 282; }
			else if (gTeam[playerid] == 6) { copskin = 285; }
			else if (gTeam[playerid] == 7) { copskin = 286; }
			else if (gTeam[playerid] == 8) { copskin = 287; }
			SetPlayerSkin(playerid, copskin);
			GivePlayerWeapon(playerid, 17, 25);
			GivePlayerWeapon(playerid, 3, 1);
			GivePlayerWeapon(playerid, 28, 1000);
			GivePlayerWeapon(playerid, 31, 1000);
			GivePlayerWeapon(playerid, 34, 100);
			GivePlayerWeapon(playerid, 41, 1000);
			GivePlayerWeapon(playerid, 26, 200);
			GivePlayerWeapon(playerid, 23, 100);
		}
	}
	return 1;
}
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
	GameTextForPlayer(player1,"~r~Busted By Police",3000,3);
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
	Info[player1][Jailed] = 1;
}
public UnjailPlayer(player1)
{
	KillTimer(JailTimer[player1]);
	Info[player1][JailTime] = 0;
	Info[player1][Jailed] = 0;
	SetPlayerInterior(player1,0);
	SpawnPlayer(player1);
	PlayerPlaySound(player1,1057,0.0,0.0,0.0);
	GameTextForPlayer(player1,"~g~Released ~n~From Jail",3000,3);
}
public TeamChat(string[])
{
    foreach(Player,i)
    {
        if((gTeam[i] <= 8) && (gTeam[i] > 0))
        {
            SendClientMessage(i,COP_COLOR,string);
        }
    }
    return 1;
}

stock GetDistanceBetweenPlayers(playerid, playerid2)
{
    new Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2;
    new Float:tmpdis;
    GetPlayerPos(playerid, x1, y1, z1);
    GetPlayerPos(playerid2, x2, y2, z2);
    tmpdis = floatsqroot(floatpower(floatabs(floatsub(x2, x1)), 2) + floatpower(floatabs(floatsub(y2, y1)), 2) + floatpower(floatabs(floatsub(z2, z1)), 2));
    return floatround(tmpdis);
}
public robtimer(id)
{
	robtime[id] = 0;
}
public Tazed(playerid)
{
      pTazed[playerid] = 0;
      TogglePlayerControllable(playerid, true);
      ClearAnimations(playerid);
      return 1;
}
public CountDown(playerid)
{
	Count--;
	if(Count == 0)
	{
	    ShowPlayerDialog(playerid,-1,0, " ", " ", " ", " ");
		GameTextForPlayer(playerid, "~g~You took too long to pay the ticket...",3000,3);
		SetPlayerWantedLevel(playerid, 2);
		new name[MAX_PLAYER_NAME];
		new string[256];
		GetPlayerName(playerid, name, sizeof(name));
		format(string, sizeof(string), "%s took too long to pay the ticket", name);
		SendClientMessageToAll(COP_COLOR, string);
		return KillTimer(CountTimer[playerid]);
	}
	if(Count < 0) return KillTimer(CountTimer[playerid]);
	new string[128];
	format(string,sizeof(string),"~r~%i",Count);
	GameTextForPlayer(playerid,string,1000,4);
	return 1;
}
