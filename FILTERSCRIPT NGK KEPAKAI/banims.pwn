/*
 *
 *         			 -- bAnims v1.0 --
 *         			 -- VisiT wWw.blooDz.Ro --
 *                   -- Filterscript Made by Babica --
 *                   -- Do not remove credits please --
*/

//=-=-=-=-=-=-=-=-=Includes=-=-=-=-=-=-=-=-=
#include <a_samp>
#include <core>
#include <float>
#pragma tabsize 0
#include "../include/gl_common.inc"


//=-=-=-=-=-=-=-=-=Defines=-=-=-=-=-=-=-=-=
#define COLOR_KOS 0x9400D3FF
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_YELLOW2 0xF5DEB3AA
#define COLOR_KOS 0x9400D3FF
#define SPECIAL_ACTION_PISSING 68

new gPlayerUsingLoopingAnim[MAX_PLAYERS];
new gPlayerAnimLibsPreloaded[MAX_PLAYERS];

new Text:txtAnimHelper;



//-------------------------------------------------

OnePlayAnim(playerid,animlib[],animname[], Float:Speed, looping, lockx, locky, lockz, lp)
{
	ApplyAnimation(playerid, animlib, animname, Speed, looping, lockx, locky, lockz, lp);
}

//-------------------------------------------------

LoopingAnim(playerid,animlib[],animname[], Float:Speed, looping, lockx, locky, lockz, lp)
{
    gPlayerUsingLoopingAnim[playerid] = 1;
    ApplyAnimation(playerid, animlib, animname, Speed, looping, lockx, locky, lockz, lp);
    TextDrawShowForPlayer(playerid,txtAnimHelper);
}

//------------------------------------------------

StopLoopingAnim(playerid)
{
	gPlayerUsingLoopingAnim[playerid] = 0;
    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
}

//=-=-=-=-=-=-=-=-=PreloadAnimLib=-=-=-=-=-=-=-=-=

PreloadAnimLib(playerid, animlib[])
{
	ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0);
}

//=-=-=-=-=-=-=-=-=OnPlayerKeyStateChange=-=-=-=-=-=-=-=-=

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(!gPlayerUsingLoopingAnim[playerid]) return;

	if(IsKeyJustDown(KEY_SPRINT,newkeys,oldkeys)) {
	    StopLoopingAnim(playerid);
        TextDrawHideForPlayer(playerid,txtAnimHelper);
    }
}

//=-=-=-=-=-=-=-=-=OnPlayerDeath=-=-=-=-=-=-=-=-=

public OnPlayerDeath(playerid, killerid, reason)
{
	if(gPlayerUsingLoopingAnim[playerid]) {
        gPlayerUsingLoopingAnim[playerid] = 0;
        TextDrawHideForPlayer(playerid,txtAnimHelper);
	}

 	return 1;
}

//=-=-=-=-=-=-=-=-=OnPlayerSpawn=-=-=-=-=-=-=-=-=

public OnPlayerSpawn(playerid)
{
	if(!gPlayerAnimLibsPreloaded[playerid]) {
   		PreloadAnimLib(playerid,"BOMBER");
   		PreloadAnimLib(playerid,"RAPPING");
    	PreloadAnimLib(playerid,"SHOP");
   		PreloadAnimLib(playerid,"BEACH");
   		PreloadAnimLib(playerid,"SMOKING");
    	PreloadAnimLib(playerid,"FOOD");
    	PreloadAnimLib(playerid,"ON_LOOKERS");
    	PreloadAnimLib(playerid,"DEALER");
    	PreloadAnimLib(playerid,"MISC");
    	PreloadAnimLib(playerid,"SWEET");
    	PreloadAnimLib(playerid,"RIOT");
    	PreloadAnimLib(playerid,"PED");
    	PreloadAnimLib(playerid,"POLICE");
		PreloadAnimLib(playerid,"CRACK");
		PreloadAnimLib(playerid,"CARRY");
		PreloadAnimLib(playerid,"COP_AMBIENT");
		PreloadAnimLib(playerid,"PARK");
		PreloadAnimLib(playerid,"INT_HOUSE");
		PreloadAnimLib(playerid,"FOOD");
		gPlayerAnimLibsPreloaded[playerid] = 1;
	}
	return 1;
}

