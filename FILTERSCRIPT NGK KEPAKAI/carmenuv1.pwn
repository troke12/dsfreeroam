//==============================================================================
//                 Vehicle Selection Menu v1.3 by [03]Garsino!
//==============================================================================
// - Credits to DracoBlue for dcmd.
// - Credits to Zeex for ZCMD.
//==============================================================================
//                              Changelog v1.3
//==============================================================================
// - [Script] Rewrote script. It is now much shorter and uses structured switch() statements.
// - [Fixed] Fixed a minor bug with destroying a player's currently spawned vehicle.
// - [Script] Added configuration macros to the script. You can now easily toggle between ZCMD, DCMD and STRCMP.
// - [Script] Re-scripted CreateVehicleEx.
// - [Fixed] You can no longer spawn vehicles while being dead or in spectate mode.
//==============================================================================
#define FILTERSCRIPT
#define VERSION 			1.3
//------------------------------------------------------------------------------
#include <a_samp>
#define ZCMD 				0 // command type: ZCMD (by Zeex - fastest command processor of these three).
#define DCMD            	1 // command type: DCMD (by DracoBlue).
#define STRCMP          	2 // command type: STRCMP (string comperisation)
#define COMMAND_TYPE   		ZCMD // What command processor should the script use? Available modes: ZCMD, DCMD and STRCMP (WARNING: case sensetive!)
#define DIALOGID 			1600 // The dialog ID the script uses. Change if you encounter any conflicts.
#define ADMIN_ONLY      	true // true = only RCON admins will be able to use the /carmenu command | false = everyone will be able to use the /carmenu command
#define ADMIN_ONLY_VEHICLES true // true = only RCON admins will be able to use vehicles such as the hydra, hunter and seasparrow | false = all vehicles are available for everyone
//------------------------------------------------------------------------------
//                          EDIT BELOW AT OWN RISK!
//------------------------------------------------------------------------------
#define _ShowDialog(%0) ShowPlayerDialog(%0, DIALOGID, DIALOG_STYLE_LIST, "Vehicle Selection Menu v"#VERSION" by [03]Garsino", "Bikes\nCars 1 [A-E]\nCars 2 [F-P]\nCars 3 [P-S]\nCars 4 [S-Z]\nHelicopters\nPlanes\nBoats\nTrains\nTrailers\nRC Vehicles + Vortex", "Select", "Cancel")
#if COMMAND_TYPE == ZCMD // Credits to Zeex for zcmd.
	#include <zcmd>
#endif
#if COMMAND_TYPE == DCMD // Credits to DracoBlue for dcmd.
	#define dcmd(%1,%2,%3) if (!strcmp((%3)[1], #%1, true, (%2)) && ((((%3)[(%2) + 1] == '\0') && (dcmd_%1(playerid, ""))) || (((%3)[(%2) + 1] == ' ') && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
