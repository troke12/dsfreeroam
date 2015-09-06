/*
 -------------------------------------------
|		  _____ _        __                 |
|		 / ____| |      / _|                |
|		| (___ | |_ ___| |_ __ _ _ __       |
|		 \___ \| __/ _ \  _/ _` | '_ \      |
|		 ____) | ||  __/ || (_| | | | |     |
|		|_____/ \__\___|_| \__,_|_| |_|     |
|                                           |
|        **   House System v1.0   **        |
|                                           |
 -------------------------------------------
      .:: Do not remove Credits ::.
*/

#include <a_samp>
#include <Dini>
#include <dudb>
#include <utils>

new FALSE = false;
#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
#define SendFormattedMessage(%0,%1,%2) do{new _str[128]; format(_str,128,%2); SendClientMessage(%0,%1,_str);}while(FALSE)

#define COLOR_WHITE 			0xFFFFFFAA
#define COLOR_LIME		 		0x80FF00AA

#define MAX_HOUSES              100     // Max houses allowed to be created
#define PTP_RADIUS              2.0     // Radius of PlayerToPoint Function

forward SavePlayerHouse(houseid);
forward ReadPlayerHouseData(playerid);
forward PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z);

new Timer[1];

enum hInfo
{
	hName[24],
	hSellable,
	hSell,
	hRent,
	hLevel,
	hPickup,
	Float:hExitX,
	Float:hExitY,
	Float:hExitZ,
	hVirtualWorld,
	hLocked
};
new HouseInfo[MAX_HOUSES][hInfo];

new Float:HousesCoords[13][3] = {
{222.9534, 1287.7649, 1082.1406},   // Sml - 1 bedroom
{261.0827, 1284.6899, 1080.2578},   // Sml - 1 bedroom
{260.6734, 1237.7909, 1084.2578},   // Sml - 1 bedroom
{376.7426, 1417.3226, 1081.3281},   // Sml - 1 bedroom
{295.2874, 1473.2769, 1080.2578},   // Med - 2 bedroom
{327.9431, 1478.3801, 1084.4375}, // Med - 2 bedroom
{2270.1050, -1210.3917, 1047.5625},   // Med - 2 bedroom
{447.1211, 1397.8444, 1084.3047},   // Med - 2 bedroom
{2196.0063, -1204.6326, 1049.0234}, // Lrg - 3 bedroom
{235.3416, 1187.2882, 1080.2578},   // Lrg - 3 bedroom
{490.9987, 1399.4164, 1080.2578},   // Lrg - 3 bedroom
{227.1212, 1114.1840, 1080.9972},   // Lrg - 4 bedroom
{225.6624, 1022.5345, 1084.0145}    // Xlrg - 4 bedrooms
};

new HousesLevels[13][2] = {
{1, 2000},    // Sml - 1 bedroom
{4, 4500},    // Sml - 1 bedroom
{9, 7000},    // Sml - 1 bedroom
{15, 10000},  // Sml - 1 bedroom
{15, 17000},  // Med - 2 bedroom
{15, 23000},  // Med - 2 bedroom
{10, 34000},  // Med - 2 bedroom
{2, 62000},   // Med - 2 bedroom
{6, 102000},  // Lrg - 3 bedroom
{3, 156000},  // Lrg - 3 bedroom
{2, 188000},  // Lrg - 3 bedroom
{5, 235000},   // Lrg - 4 bedroom
{7, 295000}   // Xlrg - 4 bedrooms
};

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print("Stefan's House System");
	print("--------------------------------------\n");
	
	for(new i = 0; i <= MAX_PLAYERS; i++)
	{
	    Timer[0] = SetTimerEx("ReadPlayerHouseData", 1000, true, "%i", i);
	}
	for(new h = 0; h <= MAX_HOUSES; h++) // Player Homes
	{
	    LoadPlayerHouse(h);
	}
	return true;
}

