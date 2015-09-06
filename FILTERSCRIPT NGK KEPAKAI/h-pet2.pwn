#define FILTERSCRIPT

#include <a_samp>
#include <ZCMD>
#include <OPSP>

new pet;
new cow;
enum
	petslot
{
    one,
	two
};

new rpet[MAX_PLAYERS][petslot];
new veh[MAX_PLAYERS];
new veh2[MAX_PLAYERS];
new Float:xp,Float:yp,Float:zp;

#define COLOR_RED 0xAA3333AA
#define COL_GREEN          "{6EF83C}"

forward hpet(playerid);
forward CowUpdate(playerid);

public hpet(playerid)
{
    new Float:x1,Float:y1,Float:z1,Float:a;
    new vehicleid = GetPlayerVehicleID(playerid);
	if (IsPlayerInAnyVehicle(playerid))
  	{
  	    if(GetPVarInt(playerid,"havepet") == 1)
  	    {
			GetPlayerPos(playerid,x1,y1,z1);
			GetVehicleZAngle(vehicleid,a);
	    	SetObjectRot(rpet[playerid][one], 0.0, 0.0, a);
	        SetObjectRot(rpet[playerid][two], 0.0, 0.0, a);
			MoveObject(rpet[playerid][one],x1,y1 + 3,z1,10000);
		}
		if(GetPVarInt(playerid,"havepets") == 1)
		{
            GetPlayerPos(playerid,x1,y1,z1);
			GetVehicleZAngle(vehicleid,a);
	    	SetObjectRot(rpet[playerid][one], 0.0, 0.0, a);
	        SetObjectRot(rpet[playerid][two], 0.0, 0.0, a);
			MoveObject(rpet[playerid][two],x1,y1 + 3,z1,10000);
		}
	}
	else
	{
	    if(GetPVarInt(playerid,"havepet") == 1)
  	    {
			GetPlayerPos(playerid,x1,y1,z1);
			GetPlayerFacingAngle(playerid,a);
	    	SetObjectRot(rpet[playerid][one], 0.0, 0.0, a);
	        SetObjectRot(rpet[playerid][two], 0.0, 0.0, a);
			MoveObject(rpet[playerid][one],x1,y1 + 3,z1,10000);
		}
        if(GetPVarInt(playerid,"havepets") == 1)
  	    {
            GetPlayerPos(playerid,x1,y1,z1);
			GetPlayerFacingAngle(playerid,a);
	    	SetObjectRot(rpet[playerid][one], 0.0, 0.0, a);
	        SetObjectRot(rpet[playerid][two], 0.0, 0.0, a);
			MoveObject(rpet[playerid][two],x1,y1 + 3,z1,10000);
		}
	}
	return 1;
}
public CowUpdate(playerid)
{
    new Float:x, Float:y, Float:z, Float:a;
    new Keys,ud,lr;
    GetPlayerKeys(playerid,Keys,ud,lr);
    if(ud < 0)
    {
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		SetPlayerPosFindZ(playerid,x + 1*floatcos(90+a, degrees), y+ 1*floatsin(90-a, degrees), z);
        ApplyAnimation(playerid,"LOWRIDER","Sit_relaxed",1000,1,1,1,1,0,1);
	}
	if(ud > 0)
    {
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		SetPlayerPosFindZ(playerid,x - 1*floatcos(90+a, degrees), y- 1*floatsin(90-a, degrees), z);
		ApplyAnimation(playerid,"LOWRIDER","Sit_relaxed",1000,1,1,1,1,0,1);
	}
	if(lr > 0)
	{
	    GetPlayerFacingAngle(playerid, a);
	    SetPlayerFacingAngle(playerid, a-10);
	}
	if(lr < 0)
	{
	    GetPlayerFacingAngle(playerid, a);
	    SetPlayerFacingAngle(playerid, a+10);
	}
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}
public OnPlayerConnect(playerid)
{
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	DestroyObject(rpet[playerid][one]);
    DestroyObject(rpet[playerid][two]);
	DestroyVehicle(veh[playerid]);
	return 1;
}

