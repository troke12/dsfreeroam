//      ## ##     ##  #######  ##     ##  ######  ########
//      ## ##     ## ##     ## ##     ## ##    ## ##
//      ## ##     ## ##     ## ##     ## ##       ##
//      ## ######### ##     ## ##     ##  ######  ######
//##    ## ##     ## ##     ## ##     ##       ## ##
//##    ## ##     ## ##     ## ##     ## ##    ## ##
// ######  ##     ##  #######   #######   ######  ########

// by Jameskmonger



// Execute this query: CREATE DATABASE jHouse
// Execute this query too: CREATE TABLE  IF NOT EXISTS `houses` ( `ID` INT(3) NOT NULL, `owner` VARCHAR( 24 ) NOT NULL , `price` INT( 8 ) NOT NULL ,`exteriorX` FLOAT( 11 ) NOT NULL ,`exteriorY` FLOAT( 11 ) NOT NULL ,`exteriorZ` FLOAT( 11 ) NOT NULL ,`interiorX` FLOAT( 11 ) NOT NULL ,`interiorY` FLOAT( 11 ) NOT NULL ,`interiorZ` FLOAT( 11 ) NOT NULL ,`interiorInt` FLOAT( 11 ) NOT NULL ,`locked` INT( 1 ) NOT NULL) ENGINE = INNODB;

#include <a_samp>
#include <a_mysql>
#include <zcmd>

#define FILTERSCRIPT

#define MYSQL_HOST	"localhost"
#define MYSQL_USER	"root"
#define MYSQL_DB "jHouse"
#define MYSQL_PASS 	""

#define MAX_HOUSES 20 //Set this no higher than 999.

#define HD HouseData
#define HC HouseCreating

#define WHITE 0xFFFFFFFF

enum jHouseInfo {
	ID,
	owner[24],
	price,
	Float:exteriorX,
	Float:exteriorY,
	Float:exteriorZ,
	Float:interiorX,
	Float:interiorY,
	Float:interiorZ,
	interiorInt,
	locked
}
new HouseData[MAX_HOUSES][jHouseInfo];
new InsideHouse[MAX_PLAYERS];

enum creatingHouse {
	Float:exteriorX,
	Float:exteriorY,
	Float:exteriorZ,
	Float:interiorX,
	Float:interiorY,
	Float:interiorZ,
	interiorInt
}
new HouseCreating[MAX_PLAYERS][creatingHouse];

forward ConnectMySQL();
forward BuildHouse(hprice, Float:hexteriorX, Float:hexteriorY, Float:hexteriorZ, Float:hinteriorX, Float:hinteriorY, Float:hinteriorZ, hinteriorInt, hlocked);

public OnFilterScriptInit()
{
    ConnectMySQL();
    print("\n\n");
	print("      ## ##     ##  #######  ##     ##  ######  ########	");
	print("      ## ##     ## ##     ## ##     ## ##    ## ## 		");
	print("      ## ##     ## ##     ## ##     ## ##       ##		");
	print("      ## ######### ##     ## ##     ##  ######  ######   ");
	print("##    ## ##     ## ##     ## ##     ##       ## ##       ");
	print("##    ## ##     ## ##     ## ##     ## ##    ## ##       ");
	print(" ######  ##     ##  #######   #######   ######  ######## ");
	print("\n\n");
	LoadHouses();
	return 1;
}

CheckMySQL()
{
	if(mysql_ping() == -1)
		mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_DB, MYSQL_PASS);
}

public OnFilterScriptExit()
{
	return 1;
}

