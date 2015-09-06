/*  rconmanager.pwn
 *
 *  (c) Copyright 2009, Emilijo "Correlli" Lovrich
 *
 *  Credits: - Y_Less for sscanf & foreach function,
			 - DracoBlue for dcmd.
*/

#include "a_samp"
#include "sscanf"
#include "foreach"

forward Float:GetPlayerPosX(playerid);
forward Float:GetPlayerPosY(playerid);
forward Float:GetPlayerPosZ(playerid);

new
		FALSE = 0;

#if !defined RCMD_PREFIX
	#define RCMD_PREFIX "/"
#endif

#if !defined rcmd // RCON command processor by Emilijo "Correlli" Lovrich, modified from DracoBlue's DCMD command processor.
	#define rcmd(%1,%2,%3) if((strcmp((%3), RCMD_PREFIX #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (rcmd_%1(""))) || (((%3)[(%2) + 1] == 32) && (rcmd_%1((%3)[(%2) + 2]))))) return true
#endif

#if !defined MAX_IO
	#define MAX_IO (128)
#endif

#if !defined MAX_ALLOWED_HEALTH
	#define MAX_ALLOWED_HEALTH (100)
#endif

#if !defined MAX_ALLOWED_ARMOR
	#define MAX_ALLOWED_ARMOR (100)
#endif

#if !defined SendClientMessageEx
	#define SendClientMessageEx(%0,%1,%2,%3) \
	do \
	{ \
		new \
			string[MAX_IO]; \
		if(strlen(%2) > 0) \
		{ \
			format(string, sizeof(string), %2, %3); \
			SendClientMessage(%0, %1, string); \
		} \
	} \
	while(FALSE)
#endif

#if !defined SendClientMessageToAllOther
	#define SendClientMessageToAllOther(%0,%1,%2,%3) \
	do \
	{ \
		new \
				string[MAX_IO]; \
		if(strlen(%2) > 0) \
		{ \
			format(string, sizeof(string), %2, %3); \
			foreach(Player, u) \
			{ \
				if(%0 != u) SendClientMessage(u, %1, string); \
			} \
		} \
	} \
	while(FALSE)
#endif

#if !defined SendRconCommandEx
	#define SendRconCommandEx(%0,%1) \
	do \
	{ \
		new \
				string[MAX_IO / 2]; \
		if(strlen(%0) > 0) \
		{ \
			format(string, sizeof(string), %0, %1); \
			SendRconCommand(string); \
		} \
	} \
	while(FALSE)
#endif

public OnFilterScriptInit()
{
	printf("-> RCON-manager filterscript v1.0 by Emilijo \"Correlli\" Lovrich is loaded!");
	return true;
}

public OnFilterScriptExit()
{
	printf("-> RCON-manager filterscript v1.0 by Emilijo \"Correlli\" Lovrich is unloaded!");
	return true;
}

public OnRconCommand(cmd[])
{
	rcmd(cmdlist, 7, cmd);
	rcmd(msg, 3, cmd);
	rcmd(msgall, 6, cmd);
	rcmd(kick, 4, cmd);
	rcmd(kickall, 7, cmd);
	rcmd(ban, 3, cmd);
	rcmd(banall, 6, cmd);
	rcmd(kill, 4, cmd);
	rcmd(killall, 7, cmd);
	rcmd(freeze, 6, cmd);
	rcmd(freezeall, 9, cmd);
	rcmd(unfreeze, 8, cmd);
	rcmd(unfreezeall, 11, cmd);
	rcmd(slap, 4, cmd);
	rcmd(slapall, 7, cmd);
	rcmd(sethealth, 9, cmd);
	rcmd(sethealthall, 12, cmd);
	rcmd(givehealth, 10, cmd);
	rcmd(givehealthall, 13, cmd);
	rcmd(setarmor, 8, cmd);
	rcmd(setarmorall, 11, cmd);
	rcmd(givearmor, 9, cmd);
	rcmd(givearmorall, 12, cmd);
	rcmd(setmoney, 8, cmd);
	rcmd(setmoneyall, 11, cmd);
	rcmd(givemoney, 9, cmd);
	rcmd(givemoneyall, 12, cmd);
	rcmd(setscore, 8, cmd);
	rcmd(setscoreall, 11, cmd);
	rcmd(givescore, 9, cmd);
	rcmd(givescoreall, 12, cmd);
	rcmd(infoplayer, 10, cmd);
	rcmd(setserverpass, 13, cmd);
	rcmd(setservername, 13, cmd);
	rcmd(setservergamemode, 17, cmd);
	rcmd(setservermap, 12, cmd);
	rcmd(setplayerweather, 16, cmd);
	rcmd(setweather, 10, cmd);
	rcmd(setgravity, 10, cmd);
	return false;
}