public OnFilterScriptExit()
{
	KillTimer(Timer[0]);
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    dcmd(househelp,9,cmdtext);
    dcmd(houseinfo,9,cmdtext);
	dcmd(enter,5,cmdtext);
	dcmd(exit,4,cmdtext);
	/*dcmd(evict,5,cmdtext);
	dcmd(renthouse,9,cmdtext);
	dcmd(unrenthouse,11,cmdtext);
	dcmd(tenants,7,cmdtext);*/
	dcmd(house,5,cmdtext);
	dcmd(lockhouse,9,cmdtext);
	dcmd(unlockhouse,11,cmdtext);
	dcmd(rentprice,9,cmdtext);
	dcmd(buyhouse,8,cmdtext);
	dcmd(sellhouse,9,cmdtext);
	dcmd(unsellhouse,11,cmdtext);
	dcmd(createhouse,11,cmdtext);
	dcmd(destroyhouse,12,cmdtext);
	
	return false;
}

///////////////////////////////////////
//	   Buisness + Homes Functions
//////////////////////////////////////

stock CreatePlayerHouse(playerid, sellprice, HouseLvl)
{
    if((ReturnNextUnusedHouseID()-1) >= MAX_HOUSES) return SendClientMessage(playerid, COLOR_WHITE, ".:: [HOUSE]: Maximum amount of houses on the server have been created.");
	new house[64], Float:X, Float:Y, Float:Z; GetPlayerPos(playerid, X, Y, Z);
	new NextHouseID = ReturnNextUnusedHouseID();
	new World = ReturnNextUnusedVirtualWorld();
	
	format(house, sizeof(house), "/Houses/%d.dini.save", NextHouseID);
	
	if(!dini_Exists(house)){
		dini_Create(house);
		dini_Set(house, "Name", "None");
		dini_IntSet(house, "For_Sell", 1);
		dini_IntSet(house, "Sell_Price", sellprice);
		dini_IntSet(house, "Rent_Price", 1000);
		dini_IntSet(house, "House_Level", HouseLvl);
 		dini_FloatSet(house,"Exit_Coord:X", X);
  		dini_FloatSet(house,"Exit_Coord:Y", Y);
    	dini_FloatSet(house,"Exit_Coord:Z", Z);
     	dini_IntSet(house, "VirtualWorld", World);
      	dini_IntSet(house, "Status", 0);
      	LoadPlayerHouse(NextHouseID);
       	SendClientMessage(playerid, COLOR_WHITE, ".:: [HOUSE]: House has been Successfully created.");
	}
	return true;
}

stock LoadPlayerHouse(houseid)
{
    new house[64]; format(house, sizeof(house), "/Houses/%d.dini.save", houseid);
    if(dini_Exists(house)){
        format(HouseInfo[houseid][hName], MAX_PLAYER_NAME, "%s", dini_Get(house, "Name"));
        HouseInfo[houseid][hSellable]  	  =  dini_Int(house, "For_Sell");
		HouseInfo[houseid][hSell]  	 	  =  dini_Int(house, "Sell_Price");
       	HouseInfo[houseid][hRent]  	 	  =  dini_Int(house, "Rent_Price");
       	HouseInfo[houseid][hLevel] 		  =  dini_Int(house, "House_Level");
       	HouseInfo[houseid][hExitX]  	  =  dini_Float(house, "Exit_Coord:X");
       	HouseInfo[houseid][hExitY]  	  =  dini_Float(house, "Exit_Coord:Y");
        HouseInfo[houseid][hExitZ]  	  =  dini_Float(house, "Exit_Coord:Z");
       	HouseInfo[houseid][hVirtualWorld] =  dini_Int(house, "VirtualWorld");
       	HouseInfo[houseid][hLocked] 	  =  dini_Int(house, "Status");
       	
       	if(HouseInfo[houseid][hSellable] == 1){
		    HouseInfo[houseid][hPickup] = CreatePickup(1273, 23, HouseInfo[houseid][hExitX], HouseInfo[houseid][hExitY], HouseInfo[houseid][hExitZ]); // not bought
		} else {
		    HouseInfo[houseid][hPickup] = CreatePickup(1272,23, HouseInfo[houseid][hExitX], HouseInfo[houseid][hExitY], HouseInfo[houseid][hExitZ]); // bought
		}
	}
	return true;
}

