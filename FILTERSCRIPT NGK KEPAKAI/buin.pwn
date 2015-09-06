//Includes
#include <a_samp>
#include <streamer>
#include <sscanf2>
#include <zcmd>
#include <YSI\y_ini>
//Defines
#define SCM SendClientMessage //Saves time
#define BPATH "/biz/%i.ini" //Defines the path y_ini will use to find the .ini file we need.
//The below colors do not have to be used, but you will need to edit the script if you choose not to use them.
#define NEWBIE_COLOR        0x7DAEFFFF
#define TCOLOR_WHITE        0xFFFFFF00
#define COLOR_GRAD1         0xB4B5B7FF
#define COLOR_GRAD2         0xBFC0C2FF
#define COLOR_GRAD3         0xCBCCCEFF
#define COLOR_GRAD4         0xD8D8D8FF
#define COLOR_GRAD5         0xE3E3E3FF
#define COLOR_GRAD6         0xF0F0F0FF
#define COLOR_FADE1         0xE6E6E6E6
#define COLOR_FADE2         0xC8C8C8C8
#define COLOR_FADE3         0xAAAAAAAA
#define COLOR_FADE4         0x8C8C8C8C
#define COLOR_FADE5         0x6E6E6E6E
#define COLOR_PURPLE        0xC2A2DAAA
#define COLOR_RED           0xAA3333AA
#define COLOR_GREY          0xAFAFAFAA
#define COLOR_GREEN         0x33AA33AA
#define COLOR_BLACK         0x000001FF
#define COLOR_BLUE          0x007BD0FF
#define COLOR_LIGHTORANGE   0xFFA100FF
#define COLOR_FLASH         0xFF000080
#define COLOR_LIGHTRED      0xFF6347AA
#define COLOR_LIGHTBLUE     0x01FCFFC8
#define COLOR_LIGHTGREEN    0x9ACD32AA
#define COLOR_YELLOW        0xFFFF00AA
#define COLOR_LIGHTYELLOW   0xFFFF91FF
#define COLOR_YELLOW2       0xF5DEB3AA
#define COLOR_WHITE         0xFFFFFFAA

new InsideBiz[MAX_PLAYERS];//This define will be used later to find out what business we are in.

enum bInfo
{
    bOwned,
    bPrice,
    bOwner[MAX_PLAYER_NAME],
    bType,
    bLocked,
    bMoney,
    Float:bEntranceX,
    Float:bEntranceY,
    Float:bEntranceZ,
    Float:bEntranceA,
    Float:bExitX,
    Float:bExitY,
    Float:bExitZ,
    Float:bExitA,
    bInt,
    bWorld,
    bInsideInt,
    bInsideWorld,
    bInsideIcon,
    bOutsideIcon,
    bName[128]
}
new BusinessInfo[200][bInfo];//We are creating a define to use for our Enum.

enum pInfo
{
	BizID,
	Money,
	Skin
}

new PlayerInfo[200][pInfo];

