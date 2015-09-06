/*
	*       GangZone Editor FS created by Krisna
	*           	  Version: 1.a
	*
	*   - Credits:
	*       Zamaroht - Colors/sounds    Dracoblue - HexToInt( )
	*       ZeeX - zcmd                 Krisna the Creator
	*
	*
*/

/* ** Includes ** */
#include 							< a_samp >
#include 							< zcmd >

/* ** Configuration ** */
#define FILE_VERSION                "1.a"

#define COLOR_MSG                   0xFAF0CEFF
#define COLOR_ZONE                  3402287696

#define D_TITLE                     "Gang Zone Editor For VGI"
#define DIALOG_NEW_PROJECT          ( 0 + 777 )
#define DIALOG_PROJECT_CONFIG       ( 1 + 777 )
#define DIALOG_ZONE_MANAGE          ( 2 + 777 )
#define DIALOG_ZONE_MODIFY          ( 3 + 777 )
#define DIALOG_ZONE_MODIFY_XY       ( 4 + 777 )
#define DIALOG_ZONE_MODIFY_COLOR    ( 5 + 777 )
#define DIALOG_ZONE_MODIFY_DEL      ( 6 + 777 )

#define SCM                         SendClientMessage

/* ** Server/Player Data ** */
enum E_GANGZONE_DATA
{
	E_ZONE,
	Float: E_MAX_X,
	Float: E_MAX_Y,
	Float: E_MIN_X,
	Float: E_MIN_Y,
	E_COLOR,
	bool: E_CREATED
};

new
	g_ProjectName                   [ 30 ],
	g_gangzoneData                	[ 20 ] [ E_GANGZONE_DATA ],
	p_EditingZone             		[ MAX_PLAYERS char ],
	g_totalZones                    = 0,
	p_ModifyLengthMode              [ MAX_PLAYERS char ],
	bool: g_WorkingProject          = false
;

/* ** Continue ** */

