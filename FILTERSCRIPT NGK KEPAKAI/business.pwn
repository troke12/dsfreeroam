// Make sure you don't get warnings about tabsize
#pragma tabsize 0

// Include default files
#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <streamer>



// ******************************************************************************************************************************
// Settings that can be changed
// ******************************************************************************************************************************

// Default max number of players is set to 500, re-define it to 50
#undef MAX_PLAYERS
#define MAX_PLAYERS 50

// Define housing parameters
#define MAX_BUSINESS				500 // Defines the maximum number of businesses that can be created
#define MAX_BUSINESSPERPLAYER		4 // Defines the maximum number of businesses that any player can own (useable values: 1 to 20)

// Define path to business-files
#define BusinessFile "PPC_Business/Business%i.ini"
#define BusinessTimeFile "PPC_Business/BusinessTime.ini"

// Set the exit-time for exiting a business (required if you use custom-made islands, otherwise you'll fall into the water)
// Default: 1 second (1000 milliseconds)
new ExitBusinessTimer = 1000;




// Define Dialogs
#define DialogCreateBusSelType      9090
#define DialogBusinessNameChange    9091
#define DialogSellBusiness          9092
#define DialogBusinessMenu          9093
#define DialogGoBusiness            9094



// ******************************************************************************************************************************
// Enums and the array-setups that use them
// ******************************************************************************************************************************

// Setup a custom type that holds all data for businesses
enum TBusinessData
{
	PickupID, // Holds the pickup-id that is linked to this business
	Text3D:DoorText, // Holds the reference to the 3DText above the business's pickup
	MapIconID, // Holds the ID of the mapicon for the business

	BusinessName[100], // Holds the name of the business (this will be displayed above the pickup near the business when it's owned)
	Float:BusinessX, // Holds the X-coordinate of the pickup for the Business
	Float:BusinessY, // Holds the Y-coordinate of the pickup for the Business
	Float:BusinessZ, // Holds the Z-coordinate of the pickup for the Business
	BusinessType, // Holds the type of business (well stacked pizza, burger shot, ...), this defines which icon and interior to use
	BusinessLevel, // Holds the level of upgrades the business has
	LastTransaction, // Holds the amount of minutes when the last transaction took place (buying the business or retrieving the money by the owner)
	bool:Owned, // Holds true if the Business is owned by somebody
	Owner[24] // Holds the name of the owner of the Business
}
// Holds the data for all houses
new ABusinessData[MAX_BUSINESS][TBusinessData];
// This variable holds the business-time (this value is increased every hour and is used to calculate the amount of money a business
// has generated after the last transaction of the business)
new BusinessTransactionTime;



// Setup a custom type that holds all data about a business
enum TBusinessType
{
	InteriorName[50], // Holds the name of the interior
	InteriorID, // Holds the interior-id
	Float:IntX, // Holds the X-coordinate of the spawn-location where you enter the business
	Float:IntY, // Holds the Y-coordinate of the spawn-location where you enter the business
	Float:IntZ, // Holds the Z-coordinate of the spawn-location where you enter the business
	BusPrice, // Holds the price for the business
	BusEarnings, // Holds the earnings for this type of business (a business earns this money every minute even when the player is offline)
	            // The earnings may not seem that high, but earning $5 every minute will earn you $7200 every day, even when you're offline
	            // These are multiplied by the level of your business, so a level 5 business earns you $36000 every day
	            // Using the default buying prices, you'll need about 70 days to refund your business and start making money with it
	IconID // Holds the icon-id which represents the business
}
// Holds the data for all interiors for businesses
new ABusinessInteriors[][TBusinessType] =
{
	{"Dummy", 				0, 		0.0, 		0.0, 		0.0,		0,			0,		0}, // Dummy business (Type 0), never used
	{"24/7 (Small)", 		6, 		-26.75, 	-55.75, 	1003.6,		500000,		5,		52}, // Type 1 (earnings per day: $7200)
	{"24/7 (Medium)", 		18, 	-31.0, 		-89.5, 		1003.6,		700000,		7,		52}, // Type 2 (earnings per day: $10080)
	{"Bar", 				11, 	502.25, 	-69.75, 	998.8,		400000,		4,		49}, // Type 3 (earnings per day: $5760)
	{"Barber (Small)", 		2, 		411.5, 		-21.25, 	1001.8,		300000,		3,		7}, // Type 4 (earnings per day: $4320)
	{"Barber (Medium)",		3, 		418.75, 	-82.5, 		1001.8,		400000,		4,		7}, // Type 5 (earnings per day: $5760)
	{"Betting shop", 		3, 		833.25, 	7.0, 		1004.2,		1500000,	15,		52}, // Type 6 (earnings per day: $21600)
	{"Burger Shot", 		10, 	363.5, 		-74.5, 		1001.5,		700000,		7,		10}, // Type 7 (earnings per day: $10080)
	{"Casino (4 Dragons)", 	10, 	2017.25, 	1017.75, 	996.9,		2500000,	25,		44}, // Type 8 (earnings per day: $36000)
	{"Casino (Caligula's)", 1, 		2234.0, 	1710.75, 	1011.3,		2500000,	25,		25}, // Type 9 (earnings per day: $36000)
	{"Casino (Small)", 		12, 	1133.0, 	-9.5,	 	1000.7,		2000000,	20,		43}, // Type 10 (earnings per day: $28800)
	{"Clothing (Binco)", 	15, 	207.75, 	-109.0, 	1005.2,		800000,		8,		45}, // Type 11 (earnings per day: $11520)
	{"Clothing (Pro)", 		3, 		207.0, 		-138.75, 	1003.5,		800000,		8,		45}, // Type 12 (earnings per day: $11520)
	{"Clothing (Urban)", 	1, 		203.75, 	-48.5, 		1001.8,		800000,		8,		45}, // Type 13 (earnings per day: $11520)
	{"Clothing (Victim)", 	5, 		226.25, 	-7.5, 		1002.3,		800000,		8,		45}, // Type 14 (earnings per day: $11520)
	{"Clothing (ZIP)",		18, 	161.5, 		-92.25, 	1001.8,		800000,		8,		45}, // Type 15 (earnings per day: $11520)
	{"Cluckin' Bell",		9,		365.75, 	-10.75,  	1001.9,		700000,		7,		14}, // Type 16 (earnings per day: $10080)
	{"Disco (Small)", 		17, 	492.75,		-22.0, 		1000.7,		1000000,	10,		48}, // Type 17 (earnings per day: $14400)
	{"Disco (Large)", 		3, 		-2642.0, 	1406.5, 	906.5,		1200000,	12,		48}, // Type 18 (earnings per day: $17280)
	{"Gym (LS)", 			5, 		772.0, 		-3.0, 		1000.8,		500000,		5,		54}, // Type 19 (earnings per day: $7200)
	{"Gym (SF)", 			6, 		774.25, 	-49.0, 		1000.6,		500000,		5,		54}, // Type 20 (earnings per day: $7200)
	{"Gym (LV)", 			7, 		774.25, 	-74.0, 		1000.7,		500000,		5,		54}, // Type 21 (earnings per day: $7200)
	{"Motel", 				15, 	2216.25, 	-1150.5, 	1025.8,		1000000,	10,		37}, // Type 22 (earnings per day: $14400)
	{"RC shop", 			6, 		-2238.75, 	131.0, 		1035.5,		600000,		6,		46}, // Type 23 (earnings per day: $8640)
	{"Sex-shop", 			3, 		-100.25, 	-22.75, 	1000.8,		800000,		8,		38}, // Type 24 (earnings per day: $11520)
	{"Slaughterhouse", 		1, 		933.75, 	2151.0, 	1011.1,		500000,		5,		50}, // Type 25 (earnings per day: $7200)
	{"Stadium (Bloodbowl)", 15, 	-1394.25, 	987.5, 		1024.0,		1700000,	17,		33}, // Type 26 (earnings per day: $24480)
	{"Stadium (Kickstart)", 14, 	-1410.75, 	1591.25, 	1052.6,		1700000,	17,		33}, // Type 27 (earnings per day: $24480)
	{"Stadium (8-Track)", 	7, 		-1396.0, 	-208.25, 	1051.2,		1700000,	17,		33}, // Type 28 (earnings per day: $24480)
	{"Stadium (Dirt Bike)", 4, 		-1425.0, 	-664.5, 	1059.9,		1700000,	17,		33}, // Type 29 (earnings per day: $24480)
	{"Stripclub (Small)", 	3, 		1212.75, 	-30.0, 		1001.0,		700000,		7,		48}, // Type 30 (earnings per day: $10080)
	{"Stripclub (Large)", 	2, 		1204.75, 	-12.5, 		1001.0,		900000,		9,		48}, // Type 31 (earnings per day: $12960)
	{"Tattoo LS", 			16, 	-203.0, 	-24.25, 	1002.3,		500000,		5,		39}, // Type 32 (earnings per day: $7200)
	{"Well Stacked Pizza", 	5,	 	372.25, 	-131.50, 	1001.5,		600000,		6,		29} // Type 33 (earnings per day: $8640)
};



