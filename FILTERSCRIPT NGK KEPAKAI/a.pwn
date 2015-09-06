/* ************************ */
/* DigiSpeedo by iPLEOMAX © */
/* ************************ */

#include <a_samp>
#include <foreach>
#include <zcmd>

#define SPEED_UPDATE_TIMER 180
#define SPEED_MULTIPLIER 2
// Update Timer in Milleseconds, Less Value = More Lag. More Value = Less Lag: (Tweak on your own way)
// Speed Multiplier 2 by default, to make it feel better, actually it's 1.

new Text:Textdraw0;
new Text:Textdraw1;
new Text:Textdraw2;
new Text:Textdraw3;
new Text:Textdraw4;
new Text:Textdraw5;
new Text:Textdraw6;
new Text:Textdraw7;
new Text:Textdraw8;
new Text:Textdraw9;
new Text:Textdraw10;
new Text:Textdraw11;
new Text:Textdraw13;
new Text:Textdraw14;
new Text:Textdraw15;

new Text:Speed[MAX_PLAYERS];

new Speedo[MAX_PLAYERS];

new SpeedUpdateTimer;

public OnFilterScriptInit()
{
	print("DigiSpeedo FilterScript Loaded. (Made by iPLEOMAX)");

	Textdraw0 = TextDrawCreate(571.000000, 364.000000, "BG");
	TextDrawBackgroundColor(Textdraw0, 255);
	TextDrawFont(Textdraw0, 1);
	TextDrawLetterSize(Textdraw0, 0.000000, 2.200000);
	TextDrawColor(Textdraw0, -1);
	TextDrawSetOutline(Textdraw0, 0);
	TextDrawSetProportional(Textdraw0, 1);
	TextDrawSetShadow(Textdraw0, 1);
	TextDrawUseBox(Textdraw0, 1);
	TextDrawBoxColor(Textdraw0, 230);
	TextDrawTextSize(Textdraw0, 387.000000, 2.000000);

	Textdraw1 = TextDrawCreate(457.000000, 401.000000, "New Textdraw");
	TextDrawBackgroundColor(Textdraw1, 255);
	TextDrawFont(Textdraw1, 1);
	TextDrawLetterSize(Textdraw1, 0.000000, -0.500000);
	TextDrawColor(Textdraw1, -1);
	TextDrawSetOutline(Textdraw1, 0);
	TextDrawSetProportional(Textdraw1, 1);
	TextDrawSetShadow(Textdraw1, 1);
	TextDrawUseBox(Textdraw1, 1);
	TextDrawBoxColor(Textdraw1, 16777215);
	TextDrawTextSize(Textdraw1, 444.000000, 0.000000);

	Textdraw2 = TextDrawCreate(467.000000, 401.000000, "New Textdraw");
	TextDrawBackgroundColor(Textdraw2, 255);
	TextDrawFont(Textdraw2, 1);
	TextDrawLetterSize(Textdraw2, 0.000000, -0.600000);
	TextDrawColor(Textdraw2, -1);
	TextDrawSetOutline(Textdraw2, 0);
	TextDrawSetProportional(Textdraw2, 1);
	TextDrawSetShadow(Textdraw2, 1);
	TextDrawUseBox(Textdraw2, 1);
	TextDrawBoxColor(Textdraw2, 16777215);
	TextDrawTextSize(Textdraw2, 454.000000, -1.000000);

	Textdraw3 = TextDrawCreate(477.000000, 401.000000, "New Textdraw");
	TextDrawBackgroundColor(Textdraw3, 255);
	TextDrawFont(Textdraw3, 1);
	TextDrawLetterSize(Textdraw3, 0.000000, -0.700000);
	TextDrawColor(Textdraw3, -1);
	TextDrawSetOutline(Textdraw3, 0);
	TextDrawSetProportional(Textdraw3, 1);
	TextDrawSetShadow(Textdraw3, 1);
	TextDrawUseBox(Textdraw3, 1);
	TextDrawBoxColor(Textdraw3, 16777215);
	TextDrawTextSize(Textdraw3, 464.000000, -1.000000);

	Textdraw4 = TextDrawCreate(487.000000, 401.000000, "New Textdraw");
	TextDrawBackgroundColor(Textdraw4, 255);
	TextDrawFont(Textdraw4, 1);
	TextDrawLetterSize(Textdraw4, 0.000000, -0.800000);
	TextDrawColor(Textdraw4, -1);
	TextDrawSetOutline(Textdraw4, 0);
	TextDrawSetProportional(Textdraw4, 1);
	TextDrawSetShadow(Textdraw4, 1);
	TextDrawUseBox(Textdraw4, 1);
	TextDrawBoxColor(Textdraw4, 16777215);
	TextDrawTextSize(Textdraw4, 474.000000, -1.000000);

	Textdraw5 = TextDrawCreate(498.000000, 401.000000, "New Textdraw");
	TextDrawBackgroundColor(Textdraw5, 255);
	TextDrawFont(Textdraw5, 1);
	TextDrawLetterSize(Textdraw5, 0.000000, -0.900000);
	TextDrawColor(Textdraw5, -1);
	TextDrawSetOutline(Textdraw5, 0);
	TextDrawSetProportional(Textdraw5, 1);
	TextDrawSetShadow(Textdraw5, 1);
	TextDrawUseBox(Textdraw5, 1);
	TextDrawBoxColor(Textdraw5, 16777215);
	TextDrawTextSize(Textdraw5, 484.000000, -1.000000);

	Textdraw6 = TextDrawCreate(508.000000, 401.000000, "New Textdraw");
	TextDrawBackgroundColor(Textdraw6, 255);
	TextDrawFont(Textdraw6, 1);
	TextDrawLetterSize(Textdraw6, 0.000000, -1.000000);
	TextDrawColor(Textdraw6, -1);
	TextDrawSetOutline(Textdraw6, 0);
	TextDrawSetProportional(Textdraw6, 1);
	TextDrawSetShadow(Textdraw6, 1);
	TextDrawUseBox(Textdraw6, 1);
	TextDrawBoxColor(Textdraw6, 16777215);
	TextDrawTextSize(Textdraw6, 495.000000, -1.000000);

	Textdraw7 = TextDrawCreate(518.000000, 401.000000, "New Textdraw");
	TextDrawBackgroundColor(Textdraw7, 255);
	TextDrawFont(Textdraw7, 1);
	TextDrawLetterSize(Textdraw7, 0.000000, -1.100000);
	TextDrawColor(Textdraw7, -1);
	TextDrawSetOutline(Textdraw7, 0);
	TextDrawSetProportional(Textdraw7, 1);
	TextDrawSetShadow(Textdraw7, 1);
	TextDrawUseBox(Textdraw7, 1);
	TextDrawBoxColor(Textdraw7, 16777215);
	TextDrawTextSize(Textdraw7, 505.000000, -1.000000);

	Textdraw8 = TextDrawCreate(529.000000, 401.000000, "New Textdraw");
	TextDrawBackgroundColor(Textdraw8, 255);
	TextDrawFont(Textdraw8, 1);
	TextDrawLetterSize(Textdraw8, 0.000000, -1.300000);
	TextDrawColor(Textdraw8, -1);
	TextDrawSetOutline(Textdraw8, 0);
	TextDrawSetProportional(Textdraw8, 1);
	TextDrawSetShadow(Textdraw8, 1);
	TextDrawUseBox(Textdraw8, 1);
	TextDrawBoxColor(Textdraw8, 16777215);
	TextDrawTextSize(Textdraw8, 515.000000, -1.000000);

	Textdraw9 = TextDrawCreate(541.000000, 401.000000, "New Textdraw");
	TextDrawBackgroundColor(Textdraw9, 255);
	TextDrawFont(Textdraw9, 1);
	TextDrawLetterSize(Textdraw9, 0.000000, -1.500000);
	TextDrawColor(Textdraw9, -1);
	TextDrawSetOutline(Textdraw9, 0);
	TextDrawSetProportional(Textdraw9, 1);
	TextDrawSetShadow(Textdraw9, 1);
	TextDrawUseBox(Textdraw9, 1);
	TextDrawBoxColor(Textdraw9, 16777215);
	TextDrawTextSize(Textdraw9, 526.000000, -1.000000);

	Textdraw10 = TextDrawCreate(553.000000, 401.000000, "New Textdraw");
	TextDrawBackgroundColor(Textdraw10, 255);
	TextDrawFont(Textdraw10, 1);
	TextDrawLetterSize(Textdraw10, 0.000000, -1.700000);
	TextDrawColor(Textdraw10, -1);
	TextDrawSetOutline(Textdraw10, 0);
	TextDrawSetProportional(Textdraw10, 1);
	TextDrawSetShadow(Textdraw10, 1);
	TextDrawUseBox(Textdraw10, 1);
	TextDrawBoxColor(Textdraw10, 16777215);
	TextDrawTextSize(Textdraw10, 538.000000, -1.000000);

	Textdraw11 = TextDrawCreate(565.000000, 401.000000, "New Textdraw");
	TextDrawBackgroundColor(Textdraw11, 255);
	TextDrawFont(Textdraw11, 1);
	TextDrawLetterSize(Textdraw11, 0.000000, -2.000000);
	TextDrawColor(Textdraw11, -1);
	TextDrawSetOutline(Textdraw11, 0);
	TextDrawSetProportional(Textdraw11, 1);
	TextDrawSetShadow(Textdraw11, 1);
	TextDrawUseBox(Textdraw11, 1);
	TextDrawBoxColor(Textdraw11, 16777215);
	TextDrawTextSize(Textdraw11, 550.000000, -1.000000);

	Textdraw13 = TextDrawCreate(446.000000, 367.000000, "MPH");
	TextDrawBackgroundColor(Textdraw13, 255);
	TextDrawFont(Textdraw13, 2);
	TextDrawLetterSize(Textdraw13, 0.329999, 1.099999);
	TextDrawColor(Textdraw13, -1);
	TextDrawSetOutline(Textdraw13, 0);
	TextDrawSetProportional(Textdraw13, 1);
	TextDrawSetShadow(Textdraw13, 0);

	Textdraw14 = TextDrawCreate(571.000000, 410.000000, "New Textdraw");
	TextDrawBackgroundColor(Textdraw14, 255);
	TextDrawFont(Textdraw14, 1);
	TextDrawLetterSize(Textdraw14, 0.000000, -0.099999);
	TextDrawColor(Textdraw14, -1);
	TextDrawSetOutline(Textdraw14, 0);
	TextDrawSetProportional(Textdraw14, 1);
	TextDrawSetShadow(Textdraw14, 1);
	TextDrawUseBox(Textdraw14, 1);
	TextDrawBoxColor(Textdraw14, 190);
	TextDrawTextSize(Textdraw14, 387.000000, 2.000000);

	Textdraw15 = TextDrawCreate(571.000000, 359.000000, "New Textdraw");
	TextDrawBackgroundColor(Textdraw15, 255);
	TextDrawFont(Textdraw15, 1);
	TextDrawLetterSize(Textdraw15, 0.000000, -0.099999);
	TextDrawColor(Textdraw15, -1);
	TextDrawSetOutline(Textdraw15, 0);
	TextDrawSetProportional(Textdraw15, 1);
	TextDrawSetShadow(Textdraw15, 1);
	TextDrawUseBox(Textdraw15, 1);
	TextDrawBoxColor(Textdraw15, 180);
	TextDrawTextSize(Textdraw15, 387.000000, 2.000000);

	SpeedUpdateTimer = SetTimer("SpeedUpdate",SPEED_UPDATE_TIMER,true);

	return true;
}

