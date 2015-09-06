#include <a_samp>
#include <../include/gl_common.inc>

new Object[MAX_PLAYERS],
	Text[MAX_PLAYERS][128],
	Size[MAX_PLAYERS] = 50,
	Index[MAX_PLAYERS] = 0,
	UseBold[MAX_PLAYERS] = 0,
	TextAlign[MAX_PLAYERS] = 1,
	FontName[MAX_PLAYERS][128],
	FontSize[MAX_PLAYERS] = 24,
	TextColor[MAX_PLAYERS],
	BackgColor[MAX_PLAYERS],
	OName[MAX_PLAYERS][30],
	ObjectID[MAX_PLAYERS] = 19353,
	Float:Pos[4], Float:Rot[3];
	
new bool:ObjectType[MAX_PLAYERS] = false,
	bool:CreatingTextO[MAX_PLAYERS] = false;

#define R               "{FF0000}" //Red
#define G               "{C4C4C4}" //Grey
#define Y               "{EEEA00}" //Yellow
#define B            	"{00A7EE}" //Blue


#define MainDialog      0
#define OTypeDialog     1
#define OModelDialog    2
#define TextDialog      3
#define IndexDialog     4
#define SizesDialog     5
#define FontNDialog     6
#define FontSDialog     7
#define BoldDialog      8
#define ColorDialog     9
#define BackgDialog     10
#define BackgColorD     11
#define AlignDialog     12
#define SaveDialog      13
#define ColorDialog2    14
#define ColorDialog3    15
#define ColorDialog4    16
#define ColorDialog5    17

