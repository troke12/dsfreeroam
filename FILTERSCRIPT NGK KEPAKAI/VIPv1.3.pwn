#if defined VIP
												xxSPEEDYxx's V.I.P System - NEW*
														   3 Levels
										  					 v2.0
COMMANDS - [v1.0]:

V.I.P Level 1 Commands:                             V.I.P Level 2 Commands:                             V.I.P Level 3 Commands:
	/mytime                                         	/vsaveskin                                          /vkick
 	/myweather                                          /dontuseskin                                        /vget
 	/myvw                                               /vweapons                                           /rw
	/mycolor                                            /vipgoto                                            /maxammo
	/vspec                                              /vasay                                              + V.I.P level 1&2 CMDS
	/vspecoff                                           + V.I.P level 1 CMDS
	/spawnme
	/vcmds

COMMANDS - [v2.0]:

V.I.P Level 1 Commands:                             V.I.P Level 2 Commands:                             V.I.P Level 3 Commands:
	/ltc[1 - 13]                                        /vipgod                                         	/vannounce
	/viphouse
	/godcars
	/vcar
	/vspa( V.I.P Special Actions! )
	/stophold!

V.I.P over 35 command! OMG!

#endif

//============ [ Includes ] ============//
		#include <	a_samp  > // Main include!
		#include <  zcmd    > // Find it on: http://forum.sa-mp.com/showthread.php?t=91354&highlight=zcmd
		#include <  sscanf2 > // Find it on: http://forum.sa-mp.com/showthread.php?t=120356
		#include <  foreach >
//======================================//
#define VIPS_SEND_COMMAND //Comment this if you don't want to show messages whena VIP use a command.
#define SHOW_LEVEL_DIALOG //Comment this if you don't want to show the dialog with your VIP level on connect.
//============ [ Colours ] ============//
#define RED 		0xE60000AA
#define YELLOW 		0xFFFF00AA
#define GREEN   	0x00FF00AA
#define ABLUE   	0x2641FEAA
#define COLOR_VIP   0xFF5500AA //aka Orange:P
//====================================//
//========== [ Dialogs ] ==========//
/*
I put the dialogids bigest to not confuse with other dialogs in your FSs/GM
*/
enum
{
	MYLVL,
	VIPS,
	VIPCMDS,
	ONCONN,
	VSPA
};
//====================================//
//============= [ Level Check ] ======//
stock
	bool:False = false
;

#define VipCheck(%0,%1)\
		do{\
	   		if(P_DATA[(%0)][Vip] < (%1)){\
    			new Str[128];\
    			format(Str, 128, "~r~~h~ERROR!~n~~w~You need to be V.I.P level ~y~~h~%d ~w~to use this command!", (%1));\
				return GameTextForPlayer((%0), Str, 3000, 4);\
			}\
		}\
		while(False)
//============= [ SPEC ] =============//
#define ADMIN_SPEC_TYPE_NONE 	(0)
#define ADMIN_SPEC_TYPE_PLAYER 	(1)
#define ADMIN_SPEC_TYPE_VEHICLE (2)
/*
Do not touch this!
*/
//=========== [ Shortcuts ] ==========//
#define Public:%0(%1) \
	forward%0(%1); public%0(%1)
//====================================//
//========== [ News&Enums ] ==========//
enum pInfo
{
    Vip,
    SpecID,
	SpecType,
	God,
	CarGod,
	p_FavSkin
};

new P_DATA[ MAX_PLAYERS ][ pInfo ];
new	DB:Database;
new Float:Position[ MAX_PLAYERS ][ 4 ];
//====================================//

//==================== [ CallBacks ] =========================================//
public OnFilterScriptInit( )
{
    Database = db_open( "Vips.db" ); //Name of the database! You can change it!

	db_query( Database, "CREATE TABLE IF NOT EXISTS `Vips` (`Key` INTEGER PRIMARY KEY AUTOINCREMENT, `Nume` TEXT, `VipLevel` NUMERIC, `VSkin` NUMERIC)" );
    return 1;
}

public OnFilterScriptExit( )
	return db_close( Database );

public OnPlayerConnect( playerid )
{
	new
		Query[ 256 ],
		DBResult:Result,
		Field[ 30 ]
	;

	format( Query, sizeof( Query ), "SELECT * FROM `Vips` WHERE `Nume` = '%s'", PlayerName( playerid ) );
	Result = db_query( Database, Query );

	if ( Result )
	{
		if ( db_num_rows( Result ) )
		{
		    db_get_field_assoc( Result, "VipLevel", Field, 4 ); P_DATA[ playerid ][ Vip ] = strval( Field );
		    db_get_field_assoc( Result, "VSkin", Field, 4 );    P_DATA[ playerid ][ p_FavSkin ] = strval( Field );
		}
		else
		{
		    P_DATA[ playerid ][ Vip ] = 0;
		    P_DATA[ playerid ][ p_FavSkin ] = -1;

		    format( Query, sizeof Query, "INSERT INTO `Vips` VALUES(NULL,'%s','0','-1')", PlayerName( playerid ) );
		    db_query( Database, Query );
	   	}
		db_free_result( Result );
	}
	return 1;
}
public OnPlayerDisconnect( playerid )
{
	new
	    sz_Query[ 128 ]
	;
	format( sz_Query, sizeof sz_Query, "UPDATE `Vips` SET `VipLevel` = '%d',`VSkin` = '%d' WHERE `Nume` = '%s'", P_DATA[ playerid ][ Vip ], P_DATA[ playerid ][ p_FavSkin ], PlayerName( playerid ) );
	db_query( Database, sz_Query );

	foreach(Player, i )
	    if ( GetPlayerState( i ) == PLAYER_STATE_SPECTATING && P_DATA[ i ][ SpecID ] == playerid )
   		   	AdvanceSpectate( i );

	return 1;
}
public OnPlayerDeath( playerid, killerid, reason )
{
	foreach(Player, i )
	    if ( GetPlayerState( i ) == PLAYER_STATE_SPECTATING && P_DATA[ i ][ SpecID ] == playerid )
	       AdvanceSpectate( i );

	return 1;
}
public OnPlayerInteriorChange( playerid, newinteriorid, oldinteriorid )
{
	new i = 0;

	while( i != MAX_PLAYERS )
	{
	    if ( IsPlayerConnected( i ) && GetPlayerState( i ) == PLAYER_STATE_SPECTATING && P_DATA[ i ][ SpecID ] == playerid && P_DATA[ i ][ SpecType ] == ADMIN_SPEC_TYPE_PLAYER )
   		{
   		    SetPlayerInterior( i, newinteriorid );
		}
		i++;
	}
}
public OnPlayerSpawn( playerid )
{
	if ( P_DATA[ playerid ][ p_FavSkin ] != -1 )
		SetPlayerSkin( playerid, P_DATA[ playerid ][ p_FavSkin ] );

	return 1;
}
public OnPlayerKeyStateChange( playerid, newkeys, oldkeys )
{
	if ( GetPlayerState( playerid ) == PLAYER_STATE_SPECTATING && P_DATA[ playerid ][ SpecID ] != INVALID_PLAYER_ID )
	{
		if ( newkeys == KEY_JUMP ) AdvanceSpectate( playerid );
		else if ( newkeys == KEY_SPRINT ) ReverseSpectate( playerid );
	}
	return 1;
}
public OnPlayerEnterVehicle( playerid, vehicleid )
{
	foreach(Player, i )
	{
	    if ( GetPlayerState( i ) == PLAYER_STATE_SPECTATING && P_DATA[ i ][ SpecID ] == playerid )
		{
	        TogglePlayerSpectating( i, 1 );
	        PlayerSpectateVehicle( i, vehicleid );
	        P_DATA[ i ][ SpecType ] = ADMIN_SPEC_TYPE_VEHICLE;
		}
	}
	return 1;
}
public OnPlayerText( playerid, text[ ] )
{
	new textstr[ 128 ];

	if ( text[ 0 ] == '^' && P_DATA[ playerid ][ Vip ] >= 1 )
	{
		format( textstr, sizeof( textstr ),"VIP Chat: {00FF00}%s{FF5500}: %s", PlayerName( playerid ), text[ 1 ] );
		SendVipMessage( COLOR_VIP, textstr );
		return 0;
	}
	return 1;
}
public OnPlayerExitVehicle( playerid, vehicleid )
{
	foreach(Player, i )
	{
    	if ( GetPlayerState( i ) == PLAYER_STATE_SPECTATING && P_DATA[ i ][ SpecID ] == playerid && P_DATA[ i ][ SpecType ] == ADMIN_SPEC_TYPE_VEHICLE)
		{
        	TogglePlayerSpectating( i, 1 );
	        PlayerSpectatePlayer( i, playerid );
    	    P_DATA[ i ][ SpecType ] = ADMIN_SPEC_TYPE_PLAYER;
		}
	}
	return 1;
}

