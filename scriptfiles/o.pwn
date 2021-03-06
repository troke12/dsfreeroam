/*
Filterscript generated using Zamaroht's TextDraw Editor Version 1.0 (v3.1 Current).
Designed for SA-MP 0.3a.

Time and Date: 2013-12-16 @ 20:7:10

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
new Text:Textdraw3;
new Text:Textdraw4;
new Text:Textdraw5;
new Text:Textdraw6;
new Text:Textdraw7;

public OnFilterScriptInit()
{
	print("Textdraw file generated by");
	print("    Zamaroht's textdraw editor was loaded.");

	// Create the textdraws:
	Textdraw0 = TextDrawCreate(320.000000, 8.000000, "_");
	TextDrawAlignment(Textdraw0, 2);
	TextDrawBackgroundColor(Textdraw0, 255);
	TextDrawFont(Textdraw0, 1);
	TextDrawLetterSize(Textdraw0, 0.400000, 9.499998);
	TextDrawColor(Textdraw0, -1);
	TextDrawSetOutline(Textdraw0, 0);
	TextDrawSetProportional(Textdraw0, 1);
	TextDrawSetShadow(Textdraw0, 1);
	TextDrawUseBox(Textdraw0, 1);
	TextDrawBoxColor(Textdraw0, 255);
	TextDrawTextSize(Textdraw0, 0.000000, 640.000000);
	TextDrawSetSelectable(Textdraw0, 0);

	Textdraw1 = TextDrawCreate(320.000000, 1.000000, "_");
	TextDrawAlignment(Textdraw1, 2);
	TextDrawBackgroundColor(Textdraw1, 255);
	TextDrawFont(Textdraw1, 1);
	TextDrawLetterSize(Textdraw1, 0.400000, 0.399998);
	TextDrawColor(Textdraw1, -1);
	TextDrawSetOutline(Textdraw1, 0);
	TextDrawSetProportional(Textdraw1, 1);
	TextDrawSetShadow(Textdraw1, 1);
	TextDrawUseBox(Textdraw1, 1);
	TextDrawBoxColor(Textdraw1, -1);
	TextDrawTextSize(Textdraw1, 0.000000, 640.000000);
	TextDrawSetSelectable(Textdraw1, 0);

	Textdraw2 = TextDrawCreate(320.000000, 94.000000, "_");
	TextDrawAlignment(Textdraw2, 2);
	TextDrawBackgroundColor(Textdraw2, 255);
	TextDrawFont(Textdraw2, 1);
	TextDrawLetterSize(Textdraw2, 0.400000, 0.399998);
	TextDrawColor(Textdraw2, -1);
	TextDrawSetOutline(Textdraw2, 0);
	TextDrawSetProportional(Textdraw2, 1);
	TextDrawSetShadow(Textdraw2, 1);
	TextDrawUseBox(Textdraw2, 1);
	TextDrawBoxColor(Textdraw2, -1);
	TextDrawTextSize(Textdraw2, 0.000000, 640.000000);
	TextDrawSetSelectable(Textdraw2, 0);

	Textdraw3 = TextDrawCreate(202.000000, 32.000000, "~y~]~r~Bali~b~Gamers~y~]");
	TextDrawBackgroundColor(Textdraw3, 255);
	TextDrawFont(Textdraw3, 2);
	TextDrawLetterSize(Textdraw3, 0.759999, 3.100000);
	TextDrawColor(Textdraw3, -1);
	TextDrawSetOutline(Textdraw3, 0);
	TextDrawSetProportional(Textdraw3, 1);
	TextDrawSetShadow(Textdraw3, 1);
	TextDrawSetSelectable(Textdraw3, 0);

	Textdraw4 = TextDrawCreate(422.000000, 10.000000, "_");
	TextDrawBackgroundColor(Textdraw4, 255);
	TextDrawFont(Textdraw4, 5);
	TextDrawLetterSize(Textdraw4, 0.500000, 1.200000);
	TextDrawColor(Textdraw4, -1);
	TextDrawSetOutline(Textdraw4, 0);
	TextDrawSetProportional(Textdraw4, 1);
	TextDrawSetShadow(Textdraw4, 1);
	TextDrawUseBox(Textdraw4, 1);
	TextDrawBoxColor(Textdraw4, 255);
	TextDrawTextSize(Textdraw4, 100.000000, 80.000000);
	TextDrawSetSelectable(Textdraw4, 0);

	Textdraw5 = TextDrawCreate(128.000000, 9.000000, "_");
	TextDrawBackgroundColor(Textdraw5, 255);
	TextDrawFont(Textdraw5, 5);
	TextDrawLetterSize(Textdraw5, 0.500000, 1.000000);
	TextDrawColor(Textdraw5, -1);
	TextDrawSetOutline(Textdraw5, 0);
	TextDrawSetProportional(Textdraw5, 1);
	TextDrawSetShadow(Textdraw5, 1);
	TextDrawUseBox(Textdraw5, 1);
	TextDrawBoxColor(Textdraw5, 255);
	TextDrawTextSize(Textdraw5, 100.000000, 80.000000);
	TextDrawSetSelectable(Textdraw5, 0);

	Textdraw6 = TextDrawCreate(211.000000, 60.000000, "-");
	TextDrawBackgroundColor(Textdraw6, 255);
	TextDrawFont(Textdraw6, 3);
	TextDrawLetterSize(Textdraw6, 16.450027, 1.000000);
	TextDrawColor(Textdraw6, -1);
	TextDrawSetOutline(Textdraw6, 0);
	TextDrawSetProportional(Textdraw6, 1);
	TextDrawSetShadow(Textdraw6, 1);
	TextDrawSetSelectable(Textdraw6, 0);

	Textdraw7 = TextDrawCreate(211.000000, 23.000000, "-");
	TextDrawBackgroundColor(Textdraw7, 255);
	TextDrawFont(Textdraw7, 3);
	TextDrawLetterSize(Textdraw7, 16.450027, 1.000000);
	TextDrawColor(Textdraw7, -1);
	TextDrawSetOutline(Textdraw7, 0);
	TextDrawSetProportional(Textdraw7, 1);
	TextDrawSetShadow(Textdraw7, 1);
	TextDrawSetSelectable(Textdraw7, 0);

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
	TextDrawHideForAll(Textdraw3);
	TextDrawDestroy(Textdraw3);
	TextDrawHideForAll(Textdraw4);
	TextDrawDestroy(Textdraw4);
	TextDrawHideForAll(Textdraw5);
	TextDrawDestroy(Textdraw5);
	TextDrawHideForAll(Textdraw6);
	TextDrawDestroy(Textdraw6);
	TextDrawHideForAll(Textdraw7);
	TextDrawDestroy(Textdraw7);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	TextDrawShowForPlayer(playerid, Textdraw0);
	TextDrawShowForPlayer(playerid, Textdraw1);
	TextDrawShowForPlayer(playerid, Textdraw2);
	TextDrawShowForPlayer(playerid, Textdraw3);
	TextDrawShowForPlayer(playerid, Textdraw4);
	TextDrawShowForPlayer(playerid, Textdraw5);
	TextDrawShowForPlayer(playerid, Textdraw6);
	TextDrawShowForPlayer(playerid, Textdraw7);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	TextDrawHideForPlayer(playerid, Textdraw0);
	TextDrawHideForPlayer(playerid, Textdraw1);
	TextDrawHideForPlayer(playerid, Textdraw2);
	TextDrawHideForPlayer(playerid, Textdraw3);
	TextDrawHideForPlayer(playerid, Textdraw4);
	TextDrawHideForPlayer(playerid, Textdraw5);
	TextDrawHideForPlayer(playerid, Textdraw6);
	TextDrawHideForPlayer(playerid, Textdraw7);
	return 1;
}