// Setup all the fields required for the player data (Speedometer TextDraw, current job, ...)
enum TPlayerData
{
	Business[20], // Holds the BusinessID's of the businesses that the player owns (index of the ABusinessData array), maximum 20 businesses per player
    CurrentBusiness // Holds the BusinessID to track in which business the player currently is (used when accessing the businessmenu)
}
// Create an array to hold the playerdata for every player
new APlayerData[MAX_PLAYERS][TPlayerData];



// These variables are used when starting the script and debugging purposes
new TotalBusiness;



// ******************************************************************************************************************************
// Callbacks
// ******************************************************************************************************************************

// The main function (used only once when the server loads)
main()
{
}

// This callback gets called when the server initializes the filterscript
public OnFilterScriptInit()
{
	// Load the businesstime-file (which holds the current time for the businesses, used for calculating the earnings every minute)
	BusinessTime_Load();

	// Loop through all businesses and try to load them (BusID 0 isn't used)
	for (new BusID = 1; BusID < MAX_BUSINESS; BusID++)
		BusinessFile_Load(BusID); // Try to load the business-file

	// Start the businesstimer and run it every minute
	SetTimer("Business_TransactionTimer", 1000 * 60, true);

	// Print information about the filterscript on the server-console
    printf("-------------------------------------");
    printf("PPC Business filterscript initialized");
    printf("Businesses loaded: %i", TotalBusiness);
    printf("-------------------------------------");

    return 1;
}

// This callback gets called when a player connects to the server
public OnPlayerConnect(playerid)
{
	// Setup local variables
	new BusID, BusSlot, Name[24];

	// Get the player's name
	GetPlayerName(playerid, Name, sizeof(Name));

	// Loop through all businesses to find the ones which belong to this player
	for (BusID = 1; BusID < MAX_BUSINESS; BusID++)
	{
		// Check if the business exists
		if (IsValidDynamicPickup(ABusinessData[BusID][PickupID]))
		{
		    // Check if the business is owned
		    if (ABusinessData[BusID][Owned] == true)
		    {
		        // Check if the player is the owner of the business
				if (strcmp(ABusinessData[BusID][Owner], Name, false) == 0)
				{
					// Add the BusID to the player's account for faster reference later on
					APlayerData[playerid][Business][BusSlot] = BusID;

					// Select the next BusSlot
					BusSlot++;
				}
		    }
		}
	}

	return 1;
}

// This callback gets called when a player disconnects from the server
public OnPlayerDisconnect(playerid, reason)
{
	// Setup local variables
	new BusSlot;

	// Loop through all businesses the player owns
	for (BusSlot = 0; BusSlot < MAX_BUSINESSPERPLAYER; BusSlot++)
	{
		// Check if the player has a business in this busslot
		if (APlayerData[playerid][Business][BusSlot] != 0)
		{
		    // Save the Busfile
			BusinessFile_Save(APlayerData[playerid][Business][BusSlot]);

		    // Clear the BusID stored in this busslot
			APlayerData[playerid][Business][BusSlot] = 0;
		}
	}

	// Clear all data for this player
	APlayerData[playerid][CurrentBusiness] = 0;

	return 1;
}

// This callback gets called when a player interacts with a dialog
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	// Select the proper dialog to process
	switch (dialogid)
	{
		case DialogCreateBusSelType: Dialog_CreateBusSelType(playerid, response, listitem);
		case DialogBusinessMenu: Dialog_BusinessMenu(playerid, response, listitem);
		case DialogGoBusiness: Dialog_GoBusiness(playerid, response, listitem);
		case DialogBusinessNameChange: Dialog_ChangeBusinessName(playerid, response, inputtext); // Change the name of your business
		case DialogSellBusiness: Dialog_SellBusiness(playerid, response); // Sell the business
	}

    return 0;
}

// This callback gets called when a player spawns somewhere
public OnPlayerSpawn(playerid)
{
	// Reset the BusID where the player is located
	APlayerData[playerid][CurrentBusiness] = 0;

	return 1;
}

// This callback gets called whenever a player dies
public OnPlayerDeath(playerid, killerid, reason)
{
	// Reset the BusID where the player is located
	APlayerData[playerid][CurrentBusiness] = 0;

	return 1;
}

// This callback gets called when the player is selecting a class (but hasn't clicked "Spawn" yet)
public OnPlayerRequestClass(playerid, classid)
{
	// Reset the BusID where the player is located
	APlayerData[playerid][CurrentBusiness] = 0;

	return 1;
}

// This callback is called when the player attempts to spawn via class-selection
public OnPlayerRequestSpawn(playerid)
{
	// Reset the BusID where the player is located
	APlayerData[playerid][CurrentBusiness] = 0;

    return 1;
}



// ******************************************************************************************************************************
// Commands
// ******************************************************************************************************************************

