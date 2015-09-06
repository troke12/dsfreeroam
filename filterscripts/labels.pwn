/*
	Credits: KillerThriller
*/
#include <a_samp>
#include <sscanf2>
#include <SII>
#define dcmd(%1,%2,%3) if (!strcmp((%3)[1], #%1, true, (%2)) && ((((%3)[(%2) + 1] == '\0') && (dcmd_%1(playerid, ""))) || (((%3)[(%2) + 1] == ' ') && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
#define ADMINSONLY    														   false//Set to false if you want everyone to be able to use it!
#define MAX_LABELS    														   50//Set this to the max labels you want to set it (Default: 50)
#define MAIN_DIALOG   														   2402//Change this to the dialog range you want this to be (To not conflict with other dialogs)
#define DEFAULT_LABEL_VIEW_THREW_OBJECTS   									   0//Change this if you want to see the labels threw objects or not (Default is: Yes)
#define DEFAULT_LABEL_VIEW_DISTANCE                                            20.0//Change this if you want to change the default draw distance of the label
#define File 																   "Labels/%i.ini"//File to store the labels
//============================= [Colors] =======================================
#define green                                                         0x00FF28FF
#define darkgreen                                                     0x5FB700FF
#define lightgreen                                                    0x23FF00FF
#define red                                                    		  0xFF0000FF
#define yellow                                                        0xF5FF00FF
#define darkyellow                                                    0xF5DE00FF
#define orange                                                        0xF5A300FF
#define darkblue                                                      0x0037FFFF
#define blue                                                          0x1400FFFF
#define lightblue                                                     0x00FFF0FF
#define grey                                                          0xB4B4B4FF
#define white                                                         0xF0F0F0FF
#define purple                                                        0x9C00AFFF
//============================= [Colors] =======================================
//=============================== [RRGGBB] =====================================
#define lgreen 														  "{6EF83C}"
#define lwhite 														  "{FFFFFF}"
#define lyellow                                                       "{FFFF22}"
#define lblue                                                         "{2255FF}"
#define lpink                                                         "{FF0077}"
#define lorange                                                       "{FF6622}"
#define lred                                                          "{FF0000}"
#define lgrey                                                         "{BEBEBE}"
#define lyellow2                                                      "{E1DE1C}"
//============================= [RRGGBB] =======================================

enum labelsinfo
{
	Text[256],
	Color,
	Float:POSX,
	Float:POSY,
 	Float:POSZ,
 	Float:Distance,
 	World
}
new Text3D:LInfo[MAX_LABELS][labelsinfo];
new Labelcount;
new Text3D:LabelID[MAX_LABELS];
new EditingLabel[MAX_PLAYERS] = -1;
public OnGameModeInit()
{
	print("\n--------------------------------------");
	print("Ultimate Label Creator by -KillerThriller");
	print("--------------------------------------\n");
	LoadLabels();
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	dcmd(label,5,cmdtext);
	return 0;
}

