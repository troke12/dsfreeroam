
#include <a_samp>
#include <mSelection>

//--------------------------[Defines]-----------------------------------------
#define DIALOG_BG_COLOR 0x4A5A6BBB
#define PREV_BG_COLOR 0x88888899
#define PREV_BG_COLOR2 0xFFFF00AA 
#define AMMO 100
//------------------------------------------------------------------------------

new gunlist = mS_INVALID_LISTID;

public OnFilterScriptInit()
{
	gunlist = LoadModelSelectionMenu("gun.txt"); 
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if(strcmp(cmdtext, "/wepsmenu", true) == 0)
	{
	    ShowModelSelectionMenu(playerid, gunlist, "Weaponlist", DIALOG_BG_COLOR, PREV_BG_COLOR, PREV_BG_COLOR2); // ѕоказываем игроку меню с выбором оружи€.
	    return 1;
	}
	return 0;
}

public OnPlayerModelSelection(playerid, response, listid, modelid)
{
	if(listid == gunlist)
	{
	    if(response)
	    {
		    switch(modelid)
			{
	        	case 331: GivePlayerWeapon(playerid, 1, AMMO); // Brass Knuckles
	        	case 333: GivePlayerWeapon(playerid, 2, AMMO); // Golf Club
	        	case 334: GivePlayerWeapon(playerid, 3, AMMO); // Nightstick
	        	case 335: GivePlayerWeapon(playerid, 4, AMMO); // Knife
	        	case 336: GivePlayerWeapon(playerid, 5, AMMO); // Baseball Bat
	        	case 337: GivePlayerWeapon(playerid, 6, AMMO); // Shovel
	        	case 338: GivePlayerWeapon(playerid, 7, AMMO); // Pool Cue
	        	case 339: GivePlayerWeapon(playerid, 8, AMMO); // Katana
	        	case 341: GivePlayerWeapon(playerid, 9, AMMO); // Chainsaw
	        	case 321: GivePlayerWeapon(playerid, 10, AMMO); // Double-ended Dildo
	        	case 325: GivePlayerWeapon(playerid, 14, AMMO); // Flowers
	        	case 326: GivePlayerWeapon(playerid, 15, AMMO); // Cane
	        	case 342: GivePlayerWeapon(playerid, 16, AMMO); // Grenade
	        	case 343: GivePlayerWeapon(playerid, 17, AMMO); // Tear Gas
	        	case 344: GivePlayerWeapon(playerid, 18, AMMO); // Molotov Cocktail
	        	case 346: GivePlayerWeapon(playerid, 22, AMMO); // 9mm
	        	case 347: GivePlayerWeapon(playerid, 23, AMMO); // Silenced 9mm
	        	case 348: GivePlayerWeapon(playerid, 24, AMMO); // Desert Eagle
	        	case 349: GivePlayerWeapon(playerid, 25, AMMO); // Shotgun
	        	case 350: GivePlayerWeapon(playerid, 26, AMMO); // Sawnoff
	        	case 351: GivePlayerWeapon(playerid, 27, AMMO); // Combat Shotgun
	        	case 352: GivePlayerWeapon(playerid, 28, AMMO); // Micro SMG/Uzi
	        	case 353: GivePlayerWeapon(playerid, 29, AMMO); // MP5
	        	case 355: GivePlayerWeapon(playerid, 30, AMMO); // AK-47
	        	case 356: GivePlayerWeapon(playerid, 31, AMMO); // M4
	        	case 372: GivePlayerWeapon(playerid, 32, AMMO); // Tec-9
	        	case 357: GivePlayerWeapon(playerid, 33, AMMO); // Country Rifle
	        	case 358: GivePlayerWeapon(playerid, 34, AMMO); // Sniper Rifle
	        	case 359: GivePlayerWeapon(playerid, 35, AMMO); // RPG
	        	case 360: GivePlayerWeapon(playerid, 36, AMMO); // HS Rocket
	        	case 361: GivePlayerWeapon(playerid, 37, AMMO); // Flamethrower
	        	case 362: GivePlayerWeapon(playerid, 38, AMMO); // Minigun
	        	case 363: { GivePlayerWeapon(playerid, 39, AMMO); GivePlayerWeapon(playerid, 40, 1); }// Satchel Charge + Detonator
	        	case 365: GivePlayerWeapon(playerid, 41, AMMO); // Spraycan
	        	case 366: GivePlayerWeapon(playerid, 42, AMMO); // Fire Extinguisher
			}
		    SendClientMessage(playerid, 0x33AA33AA, "The weapon is selected!");
	    }
	    else SendClientMessage(playerid, 0xFF0000FF, "You cancelled a weapon choice!");
    	return 1;
	}
	return 1;
}
