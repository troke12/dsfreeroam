#include <a_samp>
#include <sscanf2>
#include <zcmd>
#include <OPSP>

#define SCM SendClientMessage
#define GREY 0xAFAFAFAA
#define PURPLE 0xC2A2DAAA

new BigEar[MAX_PLAYERS],tazetimer[MAX_PLAYERS], pCuffed[MAX_PLAYERS], cufftimer[MAX_PLAYERS], Dragging[MAX_PLAYERS], Dragged[MAX_PLAYERS], draggedtimer[MAX_PLAYERS], pTazed[MAX_PLAYERS], Tazer[MAX_PLAYERS];
/*==============================================================================
-------------------------------------Cuff--------------------------------------
==============================================================================*/

cmd(cuff, playerid, params[])
{

	new ID, string[20+MAX_PLAYER_NAME];
	if(sscanf(params, "u", ID)) return SendClientMessage(playerid, GREY, "CMD:/cuff [playerid]");
	if(pTazed[ID] == 0) return SendClientMessage(playerid, GREY, "You will have to taze this player before cuffing him");
	if(ID == playerid) return SendClientMessage(playerid, GREY, "You cannot cuff/uncuff your self");
	if(pCuffed[ID] == 0)
	{
		pCuffed[ID] = 1;
		format(string, sizeof(string), "%s has been cuffed by %s.", RemoveUnderScore(ID),RemoveUnderScore(playerid));
		cufftimer[ID] = SetTimerEx("UnCuff", 500000, 0, "d", ID);
		ProxDetector(30.0, playerid, string, PURPLE,PURPLE,PURPLE,PURPLE,PURPLE);
		TogglePlayerControllable(ID, false);
		ClearAnimations(ID);
		KillTimer(tazetimer[ID]);
		pTazed[ID] = 0;
	}
	else
	{
		pCuffed[ID] = 0;
		KillTimer(cufftimer[ID]);
		format(string, sizeof(string), "%s has been uncuffed by %s.", RemoveUnderScore(ID), RemoveUnderScore(playerid));
		ProxDetector(30.0, playerid, string, PURPLE,PURPLE,PURPLE,PURPLE,PURPLE);
		TogglePlayerControllable(ID, true);
	}
	return 1;
}

forward UnCuff(playerid);
public UnCuff(playerid)
{
	pCuffed[playerid] = 0;
    TogglePlayerControllable(playerid, true);
    SendClientMessage(playerid, PURPLE, "Your cuffs broke, run!");
	Dragged[playerid] = 0;
	KillTimer(draggedtimer[playerid]);
}

/*==============================================================================
--------------------------------------Drag--------------------------------------
==============================================================================*/

cmd(drag, playerid, params[])
{
	new ID, string[26+MAX_PLAYER_NAME], string2[20+MAX_PLAYER_NAME];
	if(sscanf(params, "u", ID)) return SendClientMessage(playerid, GREY, "CMD:/cuff [playerid]");
	if(pCuffed[ID] == 0) return SendClientMessage(playerid, GREY, "This player must first be cuffed");
	if(Dragged[ID] == 0 && Dragging[playerid] == 0)
	{
	    Dragged[ID] = 1;
	    Dragging[playerid] = 1;
	    format(string, sizeof(string), "You are being dragged by %s.", RemoveUnderScore(playerid));
	    format(string2, sizeof(string2), " You are dragging %s.", RemoveUnderScore(ID));
	    SCM(playerid, PURPLE, string2);
	    SCM(ID, PURPLE, string);
        draggedtimer[ID] = SetTimerEx("Draggingt", 1000, 1, "dd", playerid,ID);
	}
	else
	{
	    Dragged[ID] = 0;
	    Dragging[playerid] = 0;
	    SCM(playerid, PURPLE, "You have stopped dragging your target.");
	    SCM(ID, PURPLE, "You aren't being dragged anymore.");
	    KillTimer(draggedtimer[ID]);
	}
	return 1;
}

forward Draggingt(playerid, ID);
public Draggingt(playerid, ID)
{
	new Float:dX, Float:dY, Float:dZ;
	GetPlayerPos(playerid, dX, dY, dZ);
	SetPlayerPos(ID, dX+1, dY, dZ);
}