public OnDialogResponse( playerid, dialogid, response, listitem, inputtext[ ] )
{
	switch( dialogid )
	{
 		case VSPA:
		{
		    if ( !response )
		        return 1;

			switch( listitem )
			{
		        case 0:
		        {
	         		for ( new i = 0; i < 5; i++ )
						if ( IsPlayerAttachedObjectSlotUsed( playerid, i ) )
							RemovePlayerAttachedObject( playerid, i );

					SetPlayerAttachedObject( playerid, 1, 19086, 8, -0.049768, -0.014062, -0.108385, 87.458297, 263.478149, 184.123764, 0.622413, 1.041609, 1.012785 );
					SendClientMessage( playerid, COLOR_VIP, "You have holded a {00FF00}dick!" );
					SendClientMessage( playerid, COLOR_VIP, "To stop holding please type {00FF00}/stophold!" );
				}
				case 1:
				{
				   	for ( new i = 0; i < 5; i++ )
						if ( IsPlayerAttachedObjectSlotUsed( playerid, i ) )
							RemovePlayerAttachedObject( playerid, i );

	                SetPlayerAttachedObject( playerid, 0, 1114, 1, 0.138007, 0.002714, -0.157366, 350.942352, 16.794704, 32.683506, 0.791829, 0.471535, 1.032759 );
					SetPlayerAttachedObject( playerid, 1, 1114, 1, 0.138007, 0.002714, 0.064523, 342.729064, 354.099456, 32.369094, 0.791829, 0.471535, 1.032759 );
	                SendClientMessage( playerid, COLOR_VIP, "You have holded a {00FF00}iron!" );
					SendClientMessage( playerid, COLOR_VIP, "To stop holding please type {00FF00}/stophold!" );
				}
				case 2:
				{
				    for ( new i = 0; i < 5; i++ )
						if ( IsPlayerAttachedObjectSlotUsed( playerid, i ) )
							RemovePlayerAttachedObject( playerid, i );

	                SetPlayerAttachedObject( playerid, 0, 18645, 2, 0.017478, 0.051500, 0.003912, 285.055511, 90.860740, 171.179550, 1.780549, 0.912008, 1.208514 );
					SetPlayerAttachedObject( playerid, 1, 18690, 2, -2.979508, 0.306475, -0.388553, 285.055511, 90.860740, 171.179550, 1.780549, 0.912008, 1.208514 );
					SetPlayerAttachedObject( playerid, 2, 18716, 2, -2.979508, 0.306475, -0.388553, 285.055511, 90.860740, 171.179550, 1.780549, 0.912008, 1.208514 );
	                SendClientMessage( playerid, COLOR_VIP, "You have holded as {00FF00}Alien!" );
					SendClientMessage( playerid, COLOR_VIP, "To stop holding please type {00FF00}/stophold!" );
				}
				case 3:
				{
				   	for ( new i = 0; i < 5; i++ )
						if ( IsPlayerAttachedObjectSlotUsed( playerid, i ) )
							RemovePlayerAttachedObject( playerid, i );

	           		SetPlayerAttachedObject( playerid, 0, 18693, 5, 1.983503, 1.558882, -0.129482, 86.705787, 308.978118, 268.198822, 1.500000, 1.500000, 1.500000 );
					SetPlayerAttachedObject( playerid, 1, 18693, 6, 1.983503, 1.558882, -0.129482, 86.705787, 308.978118, 268.198822, 1.500000, 1.500000, 1.500000 );
					SetPlayerAttachedObject( playerid, 2, 18703, 6, 1.983503, 1.558882, -0.129482, 86.705787, 308.978118, 268.198822, 1.500000, 1.500000, 1.500000 );
					SetPlayerAttachedObject( playerid, 3, 18703, 5, 1.983503, 1.558882, -0.129482, 86.705787, 308.978118, 268.198822, 1.500000, 1.500000, 1.500000 );
					SetPlayerAttachedObject( playerid, 4, 18965, 2, 0.111052, 0.021643, -0.000846, 92.280899, 92.752510, 358.071044, 1.200000, 1.283168, 1.200000 );
					SendClientMessage( playerid, COLOR_VIP, "You have holded as {00FF00}Icread!" );
					SendClientMessage( playerid, COLOR_VIP, "To stop holding please type {00FF00}/stophold!" );
				}
				case 4:
				{
				    SetPlayerSpecialAction( playerid, 2 ); //Jetpack!
					SendClientMessage( playerid, COLOR_VIP, "Jetpack Spawmed!" );
				}
			}
		}
	}
	return 1;
}
//============================================================================//
//================ [ Commands v1.0 ] =========================================//
CMD:setvips( playerid, params[ ] )
{
	if ( !IsPlayerAdmin( playerid ) )
		return SendClientMessage( playerid, RED, "Only RCON Administrator can use this command!" );

    new
		string[ 128 ],
		giveplayerid,
		level
	;
	if ( sscanf( params, "ud", giveplayerid, level ) )
		return SendClientMessage( playerid, RED, "USAGE: {FFFF00}/setvips [playerid] [level]" );

	if ( giveplayerid == INVALID_PLAYER_ID )
		return SendClientMessage( playerid, RED, "Player Is Not Connected!" );

	if ( level > 3 || level < 0 )
	 	return SendClientMessage( playerid, RED, "ERROR: Invalid level!" );

 	P_DATA[ giveplayerid ][ Vip ] = level;
 	format( string, sizeof( string ), "Administrator %s has set your V.I.P level to %d!", PlayerName( playerid ), level );
 	SendClientMessage( giveplayerid, ABLUE, string );
	return 1;
}
CMD:vipgoto( playerid , params[ ] )
{
	new PID, string[ 128 ];
	new Float:x, Float:y, Float:z;

	VipCheck( playerid, 2 );

	if ( sscanf( params, "u", PID ) )
		return SendClientMessage( playerid, RED, "USAGE: {FFFF00}/vipgoto [playerid]" );

	if ( IsPlayerConnected( PID ) )
		return SendClientMessage( playerid, RED, "Player not connected or is yourself!" );

	GetPlayerPos( PID , x , y , z );
	SetPlayerInterior( playerid , GetPlayerInterior( PID ) );
	SetPlayerVirtualWorld( playerid , GetPlayerVirtualWorld( PID ) );

	if ( GetPlayerState( playerid ) == PLAYER_STATE_DRIVER )
	{
		SetVehiclePos( GetPlayerVehicleID( playerid ) , x+3 , y , z );
		LinkVehicleToInterior( GetPlayerVehicleID( playerid ), GetPlayerInterior( PID ) );
		SetVehicleVirtualWorld( GetPlayerVehicleID( playerid ), GetPlayerVirtualWorld( PID ) );
		format( string , sizeof( string ), "You have teleported to %s's location!" , PlayerName( PID ) );
		SendClientMessage( playerid ,COLOR_VIP ,string );
		format( string, sizeof( string ), "V.I.P {00FF00}%s(%d) {FF5500}has teleported to your location!", PlayerName( playerid ), P_DATA[ playerid ][ Vip ] );
		SendClientMessage( PID, COLOR_VIP, string );
	} else {

		SetPlayerPos( playerid , x+2 , y , z );
		format( string, sizeof( string ), "V.I.P {00FF00}%s(%d) {FF5500}has teleported to your location!", PlayerName( playerid ), P_DATA[ playerid ][ Vip ] );
		SendClientMessage( PID, COLOR_VIP, string );
		format( string , sizeof( string ), "You have teleported to %s's location!" , PlayerName( PID ) );
		SendClientMessage( playerid ,COLOR_VIP ,string );
	}
	return 1;
}
CMD:spawnme( playerid, params[ ] )
{
	VipCheck( playerid, 1 );

	SpawnPlayer( playerid );
	SendClientMessage( playerid, COLOR_VIP, "You have been respawmed!" );
	return 1;
}
CMD:vips( playerid, params[ ] )
{
	new
		V,
		lsString[ 1024 ]
	;

	foreach(Player, i ) if ( P_DATA[ i ][ Vip ] > 0 )
	{
		format( lsString, sizeof lsString, "{FF5500}%s\n{FF5500}V.I.P {00FF00}%s {FF5500}- Level {00FF00}%d", lsString, PlayerName( i ), P_DATA[ i ][ Vip ] );
		V++;
	}
	if ( V == 0 )
		format( lsString, sizeof lsString, "\n{E60000}No V.I.Ps online at the moment!" );

	return ShowPlayerDialog( playerid, VIPS, DIALOG_STYLE_MSGBOX, "{00FF00}Online V.I.Ps:", lsString, "Quit", "" );
}
CMD:myweather( playerid, params[ ] )
{
	new weather, string[ 128 ];

	VipCheck( playerid, 1 );

	if ( sscanf( params, "d", weather ) ) return SendClientMessage( playerid, RED, "USAGE: {FFFF00}/myweather [weatherid]" );
	if ( ( weather < 0 ) || ( weather > 52 ) ) return SendClientMessage( playerid, RED, "Only between 0 and 52 weather ids!" );

	SetPlayerWeather( playerid, weather );
	format( string, sizeof( string ), "You have set your weather to {E60000}%d", weather );
	SendClientMessage( playerid, COLOR_VIP, string );
	return 1;
}
CMD:mytime( playerid, params[ ] )
{
	new time, string[ 128 ];

	VipCheck( playerid, 1 );

	if ( sscanf( params, "d", time ) ) return SendClientMessage( playerid, RED, "USAGE: {FFFF00}/mytime [time]" );
	if ( ( time < 0 ) || ( time > 24 ) ) return SendClientMessage( playerid, RED, "Only between 0 and 24 hours you can set your time!" );

    SetPlayerTime( playerid, time, 0 );
	format( string, sizeof( string ), "You have set your time to {E60000}%d", time );
	SendClientMessage( playerid, COLOR_VIP, string );
	return 1;
}
CMD:myvw( playerid, params[ ] )
/*
With this function you will be ablle to change your virtual world!
Disponible Virtual Worlds are between 0 and 100 you can change to bigest or lowest on this line:
                        if ( ( vw < 0 ) || ( vw > 100 ) )
*/
{
    new vw, string[ 128 ];

    VipCheck( playerid, 1 );

    if ( sscanf( params, "d", vw ) ) return SendClientMessage( playerid, RED, "USAGE: {FFFF00}/myvw [virtualworld]" );
	if ( ( vw < 0 ) || ( vw > 100 ) ) return SendClientMessage( playerid, RED, "Only between 0 and 100 Virtual Worlds ar disponible!" );

	if ( vw == 0 )
	{
	    SetPlayerVirtualWorld( playerid, 0 );
	    return SendClientMessage( playerid, YELLOW, "You have returned back in normal world( 0 )!" );
	}
	SetPlayerVirtualWorld( playerid, vw );
	format( string, sizeof( string ), "You have set your Virtual World to {E60000}%d", vw );
	SendClientMessage( playerid, COLOR_VIP, string );
	return 1;
}
CMD:vasay( playerid, params[ ] )
{
	new VipMessage[ 180 ];

	VipCheck( playerid, 2 );

	if ( sscanf( params, "s[ 120 ]", VipMessage ) ) return SendClientMessage( playerid, RED, "USAGE: {FFFF00}/vasay [text]" );

	format( VipMessage, sizeof( VipMessage ), "V.I.P - %s {FFFF00}(lvl: %d): {00FF00}%s", PlayerName( playerid ), P_DATA[ playerid ][ Vip ], VipMessage );
	SendClientMessageToAll( COLOR_VIP, VipMessage );
	return 1;
}
CMD:vammo( playerid, params[ ] )
{
	VipCheck( playerid, 3 );

	SendPlayerMaxAmmo( playerid );
	SendClientMessage( playerid, COLOR_VIP, "You have added {00FF00}Max Ammo{FF5500} to your weapons!" );
    return 1;
}
CMD:vweapons( playerid, params[ ] )
{
	VipCheck( playerid, 2 );

	GivePlayerWeapon( playerid ,28, 120) ; 	// Weapons: Micro SMG || Ammo: 120
	GivePlayerWeapon( playerid, 31, 75 ); 	// Weapons: M4 || Gloante: 75
	GivePlayerWeapon( playerid, 34, 15 ); 	// Weapons: Sniper Rifle || Ammo: 15
	GivePlayerWeapon( playerid, 26, 100 ); 	// Weapons: Sawn-off Shotgun || Ammo: 100
	return 1;
}
CMD:vspec( playerid, params[ ] )
{
    new
		PID,
		string[ 128 ]
	;

    VipCheck( playerid, 1 );

	if ( sscanf( params, "u", PID ) )
		return SendClientMessage( playerid, RED, "USAGE: {FFFF00}/vspec [playerid]" );

    if ( !IsPlayerConnected( PID ) )
		return SendClientMessage( playerid, RED, "ERROR: Player is not connected!" );

	if ( GetPlayerState( PID ) == PLAYER_STATE_SPECTATING && P_DATA[ PID ][ SpecID ] != INVALID_PLAYER_ID )
		return SendClientMessage( playerid, RED, "ERROR: Player spectating someone else!" );

	if ( GetPlayerState( PID ) == 1 && GetPlayerState( PID ) == 2 && GetPlayerState( PID ) == 3 )
	    return SendClientMessage( playerid, RED, "ERROR: Player not spawned!" );

	SpectatePlayer( playerid, PID );
	GetPlayerPos( playerid, Position[ playerid ][ 0 ], Position[ playerid ][ 1 ], Position[ playerid ][ 2 ] );
	GetPlayerFacingAngle( playerid, Position[ playerid ][ 3 ] );
	format( string, sizeof( string ), "Now you spectating %s (%d)", PlayerName( PID ), PID );
	SendClientMessage( playerid, COLOR_VIP, string );
	return 1;
}
CMD:vspecoff( playerid, params[ ] )
{
    VipCheck( playerid, 1 );

    if ( P_DATA[ playerid ][ SpecType ] == ADMIN_SPEC_TYPE_NONE )
        return SendClientMessage( playerid, RED, "ERROR: You are not spectating" );

	StopSpectate( playerid );
	SetTimerEx("ReturnPosition", 3000, 0, "d", playerid );
	SendClientMessage( playerid, COLOR_VIP, "You have stop spectating" );
	return 1;
}
CMD:vsaveskin( playerid, params[ ] )
{
 	VipCheck( playerid, 2 );

 	new
		SkinID,
		string[ 128 ]
	;
	if ( sscanf( params, "i", SkinID ) )
	    return SendClientMessage( playerid, RED, "USAGE: {FFFF00}/vsaveskin [Current SkinID]" );

	if ( SkinID != GetPlayerSkin( playerid ) )
	    return SendClientMessage( playerid, RED, "ERROR: Skin enterd don't match with your current skin!" );

	if ( SkinID < 0 || SkinID > 300 )
	    return SendClientMessage( playerid, RED, "ERROR: Invalid skin! Only between 0 and 300 !" );

	format( string, sizeof( string ), "You have successfully saved this skin (ID: %d)", SkinID );
	SendClientMessage( playerid, COLOR_VIP, string );
	SendClientMessage( playerid, COLOR_VIP, "Type /dontuseskin for don't save again this skin!" );

	return 1;
}
CMD:dontuseskin( playerid, params[ ] )
{
	VipCheck( playerid, 2 );

    P_DATA[ playerid ][ p_FavSkin ] = -1;
    SetPlayerSkin( playerid, random( 300 ) );

    SendClientMessage( playerid, COLOR_VIP, "Your saved skin is never been used!" );
	return 1;
}
CMD:mycolor( playerid, params[ ] )
{
    VipCheck( playerid, 1 );

    new Colour, colour[ 7 ];
	if ( sscanf( params, "d", Colour ) )
		return SendClientMessage( playerid, RED, "ERROR: {FFFF00}/mycolor [color]" ), SendClientMessage( playerid, RED, "0 = Black | 1 = White | 2 = Red | 3 = Orange | 4 = Yellow | 5 = Green | 6 = Blue | 7 = Purple | 8 = Brown" );

	if ( Colour > 8 )
		return SendClientMessage( playerid, RED, "Colours: 0 = Black | 1 = White | 2 = Red | 3 = Orange | 4 = Yellow | 5 = Green | 6 = Blue | 7 = Purple | 8 = Brown" );

	switch ( Colour )
	{
	 	case 0: SetPlayerColor( playerid, 0x000000AA ), colour = "Black";
	  	case 1: SetPlayerColor( playerid, 0xFFFFFFAA ), colour = "White";
	   	case 2: SetPlayerColor( playerid, 0xE60000AA ), colour = "Red";
	   	case 3: SetPlayerColor( playerid, 0xFF5500AA ), colour = "Orange";
		case 4: SetPlayerColor( playerid, 0xFFFF00AA ), colour = "Yellow";
		case 5: SetPlayerColor( playerid, 0x00FF00AA ), colour = "Green";
		case 6: SetPlayerColor( playerid, 0x0000BBAA ), colour = "Blue";
		case 7: SetPlayerColor( playerid, 0x800080AA ), colour = "Purple";
		case 8: SetPlayerColor( playerid, 0xA52A2AAA ), colour = "Brown";
	}

    return 1;
}
CMD:vmenu( playerid, params[ ] )
{
	VipCheck( playerid, 1 );

	new string[ 1024 ];
	strcat( string, "{FF5500}V.I.P Level {00FF00}1 {FF5500}Commands:\t{FF5500}V.I.P Level {00FF00}2 {FF5500}Commands:\t{FF5500}V.I.P Level {00FF00}3 {FF5500}Commands:\n\n" );
	strcat( string, "{FFFF00}/mytime\t\t\t/vsaveskin\t\t\t/vkick\n" );
	strcat( string, "/myweather\t\t\t/dontuseskin\t\t\t/vget\n" );
	strcat( string, "/myvw\t\t\t\t/vweapons\t\t\t/rw\n" );
	strcat( string, "/mycolor\t\t\t/vipgoto\t\t\t/vammo\n" );
	strcat( string, "/vspec\t\t\t\t/vjetpack\t\t\t/vasay\t\t\t\t\n" );
	strcat( string, "/vspecoff\n/spawnme\n/vmenu\n" );
	strcat( string, "{E60000}/ltc[1-13]\t\t\t/vgodon~GOD~ON\n/vgodoff~GOD~OFF\n/vannounce\n" );
	strcat( string, "{E60000}/vcar\n/vspa\n/stophold\n/viphouse\n" );
	strcat( string, "\t\t\t\t{FFFF00}+V.I.P level 1 CMDS\t\t+ V.I.P level 1&2 CMDS\n\n\n" );
	strcat( string, "{FF5500}GUNAKAN simbol {00FF00}^ {FF5500}UNTUK CHAT SESAMA VIP\n" );
	ShowPlayerDialog( playerid, VIPCMDS, DIALOG_STYLE_MSGBOX, "DRIFT STUNTING VIP MENU", string, "Quit", "" );
	return 1;
}
CMD:vgets( playerid, params[ ] )
{
	new PID, string[ 256 ];
	new Float:x, Float:y, Float:z;

    VipCheck( playerid, 3 );

    if ( sscanf( params, "u", PID ) )
		return SendClientMessage( playerid, RED, "USAGE: {FFFF00}/vgets [playerid]" );

 	if ( !IsPlayerConnected( PID ) )
 	    return SendClientMessage( playerid, RED, "Player is not connected or is yourself!" );

	GetPlayerPos( playerid, x, y, z );
 	SetPlayerInterior( PID, GetPlayerInterior( playerid ) );
	SetPlayerVirtualWorld( PID, GetPlayerVirtualWorld( playerid ) );
	if ( GetPlayerState( PID ) == 2 )
	{
	    new VehicleID = GetPlayerVehicleID( PID );
		SetVehiclePos( VehicleID, x+3, y, z);
		LinkVehicleToInterior( VehicleID, GetPlayerInterior( PID ) );
		SetVehicleVirtualWorld( GetPlayerVehicleID( PID ), GetPlayerVirtualWorld( PID ) );
		format( string, sizeof( string ),"You have been teleported to V.I.P {00FF00}%s's {FF5500}location", PlayerName( playerid ) );
		SendClientMessage( PID, COLOR_VIP, string );
		format( string, sizeof( string ),"You have teleported {00FF00}%s {FF5500}to your location", PlayerName( PID ) );
		SendClientMessage( playerid, COLOR_VIP, string );
	} else {
		SetPlayerPos( PID, x+2, y, z );
		format( string, sizeof( string ),"You have been teleported to V.I.P {00FF00}%s's {FF5500}location", PlayerName( playerid ) );
		SendClientMessage( PID, COLOR_VIP, string );
		format( string, sizeof( string ),"You have teleported {00FF00}%s {FF5500}to your location", PlayerName( PID ) );
	 	SendClientMessage( playerid, COLOR_VIP, string );
  	}
	return 1;
}
CMD:vkick( playerid, params[ ] )
{
    new string[ 128 ];

    VipCheck( playerid, 3 );

    if ( sscanf( params, "us[ 128 ]", params[ 0 ], params[ 1 ] ) )
		return SendClientMessage( playerid, RED, "USAGE: {FFFF00}/vkick [playerid] [reason]" );

    if ( IsPlayerConnected( params[ 0 ] ) )
		return SendClientMessage( playerid, RED, "Player is not connected !" );

    if ( !strlen( params[ 1 ] ) )
    {
		format( string, sizeof( string ), "%s {FF5500}has been kicked by V.I.P {00FF00}%s {FF5500}[no reason given]!",PlayerName( params[ 0 ] ), PlayerName( playerid ) );
        SendClientMessageToAll( GREEN, string );
        Kick( params[ 0 ] );
	}
	else
	{
        format( string, sizeof( string ), "%s {FF5500}has been kicked by V.I.P {00FF00}%s {FF5500}[reason: {00FF00%s{FF5500}] ", PlayerName( params[ 0 ] ), PlayerName( playerid ), params[ 1 ] );
        SendClientMessageToAll( GREEN, string );
        Kick( params[ 0 ] );
	}

	return 1;
}
CMD:rw( playerid, params[ ] )
{
	VipCheck( playerid, 3 );

	GivePlayerWeapon( playerid, 4, 1); //Knife
	GivePlayerWeapon( playerid, 28, 1000); // Micro - SMG
	GivePlayerWeapon( playerid, 26, 100); // Sawn-off Shotgun
	GivePlayerWeapon( playerid, 22, 500); // 9mm Pistol
	//Source: http://wiki.sa-mp.com/wiki/Weapons !
	SendClientMessage( playerid, COLOR_VIP, "You got an Runing Weapons package!" );

	return 1;
}
CMD:vipgod( playerid, params[ ] )
{
	VipCheck( playerid, 2 );

    switch( P_DATA[ playerid ][ God ] )
    {
        case 0:
        {
			P_DATA[ playerid ][ God ] = 1;
			SendClientMessage( playerid, COLOR_VIP, "You have activated the V.I.P {00FF00}God Mode!" );
		}
		case 1: P_DATA[ playerid ][ God ] = 0;
	}

	return 1;
}
CMD:godcars( playerid, params[ ] )
{
	VipCheck( playerid, 1 );

    switch( P_DATA[ playerid ][ CarGod ] )
    {
        case 0:
		{
			P_DATA[ playerid ][ CarGod ] = 1;
			SendClientMessage( playerid, COLOR_VIP, "You have activated the Vehicle {00FF00}God Mode!" );
		}
		case 1: P_DATA[ playerid ][ CarGod ] = 0;
	}
	return 1;
}
CMD:ltc1( playerid, params[ ] )
{
    new Float:x, Float:y, Float:z, Float:Angle, VehiclulRt;

	VipCheck( playerid, 1 );

	if ( IsPlayerInAnyVehicle( playerid ) )
		return SendClientMessage( playerid, RED, "ERROR: You already have a vehicle" );

	GetPlayerPos( playerid, x, y, z);
	GetPlayerFacingAngle( playerid, Angle );
	VehiclulRt = CreateVehicle( 560, x, y, z, Angle, 1, -1, -1 );
	PutPlayerInVehicle( playerid, VehiclulRt, 0);
	AddVehicleComponent( VehiclulRt, 1028 );	AddVehicleComponent( VehiclulRt, 1030 );	AddVehicleComponent( VehiclulRt, 1031 );	AddVehicleComponent( VehiclulRt, 1138 );	AddVehicleComponent(VehiclulRt, 1140);  AddVehicleComponent(VehiclulRt, 1170);
	AddVehicleComponent( VehiclulRt, 1028 );	AddVehicleComponent( VehiclulRt, 1030 );	AddVehicleComponent( VehiclulRt, 1031 );	AddVehicleComponent( VehiclulRt, 1138 );	AddVehicleComponent(VehiclulRt, 1140);  AddVehicleComponent(VehiclulRt, 1170);
	AddVehicleComponent( VehiclulRt, 1080 );	AddVehicleComponent( VehiclulRt, 1086 ); 	AddVehicleComponent( VehiclulRt, 1087 ); 	AddVehicleComponent( VehiclulRt, 1010 );
	PlayerPlaySound( playerid, 1133, 0.0, 0.0, 0.0 );
	ChangeVehiclePaintjob( VehiclulRt, 0 );
	SetVehicleVirtualWorld( VehiclulRt, GetPlayerVirtualWorld( playerid ) );
	LinkVehicleToInterior( VehiclulRt, GetPlayerInterior( playerid ) );
	return 1;
}
CMD:ltc2( playerid, params[ ] )
{
    new Float:x, Float:y, Float:z, Float:Angle, VehiclulRt;

	VipCheck( playerid, 1 );

	if ( IsPlayerInAnyVehicle( playerid ) )
		return SendClientMessage( playerid, RED, "ERROR: You already have a vehicle" );

	GetPlayerPos( playerid, x, y, z );
	GetPlayerFacingAngle( playerid, Angle );
    VehiclulRt = CreateVehicle( 560, x, y, z, Angle, 1, -1, -1 );
	PutPlayerInVehicle( playerid, VehiclulRt, 0 );
	AddVehicleComponent( VehiclulRt, 1028 );	AddVehicleComponent( VehiclulRt, 1030 );	AddVehicleComponent( VehiclulRt, 1031 );	AddVehicleComponent( VehiclulRt, 1138 );	AddVehicleComponent( VehiclulRt, 1140 );  AddVehicleComponent( VehiclulRt, 1170 );
    AddVehicleComponent( VehiclulRt, 1028 );	AddVehicleComponent( VehiclulRt, 1030 );	AddVehicleComponent( VehiclulRt, 1031 );	AddVehicleComponent( VehiclulRt, 1138 );	AddVehicleComponent( VehiclulRt, 1140 );  AddVehicleComponent( VehiclulRt, 1170 );
    AddVehicleComponent( VehiclulRt, 1080 );	AddVehicleComponent( VehiclulRt, 1086 ); 	AddVehicleComponent( VehiclulRt, 1087 ); 	AddVehicleComponent( VehiclulRt, 1010 );
	PlayerPlaySound( playerid, 1133, 0.0, 0.0, 0.0 );
	ChangeVehiclePaintjob( VehiclulRt, 1 );
   	SetVehicleVirtualWorld( VehiclulRt, GetPlayerVirtualWorld( playerid ) );
    LinkVehicleToInterior( VehiclulRt, GetPlayerInterior( playerid ) );
	return 1;
}

