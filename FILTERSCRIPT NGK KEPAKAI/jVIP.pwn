/*
Hello guys, this is VIP system created by Jarnu..Called jVIP System.
Don't remove the credits..

Version 0.2 is OUT!

ChangeLog-

-3 more commands
-/vweaps - VIP weapons Level 2
-/vboat - VIP Boat Level 2
-/vsay - Talking with VIP status.. ex: VIP Jarnu (0): hello! :D
-Anti-Vehicle spam Fixed.

Version 0.3!!

-Converted saving system to Y_INI.
*/
#define FILTERSCRIPT

#include <a_samp>
#include <YSI/y_ini>
#include <zcmd>
#include <sscanf>
//=================Credits==================DO NOT REMOVE=======================
#define AUTHOR "Jarnu"
#define VERSION "0.2"
//============PlayerInfo enumerator=============================================
enum pInfo
{
  pVIP
};
//==============================forwards========================================
forward EnablevBonus(playerid);
forward EnablevHeal(playerid);
forward loadvip_Account(playerid, name[], value[]);
//==============================================================================

#define MAX_VIPL 3 // Max VIP level.. can be editted
#define DIALOGCMDS 250 //VMENU dialogid
//===========Colors=============================================================
#define RED                     0xFF0000FF
#define PURPLE                  0xC2A2DAAA
#define GREEN                   0x15FF00AA
#define LIGHTGREEN              0x78FF6CAA
#define BLUE                    0x0015FFAA
//========Extra colors==========================================================
#define cred 				  	"{E10000}"
#define corange					"{FF7E19}"
#define cyellow 				"{FF9E00}"
#define cblue					"{0087FF}"
#define cwhite 					"{FFFFFF}"
#define cgreen 					"{00FF28}"
#define cgrey                   "{969696}"
//==============================================================================
//=============================Variables========================================
new Enablevheal[MAX_PLAYERS]; //-----Disable/Enable vheal command to avoid abuse
new Enablevbonus[MAX_PLAYERS]; //---Disable/Enable vbonus command to avoid abuse
new HasSpawnedCar[MAX_PLAYERS]; //---Will be used to remove the vehicles spawned
//==============================Timers==========================================
enum tInfo
{
   vHeal,
   vBonus
};
new timer[MAX_PLAYERS][tInfo]; //Time variable----------------------------------
//---------removing warning loose indentation-----------------------------------
#pragma tabsize 0
//------------------------------------------------------------------------------
//============PlayerInfo var===========
new PlayerInfo[MAX_PLAYERS][pInfo];
//=====================================
//=============================STOCKS===========================================
stock PlayerName(playerid) 
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}
//===================Account====================================================
stock getACC(playerid)
{
    new file[200];
    format(file, sizeof(file),"jVIP/%s.ini",PlayerName(playerid));
    return file;
}
//============Vip Ranks Can be editted==========================================
stock Rank(playerid)
{
    new str[156];
    if(PlayerInfo[playerid][pVIP] == 0) str = ("Player");
    else if(PlayerInfo[playerid][pVIP] == 1) str = ("Donator Level 1");
    else if(PlayerInfo[playerid][pVIP] == 2) str = ("Donator Level 2");
    else if(PlayerInfo[playerid][pVIP] == 3) str = ("Donator Level 3");
    return str;
}
stock MakeACC(playerid)
{
   if(!fexist(getACC(playerid)))
   {
      new string[125];
	  format(string, sizeof(string),"%s",Rank(playerid));
      new INI:acc = INI_Open(getACC(playerid));
      INI_SetTag(acc,"Account");
      INI_WriteInt(acc,"Level",0);
      INI_WriteString(acc,"Rank",string);
      INI_Close(acc);
      PlayerInfo[playerid][pVIP] = 0;
  }
  return 1;
}
//===========Saving the VIP level===============================================
stock SaveLevel(playerid)
{
   new INI:file = INI_Open(getACC(playerid));
   INI_SetTag(file,"Account");
   INI_WriteInt(file,"Level",PlayerInfo[playerid][pVIP]);
   INI_WriteString(file,"Rank",Rank(playerid));
   INI_Close(file);
   SendClientMessage(playerid, LIGHTGREEN,"VIP Level saved in accounts!");
   return 1;
}
//=======================Opening the file=======================================
public loadvip_Account(playerid, name[], value[])
{
   INI_Int("Level", PlayerInfo[playerid][pVIP]);
   return 1;
}
public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	printf("jVIP V %s by %s has been loaded..", VERSION, AUTHOR); //DO NOT REMOVE CREDITS
	print("--------------------------------------\n");
	return 1;
}
//==============================================================================
public OnFilterScriptExit()
{
	print("\n--------------------------------------");
	printf("jVIP V %s by %s has been unloaded..", VERSION, AUTHOR); //DO NOT REMOVE CREDITS
	print("--------------------------------------\n");
	return 1;
}
//==============================================================================
public OnPlayerConnect(playerid)
{
	PlayerInfo[playerid][pVIP] = 0; //Setting the VIP level 0 on player connect-
	Enablevheal[playerid] = 1; //Enabling the /vheal command on player connect--
	Enablevbonus[playerid] = 1; //Enabling the /vbonus command on player connect
	HasSpawnedCar[playerid] = 0;//-Setting the value to 0
	//-------------Checking and creating the player account in database---------
	if(fexist(getACC(playerid)))
	{
       INI_ParseFile(getACC(playerid),"loadvip_%s", .bExtra = true, .extra = playerid);
	   new string[256];
       format(string, sizeof(string),"Welcome %s Your VIP level has been successfully loaded [VIP Level: %d][VIP Rank: %s]",PlayerName(playerid),PlayerInfo[playerid][pVIP],Rank(playerid));
       print("\n----------------------------------------------------------");
       printf("_____[%s] Very Important Player Connected_____", PlayerName(playerid));
	   print("------------------------------------------------------------\n");
	   SendClientMessage(playerid, GREEN,string);
	}
    else
    {
	   MakeACC(playerid); //Creating the account if the account doesn't exists
	}
	return 1;
}
//Saving PLayer Stats on his disconnect=========================================
public OnPlayerDisconnect(playerid, reason)
{
	SaveLevel(playerid);
	return 1;
}
//========================================CMDS==================================
CMD:vcmds(playerid, params[])
{
   if(PlayerInfo[playerid][pVIP] >= 1)
    {
      new lstring[2566];
      strcat(lstring,""cgreen"VIP Level 1:\n\n"cwhite"/vbike - to spawn nrg\n/vcar - to spawn vip car\n/vheli - to spawn maverick\n/vheal - to heal yourself\n\n\n");
      strcat(lstring,""corange"VIP Level 2:\n"cwhite"/vweaps - to get vip weapons\n/vboat - to spawn vip boat\n/vmenu - to access vip menu\n/vplane - to spawn stunt plane for yourself\n/vpbonus - to heal and give 1 ammo of RPG to nearest players\n/vnos to activate nitros\naccess to level 1 vip commands\n\n\n");
      strcat(lstring,""cblue"VIP Level 3:\n"cwhite"access to all vip commands\n/vfix - to fix your vehicle\n/vtime - to set your time\n/vskin - to set your skin\n/vjetpack - to spawn jetpack for yourself\n/varmour - to armour yourself\n");
      ShowPlayerDialog(playerid, 222,DIALOG_STYLE_MSGBOX,"VIP Commands",lstring,"Close","");
    }
    else return SendClientMessage(playerid, RED,"[ERROR]: You need to be vip level 1 to use this command!");
    return 1;
}
//==========================VIP Level 1 Commands================================
//==============================================================================
CMD:vbike(playerid, params[])
{
   if(PlayerInfo[playerid][pVIP] >= 1)
   {
   if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, RED,"[ERROR]: You already have a vehicle!");
   	  new Float:X, Float:Y, Float:Z;
	  GetPlayerPos(playerid, X, Y, Z);
      PutPlayerInVehicle(playerid, CreateVehicle(522, X, Y, Z, 0.0,0, 1, 60), 0);
      SendClientMessage(playerid, BLUE,"Enjoy your new vip bike!");
      HasSpawnedCar[playerid] = 1;
   }
   else return SendClientMessage(playerid, RED,"[ERROR]: You need to be vip level 1 to use this command!");
   return 1;
}
//==============================================================================
CMD:vheli(playerid, params[])
{
   if(PlayerInfo[playerid][pVIP] >= 1)
   {
   if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, RED,"[ERROR]: You already have a vehicle!");
   	  new Float:X, Float:Y, Float:Z;
	  GetPlayerPos(playerid, X, Y, Z);
      PutPlayerInVehicle(playerid, CreateVehicle(487, X, Y, Z, 0.0,0, 1, 60), 0);
	  SendClientMessage(playerid, BLUE,"Enjoy your new vip helicopter!");
	  HasSpawnedCar[playerid] = 1;
   }
   else return SendClientMessage(playerid, RED,"[ERROR]: You need to be vip level 1 to use this command!");
   return 1;
}
//==============================================================================
CMD:vheal(playerid, params[])
{
   if(PlayerInfo[playerid][pVIP] >= 1) 
   {
	 if(Enablevheal[playerid] == 1)
	 {
        SetPlayerHealth(playerid, 100.0);
	    GameTextForPlayer(playerid,"~g~Healed",1500, 3);
	    PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
	    Enablevheal[playerid] = 0;
		timer[playerid][vHeal] = SetTimer("EnablevHeal", 120*1000,false);
	 } else return SendClientMessage(playerid, RED,"[ERROR]: You can only use this command in each two minutes");
   } else return SendClientMessage(playerid, RED,"[ERROR]: You need to be vip level 1 to use this command!");
   return 1;
}
//==============================================================================
CMD:vcar(playerid, params[])
{
   if(PlayerInfo[playerid][pVIP] >= 1)
   {
   if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, RED,"[ERROR]: You already have a vehicle!");
	  new Float:X, Float:Y, Float:Z;
	  GetPlayerPos(playerid, X, Y, Z);
      PutPlayerInVehicle(playerid, CreateVehicle(415, X, Y, Z, 0.0,0, 1, 60), 0);
      SendClientMessage(playerid, BLUE,"Enjoy your vip car");
      HasSpawnedCar[playerid] = 1;
   }
   else return SendClientMessage(playerid, RED,"[ERROR]: You need to be vip level 1 to use this command");
   return 1;
}
//==========Extra command=======================================================
CMD:vips(playerid, params[]) {
new count = 0;
new string[256];
new name[MAX_PLAYER_NAME];
SendClientMessage(playerid, GREEN,"  ");
SendClientMessage(playerid, GREEN,"Currently online very important players (vips)");
for(new i = 0; i < MAX_PLAYERS; i ++) {
if(IsPlayerConnected(i)) {
GetPlayerName(i, name, sizeof(name));
if(PlayerInfo[i][pVIP] >= 1) {
format(string, sizeof(string),"Donator Level - %d: %s ", PlayerInfo[playerid][pVIP],name);
SendClientMessage(playerid, PURPLE, string);
count++;
}
}
}
if(count == 0) {
SendClientMessage(playerid, GREEN,"No vips online right now");
}
return 1;
}
//==========================RCON ADMIN COMMAND==================================
CMD:setvip(playerid, params[])
{
   if(IsPlayerAdmin(playerid))
   {
	  new string[125], level, player1;
	  if(sscanf(params,"dd",player1, level)) return SendClientMessage(playerid, RED,"[USAGE]: /setvip ( playerid ) ( level )");
	  if(!IsPlayerConnected(playerid) && player1 != INVALID_PLAYER_ID)
	  {
		 SendClientMessage(playerid, RED,"[ERROR]: Player is not connected");
	  }
	  if(level > MAX_VIPL)
	  {
		 SendClientMessage(playerid, RED,"[ERROR]: Incorrect level");
	  }
	  else
	  {
	     format(string, sizeof(string),""cblue"Administrator "cgreen"'%s' "cblue"has set your vip level to "cgreen"'%d'", PlayerName(playerid),level);
	     SendClientMessage(player1, PURPLE, string);
	     PlayerPlaySound(player1,1057,0.0,0.0,0.0);
	     PlayerInfo[player1][pVIP] = level;
	  }
   }
   else return SendClientMessage(playerid, RED,"[ERROR]: You need to be RCON admin to use this command");
   return 1;
}
//==============================================================================
//============================FUNCTIONS=========================================
public EnablevBonus(playerid)
{
  if(Enablevbonus[playerid] == 0)
  {
	 Enablevbonus[playerid] = 1;
	 KillTimer(timer[playerid][vBonus]);
  }
  return 1;
}
public EnablevHeal(playerid)
{
  if(Enablevheal[playerid] == 0)
  {
	Enablevheal[playerid] = 1;
	KillTimer(timer[playerid][vHeal]);
  }
  return 1;
}
//==============================================================================
//==============VIP Level 2 Commands============================================
CMD:vplane(playerid, params[])
{
   if(PlayerInfo[playerid][pVIP] >= 2)
   {
   if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, RED,"[ERROR]: You already have a vehicle!");
   	  new Float:X, Float:Y, Float:Z;
	  GetPlayerPos(playerid, X, Y, Z);
      PutPlayerInVehicle(playerid, CreateVehicle(513, X, Y, Z, 0.0,0, 1, 60), 0);
      SendClientMessage(playerid, BLUE,"Enjoy your vip plane");
      HasSpawnedCar[playerid] = 1;
   }
   else return SendClientMessage(playerid, RED,"[ERROR]: You need to be vip level 2 to use this command");
   return 1;
}
//=======================================VBONUS=================================
CMD:vpbonus(playerid, params[])
{
   if(PlayerInfo[playerid][pVIP] >= 2)
   {
	 if(Enablevbonus[playerid] == 1)
	 {
	  for(new i = 0; i < MAX_PLAYERS; i++)
	  {
		 if(IsPlayerConnected(i))
         {
		     new Float:x, Float:y, Float:z, Float:health, Float:armour;
		     GetPlayerHealth(i, health);
		     GetPlayerArmour(i, armour);
		     GetPlayerPos(playerid, x, y, z);
		     if(IsPlayerInRangeOfPoint(i, 20.0, x, y, z))
		     {
			    GivePlayerWeapon(i, 35,1);
			    SetPlayerHealth(i, health + 20);
			    SetPlayerArmour(i, armour + 10);
			    Enablevbonus[playerid] = 0;
			    timer[playerid][vBonus] = SetTimer("EnablevBonus", 120*1000, false);
			    SendClientMessage(i, GREEN,"[INFO]: VIP near you has used bonus command so you got +1 RPG and some health and armour!");
			 }
		  }
	  }
    } else return SendClientMessage(playerid, RED,"[ERROR]: You can only use this command each two minutes");
   } else return SendClientMessage(playerid, RED,"[ERROR]: You are not vip level 2");
   return 1;
}
//========================================VNOS==================================
CMD:vnos(playerid, params[])
{
   if(PlayerInfo[playerid][pVIP] >= 2)
   {
	 if(IsPlayerInAnyVehicle(playerid))
	 {
		switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
		{
		  case 448,461,462,463,468,471,509,510,521,522,523,581,586,449:
		  return SendClientMessage(playerid,RED,"ERROR: You can not tune this vehicle!");
		}
		AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
		return PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
		}
		else return SendClientMessage(playerid,RED,"ERROR: You must be in a vehicle.");
	}
	else return SendClientMessage(playerid,RED,"ERROR: You are not a high enough level to use this command");
}
//==============================================================================
//=======================NEW VIP Level 2 Commands===============================
CMD:vweaps(playerid, params[])
{
  if(PlayerInfo[playerid][pVIP] >= 2)
  {
     GivePlayerWeapon(playerid,28,1000);
	 GivePlayerWeapon(playerid,31,1000);
	 GivePlayerWeapon(playerid,34,1000);
     GivePlayerWeapon(playerid,38,1000);
	 GivePlayerWeapon(playerid,16,1000);
	 GivePlayerWeapon(playerid,42,1000);
	 GivePlayerWeapon(playerid,14,1000);
	 GivePlayerWeapon(playerid,46,1000);
	 GivePlayerWeapon(playerid,9,1);
	 GivePlayerWeapon(playerid,24,1000);
	 GivePlayerWeapon(playerid,26,1000);
	 SendClientMessage(playerid, GREEN,"[INFO][]: You have spawned all the vip weapons!");
  }
  else return SendClientMessage(playerid, RED,"[ERROR]: You need to be VIP level 2 to use this command!");
  return 1;
}
CMD:vboat(playerid, params[])
{
   if(PlayerInfo[playerid][pVIP] >= 2)
   {
   if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, RED,"[ERROR]: You already have a vehicle!");
   	  new Float:X, Float:Y, Float:Z;
	  GetPlayerPos(playerid, X, Y, Z);
      PutPlayerInVehicle(playerid, CreateVehicle(493, X, Y, Z, 0.0,0, 1, 60), 0);
      SendClientMessage(playerid, BLUE,"Enjoy your vip boat");
      HasSpawnedCar[playerid] = 1;
   }
   else return SendClientMessage(playerid, RED,"[ERROR]: You need to be vip level 2 to use this command");
   return 1;
}
CMD:vsay(playerid, params[])
{
  if(PlayerInfo[playerid][pVIP] >= 1)
  {
     new text;
     if(sscanf(params,"s[125]",text)) return SendClientMessage(playerid, RED,"[USAGE]: /vsay [text");
	 new string[256], pName[MAX_PLAYER_NAME];
	 GetPlayerName(playerid, pName,sizeof(pName));
	 format(string, sizeof(string),"*%s %s: %s",Rank(playerid),pName, text);
	 SendClientMessageToAll(GetPlayerColor(playerid), string);
  }
  else return SendClientMessage(playerid, RED,"[ERROR]: You need to be VIP to use this command!");
  return 1;
}
//====================VIP LEVEL 3 Commands======================================
CMD:vskin(playerid, params[])
{
   if(PlayerInfo[playerid][pVIP] >= 3)
   {
      new skinid, string[128];
      if(sscanf(params, "d", skinid))
      {
         SendClientMessage(playerid, RED, "USAGE: /skin [skinID].");
      }
      else
      {
      if(skinid > 299 || skinid < 0)
	  {
         SendClientMessage(playerid, RED, "[ERROR]: Invalid skin ID.");
      }
	  else
	  {
	     SetPlayerSkin(playerid, skinid);
         format(string, sizeof(string), "[]VIP INFO[]: You have changed your skin to %d.", skinid);
	     SendClientMessage(playerid, GREEN, string);
	  }
	  }
   }
   else return SendClientMessage(playerid, RED,"[ERROR]: You need to be vip level 3 to use this command");
   return 1;
}
CMD:vfix(playerid, params[])
{
  if(PlayerInfo[playerid][pVIP] >= 3)
  {
	if(IsPlayerInAnyVehicle(playerid))
	{
	   new veh;
	   veh = GetPlayerVehicleID(playerid);
	   RepairVehicle(veh);
	   return SendClientMessage(playerid, GREEN,"[]VIP[]: Your vehicle has been repaired");
	}
	else return SendClientMessage(playerid, RED,"[ERROR]: You need to be in vehicle to use this command");
  }
  else return SendClientMessage(playerid, RED,"[ERROR]: You need to be vip level 3 to use this command");
}
CMD:vjetpack(playerid, params[])
{
  if(PlayerInfo[playerid][pVIP] >= 3)
  {
	SetPlayerSpecialAction(playerid, 2);
  }
  else return SendClientMessage(playerid, RED,"[ERROR]: You need to be vip level 3 to use this command");
  return 1;
}
CMD:vtime(playerid, params[])
{
  if(PlayerInfo[playerid][pVIP] >= 3)
  {
	 new time;
	 if(sscanf(params,"d",time)) return SendClientMessage(playerid, RED,"[USAGE]: /vtime [time]");
	 SetPlayerTime(playerid, time, 0);
	 SendClientMessage(playerid, BLUE,"[]VIP[] You have changed your time");
  }
  else return SendClientMessage(playerid, RED,"[ERROR]: You are not vip level 3");
  return 1;
}
CMD:varmour(playerid, params[])
{
   if(PlayerInfo[playerid][pVIP] >= 3)
   {
	 if(Enablevheal[playerid] == 1)
	 {
	    Enablevheal[playerid] = 0;
		timer[playerid][vHeal] = SetTimer("EnablevHeal", 120*1000,false); //Used same timer as vheal.. would not be messy ..
        GameTextForPlayer(playerid,"~g~Armoured",1500, 3);
	    PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		return SetPlayerArmour(playerid, 100.0);

	 } else return SendClientMessage(playerid, RED,"[ERROR]: You can only use this command in each two minutes");
   } else return SendClientMessage(playerid, RED,"[ERROR]: You need to be vip level 3 to use this command!");
}
CMD:vmenu(playerid, params[])
{
   if(PlayerInfo[playerid][pVIP] >= 2)
   {
	  new lstring[325];
	  format(lstring, sizeof(lstring),""cgreen"Bike\n"cblue"Car\n"corange"Plane\n"cred"Maverick\n"cred"Heal me\n"cgreen"Armour me\n"cred"Vehicle Fix\n"corange"Spawn JetPack");
	  ShowPlayerDialog(playerid, DIALOGCMDS,DIALOG_STYLE_LIST,""corange"jVIP Menu",lstring,"Select","Close");
   }
   else return SendClientMessage(playerid, RED,"[ERROR]: You need to be vip level 2 to use this command");
   return 1;
}
//=================DIALOG TIME ^^===============================================
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
  new Float:X, Float:Y, Float:Z;
  GetPlayerPos(playerid, X, Y, Z);
  if(dialogid == DIALOGCMDS)
  {
	switch(listitem)
	{
	   case 0:
	   {
            if(PlayerInfo[playerid][pVIP] >= 1)
			{
			if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, RED,"[ERROR]: You already have a vehicle!");
			   PutPlayerInVehicle(playerid, CreateVehicle(522, X, Y, Z, 0.0,0, 1, 60), 0);
			   SendClientMessage(playerid, BLUE,"Enjoy your new vip bike!");
			   HasSpawnedCar[playerid] = 1;
			}
			else return SendClientMessage(playerid, RED,"[ERROR]: You need to be vip level 1 to use this command!");
	   }
	   case 1:
	   {
          if(PlayerInfo[playerid][pVIP] >= 1)
		  {
		  if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, RED,"[ERROR]: You already have a vehicle!");
              PutPlayerInVehicle(playerid, CreateVehicle(415, X, Y, Z, 0.0,0, 1, 60), 0);
	          SendClientMessage(playerid, BLUE,"Enjoy your vip car");
              HasSpawnedCar[playerid] = 1;
		  }
	      else return SendClientMessage(playerid, RED,"[ERROR]: You need to be vip level 1 to use this command");
	   }
	   case 2:
	   {
	      if(PlayerInfo[playerid][pVIP] >= 2)
		  {
		  if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, RED,"[ERROR]: You already have a vehicle!");
		  PutPlayerInVehicle(playerid, CreateVehicle(513, X, Y, Z, 0.0,0, 1, 60), 0);
		  SendClientMessage(playerid, BLUE,"Enjoy your vip plane");
		  HasSpawnedCar[playerid] = 1;
          }
		  else return SendClientMessage(playerid, RED,"[ERROR]: You need to be vip level 2 to use this command");
	   }
	   case 3:
	   {
	      if(PlayerInfo[playerid][pVIP] >= 1)
		  {
		  if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, RED,"[ERROR]: You already have a vehicle!");
		     PutPlayerInVehicle(playerid, CreateVehicle(487, X, Y, Z, 0.0,0, 1, 60), 0);
			 SendClientMessage(playerid, BLUE,"Enjoy your new vip helicopter!");
	      }
		  else return SendClientMessage(playerid, RED,"[ERROR]: You need to be vip level 1 to use this command!");
	   }
	   case 4:
	   {
            if(PlayerInfo[playerid][pVIP] >= 1)
			{
	          if(Enablevheal[playerid] == 1)
	          {
			    SetPlayerHealth(playerid, 100.0);
				GameTextForPlayer(playerid,"~g~Healed",1500, 3);
         	    PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
	            Enablevheal[playerid] = 0;
                timer[playerid][vHeal] = SetTimer("EnablevHeal", 120*1000,false);
              } else return SendClientMessage(playerid, RED,"[ERROR]: You can only use this command in each two minutes");
            } else return SendClientMessage(playerid, RED,"[ERROR]: You need to be vip level 1 to use this command!");
	   }
	   case 5:
	   {
	       if(PlayerInfo[playerid][pVIP] >= 3)
           {
	          if(Enablevheal[playerid] == 1)
	          {
	             Enablevheal[playerid] = 0;
		         timer[playerid][vHeal] = SetTimer("EnablevHeal", 120*1000,false); //Used same timer as vheal.. would not be messy ..
                 GameTextForPlayer(playerid,"~g~Armoured",1500, 3);
	             PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		         return SetPlayerArmour(playerid, 100.0);
	          } else return SendClientMessage(playerid, RED,"[ERROR]: You can only use this command in each two minutes");
          } else return SendClientMessage(playerid, RED,"[ERROR]: You need to be vip level 3 to use this command!");
       }
	   case 6:
	   {
           if(PlayerInfo[playerid][pVIP] >= 3)
           {
	         if(IsPlayerInAnyVehicle(playerid))
	         {
	           new veh;
	           veh = GetPlayerVehicleID(playerid);
	           RepairVehicle(veh);
	           return SendClientMessage(playerid, GREEN,"[]VIP[]: Your vehicle has been repaired");
	         }
	         else return SendClientMessage(playerid, RED,"[ERROR]: You need to be in vehicle to use this command");
          }
          else return SendClientMessage(playerid, RED,"[ERROR]: You need to be vip level 3 to use this command");
	   }
	   case 7:
	   {
          if(PlayerInfo[playerid][pVIP] >= 3)
          {
	        SetPlayerSpecialAction(playerid, 2);
          }
         else return SendClientMessage(playerid, RED,"[ERROR]: You need to be vip level 3 to use this command");
	   }
	}
  }
  return 0;
}
//========================OnPlayerExitVehicle===================================
public OnPlayerExitVehicle(playerid, vehicleid)
{
  if(HasSpawnedCar[playerid] == 1)
  {
	DestroyVehicle(vehicleid);
	HasSpawnedCar[playerid] = 0;
	SendClientMessage(playerid, GREEN,"[] INFO []: Your vehicle has been destroyed to avoid vehicle spam in server");
  }
  return 1;
}