// Lets the player add new businesses
COMMAND:createbusiness(playerid, params[])
{
	// If a player hasn't logged in properly, he cannot use this command
	if (INT_IsPlayerLoggedIn(playerid) == 0) return 0;
	// If the player has an insufficient admin-level (he needs level 5 or RCON admin), exit the command
	// returning "SERVER: Unknown command" to the player
	if (INT_CheckPlayerAdminLevel(playerid, 5) == 0) return 0;

	// Setup local variables
	new BusinessList[2000];

	// Check if the player isn't inside a vehicle
	if (GetPlayerVehicleSeat(playerid) == -1)
	{
		// Construct the list of businesses
		for (new BusType = 1; BusType < sizeof(ABusinessInteriors); BusType++)
		{
		    format(BusinessList, sizeof(BusinessList), "%s%s\n", BusinessList, ABusinessInteriors[BusType][InteriorName]);
		}

		// Let the player choose a business-type via a dialog
		ShowPlayerDialog(playerid, DialogCreateBusSelType, DIALOG_STYLE_LIST, "Choose business-type:", BusinessList, "Select", "Cancel");
	}
	else
	    SendClientMessage(playerid, 0xFF0000FF, "You must be on foot to create a business");

	// Let the server know that this was a valid command
	return 1;
}

// This command lets the player delete a business
COMMAND:delbusiness(playerid, params[])
{
	// If a player hasn't logged in properly, he cannot use this command
	if (INT_IsPlayerLoggedIn(playerid) == 0) return 0;
	// If the player has an insufficient admin-level (he needs level 5 or RCON admin), exit the command
	// returning "SERVER: Unknown command" to the player
	if (INT_CheckPlayerAdminLevel(playerid, 5) == 0) return 0;

	// Setup local variables
	new file[100], Msg[128];

	// Make sure the player isn't inside a vehicle
	if (GetPlayerVehicleSeat(playerid) == -1)
	{
		// Loop through all player-owned businesses
		for (new BusID = 1; BusID < MAX_BUSINESS; BusID++)
		{
			// Check if the business exists
			if (IsValidDynamicPickup(ABusinessData[BusID][PickupID]))
			{
				// Check if the business has no owner
				if (ABusinessData[BusID][Owned] == false)
				{
					// Check if the player is in range of the business-pickup
					if (IsPlayerInRangeOfPoint(playerid, 2.5, ABusinessData[BusID][BusinessX], ABusinessData[BusID][BusinessY], ABusinessData[BusID][BusinessZ]))
					{
						// Clear all data of the business
						ABusinessData[BusID][BusinessName] = 0;
						ABusinessData[BusID][BusinessX] = 0.0;
						ABusinessData[BusID][BusinessY] = 0.0;
						ABusinessData[BusID][BusinessZ] = 0.0;
						ABusinessData[BusID][BusinessType] = 0;
						ABusinessData[BusID][BusinessLevel] = 0;
						ABusinessData[BusID][LastTransaction] = 0;
						ABusinessData[BusID][Owned] = false;
						ABusinessData[BusID][Owner] = 0;
						// Destroy the mapicon, 3DText and pickup for the house
						DestroyDynamicPickup(ABusinessData[BusID][PickupID]);
						DestroyDynamicMapIcon(ABusinessData[BusID][MapIconID]);
						DestroyDynamic3DTextLabel(ABusinessData[BusID][DoorText]);
						ABusinessData[BusID][PickupID] = 0;
						ABusinessData[BusID][MapIconID] = 0;

						// Delete the business-file
						format(file, sizeof(file), BusinessFile, BusID); // Construct the complete filename for this business-file
						if (fexist(file)) // Make sure the file exists
							fremove(file); // Delete the file

						// Also let the player know he deleted the business
						format(Msg, 128, "{00FF00}You have deleted the business with ID: {FFFF00}%i", BusID);
						SendClientMessage(playerid, 0xFFFFFFFF, Msg);

						// Exit the function
						return 1;
					}
				}
				else
				    SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}You cannot delete an owned business");
			}
		}

		// There was no house in range, so let the player know about it
		SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}No business in range to delete");
	}
	else
	    SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}You must be on foot to delete a business");

	// Let the server know that this was a valid command
	return 1;
}

// This command lets the player buy a business when he's standing in range of a business that isn't owned yet
COMMAND:buybus(playerid, params[])
{
	// If a player hasn't logged in properly, he cannot use this command
	if (INT_IsPlayerLoggedIn(playerid) == 0) return 0;

	// Setup local variables
	new Msg[128], BusType;

	// Make sure the player isn't inside a vehicle
	if (GetPlayerVehicleSeat(playerid) == -1)
	{
		// Check if the player is near a business-pickup
		for (new BusID = 1; BusID < sizeof(ABusinessData); BusID++)
		{
			// Check if this business is created (it would have a valid pickup in front of the door)
			if (IsValidDynamicPickup(ABusinessData[BusID][PickupID]))
			{
				// Check if the player is in range of the business-pickup
				if (IsPlayerInRangeOfPoint(playerid, 2.5, ABusinessData[BusID][BusinessX], ABusinessData[BusID][BusinessY], ABusinessData[BusID][BusinessZ]))
				{
				    // Check if the business isn't owned yet
				    if (ABusinessData[BusID][Owned] == false)
				    {
						// Get the type of business
						BusType = ABusinessData[BusID][BusinessType];
				        // Check if the player can afford this type of business business
				        if (INT_GetPlayerMoney(playerid) >= ABusinessInteriors[BusType][BusPrice])
				            Business_SetOwner(playerid, BusID); // Give ownership of the business to the player
				        else
				            SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}You cannot afford this business"); // The player cannot afford this business
				    }
				    else
				    {
				        // Let the player know that this business is already owned by a player
						format(Msg, 128, "{FF0000}This business is already owned by {FFFF00}%s", ABusinessData[BusID][Owner]);
						SendClientMessage(playerid, 0xFFFFFFFF, Msg);
				    }

					// The player was in range of a business-pickup, so stop searching for the other business pickups
				    return 1;
				}
			}
		}

		// All businesses have been processed, but the player wasn't in range of any business-pickup, let him know about it
		SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}To buy a business, you have to be near a business-pickup");
	}
	else
	    SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}You can't buy a business when you're inside a vehicle");

	// Let the server know that this was a valid command
	return 1;
}