CMD:ltc3( playerid, params[ ] )
{
    new Float:x, Float:y, Float:z, Float:Angle, VehiclulRt;

	VipCheck( playerid, 1 );

	if ( IsPlayerInAnyVehicle( playerid ) )
		return SendClientMessage( playerid, RED, "ERROR: You already have a vehicle" );

	GetPlayerPos( playerid, x, y, z );
	GetPlayerFacingAngle( playerid, Angle );
    VehiclulRt = CreateVehicle( 560, x, y, z, Angle, 1, -1, -1 );
	PutPlayerInVehicle( playerid, VehiclulRt, 0 );
	AddVehicleComponent( VehiclulRt, 1028 );    AddVehicleComponent( VehiclulRt, 1138 );    AddVehicleComponent( VehiclulRt, 1170 );
	AddVehicleComponent( VehiclulRt, 1030 );	AddVehicleComponent( VehiclulRt, 1031 );	AddVehicleComponent( VehiclulRt, 1140 );
    AddVehicleComponent( VehiclulRt, 1080 );	AddVehicleComponent( VehiclulRt, 1086 ); 	AddVehicleComponent( VehiclulRt, 1087 ); AddVehicleComponent( VehiclulRt, 1010 );
	PlayerPlaySound( playerid, 1133, 0.0, 0.0, 0.0 );
	ChangeVehiclePaintjob( VehiclulRt, 2 );
   	SetVehicleVirtualWorld( VehiclulRt, GetPlayerVirtualWorld( playerid ) );
    LinkVehicleToInterior( VehiclulRt, GetPlayerInterior( playerid ) );
	return 1;
}

