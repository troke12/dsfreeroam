/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
//Spawn Loading 5 seconds by Krisna

//Web: www.krisna.ganteng.ga (Keep Visit)
//Blog: wwww.krisna-pradnya.cf
//Facebook: wwww.facebook.com/krisna.pradnya

/*=-=-=-=-=-=-=-=-=-=-=-=-=EVERYTHING DO NOT REMOVE CREDITS=-=-=-=-=-=-=-=-=-=-=*/

/*--==============INCLUDE===========--*/

#include <a_samp>

/*--==============Textdraw==========--*/

new Text:Textdraw0;
new Text:Textdraw1;
new Text:Textdraw2;
new Text:Textdraw3;

/*--=========ONGAMEMODEINIT=========--*/

public OnGameModeInit()
{
	print("\n--------------------------------------");
	print(" Spawn Loading 5 seconds by Krisna");
	print("--------------------------------------\n");
	
	Textdraw0 = TextDrawCreate(-1.250000, -0.583217, "loadsc12:loadsc12");
	TextDrawLetterSize(Textdraw0, 0.000000, 0.000000);
	TextDrawTextSize(Textdraw0, 641.875000, 457.916595);
	TextDrawAlignment(Textdraw0, 1);
	TextDrawColor(Textdraw0, -1);
	TextDrawSetShadow(Textdraw0, 0);
	TextDrawSetOutline(Textdraw0, 0);
	TextDrawFont(Textdraw0, 4);

	Textdraw1 = TextDrawCreate(236.875000, 384.416656, "Krisna Freeroam's 0.3x R1-2");//You Must Change This!
	TextDrawLetterSize(Textdraw1, 0.440622, 1.961665);
	TextDrawAlignment(Textdraw1, 1);
	TextDrawColor(Textdraw1, -1);
	TextDrawSetShadow(Textdraw1, 0);
	TextDrawSetOutline(Textdraw1, 1);
	TextDrawBackgroundColor(Textdraw1, 51);
	TextDrawFont(Textdraw1, 3);
	TextDrawSetProportional(Textdraw1, 1);

	Textdraw2 = TextDrawCreate(635.125000, 415.083312, "_");
	TextDrawLetterSize(Textdraw2, 0.000000, 1.433333);
	TextDrawTextSize(Textdraw2, 489.875000, 0.000000);
	TextDrawAlignment(Textdraw2, 1);
	TextDrawColor(Textdraw2, 0);
	TextDrawUseBox(Textdraw2, true);
	TextDrawBoxColor(Textdraw2, 102);
	TextDrawSetShadow(Textdraw2, 0);
	TextDrawSetOutline(Textdraw2, 0);
	TextDrawFont(Textdraw2, 0);

	Textdraw3 = TextDrawCreate(504.375000, 412.999877, "Loading..");
	TextDrawLetterSize(Textdraw3, 0.449999, 1.600000);
	TextDrawAlignment(Textdraw3, 1);
	TextDrawColor(Textdraw3, -1);
	TextDrawSetShadow(Textdraw3, 0);
	TextDrawSetOutline(Textdraw3, 1);
	TextDrawBackgroundColor(Textdraw3, 51);
	TextDrawFont(Textdraw3, 1);
	TextDrawSetProportional(Textdraw3, 1);

	return 1;
}

public OnPlayerSpawn(playerid)
{
	TextDrawShowForPlayer(playerid, Textdraw0);
	TextDrawShowForPlayer(playerid, Textdraw1);
	TextDrawShowForPlayer(playerid, Textdraw2);
	TextDrawShowForPlayer(playerid, Textdraw3);
	SetTimer("LoadPlayer",5000,false);
	TogglePlayerControllable(playerid, false);
	return 1;
}
forward LoadPlayer();
public LoadPlayer()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			Hidetextdraw(i);
			TogglePlayerControllable(i, true);
		}
	}
}
forward Hidetextdraw(playerid);
public Hidetextdraw(playerid)
{
	TextDrawHideForPlayer(playerid, Textdraw0);
	TextDrawHideForPlayer(playerid, Textdraw1);
	TextDrawHideForPlayer(playerid, Textdraw2);
	TextDrawHideForPlayer(playerid, Textdraw3);
}