public SavePlayerHouse(houseid)
{
    new house[64]; format(house, sizeof(house), "/Houses/%d.dini.save", houseid);
    if(dini_Exists(house)){
        dini_Set(house, "Name", HouseInfo[houseid][hName]);
        dini_IntSet(house, "For_Sell", HouseInfo[houseid][hSellable]);
		dini_IntSet(house, "Sell_Price", HouseInfo[houseid][hSell]);
       	dini_IntSet(house, "Rent_Price", HouseInfo[houseid][hRent]);
	 	dini_IntSet(house, "House_Level", HouseInfo[houseid][hLevel]);
       	dini_FloatSet(house, "Exit_Coord:X", HouseInfo[houseid][hExitX]);
       	dini_FloatSet(house, "Exit_Coord:Y", HouseInfo[houseid][hExitY]);
        dini_FloatSet(house, "Exit_Coord:Z", HouseInfo[houseid][hExitZ]);
       	dini_IntSet(house, "VirtualWorld", HouseInfo[houseid][hVirtualWorld]);
	  	dini_IntSet(house, "Status", HouseInfo[houseid][hLocked]);
	}
	return true;
}

stock ReturnNextUnusedHouseID()
{
    new house[64];
	for(new h = 0; h <= MAX_HOUSES; h++){
		format(house, sizeof(house), "/Houses/%d.dini.save", h);
		if(!dini_Exists(house)) return h; }
	return true;
}

stock ReturnNextUnusedVirtualWorld()
{
    new house[64]; // Please do not make more then 255 houses because that is the Maximum Virtual Worlds. Or use as many as you want in 0.3
	format(house, sizeof(house), "/Houses/%d.dini.save", ReturnNextUnusedHouseID()-1);
	return dini_Int(house, "VirtualWorld")+1;
}

public ReadPlayerHouseData(playerid)
{
	new string[256], house[64];
	for(new h = 0; h <= MAX_HOUSES; h++){
		format(house, sizeof(house), "/Houses/%d.dini.save", h);
	    if(dini_Exists(house)){
			if(HouseInfo[h][hSellable] == 1){
	  			if(PlayerToPoint(PTP_RADIUS, playerid, HouseInfo[h][hExitX], HouseInfo[h][hExitY], HouseInfo[h][hExitZ])) {
					format(string, sizeof(string), "~g~] House for Sale ]~n~~w~Owner:~y~ %s~n~~w~Level:~r~ %d~n~~w~Sell Price:~r~ %d~n~~w~Rent Cost:~r~ %d", HouseInfo[h][hName], HouseInfo[h][hLevel], HouseInfo[h][hSell], HouseInfo[h][hRent]);
					GameTextForPlayer(playerid,string, 1500, 3);
				}
			} else if(HouseInfo[h][hSellable] == 0){
				if(PlayerToPoint(PTP_RADIUS, playerid, HouseInfo[h][hExitX], HouseInfo[h][hExitY], HouseInfo[h][hExitZ])) {
					format(string, sizeof(string), "~w~Owner:~y~ %s~n~~w~Level:~r~ %d~n~~w~Rent Cost:~r~ %d", HouseInfo[h][hName], HouseInfo[h][hLevel], HouseInfo[h][hRent]);
					GameTextForPlayer(playerid,string, 1500, 3);
				} } } }
}

stock DestroyPlayerHouse(playerid, houseid)
{
	new house[64];
    format(house, sizeof(house), "/Houses/%d.dini.save", houseid);
    if(dini_Exists(house)){
		dini_Remove(house);
		DestroyPickup(HouseInfo[houseid][hPickup]);
		SendClientMessage(playerid, COLOR_WHITE, ".:: [HOUSE]: The given house has been destroyed.");
	} else return SendClientMessage(playerid, COLOR_WHITE, ".:: [ERROR]: The given house id does not exsist so it cannot be destroyed.");
	return false;
}

///////////////////////////
//     Dcmd Commands
//////////////////////////

