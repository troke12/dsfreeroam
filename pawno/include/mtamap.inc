/*
	Copyright 2010 Michael Dabski (mick88)
	This script is my intelectual property. Please respect that and keep my credits where they are.
	You are free to modify this script or use parts of the code as long as you give me credit for my work.
*/

/*
 	MTA .map loader by mick88
 		Release 0.2
	12th December 2010

  Requirements: SSCANF2 plugin by Y_Less

  Stock functions:
  	LoadMtaMap(file[], convert03c) 	- loads .map file
  	UnloadMtaMap(file[]) 			- unloads previously loaded .map file
  	UnloadAll()                     - unloads all .map files
  	IsMapLoaded(file[])             - returns true if map has been loaded (even if loaded partially)

  Supported map elements: objects, vehicles

  Supported object data: model, posX, posY, posZ, rotX, rotY, rotZ + SAMP 0.3c objects
  Supported vehicle data: model, paintjob, mods (upgrades), colors (2 colors),
							posX, posY, posZ, rotZ, interior, world (dimension),
							numberplate (0.3c only)
	Changelog:
* 13th September 2010 ver 0.1:
	- first release
	
* 12th December 2010 ver 0.2
	-Added support for SA-MP 0.3c objects
	-Added storing object/vehicle IDs
	-Added function to unload single map
	-This script is now an include
	-Added support for custom vehicle numberplates (SA-MP 0.3c only)
	-Added function to unload all current map files
	-Added function checking if map is loaded
	-Support for Incognito's streamer
	
    native UnloadMtaMap(file[MAX_MAP_FILE_PATH]);
    native LoadMtaMap(file[MAX_MAP_FILE_PATH], convert03c=false);
    native UnloadAll();
    native IsMapLoaded(file[MAX_MAP_FILE_PATH]);
    
*/
#include <sscanf2>

#define MAX_LOADED_ELEMENTS         5000	//Max number of vehicles + objects
#define MAX_MAP_FILE_PATH           80
#define VEHICLE_RESPAWN_DELAY 		300
#define MAP_STREAM_DISTANCE          300.0

#if defined _streamer_included
    #define ADD_OBJECT(%1) 				CreateDynamicObject(%1, interior, world, -1, MAP_STREAM_DISTANCE)
    #define DELETE_OBJECT(%1)       	DestroyDynamicObject(%1)
#else                                   //Modify these if you use different streamer:
    #define ADD_OBJECT(%1) 				CreateObject(%1, MAP_STREAM_DISTANCE)
	#define DELETE_OBJECT(%1)           DestroyObject(%1)
#endif

#define MAX_MODS 					14
#define MAX_NUMBERPLATE             9

#define ELEMENT_TYPE_NONE			0
#define ELEMENT_TYPE_OBJECT			1
#define ELEMENT_TYPE_VEHICLE		2

enum MapElement
{
	eElementID,
	eElementType,
	eElementSource[MAX_MAP_FILE_PATH]
}

new
	Float: MapElements[MAX_LOADED_ELEMENTS][MapElement],
	MinElementID = 0;
	
