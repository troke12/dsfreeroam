/*
                                                                    dddddddd
   SSSSSSSSSSSSSSS hhhhhhh                                          d::::::d
 SS:::::::::::::::Sh:::::h                                          d::::::d
S:::::SSSSSS::::::Sh:::::h                                          d::::::d
S:::::S     SSSSSSSh:::::h                                          d:::::d
S:::::S             h::::h hhhhh         aaaaaaaaaaaaa      ddddddddd:::::d
S:::::S             h::::hh:::::hhh      a::::::::::::a   dd::::::::::::::d
 S::::SSSS          h::::::::::::::hh    aaaaaaaaa:::::a d::::::::::::::::d
  SS::::::SSSSS     h:::::::hhh::::::h            a::::ad:::::::ddddd:::::d
    SSS::::::::SS   h::::::h   h::::::h    aaaaaaa:::::ad::::::d    d:::::d
       SSSSSS::::S  h:::::h     h:::::h  aa::::::::::::ad:::::d     d:::::d
            S:::::S h:::::h     h:::::h a::::aaaa::::::ad:::::d     d:::::d
            S:::::S h:::::h     h:::::ha::::a    a:::::ad:::::d     d:::::d
SSSSSSS     S:::::S h:::::h     h:::::ha::::a    a:::::ad::::::ddddd::::::dd
S::::::SSSSSS:::::S h:::::h     h:::::ha:::::aaaa::::::a d:::::::::::::::::d
S:::::::::::::::SS  h:::::h     h:::::h a::::::::::aa:::a d:::::::::ddd::::d
 SSSSSSSSSSSSSSS    hhhhhhh     hhhhhhh  aaaaaaaaaa  aaaa  ddddddddd   ddddd
*/


#include <a_samp>
#define FILTERSCRIPT

new Text:Time, Text:Date;
new hour, minute, seconds;
new timestr[32];
new Text:txtTimeDisp;

forward UpdateTime();

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Updated Version! WORLDCLOCK+DATE By Shadow");
	print("--------------------------------------\n");

    SetTimer("settime",1000,true);

	txtTimeDisp = TextDrawCreate(605.0,25.0,"00:00:00");
	TextDrawUseBox(txtTimeDisp, 0);
	TextDrawFont(txtTimeDisp, 3);
	TextDrawSetShadow(txtTimeDisp,0); // no shadow
    TextDrawSetOutline(txtTimeDisp,2); // thickness 1
    TextDrawBackgroundColor(txtTimeDisp,0x000000FF);
    TextDrawColor(txtTimeDisp,0xFFFFFFFF);
    TextDrawAlignment(txtTimeDisp,3);
	TextDrawLetterSize(txtTimeDisp,0.5,1.5);

	SetTimer("UpdateTime",1000 * 60,1);
	return 1;
}

public OnFilterScriptExit()
{
	print("\n-----------------------------------------------------");
	print(" Update Version! WORLDCLOCK+DATE By Shadow !UNLOADED!");
	print("-----------------------------------------------------/n");
	return 1;
}

public OnPlayerConnect(playerid)
{
	gettime(hour, minute);
	SetPlayerTime(playerid, hour, minute, seconds);
	return 1;
}

public OnPlayerSpawn(playerid)
{
 	TextDrawShowForPlayer(playerid, Time), TextDrawShowForPlayer(playerid, Date);
	gettime(hour, minute, seconds);
	SetPlayerTime(playerid,hour,minute,seconds);
	
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	TextDrawHideForPlayer(playerid, Time), TextDrawHideForPlayer(playerid, Date);
	return 1;
}

public UpdateTime()
{
	gettime(hour, minute, seconds);
	format(timestr,32"%d/%s%d/%s%d",hour,minute,seconds);
	TextDrawSetString(txdTimeDisp,timestr);
	
	SetWorldTime(hour);
	
	new x=0;
	while(x!=MAX_PLAYERS) {
	if(IsPlayerConnected(x) && GetPlayerState(x) != PLAYER_STATE_NONE) {
	    SetPlayerTime(x,hour,minute,seconds);
	    }
	    x++;
	}
}
	
