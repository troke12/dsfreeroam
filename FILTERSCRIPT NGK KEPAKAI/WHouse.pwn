/*==============================================================================




					WHOUSE SYSTEM v2.0 BETA VERSION
					
						     STATS: TESTED
						
						       Features
						 
						_ /createhouse command
						       
						  	 _ Dialogs
							 
						    _ 0.3e colors
						       
		       _ Dynamic System house with pickup (not checkpoint)
						       
						   _ Buy/Sell house
						       
						  _ House levels

			_ Pickup house with /house options, /house exit command
						       
						       
						       
						       
==============================================================================*/


//Includes

#include <a_samp>
#include <dini>
#include <zcmd>
#include <sscanf2>

#define DIALOG_HOUSES  3000
#define DIALOG_BUYING  3001
#define DIALOG_EXIT    3002

#define COLOR_GREY 0xAFAFAFAA
#define COLOR_ACTIVEBORDER 0xB4B4B4FF
#define COLOR_ACTIVECAPTION 0x99B4D1FF
#define COLOR_ACTIVECAPTIONTEXT 0x000000FF
#define COLOR_ALICEBLUE 0xF0F8FFFF
#define COLOR_ANTIQUEWHITE 0xFAEBD7FF
#define COLOR_APPWORKSPACE 0xABABABFF
#define COLOR_AQUA 0x00FFFFFF
#define COLOR_AQUAMARINE 0x7FFFD4FF
#define COLOR_AZURE 0xF0FFFFFF
#define COLOR_BEIGE 0xF5F5DCFF
#define COLOR_BISQUE 0xFFE4C4FF
#define COLOR_BLACK 0x000000FF
#define COLOR_BLANCHEDALMOND 0xFFEBCDFF
#define COLOR_BLUE 0x0000FFFF
#define COLOR_BLUEVIOLET 0x8A2BE2FF
#define COLOR_BROWN 0xA52A2AFF
#define COLOR_BURLYWOOD 0xDEB887FF
#define COLOR_BUTTONFACE 0xF0F0F0FF
#define COLOR_BUTTONHIGHLIGHT 0xFFFFFFFF
#define COLOR_BUTTONSHADOW 0xA0A0A0FF
#define COLOR_CADETBLUE 0x5F9EA0FF
#define COLOR_CHARTREUSE 0x7FFF00FF
#define COLOR_CHOCOLATE 0xD2691EFF
#define COLOR_CONTROL 0xF0F0F0FF
#define COLOR_CONTROLDARK 0xA0A0A0FF
#define COLOR_CONTROLDARKDARK 0x696969FF
#define COLOR_CONTROLLIGHT 0xE3E3E3FF
#define COLOR_CONTROLLIGHTLIGHT 0xFFFFFFFF
#define COLOR_CONTROLTEXT 0x000000FF
#define COLOR_CORAL 0xFF7F50FF
#define COLOR_CORNFLOWERBLUE 0x6495EDFF
#define COLOR_CORNSILK 0xFFF8DCFF
#define COLOR_CRIMSON 0xDC143CFF
#define COLOR_CYAN 0x00FFFFFF
#define COLOR_DARKBLUE 0x00008BFF
#define COLOR_DARKCYAN 0x008B8BFF
#define COLOR_DARKGOLDENROD 0xB8860BFF
#define COLOR_DARKGRAY 0xA9A9A9FF
#define COLOR_DARKGREEN 0x006400FF
#define COLOR_DARKKHAKI 0xBDB76BFF
#define COLOR_DARKMAGENTA 0x8B008BFF
#define COLOR_DARKOLIVEGREEN 0x556B2FFF
#define COLOR_DARKORANGE 0xFF8C00FF
#define COLOR_DARKORCHID 0x9932CCFF
#define COLOR_DARKRED 0x8B0000FF
#define COLOR_DARKSALMON 0xE9967AFF
#define COLOR_DARKSEAGREEN 0x8FBC8BFF
#define COLOR_DARKSLATEBLUE 0x483D8BFF
#define COLOR_DARKSLATEGRAY 0x2F4F4FFF
#define COLOR_DARKTURQUOISE 0x00CED1FF
#define COLOR_DARKVIOLET 0x9400D3FF
#define COLOR_DEEPPINK 0xFF1493FF
#define COLOR_DEEPSKYBLUE 0x00BFFFFF
#define COLOR_DESKTOP 0x000000FF
#define COLOR_DIMGRAY 0x696969FF
#define COLOR_DODGERBLUE 0x1E90FFFF
#define COLOR_FIREBRICK 0xB22222FF
#define COLOR_FLORALWHITE 0xFFFAF0FF
#define COLOR_FORESTGREEN 0x228B22FF
#define COLOR_FUCHSIA 0xFF00FFFF
#define COLOR_GAINSBORO 0xDCDCDCFF
#define COLOR_GHOSTWHITE 0xF8F8FFFF
#define COLOR_GOLD 0xFFD700FF
#define COLOR_GOLDENROD 0xDAA520FF
#define COLOR_GRADIENTACTIVECAPTION 0xB9D1EAFF
#define COLOR_GRADIENTINACTIVECAPTION 0xD7E4F2FF
#define COLOR_GRAY 0x808080FF
#define COLOR_GRAYTEXT 0x808080FF
#define COLOR_GREEN 0x008000FF
#define COLOR_GREENYELLOW 0xADFF2FFF
#define COLOR_HIGHLIGHT 0x3399FFFF
#define COLOR_HIGHLIGHTTEXT 0xFFFFFFFF
#define COLOR_HONEYDEW 0xF0FFF0FF
#define COLOR_HOTPINK 0xFF69B4FF
#define COLOR_HOTTRACK 0x0066CCFF
#define COLOR_INACTIVEBORDER 0xF4F7FCFF
#define COLOR_INACTIVECAPTION 0xBFCDDBFF
#define COLOR_INACTIVECAPTIONTEXT 0x434E54FF
#define COLOR_INDIANRED 0xCD5C5CFF
#define COLOR_INDIGO 0x4B0082FF
#define COLOR_INFO 0xFFFFE1FF
#define COLOR_INFOTEXT 0x000000FF
#define COLOR_IVORY 0xFFFFF0FF
#define COLOR_KHAKI 0xF0E68CFF
#define COLOR_LAVENDER 0xE6E6FAFF
#define COLOR_LAVENDERBLUSH 0xFFF0F5FF
#define COLOR_LAWNGREEN 0x7CFC00FF
#define COLOR_LEMONCHIFFON 0xFFFACDFF
#define COLOR_LIGHTBLUE 0xADD8E6FF
#define COLOR_LIGHTCORAL 0xF08080FF
#define COLOR_LIGHTCYAN 0xE0FFFFFF
#define COLOR_LIGHTGOLDENRODYELLOW 0xFAFAD2FF
#define COLOR_LIGHTGRAY 0xD3D3D3FF
#define COLOR_LIGHTGREEN 0x90EE90FF
#define COLOR_LIGHTPINK 0xFFB6C1FF
#define COLOR_LIGHTSALMON 0xFFA07AFF
#define COLOR_LIGHTSEAGREEN 0x20B2AAFF
#define COLOR_LIGHTSKYBLUE 0x87CEFAFF
#define COLOR_LIGHTSLATEGRAY 0x778899FF
#define COLOR_LIGHTSTEELBLUE 0xB0C4DEFF
#define COLOR_LIGHTYELLOW 0xFFFFE0FF
#define COLOR_LIME 0x00FF00FF
#define COLOR_LIMEGREEN 0x32CD32FF
#define COLOR_LINEN 0xFAF0E6FF
#define COLOR_MAGENTA 0xFF00FFFF
#define COLOR_MAROON 0x800000FF
#define COLOR_MEDIUMAQUAMARINE 0x66CDAAFF
#define COLOR_MEDIUMBLUE 0x0000CDFF
#define COLOR_MEDIUMORCHID 0xBA55D3FF
#define COLOR_MEDIUMPURPLE 0x9370DBFF
#define COLOR_MEDIUMSEAGREEN 0x3CB371FF
#define COLOR_MEDIUMSLATEBLUE 0x7B68EEFF
#define COLOR_MEDIUMSPRINGGREEN 0x00FA9AFF
#define COLOR_MEDIUMTURQUOISE 0x48D1CCFF
#define COLOR_MEDIUMVIOLETRED 0xC71585FF
#define COLOR_MENU 0xF0F0F0FF
#define COLOR_MENUBAR 0xF0F0F0FF
#define COLOR_MENUHIGHLIGHT 0x3399FFFF
#define COLOR_MENUTEXT 0x000000FF
#define COLOR_MIDNIGHTBLUE 0x191970FF
#define COLOR_MINTCREAM 0xF5FFFAFF
#define COLOR_MISTYROSE 0xFFE4E1FF
#define COLOR_MOCCASIN 0xFFE4B5FF
#define COLOR_NAVAJOWHITE 0xFFDEADFF
#define COLOR_NAVY 0x000080FF
#define COLOR_OLDLACE 0xFDF5E6FF
#define COLOR_OLIVE 0x808000FF
#define COLOR_OLIVEDRAB 0x6B8E23FF
#define COLOR_ORANGE 0xFFA500FF
#define COLOR_ORANGERED 0xFF4500FF
#define COLOR_ORCHID 0xDA70D6FF
#define COLOR_PALEGOLDENROD 0xEEE8AAFF
#define COLOR_PALEGREEN 0x98FB98FF
#define COLOR_PALETURQUOISE 0xAFEEEEFF
#define COLOR_PALEVIOLETRED 0xDB7093FF
#define COLOR_PAPAYAWHIP 0xFFEFD5FF
#define COLOR_PEACHPUFF 0xFFDAB9FF
#define COLOR_PERU 0xCD853FFF
#define COLOR_PINK 0xFFC0CBFF
#define COLOR_PLUM 0xDDA0DDFF
#define COLOR_POWDERBLUE 0xB0E0E6FF
#define COLOR_PURPLE 0x800080FF
#define COLOR_RED 0xFF0000FF
#define COLOR_ROSYBROWN 0xBC8F8FFF
#define COLOR_ROYALBLUE 0x4169E1FF
#define COLOR_SADDLEBROWN 0x8B4513FF
#define COLOR_SALMON 0xFA8072FF
#define COLOR_SANDYBROWN 0xF4A460FF
#define COLOR_SCROLLBAR 0xC8C8C8FF
#define COLOR_SEAGREEN 0x2E8B57FF
#define COLOR_SEASHELL 0xFFF5EEFF
#define COLOR_SIENNA 0xA0522DFF
#define COLOR_SILVER 0xC0C0C0FF
#define COLOR_SKYBLUE 0x87CEEBFF
#define COLOR_SLATEBLUE 0x6A5ACDFF
#define COLOR_SLATEGRAY 0x708090FF
#define COLOR_SNOW 0xFFFAFAFF
#define COLOR_SPRINGGREEN 0x00FF7FFF
#define COLOR_STEELBLUE 0x4682B4FF
#define COLOR_TAN 0xD2B48CFF
#define COLOR_TEAL 0x008080FF
#define COLOR_THISTLE 0xD8BFD8FF
#define COLOR_TOMATO 0xFF6347FF
#define COLOR_TRANSPARENT 0xFFFFFF00
#define COLOR_TURQUOISE 0x40E0D0FF
#define COLOR_VIOLET 0xEE82EEFF
#define COLOR_WHEAT 0xF5DEB3FF
#define COLOR_WHITE 0xFFFFFFFF
#define COLOR_WHITESMOKE 0xF5F5F5FF
#define COLOR_WINDOW 0xFFFFFFFF
#define COLOR_WINDOWFRAME 0x646464FF
#define COLOR_WINDOWTEXT 0x000000FF
#define COLOR_YELLOW 0xFFFF00FF
#define COLOR_YELLOWGREEN 0x9ACD32FF
#define STEALTH_ORANGE 0xFF880000
#define STEALTH_OLIVE 0x66660000
#define STEALTH_GREEN 0x33DD1100
#define STEALTH_PINK 0xFF22EE00
#define STEALTH_BLUE 0x0077BB00

