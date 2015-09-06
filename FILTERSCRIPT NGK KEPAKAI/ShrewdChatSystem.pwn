/*
			+-----------------------------------------------------------+
			|                     Shrewd Chat System                    |
			|                       by varthshenon                      |
			|                        <<<<<<>>>>>>                       |
			|                            V2.1                           |
			|http://forum.sa-mp.com/showthread.php?t=270094             |
			|Stay tuned folks                                           |
			|Thanks to ZeeX for his zcmd                                |
			|Thanks to Y_Less for his sscanf and foreach                |
			|Thanks to varthshenon for his SmartChat                    |
			+-----------------------------------------------------------+
																					*/
#define FILTERSCRIPT

#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <foreach>
#include <SmartChat>

#define SYellow			0xFFFF00FF
#define SRed			0xFF0000FF
#define SPurple			0xFF76FFFF
#define SOrange			0xFF7300FF
#define SGreen			0x00FF00FF

#define at	75//Change 75 to how long the animation will applied you want or comment this line and change them one by one

new ChatState[MAX_PLAYERS char],
	bool:Muted[MAX_PLAYERS char],
	SCSString[129],
	SCSInt,
	Float:SCSPos[3];

public OnFilterScriptInit()
{
	print( "       +-----------------------------------------------------------+       " );
	print( "       |                     Shrewd Chat System                    |       " );
	print( "       |                       by varthshenon                      |       " );
	print( "       |                        <<<<<<>>>>>>                       |       " );
	print( "       |                            V2.1                           |       " );
	print( "       |http://forum.sa-mp.com/showthread.php?t=270094             |       " );
	print( "       |Stay tuned folks                                           |       " );
	print( "       |Thanks to ZeeX for his zcmd                                |       " );
	print( "       |Thanks to Y_Less for his sscanf and foreach                |       " );
	print( "       |Thanks to varthshenon for his SmartChat                    |       " );
	print( "       +-----------------------------------------------------------+       " );
	return 1;
}

public OnFilterScriptExit()
{
	print( "       +-----------------------------------------------------------+       " );
	print( "       |                Shrewd Chat System unloaded                |       " );
	print( "       +-----------------------------------------------------------+       " );
	return 1;
}

public OnPlayerConnect(playerid)
{
	Muted{playerid} = false;
	ChatState{playerid} = 0;
	return 1;
}

public OnDialogResponse(playerid,dialogid,response,listitem,inputtext[])
{
	switch(dialogid)
	{
		case 1000:
		{
			if(!response) return 1;
			ChatState{playerid} = listitem;
			CostumString(SCSString,"You change your chat state to ");
			switch(listitem)
			{
				case 0: strcat(SCSString,"Normal.",sizeof(SCSString));
				case 1: strcat(SCSString,"Low.",sizeof(SCSString));
				case 2: strcat(SCSString,"Shout.",sizeof(SCSString));
				case 3: strcat(SCSString,"Whisper.",sizeof(SCSString));
			}
			SendClientMessage(playerid,SGreen,SCSString);
			return 1;
		}
	}
	return 0;
}

public OnPlayerText(playerid,text[])
{
	switch(ChatState{playerid})
	{
		case 0:
		{
			CostumFormat(SCSString,"%s: %s",GetPlayerNameEx(playerid),text);
			SCGeneral(playerid,SCSString,5,7,10,13,15,SWhite,SChat1,SChat2,SChat3,SChat4);
		}
		case 1:
		{
			CostumFormat(SCSString,"[Low]%s: %s",GetPlayerNameEx(playerid),text);
			SCGeneral(playerid,text,2,4,6,8,10,SWhite,SChat1,SChat2,SChat3,SChat4);
		}
		case 2:
		{
			CostumFormat(SCSString,"[Shouts]%s: %s",GetPlayerNameEx(playerid),text);
			SCGeneral(playerid,text,15,20,25,30,35,SWhite,SChat1,SChat2,SChat3,SChat4);
		}
	}
	SCAnim(playerid,text,at);
	return 0;
}

