
//====================================================================*/
#include <a_samp>
#include <sscanf>
#include <streamer>
#include <dini>
#include <zcmd>
#include <foreach>
#include <YSI\y_ini>


#undef MAX_PLAYERS
#define MAX_PLAYERS 32  // Here you need to set the maximum number of players able to play on your server


#define Grey                        0xC0C0C0FF
#define COLOR_YELLOW2               0xF5DEB3AA
#define COLOR_NICERED               0xFF0000FF
#define COLOR_SUPERGREEN 0xFF01FF
#define COLOR_MODRA 0x0088FFFF
#define xBox                DIALOG_STYLE_MSGBOX
#define COLOR_HNEDA 0x993300AA
#define COLOR_0000 0x0000FFAA
#define DIALOG_REGISTER 1
#define DIALOG_LOGIN 2
#define DIALOG_SUCCESS_1 3
#define DIALOG_SUCCESS_2 4
#define COLOR_SYSTEM 0xEFEFF7AA
#define COLOR_BLUE 0x0000FFAA
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_RED 0xFF0000AA
#define COLOR_YELLOW 0xFFFF00AA
#define Vcmds		  ShowPlayerDialog
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_PURPLE 0x9900FFAA
#define COL_OGREEN         "{FFAF00}"
#define COL_ERROR          "{FF0202}"
#define COL_USAGE          "{DFDFDF}"
#define TAG[SRC]           "{FFBF00}"
#define COL_EASY           "{FFF1AF}"
#define COL_WHITE          "{FFFFFF}"
#define COL_BLACK          "{0E0101}"
#define COL_GREY           "{C3C3C3}"
#define V.I.PCmds           29
#define COL_GREEN          "{6EF83C}"
#define COL_RED            "{F81414}"
#define COL_YELLOW         "{F3FF02}"
#define COL_ORANGE         "{FFA1A1}"
#define COL_INDIGO         "{8B008B}"
#define COL_LIME           "{B7FF00}"
#define COL_CYAN           "{00FFEE}"
#define COL_LIGHTBLUE      "{C9FFAB}"
#define CLB      		   "{FFAF00}"
#define COL_BLUE           "{0049FF}"
#define COL_MAGENTA        "{F300FF}"
#define COL_VIOLET         "{B700FF}"
#define COL_PINK           "{FF00EA}"
#define COL_MARONE         "{A90202}"
#define COL_CMD            "{B8FF02}"
#define COL_PARAM          "{3FCD02}"
#define COL_SERVER         "{AFE7FF}"
#define COL_VALUE 		   "{FF8E02}"
#define COL_RULE  	   	   "{FFDE02}"
#define COL_RULE2 		   "{FBDF89}"
#define COL_RWHITE 		   "{FFFFFF}"
#define COL_LGREEN         "{C9FFAB}"
#define COL_LRED           "{FFA1A1}"
#define COL_WHITE "{FFFFFF}"
#define COL_RED "{F81414}"
#define COL_LRED2          "{C77D87}"
#define SERVER 			   "{0E0101}[{AFE7FF}SERVER{0E0101}]{FFFFFF}:"
#define COL_TRASH          "{ACD59D}"
#define COLOR_BROWN 0x993300AA
#define COLOR_ORANGE 0xFF9933AA
#define COLOR_CYAN 0x99FFFFAA
#define COLOR_PINK 0xFF66FFAA
#define COLOR_KHAKI 0x999900AA
#define COLOR_LIME 0x99FF00AA
#define XVip1 String1
#define XVip2 String2
#define XVip3 String3
#define XVcmds StringF
#define COLOR_BLACK 0x000000AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_GAMES 0xFFFFFFAA
#define blue 0x375FFFFF
#define red 0xFF0000AA
#define green 0x33FF33AA
#define yellow 0xFFFF00AA
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_LIME 0x99FF00AA
#define COLOR_LIGHTYELLOW 0xFAEAA9FF
#define COLOR_LIGHTGREEN 0x5BC476FF
#define COLOR_LIGHTORANGE 0xF7A26FFF
#define PATH "/Users/%s.ini"
#define COLOR_LIGHTRED 0xFF6A6AFF
#define COLOR_VIP 0xDDD100FF
#define MAX_FAIL_LOGINS 3
new bool:IsLogged[MAX_PLAYERS];
new Vip[MAX_PLAYERS];
new Text3D:VIPS[MAX_PLAYERS];
new Anti_heal[MAX_PLAYERS];
new wep[MAX_PLAYERS];
new de[MAX_PLAYERS];
new deb[MAX_PLAYERS];
new VipCar[MAX_PLAYERS];
new tune[MAX_PLAYERS];
new ob1;
new ob2;
new ob3;
new ob4;
new ob5;
new ob6;
new ob7;
new ob8;
new ob9;
new ob10;
new ob11;
new ob12;
new ob13;
new ob14;
new ob15;
new ob16;
new ob17;
new ob18;
new ob19;
new ob20;
new ob21;
new ob22;
new b1;
new b2;
new b3;
enum pInfo
{
    pVIP,
}
enum PLAYERDATA
{
    Float: E_LAST_X,
    Float: E_LAST_Y,
    Float: E_LAST_Z,

    bool:  E_SET,
}
new gPlayerData[MAX_PLAYERS][PLAYERDATA];
new PlayerInfo[MAX_PLAYERS][pInfo];
new String[128], Float:SpecX[MAX_PLAYERS], Float:SpecY[MAX_PLAYERS], Float:SpecZ[MAX_PLAYERS], vWorld[MAX_PLAYERS], Inter[MAX_PLAYERS];
new IsSpecing[MAX_PLAYERS], Name[MAX_PLAYER_NAME], IsBeingSpeced[MAX_PLAYERS],spectatorid[MAX_PLAYERS];
forward IronMan(playerid);
forward DestroyMe(objectid);
forward Jav(playerid);
forward Float:SetPlayerToFacePos(playerid, Float:X, Float:Y);
forward GetClosestPlayer(p1);
forward Float:GetDistanceBetweenPlayers(p1, p2);
new
	bool:flying[MAX_PLAYERS],
	Javelin[MAX_PLAYERS][2],
	Float:JavPos[MAX_PLAYERS][3];
	
new ship[MAX_PLAYERS];
new o;
new SpawnedVeh[MAX_PLAYERS];
new Text:Textdraw0;
new asked[MAX_PLAYERS];
new asked1[MAX_PLAYERS];
public OnPlayerConnect(playerid)
{
    tune[playerid] = 0;
    asked1[playerid] = 0;
	asked[playerid] = 0;
	ship[playerid] = 0;
 	INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
    new INI:File = INI_Open(UserPath(playerid));
    INI_SetTag(File,"data");
    INI_WriteInt(File,"VIP",0);
    INI_Close(File);
    return 1;
}


public OnPlayerDisconnect(playerid, reason)
{
if(IsBeingSpeced[playerid] == 1)
{
foreach(Player,i)
{
if(spectatorid[i] == playerid)
{
TogglePlayerSpectating(i,false);
}
}
}
new INI:File = INI_Open(UserPath(playerid));
INI_SetTag(File,"data");
INI_WriteInt(File,"VIP",Vip[playerid]);
INI_Close(File);
if(IsPlayerConnected(playerid)) {
IsLogged[playerid] = false;
}
return 1;
}
forward LoadUser_data(playerid,name[],value[]);
public LoadUser_data(playerid,name[],value[])
{
    INI_Int("VIP",PlayerInfo[playerid][pVIP]);
    return 1;
}
stock UserPath(playerid)
{
    new string[128],playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),PATH,playername);
    return string;
}
public OnPlayerSpawn(playerid)
{
	if(IsSpecing[playerid] == 1)
    {
    SetPlayerPos(playerid,SpecX[playerid],SpecY[playerid],SpecZ[playerid]);
    SetPlayerInterior(playerid,Inter[playerid]);
    SetPlayerVirtualWorld(playerid,vWorld[playerid]);
    IsSpecing[playerid] = 0;
    IsBeingSpeced[spectatorid[playerid]] = 0;
    }
	if(Vip[playerid] >= 1) {
 	VIPS[playerid] = Create3DTextLabel(" VIP Member", COLOR_VIP, 0.0, 0.0, 0.0, 50.0, 0, 0);
  	Attach3DTextLabelToPlayer(VIPS[playerid], playerid, 0.0, 0.0, 0.0);
   	SetPlayerArmour(playerid,100);
    }
    return 1;
}


