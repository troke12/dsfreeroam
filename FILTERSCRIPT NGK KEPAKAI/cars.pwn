/*
				Emmet's awesome dealership script!
				Made by Emmet_ on August 2, 2012

	Version: v1.1

	This Source Code Form is subject to the terms of the Mozilla Public
 	License, v. 2.0. If a copy of the MPL was not distributed with this
 	file, You can obtain one at http://mozilla.org/MPL/2.0/.
*/

#include <a_samp>
#include <foreach>
#include <zcmd>

#define FILTERSCRIPT

#define WHITE             0xFFFFFFFF
#define PURPLE            0xC2A2DAFF
#define BLUE              0x0000FFFF
#define RED               0xFF0000FF
#define YELLOW            0xFFFF00FF
#define GREEN             0x33AA33FF
#define LIGHTBLUE         0x33CCFFFF
#define LIGHTRED          0xFF6347FF
#define DARKRED           0xAA3333FF
#define GREY              0xAFAFAFFF
#define ORANGE            0xFFA100FF
#define YELLOW2           0xF5DEB3FF
#define MAX_PLAYER_CARS   4
#define LOCK_PRICE        20000
#pragma dynamic           719196 // FUCKING STRINGS

enum vDealerData
{
	vModel,
	Float:vX,
	Float:vY,
	Float:vZ,
	Float:vRot,
	vForSale,
	vPrice,
	Text3D:vLabel,
	vID,
	vSQL_ID
};

enum pDealerData
{
	pCarModel,
	Float:pCarX,
	Float:pCarY,
	Float:pCarZ,
	Float:pCarRot,
	pCarColor1,
	pCarColor2,
	pCarPaintjob,
	pCarMod1,
	pCarMod2,
	pCarMod3,
	pCarMod4,
	pCarMod5,
	pCarMod6,
	pCarMod7,
	pCarMod8,
	pCarMod9,
	pCarMod10,
	pCarMod11,
	pCarMod12,
	pCarMod13,
	pCarMod14,
	pCarMod15,
	pCarMod16,
	pCarMod17,
	pCarHasLock,
	pCarLocked,
	pCarTrunkCash,
	pCarTrunkGun1,
	pCarTrunkGun2,
	pCarTrunkGun3,
	pCarTrunkGun4,
	pCarTrunkAmmo1,
	pCarTrunkAmmo2,
	pCarTrunkAmmo3,
	pCarTrunkAmmo4,
	pCarSpawned,
	pCarOwned,
	pCarID
};
new PlayerVehicles[MAX_PLAYERS][MAX_PLAYER_CARS + 1][pDealerData];
new DealershipVehicles[MAX_VEHICLES][vDealerData];
new VehicleLocked[MAX_VEHICLES];
new VehicleListitem[MAX_PLAYERS][MAX_PLAYER_CARS + 1];
new DB:VehicleDatabase[MAX_PLAYERS];
new DB:DealerVehicleDatabase;
new dealershipCars;

new spoiler[20][0] = {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1058, 1060, 1049, 1050, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164};
new nitro[3][0] = {1008, 1009, 1010};
new front_bumper[23][0] = {1117, 1152, 1153, 1155, 1157, 1160, 1165, 1167, 1169, 1170, 1171, 1172, 1173, 1174, 1175, 1179, 1181, 1182, 1185, 1188, 1189, 1192, 1193};
new rear_bumper[22][0] = {1140, 1141, 1148, 1149, 1150, 1151, 1154, 1156, 1159, 1161, 1166, 1168, 1176, 1177, 1178, 1180, 1183, 1184, 1186, 1187, 1190, 1191};
new exhaust[28][0] = {1018, 1019, 1020, 1021, 1022, 1028, 1029, 1037, 1043, 1044, 1045, 1046, 1059, 1064, 1065, 1066, 1089, 1092, 1104, 1105, 1113, 1114, 1126, 1127, 1129, 1132, 1135, 1136};
new bventr[2][0] = {1042, 1044};
new bventl[2][0] = {1043, 1045};
new bscoop[4][0] = {1004, 1005, 1011, 1012};
new rscoop[13][0] = {1006, 1032, 1033, 1035, 1038, 1053, 1054, 1055, 1061, 1067, 1068, 1088, 1091};
new left_sideskirt[21][0] = {1007, 1026, 1031, 1036, 1039, 1042, 1047, 1048, 1056, 1057, 1069, 1070, 1090, 1093, 1106, 1108, 1118, 1119, 1133, 1122, 1134};
new right_sideskirt[21][0] = {1017, 1027, 1030, 1040, 1041, 1051, 1052, 1062, 1063, 1071, 1072, 1094, 1095, 1099, 1101, 1102, 1107, 1120, 1121, 1124, 1137};
new hydraulics[1][0] = {1087};
new bass[1][0] = {1086};
new rbbars[2][0] = {1109, 1110};
new fbbars[2][0] = {1115, 1116};
new wheels[17][0] = {1025, 1073, 1074, 1075, 1076, 1077, 1078, 1079, 1080, 1081, 1082, 1083, 1084, 1085, 1096, 1097, 1098};
new lights[2][0] = {1013, 1024};

stock PlayerName(playerid, bool:show_underscore = true)
{
	new pName[24];
	GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
	if (show_underscore == false)
	{
		for (new i = 0; i < strlen(pName); i += 1)
		{
		    if (pName[i] == '_') pName[i] = ' ';
		}
	}
	return pName;
}

