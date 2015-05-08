/*
Authors : Krisna
Forum   : http://forum.sa-mp.com/member.php?u=192739
Include : zcmd,a_samp
Do not Remove My Credits!
*/
#include <a_samp>
#include <zcmd>

new Text:MSGRandom;
forward RandomMessage();

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print("       Randome Message Loaded!          ");
	print("--------------------------------------\n");

	SetTimer("RandomMessage",30000,1);
	
	MSGRandom = TextDrawCreate(320.000000, 437.000000, "Velixion Gaming Indonesia");
	TextDrawAlignment(MSGRandom, 2);
	TextDrawBackgroundColor(MSGRandom, 255);
	TextDrawFont(MSGRandom, 2);
	TextDrawLetterSize(MSGRandom, 0.310000, 0.799998);
	TextDrawColor(MSGRandom, -1);
	TextDrawSetOutline(MSGRandom, 0);
	TextDrawSetProportional(MSGRandom, 1);
	TextDrawSetShadow(MSGRandom, 1);
	TextDrawUseBox(MSGRandom, 1);
	TextDrawBoxColor(MSGRandom, 1313030745);
	TextDrawTextSize(MSGRandom, 0.000000, 832.000000);
	return 1;

}

new RandomMessages[][] =
{
    "Use |/carmenu for spawn vehicles",
    "Don't Break The Rules!",
    "Powered and Created by Krisna",
    "Use |/wepsmenu for buy a weapon",
    "Use |/fix  for repair vehicle",
    "Press |LMB for Nos",
    "Use |/credits for see the credits",
    "Need VIP ? Contact Administator",
    "See A Cheater use | /report |",
    "Use Forum for See the News And Information",
    "www.velixiongaming.tk",
    "Use /cmds or /commands for see more commands",
    "Need Officers ? Contact the Leader Officers"
};

public RandomMessage()
{
        TextDrawSetString(MSGRandom, RandomMessages[random(sizeof(RandomMessages))]);
        return 1;
}

public OnPlayerSpawn(playerid)
{
	TextDrawShowForPlayer(playerid, MSGRandom);
	return 1;
}

//Commands

CMD:randommsg(playerid, params[])
{
	TextDrawHideForPlayer(playerid, MSGRandom);
 	return 1;
}
CMD:showmsg(playerid, params[])
{
	TextDrawShowForPlayer(playerid, MSGRandom);
	return 1;
}