dcmd_househelp(playerid,params[]) {
	#pragma unused params
	if(IsPlayerConnected(playerid)){
		SendClientMessage(playerid, COLOR_WHITE,"[HOUSE OWNER]: /(un)sellhouse, /(un)lockhouse, /rentprice, /tenants, /evict, /house (upgrade/downgrade)");
		SendClientMessage(playerid, COLOR_WHITE,"[HOUSE PLAYERS]: /houseinfo, /buyhouse, /(un)renthouse, /enter, /exit");
	}
	return true;
}

dcmd_houseinfo(playerid,params[]) {
	#pragma unused params
	if(IsPlayerConnected(playerid)){
		for(new h = 0; h <= MAX_HOUSES; h++){
		    if(PlayerToPoint(PTP_RADIUS, playerid, HouseInfo[h][hExitX], HouseInfo[h][hExitY], HouseInfo[h][hExitZ])){
			    new IsLocked[24];
			    if(HouseInfo[h][hLocked] == 1) { IsLocked = "True"; } else { IsLocked = "False"; }
			    SendClientMessage(playerid, COLOR_LIME,"HOUSE STATS ----------------------------------------------------------");
			    SendFormattedMessage(playerid, COLOR_WHITE, "Owner: %s - Level[%d] - RentCost[$%d] - SellPrice[$%d]", HouseInfo[h][hName], HouseInfo[h][hLevel], HouseInfo[h][hRent], HouseInfo[h][hSell]);
			    SendFormattedMessage(playerid, COLOR_WHITE, "IsLocked[%s] - HouseID[%d] - ExitCoords[X:%.4f, Y:%.4f, Z:%.4f]", IsLocked, h, HouseInfo[h][hExitX], HouseInfo[h][hExitY], HouseInfo[h][hExitZ]);
			    SendClientMessage(playerid, COLOR_LIME,"----------------------------------------------------------");
	  		} } }
	return true;
}

dcmd_enter(playerid,params[]) {
	#pragma unused params
	if(IsPlayerConnected(playerid)){
		for(new h = 0; h <= MAX_HOUSES; h++){
		    if(PlayerToPoint(PTP_RADIUS, playerid, HouseInfo[h][hExitX], HouseInfo[h][hExitY], HouseInfo[h][hExitZ])){
		    	new Level = HouseInfo[h][hLevel];
		    	if(HouseInfo[h][hLocked] == 1 && strcmp(HouseInfo[h][hName],GetName(playerid), false ) != 0) return SendClientMessage(playerid, COLOR_WHITE,  ".:: [HOUSE]: This house has been locked by the owner.");
	    		SetPlayerPos(playerid, HousesCoords[Level][0], HousesCoords[Level][1], HousesCoords[Level][2]);
	   			SetPlayerInterior(playerid, HousesLevels[Level][0]); SetPlayerVirtualWorld(playerid, HouseInfo[h][hVirtualWorld]);
	  		} } }
	return true;
}

dcmd_exit(playerid,params[]) {
	#pragma unused params
	if(IsPlayerConnected(playerid)){
		for(new h = 0; h <= MAX_HOUSES; h++){
		    if(PlayerToPoint(PTP_RADIUS, playerid, HousesCoords[HouseInfo[h][hLevel]][0], HousesCoords[HouseInfo[h][hLevel]][1], HousesCoords[HouseInfo[h][hLevel]][2])){
       		SetPlayerPos(playerid, HouseInfo[h][hExitX], HouseInfo[h][hExitY], HouseInfo[h][hExitZ]);
	   		SetPlayerInterior(playerid, 0); SetPlayerVirtualWorld(playerid, 0);
		    } } }
}

