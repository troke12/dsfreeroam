/*
Krisna Clock Textdraw:
Credits
[~]Zhamaroth TextDraw Editor
[~]Shadow for filterscript World Clock
[~]Krisna Pradnya edit Filterscript
[~]SAMP Team
[~]Special Thanks For LRG for Idea

Thanks~
visit our Facebook www.facebook.com/krisna.pradnya

+REP me please :D
*/


#include <a_samp>
#define FILTERSCRIPT

new Text:Time, Text:Date;
new Text:Textdraw2;
forward settime(playerid);

public OnFilterScriptInit()
{
	print("+--------------------------------------------------+");
	print("| REALTIME CLOCK AND NEW TEXTDRAW BY KRISNA LOADED |");
	print("+--------------------------------------------------+");

    SetTimer("settime",1000,true);

	Date = TextDrawCreate(566.000000, 137.000000,"     ");

	TextDrawAlignment(Date, 2);
	TextDrawBackgroundColor(Date, 255);
	TextDrawFont(Date, 3);
	TextDrawLetterSize(Date, 0.519999, 1.500000);
	TextDrawColor(Date, -1);
	TextDrawSetOutline(Date, 0);
	TextDrawSetProportional(Date, 1);
	TextDrawSetShadow(Date, 1);
	TextDrawUseBox(Date, 1);
	TextDrawBoxColor(Date, 69359971);
	TextDrawTextSize(Date, 184.000000, 123.000000);

	Time = TextDrawCreate(566.000000, 155.000000,"      ");

	TextDrawAlignment(Time, 2);
	TextDrawBackgroundColor(Time, 255);
	TextDrawFont(Time, 2);
	TextDrawLetterSize(Time, 0.500000, 1.700000);
	TextDrawColor(Time, -65281);
	TextDrawSetOutline(Time, 0);
	TextDrawSetProportional(Time, 1);
	TextDrawSetShadow(Time, 1);
	TextDrawUseBox(Time, 1);
	TextDrawBoxColor(Time, 69359971);
	TextDrawTextSize(Time, 184.000000, 123.000000);
	
	Textdraw2 = TextDrawCreate(566.000000, 121.000000, "CLOCK");
	TextDrawAlignment(Textdraw2, 2);
	TextDrawBackgroundColor(Textdraw2, 255);
	TextDrawFont(Textdraw2, 2);
	TextDrawLetterSize(Textdraw2, 0.500000, 1.300000);
	TextDrawColor(Textdraw2, -1);
	TextDrawSetOutline(Textdraw2, 0);
	TextDrawSetProportional(Textdraw2, 1);
	TextDrawSetShadow(Textdraw2, 1);
	TextDrawUseBox(Textdraw2, 1);
	TextDrawBoxColor(Textdraw2, 119690775);
	TextDrawTextSize(Textdraw2, 181.000000, 123.000000);


	SetTimer("settime",1000,true);
	return 1;
}

public OnFilterScriptExit()
{
	print("+-----------------------------------------------------+");
	print("| REALTIME CLOCK AND NEW TEXTDRAW BY KRISNA UN-LOADED |");
	print("+-----------------------------------------------------+");
	return 1;
}

public OnPlayerSpawn(playerid)
{
	TextDrawShowForPlayer(playerid, Time), TextDrawShowForPlayer(playerid, Date);
	TextDrawShowForPlayer(playerid, Textdraw2);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	TextDrawHideForPlayer(playerid, Time), TextDrawHideForPlayer(playerid, Date);
	TextDrawHideForPlayer(playerid, Textdraw2);
	return 1;
}

public settime(playerid)
{
	new string[256],year,month,day,hours,minutes,seconds;
	getdate(year, month, day), gettime(hours, minutes, seconds);
	format(string, sizeof string, "%d/%s%d/%s%d", day, ((month < 10) ? ("0") : ("")), month, (year < 10) ? ("0") : (""), year);
	TextDrawSetString(Date, string);
	format(string, sizeof string, "%s%d:%s%d:%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes, (seconds < 10) ? ("0") : (""), seconds);
	TextDrawSetString(Time, string);
}