public OnPlayerDeath(playerid, killerid, reason)
{
        if(IsBeingSpeced[playerid] == 1)
    	{
        foreach(Player,i)
       	{
            if(spectatorid[i] == playerid)
            {
                TogglePlayerSpectating(i,false);
            }
       	}
    	}
    
    	Anti_heal[playerid] = 0;
    	deb[playerid] = 0;
   	 	if(Vip[playerid] == 0) {
        VipCar[playerid] = 0;
        SendDeathMessage(killerid,playerid,reason);
        SendClientMessage(killerid, COLOR_GREEN, "+1 Score & +$ 500");
        SetPlayerScore(killerid,GetPlayerScore(killerid)+1);
        GivePlayerMoney(killerid,GetPlayerMoney(killerid)+500);
        GameTextForPlayer(killerid,"~r~+$500~n~~b~+1~w~Score",3000,4);
    	}
    	if(Vip[playerid] == 1) {
    	VipCar[playerid] = 0;
        SendDeathMessage(killerid,playerid,reason);
        SendClientMessage(killerid, COLOR_GAMES, "You are (Level 1 VIP) , you win +1score and +700$! ");
        SetPlayerScore(killerid,GetPlayerScore(killerid)+1);
        GivePlayerMoney(killerid,GetPlayerMoney(killerid)+700);
        GameTextForPlayer(killerid,"~r~+$700~n~~b~+1~w~Score",3000,4);
    	}
    	if(Vip[playerid] == 2) {
    	VipCar[playerid] = 0;
        SendDeathMessage(killerid,playerid,reason);
        SendClientMessage(killerid, COLOR_YELLOW2, "You are (Level 2 VIP , you win +1score and +900$! ");
        SetPlayerScore(killerid,GetPlayerScore(killerid)+1);
        GivePlayerMoney(killerid,GetPlayerMoney(killerid)+900);
        GameTextForPlayer(killerid,"~r~+$900~n~~b~+1~w~Score",3000,4);
    	}
    	if(Vip[playerid] == 3) {
    	VipCar[playerid] = 0;
        SendDeathMessage(killerid,playerid,reason);
        SendClientMessage(killerid, COLOR_NICERED, "You are (Level 3 VIP) , you win +1score and +1000$ ! ");
        SetPlayerScore(killerid,GetPlayerScore(killerid)+1);
        GivePlayerMoney(killerid,GetPlayerMoney(killerid)+1000);
        GameTextForPlayer(killerid,"~r~+$1000~n~~b~+1~w~Score",3000,4);
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

public OnGameModeInit()
{
    b1 = CreateObject(19332, 364.71, 2537.19, 15.68,   0.00, 0.00, 0.00);
	b2 = CreateObject(19333, 154.77, -1858.23, 2.78,   0.00, 0.00, 0.00);
	b3 = CreateObject(19334, -1748.00, -154.60, 2.60,   0.00, 0.00, 0.00);
	
	CreateDynamicObject(18751,4802.12,-4921.35,4.16,0.00,0.00,0.00);
	CreateDynamicObject(18751,4746.04,-4921.95,4.16,0.00,0.00,0.00);
	CreateDynamicObject(18751,4746.04,-4875.93,3.81,0.00,0.00,0.00);
	CreateDynamicObject(18751,4800.19,-4872.35,3.81,0.00,0.00,0.00);
	CreateDynamicObject(18750,4702.36,-4904.54,48.72,89.49,0.00,91.75);
	CreateDynamicObject(710,4722.75,-4864.69,22.20,0.00,0.00,0.00);
	CreateDynamicObject(710,4827.72,-4851.19,22.22,0.00,0.00,0.00);
	CreateDynamicObject(710,4829.30,-4950.55,21.85,0.00,0.00,0.00);
	CreateDynamicObject(710,4721.45,-4951.63,21.57,0.00,0.00,0.00);
	CreateDynamicObject(710,4709.59,-4931.41,20.32,0.00,0.00,0.00);
	CreateDynamicObject(710,4713.84,-4904.80,21.07,0.00,0.00,0.00);
	CreateDynamicObject(710,4753.89,-4944.07,23.03,0.00,0.00,0.00);
	CreateDynamicObject(710,4773.88,-4955.72,22.53,0.00,0.00,0.00);
	CreateDynamicObject(710,4791.16,-4944.48,22.28,0.00,0.00,0.00);
	CreateDynamicObject(710,4808.41,-4954.20,20.53,0.00,0.00,0.00);
	CreateDynamicObject(710,4822.39,-4930.03,23.03,0.00,0.00,0.00);
	CreateDynamicObject(710,4816.12,-4915.56,25.03,0.00,0.00,0.00);
	CreateDynamicObject(710,4804.01,-4896.12,22.78,0.00,0.00,0.00);
	CreateDynamicObject(710,4786.81,-4911.10,29.78,0.00,0.00,0.00);
	CreateDynamicObject(710,4774.98,-4922.33,21.28,0.00,0.00,0.00);
	CreateDynamicObject(710,4768.61,-4891.08,20.78,0.00,0.00,0.00);
	CreateDynamicObject(710,4747.54,-4873.75,20.53,0.00,0.00,0.00);
	CreateDynamicObject(710,4754.10,-4855.72,20.03,0.00,0.00,0.00);
	CreateDynamicObject(710,4775.39,-4852.38,20.03,0.00,0.00,0.00);
	CreateDynamicObject(710,4795.67,-4865.55,23.53,0.00,0.00,0.00);
	CreateDynamicObject(710,4819.15,-4878.53,22.78,0.00,0.00,0.00);
	CreateDynamicObject(710,4804.49,-4843.81,20.28,0.00,0.00,0.00);
	CreateDynamicObject(710,4739.19,-4906.89,22.03,0.00,0.00,0.00);
	CreateDynamicObject(710,4732.04,-4849.78,20.78,0.00,0.00,0.00);
	CreateDynamicObject(14560,4785.57,-4901.21,13.14,0.24,1.24,0.49);
	CreateDynamicObject(18751,4784.10,-4896.81,2.81,0.00,0.00,0.00);
	CreateDynamicObject(18751,4787.82,-4891.87,2.81,0.00,0.00,0.00);
	CreateDynamicObject(18751,4787.84,-4903.91,2.44,0.00,0.00,0.00);
	CreateDynamicObject(710,4786.62,-4891.45,29.78,0.00,0.00,0.00);
	CreateDynamicObject(4874,4803.51,-4790.33,5.26,0.00,0.00,274.00);
	CreateDynamicObject(710,4845.21,-4907.10,17.35,0.00,0.00,0.00);
	CreateDynamicObject(710,4842.04,-4943.09,19.85,0.00,0.00,0.00);
	CreateDynamicObject(710,4826.54,-4969.58,17.85,0.00,0.00,0.00);
	CreateDynamicObject(710,4788.97,-4962.02,19.35,0.00,0.00,0.00);
	CreateDynamicObject(710,4743.65,-4964.55,18.60,0.00,0.00,0.00);
	CreateDynamicObject(710,4838.56,-4872.83,18.60,0.00,0.00,0.00);
	CreateDynamicObject(710,4838.14,-4834.81,17.10,0.00,0.00,0.00);
	CreateDynamicObject(710,4802.21,-4826.24,15.85,0.00,0.00,0.00);
	CreateDynamicObject(710,4773.89,-4833.88,18.35,0.00,0.00,0.00);
	CreateDynamicObject(710,4737.66,-4829.94,15.60,0.00,0.00,0.00);
	CreateDynamicObject(710,4715.45,-4838.33,18.35,0.00,0.00,0.00);
	CreateDynamicObject(710,4705.28,-4872.88,17.85,0.00,0.00,0.00);
	CreateDynamicObject(1646,4837.52,-4857.08,5.28,19.75,0.00,94.75);
	CreateDynamicObject(1646,4837.37,-4855.62,5.26,19.74,0.00,94.74);
	CreateDynamicObject(1646,4837.41,-4854.17,5.31,19.74,0.00,94.74);
	CreateDynamicObject(1646,4837.43,-4852.56,5.38,19.74,0.00,94.74);
	CreateDynamicObject(1646,4837.53,-4851.11,5.48,20.21,356.53,94.94);
	CreateDynamicObject(1255,4809.30,-4885.92,10.08,0.00,0.00,0.00);
	CreateDynamicObject(1255,4809.12,-4884.04,10.01,0.00,0.00,0.00);
	CreateDynamicObject(1255,4809.14,-4882.06,9.96,0.00,0.00,0.00);
	CreateDynamicObject(1255,4809.11,-4880.41,9.91,0.00,0.00,0.00);
	CreateDynamicObject(3580,4809.47,-4931.61,13.76,0.00,0.00,42.00);
	CreateDynamicObject(18751,4746.04,-4875.93,4.06,0.00,0.00,0.00);
	CreateDynamicObject(3580,4746.13,-4924.64,13.88,0.00,0.00,302.00);
	CreateDynamicObject(3580,4729.37,-4858.95,10.66,0.00,0.00,249.99);
	CreateDynamicObject(1281,4780.41,-4887.51,9.33,349.75,0.25,0.04);
	CreateDynamicObject(1281,4785.40,-4886.42,9.20,349.74,0.25,0.04);
	CreateDynamicObject(1281,4792.80,-4893.72,9.55,359.49,0.74,0.00);
	CreateDynamicObject(1281,4793.53,-4899.43,9.50,359.49,0.74,0.00);
	CreateDynamicObject(1281,4793.45,-4905.58,9.43,359.49,0.74,0.00);
	CreateDynamicObject(1281,4785.20,-4915.99,9.25,359.49,0.74,0.00);
	CreateDynamicObject(1281,4778.56,-4911.86,9.13,1.98,5.00,273.82);
	CreateDynamicObject(1281,4778.03,-4907.11,9.38,7.21,5.03,273.36);
	CreateDynamicObject(1281,4777.69,-4900.51,9.28,7.21,5.03,273.36);
	CreateDynamicObject(1281,4778.50,-4893.69,9.20,1.98,4.99,273.82);
	CreateDynamicObject(1432,4795.00,-4913.63,9.16,354.00,0.00,0.00);
	CreateDynamicObject(1432,4791.74,-4909.15,8.66,3.99,2.00,354.11);
	CreateDynamicObject(1432,4791.61,-4890.28,8.91,356.24,0.00,0.00);
	CreateDynamicObject(14565,4785.64,-4901.48,10.66,0.00,5.00,0.25);
	CreateDynamicObject(946,4819.88,-4880.03,9.86,0.00,0.00,197.74);
	CreateDynamicObject(2114,4821.57,-4882.58,8.08,0.00,0.00,0.00);
	CreateDynamicObject(1598,4825.22,-4887.57,7.68,0.00,0.00,0.00);
	CreateDynamicObject(1598,4829.93,-4882.34,7.26,0.00,0.00,0.00);
	CreateDynamicObject(1598,4825.56,-4881.07,7.61,0.00,0.00,0.00);
	CreateDynamicObject(1598,4829.38,-4875.27,6.73,0.00,0.00,0.00);
	CreateDynamicObject(1598,4829.38,-4875.27,6.73,0.00,0.00,0.00);
	CreateDynamicObject(1598,4826.97,-4864.50,7.03,0.00,0.00,0.00);
	CreateDynamicObject(1598,4825.73,-4871.18,6.71,0.00,0.00,0.00);
	CreateDynamicObject(1598,4831.18,-4868.26,6.38,0.00,0.00,0.00);
	CreateDynamicObject(1598,4823.17,-4877.67,7.36,0.00,0.00,0.00);
	CreateDynamicObject(1461,4809.54,-4826.20,3.21,0.00,0.00,268.25);
	CreateDynamicObject(1461,4809.56,-4823.18,2.61,0.00,0.00,268.24);
	CreateDynamicObject(1609,4838.91,-4842.81,5.41,338.75,0.00,260.00);
	CreateDynamicObject(1610,4837.83,-4859.91,5.03,0.00,0.00,0.00);
	CreateDynamicObject(1637,4742.40,-4890.95,10.74,0.00,0.00,0.00);
	CreateDynamicObject(1637,4837.01,-4893.87,6.92,0.00,0.00,0.00);
	CreateDynamicObject(2406,4838.87,-4871.88,5.93,0.00,0.00,158.50);
	CreateDynamicObject(6295,4752.43,-5068.51,26.16,0.00,0.00,0.00);
	CreateDynamicObject(11495,4753.54,-4978.19,2.40,0.00,0.00,0.00);
	CreateDynamicObject(11495,4753.55,-4999.38,2.40,0.00,0.00,0.00);
	CreateDynamicObject(11495,4753.47,-5021.11,2.40,0.00,0.00,0.00);
	CreateDynamicObject(18751,4751.38,-5061.14,-3.02,0.00,0.00,0.00);
	CreateDynamicObject(11495,4753.47,-5043.03,2.40,0.00,0.00,0.00);
	CreateDynamicObject(9958,4641.37,-4897.12,6.90,0.00,0.00,1.00);
	CreateDynamicObject(710,4726.46,-5085.42,16.07,0.00,0.00,0.00);
	CreateDynamicObject(710,4728.82,-5039.80,15.60,0.00,0.00,0.00);
	CreateDynamicObject(710,4780.74,-5096.28,15.00,0.00,0.00,0.00);
	CreateDynamicObject(710,4776.91,-5046.60,14.65,0.00,0.00,0.00);
	CreateDynamicObject(710,4707.08,-4968.39,17.85,0.00,0.00,0.00);
	CreateDynamicObject(1608,4754.58,-5102.19,-0.72,0.00,0.00,64.00);
	CreateDynamicObject(1608,4741.65,-5104.36,-0.72,0.00,0.00,315.99);
	CreateDynamicObject(1607,4796.21,-5056.94,0.00,0.00,0.00,0.00);
	CreateDynamicObject(1637,4779.46,-5088.95,1.39,0.00,0.00,92.00);
	CreateDynamicObject(9237,4766.22,-4844.98,12.69,0.00,0.00,110.00);
	CreateDynamicObject(902,4847.81,-4879.33,1.80,0.00,22.25,0.00);
	CreateDynamicObject(1481,4745.98,-4874.70,10.73,0.00,0.00,355.00);
	CreateDynamicObject(1481,4746.93,-4875.15,10.73,0.00,0.00,314.99);
	CreateDynamicObject(1481,4744.98,-4874.86,10.73,0.00,0.00,22.99);
	CreateDynamicObject(11495,4744.94,-4819.69,1.62,0.00,0.00,12.00);
	CreateDynamicObject(11495,4740.79,-4800.04,7.37,32.25,0.00,11.99);
	CreateDynamicObject(11495,4739.54,-4794.23,11.15,34.74,0.00,11.99);

	ob1 = CreateObject(1006,0,0,-1000,0,0,0,100);
 	ob2 = CreateObject(1161,0,0,-1000,0,0,0,100);
 	ob3 = CreateObject(1161,0,0,-1000,0,0,0,100);
 	ob4 = CreateObject(1059,0,0,-1000,0,0,0,100);
 	ob5 = CreateObject(1146,0,0,-1000,0,0,0,100);
 	ob6 = CreateObject(1006,0,0,-1000,0,0,0,100);
	ob7 = CreateObject(1146,0,0,-1000,0,0,0,100);
 	ob8 = CreateObject(1006,0,0,-1000,0,0,0,100);
  	ob9 = CreateObject(1006,0,0,-1000,0,0,0,100);
 	ob10 = CreateObject(1006,0,0,-1000,0,0,0,100);
  	ob11 = CreateObject(1027,0,0,-1000,0,0,0,100);
  	ob12 = CreateObject(1027,0,0,-1000,0,0,0,100);
    ob13 = CreateObject(1146,0,0,-1000,0,0,0,100);
    ob14 = CreateObject(1003,0,0,-1000,0,0,0,100);
    ob15 = CreateObject(1018,0,0,-1000,0,0,0,100);
    ob16 = CreateObject(1149,0,0,-1000,0,0,0,100);
    ob17 = CreateObject(1018,0,0,-1000,0,0,0,100);
    ob18 = CreateObject(1006,0,0,-1000,0,0,0,100);
    ob19 = CreateObject(1166,0,0,-1000,0,0,0,100);
    ob20 = CreateObject(1006,0,0,-1000,0,0,0,100);
    ob21 = CreateObject(1026,0,0,-1000,0,0,0,100);
    ob22 = CreateObject(1027,0,0,-1000,0,0,0,100);
     
	Textdraw0 = TextDrawCreate(4.000000, 160.000000, "Would u like to have Pirate Ship?? ~n~~n~~n~/Yes if u want to ~n~/No if you dont want to!~n~/Hidebox To Hide This Box");
	TextDrawBackgroundColor(Textdraw0, 255);
	TextDrawFont(Textdraw0, 1);
	TextDrawLetterSize(Textdraw0, 0.230000, 1.000000);
	TextDrawColor(Textdraw0, -1);
	TextDrawSetOutline(Textdraw0, 0);
	TextDrawSetProportional(Textdraw0, 1);
	TextDrawSetShadow(Textdraw0, 1);
	TextDrawUseBox(Textdraw0, 1);
	TextDrawBoxColor(Textdraw0, 0x00000033);
	TextDrawTextSize(Textdraw0, 137.000000, -1.000000);
	o = CreateObject(8493,0,0,-1000,0,0,0,100);
}

public OnPlayerExitVehicle(playerid, vehicleid)//OnExitingTheVehicle :p
{
    if (tune[playerid] == 1)
    {
  	 o = CreateObject(1006,0,0,-1000,0,0,0,100);
	 ob2 = CreateObject(1161,0,0,-1000,0,0,0,100);
	 ob3 = CreateObject(1161,0,0,-1000,0,0,0,100);
	 ob4 = CreateObject(1059,0,0,-1000,0,0,0,100);
	 ob5 = CreateObject(1146,0,0,-1000,0,0,0,100);
	 ob6 = CreateObject(1006,0,0,-1000,0,0,0,100);
  	 ob7 = CreateObject(1146,0,0,-1000,0,0,0,100);
  	 ob8 = CreateObject(1006,0,0,-1000,0,0,0,100);
  	 ob9 = CreateObject(1006,0,0,-1000,0,0,0,100);
  	 ob10 = CreateObject(1006,0,0,-1000,0,0,0,100);
  	 ob11 = CreateObject(1027,0,0,-1000,0,0,0,100);
  	 ob12 = CreateObject(1027,0,0,-1000,0,0,0,100);
  	 ob13 = CreateObject(1146,0,0,-1000,0,0,0,100);
  	 ob14 = CreateObject(1003,0,0,-1000,0,0,0,100);
  	 ob15 = CreateObject(1018,0,0,-1000,0,0,0,100);
     ob16 = CreateObject(1149,0,0,-1000,0,0,0,100);
     ob17 = CreateObject(1018,0,0,-1000,0,0,0,100);
     ob18 = CreateObject(1006,0,0,-1000,0,0,0,100);
     ob19 = CreateObject(1166,0,0,-1000,0,0,0,100);
     ob20 = CreateObject(1006,0,0,-1000,0,0,0,100);
     ob21 = CreateObject(1026,0,0,-1000,0,0,0,100);
     ob22 = CreateObject(1027,0,0,-1000,0,0,0,100);
     tune[playerid] = 0;
    }
    TextDrawHideForPlayer(playerid,Textdraw0);
	if (ship[playerid] == 1)
    {
  	DestroyObject(o);
  	ship[playerid] = 0;
    }
}
stock SpawnVeh(vehicleid, playerid)
{
    if(SpawnedVeh[playerid] != 0)
    {
        DestroyVehicle(SpawnedVeh[playerid]);
    }
    new Float:X, Float:Y, Float:Z, Float:Angle;
    GetPlayerPos(playerid, Float:X, Float:Y, Float:Z);
    GetPlayerFacingAngle(playerid, Float:Angle);
    SpawnedVeh[playerid] = CreateVehicle(vehicleid, X, Y, Z + 2.0, Angle + 90.0, -1, -1, 600);
    SetVehicleVirtualWorld(SpawnedVeh[playerid], GetPlayerVirtualWorld(playerid));
    LinkVehicleToInterior(SpawnedVeh[playerid], GetPlayerInterior(playerid));
    PutPlayerInVehicle(playerid, SpawnedVeh[playerid], 0);
}
public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)// If the player's state changes to a vehicle state we'll have to spec the vehicle.
    {
        if(IsBeingSpeced[playerid] == 1)//If the player being spectated, enters a vehicle, then let the spectator spectate the vehicle.
        {
            foreach(Player,i)
            {
                if(spectatorid[i] == playerid)
                {
                    PlayerSpectateVehicle(i, GetPlayerVehicleID(playerid));// Letting the spectator, spectate the vehicle of the player being spectated (I hope you understand this xD)
                }
            }
        }
    }
    if(newstate == PLAYER_STATE_ONFOOT)
    {
        if(IsBeingSpeced[playerid] == 1)//If the player being spectated, exists a vehicle, then let the spectator spectate the player.
        {
            foreach(Player,i)
            {
                if(spectatorid[i] == playerid)
                {
                    PlayerSpectatePlayer(i, playerid);// Letting the spectator, spectate the player who exited the vehicle.
                }
            }
        }
    }
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
	for(new playerid = 0; playerid < MAX_PLAYERS; ++playerid)
	{
	    if(objectid == Javelin[playerid][0])
	    {
	        if(Javelin[playerid][1] == 1)
	        {
	            MoveObject(Javelin[playerid][0], JavPos[playerid][0], JavPos[playerid][1], JavPos[playerid][2], 50.0);
	            Javelin[playerid][1] = 2;
	            goto skip;
	        }
			if(Javelin[playerid][1] == 2)
			{
				DestroyObject(Javelin[playerid][0]);
				CreateExplosion(JavPos[playerid][0], JavPos[playerid][1], JavPos[playerid][2], 7, 15.0);
				CreateExplosion(JavPos[playerid][0], JavPos[playerid][1], JavPos[playerid][2] + 5.0, 7, 15.0);
				CreateExplosion(JavPos[playerid][0] + 7.5, JavPos[playerid][1], JavPos[playerid][2], 7, 15.0);
				CreateExplosion(JavPos[playerid][0] - 7.5, JavPos[playerid][1], JavPos[playerid][2], 7, 15.0);
				CreateExplosion(JavPos[playerid][0], JavPos[playerid][1] + 7.5, JavPos[playerid][2], 7, 15.0);
				CreateExplosion(JavPos[playerid][0], JavPos[playerid][1] - 7.5, JavPos[playerid][2], 7, 15.0);
			    Javelin[playerid][1] = 0;
			    JavPos[playerid][0] = 0.0;
			    JavPos[playerid][1] = 0.0;
			    JavPos[playerid][2] = 0.0;
			}
	    }
		skip:
	}
	return 0;
}
public Float:SetPlayerToFacePos(playerid, Float:X, Float:Y)
{
	new
		Float:pX,
		Float:pY,
		Float:pZ,
		Float:ang;

	if(!IsPlayerConnected(playerid)) return 0.0;

	GetPlayerPos(playerid, pX, pY, pZ);

	if( Y > pY ) ang = (-acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
	else if( Y < pY && X < pX ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 450.0);
	else if( Y < pY ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);

	if(X > pX) ang = (floatabs(floatabs(ang) + 180.0));
	else ang = (floatabs(ang) - 180.0);

	ang += 180.0;

	SetPlayerFacingAngle(playerid, ang);

 	return ang;
}

stock IsPlayerFacingPlayer(playerid, targetid, Float:dOffset)
{
	new
		Float:pX,
		Float:pY,
		Float:pZ,
		Float:pA,
		Float:X,
		Float:Y,
		Float:Z,
		Float:ang;

	if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return 0;

	GetPlayerPos(targetid, pX, pY, pZ);
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, pA);

	if( Y > pY ) ang = (-acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
	else if( Y < pY && X < pX ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 450.0);
	else if( Y < pY ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);

	return AngleInRangeOfAngle(-ang, pA, dOffset);
}

stock AngleInRangeOfAngle(Float:a1, Float:a2, Float:range)
{
	a1 -= a2;
	if((a1 < range) && (a1 > -range)) return true;

	return false;
}

public GetClosestPlayer(p1)
{
	new
		x,
		Float:dis,
		Float:dis2,
		player;

	player = -1;
	dis = 99999.99;

	for (x=0;x<MAX_PLAYERS;x++)
		if(IsPlayerConnected(x))
			if(x != p1)
			{
				dis2 = GetDistanceBetweenPlayers(x,p1);
				if(dis2 < dis && dis2 != -1.00)
				{
					dis = dis2;
					player = x;
				}
			}

	return player;
}
public Float:GetDistanceBetweenPlayers(p1, p2)
{
	new
		Float:x1,
		Float:y1,
		Float:z1,
		Float:x2,
		Float:y2,
		Float:z2;

	if(!IsPlayerConnected(p1) || !IsPlayerConnected(p2))
		return -1.00;

	GetPlayerPos(p1,x1,y1,z1);
	GetPlayerPos(p2,x2,y2,z2);

	return floatsqroot(
		floatpower(floatabs(floatsub(x2,x1)), 2)
		+ floatpower(floatabs(floatsub(y2,y1)), 2)
		+ floatpower(floatabs(floatsub(z2,z1)), 2));
}


public OnPlayerObjectMoved(playerid, objectid)
{
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


public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)//This is called when a player's interior is changed.
{
    if(IsBeingSpeced[playerid] == 1)//If the player being spectated, changes an interior, then update the interior and virtualword for the spectator.
    {
        foreach(Player,i)
        {
            if(spectatorid[i] == playerid)
            {
                SetPlayerInterior(i,GetPlayerInterior(playerid));
                SetPlayerVirtualWorld(i,GetPlayerVirtualWorld(playerid));
            }
        }
    }
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



public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
    return 1;
}
CMD:vips(playerid, params[])
{
    #pragma unused params
    new
        count = 0,
        string[800];
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if (IsPlayerConnected(i))
        {
            if (Vip[playerid] >= 1)
            {
                format(string, 500, "%s %s [ID:%i] | VIP Level: %d\n", string, PlayerName(i), i, Vip[playerid]);
                count++;
            }
        }
	}
    if (count == 0) ShowPlayerDialog(playerid, 800, DIALOG_STYLE_MSGBOX, "{F81414}Online V.I.Ps", "{00FFEE}No V.I.Ps Online", "Close", "");
    else ShowPlayerDialog(playerid, 800, DIALOG_STYLE_MSGBOX, "{F81414}Online V.I.Ps", string, "Close", "");
    return 1;
}
CMD:vannounce(playerid,params[])
{
    if (Vip[playerid] >= 3)
		{
    	if(isnull(params)) return SendClientMessage(playerid,red,"USAGE: /vannounce <text>");
    	xVip(playerid,"VANNOUNCE");
		return GameTextForAll(params,4000,3);
}
    return 1;
}
CMD:vdick( playerid, params[] )
	{
	if (Vip[playerid] >= 2)
	{
 	SetPlayerAttachedObject(playerid, 1, 19086, 8, -0.049768, -0.014062, -0.108385, 87.458297, 263.478149, 184.123764, 0.622413, 1.041609, 1.012785 ); // ChainsawDildo1 - lolatdick
    SendClientMessage(playerid, -1,"Dick Attached ");
    xVip(playerid,"VDICK");
	}
	return 1;
	}
	CMD:vgod( playerid, params[] )
	{
	if (Vip[playerid] >= 2)
	{
	SetPlayerHealth(playerid,100000);
    SendClientMessage(playerid, -1,"God Enabled");
    xVip(playerid,"VGOD");
	}
	return 1;
	}
	CMD:vjetpack( playerid, params[] )
	{
	if (Vip[playerid] >= 2)
	{
	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USEJETPACK);
    xVip(playerid,"VJETPACK");
	}
	return 1;
	}
