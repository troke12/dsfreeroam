/*
DYNAMIC ORGANIZATIONS FILTERSCRIPT
CODED FROM SCRATCH BY JAKKU
COPYRIGHT (C) 2011 - 2012
RELEASE DATE: 15/12/2011
PLEASE REPORT ALL BUGS (If found) @ SA-MP FORUMS - http://forum.sa-mp.com/showthread.php?t=303864
Feel free to edit this script, but DO NOT REMOVE THE CREDITS! I have used time to code this system and give it to you for FREE!
It isn't much asked to keep the credits in it!
*/



/*
Changelog v.2

- CreateOrganizationZone can be used to create coloured "gangzones" for orgs
- IsPlayerInOrgZone(playerid, orgname)
- SendClientMessageToOrg(orgname, color, message)
- Fixed some small bugs, nothing serious
- Added auto-save for player stats and org. leaders (45sec delay)
- Added /decline command for leaders to decline incoming requests

*/


#include <a_samp>
#include <Dini>
#include <sscanf2>
#include <zcmd>



//Color defines
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_RED 0xFF0000FF
//


#define WAGE 150 //Define the wage here
#define MAX_ORGS 10 //Change only if you need more than 10 orgs
#define MAX_ORG_WEAPONS 3 //Max amount of weapons for orgs
#define ORG_NAME_LENGTH 32 //Max name length for organization and it's leader
#define MAX_ORG_VEHICLES 10
#define MAX_ZONES_PER_ORG 10

#define SAVE_LEADERS_TO "org_leaders.txt"




// Script configuration

#define SPAWN_WITH_ORG_SKIN //Comment this line IF YOU DON'T WANT THE PLAYERS SPAWN WITH ORGANIZATION SKIN!
#define ENABLE_HQ_TELE //Comment this line IF YOU WANT TO DISABLE /teletohq

//


forward PayDay();
forward CheckArea();
forward AutoSave();


new OrgsCount;
new ZoneCount;


enum Orgs
{
Name[32],
Leader[24],
Skin,
Float:X,
Float:Y,
Float:Z,
Weapons[3],
Ammo[3],
Vehicles[MAX_ORG_VEHICLES],
VehiclesCreated,
Text3D:OrgLabel,
Zones[MAX_ZONES_PER_ORG],
Float:ZoneMinX[MAX_ZONES_PER_ORG],
Float:ZoneMinY[MAX_ZONES_PER_ORG],
Float:ZoneMaxX[MAX_ZONES_PER_ORG],
Float:ZoneMaxY[MAX_ZONES_PER_ORG],
ZoneColor[MAX_ZONES_PER_ORG],
ZonesCreated,
};

new Organization[MAX_ORGS][Orgs];

new PlayerOrg[MAX_PLAYERS];
new PlayerLeader[MAX_PLAYERS];
new PlayerRank[MAX_PLAYERS][28];
new Requesting[MAX_PLAYERS];
new CollectedWage[MAX_PLAYERS];


public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print("==Dynamic organization filterscript by Jakku - initialized!==");
	print("==(C) 2011 - 2012==");
	print("--------------------------------------\n");
	

	SetTimer("PayDay",1500000,1); //PayDay every 25 minutes
	SetTimer("CheckArea",1000,1);
	SetTimer("AutoSave",45000,1);

	/*
	
	ALWAYS add your organization BELOW the old one, otherwise the IDs will change = leaders mix up ! ! ! ! !
	
	Syntax for CreateOrganization: CreateOrganization(name[32], skin, Float:x,Float:y,Float:z, wp1,a1,wp2,a2,wp3,a3)
	
	Syntax for CreateOrgVehicle: CreateOrgVehicle(orgname[32], modelid, Float:x,Float:y,Float:z,Float:rotation, color1,color2)
	
	Syntax for CreateOrganizationZone: CreateOrganizationZone(orgname[32], Float:minx,Float:miny,Float:maxx,Float:maxy, color)
	
	*/
	
	//Create ORGS here:
	
	//
	
	//Create ORG VEHICLES here:
	
	//
	
	//Create ORG ZONES here:
	
	//



	LoadLeaders(); //This MUST BE executed AFTER the organizations are being created!
	
	new pcount = 0;
	for (new playerid = 0;playerid<MAX_PLAYERS;playerid++)
	{
	    if (IsPlayerConnected(playerid))
	    {
	    LoadPlayerOrgInfo(playerid);
	    pcount++;
	    }
	}
	if (pcount > 0)
	{
	printf("==Dynamic organization filterscript by Jakku reloaded!==");
	printf("==Data loaded for %d connected players==", pcount);
	}

	return 1;
}


