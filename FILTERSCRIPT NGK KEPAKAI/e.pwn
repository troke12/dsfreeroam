#include <a_samp>

#define KEY_1 64231 	// Recommendenced(1-1000000)
#define KEY_2 12373 	// Recommendenced(1-1000000)
#define KEY_3 97864 	// Recommendenced(1-1000000)
#define KEY_4 21675 	// Recommendenced(1-1000000)
#define KEY_5 58786 	// Recommendenced(1-1000000)
#define type1 1 		// Code
#define type0 0 		// Decode

#define MAX_STRING_TO_CODE 128

public OnFilterScriptInit() { print("[Loaded] Unique Keys by Psycho."); return 1; }
public OnFilterScriptExit() { print("[Unloaded] Unique Keys by Psycho."); return 1; }

stock UniqueCode(type,string[MAX_STRING_TO_CODE],key1,key2,key3,key4,key5)
{
	new length = strlen(string),string2[MAX_STRING_TO_CODE];
	for(new i = 0; i < length; i++)
	{
		if(type == type1) { string2[i] = (string[i]-key1)+key2-key3+key4+key5; } // Code
		if(type == type0) { string2[i] = (string[i]+key1)-key2+key3-key4-key5; } // Decode
	}
	return string2;
}
