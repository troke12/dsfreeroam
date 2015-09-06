/*
************************
************************
** ADRI1 FILTERSCRIPT **
** TEXTDRAWS CREATEDS **
** WITH ZAMAROHT TEXT **
** EDITOR. EDITED  BY **
** ADRI1 VERSION SAMP **            TABLET V3.00 CREATED BY ADRI1
** 0.3E. THIS  TABLET **
** IS V3.0 CREATED BY **
** ADRI1 COMMAND  FOR **
** TEST IS:   /TABLET **
** STABLE VERSION.BYE **
************************
************************
*/
#include <a_samp>

new PlayerText:TabletWin8[23];
new PlayerText:TabletWin8Start[51];
new PlayerText:TabletWin8UserLog[13];
new PlayerText:TabletWin8Pag[4];
new PlayerText:Escritorio[4];
new PlayerText:TabletPhotos[12];
new PlayerText:TabletTime[2];
new PlayerText:TabletMusicPlayer[11];
new PlayerText:TwoBut[2];
new Timer_A[MAX_PLAYERS];
new Timer_B[MAX_PLAYERS];
new Timer_C[MAX_PLAYERS];
new Timer_D[MAX_PLAYERS];
new Timer_E[MAX_PLAYERS];
new Timer_F[MAX_PLAYERS];
new lda[MAX_PLAYERS];
public OnGameModeInit()
{
    print(" ");
    print("			************************");
    print("			************************");
	print("			** ADRI1 FILTERSCRIPT **");
	print("			** TEXTDRAWS CREATEDS **");
	print("			** WITH ZAMAROHT TEXT **");
	print("			** EDITOR. EDITED  BY **");
	print("			** ADRI1 VERSION SAMP **");
	print("			** 0.3E. THIS  TABLET **");
	print("			** IS V3.0 CREATED BY **");
	print("			** ADRI1 COMMAND  FOR **");
	print("			** TEST IS:   /TABLET **");
	print("			** STABLE VERSION.BYE **");
	print("			************************");
	print("			************************");
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	TabletWin8[0] = CreatePlayerTextDraw(playerid,122.000000, 93.000000, "O____________iiO~n~~n~~n~O____________iiO~n~~n~~n~O____________iiO");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8[0], 255);
	PlayerTextDrawFont(playerid,TabletWin8[0], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8[0], 1.600000, 8.299999);
	PlayerTextDrawColor(playerid,TabletWin8[0], 255);
	PlayerTextDrawSetOutline(playerid,TabletWin8[0], 1);
	PlayerTextDrawSetProportional(playerid,TabletWin8[0], 1);
	PlayerTextDrawSetSelectable(playerid,TabletWin8[0], 0);

	TabletWin8[1] = CreatePlayerTextDraw(playerid,122.000000, 139.000000, "_");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8[1], 255);
	PlayerTextDrawFont(playerid,TabletWin8[1], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8[1], 0.500000, 24.300001);
	PlayerTextDrawColor(playerid,TabletWin8[1], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8[1], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8[1], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8[1], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8[1], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8[1], 255);
	PlayerTextDrawTextSize(playerid,TabletWin8[1], 549.000000, 10.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8[1], 0);

	TabletWin8[2] = CreatePlayerTextDraw(playerid,120.000000, 387.000000, "hud:radardisc");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8[2], 255);
	PlayerTextDrawFont(playerid,TabletWin8[2], 4);
	PlayerTextDrawLetterSize(playerid,TabletWin8[2], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,TabletWin8[2], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8[2], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8[2], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8[2], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8[2], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8[2], 255);
	PlayerTextDrawTextSize(playerid,TabletWin8[2], 27.000000, -33.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8[2], 0);

	TabletWin8[3] = CreatePlayerTextDraw(playerid,551.000000, 388.000000, "hud:radardisc");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8[3], 255);
	PlayerTextDrawFont(playerid,TabletWin8[3], 4);
	PlayerTextDrawLetterSize(playerid,TabletWin8[3], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,TabletWin8[3], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8[3], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8[3], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8[3], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8[3], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8[3], 255);
	PlayerTextDrawTextSize(playerid,TabletWin8[3], -27.000000, -33.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8[3], 0);

	TabletWin8[4] = CreatePlayerTextDraw(playerid,551.000000, 104.000000, "hud:radardisc");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8[4], 255);
	PlayerTextDrawFont(playerid,TabletWin8[4], 4);
	PlayerTextDrawLetterSize(playerid,TabletWin8[4], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,TabletWin8[4], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8[4], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8[4], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8[4], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8[4], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8[4], 255);
	PlayerTextDrawTextSize(playerid,TabletWin8[4], -27.000000, 33.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8[4], 0);

	TabletWin8[5] = CreatePlayerTextDraw(playerid,120.000000, 104.000000, "hud:radardisc");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8[5], 255);
	PlayerTextDrawFont(playerid,TabletWin8[5], 4);
	PlayerTextDrawLetterSize(playerid,TabletWin8[5], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,TabletWin8[5], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8[5], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8[5], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8[5], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8[5], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8[5], 255);
	PlayerTextDrawTextSize(playerid,TabletWin8[5], 27.000000, 33.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8[5], 0);

	TabletWin8[6] = CreatePlayerTextDraw(playerid,148.000000, 106.000000, "_");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8[6], 255);
	PlayerTextDrawFont(playerid,TabletWin8[6], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8[6], 0.500000, 30.999998);
	PlayerTextDrawColor(playerid,TabletWin8[6], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8[6], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8[6], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8[6], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8[6], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8[6], 255);
	PlayerTextDrawTextSize(playerid,TabletWin8[6], 522.000000, 0.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8[6], 0);

	TabletWin8[7] = CreatePlayerTextDraw(playerid,149.000000, 139.000000, "_");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8[7], 255);
	PlayerTextDrawFont(playerid,TabletWin8[7], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8[7], 0.500000, 24.200004);
	PlayerTextDrawColor(playerid,TabletWin8[7], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8[7], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8[7], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8[7], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8[7], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8[7], 1718026239);
	PlayerTextDrawTextSize(playerid,TabletWin8[7], 522.000000, 10.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8[7], 0);

	TabletWin8[8] = CreatePlayerTextDraw(playerid,203.000000, 208.000000, "_");
	PlayerTextDrawAlignment(playerid,TabletWin8[8], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8[8], 255);
	PlayerTextDrawFont(playerid,TabletWin8[8], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8[8], 0.500000, 2.900000);
	PlayerTextDrawColor(playerid,TabletWin8[8], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8[8], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8[8], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8[8], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8[8], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8[8], -1);
	PlayerTextDrawTextSize(playerid,TabletWin8[8], 0.000000, 39.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8[8], 0);

	TabletWin8[9] = CreatePlayerTextDraw(playerid,203.000000, 241.000000, "_");
	PlayerTextDrawAlignment(playerid,TabletWin8[9], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8[9], 255);
	PlayerTextDrawFont(playerid,TabletWin8[9], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8[9], 0.500000, 2.900000);
	PlayerTextDrawColor(playerid,TabletWin8[9], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8[9], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8[9], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8[9], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8[9], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8[9], -1);
	PlayerTextDrawTextSize(playerid,TabletWin8[9], 0.000000, 39.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8[9], 0);

	TabletWin8[10] = CreatePlayerTextDraw(playerid,248.000000, 241.000000, "_");
	PlayerTextDrawAlignment(playerid,TabletWin8[10], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8[10], 255);
	PlayerTextDrawFont(playerid,TabletWin8[10], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8[10], 0.500000, 2.900000);
	PlayerTextDrawColor(playerid,TabletWin8[10], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8[10], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8[10], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8[10], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8[10], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8[10], -1);
	PlayerTextDrawTextSize(playerid,TabletWin8[10], 0.000000, 39.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8[10], 0);

	TabletWin8[11] = CreatePlayerTextDraw(playerid,248.000000, 208.000000, "_");
	PlayerTextDrawAlignment(playerid,TabletWin8[11], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8[11], 255);
	PlayerTextDrawFont(playerid,TabletWin8[11], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8[11], 0.500000, 2.900000);
	PlayerTextDrawColor(playerid,TabletWin8[11], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8[11], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8[11], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8[11], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8[11], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8[11], -1);
	PlayerTextDrawTextSize(playerid,TabletWin8[11], 0.000000, 39.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8[11], 0);

	TabletWin8[12] = CreatePlayerTextDraw(playerid,281.000000, 208.000000, "Windows 8");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8[12], 255);
	PlayerTextDrawFont(playerid,TabletWin8[12], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8[12], 1.159999, 5.799995);
	PlayerTextDrawColor(playerid,TabletWin8[12], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8[12], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8[12], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8[12], 0);
	PlayerTextDrawSetSelectable(playerid,TabletWin8[12], 0);

	TabletWin8[13] = CreatePlayerTextDraw(playerid,332.000000, 301.000000, ".");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8[13], 255);
	PlayerTextDrawFont(playerid,TabletWin8[13], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8[13], 0.300000, 0.800000);
	PlayerTextDrawColor(playerid,TabletWin8[13], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8[13], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8[13], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8[13], 0);
	PlayerTextDrawSetSelectable(playerid,TabletWin8[13], 0);

	TabletWin8[14] = CreatePlayerTextDraw(playerid,328.000000, 304.000000, ".");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8[14], 255);
	PlayerTextDrawFont(playerid,TabletWin8[14], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8[14], 0.300000, 0.800000);
	PlayerTextDrawColor(playerid,TabletWin8[14], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8[14], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8[14], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8[14], 0);
	PlayerTextDrawSetSelectable(playerid,TabletWin8[14], 0);

	TabletWin8[15] = CreatePlayerTextDraw(playerid,326.000000, 309.000000, ".");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8[15], 255);
	PlayerTextDrawFont(playerid,TabletWin8[15], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8[15], 0.300000, 0.800000);
	PlayerTextDrawColor(playerid,TabletWin8[15], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8[15], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8[15], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8[15], 0);
	PlayerTextDrawSetSelectable(playerid,TabletWin8[15], 0);

	TabletWin8[16] = CreatePlayerTextDraw(playerid,328.000000, 314.000000, ".");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8[16], 255);
	PlayerTextDrawFont(playerid,TabletWin8[16], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8[16], 0.300000, 0.800000);
	PlayerTextDrawColor(playerid,TabletWin8[16], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8[16], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8[16], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8[16], 0);
	PlayerTextDrawSetSelectable(playerid,TabletWin8[16], 0);

	TabletWin8[17] = CreatePlayerTextDraw(playerid,332.000000, 316.000000, ".");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8[17], 255);
	PlayerTextDrawFont(playerid,TabletWin8[17], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8[17], 0.300000, 0.800000);
	PlayerTextDrawColor(playerid,TabletWin8[17], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8[17], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8[17], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8[17], 0);
	PlayerTextDrawSetSelectable(playerid,TabletWin8[17], 0);

	TabletWin8[18] = CreatePlayerTextDraw(playerid,336.000000, 314.000000, ".");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8[18], 255);
	PlayerTextDrawFont(playerid,TabletWin8[18], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8[18], 0.300000, 0.800000);
	PlayerTextDrawColor(playerid,TabletWin8[18], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8[18], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8[18], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8[18], 0);
	PlayerTextDrawSetSelectable(playerid,TabletWin8[18], 0);

	TabletWin8[19] = CreatePlayerTextDraw(playerid,338.000000, 309.000000, ".");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8[19], 255);
	PlayerTextDrawFont(playerid,TabletWin8[19], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8[19], 0.300000, 0.800000);
	PlayerTextDrawColor(playerid,TabletWin8[19], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8[19], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8[19], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8[19], 0);
	PlayerTextDrawSetSelectable(playerid,TabletWin8[19], 0);

	TabletWin8[20] = CreatePlayerTextDraw(playerid,337.000000, 304.000000, ".");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8[20], 255);
	PlayerTextDrawFont(playerid,TabletWin8[20], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8[20], 0.300000, 0.800000);
	PlayerTextDrawColor(playerid,TabletWin8[20], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8[20], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8[20], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8[20], 0);
	PlayerTextDrawSetSelectable(playerid,TabletWin8[20], 0);

	TabletWin8[21] = CreatePlayerTextDraw(playerid,137.000000, 124.000000, "_");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8[21], 255);
	PlayerTextDrawFont(playerid,TabletWin8[21], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8[21], 0.500000, 1.200000);
	PlayerTextDrawColor(playerid,TabletWin8[21], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8[21], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8[21], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8[21], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8[21], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8[21], 255);
	PlayerTextDrawTextSize(playerid,TabletWin8[21], 539.000000, 192.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8[21], 0);

	TabletWin8[22] = CreatePlayerTextDraw(playerid,137.000000, 362.000000, "_");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8[22], 255);
	PlayerTextDrawFont(playerid,TabletWin8[22], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8[22], 0.500000, 1.200000);
	PlayerTextDrawColor(playerid,TabletWin8[22], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8[22], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8[22], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8[22], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8[22], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8[22], 255);
	PlayerTextDrawTextSize(playerid,TabletWin8[22], 539.000000, 192.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8[22], 0);

	//Inicio
	TabletWin8Start[0] = CreatePlayerTextDraw(playerid,122.000000, 93.000000, "O____________iiO~n~~n~~n~O____________iiO~n~~n~~n~O____________iiO");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[0], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[0], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[0], 1.600000, 8.299999);
	PlayerTextDrawColor(playerid,TabletWin8Start[0], 255);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[0], 1);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[0], 1);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[0], 0);

	TabletWin8Start[1] = CreatePlayerTextDraw(playerid,122.000000, 139.000000, "_");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[1], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[1], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[1], 0.500000, 24.300001);
	PlayerTextDrawColor(playerid,TabletWin8Start[1], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[1], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[1], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[1], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[1], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[1], 255);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[1], 549.000000, 10.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[1], 0);

	TabletWin8Start[2] = CreatePlayerTextDraw(playerid,120.000000, 387.000000, "hud:radardisc");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[2], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[2], 4);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[2], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,TabletWin8Start[2], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[2], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[2], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[2], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[2], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[2], 255);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[2], 27.000000, -33.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[2], 0);

	TabletWin8Start[3] = CreatePlayerTextDraw(playerid,551.000000, 388.000000, "hud:radardisc");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[3], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[3], 4);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[3], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,TabletWin8Start[3], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[3], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[3], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[3], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[3], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[3], 255);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[3], -27.000000, -33.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[3], 0);

	TabletWin8Start[4] = CreatePlayerTextDraw(playerid,551.000000, 104.000000, "hud:radardisc");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[4], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[4], 4);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[4], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,TabletWin8Start[4], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[4], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[4], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[4], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[4], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[4], 255);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[4], -27.000000, 33.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[4], 0);

	TabletWin8Start[5] = CreatePlayerTextDraw(playerid,120.000000, 104.000000, "hud:radardisc");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[5], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[5], 4);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[5], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,TabletWin8Start[5], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[5], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[5], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[5], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[5], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[5], 255);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[5], 27.000000, 33.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[5], 0);

	TabletWin8Start[6] = CreatePlayerTextDraw(playerid,148.000000, 106.000000, "_");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[6], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[6], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[6], 0.500000, 30.999998);
	PlayerTextDrawColor(playerid,TabletWin8Start[6], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[6], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[6], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[6], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[6], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[6], 255);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[6], 522.000000, 0.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[6], 0);

	TabletWin8Start[7] = CreatePlayerTextDraw(playerid,149.000000, 139.000000, "_");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[7], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[7], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[7], 0.500000, 24.200004);
	PlayerTextDrawColor(playerid,TabletWin8Start[7], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[7], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[7], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[7], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[7], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[7], 1711315455);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[7], 522.000000, 10.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[7], 0);

	TabletWin8Start[8] = CreatePlayerTextDraw(playerid,201.000000, 173.000000, "_");
	PlayerTextDrawAlignment(playerid,TabletWin8Start[8], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[8], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[8], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[8], 0.500000, 4.199998);
	PlayerTextDrawColor(playerid,TabletWin8Start[8], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[8], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[8], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[8], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[8], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[8], 1724697855);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[8], 5.000000, 68.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[8], 0);

	TabletWin8Start[9] = CreatePlayerTextDraw(playerid,201.000000, 220.000000, "_");
	PlayerTextDrawAlignment(playerid,TabletWin8Start[9], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[9], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[9], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[9], 0.500000, 4.199998);
	PlayerTextDrawColor(playerid,TabletWin8Start[9], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[9], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[9], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[9], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[9], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[9], -6749953);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[9], 5.000000, 68.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[9], 0);

	TabletWin8Start[10] = CreatePlayerTextDraw(playerid,201.000000, 266.000000, "_");
	PlayerTextDrawAlignment(playerid,TabletWin8Start[10], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[10], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[10], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[10], 0.500000, 4.199998);
	PlayerTextDrawColor(playerid,TabletWin8Start[10], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[10], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[10], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[10], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[10], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[10], -1724671489);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[10], 5.000000, 68.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[10], 0);

	TabletWin8Start[11] = CreatePlayerTextDraw(playerid,165.000000, 310.000000, "loadsc2:loadsc2");
	PlayerTextDrawAlignment(playerid,TabletWin8Start[11], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[11], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[11], 4);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[11], 0.500000, 0.299998);
	PlayerTextDrawColor(playerid,TabletWin8Start[11], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[11], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[11], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[11], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[11], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[11], -1724671489);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[11], 72.000000, 42.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[11], 0);

	TabletWin8Start[12] = CreatePlayerTextDraw(playerid,163.000000, 139.000000, "Start");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[12], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[12], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[12], 0.759999, 3.299999);
	PlayerTextDrawColor(playerid,TabletWin8Start[12], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[12], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[12], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[12], 0);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[12], 0);

	TabletWin8Start[13] = CreatePlayerTextDraw(playerid,277.000000, 173.000000, "_");
	PlayerTextDrawAlignment(playerid,TabletWin8Start[13], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[13], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[13], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[13], 0.500000, 4.199998);
	PlayerTextDrawColor(playerid,TabletWin8Start[13], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[13], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[13], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[13], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[13], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[13], -1728013825);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[13], 5.000000, 68.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[13], 0);

	TabletWin8Start[14] = CreatePlayerTextDraw(playerid,241.000000, 218.000000, "load0uk:load0uk");
	PlayerTextDrawAlignment(playerid,TabletWin8Start[14], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[14], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[14], 4);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[14], 0.500000, 0.299998);
	PlayerTextDrawColor(playerid,TabletWin8Start[14], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[14], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[14], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[14], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[14], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[14], -1724671489);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[14], 72.000000, 42.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[14], 0);

	TabletWin8Start[15] = CreatePlayerTextDraw(playerid,277.000000, 266.000000, "_");
	PlayerTextDrawAlignment(playerid,TabletWin8Start[15], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[15], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[15], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[15], 0.500000, 4.199998);
	PlayerTextDrawColor(playerid,TabletWin8Start[15], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[15], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[15], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[15], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[15], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[15], 16711935);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[15], 5.000000, 68.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[15], 0);

	TabletWin8Start[16] = CreatePlayerTextDraw(playerid,277.000000, 313.000000, "_");
	PlayerTextDrawAlignment(playerid,TabletWin8Start[16], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[16], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[16], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[16], 0.500000, 4.199998);
	PlayerTextDrawColor(playerid,TabletWin8Start[16], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[16], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[16], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[16], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[16], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[16], 16777215);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[16], 5.000000, 68.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[16], 0);

	TabletWin8Start[17] = CreatePlayerTextDraw(playerid,334.000000, 173.000000, "_");
	PlayerTextDrawAlignment(playerid,TabletWin8Start[17], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[17], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[17], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[17], 0.500000, 4.199998);
	PlayerTextDrawColor(playerid,TabletWin8Start[17], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[17], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[17], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[17], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[17], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[17], -1721316097);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[17], 273.000000, 31.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[17], 0);

	TabletWin8Start[18] = CreatePlayerTextDraw(playerid,372.000000, 173.000000, "_");
	PlayerTextDrawAlignment(playerid,TabletWin8Start[18], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[18], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[18], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[18], 0.500000, 4.199998);
	PlayerTextDrawColor(playerid,TabletWin8Start[18], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[18], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[18], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[18], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[18], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[18], 16711935);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[18], 273.000000, 31.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[18], 0);

	TabletWin8Start[19] = CreatePlayerTextDraw(playerid,372.000000, 219.000000, "_");
	PlayerTextDrawAlignment(playerid,TabletWin8Start[19], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[19], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[19], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[19], 0.500000, 4.199998);
	PlayerTextDrawColor(playerid,TabletWin8Start[19], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[19], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[19], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[19], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[19], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[19], 65535);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[19], 273.000000, 31.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[19], 0);

	TabletWin8Start[20] = CreatePlayerTextDraw(playerid,334.000000, 220.000000, "_");
	PlayerTextDrawAlignment(playerid,TabletWin8Start[20], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[20], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[20], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[20], 0.500000, 4.199998);
	PlayerTextDrawColor(playerid,TabletWin8Start[20], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[20], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[20], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[20], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[20], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[20], -1724671489);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[20], 273.000000, 31.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[20], 0);

	TabletWin8Start[21] = CreatePlayerTextDraw(playerid,137.000000, 124.000000, "_");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[21], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[21], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[21], 0.500000, 1.200000);
	PlayerTextDrawColor(playerid,TabletWin8Start[21], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[21], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[21], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[21], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[21], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[21], 255);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[21], 539.000000, 192.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[21], 0);

	TabletWin8Start[22] = CreatePlayerTextDraw(playerid,137.000000, 362.000000, "_");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[22], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[22], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[22], 0.500000, 1.200000);
	PlayerTextDrawColor(playerid,TabletWin8Start[22], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[22], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[22], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[22], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[22], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[22], 255);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[22], 539.000000, 192.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[22], 0);

	TabletWin8Start[23] = CreatePlayerTextDraw(playerid,353.000000, 266.000000, "_");
	PlayerTextDrawAlignment(playerid,TabletWin8Start[23], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[23], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[23], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[23], 0.500000, 4.199998);
	PlayerTextDrawColor(playerid,TabletWin8Start[23], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[23], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[23], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[23], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[23], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[23], -1728013825);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[23], 5.000000, 68.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[23], 0);

	TabletWin8Start[24] = CreatePlayerTextDraw(playerid,353.000000, 313.000000, "_");
	PlayerTextDrawAlignment(playerid,TabletWin8Start[24], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[24], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[24], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[24], 0.500000, 4.199998);
	PlayerTextDrawColor(playerid,TabletWin8Start[24], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[24], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[24], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[24], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[24], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[24], -16776961);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[24], 5.000000, 68.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[24], 0);

	TabletWin8Start[25] = CreatePlayerTextDraw(playerid,419.000000, 170.000000, "ld_dual:backgnd");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[25], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[25], 4);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[25], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,TabletWin8Start[25], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[25], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[25], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[25], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[25], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[25], 255);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[25], 72.000000, 43.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[25], 0);

	TabletWin8Start[26] = CreatePlayerTextDraw(playerid,455.000000, 220.000000, "_");
	PlayerTextDrawAlignment(playerid,TabletWin8Start[26], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[26], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[26], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[26], 0.500000, 4.199998);
	PlayerTextDrawColor(playerid,TabletWin8Start[26], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[26], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[26], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[26], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[26], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[26], 65535);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[26], 5.000000, 68.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[26], 0);

	TabletWin8Start[27] = CreatePlayerTextDraw(playerid,437.000000, 266.000000, "_");
	PlayerTextDrawAlignment(playerid,TabletWin8Start[27], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[27], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[27], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[27], 0.500000, 4.199998);
	PlayerTextDrawColor(playerid,TabletWin8Start[27], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[27], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[27], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[27], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[27], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[27], 16711935);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[27], 273.000000, 31.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[27], 0);

	TabletWin8Start[28] = CreatePlayerTextDraw(playerid,437.000000, 313.000000, "_");
	PlayerTextDrawAlignment(playerid,TabletWin8Start[28], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[28], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[28], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[28], 0.500000, 4.199998);
	PlayerTextDrawColor(playerid,TabletWin8Start[28], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[28], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[28], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[28], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[28], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[28], -6749953);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[28], 273.000000, 31.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[28], 0);

	TabletWin8Start[29] = CreatePlayerTextDraw(playerid,474.000000, 266.000000, "_");
	PlayerTextDrawAlignment(playerid,TabletWin8Start[29], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[29], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[29], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[29], 0.500000, 4.199998);
	PlayerTextDrawColor(playerid,TabletWin8Start[29], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[29], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[29], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[29], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[29], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[29], -872375809);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[29], 273.000000, 31.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[29], 0);

	TabletWin8Start[30] = CreatePlayerTextDraw(playerid,474.000000, 313.000000, "_");
	PlayerTextDrawAlignment(playerid,TabletWin8Start[30], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[30], 255);
	PlayerTextDrawFont(playerid,TabletWin8Start[30], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[30], 0.500000, 4.199998);
	PlayerTextDrawColor(playerid,TabletWin8Start[30], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[30], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[30], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[30], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Start[30], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Start[30], -16776961);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[30], 273.000000, 31.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[30], 0);

	TabletWin8Start[31] = CreatePlayerTextDraw(playerid,187.000000, 198.000000, "Mail");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[31], 255);
	PlayerTextDrawAlignment(playerid,TabletWin8Start[31], 2);
	PlayerTextDrawFont(playerid,TabletWin8Start[31], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[31], 0.300000, 1.200000);
	PlayerTextDrawColor(playerid,TabletWin8Start[31], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[31], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[31], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[31], 0);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[31],10,40);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[31], 1);

	TabletWin8Start[32] = CreatePlayerTextDraw(playerid,193.000000, 245.000000, "Contacts");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[32], 255);
	PlayerTextDrawAlignment(playerid,TabletWin8Start[32], 2);
	PlayerTextDrawFont(playerid,TabletWin8Start[32], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[32], 0.300000, 1.200000);
	PlayerTextDrawColor(playerid,TabletWin8Start[32], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[32], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[32], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[32], 0);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[32],10,40);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[32], 1);

	TabletWin8Start[33] = CreatePlayerTextDraw(playerid,193.000000, 291.000000, "Messages");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[33], 255);
	PlayerTextDrawAlignment(playerid,TabletWin8Start[33], 2);
	PlayerTextDrawFont(playerid,TabletWin8Start[33], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[33], 0.300000, 1.200000);
	PlayerTextDrawColor(playerid,TabletWin8Start[33], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[33], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[33], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[33], 0);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[33],10,40);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[33], 1);

	TabletWin8Start[34] = CreatePlayerTextDraw(playerid,193.000000, 337.000000, "Desktop");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[34], 255);
	PlayerTextDrawAlignment(playerid,TabletWin8Start[34], 2);
	PlayerTextDrawFont(playerid,TabletWin8Start[34], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[34], 0.300000, 1.200000);
	PlayerTextDrawColor(playerid,TabletWin8Start[34], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[34], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[34], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[34], 0);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[34],10,40);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[34], 1);

	TabletWin8Start[35] = CreatePlayerTextDraw(playerid,273.000000, 198.000000, "Clock");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[35], 255);
	PlayerTextDrawAlignment(playerid,TabletWin8Start[35], 2);
	PlayerTextDrawFont(playerid,TabletWin8Start[35], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[35], 0.300000, 1.200000);
	PlayerTextDrawColor(playerid,TabletWin8Start[35], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[35], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[35], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[35], 0);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[35],10,40);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[35], 1);

	TabletWin8Start[36] = CreatePlayerTextDraw(playerid,273.000000, 246.000000, "Photos");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[36], 255);
	PlayerTextDrawAlignment(playerid,TabletWin8Start[36], 2);
	PlayerTextDrawFont(playerid,TabletWin8Start[36], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[36], 0.300000, 1.200000);
	PlayerTextDrawColor(playerid,TabletWin8Start[36], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[36], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[36], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[36], 0);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[36],10,40);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[36], 1);

	TabletWin8Start[37] = CreatePlayerTextDraw(playerid,273.000000, 291.000000, "Finances");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[37], 255);
	PlayerTextDrawAlignment(playerid,TabletWin8Start[37], 2);
	PlayerTextDrawFont(playerid,TabletWin8Start[37], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[37], 0.300000, 1.200000);
	PlayerTextDrawColor(playerid,TabletWin8Start[37], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[37], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[37], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[37], 0);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[37],10,40);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[37], 1);

	TabletWin8Start[38] = CreatePlayerTextDraw(playerid,273.000000, 338.000000, "Weather");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[38], 255);
	PlayerTextDrawAlignment(playerid,TabletWin8Start[38], 2);
	PlayerTextDrawFont(playerid,TabletWin8Start[38], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[38], 0.300000, 1.200000);
	PlayerTextDrawColor(playerid,TabletWin8Start[38], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[38], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[38], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[38], 0);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[38],10,55);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[38], 1);

	TabletWin8Start[39] = CreatePlayerTextDraw(playerid,324.000000, 198.000000, "IE");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[39], 255);
	PlayerTextDrawAlignment(playerid,TabletWin8Start[39], 2);
	PlayerTextDrawFont(playerid,TabletWin8Start[39], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[39], 0.300000, 1.200000);
	PlayerTextDrawColor(playerid,TabletWin8Start[39], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[39], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[39], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[39], 0);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[39],10,40);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[39], 1);

	TabletWin8Start[40] = CreatePlayerTextDraw(playerid,333.000000, 245.000000, "Maps");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[40], 255);
	PlayerTextDrawAlignment(playerid,TabletWin8Start[40], 2);
	PlayerTextDrawFont(playerid,TabletWin8Start[40], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[40], 0.300000, 1.200000);
	PlayerTextDrawColor(playerid,TabletWin8Start[40], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[40], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[40], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[40], 0);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[40],10,40);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[40], 1);

	TabletWin8Start[41] = CreatePlayerTextDraw(playerid,341.000000, 291.000000, "Sports");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[41], 255);
	PlayerTextDrawAlignment(playerid,TabletWin8Start[41], 2);
	PlayerTextDrawFont(playerid,TabletWin8Start[41], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[41], 0.300000, 1.200000);
	PlayerTextDrawColor(playerid,TabletWin8Start[41], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[41], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[41], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[41], 0);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[41],10,40);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[41], 1);

	TabletWin8Start[42] = CreatePlayerTextDraw(playerid,339.000000, 338.000000, "News");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[42], 255);
	PlayerTextDrawAlignment(playerid,TabletWin8Start[42], 2);
	PlayerTextDrawFont(playerid,TabletWin8Start[42], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[42], 0.300000, 1.200000);
	PlayerTextDrawColor(playerid,TabletWin8Start[42], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[42], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[42], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[42], 0);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[42],10,40);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[42], 1);

	TabletWin8Start[43] = CreatePlayerTextDraw(playerid,371.000000, 198.000000, "Store");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[43], 255);
	PlayerTextDrawAlignment(playerid,TabletWin8Start[43], 2);
	PlayerTextDrawFont(playerid,TabletWin8Start[43], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[43], 0.300000, 1.200000);
	PlayerTextDrawColor(playerid,TabletWin8Start[43], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[43], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[43], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[43], 0);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[43],10,40);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[43], 1);

	TabletWin8Start[44] = CreatePlayerTextDraw(playerid,371.000000, 245.000000, "SkyDw");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[44], 255);
	PlayerTextDrawAlignment(playerid,TabletWin8Start[44], 2);
	PlayerTextDrawFont(playerid,TabletWin8Start[44], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[44], 0.300000, 1.200000);
	PlayerTextDrawColor(playerid,TabletWin8Start[44], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[44], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[44], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[44], 0);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[44],10,40);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[44], 1);

	TabletWin8Start[45] = CreatePlayerTextDraw(playerid,435.000000, 198.000000, "Bing");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[45], 255);
	PlayerTextDrawAlignment(playerid,TabletWin8Start[45], 2);
	PlayerTextDrawFont(playerid,TabletWin8Start[45], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[45], 0.300000, 1.200000);
	PlayerTextDrawColor(playerid,TabletWin8Start[45], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[45], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[45], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[45], 0);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[45],10,40);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[45], 1);

	TabletWin8Start[46] = CreatePlayerTextDraw(playerid,440.000000, 245.000000, "Travels");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[46], 255);
	PlayerTextDrawAlignment(playerid,TabletWin8Start[46], 2);
	PlayerTextDrawFont(playerid,TabletWin8Start[46], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[46], 0.300000, 1.200000);
	PlayerTextDrawColor(playerid,TabletWin8Start[46], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[46], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[46], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[46], 0);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[46],10,40);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[46], 1);

	TabletWin8Start[47] = CreatePlayerTextDraw(playerid,436.000000, 293.000000, "Games");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[47], 255);
	PlayerTextDrawAlignment(playerid,TabletWin8Start[47], 2);
	PlayerTextDrawFont(playerid,TabletWin8Start[47], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[47], 0.300000, 1.200000);
	PlayerTextDrawColor(playerid,TabletWin8Start[47], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[47], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[47], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[47], 0);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[47],10,40);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[47], 1);

	TabletWin8Start[48] = CreatePlayerTextDraw(playerid,474.000000, 293.000000, "Camera");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[48], 255);
	PlayerTextDrawAlignment(playerid,TabletWin8Start[48], 2);
	PlayerTextDrawFont(playerid,TabletWin8Start[48], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[48], 0.300000, 1.200000);
	PlayerTextDrawColor(playerid,TabletWin8Start[48], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[48], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[48], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[48], 0);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[48],10,40);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[48], 1);

	TabletWin8Start[49] = CreatePlayerTextDraw(playerid,436.000000, 338.000000, "Music");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[49], 255);
	PlayerTextDrawAlignment(playerid,TabletWin8Start[49], 2);
	PlayerTextDrawFont(playerid,TabletWin8Start[49], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[49], 0.300000, 1.200000);
	PlayerTextDrawColor(playerid,TabletWin8Start[49], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[49], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[49], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[49], 0);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[49],10,40);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[49], 1);

	TabletWin8Start[50] = CreatePlayerTextDraw(playerid,473.000000, 338.000000, "Video");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Start[50], 255);
	PlayerTextDrawAlignment(playerid,TabletWin8Start[50], 2);
	PlayerTextDrawFont(playerid,TabletWin8Start[50], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Start[50], 0.300000, 1.200000);
	PlayerTextDrawColor(playerid,TabletWin8Start[50], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Start[50], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Start[50], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Start[50], 0);
	PlayerTextDrawTextSize(playerid,TabletWin8Start[50],10,40);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Start[50], 1);

	//User loader
	TabletWin8UserLog[0] = CreatePlayerTextDraw(playerid,223.000000, 173.000000, "_");
	PlayerTextDrawAlignment(playerid,TabletWin8UserLog[0], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8UserLog[0], 255);
	PlayerTextDrawFont(playerid,TabletWin8UserLog[0], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8UserLog[0], 0.500000, 16.100004);
	PlayerTextDrawColor(playerid,TabletWin8UserLog[0], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8UserLog[0], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8UserLog[0], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8UserLog[0], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8UserLog[0], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8UserLog[0], -859006465);
	PlayerTextDrawTextSize(playerid,TabletWin8UserLog[0], 0.000000, 112.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8UserLog[0], 0);

	TabletWin8UserLog[1] = CreatePlayerTextDraw(playerid,217.000000, 151.000000, ".");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8UserLog[1], 255);
	PlayerTextDrawFont(playerid,TabletWin8UserLog[1], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8UserLog[1], 0.870000, 3.700000);
	PlayerTextDrawColor(playerid,TabletWin8UserLog[1], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8UserLog[1], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8UserLog[1], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8UserLog[1], 0);
	PlayerTextDrawSetSelectable(playerid,TabletWin8UserLog[1], 0);

	TabletWin8UserLog[2] = CreatePlayerTextDraw(playerid,211.000000, 196.000000, "I");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8UserLog[2], 255);
	PlayerTextDrawFont(playerid,TabletWin8UserLog[2], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8UserLog[2], 1.700000, 7.299999);
	PlayerTextDrawColor(playerid,TabletWin8UserLog[2], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8UserLog[2], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8UserLog[2], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8UserLog[2], 0);
	PlayerTextDrawSetSelectable(playerid,TabletWin8UserLog[2], 0);

	TabletWin8UserLog[3] = CreatePlayerTextDraw(playerid,200.000000, 236.000000, "I");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8UserLog[3], 255);
	PlayerTextDrawFont(playerid,TabletWin8UserLog[3], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8UserLog[3], 1.700000, 7.299999);
	PlayerTextDrawColor(playerid,TabletWin8UserLog[3], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8UserLog[3], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8UserLog[3], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8UserLog[3], 0);
	PlayerTextDrawSetSelectable(playerid,TabletWin8UserLog[3], 0);

	TabletWin8UserLog[4] = CreatePlayerTextDraw(playerid,223.000000, 236.000000, "I");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8UserLog[4], 255);
	PlayerTextDrawFont(playerid,TabletWin8UserLog[4], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8UserLog[4], 1.700000, 7.299999);
	PlayerTextDrawColor(playerid,TabletWin8UserLog[4], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8UserLog[4], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8UserLog[4], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8UserLog[4], 0);
	PlayerTextDrawSetSelectable(playerid,TabletWin8UserLog[4], 0);

	TabletWin8UserLog[5] = CreatePlayerTextDraw(playerid,174.000000, 217.000000, "I");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8UserLog[5], 255);
	PlayerTextDrawFont(playerid,TabletWin8UserLog[5], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8UserLog[5], 7.959995, 2.299999);
	PlayerTextDrawColor(playerid,TabletWin8UserLog[5], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8UserLog[5], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8UserLog[5], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8UserLog[5], 0);
	PlayerTextDrawSetSelectable(playerid,TabletWin8UserLog[5], 0);

	TabletWin8UserLog[6] = CreatePlayerTextDraw(playerid,223.000000, 303.000000, "NAME");
	PlayerTextDrawAlignment(playerid,TabletWin8UserLog[6], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8UserLog[6], 255);
	PlayerTextDrawFont(playerid,TabletWin8UserLog[6], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8UserLog[6], 0.500000, 1.400004);
	PlayerTextDrawColor(playerid,TabletWin8UserLog[6], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8UserLog[6], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8UserLog[6], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8UserLog[6], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8UserLog[6], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8UserLog[6], 255);
	PlayerTextDrawTextSize(playerid,TabletWin8UserLog[6], 0.000000, 110.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8UserLog[6], 0);

	TabletWin8UserLog[7] = CreatePlayerTextDraw(playerid,208.000000, 157.000000, ".");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8UserLog[7], 255);
	PlayerTextDrawFont(playerid,TabletWin8UserLog[7], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8UserLog[7], 0.870000, 3.700000);
	PlayerTextDrawColor(playerid,TabletWin8UserLog[7], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8UserLog[7], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8UserLog[7], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8UserLog[7], 0);
	PlayerTextDrawSetSelectable(playerid,TabletWin8UserLog[7], 0);

	TabletWin8UserLog[8] = CreatePlayerTextDraw(playerid,298.000000, 211.000000, "Loading...~n~ Homepage");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8UserLog[8], 255);
	PlayerTextDrawFont(playerid,TabletWin8UserLog[8], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8UserLog[8], 0.580000, 2.600000);
	PlayerTextDrawColor(playerid,TabletWin8UserLog[8], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8UserLog[8], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8UserLog[8], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8UserLog[8], 0);
	PlayerTextDrawSetSelectable(playerid,TabletWin8UserLog[8], 0);

	TabletWin8UserLog[9] = CreatePlayerTextDraw(playerid,208.000000, 170.000000, ".");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8UserLog[9], 255);
	PlayerTextDrawFont(playerid,TabletWin8UserLog[9], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8UserLog[9], 0.870000, 3.700000);
	PlayerTextDrawColor(playerid,TabletWin8UserLog[9], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8UserLog[9], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8UserLog[9], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8UserLog[9], 0);
	PlayerTextDrawSetSelectable(playerid,TabletWin8UserLog[9], 0);

	TabletWin8UserLog[10] = CreatePlayerTextDraw(playerid,217.000000, 179.000000, ".");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8UserLog[10], 255);
	PlayerTextDrawFont(playerid,TabletWin8UserLog[10], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8UserLog[10], 0.870000, 3.700000);
	PlayerTextDrawColor(playerid,TabletWin8UserLog[10], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8UserLog[10], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8UserLog[10], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8UserLog[10], 0);
	PlayerTextDrawSetSelectable(playerid,TabletWin8UserLog[10], 0);

	TabletWin8UserLog[11] = CreatePlayerTextDraw(playerid,227.000000, 170.000000, ".");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8UserLog[11], 255);
	PlayerTextDrawFont(playerid,TabletWin8UserLog[11], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8UserLog[11], 0.870000, 3.700000);
	PlayerTextDrawColor(playerid,TabletWin8UserLog[11], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8UserLog[11], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8UserLog[11], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8UserLog[11], 0);
	PlayerTextDrawSetSelectable(playerid,TabletWin8UserLog[11], 0);

	TabletWin8UserLog[12] = CreatePlayerTextDraw(playerid,227.000000, 157.000000, ".");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8UserLog[12], 255);
	PlayerTextDrawFont(playerid,TabletWin8UserLog[12], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8UserLog[12], 0.870000, 3.700000);
	PlayerTextDrawColor(playerid,TabletWin8UserLog[12], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8UserLog[12], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8UserLog[12], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8UserLog[12], 0);
	PlayerTextDrawSetSelectable(playerid,TabletWin8UserLog[12], 0);

	//PAGES
	TabletWin8Pag[0] = CreatePlayerTextDraw(playerid,152.000000, 143.000000, "_");
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Pag[0], 255);
	PlayerTextDrawFont(playerid,TabletWin8Pag[0], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Pag[0], 0.600000, 23.200004);
	PlayerTextDrawColor(playerid,TabletWin8Pag[0], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Pag[0], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Pag[0], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Pag[0], 1);
	PlayerTextDrawUseBox(playerid,TabletWin8Pag[0], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Pag[0], -859006465);
	PlayerTextDrawTextSize(playerid,TabletWin8Pag[0], 517.000000, 80.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Pag[0], 0);

	TabletWin8Pag[1] = CreatePlayerTextDraw(playerid,328.000000, 145.000000, "BB~n~AA");
	PlayerTextDrawAlignment(playerid,TabletWin8Pag[1], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Pag[1], 255);
	PlayerTextDrawFont(playerid,TabletWin8Pag[1], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Pag[1], 0.679999, 3.000000);
	PlayerTextDrawColor(playerid,TabletWin8Pag[1], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Pag[1], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Pag[1], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Pag[1], 0);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Pag[1], 0);

	TabletWin8Pag[2] = CreatePlayerTextDraw(playerid,328.000000, 262.000000, "information: this filterscript it is in procees to make~n~~n~BY ADRI1");
	PlayerTextDrawAlignment(playerid,TabletWin8Pag[2], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Pag[2], 255);
	PlayerTextDrawFont(playerid,TabletWin8Pag[2], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Pag[2], 0.310000, 1.599999);
	PlayerTextDrawColor(playerid,TabletWin8Pag[2], -1);
	PlayerTextDrawSetOutline(playerid,TabletWin8Pag[2], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Pag[2], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Pag[2], 0);
	PlayerTextDrawUseBox(playerid,TabletWin8Pag[2], 1);
	PlayerTextDrawBoxColor(playerid,TabletWin8Pag[2], 255);
	PlayerTextDrawTextSize(playerid,TabletWin8Pag[2], 2.000000, 268.000000);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Pag[2], 0);

	TabletWin8Pag[3] = CreatePlayerTextDraw(playerid,508.000000, 144.000000, "X");
	PlayerTextDrawAlignment(playerid,TabletWin8Pag[3], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletWin8Pag[3], 255);
	PlayerTextDrawFont(playerid,TabletWin8Pag[3], 1);
	PlayerTextDrawLetterSize(playerid,TabletWin8Pag[3], 0.509999, 2.400000);
	PlayerTextDrawColor(playerid,TabletWin8Pag[3], -16776961);
	PlayerTextDrawSetOutline(playerid,TabletWin8Pag[3], 0);
	PlayerTextDrawSetProportional(playerid,TabletWin8Pag[3], 1);
	PlayerTextDrawSetShadow(playerid,TabletWin8Pag[3], 0);
	PlayerTextDrawTextSize(playerid,TabletWin8Pag[3],20,10);
	PlayerTextDrawSetSelectable(playerid,TabletWin8Pag[3], 1);

	//Escritorio
	Escritorio[0] = CreatePlayerTextDraw(playerid,147.000000, 137.000000, "loadsc2:loadsc2");
	PlayerTextDrawAlignment(playerid,Escritorio[0], 2);
	PlayerTextDrawBackgroundColor(playerid,Escritorio[0], 255);
	PlayerTextDrawFont(playerid,Escritorio[0], 4);
	PlayerTextDrawLetterSize(playerid,Escritorio[0], 0.500000, 0.299998);
	PlayerTextDrawColor(playerid,Escritorio[0], -1);
	PlayerTextDrawSetOutline(playerid,Escritorio[0], 0);
	PlayerTextDrawSetProportional(playerid,Escritorio[0], 1);
	PlayerTextDrawSetShadow(playerid,Escritorio[0], 1);
	PlayerTextDrawUseBox(playerid,Escritorio[0], 1);
	PlayerTextDrawBoxColor(playerid,Escritorio[0], -1724671489);
	PlayerTextDrawTextSize(playerid,Escritorio[0], 377.000000, 223.000000);
	PlayerTextDrawSetSelectable(playerid,Escritorio[0], 0);

	Escritorio[1] = CreatePlayerTextDraw(playerid,149.000000, 343.000000, "_");
	PlayerTextDrawBackgroundColor(playerid,Escritorio[1], 255);
	PlayerTextDrawFont(playerid,Escritorio[1], 1);
	PlayerTextDrawLetterSize(playerid,Escritorio[1], 0.500000, 1.600000);
	PlayerTextDrawColor(playerid,Escritorio[1], -1);
	PlayerTextDrawSetOutline(playerid,Escritorio[1], 0);
	PlayerTextDrawSetProportional(playerid,Escritorio[1], 1);
	PlayerTextDrawSetShadow(playerid,Escritorio[1], 1);
	PlayerTextDrawUseBox(playerid,Escritorio[1], 1);
	PlayerTextDrawBoxColor(playerid,Escritorio[1], 869072895);
	PlayerTextDrawTextSize(playerid,Escritorio[1], 522.000000, 0.000000);
	PlayerTextDrawSetSelectable(playerid,Escritorio[1], 0);

	Escritorio[2] = CreatePlayerTextDraw(playerid,475.000000, 343.000000, "00:00");
	PlayerTextDrawBackgroundColor(playerid,Escritorio[2], 255);
	PlayerTextDrawFont(playerid,Escritorio[2], 1);
	PlayerTextDrawLetterSize(playerid,Escritorio[2], 0.390000, 1.300000);
	PlayerTextDrawColor(playerid,Escritorio[2], -1);
	PlayerTextDrawSetOutline(playerid,Escritorio[2], 0);
	PlayerTextDrawSetProportional(playerid,Escritorio[2], 1);
	PlayerTextDrawSetShadow(playerid,Escritorio[2], 0);
	PlayerTextDrawSetSelectable(playerid,Escritorio[2], 0);

	Escritorio[3] = CreatePlayerTextDraw(playerid,173.000000, 343.000000, "START");
	PlayerTextDrawAlignment(playerid,Escritorio[3], 2);
	PlayerTextDrawBackgroundColor(playerid,Escritorio[3], 255);
	PlayerTextDrawFont(playerid,Escritorio[3], 1);
	PlayerTextDrawLetterSize(playerid,Escritorio[3], 0.390000, 1.300000);
	PlayerTextDrawColor(playerid,Escritorio[3], -1);
	PlayerTextDrawSetOutline(playerid,Escritorio[3], 0);
	PlayerTextDrawSetProportional(playerid,Escritorio[3], 1);
	PlayerTextDrawSetShadow(playerid,Escritorio[3], 0);
	PlayerTextDrawTextSize(playerid,Escritorio[3], 10.000000, 30.000000);
	PlayerTextDrawSetSelectable(playerid,Escritorio[3], 1);

	//Fotos
	TabletPhotos[0] = CreatePlayerTextDraw(playerid,165.000000, 178.000000, "loadsc2:loadsc2");
	PlayerTextDrawAlignment(playerid,TabletPhotos[0], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletPhotos[0], 255);
	PlayerTextDrawFont(playerid,TabletPhotos[0], 4);
	PlayerTextDrawLetterSize(playerid,TabletPhotos[0], 0.500000, 0.299998);
	PlayerTextDrawColor(playerid,TabletPhotos[0], -1);
	PlayerTextDrawSetOutline(playerid,TabletPhotos[0], 0);
	PlayerTextDrawSetProportional(playerid,TabletPhotos[0], 1);
	PlayerTextDrawSetShadow(playerid,TabletPhotos[0], 1);
	PlayerTextDrawUseBox(playerid,TabletPhotos[0], 1);
	PlayerTextDrawBoxColor(playerid,TabletPhotos[0], -1724671489);
	PlayerTextDrawTextSize(playerid,TabletPhotos[0], 72.000000, 42.000000);
	PlayerTextDrawSetSelectable(playerid,TabletPhotos[0], 0);

	TabletPhotos[1] = CreatePlayerTextDraw(playerid,246.000000, 178.000000, "loadsc1:loadsc1");
	PlayerTextDrawAlignment(playerid,TabletPhotos[1], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletPhotos[1], 255);
	PlayerTextDrawFont(playerid,TabletPhotos[1], 4);
	PlayerTextDrawLetterSize(playerid,TabletPhotos[1], 0.500000, 0.299998);
	PlayerTextDrawColor(playerid,TabletPhotos[1], -1);
	PlayerTextDrawSetOutline(playerid,TabletPhotos[1], 0);
	PlayerTextDrawSetProportional(playerid,TabletPhotos[1], 1);
	PlayerTextDrawSetShadow(playerid,TabletPhotos[1], 1);
	PlayerTextDrawUseBox(playerid,TabletPhotos[1], 1);
	PlayerTextDrawBoxColor(playerid,TabletPhotos[1], -1724671489);
	PlayerTextDrawTextSize(playerid,TabletPhotos[1], 72.000000, 42.000000);
	PlayerTextDrawSetSelectable(playerid,TabletPhotos[1], 0);

	TabletPhotos[2] = CreatePlayerTextDraw(playerid,327.000000, 178.000000, "loadsc10:loadsc10");
	PlayerTextDrawAlignment(playerid,TabletPhotos[2], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletPhotos[2], 255);
	PlayerTextDrawFont(playerid,TabletPhotos[2], 4);
	PlayerTextDrawLetterSize(playerid,TabletPhotos[2], 0.500000, 0.299998);
	PlayerTextDrawColor(playerid,TabletPhotos[2], -1);
	PlayerTextDrawSetOutline(playerid,TabletPhotos[2], 0);
	PlayerTextDrawSetProportional(playerid,TabletPhotos[2], 1);
	PlayerTextDrawSetShadow(playerid,TabletPhotos[2], 1);
	PlayerTextDrawUseBox(playerid,TabletPhotos[2], 1);
	PlayerTextDrawBoxColor(playerid,TabletPhotos[2], -1724671489);
	PlayerTextDrawTextSize(playerid,TabletPhotos[2], 72.000000, 42.000000);
	PlayerTextDrawSetSelectable(playerid,TabletPhotos[2], 0);

	TabletPhotos[3] = CreatePlayerTextDraw(playerid,409.000000, 178.000000, "loadsc11:loadsc11");
	PlayerTextDrawAlignment(playerid,TabletPhotos[3], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletPhotos[3], 255);
	PlayerTextDrawFont(playerid,TabletPhotos[3], 4);
	PlayerTextDrawLetterSize(playerid,TabletPhotos[3], 0.500000, 0.299998);
	PlayerTextDrawColor(playerid,TabletPhotos[3], -1);
	PlayerTextDrawSetOutline(playerid,TabletPhotos[3], 0);
	PlayerTextDrawSetProportional(playerid,TabletPhotos[3], 1);
	PlayerTextDrawSetShadow(playerid,TabletPhotos[3], 1);
	PlayerTextDrawUseBox(playerid,TabletPhotos[3], 1);
	PlayerTextDrawBoxColor(playerid,TabletPhotos[3], -1724671489);
	PlayerTextDrawTextSize(playerid,TabletPhotos[3], 72.000000, 42.000000);
	PlayerTextDrawSetSelectable(playerid,TabletPhotos[3], 0);

	TabletPhotos[4] = CreatePlayerTextDraw(playerid,409.000000, 232.000000, "loadsc12:loadsc12");
	PlayerTextDrawAlignment(playerid,TabletPhotos[4], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletPhotos[4], 255);
	PlayerTextDrawFont(playerid,TabletPhotos[4], 4);
	PlayerTextDrawLetterSize(playerid,TabletPhotos[4], 0.500000, 0.299998);
	PlayerTextDrawColor(playerid,TabletPhotos[4], -1);
	PlayerTextDrawSetOutline(playerid,TabletPhotos[4], 0);
	PlayerTextDrawSetProportional(playerid,TabletPhotos[4], 1);
	PlayerTextDrawSetShadow(playerid,TabletPhotos[4], 1);
	PlayerTextDrawUseBox(playerid,TabletPhotos[4], 1);
	PlayerTextDrawBoxColor(playerid,TabletPhotos[4], -1724671489);
	PlayerTextDrawTextSize(playerid,TabletPhotos[4], 72.000000, 42.000000);
	PlayerTextDrawSetSelectable(playerid,TabletPhotos[4], 0);

	TabletPhotos[5] = CreatePlayerTextDraw(playerid,327.000000, 232.000000, "loadsc13:loadsc13");
	PlayerTextDrawAlignment(playerid,TabletPhotos[5], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletPhotos[5], 255);
	PlayerTextDrawFont(playerid,TabletPhotos[5], 4);
	PlayerTextDrawLetterSize(playerid,TabletPhotos[5], 0.500000, 0.299998);
	PlayerTextDrawColor(playerid,TabletPhotos[5], -1);
	PlayerTextDrawSetOutline(playerid,TabletPhotos[5], 0);
	PlayerTextDrawSetProportional(playerid,TabletPhotos[5], 1);
	PlayerTextDrawSetShadow(playerid,TabletPhotos[5], 1);
	PlayerTextDrawUseBox(playerid,TabletPhotos[5], 1);
	PlayerTextDrawBoxColor(playerid,TabletPhotos[5], -1724671489);
	PlayerTextDrawTextSize(playerid,TabletPhotos[5], 72.000000, 42.000000);
	PlayerTextDrawSetSelectable(playerid,TabletPhotos[5], 0);

	TabletPhotos[6] = CreatePlayerTextDraw(playerid,246.000000, 232.000000, "loadsc14:loadsc14");
	PlayerTextDrawAlignment(playerid,TabletPhotos[6], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletPhotos[6], 255);
	PlayerTextDrawFont(playerid,TabletPhotos[6], 4);
	PlayerTextDrawLetterSize(playerid,TabletPhotos[6], 0.500000, 0.299998);
	PlayerTextDrawColor(playerid,TabletPhotos[6], -1);
	PlayerTextDrawSetOutline(playerid,TabletPhotos[6], 0);
	PlayerTextDrawSetProportional(playerid,TabletPhotos[6], 1);
	PlayerTextDrawSetShadow(playerid,TabletPhotos[6], 1);
	PlayerTextDrawUseBox(playerid,TabletPhotos[6], 1);
	PlayerTextDrawBoxColor(playerid,TabletPhotos[6], -1724671489);
	PlayerTextDrawTextSize(playerid,TabletPhotos[6], 72.000000, 42.000000);
	PlayerTextDrawSetSelectable(playerid,TabletPhotos[6], 0);

	TabletPhotos[7] = CreatePlayerTextDraw(playerid,165.000000, 232.000000, "loadsc3:loadsc3");
	PlayerTextDrawAlignment(playerid,TabletPhotos[7], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletPhotos[7], 255);
	PlayerTextDrawFont(playerid,TabletPhotos[7], 4);
	PlayerTextDrawLetterSize(playerid,TabletPhotos[7], 0.500000, 0.299998);
	PlayerTextDrawColor(playerid,TabletPhotos[7], -1);
	PlayerTextDrawSetOutline(playerid,TabletPhotos[7], 0);
	PlayerTextDrawSetProportional(playerid,TabletPhotos[7], 1);
	PlayerTextDrawSetShadow(playerid,TabletPhotos[7], 1);
	PlayerTextDrawUseBox(playerid,TabletPhotos[7], 1);
	PlayerTextDrawBoxColor(playerid,TabletPhotos[7], -1724671489);
	PlayerTextDrawTextSize(playerid,TabletPhotos[7], 72.000000, 42.000000);
	PlayerTextDrawSetSelectable(playerid,TabletPhotos[7], 0);

	TabletPhotos[8] = CreatePlayerTextDraw(playerid,165.000000, 289.000000, "loadsc4:loadsc4");
	PlayerTextDrawAlignment(playerid,TabletPhotos[8], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletPhotos[8], 255);
	PlayerTextDrawFont(playerid,TabletPhotos[8], 4);
	PlayerTextDrawLetterSize(playerid,TabletPhotos[8], 0.500000, 0.299998);
	PlayerTextDrawColor(playerid,TabletPhotos[8], -1);
	PlayerTextDrawSetOutline(playerid,TabletPhotos[8], 0);
	PlayerTextDrawSetProportional(playerid,TabletPhotos[8], 1);
	PlayerTextDrawSetShadow(playerid,TabletPhotos[8], 1);
	PlayerTextDrawUseBox(playerid,TabletPhotos[8], 1);
	PlayerTextDrawBoxColor(playerid,TabletPhotos[8], -1724671489);
	PlayerTextDrawTextSize(playerid,TabletPhotos[8], 72.000000, 42.000000);
	PlayerTextDrawSetSelectable(playerid,TabletPhotos[8], 0);

	TabletPhotos[9] = CreatePlayerTextDraw(playerid,247.000000, 289.000000, "loadsc5:loadsc5");
	PlayerTextDrawAlignment(playerid,TabletPhotos[9], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletPhotos[9], 255);
	PlayerTextDrawFont(playerid,TabletPhotos[9], 4);
	PlayerTextDrawLetterSize(playerid,TabletPhotos[9], 0.500000, 0.299998);
	PlayerTextDrawColor(playerid,TabletPhotos[9], -1);
	PlayerTextDrawSetOutline(playerid,TabletPhotos[9], 0);
	PlayerTextDrawSetProportional(playerid,TabletPhotos[9], 1);
	PlayerTextDrawSetShadow(playerid,TabletPhotos[9], 1);
	PlayerTextDrawUseBox(playerid,TabletPhotos[9], 1);
	PlayerTextDrawBoxColor(playerid,TabletPhotos[9], -1724671489);
	PlayerTextDrawTextSize(playerid,TabletPhotos[9], 72.000000, 42.000000);
	PlayerTextDrawSetSelectable(playerid,TabletPhotos[9], 0);

	TabletPhotos[10] = CreatePlayerTextDraw(playerid,327.000000, 289.000000, "loadsc6:loadsc6");
	PlayerTextDrawAlignment(playerid,TabletPhotos[10], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletPhotos[10], 255);
	PlayerTextDrawFont(playerid,TabletPhotos[10], 4);
	PlayerTextDrawLetterSize(playerid,TabletPhotos[10], 0.500000, 0.299998);
	PlayerTextDrawColor(playerid,TabletPhotos[10], -1);
	PlayerTextDrawSetOutline(playerid,TabletPhotos[10], 0);
	PlayerTextDrawSetProportional(playerid,TabletPhotos[10], 1);
	PlayerTextDrawSetShadow(playerid,TabletPhotos[10], 1);
	PlayerTextDrawUseBox(playerid,TabletPhotos[10], 1);
	PlayerTextDrawBoxColor(playerid,TabletPhotos[10], -1724671489);
	PlayerTextDrawTextSize(playerid,TabletPhotos[10], 72.000000, 42.000000);
	PlayerTextDrawSetSelectable(playerid,TabletPhotos[10], 0);

	TabletPhotos[11] = CreatePlayerTextDraw(playerid,410.000000, 289.000000, "loadsc7:loadsc7");
	PlayerTextDrawAlignment(playerid,TabletPhotos[11], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletPhotos[11], 255);
	PlayerTextDrawFont(playerid,TabletPhotos[11], 4);
	PlayerTextDrawLetterSize(playerid,TabletPhotos[11], 0.500000, 0.299998);
	PlayerTextDrawColor(playerid,TabletPhotos[11], -1);
	PlayerTextDrawSetOutline(playerid,TabletPhotos[11], 0);
	PlayerTextDrawSetProportional(playerid,TabletPhotos[11], 1);
	PlayerTextDrawSetShadow(playerid,TabletPhotos[11], 1);
	PlayerTextDrawUseBox(playerid,TabletPhotos[11], 1);
	PlayerTextDrawBoxColor(playerid,TabletPhotos[11], -1724671489);
	PlayerTextDrawTextSize(playerid,TabletPhotos[11], 72.000000, 42.000000);
	PlayerTextDrawSetSelectable(playerid,TabletPhotos[11], 0);

	//Tablet Time
	TabletTime[0] = CreatePlayerTextDraw(playerid,290.000000, 201.000000, "00/00/00");
	PlayerTextDrawBackgroundColor(playerid,TabletTime[0], 255);
	PlayerTextDrawFont(playerid,TabletTime[0], 3);
	PlayerTextDrawLetterSize(playerid,TabletTime[0], 0.519999, 1.400000);
	PlayerTextDrawColor(playerid,TabletTime[0], -1);
	PlayerTextDrawSetOutline(playerid,TabletTime[0], 1);
	PlayerTextDrawSetProportional(playerid,TabletTime[0], 1);
	PlayerTextDrawSetSelectable(playerid,TabletTime[0], 0);

	TabletTime[1] = CreatePlayerTextDraw(playerid,290.000000, 179.000000, "00:00:00");
	PlayerTextDrawBackgroundColor(playerid,TabletTime[1], 255);
	PlayerTextDrawFont(playerid,TabletTime[1], 3);
	PlayerTextDrawLetterSize(playerid,TabletTime[1], 0.799999, 2.499999);
	PlayerTextDrawColor(playerid,TabletTime[1], -1);
	PlayerTextDrawSetOutline(playerid,TabletTime[1], 1);
	PlayerTextDrawSetProportional(playerid,TabletTime[1], 1);
	PlayerTextDrawSetSelectable(playerid,TabletTime[1], 0);

	//Music Player
	TabletMusicPlayer[0] = CreatePlayerTextDraw(playerid,330.000000, 184.000000, "PSY - Gangnam Style");
	PlayerTextDrawAlignment(playerid,TabletMusicPlayer[0], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletMusicPlayer[0], 255);
	PlayerTextDrawFont(playerid,TabletMusicPlayer[0], 1);
	PlayerTextDrawLetterSize(playerid,TabletMusicPlayer[0], 0.460000, 1.500000);
	PlayerTextDrawColor(playerid,TabletMusicPlayer[0], -1);
	PlayerTextDrawSetOutline(playerid,TabletMusicPlayer[0], 0);
	PlayerTextDrawSetProportional(playerid,TabletMusicPlayer[0], 1);
	PlayerTextDrawSetShadow(playerid,TabletMusicPlayer[0], 0);
	PlayerTextDrawTextSize(playerid,TabletMusicPlayer[0], 10.000000, 250.000000);
	PlayerTextDrawSetSelectable(playerid,TabletMusicPlayer[0], 1);

	TabletMusicPlayer[1] = CreatePlayerTextDraw(playerid,330.000000, 198.000000, "Eric Prydz - Pjanoo");
	PlayerTextDrawAlignment(playerid,TabletMusicPlayer[1], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletMusicPlayer[1], 255);
	PlayerTextDrawFont(playerid,TabletMusicPlayer[1], 1);
	PlayerTextDrawLetterSize(playerid,TabletMusicPlayer[1], 0.460000, 1.500000);
	PlayerTextDrawColor(playerid,TabletMusicPlayer[1], -1);
	PlayerTextDrawSetOutline(playerid,TabletMusicPlayer[1], 0);
	PlayerTextDrawSetProportional(playerid,TabletMusicPlayer[1], 1);
	PlayerTextDrawSetShadow(playerid,TabletMusicPlayer[1], 0);
	PlayerTextDrawTextSize(playerid,TabletMusicPlayer[1], 10.000000, 250.000000);
	PlayerTextDrawSetSelectable(playerid,TabletMusicPlayer[1], 1);

	TabletMusicPlayer[2] = CreatePlayerTextDraw(playerid,330.000000, 211.000000, "Tacabro - Tacata");
	PlayerTextDrawAlignment(playerid,TabletMusicPlayer[2], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletMusicPlayer[2], 255);
	PlayerTextDrawFont(playerid,TabletMusicPlayer[2], 1);
	PlayerTextDrawLetterSize(playerid,TabletMusicPlayer[2], 0.460000, 1.500000);
	PlayerTextDrawColor(playerid,TabletMusicPlayer[2], -1);
	PlayerTextDrawSetOutline(playerid,TabletMusicPlayer[2], 0);
	PlayerTextDrawSetProportional(playerid,TabletMusicPlayer[2], 1);
	PlayerTextDrawSetShadow(playerid,TabletMusicPlayer[2], 0);
	PlayerTextDrawTextSize(playerid,TabletMusicPlayer[2], 10.000000, 250.000000);
	PlayerTextDrawSetSelectable(playerid,TabletMusicPlayer[2], 1);

	TabletMusicPlayer[3] = CreatePlayerTextDraw(playerid,330.000000, 225.000000, "P Holla - Do it for love");
	PlayerTextDrawAlignment(playerid,TabletMusicPlayer[3], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletMusicPlayer[3], 255);
	PlayerTextDrawFont(playerid,TabletMusicPlayer[3], 1);
	PlayerTextDrawLetterSize(playerid,TabletMusicPlayer[3], 0.460000, 1.500000);
	PlayerTextDrawColor(playerid,TabletMusicPlayer[3], -1);
	PlayerTextDrawSetOutline(playerid,TabletMusicPlayer[3], 0);
	PlayerTextDrawSetProportional(playerid,TabletMusicPlayer[3], 1);
	PlayerTextDrawSetShadow(playerid,TabletMusicPlayer[3], 0);
	PlayerTextDrawTextSize(playerid,TabletMusicPlayer[3], 10.000000, 250.000000);
	PlayerTextDrawSetSelectable(playerid,TabletMusicPlayer[3], 1);

	TabletMusicPlayer[4] = CreatePlayerTextDraw(playerid,330.000000, 238.000000, "Gustavo Lima - Balada Boa");
	PlayerTextDrawAlignment(playerid,TabletMusicPlayer[4], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletMusicPlayer[4], 255);
	PlayerTextDrawFont(playerid,TabletMusicPlayer[4], 1);
	PlayerTextDrawLetterSize(playerid,TabletMusicPlayer[4], 0.460000, 1.500000);
	PlayerTextDrawColor(playerid,TabletMusicPlayer[4], -1);
	PlayerTextDrawSetOutline(playerid,TabletMusicPlayer[4], 0);
	PlayerTextDrawSetProportional(playerid,TabletMusicPlayer[4], 1);
	PlayerTextDrawSetShadow(playerid,TabletMusicPlayer[4], 0);
	PlayerTextDrawTextSize(playerid,TabletMusicPlayer[4], 10.000000, 250.000000);
	PlayerTextDrawSetSelectable(playerid,TabletMusicPlayer[4], 1);

	TabletMusicPlayer[5] = CreatePlayerTextDraw(playerid,330.000000, 251.000000, "LMFAO - Party Rock");
	PlayerTextDrawAlignment(playerid,TabletMusicPlayer[5], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletMusicPlayer[5], 255);
	PlayerTextDrawFont(playerid,TabletMusicPlayer[5], 1);
	PlayerTextDrawLetterSize(playerid,TabletMusicPlayer[5], 0.460000, 1.500000);
	PlayerTextDrawColor(playerid,TabletMusicPlayer[5], -1);
	PlayerTextDrawSetOutline(playerid,TabletMusicPlayer[5], 0);
	PlayerTextDrawSetProportional(playerid,TabletMusicPlayer[5], 1);
	PlayerTextDrawSetShadow(playerid,TabletMusicPlayer[5], 0);
	PlayerTextDrawTextSize(playerid,TabletMusicPlayer[5], 10.000000, 250.000000);
	PlayerTextDrawSetSelectable(playerid,TabletMusicPlayer[5], 1);

	TabletMusicPlayer[6] = CreatePlayerTextDraw(playerid,330.000000, 265.000000, "LMFAO - Sexy and I know");
	PlayerTextDrawAlignment(playerid,TabletMusicPlayer[6], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletMusicPlayer[6], 255);
	PlayerTextDrawFont(playerid,TabletMusicPlayer[6], 1);
	PlayerTextDrawLetterSize(playerid,TabletMusicPlayer[6], 0.460000, 1.500000);
	PlayerTextDrawColor(playerid,TabletMusicPlayer[6], -1);
	PlayerTextDrawSetOutline(playerid,TabletMusicPlayer[6], 0);
	PlayerTextDrawSetProportional(playerid,TabletMusicPlayer[6], 1);
	PlayerTextDrawSetShadow(playerid,TabletMusicPlayer[6], 0);
	PlayerTextDrawTextSize(playerid,TabletMusicPlayer[6], 10.000000, 250.000000);
	PlayerTextDrawSetSelectable(playerid,TabletMusicPlayer[6], 1);

	TabletMusicPlayer[7] = CreatePlayerTextDraw(playerid,330.000000, 279.000000, "Played a live - Safari Duo");
	PlayerTextDrawAlignment(playerid,TabletMusicPlayer[7], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletMusicPlayer[7], 255);
	PlayerTextDrawFont(playerid,TabletMusicPlayer[7], 1);
	PlayerTextDrawLetterSize(playerid,TabletMusicPlayer[7], 0.460000, 1.500000);
	PlayerTextDrawColor(playerid,TabletMusicPlayer[7], -1);
	PlayerTextDrawSetOutline(playerid,TabletMusicPlayer[7], 0);
	PlayerTextDrawSetProportional(playerid,TabletMusicPlayer[7], 1);
	PlayerTextDrawSetShadow(playerid,TabletMusicPlayer[7], 0);
	PlayerTextDrawTextSize(playerid,TabletMusicPlayer[7], 10.000000, 250.000000);
	PlayerTextDrawSetSelectable(playerid,TabletMusicPlayer[7], 1);

	TabletMusicPlayer[8] = CreatePlayerTextDraw(playerid,330.000000, 293.000000, "Guru Josh Project - Infinity");
	PlayerTextDrawAlignment(playerid,TabletMusicPlayer[8], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletMusicPlayer[8], 255);
	PlayerTextDrawFont(playerid,TabletMusicPlayer[8], 1);
	PlayerTextDrawLetterSize(playerid,TabletMusicPlayer[8], 0.460000, 1.500000);
	PlayerTextDrawColor(playerid,TabletMusicPlayer[8], -1);
	PlayerTextDrawSetOutline(playerid,TabletMusicPlayer[8], 0);
	PlayerTextDrawSetProportional(playerid,TabletMusicPlayer[8], 1);
	PlayerTextDrawSetShadow(playerid,TabletMusicPlayer[8], 0);
	PlayerTextDrawTextSize(playerid,TabletMusicPlayer[8], 10.000000, 250.000000);
	PlayerTextDrawSetSelectable(playerid,TabletMusicPlayer[8], 1);

	TabletMusicPlayer[9] = CreatePlayerTextDraw(playerid,330.000000, 307.000000, "Quiero rayos de sol - Jose..");
	PlayerTextDrawAlignment(playerid,TabletMusicPlayer[9], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletMusicPlayer[9], 255);
	PlayerTextDrawFont(playerid,TabletMusicPlayer[9], 1);
	PlayerTextDrawLetterSize(playerid,TabletMusicPlayer[9], 0.460000, 1.500000);
	PlayerTextDrawColor(playerid,TabletMusicPlayer[9], -1);
	PlayerTextDrawSetOutline(playerid,TabletMusicPlayer[9], 0);
	PlayerTextDrawSetProportional(playerid,TabletMusicPlayer[9], 1);
	PlayerTextDrawSetShadow(playerid,TabletMusicPlayer[9], 0);
	PlayerTextDrawTextSize(playerid,TabletMusicPlayer[9], 10.000000, 250.000000);
	PlayerTextDrawSetSelectable(playerid,TabletMusicPlayer[9], 1);

	TabletMusicPlayer[10] = CreatePlayerTextDraw(playerid,330.000000, 321.000000, "II");
	PlayerTextDrawAlignment(playerid,TabletMusicPlayer[10], 2);
	PlayerTextDrawBackgroundColor(playerid,TabletMusicPlayer[10], 255);
	PlayerTextDrawFont(playerid,TabletMusicPlayer[10], 1);
	PlayerTextDrawLetterSize(playerid,TabletMusicPlayer[10], 0.460000, 1.500000);
	PlayerTextDrawColor(playerid,TabletMusicPlayer[10], -1);
	PlayerTextDrawSetOutline(playerid,TabletMusicPlayer[10], 0);
	PlayerTextDrawSetProportional(playerid,TabletMusicPlayer[10], 1);
	PlayerTextDrawSetShadow(playerid,TabletMusicPlayer[10], 0);
	PlayerTextDrawTextSize(playerid,TabletMusicPlayer[10], 10.000000, 250.000000);
	PlayerTextDrawSetSelectable(playerid,TabletMusicPlayer[10], 1);

	//TwoBut
	TwoBut[0] = CreatePlayerTextDraw(playerid,149.000000, 139.000000, "_");
	PlayerTextDrawBackgroundColor(playerid,TwoBut[0], 255);
	PlayerTextDrawFont(playerid,TwoBut[0], 1);
	PlayerTextDrawLetterSize(playerid,TwoBut[0], 0.500000, 24.200000);
	PlayerTextDrawColor(playerid,TwoBut[0], -1);
	PlayerTextDrawSetOutline(playerid,TwoBut[0], 0);
	PlayerTextDrawSetProportional(playerid,TwoBut[0], 1);
	PlayerTextDrawSetShadow(playerid,TwoBut[0], 1);
	PlayerTextDrawUseBox(playerid,TwoBut[0], 1);
	PlayerTextDrawBoxColor(playerid,TwoBut[0], 842150655);
	PlayerTextDrawTextSize(playerid,TwoBut[0], 522.000000, 30.000000);
	PlayerTextDrawSetSelectable(playerid,TwoBut[0], 0);

	TwoBut[1] = CreatePlayerTextDraw(playerid,526.000000, 238.000000, "LD_BEAT:square");
	PlayerTextDrawAlignment(playerid,TwoBut[1], 2);
	PlayerTextDrawBackgroundColor(playerid,TwoBut[1], 255);
	PlayerTextDrawFont(playerid,TwoBut[1], 4);
	PlayerTextDrawLetterSize(playerid,TwoBut[1], 0.460000, 1.700000);
	PlayerTextDrawColor(playerid,TwoBut[1], -1);
	PlayerTextDrawSetOutline(playerid,TwoBut[1], 0);
	PlayerTextDrawSetProportional(playerid,TwoBut[1], 1);
	PlayerTextDrawSetShadow(playerid,TwoBut[1], 0);
	PlayerTextDrawUseBox(playerid,TwoBut[1], 1);
	PlayerTextDrawBoxColor(playerid,TwoBut[1], 255);
	PlayerTextDrawTextSize(playerid,TwoBut[1], 18.000000, 22.000000);
	PlayerTextDrawSetSelectable(playerid,TwoBut[1], 1);
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/tablet", cmdtext, true, 10) == 0)
	{
		if(!GetPVarInt(playerid,"tablet"))
		{
			SetPVarInt(playerid,"tablet",1);
			PlayerTextDrawShow(playerid,TabletWin8Start[0]);
			PlayerTextDrawShow(playerid,TabletWin8Start[1]);
			PlayerTextDrawShow(playerid,TabletWin8Start[2]);
			PlayerTextDrawShow(playerid,TabletWin8Start[3]);
			PlayerTextDrawShow(playerid,TabletWin8Start[4]);
			PlayerTextDrawShow(playerid,TabletWin8Start[5]);
			PlayerTextDrawShow(playerid,TabletWin8Start[6]);
			PlayerTextDrawShow(playerid,TabletWin8Start[7]);
			PlayerTextDrawShow(playerid,TabletWin8Start[8]);
			PlayerTextDrawShow(playerid,TabletWin8Start[9]);
			PlayerTextDrawShow(playerid,TabletWin8Start[10]);
			PlayerTextDrawShow(playerid,TabletWin8Start[21]);
			PlayerTextDrawShow(playerid,TabletWin8Start[22]);
			PlayerTextDrawShow(playerid,TwoBut[0]);
			PlayerTextDrawShow(playerid,TwoBut[1]);
			SelectTextDraw(playerid,0x33AA33AA);
		}
		else
		{
			if(GetPVarInt(playerid,"tablet"))
			{
		    	HidePagForItems(playerid);
		    	HideTabletForPlayer(playerid);
		    	HidePhotosForPlayer(playerid);
		    	HideClockForPlayer(playerid);
		    	HideTabletMusicPlayer(playerid);
		    	HideStartMenuTablet(playerid);
		    	HideUserLogTablet(playerid);
				HideEscritorioForPlayer(playerid);
		    	CancelSelectTextDraw(playerid);
				PlayerTextDrawHide(playerid,TwoBut[0]);
				PlayerTextDrawHide(playerid,TwoBut[1]);
		    	KillTimer(Timer_A[playerid]);
		    	KillTimer(Timer_B[playerid]);
		    	KillTimer(Timer_C[playerid]);
		    	KillTimer(Timer_D[playerid]);
		    	KillTimer(Timer_E[playerid]);
		    	KillTimer(Timer_F[playerid]);
		    	DeletePVar(playerid,"tablet");
		    	DeletePVar(playerid,"onoff");
			}
		}
		return 1;
	}
	return 0;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	if(playertextid == TwoBut[1])
	{
		if(!GetPVarInt(playerid,"onoff"))
		{
		    SetPVarInt(playerid,"onoff",1);
			PlayerTextDrawHide(playerid,TabletWin8Start[0]);
			PlayerTextDrawHide(playerid,TabletWin8Start[1]);
			PlayerTextDrawHide(playerid,TabletWin8Start[2]);
			PlayerTextDrawHide(playerid,TabletWin8Start[3]);
			PlayerTextDrawHide(playerid,TabletWin8Start[4]);
			PlayerTextDrawHide(playerid,TabletWin8Start[5]);
			PlayerTextDrawHide(playerid,TabletWin8Start[6]);
			PlayerTextDrawHide(playerid,TabletWin8Start[7]);
			PlayerTextDrawHide(playerid,TabletWin8Start[8]);
			PlayerTextDrawHide(playerid,TabletWin8Start[9]);
			PlayerTextDrawHide(playerid,TabletWin8Start[10]);
			PlayerTextDrawHide(playerid,TabletWin8Start[21]);
			PlayerTextDrawHide(playerid,TabletWin8Start[22]);
	        PlayerTextDrawHide(playerid,TwoBut[0]);
	        CancelSelectTextDraw(playerid);
			ShowTabletForPlayer(playerid);
			Timer_A[playerid] = SetTimerEx("LoaderAnimation",50,1,"i",playerid);
			Timer_E[playerid] = SetTimerEx("StartWin8",5000,0,"i",playerid);
		}
		else
		{
			if(GetPVarInt(playerid,"onoff"))
			{
  				HidePagForItems(playerid);
		    	HideTabletForPlayer(playerid);
		    	HidePhotosForPlayer(playerid);
		    	HideClockForPlayer(playerid);
		    	HideTabletMusicPlayer(playerid);
		    	HideStartMenuTablet(playerid);
		    	HideUserLogTablet(playerid);
				HideEscritorioForPlayer(playerid);
		    	KillTimer(Timer_A[playerid]);
		    	KillTimer(Timer_B[playerid]);
		    	KillTimer(Timer_C[playerid]);
		    	KillTimer(Timer_D[playerid]);
		    	KillTimer(Timer_E[playerid]);
		    	KillTimer(Timer_F[playerid]);
			    DeletePVar(playerid,"onoff");
				PlayerTextDrawShow(playerid,TabletWin8Start[0]);
				PlayerTextDrawShow(playerid,TabletWin8Start[1]);
				PlayerTextDrawShow(playerid,TabletWin8Start[2]);
				PlayerTextDrawShow(playerid,TabletWin8Start[3]);
				PlayerTextDrawShow(playerid,TabletWin8Start[4]);
				PlayerTextDrawShow(playerid,TabletWin8Start[5]);
				PlayerTextDrawShow(playerid,TabletWin8Start[6]);
				PlayerTextDrawShow(playerid,TabletWin8Start[7]);
				PlayerTextDrawShow(playerid,TabletWin8Start[8]);
				PlayerTextDrawShow(playerid,TabletWin8Start[9]);
				PlayerTextDrawShow(playerid,TabletWin8Start[10]);
				PlayerTextDrawShow(playerid,TabletWin8Start[21]);
				PlayerTextDrawShow(playerid,TabletWin8Start[22]);
				PlayerTextDrawShow(playerid,TwoBut[0]);
				PlayerTextDrawShow(playerid,TwoBut[1]);
				SelectTextDraw(playerid,0x33AA33AA);
			}
		}
	}
    if(playertextid == TabletWin8Start[31])ShowPage(playerid,0);
    if(playertextid == TabletWin8Start[32])ShowPage(playerid,1);
    if(playertextid == TabletWin8Start[33])ShowPage(playerid,2);
    if(playertextid == TabletWin8Start[34])ShowPage(playerid,3);
    if(playertextid == TabletWin8Start[35])ShowPage(playerid,4);
    if(playertextid == TabletWin8Start[36])ShowPage(playerid,5);
    if(playertextid == TabletWin8Start[37])ShowPage(playerid,6);
    if(playertextid == TabletWin8Start[38])ShowPage(playerid,7);
    if(playertextid == TabletWin8Start[39])ShowPage(playerid,8);
    if(playertextid == TabletWin8Start[40])ShowPage(playerid,9);
    if(playertextid == TabletWin8Start[41])ShowPage(playerid,10);
    if(playertextid == TabletWin8Start[42])ShowPage(playerid,11);
    if(playertextid == TabletWin8Start[43])ShowPage(playerid,12);
    if(playertextid == TabletWin8Start[44])ShowPage(playerid,13);
    if(playertextid == TabletWin8Start[45])ShowPage(playerid,14);
    if(playertextid == TabletWin8Start[46])ShowPage(playerid,15);
    if(playertextid == TabletWin8Start[47])ShowPage(playerid,16);
    if(playertextid == TabletWin8Start[48])ShowPage(playerid,17);
    if(playertextid == TabletWin8Start[49])ShowPage(playerid,18);
    if(playertextid == TabletWin8Start[50])ShowPage(playerid,19);
    if(playertextid == TabletWin8Pag[3])
    {
    	HidePagForItems(playerid);
    	HidePhotosForPlayer(playerid);
    	HideClockForPlayer(playerid);
    	HideTabletMusicPlayer(playerid);
    	ShowStartMenuTablet(playerid);
    }
    if(playertextid == Escritorio[3])
    {
    	HidePagForItems(playerid);
    	HideEscritorioForPlayer(playerid);
    	ShowStartMenuTablet(playerid);
    }
   	if(playertextid == TabletMusicPlayer[0]) PlayAudioStreamForPlayer(playerid, "https://dl.dropbox.com/s/toc6d0gmwyf6m52/gangnamstyle.mp3?dl=1");  //PSY - Gangnam Style
	if(playertextid == TabletMusicPlayer[1]) PlayAudioStreamForPlayer(playerid, "https://dl.dropbox.com/s/3lj9dv77pp15opc/Pjanoo.mp3?dl=1");		//Eric Prydz - Pjanoo
	if(playertextid == TabletMusicPlayer[2]) PlayAudioStreamForPlayer(playerid, "https://dl.dropbox.com/s/atfmpu8eupiv138/Tacata.mp3?dl=1");		//Tacabro - Tacata
	if(playertextid == TabletMusicPlayer[3]) PlayAudioStreamForPlayer(playerid, "https://dl.dropbox.com/s/bxh0ap2k7nkk3za/DoitForLove.mp3?dl=1");	//P Holla - Do it for love
	if(playertextid == TabletMusicPlayer[4]) PlayAudioStreamForPlayer(playerid, "https://dl.dropbox.com/s/i5xrqh704s4zo2j/Balada.mp3?dl=1");		//Gustavo Lima - Balada Boa
	if(playertextid == TabletMusicPlayer[5]) PlayAudioStreamForPlayer(playerid, "https://dl.dropbox.com/s/xmo5nrwc6uvx90e/PartyLMFAO.mp3?dl=1");	//LMFAO - Party Rock
	if(playertextid == TabletMusicPlayer[6]) PlayAudioStreamForPlayer(playerid, "https://dl.dropbox.com/s/pgjx0r47wma4yvd/SexyLMFAO.mp3?dl=1");		//LMFAO - Sexy and I know
	if(playertextid == TabletMusicPlayer[7]) PlayAudioStreamForPlayer(playerid, "https://dl.dropbox.com/s/sx1pjsyp1u1v4lq/Safari.mp3?dl=1");		//Played a live - Safari Duo
	if(playertextid == TabletMusicPlayer[8]) PlayAudioStreamForPlayer(playerid, "https://dl.dropbox.com/s/xca4p49hvjtfajo/Inifinity.mp3?dl=1");		//Guru Josh Project - Infinity
	if(playertextid == TabletMusicPlayer[9]) PlayAudioStreamForPlayer(playerid, "https://dl.dropbox.com/s/eopqegiekf5p09a/Rayos.mp3?dl=1");			//Quiero rayos de sol - Jose de rico
    if(playertextid == TabletMusicPlayer[10]) StopAudioStreamForPlayer(playerid);
	return 1;
}

