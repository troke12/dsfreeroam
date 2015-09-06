#include "a_samp"
#include <zcmd>

new Squirtle[MAX_PLAYERS];
new SquirtleTime[MAX_PLAYERS];
new GotATurtle[MAX_PLAYERS];
new PokemonTurtle[MAX_PLAYERS];
new Cow[MAX_PLAYERS];
new CowTime[MAX_PLAYERS];
new GotACow[MAX_PLAYERS];
new PokemonCow[MAX_PLAYERS];
forward Squirtle_I_Choose_Youuuuu(playerid);
public Squirtle_I_Choose_Youuuuu(playerid)
{
    	new Float:phrr[4];
    	new playerstate = GetPlayerState(playerid);
        if (playerstate == PLAYER_STATE_DRIVER
        || playerstate == PLAYER_STATE_PASSENGER)
        {
        if(IsPlayerAttachedObjectSlotUsed(playerid,4))
        {
        SendClientMessage(playerid, 0xFF0000FF,"Are you crazy?..Turtle can't follow you when you're driving.");
        SendClientMessage(playerid, 0xFF0000FF,"Turtle is in your pokè ball!");
		KillTimer(SquirtleTime[playerid]);
        DestroyObject(Squirtle[playerid]);
		GotATurtle[playerid] = 0;
		}
        }
        if (playerstate == PLAYER_STATE_ONFOOT)
        {
        GetPlayerPos(playerid, phrr[0],phrr[1],phrr[2]);
   		GetPlayerFacingAngle(playerid, phrr[3]);
        SetObjectRot(Squirtle[playerid],0.0, 0.0, phrr[3]);
        MoveObject(Squirtle[playerid], phrr[0]-3,phrr[1],phrr[2],10);
        }
        return 1;
}

COMMAND:goturtle(playerid,params[])
{
    new Float:x1,Float:y1,Float:z1,Float:a;
    if(IsPlayerAttachedObjectSlotUsed(playerid,4))
    {
	if (GotATurtle[playerid] == 0)
	{
	GetPlayerPos(playerid,x1,y1,z1);
    GetPlayerFacingAngle(playerid, a);
    Squirtle[playerid] = CreateObject(1609,x1,y1,z1-1,a,0.0,0.0);
    SquirtleTime[playerid] = SetTimerEx("Squirtle_I_Choose_Youuuuu",1,true, "i", playerid);
    SendClientMessage(playerid, 0x00FF00FF,"TURTLE I CHOOSE YOUU , GO!");
   	SendClientMessage(playerid, 0xFFFF00FF,"Now use /getturtle to get it back to pokè ball!");
    GotATurtle[playerid] = 1;
	}
	else
	{
	SendClientMessage(playerid, 0xFF0000FF,"Are you blind?!?!");
	}
	}
    else
    {
    SendClientMessage(playerid, 0xFF0000FF,"You dont have a turtle!");
    }
	return 1;
}
COMMAND:getturtle(playerid,params[])
{
		if(IsPlayerAttachedObjectSlotUsed(playerid,4))
    	{
		if (GotATurtle[playerid] == 1)
		{
        SendClientMessage(playerid, 0xFFFF00FF,"Come back in pokè ball, turtle!");
        KillTimer(SquirtleTime[playerid]);
        DestroyObject(Squirtle[playerid]);
        GotATurtle[playerid] = 0;
		}
		else
		{
		SendClientMessage(playerid, 0xFF0000FF,"First you have to call it from your pokè ball!");
		}
		}
    	else
    	{
    	SendClientMessage(playerid, 0xFF0000FF,"You dont have a turtle!");
    	}
	    return 1;
}


public OnPlayerDisconnect(playerid)
{
        KillTimer(SquirtleTime[playerid]);
        GotATurtle[playerid] = 0;
        KillTimer(CowTime[playerid]);
        GotACow[playerid] = 0;
		return 1;
}