public OnFilterScriptInit()
{
	print("       ____________________________");
	print("      |-Text Object Editor Loaded- |");
	print("      |   Scripted by irinel1996   |");
	print("      |    Copyright © 2012-2013   |");
	print("      |      Keep the credits!     |");
	print("      |____________________________|");
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/createot", true) || !strcmp(cmdtext, "/cto", true) || !strcmp(cmdtext, "/create", true))
    {
        if(CreatingTextO[playerid] == false)
        {
			TextAlign[playerid] = 1,
            Text[playerid] = "Example",
			FontName[playerid] = "Arial",
			TextColor[playerid] = HexToInt("0xFFFF8200"),
			BackgColor[playerid] = HexToInt("0xFF000000");
			
        	CreatingTextO[playerid] = true, ShowMainMenu(playerid);
        	GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]), GetPlayerFacingAngle(playerid, Pos[3]);
        	new Float:x = Pos[0] + (5.0 * floatsin(-Pos[3], degrees));
    		new Float:y = Pos[1] + (5.0 * floatcos(-Pos[3], degrees));
    		
        	Object[playerid] = CreatePlayerObject(playerid, ObjectID[playerid], x, y, Pos[2]+0.5, 0.0, 0.0, Pos[3] - 90.0);
        	
        	SetPlayerObjectMaterialText(playerid, Object[playerid], Text[playerid], Index[playerid], Size[playerid], FontName[playerid],
			FontSize[playerid], UseBold[playerid], TextColor[playerid], BackgColor[playerid], TextAlign[playerid]);
			
			SendClientMessage(playerid,-1,""R"* "B"INFO: "Y"New Text Object created.");
		} else { ShowMainMenu(playerid); }
        return 1;
    }
    if(!strcmp(cmdtext, "/test", true))
    {
        new MiObjeto = CreateObject(19353, 1965.633911, 1343.049560, 15.874607, 0.000000, 0.000000, 179.142486);
		SetObjectMaterialText(MiObjeto, "Example", 0, 50, "Arial", 24, 0, -32256, -16777216, 1);
        return 1;
    }
    return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == MainDialog){
	    if(response){
	        switch(listitem) {
	            case 0:{
					new string[128], type[30];
					if(ObjectType[playerid] == false) type = "Normal Object";
					else if(ObjectType[playerid] == true) type = "Player Object";
					format(string, sizeof(string),""B"Curret Object Type: "Y"%s\
					\n"G"Please, select your Object Type below:",type);
					ShowPlayerDialog(playerid,OTypeDialog,DIALOG_STYLE_MSGBOX,"    "R"Object Type",string,"Normal O.","Player O.");
	            }
	            case 1:{
	                new string[128];
	                format(string, sizeof(string), ""B"Current Object Model ID: "Y"%d\
					\n"G"Please, type below a Model ID for the object (example = 19353):",ObjectID[playerid]);
					ShowPlayerDialog(playerid,OModelDialog,DIALOG_STYLE_INPUT,"    "R"Object Model ID",string,"Change","Back");
	            }
	        	case 2:{
	        	    new string[300];
	        	    format(string, sizeof(string),""B"Current Object Text: "Y"%s\
					\n"G"Please, type below your text for the object:",Text[playerid]);
	        	    ShowPlayerDialog(playerid,TextDialog,DIALOG_STYLE_INPUT,"    "R"Object Text",string,"Change","Back");
	        	}
	        	case 3: {
					new string[128];
					format(string, sizeof(string),""B"Current Material Index: "Y"%d\
					\n"G"Please, type below the Material Index which you want use (default = 0):",Index[playerid]);
					ShowPlayerDialog(playerid,IndexDialog,DIALOG_STYLE_INPUT,"    "R"Material Index",string,"Change","Back");
				}
				case 4: {
				    new sizes[600];
					strcat(sizes,""Y"1. "B"32x32 "G"(10)\
								\n"Y"2. "B"64x32 "G"(20)\
								\n"Y"3. "B"64x64 "G"(30)\
								\n"Y"4. "B"128x32 "G"(40)\
								\n"Y"5. "B"128x64 "G"(50)\
								\n"Y"6. "B"128x128 "G"(60)\
								\n"Y"7. "B"256x32 "G"(70)");
					strcat(sizes,"\n"Y"8. "B"256x64 "G"(80)\
								\n"Y"9. "B"256x128 "G"(90)\
								\n"Y"10. "B"256x256 "G"(100)\
								\n"Y"11. "B"512x64 "G"(110)\
								\n"Y"12. "B"512x128 "G"(120)\
								\n"Y"13. "B"512x256 "G"(130)\
								\n"Y"14. "B"512x512 "G"(140)");
					new current[128];
					format(current, sizeof(current),""R"Material Size "G"| "B"Current size: "Y"%d",Size[playerid]);
					ShowPlayerDialog(playerid,SizesDialog,DIALOG_STYLE_LIST,current,sizes,"Change","Back");
				}
				case 5: {
				    new string[128];
				    format(string, sizeof(string), ""B"Current Text Font: "Y"%s\
					\n"G"Please, type below the Text Font name which you want use:",FontName[playerid]);
                    ShowPlayerDialog(playerid,FontNDialog,DIALOG_STYLE_INPUT,"    "R"Text Font",string,"Change","Back");
				}
				case 6: {
				    new string[128];
				    format(string, sizeof(string), ""B"Current Text Size: "Y"%d\
					\n"G"Please, type below the Text Size which you want use:",FontSize[playerid]);
                    ShowPlayerDialog(playerid,FontSDialog,DIALOG_STYLE_INPUT,"    "R"Text Size",string,"Change","Back");
				}
				case 7: {
				    new title[100]; new yesorno[10];
				    if(UseBold[playerid] == 0) yesorno = "No";
				    else if(UseBold[playerid] == 1) yesorno = "Yes";
				    format(title, sizeof(title), ""R"Bold Text "G"| "B"Using Bold Text: "Y"%s",yesorno);
                    ShowPlayerDialog(playerid,BoldDialog,DIALOG_STYLE_LIST,title,""Y"1. "B"No\n"Y"2. "B"Yes","Change","Back");
				}
				case 8: {
				    new titulo[100];
				    format(titulo, sizeof(titulo),""R"Text Color "G"| "B"Current Text Color: "Y"%i",TextColor[playerid]);
                    ShowPlayerDialog(playerid,ColorDialog,DIALOG_STYLE_LIST,titulo,""Y"1. "B"Type a ARGB color code\
					\n"Y"2. "B"Select a predefinded color","Next","Back");
				}
				case 9: {
				    new titulo[100];
				    format(titulo, sizeof(titulo),""R"Object Background "G"| "B"Current Text Color: "Y"%i",BackgColor[playerid]);
                    ShowPlayerDialog(playerid,BackgColorD,DIALOG_STYLE_LIST,titulo,""Y"1. "B"Disable Background\n"Y"2. "B"Type a ARGB color code\
					\n"Y"3. "B"Select a predefinded color","Next","Back");
				}
				case 10: {
                    new title[100]; new position[30];
				    if(TextAlign[playerid] == 0) position = "Left";
				    else if(TextAlign[playerid] == 1) position = "Center";
				    else if(TextAlign[playerid] == 2) position = "Right";
				    format(title, sizeof(title), ""R"Text Alignment "G"| "B"Current Alignment: "Y"%s",position);
                    ShowPlayerDialog(playerid,AlignDialog,DIALOG_STYLE_LIST,title,""Y"1. "B"Left\n"Y"2. "B"Center\n"Y"3. "B"Right","Change","Back");
				}
				case 11: {
				    EditPlayerObject(playerid, Object[playerid]);
					SendClientMessage(playerid,-1,""R"* "B"INFO: "Y"Use "G"ESC "Y"to cancel the object edition.");
				}
				case 12: {
				    ShowPlayerDialog(playerid,SaveDialog,DIALOG_STYLE_INPUT,"    "R"Exporting Lines",
					"Please, type a name for the object below (example = MyObject):","Export","Back");
				}
				case 13: {
                    CreatingTextO[playerid] = false, DestroyPlayerObject(playerid, Object[playerid]);
					TextAlign[playerid] = 1, Text[playerid] = "Example", FontName[playerid] = "Arial",
					TextColor[playerid] = HexToInt("0xFFFF8200"), BackgColor[playerid] = HexToInt("0xFF000000"),
					Size[playerid] = 50, Index[playerid] = 0, UseBold[playerid] = 0,
					FontSize[playerid] = 24, OName[playerid] = "0", ObjectID[playerid] = 19353;
					SendClientMessage(playerid,-1,""R"* "B"INFO: "Y"All settings have been reseted.");
				}
	        }
	    }
	    return 1;
	}
	if(dialogid == OTypeDialog)
	{
	    if(response)
	    {
	        ObjectType[playerid] = false;
	        SendClientMessage(playerid,-1,""R"* "B"Object Type: "Y"Normal Object"); ShowMainMenu(playerid);
	    } else {
			ObjectType[playerid] = true;
            SendClientMessage(playerid,-1,""R"* "B"Object Type: "Y"Player Object"); ShowMainMenu(playerid);
		}
	    return 1;
	}
	if(dialogid == OModelDialog)
	{
	    if(response)
	    {
	        if(!isNumeric(inputtext)) return SendClientMessage(playerid,-1,""Y"* "R"ERROR: "G"Please, use a numeric value"R"!"), ShowMainMenu(playerid);
	        new string[128];
	        ObjectID[playerid] = strval(inputtext);
	        format(string, sizeof(string), ""R"* "B"Object Model ID: "Y"%d",ObjectID[playerid]);
	        SendClientMessage(playerid,-1,string); UpdateObject(playerid), ShowMainMenu(playerid);
	    } else { ShowMainMenu(playerid); }
	    return 1;
	}
	if(dialogid == TextDialog){
	    if(response){
	        new string[128];
	        format(string, sizeof(string),"%s",inputtext);
	        Text[playerid] = string; format(string, sizeof(string), ""R"* "B"Object Text: "Y"%s",Text[playerid]);
	        SendClientMessage(playerid,-1,string); UpdateObject(playerid), ShowMainMenu(playerid);
	    } else { ShowMainMenu(playerid); }
		return 1;
	}
	if(dialogid == IndexDialog){
	    if(response){
	        if(!isNumeric(inputtext)) return SendClientMessage(playerid,-1,""Y"* "R"ERROR: "G"Please, use a numeric value"R"!"), ShowMainMenu(playerid);
			new string[100];
			Index[playerid] = strval(inputtext);
			format(string, sizeof(string),""R"* "B"Object Material Index: "Y"%d",Index[playerid]);
			SendClientMessage(playerid,-1,string); UpdateObject(playerid), ShowMainMenu(playerid);
	    } else { ShowMainMenu(playerid); }
		return 1;
	}
	if(dialogid == SizesDialog){
	    if(response)
	    {
	        switch(listitem) {
	            case 0: Size[playerid] = 10;
	            case 1:  Size[playerid] = 20;
	            case 2:  Size[playerid] = 30;
	            case 3:  Size[playerid] = 40;
	            case 4:  Size[playerid] = 50;
	            case 5:  Size[playerid] = 60;
	            case 6:  Size[playerid] = 70;
	            case 7:  Size[playerid] = 80;
	            case 8:  Size[playerid] = 90;
	            case 9:  Size[playerid] = 100;
	            case 10:  Size[playerid] = 110;
	            case 11:  Size[playerid] = 120;
	            case 12:  Size[playerid] = 130;
	            case 13:  Size[playerid] = 140;
	            default: Size[playerid] = 70;
			}
			new string[128];
			format(string, sizeof(string), ""R"* "B"Object Material Size: "Y"%d",Size[playerid]);
			SendClientMessage(playerid,-1,string); UpdateObject(playerid), ShowMainMenu(playerid);
	    } else { ShowMainMenu(playerid); }
	    return 1;
	}
	if(dialogid == FontNDialog)
	{
	    if(response) {
	        new string[128]; format(string, sizeof(string),"%s",inputtext); FontName[playerid] = string;
	        format(string, sizeof(string), ""R"* "B"Text Font: "Y"%s",FontName[playerid]); SendClientMessage(playerid,-1,string);
			UpdateObject(playerid), ShowMainMenu(playerid);
	    } else { ShowMainMenu(playerid); }
	    return 1;
	}
	if(dialogid == FontSDialog)
	{
	    if(response) {
	        if(!isNumeric(inputtext)) return SendClientMessage(playerid,-1,""Y"* "R"ERROR: "G"Please, use a numeric value"R"!"), ShowMainMenu(playerid);
	        new string[128]; FontSize[playerid] = strval(inputtext);
			format(string, sizeof(string), ""R"* "B"Text Size: "Y"%d",FontSize[playerid]); SendClientMessage(playerid,-1,string);
			UpdateObject(playerid), ShowMainMenu(playerid);
	    } else { ShowMainMenu(playerid); }
	    return 1;
	}
	if(dialogid == BoldDialog)
	{
	    if(response)
	    {
			switch(listitem)
			{
	        	case 0: {
                    UseBold[playerid] = 0;
	        		SendClientMessage(playerid,-1,""R"* "B"Bold Text: "Y"No");
	        		UpdateObject(playerid), ShowMainMenu(playerid);
				}
				case 1: {
				    UseBold[playerid] = 1;
	        		SendClientMessage(playerid,-1,""R"* "B"Bold Text: "Y"Yes");
	        		UpdateObject(playerid), ShowMainMenu(playerid);
				}
			}
	    } else { ShowMainMenu(playerid); }
	    return 1;
	}
	if(dialogid == ColorDialog)
	{
	    if(response)
	    {
			switch(listitem)
			{
			    case 0: {
			        ShowPlayerDialog(playerid,ColorDialog2,DIALOG_STYLE_INPUT,"    "R"Text Color",
			        ""G"Please, type a ARGB color code below (example = 0xFFFF0000):","Change","Back");
			    }
			    case 1: {
			        ShowPlayerDialog(playerid,ColorDialog3,DIALOG_STYLE_LIST,""R"Color List",
			        "{FF0000}Red\n{04B404}Green\n{00B5CD}Sky-Blue\n{FFFF00}Yellow\
					\n{0000FF}Blue\n{848484}Grey\n{FF00FF}Pink\n{FFFFFF}White","Change","Back");
			    }
			}
	    } else { ShowMainMenu(playerid); }
	    return 1;
	}
	if(dialogid == ColorDialog2)
	{
	    if(response) {
	    	new string[80]; TextColor[playerid] = HexToInt(inputtext);
			format(string, sizeof(string),""R"* "B"Text Color: "Y"%i", TextColor[playerid]);
			SendClientMessage(playerid,-1,string); UpdateObject(playerid), ShowMainMenu(playerid);
		} else {
		    new titulo[100];
		    format(titulo, sizeof(titulo),""R"Text Color "G"| "B"Current Text Color: "Y"%i",TextColor[playerid]);
            ShowPlayerDialog(playerid,ColorDialog,DIALOG_STYLE_LIST,titulo,""Y"1. "B"Type a ARGB color code\
			\n"Y"2. "B"Select a predefinded color","Next","Back");
		}
   		return 1;
	}
	if(dialogid == ColorDialog3)
	{
	    if(response) {
	        switch(listitem)
	        {
	            case 0: { TextColor[playerid] = HexToInt("0xFFFF0000"); } //Red
	            case 1: { TextColor[playerid] = HexToInt("0xFF04B404"); }
	            case 2: { TextColor[playerid] = HexToInt("0xFF00B5CD"); }
	            case 3: { TextColor[playerid] = HexToInt("0xFFFFFF00"); } //Yellow
	            case 4: { TextColor[playerid] = HexToInt("0xFF0000FF"); }
	            case 5: { TextColor[playerid] = HexToInt("0xFF848484"); }
	            case 6: { TextColor[playerid] = HexToInt("0xFFFF00FF"); }
	            case 7: { TextColor[playerid] = HexToInt("0xFFFFFFFF"); } //White
	        }
	        new string[80]; UpdateObject(playerid);
	        format(string, sizeof(string),""R"* "B"Text Color: "Y"%i", TextColor[playerid]);
			SendClientMessage(playerid,-1,string); ShowMainMenu(playerid);
		} else {
		    new titulo[100];
		    format(titulo, sizeof(titulo),""R"Text Color "G"| "B"Current Text Color: "Y"%i",TextColor[playerid]);
            ShowPlayerDialog(playerid,ColorDialog,DIALOG_STYLE_LIST,titulo,""Y"1. "B"Type a ARGB color code\
			\n"Y"2. "B"Select a predefinded color","Next","Back");
		}
   		return 1;
	}
	if(dialogid == BackgColorD)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0: { BackgColor[playerid] = 0; UpdateObject(playerid);  ShowMainMenu(playerid); SendClientMessage(playerid,-1,""R"* "B"Background Color: "Y"Disabled"); }
	            case 1: {
	                ShowPlayerDialog(playerid,ColorDialog4,DIALOG_STYLE_INPUT,"    "R"Background Color",
			        ""G"Please, type a ARGB color code below (example = 0xFFFF0000):","Change","Back");
	            }
	            case 2: {
	                ShowPlayerDialog(playerid,ColorDialog5,DIALOG_STYLE_LIST,""R"Color List",
			        "{FF0000}Red\n{04B404}Green\n{00B5CD}Sky-Blue\n{FFFF00}Yellow\
					\n{0000FF}Blue\n{848484}Grey\n{FF00FF}Pink\n{FFFFFF}White","Change","Back");
	            }
	        }
	    } else { ShowMainMenu(playerid); }
	    return 1;
	}
	if(dialogid == ColorDialog4)
	{
	    if(response) {
	    	new string[80]; BackgColor[playerid] = HexToInt(inputtext);
			format(string, sizeof(string),""R"* "B"Background Color: "Y"%i", BackgColor[playerid]);
			SendClientMessage(playerid,-1,string); UpdateObject(playerid), ShowMainMenu(playerid);
		} else {
		    new titulo[100];
		    format(titulo, sizeof(titulo),""R"Object Background "G"| "B"Current Text Color: "Y"%i",BackgColor[playerid]);
            ShowPlayerDialog(playerid,BackgColorD,DIALOG_STYLE_LIST,titulo,""Y"1. "B"Disable Background\n"Y"2. "B"Type a ARGB color code\
			\n"Y"3. "B"Select a predefinded color","Next","Back");
		}
   		return 1;
	}
	if(dialogid == ColorDialog5)
	{
	    if(response) {
	        switch(listitem)
	        {
	            case 0: { BackgColor[playerid] = HexToInt("0xFFFF0000"); } //Red
	            case 1: { BackgColor[playerid] = HexToInt("0xFF04B404"); }
	            case 2: { BackgColor[playerid] = HexToInt("0xFF00B5CD"); }
	            case 3: { BackgColor[playerid] = HexToInt("0xFFFFFF00"); } //Yellow
	            case 4: { BackgColor[playerid] = HexToInt("0xFF0000FF"); }
	            case 5: { BackgColor[playerid] = HexToInt("0xFF848484"); }
	            case 6: { BackgColor[playerid] = HexToInt("0xFFFF00FF"); }
	            case 7: { BackgColor[playerid] = HexToInt("0xFFFFFFFF"); } //White
	        }
	        new string[80]; UpdateObject(playerid); ShowMainMenu(playerid);
	        format(string, sizeof(string),""R"* "B"Background Color: "Y"%i", BackgColor[playerid]);
			SendClientMessage(playerid,-1,string);
		} else {
		    new titulo[100];
		    format(titulo, sizeof(titulo),""R"Object Background "G"| "B"Current Text Color: "Y"%i",BackgColor[playerid]);
            ShowPlayerDialog(playerid,BackgColorD,DIALOG_STYLE_LIST,titulo,""Y"1. "B"Disable Background\n"Y"2. "B"Type a ARGB color code\
			\n"Y"3. "B"Select a predefinded color","Next","Back");
		}
   		return 1;
	}
	if(dialogid == AlignDialog)
	{
	    if(response) {
			switch(listitem)
			{
			    case 0: {
					TextAlign[playerid] = 0; UpdateObject(playerid);
					SendClientMessage(playerid,-1,""R"* "B"Text Alignment: "Y"Left"), ShowMainMenu(playerid);
				}
				case 1: {
					TextAlign[playerid] = 1; UpdateObject(playerid);
					SendClientMessage(playerid,-1,""R"* "B"Text Alignment: "Y"Center"), ShowMainMenu(playerid);
				}
				case 2: {
					TextAlign[playerid] = 2; UpdateObject(playerid);
					SendClientMessage(playerid,-1,""R"* "B"Text Alignment: "Y"Right"), ShowMainMenu(playerid);
				}
			}
		} else { ShowMainMenu(playerid); }
	}
	if(dialogid == SaveDialog)
	{
	    if(response)
	    {
	        if(strlen(inputtext) <= 0) return SendClientMessage(playerid,-1,""Y"* "R"ERROR: "G"Please, type something for the object name"R"!"), ShowMainMenu(playerid);
			new string[600], soname[30];
			format(soname, sizeof(soname),"%s",inputtext); OName[playerid] = soname;
		    new Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ;
		    GetPlayerObjectPos(playerid, Object[playerid], fX, fY, fZ),
			GetPlayerObjectRot(playerid, Object[playerid], fRotX, fRotY, fRotZ);
		    if(!fexist("textobjects.txt"))
			{
			    new File:archivo = fopen("textobjects.txt", io_write);
			    if(ObjectType[playerid] == false) {
			        format(string, sizeof(string),"new %s = CreateObject(%d, %0.4f, %0.4f, %0.4f, %0.4f, %0.4f, %0.4f);\
					\r\nSetObjectMaterialText(%s, \"%s\", %d, %d, \"%s\", %d, %d, %i, %i, %d);",OName[playerid],ObjectID[playerid],
					fX, fY, fZ, fRotX, fRotY, fRotZ, OName[playerid], Text[playerid], Index[playerid], Size[playerid], FontName[playerid],
					FontSize[playerid], UseBold[playerid], TextColor[playerid], BackgColor[playerid], TextAlign[playerid]);
			        fwrite(archivo,string);
			        fclose(archivo);
			    } else {
					format(string, sizeof(string),"new %s = CreatePlayerObject(playerid, %d, %0.4f, %0.4f, %0.4f, %0.4f, %0.4f, %0.4f);\
					\r\nSetPlayerObjectMaterialText(playerid, %s, \"%s\", %d, %d, \"%s\", %d, %d, %i, %i, %d);",OName[playerid],ObjectID[playerid],
					fX, fY, fZ, fRotX, fRotY, fRotZ, OName[playerid], Text[playerid], Index[playerid], Size[playerid], FontName[playerid],
					FontSize[playerid], UseBold[playerid], TextColor[playerid], BackgColor[playerid], TextAlign[playerid]);
			        fwrite(archivo,string); fclose(archivo);
				}
			} else {
            	new File:archivo = fopen("textobjects.txt", io_append);
            	if(ObjectType[playerid] == false) {
			        format(string, sizeof(string),"\r\n\r\nnew %s = CreateObject(%d, %0.4f, %0.4f, %0.4f, %0.4f, %0.4f, %0.4f);\
					\r\nSetObjectMaterialText(%s, \"%s\", %d, %d, \"%s\", %d, %d, %i, %i, %d);",OName[playerid],ObjectID[playerid],
					fX, fY, fZ, fRotX, fRotY, fRotZ, OName[playerid], Text[playerid], Index[playerid], Size[playerid], FontName[playerid],
					FontSize[playerid], UseBold[playerid], TextColor[playerid], BackgColor[playerid], TextAlign[playerid]);
			        fwrite(archivo,string); fclose(archivo);
			    } else {
					format(string, sizeof(string),"\r\n\r\nnew %s = CreatePlayerObject(playerid, %d, %0.4f, %0.4f, %0.4f, %0.4f, %0.4f, %0.4f);\
					\r\nSetPlayerObjectMaterialText(playerid, %s, \"%s\", %d, %d, \"%s\", %d, %d, %i, %i, %d);",OName[playerid],ObjectID[playerid],
					fX, fY, fZ, fRotX, fRotY, fRotZ, OName[playerid], Text[playerid], Index[playerid], Size[playerid], FontName[playerid],
					FontSize[playerid], UseBold[playerid], TextColor[playerid], BackgColor[playerid], TextAlign[playerid]);
			        fwrite(archivo,string); fclose(archivo);
				}
			}
			//---
			CreatingTextO[playerid] = false, DestroyPlayerObject(playerid, Object[playerid]);
			TextAlign[playerid] = 1, Text[playerid] = "Example", FontName[playerid] = "Arial",
			TextColor[playerid] = HexToInt("0xFFFF8200"), BackgColor[playerid] = HexToInt("0xFF000000"),
			Size[playerid] = 50, Index[playerid] = 0, UseBold[playerid] = 0,
			FontSize[playerid] = 24, OName[playerid] = "0", ObjectID[playerid] = 19353;
			//---
			SendClientMessage(playerid,-1,""R"* "B"INFO: "Y"Script saved, check your "G"textobjects.txt "Y"in "G"scriptfiles"Y".");
			SendClientMessage(playerid,-1,""R"* "B"INFO: "Y"All settings have been reseted.");
	    } else { ShowMainMenu(playerid); }
	    return 1;
	}
    return 0;
}

