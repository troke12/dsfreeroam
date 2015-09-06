/*



						LS-PD Dynamic System, by Blunt.
						Script Created on the 20th February 2012, All rights reserved.

						Commands - 

						Changelog - 22nd Feb, 2012 - Gang signs added for optimization.




*/

#define FILTERSCRIPT
#include <a_samp>
#include <ZCMD>

//Dialogs
#define DIALOG_SPAWNERMAIN  500
#define DIALOG_EQUIPMENT    501
#define DIALOG_PISTOLS      502
#define DIALOG_HEAVYWEPS    503
#define DIALOG_MELEE        504
#define DIALOG_CLOTHING     505


//Colors
#define COLOR_GREY          0xAD9797FF
#define COLOR_GREEN         0x58AB54FF
#define COLOR_PURPLE        0x963A99FF
#define COLOR_YELLOW        0xEAFF03FF
#define COLOR_LIGHTBLUE     0x7ED5F2FF
#define COLOR_RED           0xFF0D1DFF
#define COLOR_WHITE         0xFFFFFFFF
#define COLOR_BLUE          0x5D00FFFF

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" LS-PD System - by Blunt.");
	print("--------------------------------------\n");
	
	//Labels
	Create3DTextLabel("Cruiser Selector/Spawner - /carspawner \n{FF0D1D}by Blunt", COLOR_WHITE, 1574.2770,-1695.3258,6.2188, 10.0, 0, 0);
	Create3DTextLabel("Equipment Room - /enter \n{FF0D1D}by Blunt", COLOR_WHITE, 1568.6295,-1689.9706,6.2188, 10.0, 0, 0);
	Create3DTextLabel("Los Santos Police Department", COLOR_WHITE, 1554.0641,-1708.2268,6.2188, 10.0, 0, 0);
	Create3DTextLabel("Los Santos Police Department", COLOR_WHITE, 1550.8027,-1697.4136,6.2188, 10.0, 0, 0);
	Create3DTextLabel("Los Santos Police Department", COLOR_WHITE, 1532.0746,-1672.9426,6.2188, 10.0, 0, 0);
	Create3DTextLabel("Los Santos Police Department", COLOR_WHITE, 1549.7200,-1656.8212,6.2188, 10.0, 0, 0);
	
	
	//Vehicles
	AddStaticVehicle(596,1528.7388,-1687.8563,5.6116,89.5453,0,1); // PD car 1
	AddStaticVehicle(596,1528.4889,-1683.9357,5.6126,90.9261,0,1); // PD car 2
	AddStaticVehicle(596,1544.7776,-1684.2469,5.6126,88.8893,0,1); // PD car 3
	AddStaticVehicle(596,1545.6973,-1680.6071,5.6106,90.6858,0,1); // PD car 4
	AddStaticVehicle(596,1546.1519,-1667.9142,5.6102,268.5811,0,1); // PD car 5
	AddStaticVehicle(596,1544.9795,-1655.1194,5.6118,269.7381,0,1); // PD car 6
	AddStaticVehicle(596,1545.2738,-1650.8409,5.6079,268.8639,0,1); // PD car 7
	AddStaticVehicle(596,1564.4762,-1713.1947,5.6106,90.1474,0,1); // PD car 8
	AddStaticVehicle(596,1564.3260,-1709.4965,5.6115,87.3918,0,1); // PD car 9
	AddStaticVehicle(596,1574.3693,-1711.2539,5.6111,179.7121,0,1); // PD car 10
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

//ZCMD Command processing(Fast Commands)

CMD:carspawner(playerid, params[])
{
	ShowPlayerDialog(playerid, DIALOG_SPAWNERMAIN, DIALOG_STYLE_LIST, "Welcome to the LSPD Vehicle Selector/Spawner by {58AB54}Blunt", "LS-PD Cruiser \nSF-PD Cruiser \nLV-PD Cruiser \nEnforcer \nRanger \nS.W.A.T Riot control tank", "Select", "Close");
	return 1;
}


CMD:gotolspd(playerid, params[])
{
  	SetPlayerPos(playerid, 1568.6295,-1689.9706,6.2188);
  	SetPlayerInterior(playerid, 0);
  	SendClientMessage(playerid, COLOR_GREY, "You have been teleported to the LSPD Room");
	return 1;
}

