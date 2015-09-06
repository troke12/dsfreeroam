#include <a_samp>
// irc.inc from this package
// sscanf2.inc from the sscanf plugin
#include <sscanf2>

#include <irc>

#define FILTERSCRIPT

// Name that everyone will see
#define BOT_1_NICKNAME "krisna"
// Name that will only be visible in a whois
#define BOT_1_REALNAME "krisnapradnya"
// Name that will be in front of the hostname (username@hostname)
#define BOT_1_USERNAME "krisna"

#define BOT_2_NICKNAME "ADMIN.Maho"
#define BOT_2_REALNAME "ADMIN.Ganteng"
#define BOT_2_USERNAME "ADMIN.Jelek"

#define IRC_SERVER "irc.mibbit.net"
#define IRC_PORT (6667)
#define IRC_CHANNEL "#vgi"

// Maximum number of bots in the filterscript
#define MAX_BOTS (2)

#define PLUGIN_VERSION "1.5"

new botIDs[MAX_BOTS], groupID;

/*
	When the filterscript is loaded, two bots will connect and a group will be
	created for them.
*/

public OnFilterScriptInit()
{
	// Connect the first bot
	botIDs[0] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_1_NICKNAME, BOT_1_REALNAME, BOT_1_USERNAME);
	// Set the connect delay for the first bot to 20 seconds
	IRC_SetIntData(botIDs[0], E_IRC_CONNECT_DELAY, 5);
	// Connect the second bot
	botIDs[1] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_2_NICKNAME, BOT_2_REALNAME, BOT_2_USERNAME);
	// Set the connect delay for the second bot to 30 seconds
	IRC_SetIntData(botIDs[1], E_IRC_CONNECT_DELAY, 7);
	// Create a group (the bots will be added to it upon connect)
	groupID = IRC_CreateGroup();
}

/*
	When the filterscript is unloaded, the bots will disconnect, and the group
	will be destroyed.
*/

public OnFilterScriptExit()
{
	// Disconnect the first bot
	IRC_Quit(botIDs[0], "Filterscript exiting.");
	// Disconnect the second bot
	IRC_Quit(botIDs[1], "Filterscript exiting.");
	// Destroy the group
	IRC_DestroyGroup(groupID);
}

/*
	The standard SA-MP callbacks are below. We will echo a few of them to the
	IRC channel.
*/

public OnPlayerConnect(playerid)
{
	new joinMsg[128], name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	format(joinMsg, sizeof(joinMsg), "02[%d] 03*** %s has joined the server.", playerid, name);
	IRC_GroupSay(groupID, IRC_CHANNEL, joinMsg);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	new leaveMsg[128], name[MAX_PLAYER_NAME], reasonMsg[8];
	switch(reason)
	{
		case 0: reasonMsg = "Timeout";
		case 1: reasonMsg = "Leaving";
		case 2: reasonMsg = "Kicked";
	}
	GetPlayerName(playerid, name, sizeof(name));
	format(leaveMsg, sizeof(leaveMsg), "02[%d] 03*** %s has left the server. (%s)", playerid, name, reasonMsg);
	IRC_GroupSay(groupID, IRC_CHANNEL, leaveMsg);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	new msg[128], killerName[MAX_PLAYER_NAME], reasonMsg[32], playerName[MAX_PLAYER_NAME];
	GetPlayerName(killerid, killerName, sizeof(killerName));
	GetPlayerName(playerid, playerName, sizeof(playerName));
	if (killerid != INVALID_PLAYER_ID)
	{
		switch (reason)
		{
			case 0: reasonMsg = "Unarmed";
			case 1: reasonMsg = "Brass Knuckles";
			case 2: reasonMsg = "Golf Club";
			case 3: reasonMsg = "Night Stick";
			case 4: reasonMsg = "Knife";
			case 5: reasonMsg = "Baseball Bat";
			case 6: reasonMsg = "Shovel";
			case 7: reasonMsg = "Pool Cue";
			case 8: reasonMsg = "Katana";
			case 9: reasonMsg = "Chainsaw";
			case 10: reasonMsg = "Dildo";
			case 11: reasonMsg = "Dildo";
			case 12: reasonMsg = "Vibrator";
			case 13: reasonMsg = "Vibrator";
			case 14: reasonMsg = "Flowers";
			case 15: reasonMsg = "Cane";
			case 22: reasonMsg = "Pistol";
			case 23: reasonMsg = "Silenced Pistol";
			case 24: reasonMsg = "Desert Eagle";
			case 25: reasonMsg = "Shotgun";
			case 26: reasonMsg = "Sawn-off Shotgun";
			case 27: reasonMsg = "Combat Shotgun";
			case 28: reasonMsg = "MAC-10";
			case 29: reasonMsg = "MP5";
			case 30: reasonMsg = "AK-47";
			case 31: reasonMsg = "M4";
			case 32: reasonMsg = "TEC-9";
			case 33: reasonMsg = "Country Rifle";
			case 34: reasonMsg = "Sniper Rifle";
			case 37: reasonMsg = "Fire";
			case 38: reasonMsg = "Minigun";
			case 41: reasonMsg = "Spray Can";
			case 42: reasonMsg = "Fire Extinguisher";
			case 49: reasonMsg = "Vehicle Collision";
			case 50: reasonMsg = "Vehicle Collision";
			case 51: reasonMsg = "Explosion";
			default: reasonMsg = "Unknown";
		}
		format(msg, sizeof(msg), "04*** %s killed %s. (%s)", killerName, playerName, reasonMsg);
	}
	else
	{
		switch (reason)
		{
			case 53: format(msg, sizeof(msg), "04*** %s died. (Drowned)", playerName);
			case 54: format(msg, sizeof(msg), "04*** %s died. (Collision)", playerName);
			default: format(msg, sizeof(msg), "04*** %s died.", playerName);
		}
	}
	IRC_GroupSay(groupID, IRC_CHANNEL, msg);
	return 1;
}

