/*
	Login / Register system by Zh3r0, using ZCMD + SSCANF + Y_INI
	Y_INI is the fastet writing system ever.
	ZCMD is the fastet command proccessor.
	SSCANF is the most usefull function ever made.


	[ Credits ]
	Y_Less - Y_Ini, SSCANF
	Zeex - ZCMD
	Dracoblue - Set, strreplace, pName, Encode, INI_Exist
	Zh3r0 - Building up this system using the above functions...


	!!!
	INI_Exist Function is not from Y_Ini, i transformed it from DINI to this.
	Remove the credits, and you are a complete moron. Do it! You will be a moron!
	!!!

	Changelog:

	v1.2 - Added VIP System 3 levels;
		Level 1: /vipgod
		Level 2: /vipgod /vipcargod
		Level 3: /vipgod /vipcargod /vnrg /vinf

	v1.1 - Added Admin system.
	v1.0 - Initial release
*/



//
#include 	<  a_samp >
#include 	<  ZCMD   >
#include 	< sscanf  >
#include    <YSI/y_ini>


//0.3c Colors
#define COL_RED         "{F81414}"
#define COL_LIGHTBLUE   "{00C0FF}"
#define COL_LRED        "{FFA1A1}"
#define COL_GREEN       "{6EF83C}"
#define COL_GREY        "{C3C3C3}"


//Dialogs
#define DIALOG_REG  	1995
#define DIALOG_REG_REQ  1996
#define DIALOG_LOGIN    1997
#define DIALOG_LOGIN2   1998
#define DIALOG_LOG_DONE 1999
#define DIALOG_LOG      2000
#define DIALOG_STATS    2001
#define INFO_BOX    	2002


//You can edit the admin ranks as you wish!
#define Level0 "Member"
#define Level1 "Moderator"
#define Level2 "Administrator"
#define Level3 "Owner"

new God[ MAX_PLAYERS ], CGod[ MAX_PLAYERS ], pNrg500[ MAX_PLAYERS ], pInfernus[ MAX_PLAYERS ];
public OnFilterScriptInit( )	return 1;
public OnFilterScriptExit( )	return 1;


forward ParsePlayerPass( playerid, name[ ], value[ ] );
public ParsePlayerPass( playerid, name[ ], value[ ] )
{
    if ( !strcmp( name, "PASSWORD" ) )
    {
        SetPVarString( playerid, "pPass", value );
    }
}

forward LoadUser( playerid, name[ ], value[ ] );
public LoadUser( playerid, name[ ], value[ ] )
{
    if ( !strcmp(name, "REG_DATE" 	) )		SetPVarString( playerid, "Date", 	value 			);
    if ( !strcmp(name, "MONEYS" 	) )		SetPVarInt( playerid, "Moneys", 	strval( value ) );
    if ( !strcmp(name, "SCORE" 		) )		SetPVarInt( playerid, "Score", 		strval( value ) );
    if ( !strcmp(name, "LEVEL" 		) )		SetPVarInt( playerid, "Level", 		strval( value ) );
    if ( !strcmp(name, "VIP_LEVEL"  ) )		SetPVarInt( playerid, "VIP Level",  strval( value ) );
    if ( !strcmp(name, "MY_WEATHER" ) ) 	SetPVarInt( playerid, "Weather", 	strval( value ) );
    if ( !strcmp(name, "MY_TIME" 	) )		SetPVarInt( playerid, "Time", 		strval( value ) );
    if ( !strcmp(name, "MY_SKIN" 	) )		SetPVarInt( playerid, "Skin", 		strval( value ) );
    if ( !strcmp(name, "LAST_ON" 	) )		SetPVarString( playerid, "On", 		value			);
    if ( !strcmp(name, "KILLS" 		) )		SetPVarInt( playerid, "Kills", 		strval( value ) );
    if ( !strcmp(name, "DEATHS" 	) )		SetPVarInt( playerid, "Deaths", 	strval( value ) );
    if ( !strcmp(name, "MUTED" 		) )		SetPVarInt( playerid, "Muted", 		strval( value ) );
    if ( !strcmp(name, "GOD" 		) )		SetPVarInt( playerid, "God", 		strval( value ) );
    if ( !strcmp(name, "CAR_GOD" 	) )		SetPVarInt( playerid, "CGod", 		strval( value ) );
}

CMD:register( playerid, params[ ] )
{
	#pragma unused params
	if ( GetPVarInt( playerid, "Logged" ) == 1 )
	    return SendClientMessage( playerid, -1, ""COL_RED"ERROR:{FFFFFF} You are already registered and logged in.");

    ShowPlayerDialog( playerid, DIALOG_REG, DIALOG_STYLE_INPUT, "{FFFFFF}Registering...", "{FFFFFF}Please write your desired password.", ">>>", "Exit");
	return 1;
}
CMD:login( playerid, params[ ] )
{
	#pragma unused params
	if ( GetPVarInt( playerid, "Logged" ) == 1 )
	    return SendClientMessage( playerid, -1, ""COL_RED"ERROR:{FFFFFF} You are already registered and logged in.");

    ShowPlayerDialog( playerid, DIALOG_LOGIN2, DIALOG_STYLE_INPUT, "{FFFFFF}Login", "{FFFFFF}Please write your current password", "Login", "Kick");
	return 1;
}
CMD:vnrg(playerid, params[])
{
	if ( GetPVarInt( playerid, "VIP Level" ) < 3 )
		return SendClientMessage( playerid, -1, "You must be an VIP Level 3 to use this command");

	if( pNrg500[playerid] > 0 )
	{
		if(GetPlayerVehicleID(playerid) != pNrg500[playerid] ) {		CallNRG(playerid);		}
		else{    SendClientMessage( playerid, -1,"You are already sitting on your personal ~b~~h~NRG-500~w~!");    }
	}else{     CreateNRG(playerid);    }
	return 1;
}

