/* 	    Dynamic Business Creator v.1 by Gold!
 * 	With this script, you have the ability to create a business anywhere you like.
 *  You may also set the business name, description, entrance and interior.
 *  You can also enter, exit, lock, sell and buy a business.
 *  You can also store cash in your safe.
 *  If you have any questions, feel free to message me.
 *  EDIT: Updated last at March 17, 2012.
*/

// Includes
#include <a_samp>
#include <dini>

// Variables
new BusinessPickup[MAX_PLAYERS];
new BusinessUser[MAX_PLAYERS];
new Text3D:BusinessLabel[MAX_PLAYERS];

// Is player business owner?
new bool:BusinessOwner[MAX_PLAYERS];

// Is player setting up business entrance?
new bool:SettingUpEntrance[MAX_PLAYERS];

// Is player setting up business?
new bool:IsSettingUpBusiness[MAX_PLAYERS];

// Has player already setup?
new bool:HasAlreadySetupName[MAX_PLAYERS];
new bool:HasAlreadySetupDesc[MAX_PLAYERS];
new bool:HasAlreadySetupEntrance[MAX_PLAYERS];
new bool:HasAlreadySetupInterior[MAX_PLAYERS];

// Dialogs
#define DIALOG_CREATEBIZ 750
#define DIALOG_CREATEBIZDIALOG 751
#define DIALOG_CORDS 752
#define DIALOG_NAME 753
#define DIALOG_DESCRIPTION 754
#define DIALOG_INTERIOR 755
#define DIALOG_BCANCEL 756
#define DIALOG_STORECASH 757
#define DIALOG_TAKECASH 758
#define DIALOG_UPGRADE 759
#define DIALOG_UPGRADENAME 760
#define DIALOG_UPGRADEDESCRIPTION 761
#define DIALOG_UPGRADEENTRECE 762
#define DIALOG_UPGRADEINERIOR 763

// Approve status.
new bool:IsApprovalPending[MAX_PLAYERS];

// Used later on to store the information into the business variables.
enum SetupBusiness
{
	SetupName[24],
	SetupDesc[32],
	SetupOwner[24],
	SetupPrice,
	Float:SetupPX,
	Float:SetupPY,
	Float:SetupPZ,
	Float:SetupTX,
	Float:SetupTY,
	Float:SetupTZ,
	Float:SetupTA,
	SetupInt,
	SetupVir
};
new SetupBusinessInfo[MAX_PLAYERS][SetupBusiness];

// The business enum, contains a lot of business shit.
enum Business
{
	Name[64],
	Desc[64],
	Owner[24],
	Price,
	Float:PX,
	Float:PY,
	Float:PZ,
	Float:TX,
	Float:TY,
	Float:TZ,
	Float:TA,
	Cash,
	Int,
	Vir,
	Locked
};
new BusinessInfo[14][Business];

// Called when a player disconnects.
public OnPlayerDisconnect(playerid)
{
    for(new b = 0; b < sizeof(BusinessInfo); b++)
	{
    	new pname[MAX_PLAYER_NAME], file[100];
   	 	GetPlayerName(playerid, pname, sizeof(pname));
		format(file, sizeof(file), "Businesses/%s.ini", pname);
		if(dini_Exists(file))
		{
			dini_Set(file, "Owner", pname);
			dini_FloatSet(file, "Pickup X", BusinessInfo[b][PX]);
			dini_FloatSet(file, "Pickup Y", BusinessInfo[b][PY]);
			dini_FloatSet(file, "Pickup Z", BusinessInfo[b][PZ]);
			dini_FloatSet(file, "Teleport X", BusinessInfo[b][TX]);
			dini_FloatSet(file, "Teleport Y", BusinessInfo[b][TY]);
			dini_FloatSet(file, "Teleport Z", BusinessInfo[b][TZ]);
			dini_FloatSet(file, "Teleport Angle", BusinessInfo[b][TA]);
			dini_IntSet(file, "Price", BusinessInfo[b][Price]);
			dini_IntSet(file, "Interior", BusinessInfo[b][Int]);
			dini_IntSet(file, "Virtual", BusinessInfo[b][Vir]);
			dini_IntSet(file, "Cash", BusinessInfo[b][Cash]);
			DestroyPickup(BusinessPickup[playerid]);
			Delete3DTextLabel(BusinessLabel[playerid]);
			for(new i; i<MAX_PLAYERS; i++)
			{
			    RemovePlayerMapIcon(i, BusinessUser[playerid]);
   			}
			return 1;
		}
	}
	return 1;
}

