//[HiC]TheKiller's object creater script!
//Don't remove the credits or instructions :P.
//=========INSTRUCTIONS===================
//1. If you are using either F_Streamer (Fallout's) or the streamer plugin uncomment the includes :)
//2. Edit the database information to what you use (Host, User, Password, Database). If you are using wamp on localhost than it's already default
//3. You will need the MySQL plugin and include (http://forum.sa-mp.com/showthread.php?t=56564) and the sscanf2 plugin and include (http://forum.sa-mp.com/showthread.php?t=120356)
//4. If you are using CreateObject, leave the COB, CDO, FCO as it is. If you are using the streamer plugin, Uncomment CDO and comment COB. If you are using fallouts, uncomment FCO and comment COB
//5. Compile the script and make sure all the plugins are working.
//6. If you are planning on preloading more than 500 objects at a time change the MAX_LOAD_OBJECT value to a higher value.

//NEEDED INCLUDES (Don't comment)
#include <a_samp>
#include <a_mysql>
#include <sscanf2>
//==============================

//Uncomment if you use them
#include <streamer>
//#include <F_Streamer>

//==============================

//EDIT THIS IF YOU PLAB ON HAVING MORE THAN 500 objects loaded at a time (Using this script)
#define MAX_LOAD_OBJECTS 500 // MAX OF 500 spawned at a time, change this but I don't really think it should go over 2k.

//===============================

//------------EDIT THESE TO WHAT YOU USE (These are defults for localhost wa-mp server)---------------
#define SQL_HOST "127.0.0.1" //Standard wamp host
#define SQL_USER "root" //Standard wamp user
#define SQL_PASS "" //Standard wamp password (Nothing)
#define SQL_DB "object" //This is the database we are going to use (I'll show you how to set it up later :) )

//================================

//--------------Use comments if you are not using ("//")-----------------
//#define COB//Create object
#define CDO //Ignoto's streamer plugin
//#define FCO //Fallout's object streamer
//-----------------------------------------------------------------------


//START OF SCRIPT
#define mysql_fetch_row(%1) mysql_fetch_row_format(%1,"|")
new OBID[MAX_LOAD_OBJECTS], row[500], Obcount, Float:Floats[7], Var[6], Stopload, FORMAT[20], refstr[100], AID[MAX_LOAD_OBJECTS];

public OnFilterScriptInit()
{
	#if defined COB
	format(FORMAT, sizeof(FORMAT), "CreateObject");
	#endif
	#if defined CDO
	format(FORMAT, sizeof(FORMAT), "CreateDynamicObject");
	#endif
	#if defined FCO
	format(FORMAT, sizeof(FORMAT), "F_CreateObject");
	#endif
	mysql_debug(1);
	mysql_connect(SQL_HOST, SQL_USER, SQL_DB, SQL_PASS);
	SetTimer("Emload", 10000, true);
	new query[75];
	format(query, sizeof(query), "SELECT * FROM `%s`", FORMAT);
	mysql_query(query);
	mysql_store_result();
	while(mysql_fetch_row(row))
    {
        #if defined COB
            Obcount = FindFirstFreeSlot();
			sscanf(row, "p<|>dfffffffds[100]dd", Var[0], Floats[0], Floats[1], Floats[2], Floats[3], Floats[4], Floats[5], Floats[6], Var[1], refstr, AID[Obcount], Var[2]);
			OBID[Obcount] = CreateObject(Var[0], Floats[0], Floats[1], Floats[2], Floats[3], Floats[4], Floats[5], Floats[6]);
		#endif
        #if defined CDO // This is so if you don't have the include it won't chuck errors at you.
            Obcount = FindFirstFreeSlot();
			sscanf(row, "p<|>dffffffdddfds[100]dd", Var[0], Floats[0], Floats[1], Floats[2], Floats[3], Floats[4], Floats[5], Var[1], Var[2], Var[3], Floats[6], Var[4], refstr, AID[Obcount], Var[5]);
			OBID[Obcount] = CreateDynamicObject(Var[0], Floats[0], Floats[1], Floats[2], Floats[3], Floats[4], Floats[5], Var[1], Var[2], Var[3], Floats[6]);
		#endif
		#if defined FCO // This is so if you don't have the include it won't chuck errors at you.
            Obcount = FindFirstFreeSlot();
  			sscanf(row, "p<|>dffffffds[100]dd", Var[0], Floats[0], Floats[1], Floats[2], Floats[3], Floats[4], Floats[5], Var[1], refstr, AID[Obcount], Var[2]);
			OBID[Obcount] = F_CreateObject(Var[0], Floats[0], Floats[1], Floats[2], Floats[3], Floats[4], Floats[5]);
		#endif
    }
    format(query, sizeof(query), "UPDATE `%s` SET `immediate` = 0 WHERE `immediate` = 1", FORMAT);
    mysql_query(query);
    mysql_free_result();
	return 1;
}