command(lockhouse, playerid, params[])
{
	#pragma unused params
	for(new h; h < MAX_HOUSES; h++) {
	    if(IsPlayerInRangeOfPoint(playerid, 3.5, HD[h][exteriorX], HD[h][exteriorY], HD[h][exteriorZ])) {
	        if(strcmp(HD[h][owner], ReturnName(playerid), true) == 0) {
	            if(HD[h][locked] == 0) {
                    GameTextForPlayer(playerid, "House ~r~locked", 3000, 5);
					HD[h][locked] = 1;
	            } else {
	                GameTextForPlayer(playerid, "House ~g~unlocked", 3000, 5);
					HD[h][locked] = 0;
	            }
	        }
		}
		if(IsPlayerInRangeOfPoint(playerid, 3.5, HD[h][interiorX], HD[h][interiorY], HD[h][interiorZ]) && GetPlayerInterior(playerid) == HD[h][interiorInt]) {
	        if(strcmp(HD[h][owner], ReturnName(playerid), true) == 0) {
	            if(HD[h][locked] == 0) {
                    GameTextForPlayer(playerid, "House ~r~locked", 3000, 5);
					HD[h][locked] = 1;
	            } else {
	                GameTextForPlayer(playerid, "House ~g~unlocked", 3000, 5);
					HD[h][locked] = 0;
	            }
	        }
		}
	}
	return 1;
}

command(setprice, playerid, params[])
{
	new HID, HP, string[128];
	if(IsPlayerAdmin(playerid)) {
		if(sscanf(params, "dd", HID, HP)) {
		    SendClientMessage(playerid, WHITE, "SYNTAX: /setprice [HOUSE ID] [HOUSE PRICE]");
		} else {
		    HD[HID][price] = HP;
			format(string, sizeof(string), "You set house %d's price to $%d.", HID, HP);
			SendClientMessage(playerid, WHITE, string);
		}
	}
	return 1;
}

command(buyhouse, playerid, params[])
{
	#pragma unused params
    for(new h; h < MAX_HOUSES; h++) {
	    if(IsPlayerInRangeOfPoint(playerid, 3.5, HD[h][exteriorX], HD[h][exteriorY], HD[h][exteriorZ])) {
     		if(HD[h][price] > -1) {
     		    if(GetPlayerMoney(playerid) >= HD[h][price]) {
					format(HD[h][owner], 24, ReturnName(playerid));
					SendClientMessage(playerid, WHITE, "You have successfully bought the house!");
     		    }
	        } else {
         		GameTextForPlayer(playerid, "House ~r~unavailable", 3000, 5);
	        }
		}
	}
	return 1;
}

command(exithouse, playerid, params[])
{
	#pragma unused params
	for(new h; h < MAX_HOUSES; h++) {
	    if(IsPlayerInRangeOfPoint(playerid, 3.5, HD[InsideHouse[playerid]][interiorX], HD[InsideHouse[playerid]][interiorY], HD[InsideHouse[playerid]][interiorZ])) {
     		if(HD[h][locked] == 0) {
     		    SetPlayerVirtualWorld(playerid, 0);
     			SetPlayerInterior(playerid, 0);
       			SetPlayerPos(playerid, HD[InsideHouse[playerid]][exteriorX], HD[InsideHouse[playerid]][exteriorY], HD[InsideHouse[playerid]][exteriorZ]);
	        } else {
         		GameTextForPlayer(playerid, "House ~r~locked", 3000, 5);
	        }
		}
	}
	return 1;
}

command(enterhouse, playerid, params[])
{
	#pragma unused params
	for(new h; h < MAX_HOUSES; h++) {
	    if(IsPlayerInRangeOfPoint(playerid, 3.5, HD[h][exteriorX], HD[h][exteriorY], HD[h][exteriorZ])) {
     		if(HD[h][locked] == 0) {
				SetPlayerVirtualWorld(playerid, h);
				InsideHouse[playerid] = h;
     			SetPlayerInterior(playerid, HD[h][interiorInt]);
       			SetPlayerPos(playerid, HD[h][interiorX], HD[h][interiorY], HD[h][interiorZ]);
	        } else {
         		GameTextForPlayer(playerid, "House ~r~locked", 3000, 5);
	        }
		}
	}
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	new string[128];
	for(new h; h < MAX_HOUSES; h++) {
	    if(IsPlayerInRangeOfPoint(playerid, 3.5, HD[h][exteriorX], HD[h][exteriorY], HD[h][exteriorZ])) {
	        if(IsPlayerAdmin(playerid)) {
	            format(string, sizeof(string), "House ID: %d", HD[h][ID]);
	            SendClientMessage(playerid, WHITE, string);
	        }
	        if(strcmp(HD[h][owner], "", true) == 0) {
    			format(string, sizeof(string), "Unowned House\n~R~/buyhouse~w~ to buy for %d", HD[h][price]);
				GameTextForPlayer(playerid, string, 5000, 5);
	        } else {
	            if(HD[h][locked] == 1) format(string, sizeof(string), "%'s House\n~r~Locked", HD[h][price]);
	            else format(string, sizeof(string), "%'s House\n~g~Unlocked", HD[h][price]);
				GameTextForPlayer(playerid, string, 5000, 5);
	        }
	    }
	}
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public ConnectMySQL()
{
	if(mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_DB, MYSQL_PASS)) {
	    print("[MySQL] Connected to the MySQL Database successfully!");
 	} else {
	    print("[MySQL] Could not connect to the MySQL Database!");
	}
}

