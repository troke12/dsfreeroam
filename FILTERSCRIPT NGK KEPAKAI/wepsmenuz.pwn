#include <a_samp>

    #if defined FILTERSCRIPT

    #define WEAPONS 2341

    public OnFilterScriptInit()
    {
    		print("\n--------------------------------------");
			print(" Weapon MEnu for VGI by krisna Loaded");
			print("--------------------------------------\n");
            return 1;
    }

    public OnFilterScriptExit()
    {
            return 1;
    }

    #endif

    public OnPlayerCommandText(playerid, cmdtext[])
    {
            if (strcmp("/wepsmenu", cmdtext, true, 10) == 0)
            {
                    ShowPlayerDialog(playerid, 2341, DIALOG_STYLE_LIST, "Weapon Menu", "Health {$1000}\nArmour {$1500}\n9mm {$2000}\nSilence 9mm {$2500}\nDesert Eagle {$3000}\nShotgun {$5000}\nSawn-Off Shotgun {$6000}\nCombat Shotgun {$6500}\nMicro SMG {$3000}\nMP5 {$4000}\nTec-9 {$5500}\nAK-47 {$4500}\nM4 {$6000}\nCountry Rifle {$6500}\nSniper Rifle {$7000}", "Purchase", "Cancel");
                    return 1;
            }
            return 0;
    }

    public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
    {
            if(dialogid == 2341)
            {
                if(response)
                {
                    if(listitem == 0)
                    {
  	        	        if(GetPlayerMoney(playerid) < 1) return SendClientMessage(playerid, 0xFFFFFF, "You don't have enough money !");
						GivePlayerMoney(playerid, -1000);
                        SetPlayerHealth(playerid, 100); //Health
                        SendClientMessage(playerid, 0x0FFF00FF, "Item Purchase!");
                    }
                    if(listitem == 1)
                    {
                    	if(GetPlayerMoney(playerid) < 2) return SendClientMessage(playerid, 0xFFFFFF, "You don't have enough money !");
	                    GivePlayerMoney(playerid, -1500);
                     	SetPlayerArmour(playerid, 100); //Armour
                      	SendClientMessage(playerid, 0x0FFF00FF, "Item Purchase!");
                    }
                    if(listitem == 2)
                    {
            	        if(GetPlayerMoney(playerid) < 3) return SendClientMessage(playerid, 0xFFFFFF, "You don't have enough money !");
                    	GivePlayerMoney(playerid, -2000);
                     	GivePlayerWeapon(playerid, 22, 1000); //9mm
                      	SendClientMessage(playerid, 0x0FFF00FF, "Item Purchase!");
                    }
                    if(listitem == 3)
                    {
        	            if(GetPlayerMoney(playerid) < 4) return SendClientMessage(playerid, 0xFFFFFF, "You don't have enough money !");
                    	GivePlayerMoney(playerid, -2500);
                     	GivePlayerWeapon(playerid, 23, 1000); //Silence 9mm
	 					SendClientMessage(playerid, 0x0FFF00FF, "Item Purchase!");
    				}
        			if(listitem == 4)
           			{
    	       			if(GetPlayerMoney(playerid) < 5) return SendClientMessage(playerid, 0xFFFFFF, "You don't have enough money !");
       					GivePlayerMoney(playerid, -3000);
           				GivePlayerWeapon(playerid, 24, 1000); //Desert Eagle
              			SendClientMessage(playerid, 0x0FFF00FF, "Item Purchase!");
                	}
                 	if(listitem == 5)
                  	{
                  		if(GetPlayerMoney(playerid) < 6) return SendClientMessage(playerid, 0xFFFFFF, "You don't have enough money !");
                   		GivePlayerMoney(playerid, -5000);
                     	GivePlayerWeapon(playerid, 25, 1000); //Shotgun
                      	SendClientMessage(playerid, 0x0FFF00FF, "Item Purchase!");
                   	}
                    if(listitem == 6)
                    {
	                    if(GetPlayerMoney(playerid) < 7) return SendClientMessage(playerid, 0xFFFFFF, "You don't have enough money !");
                    	GivePlayerMoney(playerid, -6000);
                     	GivePlayerWeapon(playerid, 26, 1000); //Sawn-off
               			SendClientMessage(playerid, 0x0FFF00FF, "Item Purchase!");
                  	}
                    if(listitem == 7)
					{
						if(GetPlayerMoney(playerid) < 8) return SendClientMessage(playerid, 0xFFFFFF, "You don't have enough money !");
                   		GivePlayerMoney(playerid, -6500);
                     	GivePlayerWeapon(playerid, 27, 1000); //Combat Shotgun
           				SendClientMessage(playerid, 0x0FFF00FF, "Item Purchase!");
				    }
				    if(listitem == 8)
   				    {
   				    	if(GetPlayerMoney(playerid) < 9) return SendClientMessage(playerid, 0xFFFFFF, "You don't have enough money !");
           				GivePlayerMoney(playerid, -3000);
               			GivePlayerWeapon(playerid, 28, 1000); //Micro SMG
           				SendClientMessage(playerid, 0x0FFF00FF, "Item Purchase!");
               		}
                 	if(listitem == 9)
                  	{
                  		if(GetPlayerMoney(playerid) < 10) return SendClientMessage(playerid, 0xFFFFFF, "You don't have enough money !");
                   		GivePlayerMoney(playerid, -4000);
                     	GivePlayerWeapon(playerid, 29, 1000); //MP5
                      	SendClientMessage(playerid, 0x0FFF00FF, "Item Purchase!");
                   	}
                    if(listitem == 10)
                    {
                    	if(GetPlayerMoney(playerid) < 11) return SendClientMessage(playerid, 0xFFFFFF, "You don't have enough money !");
                   		GivePlayerMoney(playerid, -5500);
                     	GivePlayerWeapon(playerid, 32, 1000); //Tec-9
                      	SendClientMessage(playerid, 0x0FFF00FF, "Item Purchase!");
                    }
                    if(listitem == 11)
               	 	{
               	 	    if(GetPlayerMoney(playerid) < 12) return SendClientMessage(playerid, 0xFFFFFF, "You don't have enough money !");
                  		GivePlayerMoney(playerid, -4500);
                    	GivePlayerWeapon(playerid, 30, 1000); //AK-47
                     	SendClientMessage(playerid, 0x0FFF00FF, "Item Purchase!");
                    }
                    if(listitem == 12)
                    {
                        if(GetPlayerMoney(playerid) < 13) return SendClientMessage(playerid, 0xFFFFFF, "You don't have enough money !");
                    	GivePlayerMoney(playerid, -6000);
                     	GivePlayerWeapon(playerid, 31, 1000); //M4
                      	SendClientMessage(playerid, 0x0FFF00FF, "Item Purchase!");
                    }
                    if(listitem == 13)
                    {
                        if(GetPlayerMoney(playerid) < 14) return SendClientMessage(playerid, 0xFFFFFF, "You don't have enough money !");
                    	GivePlayerMoney(playerid, -6500);
                        GivePlayerWeapon(playerid, 33, 1000); //Country Rifle
                        SendClientMessage(playerid, 0x0FFF00FF, "Item Purchase!");
                    }
                    if(listitem == 14)
                    {
                        if(GetPlayerMoney(playerid) < 15) return SendClientMessage(playerid, 0xFFFFFF, "You don't have enough money !");
          	            GivePlayerMoney(playerid, -7000);
                       	GivePlayerWeapon(playerid, 34, 1000); //Sniper Rifle
                        SendClientMessage(playerid, 0x0FFF00FF, "Item Purchase!");
                    }
              	}
 				return 1;
    		}
     		return 1;
	}