dcmd_label(playerid,params[])
{
	#pragma unused params
	#if ADMINSONLY == true
	{
	    if(!IsPlayerAdmin(playerid)) return 0;
		ShowPlayerDialog(playerid,MAIN_DIALOG,2,"KLabels - Labels dialog","Create new label \nEdit closest label","Ok","Cancel");
	}
	#else
	{
	    ShowPlayerDialog(playerid,MAIN_DIALOG,2,"KLabels - Labels dialog","Create new label \nEdit closest label","Ok","Cancel");
 	}
	#endif
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == MAIN_DIALOG)
	{
	    if(listitem == 0)
		{
		    new Float:x,Float:y,Float:z,ID = Labelcount,string[64],file[128];
		    format(file,sizeof(file),File,ID);
		    GetPlayerPos(playerid,x,y,z);
		    LabelID[ID] = Create3DTextLabel("New label",white,x,y,z,DEFAULT_LABEL_VIEW_DISTANCE,GetPlayerVirtualWorld(playerid),DEFAULT_LABEL_VIEW_THREW_OBJECTS);
			format(LInfo[ID][Text],10,"%s","New label");
			LInfo[ID][POSX] = x;
			LInfo[ID][POSY] = y;
        	LInfo[ID][POSZ] = z;
       		LInfo[ID][Distance] = DEFAULT_LABEL_VIEW_DISTANCE;
       		LInfo[ID][World] = GetPlayerVirtualWorld(playerid);
            LInfo[ID][Color] = white;
       		INI_Open(file);
       		INI_WriteFloat("X",LInfo[ID][POSX]);
       		INI_WriteFloat("Y",LInfo[ID][POSY]);
       		INI_WriteFloat("Z",LInfo[ID][POSZ]);
       		INI_WriteFloat("Distance",LInfo[ID][Distance]);
       		INI_WriteInt("World",LInfo[ID][World]);
       		INI_WriteString("Color","White");
       		INI_WriteString("Text",LInfo[ID][Text]);
       		INI_Save();
       		INI_Close();
			format(string,sizeof(string),"Label "lyellow2"%i "lgreen"created!",ID);
			SendClientMessage(playerid,green,string);
			Labelcount++;
		}
		if(listitem == 1)
		{
		    ShowPlayerDialog(playerid,MAIN_DIALOG+1,2,"KLabels - Edit closest label","Change text \nChange view distance \nChange color","Ok","Cancel");
  		}
	}
	if(dialogid == MAIN_DIALOG+1)
	{
	    if(!response) return 0;
		EditingLabel[playerid] = GetClosestLabel(playerid);
     	if(listitem == 0)
     	{
     	    ShowPlayerDialog(playerid,MAIN_DIALOG+2,1,"KLabels - Changing text...","Type in the new text of the label you want to change \n","Ok","Cancel");
 	    }
 	    if(listitem == 1)
     	{
     	    ShowPlayerDialog(playerid,MAIN_DIALOG+3,1,"KLabels - Changing draw distance...","Type in the new draw distance of the label you want to change \n","Ok","Cancel");
 	    }
 	    if(listitem == 2)
     	{
     	    ShowPlayerDialog(playerid,MAIN_DIALOG+4,2,"KLabels - Changing color...",""lred"Red\n"lgreen"Green \n"lyellow"Yellow \n"lblue"Blue","Ok","Cancel");
 	    }
	}
	if(dialogid == MAIN_DIALOG+2)
	{
	    if(!response) return 0;
	    format(LInfo[EditingLabel[playerid]][Text],128,"%s",inputtext);
	    new file[128];
	    format(file,sizeof(file),File,EditingLabel[playerid]);
	    INI_Open(file);
	    INI_WriteString("Text",inputtext);
	    INI_Save();
	    INI_Close();
	    Update3DTextLabelText(LabelID[EditingLabel[playerid]],LInfo[EditingLabel[playerid]][Color],LInfo[EditingLabel[playerid]][Text]);
 	}
 	if(dialogid == MAIN_DIALOG+3)
	{
	    if(!response) return 0;
	    if(!isNumeric(inputtext)) return SendClientMessage(playerid,red,""lgreen"ERROR: "lorange"It must be a numeric value!");
	    LInfo[EditingLabel[playerid]][Distance] = strval(inputtext);
	    new file[128];
	    format(file,sizeof(file),File,EditingLabel[playerid]);
	    INI_Open(file);
	    INI_WriteInt("Distance",strval(inputtext));
	    INI_Save();
	    INI_Close();
		Delete3DTextLabel(LabelID[EditingLabel[playerid]]);
		LabelID[EditingLabel[playerid]] = Create3DTextLabel(LInfo[EditingLabel[playerid]][Text],LInfo[EditingLabel[playerid]][Color],LInfo[EditingLabel[playerid]][POSX],LInfo[EditingLabel[playerid]][POSY],LInfo[EditingLabel[playerid]][POSZ],LInfo[EditingLabel[playerid]][Distance],LInfo[EditingLabel[playerid]][World],DEFAULT_LABEL_VIEW_THREW_OBJECTS);
 	}
 	if(dialogid == MAIN_DIALOG+4)
	{
	    if(!response) return 0;
	    if(listitem == 0)
	    {
	    	LInfo[EditingLabel[playerid]][Color] = red;
	    	Delete3DTextLabel(LabelID[EditingLabel[playerid]]);
	    	new file[128];
		    format(file,sizeof(file),File,EditingLabel[playerid]);
		    INI_Open(file);
		    INI_WriteString("Color","Red");
		    INI_Save();
		    INI_Close();
	    	LabelID[EditingLabel[playerid]] = Create3DTextLabel(LInfo[EditingLabel[playerid]][Text],LInfo[EditingLabel[playerid]][Color],LInfo[EditingLabel[playerid]][POSX],LInfo[EditingLabel[playerid]][POSY],LInfo[EditingLabel[playerid]][POSZ],LInfo[EditingLabel[playerid]][Distance],LInfo[EditingLabel[playerid]][World],DEFAULT_LABEL_VIEW_THREW_OBJECTS);
    	}
    	if(listitem == 1)
	    {
	    	LInfo[EditingLabel[playerid]][Color] = green;
	    	Delete3DTextLabel(LabelID[EditingLabel[playerid]]);
	    	new file[128];
		    format(file,sizeof(file),File,EditingLabel[playerid]);
		    INI_Open(file);
		    INI_WriteString("Color","Green");
		    INI_Save();
		    INI_Close();
	    	LabelID[EditingLabel[playerid]] = Create3DTextLabel(LInfo[EditingLabel[playerid]][Text],LInfo[EditingLabel[playerid]][Color],LInfo[EditingLabel[playerid]][POSX],LInfo[EditingLabel[playerid]][POSY],LInfo[EditingLabel[playerid]][POSZ],LInfo[EditingLabel[playerid]][Distance],LInfo[EditingLabel[playerid]][World],DEFAULT_LABEL_VIEW_THREW_OBJECTS);
    	}
    	if(listitem == 2)
	    {
	    	LInfo[EditingLabel[playerid]][Color] = yellow;
	    	Delete3DTextLabel(LabelID[EditingLabel[playerid]]);
	    	new file[128];
		    format(file,sizeof(file),File,EditingLabel[playerid]);
		    INI_Open(file);
		    INI_WriteString("Color","Yellow");
		    INI_Save();
		    INI_Close();
	    	LabelID[EditingLabel[playerid]] = Create3DTextLabel(LInfo[EditingLabel[playerid]][Text],LInfo[EditingLabel[playerid]][Color],LInfo[EditingLabel[playerid]][POSX],LInfo[EditingLabel[playerid]][POSY],LInfo[EditingLabel[playerid]][POSZ],LInfo[EditingLabel[playerid]][Distance],LInfo[EditingLabel[playerid]][World],DEFAULT_LABEL_VIEW_THREW_OBJECTS);
    	}
    	if(listitem == 3)
	    {
	    	LInfo[EditingLabel[playerid]][Color] = blue;
	    	Delete3DTextLabel(LabelID[EditingLabel[playerid]]);
	    	new file[128];
		    format(file,sizeof(file),File,EditingLabel[playerid]);
		    INI_Open(file);
		    INI_WriteString("Color","Blue");
		    INI_Save();
		    INI_Close();
	    	LabelID[EditingLabel[playerid]] = Create3DTextLabel(LInfo[EditingLabel[playerid]][Text],LInfo[EditingLabel[playerid]][Color],LInfo[EditingLabel[playerid]][POSX],LInfo[EditingLabel[playerid]][POSY],LInfo[EditingLabel[playerid]][POSZ],LInfo[EditingLabel[playerid]][Distance],LInfo[EditingLabel[playerid]][World],DEFAULT_LABEL_VIEW_THREW_OBJECTS);
    	}
 	}
	return 0;
}