explode(const sSource[], aExplode[][], const sDelimiter[] = " ", iVertices = sizeof aExplode, iLength = sizeof aExplode[]) // Created by Westie
{
	new
		iNode,
		iPointer,
		iPrevious = -1,
		iDelimiter = strlen(sDelimiter);

	while(iNode < iVertices)
	{
		iPointer = strfind(sSource, sDelimiter, false, iPointer);

		if(iPointer == -1)
		{
			strmid(aExplode[iNode], sSource, iPrevious, strlen(sSource), iLength);
			break;
		}
		else
		{
			strmid(aExplode[iNode], sSource, iPrevious, iPointer, iLength);
		}

		iPrevious = (iPointer += iDelimiter);
		++iNode;
	}
	return iPrevious;
}

LoadHouses()
{
	new
	    extx[11],
		exty[11],
		extz[11],
		intx[11],
		inty[11],
		intz[11];
	print("House loading started...");
	mysql_query("SELECT NULL FROM houses");
	mysql_store_result();
	new rows = mysql_num_rows();
	mysql_free_result();

	CheckMySQL();

	for(new i; i < rows; i++) {
		new string[128];
		format(string, sizeof(string), "SELECT * FROM houses WHERE ID = '%d'", i);
		mysql_query(string);
		mysql_store_result();

		//if(!mysql_num_rows())
		//	return SendClientMessage(playerid, COLOR_RED, "[ACCOUNT] Incorrect password!");
		new row[128]; // The length of 1 'row' total.
		new field[11][24];
		mysql_fetch_row_format(row, "|");
		explode(row, field, "|");
		mysql_free_result();
		mysql_fetch_field_row(HD[i][ID], "ID");
		mysql_fetch_field_row(HD[i][owner], "owner");
		mysql_fetch_field_row(HD[i][price], "price");
		mysql_fetch_field_row(extx, "exteriorX");
		mysql_fetch_field_row(exty, "exteriorY");
		mysql_fetch_field_row(extz, "exteriorZ");
		mysql_fetch_field_row(intx, "interiorX");
		mysql_fetch_field_row(inty, "interiorY");
		mysql_fetch_field_row(intz, "interiorZ");
		HD[i][exteriorX] = floatstr(extx);
		HD[i][exteriorY] = floatstr(exty);
		HD[i][exteriorZ] = floatstr(extz);
		HD[i][interiorX] = floatstr(intx);
		HD[i][interiorY] = floatstr(inty);
		HD[i][interiorZ] = floatstr(intz);
		mysql_fetch_field_row(HD[i][interiorInt], "interiorInt");
		mysql_fetch_field_row(HD[i][locked], "locked");
		if(strlen(HD[i][owner]) > 0) CreatePickup(1273, 1, HD[i][exteriorX], HD[i][exteriorY], HD[i][exteriorZ], -1);
		else CreatePickup(1272, 1, HD[i][exteriorX], HD[i][exteriorY], HD[i][exteriorZ], -1);
		printf("House %d created", i);
	}
	print("House loading finished.");
}