// This command lets the player enter the house/business if he's the owner
COMMAND:enter(playerid, params[])
{
	// If a player hasn't logged in properly, he cannot use this command
	if (INT_IsPlayerLoggedIn(playerid) == 0) return 0;

	// Setup local variables
	new BusID, BusType;

	// Make sure the player isn't inside a vehicle
	if (GetPlayerVehicleSeat(playerid) == -1)
	{
		// Loop through all player-owned businesses
		for (new BusSlot; BusSlot < MAX_BUSINESSPERPLAYER; BusSlot++)
		{
		    // Get the business-id at the selected slot from the player
		    BusID = APlayerData[playerid][Business][BusSlot];

			// Check if the player has a business in this slot
			if (BusID != 0)
			{
				// Check if the player is in range of the business-pickup
				if (IsPlayerInRangeOfPoint(playerid, 2.5, ABusinessData[BusID][BusinessX], ABusinessData[BusID][BusinessY], ABusinessData[BusID][BusinessZ]))
				{
				    // Get the business-type
				    BusType = ABusinessData[BusID][BusinessType];

					// Set the worldid so other players cannot see him anymore
					SetPlayerVirtualWorld(playerid, 2000 + BusID);
					// Set the player inside the interior of the business
					SetPlayerInterior(playerid, ABusinessInteriors[BusType][InteriorID]);
					// Set the position of the player at the spawn-location of the business's interior
					SetPlayerPos(playerid, ABusinessInteriors[BusType][IntX], ABusinessInteriors[BusType][IntY], ABusinessInteriors[BusType][IntZ]);

					// Also set a tracking-variable to enable /busmenu to track in which business the player is
					APlayerData[playerid][CurrentBusiness] = BusID;
					// Also let the player know he can use /busmenu to control his business
					SendClientMessage(playerid, 0xFFFFFFFF, "{00FF00}Use {FFFF00}/busmenu{00FF00} to change options for your business");

					// Exit the function
					return 1;
				}
			}
		}
	}

	// If no business was in range, allow other scripts to use the same command (like the housing-script)
	return 0;
}

// This command opens a menu when you're inside your business to allow to access the options of your business
COMMAND:busmenu(playerid, params[])
{
	// If a player hasn't logged in properly, he cannot use this command
	if (INT_IsPlayerLoggedIn(playerid) == 0) return 0;

	// Setup local variables
	new OptionsList[200], DialogTitle[200];

	// Check if the player is inside a business
	if (APlayerData[playerid][CurrentBusiness] != 0)
	{
		// Create the dialog title
		format(DialogTitle, sizeof(DialogTitle), "Select option for %s", ABusinessData[APlayerData[playerid][CurrentBusiness]][BusinessName]);
		// Create the options in the dialog
		format(OptionsList, sizeof(OptionsList), "%sChange business-name\n", OptionsList);
		format(OptionsList, sizeof(OptionsList), "%sUpgrade business\n", OptionsList);
		format(OptionsList, sizeof(OptionsList), "%sRetrieve business earnings\n", OptionsList);
		format(OptionsList, sizeof(OptionsList), "%sSell business\n", OptionsList);
		format(OptionsList, sizeof(OptionsList), "%sExit business\n", OptionsList);
		// Show the businessmenu
		ShowPlayerDialog(playerid, DialogBusinessMenu, DIALOG_STYLE_LIST, DialogTitle, OptionsList, "Select", "Cancel");
	}
	else
	    SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}You're not inside a business");

	// Let the server know that this was a valid command
	return 1;
}

// This command teleports you to your selected business
COMMAND:gobus(playerid, params[])
{
	// If a player hasn't logged in properly, he cannot use this command
	if (INT_IsPlayerLoggedIn(playerid) == 0) return 0;

	// Setup local variables
	new BusinessList[1000], BusID, BusType, Earnings;

	// Check if the player is not jailed
	if (INT_IsPlayerJailed(playerid) == 0)
	{
		// Check if the player has a wanted level of less than 3
		if (GetPlayerWantedLevel(playerid) < 3)
		{
			// Check if the player is not inside a vehicle
			if (GetPlayerVehicleSeat(playerid) == -1)
			{
				// Ask to which business the player wants to port
				for (new BusSlot; BusSlot < MAX_BUSINESSPERPLAYER; BusSlot++)
				{
					// Get the business-id
				    BusID = APlayerData[playerid][Business][BusSlot];

					// Check if this businessindex is occupied
					if (BusID != 0)
					{
						// Get the business-type
						BusType = ABusinessData[BusID][BusinessType];
						Earnings = (BusinessTransactionTime - ABusinessData[BusID][LastTransaction]) * ABusinessInteriors[BusType][BusEarnings] * ABusinessData[BusID][BusinessLevel];
						format(BusinessList, 1000, "%s{00FF00}%s{FFFFFF} (earnings: $%i)\n", BusinessList, ABusinessData[BusID][BusinessName], Earnings);
					}
					else
						format(BusinessList, 1000, "%s{FFFFFF}%s{FFFFFF}\n", BusinessList, "Empty business-slot");
				}
				ShowPlayerDialog(playerid, DialogGoBusiness, DIALOG_STYLE_LIST, "Choose the business to go to:", BusinessList, "Select", "Cancel");
			}
			else
				SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}You need to be on-foot to port to your business");
		}
		else
		    SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}You cannot use /gobus when you're wanted");
	}
	else
	    SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}You cannot use /gobus when you're in jail");

	// Let the server know that this was a valid command
	return 1;
}



// ******************************************************************************************************************************
// Dialog-responses
// ******************************************************************************************************************************

// This dialog processes the chosen business-type and creates the business
Dialog_CreateBusSelType(playerid, response, listitem)
{
	// Just close the dialog if the player clicked "Cancel"
	if(!response) return 1;

    // Setup some local variables
	new BusType, BusID, Float:x, Float:y, Float:z, Msg[128], bool:EmptySlotFound = false;

	// Get the player's position
	GetPlayerPos(playerid, x, y, z);

	// Get the business-type from the option the player chose
	BusType = listitem + 1;

	// Find a free business-id
	for (BusID = 1; BusID < MAX_BUSINESS; BusID++)
	{
		// Check if this business ID is free
		if (ABusinessData[BusID][BusinessType] == 0)
		{
			EmptySlotFound = true;
		    break; // Stop processing
		}
	}

	// Check if an empty slot has been found
	if (EmptySlotFound == false)
	{
		// If no empty slot was found, let the player know about it and exit the function
		SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}Maximum number of businesses reached");
		return 1;
	}

	// Set some default data at the index of NextFreeBusinessID (NextFreeBusinessID will point to the next free business-index)
	ABusinessData[BusID][BusinessX] = x;
	ABusinessData[BusID][BusinessY] = y;
	ABusinessData[BusID][BusinessZ] = z;
	ABusinessData[BusID][BusinessType] = BusType;
	ABusinessData[BusID][BusinessLevel] = 1;
	ABusinessData[BusID][Owned] = false;

	// Add the pickup and 3DText at the location of the business-entrance (where the player is standing when he creates the business)
	Business_CreateEntrance(BusID);

	// Save the business
	BusinessFile_Save(BusID);

	// Inform the player that he created a new house
	format(Msg, 128, "{00FF00}You've succesfully created business {FFFF00}%i{00FF00}", BusID);
	SendClientMessage(playerid, 0xFFFFFFFF, Msg);

	return 1;
}