stock sscanf(string[], format[], {Float,_}:...)
{
	#if defined isnull
		if (isnull(string))
	#else
		if (string[0] == 0 || (string[0] == 1 && string[1] == 0))
	#endif
		{
			return format[0];
		}
	#pragma tabsize 4
	new
		formatPos = 0,
		stringPos = 0,
		paramPos = 2,
		paramCount = numargs(),
		delim = ' ';
	while (string[stringPos] && string[stringPos] <= ' ')
	{
		stringPos++;
	}
	while (paramPos < paramCount && string[stringPos])
	{
		switch (format[formatPos++])
		{
			case '\0':
			{
				return 0;
			}
			case 'i', 'd':
			{
				new
					neg = 1,
					num = 0,
					ch = string[stringPos];
				if (ch == '-')
				{
					neg = -1;
					ch = string[++stringPos];
				}
				do
				{
					stringPos++;
					if ('0' <= ch <= '9')
					{
						num = (num * 10) + (ch - '0');
					}
					else
					{
						return -1;
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num * neg);
			}
			case 'h', 'x':
			{
				new
					num = 0,
					ch = string[stringPos];
				do
				{
					stringPos++;
					switch (ch)
					{
						case 'x', 'X':
						{
							num = 0;
							continue;
						}
						case '0' .. '9':
						{
							num = (num << 4) | (ch - '0');
						}
						case 'a' .. 'f':
						{
							num = (num << 4) | (ch - ('a' - 10));
						}
						case 'A' .. 'F':
						{
							num = (num << 4) | (ch - ('A' - 10));
						}
						default:
						{
							return -1;
						}
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num);
			}
			case 'c':
			{
				setarg(paramPos, 0, string[stringPos++]);
			}
			case 'f':
			{

				new changestr[16], changepos = 0, strpos = stringPos;
				while(changepos < 16 && string[strpos] && string[strpos] != delim)
				{
					changestr[changepos++] = string[strpos++];
    				}
				changestr[changepos] = '\0';
				setarg(paramPos,0,_:floatstr(changestr));
			}
			case 'p':
			{
				delim = format[formatPos++];
				continue;
			}
			case '\'':
			{
				new
					end = formatPos - 1,
					ch;
				while ((ch = format[++end]) && ch != '\'') {}
				if (!ch)
				{
					return -1;
				}
				format[end] = '\0';
				if ((ch = strfind(string, format[formatPos], false, stringPos)) == -1)
				{
					if (format[end + 1])
					{
						return -1;
					}
					return 0;
				}
				format[end] = '\'';
				stringPos = ch + (end - formatPos);
				formatPos = end + 1;
			}
			case 'u':
			{
				new
					end = stringPos - 1,
					id = 0,
					bool:num = true,
					ch;
				while ((ch = string[++end]) && ch != delim)
				{
					if (num)
					{
						if ('0' <= ch <= '9')
						{
							id = (id * 10) + (ch - '0');
						}
						else
						{
							num = false;
						}
					}
				}
				if (num && IsPlayerConnected(id))
				{
					setarg(paramPos, 0, id);
				}
				else
				{
					#if !defined foreach
						#define foreach(%1,%2) for (new %2 = 0; %2 < MAX_PLAYERS; %2++) if (IsPlayerConnected(%2))
						#define __SSCANF_FOREACH__
					#endif
					string[end] = '\0';
					num = false;
					new
						name[MAX_PLAYER_NAME];
					id = end - stringPos;
					foreach (Player, playerid)
					{
						GetPlayerName(playerid, name, sizeof (name));
						if (!strcmp(name, string[stringPos], true, id))
						{
							setarg(paramPos, 0, playerid);
							num = true;
							break;
						}
					}
					if (!num)
					{
						setarg(paramPos, 0, INVALID_PLAYER_ID);
					}
					string[end] = ch;
					#if defined __SSCANF_FOREACH__
						#undef foreach
						#undef __SSCANF_FOREACH__
					#endif
				}
				stringPos = end;
			}
			case 's', 'z':
			{
				new
					i = 0,
					ch;
				if (format[formatPos])
				{
					while ((ch = string[stringPos++]) && ch != delim)
					{
						setarg(paramPos, i++, ch);
					}
					if (!i)
					{
						return -1;
					}
				}
				else
				{
					while ((ch = string[stringPos++]))
					{
						setarg(paramPos, i++, ch);
					}
				}
				stringPos--;
				setarg(paramPos, i, '\0');
			}
			default:
			{
				continue;
			}
		}
		while (string[stringPos] && string[stringPos] != delim && string[stringPos] > ' ')
		{
			stringPos++;
		}
		while (string[stringPos] && (string[stringPos] == delim || string[stringPos] <= ' '))
		{
			stringPos++;
		}
		paramPos++;
	}
	do
	{
		if ((delim = format[formatPos++]) > ' ')
		{
			if (delim == '\'')
			{
				while ((delim = format[formatPos++]) && delim != '\'') {}
			}
			else if (delim != 'z')
			{
				return delim;
			}
		}
	}
	while (delim > ' ');
	return 0;
}

stock DB_Escape(text[])
{
    new
        ret[80 * 2],
        ch,
        i,
        j;
    while ((ch = text[i++]) && j < sizeof (ret))
    {
        if (ch == '\'')
        {
            if (j < sizeof (ret) - 2)
            {
                ret[j++] = '\'';
                ret[j++] = '\'';
            }
        }
        else if (j < sizeof (ret))
        {
            ret[j++] = ch;
        }
        else
        {
            j++;
        }
    }
    ret[sizeof (ret) - 1] = '\0';
    return ret;
}

stock ReturnComponentSlot(componentid)
{
	new i = 0;
	for(i = 0; i < 20; i ++) { if(spoiler[i][0] == componentid) { return 1; } }
	for(i = 0; i < 3; i ++) { if(nitro[i][0] == componentid) { return 2; } }
	for(i = 0; i < 23; i ++) { if(front_bumper[i][0] == componentid) { return 3; } }
	for(i = 0; i < 22; i ++) { if(rear_bumper[i][0] == componentid) { return 4; } }
	for(i = 0; i < 28; i ++) { if(exhaust[i][0] == componentid) { return 5; } }
	for(i = 0; i < 2; i ++) { if(bventr[i][0] == componentid) { return 6; } }
	for(i = 0; i < 2; i ++) { if(bventl[i][0] == componentid) { return 7; } }
	for(i = 0; i < 4; i ++) { if(bscoop[i][0] == componentid) { return 8; } }
	for(i = 0; i < 13; i ++) { if(rscoop[i][0] == componentid) { return 9; } }
	for(i = 0; i < 21; i ++) { if(left_sideskirt[i][0] == componentid) { return 10; } }
	for(i = 0; i < 21; i ++) { if(right_sideskirt[i][0] == componentid) { return 11; } }
	if(hydraulics[0][0] == componentid) { return 12; }
	if(bass[0][0] == componentid) { return 13; }
	for(i = 0; i < 2; i ++) { if(rbbars[i][0] == componentid) { return 14; } }
	for(i = 0; i < 2; i ++) { if(fbbars[i][0] == componentid) { return 15; } }
	for(i = 0; i < 17; i ++) { if(wheels[i][0] == componentid) { return 16; } }
	for(i = 0; i < 2; i ++) { if(lights[i][0] == componentid) { return 17; } }
	return 0;
}

stock GetVehicleName(vehicleid)
{
	new
		vehicle_name[32] = "None";
	if((vehicleid == INVALID_VEHICLE_ID) || (vehicleid < 1 || (vehicleid > MAX_VEHICLES - 1))) return vehicle_name;
	switch (GetVehicleModel(vehicleid))
	{
		case 400: vehicle_name = "Landstalker";
		case 401: vehicle_name = "Bravura";
		case 402: vehicle_name = "Buffalo";
		case 403: vehicle_name = "Linerunner";
		case 404: vehicle_name = "Perennial";
		case 405: vehicle_name = "Sentinel";
		case 406: vehicle_name = "Dumper";
		case 407: vehicle_name = "Firetruck";
		case 408: vehicle_name = "Trashmaster";
		case 409: vehicle_name = "Stretch";
		case 410: vehicle_name = "Manana";
		case 411: vehicle_name = "Infernus";
		case 412: vehicle_name = "Voodoo";
		case 413: vehicle_name = "Pony";
		case 414: vehicle_name = "Mule";
		case 415: vehicle_name = "Cheetah";
		case 416: vehicle_name = "Ambulance";
		case 417: vehicle_name = "Leviathan";
		case 418: vehicle_name = "Moonbeam";
		case 419: vehicle_name = "Esperanto";
		case 420: vehicle_name = "Taxi";
		case 421: vehicle_name = "Washington";
        case 422: vehicle_name = "Bobcat";
		case 423: vehicle_name = "Mr Whoopee";
		case 424: vehicle_name = "BF Injection";
		case 425: vehicle_name = "Hunter";
		case 426: vehicle_name = "Premier";
		case 427: vehicle_name = "Enforcer";
		case 428: vehicle_name = "Securicar";
		case 429: vehicle_name = "Banshee";
		case 430: vehicle_name = "Predator";
		case 431: vehicle_name = "Bus";
		case 432: vehicle_name = "Rhino";
		case 433: vehicle_name = "Barracks";
		case 434: vehicle_name = "Hotknife";
		case 435: vehicle_name = "Article Trailer";
		case 436: vehicle_name = "Previon";
		case 437: vehicle_name = "Coach";
		case 438: vehicle_name = "Cabbie";
		case 439: vehicle_name = "Stallion";
		case 440: vehicle_name = "Rumpo";
		case 441: vehicle_name = "RC Bandit";
		case 442: vehicle_name = "Romero";
		case 443: vehicle_name = "Packer";
		case 444: vehicle_name = "Monster";
		case 445: vehicle_name = "Admiral";
		case 446: vehicle_name = "Squalo";
		case 447: vehicle_name = "Seasparrow";
		case 448: vehicle_name = "Pizzaboy";
		case 449: vehicle_name = "Tram";
		case 450: vehicle_name = "Article Trailer 2";
		case 451: vehicle_name = "Turismo";
		case 452: vehicle_name = "Speeder";
		case 453: vehicle_name = "Reefer";
		case 454: vehicle_name = "Tropic";
		case 455: vehicle_name = "Flatbed";
		case 456: vehicle_name = "Yankee";
		case 457: vehicle_name = "Caddy";
		case 458: vehicle_name = "Solair";
		case 459: vehicle_name = "Berkley's RC Van";
		case 460: vehicle_name = "Skimmer";
		case 461: vehicle_name = "PCJ-600";
		case 462: vehicle_name = "Faggio";
		case 463: vehicle_name = "Freeway";
		case 464: vehicle_name = "RC Baron";
		case 465: vehicle_name = "RC Raider";
		case 466: vehicle_name = "Glendale";
		case 467: vehicle_name = "Oceanic";
		case 468: vehicle_name = "Sanchez";
		case 469: vehicle_name = "Sparrow";
		case 470: vehicle_name = "Patriot";
		case 471: vehicle_name = "Quad";
		case 472: vehicle_name = "Coastguard";
		case 473: vehicle_name = "Dinghy";
		case 474: vehicle_name = "Hermes";
		case 475: vehicle_name = "Sabre";
		case 476: vehicle_name = "Rustler";
		case 477: vehicle_name = "ZR-350";
		case 478: vehicle_name = "Walton";
		case 479: vehicle_name = "Regina";
		case 480: vehicle_name = "Comet";
		case 481: vehicle_name = "BMX";
		case 482: vehicle_name = "Burrito";
		case 483: vehicle_name = "Camper";
		case 484: vehicle_name = "Marquis";
		case 485: vehicle_name = "Baggage";
		case 486: vehicle_name = "Dozer";
		case 487: vehicle_name = "Maverick";
		case 488: vehicle_name = "SAN News Maverick";
		case 489, 505: vehicle_name = "Rancher";
		case 490: vehicle_name = "FBI Rancher";
		case 491: vehicle_name = "Virgo";
		case 492: vehicle_name = "Greenwood";
		case 493: vehicle_name = "Jetmax";
		case 494: vehicle_name = "Hotring Racer A";
		case 495: vehicle_name = "Sandking";
		case 496: vehicle_name = "Blista Compact";
		case 497: vehicle_name = "Police Maverick";
		case 498: vehicle_name = "Boxville";
		case 499: vehicle_name = "Benson";
		case 500: vehicle_name = "Mesa";
		case 501: vehicle_name = "RC Goblin";
		case 502: vehicle_name = "Hotring Racer B";
		case 503: vehicle_name = "Hotring Racer C";
		case 504: vehicle_name = "Bloodring Banger";
		case 506: vehicle_name = "Super GT";
		case 507: vehicle_name = "Elegant";
		case 508: vehicle_name = "Journey";
		case 509: vehicle_name = "Bike";
		case 510: vehicle_name = "Mountain Bike";
		case 511: vehicle_name = "Beagle";
		case 512: vehicle_name = "Cropduster";
		case 513: vehicle_name = "Stuntplane";
		case 514: vehicle_name = "Tanker";
		case 515: vehicle_name = "Roadtrain";
		case 516: vehicle_name = "Nebula";
		case 517: vehicle_name = "Majestic";
		case 518: vehicle_name = "Buccaneer";
		case 519: vehicle_name = "Shamal";
		case 520: vehicle_name = "Hydra";
		case 521: vehicle_name = "FCR-900";
		case 522: vehicle_name = "NRG-500";
		case 523: vehicle_name = "HPV1000";
		case 524: vehicle_name = "Cement Truck";
		case 525: vehicle_name = "Towtruck";
		case 526: vehicle_name = "Fortune";
		case 527: vehicle_name = "Cadrona";
		case 528: vehicle_name = "FBI Truck";
		case 529: vehicle_name = "Willard";
		case 530: vehicle_name = "Forklift";
		case 531: vehicle_name = "Tractor";
		case 532: vehicle_name = "Combine Harvester";
		case 533: vehicle_name = "Feltzer";
		case 534: vehicle_name = "Remington";
		case 535: vehicle_name = "Slamvan";
		case 536: vehicle_name = "Blade";
		case 537: vehicle_name = "Freight";
		case 538: vehicle_name = "Brownstreak";
		case 539: vehicle_name = "Vortex";
		case 540: vehicle_name = "Vincent";
		case 541: vehicle_name = "Bullet";
		case 542: vehicle_name = "Clover";
		case 543: vehicle_name = "Sadler";
		case 544: vehicle_name = "Firetruck LA";
		case 545: vehicle_name = "Hustler";
		case 546: vehicle_name = "Intruder";
		case 547: vehicle_name = "Primo";
		case 548: vehicle_name = "Cargobob";
		case 549: vehicle_name = "Tampa";
		case 550: vehicle_name = "Sunrise";
		case 551: vehicle_name = "Merit";
		case 552: vehicle_name = "Utility Van";
		case 553: vehicle_name = "Nevada";
		case 554: vehicle_name = "Yosemite";
		case 555: vehicle_name = "Windsor";
		case 556: vehicle_name = "Monster A";
		case 557: vehicle_name = "Monster B";
		case 558: vehicle_name = "Uranus";
		case 559: vehicle_name = "Jester";
		case 560: vehicle_name = "Sultan";
		case 561: vehicle_name = "Stratum";
		case 562: vehicle_name = "Elegy";
		case 563: vehicle_name = "Raindance";
		case 564: vehicle_name = "RC Tiger";
		case 565: vehicle_name = "Flash";
		case 566: vehicle_name = "Tahoma";
		case 567: vehicle_name = "Savanna";
		case 568: vehicle_name = "Bandito";
		case 569: vehicle_name = "Freight Flat Trailer";
		case 570: vehicle_name = "Streak Trailer";
		case 571: vehicle_name = "Kart";
		case 572: vehicle_name = "Mower";
		case 573: vehicle_name = "Dune";
		case 574: vehicle_name = "Sweeper";
		case 575: vehicle_name = "Broadway";
		case 576: vehicle_name = "Tornado";
		case 577: vehicle_name = "AT-400";
		case 578: vehicle_name = "DFT-30";
		case 579: vehicle_name = "Huntley";
		case 580: vehicle_name = "Stafford";
		case 581: vehicle_name = "BF-400";
		case 582: vehicle_name = "Newsvan";
		case 583: vehicle_name = "Tug";
		case 584: vehicle_name = "Petrol Trailer";
		case 585: vehicle_name = "Emperor";
		case 586: vehicle_name = "Wayfarer";
		case 587: vehicle_name = "Euros";
		case 588: vehicle_name = "Hotdog";
		case 589: vehicle_name = "Club";
		case 590: vehicle_name = "Freight Box Trailer";
		case 591: vehicle_name = "Article Trailer 3";
		case 592: vehicle_name = "Andromada";
		case 593: vehicle_name = "Dodo";
		case 594: vehicle_name = "RC Cam";
		case 595: vehicle_name = "Launch";
		case 596: vehicle_name = "LSPD Cruiser";
		case 597: vehicle_name = "SFPD Cruiser";
		case 598: vehicle_name = "LVPD Cruiser";
		case 599: vehicle_name = "Police Ranger";
		case 600: vehicle_name = "Picador";
		case 601: vehicle_name = "S.W.A.T.";
		case 602: vehicle_name = "Alpha";
		case 603: vehicle_name = "Phoenix";
		case 604: vehicle_name = "Glendale Shit";
		case 605: vehicle_name = "Sadler Shit";
		case 606: vehicle_name = "Baggage Trailer A";
		case 607: vehicle_name = "Baggage Trailer B";
		case 608: vehicle_name = "Tug Stairs";
		case 609: vehicle_name = "Boxville";
		case 610: vehicle_name = "Farm Trailer";
		case 611: vehicle_name = "Utility Trailer";
		default: vehicle_name = "None";
	}
	return vehicle_name;
}

stock GetVehicleNameByModel(model)
{
	new
		vehicle_name[32] = "None";
	if(model < 400 || model > 611) return vehicle_name;
	switch (model)
	{
		case 400: vehicle_name = "Landstalker";
		case 401: vehicle_name = "Bravura";
		case 402: vehicle_name = "Buffalo";
		case 403: vehicle_name = "Linerunner";
		case 404: vehicle_name = "Perennial";
		case 405: vehicle_name = "Sentinel";
		case 406: vehicle_name = "Dumper";
		case 407: vehicle_name = "Firetruck";
		case 408: vehicle_name = "Trashmaster";
		case 409: vehicle_name = "Stretch";
		case 410: vehicle_name = "Manana";
		case 411: vehicle_name = "Infernus";
		case 412: vehicle_name = "Voodoo";
		case 413: vehicle_name = "Pony";
		case 414: vehicle_name = "Mule";
		case 415: vehicle_name = "Cheetah";
		case 416: vehicle_name = "Ambulance";
		case 417: vehicle_name = "Leviathan";
		case 418: vehicle_name = "Moonbeam";
		case 419: vehicle_name = "Esperanto";
		case 420: vehicle_name = "Taxi";
		case 421: vehicle_name = "Washington";
        case 422: vehicle_name = "Bobcat";
		case 423: vehicle_name = "Mr Whoopee";
		case 424: vehicle_name = "BF Injection";
		case 425: vehicle_name = "Hunter";
		case 426: vehicle_name = "Premier";
		case 427: vehicle_name = "Enforcer";
		case 428: vehicle_name = "Securicar";
		case 429: vehicle_name = "Banshee";
		case 430: vehicle_name = "Predator";
		case 431: vehicle_name = "Bus";
		case 432: vehicle_name = "Rhino";
		case 433: vehicle_name = "Barracks";
		case 434: vehicle_name = "Hotknife";
		case 435: vehicle_name = "Article Trailer";
		case 436: vehicle_name = "Previon";
		case 437: vehicle_name = "Coach";
		case 438: vehicle_name = "Cabbie";
		case 439: vehicle_name = "Stallion";
		case 440: vehicle_name = "Rumpo";
		case 441: vehicle_name = "RC Bandit";
		case 442: vehicle_name = "Romero";
		case 443: vehicle_name = "Packer";
		case 444: vehicle_name = "Monster";
		case 445: vehicle_name = "Admiral";
		case 446: vehicle_name = "Squalo";
		case 447: vehicle_name = "Seasparrow";
		case 448: vehicle_name = "Pizzaboy";
		case 449: vehicle_name = "Tram";
		case 450: vehicle_name = "Article Trailer 2";
		case 451: vehicle_name = "Turismo";
		case 452: vehicle_name = "Speeder";
		case 453: vehicle_name = "Reefer";
		case 454: vehicle_name = "Tropic";
		case 455: vehicle_name = "Flatbed";
		case 456: vehicle_name = "Yankee";
		case 457: vehicle_name = "Caddy";
		case 458: vehicle_name = "Solair";
		case 459: vehicle_name = "Berkley's RC Van";
		case 460: vehicle_name = "Skimmer";
		case 461: vehicle_name = "PCJ-600";
		case 462: vehicle_name = "Faggio";
		case 463: vehicle_name = "Freeway";
		case 464: vehicle_name = "RC Baron";
		case 465: vehicle_name = "RC Raider";
		case 466: vehicle_name = "Glendale";
		case 467: vehicle_name = "Oceanic";
		case 468: vehicle_name = "Sanchez";
		case 469: vehicle_name = "Sparrow";
		case 470: vehicle_name = "Patriot";
		case 471: vehicle_name = "Quad";
		case 472: vehicle_name = "Coastguard";
		case 473: vehicle_name = "Dinghy";
		case 474: vehicle_name = "Hermes";
		case 475: vehicle_name = "Sabre";
		case 476: vehicle_name = "Rustler";
		case 477: vehicle_name = "ZR-350";
		case 478: vehicle_name = "Walton";
		case 479: vehicle_name = "Regina";
		case 480: vehicle_name = "Comet";
		case 481: vehicle_name = "BMX";
		case 482: vehicle_name = "Burrito";
		case 483: vehicle_name = "Camper";
		case 484: vehicle_name = "Marquis";
		case 485: vehicle_name = "Baggage";
		case 486: vehicle_name = "Dozer";
		case 487: vehicle_name = "Maverick";
		case 488: vehicle_name = "SAN News Maverick";
		case 489, 505: vehicle_name = "Rancher";
		case 490: vehicle_name = "FBI Rancher";
		case 491: vehicle_name = "Virgo";
		case 492: vehicle_name = "Greenwood";
		case 493: vehicle_name = "Jetmax";
		case 494: vehicle_name = "Hotring Racer A";
		case 495: vehicle_name = "Sandking";
		case 496: vehicle_name = "Blista Compact";
		case 497: vehicle_name = "Police Maverick";
		case 498: vehicle_name = "Boxville";
		case 499: vehicle_name = "Benson";
		case 500: vehicle_name = "Mesa";
		case 501: vehicle_name = "RC Goblin";
		case 502: vehicle_name = "Hotring Racer B";
		case 503: vehicle_name = "Hotring Racer C";
		case 504: vehicle_name = "Bloodring Banger";
		case 506: vehicle_name = "Super GT";
		case 507: vehicle_name = "Elegant";
		case 508: vehicle_name = "Journey";
		case 509: vehicle_name = "Bike";
		case 510: vehicle_name = "Mountain Bike";
		case 511: vehicle_name = "Beagle";
		case 512: vehicle_name = "Cropduster";
		case 513: vehicle_name = "Stuntplane";
		case 514: vehicle_name = "Tanker";
		case 515: vehicle_name = "Roadtrain";
		case 516: vehicle_name = "Nebula";
		case 517: vehicle_name = "Majestic";
		case 518: vehicle_name = "Buccaneer";
		case 519: vehicle_name = "Shamal";
		case 520: vehicle_name = "Hydra";
		case 521: vehicle_name = "FCR-900";
		case 522: vehicle_name = "NRG-500";
		case 523: vehicle_name = "HPV1000";
		case 524: vehicle_name = "Cement Truck";
		case 525: vehicle_name = "Towtruck";
		case 526: vehicle_name = "Fortune";
		case 527: vehicle_name = "Cadrona";
		case 528: vehicle_name = "FBI Truck";
		case 529: vehicle_name = "Willard";
		case 530: vehicle_name = "Forklift";
		case 531: vehicle_name = "Tractor";
		case 532: vehicle_name = "Combine Harvester";
		case 533: vehicle_name = "Feltzer";
		case 534: vehicle_name = "Remington";
		case 535: vehicle_name = "Slamvan";
		case 536: vehicle_name = "Blade";
		case 537: vehicle_name = "Freight";
		case 538: vehicle_name = "Brownstreak";
		case 539: vehicle_name = "Vortex";
		case 540: vehicle_name = "Vincent";
		case 541: vehicle_name = "Bullet";
		case 542: vehicle_name = "Clover";
		case 543: vehicle_name = "Sadler";
		case 544: vehicle_name = "Firetruck LA";
		case 545: vehicle_name = "Hustler";
		case 546: vehicle_name = "Intruder";
		case 547: vehicle_name = "Primo";
		case 548: vehicle_name = "Cargobob";
		case 549: vehicle_name = "Tampa";
		case 550: vehicle_name = "Sunrise";
		case 551: vehicle_name = "Merit";
		case 552: vehicle_name = "Utility Van";
		case 553: vehicle_name = "Nevada";
		case 554: vehicle_name = "Yosemite";
		case 555: vehicle_name = "Windsor";
		case 556: vehicle_name = "Monster A";
		case 557: vehicle_name = "Monster B";
		case 558: vehicle_name = "Uranus";
		case 559: vehicle_name = "Jester";
		case 560: vehicle_name = "Sultan";
		case 561: vehicle_name = "Stratum";
		case 562: vehicle_name = "Elegy";
		case 563: vehicle_name = "Raindance";
		case 564: vehicle_name = "RC Tiger";
		case 565: vehicle_name = "Flash";
		case 566: vehicle_name = "Tahoma";
		case 567: vehicle_name = "Savanna";
		case 568: vehicle_name = "Bandito";
		case 569: vehicle_name = "Freight Flat Trailer";
		case 570: vehicle_name = "Streak Trailer";
		case 571: vehicle_name = "Kart";
		case 572: vehicle_name = "Mower";
		case 573: vehicle_name = "Dune";
		case 574: vehicle_name = "Sweeper";
		case 575: vehicle_name = "Broadway";
		case 576: vehicle_name = "Tornado";
		case 577: vehicle_name = "AT-400";
		case 578: vehicle_name = "DFT-30";
		case 579: vehicle_name = "Huntley";
		case 580: vehicle_name = "Stafford";
		case 581: vehicle_name = "BF-400";
		case 582: vehicle_name = "Newsvan";
		case 583: vehicle_name = "Tug";
		case 584: vehicle_name = "Petrol Trailer";
		case 585: vehicle_name = "Emperor";
		case 586: vehicle_name = "Wayfarer";
		case 587: vehicle_name = "Euros";
		case 588: vehicle_name = "Hotdog";
		case 589: vehicle_name = "Club";
		case 590: vehicle_name = "Freight Box Trailer";
		case 591: vehicle_name = "Article Trailer 3";
		case 592: vehicle_name = "Andromada";
		case 593: vehicle_name = "Dodo";
		case 594: vehicle_name = "RC Cam";
		case 595: vehicle_name = "Launch";
		case 596: vehicle_name = "LSPD Cruiser";
		case 597: vehicle_name = "SFPD Cruiser";
		case 598: vehicle_name = "LVPD Cruiser";
		case 599: vehicle_name = "Police Ranger";
		case 600: vehicle_name = "Picador";
		case 601: vehicle_name = "S.W.A.T.";
		case 602: vehicle_name = "Alpha";
		case 603: vehicle_name = "Phoenix";
		case 604: vehicle_name = "Glendale Shit";
		case 605: vehicle_name = "Sadler Shit";
		case 606: vehicle_name = "Baggage Trailer A";
		case 607: vehicle_name = "Baggage Trailer B";
		case 608: vehicle_name = "Tug Stairs";
		case 609: vehicle_name = "Boxville";
		case 610: vehicle_name = "Farm Trailer";
		case 611: vehicle_name = "Utility Trailer";
		default: vehicle_name = "None";
	}
	return vehicle_name;
}

stock CreateVehicleTables(playerid)
{
	if (IsPlayerConnected(playerid))
	{
	    new query[1536];
     	format(query, sizeof(query), "CREATE TABLE IF NOT EXISTS `VEHICLES` ");
	    strcat(query, "(`Name`, `Model`, `X`, `Y`, `Z`, `Rot`, `Color1`, `Color2`, `Paintjob`, `Mod1`, `Mod2`, `Mod3`, ");
	    strcat(query, "`Mod4`, `Mod5`, `Mod6`, `Mod7`, `Mod8`, `Mod9`, `Mod10`, `Mod11`, `Mod12`, `Mod13`, ");
	    strcat(query, "`Mod14`, `Mod15`, `Mod16`, `Mod17`, `HasLock`, `Locked`, `TrunkCash`, ");
	    strcat(query, "`TrunkGun1`, `TrunkGun2`, `TrunkGun3`, `TrunkGun4`, `TrunkAmmo1`, `TrunkAmmo2`, `TrunkAmmo3`, ");
		strcat(query, "`TrunkAmmo4`, `Spawned`, `Owned`, `Slot`)");
		db_query(VehicleDatabase[playerid], query);
	}
	return 1;
}

stock DeleteDealershipVehicle(vehicleid)
{
	new query[128];
	if (DealershipVehicles[vehicleid][vForSale])
	{
		format(query, sizeof(query), "DELETE FROM `DEALERCARS` WHERE `vID` = '%d'", DealershipVehicles[vehicleid][vSQL_ID]);
		db_query(DealerVehicleDatabase, query);
        DealershipVehicles[vehicleid][vModel] = 0;
		DealershipVehicles[vehicleid][vX] = 0.0;
		DealershipVehicles[vehicleid][vY] = 0.0;
		DealershipVehicles[vehicleid][vZ] = 0.0;
		DealershipVehicles[vehicleid][vRot] = 0.0;
		DealershipVehicles[vehicleid][vForSale] = 0;
		DealershipVehicles[vehicleid][vPrice] = 0;
		Delete3DTextLabel(DealershipVehicles[vehicleid][vLabel]);
		DestroyVehicle(DealershipVehicles[vehicleid][vID]);
		DealershipVehicles[vehicleid][vID] = 0;
		DealershipVehicles[vehicleid][vSQL_ID] = 0;
		dealershipCars -= 1;
		return 1;
	}
	return 0;
}

stock DeletePlayerVehicle(playerid, slot)
{
	new query[128];
	if (PlayerVehicles[playerid][slot][pCarOwned])
	{
		format(query, sizeof(query), "DELETE FROM `VEHICLES` WHERE `Name` = '%s' AND `Slot` = '%d'", PlayerName(playerid), slot);
		db_query(VehicleDatabase[playerid], query);
		PlayerVehicles[playerid][slot][pCarModel] = 0;
		PlayerVehicles[playerid][slot][pCarX] = 0.0;
		PlayerVehicles[playerid][slot][pCarY] = 0.0;
		PlayerVehicles[playerid][slot][pCarZ] = 0.0;
		PlayerVehicles[playerid][slot][pCarRot] = 0.0;
		PlayerVehicles[playerid][slot][pCarColor1] = 0;
		PlayerVehicles[playerid][slot][pCarColor2] = 0;
		PlayerVehicles[playerid][slot][pCarPaintjob] = -1;
		PlayerVehicles[playerid][slot][pCarMod1] = 0;
		PlayerVehicles[playerid][slot][pCarMod2] = 0;
		PlayerVehicles[playerid][slot][pCarMod3] = 0;
		PlayerVehicles[playerid][slot][pCarMod4] = 0;
		PlayerVehicles[playerid][slot][pCarMod5] = 0;
		PlayerVehicles[playerid][slot][pCarMod6] = 0;
		PlayerVehicles[playerid][slot][pCarMod7] = 0;
		PlayerVehicles[playerid][slot][pCarMod8] = 0;
		PlayerVehicles[playerid][slot][pCarMod9] = 0;
		PlayerVehicles[playerid][slot][pCarMod10] = 0;
		PlayerVehicles[playerid][slot][pCarMod11] = 0;
		PlayerVehicles[playerid][slot][pCarMod12] = 0;
		PlayerVehicles[playerid][slot][pCarMod13] = 0;
		PlayerVehicles[playerid][slot][pCarMod14] = 0;
		PlayerVehicles[playerid][slot][pCarMod15] = 0;
		PlayerVehicles[playerid][slot][pCarMod16] = 0;
		PlayerVehicles[playerid][slot][pCarMod17] = 0;
		PlayerVehicles[playerid][slot][pCarHasLock] = 0;
		PlayerVehicles[playerid][slot][pCarLocked] = 0;
		PlayerVehicles[playerid][slot][pCarTrunkCash] = 0;
		PlayerVehicles[playerid][slot][pCarTrunkGun1] = 0;
		PlayerVehicles[playerid][slot][pCarTrunkGun2] = 0;
		PlayerVehicles[playerid][slot][pCarTrunkGun3] = 0;
		PlayerVehicles[playerid][slot][pCarTrunkGun4] = 0;
		PlayerVehicles[playerid][slot][pCarTrunkAmmo1] = 0;
		PlayerVehicles[playerid][slot][pCarTrunkAmmo2] = 0;
		PlayerVehicles[playerid][slot][pCarTrunkAmmo3] = 0;
		PlayerVehicles[playerid][slot][pCarTrunkAmmo4] = 0;
		PlayerVehicles[playerid][slot][pCarSpawned] = 0;
		PlayerVehicles[playerid][slot][pCarOwned] = 0;
		if (PlayerVehicles[playerid][slot][pCarID] != 0)
		{
		    UnlockVehicle(PlayerVehicles[playerid][slot][pCarID]);
			DestroyVehicle(PlayerVehicles[playerid][slot][pCarID]);
			PlayerVehicles[playerid][slot][pCarID] = 0;
		}
		return 1;
	}
	return 0;
}

stock CreateDealershipVehicle(model, price, Float:x, Float:y, Float:z, Float:rotation)
{
	if (model < 400 || model > 611)
		return 0;

	new
	    vehicleid,
	    string[256],
		query[1536];
	    
	vehicleid = CreateVehicle(model, x, y, z, rotation, 1, 1, 5);
	if (vehicleid == INVALID_VEHICLE_ID)
	    return 0;
	    
    DealershipVehicles[vehicleid][vModel] = model;
	DealershipVehicles[vehicleid][vX] = x;
	DealershipVehicles[vehicleid][vY] = y;
	DealershipVehicles[vehicleid][vZ] = z;
	DealershipVehicles[vehicleid][vRot] = rotation;
	DealershipVehicles[vehicleid][vForSale] = 1;
	DealershipVehicles[vehicleid][vPrice] = price;
	DealershipVehicles[vehicleid][vID] = vehicleid;
	DealershipVehicles[vehicleid][vSQL_ID] = dealershipCars + 1;
	format(string, sizeof(string), "This {FFFFFF}%s {F5DEB3}is for sale.\nThe cost of this vehicle is {FFFFFF}$%d.\n{F5DEB3}For more information, enter the vehicle.", GetVehicleName(vehicleid), price);
	DealershipVehicles[vehicleid][vLabel] = Create3DTextLabel(string, YELLOW2, x, y, z, 10.0, 0);
	dealershipCars += 1;

	format(query, sizeof(query), "INSERT INTO `DEALERCARS` (`vID`, `vModel`, `vX`, `vY`, `vZ`, `vRot`, `vForSale`, `vPrice`) VALUES('%d', '%d', '%f', '%f', '%f', '%f', '%d', '%d')", dealershipCars, model, x, y, z, rotation, 1, price);
	db_query(DealerVehicleDatabase, query);
	return vehicleid;
}

stock CreatePlayerVehicle(playerid, model, Float:x, Float:y, Float:z, Float:rotation)
{
	new slot = -1;
	for (new i = 1; i < MAX_PLAYER_CARS + 1; i += 1)
	{
		if (PlayerVehicles[playerid][i][pCarOwned] == 0)
		{
			slot = i;
			break;
		}
	}
	if (slot == -1) return 0;
	new vehicleid = CreateVehicle(model, x, y, z, rotation, 1, 1, -1);
	if (vehicleid == INVALID_VEHICLE_ID) return -1;
    PlayerVehicles[playerid][slot][pCarModel] = model;
	PlayerVehicles[playerid][slot][pCarX] = x;
	PlayerVehicles[playerid][slot][pCarY] = y;
	PlayerVehicles[playerid][slot][pCarZ] = z;
	PlayerVehicles[playerid][slot][pCarRot] = rotation;
	PlayerVehicles[playerid][slot][pCarColor1] = 1;
	PlayerVehicles[playerid][slot][pCarColor2] = 1;
	PlayerVehicles[playerid][slot][pCarPaintjob] = -1;
	PlayerVehicles[playerid][slot][pCarMod1] = 0;
	PlayerVehicles[playerid][slot][pCarMod2] = 0;
	PlayerVehicles[playerid][slot][pCarMod3] = 0;
	PlayerVehicles[playerid][slot][pCarMod4] = 0;
	PlayerVehicles[playerid][slot][pCarMod5] = 0;
	PlayerVehicles[playerid][slot][pCarMod6] = 0;
	PlayerVehicles[playerid][slot][pCarMod7] = 0;
	PlayerVehicles[playerid][slot][pCarMod8] = 0;
	PlayerVehicles[playerid][slot][pCarMod9] = 0;
	PlayerVehicles[playerid][slot][pCarMod10] = 0;
	PlayerVehicles[playerid][slot][pCarMod11] = 0;
	PlayerVehicles[playerid][slot][pCarMod12] = 0;
	PlayerVehicles[playerid][slot][pCarMod13] = 0;
	PlayerVehicles[playerid][slot][pCarMod14] = 0;
	PlayerVehicles[playerid][slot][pCarMod15] = 0;
	PlayerVehicles[playerid][slot][pCarMod16] = 0;
	PlayerVehicles[playerid][slot][pCarMod17] = 0;
	PlayerVehicles[playerid][slot][pCarHasLock] = 0;
	PlayerVehicles[playerid][slot][pCarLocked] = 0;
	PlayerVehicles[playerid][slot][pCarTrunkCash] = 0;
	PlayerVehicles[playerid][slot][pCarTrunkGun1] = 0;
	PlayerVehicles[playerid][slot][pCarTrunkGun2] = 0;
	PlayerVehicles[playerid][slot][pCarTrunkGun3] = 0;
	PlayerVehicles[playerid][slot][pCarTrunkGun4] = 0;
	PlayerVehicles[playerid][slot][pCarTrunkAmmo1] = 0;
	PlayerVehicles[playerid][slot][pCarTrunkAmmo2] = 0;
	PlayerVehicles[playerid][slot][pCarTrunkAmmo3] = 0;
	PlayerVehicles[playerid][slot][pCarTrunkAmmo4] = 0;
	PlayerVehicles[playerid][slot][pCarSpawned] = 1;
	PlayerVehicles[playerid][slot][pCarOwned] = 1;
	PlayerVehicles[playerid][slot][pCarID] = vehicleid;
	
	new query[1536], query2[1536];
	format(query, sizeof(query), "INSERT INTO `VEHICLES` ");
	strcat(query, "(`Name`, `Model`, `X`, `Y`, `Z`, `Rot`, `Color1`, `Color2`, `Paintjob`, `Mod1`, `Mod2`, `Mod3`, ");
 	strcat(query, "`Mod4`, `Mod5`, `Mod6`, `Mod7`, `Mod8`, `Mod9`, `Mod10`, `Mod11`, `Mod12`, `Mod13`, ");
 	strcat(query, "`Mod14`, `Mod15`, `Mod16`, `Mod17`, `HasLock`, `Locked`, `TrunkCash`, ");
 	strcat(query, "`TrunkGun1`, `TrunkGun2`, `TrunkGun3`, `TrunkGun4`, `TrunkAmmo1`, `TrunkAmmo2`, `TrunkAmmo3`, ");
	strcat(query, "`TrunkAmmo4`, `Spawned`, `Owned`, `Slot`) ");
	
	format(query2, sizeof(query2), "VALUES('%s', '%d', '%f', '%f', '%f', '%f', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d')",
	    DB_Escape(PlayerName(playerid)),
        PlayerVehicles[playerid][slot][pCarModel],
		PlayerVehicles[playerid][slot][pCarX],
		PlayerVehicles[playerid][slot][pCarY],
		PlayerVehicles[playerid][slot][pCarZ],
		PlayerVehicles[playerid][slot][pCarRot],
		PlayerVehicles[playerid][slot][pCarColor1],
		PlayerVehicles[playerid][slot][pCarColor2],
		PlayerVehicles[playerid][slot][pCarPaintjob],
		PlayerVehicles[playerid][slot][pCarMod1],
		PlayerVehicles[playerid][slot][pCarMod2],
		PlayerVehicles[playerid][slot][pCarMod3],
		PlayerVehicles[playerid][slot][pCarMod4],
		PlayerVehicles[playerid][slot][pCarMod5],
		PlayerVehicles[playerid][slot][pCarMod6],
		PlayerVehicles[playerid][slot][pCarMod7],
		PlayerVehicles[playerid][slot][pCarMod8],
		PlayerVehicles[playerid][slot][pCarMod9],
		PlayerVehicles[playerid][slot][pCarMod10],
		PlayerVehicles[playerid][slot][pCarMod11],
		PlayerVehicles[playerid][slot][pCarMod12],
		PlayerVehicles[playerid][slot][pCarMod13],
		PlayerVehicles[playerid][slot][pCarMod14],
		PlayerVehicles[playerid][slot][pCarMod15],
		PlayerVehicles[playerid][slot][pCarMod16],
		PlayerVehicles[playerid][slot][pCarMod17],
		PlayerVehicles[playerid][slot][pCarHasLock],
		PlayerVehicles[playerid][slot][pCarLocked],
		PlayerVehicles[playerid][slot][pCarTrunkCash],
		PlayerVehicles[playerid][slot][pCarTrunkGun1],
		PlayerVehicles[playerid][slot][pCarTrunkGun2],
		PlayerVehicles[playerid][slot][pCarTrunkGun3],
		PlayerVehicles[playerid][slot][pCarTrunkGun4],
		PlayerVehicles[playerid][slot][pCarTrunkAmmo1],
		PlayerVehicles[playerid][slot][pCarTrunkAmmo2],
		PlayerVehicles[playerid][slot][pCarTrunkAmmo3],
		PlayerVehicles[playerid][slot][pCarTrunkAmmo4],
		PlayerVehicles[playerid][slot][pCarSpawned],
		PlayerVehicles[playerid][slot][pCarOwned],
		slot);
	strcat(query, query2);
	db_query(VehicleDatabase[playerid], query);
	SavePlayerVehicle(playerid, slot);
	return 1;
}

stock SavePlayerVehicle(playerid, slot)
{
	if (PlayerVehicles[playerid][slot][pCarOwned])
	{
        new query[1536], query2[1536];
 		format(query, sizeof(query), "UPDATE `VEHICLES` SET ");
		format(query2, sizeof(query2), "Name = '%s', Model = '%d', X = '%f', Y = '%f', Z = '%f', Rot = '%f', Color1 = '%d', Color2 = '%d', Paintjob = '%d', Mod1 = '%d', Mod2 = '%d', Mod3 = '%d', ",
		    DB_Escape(PlayerName(playerid)),
		    PlayerVehicles[playerid][slot][pCarModel],
		    PlayerVehicles[playerid][slot][pCarX],
		    PlayerVehicles[playerid][slot][pCarY],
		    PlayerVehicles[playerid][slot][pCarZ],
		    PlayerVehicles[playerid][slot][pCarRot],
		    PlayerVehicles[playerid][slot][pCarColor1],
		    PlayerVehicles[playerid][slot][pCarColor2],
		    PlayerVehicles[playerid][slot][pCarPaintjob],
		    PlayerVehicles[playerid][slot][pCarMod1],
		    PlayerVehicles[playerid][slot][pCarMod2],
		    PlayerVehicles[playerid][slot][pCarMod3]);
		strcat(query, query2);

		format(query2, sizeof(query2), "Mod4 = '%d', Mod5 = '%d', Mod6 = '%d', Mod7 = '%d', Mod8 = '%d', Mod9 = '%d', Mod10 = '%d', Mod11 = '%d', Mod12 = '%d', Mod13 = '%d', Mod14 = '%d', Mod15 = '%d', ",
            PlayerVehicles[playerid][slot][pCarMod4],
		    PlayerVehicles[playerid][slot][pCarMod5],
		    PlayerVehicles[playerid][slot][pCarMod6],
		    PlayerVehicles[playerid][slot][pCarMod7],
		    PlayerVehicles[playerid][slot][pCarMod8],
		    PlayerVehicles[playerid][slot][pCarMod9],
		    PlayerVehicles[playerid][slot][pCarMod10],
		    PlayerVehicles[playerid][slot][pCarMod11],
		    PlayerVehicles[playerid][slot][pCarMod12],
		    PlayerVehicles[playerid][slot][pCarMod13],
		    PlayerVehicles[playerid][slot][pCarMod14],
		    PlayerVehicles[playerid][slot][pCarMod15]);
        strcat(query, query2);

		format(query2, sizeof(query2), "Mod16 = '%d', Mod17 = '%d', HasLock = '%d', Locked = '%d', TrunkCash = '%d', TrunkGun1 = '%d', TrunkGun2 = '%d', TrunkGun3 = '%d', TrunkGun4 = '%d', TrunkAmmo1 = '%d', TrunkAmmo2 = '%d', TrunkAmmo3 = '%d', ",
			PlayerVehicles[playerid][slot][pCarMod16],
   			PlayerVehicles[playerid][slot][pCarMod17],
		    PlayerVehicles[playerid][slot][pCarHasLock],
		    PlayerVehicles[playerid][slot][pCarLocked],
		    PlayerVehicles[playerid][slot][pCarTrunkCash],
		    PlayerVehicles[playerid][slot][pCarTrunkGun1],
		    PlayerVehicles[playerid][slot][pCarTrunkGun2],
		    PlayerVehicles[playerid][slot][pCarTrunkGun3],
		    PlayerVehicles[playerid][slot][pCarTrunkGun4],
		    PlayerVehicles[playerid][slot][pCarTrunkAmmo1],
		    PlayerVehicles[playerid][slot][pCarTrunkAmmo2],
		    PlayerVehicles[playerid][slot][pCarTrunkAmmo3]);
		strcat(query, query2);
		
		format(query2, sizeof(query2), "TrunkAmmo4 = '%d', Spawned = '%d', Owned = '%d', Slot = '%d' WHERE Name = '%s' AND Slot = '%d'",
			PlayerVehicles[playerid][slot][pCarTrunkAmmo4],
		    PlayerVehicles[playerid][slot][pCarSpawned],
		    PlayerVehicles[playerid][slot][pCarOwned],
		    slot,
			DB_Escape(PlayerName(playerid)),
			slot);
	    strcat(query, query2);
		db_query(VehicleDatabase[playerid], query);
	}
	return 1;
}

stock LoadPlayerVehicles(playerid)
{
	new DBResult:result;
	new query[192], field[64];
	for (new i = 1; i < MAX_PLAYER_CARS + 1; i += 1)
	{
		format(query, sizeof(query), "SELECT * FROM `VEHICLES` WHERE `Name` = '%s' COLLATE NOCASE AND `Slot` = '%d'", PlayerName(playerid), i);
		result = db_query(VehicleDatabase[playerid], query);
		if (db_num_rows(result))
		{
            db_get_field_assoc(result, "Model", field, sizeof(field)); PlayerVehicles[playerid][i][pCarModel] = strval(field);
			db_get_field_assoc(result, "X", field, sizeof(field)); PlayerVehicles[playerid][i][pCarX] = floatstr(field);
			db_get_field_assoc(result, "Y", field, sizeof(field)); PlayerVehicles[playerid][i][pCarY] = floatstr(field);
			db_get_field_assoc(result, "Z", field, sizeof(field)); PlayerVehicles[playerid][i][pCarZ] = floatstr(field);
			db_get_field_assoc(result, "Rot", field, sizeof(field)); PlayerVehicles[playerid][i][pCarRot] = floatstr(field);
			db_get_field_assoc(result, "Color1", field, sizeof(field)); PlayerVehicles[playerid][i][pCarColor1] = strval(field);
			db_get_field_assoc(result, "Color2", field, sizeof(field)); PlayerVehicles[playerid][i][pCarColor2] = strval(field);
			db_get_field_assoc(result, "Paintjob", field, sizeof(field)); PlayerVehicles[playerid][i][pCarPaintjob] = strval(field);
			db_get_field_assoc(result, "Mod1", field, sizeof(field)); PlayerVehicles[playerid][i][pCarMod1] = strval(field);
			db_get_field_assoc(result, "Mod2", field, sizeof(field)); PlayerVehicles[playerid][i][pCarMod2] = strval(field);
			db_get_field_assoc(result, "Mod3", field, sizeof(field)); PlayerVehicles[playerid][i][pCarMod3] = strval(field);
			db_get_field_assoc(result, "Mod4", field, sizeof(field)); PlayerVehicles[playerid][i][pCarMod4] = strval(field);
			db_get_field_assoc(result, "Mod5", field, sizeof(field)); PlayerVehicles[playerid][i][pCarMod5] = strval(field);
			db_get_field_assoc(result, "Mod6", field, sizeof(field)); PlayerVehicles[playerid][i][pCarMod6] = strval(field);
			db_get_field_assoc(result, "Mod7", field, sizeof(field)); PlayerVehicles[playerid][i][pCarMod7] = strval(field);
			db_get_field_assoc(result, "Mod8", field, sizeof(field)); PlayerVehicles[playerid][i][pCarMod8] = strval(field);
			db_get_field_assoc(result, "Mod9", field, sizeof(field)); PlayerVehicles[playerid][i][pCarMod9] = strval(field);
			db_get_field_assoc(result, "Mod10", field, sizeof(field)); PlayerVehicles[playerid][i][pCarMod10] = strval(field);
			db_get_field_assoc(result, "Mod11", field, sizeof(field)); PlayerVehicles[playerid][i][pCarMod11] = strval(field);
			db_get_field_assoc(result, "Mod12", field, sizeof(field)); PlayerVehicles[playerid][i][pCarMod12] = strval(field);
			db_get_field_assoc(result, "Mod13", field, sizeof(field)); PlayerVehicles[playerid][i][pCarMod13] = strval(field);
			db_get_field_assoc(result, "Mod14", field, sizeof(field)); PlayerVehicles[playerid][i][pCarMod14] = strval(field);
			db_get_field_assoc(result, "Mod15", field, sizeof(field)); PlayerVehicles[playerid][i][pCarMod15] = strval(field);
			db_get_field_assoc(result, "Mod16", field, sizeof(field)); PlayerVehicles[playerid][i][pCarMod16] = strval(field);
			db_get_field_assoc(result, "Mod17", field, sizeof(field)); PlayerVehicles[playerid][i][pCarMod17] = strval(field);
			db_get_field_assoc(result, "HasLock", field, sizeof(field)); PlayerVehicles[playerid][i][pCarHasLock] = strval(field);
			db_get_field_assoc(result, "Locked", field, sizeof(field)); PlayerVehicles[playerid][i][pCarLocked] = strval(field);
			db_get_field_assoc(result, "TrunkCash", field, sizeof(field)); PlayerVehicles[playerid][i][pCarTrunkCash] = strval(field);
			db_get_field_assoc(result, "TrunkGun1", field, sizeof(field)); PlayerVehicles[playerid][i][pCarTrunkGun1] = strval(field);
			db_get_field_assoc(result, "TrunkGun2", field, sizeof(field)); PlayerVehicles[playerid][i][pCarTrunkGun2] = strval(field);
			db_get_field_assoc(result, "TrunkGun3", field, sizeof(field)); PlayerVehicles[playerid][i][pCarTrunkGun3] = strval(field);
			db_get_field_assoc(result, "TrunkGun4", field, sizeof(field)); PlayerVehicles[playerid][i][pCarTrunkGun4] = strval(field);
			db_get_field_assoc(result, "TrunkAmmo1", field, sizeof(field)); PlayerVehicles[playerid][i][pCarTrunkAmmo1] = strval(field);
			db_get_field_assoc(result, "TrunkAmmo2", field, sizeof(field)); PlayerVehicles[playerid][i][pCarTrunkAmmo2] = strval(field);
			db_get_field_assoc(result, "TrunkAmmo3", field, sizeof(field)); PlayerVehicles[playerid][i][pCarTrunkAmmo3] = strval(field);
			db_get_field_assoc(result, "TrunkAmmo4", field, sizeof(field)); PlayerVehicles[playerid][i][pCarTrunkAmmo4] = strval(field);
			db_get_field_assoc(result, "Spawned", field, sizeof(field)); PlayerVehicles[playerid][i][pCarSpawned] = strval(field);
			db_get_field_assoc(result, "Owned", field, sizeof(field)); PlayerVehicles[playerid][i][pCarOwned] = strval(field);
		}
		if (PlayerVehicles[playerid][i][pCarOwned])
		{
		    if (PlayerVehicles[playerid][i][pCarSpawned])
		    {
		    	PlayerVehicles[playerid][i][pCarID] = CreateVehicle(PlayerVehicles[playerid][i][pCarModel], PlayerVehicles[playerid][i][pCarX], PlayerVehicles[playerid][i][pCarY], PlayerVehicles[playerid][i][pCarZ], PlayerVehicles[playerid][i][pCarRot], PlayerVehicles[playerid][i][pCarColor1], PlayerVehicles[playerid][i][pCarColor2], -1);
		    	ModifyVehicle(playerid, i);
			}
		}
		db_free_result(result);
	}
	return 1;
}

stock SaveDealershipVehicles()
{
	new query[512], query2[512];
	for (new i = 1; i < MAX_VEHICLES; i += 1)
	{
		if (!DealershipVehicles[i][vForSale]) continue;

		format(query, sizeof(query), "UPDATE `DEALERCARS` SET ");
		format(query2, sizeof(query2), "vID = '%d', vModel = '%d', vX = '%f', vY = '%f', vZ = '%f', vRot = '%f', vForSale = '%d', vPrice = '%d' WHERE `vID` = '%d'",
		    DealershipVehicles[i][vSQL_ID],
			DealershipVehicles[i][vModel],
			DealershipVehicles[i][vX],
			DealershipVehicles[i][vY],
			DealershipVehicles[i][vZ],
			DealershipVehicles[i][vRot],
			DealershipVehicles[i][vForSale],
			DealershipVehicles[i][vPrice],
			DealershipVehicles[i][vSQL_ID]);
		    
		strcat(query, query2);
		db_query(DealerVehicleDatabase, query);
	}
	return 1;
}

stock LoadDealershipVehicles()
{
	new DBResult:result;
    new query[128], field[64], string[256];
	for (new i = 1; i < MAX_VEHICLES; i += 1)
	{
	    format(query, sizeof(query), "SELECT * FROM `DEALERCARS` WHERE vID = '%d'", i);
		result = db_query(DealerVehicleDatabase, query);
		if (db_num_rows(result))
		{
		    new model, Float:x, Float:y, Float:z, Float:rot, forsale, price, vehicleid;
			db_get_field_assoc(result, "vModel", field, sizeof(field)); model = strval(field);
			db_get_field_assoc(result, "vX", field, sizeof(field)); x = strval(field);
			db_get_field_assoc(result, "vY", field, sizeof(field)); y = strval(field);
			db_get_field_assoc(result, "vZ", field, sizeof(field)); z = strval(field);
			db_get_field_assoc(result, "vRot", field, sizeof(field)); rot = strval(field);
			db_get_field_assoc(result, "vForSale", field, sizeof(field)); forsale = strval(field);
			db_get_field_assoc(result, "vPrice", field, sizeof(field)); price = strval(field);
			vehicleid = CreateVehicle(model, x, y, z, rot, 1, 1, 5);

			DealershipVehicles[vehicleid][vModel] = model;
			DealershipVehicles[vehicleid][vX] = x;
			DealershipVehicles[vehicleid][vY] = y;
			DealershipVehicles[vehicleid][vZ] = z;
			DealershipVehicles[vehicleid][vRot] = rot;
			DealershipVehicles[vehicleid][vForSale] = forsale;
			DealershipVehicles[vehicleid][vPrice] = price;
			DealershipVehicles[vehicleid][vID] = vehicleid;
			format(string, sizeof(string), "This {FFFFFF}%s {F5DEB3}is for sale.\nThe cost of this vehicle is {FFFFFF}$%d.\n{F5DEB3}For more information, enter the vehicle.", GetVehicleName(vehicleid), price);
			DealershipVehicles[vehicleid][vLabel] = Create3DTextLabel(string, YELLOW2, x, y, z, 10.0, 0);
			DealershipVehicles[vehicleid][vSQL_ID] = dealershipCars + 1;
			dealershipCars += 1;
		}
		db_free_result(result);
	}
	return 1;
}

stock ModifyVehicle(playerid, slot)
{
    if (!PlayerVehicles[playerid][slot][pCarOwned]) return 1;
    if (!PlayerVehicles[playerid][slot][pCarSpawned]) return 1;
    new vehicleid = PlayerVehicles[playerid][slot][pCarID];
	new comp1 = PlayerVehicles[playerid][slot][pCarMod1];
	new comp2 = PlayerVehicles[playerid][slot][pCarMod2];
	new comp3 = PlayerVehicles[playerid][slot][pCarMod3];
	new comp4 = PlayerVehicles[playerid][slot][pCarMod4];
	new comp5 = PlayerVehicles[playerid][slot][pCarMod5];
	new comp6 = PlayerVehicles[playerid][slot][pCarMod6];
	new comp7 = PlayerVehicles[playerid][slot][pCarMod7];
	new comp8 = PlayerVehicles[playerid][slot][pCarMod8];
	new comp9 = PlayerVehicles[playerid][slot][pCarMod9];
	new comp10 = PlayerVehicles[playerid][slot][pCarMod10];
	new comp11 = PlayerVehicles[playerid][slot][pCarMod11];
	new comp12 = PlayerVehicles[playerid][slot][pCarMod12];
	new comp13 = PlayerVehicles[playerid][slot][pCarMod13];
	new comp14 = PlayerVehicles[playerid][slot][pCarMod14];
	new comp15 = PlayerVehicles[playerid][slot][pCarMod15];
	new comp16 = PlayerVehicles[playerid][slot][pCarMod16];
	new comp17 = PlayerVehicles[playerid][slot][pCarMod17];
	new color1 = PlayerVehicles[playerid][slot][pCarColor1];
	new color2 = PlayerVehicles[playerid][slot][pCarColor2];
	new paintjob = PlayerVehicles[playerid][slot][pCarPaintjob];

	if (comp1 != 0) AddVehicleComponent(vehicleid, comp1);
	if (comp2 != 0) AddVehicleComponent(vehicleid, comp2);
	if (comp3 != 0) AddVehicleComponent(vehicleid, comp3);
	if (comp4 != 0) AddVehicleComponent(vehicleid, comp4);
	if (comp5 != 0) AddVehicleComponent(vehicleid, comp5);
	if (comp6 != 0) AddVehicleComponent(vehicleid, comp6);
	if (comp7 != 0) AddVehicleComponent(vehicleid, comp7);
	if (comp8 != 0) AddVehicleComponent(vehicleid, comp8);
	if (comp9 != 0) AddVehicleComponent(vehicleid, comp9);
	if (comp10 != 0) AddVehicleComponent(vehicleid, comp10);
	if (comp11 != 0) AddVehicleComponent(vehicleid, comp11);
	if (comp12 != 0) AddVehicleComponent(vehicleid, comp12);
	if (comp13 != 0) AddVehicleComponent(vehicleid, comp13);
	if (comp14 != 0) AddVehicleComponent(vehicleid, comp14);
	if (comp15 != 0) AddVehicleComponent(vehicleid, comp15);
	if (comp16 != 0) AddVehicleComponent(vehicleid, comp16);
	if (comp17 != 0) AddVehicleComponent(vehicleid, comp17);
	ChangeVehicleColor(vehicleid, color1, color2);
	if (paintjob != -1) ChangeVehiclePaintjob(vehicleid, paintjob);
	
	switch (PlayerVehicles[playerid][slot][pCarLocked])
	{
	    case 0: UnlockVehicle(PlayerVehicles[playerid][slot][pCarID]);
	    case 1: LockVehicle(PlayerVehicles[playerid][slot][pCarID]);
	}
	return 1;
}

stock LockVehicle(vehicleid)
{
	foreach(Player, i)
	{
	    SetVehicleParamsForPlayer(vehicleid, i, 0, 1);
	}
	VehicleLocked[vehicleid] = 1;
	return 1;
}

stock UnlockVehicle(vehicleid)
{
	foreach(Player, i)
	{
	    SetVehicleParamsForPlayer(vehicleid, i, 0, 0);
	}
	VehicleLocked[vehicleid] = 0;
	return 1;
}

stock PlayerOwnsVehicle(playerid, vehicleid)
{
    for (new i = 1; i < MAX_PLAYER_CARS + 1; i += 1)
    {
    	if (PlayerVehicles[playerid][i][pCarID] == vehicleid && PlayerVehicles[playerid][i][pCarSpawned]) return 1;
	}
	return 0;
}

stock GetPlayerVehicleSlot(playerid)
{
	if (IsPlayerInAnyVehicle(playerid))
	{
	    for (new i = 1; i < MAX_PLAYER_CARS + 1; i += 1)
	    {
	        if (PlayerVehicles[playerid][i][pCarID] == GetPlayerVehicleID(playerid) && PlayerVehicles[playerid][i][pCarSpawned])
	        {
	            return i;
			}
		}
	}
	return 0;
}

stock GetPlayerVehicleAmount(playerid)
{
	new iCars;
	for (new i = 1; i < MAX_PLAYER_CARS + 1; i += 1)
	{
	    if (PlayerVehicles[playerid][i][pCarOwned]) ++iCars;
	}
	return iCars;
}

stock ParkVehicle(playerid, slot)
{
	if (IsPlayerInVehicle(playerid, PlayerVehicles[playerid][slot][pCarID]))
	{
		if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
		    new Float:x, Float:y, Float:z, Float:angle;
		    GetVehiclePos(GetPlayerVehicleID(playerid), x, y, z);
		    GetVehicleZAngle(GetPlayerVehicleID(playerid), angle);
			PlayerVehicles[playerid][slot][pCarX] = x;
			PlayerVehicles[playerid][slot][pCarY] = y;
			PlayerVehicles[playerid][slot][pCarZ] = z;
			PlayerVehicles[playerid][slot][pCarRot] = angle;
			foreach(Player, i)
			{
			    if (i == playerid) continue;
			    if (IsPlayerInVehicle(i, PlayerVehicles[playerid][slot][pCarID]))
			    {
			        SetPVarInt(i, "CarID", PlayerVehicles[playerid][slot][pCarID]);
			        SetPVarInt(i, "CarSeat", GetPlayerVehicleSeat(playerid));
				}
			}
			VehicleLocked[GetPlayerVehicleID(playerid)] = 0;
			UnlockVehicle(GetPlayerVehicleID(playerid));
			DestroyVehicle(GetPlayerVehicleID(playerid));
			PlayerVehicles[playerid][slot][pCarID] = CreateVehicle(PlayerVehicles[playerid][slot][pCarModel], x, y, z, angle, PlayerVehicles[playerid][slot][pCarColor1], PlayerVehicles[playerid][slot][pCarColor2], -1);
			PutPlayerInVehicle(playerid, PlayerVehicles[playerid][slot][pCarID], 0);
			foreach(Player, i)
			{
			    if (GetPVarInt(i, "CarID") == PlayerVehicles[playerid][slot][pCarID])
			    {
			        PutPlayerInVehicle(i, PlayerVehicles[playerid][slot][pCarID], GetPVarInt(i, "CarSeat"));
			        DeletePVar(i, "CarID");
			        DeletePVar(i, "CarSeat");
			    }
			}
			ModifyVehicle(playerid, slot);
			return 1;
		}
		return 0;
	}
	return -1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	if (VehicleLocked[vehicleid]) SetVehicleParamsForPlayer(vehicleid, forplayerid, 0, 1);
	else SetVehicleParamsForPlayer(vehicleid, forplayerid, 0, 0);
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
    foreach(Player, i)
	{
	    for (new j = 1; j < MAX_PLAYER_CARS + 1; j += 1)
	    {
			if (PlayerVehicles[i][j][pCarSpawned] && PlayerVehicles[i][j][pCarID] == vehicleid)
			{
			    PlayerVehicles[i][j][pCarColor1] = color1;
			    PlayerVehicles[i][j][pCarColor2] = color2;
			    break;
			}
		}
	}
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
    foreach(Player, i)
	{
	    for (new j = 1; j < MAX_PLAYER_CARS + 1; j += 1)
	    {
			if (PlayerVehicles[i][j][pCarSpawned] && PlayerVehicles[i][j][pCarID] == vehicleid)
			{
			    PlayerVehicles[i][j][pCarPaintjob] = paintjobid;
			    break;
			}
		}
	}
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
 	foreach(Player, i)
	{
	    for (new j = 1; j < MAX_PLAYER_CARS + 1; j += 1)
	    {
			if (PlayerVehicles[i][j][pCarSpawned] && PlayerVehicles[i][j][pCarID] == vehicleid)
			{
 	 	        switch (ReturnComponentSlot(componentid))
	  			{
				  	case 1: PlayerVehicles[i][j][pCarMod1] = componentid;
				  	case 2: PlayerVehicles[i][j][pCarMod2] = componentid;
				  	case 3: PlayerVehicles[i][j][pCarMod3] = componentid;
				  	case 4: PlayerVehicles[i][j][pCarMod4] = componentid;
				  	case 5: PlayerVehicles[i][j][pCarMod5] = componentid;
				  	case 6: PlayerVehicles[i][j][pCarMod6] = componentid;
				  	case 7: PlayerVehicles[i][j][pCarMod7] = componentid;
				  	case 8: PlayerVehicles[i][j][pCarMod8] = componentid;
				  	case 9: PlayerVehicles[i][j][pCarMod9] = componentid;
				  	case 10: PlayerVehicles[i][j][pCarMod10] = componentid;
				  	case 11: PlayerVehicles[i][j][pCarMod11] = componentid;
				  	case 12: PlayerVehicles[i][j][pCarMod12] = componentid;
				  	case 13: PlayerVehicles[i][j][pCarMod13] = componentid;
				  	case 14: PlayerVehicles[i][j][pCarMod14] = componentid;
				  	case 15: PlayerVehicles[i][j][pCarMod15] = componentid;
				  	case 16: PlayerVehicles[i][j][pCarMod16] = componentid;
				  	case 17: PlayerVehicles[i][j][pCarMod17] = componentid;
				}
				break;
			}
		}
	}
	return 1;
}

public OnFilterScriptInit()
{
	new query[142];
	DealerVehicleDatabase = db_open("DealershipVehicles.db");
	format(query, sizeof(query), "CREATE TABLE IF NOT EXISTS `DEALERCARS` (`vID`, `vModel`, `vX`, `vY`, `vZ`, `vRot`, `vForSale`, `vPrice`)");
	db_query(DealerVehicleDatabase, query);
	LoadDealershipVehicles();
	foreach(Player, i)
	{
	    VehicleConnect(i);
	}
	return 1;
}

public OnFilterScriptExit()
{
	SaveDealershipVehicles();
	db_close(DealerVehicleDatabase);
	foreach(Player, i)
	{
	    VehicleDisconnect(i);
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	VehicleConnect(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid)
{
    VehicleDisconnect(playerid);
	return 1;
}

stock VehicleDisconnect(playerid)
{
    for (new i = 1; i < MAX_PLAYER_CARS + 1; i += 1)
	{
	    if (PlayerVehicles[playerid][i][pCarOwned])
	    {
			SavePlayerVehicle(playerid, i);
			if (PlayerVehicles[playerid][i][pCarSpawned]) DestroyVehicle(PlayerVehicles[playerid][i][pCarID]);
		}
	}
	db_close(VehicleDatabase[playerid]);
	return 1;
}

stock VehicleConnect(playerid)
{
    new string[64];
	format(string, sizeof(string), "Vehicles/%s.db", PlayerName(playerid));
	VehicleDatabase[playerid] = db_open(string);
	CreateVehicleTables(playerid);
	for (new s = 1; s < MAX_PLAYER_CARS + 1; s += 1)
	{
		PlayerVehicles[playerid][s][pCarModel] = 0;
	    PlayerVehicles[playerid][s][pCarX] = 0.0;
	    PlayerVehicles[playerid][s][pCarY] = 0.0;
	    PlayerVehicles[playerid][s][pCarZ] = 0.0;
	    PlayerVehicles[playerid][s][pCarRot] = 0.0;
	    PlayerVehicles[playerid][s][pCarColor1] = 0;
	    PlayerVehicles[playerid][s][pCarColor2] = 0;
	    PlayerVehicles[playerid][s][pCarPaintjob] = -1;
	    PlayerVehicles[playerid][s][pCarMod1] = 0;
	    PlayerVehicles[playerid][s][pCarMod2] = 0;
	    PlayerVehicles[playerid][s][pCarMod3] = 0;
	    PlayerVehicles[playerid][s][pCarMod4] = 0;
	    PlayerVehicles[playerid][s][pCarMod5] = 0;
	    PlayerVehicles[playerid][s][pCarMod6] = 0;
	    PlayerVehicles[playerid][s][pCarMod7] = 0;
	    PlayerVehicles[playerid][s][pCarMod8] = 0;
	    PlayerVehicles[playerid][s][pCarMod9] = 0;
	    PlayerVehicles[playerid][s][pCarMod10] = 0;
	    PlayerVehicles[playerid][s][pCarMod11] = 0;
	    PlayerVehicles[playerid][s][pCarMod12] = 0;
	    PlayerVehicles[playerid][s][pCarMod13] = 0;
	    PlayerVehicles[playerid][s][pCarMod14] = 0;
	    PlayerVehicles[playerid][s][pCarMod15] = 0;
	    PlayerVehicles[playerid][s][pCarMod16] = 0;
	    PlayerVehicles[playerid][s][pCarMod17] = 0;
	    PlayerVehicles[playerid][s][pCarHasLock] = 0;
	    PlayerVehicles[playerid][s][pCarLocked] = 0;
	    PlayerVehicles[playerid][s][pCarTrunkCash] = 0;
	    PlayerVehicles[playerid][s][pCarTrunkGun1] = 0;
	    PlayerVehicles[playerid][s][pCarTrunkGun2] = 0;
	    PlayerVehicles[playerid][s][pCarTrunkGun3] = 0;
	    PlayerVehicles[playerid][s][pCarTrunkGun4] = 0;
	    PlayerVehicles[playerid][s][pCarTrunkAmmo1] = 0;
	    PlayerVehicles[playerid][s][pCarTrunkAmmo2] = 0;
	    PlayerVehicles[playerid][s][pCarTrunkAmmo3] = 0;
	    PlayerVehicles[playerid][s][pCarTrunkAmmo4] = 0;
	    PlayerVehicles[playerid][s][pCarSpawned] = 0;
	    PlayerVehicles[playerid][s][pCarOwned] = 0;
	    PlayerVehicles[playerid][s][pCarID] = 0;
	    VehicleListitem[playerid][s] = -1;
	}
	SetPVarInt(playerid, "CarOffer", INVALID_PLAYER_ID);
	LoadPlayerVehicles(playerid);
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	new string[256];
	if (newstate == PLAYER_STATE_DRIVER && DealershipVehicles[GetPlayerVehicleID(playerid)][vForSale])
	{
	    if (GetVehicleModel(GetPlayerVehicleID(playerid)) == DealershipVehicles[GetPlayerVehicleID(playerid)][vModel])
	    {
			format(string, sizeof(string), "{D5DEB3}This vehicle is FOR SALE!\n\nVehicle: {FFFFFF}%s{F5DEB3}\nCost: {FFFFFF}$%d{F5DEB3}\n\nWould you like to purchase this vehicle?", GetVehicleName(GetPlayerVehicleID(playerid)), DealershipVehicles[GetPlayerVehicleID(playerid)][vPrice]);
			ShowPlayerDialog(playerid, 9, DIALOG_STYLE_MSGBOX, "Vehicle Dealership", string, "Yes", "No");
			TogglePlayerControllable(playerid, 0);
		}
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	new string[128];
	if (dialogid == 9)
	{
	    if (!response)
	    {
			TogglePlayerControllable(playerid, 1);
			return RemovePlayerFromVehicle(playerid);
		}
		else
		{
			if (!IsPlayerInAnyVehicle(playerid))
			{
			    SendClientMessage(playerid, GREY, "You are not in a vehicle.");
			    TogglePlayerControllable(playerid, 1);
				return RemovePlayerFromVehicle(playerid);
			}
			if (!DealershipVehicles[GetPlayerVehicleID(playerid)][vForSale])
			{
			    SendClientMessage(playerid, GREY, "You are not in any vehicle that's for sale.");
			    TogglePlayerControllable(playerid, 1);
				return RemovePlayerFromVehicle(playerid);
			}
			if (GetPlayerMoney(playerid) < DealershipVehicles[GetPlayerVehicleID(playerid)][vPrice])
			{
			    SendClientMessage(playerid, GREY, "You cannot afford the vehicle.");
			    TogglePlayerControllable(playerid, 1);
				return RemovePlayerFromVehicle(playerid);
			}

			new
			    iModel = DealershipVehicles[GetPlayerVehicleID(playerid)][vModel],
			    Float:fAngle = DealershipVehicles[GetPlayerVehicleID(playerid)][vRot],
				Float:fX = DealershipVehicles[GetPlayerVehicleID(playerid)][vX],
				Float:fY = DealershipVehicles[GetPlayerVehicleID(playerid)][vY],
				Float:fZ = DealershipVehicles[GetPlayerVehicleID(playerid)][vZ];

            switch (iModel)
			{
				case 460, 464, 476, 511, 512, 513, 519, 520, 553, 577, 592, 593, 430, 446, 452, 453,
			 	454, 472, 473, 484, 493, 595, 417, 425, 447, 465, 469, 487, 488, 497, 501, 548, 563:
				{
                    fX = (fX + (24.0 * floatsin(-fAngle, degrees)));
					fY = (fY + (24.0 * floatcos(fAngle, degrees)));
				}
				default:
				{
                    fX = (fX + (6.0 * floatsin(-fAngle, degrees)));
					fY = (fY + (6.0 * floatcos(fAngle, degrees)));
				}
			}
			switch (CreatePlayerVehicle(playerid, iModel, fX, fY, fZ, fAngle))
			{
			    case -1:
			    {
	                SendClientMessage(playerid, GREY, "The vehicle could not be purchased.");
			    	TogglePlayerControllable(playerid, 1);
					return RemovePlayerFromVehicle(playerid);
				}
			    case 0:
			    {
			        SendClientMessage(playerid, GREY, "You already own the maximum amount of vehicles.");
				    TogglePlayerControllable(playerid, 1);
					return RemovePlayerFromVehicle(playerid);
				}
				case 1:
				{
					GivePlayerMoney(playerid, -DealershipVehicles[GetPlayerVehicleID(playerid)][vPrice]);
					format(string, sizeof(string), "You have purchased a %s for $%d, for more help regarding your purchase, type /carhelp.", GetVehicleName(GetPlayerVehicleID(playerid)), DealershipVehicles[GetPlayerVehicleID(playerid)][vPrice]);
					SendClientMessage(playerid, YELLOW, string);
					RemovePlayerFromVehicle(playerid);
					TogglePlayerControllable(playerid, 1);
					return 1;
				}
			}
		}
	}
	if (dialogid == 10 && response)
	{
	    for (new i = 1; i < MAX_PLAYER_CARS + 1; i += 1)
	    {
			if (VehicleListitem[playerid][i] == listitem)
			{
			    if (!PlayerVehicles[playerid][i][pCarOwned]) return SendClientMessage(playerid, GREY, "An error has occurred.");
				PlayerVehicles[playerid][i][pCarSpawned] = !PlayerVehicles[playerid][i][pCarSpawned];
				switch (PlayerVehicles[playerid][i][pCarSpawned])
				{
			        case 0:
					{
					    UnlockVehicle(PlayerVehicles[playerid][i][pCarID]);
					    DestroyVehicle(PlayerVehicles[playerid][i][pCarID]);
					    PlayerVehicles[playerid][i][pCarID] = 0;
					    format(string, sizeof(string), "You have despawned your %s in slot #%d.", GetVehicleNameByModel(PlayerVehicles[playerid][i][pCarModel]), i);
					    SendClientMessage(playerid, WHITE, string);
					}
					case 1:
					{
					    PlayerVehicles[playerid][i][pCarID] = CreateVehicle(PlayerVehicles[playerid][i][pCarModel], PlayerVehicles[playerid][i][pCarX], PlayerVehicles[playerid][i][pCarY], PlayerVehicles[playerid][i][pCarZ], PlayerVehicles[playerid][i][pCarRot], PlayerVehicles[playerid][i][pCarColor1], PlayerVehicles[playerid][i][pCarColor2], -1);
					    ModifyVehicle(playerid, i);
					    format(string, sizeof(string), "You have spawned your %s in slot #%d.", GetVehicleNameByModel(PlayerVehicles[playerid][i][pCarModel]), i);
					    SendClientMessage(playerid, WHITE, string);
					}
				}
				VehicleListitem[playerid][i] = -1;
				return 1;
			}
	    }
	}
	if (dialogid == 11 && response)
	{
	    for (new i = 1; i < MAX_PLAYER_CARS + 1; i += 1)
	    {
			if (VehicleListitem[playerid][i] == listitem)
			{
			    if (!PlayerVehicles[playerid][i][pCarOwned]) return SendClientMessage(playerid, GREY, "An error has occurred.");
				new iModel = PlayerVehicles[playerid][i][pCarModel];
				if (DeletePlayerVehicle(playerid, i))
				{
					format(string, sizeof(string), "You have deleted your %s in slot #%d.", GetVehicleNameByModel(iModel), i);
				    SendClientMessage(playerid, WHITE, string);
				}
				VehicleListitem[playerid][i] = -1;
				return 1;
			}
	    }
	}
	if (dialogid == 12 && response)
	{
	    for (new i = 1; i < MAX_PLAYER_CARS + 1; i += 1)
	    {
			if (VehicleListitem[playerid][i] == listitem)
			{
			    if (!PlayerVehicles[playerid][i][pCarOwned]) return SendClientMessage(playerid, GREY, "An error has occurred.");
				SetPVarInt(playerid, "UpgradingVehicle", i);
				ShowPlayerDialog(playerid, 13, DIALOG_STYLE_LIST, "Vehicle Upgrades", "Vehicle Lock ("#LOCK_PRICE")", "Upgrade", "Cancel");
				VehicleListitem[playerid][i] = -1;
				return 1;
			}
	    }
	}
	if (dialogid == 13)
	{
	    if (response)
	    {
			new slot = GetPVarInt(playerid, "UpgradingVehicle");
			if (!slot)
			    return SendClientMessage(playerid, GREY, "You must select a vehicle first.");

			if (!PlayerVehicles[playerid][slot][pCarOwned]) return SendClientMessage(playerid, GREY, "An error has occurred."), DeletePVar(playerid, "UpgradingVehicle");
			if (PlayerVehicles[playerid][slot][pCarHasLock]) return SendClientMessage(playerid, GREY, "This vehicle already has a lock installed."), DeletePVar(playerid, "UpgradingVehicle");

			if (GetPlayerMoney(playerid) >= LOCK_PRICE)
			{
			    GivePlayerMoney(playerid, -LOCK_PRICE);
				PlayerVehicles[playerid][slot][pCarHasLock] = 1;
				SendClientMessage(playerid, YELLOW, "You have purchased a lock for your vehicle. This costed you $"#LOCK_PRICE".");
				SendClientMessage(playerid, WHITE, "HINT: Type /lock to lock or unlock your vehicle.");
				DeletePVar(playerid, "UpgradingVehicle");
				return 1;
			}
			else
			{
			    SendClientMessage(playerid, GREY, "You cannot afford the lock.");
			    DeletePVar(playerid, "UpgradingVehicle");
		    }
		}
		else return DeletePVar(playerid, "UpgradingVehicle");
	}
	return 1;
}

CMD:dealervehicle(playerid, params[])
{
	if (IsPlayerAdmin(playerid))
	{
		new model, price, string[128];
		if (sscanf(params, "dd", model, price)) return SendClientMessage(playerid, GREY, "USAGE: /dealervehicle [model] [price]");
		if (model < 400 || model > 611) return SendClientMessage(playerid, GREY, "Invalid model.");
		new Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		
		new cdv = CreateDealershipVehicle(model, price, x, y, z, a);
		switch (cdv)
		{
	        case 0: return SendClientMessage(playerid, GREY, "The vehicle could not be created.");
	        case 1:
	        {
	            SetPlayerPos(playerid, x, y, z + 5);
				format(string, sizeof(string), "Dealership vehicle #%d created (model: %d | price: $%d).", cdv, model, price);
				SendClientMessage(playerid, GREY, string);
				SaveDealershipVehicles();
			}
		}
		return 1;
	}
	else SendClientMessage(playerid, GREY, "You cannot use this command since you're not a high enough administrator level.");
	return 1;
}

CMD:deletevehicle(playerid, params[])
{
    if (IsPlayerAdmin(playerid))
	{
		new vehicleid, string[128], iModel, iSQL;
		if (sscanf(params, "d", vehicleid)) return SendClientMessage(playerid, GREY, "USAGE: /deletevehicle [vehicleid]");
		if (!DealershipVehicles[vehicleid][vForSale]) return SendClientMessage(playerid, GREY, "That is not a dealership vehicle.");

		iModel = DealershipVehicles[vehicleid][vModel];
		iSQL = DealershipVehicles[vehicleid][vSQL_ID];
		if (DeleteDealershipVehicle(vehicleid))
		{
		    format(string, sizeof(string), "You have deleted dealership vehicle #%d (SQL ID: %d | Model: %s)", vehicleid, iSQL, GetVehicleNameByModel(iModel));
			SendClientMessage(playerid, WHITE, string);
			SaveDealershipVehicles();
		}
		return 1;
	}
	else SendClientMessage(playerid, GREY, "You cannot use this command since you're not a high enough administrator level.");
	return 1;
}

CMD:park(playerid, params[])
{
	if (!GetPlayerVehicleAmount(playerid)) return SendClientMessage(playerid, GREY, "You don't own any vehicles.");
	if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, GREY, "You are not in any vehicle.");
	if (!GetPlayerVehicleSlot(playerid)) return SendClientMessage(playerid, GREY, "You don't own this vehicle.");
	switch (ParkVehicle(playerid, GetPlayerVehicleSlot(playerid)))
	{
		case -1:
		{
		    SendClientMessage(playerid, GREY, "You are not in any vehicle.");
		}
	    case 0:
	    {
	        SendClientMessage(playerid, GREY, "You must be the driver.");
		}
		case 1:
		{
		    SendClientMessage(playerid, YELLOW, "You have successfully parked your vehicle.");
		}
	}
	return 1;
}

CMD:mycars(playerid, params[])
{
    if (!GetPlayerVehicleAmount(playerid))
		return SendClientMessage(playerid, GREY, "You don't own any vehicles.");

	new szString[128];
	new szStatus[12];
	new szCarString[128 * MAX_PLAYER_CARS];
	for (new i = 1; i < MAX_PLAYER_CARS + 1; i += 1)
	{
	    if (PlayerVehicles[playerid][i][pCarOwned] == 0) continue;
	    switch (PlayerVehicles[playerid][i][pCarSpawned])
	    {
	        case 0: szStatus = "Despawned", format(szString, sizeof(szString), "#%d - %s (Status: %s)\n", i, GetVehicleNameByModel(PlayerVehicles[playerid][i][pCarModel]), szStatus);
	        case 1: szStatus = "Spawned", format(szString, sizeof(szString), "#%d - %s (ID: %d - Status: %s)\n", i, GetVehicleNameByModel(PlayerVehicles[playerid][i][pCarModel]), PlayerVehicles[playerid][i][pCarID], szStatus);
	    }
		strcat(szCarString, szString);
	}
	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_LIST, "My Cars", szCarString, "Close", "");
	return 1;
}

CMD:spawncar(playerid, params[])
{
    if (!GetPlayerVehicleAmount(playerid))
		return SendClientMessage(playerid, GREY, "You don't own any vehicles.");

	new szString[128];
	new szStatus[12];
	new szCarString[128 * MAX_PLAYER_CARS];
	new iListitem = 0;
	for (new i = 1; i < MAX_PLAYER_CARS + 1; i += 1)
	{
	    if (PlayerVehicles[playerid][i][pCarOwned] == 0) continue;
	    switch (PlayerVehicles[playerid][i][pCarSpawned])
	    {
	        case 0: szStatus = "Despawned", format(szString, sizeof(szString), "#%d - %s (Status: %s)\n", i, GetVehicleNameByModel(PlayerVehicles[playerid][i][pCarModel]), szStatus);
	        case 1: szStatus = "Spawned", format(szString, sizeof(szString), "#%d - %s (ID: %d - Status: %s)\n", i, GetVehicleNameByModel(PlayerVehicles[playerid][i][pCarModel]), PlayerVehicles[playerid][i][pCarID], szStatus);
	    }
		strcat(szCarString, szString);
		
		VehicleListitem[playerid][i] = iListitem ++;
	}
	ShowPlayerDialog(playerid, 10, DIALOG_STYLE_LIST, "Spawn / Despawn Vehicle", szCarString, "Select", "Cancel");
	return 1;
}

CMD:deletecar(playerid, params[])
{
    if (!GetPlayerVehicleAmount(playerid))
		return SendClientMessage(playerid, GREY, "You don't own any vehicles.");

	new szString[128];
	new szStatus[12];
	new szCarString[128 * MAX_PLAYER_CARS];
	new iListitem = 0;
	for (new i = 1; i < MAX_PLAYER_CARS + 1; i += 1)
	{
	    if (PlayerVehicles[playerid][i][pCarOwned] == 0) continue;
	    switch (PlayerVehicles[playerid][i][pCarSpawned])
	    {
	        case 0: szStatus = "Despawned", format(szString, sizeof(szString), "#%d - %s (Status: %s)\n", i, GetVehicleNameByModel(PlayerVehicles[playerid][i][pCarModel]), szStatus);
	        case 1: szStatus = "Spawned", format(szString, sizeof(szString), "#%d - %s (ID: %d - Status: %s)\n", i, GetVehicleNameByModel(PlayerVehicles[playerid][i][pCarModel]), PlayerVehicles[playerid][i][pCarID], szStatus);
	    }
		strcat(szCarString, szString);

		VehicleListitem[playerid][i] = iListitem ++;
	}
	ShowPlayerDialog(playerid, 11, DIALOG_STYLE_LIST, "Delete Vehicle", szCarString, "Select", "Cancel");
	return 1;
}

CMD:upgradecar(playerid, params[])
{
    if (!GetPlayerVehicleAmount(playerid))
		return SendClientMessage(playerid, GREY, "You don't own any vehicles.");

	new szString[128];
	new szStatus[12];
	new szCarString[128 * MAX_PLAYER_CARS];
	new iListitem = 0;
	for (new i = 1; i < MAX_PLAYER_CARS + 1; i += 1)
	{
	    if (PlayerVehicles[playerid][i][pCarOwned] == 0) continue;
	    switch (PlayerVehicles[playerid][i][pCarSpawned])
	    {
	        case 0: szStatus = "Despawned", format(szString, sizeof(szString), "#%d - %s (Status: %s)\n", i, GetVehicleNameByModel(PlayerVehicles[playerid][i][pCarModel]), szStatus);
	        case 1: szStatus = "Spawned", format(szString, sizeof(szString), "#%d - %s (ID: %d - Status: %s)\n", i, GetVehicleNameByModel(PlayerVehicles[playerid][i][pCarModel]), PlayerVehicles[playerid][i][pCarID], szStatus);
	    }
		strcat(szCarString, szString);

		VehicleListitem[playerid][i] = iListitem ++;
	}
	ShowPlayerDialog(playerid, 12, DIALOG_STYLE_LIST, "Upgrade Vehicle", szCarString, "Select", "Cancel");
	return 1;
}

CMD:lock(playerid, params[])
{
    if (!GetPlayerVehicleAmount(playerid))
		return SendClientMessage(playerid, GREY, "You don't own any vehicles.");
		
	if (IsPlayerInAnyVehicle(playerid))
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
		if (!PlayerOwnsVehicle(playerid, vehicleid)) return SendClientMessage(playerid, GREY, "You don't own this vehicle.");
		if (PlayerVehicles[playerid][GetPlayerVehicleSlot(playerid)][pCarHasLock] == 0) return SendClientMessage(playerid, GREY, "This vehicle doesn't have a lock (/upgradecar to buy one).");
		VehicleLocked[vehicleid] = !VehicleLocked[vehicleid];
		switch (VehicleLocked[vehicleid])
		{
		    case 0:
		    {
		        UnlockVehicle(vehicleid);
		        PlayerVehicles[playerid][GetPlayerVehicleSlot(playerid)][pCarLocked] = 0;
				GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~w~Vehicle ~g~Unlocked", 3000, 3);
			}
			case 1:
			{
			    LockVehicle(vehicleid);
			    PlayerVehicles[playerid][GetPlayerVehicleSlot(playerid)][pCarLocked] = 1;
			    GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~w~Vehicle ~r~Locked", 3000, 3);
			}
		}
		return 1;
	}
	else
	{
	    new carcount;
	    new vehicleid = -1;
	    new slotid = -1;
		new Float:pos[3];
	    for (new i = 1; i < MAX_VEHICLES; i += 1)
	    {
			GetVehiclePos(i, pos[0], pos[1], pos[2]);
	        if (IsPlayerInRangeOfPoint(playerid, 3.5, pos[0], pos[1], pos[2]) && PlayerOwnsVehicle(playerid, i))
	        {
	            vehicleid = i;
	            carcount += 1;
	            break;
			}
		}
		if (vehicleid == -1 && !carcount) return SendClientMessage(playerid, GREY, "You are not near any vehicle that you've purchased.");
		if (carcount >= 2) return SendClientMessage(playerid, GREY, "There are too many vehicles in range.");
		else
		{
		    for (new i = 1; i < MAX_PLAYER_CARS + 1; i += 1)
		    {
		        if (PlayerVehicles[playerid][i][pCarID] == vehicleid)
		        {
		            slotid = i;
		            break;
				}
			}
			if (!slotid) return SendClientMessage(playerid, GREY, "You don't own this vehicle.");
			if (PlayerVehicles[playerid][slotid][pCarHasLock] == 0) return SendClientMessage(playerid, GREY, "This vehicle doesn't have a lock (/upgradecar to buy one).");
		    VehicleLocked[vehicleid] = !VehicleLocked[vehicleid];
			switch (VehicleLocked[vehicleid])
			{
			    case 0:
			    {
			        UnlockVehicle(vehicleid);
			        PlayerVehicles[playerid][slotid][pCarLocked] = 0;
					GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~w~Vehicle ~g~Unlocked", 3000, 3);
					PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
				}
				case 1:
				{
				    LockVehicle(vehicleid);
				    PlayerVehicles[playerid][slotid][pCarLocked] = 1;
				    GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~w~Vehicle ~r~Locked", 3000, 3);
				    PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
				}
			}
		}
	}
	return 1;
}

CMD:carhelp(playerid, params[])
{
	SendClientMessage(playerid, WHITE, "VEHICLE: /park, /mycars, /spawncar, /upgradecar, /deletecar, /lock, /sellcar.");
	SendClientMessage(playerid, WHITE, "VEHICLE: /trunkput, /trunktake, /trunkbalance.");
	return 1;
}

CMD:sellcar(playerid, params[])
{
	if (!GetPlayerVehicleAmount(playerid))
		return SendClientMessage(playerid, GREY, "You don't own any vehicles.");

	if (!IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, GREY, "You must be inside a vehicle.");
	    
	if (!PlayerOwnsVehicle(playerid, GetPlayerVehicleID(playerid)))
	    return SendClientMessage(playerid, GREY, "You don't own this vehicle.");
	    
	new userid, price, string[128];
	if (sscanf(params, "ud", userid, price))
	    return SendClientMessage(playerid, GREY, "USAGE: /sellcar [target] [price]");
	    
	if (!IsPlayerConnected(userid))
	    return SendClientMessage(playerid, GREY, "The specified player is not connected.");

	if (userid == playerid)
	    return SendClientMessage(playerid, GREY, "You can't sell a vehicle to yourself.");
	    
	if (!IsPlayerNearPlayer(playerid, userid, 7.0)) return SendClientMessage(playerid, GREY, "You are not near that player.");
	format(string, sizeof(string), "* %s wants to sell you their %s for $%d (type /acceptcar to accept).", PlayerName(playerid, false), GetVehicleName(GetPlayerVehicleID(playerid)), price);
	SendClientMessage(userid, LIGHTBLUE, string);

	format(string, sizeof(string), "* You've offered %s to buy your %s for $%d.", PlayerName(userid, false), GetVehicleName(GetPlayerVehicleID(playerid)), price);
	SendClientMessage(playerid, LIGHTBLUE, string);
	
	SetPVarInt(userid, "CarOffer", playerid);
	SetPVarInt(userid, "CarPrice", price);
	SetPVarInt(userid, "CarSlot", GetPlayerVehicleSlot(playerid));
	return 1;
}

stock RemovePlayerWeapon(playerid, weaponid)
{
	new weapons[12] = 0;
	new ammo[12] = 0;
	for (new i = 0; i < 13; i += 1)
	{
		new weapon, ammo2;
		GetPlayerWeaponData(playerid, i, weapon, ammo2);
		if ((weapon != weaponid) && (ammo2 > 0)) GetPlayerWeaponData(playerid, i, weapons[i], ammo[i]);
	}
	ResetPlayerWeapons(playerid);
	for (new i = 0; i < 13; i += 1)
	{
	    if(weapons[i] > 0 && ammo[i] != 0) GivePlayerWeapon(playerid, weapons[i], ammo[i]);
	}
	return 1;
}

stock GetWeaponNameEx(weaponid, weapon[], len)
{
	GetWeaponName(weaponid, weapon, len);
	if (weaponid == 0) format(weapon, 24, "None");
	if (weaponid == 18) format(weapon, 24, "Molotov");
	if (weaponid == 44) format(weapon, 24, "Nightvision Goggles");
	if (weaponid == 45) format(weapon, 24, "Infrared Goggles");
	return 1;
}

stock IsPlayerNearPlayer(playerid, targetid, Float:radius)
{
	if (IsPlayerConnected(playerid) && IsPlayerConnected(targetid))
	{
	    new Float:x, Float:y, Float:z;
	    GetPlayerPos(targetid, x, y, z);
	    if (IsPlayerInRangeOfPoint(playerid, radius, x, y, z)) return 1;
	}
	return 0;
}

stock IsPlayerNearVehicle(playerid, vehicleid, Float:radius)
{
	if (IsPlayerConnected(playerid))
	{
	    new
			Float:playerFloats[3],
			Float:vehicleFloats[3],
			Float:fCalculation;

	    GetPlayerPos(playerid, playerFloats[0], playerFloats[1], playerFloats[2]);
	    GetVehiclePos(vehicleid, vehicleFloats[0], vehicleFloats[1], vehicleFloats[2]);
	    fCalculation = (vehicleFloats[0] - playerFloats[0]) * (vehicleFloats[0] - playerFloats[0]) + (vehicleFloats[1] - playerFloats[1]) * (vehicleFloats[1] - playerFloats[1]) + (vehicleFloats[2] - playerFloats[2]) * (vehicleFloats[2] - playerFloats[2]);
	    if (fCalculation <= (radius * radius))
	    {
	        if (GetPlayerVirtualWorld(playerid) == GetVehicleVirtualWorld(vehicleid))
				return 1;
	    }
	}
	return 0;
}

CMD:acceptcar(playerid, params[])
{
	new string[128];
	if (GetPVarInt(playerid, "CarOffer") != INVALID_PLAYER_ID)
	{
	    new query[192];
        if (GetPVarInt(playerid, "CarOffer") != INVALID_PLAYER_ID && IsPlayerConnected(GetPVarInt(playerid, "CarOffer")))
		{
		    if (IsPlayerNearPlayer(playerid, GetPVarInt(playerid, "CarOffer"), 7.0))
			{
				if (GetPlayerMoney(playerid) >= GetPVarInt(playerid, "CarPrice"))
				{
                    if (GetPlayerVehicleAmount(playerid) < MAX_PLAYER_CARS)
                    {
						new slot = GetPVarInt(playerid, "CarSlot");
						if (PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarOwned] && PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarSpawned])
						{
						    new slotid = -1;
							for (new i = 1; i < MAX_PLAYER_CARS + 1; i += 1)
							{
							    if (!PlayerVehicles[playerid][i][pCarOwned])
								{
								    slotid = i;
								    break;
								}
							}
							if (slotid == -1) return SendClientMessage(playerid, GREY, "You already own the maximum amount of vehicles.");

						    GivePlayerMoney(playerid, -GetPVarInt(playerid, "CarPrice"));
					 		GivePlayerMoney(GetPVarInt(playerid, "CarOffer"), GetPVarInt(playerid, "CarPrice"));

			                format(string, sizeof(string), "* %s has accepted the offer; you've sold them your %s for $%d.", PlayerName(playerid, false), GetVehicleNameByModel(PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarModel]), GetPVarInt(playerid, "CarPrice"));
							SendClientMessage(GetPVarInt(playerid, "CarOffer"), LIGHTBLUE, string);

							format(string, sizeof(string), "* You have bought a %s for $%d from %s.", GetVehicleNameByModel(PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarModel]), GetPVarInt(playerid, "CarPrice"), PlayerName(GetPVarInt(playerid, "CarOffer"), false));
							SendClientMessage(playerid, LIGHTBLUE, string);
						
                            PlayerVehicles[playerid][slotid][pCarModel] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarModel];
							PlayerVehicles[playerid][slotid][pCarX] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarX];
							PlayerVehicles[playerid][slotid][pCarY] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarY];
							PlayerVehicles[playerid][slotid][pCarZ] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarZ];
							PlayerVehicles[playerid][slotid][pCarRot] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarRot];
							PlayerVehicles[playerid][slotid][pCarColor1] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarColor1];
							PlayerVehicles[playerid][slotid][pCarColor2] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarColor2];
							PlayerVehicles[playerid][slotid][pCarPaintjob] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarPaintjob];
							PlayerVehicles[playerid][slotid][pCarMod1] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod1];
							PlayerVehicles[playerid][slotid][pCarMod2] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod2];
							PlayerVehicles[playerid][slotid][pCarMod3] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod3];
							PlayerVehicles[playerid][slotid][pCarMod4] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod4];
							PlayerVehicles[playerid][slotid][pCarMod5] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod5];
							PlayerVehicles[playerid][slotid][pCarMod6] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod6];
							PlayerVehicles[playerid][slotid][pCarMod7] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod7];
							PlayerVehicles[playerid][slotid][pCarMod8] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod8];
							PlayerVehicles[playerid][slotid][pCarMod9] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod9];
							PlayerVehicles[playerid][slotid][pCarMod10] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod10];
							PlayerVehicles[playerid][slotid][pCarMod11] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod11];
							PlayerVehicles[playerid][slotid][pCarMod12] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod12];
							PlayerVehicles[playerid][slotid][pCarMod13] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod13];
							PlayerVehicles[playerid][slotid][pCarMod14] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod14];
							PlayerVehicles[playerid][slotid][pCarMod15] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod15];
							PlayerVehicles[playerid][slotid][pCarMod16] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod16];
							PlayerVehicles[playerid][slotid][pCarMod17] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod17];
							PlayerVehicles[playerid][slotid][pCarHasLock] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarHasLock];
							PlayerVehicles[playerid][slotid][pCarLocked] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarLocked];
							PlayerVehicles[playerid][slotid][pCarTrunkCash] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarTrunkCash];
							PlayerVehicles[playerid][slotid][pCarTrunkGun1] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarTrunkGun1];
							PlayerVehicles[playerid][slotid][pCarTrunkGun2] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarTrunkGun2];
							PlayerVehicles[playerid][slotid][pCarTrunkGun3] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarTrunkGun3];
							PlayerVehicles[playerid][slotid][pCarTrunkGun4] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarTrunkGun4];
							PlayerVehicles[playerid][slotid][pCarTrunkAmmo1] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarTrunkAmmo1];
							PlayerVehicles[playerid][slotid][pCarTrunkAmmo2] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarTrunkAmmo2];
							PlayerVehicles[playerid][slotid][pCarTrunkAmmo3] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarTrunkAmmo3];
							PlayerVehicles[playerid][slotid][pCarTrunkAmmo4] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarTrunkAmmo4];
							PlayerVehicles[playerid][slotid][pCarSpawned] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarSpawned];
							PlayerVehicles[playerid][slotid][pCarOwned] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarOwned];
							PlayerVehicles[playerid][slotid][pCarID] = PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarID];

                            format(query, sizeof(query), "DELETE FROM `VEHICLES` WHERE `Name` = '%s' AND `Slot` = '%d'", PlayerName(GetPVarInt(playerid, "CarOffer")), slot);
							db_query(VehicleDatabase[GetPVarInt(playerid, "CarOffer")], query);
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarModel] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarX] = 0.0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarY] = 0.0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarZ] = 0.0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarRot] = 0.0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarColor1] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarColor2] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarPaintjob] = -1;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod1] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod2] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod3] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod4] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod5] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod6] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod7] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod8] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod9] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod10] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod11] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod12] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod13] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod14] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod15] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod16] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarMod17] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarHasLock] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarLocked] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarTrunkCash] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarTrunkGun1] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarTrunkGun2] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarTrunkGun3] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarTrunkGun4] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarTrunkAmmo1] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarTrunkAmmo2] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarTrunkAmmo3] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarTrunkAmmo4] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarSpawned] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarOwned] = 0;
							PlayerVehicles[GetPVarInt(playerid, "CarOffer")][slot][pCarID] = 0;
							
							SetPVarInt(playerid, "CarOffer", INVALID_PLAYER_ID);
							DeletePVar(playerid, "CarPrice");
							DeletePVar(playerid, "CarSlot");
							return 1;
						}
                    }
                    else return SendClientMessage(playerid, GREY, "You already own the maximum amount of vehicles.");
				}
				else return SendClientMessage(playerid, GREY, "You can't afford that.");
			}
			else return SendClientMessage(playerid, GREY, "You are not near the player who offered you the car.");
		}
		else return SendClientMessage(playerid, GREY, "Nobody offered you a car.");
	}
	return 1;
}