public PayDay()
{
	for (new i=0;i<MAX_PLAYERS;i++)
	{
		if (IsPlayerConnected(i))
		{
			if (PlayerOrg[i] != 0)
			{
			new string[80];
			format(string, sizeof(string),"You have earned from your org. ($%d)", WAGE);
			SendClientMessage(i, COLOR_GREY, string);
			CollectedWage[i]+=WAGE;
			SavePlayerOrgInfo(i);
			}
		}
	}
}

public AutoSave()
{
	for (new i=0;i<MAX_PLAYERS;i++)
	{
		if (IsPlayerConnected(i))
		{
			SavePlayerOrgInfo(i);
		}
	}
	
	SaveLeaders();
}

public CheckArea()
{
	for (new i=0;i<MAX_PLAYERS;i++)
	{
	    if (IsPlayerConnected(i))
	    {
	        new count,name[32];
			for (new c=1;c<OrgsCount+1;c++)
			{
			    if (DoesOrgExist(GetOrgName(c)))
			    {
				    for (new a=1;a<Organization[c][ZonesCreated]+1;a++)
				    {
				        if (IsPlayerInArea(i, Organization[c][ZoneMinX][a],Organization[c][ZoneMinY][a],Organization[c][ZoneMaxX][a],Organization[c][ZoneMaxY][a]))
				        {
				            count++;
				            name = GetOrgName(c);
				        }

 		 			}
				}
			}
			
			if (count != 0)
			{
				if (GetPVarInt(i, "IsInOrgZone") == 0)
				{
				new string[120];
    		    if (PlayerOrg[i] == GetOrgID(name))
				{
				format(string,sizeof(string),"Welcome to your organization's zone!");
				}
				else
				{
				format(string,sizeof(string),"You are now in {5CB3FF}%s's{FFFFFF} zone!", name);
				}
				SendClientMessage(i, COLOR_WHITE, string);
				SetPVarInt(i, "IsInOrgZone", 1);
				return 1;
				}
			}
			else
			{
			SetPVarInt(i, "IsInOrgZone", 0);
			}
	    }
	}
	return 1;
}



public OnFilterScriptExit()
{
	print("Thank you for using Jakku's Dynamic organizations- filterscript");
	print("(C) 2011 - 2012");
	
	for (new i=1;i<OrgsCount+1;i++)
	{
	    for (new a=0;a<MAX_ORG_VEHICLES;a++)
	    {
	        if (IsVehicleConnected(Organization[i][Vehicles][a]))
	        {
	        DestroyVehicle(Organization[i][Vehicles][a]);
	        }
	    }
	    Delete3DTextLabel(Organization[i][OrgLabel]);
	}
	
	for (new playerid = 0;playerid<MAX_PLAYERS;playerid++)
	{
	    if (IsPlayerConnected(playerid))
	    {
	    SavePlayerOrgInfo(playerid);
	    }
	}
	
	SaveLeaders();
	return 1;
}


public OnPlayerConnect(playerid)
{
	PlayerOrg[playerid] = 0; //Resetting player org
	PlayerLeader[playerid] = 0; //Resetting player org leader status
	Requesting[playerid] = 0;
	CollectedWage[playerid] = 0;
	PlayerRank[playerid] = "None";
	
	if(!dini_Exists(PlayerPath(playerid))) //Creating file (check stock PlayerPath(playerid) )
 	{
	SendClientMessage(playerid, COLOR_ORANGE,"As this is your first visit here, we decided to tell you that this server is using Dynamic organization- script by Jakku");
  	dini_Create(PlayerPath(playerid));
	}
	else
	{
	LoadPlayerOrgInfo(playerid);
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	SavePlayerOrgInfo(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if (PlayerOrg[playerid] != 0)
	{
		if (GetPVarInt(playerid, "Dead") == 0)
		{
			new string[160];
			new leader[4];
			if (IsLeader(playerid)) leader = "Yes";
			else leader = "No";
			format(string,sizeof(string),"Organization: {5CB3FF}%s {FFFFFF}|| Leader: {5CB3FF}%s {FFFFFF}|| Rank: {5CB3FF}%s", GetOrgName(PlayerOrg[playerid]), leader, PlayerRank[playerid]);
			SendClientMessage(playerid, COLOR_WHITE, string);
			GiveOrgFeatures(playerid);
		}
	}
	SetPVarInt(playerid, "Dead", 0);
	
	for (new i=1;i<OrgsCount+1;i++)
	{
	    for (new a=1;a<Organization[i][ZonesCreated]+1;a++)
	    {
	        GangZoneShowForPlayer(playerid, Organization[i][Zones][a], Organization[i][ZoneColor][a]);
	    }
	}
	
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
SetPVarInt(playerid, "Dead", 1);
}


public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}



public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}