CMD:arismatics(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
	    SetPlayerSkin(playerid, 108);
	    GivePlayerWeapon(playerid, 30, 500);
	    GivePlayerWeapon(playerid, 23, 500);
	    new string[256], pName[MAX_PLAYER_NAME];
	    GetPlayerName(playerid,pName,MAX_PLAYER_NAME);
	    format(string,sizeof string," Admin %s ~n~ HAS ~b~Ari~y~smat~r~ics!",pName);
	    GameTextForAll(string, 5000, 5);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_RED, "You do not have access or arismatics!");
	}
	return 1;
}


CMD:adminhelp(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		ShowPlayerDialog(playerid, 9999, DIALOG_STYLE_MSGBOX, "Administration Help", "/gotolockerroom - Teleports you to the LSPD Locker room \n /gotolspd - Teleports you to the LSPD Garage \n /arismatics - SUPRISE!", "Select", "Close");
	}
	else
	{
	    new string[256], pName[MAX_PLAYER_NAME];
	    GetPlayerName(playerid,pName,MAX_PLAYER_NAME);
	    format(string,sizeof string,"Player:%s has typed an Admin command /adminhelp and does not have access",pName);
	    SendClientMessageToAll(COLOR_RED,string);
	    SendClientMessage(playerid, COLOR_RED, "You do no have access to this command");
	}
	return 1;
}

CMD:exit(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 4.0, 316.5168,-169.7899,999.6010))
	{
	    SetPlayerPos(playerid, 1568.6074,-1689.9719,6.2188);
	    SetPlayerInterior(playerid, 0);
	}
	return 1;
}

CMD:enter(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 4.0, 1568.6074,-1689.9719,6.2188))
	{
	    SetPlayerPos(playerid, 316.5168,-169.7899,999.6010);
	    GameTextForPlayer(playerid, "~r~Type /exit to get out the room", 5000, 5);
	    SendClientMessage(playerid, COLOR_RED, "[INFO]:{FFFFFF}Head to the counter and type /equipment");
		SetPlayerInterior(playerid, 6);
	}
	return 1;
}

