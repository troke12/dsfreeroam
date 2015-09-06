
#include <a_samp>
#include <dini>


new pname[24];
new PlayerVehicle[MAX_PLAYERS];
new isarenda[MAX_PLAYERS];
new arendaveh[MAX_VEHICLES];
new vehiclearenda[MAX_PLAYERS];
new vpj[MAX_VEHICLES];
new vc1[MAX_VEHICLES];
new vc2[MAX_VEHICLES];

public OnFilterScriptInit()
{
	print("\n=====================================");
	print(" Ultra Tuned Car Saver loaded!");
	print("                   by pasha97 aka [UFF]Pasha aka [N.R.G]Boss_Pasha");
	print("=====================================\n");
	for(new i = 0; i < MAX_VEHICLES; i++)
	{
	vc1[i] = 1;
	vc2[i] = 1;
	vpj[i] = 3;
	}
	return 1;
}

public OnFilterScriptExit()
{
	print("\n=====================================");
	print(" Ultra Tuned Car Saver unloaded!");
	print("=====================================\n");
	return 1;
}


public OnPlayerConnect(playerid)
{
  	GetPlayerName(playerid, pname, sizeof(pname));
	new file[256];format(file,sizeof(file),"Tuned Cars/%s.sav", pname);
  	if(dini_Isset(file,"ID") && dini_Isset(file,"X")  && dini_Isset(file,"Y") && dini_Isset(file,"Z") && dini_Isset(file,"ROT") && dini_Isset(file,"COLOR1") && dini_Isset(file,"COLOR2")){
	PlayerVehicle[playerid]=CreateVehicle(dini_Int(file,"ID"),dini_Int(file,"X"),dini_Int(file,"Y"),dini_Int(file,"Z"),dini_Int(file,"ROT"),dini_Int(file,"COLOR1"),dini_Int(file,"COLOR2"),100);
	AddVehicleComponent(PlayerVehicle[playerid], dini_Int(file,"COMPONENT1"));
	AddVehicleComponent(PlayerVehicle[playerid], dini_Int(file,"COMPONENT2"));
	AddVehicleComponent(PlayerVehicle[playerid], dini_Int(file,"COMPONENT3"));
	AddVehicleComponent(PlayerVehicle[playerid], dini_Int(file,"COMPONENT4"));
	AddVehicleComponent(PlayerVehicle[playerid], dini_Int(file,"COMPONENT5"));
	AddVehicleComponent(PlayerVehicle[playerid], dini_Int(file,"COMPONENT6"));
	AddVehicleComponent(PlayerVehicle[playerid], dini_Int(file,"COMPONENT7"));
	AddVehicleComponent(PlayerVehicle[playerid], dini_Int(file,"COMPONENT8"));
	AddVehicleComponent(PlayerVehicle[playerid], dini_Int(file,"COMPONENT9"));
	ChangeVehiclePaintjob(PlayerVehicle[playerid], dini_Int(file,"PAINTJOB"));
	arendaveh[PlayerVehicle[playerid]] = playerid;
	isarenda[PlayerVehicle[playerid]] = 1;}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    DestroyVehicle(PlayerVehicle[playerid]);
	isarenda[PlayerVehicle[playerid]] = 0;
	return 1;
}

