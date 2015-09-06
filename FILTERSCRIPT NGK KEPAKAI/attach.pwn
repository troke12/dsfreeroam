////////////////////////////////////////////////////////////////////////////////
//							ATTACHED OBJECT EDITOR                            //
//                                by Robo_N1X                                 //
//							 -Version: 0.2 Beta-                             //
// ========================================================================== //
// Note: This filterscript works in SA:MP 0.3e and upper                      //
// License note:                                                              //
// * You may not remove any credits that is written in the credits dialog in  //
//   this script!                                                             //
// * You may modify this script without removing any credits                  //
// * You may copy the content(s) of this script without removing any credits  //
// * You may use this script for non-commercial                               //
// Credits: SA-MP Team, h02, DracoBlue, whoever made some functions here      //
// Original thread: http://forum.sa-mp.com/showthread.php?t=416138            //
////////////////////////////////////////////////////////////////////////////////

#include <a_samp> // Credits to: SA-MP team
#include <Dini> // Credits to: DracoBlue
#define dcmd(%1,%2,%3) if (!strcmp((%3)[1], #%1, true, (%2)) && ((((%3)[(%2) + 1] == '\0') && (dcmd_%1(playerid, ""))) || (((%3)[(%2) + 1] == ' ') && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1 // Credits to: DracoBlue / Source: SA-MP Wiki
#define MIN_ATTACHED_OBJECT_BONE	1
#define MAX_ATTACHED_OBJECT_BONE	18
#define MAX_ATTACHED_OBJECT_OFFSET  3000.00
#define MIN_ATTACHED_OBJECT_OFFSET  -3000.00
#define MAX_ATTACHED_OBJECT_ROT     360.00
#define MIN_ATTACHED_OBJECT_ROT     -360.00
#define MAX_ATTACHED_OBJECT_SIZE    1000.00
#define MIN_ATTACHED_OBJECT_SIZE    -1000.00
#define AOE_VERSION			"0.2 - July, 2013" // Version
#define AO_FILENAME			"Attachments/%s_pao.ini" 	// Player attached/holding object (%s = name) located in scriptfiles folder by default
#define AOC_FILENAME        "Attachments/%s_exp.txt"    // Converted attached/holding object (%s = name) located in scriptfiles folder by default
#define AOE_CantEdit(%0) GetPVarInt(%0, "EditingAttachedObject") != 0 || GetPlayerState(%0) == PLAYER_STATE_WASTED || GetPlayerState(%0) == PLAYER_STATE_SPECTATING
#define AOE_IntToHexFormat(%0) %0 >>> 16, %0 & 0xFFFF // format output for int color %04x%04x to hex with alpha
// COLOR DEFINES
#define COLOR_WHITE 	0xFFFFFFFF
#define COLOR_RED 		0xFF0000FF
#define COLOR_YELLOW 	0xFFFF00FF
#define COLOR_GREEN 	0x00FF00FF
#define COLOR_CYAN      0x00FFFFFF
#define COLOR_BLUE 		0x0000FFFF
#define COLOR_MAGENTA	0xFF00FFFF

// =============================================================================

new aoe_str[128];
new PlayerName[MAX_PLAYER_NAME];
enum // Dialog ID enums
{
	AOED = 400,
	AOED_HELP,
	AOED_ABOUT,
	AOED_CREATE_MODEL,
	AOED_CREATE_BONE,
	AOED_CREATE_SLOT,
	AOED_CREATE_REPLACE,
	AOED_CREATE_EDIT,
	AOED_EDIT_SLOT,
	AOED_REMOVE_SLOT,
	AOED_REMOVE,
	AOED_REMOVEALL,
	AOED_STATS_SLOT,
	AOED_STATS,
	AOED_DUPLICATE_SLOT1,
	AOED_DUPLICATE_SLOT2,
	AOED_DUPLICATE_REPLACE,
	AOED_SET_SLOT1,
	AOED_SET_SLOT2,
	AOED_SET_SLOT_REPLACE,
	AOED_SET_MODEL_SLOT,
	AOED_SET_MODEL,
	AOED_SET_BONE_SLOT,
	AOED_SET_BONE,
	AOED_SAVE,
	AOED_SAVE_SLOT,
	AOED_SAVE_REPLACE,
	AOED_SAVE2,
	AOED_SAVE2_REPLACE,
	AOED_LOAD,
 	AOED_LOAD_SLOT,
	AOED_LOAD_REPLACE,
	AOED_LOAD2,
 	AOED_CONVERT
}
enum AttachedObjectOptions {
	aoValid = 0,
	aoModelID, aoBoneID,
	Float:aoX, Float:aoY, Float:aoZ,
	Float:aoRX, Float:aoRY, Float:aoRZ,
	Float:aoSX, Float:aoSY, Float:aoSZ,
	aoMC1, aoMC2
}
new pao[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS][AttachedObjectOptions];
new AttachedObjectBones[MAX_ATTACHED_OBJECT_BONE][24] = {
	{"Spine"}, {"Head"}, {"Left upper arm"}, {"Right upper arm"}, {"Left hand"}, {"Right hand"},
	{"Left thigh"}, {"Right thigh"}, {"Left foot"}, {"Right foot"}, {"Right calf"}, {"Left calf"},
	{"Left forearm"}, {"Right forearm"}, {"Left clavicle"}, {"Right clavicle"}, {"Neck"}, {"Jaw"}
};

// =============================================================================

public OnFilterScriptInit()
{
	for(new i = 0; i < GetMaxPlayers(); i++)
	{
		for(new s = 0; s < MAX_PLAYER_ATTACHED_OBJECTS; s++) {
	    	if(IsPlayerAttachedObjectSlotUsed(i, s)) pao[i][s][aoValid] = 1;
	 		else AOE_UnsetValues(i, s);
		}
	}
	print("  [FilterScript] Attached Object Editor for SA:MP 0.3e+ has been loaded!");
	printf("  Attached Objects Count: %d", GetAttachedObjectsCount());
	return 1;
}

public OnFilterScriptExit()
{
	printf("  Attached Objects Count: %d", GetAttachedObjectsCount());
    for(new x = 0; x < GetMaxPlayers(); x++) if(IsPlayerConnected(x)) AOE_UnsetVars(x);
    print("  [FilterScript] Attached Object Editor for SA:MP 0.3e+ has been unloaded!");
    return 1;
}

public OnPlayerConnect(playerid)
{
	for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++) {
	    if(IsPlayerAttachedObjectSlotUsed(playerid, i)) pao[playerid][i][aoValid] = 1;
 		else RemovePlayerAttachedObject(playerid, i), AOE_UnsetValues(playerid, i);
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
    new slots = 0;
    for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++) if(pao[playerid][i][aoValid])
		RestorePlayerAttachedObject(playerid, i), slots++;
    if(0 < slots <= MAX_PLAYER_ATTACHED_OBJECTS) {
    	format(aoe_str, sizeof(aoe_str), "* Automatically restored your attached object(s) [Total: %d]!", slots);
    	SendClientMessage(playerid, COLOR_GREEN, aoe_str);
	}
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if(!strcmp(cmdtext, "/attachedobjecteditor", true) || !strcmp(cmdtext, "/attach", true)) {
		if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
		else AOE_ShowPlayerDialog(playerid, 0, AOED, "Attached Object Editor", "Select", "Close");
		return 1;
	}
	if(!strcmp(cmdtext, "/removeattachedobjects", true) || !strcmp(cmdtext, "/raos", true))
	{
		if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
		else if(!GetPlayerAttachedObjectsCount(playerid)) {
	    	SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
			GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 5000, 3);
		}
		else AOE_ShowPlayerDialog(playerid, 12, AOED_REMOVEALL, "Remove All Attached Object(s)", "Yes", "Cancel");
		return 1;
	}
	if(!strcmp(cmdtext, "/undodeleteattachedobject", true) || !strcmp(cmdtext, "/undeleteattachedobject", true) || !strcmp(cmdtext, "/udao", true))
	{
		if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
		else if(GetPlayerAttachedObjectsCount(playerid) >= MAX_PLAYER_ATTACHED_OBJECTS) {
	    	SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't have more attached object(s) [Limit exceed]!");
	    	SendClientMessage(playerid, COLOR_YELLOW, "* You can only hold "#MAX_PLAYER_ATTACHED_OBJECTS" attached object(s) at a time!");
			GameTextForPlayer(playerid, "~r~~h~Too many attached objects!", 5000, 3);
		}
		else if(!GetPVarType(playerid, "LastAttachedObjectRemoved")) {
			SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object to restore!");
			GameTextForPlayer(playerid, "~r~~h~No attached object can be restored!", 5000, 3);
		}
		else
		{
			new slot = GetPVarInt(playerid, "LastAttachedObjectRemoved");
			if(!IsValidPlayerAttachedObject(playerid, slot)) {
				format(aoe_str, sizeof(aoe_str), "* Sorry, you can't restore your last attached object from slot/index number %i as it's not valid!", slot);
   				SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
		    	GameTextForPlayer(playerid, "~r~~h~Cannot restore attached object!", 5000, 3);
			}
			else if(IsPlayerAttachedObjectSlotUsed(playerid, slot)) {
			    format(aoe_str, sizeof(aoe_str), "* Sorry, you can't restore your last attached object as you had an attached object in that slot already (%i)!", slot);
   				SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
		    	GameTextForPlayer(playerid, "~r~~h~Cannot restore attached object!", 5000, 3);
			}
			else
			{
				RestorePlayerAttachedObject(playerid, slot);
				format(aoe_str, sizeof(aoe_str), "* You've restored your attaced object from slot/index number %i [Model: %d - Bone: %s (%i)]!", slot, pao[playerid][slot][aoModelID],
				GetAttachedObjectBoneName(pao[playerid][slot][aoBoneID]), pao[playerid][slot][aoBoneID]);
				SendClientMessage(playerid, COLOR_GREEN, aoe_str);
				format(aoe_str, sizeof(aoe_str), "~g~Restored your attached object~n~~w~index/number: %i~n~Model: %d - Bone: %i", slot, pao[playerid][slot][aoModelID], pao[playerid][slot][aoBoneID]);
				GameTextForPlayer(playerid, aoe_str, 5000, 3);
			}
		}
		return 1;
	}
	if(!strcmp(cmdtext, "/totalattachedobjects", true) || !strcmp(cmdtext, "/taos", true))
	{
		SendClientMessage(playerid, COLOR_CYAN, "----------------------------------------------------------------------------------------------------");
		format(aoe_str, sizeof(aoe_str), "-- Total attached object(s) attached on you: %d", GetPlayerAttachedObjectsCount(playerid));
		SendClientMessage(playerid, 0x00DDDDFF, aoe_str);
		format(aoe_str, sizeof(aoe_str), "-- Total of all attached object(s) in server: %d", GetAttachedObjectsCount());
		SendClientMessage(playerid, 0x00DDDDFF, aoe_str);
		SendClientMessage(playerid, COLOR_CYAN, "----------------------------------------------------------------------------------------------------");
		return 1;
	}

    dcmd(createattachedobject, 20, cmdtext);
    dcmd(cao, 3, cmdtext);
    dcmd(editattachedobject, 18, cmdtext);
    dcmd(eao, 3, cmdtext);
    dcmd(removeattachedobject, 20, cmdtext);
    dcmd(rao, 3, cmdtext);
    dcmd(saveattachedobject, 18, cmdtext);
    dcmd(sao, 3, cmdtext);
    dcmd(saveattachedobjects, 19, cmdtext);
    dcmd(saos, 4, cmdtext);
    dcmd(loadattachedobject, 18, cmdtext);
    dcmd(lao, 3, cmdtext);
    dcmd(loadattachedobjects, 19, cmdtext);
    dcmd(laos, 4, cmdtext);
    dcmd(convertattachedobjectfile, 25, cmdtext);
    dcmd(convertattachedobject, 21, cmdtext);
    dcmd(caof, 4, cmdtext);
    dcmd(attachedobjectstats, 19, cmdtext);
    dcmd(aos, 3, cmdtext);
    dcmd(duplicateattachedobject, 23, cmdtext);
    dcmd(dao, 3, cmdtext);
    dcmd(setattachedobjectslot, 21, cmdtext);
    dcmd(setattachedobjectindex, 22, cmdtext);
    dcmd(saoi, 4, cmdtext);
    dcmd(setattachedobjectmodel, 22, cmdtext);
    dcmd(saom, 4, cmdtext);
    dcmd(setattachedobjectbone, 21, cmdtext);
    dcmd(saob, 4, cmdtext);
    dcmd(setattachedobjectoffsetx, 24, cmdtext);
    dcmd(saoox, 5, cmdtext);
    dcmd(setattachedobjectoffsety, 24, cmdtext);
    dcmd(saooy, 5, cmdtext);
    dcmd(setattachedobjectoffsetz, 24, cmdtext);
    dcmd(saooz, 5, cmdtext);
    dcmd(setattachedobjectrotx, 21, cmdtext);
    dcmd(saorx, 5, cmdtext);
    dcmd(setattachedobjectroty, 21, cmdtext);
    dcmd(saory, 5, cmdtext);
    dcmd(setattachedobjectrotz, 21, cmdtext);
    dcmd(saorz, 5, cmdtext);
	dcmd(setattachedobjectscalex, 23, cmdtext);
    dcmd(saosx, 5, cmdtext);
    dcmd(setattachedobjectscaley, 23, cmdtext);
    dcmd(saosy, 5, cmdtext);
    dcmd(setattachedobjectscalez, 23, cmdtext);
    dcmd(saosz, 5, cmdtext);
    dcmd(setattachedobjectmc1, 20, cmdtext);
    dcmd(saomc1, 6, cmdtext);
    dcmd(setattachedobjectmc2, 20, cmdtext);
    dcmd(saomc2, 6, cmdtext);
    return 0;
}

// -----------------------------------------------------------------------------

dcmd_createattachedobject(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(GetPlayerAttachedObjectsCount(playerid) >= MAX_PLAYER_ATTACHED_OBJECTS) {
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't have more attached object(s) [Limit exceed]!");
	    SendClientMessage(playerid, COLOR_YELLOW, "* You can only hold "#MAX_PLAYER_ATTACHED_OBJECTS" attached object(s)!");
		GameTextForPlayer(playerid, "~r~~h~Too many attached objects!", 5000, 3);
	}
	else
	{
	    new idx, tmp[20], tmp2[20], tmp3[20], slot, model, bone;
	    tmp = strtok(params, idx), slot = strval(tmp), SetPVarInt(playerid, "CreateAttachedObjectIndex", slot);
		if(!strlen(tmp)) AOE_ShowPlayerDialog(playerid, 6, AOED_CREATE_SLOT, "Create Attached Object", "Select", "Cancel");
		else if(!IsValidAttachedObjectSlot(slot) || !IsNumeric(tmp)) {
			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object slot/index number [%s]!", tmp);
    		SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
    		GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 5000, 3);
		}
		else if(IsPlayerAttachedObjectSlotUsed(playerid, slot)) AOE_ShowPlayerDialog(playerid, 9, AOED_CREATE_REPLACE, "Create Attached Object (Replace)", "Yes", "Back");
		else
		{
		    tmp2 = strtok(params, idx), model = strval(tmp2), SetPVarInt(playerid, "CreateAttachedObjectModel", model);
			if(!strlen(tmp2)) AOE_ShowPlayerDialog(playerid, 4, AOED_CREATE_MODEL, "Create Attached Object", "Enter", "Sel Index");
		    else if(!IsValidObjectModel(model) || !IsNumeric(tmp2)) {
			    format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid object model number/id [%s]!", tmp2);
			    SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			    GameTextForPlayer(playerid, "~r~~h~Invalid object model!", 5000, 3);
			}
	    	else
			{
			    tmp3 = strtok(params, idx), bone = strval(tmp3), SetPVarInt(playerid, "CreateAttachedObjectBone", bone);
				if(!strlen(tmp3)) AOE_ShowPlayerDialog(playerid, 5, AOED_CREATE_BONE, "Create Attached Object", "Select", "Sel Model");
				else if(!IsValidAttachedObjectBone(bone) || !IsNumeric(tmp3)) {
					format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object bone number/id [%s]!", tmp3);
					SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
					GameTextForPlayer(playerid, "~r~~h~Invalid attached object bone!", 5000, 3);
		    	}
    			else
				{
					CreatePlayerAttachedObject(playerid, slot, model, bone);
					format(aoe_str, sizeof(aoe_str), "* Created attached object model %d at slot/index number %i [Bone: %s (%i)]!", model, slot, GetAttachedObjectBoneName(bone), bone);
					SendClientMessage(playerid, COLOR_BLUE, aoe_str);
					format(aoe_str, sizeof(aoe_str), "~b~Created attached object~n~~w~index/number: %i~n~Model: %d - Bone: %i", slot, model, bone);
					GameTextForPlayer(playerid, aoe_str, 5000, 3);
					AOE_ShowPlayerDialog(playerid, 10, AOED_CREATE_EDIT, "Create Attached Object (Edit)", "Edit", "Skip");
			    }
			}
		}
	}
	return 1;
}

dcmd_cao(playerid, params[]) return dcmd_createattachedobject(playerid, params);

dcmd_editattachedobject(playerid, params[])
{
	if(GetPVarInt(playerid, "EditingAttachedObject") == 1) CancelEdit(playerid);
	else if(GetPlayerState(playerid) == PLAYER_STATE_WASTED || GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid)) {
		SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 5000, 3);
	}
	else if(!strlen(params)) AOE_ShowPlayerDialog(playerid, 7, AOED_EDIT_SLOT, "Edit Attached Object", "Edit/Create", "Cancel");
	else
	{
		new slot = strval(params);
		SetPVarInt(playerid, "EditAttachedObjectIndex", slot);
		if(!IsValidAttachedObjectSlot(slot) || !IsNumeric(params)) {
    		format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object slot/index number [%s]!", params);
    	   	SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
    	   	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 5000, 3);
		}
		else if(!IsPlayerAttachedObjectSlotUsed(playerid, slot))
		{
 	  		format(aoe_str, sizeof(aoe_str), "* Sorry, you don't have attached object at slot/index number %i!", slot);
            SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
  			format(aoe_str, sizeof(aoe_str), "~r~~h~You have no attached object~n~~w~index/number: %i", slot);
    	   	GameTextForPlayer(playerid, aoe_str, 5000, 3);
		}
		else
		{
    	   	EditAttachedObject(playerid, slot);
    	   	SetPVarInt(playerid, "EditingAttachedObject", 1);
			format(aoe_str, sizeof(aoe_str), "* You're now editing your attached object from slot/index number %i!", slot);
            SendClientMessage(playerid, COLOR_GREEN, aoe_str);
			format(aoe_str, sizeof(aoe_str), "~g~Editing your attached object~n~~w~index/number: %i", slot);
			GameTextForPlayer(playerid, aoe_str, 5000, 3);
			if(IsValidPlayerAttachedObject(playerid, slot) != 1) SendClientMessage(playerid, COLOR_RED, "Warning: This attached object is having unknown data, please save it first to refresh the data!");
		 	if(IsPlayerInAnyVehicle(playerid))	SendClientMessage(playerid, COLOR_YELLOW, "** Hint: Use {FFFFFF}~k~~VEHICLE_ACCELERATE~{FFFF00} key to look around");
			else SendClientMessage(playerid, COLOR_YELLOW, "** Hint: Use {FFFFFF}~k~~PED_SPRINT~{FFFF00} key to look around");
   		}
	}
	return 1;
}

