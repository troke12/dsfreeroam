#include <a_samp>
#include <Dini>
#define PlayerFile 	       		"SFPD/%s.ini"
#define COLOR_RED 0xAA3333AA
#define COLOR_YELLOW 0xFFFF00AA
#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
enum PLAYER_MAIN {
    Deposit,
};
new pInfo[MAX_PLAYERS][PLAYER_MAIN];
new GetinBank;
new GetoutBank;
new chosenpid;
public OnFilterScriptInit()
{
print("\n**************");
print("*EBank Loaded*");
print("**************\n");
GetinBank = CreatePickup(1318, 1, -1754.639160, 964.123535, 24.890625, 0);
GetoutBank = CreatePickup(1318, 1, 246.476470, 107.329185, 1003.218750, 0);
SetTimer("CallConnect",1,0);
return 1;
}
forward CallConnect(playerid);
public CallConnect(playerid)
{
for(new i = 0; i < MAX_PLAYERS; i++)
{
OnPlayerConnect(i);
}
return 1;
}
public OnPlayerConnect(playerid)
{
    SetPlayerMapIcon(playerid, 12, -1587.5067138672, 891.27478027344, 47.21875, 52, 1);
  	new file[100],Name[MAX_PLAYER_NAME]; GetPlayerName(playerid,Name,sizeof(Name)); format(file,sizeof(file),PlayerFile,Name);
	if(!dini_Exists(file)) {
		dini_Create(file);
		dini_IntSet(file,"Deposit",pInfo[playerid][Deposit]);
	}
	else if(dini_Exists(file))
	{
	pInfo[playerid][Deposit] = dini_Int(file,"Deposit");
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
return 1;
}
public OnPlayerPickUpPickup(playerid,pickupid)
{
if(pickupid == GetinBank)
{
SetPlayerPos(playerid,246.389633,110.552650, 1003.218750);
SetPlayerInterior(playerid, 10);
SetCameraBehindPlayer(playerid);
return 0;
}
if(pickupid == GetoutBank)
{
SetPlayerPos(playerid,-1753.345581,957.547729, 24.882812);
SetPlayerFacingAngle(playerid,0.0);
SetPlayerInterior(playerid, 0);
SetCameraBehindPlayer(playerid);
return 0;
}
return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
 	new file[100],Name[MAX_PLAYER_NAME]; GetPlayerName(playerid,Name,sizeof(Name)); format(file,sizeof(file),PlayerFile,Name);
	dini_IntSet(file,"Deposit",pInfo[playerid][Deposit]);
	return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == 1122) //deposit
    {
 		new file[100],Name[MAX_PLAYER_NAME]; GetPlayerName(playerid,Name,sizeof(Name)); format(file,sizeof(file),PlayerFile,Name);
        if(!response) return ShowPlayerDialog(playerid,1125,DIALOG_STYLE_LIST,"Bank","Deposit\nWithdraw\nBalance\nTransfer","Select","Cancel");
        else if(strval(inputtext) > GetPlayerMoney(playerid)) return SendClientMessage(playerid,COLOR_RED,"You Don't Have That Amount!");
        else if(!IsNumeric(inputtext))
        {
        new string[128];
        format(string,sizeof(string),"Your Curret Balance Is : %d\nEnter The Amount You Want To Deposit Below :",pInfo[playerid][Deposit]);
       	ShowPlayerDialog(playerid,1122,DIALOG_STYLE_INPUT,"Deposit",string,"Deposit","Back");
        SendClientMessage(playerid,COLOR_RED,"Please Use Numbers");
        }
		else
		{
  		GivePlayerMoney(playerid,-strval(inputtext));
		pInfo[playerid][Deposit] += strval(inputtext);
		new string[128];
		format(string,sizeof(string),"You Have Deposited : %d$",strval(inputtext));
		SendClientMessage(playerid,COLOR_YELLOW,string);
		dini_IntSet(file,"Deposit",pInfo[playerid][Deposit]);
		new string2[128]; format(string2,128,"Your New Balance Is : %d$",pInfo[playerid][Deposit]);
		SendClientMessage(playerid,COLOR_YELLOW,string2);
		ShowPlayerDialog(playerid,1125,DIALOG_STYLE_LIST,"Bank","Deposit\nWithdraw\nBalance\nTransfer","Select","Cancel");
		}
		return 1;
    }
	if(dialogid == 1123) //withdraw
	{
  		new file[100],Name[MAX_PLAYER_NAME]; GetPlayerName(playerid,Name,sizeof(Name)); format(file,sizeof(file),PlayerFile,Name);
     	if(!response) return ShowPlayerDialog(playerid,1125,DIALOG_STYLE_LIST,"Bank","Deposit\nWithdraw\nBalance\nTransfer","Select","Cancel");
     	else if(strval(inputtext) > pInfo[playerid][Deposit]) return SendClientMessage(playerid,COLOR_RED,"You Don't Have That Amount In Bank!");
        else if(!IsNumeric(inputtext))
        {
        new string[128];
        format(string,sizeof(string),"Your Current Balance Is :%d\nEnter The Amount You Want To Withdraw Below :",pInfo[playerid][Deposit]);
        ShowPlayerDialog(playerid,1123,DIALOG_STYLE_INPUT,"Withdraw",string,"Withdraw","Back");
        SendClientMessage(playerid,COLOR_RED,"Please Use Numbers");
        }
		else
		{
		GivePlayerMoney(playerid,strval(inputtext));
		pInfo[playerid][Deposit] -= strval(inputtext);
		new string[128];
		format(string,sizeof(string),"You Have Withdrawed : %d$",strval(inputtext));
		SendClientMessage(playerid,COLOR_YELLOW,string);
		dini_IntSet(file,"Deposit",pInfo[playerid][Deposit]);
		new string2[128]; format(string2,128,"Your New Balance Is : %d$",pInfo[playerid][Deposit]);
		SendClientMessage(playerid,COLOR_YELLOW,string2);
		ShowPlayerDialog(playerid,1125,DIALOG_STYLE_LIST,"Bank","Deposit\nWithdraw\nBalance\nTransfer","Select","Cancel");
		}
		return 1;
	}
	if(dialogid == 1124)
	{
	if(!response) return ShowPlayerDialog(playerid,1125,DIALOG_STYLE_LIST,"Bank","Deposit\nWithdraw\nBalance\nTransfer","Select","Cancel");
	else
	{
    ShowPlayerDialog(playerid,1125,DIALOG_STYLE_LIST,"Bank","Deposit\nWithdraw\nBalance\nTransfer","Select","Cancel");
    }
    return 1;
    }
    if(dialogid == 1130) //transfer (choose playerid)
	{
     	if(!response) return ShowPlayerDialog(playerid,1125,DIALOG_STYLE_LIST,"Bank","Deposit\nWithdraw\nBalance\nTransfer","Select","Cancel");
     	else if(strval(inputtext) == INVALID_PLAYER_ID) return SendClientMessage(playerid,COLOR_RED,"Player Not Online");
        else if(!IsNumeric(inputtext))
        {
        new string[128];
	    format(string,sizeof(string),"Your Current Balance Is :%d$\nEnter The Player ID You Want To Transfer To Below :",pInfo[playerid][Deposit]);
	    ShowPlayerDialog(playerid,1130,DIALOG_STYLE_INPUT,"Transfer",string,"Next","Back");
        SendClientMessage(playerid,COLOR_RED,"Please Use ID Not Name");
        }
		else
		{
		chosenpid = strval(inputtext);
		new string[128];
		format(string,sizeof(string),"Balance : %d\nChosen Player ID : %d\nNow Enter The Amount You Want To Transfer",pInfo[playerid][Deposit],chosenpid);
		ShowPlayerDialog(playerid,1131,DIALOG_STYLE_INPUT,"Transfer",string,"Transfer","Back");
		}
		return 1;
	}
	if(dialogid == 1131) //transfer (choose amount)
	{
  		new file[100],Name[MAX_PLAYER_NAME]; GetPlayerName(playerid,Name,sizeof(Name)); format(file,sizeof(file),PlayerFile,Name);
     	if(!response) return ShowPlayerDialog(playerid,1125,DIALOG_STYLE_LIST,"Bank","Deposit\nWithdraw\nBalance\nTransfer","Select","Cancel");
     	else if(strval(inputtext) > pInfo[playerid][Deposit]) return SendClientMessage(playerid,COLOR_RED,"You Don't Have That Amount In Bank To Transfer");
        else if(!IsNumeric(inputtext))
        {
        new string[128];
		format(string,sizeof(string),"Chosen Player ID : %d\nNow Enter The Amount You Want To Transfer",chosenpid);
		ShowPlayerDialog(playerid,1131,DIALOG_STYLE_INPUT,"Transfer",string,"Transfer","Back");
        SendClientMessage(playerid,COLOR_RED,"Please Use Numbers");
        }
		else
		{
		pInfo[playerid][Deposit] -= strval(inputtext);
		pInfo[chosenpid][Deposit] += strval(inputtext);
		new string[128];
		format(string,sizeof(string),"You Transfered %d$ To ID %d Bank Account",strval(inputtext),chosenpid);
		SendClientMessage(playerid,COLOR_YELLOW,string);
		dini_IntSet(file,"Deposit",pInfo[playerid][Deposit]);
		new string2[128]; format(string2,128,"Your New Balance Is : %d$",pInfo[playerid][Deposit]);
		SendClientMessage(playerid,COLOR_YELLOW,string2);
		new string3[128]; format(string3,128,"ID : %d Transfered %d$ To Your Bank Account",playerid,strval(inputtext));
		SendClientMessage(chosenpid,COLOR_YELLOW,string3);
		new string4[128]; format(string4,128,"Your New Balance : %d$",pInfo[chosenpid][Deposit]);
		SendClientMessage(chosenpid,COLOR_YELLOW,string4);
		ShowPlayerDialog(playerid,1125,DIALOG_STYLE_LIST,"Bank","Deposit\nWithdraw\nBalance\nTransfer","Select","Cancel");
		}
		return 1;
	}
	if(dialogid == 1125 && response) // /bank
		 {
		 	switch(listitem)
	    	{
	        	case 0:
		        {
		            new string[128];
		            format(string,sizeof(string),"Your Curret Balance Is : %d$\nEnter The Amount You Want To Deposit Below :",pInfo[playerid][Deposit]);
	              	ShowPlayerDialog(playerid,1122,DIALOG_STYLE_INPUT,"Deposit",string,"Deposit","Back");

	 			}
	 			case 1:
		        {
		            new string[128];
		            format(string,sizeof(string),"Your Current Balance Is :%d\nEnter The Amount You Want To Withdraw Below :",pInfo[playerid][Deposit]);
		            ShowPlayerDialog(playerid,1123,DIALOG_STYLE_INPUT,"Withdraw",string,"Withdraw","Back");
	 			}
	 			case 2:
		        {
	              	new string[128];
					format(string,sizeof(string),"Your Balance Is %d$",pInfo[playerid][Deposit]);
					ShowPlayerDialog(playerid,1124,DIALOG_STYLE_MSGBOX,"Balance",string,"Ok","Back");
	 			}
	 			case 3:
		        {
					new string[128];
		            format(string,sizeof(string),"Your Current Balance Is :%d$\nEnter The Player ID You Want To Transfer To Below :",pInfo[playerid][Deposit]);
		            ShowPlayerDialog(playerid,1130,DIALOG_STYLE_INPUT,"Transfer",string,"Next","Back");
	 			}
	 		}
	 	}
	return 0;
}
public OnPlayerCommandText(playerid, cmdtext[])
{
dcmd(io,4,cmdtext);
dcmd(is,8,cmdtext);
return 0;
}
dcmd_io(playerid,params[])
{
#pragma unused params
if(!IsPlayerInRangeOfPoint(playerid,15.0,2313,-4, 27)) return SendClientMessage(playerid,COLOR_RED,"You Have To Be In The Bank");
else
{
ShowPlayerDialog(playerid,1125,DIALOG_STYLE_LIST,"Bank","Deposit\nWithdraw\nBalance\nTransfer","Select","Cancel");
}
return 1;
}
dcmd_is(playerid,params[])
{
#pragma unused params
SetPlayerPos(playerid,-1581.0819091797,907.59637451172, 7.6953125);
SendClientMessage(playerid,COLOR_YELLOW,"Welcome To Bank");
SetPlayerFacingAngle(playerid,180.0);
SetCameraBehindPlayer(playerid);
return 1;
}


