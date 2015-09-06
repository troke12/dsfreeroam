/*===================================================================================================*\
||===================================================================================================||
||	              ________    ________    ___    _    ______     ______     ________                 ||
||	        \    |   _____|  |  ____  |  |   \  | |  |   _  \   |  _   \   |  ____  |    /           ||
||	======== \   |  |_____   | |____| |  | |\ \ | |  |  | |  |  | |_|  /   | |____| |   / ========   ||
||	          |  | _____  |  |  ____  |  | | \ \| |  |  | |  |  |  _  \    |  ____  |  |             ||
||	======== /    ______| |  | |    | |  | |  \ \ |  |  |_|  |  | |  \ \   | |    | |   \ ========   ||
||	        /    |________|  |_|    |_|  |_|   \__|  |______/   |_|   \_|  |_|    |_|    \           ||
||                                                                                                   ||
||                                                                                                   ||
||                                        Property-Filterscript                                      ||
||                                                                                                   ||
||===================================================================================================||
||                           Created on the 5st of June 2008 by =>Sandra<=                          ||
||                                    Do NOT remove any credits!!                                    ||
\*===================================================================================================*/

#include <a_samp>
#include <dini>

#define MAX_PROPERTIES 100
#define MAX_PROPERTIES_PER_PLAYER 4
#define UNBUYABLETIME 15  //If a propertie is bought, someone else have to wait this number of minutes before he/she can buy it.

#define ENABLE_LOGIN_SYSTEM 1
#define ENABLE_MAP_ICON_STREAMER 1

#define REGISTER_COMMAND "/register"
#define LOGIN_COMMAND "/login"

new PropertiesAmount;
new MP;
enum propinfo
{
	PropName[64],
	Float:PropX,
	Float:PropY,
	Float:PropZ,
	PropIsBought,
	PropUnbuyableTime,
	PropOwner[MAX_PLAYER_NAME],
	PropValue,
	PropEarning,
	PickupNr,
}
new PropInfo[MAX_PROPERTIES][propinfo]; //CarInfo
new PlayerProps[MAX_PLAYERS];
new EarningsForPlayer[MAX_PLAYERS];
new Logged[MAX_PLAYERS];

public OnFilterScriptInit()
{
    LoadProperties();
    MP = GetMaxPlayers();
	for(new i; i<MP; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        new pName[MAX_PLAYER_NAME];
			GetPlayerName(i, pName, MAX_PLAYER_NAME);
			for(new propid; propid < PropertiesAmount; propid++)
			{
				if(PropInfo[propid][PropIsBought] == 1)
				{
				    if(strcmp(PropInfo[propid][PropOwner], pName, true)==0)
					{
					    EarningsForPlayer[i] += PropInfo[propid][PropEarning];
					    PlayerProps[i]++;
					}
				}
			}
		}
	}
    SetTimer("UpdateUnbuyableTime", 60000, 1);
	#if ENABLE_MAP_ICON_STREAMER == 1
	SetTimer("MapIconStreamer", 500, 1);
	#endif
	SetTimer("PropertyPayout", 60000, 1);
	print("-------------------------------------------------");
	print("Property-System by =>Sandra<= Succesfully loaded!");
	print("-------------------------------------------------");
	return 1;
}

public OnFilterScriptExit()
{
    SaveProperties();
	print("Properties Saved!!");
	return 1;
}