dcmd_eao(playerid, params[]) return dcmd_editattachedobject(playerid, params);

dcmd_removeattachedobject(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid)) {
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 5000, 3);
	}
	else if(!strlen(params)) AOE_ShowPlayerDialog(playerid, 7, AOED_REMOVE_SLOT, "Remove Attached Object", "Remove", "Cancel");
	else
	{
		new slot = strval(params);
		SetPVarInt(playerid, "RemoveAttachedObjectIndex", slot);
  		if(!IsValidAttachedObjectSlot(slot) || !IsNumeric(params)) {
    		format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object slot/index number [%s]!", params);
    	    SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
    	    GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 5000, 3);
  		}
    	else if(!IsPlayerAttachedObjectSlotUsed(playerid, slot))
  		{
    		format(aoe_str, sizeof(aoe_str), "* Sorry, you don't have attached object at slot/index number %i!", slot);
            SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			format(aoe_str, sizeof(aoe_str), "~r~~h~You have no attached object~n~~w~index/number: %i", slot);
    	    GameTextForPlayer(playerid, aoe_str, 5000, 3);
    	}
    	else
    	{
    	    RemovePlayerAttachedObjectEx(playerid, slot);
         	format(aoe_str, sizeof(aoe_str), "* You've removed your attached object from slot/index number %i!", slot);
            SendClientMessage(playerid, COLOR_RED, aoe_str);
			format(aoe_str, sizeof(aoe_str), "~r~Removed your attached object~n~~w~index/number: %i", slot);
			GameTextForPlayer(playerid, aoe_str, 5000, 3);
    	}
	}
	return 1;
}

dcmd_rao(playerid, params[]) return dcmd_removeattachedobject(playerid, params);

dcmd_saveattachedobject(playerid, params[])
{
	GetPlayerName(playerid, PlayerName, MAX_PLAYER_NAME);
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid)) {
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 5000, 3);
	}
	else
	{
   		new idx, tmp[20], tmp2[24], slot, ao_file[32];
	    tmp = strtok(params, idx), slot = strval(tmp), SetPVarInt(playerid, "SaveAttachedObjectIndex", slot);
     	if(!strlen(tmp)) AOE_ShowPlayerDialog(playerid, 7, AOED_SAVE_SLOT, "Save Attached Object", "Select", "Cancel");
     	else if(!IsValidAttachedObjectSlot(slot) || !IsNumeric(tmp)) {
			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object slot/index number [%s]!", tmp);
			SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
 			GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 5000, 3);
		}
		else if(!IsPlayerAttachedObjectSlotUsed(playerid, slot))
		{
			format(aoe_str, sizeof(aoe_str), "* Sorry, you don't have attached object at slot/index number %i!", slot);
  			SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
		 	format(aoe_str, sizeof(aoe_str), "~r~~h~You have no attached object~n~~w~index/number: %i", slot);
   			GameTextForPlayer(playerid, aoe_str, 5000, 3);
		}
		else
		{
		    tmp2 = strtok(params, idx), SetPVarString(playerid, "SaveAttachedObjectName", tmp2);
	    	if(!strlen(tmp2)) AOE_ShowPlayerDialog(playerid, 15, AOED_SAVE, "Save Attached Object", "Save", "Sel Idx");
			else if(!IsValidFileName(tmp2))
			{
				    format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid file name [%s]!", tmp2);
					SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
					SendClientMessage(playerid, COLOR_YELLOW, "** Valid length are greater than or equal to 1 and less than or equal to 24 characters.");
					SendClientMessage(playerid, COLOR_YELLOW, "** Valid characters are: A to Z or a to z, 0 to 9 and @, $, (, ), [, ], _, =, .");
	  				GameTextForPlayer(playerid, "~r~~h~Invalid file name!", 5000, 3);
			}
	    	else
	    	{
	        	format(ao_file, sizeof(ao_file), AO_FILENAME, tmp2);
	        	if(dini_Exists(ao_file)) {
		        	if(IsPlayerAdmin(playerid)) AOE_ShowPlayerDialog(playerid, 18, AOED_SAVE_REPLACE, "Save Attached Object", "Yes", "Cancel");
					else {
		            	format(aoe_str, sizeof(aoe_str), "* Sorry, attached object file \"%s\" already exists!", tmp2);
		            	SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
	         			GameTextForPlayer(playerid, "~r~~h~File already exists!", 5000, 3);
					}
				}
				else
				{
	            	if(IsValidPlayerAttachedObject(playerid, slot) != 1) {
	                    SendClientMessage(playerid, COLOR_RED, "* Error: Invalid attached object data, save canceled");
    					GameTextForPlayer(playerid, "~r~~h~Invalid attached object data!", 5000, 3);
					}
					else
	                {
	                    SendClientMessage(playerid, COLOR_WHITE, "* Saving attached object file, please wait...");
						AOE_SavePlayerAttachedObject(playerid, slot, ao_file);
						format(aoe_str, sizeof(aoe_str), "** Your attached object from index %i has been saved as \"%s\" (Model: %d - Bone: %i)!", slot, tmp2, pao[playerid][slot][aoModelID], pao[playerid][slot][aoBoneID]);
						SendClientMessage(playerid, COLOR_BLUE, aoe_str);
					}
	            }
	        }
	    }
	}
	return 1;
}

dcmd_sao(playerid, params[]) return dcmd_saveattachedobject(playerid, params);

dcmd_saveattachedobjects(playerid, params[])
{
	GetPlayerName(playerid, PlayerName, MAX_PLAYER_NAME);
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid)) {
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 5000, 3);
	}
	else
	{
	    if(!strlen(params)) AOE_ShowPlayerDialog(playerid, 15, AOED_SAVE2, "Save Attached Object(s) Set", "Save", "Cancel");
		else if(!IsValidFileName(params)) {
  			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid file name [%s]!", params);
			SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			SendClientMessage(playerid, COLOR_YELLOW, "** Valid length are greater than or equal to 1 and less than or equal to 24 characters.");
			SendClientMessage(playerid, COLOR_YELLOW, "** Valid characters are: A to Z or a to z, 0 to 9 and @, $, (, ), [, ], _, =, .");
			GameTextForPlayer(playerid, "~r~~h~Invalid file name!", 5000, 3);
	    }
	    else
	    {
	        new ao_file[32], slots;
	        format(ao_file, sizeof(ao_file), AO_FILENAME, params);
	        SetPVarString(playerid, "SaveAttachedObjectName", params);
	        if(dini_Exists(ao_file)) {
         		if(IsPlayerAdmin(playerid)) AOE_ShowPlayerDialog(playerid, 18, AOED_SAVE2_REPLACE, "Save Attached Object(s) Set", "Save", "Cancel");
		 		else {
			 		format(aoe_str, sizeof(aoe_str), "* Sorry, attached object(s) set file \"%s\" already exists!", params);
		            SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
	         		GameTextForPlayer(playerid, "~r~~h~File already exists!", 5000, 3);
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_WHITE, "* Saving attached object(s) set file, please wait...");
			    for(new slot = 0; slot < MAX_PLAYER_ATTACHED_OBJECTS; slot++)
			    {
   					if(IsValidPlayerAttachedObject(playerid, slot) != 1) continue;
					else {
	                    slots += AOE_SavePlayerAttachedObject(playerid, slot, ao_file);
					}
	            }
				if(!slots && dini_Exists(ao_file)) {
					dini_Remove(ao_file);
					SendClientMessage(playerid, COLOR_RED, "** Error: file saving was canceled because there were no valid attached object!");
				}
				else {
				    format(aoe_str, sizeof(aoe_str), "** Your attached object set has been saved as \"%s\" (Total: %i)!", params, slots);
					SendClientMessage(playerid, COLOR_BLUE, aoe_str);
				}
	        }
	    }
	}
	return 1;
}

dcmd_saos(playerid, params[]) return dcmd_saveattachedobjects(playerid, params);

dcmd_loadattachedobject(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(GetPlayerAttachedObjectsCount(playerid) >= MAX_PLAYER_ATTACHED_OBJECTS) {
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't have more attached object(s) [Limit exceed]!");
	    SendClientMessage(playerid, COLOR_YELLOW, "* You can only hold "#MAX_PLAYER_ATTACHED_OBJECTS" attached objects!");
		GameTextForPlayer(playerid, "~r~~h~Too many attached objects!", 5000, 3);
	}
	else
	{
	    new idx, tmp[32], tmp2[20], ao_file[32], slot;
	    tmp = strtok(params, idx), SetPVarString(playerid, "LoadAttachedObjectName", tmp);
	    if(!strlen(tmp)) AOE_ShowPlayerDialog(playerid, 16, AOED_LOAD, "Load Attached Object", "Enter", "Cancel");
		else if(!IsValidFileName(tmp)) {
			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid file name [%s]!", tmp);
			SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			SendClientMessage(playerid, COLOR_YELLOW, "** Valid length are greater than or equal to 1 and less than or equal to 24 characters.");
			SendClientMessage(playerid, COLOR_YELLOW, "** Valid characters are: A to Z or a to z, 0 to 9 and @, $, (, ), [, ], _, =, .");
			GameTextForPlayer(playerid, "~r~~h~Invalid file name!", 5000, 3);
		}
		else
		{
		    format(ao_file, sizeof(ao_file), AO_FILENAME, tmp);
		    if(!dini_Exists(ao_file)) {
      			format(aoe_str, sizeof(aoe_str), "* Sorry, attached object file \"%s\" does not exist!", tmp);
	            SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
		        GameTextForPlayer(playerid, "~r~~h~File does not exist!", 5000, 3);
			}
			else
			{
			    tmp2 = strtok(params, idx), slot = strval(tmp2), SetPVarInt(playerid, "LoadAttachedObjectIndex", slot);
			    if(!strlen(tmp2)) {
			        SendClientMessage(playerid, COLOR_WHITE, "* Load Attached Object: Please specify attached object index...");
					ShowPlayerDialog(playerid, AOED_LOAD_SLOT, DIALOG_STYLE_INPUT, "Load Attached Object", "Enter the index number of attached object in the file:", "Load", "Sel File");
			    }
			    else if(!IsValidAttachedObjectSlot(slot) || !IsNumeric(tmp2)) {
					format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object slot/index number [%s]!", tmp2);
  					SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
    				GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 5000, 3);
				}
   				else
   				{
       				if(!AOE_IsValidAttachedObjectInFile(slot, ao_file)) {
                        format(aoe_str, sizeof(aoe_str), "* Sorry, there is no valid attached object from slot/index number %i!", slot);
  						SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
    					GameTextForPlayer(playerid, "~r~~h~Attached object slot not found!", 5000, 3);
					}
					else if(IsPlayerAttachedObjectSlotUsed(playerid, slot)) AOE_ShowPlayerDialog(playerid, 17, AOED_LOAD_REPLACE, "Load & Replace Attached Object", "Yes", "Cancel");
   	                else if(!AOE_LoadPlayerAttachedObject(playerid, slot, ao_file)) {
   	                    SendClientMessage(playerid, COLOR_RED, "* Error: Invalid attached object data, load canceled");
   	                    pao[playerid][slot][aoValid] = 0;
    					GameTextForPlayer(playerid, "~r~~h~Invalid attached object data!", 5000, 3);
					}
					else
					{
					    SendClientMessage(playerid, COLOR_WHITE, "* Loading attached object file, please wait...");
				   		format(aoe_str, sizeof(aoe_str), "** You've loaded attached object from file \"%s\" by %s from skin %i (Index: %i - Model: %d - Bone: %i)!", tmp, dini_Get(ao_file, "auth"), dini_Int(ao_file, "skin"),
		   				slot, pao[playerid][slot][aoModelID], pao[playerid][slot][aoBoneID]);
						SendClientMessage(playerid, COLOR_GREEN, aoe_str);
					}
   				}
			}
		}
	}
	return 1;
}

dcmd_lao(playerid, params[]) return dcmd_loadattachedobject(playerid, params);

dcmd_loadattachedobjects(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command when editing an attached object!");
	else if(GetPlayerAttachedObjectsCount(playerid) >= MAX_PLAYER_ATTACHED_OBJECTS) {
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't have more attached object(s) [Limit exceed]!");
	    SendClientMessage(playerid, COLOR_YELLOW, "* You can only hold "#MAX_PLAYER_ATTACHED_OBJECTS" attached objects!");
		GameTextForPlayer(playerid, "~r~~h~Too many attached objects!", 5000, 3);
	}
	else
	{
	    if(!strlen(params)) AOE_ShowPlayerDialog(playerid, 16, AOED_LOAD2, "Load Attached Object(s) Set", "Load", "Cancel");
		else if(!IsValidFileName(params)) {
  			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid file name [%s]!", params);
			SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			SendClientMessage(playerid, COLOR_YELLOW, "** Valid length are greater than or equal to 1 and less than or equal to 24 characters.");
			SendClientMessage(playerid, COLOR_YELLOW, "** Valid characters are: A to Z or a to z, 0 to 9 and @, $, (, ), [, ], _, =, .");
			GameTextForPlayer(playerid, "~r~~h~Invalid file name!", 5000, 3);
		}
		else
		{
		    new ao_file[32], slots;
		    format(ao_file, sizeof(ao_file), AO_FILENAME, params);
		    if(!dini_Exists(ao_file)) {
      			format(aoe_str, sizeof(aoe_str), "* Sorry, attached object file \"%s\" does not exist!", params);
	            SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
		        GameTextForPlayer(playerid, "~r~~h~File does not exist!", 5000, 3);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_WHITE, "* Loading attached object(s) set file, please wait...");
				for(new slot = 0; slot < MAX_PLAYER_ATTACHED_OBJECTS; slot++)
   				{
                    if(!AOE_IsValidAttachedObjectInFile(slot, ao_file)) continue;
   				    else if(IsPlayerAttachedObjectSlotUsed(playerid, slot)) {
   				        format(aoe_str, sizeof(aoe_str), "** Attached object slot %i is used, load canceled", slot);
   				        SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
   				        return 1;
					}
					else slots += AOE_LoadPlayerAttachedObject(playerid, slot, ao_file);
   				}
   				if(!slots) {
                	format(aoe_str, sizeof(aoe_str), "* Sorry, there is no valid attached object data found in the file \"%s\"!", params);
					SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
					GameTextForPlayer(playerid, "~r~~h~Attached object data not found!", 5000, 3);
				}
   				else {
	   				format(aoe_str, sizeof(aoe_str), "** You've loaded attached object(s) set from file \"%s\" by %s from skin %i (Total: %i)!", params, dini_Get(ao_file, "auth"), dini_Int(ao_file, "skin"), slots);
					SendClientMessage(playerid, COLOR_GREEN, aoe_str);
				}
			}
		}
	}
	return 1;
}

dcmd_laos(playerid, params[]) return dcmd_loadattachedobjects(playerid, params);

dcmd_convertattachedobjectfile(playerid, params[])
{
	GetPlayerName(playerid, PlayerName, MAX_PLAYER_NAME);
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
  	else
	{
	    new ao_file[32], ao_filename[32], slots, ao_filelen;
	    format(ao_file, sizeof(ao_file), AO_FILENAME, params);
	    format(ao_filename, sizeof(ao_filename), AOC_FILENAME, params);
		if(!strlen(params)) AOE_ShowPlayerDialog(playerid, 2, AOED_CONVERT, "Convert Attached Object(s) File", "Convert", "Cancel");
		else if(!IsValidFileName(ao_file)) {
			SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you've entered an invalid file name!");
			SendClientMessage(playerid, COLOR_YELLOW, "** Valid length are greater than or equal to 1 and less than or equal to 24 characters.");
			SendClientMessage(playerid, COLOR_YELLOW, "** Valid characters are: A to Z or a to z, 0 to 9 and @, $, (, ), [, ], _, =, .");
		    GameTextForPlayer(playerid, "~r~~h~Invalid file name!", 5000, 3);
		}
		else
		{
		    if(!fexist(ao_file)) {
      			format(aoe_str, sizeof(aoe_str), "* Sorry, attached object(s) file \"%s\" does not exist!", params);
	            SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
		        GameTextForPlayer(playerid, "~r~~h~File does not exist!", 5000, 3);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_WHITE, "* Converting file, please wait...");
			    slots += AOE_ConvertAttachedObjectFile(playerid, ao_file, ao_filename, ao_filelen);
			    format(aoe_str, sizeof(aoe_str), "** Attached object(s) file \"%s\" has been converted to \"%s\" raw code (%i objects, %i bytes)", ao_file, ao_filename, slots, ao_filelen);
 				SendClientMessage(playerid, COLOR_GREEN, aoe_str);
			}
		}
	}
	return 1;
}

dcmd_convertattachedobject(playerid, params[]) return dcmd_convertattachedobjectfile(playerid, params);
dcmd_caof(playerid, params[]) return dcmd_convertattachedobjectfile(playerid, params);

dcmd_attachedobjectstats(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid)) {
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 5000, 3);
	}
	else if(!strlen(params)) AOE_ShowPlayerDialog(playerid, 7, AOED_STATS_SLOT, "Attached Object Stats", "Select", "Cancel");
	else
	{
	    new slot = strval(params);
	    SetPVarInt(playerid, "AttachedObjectStatsIndex", slot);
     	if(!IsValidAttachedObjectSlot(slot) || !IsNumeric(params)) {
    		format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object slot/index number [%s]!", params);
    	    SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
    	    GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 5000, 3);
  		}
	    else if(!IsPlayerAttachedObjectSlotUsed(playerid, slot))
	    {
   			format(aoe_str, sizeof(aoe_str), "* Sorry, you don't have attached object at slot/index number %i!", slot);
            SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			format(aoe_str, sizeof(aoe_str), "~r~~h~You have no attached object~n~~w~index/number: %i", slot);
    	    GameTextForPlayer(playerid, aoe_str, 5000, 3);
		}
		else {
      		format(aoe_str, sizeof(aoe_str), "Your Attached Object Stats (%i)", slot);
		    AOE_ShowPlayerDialog(playerid, 8, AOED_STATS, aoe_str, "Print", "Close");
			if(IsPlayerAdmin(playerid)) SendClientMessage(playerid, COLOR_WHITE, "* As you're an admin, you can print this attached object stats & usage to the console");
		}
	}
	return 1;
}

dcmd_aos(playerid, params[]) return dcmd_attachedobjectstats(playerid, params);

