/*==============================================================================
 				SetPlayerAttachedObject script by Richie©
 		  		 Based on the Attachments script by h02
==============================================================================*/
#include <a_samp>
#include <zcmd>
#include <a_mysql>
//============================ Database info ===================================
#define SQL_HOST 				"127.0.0.1"
#define SQL_USER 				"root"
#define SQL_PASS 				""
#define SQL_DB 					"database"
//==============================================================================
#define DIALOG_ATTACH_INDEX             2200 // DialogID
#define DIALOG_ATTACH_INDEX_SELECTION   DIALOG_ATTACH_INDEX+1
#define DIALOG_ATTACH_EDITREPLACE       DIALOG_ATTACH_INDEX+2
#define DIALOG_ATTACH_MODEL_SELECTION   DIALOG_ATTACH_INDEX+3
#define DIALOG_ATTACH_BONE_SELECTION    DIALOG_ATTACH_INDEX+4
#define SETHOLDDIALOG 					DIALOG_ATTACH_INDEX+5
#define HOLDMENU3E                      DIALOG_ATTACH_INDEX+6
#define HOLDADDDIALOG                   DIALOG_ATTACH_INDEX+7


enum _spao
{
	pUserName[24],
	pmodel[10],
	pbone[10],
	Float:pfX[10],
	Float:pfY[10],
	Float:pfZ[10],
	Float:prX[10],
	Float:prY[10],
	Float:prZ[10],
	Float:psX[10],
	Float:psY[10],
	Float:psZ[10],
	pUsingSlot[10]
}

new PlayerAttatchedObjects[MAX_PLAYERS][_spao];
new gConnectionhandle;

enum AttachmentEnum
{
    attachmodel,
    attachname[24]
}

new AttachmentObjects[][AttachmentEnum] = {
{18632, "FishingRod"},
{18633, "GTASAWrench1"},
{18634, "GTASACrowbar1"},
{18635, "GTASAHammer1"},
{18636, "PoliceCap1"},
{18637, "PoliceShield1"},
{18638, "HardHat1"},
{18639, "BlackHat1"},
{18640, "Hair1"},
{18975, "Hair2"},
{19136, "Hair4"},
{19274, "Hair5"},
{18641, "Flashlight1"},
{18642, "Taser1"},
{18643, "LaserPointer Red"},
{19080, "LaserPointer Blue"},
{19081, "LaserPointer Pink"},
{19082, "LaserPointer Orange"},
{19083, "LaserPointer Green"},
{19084, "LaserPointer Yellow"},
{18644, "Screwdriver1"},
{18645, "MotorcycleHelmet1"},
{18865, "MobilePhone1"},
{18866, "MobilePhone2"},
{18867, "MobilePhone3"},
{18868, "MobilePhone4"},
{18869, "MobilePhone5"},
{18870, "MobilePhone6"},
{18871, "MobilePhone7"},
{18872, "MobilePhone8"},
{18873, "MobilePhone9"},
{18874, "MobilePhone10"},
{18875, "Pager1"},
{18890, "Rake1"},
{18891, "Bandana1"},
{18892, "Bandana2"},
{18893, "Bandana3"},
{18894, "Bandana4"},
{18895, "Bandana5"},
{18896, "Bandana6"},
{18897, "Bandana7"},
{18898, "Bandana8"},
{18899, "Bandana9"},
{18900, "Bandana10"},
{18901, "Bandana11"},
{18902, "Bandana12"},
{18903, "Bandana13"},
{18904, "Bandana14"},
{18905, "Bandana15"},
{18906, "Bandana16"},
{18907, "Bandana17"},
{18908, "Bandana18"},
{18909, "Bandana19"},
{18910, "Bandana20"},
{18911, "Mask1"},
{18912, "Mask2"},
{18913, "Mask3"},
{18914, "Mask4"},
{18915, "Mask5"},
{18916, "Mask6"},
{18917, "Mask7"},
{18918, "Mask8"},
{18919, "Mask9"},
{18920, "Mask10"},
{18921, "Beret1"},
{18922, "Beret2"},
{18923, "Beret3"},
{18924, "Beret4"},
{18925, "Beret5"},
{18926, "Hat1"},
{18927, "Hat2"},
{18928, "Hat3"},
{18929, "Hat4"},
{18930, "Hat5"},
{18931, "Hat6"},
{18932, "Hat7"},
{18933, "Hat8"},
{18934, "Hat9"},
{18935, "Hat10"},
{18936, "Helmet1"},
{18937, "Helmet2"},
{18938, "Helmet3"},
{18939, "CapBack1"},
{18940, "CapBack2"},
{18941, "CapBack3"},
{18942, "CapBack4"},
{18943, "CapBack5"},
{18944, "HatBoater1"},
{18945, "HatBoater2"},
{18946, "HatBoater3"},
{18947, "HatBowler1"},
{18948, "HatBowler2"},
{18949, "HatBowler3"},
{18950, "HatBowler4"},
{18951, "HatBowler5"},
{18952, "BoxingHelmet1"},
{18953, "CapKnit1"},
{18954, "CapKnit2"},
{18955, "CapOverEye1"},
{18956, "CapOverEye2"},
{18957, "CapOverEye3"},
{18958, "CapOverEye4"},
{18959, "CapOverEye5"},
{18960, "CapRimUp1"},
{18961, "CapTrucker1"},
{18962, "CowboyHat2"},
{18963, "CJElvisHead"},
{18964, "SkullyCap1"},
{18965, "SkullyCap2"},
{18966, "SkullyCap3"},
{18967, "HatMan1"},
{18968, "HatMan2"},
{18969, "HatMan3"},
{18970, "HatTiger1"},
{18971, "HatCool1"},
{18972, "HatCool2"},
{18973, "HatCool3"},
{18974, "MaskZorro1"},
{18976, "MotorcycleHelmet2"},
{18977, "MotorcycleHelmet3"},
{18978, "MotorcycleHelmet4"},
{18979, "MotorcycleHelmet5"},
{19006, "GlassesType1"},
{19007, "GlassesType2"},
{19008, "GlassesType3"},
{19009, "GlassesType4"},
{19010, "GlassesType5"},
{19011, "GlassesType6"},
{19012, "GlassesType7"},
{19013, "GlassesType8"},
{19014, "GlassesType9"},
{19015, "GlassesType10"},
{19016, "GlassesType11"},
{19017, "GlassesType12"},
{19018, "GlassesType13"},
{19019, "GlassesType14"},
{19020, "GlassesType15"},
{19021, "GlassesType16"},
{19022, "GlassesType17"},
{19023, "GlassesType18"},
{19024, "GlassesType19"},
{19025, "GlassesType20"},
{19026, "GlassesType21"},
{19027, "GlassesType22"},
{19028, "GlassesType23"},
{19029, "GlassesType24"},
{19030, "GlassesType25"},
{19031, "GlassesType26"},
{19032, "GlassesType27"},
{19033, "GlassesType28"},
{19034, "GlassesType29"},
{19035, "GlassesType30"},
{19036, "HockeyMask1"},
{19037, "HockeyMask2"},
{19038, "HockeyMask3"},
{19039, "WatchType1"},
{19040, "WatchType2"},
{19041, "WatchType3"},
{19042, "WatchType4"},
{19043, "WatchType5"},
{19044, "WatchType6"},
{19045, "WatchType7"},
{19046, "WatchType8"},
{19047, "WatchType9"},
{19048, "WatchType10"},
{19049, "WatchType11"},
{19050, "WatchType12"},
{19051, "WatchType13"},
{19052, "WatchType14"},
{19053, "WatchType15"},
{19085, "EyePatch1"},
{19086, "ChainsawDildo1"},
{19090, "PomPomBlue"},
{19091, "PomPomRed"},
{19092, "PomPomGreen"},
{19093, "HardHat2"},
{19094, "BurgerShotHat1"},
{19095, "CowboyHat1"},
{19096, "CowboyHat3"},
{19097, "CowboyHat4"},
{19098, "CowboyHat5"},
{19099, "PoliceCap2"},
{19100, "PoliceCap3"},
{19101, "ArmyHelmet1"},
{19102, "ArmyHelmet2"},
{19103, "ArmyHelmet3"},
{19104, "ArmyHelmet4"},
{19105, "ArmyHelmet5"},
{19106, "ArmyHelmet6"},
{19107, "ArmyHelmet7"},
{19108, "ArmyHelmet8"},
{19109, "ArmyHelmet9"},
{19110, "ArmyHelmet10"},
{19111, "ArmyHelmet11"},
{19112, "ArmyHelmet12"},
{19113, "SillyHelmet1"},
{19114, "SillyHelmet2"},
{19115, "SillyHelmet3"},
{19116, "PlainHelmet1"},
{19117, "PlainHelmet2"},
{19118, "PlainHelmet3"},
{19119, "PlainHelmet4"},
{19120, "PlainHelmet5"},
{19137, "CluckinBellHat1"},
{19138, "PoliceGlasses1"},
{19139, "PoliceGlasses2"},
{19140, "PoliceGlasses3"},
{19141, "SWATHelmet1"},
{19142, "SWATArmour1"},
{19160, "HardHat3"},
{19161, "PoliceHat1"},
{19162, "PoliceHat2"},
{19163, "GimpMask1"},
{19317, "bassguitar01"},
{19318, "flyingv01"},
{19319, "warlock01"},
{19330, "fire_hat01"},
{19331, "fire_hat02"},
{19346, "hotdog01"},
{19347, "badge01"},
{19348, "cane01"},
{19349, "monocle01"},
{19350, "moustache01"},
{19351, "moustache02"},
{19352, "tophat01"},
{19487, "tophat02"},
{19472, "gasmask01"},
{19421, "headphones01"},
{19422, "headphones02"},
{19423, "headphones03"},
{19424, "headphones04"}
};

