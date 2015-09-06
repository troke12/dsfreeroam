
#define FILTERSCRIPT

#include <a_samp>

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Car Spawner Menu by Yuri was loaded");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
    print("\n--------------------------------------");
	print(" Car Spawner Menu by Yuri was Unloaded");
	print("--------------------------------------\n");
	return 1;
}
#endif
public OnPlayerConnect(playerid)
{
	SendClientMessage(playerid,0xFFFF00AA," Use /carmenu for a list of all cars.");
	return 1;
}
public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/carmenu", cmdtext, true, 10) == 0)
	{
		new allvehicles[] = "1\tAirplanes\n2\tHelicopters\n3\tBikes\n4\tConvertibles\n5\tIndustrial\n6\tLowriders\n7\tOffRoad\n8\tPublic Service Vehicles\n9\tSaloons\n10\tSport Vehicles\n11\tStation Wagons\n12\tBoats\n13\tUnique Vehicles\n14\tRC Vehicles\n15\tTrailers";
	   	ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST," Vehicles: || Scroll Down for more",allvehicles,"Select","Cancel");
		return 1;
	}
	return 0;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    new Float: X, Float: Y, Float: Z;
    GetPlayerPos(playerid,X,Y,Z);
	if(dialogid == 2)
	{
		if(response)
		{
			if(listitem == 0)
			{
			    new allvehicles[] = "1\tAndromada\n2\tAT-400\n3\tBeagle\n4\tCropduster\n5\tDodo\n6\tHydra\n7\tNevada\n8\tRustler\n9\tShamal\n10\tSkimmer\n11\tStunt Plane";
	    		ShowPlayerDialog(playerid,3,DIALOG_STYLE_LIST,"Airplanes: || Scroll Down for more",allvehicles,"Select","Cancel");
	    	}
	    	else if(listitem == 1)
			{
			    new allvehicles[] = "1\tCargobob\n2\tHunter\n3\tLeviathan\n4\tMaverick\n5\tNews Maverick\n6\tPolice Maverick\n7\tRaindance\n8\tSeasparrow\n9\tSparrow";
	    		ShowPlayerDialog(playerid,4,DIALOG_STYLE_LIST,"Helicopters: || Scroll Down for more",allvehicles,"Select","Cancel");
			}
			else if(listitem == 2)
			{
			    new allvehicles[] = "1\tBF-400\n2\tBike\n3\tBMX\n4\tFaggio\n5\tFCR-900\n6\tFreeway\n7\tMountain Bike\n8\tNRG-500\n9\tPCJ-600\n10\tPizzaBoy\n11\tQuad\n12\tSanchez\n13\tWayfarer";
	    		ShowPlayerDialog(playerid,5,DIALOG_STYLE_LIST,"Bikes: || Scroll Down for more",allvehicles,"Select","Cancel");
			}
			else if(listitem == 3)
			{
			    new allvehicles[] = "1\tComet\n2\tFeltzer\n3\tStallion\n4\tWindsor";
	    		ShowPlayerDialog(playerid,6,DIALOG_STYLE_LIST,"Convertibles:",allvehicles,"Select","Cancel");
			}
			else if(listitem == 4)
			{
			    new allvehicles[] = "1\tBenson\n2\tBobcat\n3\tBurrito\n4\tBoxville\n5\tBoxburg\n6\tCement Truck\n7\tDFT-300\n8\tFlatbed\n9\tLinerunner\n10\tMule\n11\tNews Van\n12\tPacker\n13\tPetrol Tanker\n14\tPicador\n15\tPony\n16\tRoad Train\n17\tRumpo\n18\tSadler\n19\tSadler Shit( Ghost Car )\n20\tTopfun\n21\tTractor\n22\tTrashmaster\n23\tUitlity Van\n24\tWalton\n25\tYankee\n26\tYosemite";
	    		ShowPlayerDialog(playerid,7,DIALOG_STYLE_LIST,"Industrial Vehicles:",allvehicles,"Select","Cancel");
			}
			else if(listitem == 5)
			{
			    new allvehicles[] = "1\tBlade\n2\tBroadway\n3\tRemington\n4\tSavanna\n5\tSlamvan\n6\tTahoma\n7\tTornado\n8\tVoodoo";
	    		ShowPlayerDialog(playerid,8,DIALOG_STYLE_LIST,"Lowriders:",allvehicles,"Select","Cancel");
			}
			else if(listitem == 6)
			{
			    new allvehicles[] = "1\tBandito\n2\tBF Injection\n3\tDune\n4\tHuntley\n5\tLandstalker\n6\tMesa\n7\tMonster Truck\n8\tMonster Truck 'A'\n9\tMonster Truck 'B'\n10\tPatriot\n11\tRancher 'A'\n12\tRancher 'B'\n13\tSandking";
	    		ShowPlayerDialog(playerid,9,DIALOG_STYLE_LIST,"Off Road Vehicles:",allvehicles,"Select","Cancel");
			}
			else if(listitem == 7)
			{
			    new allvehicles[] = "1\tAmbulance\n2\tBarracks\n3\tBus\n4\tCabbie\n5\tCoach\n6\tHPV-1000 ( Cop Bike )\n7\tEnforcer\n8\tF.B.I Rancher\n9\tF.B.I Truck\n10\tFiretruck\n11\tFireTruck LA\n12\tPolice Car ( LSPD )\n13\tPolice Car ( LVPD )\n14\tPolice Car ( SFPD )\n15\tRanger\n16\tS.W.A.T\n17\tTaxi\n18\n18Rhino";
	    		ShowPlayerDialog(playerid,10,DIALOG_STYLE_LIST,"Public Service Vehicles:",allvehicles,"Select","Cancel");
			}
			else if(listitem == 8)
			{
			    new allvehicles[] = "1\tAdmiral\n2\tBloodring Banger\n3\tBravura\n4\tBuccaneer\n5\tCadrona\n6\tClover\n7\tElegant\n8\tElegy\n9\tEmperor\n10\tEsperanto\n11\tFortune\n12\tGlendale Shit ( Ghost Car )\n13\tGlendale\n14\tGreenwood\n15\tHermes\n16\tIntruder\n17\tMajestic\n18\tMananal\n19\tMerit\n20\tNebula\n21\tOceanic\n22\tPremier\n23\tPrevion\n24\tPrimo\n25\tSentinel\n26\tStafford\n27\tSultan \n28\tSunrise\n29\tTampa\n30\tVicent\n31\tVirgo\n32\tWillard\n33\tWashington";
	    		ShowPlayerDialog(playerid,11,DIALOG_STYLE_LIST,"Saloons Vehicles:",allvehicles,"Select","Cancel");
			}
			else if(listitem == 9)
			{
			    new allvehicles[] = "1\tAlpha\n2\tBanshee\n3\tBlista Compact\n4\tBuffalo\n5\tBullet\n6\tCheetah\n7\tClub\n8\tEuros\n9\tFlash\n10\tHotring Racer 'A'\n11\tHotring Racer 'B'\n12\tHotring Racer 'C'\n13\tInfernus\n14\tJester\n15\tPhoenix\n16\tSabre\n17\tSuper GT\n18\tTurismo\n19\tUranus\n20\tZR-350";
	    		ShowPlayerDialog(playerid,12,DIALOG_STYLE_LIST,"Sport Vehicles:",allvehicles,"Select","Cancel");
			}
			else if(listitem == 10)
			{
			    new allvehicles[] = "1\tMoonbeam\n2\tPerenniel\n3\tRegina\n4\tSolair\n5\tStratum";
	    		ShowPlayerDialog(playerid,13,DIALOG_STYLE_LIST,"Station Wagons Vehicles:",allvehicles,"Select","Cancel");
			}
			else if(listitem == 11)
			{
			    new allvehicles[] = "1\tCoastguard\n2\tDinghy\n3\tJetmax\n4\tLaunch\n5\tMarquis\n6\tPredator\n7\tReefer\n8\tSpeeder\n9\tSquallo\n10\tTropic";
	    		ShowPlayerDialog(playerid,14,DIALOG_STYLE_LIST,"Boats:",allvehicles,"Select","Cancel");
			}
			else if(listitem == 12)
			{
			    new allvehicles[] = "1\tBaggage\n2\tCaddy\n3\tCamper 'A'\n4\tCamper 'B'\n5\tCobine Harvester\n6\tDozer\n7\tDumper\n8\tForklift\n9\tHotknife\n10\tHustler\n11\tHotdog\n12\tKart\n13\tMower\n14\tMr. Whoopee\n15\tRomero\n16\tSecuricar\n17\tStretch\n18\tSweeper\n19\tTowtruck\n20\tTug\n21\tVortex";
	    		ShowPlayerDialog(playerid,15,DIALOG_STYLE_LIST,"Unique Vehicles:",allvehicles,"Select","Cancel");
			}
			else if(listitem == 13)
			{
			    new allvehicles[] = "1\tRC Bandit\n2\tRC Baron\n3\tRC Raider'\n4\tRC Goblin'\n5\tRC Tiger\n6\tRC Cam";
	    		ShowPlayerDialog(playerid,16,DIALOG_STYLE_LIST,"RC Vehicles:",allvehicles,"Select","Cancel");
			}
			else if(listitem == 14)
			{
			    new allvehicles[] = "1\tArticle Trailer\n2\tArticle Trailer 2\n3\tArticle Trailer 3'\n4\tBaggage Trailer 'A''\n5\tBaggage Trailer 'B'\n6\tFarm Trailer\n7\tFreight Frat Trailer(Train)\n8\tFreight Box Trailer(Train)\n9\tPetrol Trailer\n10\tStreak Trailer(Train)\n11\tStairs Trailer\n12\tUitlity Trailer";
	    		ShowPlayerDialog(playerid,17,DIALOG_STYLE_LIST,"Trailers Vehicles:",allvehicles,"Select","Cancel");
			}
		}
	}
	else if(dialogid == 3)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(592,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 1)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(577,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 2)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(511,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 3)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(512,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 4)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(593,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 5)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(520,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 6)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(553,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 7)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(476,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 8)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(510,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 9)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(460,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 10)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(513,X,Y,Z,0,-1,-1,-1),0);
			}
		}
		else
		{
		    new allvehicles[] = "1\tAirplanes\n2\tHelicopters\n3\tBikes\n4\tConvertibles\n5\tIndustrial\n6\tLowriders\n7\tOffRoad\n8\tPublic Service Vehicles\n9\tSaloons\n10\tSport Vehicles\n11\tStation Wagons\n12\tBoats\n13\tUnique Vehicles\n14\tRC Vehicles\n15\tTrailers";
	   		ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST," Vehicles: || Scroll Down for more",allvehicles,"Select","Cancel");
		}
	}
	else if(dialogid == 4)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(548,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 1)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(425,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 2)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(417,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 3)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(487,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 4)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(488,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 5)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(497,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 6)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(563,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 7)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(447,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 8)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(469,X,Y,Z,0,-1,-1,-1),0);
			}
		}
		else
		{
		    new allvehicles[] = "1\tAirplanes\n2\tHelicopters\n3\tBikes\n4\tConvertibles\n5\tIndustrial\n6\tLowriders\n7\tOffRoad\n8\tPublic Service Vehicles\n9\tSaloons\n10\tSport Vehicles\n11\tStation Wagons\n12\tBoats\n13\tUnique Vehicles\n14\tRC Vehicles\n15\tTrailers";
	   		ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST," Vehicles: || Scroll Down for more",allvehicles,"Select","Cancel");
		}
	}
	else if(dialogid == 5)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(581,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 1)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(509,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 2)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(481,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 3)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(462,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 4)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(521,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 5)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(463,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 6)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(510,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 7)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(522,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 8)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(461,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 9)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(448,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 10)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(471,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 11)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(468,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 12)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(586,X,Y,Z,0,-1,-1,-1),0);
			}
		}
		else
		{
		    new allvehicles[] = "1\tAirplanes\n2\tHelicopters\n3\tBikes\n4\tConvertibles\n5\tIndustrial\n6\tLowriders\n7\tOffRoad\n8\tPublic Service Vehicles\n9\tSaloons\n10\tSport Vehicles\n11\tStation Wagons\n12\tBoats\n13\tUnique Vehicles\n14\tRC Vehicles\n15\tTrailers";
	   		ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST," Vehicles: || Scroll Down for more",allvehicles,"Select","Cancel");
		}
	}
	else if(dialogid == 6)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(480,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 1)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(533,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 2)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(439,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 3)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(555,X,Y,Z,0,-1,-1,-1),0);
			}
		}
		else
		{
		    new allvehicles[] = "1\tAirplanes\n2\tHelicopters\n3\tBikes\n4\tConvertibles\n5\tIndustrial\n6\tLowriders\n7\tOffRoad\n8\tPublic Service Vehicles\n9\tSaloons\n10\tSport Vehicles\n11\tStation Wagons\n12\tBoats\n13\tUnique Vehicles\n14\tRC Vehicles\n15\tTrailers";
	   		ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST," Vehicles: || Scroll Down for more",allvehicles,"Select","Cancel");
		}
	}
	else if(dialogid == 7)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(499,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 1)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(422,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 2)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(482,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 3)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(498,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 4)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(609,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 5)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(524,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 6)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(578,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 7)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(455,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 8)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(403,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 9)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(414,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 10)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(582,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 11)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(443,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 12)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(514,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 13)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(600,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 14)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(413,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 15)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(515,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 16)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(440,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 17)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(543,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 18)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(605,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 19)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(459,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 20)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(531,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 21)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(408,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 22)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(552,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 23)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(478,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 24)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(556,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 25)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(554,X,Y,Z,0,-1,-1,-1),0);
			}
		}
		else
		{
		    new allvehicles[] = "1\tAirplanes\n2\tHelicopters\n3\tBikes\n4\tConvertibles\n5\tIndustrial\n6\tLowriders\n7\tOffRoad\n8\tPublic Service Vehicles\n9\tSaloons\n10\tSport Vehicles\n11\tStation Wagons\n12\tBoats\n13\tUnique Vehicles\n14\tRC Vehicles\n15\tTrailers";
	   		ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST," Vehicles: || Scroll Down for more",allvehicles,"Select","Cancel");
		}
	}
	else if(dialogid == 8)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(536,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 1)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(575,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 2)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(534,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 3)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(567,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 4)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(535,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 5)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(566,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 6)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(576,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 7)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(412,X,Y,Z,0,-1,-1,-1),0);
			}
		}
		else
		{
		     new allvehicles[] = "1\tAirplanes\n2\tHelicopters\n3\tBikes\n4\tConvertibles\n5\tIndustrial\n6\tLowriders\n7\tOffRoad\n8\tPublic Service Vehicles\n9\tSaloons\n10\tSport Vehicles\n11\tStation Wagons\n12\tBoats\n13\tUnique Vehicles\n14\tRC Vehicles\n15\tTrailers";
	   		 ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST," Vehicles: || Scroll Down for more",allvehicles,"Select","Cancel");
		}
	}
	else if(dialogid == 9)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(568,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 1)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(424,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 2)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(573,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 3)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(579,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 4)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(400,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 5)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(500,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 6)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(444,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 7)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(556,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 8)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(557,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 9)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(470,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 10)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(489,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 11)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(505,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 12)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(495,X,Y,Z,0,-1,-1,-1),0);
			}
		}
		else
		{
		    new allvehicles[] = "1\tAirplanes\n2\tHelicopters\n3\tBikes\n4\tConvertibles\n5\tIndustrial\n6\tLowriders\n7\tOffRoad\n8\tPublic Service Vehicles\n9\tSaloons\n10\tSport Vehicles\n11\tStation Wagons\n12\tBoats\n13\tUnique Vehicles\n14\tRC Vehicles\n15\tTrailers";
	   		ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST," Vehicles: || Scroll Down for more",allvehicles,"Select","Cancel");
		}
	}
	else if(dialogid == 10)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(416,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 1)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(433,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 2)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(431,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 3)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(438,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 4)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(437,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 5)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(523,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 6)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(427,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 7)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(490,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 8)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(528,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 9)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(407,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 10)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(544,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 11)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(596,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 12)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(598,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 13)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(597,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 14)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(599,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 15)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(601,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 16)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(420,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 17)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(432,X,Y,Z,0,-1,-1,-1),0);
			}
		}
		else
		{
		    new allvehicles[] = "1\tAirplanes\n2\tHelicopters\n3\tBikes\n4\tConvertibles\n5\tIndustrial\n6\tLowriders\n7\tOffRoad\n8\tPublic Service Vehicles\n9\tSaloons\n10\tSport Vehicles\n11\tStation Wagons\n12\tBoats\n13\tUnique Vehicles\n14\tRC Vehicles\n15\tTrailers";
	   		ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST," Vehicles: || Scroll Down for more",allvehicles,"Select","Cancel");
		}
	}
	else if(dialogid == 11)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(445,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 1)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(504,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 2)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(401,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 3)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(518,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 4)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(527,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 5)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(542,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 6)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(507,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 7)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(562,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 8)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(585,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 9)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(419,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 10)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(526,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 11)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(604,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 12)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(466,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 13)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(492,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 14)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(474,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 15)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(546,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 16)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(517,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 17)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(310,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 18)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(551,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 19)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(516,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 20)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(467,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 21)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(426,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 22)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(436,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 23)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(547,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 24)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(405,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 25)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(580,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 26)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(560,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 27)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(550,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 28)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(549,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 29)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(540,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 30)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(491,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 31)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(529,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 32)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(421,X,Y,Z,0,-1,-1,-1),0);
			}
		}
		else
		{
		    new allvehicles[] = "1\tAirplanes\n2\tHelicopters\n3\tBikes\n4\tConvertibles\n5\tIndustrial\n6\tLowriders\n7\tOffRoad\n8\tPublic Service Vehicles\n9\tSaloons\n10\tSport Vehicles\n11\tStation Wagons\n12\tBoats\n13\tUnique Vehicles\n14\tRC Vehicles\n15\tTrailers";
	   		ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST," Vehicles: || Scroll Down for more",allvehicles,"Select","Cancel");
		}
	}
	else if(dialogid == 12)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(602,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 1)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(429,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 2)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(496,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 3)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(402,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 4)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(541,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 5)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(415,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 6)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(589,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 7)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(587,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 8)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(565,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 9)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(494,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 10)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(502,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 11)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(503,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 12)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(411,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 13)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(559,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 14)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(603,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 15)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(475,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 16)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(506,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 17)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(451,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 18)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(558,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 19)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(477,X,Y,Z,0,-1,-1,-1),0);
			}
		}
		else
		{
		    new allvehicles[] = "1\tAirplanes\n2\tHelicopters\n3\tBikes\n4\tConvertibles\n5\tIndustrial\n6\tLowriders\n7\tOffRoad\n8\tPublic Service Vehicles\n9\tSaloons\n10\tSport Vehicles\n11\tStation Wagons\n12\tBoats\n13\tUnique Vehicles\n14\tRC Vehicles\n15\tTrailers";
	   		ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST," Vehicles: || Scroll Down for more",allvehicles,"Select","Cancel");
		}
	}
	else if(dialogid == 13)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(418,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 1)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(404,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 2)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(479,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 3)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(458,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 4)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(561,X,Y,Z,0,-1,-1,-1),0);
			}
		}
		else
		{
		   	new allvehicles[] = "1\tAirplanes\n2\tHelicopters\n3\tBikes\n4\tConvertibles\n5\tIndustrial\n6\tLowriders\n7\tOffRoad\n8\tPublic Service Vehicles\n9\tSaloons\n10\tSport Vehicles\n11\tStation Wagons\n12\tBoats\n13\tUnique Vehicles\n14\tRC Vehicles\n15\tTrailers";
			ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST," Vehicles: || Scroll Down for more",allvehicles,"Select","Cancel");
		}
	}
	else if(dialogid == 14)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(472,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 1)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(473,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 2)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(493,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 3)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(595,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 4)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(484,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 5)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(430,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 6)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(453,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 7)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(452,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 8)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(446,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 9)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(454,X,Y,Z,0,-1,-1,-1),0);
			}
		}
		else
		{
		    new allvehicles[] = "1\tAirplanes\n2\tHelicopters\n3\tBikes\n4\tConvertibles\n5\tIndustrial\n6\tLowriders\n7\tOffRoad\n8\tPublic Service Vehicles\n9\tSaloons\n10\tSport Vehicles\n11\tStation Wagons\n12\tBoats\n13\tUnique Vehicles\n14\tRC Vehicles\n15\tTrailers";
	   		ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST," Vehicles: || Scroll Down for more",allvehicles,"Select","Cancel");
		}
	}
	else if(dialogid == 15)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(485,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 1)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(457,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 2)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(483,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 3)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(508,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 4)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(532,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 5)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(486,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 6)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(406,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 7)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(530,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 8)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(434,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 9)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(545,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 10)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(588,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 11)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(571,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 12)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(572,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 13)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(423,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 14)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(442,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 15)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(428,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 16)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(409,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 17)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(574,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 18)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(525,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 19)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(583,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 20)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(539,X,Y,Z,0,-1,-1,-1),0);
			}
		}
		else
		{
		    new allvehicles[] = "1\tAirplanes\n2\tHelicopters\n3\tBikes\n4\tConvertibles\n5\tIndustrial\n6\tLowriders\n7\tOffRoad\n8\tPublic Service Vehicles\n9\tSaloons\n10\tSport Vehicles\n11\tStation Wagons\n12\tBoats\n13\tUnique Vehicles\n14\tRC Vehicles\n15\tTrailers";
	   		ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST," Vehicles: || Scroll Down for more",allvehicles,"Select","Cancel");
		}
	}
	else if(dialogid == 16)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(441,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 1)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(464,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 2)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(465,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 3)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(501,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 4)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(564,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 5)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(594,X,Y,Z,0,-1,-1,-1),0);
			}
		}
		else
		{
		    new allvehicles[] = "1\tAirplanes\n2\tHelicopters\n3\tBikes\n4\tConvertibles\n5\tIndustrial\n6\tLowriders\n7\tOffRoad\n8\tPublic Service Vehicles\n9\tSaloons\n10\tSport Vehicles\n11\tStation Wagons\n12\tBoats\n13\tUnique Vehicles\n14\tRC Vehicles\n15\tTrailers";
	   		ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST," Vehicles: || Scroll Down for more",allvehicles,"Select","Cancel");
		}
	}
	else if(dialogid == 17)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(435,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 1)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(450,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 2)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(591,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 3)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(606,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 4)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(607,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 5)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(610,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 6)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(569,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 7)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(590,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 8)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(584,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 9)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(570,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 10)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(608,X,Y,Z,0,-1,-1,-1),0);
			}
			else if(listitem == 11)
			{
			    PutPlayerInVehicle(playerid,CreateVehicle(611,X,Y,Z,0,-1,-1,-1),0);
			}
		}
		else
		{
		    new allvehicles[] = "1\tAirplanes\n2\tHelicopters\n3\tBikes\n4\tConvertibles\n5\tIndustrial\n6\tLowriders\n7\tOffRoad\n8\tPublic Service Vehicles\n9\tSaloons\n10\tSport Vehicles\n11\tStation Wagons\n12\tBoats\n13\tUnique Vehicles\n14\tRC Vehicles\n15\tTrailers";
	   		ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST," Vehicles: || Scroll Down for more",allvehicles,"Select","Cancel");
		}
	}
	return 1;
}