#define COL_EASY           "{FFF1AF}"
#define COL_WHITE          "{FFFFFF}"
#define COL_BLACK          "{0E0101}"
#define COL_GREY           "{C3C3C3}"
#define COL_GREEN          "{6EF83C}"
#define COL_RED            "{F81414}"
#define COL_YELLOW         "{F3FF02}"
#define COL_ORANGE         "{FFAF00}"
#define COL_LIME           "{B7FF00}"
#define COL_CYAN           "{00FFEE}"
#define COL_LIGHTBLUE      "{00C0FF}"
#define COL_BLUE           "{0049FF}"
#define COL_MAGENTA        "{F300FF}"
#define COL_VIOLET         "{B700FF}"
#define COL_PINK           "{FF00EA}"
#define COL_MARONE         "{A90202}"
#define COL_CMD            "{B8FF02}"
#define COL_PARAM          "{3FCD02}"
#define COL_SERVER         "{AFE7FF}"
#define COL_VALUE          "{A3E4FF}"
#define COL_RULE           "{F9E8B7}"
#define COL_RULE2          "{FBDF89}"
#define COL_RWHITE         "{FFFFFF}"
#define COL_LGREEN         "{C9FFAB}"
#define COL_LRED           "{FFA1A1}"
#define COL_LRED2          "{C77D87}"
#define COL_PURPLE         "{AA00E3}"

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define MAX_HOUSES 10