public OnPlayerConnect(playerid)
{
    PlayerProps[playerid] = 0;
    Logged[playerid] = 0;
    EarningsForPlayer[playerid] = 0;
	new pName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
	for(new propid; propid < PropertiesAmount; propid++)
	{
		if(PropInfo[propid][PropIsBought] == 1)
		{
		    if(strcmp(PropInfo[propid][PropOwner], pName, true)==0)
			{
			    EarningsForPlayer[playerid] += PropInfo[propid][PropEarning];
			    PlayerProps[playerid]++;
			}
		}
	}
	#if ENABLE_LOGIN_SYSTEM == 0
	if(PlayerProps[playerid] > 0)
	{
	    new str[128];
	    format(str, 128, "You currently own %d properties. Type /myproperties for more info about them.", PlayerProps[playerid]);
	    SendClientMessage(playerid, 0x99FF66AA, str);
	}
	#endif
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    new cmd[256], idx, tmp[256];
	cmd = strtok(cmdtext, idx);
	//================================================================================================================================
	//================================================================================================================================
	//================================================================================================================================
	if(strcmp(cmd, "/propertyhelp", true)==0 || strcmp(cmd, "/prophelp", true)==0)
	{
	    SendClientMessage(playerid, 0x6699FFAA, "|=========================================================|");
	    new str[128];
	    SendClientMessage(playerid, 0x6699FFAA, "Property-related commands:");
	    #if ENABLE_LOGIN_SYSTEM == 1
	    format(str, 128, "%s  ==>> To register your name in our property-database", REGISTER_COMMAND);
	    SendClientMessage(playerid, 0x66CCFFAA, str);
	    format(str, 128, "%s  ==>> To log into our property-database", LOGIN_COMMAND);
	    SendClientMessage(playerid, 0x66CCFFAA, str);
		#endif
	    SendClientMessage(playerid, 0x66CCFFAA, "/buyproperty or /buyprop  ==>> To buy a property");
	    SendClientMessage(playerid, 0x66CCFFAA, "/sellproperty or /sellprop  ==>> To sell one of your properties");
	    SendClientMessage(playerid, 0x66CCFFAA, "/myproperties or /myprops  ==>> To see a list of all properties you own");
	    if(IsPlayerAdmin(playerid))
	    {
	        SendClientMessage(playerid, 0x66CCFFAA, "/sellallproperties [Admin Only] ==>> To sell all properties for all players");
		}
	    SendClientMessage(playerid, 0x6699FFAA, "|=========================================================|");
	    return 1;
	}
	//================================================================================================================================
	//================================================================================================================================
	//================================================================================================================================
	if(strcmp(cmd, "/buyproperty", true)==0 || strcmp(cmd, "/buyprop", true)==0)
	{
	    new str[128];
	    #if ENABLE_LOGIN_SYSTEM == 1
		if(Logged[playerid] == 0)
		{
		    format(str, 128, "You have to login before you can buy or sell properties! Use: %s", LOGIN_COMMAND);
			SendClientMessage(playerid, 0xFF0000AA, str);
			return 1;
		}
		#endif
	    
		new propid = IsPlayerNearProperty(playerid);

		if(propid == -1)
		{
			SendClientMessage(playerid, 0xFF0000AA, "You're not close enough to a property");
			return 1;
		}
		if(PlayerProps[playerid] == MAX_PROPERTIES_PER_PLAYER)
	    {
			format(str, 128, "You already have %d properties, you can't buy more properties!", PlayerProps[playerid]);
			SendClientMessage(playerid, 0xFF0000AA, str);
			return 1;
		}
		if(PropInfo[propid][PropIsBought] == 1)
		{
			new ownerid = GetPlayerID(PropInfo[propid][PropOwner]);
			if(ownerid == playerid)
			{
			    SendClientMessage(playerid, 0xFF0000AA, "You already own this property!");
			    return 1;
			}
			else
			{
			    if(PropInfo[propid][PropUnbuyableTime] > 0)
			    {
					format(str, 128, "This property is already bought by %s. You'll have to wait %d minutes before you can buy it.", PropInfo[propid][PropOwner], PropInfo[propid][PropUnbuyableTime]);
				    SendClientMessage(playerid, 0xFF0000AA, str);
				    return 1;
				}
			}
		}
		if(GetPlayerMoney(playerid) < PropInfo[propid][PropValue])
		{
		    format(str, 128, "You don't have enough money! You need $%d,-", PropInfo[propid][PropValue]);
		    SendClientMessage(playerid, 0xFF0000AA, str);
		    return 1;
		}
		new pName[MAX_PLAYER_NAME];
		GetPlayerName(playerid, pName, sizeof(pName));
		if(PropInfo[propid][PropIsBought] && PropInfo[propid][PropUnbuyableTime] == 0)
		{
			new ownerid = GetPlayerID(PropInfo[propid][PropOwner]);
		    format(str, 128, "%s has bought your property \"%s\". You recieved 50 percent of it's value ($%d)", pName, PropInfo[propid][PropName], (PropInfo[propid][PropValue]/2));
			GivePlayerMoney(ownerid, (PropInfo[propid][PropValue]/2));
			SendClientMessage(ownerid, 0xFFFF00AA, str);
			PlayerProps[ownerid]--;
		}
		PropInfo[propid][PropOwner] = pName;
		PropInfo[propid][PropIsBought] = 1;
		PropInfo[propid][PropUnbuyableTime] = UNBUYABLETIME;
		EarningsForPlayer[playerid] += PropInfo[propid][PropEarning];
        GivePlayerMoney(playerid, (0-PropInfo[propid][PropValue]));
		format(str, 128, "You have bought the property \"%s\" for $%d", PropInfo[propid][PropName], PropInfo[propid][PropValue]);
        SendClientMessage(playerid, 0xFFFF00AA, str);
        format(str, 128, "%s has bought the property \"%s\".", pName, PropInfo[propid][PropName]);
        SendClientMessageToAllEx(playerid, 0xFFFF00AA, str);
        PlayerProps[playerid]++;
		return 1;
	}
    //================================================================================================================================
	//================================================================================================================================
	//================================================================================================================================
	if(strcmp(cmd, "/sellproperty", true) == 0 || strcmp(cmd, "/sellprop", true) == 0)
	{
	    new str[128];
	    #if ENABLE_LOGIN_SYSTEM == 1
		if(Logged[playerid] == 0)
		{
		    format(str, 128, "You have to login before you can buy or sell properties! Use: %s", LOGIN_COMMAND);
			SendClientMessage(playerid, 0xFF0000AA, str);
			return 1;
		}
		#endif
		new propid = IsPlayerNearProperty(playerid);
		if(propid == -1)
		{
			SendClientMessage(playerid, 0xFF0000AA, "You're not close enough to a property");
			return 1;
		}
		if(PropInfo[propid][PropIsBought] == 1)
		{
			new ownerid = GetPlayerID(PropInfo[propid][PropOwner]);
			if(ownerid != playerid)
			{
			    SendClientMessage(playerid, 0xFF0000AA, "You don't own this property!");
			    return 1;
			}
		}
		new pName[MAX_PLAYER_NAME];
		GetPlayerName(playerid, pName, sizeof(pName));
		format(PropInfo[propid][PropOwner], MAX_PLAYER_NAME, "Nobody");
		PropInfo[propid][PropIsBought] = 0;
		PropInfo[propid][PropUnbuyableTime] = 0;
		GivePlayerMoney(playerid, (PropInfo[propid][PropValue]/2));
		format(str, 128, "You have sold your property \"%s\" for 50 percents of its value: $%d,-", PropInfo[propid][PropName], PropInfo[propid][PropValue]/2);
        SendClientMessage(playerid, 0xFFFF00AA, str);
        format(str, 128, "%s has sold the property \"%s\".", pName, PropInfo[propid][PropName]);
        SendClientMessageToAllEx(playerid, 0xFFFF00AA, str);
        PlayerProps[playerid]--;
        EarningsForPlayer[playerid] -= PropInfo[propid][PropEarning];
		return 1;
	}
    //================================================================================================================================
	//================================================================================================================================
	//================================================================================================================================
    if(strcmp(cmd, "/myproperties", true) == 0 || strcmp(cmd, "/myprops", true) == 0)
	{
	    new str[128], ownerid;
	    #if ENABLE_LOGIN_SYSTEM == 1
		if(Logged[playerid] == 0)
		{
		    format(str, 128, "You have to login before you can buy or sell properties! Use: %s", LOGIN_COMMAND);
			SendClientMessage(playerid, 0xFF0000AA, str);
			return 1;
		}
		#endif
	    if(PlayerProps[playerid] == 0)
	    {
	        SendClientMessage(playerid, 0xFF0000AA, "You don't own a property!");
	        return 1;
		}
		format(str, 128, "|============ Your %d Properties: =============|", PlayerProps[playerid]);
	    SendClientMessage(playerid, 0x99FF66AA, str);
		for(new propid; propid < PropertiesAmount; propid++)
		{
			if(PropInfo[propid][PropIsBought] == 1)
			{
                ownerid = GetPlayerID(PropInfo[propid][PropOwner]);
				if(ownerid == playerid)
				{
 					format(str, 128, ">> \"%s\"   Value: $%d,-   Earnings: $%d,-", PropInfo[propid][PropName], PropInfo[propid][PropValue], PropInfo[propid][PropEarning]);
 					SendClientMessage(playerid, 0x99FF66AA, str);
				}
			}
		}
		SendClientMessage(playerid, 0x99FF66AA, "|============================================|");
		return 1;
	}
	//================================================================================================================================
	//================================================================================================================================
	//================================================================================================================================
	#if ENABLE_LOGIN_SYSTEM == 1
	if(strcmp(cmd, REGISTER_COMMAND, true) == 0)
	{
	    new str[128];
	    if(Logged[playerid] == 1) return SendClientMessage(playerid, 0xFF0000AA, "You're already logged in!");
	    tmp = strtok(cmdtext, idx);
	    if(!strlen(tmp))
		{
		    format(str, 128, "Use: %s 'Your Password'", REGISTER_COMMAND);
			SendClientMessage(playerid, 0xFF9966AA, str);
			return 1;
		}
	    if(strlen(tmp) < 5) return SendClientMessage(playerid, 0xFF9966AA, "Password too short! At least 5 characters.");
	    if(strlen(tmp) > 20) return SendClientMessage(playerid, 0xFF9966AA, "Password too long! Max 20 characters.");
	    new pName[MAX_PLAYER_NAME], pass;
	    GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
		pass = dini_Int("PropertySystem/PlayerAccounts.txt", pName);
		if(pass == 0)
		{
		    dini_IntSet("PropertySystem/PlayerAccounts.txt", pName, encodepass(tmp));
		    Logged[playerid] = 1;
			format(str, 128, "Your name is now registered in our property-database. Next time use \"%s %s\" to login", LOGIN_COMMAND, tmp);
			SendClientMessage(playerid, 0x99FF66AA, str);
		}
		else
		{
			format(str, 128, "This name is already registered! Use %s to login!", LOGIN_COMMAND);
            SendClientMessage(playerid, 0xFF9966AA, str);
	    }
	    return 1;
	}
	//================================================================================================================================
	//================================================================================================================================
	//================================================================================================================================
	if(strcmp(cmd, LOGIN_COMMAND, true) == 0)
	{
	    new str[128];
	    if(Logged[playerid] == 1) return SendClientMessage(playerid, 0xFF0000AA, "You're already logged in!");
	    tmp = strtok(cmdtext, idx);
	    if(!strlen(tmp))
		{
		    format(str, 128, "Use: %s 'Your Password'", LOGIN_COMMAND);
			SendClientMessage(playerid, 0xFF9966AA, str);
			return 1;
		}
	    new pName[MAX_PLAYER_NAME], pass;
	    GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
		pass = dini_Int("PropertySystem/PlayerAccounts.txt", pName);
		if(pass == 0)
		{
		    format(str, 128, "This name is not registered yet! Use %s to register this name!", REGISTER_COMMAND);
            SendClientMessage(playerid, 0xFF9966AA, str);
		}
		else
		{
			if(pass == encodepass(tmp))
			{
			    Logged[playerid] = 1;
			    SendClientMessage(playerid, 0x99FF66AA, "You're now logged in! You can now buy and sell properties!");
			}
			else
			{
			    SendClientMessage(playerid, 0xFF0000AA, "Wrong Password");
			}
	    }
	    #if ENABLE_LOGIN_SYSTEM == 1
	    if(PlayerProps[playerid] > 0)
		{
		    format(str, 128, "You currently own %d properties. Type /myproperties for more info about them.", PlayerProps[playerid]);
		    SendClientMessage(playerid, 0x99FF66AA, str);
		}
		#endif
	    return 1;
	}
	#endif
	//================================================================================================================================
	//================================================================================================================================
	//================================================================================================================================
	if(strcmp(cmd, "/sellallproperties", true)==0)
	{
	    if(IsPlayerAdmin(playerid))
	    {
	        for(new propid; propid<PropertiesAmount; propid++)
	        {
	            format(PropInfo[propid][PropOwner], MAX_PLAYER_NAME, "Nobody");
	            PropInfo[propid][PropIsBought] = 0;
	            PropInfo[propid][PropUnbuyableTime] = 0;
			}
			for(new i; i<MAX_PLAYERS; i++)
			{
			    if(IsPlayerConnected(i))
			    {
			        PlayerProps[i] = 0;
				}
			}
			new str[128], pName[24];
			GetPlayerName(playerid, pName, 24);
			format(str, 128, "Admin %s has reset all properties!", pName);
			SendClientMessageToAll(0xFFCC66AA, str);
		}
		return 1;
	}
	//================================================================================================================================
	//================================================================================================================================
	//================================================================================================================================
	return 0;
}


