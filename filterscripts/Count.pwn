#include <a_samp>

new Countdown, countdowntimer, CountdownStart;
new Text:Sprite0, Text:Sprite1, Text:Sprite2, Text:Sprite3, Text:Sprite4, Text:Sprite5, Text:Sprite6, Text:Sprite7, Text:Sprite8;

forward OnCountdownStart();

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" V-Race Countdown loaded...");
	print("--------------------------------------\n");

	Sprite0 = TextDrawCreate(430.000, 10.000, "LD_ROUL:roulbla");
    TextDrawFont(Sprite0, 4);
    TextDrawTextSize(Sprite0, 59.500, 79.000);
    TextDrawColor(Sprite0, -1);

    Sprite1 = TextDrawCreate(430.000, 68.500, "LD_ROUL:roulbla");
    TextDrawFont(Sprite1, 4);
    TextDrawTextSize(Sprite1, 59.500, 79.000);
    TextDrawColor(Sprite1, -1);

    Sprite2 = TextDrawCreate(430.000, 127.000, "LD_ROUL:roulbla");
    TextDrawFont(Sprite2, 4);
    TextDrawTextSize(Sprite2, 59.500, 79.000);
    TextDrawColor(Sprite2, -1);

    Sprite3 = TextDrawCreate(430.000, 10.000, "LD_ROUL:roulred");
    TextDrawFont(Sprite3, 4);
    TextDrawTextSize(Sprite3, 59.500, 79.000);
    TextDrawColor(Sprite3, -1);

    Sprite4 = TextDrawCreate(430.000, 68.500, "LD_ROUL:roulred");
    TextDrawFont(Sprite4, 4);
    TextDrawTextSize(Sprite4, 59.500, 79.000);
    TextDrawColor(Sprite4, -1);

    Sprite5 = TextDrawCreate(430.000, 127.000, "LD_ROUL:roulred");
    TextDrawFont(Sprite5, 4);
    TextDrawTextSize(Sprite5, 59.500, 79.000);
    TextDrawColor(Sprite5, -1);

    Sprite6 = TextDrawCreate(430.000, 10.000, "LD_ROUL:roulgre");
    TextDrawFont(Sprite6, 4);
    TextDrawTextSize(Sprite6, 59.500, 79.000);
    TextDrawColor(Sprite6, -1);

    Sprite7 = TextDrawCreate(430.000, 68.500, "LD_ROUL:roulgre");
    TextDrawFont(Sprite7, 4);
    TextDrawTextSize(Sprite7, 59.500, 79.000);
    TextDrawColor(Sprite7, -1);

    Sprite8 = TextDrawCreate(430.000, 127.000, "LD_ROUL:roulgre");
    TextDrawFont(Sprite8, 4);
    TextDrawTextSize(Sprite8, 59.500, 79.000);
    TextDrawColor(Sprite8, -1);
	return 1;
}

public OnFilterScriptExit()
{
    TextDrawHideForAll(Sprite0);
    TextDrawDestroy(Sprite0);
    TextDrawHideForAll(Sprite1);
    TextDrawDestroy(Sprite1);
    TextDrawHideForAll(Sprite2);
    TextDrawDestroy(Sprite2);
    TextDrawHideForAll(Sprite3);
    TextDrawDestroy(Sprite3);
    TextDrawHideForAll(Sprite4);
    TextDrawDestroy(Sprite4);
    TextDrawHideForAll(Sprite5);
    TextDrawDestroy(Sprite5);
    TextDrawHideForAll(Sprite6);
    TextDrawDestroy(Sprite6);
    TextDrawHideForAll(Sprite7);
    TextDrawDestroy(Sprite7);
    TextDrawHideForAll(Sprite8);
    TextDrawDestroy(Sprite8);
    Countdown = 0;
	CountdownStart = 0;
	KillTimer(countdowntimer);
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/count", cmdtext, true, 10) == 0)
	{
	    if(CountdownStart == 0)
	    {
			new string[128], pname[24];
			GetPlayerName(playerid, pname, sizeof(pname));
			format(string, sizeof(string), "*%s has start a Countdown!", pname);
			SendClientMessageToAll(0xFFFFFFFF, string);
			countdowntimer = SetTimer("OnCountdownStart", 1000, true);
			CountdownStart = 1;
		    Countdown = 6;
		}
		else if(CountdownStart == 1)
		{
			SendClientMessage(playerid, 0xFFFFFFFF, "Its already startet a Countdown please Wait!");
		}
		return 1;
	}
	return 0;
}

public OnCountdownStart()
{
	if(Countdown == 6)
	{
	    TextDrawShowForAll(Sprite0); //Blank
    	TextDrawShowForAll(Sprite1); //Blank
    	TextDrawShowForAll(Sprite2); //Blank
    	Countdown = 5;
	}
	else if(Countdown == 5)
	{
	    TextDrawShowForAll(Sprite3); //Red
    	Countdown = 4;
    	for (new i = 0; i < MAX_PLAYERS; i++)
		{
			PlayerPlaySound(i, 1056, 0, 0, 0);
		}
	}
	else if(Countdown == 4)
	{
	    TextDrawShowForAll(Sprite4); //Red
    	Countdown = 3;
    	for (new i = 0; i < MAX_PLAYERS; i++)
		{
			PlayerPlaySound(i, 1056, 0, 0, 0);
		}
	}
	else if(Countdown == 3)
	{
	    TextDrawShowForAll(Sprite5); //Red
    	Countdown = 2;
    	for (new i = 0; i < MAX_PLAYERS; i++)
		{
			PlayerPlaySound(i, 1056, 0, 0, 0);
		}
	}
	else if(Countdown == 2)
	{
	    TextDrawShowForAll(Sprite6); //Green
    	TextDrawShowForAll(Sprite7); //Green
    	TextDrawShowForAll(Sprite8); //Green
    	Countdown = 1;
    	for (new i = 0; i < MAX_PLAYERS; i++)
		{
			PlayerPlaySound(i, 1057, 0, 0, 0);
		}
	}
	else if(Countdown == 1)
	{
	    TextDrawHideForAll(Sprite0);
	    TextDrawHideForAll(Sprite1);
	    TextDrawHideForAll(Sprite2);
	    TextDrawHideForAll(Sprite3);
	    TextDrawHideForAll(Sprite4);
	    TextDrawHideForAll(Sprite5);
	    TextDrawHideForAll(Sprite6);
	    TextDrawHideForAll(Sprite7);
	    TextDrawHideForAll(Sprite8);
		CountdownStart = 0;
	    KillTimer(countdowntimer);
	}
	return 1;
}