new AttachmentBones[][24] = {
{"Spine"},
{"Head"},
{"Left upper arm"},
{"Right upper arm"},
{"Left hand"},
{"Right hand"},
{"Left thigh"},
{"Right thigh"},
{"Left foot"},
{"Right foot"},
{"Right calf"},
{"Left calf"},
{"Left forearm"},
{"Right forearm"},
{"Left clavicle"},
{"Right clavicle"},
{"Neck"},
{"Jaw"}
};

public OnFilterScriptInit()
{
	mysql_debug(0);
	gConnectionhandle = mysql_connect(SQL_HOST, SQL_USER, SQL_DB, SQL_PASS);
	
	print("\n========================================");
	print("   Attached Objects Script by Richie©");
	print("========================================\n");
	
	new query[450];
	
    format(query, sizeof(query), "CREATE TABLE IF NOT EXISTS `PlayerObjects` (`Name` varchar(24) NOT NULL, `Slot` int(11) NOT NULL, `model` int(11) NOT NULL, \
  	`bone` int(11) NOT NULL, `fX` float NOT NULL, `fY` float NOT NULL, `fZ` float NOT NULL, `rX` float NOT NULL, `rY` float NOT NULL, `rZ` float NOT NULL, \
  	`sX` float NOT NULL, `sY` float NOT NULL, `sZ` float NOT NULL, `Enabled` int(11) NOT NULL) ENGINE=MyISAM DEFAULT CHARSET=latin1");
  	
	mysql_function_query(gConnectionhandle, query, false, "NoReturnThreads", "");
	return 1;
}

public OnPlayerConnect(playerid)
{
    ResetHoldObjects(playerid);
    SetTimerEx( "InitializePlayerObjects", 500, 0, "i", playerid );
	return 1;
}

public OnPlayerSpawn(playerid)
{
    SetPlayerObjects(playerid);
    return 1;
}

public OnPlayerEditAttachedObject( playerid, response, index, modelid, boneid,
                                   Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ,
                                   Float:fRotX, Float:fRotY, Float:fRotZ,
                                   Float:fScaleX, Float:fScaleY, Float:fScaleZ )
{
    SendClientMessage(playerid, -1, "{0BDDC4}[Hold Objects]{FFFFFF} Editing of object done.");
    SetPlayerAttachedObject(playerid,index,modelid,boneid,fOffsetX,fOffsetY,fOffsetZ,fRotX,fRotY,fRotZ,fScaleX,fScaleY,fScaleZ);

    PlayerAttatchedObjects[playerid][pmodel][index] = modelid;
    PlayerAttatchedObjects[playerid][pbone][index] = boneid;
    PlayerAttatchedObjects[playerid][pfX][index] = fOffsetX;
    PlayerAttatchedObjects[playerid][pfY][index] = fOffsetY;
    PlayerAttatchedObjects[playerid][pfZ][index] = fOffsetZ;
    PlayerAttatchedObjects[playerid][prX][index] = fRotX;
    PlayerAttatchedObjects[playerid][prY][index] = fRotY;
    PlayerAttatchedObjects[playerid][prZ][index] = fRotZ;
    PlayerAttatchedObjects[playerid][psX][index] = fScaleX;
    PlayerAttatchedObjects[playerid][psY][index] = fScaleY;
    PlayerAttatchedObjects[playerid][psZ][index] = fScaleZ;
    PlayerAttatchedObjects[playerid][pUsingSlot][index] = 1;

    SavePObjects(playerid, index);
    return 1;
}

