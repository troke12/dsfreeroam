#include <a_samp>

#define DIALOGID 1337


public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/weapons", cmdtext, true, 10) == 0)
	{
		ShowPlayerDialog(playerid, DIALOGID, DIALOG_STYLE_LIST, "Weapon Lists", "Melee\nPistols\nSub-Machine Guns\nRifle's\nAssault\nShotgun's\nHeavy Weapons\nThrown\nMisc", "Select", "Cancel");
		return 1;
	}
	return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOGID)
	{
		if(response)
		{
			if(listitem == 0) // Meele
			{
				ShowPlayerDialog(playerid, DIALOGID+1, DIALOG_STYLE_LIST, "Select a Weapon", "Knuckle Dusters\nGolf Club\nNite Stick\nKnife\nBat\nShovel\nPool Cue\nKatana\nDildo\nSpray Can\nCane", "Select", "Cancel");
			}
			if(listitem == 1) // Pistols
			{
				ShowPlayerDialog(playerid, DIALOGID+2, DIALOG_STYLE_LIST, "Select a Weapon", "9mm\nSilenced 9mm\nDesert Eagle", "Select", "Cancel");
			}
			if(listitem == 2) // Sub-Machine Guns
			{
				ShowPlayerDialog(playerid, DIALOGID+3, DIALOG_STYLE_LIST, "Select a Weapon", "Uzi\nSMG\nTec9", "Select", "Cancel");
			}
			if(listitem == 3) // Rifles
			{
				ShowPlayerDialog(playerid, DIALOGID+4, DIALOG_STYLE_LIST, "Select a Weapon", "Country Rifle\nSniper Rifle", "Select", "Cancel");
			}
			if(listitem == 4) // Assault
			{
				ShowPlayerDialog(playerid, DIALOGID+5, DIALOG_STYLE_LIST, "Select a Weapon", "AK-47\nM4", "Select", "Cancel");
			}
			if(listitem == 5) // Shotguns
			{
				ShowPlayerDialog(playerid, DIALOGID+6, DIALOG_STYLE_LIST, "Select a Weapon", "Standard Shotgun\nSawnoff Shotgun\nCombat Shotgun", "Select", "Cancel");
			}
			if(listitem == 6) // Heavy Weaponry
			{
				ShowPlayerDialog(playerid, DIALOGID+7, DIALOG_STYLE_LIST, "Select a Weapon", "Rocket Laucher\nHeat Seaker\nMinigun\nChain Saw", "Select", "Cancel");
			}
			if(listitem == 7) // Thrown
			{
				ShowPlayerDialog(playerid, DIALOGID+8, DIALOG_STYLE_LIST, "Select a Weapon", "Granade\nTear Gas", "Select", "Cancel");
			}
            if(listitem == 8) // Misc
			{
				ShowPlayerDialog(playerid, DIALOGID+9, DIALOG_STYLE_LIST, "Select a Weapon", "Fire Extinguisher\nSatchel Charge\nParachute\nNightvision Goggles\nFlowers", "Select", "Cancel");
			}
		}
		return 1;
	}

	if(dialogid == DIALOGID+1) // Meele 
	{
		if(response)
		{
			if(listitem == 0) 
			{
				GivePlayerWeapon(playerid, 1, 1);
			}
			if(listitem == 1) 
			{
				GivePlayerWeapon(playerid, 2, 1);
			}
			if(listitem == 2)
			{
				GivePlayerWeapon(playerid, 3, 1);
			}
			if(listitem == 3) 
			{
				GivePlayerWeapon(playerid, 4, 1);
			}
			if(listitem == 4)
			{
				GivePlayerWeapon(playerid, 5, 1);
			}
			if(listitem == 5) 
			{
				GivePlayerWeapon(playerid, 6, 1);
			}
			if(listitem == 6) 
			{
				GivePlayerWeapon(playerid, 7, 1);
			}
			if(listitem == 7) 
			{
				GivePlayerWeapon(playerid, 8, 1);
			}
			if(listitem == 8)
			{
				GivePlayerWeapon(playerid, 10, 1);
			}
			if(listitem == 9) 
			{
				GivePlayerWeapon(playerid, 41, 500);
			}
            if(listitem == 10)
			{
				GivePlayerWeapon(playerid, 15, 1);
			}
		}
		return 1;
	}
	
	if(dialogid == DIALOGID+2) // Pistols
	{
		if(response)
		{
			if(listitem == 0) 
			{
				GivePlayerWeapon(playerid, 22, 500);
			}
			if(listitem == 1) 
			{
				GivePlayerWeapon(playerid, 23, 500);
			}
			if(listitem == 2) 
			{
				GivePlayerWeapon(playerid, 24, 500);
			}
		}
		return 1;
	}
	
	if(dialogid == DIALOGID+3) // Sub's
	{
		if(response)
		{
			if(listitem == 0)
			{
				GivePlayerWeapon(playerid, 28, 500);
			}
			if(listitem == 1) 
			{
				GivePlayerWeapon(playerid, 29, 500);
			}
			if(listitem == 2) 
			{
				GivePlayerWeapon(playerid, 32, 500);
			}
		}
		return 1;
	}
	
	if(dialogid == DIALOGID+4) // Rifle's
	{
		if(response)
		{
			if(listitem == 0)
			{
				GivePlayerWeapon(playerid, 33, 500);
			}
			if(listitem == 1)
			{
				GivePlayerWeapon(playerid, 34, 500);
			}
		}
		return 1;
	}

	if(dialogid == DIALOGID+5) // Assault
	{
		if(response)
		{
			if(listitem == 0) 
			{
				GivePlayerWeapon(playerid, 30, 500);
			}
			if(listitem == 1)
			{
				GivePlayerWeapon(playerid, 31, 500);
			}
		}
		return 1;
	}
	
	if(dialogid == DIALOGID+6) // Shotguns
	{
		if(response)
		{
			if(listitem == 0)
			{
				GivePlayerWeapon(playerid, 25, 500);
			}
			if(listitem == 1) 
			{
				GivePlayerWeapon(playerid, 26, 500);
			}
			if(listitem == 2)
			{
	  			GivePlayerWeapon(playerid, 27, 500);
			}
		}
		return 1;
	}
	
	if(dialogid == DIALOGID+7) // Heavy Weapons
	{
		if(response)
		{
			if(listitem == 0)
			{
				GivePlayerWeapon(playerid, 35, 500);
			}
			if(listitem == 1)
			{
				GivePlayerWeapon(playerid, 36, 500);
			}
			if(listitem == 2)
			{
				GivePlayerWeapon(playerid, 38, 500);
			}
			if(listitem == 3)
			{
				GivePlayerWeapon(playerid, 9, 500);
			}
		}
		return 1;
	}
	
	if(dialogid == DIALOGID+8) // Thrown
	{
		if(response)
		{
			if(listitem == 0) 
			{
				GivePlayerWeapon(playerid, 16, 500);
			}
			if(listitem == 1)
			{
				GivePlayerWeapon(playerid, 17, 500);
			}
		}
		return 1;
	}
	
	if(dialogid == DIALOGID+9) // Misc Fire Extinguisher\nSatchel Charge\nParachute\nNightvision Goggles\nFlowers
	{
		if(response)
		{
			if(listitem == 0) 
			{
				GivePlayerWeapon(playerid, 42, 500);
			}
			if(listitem == 1) 
			{
				GivePlayerWeapon(playerid, 39, 500);
				GivePlayerWeapon(playerid, 40, 1);
			}
			if(listitem == 2) 
			{
				GivePlayerWeapon(playerid, 46, 1);
			}
			if(listitem == 3) 
			{
				GivePlayerWeapon(playerid, 44, 1);
			}
			if(listitem == 4) 
			{
				GivePlayerWeapon(playerid, 14, 1);
			}
		}
		return 1;
	}
	
	return 0;
 }
