#include <a_samp>

#if defined FILTERSCRIPT

new Text:Clock;
new Text:Date;

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print("Time and Date v2 by b00m");
	print("--------------------------------------\n");
	return 1;
}

public OnGameModeInit()
{
	Clock=TextDrawCreate(549,24, "00:00");
	TextDrawLetterSize(Clock,0.55,2);
	TextDrawFont(Clock,3);
	TextDrawBackgroundColor(Clock,0x000000AA);
	TextDrawSetOutline(Clock,2);

	Date=TextDrawCreate(500,3, "01.01.2012");
	TextDrawLetterSize(Date,0.55,2);
	TextDrawFont(Date,3);
	TextDrawBackgroundColor(Date,0x000000AA);
	TextDrawSetOutline(Date,2);

	SetTimer("time", 60000, 1); // After one minute you will se real time and date
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public time()
{
// HOURS
new hour,minute,second;
gettime(hour,minute,second);
new string[256];
new string2[256];
if (minute <= 9)
{
	format(string,25,"%d:0%d",hour,minute);
}
else
{
	format(string,25,"%d:%d",hour,minute);
}
// DATE
new day,month,year;
getdate(year,month,day);

if (day <= 9){
format(string2,25,"0%d.%d.%d",day,month,year);
}
else if (month <= 9 && day >= 9) {
format(string2,25,"%d.0%d.%d",day,month,year);
}
else {
format(string2,25,"%d.%d.%d",day,month,year);
}

if (hour == 0){SetWorldTime(0);}
if (hour == 1){SetWorldTime(1);}
if (hour == 2){SetWorldTime(2);}
if (hour == 3){SetWorldTime(3);}
if (hour == 4){SetWorldTime(4);}
if (hour == 5){SetWorldTime(5);}
if (hour == 6){SetWorldTime(6);}
if (hour == 7){SetWorldTime(7);}
if (hour == 8){SetWorldTime(8);}
if (hour == 9){SetWorldTime(9);}
if (hour == 10){SetWorldTime(10);}
if (hour == 11){SetWorldTime(11);}
if (hour == 12){SetWorldTime(12);}
if (hour == 13){SetWorldTime(13);}
if (hour == 14){SetWorldTime(14);}
if (hour == 15){SetWorldTime(15);}
if (hour == 16){SetWorldTime(16);}
if (hour == 17){SetWorldTime(17);}
if (hour == 18){SetWorldTime(18);}
if (hour == 19){SetWorldTime(19);}
if (hour == 20){SetWorldTime(20);}
if (hour == 21){SetWorldTime(21);}
if (hour == 22){SetWorldTime(22);}
if (hour == 23){SetWorldTime(23);}
if (hour == 24){SetWorldTime(24);}


for(new i=0;i<MAX_PLAYERS;i++)
{
	TextDrawHideForPlayer(i,Clock);
	TextDrawHideForPlayer(i,Date);

	TextDrawSetString(Clock,string);
	TextDrawSetString(Datum,string2);

	TextDrawShowForPlayer(i,Clock);
	TextDrawShowForPlayer(i,Date);
}
return 1;
}

public OnPlayerSpawn(playerid)
{
        TextDrawShowForPlayer(playerid,Clock);
        TextDrawShowForPlayer(playerid,Datum);
}
#endif