public OnPlayerPickUpPickup(playerid, pickupid)
{
	new propid = -1;
	for(new id; id<MAX_PROPERTIES; id++)
	{
		if(PropInfo[id][PickupNr] == pickupid)
		{
			propid = id;
            break;
		}
	}
	if(propid != -1)
	{
	    new str[128];
    	format(str, 128, "~y~\"%s\"~n~~r~Value: ~y~$%d~n~~r~Earning: ~y~$%d~n~~r~Owner: ~y~%s", PropInfo[propid][PropName], PropInfo[propid][PropValue], PropInfo[propid][PropEarning], PropInfo[propid][PropOwner]);
		GameTextForPlayer(playerid, str, 6000, 3);
	}
	return 1;
}

stock LoadProperties()
{
	if(fexist("PropertySystem/PropertyInfo.txt"))
	{
	    CountProperties();
		new Argument[9][70];
		new entry[256], BoughtProps;
		new File: propfile = fopen("PropertySystem/PropertyInfo.txt", io_read);
	    if (propfile)
		{
		    for(new id; id<PropertiesAmount; id++)
			{
				fread(propfile, entry);
				split(entry, Argument, ',');
				format(PropInfo[id][PropName], 64, "%s", Argument[0]);
				PropInfo[id][PropX] = floatstr(Argument[1]);
				PropInfo[id][PropY] = floatstr(Argument[2]);
				PropInfo[id][PropZ] = floatstr(Argument[3]);
				PropInfo[id][PropValue] = strval(Argument[4]);
				PropInfo[id][PropEarning] = strval(Argument[5]);
				format(PropInfo[id][PropOwner], MAX_PLAYER_NAME, "%s", Argument[6]);
				PropInfo[id][PropIsBought] = strval(Argument[7]);
				PropInfo[id][PropUnbuyableTime] = strval(Argument[8]);
				PropInfo[id][PickupNr] = CreatePickup(1273, 1, PropInfo[id][PropX], PropInfo[id][PropY], PropInfo[id][PropZ]);
    			if(PropInfo[id][PropIsBought] == 1)
				{
				    BoughtProps++;
				}
			}
			fclose(propfile);
			printf("===================================");
			printf("||    Created %d Properties     ||", PropertiesAmount);
			printf("||%d of the properties are bought||", BoughtProps);
			printf("===================================");
		}
	}
}