// This function processes the businessmenu dialog
Dialog_BusinessMenu(playerid, response, listitem)
{
	// Just close the dialog if the player clicked "Cancel"
	if(!response) return 1;

	// Setup local variables
	new BusID, BusType, Msg[128], DialogTitle[200], UpgradePrice;

	// Get the HouseID of the house where the player is
	BusID = APlayerData[playerid][CurrentBusiness];
	BusType = ABusinessData[BusID][BusinessType];

	// Select an option based on the selection in the list
	switch(listitem)
	{
	    case 0: // Change business name
	    {
	        format(DialogTitle, 200, "Old business-name: %s", ABusinessData[BusID][BusinessName]);
			ShowPlayerDialog(playerid, DialogBusinessNameChange, DIALOG_STYLE_INPUT, DialogTitle, "Enter a new name for your business", "OK", "Cancel");
	    }
	    case 1: // Upgrade the business
	    {
	        // Check if it's possible to upgrade further
			if (ABusinessData[BusID][BusinessLevel] < 5)
			{
			    // Get the upgrade-price
			    UpgradePrice = ABusinessInteriors[BusType][BusPrice];
			    // Check if the player can afford the upgrade
				if (INT_GetPlayerMoney(playerid) >= UpgradePrice)
				{
				    // Give the current earnings of the business to the player and update the LastTransaction time
					Business_PayEarnings(playerid, BusID);
					// Upgrade the business 1 level
				    ABusinessData[BusID][BusinessLevel]++;
					// Let the player pay for the upgrade
					INT_GivePlayerMoney(playerid, -UpgradePrice);
					// Update the 3DText near the business's entrance to show what level the business is
					Business_UpdateEntrance(BusID);
					// Let the player know about it
					format(Msg, 128, "{00FF00}You have upgraded your business to level {FFFF00}%i", ABusinessData[BusID][BusinessLevel]);
					SendClientMessage(playerid, 0xFFFFFFFF, Msg);
				}
				else
					SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}You cannot afford the upgrade");
			}
			else
			    SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}Your business has reached the maximum level, you cannot upgrade it further");
	    }
		case 2: // Retrieve business earnings
		{
		    // Give the current earnings of the business to the player and update the LastTransaction time
			Business_PayEarnings(playerid, BusID);
		}
		case 3: // Sell business
		{
		    format(Msg, 128, "Are you sure you want to sell your business for $%i?", (ABusinessInteriors[BusType][BusPrice] * ABusinessData[BusID][BusinessLevel]) / 2);
			ShowPlayerDialog(playerid, DialogSellBusiness, DIALOG_STYLE_MSGBOX, "Are you sure?", Msg, "Yes", "No");
		}
	    case 4: // Exit the business
	    {
			Business_Exit(playerid, BusID);
	    }
	}

	return 1;
}

// Let the player change the name of his business
Dialog_ChangeBusinessName(playerid, response, inputtext[])
{
	// Just close the dialog if the player clicked "Cancel" or if the player didn't input any text
	if ((!response) || (strlen(inputtext) == 0)) return 1;

	// Change the name of the business
	format(ABusinessData[APlayerData[playerid][CurrentBusiness]][BusinessName], 100, inputtext);
	// Also update the 3DText at the entrance of the business
	Business_UpdateEntrance(APlayerData[playerid][CurrentBusiness]);
	// Let the player know that the name of his business has been changed
	SendClientMessage(playerid, 0xFFFFFFFF, "{00FF00}You've changed the name of your business");

	// Save the business-file
	BusinessFile_Save(APlayerData[playerid][CurrentBusiness]);

	return 1;
}

// Sell the business
Dialog_SellBusiness(playerid, response)
{
	// Just close the dialog if the player clicked "Cancel"
	if(!response) return 1;

	// Get the BusinessID where the player is right now and the business-type
	new BusID = APlayerData[playerid][CurrentBusiness];
	new BusType = ABusinessData[BusID][BusinessType];

	// Set the player in the normal world again
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, 0);
	// Set the position of the player at the entrance of his business
	SetPlayerPos(playerid, ABusinessData[BusID][BusinessX], ABusinessData[BusID][BusinessY], ABusinessData[BusID][BusinessZ]);

	// Also clear the tracking-variable to track in which business the player is
	APlayerData[playerid][CurrentBusiness] = 0;

	// Clear the owner of the business
	ABusinessData[BusID][Owned] = false;
	ABusinessData[BusID][Owner] = 0;
	// Clear the business-name and business-level
	ABusinessData[BusID][BusinessName] = 0;
	ABusinessData[BusID][BusinessLevel] = 1;

	// Refund the player 50% of the worth of the business
	INT_GivePlayerMoney(playerid, (ABusinessInteriors[BusType][BusPrice] * ABusinessData[BusID][BusinessLevel]) / 2);
	SendClientMessage(playerid, 0xFFFFFFFF, "{00FF00}You've sold your business");

	// Clear the business-id from the player
	for (new BusSlot; BusSlot < MAX_BUSINESSPERPLAYER; BusSlot++)
	{
		// If the business-slot if found where the business was added to the player
		if (APlayerData[playerid][Business][BusSlot] == BusID)
		{
		    // Clear the business-id
		    APlayerData[playerid][Business][BusSlot] = 0;
		    // Stop searching
		    break;
		}
	}

	// Update the 3DText near the business's entrance to show other players that it's for sale again
	Business_UpdateEntrance(BusID);

	// Also save the sold business, otherwise the old ownership-data is still there
	BusinessFile_Save(BusID);

	return 1;
}

// This function processes the /gobus dialog
Dialog_GoBusiness(playerid, response, listitem)
{
	// Just close the dialog if the player clicked "Cancel"
	if(!response) return 1;

	// Setup local variables
	new BusIndex, BusID;

	// The listitem directly indicates the business-index
	BusIndex = listitem;
	BusID = APlayerData[playerid][Business][BusIndex];

	// Check if this is a valid business (BusID != 0)
	if (BusID != 0)
	{
		// Get the coordinates of the business's entrance
		SetPlayerPos(playerid, ABusinessData[BusID][BusinessX], ABusinessData[BusID][BusinessY], ABusinessData[BusID][BusinessZ]);
	}
	else
	    SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}You don't have a business in this business-slot");

	return 1;
}



// ******************************************************************************************************************************
// File functions
// ******************************************************************************************************************************

// This function loads the file that holds the current business-time
BusinessTime_Load()
{
	// Setup local variables
	new File:BFile, LineFromFile[100], ParameterName[50], ParameterValue[50];

	// Try to load the businesstime file
	if (fexist(BusinessTimeFile))
	{
		BFile = fopen(BusinessTimeFile, io_read); // Open the businesstime-file for reading

		fread(BFile, LineFromFile); // Read the first line of the file

		// Keep reading until the end of the file is found (no more data)
		while (strlen(LineFromFile) > 0)
		{
			StripNewLine(LineFromFile); // Strip any newline characters from the LineFromFile
			sscanf(LineFromFile, "s[50]s[50]", ParameterName, ParameterValue); // Extract parametername and parametervalue

			// Store the proper value in the proper place
			if (strcmp(ParameterName, "BusinessTime", false) == 0) // If the parametername is correct ("BusinessTime")
				BusinessTransactionTime = strval(ParameterValue); // Store the BusinessTime

            // Read the next line of the file
			fread(BFile, LineFromFile);
		}

        // Close the file
		fclose(BFile);

        // Return if the file was read correctly
		return 1;
	}
	else
	    return 0; // Return 0 if the file couldn't be read (doesn't exist)
}

