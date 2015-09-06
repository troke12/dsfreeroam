/*
.:[Vehicle Spawner V. 1.0]:. by x96664
Please don't remove my credits!
Use /v to open vehicle dialog.

*/
#include <a_samp>
#define dcmd(%1,%2,%3) if (!strcmp((%3)[1], #%1, true, (%2)) && ((((%3)[(%2) + 1] == '\0') && (dcmd_%1(playerid, ""))) || (((%3)[(%2) + 1] == ' ') && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
//Colors
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_RED 0xff0000a7
//RC vehicles
#define RC_BANDIT	441
#define RC_BARON	464
#define RC_GOBLIN	501
#define RC_RAIDER	465
#define D_TRAM		449
#define RC_TIGER	564
#define RC_CAM		594
//Dialogs                           I'm using bigger dialog ids to don't make conflict with your server dialogs.
#define Dialog_Unique_Vehicle 10000
#define Dialog_Trailers_Vehicle 10001
#define Dialog_Boats_Vehicle 10002
#define Dialog_Station_Vehicle 10003
#define Dialog_Sport_Vehicle 10004
#define Dialog_Saloon_Vehicle 10005
#define Dialog_Public_Service_Vehicle 10006
#define Dialog_Off-Road_Vehicle 10007
#define Dialog_LowRyder_Vehicle 10008
#define Dialog_Industry_Vehicle 10009
#define Dialog_Convertable_Vehicle 10010
#define Dialog_Bike_Vehicle 10011
#define Dialog_Helicopters 10012
#define Dialog_Airplanes 10013
#define Dialog_Rc_Vehicle 10014
#define Dialog_Vehicle 10015
//Forward
forward VehicleSpawner(playerid,model);
//new
new VehicleSpawn[MAX_PLAYERS];
//vehicles
new Airplanes[] = { 592, 577, 511, 512, 593, 520, 553, 476, 519, 460, 513 };
new Helicopters[] = { 548, 425, 417, 487, 488, 497, 563, 447, 469 };
new Bikes[] = { 581, 509, 481, 462, 521, 463, 510, 522, 461, 448, 471, 468, 586 };
new Industrials[] = { 499, 422, 482, 498, 609, 524, 578, 455, 403, 414, 582, 443, 514, 413, 515, 440, 543, 605, 459, 531, 408, 552, 478, 456, 554 };
new Lowriders[] = { 536, 575, 534, 567, 535, 566, 576, 412 };
new Offroad[] = { 568, 424, 573, 579, 400, 500, 444, 556, 557, 470, 489, 505, 495 };
new Pulic_Services[] = { 416, 433, 431, 438, 437, 523, 427, 490, 528, 407, 544, 596, 598, 597, 599, 432, 601, 420 };
new Saloons[] = { 445, 504, 401, 518, 527, 542, 507, 562, 585, 419, 526, 604, 466, 492, 474, 546, 517, 410, 551, 516, 467, 600, 426, 436, 547, 405, 580, 560, 550, 549, 540, 491, 529, 421 };
new Sport[] = { 602, 429, 496, 402, 541, 415, 589, 587, 565, 494, 502, 503, 411, 559, 603, 475, 506, 451, 558, 477 };
new Station[] = { 418, 404, 479, 458, 561 };
new Boats[] = { 472, 473, 493, 595, 484, 430, 453, 452, 446, 454 };
new Trailers[] = { 435, 450, 591, 606, 607, 610, 569, 590, 584, 570, 608, 611 };
new Unique[] = { 485, 537, 457, 483, 508, 532, 486, 406, 530, 538, 434, 545, 588, 571, 572, 423, 442, 428, 409, 574, 449, 525, 583, 539 };
new RC_Vehicles[] = { 441, 464, 465, 501, 564, 594 };

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print("|Vehicle spawner by x96664 loaded!  |");
	print("--------------------------------------\n");
	SetTimer("VehicleSpawnLimiter", 1000, true);
	return 1;
}