dcmd_duplicateattachedobject(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid)) {
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 5000, 3);
	}
   	else
 	{
  		new idx, tmp[20], tmp2[20], slot1, slot2;
   		tmp = strtok(params, idx), slot1 = strval(tmp), SetPVarInt(playerid, "DuplicateAttachedObjectIndex1", slot1);
		if(!strlen(tmp)) AOE_ShowPlayerDialog(playerid, 7, AOED_DUPLICATE_SLOT1, "Duplicate Attached Object Index (1)", "Select", "Cancel");
        else if(!IsValidAttachedObjectSlot(slot1) || !IsNumeric(tmp)) {
  			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object slot/index number [%s]!", tmp);
    		SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
	    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 5000, 3);
      	}
		else if(!IsPlayerAttachedObjectSlotUsed(playerid, slot1))
  		{
			format(aoe_str, sizeof(aoe_str), "* Sorry, you don't have attached object at slot/index number %i!", slot1);
            SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			format(aoe_str, sizeof(aoe_str), "~r~~h~You have no attached object~n~~w~index/number: %i", slot1);
			GameTextForPlayer(playerid, aoe_str, 5000, 3);
   		}
		else
		{
			tmp2 = strtok(params, idx), slot2 = strval(tmp2), SetPVarInt(playerid, "DuplicateAttachedObjectIndex2", slot2);
 			if(!strlen(tmp2)) AOE_ShowPlayerDialog(playerid, 6, AOED_DUPLICATE_SLOT2, "Duplicate Attached Object Index (2)", "Select", "Sel Idx1");
			else if(!IsValidAttachedObjectSlot(slot2) || !IsNumeric(tmp2)) {
				format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object slot/index number [%s]!", tmp2);
  				SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
    			GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 5000, 3);
			}
			else if(slot1 == slot2) {
   				format(aoe_str, sizeof(aoe_str), "* Sorry, you can't duplicate your attached object from slot/index number %i to the same slot (%i) as it's already there?!!", slot1, slot2);
			    SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
		    	GameTextForPlayer(playerid, "~y~DOH!", 2500, 3);
			}
			else if(IsPlayerAttachedObjectSlotUsed(playerid, slot2)) AOE_ShowPlayerDialog(playerid, 13, AOED_DUPLICATE_REPLACE, "Duplicate Attached Object (Replace)", "Yes", "Sel Idx2");
			else
			{
				DuplicatePlayerAttachedObject(playerid, slot1, slot2);
    			format(aoe_str, sizeof(aoe_str), "* Duplicated your attached object from slot/index number %i to %i!", slot1, slot2);
       			SendClientMessage(playerid, COLOR_GREEN, aoe_str);
	   			format(aoe_str, sizeof(aoe_str), "~g~Attached object duplicated~n~~w~index/number:~n~%i to %i", slot1, slot2);
          		GameTextForPlayer(playerid, aoe_str, 5000, 3);
     		}
		}
	}
	return 1;
}

dcmd_dao(playerid, params[]) return dcmd_duplicateattachedobject(playerid, params);

dcmd_setattachedobjectindex(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid)) {
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 5000, 3);
	}
	else
	{
 		new idx, tmp[20], tmp2[20], slot, newslot;
	    tmp = strtok(params, idx), slot = strval(tmp), SetPVarInt(playerid, "SetAttachedObjectIndex1", slot);
		if(!strlen(tmp)) AOE_ShowPlayerDialog(playerid, 7, AOED_SET_SLOT1, "Set Attached Object Index (1)", "Select", "Cancel");
		else if(!IsValidAttachedObjectSlot(slot) || !IsNumeric(tmp)) {
   			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object slot/index number [%s]!", tmp);
	    	SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
	    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 5000, 3);
		}
		else if(!IsPlayerAttachedObjectSlotUsed(playerid, slot))
  		{
			format(aoe_str, sizeof(aoe_str), "* Sorry, you don't have attached object at slot/index number %i!", slot);
			SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			format(aoe_str, sizeof(aoe_str), "~r~~h~You have no attached object~n~~w~index/number: %i", slot);
			GameTextForPlayer(playerid, aoe_str, 5000, 3);
   		}
		else
		{
			tmp2 = strtok(params, idx), newslot = strval(tmp2), SetPVarInt(playerid, "SetAttachedObjectIndex2", newslot);
 			if(!strlen(tmp2)) AOE_ShowPlayerDialog(playerid, 6, AOED_SET_SLOT2, "Set Attached Object Index (2)", "Select", "Sel Idx1");
			else if(!IsValidAttachedObjectSlot(newslot) || !IsNumeric(tmp2)) {
				format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object slot/index number [%s]!", tmp2);
  				SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
    			GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 5000, 3);
			}
			else if(slot == newslot) {
   				format(aoe_str, sizeof(aoe_str), "* Sorry, you can't move your attached object from slot/index number %i to the same slot (%i) as it's already there?!!", slot, newslot);
			    SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			    GameTextForPlayer(playerid, "~y~DOH!", 2500, 3);
			}
			else if(IsPlayerAttachedObjectSlotUsed(playerid, newslot))AOE_ShowPlayerDialog(playerid, 14, AOED_SET_SLOT_REPLACE, "Set Attached Object Index (Replace)", "Yes", "Sel Idx2");
			else
			{
			    MovePlayerAttachedObjectIndex(playerid, slot, newslot);
   				format(aoe_str, sizeof(aoe_str), "* Moved your attached object from slot/index number %i to %i!", slot, newslot);
                SendClientMessage(playerid, COLOR_GREEN, aoe_str);
				format(aoe_str, sizeof(aoe_str), "~g~Attached object moved~n~~w~index/number:~n~%i to %i", slot, newslot);
                GameTextForPlayer(playerid, aoe_str, 5000, 3);
       		}
	    }
	}
	return 1;
}

dcmd_setattachedobjectslot(playerid, params[]) return dcmd_setattachedobjectindex(playerid, params);
dcmd_saoi(playerid, params[]) return dcmd_setattachedobjectindex(playerid, params);

dcmd_setattachedobjectmodel(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid)) {
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 5000, 3);
	}
	else
	{
 		new idx, tmp[20], tmp2[20], slot, newmodel;
	    tmp = strtok(params, idx), slot = strval(tmp), SetPVarInt(playerid, "SetAttachedObjectModelIndex", slot);
   		if(!strlen(tmp)) AOE_ShowPlayerDialog(playerid, 7, AOED_SET_MODEL_SLOT, "Set Attached Object Model", "Select", "Cancel");
      	else if(!IsValidAttachedObjectSlot(slot) || !IsNumeric(tmp)) {
  			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object slot/index number [%s]!", tmp);
    		SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
	    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 5000, 3);
      	}
		else if(!IsPlayerAttachedObjectSlotUsed(playerid, slot))
		{
			format(aoe_str, sizeof(aoe_str), "* Sorry, you don't have attached object at slot/index number %i!", slot);
            SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			format(aoe_str, sizeof(aoe_str), "~r~~h~You have no attached object~n~~w~index/number: %i", slot);
			GameTextForPlayer(playerid, aoe_str, 5000, 3);
   		}
       	else
       	{
       	    tmp2 = strtok(params, idx), newmodel = strval(tmp2), SetPVarInt(playerid, "SetAttachedObjectModel", newmodel);
       	    if(!strlen(tmp2)) AOE_ShowPlayerDialog(playerid, 4, AOED_SET_MODEL, "Set Attached Object Model", "Enter", "Sel Idx");
			else if(!IsValidObjectModel(newmodel) || !IsNumeric(tmp2)) {
				format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid object model number/id [%s]!", tmp2);
  				SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
    			GameTextForPlayer(playerid, "~r~~h~Invalid object model!", 5000, 3);
			}
			else if(newmodel == pao[playerid][slot][aoModelID]) {
   				format(aoe_str, sizeof(aoe_str), "* Sorry, you can't change this attached object (SID:%i) model from %d to the same model (%d)!!", slot, pao[playerid][slot][aoModelID], newmodel);
			    SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			    GameTextForPlayer(playerid, "~y~DOH!", 2500, 3);
			}
			else
			{
   				UpdatePlayerAttachedObject(playerid, slot, newmodel, pao[playerid][slot][aoBoneID]);
				format(aoe_str, sizeof(aoe_str), "* Updated your attached object model to %d at slot/index number %i!", newmodel, slot);
                SendClientMessage(playerid, COLOR_GREEN, aoe_str);
				format(aoe_str, sizeof(aoe_str), "~g~Attached object model updated~n~~w~%d (SID:%i)", newmodel, slot);
				GameTextForPlayer(playerid, aoe_str, 5000, 3);
			}
	    }
	}
	return 1;
}

dcmd_saom(playerid, params[]) return dcmd_setattachedobjectmodel(playerid, params);

dcmd_setattachedobjectbone(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid)) {
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 5000, 3);
	}
	else
	{
		new idx, tmp[20], tmp2[128], slot, newbone;
	    tmp = strtok(params, idx), slot = strval(tmp), SetPVarInt(playerid, "SetAttachedObjectBoneIndex", slot);
     	if(!strlen(tmp)) AOE_ShowPlayerDialog(playerid, 7, AOED_SET_BONE_SLOT, "Set Attached Object Bone", "Select", "Cancel");
      	else if(!IsValidAttachedObjectSlot(slot) || !IsNumeric(tmp)) {
			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object slot/index number [%s]!", tmp);
  			SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
  			GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 5000, 3);
      	}
		else if(!IsPlayerAttachedObjectSlotUsed(playerid, slot))
  		{
			format(aoe_str, sizeof(aoe_str), "* Sorry, you don't have attached object at slot/index number %i!", slot);
			SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			format(aoe_str, sizeof(aoe_str), "~r~~h~You have no attached object~n~~w~index/number: %i", slot);
			GameTextForPlayer(playerid, aoe_str, 5000, 3);
    	}
     	else
      	{
    		tmp2 = strrest(params, idx), newbone = GetAttachedObjectBoneID(tmp2), SetPVarInt(playerid, "SetAttachedObjectBone", newbone);
   			if(!strlen(tmp2)) AOE_ShowPlayerDialog(playerid, 5, AOED_SET_BONE, "Set Attached Object", "Set", "Sel Idx");
    		else if(!IsValidAttachedObjectBoneName(tmp2)) {
  				format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object bone [%s]!", tmp2);
  				SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
   				GameTextForPlayer(playerid, "~r~~h~Invalid attached object bone!", 5000, 3);
		    }
		    else if(newbone == pao[playerid][slot][aoBoneID]) {
    			format(aoe_str, sizeof(aoe_str), "* Sorry, you can't change this attached object (SID:%i) bone from %s to the same bone (%i)!!", slot, tmp2, pao[playerid][slot][aoBoneID]);
		    	SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
		    	GameTextForPlayer(playerid, "~y~DOH!", 2500, 3);
		    }
		    else
		    {
   				UpdatePlayerAttachedObject(playerid, slot, pao[playerid][slot][aoModelID], newbone);
				format(aoe_str, sizeof(aoe_str), "* Updated your attached object bone to %i (%s) at slot/index number %i!", newbone, GetAttachedObjectBoneName(newbone), slot);
				SendClientMessage(playerid, COLOR_GREEN, aoe_str);
				format(aoe_str, sizeof(aoe_str), "~g~Attached object bone updated~n~~w~%i (SID:%i)", newbone, slot);
				GameTextForPlayer(playerid, aoe_str, 5000, 3);
			}
	    }
	}
	return 1;
}

dcmd_saob(playerid, params[]) return dcmd_setattachedobjectbone(playerid, params);

dcmd_setattachedobjectoffsetx(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid)) {
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 5000, 3);
	}
	else
	{
	    new idx, tmp[20], tmp2[20], slot, Float:newoffsetx;
	    tmp = strtok(params, idx), slot = strval(tmp);
     	tmp2 = strtok(params, idx), newoffsetx = floatstr(tmp2);
     	if(!strlen(tmp) || !strlen(tmp2)) {
      		SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /setattachedobjectoffsetx <AttachedObjectSlot> <Float:OffsetX>");
       		SendClientMessage(playerid, COLOR_WHITE, "** Allows you to set your attached object position (OffsetX) with specified parameters");
      	}
      	else if(!IsValidAttachedObjectSlot(slot) || !IsNumeric(tmp)) {
   			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object slot/index number [%s]!", tmp);
 	    	SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
 	    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 5000, 3);
       	}
		else if(!IsPlayerAttachedObjectSlotUsed(playerid, slot))
  		{
			format(aoe_str, sizeof(aoe_str), "* Sorry, you don't have attached object at slot/index number %i!", slot);
			SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			format(aoe_str, sizeof(aoe_str), "~r~~h~You have no attached object~n~~w~index/number: %i", slot);
			GameTextForPlayer(playerid, aoe_str, 5000, 3);
		}
  		else if(!IsNumeric2(tmp2) || (newoffsetx < MIN_ATTACHED_OBJECT_OFFSET || newoffsetx > MAX_ATTACHED_OBJECT_OFFSET))
  		{
			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object offset(X) value [%s]!", tmp2);
			SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			SendClientMessage(playerid, COLOR_YELLOW, "** Allowed float (OffsetX) value are larger than "#MIN_ATTACHED_OBJECT_OFFSET" and less than "#MAX_ATTACHED_OBJECT_OFFSET"");
			GameTextForPlayer(playerid, "~r~~h~Invalid attached object offset value!", 5000, 3);
 		}
   		else
     	{
   			UpdatePlayerAttachedObjectEx(playerid, slot, pao[playerid][slot][aoModelID], pao[playerid][slot][aoBoneID], newoffsetx, pao[playerid][slot][aoY], pao[playerid][slot][aoZ], pao[playerid][slot][aoRX], pao[playerid][slot][aoRY], pao[playerid][slot][aoRZ],
   			pao[playerid][slot][aoSX], pao[playerid][slot][aoSY], pao[playerid][slot][aoSZ], pao[playerid][slot][aoMC1], pao[playerid][slot][aoMC2]);
       		format(aoe_str, sizeof(aoe_str), "* Updated your attached object position (OffsetX) to %.2f at slot/index number %i!", newoffsetx, slot);
			SendClientMessage(playerid, COLOR_GREEN, aoe_str);
			GameTextForPlayer(playerid, "~g~Attached object position updated!", 5000, 3);
		}
	}
	return 1;
}

dcmd_saoox(playerid, params[]) return dcmd_setattachedobjectoffsetx(playerid, params);

dcmd_setattachedobjectoffsety(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid)) {
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 5000, 3);
	}
	else
	{
	    new idx, tmp[20], tmp2[20], slot, Float:newoffsety;
	    tmp = strtok(params, idx), slot = strval(tmp);
     	tmp2 = strtok(params, idx), newoffsety = floatstr(tmp2);
     	if(!strlen(tmp) || !strlen(tmp2)) {
      		SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /setattachedobjectoffsety <AttachedObjectSlot> <Float:OffsetY>");
       		SendClientMessage(playerid, COLOR_WHITE, "** Allows you to set your attached object position (OffsetY) with specified parameters");
      	}
      	else if(!IsValidAttachedObjectSlot(slot) || !IsNumeric(tmp)) {
   			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object slot/index number [%s]!", tmp);
 	    	SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
 	    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 5000, 3);
       	}
		else if(!IsPlayerAttachedObjectSlotUsed(playerid, slot))
  		{
			format(aoe_str, sizeof(aoe_str), "* Sorry, you don't have attached object at slot/index number %i!", slot);
            SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			format(aoe_str, sizeof(aoe_str), "~r~~h~You have no attached object~n~~w~index/number: %i", slot);
			GameTextForPlayer(playerid, aoe_str, 5000, 3);
		}
  		else if(!IsNumeric2(tmp2) || (newoffsety < MIN_ATTACHED_OBJECT_OFFSET || newoffsety > MAX_ATTACHED_OBJECT_OFFSET))
  		{
			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object offset(Y) value [%s]!", tmp2);
			SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			SendClientMessage(playerid, COLOR_YELLOW, "** Allowed float (OffsetY) value are larger than "#MIN_ATTACHED_OBJECT_OFFSET" and less than "#MAX_ATTACHED_OBJECT_OFFSET"");
			GameTextForPlayer(playerid, "~r~~h~Invalid attached object offset value!", 5000, 3);
 		}
   		else
     	{
      		UpdatePlayerAttachedObjectEx(playerid, slot, pao[playerid][slot][aoModelID], pao[playerid][slot][aoBoneID], pao[playerid][slot][aoX], newoffsety, pao[playerid][slot][aoZ], pao[playerid][slot][aoRX], pao[playerid][slot][aoRY], pao[playerid][slot][aoRZ],
       		pao[playerid][slot][aoSX], pao[playerid][slot][aoSY], pao[playerid][slot][aoSZ], pao[playerid][slot][aoMC1], pao[playerid][slot][aoMC2]);
        	format(aoe_str, sizeof(aoe_str), "* Updated your attached object position (OffsetY) to %.2f at slot/index number %i!", newoffsety, slot);
			SendClientMessage(playerid, COLOR_GREEN, aoe_str);
			GameTextForPlayer(playerid, "~g~Attached object position updated!", 5000, 3);
		}
	}
	return 1;
}

dcmd_saooy(playerid, params[]) return dcmd_setattachedobjectoffsety(playerid, params);

dcmd_setattachedobjectoffsetz(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid)) {
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 5000, 3);
	}
	else
	{
	    new idx, tmp[20], tmp2[20], slot, Float:newoffsetz;
	    tmp = strtok(params, idx), slot = strval(tmp);
     	tmp2 = strtok(params, idx), newoffsetz = floatstr(tmp2);
     	if(!strlen(tmp) || !strlen(tmp2)) {
      		SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /setattachedobjectoffsetz <AttachedObjectSlot> <Float:OffsetZ>");
       		SendClientMessage(playerid, COLOR_WHITE, "** Allows you to set your attached object position (OffsetZ) with specified parameters");
      	}
      	else if(!IsValidAttachedObjectSlot(slot) || !IsNumeric(tmp)) {
   			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object slot/index number [%s]!", tmp);
 	    	SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
 	    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 5000, 3);
       	}
		else if(!IsPlayerAttachedObjectSlotUsed(playerid, slot))
  		{
			format(aoe_str, sizeof(aoe_str), "* Sorry, you don't have attached object at slot/index number %i!", slot);
            SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			format(aoe_str, sizeof(aoe_str), "~r~~h~You have no attached object~n~~w~index/number: %i", slot);
			GameTextForPlayer(playerid, aoe_str, 5000, 3);
		}
  		else if(!IsNumeric2(tmp2) || (newoffsetz < MIN_ATTACHED_OBJECT_OFFSET || newoffsetz > MAX_ATTACHED_OBJECT_OFFSET))
		{
			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object offset(Z) value [%s]!", tmp2);
			SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			SendClientMessage(playerid, COLOR_YELLOW, "** Allowed float (OffsetZ) value are larger than "#MIN_ATTACHED_OBJECT_OFFSET" and less than "#MAX_ATTACHED_OBJECT_OFFSET"");
			GameTextForPlayer(playerid, "~r~~h~Invalid attached object offset value!", 5000, 3);
 		}
   		else
     	{
      		UpdatePlayerAttachedObjectEx(playerid, slot, pao[playerid][slot][aoModelID], pao[playerid][slot][aoBoneID], pao[playerid][slot][aoX], pao[playerid][slot][aoY], newoffsetz, pao[playerid][slot][aoRX], pao[playerid][slot][aoRY], pao[playerid][slot][aoRZ],
       		pao[playerid][slot][aoSX], pao[playerid][slot][aoSY], pao[playerid][slot][aoSZ], pao[playerid][slot][aoMC1], pao[playerid][slot][aoMC2]);
        	format(aoe_str, sizeof(aoe_str), "* Updated your attached object position (OffsetZ) to %.2f at slot/index number %i!", newoffsetz, slot);
			SendClientMessage(playerid, COLOR_GREEN, aoe_str);
			GameTextForPlayer(playerid, "~g~Attached object position updated!", 5000, 3);
		}
	}
	return 1;
}