rcmd_cmdlist(command[])
{
	#pragma unused command
	printf("RCON-COMMANDS - Commands for player:");
	printf("	%smsg   %skick   %sban   %skill   %sfreeze", RCMD_PREFIX, RCMD_PREFIX, RCMD_PREFIX, RCMD_PREFIX, RCMD_PREFIX);
	printf("	%sunfreeze   %sslap   %ssethealth   %sgivehealth   %ssetarmor", RCMD_PREFIX, RCMD_PREFIX, RCMD_PREFIX, RCMD_PREFIX, RCMD_PREFIX);
	printf("	%sgivearmor   %ssetmoney   %sgivemoney", RCMD_PREFIX, RCMD_PREFIX, RCMD_PREFIX);
	printf("	%ssetscore   %sgivescore   %sinfoplayer", RCMD_PREFIX, RCMD_PREFIX, RCMD_PREFIX);
	printf("RCON-COMMANDS - Commands for all players:");
	printf("	%smsgall   %skickall   %sbanall   %skillall   %sfreezeall", RCMD_PREFIX, RCMD_PREFIX, RCMD_PREFIX, RCMD_PREFIX, RCMD_PREFIX);
	printf("	%sunfreezeall   %sslapall   %ssethealthall   %sgivehealthall   %ssetarmorall", RCMD_PREFIX, RCMD_PREFIX, RCMD_PREFIX, RCMD_PREFIX, RCMD_PREFIX);
	printf("	%sgivearmorall   %ssetmoneyall   %sgivemoneyall", RCMD_PREFIX, RCMD_PREFIX, RCMD_PREFIX);
	printf("	%ssetscoreall   %sgivescoreall", RCMD_PREFIX, RCMD_PREFIX);
	printf("RCON-COMMANDS - Other commands:");
	printf("	%ssetserverpass   %ssetservername   %ssetservergamemode   %ssetservermap", RCMD_PREFIX, RCMD_PREFIX, RCMD_PREFIX, RCMD_PREFIX);
	return true;
}

rcmd_msg(command[])
{
	new
			toplayerid, msg[64];
	if(sscanf(command, "us[64]", toplayerid, msg))
		return printf("Correct usage: \"%smsg [playername or playerid] [message]\"", RCMD_PREFIX);
	if(!IsPlayerConnected(toplayerid))
		return printf("RCON-ERROR: That player is not connected to the server!");
	SendClientMessageEx(toplayerid, 0xFF0000AA, "* PM from RCON-CONSOLE: %s", msg);
	printf("RCON-CONSOLE: Message to player %s was sent: %s", PlayerName(toplayerid), msg);
	return true;
}

rcmd_msgall(command[])
{
	new
			msg[64];
	if(sscanf(command, "s[64]", msg)) return printf("Correct usage: \"%smsgall [message]\"", RCMD_PREFIX);
	foreach(Player, u) SendClientMessageEx(u, 0xFF0000AA, "* PM from RCON-CONSOLE: %s", msg);
	printf("RCON-CONSOLE: Message was sent to everyone: %s", msg);
	return true;
}

rcmd_kick(command[])
{
	new
			toplayerid, reason[64];
	if(sscanf(command, "us[64]", toplayerid, reason))
		return printf("Correct usage: \"%skick [playername or playerid] [reason]\"", RCMD_PREFIX);
	if(!IsPlayerConnected(toplayerid))
		return printf("RCON-ERROR: That player is not connected to the server!");
	SendClientMessageEx(toplayerid, 0xFF0000AA, "RCON-CONSOLE: You have been KICKED from the server by RCON-CONSOLE, reason: %s", reason);
	SendClientMessageToAllOther(toplayerid, 0xFF0000AA, "RCON-CONSOLE: %s has been KICKED from the server by RCON-CONSOLE, reason: %s", PlayerName(toplayerid), reason);
	printf("RCON-CONSOLE: You have KICKED player %s from the server, reason: %s", PlayerName(toplayerid), reason);
	Kick(toplayerid);
	return true;
}

rcmd_kickall(command[])
{
	new
			reason[64];
	if(sscanf(command, "s[64]", reason)) return printf("Correct usage: \"%skickall [reason]\"", RCMD_PREFIX);
	foreach(Player, u)
	{
		SendClientMessageEx(u, 0xFF0000AA, "RCON-CONSOLE: Everyone has been KICKED from the server, reason: %s", reason);
		Kick(u);
	}
	printf("RCON-CONSOLE: You have KICKED everyone from the server, reason: %s", reason);
	return true;
}

rcmd_ban(command[])
{
	new
			toplayerid, reason[64];
	if(sscanf(command, "us[64]", toplayerid, reason))
		return printf("Correct usage: \"%sban [playername or playerid] [reason]\"", RCMD_PREFIX);
	if(!IsPlayerConnected(toplayerid))
		return printf("RCON-ERROR: That player is not connected to the server!");
	SendClientMessageEx(toplayerid, 0xFF0000AA, "RCON-CONSOLE: You have been BANNED from the server by RCON-CONSOLE, reason: %s", reason);
	SendClientMessageToAllOther(toplayerid, 0xFF0000AA, "RCON-CONSOLE: %s has been BANNED from the server by RCON-CONSOLE, reason: %s", PlayerName(toplayerid), reason);
	printf("RCON-CONSOLE: You have BANNED player %s from the server, reason: %s", PlayerName(toplayerid), reason);
	Ban(toplayerid);
	return true;
}