forward LoaderAnimation(playerid);
public LoaderAnimation(playerid)
{
	if(lda[playerid] == 0) PlayerTextDrawShow(playerid,TabletWin8[13]), lda[playerid] = 1;
	else if(lda[playerid] == 1) PlayerTextDrawShow(playerid,TabletWin8[14]), lda[playerid] = 2;
	else if(lda[playerid] == 2) PlayerTextDrawShow(playerid,TabletWin8[15]), lda[playerid] = 3;
	else if(lda[playerid] == 3) PlayerTextDrawShow(playerid,TabletWin8[16]), lda[playerid] = 4;
	else if(lda[playerid] == 4) PlayerTextDrawShow(playerid,TabletWin8[17]), lda[playerid] = 5;
	else if(lda[playerid] == 5) PlayerTextDrawShow(playerid,TabletWin8[18]), lda[playerid] = 6;
	else if(lda[playerid] == 6) PlayerTextDrawShow(playerid,TabletWin8[19]), lda[playerid] = 7;
	else if(lda[playerid] == 7) PlayerTextDrawShow(playerid,TabletWin8[20]), lda[playerid] = 9;
	else if(lda[playerid] == 9) PlayerTextDrawHide(playerid,TabletWin8[13]), lda[playerid] = 10;
	else if(lda[playerid] == 10) PlayerTextDrawHide(playerid,TabletWin8[14]), lda[playerid] = 11;
	else if(lda[playerid] == 11) PlayerTextDrawHide(playerid,TabletWin8[15]), lda[playerid] = 12;
	else if(lda[playerid] == 12) PlayerTextDrawHide(playerid,TabletWin8[16]), lda[playerid] = 13;
	else if(lda[playerid] == 13) PlayerTextDrawHide(playerid,TabletWin8[17]), lda[playerid] = 14;
	else if(lda[playerid] == 14) PlayerTextDrawHide(playerid,TabletWin8[18]), lda[playerid] = 15;
	else if(lda[playerid] == 15) PlayerTextDrawHide(playerid,TabletWin8[19]), lda[playerid] = 16;
	else if(lda[playerid] == 16) PlayerTextDrawHide(playerid,TabletWin8[20]), lda[playerid] = 0;
	return 1;
}
forward StartWin8(playerid);
public StartWin8(playerid)
{
    lda[playerid] = 0;
	KillTimer(Timer_A[playerid]);
	HideTabletForPlayer(playerid);
	ShowUserLogTablet(playerid);
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,sizeof(name));
	PlayerTextDrawSetString(playerid,TabletWin8UserLog[6],name);
	Timer_B[playerid] = SetTimerEx("LoaderAnimation2",50,1,"i",playerid);
	Timer_F[playerid] = SetTimerEx("Win8GO",5000,0,"i",playerid);
	PlayerTextDrawShow(playerid,TabletWin8Start[0]);
	PlayerTextDrawShow(playerid,TabletWin8Start[1]);
	PlayerTextDrawShow(playerid,TabletWin8Start[2]);
	PlayerTextDrawShow(playerid,TabletWin8Start[3]);
	PlayerTextDrawShow(playerid,TabletWin8Start[4]);
	PlayerTextDrawShow(playerid,TabletWin8Start[5]);
	PlayerTextDrawShow(playerid,TabletWin8Start[6]);
	PlayerTextDrawShow(playerid,TabletWin8Start[7]);
	PlayerTextDrawShow(playerid,TabletWin8Start[8]);
	PlayerTextDrawShow(playerid,TabletWin8Start[9]);
	PlayerTextDrawShow(playerid,TabletWin8Start[10]);
	PlayerTextDrawShow(playerid,TabletWin8Start[21]);
	PlayerTextDrawShow(playerid,TabletWin8Start[22]);
	return 1;
}
forward LoaderAnimation2(playerid);
public LoaderAnimation2(playerid)
{
	if(lda[playerid] == 0) PlayerTextDrawShow(playerid,TabletWin8UserLog[1]), lda[playerid] = 1;
	else if(lda[playerid] == 1) PlayerTextDrawShow(playerid,TabletWin8UserLog[7]), lda[playerid] = 2;
	else if(lda[playerid] == 2) PlayerTextDrawShow(playerid,TabletWin8UserLog[9]), lda[playerid] = 3;
	else if(lda[playerid] == 3) PlayerTextDrawShow(playerid,TabletWin8UserLog[10]), lda[playerid] = 4;
	else if(lda[playerid] == 4) PlayerTextDrawShow(playerid,TabletWin8UserLog[11]), lda[playerid] = 5;
	else if(lda[playerid] == 5) PlayerTextDrawShow(playerid,TabletWin8UserLog[12]), lda[playerid] = 6;
	else if(lda[playerid] == 6) PlayerTextDrawHide(playerid,TabletWin8UserLog[1]), lda[playerid] = 7;
	else if(lda[playerid] == 7) PlayerTextDrawHide(playerid,TabletWin8UserLog[7]), lda[playerid] = 8;
	else if(lda[playerid] == 8) PlayerTextDrawHide(playerid,TabletWin8UserLog[9]), lda[playerid] = 9;
	else if(lda[playerid] == 9) PlayerTextDrawHide(playerid,TabletWin8UserLog[10]), lda[playerid] = 10;
	else if(lda[playerid] == 10) PlayerTextDrawHide(playerid,TabletWin8UserLog[11]), lda[playerid] = 11;
	else if(lda[playerid] == 11) PlayerTextDrawHide(playerid,TabletWin8UserLog[12]), lda[playerid] = 0;
	return 1;
}
forward Win8GO(playerid);
public Win8GO(playerid)
{
	KillTimer(Timer_B[playerid]);
	lda[playerid] = 0;
	HideUserLogTablet(playerid);
	ShowStartMenuTablet(playerid);
	SelectTextDraw(playerid,0x33AA33AA);
	return 1;
}
forward UpdateTime(playerid);
public UpdateTime(playerid)
{
	new Hour, Minute, Second;
	gettime(Hour, Minute, Second);
	new str[64];
	format(str,sizeof(str),"%d:%d",Hour,Minute);
	PlayerTextDrawSetString(playerid,Escritorio[2],str);
	return 1;
}
forward UpdateTime2(playerid);
public UpdateTime2(playerid)
{
	new Hour, Minute, Second;
	gettime(Hour, Minute, Second);
	new Year, Month, Day;
	getdate(Year, Month, Day);
	new str2[64];
	format(str2,sizeof(str2),"%d/%d/%d",Day,Month,Year);
	PlayerTextDrawSetString(playerid,TabletTime[0],str2);
	new str[64];
	format(str,sizeof(str),"%d:%d:%d",Hour,Minute,Second);
	PlayerTextDrawSetString(playerid,TabletTime[1],str);
	return 1;
}
//Tablet ON/OFF
stock ShowTabletForPlayer(playerid)
{
	for(new i = 0; i < 23; i++) PlayerTextDrawShow(playerid,TabletWin8[i]);
	PlayerTextDrawHide(playerid,TabletWin8[13]);
	PlayerTextDrawHide(playerid,TabletWin8[14]);
	PlayerTextDrawHide(playerid,TabletWin8[15]);
	PlayerTextDrawHide(playerid,TabletWin8[16]);
	PlayerTextDrawHide(playerid,TabletWin8[17]);
	PlayerTextDrawHide(playerid,TabletWin8[18]);
	PlayerTextDrawHide(playerid,TabletWin8[19]);
	PlayerTextDrawHide(playerid,TabletWin8[20]);
	return 1;
}
stock HideTabletForPlayer(playerid)
{
	for(new i = 0; i < 23; i++) PlayerTextDrawHide(playerid,TabletWin8[i]);
	return 1;
}