public OnFilterScriptExit()
{
	KillTimer(SpeedUpdateTimer);
	return true;
}

public OnPlayerConnect(playerid)
{
    Speed[playerid] = TextDrawCreate(441.000000, 362.000000, "000");
	TextDrawAlignment(Speed[playerid], 3);
	TextDrawBackgroundColor(Speed[playerid], -16776961);
	TextDrawFont(Speed[playerid], 3);
	TextDrawLetterSize(Speed[playerid], 0.740000, 4.299999);
	TextDrawColor(Speed[playerid], 255);
	TextDrawSetOutline(Speed[playerid], 1);
	TextDrawSetProportional(Speed[playerid], 1);
	return true;
}

public OnPlayerDisconnect(playerid, reason)
{
	return true;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER && Speedo[playerid] == 1) ShowTD(playerid);
	if(oldstate == PLAYER_STATE_DRIVER && Speedo[playerid] == 1) HideTD(playerid);
	return true;
}

forward SpeedUpdate();
public SpeedUpdate()
{
	foreach(Player, i)
	{
	    if(IsPlayerInAnyVehicle(i) && Speedo[i] != 0)
	    {
	        new Float:SPD, Float:vx, Float:vy, Float:vz;
	        GetVehicleVelocity(GetPlayerVehicleID(i), vx,vy,vz);
			SPD = floatsqroot(((vx*vx)+(vy*vy))+(vz*vz))*100;
			TextdrawUpdate(i, SPD*SPEED_MULTIPLIER);
	    }
	}
	return true;
}