public OnPlayerText(playerid, text[])
{
	new name[MAX_PLAYER_NAME], ircMsg[256];
	GetPlayerName(playerid, name, sizeof(name));
	format(ircMsg, sizeof(ircMsg), "02[%d] 07%s: %s", playerid, name, text);
	IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
	return 1;
}

/*
	The IRC callbacks are below. Many of these are simply derived from parsed
	raw messages received from the IRC server. They can be used to inform the
	bot of new activity in any of the channels it has joined.
*/

/*
	This callback is executed whenever a bot successfully connects to an IRC
	server.
*/

public IRC_OnConnect(botid, ip[], port)
{
	printf("*** IRC_OnConnect: Bot ID %d connected to %s:%d", botid, ip, port);
	// Join the channel
	IRC_JoinChannel(botid, IRC_CHANNEL);
	// Add the bot to the group
	IRC_AddToGroup(groupID, botid);
	return 1;
}

/*
	This callback is executed whenever a current connection is closed. The
	plugin may automatically attempt to reconnect per user settings. IRC_Quit
	may be called at any time to stop the reconnection process.
*/

public IRC_OnDisconnect(botid, ip[], port, reason[])
{
	printf("*** IRC_OnDisconnect: Bot ID %d disconnected from %s:%d (%s)", botid, ip, port, reason);
	// Remove the bot from the group
	IRC_RemoveFromGroup(groupID, botid);
	return 1;
}

/*
	This callback is executed whenever a connection attempt begins. IRC_Quit may
	be called at any time to stop the reconnection process.
*/

public IRC_OnConnectAttempt(botid, ip[], port)
{
	printf("*** IRC_OnConnectAttempt: Bot ID %d attempting to connect to %s:%d...", botid, ip, port);
	return 1;
}

/*
	This callback is executed whenever a connection attempt fails. IRC_Quit may
	be called at any time to stop the reconnection process.
*/

public IRC_OnConnectAttemptFail(botid, ip[], port, reason[])
{
	printf("*** IRC_OnConnectAttemptFail: Bot ID %d failed to connect to %s:%d (%s)", botid, ip, port, reason);
	return 1;
}

/*
	This callback is executed whenever a bot joins a channel.
*/

public IRC_OnJoinChannel(botid, channel[])
{
	printf("*** IRC_OnJoinChannel: Bot ID %d joined channel %s", botid, channel);
	return 1;
}

/*
	This callback is executed whenevever a bot leaves a channel.
*/

public IRC_OnLeaveChannel(botid, channel[], message[])
{
	printf("*** IRC_OnLeaveChannel: Bot ID %d left channel %s (%s)", botid, channel, message);
	return 1;
}

/*
	This callback is executed whenevever a bot is invited to a channel.
*/

public IRC_OnInvitedToChannel(botid, channel[], invitinguser[], invitinghost[])
{
	printf("*** IRC_OnInvitedToChannel: Bot ID %d invited to channel %s by %s (%s)", botid, channel, invitinguser, invitinghost);
	IRC_JoinChannel(botid, channel);
	return 1;
}

/*
	This callback is executed whenevever a bot is kicked from a channel. If the
	bot cannot immediately rejoin the channel (in the event, for example, that
	the bot is kicked and then banned), you might want to set up a timer here
	for rejoin attempts.
*/

public IRC_OnKickedFromChannel(botid, channel[], oppeduser[], oppedhost[], message[])
{
	printf("*** IRC_OnKickedFromChannel: Bot ID %d kicked by %s (%s) from channel %s (%s)", botid, oppeduser, oppedhost, channel, message);
	IRC_JoinChannel(botid, channel);
	return 1;
}

public IRC_OnUserDisconnect(botid, user[], host[], message[])
{
	printf("*** IRC_OnUserDisconnect (Bot ID %d): User %s (%s) disconnected (%s)", botid, user, host, message);
	return 1;
}

public IRC_OnUserJoinChannel(botid, channel[], user[], host[])
{
	printf("*** IRC_OnUserJoinChannel (Bot ID %d): User %s (%s) joined channel %s", botid, user, host, channel);
	return 1;
}

public IRC_OnUserLeaveChannel(botid, channel[], user[], host[], message[])
{
	printf("*** IRC_OnUserLeaveChannel (Bot ID %d): User %s (%s) left channel %s (%s)", botid, user, host, channel, message);
	return 1;
}

