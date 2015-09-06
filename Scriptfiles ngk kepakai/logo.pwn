/*
Filterscript generated using Zamaroht's TextDraw Editor Version 1.0.
Designed for SA-MP 0.3a.

Time and Date: 2013-11-21 @ 13:54:10

Instructions:
1- Compile this file using the compiler provided with the sa-mp server package.
2- Copy the .amx file to the filterscripts directory.
3- Add the filterscripts in the server.cfg file (more info here:
http://wiki.sa-mp.com/wiki/Server.cfg)
4- Run the server!

Disclaimer:
You have full rights over this file. You can distribute it, modify it, and
change it as much as you want, without having to give any special credits.
*/

#include <a_samp>

new Text:Textdraw0;
new Text:Textdraw1;
new Text:Textdraw2;

public OnFilterScriptInit()
{
	print("Textdraw file generated by");
	print("    Zamaroht's textdraw editor was loaded.");

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

	Textdraw1 = TextDrawCreate(506.000000, 333.000000, "~b~~h~Krisna ~r~~h~Pradnya");
	TextDrawBackgroundColor(Textdraw1, 255);
	TextDrawFont(Textdraw1, 1);
	TextDrawLetterSize(Textdraw1, 0.439999, 2.099999);
	TextDrawColor(Textdraw1, -1);
	TextDrawSetOutline(Textdraw1, 1);
	TextDrawSetProportional(Textdraw1, 1);
	TextDrawSetSelectable(Textdraw1, 0);

	Textdraw2 = TextDrawCreate(508.000000, 364.000000, "www.~b~~h~krisna.~y~ganteng.~w~ga");
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
	TextDrawShowForPlayer(playerid, Textdraw0);
	TextDrawShowForPlayer(playerid, Textdraw1);
	TextDrawShowForPlayer(playerid, Textdraw2);
	return 1;
}