//UserLogin
stock ShowUserLogTablet(playerid)
{
	for(new i = 0; i < 13; i++) PlayerTextDrawShow(playerid,TabletWin8UserLog[i]);
	PlayerTextDrawHide(playerid,TabletWin8UserLog[1]);
	PlayerTextDrawHide(playerid,TabletWin8UserLog[7]);
	PlayerTextDrawHide(playerid,TabletWin8UserLog[9]);
	PlayerTextDrawHide(playerid,TabletWin8UserLog[10]);
    PlayerTextDrawHide(playerid,TabletWin8UserLog[11]);
    PlayerTextDrawHide(playerid,TabletWin8UserLog[12]);
	return 1;
}
stock HideUserLogTablet(playerid)
{
	for(new i = 0; i < 13; i++) PlayerTextDrawHide(playerid,TabletWin8UserLog[i]);
	return 1;
}

//StartMenu
stock ShowStartMenuTablet(playerid)
{
	for(new i = 0; i < 51; i++) PlayerTextDrawShow(playerid,TabletWin8Start[i]);
	return 1;
}
stock HideStartMenuTablet(playerid)
{
	for(new i = 0; i < 51; i++) PlayerTextDrawHide(playerid,TabletWin8Start[i]);
	return 1;
}

//PagForItem
stock ShowPagForItems(playerid)
{
	for(new i = 0; i < 4; i++) PlayerTextDrawShow(playerid,TabletWin8Pag[i]);
	return 1;
}
stock HidePagForItems(playerid)
{
	for(new i = 0; i < 4; i++) PlayerTextDrawHide(playerid,TabletWin8Pag[i]);
	return 1;
}

