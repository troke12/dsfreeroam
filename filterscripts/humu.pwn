/*
MADE BY KRISNA
DONOT REMOVE CREDITS
*/

#include <a_samp>

#define HUMU_1 "~r~KRIS~b~NA ~y~PRAD~g~~h~NYA"
#define HUMU_2 "~g~~h~KRIS~r~NA ~b~PRAD~y~NYA"
#define HUMU_3 "~y~KRIS~g~~h~NA ~r~PRAD~b~NYA"
#define HUMU_4 "~b~KRIS~y~NA ~g~~h~PRAD~r~NYA"

new Text:Textdraw0;

public OnFilterScriptInit()
{
	print("File Humu Loaded");

	// Create the textdraws:
	Textdraw0 = TextDrawCreate(24.000000, 319.000000, "~r~KRIS~b~NA ~y~PRAD~g~~h~NYA");
	TextDrawBackgroundColor(Textdraw0, 255);
	TextDrawFont(Textdraw0, 2);
	TextDrawLetterSize(Textdraw0, 0.380000, 1.599999);
	TextDrawColor(Textdraw0, -1);
	TextDrawSetOutline(Textdraw0, 1);
	TextDrawSetProportional(Textdraw0, 1);
	TextDrawSetSelectable(Textdraw0, 0);
	
	SetTimer("animatedhumu",1000,1);

	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(IsPlayerConnected(i))
		{
			TextDrawShowForPlayer(i, Textdraw0);
		}
	}
	return 1;
}
forward animatedhumu();
public animatedhumu()
{
	TextDrawSetString(Textdraw0, HUMU_1);
	SetTimer("humu2",1000,1);
}
forward humu2();
public humu2()
{
	TextDrawSetString(Textdraw0, HUMU_2);
	SetTimer("humu3",1000,1);
}
forward humu3();
public humu3()
{
	TextDrawSetString(Textdraw0, HUMU_3);
	SetTimer("humu4",1000,1);
}
forward humu4();
public humu4()
{
	TextDrawSetString(Textdraw0, HUMU_4);
	SetTimer("animatedhumu",1000,1);
}
public OnFilterScriptExit()
{
	TextDrawHideForAll(Textdraw0);
	TextDrawDestroy(Textdraw0);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	TextDrawShowForPlayer(playerid, Textdraw0);
	return 1;
}