CMD:trunkput(playerid, params[])
{
	new carcount;
	new slotid = -1;
	new string[128];
	if (IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, GREY, "You cannot use this command while inside a vehicle.");
	for (new i = 1; i < MAX_PLAYER_CARS + 1; i += 1)
	{
	    if (!PlayerVehicles[playerid][i][pCarOwned]) continue;
	    if (!PlayerVehicles[playerid][i][pCarSpawned]) continue;
	    if (IsPlayerNearVehicle(playerid, PlayerVehicles[playerid][i][pCarID], 3.5))
	    {
	        slotid = i;
	        carcount += 1;
		}
	}
	if (slotid == -1 && !carcount)
	    return SendClientMessage(playerid, GREY, "You are not near any vehicle that you've purchased.");

	if (carcount >= 2)
	    return SendClientMessage(playerid, GREY, "There are too many vehicles in range.");

	new name[24], value;
	if (sscanf(params, "sd", name, value)) return SendClientMessage(playerid, GREY, "USAGE: /trunkput [name] [value]"), SendClientMessage(playerid, GREY, "Available names: cash, weapon");
	if (strlen(name) > 22) return 1;
	if (strcmp(name, "cash", true) == 0)
	{
	    if (GetPlayerMoney(playerid) <= 0)
	        return SendClientMessage(playerid, GREY, "You don't have any money.");

		if (value > GetPlayerMoney(playerid) || value < 1)
		    return SendClientMessage(playerid, GREY, "You don't have that much.");

		PlayerVehicles[playerid][slotid][pCarTrunkCash] += value;
	    GivePlayerMoney(playerid, -value);
	    format(string, sizeof(string), "You have stored $%d into your vehicle.", value);
	    SendClientMessage(playerid, WHITE, string);
		return 1;
	}
	if (strcmp(name, "weapon", true) == 0)
	{
	    if (!GetPlayerWeapon(playerid))
	        return SendClientMessage(playerid, GREY, "You must equip the weapon you're storing.");

		if (value < 1 || value > 4) return SendClientMessage(playerid, GREY, "Invalid slot. Slots range from 1-4.");
		if (value == 1 && PlayerVehicles[playerid][slotid][pCarTrunkGun1]) return SendClientMessage(playerid, GREY, "You already have a weapon in that slot.");
		if (value == 2 && PlayerVehicles[playerid][slotid][pCarTrunkGun2]) return SendClientMessage(playerid, GREY, "You already have a weapon in that slot.");
		if (value == 3 && PlayerVehicles[playerid][slotid][pCarTrunkGun3]) return SendClientMessage(playerid, GREY, "You already have a weapon in that slot.");
		if (value == 4 && PlayerVehicles[playerid][slotid][pCarTrunkGun4]) return SendClientMessage(playerid, GREY, "You already have a weapon in that slot.");

		new weapon[24];
		GetWeaponNameEx(GetPlayerWeapon(playerid), weapon, 24);

		switch (value)
		{
			case 1: { PlayerVehicles[playerid][slotid][pCarTrunkGun1] = GetPlayerWeapon(playerid); PlayerVehicles[playerid][slotid][pCarTrunkAmmo1] = GetPlayerAmmo(playerid); }
			case 2: { PlayerVehicles[playerid][slotid][pCarTrunkGun2] = GetPlayerWeapon(playerid); PlayerVehicles[playerid][slotid][pCarTrunkAmmo2] = GetPlayerAmmo(playerid); }
			case 3: { PlayerVehicles[playerid][slotid][pCarTrunkGun3] = GetPlayerWeapon(playerid); PlayerVehicles[playerid][slotid][pCarTrunkAmmo3] = GetPlayerAmmo(playerid); }
			case 4: { PlayerVehicles[playerid][slotid][pCarTrunkGun4] = GetPlayerWeapon(playerid); PlayerVehicles[playerid][slotid][pCarTrunkAmmo4] = GetPlayerAmmo(playerid); }
		}
		RemovePlayerWeapon(playerid, GetPlayerWeapon(playerid));
	    format(string, sizeof(string), "You have stored a %s into slot %d of your vehicle.", weapon, value);
	    SendClientMessage(playerid, WHITE, string);
		return 1;
	}
	return 1;
}