//Escritorio
stock ShowEscritorioForPlayer(playerid)
{
	for(new i = 0; i < 4; i++) PlayerTextDrawShow(playerid,Escritorio[i]);
	Timer_C[playerid] = SetTimerEx("UpdateTime",1000,1,"i",playerid);
	return 1;
}
stock HideEscritorioForPlayer(playerid)
{
	for(new i = 0; i < 4; i++) PlayerTextDrawHide(playerid,Escritorio[i]);
	KillTimer(Timer_C[playerid]);
	return 1;
}

//Photos
stock ShowPhotosForPlayer(playerid)
{
	for(new i = 0; i < 12; i++) PlayerTextDrawShow(playerid,TabletPhotos[i]);
	return 1;
}
stock HidePhotosForPlayer(playerid)
{
	for(new i = 0; i < 12; i++) PlayerTextDrawHide(playerid,TabletPhotos[i]);
	return 1;
}
//Relog
stock ShowClockForPlayer(playerid)
{
	for(new i = 0; i < 2; i++) PlayerTextDrawShow(playerid,TabletTime[i]);
	Timer_D[playerid] = SetTimerEx("UpdateTime2",1000,1,"i",playerid);
	return 1;
}
stock HideClockForPlayer(playerid)
{
	for(new i = 0; i < 2; i++) PlayerTextDrawHide(playerid,TabletTime[i]);
	KillTimer(Timer_D[playerid]);
	return 1;
}

