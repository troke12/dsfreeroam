//==============================================================================
//                              Includes
//==============================================================================
#define FILTERSCRIPT // Important
#include <a_samp> // Credits to the SA:MP Developement Team
#include <sscanf2> // Credits to Y_Less
#include <YSI\y_ini> // Credits to Y_Less
#include <ZCMD> // Credits to Zeex
#include <streamer> // Credits to Incognito
#include <foreach> // Credits to Y_Less
//##############################################################################
//                              Do NOT Replace!!!
//##############################################################################
#define INFORMATION_HEADER "{F6F6F6}House System{00BC00}"
#define LABELTEXT1 "House Name: {F6F6F6}%s\n{00BC00}House Owner: {F6F6F6}No Owner\n{00BC00}House Value: {F6F6F6}$%d\n{00BC00}For Sale: {F6F6F6}No\n{00BC00}House Privacy: {F6F6F6}Closed\n{00BC00}House ID: {F6F6F6}%d"
#define LABELTEXT2 "House Name: {F6F6F6}%s\n{00BC00}House Owner: {F6F6F6}%s\n{00BC00}House Value: {F6F6F6}$%d\n{00BC00}For Sale: {F6F6F6}%s\n{00BC00}House Privacy: {F6F6F6}%s\n{00BC00}House ID: {F6F6F6}%d"
//==============================================================================
//                              Macros
//==============================================================================
new CMDSString[1000], IsInHouse[MAX_PLAYERS char];
#define YesNo(%0) ((%0) == (1)) ? ("Yes") : ("No")
#define Answer(%0,%1,%2) (%0) == (1) ? (%1) : (%2)
#define IsPlayerInHouse(%0,%1) ((GetPVarInt(%0, "LastHouseCP") == (%1)) && (IsInHouse{%0} == (1))) ? (1) : (0)
#define ShowInfoBox(%0,%1,%2) do{CMDSString = ""; format(CMDSString, 1000, %1, %2); ShowPlayerDialog(%0, HOUSEMENU-1, DIALOG_STYLE_MSGBOX, INFORMATION_HEADER, CMDSString, "Close", "");}while(FALSE)
#define GameTextEx(%0,%1,%2,%3,%4) do{CMDSString = ""; format(CMDSString, 1000, %3, %4); GameTextForPlayer(%0, CMDSString, %1, %2);}while(FALSE)
#define Loop(%0,%1,%2) for(new %0 = %2; %0 < %1; %0++)
#define function%0(%1) forward %0(%1); public %0(%1)
#define TYPE_OUT (0)
#define TYPE_INT (1)
//==============================================================================
//                              Colours
//==============================================================================
#define COLOUR_INFO			   			0x00CC33FF
#define COLOUR_SYSTEM 		   			0xFF0000FF
#define COLOUR_YELLOW 					0xFFFF2AFF
#define COLOUR_GREEN 					0x00BC00FF
#define COLOUR_DIALOG                   0xF6F6F6AA
//==============================================================================
#define DC_SAMP         				"{F6F6F6}"
#define DC_DIALOG 						"{F6F6F6}"
#define DC_ERROR 						"{FF0000}"
#define DC_ADMIN 						"{CC00CC}"
#define DC_INFO 						"{00BC00}"
//==============================================================================
//                              Configuration
//==============================================================================
#define MAX_HOUSES 					1000 // Max houses created
#define MAX_HOUSE_INTERIORS         15 // Max house interiors created
#define MAX_HOUSES_OWNED    		5 // Max houses owned per player
#define HOUSEMENU 					21700 // Dialog ID
#define FILEPATH 					"/GarHouse/Houses/%d.ini"
#define HINT_FILEPATH 				"/GarHouse/Interiors/%d.ini"
#define USERPATH 					"/GarHouse/Users/%s.ini"
//------------------------------------------------------------------------------
#define GH_USE_MAPICONS 			true  // true = use mapicons | false = do not use mapicons
#define GH_USE_CPS 					false  // true = use checkpoints | false = use pickups
#define GH_HINTERIOR_UPGRADE 		true  // true = allow players to upgrade their house interior | false = do not allow players to upgrade their house interior
#define GH_USE_HOUSESTORAGE 		true  // true = allow players to use the house storage | false = do not allow players to use the house storage
#define GH_HOUSECARS				true  // true = enable house cars | false = disable house cars
#define SPAWN_IN_HOUSE 				false  // true = players will spawn in their house on their first spawn | false = players will not spawn in their house on their first spawn
#define CASE_SENSETIVE              true  // true = ignore case sensetive in strcmp | false = do not ignore case sensetive in strcmp
#define GH_ALLOW_BREAKIN            true  // true = allow players to breakin to houses | false = do not allow players to breakin to houses
#define GH_GIVE_WANTEDLEVEL         true  // true = increase the players wanted level when they either attempt to breakin/rob a house or they succeed in doing so | false = do not increase the players wanted level when they either attempt to breakin/rob a house or they succeed in doing so
#define GH_ALLOW_HOUSEROBBERY       false // true = allow players to rob houses | false = do not allow players to rob houses
#define GH_SAVE_ADMINWEPS 			false // true = save admin weapons (f.ex: minigun, grenades, RPG) | false = do not save admin weapons (f.ex: minigun, grenades, RPG)
#define GH_USE_WEAPONSTORAGE 		false // true = allow players to store weapons in their house | false = do not allow players to store weapons in their house
#define GH_ALLOW_HOUSETELEPORT      false // true = allow players to teleport to their house using /myhouses | false = do not allow players to teleport to their house using /myhouses
//------------------------------------------------------------------------------
#define HOUSEFILE_LENGTH      		30
#define INTERIORFILE_LENGTH   		30
#define MIN_HOUSE_VALUE             100000 // Min house value of a house (ofc prices will change when a house is bought/sold nearby)
#define MAX_HOUSE_VALUE             25000000 // Max house value of a house (ofc prices will change when a house is bought/sold nearby)
#define MIN_HINT_VALUE      		10000 // Min house interior value
#define MAX_HINT_VALUE      		50000000 // Max house interior value
#define HOUSE_ROBBERY_PERCENT       25 // How many percent of the cash in the house storage will be robbed?
#define MAX_MONEY_ROBBED            500000 // Max money you can rob from a house.
#define HSPAWN_TIMER_RATE   		1000 // After how long will the timer call the spawn in house function? (in ms)
#define MICON_VD 					50.0 // Map icon visible range (drawdistance).
#define TEXTLABEL_DISTANCE 			25.0 // 3D text visible range (drawdistance)
#define TEXTLABEL_TESTLOS 			1 // 1 makes the 3D text label visible trough walls.
#define CP_DRAWDISTANCE 			25.0 // checkpoint visible range (drawdistance)
#define DEFAULT_H_INTERIOR  		0 // Default house interior when creating a house
#define HCAR_COLOUR1 				-1 // The first colour of the housecar
#define HCAR_COLOUR2 				-1 // The second colour of the housecar
#define HCAR_RESPAWN				60 // The respawn delay of the house car (in seconds)
#define HCAR_RANGE  				10.0 // The range to check for nearby vehicles when saving the house car.
#define PICKUP_MODEL_OUT 			1273 // Pickup model ID which shows up OUTSIDE the house.
#define PICKUP_MODEL_INT 			1272 // Pickup model ID which shows up INSIDE the house.
#define PICKUP_TYPE                 1 // The pickup type if you decide to not use checkpoints
#define MAX_VISIT_TIME              1 // The max time the player can be visiting in (In Minutes).
#define TIME_BETWEEN_VISITS         2 // The time the player have to wait before previewing a new house interior (In minutes).
#define TIME_BETWEEN_BREAKINS       5 // The time the player have to wait before attempting to breakin to a house again (In minutes).
#define TIME_BETWEEN_ROBBERIES      10 // The time the player have to wait before attempting to rob a house again (In minutes).
#define HOUSE_SELLING_PROCENT   	75 // The amount of the house value the player will get when the house is sold.
#define HOUSE_SELLING_PROCENT2 		6.5 // The total percentage the nearby houses will go up/down by when a house is sold/bought nearby.
#define RANGE_BETWEEN_HOUSES        200 // The range used when increasing/decreasing the value of nearby houses when a house is bought/sold (set to 0 to disable)
#define MAX_HOUSE_NAME              35 // Max length of a house name
#define MIN_HOUSE_NAME              4 // Min length of a house name
#define MAX_HINT_NAME              	35 // Max length of a house interior name
#define MIN_HINT_NAME              	4 // Min length of a house interior name
#define MAX_HOUSE_PASSWORD          35 // Max length of a house password
#define MIN_HOUSE_PASSWORD          4 // Min length of a house password
#define MAX_ZONE_NAME 				60 // Max length of a zone name
#define MIN_ROB_TIME                30 // The minimum amount of time the player have to be in the house to be able to rob it (In seconds)
#define MAX_ROB_TIME                60 // The maximum amount of time the player have to be in the house to be able to rob it (In seconds)
#define HUPGRADE_ALARM  			10000 // How much the player should pay for the house alarm upgrade.
#define HUPGRADE_CAMERA 	 		25000 // How much the player should pay for the security camera upgrade.
#define HUPGRADE_DOG  				35000 // How much the player should pay for the security dog upgrade.
#define HUPGRADE_UPGRADED_HLOCK  	40000 // How much the player should pay for the doorlock upgrade.
#define HBREAKIN_WL                 1 // How much should the players wanted level increase by when they fail/succeed at breaking into a house (if the house has a house alarm/security camera).
#define HROBBERY_WL                 3 // How much should the players wanted level increase by when they fail/succeed at robbing a house (if the house has a house alarm/security camera).
#define GH_MAX_WANTED_LEVEL         6 // What is the max wanted level a player can get?
#define SECURITYDOG_HEALTHLOSS 		25.00 // How much health should the player lose after each bit?
#define SECURITYDOG_BITS    		3 // How many times will the dog bite the player during a breakin/robbery?
#define INVALID_HOWNER_NAME         "INVALID_PLAYER_ID" // The "name" of the house owner when there is no owner of the house
#define DEFAULT_HOUSE_NAME          "House For Sale!" // The default name when a house is created/sold
//------------------------------------------------------------------------------
new Iterator:Houses<MAX_HOUSES>, Text3D:HouseLabel[MAX_HOUSES], Float:X, Float:Y, Float:Z, Float:Angle;
#if GH_USE_CPS == true
	new HouseCPOut[MAX_HOUSES], HouseCPInt[MAX_HOUSES];
#else
	new HousePickupOut[MAX_HOUSES], HousePickupInt[MAX_HOUSES];
#endif
#if GH_USE_MAPICONS == true
	new HouseMIcon[MAX_HOUSES];
#endif
#if GH_HOUSECARS == true
	new HCar[MAX_HOUSES];