#define HOUSE_UPGRADE_MONEY 1000

new HouseEntrance[MAX_HOUSES];

enum E_HOUSE_INFO
{
	Name[24],
	Owner[24],
	Owned,
	Level,
	Price,
	Float:hX,
	Float:hY,
	Float:hZ,
	hVirtual,
	Text3D:hLabel,
}
new HouseInfo[MAX_HOUSES][E_HOUSE_INFO],
	HouseCount,
	IsPlayerInHouse[MAX_PLAYERS];



public OnFilterScriptInit()
{
	print(" ");
	print("--------------------------------------------------------");
	print("**********WazzUp's Dynamic House System Loaded**********");
	print("--------------------------------------------------------");
	print(" ");
	
	LoadHouses();
	return 1;
}

public OnFilterScriptExit()
{
    print(" ");
	print("--------------------------------------------------------");
	print("*********WazzUp's Dynamic House System Unloaded*********");
	print("--------------------------------------------------------");
	print(" ");
	return 1;
}

COMMAND:createhouse(playerid,params[])
{
	new Float:x,Float:y,Float:z,price,lvl,hname[24],string[128],file[100],labelstring[500],hID = HouseCount;
	if(!IsPlayerAdmin(playerid)) return 0;
	if(sscanf(params,"s[24]ii",hname,lvl,price)) return SendClientMessage(playerid,COLOR_RED,"USE: /createhouse [name] [level] [price]");
	if(lvl < 0) return SendClientMessage(playerid,COLOR_RED,"Level must be 1-8");
	GetPlayerPos(playerid,x,y,z);
	HouseInfo[hID][Name] = hname;
	HouseInfo[hID][Level] = lvl;
	HouseInfo[hID][Price] = price;
	HouseInfo[hID][Owned] = 0;
	HouseInfo[hID][hX] = x;
	HouseInfo[hID][hY] = y;
	HouseInfo[hID][hZ] = z;
	HouseInfo[hID][hVirtual] = GetPlayerVirtualWorld(playerid);
	format(HouseInfo[hID][Owner],24,"Anvailable House: No owner");
	format(string,sizeof(string),"Name: "COL_YELLOW"%s || Level: "COL_PURPLE"%i || Price: "COL_LIME"%i",HouseInfo[hID][Name],HouseInfo[hID][Level],HouseInfo[hID][Price]);
    SendClientMessage(playerid,COLOR_YELLOW,"House system: CREATED!");
    SendClientMessage(playerid,COLOR_LIME,string);
    HouseEntrance[hID] = CreatePickup(1273,1,x,y,z,GetPlayerVirtualWorld(playerid));
    
	format(file,sizeof(file),"Houses/%i.ini",hID);
	dini_Create(file);
	if(dini_Exists(file))
	{
	    dini_Set(file,"Name",hname);
	    dini_Set(file,"Owner","No owner");
	    dini_IntSet(file,"Owned",0);
		dini_IntSet(file,"Level",lvl);
		dini_IntSet(file,"Price",price);
		dini_FloatSet(file,"X",x);
		dini_FloatSet(file,"Y",y);
		dini_FloatSet(file,"Z",z);
		dini_IntSet(file,"VirtualWorld",GetPlayerVirtualWorld(playerid));
	}
	else
	{
	    dini_Create(file);
	}
	format(labelstring,sizeof(labelstring),""COL_YELLOW"[ Name ]: "COL_WHITE"%s\n"COL_GREEN"[ Owner ]: "#COL_WHITE#"Available\n"COL_PURPLE" [ Level ] : %i\n"COL_GREEN"[ Price ]: "#COL_LIME#"%i\nUse /house to buy this lovely house",hname,lvl,price);
	HouseInfo[hID][hLabel] = Create3DTextLabel(labelstring,0xFF0000FF,x,y,z,25.0,GetPlayerVirtualWorld(playerid));
	HouseCount ++;
	return 1;
}

COMMAND:house(playerid,params[])
{
	new option[50];
	if(sscanf(params,"s[50]",option))
	{
		SendClientMessage(playerid,COLOR_YELLOW,"USE: /house [name]");
		SendClientMessage(playerid,COLOR_GREEN,"Available names: options, buy, exit");
		return 1;
	}
	if(strcmp(option,"options") == 0)
	{
		for(new i = 0; i < MAX_HOUSES; i++)
		{
			new pname[24];
			GetPlayerName(playerid,pname,sizeof(pname));
			if(IsPlayerInRangeOfPoint(playerid,3.0,HouseInfo[i][hX],HouseInfo[i][hY],HouseInfo[i][hZ]))
			{
				if(HouseInfo[i][Owned] == 1 && strcmp(pname,HouseInfo[i][Owner]) != 0) return SendClientMessage(playerid,-1,""COL_RED"You aren't the "COL_YELLOW"owner "COL_GREEN"of this house!");
				if(HouseInfo[i][Owned] == 1 && strcmp(HouseInfo[i][Owner],pname) == 0)
				{
					ShowPlayerDialog(playerid,DIALOG_HOUSES,DIALOG_STYLE_LIST,"House Options",""COL_BLUE"Enter House\n"COL_YELLOW"Upgrade House\n"COL_RED"Sell House","Choose","Cancel");
					SavePos(playerid);
				}
			}
		}
	}
	if(strcmp(option,"buy") == 0)
	{
		for(new i = 0; i < MAX_HOUSES; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid,3.0,HouseInfo[i][hX],HouseInfo[i][hY],HouseInfo[i][hZ]))
			{
				if(HouseInfo[i][Owned] == 0)
				{
					ShowPlayerDialog(playerid,DIALOG_BUYING,DIALOG_STYLE_MSGBOX,"House Options","Do you want to buy this house?","Buy","Cancel");
				}
			}
		}
	}
	if(strcmp(option,"exit") == 0)
	{
		if(IsPlayerInRangeOfPoint(playerid,2.0,444.646911,508.239044,1001.419494)) return ShowPlayerDialog(playerid,DIALOG_EXIT,DIALOG_STYLE_MSGBOX,"House Options","Do you want to leave this house?","Yes","No");
		if(IsPlayerInRangeOfPoint(playerid,2.0,2527.654052,-1679.388305,1015.498596)) return ShowPlayerDialog(playerid,DIALOG_EXIT,DIALOG_STYLE_MSGBOX,"House Options","Do you want to leave this house?","Yes","No");
		if(IsPlayerInRangeOfPoint(playerid,2.0,2807.619873,-1171.899902,1025.570312)) return ShowPlayerDialog(playerid,DIALOG_EXIT,DIALOG_STYLE_MSGBOX,"House Options","Do you want to leave this house?","Yes","No");
		if(IsPlayerInRangeOfPoint(playerid,2.0,1527.229980,-11.574499,1002.097106)) return ShowPlayerDialog(playerid,DIALOG_EXIT,DIALOG_STYLE_MSGBOX,"House Options","Do you want to leave this house?","Yes","No");
		if(IsPlayerInRangeOfPoint(playerid,2.0,2496.049804,-1695.238159,1014.742187)) return ShowPlayerDialog(playerid,DIALOG_EXIT,DIALOG_STYLE_MSGBOX,"House Options","Do you want to leave this house?","Yes","No");
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_EXIT)
    {
		if(response)
		{
  			for(new i = 0; i < MAX_HOUSES; i++)
			{
				LoadPos(playerid);
			}
			SendClientMessage(playerid,COLOR_LIME,"You left the house");
		}
    }
    if(dialogid == DIALOG_BUYING)
    {
        if(response)
        {
            for(new i = 0; i < MAX_HOUSES; i++)
			{
			    if(!IsPlayerInRangeOfPoint(playerid,8.0,HouseInfo[i][hX],HouseInfo[i][hY],HouseInfo[i][hZ])) continue;
                if(GetPlayerMoney(playerid) < HouseInfo[i][Price]) return SendClientMessage(playerid,COLOR_RED,"You don't have enough money");
                if(HouseInfo[i][Owned] == 1) return SendClientMessage(playerid,COLOR_RED,"This house is already owned");
                HouseInfo[i][Owned] = 1;
                new file[100],pname[24],labelstring[500];
                GetPlayerName(playerid,pname,sizeof(pname));
                format(HouseInfo[i][Owner],24,"%s",pname);
                format(file,sizeof(file),"Houses/%i.ini",i);
                if(dini_Exists(file))
				{
				    dini_Set(file,"Owner",pname);
				    dini_IntSet(file,"Owned",1);
                }
                format(labelstring,sizeof(labelstring),""COL_YELLOW"[ Name ]: "COL_WHITE"%s\n"COL_GREEN"[ Owner ]: "#COL_WHITE#"Yes\n"COL_PURPLE" [ Level ] : %i\n"COL_GREEN"[ Price ]: "#COL_LIME#"%i\n[ Owner ]: %s",HouseInfo[i][Name],HouseInfo[i][Level],HouseInfo[i][Price],pname);
                Update3DTextLabelText(HouseInfo[i][hLabel],0xFF0000FF,labelstring);
                GivePlayerMoney(playerid,-HouseInfo[i][Price]);
			}
        }
    }
    if(dialogid == DIALOG_HOUSES)
    {
        if(response)
	 	{
	  		switch(listitem)
	    	{
	    	    case 0:
	    	    {
	    	        for(new i = 0; i < MAX_HOUSES; i++)
					{
					    new pname[24];
					    GetPlayerName(playerid,pname,sizeof(pname));
					    if(HouseInfo[i][Owned] == 1 && strcmp(HouseInfo[i][Owner],pname) == 0)
						{
						    if(HouseInfo[i][Level] == 1)
						    {
						    	SetPlayerInterior(playerid,12);
								SetPlayerPos(playerid,444.646911,508.239044,1001.419494);
								SetPlayerVirtualWorld(playerid,HouseInfo[i][hVirtual]);
								IsPlayerInHouse[playerid] = i;
							}
							if(HouseInfo[i][Level] == 2)
							{
							    SetPlayerInterior(playerid,1);
								SetPlayerPos(playerid,2527.654052,-1679.388305,1015.498596);
								SetPlayerVirtualWorld(playerid,HouseInfo[i][hVirtual]);
								IsPlayerInHouse[playerid] = i;
							}
							if(HouseInfo[i][Level] == 3)
							{
							    SetPlayerInterior(playerid,8);
								SetPlayerPos(playerid,2807.619873,-1171.899902,1025.570312);
								SetPlayerVirtualWorld(playerid,HouseInfo[i][hVirtual]);
								IsPlayerInHouse[playerid] = i;
							}
							if(HouseInfo[i][Level] == 4)
							{
								SetPlayerInterior(playerid,3);
								SetPlayerPos(playerid,1527.229980,-11.574499,1002.097106);
								SetPlayerVirtualWorld(playerid,HouseInfo[i][hVirtual]);
								IsPlayerInHouse[playerid] = i;
							}
							if(HouseInfo[i][Level] == 4)
							{
								SetPlayerInterior(playerid,3);
								SetPlayerPos(playerid,2496.049804,-1695.238159,1014.742187);
								SetPlayerVirtualWorld(playerid,HouseInfo[i][hVirtual]);
								IsPlayerInHouse[playerid] = i;
							}
						}
					}
	    	    }
	    	    case 1:
				{
					if(GetPlayerMoney(playerid) < HOUSE_UPGRADE_MONEY)
					{
						new string[129];
						format(string,sizeof(string),"You don't have enough money to upgrade this house. Price to upgrade: %d",HOUSE_UPGRADE_MONEY);
						SendClientMessage(playerid,COLOR_RED,string);
						return 0;
					}
					for(new i = 0; i < MAX_HOUSES; i++)
					{
					    if(HouseInfo[i][Level] > 4) return SendClientMessage(playerid,COLOR_RED,"This house is maximum level");
						HouseInfo[i][Level] ++;
						new file[100];
						format(file,sizeof(file),"Houses/%i.ini",i);
						if(dini_Exists(file))
						{
						    dini_IntSet(file,"Level",HouseInfo[i][Level]);
						}
					}
					SendClientMessage(playerid,COLOR_RED,"House system: UPGRADED");
				}
				case 2:
				{
					new string[100];
				    for(new i = 0; i < MAX_HOUSES; i++)
					{
					    new pname[24];
					    GetPlayerName(playerid,pname,sizeof(pname));
					    new file[60],labelstring[500];
					    format(HouseInfo[i][Owner],24,"Available: No owners");
					    format(file,sizeof(file),"Houses/%i.ini",i);
					    if(dini_Exists(file))
					    {
							dini_Set(file,"Owner","No owner");
							dini_IntSet(file,"Owned",0);
						}
						format(labelstring,sizeof(labelstring),""COL_YELLOW"[ Name ]: "COL_WHITE"%s\n"COL_GREEN"[ Owner ]: "#COL_WHITE#"Available\n"COL_PURPLE" [ Level ] : %i\n"COL_GREEN"[ Price ]: "#COL_LIME#"%i\nUse /house to buy this lovely house",HouseInfo[i][Name],HouseInfo[i][Level],HouseInfo[i][Price]);
                        Update3DTextLabelText(HouseInfo[i][hLabel],0xFF0000FF,string);
                        format(string,sizeof(string),"You sold your house for"COL_GREEN" %d",HouseInfo[i][Price]/=2);
						GivePlayerMoney(playerid,HouseInfo[i][Price]/=2);
						HouseInfo[i][Owned] = 0;
					}
					SendClientMessage(playerid,-1,string);
				}
	    	}
		}
    }
	return 1;
}

stock LoadHouses()
{
	new file[60],hOwner[512];
	for(new i = 0; i < MAX_HOUSES; i++)
	{
		format(file,sizeof(file),"Houses/%i.ini",i);
		if(!dini_Exists(file)) continue;
		if(dini_Exists(file))
		{
			HouseInfo[i][Name] = strval(dini_Get(file,"Name"));
			HouseInfo[i][Level] = dini_Int(file,"Level");
		    HouseInfo[i][Price] = dini_Int(file,"Price");
			HouseInfo[i][Owned] = dini_Int(file,"Owned");
			HouseInfo[i][hX] = dini_Float(file,"X");
			HouseInfo[i][hY] = dini_Float(file,"Y");
			HouseInfo[i][hZ] = dini_Float(file,"Z");
			HouseInfo[i][hVirtual] = dini_Int(file,"VirtualWorld");
			hOwner = dini_Get(file,"Owner");
			format(HouseInfo[i][Owner],24,"%s",hOwner);
			HouseEntrance[i] = CreatePickup(1273,1,HouseInfo[i][hX],HouseInfo[i][hY],HouseInfo[i][hZ],HouseInfo[i][hVirtual]);
			new labelstring[500];
			switch(HouseInfo[i][Owned])
			{
				case 0:{format(labelstring,sizeof(labelstring),""COL_YELLOW"[ Name ]: "COL_WHITE"%s\n"COL_GREEN"[ Owner ]: "#COL_WHITE#"Available\n"COL_PURPLE" [ Level ] : %i\n"COL_GREEN"[ Price ]: "#COL_LIME#"%i\nUse /house to buy this lovely house",HouseInfo[i][Name],HouseInfo[i][Level],HouseInfo[i][Price]);}
				case 1:{format(labelstring,sizeof(labelstring),""COL_YELLOW"[ Name ]: "COL_WHITE"%s\n"COL_GREEN"[ Owner ]: "#COL_WHITE#"Yes\n"COL_PURPLE" [ Level ] : %i\n"COL_GREEN"[ Price ]: "#COL_LIME#"%i\n[ Owner ]: %s",HouseInfo[i][Name],HouseInfo[i][Level],HouseInfo[i][Price],HouseInfo[i][Owner]);}
			}
			HouseInfo[i][hLabel] = Create3DTextLabel(labelstring,0xFF0000FF,HouseInfo[i][hX],HouseInfo[i][hY],HouseInfo[i][hZ],25.0,HouseInfo[i][hVirtual]);
			HouseCount ++;
		}
	}
	return 1;
}

stock SavePos(playerid)
{
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
	SetPVarFloat(playerid,"XPos",x);
	SetPVarFloat(playerid,"YPos",y);
	SetPVarFloat(playerid,"ZPos",z);
	SetPVarFloat(playerid,"Virtual",GetPlayerVirtualWorld(playerid));
	return 1;
}

stock LoadPos(playerid)
{
    SetPlayerPos(playerid,GetPVarFloat(playerid,"XPos"),GetPVarFloat(playerid,"YPos"),GetPVarFloat(playerid,"ZPos"));
    SetPlayerVirtualWorld(playerid,GetPVarInt(playerid,"Virtual"));
    SetPlayerInterior(playerid,0);
    return 1;
}