rcmd_banall(command[])
{
	new
			reason[64];
	if(sscanf(command, "s[64]", reason)) return printf("Correct usage: \"%sbanall [reason]\"", RCMD_PREFIX);
	foreach(Player, u)
	{
		SendClientMessageEx(u, 0xFF0000AA, "RCON-CONSOLE: Everyone has been BANNED from the server, reason: %s", reason);
		Ban(u);
	}
	printf("RCON-CONSOLE: You have BANNED everyone from the server, reason: %s", reason);
	return true;
}

rcmd_kill(command[])
{
	new
			toplayerid, reason[64];
	if(sscanf(command, "us[64]", toplayerid, reason))
		return printf("Correct usage: \"%skill [playername or playerid] [reason]\"", RCMD_PREFIX);
	if(!IsPlayerConnected(toplayerid))
		return printf("RCON-ERROR: That player is not connected to the server!");
	SendClientMessageEx(toplayerid, 0xFF0000AA, "RCON-CONSOLE: You have been KILLED by RCON-CONSOLE, reason: %s", reason);
	SendClientMessageToAllOther(toplayerid, 0xFF0000AA, "RCON-CONSOLE: %s has been KILLED by RCON-CONSOLE, reason: %s", PlayerName(toplayerid), reason);
	printf("RCON-CONSOLE: You have KILLED player %s, reason: %s", PlayerName(toplayerid), reason);
	KillPlayer(toplayerid);
	return true;
}

rcmd_killall(command[])
{
	new
			reason[64];
	if(sscanf(command, "s[64]", reason)) return printf("Correct usage: \"%skillall [reason]\"", RCMD_PREFIX);
	foreach(Player, u)
	{
		SendClientMessageEx(u, 0xFF0000AA, "RCON-CONSOLE: Everyone has been KILLED by RCON-CONSOLE, reason: %s", reason);
		KillPlayer(u);
	}
	printf("RCON-CONSOLE: You have KILLED everyone on the server, reason: %s", reason);
	return true;
}

rcmd_freeze(command[])
{
	new
			toplayerid, reason[64];
	if(sscanf(command, "us[64]", toplayerid, reason))
		return printf("Correct usage: \"%sfreeze [playername or playerid] [reason]\"", RCMD_PREFIX);
	if(!IsPlayerConnected(toplayerid))
		return printf("RCON-ERROR: That player is not connected to the server!");
	SendClientMessageEx(toplayerid, 0xFF0000AA, "RCON-CONSOLE: You have been FREEZED by RCON-CONSOLE, reason: %s", reason);
	SendClientMessageToAllOther(toplayerid, 0xFF0000AA, "RCON-CONSOLE: %s has been FREEZED by RCON-CONSOLE, reason: %s", PlayerName(toplayerid), reason);
	printf("RCON-CONSOLE: You have FREEZED player %s, reason: %s", PlayerName(toplayerid), reason);
	FreezePlayer(toplayerid);
	return true;
}

rcmd_freezeall(command[])
{
	new
			reason[64];
	if(sscanf(command, "s[64]", reason)) return printf("Correct usage: \"%sfreezeall [reason]\"", RCMD_PREFIX);
	foreach(Player, u)
	{
		SendClientMessageEx(u, 0xFF0000AA, "RCON-CONSOLE: Everyone has been FREEZED by RCON-CONSOLE, reason: %s", reason);
		FreezePlayer(u);
	}
	printf("RCON-CONSOLE: You have FREEZED everyone on the server, reason: %s", reason);
	return true;
}

rcmd_unfreeze(command[])
{
	new
			toplayerid, reason[64];
	if(sscanf(command, "us[64]", toplayerid, reason))
		return printf("Correct usage: \"%sunfreeze [playername or playerid] [reason]\"", RCMD_PREFIX);
	if(!IsPlayerConnected(toplayerid))
		return printf("RCON-ERROR: That player is not connected to the server!");
	SendClientMessageEx(toplayerid, 0xFF0000AA, "RCON-CONSOLE: You have been UNFREEZED by RCON-CONSOLE, reason: %s", reason);
	SendClientMessageToAllOther(toplayerid, 0xFF0000AA, "RCON-CONSOLE: %s has been UNFREEZED by RCON-CONSOLE, reason: %s", PlayerName(toplayerid), reason);
	printf("RCON-CONSOLE: You have UNFREEZED player %s, reason: %s", PlayerName(toplayerid), reason);
	UnfreezePlayer(toplayerid);
	return true;
}

rcmd_unfreezeall(command[])
{
	new
			reason[64];
	if(sscanf(command, "s[64]", reason)) return printf("Correct usage: \"%sunfreezeall [reason]\"", RCMD_PREFIX);
	foreach(Player, u)
	{
		SendClientMessageEx(u, 0xFF0000AA, "RCON-CONSOLE: Everyone has been UNFREEZED by RCON-CONSOLE, reason: %s", reason);
		UnfreezePlayer(u);
	}
	printf("RCON-CONSOLE: You have UNFREEZED everyone on the server, reason: %s", reason);
	return true;
}