//TabletMusicPlayer
stock ShowTabletMusicPlayer(playerid)
{
	for(new i = 0; i < 11; i++) PlayerTextDrawShow(playerid,TabletMusicPlayer[i]);
	return 1;
}
stock HideTabletMusicPlayer(playerid)
{
	for(new i = 0; i < 11; i++) PlayerTextDrawHide(playerid,TabletMusicPlayer[i]);
	StopAudioStreamForPlayer(playerid);
	return 1;
}
//Only for menu no bug
stock ShowPage(playerid,page)
{
    HideStartMenuTablet(playerid);
	PlayerTextDrawShow(playerid,TabletWin8Start[0]);
	PlayerTextDrawShow(playerid,TabletWin8Start[1]);
	PlayerTextDrawShow(playerid,TabletWin8Start[2]);
	PlayerTextDrawShow(playerid,TabletWin8Start[3]);
	PlayerTextDrawShow(playerid,TabletWin8Start[4]);
	PlayerTextDrawShow(playerid,TabletWin8Start[5]);
	PlayerTextDrawShow(playerid,TabletWin8Start[6]);
	PlayerTextDrawShow(playerid,TabletWin8Start[7]);
	PlayerTextDrawShow(playerid,TabletWin8Start[8]);
	PlayerTextDrawShow(playerid,TabletWin8Start[9]);
	PlayerTextDrawShow(playerid,TabletWin8Start[10]);
	PlayerTextDrawShow(playerid,TabletWin8Start[21]);
	PlayerTextDrawShow(playerid,TabletWin8Start[22]);
	if(page == 0)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"EMAIL");
	else if(page == 1)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"CONTACTS");
	else if(page == 2)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"MESSAGES");
	else if(page == 3)return ShowEscritorioForPlayer(playerid);
	else if(page == 4)return PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"CLOCK"),ShowClockForPlayer(playerid),ShowPagForItems(playerid),PlayerTextDrawHide(playerid,TabletWin8Pag[2]);
	else if(page == 5)return PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"PHOTOS"),ShowPhotosForPlayer(playerid),ShowPagForItems(playerid),PlayerTextDrawHide(playerid,TabletWin8Pag[2]);
	else if(page == 6)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"FINANCES");
	else if(page == 7)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"WEATHER");
	else if(page == 8)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"INTERNET~n~EXPLORER");
	else if(page == 9)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"MAPS");
	else if(page == 10)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"SPORTS");
	else if(page == 11)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"NEWS");
	else if(page == 12)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"STORE");
	else if(page == 13)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"SkyDrive");
	else if(page == 14)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"BING");
	else if(page == 15)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"TRAVELS");
	else if(page == 16)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"GAMES");
	else if(page == 17)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"CAMERA");
	else if(page == 18)return PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"MUSIC"),ShowTabletMusicPlayer(playerid),ShowPagForItems(playerid),PlayerTextDrawHide(playerid,TabletWin8Pag[2]);
	else if(page == 19)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"VIDEO");
    ShowPagForItems(playerid);
	return 1;
}
/*

************************
************************
** ADRI1 FILTERSCRIPT **
** TEXTDRAWS CREATEDS **
** WITH ZAMAROHT TEXT **
** EDITOR. EDITED  BY **
** ADRI1 VERSION SAMP **            TABLET V3.00 CREATED BY ADRI1
** 0.3E. THIS  TABLET **
** IS V3.0 CREATED BY **
** ADRI1 COMMAND  FOR **
** TEST IS:   /TABLET **
** STABLE VERSION.BYE **
************************
************************
*/
