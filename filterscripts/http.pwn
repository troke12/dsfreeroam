//Made by Krisna
#define FILTERSCRIPT
#include <a_samp>
#include <a_http>
// On top of script:
new Text:Textdraw0;
new Text:Textdraw1;
new Text:Textdraw2;
new Text:Textdraw3[MAX_PLAYERS];

forward HideTextDraw(playerid);
public HideTextDraw(playerid)
{
        TextDrawHideForPlayer(playerid, Textdraw0);
        TextDrawHideForPlayer(playerid, Textdraw1);
        TextDrawHideForPlayer(playerid, Textdraw2);
        TextDrawHideForPlayer(playerid, Textdraw3[playerid]);
        return 1;
}

forward UpdateResponse(playerid, response_code, data[]);
public UpdateResponse(playerid, response_code, data[])
{

    new
        string[ 1028 ];

    if(response_code == 200)
    {
        format(string, sizeof(string), "%s", data);
        TextDrawSetString(Textdraw3[playerid], string);
        TextDrawShowForPlayer(playerid, Textdraw0);
        TextDrawShowForPlayer(playerid, Textdraw1);
        TextDrawShowForPlayer(playerid, Textdraw2);
        TextDrawShowForPlayer(playerid, Textdraw3[playerid]);
        SetTimerEx("HideTextDraw", 15000, false, "i", playerid);
    }
    else
    {
        format(string, sizeof(string), "Request Failed, Code: %d", response_code);
        SendClientMessage(playerid, 0xFFFFFFFF, string);
    }
}

public OnPlayerConnect(playerid)
{

	Textdraw0 = TextDrawCreate(81.000000, 140.000000, "_");
	TextDrawAlignment(Textdraw0, 2);
	TextDrawBackgroundColor(Textdraw0, 255);
	TextDrawFont(Textdraw0, 1);
	TextDrawLetterSize(Textdraw0, 0.500000, 1.000000);
	TextDrawColor(Textdraw0, -1);
	TextDrawSetOutline(Textdraw0, 0);
	TextDrawSetProportional(Textdraw0, 1);
	TextDrawSetShadow(Textdraw0, 1);
	TextDrawUseBox(Textdraw0, 1);
	TextDrawBoxColor(Textdraw0, 16777215);
	TextDrawTextSize(Textdraw0, 0.000000, 121.000000);
	TextDrawSetSelectable(Textdraw0, 0);

	Textdraw1 = TextDrawCreate(81.000000, 154.000000, "_");
	TextDrawAlignment(Textdraw1, 2);
	TextDrawBackgroundColor(Textdraw1, 255);
	TextDrawFont(Textdraw1, 1);
	TextDrawLetterSize(Textdraw1, 0.500000, 18.100000);
	TextDrawColor(Textdraw1, -1);
	TextDrawSetOutline(Textdraw1, 0);
	TextDrawSetProportional(Textdraw1, 1);
	TextDrawSetShadow(Textdraw1, 1);
	TextDrawUseBox(Textdraw1, 1);
	TextDrawBoxColor(Textdraw1, 2038004089);
	TextDrawTextSize(Textdraw1, 0.000000, 121.000000);
	TextDrawSetSelectable(Textdraw1, 0);

	Textdraw2 = TextDrawCreate(58.000000, 139.000000, "Updates");
	TextDrawBackgroundColor(Textdraw2, 255);
	TextDrawFont(Textdraw2, 2);
	TextDrawLetterSize(Textdraw2, 0.230000, 1.000000);
	TextDrawColor(Textdraw2, -1);
	TextDrawSetOutline(Textdraw2, 1);
	TextDrawSetProportional(Textdraw2, 1);
	TextDrawSetSelectable(Textdraw2, 0);

	Textdraw3[playerid] = TextDrawCreate(20.000000, 156.000000, "-Yaoming");
	TextDrawBackgroundColor(Textdraw3[playerid], 255);
	TextDrawFont(Textdraw3[playerid], 2);
	TextDrawLetterSize(Textdraw3[playerid], 0.200000, 1.000000);
	TextDrawColor(Textdraw3[playerid], -1);
	TextDrawSetOutline(Textdraw3[playerid], 1);
	TextDrawSetProportional(Textdraw3[playerid], 1);
	TextDrawSetSelectable(Textdraw3[playerid], 0);
 	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
        TextDrawDestroy(Textdraw0);
        TextDrawDestroy(Textdraw1);
        TextDrawDestroy(Textdraw2);
        TextDrawDestroy(Textdraw3[playerid]);
        return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{

        if(strcmp(cmdtext, "/updates", true) == 0)
        {
            HTTP(playerid, HTTP_GET, "krisna.ganteng.ga/list.txt", "", "UpdateResponse");
            return 1;
        }
        return 0;
}