//=-=-=-=-=-=-=-=-=OnPlayerConnect=-=-=-=-=-=-=-=-=

public OnPlayerConnect(playerid)
{
    gPlayerUsingLoopingAnim[playerid] = 0;
	gPlayerAnimLibsPreloaded[playerid] = 0;
	
	return 1;
}

//=-=-=-=-=-=-=-=-=OnFilterScriptInit=-=-=-=-=-=-=-=-=

public OnFilterScriptInit()
{
	txtAnimHelper = TextDrawCreate(610.0, 400.0,
	"~r~~k~~PED_SPRINT~ ~w~to stop the animation");
	TextDrawUseBox(txtAnimHelper, 0);
	TextDrawFont(txtAnimHelper, 2);
	TextDrawSetShadow(txtAnimHelper,0); 
    TextDrawSetOutline(txtAnimHelper,1);
    TextDrawBackgroundColor(txtAnimHelper,0x000000FF);
    TextDrawColor(txtAnimHelper,0xFFFFFFFF);
    TextDrawAlignment(txtAnimHelper,3);
}

//=-=-=-=-=-=-=-=-=OnPlayerCommandText=-=-=-=-=-=-=-=-=

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/anims", cmdtext, true) == 0)
	{
		SendClientMessage(playerid,COLOR_YELLOW,"==============================================ANIMSLIST============================================");
        SendClientMessage(playerid,COLOR_YELLOW2,"/handsup, /dance[1-4], /rap, /rap[2-3], /wankoff, /wank, /strip[1-7], /sexy[1-8], /bj[1-4], /cellin, /cellout, /lean, /piss, /follow");
        SendClientMessage(playerid,COLOR_YELLOW2,"/greet, /injured, /injured2, /hitch, /bitchslap, /cpr, /gsign1, /gsign2, /gsign3, /gsign4, /gsign5, /gift, /getup");
        SendClientMessage(playerid,COLOR_YELLOW2,"/chairsit, /stand, /slapped, /slapass, /drunk, /gwalk, /gwalk2, /mwalk, /fwalk, /celebrate, /celebrate2, /win, /win2");
        SendClientMessage(playerid,COLOR_YELLOW2,"/yes, /deal, /deal2, /thankyou, /invite1, /invite2, /sit, /scratch, /bomb, /getarrested, /laugh, /lookout, /robman");
        SendClientMessage(playerid,COLOR_YELLOW2,"/crossarms, /crossarms2, /crossarms3, /lay, /cover, /vomit, /eat, /wave, /crack, /crack2, /smokem, /smokef, /msit, /fsit");
        SendClientMessage(playerid,COLOR_YELLOW,"========================================================================================================");
        return 1;
    }
	if (strcmp("/animlist", cmdtext, true) == 0)
	{
	    SendClientMessage(playerid,COLOR_YELLOW,"===============================================ANIMSLIST=============================================");
		SendClientMessage(playerid,COLOR_YELLOW2,"/chat, /fucku, /taichi, /chairsit, /relax, /bat1, /bat2, /bat3, /bat4, /bat5, /nod, /cry1, /cry2, /chant, /carsmoke, /aim");
        SendClientMessage(playerid,COLOR_YELLOW2,"/gang1, /gang2, /gang3, /gang4, /gang5, /gang6, /gang7, /bed[1-4], /carsit, /carsit2, /stretch, /angry");
        SendClientMessage(playerid,COLOR_YELLOW2,"/kiss[1-8], /exhausted, /ghand1, /ghand2, /ghand3, /ghand4, /ghand5");
        SendClientMessage(playerid,COLOR_YELLOW2,"/basket1, /basket2, /basket3, /basket4, /basket5, /basket6, /akick, /box, /cockgun");
        SendClientMessage(playerid,COLOR_YELLOW2,"/bar[1-4], /lay2, /liftup, /putdown, /die, /joint, /die2, /aim2");
        SendClientMessage(playerid,COLOR_YELLOW2,"/benddown, /checkout");
        SendClientMessage(playerid,COLOR_YELLOW,"==================================================================================================");
        return 1;
    }
	else if(strcmp(cmdtext, "/handsup", true) == 0)
	{
			SetPlayerSpecialAction(playerid,SPECIAL_ACTION_HANDSUP);
			SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
			 return 1;
	}

	else if(strcmp(cmdtext,"/stopanim",true) == 0)
	{
		    ApplyAnimation(playerid, "CARRY", "crry_prtial", 2.0, 0, 0, 0, 0, 0);
		    return 1;
    }

    else if(strcmp(cmdtext, "/dance", true) == 0)
	{
            SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE1);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
	}

    else if(strcmp(cmdtext, "/dance2", true) == 0)
    {
            SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE2);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
	}

	else if(strcmp(cmdtext, "/dance3", true) == 0)
    {
            SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE3);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
	}

	else if(strcmp(cmdtext, "/dance4", true) == 0)
    {
            SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE4);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
	}
	else if(strcmp(cmdtext, "/rap", true) == 0)
	{
            OnePlayAnim(playerid,"RAPPING","RAP_A_Loop",4.0,1,1,1,1,0);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
    }

	else if(strcmp(cmdtext, "/rap2", true) == 0)
	{
            OnePlayAnim(playerid,"RAPPING","RAP_B_Loop",4.0,1,1,1,1,0);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
    }

    else if(strcmp(cmdtext, "/rap3", true) == 0)
	{
            OnePlayAnim(playerid,"RAPPING","RAP_C_Loop",4.0,1,1,1,1,0);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
    }

    else if(strcmp(cmdtext, "/wankoff", true) == 0)
    {
            OnePlayAnim(playerid,"PAULNMAC","wank_in",4.0,1,1,1,1,0);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
	}

	else if(strcmp(cmdtext, "/wank", true) == 0)
    {
            OnePlayAnim(playerid,"PAULNMAC","wank_loop",4.0,1,1,1,1,0);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
	}

	else if(strcmp(cmdtext, "/strip", true) == 0)
	{
            OnePlayAnim(playerid,"STRIP","strip_A",4.0,1,1,1,1,0);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
	}

	else if(strcmp(cmdtext, "/strip2", true) == 0)
	{
            OnePlayAnim(playerid,"STRIP","strip_B",4.0,1,1,1,1,0);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
	}

	else if(strcmp(cmdtext, "/strip3", true) == 0)
	{
            OnePlayAnim(playerid,"STRIP","strip_C",4.0,1,1,1,1,0);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
	}

	else if(strcmp(cmdtext, "/strip4", true) == 0)
	{
            OnePlayAnim(playerid,"STRIP","strip_D",4.0,1,1,1,1,0);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
	}

	else if(strcmp(cmdtext, "/strip5", true) == 0)
	{
            OnePlayAnim(playerid,"STRIP","strip_E",4.0,1,1,1,1,0);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
	}

	else if(strcmp(cmdtext, "/strip6", true) == 0)
	{
            OnePlayAnim(playerid,"STRIP","strip_F",4.0,1,1,1,1,0);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
	}

	else if(strcmp(cmdtext, "/strip7", true) == 0)
	{
            OnePlayAnim(playerid,"STRIP","strip_G",4.0,1,1,1,1,0);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
	}

	else if(strcmp(cmdtext, "/sexy", true) == 0)
	{
            OnePlayAnim(playerid,"SNM","SPANKING_IDLEW",4.1,0,1,1,1,1);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
	}

	else if(strcmp(cmdtext, "/sexy2", true) == 0)
	{
            OnePlayAnim(playerid,"SNM","SPANKING_IDLEP",4.1,0,1,1,1,1);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
	}

	else if(strcmp(cmdtext, "/sexy3", true) == 0)
	{
            OnePlayAnim(playerid,"SNM","SPANKINGW",4.1,0,1,1,1,1);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
	}

	else if(strcmp(cmdtext, "/sexy4", true) == 0)
	{
            OnePlayAnim(playerid,"SNM","SPANKINGP",4.1,0,1,1,1,1);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
	}

	else if(strcmp(cmdtext, "/sexy5", true) == 0)
	{
            OnePlayAnim(playerid,"SNM","SPANKEDW",4.1,0,1,1,1,1);
SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
			return 1;
            
	}

	else if(strcmp(cmdtext, "/sexy6", true) == 0)
	{
            OnePlayAnim(playerid,"SNM","SPANKEDP",4.1,0,1,1,1,1);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
	}

	else if(strcmp(cmdtext, "/sexy7", true) == 0)
	{
            OnePlayAnim(playerid,"SNM","SPANKING_ENDW",4.1,0,1,1,1,1);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
	}

	else if(strcmp(cmdtext, "/sexy8", true) == 0)
	{
            OnePlayAnim(playerid,"SNM","SPANKING_ENDP",4.1,0,1,1,1,1);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
	}

	else if(strcmp(cmdtext, "/bj", true) == 0)
	{
            OnePlayAnim(playerid,"BLOWJOBZ","BJ_COUCH_START_P",4.1,0,1,1,1,1);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
	}

	else if(strcmp(cmdtext, "/bj2", true) == 0)
	{
            OnePlayAnim(playerid,"BLOWJOBZ","BJ_COUCH_START_W",4.1,0,1,1,1,1);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
	}

	else if(strcmp(cmdtext, "/bj3", true) == 0)
	{
            OnePlayAnim(playerid,"BLOWJOBZ","BJ_COUCH_LOOP_P",4.1,0,1,1,1,1);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
	}

	else if(strcmp(cmdtext, "/bj4", true) == 0)
	{
            OnePlayAnim(playerid,"BLOWJOBZ","BJ_COUCH_LOOP_W",4.1,0,1,1,1,1);
            SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
            return 1;
	}

	else if(strcmp(cmdtext, "/cellin", true) == 0)
    {
        SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USECELLPHONE);
        return 1;
    }

    else if(strcmp(cmdtext, "/cellout", true) == 0)
	{
        SetPlayerSpecialAction(playerid,SPECIAL_ACTION_STOPUSECELLPHONE);
        return 1;
    }

    else if(strcmp(cmdtext, "/lean", true) == 0)
	{
        OnePlayAnim(playerid,"GANGS","leanIDLE", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/piss", true) == 0)
	{
        SetPlayerSpecialAction(playerid, 68);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/follow", true) == 0)
	{
        OnePlayAnim(playerid,"WUZI","Wuzi_follow",4.0,0,0,0,0,0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/greet", true) == 0)
	{
        OnePlayAnim(playerid,"WUZI","Wuzi_Greet_Wuzi",4.0,0,0,0,0,0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/stand", true) == 0)
	{
        OnePlayAnim(playerid,"WUZI","Wuzi_stand_loop", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/injured2", true) == 0)
	{
        OnePlayAnim(playerid,"SWAT","gnstwall_injurd", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/hitch", true) == 0)
	{
        LoopingAnim(playerid,"MISC","Hiker_Pose", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/bitchslap", true) == 0)
	{
        LoopingAnim(playerid,"MISC","bitchslap",4.0,0,0,0,0,0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/cpr", true) == 0)
	{
        LoopingAnim(playerid,"MEDIC","CPR", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/gsign1", true) == 0)
	{
        LoopingAnim(playerid,"GHANDS","gsign1",4.0,0,1,1,1,1);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/gsign2", true) == 0)
	{
        LoopingAnim(playerid,"GHANDS","gsign2",4.0,0,1,1,1,1);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/gsign3", true) == 0)
	{
        LoopingAnim(playerid,"GHANDS","gsign3",4.0,0,1,1,1,1);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/gsign4", true) == 0)
	{
        LoopingAnim(playerid,"GHANDS","gsign4",4.0,0,1,1,1,1);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/gsign5", true) == 0)
	{
        LoopingAnim(playerid,"GHANDS","gsign5",4.0,0,1,1,1,1);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/gift", true) == 0)
	{
        LoopingAnim(playerid,"KISSING","gift_give",4.0,0,0,0,0,0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/chairsit", true) == 0)
	{
        LoopingAnim(playerid,"PED","SEAT_idle", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/injured", true) == 0) {

        LoopingAnim(playerid,"SWEET","Sweet_injuredloop", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/slapped", true) == 0)
	{
        LoopingAnim(playerid,"SWEET","ho_ass_slapped",4.0,0,0,0,0,0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/slapass", true) == 0)
	{
        LoopingAnim(playerid,"SWEET","sweet_ass_slap",4.0,0,0,0,0,0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/drunk", true) == 0)
	{
        LoopingAnim(playerid,"PED","WALK_DRUNK",4.1,1,1,1,1,1);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/skate", true) == 0)
	{
        LoopingAnim(playerid,"SKATE","skate_run",4.1,1,1,1,1,1);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/gwalk", true) == 0) {
        LoopingAnim(playerid,"PED","WALK_gang1",4.1,1,1,1,1,1);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/gwalk2", true) == 0)
	{
        LoopingAnim(playerid,"PED","WALK_gang2",4.1,1,1,1,1,1);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/limp", true) == 0)
	{
        LoopingAnim(playerid,"PED","WALK_old",4.1,1,1,1,1,1);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/eatsit", true) == 0)
	{
        LoopingAnim(playerid,"FOOD","FF_Sit_Loop", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/celebrate", true) == 0)
	{
        LoopingAnim(playerid,"benchpress","gym_bp_celebrate", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/win", true) == 0)
	{
        LoopingAnim(playerid,"CASINO","cards_win", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/win2", true) == 0)
	{
        LoopingAnim(playerid,"CASINO","Roulette_win", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/yes", true) == 0)
	{
        LoopingAnim(playerid,"CLOTHES","CLO_Buy", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/deal2", true) == 0)
	{
        LoopingAnim(playerid,"DEALER","DRUGS_BUY", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/thankyou", true) == 0)
	{
        LoopingAnim(playerid,"FOOD","SHP_Thank", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/invite1", true) == 0)
	{
        LoopingAnim(playerid,"GANGS","Invite_Yes",4.1,0,1,1,1,1);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/invite2", true) == 0)
	{
        LoopingAnim(playerid,"GANGS","Invite_No",4.1,0,1,1,1,1);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/celebrate2", true) == 0)
	{
        LoopingAnim(playerid,"GYMNASIUM","gym_tread_celebrate", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/sit", true) == 0)
	{
        LoopingAnim(playerid,"INT_OFFICE","OFF_Sit_Type_Loop", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/scratch", true) == 0)
	{
        LoopingAnim(playerid,"MISC","Scratchballs_01", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if (strcmp("/bomb", cmdtext, true) == 0)
	{
        ClearAnimations(playerid);
        LoopingAnim(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0); // Place Bomb
        return 1;
    }

    else if (strcmp("/getarrested", cmdtext, true, 7) == 0)
	{
        LoopingAnim(playerid,"ped", "ARRESTgun", 4.0, 0, 1, 1, 1, -1); // Gun Arrest
        return 1;
    }

    else if (strcmp("/laugh", cmdtext, true) == 0)
	{
        LoopingAnim(playerid, "RAPPING", "Laugh_01", 4.0, 0, 0, 0, 0, 0); // Laugh
        return 1;
    }

    else if (strcmp("/lookout", cmdtext, true) == 0)
	{
        LoopingAnim(playerid, "SHOP", "ROB_Shifty", 4.0, 0, 0, 0, 0, 0); // Rob Lookout
        return 1;
    }

    else if (strcmp("/robman", cmdtext, true) == 0)
	{
        LoopingAnim(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 1, 0, 0, 0, 0); // Rob
        return 1;
    }

    else if (strcmp("/crossarms", cmdtext, true) == 0)
	{
        OnePlayAnim(playerid, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1); // Arms crossed
        return 1;
    }

    else if (strcmp("/crossarms2", cmdtext, true) == 0)
	{
        OnePlayAnim(playerid, "DEALER", "DEALER_IDLE", 4.0, 0, 1, 1, 1, -1); // Arms crossed 2
        return 1;
    }

    else if (strcmp("/crossarms3", cmdtext, true) == 0)
	{
        OnePlayAnim(playerid, "DEALER", "DEALER_IDLE_01", 4.0, 0, 1, 1, 1, -1); // Arms crossed 3
        return 1;
    }

    else if (strcmp("/lay", cmdtext, true, 6) == 0)
	{
        OnePlayAnim(playerid,"BEACH", "bather", 4.0, 1, 0, 0, 0, 0); // Lay down
        return 1;
    }

    else if (strcmp("/vomit", cmdtext, true) == 0)
	{
        OnePlayAnim(playerid, "FOOD", "EAT_Vomit_P", 3.0, 0, 0, 0, 0, 0); // Vomit
        return 1;
    }

    else if (strcmp("/eat", cmdtext, true) == 0) {
        OnePlayAnim(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0); // Eat Burger
        return 1;
    }

    else if (strcmp("/wave", cmdtext, true) == 0) {
        OnePlayAnim(playerid, "ON_LOOKERS", "wave_loop", 4.0, 1, 0, 0, 0, 0); // Wave
        return 1;
    }

    else if (strcmp("/deal", cmdtext, true) == 0) {
        OnePlayAnim(playerid, "DEALER", "DEALER_DEAL", 3.0, 0, 0, 0, 0, 0); // Deal Drugs
        return 1;
    }

    else if (strcmp("/crack", cmdtext, true, 6) == 0) {
        OnePlayAnim(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0); // Dieing of Crack
        return 1;
    }

    else if (strcmp("/smokem", cmdtext, true, 4) == 0) {
        OnePlayAnim(playerid,"SMOKING", "M_smklean_loop", 4.0, 1, 0, 0, 0, 0); // Smoke
        return 1;
    }

    else if (strcmp("/smokef", cmdtext, true) == 0) {
        OnePlayAnim(playerid, "SMOKING", "F_smklean_loop", 4.0, 1, 0, 0, 0, 0); // Female Smoking
        return 1;
    }

    else if (strcmp("/msit", cmdtext, true, 4) == 0) {
        OnePlayAnim(playerid,"BEACH", "ParkSit_M_loop", 4.0, 1, 0, 0, 0, 0); // Male Sit
        return 1;
    }

    else if (strcmp("/fsit", cmdtext, true, 4) == 0) {
        OnePlayAnim(playerid,"BEACH", "ParkSit_W_loop", 4.0, 1, 0, 0, 0, 0); // Female Sit
        return 1;
    }

    else if(strcmp(cmdtext, "/chat", true) == 0) {
        OnePlayAnim(playerid,"PED","IDLE_CHAT",4.1,1,1,1,1,1);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/fucku", true) == 0)
	{
        LoopingAnim(playerid,"PED","fucku",4.0,0,0,0,0,0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/taichi", true) == 0)
	{
        LoopingAnim(playerid,"PARK","Tai_Chi_Loop", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/chairsit", true) == 0)
	{
        LoopingAnim(playerid,"BAR","dnk_stndF_loop", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/relax", true) == 0)
	{
        LoopingAnim(playerid,"BEACH","Lay_Bac_Loop", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/bat1", true) == 0)
	{
        LoopingAnim(playerid,"BASEBALL","Bat_IDLE", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/bat2", true) == 0)
	{
        LoopingAnim(playerid,"BASEBALL","Bat_M", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/bat3", true) == 0)
	{
        LoopingAnim(playerid,"BASEBALL","BAT_PART", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/bat4", true) == 0)
	{
        LoopingAnim(playerid,"CRACK","Bbalbat_Idle_01", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/bat5", true) == 0)
	{
        LoopingAnim(playerid,"CRACK","Bbalbat_Idle_02", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/nod", true) == 0)
	{
        LoopingAnim(playerid,"COP_AMBIENT","Coplook_nod",4.0,0,0,0,0,0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/gang1", true) == 0)
	{
        LoopingAnim(playerid,"GANGS","hndshkaa",4.0,0,0,0,0,0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/gang2", true) == 0)
	{
        LoopingAnim(playerid,"GANGS","hndshkba",4.0,0,0,0,0,0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/gang3", true) == 0)
	{
        LoopingAnim(playerid,"GANGS","hndshkca",4.0,0,0,0,0,0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/gang4", true) == 0)
	{
        LoopingAnim(playerid,"GANGS","hndshkcb",4.0,0,0,0,0,0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/gang5", true) == 0)
	{
        LoopingAnim(playerid,"GANGS","hndshkda",4.0,0,0,0,0,0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/gang6", true) == 0)
	{
        LoopingAnim(playerid,"GANGS","hndshkea",4.0,0,0,0,0,0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/gang7", true) == 0)
	{
        LoopingAnim(playerid,"GANGS","hndshkfa",4.0,0,0,0,0,0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/cry1", true) == 0)
	{
        LoopingAnim(playerid,"GRAVEYARD","mrnF_loop", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/cry2", true) == 0)
	{
        LoopingAnim(playerid,"GRAVEYARD","mrnM_loop", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/bed1", true) == 0)
	{
        LoopingAnim(playerid,"INT_HOUSE","BED_In_L",4.1,0,1,1,1,1);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/bed2", true) == 0)
	{
        LoopingAnim(playerid,"INT_HOUSE","BED_In_R",4.1,0,1,1,1,1);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/bed3", true) == 0)
	{
        LoopingAnim(playerid,"INT_HOUSE","BED_Loop_L", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/bed4", true) == 0)
	{
        LoopingAnim(playerid,"INT_HOUSE","BED_Loop_R", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/kiss2", true) == 0)
	{
        LoopingAnim(playerid,"BD_FIRE","Grlfrd_Kiss_03",4.0,0,0,0,0,0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/kiss3", true) == 0)
	{

        LoopingAnim(playerid,"KISSING","Grlfrd_Kiss_01",4.0,0,0,0,0,0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/kiss4", true) == 0)
	{
        LoopingAnim(playerid,"KISSING","Grlfrd_Kiss_02",4.0,0,0,0,0,0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/kiss5", true) == 0)
	{
        LoopingAnim(playerid,"KISSING","Grlfrd_Kiss_03",4.0,0,0,0,0,0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/kiss6", true) == 0)
	{
        LoopingAnim(playerid,"KISSING","Playa_Kiss_01",4.0,0,0,0,0,0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/kiss7", true) == 0)
	{
        LoopingAnim(playerid,"KISSING","Playa_Kiss_02",4.0,0,0,0,0,0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/kiss8", true) == 0)
	{
        LoopingAnim(playerid,"KISSING","Playa_Kiss_03",4.0,0,0,0,0,0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/carsit", true) == 0)
	{
        LoopingAnim(playerid,"CAR","Tap_hand", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/carsit2", true) == 0)
	{
        LoopingAnim(playerid,"LOWRIDER","Sit_relaxed", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/fwalk", true) == 0)
	{
        LoopingAnim(playerid,"ped","WOMAN_walksexy",4.1,1,1,1,1,1);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/mwalk", true) == 0)
	{
        LoopingAnim(playerid,"ped","WALK_player",4.1,1,1,1,1,1);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/stretch", true) == 0)
	{
        LoopingAnim(playerid,"PLAYIDLES","stretch",4.0,0,0,0,0,0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/chant", true) == 0)
	{
        LoopingAnim(playerid,"RIOT","RIOT_CHANT", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/angry", true) == 0)
	{
        OnePlayAnim(playerid,"RIOT","RIOT_ANGRY",4.0,0,0,0,0,0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if (strcmp("/crack2", cmdtext, true, 6) == 0)
	{
        OnePlayAnim(playerid, "CRACK", "crckidle2", 4.0, 1, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/ghand1", true) == 0)
	{
	    OnePlayAnim(playerid,"GHANDS","gsign1LH",4.0,0,1,1,1,1);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/ghand2", true) == 0)
	{
	    OnePlayAnim(playerid,"GHANDS","gsign2LH",4.0,0,1,1,1,1);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }
    else if(strcmp(cmdtext, "/ghand3", true) == 0)
	{
	    OnePlayAnim(playerid,"GHANDS","gsign3LH",4.0,0,1,1,1,1);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/ghand4", true) == 0)
	{
	    OnePlayAnim(playerid,"GHANDS","gsign4LH",4.0,0,1,1,1,1);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/ghand5", true) == 0)
	{
	    OnePlayAnim(playerid,"GHANDS","gsign5LH",4.0,0,1,1,1,1);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/exhausted", true) == 0)
	{
	    OnePlayAnim(playerid,"FAT","IDLE_tired", 4.0, 1, 0, 0, 0, 0);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/carsmoke", true) == 0)
	{
	    OnePlayAnim(playerid,"PED","Smoke_in_car", 4.0, 1, 0, 0, 0, 0);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/aim", true) == 0)
	{
	    OnePlayAnim(playerid,"PED","gang_gunstand", 4.0, 1, 0, 0, 0, 0);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/getup", true) == 0)
	{
	    OnePlayAnim(playerid,"PED","getup",4.0,0,0,0,0,0);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/basket1", true) == 0)
	{
	    OnePlayAnim(playerid,"BSKTBALL","BBALL_def_loop", 4.0, 1, 0, 0, 0, 0);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/basket2", true) == 0)
	{
	    OnePlayAnim(playerid,"BSKTBALL","BBALL_idleloop", 4.0, 1, 0, 0, 0, 0);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/basket3", true) == 0)
	{
	    OnePlayAnim(playerid,"BSKTBALL","BBALL_pickup",4.0,0,0,0,0,0);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/basket4", true) == 0)
	{
	    OnePlayAnim(playerid,"BSKTBALL","BBALL_Jump_Shot",4.0,0,0,0,0,0);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/basket5", true) == 0)
	{
	    OnePlayAnim(playerid,"BSKTBALL","BBALL_Dnk",4.1,0,1,1,1,1);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/basket6", true) == 0)
	{
	    OnePlayAnim(playerid,"BSKTBALL","BBALL_run",4.1,1,1,1,1,1);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/akick", true) == 0)
	{
	    OnePlayAnim(playerid,"FIGHT_E","FightKick",4.0,0,0,0,0,0);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/box", true) == 0)
	{
	    OnePlayAnim(playerid,"GYMNASIUM","gym_shadowbox",4.1,1,1,1,1,1);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/cockgun", true) == 0)
	{
	    OnePlayAnim(playerid, "SILENCED", "Silence_reload", 3.0, 0, 0, 0, 0, 0);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/bar1", true) == 0)
	{
	    OnePlayAnim(playerid, "BAR", "Barcustom_get", 3.0, 0, 0, 0, 0, 0);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/bar2", true) == 0)
	{
	    OnePlayAnim(playerid, "BAR", "Barcustom_order", 3.0, 0, 0, 0, 0, 0);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/bar3", true) == 0)
	{
	    OnePlayAnim(playerid, "BAR", "Barserve_give", 3.0, 0, 0, 0, 0, 0);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/bar4", true) == 0)
	{
	    OnePlayAnim(playerid, "BAR", "Barserve_glass", 3.0, 0, 0, 0, 0, 0);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if (strcmp("/lay2", cmdtext, true, 6) == 0)
	{
        OnePlayAnim(playerid,"BEACH", "SitnWait_loop_W", 4.0, 1, 0, 0, 0, 0); // Lay down
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/liftup", true) == 0)
	{
	    OnePlayAnim(playerid, "CARRY", "liftup", 3.0, 0, 0, 0, 0, 0);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/putdown", true) == 0)
	{
	    OnePlayAnim(playerid, "CARRY", "putdwn", 3.0, 0, 0, 0, 0, 0);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/joint", true) == 0)
	{
	    OnePlayAnim(playerid,"GANGS","smkcig_prtl",4.0,0,1,1,1,1);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/die", true) == 0)
	{
	    OnePlayAnim(playerid,"KNIFE","KILL_Knife_Ped_Die",4.1,0,1,1,1,1);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/shakehead", true) == 0)
	{
	    OnePlayAnim(playerid, "MISC", "plyr_shkhead", 3.0, 0, 0, 0, 0, 0);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/shakehead", true) == 0)
	{
	    OnePlayAnim(playerid, "MISC", "plyr_shkhead", 3.0, 0, 0, 0, 0, 0);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/die2", true) == 0)
	{
	    OnePlayAnim(playerid, "PARACHUTE", "FALL_skyDive_DIE", 4.0, 0, 1, 1, 1, -1);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/aim2", true) == 0)
	{
	    OnePlayAnim(playerid, "SHOP", "SHP_Gun_Aim", 4.0, 0, 1, 1, 1, -1);
	    SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
	    return 1;
    }

    else if(strcmp(cmdtext, "/benddown", true) == 0)
	{
        OnePlayAnim(playerid, "BAR", "Barserve_bottle", 4.0, 0, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }

    else if(strcmp(cmdtext, "/checkout", true) == 0)
	{
        OnePlayAnim(playerid, "GRAFFITI", "graffiti_Chkout", 4.0, 0, 0, 0, 0, 0);
        SendClientMessage(playerid,0xFFD700AA, "use /stopanim for stop the anims");
        return 1;
    }
    return 0;
}
