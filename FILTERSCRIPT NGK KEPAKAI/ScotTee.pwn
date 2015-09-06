//==============================================================================
//==============================================================================
//======            =======            =============            ================
//==========   ============   ======================   =========================
//==========   ============   ======================   =========================
//==========   ============        =================        ====================
//==========   ============   ======================   =========================
//==========   ============   ======================   =========================
//==========   ============            =============               =============
//==============================================================================
//==============================================================================
//==============================================================================
//==============================================================================
//******************************************************************************
//                 *ScotTees Dynamic Business System*
//******************************************************************************
//Original FS made by Tee, edited by SnG.Scot_MisCuDi and [ABK]Antonio
//               	 |---------Credits:------------|
//                   |  Zeex - Zcmd                |
//                   |  Darco - Dini               |
//                   |  Y_Less - Sscanf2           |
//                   |  Tee - The FS               |
//                   |  SnG.Scot_MisCuDi - Edit FS |
//                   |  [ABK]Antonio - Edit FS     |
//                   |  Incognito- Streamer plugin.|
//                   |-----------------------------|


#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <dini>
#include <streamer>

#define MAX_BUSS 100
#define NO_OWNER "INVALID_PLAYER_ID"
#define CASE_SENSETIVE	true
#define White 0xFFFFFFFF
#define Yellow 0xFFFF00FF
#define Grey 0xC0C0C0FF
#define Red 0xFF0000AA
#define Green 0x45E01FFF

new cpid[32];
new String[200];
new file[128];
new Name[MAX_PLAYER_NAME];
new Float:X,Float:Y,Float:Z;
new Label[128];
new BizExit;
enum Business
{
	CP,
	Text3D:bLabel,
	Cost,
	bName[128],
}
new BusinessInfo[MAX_BUSS][Business];
forward Payday(playerid);

stock Float:GetPosInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
	new Float:a;
	GetPlayerPos(playerid, x, y, a);
	switch(IsPlayerInAnyVehicle(playerid))
	{
	    case 0: GetPlayerFacingAngle(playerid, a);
	    case 1: GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	}
	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
	return a;
}

public OnFilterScriptInit()
{
	print("___________________________");
	print("--Dynamic Business Loaded--");
	print("      --Made by: Tee--     ");
	print("___________________________");
	LoadBusinesses();
	SetTimer("Payday",1_800_000,true);
	BizExit = CreateDynamicCP(-25.9351,-141.5631,1003.5469,1,-1,16,-1,20);
	return 1;
}

