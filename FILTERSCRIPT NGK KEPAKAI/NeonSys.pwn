// This is a comment
// uncomment the line below if you want to write a filterscript
#include <a_samp>

//COLORs DEFINES//
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_RED 0xAA3333AA
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_PINK 0xFF66FFAA
#define COLOR_BLUE 0x0000BBAA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_DARKRED 0x660000AA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_BRIGHTRED 0xFF0000AA
#define COLOR_INDIGO 0x4B00B0AA
#define COLOR_VIOLET 0x9955DEEE
#define COLOR_LIGHTRED 0xFF99AADD
#define COLOR_SEAGREEN 0x00EEADDF
#define COLOR_GRAYWHITE 0xEEEEFFC4
#define COLOR_LIGHTNEUTRALBLUE 0xabcdef66
#define COLOR_GREENISHGOLD 0xCCFFDD56
#define COLOR_LIGHTBLUEGREEN 0x0FFDD349
#define COLOR_NEUTRALBLUE 0xABCDEF01
#define COLOR_LIGHTCYAN 0xAAFFCC33
#define COLOR_LEMON 0xDDDD2357
#define COLOR_MEDIUMBLUE 0x63AFF00A
#define COLOR_NEUTRAL 0xABCDEF97
#define COLOR_BLACK 0x00000000
#define COLOR_NEUTRALGREEN 0x81CFAB00
#define COLOR_DARKGREEN 0x12900BBF
#define COLOR_LIGHTGREEN 0x24FF0AB9
#define COLOR_DARKBLUE 0x300FFAAB
#define COLOR_BLUEGREEN 0x46BBAA00
#define COLOR_PINK 0xFF66FFAA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_DARKRED 0x660000AA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_PURPLE 0x800080AA
#define COLOR_GRAD1 0xB4B5B7FF
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_RED1 0xFF0000AA
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xAA3333AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_BROWN 0x993300AA
#define COLOR_CYAN 0x99FFFFAA
#define COLOR_TAN 0xFFFFCCAA
#define COLOR_PINK 0xFF66FFAA
#define COLOR_KHAKI 0x999900AA
#define COLOR_LIME 0x99FF00AA
#define COLOR_SYSTEM 0xEFEFF7AA
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_GRAD4 0xD8D8D8FF
#define COLOR_GRAD6 0xF0F0F0FF
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_GRAD3 0xCBCCCEFF
#define COLOR_GRAD5 0xE3E3E3FF
#define COLOR_GRAD1 0xB4B5B7FF
//ENDENDENDENDEND//

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Neon System By Pro_Drifter");
	print("--------------------------------------\n");
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
	return 1;
}
public OnPlayerCommandText(playerid, cmdtext[])
{
	if(IsPlayerInAnyVehicle(playerid))
	if(strcmp("/neon", cmdtext, true, 10) == 0)
	ShowPlayerDialog(playerid,1,DIALOG_STYLE_LIST,"NeonSystem By Hellzone","1. Red Neon\r\n2. Blue Neon\r\n3. Green Neon\r\n4. Yellow Neon\r\n5. Pink Neon\r\n6. White Neon","OK", "CANCEL");
	else SendClientMessage(playerid,COLOR_RED,"Error: You are not in a vehicle");
	return 1;
	}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid) // Lookup the dialogid
    {
        case 1:
        {
            if(!response)
            {
                SendClientMessage(playerid, 0xFF0000FF, "You Canceled");
                return 1; // We processed it
            }
            switch(listitem) // This is far more efficient than using an if-elseif-else structure
            {
                case 0: // Listitems start with 0, not 1
                {
                    new neon = CreateObject(18647,0,0,0,0,0,0,100.0);
					new neon1 = CreateObject(18647,0,0,0,0,0,0,100.0);
					AttachObjectToVehicle(neon, GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					AttachObjectToVehicle(neon1, GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					SendClientMessage(playerid, COLOR_RED, "Red Neon Installed");
                }
                case 1:
                {
                	new neon = CreateObject(18648,0,0,0,0,0,0,100.0);
					new neon1 = CreateObject(18648,0,0,0,0,0,0,100.0);
					AttachObjectToVehicle(neon, GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					AttachObjectToVehicle(neon1, GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					SendClientMessage(playerid, COLOR_BLUE, "Blue Neon Installed");
                }
                case 2:
                {
                	new neon = CreateObject(18649,0,0,0,0,0,0,100.0);
					new neon1 = CreateObject(18649,0,0,0,0,0,0,100.0);
					AttachObjectToVehicle(neon, GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					AttachObjectToVehicle(neon1, GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					SendClientMessage(playerid, COLOR_GREEN, "Green Neon Installed");
                }
                case 3:
                {
                	new neon = CreateObject(18650,0,0,0,0,0,0,100.0);
					new neon1 = CreateObject(18650,0,0,0,0,0,0,100.0);
					AttachObjectToVehicle(neon, GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					AttachObjectToVehicle(neon1, GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					SendClientMessage(playerid, COLOR_YELLOW, "Yellow Neon Installed");
                }
                case 4:
                {
                	new neon = CreateObject(18651,0,0,0,0,0,0,100.0);
					new neon1 = CreateObject(18651,0,0,0,0,0,0,100.0);
					AttachObjectToVehicle(neon, GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					AttachObjectToVehicle(neon1, GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					SendClientMessage(playerid, COLOR_PINK, "Pink Neon Installed");
                }
                case 5:
                {
                	new neon = CreateObject(18652,0,0,0,0,0,0,100.0);
					new neon1 = CreateObject(18652,0,0,0,0,0,0,100.0);
					AttachObjectToVehicle(neon, GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					AttachObjectToVehicle(neon1, GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					SendClientMessage(playerid, COLOR_WHITE, "White Neon Installed");
                }
            }

        }

    }
    return 0; // If you put return 1 here the callback will not continue to be called in other scripts (filterscripts, etc.).
}