public OnFilterScriptExit()
{	print("\n--------------------------------------");
	print("|Vehicle spawner by x96664 unloaded!  |");
	print("--------------------------------------\n");
	return 1;
}
public OnPlayerSpawn(playerid)
{
  SendClientMessage(playerid, COLOR_WHITE, "You can spawn a vehicle using /v.");
}
public OnPlayerCommandText(playerid, cmdtext[])
{
dcmd(v, 1,cmdtext);
return 0;
}
dcmd_v(playerid, params[])
{
#pragma unused params
ShowVehicleDialog(playerid);
return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{

    if(newkeys == KEY_SECONDARY_ATTACK ){
        if(!IsPlayerInAnyVehicle(playerid)){
            new Float:x, Float:y, Float:z, vehicle; 
            GetPlayerPos(playerid, x, y, z );
            GetVehicleWithinDistance(playerid, x, y, z, 20.0, vehicle);

            if(IsVehicleRc(vehicle)){
              PutPlayerInVehicle(playerid, vehicle, 0);
            }
        }

        else {
            new vehicleID = GetPlayerVehicleID(playerid);
            if(IsVehicleRc(vehicleID) || GetVehicleModel(vehicleID) == RC_CAM){
              if(GetVehicleModel(vehicleID) != D_TRAM){
                new Float:x, Float:y, Float:z;
                GetPlayerPos(playerid, x, y, z);
                SetPlayerPos(playerid, x+0.5, y, z+1.0);
                }
            }
        }
    }
}
GetVehicleWithinDistance( playerid, Float:x1, Float:y1, Float:z1, Float:dist, &veh){
    for(new i = 1; i < MAX_VEHICLES; i++){
        if(GetVehicleModel(i) > 0){
            if(GetPlayerVehicleID(playerid) != i ){
            new Float:x, Float:y, Float:z;
            new Float:x2, Float:y2, Float:z2;
            GetVehiclePos(i, x, y, z);
            x2 = x1 - x; y2 = y1 - y; z2 = z1 - z;
            new Float:vDist = (x2*x2+y2*y2+z2*z2);
            if( vDist < dist){
            veh = i;
            dist = vDist;
                }
            }
        }
    }
}
IsVehicleRc( vehicleid ){
  new model = GetVehicleModel(vehicleid);
  switch(model){
  case RC_GOBLIN, RC_BARON, RC_BANDIT, RC_RAIDER, RC_TIGER: return 1;
  default: return 0;
    }

  return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
if(dialogid== Dialog_Vehicle)
{
if ( response==1 )
{
if(listitem==0)ShowPlayerDialog( playerid, Dialog_Airplanes, 2, "{ffffff}Airplanes:", "Andromada\nAT-400\nBeagle\nCropduster\nDodo\nHydra\nNevada\nRustler\nShamal\nSkimmer\nStuntplane", "Select", "Back" );
if(listitem==1)ShowPlayerDialog( playerid, Dialog_Helicopters, 2, "{ffffff}Helicopters:", "Cargobob\nHunter\nLeviathan\nMaverick\nNews Maverick\nPolice Maverick\nRaindance\nSeasparrow\nSparrow", "Select", "Back" );
if(listitem==2)ShowPlayerDialog( playerid, Dialog_Bike_Vehicle, 2, "{ffffff}Bikes:", "BF-400\nBike\nBMX\nFaggio\nFCR-900\nFreeway\nMountain Bike\nNRG-500\nPCJ-600\nPizzaboy\nQuad\nSanchez\nWayfarer", "Select", "Back" );
if(listitem==3)ShowPlayerDialog( playerid, Dialog_Convertable_Vehicle, 2, "{ffffff}Convertibles:", "Comet\nFeltzer\nStallion\nWindsor", "Select", "Back" );
if(listitem==4)ShowPlayerDialog( playerid, Dialog_Industry_Vehicle, 2, "{ffffff}Industrial:", "Benson\nBobcat\nBurrito\nBoxville\nBoxburg\nCement Truck\nDFT-30\nFlatbed\nLinerunner\nMule\nNewsvan\nPacker\nPetrol Tanker\nPony\nRoadtrain\nRumpo\nSadler\nSadler Shit\nTopfun\nTractor\nTrashmaster\nUtility Van\nWalton\nYankee\nYosemite", "Select", "Back" );
if(listitem==5)ShowPlayerDialog( playerid, Dialog_LowRyder_Vehicle, 2, "{ffffff}Lowriders:", "Blade\nBroadway\nRemington\nSavanna\nSlamvan\nTahoma\nTornado\nVoodoo", "Select", "Back" );
if(listitem==6)ShowPlayerDialog( playerid, Dialog_Off-Road_Vehicle, 2, "{ffffff}Off Road:", "Bandito\nBF Injection\nDune\nHuntley\nLandstalker\nMesa\nMonster\nMonster A\nMonster B\nPatriot\nRancher A\nRancher B\nSandking", "Select", "Back" );
if(listitem==7)ShowPlayerDialog( playerid, Dialog_Public_Service_Vehicle, 2, "{ffffff}Public Service Vehicles:", "Ambulance\nBarracks\nBus\nCabbie\nCoach\nCop Bike (HPV-1000)\nEnforcer\nFBI Rancher\nFBI Truck\nFiretruck\nFiretruck LA\nPolice Car (LSPD)\nPolice Car (LVPD)\nPolice Car (SFPD)\nRanger\nRhino\nS.W.A.T\nTaxi", "Select", "Back" );
if(listitem==8)ShowPlayerDialog( playerid, Dialog_Saloon_Vehicle, 2, "{ffffff}Saloons:", "Admiral\nBlooDialog_Weapon_Riflesng Banger\nBravura\nBuccaneer\nCadrona\nClover\nElegant\nElegy\nEmperor\nEsperanto\nFortune\nGlendale Shit\nGlendale\nGreenwood\nHermes\nIntruder\nMajestic\nManana\nMerit\nNebula\nOceanic\nPicador\nPremier\nPrevion\nPrimo\nSentinel\nStafford\nSultan\nSunrise\nTampa\nVincent\nVirgo\nWillard\nWashington", "Select", "Back" );
if(listitem==9)ShowPlayerDialog( playerid, Dialog_Sport_Vehicle, 2, "{ffffff}Sport Vehicles:", "Alpha\nBanshee\nBlista Compact\nBuffalo\nBullet\nCheetah\nClub\nEuros\nFlash\nHotring Racer\nHotring Racer A\nHotring Racer B\nInfernus\nJester\nPhoenix\nSabre\nSuper GT\nTurismo\nUranus\nZR-350", "Select", "Back" );
if(listitem==10)ShowPlayerDialog( playerid, Dialog_Station_Vehicle, 2, "{ffffff}Station Wagons:", "Moonbeam\nPerenniel\nRegina\nSolair\nStratum", "Select", "Back" );
if(listitem==11)ShowPlayerDialog( playerid, Dialog_Boats_Vehicle, 2, "{ffffff}Boats:", "Coastguard\nDinghy\nJetmax\nLaunch\nMarquis\nPredator\nReefer\nSpeeder\nSquallo\nTropic", "Select", "Back" );
if(listitem==12)ShowPlayerDialog( playerid, Dialog_Trailers_Vehicle, 2, "{ffffff}Trailers:", "Article Trailer\nArticle Trailer 2\nArticle Trailer 3\nBaggage Trailer A\nBaggage Trailer B\nFarm Trailer\nFreight Flat Trailer (Train)\nFreight Box Trailer (Train)\nPetrol Trailer\nStreak Trailer (Train)\nStairs Trailer\nUtility Trailer", "Select", "Back" );
if(listitem==13)ShowPlayerDialog( playerid, Dialog_Unique_Vehicle, 2, "{ffffff}Unique Vehicles:", "Baggage\nBrownstreak (Train)\nCaddy\nCamper\nCamper A\nCombine Harvester\nDozer\nDumper\nForklift\nFreight (Train)\nHotknife\nHustler\nHotdog\nKart\nMower\nMr Whoopee\nRomero\nSecuricar\nStretch\nSweeper\nTram\nTowtruck\nTug\nVortex", "Select", "Back" );
if(listitem==14)ShowPlayerDialog( playerid, Dialog_Rc_Vehicle, 2, "{ffffff}RC Vehicles:", "RC Bandit\nRC Baron\nRC Raider\nRC Goblin\nRC Tiger\nRC Cam", "Select", "Back" );
}
}
if(dialogid== Dialog_Airplanes){if ( response ){
VehicleSpawner(playerid,Airplanes[ listitem ]);}}
if(dialogid== Dialog_Helicopters){
if ( response ){
VehicleSpawner(playerid,Helicopters[ listitem ]);
}else ShowVehicleDialog(playerid);
}
if(dialogid== Dialog_Bike_Vehicle){
if ( response ){
VehicleSpawner(playerid,Bikes[ listitem ]);
}else ShowVehicleDialog(playerid);
}
if(dialogid== Dialog_Convertable_Vehicle){
if ( response ){
new Convertibles[] = { 480, 533, 439, 555 };
VehicleSpawner(playerid,Convertibles[ listitem ]);
}else ShowVehicleDialog(playerid);
}
if(dialogid== Dialog_Industry_Vehicle){
if ( response ){
VehicleSpawner(playerid,Industrials[ listitem ]);
}else ShowVehicleDialog(playerid);
}
if(dialogid== Dialog_LowRyder_Vehicle){
if ( response ){
VehicleSpawner(playerid,Lowriders[ listitem ]);
}else ShowVehicleDialog(playerid);
}
if(dialogid== Dialog_Off-Road_Vehicle){
if ( response ){
VehicleSpawner(playerid,Offroad[ listitem ]);
}else ShowVehicleDialog(playerid);
}
if(dialogid== Dialog_Public_Service_Vehicle){
if ( response ){
VehicleSpawner(playerid,Pulic_Services[ listitem ]);
}else ShowVehicleDialog(playerid);
}
if(dialogid== Dialog_Saloon_Vehicle){
if ( response ){
VehicleSpawner(playerid,Saloons[ listitem ]);
}else ShowVehicleDialog(playerid);
}
if(dialogid== Dialog_Sport_Vehicle){
if ( response ){
VehicleSpawner(playerid,Sport[ listitem ]);
}else ShowVehicleDialog(playerid);
}
if(dialogid== Dialog_Station_Vehicle){
if ( response ){
VehicleSpawner(playerid,Station[ listitem ]);
}else ShowVehicleDialog(playerid);
}
if(dialogid== Dialog_Boats_Vehicle){
if ( response ){
VehicleSpawner(playerid,Boats[ listitem ]);
}else ShowVehicleDialog(playerid);
}
if(dialogid== Dialog_Trailers_Vehicle){
if ( response ){
VehicleSpawner(playerid,Trailers[ listitem ]);
}else ShowVehicleDialog(playerid);
}
if(dialogid== Dialog_Unique_Vehicle){
if ( response ){
VehicleSpawner(playerid,Unique[ listitem ]);
}else ShowVehicleDialog(playerid);
}
if(dialogid== Dialog_Rc_Vehicle){
if ( response ){
VehicleSpawner(playerid,RC_Vehicles[ listitem ]);
}else ShowVehicleDialog(playerid);
}
return 1;
}

stock ShowVehicleDialog(playerid)
{
ShowPlayerDialog(playerid, Dialog_Vehicle, 2, "{ffffff}Vehicle categories:", "Airplanes\nHelicopters\nBikes\nConvertibles\nIndustrial\nLowriders\nOff Road\nPublic Service Vehicles\nSaloons\nSport Vehicles\nStation Wagons\nBoats\nTrailers\nUnique Vehicles\nRC Vehicles", "Select", "Back" );
}

public VehicleSpawner(playerid,model){
	if(IsPlayerInAnyVehicle(playerid)){
		SendClientMessage(playerid, COLOR_RED, "Error: You're already in vehicle!");
 	}
 	else{
	if(VehicleSpawn[playerid]==0){
	new Float:x,Float:y,Float:z,Float:a, vehicleid;
    GetPlayerPos(playerid,x,y,z);
    GetPlayerFacingAngle(playerid,a);
    vehicleid = CreateVehicle(model,x+1,y+1,z,a,-1,-1,-1);
    PutPlayerInVehicle(playerid, vehicleid, 0);
    SetVehicleHealth(vehicleid,  1000.0);
    LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
    }
  }
}