#endif
enum Data
{
   HousePassword,
   HouseOwner[MAX_PLAYER_NAME],
   HouseName[MAX_HOUSE_NAME],
   HouseLocation[MAX_ZONE_NAME],
   Float:SpawnOutAngle,
   SpawnInterior,
   SpawnWorld,
   Float:CPOutX,
   Float:CPOutY,
   Float:CPOutZ,
   Float:SpawnOutX,
   Float:SpawnOutY,
   Float:SpawnOutZ,
   HouseValue,
   HouseStorage,
   HouseInterior,
   HouseCar,
   HouseCarModel,
   HouseCarWorld,
   HouseCarInterior,
   Float:HouseCarPosX,
   Float:HouseCarPosY,
   Float:HouseCarPosZ,
   Float:HouseCarAngle,
   QuitInHouse,
   Weapon[14],
   Ammo[14],
   ForSale,
   ForSalePrice,
   HousePrivacy,
   HouseAlarm,
   HouseCamera,
   HouseDog,
   UpgradedLock
}
enum hIntData
{
   IntName[30],
   Float:IntSpawnX,
   Float:IntSpawnY,
   Float:IntSpawnZ,
   Float:IntSpawnAngle,
   Float:IntCPX,
   Float:IntCPY,
   Float:IntCPZ,
   IntInterior,
   IntValue
}
new hInfo[MAX_HOUSES][Data], hIntInfo[MAX_HOUSE_INTERIORS][hIntData];
new CurrentID;
//==============================================================================
//                   Translation / SendClientMessage Messages
//==============================================================================
/*
	- Below you will find a list of messages.
	- You can translate these messages to whatever language you want.
	- When updating to a new version, simply replace the messages with the ones you translated.
	- But read the note where it says what version the messages below were added for.
 		- There might have been some more messages added after this version of GarHouse (v2.0),
		- so do not replace all of the messages without looking carefully if there is any new ones.
	- And be careful when editing messages containing placeholders (%s, %d, %i, etc),
		- if you change the position of these it will screw up eventually.
		- and do not remove or add any more placeholders if you do NOT know what you're doing.
	- Oh and one more thing, I did not translate the dialogs wich uses list items. You will have to do that yourself.
	
	
	Thanks,
	[03]Garsino.
*/
/*
						----------------------------------
						  VERSION 2.0 NOTES - IMPORTANT!
						----------------------------------
					     All messages needs to be replaced
*/
//##############################################################################
//                          Messages added in v2.0
//##############################################################################
#define E_NO_HOUSES_OWNED "{F6F6F6}You do not own any houses."
#define I_HMENU "{F6F6F6}Type /housemenu to access the house menu."
#define E_H_ALREADY_OWNED "{F6F6F6}This house is already owned by someone else."
#define E_INVALID_HPASS_LENGTH "{F6F6F6}Invalid house password length"
#define E_INVALID_HPASS "{F6F6F6}Invalid house password. You may not use this house password."
#define E_INVALID_HPASS_CHARS "{F6F6F6}Your house password contains illegal characters ({00BC00}percentage sign {F6F6F6}or {00BC00}~{F6F6F6})."
#define E_INVALID_HNAME_LENGTH "{F6F6F6}Invalid house name length."
#define E_INVALID_HNAME_CHARS "{F6F6F6}Your house name contains illegal characters ({00BC00}percentage sign {F6F6F6}or {00BC00}~{F6F6F6})."
#define I_HPASS_NO_CHANGE "{F6F6F6}Your house password remains the same."
#define I_HPASS_REMOVED "{F6F6F6}The house password for this house has been removed."
#define E_NOT_ENOUGH_PMONEY "{F6F6F6}You do not have that much money."
#define E_INVALID_AMOUNT "{F6F6F6}Invalid amount."
#define E_HSTORAGE_L_REACHED "{F6F6F6}You can not deposit this much money into your house storage. It can only hold up to {00BC00}$25,000,000{F6F6F6}."
#define E_NOT_ENOUGH_HSMONEY "{F6F6F6}You do not have that much money in your house storage."
#define E_NO_WEAPONS "{F6F6F6}You do not have any weapons to store."
#define E_NO_HS_WEAPONS "{F6F6F6}You do not have any weapons in your house storage."
#define E_INVALID_HPASS_CHARS2 "{F6F6F6}The entered house password contains illegal characters ({00BC00}percentage sign {F6F6F6}or {00BC00}~{F6F6F6})."
#define E_C_ACCESS_SE_HM "{F6F6F6}You can not access someone elses house menu."
#define E_NOT_IN_HOUSE "{F6F6F6}You need to be in a house to use this command."
#define E_NOT_HOWNER "{F6F6F6}You need to be the owner of a house to use this command."
#define E_HCAR_NOT_IN_VEH "{F6F6F6}You need to be in a vehicle to add a house car."
#define E_INVALID_HID "{F6F6F6}Invalid house ID. This house ID does not exist."
#define E_NO_HCAR "{F6F6F6}This house ID does not have a house car. Unable to delete."
#define E_H_A_F_SALE "{F6F6F6}This house is already for sale. You can not sell it."
#define E_ALREADY_HAVE_HINTERIOR "{F6F6F6}You already have this house interior."
#define E_HINT_WAIT_BEFORE_VISITING "{F6F6F6}Please wait before visiting a house interior again."
#define I_WRONG_HPASS1 "{F6F6F6}You have failed to enter {00BC00}%s's {F6F6F6}house using the password {00BC00}%s{F6F6F6}."
#define I_WRONG_HPASS2 "{00BC00}%s (%d) {F6F6F6}has attempted to enter your house using the password {00BC00}%s{F6F6F6}."
#define I_CORRECT_HPASS1 "{F6F6F6}You have successfully entered {00BC00}%s's {F6F6F6}house using the password {00BC00}%s{F6F6F6}."
#define I_CORRECT_HPASS2 "{00BC00}%s (%d) {F6F6F6}has successfully entered your house using the password {00BC00}%s{F6F6F6}!"
#define E_TOO_MANY_HOUSES "{F6F6F6}Sorry, but there are already {00BC00}%d {F6F6F6}houses created.\nDelete one of the current ones or increase the limit in the script."
#define I_H_CREATED "{F6F6F6}House ID {00BC00}%d {F6F6F6}created..."
#define I_HCAR_EXIST_ALREADY "{F6F6F6}House ID %d {F6F6F6}already have a house car. Overwriting current one."
#define I_HCAR_CREATED "{F6F6F6}House car for house ID {00BC00}%d {F6F6F6}created..."
#define I_H_DESTROYED "{F6F6F6}House ID {00BC00}%d {F6F6F6}destroyed..."
#define I_HCAR_REMOVED "{F6F6F6}House car for house ID {00BC00}%d {F6F6F6}removed..."
#define I_ALLH_DESTROYED "{F6F6F6}All houses removed. ({00BC00}%d {F6F6F6}in total)"
#define I_ALLHCAR_REMOVED "{F6F6F6}All house cars removed. ({00BC00}%d {F6F6F6}in total)"
#define I_HSPAWN_CHANGED "{F6F6F6}You have changed the spawnposition and angle for house ID {00BC00}%d{F6F6F6}."
#define I_TELEPORT_MSG "{F6F6F6}You have teleported to house ID {00BC00}%d{F6F6F6}."
#define I_H_SOLD "{F6F6F6}You have sold house ID {00BC00}%d{F6F6F6}..."
#define I_ALLH_SOLD "{F6F6F6}All houses on the server has been sold. ({00BC00}%d {F6F6F6}in total)"
#define I_H_PRICE_CHANGED "{F6F6F6}The value for house ID {00BC00}%d has been changed to {00BC00}$%d{F6F6F6}."
#define I_ALLH_PRICE_CHANGED "{F6F6F6}You have changed the value of all houses on the server to {00BC00}$%d. ({00BC00}%d {F6F6F6}in total)"
#define I_HINT_VISIT_OVER "{F6F6F6}Your visiting time is over.\nDo you want to buy the house interior {00BC00}%s {F6F6F6}for {00BC00}$%d{F6F6F6}?"
#define E_INVALID_HCAR_MODEL "{F6F6F6}Invalid car model. Accepted car models are between {00BC00}400 {F6F6F6}and {00BC00}612."
#define I_HCAR_CHANGED "{F6F6F6}Car model for house ID {00BC00}%d {F6F6F6}changed to {00BC00}%d."
#define HMENU_SELL_HOUSE2 "{F6F6F6}Type in how much you want to sell your house for below:"
#define HMENU_CANCEL_HOUSE_SALE "{F6F6F6}Your house is no longer for sale."
#define HMENU_HSALE_CANCEL "{F6F6F6}Click {00BC00}\"Remove\" {F6F6F6}to cancel the house sale for this house."
#define E_H_NOT_FOR_SALE "{F6F6F6}This house is not for sale."
#define E_INVALID_HSELL_AMOUNT "{F6F6F6}Invalid amount. The price you want to sell your house for can not be higher than {00BC00}$"#MAX_HOUSE_VALUE" {F6F6F6}or lower than {00BC00}$"#MIN_HOUSE_VALUE"{F6F6F6}."
#define I_H_SET_FOR_SALE "{F6F6F6}You have successfully set your house {00BC00}%s {F6F6F6}for sale for {00BC00}$%d{F6F6F6}."
#define HSELL_BUY_DIALOG "{00BC00}Current House Owner: {F6F6F6}%s\n{00BC00}Current House Name: {F6F6F6}%s\n\nAre You Sure You Want To Buy This House For {00BC00}$%d{F6F6F6}?"
#define HSELLER_CONNECTED_MSG1 "{F6F6F6}Your house {00BC00}%s {F6F6F6}has been sold to {00BC00}%s (%d){F6F6F6}.\n"
#define HSELLER_CONNECTED_MSG2 "{00BC00}You receive: {F6F6F6}$%d\n{00BC00}House Storage: {F6F6F6}$%d\n{00BC00}House Price: {F6F6F6}$%d"
#define HSELLER_OFFLINE_MSG1 "{F6F6F6}Your house {00BC00}%s {F6F6F6}has been sold to {00BC00}%s {F6F6F6}while you were offline.\n"
#define HSELLER_OFFLINE_MSG2 "{00BC00}You receive: {F6F6F6}$%d\n{00BC00}House Storage: {F6F6F6}$%d\n{00BC00}House Price: {F6F6F6}$%d"
#define E_NOT_HOUSECAR_OWNER "{F6F6F6}You can not drive this vehicle as it belongs to the owner of house ID {F6F6F6}%d which is {F6F6F6}%s."
#define I_HOUSECAR_OWNER "{F6F6F6}Welcome to your vehicle, {00BC00}%s{F6F6F6}! This vehicle belongs to your house (ID {00BC00}%d{F6F6F6}) so therefore only you can drive it."
#define I_TO_PLAYERS_HSOLD "{F6F6F6}This house has been sold.\nYou have been automaticly kicked out from the house."
#define E_INVALID_HINT "{F6F6F6}Invalid house interior. Accepted house interiors are between {00BC00}0 {F6F6F6}and {00BC00}"#MAX_HOUSE_INTERIORS"{F6F6F6}."
#define E_CMD_USAGE_CHANGEHINTSPAWN "Usage:{F6F6F6} /changehintspawn (house interior)"
#define E_CMD_USAGE_CREATEHINT "Usage:{F6F6F6} /createhint (value) (name)"
#define E_CMD_USAGE_REMOVEHINT "Usage:{F6F6F6} /removehint (house interior)"
#define E_CMD_USAGE_CREATEHOUSE "Usage:{F6F6F6} /createhouse (house value) (optional: house interior)"
#define E_CMD_USAGE_ADDHCAR "Usage:{F6F6F6} /addhcar (house id)"
#define E_CMD_USAGE_REMOVEHOUSE "Usage:{F6F6F6} /removehouse (houseid)"
#define E_CMD_USAGE_REMOVEHCAR "Usage:{F6F6F6} /removehcar (house id)"
#define E_CMD_USAGE_CHANGEHCAR "Usage:{F6F6F6} /changehcar (house id) (modelid: 400-612)"
#define E_CMD_USAGE_CHANGESPAWN "Usage:{F6F6F6} /changespawn (houseid)"
#define E_CMD_USAGE_GOTOHOUSE "Usage:{F6F6F6} /gotohouse (houseid)"
#define E_CMD_USAGE_SELLHOUSE "Usage:{F6F6F6} /sellhouse (houseid)"
#define E_CMD_USAGE_CHANGEPRICE "Usage:{F6F6F6} /changeprice (houseid) (price)"
#define E_CMD_USAGE_CHANGEALLPRICE "Usage:{F6F6F6} /changeallprices (price)"
#define E_INVALID_HINT_ID "{F6F6F6}Invalid house interior ID."
#define I_HINT_SPAWN_CHANGED "{F6F6F6}You have changed the spawn position and angel for house interior ID %d."
#define I_HINT_CREATED "{F6F6F6}House interior ID {00BC00}%d {F6F6F6}created...\n{00BC00}House Interior Value: {F6F6F6}$%d\n{00BC00}House Interior Name: {F6F6F6}%s"
#define E_TOO_MANY_HINTS "{F6F6F6}Sorry, but there are already {00BC00}%d {F6F6F6}house interiors created.\nDelete one of the current ones or increase the limit in the script."
#define E_INVALID_HINT_VALUE "{F6F6F6}Invalid house interior value. The value must be between {00BC00}$"#MIN_HINT_VALUE" {F6F6F6}and {00BC00}$"#MAX_HINT_VALUE"{F6F6F6}."
#define E_INVALID_HINT_LENGTH "{F6F6F6}Invalid house interior name length. The length must be between {00BC00}"#MIN_HINT_NAME" {F6F6F6}and {00BC00}"#MAX_HINT_NAME"{F6F6F6}."
#define I_HINT_DESTROYED "{F6F6F6}House interior ID {00BC00}%d {F6F6F6}has been deleted..."
#define E_NO_HOUSESTORAGE "{F6F6F6}The house storage feature has been disabled in this server. You can not use it."
#define I_HOWNER_HINFO_1 "{00BC00}House Name: {F6F6F6}%s\n{00BC00}House Location: {F6F6F6}%s\n{00BC00}Distance to house from you: {F6F6F6}%0.2f feet\n"
#define I_HOWNER_HINFO_2 "{00BC00}House Value: {F6F6F6}$%d\n{00BC00}House Storage: {F6F6F6}$%d\n{00BC00}House Privacy: {F6F6F6}%s\n{00BC00}House ID: {F6F6F6}%d"
#define HMENU_ENTER_PASS "{00BC00}House Name: {F6F6F6}%s\n{00BC00}House Owner: {F6F6F6}%s\n{00BC00}House Value: {F6F6F6}$%d\n{00BC00}House ID: {F6F6F6}%d\n\nEnter The Password For The House Below If You Wish To Enter:"
#define I_HINT_DEPOSIT1 "{F6F6F6}You have {00BC00}$%d {F6F6F6}in your house storage.\n\nType in the amount you want to deposit below:"
#define I_HINT_WITHDRAW1 "{F6F6F6}You have {00BC00}$%d {F6F6F6}in your house storage.\n\nType in the amount you want to withdraw below:"
#define I_HINT_DEPOSIT2 "{F6F6F6}You have successfully deposited {00BC00}$%d {F6F6F6}Into your house storage.\n{00BC00}Current Balance: {F6F6F6}$%d"
#define I_HINT_WITHDRAW2 "{F6F6F6}You have successfully withdrawn {00BC00}$%d {F6F6F6}From your house storage.\n{00BC00}Current Balance: {F6F6F6}$%d"
#define I_HINT_CHECKBALANCE "{F6F6F6}You have {00BC00}$%d {F6F6F6}in your house storage."
#define E_HINT_DOESNT_EXIST "{F6F6F6}Invalid house interior. This house interior does not exist."
#define HMENU_BUY_HOUSE "{F6F6F6}Do you want to buy this house for {00BC00}$%d{F6F6F6}?"
#define HMENU_BUY_HINTERIOR "{F6F6F6}Do you want to buy the house interior {00BC00}%s {F6F6F6}for {00BC00}$%d{F6F6F6}?"
#define HMENU_SELL_HOUSE "{F6F6F6}Are you sure you want to sell your house {00BC00}%s {F6F6F6}for {00BC00}$%d{F6F6F6}?"
#define I_SELL_HOUSE1_1 "{F6F6F6}You have successfully sold your house for {00BC00}$%d\n"
#define I_SELL_HOUSE1_2 "{00BC00}Selling Fee: {F6F6F6}$%d\nThe {00BC00}$%d {F6F6F6}in your house storage has been transfered to your pocket."
#define I_SELL_HOUSE2 "{F6F6F6}You have successfully sold your house {00BC00}%s {F6F6F6}for {00BC00}$%d.\n{00BC00}Selling Fee: {F6F6F6}$%d"
#define I_BUY_HOUSE "{F6F6F6}You have successfully bought this house for {00BC00}$%d{F6F6F6}!"
#define I_HPASSWORD_CHANGED "{F6F6F6}You have successfully set the house password to {00BC00}%s{F6F6F6}!"
#define I_HNAME_CHANGED "{F6F6F6}You have successfully set the house name to {00BC00}%s{F6F6F6}!"
#define I_VISITING_HOUSEINT "{F6F6F6}You're now visiting the house interior {00BC00}%s{F6F6F6}.\nThis house interior costs {00BC00}$%d{F6F6F6}.\nYour visit time will end in {00BC00}%d {F6F6F6}minute%s."
#define E_CANT_AFFORD_HINT1 "{F6F6F6}You can not afford to buy the house interior {00BC00}%s{F6F6F6}.\n{00BC00}House Interior Price: {F6F6F6}$%d\n"
#define E_CANT_AFFORD_HINT2 "{00BC00}You have: {F6F6F6}$%d\n{00BC00}You Need: {F6F6F6}$%d"
#define I_HINT_BOUGHT "{F6F6F6}You have bought the house interior {00BC00}%s {F6F6F6}for {00BC00}$%d."
#define I_HS_WEAPONS1 "{F6F6F6}You have successfully stored {00BC00}%d {F6F6F6}weapon%s in your house storage."
#define I_HS_WEAPONS2 "{F6F6F6}You have successfully received {00BC00}%d {F6F6F6}weapon%s from your house storage."
#define E_INVALID_HVALUE "{F6F6F6}Invalid house value. The house value must be between {00BC00}$"#MIN_HOUSE_VALUE" {F6F6F6}and {00BC00}$"#MAX_HOUSE_VALUE"{F6F6F6}."
#define I_HOPEN_FOR_VISITORS "{F6F6F6}You have successfully opened your house for visitors."
#define I_CLOSED_FOR_VISITORS1 "{F6F6F6}You have successfully closed your house for visitors.\n{00BC00}Total visitors kicked out: {F6F6F6}%d"
#define I_CLOSED_FOR_VISITORS2 "{00BC00}%s (%d) {F6F6F6}has closed their house for visitors. Automaticly exiting house..."
#define E_MAX_HOUSES_OWNED "{F6F6F6}You already own {00BC00}%d {F6F6F6}house%s. Sell one of your others before buying a new."
#define E_CANT_AFFORD_HOUSE "{F6F6F6}You can not afford to buy this house.\n{00BC00}House Value: {F6F6F6}$%d\n{00BC00}You Have: {F6F6F6}$%d\n{00BC00}You Need: {F6F6F6}$%d"
#define I_SUCCESSFULL_BREAKIN1_1 "{00BC00}%s (%d) {F6F6F6}has successfully broken into your house {00BC00}%s {F6F6F6}in {00BC00}%s{F6F6F6}."
#define I_SUCCESSFULL_BREAKIN1_2 "{F6F6F6}Someone has successfully broken into your house {00BC00}%s {F6F6F6}in {00BC00}%s{F6F6F6}."
#define I_SUCCESSFULL_BREAKIN2 "{F6F6F6}You have successfully broken into this house.\n{00BC00}House Name: {F6F6F6}%s\n{00BC00}House Owner: {F6F6F6}%s"
#define E_FAILED_BREAKIN1_1 "{00BC00}%s (%d) {F6F6F6}has failed to breakin to your house {00BC00}%s {F6F6F6}in {00BC00}%s{F6F6F6}."
#define E_FAILED_BREAKIN1_2 "{F6F6F6}Someone has failed to breakin to your house {00BC00}%s {F6F6F6}in {00BC00}%s{F6F6F6}."
#define E_FAILED_BREAKIN2 "{F6F6F6}You have failed to breakin to this house.\n{00BC00}House Name: {F6F6F6}%s\n{00BC00}House Owner: {F6F6F6}%s"
#define E_NO_HOUSE_BREAKIN "{F6F6F6}The breakin feature has been disabled in this server. You can not use it."
#define E_KICKED_NOT_IN_HOUSE "{F6F6F6}This player is not in your house."
#define I_KICKED_FROM_HOUSE1 "{F6F6F6}You have kicked out {00BC00}%s (%d) {F6F6F6}from your house."
#define I_KICKED_FROM_HOUSE2 "{F6F6F6}You have been kicked out from the house by {00BC00}%s (%d){F6F6F6}."
#define E_ALREADY_HAVE_HOUSEKEYS "{F6F6F6}You have already given the house keys for this house to this player."
#define I_HOUSEKEYS_RECIEVED_1 "{F6F6F6}You have given {00BC00}%s (%d) {F6F6F6}house keys to this house."
#define I_HOUSEKEYS_RECIEVED_2 "{F6F6F6}You have been given house keys to {00BC00}%s {F6F6F6}in {00BC00}%s {F6F6F6}by {00BC00}%s (%d){F6F6F6}."
#define E_DOESNT_HAVE_HOUSEKEYS "{F6F6F6}This player does not have the house keys for this house."
#define I_HOUSEKEYS_TAKEN_1 "{F6F6F6}You have taken away {00BC00}%s's (%d) {F6F6F6}house keys to this house."
#define I_HOUSEKEYS_TAKEN_2 "{00BC00}%s (%d) {F6F6F6}has taken away the house keys to his house {00BC00}%s {F6F6F6}in {00BC00}%s{F6F6F6}."
#define E_NONE_IN_HOUSE "{F6F6F6}There isn't anyone in your house."
#define E_CANT_ROB_OWN_HOUSE "{F6F6F6}You can not rob your own house."
#define E_ALREADY_HAVE_ALARM "{F6F6F6}You have already bought a house alarm for this house."
#define E_ALREADY_HAVE_CAMERA "{F6F6F6}You have already bought a security camera for this house."
#define E_ALREADY_HAVE_DOG "{F6F6F6}You have already bought a security dog for this house."
#define E_ALREADY_HAVE_UPGRADED_HLOCK "{F6F6F6}You have already bought a better doorlock for this house."
#define E_NOT_ENOUGH_MONEY_ALARM "{F6F6F6}You do not have enough money to buy a house alarm for your house."
#define E_NOT_ENOUGH_MONEY_CAMERA "{F6F6F6}You do not have enough money to buy a security camera for your house."
#define E_NOT_ENOUGH_MONEY_DOG "{F6F6F6}You do not have enough money to buy a security dog for your house."
#define E_NOT_ENOUGH_MONEY_UPGRADED_HLOCK "{F6F6F6}You do not have enough money to buy a better doorlock for your house."
#define I_HUPGRADE_ALARM "{F6F6F6}You have bought a alarm for your house.\nThis alarm will warn you when someone tries to or succeed in either robbing or breaking into your house.\n{00BC00}Note: {F6F6F6}It does not notify you of who it is."
#define I_HUPGRADE_CAMERA "{F6F6F6}You have bought a security camera for your house.\nThis security camera will warn you when someone tries to or succeed in either robbing or breaking into your house.\n{00BC00}Note: {F6F6F6}It does notify you of who it is."
#define I_HUPGRADE_DOG "{F6F6F6}You have bought a security dog for your house.\nThis security dog will try to kill anyone who tries to either rob or breakin to your house."
#define I_HUPGRADE_UPGRADED_HLOCK "{F6F6F6}You have bought upgraded the doorlock for your house.\nIt will now be harder to breakin to your house."
#define E_FAILED_HROB1_1 "{00BC00}%s (%d) {F6F6F6}has failed to rob your house {00BC00}%s {F6F6F6}in {00BC00}%s{F6F6F6}."
#define E_FAILED_HROB1_2 "{F6F6F6}Someone has failed to rob your house {00BC00}%s {F6F6F6}in {00BC00}%s{F6F6F6}."
#define I_HROB_STARTED1_1 "{F6F6F6}Someone is currently robbing your house %s {F6F6F6}in %s{F6F6F6}."
#define I_HROB_STARTED1_2 "{00BC00}%s (%d) {F6F6F6}is currently robbing your house %s {F6F6F6}in %s{F6F6F6}."
#define I_HROB_STARTED2 "{F6F6F6}You have started the robbery of {00BC00}%s's {F6F6F6}house {00BC00}%s {F6F6F6}in {00BC00}%s{F6F6F6}.\n\n{00BC00}Stay alive and do not leave the house until the robbery finishes!"
#define E_HROB_OWNER_NOT_CONNECTED "{F6F6F6}You can not rob this house since the owner of it is not connected."
#define I_HROB_FAILED_DEATH "{F6F6F6}You have died.\nThe attempt to rob the house {00BC00}%s {F6F6F6}has failed."
#define I_HROB_FAILED_HEXIT "{F6F6F6}You have left the house.\nThe attempt to rob the house {00BC00}%s {F6F6F6}has failed."
#define I_HROB_FAILED_NOT_IN_HOUSE "{F6F6F6}You are not in the house you were attempting to rob.\nThe attempt to rob the house {00BC00}%s {F6F6F6}has failed."
#define E_FAILED_HROB2 "{F6F6F6}House robbery failed."
#define I_HROB_COMPLETED1_1 "{F6F6F6}Your house {00BC00}%s {F6F6F6}in {00BC00}%s {F6F6F6}has been robbed for {00BC00}$%d{F6F6F6}."
#define I_HROB_COMPLETED1_2 "{00BC00}%s (%d) {F6F6F6}has robbed your house {00BC00}%s {F6F6F6}in {00BC00}%s {F6F6F6}for {00BC00}$%d{F6F6F6}."
#define I_HROB_COMPLETED2 "{F6F6F6}House robbery completed.\nYou got away with {00BC00}$%d {F6F6F6}from {00BC00}%s's {F6F6F6}house {00BC00}%s {F6F6F6}in {00BC00}%s{F6F6F6}."
#define HROB_FAILED1 "{F6F6F6}You have been bit to death by the security dog for this house.\nRobbery failed."
#define HBREAKIN_FAILED1 "{F6F6F6}You have been bit to death by the security dog for this house.\nHouse breakin failed."
#define E_WAIT_BEFORE_BREAKIN "{F6F6F6}Please wait before attempting to breakin to a house again."
#define E_WAIT_BEFORE_ROBBING "{F6F6F6}Please wait before attempting to rob a house again."
#define E_ALREADY_ROBBING_HOUSE "{F6F6F6}You are already robbing a house."
#define HROB_FAILED2 "{F6F6F6}House robbery failed.\nYou have been bit by the security dog for this house."
#define HBREAKIN_FAILED2 "{F6F6F6}House breakin failed.\nYou have been bit by the security dog for this house."
//==============================================================================
//                              Awesomeness
//==============================================================================
public OnFilterScriptInit()
{
    print("\n>> Attempting to load GarHouse v2.0... <<\n");
    INI_Load("/GarHouse/House.ini");
    LoadHouses(); // Load houses
    foreach(Player, i)
    {
        SetPVarInt(i, "HousePrevTime", 0);
        SetPVarInt(i, "TimeSinceHouseRobbery", 0);
    	SetPVarInt(i, "TimeSinceHouseBreakin", 0);
        SetPVarInt(i, "HouseRobberyTimer", -1);
    }
    print("\n>> GarHouse v2.0 By [03]Garsino Loaded <<\n");
    return 1;
}
public OnFilterScriptExit()
{
	new INI:file, lasthcp;
	foreach(Player, i)
	{
	    EndHouseRobbery(i);
	    SetPVarInt(i, "IsRobbingHouse", 0);
	    lasthcp = GetPVarInt(i, "LastHouseCP");
	    if(!strcmp(hInfo[lasthcp][HouseOwner], pNick(i), CASE_SENSETIVE) && IsInHouse{i} == 1 && fexist(HouseFile(lasthcp)))
		{
  			file = INI_Open(HouseFile(lasthcp));
	    	INI_WriteInt(file, "QuitInHouse", 1);
		    INI_Close(file);
		    #if GH_HOUSECARS == true
	    		SaveHouseCar(lasthcp);
        	#endif
		}
		ExitHouse(i, lasthcp);
		DeletePVars(i);
	}
    UnloadHouses(); // Unload houses (also unloads the house cars)
    print("\n>> GarHouse v2.0 By [03]Garsino Unloaded <<\n");
    return 1;
}
public OnPlayerDeath(playerid, killerid, reason)
{
	if(GetPVarInt(playerid, "IsRobbingHouse") == 1)
	{
	    ShowInfoBox(playerid, I_HROB_FAILED_DEATH, hInfo[GetPVarInt(playerid, "LastHouseCP")][HouseName]);
		EndHouseRobbery(playerid);
		SetPVarInt(playerid, "IsRobbingHouse", 0);
		SetPVarInt(playerid, "TimeSinceHouseRobbery", GetTickCount());
	}
	return 1;
}
public OnPlayerSpawn(playerid)
{
	if(GetPVarInt(playerid, "IsAnimsPreloaded") == 0)
	{
	    ApplyAnimation(playerid, "CRACK", "null", 0.0, 0, 0, 0, 0, 0);
    	SetPVarInt(playerid, "IsAnimsPreloaded", 1);
    }
    #if SPAWN_IN_HOUSE == true
    if(GetPVarInt(playerid, "FirstSpawn") == 0)
    {
		SetTimerEx("HouseSpawning", HSPAWN_TIMER_RATE, false, "i", playerid); // Increase timer rate if your gamemodes OnPlayerSpawn gets called after the timer has ended
    }
    #endif
	return 1;
}
#if GH_HOUSECARS == true
public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER)
	{
		foreach(Houses, h)
		{
	    	if(GetPlayerVehicleID(playerid) == HCar[h])
	    	{
	    	    switch(strcmp(hInfo[h][HouseOwner], pNick(playerid), CASE_SENSETIVE))
	    	    {
	    	        case 0: ShowInfoBox(playerid, I_HOUSECAR_OWNER, pNick(playerid), h);
	    	        case 1:
	    	        {
	    	            GetPlayerPos(playerid, X, Y, Z);
	    	            SetPlayerPos(playerid, (X + 3), Y, Z);
                  		ShowInfoBox(playerid, E_NOT_HOUSECAR_OWNER, h, hInfo[h][HouseOwner]);
	    	        }
	    	    }
	    	    break;
	    	}
	    }
	}
	return 1;
}
#endif
public OnPlayerConnect(playerid)
{
	new filename[HOUSEFILE_LENGTH], string1[MAX_PLAYER_NAME], string2[MAX_HOUSE_NAME], _tmpstring[256];
	format(filename, sizeof(filename), USERPATH, pNick(playerid));
	if(fexist(filename))
	{
	    new hs = GetPVarInt(playerid, "GA_TMP_HOUSESTORAGE"), price = GetPVarInt(playerid, "GA_TMP_HOUSEFORSALEPRICE");
	    INI_ParseFile(filename, "LoadUserData", false, true, playerid, true, false);
	    fremove(filename);
		GetPVarString(playerid, "GA_TMP_NEWHOUSEOWNER", string2, MAX_PLAYER_NAME);
		GetPVarString(playerid, "GA_TMP_HOUSENAME", string1, MAX_HOUSE_NAME);
		CMDSString = "";
		format(_tmpstring, sizeof(_tmpstring), HSELLER_OFFLINE_MSG1, string1, string2);
		strcat(CMDSString, _tmpstring);
		format(_tmpstring, sizeof(_tmpstring), HSELLER_OFFLINE_MSG2, (hs + price), hs, price);
		strcat(CMDSString, _tmpstring);
		ShowInfoBoxEx(playerid, COLOUR_INFO, CMDSString);
		DeletePVar(playerid, "GA_TMP_HOUSESTORAGE"), DeletePVar(playerid, "GA_TMP_HOUSEFORSALEPRICE"), DeletePVar(playerid, "GA_TMP_NEWHOUSEOWNER"), DeletePVar(playerid, "GA_TMP_HOUSENAME");
 	}
 	SetPVarInt(playerid, "HouseRobberyTimer", -1);
 	IsInHouse{playerid} = 0;
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	new year, month, day, lastvisited[20], lasthcp = GetPVarInt(playerid, "LastHouseCP");
	EndHouseRobbery(playerid);
    if(!strcmp(hInfo[lasthcp][HouseOwner], pNick(playerid), CASE_SENSETIVE) && IsInHouse{playerid} == 1 && fexist(HouseFile(lasthcp)))
	{
	    getdate(year, month, day);
	    format(lastvisited, sizeof(lastvisited), "%02d/%02d/%d", day, month, year);
	    new INI:file = INI_Open(HouseFile(lasthcp));
	    INI_WriteInt(file, "QuitInHouse", 1);
	    INI_WriteString(file, "LastVisited", lastvisited);
	    INI_Close(file);
	    #if GH_HOUSECARS == true
	    	SaveHouseCar(lasthcp);
	    	UnloadHouseCar(lasthcp);
        #endif
	}
	IsInHouse{playerid} = 0;
	return 1;
}
#if GH_USE_CPS == true
public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
	    new string[256], tmpstring[50];
	    foreach(Houses, h)
		{
		    if(checkpointid == HouseCPOut[h])
		    {
		        SetPVarInt(playerid, "LastHouseCP", h);
		        if(!strcmp(hInfo[h][HouseOwner], pNick(playerid), CASE_SENSETIVE))
		        {
		            SetPlayerHouseInterior(playerid, h);
		            ShowInfoBoxEx(playerid, COLOUR_INFO, I_HMENU);
		            break;
		        }
                format(tmpstring, sizeof(tmpstring), "HouseKeys_%d", h);
			    if(GetPVarInt(playerid, tmpstring) == 1)
			    {
			        SetPlayerHouseInterior(playerid, h);
			        break;
			    }
		        if(strcmp(hInfo[h][HouseOwner], pNick(playerid), CASE_SENSETIVE) && strcmp(hInfo[h][HouseOwner], INVALID_HOWNER_NAME, CASE_SENSETIVE))
		        {
		            if(hInfo[h][HousePassword] == udb_hash("INVALID_HOUSE_PASSWORD"))
					{
					    switch(hInfo[h][ForSale])
					    {
					        case 0: ShowInfoBox(playerid, LABELTEXT2, hInfo[h][HouseName], hInfo[h][HouseOwner], hInfo[h][HouseValue], h);
							case 1:
							{
							    switch(hInfo[h][HousePrivacy])
							    {
							        case 0: ShowPlayerDialog(playerid, HOUSEMENU+23, DIALOG_STYLE_LIST, INFORMATION_HEADER, "Buy House (Step 1)\nBreak In", "Select", "Cancel");
									case 1: ShowPlayerDialog(playerid, HOUSEMENU+23, DIALOG_STYLE_LIST, INFORMATION_HEADER, "Buy House (Step 1)\nBreak In\nEnter House", "Select", "Cancel");
								}
							}
						}
						break;
					}
					if(hInfo[h][HousePassword] != udb_hash("INVALID_HOUSE_PASSWORD"))
					{
					    switch(hInfo[h][ForSale])
					    {
					        case 0:
					        {
							    switch(hInfo[h][HousePrivacy])
							    {
							        case 0: ShowPlayerDialog(playerid, HOUSEMENU+28, DIALOG_STYLE_LIST, INFORMATION_HEADER, "Enter House Using Password\nBreak In", "Select", "Cancel");
									case 1: ShowPlayerDialog(playerid, HOUSEMENU+28, DIALOG_STYLE_LIST, INFORMATION_HEADER, "Enter House Using Password\nBreak In\nEnter House", "Select", "Cancel");
								}
							}
       						case 1: ShowPlayerDialog(playerid, HOUSEMENU+23, DIALOG_STYLE_LIST, INFORMATION_HEADER, "Buy House (Step 1)\nBreak In\nEnter House", "Select", "Cancel");
				   		}
				   		break;
					}
		        }
		        if(!strcmp(hInfo[h][HouseOwner], INVALID_HOWNER_NAME, CASE_SENSETIVE) && hInfo[h][HouseValue] > 0 && GetPVarInt(playerid, "JustCreatedHouse") == 0)
				{
					format(string, sizeof(string), HMENU_BUY_HOUSE, hInfo[h][HouseValue]);
					ShowPlayerDialog(playerid, HOUSEMENU+4, DIALOG_STYLE_MSGBOX, INFORMATION_HEADER, string, "Buy", "Cancel");
					break;
				}
		    }
		    if(checkpointid == HouseCPInt[h])
		    {
		        switch(GetPVarInt(playerid, "HousePreview"))
		        {
		            case 0: ExitHouse(playerid, h);
		            #if GH_HINTERIOR_UPGRADE == true
		            case 1:
			        {
						GetPVarString(playerid, "HousePrevName", tmpstring, 50);
						format(string, sizeof(string), HMENU_BUY_HINTERIOR, tmpstring, GetPVarInt(playerid, "HousePrevValue"));
						ShowPlayerDialog(playerid, HOUSEMENU+17, DIALOG_STYLE_MSGBOX, INFORMATION_HEADER, string, "Buy", "Cancel");
			        }
		            #endif
		        }
				break;
		    }
	    }
	}
	return 1;
}
public OnPlayerLeaveDynamicCP(playerid, checkpointid)
{
    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && GetPVarInt(playerid, "JustCreatedHouse") == 1)
	{
	    foreach(Houses, h)
		{
		    if(checkpointid == HouseCPOut[h])
		    {
		        DeletePVar(playerid, "JustCreatedHouse");
		        break;
		    }
	    }
	}
	return 1;
}
#else
public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
	    new string[256], tmpstring[50];
	    foreach(Houses, h)
		{
		    if(pickupid == HousePickupOut[h])
		    {
		        SetPVarInt(playerid, "LastHouseCP", h);
		        if(!strcmp(hInfo[h][HouseOwner], pNick(playerid), CASE_SENSETIVE))
		        {
		            SetPlayerHouseInterior(playerid, h);
		            ShowInfoBoxEx(playerid, COLOUR_INFO, I_HMENU);
		            break;
		        }
                format(tmpstring, sizeof(tmpstring), "HouseKeys_%d", h);
			    if(GetPVarInt(playerid, tmpstring) == 1)
			    {
			        SetPlayerHouseInterior(playerid, h);
			        break;
			    }
		        if(strcmp(hInfo[h][HouseOwner], pNick(playerid), CASE_SENSETIVE) && strcmp(hInfo[h][HouseOwner], INVALID_HOWNER_NAME, CASE_SENSETIVE))
		        {
		            if(hInfo[h][HousePassword] == udb_hash("INVALID_HOUSE_PASSWORD"))
					{
					    switch(hInfo[h][ForSale])
					    {
					        case 0: ShowInfoBox(playerid, LABELTEXT2, hInfo[h][HouseName], hInfo[h][HouseOwner], hInfo[h][HouseValue], h);
							case 1:
							{
							    switch(hInfo[h][HousePrivacy])
							    {
							        case 0: ShowPlayerDialog(playerid, HOUSEMENU+23, DIALOG_STYLE_LIST, INFORMATION_HEADER, "Buy House (Step 1)\nBreak In", "Select", "Cancel");
									case 1: ShowPlayerDialog(playerid, HOUSEMENU+23, DIALOG_STYLE_LIST, INFORMATION_HEADER, "Buy House (Step 1)\nBreak In\nEnter House", "Select", "Cancel");
								}
							}
						}
						break;
					}
					if(hInfo[h][HousePassword] != udb_hash("INVALID_HOUSE_PASSWORD"))
					{
					    switch(hInfo[h][ForSale])
					    {
					        case 0:
					        {
							    switch(hInfo[h][HousePrivacy])
							    {
							        case 0: ShowPlayerDialog(playerid, HOUSEMENU+28, DIALOG_STYLE_LIST, INFORMATION_HEADER, "Enter House Using Password\nBreak In", "Select", "Cancel");
									case 1: ShowPlayerDialog(playerid, HOUSEMENU+28, DIALOG_STYLE_LIST, INFORMATION_HEADER, "Enter House Using Password\nBreak In\nEnter House", "Select", "Cancel");
								}
							}
       						case 1: ShowPlayerDialog(playerid, HOUSEMENU+23, DIALOG_STYLE_LIST, INFORMATION_HEADER, "Buy House (Step 1)\nBreak In\nEnter House", "Select", "Cancel");
				   		}
				   		break;
					}
		        }
		        if(!strcmp(hInfo[h][HouseOwner], INVALID_HOWNER_NAME, CASE_SENSETIVE) && hInfo[h][HouseValue] > 0 && GetPVarInt(playerid, "JustCreatedHouse") == 0)
				{
					format(string, sizeof(string), HMENU_BUY_HOUSE, hInfo[h][HouseValue]);
					ShowPlayerDialog(playerid, HOUSEMENU+4, DIALOG_STYLE_MSGBOX, INFORMATION_HEADER, string, "Buy", "Cancel");
					break;
				}
		    }
		    if(pickupid == HousePickupInt[h])
		    {
		        switch(GetPVarInt(playerid, "HousePreview"))
		        {
		            case 0: ExitHouse(playerid, h);
		            #if GH_HINTERIOR_UPGRADE == true
		            case 1:
			        {
						GetPVarString(playerid, "HousePrevName", tmpstring, 50);
						format(string, sizeof(string), HMENU_BUY_HINTERIOR, tmpstring, GetPVarInt(playerid, "HousePrevValue"));
						ShowPlayerDialog(playerid, HOUSEMENU+17, DIALOG_STYLE_MSGBOX, INFORMATION_HEADER, string, "Buy", "Cancel");
			        }
		            #endif
		        }
				break;
		    }
	    }
	}
	return 1;
}
#endif
stock Float:DistanceToPoint(Float:X1, Float:Y1, Float:Z1, Float:X2, Float:Y2, Float:Z2) return Float:floatsqroot(((X2 - X1) * (X2 - X1)) + ((Y2 - Y1) * (Y2 - Y1)) + ((Z2 - Z1) * (Z2 - Z1)));
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	new string[400], _tmpstring[256], INI:file, filename[HOUSEFILE_LENGTH], h = GetPVarInt(playerid, "LastHouseCP"), amount = floatround(strval(inputtext));
    format(filename, sizeof(filename), FILEPATH, h);
	if(dialogid == HOUSEMENU && response)
	{
	    switch(listitem)
		{
		    case 0: ShowPlayerDialog(playerid, HOUSEMENU+19, DIALOG_STYLE_LIST, INFORMATION_HEADER, "Set House For Sale\nCancel Active House Sale\nSell House", "Select", "Cancel");
		    case 1:
			{
				#if GH_USE_HOUSESTORAGE == false
					ShowInfoBoxEx(playerid, COLOUR_INFO, E_NO_HOUSESTORAGE);
				#else
					#if GH_USE_WEAPONSTORAGE == true
						ShowPlayerDialog(playerid, HOUSEMENU+18, DIALOG_STYLE_LIST, INFORMATION_HEADER, "Money Storage\nWeapon Storage", "Select", "Cancel");
					#else
						ShowPlayerDialog(playerid, HOUSEMENU+10, DIALOG_STYLE_LIST, INFORMATION_HEADER, "Deposit Money\nWithdraw Money\nCheck Balance", "Select", "Cancel");
					#endif
				#endif
			}
			case 2: ShowPlayerDialog(playerid, HOUSEMENU+14, DIALOG_STYLE_INPUT, INFORMATION_HEADER, "Type In The New House Name Below:\n\nPress 'Cancel' To Cancel", "Done", "Cancel");
		    case 3: ShowPlayerDialog(playerid, HOUSEMENU+13, DIALOG_STYLE_INPUT, INFORMATION_HEADER, "Type In The New House Password Below:\nLeave The Box Empty If You Want To Keep Your Current House Password.\nPress 'Remove' To Remove The House Password.", "Done", "Remove");
			case 4:
		 	{
				#if GH_HINTERIOR_UPGRADE == true
		 			ShowPlayerDialog(playerid, HOUSEMENU+16, DIALOG_STYLE_LIST, INFORMATION_HEADER, "Preview House Interior\nBuy House Interior", "Select", "Cancel");
				#else
                	ShowPlayerDialog(playerid, HOUSEMENU+24, DIALOG_STYLE_LIST, INFORMATION_HEADER, "Open House For Visitors\nClose House For Visitors", "Select", "Cancel");
				#endif
			}
			case 5:
			{
			    #if GH_HINTERIOR_UPGRADE == true
					ShowPlayerDialog(playerid, HOUSEMENU+24, DIALOG_STYLE_LIST, INFORMATION_HEADER, "Open House For Visitors\nClose House For Visitors", "Select", "Cancel");
				#else
				new tmpcount = 1, total = (CountPlayersInHouse(h) - 1);
				if(CountPlayersInHouse(h) == 0) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_NONE_IN_HOUSE);
				CMDSString = "";
				foreach(Player, i)
				{
				    if(!IsPlayerInHouse(i, h)) continue;
				    if(playerid == i) continue;
					if(tmpcount == total)
					{
					    format(_tmpstring, sizeof(_tmpstring), "{00BC00}%d.\t{FFFF2A}%s in %s", tmpcount, pNick(i), i);
					}
					else format(_tmpstring, sizeof(_tmpstring), "{00BC00}%d.\t{FFFF2A}%s (%d)\n", tmpcount, pNick(i), i);
					strcat(CMDSString, _tmpstring);
					tmpcount++;
				}
				ShowPlayerDialog(playerid, HOUSEMENU+25, DIALOG_STYLE_LIST, INFORMATION_HEADER, CMDSString, "Select", "Cancel");
				#endif
			}
			case 6:
			{
			    #if GH_HINTERIOR_UPGRADE == true
				new tmpcount = 1, total = (CountPlayersInHouse(h) - 1);
				if(CountPlayersInHouse(h) == 0) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_NONE_IN_HOUSE);
				CMDSString = "";
				foreach(Player, i)
				{
				    if(!IsPlayerInHouse(i, h)) continue;
				    if(playerid == i) continue;
					if(tmpcount == total)
					{
					    format(_tmpstring, sizeof(_tmpstring), "{00BC00}%d.\t{FFFF2A}%s in %s", tmpcount, pNick(i), i);
					}
					else format(_tmpstring, sizeof(_tmpstring), "{00BC00}%d.\t{FFFF2A}%s (%d)\n", tmpcount, pNick(i), i);
					strcat(CMDSString, _tmpstring);
					tmpcount++;
				}
				ShowPlayerDialog(playerid, HOUSEMENU+25, DIALOG_STYLE_LIST, INFORMATION_HEADER, CMDSString, "Select", "Cancel");
				#else
                	ShowPlayerDialog(playerid, HOUSEMENU+27, DIALOG_STYLE_LIST, INFORMATION_HEADER, "Buy House Alarm\t\t$"#HUPGRADE_ALARM"\nBuy Security Camera\t\t$"#HUPGRADE_CAMERA"\nBuy House Security Dog\t$"#HUPGRADE_DOG"\nBuy Better Houselock\t\t$"#HUPGRADE_UPGRADED_HLOCK"", "Select", "Cancel");
				#endif
			}
			case 7: ShowPlayerDialog(playerid, HOUSEMENU+27, DIALOG_STYLE_LIST, INFORMATION_HEADER, "Buy House Alarm\t\t$"#HUPGRADE_ALARM"\nBuy Security Camera\t\t$"#HUPGRADE_CAMERA"\nBuy House Security Dog\t$"#HUPGRADE_DOG"\nBuy Better Houselock\t\t$"#HUPGRADE_UPGRADED_HLOCK"", "Select", "Cancel");
		}
		return 1;
	}