rcmd_slap(command[])
{
	new
			toplayerid, reason[64];
	if(sscanf(command, "us[64]", toplayerid, reason))
		return printf("Correct usage: \"%sslap [playername or playerid] [reason]\"", RCMD_PREFIX);
	if(!IsPlayerConnected(toplayerid))
		return printf("RCON-ERROR: That player is not connected to the server!");
	SendClientMessageEx(toplayerid, 0xFF0000AA, "RCON-CONSOLE: You have been SLAPPED by RCON-CONSOLE, reason: %s", reason);
	SendClientMessageToAllOther(toplayerid, 0xFF0000AA, "RCON-CONSOLE: %s has been SLAPPED by RCON-CONSOLE, reason: %s", PlayerName(toplayerid), reason);
	printf("RCON-CONSOLE: You have SLAPPED player %s, reason: %s", PlayerName(toplayerid), reason);
	SetPlayerHealth(toplayerid, PlayerHealth(toplayerid) - 20.0);
	return true;
}

rcmd_slapall(command[])
{
	new
			reason[64];
	if(sscanf(command, "s[64]", reason)) return printf("Correct usage: \"%sslapall [reason]\"", RCMD_PREFIX);
	foreach(Player, u)
	{
		SendClientMessageEx(u, 0xFF0000AA, "RCON-CONSOLE: Everyone has been SLAPPED by RCON-CONSOLE, reason: %s", reason);
		SetPlayerHealth(u, PlayerHealth(u) - 20.0);
	}
	printf("RCON-CONSOLE: You have SLAPPED everyone on the server, reason: %s", reason);
	return true;
}

rcmd_sethealth(command[])
{
	new
			toplayerid, amount, reason[64];
	if(sscanf(command, "uis[64]", toplayerid, amount, reason))
		return printf("Correct usage: \"%ssethealth [playername or playerid] [amount] [reason]\"", RCMD_PREFIX);
	if(!IsPlayerConnected(toplayerid))
		return printf("RCON-ERROR: That player is not connected to the server!");
	if(amount >= 0 && amount <= MAX_ALLOWED_HEALTH)
	{
		SendClientMessageEx(toplayerid, 0xFF0000AA, "RCON-CONSOLE: Your health has been setted to %i/%i by RCON-CONSOLE, reason: %s", amount, MAX_ALLOWED_HEALTH, reason);
		SendClientMessageToAllOther(toplayerid, 0xFF0000AA, "RCON-CONSOLE: %s's health was setted to %i/%i by RCON-CONSOLE, reason: %s", PlayerName(toplayerid), amount, MAX_ALLOWED_HEALTH, reason);
		printf("RCON-CONSOLE: You have setted player %s's health to %i/%i, reason: %s", PlayerName(toplayerid), amount, MAX_ALLOWED_HEALTH, reason);
		SetPlayerHealth(toplayerid, amount);
	}
	else
	{
		printf("RCON-ERROR: Valid health value is from 0 to %i.", MAX_ALLOWED_HEALTH);
		printf("RCON-ERROR: If you want to change the value, open the script and change the MAX_ALLOWED_HEALTH define.");
	}
	return true;
}

rcmd_sethealthall(command[])
{
	new
			amount, reason[64];
	if(sscanf(command, "is[64]", amount, reason)) return printf("Correct usage: \"%ssethealthall [amount] [reason]\"", RCMD_PREFIX);
	if(amount >= 0 && amount <= MAX_ALLOWED_HEALTH)
	{
		foreach(Player, u)
		{
			SendClientMessageEx(u, 0xFF0000AA, "RCON-CONSOLE: Your health has been setted to %i/%i by RCON-CONSOLE, reason: %s", amount, MAX_ALLOWED_HEALTH, reason);
			SetPlayerHealth(u, amount);
		}
		printf("RCON-CONSOLE: You have setted everyone's health to %i/%i, reason: %s", amount, MAX_ALLOWED_HEALTH, reason);
	}
	else
	{
		printf("RCON-ERROR: Valid health value is from 0 to %i.", MAX_ALLOWED_HEALTH);
		printf("RCON-ERROR: If you want to change the value, open the script and change the MAX_ALLOWED_HEALTH define.");
	}
	return true;
}