dcmd_saooz(playerid, params[]) return dcmd_setattachedobjectoffsetz(playerid, params);

dcmd_setattachedobjectrotx(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid)) {
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 5000, 3);
	}
	else
	{
	    new idx, tmp[20], tmp2[20], slot, Float:newrotx;
	    tmp = strtok(params, idx), slot = strval(tmp);
     	tmp2 = strtok(params, idx), newrotx = floatstr(tmp2);
     	if(!strlen(tmp) || !strlen(tmp2)) {
      		SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /setattachedobjectrotx <AttachedObjectSlot> <Float:RotX>");
    		SendClientMessage(playerid, COLOR_WHITE, "** Allows you to set your attached object rotation (RotX) with specified parameters");
      	}
      	else if(!IsValidAttachedObjectSlot(slot) || !IsNumeric(tmp)) {
   			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object slot/index number [%s]!", tmp);
 	    	SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
 	    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 5000, 3);
       	}
		else if(!IsPlayerAttachedObjectSlotUsed(playerid, slot))
  		{
			format(aoe_str, sizeof(aoe_str), "* Sorry, you don't have attached object at slot/index number %i!", slot);
            SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			format(aoe_str, sizeof(aoe_str), "~r~~h~You have no attached object~n~~w~index/number: %i", slot);
			GameTextForPlayer(playerid, aoe_str, 5000, 3);
		}
  		else if(!IsNumeric2(tmp2) || (newrotx < MIN_ATTACHED_OBJECT_ROT || newrotx > MAX_ATTACHED_OBJECT_ROT))
		{
			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object rotation(X) value [%s]!", tmp2);
			SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			SendClientMessage(playerid, COLOR_YELLOW, "** Allowed float (RotX) value are larger than "#MIN_ATTACHED_OBJECT_ROT" and less than "#MAX_ATTACHED_OBJECT_ROT"");
			GameTextForPlayer(playerid, "~r~~h~Invalid attached object rotation value!", 5000, 3);
 		}
   		else
     	{
      		UpdatePlayerAttachedObjectEx(playerid, slot, pao[playerid][slot][aoModelID], pao[playerid][slot][aoBoneID], pao[playerid][slot][aoX], pao[playerid][slot][aoY], pao[playerid][slot][aoZ], newrotx, pao[playerid][slot][aoRY], pao[playerid][slot][aoRZ],
       		pao[playerid][slot][aoSX], pao[playerid][slot][aoSY], pao[playerid][slot][aoSZ], pao[playerid][slot][aoMC1], pao[playerid][slot][aoMC2]);
        	format(aoe_str, sizeof(aoe_str), "* Updated your attached object rotation (RotX) to %.2f at slot/index number %i!", newrotx, slot);
			SendClientMessage(playerid, COLOR_GREEN, aoe_str);
			GameTextForPlayer(playerid, "~g~Attached object rotation updated!", 5000, 3);
		}
	}
	return 1;
}

dcmd_saorx(playerid, params[]) return dcmd_setattachedobjectrotx(playerid, params);

dcmd_setattachedobjectroty(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid)) {
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 5000, 3);
	}
	else
	{
	    new idx, tmp[20], tmp2[20], slot, Float:newroty;
	    tmp = strtok(params, idx), slot = strval(tmp);
     	tmp2 = strtok(params, idx), newroty = floatstr(tmp2);
     	if(!strlen(tmp) || !strlen(tmp2)) {
      		SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /setattachedobjectroty <AttachedObjectSlot> <Float:RotY>");
    		SendClientMessage(playerid, COLOR_WHITE, "** Allows you to set your attached object rotation (RotY) with specified parameters");
      	}
      	else if(!IsValidAttachedObjectSlot(slot) || !IsNumeric(tmp)) {
   			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object slot/index number [%s]!", tmp);
 	    	SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
 	    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 5000, 3);
       	}
		else if(!IsPlayerAttachedObjectSlotUsed(playerid, slot))
  		{
			format(aoe_str, sizeof(aoe_str), "* Sorry, you don't have attached object at slot/index number %i!", slot);
			SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			format(aoe_str, sizeof(aoe_str), "~r~~h~You have no attached object~n~~w~index/number: %i", slot);
			GameTextForPlayer(playerid, aoe_str, 5000, 3);
		}
  		else if(!IsNumeric2(tmp2) || (newroty < MIN_ATTACHED_OBJECT_ROT || newroty > MAX_ATTACHED_OBJECT_ROT))
  		{
			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object rotation(Y) value [%s]!", tmp2);
			SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			SendClientMessage(playerid, COLOR_YELLOW, "** Allowed float (RotY) value are larger than "#MIN_ATTACHED_OBJECT_ROT" and less than "#MAX_ATTACHED_OBJECT_ROT"");
			GameTextForPlayer(playerid, "~r~~h~Invalid attached object rotation value!", 5000, 3);
 		}
   		else
     	{
      		UpdatePlayerAttachedObjectEx(playerid, slot, pao[playerid][slot][aoModelID], pao[playerid][slot][aoBoneID], pao[playerid][slot][aoX], pao[playerid][slot][aoY], pao[playerid][slot][aoZ], pao[playerid][slot][aoRX], newroty, pao[playerid][slot][aoRZ],
       		pao[playerid][slot][aoSX], pao[playerid][slot][aoSY], pao[playerid][slot][aoSZ], pao[playerid][slot][aoMC1], pao[playerid][slot][aoMC2]);
        	format(aoe_str, sizeof(aoe_str), "* Updated your attached object rotation (RotY) to %.2f at slot/index number %i!", newroty, slot);
			SendClientMessage(playerid, COLOR_GREEN, aoe_str);
			GameTextForPlayer(playerid, "~g~Attached object rotation updated!", 5000, 3);
		}
	}
	return 1;
}

dcmd_saory(playerid, params[]) return dcmd_setattachedobjectroty(playerid, params);

dcmd_setattachedobjectrotz(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid)) {
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 5000, 3);
	}
	else
	{
	    new idx, tmp[20], tmp2[20], slot, Float:newrotz;
	    tmp = strtok(params, idx), slot = strval(tmp);
     	tmp2 = strtok(params, idx), newrotz = floatstr(tmp2);
     	if(!strlen(tmp) || !strlen(tmp2)) {
      		SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /setattachedobjectrotz <AttachedObjectSlot> <Float:RotZ>");
    		SendClientMessage(playerid, COLOR_WHITE, "** Allows you to set your attached object rotation (RotZ) with specified parameters");
      	}
      	else if(!IsValidAttachedObjectSlot(slot) || !IsNumeric(tmp)) {
   			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object slot/index number [%s]!", tmp);
 	    	SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
 	    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 5000, 3);
       	}
		else if(!IsPlayerAttachedObjectSlotUsed(playerid, slot))
  		{
			format(aoe_str, sizeof(aoe_str), "* Sorry, you don't have attached object at slot/index number %i!", slot);
			SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			format(aoe_str, sizeof(aoe_str), "~r~~h~You have no attached object~n~~w~index/number: %i", slot);
			GameTextForPlayer(playerid, aoe_str, 5000, 3);
		}
  		else if(!IsNumeric2(tmp2) || (newrotz < MIN_ATTACHED_OBJECT_ROT || newrotz > MAX_ATTACHED_OBJECT_ROT))
  		{
			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object rotation(Z) value [%s]!", tmp2);
			SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			SendClientMessage(playerid, COLOR_YELLOW, "** Allowed float (RotZ) value are larger than "#MIN_ATTACHED_OBJECT_ROT" and less than "#MAX_ATTACHED_OBJECT_ROT"");
			GameTextForPlayer(playerid, "~r~~h~Invalid attached object rotation value!", 5000, 3);
 		}
   		else
     	{
      		UpdatePlayerAttachedObjectEx(playerid, slot, pao[playerid][slot][aoModelID], pao[playerid][slot][aoBoneID], pao[playerid][slot][aoX], pao[playerid][slot][aoY], pao[playerid][slot][aoZ], pao[playerid][slot][aoRX], pao[playerid][slot][aoRY], newrotz,
       		pao[playerid][slot][aoSX], pao[playerid][slot][aoSY], pao[playerid][slot][aoSZ], pao[playerid][slot][aoMC1], pao[playerid][slot][aoMC2]);
        	format(aoe_str, sizeof(aoe_str), "* Updated your attached object rotation (RotZ) to %.2f at slot/index number %i!", newrotz, slot);
			SendClientMessage(playerid, COLOR_GREEN, aoe_str);
			GameTextForPlayer(playerid, "~g~Attached object rotation updated!", 5000, 3);
		}
	}
	return 1;
}

dcmd_saorz(playerid, params[]) return dcmd_setattachedobjectrotz(playerid, params);

dcmd_setattachedobjectscalex(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid)) {
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 5000, 3);
	}
	else
	{
	    new idx, tmp[20], tmp2[20], slot, Float:newscalex;
	    tmp = strtok(params, idx), slot = strval(tmp);
     	tmp2 = strtok(params, idx), newscalex = floatstr(tmp2);
     	if(!strlen(tmp) || !strlen(tmp2)) {
      		SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /setattachedobjectscalex <AttachedObjectSlot> <Float:ScaleX>");
    		SendClientMessage(playerid, COLOR_WHITE, "** Allows you to set your attached object size (ScaleX) with specified parameters");
      	}
      	else if(!IsValidAttachedObjectSlot(slot) || !IsNumeric(tmp)) {
   			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object slot/index number [%s]!", tmp);
 	    	SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
 	    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 5000, 3);
       	}
		else if(!IsPlayerAttachedObjectSlotUsed(playerid, slot))
  		{
			format(aoe_str, sizeof(aoe_str), "* Sorry, you don't have attached object at slot/index number %i!", slot);
            SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			format(aoe_str, sizeof(aoe_str), "~r~~h~You have no attached object~n~~w~index/number: %i", slot);
			GameTextForPlayer(playerid, aoe_str, 5000, 3);
		}
  		else if(!IsNumeric2(tmp2) || (newscalex < MIN_ATTACHED_OBJECT_SIZE || newscalex > MAX_ATTACHED_OBJECT_SIZE))
		{
			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object scale(X) value [%s]!", tmp2);
			SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			SendClientMessage(playerid, COLOR_YELLOW, "** Allowed float (ScaleX) value are larger than "#MIN_ATTACHED_OBJECT_SIZE" and less than "#MAX_ATTACHED_OBJECT_SIZE"");
			GameTextForPlayer(playerid, "~r~~h~Invalid attached object size value!", 5000, 3);
 		}
   		else
     	{
      		UpdatePlayerAttachedObjectEx(playerid, slot, pao[playerid][slot][aoModelID], pao[playerid][slot][aoBoneID], pao[playerid][slot][aoX], pao[playerid][slot][aoY], pao[playerid][slot][aoZ], pao[playerid][slot][aoRX], pao[playerid][slot][aoRY], pao[playerid][slot][aoRZ],
       		newscalex, pao[playerid][slot][aoSY], pao[playerid][slot][aoSZ], pao[playerid][slot][aoMC1], pao[playerid][slot][aoMC2]);
        	format(aoe_str, sizeof(aoe_str), "* Updated your attached object size (ScaleX) to %.2f at slot/index number %i!", newscalex, slot);
			SendClientMessage(playerid, COLOR_GREEN, aoe_str);
			GameTextForPlayer(playerid, "~g~Attached object size updated!", 5000, 3);
		}
	}
	return 1;
}

dcmd_saosx(playerid, params[]) return dcmd_setattachedobjectscalex(playerid, params);

dcmd_setattachedobjectscaley(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid)) {
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 5000, 3);
	}
	else
	{
	    new idx, tmp[20], tmp2[20], slot, Float:newscaley;
	    tmp = strtok(params, idx), slot = strval(tmp);
     	tmp2 = strtok(params, idx), newscaley = floatstr(tmp2);
     	if(!strlen(tmp) || !strlen(tmp2)) {
      		SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /setattachedobjectscaley <AttachedObjectSlot> <Float:ScaleY>");
    		SendClientMessage(playerid, COLOR_WHITE, "** Allows you to set your attached object size (ScaleY) with specified parameters");
      	}
      	else if(!IsValidAttachedObjectSlot(slot) || !IsNumeric(tmp)) {
   			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object slot/index number [%s]!", tmp);
 	    	SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
 	    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 5000, 3);
       	}
		else if(!IsPlayerAttachedObjectSlotUsed(playerid, slot))
  		{
			format(aoe_str, sizeof(aoe_str), "* Sorry, you don't have attached object at slot/index number %i!", slot);
			SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			format(aoe_str, sizeof(aoe_str), "~r~~h~You have no attached object~n~~w~index/number: %i", slot);
			GameTextForPlayer(playerid, aoe_str, 5000, 3);
		}
  		else if(!IsNumeric2(tmp2) || (newscaley < MIN_ATTACHED_OBJECT_SIZE || newscaley > MAX_ATTACHED_OBJECT_SIZE))
		{
			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object scale(Y) value [%s]!", tmp2);
			SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			SendClientMessage(playerid, COLOR_YELLOW, "** Allowed float (ScaleY) value are larger than "#MIN_ATTACHED_OBJECT_SIZE" and less than "#MAX_ATTACHED_OBJECT_SIZE"");
			GameTextForPlayer(playerid, "~r~~h~Invalid attached object size value!", 5000, 3);
 		}
   		else
     	{
      		UpdatePlayerAttachedObjectEx(playerid, slot, pao[playerid][slot][aoModelID], pao[playerid][slot][aoBoneID], pao[playerid][slot][aoX], pao[playerid][slot][aoY], pao[playerid][slot][aoZ], pao[playerid][slot][aoRX], pao[playerid][slot][aoRY], pao[playerid][slot][aoRZ],
       		pao[playerid][slot][aoSX], newscaley, pao[playerid][slot][aoSZ], pao[playerid][slot][aoMC1], pao[playerid][slot][aoMC2]);
        	format(aoe_str, sizeof(aoe_str), "* Updated your attached object size (ScaleY) to %.2f at slot/index number %i!", newscaley, slot);
			SendClientMessage(playerid, COLOR_GREEN, aoe_str);
			GameTextForPlayer(playerid, "~g~Attached object size updated!", 5000, 3);
		}
	}
	return 1;
}

dcmd_saosy(playerid, params[]) return dcmd_setattachedobjectscaley(playerid, params);

dcmd_setattachedobjectscalez(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid)) {
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 5000, 3);
	}
	else
	{
	    new idx, tmp[20], tmp2[20], slot, Float:newscalez;
	    tmp = strtok(params, idx), slot = strval(tmp);
     	tmp2 = strtok(params, idx), newscalez = floatstr(tmp2);
     	if(!strlen(tmp) || !strlen(tmp2)) {
      		SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /setattachedobjectscalez <AttachedObjectSlot> <Float:ScaleZ>");
    		SendClientMessage(playerid, COLOR_WHITE, "** Allows you to set your attached object size (ScaleZ) with specified parameters");
      	}
      	else if(!IsValidAttachedObjectSlot(slot) || !IsNumeric(tmp)) {
   			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object slot/index number [%s]!", tmp);
 	    	SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
 	    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 5000, 3);
       	}
		else if(!IsPlayerAttachedObjectSlotUsed(playerid, slot))
  		{
			format(aoe_str, sizeof(aoe_str), "* Sorry, you don't have attached object at slot/index number %i!", slot);
			SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			format(aoe_str, sizeof(aoe_str), "~r~~h~You have no attached object~n~~w~index/number: %i", slot);
			GameTextForPlayer(playerid, aoe_str, 5000, 3);
		}
  		else if(!IsNumeric2(tmp2) || (newscalez < MIN_ATTACHED_OBJECT_SIZE || newscalez > MAX_ATTACHED_OBJECT_SIZE))
  		{
			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object scale(Z) value [%s]!", tmp2);
			SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			SendClientMessage(playerid, COLOR_YELLOW, "** Allowed float (ScaleZ) value are larger than "#MIN_ATTACHED_OBJECT_SIZE" and less than "#MAX_ATTACHED_OBJECT_SIZE"");
			GameTextForPlayer(playerid, "~r~~h~Invalid attached object size value!", 5000, 3);
 		}
   		else
     	{
      		UpdatePlayerAttachedObjectEx(playerid, slot, pao[playerid][slot][aoModelID], pao[playerid][slot][aoBoneID], pao[playerid][slot][aoX], pao[playerid][slot][aoY], pao[playerid][slot][aoZ], pao[playerid][slot][aoRX], pao[playerid][slot][aoRY], pao[playerid][slot][aoRZ],
       		pao[playerid][slot][aoSX], pao[playerid][slot][aoSY], newscalez, pao[playerid][slot][aoMC1], pao[playerid][slot][aoMC2]);
        	format(aoe_str, sizeof(aoe_str), "* Updated your attached object size (ScaleZ) to %.2f at slot/index number %i!", newscalez, slot);
			SendClientMessage(playerid, COLOR_GREEN, aoe_str);
			GameTextForPlayer(playerid, "~g~Attached object size updated!", 5000, 3);
		}
	}
	return 1;
}

dcmd_saosz(playerid, params[]) return dcmd_setattachedobjectscalez(playerid, params);