CMD:b(playerid,params[])
{
	if(isnull(params)) return SendClientMessage(playerid,SYellow,"Usage: /b <text> ~To talk in local OOC chat.");
	CostumFormat(SCSString,"(([%d]%s: %s))",playerid,GetPlayerNameEx(playerid),params);
	SCGeneral(playerid,SCSString,20,0,0,0,0,SWhite,0,0,0,0);
	return 1;
}

CMD:o(playerid,params[])
{
	if(isnull(params)) return SendClientMessage(playerid,SYellow,"Usage: /o(oc) <text> ~To talk in global OOC chat.");
	CostumFormat(SCSString,"(([OOC]%s: %s))",GetPlayerNameEx(playerid),params);
	SCGeneral(playerid,params,-1,0,0,0,0,SWhite,0,0,0,0);
	return 1;
}

CMD:ooc(playerid,params[]) return cmd_o(playerid,params);

CMD:pm(playerid,params[])
{
	if(sscanf(params,"us[129]",SCSInt,params)) return SendClientMessage(playerid,SYellow,"Usage: /pm <playerid> <text> ~To send pm.");
	if(!IsPlayerConnected(SCSInt) || playerid == SCSInt) return SendClientMessage(playerid,SRed,"Error.");
	CostumFormat(SCSString,"(([PM]%s: %s))",GetPlayerNameEx(playerid),params);
	SCMessage(playerid,SCSInt,SCSString,SWhite);
	return 1;
}

CMD:l(playerid,params[])
{
	if(isnull(params)) return SendClientMessage(playerid,SYellow,"Usage: /l(ow) <text> ~To speak low.");
	CostumFormat(SCSString,"[Low]%s: %s",GetPlayerNameEx(playerid),params);
	SCGeneral(playerid,SCSString,2,4,6,8,10,SWhite,SChat1,SChat2,SChat3,SChat4);
	SCAnim(playerid,params,at);
	return 1;
}

CMD:low(playerid,params[]) return cmd_l(playerid,params);

CMD:s(playerid,params[])
{
	if(isnull(params)) return SendClientMessage(playerid,SYellow,"Usage: /s(houts) <text> ~To shouts.");
	CostumFormat(SCSString,"[Shouts]%s: %s",GetPlayerNameEx(playerid),params);
	SCGeneral(playerid,SCSString,15,20,25,30,35,SWhite,SChat1,SChat2,SChat3,SChat4);
	SCAnim(playerid,params,at);
	return 1;
}

CMD:shouts(playerid,params[]) return cmd_s(playerid,params);

CMD:w(playerid,params[])
{
	if(sscanf(params,"us[129]",SCSInt,params)) return SendClientMessage(playerid,SYellow,"Usage: /w(hisper) <playerid> <text> ~To whisper.");
	if(!IsPlayerConnected(SCSInt) || playerid == SCSInt) return SendClientMessage(playerid,SRed,"Error.");
	GetPlayerPos(playerid,SCSPos[0],SCSPos[1],SCSPos[2]);
	if(IsPlayerInRangeOfPoint(SCSInt,3,SCSPos[0],SCSPos[1],SCSPos[2]))
	{
		CostumFormat(SCSString,"[Whisper]%s: %s",GetPlayerNameEx(playerid),params);
		SCMessage(playerid,SCSInt,params,SWhite);
	}
	else SendClientMessage(playerid,SRed,"The player is too far.");
	return 1;
}

CMD:whisper(playerid,params[]) return cmd_w(playerid,params);

CMD:me(playerid,params[])
{
	if(isnull(params)) return SendClientMessage(playerid,SYellow,"Usage: /me <text> ~To tell what you do.");
	CostumFormat(SCSString,"*%s %s*",GetPlayerNameEx(playerid),params);
	SCGeneral(playerid,SCSString,15,0,0,0,0,SPurple,0,0,0,0);
	return 1;
}