public OnPlayerSpawn(playerid)
{
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

public OnPlayerCommandText(playerid, cmdtext[])
{
   	if(strcmp(cmdtext, "/scar", true) == 0)
	{
	new file[256];
	new str[256];
	new Float:nx,Float:ny,Float:nz,Float:nrot,Model, comp1, comp2, comp3, comp4, comp5, comp6, comp7, comp8, comp9;
	new Var[50];
    GetPlayerName(playerid, pname, sizeof(pname));
    format(file, sizeof(file), "Tuned Cars/%s.sav", pname);
	if(!dini_Exists(file))
	{
	dini_Create(file);
	}
	if(!IsPlayerInAnyVehicle(playerid)){
	SendClientMessage(playerid,0xFF0000FF,"You're not in a vehicle! Find one to save it!");
	return 1;}
  	if(IsPlayerInAnyVehicle(playerid)){
    if(dini_Isset(file,"ID") && dini_Isset(file,"X")  && dini_Isset(file,"Y") && dini_Isset(file,"Z") && dini_Isset(file,"ROT") && dini_Isset(file,"COLOR1") && dini_Isset(file,"COLOR2")){
	SendClientMessage(playerid,0xFFCC00FF,"You have changed your saved vehicle");}
	GetPlayerPos(playerid,nx,ny,nz);
 	GetVehicleZAngle(GetPlayerVehicleID(playerid),nrot);
	Model=GetVehicleModel(GetPlayerVehicleID(playerid));
	comp1 = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_SPOILER);
	comp2 = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_HOOD);
	comp3 = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_ROOF);
	comp4 = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_SIDESKIRT);
	comp5 = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_EXHAUST);
	comp6 = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_WHEELS);
	comp7 = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_HYDRAULICS);
	comp8 = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_FRONT_BUMPER);
	comp9 = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_REAR_BUMPER);
	dini_IntSet(file,"ID",Model);
	format(Var, sizeof(Var),"%0.2f", nx);
	dini_IntSet(file,"X",strval(Var));
	format(Var, sizeof(Var),"%0.2f", ny);
	dini_IntSet(file,"Y",strval(Var));
	format(Var, sizeof(Var),"%0.2f", nz+0.5);
	dini_IntSet(file,"Z",strval(Var));
	format(Var, sizeof(Var),"%0.2f", nrot);
	dini_IntSet(file,"ROT",strval(Var));
	dini_IntSet(file,"COLOR1",vc1[GetPlayerVehicleID(playerid)]);
	dini_IntSet(file,"COLOR2",vc2[GetPlayerVehicleID(playerid)]);
	dini_IntSet(file,"COMPONENT1",comp1);
	dini_IntSet(file,"COMPONENT2",comp2);
	dini_IntSet(file,"COMPONENT3",comp3);
	dini_IntSet(file,"COMPONENT4",comp4);
	dini_IntSet(file,"COMPONENT5",comp5);
	dini_IntSet(file,"COMPONENT6",comp6);
	dini_IntSet(file,"COMPONENT7",comp7);
	dini_IntSet(file,"COMPONENT8",comp8);
	dini_IntSet(file,"COMPONENT9",comp9);
	dini_IntSet(file,"PAINTJOB",vpj[GetPlayerVehicleID(playerid)]);
	PlayerVehicle[playerid]=GetPlayerVehicleID(playerid);
	arendaveh[PlayerVehicle[playerid]] = playerid;
	isarenda[PlayerVehicle[playerid]] = 1;
	SendClientMessage(playerid,0x00FF00FF,"You have saved your Personal Vehicle");
	format(str, sizeof(str), "{ffffff}%s {ffcc00}saved personal vehicle {00ff00}/scar", pname), SendClientMessageToAll(0xFFFFFFFF, str);}
	return 1;
	}
   	if(strcmp(cmdtext, "/lcar", true) == 0)
	{
		GetPlayerName(playerid, pname, sizeof(pname));
		new file[256], str[256];format(file,sizeof(file),"Tuned Cars/%s.sav", pname);
		new Float:nx,Float:ny,Float:nz,Float:nrot;
		GetPlayerPos(playerid, nx, ny, nz);
		GetPlayerFacingAngle(playerid, nrot);
		if(dini_Isset(file,"ID") && dini_Isset(file,"X")  && dini_Isset(file,"Y") && dini_Isset(file,"Z") && dini_Isset(file,"ROT") && dini_Isset(file,"COLOR1") && dini_Isset(file,"COLOR2")){
		SetVehiclePos(PlayerVehicle[playerid], nx, ny, nz);
		AddVehicleComponent(PlayerVehicle[playerid], dini_Int(file,"COMPONENT1"));
		AddVehicleComponent(PlayerVehicle[playerid], dini_Int(file,"COMPONENT2"));
		AddVehicleComponent(PlayerVehicle[playerid], dini_Int(file,"COMPONENT3"));
		AddVehicleComponent(PlayerVehicle[playerid], dini_Int(file,"COMPONENT4"));
		AddVehicleComponent(PlayerVehicle[playerid], dini_Int(file,"COMPONENT5"));
		AddVehicleComponent(PlayerVehicle[playerid], dini_Int(file,"COMPONENT6"));
		AddVehicleComponent(PlayerVehicle[playerid], dini_Int(file,"COMPONENT7"));
		AddVehicleComponent(PlayerVehicle[playerid], dini_Int(file,"COMPONENT8"));
		AddVehicleComponent(PlayerVehicle[playerid], dini_Int(file,"COMPONENT9"));
		ChangeVehiclePaintjob(PlayerVehicle[playerid], dini_Int(file,"PAINTJOB"));
		PutPlayerInVehicle(playerid, PlayerVehicle[playerid], 0);
	    SendClientMessage(playerid, 0x00FF00FF, "You have loaded your personal vehicle.");
		format(str, sizeof(str), "{ffffff}%s {ffcc00}loaded personal vehicle {00ff00}/lcar",pname), SendClientMessageToAll(0xFFFFFFFF, str);}
	    else{
	    SendClientMessage(playerid, 0xFF0000FF, "You do not have any perosnal vehicle.");}
	    return 1;
	}
	return 0;
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
	vehiclearenda[playerid] = GetPlayerVehicleID(playerid);
	if(isarenda[vehiclearenda[playerid]] == 1)
	{
	if(newstate == PLAYER_STATE_DRIVER)
	{
	if(arendaveh[vehiclearenda[playerid]] == playerid)
	{
	SendClientMessage(playerid,0xFFCC00FF,"{ffcc00}This is your personal car");
	}
	else
	{
	RemovePlayerFromVehicle(playerid);
	SendClientMessage(playerid,0xFF0000,"{ff0000}This car is owned by another player");
	}
	}
	}
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
	vpj[vehicleid] = paintjobid;
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
    vc1[vehicleid] = color1;
    vc2[vehicleid] = color2;
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
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