forward Emload();
public Emload()
{
	if(Stopload) return 1;
	new query[75];
	format(query, sizeof(query), "SELECT * FROM `%s` WHERE `immediate` = 1", FORMAT);
	mysql_query(query);
	mysql_store_result();
	while(mysql_fetch_row(row))
    {
        #if defined COB
            Obcount = FindFirstFreeSlot();
			sscanf(row, "p<|>dfffffffds[100]dd", Var[0], Floats[0], Floats[1], Floats[2], Floats[3], Floats[4], Floats[5], Floats[6], Var[1], refstr, AID[Obcount], Var[2]);
			OBID[Obcount] = CreateObject(Var[0], Floats[0], Floats[1], Floats[2], Floats[3], Floats[4], Floats[5], Floats[6]);
		#endif
        #if defined CDO // This is so if you don't have the include it won't chuck errors at you.
            Obcount = FindFirstFreeSlot();
			sscanf(row, "p<|>dffffffdddfds[100]dd", Var[0], Floats[0], Floats[1], Floats[2], Floats[3], Floats[4], Floats[5], Var[1], Var[2], Var[3], Floats[6], Var[4], refstr, AID[Obcount], Var[5]);
			OBID[Obcount] = CreateDynamicObject(Var[0], Floats[0], Floats[1], Floats[2], Floats[3], Floats[4], Floats[5], Var[1], Var[2], Var[3], Floats[6]);
		#endif
		#if defined FCO // This is so if you don't have the include it won't chuck errors at you.
            Obcount = FindFirstFreeSlot();
  			sscanf(row, "p<|>dffffffds[100]dd", Var[0], Floats[0], Floats[1], Floats[2], Floats[3], Floats[4], Floats[5], Var[1], refstr, AID[Obcount], Var[2]);
			OBID[Obcount] = F_CreateObject(Var[0], Floats[0], Floats[1], Floats[2], Floats[3], Floats[4], Floats[5]);
		#endif
    }
    mysql_free_result();
    format(query, sizeof(query), "UPDATE `%s` SET `immediate` = 0 WHERE `immediate` = 1", FORMAT);
    mysql_query(query);
    //=========================================================================
	format(query, sizeof(query), "SELECT * FROM %s WHERE deleted = 1", FORMAT);
	mysql_query(query);
	mysql_store_result();
	new intt;
	new p = mysql_num_rows();
	if(p > 0)
	{
		for(new x; x<p; x++)
		{
		    format(query, sizeof(query), "SELECT id FROM %s WHERE deleted = 1", FORMAT);
			mysql_query(query);
			mysql_store_result();
			new aid = mysql_fetch_int();
			for(new Z; Z<MAX_LOAD_OBJECTS; Z++) //Isn't very efficient but this is only actually called when there is immediate objects to be deleted
			{
	 			if(AID[Z] == aid)
	   			{
	      			#if defined COB
			  		DestroyObject(Z);
			  		#endif
			  		
			  		#if defined CDO
			  		DestroyDynamicObject(Z);
			  		#endif
			  		
					#if defined FCO
					F_DestroyObject(Z);
					#endif
					AID[Z] = 0;
					OBID[Z] = 0;
					intt = Z;
					break;
		    	}
	    	}
			format(query, sizeof(query), "DELETE FROM %s WHERE deleted = 1 AND id = %d", FORMAT, aid);
			mysql_query(query);
			mysql_free_result();
		}
	}
	#if defined COB
	DestroyObject(intt+1);
	#endif
	#if defined CDO
	DestroyDynamicObject(intt+1);
	#endif
	#if defined FCO
	F_DestroyObject(intt+1);
	#endif
	return 1;
}