CMD:ltc4( playerid, params[ ] )
{
    new Float:x, Float:y, Float:z, Float:Angle, carid;

	VipCheck( playerid, 1 );

	if ( IsPlayerInAnyVehicle( playerid ) )
		return SendClientMessage( playerid, RED, "ERROR: You already have a vehicle" );

	GetPlayerPos( playerid, x, y, z );
	GetPlayerFacingAngle( playerid, Angle );
    carid = CreateVehicle( 559, x, y, z, Angle, 1, -1, -1 );
	PutPlayerInVehicle( playerid, carid, 0 );
	AddVehicleComponent( carid, 1065 );    	AddVehicleComponent( carid, 1067 );     AddVehicleComponent( carid, 1073 );
	AddVehicleComponent( carid, 1162 );		AddVehicleComponent( carid, 1010 ); 	ChangeVehiclePaintjob( carid, 1 );
   	SetVehicleVirtualWorld( carid, GetPlayerVirtualWorld( playerid ) );
	LinkVehicleToInterior( carid, GetPlayerInterior( playerid ) );
	return 1;
}

CMD:ltc5( playerid, params[ ] )
{
    new Float:x, Float:y, Float:z, Float:Angle, carid;

	VipCheck( playerid, 1 );

	if ( IsPlayerInAnyVehicle( playerid ) )
		return SendClientMessage( playerid, RED, "ERROR: You already have a vehicle" );

	GetPlayerPos( playerid, x, y, z );
	GetPlayerFacingAngle( playerid, Angle );
    carid = CreateVehicle( 565, x, y, z, Angle, 1, -1, -1 );
	PutPlayerInVehicle( playerid, carid, 0 );
    AddVehicleComponent( carid, 1046 ); 	AddVehicleComponent( carid, 1049 );     AddVehicleComponent( carid, 1073 );
	AddVehicleComponent( carid, 1053 ); 	AddVehicleComponent( carid, 1010 );  	ChangeVehiclePaintjob( carid, 1 );
   	SetVehicleVirtualWorld( carid, GetPlayerVirtualWorld( playerid ) );
	LinkVehicleToInterior( carid, GetPlayerInterior( playerid ) );
	return 1;
}