/*dcmd_evict(playerid,params[]) { // This needs to be intergrated with your players .ini account
	#pragma unused params
	if(IsPlayerConnected(playerid)){
		new giveplayerid;
		if(sscanf(params, "i", giveplayerid)) return SendClientMessage(playerid, COLOR_WHITE, "[USAGE]: /evict [id]");
		if(!IsPlayerConnected(giveplayerid)) return SendClientMessage(playerid, COLOR_WHITE, "The given player does not exist");
		
		for(new h = 0; h <= MAX_HOUSES; h++){
		    if(PlayerToPoint(PTP_RADIUS, playerid, HouseInfo[h][hExitX], HouseInfo[h][hExitY], HouseInfo[h][hExitZ])){
     			if(strcmp(HouseInfo[h][hName],GetName(playerid), false ) == 0){
				    if(PlayerInfo[giveplayerid][pHouse] != h) return SendClientMessage(playerid, COLOR_WHITE, ".:: [ERROR]: This player is not renting your house.");
				    PlayerInfo[giveplayerid][pHouse] = -1; PlayerUpdate(giveplayerid);
				    SendFormattedMessage(playerid, COLOR_WHITE, ".:: [HOUSE]: You have evicted %s[%d] from your house.", GetName(giveplayerid), giveplayerid);
          		} else return SendClientMessage(playerid, COLOR_WHITE, ".:: [HOUSE]: You are not the owner of this house.");
			} } }
	return true;
}

dcmd_tenants(playerid,params[]) { // This needs to be intergrated with your players .ini account
	#pragma unused params
	if(IsPlayerConnected(playerid)){
		for(new i = 0; i <= MAX_PLAYERS; i++){
		    for(new h = 0; h <= MAX_HOUSES; h++){
			    if(PlayerToPoint(PTP_RADIUS, playerid, HouseInfo[h][hExitX], HouseInfo[h][hExitY], HouseInfo[h][hExitZ])){
				    if(PlayerInfo[i][pHouse] == h){
						if(strcmp(HouseInfo[h][hName],GetName(playerid), false ) == 0){
							PlayerInfo[giveplayerid][pHouse] = -1;
							SendClientMessage(playerid, COLOR_LIME, "_---- Tenants ----");
							SendFormattedMessage(playerid, COLOR_WHITE, "%s[%d]", GetName(i), i);
						} else return SendClientMessage(playerid, COLOR_WHITE, ".:: [HOUSE]: You are not the owner of this house.");
					} } } } }
	return true;
}

dcmd_renthouse(playerid,params[]) { // This needs to be intergrated with your players .ini account
	#pragma unused params
	if(IsPlayerConnected(playerid)){
		for(new h = 0; h <= MAX_HOUSES; h++){
		    if(PlayerToPoint(PTP_RADIUS, playerid, HouseInfo[h][hExitX], HouseInfo[h][hExitY], HouseInfo[h][hExitZ])){
			    if(HouseInfo[h][hName] == "Name") return SendClientMessage(playerid, COLOR_WHITE, ".:: [ERROR]: No one has bought this house so you cannot rent from here.");
		    	if(PlayerInfo[playerid][pHouse] != -1) return SendClientMessage(playerid, COLOR_WHITE, ".:: [ERROR]: You are allready renting a house. Use /unrenthouse to stop renting there.");
			    PlayerInfo[playerid][pHouse] = h; PlayerUpdate(giveplayerid);
			    SendFormattedMessage(playerid, COLOR_WHITE, ".:: [HOUSE]: You are now renting from %s.", HouseInfo[h][hName]);
			} } }
	return true;
}

dcmd_unrenthouse(playerid,params[]) { // This needs to be intergrated with your players .ini account
	#pragma unused params
	if(IsPlayerConnected(playerid)){
		if(PlayerInfo[playerid][pHouse] == -1) return SendClientMessage(playerid, COLOR_WHITE, ".:: [ERROR]: You are not renting a house.");
		PlayerInfo[playerid][pHouse] = -1; PlayerUpdate(giveplayerid);
		SendFormattedMessage(playerid, COLOR_WHITE, ".:: [HOUSE]: You are not renting from %s anymore.", HouseInfo[h][hName]);
		}
	return true;
}
*/