rcmd_givehealth(command[])
{
	new
			toplayerid, amount, reason[64];
	if(sscanf(command, "uis[64]", toplayerid, amount, reason))
		return printf("Correct usage: \"%sgivehealth [playername or playerid] [amount] [reason]\"", RCMD_PREFIX);
	if(!IsPlayerConnected(toplayerid))
		return printf("RCON-ERROR: That player is not connected to the server!");
	if(amount > 0 && amount <= (MAX_ALLOWED_HEALTH - PlayerHealth(toplayerid)))
	{
		SendClientMessageEx(toplayerid, 0xFF0000AA, "RCON-CONSOLE: You have received %i health from RCON-CONSOLE, reason: %s", amount, reason);
		SendClientMessageToAllOther(toplayerid, 0xFF0000AA, "RCON-CONSOLE: %s received %i health from RCON-CONSOLE, reason: %s", PlayerName(toplayerid), amount, reason);
		printf("RCON-CONSOLE: You gave %i health to player %s, reason: %s", amount, PlayerName(toplayerid), reason);
		GivePlayerHealth(toplayerid, amount);
	}
	else
	{
		printf("RCON-ERROR: Valid health value is from 0 to %i.", MAX_ALLOWED_HEALTH);
		printf("RCON-ERROR: If you want to change the value, open the script and change the MAX_ALLOWED_HEALTH define.");
	}
	return true;
}

rcmd_givehealthall(command[])
{
	new
			amount, reason[64];
	if(sscanf(command, "is[64]", amount, reason)) return printf("Correct usage: \"%sgivehealthall [amount] [reason]\"", RCMD_PREFIX);
	foreach(Player, u)
	{
		if(amount > 0 && amount <= (MAX_ALLOWED_HEALTH - PlayerHealth(u)))
		{
			SendClientMessageEx(u, 0xFF0000AA, "RCON-CONSOLE: You have received %i health from RCON-CONSOLE, reason: %s", amount, reason);
			GivePlayerHealth(u, amount);
		}
	}
	printf("RCON-CONSOLE: You gave %i health to everyone, reason: %s", amount, reason);
	return true;
}

rcmd_setarmor(command[])
{
	new
			toplayerid, amount, reason[64];
	if(sscanf(command, "uis[64]", toplayerid, amount, reason))
		return printf("Correct usage: \"%ssetarmor [playername or playerid] [amount] [reason]\"", RCMD_PREFIX);
	if(!IsPlayerConnected(toplayerid))
		return printf("RCON-ERROR: That player is not connected to the server!");
	if(amount >= 0 && amount <= MAX_ALLOWED_ARMOR)
	{
		SendClientMessageEx(toplayerid, 0xFF0000AA, "RCON-CONSOLE: Your armor has been setted to %i/%i by RCON-CONSOLE, reason: %s", amount, MAX_ALLOWED_ARMOR, reason);
		SendClientMessageToAllOther(toplayerid, 0xFF0000AA, "RCON-CONSOLE: %s's armor was setted to %i/%i by RCON-CONSOLE, reason: %s", PlayerName(toplayerid), amount, MAX_ALLOWED_ARMOR, reason);
		printf("RCON-CONSOLE: You have setted player %s's armor to %i/%i, reason: %s", PlayerName(toplayerid), amount, MAX_ALLOWED_ARMOR, reason);
		SetPlayerArmour(toplayerid, amount);
	}
	else
	{
		printf("RCON-ERROR: Valid armor value is from 0 to %i.", MAX_ALLOWED_ARMOR);
		printf("RCON-ERROR: If you want to change the value, open the script and change the MAX_ALLOWED_ARMOR define.");
	}
	return true;
}

rcmd_setarmorall(command[])
{
	new
			amount, reason[64];
	if(sscanf(command, "is[64]", amount, reason))
		return printf("Correct usage: \"%ssetarmorall [amount] [reason]\"", RCMD_PREFIX);
	if(amount >= 0 && amount <= MAX_ALLOWED_ARMOR)
	{
		foreach(Player, u)
		{
			SendClientMessageEx(u, 0xFF0000AA, "RCON-CONSOLE: Your armor has been setted to %i/%i by RCON-CONSOLE, reason: %s", amount, MAX_ALLOWED_ARMOR, reason);
			SetPlayerArmour(u, amount);
		}
		printf("RCON-CONSOLE: You have setted everyone's armor to %i/%i, reason: %s", amount, MAX_ALLOWED_ARMOR, reason);
	}
	else
	{
		printf("RCON-ERROR: Valid armor value is from 0 to %i.", MAX_ALLOWED_ARMOR);
		printf("RCON-ERROR: If you want to change the value, open the script and change the MAX_ALLOWED_ARMOR define.");
	}
	return true;
}

rcmd_givearmor(command[])
{
	new
			toplayerid, amount, reason[64];
	if(sscanf(command, "uis[64]", toplayerid, amount, reason))
		return printf("Correct usage: \"%sgivearmor [playername or playerid] [amount] [reason]\"", RCMD_PREFIX);
	if(!IsPlayerConnected(toplayerid))
		return printf("RCON-ERROR: That player is not connected to the server!");
	if(amount > 0 && amount <= (MAX_ALLOWED_ARMOR - PlayerArmor(toplayerid)))
	{
		SendClientMessageEx(toplayerid, 0xFF0000AA, "RCON-CONSOLE: You have received %i armor from RCON-CONSOLE, reason: %s", amount, reason);
 		SendClientMessageToAllOther(toplayerid, 0xFF0000AA, "RCON-CONSOLE: %s received %i armor from RCON-CONSOLE, reason: %s", PlayerName(toplayerid), amount, reason);
		printf("RCON-CONSOLE: You gave %i armor to player %s, reason: %s", amount, PlayerName(toplayerid), reason);
		GivePlayerArmor(toplayerid, amount);
	}
	else
	{
		printf("RCON-ERROR: Valid armor value is from 0 to %i.", MAX_ALLOWED_ARMOR);
		printf("RCON-ERROR: If you want to change the value, open the script and change the MAX_ALLOWED_ARMOR define.");
	}
	return true;
}