CMD:trunktake(playerid, params[])
{
	new carcount;
	new slotid = -1;
	new string[128];
	if (IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, GREY, "You cannot use this command while inside a vehicle.");
	for (new i = 1; i < MAX_PLAYER_CARS + 1; i += 1)
	{
	    if (!PlayerVehicles[playerid][i][pCarOwned]) continue;
	    if (!PlayerVehicles[playerid][i][pCarSpawned]) continue;
	    if (IsPlayerNearVehicle(playerid, PlayerVehicles[playerid][i][pCarID], 3.5))
	    {
	        slotid = i;
	        carcount += 1;
		}
	}
	if (slotid == -1 && !carcount)
	    return SendClientMessage(playerid, GREY, "You are not near any vehicle that you've purchased.");

	if (carcount >= 2)
	    return SendClientMessage(playerid, GREY, "There are too many vehicles in range.");

	new name[24], value;
	if (sscanf(params, "sd", name, value)) return SendClientMessage(playerid, GREY, "USAGE: /trunktake [name] [value]"), SendClientMessage(playerid, GREY, "Available names: cash, weapon");
	if (strlen(name) > 22) return 1;
	if (strcmp(name, "cash", true) == 0)
	{
	    if (PlayerVehicles[playerid][slotid][pCarTrunkCash] <= 0)
	        return SendClientMessage(playerid, GREY, "You don't have any money in your trunk.");

		if (value > PlayerVehicles[playerid][slotid][pCarTrunkCash] || value < 1)
		    return SendClientMessage(playerid, GREY, "You don't have that much money in your trunk.");

		PlayerVehicles[playerid][slotid][pCarTrunkCash] -= value;
	    GivePlayerMoney(playerid, value);
	    format(string, sizeof(string), "You have taken $%d from your vehicle.", value);
	    SendClientMessage(playerid, WHITE, string);
		return 1;
	}
	if (strcmp(name, "weapon", true) == 0)
	{
	    new weaponid, ammo;
		if (value < 1 || value > 4) return SendClientMessage(playerid, GREY, "Invalid slot. Slots range from 1-4.");
		switch (value)
		{
			case 1: { weaponid = PlayerVehicles[playerid][slotid][pCarTrunkGun1]; ammo = PlayerVehicles[playerid][slotid][pCarTrunkAmmo1]; }
			case 2: { weaponid = PlayerVehicles[playerid][slotid][pCarTrunkGun2]; ammo = PlayerVehicles[playerid][slotid][pCarTrunkAmmo2]; }
			case 3: { weaponid = PlayerVehicles[playerid][slotid][pCarTrunkGun3]; ammo = PlayerVehicles[playerid][slotid][pCarTrunkAmmo3]; }
			case 4: { weaponid = PlayerVehicles[playerid][slotid][pCarTrunkGun4]; ammo = PlayerVehicles[playerid][slotid][pCarTrunkAmmo4]; }
		}
		if (!weaponid) return SendClientMessage(playerid, GREY, "You don't have any weapon in that slot.");

		new weapon[24];
		GetWeaponNameEx(weaponid, weapon, 24);
		if (value == 1) PlayerVehicles[playerid][slotid][pCarTrunkGun1] = 0, PlayerVehicles[playerid][slotid][pCarTrunkAmmo1] = 0;
		if (value == 2) PlayerVehicles[playerid][slotid][pCarTrunkGun2] = 0, PlayerVehicles[playerid][slotid][pCarTrunkAmmo2] = 0;
		if (value == 3) PlayerVehicles[playerid][slotid][pCarTrunkGun3] = 0, PlayerVehicles[playerid][slotid][pCarTrunkAmmo3] = 0;
		if (value == 4) PlayerVehicles[playerid][slotid][pCarTrunkGun4] = 0, PlayerVehicles[playerid][slotid][pCarTrunkAmmo4] = 0;

        GivePlayerWeapon(playerid, weaponid, ammo);
	    format(string, sizeof(string), "You have taken a %s from slot %d of your vehicle.", weapon, value);
	    SendClientMessage(playerid, WHITE, string);
		return 1;
	}
	return 1;
}