CMD:vspec(playerid, params[])
{
    if (Vip[playerid] >= 2)
	{
    new id;
    if(!IsPlayerAdmin(playerid))return 0;
    if(sscanf(params,"u", id))return SendClientMessage(playerid, Grey, "Usage: /vspec [id]");
    if(id == playerid)return SendClientMessage(playerid,Grey,"You cannot spec yourself.");
    if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, Grey, "Player not found!");
    if(IsSpecing[playerid] == 1)return SendClientMessage(playerid,Grey,"You are already specing someone.");
    GetPlayerPos(playerid,SpecX[playerid],SpecY[playerid],SpecZ[playerid]);
    Inter[playerid] = GetPlayerInterior(playerid);
    vWorld[playerid] = GetPlayerVirtualWorld(playerid);
    TogglePlayerSpectating(playerid, true);
    xVip(playerid,"VSPEC");
    if(IsPlayerInAnyVehicle(id))
    {
        if(GetPlayerInterior(id) > 0)
        {
            SetPlayerInterior(playerid,GetPlayerInterior(id));
        }
        if(GetPlayerVirtualWorld(id) > 0)
        {
            SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(id));
        }
        PlayerSpectateVehicle(playerid,GetPlayerVehicleID(id));
    }
    else
    {
        if(GetPlayerInterior(id) > 0)
        {
            SetPlayerInterior(playerid,GetPlayerInterior(id));
        }
        if(GetPlayerVirtualWorld(id) > 0)
        {
            SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(id));
        }
        PlayerSpectatePlayer(playerid,id);
    }
    GetPlayerName(id, Name, sizeof(Name));
    format(String, sizeof(String),"You have started to spectate %s.",Name);
    SendClientMessage(playerid,0x0080C0FF,String);
    IsSpecing[playerid] = 1;
    IsBeingSpeced[id] = 1;
    spectatorid[playerid] = id;
}
    return 1;
}
CMD:ballooncmds(playerid, params[])
{
 	#define DIALOG_B 2
    if (Vip[playerid] >= 1)
	{
	    ShowPlayerDialog(playerid, DIALOG_B, DIALOG_STYLE_MSGBOX, "Balloon Commands", "/rballoon red balloon\n/bballon blue balloon\n/gballon grey balloon\n/rup - Red balloon Up, /rdown - Red Balloon Down\n/bup - Blue balloon Up, /bdown - Blue Balloon Down\n/gup - Grey balloon Up, /gdown - Grey Balloon Down", "Close", "");
	}
	return 1;
}
CMD:rballoon(playerid, params[])
{
    if (Vip[playerid] >= 1)
	{
	SetPlayerPos(playerid,382.0658, 2537.5269, 15.6774);
 	SendClientMessage(playerid, 0xDEEE20FF, "Welcome to Red Balloon");
 	xVip(playerid,"RBALLOON");
	}
	return 1;
}
CMD:bballoon(playerid, params[])
{
    if (Vip[playerid] >= 1)
	{
	SetPlayerPos(playerid,153.8562, -1879.2620, 2.7823);
 	SendClientMessage(playerid, 0xDEEE20FF, "Welcome to Blue Balloon");
 	xVip(playerid,"BBALLOON");
	}
	return 1;
}
CMD:gballoon(playerid, params[])
{
    if (Vip[playerid] >= 1)
	{
	SetPlayerPos(playerid,-1738.4253, -137.0162, 2.6011);
 	SendClientMessage(playerid, 0xDEEE20FF, "Welcome to Grey Balloon");
 	xVip(playerid,"GBALLOON");
	}
	return 1;
}
CMD:rup(playerid, params[])
{
    if (Vip[playerid] >= 1)
	{
	MoveObject(b1, 237.11, 2547.02, 354.68, 3);
 	SendClientMessage(playerid, 0xDEEE20FF, "Going!");
 	xVip(playerid,"RUP");
	}
	return 1;
}
CMD:bup(playerid, params[])
{
    if (Vip[playerid] >= 1)
	{
	MoveObject(b2, 455.3196, -1870.2194, 824.6305, 3);
 	SendClientMessage(playerid, 0xDEEE20FF, "Going!");
 	xVip(playerid,"BUP");
	}
	return 1;
}
CMD:gup(playerid, params[])
{
    if (Vip[playerid] >= 1)
	{
	MoveObject(b3,-1752.5271, -8.4947, 282.0090, 3);
 	SendClientMessage(playerid, 0xDEEE20FF, "Going!");
 	xVip(playerid,"GUP");
	}
	return 1;
}
CMD:rdown(playerid, params[])
{
    if (Vip[playerid] >= 1)
	{
	MoveObject(b1, 365.56, 2537.17, 15.68, 5);
  	SendClientMessage(playerid, 0xDEEE20FF, "Going Down!");
 	xVip(playerid,"RDOWN");
	}
	return 1;
}
CMD:bdown(playerid, params[])
{
    if (Vip[playerid] >= 1)
	{
	MoveObject(b2, 154.7741, -1858.2334, 2.7823 , 5);
 	SendClientMessage(playerid, 0xDEEE20FF, "Going Down!");
 	xVip(playerid,"BDOWN");
	}
	return 1;
}
CMD:gdown(playerid, params[])
{
    if (Vip[playerid] >= 1)
	{
	MoveObject(b3, -1748.0038, -154.6030, 2.6011, 5);
 	SendClientMessage(playerid, 0xDEEE20FF, "Going Down!");
 	xVip(playerid,"GDOWN");
	}
	return 1;
}
CMD:vspecoff(playerid, params[])
{
    if (Vip[playerid] >= 2)
	{
    if(IsSpecing[playerid] == 0)return SendClientMessage(playerid,Grey,"You are not spectating anyone.");
    TogglePlayerSpectating(playerid, 0);
    xVip(playerid,"VSPECOFF");
	}
	return 1;
}
CMD:vloadpos(playerid, params[])
{
	if (Vip[playerid] >= 2)
	{
    if(gPlayerData[playerid][E_SET] == true)
    {
        SetPlayerLastPos(playerid);
        xVip(playerid,"VLOADPOS");
    } else return SendClientMessage(playerid, 0xFFFFFFFF, "Not set!");
	}
    return 1;
}