//------------------------------------------------------------------------------
//                               House Sale
//------------------------------------------------------------------------------
	if(dialogid == HOUSEMENU+3 && response)
	{
		if(GetOwnedHouses(playerid) == 0) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_NO_HOUSES_OWNED);
		else
		{
		    new procent = ReturnProcent(hInfo[h][HouseValue], HOUSE_SELLING_PROCENT);
			GivePlayerMoney(playerid, procent);
			if(hInfo[h][HouseStorage] >= 1)
			{
			    CMDSString = "";
				format(_tmpstring, sizeof(_tmpstring), I_SELL_HOUSE1_1, procent);
				strcat(CMDSString, _tmpstring);
				format(_tmpstring, sizeof(_tmpstring), I_SELL_HOUSE1_2, (hInfo[h][HouseValue] - procent), hInfo[h][HouseStorage]);
				strcat(CMDSString, _tmpstring);
   				ShowInfoBoxEx(playerid, COLOUR_INFO, CMDSString);
				GivePlayerMoney(playerid, hInfo[h][HouseStorage]);
			}
			if(hInfo[h][HouseStorage] == 0)
			{
			    ShowInfoBox(playerid, I_SELL_HOUSE2, hInfo[h][HouseName], procent, (hInfo[h][HouseValue] - procent));
			}
			format(hInfo[h][HouseName], MAX_HOUSE_NAME, "%s", DEFAULT_HOUSE_NAME);
   			format(hInfo[h][HouseOwner], MAX_PLAYER_NAME, "%s", INVALID_HOWNER_NAME);
		    hInfo[h][HousePassword] = udb_hash("INVALID_HOUSE_PASSWORD");
		    hInfo[h][HouseStorage] = hInfo[h][HouseAlarm] = hInfo[h][HouseDog] = hInfo[h][HouseCamera] = hInfo[h][UpgradedLock] = 0;
		    hInfo[h][HouseValue] = ReturnProcent(hInfo[h][HouseValue], HOUSE_SELLING_PROCENT);
			file = INI_Open(filename);
			INI_WriteInt(file, "HouseValue", hInfo[h][HouseValue]);
			INI_WriteString(file, "HouseOwner", INVALID_HOWNER_NAME);
			INI_WriteInt(file, "HousePassword", hInfo[h][HousePassword]);
			INI_WriteString(file, "HouseName", DEFAULT_HOUSE_NAME);
			INI_WriteInt(file, "HouseStorage", 0);
			INI_Close(file);
			foreach(Houses, h2)
			{
				if(IsHouseInRangeOfHouse(h, h2, RANGE_BETWEEN_HOUSES) && h2 != h)
				{
			   		hInfo[h2][HouseValue] = (hInfo[h2][HouseValue] - ReturnProcent(hInfo[h2][HouseValue], HOUSE_SELLING_PROCENT2));
			   		file = INI_Open(HouseFile(h2));
					INI_WriteInt(file, "HouseValue", hInfo[h2][HouseValue]);
					INI_Close(file);
                    UpdateHouseText(h2);
				}
			}
			foreach(Player, i)
			{
			    if(IsPlayerInHouse(i, h))
			    {
			        ExitHouse(i, h);
					ShowInfoBoxEx(i, COLOUR_INFO, I_TO_PLAYERS_HSOLD);
			    }
			}
			#if GH_USE_MAPICONS == true
				DestroyDynamicMapIcon(HouseMIcon[h]);
				HouseMIcon[h] = CreateDynamicMapIcon(hInfo[h][CPOutX], hInfo[h][CPOutY], hInfo[h][CPOutZ], 31, -1, hInfo[h][SpawnWorld], hInfo[h][SpawnInterior], -1, MICON_VD);
			#endif
			UpdateHouseText(h);
		}
		return 1;
	}
//------------------------------------------------------------------------------
//                               House Buying
//------------------------------------------------------------------------------
	if(dialogid == HOUSEMENU+4)
	{
		if(response)
		{
		    new hname[MAX_PLAYER_NAME+9];
			if(GetOwnedHouses(playerid) >= MAX_HOUSES_OWNED) { ShowInfoBox(playerid, E_MAX_HOUSES_OWNED, MAX_HOUSES_OWNED, AddS(MAX_HOUSES_OWNED)); return 1; }
			if(strcmp(hInfo[h][HouseOwner], pNick(playerid), CASE_SENSETIVE) && strcmp(hInfo[h][HouseOwner], INVALID_HOWNER_NAME, CASE_SENSETIVE)) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_H_ALREADY_OWNED);
			if(hInfo[h][HouseValue] > GetPlayerMoney(playerid)) { ShowInfoBox(playerid, E_CANT_AFFORD_HOUSE, hInfo[h][HouseValue], GetPlayerMoney(playerid), (hInfo[h][HouseValue] - GetPlayerMoney(playerid))); return 1; }
			else
			{
			    format(hname, sizeof(hname), "%s's House", pNick(playerid));
			    format(hInfo[h][HouseName], sizeof(hname), "%s", hname);
			    format(hInfo[h][HouseOwner], MAX_PLAYER_NAME, "%s", pNick(playerid));
			    hInfo[h][HousePassword] = udb_hash("INVALID_HOUSE_PASSWORD");
			    hInfo[h][HouseStorage] = 0;
				GivePlayerMoney(playerid, -hInfo[h][HouseValue]);
				file = INI_Open(filename);
				INI_WriteString(file, "HouseOwner", pNick(playerid));
				INI_WriteInt(file, "HousePassword", hInfo[h][HousePassword]);
				INI_WriteString(file, "HouseName", hname);
				INI_WriteInt(file, "HouseStorage", 0);
				INI_Close(file);
				ShowInfoBox(playerid, I_BUY_HOUSE, hInfo[h][HouseValue]);
				foreach(Houses, h2)
				{
					if(IsHouseInRangeOfHouse(h, h2, RANGE_BETWEEN_HOUSES) && h2 != h)
					{
					    file = INI_Open(HouseFile(h2));
						INI_WriteInt(file, "HouseValue", (hInfo[h2][HouseValue] + ReturnProcent(hInfo[h2][HouseValue], HOUSE_SELLING_PROCENT2)));
                        UpdateHouseText(h2);
                        INI_Close(file);
					}
				}
				#if GH_USE_MAPICONS == true
					DestroyDynamicMapIcon(HouseMIcon[h]);
					HouseMIcon[h] = CreateDynamicMapIcon(hInfo[h][CPOutX], hInfo[h][CPOutY], hInfo[h][CPOutZ], 32, -1, hInfo[h][SpawnWorld], hInfo[h][SpawnInterior], -1, MICON_VD);
				#endif
				UpdateHouseText(h);
			}
		}
		return 1;
	}
//------------------------------------------------------------------------------
//                               House Password
//------------------------------------------------------------------------------
	if(dialogid == HOUSEMENU+13)
	{
		if(response)
		{
			if(strlen(inputtext) > MAX_HOUSE_PASSWORD || (strlen(inputtext) < MIN_HOUSE_PASSWORD && strlen(inputtext) >= 1)) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_HPASS_LENGTH);
			if(!strcmp(inputtext, "INVALID_HOUSE_PASSWORD", CASE_SENSETIVE)) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_HPASS);
			if(strfind(inputtext, "%", CASE_SENSETIVE) != -1 || strfind(inputtext, "~", CASE_SENSETIVE) != -1) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_HPASS_CHARS);
			else
			{
			    if(strlen(inputtext) >= 1)
			    {
			        hInfo[h][HousePassword] = udb_hash(inputtext);
			        file = INI_Open(filename);
					INI_WriteInt(file, "HousePassword", hInfo[h][HousePassword]);
					INI_Close(file);
					ShowInfoBox(playerid, I_HPASSWORD_CHANGED, inputtext);
				}
				else ShowInfoBoxEx(playerid, COLOUR_INFO, I_HPASS_NO_CHANGE);
			}
		}
		if(!response)
		{
		    file = INI_Open(filename);
		    INI_WriteInt(file, "HousePassword", udb_hash("INVALID_HOUSE_PASSWORD"));
		    INI_Close(file);
			ShowInfoBoxEx(playerid, COLOUR_INFO, I_HPASS_REMOVED);
		}
		return 1;
	}
//------------------------------------------------------------------------------
//                               House Name
//------------------------------------------------------------------------------
	if(dialogid == HOUSEMENU+14)
	{
		if(response)
		{
		    if(strfind(inputtext, "%", CASE_SENSETIVE) != -1 || strfind(inputtext, "~", CASE_SENSETIVE) != -1) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_HNAME_CHARS);
			if(strlen(inputtext) < MIN_HOUSE_NAME || strlen(inputtext) > MAX_HOUSE_NAME) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_HNAME_LENGTH);
			else
			{
			    format(hInfo[h][HouseName], MAX_HOUSE_NAME, "%s", inputtext);
			    file = INI_Open(filename);
				INI_WriteString(file, "HouseName", inputtext);
				INI_Close(file);
				ShowInfoBox(playerid, I_HNAME_CHANGED, inputtext);
                UpdateHouseText(h);
			}
		}
		return 1;
	}
//------------------------------------------------------------------------------
//                       House Interior Upgrade
//------------------------------------------------------------------------------
	if(dialogid == HOUSEMENU+15 && response)
	{
	    new _int = hInfo[h][HouseInterior];
	    SetPVarInt(playerid, "OldHouseInt", _int);
	    Loop(hint, MAX_HOUSE_INTERIORS, 0)
		{
		    if(hint == listitem)
		    {
		        SetPVarInt(playerid, "HousePrevInt", hint), SetPVarInt(playerid, "HousePrevValue", hIntInfo[hint][IntValue]), SetPVarString(playerid, "HousePrevName", hIntInfo[hint][IntName]);
		    }
		}
		if(_int == GetPVarInt(playerid, "HousePrevInt")) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_ALREADY_HAVE_HINTERIOR);
		else
		{
		    new hprevvalue = GetPVarInt(playerid, "HousePrevValue");
		    GetPVarString(playerid, "HousePrevName", string, 50);
//------------------------------------------------------------------------------
		    switch(GetPVarInt(playerid, "HouseIntUpgradeMod"))
		    {
				case 1:
				{
				    if(GetSecondsBetweenAction(GetPVarInt(playerid, "HousePrevTime")) < (TIME_BETWEEN_VISITS * 60000) && GetPVarInt(playerid, "HousePrevTime") != 0) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_HINT_WAIT_BEFORE_VISITING);
				    SetPVarInt(playerid, "IsHouseVisiting", 1);
					SetPVarInt(playerid, "HousePreview", 1);
					SetPVarInt(playerid, "ChangeHouseInt", 1);
					SetPVarInt(playerid, "HousePrevTime", GetTickCount());
					SetPVarInt(playerid, "HousePrevTimer", SetTimerEx("HouseVisiting", (MAX_VISIT_TIME * 60000), false, "i", playerid));
					ShowInfoBox(playerid, I_VISITING_HOUSEINT, string, hprevvalue, MAX_VISIT_TIME, AddS(MAX_VISIT_TIME));

				}
				case 2:
				{
					if(hprevvalue > GetPlayerMoney(playerid))
					{
					    CMDSString = "";
						format(_tmpstring, sizeof(_tmpstring), E_CANT_AFFORD_HINT1, string, hprevvalue);
						strcat(CMDSString, _tmpstring);
						format(_tmpstring, sizeof(_tmpstring), E_CANT_AFFORD_HINT2, GetPlayerMoney(playerid), (hprevvalue - GetPlayerMoney(playerid)));
						strcat(CMDSString, _tmpstring);
						ShowInfoBoxEx(playerid, COLOUR_INFO, CMDSString);
					}
					if(hprevvalue <= GetPlayerMoney(playerid))
					{
					    GivePlayerMoney(playerid, -hprevvalue);
					    SetPVarInt(playerid, "ChangeHouseInt", 1);
    	    			file = INI_Open(filename);
					    INI_Close(file);
						ShowInfoBox(playerid, I_HINT_BOUGHT, string, hprevvalue);
					}
				}
			}
//------------------------------------------------------------------------------
			if(GetPVarInt(playerid, "ChangeHouseInt") == 1)
		    {
		        hInfo[h][HouseInterior] = GetPVarInt(playerid, "HousePrevInt");
 	    		file = INI_Open(filename);
			    INI_WriteInt(file, "HouseInterior", hInfo[h][HouseInterior]);
			    INI_Close(file);
			    DestroyHouseEntrance(h, TYPE_INT);
				CreateCorrectHouseExitCP(h);
				foreach(Player, i)
		  		{
		  		    if(GetPVarInt(i, "LastHouseCP") == h && IsInHouse{i} == 1)
		  		    {
		  				SetPlayerHouseInterior(i, h);
		  			}
		  		}
		  		DeletePVar(playerid, "ChangeHouseInt");
	  		}
//------------------------------------------------------------------------------
		}
		return 1;
	}
//------------------------------------------------------------------------------
//                       House Interior Mode Selecting
//------------------------------------------------------------------------------
    #if GH_HINTERIOR_UPGRADE == true
	if(dialogid == HOUSEMENU+16 && response)
	{
	    switch(listitem)
	    {
	        case 0: SetPVarInt(playerid, "HouseIntUpgradeMod", 1);
	        case 1: SetPVarInt(playerid, "HouseIntUpgradeMod", 2);
	    }
	    CMDSString = "";
	    Loop(i, MAX_HOUSE_INTERIORS, 0)
	    {
	        format(filename, sizeof(filename), HINT_FILEPATH, i);
	        if(!fexist(filename)) continue;
			if(i == (MAX_HOUSE_INTERIORS-1))
			{
			    switch(strlen(hIntInfo[i][IntName]))
			    {
					case 0..13: format(_tmpstring, sizeof(_tmpstring), "{00BC00}%d.\t{FFFF2A}%s\t\t\t{00BC00}$%d", (i + 1), hIntInfo[i][IntName], hIntInfo[i][IntValue]);
					default: format(_tmpstring, sizeof(_tmpstring), "{00BC00}%d.\t{FFFF2A}%s\t\t{00BC00}$%d", (i + 1), hIntInfo[i][IntName], hIntInfo[i][IntValue]);
				}
			}
			else
			{
			    switch(strlen(hIntInfo[i][IntName]))
			    {
					case 0..13: format(_tmpstring, sizeof(_tmpstring), "{00BC00}%d.\t{FFFF2A}%s\t\t\t{00BC00}$%d\n", (i + 1), hIntInfo[i][IntName], hIntInfo[i][IntValue]);
					default: format(_tmpstring, sizeof(_tmpstring), "{00BC00}%d.\t{FFFF2A}%s\t\t{00BC00}$%d\n", (i + 1), hIntInfo[i][IntName], hIntInfo[i][IntValue]);
				}
			}
			strcat(CMDSString, _tmpstring);
	    }
		ShowPlayerDialog(playerid, HOUSEMENU+15, DIALOG_STYLE_LIST, INFORMATION_HEADER, CMDSString, "Buy", "Cancel");
		return 1;
	}
	#endif
//------------------------------------------------------------------------------
//                       House Interior Upgrade
//------------------------------------------------------------------------------
    #if GH_HINTERIOR_UPGRADE == true
	if(dialogid == HOUSEMENU+17)
	{
	    KillTimer(GetPVarInt(playerid, "HousePrevTimer"));
	    DeletePVar(playerid, "IsHouseVisiting"), DeletePVar(playerid, "HousePrevTimer");
	    file = INI_Open(filename);
	    switch(response)
	    {
	        case 0:
			{
			    hInfo[h][HouseInterior] = GetPVarInt(playerid, "OldHouseInt");
			    INI_WriteInt(file, "HouseInterior", hInfo[h][HouseInterior]);
			}
	        case 1:
	        {
	            new hprevvalue = GetPVarInt(playerid, "HousePrevValue");
	            GetPVarString(playerid, "HousePrevName", string, 50);
	            if(GetPlayerMoney(playerid) < GetPVarInt(playerid, "HousePrevValue"))
	            {
	                hInfo[h][HouseInterior] = GetPVarInt(playerid, "OldHouseInt");
	                INI_WriteInt(file, "HouseInterior", hInfo[h][HouseInterior]);
	                CMDSString = "";
					format(_tmpstring, sizeof(_tmpstring), E_CANT_AFFORD_HINT1, string, hprevvalue);
					strcat(CMDSString, _tmpstring);
					format(_tmpstring, sizeof(_tmpstring), E_CANT_AFFORD_HINT2, GetPlayerMoney(playerid), (hprevvalue - GetPlayerMoney(playerid)));
					strcat(CMDSString, _tmpstring);
					ShowInfoBoxEx(playerid, COLOUR_INFO, CMDSString);
				}
				else
				{
	            	GivePlayerMoney(playerid, -hprevvalue);
	            	hInfo[h][HouseInterior] = GetPVarInt(playerid, "HousePrevInt");
	            	INI_WriteString(file, "HouseInteriorName", string);
			    	INI_WriteInt(file, "HouseInterior", hInfo[h][HouseInterior]);
			    	INI_WriteInt(file, "HouseInteriorValue", hprevvalue);
	            	ShowInfoBox(playerid, I_HINT_BOUGHT, string, hprevvalue);
				}
			}
	    }
	    INI_Close(file);
//------------------------------------------------------------------------------
  		DestroyHouseEntrance(h, TYPE_INT);
		CreateCorrectHouseExitCP(h);
		foreach(Player, i)
		{
  			if(GetPVarInt(i, "LastHouseCP") == h && IsInHouse{i} == 1)
  			{
				SetPlayerHouseInterior(i, h);
			}
		}
		SetPVarInt(playerid, "HousePreview", 0);
//------------------------------------------------------------------------------
		return 1;
	}
	#endif
//------------------------------------------------------------------------------
//                               Money Storage
//------------------------------------------------------------------------------
	if(dialogid == HOUSEMENU+10 && response)
	{
    	if(listitem == 0) // Deposit
	   	{
     		format(string, sizeof(string), I_HINT_DEPOSIT1, hInfo[h][HouseStorage]);
  			ShowPlayerDialog(playerid, HOUSEMENU+11, DIALOG_STYLE_INPUT, INFORMATION_HEADER, string, "Deposit", "Cancel");
	    }
	    if(listitem == 1) // Withdraw
	    {
     		format(string, sizeof(string), I_HINT_WITHDRAW1, hInfo[h][HouseStorage]);
       		ShowPlayerDialog(playerid, HOUSEMENU+12, DIALOG_STYLE_INPUT, INFORMATION_HEADER, string, "Withdraw", "Cancel");
    	}
	    if(listitem == 2) // Check Balance
	    {
     		ShowInfoBox(playerid, I_HINT_CHECKBALANCE, hInfo[h][HouseStorage]);
		}
		return 1;
	}
//------------------------------------------------------------------------------
	if(dialogid == HOUSEMENU+11 && response)
	{
		if(amount > GetPlayerMoney(playerid)) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_NOT_ENOUGH_PMONEY);
		if(amount < 1) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_AMOUNT);
		if((hInfo[h][HouseStorage] + amount) >= 25000000) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_HSTORAGE_L_REACHED);
		else
		{
		    hInfo[h][HouseStorage] = (hInfo[h][HouseStorage] + amount);
		    file = INI_Open(filename);
			INI_WriteInt(file, "HouseStorage", hInfo[h][HouseStorage]);
			INI_Close(file);
			GivePlayerMoney(playerid, -amount);
			ShowInfoBox(playerid, I_HINT_DEPOSIT2, amount, hInfo[h][HouseStorage]);
		}
		return 1;
	}
//------------------------------------------------------------------------------
	if(dialogid == HOUSEMENU+12 && response)
	{
		if(amount > hInfo[h][HouseStorage]) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_NOT_ENOUGH_HSMONEY);
		if(amount < 1) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_AMOUNT);
		else
		{
		    hInfo[h][HouseStorage] = (hInfo[h][HouseStorage] - amount);
		    file = INI_Open(filename);
			INI_WriteInt(file, "HouseStorage", hInfo[h][HouseStorage]);
			INI_Close(file);
			GivePlayerMoney(playerid, amount);
			ShowInfoBox(playerid, I_HINT_WITHDRAW2, amount, hInfo[h][HouseStorage]);
		}
		return 1;
	}
//------------------------------------------------------------------------------
//                          House Sale
//------------------------------------------------------------------------------
	if(dialogid == HOUSEMENU+18 && response)
	{
		switch(listitem)
		{
		    case 0: ShowPlayerDialog(playerid, HOUSEMENU+10, DIALOG_STYLE_LIST, INFORMATION_HEADER, "Deposit Money\nWithdraw Money\nCheck Balance", "Select", "Cancel");
		    case 1: ShowPlayerDialog(playerid, HOUSEMENU+30, DIALOG_STYLE_LIST, INFORMATION_HEADER, "Store Your Current Weapons\nReceive House Storage Weapons", "Select", "Cancel");
		}
	}
//------------------------------------------------------------------------------
//                          Selling House
//------------------------------------------------------------------------------
	if(dialogid == HOUSEMENU+19 && response)
	{
  		switch(listitem)
		{
		    case 0: ShowPlayerDialog(playerid, HOUSEMENU+20, DIALOG_STYLE_INPUT, INFORMATION_HEADER, HMENU_SELL_HOUSE2, "Select", "Cancel");
		    case 1: ShowPlayerDialog(playerid, HOUSEMENU+21, DIALOG_STYLE_MSGBOX, INFORMATION_HEADER, HMENU_HSALE_CANCEL, "Remove", "Cancel");
		    case 2:
		    {
		    	format(string, sizeof(string), HMENU_SELL_HOUSE, hInfo[h][HouseName], ReturnProcent(hInfo[h][HouseValue], HOUSE_SELLING_PROCENT));
				ShowPlayerDialog(playerid, HOUSEMENU+3, DIALOG_STYLE_MSGBOX, INFORMATION_HEADER, string, "Sell", "Cancel");
			}
		}
		return 1;
	}
