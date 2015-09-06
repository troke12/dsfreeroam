/*
||||||||||||||||||||||||||||||||||||||||
||Neon System By AlexzzPro            ||
||Please keep the credits to me       ||
||Do not re-relase without permisssion||
||Enjoy!                              ||
||||||||||||||||||||||||||||||||||||||||
*/
#define FILTERSCRIPT
#define COLOR_WHITE 0xFFFFFFAA
#include <a_samp>
#define NEON 1337 // Dialogid
#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Neon System By AlexzzPro");
	print("--------------------------------------\n");
	return 1;
}

#endif
public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/neon", cmdtext, true, 10) == 0)
	{
		if(IsPlayerInAnyVehicle(playerid))
 		{
  			if(GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
			{
				SendClientMessage(playerid, COLOR_WHITE, "      You are not the driver");
				return 1;
			}
			ShowPlayerDialog(playerid, NEON, DIALOG_STYLE_LIST, "Choose your neon colour","Blue\nGreen\nYellow\nWhite\nPink\nTurn off Neon","Add","Close");
		}
		else
		{
		    SendClientMessage(playerid, COLOR_WHITE, " You are not in a vehicle");
		}
		return 1;
	}
	return 0;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == NEON)
	{
		if(response)
		{
		    if(listitem == 0)
		    {
		        SetPVarInt(playerid, "neon", 1);
            	SetPVarInt(playerid, "blue", CreateObject(18648,0,0,0,0,0,0));
            	SetPVarInt(playerid, "blue1", CreateObject(18648,0,0,0,0,0,0));
            	AttachObjectToVehicle(GetPVarInt(playerid, "blue"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
            	AttachObjectToVehicle(GetPVarInt(playerid, "blue1"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
            	GameTextForPlayer(playerid, "~b~ Blue ~w~Neon has been added to your vehicle",3500,5);
			}
			if(listitem == 1)
			{
   				SetPVarInt(playerid, "neon", 1);
       			SetPVarInt(playerid, "green", CreateObject(18649,0,0,0,0,0,0));
       			SetPVarInt(playerid, "green1", CreateObject(18649,0,0,0,0,0,0));
       			AttachObjectToVehicle(GetPVarInt(playerid, "green"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
          		AttachObjectToVehicle(GetPVarInt(playerid, "green1"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
          		GameTextForPlayer(playerid, "~g~Green ~w~Neon has been added to your vehicle",3500,5);
			}
			if(listitem == 2)
			{
			    SetPVarInt(playerid, "neon", 1);
       			SetPVarInt(playerid, "yellow", CreateObject(18650,0,0,0,0,0,0));
          		SetPVarInt(playerid, "yellow1", CreateObject(18650,0,0,0,0,0,0));
            	AttachObjectToVehicle(GetPVarInt(playerid, "yellow"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
             	AttachObjectToVehicle(GetPVarInt(playerid, "yellow1"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				GameTextForPlayer(playerid, "~y~Yellow~w~ Neon has been added to your vehicle",3500,5);
			}
			if(listitem == 3)
			{
   				SetPVarInt(playerid, "neon", 1);
   				SetPVarInt(playerid, "white", CreateObject(18652,0,0,0,0,0,0));
   				SetPVarInt(playerid, "white1", CreateObject(18652,0,0,0,0,0,0));
       			AttachObjectToVehicle(GetPVarInt(playerid, "white"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
          		AttachObjectToVehicle(GetPVarInt(playerid, "white1"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                GameTextForPlayer(playerid, "~w~White~w~ Neon has been added to your vehicle",3500,5);
			}
			if(listitem == 4)
			{
   				SetPVarInt(playerid, "neon", 1);
     			SetPVarInt(playerid, "pink", CreateObject(18651,0,0,0,0,0,0));
        		SetPVarInt(playerid, "pink1", CreateObject(18651,0,0,0,0,0,0));
          		AttachObjectToVehicle(GetPVarInt(playerid, "pink"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
            	AttachObjectToVehicle(GetPVarInt(playerid, "pink1"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				GameTextForPlayer(playerid, "~p~Pink~w~ Neon has been added to your vehicle",3500,5);
			}
			if(listitem == 5)
			{
	   			DestroyObject(GetPVarInt(playerid, "blue"));
	            DeletePVar(playerid, "neon");
	            DestroyObject(GetPVarInt(playerid, "blue1"));
	            DeletePVar(playerid, "neon");
	            DestroyObject(GetPVarInt(playerid, "green"));
	            DeletePVar(playerid, "neon");
	            DestroyObject(GetPVarInt(playerid, "green1"));
	            DeletePVar(playerid, "neon");
	            DestroyObject(GetPVarInt(playerid, "yellow"));
	            DeletePVar(playerid, "neon");
	            DestroyObject(GetPVarInt(playerid, "yellow1"));
	            DeletePVar(playerid, "neon");
	            DestroyObject(GetPVarInt(playerid, "white"));
	            DeletePVar(playerid, "neon");
	            DestroyObject(GetPVarInt(playerid, "white1"));
	            DeletePVar(playerid, "neon");
	            DestroyObject(GetPVarInt(playerid, "pink"));
	            DeletePVar(playerid, "neon");
	            DestroyObject(GetPVarInt(playerid, "pink1"));
	            DeletePVar(playerid, "neon");
	            GameTextForPlayer(playerid, "~g~Neon was deleted from your vehicle",3500,5);
            }
		}
 	}
	return 1;
}