dcmd_buyhouse(playerid,params[]) {
	#pragma unused params
	if(IsPlayerConnected(playerid)){
	    for(new h = 0; h <= MAX_HOUSES; h++){
		    if(PlayerToPoint(PTP_RADIUS, playerid, HouseInfo[h][hExitX], HouseInfo[h][hExitY], HouseInfo[h][hExitZ])){
		        if(strcmp(HouseInfo[h][hName],GetName(playerid), false ) != 0){
		        	if(HouseInfo[h][hSellable] == 1){
			            if(GetPlayerMoney(playerid) < HouseInfo[h][hSell]) return SendClientMessage(playerid, COLOR_WHITE, ".:: [HOUSE]: You do not have anough money to buy this house.");
			        	DestroyPickup(HouseInfo[h][hPickup]);
			        	HouseInfo[h][hPickup] = CreatePickup(1272,23, HouseInfo[h][hExitX], HouseInfo[h][hExitY], HouseInfo[h][hExitZ]); // bought
						HouseInfo[h][hSellable] = 0; GivePlayerMoney(playerid, -HouseInfo[h][hSell]);
			        	format(HouseInfo[h][hName], 24, "%s", GetName(playerid)); SavePlayerHouse(h);
          			} else return SendClientMessage(playerid, COLOR_WHITE, ".:: [HOUSE]: This house is not for sale.");
   				} else return SendClientMessage(playerid, COLOR_WHITE, ".:: [HOUSE]: You are cannot buy the house you are selling.");
		    } } }
	return true;
}

dcmd_rentprice(playerid,params[]) {
	#pragma unused params
	if(IsPlayerConnected(playerid)){
		new Price;
		if(sscanf(params, "i", Price)) return SendClientMessage(playerid, COLOR_WHITE, "[USAGE]: /rentprice [rentprice]");
		if(Price < 0 || Price > 10000) return SendClientMessage(playerid, COLOR_WHITE, "You cannot set the rent price below 0 or above 10k");
		for(new h = 0; h <= MAX_HOUSES; h++){
		    if(PlayerToPoint(PTP_RADIUS, playerid, HouseInfo[h][hExitX], HouseInfo[h][hExitY], HouseInfo[h][hExitZ])){
     			if(strcmp(HouseInfo[h][hName],GetName(playerid), false ) == 0){
				    HouseInfo[h][hRent] = Price; SavePlayerHouse(h);
          		} else return SendClientMessage(playerid, COLOR_WHITE, ".:: [HOUSE]: You are not the owner of this house.");
			} } }
	return true;
}

dcmd_house(playerid,params[]) {
	#pragma unused params
	if(IsPlayerConnected(playerid)){
		new tmp[64];
		if(sscanf(params, "s", tmp)) return SendClientMessage(playerid, COLOR_WHITE, "[USAGE]: /house (upgrade/downgrade)");
		SendFormattedMessage(playerid, COLOR_WHITE, "Houses: 0[%d], 1[%d], 2[%d], 3[%d], 4[%d], 5[%d], 6[%d]", HousesLevels[0][1], HousesLevels[1][1], HousesLevels[2][1], HousesLevels[3][1], HousesLevels[4][1], HousesLevels[5][1], HousesLevels[6][1]);
		SendFormattedMessage(playerid, COLOR_WHITE, "7[%d], 8[%d], 9[%d], 10[%d], 11[%d], 12[%d]", HousesLevels[7][1], HousesLevels[8][1], HousesLevels[9][1], HousesLevels[10][1], HousesLevels[11][1], HousesLevels[12][1]);
		if(strlen(tmp) == strlen("upgrade")){
			for(new h = 0; h <= MAX_HOUSES; h++){
			    if(PlayerToPoint(PTP_RADIUS, playerid, HouseInfo[h][hExitX], HouseInfo[h][hExitY], HouseInfo[h][hExitZ])){
					if(strcmp(HouseInfo[h][hName],GetName(playerid), false ) == 0){
					    if(HouseInfo[h][hLevel]+1 > 12) return SendClientMessage(playerid, COLOR_WHITE, "You cannot set your house lvl above 12");
					    new Level = HousesLevels[HouseInfo[h][hLevel]+1][1];
					    SendFormattedMessage(playerid, COLOR_WHITE, "You have added improvments to your house that costs $%d", Level);
					    HouseInfo[h][hLevel] = (HouseInfo[h][hLevel]+1); GivePlayerMoney(playerid, -Level);
						SavePlayerHouse(h);
	          		} else return SendClientMessage(playerid, COLOR_WHITE, ".:: [HOUSE]: You are not the owner of this house."); } }
		}
	    if(strlen(tmp) == strlen("downgrade")){
		    for(new h = 0; h <= MAX_HOUSES; h++){
			    if(PlayerToPoint(PTP_RADIUS, playerid, HouseInfo[h][hExitX], HouseInfo[h][hExitY], HouseInfo[h][hExitZ])){
					if(strcmp(HouseInfo[h][hName],GetName(playerid), false ) == 0){
					    if(HouseInfo[h][hLevel]-1 < 0) return SendClientMessage(playerid, COLOR_WHITE, "You cannot set your house lvl below 0");
					    new Level = HousesLevels[HouseInfo[h][hLevel]-1][1];
					    SendFormattedMessage(playerid, COLOR_WHITE, "You have removed improvments done to your house and have been refunded $%d", Level);
					    HouseInfo[h][hLevel] = (HouseInfo[h][hLevel]-1); GivePlayerMoney(playerid, Level);
						SavePlayerHouse(h);
	          		} else return SendClientMessage(playerid, COLOR_WHITE, ".:: [HOUSE]: You are not the owner of this house."); } }
		}
	}
	return true;
}

