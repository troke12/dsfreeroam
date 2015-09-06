//=====================
//WEAPON MENU BY KRISNA
//=====================
#include <a_samp>
#include <zcmd>
#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
    print("\n--------------------------------------");
    print(" Weapon Menu By Krisna Loaded");
    print("--------------------------------------\n");
    return 1;
}

public OnFilterScriptExit()
{
    print("\n--------------------------------------");
    print(" Weapon Menu By krisna Unloaded");
    print("--------------------------------------\n");
    return 1;
}

#else

main()
{
    print("\n----------------------------------");
    print(" Any Gamemode");
    print("----------------------------------\n");
}

#endif

public OnGameModeInit()
{
    return 1;
}

public OnGameModeExit()
{
    print("\n--------------------------------------");
    print(" Weapon Menu by Krisna UnLoaded");
    print("--------------------------------------\n");
    return 1;
}
CMD:9mm(playerid,params[])
{
    GivePlayerWeapon(playerid,22,50);
    GivePlayerMoney(playerid,-5000);
    SendClientMessage(playerid, 0x0000FF, "You Have Been Bought A 9mm Pistol For $5000 ");
    return 1;
}
CMD:shotgun(playerid,params[])
{
    GivePlayerWeapon(playerid,26,50);
    GivePlayerMoney(playerid,-5000);
    SendClientMessage(playerid, 0x0000FF, "You Have Been Bought A Pump Shotgun For $5000 ");
    return 1;
}
CMD:mp5(playerid,params[])
{
    GivePlayerWeapon(playerid,29,100);
    GivePlayerMoney(playerid,-5000);
    SendClientMessage(playerid, 0x0000FF, "You Have Been Bought A MP5 Machine Gun For $5000 ");
    return 1;
}
CMD:m4(playerid,params[])
{
    GivePlayerWeapon(playerid,31,90);
    GivePlayerMoney(playerid,-6000);
    SendClientMessage(playerid, 0x0000FF, "You Have Been Bought A M4A1 For $6000 ");
    return 1;
}
CMD:sniper(playerid,params[])
{
    GivePlayerWeapon(playerid,34,80);
    GivePlayerMoney(playerid,-6000);
    SendClientMessage(playerid, 0x0000FF, "You Have Been Bought A Sniper Rifle For $6000 ");
    return 1;
}
CMD:rocket(playerid,params[])
{
    GivePlayerWeapon(playerid,35,20);
    GivePlayerMoney(playerid,-7000);
    SendClientMessage(playerid, 0x0000FF, "You Have Been Bought A Rocket Launcher For $7000 ");
    return 1;
}
CMD:timebomb(playerid,params[])
{
    GivePlayerWeapon(playerid,39,15);
    GivePlayerMoney(playerid,-4000);
    SendClientMessage(playerid, 0x0000FF, "You Have Been Bought A Time Bomb For $4000 ");
    return 1;
}
CMD:camera(playerid,params[])
{
    GivePlayerWeapon(playerid,43,9999);
    GivePlayerMoney(playerid,-3000);
    SendClientMessage(playerid, 0x0000FF, "You Have Been Bought A Camera For $3000 ");
    return 1;
}
CMD:golf(playerid,params[])
{
	GivePlayerWeapon(playerid,2,500);
	GivePlayerMoney(playerid,-500);
	SendClientMessage(playerid, 0x0000FF, "You Have Golf Stick for $500");
	return 1;
}
CMD:baseball(playerid,params[])
{
	GivePlayerWeapon(playerid,5,500);
	GivePlayerMoney(playerid,-500);
	SendClientMessage(playerid, 0x0000FF, "You Have Baseball Bat for $500");
	return 1;
}
CMD:dildo(playerid,params[])
{
	GivePlayerWeapon(playerid,10,500);
	GivePlayerMoney(playerid,-500);
	SendClientMessage(playerid, 0x0000FF, "You Have Dildo for $500");
	return 1;
}
CMD:grenade(playerid,params[])
{
	GivePlayerWeapon(playerid,15,20);
	GivePlayerMoney(playerid,-5000);
	SendClientMessage(playerid, 0x0000FF, "You Have grenade for $5000");
	return 1;
}
CMD:molotop(playerid,params[])
{
	GivePlayerWeapon(playerid,18,15);
	GivePlayerMoney(playerid,-4000);
	SendClientMessage(playerid, 0x0000FF, "You Have Molotov for $4000");
	return 1;
}
CMD:uzi(playerid,params[])
{
	GivePlayerWeapon(playerid,28,500);
	GivePlayerMoney(playerid,-15000);
	SendClientMessage(playerid, 0x0000FF, "You Have UZI for $15000");
	return 1;
}
CMD:deagle(playerid,params[])
{
	GivePlayerWeapon(playerid,24,50);
	GivePlayerMoney(playerid,-10000);
	SendClientMessage(playerid, 0x0000FF, "You Have Deagle for $10000");
	return 1;
}
CMD:silenced(playerid,params[])
{
	GivePlayerWeapon(playerid,23,500);
	GivePlayerMoney(playerid,-5000);
	SendClientMessage(playerid, 0x0000FF, "You Have Silenced for $5000");
	return 1;
}
CMD:ak47(playerid,params[])
{
	GivePlayerWeapon(playerid,30,500);
	GivePlayerMoney(playerid,-5000);
	SendClientMessage(playerid, 0x0000FF, "You Have AK47 for $5000");
	return 1;
}
CMD:wepsmenu(playerid,params[])
{
    ShowPlayerDialog(playerid,1, DIALOG_STYLE_MSGBOX,"{00FFFF}Weapon Menu","{00FFFF}Beberapa CMD Weapon Antara Lain:\n{C0C0C0}/heal\n{C0C0C0}/armour\n{C0C0C0}/9mm\n{C0C0C0}/shotgun\n{C0C0C0}/mp5\n{C0C0C0}/m4\n{C0C0C0}/sniper\n{C0C0C0}/rocket\n{C0C0C0}\n{C0C0C0}/timebomb\n{C0C0C0}/camera\n{C0C0C0}/golf\n{C0C0C0}/baseball\n{C0C0C0}/dildo\n{C0C0C0}/grenade\n{C0C0C0}/molotop\n{C0C0C0}/uzi\n{C0C0C0}/deagle\n{C0C0C0}/silenced\n{C0C0C0}/ak47\n{FFFFFF}Weapon Menu By Krisna", "Close","Close");
    GivePlayerMoney(playerid,-5);
    SendClientMessage(playerid, 0x00FFFF, "You Are Now Viewing The Weapon List To Buy.");
    return 1;
}
