/*---------------------------------------------------------------------------------------------------------

                   Radio System v2.0 Created by GBLTeam
          Me on forum samp: http://forum.sa-mp.com/member.php?u=48181
         Please dont remove this Credits & and dont steal the code !
         There too many new stuff in this new version of my "Radio System".
		 +++++++++++++++++Thanks for using my Radio System+++++++++++++++

---------------------------------------------------------------------------------------------------------*/
//--Radio System - Includes  -- By GBLTeam
#include <a_samp>
#pragma tabsize 0
//--Radio System - Defines -- By GBLTeam
#define dcmd(%1,%2,%3) if (!strcmp((%3)[1], #%1, true, (%2)) && ((((%3)[(%2) + 1] == '\0') && (dcmd_%1(playerid, ""))) || (((%3)[(%2) + 1] == ' ') && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
#define RSystem 4000
#define COLOR_YELLOW 0xDABB3EAA
#define COLOR_GREEN 0x9EC73DAA
#define DIALOG_HELP 5
//----Animations -- By GBLTeam
new gPlayerUsingLoopingAnim[MAX_PLAYERS];
//----Radio System -- By GBLTeam
new Radio[MAX_PLAYERS];
new Radio1[MAX_PLAYERS];
new Radio2[MAX_PLAYERS];
new Radio3[MAX_PLAYERS];
new Radio4[MAX_PLAYERS];
new Radio5[MAX_PLAYERS];
new Radio6[MAX_PLAYERS];
new Radio7[MAX_PLAYERS];
new Radio8[MAX_PLAYERS];
new Radio9[MAX_PLAYERS];
new Radio10[MAX_PLAYERS];
new Radio11[MAX_PLAYERS];
new Radio12[MAX_PLAYERS];
new Radio13[MAX_PLAYERS];
new Radio14[MAX_PLAYERS];
//#######################[Useful]######################################## -- By GBLTeam
//--------------------[OnePlayAnim Command]----------------------

OnePlayAnim(playerid,animlib[],animname[], Float:Speed, looping, lockx, locky, lockz, lp)
{
	ApplyAnimation(playerid, animlib, animname, Speed, looping, lockx, locky, lockz, lp);
}
//--------------------------------------------------------------------

//--------------------[LoopingAnim Command]----------------------

LoopingAnim(playerid,animlib[],animname[], Float:Speed, looping, lockx, locky, lockz, lp)
{
    gPlayerUsingLoopingAnim[playerid] = 1;
    ApplyAnimation(playerid, animlib, animname, Speed, looping, lockx, locky, lockz, lp);
}
//--------------------------------------------------------------------
//#######################[Useful End]##################################### -- By GBLTeam


new AB[][] = // By GBLTeam
{
	"{FFFFFF}----Radio System{008000} by {009BFF}GBLTeam{FFFFFF}---\n",
	"",
	"{FFFFFF}• This script is used for Radio Streaming online for all players.",
	"{FFFFFF}• I made it because i was loving to give us some good radio system with my idea.",
	"",
	"{008000}+{FFFFFF} Created by {009BFF}GBLTeam{FFFFFF}"
};

new VR[][] = // By GBLTeam
{
	"{FFFFFF}----Radio System{008000} by {009BFF}GBLTeam{FFFFFF}---\n",
	"{FFFFFF}Version 2.0 - updated and recoded by the original scripter GBLTeam.",
	"{FFFFFF}This is not simple like the old version 1.0 with only playing radio stations.",
	"{FFFFFF}What i have added in this version ? v2.0 just read it down:.",
	"",
	"",
	"{FFFFFF}• Added everything in dialog with more options.",
	"{FFFFFF}• Options: Radio Stations - Import a Radio Station URL - Other Options - Stop Radio. -",
	"{FFFFFF}• Options: Animations - Stop Animation. -",
	"{FFFFFF}• Added gametext when you play the radio station to tell you which radio station you choused...",
	"{FFFFFF}• Added some animations for fun :)...",
	"{FFFFFF}Maybe this is not all you can check the script :)..",
	"",
	"",
	"{008000}+{FFFFFF} Created by {009BFF}GBLTeam{FFFFFF}"
};
#if defined FILTERSCRIPT
            
            
public OnFilterScriptInit()
{
	print(" ..::: Radio System 2.0 by GBLTeam :::..");
	return 1;
}