stock SaveProperties()
{
	new entry[256];
	new File: propfile = fopen("PropertySystem/PropertyInfo.txt", io_write);
	for(new id; id<PropertiesAmount; id++)
	{
	    format(entry, 128, "%s,%.2f,%.2f,%.2f,%d,%d,%s,%d,%d \r\n",PropInfo[id][PropName], PropInfo[id][PropX], PropInfo[id][PropY], PropInfo[id][PropZ], PropInfo[id][PropValue], PropInfo[id][PropEarning], PropInfo[id][PropOwner], PropInfo[id][PropIsBought], PropInfo[id][PropUnbuyableTime]);
		fwrite(propfile, entry);
	}
	printf("Saved %d Properties!", PropertiesAmount);
	fclose(propfile);
}

forward split(const strsrc[], strdest[][], delimiter);
public split(const strsrc[], strdest[][], delimiter)
{
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc)){
	    if(strsrc[i]==delimiter || i==strlen(strsrc)){
	        len = strmid(strdest[aNum], strsrc, li, i, 128);
	        strdest[aNum][len] = 0;
	        li = i+1;
	        aNum++;
		}
		i++;
	}
	return 1;
}

stock CountProperties()
{
    new entry[256];
	new File: propfile = fopen("PropertySystem/PropertyInfo.txt", io_read);
	while(fread(propfile, entry, 256))
	{
		PropertiesAmount++;
  	}
  	fclose(propfile);
}