#endif
//==============================================================================
new cVeh[MAX_PLAYERS] = INVALID_VEHICLE_ID;
//==============================================================================
public OnFilterScriptInit()
{
	print("Vehicle Selection Menu v"#VERSION" by [03]Garsino has been loaded.");
	return 1;
}
public OnFilterScriptExit()
{
    print("Vehicle Selection Menu v"#VERSION" by [03]Garsino has been unloaded.");
	return 1;
}
public OnPlayerConnect(playerid)
{
    cVeh[playerid] = INVALID_VEHICLE_ID;
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
    VehicleDestroy(playerid);
	return 1;
}
stock VehicleDestroy(playerid, bool:always_destroy = false)
{
	if(cVeh[playerid] == INVALID_VEHICLE_ID) return 0;
	if(always_destroy == true)
	{
	    DestroyVehicle(cVeh[playerid]);
	}
	else
	{
		if(!IsVehicleOccupied(cVeh[playerid]))
		{
			DestroyVehicle(cVeh[playerid]);
		}
		else return 0;
	}
	cVeh[playerid] = INVALID_VEHICLE_ID;
	return 1;
}
#if COMMAND_TYPE == ZCMD
CMD:carmenu(playerid, params[])
{
	#if ADMIN_ONLY == true
		if(!IsPlayerAdmin(playerid)) return 0;
	#endif
 	_ShowDialog(playerid);
    return 1;
}
#endif
#if COMMAND_TYPE == DCMD
dcmd_carmenu(playerid, params[])
{
	#pragma unused params
	#if ADMIN_ONLY == true
		if(!IsPlayerAdmin(playerid)) return 0;
	#endif
 	_ShowDialog(playerid);
    return 1;
}
#endif
#if COMMAND_TYPE != ZCMD
public OnPlayerCommandText(playerid, cmdtext[])
{
	#if COMMAND_TYPE == DCMD
	dcmd(carmenu, 7, cmdtext);
	#else
	if(!strcmp(cmdtext, "/carmenu"))
	{
		#if ADMIN_ONLY == true
			if(!IsPlayerAdmin(playerid)) return 0;
		#endif
	 	_ShowDialog(playerid);
	}
	#endif
	return 0;
}
#endif
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    new cMenuString[408];
    cMenuString = "";
//==============================================================================
//                           		Carmenu
//==============================================================================
	if(dialogid == DIALOGID && response)
	{
		switch(listitem)
		{
   			case 0: ShowPlayerDialog(playerid, (DIALOGID + 1), DIALOG_STYLE_LIST, "Bikes", "BF-400\nBike\nBMX\nHPV1000\nFaggio\nFCR-900\nFreeway\nMountain Bike\nNRG-500\nPCJ-600\nPizzaboy\nSanchez\nWayfarer\nQuad\nBack", "Select", "Cancel");
			case 1: // Cars [A-E]
			{
				strcat(cMenuString, "Admiral\nAlpha\nAmbulance\nBaggage\nBandito\nBanshee\nBarracks\nBenson\nBerkley's RC Van\nBF Injection\nBlade\nBlista Compact\nBloodring Banger\nBobcat\nBoxville 1\nBoxville 2\nBravura\nBroadway\nBuccaneer\nBuffalo\nBullet\nBurrito\nBus\nCabbie\n");
				strcat(cMenuString, "Caddy\nCadrona\nCamper\nCement Truck\nCheetah\nClover\nClub\nCoach\nCombine Harvester\nComet\nDFT-30\nDozer\nDumper\nDune(ride)\nElegant\nElegy\nEmperor\nEsperanto\nEuros\nBack");
				ShowPlayerDialog(playerid, (DIALOGID + 2), DIALOG_STYLE_LIST, "Cars 1 [A-E]", cMenuString, "Select", "Cancel");
			}
			case 2: // Cars 2 [F-P]
			{
				strcat(cMenuString, "FBI Rancher\nFBI Truck\nFeltzer\nFiretruck 1\nFiretruck 2\nFlash\nFlatbed\nForklift\nFortune\nGlendale 1\nGlendale 2\nGreenwood\nHermes\nHotdog\nHotknife\nHotring Racer 1\nHotring Racer 2\nHotring Racer 3\nHuntley\nHustler\nInfernus\nIntruder\nJester\nJourney\nKart\nLandstalker\nLinerunner\nMajestic\nManana\nMerit\nMesa\nMonster\nMonster A\nMonster B\nMoonbeam\nMower\nMr Whoopee\nMule\nNebula\n");
				strcat(cMenuString, "Newsvan\nOceanic\nPacker\nBack");
				ShowPlayerDialog(playerid, (DIALOGID + 3), DIALOG_STYLE_LIST, "Cars 2 [F-P]", cMenuString, "Select", "Cancel");
			}
			case 3:
			{
			    strcat(cMenuString, "Patriot\nPerenniel\nPetrol Tanker\nPhoenix\nPicador\nPolice Car (LSPD)\nPolice Car (SFPD)\nPolice Car (LVPD)\nPolice Ranger\nPolice Truck (Enforcer)\nPolice Truck (SWAT)\nPony\nPremier\nPrevion\nPrimo\nRancher\nRegina\nRemington\n");
				strcat(cMenuString, "Rhino\nRoadtrain\nRomero\nRumpo\nSabre\nSadler 1\nSadler 2\nSandking\nSavanna\nSecuricar\nSentinel\nSlamvan\nSolair\nStafford\nStallion\nStratum\nStretch\nSultan\nSunrise\nBack");
				ShowPlayerDialog(playerid, (DIALOGID + 4), DIALOG_STYLE_LIST, "Cars 3 [P-S]", cMenuString, "Select", "Cancel");
			}
			case 4: ShowPlayerDialog(playerid, (DIALOGID + 5), DIALOG_STYLE_LIST, "Cars 4 [S-Z]", "Super GT\nSweeper\nTahoma\nTampa\nTaxi\nTornado\nTowtruck\nTractor\nTrashmaster\nTug\nTurismo\nUranus\nUtility Van\nVincent\nVirgo\nVoodoo\nWalton\nWashington\nWilliard\nWindsor\nYankee\nYosemite\nZR-350\nBack", "Select", "Cancel");
			case 5: ShowPlayerDialog(playerid, (DIALOGID + 6), DIALOG_STYLE_LIST, "Helicopters", "Cargobob\nHunter\nLeviathan\nMaverick\nPolice Maverick\nNews Chopper\nRaindance\nSparrow\nSea Sparrow\nBack", "Select", "Cancel");
			case 6: ShowPlayerDialog(playerid, (DIALOGID + 7), DIALOG_STYLE_LIST, "Planes", "Andromada\nAT-400\nBeagle\nCropduster\nDodo\nHydra\nNevada\nRustler\nShamal\nSkimmer\nStuntplane\nBack", "Select", "Cancel");
			case 7: ShowPlayerDialog(playerid, (DIALOGID + 8), DIALOG_STYLE_LIST, "Boats", "Coastguard\nDinghy\nJetmax\nLaunch\nMarquis\nPredator\nReefer\nSpeeder\nSquallo\nTropic\nBack", "Select", "Cancel");
			case 8: ShowPlayerDialog(playerid, (DIALOGID + 9), DIALOG_STYLE_LIST, "Trains", "Brown Streak\nFreight Box Trailer\nFreight Flat Trailer\nFreight\nStreak Trailer\nTram\nBack", "Select", "Cancel");
			case 9: ShowPlayerDialog(playerid, (DIALOGID + 10), DIALOG_STYLE_LIST, "Trailers", "Article Trailer 1\nArticle Trailer 2\nArticle Trailer 3\nBaggage Trailer (A)\nBaggage Trailer (B)\nFarm Trailer\nPetrol Trailer\nTug Stairs Trailer\nUtility Trailer\nBack", "Select", "Cancel");
			case 10: ShowPlayerDialog(playerid, (DIALOGID + 11), DIALOG_STYLE_LIST, "RC Vehicles + Vortex", "RC Bandit\nRC Cam\nRC Tiger\nRC Baron\nRC Goblin\nRC Raider\nVortex\nBack", "Select", "Cancel");
		}
		return 1;
	}
//==============================================================================
//                          		 Bikes
//==============================================================================
	if(dialogid == (DIALOGID + 1) && response) // Bikes
	{
		switch(listitem)
		{
			case 0: CreateVehicleEx(playerid, 581); // BF-400
			case 1: CreateVehicleEx(playerid, 509); // Bike
			case 2: CreateVehicleEx(playerid, 481);//  BMX
			case 3: CreateVehicleEx(playerid, 523); //  HPV1000
			case 4: CreateVehicleEx(playerid, 462); //  Faggio
			case 5: CreateVehicleEx(playerid, 521); // FCR-900
			case 6: CreateVehicleEx(playerid, 463); // Freeway
			case 7: CreateVehicleEx(playerid, 510); // Mountain Bike
			case 8: CreateVehicleEx(playerid, 522); // NRG-500
			case 9: CreateVehicleEx(playerid, 461); // PCJ-600
			case 10: CreateVehicleEx(playerid, 448); // Pizzaboy
			case 11: CreateVehicleEx(playerid, 468); // Sanchez
			case 12: CreateVehicleEx(playerid, 586); // Wayfarer
			case 13: CreateVehicleEx(playerid, 471); // Quad
			case 14: _ShowDialog(playerid);
		}
		return 1;
	}
//==============================================================================
//                          		 Cars 1
//==============================================================================
	if(dialogid == (DIALOGID + 2) && response) // Cars 1
	{
		switch(listitem)
		{
			case 0: CreateVehicleEx(playerid, 445); // Admiral
			case 1: CreateVehicleEx(playerid, 602); // Alpha
			case 2: CreateVehicleEx(playerid, 416); // Ambulance
			case 3: CreateVehicleEx(playerid, 485); // Baggage
			case 4: CreateVehicleEx(playerid, 568); // Bandito
			case 5: CreateVehicleEx(playerid, 429); // Banshee
			case 6: CreateVehicleEx(playerid, 433); // Barracks
			case 7: CreateVehicleEx(playerid, 499); // Benson
			case 8: CreateVehicleEx(playerid, 459); // Berkley's RC Van
			case 9: CreateVehicleEx(playerid, 424);  //BF Injection
			case 10: CreateVehicleEx(playerid, 536); // Blade
			case 11: CreateVehicleEx(playerid, 496); // Blista Compact
			case 12: CreateVehicleEx(playerid, 504); // Bloodring Banger
			case 13: CreateVehicleEx(playerid, 422); // Bobcat
			case 14: CreateVehicleEx(playerid, 609); // Boxville 1
			case 15: CreateVehicleEx(playerid, 498); // Boxville 2
			case 16: CreateVehicleEx(playerid, 401); // Bravura
			case 17: CreateVehicleEx(playerid, 575); // Broadway
			case 18: CreateVehicleEx(playerid, 518); // Buccaneer
			case 19: CreateVehicleEx(playerid, 402); // Buffalo
			case 20: CreateVehicleEx(playerid, 541);  // Bullet
			case 21: CreateVehicleEx(playerid, 482);  // Burrito
			case 22: CreateVehicleEx(playerid, 431); // Bus
			case 23: CreateVehicleEx(playerid, 438); // Cabbie
			case 24: CreateVehicleEx(playerid, 457); // Caddy
			case 25: CreateVehicleEx(playerid, 527); // Cadrona
			case 26: CreateVehicleEx(playerid, 483); // Camper
			case 27: CreateVehicleEx(playerid, 524); // Cement Truck
			case 28: CreateVehicleEx(playerid, 415); // Cheetah
			case 29: CreateVehicleEx(playerid, 542); // Clover
			case 30: CreateVehicleEx(playerid, 589); // Club
			case 31: CreateVehicleEx(playerid, 437); // Coach
			case 32: CreateVehicleEx(playerid, 532); // Combine Harvester
			case 33: CreateVehicleEx(playerid, 480); // Comet
			case 34: CreateVehicleEx(playerid, 578); // DFT-30
			case 35: CreateVehicleEx(playerid, 486); // Dozer
			case 36: CreateVehicleEx(playerid, 406); // Dumper
			case 37: CreateVehicleEx(playerid, 573); // Dune(ride)
			case 38: CreateVehicleEx(playerid, 507); // Elegant
			case 39: CreateVehicleEx(playerid, 562); // Elegy
			case 40: CreateVehicleEx(playerid, 585); // Emperor
			case 41: CreateVehicleEx(playerid, 419); // Esperanto
			case 42: CreateVehicleEx(playerid, 587); // Euros
			case 43: _ShowDialog(playerid);
		}
		return 1;
	}

//==============================================================================
//                          		 Cars 2
//==============================================================================
	if(dialogid == (DIALOGID + 3) && response) // Cars 2
	{
		switch(listitem)
		{
			case 0: CreateVehicleEx(playerid, 490); // FBI Rancher
			case 1: CreateVehicleEx(playerid, 528); // FBI Truck
			case 2: CreateVehicleEx(playerid, 533); // Feltzer
			case 3: CreateVehicleEx(playerid, 544); // Firetruck 1
			case 4: CreateVehicleEx(playerid, 407); // Firetruck 2
			case 5: CreateVehicleEx(playerid, 565); // Flash
			case 6: CreateVehicleEx(playerid, 455); // Flatbed
			case 7: CreateVehicleEx(playerid, 530); // Forklift
			case 8: CreateVehicleEx(playerid, 526); // Fortune
			case 9: CreateVehicleEx(playerid, 466); // Glendale 1
			case 10: CreateVehicleEx(playerid, 604); // Glendale 2
			case 11: CreateVehicleEx(playerid, 492); // Greenwood
			case 12: CreateVehicleEx(playerid, 474); // Hermes
			case 13: CreateVehicleEx(playerid, 588); // Hotdog
			case 14: CreateVehicleEx(playerid, 434); // Hotknife
			case 15: CreateVehicleEx(playerid, 502); // Hotring Racer 1
			case 16: CreateVehicleEx(playerid, 503); // Hotring Racer 2
			case 17: CreateVehicleEx(playerid, 494); // Hotring Racer 3
			case 18: CreateVehicleEx(playerid, 579); // Huntley
			case 19: CreateVehicleEx(playerid, 545); // Hustler
			case 20: CreateVehicleEx(playerid, 411); // Infernus
			case 21: CreateVehicleEx(playerid, 546); // Intruder
			case 22: CreateVehicleEx(playerid, 559); // Jester
			case 23: CreateVehicleEx(playerid, 508); // Journey
			case 24: CreateVehicleEx(playerid, 571); // Kart
			case 25: CreateVehicleEx(playerid, 400); // Landstalker
			case 26: CreateVehicleEx(playerid, 403); // Linerunner
			case 27: CreateVehicleEx(playerid, 517); // Majestic
			case 28: CreateVehicleEx(playerid, 410); // Manana
			case 29: CreateVehicleEx(playerid, 551); // Merit
			case 30: CreateVehicleEx(playerid, 500); // Mesa
			case 31: CreateVehicleEx(playerid, 444); // Monster
			case 32: CreateVehicleEx(playerid, 556); // Monster A
			case 33: CreateVehicleEx(playerid, 557); // Monster B
			case 34: CreateVehicleEx(playerid, 418); // Moonbeam
			case 35: CreateVehicleEx(playerid, 572); // Mower
			case 36: CreateVehicleEx(playerid, 423); // Mr Whoopee
			case 37: CreateVehicleEx(playerid, 414); // Mule
			case 38: CreateVehicleEx(playerid, 516); // Nebula
			case 39: CreateVehicleEx(playerid, 582); // Newsvan
			case 40: CreateVehicleEx(playerid, 467); // Oceanic
			case 41: CreateVehicleEx(playerid, 443); // Packer
			case 42: _ShowDialog(playerid);

		}
		return 1;
	}

//==============================================================================
//                             			Cars 3
//==============================================================================
	if(dialogid == (DIALOGID + 4) && response) // Cars 3
	{
		switch(listitem)
		{
			case 0: CreateVehicleEx(playerid, 470); // Patriot
			case 1: CreateVehicleEx(playerid, 404); // Perenniel
			case 2: CreateVehicleEx(playerid, 514); // Petrol Tanker
			case 3: CreateVehicleEx(playerid, 603); // Phoenix
			case 4: CreateVehicleEx(playerid, 600); // Picador
			case 5: CreateVehicleEx(playerid, 596); // Police Car LSPD
			case 6: CreateVehicleEx(playerid, 597); // Police Car SFPD
			case 7: CreateVehicleEx(playerid, 598); // Police Car LVPD
			case 8: CreateVehicleEx(playerid, 599); // Police Ranger
			case 9: CreateVehicleEx(playerid, 427); // Police Truck (Enforcer)
			case 10: CreateVehicleEx(playerid, 601); // Police Truck (SWAT)
			case 11: CreateVehicleEx(playerid, 413); // Pony
			case 12: CreateVehicleEx(playerid, 426); // Premier
			case 13: CreateVehicleEx(playerid, 436); // Previon
			case 14: CreateVehicleEx(playerid, 547); // Primo
			case 15: CreateVehicleEx(playerid, 489); // Rancher
			case 16: CreateVehicleEx(playerid, 479); // Regina
			case 17: CreateVehicleEx(playerid, 534); // Remington
			case 18: CreateVehicleEx(playerid, 432); // Rhino
			case 19: CreateVehicleEx(playerid, 515); // Roadtrain
			case 20: CreateVehicleEx(playerid, 442); // Romero
			case 21: CreateVehicleEx(playerid, 440); // Rumpo
			case 22: CreateVehicleEx(playerid, 475); // Sabre
			case 23: CreateVehicleEx(playerid, 543); // Sadler 1
			case 24: CreateVehicleEx(playerid, 605); // Sadler 2
			case 25: CreateVehicleEx(playerid, 495); // Sandking
			case 26: CreateVehicleEx(playerid, 567); // Savanna
			case 27: CreateVehicleEx(playerid, 428); // Securicar
			case 28: CreateVehicleEx(playerid, 405); // Sentinel
			case 29: CreateVehicleEx(playerid, 535); // Slamvan
			case 30: CreateVehicleEx(playerid, 458); // Solair
			case 31: CreateVehicleEx(playerid, 580); // Stafford
			case 32: CreateVehicleEx(playerid, 439); // Stallion
			case 33: CreateVehicleEx(playerid, 561); // Stratum
			case 34: CreateVehicleEx(playerid, 409); // Stretch
			case 35: CreateVehicleEx(playerid, 560);// Sultan
			case 36: CreateVehicleEx(playerid, 550); // Sunrise
			case 37: _ShowDialog(playerid);
		}
		return 1;
	}

//==============================================================================
//                          		 Cars 4
//==============================================================================
	if(dialogid == (DIALOGID + 5) && response) // Cars 4
	{
		switch(listitem)
		{
			case 0: CreateVehicleEx(playerid, 506); // Super GT
			case 1: CreateVehicleEx(playerid, 574); // Sweeper
			case 2: CreateVehicleEx(playerid, 566); // Tahoma
			case 3: CreateVehicleEx(playerid, 549); // Tampa
			case 4: CreateVehicleEx(playerid, 420); // Taxi
			case 5: CreateVehicleEx(playerid, 576); // Tornado
			case 6: CreateVehicleEx(playerid, 525); // Towtruck
			case 7: CreateVehicleEx(playerid, 531); // Tractor
			case 8: CreateVehicleEx(playerid, 408); // Trashmaster
			case 9: CreateVehicleEx(playerid, 583); // Tug
			case 10: CreateVehicleEx(playerid, 451); // Turismo
			case 11: CreateVehicleEx(playerid, 558); // Uranus
			case 12: CreateVehicleEx(playerid, 552); // Utility Van
			case 13: CreateVehicleEx(playerid, 540); // Vincent
			case 14: CreateVehicleEx(playerid, 491); // Virgo
			case 15: CreateVehicleEx(playerid, 412); // Voodoo
			case 16: CreateVehicleEx(playerid, 478); // Walton
			case 17: CreateVehicleEx(playerid, 421); // Washington
			case 18: CreateVehicleEx(playerid, 529); // Williard
			case 19: CreateVehicleEx(playerid, 555); // Windsor
			case 20: CreateVehicleEx(playerid, 456); // Yankee
			case 21: CreateVehicleEx(playerid, 554); // Yosemite
			case 22: CreateVehicleEx(playerid, 477); // ZR-350
			case 23: _ShowDialog(playerid);
		}
		return 1;
	}
//==============================================================================
//                          		 Helicopters
//==============================================================================
	if(dialogid == (DIALOGID + 6) && response) // Helicopters
	{
		switch(listitem)
		{
			case 0: CreateVehicleEx(playerid, 548); // Cargobob
			case 1: CreateVehicleEx(playerid, 425); // Hunter
			case 2: CreateVehicleEx(playerid, 417); // Leviathan
			case 3: CreateVehicleEx(playerid, 487); // Maverick
			case 4: CreateVehicleEx(playerid, 497); // Police Maverick
			case 5: CreateVehicleEx(playerid, 488); // News Chopper
			case 6: CreateVehicleEx(playerid, 563); // Raindance
			case 7: CreateVehicleEx(playerid, 469); // Sparrow
			case 8: CreateVehicleEx(playerid, 447); // Sea Sparrow
			case 9:  _ShowDialog(playerid);
		}
		return 1;
	}
//==============================================================================
//                                  Planes
//==============================================================================
	if(dialogid == (DIALOGID + 7) && response) // Planes
	{
		switch(listitem)
		{
			case 0: CreateVehicleEx(playerid, 592); // Andromada
			case 1: CreateVehicleEx(playerid, 577); // At-400
			case 2: CreateVehicleEx(playerid, 511); // Beagle
			case 3: CreateVehicleEx(playerid, 512); // Cropduster
			case 4: CreateVehicleEx(playerid, 593); // Dodo
			case 5: CreateVehicleEx(playerid, 520); // Hydra
			case 6: CreateVehicleEx(playerid, 553); // Nevada
			case 7: CreateVehicleEx(playerid, 476); // Rustler
			case 8: CreateVehicleEx(playerid, 519); // Shamal
			case 9: CreateVehicleEx(playerid, 460); // Skimmer
			case 10: CreateVehicleEx(playerid, 513); // Stuntplane
			case 11: _ShowDialog(playerid);
		}
		return 1;
	}
//==============================================================================
//                                  Boats
//==============================================================================
	if(dialogid == (DIALOGID + 8) && response) // Boats
	{
		switch(listitem)
		{
			case 0: CreateVehicleEx(playerid, 472); // Coastguard
			case 1: CreateVehicleEx(playerid, 473); // Dinghy
			case 2: CreateVehicleEx(playerid, 493); // Jetmax
			case 3: CreateVehicleEx(playerid, 595); // Launch
			case 4: CreateVehicleEx(playerid, 484); // Marquis
			case 5: CreateVehicleEx(playerid, 430); // Predator
			case 6: CreateVehicleEx(playerid, 453); // Reefer
			case 7: CreateVehicleEx(playerid, 452); // Speeder
			case 8: CreateVehicleEx(playerid, 446); // Squallo
			case 9: CreateVehicleEx(playerid, 454); // Tropic
			case 10: _ShowDialog(playerid);
		}
		return 1;
	}
//==============================================================================
//                          		 Trains
//==============================================================================
	if(dialogid == (DIALOGID + 9) && response) // Trains
	{
		switch(listitem)
		{
			case 0: CreateVehicleEx(playerid, 537); // Brown Streak
			case 1: CreateVehicleEx(playerid, 590); // Freight Box Trailer
			case 2: CreateVehicleEx(playerid, 569); // Freight Flat Trailer
			case 3: CreateVehicleEx(playerid, 538); // Freight
			case 4: CreateVehicleEx(playerid, 570); // Streak Trailer
			case 5: CreateVehicleEx(playerid, 449); // Tram
			case 6: _ShowDialog(playerid);
		}
		return 1;
	}
//==============================================================================
//                          		 Trailers
//==============================================================================
	if(dialogid == (DIALOGID + 10) && response) // Trailers
	{
		switch(listitem)
		{
			case 0: CreateVehicleEx(playerid, 435); // Article Trailer 1
			case 1: CreateVehicleEx(playerid, 450); // Article Trailer 2
			case 2: CreateVehicleEx(playerid, 591); // Article Trailer 3
			case 3: CreateVehicleEx(playerid, 606); // Baggage Trailer (A)
			case 4: CreateVehicleEx(playerid, 607); // Baggage Trailer (B)
			case 5: CreateVehicleEx(playerid, 610); // Farm Trailer
			case 6: CreateVehicleEx(playerid, 584); // Petrol Trailer
			case 7: CreateVehicleEx(playerid, 608); // Tug Stairs Trailer
			case 8: CreateVehicleEx(playerid, 611); // Utility Trailer
			case 9: _ShowDialog(playerid);
		}
		return 1;
	}
//==============================================================================
//                          RC Vehicles + Vortex
//==============================================================================
	if(dialogid == (DIALOGID + 11) && response) // RC Vehicles + Vortex
	{
		switch(listitem)
		{
			case 0: CreateVehicleEx(playerid, 441); // RC Bandit
			case 1: CreateVehicleEx(playerid, 594); // RC Cam
			case 2: CreateVehicleEx(playerid, 564); // RC Tiger
			case 3: CreateVehicleEx(playerid, 464); // RC Baron
			case 4: CreateVehicleEx(playerid, 501); // RC Goblin
			case 5: CreateVehicleEx(playerid, 465); // RC Raider
			case 6: CreateVehicleEx(playerid, 539); // Vortex
			case 7: _ShowDialog(playerid);
		}
		return 1;
	}
	return 0;
}
//==============================================================================
stock IsVehicleOccupied(vehicleid)
{
  	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerInVehicle(i, vehicleid)) return 1;
	}
	return 0;
}
//==============================================================================
stock CreateVehicleEx(playerid, modelid)
{
	new pState = GetPlayerState(playerid);
	if(pState != PLAYER_STATE_DRIVER && pState != PLAYER_STATE_ONFOOT) return 0;
	#if ADMIN_ONLY_VEHICLES == true
	switch(modelid)
	{
	    case 464, 449, 570, 537, 538, 569, 590, 430, 220, 476, 577, 592, 447, 425, 432:
		{
			if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, 0xFFFFFFFF, "Only RCON admins may spawn this vehicle.");
		}
	}
	#endif
	new world = GetPlayerVirtualWorld(playerid), interior = GetPlayerInterior(playerid), Float:Pos[4], Float:Velocity[3], vehicleid = GetPlayerVehicleID(playerid);
	GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]), GetPlayerFacingAngle(playerid, Pos[3]);
	VehicleDestroy(playerid);
	if(vehicleid != 0)
	{
	    GetVehicleVelocity(vehicleid, Velocity[0], Velocity[1], Velocity[2]);
		DestroyVehicle(vehicleid);
	}
	cVeh[playerid] = CreateVehicle(modelid, Pos[0], Pos[1], Pos[2], Pos[3], -1, -1, -1);
 	LinkVehicleToInterior(cVeh[playerid], interior), SetVehicleVirtualWorld(cVeh[playerid], world), SetVehiclePos(cVeh[playerid], Pos[0], Pos[1], (Pos[2] + 1.5));
	SetVehicleZAngle(cVeh[playerid], Pos[3]), PutPlayerInVehicle(playerid, cVeh[playerid], 0), SetVehicleVelocity(cVeh[playerid], Velocity[0], Velocity[1], Velocity[2]);
	return 1;
}
//==============================================================================