public OnPlayerSelectObject(playerid, type, objectid, modelid, Float:fX, Float:fY, Float:fZ)
{
    if(type == SELECT_OBJECT_PLAYER_OBJECT)
    {
        EditPlayerObject(playerid, objectid);
    }
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) //New Dialog response
{
	switch(dialogid)
	{
	    case DIALOG_ATTACH_INDEX_SELECTION:
        {
            if(response)
            {
                if(IsPlayerAttachedObjectSlotUsed(playerid, listitem))
                {
                    ShowPlayerDialog(playerid, DIALOG_ATTACH_EDITREPLACE, DIALOG_STYLE_MSGBOX, "{FF0000}Attachment Modification", "Do you wish to edit the attachment in that slot, or delete it?", "Edit", "Delete");
                }
                else
                {
                    new bigstring[4050];
                    for(new x;x<sizeof(AttachmentObjects);x++)
                    {
                   		format(bigstring, sizeof(bigstring), "%s%s\n", bigstring, AttachmentObjects[x][attachname]);
                    }
                    ShowPlayerDialog(playerid, DIALOG_ATTACH_MODEL_SELECTION, DIALOG_STYLE_LIST, \
                    "{FF0000}Attachment Modification - Model Selection", bigstring, "Select", "Cancel");
                }
                SetPVarInt(playerid, "AttachmentIndexSel", listitem);
            }
            else ShowPlayerDialog(playerid, HOLDMENU3E, DIALOG_STYLE_LIST, "{F42626}Set or Edit", "Wear/Take off one of your items \nAdd/Replace items \nEdit items", "Select", "Cancel");
        }
        case DIALOG_ATTACH_EDITREPLACE:
        {
            if(response) EditAttachedObject(playerid, GetPVarInt(playerid, "AttachmentIndexSel"));
            else
			{
				RemovePlayerAttachedObject(playerid, GetPVarInt(playerid, "AttachmentIndexSel"));
				PlayerAttatchedObjects[playerid][pmodel][GetPVarInt(playerid, "AttachmentIndexSel")] = 0;
				SavePObjects(playerid, GetPVarInt(playerid, "AttachmentIndexSel"));
			}
            DeletePVar(playerid, "AttachmentIndexSel");
        }
        case DIALOG_ATTACH_MODEL_SELECTION:
        {
            if(response)
            {
                SetPVarInt(playerid, "AttachmentModelSel", AttachmentObjects[listitem][attachmodel]);
                new holdstring[260];
                for(new x;x<sizeof(AttachmentBones);x++)
                {
                    format(holdstring, sizeof(holdstring), "%s%s\n", holdstring, AttachmentBones[x]);
                }
                ShowPlayerDialog(playerid, DIALOG_ATTACH_BONE_SELECTION, DIALOG_STYLE_LIST, "{FF0000}Attachment Modification - Bone Selection", holdstring, "Select", "Cancel");
            }
            else DeletePVar(playerid, "AttachmentIndexSel");
        }
        case DIALOG_ATTACH_BONE_SELECTION:
        {
            if(response)
            {
                SetPlayerAttachedObject(playerid, GetPVarInt(playerid, "AttachmentIndexSel"), GetPVarInt(playerid, "AttachmentModelSel"), listitem+1);
                EditAttachedObject(playerid, GetPVarInt(playerid, "AttachmentIndexSel"));
                SendClientMessage(playerid, 0xFFFFFFFF, "Hint: Use {FFFF00}~k~~PED_SPRINT~{FFFFFF} to look around.");
            }
            DeletePVar(playerid, "AttachmentIndexSel");
            DeletePVar(playerid, "AttachmentModelSel");
        }
        case HOLDADDDIALOG:
        {
            new stringb[4050];
            if(!response) return ShowPlayerDialog(playerid, HOLDMENU3E, DIALOG_STYLE_LIST, "{F42626}Set or Edit", "Wear/Take off one of your items \nAdd/Replace items \nEdit items", "Select", "Cancel");
			for(new x;x<sizeof(AttachmentObjects);x++)
            {
          		format(stringb, sizeof(stringb), "%s%s\n", stringb, AttachmentObjects[x][attachname]);
            }
            ShowPlayerDialog(playerid, DIALOG_ATTACH_MODEL_SELECTION, DIALOG_STYLE_LIST, \
            "{FF0000}Attachment Modification - Model Selection", stringb, "Select", "Cancel");
            SetPVarInt(playerid, "AttachmentIndexSel", listitem);
        }
        case HOLDMENU3E:
	    {
	        if(!response) return 1;
	        switch(listitem)
	        {
				case 0: // Choose the ones they set
				{
				    new holdstring[800];
				    for(new x;x<MAX_PLAYER_ATTACHED_OBJECTS;x++)
				    {
				        new model = PlayerAttatchedObjects[playerid][pmodel][x];
				        if(PlayerAttatchedObjects[playerid][pmodel][x] > 18000)
						{
						    if(IsPlayerAttachedObjectSlotUsed(playerid, x)) format(holdstring, sizeof(holdstring), "%sSlot: %d Item: %s {43D017}(Used){FFFFFF}\n", holdstring, x, GetAttachedModelName(model));
						    else format(holdstring, sizeof(holdstring), "%sSlot: %d Item: %s\n", holdstring, x, GetAttachedModelName(model));
						}
				        else format(holdstring, sizeof(holdstring), "%sSlot: %d Item: None\n", holdstring, x);
					}
				 	ShowPlayerDialog(playerid, SETHOLDDIALOG, DIALOG_STYLE_LIST, \
				  	"{FF0000}Set Attachment - Slot Selection", holdstring, "Select", "Back");
				}
				case 1: // Add new object
				{
				    new holdstring[800];
				    for(new x;x<MAX_PLAYER_ATTACHED_OBJECTS;x++)
				    {
				    	new model = PlayerAttatchedObjects[playerid][pmodel][x];
				        if(PlayerAttatchedObjects[playerid][pmodel][x] > 18000) format(holdstring, sizeof(holdstring), "%sSlot: %d Item: %s\n", holdstring, x, GetAttachedModelName(model));
				        else format(holdstring, sizeof(holdstring), "%sSlot: %d Item: None\n", holdstring, x);
					}
				 	ShowPlayerDialog(playerid, HOLDADDDIALOG, DIALOG_STYLE_LIST, \
				  	"{FF0000}Add/Replace Attachment - Slot Selection", holdstring, "Select", "Back");
				}
				case 2: // Edit their objects
				{
				    new holdstring[300];
				    for(new x;x<MAX_PLAYER_ATTACHED_OBJECTS;x++)
				    {
				        if(IsPlayerAttachedObjectSlotUsed(playerid, x))
						{
						    new model = PlayerAttatchedObjects[playerid][pmodel][x];
							format(holdstring, sizeof(holdstring), "%sSlot: %d Item: %s (Used)\n", holdstring, x, GetAttachedModelName(model));
						}
				        else
						{
						    if(PlayerAttatchedObjects[playerid][pmodel][x] > 18000)
						    {
						        new model = PlayerAttatchedObjects[playerid][pmodel][x];
                                format(holdstring, sizeof(holdstring), "%sSlot: %d Item: %s\n", holdstring, x, GetAttachedModelName(model));
						    }
						    else format(holdstring, sizeof(holdstring), "%sSlot: %d Item: None\n", holdstring, x);
						}
					}
				 	ShowPlayerDialog(playerid, DIALOG_ATTACH_INDEX_SELECTION, DIALOG_STYLE_LIST, \
				  	"{FF0000}Attachment Modification - Slot Selection", holdstring, "Select", "Back");
				}
			}
	    }
	    case SETHOLDDIALOG:
	    {
	        if(!response) return ShowPlayerDialog(playerid, HOLDMENU3E, DIALOG_STYLE_LIST, "{F42626}Set or Edit", "Wear/Take off one of your items \nAdd/Replace items \nEdit items", "Select", "Cancel");
	        switch(listitem)
	        {
	            case 0:
				{
					if(PlayerAttatchedObjects[playerid][pUsingSlot][0] == 0)
					{
						SetPlayerAttachedObject(playerid, 0, PlayerAttatchedObjects[playerid][pmodel][0], PlayerAttatchedObjects[playerid][pbone][0], PlayerAttatchedObjects[playerid][pfX][0], PlayerAttatchedObjects[playerid][pfY][0], PlayerAttatchedObjects[playerid][pfZ][0],
						PlayerAttatchedObjects[playerid][prX][0], PlayerAttatchedObjects[playerid][prY][0], PlayerAttatchedObjects[playerid][prZ][0], PlayerAttatchedObjects[playerid][psX][0], PlayerAttatchedObjects[playerid][psY][0], PlayerAttatchedObjects[playerid][psZ][0]);
						PlayerAttatchedObjects[playerid][pUsingSlot][0] = 1;
						GameTextForPlayer(playerid, "Item placed", 1200, 3);
					}
					else
					{
						RemovePlayerAttachedObject(playerid, 0);
						PlayerAttatchedObjects[playerid][pUsingSlot][0] = 0;
						SendClientMessage(playerid, -1, "{0BDDC4}[Hold Objects]{FFFFFF} Item removed! To permanently delete it, use edit items.");
					}
					SavePObjects(playerid, 0);
				}
				case 1:
				{
					if(PlayerAttatchedObjects[playerid][pUsingSlot][1] == 0)
					{
						SetPlayerAttachedObject(playerid, 1, PlayerAttatchedObjects[playerid][pmodel][1], PlayerAttatchedObjects[playerid][pbone][1], PlayerAttatchedObjects[playerid][pfX][1], PlayerAttatchedObjects[playerid][pfY][1], PlayerAttatchedObjects[playerid][pfZ][1],
	                    PlayerAttatchedObjects[playerid][prX][1], PlayerAttatchedObjects[playerid][prY][1], PlayerAttatchedObjects[playerid][prZ][1], PlayerAttatchedObjects[playerid][psX][1], PlayerAttatchedObjects[playerid][psY][1], PlayerAttatchedObjects[playerid][psZ][1]);
						PlayerAttatchedObjects[playerid][pUsingSlot][1] = 1;
						GameTextForPlayer(playerid, "Item placed", 1200, 3);
					}
					else
					{
						RemovePlayerAttachedObject(playerid, 1);
						PlayerAttatchedObjects[playerid][pUsingSlot][1] = 0;
						SendClientMessage(playerid, -1, "{0BDDC4}[Hold Objects]{FFFFFF} Item removed! To permanently delete it, use edit items.");
					}
					SavePObjects(playerid, 1);
				}
				case 2:
				{
					if(PlayerAttatchedObjects[playerid][pUsingSlot][2] == 0)
					{
						SetPlayerAttachedObject(playerid, 2, PlayerAttatchedObjects[playerid][pmodel][2], PlayerAttatchedObjects[playerid][pbone][2], PlayerAttatchedObjects[playerid][pfX][2], PlayerAttatchedObjects[playerid][pfY][2], PlayerAttatchedObjects[playerid][pfZ][2],
	                    PlayerAttatchedObjects[playerid][prX][2], PlayerAttatchedObjects[playerid][prY][2], PlayerAttatchedObjects[playerid][prZ][2], PlayerAttatchedObjects[playerid][psX][2], PlayerAttatchedObjects[playerid][psY][2], PlayerAttatchedObjects[playerid][psZ][2]);
						PlayerAttatchedObjects[playerid][pUsingSlot][2] = 1;
						GameTextForPlayer(playerid, "Item placed", 1200, 3);
					}
					else
					{
						RemovePlayerAttachedObject(playerid, 2);
						PlayerAttatchedObjects[playerid][pUsingSlot][2] = 0;
						SendClientMessage(playerid, -1, "{0BDDC4}[Hold Objects]{FFFFFF} Item removed! To permanently delete it, use edit items.");
					}
					SavePObjects(playerid, 2);
				}
	            case 3:
				{
					if(PlayerAttatchedObjects[playerid][pUsingSlot][3] == 0)
					{
						SetPlayerAttachedObject(playerid, 3, PlayerAttatchedObjects[playerid][pmodel][3], PlayerAttatchedObjects[playerid][pbone][3], PlayerAttatchedObjects[playerid][pfX][3], PlayerAttatchedObjects[playerid][pfY][3], PlayerAttatchedObjects[playerid][pfZ][3],
	                    PlayerAttatchedObjects[playerid][prX][3], PlayerAttatchedObjects[playerid][prY][3], PlayerAttatchedObjects[playerid][prZ][3], PlayerAttatchedObjects[playerid][psX][3], PlayerAttatchedObjects[playerid][psY][3], PlayerAttatchedObjects[playerid][psZ][3]);
						PlayerAttatchedObjects[playerid][pUsingSlot][3] = 1;
						GameTextForPlayer(playerid, "Item placed", 1200, 3);
					}
					else
					{
						RemovePlayerAttachedObject(playerid, 3);
						PlayerAttatchedObjects[playerid][pUsingSlot][3] = 0;
						SendClientMessage(playerid, -1, "{0BDDC4}[Hold Objects]{FFFFFF} Item removed! To permanently delete it, use edit items.");
					}
					SavePObjects(playerid, 3);
				}
	            case 4:
				{
					if(PlayerAttatchedObjects[playerid][pUsingSlot][4] == 0)
					{
						SetPlayerAttachedObject(playerid, 4, PlayerAttatchedObjects[playerid][pmodel][4], PlayerAttatchedObjects[playerid][pbone][4], PlayerAttatchedObjects[playerid][pfX][4], PlayerAttatchedObjects[playerid][pfY][4], PlayerAttatchedObjects[playerid][pfZ][4],
	                    PlayerAttatchedObjects[playerid][prX][4], PlayerAttatchedObjects[playerid][prY][4], PlayerAttatchedObjects[playerid][prZ][4], PlayerAttatchedObjects[playerid][psX][4], PlayerAttatchedObjects[playerid][psY][4], PlayerAttatchedObjects[playerid][psZ][4]);
						PlayerAttatchedObjects[playerid][pUsingSlot][4] = 1;
						GameTextForPlayer(playerid, "Item placed", 1200, 3);
					}
					else
					{
						RemovePlayerAttachedObject(playerid, 4);
						PlayerAttatchedObjects[playerid][pUsingSlot][4] = 0;
						SendClientMessage(playerid, -1, "{0BDDC4}[Hold Objects]{FFFFFF} Item removed! To permanently delete it, use edit items.");
					}
					SavePObjects(playerid, 4);
				}
	            case 5:
				{
					if(PlayerAttatchedObjects[playerid][pUsingSlot][5] == 0)
					{
						SetPlayerAttachedObject(playerid, 5, PlayerAttatchedObjects[playerid][pmodel][5], PlayerAttatchedObjects[playerid][pbone][5], PlayerAttatchedObjects[playerid][pfX][5], PlayerAttatchedObjects[playerid][pfY][5], PlayerAttatchedObjects[playerid][pfZ][5],
	                    PlayerAttatchedObjects[playerid][prX][5], PlayerAttatchedObjects[playerid][prY][5], PlayerAttatchedObjects[playerid][prZ][5], PlayerAttatchedObjects[playerid][psX][5], PlayerAttatchedObjects[playerid][psY][5], PlayerAttatchedObjects[playerid][psZ][5]);
						PlayerAttatchedObjects[playerid][pUsingSlot][5] = 1;
						GameTextForPlayer(playerid, "Item placed", 1200, 3);
					}
					else
					{
						RemovePlayerAttachedObject(playerid, 5);
						PlayerAttatchedObjects[playerid][pUsingSlot][5] = 0;
						SendClientMessage(playerid, -1, "{0BDDC4}[Hold Objects]{FFFFFF} Item removed! To permanently delete it, use edit items.");
					}
					SavePObjects(playerid, 5);
				}
	            case 6:
				{
					if(PlayerAttatchedObjects[playerid][pUsingSlot][6] == 0)
					{
						SetPlayerAttachedObject(playerid, 6, PlayerAttatchedObjects[playerid][pmodel][6], PlayerAttatchedObjects[playerid][pbone][6], PlayerAttatchedObjects[playerid][pfX][6], PlayerAttatchedObjects[playerid][pfY][6], PlayerAttatchedObjects[playerid][pfZ][6],
	                    PlayerAttatchedObjects[playerid][prX][6], PlayerAttatchedObjects[playerid][prY][6], PlayerAttatchedObjects[playerid][prZ][6], PlayerAttatchedObjects[playerid][psX][6], PlayerAttatchedObjects[playerid][psY][6], PlayerAttatchedObjects[playerid][psZ][6]);
						PlayerAttatchedObjects[playerid][pUsingSlot][6] = 1;
						GameTextForPlayer(playerid, "Item placed", 1200, 3);
					}
					else
					{
						RemovePlayerAttachedObject(playerid, 6);
						PlayerAttatchedObjects[playerid][pUsingSlot][6] = 0;
						SendClientMessage(playerid, -1, "{0BDDC4}[Hold Objects]{FFFFFF} Item removed! To permanently delete it, use edit items.");
					}
					SavePObjects(playerid, 6);
				}
	            case 7:
				{
					if(PlayerAttatchedObjects[playerid][pUsingSlot][7] == 0)
					{
						SetPlayerAttachedObject(playerid, 7, PlayerAttatchedObjects[playerid][pmodel][7], PlayerAttatchedObjects[playerid][pbone][7], PlayerAttatchedObjects[playerid][pfX][7], PlayerAttatchedObjects[playerid][pfY][7], PlayerAttatchedObjects[playerid][pfZ][7],
	                    PlayerAttatchedObjects[playerid][prX][7], PlayerAttatchedObjects[playerid][prY][7], PlayerAttatchedObjects[playerid][prZ][7], PlayerAttatchedObjects[playerid][psX][7], PlayerAttatchedObjects[playerid][psY][7], PlayerAttatchedObjects[playerid][psZ][7]);
						PlayerAttatchedObjects[playerid][pUsingSlot][7] = 1;
						GameTextForPlayer(playerid, "Item placed", 1200, 3);
					}
					else
					{
						RemovePlayerAttachedObject(playerid, 7);
						PlayerAttatchedObjects[playerid][pUsingSlot][7] = 0;
						SendClientMessage(playerid, -1, "{0BDDC4}[Hold Objects]{FFFFFF} Item removed! To permanently delete it, use edit items.");
					}
					SavePObjects(playerid, 7);
				}
	            case 8:
				{
					if(PlayerAttatchedObjects[playerid][pUsingSlot][8] == 0)
					{
						SetPlayerAttachedObject(playerid, 8, PlayerAttatchedObjects[playerid][pmodel][8], PlayerAttatchedObjects[playerid][pbone][8], PlayerAttatchedObjects[playerid][pfX][8], PlayerAttatchedObjects[playerid][pfY][8], PlayerAttatchedObjects[playerid][pfZ][8],
	                    PlayerAttatchedObjects[playerid][prX][8], PlayerAttatchedObjects[playerid][prY][8], PlayerAttatchedObjects[playerid][prZ][8], PlayerAttatchedObjects[playerid][psX][8], PlayerAttatchedObjects[playerid][psY][8], PlayerAttatchedObjects[playerid][psZ][8]);
						PlayerAttatchedObjects[playerid][pUsingSlot][8] = 1;
						GameTextForPlayer(playerid, "Item placed", 1200, 3);
					}
					else
					{
						RemovePlayerAttachedObject(playerid, 8);
						PlayerAttatchedObjects[playerid][pUsingSlot][8] = 0;
						SendClientMessage(playerid, -1, "{0BDDC4}[Hold Objects]{FFFFFF} Item removed! To permanently delete it, use edit items.");
					}
					SavePObjects(playerid, 8);
				}
	            case 9:
				{
					if(PlayerAttatchedObjects[playerid][pUsingSlot][9] == 0)
					{
						SetPlayerAttachedObject(playerid, 9, PlayerAttatchedObjects[playerid][pmodel][9], PlayerAttatchedObjects[playerid][pbone][9], PlayerAttatchedObjects[playerid][pfX][9], PlayerAttatchedObjects[playerid][pfY][9], PlayerAttatchedObjects[playerid][pfZ][9],
	                    PlayerAttatchedObjects[playerid][prX][9], PlayerAttatchedObjects[playerid][prY][9], PlayerAttatchedObjects[playerid][prZ][9], PlayerAttatchedObjects[playerid][psX][9], PlayerAttatchedObjects[playerid][psY][9], PlayerAttatchedObjects[playerid][psZ][9]);
						PlayerAttatchedObjects[playerid][pUsingSlot][9] = 1;
						GameTextForPlayer(playerid, "Item placed", 1200, 3);
					}
					else
					{
						RemovePlayerAttachedObject(playerid, 9);
						PlayerAttatchedObjects[playerid][pUsingSlot][9] = 0;
						SendClientMessage(playerid, -1, "{0BDDC4}[Hold Objects]{FFFFFF} Item removed! To permanently delete it, use edit items.");
					}
					SavePObjects(playerid, 9);
				}
	        }
	    }
	}
	return 1;
}