rcmd_givearmorall(command[])
{
	new
			amount, reason[64];
	if(sscanf(command, "is[64]", amount, reason)) return printf("Correct usage: \"%sgivearmorall [amount] [reason]\"", RCMD_PREFIX);
	foreach(Player, u)
	{
		if(amount > 0 && amount <= (MAX_ALLOWED_ARMOR - PlayerArmor(u)))
		{
			SendClientMessageEx(u, 0xFF0000AA, "RCON-CONSOLE: You have received %i armor from RCON-CONSOLE, reason: %s", amount, reason);
			GivePlayerArmor(u, amount);
		}
	}
	printf("RCON-CONSOLE: You gave %i armor to everyone, reason: %s", amount, reason);
	return true;
}

rcmd_setmoney(command[])
{
	new
			toplayerid, amount, reason[64];
	if(sscanf(command, "uis[64]", toplayerid, amount, reason))
		return printf("Correct usage: \"%ssetmoney [playername or playerid] [amount] [reason]\"", RCMD_PREFIX);
	if(!IsPlayerConnected(toplayerid))
		return printf("RCON-ERROR: That player is not connected to the server!");
	if(amount >= 0)
	{
		SendClientMessageEx(toplayerid, 0xFF0000AA, "RCON-CONSOLE: Your money has been setted to $%i by RCON-CONSOLE, reason: %s", amount, reason);
 		SendClientMessageToAllOther(toplayerid, 0xFF0000AA, "RCON-CONSOLE: %s's money was setted to $%i by RCON-CONSOLE, reason: %s", PlayerName(toplayerid), amount, reason);
		printf("RCON-CONSOLE: You have setted player %s's money to $%i, reason: %s", PlayerName(toplayerid), amount, reason);
		SetPlayerMoney(toplayerid, amount);
	}
	else printf("RCON-ERROR: You must enter amount which is equal to 0 or higher than 0.");
	return true;
}

rcmd_setmoneyall(command[])
{
	new
			amount, reason[64];
	if(sscanf(command, "is[64]", amount, reason)) return printf("Correct usage: \"%ssetmoneyall [amount] [reason]\"", RCMD_PREFIX);
	if(amount >= 0)
	{
		foreach(Player, u)
		{
			SendClientMessageEx(u, 0xFF0000AA, "RCON-CONSOLE: Your money has been setted to $%i by RCON-CONSOLE, reason: %s", amount, reason);
			SetPlayerMoney(u, amount);
		}
		printf("RCON-CONSOLE: You have setted everyone's money to $%i, reason: %s", amount, reason);
	}
	else printf("RCON-ERROR: You must enter amount which is equal to 0 or higher than 0.");
	return true;
}

rcmd_givemoney(command[])
{
	new
			toplayerid, amount, reason[64];
	if(sscanf(command, "uis[64]", toplayerid, amount, reason))
		return printf("Correct usage: \"%sgivemoney [playername or playerid] [amount] [reason]\"", RCMD_PREFIX);
	if(!IsPlayerConnected(toplayerid))
		return printf("RCON-ERROR: That player is not connected to the server!");
	SendClientMessageEx(toplayerid, 0xFF0000AA, "RCON-CONSOLE: You have received $%i money from RCON-CONSOLE, reason: %s", amount, reason);
	SendClientMessageToAllOther(toplayerid, 0xFF0000AA, "RCON-CONSOLE: %s received $%i money from RCON-CONSOLE, reason: %s", PlayerName(toplayerid), amount, reason);
	printf("RCON-CONSOLE: You gave $%i money to player %s, reason: %s", amount, PlayerName(toplayerid), reason);
	GivePlayerMoney(toplayerid, amount);
	return true;
}

rcmd_givemoneyall(command[])
{
	new
			amount, reason[64];
	if(sscanf(command, "is[64]", amount, reason)) return printf("Correct usage: \"%sgivemoneyall [amount] [reason]\"", RCMD_PREFIX);
	foreach(Player, u)
	{
		SendClientMessageEx(u, 0xFF0000AA, "RCON-CONSOLE: You have received $%i money from RCON-CONSOLE, reason: %s", amount, reason);
		GivePlayerMoney(u, amount);
	}
	printf("RCON-CONSOLE: You gave $%i money to everyone, reason: %s", amount, reason);
	return true;
}

