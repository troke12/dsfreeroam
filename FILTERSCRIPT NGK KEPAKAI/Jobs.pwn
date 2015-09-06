/* ---------------------------------------------------------------------------------------------------------
|																										   |
|				Ekeleke Jobs - Made by Ekeleke aka Jack Shred                                              |
|				You can edit the defines by your wishes                                                    |
|				Do not remove these credits!                                                               |
|																										   |
--------------------------------------------------------------------------------------------------------- */
#include <a_samp>

// --- Variables --- //

new bodypickup;
new hackpickup;
new hackpcpickup;
new amount;
new taz;
new policepickup;
new wantedpointpickup;
new time;
new amountz;
new lawyerpickup;
new amountzz;
new amountzzz;
new hitmanpickup;
new orderpickup;
new robpickup;

// --- Defines --- //

#define HACK_AWARD 10000 // The amount a player gets if he succesfully hacks a building
#define MAX_ARREST_FINE 20001 // The amount an officer can fine a player when the player gets arrested [ Maximum ] - 1
#define MINIMUM_ARREST_FINE 1999 // The amount an officer can fine a player when the player gets arrested [ Minimum ] + 1
#define MAX_DEFEND_AMOUNT 10001 // The amount a lawyer can remove a wanted star for [ Maximum ] - 1
#define MIN_DEFEND_AMOUNT 1999 // The amount a lawyer can remove a wanted star for [ Maximum ] + 1
#define MAX_ARREST_JAIL_TIME 21 // The amount an officer can put a player in jail for in minutes [ Maximum ] - 1
#define MIN_ARREST_JAIL_TIME 1 // The amount an officer can put a player in jail for in minutes [ Minimum ] + 1
#define MAX_CONTRACT_AMOUNT 1000001 // The amount a player can contract another player for [ Maximum ] - 1
#define MIN_CONTRACT_AMOUNT 9999 // The amount a player can contract another player for [ Minimum ] + 1
#define dcmd(%1,%2,%3) if (!strcmp((%3)[1], #%1, true, (%2)) && ((((%3)[(%2) + 1] == '\0') && (dcmd_%1(playerid, ""))) || (((%3)[(%2) + 1] == ' ') && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1

// --- Playerid Variables --- //

new PlayerJob[MAX_PLAYERS];
new WantedLevel[MAX_PLAYERS];
new PlayerOffered[MAX_PLAYERS];
new IsContracted[MAX_PLAYERS];
new PlayerTicket[MAX_PLAYERS];
new PlayerDefense[MAX_PLAYERS];
new IsCuffed[MAX_PLAYERS];
new IsTazed[MAX_PLAYERS];
new CanHack[MAX_PLAYERS];

// --- Forwards --- //

forward SendCopsMessage(color, string[]);
forward SendHitmansMessage(color, string[]);
forward SetPlayerJailed(playerid);
forward	OnPlayerAcceptVestOffer(playerid);
forward OnPlayerAcceptVestOffer2(playerid);
forward OnPlayerAcceptTicket(playerid);
forward OnPlayerAcceptTicket2(playerid);
forward OnPlayerAcceptDefense(playerid);
forward OnPlayerAcceptDefense2(playerid);
forward SendRconAdminMessage(playerid, color, string[]);
forward tazertimer(playerid);
forward OnPlayerJailed(playerid);
forward Time2Explode(playerid);
forward Time2Hack(playerid);
forward Anti2Hack(playerid);

// ---- Filterscript Defines --- //
#define FILTERSCRIPT
#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Ekeleke Jobs has been loaded");
	print(" Made by Ekeleke aka Jack Shred ");
	print("--------------------------------------\n");
	
	// --- Pickups --- //
	
	bodypickup = CreatePickup(1239, 1, 2141.4048,-1732.1564,17.2891, 0);
	hackpickup = CreatePickup(1239, 1, 781.3233,-1060.5305,24.8275, 0);
	policepickup = CreatePickup(1239,1,256.6144,69.6090,1003.6406,-1);
	wantedpointpickup = CreatePickup(1247, 23, 1528.3268,-1677.8229,5.8906);
	lawyerpickup = CreatePickup(1239,1,475.7782,-1501.5706,20.5386,0);
	hitmanpickup = CreatePickup(1239, 1, 688.0978,-443.2654,16.3359, 0);
	orderpickup = CreatePickup(1239, 1, 681.3100,-444.6037,16.3359, 0);
	robpickup = CreatePickup(1239, 1, 1941.0897,-2110.6958,13.6953, 0);
	hackpcpickup = CreatePickup(1239, 1, 1123.9536,-2036.9503,69.8856, 0);

	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}
#endif