forward InitializePlayerObjects(playerid);
public InitializePlayerObjects(playerid)
{
	new Query[160];
	mysql_format(gConnectionhandle, Query, "SELECT * FROM `PlayerObjects` WHERE `Name` = '%s' LIMIT 10", pName(playerid));
	mysql_function_query(gConnectionhandle, Query, true, "OnPlayerObjectsLoad", "d", playerid);
}

CMD:playerobjects(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{F42626}[Info]{FFFFFF}You need to leave the vehicle to use this command!");
	ShowPlayerDialog(playerid, HOLDMENU3E, DIALOG_STYLE_LIST, "{F42626}Set or Edit", "Wear/Take off one of your items \nAdd/Replace items \nEdit items", "Select", "Cancel");
	return 1;
}

/*==============================================================================
	Use InitializePlayerObjects(playerid); where player info is beeing loaded
==============================================================================*/
forward OnPlayerObjectsLoad(playerid);
public OnPlayerObjectsLoad(playerid)
{
  	if(IsPlayerConnected(playerid))
   	{
	    new rows, fields;
 		cache_get_data(rows, fields);
 		if(!rows)
		{
  			new EscName[MAX_PLAYER_NAME], Query[160];
	    	mysql_real_escape_string(pName(playerid), EscName);
		    for(new i = 0; i < 10; i++)
		    {
				format(Query, sizeof(Query), "INSERT INTO `PlayerObjects` (`Name`, `Slot`) VALUES ('%s', %d)", EscName, i);
				mysql_function_query(gConnectionhandle, Query, false, "NoReturnThread", "d", playerid);

				PlayerAttatchedObjects[playerid][pmodel][i] = 0;
			    PlayerAttatchedObjects[playerid][pbone][i] = 0;
			    PlayerAttatchedObjects[playerid][pfX][i] = 0;
			    PlayerAttatchedObjects[playerid][pfY][i] = 0;
			    PlayerAttatchedObjects[playerid][pfZ][i] = 0;
			    PlayerAttatchedObjects[playerid][prX][i] = 0;
			    PlayerAttatchedObjects[playerid][prY][i] = 0;
			    PlayerAttatchedObjects[playerid][prZ][i] = 0;
			    PlayerAttatchedObjects[playerid][psX][i] = 0;
			    PlayerAttatchedObjects[playerid][psY][i] = 0;
			    PlayerAttatchedObjects[playerid][psZ][i] = 0;
			    PlayerAttatchedObjects[playerid][pUsingSlot][i] = 0;
			}
		}
   		else
   		{
   		    new Data[50];
   		    for(new x=0; x<rows; x++)
   		    {
	   		    cache_get_field_content(x, "model", Data), 						PlayerAttatchedObjects[playerid][pmodel][x]  = strval(Data);
	   		    cache_get_field_content(x, "bone", Data), 						PlayerAttatchedObjects[playerid][pbone][x] = strval(Data);
	   		    cache_get_field_content(x, "fX", Data),							PlayerAttatchedObjects[playerid][pfX][x] = floatstr(Data);
	   		    cache_get_field_content(x, "fY", Data),							PlayerAttatchedObjects[playerid][pfY][x] = floatstr(Data);
	   		    cache_get_field_content(x, "fZ", Data),							PlayerAttatchedObjects[playerid][pfZ][x] = floatstr(Data);
	   		    cache_get_field_content(x, "rX", Data),							PlayerAttatchedObjects[playerid][prX][x] = floatstr(Data);
	   		    cache_get_field_content(x, "rY", Data),							PlayerAttatchedObjects[playerid][prY][x] = floatstr(Data);
	   		    cache_get_field_content(x, "rZ", Data), 						PlayerAttatchedObjects[playerid][prZ][x] = floatstr(Data);
	   		    cache_get_field_content(x, "sX", Data),							PlayerAttatchedObjects[playerid][psX][x] = floatstr(Data);
	   		    cache_get_field_content(x, "sY", Data),							PlayerAttatchedObjects[playerid][psY][x] = floatstr(Data);
	   		    cache_get_field_content(x, "sZ", Data),							PlayerAttatchedObjects[playerid][psZ][x] = floatstr(Data);
	   		    cache_get_field_content(x, "Enabled", Data),					PlayerAttatchedObjects[playerid][pUsingSlot][x] = strval(Data);
			}
		}
  	}
    return 1;
}