// Called when a player connects.
public OnPlayerConnect(playerid)
{
    for(new b = 0; b < sizeof(BusinessInfo); b++)
	{
    	new pname[MAX_PLAYER_NAME];
		new name[256], desc[256];
		new file[100], str[128];
    	GetPlayerName(playerid, pname, sizeof(pname));
		format(file, sizeof(file), "Businesses/%s.ini", pname);
		if(dini_Exists(file))
		{
			name = dini_Get(file, "Name");
			desc = dini_Get(file, "Description");
			BusinessInfo[b][Owner] = pname;
			BusinessInfo[b][Price] = dini_Int(file, "Price");
			BusinessInfo[b][PX] = dini_Float(file, "Pickup X");
			BusinessInfo[b][PY] = dini_Float(file, "Pickup Y");
			BusinessInfo[b][PZ] = dini_Float(file, "Pickup Z");
			BusinessInfo[b][TX] = dini_Float(file, "Teleport X");
			BusinessInfo[b][TY] = dini_Float(file, "Teleport Y");
			BusinessInfo[b][TZ] = dini_Float(file, "Teleport Z");
			BusinessInfo[b][TA] = dini_Float(file, "Teleport Angle");
			BusinessInfo[b][Int] = dini_Int(file, "Interior");
			BusinessInfo[b][Vir] = dini_Int(file, "Virtual");
			BusinessInfo[b][Cash] = dini_Int(file, "Cash");
			format(str, sizeof(str), "[Business]\nName: %s\nDescription: %s\nOwner: %s", name, desc, pname);
			BusinessLabel[playerid] = Create3DTextLabel(str, 0xF97804FF, BusinessInfo[b][PX], BusinessInfo[b][PY], BusinessInfo[b][PZ], 20.0, 0);
			BusinessOwner[playerid] = true;
			BusinessPickup[playerid] = CreatePickup(1274, 23, BusinessInfo[b][PX], BusinessInfo[b][PY], BusinessInfo[b][PZ]);
			BusinessUser[playerid] = playerid;
			return 1;
		}
	}
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

// Called when a player types a command.
public OnPlayerCommandText(playerid, cmdtext[])
{
    new cmd[128], idx;
	cmd = strtok(cmdtext, idx);
 	if(!strcmp(cmdtext, "/buybusiness", true))
	{ // Buying Business.
		if(BusinessOwner[playerid] == true)
		{
		    if(IsSettingUpBusiness[playerid] == false)
		    {
		    	ShowPlayerDialog(playerid, DIALOG_CREATEBIZ, DIALOG_STYLE_MSGBOX, "Confirmation", "You are about to create your very own business.\n\nPress 'Continue' to start.", "Continue", "Cancel");
  			}
  			else
  			{
  		    	SendClientMessage(playerid, 0xE21F1FFF, "You are already setting up your business.");
  		    	return 1;
    		}
		}
		else
  		{
 			SendClientMessage(playerid, 0xE21F1FFF, "You already own a business.");
  			return 1;
		}
		return 1;
	}
	if(!strcmp(cmdtext, "/businessupgrade", true))
	{
	    if(BusinessOwner[playerid] == true)
		{
	    	ShowPlayerDialog(playerid, DIALOG_UPGRADE, DIALOG_STYLE_LIST, "Business Upgrade", "Upgrade Name\nUpgrade Description\nUpgrade Entrance\nUpgrade Interior", "Select", "Cancel");
	    	return 1;
 		}
 		else
  		{
 			SendClientMessage(playerid, 0xE21F1FFF, "You don't own a business.");
		}
	    return 1;
 	}
	if(!strcmp(cmdtext, "/confirm", true))
	{ // Confirming entrance.
	    if(SettingUpEntrance[playerid] == true)
	    {
	        new str[32], str2[32], str3[32];
	        new Float:X, Float:Y, Float:Z;
	        GetPlayerPos(playerid, X, Y, Z);
	        SetupBusinessInfo[playerid][SetupPX] = X;
			SetupBusinessInfo[playerid][SetupPY] = Y;
			SetupBusinessInfo[playerid][SetupPZ] = Z;
			BusinessPickup[playerid] = CreatePickup(1274, 23, X, Y, Z);
            PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
            SendClientMessage(playerid, 0xFFFF00FF, "You have set your business entrance coordinates to:");
			format(str, sizeof(str), "X: %f", X);
			SendClientMessage(playerid, 0xFFFFFFAA, str);
			format(str2, sizeof(str2), "Y: %f", Y);
			SendClientMessage(playerid, 0xFFFFFFAA, str2);
			format(str3, sizeof(str3), "Z: %f", Z);
			SendClientMessage(playerid, 0xFFFFFFAA, str3);
            ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
            HasAlreadySetupEntrance[playerid] = true;
            return 1;
		}
		return 1;
	}
   	if(!strcmp(cmdtext, "/lockbusiness", true))
	{ // Locking Business.
		for(new h = 0; h < sizeof(BusinessInfo); h++)
		{
		    if(BusinessOwner[playerid] == true)
		    {
		        if(IsPlayerInRangeOfPoint(playerid, 3.0, BusinessInfo[h][PX], BusinessInfo[h][PY], BusinessInfo[h][PZ]))
		        {
					if(BusinessInfo[h][Locked] == 0)
					{
			    		BusinessInfo[h][Locked] = 1;
                		PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
                		GameTextForPlayer(playerid, "~r~Business locked!", 5000, 6);
			    		return 1;
   					}
   					else if(BusinessInfo[h][Locked] == 1)
					{
			    		BusinessInfo[h][Locked] = 0;
			    		PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
                		GameTextForPlayer(playerid, "~g~Business unlocked!", 5000, 6);
                		return 1;
       				}
 					else if(!IsPlayerInRangeOfPoint(playerid, 3.0, BusinessInfo[h][PX], BusinessInfo[h][PY], BusinessInfo[h][PZ]))
 					{
 			    		SendClientMessage(playerid, 0xE21F1FFF, "You are not near your business.");
 			    		return 1;
    				}
  				}
  				else if(BusinessOwner[playerid] == false)
  				{
  			    	SendClientMessage(playerid, 0xE21F1FFF, "You don't own a business.");
  			    	return 1;
	    		}
    		}
   		}
    	return 1;
   	}
   	if(!strcmp(cmdtext, "/enter", true))
	{ // Enter Business.
		for(new h = 0; h < sizeof(BusinessInfo); h++)
		{
  			if(IsPlayerInRangeOfPoint(playerid, 3.0, BusinessInfo[h][PX], BusinessInfo[h][PY], BusinessInfo[h][PZ]))
		    {
		        if(BusinessInfo[h][Locked] == 0)
				{
		        	SetPlayerPos(playerid, BusinessInfo[h][TX], BusinessInfo[h][TY], BusinessInfo[h][TZ]);
		        	SetPlayerFacingAngle(playerid, BusinessInfo[h][TA]);
		        	SetPlayerInterior(playerid, BusinessInfo[h][Int]);
		        	SetPlayerVirtualWorld(playerid, BusinessInfo[h][Vir]);
					return 1;
				}
				else
				{
			    	SendClientMessage(playerid, 0xE12F1FFF, "This business is locked.");
			    	return 1;
				}
			}
			else
			{
  			  	SendClientMessage(playerid, 0xE12F1FFF, "You are not near a business.");
			    return 1;
			}
		}
		return 1;
	}
	if(!strcmp(cmdtext, "/exit", true))
	{ // Exit Business.
		for(new h = 0; h < sizeof(BusinessInfo); h++)
		{
  			if(IsPlayerInRangeOfPoint(playerid, 3.0, BusinessInfo[h][TX], BusinessInfo[h][TY], BusinessInfo[h][TZ]))
		    {
		        SetPlayerPos(playerid, BusinessInfo[h][PX], BusinessInfo[h][PY], BusinessInfo[h][PZ]);
		        SetPlayerFacingAngle(playerid, 0.0);
		        SetPlayerInterior(playerid, 0);
		        SetPlayerVirtualWorld(playerid, 0);
				return 1;
			}
			else
			{
			    SendClientMessage(playerid, 0xE12F1FFF, "You are not in a business.");
			    return 1;
			}
		}
		return 1;
	}
	if(!strcmp(cmdtext, "/sellbusiness", true))
	{ // Sell your Business.
	    for(new h = 0; h < sizeof(BusinessInfo); h++)
		{
	    	if(BusinessOwner[playerid] == true)
	    	{
	        	new str[64];
	        	format(str, sizeof(str), "Congratulations! You have sold your Business for $%i.",BusinessInfo[h][Price]/2);
	        	SendClientMessage(playerid, 0xFFFF00FF, str);
	        	GivePlayerMoney(playerid, BusinessInfo[h][Price]/2);
				BusinessOwner[playerid] = false;
	        	BusinessInfo[h][Name] = 0;
	        	BusinessInfo[h][Desc] = 0;
	        	BusinessInfo[h][Owner] = 0;
	        	BusinessInfo[h][Price] = 0;
	        	BusinessInfo[h][PX] = 0.0;
	        	BusinessInfo[h][PY] = 0.0;
	        	BusinessInfo[h][PZ] = 0.0;
	        	BusinessInfo[h][TX] = 0.0;
	        	BusinessInfo[h][TY] = 0.0;
	        	BusinessInfo[h][TZ] = 0.0;
	        	BusinessInfo[h][TA] = 0.0;
	        	BusinessInfo[h][Int] = 0;
	        	BusinessInfo[h][Vir] = 0;
	        	DestroyPickup(BusinessPickup[playerid]);
				Delete3DTextLabel(BusinessLabel[playerid]);
				new file[100], pName[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pName, 24);
	        	format(file, sizeof(file), "Businesses/%s.ini", pName);
	        	dini_Remove(file);
	        	return 1;
   			}
   			else
   			{
   			    SendClientMessage(playerid, 0xE21F1FFF, "You don't own a Business.");
   			    return 1;
		    }
    	}
   		return 1;
   	}
	if(!strcmp(cmdtext, "/storecash", true))
 	{ // Store cash in Business safe.
	    for(new h = 0; h < sizeof(BusinessInfo); h++)
		{
	    	if(BusinessOwner[playerid] == true)
    		{
    			if(IsPlayerInRangeOfPoint(playerid, 3.0, BusinessInfo[h][TX], BusinessInfo[h][TY], BusinessInfo[h][TZ]))
		    	{
		        	ShowPlayerDialog(playerid, DIALOG_STORECASH, DIALOG_STYLE_INPUT, "Cash", "Please enter an amount you would like to store in your cash box.", "Store", "Cancel");
					return 1;
				}
				else
				{
			   		SendClientMessage(playerid, 0xE12F1FFF, "You are not in a business.");
			    	return 1;
				}
			}
			else
			{
				SendClientMessage(playerid, 0xE12F1FFF, "You don't own a business.");
				return 1;
			}
		}
		return 1;
	}
	if(!strcmp(cmdtext, "/takecash", true))
	{ // Take cash from Business safe.
	    for(new h = 0; h < sizeof(BusinessInfo); h++)
		{
	    	if(BusinessOwner[playerid] == true)
    		{
    			if(IsPlayerInRangeOfPoint(playerid, 3.0, BusinessInfo[h][TX], BusinessInfo[h][TY], BusinessInfo[h][TZ]))
		    	{
		        	ShowPlayerDialog(playerid, DIALOG_TAKECASH, DIALOG_STYLE_INPUT, "Cash", "Please enter an amount you would like to take from your cash box.", "Store", "Cancel");
					return 1;
				}
				else
				{
			   		SendClientMessage(playerid, 0xE12F1FFF, "You are not in a business.");
			    	return 1;
				}
			}
			else
			{
				SendClientMessage(playerid, 0xE12F1FFF, "You don't own a business.");
				return 1;
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/approvebusiness", true) == 0)
	{ // Accepting Business.
    	if(!IsPlayerAdmin(playerid))
        	return SendClientMessage(playerid, 0xFFFFFFAA, "SERVER: Unknown command.");
    	new tmp[128], giveplayerid;
    	tmp = strtok(cmdtext, idx);
    	if(!strlen(tmp)) {
        	SendClientMessage(playerid, 0xE21F1FFF, "USAGE: /approvebusiness [playerid/PartOfName]");
        	return 1;
    	}
    	giveplayerid = ReturnUser(tmp);
    	if(IsPlayerConnected(giveplayerid)) {
        	if(giveplayerid != INVALID_PLAYER_ID) {
            	if(IsApprovalPending[giveplayerid] == true) {
                	new money = GetPlayerMoney(giveplayerid);
                	if(money < SetupBusinessInfo[giveplayerid][SetupPrice])
					{ // Cannot afford, so we'll reset all variables used.
                    	SendClientMessage(giveplayerid, 0xE21F1FFF, "You dont have a enough money.");
                    	IsSettingUpBusiness[giveplayerid] = false; SettingUpEntrance[giveplayerid] = false;
                    	HasAlreadySetupName[giveplayerid] = false; HasAlreadySetupDesc[giveplayerid] = false;
                    	HasAlreadySetupEntrance[giveplayerid] = false; HasAlreadySetupInterior[giveplayerid] = false;
                    	SetupBusinessInfo[giveplayerid][SetupName] = 0; SetupBusinessInfo[giveplayerid][SetupDesc] = 0;
                    	SetupBusinessInfo[giveplayerid][SetupOwner] = 0; SetupBusinessInfo[giveplayerid][SetupPrice] = 0;
                    	SetupBusinessInfo[giveplayerid][SetupPX] = 0.0; SetupBusinessInfo[giveplayerid][SetupPY] = 0.0;
                    	SetupBusinessInfo[giveplayerid][SetupPZ] = 0.0; SetupBusinessInfo[giveplayerid][SetupTX] = 0.0;
                    	SetupBusinessInfo[giveplayerid][SetupTY] = 0.0; SetupBusinessInfo[giveplayerid][SetupTZ] = 0.0;
                    	SetupBusinessInfo[giveplayerid][SetupTA] = 0.0; SetupBusinessInfo[giveplayerid][SetupInt] = 0;
                    	SetupBusinessInfo[giveplayerid][SetupVir] = 0;
						DestroyPickup(BusinessPickup[playerid]);
						Delete3DTextLabel(BusinessLabel[playerid]);
                    	IsApprovalPending[giveplayerid] = false;
                    	PlayerPlaySound(giveplayerid, 1085, 0.0, 0.0, 0.0);
                    	new file[100], pname[24];
                    	GetPlayerName(giveplayerid, pname, 24);
                    	format(file, sizeof(file), "Businesses/%s.ini", pname);
                    	dini_Remove(file);
                    	return 1;
                	}
                	else { // If player can afford Business.
                    	new str[64];
                    	for(new h = 0; h < sizeof(BusinessInfo); h++)
						{ // Store setup data in Business variables.
                        	new str2[128];
                        	BusinessInfo[h][Name] = SetupBusinessInfo[giveplayerid][SetupName];
                        	BusinessInfo[h][Desc] = SetupBusinessInfo[giveplayerid][SetupDesc];
                        	BusinessInfo[h][Owner] = SetupBusinessInfo[giveplayerid][SetupOwner];
                        	BusinessInfo[h][Price] = SetupBusinessInfo[giveplayerid][SetupPrice];
                        	BusinessInfo[h][PX] = SetupBusinessInfo[giveplayerid][SetupPX];
                        	BusinessInfo[h][PY] = SetupBusinessInfo[giveplayerid][SetupPY];
                        	BusinessInfo[h][PZ] = SetupBusinessInfo[giveplayerid][SetupPZ];
                        	BusinessInfo[h][TX] = SetupBusinessInfo[giveplayerid][SetupTX];
                        	BusinessInfo[h][TY] = SetupBusinessInfo[giveplayerid][SetupTY];
                        	BusinessInfo[h][TZ] = SetupBusinessInfo[giveplayerid][SetupTZ];
                        	BusinessInfo[h][TA] = SetupBusinessInfo[giveplayerid][SetupTA];
                        	BusinessInfo[h][Int] = SetupBusinessInfo[giveplayerid][SetupInt];
                        	BusinessInfo[h][Vir] = SetupBusinessInfo[giveplayerid][SetupVir];
                        	BusinessInfo[h][Locked] = 0;
                        	PlayerPlaySound(giveplayerid, 1149, 0.0, 0.0, 0.0);
                        	format(str, sizeof(str), "Congratulations! You have bought a business for $%i.", SetupBusinessInfo[giveplayerid][SetupPrice]);
                        	SendClientMessage(giveplayerid, 0xFFFF00FF, str);
                        	GivePlayerMoney(giveplayerid, -BusinessInfo[h][Price]);
                        	BusinessOwner[giveplayerid] = true;
                        	IsSettingUpBusiness[giveplayerid] = false; SettingUpEntrance[giveplayerid] = false;
                        	HasAlreadySetupName[giveplayerid] = false; HasAlreadySetupDesc[giveplayerid] = false;
                        	HasAlreadySetupEntrance[giveplayerid] = false; HasAlreadySetupInterior[giveplayerid] = false;
                        	SetupBusinessInfo[giveplayerid][SetupName] = 0; SetupBusinessInfo[giveplayerid][SetupDesc] = 0;
                       		SetupBusinessInfo[giveplayerid][SetupOwner] = 0; SetupBusinessInfo[giveplayerid][SetupPrice] = 0;
                        	SetupBusinessInfo[giveplayerid][SetupPX] = 0.0; SetupBusinessInfo[giveplayerid][SetupPY] = 0.0;
                        	SetupBusinessInfo[giveplayerid][SetupPZ] = 0.0; SetupBusinessInfo[giveplayerid][SetupTX] = 0.0;
                        	SetupBusinessInfo[giveplayerid][SetupTY] = 0.0; SetupBusinessInfo[giveplayerid][SetupTZ] = 0.0;
                        	SetupBusinessInfo[giveplayerid][SetupTA] = 0.0; SetupBusinessInfo[giveplayerid][SetupInt] = 0;
                        	SetupBusinessInfo[giveplayerid][SetupVir] = 0;
                        	IsApprovalPending[giveplayerid] = false;
                 	        new pname[MAX_PLAYER_NAME];
                 	        new name[256], desc[256];
	                     	new file[100];
	    					GetPlayerName(giveplayerid, pname, sizeof(pname));
                  	      	format(file, sizeof(file), "Businesses/%s.ini", pname);
                        	name = dini_Get(file, "Name");
                        	desc = dini_Get(file, "Description");
                        	format(str2, sizeof(str2), "[Business]\nName: %s\nDescription: %s\nOwner: %s", name, desc, pname);
                        	BusinessLabel[giveplayerid] = Create3DTextLabel(str2, 0xF97804FF, BusinessInfo[h][PX], BusinessInfo[h][PY], BusinessInfo[h][PZ], 20.0, 0);
                        	return 1;
						}
					}
        		}
    		}
		}
		else
		{
			SendClientMessage(playerid, 0xE21F1FFF, "That player didn't create a business yet!");
		}
		return 1;
	}
	if(strcmp(cmd, "/denybusiness", true) == 0)
	{ // Deny Business.
    	if(!IsPlayerAdmin(playerid))
        	return SendClientMessage(playerid, 0xFFFFFFAA, "SERVER: Unknown command.");
    	new tmp[128], giveplayerid;
    	tmp = strtok(cmdtext, idx);
    	if(!strlen(tmp)) {
        	SendClientMessage(playerid, 0xE21F1FFF, "USAGE: /denybusiness [playerid/PartOfName]");
        	return 1;
    	}
    	giveplayerid = ReturnUser(tmp);
    	if(IsPlayerConnected(giveplayerid)) {
        	if(giveplayerid != INVALID_PLAYER_ID) {
            	if(IsApprovalPending[giveplayerid] == true) {
                    SendClientMessage(giveplayerid, 0xE21F1FFF, "Your business request was denied.");
                    IsSettingUpBusiness[giveplayerid] = false; SettingUpEntrance[giveplayerid] = false;
                    HasAlreadySetupName[giveplayerid] = false; HasAlreadySetupDesc[giveplayerid] = false;
                    HasAlreadySetupEntrance[giveplayerid] = false; HasAlreadySetupInterior[giveplayerid] = false;
                    SetupBusinessInfo[giveplayerid][SetupName] = 0; SetupBusinessInfo[giveplayerid][SetupDesc] = 0;
                    SetupBusinessInfo[giveplayerid][SetupOwner] = 0; SetupBusinessInfo[giveplayerid][SetupPrice] = 0;
                    SetupBusinessInfo[giveplayerid][SetupPX] = 0.0; SetupBusinessInfo[giveplayerid][SetupPY] = 0.0;
                    SetupBusinessInfo[giveplayerid][SetupPZ] = 0.0; SetupBusinessInfo[giveplayerid][SetupTX] = 0.0;
                    SetupBusinessInfo[giveplayerid][SetupTY] = 0.0; SetupBusinessInfo[giveplayerid][SetupTZ] = 0.0;
                    SetupBusinessInfo[giveplayerid][SetupTA] = 0.0; SetupBusinessInfo[giveplayerid][SetupInt] = 0;
                    SetupBusinessInfo[giveplayerid][SetupVir] = 0;
                    IsApprovalPending[giveplayerid] = false;
                   	DestroyPickup(BusinessPickup[giveplayerid]);
                    Delete3DTextLabel(BusinessLabel[giveplayerid]);
                    PlayerPlaySound(giveplayerid, 1085, 0.0, 0.0, 0.0);
                    new file[100], pname[24];
                   	GetPlayerName(giveplayerid, pname, 24);
                    format(file, sizeof(file), "Businesses/%s.ini", pname);
                    dini_Remove(file);
                    return 1;
                }
    		}
		}
		else
		{
			SendClientMessage(playerid, 0xE21F1FFF, "That player didn't create a business yet!");
		}
		return 1;
	}
	return 0;
}

IsNumeric(const string[])
{
	for (new i = 0, j = strlen(string); i < j; i++)
	{
		if (string[i] > '9' || string[i] < '0') return 0;
	}
	return 1;
}

ReturnUser(text[], playerid = INVALID_PLAYER_ID)
{
	new pos = 0;
	while (text[pos] < 0x21) // Strip out leading spaces
	{
		if (text[pos] == 0) return INVALID_PLAYER_ID; // No passed text
		pos++;
	}
	new userid = INVALID_PLAYER_ID;
	if (IsNumeric(text[pos])) // Check whole passed string
	{
		// If they have a numeric name you have a problem (although names are checked on id failure)
		userid = strval(text[pos]);
		if (userid >=0 && userid < MAX_PLAYERS)
		{
			if(!IsPlayerConnected(userid))
			{
				/*if (playerid != INVALID_PLAYER_ID)
				{
					SendClientMessage(playerid, 0xFF0000AA, "User not connected");
				}*/
				userid = INVALID_PLAYER_ID;
			}
			else
			{
				return userid; // A player was found
			}
		}
		/*else
		{
			if (playerid != INVALID_PLAYER_ID)
			{
				SendClientMessage(playerid, 0xFF0000AA, "Invalid user ID");
			}
			userid = INVALID_PLAYER_ID;
		}
		return userid;*/
		// Removed for fallthrough code
	}
	// They entered [part of] a name or the id search failed (check names just incase)
	new len = strlen(text[pos]);
	new count = 0;
	new name[MAX_PLAYER_NAME];
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i))
		{
			GetPlayerName(i, name, sizeof (name));
			if (strcmp(name, text[pos], true, len) == 0) // Check segment of name
			{
				if (len == strlen(name)) // Exact match
				{
					return i; // Return the exact player on an exact match
					// Otherwise if there are two players:
					// Me and MeYou any time you entered Me it would find both
					// And never be able to return just Me's id
				}
				else // Partial match
				{
					count++;
					userid = i;
				}
			}
		}
	}
	if (count != 1)
	{
		if (playerid != INVALID_PLAYER_ID)
		{
			if (count)
			{
				SendClientMessage(playerid, 0xFF0000AA, "Multiple users found, please narrow earch");
			}
			else
			{
				SendClientMessage(playerid, 0xFF0000AA, "No matching user found");
			}
		}
		userid = INVALID_PLAYER_ID;
	}
	return userid; // INVALID_USER_ID for bad return
}

// Called when a player uses the dialogs.
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_CREATEBIZ) // Confirm Business creation.
	{
	    if(response)
	    {
	        new name, pName[MAX_PLAYER_NAME];
	        name = GetPlayerName(playerid, pName, sizeof(pName));
	        ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
	        IsSettingUpBusiness[playerid] = true;
	        SetupBusinessInfo[playerid][SetupOwner] = name;
	        new file[100];
	        format(file, sizeof(file), "Businesses/%s.ini", pName);
	        dini_Create(file);
	        dini_Set(file, "Owner", pName);
	        return 1;
     	}
 	}
	if(dialogid == DIALOG_CREATEBIZDIALOG) // Business setup.
	{
	    if(response)
	    {
	        if(listitem == 0) // Entrance
	        {
	            if(HasAlreadySetupEntrance[playerid] == false)
	            {
	            	ShowPlayerDialog(playerid, DIALOG_CORDS, DIALOG_STYLE_MSGBOX, "Confirm Entrance", "Are you sure you want to mark your current position as the entrance to your business?", "Yes", "No");
					return 1;
				}
				else
				{
					SendClientMessage(playerid, 0xE21F1FFF, "You already setup your entrance!");
					ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
					return 1;
				}
			}
			if(listitem == 1) // Name
			{
			    if(HasAlreadySetupName[playerid] == false)
			    {
			    	ShowPlayerDialog(playerid, DIALOG_NAME, DIALOG_STYLE_INPUT, "Confirm Name", "Please type in the name of your business.\nExample: Family business.", "Confirm", "Cancel");
					return 1;
				}
				else
				{
					SendClientMessage(playerid, 0xE21F1FFF, "You already setup your name!");
					ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
					return 1;
				}
			}
			if(listitem == 2) // Description
			{
			    if(HasAlreadySetupDesc[playerid] == false)
			    {
			    	ShowPlayerDialog(playerid, DIALOG_DESCRIPTION, DIALOG_STYLE_INPUT, "Confirm Description", "Please type in the description of your business.\nExample: My business is the best business ever.", "Confirm", "Cancel");
					return 1;
				}
				else
				{
					SendClientMessage(playerid, 0xE21F1FFF, "You already setup your description!");
					ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
					return 1;
				}
			}
			if(listitem == 3) // Interior
			{
			    if(HasAlreadySetupInterior[playerid] == false)
			    {
			        ShowPlayerDialog(playerid, DIALOG_INTERIOR, DIALOG_STYLE_LIST, "Confirm Interior", "24/7 ($250,000)\nRestaurant ($250,000)\nClub ($250,000)\nCasino ($250,000)\n24/7 (5) ($250,000)\n24/7 (6) ($250,000)\nAmmunation 1 ($350,000)\nAmmunation 2 ($350,000)\nAmmunation 3 ($350,000)", "Buy", "Cancel");
			        return 1;
				}
				else
				{
					SendClientMessage(playerid, 0xE21F1FFF, "You already setup your interior!");
					ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
					return 1;
				}
			}
			if(listitem == 4) // Purchase
			{
			    if(HasAlreadySetupEntrance[playerid] == false)
			    {
			        SendClientMessage(playerid, 0xE21F1FFF, "You didn't setup your entrance yet!");
			        ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
			        return 1;
       			}
       			if(HasAlreadySetupName[playerid] == false)
			    {
			        SendClientMessage(playerid, 0xE21F1FFF, "You didn't setup your name yet!");
			        ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
			        return 1;
       			}
       			if(HasAlreadySetupDesc[playerid] == false)
			    {
			        SendClientMessage(playerid, 0xE21F1FFF, "You didn't setup your description yet!");
			        ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
			        return 1;
       			}
       			if(HasAlreadySetupInterior[playerid] == false)
			    {
			        SendClientMessage(playerid, 0xE21F1FFF, "You didn't setup your interior yet!");
			        ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
			        return 1;
       			}
				ShowPlayerDialog(playerid, 679, DIALOG_STYLE_MSGBOX, "Approval Pending", "You have created a business, but you must wait approval by an Administrator.", "Okay", "Cancel");
				IsApprovalPending[playerid] = true;
				for(new i; i<MAX_PLAYERS; i++)
				{
				    if(IsPlayerAdmin(i))
				    {
				        new str[128], pname[MAX_PLAYER_NAME];
						GetPlayerName(playerid, pname, 24);
				        format(str, sizeof(str), "Business APPROVAL: %s has created a business, check the entrance. (/approveBusiness to approve the business)", pname);
				        SendClientMessage(i, 0x33AA33AA, str);
				        return 1;
      				}
  				}
			}
		}
		else if(!response)
    	{
    		ShowPlayerDialog(playerid, DIALOG_BCANCEL, DIALOG_STYLE_MSGBOX, "Cancel", "Are you sure you want to stop creating your business?", "Yes", "No");
		  	return 1;
 		}
	}
	if(dialogid == DIALOG_CORDS) // Entrance
	{
	    if(response)
	    {
	        new str[32], str2[32], str3[32];
	        new Float:X, Float:Y, Float:Z;
	        GetPlayerPos(playerid, X, Y, Z);
	        SetupBusinessInfo[playerid][SetupPX] = X;
			SetupBusinessInfo[playerid][SetupPY] = Y;
			SetupBusinessInfo[playerid][SetupPZ] = Z;
            PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
            SendClientMessage(playerid, 0xFFFF00FF, "You have set your business entrance coordinates to:");
			format(str, sizeof(str), "X: %f", X);
			SendClientMessage(playerid, 0xFFFFFFAA, str);
			format(str2, sizeof(str2), "Y: %f", Y);
			SendClientMessage(playerid, 0xFFFFFFAA, str2);
			format(str3, sizeof(str3), "Z: %f", Z);
			SendClientMessage(playerid, 0xFFFFFFAA, str3);
            ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
            HasAlreadySetupEntrance[playerid] = true;
            BusinessPickup[playerid] = CreatePickup(1274, 23, X, Y, Z);
            new file[100], pName[MAX_PLAYER_NAME];
			GetPlayerName(playerid, pName, 24);
	        format(file, sizeof(file), "Businesses/%s.ini", pName);
	        dini_FloatSet(file, "Pickup X", X);
	        dini_FloatSet(file, "Pickup Y", Y);
	        dini_FloatSet(file, "Pickup Z", Z);
            return 1;
   		}
   		else
   		{
   		    SettingUpEntrance[playerid] = true;
			SendClientMessage(playerid, 0xFFFF00FF, "Stand in the position you want your business entrance at.");
			SendClientMessage(playerid, 0xFFFFFFAA, "HINT: When done, type /confirm.");
			return 1;
		}
	}
	if(dialogid == DIALOG_NAME) // Name
	{
	    if(response)
	    {
	        new str[64];
			if(strlen(inputtext) < 1) return ShowPlayerDialog(playerid, DIALOG_NAME, DIALOG_STYLE_INPUT, "Confirm Name", "Please type in the name of your business.\nExample: Family business.", "Confirm", "Cancel");
			if(strlen(inputtext) > 24) return  ShowPlayerDialog(playerid, DIALOG_NAME, DIALOG_STYLE_INPUT, "Confirm Name", "Please type in the name of your business.\nExample: Family business.", "Confirm", "Cancel");
	        SetupBusinessInfo[playerid][SetupName] = strlen(inputtext);
	        SendClientMessage(playerid, 0xFFFF00FF, "You have set your business name to:");
	        format(str, sizeof(str), "%s", inputtext);
	        SendClientMessage(playerid, 0xFFFFFFAA, str);
	        ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
	        PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
	        HasAlreadySetupName[playerid] = true;
	        new file[100], pName[MAX_PLAYER_NAME];
			GetPlayerName(playerid, pName, 24);
	        format(file, sizeof(file), "Businesses/%s.ini", pName);
	        dini_Set(file, "Name", inputtext);
	        return 1;
   		}
		else
		{
		    ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
		    return 1;
  		}
	}
	if(dialogid == DIALOG_DESCRIPTION) // Description
	{
	    if(response)
	    {
	        new str[64];
			if(strlen(inputtext) < 1) return ShowPlayerDialog(playerid, DIALOG_DESCRIPTION, DIALOG_STYLE_INPUT, "Confirm Description", "Please type in the description of your business.\nExample: My business is the best business ever.", "Confirm", "Cancel");
			if(strlen(inputtext) > 32) return ShowPlayerDialog(playerid, DIALOG_DESCRIPTION, DIALOG_STYLE_INPUT, "Confirm Description", "Please type in the description of your business.\nExample: My business is the best business ever.", "Confirm", "Cancel");
	        SetupBusinessInfo[playerid][SetupDesc] = strlen(inputtext);
	        SendClientMessage(playerid, 0xFFFF00FF, "You have set your business description to:");
	        format(str, sizeof(str), "%s", inputtext);
	        SendClientMessage(playerid, 0xFFFFFFAA, str);
	        ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
	        PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
	        HasAlreadySetupDesc[playerid] = true;
	        new file[100], pName[MAX_PLAYER_NAME];
			GetPlayerName(playerid, pName, 24);
	        format(file, sizeof(file), "Businesses/%s.ini", pName);
	        dini_Set(file, "Description", inputtext);
	        return 1;
   		}
		else
		{
		    ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
		    return 1;
  		}
	}
	if(dialogid == DIALOG_INTERIOR) // Interior
	{
	    if(response)
	    {
	        if(!response) { ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel"); return 1; }
	        if(listitem == 0)
	        {
	            new randvir = 2 + random(1999999);
				new str[64];
				SetupBusinessInfo[playerid][SetupPrice] += 250000;
				SetupBusinessInfo[playerid][SetupTX] = -25.884498;
				SetupBusinessInfo[playerid][SetupTY] = -185.868988;
				SetupBusinessInfo[playerid][SetupTZ] = 1003.546875;
				SetupBusinessInfo[playerid][SetupTA] = 0.0;
				SetupBusinessInfo[playerid][SetupInt] = 17;
				SetupBusinessInfo[playerid][SetupVir] = randvir;
				SendClientMessage(playerid, 0xFFFF00FF, "You have set your business interior to:");
				SendClientMessage(playerid, 0xFFFFFFAA, "24/7");
				format(str, sizeof(str), "Price: $%d", SetupBusinessInfo[playerid][SetupPrice]);
				SendClientMessage(playerid, 0xFFFFFFAA, str);
				ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
				PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
				HasAlreadySetupInterior[playerid] = true;
				new file[100], pName[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pName, 24);
	        	format(file, sizeof(file), "Businesses/%s.ini", pName);
	        	dini_IntSet(file, "Price", SetupBusinessInfo[playerid][SetupPrice]);
	        	dini_FloatSet(file, "Teleport X", SetupBusinessInfo[playerid][SetupTX]);
	        	dini_FloatSet(file, "Teleport Y", SetupBusinessInfo[playerid][SetupTY]);
	        	dini_FloatSet(file, "Teleport Z", SetupBusinessInfo[playerid][SetupTZ]);
	        	dini_FloatSet(file, "Teleport Angle", SetupBusinessInfo[playerid][SetupTA]);
                dini_IntSet(file, "Interior", 17);
                dini_IntSet(file, "Virtual", randvir);
				return 1;
			}
			if(listitem == 1)
	        {
	            new randvir = 2 + random(1999999);
				new str[64];
				SetupBusinessInfo[playerid][SetupPrice] += 250000;
				SetupBusinessInfo[playerid][SetupTX] = 372.3520;
				SetupBusinessInfo[playerid][SetupTY] = -131.6510;
				SetupBusinessInfo[playerid][SetupTZ] = 1001.4922;
				SetupBusinessInfo[playerid][SetupTA] = 0.0;
				SetupBusinessInfo[playerid][SetupInt] = 5;
				SetupBusinessInfo[playerid][SetupVir] = randvir;
				SendClientMessage(playerid, 0xFFFF00FF, "You have set your business interior to:");
				SendClientMessage(playerid, 0xFFFFFFAA, "Restaurant");
				format(str, sizeof(str), "Price: $%d", SetupBusinessInfo[playerid][SetupPrice]);
				SendClientMessage(playerid, 0xFFFFFFAA, str);
				ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
				PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
				HasAlreadySetupInterior[playerid] = true;
				new file[100], pName[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pName, 24);
	        	format(file, sizeof(file), "Businesses/%s.ini", pName);
	        	dini_IntSet(file, "Price", SetupBusinessInfo[playerid][SetupPrice]);
	        	dini_FloatSet(file, "Teleport X", SetupBusinessInfo[playerid][SetupTX]);
	        	dini_FloatSet(file, "Teleport Y", SetupBusinessInfo[playerid][SetupTY]);
	        	dini_FloatSet(file, "Teleport Z", SetupBusinessInfo[playerid][SetupTZ]);
	        	dini_FloatSet(file, "Teleport Angle", SetupBusinessInfo[playerid][SetupTA]);
                dini_IntSet(file, "Interior", 10);
                dini_IntSet(file, "Virtual", randvir);
				return 1;
			}
			if(listitem == 2)
	        {
	            new randvir = 2 + random(1999999);
				new str[64];
				SetupBusinessInfo[playerid][SetupPrice] += 10000;
				SetupBusinessInfo[playerid][SetupTX] = 1204.9326;
				SetupBusinessInfo[playerid][SetupTY] = -8.1650;
				SetupBusinessInfo[playerid][SetupTZ] = 1000.9219;
				SetupBusinessInfo[playerid][SetupTA] = 0.0;
				SetupBusinessInfo[playerid][SetupInt] = 2;
				SetupBusinessInfo[playerid][SetupVir] = randvir;
				SendClientMessage(playerid, 0xFFFF00FF, "You have set your business interior to:");
				SendClientMessage(playerid, 0xFFFFFFAA, "Club");
				format(str, sizeof(str), "Price: $%d", SetupBusinessInfo[playerid][SetupPrice]);
				SendClientMessage(playerid, 0xFFFFFFAA, str);
				ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
				PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
				HasAlreadySetupInterior[playerid] = true;
				new file[100], pName[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pName, 24);
	        	format(file, sizeof(file), "Businesses/%s.ini", pName);
	        	dini_IntSet(file, "Price", SetupBusinessInfo[playerid][SetupPrice]);
	        	dini_FloatSet(file, "Teleport X", SetupBusinessInfo[playerid][SetupTX]);
	        	dini_FloatSet(file, "Teleport Y", SetupBusinessInfo[playerid][SetupTY]);
	        	dini_FloatSet(file, "Teleport Z", SetupBusinessInfo[playerid][SetupTZ]);
	        	dini_FloatSet(file, "Teleport Angle", SetupBusinessInfo[playerid][SetupTA]);
                dini_IntSet(file, "Interior", 18);
                dini_IntSet(file, "Virtual", randvir);
				return 1;
			}
			if(listitem == 3)
	        {
	            new randvir = 2 + random(1999999);
				new str[64];
				SetupBusinessInfo[playerid][SetupPrice] += 250000;
				SetupBusinessInfo[playerid][SetupTX] = 2016.2699;
				SetupBusinessInfo[playerid][SetupTY] = 1017.7790;
				SetupBusinessInfo[playerid][SetupTZ] = 996.8750;
				SetupBusinessInfo[playerid][SetupTA] = 0.0;
				SetupBusinessInfo[playerid][SetupInt] = 10;
				SetupBusinessInfo[playerid][SetupVir] = randvir;
				SendClientMessage(playerid, 0xFFFF00FF, "You have set your business interior to:");
				SendClientMessage(playerid, 0xFFFFFFAA, "Casino");
				format(str, sizeof(str), "Price: $%d", SetupBusinessInfo[playerid][SetupPrice]);
				SendClientMessage(playerid, 0xFFFFFFAA, str);
				ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
				PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
				HasAlreadySetupInterior[playerid] = true;
				new file[100], pName[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pName, 24);
	        	format(file, sizeof(file), "Businesses/%s.ini", pName);
	        	dini_IntSet(file, "Price", SetupBusinessInfo[playerid][SetupPrice]);
	        	dini_FloatSet(file, "Teleport X", SetupBusinessInfo[playerid][SetupTX]);
	        	dini_FloatSet(file, "Teleport Y", SetupBusinessInfo[playerid][SetupTY]);
	        	dini_FloatSet(file, "Teleport Z", SetupBusinessInfo[playerid][SetupTZ]);
	        	dini_FloatSet(file, "Teleport Angle", SetupBusinessInfo[playerid][SetupTA]);
                dini_IntSet(file, "Interior", 16);
                dini_IntSet(file, "Virtual", randvir);
				return 1;
			}
			if(listitem == 4)
	        {
	            new randvir = 2 + random(1999999);
				new str[64];
				SetupBusinessInfo[playerid][SetupPrice] += 250000;
				SetupBusinessInfo[playerid][SetupTX] = -27.312300;
				SetupBusinessInfo[playerid][SetupTY] = -29.277599;
				SetupBusinessInfo[playerid][SetupTZ] = 1003.549988;
				SetupBusinessInfo[playerid][SetupTA] = 0.0;
				SetupBusinessInfo[playerid][SetupInt] = 4;
				SetupBusinessInfo[playerid][SetupVir] = randvir;
				SendClientMessage(playerid, 0xFFFF00FF, "You have set your business interior to:");
				SendClientMessage(playerid, 0xFFFFFFAA, "24/7 (5)");
				format(str, sizeof(str), "Price: $%d", SetupBusinessInfo[playerid][SetupPrice]);
				SendClientMessage(playerid, 0xFFFFFFAA, str);
				ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
				PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
				HasAlreadySetupInterior[playerid] = true;
				new file[100], pName[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pName, 24);
	        	format(file, sizeof(file), "Businesses/%s.ini", pName);
	        	dini_IntSet(file, "Price", SetupBusinessInfo[playerid][SetupPrice]);
	        	dini_FloatSet(file, "Teleport X", SetupBusinessInfo[playerid][SetupTX]);
	        	dini_FloatSet(file, "Teleport Y", SetupBusinessInfo[playerid][SetupTY]);
	        	dini_FloatSet(file, "Teleport Z", SetupBusinessInfo[playerid][SetupTZ]);
	        	dini_FloatSet(file, "Teleport Angle", SetupBusinessInfo[playerid][SetupTA]);
                dini_IntSet(file, "Interior", 4);
                dini_IntSet(file, "Virtual", randvir);
				return 1;
			}
			if(listitem == 5)
	        {
	            new randvir = 2 + random(1999999);
				new str[64];
				SetupBusinessInfo[playerid][SetupPrice] += 250000;
				SetupBusinessInfo[playerid][SetupTX] = -26.691599;
				SetupBusinessInfo[playerid][SetupTY] = -55.714897;
				SetupBusinessInfo[playerid][SetupTZ] = 1003.549988;
				SetupBusinessInfo[playerid][SetupTA] = 0.0;
				SetupBusinessInfo[playerid][SetupInt] = 6;
				SetupBusinessInfo[playerid][SetupVir] = randvir;
				SendClientMessage(playerid, 0xFFFF00FF, "You have set your business interior to:");
				SendClientMessage(playerid, 0xFFFFFFAA, "24/7 (6)");
				format(str, sizeof(str), "Price: $%d", SetupBusinessInfo[playerid][SetupPrice]);
				SendClientMessage(playerid, 0xFFFFFFAA, str);
				ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
				PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
				HasAlreadySetupInterior[playerid] = true;
				new file[100], pName[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pName, 24);
	        	format(file, sizeof(file), "Businesses/%s.ini", pName);
	        	dini_IntSet(file, "Price", SetupBusinessInfo[playerid][SetupPrice]);
	        	dini_FloatSet(file, "Teleport X", SetupBusinessInfo[playerid][SetupTX]);
	        	dini_FloatSet(file, "Teleport Y", SetupBusinessInfo[playerid][SetupTY]);
	        	dini_FloatSet(file, "Teleport Z", SetupBusinessInfo[playerid][SetupTZ]);
	        	dini_FloatSet(file, "Teleport Angle", SetupBusinessInfo[playerid][SetupTA]);
                dini_IntSet(file, "Interior", 6);
                dini_IntSet(file, "Virtual", randvir);
				return 1;
			}
			if(listitem == 6)
	        {
	            new randvir = 2 + random(1999999);
				new str[64];
				SetupBusinessInfo[playerid][SetupPrice] += 350000;
				SetupBusinessInfo[playerid][SetupTX] = 286.148987;
				SetupBusinessInfo[playerid][SetupTY] = -40.644398;
				SetupBusinessInfo[playerid][SetupTZ] = 1001.569946;
				SetupBusinessInfo[playerid][SetupTA] = 0.0;
				SetupBusinessInfo[playerid][SetupInt] = 1;
				SetupBusinessInfo[playerid][SetupVir] = randvir;
				SendClientMessage(playerid, 0xFFFF00FF, "You have set your business interior to:");
				SendClientMessage(playerid, 0xFFFFFFAA, "Ammunation 1");
				format(str, sizeof(str), "Price: $%d", SetupBusinessInfo[playerid][SetupPrice]);
				SendClientMessage(playerid, 0xFFFFFFAA, str);
				ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
				PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
				HasAlreadySetupInterior[playerid] = true;
				new file[100], pName[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pName, 24);
	        	format(file, sizeof(file), "Businesses/%s.ini", pName);
	        	dini_IntSet(file, "Price", SetupBusinessInfo[playerid][SetupPrice]);
	        	dini_FloatSet(file, "Teleport X", SetupBusinessInfo[playerid][SetupTX]);
	        	dini_FloatSet(file, "Teleport Y", SetupBusinessInfo[playerid][SetupTY]);
	        	dini_FloatSet(file, "Teleport Z", SetupBusinessInfo[playerid][SetupTZ]);
	        	dini_FloatSet(file, "Teleport Angle", SetupBusinessInfo[playerid][SetupTA]);
                dini_IntSet(file, "Interior", 1);
                dini_IntSet(file, "Virtual", randvir);
				return 1;
			}
			if(listitem == 7)
	        {
	            new randvir = 2 + random(1999999);
				new str[64];
				SetupBusinessInfo[playerid][SetupPrice] += 350000;
				SetupBusinessInfo[playerid][SetupTX] = 286.800995;
				SetupBusinessInfo[playerid][SetupTY] = -82.547600;
				SetupBusinessInfo[playerid][SetupTZ] = 1001.539978;
				SetupBusinessInfo[playerid][SetupTA] = 0.0;
				SetupBusinessInfo[playerid][SetupInt] = 4;
				SetupBusinessInfo[playerid][SetupVir] = randvir;
				SendClientMessage(playerid, 0xFFFF00FF, "You have set your business interior to:");
				SendClientMessage(playerid, 0xFFFFFFAA, "Ammunation 2");
				format(str, sizeof(str), "Price: $%d", SetupBusinessInfo[playerid][SetupPrice]);
				SendClientMessage(playerid, 0xFFFFFFAA, str);
				ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
				PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
				HasAlreadySetupInterior[playerid] = true;
				new file[100], pName[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pName, 24);
	        	format(file, sizeof(file), "Businesses/%s.ini", pName);
	        	dini_IntSet(file, "Price", SetupBusinessInfo[playerid][SetupPrice]);
	        	dini_FloatSet(file, "Teleport X", SetupBusinessInfo[playerid][SetupTX]);
	        	dini_FloatSet(file, "Teleport Y", SetupBusinessInfo[playerid][SetupTY]);
	        	dini_FloatSet(file, "Teleport Z", SetupBusinessInfo[playerid][SetupTZ]);
	        	dini_FloatSet(file, "Teleport Angle", SetupBusinessInfo[playerid][SetupTA]);
                dini_IntSet(file, "Interior", 4);
                dini_IntSet(file, "Virtual", randvir);
				return 1;
			}
			if(listitem == 8)
	        {
	            new randvir = 2 + random(1999999);
				new str[64];
				SetupBusinessInfo[playerid][SetupPrice] += 350000;
				SetupBusinessInfo[playerid][SetupTX] = 296.919983;
				SetupBusinessInfo[playerid][SetupTY] = -108.071999;
				SetupBusinessInfo[playerid][SetupTZ] = 1001.569946;
				SetupBusinessInfo[playerid][SetupTA] = 0.0;
				SetupBusinessInfo[playerid][SetupInt] = 6;
				SetupBusinessInfo[playerid][SetupVir] = randvir;
				SendClientMessage(playerid, 0xFFFF00FF, "You have set your business interior to:");
				SendClientMessage(playerid, 0xFFFFFFAA, "Ammunation 3");
				format(str, sizeof(str), "Price: $%d", SetupBusinessInfo[playerid][SetupPrice]);
				SendClientMessage(playerid, 0xFFFFFFAA, str);
				ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
				PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
				HasAlreadySetupInterior[playerid] = true;
				new file[100], pName[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pName, 24);
	        	format(file, sizeof(file), "Businesses/%s.ini", pName);
	        	dini_IntSet(file, "Price", SetupBusinessInfo[playerid][SetupPrice]);
	        	dini_FloatSet(file, "Teleport X", SetupBusinessInfo[playerid][SetupTX]);
	        	dini_FloatSet(file, "Teleport Y", SetupBusinessInfo[playerid][SetupTY]);
	        	dini_FloatSet(file, "Teleport Z", SetupBusinessInfo[playerid][SetupTZ]);
	        	dini_FloatSet(file, "Teleport Angle", SetupBusinessInfo[playerid][SetupTA]);
                dini_IntSet(file, "Interior", 6);
                dini_IntSet(file, "Virtual", randvir);
				return 1;
			}
		}
		else
		{
		    ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
		    return 1;
  		}
	}
	if(dialogid == DIALOG_BCANCEL) // Business cancellation
 	{
 	    if(response)
 	    {
 	        IsSettingUpBusiness[playerid] = false; SettingUpEntrance[playerid] = false;
			HasAlreadySetupName[playerid] = false; HasAlreadySetupDesc[playerid] = false;
			HasAlreadySetupEntrance[playerid] = false; HasAlreadySetupInterior[playerid] = false;
			SetupBusinessInfo[playerid][SetupName] = 0; SetupBusinessInfo[playerid][SetupDesc] = 0;
			SetupBusinessInfo[playerid][SetupOwner] = 0; SetupBusinessInfo[playerid][SetupPrice] = 0;
			SetupBusinessInfo[playerid][SetupPX] = 0.0; SetupBusinessInfo[playerid][SetupPY] = 0.0;
			SetupBusinessInfo[playerid][SetupPZ] = 0.0; SetupBusinessInfo[playerid][SetupTX] = 0.0;
			SetupBusinessInfo[playerid][SetupTY] = 0.0; SetupBusinessInfo[playerid][SetupTZ] = 0.0;
			SetupBusinessInfo[playerid][SetupTA] = 0.0; SetupBusinessInfo[playerid][SetupInt] = 0;
			SetupBusinessInfo[playerid][SetupVir] = 0;
			DestroyPickup(BusinessPickup[playerid]);
			Delete3DTextLabel(BusinessLabel[playerid]);
			PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
			SendClientMessage(playerid, 0xFFFFFFAA, "You have cancelled creating your business.");
			new file[100], pname[24];
			GetPlayerName(playerid, pname, 24);
			format(file, sizeof(file), "Businesses/%s.ini", pname);
			dini_Remove(file);
			return 1;
		}
		else
		{
		    ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
		    return 1;
  		}
	}
	if(dialogid == DIALOG_STORECASH) // Store cash
	{
	    if(response)
	    {
	    	new str[64];
			for(new h = 0; h < sizeof(BusinessInfo); h++)
			{
	        	new money = strval(inputtext);
	        	new cash = GetPlayerMoney(playerid);
	        	if(cash < money)
					return SendClientMessage(playerid, 0xE21F1FFF, "You don't have that much!");
				if(money < 1 || money < 0 || money < -1)
					return SendClientMessage(playerid, 0xE21F1FFF, "You must input an amount above 0.");
				BusinessInfo[h][Cash] += money;
				GivePlayerMoney(playerid, -money);
				format(str, sizeof(str), "You have stored $%i into your safe.",money);
				SendClientMessage(playerid, 0xFFFF00FF, str);
				return 1;
			}
		}
	}
	if(dialogid == DIALOG_TAKECASH) // Take cash
	{
	    if(response)
	    {
	    	new str[64];
			for(new h = 0; h < sizeof(BusinessInfo); h++)
			{
	        	new money = strval(inputtext);
	        	if(BusinessInfo[h][Cash] < money)
					return SendClientMessage(playerid, 0xE21F1FFF, "You don't have that much in your safe!");
				if(money < 1 || money < 0 || money < -1)
					return SendClientMessage(playerid, 0xE21F1FFF, "You must input an amount above 0.");
				BusinessInfo[h][Cash] -= money;
				GivePlayerMoney(playerid, money);
				format(str, sizeof(str), "You have taken $%i from your safe.",money);
				SendClientMessage(playerid, 0xFFFF00FF, str);
				return 1;
			}
		}
	}
	if(dialogid == DIALOG_UPGRADE) // Upgrade
	{
	    if(response)
	    {
			if(listitem == 0) // Name
			{
			    ShowPlayerDialog(playerid, DIALOG_UPGRADENAME, DIALOG_STYLE_INPUT, "Confirm Name", "Please type in the name of your Business.\nExample: Family Business.", "Confirm", "Cancel");
			}
			if(listitem == 1) // Description
			{
			    ShowPlayerDialog(playerid, DIALOG_UPGRADEDESCRIPTION, DIALOG_STYLE_INPUT, "Confirm Description", "Please type in the description of your Business.\nExample: My Business is the best Business ever.", "Confirm", "Cancel");
			}
			if(listitem == 2) // Entrance
	        {
         		ShowPlayerDialog(playerid, DIALOG_UPGRADEENTRECE, DIALOG_STYLE_MSGBOX, "Confirm Entrance", "Are you sure you want to mark your current position as the entrance to your Business?", "Yes", "No");
       		}
			if(listitem == 3) // Interior
			{
				ShowPlayerDialog(playerid, DIALOG_UPGRADEINERIOR, DIALOG_STYLE_LIST, "Confirm Interior", "24/7 (1) ($250,000)\n24/7 (2) ($250,000)\n24/7 (3) ($250,000)\n24/7 (4) ($250,000)\n24/7 (5) ($250,000)\n24/7 (6) ($250,000)\nAmmunation 1 ($350,000)\nAmmunation 2 ($350,000)\nAmmunation 3 ($350,000)", "Buy", "Cancel");
			}
		}
	}
	if(dialogid == DIALOG_UPGRADENAME) // Upgrade Name
	{
	    if(response)
	    {
			for(new h = 0; h < sizeof(BusinessInfo); h++)
			{
	        	new str[64];
				if(strlen(inputtext) < 1) return ShowPlayerDialog(playerid, DIALOG_NAME, DIALOG_STYLE_INPUT, "Confirm Name", "Please type in the name of your business.\nExample: Family business.", "Confirm", "Cancel");
				if(strlen(inputtext) > 24) return  ShowPlayerDialog(playerid, DIALOG_NAME, DIALOG_STYLE_INPUT, "Confirm Name", "Please type in the name of your business.\nExample: Family business.", "Confirm", "Cancel");
	        	BusinessInfo[h][Name] = strlen(inputtext);
	        	SendClientMessage(playerid, 0xFFFF00FF, "You have set your business name to:");
	        	format(str, sizeof(str), "%s", inputtext);
	        	SendClientMessage(playerid, 0xFFFFFFAA, str);
	        	PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
	        	new file[100], pName[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pName, 24);
	        	format(file, sizeof(file), "Businesses/%s.ini", pName);
	        	dini_Set(file, "Name", inputtext);
	        	new pname[MAX_PLAYER_NAME];
				new name[256], desc[256], strr[128];
				DestroyPickup(BusinessPickup[playerid]);
				Delete3DTextLabel(BusinessLabel[playerid]);
    			GetPlayerName(playerid, pname, sizeof(pname));
				name = dini_Get(file, "Name");
				desc = dini_Get(file, "Description");
				format(strr, sizeof(strr), "[Business]\nName: %s\nDescription: %s\nOwner: %s", name, desc, pname);
				BusinessLabel[playerid] = Create3DTextLabel(strr, 0xF97804FF, BusinessInfo[h][PX], BusinessInfo[h][PY], BusinessInfo[h][PZ], 20.0, 0);
				BusinessPickup[playerid] = CreatePickup(1274, 23, BusinessInfo[h][PX], BusinessInfo[h][PY], BusinessInfo[h][PZ]);
	        	return 1;
			}
   		}
	}
	if(dialogid == DIALOG_UPGRADEDESCRIPTION) // Upgrade Desc
	{
	    if(response)
	    {
			for(new h = 0; h < sizeof(BusinessInfo); h++)
			{
	        	new str[64];
				if(strlen(inputtext) < 1) return ShowPlayerDialog(playerid, DIALOG_NAME, DIALOG_STYLE_INPUT, "Confirm Name", "Please type in the name of your business.\nExample: Family business.", "Confirm", "Cancel");
				if(strlen(inputtext) > 24) return  ShowPlayerDialog(playerid, DIALOG_NAME, DIALOG_STYLE_INPUT, "Confirm Name", "Please type in the name of your business.\nExample: Family business.", "Confirm", "Cancel");
	        	BusinessInfo[h][Desc] = strlen(inputtext);
	        	SendClientMessage(playerid, 0xFFFF00FF, "You have set your business description to:");
	        	format(str, sizeof(str), "%s", inputtext);
	        	SendClientMessage(playerid, 0xFFFFFFAA, str);
	        	PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
	        	new file[100], pName[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pName, 24);
	        	format(file, sizeof(file), "Businesses/%s.ini", pName);
	        	dini_Set(file, "Description", inputtext);
	        	new pname[MAX_PLAYER_NAME];
				new name[256], desc[256], strr[128];
				DestroyPickup(BusinessPickup[playerid]);
				Delete3DTextLabel(BusinessLabel[playerid]);
    			GetPlayerName(playerid, pname, sizeof(pname));
				name = dini_Get(file, "Name");
				desc = dini_Get(file, "Description");
				format(strr, sizeof(strr), "[Business]\nName: %s\nDescription: %s\nOwner: %s", name, desc, pname);
				BusinessLabel[playerid] = Create3DTextLabel(strr, 0xF97804FF, BusinessInfo[h][PX], BusinessInfo[h][PY], BusinessInfo[h][PZ], 20.0, 0);
				BusinessPickup[playerid] = CreatePickup(1274, 23, BusinessInfo[h][PX], BusinessInfo[h][PY], BusinessInfo[h][PZ]);
	        	return 1;
			}
   		}
	}
	if(dialogid == DIALOG_UPGRADEENTRECE) // Upgrade Entrance
	{
        if(response)
	    {
	        for(new h = 0; h < sizeof(BusinessInfo); h++)
			{
			    new pname[MAX_PLAYER_NAME], Float:X, Float:Y, Float:Z;
				new name[256], desc[256], file[100], strr[128];
				DestroyPickup(BusinessPickup[playerid]);
				Delete3DTextLabel(BusinessLabel[playerid]);
    			GetPlayerName(playerid, pname, sizeof(pname));
				format(file, sizeof(file), "Businesses/%s.ini", pname);
				name = dini_Get(file, "Name");
				desc = dini_Get(file, "Description");
				format(strr, sizeof(strr), "[Business]\nName: %s\nDescription: %s\nOwner: %s", name, desc, pname);
				new str[32], str2[32], str3[32];
				GetPlayerPos(playerid, X, Y, Z);
            	PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
            	dini_FloatSet(file, "Pickup X", X);
	        	dini_FloatSet(file, "Pickup Y", Y);
	        	dini_FloatSet(file, "Pickup Z", Z);
         		BusinessInfo[h][PX] = X;
	        	BusinessInfo[h][PY] = Y;
	        	BusinessInfo[h][PZ] = Z;
	        	BusinessLabel[playerid] = Create3DTextLabel(strr, 0xF97804FF, BusinessInfo[h][PX], BusinessInfo[h][PY], BusinessInfo[h][PZ], 20.0, 0);
				BusinessPickup[playerid] = CreatePickup(1274, 23, BusinessInfo[h][PX], BusinessInfo[h][PY], BusinessInfo[h][PZ]);
            	SendClientMessage(playerid, 0xFFFF00FF, "You have set your business entrance coordinates to:");
				format(str, sizeof(str), "X: %f", X);
				SendClientMessage(playerid, 0xFFFFFFAA, str);
				format(str2, sizeof(str2), "Y: %f", Y);
				SendClientMessage(playerid, 0xFFFFFFAA, str2);
				format(str3, sizeof(str3), "Z: %f", Z);
				SendClientMessage(playerid, 0xFFFFFFAA, str3);
				return 1;
         	}
   		}
	}
	if(dialogid == DIALOG_UPGRADEINERIOR && response) // Upgrade Interior
	{
	    for(new h = 0; h < sizeof(BusinessInfo); h++)
		{
    		if(listitem == 0)
	        {
	            new randvir = 2 + random(1999999);
				new str[64];
				SetupBusinessInfo[playerid][SetupPrice] += 250000;
				SetupBusinessInfo[playerid][SetupTX] = -25.884498;
				SetupBusinessInfo[playerid][SetupTY] = -185.868988;
				SetupBusinessInfo[playerid][SetupTZ] = 1003.546875;
				SetupBusinessInfo[playerid][SetupTA] = 0.0;
				SetupBusinessInfo[playerid][SetupInt] = 17;
				SetupBusinessInfo[playerid][SetupVir] = randvir;
				SendClientMessage(playerid, 0xFFFF00FF, "You have set your business interior to:");
				SendClientMessage(playerid, 0xFFFFFFAA, "24/7 (1)");
				format(str, sizeof(str), "Price: $%d", SetupBusinessInfo[playerid][SetupPrice]);
				SendClientMessage(playerid, 0xFFFFFFAA, str);
				ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
				PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
				HasAlreadySetupInterior[playerid] = true;
				new file[100], pName[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pName, 24);
	        	format(file, sizeof(file), "Businesses/%s.ini", pName);
	        	dini_IntSet(file, "Price", SetupBusinessInfo[playerid][SetupPrice]);
	        	dini_FloatSet(file, "Teleport X", SetupBusinessInfo[playerid][SetupTX]);
	        	dini_FloatSet(file, "Teleport Y", SetupBusinessInfo[playerid][SetupTY]);
	        	dini_FloatSet(file, "Teleport Z", SetupBusinessInfo[playerid][SetupTZ]);
	        	dini_FloatSet(file, "Teleport Angle", SetupBusinessInfo[playerid][SetupTA]);
                dini_IntSet(file, "Interior", 17);
                dini_IntSet(file, "Virtual", randvir);
				return 1;
			}
			if(listitem == 1)
	        {
	            new randvir = 2 + random(1999999);
				new str[64];
				SetupBusinessInfo[playerid][SetupPrice] += 250000;
				SetupBusinessInfo[playerid][SetupTX] = 6.091180;
				SetupBusinessInfo[playerid][SetupTY] = -29.271898;
				SetupBusinessInfo[playerid][SetupTZ] = 1003.549988;
				SetupBusinessInfo[playerid][SetupTA] = 0.0;
				SetupBusinessInfo[playerid][SetupInt] = 10;
				SetupBusinessInfo[playerid][SetupVir] = randvir;
				SendClientMessage(playerid, 0xFFFF00FF, "You have set your business interior to:");
				SendClientMessage(playerid, 0xFFFFFFAA, "24/7 (2)");
				format(str, sizeof(str), "Price: $%d", SetupBusinessInfo[playerid][SetupPrice]);
				SendClientMessage(playerid, 0xFFFFFFAA, str);
				ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
				PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
				HasAlreadySetupInterior[playerid] = true;
				new file[100], pName[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pName, 24);
	        	format(file, sizeof(file), "Businesses/%s.ini", pName);
	        	dini_IntSet(file, "Price", SetupBusinessInfo[playerid][SetupPrice]);
	        	dini_FloatSet(file, "Teleport X", SetupBusinessInfo[playerid][SetupTX]);
	        	dini_FloatSet(file, "Teleport Y", SetupBusinessInfo[playerid][SetupTY]);
	        	dini_FloatSet(file, "Teleport Z", SetupBusinessInfo[playerid][SetupTZ]);
	        	dini_FloatSet(file, "Teleport Angle", SetupBusinessInfo[playerid][SetupTA]);
                dini_IntSet(file, "Interior", 10);
                dini_IntSet(file, "Virtual", randvir);
				return 1;
			}
			if(listitem == 2)
	        {
	            new randvir = 2 + random(1999999);
				new str[64];
				SetupBusinessInfo[playerid][SetupPrice] += 10000;
				SetupBusinessInfo[playerid][SetupTX] = -30.946699;
				SetupBusinessInfo[playerid][SetupTY] = -89.609596;
				SetupBusinessInfo[playerid][SetupTZ] = 1003.549988;
				SetupBusinessInfo[playerid][SetupTA] = 0.0;
				SetupBusinessInfo[playerid][SetupInt] = 18;
				SetupBusinessInfo[playerid][SetupVir] = randvir;
				SendClientMessage(playerid, 0xFFFF00FF, "You have set your business interior to:");
				SendClientMessage(playerid, 0xFFFFFFAA, "24/7 (3)");
				format(str, sizeof(str), "Price: $%d", SetupBusinessInfo[playerid][SetupPrice]);
				SendClientMessage(playerid, 0xFFFFFFAA, str);
				ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
				PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
				HasAlreadySetupInterior[playerid] = true;
				new file[100], pName[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pName, 24);
	        	format(file, sizeof(file), "Businesses/%s.ini", pName);
	        	dini_IntSet(file, "Price", SetupBusinessInfo[playerid][SetupPrice]);
	        	dini_FloatSet(file, "Teleport X", SetupBusinessInfo[playerid][SetupTX]);
	        	dini_FloatSet(file, "Teleport Y", SetupBusinessInfo[playerid][SetupTY]);
	        	dini_FloatSet(file, "Teleport Z", SetupBusinessInfo[playerid][SetupTZ]);
	        	dini_FloatSet(file, "Teleport Angle", SetupBusinessInfo[playerid][SetupTA]);
                dini_IntSet(file, "Interior", 18);
                dini_IntSet(file, "Virtual", randvir);
				return 1;
			}
			if(listitem == 3)
	        {
	            new randvir = 2 + random(1999999);
				new str[64];
				SetupBusinessInfo[playerid][SetupPrice] += 250000;
				SetupBusinessInfo[playerid][SetupTX] = -25.132599;
				SetupBusinessInfo[playerid][SetupTY] = -139.066986;
				SetupBusinessInfo[playerid][SetupTZ] = 1003.549988;
				SetupBusinessInfo[playerid][SetupTA] = 0.0;
				SetupBusinessInfo[playerid][SetupInt] = 16;
				SetupBusinessInfo[playerid][SetupVir] = randvir;
				SendClientMessage(playerid, 0xFFFF00FF, "You have set your business interior to:");
				SendClientMessage(playerid, 0xFFFFFFAA, "24/7 (4)");
				format(str, sizeof(str), "Price: $%d", SetupBusinessInfo[playerid][SetupPrice]);
				SendClientMessage(playerid, 0xFFFFFFAA, str);
				ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
				PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
				HasAlreadySetupInterior[playerid] = true;
				new file[100], pName[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pName, 24);
	        	format(file, sizeof(file), "Businesses/%s.ini", pName);
	        	dini_IntSet(file, "Price", SetupBusinessInfo[playerid][SetupPrice]);
	        	dini_FloatSet(file, "Teleport X", SetupBusinessInfo[playerid][SetupTX]);
	        	dini_FloatSet(file, "Teleport Y", SetupBusinessInfo[playerid][SetupTY]);
	        	dini_FloatSet(file, "Teleport Z", SetupBusinessInfo[playerid][SetupTZ]);
	        	dini_FloatSet(file, "Teleport Angle", SetupBusinessInfo[playerid][SetupTA]);
                dini_IntSet(file, "Interior", 16);
                dini_IntSet(file, "Virtual", randvir);
				return 1;
			}
			if(listitem == 4)
	        {
	            new randvir = 2 + random(1999999);
				new str[64];
				SetupBusinessInfo[playerid][SetupPrice] += 250000;
				SetupBusinessInfo[playerid][SetupTX] = -27.312300;
				SetupBusinessInfo[playerid][SetupTY] = -29.277599;
				SetupBusinessInfo[playerid][SetupTZ] = 1003.549988;
				SetupBusinessInfo[playerid][SetupTA] = 0.0;
				SetupBusinessInfo[playerid][SetupInt] = 4;
				SetupBusinessInfo[playerid][SetupVir] = randvir;
				SendClientMessage(playerid, 0xFFFF00FF, "You have set your business interior to:");
				SendClientMessage(playerid, 0xFFFFFFAA, "24/7 (5)");
				format(str, sizeof(str), "Price: $%d", SetupBusinessInfo[playerid][SetupPrice]);
				SendClientMessage(playerid, 0xFFFFFFAA, str);
				ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
				PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
				HasAlreadySetupInterior[playerid] = true;
				new file[100], pName[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pName, 24);
	        	format(file, sizeof(file), "Businesses/%s.ini", pName);
	        	dini_IntSet(file, "Price", SetupBusinessInfo[playerid][SetupPrice]);
	        	dini_FloatSet(file, "Teleport X", SetupBusinessInfo[playerid][SetupTX]);
	        	dini_FloatSet(file, "Teleport Y", SetupBusinessInfo[playerid][SetupTY]);
	        	dini_FloatSet(file, "Teleport Z", SetupBusinessInfo[playerid][SetupTZ]);
	        	dini_FloatSet(file, "Teleport Angle", SetupBusinessInfo[playerid][SetupTA]);
                dini_IntSet(file, "Interior", 4);
                dini_IntSet(file, "Virtual", randvir);
				return 1;
			}
			if(listitem == 5)
	        {
	            new randvir = 2 + random(1999999);
				new str[64];
				SetupBusinessInfo[playerid][SetupPrice] += 250000;
				SetupBusinessInfo[playerid][SetupTX] = -26.691599;
				SetupBusinessInfo[playerid][SetupTY] = -55.714897;
				SetupBusinessInfo[playerid][SetupTZ] = 1003.549988;
				SetupBusinessInfo[playerid][SetupTA] = 0.0;
				SetupBusinessInfo[playerid][SetupInt] = 6;
				SetupBusinessInfo[playerid][SetupVir] = randvir;
				SendClientMessage(playerid, 0xFFFF00FF, "You have set your business interior to:");
				SendClientMessage(playerid, 0xFFFFFFAA, "24/7 (6)");
				format(str, sizeof(str), "Price: $%d", SetupBusinessInfo[playerid][SetupPrice]);
				SendClientMessage(playerid, 0xFFFFFFAA, str);
				ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
				PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
				HasAlreadySetupInterior[playerid] = true;
				new file[100], pName[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pName, 24);
	        	format(file, sizeof(file), "Businesses/%s.ini", pName);
	        	dini_IntSet(file, "Price", SetupBusinessInfo[playerid][SetupPrice]);
	        	dini_FloatSet(file, "Teleport X", SetupBusinessInfo[playerid][SetupTX]);
	        	dini_FloatSet(file, "Teleport Y", SetupBusinessInfo[playerid][SetupTY]);
	        	dini_FloatSet(file, "Teleport Z", SetupBusinessInfo[playerid][SetupTZ]);
	        	dini_FloatSet(file, "Teleport Angle", SetupBusinessInfo[playerid][SetupTA]);
                dini_IntSet(file, "Interior", 6);
                dini_IntSet(file, "Virtual", randvir);
				return 1;
			}
			if(listitem == 6)
	        {
	            new randvir = 2 + random(1999999);
				new str[64];
				SetupBusinessInfo[playerid][SetupPrice] += 350000;
				SetupBusinessInfo[playerid][SetupTX] = 286.148987;
				SetupBusinessInfo[playerid][SetupTY] = -40.644398;
				SetupBusinessInfo[playerid][SetupTZ] = 1001.569946;
				SetupBusinessInfo[playerid][SetupTA] = 0.0;
				SetupBusinessInfo[playerid][SetupInt] = 1;
				SetupBusinessInfo[playerid][SetupVir] = randvir;
				SendClientMessage(playerid, 0xFFFF00FF, "You have set your business interior to:");
				SendClientMessage(playerid, 0xFFFFFFAA, "Ammunation 1");
				format(str, sizeof(str), "Price: $%d", SetupBusinessInfo[playerid][SetupPrice]);
				SendClientMessage(playerid, 0xFFFFFFAA, str);
				ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
				PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
				HasAlreadySetupInterior[playerid] = true;
				new file[100], pName[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pName, 24);
	        	format(file, sizeof(file), "Businesses/%s.ini", pName);
	        	dini_IntSet(file, "Price", SetupBusinessInfo[playerid][SetupPrice]);
	        	dini_FloatSet(file, "Teleport X", SetupBusinessInfo[playerid][SetupTX]);
	        	dini_FloatSet(file, "Teleport Y", SetupBusinessInfo[playerid][SetupTY]);
	        	dini_FloatSet(file, "Teleport Z", SetupBusinessInfo[playerid][SetupTZ]);
	        	dini_FloatSet(file, "Teleport Angle", SetupBusinessInfo[playerid][SetupTA]);
                dini_IntSet(file, "Interior", 1);
                dini_IntSet(file, "Virtual", randvir);
				return 1;
			}
			if(listitem == 7)
	        {
	            new randvir = 2 + random(1999999);
				new str[64];
				SetupBusinessInfo[playerid][SetupPrice] += 350000;
				SetupBusinessInfo[playerid][SetupTX] = 286.800995;
				SetupBusinessInfo[playerid][SetupTY] = -82.547600;
				SetupBusinessInfo[playerid][SetupTZ] = 1001.539978;
				SetupBusinessInfo[playerid][SetupTA] = 0.0;
				SetupBusinessInfo[playerid][SetupInt] = 4;
				SetupBusinessInfo[playerid][SetupVir] = randvir;
				SendClientMessage(playerid, 0xFFFF00FF, "You have set your business interior to:");
				SendClientMessage(playerid, 0xFFFFFFAA, "Ammunation 2");
				format(str, sizeof(str), "Price: $%d", SetupBusinessInfo[playerid][SetupPrice]);
				SendClientMessage(playerid, 0xFFFFFFAA, str);
				ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
				PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
				HasAlreadySetupInterior[playerid] = true;
				new file[100], pName[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pName, 24);
	        	format(file, sizeof(file), "Businesses/%s.ini", pName);
	        	dini_IntSet(file, "Price", SetupBusinessInfo[playerid][SetupPrice]);
	        	dini_FloatSet(file, "Teleport X", SetupBusinessInfo[playerid][SetupTX]);
	        	dini_FloatSet(file, "Teleport Y", SetupBusinessInfo[playerid][SetupTY]);
	        	dini_FloatSet(file, "Teleport Z", SetupBusinessInfo[playerid][SetupTZ]);
	        	dini_FloatSet(file, "Teleport Angle", SetupBusinessInfo[playerid][SetupTA]);
                dini_IntSet(file, "Interior", 4);
                dini_IntSet(file, "Virtual", randvir);
				return 1;
			}
			if(listitem == 8)
	        {
	            new randvir = 2 + random(1999999);
				new str[64];
				SetupBusinessInfo[playerid][SetupPrice] += 350000;
				SetupBusinessInfo[playerid][SetupTX] = 296.919983;
				SetupBusinessInfo[playerid][SetupTY] = -108.071999;
				SetupBusinessInfo[playerid][SetupTZ] = 1001.569946;
				SetupBusinessInfo[playerid][SetupTA] = 0.0;
				SetupBusinessInfo[playerid][SetupInt] = 6;
				SetupBusinessInfo[playerid][SetupVir] = randvir;
				SendClientMessage(playerid, 0xFFFF00FF, "You have set your business interior to:");
				SendClientMessage(playerid, 0xFFFFFFAA, "Ammunation 3");
				format(str, sizeof(str), "Price: $%d", SetupBusinessInfo[playerid][SetupPrice]);
				SendClientMessage(playerid, 0xFFFFFFAA, str);
				ShowPlayerDialog(playerid, DIALOG_CREATEBIZDIALOG, DIALOG_STYLE_LIST, "Business Setup", "Entrance\nName\nDescription\nInterior\nPurchase", "Select", "Cancel");
				PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
				HasAlreadySetupInterior[playerid] = true;
				new file[100], pName[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pName, 24);
	        	format(file, sizeof(file), "Businesses/%s.ini", pName);
	        	dini_IntSet(file, "Price", SetupBusinessInfo[playerid][SetupPrice]);
	        	dini_FloatSet(file, "Teleport X", SetupBusinessInfo[playerid][SetupTX]);
	        	dini_FloatSet(file, "Teleport Y", SetupBusinessInfo[playerid][SetupTY]);
	        	dini_FloatSet(file, "Teleport Z", SetupBusinessInfo[playerid][SetupTZ]);
	        	dini_FloatSet(file, "Teleport Angle", SetupBusinessInfo[playerid][SetupTA]);
                dini_IntSet(file, "Interior", 6);
                dini_IntSet(file, "Virtual", randvir);
				return 1;
			}
		}
	}
	return 1;
}