stock DeleteAllLoadObjects()
{
	for(new i; i<MAX_LOAD_OBJECTS; i++)
	{
	    if(OBID[i] != 0) DestroyObject(OBID[i]);
	}
}

stock ReloadAllLoadObjects()
{
	for(new i; i<MAX_LOAD_OBJECTS; i++)
	{
	    if(OBID[i] != 0) DestroyObject(OBID[i]);
	}
	new query[75];
	format(query, sizeof(query), "SELECT * FROM `%s`", FORMAT);
	mysql_query(query);
	mysql_store_result();
	if(Stopload) return 1;
	while(mysql_fetch_row(row))
    {
        #if defined COB
            Obcount = FindFirstFreeSlot();
			sscanf(row, "p<|>dfffffffds[100]dd", Var[0], Floats[0], Floats[1], Floats[2], Floats[3], Floats[4], Floats[5], Floats[6], Var[1], refstr, AID[Obcount], Var[2]);
			OBID[Obcount] = CreateObject(Var[0], Floats[0], Floats[1], Floats[2], Floats[3], Floats[4], Floats[5], Floats[6]);
		#endif
        #if defined CDO // This is so if you don't have the include it won't chuck errors at you.
            Obcount = FindFirstFreeSlot();
			sscanf(row, "p<|>dffffffdddfds[100]dd", Var[0], Floats[0], Floats[1], Floats[2], Floats[3], Floats[4], Floats[5], Var[1], Var[2], Var[3], Floats[6], Var[4], refstr, AID[Obcount], Var[5]);
			OBID[Obcount] = CreateDynamicObject(Var[0], Floats[0], Floats[1], Floats[2], Floats[3], Floats[4], Floats[5], Var[1], Var[2], Var[3], Floats[6]);
		#endif
		#if defined FCO // This is so if you don't have the include it won't chuck errors at you.
            Obcount = FindFirstFreeSlot();
  			sscanf(row, "p<|>dffffffds[100]dd", Var[0], Floats[0], Floats[1], Floats[2], Floats[3], Floats[4], Floats[5], Var[1], refstr, AID[Obcount], Var[2]);
			OBID[Obcount] = F_CreateObject(Var[0], Floats[0], Floats[1], Floats[2], Floats[3], Floats[4], Floats[5]);
		#endif
    }
    format(query, sizeof(query), "UPDATE `%s` SET `immediate` = 0 WHERE `immediate` = 1", FORMAT);
    mysql_query(query);
    mysql_free_result();
    return 1;
}

stock StopLoadingObjects() return Stopload = 1;
stock StartLoadingObjects() return Stopload = 0;

public OnPlayerCommandText(playerid, cmdtext[])
{
	if(IsPlayerAdmin(playerid))
	{
		if(!strcmp(cmdtext, "/DeleteLoadObjects", true))
		{
		    DeleteAllLoadObjects();
		    return 1;
		}
		if(!strcmp(cmdtext, "/ReloadLoadObjects", true))
		{
		    ReloadAllLoadObjects();
		    return 1;
		}
		if(!strcmp(cmdtext, "/StopLoadingObjects", true))
		{
		    StopLoadingObjects();
		    return 1;
		}
		if(!strcmp(cmdtext, "/StartLoadingObjects", true))
		{
		    StartLoadingObjects();
		    return 1;
		}
	}
	return 0;
}

stock FindFirstFreeSlot()
{
	for(new i; i<MAX_LOAD_OBJECTS; i++)
	{
	    if(AID[i] == 0) return i;
	}
	return -1;
}
