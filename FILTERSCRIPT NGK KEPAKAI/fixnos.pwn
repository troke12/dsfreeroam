             /*-*-*-*-*-*-**-*-*-*-*-*-**-*-*-*-*-*-**-*-*-*-*/
             //   FFFFFF  EEEEEE  CCCCC   EEEEEE  EEEEEE  !!  //
             //   FF      EE      CC  CC  EE      EE      !!  //
             //   FFFF    EEEE    CC  CC  EEEE    EEEE    !!  //
             //   FF      EE      CC  CC  EE      EE      !!  //
             //   FF      EEEEEE  CCCCC   EEEEEE  EEEEEE  00  //
             //   Fix car and Infinite NOS system by Fedee!   //
             /*-*-*-*-*-*-**-*-*-*-*-*-**-*-*-*-*-*-**-*-*-*-*/

// ========================================================================== //

#define FILTERSCRIPT
#define COLOR_YELLOW 0xFFFF00AA
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define IsPlayerNotInVehicle(%0) (!IsPlayerInAnyVehicle(%0))
#include <a_samp>
#if defined FILTERSCRIPT
forward InfiniteNitro();
////////////////////////////////////////////////////////////////////////////////
public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Fix car and infinite NOS made by Feche.");
	print("--------------------------------------\n");
	
	SetTimer("InfiniteNitro",2000,1);
	return 1;
	
}
////////////////////////////////////////////////////////////////////////////////
public InfiniteNitro()
{
    new vehicleid;
	for(new i=0;i<MAX_PLAYERS;i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(GetPlayerState(i)==2)
	        {
	            vehicleid=GetPlayerVehicleID(i);
	    		if(CheckVehicle(vehicleid))
				AddVehicleComponent(vehicleid,1010);
			}
		}
	}
	return 0;
}
////////////////////////////////////////////////////////////////////////////////
stock CheckVehicle(vehicleid)
{
    #define MAX_INVALID_NOS_VEHICLES 13

    new InvalidNOSVehicles[MAX_INVALID_NOS_VEHICLES] =
    {
 		522,481,441,468,448,446,513,521,510,430,520,476,463 // Invalid vehicles for NOS
    };

	for(new i = 0; i < MAX_INVALID_NOS_VEHICLES; i++)
	{
 		if(GetVehicleModel(vehicleid) == InvalidNOSVehicles[i]) return false;
	}
    return true;
}
////////////////////////////////////////////////////////////////////////////////
#endif
