//SpeedBoost With Car Fly Nitros by Boom
//Don't Romove the Credits Please
//You can Add it with the credits thanks Enjoy my script


#include a_samp
#define FILTERSCRIPT
#define red 0xF60000AA
#define GREEN 				0x21DD00FF
#define PRESSED(%0) \
(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define COLOR_MESSAGE_YELLOW            0xFFDD00AA
//------------------------------------------------------------------------------
new Float:SpeedBoostMultiplier[MAX_PLAYERS];

// -----------------------------------------------------------------------------

public OnFilterScriptInit()
{
	print("\n-------------------------------------------------");
	print(" Speed Boost With Car Fly Has been loaded by Drifter");
	print("-------------------------------------------------\n");

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
	    if (IsPlayerConnected(i) && !IsPlayerNPC(i))
	    {
	        SpeedBoostMultiplier[i] = 3.0;
	    }
	}

	return 1;
}

// -----------------------------------------------------------------------------

public OnFilterScriptExit()
{
	print("\n------------------------------------------------");
	print(" Unloaded SpeedBoost with CarFly By Drifter Successfully");
	print("------------------------------------------------\n");
	return 1;
}

// -----------------------------------------------------------------------------

public OnPlayerCommandText(playerid, cmdtext[])
{
    new cmd[256];
	new idx;

	cmd = strtok(cmdtext, idx);
	if (strcmp(cmd, "/SpeedBoostSetup", true) == 0 || strcmp(cmd, "/ssb", true) == 0)
	{
	    new strBoostMultiplier[256];
	    new strTempString[256];
      	strBoostMultiplier = strtok(cmdtext, idx);

      	if (!strlen(strBoostMultiplier))
      	{
        	return 1;
      	}

      	if (!IsNumeric2(strBoostMultiplier))
      	{
        	return 1;
      	}

        new Float:BoostMultiplier = floatstr(strBoostMultiplier);

		if (BoostMultiplier < 1.0 || BoostMultiplier > 3.0)
        {
        	SendClientMessage(playerid, COLOR_MESSAGE_YELLOW, "*** Error: You can just change it for 0.1 to 3.0");
        	return 1;
      	}

      	SpeedBoostMultiplier[playerid] = BoostMultiplier;

		format(strTempString,sizeof(strTempString), "*** You set your speed boost multiplier to %0.2f", SpeedBoostMultiplier[playerid]);
        SendClientMessage(playerid, COLOR_MESSAGE_YELLOW, strTempString);

      	return 1;
    }
	return 0;
}

// -----------------------------------------------------------------------------

public OnPlayerConnect(playerid)
{
	SendClientMessage(playerid, COLOR_MESSAGE_YELLOW, "This servers uses Speedbost+CarFly system to boost the car press LMB to bounce press Number 2 and to fix your car press H");
    // (the previous player may of changed it)
	SpeedBoostMultiplier[playerid] = 2.0; //Its 2.0 you can also doing 3.0 and change it
	return 1;
}

// -----------------------------------------------------------------------------

stock strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

// -----------------------------------------------------------------------------

IsNumeric2(const string[])
{
	new length=strlen(string);
	if (length==0) return false;
	for (new i = 0; i < length; i++)
	{
	  if((string[i] > '9' || string[i] < '0' && string[i]!='-' && string[i]!='+' && string[i]!='.') // Not a number,'+' or '-' or '.'
	         || (string[i]=='-' && i!=0)                                             // A '-' but not first char.
	         || (string[i]=='+' && i!=0)                                             // A '+' but not first char.
	     ) return false;
	}
	if (length==1 && (string[0]=='-' || string[0]=='+' || string[0]=='.')) return false;
	return true;
}

// -----------------------------------------------------------------------------

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys == KEY_CROUCH)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			{
    			RepairVehicle(GetPlayerVehicleID(playerid));
			}
		}
	}
	if (PRESSED(KEY_FIRE))
	{
		new
			vehicleid = GetPlayerVehicleID(playerid);
		if (vehicleid)
		{
			AddVehicleComponent(vehicleid, 1010);
		}
	}
	if(newkeys & KEY_FIRE && IsPlayerInAnyVehicle(playerid))
	{
		if(!IsNosVehicle(GetPlayerVehicleID(playerid))) return
		AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
		PlayerPlaySound(playerid, 1133 ,0, 0, 0);
	}
	if(newkeys & KEY_SUBMISSION && IsPlayerInAnyVehicle(playerid))
    {
  		if(IsPlayerInAnyVehicle(playerid))
		{
  			new Float:x, Float:y, Float:z;
			GetVehicleVelocity(GetPlayerVehicleID(playerid), x, y, z);
			SetVehicleVelocity(GetPlayerVehicleID(playerid) ,x ,y ,z+0.3);
		}
    }
	if (IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		if (newkeys & KEY_FIRE)
		{
		    new Float:vx, Float:vy, Float:vz;
		    GetVehicleVelocity(GetPlayerVehicleID(playerid), vx, vy, vz);

		    if (floatabs(vx) < 3 && floatabs(vy) < 3 && floatabs(vz) < 3)
		    {
		    	SetVehicleVelocity(GetPlayerVehicleID(playerid), vx * SpeedBoostMultiplier[playerid], vy * SpeedBoostMultiplier[playerid], vz * SpeedBoostMultiplier[playerid]);
		    }
		    return 1;
		}
	}
	return 1;
}
IsNosVehicle(vehicleid)
{
	#define NO_NOS_VEHICLES 52

	new InvalidNosVehicles[NO_NOS_VEHICLES] =
	{
		581,523,462,521,463,522,461,448,468,586,417,425,469,487,512,520,563,593,
		509,481,510,472,473,493,520,595,484,430,453,432,476,497,513,533,577,
		452,446,447,454,590,569,537,538,570,449,519,460,488,511,519,548,592
	};

	for(new i = 0; i < NO_NOS_VEHICLES; i++)
	{
		if(GetVehicleModel(vehicleid) == InvalidNosVehicles[i])
		{
			return false;
		}
	}
	return true;
}

