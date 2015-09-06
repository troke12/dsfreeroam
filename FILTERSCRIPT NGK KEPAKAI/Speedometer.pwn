#include <a_samp>
/*Please leave credits if using!*/
forward CheckSpeed();
new Text:KMH[MAX_PLAYERS];
new Text:Name[MAX_PLAYERS];
new Text:CarH[MAX_PLAYERS];
new Text:Type[MAX_PLAYERS];
new Text:Out1[MAX_PLAYERS],Text:Out2[MAX_PLAYERS],Text:Out3[MAX_PLAYERS];
new Text:Out4[MAX_PLAYERS],Text:Out5[MAX_PLAYERS],Text:Out6[MAX_PLAYERS];
new Text:Out7[MAX_PLAYERS],Text:Out8[MAX_PLAYERS],Text:Out9[MAX_PLAYERS];
new CarsName[][] = {
   "Landstalker",
   "Bravura",
   "Buffalo",
   "Linerunner",
   "Pereniel",
   "Sentinel",
   "Dumper",
   "Firetruck",
   "Trashmaster",
   "Stretch",
   "Manana",
   "Infernus",
   "Voodoo",
   "Pony",
   "Mule",
   "Cheetah",
   "Ambulance",
   "Leviathan",
   "Moonbeam",
   "Esperanto",
   "Taxi",
   "Washington",
   "Bobcat",
   "Mr Whoopee",
   "BF Injection",
   "Hunter",
   "Premier",
   "Enforcer",
   "Securicar",
   "Banshee",
   "Predator",
   "Bus",
   "Rhino",
   "Barracks",
   "Hotknife",
   "Trailer",
   "Previon",
   "Coach",
   "Cabbie",
   "Stallion",
   "Rumpo",
   "RC Bandit",
   "Romero",
   "Packer",
   "Monster",
   "Admiral",
   "Squalo",
   "Seasparrow",
   "Pizzaboy",
   "Tram",
   "Trailer",
   "Turismo",
   "Speeder",
   "Reefer",
   "Tropic",
   "Flatbed",
   "Yankee",
   "Caddy",
   "Solair",
   "RC Van",
   "Skimmer",
   "PCJ-600",
   "Faggio",
   "Freeway",
   "RC Baron",
   "RC Raider",
   "Glendale",
   "Oceanic",
   "Sanchez",
   "Sparrow",
   "Patriot",
   "Quad",
   "Coastguard",
   "Dinghy",
   "Hermes",
   "Sabre",
   "Rustler",
   "ZR-350",
   "Walton",
   "Regina",
   "Comet",
   "BMX",
   "Burrito",
   "Camper",
   "Marquis",
   "Baggage",
   "Dozer",
   "Maverick",
   "News Chopper",
   "Rancher",
   "FBI Rancher",
   "Virgo",
   "Greenwood",
   "Jetmax",
   "Hotring",
   "Sandking",
   "Blista Compact",
   "PD Maverick",
   "Boxville",
   "Benson",
   "Mesa",
   "RC Goblin",
   "Hotring",
   "Hotring",
   "Bloodring",
   "Rancher",
   "Super GT",
   "Elegant",
   "Journey",
   "Bike",
   "Mountain Bike",
   "Beagle",
   "Cropdust",
   "Stunt",
   "Tanker",
   "RoadTrain",
   "Nebula",
   "Majestic",
   "Buccaneer",
   "Shamal",
   "Hydra",
   "FCR-900",
   "NRG-500",
   "HPV1000",
   "Cement",
   "Tow Truck",
   "Fortune",
   "Cadrona",
   "FBI Truck",
   "Willard",
   "Forklift",
   "Tractor",
   "Combine",
   "Feltzer",
   "Remington",
   "Slamvan",
   "Blade",
   "Freight",
   "Streak",
   "Vortex",
   "Vincent",
   "Bullet",
   "Clover",
   "Sadler",
   "Firetruck",
   "Hustler",
   "Intruder",
   "Primo",
   "Cargobob",
   "Tampa",
   "Sunrise",
   "Merit",
   "Utility",
   "Nevada",
   "Yosemite",
   "Windsor",
   "Monster",
   "Monster",
   "Uranus",
   "Jester",
   "Sultan",
   "Stratum",
   "Elegy",
   "Raindance",
   "RC Tiger",
   "Flash",
   "Tahoma",
   "Savanna",
   "Bandito",
   "Freight",
   "Trailer",
   "Kart",
   "Mower",
   "Duneride",
   "Sweeper",
   "Broadway",
   "Tornado",
   "AT-400",
   "DFT-30",
   "Huntley",
   "Stafford",
   "BF-400",
   "Newsvan",
   "Tug",
   "Trailer",
   "Emperor",
   "Wayfarer",
   "Euros",
   "Hotdog",
   "Club",
   "Trailer",
   "Trailer",
   "Andromada",
   "Dodo",
   "RC Cam",
   "Launch",
   "Police Car",
   "Police Car",
   "Police Car",
   "Police Ranger",
   "Picador",
   "S.W.A.T",
   "Alpha",
   "Phoenix",
   "Glendale",
   "Sadler",
   "Luggage Trailer",
   "Luggage Trailer",
   "Stair Trailer",
   "Boxville",
   "Farm Plow",
   "Utility Trailer"
};
public OnFilterScriptInit()
{
    print("***********************************");
	print("*     SA-MP Speedometer by Pro    *");
	print("*        FILTERSCRIPT:LOADED      *");
	print("***********************************");
	SetTimer("CheckSpeed",150,1);
	for(new playerid = 0; playerid < MAX_PLAYERS; playerid++)
 	{
  	KMH[playerid] = TextDrawCreate(501.000000, 414.000000, "KM/H:");
	TextDrawBackgroundColor(KMH[playerid], 255);
	TextDrawFont(KMH[playerid], 1);
	TextDrawLetterSize(KMH[playerid], 0.400000, 1.0000000);
	TextDrawColor(KMH[playerid], -1);
	TextDrawSetOutline(KMH[playerid], 1);
	TextDrawSetProportional(KMH[playerid], 1);
	TextDrawUseBox(KMH[playerid], 1);
	TextDrawBoxColor(KMH[playerid], -2139062187);
	TextDrawTextSize(KMH[playerid], 636.000000, 0.000000);

	Type[playerid] = TextDrawCreate(501.000000, 431.000000, "Type:");
	TextDrawBackgroundColor(Type[playerid], 255);
	TextDrawFont(Type[playerid], 1);
	TextDrawLetterSize(Type[playerid], 0.400000, 1.000000);
	TextDrawColor(Type[playerid], -1);
	TextDrawSetOutline(Type[playerid], 1);
	TextDrawSetProportional(Type[playerid], 1);
	TextDrawUseBox(Type[playerid], 1);
	TextDrawBoxColor(Type[playerid], -2139062187);
	TextDrawTextSize(Type[playerid], 636.000000, 0.000000);

	CarH[playerid] = TextDrawCreate(501.000000, 398.000000, "Health:");
	TextDrawBackgroundColor(CarH[playerid], 255);
	TextDrawFont(CarH[playerid], 1);
	TextDrawLetterSize(CarH[playerid], 0.400000, 1.0000000);
	TextDrawColor(CarH[playerid], -1);
	TextDrawSetOutline(CarH[playerid], 1);
	TextDrawSetProportional(CarH[playerid], 1);
	TextDrawUseBox(CarH[playerid], 1);
	TextDrawBoxColor(CarH[playerid], -2139062187);
	TextDrawTextSize(CarH[playerid], 636.000000, 0.000000);

	Name[playerid] = TextDrawCreate(501.000000, 382.000000, "Name:");
	TextDrawBackgroundColor(Name[playerid], 255);
	TextDrawFont(Name[playerid], 1);
	TextDrawLetterSize(Name[playerid], 0.400000, 1.000000);
	TextDrawColor(Name[playerid], -1);
	TextDrawSetOutline(Name[playerid], 1);
	TextDrawSetProportional(Name[playerid], 1);
	TextDrawUseBox(Name[playerid], 1);
	TextDrawBoxColor(Name[playerid], -2139062187);
	TextDrawTextSize(Name[playerid], 636.000000, 0.000000);

	Out1[playerid] = TextDrawCreate(501.000000, 434.000000, "_");
	TextDrawBackgroundColor(Out1[playerid], 255);
	TextDrawFont(Out1[playerid], 1);
	TextDrawLetterSize(Out1[playerid], 0.500000, 1.000000);
	TextDrawColor(Out1[playerid], -1);
	TextDrawSetOutline(Out1[playerid], 0);
	TextDrawSetProportional(Out1[playerid], 1);
	TextDrawSetShadow(Out1[playerid], 1);
	TextDrawUseBox(Out1[playerid], 1);
	TextDrawBoxColor(Out1[playerid], 255);
	TextDrawTextSize(Out1[playerid], 489.000000, 0.000000);

	Out2[playerid] = TextDrawCreate(501.000000, 419.000000, "_");
	TextDrawBackgroundColor(Out2[playerid], 255);
	TextDrawFont(Out2[playerid], 1);
	TextDrawLetterSize(Out2[playerid], 0.500000, 1.000000);
	TextDrawColor(Out2[playerid], -1);
	TextDrawSetOutline(Out2[playerid], 0);
	TextDrawSetProportional(Out2[playerid], 1);
	TextDrawSetShadow(Out2[playerid], 1);
	TextDrawUseBox(Out2[playerid], 1);
	TextDrawBoxColor(Out2[playerid], 255);
	TextDrawTextSize(Out2[playerid], 489.000000, 0.000000);

	Out3[playerid] = TextDrawCreate(501.000000, 402.000000, "_");
	TextDrawBackgroundColor(Out3[playerid], 255);
	TextDrawFont(Out3[playerid], 1);
	TextDrawLetterSize(Out3[playerid], 0.500000, 1.000000);
	TextDrawColor(Out3[playerid], -1);
	TextDrawSetOutline(Out3[playerid], 0);
	TextDrawSetProportional(Out3[playerid], 1);
	TextDrawSetShadow(Out3[playerid], 1);
	TextDrawUseBox(Out3[playerid], 1);
	TextDrawBoxColor(Out3[playerid], 255);
	TextDrawTextSize(Out3[playerid], 489.000000, 0.000000);

	Out4[playerid] = TextDrawCreate(501.000000, 386.000000, "_");
	TextDrawBackgroundColor(Out4[playerid], 255);
	TextDrawFont(Out4[playerid], 1);
	TextDrawLetterSize(Out4[playerid], 0.500000, 1.000000);
	TextDrawColor(Out4[playerid], -1);
	TextDrawSetOutline(Out4[playerid], 0);
	TextDrawSetProportional(Out4[playerid], 1);
	TextDrawSetShadow(Out4[playerid], 1);
	TextDrawUseBox(Out4[playerid], 1);
	TextDrawBoxColor(Out4[playerid], 255);
	TextDrawTextSize(Out4[playerid], 489.000000, 0.000000);

	Out5[playerid] = TextDrawCreate(501.000000, 386.000000, "_");
	TextDrawBackgroundColor(Out5[playerid], 255);
	TextDrawFont(Out5[playerid], 1);
	TextDrawLetterSize(Out5[playerid], 0.500000, 1.000000);
	TextDrawColor(Out5[playerid], -1);
	TextDrawSetOutline(Out5[playerid], 0);
	TextDrawSetProportional(Out5[playerid], 1);
	TextDrawSetShadow(Out5[playerid], 1);
	TextDrawUseBox(Out5[playerid], 1);
	TextDrawBoxColor(Out5[playerid], 255);
	TextDrawTextSize(Out5[playerid], 489.000000, 0.000000);

	Out6[playerid] = TextDrawCreate(501.000000, 382.000000, "_");
	TextDrawBackgroundColor(Out6[playerid], 255);
	TextDrawFont(Out6[playerid], 1);
	TextDrawLetterSize(Out6[playerid], 0.500000, 1.000000);
	TextDrawColor(Out6[playerid], -1);
	TextDrawSetOutline(Out6[playerid], 0);
	TextDrawSetProportional(Out6[playerid], 1);
	TextDrawSetShadow(Out6[playerid], 1);
	TextDrawUseBox(Out6[playerid], 1);
	TextDrawBoxColor(Out6[playerid], 255);
	TextDrawTextSize(Out6[playerid], 489.000000, 0.000000);

	Out7[playerid] = TextDrawCreate(653.000000, 377.000000, "_");
	TextDrawBackgroundColor(Out7[playerid], 255);
	TextDrawFont(Out7[playerid], 1);
	TextDrawLetterSize(Out7[playerid], 0.500000, -0.199999);
	TextDrawColor(Out7[playerid], -1);
	TextDrawSetOutline(Out7[playerid], 0);
	TextDrawSetProportional(Out7[playerid], 1);
	TextDrawSetShadow(Out7[playerid], 1);
	TextDrawUseBox(Out7[playerid], 1);
	TextDrawBoxColor(Out7[playerid], 255);
	TextDrawTextSize(Out7[playerid], 489.000000, 0.000000);

	Out8[playerid] = TextDrawCreate(653.000000, 447.000000, "_");
	TextDrawBackgroundColor(Out8[playerid], 255);
	TextDrawFont(Out8[playerid], 1);
	TextDrawLetterSize(Out8[playerid], 0.500000, -0.199999);
	TextDrawColor(Out8[playerid], -1);
	TextDrawSetOutline(Out8[playerid], 0);
	TextDrawSetProportional(Out8[playerid], 1);
	TextDrawSetShadow(Out8[playerid], 1);
	TextDrawUseBox(Out8[playerid], 1);
	TextDrawBoxColor(Out8[playerid], 255);
	TextDrawTextSize(Out8[playerid], 489.000000, 0.000000);

	Out9[playerid] = TextDrawCreate(644.000000, 447.000000, "_");
	TextDrawBackgroundColor(Out9[playerid], 255);
	TextDrawFont(Out9[playerid], 1);
	TextDrawLetterSize(Out9[playerid], 0.500000, -7.999998);
	TextDrawColor(Out9[playerid], -1);
	TextDrawSetOutline(Out9[playerid], 0);
	TextDrawSetProportional(Out9[playerid], 1);
	TextDrawSetShadow(Out9[playerid], 1);
	TextDrawUseBox(Out9[playerid], 1);
	TextDrawBoxColor(Out9[playerid], 255);
	TextDrawTextSize(Out9[playerid], 632.000000, 1.000000);
	}
	return 1;
}
public OnFilterScriptExit()
{
    for(new i = 0;i < MAX_PLAYERS; i++)
    {
   		TextDrawHideForPlayer(i,Name[i]);
		TextDrawHideForPlayer(i,KMH[i]);
		TextDrawHideForPlayer(i,Type[i]);
		TextDrawHideForPlayer(i,CarH[i]);
    	TextDrawHideForPlayer(i,Out1[i]);
    	TextDrawHideForPlayer(i,Out2[i]);
    	TextDrawHideForPlayer(i,Out3[i]);
    	TextDrawHideForPlayer(i,Out4[i]);
    	TextDrawHideForPlayer(i,Out5[i]);
    	TextDrawHideForPlayer(i,Out6[i]);
    	TextDrawHideForPlayer(i,Out7[i]);
    	TextDrawHideForPlayer(i,Out8[i]);
    	TextDrawHideForPlayer(i,Out9[i]);
    }
	return 1;
}