CMD:vsavepos(playerid, params[])
{
	if (Vip[playerid] >= 2)
	{
    GetPlayerLastPos(playerid);
    xVip(playerid,"VSASVEPOS");
    SendClientMessage(playerid, 0xFFFFFFFF, "Position set! Use /vloadpos to go to that pos!");
    gPlayerData[playerid][E_SET] = true;
    }
    return 1;
}
//CARSSSSSSSSSSSSSSSSSSSSSSSSS :D
CMD:untune(playerid, params[])
{
if (Vip[playerid] >= 1)
{
if(tune[playerid] == 1)
{
RemovePlayerFromVehicle(playerid);
DestroyObject(o);
DestroyObject(ob1 );
DestroyObject(ob2 );
DestroyObject(ob3);
DestroyObject(ob4);
DestroyObject(ob5);
DestroyObject(ob6);
DestroyObject(ob7);
DestroyObject(ob8);
DestroyObject(ob9);
DestroyObject(ob10);
DestroyObject(ob11);
DestroyObject(ob12);
DestroyObject(ob13);
DestroyObject(ob14);
DestroyObject(ob15);
DestroyObject(ob16);
DestroyObject(ob17);
DestroyObject(ob18);
DestroyObject(ob19);
DestroyObject(ob20);
DestroyObject(ob21);
DestroyObject(ob22);
xVip(playerid,"UNTUNE");
SendClientMessage(playerid,-1,"SERVER:Untuned Sucessfully !");
}
else
if(tune[playerid] == 0)
{
SendClientMessage(playerid,-1,"SERVER:Your vehicle is not tuned!");
}
}
return 1;
}
CMD:vtune(playerid, params[])
{
if (Vip[playerid] >= 1)
{
new vehicleid = GetPlayerVehicleID(playerid);
if(GetVehicleModel(vehicleid) == 411) // 411 is the infernus model
{
tune[playerid] = 1;
AttachObjectToVehicle(o, GetPlayerVehicleID(playerid), -0.300000,0.000000,0.675000,0.000000,0.000000,0.000000);
AttachObjectToVehicle(ob2, GetPlayerVehicleID(playerid), 1.049999,2.174999,-0.599999,0.000005,180.899887,180.899963);
AttachObjectToVehicle(ob3, GetPlayerVehicleID(playerid), -1.049999,-1.950001,-0.599999,0.000005,180.899887,361.799743);
AttachObjectToVehicle(ob4, GetPlayerVehicleID(playerid), 0.000000,0.000000,0.000000,0.000000,0.000000,0.000000);
AttachObjectToVehicle(ob5, GetPlayerVehicleID(playerid), -0.074999,-2.325000,0.375000,0.000000,0.000000,0.000000);
AttachObjectToVehicle(ob6, GetPlayerVehicleID(playerid), 0.225000,0.000000,0.674999,0.000000,0.000000,0.000000);
AttachObjectToVehicle(ob7, GetPlayerVehicleID(playerid), -0.074999,-2.325000,0.524999,0.000000,0.000000,0.000000);
AttachObjectToVehicle(ob8, GetPlayerVehicleID(playerid), 0.000000,1.800000,0.149999,0.000000,0.000000,0.000000);
AttachObjectToVehicle(ob9, GetPlayerVehicleID(playerid), 0.000000,1.650000,0.150000,0.000000,0.000000,0.000000);
AttachObjectToVehicle(ob10, GetPlayerVehicleID(playerid), 0.000000,1.950000,0.150000,-10.800001,0.000000,0.000000);
AttachObjectToVehicle(ob11, GetPlayerVehicleID(playerid), -1.049999,-0.824999,-0.599999,0.000000,0.000000,0.000000);
AttachObjectToVehicle(ob12, GetPlayerVehicleID(playerid), 0.974999,-0.824999,-0.599999,0.000000,0.000000,0.000000);
AttachObjectToVehicle(ob13, GetPlayerVehicleID(playerid), -0.074999,-2.325000,0.449999,0.000000,0.000000,0.000000);
AddVehicleComponent(vehicleid, 1079);
ChangeVehicleColor(vehicleid,0,0);
xVip(playerid,"VTUNE");
SendClientMessage(playerid, 0xDEEE20FF, "Your Infernes is now Tuned!");
}
else
if(GetVehicleModel(vehicleid) == 541) // 541 is the Bullet model
{
tune[playerid] = 1;
AttachObjectToVehicle(ob14, GetPlayerVehicleID(playerid), 0.000000,-2.025000,0.300000,0.000000,0.000000,0.000000);
AttachObjectToVehicle(ob15, GetPlayerVehicleID(playerid), -0.375000,-1.275000,-0.375000,0.000000,0.000000,0.000000);
AttachObjectToVehicle(ob16, GetPlayerVehicleID(playerid), 1.049999,-1.500000,0.075000,0.000000,0.000000,0.000000);
AttachObjectToVehicle(ob17, GetPlayerVehicleID(playerid), 0.374999,-1.275000,-0.375000,0.000000,0.000000,0.000000);
AttachObjectToVehicle(ob18, GetPlayerVehicleID(playerid), 0.000000,0.224999,0.600000,0.000000,0.000000,0.000000);
AttachObjectToVehicle(ob19, GetPlayerVehicleID(playerid), 1.049999,1.575000,0.000000,0.000000,0.000000,0.000000);
AttachObjectToVehicle(ob20, GetPlayerVehicleID(playerid), -0.075000,1.200000,0.300000,0.000000,0.000000,0.000000);
AttachObjectToVehicle(ob21, GetPlayerVehicleID(playerid), 1.049999,-0.899999,-0.375000,0.000000,0.000000,0.000000);
AttachObjectToVehicle(ob22, GetPlayerVehicleID(playerid), -1.049999,-0.974999,-0.449999,0.000000,0.000000,0.000000);
AddVehicleComponent(vehicleid, 1079);
ChangeVehicleColor(vehicleid,0,0);
xVip(playerid,"VTUNE");
SendClientMessage(playerid, 0xDEEE20FF, "Your Bullet is now Tuned!");
}
else
{
tune[playerid] = 0;
SendClientMessage(playerid,-1,"SERVER:You need to be in infernus or bullet to use this command.");
}
}
return 1;
}
CMD:vtunecmds(playerid, params[])
{
	#define tu 2
	if (Vip[playerid] >= 1)
	{
	ShowPlayerDialog(playerid, tu, DIALOG_STYLE_MSGBOX, "Vehicle Tune Commands", "/vtune - To Tune the Car!!\n/untune - To Untune the Car\n\n\nNOTE: The Car Should be Infernus or Bullet Only", "Close", "");
    }
    return 1;
}
CMD:visland(playerid, params[])
{
	if (Vip[playerid] >= 2)
	{
	SetPlayerInterior(playerid,0);
	xVip(playerid,"VISLAND");
	SetPlayerPos(playerid,4741.7563476563,-4899.0366210938,8.4952936172485);
	SendClientMessage(playerid, COLOR_YELLOW,"Welcome to VIP Island, By Speederx");
    }
    return 1;
}
//=========================================
//SHIP!!!!!!!!!!!!!!!
CMD:piratecmds(playerid, params[])
{
    #define DIALOG_P 2
	if (Vip[playerid] >= 1)
	{
	ShowPlayerDialog(playerid, DIALOG_P, DIALOG_STYLE_MSGBOX, "Pirate Ship Commands!", "/VPirate - To Spawn the Ship\n/hidebox - Hide the Box (below the chat)\n/yes - To Use the Ship!!\n/no - Not To Use the Ship!!", "Close", "");
    }
    return 1;
}
CMD:vpirate(playerid, params[])
{
	if (Vip[playerid] >= 1)
	{
    asked[playerid] = 1;
    asked1[playerid] = 1;
    SpawnVeh(453, playerid);
    xVip(playerid,"VPIRATE");
    SendClientMessage(playerid, 0xFF0080C8, "Reefer Spawned, Good Luck Mr Pirate!");//spawning that BOAT :D
    TextDrawShowForPlayer(playerid,Textdraw0);
    }
    return 1;
}
CMD:vcmds(playerid, params[])
{
if (Vip[playerid] >= 1)
{
new XVip1[]="{FF4101}Level 1 VIP Commands\n\
/vcar       /vbike     \n\
/vheli      /vboat     \n\
/vplane     /vheal     \n\
/varmour    /balloncmds\n\
/gballon    /rballon   \n\
/bballon     /bup      \n\
/gup        /rup       \n\
/bdown      /rdown     \n\
/gdown      /yes       \n\
/no        /hidebox    \n\
/vpirate   /piratecmds \n\
/vtunecmds  /vheli     \n\
/unship     /vnos      \n\
/vcolor     /vcarcolor \n\
/vtune      /vuntune\n\n\n\n",


XVip2[]="{FA0404}Level 2 VIP Commands\n\
/vskin       /vcar     \n\
/vspecoff    /vspec    \n\
/vweather    /vheli    \n\
/visland     /vplane   \n\
/vsay        /vboat    \n\
/vweap      /vpirate   \n\
/vkick      /vtune     \n\
/vgod      /vjetpack     \n\
/vdick     /vuntune\n\n\n\n",


XVip3[]="{2CF11A}Level 3 VIP Commands\n\
/vannounce   /vshop      \n\
/vheli      /vfeature    \n\
/vplane     /vironman    \n\
/varmour    /vgodcar     \n\
/vgoto\n\n\n\
{FFFFFF}Use /vc For VIP Chat\n",

XVcmds[1600];
format( XVcmds, sizeof XVcmds, "%s%s%s%s%s", XVip1, XVip2, XVip3);
Vcmds(playerid, V.I.PCmds, xBox, "V.I.P Commands", XVcmds, "Ok", "" );
}
return 1;
}
CMD:hidebox(playerid, params[])
{
    if (Vip[playerid] >= 1)
	{
    TextDrawHideForPlayer(playerid,Textdraw0);
    xVip(playerid,"HIDEBOX");
    SendClientMessage(playerid, 0xFF0080C8, "Box is Now Hidden!");
    }
    return 1;
}
CMD:yes(playerid, params[])
{
	if (Vip[playerid] >= 1)
	{
	if (asked[playerid] == 1)
	{
	ship[playerid] = 1;
	TextDrawHideForPlayer(playerid,Textdraw0);
    asked[playerid] = 0;
    xVip(playerid,"YES");
	AttachObjectToVehicle(o, GetPlayerVehicleID(playerid), 0.899999,30.000114,17.099996,0.000000,0.000000,0.000000);
    }
    }
    else if (asked[playerid] == 0)
	{
	SendClientMessage(playerid,-1,"Non. Asked u a Question!");
	}
    return 1;
}
CMD:no(playerid, params[])
{
	if (Vip[playerid] >= 1)
	{
	if (asked1[playerid] == 1)
	{
	TextDrawHideForPlayer(playerid,Textdraw0);
    asked1[playerid] = 0;
    xVip(playerid,"NO");
	SendClientMessage(playerid, 0xFF0080C8, "Use /vPirate if u wanna Use it ever again!");
    }
    }
    else if (asked1[playerid] == 0)
	{
	SendClientMessage(playerid,-1,"Non. Asked u a Question!");
	}
    return 1;
}
//======================================
CMD:setvip(playerid, params[])
{
if (IsPlayerAdmin(playerid) )
{
new string[200], pos, level;
if(!params[0]||!(pos=chrfind(' ',params)+1)||!params[pos]) return SendClientMessage(playerid, COLOR_RED, "[!] USAGE: /setlevel [ID] [0-3]");
new id = strval(params[0]);
level = strval(params[pos]);
if(!IsPlayerConnected(id))  return SendClientMessage(playerid, COLOR_RED, "  [!] Player with this ID is not on the server !");
if(level < 0 || level > 3) return SendClientMessage(playerid, COLOR_RED, "  [!] the level must be betwen 0 and 3 !");
format(string, sizeof(string), " **Administrator %s set Vip Level to %s [Level: %d]", PlayerName(playerid), PlayerName(id), level);
SendClientMessageToAll(COLOR_RED, string);
Vip[id] = level;
}
return 1;
}
stock PlayerName(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid,name,MAX_PLAYER_NAME);
    return name;
}
CMD:vironman(playerid, params[])
    if (Vip[playerid] >= 3)
	{
	{
		if((flying[playerid] = !flying[playerid]))
		{
		    new Float:x, Float:y, Float:z;
		    GetPlayerPos(playerid, x, y, z);
		    SetPlayerHealth(playerid, 1000000000.0);
		    SetTimerEx("IronMan", 100, 0, "d", playerid);
		    xVip(playerid,"VIRONMAN");
		    SetTimerEx("DestroyMe", 500, 0, "d", CreateObject(2780, x, y, z - 3.0, 0.0, 0.0, 0.0));
		}
		else
		    SetPlayerHealth(playerid, 100.0);
}
}
CMD:unship(playerid, params[])
{
if(ship[playerid] == 1)
{
RemovePlayerFromVehicle(playerid);
DestroyObject(o);
SendClientMessage(playerid,-1,"SERVER:Pirate Ship Removed! !");
xVip(playerid,"UNSHIP");
}
else
if(ship[playerid] == 0)
{
SendClientMessage(playerid,-1,"SERVER:Your vehicle is not having Pirate Ship!");
}
return 1;
}
CMD:vweather(playerid, params[])
{
if (Vip[playerid] >= 2)
{
new pos, level;
if(isnull(params)) return SendClientMessage(playerid, COLOR_RED, "xUSAGE: /weahter [weather id]");
level = strval(params[pos]);
if(level < 1 || level > 44) return SendClientMessage(playerid, COLOR_RED, "  Please enter number of weather [1-44]");
xVip(playerid,"VWEATHER");
SetWeather(level);
}
return 1;
}
CMD:vcargod(playerid, params[])
{
if (Vip[playerid] >= 3)
{
SendClientMessage(playerid,COLOR_RED,"Enjoy Your God Car!");
SetVehicleHealth(playerid,99999999999999999.0);
xVip(playerid,"VCARGOD");
} else {
 SendClientMessage(playerid,COLOR_RED,"ERROR: You Cant Use This CMD");
 }
return 1;
}

