#define FILTERSCRIPT

#include <a_samp>
#include <zcmd>

#define COLOR_WHITE 0xFFFFFFAA

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Easy AFK/BRB Script Made by Pro_Drifter");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

CMD:afk(playerid, params [])
{
    new string[129], pName[MAX_PLAYER_NAME];
    GetPlayerName(playerid,pName,MAX_PLAYER_NAME);
    SendClientMessage(playerid, COLOR_WHITE, "You are now AFK.");
    format(string,sizeof string, "%s is now AFK (Away From Keyboard).",pName);
    SendClientMessageToAll(0xFF0000AA,string);
    TogglePlayerControllable(playerid, 0);
    return 1;
}

CMD:brb(playerid, params [])
{
    new string[129], pName[MAX_PLAYER_NAME];
    GetPlayerName(playerid,pName,MAX_PLAYER_NAME);
    SendClientMessage(playerid, COLOR_WHITE, "You are now BRB.");
    format(string,sizeof string, "%s is now BRB (Be Right Back).",pName);
    SendClientMessageToAll(0xFF0000AA,string);
    TogglePlayerControllable(playerid, 0);
    return 1;
}

CMD:back(playerid, params [])
{
    new string[129], pName[MAX_PLAYER_NAME];
    GetPlayerName(playerid,pName,MAX_PLAYER_NAME);
    SendClientMessage(playerid, COLOR_WHITE, "You are no longer AFK/BRB.");
    format(string,sizeof string, "%s is no longer AFK/BACK.",pName);
    SendClientMessageToAll(0xFF0000AA,string);
    TogglePlayerControllable(playerid, 1);
    return 1;
}
#endif