CMD:ame(playerid,params[])
{
	if(isnull(params)) return SendClientMessage(playerid,SYellow,"Usage: /ame <text> ~To tell what you do (Above your head).");
	CostumFormat(SCSString,"*%s %s*",GetPlayerNameEx(playerid),params);
	SCBubble(playerid,SCSString,true,SPurple,10,5000);
	return 1;
}

CMD:do(playerid,params[])
{
	if(isnull(params)) return SendClientMessage(playerid,SYellow,"Usage: /do <text> ~To describe something.");
	CostumFormat(SCSString,"*%s ((%s))*",params,GetPlayerNameEx(playerid));
	SCGeneral(playerid,SCSString,15,0,0,0,0,SPurple,0,0,0,0);
	return 1;
}

CMD:chatstate(playerid,params[])
{
	ShowPlayerDialog(playerid,1000,2,"Chat State","Normal\nLow\nShouts","Select","Cancel");
	return 1;
}

CMD:ch(playerid,params[]) return cmd_chatstate(playerid,params);

CMD:mute(playerid,params[])
{
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,SRed,"Only admin can use this command.");
	if(sscanf(params,"u",SCSInt)) return SendClientMessage(playerid,SYellow,"Usage: /mute <playerid> ~To mute/unmute player.");
	if(!IsPlayerConnected(SCSInt)) return SendClientMessage(playerid,SRed,"The player isn't connected.");
	if(Muted{SCSInt} == true)
	{
		Muted{SCSInt} = false;
		format(params,128,"%s has been unmuted by %s",SUName(SCSInt),SUName(playerid));
		SendClientMessageToAll(SOrange,params);
	}
	else
	{
		Muted{SCSInt} = true;
		format(params,128,"%s has been muted by %s",SUName(SCSInt),SUName(playerid));
		SendClientMessageToAll(SOrange,params);
	}
	return 1;
}

CMD:chathelp(playerid,params[])
{
	SendClientMessage(playerid,SYellow,"----------------------Shrewd Chat System V2----------------------");
	SendClientMessage(playerid,SYellow,"Usage: /b <text> ~To talk in local OOC chat.");
	SendClientMessage(playerid,SYellow,"Usage: /o(oc) <text> ~To talk in global OOC chat.");
	SendClientMessage(playerid,SYellow,"Usage: /pm <playerid> <text> ~To send pm.");
	SendClientMessage(playerid,SYellow,"Usage: /l(ow) <text> ~To speak low.");
	SendClientMessage(playerid,SYellow,"Usage: /w(hisper) <playerid> <text> ~To whisper.");
	SendClientMessage(playerid,SYellow,"Usage: /me <text> ~To tell what you do.");
	SendClientMessage(playerid,SYellow,"Usage: /ame <text> ~To tell what you do (Above your head).");
	SendClientMessage(playerid,SYellow,"Usage: /do <text> ~To describe something.");
	SendClientMessage(playerid,SYellow,"Usage: /a(dminchat) <text> ~To talk in admin chat.");
	SendClientMessage(playerid,SYellow,"Usage: /ch(atstate) ~To open chat state dialog.");
	SendClientMessage(playerid,SYellow,"Usage: /mute ~To mute/unmute player.");
	return 1;
}

CMD:adminchat(playerid,params[])
{
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,SRed,"Only admin can use this command.");
	if(isnull(params)) return SendClientMessage(playerid,SYellow,"Usage: /a(adminchat) <text> ~To talk in admin chat.");
	format(params,160,"(([Admin]%s: %s))",GetPlayerNameEx(playerid),params);
	SLog(STimeDate(),params,"Admin Chat.ini");
	AdminChat(params);
	return 1;
}

CMD:a(playerid,params[]) return cmd_adminchat(playerid,params);

stock AdminChat(SCSStringtext[])
{
	foreach(Player,i)
	{
		if(IsPlayerAdmin(i)) SendClientMessage(i,SOrange,SCSStringtext);
	}
	return 1;
}

stock GetPlayerNameEx(playerid)
{
	new pname[MAX_PLAYER_NAME];
	GetPlayerName(playerid,pname,sizeof(pname));
	return pname;
}