/*


Idea by Juan

Scripting by Agusfn
*/

  /////////////////////////////////////////
 //   Pershing Square Car Park V3.5     //
/////////////////////////////////////////

#include <a_samp>
#include <Dini>
#pragma unused ret_memcpy
#define ParkFile "Parking.txt"

#define FILTERSCRIPT
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_WHITE
#define COLOR_GREEN 0x33AA33AA
#define COLOR_ULTRARED 0xFF0606FF
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_PURPLE 0xC2A2DAAA

forward ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5);
forward ProxDetectorS(Float:radi, playerid, targetid);
forward PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z);
forward GateClose();
forward Gate2Close();
forward Gate3Close();

new ParkingPrice = 1000; // Price of the inscription
new PanelTimer = 4000; // Time before closing the white pantel; 4 seconds
new DoorTimer = 3000; // Time before closing the door; 3 seconds
new GateTimer = 6000; // Time before closing the vehicle gate; 6 seconds
new Door;
new Gate;
new Door2;
new Registered[MAX_PLAYERS];

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Pershing Square Parking v3.5 English   ");
 	print(" By Agusfn20!						   ");
 	print(" Filterscript Loaded 				   ");
	print("--------------------------------------\n");
	if(!dini_Exists(ParkFile)) dini_Create(ParkFile);

	CreateObject(973, 1579.8, -1751.0, 13.2, 0.0, 0.0, 90.0);
	CreateObject(973, 1579.9, -1757.5, 13.2, 0.0, 0.0, 90.0);
	CreateObject(973, 1367.9, -1573.9, 13.2, 0.0, 0.0, 164.0);
	CreateObject(973, 1362.9, -1592.2, 13.3, 0.0, 0.0, -16.0);
	CreateObject(973, 1401.8, -1450.5, 13.2, 0.0, 0.0, 0.0);
	CreateObject(974, 1680.6, -1678.9, 20.6, 0.0, 0.0, 90.0);
	CreateObject(974, 1680.7, -1667.5, 20.6, 0.0, 0.0, 90.0);
	CreateObject(984, 1680.6, -1675.8, 24.0, 0.0, 0.0, 0.0);
	CreateObject(983, 1680.6, -1667.4, 24.0, 0.0, 0.0, 0.0);
	CreateObject(3850, 1684.6, -1682.0, 20.5, 0.0, 0.0, 90.0);
	CreateObject(3850, 1688.1, -1682.0, 20.5, 0.0, 0.0, 90.0);
	CreateObject(3850, 1691.7, -1682.0, 20.5, 0.0, 0.0, 90.0);
	CreateObject(3850, 1695.1, -1682.0, 20.5, 0.0, 0.0, 90.0);
	CreateObject(3850, 1684.4, -1664.3, 20.5, 0.0, 0.0, 90.0);
	CreateObject(3850, 1688.0, -1664.3, 20.4, 0.0, 0.0, 90.0);
	CreateObject(3850, 1691.5, -1664.3, 20.5, 0.0, 0.0, 90.0);
	CreateObject(3850, 1695.0, -1664.2, 20.5, 0.0, 0.0, 90.0);
	CreateObject(1495, 1638.3, -1673.4, 14.2, 0.0, 0.0, 180.0);
	CreateObject(983, 1638.6, -1673.6, 17.4, 0.0, -28.0, 90.0);
	CreateObject(970, 1635.3, -1672.5, 15.9, 0.0, -38.0, 90.0);
	CreateObject(1419, 1637.3, -1668.6, 17.3, 0.0, 0.0, 0.0);
	CreateObject(1419, 1639.6, -1668.4, 21.8, 0.0, 0.0, 90.0);
	CreateObject(1233, 1534.798706, -1681.711914, 14.106555, 0.0, 0.0, 0.0);
	CreateObject(4639, 1637.3, -1706.8, 14.0, 0.0, 0.0, -120.0);
	CreateObject(1215, 1644.4, -1709.1, 15.1, 0.0, 0.0, 0.0);
	CreateObject(1215, 1662.5, -1692.0, 15.1, 0.0, 0.0, 0.0);
	CreateObject(1215, 1672.3, -1719.3, 15.1, 0.0, 0.0, 0.0);
	CreateObject(1215, 1644.0, -1719.4, 15.1, 0.0, 0.0, 0.0);
	CreateObject(1215, 1672.1, -1696.8, 15.1, 0.0, 0.0, 0.0);
	CreateObject(1215, 1644.6, -1691.4, 15.1, 0.0, 0.0, 0.0);
	CreateObject(1215, 1631.2, -1708.3, 17.9, 0.0, 0.0, 0.0);
	CreateObject(1215, 1643.1, -1719.6, 19.8, 0.0, 0.0, 0.0);
	CreateObject(1215, 1659.9, -1692.9, 19.8, 0.0, 0.0, 0.0);
	CreateObject(1215, 1674.0, -1693.0, 19.8, 0.0, 0.0, 0.0);
	CreateObject(1215, 1674.5, -1719.5, 19.8, 0.0, 0.0, 0.0);
	CreateObject(1215, 1643.4, -1692.8, 19.8, 0.0, 0.0, 0.0);
	CreateObject(1215, 1641.3, -1706.4, 21.1, 0.0, 0.0, 0.0);
	CreateObject(1215, 1634.8, -1697.0, 16.3, 0.0, 0.0, 0.0);
	CreateObject(1215, 1641.0, -1683.9, 21.7, 0.0, 0.0, 0.0);
	CreateObject(970, 1640.5, -1693.5, 16.5, 0.0, 8.0, 9.0);
	CreateObject(1215, 1638.1, -1716.9, 19.5, 0.0, 0.0, 0.0);
	CreateObject(800, 1640.5, -1684.9, 21.8, 0.0, 0.0, 90.0);
	Gate = 	CreateObject(969, 1643.3, -1719.5, 14.6, 0.0, 0.0, 90.0);
	Door = CreateObject(1495, 1635.5, -1673.4, 14.2, 0.0, 0.0, 0.0);
	Door2 = CreateObject(974, 1680.7, -1673.3, 20.6, 0.0, 0.0, 90.0);
	
	CreatePickup(1239,2,1635.5797,-1709.5321,13.3187);
	return 1;
}