public OnFilterScriptExit()
{
	UnloadBusinesses();
	return 1;
}
public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
   	for(new i = 0;i<MAX_BUSS;i++)
   	{
   	    if(checkpointid == BusinessInfo[i][CP])
   	    {
			cpid[playerid] = i;
			format(file,sizeof(file),"Business/%i.ini",i);
			if(dini_Int(file, "HasOwner") == 0)
			{
				ShowPlayerDialog(playerid,219,DIALOG_STYLE_MSGBOX,"Buy Business","Do you want to buy this businesses?","Buy","Cancel");
			}
			else
			{
			    SetPlayerPos(playerid, -25.132598,-139.066986,1003.546875);
			    SetPlayerInterior(playerid, 16);
			    SetPlayerVirtualWorld(playerid, i);
			    SetPlayerFacingAngle(playerid, 359.9003);
			}
		}
	}
	if(checkpointid == BizExit)
	{
	    format(file, sizeof(file), "Business/%i.ini", GetPlayerVirtualWorld(playerid));
	    SetPlayerPos(playerid, dini_Float(file, "SpawnOutX"), dini_Float(file, "SpawnOutY"), dini_Float(file, "BusZ"));
	    SetPlayerFacingAngle(playerid, dini_Float(file, "A"));
	    SetPlayerVirtualWorld(playerid, 0);
	    SetPlayerInterior(playerid, 0);
	}
	return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == 219)
	{
		if(response == 1)
		{
		    if(GetPlayerBusinessID(playerid) == 1)return 0;
			new busid;
  			format(file,sizeof(file),"Business/%i.ini",cpid[playerid]);
			if(GetPlayerBusinessID(playerid) > -1)return SendClientMessage(playerid,Red,"You already own a business");
			if(dini_Int(file,"Cost") > GetPlayerMoney(playerid))return SendClientMessage(playerid,Red,"You do not have enough cash to buy this business.");
			GivePlayerMoney(playerid, -dini_Int(file,"Cost"));
			GetPlayerName(playerid,Name,sizeof(Name));
			dini_Set(file, "Name", Name);
			dini_Set(file, "Owner",Name);
			dini_IntSet(file, "OwnedBus",1);
			dini_IntSet(file, "HasOwner",1);
			format(Label, sizeof(Label), "{ccccff}%s's business\n\n{999999}%s\n{00BC00}Cost: {999999}$%i\n{00BC00}ID: {999999}%i",Name,dini_Get(file, "Owner"),dini_Int(file, "Cost"),busid);
			Update3DTextLabelText(BusinessInfo[cpid[playerid]][bLabel],White,Label);
			format(String,sizeof(String),"You have successfully purchased the %s.",dini_Get(file, "Name"));
			SendClientMessage(playerid,Green,String);
		}
		if(response == 0)
		{
		    SendClientMessage(playerid,Yellow,"You chose not to buy this business");
		}
	}
	if(dialogid == 220)
	{
		if(response == 1)
		{
			GetPlayerName(playerid,Name,sizeof(Name));
			format(file,sizeof(file),"Business/%i.ini",GetPlayerBusinessID(playerid));
			format(Label, sizeof(Label), "{ccccff}For Sale\n\n{999999}No Owner\n{00BC00}Cost: {999999}$%i",dini_Get(file, "Name"),dini_Int(file, "Cost"));
			Update3DTextLabelText(BusinessInfo[cpid[playerid]][bLabel],White,Label);
			dini_Set(file, "Owner","No Owner");
			dini_IntSet(file, "Cost",dini_Int(file, "Cost"));
			dini_IntSet(file, "OwnedBus",0); 
			dini_IntSet(file, "HasOwner",0);
			GivePlayerMoney(playerid,dini_Int(file, "Cost")/2);
			SendClientMessage(playerid,Green,"You have sold your business and recieved 50 percent of the price.");
		}
	}
	return 1;
}

// This command is used to create the business.
COMMAND:createbiz(playerid, params[])
{
	new busid,cost,name[128];
	new Float:x,Float:y; 
	if(!IsPlayerAdmin(playerid))return 0; 
	if(sscanf(params,"I(500000)S(For Sale)[128]",cost,name))return SendClientMessage(playerid, 0xFF0000AA, "Usage: /createbiz [cost] [name]");
	for(new i=0; i<MAX_BUSS; i++) 
	{
	    format(file,sizeof(file),"Business/%i.ini",i);
     	if(!dini_Exists(file))
     	{
     	    busid = i;
     	    break;
     	}
	}
	format(file,sizeof(file),"Business/%i.ini",busid);
	BusinessInfo[busid][bName] = name;
	BusinessInfo[busid][Cost] = cost;
	GetPlayerPos(playerid, X, Y, Z);
    GetPosInFrontOfPlayer(playerid, x, y, -2.5);
	dini_Create(file);
	dini_Set(file, "Name", name);
	dini_Set(file, "Owner","No Owner");
	dini_IntSet(file, "Cost",cost);
	dini_FloatSet(file, "BusX", X);
	dini_FloatSet(file, "BusY", Y);
	dini_FloatSet(file, "BusZ", Z);
	dini_FloatSet(file, "SpawnOutX", x);
	dini_FloatSet(file, "SpawnOutY", y);
    dini_FloatSet(file, "SpawnOutZ", Z);
	dini_IntSet(file, "World",GetPlayerVirtualWorld(playerid));
	dini_IntSet(file, "Interior",GetPlayerInterior(playerid));
	dini_IntSet(file, "OwnedBus",0);
	dini_IntSet(file, "HasOwner",0);
	BusinessInfo[busid][CP] = CreateDynamicCP(X,Y,Z,1.0,GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid),-1,50.0);
	format(Label, sizeof(Label), "{ccccff}%s\n{999999}No Owner\n{00BC00}Cost: {999999}$%i\nID: %i", name,cost,busid);
	BusinessInfo[busid][bLabel] = Create3DTextLabel(Label,White,X,Y,Z,100.0,GetPlayerVirtualWorld(playerid),1);
	format(String,sizeof(String),"BusinessCreated. Name: %s | Cost: $%i | Owner: No Owner | ID: %i",name,cost,busid);
	SendClientMessage(playerid,Green,String);
	return 1;
}
COMMAND:namebiz(playerid, params[])
{
    new name[128];
    if(sscanf(params,"s[128]",name))return SendClientMessage(playerid, 0xFF0000AA, "Usage: /bizname [name]");
    if(GetPlayerBusinessID(playerid) == -1) return SendClientMessage(playerid,Red,"You do not own a business.");
    format(file,sizeof(file),"Business/%i.ini",GetPlayerBusinessID(playerid));
    dini_Set(file, "Name", name);
    format(String,sizeof(String),"Biz renamed to: %s",name);
    SendClientMessage(playerid,Green,String); 
    format(Label, sizeof(Label), "{ccccff}%s\n\n{999999}%s\n{00BC00}Cost: {999999}$%i\n{00BC00}ID: {999999}%i",name, dini_Get(file, "Owner"),dini_Int(file, "Cost"),GetPlayerBusinessID(playerid));
    Update3DTextLabelText(BusinessInfo[GetPlayerBusinessID(playerid)][bLabel],White,Label);
    return 1;
}
//This command is used to delete a business.
COMMAND:deletebiz(playerid, params[])
{
	new busid;
	if(!IsPlayerAdmin(playerid)) return 0;
	if(sscanf(params, "i", busid)) return SendClientMessage(playerid,0xC0C0C0FF,"Usage: /deletebusiness [busid]");
	format(file,sizeof(file),"Business/%i.ini",busid);
	if(!dini_Exists(file))return SendClientMessage(playerid,Red,"That businessid does not exists.");
	format(String,sizeof(String),"You have successfully deleted a business. ID: %i.",busid);
	SendClientMessage(playerid,Yellow,String);
	DestroyDynamicCP(BusinessInfo[busid][CP]);
	Delete3DTextLabel(BusinessInfo[busid][bLabel]);
	dini_Remove(file);
	return 1;
}

