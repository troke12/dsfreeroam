//=======================>>Gang creating  Sytem <<==================//
//=====      Made by GoldenStein|Translated by Doctor_H3ll      =====// I mean its translated by Carrot but i think that Doctor translated it
//===================>>Visit www.vyo.fnhost.org<<==============//	Romanian from English ...
//===================>>Visit www.sa-mp.ro/forum<<==============//
//===================>>please don't delete credits<<=============//
#include <a_samp>


#define FILTERSCRIPT

#if defined FILTERSCRIPT
forward PlayerLeaveGang(playerid);
#define COLOR_ORANGERED 0xE9370DFC
#define COLOR_GOLD 0xDEAD4370
#define COLOR_MEDIUMAQUA 0x83BFBFFF
#define COLOR_BLUE 0x0000FFAA
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_PURPLE 0x9900FFAA
#define COLOR_BROWN 0x993300AA
#define COLOR_ORANGE 0xFF9933AA
#define COLOR_CYAN 0x99FFFFAA
#define COLOR_TAN 0xFFFFCCAA
#define COLOR_PINK 0xFF66FFAA
#define COLOR_KHAKI 0x999900AA
#define COLOR_LIME 0x99FF00AA
#define COLOR_BLACK 0x000000AA
#define COLOR_TURQ 0x00A3C0AA
#define COLOR_LIGHTBLUE 0x00BFFFAA
#define COLOR_GREENISHGOLD 0xCCFFDD56
#define COLOR_LIGHTBLUEGREEN 0x0FFDD349
#define COLOR_LIGHTCYAN 0xAAFFCC33
#define COLOR_LEMON 0xDDDD2357
#define COLOR_LIGHTGREEN 0x7CFC00AA
#define COLOR_WHITEYELLOW 0xFFE87DAA
#define COLOR_BLUEAQUA 0x7E60FFAA
#define COLOR_GREENYELLOWWHITE 0xCBFF45AA
#define COLOR_DARKBLUE 0x15005EAA
#define COLOR_RED 0xAA3333AA
#define COLOR_LIGHTRED 0xFF0000AA
#define NUMVALUES 4

new playerColors[100] = {
0xFF8C13FF,0xC715FFFF,0x20B2AAFF,0xDC143CFF,0x6495EDFF,0xf0e68cFF,0x778899FF,0xFF1493FF,0xF4A460FF,0xEE82EEFF,0xFFD720FF,
0x8b4513FF,0x4949A0FF,0x148b8bFF,0x14ff7fFF,0x556b2fFF,0x0FD9FAFF,0x10DC29FF,0x534081FF,0x0495CDFF,0xEF6CE8FF,0xBD34DAFF,
0x247C1BFF,0x0C8E5DFF,0x635B03FF,0xCB7ED3FF,0x65ADEBFF,0x5C1ACCFF,0xF2F853FF,0x11F891FF,0x7B39AAFF,0x53EB10FF,0x54137DFF,
0x275222FF,0xF09F5BFF,0x3D0A4FFF,0x22F767FF,0xD63034FF,0x9A6980FF,0xDFB935FF,0x3793FAFF,0x90239DFF,0xE9AB2FFF,0xAF2FF3FF,
0x057F94FF,0xB98519FF,0x388EEAFF,0x028151FF,0xA55043FF,0x0DE018FF,0x93AB1CFF,0x95BAF0FF,0x369976FF,0x18F71FFF,0x4B8987FF,
0x491B9EFF,0x829DC7FF,0xBCE635FF,0xCEA6DFFF,0x20D4ADFF,0x2D74FDFF,0x3C1C0DFF,0x12D6D4FF,0x48C000FF,0x2A51E2FF,0xE3AC12FF,
0xFC42A8FF,0x2FC827FF,0x1A30BFFF,0xB740C2FF,0x42ACF5FF,0x2FD9DEFF,0xFAFB71FF,0x05D1CDFF,0xC471BDFF,0x94436EFF,0xC1F7ECFF,
0xCE79EEFF,0xBD1EF2FF,0x93B7E4FF,0x3214AAFF,0x184D3BFF,0xAE4B99FF,0x7E49D7FF,0x4C436EFF,0xFA24CCFF,0xCE76BEFF,0xA04E0AFF,
0x9F945CFF,0xDCDE3DFF,0x10C9C5FF,0x70524DFF,0x0BE472FF,0x8A2CD7FF,0x6152C2FF,0xCF72A9FF,0xE59338FF,0xEEDC2DFF,0xD8C762FF,
0x3FE65CFF
};