public OnGameModeInit()
{
    new str[40];
    for(new idx = 1; idx < sizeof(BusinessInfo); idx++)//Creates a loop, that goes through all of the businesses.
    {
        format(str, sizeof(str), BPATH, idx);//formats the file path, with the biz ID
        INI_ParseFile(str, "loadbiz_%s", .bExtra = true, .extra = idx );//This is very hard to explain, but it basically loads the info from the file(More in Y_Less y_ini tutorial.)
        BusinessInfo[idx][bOutsideIcon] = CreateDynamicPickup(1272, 1, BusinessInfo[idx][bEntranceX], BusinessInfo[idx][bEntranceY], BusinessInfo[idx][bEntranceZ], BusinessInfo[idx][bWorld]); //Creates a pickup at the business entrance.
        BusinessInfo[idx][bInsideIcon] = CreateDynamicPickup(1272, 1, BusinessInfo[idx][bExitX], BusinessInfo[idx][bExitY], BusinessInfo[idx][bExitZ], BusinessInfo[idx][bInsideWorld]); //Creates a pickup at the exit(Inside the interior)
    }
	return 1;
}
public OnGameModeExit()
{
    for(new id = 1; id < sizeof(BusinessInfo); id++)//Loops through the businesses.
    {
        if(BusinessInfo[id][bPrice] == 0) break;//Breaks the loop if the price is 0(Meaning it doesn't exist)
        SaveBusiness(id);//Calls the SaveBusiness function.
    }
 	return 1;
}
forward SaveBusiness(id);
public SaveBusiness(id)
{
    new file4[40];
    format(file4, sizeof(file4), BPATH, id);
    new INI:File = INI_Open(file4);
    INI_SetTag(File,"data");
    INI_WriteInt(File,"bOwned", BusinessInfo[id][bOwned]);
    INI_WriteInt(File,"bPrice", BusinessInfo[id][bPrice]);
    INI_WriteString(File,"bOwner", BusinessInfo[id][bOwner]);
    INI_WriteInt(File,"bType", BusinessInfo[id][bType]);
    INI_WriteInt(File,"bLocked", BusinessInfo[id][bLocked]);
    INI_WriteInt(File,"bMoney", BusinessInfo[id][bMoney]);
    INI_WriteFloat(File,"bEntranceX", BusinessInfo[id][bEntranceX]);
    INI_WriteFloat(File,"bEntranceY", BusinessInfo[id][bEntranceY]);
    INI_WriteFloat(File,"bEntranceZ", BusinessInfo[id][bEntranceZ]);
    INI_WriteFloat(File,"bEntranceA", BusinessInfo[id][bEntranceA]);
    INI_WriteFloat(File,"bExitX", BusinessInfo[id][bExitX]);
    INI_WriteFloat(File,"bExitY", BusinessInfo[id][bExitY]);
    INI_WriteFloat(File,"bExitZ", BusinessInfo[id][bExitZ]);
    INI_WriteFloat(File,"bExitA", BusinessInfo[id][bExitA]);
    INI_WriteInt(File,"bInt", BusinessInfo[id][bInt]);
    INI_WriteInt(File,"bWorld", BusinessInfo[id][bWorld]);
    INI_WriteInt(File,"bInsideInt", BusinessInfo[id][bInsideInt]);
    INI_WriteInt(File,"bInsideWorld", BusinessInfo[id][bInsideWorld]);
    INI_WriteString(File,"bName", BusinessInfo[id][bName]);
    INI_Close(File);
    return 1;
}
forward loadbiz_data(idx, name[], value[]);
public loadbiz_data(idx, name[], value[])
{
    INI_Int("bOwned", BusinessInfo[idx][bOwned]);
    INI_Int("bPrice", BusinessInfo[idx][bPrice]);
    INI_String("bOwner", BusinessInfo[idx][bOwner], 24);
    INI_Int("bType", BusinessInfo[idx][bType]);
    INI_Int("bLocked", BusinessInfo[idx][bLocked]);
    INI_Int("bMoney", BusinessInfo[idx][bMoney]);
    INI_Float("bEntranceX", BusinessInfo[idx][bEntranceX]);
    INI_Float("bEntranceY", BusinessInfo[idx][bEntranceY]);
    INI_Float("bEntranceZ", BusinessInfo[idx][bEntranceZ]);
    INI_Float("bEntranceA", BusinessInfo[idx][bEntranceA]);
    INI_Float("bExitX", BusinessInfo[idx][bExitX]);
    INI_Float("bExitY", BusinessInfo[idx][bExitY]);
    INI_Float("bExitZ", BusinessInfo[idx][bExitZ]);
    INI_Float("bExitA", BusinessInfo[idx][bExitA]);
    INI_Int("bInt", BusinessInfo[idx][bInt]);
    INI_Int("bWorld", BusinessInfo[idx][bWorld]);
    INI_Int("bInsideInt", BusinessInfo[idx][bInsideInt]);
    INI_Int("bInsideWorld", BusinessInfo[idx][bInsideWorld]);
    INI_String("bName", BusinessInfo[idx][bName], 128);
    return 1;
}

