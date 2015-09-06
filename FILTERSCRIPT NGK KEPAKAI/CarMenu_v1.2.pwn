/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*\
||                                                                                            ||
||						Created 3rd June 2010 By [03]Garsino.                                 ||
||		WARNING: Do NOT Claim This As Your Own. Do NOT Re-Release This Without Permission.    ||
||      							DO NOT SELL THIS SCRIPT! 								  ||
||                                                                                            ||
\*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
#include <a_samp>
#define CARMENU 25000
#define dcmd(%1,%2,%3) if (!strcmp((%3)[1], #%1, true, (%2)) && ((((%3)[(%2) + 1] == '\0') && (dcmd_%1(playerid, ""))) || (((%3)[(%2) + 1] == ' ') && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
//==============================================================================
new Float:X, Float:Y, Float:Z, Float:Angle;
new CurrentSpawnedVehicle[MAX_PLAYERS];
//==============================================================================
public OnFilterScriptInit()
{
	print("===============================================");
	print("Vehicle Selection Menu By [03]Garsino Loaded...");
	print("===============================================");
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	dcmd(carmenu, 7, cmdtext);
	return 0;
}
dcmd_carmenu(playerid, params[])
{
	#pragma unused params
	//if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,0xF60000AA, "You Need To Be An Admin To Use This Command");
	//else
	ShowPlayerDialog(playerid, CARMENU, DIALOG_STYLE_LIST, "Vehicle Selection Menu","Bikes\nCars 1 [A-E]\nCars 2 [F-P]\nCars 3 [P-S]\nCars 4 [S-Z]\nHelicopters\nPlanes\nBoats\nTrains\nTrailers\nRC Vehicles + Vortex", "Select", "Cancel");
    return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
//==============================================================================
	GetPlayerPos(playerid, X,Y,Z);
	GetPlayerFacingAngle(playerid,Angle);
//==============================================================================
//                           		Carmenu
//==============================================================================
	if(dialogid == CARMENU)
	{
		if(response)
		{
   			if(listitem == 0) // Bikes
   			{
				ShowPlayerDialog(playerid, CARMENU+1, DIALOG_STYLE_LIST, "Bikes", "BF-400\nBike\nBMX\nHPV1000\nFaggio\nFCR-900\nFreeway\nMountain Bike\nNRG-500\nPCJ-600\nPizzaboy\nSanchez\nWayfarer\nQuad\nBack", "Select", "Cancel");
			}
			if(listitem == 1) // Cars [A-E]
			{
				new cMenuString[408];
				cMenuString = " ";
				strcat(cMenuString, "Admiral\nAlpha\nAmbulance\nBaggage\nBandito\nBanshee\nBarracks\nBenson\nBerkley's RC Van\nBF Injection\nBlade\nBlista Compact\nBloodring Banger\nBobcat\nBoxville 1\nBoxville 2\nBravura\nBroadway\nBuccaneer\nBuffalo\nBullet\nBurrito\nBus\nCabbie\n");
				strcat(cMenuString, "Caddy\nCadrona\nCamper\nCement Truck\nCheetah\nClover\nClub\nCoach\nCombine Harvester\nComet\nDFT-30\nDozer\nDumper\nDune(ride)\nElegant\nElegy\nEmperor\nEsperanto\nEuros\nBack");
				ShowPlayerDialog(playerid, CARMENU+2, DIALOG_STYLE_LIST, "Cars 1 [A-E]", cMenuString, "Select", "Cancel");
			}
			if(listitem == 2) // Cars 2 [F-P]
			{
				new cMenuString[408];
				cMenuString = " ";
				strcat(cMenuString, "FBI Rancher\nFBI Truck\nFeltzer\nFiretruck 1\nFiretruck 2\nFlash\nFlatbed\nForklift\nFortune\nGlendale 1\nGlendale 2\nGreenwood\nHermes\nHotdog\nHotknife\nHotring Racer 1\nHotring Racer 2\nHotring Racer 3\nHuntley\nHustler\nInfernus\nIntruder\nJester\nJourney\nKart\nLandstalker\nLinerunner\nMajestic\nManana\nMerit\nMesa\nMonster\nMonster A\nMonster B\nMoonbeam\nMower\nMr Whoopee\nMule\nNebula\n");
				strcat(cMenuString, "Newsvan\nOceanic\nPacker\nBack");
				ShowPlayerDialog(playerid, CARMENU+3, DIALOG_STYLE_LIST, "Cars 2 [F-P]", cMenuString, "Select", "Cancel");
			}
			if(listitem == 3) // Cars 3 [P-S]
			{
				ShowPlayerDialog(playerid, CARMENU+4, DIALOG_STYLE_LIST, "Cars 3 [P-S]", "Patriot\nPerenniel\nPetrol Tanker\nPhoenix\nPicador\nPolice Car (LSPD)\nPolice Car (SFPD)\nPolice Car (LVPD)\nPolice Ranger\nPolice Truck (Enforcer)\nPolice Truck (SWAT)\nPony\nPremier\nPrevion\nPrimo\nRancher\nRegina\nRemington\nRhino\nRoadtrain\nRomero\nRumpo\nSabre\nSadler 1\nSadler 2\nSandking\nSavanna\nSecuricar\nSentinel\nSlamvan\nSolair\nStafford\nStallion\nStratum\nStretch\nSultan\nSunrise\nBack", "Select", "Cancel");
			}
			if(listitem == 4) // Cars 4 [S-Z]
			{
				ShowPlayerDialog(playerid, CARMENU+5, DIALOG_STYLE_LIST, "Cars 4 [S-Z]", "Super GT\nSweeper\nTahoma\nTampa\nTaxi\nTornado\nTowtruck\nTractor\nTrashmaster\nTug\nTurismo\nUranus\nUtility Van\nVincent\nVirgo\nVoodoo\nWalton\nWashington\nWilliard\nWindsor\nYankee\nYosemite\nZR-350\nBack", "Select", "Cancel");
			}
			if(listitem == 5) // Helicopters
			{
				ShowPlayerDialog(playerid, CARMENU+6, DIALOG_STYLE_LIST, "Helicopters", "Cargobob\nHunter\nLeviathan\nMaverick\nPolice Maverick\nNews Chopper\nRaindance\nSparrow\nSea Sparrow\nBack", "Select", "Cancel");
   			}
			if(listitem == 6) // Planes
			{
				ShowPlayerDialog(playerid, CARMENU+7, DIALOG_STYLE_LIST, "Planes", "Andromada\nAT-400\nBeagle\nCropduster\nDodo\nHydra\nNevada\nRustler\nShamal\nSkimmer\nStuntplane\nBack", "Select", "Cancel");
   			}
			if(listitem == 7) // Boats
			{
				ShowPlayerDialog(playerid, CARMENU+8, DIALOG_STYLE_LIST, "Boats", "Coastguard\nDinghy\nJetmax\nLaunch\nMarquis\nPredator\nReefer\nSpeeder\nSquallo\nTropic\nBack", "Select", "Cancel");
   			}
			if(listitem == 8) // Trains
			{
				ShowPlayerDialog(playerid, CARMENU+9, DIALOG_STYLE_LIST, "Trains", "Brown Streak\nFreight Box Trailer\nFreight Flat Trailer\nFreight\nStreak Trailer\nTram\nBack", "Select", "Cancel");
   			}
			if(listitem == 9) // Trailers
			{
				ShowPlayerDialog(playerid, CARMENU+10, DIALOG_STYLE_LIST, "Trailers", "Article Trailer 1\nArticle Trailer 2\nArticle Trailer 3\nBaggage Trailer (A)\nBaggage Trailer (B)\nFarm Trailer\nPetrol Trailer\nTug Stairs Trailer\nUtility Trailer\nBack", "Select", "Cancel");
   			}
			if(listitem == 10) // RC Vehicles + Vortex
			{
				ShowPlayerDialog(playerid, CARMENU+11, DIALOG_STYLE_LIST, "RC Vehicles + Vortex", "RC Bandit\nRC Cam\nRC Tiger\nRC Baron\nRC Goblin\nRC Raider\nVortex\nBack", "Select", "Cancel");
   			}
		}
		return 1;
	}
//==============================================================================
//                          		 Bikes
//==============================================================================
	if(dialogid == CARMENU+1) // Bikes
	{
		if(response)
		{
			if(listitem == 0) // BF-400
			{
   				CreateVehicleEx(playerid,581, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 1) // Bike
			{
				CreateVehicleEx(playerid,509, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 2) //  BMX
			{
				CreateVehicleEx(playerid,481, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 3) //  HPV1000
			{
				CreateVehicleEx(playerid,523, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 4) //  Faggio
			{
				CreateVehicleEx(playerid,462, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 5) // FCR-900
			{
				CreateVehicleEx(playerid,521, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 6) // Freeway
  			{
  				CreateVehicleEx(playerid,463, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 7) // Mountain Bike
  			{
  				CreateVehicleEx(playerid,510, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 8) // NRG-500
  			{
  				CreateVehicleEx(playerid,522, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 9) // PCJ-600
  			{
  				CreateVehicleEx(playerid,461, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 10) // Pizzaboy
  			{
  				CreateVehicleEx(playerid,448, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 11) // Sanchez
  			{
  				CreateVehicleEx(playerid,468, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 12) // Wayfarer
  			{
  				CreateVehicleEx(playerid,586, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 13) // Quad
  			{
  				CreateVehicleEx(playerid,471, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 14) // Back
  			{
			ShowPlayerDialog(playerid, CARMENU, DIALOG_STYLE_LIST, "Vehicle Selection Menu","Bikes\nCars 1 [A-E]\nCars 2 [F-P]\nCars 3 [P-S]\nCars 4 [S-Z]\nHelicopters\nPlanes\nBoats\nTrains\nTrailers\nRC Vehicles + Vortex", "Select", "Cancel");
			}

		}
		return 1;
	}
//==============================================================================
//                          		 Cars 1
//==============================================================================
	if(dialogid == CARMENU+2) // Cars 1
	{
		if(response)
		{
			if(listitem == 0) // Admiral
			{
				CreateVehicleEx(playerid,445, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 1) // Alpha
			{
				CreateVehicleEx(playerid,602, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 2) // Ambulance
			{
				CreateVehicleEx(playerid,416, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 3) // Baggage
			{
				CreateVehicleEx(playerid,485, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 4) // Bandito
			{
				CreateVehicleEx(playerid,568, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 5) // Banshee
			{
				CreateVehicleEx(playerid,429, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 6) // Barracks
			{
				CreateVehicleEx(playerid,433, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 7) // Benson
			{
				CreateVehicleEx(playerid,499, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 8) // Berkley's RC Van
			{
				CreateVehicleEx(playerid,459, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 9) //BF Injection
			{
				CreateVehicleEx(playerid,424, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 10) // Blade
			{
				CreateVehicleEx(playerid,536, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 11) // Blista Compact
			{
				CreateVehicleEx(playerid,496, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 12) // Bloodring Banger
			{
				CreateVehicleEx(playerid,504, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 13) // Bobcat
			{
				CreateVehicleEx(playerid,422, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 14) // Boxville 1
			{
				CreateVehicleEx(playerid,609, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 15) // Boxville 2
			{
				CreateVehicleEx(playerid,498, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 16) // Bravura
			{
				CreateVehicleEx(playerid,401, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 17) // Broadway
			{
				CreateVehicleEx(playerid,575, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 18) // Buccaneer
			{
				CreateVehicleEx(playerid,518, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 19) // Buffalo
			{
				CreateVehicleEx(playerid,402, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 20) // Bullet
			{
				CreateVehicleEx(playerid,541, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 21) // Burrito
			{
				CreateVehicleEx(playerid,482, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 22) // Bus
			{
				CreateVehicleEx(playerid,431, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 23) // Cabbie
			{
				CreateVehicleEx(playerid,438, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 24) // Caddy
			{
				CreateVehicleEx(playerid,457, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 25) // Cadrona
			{
				CreateVehicleEx(playerid,527, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 26) // Camper
			{
				CreateVehicleEx(playerid,483, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 27) // Cement Truck
			{
				CreateVehicleEx(playerid,524, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 28) // Cheetah
			{
				CreateVehicleEx(playerid,415, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 29) // Clover
			{
				CreateVehicleEx(playerid,542, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 30) // Club
			{
				CreateVehicleEx(playerid,589, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 31) // Coach
			{
				CreateVehicleEx(playerid,437, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 32) // Combine Harvester
			{
				CreateVehicleEx(playerid,532, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 33) // Comet
			{
				CreateVehicleEx(playerid,480, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 34) // DFT-30
			{
				CreateVehicleEx(playerid,578, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 35) // Dozer
			{
				CreateVehicleEx(playerid,486, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 36) // Dumper
			{
				CreateVehicleEx(playerid, 406, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 37) // Dune(ride)
			{
				CreateVehicleEx(playerid, 573, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 38) // Elegant
			{
				CreateVehicleEx(playerid,507, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 39) // Elegy
			{
				CreateVehicleEx(playerid,562, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 40) // Emperor
			{
				CreateVehicleEx(playerid,585, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 41) // Esperanto
			{
				CreateVehicleEx(playerid,419, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 42) // Euros
			{
				CreateVehicleEx(playerid,587, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 43) // Back
			{
				ShowPlayerDialog(playerid, CARMENU, DIALOG_STYLE_LIST, "Vehicle Selection Menu","Bikes\nCars 1 [A-E]\nCars 2 [F-P]\nCars 3 [P-S]\nCars 4 [S-Z]\nHelicopters\nPlanes\nBoats\nTrains\nTrailers\nRC Vehicles + Vortex", "Select", "Cancel");
			}
		}
		return 1;
	}

//==============================================================================
//                          		 Cars 2
//==============================================================================
	if(dialogid == CARMENU+3) // Cars 2
	{
		if(response)
		{
			if(listitem == 0) // FBI Rancher
			{
				CreateVehicleEx(playerid,490, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 1) // FBI Truck
			{
				CreateVehicleEx(playerid,528, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 2) // Feltzer
			{
				CreateVehicleEx(playerid,533, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 3) // Firetruck 1
			{
				CreateVehicleEx(playerid,544, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 4) // Firetruck 2
			{
				CreateVehicleEx(playerid,407, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 5) // Flash
			{
				CreateVehicleEx(playerid,565, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 6) // Flatbed
			{
				CreateVehicleEx(playerid,455, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 7) // Forklift
			{
				CreateVehicleEx(playerid,530, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 8) // Fortune
			{
				CreateVehicleEx(playerid,526, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 9) // Glendale 1
			{
				CreateVehicleEx(playerid,466, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 10) // Glendale 2
			{
				CreateVehicleEx(playerid,604, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 11) // Greenwood
			{
				CreateVehicleEx(playerid,492, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 12) // Hermes
			{
				CreateVehicleEx(playerid,474, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 13) // Hotdog
			{
				CreateVehicleEx(playerid,588, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 14) // Hotknife
			{
				CreateVehicleEx(playerid,434, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 15) // Hotring Racer 1
			{
				CreateVehicleEx(playerid,502, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 16) // Hotring Racer 2
			{
				CreateVehicleEx(playerid,503, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 17) // Hotring Racer 3
			{
				CreateVehicleEx(playerid,494, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 18) // Huntley
			{
				CreateVehicleEx(playerid,579, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 19) // Hustler
			{
				CreateVehicleEx(playerid,545, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 20) // Infernus
			{
				CreateVehicleEx(playerid,411, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 21) // Intruder
			{
				CreateVehicleEx(playerid,546, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 22) // Jester
			{
				CreateVehicleEx(playerid,559, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 23) // Journey
			{
				CreateVehicleEx(playerid,508, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 24) // Kart
			{
				CreateVehicleEx(playerid,571, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 25) // Landstalker
			{
				CreateVehicleEx(playerid,400, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 26) // Linerunner
			{
				CreateVehicleEx(playerid,403, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 27) // Majestic
			{
				CreateVehicleEx(playerid,517, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 28) // Manana
			{
				CreateVehicleEx(playerid,410, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 29) // Merit
			{
				CreateVehicleEx(playerid,551, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 30) // Mesa
			{
				CreateVehicleEx(playerid,500, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 31) // Monster
			{
				CreateVehicleEx(playerid, 444, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 32) // Monster A
			{
				CreateVehicleEx(playerid, 556, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 33) // Monster B
			{
				CreateVehicleEx(playerid, 557, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 34) // Moonbeam
			{
				CreateVehicleEx(playerid,418, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 35) // Mower
			{
				CreateVehicleEx(playerid,572, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 36) // Mr Whoopee
			{
				CreateVehicleEx(playerid, 423, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 37) // Mule
			{
				CreateVehicleEx(playerid, 414, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 38) // Nebula
			{
				CreateVehicleEx(playerid,516, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 39) // Newsvan
			{
				CreateVehicleEx(playerid,582, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 40) // Oceanic
			{
				CreateVehicleEx(playerid,467, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 41) // Packer
			{
				CreateVehicleEx(playerid,443, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 42) // Back
			{
				ShowPlayerDialog(playerid, CARMENU, DIALOG_STYLE_LIST, "Vehicle Selection Menu","Bikes\nCars 1 [A-E]\nCars 2 [F-P]\nCars 3 [P-S]\nCars 4 [S-Z]\nHelicopters\nPlanes\nBoats\nTrains\nTrailers\nRC Vehicles + Vortex", "Select", "Cancel");
			}
		}
		return 1;
	}

//==============================================================================
//                             			Cars 3
//==============================================================================
	if(dialogid == CARMENU+4) // Cars 3
	{
		if(response)
		{
			if(listitem == 0) // Patriot
			{
				CreateVehicleEx(playerid,470, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 1) // Perenniel
			{
				CreateVehicleEx(playerid,404, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 2) // Petrol Tanker
			{
				CreateVehicleEx(playerid,514, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 3) // Phoenix
			{
				CreateVehicleEx(playerid,603, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 4) // Picador
			{
				CreateVehicleEx(playerid,600, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 5) // Police Car LSPD
			{
				CreateVehicleEx(playerid,596, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 6) // Police Car SFPD
			{
				CreateVehicleEx(playerid,597, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 7) // Police Car LVPD
			{
				CreateVehicleEx(playerid,598, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 8) // Police Ranger
			{
				CreateVehicleEx(playerid,599, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 9) // Police Truck (Enforcer)
			{
				CreateVehicleEx(playerid,427, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 10) // Police Truck (SWAT)
			{
				CreateVehicleEx(playerid,601, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 11) // Pony
			{
				CreateVehicleEx(playerid,413, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 12) // Premier
			{
				CreateVehicleEx(playerid,426, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 13) // Previon
			{
				CreateVehicleEx(playerid,436, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 14) // Primo
			{
				CreateVehicleEx(playerid,547, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 15) // Rancher
			{
				CreateVehicleEx(playerid,489, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 16) // Regina
			{
				CreateVehicleEx(playerid,479, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 17) // Remington
			{
				CreateVehicleEx(playerid,534, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 18) // Rhino
			{
				//if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOUR_SYSTEM, "You Can Not Spawn This Vehicle!");
				//else
				CreateVehicleEx(playerid,432, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 19) // Roadtrain
			{
				CreateVehicleEx(playerid,515, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 20) // Romero
			{
				CreateVehicleEx(playerid,442, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 21) // Rumpo
			{
				CreateVehicleEx(playerid,440, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 22) // Sabre
			{
				CreateVehicleEx(playerid, 475, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 23) // Sadler 1
			{
				CreateVehicleEx(playerid,543, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 24) // Sadler 2
			{
				CreateVehicleEx(playerid,605, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 25) // Sandking
			{
				CreateVehicleEx(playerid,495, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 26) // Savanna
			{
				CreateVehicleEx(playerid,567, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 27) // Securicar
			{
				CreateVehicleEx(playerid,428, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 28) // Sentinel
			{
				CreateVehicleEx(playerid,405, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 29) // Slamvan
			{
				CreateVehicleEx(playerid,535, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 30) // Solair
			{
				CreateVehicleEx(playerid,458, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 31) // Stafford
			{
				CreateVehicleEx(playerid,580, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 32) // Stallion
			{
				CreateVehicleEx(playerid,439, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 33) // Stratum
			{
				CreateVehicleEx(playerid,561, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 34) // Stretch
			{
				CreateVehicleEx(playerid,409, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 35) // Sultan
			{
				CreateVehicleEx(playerid,560, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 36) // Sunrise
			{
				CreateVehicleEx(playerid,550, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 37) // Back
			{
			ShowPlayerDialog(playerid, CARMENU, DIALOG_STYLE_LIST, "Vehicle Selection Menu","Bikes\nCars 1 [A-E]\nCars 2 [F-P]\nCars 3 [P-S]\nCars 4 [S-Z]\nHelicopters\nPlanes\nBoats\nTrains\nTrailers\nRC Vehicles + Vortex", "Select", "Cancel");
			}
		}
		return 1;
	}

//==============================================================================
//                          		 Cars 4
//==============================================================================
	if(dialogid == CARMENU+5) // Cars 4
	{
		if(response)
		{
			if(listitem == 0) // Super GT
			{
				CreateVehicleEx(playerid,506, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 1) // Sweeper
			{
				CreateVehicleEx(playerid,574, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 2) // Tahoma
			{
				CreateVehicleEx(playerid,566, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 3) // Tampa
			{
				CreateVehicleEx(playerid,549, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 4) // Taxi
			{
				CreateVehicleEx(playerid,420, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 5) // Tornado
			{
				CreateVehicleEx(playerid,576, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 6) // Towtruck
			{
				CreateVehicleEx(playerid,525, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 7) // Tractor
			{
				CreateVehicleEx(playerid,531, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 8) // Trashmaster
			{
				CreateVehicleEx(playerid,408, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 9) // Tug
			{
				CreateVehicleEx(playerid,583, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 10) // Turismo
			{
				CreateVehicleEx(playerid,451, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 11) // Uranus
			{
				CreateVehicleEx(playerid,558, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 12) // Utility Van
			{
				CreateVehicleEx(playerid,552, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 13) // Vincent
			{
				CreateVehicleEx(playerid,540, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 14) // Virgo
			{
				CreateVehicleEx(playerid,491, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 15) // Voodoo
			{
				CreateVehicleEx(playerid,412, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 16) // Walton
			{
				CreateVehicleEx(playerid,478, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 17) // Washington
			{
				CreateVehicleEx(playerid, 421, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 18) // Williard
			{
				CreateVehicleEx(playerid,529, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 19) // Windsor
			{
				CreateVehicleEx(playerid,555, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 20) // Yankee
			{
				CreateVehicleEx(playerid,456, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 21) // Yosemite
			{
				CreateVehicleEx(playerid,554, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 22) // ZR-350
			{
				CreateVehicleEx(playerid,477, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 23) // Back
			{
				ShowPlayerDialog(playerid, CARMENU, DIALOG_STYLE_LIST, "Vehicle Selection Menu","Bikes\nCars 1 [A-E]\nCars 2 [F-P]\nCars 3 [P-S]\nCars 4 [S-Z]\nHelicopters\nPlanes\nBoats\nTrains\nTrailers\nRC Vehicles + Vortex", "Select", "Cancel");
			}
		}
		return 1;
	}
//==============================================================================
//                          		 Helicopters
//==============================================================================
	if(dialogid == CARMENU+6) // Helicopters
	{
		if(response)
		{
			if(listitem == 0) // Cargobob
			{
				CreateVehicleEx(playerid, 548, X,Y,Z+6, Angle, random(126), random(126), -1);
			}
			if(listitem == 1) // Hunter
			{
				//if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOUR_SYSTEM, "You Can Not Spawn This Vehicle!");
				//else
				CreateVehicleEx(playerid,425, X,Y,Z+6, Angle, random(126), random(126), -1);
			}
			if(listitem == 2) // Leviathan
			{
				CreateVehicleEx(playerid,417, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 3) // Maverick
			{
				CreateVehicleEx(playerid,487, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 4) // Police Maverick
			{
				CreateVehicleEx(playerid,497, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 5) // News Chopper
			{
				CreateVehicleEx(playerid,488, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 6) // Raindance
			{
				CreateVehicleEx(playerid,563, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 7) // Sparrow
			{
				CreateVehicleEx(playerid,469, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 8) // Sea Sparrow
			{
				//if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOUR_SYSTEM, "You Can Not Spawn This Vehicle!");
				//else
				CreateVehicleEx(playerid,447, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 9) // Back
			{
			ShowPlayerDialog(playerid, CARMENU, DIALOG_STYLE_LIST, "Vehicle Selection Menu","Bikes\nCars 1 [A-E]\nCars 2 [F-P]\nCars 3 [P-S]\nCars 4 [S-Z]\nHelicopters\nPlanes\nBoats\nTrains\nTrailers\nRC Vehicles + Vortex", "Select", "Cancel");
			}
		}
		return 1;
	}
//==============================================================================
//                                  Planes
//==============================================================================
	if(dialogid == CARMENU+7) // Planes
	{
		if(response)
		{
			if(listitem == 0) // Andromada
			{
				//if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOUR_SYSTEM, "You Can Not Spawn This Vehicle!");
				//else
				CreateVehicleEx(playerid,592, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 1) // At-400
			{
				//if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOUR_SYSTEM, "You Can Not Spawn This Vehicle!");
				//else
				CreateVehicleEx(playerid,577, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 2) // Beagle
			{
				CreateVehicleEx(playerid,511, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 3) // Cropduster
			{
				CreateVehicleEx(playerid,512, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 4) // Dodo
			{
				CreateVehicleEx(playerid,593, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 5) // Hydra
			{
				//if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOUR_SYSTEM, "You Can Not Spawn This Vehicle!");
				//else
				CreateVehicleEx(playerid,520, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 6) // Nevada
			{
				//if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOUR_SYSTEM, "You Can Not Spawn This Vehicle!");
				//else
				CreateVehicleEx(playerid,553, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 7) // Rustler
			{
				//if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOUR_SYSTEM, "You Can Not Spawn This Vehicle!");
				//else
				CreateVehicleEx(playerid,476, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 8) // Shamal
			{
				CreateVehicleEx(playerid,519, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 9) // Skimmer
			{
				CreateVehicleEx(playerid,460, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 10) // Stuntplane
			{
				CreateVehicleEx(playerid,513, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 11) // Back
			{
				ShowPlayerDialog(playerid, CARMENU, DIALOG_STYLE_LIST, "Vehicle Selection Menu","Bikes\nCars 1 [A-E]\nCars 2 [F-P]\nCars 3 [P-S]\nCars 4 [S-Z]\nHelicopters\nPlanes\nBoats\nTrains\nTrailers\nRC Vehicles + Vortex", "Select", "Cancel");
			}
		}
		return 1;
	}
//==============================================================================
//                                  Boats
//==============================================================================
	if(dialogid == CARMENU+8) // Boats
	{
		if(response)
		{
			if(listitem == 0) // Coastguard
			{
				CreateVehicleEx(playerid,472, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 1) // Dinghy
			{
				CreateVehicleEx(playerid,473, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 2) // Jetmax
			{
				CreateVehicleEx(playerid,493, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 3) // Launch
			{
				CreateVehicleEx(playerid,595, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 4) // Marquis
			{
				CreateVehicleEx(playerid,484, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 5) // Predator
			{
				//if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOUR_SYSTEM, "You Can Not Spawn This Vehicle!");
				//else
				CreateVehicleEx(playerid,430, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 6) // Reefer
			{
				CreateVehicleEx(playerid,453, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 7) // Speeder
			{
				CreateVehicleEx(playerid,452, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 8) // Squallo
			{
				CreateVehicleEx(playerid,446, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 9) // Tropic
			{
				CreateVehicleEx(playerid,454, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 10) // Back
			{
   				ShowPlayerDialog(playerid, CARMENU, DIALOG_STYLE_LIST, "Vehicle Selection Menu","Bikes\nCars 1 [A-E]\nCars 2 [F-P]\nCars 3 [P-S]\nCars 4 [S-Z]\nHelicopters\nPlanes\nBoats\nTrains\nTrailers\nRC Vehicles + Vortex", "Select", "Cancel");
			}
		}
		return 1;
	}
//==============================================================================
//                          		 Trains
//==============================================================================
	if(dialogid == CARMENU+9) // Trains
	{
		if(response)
		{
			if(listitem == 0) // Brown Streak
			{
			//if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOUR_SYSTEM, "You Can Not Spawn This Vehicle!");
			//else
			AddStaticVehicle(537, X,Y,Z+1, Angle, random(126), random(126));
			}
			if(listitem == 1) // Freight Box Trailer
			{
			//if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOUR_SYSTEM, "You Can Not Spawn This Vehicle!");
			//else
			CreateVehicleEx(playerid, 590, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 2) // Freight Flat Trailer
			{
			//if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOUR_SYSTEM, "You Can Not Spawn This Vehicle!");
			//else
			CreateVehicleEx(playerid,569, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 3) // Freight
			{
			//if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOUR_SYSTEM, "You Can Not Spawn This Vehicle!");
			//else
			AddStaticVehicle(538, X,Y,Z+1, Angle, random(126), random(126));
			}
			if(listitem == 4) // Streak Trailer
			{
			//if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOUR_SYSTEM, "You Can Not Spawn This Vehicle!");
			//else
			CreateVehicleEx(playerid,570, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 5) // Tram
			{
			//if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOUR_SYSTEM, "This Vehicle Is Not For You!");
			//else
			AddStaticVehicle(449, X,Y,Z+1, Angle, random(126), random(126));
			}
			if(listitem == 6) // Back
			{
			ShowPlayerDialog(playerid, CARMENU, DIALOG_STYLE_LIST, "Vehicle Selection Menu","Bikes\nCars 1 [A-E]\nCars 2 [F-P]\nCars 3 [P-S]\nCars 4 [S-Z]\nHelicopters\nPlanes\nBoats\nTrains\nTrailers\nRC Vehicles + Vortex", "Select", "Cancel");
			}
		}
		return 1;
	}
//==============================================================================
//                          		 Trailers
//==============================================================================
	if(dialogid == CARMENU+10) // Trailers
	{
		if(response)
		{

			if(listitem == 0) // Article Trailer 1
			{
				CreateVehicleEx(playerid,435, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 1) // Article Trailer 2
			{
				CreateVehicleEx(playerid,450, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 2) // Article Trailer 3
			{
				CreateVehicleEx(playerid,591, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 3) // Baggage Trailer (A)
			{
				CreateVehicleEx(playerid,606, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 4) // Baggage Trailer (B)
			{
				CreateVehicleEx(playerid,607, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 5) // Farm Trailer
			{
				CreateVehicleEx(playerid,610, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 6) // Petrol Trailer
			{
				CreateVehicleEx(playerid,584, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 7) // Tug Stairs Trailer
			{
				CreateVehicleEx(playerid,608, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 8) // Utility Trailer
			{
				CreateVehicleEx(playerid,611, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 9) // Back
			{
            ShowPlayerDialog(playerid, CARMENU, DIALOG_STYLE_LIST, "Vehicle Selection Menu","Bikes\nCars 1 [A-E]\nCars 2 [F-P]\nCars 3 [P-S]\nCars 4 [S-Z]\nHelicopters\nPlanes\nBoats\nTrains\nTrailers\nRC Vehicles + Vortex", "Select", "Cancel");
			}
		}
		return 1;
	}
//==============================================================================
//                          	RC Vehicles + Vortex
//==============================================================================
	if(dialogid == CARMENU+11) // RC Vehicles + Vortex
	{
		if(response)
		{
			if(listitem == 0) // RC Bandit
			{
				CreateVehicleEx(playerid,441, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 1) // RC Cam
			{
				CreateVehicleEx(playerid,594, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 2) // RC Tiger
			{
				CreateVehicleEx(playerid,564, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 3) // RC Baron
			{
			//if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOUR_SYSTEM, "This Vehicle Is Not For You!");
			//else
			CreateVehicleEx(playerid,464, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 4) // RC Goblin
			{
				CreateVehicleEx(playerid,501, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 5) // RC Raider
			{
				CreateVehicleEx(playerid,465, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 6) // Vortex
			{
				CreateVehicleEx(playerid,539, X,Y,Z+1, Angle, random(126), random(126), -1);
			}
			if(listitem == 7) // Back
			{
				ShowPlayerDialog(playerid, CARMENU, DIALOG_STYLE_LIST, "Vehicle Selection Menu","Bikes\nCars 1 [A-E]\nCars 2 [F-P]\nCars 3 [P-S]\nCars 4 [S-Z]\nHelicopters\nPlanes\nBoats\nTrains\nTrailers\nRC Vehicles + Vortex", "Select", "Cancel");
			}
		}
		return 1;
	}
	return 0;
}
//==============================================================================
stock IsVehicleOccupied(vehicleid)
{
  	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(GetPlayerState(i) == PLAYER_STATE_DRIVER || GetPlayerState(i) == PLAYER_STATE_PASSENGER)
		{
			if(GetPlayerVehicleID(i) == vehicleid)
			{
				return 1;
			}
		}
	}
	return 0;
}
//==============================================================================
stock CreateVehicleEx(playerid, modelid, Float:posX, Float:posY, Float:posZ, Float:angle, Colour1, Colour2, respawn_delay)
{
	new world = GetPlayerVirtualWorld(playerid);
	new interior = GetPlayerInterior(playerid);
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		DestroyVehicle(GetPlayerVehicleID(playerid));
		GetPlayerPos(playerid, posX, posY, posZ);
		GetPlayerFacingAngle(playerid, angle);
		CurrentSpawnedVehicle[playerid] = CreateVehicle(modelid, posX, posY, posZ, angle, Colour1, Colour2, respawn_delay);
        LinkVehicleToInterior(CurrentSpawnedVehicle[playerid], interior);
		SetVehicleVirtualWorld(CurrentSpawnedVehicle[playerid], world);
		SetVehicleZAngle(CurrentSpawnedVehicle[playerid], angle);
		PutPlayerInVehicle(playerid, CurrentSpawnedVehicle[playerid], 0);
		SetPlayerInterior(playerid, interior);
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
	    if(IsVehicleOccupied(CurrentSpawnedVehicle[playerid])) {} else DestroyVehicle(CurrentSpawnedVehicle[playerid]);
		GetPlayerPos(playerid, posX, posY, posZ);
		GetPlayerFacingAngle(playerid, angle);
		CurrentSpawnedVehicle[playerid] = CreateVehicle(modelid, posX, posY, posZ, angle, Colour1, Colour2, respawn_delay);
		LinkVehicleToInterior(CurrentSpawnedVehicle[playerid], interior);
		SetVehicleVirtualWorld(CurrentSpawnedVehicle[playerid], world);
		SetVehicleZAngle(CurrentSpawnedVehicle[playerid], angle);
		PutPlayerInVehicle(playerid, CurrentSpawnedVehicle[playerid], 0);
		SetPlayerInterior(playerid, interior);
	}
	return 1;
}
//==============================================================================