CMD:trunkbalance(playerid, params[])
{
    new carcount;
	new slotid = -1;
	new string[128];
	if (IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, GREY, "You cannot use this command while inside a vehicle.");
	for (new i = 1; i < MAX_PLAYER_CARS + 1; i += 1)
	{
	    if (!PlayerVehicles[playerid][i][pCarOwned]) continue;
	    if (!PlayerVehicles[playerid][i][pCarSpawned]) continue;
	    if (IsPlayerNearVehicle(playerid, PlayerVehicles[playerid][i][pCarID], 3.5))
	    {
	        slotid = i;
	        carcount += 1;
		}
	}
	if (slotid == -1 && !carcount)
	    return SendClientMessage(playerid, GREY, "You are not near any vehicle that you've purchased.");

	if (carcount >= 2)
	    return SendClientMessage(playerid, GREY, "There are too many vehicles in range.");

	new weapon1[24];
	new weapon2[24];
	new weapon3[24];
	new weapon4[24];

	GetWeaponNameEx(PlayerVehicles[playerid][slotid][pCarTrunkGun1], weapon1, 24);
	GetWeaponNameEx(PlayerVehicles[playerid][slotid][pCarTrunkGun2], weapon2, 24);
	GetWeaponNameEx(PlayerVehicles[playerid][slotid][pCarTrunkGun3], weapon3, 24);
	GetWeaponNameEx(PlayerVehicles[playerid][slotid][pCarTrunkGun4], weapon4, 24);

	SendClientMessage(playerid, GREEN, "_________________________________");
	SendClientMessage(playerid, WHITE, "** Trunk Balance **");
	format(string, sizeof(string), "Cash: $%d", PlayerVehicles[playerid][slotid][pCarTrunkCash]);
	SendClientMessage(playerid, WHITE, string);
	format(string, sizeof(string), "Weapon 1: %s | Ammo: %d", weapon1, PlayerVehicles[playerid][slotid][pCarTrunkAmmo1]);
	SendClientMessage(playerid, WHITE, string);
	format(string, sizeof(string), "Weapon 2: %s | Ammo: %d", weapon2, PlayerVehicles[playerid][slotid][pCarTrunkAmmo2]);
	SendClientMessage(playerid, WHITE, string);
	format(string, sizeof(string), "Weapon 3: %s | Ammo: %d", weapon3, PlayerVehicles[playerid][slotid][pCarTrunkAmmo3]);
	SendClientMessage(playerid, WHITE, string);
	format(string, sizeof(string), "Weapon 4: %s | Ammo: %d", weapon4, PlayerVehicles[playerid][slotid][pCarTrunkAmmo4]);
	SendClientMessage(playerid, WHITE, string);
	SendClientMessage(playerid, GREEN, "_________________________________");
	return 1;
}
