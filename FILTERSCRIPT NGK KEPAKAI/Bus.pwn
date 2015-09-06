/*
				jBizz - Fast, Dynamic & Simple business system
								 Created by Joe_
       This is a public release, you may edit to your liking for private use-
        Redistributing this file without my permission is strictly forbidden.
*/


#include <a_samp>
#include <streamer>
#include <sscanf2>
#include <zcmd>

// |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
/*
	Config jBizz to your preferences !

	Remember, you have to create the file path 'BUSINESS_FILE_PATH' or the businesses WILL NOT BE CREATED!!
	If you need help or are unsure on how to make the folder and file, or how to know where to put it, or in that case-
	are unsure / don't know what to do with any of the settings below,  please don't hesitage to ask on-
	The jBizz thread, I or somebody else will help you ! :)
*/


#define BUSINESS_FILE_PATH              "/jBizz/Businesses.cfg" // File path, edit if you know how the FOLDER defining format works
#define MAX_BUSINESS_NAME               (30) // Max Business name lenght
#define MAX_BUSINESSES                  (30) // Max Businesses
#define MAX_PER_PLAYER_BUSINESSES       (2) // Max businesses per player
#define BIZZ_SELL_DEVIDE                (2) // Business price devided by THIS value is the sell price, default is 2 (Price / 2)
#define BIZZ_EARN_DEVIDE                (5) // Business price devided by THIS value is the earnings earnt per BUSINESS_PAYMENT_INTERVAL, default is 5 (Price / 5)
#define BIZZ_PAYMENT_INTERVAL           (5) // Time between every payment in >> MINUTES <<
#define BIZZ_MESSAGE_COLOR              (0x409FFFFF) // Color of Client messages send by jBizz
#define BIZZ_DIALOG_ID                  (1337) // Dialogid shown when picking up a business pickup, change if experiencing problems with other dialogs etc
#define BIZZ_AVAIL_MAPICON              (31) // Mapicon used for a BUYABLE business
#define BIZZ_UNAVAIL_MAPICON            (32) // Mapicon used for a UNBUYABLE business
#define BIZZ_MAPICON_DRAWDISTANCE       (100.0) // Mapicon drawdistance
#define BIZZ_AVAIL_PICKUP_MODEL         (1273) // Pickup model used for a BUYABLE business
#define BIZZ_UNAVAIL_PICKUP_MODEL       (1272) // Pickup model used for a UNBUYABLE business
#define BIZZ_PICKUP_DRAWDISTANCE        (100.0) // Pickup drawdistance
#define BIZZ_3DTAG_COLOR                (0x80FFFFFF) // 3DTag color
#define BIZZ_3DTAG_DRAWDISTANCE         (100.0) // 3DTag Drawdistance

// |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

enum E_BUSINESS_DATA
{
	Name[MAX_BUSINESS_NAME], Price,
	Float:x, Float:y, Float:z, interior, world,
	Owner, mapid, Pickupid, Text3D:labelid
}

enum E_PLAYER_DATA
{
	Businesses, Earnings, idx
}

new bData[MAX_BUSINESSES][E_BUSINESS_DATA], pData[MAX_PLAYERS][E_PLAYER_DATA];
new str[128], Count = 0, Timer;


#define DestroyBizzElements(%0) \
	DestroyDynamicMapIcon(bData[%0][mapid]); \
	DestroyDynamicPickup(bData[%0][Pickupid]); \
	DestroyDynamic3DTextLabel(bData[%0][labelid]);

stock CreateAvailableBizzElements(BizzID)
{
    DestroyBizzElements(BizzID)
    bData[BizzID][mapid] = CreateDynamicMapIcon(bData[BizzID][x], bData[BizzID][y], bData[BizzID][z], BIZZ_AVAIL_MAPICON, 0, bData[BizzID][world], bData[BizzID][interior], -1, BIZZ_MAPICON_DRAWDISTANCE);
   	bData[BizzID][Pickupid] = CreateDynamicPickup(BIZZ_AVAIL_PICKUP_MODEL, 23, bData[BizzID][x], bData[BizzID][y], bData[BizzID][z], bData[BizzID][world], bData[BizzID][interior], -1, BIZZ_PICKUP_DRAWDISTANCE);
   	format(str, sizeof(str), "[%s]\nPrice: $%d", bData[BizzID][Name], bData[BizzID][Price]);
   	bData[BizzID][labelid] = CreateDynamic3DTextLabel(str, BIZZ_3DTAG_COLOR, bData[BizzID][x], bData[BizzID][y], bData[BizzID][z], BIZZ_3DTAG_DRAWDISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, bData[BizzID][world], bData[BizzID][interior], -1, BIZZ_3DTAG_DRAWDISTANCE);
}

stock CreateUnvailableBizzElements(BizzID)
{
    DestroyBizzElements(BizzID)
    bData[BizzID][mapid] = CreateDynamicMapIcon(bData[BizzID][x], bData[BizzID][y], bData[BizzID][z], BIZZ_UNAVAIL_MAPICON, 0, bData[BizzID][world], bData[BizzID][interior], -1, BIZZ_MAPICON_DRAWDISTANCE);
	bData[BizzID][Pickupid] = CreateDynamicPickup(BIZZ_UNAVAIL_PICKUP_MODEL, 23, bData[BizzID][x], bData[BizzID][y], bData[BizzID][z], bData[BizzID][world], bData[BizzID][interior], -1, BIZZ_PICKUP_DRAWDISTANCE);
	format(str, sizeof(str), "[%s]\nOwner: %s", bData[BizzID][Name], pName(bData[BizzID][Owner]));
	bData[BizzID][labelid] = CreateDynamic3DTextLabel(str, BIZZ_3DTAG_COLOR, bData[BizzID][x], bData[BizzID][y], bData[BizzID][z], BIZZ_3DTAG_DRAWDISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, bData[BizzID][world], bData[BizzID][interior], -1, BIZZ_3DTAG_DRAWDISTANCE);
}

