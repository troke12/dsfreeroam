/* Copyright(c), JewelL
_______________________________________________________________________________________
JL administration system v1.0 beta
=======================================================================================
--------------------------••••JLadmin include••••-------------------------------------

* how to use JLadmin levels in other filter scripts

1. add JLadmin include on top of the filterscript. ( #include <JLadmin> )
2. To make a command only for Administrators use:  AdminLevel(playerid)
   Example:
	  CMD:mycommand(playerid,params[])
	  {
			if(AdminLevel(playerid))
			{
				//Do something
				return 1;
			}
			else return SendClientMessage(playerid,-1,"You are NOT an Administrator");
	  }

**Make a command for Administrators levels. use  AdminLevel(playerid) > level
   Example: Make a command only for level 5 + Administrators
   
      CMD:mycommand(playerid,params[])
	  {
			if(AdminLevel(playerid) >= 5)
			{
				//Do something
				return 1;
			}
			else return SendClientMessage(playerid,-1,"You are NOT an level 5 Administrator");
	  }

* how to use V.I.P levels in other filter scripts

1. add JLadmin include on top of the filterscript. ( #include <JLadmin> )
2. To make a command only for V.I.P use:  VipLevel(playerid)
   Example:
	  CMD:mycommand(playerid,params[])
	  {
			if(VipLevel(playerid))
			{
				//Do something
				return 1;
			}
			else return SendClientMessage(playerid,-1,"You are NOT an V.I.P member");
	  }

**Make a command for V.I.P levels. use  VipLevel(playerid) > level
   Example: Make a command only for level 2 + V.I.P

      CMD:mycommand(playerid,params[])
	  {
			if(VipLevel(playerid) >= 2)
			{
				//Do something
				return 1;
			}
			else return SendClientMessage(playerid,-1,"You are NOT an level 5 V.I.P member");
	  }


---------------------------------------------------------------------------------------*/

#if defined _JLadmin_included
  #endinput
#endif
#define _JLadmin_included
#pragma library JLadmin

#include <a_samp>

/*----------------------------------------------------------------------------*/
/*------------------Check player Administrator level--------------------------*/
/*----------------------------------------------------------------------------*/
stock AdminLevel(playerid)
{
	return (CallRemoteFunction("PlayerLevel","i",playerid));
}

/*----------------------------------------------------------------------------*/
/*------------------------Check player V.I.P level----------------------------*/
/*----------------------------------------------------------------------------*/
stock VipLevel(playerid)
{
	return (CallRemoteFunction("VipLevel","i",playerid));
}