// This function saves the file that holds the current business-time
BusinessTime_Save()
{
	// Setup local variables
	new File:BFile, LineForFile[100];

	BFile = fopen(BusinessTimeFile, io_write); // Open the businesstime-file for writing

	format(LineForFile, 100, "BusinessTime %i\r\n", BusinessTransactionTime); // Construct the line: "BusinessTime <BusinessTransactionTime>"
	fwrite(BFile, LineForFile); // And save it to the file

	fclose(BFile); // Close the file

	return 1;
}

// This function will load the business's datafile (used when the server is started to load all businesses)
BusinessFile_Load(BusID)
{
	// Setup local variables
	new file[100], File:BFile, LineFromFile[100], ParameterName[50], ParameterValue[50];

    // Construct the complete filename for this business-file
	format(file, sizeof(file), BusinessFile, BusID);

	// Check if the business-file exists
	if (fexist(file))
	{
	    // Open the businessfile for reading
		BFile = fopen(file, io_read);

        // Read the first line of the file
		fread(BFile, LineFromFile);

		// Keep reading until the end of the file is found (no more data)
		while (strlen(LineFromFile) > 0)
		{
			StripNewLine(LineFromFile); // Strip any newline characters from the LineFromFile
			sscanf(LineFromFile, "s[50]s[50]", ParameterName, ParameterValue); // Extract parametername and parametervalue

			// Check if there is anything in the LineFromFile (skipping empty lines)
			if (strlen(LineFromFile) > 0)
			{
				// Store the proper value in the proper place
				if (strcmp(ParameterName, "BusinessName", false) == 0) // If the parametername is correct ("BusinessName")
				    format(ABusinessData[BusID][BusinessName], 24, ParameterValue); // Store the BusinessName
				if (strcmp(ParameterName, "BusinessX", false) == 0) // If the parametername is correct ("BusinessX")
					ABusinessData[BusID][BusinessX] = floatstr(ParameterValue); // Store the BusinessX
				if (strcmp(ParameterName, "BusinessY", false) == 0) // If the parametername is correct ("BusinessY")
					ABusinessData[BusID][BusinessY] = floatstr(ParameterValue); // Store the BusinessY
				if (strcmp(ParameterName, "BusinessZ", false) == 0) // If the parametername is correct ("BusinessZ")
					ABusinessData[BusID][BusinessZ] = floatstr(ParameterValue); // Store the BusinessZ
				if (strcmp(ParameterName, "BusinessType", false) == 0) // If the parametername is correct ("BusinessType")
					ABusinessData[BusID][BusinessType] = strval(ParameterValue); // Store the BusinessType
				if (strcmp(ParameterName, "BusinessLevel", false) == 0) // If the parametername is correct ("BusinessLevel")
					ABusinessData[BusID][BusinessLevel] = strval(ParameterValue); // Store the BusinessLevel
				if (strcmp(ParameterName, "LastTransaction", false) == 0) // If the parametername is correct ("LastTransaction")
					ABusinessData[BusID][LastTransaction] = strval(ParameterValue); // Store the LastTransaction
				if (strcmp(ParameterName, "Owned", false) == 0) // If the parametername is correct ("Owned")
				{
				    if (strcmp(ParameterValue, "Yes", false) == 0) // If the value "Yes" was read
						ABusinessData[BusID][Owned] = true; // House is owned
					else
						ABusinessData[BusID][Owned] = false; // House is not owned
				}
				if (strcmp(ParameterName, "Owner", false) == 0) // If the parametername is correct ("Owner")
				    format(ABusinessData[BusID][Owner], 24, ParameterValue);
			}

            // Read the next line of the file
			fread(BFile, LineFromFile);
		}

        // Close the file
		fclose(BFile);

		// Create the business-entrance and set data
		Business_CreateEntrance(BusID);
		// Increase the amount of businesses loaded
		TotalBusiness++;

        // Return if the file was read correctly
		return 1;
	}
	else
	    return 0; // Return 0 if the file couldn't be read (doesn't exist)
}

// This function will save the given business
BusinessFile_Save(BusID)
{
	// Setup local variables
	new file[100], File:BFile, LineForFile[100];

    // Construct the complete filename for this business
	format(file, sizeof(file), BusinessFile, BusID);

    // Open the business-file for writing
	BFile = fopen(file, io_write);

	format(LineForFile, 100, "BusinessName %s\r\n", ABusinessData[BusID][BusinessName]); // Construct the line: "BusinessName <BusinessName>"
	fwrite(BFile, LineForFile); // And save it to the file
	format(LineForFile, 100, "BusinessX %f\r\n", ABusinessData[BusID][BusinessX]); // Construct the line: "BusinessX <BusinessX>"
	fwrite(BFile, LineForFile); // And save it to the file
	format(LineForFile, 100, "BusinessY %f\r\n", ABusinessData[BusID][BusinessY]); // Construct the line: "BusinessY <BusinessY>"
	fwrite(BFile, LineForFile); // And save it to the file
	format(LineForFile, 100, "BusinessZ %f\r\n", ABusinessData[BusID][BusinessZ]); // Construct the line: "BusinessZ <BusinessZ>"
	fwrite(BFile, LineForFile); // And save it to the file
	format(LineForFile, 100, "BusinessType %i\r\n", ABusinessData[BusID][BusinessType]); // Construct the line: "BusinessType <BusinessType>"
	fwrite(BFile, LineForFile); // And save it to the file
	format(LineForFile, 100, "BusinessLevel %i\r\n", ABusinessData[BusID][BusinessLevel]); // Construct the line: "BusinessLevel <BusinessLevel>"
	fwrite(BFile, LineForFile); // And save it to the file
	format(LineForFile, 100, "LastTransaction %i\r\n", ABusinessData[BusID][LastTransaction]); // Construct the line: "LastTransaction <LastTransaction>"
	fwrite(BFile, LineForFile); // And save it to the file

	if (ABusinessData[BusID][Owned] == true) // Check if the business is owned
	{
		format(LineForFile, 100, "Owned Yes\r\n"); // Construct the line: "Owned Yes"
		fwrite(BFile, LineForFile); // And save it to the file
	}
	else
	{
		format(LineForFile, 100, "Owned No\r\n"); // Construct the line: "Owned No"
		fwrite(BFile, LineForFile); // And save it to the file
	}

	format(LineForFile, 100, "Owner %s\r\n", ABusinessData[BusID][Owner]); // Construct the line: "Owner <Owner>"
	fwrite(BFile, LineForFile); // And save it to the file

	fclose(BFile); // Close the file

	return 1;
}



// ******************************************************************************************************************************
// Business functions
// ******************************************************************************************************************************

// This timer increases the variable "BusinessTransactionTime" every minute and saves the businesstime file
forward Business_TransactionTimer();
public Business_TransactionTimer()
{
	// Increase the variable by one
    BusinessTransactionTime++;

	// And save it to the file
	BusinessTime_Save();
}

