#include a_samp
#include dini
#define Red 0xFF0000FF
#define Blue 0x0000FFFF
#define Yellow 0xFFFF00FF
#define Green 0x008000FF
#define Black 0x000000FF
#define Purple 0x800080FF
#define Orange 0xFFA500FF
#define Gray 0x808080FF
#define Gold 0xFFD700FF
#define Pink 0xFFC0CBFF
#define Silver 0xC0C0C0FF
#define LightBlue 0xADD8E6FF
#define GreenYellow 0xADFF2FFF
#define DarkGreen 0x006400FF
#define LightYellow 0xFFFFE0FF
#define LightPink 0xFFB6C1FF
#define LightCoral 0xF08080FF
#define DarkGray 0xA9A9A9FF
#define White 0xFFFFFFFF
#define Brown 0x400000FF

public OnPlayerCommandText(playerid, cmdtext[])
{
    if (strcmp("/Colors", cmdtext, true) == 0) {
        ShowPlayerDialog(playerid, 24, DIALOG_STYLE_LIST, "Choose The Color WhatEver You Like", "Red\nBlue\nYellow\nGreen\nBlack\nPurple\nOrange\nBrown\nGray\nWhite\nGold\nPink\nSilver\nLightBlue\nGreenYellow\nDarkGreen\nLightYellow\nLightPink\nLightCoral\nDarkGray", "Select", "Cancel");
        return 1;
    }
    return 0;
}


public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 24) {
        if(response) {
            if(listitem == 0) {
                SetPlayerColor(playerid,Red);
            }
            if(listitem == 1) {
                SetPlayerColor(playerid,Blue);
            }
            if(listitem == 2) {
                SetPlayerColor(playerid,Yellow);
            }
            if(listitem == 3) {
                SetPlayerColor(playerid,Green);
            }
            if(listitem == 4) {
                SetPlayerColor(playerid,Black);
            }
            if(listitem == 5) {
                SetPlayerColor(playerid,Purple);
            }
            if(listitem == 6) {
                SetPlayerColor(playerid,Orange);
            }
            if(listitem == 7) {
                SetPlayerColor(playerid,Brown);
            }
            if(listitem == 8) {
                SetPlayerColor(playerid,Gray);
            }
            if(listitem == 9) {
                SetPlayerColor(playerid,White);
            }
            if(listitem == 10) {
                SetPlayerColor(playerid,Gold);
            }
            if(listitem == 11) {
                SetPlayerColor(playerid,Silver);
            }
            if(listitem == 12) {
                SetPlayerColor(playerid,LightBlue);
            }
            if(listitem == 13) {
                SetPlayerColor(playerid,GreenYellow);
            }
            if(listitem == 14) {
                SetPlayerColor(playerid,DarkGreen);
            }
            if(listitem == 15) {
                SetPlayerColor(playerid,LightYellow);
            }
            if(listitem == 16) {
                SetPlayerColor(playerid,LightPink);
            }
            if(listitem == 17) {
                SetPlayerColor(playerid,LightCoral);
            }
            if(listitem == 18) {
                SetPlayerColor(playerid,DarkGray);
            }
        }
    }
    return 1;
}


//Enjoy :D