dcmd_setattachedobjectmc1(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid)) {
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 5000, 3);
	}
	else
	{
	    new idx, tmp[20], tmp2[20], slot, newmc1;
	    tmp = strtok(params, idx), slot = strval(tmp);
     	if(!strlen(tmp)) {
      		SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /setattachedobjectmc1 <AttachedObjectSlot> <MaterialColor>");
    		SendClientMessage(playerid, COLOR_WHITE, "** Allows you to set your attached object color (Material:1) with specified parameters");
      	}
      	else if(!IsValidAttachedObjectSlot(slot) || !IsNumeric(tmp)) {
   			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object slot/index number [%s]!", tmp);
 	    	SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
 	    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 5000, 3);
       	}
		else if(!IsPlayerAttachedObjectSlotUsed(playerid, slot))
  		{
			format(aoe_str, sizeof(aoe_str), "* Sorry, you don't have attached object at slot/index number %i!", slot);
			SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			format(aoe_str, sizeof(aoe_str), "~r~~h~You have no attached object~n~~w~index/number: %i", slot);
			GameTextForPlayer(playerid, aoe_str, 5000, 3);
		}
		else
		{
		    new alpha[3], red[3], green[3], blue[3], colors[16];
		    tmp2 = strtok(params, idx);
           	if(!strlen(tmp2)) {
      			SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /setattachedobjectmc1 <AttachedObjectSlot> <MaterialColor>");
    			SendClientMessage(playerid, COLOR_WHITE, "** Allows you to set your attached object color (Material:1) with specified parameters");
      		}
		    else
			{
				strins(colors, tmp2, 0);
				if(IsNumeric2(tmp2)) newmc1 = strval(colors); // Integer
				else if(strlen(tmp2) == 8) // AARRGGBB
				{
					SetColor:
				    if(IsValidHex(colors))
				    {
			    		format(alpha, sizeof(alpha), "%c%c", colors[0], colors[1]);
   						format(red, sizeof(red), "%c%c", colors[2], colors[3]);
		    			format(green, sizeof(green), "%c%c", colors[4], colors[5]);
		    			format(blue, sizeof(blue), "%c%c", colors[6], colors[7]);
		    			newmc1 = RGBAtoARGB(RGB(HexToInt(red), HexToInt(green), HexToInt(blue), HexToInt(alpha)));
					}
					else goto Error;
				}
				else if(tmp2[0] == '#' && strlen(tmp2) == 9) { // #AARRGGBB
					strdel(colors, 0, 1);
					goto SetColor;
				}
				else if(tmp2[0] == '0' && tmp2[1] == 'x' && strlen(tmp2) == 10) { // 0xAARRGGBB
					strdel(colors, 0, 2);
					goto SetColor;
				}
				else
				{
				    Error:
					format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object color(MC1) value [%s]!", tmp2);
					SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
					SendClientMessage(playerid, COLOR_WHITE, "** Use hex color with ARGB (AARRGGBB) format (eg. 0xFFFF0000, #FF00FF00, FF0000FF) or integer value.");
					GameTextForPlayer(playerid, "~r~~h~Invalid attached object color value!", 5000, 3);
					return 1;
				}
				UpdatePlayerAttachedObjectEx(playerid, slot, pao[playerid][slot][aoModelID], pao[playerid][slot][aoBoneID], pao[playerid][slot][aoX], pao[playerid][slot][aoY], pao[playerid][slot][aoZ],
				pao[playerid][slot][aoRX], pao[playerid][slot][aoRY], pao[playerid][slot][aoRZ], pao[playerid][slot][aoSX], pao[playerid][slot][aoSY], pao[playerid][slot][aoSZ], newmc1, pao[playerid][slot][aoMC2]);
				format(aoe_str, sizeof(aoe_str), "* Updated your attached object color (MC1) to %s at slot/index number %i!", tmp2, slot);
				SendClientMessage(playerid, COLOR_GREEN, aoe_str);
				GameTextForPlayer(playerid, "~g~Attached object color updated!", 5000, 3);
			}
		}
	}
	return 1;
}

dcmd_saomc1(playerid, params[]) return dcmd_setattachedobjectmc1(playerid, params);

dcmd_setattachedobjectmc2(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid)) {
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 5000, 3);
	}
	else
	{
	    new idx, tmp[24], tmp2[24], slot, newmc2;
	    tmp = strtok(params, idx), slot = strval(tmp);
     	if(!strlen(tmp)) {
      		SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /setattachedobjectmc2 <AttachedObjectSlot> <MaterialColor>");
    		SendClientMessage(playerid, COLOR_WHITE, "** Allows you to set your attached object color (Material:2) with specified parameters");
      	}
      	else if(!IsValidAttachedObjectSlot(slot) || !IsNumeric(tmp)) {
   			format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object slot/index number [%s]!", tmp);
 	    	SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
 	    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 5000, 3);
       	}
		else if(!IsPlayerAttachedObjectSlotUsed(playerid, slot))
  		{
			format(aoe_str, sizeof(aoe_str), "* Sorry, you don't have attached object at slot/index number %i!", slot);
			SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
			format(aoe_str, sizeof(aoe_str), "~r~~h~You have no attached object~n~~w~index/number: %i", slot);
			GameTextForPlayer(playerid, aoe_str, 5000, 3);
		}
		else
		{
		    new alpha[3], red[3], green[3], blue[3], colors[10];
 			tmp2 = strtok(params, idx);
   			if(!strlen(tmp)) {
      			SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /setattachedobjectmc2 <AttachedObjectSlot> <MaterialColor>");
    			SendClientMessage(playerid, COLOR_WHITE, "** Allows you to set your attached object color (Material:2) with specified parameters");
      		}
		    else
			{
				strins(colors, tmp2, 0);
				if(IsNumeric2(tmp2)) newmc2 = strval(colors); // Integer
				else if(strlen(tmp2) == 8) // AARRGGBB
				{
					SetColor:
				    if(IsValidHex(colors))
				    {
			    		format(alpha, sizeof(alpha), "%c%c", colors[0], colors[1]);
   						format(red, sizeof(red), "%c%c", colors[2], colors[3]);
		    			format(green, sizeof(green), "%c%c", colors[4], colors[5]);
		    			format(blue, sizeof(blue), "%c%c", colors[6], colors[7]);
		    			newmc2 = RGBAtoARGB(RGB(HexToInt(red), HexToInt(green), HexToInt(blue), HexToInt(alpha)));
					}
					else goto Error;
				}
				else if(tmp2[0] == '#' && strlen(tmp2) == 9) { // #AARRGGBB
					strdel(colors, 0, 1);
					goto SetColor;
				}
				else if(tmp2[0] == '0' && tmp2[1] == 'x' && strlen(tmp2) == 10) { // 0xAARRGGBB
					strdel(colors, 0, 2);
					goto SetColor;
				}
				else
				{
			    	Error:
					format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid attached object color(MC2) value [%s]!", tmp2);
					SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
					SendClientMessage(playerid, COLOR_WHITE, "** Use hex color with ARGB (AARRGGBB) format (eg. 0xFFFF0000, #FF00FF00, FF0000FF) or integer value.");
					GameTextForPlayer(playerid, "~r~~h~Invalid attached object color value!", 5000, 3);
					return 1;
				}
				UpdatePlayerAttachedObjectEx(playerid, slot, pao[playerid][slot][aoModelID], pao[playerid][slot][aoBoneID], pao[playerid][slot][aoX], pao[playerid][slot][aoY], pao[playerid][slot][aoZ],
				pao[playerid][slot][aoRX], pao[playerid][slot][aoRY], pao[playerid][slot][aoRZ], pao[playerid][slot][aoSX], pao[playerid][slot][aoSY], pao[playerid][slot][aoSZ], pao[playerid][slot][aoMC1], newmc2);
				format(aoe_str, sizeof(aoe_str), "* Updated your attached object color (MC2) to %s at slot/index number %i!", tmp2, slot);
				SendClientMessage(playerid, COLOR_GREEN, aoe_str);
				GameTextForPlayer(playerid, "~g~Attached object color updated!", 5000, 3);
			}
		}
	}
	return 1;
}

dcmd_saomc2(playerid, params[]) return dcmd_setattachedobjectmc2(playerid, params);

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
	{
	    case AOED:
	    {
	        if(response)
	        {
				switch(listitem)
				{
				    case 0: OnPlayerCommandText(playerid, "/createattachedobject");
				    case 1: OnPlayerCommandText(playerid, "/duplicateattachedobject");
                    case 2: OnPlayerCommandText(playerid, "/editattachedobject");
                    case 3: OnPlayerCommandText(playerid, "/setattachedobjectindex");
                    case 4: OnPlayerCommandText(playerid, "/setattachedobjectmodel");
                    case 5: OnPlayerCommandText(playerid, "/setattachedobjectbone");
					case 6: OnPlayerCommandText(playerid, "/saveattachedobject");
				    case 7: OnPlayerCommandText(playerid, "/saveattachedobjects");
				    case 8: OnPlayerCommandText(playerid, "/loadattachedobject");
				    case 9: OnPlayerCommandText(playerid, "/loadattachedobjects");
				    case 10: OnPlayerCommandText(playerid, "/removeattachedobject");
					case 11: OnPlayerCommandText(playerid, "/removeattachedobjects");
				    case 12: OnPlayerCommandText(playerid, "/undodeleteattachedobject");
				    case 13: OnPlayerCommandText(playerid, "/convertattachedobjectfile");
				    case 14: OnPlayerCommandText(playerid, "/attachedobjectstats");
				    case 15: OnPlayerCommandText(playerid, "/totalattachedobjects");
				    case 16: AOE_ShowPlayerDialog(playerid, 1, AOED_HELP, "Attached Object Editor Help", "Close");
					case 17: AOE_ShowPlayerDialog(playerid, 3, AOED_ABOUT, "About Attached Object Editor", "Close");
				}
	        }
	        else SendClientMessage(playerid, COLOR_WHITE, "* You've closed attached object editor dialog");
	    }
	    case AOED_CREATE_SLOT:
		{
		    if(response) {
		        format(aoe_str, sizeof(aoe_str), "%i", listitem);
		        dcmd_createattachedobject(playerid, aoe_str);
		    }
      	}
	    case AOED_CREATE_MODEL:
	    {
	        if(response) {
	            new model;
	        	model = strval(inputtext), SetPVarInt(playerid, "CreateAttachedObjectModel", model);
				if(!IsValidObjectModel(model) || !IsNumeric(inputtext)) {
				    format(aoe_str, sizeof(aoe_str), "* Sorry, you've entered an invalid object model number/id [%s]!", inputtext);
				    SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
				    GameTextForPlayer(playerid, "~r~~h~Invalid object model!", 5000, 3);
				}
				else AOE_ShowPlayerDialog(playerid, 5, AOED_CREATE_BONE, "Create Attached Object", "Select", "Sel Model");
	        }
	        else AOE_ShowPlayerDialog(playerid, 6, AOED_CREATE_SLOT, "Create Attached Object", "Select", "Cancel");
	    }
	    case AOED_CREATE_BONE:
	    {
	        if(response)
			{
	            new slot, model, bone;
	            slot = GetPVarInt(playerid, "CreateAttachedObjectIndex");
	            model = GetPVarInt(playerid, "CreateAttachedObjectModel");
				bone = listitem+1, SetPVarInt(playerid, "CreateAttachedObjectBone", bone);
				CreatePlayerAttachedObject(playerid, slot, model, bone);
				format(aoe_str, sizeof(aoe_str), "* Created attached object model %d at slot/index number %i [Bone: %s (%i)]!", model, slot, GetAttachedObjectBoneName(bone), bone);
				SendClientMessage(playerid, COLOR_BLUE, aoe_str);
				format(aoe_str, sizeof(aoe_str), "~b~Created attached object~n~~w~index/number: %i~n~Model: %d - Bone: %i", slot, model, bone);
				GameTextForPlayer(playerid, aoe_str, 5000, 3);
				AOE_ShowPlayerDialog(playerid, 10, AOED_CREATE_EDIT, "Create Attached Object (Edit)", "Edit", "Skip");
	        }
	        else AOE_ShowPlayerDialog(playerid, 4, AOED_CREATE_MODEL, "Create Attached Object", "Enter", "Sel Index");
	    }
	    case AOED_CREATE_REPLACE:
	    {
	        if(response) AOE_ShowPlayerDialog(playerid, 4, AOED_CREATE_MODEL, "Create Attached Object", "Enter", "Sel Index");
	        else AOE_ShowPlayerDialog(playerid, 6, AOED_CREATE_SLOT, "Create Attached Object", "Select", "Cancel");
	    }
	    case AOED_CREATE_EDIT:
	    {
	        if(response) {
				format(aoe_str, sizeof(aoe_str), "%i", GetPVarInt(playerid, "CreateAttachedObjectIndex"));
				dcmd_editattachedobject(playerid, aoe_str);
			}
			else {
			    SendClientMessage(playerid, COLOR_WHITE, "* You've skipped to edit your attached object");
			    SendClientMessage(playerid, COLOR_WHITE, "** Note: use /editattachedobject command to edit your attached object");
			}
	    }
	    case AOED_EDIT_SLOT:
	    {
	        if(response)
     		{
	            if(IsPlayerAttachedObjectSlotUsed(playerid, listitem)) {
	            	format(aoe_str, sizeof(aoe_str), "%i", listitem);
	    			dcmd_editattachedobject(playerid, aoe_str);
				}
				else {
					format(aoe_str, sizeof(aoe_str), "%i", listitem);
					dcmd_createattachedobject(playerid, aoe_str);
				}
	        }
	    	SetPVarInt(playerid, "EditingAttachedObject", 0);
	    }
	    case AOED_REMOVE_SLOT:
	    {
	        if(response) {
	            format(aoe_str, sizeof(aoe_str), "%i", listitem);
	            dcmd_removeattachedobject(playerid, aoe_str);
	        }
	    }
	    case AOED_REMOVE:
		{
		    if(response)
	 		{
		        new slot = GetPVarInt(playerid, "RemoveAttachedObjectIndex");
                RemovePlayerAttachedObjectEx(playerid, slot), SetPVarInt(playerid, "RemoveAttachedObjectIndex", slot);
				format(aoe_str, sizeof(aoe_str), "* You've removed your attached object from slot/index number %i!", slot);
				SendClientMessage(playerid, COLOR_RED, aoe_str);
				format(aoe_str, sizeof(aoe_str), "~r~Removed your attached object~n~~w~index/number: %i", slot);
				GameTextForPlayer(playerid, aoe_str, 5000, 3);
			}
		    else SendClientMessage(playerid, COLOR_WHITE, "* You've canceled removing your attached object");
		}
	    case AOED_REMOVEALL:
	    {
	        if(response)
	        {
	            new slots = RemovePlayerAttachedObjectEx(playerid, 0, true);
       			format(aoe_str, sizeof(aoe_str), "* You've removed all of your %d attached object(s)!", slots);
				SendClientMessage(playerid, COLOR_RED, aoe_str);
				format(aoe_str, sizeof(aoe_str), "~r~Removed all your attached object(s)~n~~w~Total: %d", slots);
				GameTextForPlayer(playerid, aoe_str, 5000, 3);
			}
	        else SendClientMessage(playerid, COLOR_WHITE, "* You've canceled removing all your attached object(s)");
	    }
	    case AOED_STATS_SLOT:
		{
		    if(response) {
				format(aoe_str, sizeof(aoe_str), "%i", listitem);
				dcmd_attachedobjectstats(playerid, aoe_str);
		    }
		}
	    case AOED_STATS:
	    {
	        if(response && IsPlayerAdmin(playerid))
			{
	            new slot = GetPVarInt(playerid, "AttachedObjectStatsIndex");
	            GetPlayerName(playerid, PlayerName, MAX_PLAYER_NAME);
	            printf("  >> %s (ID:%i) has requested to print their attached object stats", PlayerName, playerid);
	            printf("  Attached object slot/index number: %i\n  - Model ID/Number/Type: %d\n  - Bone: %s (ID:%d)\n  - Offsets:\n  -- X: %.2f ~ Y: %.2f ~ Z: %.2f\n  - Rotations:\n  -- RX: %.2f ~ RY: %.2f ~ RZ: %.2f\
	            \n  - Scales:\n  -- SX: %.2f ~ SY: %.2f ~ SZ: %.2f\n  - Materials:\n  -- Color 1: %i (0x%04x%04x) ~ Color 2: %i (0x%04x%04x)\n  Total of %s (ID:%i)'s attached object(s): %d", slot, pao[playerid][slot][aoModelID], GetAttachedObjectBoneName(pao[playerid][slot][aoBoneID]),
	            pao[playerid][slot][aoBoneID], pao[playerid][slot][aoX], pao[playerid][slot][aoY], pao[playerid][slot][aoZ], pao[playerid][slot][aoRX], pao[playerid][slot][aoRY], pao[playerid][slot][aoRZ], pao[playerid][slot][aoSX], pao[playerid][slot][aoSY], pao[playerid][slot][aoSZ],
				pao[playerid][slot][aoMC1], AOE_IntToHexFormat(pao[playerid][slot][aoMC1]), pao[playerid][slot][aoMC2], AOE_IntToHexFormat(pao[playerid][slot][aoMC2]), PlayerName, playerid, GetPlayerAttachedObjectsCount(playerid));
	            printf("  Skin: %i ~ Code usage (playerid = %i):\n  SetPlayerAttachedObject(playerid, %i, %d, %i, %.4f, %.4f, %.4f, %.4f, %.4f, %.4f, %.4f, %.4f, %.4f, %i, %i);", GetPlayerSkin(playerid), playerid, slot, pao[playerid][slot][aoModelID], pao[playerid][slot][aoBoneID],
				pao[playerid][slot][aoX], pao[playerid][slot][aoY], pao[playerid][slot][aoZ], pao[playerid][slot][aoRX], pao[playerid][slot][aoRY], pao[playerid][slot][aoRZ], pao[playerid][slot][aoSX], pao[playerid][slot][aoSY], pao[playerid][slot][aoSZ],
				pao[playerid][slot][aoMC1], pao[playerid][slot][aoMC2]);
	            SendClientMessage(playerid, COLOR_WHITE, "SERVER: Your attached object stats has been printed!");
	        }
	        else SendClientMessage(playerid, COLOR_WHITE, "* You've closed your attached object stats dialog");
	    }
	    case AOED_DUPLICATE_SLOT1:
	    {
	        if(response) {
				format(aoe_str, sizeof(aoe_str), "%i", listitem);
				dcmd_duplicateattachedobject(playerid, aoe_str);
	        }
	    }
	    case AOED_DUPLICATE_SLOT2:
	    {
	        if(response) {
	            format(aoe_str, sizeof(aoe_str), "%i %i", GetPVarInt(playerid, "DuplicateAttachedObjectIndex1"), listitem);
				dcmd_duplicateattachedobject(playerid, aoe_str);
	        }
	        else AOE_ShowPlayerDialog(playerid, 7, AOED_DUPLICATE_SLOT1, "Duplicate Attached Object Index (1)", "Select", "Cancel");
	    }
	    case AOED_DUPLICATE_REPLACE:
	    {
	        if(response)
	        {
	            new slot1 = GetPVarInt(playerid, "DuplicateAttachedObjectIndex1"), slot2 = GetPVarInt(playerid, "DuplicateAttachedObjectIndex2");
	            DuplicatePlayerAttachedObject(playerid, slot1, slot2);
             	format(aoe_str, sizeof(aoe_str), "* Duplicated your attached object from slot/index number %i to %i!", slot1, slot2);
                SendClientMessage(playerid, COLOR_GREEN, aoe_str);
			 	format(aoe_str, sizeof(aoe_str), "~g~Attached object duplicated~n~~w~index/number:~n~%i to %i", slot1, slot2);
             	GameTextForPlayer(playerid, aoe_str, 5000, 3);
            }
	        else AOE_ShowPlayerDialog(playerid, 6, AOED_DUPLICATE_SLOT2, "Duplicate Attached Object Index (2)", "Select", "Sel Idx1");
	    }
	    case AOED_SET_SLOT1:
	    {
	        if(response) {
	            format(aoe_str, sizeof(aoe_str), "%i", listitem);
				dcmd_setattachedobjectindex(playerid, aoe_str);
	        }
	    }
		case AOED_SET_SLOT2:
		{
	        if(response) {
	            format(aoe_str, sizeof(aoe_str), "%i %i", GetPVarInt(playerid, "SetAttachedObjectIndex1"), listitem);
				dcmd_setattachedobjectindex(playerid, aoe_str);
	        }
	        else AOE_ShowPlayerDialog(playerid, 7, AOED_SET_SLOT1, "Set Attached Object Index (1)", "Select", "Cancel");
		}
  		case AOED_SET_SLOT_REPLACE:
		{
		    if(response)
		    {
		        new slot = GetPVarInt(playerid, "SetAttachedObjectIndex1"), newslot = GetPVarInt(playerid, "SetAttachedObjectIndex2");
		        MovePlayerAttachedObjectIndex(playerid, slot, newslot);
				format(aoe_str, sizeof(aoe_str), "* Moved & replaced your attached object from slot/index number %i to %i!", slot, newslot);
                SendClientMessage(playerid, COLOR_GREEN, aoe_str);
				format(aoe_str, sizeof(aoe_str), "~g~Attached object moved~n~~w~index/number:~n~%i to %i", slot, newslot);
                GameTextForPlayer(playerid, aoe_str, 5000, 3);
            }
			else AOE_ShowPlayerDialog(playerid, 6, AOED_SET_SLOT2, "Set Attached Object Index (2)", "Select", "Sel Idx1");
		}
		case AOED_SET_MODEL_SLOT:
		{
		    if(response) {
                format(aoe_str, sizeof(aoe_str), "%i", listitem);
				dcmd_setattachedobjectmodel(playerid, aoe_str);
		    }
		}
		case AOED_SET_MODEL:
		{
		    if(response) {
                format(aoe_str, sizeof(aoe_str), "%i %d", GetPVarInt(playerid, "SetAttachedObjectModelIndex"), strval(inputtext));
    			dcmd_setattachedobjectmodel(playerid, aoe_str);
		    }
		    else AOE_ShowPlayerDialog(playerid, 7, AOED_SET_MODEL_SLOT, "Set Attached Object Model", "Select", "Cancel");
		}
		case AOED_SET_BONE_SLOT:
		{
		    if(response) {
      			format(aoe_str, sizeof(aoe_str), "%i", listitem);
				dcmd_setattachedobjectbone(playerid, aoe_str);
		    }
		}
		case AOED_SET_BONE:
		{
		    if(response) {
		        format(aoe_str, sizeof(aoe_str), "%i %i", GetPVarInt(playerid, "SetAttachedObjectBoneIndex"), listitem+1);
				dcmd_setattachedobjectbone(playerid, aoe_str);
		    }
		    else AOE_ShowPlayerDialog(playerid, 7, AOED_SET_BONE_SLOT, "Set Attached Object Bone", "Select", "Cancel");
		}
		case AOED_SAVE_SLOT:
		{
		    if(response) {
                format(aoe_str, sizeof(aoe_str), "%i", listitem);
				dcmd_saveattachedobject(playerid, aoe_str);
			}
		}
		case AOED_SAVE:
		{
		    if(response) {
		        format(aoe_str, sizeof(aoe_str), "%i %s", GetPVarInt(playerid, "SaveAttachedObjectIndex"), inputtext);
		        dcmd_saveattachedobject(playerid, aoe_str);
			}
   			else AOE_ShowPlayerDialog(playerid, 7, AOED_SAVE_SLOT, "Save Attached Object", "Select", "Cancel");
		}
		case AOED_SAVE_REPLACE:
		{
		    if(response) {
		        new slot = GetPVarInt(playerid, "SaveAttachedObjectIndex"), ao_file[32];
                if(IsValidPlayerAttachedObject(playerid, slot) != 1) {
                    SendClientMessage(playerid, COLOR_RED, "* Error: Invalid attached object data, save canceled");
					GameTextForPlayer(playerid, "~r~~h~Invalid attached object data!", 5000, 3);
				}
				else
                {
                    GetPVarString(playerid, "SaveAttachedObjectName", aoe_str, sizeof(aoe_str));
                    format(ao_file, sizeof(ao_file), AO_FILENAME, aoe_str);
                    SendClientMessage(playerid, COLOR_WHITE, "* Saving attached object file, please wait...");
					AOE_SavePlayerAttachedObject(playerid, slot, ao_file);
					format(aoe_str, sizeof(aoe_str), "** Your attached object from index %i has been saved as \"%s\" (Model: %d - Bone: %i)!", slot, aoe_str, pao[playerid][slot][aoModelID], pao[playerid][slot][aoBoneID]);
					SendClientMessage(playerid, COLOR_BLUE, aoe_str);
					SendClientMessage(playerid, COLOR_BLUE, "** The attached object data on file has been edited (Updated)");
				}
			}
		}
		case AOED_SAVE2: if(response) dcmd_saveattachedobjects(playerid, inputtext);
		case AOED_SAVE2_REPLACE:
		{
		    if(response) {
		        new ao_file[32], slots;
		        GetPVarString(playerid, "SaveAttachedObjectName", aoe_str, sizeof(aoe_str));
		        format(ao_file, sizeof(ao_file), AO_FILENAME, aoe_str);
		        SendClientMessage(playerid, COLOR_WHITE, "* Saving attached object(s) set file, please wait...");
				if(dini_Exists(ao_file)) dini_Remove(ao_file);
				for(new slot = 0; slot < MAX_PLAYER_ATTACHED_OBJECTS; slot++)
			    {
   					if(IsValidPlayerAttachedObject(playerid, slot) != 1) continue;
					else {
	                    slots += AOE_SavePlayerAttachedObject(playerid, slot, ao_file);
					}
	            }
				if(!slots && dini_Exists(ao_file)) {
					dini_Remove(ao_file);
					SendClientMessage(playerid, COLOR_RED, "** Error: file saving was canceled because there were no valid attached object!");
				}
				else {
				    format(aoe_str, sizeof(aoe_str), "** Your attached object set has been saved as \"%s\" (Total: %i)!", aoe_str, slots);
					SendClientMessage(playerid, COLOR_BLUE, aoe_str);
					SendClientMessage(playerid, COLOR_BLUE, "** The attached object(s) data on file has been overwritten (Re-Created)");
				}
			}
		}
		case AOED_LOAD: if(response) dcmd_loadattachedobject(playerid, inputtext);
		case AOED_LOAD_SLOT:
		{
		    if(response) {
		        GetPVarString(playerid, "LoadAttachedObjectName", aoe_str, sizeof(aoe_str));
		        format(aoe_str, sizeof(aoe_str), "%s %i", aoe_str, strval(inputtext));
		        dcmd_loadattachedobject(playerid, aoe_str);
			}
   			else AOE_ShowPlayerDialog(playerid, 16, AOED_LOAD, "Load Attached Object", "Enter", "Cancel");
		}
		case AOED_LOAD_REPLACE:
		{
		    if(response) {
		        SendClientMessage(playerid, COLOR_WHITE, "* Loading attached object file, please wait...");
		        new slot = GetPVarInt(playerid, "LoadAttachedObjectIndex"), ao_file[32];
		        GetPVarString(playerid, "LoadAttachedObjectName", aoe_str, sizeof(aoe_str));
		        format(ao_file, sizeof(ao_file), AO_FILENAME, aoe_str);
		        AOE_LoadPlayerAttachedObject(playerid, slot, ao_file);
	   			format(aoe_str, sizeof(aoe_str), "** You've loaded & replaced your attached object from file \"%s\" by %s from skin %i (Index: %i - Model: %d - Bone: %i)!", aoe_str,
			   	dini_Get(ao_file, "auth"), dini_Int(ao_file, "skin"), slot, pao[playerid][slot][aoModelID], pao[playerid][slot][aoBoneID]);
				SendClientMessage(playerid, COLOR_GREEN, aoe_str);
		    }
		}
		case AOED_LOAD2: if(response) dcmd_loadattachedobjects(playerid, inputtext);
		case AOED_CONVERT: if(response) dcmd_convertattachedobjectfile(playerid, inputtext);
	}
	return 0;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
    if(response == EDIT_RESPONSE_FINAL)
	{
	    if(IsPlayerAttachedObjectSlotUsed(playerid, index)) RemovePlayerAttachedObject(playerid, index);
		UpdatePlayerAttachedObjectEx(playerid, index, modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);
        SetPVarInt(playerid, "EditingAttachedObject", 0);
        format(aoe_str, sizeof(aoe_str), "* You've edited your attached object from slot/index number %i", index);
	 	SendClientMessage(playerid, COLOR_CYAN, aoe_str);
		format(aoe_str, sizeof(aoe_str), "~b~~h~Edited your attached object~n~~w~index/number: %i", index);
		GameTextForPlayer(playerid, aoe_str, 5000, 3);
	}
	if(response == EDIT_RESPONSE_CANCEL)
	{
	    if(IsPlayerAttachedObjectSlotUsed(playerid, index)) RemovePlayerAttachedObject(playerid, index);
		SetPlayerAttachedObject(playerid, index, pao[playerid][index][aoModelID], pao[playerid][index][aoBoneID], pao[playerid][index][aoX], pao[playerid][index][aoY], pao[playerid][index][aoZ],
	 	pao[playerid][index][aoRX], pao[playerid][index][aoRY], pao[playerid][index][aoRZ], pao[playerid][index][aoSX], pao[playerid][index][aoSY], pao[playerid][index][aoSZ], pao[playerid][index][aoMC1], pao[playerid][index][aoMC2]);
	 	pao[playerid][index][aoValid] = 1;
		SetPVarInt(playerid, "EditingAttachedObject", 0);
		format(aoe_str, sizeof(aoe_str), "* You've canceled editing your attached object from slot/index number %i", index);
	 	SendClientMessage(playerid, COLOR_YELLOW, aoe_str);
	 	format(aoe_str, sizeof(aoe_str), "~r~~h~Canceled editing your attached object~n~~w~index/number: %i", index);
		GameTextForPlayer(playerid, aoe_str, 5000, 3);
	}
	return 1;
}

