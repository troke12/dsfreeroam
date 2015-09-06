#include <a_samp>

#define COLOR_ORANGE 0xFFA500AA

new messages[4][256] = {
"Register Today In Our web sanguir.forumid.net",
"You can see all the cmds here /teles /cmds /rules /credits /about",
"Server Creators:Troke ,Oloberysko, Andi_Evandy ",
"/carmenu /wepsmenu /teles" // The last one Should be without ',' commas.

	//if you want you can add more lines, where there is change the number [4] for the quantity of yours added line.
	//You can also change the colors, can use Hex Codes,Example: {FFFFFF}
	//has a site here what i usage http://www.developingwebs.net/tools/color.php
};

new colors[] = {
COLOR_ORANGE
};

forward RandomMSG();

public OnGameModeInit()
{
	SetTimer("RandomMSG",300000,1);
	return 1;
}

public RandomMSG()
{
	new string[256];
	new random1 = random(sizeof(messages));
	new random2 = random(sizeof(colors));
	format(string, sizeof(string), "%s", messages[random1]);
	SendClientMessageToAll(colors[random2],string);
	return 1;
}