CMD:vheal(playerid, params[])
{
if (Vip[playerid] >= 1)
{
if(Anti_heal[playerid] == 0) {
SendClientMessage(playerid,COLOR_RED,"Health Restored");
xVip(playerid,"VHEAL");
SetPlayerHealth(playerid,100);
Anti_heal[playerid] = 1;
} else return SendClientMessage(playerid,COLOR_RED,"ERROR: You Can Use This Per Death Only");
	  } else return SendClientMessage(playerid,COLOR_RED,"ERROR: You Need Atleast VIP Rank 1 To Use This Command");
return 1;
}
CMD:varmour(playerid, params[])
{
if (Vip[playerid] >= 1)
{
if(Anti_heal[playerid] == 0) {
SendClientMessage(playerid,COLOR_RED,"Armour Restored");
SetPlayerArmour(playerid,100);
xVip(playerid,"VARMOUR");
Anti_heal[playerid] = 1;
} else return SendClientMessage(playerid,COLOR_RED,"ERROR: You Can Use This Per Death Only");
	  } else return SendClientMessage(playerid,COLOR_RED,"ERROR: You Need Atleast VIP Rank 1 To Use This Command");

return 1;
}
CMD:vweap(playerid, params[])
{
if (Vip[playerid] >= 2)
{
if(wep[playerid] == 0) {
GivePlayerWeapon(playerid, 26,500);
GivePlayerWeapon(playerid, 24,500);
GivePlayerWeapon(playerid, 35,1);
GivePlayerWeapon(playerid, 16,2);
xVip(playerid,"VWEAP");
wep[playerid] = 1;
} else return SendClientMessage(playerid,COLOR_RED,"ERROR: You Can Use This Per Death Only");
	  } else return SendClientMessage(playerid,COLOR_RED,"ERROR: You Need Atleast VIP Rank 1 To Use This Command");
return 1;
}
CMD:credits(playerid, params[])
{
SendClientMessage(playerid,COLOR_RED,"Thanks To Krisna for VIP system");
SendClientMessage(playerid,COLOR_RED,"Thanks To SAMP for /ironman");
SendClientMessage(playerid,COLOR_RED,"Thanks To Speederx for VIP Island");
}
CMD:vcarcolor(playerid, params[])
{
if (Vip[playerid] >= 1)
{
xVip(playerid,"VCARCOLOR");
ShowPlayerDialog(playerid,245,DIALOG_STYLE_LIST,"Color List","{FCF7F9}White\n{1C9139}Green\n{2D5CAD}Blue\n{E8B82A}Orange\n{5C512F}Brwon\n{16F2E7}Light Blue\n{FF0000}Red\n{FF42EF}Pink\n{B907F5}Purple \n{878478}Grey\n{000000}Black","Select","Cancel");
}
return 1;
}