public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}


public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if (dialogid == 755)
	{
		if (response)
		{
			new string[120];
			format(string,sizeof(string),"You have resigned from %s", Organization[PlayerOrg[playerid]][Name]);
			SendClientMessage(playerid, COLOR_YELLOW, string);
			format(string,sizeof(string),"**%s has resigned from %s", PlayerName(playerid), Organization[PlayerOrg[playerid]][Name]);
			SendClientMessageToAllEx(playerid, COLOR_GREY, string);
			
			if (IsLeader(playerid))
			{
			new none[24];
			format(none,sizeof(none),"None");
			Organization[PlayerOrg[playerid]][Leader] = none;
			}
			ResetPlayerOrg(playerid);
			SavePlayerOrgInfo(playerid);
		}
		else
		{
			SendClientMessage(playerid, COLOR_YELLOW, "Resignation cancelled");
		}
	}

	if (dialogid == 756 && response)
	{
		switch (listitem)
		{
			case 0:
			{
				for (new i=1;i<OrgsCount+1;i++)
				{
					if (IsPlayerInRangeOfPoint(playerid, 3.0, Organization[i][X], Organization[i][Y],Organization[i][Z]))
					{
					new string[140];
					format(string,sizeof(string),"{5CB3FF}Organization: {FFFFFF}%s\n{5CB3FF}Leader: {FFFFFF}%s", GetOrgName(i), Organization[i][Leader]);
					ShowPlayerDialog(playerid, 757, DIALOG_STYLE_MSGBOX, "Organization",string,"Close","");
					return 1;
					}
				}

			}

			case 1:
			{
				if (CollectedWage[playerid] <= 0) return SendClientMessage(playerid, COLOR_RED, "You don't have any wage earned yet!");
				new string[80];
				format(string,sizeof(string),"You have collected $%d", CollectedWage[playerid]);
				SendClientMessage(playerid, COLOR_YELLOW, string);
				GivePlayerMoney(playerid, CollectedWage[playerid]);
				CollectedWage[playerid] = 0;
				SavePlayerOrgInfo(playerid);
			}

		}

	}
	return 1;
}

public OnPlayerStateChange(playerid,newstate,oldstate)
{
    if (newstate == PLAYER_STATE_DRIVER)
    {
	 	for (new i=1;i<OrgsCount+1;i++)
		{
		   for (new a=0;a<MAX_ORG_VEHICLES;a++)
		   {
		        new vehicleid = GetPlayerVehicleID(playerid);
		        if (IsVehicleConnected(vehicleid))
		        {
					if (vehicleid == Organization[i][Vehicles][a] && PlayerOrg[playerid] != i)
					{
						    if (DoesOrgExist(GetOrgName(i)))
						    {
							new string[100];
							format(string,sizeof(string),"This vehicle belongs to %s. You are not authorized to use it", GetOrgName(i));
							SendClientMessage(playerid, COLOR_RED, string);
							RemovePlayerFromVehicle(playerid);
							}
						}
				}
		   }
		}
    }

    return 1;
}

stock PlayerName(playerid)
{
  new playername[24];
  GetPlayerName(playerid, playername, 24);
  return playername;
}


stock CreateOrganization(name[32], skin, Float:x,Float:y,Float:z, wp1 = 0,a1 = 0,wp2 = 0,a2 = 0,wp3 = 0,a3 = 0)
{
OrgsCount++;
if (OrgsCount >= MAX_ORGS) return printf("You have exceeded the MAX_ORGS- define! Aborted");
new id = OrgsCount;
Organization[id][Name] = name;
Organization[id][Skin] = skin;
Organization[id][X] = x;
Organization[id][Y] = y;
Organization[id][Z] = z;
Organization[id][Weapons][0] = wp1;
Organization[id][Ammo][0] = a1;
Organization[id][Weapons][1] = wp2;
Organization[id][Ammo][1] = a2;
Organization[id][Weapons][2] = wp3;
Organization[id][Ammo][2] = a3;
printf("Organization created: ID: %d || Name: %s",id, name);
new string[100];
format(string,sizeof(string),"{5CB3FF}HQ:{FFFFFF} %s\nType {5CB3FF}/org{FFFFFF} for more information!",name);
Organization[id][OrgLabel] = Create3DTextLabel(string, 0x008080FF, x, y, z, 25.0, 0);
return 1;
}