public IRC_OnUserKickedFromChannel(botid, channel[], kickeduser[], oppeduser[], oppedhost[], message[])
{
	printf("*** IRC_OnUserKickedFromChannel (Bot ID %d): User %s kicked by %s (%s) from channel %s (%s)", botid, kickeduser, oppeduser, oppedhost, channel, message);
}

public IRC_OnUserNickChange(botid, oldnick[], newnick[], host[])
{
	printf("*** IRC_OnUserNickChange (Bot ID %d): User %s (%s) changed his/her nick to %s", botid, oldnick, host, newnick);
	return 1;
}

public IRC_OnUserSetChannelMode(botid, channel[], user[], host[], mode[])
{
	printf("*** IRC_OnUserSetChannelMode (Bot ID %d): User %s (%s) on %s set mode: %s", botid, user, host, channel, mode);
	return 1;
}

public IRC_OnUserSetChannelTopic(botid, channel[], user[], host[], topic[])
{
	printf("*** IRC_OnUserSetChannelTopic (Bot ID %d): User %s (%s) on %s set topic: %s", botid, user, host, channel, topic);
	return 1;
}

public IRC_OnUserSay(botid, recipient[], user[], host[], message[])
{
	printf("*** IRC_OnUserSay (Bot ID %d): User %s (%s) sent message to %s: %s", botid, user, host, recipient, message);
	// Someone sent the first bot a private message
	if (!strcmp(recipient, BOT_1_NICKNAME))
	{
		IRC_Say(botid, user, "You sent me a PM!");
	}
	return 1;
}

public IRC_OnUserNotice(botid, recipient[], user[], host[], message[])
{
	printf("*** IRC_OnUserNotice (Bot ID %d): User %s (%s) sent notice to %s: %s", botid, user, host, recipient, message);
	// Someone sent the second bot a notice (probably a network service)
	if (!strcmp(recipient, BOT_2_NICKNAME))
	{
		IRC_Notice(botid, user, "You sent me a notice!");
	}
	return 1;
}