ShowMainMenu(playerid)
{
    new string[600];
    strcat(string,""Y"1. "B"Set Object Type\n"Y"2. "B"Set Object Model ID\n"Y"3. "B"Set Object Text\
	\n"Y"4. "B"Set Material Index\n"Y"5. "B"Set Material Size\n");
	strcat(string, ""Y"6. "B"Set Text Font\n"Y"7. "B"Set Text Size\n"Y"8. "B"Set Bold Text\
	\n"Y"9. "B"Set Text Color\n"Y"10. "B"Set Background Color\n"Y"11. "B"Set Text Alignment\n"Y"12. "G"Edit Object\
	\n"Y"13. "G"Export Lines\n"Y"14. "G"Reset Object");
	ShowPlayerDialog(playerid,MainDialog,DIALOG_STYLE_LIST,""R"Text Object | Main Menu",string,"Continue","Exit");
	return 1;
}

UpdateObject(playerid)
{
    GetPlayerObjectPos(playerid, Object[playerid], Pos[0], Pos[1], Pos[2]);
    GetPlayerObjectRot(playerid, Object[playerid], Rot[0], Rot[1], Rot[2]); DestroyPlayerObject(playerid, Object[playerid]);
	Object[playerid] = CreatePlayerObject(playerid, ObjectID[playerid], Pos[0], Pos[1], Pos[2], Rot[0], Rot[1], Rot[2]);

	SetPlayerObjectMaterialText(playerid, Object[playerid], Text[playerid], Index[playerid], Size[playerid], FontName[playerid],
	FontSize[playerid], UseBold[playerid], TextColor[playerid], BackgColor[playerid], TextAlign[playerid]);
}

public OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ)
{
	if(objectid == Object[playerid]) {
		if(response == EDIT_RESPONSE_FINAL)
	 	{
	 	    SendClientMessage(playerid,-1,""R"* "B"Object Edition: "Y"Updated");
            DestroyPlayerObject(playerid, Object[playerid]);
			Object[playerid] = CreatePlayerObject(playerid, ObjectID[playerid], fX, fY, fZ, fRotX, fRotY, fRotZ);
			SetPlayerObjectMaterialText(playerid, Object[playerid], Text[playerid], Index[playerid], Size[playerid], FontName[playerid],
			FontSize[playerid], UseBold[playerid], TextColor[playerid], BackgColor[playerid], TextAlign[playerid]);
			ShowMainMenu(playerid);
		} else if(response == EDIT_RESPONSE_CANCEL) {
            SendClientMessage(playerid,-1,""R"* "B"Object Edition: "Y"No updated"); UpdateObject(playerid), ShowMainMenu(playerid);
		}
	}
}
stock HexToInt(string[]) //By Zamaroht, I think... =/
{
  if (string[0]==0) return 0;
  new i;
  new cur=1;
  new res=0;
  for (i=strlen(string);i>0;i--) {
    if (string[i-1]<58) res=res+cur*(string[i-1]-48); else res=res+cur*(string[i-1]-65+10);
    cur=cur*16;
  }
  return res;
}