stock PlayerPath(playerid)
{
new path[45];
format(path, sizeof(path),"Orginfo_%s.ini", PlayerName(playerid));
return path;
}

stock SaveLeaders()
{
	new part[40];
	if (!dini_Exists(SAVE_LEADERS_TO))
	{
	dini_Create(SAVE_LEADERS_TO);
	}

	for (new i=1;i<OrgsCount+1;i++)
	{
	format(part,sizeof(part),"%d", i);
	dini_Set(SAVE_LEADERS_TO,part,Organization[i][Leader]);
	}
}

stock LoadLeaders()
{
	new part[24];
	new part2[40];

	if (!dini_Exists(SAVE_LEADERS_TO))
	{
		for (new i=1;i<OrgsCount+1;i++)
		{
		dini_Create(SAVE_LEADERS_TO);
		format(part,sizeof(part),"None");
		Organization[i][Leader] = part;
		SaveLeaders();
		}
		return 1;
	}

	for (new i=1;i<OrgsCount+1;i++)
	{
	format(part2,sizeof(part2),"%d", i);
	format(part,sizeof(part),dini_Get(SAVE_LEADERS_TO,part2));
	
	if (strcmp(part," ", false) == 0)
	{
	part = "None";
	}
	
    Organization[i][Leader] = part;
	}

	return 1;
	}

stock SavePlayerOrgInfo(playerid)
{

if (!dini_Exists(PlayerPath(playerid)))
{
dini_Create(PlayerPath(playerid));
}
//dini_Set(savef,"ContactName1",ContactNames[0][playerid]);
dini_Set(PlayerPath(playerid),"Org",Organization[PlayerOrg[playerid]][Name]);
dini_Set(PlayerPath(playerid),"Rank",PlayerRank[playerid]);
dini_IntSet(PlayerPath(playerid),"CollectedWage",CollectedWage[playerid]);
}

stock LoadPlayerOrgInfo(playerid)
{
new string[45];
format(string,sizeof(string),"%s",dini_Get(PlayerPath(playerid),"Org"));
PlayerOrg[playerid] = GetOrgID(string);
new string2[28];
format(string2,sizeof(string2),"%s",dini_Get(PlayerPath(playerid),"Rank"));
PlayerRank[playerid] = string2;
CollectedWage[playerid] = dini_Int(PlayerPath(playerid), "CollectedWage");

if (strcmp(Organization[PlayerOrg[playerid]][Leader], PlayerName(playerid),true) == 0 && PlayerOrg[playerid] != 0)
{
PlayerLeader[playerid] = 1;
}

}

stock GiveOrgFeatures(playerid)
{
	new org = PlayerOrg[playerid];
	if (!org) return 1;
	GivePlayerWeapon(playerid, Organization[org][Weapons][0],Organization[org][Ammo][0]);
	GivePlayerWeapon(playerid, Organization[org][Weapons][1],Organization[org][Ammo][1]);
	GivePlayerWeapon(playerid, Organization[org][Weapons][2],Organization[org][Ammo][2]);
	#if defined SPAWN_WITH_ORG_SKIN
	SetPlayerSkin(playerid, Organization[org][Skin]);
	#endif
	return 1;
}

stock GetOrgName(orgid)
{
new name[32];
format(name,sizeof(name),"%s",Organization[orgid][Name]);
if (orgid == 0) format(name,sizeof(name),"None");
return name;
}




stock SendClientMessageToAllEx(exception, clr, const message[])
{
    for(new i; i<MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
 	{
	    if(i != exception)
	    {
	        SendClientMessage(i, clr, message);
	    }
	}
    }
}

stock ResetPlayerOrg(playerid)
{
if (PlayerOrg[playerid] == 0) return 1;
printf("%s has been removed from %s", PlayerName(playerid), GetOrgName(PlayerOrg[playerid]));
SetPlayerSkin(playerid, 0);
ResetPlayerWeapons(playerid);
PlayerOrg[playerid] = 0;
Requesting[playerid] = 0;
PlayerLeader[playerid] = 0;
return 1;
}