dcmd_lockhouse(playerid,params[]) {
	#pragma unused params
	if(IsPlayerConnected(playerid)){
		for(new h = 0; h <= MAX_HOUSES; h++){
		    if(PlayerToPoint(PTP_RADIUS, playerid, HouseInfo[h][hExitX], HouseInfo[h][hExitY], HouseInfo[h][hExitZ])){
     			if(strcmp(HouseInfo[h][hName],GetName(playerid), false ) == 0){
     				if(HouseInfo[h][hLocked] == 1) return SendClientMessage(playerid, COLOR_WHITE, ".:: [ERROR]: This house is allready locked.");
				    HouseInfo[h][hLocked] = 1; SavePlayerHouse(h);
				    SendClientMessage(playerid, COLOR_WHITE, ".:: [HOUSE]: You house has been locked.");
          		} else return SendClientMessage(playerid, COLOR_WHITE, ".:: [HOUSE]: You are not the owner of this house.");
		    } } }
	return true;
}

dcmd_unlockhouse(playerid,params[]) {
	#pragma unused params
	if(IsPlayerConnected(playerid)){
		for(new h = 0; h <= MAX_HOUSES; h++){
		    if(PlayerToPoint(PTP_RADIUS, playerid, HouseInfo[h][hExitX], HouseInfo[h][hExitY], HouseInfo[h][hExitZ])){
     			if(strcmp(HouseInfo[h][hName],GetName(playerid), false ) == 0){
     			    if(HouseInfo[h][hLocked] == 0) return SendClientMessage(playerid, COLOR_WHITE, ".:: [ERROR]: This house is allready unlocked.");
				    HouseInfo[h][hLocked] = 0; SavePlayerHouse(h);
				    SendClientMessage(playerid, COLOR_WHITE, ".:: [HOUSE]: You house has been unlocked.");
          		} else return SendClientMessage(playerid, COLOR_WHITE, ".:: [HOUSE]: You are not the owner of this house.");
		    } } }
	return true;
}