stock NextElementID()
{
	Increment:
	MinElementID++;
	if (MinElementID == MAX_LOADED_ELEMENTS)
	{
	    print("ERROR: Cannot load any more map elements. Current maximum "#MAX_LOADED_ELEMENTS" has been reached!");
		return false;
	}
	if (MapElements[MinElementID][eElementType]) 	goto Increment;
	return true;
}

// :::::::::::::::::::::::::: STOCK FUNCTIONS :::::::::::::::::::::::::::
stock UnloadMtaMap(file[])
{
	new n;
	for (new id=MAX_LOADED_ELEMENTS-1; id >= 0; id--) if (MapElements[id][eElementType] && strcmp(file, MapElements[id][eElementSource], false, MAX_MAP_FILE_PATH) == 0)
	{
	    switch (MapElements[id][eElementType])
	    {
	        case ELEMENT_TYPE_OBJECT: 	DELETE_OBJECT(MapElements[id][eElementID]);
	        case ELEMENT_TYPE_VEHICLE:  DestroyVehicle(MapElements[id][eElementID]);
	    }
	    MapElements[id][eElementID] 		= 0;
	    MapElements[id][eElementType]   	= ELEMENT_TYPE_NONE;
	    MapElements[id][eElementSource][0] 	= '\0';
	    MinElementID 						= id;
	}
	return n;
}

stock IsMapLoaded(file[])
{
	for (new id=MAX_LOADED_ELEMENTS-1; id >= 0; id--) if (MapElements[id][eElementType] && strcmp(file, MapElements[id][eElementSource], false, MAX_MAP_FILE_PATH) == 0) return true;
	return false;
}

stock UnloadAll()
{
	new n;
	for (new id=MAX_LOADED_ELEMENTS-1; id >= 0; id--) if (MapElements[id][eElementType])
	{
	    switch (MapElements[id][eElementType])
	    {
	        case ELEMENT_TYPE_OBJECT: 	DELETE_OBJECT(MapElements[id][eElementID]);
	        case ELEMENT_TYPE_VEHICLE:  DestroyVehicle(MapElements[id][eElementID]);
	    }
	    MapElements[id][eElementID] 		= 0;
	    MapElements[id][eElementType]   	= ELEMENT_TYPE_NONE;
	    MapElements[id][eElementSource][0] 	= '\0';
	    MinElementID 						= id;
	}
	return n;
}

stock LoadMtaMap(file[], convert03c=false)
{
	if (!fexist(file) || MinElementID == MAX_LOADED_ELEMENTS)
	{
	    printf("Map %s cannot be loaded", file);
		return 0;
	}
	new File:MapFile=fopen(file),
	n, string[400], numberplate[MAX_NUMBERPLATE],
	Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz,
	modelid, paintjob, interior, world,
	t = GetTickCount();
	
	while(fread(MapFile, string))
	{
	    if (!sscanf(string, "p<\">'object''model='d'interior='d'dimension='d'posX='f'posY='f'posZ='f'rotX='f'rotY='f'rotZ='f", modelid, interior, world, x, y, z, rx, ry, rz))
		{
	        if (convert03c)
	        {
	            switch(modelid)
			    {
			        case 14383..14483: 	modelid += 4248;
					case 14770..14856: 	modelid += 4063;
					case 14858..14871: 	modelid += 4062;
					case 18000..18036: 	modelid += 934;
					case 18038..18101: 	modelid += 933;
					case 14872..14883: 	modelid += 4163;
					case 14885..14891: 	modelid += 4162;
					case 13590..13667: 	modelid += 5142;
					case 14500..14522: 	modelid += 4310;
					case 12835..12944: 	modelid -= 6219;
					case 14892: 		modelid += 5009;
			    }
	        }
	        //modelid x y z rx ry rz interior world
	        new objectid = ADD_OBJECT(modelid, x, y, z, rx, ry, rz);
	        if (objectid == INVALID_OBJECT_ID) printf("Error, object could not be created. Make sure you don't exceed max number of objects. Use stramer if you need to create more than %d objects!", MAX_OBJECTS);
	        else
	        {
	            #if defined _streamer_included
			        Streamer_SetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_DRAW_DISTANCE, MAP_STREAM_DISTANCE);
				#endif
	            MapElements[MinElementID][eElementType] 	= ELEMENT_TYPE_OBJECT;
	            MapElements[MinElementID][eElementID] 		= objectid;
	            strcp(file, MapElements[MinElementID][eElementSource]);
	            //MapElements[MinElementID][eElementSource] 	= file;
	            n++;
	            //printf("Object %d loaded into slot %d", objectid, MinElementID);
				if (!NextElementID())
				{
				    fclose(MapFile);
					return n;
				}
	        }
	    }
	    else if (!sscanf(string, "p<\">'vehicle''paintjob='d'model='d'plate='s["#MAX_NUMBERPLATE"]'interior='d'dimension='d'posX='f'posY='f'posZ='f'rotZ='f", paintjob, modelid, numberplate, interior, world, x, y, z, rz))
	    {
	        new col1, col2, colors[20], mods[80], mod[MAX_MODS];
	        sscanf(string, "p<\">'color='s[20] ", colors);
	        sscanf(string, "p<\">'upgrades='s[80] ", mods);
	        sscanf(colors, "p<,>dd", col1, col2);
	        sscanf(mods, "p<,>A<d>(0)["#MAX_MODS"]", mod);
	        
	        //modelid x y z rz col1 col2 paintjob interior world
			new vehicleid = CreateVehicle(modelid, x, y, z, rz, col1, col2, VEHICLE_RESPAWN_DELAY);
			if (vehicleid == INVALID_VEHICLE_ID) print("Vehicle failed to load! Check if you exceeded maximum of 2000 vehicles");
			else
			{
			    SetVehicleNumberPlate(vehicleid, numberplate);
			    SetVehicleToRespawn(vehicleid);
			    for (new i; i < MAX_MODS; i++) if (mod[i]) AddVehicleComponent(vehicleid, mod[i]);
	            ChangeVehiclePaintjob(vehicleid, paintjob);
	            LinkVehicleToInterior(vehicleid, interior);
	            SetVehicleVirtualWorld(vehicleid, world);
	            
	            MapElements[MinElementID][eElementType] 	= ELEMENT_TYPE_VEHICLE;
	            MapElements[MinElementID][eElementID] 		= vehicleid;
	            strcp(file, MapElements[MinElementID][eElementSource]);
	            //MapElements[MinElementID][eElementSource] 	= file;
	            n++;
	            //printf("Vehicle %d loaded into slot %d", vehicleid, MinElementID);
				if (!NextElementID())
				{
				    fclose(MapFile);
					return n;
				}
			}
	    }
	}
	fclose(MapFile);
	printf("%d items loaded from '%s' in %dms", n, file, GetTickCount()-t);
	return n;
}

stock strcp(from[], to[])
{
	new i;
	for (i = 0; from[i]; i++) to[i] = from[i];
	to[i] = '\0';
}

/*
	Copyright 2010 Michael Dabski (mick88)
	This script is my intelectual property. Please respect that and keep my credits where they are.
	You are free to modify this script or use parts of the code as long as you give me credit for my work.
*/