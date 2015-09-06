//*********************************************************//
//        Ultra Neon System (UNS) by smokkr            //
//              Dont remove the credits!                //
//*********************************************************//
//**Include****//
#include <a_samp>

#pragma tabsize 0
#define neondialog 8131

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print("Ultra Neon by Smokkr");
	print("--------------------------------------\n");
	return 1;
	//*********Color****************//
		#define COLOR_YELLOW 0xFFFF00AA
		#define COLOR_BLUE 0x1229FAFF
}

public OnFilterScriptExit()
{
	return 1;
}

//**************Commands*********************//
public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp(cmdtext, "/neon", true)==0)
	{
	if(IsPlayerInAnyVehicle(playerid))
	{
    ShowPlayerDialog(playerid, neondialog, DIALOG_STYLE_LIST, "Neon Colour", "DarkBlue\nRed\nGreen\nWhite\nViolet\nYellow\nCyan\nLightBlue\nPink\nOrange\nLightGreen\nLightYellow\nDelete Neon", "Select", "Cancel");
	}
	return 1;
	}
	return 0;
}
//**************Dialog*********************//
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{

    if(dialogid == neondialog)
	{
		if(response)
		{
			if(listitem == 0)
			{
			    SetPVarInt(playerid, "Status", 1);
                SetPVarInt(playerid, "neon", CreateObject(18648,0,0,0,0,0,0));
                SetPVarInt(playerid, "neon1", CreateObject(18648,0,0,0,0,0,0));
                AttachObjectToVehicle(GetPVarInt(playerid, "neon"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                AttachObjectToVehicle(GetPVarInt(playerid, "neon1"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                SendClientMessage(playerid, 0xFFFFFFAA, "Neon DarkBlue is Installed!");
   			}
			if(listitem == 1)
			{
				SetPVarInt(playerid, "Status", 1);
	            SetPVarInt(playerid, "neon2", CreateObject(18647,0,0,0,0,0,0));
	            SetPVarInt(playerid, "neon3", CreateObject(18647,0,0,0,0,0,0));
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon2"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon3"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            SendClientMessage(playerid, 0xFFFFFFAA, "Neon Red is Installed!");

            }
			if(listitem == 2)
			{
		   	    SetPVarInt(playerid, "Status", 1);
	            SetPVarInt(playerid, "neon4", CreateObject(18649,0,0,0,0,0,0));
	            SetPVarInt(playerid, "neon5", CreateObject(18649,0,0,0,0,0,0));
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon4"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon5"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            SendClientMessage(playerid, 0xFFFFFFAA, "Neon Green is Installed!");

	            }
			if(listitem == 3)
			{
		   	    SetPVarInt(playerid, "Status", 1);
	            SetPVarInt(playerid, "neon6", CreateObject(18652,0,0,0,0,0,0));
	            SetPVarInt(playerid, "neon7", CreateObject(18652,0,0,0,0,0,0));
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon6"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon7"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            SendClientMessage(playerid, 0xFFFFFFAA, "Neon White is Installed!");

            }
			if(listitem == 4)
			{
		   	    SetPVarInt(playerid, "Status", 1);
	            SetPVarInt(playerid, "neon8", CreateObject(18651,0,0,0,0,0,0));
	            SetPVarInt(playerid, "neon9", CreateObject(18651,0,0,0,0,0,0));
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon8"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon9"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            SendClientMessage(playerid, 0xFFFFFFAA, "Neon Violet is Installed!");

            }
			if(listitem == 5)
			{
  				SetPVarInt(playerid, "Status", 1);
	            SetPVarInt(playerid, "neon10", CreateObject(18650,0,0,0,0,0,0));
	            SetPVarInt(playerid, "neon11", CreateObject(18650,0,0,0,0,0,0));
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon10"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon11"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            SendClientMessage(playerid, 0xFFFFFFAA, "Neon Yellow is Installed!");

            }
            if(listitem == 6)
			{
  				SetPVarInt(playerid, "Status", 1);
                SetPVarInt(playerid, "neon12", CreateObject(18648,0,0,0,0,0,0));
                SetPVarInt(playerid, "neon13", CreateObject(18648,0,0,0,0,0,0));
	            SetPVarInt(playerid, "neon14", CreateObject(18649,0,0,0,0,0,0));
	            SetPVarInt(playerid, "neon15", CreateObject(18649,0,0,0,0,0,0));
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon12"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon13"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon14"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon15"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            SendClientMessage(playerid, 0xFFFFFFAA, "Neon Cyan is Installed!");

            }
             if(listitem == 7)
			{
  				SetPVarInt(playerid, "Status", 1);
                SetPVarInt(playerid, "neon16", CreateObject(18648,0,0,0,0,0,0));
                SetPVarInt(playerid, "neon17", CreateObject(18648,0,0,0,0,0,0));
                SetPVarInt(playerid, "neon18", CreateObject(18652,0,0,0,0,0,0));
	            SetPVarInt(playerid, "neon19", CreateObject(18652,0,0,0,0,0,0));
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon16"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon17"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon18"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon19"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            SendClientMessage(playerid, 0xFFFFFFAA, "Neon Light Blue is Installed!");

            }
            if(listitem == 8)
			{
  				SetPVarInt(playerid, "Status", 1);
	            SetPVarInt(playerid, "neon20", CreateObject(18647,0,0,0,0,0,0));
	            SetPVarInt(playerid, "neon21", CreateObject(18647,0,0,0,0,0,0));
	            SetPVarInt(playerid, "neon22", CreateObject(18652,0,0,0,0,0,0));
	            SetPVarInt(playerid, "neon23", CreateObject(18652,0,0,0,0,0,0));
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon20"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon21"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon22"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon23"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            SendClientMessage(playerid, 0xFFFFFFAA, "Neon Pink is Installed!");

            }
             if(listitem == 9)
			{
  				SetPVarInt(playerid, "Status", 1);
	            SetPVarInt(playerid, "neon24", CreateObject(18647,0,0,0,0,0,0));
	            SetPVarInt(playerid, "neon25", CreateObject(18647,0,0,0,0,0,0));
	            SetPVarInt(playerid, "neon26", CreateObject(18650,0,0,0,0,0,0));
	            SetPVarInt(playerid, "neon27", CreateObject(18650,0,0,0,0,0,0));
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon24"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon25"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon26"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon27"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            SendClientMessage(playerid, 0xFFFFFFAA, "Neon Orange is Installed!");

            }
             if(listitem == 10)
			{
  				SetPVarInt(playerid, "Status", 1);
	            SetPVarInt(playerid, "neon28", CreateObject(18649,0,0,0,0,0,0));
	            SetPVarInt(playerid, "neon29", CreateObject(18649,0,0,0,0,0,0));
	            SetPVarInt(playerid, "neon30", CreateObject(18652,0,0,0,0,0,0));
	            SetPVarInt(playerid, "neon31", CreateObject(18652,0,0,0,0,0,0));
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon28"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon29"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon30"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon31"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            SendClientMessage(playerid, 0xFFFFFFAA, "Neon Light Green is Installed!");

            }
            if(listitem == 11)
			{
  				SetPVarInt(playerid, "Status", 1);
	            SetPVarInt(playerid, "neon32", CreateObject(18652,0,0,0,0,0,0));
	            SetPVarInt(playerid, "neon33", CreateObject(18652,0,0,0,0,0,0));
	            SetPVarInt(playerid, "neon34", CreateObject(18650,0,0,0,0,0,0));
	            SetPVarInt(playerid, "neon35", CreateObject(18650,0,0,0,0,0,0));
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon32"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon33"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon34"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            AttachObjectToVehicle(GetPVarInt(playerid, "neon35"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	            SendClientMessage(playerid, 0xFFFFFFAA, "Neon Light Yellow is Installed!");

            }
   if(listitem == 12){DestroyObject(GetPVarInt(playerid, "neon")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon1")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon2")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon3"));
            DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon4")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon5")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon6")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon7"));
			DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon8")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon9")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon10")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon11"));
            DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon12")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon13")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon14")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon15"));
            DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon16")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon17")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon18")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon19"));
            DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon20")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon21")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon22")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon23"));
			DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon24")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon25")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon26")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon27"));
            DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon28")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon29")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon30")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon31"));
            DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon32")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon33")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon34")); DeletePVar(playerid, "Status"); DestroyObject(GetPVarInt(playerid, "neon35"));
	 	    }
		}
	}
    return 0;
}
	public OnPlayerConnect()
		{
		return 1;
		}
		//Dont remove the credits please!
