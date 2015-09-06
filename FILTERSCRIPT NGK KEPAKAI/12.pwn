/* ----------------------------------------------------------
This is a simple masking system created by iGetty. This system
allows you to mask and hide your name from other players and will
also hide your name and show a label of "Masked Player_%d", where
the %d would be a random value that is assigned upon "/mask".

This will also automatically remove the mask when a player disconnects.
If a player dies with a mask on, they will then have the mask forcefully removed
and it will then show the players name tag again for all players.

There is also a name checking system that I implemented for people that may
want to use this in a game mode. They can use the following:

pMaskName(playerid), to check if the player is masked or not, if they are it will
return "Mask %d", if not it will return the actual player name.

Commands:
/mask
/unmask
/removemask (RCON admin)

Credits:
ZeeX for ZCMD.
Incognito for Streamer.
Y_Less for sscanf2
SA-MP team for the ability to script for SA-MP and for the a_samp include.
iGetty for creating this filterscript.

Please don't remove any credits for this script as it was created for the SA-MP
community out of good will and I would appreciate it if you could at least be
respectful enough to keep them there.

Thank you for using the script.

iGetty.
---------------------------------------------------------- */

#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <streamer>

new Masked[MAX_PLAYERS], Text3D:MaskLabel[MAX_PLAYERS], MaskID[MAX_PLAYERS];

#undef MAX_PLAYERS
#define MAX_PLAYERS GetMaxPlayers()

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Simple Mask System by iGetty loaded!");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
    print("\n--------------------------------------");
	print(" Simple Mask System by iGetty unloaded!");
	print("--------------------------------------\n");
	return 1;
}

public OnPlayerConnect(playerid)
{
	Masked[playerid] = 0;
	MaskID[playerid] = 0;

	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(Masked[i] == 1)
	    {
			ShowPlayerNameTagForPlayer(i, playerid, false);
		}
		else
		{
		    ShowPlayerNameTagForPlayer(i, playerid, true);
		}
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(Masked[playerid] == 1)
	{
    	Masked[playerid] = 0;
		MaskID[playerid] = 0;
		DestroyDynamic3DTextLabel(MaskLabel[playerid]);
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(Masked[playerid] == 1)
	{
	    DestroyDynamic3DTextLabel(MaskLabel[playerid]);
	    for(new i = 0; i < MAX_PLAYERS; i++) ShowPlayerNameTagForPlayer(i, playerid, true);
	    Masked[playerid] = 0;
	    MaskID[playerid] = 0;
	    SendClientMessage(playerid, -1, "As you have died, the nurses took off your mask to reveal your identity.");
	}
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

command(mask, playerid, params[])
{
	if(Masked[playerid] == 0)
	{
		new rand = 1000 + random(8999), string[128];
		MaskID[playerid] = rand;
    	for(new i = 0; i < MAX_PLAYERS; i++) ShowPlayerNameTagForPlayer(i, playerid, false);
    	Masked[playerid] = 1;
    	format(string, sizeof(string), "Stranger_%d", MaskID[playerid]);
		MaskLabel[playerid] = CreateDynamic3DTextLabel(string, -1, 0, 0, -20, 25, playerid);
		Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, MaskLabel[playerid] , E_STREAMER_ATTACH_OFFSET_Z, 0.30);
	}
	else return SendClientMessage(playerid, -1, "You are already masked!");
	return 1;
}

command(removemask, playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		new id, string[128];
		if(sscanf(params, "u", id))return SendClientMessage(playerid, -1, "Usage: /removemask [player id or name]");
		{
		    if(IsPlayerConnected(id))
		    {
		    	if(Masked[id] == 1)
		    	{
					format(string, sizeof(string), "Admin %s has forced %s to take off their mask.", pName(playerid), pName(id));
					SendClientMessageToAll(-1, string);
					DestroyDynamic3DTextLabel(MaskLabel[id]);
					for(new i = 0; i < MAX_PLAYERS; i++) ShowPlayerNameTagForPlayer(i, id, true);
					Masked[id] = 0;
					MaskID[id] = 0;
		    	}
		    	else return SendClientMessage(playerid, -1, "That player isn't masked.");
			}
			else return SendClientMessage(playerid, -1, "That player isn't connected.");
		}
	}
	else return SendClientMessage(playerid, -1, "You must be logged into RCON to use this.");
	return 1;
}

command(unmask, playerid, params[])
{
	if(Masked[playerid] == 1)
	{
	    new string[128];
	    format(string, sizeof(string), "** %s has taken off their mask!", pName(playerid));
		SendClientMessageToAll(-1, string);
	    DestroyDynamic3DTextLabel(MaskLabel[playerid]);
	    for(new i = 0; i < MAX_PLAYERS; i++) ShowPlayerNameTagForPlayer(i, playerid, true);
	    Masked[playerid] = 0;
	    MaskID[playerid] = 0;
	}
	else return SendClientMessage(playerid, -1, "You aren't masked!");
	return 1;
}

public OnPlayerUpdate(playerid)
{
    if(Masked[playerid] == 0)
	{
	    for(new i = 0; i < MAX_PLAYERS; i++)
		{
			ShowPlayerNameTagForPlayer(i, playerid, true);
		}
	}

	if(Masked[playerid] == 1)
	{
	    for(new i = 0; i < MAX_PLAYERS; i++)
		{
			ShowPlayerNameTagForPlayer(i, playerid, false);
		}
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

stock pMaskName(playerid)
{
	new string[25];
	if(Masked[playerid] == 1) format(string, sizeof(string), "Mask %d", MaskID[playerid]);
	else format(string, sizeof(string), "%s", pName(playerid));
	return string;
}

stock pName(playerid)
{
	new name[24];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}
