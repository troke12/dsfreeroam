/*
Logo Name By Krisna

Tutorial
-Ganti web www.krisna.ganteng.ga ke nama web kamu sendiri
*/

#include <a_samp>

new Text:Textdraw0;
new Text:Textdraw1;
new Text:Textdraw2;

public OnFilterScriptInit()
{
	print("______________________________");
	print(" *LOGO NAME BY KRISNA LOADED* ");
	print("______________________________");

	// Create the textdraws:
	Textdraw0 = TextDrawCreate(486.000000, 354.000000, "-");
	TextDrawBackgroundColor(Textdraw0, -1);
	TextDrawFont(Textdraw0, 1);
	TextDrawLetterSize(Textdraw0, 10.890008, 0.699998);
	TextDrawColor(Textdraw0, -1);
	TextDrawSetOutline(Textdraw0, 0);
	TextDrawSetProportional(Textdraw0, 1);
	TextDrawSetShadow(Textdraw0, 1);
	TextDrawSetSelectable(Textdraw0, 0);

	Textdraw1 = TextDrawCreate(506.000000, 333.000000, "Krisna is a Handsome");//ga Boleh Ganti :P
	TextDrawBackgroundColor(Textdraw1, 255);
	TextDrawFont(Textdraw1, 1);
	TextDrawLetterSize(Textdraw1, 0.439999, 2.099999);
	TextDrawColor(Textdraw1, -1);
	TextDrawSetOutline(Textdraw1, 1);
	TextDrawSetProportional(Textdraw1, 1);
	TextDrawSetSelectable(Textdraw1, 0);

	Textdraw2 = TextDrawCreate(508.000000, 364.000000, "www~r~.~b~~h~krisna~r~.~y~ganteng~r~.~w~ga");
	TextDrawBackgroundColor(Textdraw2, 255);
	TextDrawFont(Textdraw2, 2);
	TextDrawLetterSize(Textdraw2, 0.210000, 1.100000);
	TextDrawColor(Textdraw2, -1);
	TextDrawSetOutline(Textdraw2, 1);
	TextDrawSetProportional(Textdraw2, 1);
	TextDrawSetSelectable(Textdraw2, 0);

	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(IsPlayerConnected(i))
		{
			TextDrawShowForPlayer(i, Textdraw0);
			TextDrawShowForPlayer(i, Textdraw1);
			TextDrawShowForPlayer(i, Textdraw2);
		}
	}
	return 1;
}

public OnFilterScriptExit()
{
	TextDrawHideForAll(Textdraw0);
	TextDrawDestroy(Textdraw0);
	TextDrawHideForAll(Textdraw1);
	TextDrawDestroy(Textdraw1);
	TextDrawHideForAll(Textdraw2);
	TextDrawDestroy(Textdraw2);
	return 1;
}

public OnPlayerConnect(playerid)
{
	SendClientMessage(playerid, -1, "Yang Baca Homo, woi jangan dibaca, ah lu homo yeh?");
	return 1;
}
public OnPlayerSpawn(playerid)
{
	new PlayerName[MAX_PLAYER_NAME];
	new string[256];
	GetPlayerName(playerid, PlayerName, MAX_PLAYER_NAME);
	format(string,32,"~b~~h~%s",PlayerName);
   	TextDrawSetString(Textdraw1,string);
	TextDrawShowForPlayer(playerid, Textdraw0);
	TextDrawShowForPlayer(playerid, Textdraw1);
	TextDrawShowForPlayer(playerid, Textdraw2);
	return 1;
}
public OnPlayerCommandText(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/hidelogo", true))
    {
    	TextDrawHideForPlayer(playerid, Textdraw0);
		TextDrawHideForPlayer(playerid, Textdraw1);
		TextDrawHideForPlayer(playerid, Textdraw2);
		return 1;
	}
	
 	if(!strcmp(cmdtext, "/showlogo", true))
    {
    	TextDrawShowForPlayer(playerid, Textdraw0);
		TextDrawShowForPlayer(playerid, Textdraw1);
		TextDrawShowForPlayer(playerid, Textdraw2);
		return 1;
	}
	return 1;
}