#define MAX_GANGS 			32
#define MAX_GANG_MEMBERS    20
#define MAX_GANG_NAME       30
new gangMembers[MAX_GANGS][MAX_GANG_MEMBERS];
new gangNames[MAX_GANGS][MAX_GANG_NAME];
new gangInfo[MAX_GANGS][3];
new gangBank[MAX_GANGS];
new playerGang[MAX_PLAYERS];
new gangInvite[MAX_PLAYERS];



public OnFilterScriptInit()
{
	print("==========================");
	print("Gang creating System GoldenStein|Translated by Doctor_H3ll");  // By Carrot from Romanian to English
	print("==========================");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

#endif

public OnPlayerText(playerid, text[])
{
	if(text[0] == '!') {
		if(playerGang[playerid] > 0) {
		    new gangChat[256];
		    new senderName[MAX_PLAYER_NAME];
		    new string[256];

			strmid(gangChat,text,1,strlen(text));

			GetPlayerName(playerid, senderName, sizeof(senderName));
			format(string, sizeof(string),"[GANG %s:] %s", senderName, gangChat);

			for(new i = 0; i < gangInfo[playerGang[playerid]][1]; i++) {
				SendClientMessage(gangMembers[playerGang[playerid]][i], COLOR_LIGHTBLUE, string);
			}
		}

		return 0;
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
    playerGang[playerid]=0;
	gangInvite[playerid]=0;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    PlayerLeaveGang(playerid);
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	new string[256];
	new sendername[MAX_PLAYER_NAME];
	new giveplayer[MAX_PLAYER_NAME];
	new cmd[256];
	new giveplayerid,idx;

	cmd = strtok(cmdtext, idx);

    if(strcmp(cmd, "/ganghelp", true) == 0) {
    SendClientMessage(playerid, COLOR_YELLOW,"/createclan [Name]");
    SendClientMessage(playerid, COLOR_YELLOW,"/caccept");
    SendClientMessage(playerid, COLOR_YELLOW,"/cinvite [Player ID]");
    SendClientMessage(playerid, COLOR_YELLOW,"/lclan");
    SendClientMessage(playerid, COLOR_YELLOW,"/claninfo [Gang ID]");
    SendClientMessage(playerid, COLOR_YELLOW,"! [Text] Gang chat");
    return 1;
	}


    //------------------- gang

	if(strcmp(cmd, "/gang", true) == 0) {
	    new tmp[256];
	    new gangcmd, gangnum;
		tmp = strtok(cmdtext, idx);

		if(!strlen(tmp)) {
			SendClientMessage(playerid, 0x83BFBFFF, "Write /clanhelp for details.");
			return 1;
		}
		giveplayerid = strval(tmp);

		if(strcmp(tmp, "create", true)==0)
		    gangcmd = 1;
		else if(strcmp(tmp, "invite", true)==0)
		    gangcmd = 2;
		else if(strcmp(tmp, "enter", true)==0)
		    gangcmd = 3;
		else if(strcmp(tmp, "abandon", true)==0) // I think LEAVE goes better but ... abandoneaza = abandon
		    gangcmd = 4;

		tmp = strtok(cmdtext, idx);
		if(gangcmd < 3 && !strlen(tmp)) {
		    if(gangcmd==0)
				SendClientMessage(playerid, 0x83BFBFFF, "Write /clanhelp for details.");
			else if(gangcmd==1)
				SendClientMessage(playerid, 0x83BFBFFF, "Write: /createclan [Name]");
			else if(gangcmd==2)
				SendClientMessage(playerid, 0x83BFBFFF, "Write: /cinvite [PlayerID]");
			return 1;
		}

		//Create//
		if(gangcmd==1) {
		    if(playerGang[playerid]>0) {
				SendClientMessage(playerid, 0x83BFBFFF, "You are already in a clan !");
				return 1;
		    }

			for(new i = 1; i < MAX_GANGS; i++) {
				if(gangInfo[i][0]==0) {
				    //Gang name
					format(gangNames[i], MAX_GANG_NAME, "%s", tmp);
					//Existing gang
					gangInfo[i][0]=1;
					//Only one member
					gangInfo[i][1]=1;
					//Gang color is player's color
					gangInfo[i][2]=playerColors[playerid];

					//Player is 1st (first) member
					gangMembers[i][0] = playerid;
					format(string, sizeof(string),"You've created gang '%s' (ID: %d)", gangNames[i], i);
					SendClientMessage(playerid, 0x83BFBFFF, string);

					playerGang[playerid]=i;

					return 1;
				}
			}

			return 1;

		//Enter gang//
		} else if (gangcmd==3) {
			gangnum = gangInvite[playerid];

		    if(playerGang[playerid]>0) {
				SendClientMessage(playerid, 0x83BFBFFF, "You are already in a gang.");
				return 1;
		    }
			if(gangInvite[playerid]==0) {
				SendClientMessage(playerid, 0x83BFBFFF, "You are not invited in a gang.");
				return 1;
			}
			if(gangInfo[gangnum][0]==0) {
				SendClientMessage(playerid, 0x83BFBFFF, "Gang doesn't exist.");
				return 1;
			}

			if(gangInfo[gangnum][1] < MAX_GANG_MEMBERS) {
			    new i = gangInfo[gangnum][1];

				gangInvite[playerid]=0;

				gangMembers[gangnum][i] = playerid;

			    GetPlayerName(playerid, sendername, MAX_PLAYER_NAME);
				for(new j = 0; j < gangInfo[gangnum][1]; j++) {
					format(string, sizeof(string),"%s entered your gang.Say hi to %s and help him fit.", sendername);
					SendClientMessage(gangMembers[gangnum][j], COLOR_ORANGE, string);
				}

				gangInfo[gangnum][1]++;
				playerGang[playerid] = gangnum;

				SetPlayerColor(playerid,gangInfo[gangnum][2]);

				format(string, sizeof(string),"You've entered in gang '%s'(id: %d)", gangNames[gangnum], gangnum);
				SendClientMessage(playerid, 0x83BFBFFF, string);

				return 1;
			}

			SendClientMessage(playerid, 0x83BFBFFF, "No member found");
			return 1;

		//Invite//
		} else if (gangcmd==2) {
			giveplayerid = strval(tmp);

			if(playerGang[playerid]==0) {
				SendClientMessage(playerid, 0x83BFBFFF, "You aren't in a gang.");
				return 1;
			}
//			if(gangMembers[playerGang[playerid]][0]!=playerid) {
//				SendClientMessage(playerid, COLOR_RED, "You have to be the gang leader to invite someone.");
//				return 1;
//			}

			if(IsPlayerConnected(giveplayerid)) {
				GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
				GetPlayerName(playerid, sendername, sizeof(sendername));

				format(string, sizeof(string),"You invited %s in your gang.", giveplayer);
				SendClientMessage(playerid, 0x83BFBFFF, string);
				format(string, sizeof(string),"You got an invitation from %s to enter his gang '%s' (id: %d)", sendername, gangNames[playerGang[playerid]],playerGang[playerid]);
				SendClientMessage(giveplayerid, 0x83BFBFFF, string);

				gangInvite[giveplayerid]=playerGang[playerid];

			} else
				SendClientMessage(playerid, 0x83BFBFFF, "That member doesn't exist !");

		//Parasets//
		} else if (gangcmd==4) {
		    PlayerLeaveGang(playerid);
		}

		return 1;
	}

	//------------------- /claninfo

	if(strcmp(cmd, "/claninfo", true) == 0) {
	    new tmp[256];
	    new gangnum;
		tmp = strtok(cmdtext, idx);

		if(!strlen(tmp) && playerGang[playerid]==0) {
			SendClientMessage(playerid, 0x83BFBFFF, "Write: /ganginfo [Gang ID]");
			return 1;
		} else if (!strlen(tmp))
			gangnum = playerGang[playerid];
		else
			gangnum = strval(tmp);

		if(gangInfo[gangnum][0]==0) {
			SendClientMessage(playerid, 0x83BFBFFF, "This gang ID doesn't exist !");
			return 1;
		}

		format(string, sizeof(string),"'%s' Gang members (id: %d)", gangNames[gangnum], gangnum);
		SendClientMessage(playerid, 0x83BFBFFF, string);

		for(new i = 0; i < gangInfo[gangnum][1]; i++) {
			GetPlayerName(gangMembers[gangnum][i], giveplayer, sizeof(giveplayer));
			format(string, sizeof(string),"%s (%d)", giveplayer, gangMembers[gangnum][i]);
			SendClientMessage(playerid, 0x83BFBFFF, string);
		}

		return 1;
	}

	//------------------- /clans

	if(strcmp(cmd, "/clans", true) == 0)
	{
		new x;

		SendClientMessage(playerid, 0x83BFBFFF, "Existing gangs:");
	    for(new i=0; i < MAX_GANGS; i++) {
			if(gangInfo[i][0]==1) {
				format(string, sizeof(string), "%s%s(%d) - %d members", string,gangNames[i],i,gangInfo[i][1]);

				x++;
				if(x > 2) {
				    SendClientMessage(playerid, 0x83BFBFFF, string);
				    x = 0;
					format(string, sizeof(string), "");
				} else {
					format(string, sizeof(string), "%s, ", string);
				}
			}
		}

		if(x <= 2 && x > 0) {
			string[strlen(string)-2] = '.';
		    SendClientMessage(playerid, 0x83BFBFFF, string);
		}

		return 1;
	}
	return 0;
}

stock PlayerName(playerid) {
  new name[255];
  GetPlayerName(playerid, name, 255);
  return name;
}

public PlayerLeaveGang(playerid) {
	new string[256];
	new playername[MAX_PLAYER_NAME];
	new gangnum = playerGang[playerid];

    if(gangnum > 0) {
		for(new i = 0; i < gangInfo[gangnum][1]; i++) {
			if(gangMembers[gangnum][i]==playerid) {

			    // Only one member
			    gangInfo[gangnum][1]--;

      		    for(new j = i; j < gangInfo[gangnum][1]; j++) {
				    //Shift banda de membri   -------- I dont know this one ... Something about members ans shift xD
				    gangMembers[gangnum][j]=gangMembers[gangnum][j+1];
	    		}

			    //Destroy gang if there's no members
			    if(gangInfo[gangnum][1]<1) {
			        gangInfo[gangnum][0]=0;
			        gangInfo[gangnum][1]=0;
			        gangBank[gangnum]=0;
       			}

				//Warn members
				for(new j = 0; j < gangInfo[gangnum][1]; j++) {
				    GetPlayerName(playerid, playername, MAX_PLAYER_NAME);
					format(string, sizeof(string),"%s left your gang !", playername);
					SendClientMessage(gangMembers[gangnum][j], COLOR_ORANGE, string);
				}

				format(string, sizeof(string),"You left gang '%s'(id: %d)", gangNames[gangnum], gangnum);
				SendClientMessage(playerid, 0x83BFBFFF, string);

				playerGang[playerid]=0;

				SetPlayerColor(playerid,playerColors[playerid]);

				return;
			}
		}
	} else {
		SendClientMessage(playerid, 0x83BFBFFF, "You are not in any gang.");
		}
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
