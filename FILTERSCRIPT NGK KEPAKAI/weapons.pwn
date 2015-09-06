/*

*******************************************************
 Dialog/Command based Weapon Spawner by FusiouS
 Version: 1.0, Release 1
 SA-MP Version: 0.3 Compatible (including newest 0.3c)
 Credits: FusiouS
*******************************************************

					Features:
	- Dialog/Command based weapon spawning.
	- Guns in Weapon ID number order (Starting from 4-)
	- Currently working for all users, can be easily changed for RCON admins only.
	- Contains most used weapons in SA-MP.


				How to install & use:
					
	1) Download package and place .pwn file to your filterscripts folder
	2) Compile .pwn file to .amx and write to your server.cfg behind filterscripts: weapons
	3) Start your server and login as RCON admin
	4) Type /weapons and weapon list appears. Choose your weapon and press "spawn"


TERMS OF USE: You are free to modify this script for your OWN use only. DO NOT remove credits or re-release this as your own work.              */

#include <a_samp>
#define weapons 4670

public OnFilterScriptInit()
{
    print("\n--------------------------------------");
    print(" Weapon Spawner by FusiouS loaded ");
    print(" Version: 1.0, Release 1");
    print("--------------------------------------");
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if (!strcmp(cmdtext, "/weapons", true))

	{
        ShowPlayerDialog(playerid, weapons, DIALOG_STYLE_LIST, "Weapon Spawner", "Knife\nBaseball Bat\nPistol\nSilenced Pistol\nDesert Eagle\nShotgun\nSawn-off Shotgun\nCombat Shotgun\nTec-9\nMicro-MP5\nMP5\nAK-47\nM4 Carbine\nCountry Rifle\nSniper Rifle\nRocket Launcher\nHeat Seeker\nFlamethrower\nGrenade\nTear Gas-Grenade\nMolotov Cocktail\nRemote Satchel with Detonator\nSpray Can\nFire Extinguisher", "Spawn", "Cancel");
        return 1;
    }
    return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == weapons)
    {
        switch(listitem)
        {
            case 0:
                {
                  GivePlayerWeapon(playerid, 4, 1);
                }
			case 1:
                {
                  GivePlayerWeapon(playerid, 5, 1);
                }
			case 2:
                {
                  GivePlayerWeapon(playerid, 22, 5000);
                }
            case 3:
                {
                  GivePlayerWeapon(playerid, 23, 5000);
                }
            case 4:
                {
                  GivePlayerWeapon(playerid, 24, 5000);
                }
            case 5:
                {
                  GivePlayerWeapon(playerid, 25, 5000);
                }
            case 6:
                {
                  GivePlayerWeapon(playerid, 26, 5000);
                }
            case 7:
                {
                  GivePlayerWeapon(playerid, 27, 5000);
                }
            case 8:
                {
                  GivePlayerWeapon(playerid, 32, 5000);
                }
            case 9:
                {
                  GivePlayerWeapon(playerid, 28, 5000);
                }
            case 10:
                {
                  GivePlayerWeapon(playerid, 29, 5000);
                }
            case 11:
                {
                  GivePlayerWeapon(playerid, 30, 5000);
                }
            case 12:
                {
                  GivePlayerWeapon(playerid, 31, 5000);
                }
            case 13:
                {
                  GivePlayerWeapon(playerid, 33, 5000);
                }
            case 14:
                {
                  GivePlayerWeapon(playerid, 34, 5000);
                }
            case 15:
                {
                  GivePlayerWeapon(playerid, 35, 5000);
                }
            case 16:
                {
                  GivePlayerWeapon(playerid, 36, 5000);
                }
            case 17:
                {
                  GivePlayerWeapon(playerid, 37, 5000);
                }
            case 18:
                {
                  GivePlayerWeapon(playerid, 16, 5000);
                }
            case 19:
                {
                  GivePlayerWeapon(playerid, 17, 5000);
                }
            case 20:
                {
                  GivePlayerWeapon(playerid, 18, 5000);
                }
            case 21:
                {
                  GivePlayerWeapon(playerid, 39, 5000);
                  GivePlayerWeapon(playerid, 40, 1);
				}
            case 22:
                {
                  GivePlayerWeapon(playerid, 41, 5000);
                }
            case 23:
                {
                  GivePlayerWeapon(playerid, 42, 5000);
                }
        }
    }
    return 1;
}