CMD:speedo(playerid, params[])
{
    if(Speedo[playerid] == 0) {
        SendClientMessage(playerid, 0xFFFFFFFF, "Digital Speedometer: {00FF00}Activated.");
        Speedo[playerid] = 1;
        if(IsPlayerInAnyVehicle(playerid)) ShowTD(playerid);
    } else {
        SendClientMessage(playerid, 0xFFFFFFFF, "Digital Speedometer: {FF0000}Turned Off.");
        Speedo[playerid] = 0;
        HideTD(playerid);
    }
	return true;
}

forward TextdrawUpdate(playerid, Float:speed);
public TextdrawUpdate(playerid, Float:speed)
{
	new SS[4];
	format(SS,4,"%f",speed);
	TextDrawSetString(Speed[playerid], SS);

	if(speed >= 10) { TextDrawShowForPlayer(playerid, Textdraw1); }
	else TextDrawHideForPlayer(playerid, Textdraw1);
	if(speed >= 30) { TextDrawShowForPlayer(playerid, Textdraw2); }
	else TextDrawHideForPlayer(playerid, Textdraw2);
	if(speed >= 50) { TextDrawShowForPlayer(playerid, Textdraw3); }
	else TextDrawHideForPlayer(playerid, Textdraw3);
	if(speed >= 70) { TextDrawShowForPlayer(playerid, Textdraw4); }
	else TextDrawHideForPlayer(playerid, Textdraw4);
	if(speed >= 90) { TextDrawShowForPlayer(playerid, Textdraw5); }
	else TextDrawHideForPlayer(playerid, Textdraw5);
	if(speed >= 110) { TextDrawShowForPlayer(playerid, Textdraw6); }
	else TextDrawHideForPlayer(playerid, Textdraw6);
	if(speed >= 130) { TextDrawShowForPlayer(playerid, Textdraw7); }
	else TextDrawHideForPlayer(playerid, Textdraw7);
	if(speed >= 150) { TextDrawShowForPlayer(playerid, Textdraw8); }
	else TextDrawHideForPlayer(playerid, Textdraw8);
	if(speed >= 170) { TextDrawShowForPlayer(playerid, Textdraw9); }
	else TextDrawHideForPlayer(playerid, Textdraw9);
	if(speed >= 180) { TextDrawShowForPlayer(playerid, Textdraw10); }
	else TextDrawHideForPlayer(playerid, Textdraw10);
	if(speed >= 200) { TextDrawShowForPlayer(playerid, Textdraw11); }
	else TextDrawHideForPlayer(playerid, Textdraw11);
	return true;
}