//------------------------------------------------------------------------------
//                          Selling House
//------------------------------------------------------------------------------
	if(dialogid == HOUSEMENU+20 && response)
	{
		if(amount < MIN_HOUSE_VALUE || amount > MAX_HOUSE_VALUE) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_HSELL_AMOUNT);
		else
		{
		    hInfo[h][ForSalePrice] = amount;
		    hInfo[h][ForSale] = 1;
		    file = INI_Open(filename);
			INI_WriteInt(file, "ForSale", 1);
			INI_WriteInt(file, "ForSalePrice", amount);
			INI_Close(file);
			ShowInfoBox(playerid, I_H_SET_FOR_SALE, hInfo[h][HouseName], amount);
			UpdateHouseText(h);
		}
		return 1;
	}
//------------------------------------------------------------------------------
//                          Cancelling House Sale
//------------------------------------------------------------------------------
	if(dialogid == HOUSEMENU+21 && response)
	{
		if(hInfo[h][ForSale] != 1) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_H_NOT_FOR_SALE);
		else
		{
		    hInfo[h][ForSalePrice] = 0;
		    hInfo[h][ForSale] = 0;
		    file = INI_Open(filename);
			INI_WriteInt(file, "ForSale", 0);
			INI_WriteInt(file, "ForSalePrice", 0);
			INI_Close(file);
			ShowInfoBoxEx(playerid, COLOUR_INFO, HMENU_CANCEL_HOUSE_SALE);
			UpdateHouseText(h);
		}
		return 1;
	}
//------------------------------------------------------------------------------
//                          Selecting some stuff
//------------------------------------------------------------------------------
	if(dialogid == HOUSEMENU+22 && response)
	{
	    if(GetPlayerMoney(playerid) < hInfo[h][ForSalePrice]) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_NOT_ENOUGH_PMONEY);
	    else
	    {
			new houseowner = GetHouseOwnerEx(h);
			switch(IsPlayerConnected(houseowner))
			{
				case 0:
	   			{
	    			new filename2[50];
	       			format(filename2, sizeof(filename2), USERPATH, hInfo[h][HouseOwner]);
			        if(!fexist(filename2))
			        {
	          			fcreate(filename2);
			        }
			        file = INI_Open(filename2);
					INI_WriteInt(file, "MoneyToGive", hInfo[h][ForSalePrice]);
					INI_WriteInt(file, "MoneyToGiveHS", hInfo[h][HouseStorage]);
					INI_WriteString(file, "HouseName", hInfo[h][HouseName]);
					INI_WriteString(file, "HouseBuyer", pNick(playerid));
					INI_Close(file);
	 			}
	 			case 1:
	 			{
	 			    CMDSString = "";
					format(_tmpstring, sizeof(_tmpstring), HSELLER_CONNECTED_MSG1, hInfo[h][HouseName], pNick(playerid), playerid);
					strcat(CMDSString, _tmpstring);
					format(_tmpstring, sizeof(_tmpstring), HSELLER_CONNECTED_MSG2, (hInfo[h][HouseStorage] + hInfo[h][ForSalePrice]), hInfo[h][HouseStorage], hInfo[h][ForSalePrice]);
					strcat(CMDSString, _tmpstring);
					ShowInfoBoxEx(houseowner, COLOUR_INFO, CMDSString);
					GivePlayerMoney(houseowner, (hInfo[h][ForSalePrice] + hInfo[h][HouseStorage]));
	  			}
			}
			GivePlayerMoney(playerid, -hInfo[h][ForSalePrice]);
			format(hInfo[h][HouseName], MAX_HOUSE_NAME, "%s's House", pNick(playerid));
			format(hInfo[h][HouseOwner], MAX_PLAYER_NAME, "%s", pNick(playerid));
			hInfo[h][HousePassword] = udb_hash("INVALID_HOUSE_PASSWORD");
			hInfo[h][ForSale] = 0;
			hInfo[h][ForSalePrice] = 0;
	   		hInfo[h][HouseStorage] = 0;
			file = INI_Open(filename);
			INI_WriteString(file, "HouseOwner", pNick(playerid));
			INI_WriteInt(file, "HousePassword", hInfo[h][HousePassword]);
			INI_WriteString(file, "HouseName", hInfo[h][HouseName]);
			INI_WriteInt(file, "HouseStorage", 0);
			INI_WriteInt(file, "ForSale", 0);
			INI_WriteInt(file, "ForSalePrice", 0);
			INI_Close(file);
			UpdateHouseText(h);
			#if GH_USE_MAPICONS == true
				DestroyDynamicMapIcon(HouseMIcon[h]);
				HouseMIcon[h] = CreateDynamicMapIcon(hInfo[h][CPOutX], hInfo[h][CPOutY], hInfo[h][CPOutZ], 31, -1, hInfo[h][SpawnWorld], hInfo[h][SpawnInterior], -1, MICON_VD);
			#endif
			UpdateHouseText(h);
		}
		return 1;
	}
//------------------------------------------------------------------------------
//                          Selecting some stuff
//------------------------------------------------------------------------------
	if(dialogid == HOUSEMENU+23 && response)
	{
		switch(listitem)
		{
		    case 0:
			{
			    format(string,sizeof(string), HSELL_BUY_DIALOG, hInfo[h][HouseOwner], hInfo[h][HouseName], hInfo[h][ForSalePrice]);
				ShowPlayerDialog(playerid, HOUSEMENU+22, DIALOG_STYLE_MSGBOX, INFORMATION_HEADER, string, "Buy", "Cancel");
			}
			case 1:
			{
			    #if GH_ALLOW_BREAKIN == false
			    	ShowInfoBoxEx(playerid, COLOUR_INFO, E_NO_HOUSE_BREAKIN);
			    #else
			    new breakintime = GetPVarInt(playerid, "TimeSinceHouseBreakin"), houseowner = GetHouseOwnerEx(h), bi_chance = random(10000);
       			if(GetSecondsBetweenAction(breakintime) < (TIME_BETWEEN_BREAKINS * 60000) && breakintime != 0) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_WAIT_BEFORE_BREAKIN);
			    SetPVarInt(playerid, "TimeSinceHouseBreakin", GetTickCount());
			    if((hInfo[h][UpgradedLock] == 0 && bi_chance < 7000) ||  (hInfo[h][UpgradedLock] == 1 && bi_chance < 9000))
			    {
			    	if(IsPlayerConnected(houseowner))
        			{
           				switch(hInfo[h][HouseCamera])
               			{
                  			case 0:
	                    	{
                       			if(hInfo[h][HouseAlarm] == 1)
	                        	{
                          			ShowInfoBox(houseowner, E_FAILED_BREAKIN1_2, hInfo[h][HouseName], hInfo[h][HouseLocation]);
                       			}
           					}
	                		case 1: ShowInfoBox(houseowner, E_FAILED_BREAKIN1_1, pNick(playerid), playerid, hInfo[h][HouseName], hInfo[h][HouseLocation]);
           				}
           			}
		            ShowInfoBox(playerid, E_FAILED_BREAKIN2, hInfo[h][HouseName], hInfo[h][HouseOwner]);
		            SecurityDog_Bite(playerid, h, 0, 1);
			    }
			    if((hInfo[h][UpgradedLock] == 0 && bi_chance >= 7000) ||  (hInfo[h][UpgradedLock] == 1 && bi_chance >= 9000))
			    {
					if(IsPlayerConnected(houseowner))
     				{
         				switch(hInfo[h][HouseCamera])
             			{
                			case 0:
           					{
                				if(hInfo[h][HouseAlarm] == 1)
			                    {
									ShowInfoBox(houseowner, I_SUCCESSFULL_BREAKIN1_2, hInfo[h][HouseName], hInfo[h][HouseLocation]);
			                    }
			                }
		                	case 1: ShowInfoBox(houseowner, I_SUCCESSFULL_BREAKIN1_1, pNick(playerid), playerid, hInfo[h][HouseName], hInfo[h][HouseLocation]);
                		}
	            	}
		            ShowInfoBox(playerid, I_SUCCESSFULL_BREAKIN2, hInfo[h][HouseName], hInfo[h][HouseOwner]);
		           	SetPlayerHouseInterior(playerid, h);
			    }
			    #if GH_GIVE_WANTEDLEVEL == true
				if((GetPlayerWantedLevel(playerid) + HBREAKIN_WL) > GH_MAX_WANTED_LEVEL)
				{
					SetPlayerWantedLevel(playerid, GH_MAX_WANTED_LEVEL);
				}
				else SetPlayerWantedLevel(playerid, (GetPlayerWantedLevel(playerid) + HBREAKIN_WL));
				#endif
			    #endif
			}
			case 2:
		    {
		        if(hInfo[h][HousePassword] != udb_hash("INVALID_HOUSE_PASSWORD"))
		        {
		            format(string, sizeof(string), HMENU_ENTER_PASS, hInfo[h][HouseName], hInfo[h][HouseOwner], hInfo[h][HouseValue], h);
 					ShowPlayerDialog(playerid, HOUSEMENU+60, DIALOG_STYLE_INPUT, INFORMATION_HEADER, string, "Enter", "Close");
    			}
    			else SetPlayerHouseInterior(playerid, h);
		    }
		}
		return 1;
	}
//------------------------------------------------------------------------------
//                          Selecting some stuff
//------------------------------------------------------------------------------
	if(dialogid == HOUSEMENU+28 && response)
	{
		switch(listitem)
		{
		    case 0:
			{
			    if(hInfo[h][HousePassword] != udb_hash("INVALID_HOUSE_PASSWORD"))
		        {
		            format(string,sizeof(string), HMENU_ENTER_PASS, hInfo[h][HouseName], hInfo[h][HouseOwner], hInfo[h][HouseValue], h);
 					ShowPlayerDialog(playerid, HOUSEMENU+60, DIALOG_STYLE_INPUT, INFORMATION_HEADER, string, "Enter", "Close");
    			}
			}
			case 1:
			{
			    #if GH_ALLOW_BREAKIN == false
			    	ShowInfoBoxEx(playerid, COLOUR_INFO, E_NO_HOUSE_BREAKIN);
			    #else
			    new breakintime = GetPVarInt(playerid, "TimeSinceHouseBreakin"), houseowner = GetHouseOwnerEx(h), bi_chance = random(10000);
       			if(GetSecondsBetweenAction(breakintime) < (TIME_BETWEEN_BREAKINS * 60000) && breakintime != 0) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_WAIT_BEFORE_BREAKIN);
			    SetPVarInt(playerid, "TimeSinceHouseBreakin", GetTickCount());
			    if((hInfo[h][UpgradedLock] == 0 && bi_chance < 7000) ||  (hInfo[h][UpgradedLock] == 1 && bi_chance < 9000))
			    {
			    	if(IsPlayerConnected(houseowner))
        			{
           				switch(hInfo[h][HouseCamera])
               			{
                  			case 0:
	                    	{
                       			if(hInfo[h][HouseAlarm] == 1)
	                        	{
                          			ShowInfoBox(houseowner, E_FAILED_BREAKIN1_2, hInfo[h][HouseName], hInfo[h][HouseLocation]);
                       			}
           					}
	                		case 1: ShowInfoBox(houseowner, E_FAILED_BREAKIN1_1, pNick(playerid), playerid, hInfo[h][HouseName], hInfo[h][HouseLocation]);
           				}
           			}
		            ShowInfoBox(playerid, E_FAILED_BREAKIN2, hInfo[h][HouseName], hInfo[h][HouseOwner]);
		            SecurityDog_Bite(playerid, h, 0, 1);
			    }
			    if((hInfo[h][UpgradedLock] == 0 && bi_chance >= 7000) ||  (hInfo[h][UpgradedLock] == 1 && bi_chance >= 9000))
			    {
					if(IsPlayerConnected(houseowner))
     				{
         				switch(hInfo[h][HouseCamera])
             			{
                			case 0:
           					{
                				if(hInfo[h][HouseAlarm] == 1)
			                    {
									ShowInfoBox(houseowner, I_SUCCESSFULL_BREAKIN1_2, hInfo[h][HouseName], hInfo[h][HouseLocation]);
			                    }
			                }
		                	case 1: ShowInfoBox(houseowner, I_SUCCESSFULL_BREAKIN1_1, pNick(playerid), playerid, hInfo[h][HouseName], hInfo[h][HouseLocation]);
                		}
	            	}
		            ShowInfoBox(playerid, I_SUCCESSFULL_BREAKIN2, hInfo[h][HouseName], hInfo[h][HouseOwner]);
		           	SetPlayerHouseInterior(playerid, h);
			    }
			    #if GH_GIVE_WANTEDLEVEL == true
				if((GetPlayerWantedLevel(playerid) + HBREAKIN_WL) > GH_MAX_WANTED_LEVEL)
				{
					SetPlayerWantedLevel(playerid, GH_MAX_WANTED_LEVEL);
				}
				else SetPlayerWantedLevel(playerid, (GetPlayerWantedLevel(playerid) + HBREAKIN_WL));
				#endif
			    #endif
			}
		    case 2: SetPlayerHouseInterior(playerid, h);
		}
		return 1;
	}
//------------------------------------------------------------------------------
//                          House Privacy
//------------------------------------------------------------------------------
	if(dialogid == HOUSEMENU+24 && response)
	{
		switch(listitem)
		{
		    case 0: // Open
			{
			    hInfo[h][HousePrivacy] = 1;
			    file = INI_Open(filename);
			    INI_WriteInt(file, "HousePrivacy", 1);
			    INI_Close(file);
			    ShowInfoBoxEx(playerid, COLOUR_INFO, I_HOPEN_FOR_VISITORS);
			}
			case 1: // Closed
		    {
		        new count;
		        hInfo[h][HousePrivacy] = 0;
			    file = INI_Open(filename);
			    INI_WriteInt(file, "HousePrivacy", 0);
			    INI_Close(file);
		      	foreach(Player, i)
				{
				    if(i == playerid) continue;
		  			if(GetPVarInt(i, "LastHouseCP") == h && IsInHouse{i} == 1)
		  			{
						ExitHouse(i, GetPVarInt(i, "LastHouseCP"));
						ShowInfoBox(playerid, I_CLOSED_FOR_VISITORS2 , pNick(playerid), playerid);
						count++;
					}
				}
                ShowInfoBox(playerid, I_CLOSED_FOR_VISITORS1, count);
		    }
		}
		UpdateHouseText(h);
		return 1;
	}
//------------------------------------------------------------------------------
//                          Player Selecting - Part 1
//------------------------------------------------------------------------------
	if(dialogid == HOUSEMENU+25 && response)
	{
	    new tmpcount;
		foreach(Player, i)
		{
  			if(!IsPlayerInHouse(i, h)) continue;
	    	if(playerid == i) continue;
	    	if(listitem == tmpcount)
	    	{
	    	    SetPVarInt(playerid, "ClickedPlayer", i);
	    	    break;
	    	}
	    	tmpcount++;
		}
		ShowPlayerDialog(playerid, HOUSEMENU+26, DIALOG_STYLE_LIST, INFORMATION_HEADER, "Kick Out From House\nGive House Key\nTake House Key", "Select", "Cancel");
		return 1;
	}
//------------------------------------------------------------------------------
//                         Player Selecting - Part 2
//------------------------------------------------------------------------------
	if(dialogid == HOUSEMENU+26 && response)
	{
	    new clickedplayer = GetPVarInt(playerid, "ClickedPlayer"), _temp_[17];
	    switch(listitem)
	    {
	        case 0:
			{
			    if(!IsPlayerInHouse(clickedplayer, h)) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_KICKED_NOT_IN_HOUSE);
			    ExitHouse(clickedplayer, h);
			    ShowInfoBox(playerid, I_KICKED_FROM_HOUSE1, pNick(clickedplayer), clickedplayer);
			    ShowInfoBox(clickedplayer, I_KICKED_FROM_HOUSE2, pNick(playerid), playerid);
			}
	        case 1:
			{
			    format(_temp_, sizeof(_temp_), "HouseKeys_%d", h);
			    if(GetPVarInt(clickedplayer, _temp_) == 1)  return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_ALREADY_HAVE_HOUSEKEYS);
			    SetPVarInt(clickedplayer, _temp_, 1);
			    ShowInfoBox(playerid, I_HOUSEKEYS_RECIEVED_1, pNick(clickedplayer), clickedplayer);
			    ShowInfoBox(clickedplayer, I_HOUSEKEYS_RECIEVED_2, hInfo[h][HouseName], hInfo[h][HouseLocation], pNick(playerid), playerid);
	        }
	        case 2:
	        {
			    format(_temp_, sizeof(_temp_), "HouseKeys_%d", h);
			    if(GetPVarInt(clickedplayer, _temp_) == 0)  return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_DOESNT_HAVE_HOUSEKEYS);
			    DeletePVar(clickedplayer, _temp_);
			    ShowInfoBox(playerid, I_HOUSEKEYS_TAKEN_1, pNick(clickedplayer), clickedplayer);
			    ShowInfoBox(clickedplayer, I_HOUSEKEYS_TAKEN_2, pNick(playerid), playerid, hInfo[h][HouseName], hInfo[h][HouseLocation]);
	        }
	    }
		return 1;
	}
//------------------------------------------------------------------------------
//                         House Security
//------------------------------------------------------------------------------
	if(dialogid == HOUSEMENU+27 && response)
	{
		file = INI_Open(filename);
	    switch(listitem)
	    {
	        case 0: // House Alarm
	        {
	            if(hInfo[h][HouseAlarm] == 1) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_ALREADY_HAVE_ALARM);
	            if(GetPlayerMoney(playerid) < HUPGRADE_ALARM) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_NOT_ENOUGH_MONEY_ALARM);
	            GivePlayerMoney(playerid, -HUPGRADE_ALARM);
	            hInfo[h][HouseAlarm] = 1;
	            INI_WriteInt(file, "HouseAlarm", 1);
	            ShowInfoBoxEx(playerid, COLOUR_INFO, I_HUPGRADE_ALARM);
	        }
			case 1: // Security Camera
			{
			    if(hInfo[h][HouseCamera] == 1) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_ALREADY_HAVE_CAMERA);
			    if(GetPlayerMoney(playerid) < HUPGRADE_CAMERA) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_NOT_ENOUGH_MONEY_CAMERA);
			    GivePlayerMoney(playerid, -HUPGRADE_CAMERA);
			    hInfo[h][HouseCamera] = 1;
			    INI_WriteInt(file, "HouseCamera", 1);
			    ShowInfoBoxEx(playerid, COLOUR_INFO, I_HUPGRADE_CAMERA);
	        }
			case 2: // House Security Dog
			{
			    if(hInfo[h][HouseDog] == 1) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_ALREADY_HAVE_DOG);
			    if(GetPlayerMoney(playerid) < HUPGRADE_DOG) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_NOT_ENOUGH_MONEY_DOG);
			    GivePlayerMoney(playerid, -HUPGRADE_DOG);
			    hInfo[h][HouseDog] = 1;
			    INI_WriteInt(file, "HouseDog", 1);
			    ShowInfoBoxEx(playerid, COLOUR_INFO, I_HUPGRADE_DOG);
	        }
			case 3: // Better Houselock
			{
			    if(hInfo[h][UpgradedLock] == 1) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_ALREADY_HAVE_UPGRADED_HLOCK);
			    if(GetPlayerMoney(playerid) < HUPGRADE_UPGRADED_HLOCK) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_NOT_ENOUGH_MONEY_UPGRADED_HLOCK);
			    GivePlayerMoney(playerid, -HUPGRADE_UPGRADED_HLOCK);
			    hInfo[h][UpgradedLock] = 1;
			    INI_WriteInt(file, "HouseUpgradedLock", 1);
			    ShowInfoBoxEx(playerid, COLOUR_INFO, I_HUPGRADE_UPGRADED_HLOCK);
	        }
	    }
	    INI_Close(file);
		return 1;
	}
//------------------------------------------------------------------------------
//                          Weapon Storage
//------------------------------------------------------------------------------
	if(dialogid == HOUSEMENU+30 && response)
	{
	    new tmp[9], tmp2[13], tmpcount;
		switch(listitem)
		{
		    case 0: // Store weapons
		    {
		        file = INI_Open(filename);
				Loop(weap, 14, 1)
				{
				    format(tmp, sizeof(tmp), "Weapon%d", weap);
  					format(tmp2, sizeof(tmp2), "Weapon%dAmmo", weap);
				    #if GH_SAVE_ADMINWEPS == false
				    if(weap == 7 || weap == 8 || weap == 9 || weap == 12) continue;
				    #endif
				    GetPlayerWeaponData(playerid, weap, hInfo[h][Weapon][weap], hInfo[h][Ammo][weap]);
				    if(hInfo[h][Ammo][weap] < 1 || (weap == 11 && hInfo[h][Weapon][weap] != 46)) continue;
					INI_WriteInt(file, tmp, hInfo[h][Weapon][weap]);
					INI_WriteInt(file, tmp2, hInfo[h][Ammo][weap]);
					GivePlayerWeapon(playerid, hInfo[h][Weapon][weap], -hInfo[h][Ammo][weap]);
					tmpcount++;
				}
				INI_Close(file);
				switch(tmpcount)
				{
				    case 0: ShowInfoBox(playerid, E_NO_WEAPONS, tmpcount);
				    default: ShowInfoBox(playerid, I_HS_WEAPONS1, tmpcount, AddS(tmpcount));
				}
			}
			case 1: // Receive Weapons
			{
			    file = INI_Open(filename);
				Loop(weap, 14, 1)
				{
				    format(tmp, sizeof(tmp), "Weapon%d", weap);
  					format(tmp2, sizeof(tmp2), "Weapon%dAmmo", weap);
  					if(hInfo[h][Ammo][weap] < 1) continue;
				    #if GH_SAVE_ADMINWEPS == false
				    if(weap == 7 || weap == 8 || weap == 9 || weap == 11 || weap == 12) continue;
				    #endif
					GivePlayerWeapon(playerid, hInfo[h][Weapon][weap], hInfo[h][Ammo][weap]);
					INI_WriteInt(file, tmp, 0);
					INI_WriteInt(file, tmp2, 0);
					tmpcount++;
				}
				INI_Close(file);
				switch(tmpcount)
				{
				    case 0: ShowInfoBoxEx(playerid, COLOUR_INFO, E_NO_HS_WEAPONS);
				    default: ShowInfoBox(playerid, I_HS_WEAPONS2, tmpcount, AddS(tmpcount));
				}
			}
		}
	}
//------------------------------------------------------------------------------
//                       /myhouse House Selecting - Part 1
//------------------------------------------------------------------------------
	if(dialogid == (HOUSEMENU+50) && response)
	{
	    SetPVarInt(playerid, "ClickedHouse", ReturnPlayerHouseID(playerid, (listitem + 1)));
	    #if GH_ALLOW_HOUSETELEPORT == true
        	ShowPlayerDialog(playerid, HOUSEMENU+51, DIALOG_STYLE_LIST, INFORMATION_HEADER, "Show Information\nTeleport To This House", "Select", "Cancel");
        #else
        	ShowPlayerDialog(playerid, HOUSEMENU+51, DIALOG_STYLE_LIST, INFORMATION_HEADER, "Show Information", "Select", "Cancel");
        #endif
        return 1;
	}
//------------------------------------------------------------------------------
//                          /myhouse House Selecting - Part 2
//------------------------------------------------------------------------------
	if(dialogid == (HOUSEMENU+51) && response)
	{
	    new _h = GetPVarInt(playerid, "ClickedHouse");
	    switch(listitem)
	    {
			case 0:
			{
                GetPlayerPos(playerid, X, Y, Z);
			    CMDSString = "";
			    format(_tmpstring, sizeof(_tmpstring), I_HOWNER_HINFO_1, hInfo[_h][HouseName], hInfo[_h][HouseLocation], DistanceToPoint(X, Y, Z, hInfo[h][CPOutX], hInfo[h][CPOutY], hInfo[h][CPOutZ]));
			    strcat(CMDSString, _tmpstring);
				format(_tmpstring, sizeof(_tmpstring), I_HOWNER_HINFO_2, hInfo[_h][HouseValue], hInfo[_h][HouseStorage], Answer(hInfo[_h][HousePrivacy], "Open For Public", "Closed For Public"), _h);
                strcat(CMDSString, _tmpstring);
				ShowInfoBoxEx(playerid, COLOUR_INFO, CMDSString);
			}
			case 1: SetPlayerHouseInterior(playerid, _h);
	    }
	    return 1;
	}