public OnFilterScriptExit()
{
	print("\n--------------------------------------");
	print(" Pershing Square Parking v3.5 English   ");
 	print(" By Agusfn20!						   ");
 	print(" Filterscript Unloaded				   ");
	print("--------------------------------------\n");
	return 1;
}

public OnPlayerConnect(playerid)
{
	new File: PF = fopen(ParkFile, io_read);
	new sendername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, sendername, sizeof(sendername));
	if(dini_Int(ParkFile,sendername) == 1)
	{
	Registered[playerid] = 1;
	}
	else
	{
	Registered[playerid] = 0;
	dini_IntSet(ParkFile, sendername, 0);
	}
	fclose(PF);
	return 1;
}


public OnPlayerCommandText(playerid, cmdtext[])
{
	new cmd[256], idx;
	cmd = strtok(cmdtext, idx);
	new string[256];
	new sendername[MAX_PLAYER_NAME],giveplayername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, sendername, MAX_PLAYER_NAME);
	new giveplayerid, tmp[256];
	
	if(!strcmp("/instructions", cmdtext, true))
	{
		if (Registered[playerid] == 1)
		{
	 		format(string, sizeof(string), "* %s reads the manual of the car park.", sendername);
			ProxDetector(20.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		 	SendClientMessage(playerid, COLOR_GREY,"-------------------------------------------------------------------");
		 	SendClientMessage(playerid, COLOR_YELLOW,"Rules of the parking:");
	  	   	SendClientMessage(playerid, COLOR_GREEN,"*Turn off the engine when not using the car.");
	  	   	SendClientMessage(playerid, COLOR_GREEN,"*Turn the alarm on for a better security.");
	  	   	SendClientMessage(playerid, COLOR_ULTRARED,"We don't apologize for steals or damages.");
	      	SendClientMessage(playerid, COLOR_LIGHTBLUE,"At the receptio, a remote control was given to you.");
	      	SendClientMessage(playerid, COLOR_LIGHTBLUE,"With that control, you can open the 3 gates.");
	      	SendClientMessage(playerid, COLOR_LIGHTBLUE,"To open the vehicle gate, use /opengate while being near it.");
	      	SendClientMessage(playerid, COLOR_LIGHTBLUE,"To open the door, use /opendoor while being near it.");
	      	SendClientMessage(playerid, COLOR_LIGHTBLUE,"And to access the hotel, use /openpanel while being near it.");
		}
		else
    	{
			SendClientMessage(playerid, COLOR_ULTRARED,"Error: No tienes el manual del estacionamiento.");
   		}
        return 1;
	}

	/*if	(!strcmp(cmd, "/signto", true))
	{
		tmp = strtok(cmdtext, idx);
		if	(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_GREEN, "USE: /signto [playerid]");
			return 1;
		}
		giveplayerid = strval(tmp);
		if 	(!(IsPlayerConnected(giveplayerid)))
		{
			SendClientMessage(playerid, COLOR_ULTRARED, "Invalid PlayerID");
			return 1;
		}
		if (ProxDetectorS(5.0, playerid, giveplayerid))
		{
			GetPlayerName(giveplayerid, giveplayername, sizeof(giveplayername));
			format(string, sizeof(string), "You gave %s a remote control and a manual",giveplayername);
			SendClientMessage(playerid, 0x33CCFFAA, string);
			format(string, sizeof(string), "%s gave you a remote control and a manual",sendername);
			SendClientMessage(giveplayerid, 0x33CCFFAA, string);
	 		format(string, sizeof(string), "* %s gives %s a remote control and a manual.", sendername,giveplayername);
			ProxDetector(20.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			Registered[giveplayerid] = 1;
		}
		else
    	{
			SendClientMessage(playerid, COLOR_ULTRARED,"You are too far!.");
    	}
        return 1;
	}*/

	if(!strcmp("/signon", cmdtext, true))
	{
 		if(PlayerToPoint(3.5,playerid,1635.5797,-1709.5321,13.3187))
        {
			if(GetPlayerMoney(playerid)>=ParkingPrice)
			{
				if (Registered[playerid] == 0)
				{
					GivePlayerMoney(playerid, -ParkingPrice);
					Registered[playerid] = 1;
					dini_IntSet(ParkFile, sendername, 1);
					SendClientMessage(playerid, COLOR_LIGHTBLUE,"Welcome to the Pershing Square Car Park!");
      				SendClientMessage(playerid, COLOR_LIGHTBLUE,"You were given a remote control and a manual, type /instructions to see it.");
 					format(string, sizeof(string), "* %s signs on and recieves a remote control and a manual.", sendername);
					ProxDetector(20.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				}
				else
    			{
					SendClientMessage(playerid, COLOR_ULTRARED,"Error: You are already registered.");
				}
			}
			else
    		{
    			format(string, sizeof(string), "* The inscription costs $%d, you don't have enought money!", ParkingPrice);
				SendClientMessage(playerid, COLOR_ULTRARED,string);
        	}
		}
        return 1;
	}

	if(!strcmp("/leaveservice", cmdtext, true))
	{
 		if(PlayerToPoint(3.5,playerid,1635.5797,-1709.5321,13.3187))
        {
			if (Registered[playerid] == 1)
			{
				Registered[playerid] = 0;
				dini_IntSet(ParkFile, sendername, 0);
      			SendClientMessage(playerid, COLOR_LIGHTBLUE,"Thanks for using our service.");
 				format(string, sizeof(string), "* %s signs off and gives his/her remote control.", sendername);
				ProxDetector(20.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			}
			else
    		{
				SendClientMessage(playerid, COLOR_ULTRARED,"You are already not registered!");
			}
		}
        return 1;
	}
	
	if(!strcmp("/opendoor", cmdtext, true))
	{
		if(PlayerToPoint(2.0,playerid,1636.3462,-1673.8210,14.7863))
        {
			if(IsPlayerInAnyVehicle(playerid))
    		{
				if (Registered[playerid] == 1)
				{
   					SendClientMessage(playerid, COLOR_ULTRARED,"Error: Vehicles can't access this door.");
				}
				else
    			{
					SendClientMessage(playerid, COLOR_ULTRARED,"Error: You don't have the remote control.");
    			}
  			}
   			else
    		{
				MoveObject(Door, 1635.5, -1673.4, 14.2, 1.5);
				MoveObject(Door, 1636.6, -1673.4, 14.2, 1.5);
		   		SetTimer("Gate2Close", DoorTimer, 0);
		      	SendClientMessage(playerid, COLOR_LIGHTBLUE,"You've opened the door with tour remote control.");
		 		format(string, sizeof(string), "* %s opens the door with his/her remote control.", sendername);
				ProxDetector(20.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			}
		}
        return 1;
	}

	if(!strcmp("/openpanel", cmdtext, true))
	{
 	   	if(PlayerToPoint(5.0,playerid,1680.9153,-1673.2229,20.2074))
        {
			if(IsPlayerInAnyVehicle(playerid))
    		{
				if (Registered[playerid] == 1)
				{
   					SendClientMessage(playerid, COLOR_ULTRARED,"Error: Vehicles can't access this door.");
    			}
				else
    			{
					SendClientMessage(playerid, COLOR_ULTRARED,"Error: You don't have the remote control.");
    			}
			}
			else
    		{
		  		MoveObject(Door2, 1680.7, -1673.3, 20.6, 1.5);
				MoveObject(Door2, 1680.7, -1668.3, 20.6, 1.5);
		   		SetTimer("Gate3Close", PanelTimer, 0);
		      	SendClientMessage(playerid, COLOR_LIGHTBLUE,"You've opened the door with tour remote control.");
		 		format(string, sizeof(string), "* %s opens the door with his/her remote control.", sendername);
				ProxDetector(20.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			}
		}
        return 1;
	}

	if(!strcmp("/opengate", cmdtext, true))
	{
 	   	if(PlayerToPoint(10.0,playerid,1642.8959,-1715.1106,15.6024))
        {
			if(IsPlayerInAnyVehicle(playerid))
			{
				if (Registered[playerid] == 1)
				{
	 				MoveObject(Gate, 1643.3, -1719.5, 14.6, 2.5);
	  				MoveObject(Gate, 1643.3, -1711.5, 14.6, 2.5);
      				SetTimer("GateClose", GateTimer, 0);
      				SendClientMessage(playerid, COLOR_LIGHTBLUE,"You've opened the gate with tour remote control.");
 					format(string, sizeof(string), "* %s opens the gate with his/her remote control.", sendername);
					ProxDetector(20.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				}
   				else
    			{
					SendClientMessage(playerid, COLOR_ULTRARED,"Error: You don't have the remote control.");
	    		}
    		}
   			else
    		{
   				SendClientMessage(playerid, COLOR_ULTRARED,"Error: Only vehicles can access this door.");
    		}
		}
        return 1;
	}
	return 0;
}

// Callbacks

public GateClose()
{
	MoveObject(Gate, 1643.3, -1711.5, 14.6, 2.5);
	MoveObject(Gate, 1643.3, -1719.5, 14.6, 2.5);
	return 1;
}

public Gate2Close()
{
	MoveObject(Door, 1636.6, -1673.4, 14.2, 1.5);
	MoveObject(Door, 1635.5, -1673.4, 14.2, 1.5);
	return 1;
}
	
public Gate3Close()
{
	MoveObject(Door2, 1680.7, -1668.3, 20.6, 1.5);
	MoveObject(Door2, 1680.7, -1673.3, 20.6, 1.5);
	return 1;
}

public ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5)
{
	if(IsPlayerConnected(playerid))
	{
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		//radi = 2.0; //Trigger Radius
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{

					GetPlayerPos(i, posx, posy, posz);
					tempposx = (oldposx -posx);
					tempposy = (oldposy -posy);
					tempposz = (oldposz -posz);
					//printf("DEBUG: X:%f Y:%f Z:%f",posx,posy,posz);
					if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
					{
						SendClientMessage(i, col1, string);
					}
					else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
					{
						SendClientMessage(i, col2, string);
					}
					else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
					{
						SendClientMessage(i, col3, string);
					}
					else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
					{
						SendClientMessage(i, col4, string);
					}
					else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
					{
						SendClientMessage(i, col5, string);
					}
				}
				else
				{
					SendClientMessage(i, col1, string);
				}
			}
		}
	//not connected
	return 1;
}
public ProxDetectorS(Float:radi, playerid, targetid)
{
    if(IsPlayerConnected(playerid)&&IsPlayerConnected(targetid))
	{
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		//radi = 2.0; //Trigger Radius
		GetPlayerPos(targetid, posx, posy, posz);
		tempposx = (oldposx -posx);
		tempposy = (oldposy -posy);
		tempposz = (oldposz -posz);
		//printf("DEBUG: X:%f Y:%f Z:%f",posx,posy,posz);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
		{
			return 1;
		}
	}
	return 0;
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

public PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z)
{
    if(IsPlayerConnected(playerid))
	{
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		tempposx = (oldposx -x);
		tempposy = (oldposy -y);
		tempposz = (oldposz -z);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
		{
		return 1;
		}
	}
	return 0;
}

/* 		/\ \
	   / -\ \
  	  / /--\ \
	 /_/    \_\  */