forward IsPlayerNearProperty(playerid);
public IsPlayerNearProperty(playerid)
{
	new Float:Distance;
	for(new prop; prop<PropertiesAmount; prop++)
	{
	    Distance = GetDistanceToProperty(playerid, prop);
	    if(Distance < 1.0)
	    {
	        return prop;
		}
	}
	return -1;
}

forward Float:GetDistanceToProperty(playerid, Property);
public Float:GetDistanceToProperty(playerid, Property)
{
	new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
	GetPlayerPos(playerid,x1,y1,z1);
	x2 = PropInfo[Property][PropX];
	y2 = PropInfo[Property][PropY];
	z2 = PropInfo[Property][PropZ];
	return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}

stock GetPlayerID(const Name[])
{
	for(new i; i<MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        new pName[MAX_PLAYER_NAME];
			GetPlayerName(i, pName, sizeof(pName));
	        if(strcmp(Name, pName, true)==0)
	        {
	            return i;
			}
		}
	}
	return -1;
}

stock SendClientMessageToAllEx(exeption, color, const message[])
{
	for(new i; i<MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(i != exeption)
		    {
		        SendClientMessage(i, color, message);
			}
		}
	}
}

forward UpdateUnbuyableTime();
public UpdateUnbuyableTime()
{
	for(new propid; propid<PropertiesAmount; propid++)
	{
	    if(PropInfo[propid][PropIsBought] == 1)
	    {
			if(PropInfo[propid][PropUnbuyableTime] > 0)
			{
	        	PropInfo[propid][PropUnbuyableTime]--;
			}
		}
	}
}