CMD:resign(playerid, params[])
{
#pragma unused params
if (PlayerOrg[playerid] == 0) return SendClientMessage(playerid, COLOR_RED, "You are not a member of an organization");
ShowPlayerDialog(playerid, 755, DIALOG_STYLE_MSGBOX, "{FFFFFF}Are you sure you want to resign?","{FFFFFF}Please {00FF00}confirm {FFFFFF}your resignation request","Resign","Cancel");
return 1;
}


CMD:ochat(playerid, params[])
{
if (PlayerOrg[playerid] == 0) return SendClientMessage(playerid, COLOR_RED,"You are not a member of an organization");
new text[100];
if (sscanf(params, "s[100]", text)) return SendClientMessage(playerid,COLOR_WHITE,"Usage: /ochat [message]");
new org = PlayerOrg[playerid];
new string[128];
format(string,sizeof(string),"{5CB3FF}(Org Chat) {FFFFFF}(%s): %s", PlayerName(playerid), text);
SendClientMessageToOrg(GetOrgName(org), COLOR_WHITE, string);
return 1;
}

CMD:teletohq(playerid, params[])
{
#pragma unused params

	#if defined ENABLE_HQ_TELE
	if (PlayerOrg[playerid] == 0) return SendClientMessage(playerid, COLOR_RED,"You are not a member of an organization");
	
	if (IsPlayerInRangeOfPoint(playerid, 10.0,Organization[PlayerOrg[playerid]][X],Organization[PlayerOrg[playerid]][Y],Organization[PlayerOrg[playerid]][Z]))
	{
    SendClientMessage(playerid, COLOR_RED,"You are already close to your HQ!");
	return 1;
	}
	
	SetPlayerPos(playerid, Organization[PlayerOrg[playerid]][X],Organization[PlayerOrg[playerid]][Y],Organization[PlayerOrg[playerid]][Z]);
	SendClientMessage(playerid, COLOR_YELLOW,"You have teleported to your HQ");
	
	#else
	SendClientMessage(playerid, COLOR_RED,"This feature has been disabled");
	#endif

return 1;
}


CMD:ovrespawn(playerid, params[])
{
#pragma unused params
if (!IsLeader(playerid)) return SendClientMessage(playerid, COLOR_RED,"You are not the leader of an organization!");
new org = PlayerOrg[playerid];
if (Organization[org][VehiclesCreated] <= 0) return SendClientMessage(playerid, COLOR_RED,"There are no vehicles created for your org!");
SendClientMessage(playerid, COLOR_YELLOW,"You have respawned your org. vehicles!");

for (new i=0;i<MAX_ORG_VEHICLES;i++)
{
	if (IsVehicleConnected(Organization[org][Vehicles][i]))
	{
	SetVehicleToRespawn(Organization[org][Vehicles][i]);
	}
}

return 1;
}

CMD:org(playerid, params[])
{
#pragma unused params

	for (new i=1;i<OrgsCount+1;i++)
	{
		if (IsPlayerInRangeOfPoint(playerid, 3.0, Organization[i][X],Organization[i][Y],Organization[i][Z]))
		{
		new string[35];
		new string2[80];
		format(string, sizeof(string),"%s", GetOrgName(i));
		format(string2, sizeof(string2),"Information");
		if (PlayerOrg[playerid] == i) format(string2, sizeof(string2),"Information\nCollect Wage");
		ShowPlayerDialog(playerid, 756, DIALOG_STYLE_LIST, string,string2,"Ok","Cancel");
		return 1;
		}
	}
	SendClientMessage(playerid, COLOR_RED,"You are not close enough to an organization!");
	return 1;
}

CMD:setmember(playerid, params[])
{
if (!IsLeader(playerid)) return SendClientMessage(playerid,COLOR_RED,"You are not the leader of an organization");
new ID;
if (sscanf(params, "u", ID)) return SendClientMessage(playerid,COLOR_WHITE,"Usage: /setmember [playerid]");
if (!IsPlayerConnected(ID) || ID == playerid) return 1;
new org = PlayerOrg[playerid];
if (PlayerOrg[ID]) return SendClientMessage(playerid, COLOR_RED,"That player already belongs to an organization");
if (Requesting[ID] != org) return SendClientMessage(playerid, COLOR_RED,"That player is not requesting to join your organization!");
new string[120];
format(string,sizeof(string),"%s has set you as a member of %s", PlayerName(playerid), GetOrgName(org));
SendClientMessage(ID, COLOR_YELLOW, string);
format(string,sizeof(string),"You have set %s a member of %s", PlayerName(ID), GetOrgName(org));
SendClientMessage(playerid, COLOR_YELLOW, string);
PlayerOrg[ID] = org;
GiveOrgFeatures(ID);
Requesting[ID] = 0;
return 1;
}