// This function returns the first free business-slot for the given player
Player_GetFreeBusinessSlot(playerid)
{
	// Check if the player has room for another business (he hasn't bought the maximum amount of businesses per player yet)
	// and get the slot-id
	for (new BusIndex; BusIndex < MAX_BUSINESSPERPLAYER; BusIndex++) // Loop through all business-slots of the player
		if (APlayerData[playerid][Business][BusIndex] == 0) // Check if this business slot is free
		    return BusIndex; // Return the free BusIndex for this player

	// If there were no free business-slots, return "-1"
	return -1;
}

// This function sets ownership of the business to the given player
Business_SetOwner(playerid, BusID)
{
	// Setup local variables
	new BusSlotFree, Name[24], Msg[128], BusType;

	// Get the first free business-slot from this player
	BusSlotFree = Player_GetFreeBusinessSlot(playerid);

	// Check if the player has a free business-slot
	if (BusSlotFree != -1)
	{
		// Get the player's name
		GetPlayerName(playerid, Name, sizeof(Name));

		// Store the business-id for the player
		APlayerData[playerid][Business][BusSlotFree] = BusID;
		// Get the business-type
		BusType = ABusinessData[BusID][BusinessType];

		// Let the player pay for the business
		INT_GivePlayerMoney(playerid, -ABusinessInteriors[BusType][BusPrice]);

		// Set the business as owned
		ABusinessData[BusID][Owned] = true;
		// Store the owner-name for the business
		format(ABusinessData[BusID][Owner], 24, Name);
		// Set the level to 1
		ABusinessData[BusID][BusinessLevel] = 1;
		// Set the default business-name
		format(ABusinessData[BusID][BusinessName], 100, ABusinessInteriors[BusType][InteriorName]);
		// Store the current transaction-time (this is used so the player can only retrieve cash from the business from the moment he bought it)
		ABusinessData[BusID][LastTransaction] = BusinessTransactionTime;

		// Also, update 3DText of this business
		Business_UpdateEntrance(BusID);

		// Save the business-file
		BusinessFile_Save(BusID);

		// Let the player know he bought the business
		format(Msg, 128, "{00FF00}You've bought the business for {FFFF00}$%i", ABusinessInteriors[BusType][BusPrice]);
		SendClientMessage(playerid, 0xFFFFFFFF, Msg);
	}
	else
	    SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}You already own the maximum amount of allowed businesses per player");

	return 1;
}

// This function adds a pickup for the given business
Business_CreateEntrance(BusID)
{
	// Setup local variables
	new Msg[128], Float:x, Float:y, Float:z, BusType, Icon;

	// Get the coordinates of the house's pickup (usually near the door)
	x = ABusinessData[BusID][BusinessX];
	y = ABusinessData[BusID][BusinessY];
	z = ABusinessData[BusID][BusinessZ];
	// Get the business-type and icon
	BusType = ABusinessData[BusID][BusinessType];
	Icon = ABusinessInteriors[BusType][IconID];

	// Add a dollar-sign to indicate this business
	ABusinessData[BusID][PickupID] = CreateDynamicPickup(1274, 1, x, y, z, 0);
	// Add a map-icon depending on which type the business is
	ABusinessData[BusID][MapIconID] = CreateDynamicMapIcon(x, y, z, Icon, 0, 0, 0, -1, 150.0);

	// Add a new 3DText at the business's location (usually near the door)
	if (ABusinessData[BusID][Owned] == true)
	{
		// Create the 3DText that appears above the business-pickup (displays the businessname, the name of the owner and the current level)
		format(Msg, 128, "%s\nOwned by: %s\nBusiness-level: %i\n/enter", ABusinessData[BusID][BusinessName], ABusinessData[BusID][Owner], ABusinessData[BusID][BusinessLevel]);
		ABusinessData[BusID][DoorText] = CreateDynamic3DTextLabel(Msg, 0x008080FF, x, y, z + 1.0, 50.0);
	}
	else
	{
		// Create the 3DText that appears above the business-pickup (displays the price of the business and the earnings)
		format(Msg, 128, "%s\nAvailable for\n$%i\nEarnings: $%i\n/buybus", ABusinessInteriors[BusType][InteriorName], ABusinessInteriors[BusType][BusPrice], ABusinessInteriors[BusType][BusEarnings]);
		ABusinessData[BusID][DoorText] = CreateDynamic3DTextLabel(Msg, 0x008080FF, x, y, z + 1.0, 50.0);
	}
}

// This function changes the 3DText for the given business (used when buying or selling a business)
Business_UpdateEntrance(BusID)
{
	// Setup local variables
	new Msg[128], BusType;

	// Get the business-type
	BusType = ABusinessData[BusID][BusinessType];

	// Update the 3DText at the business's location (usually near the door)
	if (ABusinessData[BusID][Owned] == true)
	{
		// Create the 3DText that appears above the business-pickup (displays the businessname, the name of the owner and the current level)
		format(Msg, 128, "%s\nOwned by: %s\nBusiness-level: %i\n/enter", ABusinessData[BusID][BusinessName], ABusinessData[BusID][Owner], ABusinessData[BusID][BusinessLevel]);
		UpdateDynamic3DTextLabelText(ABusinessData[BusID][DoorText], 0x008080FF, Msg);
	}
	else
	{
		// Create the 3DText that appears above the business-pickup (displays the price of the business and the earnings)
		format(Msg, 128, "%s\nAvailable for\n$%i\nEarnings: $%i\n/buybus", ABusinessInteriors[BusType][InteriorName], ABusinessInteriors[BusType][BusPrice], ABusinessInteriors[BusType][BusEarnings]);
		UpdateDynamic3DTextLabelText(ABusinessData[BusID][DoorText], 0x008080FF, Msg);
	}
}

// This function pays the current earnings of the given business to the player
Business_PayEarnings(playerid, BusID)
{
	// Setup local variables
	new Msg[128];

	// Get the business-type
	new BusType = ABusinessData[BusID][BusinessType];

	// Calculate the earnings of the business since the last transaction
	// This is calculated by the number of minutes between the current business-time and last business-time, multiplied by the earnings-per-minute and business-level
	new Earnings = (BusinessTransactionTime - ABusinessData[BusID][LastTransaction]) * ABusinessInteriors[BusType][BusEarnings] * ABusinessData[BusID][BusinessLevel];
	// Reset the last transaction time to the current time
	ABusinessData[BusID][LastTransaction] = BusinessTransactionTime;
	// Reward the player with his earnings
	INT_GivePlayerMoney(playerid, Earnings);
	// Inform the player that he has earned money from his business
	format(Msg, 128, "{00FF00}Your business has earned {FFFF00}$%i{00FF00} since your last withdrawl", Earnings);
	SendClientMessage(playerid, 0xFFFFFFFF, Msg);
}