CMD:vnos(playerid, params[])
{
if (Vip[playerid] >= 1)
{
SendClientMessage(playerid,COLOR_RED,"Nirto Added");
AddVehicleComponent(GetPlayerVehicleID(playerid), 1010); // Nitro
xVip(playerid,"VNOS");
}
return 1;
}
CMD:vsay(playerid, params[])
{
if (Vip[playerid] >= 2){
new name[MAX_PLAYER_NAME+1], string[24+MAX_PLAYER_NAME+1];
GetPlayerName(playerid, name, sizeof(name));
if(isnull(params)) return SendClientMessage(playerid, red, "ERROR: Please Use /vsay [text]");
format(string, sizeof(string), "[VIP]%s: %s", name, params[0] );
return SendClientMessageToAll(0xFF9900AA,string);
} else return SendClientMessage(playerid,red,"ERROR: You need to be VIP to use this command");
}
//Donor Chat!!!
CMD:vc(playerid, params[])
{
if (Vip[playerid] >= 1){
new name[MAX_PLAYER_NAME+1], string[24+MAX_PLAYER_NAME+1];
GetPlayerName(playerid, name, sizeof(name));
if(isnull(params)) return SendClientMessage(playerid, red, "ERROR: Please Use /vc [text]");
format(string, sizeof(string), "~VIP~Chat: %s: %s", name, params[0] );
return MessageToD(0xFF9900AA,string);
} else return SendClientMessage(playerid,red,"ERROR: You need to be VIP to use this command");
}
//---------------------------
CMD:vheli(playerid, params[])
{
   	if (Vip[playerid] >= 1)
   	{
   	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_RED,"You already have a vehicle!");
	new Float:X, Float:Y, Float:Z;
 	GetPlayerPos(playerid, X, Y, Z);
  	PutPlayerInVehicle(playerid, CreateVehicle(487, X, Y, Z, 0.0,0, 1, 60), 0);
   	SendClientMessage(playerid, COLOR_RED,"Enjoy your new V.I.P Heli!");
   	xVip(playerid,"VHELI");
 	} else return SendClientMessage(playerid,COLOR_RED,"ERROR: You Need Atleast VIP Rank 1 To Use This Command");
   	return 1;
}
CMD:vboat(playerid, params[])
{
   	if (Vip[playerid] >= 1)
   	{
   	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_RED,"You already have a vehicle!");
	new Float:X, Float:Y, Float:Z;
 	GetPlayerPos(playerid, X, Y, Z);
  	PutPlayerInVehicle(playerid, CreateVehicle(493, X, Y, Z, 0.0,0, 1, 60), 0);
   	SendClientMessage(playerid, COLOR_RED,"Enjoy your new V.I.P Boat!");
   	xVip(playerid,"VBOAT");
 	} else return SendClientMessage(playerid,COLOR_RED,"ERROR: You Need Atleast VIP Rank 1 To Use This Command");
   	return 1;
}
CMD:vplane(playerid, params[])
{
   	if (Vip[playerid] >= 1)
   	{
   	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_RED,"You already have a vehicle!");
	new Float:X, Float:Y, Float:Z;
 	GetPlayerPos(playerid, X, Y, Z);
  	PutPlayerInVehicle(playerid, CreateVehicle(519, X, Y, Z, 0.0,0, 1, 60), 0);
   	SendClientMessage(playerid, COLOR_RED,"Enjoy your new V.I.P Plane!");
   	xVip(playerid,"VPLANE");
   	de[playerid] = 1;
 	} else return SendClientMessage(playerid,COLOR_RED,"ERROR: You Need Atleast VIP Rank 1 To Use This Command");
   	return 1;
}
CMD:vcar(playerid, params[])
{
   	if (Vip[playerid] >= 1)
   	{
   	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_RED,"You already have a vehicle!");
	new Float:X, Float:Y, Float:Z;
 	GetPlayerPos(playerid, X, Y, Z);
  	PutPlayerInVehicle(playerid, CreateVehicle(415, X, Y, Z, 0.0,0, 1, 60), 0);
   	SendClientMessage(playerid, COLOR_RED,"Enjoy your new V.I.P car!");
   	xVip(playerid,"VCAR");
 	} else return SendClientMessage(playerid,COLOR_RED,"ERROR: You Need Atleast VIP Rank 1 To Use This Command");
   	return 1;
}
CMD:vbike(playerid, params[])
{
   	if (Vip[playerid] >= 1)
   	{
   	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_RED,"You already have a vehicle!");
	new Float:X, Float:Y, Float:Z;
 	GetPlayerPos(playerid, X, Y, Z);
  	PutPlayerInVehicle(playerid, CreateVehicle(522, X, Y, Z, 0.0,0, 1, 60), 0);
   	SendClientMessage(playerid, COLOR_RED,"Enjoy your new V.I.P bike!");
   	xVip(playerid,"VBIKE");
 	} else return SendClientMessage(playerid,COLOR_RED,"ERROR: You Need Atleast VIP Rank 1 To Use This Command");
   	return 1;
}
CMD:vgoto(playerid, params[])
{
if (Vip[playerid] >= 3)
{
if(isnull(params)) return SendClientMessage(playerid, COLOR_RED, "xUSAGE: /vgoto [player's id]");
new id = strval(params[0]);
new Float:x,Float:y,Float:z;
GetPlayerPos(id,x,y,z);
SetPlayerPos(playerid,x,y,z);
xVip(playerid,"VGOTO");
SendClientMessage(playerid, COLOR_WHITE,"Teleported.");
}
return 1;
}
CMD:vstats(playerid, params[])
{
#pragma unused params
new string[200];
format(string, sizeof(string), " Name: %s  Vip Level: %d", PlayerName(playerid), Vip[playerid] );
SendClientMessage(playerid ,COLOR_RED, string);
return 1;
}
CMD:vshop(playerid, params[])
{
if (Vip[playerid] >= 3)
{
xVip(playerid,"VSHOP");
ShowPlayerDialog(playerid,99,DIALOG_STYLE_LIST,"{00FF00}VIP Player Shop","\n{FFFFFF}Full Armour+Health- {00FF00}3000$\n{FFFFFF}RPG(Rocket Luncher)- {00FF00}7800$\n{FFFFFF}Grenades- {00FF00}6500$","Buy","Cancel");
}
return 1;
}
CMD:vfeatures(playerid, params[])
{
if (Vip[playerid] >= 3)
{
xVip(playerid,"VFEATURES");
ShowPlayerDialog(playerid, 786, DIALOG_STYLE_LIST, "xV.I.P Features","Vip Car(/vcar)\nVip Nos(/vnos)\nVip Color(/vcolor)\nVip Weapons(/vweap)\nVIP Heal(vheal)\nVIP Armour(/varmour)\nVip Car Color(/vcarcolor)\nVIP Car God(/vcargod)","Select","Close");
}
return 1;
}
CMD:vskin(playerid, params[])
{
if (Vip[playerid] >= 1)
{
new pos, level;
if(isnull(params)) return SendClientMessage(playerid, COLOR_RED, "USAGE: /vskin [skin id]");
level = strval(params[pos]);
if(level < 1 || level > 299) return SendClientMessage(playerid, COLOR_RED, "ERROR: Please enter number of level [1-299]");
xVip(playerid,"VSKIN");
SetPlayerSkin(playerid, level);
}
return 1;
}
CMD:vkick(playerid, params[])
{
    if (Vip[playerid] >= 2)
	{
    new id, reason[128];
    if(sscanf(params, "us(No Reason)[128]", id, reason))SendClientMessage(playerid, COLOR_WHITE, "Usage: /kick [id/name][reason]");
    else if(id==playerid)SendClientMessage(playerid,COLOR_WHITE,"Error: You can not kick yourself!");
    else if (id==INVALID_PLAYER_ID)SendClientMessage(playerid,COLOR_WHITE,"Error: Player is not connected!");
    else {
        new KickMessage[128];
        new Name2[MAX_PLAYER_NAME];
        GetPlayerName(playerid, Name, sizeof(Name));
        GetPlayerName(id, Name2, sizeof(Name2));
        format(KickMessage, sizeof(KickMessage), "VIP PLAYER %s(%d) has kicked player %s(%d). Reason: %s", Name, playerid, Name2, id);
        SendClientMessageToAll(COLOR_WHITE, KickMessage);
        xVip(playerid,"VKICK");
        Kick(id);
    }
    }
    return 1;
}
CMD:vcolor(playerid, params[])
{
if (Vip[playerid] >= 1)
{
#pragma unused params
SendClientMessage(playerid,COLOR_RED,"***Your Color Is VIP Now!***");
xVip(playerid,"VCOLOR");
SetPlayerColor(playerid,COLOR_VIP);
}
}
public IronMan(playerid)
{
	if(!IsPlayerConnected(playerid))
		return flying[playerid] = false;

	if(flying[playerid])
	{
	    if(!IsPlayerInAnyVehicle(playerid))
	    {
			new
			    i,
			    keys,
				ud,
				lr,
				Float:x[2],
				Float:y[2],
				Float:z,
				Float:a;

			GetPlayerKeys(playerid, keys, ud, lr);
			GetPlayerVelocity(playerid, x[0], y[0], z);

			if(!GetPlayerWeapon(playerid))
			{
				if((keys & KEY_FIRE) == (KEY_FIRE))
				{
				    i = 0;
				    while(i < MAX_PLAYERS)
				    {
				        if(i != playerid)
				        {
						    GetPlayerPos(i, x[0], y[0], z);
						    if(IsPlayerInRangeOfPoint(playerid, 3.0, x[0], y[0], z))
					        	if(IsPlayerFacingPlayer(playerid, i, 15.0))
					        	    SetPlayerVelocity(i, floatsin(-a, degrees), floatcos(-a, degrees), 0.05);
				        }
						++i;
				    }
				}

				if((keys & 136) == (136))
				    Jav(playerid);

	   		}

			if(ud == KEY_UP)
			{
				GetPlayerCameraPos(playerid, x[0], y[0], z);
				GetPlayerCameraFrontVector(playerid, x[1], y[1], z);

				a = SetPlayerToFacePos(playerid, x[0] + x[1], y[0] + y[1]);

		    	ApplyAnimation(playerid, "PARACHUTE", "FALL_SkyDive_Accel", 4.1, 0, 0, 0, 0, 0);
				SetPlayerVelocity(playerid, x[1], y[1], z);

				i = 0;
				while(i < MAX_PLAYERS)
				{
				    if(i != playerid)
				    {
					    GetPlayerPos(i, x[0], y[0], z);
					    if(IsPlayerInRangeOfPoint(playerid, 10.0, x[0], y[0], z))
					        if(IsPlayerInAnyVehicle(i))
					        {
					            SetVehicleHealth(GetPlayerVehicleID(i), 0.0);
					            CreateExplosion(x[0], y[0], z, 7, 5.0);
				         	}
	       			}

					++i;
				}
			}
			else
				SetPlayerVelocity(playerid, 0.0, 0.0, 0.01);
		}

		SetTimerEx("IronMan", 100, 0, "d", playerid);
	}

	return 0;
}
public DestroyMe(objectid)
{
	return DestroyObject(objectid);
}