public OnPlayerConnect(playerid)
{
	SendClientMessage(playerid,0xFF0000AA,"[Succes]: Ekeleke Jobs has been loaded. Credits go to Ekeleke aka Jack Shred ! ");
	PlayerOffered[playerid] = 999;
	PlayerTicket[playerid] = 999;
	PlayerDefense[playerid] = 999;
	PlayerJob[playerid] = 0;
	SetPlayerMapIcon(playerid, 95, 2141.4048,-1732.1564,17.2891, 44, 0); // BodyGuard MapIcon
	SetPlayerMapIcon(playerid, 96, 781.3233,-1060.5305,24.8275, 44, 0); // Hacker MapIcon
 	// Police ( Interior! - Los Santos Police Department, Lobby - Right corner )
 	SetPlayerMapIcon(playerid, 97, 475.7782,-1501.5706,20.5386, 44, 0); // Lawyer MapIcon
 	SetPlayerMapIcon(playerid, 98, 688.0978,-443.2654,16.3359, 44, 0); // Hitman MapIcon
 	SetPlayerMapIcon(playerid, 99, 1941.0897,-2110.6958,13.6953, 44, 0); // Robber MapIcon
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(IsContracted[playerid] == 1 && PlayerJob[killerid] == 5)
	{
	GivePlayerMoney(playerid, -amountzzz);
	GivePlayerMoney(killerid, amountzzz);
	SendClientMessage(playerid, 0xFF0000AA, "[Hitman]: You have been killed by a hitman and lost the money! The contract has been removed");
	SendClientMessage(killerid, 0xFF0000AA, "[Succes]: You have killed the player and gained the money!");
	IsContracted[playerid] = 0;
	}
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
	// ---------------------------------------------------------------------- DCMD COMMANDS | SSCANF ----------------------------------------------------------//
	
	dcmd(p, 1, cmdtext);
	dcmd(f, 1, cmdtext);
	dcmd(sellvest, 8, cmdtext);
	dcmd(su, 2, cmdtext);
	dcmd(pu, 2, cmdtext);
	dcmd(tazer, 5, cmdtext);
	dcmd(arrest, 6, cmdtext);
	dcmd(cuff, 4, cmdtext);
	dcmd(uncuff, 6, cmdtext);
	dcmd(drag, 4, cmdtext);
	dcmd(ticket, 6, cmdtext);
	dcmd(defend, 6, cmdtext);
	dcmd(contract, 8, cmdtext);
	dcmd(order, 5, cmdtext);
	dcmd(rob, 3, cmdtext);
	
	// ----------------------------------------------------------------- STRCMP COMMANDS ----------------------------------------------------------------------//



	if(strcmp("/acceptvest", cmdtext, true, 10) == 0)
	{
	    new Float:X,Float:Y,Float:Z;
	    GetPlayerPos(PlayerOffered[playerid],X,Y,Z);
	    if(PlayerOffered[playerid] == 999 )
	    {
	    SendClientMessage(playerid,0xFF0000AA, "[Error]: No-one has offered you a vest");
	    return 1;
	    }
	    if(!IsPlayerInRangeOfPoint(playerid,20.0,X,Y,Z))
	    {
	    SendClientMessage(playerid,0xFF0000AA,"[Error]: You are too far away from him!");
	    }
	    if(IsPlayerInRangeOfPoint(playerid,20.0,X,Y,Z))
	    {
     	OnPlayerAcceptVestOffer(playerid);
     	OnPlayerAcceptVestOffer2(PlayerOffered[playerid]);
     	}
		return 1;
	}
	
	if(strcmp("/hack", cmdtext, true, 10) == 0)
	{
	    if(PlayerJob[playerid] != 2)
	    {
	    SendClientMessage(playerid, 0xFF0000AA, "[Error]: You are not a hacker!");
	    }
	    if(CanHack[playerid] == 1) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: You need to wait atleast 30 minutes before hacking again");
	    if(!IsPlayerInRangeOfPoint(playerid, 20.0, 1123.9536,-2036.9503,69.8856))
	    {
	    SendClientMessage(playerid, 0xFF0000AA, "[Error]: You are not at the Verdant Bluffs building");
	    }
	    else
	    {
	    SendClientMessage(playerid, 0xFF0000AA, "[Succes]: You are hacking the building!");
	    SendClientMessage(playerid, 0xFF0000AA, "[Hacking]: Loading Syst32.exe [ 20 percent ]");
	    SendClientMessage(playerid, 0xFF0000AA, "[Hacking]: Loading Syst32.exe [ 40 percent ]");
	    SendClientMessage(playerid, 0xFF0000AA, "[Hacking]: Loading Syst32.exe [ 60 percent ]");
	    SendClientMessage(playerid, 0xFF0000AA, "[Hacking]: Loading Syst32.exe [ 80 percent ]");
	    SendClientMessage(playerid, 0xFF0000AA, "[Hacking]: Loading Syst32.exe [ 100 percent ]");
	    SendClientMessage(playerid, 0xFF0000AA, "[Hacking]: Loading X37ey4dhfruKjH3.exe [ 20 percent ]");
	    SendClientMessage(playerid, 0xFF0000AA, "[Hacking]: Loading X37ey4dhfruKjH3.exe [ 40 percent ]");
	    SendClientMessage(playerid, 0xFF0000AA, "[Hacking]: Loading X37ey4dhfruKjH3.exe [ 60 percent ]");
	    SendClientMessage(playerid, 0xFF0000AA, "[Hacking]: Loading X37ey4dhfruKjH3.exe [ 80 percent ]");
	    SendClientMessage(playerid, 0xFF0000AA, "[Hacking]: Loading X37ey4dhfruKjH3.exe [ 100 percent ]");
	    TogglePlayerControllable(playerid, false);
	    SetTimerEx("Time2Hack", 10000, false, "i",playerid);
	    SetTimerEx("Anti2Hack", 3000000, false, "i", playerid);
	    CanHack[playerid] = 1;
	    }
	    return 1;
	}
	if(strcmp("/acceptdefense", cmdtext, true, 10) == 0)
	{
	    new Float:X, Float:Y, Float:Z;
	    GetPlayerPos(PlayerDefense[playerid],X,Y,Z);
	    if(PlayerDefense[playerid] == 999)
	    {
	    SendClientMessage(playerid, 0xFF0000AA, "[Error]: No-one has offered to defend you");
		}
		if(!IsPlayerInRangeOfPoint(playerid,20.0,X,Y,Z))
		{
		SendClientMessage(playerid,0xFF0000AA,"[Error]: You are too far away from him");
		}
		if(IsPlayerInRangeOfPoint(playerid,20.0,X,Y,Z))
		{
		OnPlayerAcceptDefense(playerid);
		OnPlayerAcceptDefense2(PlayerDefense[playerid]);
		}
		return 1;
	}
	
	if(strcmp("/acceptticket", cmdtext, true, 10) == 0)
	{
	    new Float:X,Float:Y,Float:Z;
	    GetPlayerPos(PlayerTicket[playerid],X,Y,Z);
	    if(PlayerTicket[playerid] == 999 )
	    {
	    SendClientMessage(playerid,0xFF0000AA, "[Error]: No-one has given you a ticket");
		}
		if(!IsPlayerInRangeOfPoint(playerid,20.0,X,Y,Z))
		{
		SendClientMessage(playerid,0xFF0000AA,"[Error]: You are too away from him!");
		}
		if(IsPlayerInRangeOfPoint(playerid,20.0,X,Y,Z))
		{
		OnPlayerAcceptTicket(playerid);
		OnPlayerAcceptTicket2(PlayerTicket[playerid]);
		}
		return 1;
	}

	if (strcmp("/quitjob", cmdtext, true, 10) == 0)
	{
		if(PlayerJob[playerid] == 0)
		{
		SendClientMessage(playerid, 0xFF0000AA, " [Error]: You don't have a job! ");
		}
	    else if(PlayerJob[playerid] >= 0)
		{
		PlayerJob[playerid] = 0;
		SendClientMessage(playerid, 0xFF0000AA, " [Succes]: You have left your job! ");
		}
		return 1;
	}
	if (strcmp("/join", cmdtext, true, 10) == 0)
	{
		if(PlayerJob[playerid] > 0)
		{
		SendClientMessage(playerid,0xFF0000AA, "[Error]: You already have a job! ");
		}
		if(PlayerJob[playerid] == 0)
		{
		    	if(IsPlayerInRangeOfPoint(playerid, 5.0, 2141.4048,-1732.1564,17.2891)) // bodyguard
		    	{
				PlayerJob[playerid] = 1;
				SendClientMessage(playerid,0xFF0000AA, "[Succes]: You are now a bodyguard! Type /jobhelp for more information");
				}
				else if(IsPlayerInRangeOfPoint(playerid, 5.0, 781.3233,-1060.5305,24.8275)) // hacker
				{
				PlayerJob[playerid] = 2;
				SendClientMessage(playerid, 0xFF0000AA, "[Succes]: You are now a hacker! Type /jobhelp for more information");
				SendClientMessage(playerid, 0xFF0000AA, "[Note]: This is an illegal job, the cops can arrest you for this");
				}
				else if(IsPlayerInRangeOfPoint(playerid, 5.0, 256.6144,69.6090,1003.6406)) // police
				{
				PlayerJob[playerid] = 3;
				SendClientMessage(playerid, 0xFF0000AA, "[Succes]: You are now a Police Officer! Type /jobhelp for more information");
				}
				else if(IsPlayerInRangeOfPoint(playerid, 5.0, 475.7782,-1501.5706,20.5386)) // lawyer
				{
				PlayerJob[playerid] = 4;
				SendClientMessage(playerid, 0xFF0000AA, "[Succes]: You are now a Lawyer! Type /jobhelp for more information");
				}
				else if(IsPlayerInRangeOfPoint(playerid, 5.0, 688.0978,-443.2654,16.3359)) // hitman
				{
				PlayerJob[playerid] = 5;
				SendClientMessage(playerid, 0xFF0000AA, "[Succes]: You are now a hitman! Type /jobhelp for more information");
				}
				else if(IsPlayerInRangeOfPoint(playerid, 5.0, 1941.0897,-2110.6958,13.6953)) // robber
				{
				PlayerJob[playerid] = 6;
				SendClientMessage(playerid, 0xFF0000AA, "[Succes]: You are now a Robber! Type /jobhelp for more information");
				}
		}
		return 1;
	}
	if (strcmp("/jobhelp", cmdtext, true, 10) == 0)
	{
	    if(PlayerJob[playerid] == 0)
	    {
	    SendClientMessage(playerid,0xFF0000AA, "[Error] You don't have a job!");
	    }
	    else if(PlayerJob[playerid] == 1)
	    {
	    SendClientMessage(playerid, 0xFF0000AA, "[Succes]: You have opened the bodyguard jobhelp");
	    SendClientMessage(playerid, 0xFF0000AA, "[Jobhelp]: Your commands are: /sellvest [Playerid]");
	    }
	    else if(PlayerJob[playerid] == 2)
	    {
	    SendClientMessage(playerid, 0xFF0000AA, "[Succes]: You have opened the hacker jobhelp");
	    SendClientMessage(playerid, 0xFF0000AA, "[Jobhelp]: Your commands are: /hack ");
	    }
	    else if(PlayerJob[playerid] == 3)
	    {
		SendClientMessage(playerid, 0xFF0000AA, "[Succes]: You have opened the Police jobhelp");
		SendClientMessage(playerid, 0xFF0000AA, "[Jobhelp]: Your commands are: /tazer | /arrest | /su(spect) | /wanted | /pu(llover) | /r(adio) | /drag | /ticket");
		}
		else if(PlayerJob[playerid] == 4)
		{
		SendClientMessage(playerid, 0xFF0000AA, "[Succes]: You have opened the Lawyer jobhelp");
		SendClientMessage(playerid, 0xFF0000AA, "[Jobhelp]: Your commands are: /defend [Playerid]");
		}
		else if(PlayerJob[playerid] == 5)
		{
		SendClientMessage(playerid, 0xFF0000AA, "[Succes]: You have opened the Hitman jobhelp");
		SendClientMessage(playerid, 0xFF0000AA, "[Jobhelp]: Your commands are: /contracts, /order");
		}
		else if(PlayerJob[playerid] == 6)
		{
		SendClientMessage(playerid, 0xFF0000AA, "[Succes]: You have opened the Robber jobhelp");
		SendClientMessage(playerid, 0xFF0000AA, "[Jobhelp]: Your commands are: /rob");
		}
		return 1;
	}
	if (strcmp("/wanteds", cmdtext, true, 10) == 0)
	{
 	if(IsPlayerConnected(playerid))
	{
				new llama;
				new wantedname[MAX_PLAYER_NAME];
				new string[56];
				SendClientMessage(playerid, 0xFF0000AA, "----- Wanted Persons -----");
                for(new players; players<MAX_PLAYERS; players++)
				if(IsPlayerConnected(players))
				{
    				if(WantedLevel[players] >= 0)
			    	{
					GetPlayerName(players, wantedname, sizeof(wantedname));
					format(string, sizeof(string), "%s%s: %d", string,wantedname,WantedLevel[players]);
					llama++;
					if(llama > 3)
					{
					SendClientMessage(playerid, 0xAA3333AA, string);
	    			llama = 0;
					format(string, sizeof(string), "");
					}
					else
					{
					format(string, sizeof(string), "%s, ", string);
					}
				}


					if(llama <= 3 && llama > 0)
					{
					string[strlen(string)-2] = '.';
				    SendClientMessage(playerid, 0xAA3333AA, string);
					}
				}
   }
  	return 1;
	}
	if (strcmp("/contracts", cmdtext, true, 10) == 0)
	{
 	if(IsPlayerConnected(playerid))
	{
	    if(PlayerJob[playerid] != 5)
	    {
	    SendClientMessage(playerid,0xFF0000AA,"[Error]: You are not a hitman!");
	    }
		else
		{
				new llama;
				new wantedname[MAX_PLAYER_NAME];
				new string[56];
				SendClientMessage(playerid, 0xFF0000AA, "----- Contracts -----");
                for(new players; players<MAX_PLAYERS; players++)
				if(IsPlayerConnected(players))
				{
    				if(IsContracted[players] == 1)
			    	{
					GetPlayerName(players, wantedname, sizeof(wantedname));
					format(string, sizeof(string), "%s%s: %d", string,wantedname,amountzzz);
					llama++;
					if(llama > 3)
					{
					SendClientMessage(playerid, 0xAA3333AA, string);
	    			llama = 0;
					format(string, sizeof(string), "");
					}
					else
					{
					format(string, sizeof(string), "%s, ", string);
					}
				}


					if(llama <= 3 && llama > 0)
					{
					string[strlen(string)-2] = '.';
				    SendClientMessage(playerid, 0xAA3333AA, string);
					}
				}
			}
		}
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
	if(pickupid == bodypickup)
	{
	GameTextForPlayer(playerid, " ~w~You are at the ~r~bodyguard job. ~w~ Type ~r~ /join ~w~ to accept the job!", 4000, 4);
	}
	if(pickupid == hackpickup)
	{
	GameTextForPlayer(playerid, " ~w~ You are at the ~r~hacker job. ~w~ Type ~r~ /join ~w~ to accept the job!", 4000, 4);
	}
	if(pickupid == policepickup)
	{
	GameTextForPlayer(playerid, " ~w~ You are at the ~r~ police officer job. ~w~ Type ~r~ /join ~w~ to accept the job!", 4000, 4);
	}
	if(pickupid == wantedpointpickup)
	{
	GameTextForPlayer(playerid, " ~r~ Arrest Point", 4000, 4);
	}
	if(pickupid == lawyerpickup)
	{
	GameTextForPlayer(playerid, " ~w~ You are at the ~r~ lawyer job. ~w~ Type ~r~ /join ~w~ to accept the job!", 4000, 4);
	}
	if(pickupid == hitmanpickup)
	{
	GameTextForPlayer(playerid, " ~w~ You are at the ~r~ hitman job. ~w~ Type ~r~ /join ~w~ to accept the job!", 4000, 4);
	}
	if(pickupid == orderpickup)
	{
	GameTextForPlayer(playerid, " ~w~ Type ~r~ /order ~w~ to ~r~ order ~w~ guns", 4000, 4);
	}
	if(pickupid == robpickup)
	{
	GameTextForPlayer(playerid, "~w~ You are at the ~r~ Robber job. ~w~ Type ~r~ /join ~w~ to accept the job!", 4000, 4);
	}
	if(pickupid == hackpcpickup)
	{
	GameTextForPlayer(playerid, "~w~ You are at the ~r~Hacker building. ~w~ Type ~r~ /hack ~w~ to start hacking!", 4000, 4);
	}
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
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public OnPlayerAcceptVestOffer(playerid)
{
	SendClientMessage(playerid, 0xFF0000AA, "[Succes]: You have sold the vest." );
	GivePlayerMoney(playerid, amount);
	return 1;
}

public OnPlayerAcceptVestOffer2(playerid)
{
	SendClientMessage(playerid, 0xFF0000AA, "[Succes]: You have bought the vest!");
	GivePlayerMoney(playerid, -amount);
	SetPlayerArmour(playerid, 50.0);
	return 1;
}

public OnPlayerAcceptDefense(playerid)
{
	SendClientMessage(playerid, 0xFF0000AA, "[Succes]: You have defended the player");
	GivePlayerMoney(playerid, amountzz);
	return 1;
}

public OnPlayerAcceptDefense2(playerid)
{
	SendClientMessage(playerid, 0xFF0000AA, "[Succes]: You have been defended");
	GivePlayerMoney(playerid, -amountzz);
	SetPlayerWantedLevel(playerid, GetPlayerWantedLevel(playerid) -1);
	WantedLevel[playerid] = GetPlayerWantedLevel(playerid);
	return 1;
}

public OnPlayerAcceptTicket(playerid)
{
	SendClientMessage(playerid, 0xFF0000AA, "[Succes]: The picket has been paid");
	GivePlayerMoney(playerid, amount);
	return 1;
}

public OnPlayerAcceptTicket2(playerid)
{
	SendClientMessage(playerid, 0xFF0000AA, "[Succes]: The ticket has been paid");
	GivePlayerMoney(playerid, -amountz);
	WantedLevel[playerid] = 0;
	SetPlayerWantedLevel(playerid, 0);
}

public tazertimer(playerid)
{
	TogglePlayerControllable(playerid, true);
	IsTazed[playerid] = 0;
	return 1;
}

public Time2Hack(playerid)
{
	SendClientMessage(playerid, 0xFF0000AA, "[Succes]: All files have been loaded");
	SendClientMessage(playerid, 0xFF0000AA, "[Hacker]: You have ten seconds to run away before everything explodes!");
	SetTimerEx("Time2Explode", 10000, false, "i", playerid);
	TogglePlayerControllable(playerid, true);
 	return 1;
}

public Anti2Hack(playerid)
{
	CanHack[playerid] = 0;
	SendClientMessage(playerid, 0xFF0000AA, "[Notice]: You can hack again!");
	return 1;
}

public Time2Explode(playerid)
{
	GivePlayerMoney(playerid, HACK_AWARD);
	GameTextForPlayer(playerid, "~b~ Mission Accomplished!", 4000, 4);
	CreateExplosion(1116.2539,-2004.2670,82.1553, 9, 20.0);
	CreateExplosion(1115.8361,-2011.8665,74.4297, 6, 20.0);
	CreateExplosion(1115.9530,-2014.0562,74.4297, 6, 20.0);
	CreateExplosion(1116.1201,-2017.1725,74.4297, 6, 20.0);
	CreateExplosion(1116.2958,-2020.4607,74.4297, 6, 20.0);
	CreateExplosion(1116.4860,-2024.0175,74.4297, 9, 20.0);
	CreateExplosion(1116.6676,-2027.4211,74.4297, 6, 20.0);
	CreateExplosion(1117.3436,-2032.3817,77.3166, 6, 20.0);
	CreateExplosion(1117.8354,-2036.4893,78.7500, 6, 20.0);
	CreateExplosion(1117.9467,-2043.3848,78.2187, 6, 20.0);
	CreateExplosion(1118.0891,-2050.3115,74.4297, 6, 20.0);
	CreateExplosion(1117.4946,-2054.6250,74.4297, 9, 20.0);
	CreateExplosion(1117.1321,-2056.7988,74.4297, 6, 20.0);
	CreateExplosion(1116.6288,-2059.8152,74.4297, 6, 20.0);
	CreateExplosion(1116.1436,-2062.7239,74.4297, 6, 20.0);
	CreateExplosion(1116.4359,-2069.1660,82.1472, 6, 20.0);
	CreateExplosion(1104.8898,-2037.4963,74.4647, 6, 20.0);
	CreateExplosion(1101.3552,-2036.5464,81.3554, 9, 20.0);
	CreateExplosion(1095.7667,-2036.2343,81.4578, 6, 20.0);
	CreateExplosion(1125.5189,-2011.2540,69.0078, 6, 20.0);
	CreateExplosion(1125.5337,-2014.2014,69.0078, 6, 20.0);
	CreateExplosion(1125.9061,-2017.9900,69.0078, 9, 20.0);
	CreateExplosion(1126.3292,-2022.2958,69.0078, 6, 20.0);
	CreateExplosion(1127.3964,-2028.4117,69.0078, 6, 20.0);
	CreateExplosion(1127.5044,-2031.7402,69.8654, 6, 20.0);
	CreateExplosion(1127.6559,-2036.4146,69.8120, 6, 20.0);
	CreateExplosion(1127.8129,-2041.2634,69.7493, 6, 20.0);
	CreateExplosion(1127.9932,-2046.8412,69.0078, 9, 20.0);
	CreateExplosion(1128.1393,-2051.3540,69.0078, 6, 20.0);
	CreateExplosion(1128.2678,-2055.3220,69.0078, 6, 20.0);
	CreateExplosion(1128.3909,-2059.1348,69.0078, 6, 20.0);
	CreateExplosion(1171.7727,-2038.8571,69.0078, 6, 20.0);
	CreateExplosion(1172.1289,-2035.3053,69.0078, 6, 20.0);
	CreateExplosion(1174.8809,-2034.0485,69.0078, 9, 20.0);
	CreateExplosion(1177.3298,-2034.6859,69.0078, 6, 20.0);
	CreateExplosion(1178.3862,-2037.0609,69.0078, 6, 20.0);
	CreateExplosion(1177.2159,-2039.1716,69.0078, 6, 20.0);
	CreateExplosion(1174.3842,-2039.6628,69.0078,6, 20.0);
	CreateExplosion(1174.9976,-2036.9447,71.4376,9,20.0);
	CreateExplosion(1174.9976,-2036.9447,73.3316,6,20.0);
	CreateExplosion(1174.9976,-2036.9447,75.3782,6,20.0);
	CreateExplosion(1174.9976,-2036.9447,76.3694,6, 20.0);
	return 1;
}
public SetPlayerJailed(playerid)
{
	SetPlayerPos(playerid, 264.0470,77.4918,1001.0391);
	SetPlayerInterior(playerid, 6);
	SetTimerEx("OnPlayerJailed", time * 60000, false, "u", playerid);
	TogglePlayerControllable(playerid, true);
	IsTazed[playerid] = 0;
	WantedLevel[playerid] = 0;
	IsCuffed[playerid] = 0;
	SetPlayerWantedLevel(playerid, 0);
	return 1;
}
public OnPlayerJailed(playerid)
{
	SetPlayerPos(playerid,1529.6, -1691.2, 13.3);
	SetPlayerInterior(playerid, 0);
	TogglePlayerControllable(playerid,true);
	GameTextForPlayer(playerid, "~g~ Freedom!", 4000, 4);
	return 1;
}

public SendCopsMessage(color, string[])
{
for(new players=0; players<MAX_PLAYERS; players++)
{
if(PlayerJob[players] == 3)
{
SendClientMessage(players,color,string);
}
}
return 1;
}

public SendHitmansMessage(color, string[])
{
for(new players=0; players<MAX_PLAYERS; players++)
{
if(PlayerJob[players] == 5)
{
SendClientMessage(players,color,string);
}
}
return 1;
}

public SendRconAdminMessage(playerid, color, string[])
{
for(new players=0; players<MAX_PLAYERS; players++)
{
if(IsPlayerAdmin(playerid))
{
SendClientMessage(players,color,string);
}
}
return 1;
}
// ------ SSCANF COMMANDS ------ //

dcmd_p(playerid, params[])
{
	if(PlayerJob[playerid] != 3)
	{
	    SendClientMessage(playerid, 0xFF0000AA, "[Error]: You are not a police officer!");
	}
	if(PlayerJob[playerid] == 3)
	{
	    new PlayerName[MAX_PLAYER_NAME];
		new string[128];
		if(sscanf(params,"s", string)) return SendClientMessage(playerid, 0xFFFFFFFF, "[Error]: Usage: /p [message]");
		GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
		format(string, sizeof(string), "[OFFICER] %s: %s, over.", PlayerName, string);
		SendCopsMessage(0xCCCCCC00, string);
    	}
 	return 1;
}

dcmd_f(playerid, params[])
{
	new string[128];
	if(sscanf(params,"s",string)) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: Usage: /f [Message]");
	if(PlayerJob[playerid] != 5) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: You are not a hitman!");
	if(PlayerJob[playerid] == 5)
	{
	    new PlayerName[MAX_PLAYER_NAME];
		GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
		format(string, sizeof(string), "[Radio]: Hitman %s: %s, over.", PlayerName, string);
		SendHitmansMessage(0xCCCCCC00, string);
	}
	return 1;
}

dcmd_rob(playerid, params[])
{
	new string[128],
		PlayerName[MAX_PLAYER_NAME],
		OtherName[MAX_PLAYER_NAME],
		id,
		robamount;
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: Usage: /rob [Playerid]");
	if(PlayerJob[playerid] != 6) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: You are not a robber!");
	else
	{
	    robamount = GetPlayerMoney(id) / 1000;
	    GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
	    GetPlayerName(id, OtherName, sizeof(OtherName));
	    format(string, sizeof(string), "[Succes]: You have robbed $%d from %s!", robamount, OtherName);
	    SendClientMessage(playerid, 0xFF0000AA, string);
	    format(string, sizeof(string), "[Rob]: You have been robbed by %s! He stole $%d from you!", PlayerName, robamount);
	    SendClientMessage(id, 0xFF0000AA, string);
	    GivePlayerMoney(playerid, robamount);
	    GivePlayerMoney(id, -robamount);
		if(GetPlayerWantedLevel(playerid) == 0)
		{
		SetPlayerWantedLevel(playerid, 4);
		}
		if(GetPlayerWantedLevel(playerid) == 1)
		{
		SetPlayerWantedLevel(playerid, 5);
		}
		if(GetPlayerWantedLevel(playerid) == 2)
		{
		SetPlayerWantedLevel(playerid, 6);
		}
		if(GetPlayerWantedLevel(playerid) == 3 || GetPlayerWantedLevel(playerid) >= 3)
		{
		SetPlayerWantedLevel(playerid, 6);
		}
		WantedLevel[playerid] = GetPlayerWantedLevel(playerid);
	}
	return 1;
}

dcmd_drag(playerid, params[])
{
new id,
	PlayerName[MAX_PLAYER_NAME],
	WantedName[MAX_PLAYER_NAME],
	string[128];
if(sscanf(params,"u", id)) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: Usage: /drag [Playerid]");
if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: That player doesn't exist!");
if(PlayerJob[playerid] != 3) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: You are not a police officer!");
if(IsCuffed[id] == 0) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: That player is not cuffed!");
if(PlayerJob[playerid] == 3 || IsCuffed[id] == 1)
{
new Float:X,Float:Y,Float:Z;
GetPlayerPos(playerid, X, Y, Z);
GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
GetPlayerName(id, WantedName, sizeof(WantedName));
SetPlayerPos(id, X, Y, Z);
SetPlayerInterior(id, GetPlayerInterior(playerid));
format(string, sizeof(string), "You have been dragged by officer %s ", PlayerName);
SendClientMessage(playerid,0xFF0000AA,string);
format(string, sizeof(string), "[Succes]: You have dragged %s ", WantedName);
SendClientMessage(playerid,0xFF0000AA,string);
}
return 1;
}

dcmd_order(playerid, params[])
{
new weaponz;

if(PlayerJob[playerid] != 5) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: You are not a hitman");
if(sscanf(params, "d", weaponz))
{
	SendClientMessage(playerid, 0xFF0000AA, "[Error]: Usage: /order <weaponid>");
	SendClientMessage(playerid, 0xFF0000AA, "[Info]: Deagle = 1 ( $2000 ) | AK-47 = 2 ( $5000 ) | M4 = 3 ( $7000 ) | Spas-12 = 4 ( $10000 ) ");
	SendClientMessage(playerid, 0xFF0000AA, "[Info]: Knife = 5 ( $500 )| Sniper = 6 ( $10000 ) | MP5 = 7 ( $1500 ) | Shotgun = 8 ( $1000 )  ");
}
if(!IsPlayerInRangeOfPoint(playerid, 20.0, 681.3100,-444.6037,16.3359)) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: You are not at the orderplace!");
else
{
	if(weaponz == 1)
	{
	    if(GetPlayerMoney(playerid) <= 2000)
	    {
	    SendClientMessage(playerid, 0xFF0000AA, "[Error]: Not enough money!");
	    }
	    else
	    {
		GivePlayerWeapon(playerid, 24, 99999);
		GivePlayerMoney(playerid, -2000);
		}
	}
	if(weaponz == 2)
	{
	    if(GetPlayerMoney(playerid) <= 5000)
	    {
	    SendClientMessage(playerid, 0xFF0000AA, "[Error]: Not enough money!");
	    }
	    else
	    {
		GivePlayerWeapon(playerid, 30, 99999);
		GivePlayerMoney(playerid, -5000);
		}
	}
 	if(weaponz == 3)
	{
	    if(GetPlayerMoney(playerid) <= 7000)
	    {
	    SendClientMessage(playerid, 0xFF0000AA, "[Error]: Not enough money!");
	    }
	    else
	    {
		GivePlayerWeapon(playerid, 31, 99999);
		GivePlayerMoney(playerid, -7000);
		}
	}
 	if(weaponz == 4)
	{
	    if(GetPlayerMoney(playerid) <= 10000)
	    {
	    SendClientMessage(playerid, 0xFF0000AA, "[Error]: Not enough money!");
	    }
	    else
	    {
		GivePlayerWeapon(playerid, 27, 99999);
		GivePlayerMoney(playerid, -10000);
		}
	}
	if(weaponz == 5)
	{
	    if(GetPlayerMoney(playerid) <= 500)
	    {
	    SendClientMessage(playerid, 0xFF0000AA, "[Error]: Not enough money!");
	    }
	    else
	    {
		GivePlayerWeapon(playerid, 4, 99999);
		GivePlayerMoney(playerid, -500);
		}
	}
 	if(weaponz == 6)
	{
	    if(GetPlayerMoney(playerid) <= 10000)
	    {
	    SendClientMessage(playerid, 0xFF0000AA, "[Error]: Not enough money!");
	    }
	    else
	    {
		GivePlayerWeapon(playerid, 34, 99999);
		GivePlayerMoney(playerid, -10000);
		}
	}
	if(weaponz == 7)
	{
	    if(GetPlayerMoney(playerid) <= 1500)
	    {
	    SendClientMessage(playerid, 0xFF0000AA, "[Error]: Not enough money!");
	    }
	    else
	    {
		GivePlayerWeapon(playerid, 29, 99999);
		GivePlayerMoney(playerid, -2000);
		}
	}
 	if(weaponz == 8)
	{
	    if(GetPlayerMoney(playerid) <= 1000)
	    {
	    SendClientMessage(playerid, 0xFF0000AA, "[Error]: Not enough money!");
	    }
	    else
	    {
		GivePlayerWeapon(playerid, 25, 99999);
		GivePlayerMoney(playerid, -2000);
		}
	}
}
return 1;
}

dcmd_arrest(playerid, params[])
{
	new id,
	    PlayerName[MAX_PLAYER_NAME],
	    WantedName[MAX_PLAYER_NAME],
	    fine,
	    string[128],
	    string2[128],
	    string3[128];
	if(sscanf(params,"udd", id, fine, time)) return SendClientMessage(playerid, 0xFF0000AA, "[Error] Usage: /arrest [Playerid] [Fine] [Time]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: That player doesn't exist!");
	if(PlayerJob[playerid] != 3) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: You are not a police officer");
	if(IsCuffed[id] == 0) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: That player is not cuffed!");
	if(WantedLevel[id] == 0) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: That player is not wanted!");
	if(!IsPlayerInRangeOfPoint(playerid, 20.0, 1528.2760,-1677.7377,5.8906)) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: You are not at the arrest point!");
	if(!IsPlayerInRangeOfPoint(id, 20.0, 1528.2760,-1677.7377,5.8906)) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: That player is not at the arrest point!");
	if(fine >= MAX_ARREST_FINE) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: That fine is too high!");
	if(fine <= MINIMUM_ARREST_FINE) return SendClientMessage(playerid, 0xFF0000AA, "[Error] That fine is too low!");
	if(time >= MAX_ARREST_JAIL_TIME) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: That time is too long!");
	if(time <= MIN_ARREST_JAIL_TIME) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: That time is too short!");
	if(PlayerJob[playerid] == 3)
	{
	if(IsPlayerInRangeOfPoint(playerid, 20.0, 1528.2760,-1677.7377,5.8906) && IsPlayerInRangeOfPoint(id, 20.0, 1528.2760,-1677.7377,5.8906) && IsCuffed[id] == 1 && WantedLevel[id] >= 0)
	{
	GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
	GetPlayerName(playerid, WantedName, sizeof(WantedName));
	SetPlayerJailed(id);
	format(string, sizeof(string), "[Radio]: All units: %s has arrested %s for %d minutes and recieved $%d", PlayerName, WantedName,time, fine);
	SendCopsMessage(0xCCCCCC00, string);
	format(string2, sizeof(string2), "[Government]: You have been arrested by %s for %d minutes and lost $%d", PlayerName, time, fine);
	SendClientMessage(id, 0xFF0000AA, string2);
	format(string3, sizeof(string3), "[Succes]: You have arrested %s for %d minutes and gained $%d", WantedName, time, fine);
	SendClientMessage(playerid, 0xFF0000AA, string3);
	GivePlayerMoney(playerid, fine);
	GivePlayerMoney(id, -fine);
	}
	}
	return 1;
}
	

dcmd_tazer(playerid, params[])
{
	new id;
	new Float:X,Float:Y,Float:Z;
	if(sscanf(params,"u", id)) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: Usage: /tazer [Playerid]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: That player doesn't exist!");
	if(IsCuffed[id] == 1) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: That player is already cuffed!");
	if(PlayerJob[playerid] != 3)
	{
		SendClientMessage(playerid, 0xFF0000AA, "[Error]: You are not a police officer!");
	}
	if(PlayerJob[playerid] == 3)
	{
	GetPlayerPos(id, X, Y, Z);
 	if(IsPlayerInRangeOfPoint(playerid, 20.0, X, Y, Z))
	{
		TogglePlayerControllable(id, false);
		IsTazed[id] = 1;
		GameTextForPlayer(id, "~r~ tazed!", 4000, 4);
		taz = SetTimerEx("tazertimer", 7000, false, "u", id);
		SendClientMessage(playerid, 0xFF0000AA, "[Succes] You have tazed the player");
		SendClientMessage(id, 0xFF0000AA, "You have been tazed by an officer");
	}
	}
	return 1;
 }

dcmd_cuff(playerid, params[])
{
	new id,
	    PlayerName[MAX_PLAYER_NAME],
	    WantedName[MAX_PLAYER_NAME],
	    string[128];
	if(sscanf(params,"u", id)) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: Usage: /cuff [Playerid]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: That player doesn't exist!");
	if(PlayerJob[playerid] != 3) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: You are not a police officer!");
	if(IsCuffed[id] == 1) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: That player is already cuffed!");
	if(IsTazed[id] == 0) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: You need to taze this player first!");
	if(PlayerJob[playerid] == 3 && IsCuffed[id] == 0 || IsTazed[id] == 1)
	{
	IsCuffed[id] = 1;
	IsTazed[id] = 0;
	TogglePlayerControllable(id, false);
	GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
	GetPlayerName(id, WantedName, sizeof(WantedName));
	format(string, sizeof(string), "You have been cuffed by officer %s", PlayerName);
	SendClientMessage(id, 0xFF0000AA, string);
	format(string, sizeof(string), "[Succes]: You have cuffed %s", WantedName);
	SendClientMessage(playerid, 0xFF0000AA, string);
	KillTimer(taz);
	}
	return 1;
}

dcmd_uncuff(playerid, params[])
{
	new id,
	    PlayerName[MAX_PLAYER_NAME],
	    WantedName[MAX_PLAYER_NAME],
	    string[128];
	if(sscanf(params,"u", id)) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: Usage: /uncuff [Playerid]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: That player doesn't exist!");
	if(PlayerJob[playerid] != 3) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: You are not a police officer!");
	if(IsCuffed[id] == 0) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: That player is not cuffed");
	else
	{
	IsCuffed[id] = 0;
	IsTazed[id] = 0;
	TogglePlayerControllable(id, true);
	GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
	GetPlayerName(id, WantedName, sizeof(WantedName));
	format(string, sizeof(string), "You have been uncuffed by officer %s", PlayerName);
	SendClientMessage(id, 0xFF0000AA, string);
	format(string, sizeof(string), "[Succes]: You have uncuffed %s", WantedName);
	SendClientMessage(playerid, 0xFF0000AA, string);
	}
	return 1;
}

dcmd_su(playerid, params[])
{
	new id;
 	new reason[128];
	if(sscanf(params,"uz", id, reason)) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: Usage: /su [Playerid] [Reason]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: That player doesn't exist!");
	if(PlayerJob[playerid] != 3) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: You are not a police officer!");
	if(GetPlayerWantedLevel(id) == 6) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: That player is already most wanted!");
	if(PlayerJob[playerid] == 3)
	{
	    new PlayerName[MAX_PLAYER_NAME];
	    new WantedName[MAX_PLAYER_NAME];
	    GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
	    GetPlayerName(id, WantedName, sizeof(WantedName));
	    format(reason, sizeof (reason), "[Government]: %s has su'd %s for %s", PlayerName, WantedName, reason);
	    SendClientMessageToAll(0xFF0000AA, reason);
		SetPlayerWantedLevel(id, GetPlayerWantedLevel(playerid) + 1);
		WantedLevel[id] = GetPlayerWantedLevel(playerid);
	}
	return 1;
}

dcmd_contract(playerid, params[])
{
	new id;
	new PlayerName[MAX_PLAYER_NAME];
	new OtherName[MAX_PLAYER_NAME];
	new string[128];
	if(sscanf(params,"ud", id, amountzzz)) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: Usage: /contract [Playerid] [Amount]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: That player does not exist!");
	if(GetPlayerMoney(playerid) <= amountzzz) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: You don't have enough money!");
	if(IsContracted[id] == 1) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: That player is already contracted!");
	if(PlayerJob[playerid] == 5) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: Hitmans can't put contracts on people!");
	if(amountzzz >= MAX_CONTRACT_AMOUNT) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: That amount is too high!");
	if(amountzzz <= MIN_CONTRACT_AMOUNT) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: That amount is too low!");
	else
	{
	GetPlayerName(id, PlayerName, sizeof(PlayerName));
	GetPlayerName(playerid, OtherName, sizeof(OtherName));
	format(string, sizeof(string), "[Radio]: %s has contracted %s! Amount: %d", OtherName, PlayerName, amountzzz);
	SendHitmansMessage(0xCCCCCC00, string);
	format(string, sizeof(string), "[Succes]: You have contracted %s for %d", OtherName, amountzzz);
	SendClientMessage(playerid, 0xFF0000AA, string);
	IsContracted[id] = 1;
	}
	return 1;
}
	

dcmd_pu(playerid, params[])
{
	new id;
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: That player doesn't exist!");
	if(PlayerJob[playerid] != 3)
	{
	    SendClientMessage(playerid, 0xFF0000AA, "[Error]: You are not a police officer!");
	}
	if(PlayerJob[playerid] == 3)
	{
	    new PlayerName[MAX_PLAYER_NAME];
	    new PullName[MAX_PLAYER_NAME];
	    new string[128];
	    if(sscanf(params,"u", id)) return SendClientMessage(playerid, 0xFF0000AA, "[Error]: Usage: /pu [Playerid]");
	    GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
	    GetPlayerName(id, PullName, sizeof(PullName));
	    format(string, sizeof(string), "[Government]: Officer %s has asked you ' %s ' to pullover", PlayerName, PullName);
	    SendClientMessage(id, 0xFF0000AA, string);
	    format(string, sizeof(string), "[Job]: You have asked %s to pullover", PullName);
	    SendClientMessage(playerid, 0xFF0000AA, string);
	}
	return 1;
 }

dcmd_sellvest(playerid, params[])
{
	new
		id,
		Float:X,Float:Y,Float:Z,
		string[256];
	GetPlayerPos(id,X,Y,Z);
	if (sscanf(params, "ud", id, amount)) SendClientMessage(playerid, 0xFF0000AA, "[Error]: Usage: \"/sellvest <playerid> <amount>\"");
	else if (id == INVALID_PLAYER_ID) SendClientMessage(playerid, 0xFF0000AA, "[Error]: That is not a valid player.");
	else if(PlayerJob[playerid] != 1) SendClientMessage(playerid, 0xFF0000AA, "[Error]: You are not a bodyguard!");
	else if(PlayerJob[playerid] == 1)
	{
	if(IsPlayerInRangeOfPoint(playerid,20,X,Y,Z))
	{
	new bodyid[MAX_PLAYER_NAME];
	new customid[MAX_PLAYER_NAME];
 	GetPlayerName(playerid, bodyid, sizeof(bodyid));
  	GetPlayerName(id, customid, sizeof(customid));
   	format(string, sizeof(string), "[Server]: You have offered %s a vest for %d",customid, amount);
	SendClientMessage(playerid, 0xFF0000AA, string);
	format(string, sizeof(string), "[Server]: %s has offered you a vest for %d. Type /acceptvest to accept %s's offer!",bodyid, amount, customid);
 	SendClientMessage(id, 0xFF0000AA, string);
	PlayerOffered[id] = playerid;
	}
	}
	else if(!IsPlayerInRangeOfPoint(playerid,20,X,Y,Z))
	{
	SendClientMessage(playerid, 0xFF0000AA, " You're too far away from that player!");
	}
	return 1;
}

dcmd_ticket(playerid, params[])
{
	new
	    id,
	    Float:X,Float:Y,Float:Z,
	    string[256],
	    reason;
	GetPlayerPos(id, X, Y, Z);
	if (sscanf(params, "udz", id, amountz, reason)) SendClientMessage(playerid, 0xFF0000AA, "[Error]: Usage: /ticket [Playerid] [Amount] [Reason]");
	else if (id == INVALID_PLAYER_ID) SendClientMessage(playerid, 0xFF0000AA, "[Error]: That is not a valid player.");
	else if(PlayerJob[playerid] != 3) SendClientMessage(playerid, 0xFF0000AA, "[Error]: You are not a police officer");
	else if(!IsPlayerInRangeOfPoint(playerid,20.0,X,Y,Z)) SendClientMessage(playerid, 0xFF0000AA, "[Error]: You are too far away from that player!");
	else if(PlayerJob[playerid] == 3)
	{
		if(IsPlayerInRangeOfPoint(playerid,20.0,X,Y,Z))
		{
		new PlayerName[MAX_PLAYER_NAME];
		new WantedName[MAX_PLAYER_NAME];
		GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
		GetPlayerName(id, WantedName, sizeof(WantedName));
		format(string, sizeof(string), "[Server]: You have given %s a ticket of %d. Reason: %z", WantedName, amountz, reason);
		SendClientMessage(playerid, 0xFF0000AA, string);
		format(string, sizeof(string), "[Server]: Officer %s has given you a ticket of %d. Reason: %z. Type /acceptticket to pay.");
		SendClientMessage(id, 0xFF0000AA, string);
		PlayerTicket[id] = playerid;
		}
	}
	return 1;
}

dcmd_defend(playerid, params[])
{
	new
	    id,
	    Float:X,Float:Y,Float:Z,
	    string[256];
	GetPlayerPos(id, X, Y, Z);
	if (sscanf(params, "ud", id, amountzz)) SendClientMessage(playerid, 0xFF0000AA, "[Error]: Usage: /defend [Playerid] [Amount]");
	else if(id == INVALID_PLAYER_ID) SendClientMessage(playerid, 0xFF0000AA, "[Error]: That is not a valid player.");
	else if(PlayerJob[playerid] != 4) SendClientMessage(playerid, 0xFF0000AA, "[Error]: You are not a lawyer!");
	else if(WantedLevel[id] == 0) SendClientMessage(playerid, 0xFf0000AA, "[Error]: That player is not wanted");
	else if(amountzz >= MAX_DEFEND_AMOUNT) SendClientMessage(playerid, 0xFF0000AA, "[Error]: That amount is too high!");
	else if(amountzz <= MIN_DEFEND_AMOUNT) SendClientMessage(playerid, 0xFF0000AA, "[Error]]: That amount is too low!");
	else if(!IsPlayerInRangeOfPoint(playerid, 20.0, X, Y, Z)) SendClientMessage(playerid, 0xFF0000AA, "[Error]: You are too far away from that player!");
	else if(PlayerJob[playerid] == 4)
	{
	    if(IsPlayerInRangeOfPoint(playerid,20.0,X,Y,Z))
	    {
	    new PlayerName[MAX_PLAYER_NAME];
	    new WantedName[MAX_PLAYER_NAME];
	    GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
	    GetPlayerName(id, WantedName, sizeof(WantedName));
	    format(string, sizeof(string), "[Server]: You have offered defense to %s for %d", WantedName, amountzz);
	    SendClientMessage(playerid, 0xFF0000AA, string);
	    format(string, sizeof(string), "[Server]: %s has offered defense to you for %d, type /acceptdefense to accept", PlayerName, amountzz);
	    SendClientMessage(id, 0xFF0000AA, string);
	    PlayerDefense[id] = playerid;
	    }
	}
	return 1;
}



/*----------------------------------------------------------------------------*-
Function:
	sscanf
Params:
	string[] - String to extract parameters from.
	format[] - Parameter types to get.
	{Float,_}:... - Data return variables.
Return:
	0 - Successful, not 0 - fail.
Notes:
	A fail is either insufficient variables to store the data or insufficient
	data for the format string - excess data is disgarded.

	A string in the middle of the input data is extracted as a single word, a
	string at the end of the data collects all remaining text.

	The format codes are:

	c - A character.
	d, i - An integer.
	h, x - A hex number (e.g. a colour).
	f - A float.
	s - A string.
	z - An optional string.
	pX - An additional delimiter where X is another character.
	'' - Encloses a litteral string to locate.
	u - User, takes a name, part of a name or an id and returns the id if they're connected.

	Now has IsNumeric integrated into the code.

	Added additional delimiters in the form of all whitespace and an
	optioanlly specified one in the format string.
-*----------------------------------------------------------------------------*/

stock sscanf(string[], format[], {Float,_}:...)
{
	#if defined isnull
		if (isnull(string))
	#else
		if (string[0] == 0 || (string[0] == 1 && string[1] == 0))
	#endif
		{
			return format[0];
		}
	#pragma tabsize 4
	new
		formatPos = 0,
		stringPos = 0,
		paramPos = 2,
		paramCount = numargs(),
		delim = ' ';
	while (string[stringPos] && string[stringPos] <= ' ')
	{
		stringPos++;
	}
	while (paramPos < paramCount && string[stringPos])
	{
		switch (format[formatPos++])
		{
			case '\0':
			{
				return 0;
			}
			case 'i', 'd':
			{
				new
					neg = 1,
					num = 0,
					ch = string[stringPos];
				if (ch == '-')
				{
					neg = -1;
					ch = string[++stringPos];
				}
				do
				{
					stringPos++;
					if ('0' <= ch <= '9')
					{
						num = (num * 10) + (ch - '0');
					}
					else
					{
						return -1;
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num * neg);
			}
			case 'h', 'x':
			{
				new
					num = 0,
					ch = string[stringPos];
				do
				{
					stringPos++;
					switch (ch)
					{
						case 'x', 'X':
						{
							num = 0;
							continue;
						}
						case '0' .. '9':
						{
							num = (num << 4) | (ch - '0');
						}
						case 'a' .. 'f':
						{
							num = (num << 4) | (ch - ('a' - 10));
						}
						case 'A' .. 'F':
						{
							num = (num << 4) | (ch - ('A' - 10));
						}
						default:
						{
							return -1;
						}
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num);
			}
			case 'c':
			{
				setarg(paramPos, 0, string[stringPos++]);
			}
			case 'f':
			{

				new changestr[16], changepos = 0, strpos = stringPos;
				while(changepos < 16 && string[strpos] && string[strpos] != delim)
				{
					changestr[changepos++] = string[strpos++];
    				}
				changestr[changepos] = '\0';
				setarg(paramPos,0,_:floatstr(changestr));
			}
			case 'p':
			{
				delim = format[formatPos++];
				continue;
			}
			case '\'':
			{
				new
					end = formatPos - 1,
					ch;
				while ((ch = format[++end]) && ch != '\'') {}
				if (!ch)
				{
					return -1;
				}
				format[end] = '\0';
				if ((ch = strfind(string, format[formatPos], false, stringPos)) == -1)
				{
					if (format[end + 1])
					{
						return -1;
					}
					return 0;
				}
				format[end] = '\'';
				stringPos = ch + (end - formatPos);
				formatPos = end + 1;
			}
			case 'u':
			{
				new
					end = stringPos - 1,
					id = 0,
					bool:num = true,
					ch;
				while ((ch = string[++end]) && ch != delim)
				{
					if (num)
					{
						if ('0' <= ch <= '9')
						{
							id = (id * 10) + (ch - '0');
						}
						else
						{
							num = false;
						}
					}
				}
				if (num && IsPlayerConnected(id))
				{
					setarg(paramPos, 0, id);
				}
				else
				{
					#if !defined foreach
						#define foreach(%1,%2) for (new %2 = 0; %2 < MAX_PLAYERS; %2++) if (IsPlayerConnected(%2))
						#define __SSCANF_FOREACH__
					#endif
					string[end] = '\0';
					num = false;
					new
						name[MAX_PLAYER_NAME];
					id = end - stringPos;
					foreach (Player, playerid)
					{
						GetPlayerName(playerid, name, sizeof (name));
						if (!strcmp(name, string[stringPos], true, id))
						{
							setarg(paramPos, 0, playerid);
							num = true;
							break;
						}
					}
					if (!num)
					{
						setarg(paramPos, 0, INVALID_PLAYER_ID);
					}
					string[end] = ch;
					#if defined __SSCANF_FOREACH__
						#undef foreach
						#undef __SSCANF_FOREACH__
					#endif
				}
				stringPos = end;
			}
			case 's', 'z':
			{
				new
					i = 0,
					ch;
				if (format[formatPos])
				{
					while ((ch = string[stringPos++]) && ch != delim)
					{
						setarg(paramPos, i++, ch);
					}
					if (!i)
					{
						return -1;
					}
				}
				else
				{
					while ((ch = string[stringPos++]))
					{
						setarg(paramPos, i++, ch);
					}
				}
				stringPos--;
				setarg(paramPos, i, '\0');
			}
			default:
			{
				continue;
			}
		}
		while (string[stringPos] && string[stringPos] != delim && string[stringPos] > ' ')
		{
			stringPos++;
		}
		while (string[stringPos] && (string[stringPos] == delim || string[stringPos] <= ' '))
		{
			stringPos++;
		}
		paramPos++;
	}
	do
	{
		if ((delim = format[formatPos++]) > ' ')
		{
			if (delim == '\'')
			{
				while ((delim = format[formatPos++]) && delim != '\'') {}
			}
			else if (delim != 'z')
			{
				return delim;
			}
		}
	}
	while (delim > ' ');
	return 0;
}