rcmd_setscore(command[])
{
	new
			toplayerid, amount, reason[64];
	if(sscanf(command, "uis[64]", toplayerid, amount, reason))
		return printf("Correct usage: \"%ssetscore [playername or playerid] [amount] [reason]\"", RCMD_PREFIX);
	if(!IsPlayerConnected(toplayerid))
		return printf("RCON-ERROR: That player is not connected to the server!");
	if(amount >= 0)
	{
		SendClientMessageEx(toplayerid, 0xFF0000AA, "RCON-CONSOLE: Your score has been setted to %i by RCON-CONSOLE, reason: %s", amount, reason);
		SendClientMessageToAllOther(toplayerid, 0xFF0000AA, "RCON-CONSOLE: %s's score was setted to %i by RCON-CONSOLE, reason: %s", PlayerName(toplayerid), amount, reason);
		printf("RCON-CONSOLE: You have setted player %s's score to %i, reason: %s", PlayerName(toplayerid), amount, reason);
		SetPlayerScore(toplayerid, amount);
	}
	else printf("RCON-ERROR: You must enter amount which is equal to 0 or higher than 0.");
	return true;
}

rcmd_setscoreall(command[])
{
	new
			amount, reason[64];
	if(sscanf(command, "is[64]", amount, reason))
		return printf("Correct usage: \"%ssetscoreall [amount] [reason]\"", RCMD_PREFIX);
	if(amount >= 0)
	{
		foreach(Player, u)
		{
			SendClientMessageEx(u, 0xFF0000AA, "RCON-CONSOLE: Your score has been setted to %i by RCON-CONSOLE, reason: %s", amount, reason);
			SetPlayerScore(u, amount);
		}
		printf("RCON-CONSOLE: You have setted everyone's score to %i, reason: %s", amount, reason);
	}
	else printf("RCON-ERROR: You must enter amount which is equal to 0 or higher than 0.");
	return true;
}

rcmd_givescore(command[])
{
	new
			toplayerid, amount, reason[64];
	if(sscanf(command, "uis[64]", toplayerid, amount, reason))
		return printf("Correct usage: \"%sgivescore [playername or playerid] [amount] [reason]\"", RCMD_PREFIX);
	if(!IsPlayerConnected(toplayerid))
		return printf("RCON-ERROR: That player is not connected to the server!");
	SendClientMessageEx(toplayerid, 0xFF0000AA, "RCON-CONSOLE: You have received %i score from RCON-CONSOLE, reason: %s", amount, reason);
	SendClientMessageToAllOther(toplayerid, 0xFF0000AA, "RCON-CONSOLE: %s received %i score from RCON-CONSOLE, reason: %s", PlayerName(toplayerid), amount, reason);
	printf("RCON-CONSOLE: You gave %i score to player %s, reason: %s", amount, PlayerName(toplayerid), reason);
	GivePlayerScore(toplayerid, amount);
	return true;
}

rcmd_givescoreall(command[])
{
	new
			amount, reason[64];
	if(sscanf(command, "is[64]", amount, reason)) return printf("Correct usage: \"%sgivescoreall [amount] [reason]\"", RCMD_PREFIX);
	foreach(Player, u)
	{
		SendClientMessageEx(u, 0xFF0000AA, "RCON-CONSOLE: You have received %i score from RCON-CONSOLE, reason: %s", amount, reason);
		SetPlayerScore(u, amount);
	}
	printf("RCON-CONSOLE: You gave %i score to everyone, reason: %s", amount, reason);
	return true;
}

rcmd_infoplayer(command[])
{
	new
			toplayerid;
	if(sscanf(command, "u", toplayerid))
		return printf("Correct usage: \"%sinfoplayer [playername or playerid]\"", RCMD_PREFIX);
	if(!IsPlayerConnected(toplayerid))
		return printf("RCON-ERROR: That player is not connected to the server!");
	printf("RCON-CONSOLE: Information about \"%s\" player:", PlayerName(toplayerid));
	printf("    Name: %s, playerID: %i, health: %i, armor: %i, money: $%i", PlayerName(toplayerid), toplayerid, PlayerHealth(toplayerid), PlayerArmor(toplayerid), GetPlayerMoney(toplayerid));
	printf("    IP: %s, ping: %i, score: %i", PlayerIP(toplayerid), GetPlayerPing(toplayerid), GetPlayerScore(toplayerid));
	printf("    position X: %.3f, position Y: %.3f, position Z: %.3f", GetPlayerPosX(toplayerid), GetPlayerPosY(toplayerid), GetPlayerPosZ(toplayerid));
	printf("    state: %s, interior: %i, virtual world: %i", PlayerStateName(toplayerid), GetPlayerInterior(toplayerid), GetPlayerVirtualWorld(toplayerid));
	return true;
}

rcmd_setserverpass(command[])
{
	new
			password[32];
	if(sscanf(command, "s[32]", password))
		return printf("Correct usage: \"%ssetserverpass [password]\"", RCMD_PREFIX);
	SetServerPassword(password);
	return true;
}

rcmd_setservername(command[])
{
	new
			name[64];
	if(sscanf(command, "s[64]", name))
		return printf("Correct usage: \"%ssetservername [name]\"", RCMD_PREFIX);
	SetServerName(name);
	return true;
}

