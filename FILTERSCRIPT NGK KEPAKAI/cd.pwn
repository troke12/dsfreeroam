#include "a_samp"
#include "zcmd"
new Count;
#define RANGEOFSTARTER 20 // freezes all that are in range of player(20 meters) that
// actived /countdown
forward Counting(playerid);
forward Counting2(playerid);
forward Counting1(playerid);
forward CountingGO(playerid);
public OnFilterScriptInit()
{
	Count = 0;
}
CMD:countdown(playerid,params[])
{
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid, x, y, z);
	if (Count == 0)
	{
	SetTimer("Counting",1000,false);
	}else{
	SendClientMessage(playerid, 0xFF0000FF,"Countdown already started!");
	}
	if IsPlayerInRangeOfPoint(playerid, RANGEOFSTARTER, x, y, z)*then
	{
	TogglePlayerControllable(playerid, 0);
	}
	return 1;
}
public Counting(playerid)
{
	Count = 1;
	GameTextForAll("~y~3",1000,6);
    PlayerPlaySound(playerid, 1056,0,0,0);
	SetTimer("Counting2",1000,false);
	return 1;
}
public Counting2(playerid)
{
	Count = 1;
	GameTextForAll("~g~2",1000,6);
    PlayerPlaySound(playerid, 1056,0,0,0);
	SetTimer("Counting1",1000,false);
	return 1;
}
public Counting1(playerid)
{
	Count = 1;
	GameTextForAll("~b~1",1000,6);
    PlayerPlaySound(playerid, 1056,0,0,0);
	SetTimer("CountingGO",1000,false);
	return 1;
}
public CountingGO(playerid)
{
	Count = 0;
    PlayerPlaySound(playerid, 1057,0,0,0);
	GameTextForAll("~r~GO!!!",1000,6);
    TogglePlayerControllable(playerid, 1);
	return 1;
}