public OnFilterScriptInit( )
{
	print( " - Gang Zone Editor v"#FILE_VERSION" by Krisna Loaded!" );
	return 1;
}

public OnFilterScriptExit( )
{
	for( new z; z < sizeof( g_gangzoneData ); z++ )
	{
     	GangZoneHideForAll( g_gangzoneData[ z ] [ E_ZONE ] );
		GangZoneDestroy( g_gangzoneData[ z ] [ E_ZONE ] );
		g_gangzoneData[ z ] [ E_CREATED ] = false;
		g_totalZones = 0;
	}
	return 1;
}

public OnPlayerDisconnect( playerid, reason )
{
    p_ModifyLengthMode{ playerid } = 0;
	return 1;
}

CMD:zone( playerid, params[ ] )
{
	if( playerid != 0 )
	    return SendClientMessage( playerid, COLOR_MSG, "Only the smaller ID's can create gangzones." );

	if( p_ModifyLengthMode{ playerid } != 0 )
		return SCM( playerid, COLOR_MSG, "Your currently setting a position on a gangzone, to exit that press your sprint key (SPACE)" );
	if( g_WorkingProject == true )
	{
		ShowPlayerDialog( playerid, DIALOG_PROJECT_CONFIG, DIALOG_STYLE_LIST, D_TITLE, "Zone Management\nClose Project\nExport Project", "Select", "" );
	}
	else
	{
	    ShowPlayerDialog( playerid, DIALOG_NEW_PROJECT, DIALOG_STYLE_INPUT, D_TITLE, "Enter a project name:\n\n(NOTE) The project name is what the save file is going to be located\ninside your scriptfiles folder.", "Submit", "Cancel" );
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	new
	    string[ 500 ]
	;

    if( response ) 	PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0); // Confirmation sound
    else 			PlayerPlaySound(playerid, 1084, 0.0, 0.0, 0.0); // Cancelation sound

	if( ( dialogid == DIALOG_NEW_PROJECT ) && response )
	{
	    if( !strlen( inputtext ) || strlen( inputtext ) >= 30 )
			return ShowPlayerDialog(playerid, DIALOG_NEW_PROJECT, DIALOG_STYLE_INPUT, D_TITLE, "Enter a project name:\n\n(NOTE) The project name is what the save file is going to be located\ninside your scriptfiles folder.\n\n{FF0000}A project name must not exceed 30 characters or be blank.", "Submit", "Cancel" );
		format( string, 40, "%s.ini", inputtext );
		if( fexist( string ) )
		    return ShowPlayerDialog(playerid, DIALOG_NEW_PROJECT, DIALOG_STYLE_INPUT, D_TITLE, "Enter a project name:\n\n(NOTE) The project name is what the save file is going to be located\ninside your scriptfiles folder.\n\n{FF0000}This project already exists, try a different name.", "Submit", "Cancel" );
		format( g_ProjectName, 30, "%s", inputtext );
		g_WorkingProject = true;
		ShowPlayerDialog( playerid, DIALOG_PROJECT_CONFIG, DIALOG_STYLE_LIST, D_TITLE, "Zone Management\nClose Project\nExport Project", "Select", "" );
	}
	if( ( dialogid == DIALOG_PROJECT_CONFIG ) && response )
	{
	    switch( listitem )
	    {
	        case 0:
	        {
	            format( string, sizeof( string ), "{00FFFF}Create New Gangzone{FFFFFF}\n" );
				for( new i; i < sizeof( g_gangzoneData ); i++ )
				{
				    if( g_gangzoneData[ i ] [ E_CREATED ] == true ) {
		           		format( string, sizeof( string ), "%sZone %d\n", string, i );
					}
				}
				ShowPlayerDialog( playerid, DIALOG_ZONE_MANAGE, DIALOG_STYLE_LIST, D_TITLE, string, "Select", "Go Back" );
	        }
	        case 1:
	        {
	            g_ProjectName[ 0 ] = '\0';
	            g_WorkingProject = false;

				for( new z; z < sizeof( g_gangzoneData ); z++ )
				{
		            GangZoneHideForAll( g_gangzoneData[ z ] [ E_ZONE ] );
					GangZoneDestroy( g_gangzoneData[ z ] [ E_ZONE ] );
					g_gangzoneData[ z ] [ E_CREATED ] = false;
					g_totalZones = 0;
	            }

				SCM( playerid, COLOR_MSG, "You have successfully closed this project." );
	        }
	        case 2:
	        {
	            if( g_totalZones )
	            {
		            new
		                File: iFile
					;
					format( string, 40, "%s.ini", g_ProjectName );
					iFile = fopen( string );
					fwrite( iFile, "This is create a new zones\r\n\r\n" );
					for( new i; i < g_totalZones; i++ )
					{
					    format( string, sizeof( string ), "GangZoneCreate( %0.3f, %0.3f, %0.3f, %0.3f ); // color = %d\r\n", g_gangzoneData[ i ] [ E_MIN_X ], g_gangzoneData[ i ] [ E_MIN_Y ], g_gangzoneData[ i ] [ E_MAX_X ], g_gangzoneData[ i ] [ E_MAX_Y ], g_gangzoneData[ i ] [ E_COLOR ] );
						fwrite( iFile, string );
					}
					fclose( iFile );
					ShowPlayerDialog( playerid, DIALOG_PROJECT_CONFIG, DIALOG_STYLE_LIST, D_TITLE, "Zone Management\nClose Project\nExport Project", "Select", "" );
					SCM( playerid, COLOR_MSG, "You have successfully exported this project, check your scriptfiles for the export file." );
				}
				else
				{
				    ShowPlayerDialog( playerid, DIALOG_PROJECT_CONFIG, DIALOG_STYLE_LIST, D_TITLE, "Zone Management\nClose Project\nExport Project", "Select", "" );
					SCM( playerid, COLOR_MSG, "Couldn't process due to being that there are no textdraws created." );
				}
	        }
	    }
	}
	if( dialogid == DIALOG_ZONE_MANAGE )
	{
	    if( response )
	    {
	        if( listitem != 0 )
	        {
	            p_EditingZone{ playerid } = -1;

		        for( new i, x = 1; ; i ++ )
		        {
		            if( g_gangzoneData[ i ] [ E_CREATED ] )
		            {
		                if( x == listitem )
		                {
		                    p_EditingZone{ playerid } = i;
		                    format( string, 100, "You are new editing Zone %d", i );
		                    SCM( playerid, COLOR_MSG, string );
		                    ShowPlayerDialog( playerid, DIALOG_ZONE_MODIFY, DIALOG_STYLE_LIST, D_TITLE, "Change Position\nChange Color\nDelete Zone", "Select", "Go Back" );
		                }
		                x ++;
		            }
		        }

			}
			else
			{
			    new gID = getFreeGangZone( );

				if( gID == -1 )
				{
				    SCM( playerid, COLOR_MSG, "You have reached the limit of gang zones." );
				    goto skip_createzone;
				}

	            g_gangzoneData[ gID ] [ E_CREATED ] = true;
	            g_gangzoneData[ gID ] [ E_COLOR ] = COLOR_ZONE;
                g_gangzoneData[ gID ] [ E_MAX_X ] = 10.0;
                g_gangzoneData[ gID ] [ E_MAX_Y ] = 10.0;
                g_gangzoneData[ gID ] [ E_MIN_X ] = 10.0;
                g_gangzoneData[ gID ] [ E_MIN_Y ] = 10.0;
                g_gangzoneData[ gID ] [ E_ZONE ] = GangZoneCreate( 10.0, 10.0, 10.0, 10.0 );
				GangZoneShowForPlayer( playerid, g_gangzoneData[ gID ] [ E_ZONE ], g_gangzoneData[ gID ] [ E_COLOR ] );
				g_totalZones ++;

			    skip_createzone:
			    format( string, sizeof( string ), "{00FFFF}Create New Gangzone{FFFFFF}\n" );
                for( new i; i < sizeof( g_gangzoneData ); i++ )
				{
				    if( g_gangzoneData[ i ] [ E_CREATED ] == true ) {
		           		format( string, sizeof( string ), "%sZone %d\n", string, i );
					}
				}
				ShowPlayerDialog( playerid, DIALOG_ZONE_MANAGE, DIALOG_STYLE_LIST, D_TITLE, string, "Select", "Go Back" );
			}
	    }
	    else ShowPlayerDialog( playerid, DIALOG_PROJECT_CONFIG, DIALOG_STYLE_LIST, D_TITLE, "Zone Management\nClose Project\nExport Project", "Select", "" );
	}
	if( dialogid == DIALOG_ZONE_MODIFY )
	{
	    if( response )
	    {
	        switch( listitem )
	        {
				case 0: ShowPlayerDialog( playerid, DIALOG_ZONE_MODIFY_XY, DIALOG_STYLE_LIST, D_TITLE, "Modify Max X/Y\nModify Min X/Y", "Select", "Go Back" );
				case 1: ShowPlayerDialog( playerid, DIALOG_ZONE_MODIFY_COLOR, DIALOG_STYLE_INPUT, D_TITLE, "Enter the color you wish to use for your gangzone.\n(NOTE) Must be in hexidecimal otherwise something can go wrong!", "Submit", "Go Back" );
				case 2: ShowPlayerDialog( playerid, DIALOG_ZONE_MODIFY_DEL, DIALOG_STYLE_MSGBOX, D_TITLE, "Are you sure you want to delete this gangzone?", "Delete", "Cancel" );
	        }
	    }
	    else
	    {
	        format( string, sizeof( string ), "{00FFFF}Create New Gangzone{FFFFFF}\n" );
			for( new i; i < sizeof( g_gangzoneData ); i++ )
			{
			    if( g_gangzoneData[ i ] [ E_CREATED ] == true ) {
	           		format( string, sizeof( string ), "%sZone %d\n", string, i );
				}
			}
			ShowPlayerDialog( playerid, DIALOG_ZONE_MANAGE, DIALOG_STYLE_LIST, D_TITLE, string, "Select", "Go Back" );
	    }
	}
	if( dialogid == DIALOG_ZONE_MODIFY_XY )
	{
	    if( response )
	    {
			p_ModifyLengthMode{ playerid } = listitem + 1;
			SCM( playerid, COLOR_MSG, "Use you map and right click on the position that you want to set the max/min X-Y at." );
			SCM( playerid, COLOR_MSG, "Press your sprint key (SPACE) when you're done." );
	    }
	    else ShowPlayerDialog( playerid, DIALOG_ZONE_MODIFY, DIALOG_STYLE_LIST, D_TITLE, "Change Position\nChange Color\nDelete Zone", "Select", "Go Back" );
	}
	if( dialogid == DIALOG_ZONE_MODIFY_COLOR )
	{
	    if( response )
	    {
			#define n inputtext
	        if( !strlen( n ) || n[ 0 ] != '0' || n[ 1 ] != 'x' || strlen( n ) > 10 )
	            return ShowPlayerDialog( playerid, DIALOG_ZONE_MODIFY_COLOR, DIALOG_STYLE_INPUT, D_TITLE, "Enter the color you wish to use for your gangzone.\n(NOTE) Must be in hexidecimal otherwise something can go wrong!\n\n{FF0000}Invalid hexidecimal color!", "Submit", "Go Back" );

			GangZoneHideForPlayer( playerid, g_gangzoneData[ p_EditingZone{ playerid } ] [ E_ZONE ] );
	        g_gangzoneData[ p_EditingZone{ playerid } ] [ E_COLOR ] = HexToInt( n );
			GangZoneShowForPlayer( playerid, g_gangzoneData[ p_EditingZone{ playerid } ] [ E_ZONE ], HexToInt( n ) );
			ShowPlayerDialog( playerid, DIALOG_ZONE_MODIFY_COLOR, DIALOG_STYLE_INPUT, D_TITLE, "Enter the color you wish to use for your gangzone.\n(NOTE) Must be in hexidecimal otherwise something can go wrong!", "Submit", "Go Back" );
	        #undef n
	    }
	    else ShowPlayerDialog( playerid, DIALOG_ZONE_MODIFY, DIALOG_STYLE_LIST, D_TITLE, "Change Position\nChange Color\nDelete Zone", "Select", "Go Back" );
	}
	if( dialogid == DIALOG_ZONE_MODIFY_DEL )
	{
	    if( response )
	    {
	        new z = p_EditingZone{ playerid };
			GangZoneHideForAll( g_gangzoneData[ z ] [ E_ZONE ] );
			GangZoneDestroy( g_gangzoneData[ z ] [ E_ZONE ] );
			g_gangzoneData[ z ] [ E_CREATED ] = false;
			g_totalZones --;
            format( string, sizeof( string ), "{00FFFF}Create New Gangzone{FFFFFF}\n" );
			for( new i; i < sizeof( g_gangzoneData ); i++ )
			{
			    if( g_gangzoneData[ i ] [ E_CREATED ] == true ) {
	           		format( string, sizeof( string ), "%sZone %d\n", string, i );
				}
			}
			ShowPlayerDialog( playerid, DIALOG_ZONE_MANAGE, DIALOG_STYLE_LIST, D_TITLE, string, "Select", "Go Back" );
	    }
	    else ShowPlayerDialog( playerid, DIALOG_ZONE_MODIFY, DIALOG_STYLE_LIST, D_TITLE, "Change Position\nChange Color\nDelete Zone", "Select", "Go Back" );
	}
	return 1;
}

public OnPlayerClickMap( playerid, Float:fX, Float:fY, Float:fZ )
{
	switch( p_ModifyLengthMode{ playerid } )
	{
	    case 1:
	    {
	        new i = p_EditingZone{ playerid };
	        g_gangzoneData[ i ] [ E_MAX_X ] = fX;
	        g_gangzoneData[ i ] [ E_MAX_Y ] = fY;
			GangZoneHideForPlayer( playerid, g_gangzoneData[ i ] [ E_ZONE ] );
	       	g_gangzoneData[ i ] [ E_ZONE ] = GangZoneCreate( g_gangzoneData[ i ] [ E_MIN_X ], g_gangzoneData[ i ] [ E_MIN_Y ], g_gangzoneData[ i ] [ E_MAX_X ], g_gangzoneData[ i ] [ E_MAX_Y ] );
			GangZoneShowForPlayer( playerid, g_gangzoneData[ i ] [ E_ZONE ], g_gangzoneData[ i ] [ E_COLOR ] );
	        SCM( playerid, COLOR_MSG, "You have successfully set the max X-Y at the point selected." );
	    }
	    case 2:
	    {
	        new i = p_EditingZone{ playerid };
	        g_gangzoneData[ i ] [ E_MIN_X ] = fX;
	        g_gangzoneData[ i ] [ E_MIN_Y ] = fY;
			GangZoneHideForPlayer( playerid, g_gangzoneData[ i ] [ E_ZONE ] );
	        GangZoneDestroy( g_gangzoneData[ i ] [ E_ZONE ] );
       		g_gangzoneData[ i ] [ E_ZONE ] = GangZoneCreate( g_gangzoneData[ i ] [ E_MIN_X ], g_gangzoneData[ i ] [ E_MIN_Y ], g_gangzoneData[ i ] [ E_MAX_X ], g_gangzoneData[ i ] [ E_MAX_Y ] );
			GangZoneShowForPlayer( playerid, g_gangzoneData[ i ] [ E_ZONE ], g_gangzoneData[ i ] [ E_COLOR ] );
	        SCM( playerid, COLOR_MSG, "You have successfully set the min X-Y at the point selected." );
	    }
	}
	return 1;
}

public OnPlayerKeyStateChange( playerid, newkeys, oldkeys )
{
	if( ( newkeys & KEY_SPRINT ) && p_ModifyLengthMode{ playerid } != 0 )
	{
	    p_ModifyLengthMode{ playerid } = 0;
	    ShowPlayerDialog( playerid, DIALOG_ZONE_MODIFY_XY, DIALOG_STYLE_LIST, D_TITLE, "Modify Max X/Y\nModify Min X/Y", "Select", "Go Back" );
	    SCM( playerid, COLOR_MSG, "You have finished setting the position on this axis." );
	}
	return 1;
}

stock getFreeGangZone( )
{
	for( new i; i < sizeof( g_gangzoneData ); i++ )
	{
	    if( !g_gangzoneData[ i ] [ E_CREATED ] )
			return i;
	}
	return -1;
}

stock HexToInt(string[]) // By DracoBlue
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