stock Float:GetDistanceBetweenPoints(Float:x,Float:y,Float:tx,Float:ty)
{
	new Float:temp1, Float:temp2;
  	temp1 = x-tx;temp2 = y-ty;
  	return floatsqroot(temp1*temp1+temp2*temp2);
}

stock GetClosestLabel(playerid)
{
	new Float:distance = 10,Float:temp,Float:x,Float:y,Float:z,current = -1;
	GetPlayerPos(playerid,x,y,z);
	for(new i = 0;i<MAX_LABELS;i++)
	{
		temp = GetDistanceBetweenPoints(x,y,LInfo[i][POSX],LInfo[i][POSY]);
		if(temp < distance)
		{
			distance = temp;
			current = i;
		}
	}
	return current;
}

stock isNumeric(const string[])
{
  	new length=strlen(string);
  	if (length==0) return false;
  	for (new i = 0; i < length; i++)
    {
      if (
            (string[i] > '9' || string[i] < '0' && string[i]!='-' && string[i]!='+') // Not a number,'+' or '-'
             || (string[i]=='-' && i!=0)                                             // A '-' but not at first.
             || (string[i]=='+' && i!=0)                                             // A '+' but not at first.
         ) return false;
    }
  	if (length==1 && (string[0]=='-' || string[0]=='+')) return false;
  	return true;
}