CMD:ltc6( playerid, params[ ] )
{
    new Float:x, Float:y, Float:z, Float:Angle, carid;

	VipCheck( playerid, 1 );

	if ( IsPlayerInAnyVehicle( playerid ) )
		return SendClientMessage( playerid, RED, "ERROR: You already have a vehicle" );

	GetPlayerPos( playerid, x, y, z );
	GetPlayerFacingAngle( playerid, Angle );
    carid = CreateVehicle( 558, x, y, z, Angle, 1, -1, -1 );
	PutPlayerInVehicle( playerid, carid, 0 );
	AddVehicleComponent( carid, 1088 ); 	AddVehicleComponent( carid, 1092 );     AddVehicleComponent( carid, 1073 );
 	AddVehicleComponent( carid, 1139 ); 	AddVehicleComponent( carid, 1010 );  	ChangeVehiclePaintjob( carid, 1 );
   	SetVehicleVirtualWorld( carid, GetPlayerVirtualWorld( playerid ) );
  	LinkVehicleToInterior( carid, GetPlayerInterior( playerid ) );
	return 1;
}

CMD:ltc7( playerid, params[ ] )
{
    new Float:x, Float:y, Float:z, Float:Angle, carid;

	VipCheck( playerid, 1 );

	if ( IsPlayerInAnyVehicle( playerid ) )
		return SendClientMessage( playerid, RED, "ERROR: You already have a vehicle" );

	GetPlayerPos( playerid, x, y, z );
	GetPlayerFacingAngle( playerid, Angle );
    carid = CreateVehicle( 561, x, y, z, Angle, 1, -1, -1 );
	PutPlayerInVehicle( playerid, carid, 0 );
	AddVehicleComponent( carid, 1055 ); 	AddVehicleComponent( carid, 1058 ); 	AddVehicleComponent( carid, 1073 );
	AddVehicleComponent( carid, 1064 ); 	AddVehicleComponent( carid, 1010 );  	ChangeVehiclePaintjob( carid, 1 );
   	SetVehicleVirtualWorld( carid, GetPlayerVirtualWorld( playerid ) );
 	LinkVehicleToInterior( carid, GetPlayerInterior( playerid ) );
	return 1;
}