rcmd_setservergamemode(command[])
{
	new
			gamemode[32];
	if(sscanf(command, "s[32]", gamemode))
		return printf("Correct usage: \"%ssetservergamemode [name]\"", RCMD_PREFIX);
	SetServerGamemode(gamemode);
	return true;
}

rcmd_setservermap(command[])
{
	new
			map[24];
	if(sscanf(command, "s[24]", map))
		return printf("Correct usage: \"%ssetservermap [name]\"", RCMD_PREFIX);
	SetServerMap(map);
	return true;
}

rcmd_setplayerweather(command[])
{
	new
			toplayerid, weatherid;
	if(sscanf(command, "ui", toplayerid, weatherid))
		return printf("Correct usage: \"%ssetplayerweather [playername or playerid] [weather-ID]\"", RCMD_PREFIX);
	if(!IsPlayerConnected(toplayerid))
		return printf("RCON-ERROR: That player is not connected to the server!");
	SetPlayerWeather(toplayerid, weatherid);
	printf("Setting player weather: Player: \"%s (%i)\", Weather: \"%i\"", PlayerName(toplayerid), toplayerid, weatherid);
	return true;
}

rcmd_setweather(command[])
{
	new
			weatherid;
	if(sscanf(command, "i", weatherid))
		return printf("Correct usage: \"%ssetweather [weather-ID]\"", RCMD_PREFIX);
	SetWeather(weatherid);
	printf("Setting server weather to: %i", weatherid);
	return true;
}

rcmd_setgravity(command[])
{
	new
			gravityid;
	if(sscanf(command, "f", gravityid))
		return printf("Correct usage: \"%ssetgravity [gravity-ID (in float value)]\"", RCMD_PREFIX);
	SetGravity(gravityid);
	printf("Setting server gravity to: %.6f", gravityid);
	return true;
}

/*----------------------------------------------------------------------------*/

stock PlayerName(playerid)
{
	new
			name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	return name;
}

stock PlayerHealth(playerid)
{
	new
			Float:health;
	GetPlayerHealth(playerid, health);
	return floatround(health);
}

stock GivePlayerHealth(playerid, amount) return SetPlayerHealth(playerid, PlayerHealth(playerid) + amount);

stock KillPlayer(playerid) return SetPlayerHealth(playerid, 0);

stock PlayerArmor(playerid)
{
	new
			Float:armor;
	GetPlayerArmour(playerid, armor);
	return floatround(armor);
}

stock GivePlayerArmor(playerid, amount) return SetPlayerArmour(playerid, PlayerArmor(playerid) + amount);

stock SetPlayerMoney(playerid, amount)
{
	ResetPlayerMoney(playerid);
	return GivePlayerMoney(playerid, amount);
}

stock GivePlayerScore(playerid, amount) return SetPlayerScore(playerid, GetPlayerScore(playerid) + amount);

stock PlayerIP(playerid)
{
	new
			ip[16];
	GetPlayerIp(playerid, ip, 16);
	return ip;
}

stock PlayerStateName(playerid)
{
	new
			statename[32];
	switch(GetPlayerState(playerid))
	{
		case PLAYER_STATE_NONE: statename = "on foot";
		case PLAYER_STATE_ONFOOT: statename = "on foot";
		case PLAYER_STATE_DRIVER: statename = "driver in the vehicle";
		case PLAYER_STATE_PASSENGER: statename = "passenger in the vehicle";
		case PLAYER_STATE_WASTED: statename = "wasted";
		case PLAYER_STATE_SPAWNED: statename = "spawned";
		case PLAYER_STATE_SPECTATING: statename = "spectating";
		default: statename = "unknown state";
	}
	return statename;
}

Float:GetPlayerPosX(playerid)
{
	new
			Float:get_x, Float:get_y, Float:get_z;
	GetPlayerPos(playerid, get_x, get_y, get_z);
	return get_x;
}

Float:GetPlayerPosY(playerid)
{
	new
			Float:get_x, Float:get_y, Float:get_z;
	GetPlayerPos(playerid, get_x, get_y, get_z);
	return get_y;
}

Float:GetPlayerPosZ(playerid)
{
	new
			Float:get_x, Float:get_y, Float:get_z;
	GetPlayerPos(playerid, get_x, get_y, get_z);
	return get_z;
}

stock FreezePlayer(playerid) return TogglePlayerControllable(playerid, false);

stock UnfreezePlayer(playerid) return TogglePlayerControllable(playerid, true);

stock SetServerPassword(password[])
{
	SendRconCommandEx("password %s", password);
	return true;
}

stock SetServerName(name[])
{
	SendRconCommandEx("hostname %s", name);
	printf("Setting server name to: \"%s\"", name);
	return true;
}

stock SetServerGamemode(gamemode[])
{
	SendRconCommandEx("gamemodetext %s", gamemode);
	printf("Setting server gamemode name to: \"%s\"", gamemode);
	return true;
}

stock SetServerMap(map[])
{
	SendRconCommandEx("mapname %s", map);
	printf("Setting server map name to: \"%s\"", map);
	return true;
}