stock encodepass(buf[]) {
	new length=strlen(buf);
    new s1 = 1;
    new s2 = 0;
    new n;
    for (n=0; n<length; n++)
    {
       s1 = (s1 + buf[n]) % 65521;
       s2 = (s2 + s1)     % 65521;
    }
    return (s2 << 16) + s1;
}

forward MapIconStreamer();
public MapIconStreamer()
{
	for(new i; i<MP; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        new Float:SmallestDistance = 99999.9;
	        new CP, Float:OldDistance;
	        for(new propid; propid<PropertiesAmount; propid++)
	        {
	            OldDistance = GetDistanceToProperty(i, propid);
	            if(OldDistance < SmallestDistance)
	            {
	                SmallestDistance = OldDistance;
	                CP = propid;
				}
			}
			RemovePlayerMapIcon(i, 31);
			if(PropInfo[CP][PropIsBought] == 1)
			{
                SetPlayerMapIcon(i, 31, PropInfo[CP][PropX], PropInfo[CP][PropY], PropInfo[CP][PropZ], 32, 0);
			}
			else
			{
			    SetPlayerMapIcon(i, 31, PropInfo[CP][PropX], PropInfo[CP][PropY], PropInfo[CP][PropZ], 31, 0);
			}
		}
	}
}

forward PropertyPayout();
public PropertyPayout()
{
	new str[64];
	for(new i; i<MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(PlayerProps[i] > 0)
	        {
	            GivePlayerMoney(i, EarningsForPlayer[i]);
				format(str, 64, "You earned $%d,- from your properties!", EarningsForPlayer[i]);
				SendClientMessage(i, 0xFFFF00AA, str);
			}
		}
	}
}