CMD:ltc8( playerid, params[ ] )
{
 	new Float:x, Float:y, Float:z, Float:Angle, carid;

	VipCheck( playerid, 1 );

	if ( IsPlayerInAnyVehicle( playerid ) )
		return SendClientMessage( playerid, RED, "ERROR: You already have a vehicle" );

	GetPlayerPos( playerid, x, y, z );
	GetPlayerFacingAngle( playerid, Angle );
    carid = CreateVehicle( 562, x, y, z, Angle, 1, -1, -1 );
	PutPlayerInVehicle( playerid, carid, 0 );
    AddVehicleComponent( carid, 1034 ); 	AddVehicleComponent( carid, 1038 );     AddVehicleComponent( carid, 1073 );
	AddVehicleComponent( carid, 1147 ); 	AddVehicleComponent( carid, 1010 );  	ChangeVehiclePaintjob( carid, 1 );
   	SetVehicleVirtualWorld( carid, GetPlayerVirtualWorld( playerid ) );
	LinkVehicleToInterior( carid, GetPlayerInterior( playerid ) );
	return 1;
}

CMD:ltc9( playerid, params[ ] )
{
	new Float:x, Float:y, Float:z, Float:Angle, carid;

	VipCheck( playerid, 1 );

	if ( IsPlayerInAnyVehicle( playerid ) )
		return SendClientMessage( playerid, RED, "ERROR: You already have a vehicle" );

	GetPlayerPos( playerid, x, y, z );
	GetPlayerFacingAngle( playerid, Angle );
    carid = CreateVehicle( 567, x, y, z, Angle, 1, -1, -1 );
	PutPlayerInVehicle( playerid, carid, 0 );
    AddVehicleComponent( carid, 1102 ); 	AddVehicleComponent( carid, 1129 );     AddVehicleComponent( carid, 1188 );     AddVehicleComponent( carid, 1087 );     AddVehicleComponent( carid, 1086 );
	AddVehicleComponent( carid, 1133 ); 	AddVehicleComponent( carid, 1186 );  	AddVehicleComponent( carid, 1010 ); 	AddVehicleComponent( carid, 1085 );   	ChangeVehiclePaintjob( carid, 1 );
   	SetVehicleVirtualWorld( carid, GetPlayerVirtualWorld( playerid ) );
 	LinkVehicleToInterior( carid, GetPlayerInterior( playerid ) );
	return 1;
}

