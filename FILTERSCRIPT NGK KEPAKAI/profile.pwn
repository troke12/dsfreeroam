#include <a_samp>
#include <ZCMD>
#include <sscanf2>
#include <profile>

new ADMIN_LEVELS[][] =
{
    "None", //<-- Level 0
    "Helper", //<-- Level 1
    "Moderator",
    "Server Moderator",
    "Administrator",
    "Owner" //<-- Level 5
};

enum pInfo //<-- If you use these weird & shitty names XD
{
    pAdminLevel,
    pScore,
    pMoney
    //bla bla..
}
new PlayerInfo[MAX_PLAYERS][pInfo];

CMD:setlevel(playerid, params[])
{
    if(PlayerInfo[playerid][pAdminLevel] < 4)
    return SendClientMessage(playerid, -1, "ERROR: You need to be a level 4 admin");

    new targetid, level;
    if(sscanf(params, "ui", targetid, level))
    return SendClientMessage(playerid, -1, "USAGE: /setlevel [PlayerID] [Level]");

    if(!IsPlayerConnected(targetid))
    return SendClientMessage(playerid, -1, "ERROR: Player is not connected");

    if(level < 0 || level > 5)
    return SendClientMessage(playerid, -1, "ERROR: Enter a valid level (0 - 5)");

    Profile_SetAdminLevel(targetid, level, ADMIN_LEVELS[level]); //<--
    PlayerInfo[targetid][pAdminLevel] = level;

    new message[64], name[MAX_PLAYER_NAME];

    GetPlayerName(playerid, name, sizeof name);
    format(message, sizeof message, "%s has give you a new admin level: %i", name, level);
    SendClientMessage(targetid, -1, message);

    GetPlayerName(targetid, name, sizeof name);
    format(message, sizeof message, "You made %s level %i", name, level);
    SendClientMessage(playerid, -1, message);
    return true;
}