COMMAND:buyturtle(playerid,params[])
{
        if (IsPlayerAttachedObjectSlotUsed(playerid, 4) == 0)
        {
        SetPlayerAttachedObject(playerid, 4, 1609, 10, 0.0, 0.0,0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        SendClientMessage(playerid, 0x00FF00FF,"You have bought a turtle");
    	SendClientMessage(playerid, 0x00FF00FF,"Now use /goturtle to call it from pokè ball!");
        GivePlayerMoney(playerid, -20000);
		GotATurtle[playerid] = 0;
        PokemonTurtle[playerid] = 1;
		}
        return 1;
}
COMMAND:sellturtle(playerid,params[])
{
        if(IsPlayerAttachedObjectSlotUsed(playerid,4))
        {
        RemovePlayerAttachedObject(playerid,4);
        DestroyObject(Squirtle[playerid]);
        SendClientMessage(playerid, 0x00FF00FF,"You have sold a turtle");
    	GivePlayerMoney(playerid, 19000);
        GotATurtle[playerid] = 0;
        PokemonTurtle[playerid] = 0;
		}
        return 1;
}

 forward Cow_I_Choose_Youuuuu(playerid);
public Cow_I_Choose_Youuuuu(playerid)
{
    	new Float:phrr[4];
    	new playerstate = GetPlayerState(playerid);
        if (playerstate == PLAYER_STATE_DRIVER
        || playerstate == PLAYER_STATE_PASSENGER)
        {
        if(PokemonCow[playerid] == 1)
        {
        SendClientMessage(playerid, 0xFF0000FF,"Are you crazy?..Cow can't follow you when you're driving.");
        SendClientMessage(playerid, 0xFF0000FF,"Cow is in your pokè ball!");
		KillTimer(CowTime[playerid]);
        DestroyObject(Cow[playerid]);
		GotACow[playerid] = 0;
		}
        }
        if (playerstate == PLAYER_STATE_ONFOOT)
        {
        GetPlayerPos(playerid, phrr[0],phrr[1],phrr[2]);
   		GetPlayerFacingAngle(playerid, phrr[3]);
        SetObjectRot(Cow[playerid],0.0, 0.0, phrr[3]);
        MoveObject(Cow[playerid], phrr[0]-10,phrr[1],phrr[2],10);
        }
        return 1;
}

COMMAND:gocow(playerid,params[])
{
    new Float:x1,Float:y1,Float:z1,Float:a;
    if(PokemonCow[playerid] == 1)
    {
	if (GotACow[playerid] == 0)
	{
	GetPlayerPos(playerid,x1,y1,z1);
    GetPlayerFacingAngle(playerid, a);
    Cow[playerid] = CreateObject(16442,x1-10,y1,z1-1,a,0.0,0.0);
    CowTime[playerid] = SetTimerEx("Cow_I_Choose_Youuuuu",1,true, "i", playerid);
    SendClientMessage(playerid, 0x00FF00FF,"COW I CHOOSE YOUU , GO!");
   	SendClientMessage(playerid, 0xFFFF00FF,"Now use /getcow to get it back to pokè ball!");
    GotACow[playerid] = 1;
	}
	else
	{
	SendClientMessage(playerid, 0xFF0000FF,"Are you blind?!?!");
	}
	}
    else
    {
    SendClientMessage(playerid, 0xFF0000FF,"You dont have a cow!");
    }
	return 1;
}
COMMAND:getcow(playerid,params[])
{
		if (PokemonCow[playerid] == 1)
		{
		if (GotACow[playerid] == 1)
		{
        SendClientMessage(playerid, 0xFFFF00FF,"Come back in pokè ball, cow!");
        KillTimer(CowTime[playerid]);
        DestroyObject(Cow[playerid]);
        GotACow[playerid] = 0;
		}
		else
		{
		SendClientMessage(playerid, 0xFF0000FF,"First you have to call it from your pokè ball!");
		}
		}
    	else
    	{
    	SendClientMessage(playerid, 0xFF0000FF,"You dont have a cow!");
    	}
	    return 1;
}


COMMAND:buycow(playerid,params[])
{
        if (PokemonCow[playerid] == 0)
        {
        SendClientMessage(playerid, 0x00FF00FF,"You have bought a cow");
    	SendClientMessage(playerid, 0x00FF00FF,"Now use /gocow to call it from pokè ball!");
        GivePlayerMoney(playerid, -20000);
		GotACow[playerid] = 0;
        PokemonCow[playerid] = 1;
		}
        return 1;
}
COMMAND:sellcow(playerid,params[])
{
        if(PokemonCow[playerid] == 1)
        {
        DestroyObject(Cow[playerid]);
        SendClientMessage(playerid, 0x00FF00FF,"You have sold a cow");
    	GivePlayerMoney(playerid, 19000);
        GotACow[playerid] = 0;
        PokemonCow[playerid] = 0;
		}
        return 1;
}