CMD:setleader(playerid, params[])
{
if (!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,COLOR_RED,"You must be logged into RCON to use this command!");
new ID,orgid;
if (sscanf(params, "ud", ID,orgid)) return SendClientMessage(playerid,COLOR_WHITE,"Usage: /setleader [playerid] [orgid]");
if (!IsPlayerConnected(ID)) return 1;
if (PlayerOrg[ID]) return SendClientMessage(playerid, COLOR_RED,"That player already belongs to an organization");
if (orgid < 1 || orgid > OrgsCount) return SendClientMessage(playerid, COLOR_RED,"Invalid org. ID!");
new string[140];
format(string,sizeof(string),"An admin %s has set you as the leader of %s", PlayerName(playerid), GetOrgName(orgid));
SendClientMessage(ID, COLOR_YELLOW, string);
format(string,sizeof(string),"You have set %s the leader of %s", PlayerName(ID), GetOrgName(orgid));
SendClientMessage(playerid, COLOR_YELLOW, string);
PlayerOrg[ID] = orgid;
PlayerLeader[ID] = 1;
Organization[orgid][Leader] = PlayerName(ID);
SaveLeaders();
SavePlayerOrgInfo(ID);
GiveOrgFeatures(ID);
return 1;
}


CMD:setrank(playerid, params[])
{
if (!IsLeader(playerid)) return SendClientMessage(playerid,COLOR_RED,"You are not the leader of an organization");
new ID, rank[28];
if (sscanf(params, "us[28]", ID, rank)) return SendClientMessage(playerid,COLOR_WHITE,"Usage: /setrank [playerid] [rank]");
if (strlen(rank) > 28) return SendClientMessage(playerid, COLOR_RED,"The maximum rank length is 28 characters!");
if (!IsPlayerConnected(ID)) return 1;
new org = PlayerOrg[playerid];
if (PlayerOrg[ID] != org) return SendClientMessage(playerid, COLOR_RED,"That player does not belong to your organization");
new string[120];
format(string,sizeof(string),"Your leader %s has given you a rank: '%s'", PlayerName(playerid), rank);
SendClientMessage(ID, COLOR_YELLOW, string);
format(string,sizeof(string),"You have given a rank to %s (%s)", PlayerName(ID), rank);
SendClientMessage(playerid, COLOR_YELLOW, string);
PlayerRank[ID] = rank;
SavePlayerOrgInfo(ID);
return 1;
}

CMD:kickmember(playerid, params[])
{
if (!IsLeader(playerid)) return SendClientMessage(playerid,COLOR_RED,"You are not the leader of an organization");
new ID;
if (sscanf(params, "u", ID)) return SendClientMessage(playerid,COLOR_WHITE,"Usage: /kickmember [playerid]");
if (!IsPlayerConnected(ID) || ID == playerid) return 1;
new org = PlayerOrg[playerid];
if (PlayerOrg[ID] != org) return SendClientMessage(playerid, COLOR_RED,"That player does not belong to your organization");
new string[130];
format(string,sizeof(string),"%s has kicked you from %s", PlayerName(playerid), GetOrgName(org));
SendClientMessage(ID, COLOR_YELLOW, string);
format(string,sizeof(string),"You have kicked %s from %s", PlayerName(ID), GetOrgName(org));
SendClientMessage(playerid, COLOR_YELLOW, string);
ResetPlayerOrg(ID);
return 1;
}

CMD:request(playerid, params[])
{
if (PlayerOrg[playerid] > 0) return SendClientMessage(playerid, COLOR_RED,"You already belong to an organization!");
if (Requesting[playerid] > 0) return SendClientMessage(playerid, COLOR_RED,"You are already requesting to join an organization!");
new ID;
if (sscanf(params, "d", ID)) return SendClientMessage(playerid,COLOR_WHITE,"Usage: /request [org id]");
if (ID < 1 || ID > OrgsCount) return SendClientMessage(playerid,COLOR_RED,"Invalid organization ID! Type /orglist for a complete list");
if (!IsLeaderOnline(ID)) return SendClientMessage(playerid,COLOR_RED,"The leader of this organization is currently offline!");
new string[120];
format(string,sizeof(string),"%s is requesting to join the %s", PlayerName(playerid), GetOrgName(ID));
SendClientMessageToAllEx(playerid, COLOR_GREY, string);
format(string,sizeof(string),"Your request to %s has been sent", GetOrgName(ID));
SendClientMessage(playerid, COLOR_YELLOW, string);
Requesting[playerid] = ID;
return 1;
}

