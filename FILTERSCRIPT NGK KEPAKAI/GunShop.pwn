/*                                          Gun shop system
                                             With dialogs
									          and colors
									          
                              Made by Tautwis, August, 16th, Lithuania, 2011.
                              
                                     Don't remove credits please :)
*/

// === DEFINES === //
#define FILTERSCRIPT
#define COL_RED            "{F81414}"
#define COL_WHITE          "{FFFFFF}"
#define COL_GREEN          "{6EF83C}"
#define COLOR_GREEN 0x9EC73DAA

#include <a_samp>
#include <zcmd>

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" GunShop system with dialogs and colors loaded !");
	print("--------------------------------------\n");
	return 1;
}

#else // I din't knew how to remove this, so sorry :)

main()
{
 print("\n----------------------------------");
 print(" Blank Gamemode by your name here");
 print("----------------------------------\n");
}

#endif

public OnPlayerConnect(playerid)
{
	SendClientMessage(playerid, 0x9EC73DAA, "This server is using {F81414} GunShop with dialogs, made by Tautwis !");
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(response)
	    {
	    switch(dialogid)
	        {
			case 1:
	    	    {
	           	switch(listitem)
	        	{
	        	    case 0:
	        	    {
	        	        if(GetPlayerMoney(playerid) < 1) return SendClientMessage(playerid, 0xFFFFFF, "You don't have enough money !");
	        	        GivePlayerMoney(playerid, -1000);
	        	        GivePlayerWeapon(playerid, 31,100);
	        	        PlayerPlaySound(playerid, 1057, 0.0, 0.0, 10.0);
	        	        SendClientMessage(playerid, 0x9EC73DAA, "Bought {F81414}M4 !");
	        	    }
	        	    case 1:
	        	    {
	        	        if(GetPlayerMoney(playerid) < 2) return SendClientMessage(playerid, 0xFFFFFF, "You don't have enough money !");
	        	        GivePlayerMoney(playerid, -2000);
	        	        GivePlayerWeapon(playerid, 30,100);
	        	        PlayerPlaySound(playerid, 1057, 0.0, 0.0, 10.0);
	        	        SendClientMessage(playerid, 0x9EC73DAA, "Bought {F81414}AK47 !");
	        	    }
	        	    case 2:
	        	    {
	        	        if(GetPlayerMoney(playerid) < 3) return SendClientMessage(playerid, 0xFFFFFF, "You don't have enough money !");
	        	        GivePlayerMoney(playerid, -5000);
	        	        GivePlayerWeapon(playerid, 35,10);
	        	        PlayerPlaySound(playerid, 1057, 0.0, 0.0, 10.0);
	        	        SendClientMessage(playerid, 0x9EC73DAA, "Bought {F81414}Bazooka !");
	        	    }
	        	    case 3:
	        	    {
	        	        if(GetPlayerMoney(playerid) < 4) return SendClientMessage(playerid, 0xFFFFFF, "You don't have enough money !");
	        	        GivePlayerMoney(playerid, -7000);
	        	        GivePlayerWeapon(playerid, 34,50);
	        	        PlayerPlaySound(playerid, 1057, 0.0, 0.0, 10.0);
	        	        SendClientMessage(playerid, 0x9EC73DAA, "Bought {F81414}Sniper Rifle !");
	        	    }
	        	    case 4:
	        	    {
	        	        if(GetPlayerMoney(playerid) < 5) return SendClientMessage(playerid, 0xFFFFFF, "You don't have enough money !");
	        	        GivePlayerMoney(playerid, -200);
	        	        GivePlayerWeapon(playerid, 16,10);
	        	        PlayerPlaySound(playerid, 1057, 0.0, 0.0, 10.0);
	        	        SendClientMessage(playerid, 0x9EC73DAA, "Bought {F81414}Grenades !");
	        	    }
	        	    case 5:
	        	    {
	        	        if(GetPlayerMoney(playerid) < 6) return SendClientMessage(playerid, 0xFFFFFF, "You don't have enough money !");
	        	        GivePlayerMoney(playerid, -300);
	        	        GivePlayerWeapon(playerid, 18,10);
	        	        PlayerPlaySound(playerid, 1057, 0.0, 0.0, 10.0);
	        	        SendClientMessage(playerid, 0x9EC73DAA, "Bought {F81414}Molotov !");
	        	    }
	        	    case 6:
	        	    {
	        	        if(GetPlayerMoney(playerid) < 7) return SendClientMessage(playerid, 0xFFFFFF, "You don't have enough money !");
	        	        GivePlayerMoney(playerid, -500);
	        	        GivePlayerWeapon(playerid, 22,100);
	        	        PlayerPlaySound(playerid, 1057, 0.0, 0.0, 10.0);
	        	        SendClientMessage(playerid, 0x9EC73DAA, "Bought {F81414}Colt !");
	        	    }
	        	    case 7:
	        	    {
	        	        if(GetPlayerMoney(playerid) < 8) return SendClientMessage(playerid, 0xFFFFFF, "You don't have enough money !");
	        	        GivePlayerMoney(playerid, -6000);
	        	        GivePlayerWeapon(playerid, 27,100);
	        	        PlayerPlaySound(playerid, 1057, 0.0, 0.0, 10.0);
	        	        SendClientMessage(playerid, 0x9EC73DAA, "Bought {F81414}Combat Shotgun !");
	        	    }
	        	    case 8:
	        	    {
	        	        if(GetPlayerMoney(playerid) < 9) return SendClientMessage(playerid, 0xFFFFFF, "You don't have enough money !");
	        	        GivePlayerMoney(playerid, -4000);
	        	        GivePlayerWeapon(playerid, 28,100);
	        	        PlayerPlaySound(playerid, 1057, 0.0, 0.0, 10.0);
	        	        SendClientMessage(playerid, 0x9EC73DAA, "Bought {F81414}UZI !");
	        	    }
	        	    case 9:
	        	    {
	        	        if(GetPlayerMoney(playerid) < 10) return SendClientMessage(playerid, 0xFFFFFF, "You don't have enough money !");
	        	        GivePlayerMoney(playerid, -1000);
	        	        GivePlayerWeapon(playerid, 29,100);
	        	        PlayerPlaySound(playerid, 1057, 0.0, 0.0, 10.0);
	        	        SendClientMessage(playerid, 0x9EC73DAA, "Bought {F81414}MP5 !");

	        	    }
	    	    }
			}
	    }
	}
	return 1;
}

// ============================= ZCMD COMMAND ================================//
COMMAND:buygun(playerid, params[])
{
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_LIST, "Choose a gun to buy", "M4 \
	 {F81414}$1000 \nAK-47  {F81414}$2000 \nBazooka  {F81414}$5000 \n\
	Sniper Rifle  {F81414}$7000 \nGrenades  {F81414}$200 \nMolotov  {F81414}$400\
	 \nColt  {F81414}$500 \nCombat Shotgun  {F81414}$6000 \nUZI  {F81414}$4000 \
	 \nMP5  {F81414}$1000", "Buy", "Cancel"); // You can change the dialog ID to your own
	return 1;
}