stock LoadLabels()
{
	for(new i = 0; i < MAX_LABELS;i++)
	{
	    new file[128];
		format(file,sizeof(file),File,i);
		if(INI_Exist(file))
		{
		    new color[64],text[200];
		    INI_Open(file);
		    INI_ReadString(color,"Color",64);
		    INI_ReadString(text,"Text",200);
       		LInfo[i][POSX] = INI_ReadFloat("X");
       		LInfo[i][POSY] = INI_ReadFloat("Y");
       		LInfo[i][POSZ] = INI_ReadFloat("Z");
       		LInfo[i][Distance] = INI_ReadFloat("Distance");
       		LInfo[i][World] = INI_ReadInt("World");
			format(LInfo[i][Text],200,"%s",text);
       		INI_Save();
       		INI_Close();
       		if(strcmp(color,"Red") == 0)
       		{
       		    LInfo[i][Color] = red;
       			LabelID[i] = Create3DTextLabel(LInfo[i][Text],LInfo[i][Color],LInfo[i][POSX],LInfo[i][POSY],LInfo[i][POSZ],LInfo[i][Distance],LInfo[i][World],DEFAULT_LABEL_VIEW_THREW_OBJECTS);
			}
			if(strcmp(color,"Green") == 0)
       		{
       		    LInfo[i][Color] = green;
       			LabelID[i] = Create3DTextLabel(LInfo[i][Text],LInfo[i][Color],LInfo[i][POSX],LInfo[i][POSY],LInfo[i][POSZ],LInfo[i][Distance],LInfo[i][World],DEFAULT_LABEL_VIEW_THREW_OBJECTS);
			}
			if(strcmp(color,"Yellow") == 0)
       		{
       		    LInfo[i][Color] = yellow;
       			LabelID[i] = Create3DTextLabel(LInfo[i][Text],LInfo[i][Color],LInfo[i][POSX],LInfo[i][POSY],LInfo[i][POSZ],LInfo[i][Distance],LInfo[i][World],DEFAULT_LABEL_VIEW_THREW_OBJECTS);
			}
			if(strcmp(color,"Blue") == 0)
       		{
       		    LInfo[i][Color] = blue;
       			LabelID[i] = Create3DTextLabel(LInfo[i][Text],LInfo[i][Color],LInfo[i][POSX],LInfo[i][POSY],LInfo[i][POSZ],LInfo[i][Distance],LInfo[i][World],DEFAULT_LABEL_VIEW_THREW_OBJECTS);
			}
			if(strcmp(color,"White") == 0)
       		{
       		    LInfo[i][Color] = white;
       			LabelID[i] = Create3DTextLabel(LInfo[i][Text],LInfo[i][Color],LInfo[i][POSX],LInfo[i][POSY],LInfo[i][POSZ],LInfo[i][Distance],LInfo[i][World],DEFAULT_LABEL_VIEW_THREW_OBJECTS);
			}
			Labelcount++;
		}
	}
	printf("KLabels - Labels loaded: %i",Labelcount);
	return 1;
}