//This command is used to sell a business (only owners can use it).
COMMAND:sellbiz(playerid, params[])
{
	if(GetPlayerBusinessID(playerid) == -1)return SendClientMessage(playerid,Red,"You do not own a business.");
	ShowPlayerDialog(playerid,220,DIALOG_STYLE_MSGBOX,"Sell Business","Do you want to sell your businesses?","Sell","Cancel");
	return 1;
}

//This function gets the owner of a specific business.
stock GetBusOwner(bussid)
{
	new owner[MAX_PLAYER_NAME];
	format(owner, MAX_PLAYER_NAME, NO_OWNER);
	format(String, sizeof(String), "Business/%i.ini", bussid);
	if(dini_Exists(String))
	{
	    format(owner, MAX_PLAYER_NAME, "%s", dini_Get(String, "Owner"));
		return owner;
	}
	return owner;
}

//This function gets a business ID (it also tells if a player owns a business or not).
stock GetPlayerBusinessID(playerid)
{
	new returnval, found=0;
 	for(new i = 0;i<MAX_BUSS;i++)
	{
   		format(String,sizeof(String),"Business/%i.ini",i);
   		if(dini_Exists(String))
		{
			GetPlayerName(playerid,Name,sizeof(Name));
   			if(!strcmp(Name, dini_Get(String,"Owner"), false))
      		{
      		    returnval = i;
      		    found = 1;
			}
		}
	}
	if(!found) returnval = -1;
	return returnval;
}


//This command removes a player from owning a business.
COMMAND:debiz(playerid, params[])
{
	new id;
	if(!IsPlayerAdmin(playerid))return 0;
	if(sscanf(params,"u", id))return SendClientMessage(playerid, 0xFF0000AA, "Usage: /debus [id]");
	if(GetPlayerBusinessID(id) == -1)return SendClientMessage(playerid,Red,"That player does not own a business.");
	format(String,sizeof(String),"Business/%i.ini",GetPlayerBusinessID(id));
	format(Label, sizeof(Label), "{ccccff}%s\n{999999}No Owner\n{00BC00}Cost: {999999}$%i",dini_Get(String, "Name"),dini_Int(String, "Cost"));
	Update3DTextLabelText(BusinessInfo[GetPlayerBusinessID(id)][bLabel],White,Label);
	dini_Set(String, "Owner","No Owner");
	dini_IntSet(String, "Cost",dini_Int(String, "Cost"));
	dini_IntSet(String, "OwnedBus",0);
	dini_IntSet(String, "HasOwner",0);
	GivePlayerMoney(id,dini_Int(String, "Cost")/4);
	format(String, sizeof(String), "You have removed %s as the owner of his/her business.",Name);
	SendClientMessage(playerid,Red, String);
	return 1;
}