public IRC_OnUserRequestCTCP(botid, user[], host[], message[])
{
	printf("*** IRC_OnUserRequestCTCP (Bot ID %d): User %s (%s) sent CTCP request: %s", botid, user, host, message);
	// Someone sent a CTCP VERSION request
	if (!strcmp(message, "VERSION"))
	{
		IRC_ReplyCTCP(botid, user, "VERSION SA-MP IRC Plugin v" #PLUGIN_VERSION "");
	}
	return 1;
}

public IRC_OnUserReplyCTCP(botid, user[], host[], message[])
{
	printf("*** IRC_OnUserReplyCTCP (Bot ID %d): User %s (%s) sent CTCP reply: %s", botid, user, host, message);
	return 1;
}

/*
	This callback is useful for logging, debugging, or catching error messages
	sent by the IRC server.
*/

public IRC_OnReceiveRaw(botid, message[])
{
	new File:file;
	if (!fexist("irc_log.txt"))
	{
		file = fopen("irc_log.txt", io_write);
	}
	else
	{
		file = fopen("irc_log.txt", io_append);
	}
	if (file)
	{
		fwrite(file, message);
		fwrite(file, "\r\n");
		fclose(file);
	}
	return 1;
}

/*
	Some examples of channel commands are here. You can add more very easily;
	their implementation is identical to that of ZeeX's zcmd.
*/

IRCCMD:say(botid, channel[], user[], host[], params[])
{
	if (!isnull(params))
	{
		new msg[128];
			// Echo the formatted message
		format(msg, sizeof(msg), "02*** %s on IRC: %s", user, params);
		IRC_GroupSay(groupID, channel, msg);
		format(msg, sizeof(msg), "*** %s on IRC: %s", user, params);
		SendClientMessageToAll(0x00CCCCFF, msg);
	}
	return 1;
}

IRCCMD:msay(botid, channel[], user[], host[], params[])
{
	// Check if the user has at least voice in the channel
	if (IRC_IsVoice(botid, channel, user))
	{
		// Check if the user entered any text
		if (!isnull(params))
		{
			new msg[128];
			// Echo the formatted message
			format(msg, sizeof(msg), "11Moderator %s on IRC: %s", user, params);
			IRC_GroupSay(groupID, channel, msg);
			format(msg, sizeof(msg), "Moderator %s on IRC: %s", user, params);
			SendClientMessageToAll(0x00CCCCFF, msg);
		}
	}
	return 1;
}

IRCCMD:asay(botid, channel[], user[], host[], params[])
{
	// Check if the user has at least voice in the channel
	if (IRC_IsOp(botid, channel, user))
	{
		// Check if the user entered any text
		if (!isnull(params))
		{
			new msg[128];
			// Echo the formatted message
			format(msg, sizeof(msg), "12Administrator %s on IRC: %s", user, params);
			IRC_GroupSay(groupID, channel, msg);
			format(msg, sizeof(msg), "Administrator %s on IRC: %s", user, params);
			SendClientMessageToAll(0x00CCCCFF, msg);
		}
	}
	return 1;
}

IRCCMD:osay(botid, channel[], user[], host[], params[])
{
	// Check if the user has at least voice in the channel
	if (IRC_IsOwner(botid, channel, user))
	{
		// Check if the user entered any text
		if (!isnull(params))
		{
			new msg[128];
			// Echo the formatted message
			format(msg, sizeof(msg), "12Owner %s on IRC: %s", user, params);
			IRC_GroupSay(groupID, channel, msg);
			format(msg, sizeof(msg), "Owner %s on IRC: %s", user, params);
			SendClientMessageToAll(0x00CCCCFF, msg);
		}
	}
	return 1;
}

IRCCMD:smsay(botid, channel[], user[], host[], params[])
{
	// Check if the user has at least voice in the channel
	if (IRC_IsVoice(botid, channel, user))
	{
		// Check if the user entered any text
		if (!isnull(params))
		{
			new msg[128];
			// Echo the formatted message
			format(msg, sizeof(msg), "12Moderator on IRC: %s", params);
			IRC_GroupSay(groupID, channel, msg);
			format(msg, sizeof(msg), "Moderator on IRC: %s", params);
			SendClientMessageToAll(0x00CCCCFF, msg);
		}
	}
	return 1;
}

IRCCMD:sasay(botid, channel[], user[], host[], params[])
{
	// Check if the user has at least voice in the channel
	if (IRC_IsOp(botid, channel, user))
	{
		// Check if the user entered any text
		if (!isnull(params))
		{
			new msg[128];
			// Echo the formatted message
			format(msg, sizeof(msg), "12Administrator on IRC: %s", params);
			IRC_GroupSay(groupID, channel, msg);
			format(msg, sizeof(msg), "Administrator on IRC: %s", params);
			SendClientMessageToAll(0x00CCCCFF, msg);
		}
	}
	return 1;
}

IRCCMD:sosay(botid, channel[], user[], host[], params[])
{
	// Check if the user has at least voice in the channel
	if (IRC_IsOwner(botid, channel, user))
	{
		// Check if the user entered any text
		if (!isnull(params))
		{
			new msg[128];
			// Echo the formatted message
			format(msg, sizeof(msg), "12Owner on IRC: %s", params);
			IRC_GroupSay(groupID, channel, msg);
			format(msg, sizeof(msg), "Owner on IRC: %s", params);
			SendClientMessageToAll(0x00CCCCFF, msg);
		}
	}
	return 1;
}

IRCCMD:mkick(botid, channel[], user[], host[], params[])
{
	// Check if the user is at least a halfop in the channel
	if (IRC_IsVoice(botid, channel, user))
	{
		new playerid, reason[64];
		// Check if the user at least entered a player ID
		if (sscanf(params, "dS(No reason)[64]", playerid, reason))
		{
			return 1;
		}
		// Check if the player is connected
		if (IsPlayerConnected(playerid))
		{
			// Echo the formatted message
			new msg[128], name[MAX_PLAYER_NAME];
			GetPlayerName(playerid, name, sizeof(name));
			format(msg, sizeof(msg), "02*** %s has been kicked by Moderator %s on IRC for reason: %s", name, user, reason);
			IRC_GroupSay(groupID, channel, msg);
			format(msg, sizeof(msg), "*** %s has been kicked by Moderator %s on IRC for reason: %s", name, user, reason);
			SendClientMessageToAll(0xFF0000C8, msg);
			// Kick the player
			Kick(playerid);
		}
	}
	return 1;
}

IRCCMD:akick(botid, channel[], user[], host[], params[])
{
	// Check if the user is at least a halfop in the channel
	if (IRC_IsOp(botid, channel, user))
	{
		new playerid, reason[64];
		// Check if the user at least entered a player ID
		if (sscanf(params, "dS(No reason)[64]", playerid, reason))
		{
			return 1;
		}
		// Check if the player is connected
		if (IsPlayerConnected(playerid))
		{
			// Echo the formatted message
			new msg[128], name[MAX_PLAYER_NAME];
			GetPlayerName(playerid, name, sizeof(name));
			format(msg, sizeof(msg), "02*** %s has been kicked by Administrator %s on IRC for reason: %s", name, user, reason);
			IRC_GroupSay(groupID, channel, msg);
			format(msg, sizeof(msg), "*** %s has been kicked by Administrator %s on IRC for reason: %s", name, user, reason);
			SendClientMessageToAll(0xFF0000C8, msg);
			// Kick the player
			Kick(playerid);
		}
	}
	return 1;
}

IRCCMD:okick(botid, channel[], user[], host[], params[])
{
	// Check if the user is at least a halfop in the channel
	if (IRC_IsOwner(botid, channel, user))
	{
		new playerid, reason[64];
		// Check if the user at least entered a player ID
		if (sscanf(params, "dS(No reason)[64]", playerid, reason))
		{
			return 1;
		}
		// Check if the player is connected
		if (IsPlayerConnected(playerid))
		{
			// Echo the formatted message
			new msg[128], name[MAX_PLAYER_NAME];
			GetPlayerName(playerid, name, sizeof(name));
			format(msg, sizeof(msg), "02*** %s has been kicked by Owner %s on IRC for reason: %s", name, user, reason);
			IRC_GroupSay(groupID, channel, msg);
			format(msg, sizeof(msg), "*** %s has been kicked by Owner %s on IRC for reason: %s", name, user, reason);
			SendClientMessageToAll(0xFF0000C8, msg);
			// Kick the player
			Kick(playerid);
		}
	}
	return 1;
}

IRCCMD:mban(botid, channel[], user[], host[], params[])
{
	// Check if the user is at least an op in the channel
	if (IRC_IsVoice(botid, channel, user))
	{
		new playerid, reason[64];
		// Check if the user at least entered a player ID
		if (sscanf(params, "dS(No reason)[64]", playerid, reason))
		{
			return 1;
		}
		// Check if the player is connected
		if (IsPlayerConnected(playerid))
		{
			// Echo the formatted message
			new msg[128], name[MAX_PLAYER_NAME];
			GetPlayerName(playerid, name, sizeof(name));
			format(msg, sizeof(msg), "02*** %s has been banned by Moderator %s on IRC for reason: %s", name, user, reason);
			IRC_GroupSay(groupID, channel, msg);
			format(msg, sizeof(msg), "*** %s has been banned by Moderator %s on IRC for reason: %s", name, user, reason);
			SendClientMessageToAll(0xFF0000C8, msg);
			// Ban the player
			BanEx(playerid, reason);
		}
	}
	return 1;
}

IRCCMD:aban(botid, channel[], user[], host[], params[])
{
	// Check if the user is at least an op in the channel
	if (IRC_IsOp(botid, channel, user))
	{
		new playerid, reason[64];
		// Check if the user at least entered a player ID
		if (sscanf(params, "dS(No reason)[64]", playerid, reason))
		{
			return 1;
		}
		// Check if the player is connected
		if (IsPlayerConnected(playerid))
		{
			// Echo the formatted message
			new msg[128], name[MAX_PLAYER_NAME];
			GetPlayerName(playerid, name, sizeof(name));
			format(msg, sizeof(msg), "02*** %s has been banned by Administrator %s on IRC for reason: %s", name, user, reason);
			IRC_GroupSay(groupID, channel, msg);
			format(msg, sizeof(msg), "*** %s has been banned by Administrator %s on IRC for reason: %s", name, user, reason);
			SendClientMessageToAll(0xFF0000C8, msg);
			// Ban the player
			BanEx(playerid, reason);
		}
	}
	return 1;
}

IRCCMD:oban(botid, channel[], user[], host[], params[])
{
	// Check if the user is at least an op in the channel
	if (IRC_IsOwner(botid, channel, user))
	{
		new playerid, reason[64];
		// Check if the user at least entered a player ID
		if (sscanf(params, "dS(No reason)[64]", playerid, reason))
		{
			return 1;
		}
		// Check if the player is connected
		if (IsPlayerConnected(playerid))
		{
			// Echo the formatted message
			new msg[128], name[MAX_PLAYER_NAME];
			GetPlayerName(playerid, name, sizeof(name));
			format(msg, sizeof(msg), "02*** %s has been banned by Owner %s on IRC for reason: %s", name, user, reason);
			IRC_GroupSay(groupID, channel, msg);
			format(msg, sizeof(msg), "*** %s has been banned by Owner %s on IRC for reason: %s", name, user, reason);
			SendClientMessageToAll(0xFF0000C8, msg);
			// Ban the player
			BanEx(playerid, reason);
		}
	}
	return 1;
}

IRCCMD:fu(botid, channel[], user[], host[], params[])
{
	new playerid, reason[64];
	//Playerid
	if (sscanf(params, "dS(No reason.)[64]", playerid, reason))
	{
		return 1;
	}

	if(IRC_IsVoice(botid, channel, user))
	{

		if(IsPlayerConnected(playerid))
		{
			new msg[128], pname[MAX_PLAYER_NAME];
			GetPlayerName(playerid, pname, sizeof(pname));
			format(msg, sizeof(msg), "*** %s has been fucked up by Staff Member %s on IRC for reason: %s", pname, user, reason);
			IRC_GroupSay(groupID, channel, msg);
			format(msg, sizeof(msg), "*** %s has been fucked up by Staff Member %s on IRC for reason: %s", pname, user, reason);
			SendClientMessageToAll(0xFF0000C8, msg);
			SetPlayerDrunkLevel(playerid, 50000);
			SetPlayerColor(playerid, 0xFF00FFC8);
			SetPlayerHealth(playerid, 0.2);
			ResetPlayerWeapons(playerid);
			GivePlayerMoney(playerid, -10000);
			SetPlayerSkin(playerid, 77);
		}
	}
	return 1;
}


IRCCMD:rcon(botid, channel[], user[], host[], params[])
{
	// Check if the user is at least an Owner in the channel
	if (IRC_IsOwner(botid, channel, user))
	{
		// Check if the user entered any text
		if (!isnull(params))
		{
			// Check if the user did not enter any invalid commands
			if (strcmp(params, "exit", true) != 0 && strfind(params, "loadfs irc", true) == -1)
			{
				// Echo the formatted message
				new msg[128];
				format(msg, sizeof(msg), "RCON command %s has been successfully executed.", params);
				IRC_GroupSay(groupID, channel, msg);
				// Send the command
				SendRconCommand(params);
			}
		}
	}
	return 1;
}

IRCCMD:players( botid, channel[], user[], host[], params[] )
{
    new tempstr[128], string[200], count, name[24];
    for( new i ,slots = GetMaxPlayers(); i < slots; i++ )
    {
        if(IsPlayerConnected(i))
        {
            count++;
            GetPlayerName(i, name, sizeof(name));
            format(tempstr, sizeof(tempstr), "%s , %s", tempstr, name);
        }
    }
    if(count)
    {
        format(string, sizeof(string), "Connected Players[%d/%d]:- %s", count, GetMaxPlayers(), tempstr);
        IRC_Say(botid, channel, string);
    } else IRC_Say(botid, channel, "No players are online. :/");
    return 1;
}

IRCCMD:cmds(botid, channel[], user[], host[], params[])
{
	new string[50];
	new string2[230];
	new string3[100];

	format(string, sizeof(string), "IRC COMMANDS:");
	format(string2, sizeof(string2), "!players, !rcon, !fu, !oban, !aban, !mban, !okick, !akick, !mkick, !sosay, !sasay, !smsay, !osay, !asay, !msay, !say, !slap, !warn, !freeze, !unfreeze, !explode, !disarm, !resetcash, !giveallcash, !getname, !forums, !respawncars");
	format(string3, sizeof(string3), "!enablestuntbonus, !disablestuntbonus, !spawn, !fuck, !getinfo");

	IRC_Say(botid, channel, string);
	IRC_Say(botid, channel, string2);
	IRC_Say(botid, channel, string3);

	//Displays a full list of commands on IRC. By NoahF. :)

	return 1;
}

IRCCMD:slap(botid, channel[], user[], host[], params[])
{
	new playerid, reason[64];
	new player1;
	//Playerid
	if (sscanf(params, "dS(No reason.)[64]", playerid, reason))
	{
		return 1;
	}
    if (IRC_IsVoice(botid, channel, user))
	{
		if(IsPlayerConnected(playerid))
		{
			new msg[128], pname[MAX_PLAYER_NAME];
			GetPlayerName(playerid, pname, sizeof(pname));
			format(msg, sizeof(msg), "*** %s has been slapped by Staff Member %s on IRC for reason: %s", pname, user, reason);
			IRC_GroupSay(groupID, channel, msg);
			format(msg, sizeof(msg), "*** %s has been slapped by Staff Member %s on IRC for reason: %s", pname, user, reason);
			SendClientMessageToAll(0xFF0000C8, msg);
			//"Slap" the target. By NoahF. :)
			new Float:Health;
			new Float:x, Float:y, Float:z;
			GetPlayerHealth(player1,Health);
			SetPlayerHealth(player1,Health-25);
			GetPlayerPos(player1,x,y,z);
			SetPlayerPos(player1,x,y,z+7);
			PlayerPlaySound(playerid,1190,0.0,0.0,0.0);
			PlayerPlaySound(player1,1190,0.0,0.0,0.0);
		}
	}
	return 1;
}

IRCCMD:warn(botid, channel[], user[], host[], params[])
{
	new playerid, reason[64];
	//Playerid
	if (sscanf(params, "dS(No reason.)[64]", playerid, reason))
	{
		return 1;
	}
    if (IRC_IsVoice(botid, channel, user))
	{
		if(IsPlayerConnected(playerid))
		{
			new msg[128], pname[MAX_PLAYER_NAME];
			GetPlayerName(playerid, pname, sizeof(pname));
			format(msg, sizeof(msg), "*** %s has been warned by Staff Member %s on IRC for reason: %s", pname, user, reason);
			IRC_GroupSay(groupID, channel, msg);
			format(msg, sizeof(msg), "*** %s has been warned by Staff Member %s on IRC for reason: %s", pname, user, reason);
			SendClientMessageToAll(0xFFFF00C8, msg);
			//Simple warn by NoahF. :)
		}
	}
	return 1;
}

IRCCMD:freeze(botid, channel[], user[], host[], params[])
{
	new playerid, reason[64];
	//Playerid
	if (sscanf(params, "dS(No reason.)[64]", playerid, reason))
	{
		return 1;
	}
    if (IRC_IsVoice(botid, channel, user))
	{
		if(IsPlayerConnected(playerid))
		{
			new msg[128], pname[MAX_PLAYER_NAME];
			GetPlayerName(playerid, pname, sizeof(pname));
			format(msg, sizeof(msg), "*** %s has been frozen by Staff Member %s on IRC for reason: %s", pname, user, reason);
			IRC_GroupSay(groupID, channel, msg);
			format(msg, sizeof(msg), "*** %s has been frozen by Staff Member %s on IRC for reason: %s", pname, user, reason);
			SendClientMessageToAll(0xFF0000C8, msg);
			//Freeze.
			TogglePlayerControllable(playerid, 0);
			//Freeze the player, by Noah.
		}
	}
	return 1;
}

IRCCMD:unfreeze(botid, channel[], user[], host[], params[])
{
	new playerid, reason[64];
	//Playerid
	if (sscanf(params, "dS(No reason.)[64]", playerid, reason))
	{
		return 1;
	}
    if (IRC_IsVoice(botid, channel, user))
	{
		if(IsPlayerConnected(playerid))
		{
			new msg[128], pname[MAX_PLAYER_NAME];
			GetPlayerName(playerid, pname, sizeof(pname));
			format(msg, sizeof(msg), "*** %s has been unfrozen by Staff Member %s on IRC for reason: %s", pname, user, reason);
			IRC_GroupSay(groupID, channel, msg);
			format(msg, sizeof(msg), "*** %s has been unfrozen by Staff Member %s on IRC for reason: %s", pname, user, reason);
			SendClientMessageToAll(0x00E600C8, msg);
	        TogglePlayerControllable(playerid, 1);
		}
	}
	return 1;
}
//Unfreeze by Noah.

IRCCMD:explode(botid, channel[], user[], host[], params[])
{
	new playerid, reason[64];
	new player1;
	//Playerid
	if (sscanf(params, "dS(No reason.)[64]", playerid, reason))
	{
		return 1;
	}
    if (IRC_IsHalfop(botid, channel, user))
	{
		if(IsPlayerConnected(playerid))
		{
			new msg[128], pname[MAX_PLAYER_NAME];
			GetPlayerName(playerid, pname, sizeof(pname));
			format(msg, sizeof(msg), "*** %s has been exploded by Staff Member %s on IRC for reason: %s", pname, user, reason);
			IRC_GroupSay(groupID, channel, msg);
			format(msg, sizeof(msg), "*** %s has been exploded by Staff Member %s on IRC for reason: %s", pname, user, reason);
			SendClientMessageToAll(0xFF0000C8, msg);
			new Float:x, Float:y, Float:z;
			GetPlayerPos(player1,x,y,z);
			CreateExplosion(x, y, z, 0, 10.0);
		}
	}
	return 1;
}
//Explode, by Noah.

IRCCMD:disarm(botid, channel[], user[], host[], params[])
{
	new playerid, reason[64];
	//Playerid
	if (sscanf(params, "dS(No reason.)[64]", playerid, reason))
	{
		return 1;
	}
    if (IRC_IsHalfop(botid, channel, user))
	{
		if(IsPlayerConnected(playerid))
		{
			new msg[128], pname[MAX_PLAYER_NAME];
			GetPlayerName(playerid, pname, sizeof(pname));
			format(msg, sizeof(msg), "*** %s has been disarmed by Staff Member %s on IRC for reason: %s", pname, user, reason);
			IRC_GroupSay(groupID, channel, msg);
			format(msg, sizeof(msg), "*** %s has been disarmed by Staff Member %s on IRC for reason: %s", pname, user, reason);
			SendClientMessageToAll(0xFF0000C8, msg);
			ResetPlayerWeapons(playerid);
		}
	}
	return 1;
}
//Disarm by Noah.

IRCCMD:resetcash(botid, channel[], user[], host[], params[])
{
	new playerid, reason[64];
	//Playerid
	if (sscanf(params, "dS(No reason.)[64]", playerid, reason))
	{
		return 1;
	}
    if (IRC_IsHalfop(botid, channel, user))
	{
		if(IsPlayerConnected(playerid))
		{
			new msg[128], pname[MAX_PLAYER_NAME];
			GetPlayerName(playerid, pname, sizeof(pname));
			format(msg, sizeof(msg), "*** %s has been removed of their cash by Staff Member %s on IRC for reason: %s", pname, user, reason);
			IRC_GroupSay(groupID, channel, msg);
			format(msg, sizeof(msg), "*** %s has been removed of their cash by Staff Member %s on IRC for reason: %s", pname, user, reason);
			SendClientMessageToAll(0xFF0000C8, msg);
			ResetPlayerMoney(playerid);
		}
	}
	return 1;
}
//Resetcash, by Noah.

IRCCMD:giveallcash(botid, channel[], user[], host[], params[])
{
    new value;
	new msg1[128];
	new msg2[128];

    if(sscanf(params, "d", value) != 0)
    {
        return 1;
	}
	if (IRC_IsVoice(botid, channel, user))
	{
    	for(new i=0; i<MAX_PLAYERS; i++)
    	{
        	if(IsPlayerConnected(i))
        	{
				GivePlayerMoney(i, value);
                format(msg1, sizeof(msg1), "*** Happy Staff Member %s has given all players some cash!", user);
				IRC_GroupSay(groupID, channel, msg1);
                format(msg2, sizeof(msg2), "*** Happy Staff Member %s has given all players some cash!", user);
                SendClientMessageToAll(0x00E600C8, msg2);
			}
    	}
	}
	return 1;
}
//Giveallcash, by Noah.

IRCCMD:getname(botid, channel[], user[], host[], params[])
{
	new playerid;
	//Playerid
	if (sscanf(params, "d", playerid))
	{
		return 1;
	}
	if(IsPlayerConnected(playerid))
	{
		new msg[128], pname[MAX_PLAYER_NAME];
		GetPlayerName(playerid, pname, sizeof(pname));
		format(msg, sizeof(msg), "*** The player's name is %s", pname, user);
		IRC_GroupSay(groupID, channel, msg);
	}
	return 1;
}
//Getname, by Noah.

IRCCMD:forums(botid, channel[], user[], host[], params[])
{
	new string29[128];
	new string30[128];

	if (IRC_IsVoice(botid, channel, user))
	{
		format(string29, 128, "Sign up at our forums today! http://www.teamzl.forumotion.com");
		format(string30, 128, "Sign up at our forums today! http://www.teamzl.forumotion.com");

		IRC_GroupSay(groupID, channel, string29);

		SendClientMessageToAll(0x00E800C8, string30);
	}
	return 1;
}
//Forums, by Noah.

IRCCMD:disablestuntbonus(botid, channel[], user[], host[], params[])
{
	new string31[128];
	new string32[128];

	if (IRC_IsOp(botid, channel, user))
	{
		format(string31, 128, "*** A Staff Member has disabled stunt bonuses for everyone!");
		format(string32, 128, "*** A Staff Member has disabled stunt bonuses for everyone!");

		IRC_GroupSay(groupID, channel, string31);

		SendClientMessageToAll(0xFF0000C8, string32);
		EnableStuntBonusForAll(false);
	}
	return 1;
}
//DisableStuntBonus by Noah.

IRCCMD:enablestuntbonus(botid, channel[], user[], host[], params[])
{
	new string33[128];
	new string34[128];

	if (IRC_IsOp(botid, channel, user))
	{
		format(string33, 128, "*** A Staff Member has enabled stunt bonuses for everyone!");
		format(string34, 128, "*** A Staff Member has enabled stunt bonuses for everyone!");

		IRC_GroupSay(groupID, channel, string33);

		SendClientMessageToAll(0x00FF00C8, string34);
		EnableStuntBonusForAll(true);
	}
	return 1;
}
//EnableStuntBonus by Noah.

IRCCMD:spawn(botid, channel[], user[], host[], params[])
{
	new playerid, reason[64];
	//Playerid
	if (sscanf(params, "dS(No reason.)[64]", playerid, reason))
	{
		return 1;
	}
    if (IRC_IsVoice(botid, channel, user))
	{
		if(IsPlayerConnected(playerid))
		{
			new msg[128], pname[MAX_PLAYER_NAME];
			GetPlayerName(playerid, pname, sizeof(pname));
			format(msg, sizeof(msg), "*** %s has been spawned by Staff Member %s on IRC for reason: %s", pname, user, reason);
			IRC_GroupSay(groupID, channel, msg);
			format(msg, sizeof(msg), "*** %s has been spawned by Staff Member %s on IRC for reason: %s", pname, user, reason);
			SendClientMessageToAll(0xFF0000C8, msg);
			SpawnPlayer(playerid);
		}
	}
	return 1;
}
// Spawn by Noah.

IRCCMD:fuck(botid, channel[], user[], host[], params[])
{
	new playerid;
	//Playerid
	if (sscanf(params, "d", playerid))
	{
		return 1;
	}
	if(IsPlayerConnected(playerid))
	{
		new msg[128], pname[MAX_PLAYER_NAME], msg2[128];
		GetPlayerName(playerid, pname, sizeof(pname));
		format(msg, sizeof(msg), "*** %s would like to anally fuck %s", user, pname);
		format(msg2, 128, "*** %s would like to anally fuck %s", user, pname);
		SendClientMessageToAll(0x00E800C8, msg2);
		IRC_GroupSay(groupID, channel, msg);
	}
	return 1;
}
//Fuck by noah.

IRCCMD:getinfo(botid, channel[], user[], host[], params[])
{
	new playerid, pIP[128], Float:health, Float:armour;
	//Playerid
	if (sscanf(params, "d", playerid))
	{
		return 1;
	}
	if(IsPlayerConnected(playerid))
	{
		new msg[128], pname[MAX_PLAYER_NAME];
		GetPlayerName(playerid, pname, sizeof(pname));
		GetPlayerIp(playerid, pIP, 128);
		GetPlayerHealth(playerid, health);
		GetPlayerArmour(playerid, armour);
		new ping;
		ping = GetPlayerPing(playerid);
		format(msg, sizeof(msg), "*** %s's info: IP: %s | Health: %d | Armour: %d | Ping: %d", pname, pIP, floatround(health), floatround(armour), ping);
		IRC_GroupSay(groupID, channel, msg);
	}
	return 1;
}

IRCCMD:respawncars(botid, channel[], user[], host[], params[])
{
	new string1[128], string2[128];

	for(new i = 1; i <= MAX_VEHICLES; i++)
	{
		SetVehicleToRespawn(i);
	}
	format(string1, 128, "*** Staff Member %s has respawned all vehicles", user);
	format(string2, 128, "*** Staff Member %s has respawned all vehicles", user);

	IRC_GroupSay(groupID, channel, string1);
	SendClientMessageToAll(0x00E800C8, string2);
	return 1;
}
//By NoahF.
/*

CREDITS:

Creators of this script: NoahF and Zacklogan

Misc. Credits:

Incognito for the IRC Plugin

Y_Less for SSCANF

Thanks for using. */