CMD:ltc10( playerid, params[ ] )
{
    new Float:x, Float:y, Float:z, Float:Angle, carid;

	VipCheck( playerid, 1 );

	if ( IsPlayerInAnyVehicle( playerid ) )
		return SendClientMessage( playerid, RED, "ERROR: You already have a vehicle" );

	GetPlayerPos( playerid, x, y, z );
	GetPlayerFacingAngle( playerid, Angle );
    carid = CreateVehicle( 558, x, y, z, Angle, 1, -1, -1 );
	PutPlayerInVehicle( playerid, carid, 0 );
	AddVehicleComponent( carid, 1092 ); 	AddVehicleComponent( carid, 1166 ); 	AddVehicleComponent( carid, 1165 ); 	AddVehicleComponent( carid, 1090 );
    AddVehicleComponent( carid, 1094 ); 	AddVehicleComponent( carid, 1010 ); 	AddVehicleComponent( carid, 1087 ); 	AddVehicleComponent( carid, 1163 );
    AddVehicleComponent( carid, 1091 ); 	ChangeVehiclePaintjob( carid, 2 );
   	SetVehicleVirtualWorld( carid, GetPlayerVirtualWorld( playerid ) );
	LinkVehicleToInterior( carid, GetPlayerInterior( playerid ) );
	return 1;
}

CMD:ltc11( playerid, params[ ] )
{
    new Float:x, Float:y, Float:z, Float:Angle, carid;

	VipCheck( playerid, 1 );

	if ( IsPlayerInAnyVehicle( playerid ) )
		return SendClientMessage( playerid, RED, "ERROR: You already have a vehicle" );

	GetPlayerPos( playerid, x, y, z );
	GetPlayerFacingAngle( playerid, Angle );
    carid = CreateVehicle( 557, x, y, z, Angle, 1, 1, -1 );
	PutPlayerInVehicle( playerid, carid, 0 );
	AddVehicleComponent( carid, 1010 ); 	AddVehicleComponent( carid, 1081 );
   	SetVehicleVirtualWorld( carid, GetPlayerVirtualWorld( playerid ) );
	LinkVehicleToInterior( carid, GetPlayerInterior( playerid ) );
	return 1;
}
CMD:ltc12( playerid, params[ ] )
{
	new Float:x, Float:y, Float:z, Float:Angle, carid;

	VipCheck( playerid, 1 );

	if ( IsPlayerInAnyVehicle( playerid ) )
		return SendClientMessage( playerid, RED, "ERROR: You already have a vehicle" );

	GetPlayerPos( playerid, x, y, z );
	GetPlayerFacingAngle( playerid, Angle );
    carid = CreateVehicle( 535, x, y, z, Angle, 1, -1, -1 );
	PutPlayerInVehicle( playerid, carid, 0 );
	ChangeVehiclePaintjob( carid, 1 ); 		AddVehicleComponent( carid, 1109 ); 	AddVehicleComponent( carid, 1115 ); 	AddVehicleComponent( carid, 1117 ); 	AddVehicleComponent( carid, 1073 ); 	AddVehicleComponent( carid, 1010 );
    AddVehicleComponent( carid, 1087 ); 	AddVehicleComponent( carid, 1114 ); 	AddVehicleComponent( carid, 1081 ); 	AddVehicleComponent( carid, 1119 ); 	AddVehicleComponent( carid, 1121 );
   	SetVehicleVirtualWorld( carid, GetPlayerVirtualWorld( playerid ) );
	LinkVehicleToInterior( carid, GetPlayerInterior( playerid ) );
	return 1;
}
CMD:ltc13( playerid, params[ ] )
{
	new Float:x, Float:y, Float:z, Float:Angle, carid;

	VipCheck( playerid, 1 );

	if ( IsPlayerInAnyVehicle( playerid ) )
		return SendClientMessage( playerid, RED, "ERROR: You already have a vehicle" );

	GetPlayerPos( playerid, x, y, z );
	GetPlayerFacingAngle( playerid, Angle );
    carid = CreateVehicle( 562, x, y, z, Angle, 1, -1, -1 );
	PutPlayerInVehicle( playerid, carid, 0 );
	AddVehicleComponent( carid, 1034 ); 	AddVehicleComponent( carid, 1038 ); 	AddVehicleComponent( carid, 1147 );
	AddVehicleComponent( carid, 1010 ); 	AddVehicleComponent( carid, 1073 ); 	ChangeVehiclePaintjob( carid, 0 );
   	SetVehicleVirtualWorld( carid, GetPlayerVirtualWorld( playerid ) );
	LinkVehicleToInterior( carid, GetPlayerInterior( playerid ) );
	return 1;
}
CMD:vcar( playerid, params[ ] )
{
    new Float:x, Float:y, Float:z, Float:Angle, carid;
	VipCheck( playerid, 1 );

	if ( IsPlayerInAnyVehicle( playerid ) )
		return SendClientMessage( playerid, RED, "ERROR: You already have a vehicle" );

	GetPlayerPos( playerid, x, y, z );
	GetPlayerFacingAngle( playerid, Angle );
    carid = CreateVehicle( 402, x, y, z, Angle, 0, 0, 0 ); // Car: Buffalo
	PutPlayerInVehicle( playerid, carid, 0 );
   	SetVehicleVirtualWorld( carid, GetPlayerVirtualWorld( playerid ) );
    LinkVehicleToInterior( carid, GetPlayerInterior( playerid ) );

	//Source: http://wiki.sa-mp.com/wiki/Vehicles:All
	return 1;
}
CMD:vannounce( playerid, params[ ] )
{
	VipCheck( playerid, 1 );

    if ( sscanf( params, "s[128]", params[ 0 ] ) )
		return SendClientMessage( playerid, RED, "USAGE: {FFFF00}/vannounce [text]" );

    GameTextForAll( params[ 0 ], 6000, 1 );
	return 1;
}
CMD:vspa( playerid, params[ ] )// V.I.Ps Special Actions( Holds + Jetpack! )
{
	VipCheck( playerid, 1 );

	ShowPlayerDialog( playerid, VSPA, DIALOG_STYLE_LIST, "V.I.P Special Actions!", "Hold: Dick!\nHold: Iron!\nHold: Alien!\nHold: Incred!\nSpawn: JetPack!", "Select", "Cancel" );

	return 1;
}