// This function is used to spawn back at the entrance of your business
Business_Exit(playerid, BusID)
{
	// Set the player in the normal world again
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, 0);
	// Set the position of the player at the entrance of his business
	SetPlayerPos(playerid, ABusinessData[BusID][BusinessX], ABusinessData[BusID][BusinessY], ABusinessData[BusID][BusinessZ]);
	// Also clear the tracking-variable to track in which business the player is
	APlayerData[playerid][CurrentBusiness] = 0;

	// Check if there is a timer-value set for exiting the business (this timer freezes the player while the environment is being loaded)
	if (ExitBusinessTimer > 0)
	{
		// Don't allow the player to fall
	    TogglePlayerControllable(playerid, 0);
		// Let the player know he's frozen while the environment loads
		GameTextForPlayer(playerid, "Waiting for the environment to load", ExitBusinessTimer, 4);
		// Start a timer that will allow the player to fall again when the environment has loaded
		SetTimerEx("Business_ExitTimer", ExitBusinessTimer, false, "ii", playerid, BusID);
	}

	return 1;
}

forward Business_ExitTimer(playerid, BusID);
public Business_ExitTimer(playerid, BusID)
{
	// Allow the player to move again (environment should have been loaded now)
    TogglePlayerControllable(playerid, 1);

	return 1;
}



// ******************************************************************************************************************************
// Support functions
// ******************************************************************************************************************************

// This function is copied from the include-file "dutils.inc"
stock StripNewLine(string[])
{
	new len = strlen(string); // Get the length of the given string

	if (string[0] == 0) return ; // If the given string is empty, exit the function
	if ((string[len - 1] == '\n') || (string[len - 1] == '\r')) // If the string ends with \n or \r
	{
		string[len - 1] = 0; // Replace the \n or \r with a 0 character
		if (string[0]==0) return ; // If the string became empty, exit the function
		if ((string[len - 2] == '\n') || (string[len - 2] == '\r')) // Check again if the string ends with \n or \r
			string[len - 2] = 0; // Replace the \n or \r again with a 0 character
	}
}



// ******************************************************************************************************************************
// Special functions that try to access external public functions to retreive or set data from another script
// ******************************************************************************************************************************

// This function is used to get the player's money
INT_GetPlayerMoney(playerid)
{
	// Setup local variables
	new Money;

	// Try to call the external function to get the player's money (used to get the serversided money for this player)
	Money = CallRemoteFunction("Admin_GetPlayerMoney", "i", playerid);

	// The external function returned "0" (as the player doesn't have any money yet), or the function is not used in another script
	if (Money == 0)
		return GetPlayerMoney(playerid); // Return the normal money of the player
	else
		return Money; // Return the money that was returned by the external function
}

// This function is used to set the player's money
INT_GivePlayerMoney(playerid, Money)
{
	// Setup local variables
	new Success;

	// Try to call the external function to get the player's money (used to get the serversided money for this player)
	Success = CallRemoteFunction("Admin_GivePlayerMoney", "ii", playerid, Money);

	// The external function returned "0" as the function is not used in another script
	if (Success == 0)
		GivePlayerMoney(playerid, Money); // Use the normal money (client-sided money)
}

// This function checks if the admin-level of a player is sufficient
INT_CheckPlayerAdminLevel(playerid, AdminLevel)
{
	// Setup local variables
	new Level;

	// Check if the player is an RCON admin
	if (IsPlayerAdmin(playerid))
	    return 1; // Return 1 to indicate this player has a sufficient admin-level to use a command

	// If the player is not an RCON admin, try to get his admin-level from an external script using a remote function
	Level = CallRemoteFunction("Admin_GetPlayerAdminLevel", "i", playerid);
	// Check if the player has a sufficient admin-level
	if (Level >= AdminLevel)
	    return 1; // Return 1 to indicate this player has a sufficient admin-level
	else
		return 0; // Return 0 to indicate this player has an insufficient admin-level
}

// This function checks if the player has logged in properly by entering his password
INT_IsPlayerLoggedIn(playerid)
{
	// Setup local variables
	new LoggedIn;

	// Try to determine if the player logged in properly by entering his password in another script
	LoggedIn = CallRemoteFunction("Admin_IsPlayerLoggedIn", "i", playerid);

	// Check if the player has logged in properly
	switch (LoggedIn)
	{
		case 0: return 1; // No admin script present that holds the LoggedIn status of a player, so allow a command to be used
		case 1: return 1; // The player logged in properly by entering his password, allow commands to be used
		case -1: return 0; // There is an admin script present, but the player hasn't entered his password yet, so block all commands
							// This prevents executing the commands using F6 during login with an admin-account before entering a password
	}

	// In any other case, block all commands
	return 0;
}

// This function tries to cetermine if the player is in jail
INT_IsPlayerJailed(playerid)
{
	// Setup local variables
	new Jailed;

	// Try to determine if the player is jailed
	Jailed = CallRemoteFunction("Admin_IsPlayerJailed", "i", playerid);

	// Check if the player is jailed
	switch (Jailed)
	{
		case 0: return 0; // No admin script present, so there is no jail either, player cannot be jailed in this case
		case 1: return 1; // The player is jailed, so return "1"
		case -1: return 0; // There is an admin script present, but the player isn't jailed
	}

	// In any other case, return "0" (player not jailed)
	return 0;
}



// ******************************************************************************************************************************
// External functions to be used from within other filterscripts or gamemode (these aren't called anywhere inside this script)
// These functions can be called from other filterscripts or the gamemode to get data from the housing filterscript
// ******************************************************************************************************************************



// ******************************************************************************************************************************
// Functions that need to be placed in the gamemode or filterscript which holds the playerdata
// Only needed when the server uses server-sided money, otherwise the normal money is used
// ******************************************************************************************************************************

/*
// This function is used to get the player's money
forward Admin_GetPlayerMoney(playerid);
public Admin_GetPlayerMoney(playerid)
{
	return APlayerData[playerid][PlayerMoney];
}

// This function is used to get the player's money
forward Admin_GivePlayerMoney(playerid, Money);
public Admin_GivePlayerMoney(playerid, Money)
{
	// Add the given money to the player's account
	APlayerData[playerid][PlayerMoney] = APlayerData[playerid][PlayerMoney] + Money;

	// Return that the function had success
	return 1;
}

// This function is used to get the player's admin-level
forward Admin_GetPlayerAdminLevel(playerid);
public Admin_GetPlayerAdminLevel(playerid)
{
	return APlayerData[playerid][AdminLevel];
}

// This function is used to determine if the player has logged in (he succesfully entered his password)
forward Admin_IsPlayerLoggedIn(playerid);
public Admin_IsPlayerLoggedIn(playerid)
{
	if (APlayerData[playerid][LoggedIn] == true)
	    return 1; // The player has logged in succesfully
	else
	    return -1; // The player hasn't logged in (yet)
}

// This function is used to determine if a player is jailed
forward Admin_IsPlayerJailed(playerid);
public Admin_IsPlayerJailed(playerid)
{
	// Check if a player has jaimtime left
	if (APlayerData[playerid][PlayerJailed] == true)
	    return 1; // The player is still jailed
	else
	    return -1; // The player is not jailed
}
*/