//This function loads every business.
stock LoadBusinesses()
{
	new count = 0;
	for(new i=0; i<MAX_BUSS; i++)
	{
		format(String,sizeof(String),"Business/%i.ini",i); // the ID would be the name of the file, 1 2 3 4 5 etc
		if(dini_Exists(String)) //thats the easiest way to get IDs of them, you don't need to write it inside of the file itself if the name of the file is a number.. looks good?
		{
			BusinessInfo[i][CP] = CreateDynamicCP(dini_Float(String, "BusX"),dini_Float(String, "BusY"),dini_Float(String, "BusZ"),1.0,dini_Int(String, "World"),dini_Int(String, "Interior"),-1,100.0);
			if(!strcmp(GetBusOwner(i), NO_OWNER, CASE_SENSETIVE))
			{
				format(Label, sizeof(Label), "{ccccff}%s\n{999999}No Owner\n{00BC00}Cost: {999999}$%i",dini_Get(String, "Name"),dini_Int(String, "Cost"));
				BusinessInfo[i][bLabel] = Create3DTextLabel(Label,White,dini_Float(String, "BusX"),dini_Float(String, "BusY"),dini_Float(String, "BusZ")+1,100.0,0,1);
			}
			if(strcmp(GetBusOwner(i), NO_OWNER, CASE_SENSETIVE))//i will be what index it's at in the loop which would be the ID as its looping through all the files
			{
				format(Label, sizeof(Label), "{ccccff}%s\n\n{999999}%s\n{00BC00}Cost: {999999}$%i\n{00BC00}ID: {999999}%i",dini_Get(String, "Name"), dini_Get(String, "Owner"),dini_Int(String, "Cost"),i);
				BusinessInfo[i][bLabel] = Create3DTextLabel(Label,White,dini_Float(String, "BusX"),dini_Float(String, "BusY"),dini_Float(String, "BusZ")+1,100.0,0,1);
			}
			count++;
		}
	}
	return printf("Total Businesses Loaded: %i",count);
}

//This function gets the last bused business ID.
stock GetLastBusinessID()
{
	new count = 0;
	for(new i=0; i<MAX_BUSS; i++)
	{
		format(String,sizeof(String),"Business/%i.ini",i);
		{
		    count++;
		}
	}
	return count;
}

//This function unloads every business.
stock UnloadBusinesses()
{
	for(new i=0; i<MAX_BUSS; i++)
    {
		Delete3DTextLabel(BusinessInfo[i][bLabel]);
		DestroyDynamicCP(BusinessInfo[i][CP]);
	}
	return 1;
}

//This is used by RCON admins. Either to debug or to force a payday.
COMMAND:forcepayday(playerid,params[])
{
	if(!IsPlayerAdmin(playerid))return 0;
	SendClientMessage(playerid,Grey,"You have forced a payday.");
	for(new i=0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i)) Payday(i);
	return 1;
}

#define TIMEDEBUG 1 //set this to 0 if you don't want it to print the time it took for this function to execute

//This function is the payday (to pay the owners).
public Payday(playerid)
{
	#if TIMEDEBUG == 1
	new tick = GetTickCount();
	#endif
	if(GetPlayerBusinessID(playerid) != -1)
	{
		new RandMoney = rand(100_000, 250_000), msg[128];
		GivePlayerMoney(playerid, RandMoney);
		format(msg, sizeof(msg), "[BIZ UPDATE] You've recieved $%i", RandMoney);
		SendClientMessage(playerid, Green, msg);
		format(msg, sizeof(msg), "~w~You've recieved ~g~$%i ~w~from your biz", RandMoney);
		GameTextForPlayer(playerid, msg, 4000,3);
	} 
	else return SendClientMessage(playerid, Green, "If you had a business, you could've gotten a paycheck!"); 
	#if TIMEDEBUG == 1
	printf("Time taken to execute Payday(): %i", GetTickCount()-tick);
	#endif
	return 1;
}
stock pName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}
stock rand(minnum = cellmin,maxnum = cellmax) return random(maxnum - minnum + 1) + minnum; //swtiches so much better