stock pName(playerid)
{
	new PlayerName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
	return PlayerName;
}

public OnFilterScriptInit()
{
	new
	    output[500], File: Handle = fopen(BUSINESS_FILE_PATH, io_read);

	while(fread(Handle, output))
	{
	    if(!sscanf(output, "e<p<,>s[30]dfffdd>", bData[Count]))
	    {
			CreateAvailableBizzElements(Count);
			bData[Count][Owner] = INVALID_PLAYER_ID;
			Count++;
		}
	}
	fclose(Handle);
	printf(" ** jBizz loaded %d businesses ! **", Count);

	Timer = SetTimer("Payments", BIZZ_PAYMENT_INTERVAL*60000, true);
	return 1;
}

public OnFilterScriptExit()
{
	for(new a = 0; a < Count; a++)
	{
		DestroyBizzElements(a)
	}

	KillTimer(Timer);
	return 1;
}

public OnPlayerConnect(playerid)
{
	pData[playerid][Businesses] = 0;
	pData[playerid][Earnings] = 0;
	return 1;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	for(new a = 0; a < Count; a++)
	{
	    if(pickupid == bData[a][Pickupid])
	    {
         	switch(bData[a][Owner])
     		{
				case INVALID_PLAYER_ID: format(str, sizeof(str), "Name: %s\nPrice: $%d\nSell Price: $%d, Earnings: $%d", bData[a][Name], bData[a][Price], bData[a][Price] / BIZZ_SELL_DEVIDE, bData[a][Price] / BIZZ_EARN_DEVIDE);
				default: format(str, sizeof(str), "Name: %s\nOwner:%s", bData[a][Name], pName(bData[a][Owner]));
			}

			pData[playerid][idx] = a;
			ShowPlayerDialog(playerid, 1337, DIALOG_STYLE_MSGBOX, "jBizz", str, "Buy", "Sell");
			return 1;
		}
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == 1337)
	{
	    new Idx = pData[playerid][idx];

		if(response)
		{
			if(bData[Idx][Owner] == INVALID_PLAYER_ID)
			{
			    if(GetPlayerMoney(playerid) >= bData[Idx][Price])
			    {
			        if(pData[playerid][Businesses] < MAX_PER_PLAYER_BUSINESSES)
			        {
				        bData[Idx][Owner] = playerid;
				        pData[playerid][Businesses]++;
				        pData[playerid][Earnings] += bData[Idx][Price] / BIZZ_EARN_DEVIDE;
				        GivePlayerMoney(playerid, -bData[Idx][Price]);

						CreateUnvailableBizzElements(Idx);

						format(str, sizeof(str), " > You have sucessfully brought the business \"%s\" for $%d, you will earn $%d every %d minutes.", bData[Idx][Name], bData[Idx][Price], pData[playerid][Earnings], BIZZ_PAYMENT_INTERVAL);
						return SendClientMessage(playerid, BIZZ_MESSAGE_COLOR, str);
					}
					format(str, sizeof(str), " > You can only own up to %d businesses !", MAX_PER_PLAYER_BUSINESSES);
					return SendClientMessage(playerid, BIZZ_MESSAGE_COLOR, str);
				}
				format(str, sizeof(str), " > This business costs $%d and you only have $%d !", bData[Idx][Price], GetPlayerMoney(playerid));
				return SendClientMessage(playerid, BIZZ_MESSAGE_COLOR, str);
			}
            format(str, sizeof(str), " > This business is already owned by %s !", pName(bData[Idx][Owner]));
			return SendClientMessage(playerid, BIZZ_MESSAGE_COLOR, str);
		}
		if(bData[Idx][Owner] == playerid)
		{
		    bData[Idx][Owner] = INVALID_PLAYER_ID;
      		pData[playerid][Businesses]--;
       		pData[playerid][Earnings] -= bData[Idx][Price] / BIZZ_EARN_DEVIDE;
       		GivePlayerMoney(playerid, bData[Idx][Price] / BIZZ_SELL_DEVIDE);

			CreateAvailableBizzElements(Idx);

			format(str, sizeof(str), " > You have sold the business \"%s\" for $%d.", bData[Idx][Name], bData[Idx][Price] / BIZZ_SELL_DEVIDE);
			return SendClientMessage(playerid, BIZZ_MESSAGE_COLOR, str);
		}
		return 1;
	}
	return 1;
}

forward Payments();
public Payments()
{
	for(new a = 0, b = GetMaxPlayers(); a < b; a++)
	{
	    if(pData[a][Earnings])
	    {
	        GivePlayerMoney(a, pData[a][Earnings]);
	        format(str, sizeof(str), " > You have earned $%d from your %d businesses !", pData[a][Earnings], pData[a][Businesses]);
         	SendClientMessage(a, BIZZ_MESSAGE_COLOR, str);
		}
	}
	return 1;
}