// =============================================================================

AOE_UnsetValues(playerid, index)
{
	pao[playerid][index][aoValid] = 0;
	pao[playerid][index][aoModelID] = 0, pao[playerid][index][aoBoneID] = 0;
	pao[playerid][index][aoX] = 0.0, pao[playerid][index][aoY] = 0.0, pao[playerid][index][aoZ] = 0.0;
	pao[playerid][index][aoRX] = 0.0, pao[playerid][index][aoRY] = 0.0, pao[playerid][index][aoRZ] = 0.0;
	pao[playerid][index][aoSX] = 0.0, pao[playerid][index][aoSY] = 0.0, pao[playerid][index][aoSZ] = 0.0;
	pao[playerid][index][aoMC1] = 0, pao[playerid][index][aoMC2] = 0;
}

AOE_UnsetVars(playerid)
{
	if(GetPVarInt(playerid, "EditingAttachedObject") == 1) CancelEdit(playerid);
	DeletePVar(playerid, "CreateAttachedObjectModel");
	DeletePVar(playerid, "CreateAttachedObjectBone");
	DeletePVar(playerid, "CreateAttachedObjectIndex");
	DeletePVar(playerid, "EditAttachedObjectIndex");
	DeletePVar(playerid, "EditingAttachedObject");
	DeletePVar(playerid, "RemoveAttachedObjectIndex");
	DeletePVar(playerid, "AttachedObjectStatsIndex");
	DeletePVar(playerid, "DuplicateAttachedObjectIndex1");
	DeletePVar(playerid, "DuplicateAttachedObjectIndex2");
	DeletePVar(playerid, "SetAttachedObjectIndex1");
	DeletePVar(playerid, "SetAttachedObjectIndex2");
	DeletePVar(playerid, "SetAttachedObjectModelIndex");
	DeletePVar(playerid, "SetAttachedObjectModel");
	DeletePVar(playerid, "SetAttachedObjectBoneIndex");
	DeletePVar(playerid, "SetAttachedObjectBone");
	DeletePVar(playerid, "SaveAttachedObjectIndex");
	DeletePVar(playerid, "SaveAttachedObjectName");
	DeletePVar(playerid, "LoadAttachedObjectName");
	DeletePVar(playerid, "LoadAttachedObjectIndex");
	DeletePVar(playerid, "LastAttachedObjectRemoved");
}