CMD:createbiz(playerid, params[])
{
    if(!IsPlayerAdmin(playerid)) return SCM(playerid, COLOR_GREY, "You aren't authorized to use this command!");//Checks if player is a RCON admin..Change this with your admin system.

    new price, level, id, int, world, string[128], Float:Xi, Float:Yi, Float:Zi, inti;//All the new defines we will need.
    if(sscanf(params, "dddfff", price, level, inti, Xi, Yi, Zi)) return SendClientMessage(playerid, COLOR_GREY, "CMD: /createbiz [price] [type] [interior] [X] [Y] [Z]");//d stands for integer, f stands for float.

    if(level < 0 || level > 4) return SendClientMessage(playerid, COLOR_GREY, "CMD: Type cannot go below 0, or above 10.");//

    if(price < 10000) return SendClientMessage(playerid, COLOR_GREY, "CMD: Price cannot go below $10,000.");// Check if the price is below 1000, if it is it will return a message saying it.

    for(new h = 1;h < sizeof(BusinessInfo);h++)//Loops through all the businesses
    {
        if(BusinessInfo[h][bPrice] == 0)//Checks if the price of a business is 0.
        {
            id = h;
            break;//It stops looping if it is.
        }
    }
    new Float:X,Float:Y,Float:Z,Float:A;//More new defines.
    GetPlayerPos(playerid, X, Y, Z);//Gets your player position, and saves it into floats.
    GetPlayerFacingAngle(playerid, A);//Gets your facing angle, and saves it into a float.
    int = GetPlayerInterior(playerid);//Gets your interior, and saves it into a integer.
    world = GetPlayerVirtualWorld(playerid);//Gets your Virtual World, and saves it into a integer
    BusinessInfo[id][bInsideInt] = inti;
    BusinessInfo[id][bExitX] = Xi;
    BusinessInfo[id][bExitY] = Yi;
    BusinessInfo[id][bExitZ] = Zi;

    BusinessInfo[id][bOwned] = 0;
    BusinessInfo[id][bPrice] = price;
    BusinessInfo[id][bType] = level;
    BusinessInfo[id][bEntranceX] = X;
    BusinessInfo[id][bEntranceY] = Y;
    BusinessInfo[id][bEntranceZ] = Z;
    BusinessInfo[id][bEntranceA] = A;
    BusinessInfo[id][bLocked] = 1;

    BusinessInfo[id][bInt] =int;
    BusinessInfo[id][bWorld] =world;
    BusinessInfo[id][bInsideWorld] =id;

    format(string, sizeof(string), "None");
    strmid(BusinessInfo[id][bName], string, 0, strlen(string), 255);

    if(BusinessInfo[id][bOutsideIcon]) DestroyDynamicPickup(BusinessInfo[id][bOutsideIcon]);
    if(BusinessInfo[id][bInsideIcon]) DestroyDynamicPickup(BusinessInfo[id][bInsideIcon]);
    BusinessInfo[id][bOutsideIcon] = CreateDynamicPickup(1272, 1, BusinessInfo[id][bEntranceX], BusinessInfo[id][bEntranceY], BusinessInfo[id][bEntranceZ], BusinessInfo[id][bWorld]);//Creates a pickup at your location
    BusinessInfo[id][bInsideIcon] = CreateDynamicPickup(1272, 1, BusinessInfo[id][bExitX], BusinessInfo[id][bExitY], BusinessInfo[id][bExitZ], BusinessInfo[id][bInsideWorld]);//Creates a pickup at your location
    new file4[40];
    format(file4, sizeof(file4), BPATH, id);
    new INI:File = INI_Open(file4);
    INI_SetTag(File,"data");
    INI_WriteInt(File,"bOwned", BusinessInfo[id][bOwned]);
    INI_WriteInt(File,"bPrice", BusinessInfo[id][bPrice]);
    INI_WriteString(File,"bOwner", BusinessInfo[id][bOwner]);
    INI_WriteInt(File,"bType", BusinessInfo[id][bType]);
    INI_WriteInt(File,"bLocked", BusinessInfo[id][bLocked]);
    INI_WriteInt(File,"bMoney", BusinessInfo[id][bMoney]);
    INI_WriteFloat(File,"bEntranceX", BusinessInfo[id][bEntranceX]);
    INI_WriteFloat(File,"bEntranceY", BusinessInfo[id][bEntranceY]);
    INI_WriteFloat(File,"bEntranceZ", BusinessInfo[id][bEntranceZ]);
    INI_WriteFloat(File,"bEntranceA", BusinessInfo[id][bEntranceA]);
    INI_WriteFloat(File,"bExitX", BusinessInfo[id][bExitX]);
    INI_WriteFloat(File,"bExitY", BusinessInfo[id][bExitY]);
    INI_WriteFloat(File,"bExitZ", BusinessInfo[id][bExitZ]);
    INI_WriteFloat(File,"bExitA", BusinessInfo[id][bExitA]);
    INI_WriteInt(File,"bInt", BusinessInfo[id][bInt]);
    INI_WriteInt(File,"bWorld", BusinessInfo[id][bWorld]);
    INI_WriteInt(File,"bInsideInt", BusinessInfo[id][bInsideInt]);
    INI_WriteInt(File,"bInsideWorld", BusinessInfo[id][bInsideWorld]);
    INI_WriteString(File,"bName", BusinessInfo[id][bName]);
    INI_Close(File);
    return 1;
}
CMD:deletebiz(playerid, params[])
{
    if(!IsPlayerAdmin(playerid)) return 1; // Checks if a player is a RCON admin, again change this to your admin system.

    new id;

    if(sscanf(params, "d", id)) return SendClientMessage(playerid, COLOR_GREY, "CMD: /deletebiz [id]");
    if(BusinessInfo[id][bOwned] == 1) return SCM(playerid, COLOR_GREY, "This biz is owned.");//Checks if the biz is owned, if it is it won't allow it to be deleted.
        //Below it resets all the biz enum info.
    BusinessInfo[id][bOwned] = 0;
    BusinessInfo[id][bPrice] = 0;
    BusinessInfo[id][bOwner] = 0;
    BusinessInfo[id][bType] = 0;
    BusinessInfo[id][bLocked] = 0;
    BusinessInfo[id][bName] = 0;
    BusinessInfo[id][bMoney] = 0;
    BusinessInfo[id][bEntranceX] = 0;
    BusinessInfo[id][bEntranceY] = 0;
    BusinessInfo[id][bEntranceZ] = 0;
    BusinessInfo[id][bEntranceA] = 0;
    BusinessInfo[id][bExitX] = 0;
    BusinessInfo[id][bExitY] = 0;
    BusinessInfo[id][bExitZ] = 0;
    BusinessInfo[id][bExitA] = 0;
    BusinessInfo[id][bInt] = 0;
    BusinessInfo[id][bWorld] = 0;

    if(BusinessInfo[id][bOutsideIcon]) DestroyDynamicPickup(BusinessInfo[id][bOutsideIcon]);//Destroys the pickup.

    new string[128];

    format(string, sizeof(string), BPATH, id);
    fremove(string);
    return 1;
}
public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    new string[256];
    for(new b = 1;b < sizeof(BusinessInfo);b++)// Loopd through all the businesses again.
    {
        if(pickupid == BusinessInfo[b][bOutsideIcon])//Checks if it's a biz pickup.
        {
           if(BusinessInfo[b][bOwned] == 0)//Checks if it is owned.
           {
                format(string, sizeof(string), "~g~Name:~w~%s~n~~w~This business is ~g~for sale!~n~~r~Price:~g~%i~n~BizType:~w~%s~n~~g~BizID:~w~%i", BusinessInfo[b][bName], BusinessInfo[b][bPrice], BusinessType(b), b);//Formats a string with all the info.
                GameTextForPlayer(playerid, string, 3000, 3);
           }
           if(BusinessInfo[b][bOwned] == 1)//Checks if it owned.
           {
                format(string, sizeof(string), "~g~Name:~w~%s~n~~g~Owner:~w~%s~n~~g~BizType:~w~%s ~n~~g~BizID:~w~%i", BusinessInfo[b][bName], BusinessInfo[b][bOwner], BusinessType(b), b);//Formats a string with all the info.
                GameTextForPlayer(playerid, string, 3000, 3);
           }
        }
    }
    return 1;
}
stock BusinessType(b)// creates a stock.
{
    new string[30];
    switch(BusinessInfo[b][bType])//You should know what switch is.
    {
        case 4: string = "24/7";
        case 3: string = "Club";
        case 2: string = "Bar";
        case 1: string = "Clothes Shop";
    }
    return string;
}
IsPlayerNearBizEnt(playerid)
{
    for(new b = 1; b < sizeof(BusinessInfo); b++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 2.0, BusinessInfo[b][bEntranceX], BusinessInfo[b][bEntranceY], BusinessInfo[b][bEntranceZ])) return b;
    }
    return -1;
}
CMD:lockbiz(playerid, params[])
{
    new id = IsPlayerNearBizEnt(playerid);//Uses the function to find if player is near a biz!
    if(id != PlayerInfo[playerid][BizID]) return SCM(playerid, COLOR_GREY, "This isn't your biz!");
    if(BusinessInfo[id][bLocked] == 1)
    {
        BusinessInfo[id][bLocked] = 0;
        GameTextForPlayer(playerid, "Biz ~g~unlocked!", 3000, 3);
    }
    else
    {
        BusinessInfo[id][bLocked] = 1;
        GameTextForPlayer(playerid, "Biz ~r~locked!", 3000, 3);
    }
    return 1;
}
CMD:enter(playerid, params[])
{
    for(new b = 1; b < sizeof(BusinessInfo); b++)//Loops through all the businesses.
    {
        if(IsPlayerInRangeOfPoint(playerid, 1.0, BusinessInfo[b][bEntranceX], BusinessInfo[b][bEntranceY], BusinessInfo[b][bEntranceZ]))//Checks if player is near the entrance.
        {
            if(BusinessInfo[b][bLocked] == 1) return SendClientMessage(playerid, COLOR_GREY, "This Business is locked!");//Checks it it is locked/
            SetPlayerPos(playerid, BusinessInfo[b][bExitX], BusinessInfo[b][bExitY], BusinessInfo[b][bExitZ]);
            SetPlayerFacingAngle(playerid, BusinessInfo[b][bExitA]);
            SetPlayerInterior(playerid, BusinessInfo[b][bInsideInt]);
            SetPlayerVirtualWorld(playerid, BusinessInfo[b][bInsideWorld]);
            InsideBiz[playerid] = b;
            return 1;
        }
        if(IsPlayerInRangeOfPoint(playerid, 2.0, BusinessInfo[b][bExitX], BusinessInfo[b][bExitY], BusinessInfo[b][bExitZ]) && GetPlayerVirtualWorld(playerid) == BusinessInfo[b][bInsideWorld])//Checks if player is in near the exit.
        {
            SetPlayerPos(playerid, BusinessInfo[b][bEntranceX], BusinessInfo[b][bEntranceY], BusinessInfo[b][bEntranceZ]);
            SetPlayerFacingAngle(playerid, BusinessInfo[b][bEntranceA]);
            SetPlayerInterior(playerid, BusinessInfo[b][bInt]);
            SetPlayerVirtualWorld(playerid, BusinessInfo[b][bWorld]);
            InsideBiz[playerid] = 0;
            return 1;
        }
    }
    return 1;
}
CMD:buybiz(playerid, params[])
{

    new id = IsPlayerNearBizEnt(playerid);

    if(id == -1 || id == 0) return SendClientMessage(playerid, COLOR_GREY, "You are not near a biz");

    if(BusinessInfo[id][bOwned] != 0 || BusinessInfo[id][bPrice] == 0) return SendClientMessage(playerid, COLOR_GREY, "This biz is not for sale.");

    if(PlayerInfo[playerid][BizID] != 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You already own a biz.");

    if(PlayerInfo[playerid][Money] < BusinessInfo[id][bPrice]) return SendClientMessage(playerid, COLOR_LIGHTRED, "Sorry, you can not afford this biz.");

    PlayerInfo[playerid][BizID] = id;
    PlayerInfo[playerid][Money] -= BusinessInfo[id][bPrice];
    GivePlayerMoney(playerid, -BusinessInfo[id][bPrice]);

    BusinessInfo[id][bLocked] = 0;
    BusinessInfo[id][bOwned] = 1;
    BusinessInfo[id][bOwner] = RemoveUnderScore(playerid);

    SendClientMessage(playerid, COLOR_YELLOW, "Congratulations on your new biz! Use /bizhelp to get help, or /ask!");
    return 1;
}
CMD:sellbiz(playerid, params[])
{
    new id = PlayerInfo[playerid][BizID];
    if(PlayerInfo[playerid][BizID] == 0) return SCM(playerid, COLOR_GREY, "You don't own a biz!");
    BusinessInfo[id][bOwned] = 0;
    BusinessInfo[id][bOwner] = 0;
    BusinessInfo[id][bLocked] = 1;
    PlayerInfo[playerid][Money] = BusinessInfo[id][bPrice];
    PlayerInfo[playerid][BizID] = 0;
    SCM(playerid, COLOR_YELLOW, "Business sold!");
    return 1;
}
CMD:bizsetname(playerid, params[])
{
    new name[128];
    if(sscanf(params, "s[128]", name)) return SCM(playerid, COLOR_GREY, "/bizsetname [name]");
    if(PlayerInfo[playerid][BizID] == 0) return SCM(playerid, COLOR_GREY, "You don't own a biz!");
    BusinessInfo[PlayerInfo[playerid][BizID]][bName] = name;
    SCM(playerid, COLOR_YELLOW, "Business name changed!");
    return 1;
}
CMD:clothes(playerid, params[])
{
    new skin;
    if(sscanf(params, "i", skin)) return SCM(playerid, COLOR_GREY, "CMD:/skin [skinid]");
    if(PlayerInfo[playerid][Money] < 100) return SCM(playerid, COLOR_GREY, "You need atleast 100%!");
    if(BusinessInfo[InsideBiz[playerid]][bType] != 1) return SCM(playerid, COLOR_GREY, "You need to be in clothes shop!");
    if(1 > skin ||  299 < skin || skin == 288 || skin == 287 || skin == 286 || skin == 285 || skin == 284 || skin == 283 || skin == 282 || skin == 281 || skin == 280 || skin == 279 || skin == 278 || skin == 277 || skin == 276 || skin == 275 || skin == 274) return SCM(playerid, COLOR_GREY, "Invalid skin ID!");
    SetPlayerSkin(playerid, skin);
    PlayerInfo[playerid][Skin] = skin;
    GivePlayerMoney(playerid, -100);
    BusinessInfo[InsideBiz[playerid]][bMoney] += 100;
    return 1;
}
/*==============================================================================
--------------------------------RemoveUnderScore--------------------------------
==============================================================================*/
stock RemoveUnderScore(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid,name,sizeof(name));
    for(new i = 0; i < MAX_PLAYER_NAME; i++)
    {
        if(name[i] == '_') name[i] = ' ';
    }
    return name;
}
