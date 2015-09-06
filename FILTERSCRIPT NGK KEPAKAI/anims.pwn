//Anims By FLake.
#include <a_samp>
#define SPECIAL_ACTION_PISSING 68
#define COLOR_BLUE 0x33AAFFFF
#define COLOR_YELLOW 0xFFFF00AA
public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print("          Anims Loading              ");
	print("       					            ");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	print("\n----------------------------------");
	print("          Anims Unloading        ");
	print("         				       ");
	print("----------------------------------\n");
	return 1;
}

public OnPlayerConnect(playerid)
{
	
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/anims", cmdtext, true, 10) == 0)
	{
		SendClientMessage(playerid, COLOR_BLUE, "/relax | /scared | /sick | /wave | /spank | /taichi | /crossarms |");
        SendClientMessage(playerid, COLOR_BLUE, "/wank | /kiss | /talk | /fucku | /cocaine | /rocky | /sit | /smoke |");
        SendClientMessage(playerid, COLOR_BLUE, "/beach | /lookout | /circle | /medic | /chat | /die | /slapa | /rofl |");
        SendClientMessage(playerid, COLOR_BLUE, "/glitched | /fakefire | /bomb | /robman | /handsup | /piss |");
        SendClientMessage(playerid, COLOR_BLUE, "/getin | /skate | /cover | /fart | /vomit | /drunk | /bj1 | /bj2 | /bj3");
        SendClientMessage(playerid, COLOR_BLUE, "/funnywalk | /kickass | /cell | /laugh | /eat | /injured |");
        SendClientMessage(playerid, COLOR_BLUE, "/slapass | /laydown | /arrest | /laugh | /eat | /carjack | /strip | /strip2");
        SendClientMessage(playerid, COLOR_BLUE, "/animswat | /animswat1 | /animswat2 | /animswat3 | /animswat4 | /animswat5");
        SendClientMessage(playerid, COLOR_BLUE, "/animswat6 | /strip3 | /strip4 | /strip5 | /baseball | /baseball2");
        return 1;
	}
	else if (strcmp(cmdtext, "/relax", true)==0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
            ApplyAnimation(playerid,"BEACH", "bather", 4.0, 1, 0, 0, 0, 0);
		}
	    return 1;
	}
	else if (strcmp(cmdtext, "/handsup", true)==0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
			SetPlayerSpecialAction(playerid,SPECIAL_ACTION_HANDSUP);
		}
	    return 1;
	}
	else if (strcmp(cmdtext, "/bomb", true)==0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
            ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
		}
	    return 1;
	}
	else if (strcmp(cmdtext, "/robman", true)==0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
            ApplyAnimation(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 1, 0, 0, 0, 0);
		}
	    return 1;
	}
	else if (strcmp(cmdtext, "/wank", true)==0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
            ApplyAnimation(playerid,"PAULNMAC", "wank_loop", 1.800001, 1, 0, 0, 1, 600);
		}
	    return 1;
	}
	else if (strcmp(cmdtext, "/crossarms", true)==0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
            ApplyAnimation(playerid,"PAULNMAC", "wank_loop", 1.800001, 1, 0, 0, 1, 600);
		}
	    return 1;
	}
	else if (strcmp(cmdtext, "/taichi", true)==0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
            ApplyAnimation(playerid,"PARK","Tai_Chi_Loop",4.0,1,0,0,0,0);
		}
	    return 1;
	}
	else if (strcmp(cmdtext, "/spank", true)==0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
            ApplyAnimation(playerid, "SWEET", "sweet_ass_slap", 4.0, 0, 0, 0, 0, 0);
		}
	    return 1;
	}
	else if (strcmp(cmdtext, "/wave", true)==0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
            ApplyAnimation(playerid, "ON_LOOKERS", "wave_loop", 4.0, 1, 0, 0, 0, 0);
		}
	    return 1;
	}
	else if (strcmp(cmdtext, "/sick", true)==0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
            ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 3.0, 0, 0, 0, 0, 0);
		}
	    return 1;
	}
	else if (strcmp(cmdtext, "/scared", true)==0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
            ApplyAnimation(playerid, "ped", "cower", 3.0, 1, 0, 0, 0, 0);
		}
	    return 1;
	}
	else if (strcmp(cmdtext, "/talk", true)==0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
			ApplyAnimation(playerid,"PED","IDLE_CHAT",1.800001, 1, 1, 1, 1, 13000);
		}
	    return 1;
	}
	else if (strcmp(cmdtext, "/kiss", true)==0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
			ApplyAnimation(playerid,"KISSING", "Grlfrd_Kiss_02", 1.800001, 1, 0, 0, 1, 600);
		}
	    return 1;
	}
	else if (strcmp(cmdtext, "/sit", true)==0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
			ApplyAnimation(playerid,"INT_OFFICE", "OFF_Sit_Bored_Loop", 1.800001, 1, 0, 0, 1, 600);
		}
	    return 1;
	}
	else if (strcmp(cmdtext, "/fucku", true)==0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
			ApplyAnimation(playerid,"ped", "fucku", 4.1, 0, 1, 1, 1, 1 );
		}
	    return 1;
	}
	else if (strcmp(cmdtext, "/cocaine", true)==0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
			ApplyAnimation(playerid,"CRACK", "crckdeth2", 1.800001, 1, 0, 0, 1, 600);
		}
	    return 1;
	}
	else if (strcmp(cmdtext, "/rocky", true)==0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
			ApplyAnimation(playerid,"GYMNASIUM", "GYMshadowbox", 1.800001, 1, 0, 0, 1, 600);
		}
	    return 1;
	}
	else if (strcmp(cmdtext, "/smoke", true)==0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
			ApplyAnimation(playerid,"SMOKING", "M_smklean_loop", 4.0, 1, 0, 0, 0, 0);
		}
	    return 1;
	}
	else if (strcmp("/beach", cmdtext, true, 10) == 0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
			ApplyAnimation(playerid,"BEACH","SitnWait_loop_W",4.1,0,1,1,1,1);
		}
		return 1;
	}
	else if (strcmp("/lookout", cmdtext, true, 10) == 0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
			ApplyAnimation(playerid,"ON_LOOKERS","lkup_in",4.1,0,1,1,1,1);
		}
		return 1;
	}
	else if (strcmp("/circle", cmdtext, true, 10) == 0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
			ApplyAnimation(playerid,"CHAINSAW","CSAW_Hit_2",4.1,0,1,1,1,1);
		}
		return 1;
	}
	else if (strcmp("/medic", cmdtext, true, 10) == 0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
			ApplyAnimation(playerid,"MEDIC","CPR",4.1,0,1,1,1,1);
		}
		return 1;
	}
	else if (strcmp("/chat", cmdtext, true, 10) == 0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
			ApplyAnimation(playerid,"PED","IDLE_CHAT",4.1,0,1,1,1,1);
		}
		return 1;
	}
	else if (strcmp("/die", cmdtext, true, 10) == 0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
			ApplyAnimation(playerid,"PED","BIKE_fallR",4.1,0,1,1,1,1);
		}
		return 1;
	}
	else if (strcmp("/slapa", cmdtext, true, 10) == 0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
			ApplyAnimation(playerid,"PED","BIKE_elbowL",4.1,0,1,1,1,1);
		}
		return 1;
	}
	else if (strcmp("/rofl", cmdtext, true, 10) == 0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
			ApplyAnimation(playerid,"PED","Crouch_Roll_L",4.1,0,1,1,1,1);
		}
		return 1;
	}
	else if (strcmp("/glitched", cmdtext, true, 10) == 0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
			ApplyAnimation(playerid,"TATTOOS","TAT_Sit_Out_O",4.1,0,1,1,1,1);
		}
		return 1;
	}
	else if (strcmp("/fakefire", cmdtext, true, 10) == 0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
			ApplyAnimation(playerid,"SILENCED","SilenceCrouchfire",4.1,0,1,1,1,1);
		}
		return 1;
	}
	else if (strcmp("/fart", cmdtext, true, 10) == 0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
			PlayerPlaySound(playerid, 1147, 0.0, 0.0, 0.0);
		}
		return 1;
	}
	else if (strcmp("/vomit", cmdtext, true) == 0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
	    	ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 3.0, 0, 0, 0, 0, 0); // Vomit BAH!
	    	PlayerPlaySound(playerid, 1169, 0.0, 0.0, 0.0);
        }
        return 1;
	}
	else if (strcmp("/drunk", cmdtext, true, 10) == 0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
			ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1,0,1,1,1,1);
		}
		return 1;
	}
	else if (strcmp("/getin", cmdtext, true) == 0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
			ApplyAnimation(playerid,"NEVADA","NEVADA_getin",4.1,0,1,1,1,1);
        }
        return 1;
    }
	else if (strcmp("/piss", cmdtext, true) == 0)
    {
	    if (GetPlayerState(playerid)== 1)
	    {
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_PISSING);
        }
		return 1;
    }
	else if (strcmp("/funnywalk", cmdtext, true) == 0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
			ApplyAnimation(playerid,"WUZI","Wuzi_Walk",4.1,0,1,1,1,1);
		}
  		return 1;
    }
	else if (strcmp("/kickass", cmdtext, true) == 0)
	{
		if (GetPlayerState(playerid)== 1)
	    {
			ApplyAnimation(playerid,"FIGHT_E","Hit_fightkick",4.1,0,1,1,1,1);
        }
        return 1;
    }
 	if(strcmp("/cell", cmdtext, true) == 0)
	{
		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USECELLPHONE);
        return 1;
    }
    if (strcmp("/laugh", cmdtext, true) == 0)
	{
		ApplyAnimation(playerid, "RAPPING", "Laugh_01", 4.0, 0, 0, 0, 0, 0); // Laugh
		return 1;
	}
    if (strcmp("/eat", cmdtext, true) == 0)
	{
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0); // Eat Burger
		return 1;
	}
    if(strcmp("/injured", cmdtext, true) == 0)
	{
		ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.0, 1, 0, 0, 0, 0);
		return 1;
    }
    if (strcmp("/slapass", cmdtext, true) == 0)
	{
		ApplyAnimation(playerid, "SWEET", "sweet_ass_slap", 4.0, 0, 0, 0, 0, 0); // Ass Slapping
		return 1;
	}
    if (strcmp("/laydown", cmdtext, true) == 0)
	{
		ApplyAnimation(playerid,"BEACH", "bather", 4.0, 1, 0, 0, 0, 0); // Lay down
		return 1;
 	}
    if (strcmp("/arrest", cmdtext, true) == 0)
	{
		ApplyAnimation(playerid,"ped", "ARRESTgun", 4.0, 0, 1, 1, 1, -1); // Gun Arrest
		return 1;
 	}
    if(strcmp("/carjack", cmdtext, true) == 0)
	{
		ApplyAnimation(playerid,"PED","CAR_jackedLHS",4.0,0,1,1,1,0);
  		return 1;
    }
    else if (strcmp(cmdtext, "/stopanim", true)==0)
	{
        ClearAnimations(playerid);
	    return 1;
	}
	if(strcmp("/bj1", cmdtext, true) == 0)
	{
		ApplyAnimation(playerid,"BLOWJOBZ","BJ_STAND_END_W",4.0,0,1,1,1,0);
  		return 1;
    }
    if(strcmp("/bj2", cmdtext, true) == 0)
    {
		ApplyAnimation(playerid,"BLOWJOBZ","BJ_STAND_END_P",4.0,0,1,1,1,0);
  		return 1;
    }
    if(strcmp("/bj3", cmdtext, true) == 0)
    {
		ApplyAnimation(playerid,"BLOWJOBZ","BJ_STAND_LOOP_W",4.0,0,1,1,1,0);
  		return 1;
    }
    if(strcmp("/animswat", cmdtext, true) == 0)
    {
		ApplyAnimation(playerid,"SWAT","gnstwall_injurd",4.0,0,1,1,1,0);
  		return 1;
    }
    if(strcmp("/animswat2", cmdtext, true) == 0)
    {
		ApplyAnimation(playerid,"SWAT","JMP_Wall1m_180",4.0,0,1,1,1,0);
  		return 1;
    }
    if(strcmp("/animswat3", cmdtext, true) == 0)
    {
		ApplyAnimation(playerid,"SWAT","Rail_fall",4.0,0,1,1,1,0);
  		return 1;
    }
    if(strcmp("/animswat4", cmdtext, true) == 0)
    {
		ApplyAnimation(playerid,"SWAT","Rail_fall_crawl",4.0,0,1,1,1,0);
  		return 1;
    }
    if(strcmp("/animswat5", cmdtext, true) == 0)
    {
		ApplyAnimation(playerid,"SWAT","swt_breach_01",4.0,0,1,1,1,0);
  		return 1;
    }
    if(strcmp("/animswat6", cmdtext, true) == 0)
    {
		ApplyAnimation(playerid,"SWAT","swt_breach_02",4.0,0,1,1,1,0);
  		return 1;
    }
    if(strcmp("/strip", cmdtext, true) == 0)
    {
		ApplyAnimation(playerid,"STRIP","strip_A",4.0,0,1,1,1,0);
  		return 1;
    }
    if(strcmp("/strip2", cmdtext, true) == 0)
    {
		ApplyAnimation(playerid,"STRIP","strip_B",4.0,0,1,1,1,0);
  		return 1;
    }
    if(strcmp("/strip3", cmdtext, true) == 0)
    {
		ApplyAnimation(playerid,"STRIP","strip_C",4.0,0,1,1,1,0);
  		return 1;
    }
    if(strcmp("/strip4", cmdtext, true) == 0)
    {
		ApplyAnimation(playerid,"STRIP","strip_D",4.0,0,1,1,1,0);
  		return 1;
    }
    if(strcmp("/stri5", cmdtext, true) == 0)
    {
		ApplyAnimation(playerid,"STRIP","strip_E",4.0,0,1,1,1,0);
  		return 1;
    }
    if(strcmp("/Baseball", cmdtext, true) == 0)
    {
		ApplyAnimation(playerid,"BASEBALL","Bat_1",4.0,0,1,1,1,0);
  		return 1;
    }
    if(strcmp("/baseball2", cmdtext, true) == 0)
    {
		ApplyAnimation(playerid,"BASEBALL","Bat_2",4.0,0,1,1,1,0);
  		return 1;
    }
	return 0;
}