public BuildHouse(hprice, Float:hexteriorX, Float:hexteriorY, Float:hexteriorZ, Float:hinteriorX, Float:hinteriorY, Float:hinteriorZ, hinteriorInt, hlocked) {
	mysql_query("SELECT NULL FROM houses");
	mysql_store_result();
	new rows = mysql_num_rows();
	mysql_free_result();
	new houseID = rows++;
	if(houseID < MAX_HOUSES) {
		CheckMySQL();
		new string[128];
		format(string, sizeof(string), "INSERT INTO houses (ID, owner, price, exteriorX, exteriorY, exteriorZ, interiorX, interiorY, interiorZ, interiorInt, locked) VALUES");
		format(string, sizeof(string), "%s VALUES ('%d', '', %d, %f, %f, %f, %f, %f, %f, %d, '1')", string, houseID, hprice, hexteriorX, hexteriorY, hexteriorZ, hinteriorX, hinteriorY, hinteriorZ, hinteriorInt);
		mysql_query(string);
		CreatePickup(1273, 1, hexteriorX, hexteriorY, hexteriorZ, -1);
		printf("House %d created", houseID);
		HD[houseID][ID] = houseID;
		HD[houseID][price] = hprice;
	 	HD[houseID][exteriorX] = hexteriorX;
		HD[houseID][exteriorY] = hexteriorY;
		HD[houseID][exteriorZ] = hexteriorZ;
		HD[houseID][interiorX] = hinteriorX;
		HD[houseID][interiorY] = hinteriorY;
		HD[houseID][interiorZ] = hinteriorZ;
		HD[houseID][interiorInt] = hinteriorInt;
		HD[houseID][locked] = hlocked;
		format(HD[houseID][owner], 24, "");
	} else {
		print("Too many houses!");
	}
}

command(createhouse, playerid, params[])
{
	new type[128];
	if(IsPlayerAdmin(playerid)) {
		if(sscanf(params, "s", type))
		{
			SendClientMessage(playerid, WHITE, "SYNTAX: /createhouse option - options: Help|Interior|Exterior|Finish");
		} else {
			if(strcmp(type, "help", true) == 0) {
			    SendClientMessage(playerid, WHITE, "jHouse by Jameskmonger - Help!");
			    SendClientMessage(playerid, WHITE, "Go to the spot you want the entrance to be and type /createhouse Exterior");
			    SendClientMessage(playerid, WHITE, "Then go to the interior you want them to be teleported to, in the exit position, and do /createhouse Interior");
			    SendClientMessage(playerid, WHITE, "Then do /createhouse Finish. The house will be unavailable to buy at first, but do /sethouseprice [price]");
			    SendClientMessage(playerid, WHITE, "To make it available.");
			}
		    if(strcmp("exterior", type, true) == 0) {
		        GetPlayerPos(playerid, HC[playerid][exteriorX], HC[playerid][exteriorY],HC[playerid][exteriorZ]);
		    }
		    if(strcmp("interior", type, true) == 0) {
		        GetPlayerPos(playerid, HC[playerid][interiorX], HC[playerid][interiorY],HC[playerid][interiorZ]);
		        HC[playerid][interiorInt] = GetPlayerInterior(playerid);
		    }
		    if(strcmp("finish", type, true) == 0) {
		        BuildHouse(-1, HC[playerid][exteriorX], HC[playerid][exteriorY],HC[playerid][exteriorZ], HC[playerid][interiorX], HC[playerid][interiorY],HC[playerid][interiorZ], HC[playerid][interiorInt], 1);
				SendClientMessage(playerid, WHITE, "House created!");
			}
		}
	} else {
		SendClientMessage(playerid, WHITE, "You are not authorised to use that command.");
		return 1;
	}
	return 1;
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
				setarg(paramPos, 0, _:floatstr(string[stringPos]));
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
				if ((ch = strfind(string, format[formatPos], false, stringPos))  == -1)
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
					foreach(Player, playerid)
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

stock ReturnName(playerid) {
	new name[24];
	GetPlayerName(playerid, name, 24);
	return name;
}
