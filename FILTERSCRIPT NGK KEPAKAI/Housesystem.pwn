/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickoals Whatcha Core Shaffer 2010

        Requirements:
        -Incognito's streamer plugin
        -zcmd command processor (zcmd.inc)
        -sscanf 2.0 plugin
        -MySQL plugin R5 or higher
*/

#include <a_samp>
#include <streamer>
#include <a_mysql>
#include <sscanf2>
#include <zcmd>

//Change this to whatever you like, but keep it as close to actual house number as possible for best efficiency:
#define MAX_HOUSES                      500

//Mysql credentials:
#define MYSQL_IP                        "127.0.0.1"
#define MYSQL_USER                      "root"
#define MYSQL_PASSWORD                  ""
#define MYSQL_DB                        "house"
#define MYSQL_TABLE_NAME                "house"

//Exchanging player data with main script (change this if you use custom money/adminship script):

#define IS_ADMIN(%1)                    IsPlayerAdmin(%1)
#define GET_MONEY(%1)                   GetPlayerMoney(%1)
#define ADD_MONEY(%1,%2)                GivePlayerMoney(%1,(%2))

/*  Example:

        #define IS_ADMIN(%1)                    GetPVarInt(%1, "admin")
        #define GET_MONEY(%1)                   GetPVarInt(%1, "money")
        #define ADD_MONEY(%1,%2)                SetPVarInt(%1, "money", GET_MONEY(%1)+(%2))
*/

//Script settings:
#define DEFAULT_HOUSE_PRICE             500000
#define DEFAULT_HOUSE_INTERIOR          0
#define HOUSE_SELL_PAYBACK              0.75
#define EXIT_PICKUP_MODEL                               1272
#define HOUSE_PICKUP_MODEL              1273

#define MAX_INTERIORS                   15 //must equal number of house interiors
#define HOUSE_RANGE                     1.0
#define INVALID_HOUSE_ID                0
#define HOUSE_WORLD_OFFSET              0
#define HOUSE_LABEL_SIZE                        64
#define HOUSE_ENTER_LEAVE_KEY                   KEY_SECONDARY_ATTACK //key used for entering house and leaving

#define HOUSE_LABEL_COLOR                               0x008000FF
#define COLOR_RED                                               0xAA3333AA
#define COLOR_WHITE                                     0xFFFFFFFF
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
//macros
#define ADMIN                           if (!IS_ADMIN(playerid)) return 0
#define ERROR(%1)                       SendClientMessage(playerid, COLOR_RED, %1)
#define MESSAGE(%1)                     SendClientMessage(playerid, COLOR_WHITE, %1)
#define MSG                             msg, sizeof(msg)
#define QUERY(%1)                                               mysql_query(%1, -1, -1, mysql_connection)
#define GET_INT(%1,%2)                                  mysql_fetch_field_row(tmp, %2);%1 = strval(tmp)
#define GET_STR(%1,%2)                                  mysql_fetch_field_row(%1, %2)
#define GET_FLOAT(%1,%2)                                mysql_fetch_field_row(tmp, %2);%1 = floatstr(tmp)
#define NEW_KEY(%1)                                     ((newkeys & %1) && !(oldkeys & %1))

#define ADD_INTERIOR(%1,%2,%3,%4,%5,%6)                         \
                Interiors[%1][int_x] = %2;                          \
                Interiors[%1][int_y] = %3;                          \
                Interiors[%1][int_z] = %4;                          \
                Interiors[%1][int_r] = %5;                          \
                Interiors[%1][int_interior] = %6;                   \
                Interiors[%1][int_pickup]=CreateDynamicPickup(EXIT_PICKUP_MODEL,23,%2,%3,%4,-1,%6,-1)

#define SPAWN_HOUSE(%1)             \
                Houses[%1][house_pickup] = CreateDynamicPickup(HOUSE_PICKUP_MODEL, 23,                          \
                                                                        Houses[%1][house_x], Houses[%1][house_y],                       \
                                                                        Houses[%1][house_z], 0, 0, -1);                                         \
                Houses[%1][house_label] = CreateDynamic3DTextLabel("", HOUSE_LABEL_COLOR,                       \
                                                                        Houses[%1][house_x], Houses[%1][house_y],                       \
                                                                        Houses[%1][house_z]+0.75, 20,                                   \
                                                                        INVALID_PLAYER_ID, INVALID_VEHICLE_ID, true, 0, 0, -1);     \
            UpdateHouseLabel(id)