dcmd_sellhouse(playerid,params[]) {
	#pragma unused params
	if(IsPlayerConnected(playerid)){
		new Sell;
		if(sscanf(params, "i", Sell)) return SendClientMessage(playerid, COLOR_WHITE, "[USAGE]: /sellhouse [sellprice]");
		if(Sell < 0 || Sell > 5000000) return SendClientMessage(playerid, COLOR_WHITE, "You cannot set the sell price below 0 or above 5 Mill");
		for(new h = 0; h <= MAX_HOUSES; h++){
		    if(PlayerToPoint(PTP_RADIUS, playerid, HouseInfo[h][hExitX], HouseInfo[h][hExitY], HouseInfo[h][hExitZ])){
     			if(strcmp(HouseInfo[h][hName],GetName(playerid), false ) == 0){
	        		DestroyPickup(HouseInfo[h][hPickup]);
	   				HouseInfo[h][hPickup] = CreatePickup(1273, 23, HouseInfo[h][hExitX], HouseInfo[h][hExitY], HouseInfo[h][hExitZ]); // not bought
				    HouseInfo[h][hSellable] = 1; HouseInfo[h][hSell] = Sell; SavePlayerHouse(h);
          		} else return SendClientMessage(playerid, COLOR_WHITE, ".:: [HOUSE]: You are not the owner of this house.");
		    } } }
	return true;
}

dcmd_unsellhouse(playerid,params[]) {
	#pragma unused params
	if(IsPlayerConnected(playerid)){
		for(new h = 0; h <= MAX_HOUSES; h++){
		    if(PlayerToPoint(PTP_RADIUS, playerid, HouseInfo[h][hExitX], HouseInfo[h][hExitY], HouseInfo[h][hExitZ])){
     			if(strcmp(HouseInfo[h][hName],GetName(playerid), false ) == 0){
	        		DestroyPickup(HouseInfo[h][hPickup]);
		        	HouseInfo[h][hPickup] = CreatePickup(1272,23, HouseInfo[h][hExitX], HouseInfo[h][hExitY], HouseInfo[h][hExitZ]); // bought
				    HouseInfo[h][hSellable] = 0; SavePlayerHouse(h);
          		} else return SendClientMessage(playerid, COLOR_WHITE, ".:: [HOUSE]: You are not the owner of this house.");
			} } }
	return true;
}

dcmd_createhouse(playerid,params[]) {
	#pragma unused params
	if(IsPlayerConnected(playerid)){
		//if(PlayerInfo[playerid][pAdmin] < 10) return SendClientMessage(playerid,COLOR_WHITE,"SERVER: Unknown command.");
		if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Only admins allowed to use this command");
		new Sell, lvl;
		if(sscanf(params, "ii", Sell, lvl)) return SendClientMessage(playerid, COLOR_WHITE, "[USAGE]: /createhouse [sellprice] [HouseLvl]");
		if(Sell < 0 || Sell > 5000000) return SendClientMessage(playerid, COLOR_WHITE, "You cannot set the sell price below 0 or above 5 Mill");
		if(lvl < 0 || lvl > 12) return SendClientMessage(playerid, COLOR_WHITE, "You cannot create a house lvl that is below 0 or above 12");
		CreatePlayerHouse(playerid, Sell, lvl); }
	return true;
}

dcmd_destroyhouse(playerid,params[]) {
	#pragma unused params
	if(IsPlayerConnected(playerid)){
		//if(PlayerInfo[playerid][pAdmin] < 10) return SendClientMessage(playerid,COLOR_WHITE,"SERVER: Unknown command.");
		if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Only admins allowed to use this command");
	  	new houseid;
		if(sscanf(params, "i", houseid)) return SendClientMessage(playerid, COLOR_WHITE, "[USAGE]: /destroyhouse [houseid]");
		DestroyPlayerHouse(playerid, houseid);}
	return true;
}

///////////////////////////
//   Standard Functions
//////////////////////////

stock GetName(playerid)
{
	new pname[MAX_PLAYER_NAME]; pname="Invalid PlayerID";
	if(IsPlayerConnected(playerid)) {
		GetPlayerName(playerid, pname, sizeof (pname));
	}
	return pname;
}

public PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z)
{
	new Float:oldposx, Float:oldposy, Float:oldposz;
	new Float:tempposx, Float:tempposy, Float:tempposz;
	GetPlayerPos(playerid, oldposx, oldposy, oldposz);
	tempposx = (oldposx -x); tempposy = (oldposy -y); tempposz = (oldposz -z);
	if(((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
	{ return true; }
	return false;
}