//------------------------------------------------------------------------------
//                          Enter House Using Password
//------------------------------------------------------------------------------
	if(dialogid == HOUSEMENU+60)
	{
		if(response)
		{
		    new _tmp_ = GetHouseOwnerEx(h);
		    if(strfind(inputtext, "%", CASE_SENSETIVE) != -1 || strfind(inputtext, "~", CASE_SENSETIVE) != -1) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_HPASS_CHARS2);
		    if(strlen(inputtext) < MIN_HOUSE_PASSWORD || strlen(inputtext) > MAX_HOUSE_PASSWORD) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_HPASS_LENGTH);
			if(udb_hash(inputtext) != hInfo[h][HousePassword])
			{
				ShowInfoBox(playerid, I_WRONG_HPASS1, hInfo[h][HouseOwner], inputtext);
				if(IsPlayerConnected(_tmp_))
				{
					ShowInfoBox(_tmp_, INFORMATION_HEADER, I_WRONG_HPASS2, pNick(playerid), playerid, inputtext);
    			}
			}
			else
			{
				ShowInfoBox(playerid, I_CORRECT_HPASS1, hInfo[h][HouseOwner], inputtext);
				SetPlayerHouseInterior(playerid, h);
				if(IsPlayerConnected(_tmp_))
				{
					ShowInfoBox(_tmp_, INFORMATION_HEADER, I_CORRECT_HPASS2, pNick(playerid), playerid, inputtext);
				}
			}
		}
		return 1;
	}
	return 0; // It is important to have return 0; here at the end of ALL your scripts which uses dialogs.
}
//==============================================================================
// GetPosInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance);
// Used to get the position infront of a player.
// Credits to whoever made this!
//==============================================================================
stock Float:GetPosInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
	new Float:a;
	GetPlayerPos(playerid, x, y, a);
	switch(IsPlayerInAnyVehicle(playerid))
	{
	    case 0: GetPlayerFacingAngle(playerid, a);
	    case 1: GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	}
	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
	return a;
}
//##############################################################################
// 								Commands
//##############################################################################
// 							  By [03]Garsino!
//==============================================================================
// This command is used to display the house owner menu
// when a player is in a house and is the house owner.
//==============================================================================
CMD:housemenu(playerid, params[])
{
	#pragma unused params
	new h = GetPVarInt(playerid, "LastHouseCP");
 	if(strcmp(hInfo[h][HouseOwner], pNick(playerid), CASE_SENSETIVE) && IsInHouse{playerid} == 1) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_C_ACCESS_SE_HM);
	if(IsInHouse{playerid} == 0) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_NOT_IN_HOUSE);
	if(GetOwnedHouses(playerid) == 0) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_NOT_HOWNER);
	if(IsInHouse{playerid} == 1 && !strcmp(hInfo[h][HouseOwner], pNick(playerid), CASE_SENSETIVE) && GetOwnedHouses(playerid) >= 1)
	{
	    #if GH_HINTERIOR_UPGRADE == true
			ShowPlayerDialog(playerid, HOUSEMENU, DIALOG_STYLE_LIST, INFORMATION_HEADER, "House Selling\nHouse Storage\nSet House Name\nSet House Password\nBuy/Preview House Interior\nToggle House Privacy\nManage Players In House\nHouse Security", "Select", "Cancel");
		#else
			ShowPlayerDialog(playerid, HOUSEMENU, DIALOG_STYLE_LIST, INFORMATION_HEADER, "House Selling\nHouse Storage\nSet House Name\nSet House Password\nToggle House Privacy\nManage Players In House\nHouse Security", "Select", "Cancel");
		#endif
	}
	return 1;
}
//==============================================================================
// This command is used to trigger a house robbery
//==============================================================================
#if GH_ALLOW_HOUSEROBBERY == true
CMD:robhouse(playerid, params[])
{
	#pragma unused params
	new h = GetPVarInt(playerid, "LastHouseCP"), houseowner = GetHouseOwnerEx(GetPVarInt(playerid, "LastHouseCP")), robtime = GetPVarInt(playerid, "TimeSinceHouseBreakin");
	if(IsInHouse{playerid} == 0) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_NOT_IN_HOUSE);
	if(!strcmp(hInfo[h][HouseOwner], pNick(playerid), CASE_SENSETIVE)) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_CANT_ROB_OWN_HOUSE);
	if(!IsPlayerConnected(houseowner)) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_HROB_OWNER_NOT_CONNECTED);
	if(GetPVarInt(playerid, "IsRobbingHouse") == 1) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_ALREADY_ROBBING_HOUSE);
	if(GetSecondsBetweenAction(robtime) < (TIME_BETWEEN_ROBBERIES * 60000) && robtime != 0) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_WAIT_BEFORE_ROBBING);
	switch(random(10000))
	{
	    case 0..6999: // Failed robbery
		{
			switch(hInfo[h][HouseCamera])
 			{
 				case 0:
		   		{
			   		if(hInfo[h][HouseAlarm] == 1)
			   		{
      					ShowInfoBox(houseowner, E_FAILED_HROB1_2, hInfo[h][HouseName], hInfo[h][HouseLocation]);
			    	}
		     	}
		   		case 1: ShowInfoBox(houseowner, E_FAILED_HROB1_1, pNick(playerid), playerid, hInfo[h][HouseName], hInfo[h][HouseLocation]);
   			}
   			SecurityDog_Bite(playerid, h, 1, 1);
   			ShowInfoBox(playerid, E_FAILED_HROB2, hInfo[h][HouseName], hInfo[h][HouseOwner]);
		}
	    case 7000..9999: // Successfull robbery
	    {
			switch(hInfo[h][HouseCamera])
 			{
 				case 0:
				{
                	if(hInfo[h][HouseAlarm] == 1)
                  	{
                   		ShowInfoBox(houseowner, I_HROB_STARTED1_1, hInfo[h][HouseName], hInfo[h][HouseLocation]);
                   	}
    			}
               	case 1: ShowInfoBox(houseowner, I_HROB_STARTED1_2, pNick(playerid), playerid, hInfo[h][HouseName], hInfo[h][HouseLocation]);
    		}
   			ShowInfoBox(playerid, I_HROB_STARTED2, hInfo[h][HouseOwner], hInfo[h][HouseName], hInfo[h][HouseLocation]);
			SetPVarInt(playerid, "IsRobbingHouse", 1), SetPVarInt(playerid, "HouseRobberyTime", RandomEx(MIN_ROB_TIME, MAX_ROB_TIME));
			SetPVarInt(playerid, "HouseRobberyTimer", SetTimerEx("HouseRobbery", 999, true, "ii", playerid, h));
	    }
	}
	#if GH_GIVE_WANTEDLEVEL == true
	if((GetPlayerWantedLevel(playerid) + HROBBERY_WL) > GH_MAX_WANTED_LEVEL)
	{
		SetPlayerWantedLevel(playerid, GH_MAX_WANTED_LEVEL);
	}
	else SetPlayerWantedLevel(playerid, (GetPlayerWantedLevel(playerid) + HROBBERY_WL));
	#endif
	SetPVarInt(playerid, "TimeSinceHouseRobbery", GetTickCount());
	return 1;
}
#endif
#if GH_ALLOW_HOUSEROBBERY == true
function HouseRobbery(playerid, houseid)
{
	new robberytime = GetPVarInt(playerid, "HouseRobberyTime");
	if(GetPVarInt(playerid, "IsRobbingHouse") == 1)
	{
		switch(robberytime)
		{
		    case 1..MAX_ROB_TIME: GameTextEx(playerid, 999, 3, "~n~ ~g~Robbery in Progress... ~n~ ~r~%d ~w~Seconds Remaining...", robberytime);
			case 0:
			{
			    switch(IsPlayerInHouse(playerid, houseid))
       			{
	    			case 0: ShowInfoBox(playerid, I_HROB_FAILED_NOT_IN_HOUSE, hInfo[houseid][HouseName]);
					case 1:
					{
	    				new RobAmount = ReturnProcent(hInfo[houseid][HouseStorage], HOUSE_ROBBERY_PERCENT), houseowner = GetHouseOwnerEx(houseid);
				    	if(RobAmount > MAX_MONEY_ROBBED)
					    {
							RobAmount = MAX_MONEY_ROBBED;
					    }
					    if(IsPlayerConnected(houseowner))
	     				{
	         				switch(hInfo[houseid][HouseCamera])
	             			{
	                			case 0:
	           					{
	                				if(hInfo[houseid][HouseAlarm] == 1)
				                    {
										ShowInfoBox(houseowner, I_HROB_COMPLETED1_2, hInfo[houseid][HouseName], hInfo[houseid][HouseLocation], RobAmount);
				                    }
				                }
			                	case 1: ShowInfoBox(houseowner, I_HROB_COMPLETED1_1, pNick(playerid), playerid, hInfo[houseid][HouseName], hInfo[houseid][HouseLocation], RobAmount);
	                		}
		            	}
					    hInfo[houseid][HouseStorage] -= RobAmount;
						new INI:file = INI_Open(HouseFile(houseid));
						INI_WriteInt(file, "HouseStorage", hInfo[houseid][HouseStorage]);
						INI_Close(file);
					    GivePlayerMoney(playerid, RobAmount);
					    ShowInfoBox(playerid, I_HROB_COMPLETED2, RobAmount, hInfo[houseid][HouseOwner], hInfo[houseid][HouseName], hInfo[houseid][HouseLocation]);
					    GameTextEx(playerid, 4500, 3, "~n~ ~p~Robbery Completed~w~! ~n~ Robbed ~g~$%d~w~!", RobAmount);
			    	}
				}
				EndHouseRobbery(playerid);
				SetPVarInt(playerid, "IsRobbingHouse", 0);
				SetPVarInt(playerid, "TimeSinceHouseRobbery", GetTickCount());
			    DeletePVar(playerid, "HouseRobberyTimer");
			}
		}
	}
	return SetPVarInt(playerid, "HouseRobberyTime", (robberytime - 1));
}
#endif
//==============================================================================
// This command is used to display the players houses.
//==============================================================================
CMD:myhouses(playerid, params[])
{
	#pragma unused params
	if(GetOwnedHouses(playerid) == 0) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_NO_HOUSES_OWNED);
	new h, _tmpstring[128], count = GetOwnedHouses(playerid);
	CMDSString = "";
	Loop(i, (count + 1), 1)
	{
	    h = ReturnPlayerHouseID(playerid, i);
		if(i == count)
		{
		    format(_tmpstring, sizeof(_tmpstring), "{00BC00}%d.\t{FFFF2A}%s in %s", i, hInfo[h][HouseName], hInfo[h][HouseLocation]);
		}
		else format(_tmpstring, sizeof(_tmpstring), "{00BC00}%d.\t{FFFF2A}%s in %s\n", i, hInfo[h][HouseName], hInfo[h][HouseLocation]);
		strcat(CMDSString, _tmpstring);
	}
	ShowPlayerDialog(playerid, HOUSEMENU+50, DIALOG_STYLE_LIST, INFORMATION_HEADER, CMDSString, "Select", "Cancel");
	return 1;
}
//==============================================================================
// This command is used to create a house.
// The only thing you have to enter is the house value,
// the rest is done by the script.
//==============================================================================
CMD:createhouse(playerid, params[])
{
	new cost, h = GetFreeHouseID(), labeltext[250], hint;
	if(!IsPlayerAdmin(playerid)) return 0;
	if(sscanf(params, "dD(" #DEFAULT_H_INTERIOR ")", cost, hint)) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_CMD_USAGE_CREATEHOUSE);
	if(h < 0)
	{
		ShowInfoBox(playerid, E_TOO_MANY_HOUSES, MAX_HOUSES);
		return 1;
	}
	if(hint < 0 || hint > MAX_HOUSE_INTERIORS) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_HINT);
	if(IsHouseInteriorValid(hint) == 0) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_HINT_DOESNT_EXIST);
	if(cost < MIN_HOUSE_VALUE || cost > MAX_HOUSE_VALUE) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_HVALUE);
	else
	{
        fcreate(HouseFile(h));
		GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid, Angle);
		new world = GetPlayerVirtualWorld(playerid), interior = GetPlayerInterior(playerid);
		hInfo[h][CPOutX] = X, hInfo[h][CPOutY] = Y, hInfo[h][CPOutZ] = Z;
		format(hInfo[h][HouseName], MAX_HOUSE_NAME, "%s", DEFAULT_HOUSE_NAME);
		format(hInfo[h][HouseOwner], MAX_PLAYER_NAME, "%s", INVALID_HOWNER_NAME);
		format(hInfo[h][HouseLocation], MAX_ZONE_NAME, "%s", GetHouseLocation(h));
		hInfo[h][HousePassword] = udb_hash("INVALID_HOUSE_PASSWORD");
		hInfo[h][HouseValue] = cost, hInfo[h][HouseStorage] = 0;
		new INI:file = INI_Open(HouseFile(h));
		INI_WriteFloat(file, "CPOutX", X);
		INI_WriteFloat(file, "CPOutY", Y);
		INI_WriteFloat(file, "CPOutZ", Z);
		INI_WriteString(file, "HouseName", DEFAULT_HOUSE_NAME);
		INI_WriteString(file, "HouseOwner", INVALID_HOWNER_NAME);
		INI_WriteString(file, "HouseLocation", hInfo[h][HouseLocation]);
		INI_WriteInt(file, "HousePassword", hInfo[h][HousePassword]);
		INI_WriteString(file, "HouseCreator", pNick(playerid));
		INI_WriteInt(file, "HouseValue", cost);
		INI_WriteInt(file, "HouseStorage", 0);
		format(labeltext, sizeof(labeltext), LABELTEXT1, DEFAULT_HOUSE_NAME, cost, h);
		#if GH_USE_CPS == true
			HouseCPOut[h] = CreateDynamicCP(X, Y, Z, 1.5, world, interior, -1, CP_DRAWDISTANCE);
			HouseCPInt[h] = CreateDynamicCP(hIntInfo[hint][IntCPX], hIntInfo[hint][IntCPY], hIntInfo[hint][IntCPZ], 1.5, (h + 1000), hIntInfo[hint][IntInterior], -1, 15.0);
		#else
			HousePickupOut[h] = CreateDynamicPickup(PICKUP_MODEL_OUT, PICKUP_TYPE, X, Y, Z, world, interior, -1, 15.0);
			HousePickupInt[h] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, hIntInfo[hint][IntCPX], hIntInfo[hint][IntCPY], hIntInfo[hint][IntCPZ], (h + 1000), hIntInfo[hint][IntInterior], -1, 15.0);
		#endif
		#if GH_USE_MAPICONS == true
	 		HouseMIcon[h] = CreateDynamicMapIcon(X, Y, Z, 31, -1, world, interior, -1, 50.0);
	 	#endif
		HouseLabel[h] = CreateDynamic3DTextLabel(labeltext, COLOUR_GREEN, X, Y, Z+0.7, TEXTLABEL_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, TEXTLABEL_TESTLOS, world, interior, -1, TEXTLABEL_DISTANCE);
		ShowInfoBox(playerid, I_H_CREATED, h);
		GetPosInFrontOfPlayer(playerid, X, Y, -2.5);
		INI_WriteFloat(file, "SpawnOutX", X);
		INI_WriteFloat(file, "SpawnOutY", Y);
		INI_WriteFloat(file, "SpawnOutZ", Z);
		INI_WriteFloat(file, "SpawnOutAngle", (180.0 + Angle));
		INI_WriteInt(file, "SpawnWorld", world);
		INI_WriteInt(file, "SpawnInterior", interior);
		INI_WriteInt(file, "HouseInterior", hint);
		hInfo[h][SpawnOutX] = X, hInfo[h][SpawnOutY] = Y, hInfo[h][SpawnOutZ] = Z, hInfo[h][SpawnOutAngle] = (180.0 + Angle);
		hInfo[h][SpawnWorld] = world, hInfo[h][SpawnInterior] = interior, hInfo[h][HouseInterior] = hint;
		hInfo[h][HouseAlarm] = hInfo[h][HouseDog] = hInfo[h][HouseCamera] = hInfo[h][UpgradedLock] = 0;
		INI_Close(file);
		CurrentID++;
		file = INI_Open("/GarHouse/House.ini");
		INI_WriteInt(file, "CurrentID", CurrentID);
		INI_Close(file);
		SetPVarInt(playerid, "JustCreatedHouse", 1);
		Iter_Add(Houses, h);
	}
    return 1;
}
//==============================================================================
// This command is used to add a house car for a house.
// The only thing you have to enter is the house value,
// the rest is done by the script.
//==============================================================================
CMD:addhcar(playerid, params[])
{
	new h;
	if(!IsPlayerAdmin(playerid)) return 0;
	if(!IsPlayerInAnyVehicle(playerid)) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_HCAR_NOT_IN_VEH);
	if(sscanf(params, "d", h)) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_CMD_USAGE_ADDHCAR);
	if(!fexist(HouseFile(h))) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_HID);
	else
	{
	    if(hInfo[h][HouseCar] == 1) { ShowInfoBox(playerid, I_HCAR_EXIST_ALREADY, h); }
	    if(hInfo[h][HouseCar] == 0) { ShowInfoBox(playerid, I_HCAR_CREATED, h); }
		GetVehiclePos(GetPlayerVehicleID(playerid), X, Y, Z);
		GetVehicleZAngle(GetPlayerVehicleID(playerid), Angle);
		new world = GetPlayerVirtualWorld(playerid), interior = GetPlayerInterior(playerid);
		hInfo[h][HouseCar] = 1, hInfo[h][HouseCarPosX] = X, hInfo[h][HouseCarPosY] = Y, hInfo[h][HouseCarPosZ] = Z, hInfo[h][HouseCarAngle] = Angle;
		hInfo[h][HouseCarModel] = GetVehicleModel(GetPlayerVehicleID(playerid)), hInfo[h][HouseCarInterior] = interior, hInfo[h][HouseCarWorld] = world;
		new INI:file = INI_Open(HouseFile(h));
		INI_WriteFloat(file, "HCarPosX", X);
		INI_WriteFloat(file, "HCarPosY", Y);
		INI_WriteFloat(file, "HCarPosZ", Z);
		INI_WriteFloat(file, "HCarAngle", Angle);
		INI_WriteInt(file, "HCar", 1);
		INI_WriteInt(file, "HCarWorld", world);
		INI_WriteInt(file, "HCarInt", interior);
		INI_WriteInt(file, "HCarModel", hInfo[h][HouseCarModel]);
		INI_Close(file);
	}
    return 1;
}
//==============================================================================
// This command is used to delete a house.
// Note: It does not give any money to the house owner when the house is deleted
//==============================================================================
CMD:removehouse(playerid, params[])
{
	new h;
	if(!IsPlayerAdmin(playerid)) return 0;
	if(sscanf(params, "d", h)) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_CMD_USAGE_REMOVEHOUSE);
	if(!fexist(HouseFile(h))) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_HID);
	else
	{
	    foreach(Player, i)
	    {
			if(IsInHouse{i} == 0) continue;
			ExitHouse(i, h);
	    }
     	DestroyHouseEntrance(h, TYPE_OUT);
	    DestroyHouseEntrance(h, TYPE_INT);
	    #if GH_USE_MAPICONS == true
			DestroyDynamicMapIcon(HouseMIcon[h]);
		#endif
	    DestroyDynamic3DTextLabel(HouseLabel[h]);
		ShowInfoBox(playerid, I_H_DESTROYED, h);
		fremove(HouseFile(h));
		Iter_Remove(Houses, h);
	}
    return 1;
}
//==============================================================================
// This command is used to remove the house car for a house.
//==============================================================================
CMD:removehcar(playerid, params[])
{
	new h;
	if(!IsPlayerAdmin(playerid)) return 0;
	if(sscanf(params, "d", h)) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_CMD_USAGE_REMOVEHCAR);
	if(!fexist(HouseFile(h))) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_HID);
	if(hInfo[h][HouseCar] == 0) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_NO_HCAR);
	else
	{
	    UnloadHouseCar(h);
	    hInfo[h][HouseCar] = 0;
	    new INI:file = INI_Open(HouseFile(h));
		INI_WriteInt(file, "HCar", 0);
		INI_Close(file);
		ShowInfoBox(playerid, I_HCAR_REMOVED, h);
	}
    return 1;
}
//==============================================================================
// This command is used to change the modelid of a housecar.
//==============================================================================
CMD:changehcar(playerid, params[])
{
	new h, modelid;
	if(!IsPlayerAdmin(playerid)) return 0;
	if(sscanf(params, "dd", h, modelid)) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_CMD_USAGE_CHANGEHCAR);
	if(!fexist(HouseFile(h))) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_HID);
	if(modelid < 400 || modelid > 612) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_HCAR_MODEL);
	else
	{
	    hInfo[h][HouseCarModel] = modelid;
	    new INI:file = INI_Open(HouseFile(h));
		INI_WriteInt(file, "HCarModel", modelid);
		INI_Close(file);
		ShowInfoBox(playerid, I_HCAR_CHANGED, h, modelid);
    	#if GH_HOUSECARS == true
		if(GetVehicleModel(HCar[h]) != -1)
		{
		    if(IsVehicleOccupied(HCar[h]))
		    {
		        new Float:Velocity[3], Float:Pos[4], Seat[MAX_PLAYERS char] = -1, interior, vw = GetVehicleVirtualWorld(HCar[h]);
		        foreach(Player, i)
		        {
		            if(IsPlayerInVehicle(i, HCar[h]))
		            {
		                Seat{i} = GetPlayerVehicleSeat(i);
		                if(Seat{i} == 0)
		                {
		                    interior = GetPlayerInterior(i); // Have to do it this way because there is no GetVehicleInterior..
						}
		            }
		        }
		        GetVehiclePos(HCar[h], Pos[0], Pos[1], Pos[2]);
		        GetVehicleZAngle(HCar[h], Pos[3]);
		        GetVehicleVelocity(HCar[h], Velocity[0], Velocity[1], Velocity[2]);
		        DestroyVehicle(HCar[h]);
		        HCar[h] = CreateVehicle(modelid, Pos[0], Pos[1], Pos[2], Pos[3], HCAR_COLOUR1, HCAR_COLOUR2, HCAR_RESPAWN);
				LinkVehicleToInterior(HCar[h], interior);
				SetVehicleVirtualWorld(HCar[h], vw);
				foreach(Player, i)
		        {
		            if(Seat[i] != -1)
		            {
		                PutPlayerInVehicle(i, HCar[h], Seat{i});
		                Seat{i} = -1;
		            }
		        }
				SetVehicleVelocity(HCar[h], Velocity[0], Velocity[1], Velocity[2]);
		    }
            if(!IsVehicleOccupied(HCar[h]))
		    {
		        UnloadHouseCar(h);
		        LoadHouseCar(h);
		    }
		}
		#endif
	}
    return 1;
}
//==============================================================================
// This command is used to delete all houses.
// It does not give any money to the house owners when the houses is deleted.
//==============================================================================
CMD:removeallhouses(playerid, params[])
{
	#pragma unused params
	new hcount;
	if(!IsPlayerAdmin(playerid)) return 0;
	else
	{
	    foreach(Houses, h)
	    {
	        foreach(Player, i)
		    {
				if(IsInHouse{i} == 0) continue;
				ExitHouse(i, h);
		    }
	        UnloadHouseCar(h);
    		DestroyHouseEntrance(h, TYPE_OUT);
		    DestroyHouseEntrance(h, TYPE_INT);
		    #if GH_USE_MAPICONS == true
				DestroyDynamicMapIcon(HouseMIcon[h]);
			#endif
    		DestroyDynamic3DTextLabel(HouseLabel[h]);
			fremove(HouseFile(h));
			hcount++;
			Iter_Remove(Houses, h);
		}
		ShowInfoBox(playerid, I_ALLH_DESTROYED, hcount);
	}
    return 1;
}
//==============================================================================
// This command is used remove all house cars.
// It does not delete the house cars itself due to SA:MP mixing up vehicle ID's.
//==============================================================================
CMD:removeallhcars(playerid, params[])
{
	#pragma unused params
	new hcount, INI:file, filename[HOUSEFILE_LENGTH];
	if(!IsPlayerAdmin(playerid)) return 0;
	else
	{
	    foreach(Houses, h)
	    {
	        UnloadHouseCar(h);
	        hInfo[h][HouseCar] = 0;
         	file = INI_Open(filename);
			INI_WriteInt(file, "HCar", 0);
			INI_Close(file);
		}
		ShowInfoBox(playerid, I_ALLHCAR_REMOVED, hcount);
	}
    return 1;
}
//==============================================================================
// This command is used to change the spawnposition details of a house
//==============================================================================
CMD:changespawn(playerid, params[])
{
	new h;
	if(!IsPlayerAdmin(playerid)) return 0;
	if(sscanf(params, "d", h)) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_CMD_USAGE_CHANGESPAWN);
	if(!fexist(HouseFile(h))) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_HID);
	else
	{
	    GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid, Angle);
		new world = GetPlayerVirtualWorld(playerid), interior = GetPlayerInterior(playerid);
		hInfo[h][SpawnOutX] = X, hInfo[h][SpawnOutY] = Y, hInfo[h][SpawnOutZ] = Z, hInfo[h][SpawnOutAngle] = (180.0 + Angle);
		hInfo[h][SpawnWorld] = world, hInfo[h][SpawnInterior] = interior;
		new INI:file = INI_Open(HouseFile(h));
	    INI_WriteFloat(file, "SpawnOutX", X);
		INI_WriteFloat(file, "SpawnOutY", Y);
		INI_WriteFloat(file, "SpawnOutZ", Z);
		INI_WriteFloat(file, "SpawnOutAngle", Angle);
		INI_WriteInt(file, "SpawnWorld", world);
		INI_WriteInt(file, "SpawnInterior", interior);
		INI_Close(file);
		ShowInfoBox(playerid, I_HSPAWN_CHANGED, h);
	}
    return 1;
}
//==============================================================================
// This command is used to change the spawnposition details of a house interior
//==============================================================================
CMD:changehintspawn(playerid, params[])
{
	new hint, filename[HOUSEFILE_LENGTH];
	if(!IsPlayerAdmin(playerid)) return 0;
	if(sscanf(params, "d", hint)) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_CMD_USAGE_CHANGEHINTSPAWN);
    format(filename, sizeof(filename), HINT_FILEPATH, hint);
	if(!fexist(filename)) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_HINT_ID);
	else
	{
	    GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid, Angle);
		hIntInfo[hint][IntSpawnX] = X, hIntInfo[hint][IntSpawnY] = Y, hIntInfo[hint][IntSpawnZ] = Z, hIntInfo[hint][IntInterior] = GetPlayerInterior(playerid);
 		hIntInfo[hint][IntSpawnAngle] = (Angle + 180.0);
		new INI:file = INI_Open(filename);
	    INI_WriteFloat(file, "SpawnX", X);
		INI_WriteFloat(file, "SpawnY", Y);
		INI_WriteFloat(file, "SpawnZ", Z);
		INI_WriteFloat(file, "Angle", hIntInfo[hint][IntSpawnAngle]);
		INI_WriteInt(file, "Interior", hIntInfo[hint][IntInterior]);
		INI_Close(file);
		ShowInfoBox(playerid, I_HINT_SPAWN_CHANGED, hint);
	}
    return 1;
}
//==============================================================================
// This command is used to create a house interior.
//==============================================================================
CMD:createhint(playerid, params[])
{
	new filename[HOUSEFILE_LENGTH], h = GetFreeInteriorID(), value, name[31], interior = GetPlayerInterior(playerid);
	if(!IsPlayerAdmin(playerid)) return 0;
	if(sscanf(params, "ds[30]", value, name)) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_CMD_USAGE_CREATEHINT);
	if(h < 0)
	{
		ShowInfoBox(playerid, E_TOO_MANY_HINTS, MAX_HOUSE_INTERIORS);
		return 1;
	}
	if(value < MIN_HINT_VALUE || value > MAX_HINT_VALUE) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_HINT_VALUE);
	if(name[30]) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_HINT_LENGTH);
	else
	{
	    format(filename, sizeof(filename), HINT_FILEPATH, h);
        fcreate(filename);
 		GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid, Angle);
		hIntInfo[h][IntCPX] = X, hIntInfo[h][IntCPY] = Y, hIntInfo[h][IntCPZ] = Z;
		hIntInfo[h][IntInterior] = interior, hIntInfo[h][IntSpawnAngle] = (Angle + 180.0), format(hIntInfo[h][IntName], 30, "%s", name), hIntInfo[h][IntValue] = value;
		new INI:file = INI_Open(filename);
		INI_WriteFloat(file, "CPX", X);
		INI_WriteFloat(file, "CPY", Y);
		INI_WriteFloat(file, "CPZ", Z);
		INI_WriteString(file, "Name", name);
		INI_WriteInt(file, "Value", value);
		GetPosInFrontOfPlayer(playerid, X, Y, -2.5);
		INI_WriteFloat(file, "SpawnX", X);
		INI_WriteFloat(file, "SpawnY", Y);
		INI_WriteFloat(file, "SpawnZ", Z);
		INI_WriteFloat(file, "Angle", hIntInfo[h][IntSpawnAngle]);
		INI_WriteInt(file, "Interior", interior);
		INI_Close(file);
		hIntInfo[h][IntSpawnX] = X, hIntInfo[h][IntSpawnY] = Y, hIntInfo[h][IntSpawnZ] = Z;
		ShowInfoBox(playerid, I_HINT_CREATED, h, value, name);
	}
    return 1;
}
//==============================================================================
// This command is used to remove a house interior.
//==============================================================================
CMD:removehint(playerid, params[])
{
	new hint, filename[HOUSEFILE_LENGTH];
	if(!IsPlayerAdmin(playerid)) return 0;
	if(sscanf(params, "d", hint)) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_CMD_USAGE_REMOVEHINT);
    format(filename, sizeof(filename), HINT_FILEPATH, hint);
	if(!fexist(filename)) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_HINT);
	ShowInfoBox(playerid, I_HINT_DESTROYED, hint);
	fremove(filename);
	foreach(Houses, h)
	{
	    if(hInfo[h][HouseInterior] == hint)
		{
  			hInfo[h][HouseInterior] = DEFAULT_H_INTERIOR;
	    	new INI:file = INI_Open(HouseFile(h));
		    INI_WriteInt(file, "HouseInterior", DEFAULT_H_INTERIOR);
		    INI_Close(file);
		}
	}
    return 1;
}
//==============================================================================
// This command is used to teleport to a house.
//==============================================================================
CMD:gotohouse(playerid, params[])
{
	new h;
	if(!IsPlayerAdmin(playerid)) return 0;
	if(sscanf(params, "d", h)) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_CMD_USAGE_GOTOHOUSE);
	if(!fexist(HouseFile(h))) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_HID);
	SetPlayerPosEx(playerid, hInfo[h][SpawnOutX], hInfo[h][SpawnOutY], hInfo[h][SpawnOutZ], hInfo[h][SpawnInterior], hInfo[h][SpawnWorld]);
	ShowInfoBox(playerid, I_TELEPORT_MSG, h);
    return 1;
}
//==============================================================================
// This command is used to sell a house.
// If the house owner is connected while selling the house,
// the amount in the house storage and 75% of the house value will be given to the house owner.
//==============================================================================
CMD:sellhouse(playerid, params[])
{
	new h;
	if(!IsPlayerAdmin(playerid)) return 0;
	if(sscanf(params, "d", h)) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_CMD_USAGE_SELLHOUSE);
	if(!fexist(HouseFile(h))) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_HID);
	if(!strcmp(hInfo[h][HouseOwner], INVALID_HOWNER_NAME, CASE_SENSETIVE)) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_H_A_F_SALE);
	else
	{
		ShowInfoBox(playerid, I_H_SOLD, h);
		if(hInfo[h][HouseStorage] >= 1 && IsPlayerConnected(GetHouseOwnerEx(h)))
		{
			GivePlayerMoney(playerid, (hInfo[h][HouseStorage] + ReturnProcent(hInfo[h][HouseValue], HOUSE_SELLING_PROCENT)));
		}
		hInfo[h][HouseValue] = ReturnProcent(hInfo[h][HouseValue], HOUSE_SELLING_PROCENT);
		format(hInfo[h][HouseOwner], MAX_PLAYER_NAME, "%s", INVALID_HOWNER_NAME);
		hInfo[h][HousePassword] = udb_hash("INVALID_HOUSE_PASSWORD");
		format(hInfo[h][HouseName], MAX_HOUSE_NAME, "%s", DEFAULT_HOUSE_NAME);
		hInfo[h][HouseStorage] = hInfo[h][HouseAlarm] = hInfo[h][HouseDog] = hInfo[h][HouseCamera] = hInfo[h][UpgradedLock] = 0;
		new INI:file = INI_Open(HouseFile(h));
		INI_WriteInt(file, "HouseValue", hInfo[h][HouseValue]);
		INI_WriteString(file, "HouseOwner", INVALID_HOWNER_NAME);
		INI_WriteInt(file, "HousePassword", hInfo[h][HousePassword]);
		INI_WriteString(file, "HouseName", DEFAULT_HOUSE_NAME);
		INI_WriteInt(file, "HouseStorage", 0);
		INI_Close(file);
		foreach(Houses, h2)
		{
			if(IsHouseInRangeOfHouse(h, h2, RANGE_BETWEEN_HOUSES) && h2 != h)
			{
		    	hInfo[h2][HouseValue] = (hInfo[h2][HouseValue] - ReturnProcent(hInfo[h2][HouseValue], HOUSE_SELLING_PROCENT2));
		    	file = INI_Open(HouseFile(h2));
				INI_WriteInt(file, "HouseValue", hInfo[h2][HouseValue]);
				INI_Close(file);
			}
		}
		foreach(Player, i)
		{
  			if(IsPlayerInHouse(i, h))
	    	{
      			ExitHouse(i, h);
				ShowInfoBoxEx(i, COLOUR_INFO, I_TO_PLAYERS_HSOLD);
	    	}
		}
		#if GH_USE_MAPICONS == true
			DestroyDynamicMapIcon(HouseMIcon[h]);
			HouseMIcon[h] = CreateDynamicMapIcon(hInfo[h][CPOutX], hInfo[h][CPOutY], hInfo[h][CPOutZ], 31, -1, hInfo[h][SpawnWorld], hInfo[h][SpawnInterior], -1, MICON_VD);
		#endif
		UpdateHouseText(h);
	}
    return 1;
}
//==============================================================================
// This command is used to sell a house.
// If the house owner is connected while selling the house,
// the amount in the house storage and 75% of the house value will be given to the house owner.
//==============================================================================
CMD:sellallhouses(playerid, params[])
{
	#pragma unused params
	new INI:file, hcount;
	if(!IsPlayerAdmin(playerid)) return 0;
	else
	{
	    foreach(Houses, h)
	    {
	        if(strcmp(hInfo[h][HouseOwner], INVALID_HOWNER_NAME, CASE_SENSETIVE))
	        {
				if(hInfo[h][HouseStorage] >= 1 && IsPlayerConnected(GetHouseOwnerEx(h)))
				{
					GivePlayerMoney(playerid, (hInfo[h][HouseStorage] + ReturnProcent(hInfo[h][HouseValue], HOUSE_SELLING_PROCENT)));
				}
				hInfo[h][HouseValue] = ReturnProcent(hInfo[h][HouseValue], HOUSE_SELLING_PROCENT);
				format(hInfo[h][HouseOwner], MAX_PLAYER_NAME, "%s", INVALID_HOWNER_NAME);
				hInfo[h][HousePassword] = udb_hash("INVALID_HOUSE_PASSWORD");
				format(hInfo[h][HouseName], MAX_HOUSE_NAME, "%s", DEFAULT_HOUSE_NAME);
				hInfo[h][HouseStorage] = hInfo[h][HouseAlarm] = hInfo[h][HouseDog] = hInfo[h][HouseCamera] = hInfo[h][UpgradedLock] = 0;
				file = INI_Open(HouseFile(h));
				INI_WriteInt(file, "HouseValue", hInfo[h][HouseValue]);
				INI_WriteString(file, "HouseOwner", INVALID_HOWNER_NAME);
				INI_WriteInt(file, "HousePassword", hInfo[h][HousePassword]);
				INI_WriteString(file, "HouseName", DEFAULT_HOUSE_NAME);
				INI_WriteInt(file, "HouseStorage", 0);
				INI_Close(file);
				#if GH_USE_MAPICONS == true
					DestroyDynamicMapIcon(HouseMIcon[h]);
					HouseMIcon[h] = CreateDynamicMapIcon(hInfo[h][CPOutX], hInfo[h][CPOutY], hInfo[h][CPOutZ], 31, -1, hInfo[h][SpawnWorld], hInfo[h][SpawnInterior], -1, MICON_VD);
				#endif
				UpdateHouseText(h);
				hcount++;
			}
		}
		foreach(Player, i)
		{
  			if(IsInHouse{i} == 1)
	    	{
      			ExitHouse(i, GetPVarInt(i, "LastHouseCP"));
				ShowInfoBoxEx(i, COLOUR_INFO, I_TO_PLAYERS_HSOLD);
	    	}
		}
		ShowInfoBox(playerid, I_ALLH_SOLD, hcount);
	}
    return 1;
}
//==============================================================================
// 			This command is used to change the value of a house.
//==============================================================================
CMD:changeprice(playerid, params[])
{
	new h, price;
	if(!IsPlayerAdmin(playerid)) return 0;
	if(sscanf(params, "dd", h, price)) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_CMD_USAGE_CHANGEPRICE);
	if(!fexist(HouseFile(h))) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_HID);
	if(price < MIN_HOUSE_VALUE || price > MAX_HOUSE_VALUE) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_HVALUE);
	hInfo[h][HouseValue] = price;
	new INI:file = INI_Open(HouseFile(h));
 	INI_WriteInt(file, "HouseValue", price);
 	INI_Close(file);
	ShowInfoBox(playerid, I_H_PRICE_CHANGED, h, price);
	UpdateHouseText(h);
    return 1;
}
//==============================================================================
// 		This command is used to change the value of all houses on the server.
//==============================================================================
CMD:changeallprices(playerid, params[])
{
	new hcount, INI:file, price;
	if(!IsPlayerAdmin(playerid)) return 0;
	if(sscanf(params, "d", price)) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_CMD_USAGE_CHANGEALLPRICE);
	if(price < MIN_HOUSE_VALUE || price > MAX_HOUSE_VALUE) return ShowInfoBoxEx(playerid, COLOUR_SYSTEM, E_INVALID_HVALUE);
	else
	{
	    foreach(Houses, h)
	    {
	        hInfo[h][HouseValue] = price;
			file = INI_Open(HouseFile(h));
	 		INI_WriteInt(file, "HouseValue", price);
	 		INI_Close(file);
			UpdateHouseText(h);
			hcount++;
	    }
		ShowInfoBox(playerid, I_ALLH_PRICE_CHANGED, price, hcount);
	}
    return 1;
}
CMD:ghcmds(playerid, params[])
{
	#pragma unused params
	if(!IsPlayerAdmin(playerid)) return 0;
	else return ShowPlayerDialog(playerid, HOUSEMENU-1, DIALOG_STYLE_MSGBOX, INFORMATION_HEADER, "/changeallprices\n/removeallhcars\n/sellallhouses\n/changeprice\n/changespawn\n/removehcar\n/sellhouse\n/housemenu\n/gotohouse\n/addhcar\n/changehcar\n/changehintspawn\n/createhint\n/removehint\n/ghcmds", "Close", "");
}
//##############################################################################
// 								      Callbacks
//##############################################################################
function HouseVisiting(playerid)
{
	new string[200], tmpstring[50];
	GetPVarString(playerid, "HousePrevName", tmpstring, 50);
	format(string, sizeof(string), I_HINT_VISIT_OVER, tmpstring, GetPVarInt(playerid, "HousePrevValue"));
	ShowPlayerDialog(playerid, HOUSEMENU+17, DIALOG_STYLE_MSGBOX, INFORMATION_HEADER, string, "Buy", "Cancel");
	return 1;
}
function HouseSpawning(playerid)
{
	foreach(Houses, h)
	{
		if(!strcmp(hInfo[h][HouseOwner], pNick(playerid), CASE_SENSETIVE))
		{
  			if(hInfo[h][QuitInHouse] == 1)
	    	{
			    SetPVarInt(playerid, "LastHouseCP", h);
       			SetPlayerHouseInterior(playerid, h);
       			#if GH_HOUSECARS == true
       				LoadHouseCar(h);
       			#endif
			    ShowInfoBoxEx(playerid, COLOUR_INFO, I_HMENU);
			    hInfo[h][QuitInHouse] = 0;
			    new INI:file = INI_Open(HouseFile(h));
			    INI_WriteInt(file, "QuitInHouse", 0);
			    INI_Close(file);
		    	break;
			}
		}
	}
	SetPVarInt(playerid, "FirstSpawn", 1);
	return 1;
}
function LoadHouseData(h, name[], value[])
{
    if(!strcmp(name, "HouseName", true)) { format(hInfo[h][HouseName], MAX_HOUSE_NAME, "%s", value); }
    if(!strcmp(name, "HouseOwner", true)) { format(hInfo[h][HouseOwner], MAX_PLAYER_NAME, "%s", value); }
    if(!strcmp(name, "HouseLocation", true)) { format(hInfo[h][HouseLocation], MAX_ZONE_NAME, "%s", GetHouseLocation(h)); }
    if(!strcmp(name, "HousePassword", true))
    {
        switch(strcmp(value, "INVALID_HOUSE_PASSWORD", true))
        {
			case 0: hInfo[h][HousePassword] = udb_hash(value);
			case 1: hInfo[h][HousePassword] = strval(value);
		}
	}
   	if(!strcmp(name, "SpawnOutX", true)) { hInfo[h][SpawnOutX] = floatstr(value); }
	if(!strcmp(name, "SpawnOutY", true)) { hInfo[h][SpawnOutY] = floatstr(value); }
	if(!strcmp(name, "SpawnOutZ", true)) { hInfo[h][SpawnOutZ] = floatstr(value); }
    if(!strcmp(name, "SpawnOutAngle", true)) { hInfo[h][SpawnOutAngle] = floatstr(value); }
    if(!strcmp(name, "SpawnInterior", true)) { hInfo[h][SpawnInterior] = strval(value); }
    if(!strcmp(name, "SpawnWorld", true)) { hInfo[h][SpawnWorld] = strval(value); }
    if(!strcmp(name, "CPOutX", true)) { hInfo[h][CPOutX] = floatstr(value); }
	if(!strcmp(name, "CPOutY", true)) { hInfo[h][CPOutY] = floatstr(value); }
	if(!strcmp(name, "CPOutZ", true)) { hInfo[h][CPOutZ] = floatstr(value); }
	if(!strcmp(name, "HouseValue", true)) { hInfo[h][HouseValue] = strval(value); }
	if(!strcmp(name, "HouseStorage", true)) { hInfo[h][HouseStorage] = strval(value); }
	if(!strcmp(name, "HouseInterior", true)) { hInfo[h][HouseInterior] = strval(value); }
	if(!strcmp(name, "HouseWorld", true)) { hInfo[h][SpawnWorld] = strval(value); }
	if(!strcmp(name, "HouseCar", true)) { hInfo[h][HouseCar] = strval(value); }
	if(!strcmp(name, "HCarPosX", true)) { hInfo[h][HouseCarPosX] = floatstr(value); }
	if(!strcmp(name, "HCarPosY", true)) { hInfo[h][HouseCarPosY] = floatstr(value); }
	if(!strcmp(name, "HCarPosZ", true)) { hInfo[h][HouseCarPosZ] = floatstr(value); }
	if(!strcmp(name, "HCarAngle", true)) { hInfo[h][HouseCarAngle] = floatstr(value); }
	if(!strcmp(name, "HCarModel", true)) { hInfo[h][HouseCarModel] = strval(value); }
	if(!strcmp(name, "HCarWorld", true)) { hInfo[h][HouseCarWorld] = strval(value); }
	if(!strcmp(name, "HCarInt", true)) { hInfo[h][HouseCarInterior] = strval(value); }
	if(!strcmp(name, "QuitInHouse", true)) { hInfo[h][QuitInHouse] = strval(value); }
	if(!strcmp(name, "ForSale", true)) { hInfo[h][ForSale] = strval(value); }
	if(!strcmp(name, "ForSalePrice", true)) { hInfo[h][ForSalePrice] = strval(value); }
	if(!strcmp(name, "HousePrivacy", true)) { hInfo[h][HousePrivacy] = strval(value); }
	if(!strcmp(name, "HouseAlarm", true)) { hInfo[h][HouseAlarm] = strval(value); }
	if(!strcmp(name, "HouseCamera", true)) { hInfo[h][HouseCamera] = strval(value); }
	if(!strcmp(name, "HouseDog", true)) { hInfo[h][HouseDog] = strval(value); }
	if(!strcmp(name, "HouseUpgradedLock", true)) { hInfo[h][UpgradedLock] = strval(value); }
	return 0;
}
function LoadHouseInteriorData(hint, name[], value[])
{
    if(!strcmp(name, "Name", true)) { format(hIntInfo[hint][IntName], 30, "%s", value); }
   	if(!strcmp(name, "SpawnX", true)) { hIntInfo[hint][IntSpawnX] = floatstr(value); }
	if(!strcmp(name, "SpawnY", true)) { hIntInfo[hint][IntSpawnY] = floatstr(value); }
	if(!strcmp(name, "SpawnZ", true)) { hIntInfo[hint][IntSpawnZ] = floatstr(value); }
    if(!strcmp(name, "Angle", true)) { hIntInfo[hint][IntSpawnAngle] = floatstr(value); }
    if(!strcmp(name, "CPX", true)) { hIntInfo[hint][IntCPX] = floatstr(value); }
	if(!strcmp(name, "CPY", true)) { hIntInfo[hint][IntCPY] = floatstr(value); }
	if(!strcmp(name, "CPZ", true)) { hIntInfo[hint][IntCPZ] = floatstr(value); }
	if(!strcmp(name, "Interior", true)) { hIntInfo[hint][IntInterior] = strval(value); }
	if(!strcmp(name, "Value", true)) { hIntInfo[hint][IntValue] = strval(value); }
	return 0;
}
function LoadUserData(playerid, name[], value[])
{
	if(!strcmp(name, "MoneyToGive", true)) { GivePlayerMoney(playerid, strval(value)), SetPVarInt(playerid, "GA_TMP_HOUSEFORSALEPRICE", strval(value)); }
	if(!strcmp(name, "MoneyToGiveHS", true))  { GivePlayerMoney(playerid, strval(value)), SetPVarInt(playerid, "GA_TMP_HOUSESTORAGE", strval(value)); }
	if(!strcmp(name, "HouseName", true)) { SetPVarString(playerid, "GA_TMP_HOUSENAME", value); }
	if(!strcmp(name, "HouseBuyer", true)) { SetPVarString(playerid, "GA_TMP_NEWHOUSEOWNER", value); }
	return 0;
}
INI:currentid[](name[], value[])
{
	if(!strcmp(name, "CurrentID", true)) { CurrentID = strval(value); }
    return 0;
}
function SecurityDog_ClearAnimations(playerid)
{
	return ClearAnimations(playerid);
}
//##############################################################################
// 								Functions
//##############################################################################
// 							  By [03]Garsino!
//==============================================================================
// LoadHouses();
// This function is used to load the houses.
// It creates all the checkpoints, map icons and
// 3D texts for all the houses and sets the correct 3D text information.
//==============================================================================
stock LoadHouses()
{
	new hcount, labeltext[250], countstart = GetTickCount(), INI:file;
	LoadHouseInteriors(); // Load house interiors
	Loop(h, MAX_HOUSES, 0)
	{
	    if(fexist(HouseFile(h)))
	    {
	        INI_ParseFile(HouseFile(h), "LoadHouseData", false, true, h, true, false );
		    #if GH_USE_CPS == true
		    	HouseCPOut[h] = CreateDynamicCP(hInfo[h][CPOutX], hInfo[h][CPOutY], hInfo[h][CPOutZ], 1.5, hInfo[h][SpawnWorld], hInfo[h][SpawnInterior], -1, 15.0);
			#else
				HousePickupOut[h] = CreateDynamicPickup(PICKUP_MODEL_OUT, PICKUP_TYPE, hInfo[h][CPOutX], hInfo[h][CPOutY], hInfo[h][CPOutZ], hInfo[h][SpawnWorld], hInfo[h][SpawnInterior], -1, 15.0);
			#endif
			CreateCorrectHouseExitCP(h);
		    if(!strcmp(hInfo[h][HouseOwner], INVALID_HOWNER_NAME, CASE_SENSETIVE))
		    {
		        format(labeltext, sizeof(labeltext), LABELTEXT1, hInfo[h][HouseName], hInfo[h][HouseValue], h);
                #if GH_USE_MAPICONS == true
					HouseMIcon[h] = CreateDynamicMapIcon(hInfo[h][CPOutX], hInfo[h][CPOutY], hInfo[h][CPOutZ], 31, -1, hInfo[h][SpawnWorld], hInfo[h][SpawnInterior], -1, MICON_VD);
				#endif
			}
		    if(strcmp(hInfo[h][HouseOwner], INVALID_HOWNER_NAME, CASE_SENSETIVE))
		    {
		        format(labeltext, sizeof(labeltext), LABELTEXT2, hInfo[h][HouseName], hInfo[h][HouseOwner], hInfo[h][HouseValue], YesNo(hInfo[h][ForSale]), Answer(hInfo[h][HousePrivacy], "Open", "Closed"), h);
                #if GH_USE_MAPICONS == true
					HouseMIcon[h] = CreateDynamicMapIcon(hInfo[h][CPOutX], hInfo[h][CPOutY], hInfo[h][CPOutZ], 32, -1, hInfo[h][SpawnWorld], hInfo[h][SpawnInterior], -1, MICON_VD);
				#endif
			}
			HouseLabel[h] = CreateDynamic3DTextLabel(labeltext, COLOUR_GREEN, hInfo[h][CPOutX], hInfo[h][CPOutY], hInfo[h][CPOutZ]+0.7, TEXTLABEL_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, TEXTLABEL_TESTLOS, hInfo[h][SpawnWorld], hInfo[h][SpawnInterior], -1, TEXTLABEL_DISTANCE);
            if(isnull(hIntInfo[hInfo[h][HouseInterior]][IntName]))
			{
			    hInfo[h][HouseInterior] = DEFAULT_H_INTERIOR;
			    file = INI_Open(HouseFile(h));
			    INI_WriteInt(file, "HouseInterior", DEFAULT_H_INTERIOR);
			    INI_Close(file);
			}
			Iter_Add(Houses, h);
		    hcount++;
		}
	}
	return printf("\nTotal Houses Loaded: %d. Duration: %d ms\n", hcount, (GetTickCount() - countstart));
}
//==============================================================================
// LoadHouseCar(houseid);
// This function is used to load the house car for a house.
//==============================================================================
stock LoadHouseCar(houseid)
{
	#if GH_HOUSECARS == true
		if(fexist(HouseFile(houseid)) && hInfo[houseid][HouseCar] == 1)
		{
			HCar[houseid] = CreateVehicle(hInfo[houseid][HouseCarModel], hInfo[houseid][HouseCarPosX], hInfo[houseid][HouseCarPosY], hInfo[houseid][HouseCarPosZ], hInfo[houseid][HouseCarAngle], HCAR_COLOUR1, HCAR_COLOUR2, HCAR_RESPAWN);
			SetVehicleVirtualWorld(HCar[houseid], hInfo[houseid][HouseCarWorld]);
			LinkVehicleToInterior(HCar[houseid], hInfo[houseid][HouseCarInterior]);
		}
	#endif
	return 1;
}
//==============================================================================
// UnloadHouseCar(houseid);
// This function is used to the unload house car for a house.
//==============================================================================
stock UnloadHouseCar(houseid)
{
	#if GH_HOUSECARS == false
	    #pragma unused houseid
	#else
		if(fexist(HouseFile(houseid)) && hInfo[houseid][HouseCar] == 1)
		{
		    if(GetVehicleModel(HCar[houseid]) >= 400 && GetVehicleModel(HCar[houseid]) <= 611 && HCar[houseid] >= 1)
			{
			    DestroyVehicle(HCar[houseid]);
			    HCar[houseid] = -1;
			}
		}
	#endif
	return 1;
}
//==============================================================================
// SaveHouseCar(houseid);
// This function is used to check if there is any vehicles
// near the housecar spawn.
//==============================================================================
stock SaveHouseCar(houseid)
{
	#if GH_HOUSECARS == true
	if(fexist(HouseFile(houseid)) && hInfo[houseid][HouseCar] == 1)
	{
 		Loop(v, MAX_VEHICLES, 0)
		{
			if(GetVehicleModel(v) < 400 || GetVehicleModel(v) > 611 || IsVehicleOccupied(v)) continue;
   			GetVehiclePos(v, X, Y, Z);
   			if(PointInRangeOfPoint(HCAR_RANGE, X, Y, Z, hInfo[houseid][HouseCarPosX], hInfo[houseid][HouseCarPosY], hInfo[houseid][HouseCarPosZ]))
   			{
			        new INI:file = INI_Open(HouseFile(houseid));
			        INI_WriteInt(file, "HCarModel", GetVehicleModel(v));
			        INI_Close(file);
			        DestroyVehicle(v);
			        break;
   			}
		}
	}
	#endif
	return 1;
}
//==============================================================================
// LoadHouseInteriors();
// This function is used to load the house interior datas from the files.
//==============================================================================
stock LoadHouseInteriors()
{
	new hintcount, filename[HOUSEFILE_LENGTH], countstart = GetTickCount();
	Loop(hint, MAX_HOUSE_INTERIORS, 0)
	{
	    format(filename, sizeof(filename), HINT_FILEPATH, hint);
	    if(fexist(filename))
	    {
	        INI_ParseFile(filename, "LoadHouseInteriorData", false, true, hint, true, false);
		    hintcount++;
		}
	}
	return printf("\nTotal House Interiors Loaded: %d. Duration: %d ms\n", hintcount, (GetTickCount() - countstart));
}
//==============================================================================
// GetOwnedHouses(playerid);
// This function is used to find out how many houses a player owns
//==============================================================================
stock GetOwnedHouses(playerid)
{
	new tmpcount;
	foreach(Houses, h)
	{
	    if(!strcmp(hInfo[h][HouseOwner], pNick(playerid), CASE_SENSETIVE))
	    {
     		tmpcount++;
		}
	}
	return tmpcount;
}
//==============================================================================
// GetHouseOwnerEx(houseid);
// This function is used to get the house owner of a house
// and return the playerid, it will return INVALID_PLAYER_ID
// if the house owner is not connected
//==============================================================================
stock GetHouseOwnerEx(houseid)
{
 	if(fexist(HouseFile(houseid)))
  	{
   		foreach(Character, i)
   		{
	    	if(!strcmp(pNick(i), hInfo[houseid][HouseOwner], CASE_SENSETIVE))
   			{
      			return i;
   			}
		}
	}
	return INVALID_PLAYER_ID;
}
//==============================================================================
// ReturnPlayerHouseID(playerid, houseslot);
// This function is used to return the house id from a players house 'slot'
// Example: ReturnPlayerHouseID(playerid, 0);
// Would return for example house ID 500.
//==============================================================================
stock ReturnPlayerHouseID(playerid, houseslot)
{
	new tmpcount;
	if(houseslot < 1 && houseslot > MAX_HOUSES_OWNED) return -1;
	foreach(Houses, h)
	{
	    if(!strcmp(pNick(playerid), hInfo[h][HouseOwner], CASE_SENSETIVE))
	    {
     		tmpcount++;
       		if(tmpcount == houseslot)
       		{
        		return h;
  			}
	    }
	}
	return -1;
}
//==============================================================================
// UnloadHouses();
// This function is used to unload the houses.
// It deletes all the checkpoints, map icons and 3D texts for all the houses.
//==============================================================================
stock UnloadHouses()
{
	foreach(Houses, h)
	{
		DestroyHouseEntrance(h, TYPE_OUT);
		DestroyHouseEntrance(h, TYPE_INT);
		#if GH_USE_MAPICONS == true
			DestroyDynamicMapIcon(HouseMIcon[h]);
		#endif
		DestroyDynamic3DTextLabel(HouseLabel[h]);
		#if GH_HOUSECARS == true
			UnloadHouseCar(h);
		#endif
	}
	Iter_Clear(Houses);
	return 1;
}
//==============================================================================
// IsHouseInRangeOfHouse(house, house2, Float:range);
// This function is used to check if a house is in range of another house
// Default range is 250.0
//==============================================================================
stock IsHouseInRangeOfHouse(house, house2, Float:range = 250.0)
{
	if(fexist(HouseFile(house)) && fexist(HouseFile(house2)))
	{
		if(PointInRangeOfPoint(range, hInfo[house][CPOutX], hInfo[house][CPOutY], hInfo[house][CPOutZ], hInfo[house2][CPOutX], hInfo[house2][CPOutY], hInfo[house2][CPOutZ]))
		{
		    return 1;
		}
	}
	return 0;
}
//==============================================================================
// CreateCorrectHouseExitCP(houseid);
// This function is used to create the correct house exit checkpoint for the houseid
// based on the house interior ID
//==============================================================================
stock CreateCorrectHouseExitCP(houseid)
{
    new _int = hInfo[houseid][HouseInterior];
    #if GH_USE_CPS == true
		HouseCPInt[houseid] = CreateDynamicCP(hIntInfo[_int][IntCPX], hIntInfo[_int][IntCPY], hIntInfo[_int][IntCPZ], 1.5, (houseid + 1000), hIntInfo[_int][IntInterior], -1, 15.0);
	#else
		HousePickupInt[houseid] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, hIntInfo[_int][IntCPX], hIntInfo[_int][IntCPY], hIntInfo[_int][IntCPZ], (houseid + 1000), hIntInfo[_int][IntInterior], -1, 15.0);
	#endif
	return 1;
}
//==============================================================================
// SetPlayerHouseInterior(playerid, house);
// This function is used to set the correct house interior for a player when he enters a house or buy a new house interior.
//==============================================================================
stock SetPlayerHouseInterior(playerid, houseid)
{
    new _int = hInfo[houseid][HouseInterior];
	SetPVarInt(playerid, "IsInHouse", 1), IsInHouse{playerid} = 1;
	SetPlayerPosEx(playerid, hIntInfo[_int][IntSpawnX], hIntInfo[_int][IntSpawnY], hIntInfo[_int][IntSpawnZ], hIntInfo[_int][IntInterior], (houseid + 1000));
	SetPlayerFacingAngle(playerid, hIntInfo[_int][IntSpawnAngle]);
}
//==============================================================================
// pNick(playerid);
// Used to get the name of a player.
//==============================================================================
stock pNick(playerid)
{
	new GHNick[MAX_PLAYER_NAME];
	GetPlayerName(playerid, GHNick, MAX_PLAYER_NAME);
 	return GHNick;
}
//==============================================================================
// PointInRangeOfPoint(Float:range, Float:x2, Float:y2, Float:z2, Float:X2, Float:Y2, Float:Z2);
// Used to check if a point is in range of another point.
// Credits to whoever made this!
//==============================================================================
stock PointInRangeOfPoint(Float:range, Float:x2, Float:y2, Float:z2, Float:X2, Float:Y2, Float:Z2)
{
    X2 -= x2, Y2 -= y2, Z2 -= z2;
    return ((X2 * X2) + (Y2 * Y2) + (Z2 * Z2)) < (range * range);
}
//==============================================================================
// ReturnProcent(Float:amount, Float:procent);
// Used to return the procent of an value.
//==============================================================================
stock ReturnProcent(Float:amount, Float:procent) return floatround(((amount / 100) * procent));
//==============================================================================
// SetPlayerPosEx(playerid, Float:posX, Float:posY, Float:posZ, Interior = 0, World = 0);
// Used to set the position of a player with optional interiorid and worldid parameters
//==============================================================================
stock SetPlayerPosEx(playerid, Float:posX, Float:posY, Float:posZ, Interior = 0, World = 0)
{
	SetPlayerVirtualWorld(playerid, World), SetPlayerInterior(playerid, Interior), SetPlayerPos(playerid, posX, posY, posZ), SetCameraBehindPlayer(playerid);
	return 1;
}
//==============================================================================
// GetFreeHouseID();
// Used to get the next free house ID. Will return -1 if there is none free.
//==============================================================================
stock GetFreeHouseID()
{
    Loop(h, MAX_HOUSES, 0)
    {
        if(!fexist(HouseFile(h)))
        {
            return h;
		}
	}
    return -1;
}
//==============================================================================
// GetFreeInteriorID();
// Used to get the next free house interior ID. Will return -1 if there is none free.
//==============================================================================
stock GetFreeInteriorID()
{
	new filename[INTERIORFILE_LENGTH];
    Loop(hint, MAX_HOUSE_INTERIORS, 0)
    {
        format(filename, sizeof(filename), HINT_FILEPATH, hint);
        if(!fexist(filename))
        {
            return hint;
		}
	}
    return -1;
}
//==============================================================================
// GetTotalHouses();
// Used to get the amount of existing houses.
//==============================================================================
stock GetTotalHouses() return Iter_Count(Houses);
//==============================================================================
// IsHouseInteriorValid(houseinterior);
// Used to check if a house interior does exist.
//==============================================================================
stock IsHouseInteriorValid(houseinterior)
{
	new filename[INTERIORFILE_LENGTH];
	format(filename, sizeof(filename), HINT_FILEPATH, houseinterior);
	return fexist(filename);
}
//==============================================================================
// UpdateHouseText();
// Updates the 3D text label.
//==============================================================================
stock UpdateHouseText(houseid)
{
	new labeltext[250];
	if(fexist(HouseFile(houseid)))
	{
	    switch(strcmp(INVALID_HOWNER_NAME, hInfo[houseid][HouseOwner], CASE_SENSETIVE))
	    {
	        case 0: format(labeltext, sizeof(labeltext), LABELTEXT1, hInfo[houseid][HouseName], hInfo[houseid][HouseValue], houseid);
	        case 1: format(labeltext, sizeof(labeltext), LABELTEXT2, hInfo[houseid][HouseName], hInfo[houseid][HouseOwner], hInfo[houseid][HouseValue], YesNo(hInfo[houseid][ForSale]), Answer(hInfo[houseid][HousePrivacy], "Open", "Closed"), houseid);
	    }
		UpdateDynamic3DTextLabelText(HouseLabel[houseid], COLOUR_GREEN, labeltext);
    }
}
//==============================================================================
// AddS(amount);
// By [03]Garsino.
//==============================================================================
stock AddS(amount)
{
	new returnstring[2];
	format(returnstring, 2, "");
	if(amount != 1 && amount != -1)
	{
	    format(returnstring, 2, "s");
	}
	return returnstring;
}
//==============================================================================
// GetSecondsBetweenAction(action);
// By [03]Garsino.
//==============================================================================
stock GetSecondsBetweenAction(action) return floatround(floatdiv((GetTickCount() - action), 1000), floatround_tozero);
//==============================================================================
// DestroyHouseEntrance(houseid, type);
// Destroys the house entrance of a house (pickup or checkpoint).
// Type can be: TYPE_OUT (0) and TYPE_INT (1)
// By [03]Garsino.
//==============================================================================
stock DestroyHouseEntrance(houseid, type)
{
	#if GH_USE_CPS == true
		if(type == TYPE_OUT) { DestroyDynamicCP(HouseCPOut[houseid]); }
		if(type == TYPE_INT) { DestroyDynamicCP(HouseCPInt[houseid]); }
	#else
		if(type == TYPE_OUT) { DestroyDynamicPickup(HousePickupOut[houseid]); }
		if(type == TYPE_INT) { DestroyDynamicPickup(HousePickupInt[houseid]); }
	#endif
	return 1;
}
//==============================================================================
// IsVehicleOccupied(vehicleid);
// Checks if a vehicle is occupied or not.
// By [03]Garsino.
//==============================================================================
stock IsVehicleOccupied(vehicleid)
{
  	foreach(Player, i)
	{
		if(IsPlayerInVehicle(i, vehicleid))
		{
			return 1;
		}
	}
	return 0;
}
//==============================================================================
stock CountPlayersInHouse(houseid)
{
	new count;
	foreach(Player, i)
	{
	    if(!IsPlayerInHouse(i, houseid)) continue;
		count++;
	}
	return count;
}
stock ShowInfoBoxEx(playerid, colour, message[])
{
	new HugeAssString[1000];
	format(HugeAssString, sizeof(HugeAssString), "{%06x}%s", (colour >>> 8), message);
	return ShowPlayerDialog(playerid, (HOUSEMENU-1), DIALOG_STYLE_MSGBOX, INFORMATION_HEADER, HugeAssString, "Close", "");
}
stock DeletePVars(playerid)
{
	DeletePVar(playerid, "LastHouseCP"), DeletePVar(playerid, "IsInHouse"), DeletePVar(playerid, "FirstSpawn");
	DeletePVar(playerid, "GA_TMP_HOUSESTORAGE"), DeletePVar(playerid, "GA_TMP_NEWHOUSEOWNER"), DeletePVar(playerid, "GA_TMP_HOUSEFORSALEPRICE"), DeletePVar(playerid, "GA_TMP_HOUSENAME");
	DeletePVar(playerid, "JustCreatedHouse"), DeletePVar(playerid, "HousePreview"), DeletePVar(playerid, "HousePrevValue"), DeletePVar(playerid, "HousePrevName");
	DeletePVar(playerid, "HousePrevInt"), DeletePVar(playerid, "HouseIntUpgradeMod"), DeletePVar(playerid, "IsHouseVisiting"), DeletePVar(playerid, "ChangeHouseInt");
	DeletePVar(playerid, "HousePrevTime"), DeletePVar(playerid, "HousePrevTimer"), DeletePVar(playerid, "OldHouseInt"), DeletePVar(playerid, "ClickedHouse");
	DeletePVar(playerid, "ClickedPlayer"), DeletePVar(playerid, "TimeSinceHouseBreakin");
	DeletePVar(playerid, "IsRobbingHouse"), DeletePVar(playerid, "HouseRobberyTime"), DeletePVar(playerid, "HouseRobberyTimer"), DeletePVar(playerid, "TimeSinceHouseRobbery");
	return 1;
}
stock fcreate(filename[])
{
    if(fexist(filename)) return 0;
    new File:file = fopen(filename, io_write);
    fclose(file);
    return 1;
}
stock RandomEx(min, max) return (random((max - min)) + min);
stock ExitHouse(playerid, houseid)
{
    if(!IsPlayerInHouse(playerid, houseid)) return 1;
	DeletePVar(playerid, "IsInHouse");
	IsInHouse{playerid} = 0;
 	SetPlayerPosEx(playerid, hInfo[houseid][SpawnOutX], hInfo[houseid][SpawnOutY], hInfo[houseid][SpawnOutZ], hInfo[houseid][SpawnInterior], hInfo[houseid][SpawnWorld]);
  	SetPlayerFacingAngle(playerid, hInfo[houseid][SpawnOutAngle]);
	SetPlayerInterior(playerid, hInfo[houseid][SpawnInterior]);
	SetPlayerVirtualWorld(playerid, hInfo[houseid][SpawnWorld]);
	if(GetPVarInt(playerid, "IsRobbingHouse") == 1)
	{
	    ShowInfoBox(playerid, I_HROB_FAILED_HEXIT, hInfo[houseid][HouseName]);
		EndHouseRobbery(playerid);
		SetPVarInt(playerid, "IsRobbingHouse", 0);
		SetPVarInt(playerid, "TimeSinceHouseRobbery", GetTickCount());
	}
 	return 1;
}
stock udb_hash(buf[]) // By DracoBlue
{
	new length = strlen(buf), s1 = 1, s2;
	Loop(n, length, 0)
    {
       s1 = (s1 + buf[n]) % 65521, s2 = (s2 + s1)     % 65521;
    }
    return (s2 << 16) + s1;
}
enum SAZONE_MAIN { SAZONE_NAME[28], Float:SAZONE_AREA[6] }; // By BetaMaster
static const gSAZones[][SAZONE_MAIN] =
{ 
	{"24/7",	                	{-34.23,-186.02,1003.54,-4.24,-169.91,1003.54}},
	{"The Big Ear",	                {-410.00,1403.30,-3.00,-137.90,1681.20,200.00}},
	{"Aldea Malvada",               {-1372.10,2498.50,0.00,-1277.50,2615.30,200.00}},
	{"Angel Pine",                  {-2324.90,-2584.20,-6.10,-1964.20,-2212.10,200.00}},
	{"Arco del Oeste",              {-901.10,2221.80,0.00,-592.00,2571.90,200.00}},
	{"Avispa Country Club",         {-2646.40,-355.40,0.00,-2270.00,-222.50,200.00}},
	{"Avispa Country Club",         {-2831.80,-430.20,-6.10,-2646.40,-222.50,200.00}},
	{"Avispa Country Club",         {-2361.50,-417.10,0.00,-2270.00,-355.40,200.00}},
	{"Avispa Country Club",         {-2667.80,-302.10,-28.80,-2646.40,-262.30,71.10}},
	{"Avispa Country Club",         {-2470.00,-355.40,0.00,-2270.00,-318.40,46.10}},
	{"Avispa Country Club",         {-2550.00,-355.40,0.00,-2470.00,-318.40,39.70}},
	{"Back o' Beyond",               {-1166.90,-2641.10,0.00,-321.70,-1856.00,200.00}},
	{"Bar",               	        {487.65,-88.76,998.75,512.06,-67.74,999.25}},
	{"Battery Point",               {-2741.00,1268.40,-4.50,-2533.00,1490.40,200.00}},
	{"Bayside",                     {-2741.00,2175.10,0.00,-2353.10,2722.70,200.00}},
	{"Bayside Marina",              {-2353.10,2275.70,0.00,-2153.10,2475.70,200.00}},
	{"Beacon Hill",                 {-399.60,-1075.50,-1.40,-319.00,-977.50,198.50}},
	{"Blackfield",                  {964.30,1203.20,-89.00,1197.30,1403.20,110.90}},
	{"Blackfield",                  {964.30,1403.20,-89.00,1197.30,1726.20,110.90}},
	{"Blackfield Chapel",           {1375.60,596.30,-89.00,1558.00,823.20,110.90}},
	{"Blackfield Chapel",           {1325.60,596.30,-89.00,1375.60,795.00,110.90}},
	{"Blackfield Intersection",     {1197.30,1044.60,-89.00,1277.00,1163.30,110.90}},
	{"Blackfield Intersection",     {1166.50,795.00,-89.00,1375.60,1044.60,110.90}},
	{"Blackfield Intersection",     {1277.00,1044.60,-89.00,1315.30,1087.60,110.90}},
	{"Blackfield Intersection",     {1375.60,823.20,-89.00,1457.30,919.40,110.90}},
	{"Blueberry",                   {104.50,-220.10,2.30,349.60,152.20,200.00}},
	{"Blueberry",                   {19.60,-404.10,3.80,349.60,-220.10,200.00}},
	{"Blueberry Acres",             {-319.60,-220.10,0.00,104.50,293.30,200.00}},
	{"Caligula's Casino",           {2087.30,1543.20,-89.00,2437.30,1703.20,110.90}},
	{"Caligula's Casino",           {2137.40,1703.20,-89.00,2437.30,1783.20,110.90}},
	{"Calton Heights",              {-2274.10,744.10,-6.10,-1982.30,1358.90,200.00}},
	{"Chinatown",                   {-2274.10,578.30,-7.60,-2078.60,744.10,200.00}},
	{"City Hall",                   {-2867.80,277.40,-9.10,-2593.40,458.40,200.00}},
	{"Come-A-Lot",                  {2087.30,943.20,-89.00,2623.10,1203.20,110.90}},
	{"Commerce",                    {1323.90,-1842.20,-89.00,1701.90,-1722.20,110.90}},
	{"Commerce",                    {1323.90,-1722.20,-89.00,1440.90,-1577.50,110.90}},
	{"Commerce",                    {1370.80,-1577.50,-89.00,1463.90,-1384.90,110.90}},
	{"Commerce",                    {1463.90,-1577.50,-89.00,1667.90,-1430.80,110.90}},
	{"Commerce",                    {1583.50,-1722.20,-89.00,1758.90,-1577.50,110.90}},
	{"Commerce",                    {1667.90,-1577.50,-89.00,1812.60,-1430.80,110.90}},
	{"Conference Center",           {1046.10,-1804.20,-89.00,1323.90,-1722.20,110.90}},
	{"Conference Center",           {1073.20,-1842.20,-89.00,1323.90,-1804.20,110.90}},
	{"Cranberry Station",           {-2007.80,56.30,0.00,-1922.00,224.70,100.00}},
	{"Creek",                       {2749.90,1937.20,-89.00,2921.60,2669.70,110.90}},
	{"Dillimore",                   {580.70,-674.80,-9.50,861.00,-404.70,200.00}},
	{"Downtown San Fierro",         {-2270.00,-324.10,-0.00,-1794.90,-222.50,200.00}},
	{"Downtown San Fierro",         {-2173.00,-222.50,-0.00,-1794.90,265.20,200.00}},
	{"Downtown San Fierro",         {-1982.30,744.10,-6.10,-1871.70,1274.20,200.00}},
	{"Downtown San Fierro",         {-1871.70,1176.40,-4.50,-1620.30,1274.20,200.00}},
	{"Downtown San Fierro",         {-1700.00,744.20,-6.10,-1580.00,1176.50,200.00}},
	{"Downtown San Fierro",         {-1580.00,744.20,-6.10,-1499.80,1025.90,200.00}},
	{"Downtown San Fierro",         {-2078.60,578.30,-7.60,-1499.80,744.20,200.00}},
	{"Downtown San Fierro",         {-1993.20,265.20,-9.10,-1794.90,578.30,200.00}},
	{"Downtown Los Santos",         {1463.90,-1430.80,-89.00,1724.70,-1290.80,110.90}},
	{"Downtown Los Santos",         {1724.70,-1430.80,-89.00,1812.60,-1250.90,110.90}},
	{"Downtown Los Santos",         {1463.90,-1290.80,-89.00,1724.70,-1150.80,110.90}},
	{"Downtown Los Santos",         {1370.80,-1384.90,-89.00,1463.90,-1170.80,110.90}},
	{"Downtown Los Santos",         {1724.70,-1250.90,-89.00,1812.60,-1150.80,110.90}},
	{"Downtown Los Santos",         {1370.80,-1170.80,-89.00,1463.90,-1130.80,110.90}},
	{"Downtown Los Santos",         {1378.30,-1130.80,-89.00,1463.90,-1026.30,110.90}},
	{"Downtown Los Santos",         {1391.00,-1026.30,-89.00,1463.90,-926.90,110.90}},
	{"Downtown Los Santos",         {1507.50,-1385.20,110.90,1582.50,-1325.30,335.90}},
	{"East Beach",                  {2632.80,-1852.80,-89.00,2959.30,-1668.10,110.90}},
	{"East Beach",                  {2632.80,-1668.10,-89.00,2747.70,-1393.40,110.90}},
	{"East Beach",                  {2747.70,-1668.10,-89.00,2959.30,-1498.60,110.90}},
	{"East Beach",                  {2747.70,-1498.60,-89.00,2959.30,-1120.00,110.90}},
	{"East Los Santos",             {2421.00,-1628.50,-89.00,2632.80,-1454.30,110.90}},
	{"East Los Santos",             {2222.50,-1628.50,-89.00,2421.00,-1494.00,110.90}},
	{"East Los Santos",             {2266.20,-1494.00,-89.00,2381.60,-1372.00,110.90}},
	{"East Los Santos",             {2381.60,-1494.00,-89.00,2421.00,-1454.30,110.90}},
	{"East Los Santos",             {2281.40,-1372.00,-89.00,2381.60,-1135.00,110.90}},
	{"East Los Santos",             {2381.60,-1454.30,-89.00,2462.10,-1135.00,110.90}},
	{"East Los Santos",             {2462.10,-1454.30,-89.00,2581.70,-1135.00,110.90}},
	{"Easter Basin",                {-1794.90,249.90,-9.10,-1242.90,578.30,200.00}},
	{"Easter Basin",                {-1794.90,-50.00,-0.00,-1499.80,249.90,200.00}},
	{"Easter Bay Airport",          {-1499.80,-50.00,-0.00,-1242.90,249.90,200.00}},
	{"Easter Bay Airport",          {-1794.90,-730.10,-3.00,-1213.90,-50.00,200.00}},
	{"Easter Bay Airport",          {-1213.90,-730.10,0.00,-1132.80,-50.00,200.00}},
	{"Easter Bay Airport",          {-1242.90,-50.00,0.00,-1213.90,578.30,200.00}},
	{"Easter Bay Airport",          {-1213.90,-50.00,-4.50,-947.90,578.30,200.00}},
	{"Easter Bay Airport",          {-1315.40,-405.30,15.40,-1264.40,-209.50,25.40}},
	{"Easter Bay Airport",          {-1354.30,-287.30,15.40,-1315.40,-209.50,25.40}},
	{"Easter Bay Airport",          {-1490.30,-209.50,15.40,-1264.40,-148.30,25.40}},
	{"Easter Bay Chemicals",        {-1132.80,-768.00,0.00,-956.40,-578.10,200.00}},
	{"Easter Bay Chemicals",        {-1132.80,-787.30,0.00,-956.40,-768.00,200.00}},
	{"El Castillo del Diablo",      {-464.50,2217.60,0.00,-208.50,2580.30,200.00}},
	{"El Castillo del Diablo",      {-208.50,2123.00,-7.60,114.00,2337.10,200.00}},
	{"El Castillo del Diablo",      {-208.50,2337.10,0.00,8.40,2487.10,200.00}},
	{"El Corona",                   {1812.60,-2179.20,-89.00,1970.60,-1852.80,110.90}},
	{"El Corona",                   {1692.60,-2179.20,-89.00,1812.60,-1842.20,110.90}},
	{"El Quebrados",                {-1645.20,2498.50,0.00,-1372.10,2777.80,200.00}},
	{"Esplanade East",              {-1620.30,1176.50,-4.50,-1580.00,1274.20,200.00}},
	{"Esplanade East",              {-1580.00,1025.90,-6.10,-1499.80,1274.20,200.00}},
	{"Esplanade East",              {-1499.80,578.30,-79.60,-1339.80,1274.20,20.30}},
	{"Esplanade North",             {-2533.00,1358.90,-4.50,-1996.60,1501.20,200.00}},
	{"Esplanade North",             {-1996.60,1358.90,-4.50,-1524.20,1592.50,200.00}},
	{"Esplanade North",             {-1982.30,1274.20,-4.50,-1524.20,1358.90,200.00}},
	{"Fallen Tree",                 {-792.20,-698.50,-5.30,-452.40,-380.00,200.00}},
	{"Fallow Bridge",               {434.30,366.50,0.00,603.00,555.60,200.00}},
	{"Fern Ridge",                  {508.10,-139.20,0.00,1306.60,119.50,200.00}},
	{"Financial",                   {-1871.70,744.10,-6.10,-1701.30,1176.40,300.00}},
	{"Fisher's Lagoon",             {1916.90,-233.30,-100.00,2131.70,13.80,200.00}},
	{"Flint Intersection",          {-187.70,-1596.70,-89.00,17.00,-1276.60,110.90}},
	{"Flint Range",                 {-594.10,-1648.50,0.00,-187.70,-1276.60,200.00}},
	{"Fort Carson",                 {-376.20,826.30,-3.00,123.70,1220.40,200.00}},
	{"Foster Valley",               {-2270.00,-430.20,-0.00,-2178.60,-324.10,200.00}},
	{"Foster Valley",               {-2178.60,-599.80,-0.00,-1794.90,-324.10,200.00}},
	{"Foster Valley",               {-2178.60,-1115.50,0.00,-1794.90,-599.80,200.00}},
	{"Foster Valley",               {-2178.60,-1250.90,0.00,-1794.90,-1115.50,200.00}},
	{"Frederick Bridge",            {2759.20,296.50,0.00,2774.20,594.70,200.00}},
	{"Gant Bridge",                 {-2741.40,1659.60,-6.10,-2616.40,2175.10,200.00}},
	{"Gant Bridge",                 {-2741.00,1490.40,-6.10,-2616.40,1659.60,200.00}},
	{"Ganton",                      {2222.50,-1852.80,-89.00,2632.80,-1722.30,110.90}},
	{"Ganton",                      {2222.50,-1722.30,-89.00,2632.80,-1628.50,110.90}},
	{"Garcia",                      {-2411.20,-222.50,-0.00,-2173.00,265.20,200.00}},
	{"Garcia",                      {-2395.10,-222.50,-5.30,-2354.00,-204.70,200.00}},
	{"Garver Bridge",               {-1339.80,828.10,-89.00,-1213.90,1057.00,110.90}},
	{"Garver Bridge",               {-1213.90,950.00,-89.00,-1087.90,1178.90,110.90}},
	{"Garver Bridge",               {-1499.80,696.40,-179.60,-1339.80,925.30,20.30}},
	{"Glen Park",                   {1812.60,-1449.60,-89.00,1996.90,-1350.70,110.90}},
	{"Glen Park",                   {1812.60,-1100.80,-89.00,1994.30,-973.30,110.90}},
	{"Glen Park",                   {1812.60,-1350.70,-89.00,2056.80,-1100.80,110.90}},
	{"Green Palms",                 {176.50,1305.40,-3.00,338.60,1520.70,200.00}},
	{"Greenglass College",          {964.30,1044.60,-89.00,1197.30,1203.20,110.90}},
	{"Greenglass College",          {964.30,930.80,-89.00,1166.50,1044.60,110.90}},
	{"Hampton Barns",               {603.00,264.30,0.00,761.90,366.50,200.00}},
	{"Hankypanky Point",            {2576.90,62.10,0.00,2759.20,385.50,200.00}},
	{"Harry Gold Parkway",          {1777.30,863.20,-89.00,1817.30,2342.80,110.90}},
	{"Hashbury",                    {-2593.40,-222.50,-0.00,-2411.20,54.70,200.00}},
	{"Hilltop Farm",                {967.30,-450.30,-3.00,1176.70,-217.90,200.00}},
	{"Hunter Quarry",               {337.20,710.80,-115.20,860.50,1031.70,203.70}},
	{"Idlewood",                    {1812.60,-1852.80,-89.00,1971.60,-1742.30,110.90}},
	{"Idlewood",                    {1812.60,-1742.30,-89.00,1951.60,-1602.30,110.90}},
	{"Idlewood",                    {1951.60,-1742.30,-89.00,2124.60,-1602.30,110.90}},
	{"Idlewood",                    {1812.60,-1602.30,-89.00,2124.60,-1449.60,110.90}},
	{"Idlewood",                    {2124.60,-1742.30,-89.00,2222.50,-1494.00,110.90}},
	{"Idlewood",                    {1971.60,-1852.80,-89.00,2222.50,-1742.30,110.90}},
	{"Jefferson",                   {1996.90,-1449.60,-89.00,2056.80,-1350.70,110.90}},
	{"Jefferson",                   {2124.60,-1494.00,-89.00,2266.20,-1449.60,110.90}},
	{"Jefferson",                   {2056.80,-1372.00,-89.00,2281.40,-1210.70,110.90}},
	{"Jefferson",                   {2056.80,-1210.70,-89.00,2185.30,-1126.30,110.90}},
	{"Jefferson",                   {2185.30,-1210.70,-89.00,2281.40,-1154.50,110.90}},
	{"Jefferson",                   {2056.80,-1449.60,-89.00,2266.20,-1372.00,110.90}},
	{"Julius Thruway East",         {2623.10,943.20,-89.00,2749.90,1055.90,110.90}},
	{"Julius Thruway East",         {2685.10,1055.90,-89.00,2749.90,2626.50,110.90}},
	{"Julius Thruway East",         {2536.40,2442.50,-89.00,2685.10,2542.50,110.90}},
	{"Julius Thruway East",         {2625.10,2202.70,-89.00,2685.10,2442.50,110.90}},
	{"Julius Thruway North",        {2498.20,2542.50,-89.00,2685.10,2626.50,110.90}},
	{"Julius Thruway North",        {2237.40,2542.50,-89.00,2498.20,2663.10,110.90}},
	{"Julius Thruway North",        {2121.40,2508.20,-89.00,2237.40,2663.10,110.90}},
	{"Julius Thruway North",        {1938.80,2508.20,-89.00,2121.40,2624.20,110.90}},
	{"Julius Thruway North",        {1534.50,2433.20,-89.00,1848.40,2583.20,110.90}},
	{"Julius Thruway North",        {1848.40,2478.40,-89.00,1938.80,2553.40,110.90}},
	{"Julius Thruway North",        {1704.50,2342.80,-89.00,1848.40,2433.20,110.90}},
	{"Julius Thruway North",        {1377.30,2433.20,-89.00,1534.50,2507.20,110.90}},
	{"Julius Thruway South",        {1457.30,823.20,-89.00,2377.30,863.20,110.90}},
	{"Julius Thruway South",        {2377.30,788.80,-89.00,2537.30,897.90,110.90}},
	{"Julius Thruway West",         {1197.30,1163.30,-89.00,1236.60,2243.20,110.90}},
	{"Julius Thruway West",         {1236.60,2142.80,-89.00,1297.40,2243.20,110.90}},
	{"Juniper Hill",                {-2533.00,578.30,-7.60,-2274.10,968.30,200.00}},
	{"Juniper Hollow",              {-2533.00,968.30,-6.10,-2274.10,1358.90,200.00}},
	{"K.A.C.C. Military Fuels",     {2498.20,2626.50,-89.00,2749.90,2861.50,110.90}},
	{"Kincaid Bridge",              {-1339.80,599.20,-89.00,-1213.90,828.10,110.90}},
	{"Kincaid Bridge",              {-1213.90,721.10,-89.00,-1087.90,950.00,110.90}},
	{"Kincaid Bridge",              {-1087.90,855.30,-89.00,-961.90,986.20,110.90}},
	{"King's",                      {-2329.30,458.40,-7.60,-1993.20,578.30,200.00}},
	{"King's",                      {-2411.20,265.20,-9.10,-1993.20,373.50,200.00}},
	{"King's",                      {-2253.50,373.50,-9.10,-1993.20,458.40,200.00}},
	{"LVA Freight Depot",           {1457.30,863.20,-89.00,1777.40,1143.20,110.90}},
	{"LVA Freight Depot",           {1375.60,919.40,-89.00,1457.30,1203.20,110.90}},
	{"LVA Freight Depot",           {1277.00,1087.60,-89.00,1375.60,1203.20,110.90}},
	{"LVA Freight Depot",           {1315.30,1044.60,-89.00,1375.60,1087.60,110.90}},
	{"LVA Freight Depot",           {1236.60,1163.40,-89.00,1277.00,1203.20,110.90}},
	{"Las Barrancas",               {-926.10,1398.70,-3.00,-719.20,1634.60,200.00}},
	{"Las Brujas",                  {-365.10,2123.00,-3.00,-208.50,2217.60,200.00}},
	{"Las Colinas",                 {1994.30,-1100.80,-89.00,2056.80,-920.80,110.90}},
	{"Las Colinas",                 {2056.80,-1126.30,-89.00,2126.80,-920.80,110.90}},
	{"Las Colinas",                 {2185.30,-1154.50,-89.00,2281.40,-934.40,110.90}},
	{"Las Colinas",                 {2126.80,-1126.30,-89.00,2185.30,-934.40,110.90}},
	{"Las Colinas",                 {2747.70,-1120.00,-89.00,2959.30,-945.00,110.90}},
	{"Las Colinas",                 {2632.70,-1135.00,-89.00,2747.70,-945.00,110.90}},
	{"Las Colinas",                 {2281.40,-1135.00,-89.00,2632.70,-945.00,110.90}},
	{"Las Payasadas",               {-354.30,2580.30,2.00,-133.60,2816.80,200.00}},
	{"Las Venturas Airport",        {1236.60,1203.20,-89.00,1457.30,1883.10,110.90}},
	{"Las Venturas Airport",        {1457.30,1203.20,-89.00,1777.30,1883.10,110.90}},
	{"Las Venturas Airport",        {1457.30,1143.20,-89.00,1777.40,1203.20,110.90}},
	{"Las Venturas Airport",        {1515.80,1586.40,-12.50,1729.90,1714.50,87.50}},
	{"Last Dime Motel",             {1823.00,596.30,-89.00,1997.20,823.20,110.90}},
	{"Leafy Hollow",                {-1166.90,-1856.00,0.00,-815.60,-1602.00,200.00}},
	{"Liberty City",                {-1000.00,400.00,1300.00,-700.00,600.00,1400.00}},
	{"Lil' Probe Inn",              {-90.20,1286.80,-3.00,153.80,1554.10,200.00}},
	{"Linden Side",                 {2749.90,943.20,-89.00,2923.30,1198.90,110.90}},
	{"Linden Station",              {2749.90,1198.90,-89.00,2923.30,1548.90,110.90}},
	{"Linden Station",              {2811.20,1229.50,-39.50,2861.20,1407.50,60.40}},
	{"Little Mexico",               {1701.90,-1842.20,-89.00,1812.60,-1722.20,110.90}},
	{"Little Mexico",               {1758.90,-1722.20,-89.00,1812.60,-1577.50,110.90}},
	{"Los Flores",                  {2581.70,-1454.30,-89.00,2632.80,-1393.40,110.90}},
	{"Los Flores",                  {2581.70,-1393.40,-89.00,2747.70,-1135.00,110.90}},
	{"Los Santos International",    {1249.60,-2394.30,-89.00,1852.00,-2179.20,110.90}},
	{"Los Santos International",    {1852.00,-2394.30,-89.00,2089.00,-2179.20,110.90}},
	{"Los Santos International",    {1382.70,-2730.80,-89.00,2201.80,-2394.30,110.90}},
	{"Los Santos International",    {1974.60,-2394.30,-39.00,2089.00,-2256.50,60.90}},
	{"Los Santos International",    {1400.90,-2669.20,-39.00,2189.80,-2597.20,60.90}},
	{"Los Santos International",    {2051.60,-2597.20,-39.00,2152.40,-2394.30,60.90}},
	{"Marina",                      {647.70,-1804.20,-89.00,851.40,-1577.50,110.90}},
	{"Marina",                      {647.70,-1577.50,-89.00,807.90,-1416.20,110.90}},
	{"Marina",                      {807.90,-1577.50,-89.00,926.90,-1416.20,110.90}},
	{"Market",                      {787.40,-1416.20,-89.00,1072.60,-1310.20,110.90}},
	{"Market",                      {952.60,-1310.20,-89.00,1072.60,-1130.80,110.90}},
	{"Market",                      {1072.60,-1416.20,-89.00,1370.80,-1130.80,110.90}},
	{"Market",                      {926.90,-1577.50,-89.00,1370.80,-1416.20,110.90}},
	{"Market Station",              {787.40,-1410.90,-34.10,866.00,-1310.20,65.80}},
	{"Martin Bridge",               {-222.10,293.30,0.00,-122.10,476.40,200.00}},
	{"Missionary Hill",             {-2994.40,-811.20,0.00,-2178.60,-430.20,200.00}},
	{"Montgomery",                  {1119.50,119.50,-3.00,1451.40,493.30,200.00}},
	{"Montgomery",                  {1451.40,347.40,-6.10,1582.40,420.80,200.00}},
	{"Montgomery Intersection",     {1546.60,208.10,0.00,1745.80,347.40,200.00}},
	{"Montgomery Intersection",     {1582.40,347.40,0.00,1664.60,401.70,200.00}},
	{"Mulholland",                  {1414.00,-768.00,-89.00,1667.60,-452.40,110.90}},
	{"Mulholland",                  {1281.10,-452.40,-89.00,1641.10,-290.90,110.90}},
	{"Mulholland",                  {1269.10,-768.00,-89.00,1414.00,-452.40,110.90}},
	{"Mulholland",                  {1357.00,-926.90,-89.00,1463.90,-768.00,110.90}},
	{"Mulholland",                  {1318.10,-910.10,-89.00,1357.00,-768.00,110.90}},
	{"Mulholland",                  {1169.10,-910.10,-89.00,1318.10,-768.00,110.90}},
	{"Mulholland",                  {768.60,-954.60,-89.00,952.60,-860.60,110.90}},
	{"Mulholland",                  {687.80,-860.60,-89.00,911.80,-768.00,110.90}},
	{"Mulholland",                  {737.50,-768.00,-89.00,1142.20,-674.80,110.90}},
	{"Mulholland",                  {1096.40,-910.10,-89.00,1169.10,-768.00,110.90}},
	{"Mulholland",                  {952.60,-937.10,-89.00,1096.40,-860.60,110.90}},
	{"Mulholland",                  {911.80,-860.60,-89.00,1096.40,-768.00,110.90}},
	{"Mulholland",                  {861.00,-674.80,-89.00,1156.50,-600.80,110.90}},
	{"Mulholland Intersection",     {1463.90,-1150.80,-89.00,1812.60,-768.00,110.90}},
	{"North Rock",                  {2285.30,-768.00,0.00,2770.50,-269.70,200.00}},
	{"Ocean Docks",                 {2373.70,-2697.00,-89.00,2809.20,-2330.40,110.90}},
	{"Ocean Docks",                 {2201.80,-2418.30,-89.00,2324.00,-2095.00,110.90}},
	{"Ocean Docks",                 {2324.00,-2302.30,-89.00,2703.50,-2145.10,110.90}},
	{"Ocean Docks",                 {2089.00,-2394.30,-89.00,2201.80,-2235.80,110.90}},
	{"Ocean Docks",                 {2201.80,-2730.80,-89.00,2324.00,-2418.30,110.90}},
	{"Ocean Docks",                 {2703.50,-2302.30,-89.00,2959.30,-2126.90,110.90}},
	{"Ocean Docks",                 {2324.00,-2145.10,-89.00,2703.50,-2059.20,110.90}},
	{"Ocean Flats",                 {-2994.40,277.40,-9.10,-2867.80,458.40,200.00}},
	{"Ocean Flats",                 {-2994.40,-222.50,-0.00,-2593.40,277.40,200.00}},
	{"Ocean Flats",                 {-2994.40,-430.20,-0.00,-2831.80,-222.50,200.00}},
	{"Octane Springs",              {338.60,1228.50,0.00,664.30,1655.00,200.00}},
	{"Old Venturas Strip",          {2162.30,2012.10,-89.00,2685.10,2202.70,110.90}},
	{"Palisades",                   {-2994.40,458.40,-6.10,-2741.00,1339.60,200.00}},
	{"Palomino Creek",              {2160.20,-149.00,0.00,2576.90,228.30,200.00}},
	{"Paradiso",                    {-2741.00,793.40,-6.10,-2533.00,1268.40,200.00}},
	{"Pershing Square",             {1440.90,-1722.20,-89.00,1583.50,-1577.50,110.90}},
	{"Pilgrim",                     {2437.30,1383.20,-89.00,2624.40,1783.20,110.90}},
	{"Pilgrim",                     {2624.40,1383.20,-89.00,2685.10,1783.20,110.90}},
	{"Pilson Intersection",         {1098.30,2243.20,-89.00,1377.30,2507.20,110.90}},
	{"Pirates in Men's Pants",      {1817.30,1469.20,-89.00,2027.40,1703.20,110.90}},
	{"Playa del Seville",           {2703.50,-2126.90,-89.00,2959.30,-1852.80,110.90}},
	{"Prickle Pine",                {1534.50,2583.20,-89.00,1848.40,2863.20,110.90}},
	{"Prickle Pine",                {1117.40,2507.20,-89.00,1534.50,2723.20,110.90}},
	{"Prickle Pine",                {1848.40,2553.40,-89.00,1938.80,2863.20,110.90}},
	{"Prickle Pine",                {1938.80,2624.20,-89.00,2121.40,2861.50,110.90}},
	{"Queens",                      {-2533.00,458.40,0.00,-2329.30,578.30,200.00}},
	{"Queens",                      {-2593.40,54.70,0.00,-2411.20,458.40,200.00}},
	{"Queens",                      {-2411.20,373.50,0.00,-2253.50,458.40,200.00}},
	{"Randolph Industrial Estate",  {1558.00,596.30,-89.00,1823.00,823.20,110.90}},
	{"Redsands East",               {1817.30,2011.80,-89.00,2106.70,2202.70,110.90}},
	{"Redsands East",               {1817.30,2202.70,-89.00,2011.90,2342.80,110.90}},
	{"Redsands East",               {1848.40,2342.80,-89.00,2011.90,2478.40,110.90}},
	{"Redsands West",               {1236.60,1883.10,-89.00,1777.30,2142.80,110.90}},
	{"Redsands West",               {1297.40,2142.80,-89.00,1777.30,2243.20,110.90}},
	{"Redsands West",               {1377.30,2243.20,-89.00,1704.50,2433.20,110.90}},
	{"Redsands West",               {1704.50,2243.20,-89.00,1777.30,2342.80,110.90}},
	{"Regular Tom",                 {-405.70,1712.80,-3.00,-276.70,1892.70,200.00}},
	{"Restraunt",	       			{-229.07,1393.80,28.35,-222.40,1412.19,27.77}},
	{"Restraunt",	       			{-221.54,1401.45,27.77,-217.49,1407.54,28.41}},
	{"Richman",                     {647.50,-1118.20,-89.00,787.40,-954.60,110.90}},
	{"Richman",                     {647.50,-954.60,-89.00,768.60,-860.60,110.90}},
	{"Richman",                     {225.10,-1369.60,-89.00,334.50,-1292.00,110.90}},
	{"Richman",                     {225.10,-1292.00,-89.00,466.20,-1235.00,110.90}},
	{"Richman",                     {72.60,-1404.90,-89.00,225.10,-1235.00,110.90}},
	{"Richman",                     {72.60,-1235.00,-89.00,321.30,-1008.10,110.90}},
	{"Richman",                     {321.30,-1235.00,-89.00,647.50,-1044.00,110.90}},
	{"Richman",                     {321.30,-1044.00,-89.00,647.50,-860.60,110.90}},
	{"Richman",                     {321.30,-860.60,-89.00,687.80,-768.00,110.90}},
	{"Richman",                     {321.30,-768.00,-89.00,700.70,-674.80,110.90}},
	{"Robada Intersection",         {-1119.00,1178.90,-89.00,-862.00,1351.40,110.90}},
	{"Roca Escalante",              {2237.40,2202.70,-89.00,2536.40,2542.50,110.90}},
	{"Roca Escalante",              {2536.40,2202.70,-89.00,2625.10,2442.50,110.90}},
	{"Rockshore East",              {2537.30,676.50,-89.00,2902.30,943.20,110.90}},
	{"Rockshore West",              {1997.20,596.30,-89.00,2377.30,823.20,110.90}},
	{"Rockshore West",              {2377.30,596.30,-89.00,2537.30,788.80,110.90}},
	{"Rodeo",                       {72.60,-1684.60,-89.00,225.10,-1544.10,110.90}},
	{"Rodeo",                       {72.60,-1544.10,-89.00,225.10,-1404.90,110.90}},
	{"Rodeo",                       {225.10,-1684.60,-89.00,312.80,-1501.90,110.90}},
	{"Rodeo",                       {225.10,-1501.90,-89.00,334.50,-1369.60,110.90}},
	{"Rodeo",                       {334.50,-1501.90,-89.00,422.60,-1406.00,110.90}},
	{"Rodeo",                       {312.80,-1684.60,-89.00,422.60,-1501.90,110.90}},
	{"Rodeo",                       {422.60,-1684.60,-89.00,558.00,-1570.20,110.90}},
	{"Rodeo",                       {558.00,-1684.60,-89.00,647.50,-1384.90,110.90}},
	{"Rodeo",                       {466.20,-1570.20,-89.00,558.00,-1385.00,110.90}},
	{"Rodeo",                       {422.60,-1570.20,-89.00,466.20,-1406.00,110.90}},
	{"Rodeo",                       {466.20,-1385.00,-89.00,647.50,-1235.00,110.90}},
	{"Rodeo",                       {334.50,-1406.00,-89.00,466.20,-1292.00,110.90}},
	{"Royal Casino",                {2087.30,1383.20,-89.00,2437.30,1543.20,110.90}},
	{"San Andreas Sound",           {2450.30,385.50,-100.00,2759.20,562.30,200.00}},
	{"Santa Flora",                 {-2741.00,458.40,-7.60,-2533.00,793.40,200.00}},
	{"Santa Maria Beach",           {342.60,-2173.20,-89.00,647.70,-1684.60,110.90}},
	{"Santa Maria Beach",           {72.60,-2173.20,-89.00,342.60,-1684.60,110.90}},
	{"Shady Cabin",                 {-1632.80,-2263.40,-3.00,-1601.30,-2231.70,200.00}},
	{"Shady Creeks",                {-1820.60,-2643.60,-8.00,-1226.70,-1771.60,200.00}},
	{"Shady Creeks",                {-2030.10,-2174.80,-6.10,-1820.60,-1771.60,200.00}},
	{"Sobell Rail Yards",           {2749.90,1548.90,-89.00,2923.30,1937.20,110.90}},
	{"Spinybed",                    {2121.40,2663.10,-89.00,2498.20,2861.50,110.90}},
	{"Starfish Casino",             {2437.30,1783.20,-89.00,2685.10,2012.10,110.90}},
	{"Starfish Casino",             {2437.30,1858.10,-39.00,2495.00,1970.80,60.90}},
	{"Starfish Casino",             {2162.30,1883.20,-89.00,2437.30,2012.10,110.90}},
	{"Temple",                      {1252.30,-1130.80,-89.00,1378.30,-1026.30,110.90}},
	{"Temple",                      {1252.30,-1026.30,-89.00,1391.00,-926.90,110.90}},
	{"Temple",                      {1252.30,-926.90,-89.00,1357.00,-910.10,110.90}},
	{"Temple",                      {952.60,-1130.80,-89.00,1096.40,-937.10,110.90}},
	{"Temple",                      {1096.40,-1130.80,-89.00,1252.30,-1026.30,110.90}},
	{"Temple",                      {1096.40,-1026.30,-89.00,1252.30,-910.10,110.90}},
	{"The Camel's Toe",             {2087.30,1203.20,-89.00,2640.40,1383.20,110.90}},
	{"The Clown's Pocket",          {2162.30,1783.20,-89.00,2437.30,1883.20,110.90}},
	{"The Emerald Isle",            {2011.90,2202.70,-89.00,2237.40,2508.20,110.90}},
	{"The Farm",                    {-1209.60,-1317.10,114.90,-908.10,-787.30,251.90}},
	{"The Four Dragons Casino",     {1817.30,863.20,-89.00,2027.30,1083.20,110.90}},
	{"The High Roller",             {1817.30,1283.20,-89.00,2027.30,1469.20,110.90}},
	{"The Mako Span",               {1664.60,401.70,0.00,1785.10,567.20,200.00}},
	{"The Panopticon",              {-947.90,-304.30,-1.10,-319.60,327.00,200.00}},
	{"The Pink Swan",               {1817.30,1083.20,-89.00,2027.30,1283.20,110.90}},
	{"The Sherman Dam",             {-968.70,1929.40,-3.00,-481.10,2155.20,200.00}},
	{"The Strip",                   {2027.40,863.20,-89.00,2087.30,1703.20,110.90}},
	{"The Strip",                   {2106.70,1863.20,-89.00,2162.30,2202.70,110.90}},
	{"The Strip",                   {2027.40,1783.20,-89.00,2162.30,1863.20,110.90}},
	{"The Strip",                   {2027.40,1703.20,-89.00,2137.40,1783.20,110.90}},
	{"The Visage",                  {1817.30,1863.20,-89.00,2106.70,2011.80,110.90}},
	{"The Visage",                  {1817.30,1703.20,-89.00,2027.40,1863.20,110.90}},
	{"Unity Station",               {1692.60,-1971.80,-20.40,1812.60,-1932.80,79.50}},
	{"Valle Ocultado",              {-936.60,2611.40,2.00,-715.90,2847.90,200.00}},
	{"Verdant Bluffs",              {930.20,-2488.40,-89.00,1249.60,-2006.70,110.90}},
	{"Verdant Bluffs",              {1073.20,-2006.70,-89.00,1249.60,-1842.20,110.90}},
	{"Verdant Bluffs",              {1249.60,-2179.20,-89.00,1692.60,-1842.20,110.90}},
	{"Verdant Meadows",             {37.00,2337.10,-3.00,435.90,2677.90,200.00}},
	{"Verona Beach",                {647.70,-2173.20,-89.00,930.20,-1804.20,110.90}},
	{"Verona Beach",                {930.20,-2006.70,-89.00,1073.20,-1804.20,110.90}},
	{"Verona Beach",                {851.40,-1804.20,-89.00,1046.10,-1577.50,110.90}},
	{"Verona Beach",                {1161.50,-1722.20,-89.00,1323.90,-1577.50,110.90}},
	{"Verona Beach",                {1046.10,-1722.20,-89.00,1161.50,-1577.50,110.90}},
	{"Vinewood",                    {787.40,-1310.20,-89.00,952.60,-1130.80,110.90}},
	{"Vinewood",                    {787.40,-1130.80,-89.00,952.60,-954.60,110.90}},
	{"Vinewood",                    {647.50,-1227.20,-89.00,787.40,-1118.20,110.90}},
	{"Vinewood",                    {647.70,-1416.20,-89.00,787.40,-1227.20,110.90}},
	{"Whitewood Estates",           {883.30,1726.20,-89.00,1098.30,2507.20,110.90}},
	{"Whitewood Estates",           {1098.30,1726.20,-89.00,1197.30,2243.20,110.90}},
	{"Willowfield",                 {1970.60,-2179.20,-89.00,2089.00,-1852.80,110.90}},
	{"Willowfield",                 {2089.00,-2235.80,-89.00,2201.80,-1989.90,110.90}},
	{"Willowfield",                 {2089.00,-1989.90,-89.00,2324.00,-1852.80,110.90}},
	{"Willowfield",                 {2201.80,-2095.00,-89.00,2324.00,-1989.90,110.90}},
	{"Willowfield",                 {2541.70,-1941.40,-89.00,2703.50,-1852.80,110.90}},
	{"Willowfield",                 {2324.00,-2059.20,-89.00,2541.70,-1852.80,110.90}},
	{"Willowfield",                 {2541.70,-2059.20,-89.00,2703.50,-1941.40,110.90}},
	{"Yellow Bell Station",         {1377.40,2600.40,-21.90,1492.40,2687.30,78.00}},
	// Main Zones
	{"Los Santos",                  {44.60,-2892.90,-242.90,2997.00,-768.00,900.00}},
	{"Las Venturas",                {869.40,596.30,-242.90,2997.00,2993.80,900.00}},
	{"Bone County",                 {-480.50,596.30,-242.90,869.40,2993.80,900.00}},
	{"Tierra Robada",               {-2997.40,1659.60,-242.90,-480.50,2993.80,900.00}},
	{"Tierra Robada",               {-1213.90,596.30,-242.90,-480.50,1659.60,900.00}},
	{"San Fierro",                  {-2997.40,-1115.50,-242.90,-1213.90,1659.60,900.00}},
	{"Red County",                  {-1213.90,-768.00,-242.90,2997.00,596.30,900.00}},
	{"Flint County",                {-1213.90,-2892.90,-242.90,44.60,-768.00,900.00}},
	{"San Andreas",                	{4601.083, -2989.536, -242.90, 2989.536, -3666.853, 1500.00}},
	{"Mount Chilliad",              {-2997.40,-2892.90,-242.90,-1213.90,-1115.50,900.00}}
};
stock GetHouseLocation(houseid) // By [03]Garsino
{
	new zone[MAX_ZONE_NAME];
    format(zone, MAX_ZONE_NAME, "Unknown");
	new size = sizeof(gSAZones);
    Loop(i, size, 0)
 	{
		if(hInfo[houseid][CPOutX] >= gSAZones[i][SAZONE_AREA][0] && hInfo[houseid][CPOutX] <= gSAZones[i][SAZONE_AREA][3] && hInfo[houseid][CPOutY] >= gSAZones[i][SAZONE_AREA][1] && hInfo[houseid][CPOutY] <= gSAZones[i][SAZONE_AREA][4])
		{
		    format(zone, MAX_ZONE_NAME, "%s", gSAZones[i][SAZONE_NAME]);
		    return zone;
		}
	}
	return zone;
}
stock HouseFile(houseid)
{
    new filename[HOUSEFILE_LENGTH];
	format(filename, sizeof(filename), FILEPATH, houseid);
	return filename;
}
stock EndHouseRobbery(playerid)
{
	new timer_state = GetPVarInt(playerid, "HouseRobberyTimer");
	if(timer_state != -1)
	{
	    KillTimer(timer_state);
    	SetPVarInt(playerid, "HouseRobberyTimer", -1);
    }
    return 1;
}
stock SecurityDog_Bite(playerid, houseid, type, failed = 0)
{
	if(hInfo[houseid][HouseDog] == 0) return 1;
    new Float:health;
	GetPlayerHealth(playerid, health);
 	ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
	if((health - (SECURITYDOG_HEALTHLOSS * SECURITYDOG_BITS)) <= 0.00)
	{
 		SetPlayerHealth(playerid, 0.00);
 		switch(type)
 		{
 		    case 0: ShowInfoBoxEx(playerid, COLOUR_SYSTEM, HBREAKIN_FAILED1);
 		    case 1: ShowInfoBoxEx(playerid, COLOUR_SYSTEM, HROB_FAILED1);
 		}
	}
	else
	{
		SetPlayerHealth(playerid, (health - (SECURITYDOG_HEALTHLOSS * SECURITYDOG_BITS)));
		if(failed == 1)
		{
			switch(type)
	 		{
	 		    case 0: ShowInfoBoxEx(playerid, COLOUR_SYSTEM, HBREAKIN_FAILED2);
	 		    case 1: ShowInfoBoxEx(playerid, COLOUR_SYSTEM, HROB_FAILED2);
	 		}
 		}
	}
	SetTimerEx("SecurityDog_ClearAnimations", 4000, false, "i", playerid);
	return 1;
}
// © [03]Garsino - Keep The Credits!