#endif
public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	dcmd(radio, 5, cmdtext);
	return 0;
}
dcmd_radio(playerid, params[])
{
            #pragma unused params
            ShowPlayerDialog(playerid, RSystem, DIALOG_STYLE_LIST, "Radio System by GBLTeam", "{009BFF}Radio Stations\n{FFFFFF}Import a Radio URL\n{FFFFFF}Other Options\n{009BFF}Animations\n{FFFFFF}[STOP RADIO]\n{FFFFFF}[STOP ANIMATION]", "Okay", "Exit");
            return SendClientMessage(playerid,COLOR_GREEN,"Chouse some option what you need.");
    }
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == RSystem) // RSystem -- by GBLTeam
	{
 		if(response)
		{
   			if(listitem == 0)
			{
                ShowPlayerDialog(playerid, 101, DIALOG_STYLE_LIST, "Radio System by GBLTeam", "{FF1400}0-Jazz Radio\n{FFB400}1-.977(Rock)\n{DCDCDC}2-181FM(Rock)\n{19FF00}3-Cinemix(CLassical)\n{FF00D7}4-Reggae141\n{CD0000}5-Infowars(Real talk)\n{2800FF}6-Comedy\n{F5FF00}7-BBC News\n{C800FF}8-HotJamz(Hip Hop)\n{FF6400}9-Xtreme(Metal)\n{FFD200}10-Metal\n{FF3C00}11-Hindi\n{EBFF00}12-Trance\n{007DFF}13- UG Rap\n{00FFF0}14-Urban", "Okay", "Exit");
			}
			if(listitem == 1)
			{
                ShowPlayerDialog(playerid, 102, DIALOG_STYLE_INPUT, "Radio System by GBLTeam","{FFFFFF}Write the {009BFF}URL{FFFFFF} from Radio Station:", "Okay", "Exit");
			}
			if(listitem == 2)
			{
                ShowPlayerDialog(playerid, 103, DIALOG_STYLE_LIST, "Radio System by GBLTeam", "{009BFF}About\n{FFFFFF}Version", "Okay", "Exit");
			}
			if(listitem == 3)
			{
                ShowPlayerDialog(playerid, 104, DIALOG_STYLE_LIST, "Radio System by GBLTeam", "{009BFF}Dance\n{FFFFFF}Rap\n{00FFFF}Drunk\n{FFF000}Laugh\n{FF9600}Lay\n{00FF28}SmokeF\n{E600FF}SmokingM\n{D2D2D2}Crossarms\n{D70000}Lookout\n{FF009B}Sex\n{5A00FF}Ciggy\n{B9FF00}Piss\n{A000FF}Beer\n{FF002D}Wine\n{AFFF00}Wank\n{969696}Kiss", "Okay", "Exit");
			}
			if(listitem == 4)
			{
                StopAudioStreamForPlayer(playerid);
                GameTextForPlayer(playerid, "Radio Stopped.",2500,1);
			}
			if(listitem == 5)
			{
                ClearAnimations(playerid);
                GameTextForPlayer(playerid, "Animations Stopped.",2500,1);
			}
			return 1;
        }
    }
	if(dialogid == 101) // by GBLTeam Scripter & Coder
	{
		if(response)
		{
			if(listitem == 0)// (1-Jazz Radio)
			{//
           Radio[playerid] = PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=674096");
           GameTextForPlayer(playerid, "Playing Jazz...",2500,1);
			}
			if(listitem == 1)// (2-.977(Rock))
			{//
           Radio1[playerid] = PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=1280356");
           GameTextForPlayer(playerid, "Playing 977-Rock...",2500,1);
			}
			if(listitem == 2)// (3-181FM(Rock))
			{
           Radio2[playerid] = PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=301250");
           GameTextForPlayer(playerid, "Playing 181FM-Rock...",2500,1);
			}
			if(listitem == 3)// (4-Cinemix(CLassical))
			{
           Radio3[playerid] = PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=614375");
           GameTextForPlayer(playerid, "Playing Cinemax...",2500,1);
			}
			if(listitem == 4)// (5-Reggae141)
			{
           Radio4[playerid] = PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=1280855");
           GameTextForPlayer(playerid, "Playing Reggae141...",2500,1);
			}
			if(listitem == 5)// (6-Infowars(Real talk))
			{
           Radio5[playerid] = PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=1026951");
           GameTextForPlayer(playerid, "Playing Infowars...",2500,1);
			}
			if(listitem == 6)// (7-Comedy)
			{
           Radio6[playerid] = PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=9463");
           GameTextForPlayer(playerid, "Playing Comedy...",2500,1);
			}
			if(listitem == 7)// (8-BBC News)
			{
           Radio7[playerid] = PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=1377212");
           GameTextForPlayer(playerid, "Playing BBC News...",2500,1);
			}
			if(listitem == 8)// (9-HotJamz(Hip Hop))
			{
           Radio8[playerid] = PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=1281016");
           GameTextForPlayer(playerid, "Playing HotJamz...",2500,1);
			}
			if(listitem == 9)// (10-Xtreme(Metal))
			{
           Radio9[playerid] = PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=1275071");
           GameTextForPlayer(playerid, "Playing Xtreme Metal...",2500,1);
			}
			if(listitem == 10)// (11-Metal)
			{
           Radio10[playerid] = PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=1280610");
           GameTextForPlayer(playerid, "Playing Metal...",2500,1);
			}
			if(listitem == 11)// (12-Hindi)
           {
           Radio11[playerid] = PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=1275743");
           GameTextForPlayer(playerid, "Playing Hindi...",2500,1);
			}
			if(listitem == 12)// (13-Trance)
			{
           Radio12[playerid] = PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=1193516");
           GameTextForPlayer(playerid, "Playing Trance...",2500,1);
			}
			if(listitem == 13)// (14- UG Rap)
			{
           Radio13[playerid] = PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=9054");
           GameTextForPlayer(playerid, "Playing UG-Rap...",2500,1);
			}
			if(listitem == 14)// (14-Urban)
			{
           Radio14[playerid] = PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=702448");
           GameTextForPlayer(playerid, "Playing Urban...",2500,1);
			}
			return 1;
        }
    }
	if(dialogid == 102) //
	{
      if(response)
		 {
      for(new i=0; i<250; i++)
     {
       if(IsPlayerConnected(i))
      {
           PlayAudioStreamForPlayer(i, inputtext);
         }
      }
    }
}
	if(dialogid == 104) // by GBLTeam -- Scripter & Coder
	{
		if(response)
		{
			if(listitem == 0)// (Dancing)
			{//
           SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE1);
           GameTextForPlayer(playerid, "Dancing...",2500,1);
			}
			if(listitem == 1)// (Rap)
			{//
           ApplyAnimation(playerid,"RAPPING","RAP_B_Loop",4.0,1,1,1,1,0);
           GameTextForPlayer(playerid, "Rap...",2500,1);
			}
			if(listitem == 2)// (Drunk)
			{
           LoopingAnim(playerid,"PED","WALK_DRUNK",4.0,1,1,1,0,0);
           GameTextForPlayer(playerid, "Drunk...",2500,1);
			}
			if(listitem == 3)// (Laugh)
			{
           OnePlayAnim(playerid, "RAPPING", "Laugh_01", 4.0, 0, 0, 0, 0, 0);
           GameTextForPlayer(playerid, "Laugh..",2500,1);
			}
			if(listitem == 4)// (Lay)
			{
           LoopingAnim(playerid,"BEACH", "bather", 4.0, 1, 0, 0, 0, 0);
           GameTextForPlayer(playerid, "Lay...",2500,1);
			}
			if(listitem == 5)// (Smokeing Female)
			{
           LoopingAnim(playerid, "SMOKING", "F_smklean_loop", 4.0, 1, 0, 0, 0, 0);
           GameTextForPlayer(playerid, "Smokeing Female...",2500,1);
			}
			if(listitem == 6)// (Someking Male)
			{
           LoopingAnim(playerid,"SMOKING", "M_smklean_loop", 4.0, 1, 0, 0, 0, 0);
           GameTextForPlayer(playerid, "Smokeing Male...",2500,1);
			}
			if(listitem == 7)// (CrossArms)
			{
           LoopingAnim(playerid, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1);
           GameTextForPlayer(playerid, "CrossArms...",2500,1);
			}
			if(listitem == 8)// (Lookout)
			{
           OnePlayAnim(playerid, "SHOP", "ROB_Shifty", 4.0, 0, 0, 0, 0, 0);
           GameTextForPlayer(playerid, "Lookout...",2500,1);
			}
			if(listitem == 9)// (Sex)
			{
           LoopingAnim(playerid,"SNM","SPANKING_ENDW",4.1,0,1,1,1,1);
           GameTextForPlayer(playerid, "Sex...",2500,1);
			}
			if(listitem == 10)// (Ciggy)
			{
           SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
           GameTextForPlayer(playerid, "Ciggy...",2500,1);
			}
			if(listitem == 11)// (Piss)
           {
           SetPlayerSpecialAction(playerid, 68);
           GameTextForPlayer(playerid, "Pissing...",2500,1);
			}
			if(listitem == 12)// (Beer)
			{
           SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);
           GameTextForPlayer(playerid, "Drink Beer...",2500,1);
			}
			if(listitem == 13)// (Wine)
			{
          SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_WINE);
           GameTextForPlayer(playerid, "Drink Wine...",2500,1);
			}
			if(listitem == 14)// (Wank)
			{
           LoopingAnim(playerid,"PAULNMAC","wank_loop",4.0,1,1,1,1,0);
           GameTextForPlayer(playerid, "Wanking...",2500,1);
			}
			if(listitem == 14)// (Kiss)
			{
           LoopingAnim(playerid,"KISSING","Grlfrd_Kiss_02",4.0,1,0,0,1,0);
           GameTextForPlayer(playerid, "Kiss...",2500,1);
			}
			return 1;
        }
    }
	if(dialogid == 103) // by GBLTeam -- Scripter & Coder
	{
      if(response)
		 {
		 if(listitem == 0)// R3 System
         {//

	    new string[1024];
	    format(string,1024,"%s\n%s\n%s\n%s\n%s\n%s",AB[0],AB[1],AB[2],AB[3],AB[4],AB[5]);
        ShowPlayerDialog(playerid,DIALOG_HELP,DIALOG_STYLE_MSGBOX, "{FFFFFF}Radio System{008000} - {FFFFFF}About",string,"Okay","Exit");
         }
         if(listitem == 1)
         {
	    new string[1024];
	    format(string,1024,"%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s",VR[0],VR[1],VR[2],VR[3],VR[4],VR[5],VR[6],VR[7],VR[8],VR[9],VR[10],VR[11],VR[12],VR[13],VR[14]);
        ShowPlayerDialog(playerid,DIALOG_HELP,DIALOG_STYLE_MSGBOX, "{FFFFFF}Radio System{008000} - {FFFFFF}Version",string,"Okay","Exit");

            }
		}
 	}
	return 1;
}
//------------End ---- Coded & Scripted by GBLTeam ------ Do not steal or remove the credits !-----//