forward NoReturnThreads();
public NoReturnThreads()
{
	return 1;
}

/*==============================================================================
								Stocks
===============================================================================*/
stock pName(playerid)
{
	new Name[24];
	GetPlayerName(playerid, Name, sizeof(Name));
	return Name;
}

stock SetPlayerObjects(playerid)
{
    for(new i=0; i<10; i++)
    {
        if(PlayerAttatchedObjects[playerid][pmodel][i] > 18000)
        {
            if(PlayerAttatchedObjects[playerid][pUsingSlot][i] == 1)
            {
        		SetPlayerAttachedObject(playerid, i, PlayerAttatchedObjects[playerid][pmodel][i], PlayerAttatchedObjects[playerid][pbone][i], PlayerAttatchedObjects[playerid][pfX][i], PlayerAttatchedObjects[playerid][pfY][i], PlayerAttatchedObjects[playerid][pfZ][i],
        		PlayerAttatchedObjects[playerid][prX][i], PlayerAttatchedObjects[playerid][prY][i], PlayerAttatchedObjects[playerid][prZ][i], PlayerAttatchedObjects[playerid][psX][i], PlayerAttatchedObjects[playerid][psY][i], PlayerAttatchedObjects[playerid][psZ][i]);
			}
        }
    }
}

stock SavePObjects(playerid, slotid)
{
    new
		Query[1024], EscName[MAX_PLAYER_NAME];

	new index = slotid;

	if(index < 10)
	{
		mysql_real_escape_string(pName(playerid), EscName);

	    format(Query, sizeof(Query), "UPDATE `PlayerObjects` SET `model` = %d, `bone` = %d, `fX` = %f, `fY` = %f, `fZ` = %f, `rX` = %f, `rY` = %f, `rZ` = %f, `sX` = %f, `sY` = %f, `sZ` = %f, `Enabled` = %d WHERE `Name` = '%s' AND `Slot` = %d",
		PlayerAttatchedObjects[playerid][pmodel][index],
	    PlayerAttatchedObjects[playerid][pbone][index],
	    PlayerAttatchedObjects[playerid][pfX][index],
	    PlayerAttatchedObjects[playerid][pfY][index],
	    PlayerAttatchedObjects[playerid][pfZ][index],
	    PlayerAttatchedObjects[playerid][prX][index],
	    PlayerAttatchedObjects[playerid][prY][index],
	    PlayerAttatchedObjects[playerid][prZ][index],
	    PlayerAttatchedObjects[playerid][psX][index],
	    PlayerAttatchedObjects[playerid][psY][index],
	    PlayerAttatchedObjects[playerid][psZ][index],
	    PlayerAttatchedObjects[playerid][pUsingSlot][index],
		EscName,
	 	index);

	    mysql_function_query(gConnectionhandle, Query, false, "NoReturnThreads", "");
	}
}