/*==============================================================================
--------------------------------RemoveUnderScore--------------------------------
==============================================================================*/
stock RemoveUnderScore(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid,name,sizeof(name));
    for(new i = 0; i < MAX_PLAYER_NAME; i++)
    {
        if(name[i] == '_') name[i] = ' ';
    }
    return name;
}

//==============================================================================
//---------------------------------PROXDETECTOR---------------------------------
//==============================================================================
stock ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5)
{
	if(IsPlayerConnected(playerid))
	{
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		new invehicle[MAX_PLAYERS];
		new virtualworld = GetPlayerVirtualWorld(playerid);
		new interior = GetPlayerInterior(playerid);
		new vehicleid = GetPlayerVehicleID(playerid);
		new ivehicleid;
		if(vehicleid)
		{
			GetVehiclePos(vehicleid,oldposx,oldposy,oldposz);
		}
		else
		{
			GetPlayerPos(playerid, oldposx, oldposy, oldposz);
			vehicleid = GetPlayerVehicleID(playerid);
		}
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
			    if(!BigEar[i])
			    {
					if(GetPlayerVirtualWorld(i) == virtualworld)
					{
						if((GetPlayerInterior(i) == interior))
						{
						    if(vehicleid)
						    {
							    if(IsPlayerInVehicle(i,vehicleid)) invehicle[i] = 1;
							}
							if(!invehicle[i])
							{
							    if(IsPlayerInAnyVehicle(i))
								{
								    ivehicleid = GetPlayerVehicleID(i);
								    GetVehiclePos(ivehicleid,posx,posy,posz);
								}
								else
								{
					    			GetPlayerPos(i,posx,posy,posz);
								}
								tempposx = (oldposx -posx);
								tempposy = (oldposy -posy);
								tempposz = (oldposz -posz);
								if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16))) SendClientMessage(i, col1, string);
								else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8))) SendClientMessage(i, col2, string);
								else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4))) SendClientMessage(i, col3, string);
								else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2))) SendClientMessage(i, col4, string);
								else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi))) SendClientMessage(i, col5, string);
							}
							else SendClientMessage(i, col1, string);
						}
					}
				}
				else SendClientMessage(i, col1, string);
			}
		}
	}
	return 1;
}

/*==============================================================================
-------------------------------------Tazer--------------------------------------
==============================================================================*/

cmd(tazer, playerid, params[])
{
	new string[28+MAX_PLAYER_NAME];
	if(Tazer[playerid] == 0)
	{
	    GivePlayerWeapon(playerid, 23, 9999);
	    format(string, sizeof(string),"%s has unholstered his tazer.", RemoveUnderScore(playerid));
	    ProxDetector(30.0, playerid, string, PURPLE,PURPLE,PURPLE,PURPLE,PURPLE);
	    Tazer[playerid] = 1;
	}
	else
	{
	    SetPlayerAmmo(playerid, 23, 0);
	    format(string, sizeof(string),"%s has holstered his tazer.", RemoveUnderScore(playerid));
		Tazer[playerid] = 0;
		ProxDetector(30.0, playerid, string, PURPLE,PURPLE,PURPLE,PURPLE,PURPLE);
	}
	return 1;
}

forward Tazed(playerid);
public Tazed(playerid)
{
      pTazed[playerid] = 0;
      TogglePlayerControllable(playerid, true);
      ClearAnimations(playerid);
      return 1;
}

public OnPlayerShootPlayer(Shooter,Target,Float:HealthLost,Float:ArmourLost)
{
	if(GetPlayerWeapon(Shooter) == 23)
	{
 		new string[17+48], playerid;
		TogglePlayerControllable(Target, false);
		ApplyAnimation(Target,"CRACK","crckdeth2",4.1,1,1,1,1,1);
		pTazed[Target] = 1;
		tazetimer[Target] = SetTimerEx("Tazed", 10000, 0, "d", Target);
		format(string, sizeof(string), "%s has been tazed by %s.", RemoveUnderScore(Target), RemoveUnderScore(Shooter));
		ProxDetector(30.0, playerid, string, PURPLE,PURPLE,PURPLE,PURPLE,PURPLE);
	}
    return 1;
}