CMD:decline(playerid, params[])
{
#pragma unused params
if (!IsLeader(playerid)) return SendClientMessage(playerid,COLOR_RED,"You are not the leader of an organization");
new ID;
if (sscanf(params, "u", ID)) return SendClientMessage(playerid,COLOR_WHITE,"Usage: /decline [playerid]");
if (!IsPlayerConnected(ID) || ID == playerid) return 1;
new org = PlayerOrg[playerid];
if (Requesting[ID] != org) return SendClientMessage(playerid, COLOR_RED,"That player is not requesting to join your organization!");
new string[120];
format(string,sizeof(string),"Your request to %s has been declined by %s", GetOrgName(org), PlayerName(playerid));
SendClientMessage(ID, COLOR_GREY, string);
format(string,sizeof(string),"You have successfully declined %s's request", PlayerName(ID));
SendClientMessage(playerid, COLOR_YELLOW, string);
Requesting[ID] = 0;
return 1;
}

CMD:orglist(playerid, params[])
{
#pragma unused params
new string[90];
if (OrgsCount == 0) return SendClientMessage(playerid, COLOR_RED,"Sorry, there are no organizations created at the moment!");
SendClientMessage(playerid, COLOR_WHITE, "Current organizations:");

for (new i=1;i<OrgsCount+1;i++)
{
format(string,sizeof(string),"ID: %d || Name: %s || Leader: %s", i, GetOrgName(i), Organization[i][Leader]);
SendClientMessage(playerid, COLOR_YELLOW, string);
}

return 1;
}

CMD:members(playerid, params[])
{
#pragma unused params
if (!IsLeader(playerid)) return SendClientMessage(playerid, COLOR_RED,"You're not the leader of an organization");
new string[60];
new count = 0;
SendClientMessage(playerid, COLOR_YELLOW,"Employees online");
for (new i=0;i<MAX_PLAYERS;i++)
	{
		if (IsPlayerConnected(i))
		{
		    if (PlayerOrg[i] == PlayerOrg[playerid] && i != playerid)
		    {
			format(string,sizeof(string),"%s - %s", PlayerName(i), PlayerRank[i]);
			SendClientMessage(playerid, COLOR_WHITE, string);
			count++;
		    }
		}
}

if (count == 0)
{
SendClientMessage(playerid, COLOR_YELLOW,"None of your employees are online");
}

	else
	{
	format(string,sizeof(string),"%d member(s) online", count);
	SendClientMessage(playerid, COLOR_WHITE, string);
	}
	
return 1;
}

CMD:myorg(playerid, params[])
{
#pragma unused params
if (PlayerOrg[playerid] == 0) return SendClientMessage(playerid, COLOR_RED,"You are not a member of an organization");
new string[140];
format(string,sizeof(string),"{5CB3FF}Organization: {FFFFFF}%s\n{5CB3FF}Leader: {FFFFFF}%s", GetOrgName(PlayerOrg[playerid]), Organization[PlayerOrg[playerid]][Leader]);
ShowPlayerDialog(playerid, 757, DIALOG_STYLE_MSGBOX, "My organization", string, "Ok", "");
return 1;
}

CMD:orghelp(playerid, params[])
{
#pragma unused params
SendClientMessage(playerid, COLOR_YELLOW, "Dynamic Organizations by Jakku");
SendClientMessage(playerid, COLOR_WHITE, "/orglist || /myorg || /request || /resign || /org || /ochat");
if (IsPlayerAdmin(playerid)) SendClientMessage(playerid, COLOR_WHITE,"RCON- Admin commands: /setleader");
if (IsLeader(playerid)) SendClientMessage(playerid, COLOR_WHITE,"Leader commands: /setmember || /kickmember || /setrank || /members || /ovrespawn || /decline");
return 1;
}

stock GetOrgID(name[])
{
	if (strlen(name) <= 0) return 0;
	for (new i=1;i<OrgsCount+1;i++)
	{
		if (strcmp(name,Organization[i][Name],true) == 0) return i;
	}
	return 0;
}