AOE_ShowPlayerDialog(playerid, type, dialogid, caption[], button1[], button2[] = "")
{
    new aoe_str2[2048], slot, slot2;
	switch(type)
	{
	    case 0: // AOE menu
	    {
	        new slots = GetPlayerAttachedObjectsCount(playerid), aoe_str1[64];
	        slot = GetPVarInt(playerid, "LastAttachedObjectRemoved");
	        if(!GetPVarType(playerid, "LastAttachedObjectRemoved")) aoe_str1 = "{FF0000}Restore your last deleted attached object";
	        else if(IsPlayerAttachedObjectSlotUsed(playerid, slot)) format(aoe_str1, sizeof(aoe_str1), "{D1D1D1}Restore your last deleted attached object [Index:%i]", slot);
	        else format(aoe_str1, sizeof(aoe_str1), "Restore your last deleted attached object [Index:%i]", slot);
			if(!slots) {
				format(aoe_str2, sizeof(aoe_str2), "Create your attached object\n{FF0000}Duplicate your attached object\n{FF0000}Edit your attached object\n\
				{FF0000}Edit your attached object index\n{FF0000}Edit your attached object model\n{FF0000}Edit your attached object bone\n\
				{FF0000}Save your attached object\n{FF0000}Save all of your attached object(s) [Total:%i]\nLoad attached object file\nLoad attached object(s) set", slots);
				format(aoe_str2, sizeof(aoe_str2), "%s\n{FF0000}Remove your attached object\n{FF0000}Remove all of your attached object(s) [Total:%i]\n%s\n\
				{FFFFFF}Export/convert attached object(s) file\n{FF0000}View your attached object stats\n{FFFFFF}Total attached object(s) [%i]", aoe_str2, slots, aoe_str1, slots);
			}
			else if(slots == MAX_PLAYER_ATTACHED_OBJECTS) {
				format(aoe_str2, sizeof(aoe_str2), "{FF0000}Create your attached object\n{D1D1D1}Duplicate your attached object\nEdit your attached object\n\
				Edit your attached object index\nEdit your attached object model\nEdit your attached object bone\n\
				Save your attached object\nSave all of your attached object(s) [Total:%i]\n{FF0000}Load attached object file\n{FF0000}Load attached object(s) set", slots);
				format(aoe_str2, sizeof(aoe_str2), "%s\nRemove your attached object\nRemove all of your attached object(s) [Total:%i]\n%s\n\
				Export/convert attached object(s) file\nView your attached object stats\nTotal attached object(s) [%i]", aoe_str2, slots, aoe_str1, slots);
			}
			else {
				format(aoe_str2, sizeof(aoe_str2), "Create your attached object\nDuplicate your attached object\nEdit your attached object\n\
				Edit your attached object index\nEdit your attached object model\nEdit your attached object bone\n\
				Save your attached object\nSave all of your attached object(s) [Total:%i]\nLoad attached object file\nLoad attached object(s) set", slots);
				format(aoe_str2, sizeof(aoe_str2), "%s\nRemove your attached object\nRemove all of your attached object(s) [Total:%i]\n%s\n\
				Export/convert attached object(s) file\nView your attached object stats\nTotal attached object(s) [%i]", aoe_str2, slots, aoe_str1, slots);
			}
			strcat(aoe_str2, "\nHelp/commands\nAbout this editor");
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, caption, aoe_str2, button1, button2);
	    }
	    case 1: // AOE help
	    {
	       	strcat(aoe_str2, "Command list & usage\nGeneral:\n");
		 	strcat(aoe_str2, " /attachedobjecteditor (/aoe): Shows attached object menu dialog\n /createattachedobject (/cao): Create your attached object\n");
		  	strcat(aoe_str2, " /editattachedobject (/eao): Edit your attached object\n /duplicateattachedobject (/dao): Duplicate your attached object\n");
		  	strcat(aoe_str2, " /removeattachedobject (/rao): Remove your attached object\n /removeattachedobjects (/raos): Remove all of your attached object(s)\n");
		  	strcat(aoe_str2, " /undeleteattachedobject (/udao): Restore your last deleted attached object\n /saveattachedobject (/sao): Save your attached object to a file\n");
		 	strcat(aoe_str2, " /saveattachedobjects (/saos): Save all of your attached object(s) to a set file\n /loadattachedobject (/lao): Load existing attached object file\n");
			strcat(aoe_str2, " /loadattachedobjects (/laos): Load existing attached object(s) set file\n /convertattachedobject (/caof): Convert saved file to raw code/script\n");
			strcat(aoe_str2, " /attachedobjectstats (/aos): Shows your attached object stats\n /totalattachedobjects (/taos): Shows the number of attached object(s)\nChange/set value:\n");
		 	strcat(aoe_str2, " /setattachedobjectslot (/saoi): Set your attached object slot/index\n /setattachedobjectmodel (/saom): Set your attached object model\n");
		 	strcat(aoe_str2, " /setattachedobjectbone (/saob): Set your attached object bone\n /setattachedobjectoffsetx (/saoox): Set your attached object offset X\n");
		 	strcat(aoe_str2, " /setattachedobjectoffsety (/saooy): Set your attached object offset Y\n /setattachedobjectoffsetz (/saooz): Set your attached object offset Z\n");
		 	strcat(aoe_str2, " /setattachedobjectrotx (/saorx): Set your attached object rotation X\n /setattachedobjectrotx (/saory): Set your attached object rotation Y\n");
		 	strcat(aoe_str2, " /setattachedobjectrotx (/saorz): Set your attached object rotation Z\n /setattachedobjectscalex (/saosx): Set your attached object scale X\n");
		 	strcat(aoe_str2, " /setattachedobjectscalex (/saosy): Set your attached object scale Y\n /setattachedobjectscalex (/saosz): Set your attached object scale Z\n");
		 	strcat(aoe_str2, " /setattachedobjectmc1 (/saomc1): Set your attached object material color #1\n /setattachedobjectmc2 (/saomc2): Set your attached object material color #2\n");
	 	 	ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, caption, aoe_str2, button1, button2);
	    }
	    case 2: // AOE convert
	    {
			format(aoe_str, sizeof(aoe_str), "* %s: Please enter an attached object file name...", caption);
		 	ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, caption, "Please enter an existing (saved) & valid attached object file name below to convert,\n\nPlease note that valid characters are:\n\
			A to Z or a to z, 0 to 9 and @, $, (, ), [, ], _, =, .\nand the length must be 1-24 characters long", button1, button2);
		 	SendClientMessage(playerid, COLOR_WHITE, aoe_str);
	    }
	    case 3: // AOE about
	    {
	        GetPlayerName(playerid, PlayerName, MAX_PLAYER_NAME);
            format(aoe_str2, sizeof(aoe_str2), "[FilterScript] Attached Object Editor for SA:MP 0.3e and upper\nSimple editor/tool for attached object(s)\n\nVersion: %s\nCreated by: Robo_N1X\nhttp://forum.sa-mp.com/showthread.php?t=416138\n\
			\nCredits & Thanks to:\n> SA:MP Team (www.sa-mp.com)\n> h02 for the attachments editor idea\n> DracoBlue (DracoBlue.net)\n> SA:MP Wiki (wiki.sa-mp.com)\n> Whoever that made useful function for this script\nAnd you, %s (ID:%i) for using this filterscript!",
			AOE_VERSION, PlayerName, playerid);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, caption, aoe_str2, button1, button2);
	    }
	    case 4: // AOE object model input
		{
		    format(aoe_str, sizeof(aoe_str), "* %s: Please enter object model id/number...", caption);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, caption, "Please enter a valid GTA:SA/SA:MP object model id/number below:", button1, button2);
			SendClientMessage(playerid, COLOR_WHITE, aoe_str);
		}
		case 5: // AOE bone list
		{
			for(new i = MIN_ATTACHED_OBJECT_BONE; i <= MAX_ATTACHED_OBJECT_BONE; i++)
				format(aoe_str2, sizeof(aoe_str2), "%s%d. %s\n", aoe_str2, i, GetAttachedObjectBoneName(i));
			format(aoe_str, sizeof(aoe_str), "* %s: Please select attached object bone...", caption);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, caption, aoe_str2, button1, button2);
			SendClientMessage(playerid, COLOR_WHITE, aoe_str);
		}
		case 6: // AOE slot/index list (free slot)
		{
			for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
			{
			    if(IsValidPlayerAttachedObject(playerid, i) == -1) format(aoe_str2, sizeof(aoe_str2), "%s{FFFFFF}%d. None - (Not Used)\n", aoe_str2, i);
			    else if(!IsValidPlayerAttachedObject(playerid, i)) format(aoe_str2, sizeof(aoe_str2), "%s{D1D1D1}%d. Unknown - Invalid attached object info\n", aoe_str2, i);
			    else format(aoe_str2, sizeof(aoe_str2), "%s{FF0000}%d. %d - %s (BID:%i) - (Used)\n", aoe_str2, i, pao[playerid][i][aoModelID], GetAttachedObjectBoneName(pao[playerid][i][aoBoneID]), pao[playerid][i][aoBoneID]);
			}
			if(!strcmp(button1, "Select", true)) format(aoe_str, sizeof(aoe_str), "* %s: Please select attached object slot/index number...", caption);
			else format(aoe_str, sizeof(aoe_str), "* %s: Please select attached object slot/index number to %s...", caption, button1);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, caption, aoe_str2, button1, button2);
			SendClientMessage(playerid, COLOR_WHITE, aoe_str);
		}
		case 7: // AOE slot/index list (used slot)
		{
			for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
			{
			    if(IsValidPlayerAttachedObject(playerid, i) == -1) format(aoe_str2, sizeof(aoe_str2), "%s{FF0000}%d. None - (Not Used)\n", aoe_str2, i);
			    else if(!IsValidPlayerAttachedObject(playerid, i)) format(aoe_str2, sizeof(aoe_str2), "%s{D1D1D1}%d. Unknown - Invalid attached object info\n", aoe_str2, i);
			    else format(aoe_str2, sizeof(aoe_str2), "%s{FFFFFF}%d. %d - %s (BID:%i) - (Used)\n", aoe_str2, i, pao[playerid][i][aoModelID], GetAttachedObjectBoneName(pao[playerid][i][aoBoneID]), pao[playerid][i][aoBoneID]);
			}
			if(!strcmp(button1, "Select", true)) format(aoe_str, sizeof(aoe_str), "* %s: Please select attached object slot/index number...", caption);
			else format(aoe_str, sizeof(aoe_str), "* %s: Please select attached object slot/index number to %s...", caption, button1);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, caption, aoe_str2, button1, button2);
			SendClientMessage(playerid, COLOR_WHITE, aoe_str);
		}
		case 8: // AOE stats
		{
 			slot = GetPVarInt(playerid, "AttachedObjectStatsIndex");
	    	format(aoe_str2, sizeof(aoe_str2), "Attached object slot/index number %i stats...\n\nIs valid data? %s\nModel ID/Number/Type: %d\nBone: %s (%i)\n\nOffsets\nX Offset: %f\nY Offset: %f\nZ Offset: %f\n\nRotations\nX Rotation: %f\nY Rotation: %f\
			\nZ Rotation: %f\n\nScales\nX Scale: %f\nY Scale: %f\nZ Scale: %f\n\nMaterial\nColor 1: %i (0x%04x%04x)\nColor 2: %i (0x%04x%04x)\n\nYour skin: %i\nTotal of your attached object(s): %d", slot, ((pao[playerid][slot][aoValid] == 1) ? ("Yes") : ("No")),
			pao[playerid][slot][aoModelID], GetAttachedObjectBoneName(pao[playerid][slot][aoBoneID]), pao[playerid][slot][aoBoneID], pao[playerid][slot][aoX], pao[playerid][slot][aoY], pao[playerid][slot][aoZ],
			pao[playerid][slot][aoRX], pao[playerid][slot][aoRY], pao[playerid][slot][aoRZ], pao[playerid][slot][aoSX], pao[playerid][slot][aoSY], pao[playerid][slot][aoSZ],
			pao[playerid][slot][aoMC1], AOE_IntToHexFormat(pao[playerid][slot][aoMC1]), pao[playerid][slot][aoMC2], AOE_IntToHexFormat(pao[playerid][slot][aoMC2]), GetPlayerSkin(playerid), GetPlayerAttachedObjectsCount(playerid));
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, caption, aoe_str2, (IsPlayerAdmin(playerid) ? button1 : button2), (IsPlayerAdmin(playerid) ? button2 : "")); // Only shows "Close" button for non-admin
			format(aoe_str, sizeof(aoe_str), "* You're viewing your attached object stats from slot/index number %i", slot);
  			SendClientMessage(playerid, COLOR_CYAN, aoe_str);
		}
		case 9: // AOE create replace
		{
			format(aoe_str2, sizeof(aoe_str2), "Sorry, attached object slot/index number %i\nis already used, do you want to replace it?\n(This action can't be undone)", GetPVarInt(playerid, "CreateAttachedObjectIndex"));
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, caption, aoe_str2, button1, button2);
		}
		case 10: // AOE create final
		{
  			format(aoe_str2, sizeof(aoe_str2), "You've created your attached object\nat slot/index number: %i\nModel: %d\nBone: %s (BID:%i)\n\nDo you want to edit your attached object?", GetPVarInt(playerid, "CreateAttachedObjectIndex"),
  			GetPVarInt(playerid, "CreateAttachedObjectModel"), GetAttachedObjectBoneName(GetPVarInt(playerid, "CreateAttachedObjectBone")), GetPVarInt(playerid, "CreateAttachedObjectBone"));
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, caption, aoe_str2, button1, button2);
		}
		case 11: // AOE remove
		{
		    format(aoe_str2, sizeof(aoe_str2), "You're about to remove attached object from slot/index number %i\nAre you sure you want to remove it?\n", GetPVarInt(playerid, "RemoveAttachedObjectIndex"));
		    ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, caption, aoe_str2, button1, button2);
		}
		case 12: // AOE remove all
		{
		    format(aoe_str2, sizeof(aoe_str2), "You're about to remove all of your attached object(s)\nTotal: %d\nAre you sure you want to remove them?\n(This action can't be undone)", GetPlayerAttachedObjectsCount(playerid));
		    ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, caption, aoe_str2, button1, button2);
		}
		case 13: // AOE duplicate replace
		{
		    slot = GetPVarInt(playerid, "DuplicateAttachedObjectIndex1"), slot2 = GetPVarInt(playerid, "DuplicateAttachedObjectIndex2");
			format(aoe_str2, sizeof(aoe_str2), "You already have attached object at slot/index number %i!\nDo you want to replace it with attached object from slot %i?", slot, slot2);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, caption, aoe_str2, button1, button2);
		}
		case 14: // AOE set index replace
		{
		    slot = GetPVarInt(playerid, "SetAttachedObjectIndex1"), slot2 = GetPVarInt(playerid, "SetAttachedObjectIndex2");
			format(aoe_str2, sizeof(aoe_str2), "You already have attached object at slot/index number %i!\nDo you want to replace it with attached object from slot %i?", slot2, slot);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, caption, aoe_str2, button1, button2);
		}
		case 15: // AOE save
		{
		    format(aoe_str, sizeof(aoe_str), "* %s: Please enter attached object file name to save...", caption);
		    ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, caption, "Please enter a valid file name to save this attached object below,\n\nPlease note that valid characters are:\n\
			A to Z or a to z, 0 to 9 and @, $, (, ), [, ], _, =, .\nand the length must be 1-24 characters long", button1, button2);
		    SendClientMessage(playerid, COLOR_WHITE, aoe_str);
		}
		case 16: // AOE load
		{
		    format(aoe_str, sizeof(aoe_str), "* %s: Please enter attached object file name to load...", caption);
		    ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, caption, "Please enter an valid and existing attached object file name below,\n\nPlease note that valid characters are:\n\
			A to Z or a to z, 0 to 9 and @, $, (, ), [, ], _, =, .\nand the length must be 1-24 characters long", button1, button2);
		    SendClientMessage(playerid, COLOR_WHITE, aoe_str);
		}
		case 17: // AOE load replace
		{
		    format(aoe_str2, sizeof(aoe_str2), "You already have attached object at slot/index number %i!\nDo you want to continue loading and replace it?", GetPVarInt(playerid, "LoadAttachedObjectIndex"));
		    ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, caption, aoe_str2, button1, button2);
		}
		case 18: // AOE save replace
		{
		    new name[32];
		    GetPVarString(playerid, "SaveAttachedObjectName", name, sizeof(name));
		    format(aoe_str2, sizeof(aoe_str2), "The file \"%s\" is already exist!\nDo you want to replace and overwrite it?\n(This action can't be undone)", name);
		    ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, caption, aoe_str2, button1, button2);
		    SendClientMessage(playerid, COLOR_WHITE, "* As you're an admin, you can replace an existed attached object file");
		}
	}
	return dialogid;
}

AOE_SavePlayerAttachedObject(playerid, index, filename[])
{
	new aof_varname[32];
	if(!IsPlayerConnected(playerid)) return INVALID_PLAYER_ID;
	if(!IsValidAttachedObjectSlot(index) || !IsValidObjectModel(pao[playerid][index][aoModelID]) || !IsValidAttachedObjectBone(pao[playerid][index][aoBoneID])) return 0;
	if(!dini_Exists(filename)) dini_Create(filename);
 	GetPlayerName(playerid, PlayerName, MAX_PLAYER_NAME);
	dini_Set(filename, "auth", PlayerName);
 	dini_IntSet(filename, "skin", GetPlayerSkin(playerid));
 	format(aof_varname, sizeof(aof_varname), "[%i]model", index), dini_IntSet(filename, aof_varname, pao[playerid][index][aoModelID]);
   	format(aof_varname, sizeof(aof_varname), "[%i]bone", index), dini_IntSet(filename, aof_varname, pao[playerid][index][aoBoneID]);
    format(aof_varname, sizeof(aof_varname), "[%i]x", index), dini_FloatSet(filename, aof_varname, pao[playerid][index][aoX]);
    format(aof_varname, sizeof(aof_varname), "[%i]y", index), dini_FloatSet(filename, aof_varname, pao[playerid][index][aoY]);
    format(aof_varname, sizeof(aof_varname), "[%i]z", index), dini_FloatSet(filename, aof_varname, pao[playerid][index][aoZ]);
    format(aof_varname, sizeof(aof_varname), "[%i]rx", index), dini_FloatSet(filename, aof_varname, pao[playerid][index][aoRX]);
    format(aof_varname, sizeof(aof_varname), "[%i]ry", index), dini_FloatSet(filename, aof_varname, pao[playerid][index][aoRY]);
    format(aof_varname, sizeof(aof_varname), "[%i]rz", index), dini_FloatSet(filename, aof_varname, pao[playerid][index][aoRZ]);
    format(aof_varname, sizeof(aof_varname), "[%i]sx", index), dini_FloatSet(filename, aof_varname, pao[playerid][index][aoSX]);
    format(aof_varname, sizeof(aof_varname), "[%i]sy", index), dini_FloatSet(filename, aof_varname, pao[playerid][index][aoSY]);
    format(aof_varname, sizeof(aof_varname), "[%i]sz", index), dini_FloatSet(filename, aof_varname, pao[playerid][index][aoSZ]);
    format(aof_varname, sizeof(aof_varname), "[%i]mc1", index), dini_IntSet(filename, aof_varname, pao[playerid][index][aoMC1]);
    format(aof_varname, sizeof(aof_varname), "[%i]mc2", index), dini_IntSet(filename, aof_varname, pao[playerid][index][aoMC2]);
	return 1;
}

AOE_LoadPlayerAttachedObject(playerid, index, filename[])
{
    new aof_varname[32];
    if(!IsPlayerConnected(playerid)) return INVALID_PLAYER_ID;
    if(!AOE_IsValidAttachedObjectInFile(index, filename)) return 0;
	GetPlayerName(playerid, PlayerName, MAX_PLAYER_NAME);
	format(aof_varname, sizeof(aof_varname), "[%i]model", index), pao[playerid][index][aoModelID] = dini_Int(filename, aof_varname);
	format(aof_varname, sizeof(aof_varname), "[%i]bone", index), pao[playerid][index][aoBoneID] = dini_Int(filename, aof_varname);
	format(aof_varname, sizeof(aof_varname), "[%i]x", index), pao[playerid][index][aoX] = dini_Float(filename, aof_varname);
	format(aof_varname, sizeof(aof_varname), "[%i]y", index), pao[playerid][index][aoY] = dini_Float(filename, aof_varname);
	format(aof_varname, sizeof(aof_varname), "[%i]z", index), pao[playerid][index][aoZ] = dini_Float(filename, aof_varname);
	format(aof_varname, sizeof(aof_varname), "[%i]rx", index), pao[playerid][index][aoRX] = dini_Float(filename, aof_varname);
	format(aof_varname, sizeof(aof_varname), "[%i]ry", index), pao[playerid][index][aoRY] = dini_Float(filename, aof_varname);
	format(aof_varname, sizeof(aof_varname), "[%i]rz", index), pao[playerid][index][aoRZ] = dini_Float(filename, aof_varname);
	format(aof_varname, sizeof(aof_varname), "[%i]sx", index), pao[playerid][index][aoSX] = dini_Float(filename, aof_varname);
	format(aof_varname, sizeof(aof_varname), "[%i]sy", index), pao[playerid][index][aoSY] = dini_Float(filename, aof_varname);
	format(aof_varname, sizeof(aof_varname), "[%i]sz", index), pao[playerid][index][aoSZ] = dini_Float(filename, aof_varname);
	format(aof_varname, sizeof(aof_varname), "[%i]mc1", index), pao[playerid][index][aoMC1] = dini_Int(filename, aof_varname);
	format(aof_varname, sizeof(aof_varname), "[%i]mc2", index), pao[playerid][index][aoMC2] = dini_Int(filename, aof_varname);
	if(IsValidAttachedObjectSlot(index) && IsValidObjectModel(pao[playerid][index][aoModelID]) && IsValidAttachedObjectBone(pao[playerid][index][aoBoneID]))
 		UpdatePlayerAttachedObjectEx(playerid, index, pao[playerid][index][aoModelID], pao[playerid][index][aoBoneID], pao[playerid][index][aoX], pao[playerid][index][aoY], pao[playerid][index][aoZ],
		pao[playerid][index][aoRX], pao[playerid][index][aoRY], pao[playerid][index][aoRZ], pao[playerid][index][aoSX], pao[playerid][index][aoSY], pao[playerid][index][aoSZ],
		pao[playerid][index][aoMC1], pao[playerid][index][aoMC2]);
	else {
		AOE_UnsetValues(playerid, index);
		return 0;
	}
	return 1;
}

