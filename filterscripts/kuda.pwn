/*
Kuda-Kudaan By Krisno
*/

#include <a_samp>

new Text:Textdraw0;
new Text:Textdraw1;
new Text:Textdraw2;
new Text:Textdraw3;
new Text:Textdraw4;
new Text:Textdraw5;
new Text:Textdraw6;

#define HUMU_1 "ld_otb:hrs1"
#define HUMU_2 "ld_otb:hrs2"
#define HUMU_3 "ld_otb:hrs3"
#define HUMU_4 "ld_otb:hrs4"
#define HUMU_5 "ld_otb:hrs5"
#define HUMU_6 "ld_otb:hrs6"
#define HUMU_7 "ld_otb:hrs7"
#define HUMU_8 "ld_otb:hrs8"

public OnFilterScriptInit()
{
	print("+-------------------------+");
	print("|   Kuda-Kudaan Loaded    |");
	print("| if you know what i mean |");
	print("+-------------------------+");

	Textdraw0 = TextDrawCreate(77.000000, 162.000000, "_");
	TextDrawAlignment(Textdraw0, 2);
	TextDrawBackgroundColor(Textdraw0, 0);
	TextDrawFont(Textdraw0, 2);
	TextDrawLetterSize(Textdraw0, 0.500000, 16.000000);
	TextDrawColor(Textdraw0, -1);
	TextDrawSetOutline(Textdraw0, 0);
	TextDrawSetProportional(Textdraw0, 1);
	TextDrawSetShadow(Textdraw0, 1);
	TextDrawUseBox(Textdraw0, 1);
	TextDrawBoxColor(Textdraw0, -1);
	TextDrawTextSize(Textdraw0, 109.000000, 110.000000);
	TextDrawSetSelectable(Textdraw0, 0);

	Textdraw1 = TextDrawCreate(18.000000, 158.000000, "ld_drv:tvcorn");
	TextDrawBackgroundColor(Textdraw1, 0);
	TextDrawFont(Textdraw1, 4);
	TextDrawLetterSize(Textdraw1, 0.500000, 1.000000);
	TextDrawColor(Textdraw1, -1);
	TextDrawSetOutline(Textdraw1, 0);
	TextDrawSetProportional(Textdraw1, 1);
	TextDrawSetShadow(Textdraw1, 1);
	TextDrawUseBox(Textdraw1, 1);
	TextDrawBoxColor(Textdraw1, 255);
	TextDrawTextSize(Textdraw1, 60.000000, 100.000000);
	TextDrawSetSelectable(Textdraw1, 0);

	Textdraw2 = TextDrawCreate(136.000000, 158.000000, "ld_drv:tvcorn");
	TextDrawBackgroundColor(Textdraw2, 0);
	TextDrawFont(Textdraw2, 4);
	TextDrawLetterSize(Textdraw2, 0.500000, 1.000000);
	TextDrawColor(Textdraw2, -1);
	TextDrawSetOutline(Textdraw2, 0);
	TextDrawSetProportional(Textdraw2, 1);
	TextDrawSetShadow(Textdraw2, 1);
	TextDrawUseBox(Textdraw2, 1);
	TextDrawBoxColor(Textdraw2, 255);
	TextDrawTextSize(Textdraw2, -63.000000, 100.000000);
	TextDrawSetSelectable(Textdraw2, 0);

	Textdraw3 = TextDrawCreate(136.000000, 311.000000, "ld_drv:tvcorn");
	TextDrawBackgroundColor(Textdraw3, 0);
	TextDrawFont(Textdraw3, 4);
	TextDrawLetterSize(Textdraw3, 0.500000, 1.000000);
	TextDrawColor(Textdraw3, -1);
	TextDrawSetOutline(Textdraw3, 0);
	TextDrawSetProportional(Textdraw3, 1);
	TextDrawSetShadow(Textdraw3, 1);
	TextDrawUseBox(Textdraw3, 1);
	TextDrawBoxColor(Textdraw3, 255);
	TextDrawTextSize(Textdraw3, -65.000000, -61.000000);
	TextDrawSetSelectable(Textdraw3, 0);

	Textdraw4 = TextDrawCreate(18.000000, 311.000000, "ld_drv:tvcorn");
	TextDrawBackgroundColor(Textdraw4, 0);
	TextDrawFont(Textdraw4, 4);
	TextDrawLetterSize(Textdraw4, 0.500000, 1.000000);
	TextDrawColor(Textdraw4, -1);
	TextDrawSetOutline(Textdraw4, 0);
	TextDrawSetProportional(Textdraw4, 1);
	TextDrawSetShadow(Textdraw4, 1);
	TextDrawUseBox(Textdraw4, 1);
	TextDrawBoxColor(Textdraw4, 255);
	TextDrawTextSize(Textdraw4, 55.000000, -61.000000);
	TextDrawSetSelectable(Textdraw4, 0);

	Textdraw5 = TextDrawCreate(50.000000, 199.000000, "ld_otb:hrs1");
	TextDrawBackgroundColor(Textdraw5, 0);
	TextDrawFont(Textdraw5, 4);
	TextDrawLetterSize(Textdraw5, 0.500000, 1.000000);
	TextDrawColor(Textdraw5, -1);
	TextDrawSetOutline(Textdraw5, 0);
	TextDrawSetProportional(Textdraw5, 1);
	TextDrawSetShadow(Textdraw5, 1);
	TextDrawUseBox(Textdraw5, 1);
	TextDrawBoxColor(Textdraw5, 255);
	TextDrawTextSize(Textdraw5, 55.000000, 82.000000);
	TextDrawSetSelectable(Textdraw5, 0);

	Textdraw6 = TextDrawCreate(78.000000, 170.000000, "Kuda-Kudaan");
	TextDrawAlignment(Textdraw6, 2);
	TextDrawBackgroundColor(Textdraw6, 0);
	TextDrawFont(Textdraw6, 1);
	TextDrawLetterSize(Textdraw6, 0.300000, 1.499999);
	TextDrawColor(Textdraw6, 255);
	TextDrawSetOutline(Textdraw6, 0);
	TextDrawSetProportional(Textdraw6, 1);
	TextDrawSetShadow(Textdraw6, 1);
	TextDrawSetSelectable(Textdraw6, 0);

    SetTimer("animated",100,1);

	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(IsPlayerConnected(i))
		{
			TextDrawShowForPlayer(i, Textdraw0);
			TextDrawShowForPlayer(i, Textdraw1);
			TextDrawShowForPlayer(i, Textdraw2);
			TextDrawShowForPlayer(i, Textdraw3);
			TextDrawShowForPlayer(i, Textdraw4);
			TextDrawShowForPlayer(i, Textdraw5);
			TextDrawShowForPlayer(i, Textdraw6);
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
	TextDrawHideForAll(Textdraw3);
	TextDrawDestroy(Textdraw3);
	TextDrawHideForAll(Textdraw4);
	TextDrawDestroy(Textdraw4);
	TextDrawHideForAll(Textdraw5);
	TextDrawDestroy(Textdraw5);
	TextDrawHideForAll(Textdraw6);
	TextDrawDestroy(Textdraw6);
	return 1;
}

public OnPlayerConnect(playerid)
{
	TextDrawShowForPlayer(playerid, Textdraw0);
	TextDrawShowForPlayer(playerid, Textdraw1);
	TextDrawShowForPlayer(playerid, Textdraw2);
	TextDrawShowForPlayer(playerid, Textdraw3);
	TextDrawShowForPlayer(playerid, Textdraw4);
	TextDrawShowForPlayer(playerid, Textdraw5);
	TextDrawShowForPlayer(playerid, Textdraw6);
	return 1;
}
forward animated();
public animated()
{
	TextDrawSetString(Textdraw5, HUMU_1);
	SetTimer("humu2",100,1);
}
forward humu2();
public humu2()
{
	TextDrawSetString(Textdraw5, HUMU_2);
	SetTimer("humu3",100,1);
}
forward humu3();
public humu3()
{
	TextDrawSetString(Textdraw5, HUMU_3);
	SetTimer("humu4",100,1);
}
forward humu4();
public humu4()
{
	TextDrawSetString(Textdraw5, HUMU_4);
	SetTimer("humu4",100,1);
}
forward humu5();
public humu5()
{
	TextDrawSetString(Textdraw5, HUMU_5);
	SetTimer("humu6",100,1);
}
forward humu6();
public humu6()
{
	TextDrawSetString(Textdraw5, HUMU_6);
	SetTimer("humu7",100,1);
}
forward humu7();
public humu7()
{
	TextDrawSetString(Textdraw5, HUMU_7);
	SetTimer("humu8",100,1);
}
forward humu8();
public humu8()
{
	TextDrawSetString(Textdraw5, HUMU_8);
	SetTimer("animated",100,1);
}