forward ShowTD(playerid);
public ShowTD(playerid)
{
	TextDrawShowForPlayer(playerid, Textdraw0);
	TextDrawShowForPlayer(playerid, Speed[playerid]);
	TextDrawShowForPlayer(playerid, Textdraw13);
	TextDrawShowForPlayer(playerid, Textdraw14);
	TextDrawShowForPlayer(playerid, Textdraw15);
	return true;
}

forward HideTD(playerid);
public HideTD(playerid)
{
	TextDrawHideForPlayer(playerid, Textdraw0);
	TextDrawHideForPlayer(playerid, Speed[playerid]);
	TextDrawHideForPlayer(playerid, Textdraw13);
	TextDrawHideForPlayer(playerid, Textdraw14);
	TextDrawHideForPlayer(playerid, Textdraw15);
	TextDrawHideForPlayer(playerid, Textdraw1);
	TextDrawHideForPlayer(playerid, Textdraw2);
	TextDrawHideForPlayer(playerid, Textdraw3);
	TextDrawHideForPlayer(playerid, Textdraw4);
	TextDrawHideForPlayer(playerid, Textdraw5);
	TextDrawHideForPlayer(playerid, Textdraw6);
	TextDrawHideForPlayer(playerid, Textdraw7);
	TextDrawHideForPlayer(playerid, Textdraw8);
	TextDrawHideForPlayer(playerid, Textdraw9);
	TextDrawHideForPlayer(playerid, Textdraw10);
	TextDrawHideForPlayer(playerid, Textdraw11);
	return true;
}