//------------------[SSCANF]-------------------------------------
stock sscanf(string[], format[], {Float,_}:...)
{
	#if defined isnull
		if (isnull(string))
	#else
		if (string[0] == 0 || (string[0] == 1 && string[1] == 0))
	#endif
		{
			return format[0];
		}
	#pragma tabsize 4
	new
		formatPos = 0,
		stringPos = 0,
		paramPos = 2,
		paramCount = numargs(),
		delim = ' ';
	while (string[stringPos] && string[stringPos] <= ' ')
	{
		stringPos++;
	}
	while (paramPos < paramCount && string[stringPos])
	{
		switch (format[formatPos++])
		{
			case '\0':
			{
				return 0;
			}
			case 'i', 'd':
			{
				new
					neg = 1,
					num = 0,
					ch = string[stringPos];
				if (ch == '-')
				{
					neg = -1;
					ch = string[++stringPos];
				}
				do
				{
					stringPos++;
					if ('0' <= ch <= '9')
					{
						num = (num * 10) + (ch - '0');
					}
					else
					{
						return -1;
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num * neg);
			}
			case 'h', 'x':
			{
				new
					num = 0,
					ch = string[stringPos];
				do
				{
					stringPos++;
					switch (ch)
					{
						case 'x', 'X':
						{
							num = 0;
							continue;
						}
						case '0' .. '9':
						{
							num = (num << 4) | (ch - '0');
						}
						case 'a' .. 'f':
						{
							num = (num << 4) | (ch - ('a' - 10));
						}
						case 'A' .. 'F':
						{
							num = (num << 4) | (ch - ('A' - 10));
						}
						default:
						{
							return -1;
						}
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num);
			}
			case 'c':
			{
				setarg(paramPos, 0, string[stringPos++]);
			}
			case 'f':
			{

				new changestr[16], changepos = 0, strpos = stringPos;
				while(changepos < 16 && string[strpos] && string[strpos] != delim)
				{
					changestr[changepos++] = string[strpos++];
    				}
				changestr[changepos] = '\0';
				setarg(paramPos,0,_:floatstr(changestr));
			}
			case 'p':
			{
				delim = format[formatPos++];
				continue;
			}
			case '\'':
			{
				new
					end = formatPos - 1,
					ch;
				while ((ch = format[++end]) && ch != '\'') {}
				if (!ch)
				{
					return -1;
				}
				format[end] = '\0';
				if ((ch = strfind(string, format[formatPos], false, stringPos)) == -1)
				{
					if (format[end + 1])
					{
						return -1;
					}
					return 0;
				}
				format[end] = '\'';
				stringPos = ch + (end - formatPos);
				formatPos = end + 1;
			}
			case 'u':
			{
				new
					end = stringPos - 1,
					id = 0,
					bool:num = true,
					ch;
				while ((ch = string[++end]) && ch != delim)
				{
					if (num)
					{
						if ('0' <= ch <= '9')
						{
							id = (id * 10) + (ch - '0');
						}
						else
						{
							num = false;
						}
					}
				}
				if (num && IsPlayerConnected(id))
				{
					setarg(paramPos, 0, id);
				}
				else
				{
					#if !defined foreach
						#define foreach(%1,%2) for (new %2 = 0; %2 < MAX_PLAYERS; %2++) if (IsPlayerConnected(%2))
						#define __SSCANF_FOREACH__
					#endif
					string[end] = '\0';
					num = false;
					new
						name[MAX_PLAYER_NAME];
					id = end - stringPos;
					foreach (Player, playerid)
					{
      GetPlayerName(playerid, name, sizeof (name));
						if (!strcmp(name, string[stringPos], true, id))
						{
							setarg(paramPos, 0, playerid);
							num = true;
							break;
						}
					}
					if (!num)
					{
						setarg(paramPos, 0, INVALID_PLAYER_ID);
					}
					string[end] = ch;
					#if defined __SSCANF_FOREACH__
						#undef foreach
						#undef __SSCANF_FOREACH__
					#endif
				}
				stringPos = end;
			}
			case 's', 'z':
			{
				new
					i = 0,
					ch;
				if (format[formatPos])
				{
					while ((ch = string[stringPos++]) && ch != delim)
					{
						setarg(paramPos, i++, ch);
					}
					if (!i)
					{
						return -1;
					}
				}
				else
				{
					while ((ch = string[stringPos++]))
					{
						setarg(paramPos, i++, ch);
					}
				}
				stringPos--;
				setarg(paramPos, i, '\0');
			}
			default:
			{
				continue;
			}
		}
		while (string[stringPos] && string[stringPos] != delim && string[stringPos] > ' ')
		{
			stringPos++;
		}
		while (string[stringPos] && (string[stringPos] == delim || string[stringPos] <= ' '))
		{
			stringPos++;
		}
		paramPos++;
	}
	do
	{
		if ((delim = format[formatPos++]) > ' ')
		{
			if (delim == '\'')
			{
				while ((delim = format[formatPos++]) && delim != '\'') {}
			}
			else if (delim != 'z')
			{
				return delim;
			}
		}
	}
	while (delim > ' ');
	return 0;
}
stock IsNumeric(string[])
{
	for (new i = 0, j = strlen(string); i < j; i++)
	{
		if (string[i] > '9' || string[i] < '0') return 0;
	}
	return 1;
}