public Jav(playerid)
{
	if(!Javelin[playerid][1])
	{
 		new
			target = GetClosestPlayer(playerid);

		if(target != -1)
		{
		    GetPlayerPos(target, JavPos[playerid][0], JavPos[playerid][1], JavPos[playerid][2]);
			if(IsPlayerInRangeOfPoint(playerid, 500.0, JavPos[playerid][0], JavPos[playerid][1], JavPos[playerid][2]))
			{
				new Float:a;
				GetPlayerPos(playerid, JavPos[playerid][0], JavPos[playerid][1], JavPos[playerid][2]);
				GetPlayerFacingAngle(playerid, a);

				Javelin[playerid][0] = CreateObject(354, JavPos[playerid][0], JavPos[playerid][1], JavPos[playerid][2], 0.0, 90.0, 0.0);
				MoveObject(Javelin[playerid][0], JavPos[playerid][0], JavPos[playerid][1], JavPos[playerid][2] + 100.0, 45.0);

				GetPlayerPos(target, JavPos[playerid][0], JavPos[playerid][1], JavPos[playerid][2]);

				Javelin[playerid][1] = 1;
			}
		}
	}

	return 0;
}
stock xVip(playerid,command[])
{
	new string[128]; GetPlayerName(playerid,string,sizeof(string));
	format(string,sizeof(string),"[INFO]V.I.P %s has used %s",string,command);
	MessageToD(blue,string);
}
forward MessageToD(color,const string[]);
public MessageToD(color,const string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	if (Vip[i] >= 1 ) SendClientMessage(i, color, string);
	}
	return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    			switch(dialogid)
    			{
        		case 245:
        		{
            	if(!response)
            	{
                SendClientMessage(playerid, COLOR_RED,"You Canceled!");
                return 1;
            	}
             	switch(listitem)
             	{
                case 0:
                {
                  ChangeVehicleColor(GetPlayerVehicleID(playerid), 1, 1);
        	    }
        	    case 1:
        	    {
                    ChangeVehicleColor(GetPlayerVehicleID(playerid), 236, 236);
                }
                case 2:
                {
                    ChangeVehicleColor(GetPlayerVehicleID(playerid), 79, 79);
                }
                case 3:
                {
                    ChangeVehicleColor(GetPlayerVehicleID(playerid), 6, 6);
                }
                case 4:
				{
                    ChangeVehicleColor(GetPlayerVehicleID(playerid), 55, 55);
                }
                case 5:
                {
                    ChangeVehicleColor(GetPlayerVehicleID(playerid), 147, 147);
                }
                case 6:
                {
                    ChangeVehicleColor(GetPlayerVehicleID(playerid), 3, 3);
                }
                case 7:
                {
                    ChangeVehicleColor(GetPlayerVehicleID(playerid), 183, 183);
                }
                case 8:
                {
                    ChangeVehicleColor(GetPlayerVehicleID(playerid), 186, 186);
                }
                case 9:
                {
                    ChangeVehicleColor(GetPlayerVehicleID(playerid), 91, 91);
                }
                case 10:
                {
                    ChangeVehicleColor(GetPlayerVehicleID(playerid), 000, 000);
                }
              	}
         		}
         		}
  				switch(dialogid)
    			{
        		case 99:
        		{
            	if(!response)
            	{
                SendClientMessage(playerid, COLOR_RED,"You Canceled!");
                return 1;
            	}
             	switch(listitem)
             	{
                case 0:
                {
				if(GetPlayerMoney(playerid) < 3000)
				{
				SetPlayerHealth(playerid, 100);
				SetPlayerArmour(playerid, 100);
				GivePlayerMoney(playerid,-3000);
				}
				}
        	    case 1:
        	    {
				if(GetPlayerMoney(playerid) < 7800) {
				GivePlayerWeapon(playerid,35,2);
				GivePlayerMoney(playerid,-7800);
                }
                }
                case 2:
                {
				if(GetPlayerMoney(playerid) < 6500) {
				GivePlayerWeapon(playerid,16,4);
				GivePlayerMoney(playerid,-6500);
				}
				}
				}
				}
				}
         		switch(dialogid)
    			{
        		case 786:
        		{
            	if(!response)
            	{
                SendClientMessage(playerid, COLOR_RED,"You Canceled!");
                return 1;
            	}
             	switch(listitem)
             	{
                case 0:
                {
                if (Vip[playerid] >= 1)
			   	{
			   	if (de[playerid] == 0)
			   	{
			   	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_RED,"You already have a vehicle!");
				new Float:X, Float:Y, Float:Z;
			 	GetPlayerPos(playerid, X, Y, Z);
			  	PutPlayerInVehicle(playerid, CreateVehicle(415, X, Y, Z, 0.0,0, 1, 60), 0);
			   	SendClientMessage(playerid, COLOR_RED,"Enjoy your new V.I.P car!");
			   	de[playerid] = 1;
				} else return SendClientMessage(playerid,COLOR_RED,"ERROR: You Can Use This Per Death Only");
			 	} else return SendClientMessage(playerid,COLOR_RED,"ERROR: You Need Atleast VIP Rank 1 To Use This Command");
        	    }
        	    case 1:
        	    {
             	if (Vip[playerid] >= 1)
				{
				SendClientMessage(playerid,COLOR_RED,"Nirto Added");
				AddVehicleComponent(GetPlayerVehicleID(playerid), 1010); // Nitro
				}
                }
                case 2:
                {
                if (Vip[playerid] >= 1)
				{
				SendClientMessage(playerid,COLOR_RED,"***Your Color Is VIP Now!***");
				SetPlayerColor(playerid,COLOR_VIP);
				}
                }
                case 3:
                {
                if (Vip[playerid] >= 1)
				{
				if(wep[playerid] == 0) {
				GivePlayerWeapon(playerid, 26,500);
				GivePlayerWeapon(playerid, 24,500);
				GivePlayerWeapon(playerid, 35,1);
				GivePlayerWeapon(playerid, 16,2);
				} else return SendClientMessage(playerid,COLOR_RED,"ERROR: You Can Use This Per Death Only");
		  		} else return SendClientMessage(playerid,COLOR_RED,"ERROR: You Need Atleast VIP Rank 1 To Use This Command");
                }
                case 4:
				{
    			if (Vip[playerid] >= 1)
				{
				if(Anti_heal[playerid] == 0) {
				SendClientMessage(playerid,COLOR_RED,"Health Restored");
				SetPlayerHealth(playerid,100);
				Anti_heal[playerid] = 1;
				} else return SendClientMessage(playerid,COLOR_RED,"ERROR: You Can Use This Per Death Only");
					  } else return SendClientMessage(playerid,COLOR_RED,"ERROR: You Need Atleast VIP Rank 1 To Use This Command");
                }
                case 5:
                {
                if (Vip[playerid] >= 1)
				{
				if(Anti_heal[playerid] == 0) {
				SendClientMessage(playerid,COLOR_RED,"Armour Restored");
				SetPlayerArmour(playerid,100);
				Anti_heal[playerid] = 1;
				} else return SendClientMessage(playerid,COLOR_RED,"ERROR: You Can Use This Per Death Only");
					  } else return SendClientMessage(playerid,COLOR_RED,"ERROR: You Need Atleast VIP Rank 1 To Use This Command");

                }
                case 6:
                {
                    ShowPlayerDialog(playerid,245,DIALOG_STYLE_LIST,"Color List","{FCF7F9}White\n{1C9139}Green\n{2D5CAD}Blue\n{E8B82A}Orange\n{5C512F}Brwon\n{16F2E7}Light Blue\n{FF0000}Red\n{FF42EF}Pink\n{B907F5}Purple \n{878478}Grey\n{000000}Black","Select","Cancel");
                }
                case 7:
                {
                if (Vip[playerid] >= 1)
				{
				SendClientMessage(playerid,COLOR_RED,"Enjoy Your God Car!");
				SetVehicleHealth(playerid,99999999999999999.0);
				} else {
				 SendClientMessage(playerid,COLOR_RED,"ERROR: You Cant Use This CMD");
				 }
                }
              	}
         		}
         		}
         		return 0;
         		}
         		stock GetPlayerLastPos(playerid)
{
    new Float:pX, Float:pY, Float:pZ;
    GetPlayerPos(playerid, pX, pY, pZ);
    gPlayerData[playerid][E_LAST_X] = pX;
    gPlayerData[playerid][E_LAST_Y] = pY;
    gPlayerData[playerid][E_LAST_Z] = pZ;
}

stock SetPlayerLastPos(playerid)
{
    SetPlayerPos(playerid,gPlayerData[playerid][E_LAST_X],gPlayerData[playerid][E_LAST_Y], gPlayerData[playerid][E_LAST_Z]);
}
