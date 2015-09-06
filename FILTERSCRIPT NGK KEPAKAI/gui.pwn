// This is a comment
// uncomment the line below if you want to write a filterscript
#define FILTERSCRIPT

#include <a_samp>
#include <dini>
#include <dudb>
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_RED 0xAA3333AA
#define COLOR_YELLOW 0xFFFF00AA
#define yellow 0xFFFF00AA
#define COLOR_POWDERBLUE 0xB0E0E6FF
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_BLUE 0x0000BBAA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_GOLD 0xFFD700FF
#define COLOR_LIGHTGREEN 0x90EE90FF
#define COLOR_OLIVE 0x808000FF
#define COLOR_ORED 0xFF0000FF
#define COLOR_SALMON 0xFA8072FF
#define COLOR_GREEN 0x00F20096
#define green 0x00F20096
#define red 0xFF0000FF
#define RED 0xFF0000FF
#define COLOR_MAGENTA 0xFF00FFFF
#define COLOR_TEAL 0x008080FF
#define COLOR_BROWN 0xFFBB7796
public OnFilterScriptInit()
{
    print("\n--------------------------------------");
    print(" Blank Filterscript by your name here");
    print("--------------------------------------\n");
    return 1;
}
new Member[MAX_PLAYERS];
new Leader[MAX_PLAYERS];
new IsInOrg[MAX_PLAYERS];
new IsLaw[MAX_PLAYERS];
public OnFilterScriptExit()
{
    return 1;
}
public OnPlayerConnect(playerid)
{
new name[MAX_PLAYER_NAME], file[256];
    GetPlayerName(playerid, name, sizeof(name));
    format(file, sizeof(file), "%s_ORG.ini", name);
                    Member[playerid] = dini_Int(file, "Member");
                    Leader[playerid] = dini_Int(file,"Leader");
                    IsInOrg[playerid] = dini_Int(file,"InOrg");
                    IsLaw[playerid] = dini_Int(file,"Law");
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
new name[MAX_PLAYER_NAME], file[256];
    GetPlayerName(playerid, name, sizeof(name));
    format(file, sizeof(file), "%s_ORG.ini", name);
dini_IntSet(file,"Leader",Leader[playerid]);
dini_IntSet(file,"InOrg",IsInOrg[playerid]);
dini_IntSet(file,"Law",IsLaw[playerid]);
    return 1;
}

public OnPlayerSpawn(playerid)
{
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
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

public OnPlayerText(playerid, text[])
{
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
 new cmd[256];
 new idx;
 cmd = strtok(cmdtext, idx);

    if (streq(cmd,"/setleader1"))
{
    if(!strlen(cmdtext[12]))
    {
        SendClientMessage(playerid, red, "Usage: /setleader1 [playerid]");
        return 1;
    }
    new ID = strval(cmdtext[12]);
    new pName[24], str[64];
    if(IsPlayerConnected(ID))
    {
        GetPlayerName(playerid, pName, 24);
        format(str, 123, "Admin %s has set your the leader of organization Gang.", pName);
        SendClientMessage(ID,COLOR_LIGHTBLUE, str);
        SetPlayerColor(ID, 0x00C300FF); // Color
        GivePlayerWeapon(ID,28,5000); // Weapon1
        GivePlayerWeapon(ID,1,-1); // Weapon 2
        IsInOrg[ID] = 1; // This tells that the user is already in an organization.
        Member[ID] = 1; //This is org id, forexample my org id i want is 1 , so i will put 1, if i want it 2 , i will put 2. Note; do not duplicate the number.
        Leader[ID] = 1; //This will remain as "1". This shows that the player ur setting is a leader.
        IsLaw[ID] = 0; // This shows that the org is not a law enforcement, its a Gang.
        format(str, 123, "You have set a player leader of Gang.");
        SendClientMessage(playerid,red, str);
    }
    return 1;

}
if(Leader[playerid] == 1) {
if (streq(cmd,"/setmember"))
{
    if(!strlen(cmdtext[11]))
    {
        SendClientMessage(playerid, red, "Usage: /setmember [playerid]");
        return 1;
    }
    new ID = strval(cmdtext[11]);
    new pName[24], str[64];
    if(IsPlayerConnected(ID))
    {
        GetPlayerName(playerid, pName, 24);
     if(IsInOrg[ID] == 1) return SendClientMessage(playerid,red,"Ths user is already in an organization!");
     else   if(Member[playerid] == 1 && Member[ID] == 0)
{
        format(str, 123, "Your application to join Gang has been accepted by leader %s.", pName);
SendClientMessage(ID,COLOR_LIGHTBLUE,str);
       SetPlayerColor(ID,0x0000BBAA); //color
        SendClientMessage(ID,green, str);
        GivePlayerWeapon(ID,24,250); //weapon1
        GivePlayerWeapon(ID,3,99999); //weapon2
        GivePlayerWeapon(ID,29,1000); //weapon3 (optional)
        IsInOrg[ID] = 1; //Shows that the user that leader is recruiting is is in org.
        IsLaw[ID] = 0; //Not a law, gang.
        Member[ID] = 1; // Org ID
        format(str, 123, "You have accepted the following member into your organization.");
        SendClientMessage(playerid,COLOR_LIGHTBLUE, str);
}
return 1;
}
}
}

     else if (streq(cmd,"/kickmember"))
{
    if(!strlen(cmdtext[11]))
    {
        SendClientMessage(playerid, red, "Usage: /kickmember [playerid]");
        return 1;
    }

    new ID = strval(cmdtext[11]);
    new pName[24], str[64];

    if(IsPlayerConnected(ID))
    {
        GetPlayerName(playerid, pName, 24);
 if(Member[playerid] == 1 && Member[ID] == 1)
{
        format(str, 123, "Leader %s has kicked you from organization gang.", pName);
        SendClientMessage(ID,COLOR_ORANGE, str);
        SetPlayerSkin(ID, 299);
        ResetPlayerWeapons(ID);
        Member[ID] = 0;
        IsLaw[playerid] = 0;
        IsInOrg[ID] = 0;
        SetPlayerColor(ID, 0xFFFFFFFF);
        format(str, 123, "You have kicked a player from gang.");
        SendClientMessage(playerid,red, str);

}
return 1;
}
}
    return 0;
}

streq(str1[],str2[])
{
        if (strlen(str1)!=strlen(str2)) return 0;

        return strcmp(str1,str2,true)==0;
}
