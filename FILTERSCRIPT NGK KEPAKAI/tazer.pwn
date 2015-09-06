//RP TASER SYSTEM BY JUSTLUCA (IVMyLife)
//The "TazerAcceso" variable check if the Taser was ON or OFF. 1 for ON and 0 for OFF.

//===========================[Includes]=========================================
#include <a_samp>
//===========================[Defines]==========================================
#define FILTERSCRIPT
#if defined FILTERSCRIPT
//===========================[New]==============================================
new TazerAcceso[MAX_PLAYERS];

public OnFilterScriptInit()
{
	print("\n-----------------------------------------");
	print(" Taser System by JustLuca (IVMyLife) LOADED");
	print("-------------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
    print("\n--------------------------------------------");
	print(" Taser System by JustLuca (IVMyLife) UNLOADED ");
	print("---------------------------------------------\n");
	return 1;
}

#endif

public OnPlayerConnect(playerid)
{
	TazerAcceso[playerid] = 0;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	TazerAcceso[playerid] = 0;
	return 1;
}

public OnPlayerUpdate(playerid)
{
	if(TazerAcceso[playerid] == 1)
	{
		if(GetPlayerWeapon(playerid) == 0)
		{
		    SetPlayerAttachedObject(playerid, 7, 18642, 6, 0.06, 0.01, 0.08, 180.0, 0.0, 0.0); //Taser
		    return 1;
		}
		if(GetPlayerWeapon(playerid) != 0)
		{
		    RemovePlayerAttachedObject(playerid, 7); //This remove the taser
		    return 1;
		}
	}
	return 1;
}

forward Float:GetDistanceBetweenPlayers(p1,p2);
public Float:GetDistanceBetweenPlayers(p1,p2)
{
	new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
	if(!IsPlayerConnected(p1) || !IsPlayerConnected(p2))
	{
		return -1.00;
	}
	GetPlayerPos(p1,x1,y1,z1);
	GetPlayerPos(p2,x2,y2,z2);
	return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}

forward GetClosestPlayer(p1);
public GetClosestPlayer(p1)
{
	new x,Float:dis,Float:dis2,player;
	player = -1;
	dis = 99999.99;
	for (x=0;x<MAX_PLAYERS;x++)
	{
		if(IsPlayerConnected(x))
		{
			if(x != p1)
			{
				dis2 = GetDistanceBetweenPlayers(x,p1);
				if(dis2 < dis && dis2 != -1.00)
				{
					dis = dis2;
					player = x;
				}
			}
		}
	}
	return player;
}

public OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid)
{
	if(TazerAcceso[playerid] == 1)
	{
 	if(GetPlayerWeapon(playerid) == 0)
    {
 			ApplyAnimation(playerid,"KNIFE", "knife_3", 4.0, 0, 1, 1, 1, 1000);
      		SetTimerEx("TimerClear",2000,false,"d",playerid);
      		new victimid = GetClosestPlayer(playerid);
			if(IsPlayerConnected(victimid))
	     	{
	        	if(GetDistanceBetweenPlayers(playerid,victimid) < 2)
	            {
	            	new Float:health;
	                GetPlayerHealth(victimid, health);
	                SetPlayerHealth(victimid, health - 5.0);
	                SetTimerEx("TimerFall",300,false,"d",victimid);
					TogglePlayerControllable(victimid, 0);
					SetTimerEx("Untaze", 20000, false, "i", victimid);
	             }
	         }
	      }
    }
    return 1;
}

forward Untaze(playerid);
public Untaze(playerid)
{
	SendClientMessage(playerid, -1, "[Info:] You are not more Tased");
	TogglePlayerControllable(playerid, 1);
	return 1;
}

forward TimeClear(playerid);
public TimeClear(playerid)
{
	ClearAnimations(playerid);
}

forward TimerFall(playerid);
public TimerFall(playerid)
{
    ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
    SetTimerEx("TimerClear",19700,false,"d",playerid);
}
forward TimerCrack(playerid);
public TimerCrack(playerid)
{
    ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
    SetTimerEx("TimeClear",19700,false,"d",playerid);
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/tason", cmdtext, true, 8) == 0)
	{
	    if(TazerAcceso[playerid] == 1)
		{
		    SendClientMessage(playerid,-1,"[Info:] Your taser is already on!");
		    return 1;
	    }
	    TazerAcceso[playerid] = 1;
	    SetPlayerAttachedObject(playerid, 7, 18642, 6, 0.06, 0.01, 0.08, 180.0, 0.0, 0.0);
	    SendClientMessage(playerid,-1,"[Info:] Type /tasoff for turn off.");
	    SendClientMessage(playerid,-1,"[Info:] The taser will auto-equip when you select the fists.");
	    SendClientMessage(playerid,-1,"[Info:] For use the taser, you just need to punch with who you want use it.");
		return 1;
	}
	if (strcmp("/tasoff", cmdtext, true, 9) == 0)
	{
        if(TazerAcceso[playerid] == 0)
		{
		    SendClientMessage(playerid,-1,"[Info:] Your taser is already off!");
		    return 1;
	    }
        TazerAcceso[playerid] = 1;
        RemovePlayerAttachedObject(playerid, 7);
	    SendClientMessage(playerid,-1,"[Info:] You turn off your taser, for turn on type /tason .");
	    SendClientMessage(playerid,-1,"[Info:] You turned off your taser! Remember to turn on it.");
		return 1;
	}
	return 0;
}

/*================================================================================================================================
End of the line.
================================================================================================================================*/