CMD:stophold( playerid, params[ ] )
{
	VipCheck( playerid, 1 );

	if( !IsPlayerAttachedObjectSlotUsed( playerid, 0  ) &&
	    !IsPlayerAttachedObjectSlotUsed( playerid, 1  ) &&
	    !IsPlayerAttachedObjectSlotUsed( playerid, 2  ) &&
	    !IsPlayerAttachedObjectSlotUsed( playerid, 3  ) &&
	    !IsPlayerAttachedObjectSlotUsed( playerid, 4  ) )
		return SendClientMessage( playerid, RED, "You are not holding any object" );


	for ( new i = 0; i < 5; i ++ )
	{
		if ( IsPlayerAttachedObjectSlotUsed( playerid, i ) )
		{
			RemovePlayerAttachedObject( playerid, i );
			SendClientMessage( i, RED, "You have stopped holding object!" );
		}
	}
	return 1;
}

CMD:viphouse( playerid, params[ ] )
{
	VipCheck( playerid, 1 );

    SetPlayerPos( playerid, -2637.69,1404.24,906.46 );
	SetPlayerInterior( playerid, 3 );
	RemovePlayerFromVehicle( playerid );
	SendClientMessage( playerid, COLOR_VIP, "You have teleported to V.I.P House( Club )!" );
	return 1;
}
Public: SendVipMessage( color, const string[ ] )
{
	foreach(Player, i )
		if ( P_DATA[ i ][ Vip ] >= 1 )
		 	SendClientMessage( i, color, string );

	return 1;
}
Public: ReturnPosition( playerid )
{
	SetPlayerPos( playerid, Position[ playerid ][ 0 ], Position[ playerid ][ 1 ], Position[ playerid ][ 2 ] );
	SetPlayerFacingAngle( playerid, Position[ playerid ][ 3 ] );
}
Public: GodUpdate( )
{
	foreach(Player, i )
	{
		if ( P_DATA[ i ][ God ] == 1 )
			SetPlayerHealth( i, 1000);

		if ( P_DATA[ i ][ CarGod ] == 1 && IsPlayerInAnyVehicle( i ) )
			SetVehicleHealth( GetPlayerVehicleID( i ), 1000000000 );
	}
}
//======================================================== [ Stocks ] ============================================================//
stock PlayerName( i )
{
	new n[ 24 ];
	GetPlayerName( i, n, 24 );
	return n;
}
stock SpectatePlayer( playerid, PID )
{
    new string[ 100 ], Float:health, Float:armour;

	foreach(Player, i )
	    if ( GetPlayerState( i ) == PLAYER_STATE_SPECTATING && P_DATA[ i ][ SpecID ] == playerid )
	       AdvanceSpectate( i );

	SetPlayerInterior( playerid, GetPlayerInterior( PID ) );
	TogglePlayerSpectating( playerid, 1 );

	if ( IsPlayerInAnyVehicle( PID ) )
	{
		PlayerSpectateVehicle( playerid, GetPlayerVehicleID( PID ) );
		P_DATA[ playerid ][ SpecID ] = PID;
		P_DATA[ playerid ][ SpecType ] = ADMIN_SPEC_TYPE_VEHICLE;
	}
	else
	{
		PlayerSpectatePlayer( playerid, PID );
		P_DATA[ playerid ][ SpecID ] = PID;
		P_DATA[ playerid ][ SpecType ] = ADMIN_SPEC_TYPE_PLAYER;
	}

	GetPlayerName( PID, string, sizeof( string ) );
	GetPlayerHealth( PID, health );
	GetPlayerArmour( PID, armour );
	format( string, sizeof( string ),"~n~~n~~n~~n~~n~~n~~n~n~~w~%s - id:%d~n~< sprint - jump >~n~~r~Health:%0.1f ~b~Armour:%0.1f~n~~g~$%d~n~~g~%d", string, PID, health, armour, GetPlayerMoney( PID ), GetPlayerScore( PID ) );
	GameTextForPlayer( playerid, string, 25000, 3 );
	return 1;
}
stock StopSpectate( playerid )
{
	TogglePlayerSpectating( playerid, 0 );
	P_DATA[ playerid ][ SpecID ] = INVALID_PLAYER_ID;
	P_DATA[ playerid ][ SpecType ] = ADMIN_SPEC_TYPE_NONE;
	GameTextForPlayer( playerid,"~n~~n~~n~~w~Spectate mode ended", 1000, 3 );
	return 1;
}
stock AdvanceSpectate( playerid )
{
    if ( ConnectedPlayers( ) == 2 )
		return StopSpectate( playerid );

	if ( GetPlayerState( playerid ) == PLAYER_STATE_SPECTATING && P_DATA[ playerid ][ SpecID ] != INVALID_PLAYER_ID )
	{
	    for ( new i = P_DATA[ playerid ][ SpecID] +1; i <= MAX_PLAYERS; i++ )
		{
	    	if ( i == MAX_PLAYERS ) i = 0;
	        if ( IsPlayerConnected( i ) && i != playerid )
			{
				if ( GetPlayerState( i ) == PLAYER_STATE_SPECTATING && P_DATA[ i ][ SpecID ] != INVALID_PLAYER_ID || ( GetPlayerState( i ) != 1 && GetPlayerState( i ) != 2 && GetPlayerState( i ) != 3 ) )
				{
					continue;
				} else {
					SpectatePlayer( playerid, i );
					break;
				}
			}
		}
	}
	return 1;
}
stock ConnectedPlayers( )
{
	new Connected;
	foreach(Player, i ) Connected++;
	return Connected;
}
stock ReverseSpectate( playerid )
{
    if ( ConnectedPlayers( ) == 2 )
	{
		StopSpectate( playerid );
	 	return 1;
 	}
	if ( GetPlayerState( playerid ) == PLAYER_STATE_SPECTATING && P_DATA[ playerid ][ SpecID ] != INVALID_PLAYER_ID )
	{
	    for ( new i = P_DATA[ playerid ][ SpecID ]-1; i >= 0; i-- )
		{
	    	if ( i == 0 ) i = MAX_PLAYERS;
	        if ( IsPlayerConnected( i ) && i != playerid )
			{
				if ( GetPlayerState( i ) == PLAYER_STATE_SPECTATING && P_DATA[ i ][ SpecID ] != INVALID_PLAYER_ID || ( GetPlayerState( i ) != 1 && GetPlayerState( i ) != 2 && GetPlayerState( i ) != 3 ) )
				{
					continue;
				} else {
					SpectatePlayer( playerid, i );
					break;
				}
			}
		}
	}
	return 1;
}
stock SendPlayerMaxAmmo( playerid )
{
	new slot, weap, ammo;

	for ( slot = 0; slot < 14; slot++ )
	{
    	GetPlayerWeaponData( playerid, slot, weap, ammo );
		if ( IsValidWeapon( weap ) )
		{
		   	GivePlayerWeapon( playerid, weap, 99999 );
		}
	}
	return 1;
}
stock IsValidWeapon( weaponid )
{
    if ( weaponid > 0 && weaponid < 19 || weaponid > 21 && weaponid < 47 ) return 1;
    return 0;
}
//============================================================ [ EOF ] ===========================================================//
