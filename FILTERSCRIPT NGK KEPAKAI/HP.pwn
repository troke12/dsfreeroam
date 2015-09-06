/*
* Clock Real Time - Created by Noredine - Licence GPLv3
*/

#include <a_samp>

forward clock();
forward clock2();

new Text:Clock;
new clockcreated = 0;

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Clock by HP Loaded                     ");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerSpawn(playerid){
	clock();
}

public clock(){
	new hour,minute,second;
	new string[256];
	gettime(hour,minute,second);
	if (minute <= 9) {
		format(string,25,"%d:0%d",hour,minute);
	}
	else {
		format(string,25,"%d:%d",hour,minute);
	}

	if (clockcreated == 0) {
	    clockcreated = 1;
		Clock = TextDrawCreate(546.0, 23.0, string);
		TextDrawLetterSize(Clock, 0.5, 1.9);
		TextDrawFont(Clock, 3);
		TextDrawSetOutline(Clock, 2);
		TextDrawShowForAll(Clock);
	}
	else {

	}
	SetTimer("clock2",1000,1);
	return 1;
}

public clock2(){
	new hour,minute,second;
	new string[256];
	gettime(hour,minute,second);
	if (minute <= 9) {
		if (second <= 9) {
			format(string,25,"%d:0%d:0%d", hour, minute, second);
		}
		else {
			format(string,25,"%d:0%d:%d",hour,minute, second);
		}
	}
	else {
		if (second <= 9) {
			format(string,25,"%d:%d:0%d", hour, minute, second);
		}
		else {
			format(string,25,"%d:%d:%d",hour,minute, second);
		}
	}

	if (clockcreated == 1) {
	    TextDrawSetString(Clock, string);
	}
	TextDrawShowForAll(Clock);
	return 1;
}