CMD:vinf(playerid, params[])
{
    if ( GetPVarInt( playerid, "VIP Level" ) < 3 )
		return SendClientMessage( playerid, -1, "You must be an VIP Level 3 to use this command");

	if( pInfernus[playerid] > 0 )
	{
		if ( GetPlayerVehicleID(playerid) != pInfernus [playerid] ) {		CallInfernus(playerid);		}
		else {    SendClientMessage( playerid, -1, "You are already sitting on your personal ~b~~h~Infernus~w~!");    }
	}else{	  CreateInfernus(playerid);    }
	return 1;
}
CMD:ban( playerid, params[ ] )
{
 	if ( GetPVarInt( playerid, "Level" ) < 3 )
	    return SendClientMessage( playerid, -1, "You must be the "COL_LIGHTBLUE""Level3"{FFFFFF} to ban someone.");

 	if ( sscanf( params, "uS", params[ 0 ], params[ 1 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_LIGHTBLUE"Usage:{FFFFFF} /kick <id> [reason]");

	if ( !IsPlayerConnected( params[ 0 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_RED"Player is not connected");


	new String[ 256 ];

	format( String, sizeof String, ""COL_LIGHTBLUE"%s"COL_GREY"( %s | ID: %i){FFFFFF} banned player "COL_LIGHTBLUE"%s"COL_GREY"( %s | ID: %i ) "COL_LIGHTBLUE"Reason: "COL_GREY"%s",
				pName( playerid ),
				GetPlayerLevelName( playerid ),
				playerid,
				pName( params[ 0 ] ),
				GetPlayerLevelName( params[ 0 ] ),
				params[ 0 ],
				params[ 1 ]);

	SendClientMessageToAll( -1, String );
	Ban( params[ 0 ] );
	return 1;
}
CMD:kick( playerid, params[ ] )
{
	if ( GetPVarInt( playerid, "Level" ) < 2 )
	    return SendClientMessage( playerid, -1, "You must be an admin level "COL_LIGHTBLUE"2{FFFFFF} or above.");

 	if ( sscanf( params, "uS", params[ 0 ], params[ 1 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_LIGHTBLUE"Usage:{FFFFFF} /kick <id> [reason]");

	if ( !IsPlayerConnected( params[ 0 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_RED"Player is not connected");


	new String[ 256 ];

	format( String, sizeof String, ""COL_LIGHTBLUE"%s"COL_GREY"( %s | ID: %i){FFFFFF} kicked player "COL_LIGHTBLUE"%s"COL_GREY"( %s | ID: %i ) "COL_LIGHTBLUE"Reason: "COL_GREY"%s",
				pName( playerid ),
				GetPlayerLevelName( playerid ),
				playerid,
				pName( params[ 0 ] ),
				GetPlayerLevelName( params[ 0 ] ),
				params[ 0 ],
				params[ 1 ]);

	SendClientMessageToAll( -1, String );
	Kick( params[ 0 ] );
	return 1;
}
CMD:myskin( playerid, params[ ] )
{
    if ( GetPVarInt( playerid, "Logged" ) == 0 )
	    return SendClientMessage( playerid, -1, ""COL_RED"ERROR:{FFFFFF} Please "COL_LIGHTBLUE"/login{FFFFFF} to change your skin.");

	if ( sscanf( params, "d", params[ 0 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_LIGHTBLUE"Usage:{FFFFFF} /myskin <skin>");

	if ( !IsValidSkin( params[ 0 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_RED"ERROR:{FFFFFF} Invalid skin ID.");

	SetPVarInt( playerid, "Skin", params[ 0 ] );
	SetPlayerSkin( playerid, params[ 0 ] );

	new String[ 129 ];
	format( String, sizeof String, "{FFFFFF}You set your time to "COL_LIGHTBLUE"%d{FFFFFF} and it has been saved into your account succesfully!", params[ 0 ] );
	SendClientMessage( playerid, -1, String );

	new PlayerFile[ 13 + MAX_PLAYER_NAME ];

	format( PlayerFile , sizeof PlayerFile, "Accounts/%s.ini", Encode( pName( playerid ) ) );
	new
		INI:PlayerAcc = INI_Open( PlayerFile );
	INI_WriteString( PlayerAcc, "MY_SKIN", 	params[ 0 ]);
	INI_Close( PlayerAcc );
	return 1;
}
CMD:mytime( playerid, params[ ] )
{
    if ( GetPVarInt( playerid, "Logged" ) == 0 )
	    return SendClientMessage( playerid, -1, ""COL_RED"ERROR:{FFFFFF} Please "COL_LIGHTBLUE"/login{FFFFFF} to change your time.");

	if ( sscanf( params, "d", params[ 0 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_LIGHTBLUE"Usage:{FFFFFF} /mytime <hour>");

	if ( params[ 0 ] < 0 || params[ 0 ] > 24 )
	    return SendClientMessage( playerid, -1, ""COL_RED"ERROR:{FFFFFF} You must have forgot the time or what? Loo at your clock, time is from 1 to 24...");
	SetPVarInt( playerid, "Time", params[ 0 ] );
	SetPlayerTime( playerid, params[ 0 ], 0 );

	new String[ 129 ];
	format( String, sizeof String, "{FFFFFF}You set your time to "COL_LIGHTBLUE"%d{FFFFFF} and it has been saved into your account succesfully!", params[ 0 ] );
	SendClientMessage( playerid, -1, String );

	new PlayerFile[ 13 + MAX_PLAYER_NAME ];

	format( PlayerFile , sizeof PlayerFile, "Accounts/%s.ini", Encode( pName( playerid ) ) );
	new
		INI:PlayerAcc = INI_Open( PlayerFile );
	INI_WriteString( PlayerAcc, "MY_TIME", 	params[ 0 ]);
	INI_Close( PlayerAcc );
	return 1;
}
CMD:myweather( playerid, params[ ] )
{
    if ( GetPVarInt( playerid, "Logged" ) == 0 )
	    return SendClientMessage( playerid, -1, ""COL_RED"ERROR:{FFFFFF} Please "COL_LIGHTBLUE"/login{FFFFFF} to set your weather.");

	if ( sscanf( params, "d", params[ 0 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_LIGHTBLUE"Usage:{FFFFFF} /myweather <weather>");

	SetPVarInt( playerid, "Weather", params[ 0 ] );
	SetPlayerWeather( playerid, params[ 0 ] );

	new String[ 129 ];
	format( String, sizeof String, "{FFFFFF}You set your weather to id "COL_LIGHTBLUE"%d{FFFFFF} and it has been saved into your account succesfully!", params[ 0 ] );
	SendClientMessage( playerid, -1, String );

	new PlayerFile[ 13 + MAX_PLAYER_NAME ];

	format( PlayerFile , sizeof PlayerFile, "Accounts/%s.ini", Encode( pName( playerid ) ) );
	new
		INI:PlayerAcc = INI_Open( PlayerFile );
	INI_WriteString( PlayerAcc, "MY_WEATHER", 	params[ 0 ]);
	INI_Close( PlayerAcc );
	return 1;
}
CMD:changepass( playerid, params[ ] )
{
	if ( !INI_Exist( pName( playerid ) ) )
	    return SendClientMessage( playerid, -1, ""COL_RED"ERROR:{FFFFFF} You must be registered to change your pass.Use "COL_LIGHTBLUE"/register{FFFFFF}.");

	if ( GetPVarInt( playerid, "Logged" ) == 0 )
	    return SendClientMessage( playerid, -1, ""COL_RED"ERROR:{FFFFFF} Please "COL_LIGHTBLUE"/login{FFFFFF} to change your password.");

	new NewPass[ 21 ], OldPass[ 21 ];
	if ( sscanf( params, "ss", OldPass, NewPass ) )
	    return SendClientMessage( playerid, -1, ""COL_LIGHTBLUE"Usage:{FFFFFF} /changepass [OLD] [NEW]");

    new PlayerFile[ 13 + MAX_PLAYER_NAME ];

	format( PlayerFile , sizeof PlayerFile, "Accounts/%s.ini", Encode( pName( playerid ) ) );
	INI_ParseFile( PlayerFile, "ParsePlayerPass", false, true, playerid );

	new Password[ 20 ],
		String[ 129 ]
	;
	GetPVarString( playerid, "pPass", Password, 20 );

	if ( strcmp( Password, OldPass, false ) != 0 )
	    return SendClientMessage( playerid, -1, ""COL_RED"ERROR:{FFFFFF} Old password didn't match the one you inserted!");

	if ( strlen( NewPass ) < 3 || strlen( NewPass ) > 20 )
	    return SendClientMessage( playerid, -1, ""COL_RED"ERROR:{FFFFFF} New password may contain Min. 3 Char. and Max. 20 Char.");

	format( String, sizeof String, "You have changed your password to \""COL_LIGHTBLUE"%s{FFFFFF}\" ", NewPass );
	SendClientMessage( playerid, -1, String );

	format( PlayerFile , sizeof PlayerFile, "Accounts/%s.ini", Encode( pName( playerid ) ) );
	new
		INI:PlayerAcc = INI_Open( PlayerFile );
	INI_WriteString( PlayerAcc, "OLD_PASSWORD", OldPass);
	INI_WriteString( PlayerAcc, "PASSWORD", 	NewPass);
	INI_Close( PlayerAcc );
	return 1;
}
CMD:mycmds( playerid, params[ ] )
{
	new LongString[ 1024 ];
	new Str1[ ] =   ""COL_LIGHTBLUE"Available commands you can use{FFFFFF}\n\n\n\
					Use "COL_LIGHTBLUE"/myweather{FFFFFF} to set and save your favorite weather.\n\
					Use "COL_LIGHTBLUE"/mytime{FFFFFF} to set your time and save it.\n\
					Use "COL_LIGHTBLUE"/myskin{FFFFFF} to set your skin and save it, and use it on next login.\n\
					If you are a VIP Member use "COL_LIGHTBLUE"/viphelp{FFFFFF} to see available commands for VIP Members.\n";

	new Str2[ ] =   "Use "COL_LIGHTBLUE"/stats{FFFFFF} to view your stats, deats, kills etc!\n\
					Use "COL_LIGHTBLUE"/changepass{FFFFFF} to change your accounts's password.";
	format( LongString, 1024, "%s%s", Str1, Str2 );
	ShowPlayerDialog( playerid, INFO_BOX, DIALOG_STYLE_MSGBOX, "{FFFFFF}My commands", LongString, "Oke", "");
	return 1;
}
stock GetPlayerLevelName( playerid )
{
	new Llevel[ 14 ];
	if ( GetPVarInt( playerid, "Level" ) == 0 ) Llevel = Level0;
	if ( GetPVarInt( playerid, "Level" ) == 1 ) Llevel = Level1;
	if ( GetPVarInt( playerid, "Level" ) == 2 ) Llevel = Level2;
	if ( GetPVarInt( playerid, "Level" ) == 3 ) Llevel = Level3;
	return Llevel;
}


CMD:setlevel( playerid, params[ ] )
{
	if ( GetPVarInt( playerid, "Level" ) < 3 && !IsPlayerAdmin( playerid ) )
	    return SendClientMessage( playerid, -1, "You are not allowed to use this command");

	if ( sscanf( params, "ui", params[ 0 ], params[ 1 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_LIGHTBLUE"Usage:{FFFFFF} /setlevel <id/name> <level> "),SendClientMessage( playerid, -1, "-Check "COL_LIGHTBLUE"/levelranks{FFFFFF} to view each level's name");

	if ( !IsPlayerConnected( params[ 0 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_RED"Player is not connected");

	if ( params[ 1 ] < 0 || params[ 1 ] > 3 )
	    return SendClientMessage( playerid, -1, "You must insert from level "COL_LIGHTBLUE"0{FFFFFF} to "COL_LIGHTBLUE"3{FFFFFF}");

	if ( GetPVarInt( playerid, "Level" ) < GetPVarInt( params[ 0 ], "Level" ) )
	    return SendClientMessage( playerid, -1, "You are not allowed to use this command on this admin."),SendClientMessage( playerid, -1, "REASON: Player is higher in grade than you.");


	SetPVarInt( params[ 0 ], "Level", params[ 1 ] );
	new String[ 256 ];
	if ( playerid == params[ 0 ] )
	{
	    format( String, sizeof String, "You made yourself an admin level "COL_LIGHTBLUE"%d{FFFFFF}["COL_LIGHTBLUE"%s{FFFFFF}]", params[ 1 ], GetPlayerLevelName( playerid ) );
	    SendClientMessage( playerid, -1, String );
 	}
 	else
 	{
        format( String, sizeof String, "You made "COL_LIGHTBLUE"%s{FFFFFF} an "COL_LIGHTBLUE"%s{FFFFFF} level "COL_LIGHTBLUE"%d",pName( params[ 0 ] ), GetPlayerLevelName( playerid ), params[ 1 ] );
        SendClientMessage( playerid, -1, String );
        format( String, sizeof String, "%s( %s ) made you an %s",pName( playerid ), GetPlayerLevelName( playerid ),GetPlayerLevelName( params[ 0 ] ) );
        SendClientMessage( params[ 0 ], -1, String );
	}
	return 1;
}
CMD:setvip( playerid, params[ ] )
{
	if ( GetPVarInt( playerid, "Level" ) < 3 )
	    return SendClientMessage( playerid, -1, "You are not allowed to use this command!");

	if ( sscanf( params, "ui", params[ 0 ], params[ 1 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_LIGHTBLUE"Usage:{FFFFFF} /setvip <id/name> <level> ");

	if ( !IsPlayerConnected( params[ 0 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_RED"Player is not connected");

	if ( params[ 1 ] < 0 || params[ 1 ] > 3 )
	    return SendClientMessage( playerid, -1, "You must insert from level "COL_LIGHTBLUE"0{FFFFFF} to "COL_LIGHTBLUE"3{FFFFFF}");

	if (GetPVarInt( playerid, "Level" ) < GetPVarInt( params[ 0 ], "Level" ) )
	    return SendClientMessage( playerid, -1, "You are not allowed to use this command on this admin."),SendClientMessage( playerid, -1, "REASON: Player is higher in grade than you.");


	SetPVarInt( params[ 0 ], "VIP Level", params[ 1 ] );
	new String[ 256 ];
	if ( playerid == params[ 0 ] )
	{
	    format( String, sizeof String, "You made yourself a VIP level "COL_LIGHTBLUE"%d", params[ 1 ]);
	    SendClientMessage( playerid, -1, String );
 	}
 	else
 	{
        format( String, sizeof String, "You made "COL_LIGHTBLUE"%s{FFFFFF} a VIP level %d", pName(  params[ 0 ] ),params[ 1 ] );
        SendClientMessage( playerid, -1, String );
        format( String, sizeof String, "%s( %s ) made you a VIP Level %d",pName( playerid ), GetPlayerLevelName( playerid ), params[ 1 ] );
        SendClientMessage( params[ 0 ], -1, String );
	}
	return 1;
}
CMD:setmoney( playerid,params[])
{
    if ( GetPVarInt( playerid, "Level" ) < 1 )
	    return SendClientMessage( playerid, -1, "You must be an "#Level1" to use this command");

	if ( sscanf( params, "ui", params[ 0 ], params[ 1 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_LIGHTBLUE"Usage:{FFFFFF} /setmoney <id/name> <money> ");

    if ( !IsPlayerConnected( params[ 0 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_RED"Player is not connected");

    if (GetPVarInt( playerid, "Level" ) < GetPVarInt( params[ 0 ], "Level" ) )
	    return SendClientMessage( playerid, -1, "You are not allowed to use this command on this admin."),SendClientMessage( playerid, -1, "REASON: Player is higher in grade than you.");

	ResetPlayerMoney( params[ 0 ] );
	GivePlayerMoney( params[ 0 ], params[ 1 ] );

	new String[ 245 ];
    format( String, sizeof String, "You gave "COL_LIGHTBLUE"%s{FFFFFF} "COL_GREEN"$%d{FFFFFF} moneys.", pName(  params[ 0 ] ),params[ 1 ] );
    SendClientMessage( playerid, -1, String );
    format( String, sizeof String, ""COL_LIGHTBLUE"%s( %s ){FFFFFF} set your cash to "COL_GREEN"$%d",pName( playerid ), GetPlayerLevelName( playerid ), params[ 1 ] );
    SendClientMessage( params[ 0 ], -1, String );
	return 1;
}
CMD:settime( playerid,params[])
{
    if ( GetPVarInt( playerid, "Level" ) < 1 )
	    return SendClientMessage( playerid, -1, "You must be an "#Level1" to use this command");

	if ( sscanf( params, "ui", params[ 0 ], params[ 1 ] ) || params[ 1 ] < 1 || params[ 1 ] > 24 )
	    return SendClientMessage( playerid, -1, ""COL_LIGHTBLUE"Usage:{FFFFFF} /settime <id/name> <hour> ");

    if ( !IsPlayerConnected( params[ 0 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_RED"Player is not connected");

    if (GetPVarInt( playerid, "Level" ) < GetPVarInt( params[ 0 ], "Level" ) )
	    return SendClientMessage( playerid, -1, "You are not allowed to use this command on this admin."),SendClientMessage( playerid, -1, "REASON: Player is higher in grade than you.");

	SetPlayerTime( params[ 0 ], params[ 1 ], 0 );

	new String[ 245 ];
    format( String, sizeof String, "You set "COL_LIGHTBLUE"%s's{FFFFFF} time to "COL_LIGHTBLUE"%d:00", pName(  params[ 0 ] ),params[ 1 ] );
    SendClientMessage( playerid, -1, String );
    format( String, sizeof String, ""COL_LIGHTBLUE"%s( %s ){FFFFFF} set your time to "COL_LIGHTBLUE"%d:00",pName( playerid ), GetPlayerLevelName( playerid ), params[ 1 ] );
    SendClientMessage( params[ 0 ], -1, String );
	return 1;
}
CMD:setscore( playerid,params[])
{
    if ( GetPVarInt( playerid, "Level" ) < 1 )
	    return SendClientMessage( playerid, -1, "You must be an "#Level1" to use this command");

	if ( sscanf( params, "ui", params[ 0 ], params[ 1 ] ))
	    return SendClientMessage( playerid, -1, ""COL_LIGHTBLUE"Usage:{FFFFFF} /setscore <id/name> <score> ");

    if ( !IsPlayerConnected( params[ 0 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_RED"Player is not connected");

    if (GetPVarInt( playerid, "Level" ) < GetPVarInt( params[ 0 ], "Level" ) )
	    return SendClientMessage( playerid, -1, "You are not allowed to use this command on this admin."),SendClientMessage( playerid, -1, "REASON: Player is higher in grade than you.");

	SetPlayerScore( playerid, params[ 1 ] );

	new String[ 245 ];
    format( String, sizeof String, "You set "COL_LIGHTBLUE"%s's{FFFFFF} score to "COL_LIGHTBLUE"%d", pName(  params[ 0 ] ),params[ 1 ] );
    SendClientMessage( playerid, -1, String );
    format( String, sizeof String, ""COL_LIGHTBLUE"%s( %s ){FFFFFF} set your score to "COL_LIGHTBLUE"%d",pName( playerid ), GetPlayerLevelName( playerid ), params[ 1 ] );
    SendClientMessage( params[ 0 ], -1, String );
	return 1;
}
CMD:setweather( playerid,params[])
{
    if ( GetPVarInt( playerid, "Level" ) < 1 )
	    return SendClientMessage( playerid, -1, "You must be an "#Level1" to use this command");

	if ( sscanf( params, "ui", params[ 0 ], params[ 1 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_LIGHTBLUE"Usage:{FFFFFF} /setweather <id/name> <weather> ");

    if ( !IsPlayerConnected( params[ 0 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_RED"Player is not connected");

    if (GetPVarInt( playerid, "Level" ) < GetPVarInt( params[ 0 ], "Level" ) )
	    return SendClientMessage( playerid, -1, "You are not allowed to use this command on this admin."),SendClientMessage( playerid, -1, "REASON: Player is higher in grade than you.");

	SetPlayerWeather( params[ 0 ], params[ 1 ]);

	new String[ 245 ];
    format( String, sizeof String, "You set "COL_LIGHTBLUE"%s's{FFFFFF} weather to "COL_LIGHTBLUE"%d", pName(  params[ 0 ] ),params[ 1 ] );
    SendClientMessage( playerid, -1, String );
    format( String, sizeof String, ""COL_LIGHTBLUE"%s( %s ){FFFFFF} set your weather to "COL_LIGHTBLUE"%d",pName( playerid ), GetPlayerLevelName( playerid ), params[ 1 ] );
    SendClientMessage( params[ 0 ], -1, String );
	return 1;
}
CMD:sethealth( playerid,params[])
{
    if ( GetPVarInt( playerid, "Level" ) < 1 )
	    return SendClientMessage( playerid, -1, "You must be an "#Level1" to use this command");

	if ( sscanf( params, "ui", params[ 0 ], params[ 1 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_LIGHTBLUE"Usage:{FFFFFF} /sethealth <id/name> <health> ");

    if ( !IsPlayerConnected( params[ 0 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_RED"Player is not connected");

    if (GetPVarInt( playerid, "Level" ) < GetPVarInt( params[ 0 ], "Level" ) )
	    return SendClientMessage( playerid, -1, "You are not allowed to use this command on this admin."),SendClientMessage( playerid, -1, "REASON: Player is higher in grade than you.");

	SetPlayerHealth( params[ 0 ], params[ 1 ]);

	new String[ 245 ];
    format( String, sizeof String, "You set "COL_LIGHTBLUE"%s's{FFFFFF} health to "COL_LIGHTBLUE"%d", pName(  params[ 0 ] ),params[ 1 ] );
    SendClientMessage( playerid, -1, String );
    format( String, sizeof String, ""COL_LIGHTBLUE"%s( %s ){FFFFFF} set your health to "COL_LIGHTBLUE"%d",pName( playerid ), GetPlayerLevelName( playerid ), params[ 1 ] );
    SendClientMessage( params[ 0 ], -1, String );
	return 1;
}
CMD:setarmour( playerid,params[])
{
    if ( GetPVarInt( playerid, "Level" ) < 1 )
	    return SendClientMessage( playerid, -1, "You must be an "#Level1" to use this command");

	if ( sscanf( params, "ui", params[ 0 ], params[ 1 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_LIGHTBLUE"Usage:{FFFFFF} /setarmour <id/name> <armour> ");

    if ( !IsPlayerConnected( params[ 0 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_RED"Player is not connected");

    if (GetPVarInt( playerid, "Level" ) < GetPVarInt( params[ 0 ], "Level" ) )
	    return SendClientMessage( playerid, -1, "You are not allowed to use this command on this admin."),SendClientMessage( playerid, -1, "REASON: Player is higher in grade than you.");

	SetPlayerArmour( params[ 0 ], params[ 1 ]);

	new String[ 245 ];
    format( String, sizeof String, "You set "COL_LIGHTBLUE"%s's{FFFFFF} armour to "COL_LIGHTBLUE"%d", pName(  params[ 0 ] ), params[ 1 ] );
    SendClientMessage( playerid, -1, String );
    format( String, sizeof String, ""COL_LIGHTBLUE"%s( %s ){FFFFFF} set your armour to "COL_LIGHTBLUE"%d",pName( playerid ), GetPlayerLevelName( playerid ), params[ 1 ] );
    SendClientMessage( params[ 0 ], -1, String );
	return 1;
}
CMD:heal( playerid,params[])
{
    if ( GetPVarInt( playerid, "Level" ) < 1 )
	    return SendClientMessage( playerid, -1, "You must be an "#Level1" to use this command");

	if ( sscanf( params, "u", params[ 0 ], params[ 1 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_LIGHTBLUE"Usage:{FFFFFF} /heal <id/name>");

    if ( !IsPlayerConnected( params[ 0 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_RED"Player is not connected");

    if (GetPVarInt( playerid, "Level" ) < GetPVarInt( params[ 0 ], "Level" ) )
	    return SendClientMessage( playerid, -1, "You are not allowed to use this command on this admin."),SendClientMessage( playerid, -1, "REASON: Player is higher in grade than you.");

	SetPlayerHealth( params[ 0 ], 100.0);

	new String[ 245 ];
    format( String, sizeof String, "You healed "COL_LIGHTBLUE"%s", pName(  params[ 0 ] ));
    SendClientMessage( playerid, -1, String );
    format( String, sizeof String, ""COL_LIGHTBLUE"%s( %s ){FFFFFF} healed you.",pName( playerid ), GetPlayerLevelName( playerid ));
    SendClientMessage( params[ 0 ], -1, String );
	return 1;
}
CMD:akill( playerid,params[])
{
    if ( GetPVarInt( playerid, "Level" ) < 2 )
	    return SendClientMessage( playerid, -1, "You must be an "#Level2" to use this command");

	if ( sscanf( params, "u", params[ 0 ], params[ 1 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_LIGHTBLUE"Usage:{FFFFFF} /akill <id/name>");

    if ( !IsPlayerConnected( params[ 0 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_RED"Player is not connected");

    if (GetPVarInt( playerid, "Level" ) < GetPVarInt( params[ 0 ], "Level" ) )
	    return SendClientMessage( playerid, -1, "You are not allowed to use this command on this admin."),SendClientMessage( playerid, -1, "REASON: Player is higher in grade than you.");

	SetPlayerHealth( params[ 0 ], 0.0);

	new String[ 245 ];
    format( String, sizeof String, "You killed "COL_LIGHTBLUE"%s", pName(  params[ 0 ] ));
    SendClientMessage( playerid, -1, String );
    format( String, sizeof String, ""COL_LIGHTBLUE"%s( %s ){FFFFFF} killed you.",pName( playerid ), GetPlayerLevelName( playerid ));
    SendClientMessage( params[ 0 ], -1, String );
	return 1;
}
CMD:mute( playerid,params[])
{
    if ( GetPVarInt( playerid, "Level" ) < 2 )
	    return SendClientMessage( playerid, -1, "You must be an "#Level2" to use this command");

	if ( sscanf( params, "u", params[ 0 ], params[ 1 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_LIGHTBLUE"Usage:{FFFFFF} /mute <id/name>");

	if ( GetPVarInt( playerid, "Muted" ) == 1 )
		return SendClientMessage( playerid, -1, ""COL_RED"ERROR:{FFFFFF} Player is already muted.");

    if ( !IsPlayerConnected( params[ 0 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_RED"Player is not connected");

    if (GetPVarInt( playerid, "Level" ) < GetPVarInt( params[ 0 ], "Level" ) )
    	return SendClientMessage( playerid, -1, "You are not allowed to use this command on this admin."),SendClientMessage( playerid, -1, "REASON: Player is higher in grade than you.");

	SetPVarInt( params[ 0 ], "Muted", 1 );

	new String[ 245 ];
    format( String, sizeof String, "You muted "COL_LIGHTBLUE"%s", pName(  params[ 0 ] ));
    SendClientMessage( playerid, -1, String );
    format( String, sizeof String, ""COL_LIGHTBLUE"%s( %s ){FFFFFF} muted you.",pName( playerid ), GetPlayerLevelName( playerid ));
    SendClientMessage( params[ 0 ], -1, String );
	return 1;
}
CMD:unmute( playerid,params[])
{
    if ( GetPVarInt( playerid, "Level" ) < 2 )
	    return SendClientMessage( playerid, -1, "You must be an "#Level2" to use this command");

	if ( sscanf( params, "u", params[ 0 ], params[ 1 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_LIGHTBLUE"Usage:{FFFFFF} /mute <id/name>");

	if ( GetPVarInt( playerid, "Muted" ) == 0 )
		return SendClientMessage( playerid, -1, ""COL_RED"ERROR:{FFFFFF} Player is already un-muted.");

    if ( !IsPlayerConnected( params[ 0 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_RED"Player is not connected");

    if (GetPVarInt( playerid, "Level" ) < GetPVarInt( params[ 0 ], "Level" ) )
    	return SendClientMessage( playerid, -1, "You are not allowed to use this command on this admin."),SendClientMessage( playerid, -1, "REASON: Player is higher in grade than you.");

	SetPVarInt(  params[ 0 ], "Muted", 0 );

	new String[ 245 ];
    format( String, sizeof String, "You unmuted "COL_LIGHTBLUE"%s", pName(  params[ 0 ] ));
    SendClientMessage( playerid, -1, String );
    format( String, sizeof String, ""COL_LIGHTBLUE"%s( %s ){FFFFFF} unmuted you.",pName( playerid ), GetPlayerLevelName( playerid ));
    SendClientMessage( params[ 0 ], -1, String );
	return 1;
}
CMD:freeze( playerid,params[])
{
    if ( GetPVarInt( playerid, "Level" ) < 2 )
	    return SendClientMessage( playerid, -1, "You must be an "#Level2" to use this command");

	if ( sscanf( params, "u", params[ 0 ], params[ 1 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_LIGHTBLUE"Usage:{FFFFFF} /freeze <id/name>");

	if ( GetPVarInt( playerid, "Freeze" ) == 1 )
		return SendClientMessage( playerid, -1, ""COL_RED"ERROR:{FFFFFF} Player is already frozen.");

    if ( !IsPlayerConnected( params[ 0 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_RED"Player is not connected");

    if (GetPVarInt( playerid, "Level" ) < GetPVarInt( params[ 0 ], "Level" ) )
    	return SendClientMessage( playerid, -1, "You are not allowed to use this command on this admin."),SendClientMessage( playerid, -1, "REASON: Player is higher in grade than you.");

	SetPVarInt(  params[ 0 ], "Freeze", 1 );
	TogglePlayerControllable( playerid, false );

	new String[ 245 ];
    format( String, sizeof String, "You frozen "COL_LIGHTBLUE"%s", pName(  params[ 0 ] ));
    SendClientMessage( playerid, -1, String );
    format( String, sizeof String, ""COL_LIGHTBLUE"%s( %s ){FFFFFF} frozen you.",pName( playerid ), GetPlayerLevelName( playerid ));
    SendClientMessage( params[ 0 ], -1, String );
	return 1;
}
CMD:unfreeze( playerid,params[])
{
    if ( GetPVarInt( playerid, "Level" ) < 2 )
	    return SendClientMessage( playerid, -1, "You must be an "#Level2" to use this command");

	if ( sscanf( params, "u", params[ 0 ], params[ 1 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_LIGHTBLUE"Usage:{FFFFFF} /freeze <id/name>");

	if ( GetPVarInt( playerid, "Freeze" ) == 0 )
		return SendClientMessage( playerid, -1, ""COL_RED"ERROR:{FFFFFF} Player is already unfrozen.");

    if ( !IsPlayerConnected( params[ 0 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_RED"Player is not connected");

    if (GetPVarInt( playerid, "Level" ) < GetPVarInt( params[ 0 ], "Level" ) )
    	return SendClientMessage( playerid, -1, "You are not allowed to use this command on this admin."),SendClientMessage( playerid, -1, "REASON: Player is higher in grade than you.");

	SetPVarInt(  params[ 0 ], "Freeze", 0 );
	TogglePlayerControllable( playerid, true );

	new String[ 245 ];
    format( String, sizeof String, "You unfrozen "COL_LIGHTBLUE"%s", pName(  params[ 0 ] ));
    SendClientMessage( playerid, -1, String );
    format( String, sizeof String, ""COL_LIGHTBLUE"%s( %s ){FFFFFF} unfrozen you.",pName( playerid ), GetPlayerLevelName( playerid ));
    SendClientMessage( params[ 0 ], -1, String );
	return 1;
}
CMD:spawn( playerid,params[])
{
    if ( GetPVarInt( playerid, "Level" ) < 2 )
	    return SendClientMessage( playerid, -1, "You must be an "#Level2" to use this command");

	if ( sscanf( params, "u", params[ 0 ], params[ 1 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_LIGHTBLUE"Usage:{FFFFFF} /spawn <id/name>");

    if ( !IsPlayerConnected( params[ 0 ] ) )
	    return SendClientMessage( playerid, -1, ""COL_RED"Player is not connected");

    if (GetPVarInt( playerid, "Level" ) < GetPVarInt( params[ 0 ], "Level" ) )
    	return SendClientMessage( playerid, -1, "You are not allowed to use this command on this admin."),SendClientMessage( playerid, -1, "REASON: Player is higher in grade than you.");

	SpawnPlayer( params[ 0 ] );

	new String[ 245 ];
    format( String, sizeof String, "You spawned "COL_LIGHTBLUE"%s", pName(  params[ 0 ] ) );
    SendClientMessage( playerid, -1, String );
    format( String, sizeof String, ""COL_LIGHTBLUE"%s( %s ){FFFFFF} spawned you.",pName( playerid ), GetPlayerLevelName( playerid ));
    SendClientMessage( params[ 0 ], -1, String );
	return 1;
}
CMD:vipgod( playerid,params[])
{
    if ( GetPVarInt( playerid, "VIP Level" ) < 1 )
	    return SendClientMessage( playerid, -1, "You must be an VIP Level 1 to use this command");

    if ( GetPVarInt( playerid, "God" ) == 0 )
    {
        SetPVarInt( playerid, "God", 1);
		God[ playerid ] = SetTimerEx( "GodTimer", 200, true, "i", playerid );
		SendClientMessage( playerid, -1, ""COL_LIGHTBLUE"God Fature{FFFFFF} is now enabled!");
	}
	else
	{
		SetPVarInt( playerid, "God", 0);
		KillTimer( God[ playerid ] );
		SetPlayerHealth( playerid, 100.0 );
		SendClientMessage( playerid, -1, ""COL_LIGHTBLUE"God Fature{FFFFFF} is now disabled!");
	}
	return 1;
}
CMD:vipcargod( playerid,params[])
{
    if ( GetPVarInt( playerid, "VIP Level" ) < 1 )
	    return SendClientMessage( playerid, -1, "You must be an VIP Level 1 to use this command");

    if ( GetPVarInt( playerid, "CGod" ) == 0 )
    {
        SetPVarInt( playerid, "CGod", 1);
		CGod[ playerid ] = SetTimerEx( "CarGodTimer", 200, true, "i", playerid );
		SendClientMessage( playerid, -1, ""COL_LIGHTBLUE"Car God Fature{FFFFFF} is now enabled!");
	}
	else
	{
		SetPVarInt( playerid, "CGod", 0);
		KillTimer( CGod[ playerid ] );
		SetVehicleHealth( GetPlayerVehicleID( playerid ), 1000.0 );
		SendClientMessage( playerid, -1, ""COL_LIGHTBLUE"Car God Fature{FFFFFF} is now disabled!");
	}
	return 1;
}
CMD:acmds( playerid, params[ ] )
{
    if ( GetPVarInt( playerid, "Level" ) < 1 )
	    return SendClientMessage( playerid, -1, "You must be an Admin level 1 or above to view the commands");

	new CBox[ 512 ];
	format( CBox, sizeof CBox, "{FFFFFF}Current Admin commands\n\n\n\
	                            "COL_RED"Level {FFFFFF}1 "COL_RED"- {FFFFFF}( "COL_RED""Level1" {FFFFFF})\n\
	                            /settime /setweather /sethealth /setarmour /heal /setmoney /setscore\n\n\
	                            "COL_RED"Level {FFFFFF}2 "COL_RED"- {FFFFFF}( "COL_RED""Level2" {FFFFFF})\n");

	format( CBox, sizeof CBox,  "%s/akill /mute /unmute /freeze /unfreeze /kick /spawn\n\n\
	                            "COL_RED"Level {FFFFFF}3 "COL_RED"- {FFFFFF}( "COL_RED""Level3" {FFFFFF})\n\
	                            /gmx /ban\n\n\n\
								Please take a look at the Admin Rules -> "COL_RED"/arules", CBox);
	ShowPlayerDialog( playerid, INFO_BOX, DIALOG_STYLE_MSGBOX, "{FFFFFF}Admin Commands", CBox, "Oke", "");
	return 1;
}
CMD:viphelp( playerid, params[ ] )
{
    if ( GetPVarInt( playerid, "Level" ) < 1 )
	    return SendClientMessage( playerid, -1, "You must be a VIP Member to use this command");

	ShowPlayerDialog( playerid, INFO_BOX, DIALOG_STYLE_MSGBOX, "{FFFFFF}Admin Commands", 	"{FFFFFF}Few VIP Commands.\n\n\n\
																                            "COL_LIGHTBLUE"Level {FFFFFF}1\n\
																                            /vipgod\n\n\
																                            "COL_LIGHTBLUE"Level {FFFFFF}2\n\
																							/vipgod /vipcargod\n\n\
																                            "COL_LIGHTBLUE"Level {FFFFFF}3\n\
																                            /vipgod /vipcargod /vnrg /vinf\n\n\n", "Oke", "");
	return 1;
}
CMD:arules( playerid, params[ ] )
{
    if ( GetPVarInt( playerid, "Level" ) < 1 )
	    return SendClientMessage( playerid, -1, "You must be an Admin level 1 or above to view the Admin Rules");

	new CBox[ 700 ];
	format( CBox, sizeof CBox, "{FFFFFF}Current Admin Rules\n\n\n\
	                            "COL_RED"Level {FFFFFF}1 "COL_RED"- {FFFFFF}( "COL_RED""Level1" {FFFFFF})\n\
	                            -Your duty is to ensure a player's pleasure to play on the server, set his time\n\
								set his wather, etc.\n\n\
	                            "COL_RED"Level {FFFFFF}2 "COL_RED"- {FFFFFF}( "COL_RED""Level2" {FFFFFF})\n");

	format( CBox, sizeof CBox, "%s-Your job is to ensure nobody abuses the commands, or insults players\n\
	                            you must take control over mean players and punish them.\n\n\
	                            "COL_RED"Level {FFFFFF}3 "COL_RED"- {FFFFFF}( "COL_RED""Level3" {FFFFFF})\n\
	                            -The "Level3" can do whatever they want, you cannot judge their actions.\n\n\n\
								Please take a look at the Admin Commands -> "COL_RED"/acmds", CBox);
	ShowPlayerDialog( playerid, INFO_BOX, DIALOG_STYLE_MSGBOX, "{FFFFFF}Admin Commands", CBox, "Oke", "");
	return 1;
}
CMD:stats( playerid, paramz[ ] )
{
	if ( GetPVarInt( playerid, "Logged" ) == 0 )
	    return SendClientMessage( playerid, -1, ""COL_RED"ERROR:{FFFFFF} To view your stats you must be logged in ");

	new
		iBox[ 1024 ],
		RegDate[ 40 ],
		pLastOn[ 20 + 20 ],
		pLevel = GetPVarInt( playerid, "Level")
	;
	GetPVarString( playerid, "Date", RegDate, sizeof RegDate );
	GetPVarString( playerid, "On", pLastOn, sizeof pLastOn );

	format( iBox, sizeof iBox, "{FFFFFF}Hello "COL_LIGHTBLUE"%s{FFFFFF}, these are your stats\n\n\
	                            {FFFFFF}Admin level: "COL_LIGHTBLUE"%s{FFFFFF}["COL_LIGHTBLUE"%d{FFFFFF}]\n\
	                            {FFFFFF}VIP Level: "COL_LIGHTBLUE"%d\n\
	                            {FFFFFF}Moneys: "COL_LIGHTBLUE"%d\n\
	                            {FFFFFF}Score: "COL_LIGHTBLUE"%d\n\
	                            {FFFFFF}Kills: "COL_LIGHTBLUE"%d\n\
	                            {FFFFFF}Deaths: "COL_LIGHTBLUE"%d\n\
	                            {FFFFFF}Registration Date: "COL_LIGHTBLUE"%s\n\
	                            {FFFFFF}Interior: "COL_LIGHTBLUE"%d\n",
											  pName( playerid ),
											  GetPlayerLevelName( playerid ),
											  pLevel,
											  GetPlayerVLevel( playerid ),
											  GetPlayerMoney( playerid ),
											  GetPlayerScore( playerid ),
											  GetPVarInt( playerid,"Kills" ),
											  GetPVarInt( playerid,"Deaths" ),
											  RegDate,
											  GetPlayerInterior( playerid ) );

	format( iBox, sizeof iBox,	"%s{FFFFFF}Virtual World: "COL_LIGHTBLUE"%d\n\
								{FFFFFF}My Favorite Skin: "COL_LIGHTBLUE"%d\n\
								{FFFFFF}My Time: "COL_LIGHTBLUE"%d\n\
								{FFFFFF}My Weather: "COL_LIGHTBLUE"%d\n\
								{FFFFFF}Last On: "COL_LIGHTBLUE"%s\n\
								{FFFFFF}Car God: "COL_LIGHTBLUE"%s\n\
								{FFFFFF}Player God: "COL_LIGHTBLUE"%s",
											  iBox,
											  GetPlayerVirtualWorld( playerid ),
											  GetMySkin( playerid ),
											  GetMyTime( playerid ),
											  GetMyWeather( playerid ),
											  pLastOn,
											  GetPVarInt( playerid, "CGod" ) ? (""COL_GREEN"Yes") : (""COL_RED"No"),
											  GetPVarInt( playerid, "God" ) ? (""COL_GREEN"Yes") : (""COL_RED"No"));

	ShowPlayerDialog( playerid, DIALOG_STATS, DIALOG_STYLE_MSGBOX, "{FFFFFF}Your Stats!", iBox, "Ok", "");
	return 1;
}
public OnPlayerDeath( playerid, killerid, reason )
{
	SetPVarInt( killerid, "Kills",  GetPVarInt( playerid, "Kills" ) + 1 );
	SetPVarInt( playerid, "Deaths", GetPVarInt( playerid, "Deaths" ) + 1 );
	return 1;
}
public OnPlayerText( playerid, text[] )
{
	if ( GetPVarInt( playerid, "Muted" ) == 1 && !IsPlayerAdmin( playerid ) )
	{
	    SendClientMessage( playerid, -1, ""COL_RED"ERROR:{FFFFFF} You are muted, you cannot chat!");
	}
	return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch( dialogid )
	{
	    case DIALOG_REG:
	    {
	        if ( response )
	        {
	            if ( sscanf( inputtext, "s", inputtext[ 0 ] || strlen( inputtext[ 0 ] ) == 0 ) )
	                return ShowPlayerDialog( playerid, DIALOG_REG, DIALOG_STYLE_INPUT, "{FFFFFF}Password", ""COL_RED"Error!\n\
																							{FFFFFF}Please write your desired password.\n",
																							">>>", "Exit");
        		if ( strlen( inputtext[ 0 ] ) < 3 || strlen( inputtext[ 0 ] ) > 20 )
        			return ShowPlayerDialog( playerid, DIALOG_REG, DIALOG_STYLE_INPUT, "{FFFFFF}Password", ""COL_RED"Error!\n\
																							{FFFFFF}Please write your desired password.\n\
																		 					"COL_RED"#{FFFFFF}Min. 3 Char. Max. 20 Char.",
																							">>>", "Exit");
				new
					PlayerFile[ 13 + MAX_PLAYER_NAME ],
					pDate[ 8 + 15 ], //HH:MM:SS + DD.MM.YYYY = 18
					pYear,
					pMonth,
					pDay,
					pHour,
					pMinute,
					pSecond,
					pIP[ 20 ],
					InfBox[ 512 ]
				;
				getdate(pYear, pMonth, pDay ),gettime(pHour, pMinute, pSecond );
				GetPlayerIp( playerid, pIP, 20 );


				format( PlayerFile , sizeof PlayerFile, "Accounts/%s.ini", Encode( pName( playerid ) ) );
				format( pDate, sizeof pDate, "%d:%d:%d  %d/%d/%d",pHour, pMinute, pSecond , pDay, pMonth, pYear );
			    format( InfBox, sizeof InfBox, "{FFFFFF}You registered your account with success!\n\n\
			                                            "COL_LIGHTBLUE"Account: {FFFFFF}%s\n\
			                                            "COL_LIGHTBLUE"Password: {FFFFFF}%s\n\n\
			                                            You received "COL_GREEN"$5000{FFFFFF} for registering.\n\
			                                            Would you like to login?", pName( playerid ),
																				 inputtext		 );
				ShowPlayerDialog( playerid, DIALOG_LOG, DIALOG_STYLE_MSGBOX, "Login", InfBox, "Yes", "No" );


				new
					INI:PlayerAcc = INI_Open( PlayerFile );

                INI_WriteString( PlayerAcc, "NAME",				  pName( playerid )	   );
			 	INI_WriteString( PlayerAcc, "PASSWORD", 		  inputtext 	       );
				INI_WriteString( PlayerAcc, "REG_DATE", 		  pDate 			   );
				INI_WriteString( PlayerAcc, "LAST_ON", 		      "First connection"   );
				INI_WriteInt( PlayerAcc,    "MONEYS",             5000                 );
				INI_WriteInt( PlayerAcc,    "SCORE",              15                   );
				INI_WriteInt( PlayerAcc,    "KILLS",              0                    );
				INI_WriteInt( PlayerAcc,    "DEATHS",             0                    );
				INI_WriteInt( PlayerAcc,    "VIP_LEVEL",          0                    );
				INI_WriteInt( PlayerAcc,    "LEVEL",              0                    );
				INI_WriteInt( PlayerAcc,    "MY_SKIN",            0                    );
				INI_WriteInt( PlayerAcc,    "MY_TIME",            12                   );
				INI_WriteInt( PlayerAcc,    "MY_WEATHER",         1                    );

				INI_Close( PlayerAcc );

				SetPVarString( playerid, "Date", pDate );
				SetPVarInt( playerid, "Logged", 0 );
				GivePlayerMoney( playerid, 5000 );
				SetPlayerScore( playerid, GetPlayerScore( playerid ) + 15 );


			}
		}
		case DIALOG_REG_REQ:
		{
		    if ( response ) cmd_register( playerid, "");
		    if ( !response ) return 0;

		}

		case DIALOG_LOGIN: ShowPlayerDialog( playerid, DIALOG_LOGIN2, DIALOG_STYLE_INPUT, "{FFFFFF}Password",
																						  "{FFFFFF}Please write your current password.",
																						  "Login", "Kick");

		case DIALOG_LOG:
		{
		    if ( response )
            	ShowPlayerDialog( playerid, DIALOG_LOGIN2, DIALOG_STYLE_INPUT, "{FFFFFF}Password", 	"{FFFFFF}Please write your current password.","Login","Kick");
		}
		case DIALOG_LOGIN2:
		{
		    if ( !response ) return Kick( playerid );
		    if ( response )
		    {
			    if ( strlen( inputtext ) == 0 )
			        return ShowPlayerDialog( playerid, DIALOG_LOGIN2, DIALOG_STYLE_INPUT, "{FFFFFF}Password", 	""COL_RED"Error!\n\
																												{FFFFFF}Please write your current password.",
																												"Login", "Kick");

			    new
					PlayerFile[ 13 + MAX_PLAYER_NAME ],
					Password[ 20 + 1 ]
				;
			    format( PlayerFile , sizeof PlayerFile, "Accounts/%s.ini", Encode( pName( playerid ) ) );
		        INI_ParseFile( PlayerFile, "ParsePlayerPass", false, true, playerid );
		        GetPVarString( playerid, "pPass", Password, sizeof Password );

		        if ( !strcmp ( inputtext, Password, false ) )
	        	{
	        	    new
						sTitle[ 21 + MAX_PLAYER_NAME + 25 ],
						sBoxInfo[ 512 ],
						Pdata[ 8 + 15 ]
					;

					SetPVarInt( playerid, "Logged", 1 );
					format( PlayerFile , sizeof PlayerFile, "Accounts/%s.ini", Encode( pName( playerid ) ) );
	        	    INI_ParseFile( PlayerFile, "LoadUser", false, true, playerid, true, false );
	        	    GetPVarString( playerid, "Date", Pdata, 8 + 10 );


					if ( GetPVarInt( playerid, "CGod" ) == 1 )
					{
					    SetPVarInt( playerid, "CGod", 1);
						CGod[ playerid ] = SetTimerEx( "CarGodTimer", 200, true, "i", playerid );
					}
                    if ( GetPVarInt( playerid, "God" ) == 1 )
					{
					    SetPVarInt( playerid, "God", 1);
						God[ playerid ] = SetTimerEx( "GodTimer", 200, true, "i", playerid );
					}
	        	    format( sTitle, sizeof sTitle, "{FFFFFF}Welcome back, "COL_LIGHTBLUE"%s{FFFFFF}!", pName( playerid ) );
	        	    if ( GetPVarInt( playerid, "Level" ) == 0 )
	        	    {
	        	    format( sBoxInfo, sizeof sBoxInfo, "{FFFFFF}These are your stats:\n\n\
	        	                                        {FFFFFF}Rank: "COL_LIGHTBLUE"%s\n\
	        	                                        {FFFFFF}VIP Level: "COL_LIGHTBLUE"%d\n\
	        	                                        {FFFFFF}Score: "COL_LIGHTBLUE"%d\n\
	        	                                        {FFFFFF}Registered on: "COL_LIGHTBLUE"%s\n\n\
														{FFFFFF}To view more stats please type to "COL_LIGHTBLUE"/stats\n\
														{FFFFFF}Type "COL_LIGHTBLUE"/mycmds{FFFFFF} to view your current commands.",
																								   GetPlayerLevelName( playerid ),
																								   GetPlayerVLevel( playerid ),
																								   GetPVarInt( playerid, "Score" ),
																								   Pdata );
					}
					if ( GetPVarInt( playerid, "Level" ) > 1 )
	        	    {
	        	    format( sBoxInfo, sizeof sBoxInfo, "{FFFFFF}These are your stats:\n\n\
	        	                                        {FFFFFF}Level: "COL_LIGHTBLUE"%s\n\
	        	                                        {FFFFFF}VIP Level: "COL_LIGHTBLUE"%d\n\
	        	                                        {FFFFFF}Score: "COL_LIGHTBLUE"%d\n\
	        	                                        {FFFFFF}Registered on: "COL_LIGHTBLUE"%s\n\n",
																								   GetPlayerLevelName( playerid ),
																								   GetPlayerVLevel( playerid ),
																								   GetPVarInt( playerid, "Score" ),
																								   Pdata );

					format( sBoxInfo, sizeof sBoxInfo,	"%s{FFFFFF}To view more stats please type to "COL_LIGHTBLUE"/stats\n\
														{FFFFFF}Type "COL_LIGHTBLUE"/mycmds{FFFFFF} to view your current commands.\n\
														"COL_RED"Admin note:{FFFFFF}Use "COL_LIGHTBLUE"/acmds {FFFFFF}and "COL_LIGHTBLUE"/arules {FFFFFF}for commands and Admin rules.",sBoxInfo);
					}
					ShowPlayerDialog(playerid, DIALOG_LOG_DONE, DIALOG_STYLE_MSGBOX, sTitle, sBoxInfo, "Ok", "");

	        	}
	        	else ShowPlayerDialog(playerid, DIALOG_LOGIN2, DIALOG_STYLE_INPUT, ""COL_RED"Wrong password...", ""COL_RED"Wrong password!\n{FFFFFF}Please try again.", "Login", "Kick");


        	}
		}
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	if ( !INI_Exist( pName( playerid ) ) )
		ShowPlayerDialog( playerid, DIALOG_REG_REQ, DIALOG_STYLE_MSGBOX, "{FFFFFF}Password", "{FFFFFF}To play you must register an account!", "Ok", "");
	else
	    ShowPlayerDialog( playerid, DIALOG_LOGIN, DIALOG_STYLE_MSGBOX, "{FFFFFF}Password", "{FFFFFF}Your name is registered, would you like to login?", "Yes", "No");
	return 1;
}
public OnPlayerRequestSpawn( playerid )
{
	SetTimerEx("LoadFav", 200, false , "i" , playerid );
	return 1;
}
forward LoadFav( playerid );
public LoadFav( playerid )
{
    GivePlayerMoney ( playerid, GetPVarInt( playerid, "Moneys"  )    );
	SetPlayerScore  ( playerid, GetPVarInt( playerid, "Score"   )    );
	SetPlayerWeather( playerid, GetPVarInt( playerid, "Weather" )    );
	SetPlayerTime   ( playerid, GetPVarInt( playerid, "Time"    ), 0 );
	SetPlayerSkin   ( playerid, GetPVarInt( playerid, "Skin"    )    );

	SendClientMessage( playerid, -1, "Your favorite things have been loaded! Check "COL_LIGHTBLUE"/stats.");
}
public OnPlayerDisconnect(playerid, reason)
{
    if ( GetPVarInt( playerid, "Logged" ) == 1 && INI_Exist( pName( playerid ) ) )
	{
		new
			PlayerFile[ 13 + MAX_PLAYER_NAME + 1],
			tDate[ 40 ],
			Year,
			Month,
			Day,
			Hour,
			Minute,
			Second
		;

	    format( PlayerFile , sizeof PlayerFile, "Accounts/%s.ini", Encode( pName( playerid ) ) );
		getdate( Year,Month,Day );
		gettime( Hour,Minute,Second );
		format( tDate, sizeof tDate, "%d/%d/%d at %d:%d:%d", Day,Month,Year,Hour,Minute,Second);

	    new
			INI:PlayerAcc = INI_Open( PlayerFile );

		INI_WriteInt( PlayerAcc,    "MONEYS", 		GetPlayerMoney( playerid ) 			);
		INI_WriteInt( PlayerAcc,    "SCORE", 		GetPlayerScore( playerid ) 			);
		INI_WriteInt( PlayerAcc,    "KILLS", 		GetPVarInt( playerid, "Kills" ) 	);
		INI_WriteInt( PlayerAcc,    "DEATHS", 		GetPVarInt( playerid, "Deaths" ) 	);
		INI_WriteInt( PlayerAcc,    "LEVEL",	    GetPVarInt( playerid, "Level" ) 	);
		INI_WriteInt( PlayerAcc,    "VIP_LEVEL", 	GetPVarInt( playerid, "VIP Level" ) );
		INI_WriteInt( PlayerAcc,    "MY_WEATHER", 	GetPVarInt( playerid, "Weather" )	);
		INI_WriteInt( PlayerAcc,    "MY_TIME",  	GetPVarInt( playerid, "Time" )		);
		INI_WriteInt( PlayerAcc,    "MY_SKIN",  	GetPVarInt( playerid, "Skin" ) 		);
		INI_WriteInt( PlayerAcc,    "MUTED",  		GetPVarInt( playerid, "Muted" ) 	);
		INI_WriteInt( PlayerAcc,    "GOD",  		GetPVarInt( playerid, "God" ) 		);
		INI_WriteInt( PlayerAcc,    "CAR_GOD",  	GetPVarInt( playerid, "CGod" ) 		);
		INI_WriteString( PlayerAcc, "LAST_ON",   	tDate 								);
		INI_Close( PlayerAcc );
	}
	SetPVarInt( playerid, "Logged", 0 );
	return 1;
}
//Stocks
stock GetPlayerVLevel( playerid ) return GetPVarInt( playerid, "VIP Level" );
stock GetMySkin( playerid ) return GetPVarInt( playerid, "Skin" );
stock GetMyTime( playerid ) return GetPVarInt( playerid, "Time" );
stock GetMyWeather( playerid ) return GetPVarInt( playerid, "Weather" );


stock IsValidSkin(SkinID)
{
	if ( ( SkinID == 0 ) ||
		 ( SkinID == 7 ) ||
		 ( SkinID >= 9 && SkinID <= 41 ) ||
		 ( SkinID >= 43 && SkinID <= 64 ) ||
		 ( SkinID >= 66 && SkinID <= 73 ) ||
		 ( SkinID >= 75 && SkinID <= 85 ) ||
		 ( SkinID >= 87 && SkinID <= 118 ) ||
		 ( SkinID >= 120 && SkinID <= 148 ) ||
		 ( SkinID >= 150 && SkinID <= 207 ) ||
		 ( SkinID >= 209 && SkinID <= 264 ) ||
		 ( SkinID >= 274 && SkinID <= 288 ) ||
		 ( SkinID >= 290 && SkinID <= 299 ) )
		return true;
	else return false;
}

stock INI_Exist(nickname[])
{
  new tmp[255];
  format(tmp,sizeof(tmp),"Accounts/%s.ini",Encode( nickname ) );
  return fexist(tmp);
}

stock pName( playerid )
{
	new Name[ MAX_PLAYER_NAME ];
	GetPlayerName( playerid, Name, sizeof( Name ) );
	return Name;
}

//DracoBlue
stock Encode(nickname[])
{
  new tmp[255];
  set(tmp,nickname);
  tmp=strreplace("_","_00",tmp);
  tmp=strreplace(";","_01",tmp);
  tmp=strreplace("!","_02",tmp);
  tmp=strreplace("/","_03",tmp);
  tmp=strreplace("\\","_04",tmp);
  tmp=strreplace("[","_05",tmp);
  tmp=strreplace("]","_06",tmp);
  tmp=strreplace("?","_07",tmp);
  tmp=strreplace(".","_08",tmp);
  tmp=strreplace("*","_09",tmp);
  tmp=strreplace("<","_10",tmp);
  tmp=strreplace(">","_11",tmp);
  tmp=strreplace("{","_12",tmp);
  tmp=strreplace("}","_13",tmp);
  tmp=strreplace(" ","_14",tmp);
  tmp=strreplace("\"","_15",tmp);
  tmp=strreplace(":","_16",tmp);
  tmp=strreplace("|","_17",tmp);
  tmp=strreplace("=","_18",tmp);
  return tmp;
}
stock set(dest[],source[]) {
	new count = strlen(source);
	new i=0;
	for (i=0;i<count;i++) {
		dest[i]=source[i];
	}
	dest[count]=0;
}
stock strreplace(trg[],newstr[],src[]) {
    new f=0;
    new s1[255];
    new tmp[255];
    format(s1,sizeof(s1),"%s",src);
    f = strfind(s1,trg);
    tmp[0]=0;
    while (f>=0) {
        strcat(tmp,ret_memcpy(s1, 0, f));
        strcat(tmp,newstr);
        format(s1,sizeof(s1),"%s",ret_memcpy(s1, f+strlen(trg), strlen(s1)-f));
        f = strfind(s1,trg);
    }
    strcat(tmp,s1);
    return tmp;
}
ret_memcpy(source[],index=0,numbytes) {
	new tmp[255];
	new i=0;
	tmp[0]=0;
	if (index>=strlen(source)) return tmp;
	if (numbytes+index>=strlen(source)) numbytes=strlen(source)-index;
	if (numbytes<=0) return tmp;
	for (i=index;i<numbytes+index;i++) {
		tmp[i-index]=source[i];
		if (source[i]==0) return tmp;
	}
	tmp[numbytes]=0;
	return tmp;
}
forward GodTimer( playerid );
public GodTimer( playerid )
{
	if ( GetPVarInt( playerid, "God" ) == 0 ) KillTimer( God[ playerid ] );
	SetPlayerHealth( playerid, 999999999.0 );
}
forward CarGodTimer( playerid );
public CarGodTimer( playerid )
{
	if ( GetPVarInt( playerid, "CGod" ) == 0 ) KillTimer( CGod[ playerid ] );
	if ( IsPlayerInAnyVehicle( playerid ) == 1 )
	{
	    RepairVehicle( GetPlayerVehicleID( playerid ) );
	    SetVehicleHealth( GetPlayerVehicleID( playerid ), 9999.0 );
	}
}
forward CallInfernus(playerid);
public CallInfernus(playerid)
{
	if(IsPlayerInAnyVehicle(playerid)) RemovePlayerFromVehicle(playerid);
	new Float: X, Float: Y, Float: Z, Float: Ang;
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, Ang);
	PutPlayerInVehicle(playerid, pInfernus[playerid], 0);
	SetVehiclePos(pInfernus[playerid], X, Y, Z);
	SetVehicleZAngle(pInfernus[playerid], Ang);
	SetVehicleHealth(pInfernus[playerid],  1000.0);
	LinkVehicleToInterior(pInfernus[playerid], GetPlayerInterior(playerid));
	SendClientMessage( playerid, -1, "-Personal "COL_LIGHTBLUE"Infernus{FFFFFF} called!");
}
forward CreateInfernus( playerid );
public CreateInfernus(playerid)
{
	if(IsPlayerInAnyVehicle(playerid)) RemovePlayerFromVehicle(playerid);
	new Float: X, Float: Y, Float: Z, Float: Ang;
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, Ang);
	pInfernus[playerid] = CreateVehicle(411, X, Y, Z+3, Ang, 75,3, 5000000);
	PutPlayerInVehicle(playerid, pInfernus[playerid], 0);
	LinkVehicleToInterior(pInfernus[playerid], GetPlayerInterior(playerid));
	printf("Personal Infernus created for %s.", pName(playerid));
	SendClientMessage( playerid, -1, "-Personal "COL_LIGHTBLUE"Infernus{FFFFFF} created!");
	for(new i=0; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i) && i != playerid)
		{
			SetVehicleParamsForPlayer(pInfernus[playerid], i, 0, 1);
		}
	}
}
forward CallNRG(playerid);
public CallNRG(playerid)
{
	if(IsPlayerInAnyVehicle(playerid)) RemovePlayerFromVehicle(playerid);
	new Float: X, Float: Y, Float: Z, Float: Ang;
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, Ang);
	PutPlayerInVehicle(playerid, pNrg500[playerid], 0);
	SetVehiclePos(pNrg500[playerid], X, Y, Z);
	SetVehicleZAngle(pNrg500[playerid], Ang);
	SetVehicleHealth(pNrg500[playerid],  1000.0);
	LinkVehicleToInterior(pNrg500[playerid], GetPlayerInterior(playerid));
	SendClientMessage( playerid, -1, "-Personal "COL_LIGHTBLUE"NRG-500{FFFFFF} called");
}
forward CreateNRG(playerid);
public CreateNRG(playerid)
{
	if(IsPlayerInAnyVehicle(playerid)) RemovePlayerFromVehicle(playerid);
	new Float: X, Float: Y, Float: Z, Float: Ang;
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, Ang);
	pNrg500[playerid] = CreateVehicle(522, X, Y, Z+3, Ang, 75,3, 5000000);
	PutPlayerInVehicle(playerid, pNrg500[playerid], 0);
	LinkVehicleToInterior(pNrg500[playerid], GetPlayerInterior(playerid));
	printf("Personal NRG created for %s.", pName(playerid));
    SendClientMessage( playerid, -1, "-Personal "COL_LIGHTBLUE"NRG-500{FFFFFF} created!");
	for(new i=0; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i) && i != playerid)
		{
			SetVehicleParamsForPlayer(pNrg500[playerid], i, 0, 1);
		}
	}
}