CMD:equipment(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 312.6893,-166.1366,999.6010))
	{
		ShowPlayerDialog(playerid, DIALOG_EQUIPMENT, DIALOG_STYLE_LIST, "Welcome to the Equipment Selection by {58AB54}Blunt", "Pistols \nHeavy weapons \nMelee weapons \nEquipment Suits(Skins) \nDonuts \nGo on duty", "Select", "Exit");
	}
	return 1;
}
//END OF ZCMD

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_SPAWNERMAIN)
	{
		if(response)
		{
			if(listitem == 0)
			{
				AddStaticVehicle(596,1561.4475,-1694.5120,5.6133,182.9121,0,1);
				GameTextForPlayer(playerid, "~b~LSPD Cruiser spawned", 5000, 5);
			}
			if(listitem == 1)
			{
			    AddStaticVehicle(597,1561.4475,-1694.5120,5.6133,182.9121,0,1);
			    GameTextForPlayer(playerid, "~b~SFPD Cruiser spawned", 5000, 5);
			}
			if(listitem == 2)
			{
			    AddStaticVehicle(598,1561.4475,-1694.5120,5.6133,182.9121,0,1);
			    GameTextForPlayer(playerid, "~b~LVPD Cruiser spawned", 5000, 5);
			}
			if(listitem == 3)
			{
			    AddStaticVehicle(427,1561.4475,-1694.5120,5.6133,182.9121,0,1);
			    GameTextForPlayer(playerid, "~b~Enforcer spawned", 5000, 5);
			}
			if(listitem == 4)
			{
			    AddStaticVehicle(599,1561.4475,-1694.5120,5.6133,182.9121,0,1);
			    GameTextForPlayer(playerid, "~b~LSPD Ranger spawned", 5000, 5);
			}
			if(listitem == 5)
			{
			    AddStaticVehicle(601,1561.4475,-1694.5120,5.6133,182.9121,0,1);
			    GameTextForPlayer(playerid, "~b~SWAT Tank spawned", 5000, 5);
			}
		}
		return 1;
	}
	
	if(dialogid == DIALOG_EQUIPMENT)
	{
	    if(response)
	    {
			if(listitem == 0)
			{
			    ShowPlayerDialog(playerid, DIALOG_PISTOLS, DIALOG_STYLE_LIST, "Equipment - Pistols", "Colt. 45 \nColt. 45 w/Silencer \nDesert Eagle \nBack", "Select", "Exit");
			}
			if(listitem == 1)
			{
			    ShowPlayerDialog(playerid, DIALOG_HEAVYWEPS, DIALOG_STYLE_LIST, "Equipment - Heavy weapons", "M4 Carbine \nShotgun \nRifle \nSniper \nMP5 \nBack", "Select", "Exit");
			}
			if(listitem == 2)
			{
			    ShowPlayerDialog(playerid, DIALOG_MELEE, DIALOG_STYLE_LIST, "Equipment - Melee", "Nitestick \nPepper-Spray \nTear Gas \nBack", "Select", "Exit");
			}
			if(listitem == 3)
			{
				ShowPlayerDialog(playerid, DIALOG_CLOTHING, DIALOG_STYLE_LIST, "Equipment - Clothing", "Cadet \nPolice Uniform \nSWAT Uniform \nBack", "Select", "Exit");
				
			}
			if(listitem == 4)
			{
                SetPlayerHealth(playerid, 100);
				SendClientMessage(playerid, COLOR_WHITE, "[INFO]:{AD9797}You have eaten some donuts, your feeling quite bloated");
                ShowPlayerDialog(playerid, DIALOG_EQUIPMENT, DIALOG_STYLE_LIST, "Welcome to the Equipment Selection by {58AB54}Blunt", "Pistols \nHeavy weapons \nMelee weapons \nDonuts \nGo on duty", "Select", "Exit");
			}
			if(listitem == 5)
			{
			    SetPlayerColor(playerid, COLOR_BLUE);
			    new string[256], pName[MAX_PLAYER_NAME];
			    GetPlayerName(playerid,pName,MAX_PLAYER_NAME);
			    format(string,sizeof string,"Police Officer: {FFFFFF}%s is now on duty, listen out for his sirens",pName);
			    SendClientMessageToAll(COLOR_BLUE,string);
			    GetPlayerName(playerid, pName,MAX_PLAYER_NAME);
			    SendClientMessage(playerid, COLOR_BLUE, string);
			    format(string, sizeof string, "**%s quickly grabs his badge and equipment before tapping the duty button**");
			}
	    }
	    return 1;
	}
	
	if(dialogid == DIALOG_PISTOLS)
	{
	    if(response)
	    {
	        if(listitem == 0)
	        {
	            GivePlayerWeapon(playerid, 22, 250);
	            ShowPlayerDialog(playerid, DIALOG_PISTOLS, DIALOG_STYLE_LIST, "Equipment - Pistols", "Colt. 45 \nColt. 45 w/Silencer \nDesert Eagle \nBack", "Select", "Exit");
	        }
	        if(listitem == 1)
	        {
	            GivePlayerWeapon(playerid, 23, 250);
	            ShowPlayerDialog(playerid, DIALOG_PISTOLS, DIALOG_STYLE_LIST, "Equipment - Pistols", "Colt. 45 \nColt. 45 w/Silencer \nDesert Eagle \nBack", "Select", "Exit");
	        }
			if(listitem == 2)
			{
			    GivePlayerWeapon(playerid, 24, 250);
			    ShowPlayerDialog(playerid, DIALOG_PISTOLS, DIALOG_STYLE_LIST, "Equipment - Pistols", "Colt. 45 \nColt. 45 w/Silencer \nDesert Eagle \nBack", "Select", "Exit");
			}
			if(listitem == 3)
			{
			    ShowPlayerDialog(playerid, DIALOG_EQUIPMENT, DIALOG_STYLE_LIST, "Welcome to the Equipment Selection by {58AB54}Blunt", "Pistols \nHeavy weapons \nMelee weapons \nEquipment Suits(Skins) \nDonuts \nGo on duty", "Select", "Exit");
			}
	    }
	    return 1;
	}
	
	if(dialogid == DIALOG_HEAVYWEPS)
	{
	    if(response)
	    {
	        if(listitem == 0)
	        {
	            GivePlayerWeapon(playerid, 31, 400);
	            ShowPlayerDialog(playerid, DIALOG_HEAVYWEPS, DIALOG_STYLE_LIST, "Equipment - Heavy weapons", "M4 Carbine \nShotgun \nRifle \nSniper \nMP5 \nBack", "Select", "Exit");
	        }
	        if(listitem == 1)
	        {
	            GivePlayerWeapon(playerid, 25, 200);
	            ShowPlayerDialog(playerid, DIALOG_HEAVYWEPS, DIALOG_STYLE_LIST, "Equipment - Heavy weapons", "M4 Carbine \nShotgun \nRifle \nSniper \nMP5 \nBack", "Select", "Exit");
	        }
	        if(listitem == 2)
	        {
	            GivePlayerWeapon(playerid, 33, 100);
	            ShowPlayerDialog(playerid, DIALOG_HEAVYWEPS, DIALOG_STYLE_LIST, "Equipment - Heavy weapons", "M4 Carbine \nShotgun \nRifle \nSniper \nMP5 \nBack", "Select", "Exit");
	        }
	        if(listitem == 3)
			{
			    GivePlayerWeapon(playerid, 34, 50);
			    ShowPlayerDialog(playerid, DIALOG_HEAVYWEPS, DIALOG_STYLE_LIST, "Equipment - Heavy weapons", "M4 Carbine \nShotgun \nRifle \nSniper \nMP5 \nBack", "Select", "Exit");
			}
			if(listitem == 4)
			{
			    GivePlayerWeapon(playerid, 29, 500);
			    ShowPlayerDialog(playerid, DIALOG_HEAVYWEPS, DIALOG_STYLE_LIST, "Equipment - Heavy weapons", "M4 Carbine \nShotgun \nRifle \nSniper \nMP5 \nBack", "Select", "Exit");
			}
			if(listitem == 5)
			{
			    ShowPlayerDialog(playerid, DIALOG_EQUIPMENT, DIALOG_STYLE_LIST, "Welcome to the Equipment Selection by {58AB54}Blunt", "Pistols \nHeavy weapons \nMelee weapons \nEquipment Suits(Skins) \nDonuts \nGo on duty", "Select", "Exit");
			}
		}
		return 1;
	}
	
	if(dialogid == DIALOG_MELEE)
	{
	    if(response)
	    {
	        if(listitem == 0)
	        {
	            GivePlayerWeapon(playerid, 3, 1);
	            ShowPlayerDialog(playerid, DIALOG_MELEE, DIALOG_STYLE_LIST, "Equipment - Melee", "Nitestick \nPepper-Spray \nTear Gas \nBack", "Select", "Exit");
	        }
	        if(listitem == 1)
	        {
	            GivePlayerWeapon(playerid, 41, 9999);
	            ShowPlayerDialog(playerid, DIALOG_MELEE, DIALOG_STYLE_LIST, "Equipment - Melee", "Nitestick \nPepper-Spray \nTear Gas \nBack", "Select", "Exit");
	        }
	        if(listitem == 2)
	        {
	            GivePlayerWeapon(playerid, 17, 5);
	            ShowPlayerDialog(playerid, DIALOG_MELEE, DIALOG_STYLE_LIST, "Equipment - Melee", "Nitestick \nPepper-Spray \nTear Gas \nBack", "Select", "Exit");
	        }
	        if(listitem == 3)
	        {
	            ShowPlayerDialog(playerid, DIALOG_EQUIPMENT, DIALOG_STYLE_LIST, "Welcome to the Equipment Selection by {58AB54}Blunt", "Pistols \nHeavy weapons \nMelee weapons \nEquipment Suits(Skins) \nDonuts \nGo on duty", "Select", "Exit");
	        }
	    }
	    return 1;
	}
	
	if(dialogid == DIALOG_CLOTHING)
	{
	    if(response)
	    {
	        if(listitem == 0)
	        {
				SetPlayerSkin(playerid, 71);
				ShowPlayerDialog(playerid, DIALOG_CLOTHING, DIALOG_STYLE_LIST, "Equipment - Clothing", "Cadet \nPolice Uniform \nSWAT Uniform \nBack", "Select", "Exit");
	        }
	        if(listitem == 1)
	        {
	            SetPlayerSkin(playerid, 280);
	            ShowPlayerDialog(playerid, DIALOG_CLOTHING, DIALOG_STYLE_LIST, "Equipment - Clothing", "Cadet \nPolice Uniform \nSWAT Uniform \nBack", "Select", "Exit");
	        }
	        if(listitem == 2)
	        {
	            SetPlayerSkin(playerid, 287);
	            ShowPlayerDialog(playerid, DIALOG_CLOTHING, DIALOG_STYLE_LIST, "Equipment - Clothing", "Cadet \nPolice Uniform \nSWAT Uniform \nBack", "Select", "Exit");
	        }
	        if(listitem == 3)
	        {
	            ShowPlayerDialog(playerid, DIALOG_EQUIPMENT, DIALOG_STYLE_LIST, "Welcome to the Equipment Selection by {58AB54}Blunt", "Pistols \nHeavy weapons \nMelee weapons \nEquipment Suits(Skins) \nDonuts \nGo on duty", "Select", "Exit");
	        }
	    }
	    return 1;
	}
	return 0;
}