stock ResetHoldObjects(playerid)
{
	for(new i = 0; i < 10; i++)
	{
    	PlayerAttatchedObjects[playerid][pmodel][i] = 0;
	    PlayerAttatchedObjects[playerid][pbone][i] = 0;
	    PlayerAttatchedObjects[playerid][pfX][i] = 0;
	    PlayerAttatchedObjects[playerid][pfY][i] = 0;
	    PlayerAttatchedObjects[playerid][pfZ][i] = 0;
	    PlayerAttatchedObjects[playerid][prX][i] = 0;
	    PlayerAttatchedObjects[playerid][prY][i] = 0;
	    PlayerAttatchedObjects[playerid][prZ][i] = 0;
	    PlayerAttatchedObjects[playerid][psX][i] = 0;
	    PlayerAttatchedObjects[playerid][psY][i] = 0;
	    PlayerAttatchedObjects[playerid][psZ][i] = 0;
	    PlayerAttatchedObjects[playerid][pUsingSlot][i] = 0;
	}
}

stock GetAttachedModelName(modelid)
{
    new returnt[64];
	switch(modelid)
	{
	    case 18632: { format(returnt,sizeof(returnt),  "FishingRod"); }
		case 18633: { format(returnt,sizeof(returnt),  "GTASAWrench1"); }
		case 18634: { format(returnt,sizeof(returnt),  "GTASACrowbar1"); }
		case 18635: { format(returnt,sizeof(returnt),  "GTASAHammer1"); }
		case 18636: { format(returnt,sizeof(returnt),  "PoliceCap1"); }
		case 18637: { format(returnt,sizeof(returnt),  "PoliceShield1"); }
		case 18638: { format(returnt,sizeof(returnt),  "HardHat1"); }
		case 18639: { format(returnt,sizeof(returnt),  "BlackHat1"); }
		case 18640: { format(returnt,sizeof(returnt),  "Hair1"); }
		case 18975: { format(returnt,sizeof(returnt),  "Hair2"); }
		case 19136: { format(returnt,sizeof(returnt),  "Hair4"); }
		case 19274: { format(returnt,sizeof(returnt),  "Hair5"); }
		case 18641: { format(returnt,sizeof(returnt),  "Flashlight1"); }
		case 18642: { format(returnt,sizeof(returnt),  "Taser1"); }
		case 18643: { format(returnt,sizeof(returnt),  "LaserPointer1"); }
		case 19080: { format(returnt,sizeof(returnt),  "LaserPointer2"); }
		case 19081: { format(returnt,sizeof(returnt),  "LaserPointer3"); }
		case 19082: { format(returnt,sizeof(returnt),  "LaserPointer4"); }
		case 19083: { format(returnt,sizeof(returnt),  "LaserPointer5"); }
		case 19084: { format(returnt,sizeof(returnt),  "LaserPointer6"); }
		case 18644: { format(returnt,sizeof(returnt),  "Screwdriver1"); }
		case 18645: { format(returnt,sizeof(returnt),  "MotorcycleHelmet1"); }
		case 18865: { format(returnt,sizeof(returnt),  "MobilePhone1"); }
		case 18866: { format(returnt,sizeof(returnt),  "MobilePhone2"); }
		case 18867: { format(returnt,sizeof(returnt),  "MobilePhone3"); }
		case 18868: { format(returnt,sizeof(returnt),  "MobilePhone4"); }
		case 18869: { format(returnt,sizeof(returnt),  "MobilePhone5"); }
		case 18870: { format(returnt,sizeof(returnt),  "MobilePhone6"); }
		case 18871: { format(returnt,sizeof(returnt),  "MobilePhone7"); }
		case 18872: { format(returnt,sizeof(returnt),  "MobilePhone8"); }
		case 18873: { format(returnt,sizeof(returnt),  "MobilePhone9"); }
		case 18874: { format(returnt,sizeof(returnt),  "MobilePhone10"); }
		case 18875: { format(returnt,sizeof(returnt),  "Pager1"); }
		case 18890: { format(returnt,sizeof(returnt),  "Rake1"); }
		case 18891: { format(returnt,sizeof(returnt),  "Bandana1"); }
		case 18892: { format(returnt,sizeof(returnt),  "Bandana2"); }
		case 18893: { format(returnt,sizeof(returnt),  "Bandana3"); }
		case 18894: { format(returnt,sizeof(returnt),  "Bandana4"); }
		case 18895: { format(returnt,sizeof(returnt),  "Bandana5"); }
		case 18896: { format(returnt,sizeof(returnt),  "Bandana6"); }
		case 18897: { format(returnt,sizeof(returnt),  "Bandana7"); }
		case 18898: { format(returnt,sizeof(returnt),  "Bandana8"); }
		case 18899: { format(returnt,sizeof(returnt),  "Bandana9"); }
		case 18900: { format(returnt,sizeof(returnt),  "Bandana10"); }
		case 18901: { format(returnt,sizeof(returnt),  "Bandana11"); }
		case 18902: { format(returnt,sizeof(returnt),  "Bandana12"); }
		case 18903: { format(returnt,sizeof(returnt),  "Bandana13"); }
		case 18904: { format(returnt,sizeof(returnt),  "Bandana14"); }
		case 18905: { format(returnt,sizeof(returnt),  "Bandana15"); }
		case 18906: { format(returnt,sizeof(returnt),  "Bandana16"); }
		case 18907: { format(returnt,sizeof(returnt),  "Bandana17"); }
		case 18908: { format(returnt,sizeof(returnt),  "Bandana18"); }
		case 18909: { format(returnt,sizeof(returnt),  "Bandana19"); }
		case 18910: { format(returnt,sizeof(returnt),  "Bandana20"); }
		case 18911: { format(returnt,sizeof(returnt),  "Mask1"); }
		case 18912: { format(returnt,sizeof(returnt),  "Mask2"); }
		case 18913: { format(returnt,sizeof(returnt),  "Mask3"); }
		case 18914: { format(returnt,sizeof(returnt),  "Mask4"); }
		case 18915: { format(returnt,sizeof(returnt),  "Mask5"); }
		case 18916: { format(returnt,sizeof(returnt),  "Mask6"); }
		case 18917: { format(returnt,sizeof(returnt),  "Mask7"); }
		case 18918: { format(returnt,sizeof(returnt),  "Mask8"); }
		case 18919: { format(returnt,sizeof(returnt),  "Mask9"); }
		case 18920: { format(returnt,sizeof(returnt),  "Mask10"); }
		case 18921: { format(returnt,sizeof(returnt),  "Beret1"); }
		case 18922: { format(returnt,sizeof(returnt),  "Beret2"); }
		case 18923: { format(returnt,sizeof(returnt),  "Beret3"); }
		case 18924: { format(returnt,sizeof(returnt),  "Beret4"); }
		case 18925: { format(returnt,sizeof(returnt),  "Beret5"); }
		case 18926: { format(returnt,sizeof(returnt),  "Hat1"); }
		case 18927: { format(returnt,sizeof(returnt),  "Hat2"); }
		case 18928: { format(returnt,sizeof(returnt),  "Hat3"); }
		case 18929: { format(returnt,sizeof(returnt),  "Hat4"); }
		case 18930: { format(returnt,sizeof(returnt),  "Hat5"); }
		case 18931: { format(returnt,sizeof(returnt),  "Hat6"); }
		case 18932: { format(returnt,sizeof(returnt),  "Hat7"); }
		case 18933: { format(returnt,sizeof(returnt),  "Hat8"); }
		case 18934: { format(returnt,sizeof(returnt),  "Hat9"); }
		case 18935: { format(returnt,sizeof(returnt),  "Hat10"); }
		case 18936: { format(returnt,sizeof(returnt),  "Helmet1"); }
		case 18937: { format(returnt,sizeof(returnt),  "Helmet2"); }
		case 18938: { format(returnt,sizeof(returnt),  "Helmet3"); }
		case 18939: { format(returnt,sizeof(returnt),  "CapBack1"); }
		case 18940: { format(returnt,sizeof(returnt),  "CapBack2"); }
		case 18941: { format(returnt,sizeof(returnt),  "CapBack3"); }
		case 18942: { format(returnt,sizeof(returnt),  "CapBack4"); }
		case 18943: { format(returnt,sizeof(returnt),  "CapBack5"); }
		case 18944: { format(returnt,sizeof(returnt),  "HatBoater1"); }
		case 18945: { format(returnt,sizeof(returnt),  "HatBoater2"); }
		case 18946: { format(returnt,sizeof(returnt),  "HatBoater3"); }
		case 18947: { format(returnt,sizeof(returnt),  "HatBowler1"); }
		case 18948: { format(returnt,sizeof(returnt),  "HatBowler2"); }
		case 18949: { format(returnt,sizeof(returnt),  "HatBowler3"); }
		case 18950: { format(returnt,sizeof(returnt),  "HatBowler4"); }
		case 18951: { format(returnt,sizeof(returnt),  "HatBowler5"); }
		case 18952: { format(returnt,sizeof(returnt),  "BoxingHelmet1"); }
		case 18953: { format(returnt,sizeof(returnt),  "CapKnit1"); }
		case 18954: { format(returnt,sizeof(returnt),  "CapKnit2"); }
		case 18955: { format(returnt,sizeof(returnt),  "CapOverEye1"); }
		case 18956: { format(returnt,sizeof(returnt),  "CapOverEye2"); }
		case 18957: { format(returnt,sizeof(returnt),  "CapOverEye3"); }
		case 18958: { format(returnt,sizeof(returnt),  "CapOverEye4"); }
		case 18959: { format(returnt,sizeof(returnt),  "CapOverEye5"); }
		case 18960: { format(returnt,sizeof(returnt),  "CapRimUp1"); }
		case 18961: { format(returnt,sizeof(returnt),  "CapTrucker1"); }
		case 18962: { format(returnt,sizeof(returnt),  "CowboyHat2"); }
		case 18963: { format(returnt,sizeof(returnt),  "CJElvisHead"); }
		case 18964: { format(returnt,sizeof(returnt),  "SkullyCap1"); }
		case 18965: { format(returnt,sizeof(returnt),  "SkullyCap2"); }
		case 18966: { format(returnt,sizeof(returnt),  "SkullyCap3"); }
		case 18967: { format(returnt,sizeof(returnt),  "HatMan1"); }
		case 18968: { format(returnt,sizeof(returnt),  "HatMan2"); }
		case 18969: { format(returnt,sizeof(returnt),  "HatMan3"); }
		case 18970: { format(returnt,sizeof(returnt),  "HatTiger1"); }
		case 18971: { format(returnt,sizeof(returnt),  "HatCool1"); }
		case 18972: { format(returnt,sizeof(returnt),  "HatCool2"); }
		case 18973: { format(returnt,sizeof(returnt),  "HatCool3"); }
		case 18974: { format(returnt,sizeof(returnt),  "MaskZorro1"); }
		case 18976: { format(returnt,sizeof(returnt),  "MotorcycleHelmet2"); }
		case 18977: { format(returnt,sizeof(returnt),  "MotorcycleHelmet3"); }
		case 18978: { format(returnt,sizeof(returnt),  "MotorcycleHelmet4"); }
		case 18979: { format(returnt,sizeof(returnt),  "MotorcycleHelmet5"); }
		case 19006: { format(returnt,sizeof(returnt),  "GlassesType1"); }
		case 19007: { format(returnt,sizeof(returnt),  "GlassesType2"); }
		case 19008: { format(returnt,sizeof(returnt),  "GlassesType3"); }
		case 19009: { format(returnt,sizeof(returnt),  "GlassesType4"); }
		case 19010: { format(returnt,sizeof(returnt),  "GlassesType5"); }
		case 19011: { format(returnt,sizeof(returnt),  "GlassesType6"); }
		case 19012: { format(returnt,sizeof(returnt),  "GlassesType7"); }
		case 19013: { format(returnt,sizeof(returnt),  "GlassesType8"); }
		case 19014: { format(returnt,sizeof(returnt),  "GlassesType9"); }
		case 19015: { format(returnt,sizeof(returnt),  "GlassesType10"); }
		case 19016: { format(returnt,sizeof(returnt),  "GlassesType11"); }
		case 19017: { format(returnt,sizeof(returnt),  "GlassesType12"); }
		case 19018: { format(returnt,sizeof(returnt),  "GlassesType13"); }
		case 19019: { format(returnt,sizeof(returnt),  "GlassesType14"); }
		case 19020: { format(returnt,sizeof(returnt),  "GlassesType15"); }
		case 19021: { format(returnt,sizeof(returnt),  "GlassesType16"); }
		case 19022: { format(returnt,sizeof(returnt),  "GlassesType17"); }
		case 19023: { format(returnt,sizeof(returnt),  "GlassesType18"); }
		case 19024: { format(returnt,sizeof(returnt),  "GlassesType19"); }
		case 19025: { format(returnt,sizeof(returnt),  "GlassesType20"); }
		case 19026: { format(returnt,sizeof(returnt),  "GlassesType21"); }
		case 19027: { format(returnt,sizeof(returnt),  "GlassesType22"); }
		case 19028: { format(returnt,sizeof(returnt),  "GlassesType23"); }
		case 19029: { format(returnt,sizeof(returnt),  "GlassesType24"); }
		case 19030: { format(returnt,sizeof(returnt),  "GlassesType25"); }
		case 19031: { format(returnt,sizeof(returnt),  "GlassesType26"); }
		case 19032: { format(returnt,sizeof(returnt),  "GlassesType27"); }
		case 19033: { format(returnt,sizeof(returnt),  "GlassesType28"); }
		case 19034: { format(returnt,sizeof(returnt),  "GlassesType29"); }
		case 19035: { format(returnt,sizeof(returnt),  "GlassesType30"); }
		case 19036: { format(returnt,sizeof(returnt),  "HockeyMask1"); }
		case 19037: { format(returnt,sizeof(returnt),  "HockeyMask2"); }
		case 19038: { format(returnt,sizeof(returnt),  "HockeyMask3"); }
		case 19039: { format(returnt,sizeof(returnt),  "WatchType1"); }
		case 19040: { format(returnt,sizeof(returnt),  "WatchType2"); }
		case 19041: { format(returnt,sizeof(returnt),  "WatchType3"); }
		case 19042: { format(returnt,sizeof(returnt),  "WatchType4"); }
		case 19043: { format(returnt,sizeof(returnt),  "WatchType5"); }
		case 19044: { format(returnt,sizeof(returnt),  "WatchType6"); }
		case 19045: { format(returnt,sizeof(returnt),  "WatchType7"); }
		case 19046: { format(returnt,sizeof(returnt),  "WatchType8"); }
		case 19047: { format(returnt,sizeof(returnt),  "WatchType9"); }
		case 19048: { format(returnt,sizeof(returnt),  "WatchType10"); }
		case 19049: { format(returnt,sizeof(returnt),  "WatchType11"); }
		case 19050: { format(returnt,sizeof(returnt),  "WatchType12"); }
		case 19051: { format(returnt,sizeof(returnt),  "WatchType13"); }
		case 19052: { format(returnt,sizeof(returnt),  "WatchType14"); }
		case 19053: { format(returnt,sizeof(returnt),  "WatchType15"); }
		case 19079: { format(returnt,sizeof(returnt),  "Parrot"); }
		case 19085: { format(returnt,sizeof(returnt),  "EyePatch1"); }
		case 19086: { format(returnt,sizeof(returnt),  "ChainsawDildo1"); }
		case 19090: { format(returnt,sizeof(returnt),  "PomPomBlue"); }
		case 19091: { format(returnt,sizeof(returnt),  "PomPomRed"); }
		case 19092: { format(returnt,sizeof(returnt),  "PomPomGreen"); }
		case 19093: { format(returnt,sizeof(returnt),  "HardHat2"); }
		case 19094: { format(returnt,sizeof(returnt),  "BurgerShotHat1"); }
		case 19095: { format(returnt,sizeof(returnt),  "CowboyHat1"); }
		case 19096: { format(returnt,sizeof(returnt),  "CowboyHat3"); }
		case 19097: { format(returnt,sizeof(returnt),  "CowboyHat4"); }
		case 19098: { format(returnt,sizeof(returnt),  "CowboyHat5"); }
		case 19099: { format(returnt,sizeof(returnt),  "PoliceCap2"); }
		case 19100: { format(returnt,sizeof(returnt),  "PoliceCap3"); }
		case 19101: { format(returnt,sizeof(returnt),  "ArmyHelmet1"); }
		case 19102: { format(returnt,sizeof(returnt),  "ArmyHelmet2"); }
		case 19103: { format(returnt,sizeof(returnt),  "ArmyHelmet3"); }
		case 19104: { format(returnt,sizeof(returnt),  "ArmyHelmet4"); }
		case 19105: { format(returnt,sizeof(returnt),  "ArmyHelmet5"); }
		case 19106: { format(returnt,sizeof(returnt),  "ArmyHelmet6"); }
		case 19107: { format(returnt,sizeof(returnt),  "ArmyHelmet7"); }
		case 19108: { format(returnt,sizeof(returnt),  "ArmyHelmet8"); }
		case 19109: { format(returnt,sizeof(returnt),  "ArmyHelmet9"); }
		case 19110: { format(returnt,sizeof(returnt),  "ArmyHelmet10"); }
		case 19111: { format(returnt,sizeof(returnt),  "ArmyHelmet11"); }
		case 19112: { format(returnt,sizeof(returnt),  "ArmyHelmet12"); }
		case 19113: { format(returnt,sizeof(returnt),  "SillyHelmet1"); }
		case 19114: { format(returnt,sizeof(returnt),  "SillyHelmet2"); }
		case 19115: { format(returnt,sizeof(returnt),  "SillyHelmet3"); }
		case 19116: { format(returnt,sizeof(returnt),  "PlainHelmet1"); }
		case 19117: { format(returnt,sizeof(returnt),  "PlainHelmet2"); }
		case 19118: { format(returnt,sizeof(returnt),  "PlainHelmet3"); }
		case 19119: { format(returnt,sizeof(returnt),  "PlainHelmet4"); }
		case 19120: { format(returnt,sizeof(returnt),  "PlainHelmet5"); }
		case 19137: { format(returnt,sizeof(returnt),  "CluckinBellHat1"); }
		case 19138: { format(returnt,sizeof(returnt),  "PoliceGlasses1"); }
		case 19139: { format(returnt,sizeof(returnt),  "PoliceGlasses2"); }
		case 19140: { format(returnt,sizeof(returnt),  "PoliceGlasses3"); }
		case 19141: { format(returnt,sizeof(returnt),  "SWATHelmet1"); }
		case 19142: { format(returnt,sizeof(returnt),  "SWATArmour1"); }
		case 19160: { format(returnt,sizeof(returnt),  "HardHat3"); }
		case 19161: { format(returnt,sizeof(returnt),  "PoliceHat1"); }
		case 19162: { format(returnt,sizeof(returnt),  "PoliceHat2"); }
		case 19163: { format(returnt,sizeof(returnt),  "GimpMask1"); }
		case 19317: { format(returnt,sizeof(returnt),  "bassguitar01"); }
		case 19318: { format(returnt,sizeof(returnt),  "flyingv01"); }
		case 19319: { format(returnt,sizeof(returnt),  "warlock01"); }
		case 19330: { format(returnt,sizeof(returnt),  "fire_hat01"); }
		case 19331: { format(returnt,sizeof(returnt),  "fire_hat02"); }
		case 19346: { format(returnt,sizeof(returnt),  "hotdog01"); }
		case 19347: { format(returnt,sizeof(returnt),  "badge01"); }
		case 19348: { format(returnt,sizeof(returnt),  "cane01"); }
		case 19349: { format(returnt,sizeof(returnt),  "monocle01"); }
		case 19350: { format(returnt,sizeof(returnt),  "moustache01"); }
		case 19351: { format(returnt,sizeof(returnt),  "moustache02"); }
		case 19352: { format(returnt,sizeof(returnt),  "tophat01"); }
		default: { format(returnt,sizeof(returnt),  "Un-listed item"); }
	}
	return returnt;
}