public CheckSpeed()
{
	for(new i=0;i<MAX_PLAYERS;i++)
	{
	    if (IsPlayerInAnyVehicle(i) && IsPlayerConnected(i))
	    {
	        new Float:h,str[167],str3[167],str4[167],v,sp;
	        v = GetPlayerVehicleID(i);
	        GetVehicleHealth(v,h);
			sp = GetPlayerSpeed(i);
			format(str,sizeof(str),"KM/H: %d",sp);
			if(IsInAnyBike(v))
			{
				TextDrawSetString(Type[i],"Type: Bike");
			}
			else if(IsInAirplane(v))
			{
			    TextDrawSetString(Type[i],"Type: Airplane");
			}
			else if(IsInHeli(v))
			{
			    TextDrawSetString(Type[i],"Type: Helicopter");
			}
			else if(IsInBoat(v))
			{
			    TextDrawSetString(Type[i],"Type: Boat");
			}
			else
			{
				TextDrawSetString(Type[i],"Type: Car");
			}
			format(str3,sizeof(str3),"Health: %.0f",h);
			format(str4,167,"Name: %s",CarsName[GetVehicleModel(v)-400]);
			TextDrawSetString(KMH[i],str);
			TextDrawSetString(CarH[i],str3);
			TextDrawSetString(Name[i],str4);
		}
	}
	return 1;
}
public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if (newstate == PLAYER_STATE_DRIVER)
	{

		TextDrawShowForPlayer(playerid,KMH[playerid]);
		TextDrawShowForPlayer(playerid,Name[playerid]);
		TextDrawShowForPlayer(playerid,Type[playerid]);
		TextDrawShowForPlayer(playerid,CarH[playerid]);
		TextDrawShowForPlayer(playerid,Out1[playerid]);
		TextDrawShowForPlayer(playerid,Out2[playerid]);
		TextDrawShowForPlayer(playerid,Out3[playerid]);
		TextDrawShowForPlayer(playerid,Out4[playerid]);
		TextDrawShowForPlayer(playerid,Out5[playerid]);
		TextDrawShowForPlayer(playerid,Out6[playerid]);
		TextDrawShowForPlayer(playerid,Out7[playerid]);
		TextDrawShowForPlayer(playerid,Out8[playerid]);
		TextDrawShowForPlayer(playerid,Out9[playerid]);
	}
	else if (newstate == PLAYER_STATE_ONFOOT)
	{
		TextDrawHideForPlayer(playerid,KMH[playerid]);
		TextDrawHideForPlayer(playerid,Name[playerid]);
		TextDrawHideForPlayer(playerid,Type[playerid]);
		TextDrawHideForPlayer(playerid,CarH[playerid]);
		TextDrawHideForPlayer(playerid,Out1[playerid]);
		TextDrawHideForPlayer(playerid,Out2[playerid]);
		TextDrawHideForPlayer(playerid,Out3[playerid]);
		TextDrawHideForPlayer(playerid,Out4[playerid]);
		TextDrawHideForPlayer(playerid,Out5[playerid]);
		TextDrawHideForPlayer(playerid,Out6[playerid]);
		TextDrawHideForPlayer(playerid,Out7[playerid]);
		TextDrawHideForPlayer(playerid,Out8[playerid]);
		TextDrawHideForPlayer(playerid,Out9[playerid]);
	}
	return 1;
}
stock GetPlayerSpeed(playerid)
{
    new Float:ST[4];
    if(IsPlayerInAnyVehicle(playerid))
	GetVehicleVelocity(GetPlayerVehicleID(playerid),ST[0],ST[1],ST[2]);
	else GetPlayerVelocity(playerid,ST[0],ST[1],ST[2]);
    ST[3] = floatsqroot(floatpower(floatabs(ST[0]), 2.0) + floatpower(floatabs(ST[1]), 2.0) + floatpower(floatabs(ST[2]), 2.0)) * 100.3;
    return floatround(ST[3]);
}
stock IsInAnyBike(bikeid)
{
    new Bikes[] = { 509,510,481,581, 462, 521, 463, 522, 461, 448, 471, 468, 586 };
    for(new i = 0; i < sizeof(Bikes); i++)
    {
        if(GetVehicleModel(bikeid) == Bikes[i]) return 1;
    }
    return 0;
}
stock IsInAirplane(airplaneid)
{
    new Airplanes[] = { 460,476,511,512,513,519,520,553,577,563,592,593 };
    for(new i = 0; i < sizeof(Airplanes); i++)
    {
        if(GetVehicleModel(airplaneid) == Airplanes[i]) return 1;
    }
    return 0;
}
stock IsInHeli(heliid)
{
	new Helis[] = { 417,425,447,469,487,488,497,548,563 };
	for(new i = 0; i < sizeof(Helis); i++)
	{
	    if(GetVehicleModel(heliid) == Helis[i]) return 1;
	}
	return 0;
}
stock IsInBoat(boatid)
{
    new Boats[] = { 472, 473, 493, 495, 484, 430, 454, 453, 452, 446 };
    for(new i = 0; i < sizeof(Boats); i++)
    {
	if(GetVehicleModel(boatid) == Boats[i]) return 1;
    }
    return 0;
}