#define CREATE_TABLE_QUERY  \
        "CREATE TABLE IF NOT EXISTS `"#MYSQL_TABLE_NAME"`(`id` int(11) NOT NULL,        \
        `x` float NOT NULL,`y` float NOT NULL,`z` float NOT NULL,                       \
        `r` float NOT NULL,`interior` smallint(6) NOT NULL,                                     \
        `price` int(11) NOT NULL,                                                                                       \
        `Slots` int(11) NOT NULL,                                                                                       \
        `owner` char(25) COLLATE latin1_general_cs NOT NULL,                            \
        UNIQUE KEY `id` (`id`))                                             \
        ENGINE=MyISAM DEFAULT CHARSET=latin1                                                            \
        COLLATE=latin1_general_cs AUTO_INCREMENT=1"
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
//Public functions - these can be used from outside the script, eg in Gamemode:
forward GetPlayerHouseID(playerid);                             //return ID of the house that player is currently inside
forward IsHouseOwnedByPlayer(playerid, houseid);
forward PutPlayerInHouse(playerid, id);
forward RemovePlayerFromHouse(playerid);
forward GiveHouseToPlayer(playerid, houseid);
forward TakeHouseFromPlayer(houseid);
forward GetPlayerHouseEntrance(playerid);           //Returns ID of the house if player is in house pickup or 0 if not.
forward CreateHouse(Float:x, Float:y, Float:z, Float:r, price, interior, Slots2);
forward GetHousePos(houseid, &Float:x, &Float:y, &Float:z); //Returns XYZ coordinates of house entrance
forward GetHouseFacingAngle(houseid, &Float:angle);
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
enum HouseData
{
        Float:house_x,
        Float:house_y,
        Float:house_z,
        Float:house_r,
        house_price,
        house_interior,
        house_owner[MAX_PLAYER_NAME],
        house_pickup,
        Text3D:house_label,
        Slots
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
enum PlayerData
{
        last_house_entrance,
        in_house
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
enum InteriorData
{
   int_interior,
        Float:int_x,
        Float:int_y,
        Float:int_z,
        Float:int_r,
        int_pickup
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
new
        mysql_connection,
        Float:Houses[MAX_HOUSES][HouseData],
        Float:Players[MAX_PLAYERS][PlayerData],
        Float:Interiors[MAX_INTERIORS][InteriorData];
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
//===================================================================
//:::::::::::::::::::::: Callbacks ::::::::::::::::::::::::::::::::::
//===================================================================
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
        new id;
   if (NEW_KEY(HOUSE_ENTER_LEAVE_KEY))
        {
                if ((id = GetPlayerHouseEntrance(playerid)))
                {
                    if (!IsHouseOwnedByPlayer(playerid, id)) return GameTextForPlayer(playerid, "~r~You don't own this house", 3000, 3);
                        PutPlayerInHouse(playerid, id);
                }
                else if ((id = Players[playerid][in_house]))
                {
                    new i = Houses[id][house_interior];
                        if (IsPlayerInRangeOfPoint(playerid, HOUSE_RANGE, Interiors[i][int_x], Interiors[i][int_y], Interiors[i][int_z])) RemovePlayerFromHouse(playerid);
                }
        }
        return 1;
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
public OnFilterScriptInit()
{
   DisableInteriorEnterExits();
        ADD_INTERIOR(0, 2259.8435,      -1136.2699,     1050.6328,      254.2604,       10);
        ADD_INTERIOR(1, 2233.4900,      -1114.4435,     1050.8828,      357.3481,       5);
        ADD_INTERIOR(2, 2196.3943,      -1204.1359,     1049.0234,      78.2122,        6);
        ADD_INTERIOR(3, 2318.1616,      -1026.3762,     1050.2109,      358.3114,       9);
        ADD_INTERIOR(4, 421.8333,       2536.9814,      10,             92.9158,        10);
        ADD_INTERIOR(5, 234.6087,       1187.8195,      1080.2578,      349.4844,       3); //wrong interior ID!!
        ADD_INTERIOR(6, 225.5707,       1240.0643,      1082.1406,      96.2852,        2);
        ADD_INTERIOR(7, 223.2357,       1287.0824,      1082.1406,      359.868,        1);
        ADD_INTERIOR(8, 226.7545,       1114.4180,      1080.9952,      267.4440,       5);
        ADD_INTERIOR(8, 2269.9636,      -1210.3275,     1047.5625,      89.8057,        10);
        ADD_INTERIOR(9, 2496.2087,      -1692.3149,     1014.7422,      181.4683,       3);
        ADD_INTERIOR(10, 1299.1381,     -796.1603,      1084.0078,      0,              5);
        ADD_INTERIOR(11, 318.8655,      1115.1758,      1083.8828,      2.0485,         5);
        ADD_INTERIOR(12, 2324.3159,     -1148.7551,     1050.7101,      2.1677,         12);
        ADD_INTERIOR(13, 2365.0630,     -1135.2068,     1050.8750,      357.6382,       8);
        ADD_INTERIOR(14, 2283.0852,     -1139.4916,     1050.8984,      359.7849,       11);

        //mysql_debug(1); //uncommend for debugging

        mysql_connection = mysql_connect(MYSQL_IP, MYSQL_USER, MYSQL_DB, MYSQL_PASSWORD);

        QUERY(CREATE_TABLE_QUERY); //This line creates table in the database. Once ran, can be commented out - required only in the first run

        //Loading houses from database
        QUERY("SELECT * FROM `"#MYSQL_TABLE_NAME"` WHERE `id` < "#MAX_HOUSES);
        mysql_store_result(mysql_connection);
        new n;
        while (mysql_retrieve_row())
        {
            new tmp[32];
            new id;
                GET_INT(id, "id");//Loads houseid
                GET_INT(Houses[id][house_price], "price");
                GET_INT(Houses[id][house_interior], "interior");
                GET_INT(Houses[id][Slots], "Slots");
                GET_STR(Houses[id][house_owner], "owner");

                new Float:x, Float:y, Float:z, Float:r;
                GET_FLOAT(x, "x");
                GET_FLOAT(y, "y");
                GET_FLOAT(z, "z");
                GET_FLOAT(r, "r");
                Houses[id][house_x] = x;
                Houses[id][house_y] = y;
                Houses[id][house_z] = z;
                Houses[id][house_r] = r;

                SPAWN_HOUSE(id);
            n++;
        }
        mysql_free_result(mysql_connection);
        printf("%d houses loaded from %s/%s/%s, username %s", n, MYSQL_IP, MYSQL_DB, MYSQL_TABLE_NAME, MYSQL_USER);
        print("House system loaded");
        return 1;
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
public OnFilterScriptExit()
{
   mysql_close(mysql_connection);
        print("\nHouse system unloaded\n");
        return 1;
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
        for (new i=1; i < MAX_HOUSES; i++) if (pickupid == Houses[i][house_pickup])
        {
            Players[playerid][last_house_entrance] = i;
            if (IsHouseOwnedByPlayer(playerid, i)) GameTextForPlayer(playerid, "~y~Press ~r~~k~~VEHICLE_ENTER_EXIT~ ~y~to enter your house", 3000, 3);
            break;
        }
        return 1;
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
public OnPlayerConnect(playerid)
{
        Players[playerid][in_house] =                           INVALID_HOUSE_ID;
        Players[playerid][last_house_entrance] =        INVALID_HOUSE_ID;
        return 0;
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
public OnPlayerCommandText(playerid, cmdtext[])
{
        return 0;
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
//===================================================================
//:::::::::::::::::::::: Script functions :::::::::::::::::::::::::::
//===================================================================
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
public GetHousePos(houseid, &Float:x, &Float:y, &Float:z)
{
        if (houseid == INVALID_HOUSE_ID || houseid >= MAX_HOUSES || !Houses[houseid][house_price]) return false;
        x = Houses[houseid][house_x];
        y = Houses[houseid][house_y];
        z = Houses[houseid][house_z];
        return true;
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
public GetHouseFacingAngle(houseid, &Float:angle)
{
        if (houseid == INVALID_HOUSE_ID || houseid >= MAX_HOUSES || !Houses[houseid][house_price]) return false;
        angle = Houses[houseid][house_r];
        return true;
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
stock UpdateHouseLabel(houseid)
{
        if (houseid == INVALID_HOUSE_ID) return false;
        new label[HOUSE_LABEL_SIZE];
        if (isnull(Houses[houseid][house_owner])) format(label, HOUSE_LABEL_SIZE, "For sale\nPrice: %s\nSlots:%i", FormatMoney(Houses[houseid][house_price]), Houses[houseid][Slots]);
        else format(label, HOUSE_LABEL_SIZE, "House owned by:\n%s", Houses[houseid][house_owner]);
        return UpdateDynamic3DTextLabelText(Houses[houseid][house_label], HOUSE_LABEL_COLOR, label);
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
public IsHouseOwnedByPlayer(playerid, houseid)
{
        if (houseid == INVALID_HOUSE_ID) return false;
        return (!isnull(Houses[houseid][house_owner]) && !strcmp(Houses[houseid][house_owner], PlayerName(playerid), false, MAX_PLAYER_NAME));
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
public PutPlayerInHouse(playerid, id)
{
        if (id == INVALID_HOUSE_ID) return 0;
        new interior = Houses[id][house_interior];
        SetPlayerInterior(playerid, Interiors[interior][int_interior]);
        SetPlayerVirtualWorld(playerid, HOUSE_WORLD_OFFSET+id);
        SetPlayerPos(playerid, Interiors[interior][int_x],Interiors[interior][int_y],Interiors[interior][int_z]);
        SetPlayerFacingAngle(playerid, Interiors[interior][int_r]);
        SetCameraBehindPlayer(playerid);
        Players[playerid][in_house] = id;
        Streamer_Update(playerid);
        return 1;
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
public RemovePlayerFromHouse(playerid)
{
        new id = Players[playerid][in_house];
        if (id == INVALID_HOUSE_ID) return 0;
        Streamer_UpdateEx(playerid, Houses[id][house_x], Houses[id][house_y], Houses[id][house_z]);
        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 0);
        SetPlayerPos(playerid, Houses[id][house_x], Houses[id][house_y], Houses[id][house_z]);
        SetPlayerFacingAngle(playerid, Houses[id][house_r]);
        SetCameraBehindPlayer(playerid);
        Players[playerid][in_house] = 0;
        return 1;
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
public GiveHouseToPlayer(playerid, houseid)
{
        if (houseid == INVALID_HOUSE_ID || !isnull(Houses[houseid][house_owner])) return 0;
        GetPlayerName(playerid, Houses[houseid][house_owner], MAX_PLAYER_NAME);
        printf("House %d is given to %s", houseid, Houses[houseid][house_owner]);
        SaveHouse(houseid);
        UpdateHouseLabel(houseid);
        return 1;
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
public TakeHouseFromPlayer(houseid)
{
        if (houseid == INVALID_HOUSE_ID || isnull(Houses[houseid][house_owner])) return 0;
        printf("Evicting %s from house %d", Houses[houseid][house_owner], houseid);
        Houses[houseid][house_owner] = 0;
        SaveHouse(houseid);
        UpdateHouseLabel(houseid);
        return 1;
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
stock GetNewHouseID()
{
        for (new i=1; i < MAX_HOUSES; i++) if (!Houses[i][house_price]) return i;
        return INVALID_HOUSE_ID;
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
stock SaveHouse(houseid)
{
        new q[200];
        format(q, 200, "UPDATE `"#MYSQL_TABLE_NAME"` SET `price`=%d,`owner`='%s',`x`='%f',`y`='%f',`z`='%f',`r`='%f',`interior`=%d,`Slots`=%i WHERE `id`=%d LIMIT 1",
                Houses[houseid][house_price], Houses[houseid][house_owner], Houses[houseid][house_x], Houses[houseid][house_y],
                Houses[houseid][house_z], Houses[houseid][house_r], Houses[houseid][house_interior], Houses[houseid][Slots], houseid);
        QUERY(q);
        return 1;
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
public GetPlayerHouseEntrance(playerid)
{
        new id = Players[playerid][last_house_entrance];
        if (id == INVALID_HOUSE_ID || IsPlayerInRangeOfPoint(playerid, HOUSE_RANGE, Houses[id][house_x], Houses[id][house_y], Houses[id][house_z])) return id;
        return INVALID_HOUSE_ID;
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
public GetPlayerHouseID(playerid)
{
        return Players[playerid][in_house];
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
public CreateHouse(Float:x, Float:y, Float:z, Float:r, price, interior, Slots2)
{
        new id = GetNewHouseID();
        if (id == INVALID_HOUSE_ID || price <= 0 || interior >= MAX_INTERIORS || interior < 0) return INVALID_HOUSE_ID;
        Houses[id][house_x] = x;
        Houses[id][house_y] = y;
        Houses[id][house_z] = z;
        Houses[id][house_r] = r;
        Houses[id][house_price] = price;
        Houses[id][house_interior] = interior;
        Houses[id][house_owner] = 0;
        Houses[id][Slots] = Slots2;
        new q[128];
        format(q, 200, "INSERT INTO `"#MYSQL_TABLE_NAME"` (`id`) VALUES (%d)", id);
        QUERY(q);
        SPAWN_HOUSE(id);
        SaveHouse(id);
        printf("House %d is created. Price %s, interior %d", id, FormatMoney(price), interior);
        return id;
}

//===================================================================
//:::::::::::::::::::::: Script commands ::::::::::::::::::::::::::::
//===================================================================
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
// ======= Player commands ========
CMD:buyhouse(playerid, params[])
{
        new price,
        id = GetPlayerHouseEntrance(playerid);
        if (id == INVALID_HOUSE_ID) return ERROR("You must stand in house entrance!");
        price = Houses[id][house_price];
        if (GET_MONEY(playerid) >= price && GiveHouseToPlayer(playerid, id))
        {
            ADD_MONEY(playerid, -price);
            new msg[128];
            format(MSG, "You bought house for %s", FormatMoney(price));
            MESSAGE(msg);
        }
        else ERROR("You cannot buy this house!");
        return 1;
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
CMD:sellhouse(playerid, params[])
{
   new price,
        id = GetPlayerHouseEntrance(playerid);
        if (!IsHouseOwnedByPlayer(playerid, id)) return ERROR("You must stand in the entrance of your house");
        price = floatround(Houses[id][house_price] * HOUSE_SELL_PAYBACK);
        if (TakeHouseFromPlayer(id))
        {
            ADD_MONEY(playerid, price);
            new msg[128];
            format(MSG, "You sold house for %s", FormatMoney(price));
            MESSAGE(msg);
        }
        else ERROR("You cannot sell this house!");
        return 1;
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
CMD:enter(playerid, params[])
{
        new id = GetPlayerHouseEntrance(playerid);
        if (id == INVALID_HOUSE_ID) return ERROR("You must be in house entrance to use this command");
        if (IsHouseOwnedByPlayer(playerid, id) || IS_ADMIN(playerid)) PutPlayerInHouse(playerid, id);
        else ERROR("You don't own this house");
        return 1;
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
CMD:exit(playerid, params[])
{
        if (!RemovePlayerFromHouse(playerid)) return ERROR("You must be inside house to use this command");
        return 1;
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
CMD:housecmds(playerid, params[])
{
        MESSAGE("House commands: /BuyHouse /SellHouse /enter /exit");
        if (IS_ADMIN(playerid))
        {
            MESSAGE("Admin house commands: /AddHouse /SetPrice /SetInterior /GiveHouse /Evict /TeleHouse");
        }
        return 1;
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
// ======= Admin commands ========
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
CMD:addhouse(playerid, params[])
{
        ADMIN;
        new Float:x, Float:y, Float:z, Float:r, price, interior, id, msg[128], Slots2;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, r);
        if (sscanf(params, "iI("#DEFAULT_HOUSE_INTERIOR")i", price, interior, Slots2)) return ERROR("Usage: /AddHouse [price] (interior="#DEFAULT_HOUSE_INTERIOR") [Slots]");
        if (price <= 0) return ERROR("Price given is not correct!");
        if ((id = CreateHouse(x, y, z, r, price, interior, Slots2)) == INVALID_HOUSE_ID) ERROR("House could not be created! House limit "#MAX_HOUSES" may have been reached");
        format(MSG, "House %d has been created with price %s and interior %d", id, FormatMoney(Houses[id][house_price]), Houses[id][house_interior]);
    //  Houses[id][Slots] = Slots2;
        MESSAGE(msg);
        Streamer_Update(playerid);
        return 1;
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
CMD:telehouse(playerid, params[])
{
        ADMIN;
        new Float:x, Float:y, Float:z, id;
        if (sscanf(params, "i", id)) return ERROR("Usage: /TeleHouse [houseid]");
        if (!GetHousePos(id, x, y, z)) return ERROR("Invalid house id!");
        Streamer_UpdateEx(playerid, x, y ,z);
        SetPlayerVirtualWorld(playerid, 0);
        SetPlayerInterior(playerid, 0);
        SetPlayerPos(playerid, x, y, z);
        return 1;
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
CMD:setprice(playerid, params[])
{
        ADMIN;
        new price;
        if (sscanf(params,  "i", price)) return ERROR("Usage: /SetPrice [price]");
        if (price <= 0) return ERROR("Price is too low!");
        new id = GetPlayerHouseEntrance(playerid);
        if (id == INVALID_HOUSE_ID) return ERROR("You must stand in house entrance!");
        Houses[id][house_price] = price;
        SaveHouse(id);
        UpdateHouseLabel(id);
        new msg[128];
        format(MSG, "House %d price set to %s", id, FormatMoney(price));
        MESSAGE(msg);
        return 1;
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
CMD:setinterior(playerid, params[])
{
        ADMIN;
        new interior;
        if (sscanf(params,  "i", interior)) return ERROR("Usage: /SetInterior [interior]");
        if (interior < 0 || interior >= MAX_INTERIORS) return ERROR("Wrong interior id! Interior must be lower than "#MAX_INTERIORS);
        new id = GetPlayerHouseEntrance(playerid);
        if (id == INVALID_HOUSE_ID) return ERROR("You must stand in house entrance!");
        Houses[id][house_interior] = interior;
        SaveHouse(id);
        new msg[128];
        format(MSG, "House %d interior set to %d", id, interior);
        MESSAGE(msg);
        return 1;
}

/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
CMD:evict(playerid, params[])
{
        ADMIN;
        if (!TakeHouseFromPlayer(GetPlayerHouseEntrance(playerid))) return ERROR("Error: make sure you are standing in the entrance of owned house!");
        else MESSAGE("Player is evicted from house");
        Streamer_Update(playerid);
        return 1;
}
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
CMD:givehouse(playerid, params[])
{
        ADMIN;
        new pid;
        if (sscanf(params, "u", pid)) return ERROR("Usage: /GiveHouse [player]");
        if (pid == INVALID_PLAYER_ID) return ERROR("Invalid Player ID");
        if (!GiveHouseToPlayer(pid, GetPlayerHouseEntrance(playerid))) return ERROR("Error: make sure you are standing in the entrance of unowned house!");
        else
        {
            new msg[128];
            format(MSG, "House given to %s", PlayerName(pid));
            MESSAGE(msg);
        }
        Streamer_Update(playerid);
        return 1;
}
//===================================================================
//:::::::::::::::::::::: Stock functions ::::::::::::::::::::::::::::
//===================================================================
/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
stock PlayerName(playerid)
{
        new name[MAX_PLAYER_NAME];
        GetPlayerName(playerid, name, MAX_PLAYER_NAME);
        return name;
}

stock FormatMoney(Float:amount, delimiter[2]=",")
{
        #define MAX_MONEY_STRING 16
        new txt[MAX_MONEY_STRING];
        format(txt, MAX_MONEY_STRING, "$%d", floatround(amount));
        new l = strlen(txt);
        if (amount < 0) // -
        {
            if (l > 5) strins(txt, delimiter, l-3);
                if (l > 8) strins(txt, delimiter, l-6);
                if (l > 11) strins(txt, delimiter, l-9);
        }
        else
        {
                if (l > 4) strins(txt, delimiter, l-3);
                if (l > 7) strins(txt, delimiter, l-6);
                if (l > 10) strins(txt, delimiter, l-9);
        }
        return txt;
}

/*
        House system by mick88 and Whatcha
        Michael Dabski 2010
        Nickolas Whatcha Core Shaffer 2010
*/