public OnPlayerSpawn(playerid)
{
    if(GetPVarInt(playerid,"havepets") != 1)
	{
		if(GetPVarInt(playerid,"havepet") != 1)
		{
			if(GetPVarInt(playerid,"havepetss") != 1)
			{
				ShowPlayerDialog(playerid,101,DIALOG_STYLE_LIST,"H-Pet System By Horrible","Turtle\r\nShark\r\nCow","buy", "Cancel");
			}
		}
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
  	switch(dialogid)
 	{
		case 100:
    	{
        	if(!response)
            {
                SendClientMessage(playerid, 0xFF0000FF, "You cancelled.");
                return 1; // We processed it
            }
			else
			{
        	switch(listitem) // This is far more efficient than using an if-elseif-else structure
        	{
                case 0:
                {
                    SendClientMessage(playerid,COLOR_RED,"You Only Can Buy Pet While Respawn");
                    SendClientMessage(playerid,COLOR_RED,"Want to respawn now ? If yes type /respawn if no just ignore this message");
				}
                case 1:
                {
                    if(GetPVarInt(playerid,"havepet") == 1)
				    {
					GivePlayerMoney(playerid, 10000);
				 	SetPVarInt(playerid,"havepet",0);
				  	KillTimer(pet);
				   	DestroyObject(rpet[playerid][one]);
				    DestroyVehicle(veh[playerid]);
					}
					if(GetPVarInt(playerid,"havepets") == 1)
				 	{
				  	GivePlayerMoney(playerid, 10000);
				   	SetPVarInt(playerid,"havepets",0);
				    KillTimer(pet);
				    DestroyObject(rpet[playerid][two]);
				    DestroyVehicle(veh[playerid]);
					}
					if(GetPVarInt(playerid,"havepetss") == 1)
				 	{
				  	GivePlayerMoney(playerid, 10000);
				   	SetPVarInt(playerid,"havepetss",0);
				    KillTimer(cow);
				    RemovePlayerAttachedObject(playerid, 3);
				    ClearAnimations(playerid);
				    ClearAnimations(playerid);
					}
				}
                case 2:
                {
                    new Float:x2,Float:y2,Float:z2,Float:a1;
					new Float:x3,Float:y3;
					if(GetPVarInt(playerid,"havepets") == 1)
				 	{
					GetPlayerPos(playerid,xp,yp,zp);
					DestroyObject(rpet[playerid][one]);
					GetObjectPos(rpet[playerid][two],x2,y2,z2);
					GetObjectRot(rpet[playerid][two],x3,y3,a1);
					rpet[playerid][two] = CreateObject(1608, x2, y2, z2, 0.0, 0.0, a1);
					veh2[playerid] = CreateVehicle(441,x2,y2,z2,a1,1,1,-1);
					AttachObjectToVehicle(rpet[playerid][two],veh2[playerid],0,0,0.8,0,0,0);
					PutPlayerInVehicle( playerid, veh2[playerid], 0 );
					SetVehiclePos(veh2[playerid],xp,yp,zp);
                    AttachObjectToVehicle(rpet[playerid][two],veh2[playerid],0,0,0.8,0,0,0);
					}
					if(GetPVarInt(playerid,"havepet") == 1)
				 	{
                    GetPlayerPos(playerid,xp,yp,zp);
					DestroyObject(rpet[playerid][two]);
					GetObjectPos(rpet[playerid][one],x2,y2,z2);
					GetObjectRot(rpet[playerid][one],x3,y3,a1);
					veh[playerid] = CreateVehicle(441,x2,y2,z2,a1,1,1,-1);
					AttachObjectToVehicle(rpet[playerid][one],veh[playerid],0,0,0,0,0,0);
					PutPlayerInVehicle( playerid, veh[playerid], 0 );
                    SetVehiclePos(veh[playerid],xp,yp,zp);
                    AttachObjectToVehicle(rpet[playerid][one],veh[playerid],0,0,0,0,0,0);
					}
					if(GetPVarInt(playerid,"havepetss") == 1)
				 	{
				 	SendClientMessage(playerid,COLOR_RED,"DONT HIT SOLID OBJECT / BUILDING. IT MIGHT CAUSE YOU BUG UNDERGROUND!");
					SetPlayerAttachedObject(playerid, 3, 16442, 1, -0.635999,0.319998,-0.012999,100.099929,102.400070,1.700000,0.348000,0.387000,0.348000);
				    ApplyAnimation(playerid,"LOWRIDER","Sit_relaxed",1000,1,1,1,1,0,1);
				    ApplyAnimation(playerid,"LOWRIDER","Sit_relaxed",1000,1,1,1,1,0,1);
					cow = SetTimerEx("CowUpdate",100,true,"d",playerid);
					}
					if(GetPVarInt(playerid,"havepets") != 1)
				    {
				    	if(GetPVarInt(playerid,"havepet") != 1)
				    	{
				            if(GetPVarInt(playerid,"havepetss") != 1)
				    		{
							SendClientMessage(playerid,COLOR_RED,"You Dont Have Any Pet");
							}
						}
					}
				}
               	case 3:
                {
                    new Float:x1,Float:y1,Float:z1,Float:a;
				    if(GetPVarInt(playerid,"havepet") == 1)
				 	{
						RemovePlayerFromVehicle(playerid);
						DestroyVehicle(veh[playerid]);
						DestroyObject(rpet[playerid][one]);
						SetPlayerPos(playerid,xp,yp,zp);
				  		GetPlayerFacingAngle(playerid, a);
						GetPlayerPos(playerid,x1,y1,z1);
						rpet[playerid][one] = CreateObject(1609, x1, y1 + 3, z1, 0.0, 0.0, a);
					}
					if(GetPVarInt(playerid,"havepets") == 1)
				 	{
						RemovePlayerFromVehicle(playerid);
						DestroyVehicle(veh2[playerid]);
				        DestroyObject(rpet[playerid][two]);
				        SetPlayerPos(playerid,xp,yp,zp);
				  		GetPlayerFacingAngle(playerid, a);
						GetPlayerPos(playerid,x1,y1,z1);
						rpet[playerid][two] = CreateObject(1608, x1, y1 + 3, z1, 0.0, 0.0, a);
					}
				 	if(GetPVarInt(playerid,"havepetss") == 1)
				  	{
				   		ClearAnimations(playerid);
						SetPlayerAttachedObject(playerid, 3, 16442, 1, -0.756000,0.721999,-1.125000,99.399978,73.700012,0.000000,0.348000,0.387000,0.348000);
				        KillTimer(cow);
					}
					if(GetPVarInt(playerid,"havepets") != 1)
				 	{
				 		if(GetPVarInt(playerid,"havepet") != 1)
						{
							if(GetPVarInt(playerid,"havepetss") != 1)
							{
								SendClientMessage(playerid,COLOR_RED,"You Dont Have Any Pet");
							}
						}
					}
				}
            	case 4:
                {
	                ShowPlayerDialog(playerid,102,DIALOG_STYLE_MSGBOX,#COL_GREEN"H-Pet System By Horrible",#COL_GREEN"Codding : Horribles a.k.a Horrible\r\nInclude: ZCMD : Zeex , OPSP : Wups , Cow object : Hiddos\r\n---------------------------\r\nH-Pet System Help\r\n---------------------------\r\n/Buypet -> to buy a pet \r\n/Sellpet -> to sell your pet\r\n/controlpet -> Ride your pet\r\n/uncontrol -> Unride Your pet","O", "K");
            	}
		}
    }
	}
    case 101:
    {
    	if(!response) return SendClientMessage(playerid, 0xFFFFFFFF, "You canceled!");
        switch(listitem) // This is far more efficient than using an if-elseif-else structure
        {
                case 0:
                {
                    if(GetPVarInt(playerid,"havepet") != 1)
    				{
    				if(GetPlayerMoney(playerid) >= 10000)
					{
					new Float:x1,Float:y1,Float:z1,Float:a;
					SetPVarInt(playerid,"havepet",1);
     				GetPlayerFacingAngle(playerid, a);
					GetPlayerPos(playerid,x1,y1,z1);
					rpet[playerid][one] = CreateObject(1609, x1, y1 + 3, z1, 0.0, 0.0, a);
					pet = SetTimerEx("hpet",100,true,"d",playerid);
					GivePlayerMoney(playerid,-10000);
					}
					}
				}
                case 1:
                {
                    if(GetPVarInt(playerid,"havepets") != 1)
    				{
					if(GetPlayerMoney(playerid) >= 10000)
					{
					new Float:x1,Float:y1,Float:z1,Float:a;
					SetPVarInt(playerid,"havepets",1);
					GetPlayerFacingAngle(playerid, a);
					GetPlayerPos(playerid,x1,y1,z1);
                    rpet[playerid][two] = CreateObject(1608, x1, y1 + 3, z1, 0.0, 0.0, a);
					pet = SetTimerEx("hpet",100,true,"d",playerid);
					GivePlayerMoney(playerid,-10000);
					}
					}
				}
				case 2:
                {
                    if(GetPVarInt(playerid,"havepetss") != 1)
    				{
					if(GetPlayerMoney(playerid) >= 10000)
					{
					SetPVarInt(playerid,"havepetss",1);
				 	SetPlayerAttachedObject(playerid, 3, 16442, 1, -0.756000,0.721999,-1.125000,99.399978,73.700012,0.000000,0.348000,0.387000,0.348000);
					GivePlayerMoney(playerid,-10000);
					}
					}
				}
            }

        }
	}
	return 0;
}
public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
public OnPlayerShootPlayer(Shooter,Target,Float:HealthLost,Float:ArmourLost)
{
	if(GetPVarInt(Shooter,"havepet") == 1)
    {
   	new Float:armour;
	GetPlayerArmour(Target, armour);
	if(armour > 0)
	{
			SetPlayerArmour(Target,armour - 2);
	}
	if(armour < 0)
	{
 			new Float:health;
    		GetPlayerHealth(Target,health);
			SetPlayerHealth(Target,health - 2);
	}
	}
	if(GetPVarInt(Target,"havepet") == 1)
    {
    new Float:armour;
	GetPlayerArmour(Target, armour);
	new Float:health;
	GetPlayerHealth(Target,health);
    if(armour > 0)
	{
			SetPlayerArmour(Target,armour + 2);
	}
	if(armour < 0)
	{
			SetPlayerHealth(Target,health + 2);
	}
	}
	return 1;
}
CMD:uncontrol(playerid,params[])
{
    new Float:x1,Float:y1,Float:z1,Float:a;
    if(GetPVarInt(playerid,"havepet") == 1)
 	{
		RemovePlayerFromVehicle(playerid);
		DestroyVehicle(veh[playerid]);
		DestroyObject(rpet[playerid][one]);
		SetPlayerPos(playerid,xp,yp,zp);
  		GetPlayerFacingAngle(playerid, a);
		GetPlayerPos(playerid,x1,y1,z1);
		rpet[playerid][one] = CreateObject(1609, x1, y1 + 3, z1, 0.0, 0.0, a);
	}
	if(GetPVarInt(playerid,"havepets") == 1)
 	{
		RemovePlayerFromVehicle(playerid);
		DestroyVehicle(veh2[playerid]);
        DestroyObject(rpet[playerid][two]);
        SetPlayerPos(playerid,xp,yp,zp);
  		GetPlayerFacingAngle(playerid, a);
		GetPlayerPos(playerid,x1,y1,z1);
		rpet[playerid][two] = CreateObject(1608, x1, y1 + 3, z1, 0.0, 0.0, a);
	}
 	if(GetPVarInt(playerid,"havepetss") == 1)
  	{
   		ClearAnimations(playerid);
		SetPlayerAttachedObject(playerid, 3, 16442, 1, -0.756000,0.721999,-1.125000,99.399978,73.700012,0.000000,0.348000,0.387000,0.348000);
        KillTimer(cow);
	}
	if(GetPVarInt(playerid,"havepets") != 1)
 	{
 		if(GetPVarInt(playerid,"havepet") != 1)
		{
			if(GetPVarInt(playerid,"havepetss") != 1)
			{
				SendClientMessage(playerid,COLOR_RED,"You Dont Have Any Pet");
			}
		}
	}
	return 1;
}
CMD:controlpet(playerid,params[])
{
					new Float:x2,Float:y2,Float:z2,Float:a1;
					new Float:x3,Float:y3;
					if(GetPVarInt(playerid,"havepets") == 1)
				 	{
					GetPlayerPos(playerid,xp,yp,zp);
					DestroyObject(rpet[playerid][one]);
					GetObjectPos(rpet[playerid][two],x2,y2,z2);
					GetObjectRot(rpet[playerid][two],x3,y3,a1);
					rpet[playerid][two] = CreateObject(1608, x2, y2, z2, 0.0, 0.0, a1);
					veh2[playerid] = CreateVehicle(441,x2,y2,z2,a1,1,1,-1);
					AttachObjectToVehicle(rpet[playerid][two],veh2[playerid],0,0,0.8,0,0,0);
					PutPlayerInVehicle( playerid, veh2[playerid], 0 );
					SetVehiclePos(veh2[playerid],xp,yp,zp);
                    AttachObjectToVehicle(rpet[playerid][two],veh2[playerid],0,0,0.8,0,0,0);
					}
					if(GetPVarInt(playerid,"havepet") == 1)
				 	{
                    GetPlayerPos(playerid,xp,yp,zp);
					DestroyObject(rpet[playerid][two]);
					GetObjectPos(rpet[playerid][one],x2,y2,z2);
					GetObjectRot(rpet[playerid][one],x3,y3,a1);
					veh[playerid] = CreateVehicle(441,x2,y2,z2,a1,1,1,-1);
					AttachObjectToVehicle(rpet[playerid][one],veh[playerid],0,0,0,0,0,0);
					PutPlayerInVehicle( playerid, veh[playerid], 0 );
                    SetVehiclePos(veh[playerid],xp,yp,zp);
                    AttachObjectToVehicle(rpet[playerid][one],veh[playerid],0,0,0,0,0,0);
					}
					if(GetPVarInt(playerid,"havepetss") == 1)
				 	{
				 	SendClientMessage(playerid,COLOR_RED,"DONT HIT SOLID OBJECT / BUILDING. IT MIGHT CAUSE YOU BUG UNDERGROUND!");
					SetPlayerAttachedObject(playerid, 3, 16442, 1, -0.635999,0.319998,-0.012999,100.099929,102.400070,1.700000,0.348000,0.387000,0.348000);
				    ApplyAnimation(playerid,"LOWRIDER","Sit_relaxed",1000,1,1,1,1,0,1);
				    ApplyAnimation(playerid,"LOWRIDER","Sit_relaxed",1000,1,1,1,1,0,1);
					cow = SetTimerEx("CowUpdate",100,true,"d",playerid);
					}
					if(GetPVarInt(playerid,"havepets") != 1)
				    {
				    	if(GetPVarInt(playerid,"havepet") != 1)
				    	{
				            if(GetPVarInt(playerid,"havepetss") != 1)
				    		{
							SendClientMessage(playerid,COLOR_RED,"You Dont Have Any Pet");
							}
						}
					}
					return 1;
}
CMD:petmenu(playerid,params[])
{
	ShowPlayerDialog(playerid,100,DIALOG_STYLE_LIST,#COL_GREEN"H-Pet System By Horrible","Buy Pet\r\nSell Pet\r\nControl Pet\r\nUn-Cotrol Pet\r\nCredits And Help","Ok", "Cancel");
	return 1;
}
CMD:sellpet(playerid,params[])
{
    if(GetPVarInt(playerid,"havepet") == 1)
    {
		GivePlayerMoney(playerid, 10000);
 		SetPVarInt(playerid,"havepet",0);
  		KillTimer(pet);
   		DestroyObject(rpet[playerid][one]);
	    DestroyVehicle(veh[playerid]);
	}
	if(GetPVarInt(playerid,"havepets") == 1)
	{
		GivePlayerMoney(playerid, 10000);
 		SetPVarInt(playerid,"havepets",0);
	    KillTimer(pet);
	    DestroyObject(rpet[playerid][two]);
	    DestroyVehicle(veh[playerid]);
	}
	if(GetPVarInt(playerid,"havepetss") == 1)
	{
		GivePlayerMoney(playerid, 10000);
	   	SetPVarInt(playerid,"havepetss",0);
	    KillTimer(cow);
	    RemovePlayerAttachedObject(playerid, 3);
	    ClearAnimations(playerid);
	    ClearAnimations(playerid);
	}
    return 1;
}
CMD:respawn(playerid,params[])
{
	SetPlayerHealth(playerid,0);
	return 1;
}