AOE_ConvertAttachedObjectFile(playerid, filename[], filename2[], &filelen = 0)
{
    new aoe_str2[256], aof_varname[32], pao_name[32], ao_tmp[AttachedObjectOptions], slots,
		Hour, Minute, Second, Year, Month, Day;
    if(!IsPlayerConnected(playerid)) return INVALID_PLAYER_ID;
	GetPlayerName(playerid, PlayerName, MAX_PLAYER_NAME);
	gettime(Hour, Minute, Second), getdate(Year, Month, Day);
	strmid(pao_name, filename, 0, strlen(filename)-(strlen(AO_FILENAME)-2));
	format(aoe_str, sizeof(aoe_str), "\r\n/* \"%s\" converted by %s on %02d/%02d/%d - %02d:%02d:%02d */\r\n", filename, PlayerName, Day, Month, Year, Hour, Minute, Second);
	for(new slot = 0; slot < MAX_PLAYER_ATTACHED_OBJECTS; slot++)
	{
 		format(aof_varname, sizeof(aof_varname), "[%i]model", slot), ao_tmp[aoModelID] = dini_Int(filename, aof_varname);
   		format(aof_varname, sizeof(aof_varname), "[%i]bone", slot), ao_tmp[aoBoneID] = dini_Int(filename, aof_varname);
	    format(aof_varname, sizeof(aof_varname), "[%i]x", slot), ao_tmp[aoX] = dini_Float(filename, aof_varname);
	    format(aof_varname, sizeof(aof_varname), "[%i]y", slot), ao_tmp[aoY] = dini_Float(filename, aof_varname);
	    format(aof_varname, sizeof(aof_varname), "[%i]z", slot), ao_tmp[aoZ] = dini_Float(filename, aof_varname);
	    format(aof_varname, sizeof(aof_varname), "[%i]rx", slot), ao_tmp[aoRX] = dini_Float(filename, aof_varname);
	    format(aof_varname, sizeof(aof_varname), "[%i]ry", slot), ao_tmp[aoRY] = dini_Float(filename, aof_varname);
	    format(aof_varname, sizeof(aof_varname), "[%i]rz", slot), ao_tmp[aoRZ] = dini_Float(filename, aof_varname);
	    format(aof_varname, sizeof(aof_varname), "[%i]sx", slot), ao_tmp[aoSX] = dini_Float(filename, aof_varname);
	    format(aof_varname, sizeof(aof_varname), "[%i]sy", slot), ao_tmp[aoSY] = dini_Float(filename, aof_varname);
	    format(aof_varname, sizeof(aof_varname), "[%i]sz", slot), ao_tmp[aoSZ] = dini_Float(filename, aof_varname);
	    format(aof_varname, sizeof(aof_varname), "[%i]mc1", slot), ao_tmp[aoMC1] = dini_Int(filename, aof_varname);
	    format(aof_varname, sizeof(aof_varname), "[%i]mc2", slot), ao_tmp[aoMC2] = dini_Int(filename, aof_varname);
		if(!IsValidAttachedObjectSlot(slot) || !IsValidObjectModel(ao_tmp[aoModelID]) || !IsValidAttachedObjectBone(ao_tmp[aoBoneID])) continue;
		else {
			format(aoe_str2, sizeof(aoe_str2), "SetPlayerAttachedObject(playerid, %i, %d, %i, %.4f, %.4f, %.4f, %.4f, %.4f, %.4f, %.4f, %.4f, %.4f, %i, %i); // \"%s\" by %s (Skin:%i)\r\n",
			slot, ao_tmp[aoModelID], ao_tmp[aoBoneID], ao_tmp[aoX], ao_tmp[aoY], ao_tmp[aoZ], ao_tmp[aoRX], ao_tmp[aoRY], ao_tmp[aoRZ], ao_tmp[aoSX], ao_tmp[aoSY], ao_tmp[aoSZ],
			ao_tmp[aoMC1], ao_tmp[aoMC2], pao_name, dini_Get(filename, "auth"), dini_Int(filename, "skin"));
			if(!fexist(filename2))
			{
				new File:ao_file = fopen(filename2, io_write);
				fwrite(ao_file, "// Attached object raw code/exported file converted with [FS]Attached Object Editor (Version:"#AOE_VERSION") for SA:MP 0.3e and upper\r\n");
				fwrite(ao_file, "// Each attached object(s)/set file has the creation and information log above the code\r\n");
				fwrite(ao_file, "// By default, the log shows the name of player who converted the file and time with format DD/MM/YYYY - HH:MM:SS\r\n");
				fwrite(ao_file, "// Copy and paste the raw code(s) below, you can change the index parameter with valid slot number (0-9)!\r\n");
				fwrite(ao_file, aoe_str);
				fwrite(ao_file, aoe_str2);
				filelen = flength(ao_file);
				fclose(ao_file);
			}
			else
			{
				new File:ao_file = fopen(filename2, io_append);
				if(slots == 0) fwrite(ao_file, aoe_str);
				fwrite(ao_file, aoe_str2);
				filelen = flength(ao_file);
				fclose(ao_file);
			}
			slots++;
		}
	}
	return slots;
}

AOE_IsValidAttachedObjectInFile(index, filename[])
{
	new aof_varname[32], ao_tmp[AttachedObjectOptions];
	if(!fexist(filename)) return false;
	if(IsValidAttachedObjectSlot(index))
	{
		format(aof_varname, sizeof(aof_varname), "[%i]model", index), ao_tmp[aoModelID] = dini_Int(filename, aof_varname);
		format(aof_varname, sizeof(aof_varname), "[%i]bone", index), ao_tmp[aoBoneID] = dini_Int(filename, aof_varname);
		if(IsValidObjectModel(ao_tmp[aoModelID]) && IsValidAttachedObjectBone(ao_tmp[aoBoneID])) return true;
	}
	return false;
}

//------------------------------------------------------------------------------

stock CreatePlayerAttachedObject(playerid, index, modelid, bone)
{
    if(!IsPlayerConnected(playerid)) return INVALID_PLAYER_ID;
	if(!IsValidAttachedObjectSlot(index) || !IsValidObjectModel(modelid) || !IsValidAttachedObjectBone(bone)) return 0;
	if(IsPlayerAttachedObjectSlotUsed(playerid, index)) RemovePlayerAttachedObject(playerid, index);
	SetPlayerAttachedObject(playerid, index, modelid, bone);
	SetPVarInt(playerid, "CreateAttachedObjectIndex", index);
	SetPVarInt(playerid, "CreateAttachedObjectModel", modelid);
	SetPVarInt(playerid, "CreateAttachedObjectBone", bone);
 	pao[playerid][index][aoValid] = 1;
	pao[playerid][index][aoModelID] = modelid;
	pao[playerid][index][aoBoneID] = bone;
	pao[playerid][index][aoX] = 0.0, pao[playerid][index][aoY] = 0.0, pao[playerid][index][aoZ] = 0.0;
	pao[playerid][index][aoRX] = 0.0, pao[playerid][index][aoRY] = 0.0, pao[playerid][index][aoRZ] = 0.0;
	pao[playerid][index][aoSX] = 1.0, pao[playerid][index][aoSY] = 1.0, pao[playerid][index][aoSZ] = 1.0;
	pao[playerid][index][aoMC1] = 0, pao[playerid][index][aoMC2] = 0;
	return 1;
}

stock UpdatePlayerAttachedObject(playerid, index, modelid, bone)
	return UpdatePlayerAttachedObjectEx(playerid, index, modelid, bone, pao[playerid][index][aoX], pao[playerid][index][aoY], pao[playerid][index][aoZ], pao[playerid][index][aoRX], pao[playerid][index][aoRY], pao[playerid][index][aoRZ],
 	pao[playerid][index][aoSX], pao[playerid][index][aoSY], pao[playerid][index][aoSZ], pao[playerid][index][aoMC1], pao[playerid][index][aoMC2]);

stock UpdatePlayerAttachedObjectEx(playerid, index, modelid, bone, Float:fOffsetX = 0.0, Float:fOffsetY = 0.0, Float:fOffsetZ = 0.0, Float:fRotX = 0.0, Float:fRotY = 0.0, Float:fRotZ = 0.0, Float:fScaleX = 1.0, Float:fScaleY = 1.0, Float:fScaleZ = 1.0, materialcolor1 = 0, materialcolor2 = 0)
{
    if(!IsPlayerConnected(playerid)) return INVALID_PLAYER_ID;
    if(!IsValidAttachedObjectSlot(index) || !IsValidObjectModel(modelid) || !IsValidAttachedObjectBone(bone)) return 0;
	SetPlayerAttachedObject(playerid, index, modelid, bone, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ, materialcolor1, materialcolor2);
    pao[playerid][index][aoValid] = 1;
	pao[playerid][index][aoModelID] = modelid;
	pao[playerid][index][aoBoneID] = bone;
	pao[playerid][index][aoX] = fOffsetX, pao[playerid][index][aoY] = fOffsetY, pao[playerid][index][aoZ] = fOffsetZ;
	pao[playerid][index][aoRX] = fRotX, pao[playerid][index][aoRY] = fRotY, pao[playerid][index][aoRZ] = fRotZ;
	pao[playerid][index][aoSX] = fScaleX, pao[playerid][index][aoSY] = fScaleY, pao[playerid][index][aoSZ] = fScaleZ;
    pao[playerid][index][aoMC1] = materialcolor1, pao[playerid][index][aoMC2] = materialcolor2;
    return index;
}

stock DuplicatePlayerAttachedObject(playerid, index1, index2)
{
	if(IsValidPlayerAttachedObject(playerid, index1) && IsValidAttachedObjectSlot(index1) && IsValidAttachedObjectSlot(index2)) {
		if(IsPlayerAttachedObjectSlotUsed(playerid, index2)) RemovePlayerAttachedObject(playerid, index2);
		return UpdatePlayerAttachedObjectEx(playerid, index2, pao[playerid][index1][aoModelID], pao[playerid][index1][aoBoneID], pao[playerid][index1][aoX], pao[playerid][index1][aoY], pao[playerid][index1][aoZ],
		pao[playerid][index1][aoRX], pao[playerid][index1][aoRY], pao[playerid][index1][aoRZ], pao[playerid][index1][aoSX], pao[playerid][index1][aoSY], pao[playerid][index1][aoSZ], pao[playerid][index1][aoMC1], pao[playerid][index1][aoMC2]);
	}
	return 0;
}

stock MovePlayerAttachedObjectIndex(playerid, index1, index2)
{
    if(IsValidPlayerAttachedObject(playerid, index1) && IsValidAttachedObjectSlot(index1) && IsValidAttachedObjectSlot(index2)) {
		if(IsPlayerAttachedObjectSlotUsed(playerid, index1)) RemovePlayerAttachedObject(playerid, index1), pao[playerid][index1][aoValid] = 0;
		if(IsPlayerAttachedObjectSlotUsed(playerid, index2)) RemovePlayerAttachedObject(playerid, index2), pao[playerid][index2][aoValid] = 0;
		return UpdatePlayerAttachedObjectEx(playerid, index2, pao[playerid][index1][aoModelID], pao[playerid][index1][aoBoneID], pao[playerid][index1][aoX], pao[playerid][index1][aoY], pao[playerid][index1][aoZ],
		pao[playerid][index1][aoRX], pao[playerid][index1][aoRY], pao[playerid][index1][aoRZ], pao[playerid][index1][aoSX], pao[playerid][index1][aoSY], pao[playerid][index1][aoSZ]);
	}
	return 0;
}

stock RefreshPlayerAttachedObjects(playerid, forplayerid)
{
	new slots = 0;
	if(!IsPlayerConnected(playerid) || !IsPlayerConnected(forplayerid)) return INVALID_PLAYER_ID;
	for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
	{
	    if(IsPlayerAttachedObjectSlotUsed(playerid, i) || IsValidPlayerAttachedObject(playerid, i))
	    {
	    	if(IsPlayerAttachedObjectSlotUsed(forplayerid, i)) RemovePlayerAttachedObject(forplayerid, i);
			SetPlayerAttachedObject(forplayerid, i, pao[playerid][i][aoModelID], pao[playerid][i][aoBoneID], pao[playerid][i][aoX], pao[playerid][i][aoY], pao[playerid][i][aoZ],
			pao[playerid][i][aoRX], pao[playerid][i][aoRY], pao[playerid][i][aoRZ], pao[playerid][i][aoSX], pao[playerid][i][aoSY], pao[playerid][i][aoSZ], pao[playerid][index][aoMC1], pao[playerid][index][aoMC2]);
			pao[forplayerid][i][aoValid] = 1;
			pao[forplayerid][i][aoModelID] = pao[playerid][i][aoModelID];
	    	pao[forplayerid][i][aoBoneID] = pao[playerid][i][aoBoneID];
        	pao[forplayerid][i][aoX] = pao[playerid][i][aoX], pao[forplayerid][i][aoY] = pao[playerid][i][aoY], pao[forplayerid][i][aoZ] = pao[playerid][i][aoZ];
        	pao[forplayerid][i][aoRX] = pao[playerid][i][aoRX], pao[forplayerid][i][aoRY] = pao[playerid][i][aoRY], pao[forplayerid][i][aoRZ] = pao[playerid][i][aoRZ];
 	 		pao[forplayerid][i][aoSX] = pao[playerid][i][aoSX], pao[forplayerid][i][aoSY] = pao[playerid][i][aoSY], pao[forplayerid][i][aoSZ] = pao[playerid][i][aoSZ];
			pao[forplayerid][i][aoMC1] = pao[playerid][i][aoMC1], pao[forplayerid][i][aoMC2] = pao[playerid][i][aoMC2];
        	slots++;
		}
	}
	return slots;
}

stock RestorePlayerAttachedObject(playerid, index)
{
	if(!IsPlayerConnected(playerid)) return INVALID_PLAYER_ID;
	if(IsValidPlayerAttachedObject(playerid, index))
	{
	    SetPlayerAttachedObject(playerid, index, pao[playerid][index][aoModelID], pao[playerid][index][aoBoneID], pao[playerid][index][aoX], pao[playerid][index][aoY], pao[playerid][index][aoZ],
		pao[playerid][index][aoRX], pao[playerid][index][aoRY], pao[playerid][index][aoRZ], pao[playerid][index][aoSX], pao[playerid][index][aoSY], pao[playerid][index][aoSZ], pao[playerid][index][aoMC1], pao[playerid][index][aoMC2]);
		pao[playerid][index][aoValid] = 1;
		return 1;
	}
	return 0;
}

stock RemovePlayerAttachedObjectEx(playerid, index = 0, bool:RemoveAll = false)
{
    if(!IsPlayerConnected(playerid)) return INVALID_PLAYER_ID;
    if(!GetPlayerAttachedObjectsCount(playerid) || !IsValidAttachedObjectSlot(index)) return 0;
	new _TOTAL_ATTACHED_OBJECT_REMOVED_;
	if(RemoveAll == true)
	{
	    _TOTAL_ATTACHED_OBJECT_REMOVED_ = 0;
		for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
		{
		    if(IsPlayerAttachedObjectSlotUsed(playerid, i)) {
		        RemovePlayerAttachedObject(playerid, i);
		        pao[playerid][i][aoValid] = 0;
		        SetPVarInt(playerid, "LastAttachedObjectRemoved", i);
		        _TOTAL_ATTACHED_OBJECT_REMOVED_++;
			}
		}
	}
	else
	{
	    _TOTAL_ATTACHED_OBJECT_REMOVED_ = 0;
	    if(IsPlayerAttachedObjectSlotUsed(playerid, index)) {
	        RemovePlayerAttachedObject(playerid, index);
	        pao[playerid][index][aoValid] = 0;
	        SetPVarInt(playerid, "LastAttachedObjectRemoved", index);
	        _TOTAL_ATTACHED_OBJECT_REMOVED_++;
		}
	}
	return _TOTAL_ATTACHED_OBJECT_REMOVED_;
}

stock GetAttachedObjectBoneName(BoneID)
{
	new GET_AO_BONE_NAME[24];
	if(!IsValidAttachedObjectBone(BoneID)) valstr(GET_AO_BONE_NAME, 0);
	else strins(GET_AO_BONE_NAME, AttachedObjectBones[BoneID - MIN_ATTACHED_OBJECT_BONE], 0);
	return GET_AO_BONE_NAME;
}

stock GetAttachedObjectBoneID(const BoneName[])
{
	if(!IsValidAttachedObjectBoneName(BoneName)) return 0;
	if(IsNumeric(BoneName) && IsValidAttachedObjectBoneName(BoneName)) return strval(BoneName);
	for(new i = 0; i < sizeof(AttachedObjectBones); i++)
		if(strfind(AttachedObjectBones[i], BoneName, true) != -1) return i + MIN_ATTACHED_OBJECT_BONE;
	return 0;
}

stock GetAttachedObjectsCount()
{
	new _AttachedObjectsCount;
 	for(new x = 0; x < GetMaxPlayers(); x++)
	 	if(IsPlayerConnected(x))
		 	for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
		 		if(IsPlayerAttachedObjectSlotUsed(x, i)) _AttachedObjectsCount++;
	return _AttachedObjectsCount;
}

stock GetPlayerAttachedObjectsCount(playerid)
{
	if(!IsPlayerConnected(playerid)) return INVALID_PLAYER_ID;
	new _PlayerAttachedObjectsCount;
	for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
	    if(IsPlayerAttachedObjectSlotUsed(playerid, i)) _PlayerAttachedObjectsCount++;
	return _PlayerAttachedObjectsCount;
}

stock IsValidPlayerAttachedObject(playerid, index)
{
	if(!IsPlayerConnected(playerid)) return INVALID_PLAYER_ID; // Player is offline
	if(!GetPlayerAttachedObjectsCount(playerid) || !IsPlayerAttachedObjectSlotUsed(playerid, index)) return -1; // Not used
	if(!IsValidAttachedObjectSlot(index) || !IsValidObjectModel(pao[playerid][index][aoModelID]) || !IsValidAttachedObjectBone(pao[playerid][index][aoBoneID]) || !pao[playerid][index][aoValid]) return 0; // Invalid data
	return 1;
}

stock IsValidAttachedObjectSlot(SlotID) {
	if(0 <= SlotID < MAX_PLAYER_ATTACHED_OBJECTS) return true;
	return false;
}

stock IsValidAttachedObjectBone(BoneID) {
	if(MIN_ATTACHED_OBJECT_BONE <= BoneID <= MAX_ATTACHED_OBJECT_BONE) return true;
	return false;
}

stock IsValidAttachedObjectBoneName(const BoneName[])
{
	new length = strlen(BoneName);
	if(!length || length > 24) return false;
	for(new b = 0; b < sizeof(AttachedObjectBones); b++)
		if(!strcmp(BoneName, AttachedObjectBones[b], true)) return true;
	if(IsNumeric(BoneName) && IsValidAttachedObjectBone(strval(BoneName))) return true;
	return false;
}

stock IsValidFileName(const filename[])
{
	new length = strlen(filename);
	if(length < 1 || length > 24) return false;
	for(new j = 0; j < length; j++) {
		if((filename[j] < 'A' || filename[j] > 'Z') && (filename[j] < 'a' || filename[j] > 'z') && (filename[j] < '0' || filename[j] > '9')
			&& !(filename[j] == '@' || filename[j] == '$' || filename[j] == '(' || filename[j] == ')'
			|| filename[j] == '[' || filename[j] == ']' || filename[j] == '_' || filename[j] == '=' || filename[j] == '.')) return false;
	}
	return true;
}

//------------------------------------------------------------------------------

stock IsValidObjectModel(ModelID)
{
    if(
    // Weapons Objects
    (ModelID >= 321 && ModelID <= 326)
    || (ModelID >= 330 && ModelID <= 331)
    || (ModelID >= 333 && ModelID <= 339)
    || (ModelID >= 341 && ModelID <= 344)
    || (ModelID >= 346 && ModelID <= 363)
    || (ModelID >= 365 && ModelID <= 372)
    // Fun Objects
    || (ModelID >= 1433 && ModelID <= 13594)
    // Roads Objects
    || (ModelID >= 5482 && ModelID <= 5512)
    // Barriers Objects
    || (ModelID >= 966 && ModelID <= 998)
    // Misc Objects 1210-1325
    || (ModelID >= 1210 && ModelID <= 1325)
    // Misc Objects 1420-1620
    || (ModelID >= 1420 && ModelID <= 1620)
    // Misc Objects 1971-4522
    || (ModelID >= 1971 && ModelID <= 4522)
	// SA:MP Object 18632-19515 (0.3e)
	|| (ModelID >= 18632 && ModelID <= 19515)
	// Custom Object 19516-19999 (Including SA:MP 0.3x objects, can be changed)
	|| (ModelID >= 19516 && ModelID <= 19999))
		return true;
    return false;
}

stock strtok(const string[], &index)
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

stock strrest(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}
	new offset = index;
	new result[128];
	while ((index < length) && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

stock IsNumeric(const string[])
{
    new length=strlen(string);
    if(length==0) return false;
    for(new i = 0; i < length; i++) {
        if(string[i] > '9' || string[i] <'0') return false;
    }
    return true;
}

stock IsNumeric2(const string[])
{
	// Is Numeric Check 2
	// ------------------
	// By DracoBlue... handles negative numbers
	new length=strlen(string);
	if (length==0) return false;
	for (new i = 0; i < length; i++)
	{
    	if((string[i] > '9' || string[i] < '0' && string[i]!='-' && string[i]!='+' && string[i]!='.') // Not a number,'+' or '-' or '.'
    		|| (string[i]=='-' && i!=0)				// A '-' but not first char.
    		|| (string[i]=='+' && i!=0)				// A '+' but not first char.
		) return false;
	}
	if (length==1 && (string[0]=='-' || string[0]=='+' || string[0]=='.')) return false;
	return true;
}

stock IsValidHex(string[])
{
	new length = strlen(string);
	if(length < 6 || length > 8) return false;
	for(new i = 0; i < length; i++)
	    if((string[i] < 'A' || string[i] > 'F') && (string[i] < 'a' || string[i] > 'f') && (string[i] < '0' || string[i] > '9')) return false;
	return true;
}

stock RGB( red, green, blue, alpha )
{
	/* Combines a color and returns it, so it can be used in functions.
 	@red:           Amount of red color.
  	@green:         Amount of green color.
    @blue:          Amount of blue color.
	@alpha:         Amount of alpha transparency.

	-Returns:
 	An integer with the combined color.
  	*/
   	return (red * 16777216) + (green * 65536) + (blue * 256) + alpha;
}

stock RGBAtoARGB(color)
	return (color >>> 8)|(color << 24);

stock HexToInt(string[])
{
    if (string[0] == 0) return 0;
    new i;
    new cur = 1;
    new res = 0;
    for (i = strlen(string); i > 0; i--) {
        if (string[i-1] < 58) res = res + cur * (string[i-1] - 48);
        else {
            res = res + cur * (string[i-1] - 65 + 10);
            cur = cur * 16;
        }
    }
    return res;
}
