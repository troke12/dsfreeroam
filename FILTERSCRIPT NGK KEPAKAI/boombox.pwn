// Includes
#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <streamer>

// Defines
#define COLOR_WHITE 0xFFFFFFFF
#define COLOR_LIGHTBLUE 0x33CCFFFF
#define COLOR_GREY 0xAFAFAFFF

// Variables
new Boombox[MAX_PLAYERS];
new BoomboxObject[MAX_PLAYERS];
new BoomboxStream[MAX_PLAYERS];
new BoomboxPlayer[MAX_PLAYERS];
new BoomboxURL[MAX_PLAYERS][256];
new Float:bpos[MAX_PLAYERS][4];

// Clearing variables
public OnPlayerConnect(playerid)
{
    Boombox[playerid] = 0;
    BoomboxPlayer[playerid] = -1;
    BoomboxStream[playerid] = 0;
    bpos[playerid][0] = 0; bpos[playerid][1] = 0; bpos[playerid][2] = 0; bpos[playerid][3] = 0;
    format(BoomboxURL[playerid], 256, "");
    if(IsValidDynamicObject(BoomboxObject[playerid])) DestroyDynamicObject(BoomboxObject[playerid]);
    return 1;
}

// Clearing variables & Stopping boombox music on disconnect (Double check)
public OnPlayerDisconnect(playerid)
{
    Boombox[playerid] = 0;
    BoomboxPlayer[playerid] = -1;
    BoomboxStream[playerid] = 0;
    bpos[playerid][0] = 0; bpos[playerid][1] = 0; bpos[playerid][2] = 0; bpos[playerid][3] = 0;
    format(BoomboxURL[playerid], 256, "");
    if(IsValidDynamicObject(BoomboxObject[playerid])) DestroyDynamicObject(BoomboxObject[playerid]);
    for(new i=0; i<MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            if(BoomboxPlayer[i] == playerid)
            {
                BoomboxStream[i] = 0;
                BoomboxPlayer[i] = -1;
                StopAudioStreamForPlayer(i);
                SendClientMessage(i, COLOR_GREY, " The boombox creator has disconnected from the server.");
            }
        }
    }
    return 1;
}


// Boombox command - Usage: /boombox [URL]
CMD:boombox(playerid, params[])
{
    new string[128];
    if(!Boombox[playerid])
    {
        if(sscanf(params, "s[256]", params)) return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /boombox [music url]");
        for(new i=0; i<MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i))
            {
                    if(Boombox[i])
                    {
                        if(IsPlayerInRangeOfPoint(playerid, 30, bpos[i][0], bpos[i][1], bpos[i][2]))
                        {
                            SendClientMessage(playerid, COLOR_GREY, " There is another boombox nearby, place yours somewhere else.");
                            return 1;
                        }
                    }
            }
        }
        Boombox[playerid] = 1;
        format(string, sizeof(string), " You have placed your boombox at your location.");
        SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
        GetPlayerPos(playerid, bpos[playerid][0], bpos[playerid][1], bpos[playerid][2]); bpos[playerid][2] = bpos[playerid][2] - 1;
        GetPlayerFacingAngle(playerid, bpos[playerid][3]); bpos[playerid][3] = bpos[playerid][3] +180;
        BoomboxObject[playerid] = CreateDynamicObject(2103, bpos[playerid][0], bpos[playerid][1], bpos[playerid][2], 0, 0, bpos[playerid][3]);
        format(BoomboxURL[playerid], 256, "%s", params);
    }
    else
    {
        Boombox[playerid] = 0;
        format(string, sizeof(string), " You have removed your boombox.");
        SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
        DestroyDynamicObject(BoomboxObject[playerid]);
        format(BoomboxURL[playerid], 256, "");
        for(new i=0; i<MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i))
            {
                if(BoomboxPlayer[i] == playerid)
                {
                    BoomboxStream[i] = 0;
                    BoomboxPlayer[i] = -1;
                    StopAudioStreamForPlayer(i);
                    SendClientMessage(i, COLOR_GREY, " The boombox creator has removed his boombox.");
                }
            }
        }
    }
    return 1;
}

// Boombox editing - Usage: /boomboxnext [url]
CMD:boomboxnext(playerid, params[])
{
    if(!Boombox[playerid]) return SendClientMessage(playerid, COLOR_GREY, "You don't have a boombox placed.");
    if(sscanf(params, "s[256]", params)) return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /boomboxnext [music url]");
    SendClientMessage(playerid, COLOR_GREY, " You have changed the music your boombox is playing.");
    format(BoomboxURL[playerid], 256, "%s", params);
    for(new i=0; i<MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
                if(BoomboxPlayer[i] == playerid)
                {
                    PlayAudioStreamForPlayer(i, BoomboxURL[playerid], bpos[playerid][0], bpos[playerid][1], bpos[playerid][2], 30, 1);
                    SendClientMessage(i, COLOR_GREY, " The boombox music you're listening to has changed.");
                }
        }
    }
    return 1;
}


// Playing/Stopping boombox music for nearby players
public OnPlayerUpdate(playerid)
{
    if(!BoomboxStream[playerid])
    {
        for(new i=0; i<MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i))
            {
                if(Boombox[i])
                {
                    if(IsPlayerInRangeOfPoint(playerid, 30, bpos[i][0], bpos[i][1], bpos[i][2]))
                    {
                        PlayAudioStreamForPlayer(playerid, BoomboxURL[i], bpos[i][0], bpos[i][1], bpos[i][2], 30, 1);
                        BoomboxPlayer[playerid] = i;
                        BoomboxStream[playerid] = 1;
                        SendClientMessage(playerid, COLOR_GREY, " You are listening to music coming out of a nearby boombox.");
                    }
                }
            }
        }
    }
    else
    {
        new i = BoomboxPlayer[playerid];
        if(!IsPlayerInRangeOfPoint(playerid, 30, bpos[i][0], bpos[i][1], bpos[i][2]))
        {
            BoomboxStream[playerid] = 0;
            BoomboxPlayer[playerid] = -1;
            StopAudioStreamForPlayer(playerid);
            SendClientMessage(playerid, COLOR_GREY, " You have went far away from the boombox.");
        }
    }
    return 1;
}