stock CreateOrgVehicle(org[32], model, Float:x,Float:y,Float:z,Float:rot, clr1,clr2)
{
if (!DoesOrgExist(org)) return printf("You are attempting to create org. vehicles for an org. which does not exist!");
new orgid = GetOrgID(org);
new freeslot = Organization[orgid][VehiclesCreated];
if (freeslot >= MAX_ORG_VEHICLES) return printf("Error: %s cannot handle more vehicles! Aborted", org);

Organization[orgid][Vehicles][freeslot] = CreateVehicle(model, x,y,z,rot,clr1,clr2,900);
printf("Added org. vehicle: %d to slot %d for %s",model,freeslot+1, org);
Organization[orgid][VehiclesCreated]++;
return 1;
}


stock IsLeaderOnline(org)
{
   	for (new i = 0; i < MAX_PLAYERS; i++)
	{
	    if (IsPlayerConnected(i))
	    {
			if (PlayerOrg[i] == org && PlayerLeader[i] == 1) return true;
		}

	}
	return false;
}

stock IsLeader(playerid)
{
	if (PlayerOrg[playerid] != 0 && PlayerLeader[playerid] == 1) return 1;
	return 0;
}

stock IsVehicleConnected(vehicleid)
{
	new Float:x1,Float:y1,Float:z1;
	GetVehiclePos(vehicleid,x1,y1,z1);
	if(x1==0.0 && y1==0.0 && z1==0.0)
	{
		return 0;
	}
	return 1;
}

stock DoesOrgExist(orgname[32])
{
	for (new i=1;i<OrgsCount+1;i++)
	{
	    if (strcmp(Organization[i][Name], orgname, true) == 0) return 1;
	}
	return 0;
}

stock CreateOrganizationZone(orgname[32], Float:minx,Float:miny,Float:maxx,Float:maxy, color)
{
	if (!DoesOrgExist(orgname)) return printf("Error: You are attempting to create a gangzone for '%s' which does not exist", orgname);

	new orgid = GetOrgID(orgname);
	Organization[orgid][ZonesCreated]++;
	if (Organization[orgid][ZonesCreated] >= MAX_ZONES_PER_ORG) return printf("Error: You are attempting to create more than %d zones for %s", MAX_ZONES_PER_ORG, orgname);
	new id = Organization[orgid][ZonesCreated];
	Organization[orgid][ZoneMinX][id] = minx;
	Organization[orgid][ZoneMinY][id] = miny;
	Organization[orgid][ZoneMaxX][id] = maxx;
	Organization[orgid][ZoneMaxY][id] = maxy;
	Organization[orgid][ZoneColor][id] = hexToDec(color);
    Organization[orgid][Zones][id] = GangZoneCreate(minx, miny, maxx, maxy);
    ZoneCount++;
	return ZoneCount;
}


stock hexToDec(hex) { new out[11]; format(out, 11, "%i", hex); return strval(out); }


stock IsPlayerInArea(playerid, Float:MinX, Float:MinY, Float:MaxX, Float:MaxY)
{
    new Float:AX, Float:AY, Float:AZ;
    GetPlayerPos(playerid, AX, AY, AZ);
    if (AX > MinX && AX < MaxX && AY > MinY && AY < MaxY) return true;
    else return false;
}


stock IsPlayerInOrgZone(playerid, orgname[32])
{
	new orgid = GetOrgID(orgname);
	if (DoesOrgExist(orgname))
 	{
		for (new i=1;i<ZoneCount+1;i++)
		{
		    if (Organization[orgid][ZoneMinX][i] != 0.0)
		    {
		        if (IsPlayerInArea(playerid, Organization[orgid][ZoneMinX][i],Organization[orgid][ZoneMinY][i],Organization[orgid][ZoneMaxX][i],Organization[orgid][ZoneMaxY][i]))
		        {
		            return 1;
		        }
			}
		}
	}
	return 0;
}

stock SendClientMessageToOrg(orgname[32], clr, msg[])
{
	if (!DoesOrgExist(orgname)) return 0;
	
 	for (new a=0;a<MAX_PLAYERS;a++)
  	{
   		if (IsPlayerConnected(a))
     	{
      		if (PlayerOrg[a] == GetOrgID(orgname))
        	{
         		SendClientMessage(a, clr, msg);
           	}
        }
   }
	return 1;
}
