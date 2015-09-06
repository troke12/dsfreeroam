#include <a_samp>
#define MAIN		2000
#define RED			2001
#define BLUE		2002
#define GREEN		2003
#define YELLOW		2004
#define CYAN		2005
#define PINK		2006
#define WHITE		2007
#define BLACK		2008
#pragma tabsize 0

new string[128];
new VehicleId;
new Float:X,Float:Y,Float:Z,Float:Angle;

public OnPlayerCommandText(playerid, cmdtext[])
{
    if (strcmp(cmdtext, "/plate", true) == 0 || strcmp(cmdtext, "/setplate", true) == 0 || strcmp(cmdtext, "/setnumberplate", true) == 0 || strcmp(cmdtext, "/numberplate", true) == 0)
	{
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xE60000FF, "ERROR: You must be in a vehicle to use this command!");
		else
		{
    		ShowPlayerDialog(playerid, MAIN, DIALOG_STYLE_LIST, "Plate System > Select you color", "{FF0000}Red\n{00FF00}Green\n{0000FF}Blue\n{FFFF00}Yellow\n{00FFFF}Cyan\n{FF00FF}Pink\n{F0F0F0}White\n{0F0F0F}Black", "Select", "Cancel");
		}
		return 1;
	}
    return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
    {
        case MAIN:
        {
            if(!response)
            {
                   return 1;
            }

            switch(listitem)
            {
                case 0:
				{
				    ShowPlayerDialog(playerid, RED, DIALOG_STYLE_INPUT, "Plate System > Red","Type your text here [4-8 Character]", "Set", "Back");
				}
				case 1:
				{
				    ShowPlayerDialog(playerid, BLUE, DIALOG_STYLE_INPUT, "Plate System > Blue","Type your text here [4-8 Character]", "Set", "Back");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, GREEN, DIALOG_STYLE_INPUT, "Plate System > Green","Type your text here [4-8 Character]", "Set", "Back");
				}
				case 3:
				{
					ShowPlayerDialog(playerid, YELLOW, DIALOG_STYLE_INPUT, "Plate System > Yellow","Type your text here [4-8 Character]", "Set", "Back");
				}
				case 4:
				{
					ShowPlayerDialog(playerid, CYAN, DIALOG_STYLE_INPUT, "Plate System > Cyan","Type your text here [4-8 Character]", "Set", "Back");
				}
				case 5:
				{
					ShowPlayerDialog(playerid, PINK, DIALOG_STYLE_INPUT, "Plate System > Pink","Type your text here [4-8 Character]", "Set", "Back");
				}
				case 6:
				{
					ShowPlayerDialog(playerid, WHITE, DIALOG_STYLE_INPUT, "Plate System > White","Type your text here [4-8 Character]", "Set", "Back");
				}
				case 7:
				{
					ShowPlayerDialog(playerid, BLACK, DIALOG_STYLE_INPUT, "Plate System > Black","Type your text here [4-8 Character]", "Set", "Back");
				}
			}
		}
	}
	if(dialogid == RED)
	{
      	if(response)
		{
      		if(strlen(inputtext) > 3 && strlen(inputtext) < 9)
            {
                format(string,sizeof(string),"{FF0000}%s",inputtext);
	      		VehicleId = GetPlayerVehicleID(playerid);
	      		GetPlayerPos(playerid,X,Y,Z);
	      		GetVehicleZAngle(VehicleId,Angle);
	           	SetVehicleNumberPlate(VehicleId,string);
				SetVehicleToRespawn(VehicleId);
				SetVehiclePos(VehicleId,X,Y,Z);
				PutPlayerInVehicle(playerid,VehicleId,0);
				SetVehicleZAngle(VehicleId,Angle);
				SetCameraBehindPlayer(playerid);
            }
            else
            {
                SendClientMessage(playerid, 0xE60000FF, "You must enter a text between 4-8 Character.");
                ShowPlayerDialog(playerid, RED, DIALOG_STYLE_INPUT, "Plate System > Red","Enter the name [4-8 Character]\n{ff0000}ERROR: You must enter a text between 4-8 Character.", "Set", "Back");
			}
      	}
      	if(!response)
      	{
      	    ShowPlayerDialog(playerid, MAIN, DIALOG_STYLE_LIST, "Plate System > Select you color", "{FF0000}Red\n{00FF00}Green\n{0000FF}Blue\n{FFFF00}Yellow\n{00FFFF}Cyan\n{FF00FF}Pink\n{F0F0F0}White\n{0F0F0F}Black", "Select", "Cancel");
		}
	}
	if(dialogid == GREEN)
	{
      	if(response)
		{
      		if(strlen(inputtext) > 3 && strlen(inputtext) < 9)
            {
                format(string,sizeof(string),"{0000FF}%s",inputtext);
	      		VehicleId = GetPlayerVehicleID(playerid);
	      		GetPlayerPos(playerid,X,Y,Z);
	      		GetVehicleZAngle(VehicleId,Angle);
	           	SetVehicleNumberPlate(VehicleId,string);
				SetVehicleToRespawn(VehicleId);
				SetVehiclePos(VehicleId,X,Y,Z);
				PutPlayerInVehicle(playerid,VehicleId,0);
				SetVehicleZAngle(VehicleId,Angle);
				SetCameraBehindPlayer(playerid);
            }
            else
            {
                SendClientMessage(playerid, 0xE60000FF, "ERROR: You must enter a text between 4-8 Character.");
                ShowPlayerDialog(playerid, GREEN, DIALOG_STYLE_INPUT, "Plate System > Green","Enter the name [4-8 Character]\n{ff0000}ERROR: You must enter a text between 4-8 Character.", "Set", "Back");
			}
      	}
      	if(!response)
      	{
      	    ShowPlayerDialog(playerid, MAIN, DIALOG_STYLE_LIST, "Plate System > Select you color", "{FF0000}Red\n{00FF00}Green\n{0000FF}Blue\n{FFFF00}Yellow\n{00FFFF}Cyan\n{FF00FF}Pink\n{F0F0F0}White\n{0F0F0F}Black", "Select", "Cancel");
		}
	}
	if(dialogid == BLUE)
	{
      	if(response)
		{
      		if(strlen(inputtext) > 3 && strlen(inputtext) < 9)
            {
                format(string,sizeof(string),"{00FF00}%s",inputtext);
	      		VehicleId = GetPlayerVehicleID(playerid);
	      		GetPlayerPos(playerid,X,Y,Z);
	      		GetVehicleZAngle(VehicleId,Angle);
	           	SetVehicleNumberPlate(VehicleId,string);
				SetVehicleToRespawn(VehicleId);
				SetVehiclePos(VehicleId,X,Y,Z);
				PutPlayerInVehicle(playerid,VehicleId,0);
				SetVehicleZAngle(VehicleId,Angle);
				SetCameraBehindPlayer(playerid);
            }
            else
            {
                SendClientMessage(playerid, 0xE60000FF, "ERROR: You must enter a text between 4-8 Character.");
                ShowPlayerDialog(playerid, BLUE, DIALOG_STYLE_INPUT, "Plate System > Blue","Enter the name [4-8 Character]\n{ff0000}ERROR: You must enter a text between 4-8 Character.", "Set", "Back");
			}
      	}
      	if(!response)
      	{
      	    ShowPlayerDialog(playerid, MAIN, DIALOG_STYLE_LIST, "Plate System > Select you color", "{FF0000}Red\n{00FF00}Green\n{0000FF}Blue\n{FFFF00}Yellow\n{00FFFF}Cyan\n{FF00FF}Pink\n{F0F0F0}White\n{0F0F0F}Black", "Select", "Cancel");
		}
	}
	if(dialogid == YELLOW)
	{
      	if(response)
		{
      		if(strlen(inputtext) > 3 && strlen(inputtext) < 9)
            {
                format(string,sizeof(string),"{FFFF00}%s",inputtext);
	      		VehicleId = GetPlayerVehicleID(playerid);
	      		GetPlayerPos(playerid,X,Y,Z);
	      		GetVehicleZAngle(VehicleId,Angle);
	           	SetVehicleNumberPlate(VehicleId,string);
				SetVehicleToRespawn(VehicleId);
				SetVehiclePos(VehicleId,X,Y,Z);
				PutPlayerInVehicle(playerid,VehicleId,0);
				SetVehicleZAngle(VehicleId,Angle);
				SetCameraBehindPlayer(playerid);
            }
            else
            {
                SendClientMessage(playerid, 0xE60000FF, "ERROR: You must enter a text between 4-8 Character.");
                ShowPlayerDialog(playerid, YELLOW, DIALOG_STYLE_INPUT, "Plate System > Yellow","Enter the name [4-8 Character]\n{ff0000}ERROR: You must enter a text between 4-8 Character.", "Set", "Back");
			}
      	}
      	if(!response)
      	{
      	    ShowPlayerDialog(playerid, MAIN, DIALOG_STYLE_LIST, "Plate System > Select you color", "{FF0000}Red\n{00FF00}Green\n{0000FF}Blue\n{FFFF00}Yellow\n{00FFFF}Cyan\n{FF00FF}Pink\n{F0F0F0}White\n{0F0F0F}Black", "Select", "Cancel");
		}
	}
	if(dialogid == CYAN)
	{
      	if(response)
		{
      		if(strlen(inputtext) > 3 && strlen(inputtext) < 9)
            {
                format(string,sizeof(string),"{00FFFF}%s",inputtext);
	      		VehicleId = GetPlayerVehicleID(playerid);
	      		GetPlayerPos(playerid,X,Y,Z);
	      		GetVehicleZAngle(VehicleId,Angle);
	           	SetVehicleNumberPlate(VehicleId,string);
				SetVehicleToRespawn(VehicleId);
				SetVehiclePos(VehicleId,X,Y,Z);
				PutPlayerInVehicle(playerid,VehicleId,0);
				SetVehicleZAngle(VehicleId,Angle);
				SetCameraBehindPlayer(playerid);
            }
            else
            {
                SendClientMessage(playerid, 0xE60000FF, "ERROR: You must enter a text between 4-8 Character.");
                ShowPlayerDialog(playerid, CYAN, DIALOG_STYLE_INPUT, "Plate System > Cyan","Enter the name [4-8 Character]\n{ff0000}ERROR: You must enter a text between 4-8 Character.", "Set", "Back");
			}
      	}
      	if(!response)
      	{
      	    ShowPlayerDialog(playerid, MAIN, DIALOG_STYLE_LIST, "Plate System > Select you color", "{FF0000}Red\n{00FF00}Green\n{0000FF}Blue\n{FFFF00}Yellow\n{00FFFF}Cyan\n{FF00FF}Pink\n{F0F0F0}White\n{0F0F0F}Black", "Select", "Cancel");
		}
	}
	if(dialogid == PINK)
	{
      	if(response)
		{
      		if(strlen(inputtext) > 3 && strlen(inputtext) < 9)
            {
                format(string,sizeof(string),"{FF00FF}%s",inputtext);
	      		VehicleId = GetPlayerVehicleID(playerid);
	      		GetPlayerPos(playerid,X,Y,Z);
	      		GetVehicleZAngle(VehicleId,Angle);
	           	SetVehicleNumberPlate(VehicleId,string);
				SetVehicleToRespawn(VehicleId);
				SetVehiclePos(VehicleId,X,Y,Z);
				PutPlayerInVehicle(playerid,VehicleId,0);
				SetVehicleZAngle(VehicleId,Angle);
				SetCameraBehindPlayer(playerid);
            }
            else
            {
                SendClientMessage(playerid, 0xE60000FF, "ERROR: You must enter a text between 4-8 Character.");
                ShowPlayerDialog(playerid, PINK, DIALOG_STYLE_INPUT, "Plate System > Pink","Enter the name [4-8 Character]\n{ff0000}ERROR: You must enter a text between 4-8 Character.", "Set", "Back");
			}
      	}
      	if(!response)
      	{
      	    ShowPlayerDialog(playerid, MAIN, DIALOG_STYLE_LIST, "Plate System > Select you color", "{FF0000}Red\n{00FF00}Green\n{0000FF}Blue\n{FFFF00}Yellow\n{00FFFF}Cyan\n{FF00FF}Pink\n{F0F0F0}White\n{0F0F0F}Black", "Select", "Cancel");
		}
	}
	if(dialogid == WHITE)
	{
      	if(response)
		{
      		if(strlen(inputtext) > 3 && strlen(inputtext) < 9)
            {
                format(string,sizeof(string),"{F0F0F0}%s",inputtext);
	      		VehicleId = GetPlayerVehicleID(playerid);
	      		GetPlayerPos(playerid,X,Y,Z);
	      		GetVehicleZAngle(VehicleId,Angle);
	           	SetVehicleNumberPlate(VehicleId,string);
				SetVehicleToRespawn(VehicleId);
				SetVehiclePos(VehicleId,X,Y,Z);
				PutPlayerInVehicle(playerid,VehicleId,0);
				SetVehicleZAngle(VehicleId,Angle);
				SetCameraBehindPlayer(playerid);
            }
            else
            {
                SendClientMessage(playerid, 0xE60000FF, "ERROR: You must enter a text between 4-8 Character.");
                ShowPlayerDialog(playerid, WHITE, DIALOG_STYLE_INPUT, "Plate System > White","Enter the name [4-8 Character]\n{ff0000}ERROR: You must enter a text between 4-8 Character.", "Set", "Back");
			}
      	}
      	if(!response)
      	{
      	    ShowPlayerDialog(playerid, MAIN, DIALOG_STYLE_LIST, "Plate System > Select you color", "{FF0000}Red\n{00FF00}Green\n{0000FF}Blue\n{FFFF00}Yellow\n{00FFFF}Cyan\n{FF00FF}Pink\n{F0F0F0}White\n{0F0F0F}Black", "Select", "Cancel");
		}
	}
	if(dialogid == BLACK)
	{
      	if(response)
		{
      		if(strlen(inputtext) > 3 && strlen(inputtext) < 9)
            {
                format(string,sizeof(string),"{0F0F0F}%s",inputtext);
	      		VehicleId = GetPlayerVehicleID(playerid);
	      		GetPlayerPos(playerid,X,Y,Z);
	      		GetVehicleZAngle(VehicleId,Angle);
	           	SetVehicleNumberPlate(VehicleId,string);
				SetVehicleToRespawn(VehicleId);
				SetVehiclePos(VehicleId,X,Y,Z);
				PutPlayerInVehicle(playerid,VehicleId,0);
				SetVehicleZAngle(VehicleId,Angle);
				SetCameraBehindPlayer(playerid);
            }
            else
            {
                SendClientMessage(playerid, 0xE60000FF, "ERROR: You must enter a text between 4-8 Character.");
                ShowPlayerDialog(playerid, BLACK, DIALOG_STYLE_INPUT, "Plate System > Black","Enter the name [4-8 Character]\n{ff0000}ERROR: You must enter a text between 4-8 Character.", "Set", "Back");
			}
      	}
      	if(!response)
      	{
      	    ShowPlayerDialog(playerid, MAIN, DIALOG_STYLE_LIST, "Plate System > Select you color", "{FF0000}Red\n{00FF00}Green\n{0000FF}Blue\n{FFFF00}Yellow\n{00FFFF}Cyan\n{FF00FF}Pink\n{F0F0F0}White\n{0F0F0F}Black", "Select", "Cancel");
		}
	}
	return 1;
}
