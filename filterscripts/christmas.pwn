/*
  ___ __  ____      _____      _____ _          _     _
 |  _|  \/  \ \    / /_  |    / ____| |        (_)   | |
 | | | \  / |\ \  / /  | |   | |    | |__  _ __ _ ___| |_ _ __ ___   __ _ ___
 | | | |\/| | \ \/ /   | |   | |    | '_ \| '__| / __| __| '_ ` _ \ / _` / __|
 | | | |  | |  \  /    | |   | |____| | | | |  | \__ \ |_| | | | | | (_| \__ \
 | |_|_|  |_|   \/    _| |    \_____|_| |_|_|  |_|___/\__|_| |_| |_|\__,_|___/
 |___|               |___|______
                         |______|

Free to use on the following conditions:

	*Do not re-release edited versions without my permision
	*Do not and NEVER clame this as your own, not even an edit!
	*Say thanks on the sa-mp forums if you like ;)
	*Suggest more christmas songs on the topic


----------------UPDATES:--------------------------------------------------------
- Edited christmas songs urls
- Edited several parts in scripts
- Support for incognito's streamer added
*/

#define using_streamer
/*
	Are you using incognito's streamer ? Then you may uncomment this line.
	If you aren't using any streamer then comment this line.
*/

#define SF false

/*
IMPORTANT: When "true" this FS uses 568 objects ! BE CAREFULL IF YOU DON'T HAVE AN OBJECT STREAMER
-> If you add something and you still don't want to use a streamer
type in the rcon console "count" - It prints the total objects in the server. (MAX_OBJECTS = 1000)
*/


#include <a_samp>
#include <sscanf2>
#include <zcmd>
#include <xFireworks>
#if defined using_streamer
	#include <streamer>
	#define CreateObject CreateDynamicObject
#endif

#define Loop(%0,%1) for(new %0 = 0; %0 < %1; %0++)
#define LoopEx(%0,%1,%2) for(new %0 = %1; %0 < %2; %0++)

//------------------------------------------------------------------------------
#define COLOR_INVISIBLE 	0xFFFFFF00
#define COLOR_WHITE 		0xFFFFFFFF
#define COLOR_BLACK 		0x000000FF
#define COLOR_BLUE 			0x0000DDFF
#define COLOR_RED 			0xAA3333AA
#define COLOR_GREEN 		0x00FF00FF
#define COLOR_PURPLE 		0xC2A2DAAA
#define COLOR_YELLOW 		0xFFFF00AA
#define COLOR_YELLOWORANGE 	0xE8D600FF
#define COLOR_GREY 			0xAFAFAFAA
#define COLOR_ORANGE 		0xFF5F11FF
#define ORANGE 				0xF4B906FF
#define COLOR_BROWN 		0x804000FF
#define COLOR_CYAN 			0x00FFFFFF
#define COLOR_LIGHTBLUE 	0x33CCFFAA
#define COLOR_PINK 			0xFF80C0FF
//-------------------------------DIALOG IDS-------------------------------------
#define DIALOG_CHRISTMASMUSIC 		1113
#define DIALOG_CHRISTMASMUSICALL    1114
#define DIALOG_CHRISTMAS        	1112
#define DIALOG_CHRISTMASFW      	1110
//-----------------------SNOWBALL MINIGAME BY ShOoBy----------------------------
#define KEY_AIM (128)

new bool:Snow_F[MAX_PLAYERS];
new Obj[MAX_PLAYERS];
new bool:Shoot[MAX_PLAYERS];
new Killer[MAX_PLAYERS];
new bool:Charged[MAX_PLAYERS];
//------------------------FW by Martok------------------------------------------
new explosions[] = {0,2,4,5,6,7,8,9,10,13};

enum t_fwbattery {
    inuse,
    timer,
    count,
    Float:height,
    hvar,
    Float:windspeed,
    Float:interval,
    Float:pos[3],
    machine
};

new batteries[50][t_fwbattery];
//----------------------NEW YEAR COUNTDOWN by Meta------------------------------
new cTime;
new Text:NYCounter, Text:HappyNewYearText;
//--------------------SNOWMAN TEXTDRAW by Zh3r0---------------------------------
#define COL_ORANGE         "{FFAF00}"
#define COL_GREEN          "{6EF83C}"
#define COL_RED            "{FF4040}"
#define COL_BLUE           "{0285FF}"
#define COL_YELLOW         "{FFEA02}"
#define COL_EASY           "{FFF1AF}"


forward  LoadTextdraws();
forward  AddMouthOptions();
forward  AddEyesOptions();
forward  Animate();
forward  DestroyTextdraws();
forward  HideLogo(playerid);
forward  ShowLogo(playerid);


new

	Text:Textdraw100,	  Text:Textdraw101,   Text:Textdraw102,
    Text:Textdraw103,	  Text:Textdraw104,   Text:Textdraw105,
    Text:Textdraw106,	  Text:Textdraw107,   Text:Textdraw108,
    Text:Textdraw109,	  Text:Textdraw110,  Text:Textdraw111,
    Text:Textdraw112,  Text:Textdraw113,  Text:Textdraw114,
    Text:Textdraw115,  Text:Textdraw116,  Text:Textdraw117,
    Text:Textdraw119,  Text:Textdraw120,

    Float:TheX = 508.000000,
	Float:BoxY = 0.499999,
	gDirection,
	gCount,
	bool:pLogo[ MAX_PLAYERS ]

;

//-------SNOW by Michael@Belgium (and released on sa:mp forums by kwarde)-------

#define MAX_SNOW_OBJECTS    5 // recommended - If you have more you might need a object streamer
#define UPDATE_INTERVAL     1000

new bool:snowOn[MAX_PLAYERS char],
        snowObject[MAX_PLAYERS][MAX_SNOW_OBJECTS],
        updateTimer[MAX_PLAYERS char]
;
//------------------------------------------------------------------------------
#define MAX_XMASTREES 20 //recommended - If you have more you might need a object streamer

enum XmasTrees
{
	XmasTreeX,
    Float:XmasX,
    Float:XmasY,
    Float:XmasZ,
    XmasObject1,
    XmasObject2,
    XmasObject3,
    XmasObject4,
    XmasObject5,
    XmasObject6,
    XmasObject7,
    XmasObject8,
    XmasObject9,
    XmasObject10

};
new Treepos[MAX_XMASTREES][XmasTrees];

public OnFilterScriptInit()
{
	print("[MV]");
	print("  _____                  _");
	print(" / ____| |        (_)   | |");
	print("| |    | |__  _ __ _ ___| |_ _ __ ___   __ _ ___");
	print("| |    | '_ | '__| / __| __| '_ ` _  / _` / __|");
	print("| |____| | | | |  | |__  |_| | | | | | (_| |__");
	print("|______|_| |_|_|  |_|___/__|_| |_| |_| __,_|___/");
	print("");
	print("----------------- Version: 1.5 ----------------------");

	LoadMetasTextdraws();

 	SetTimer(  "Animate" , 300, true   );
	LoadTextdraws();

 	Loop(i,sizeof(batteries)) batteries[i][inuse] = false;

	//------------------snowball minigame----
	CreateObject(8172,-716.59997559,3800.50000000,8.50000000,0.00000000,0.00000000,90.00000000); //object(vgssairportland07) (1)
	CreateObject(3074,-782.29998779,3785.30004883,8.50000000,0.00000000,270.00000000,269.99948120); //object(d9_runway) (6)
	CreateObject(3074,-782.29998779,3798.89990234,8.50000000,0.00000000,270.00000000,269.99450684); //object(d9_runway) (7)
	CreateObject(3074,-782.29998779,3807.60009766,8.50000000,0.00000000,270.00000000,269.99450684); //object(d9_runway) (8)
	CreateObject(3074,-752.09997559,3807.60009766,8.50000000,0.00000000,270.00000000,269.99450684); //object(d9_runway) (9)
	CreateObject(3074,-722.00000000,3807.50000000,8.50000000,0.00000000,270.00000000,269.99450684); //object(d9_runway) (10)
	CreateObject(3074,-691.79998779,3807.50000000,8.50000000,0.00000000,270.00000000,269.99450684); //object(d9_runway) (11)
	CreateObject(3074,-661.59997559,3807.50000000,8.50000000,0.00000000,270.00000000,269.99450684); //object(d9_runway) (12)
	CreateObject(3074,-753.79998779,3795.19995117,8.60000038,0.00000000,270.00000000,269.99450684); //object(d9_runway) (14)
	CreateObject(3074,-723.59997559,3795.10009766,8.60000038,0.00000000,270.00000000,269.99450684); //object(d9_runway) (15)
	CreateObject(3074,-693.40002441,3794.89990234,8.60000038,0.00000000,270.00000000,269.99450684); //object(d9_runway) (16)
	CreateObject(3074,-664.09997559,3794.69995117,8.60000038,0.00000000,270.00000000,269.99450684); //object(d9_runway) (17)
	CreateObject(3074,-664.29998779,3781.69995117,8.69999981,0.00000000,270.00000000,269.99450684); //object(d9_runway) (18)
	CreateObject(3074,-694.50000000,3781.80004883,8.69999981,0.00000000,270.00000000,269.99450684); //object(d9_runway) (19)
	CreateObject(3074,-724.40002441,3781.89990234,8.69999981,0.00000000,270.00000000,269.99450684); //object(d9_runway) (20)
	CreateObject(3074,-754.40002441,3782.00000000,8.69999981,0.00000000,270.00000000,269.99450684); //object(d9_runway) (21)
	CreateObject(8172,-796.79998779,3800.50000000,-48.00000000,90.00000000,0.00000000,90.00000000); //object(vgssairportland07) (2)
	CreateObject(8172,-650.20001221,3800.50000000,-48.00000000,90.00000000,180.00000000,90.00000000); //object(vgssairportland07) (3)
	CreateObject(8172,-729.09997559,3780.69995117,12.80000019,0.00000000,270.00000000,270.00000000); //object(vgssairportland07) (4)
	CreateObject(8172,-726.20001221,3820.19995117,12.80000019,0.00000000,270.00000000,90.00000000); //object(vgssairportland07) (5)


	//------------SF christmas trees---------
	#if SF == true
	CreateChristmasTree(2,-1549.0511,585.0486,7.1797);
	CreateChristmasTree(1,-1548.4778,646.2723,7.1875);
	CreateChristmasTree(2,-1568.5579,828.9424,7.1875);
	CreateChristmasTree(1,-1991.4308,89.8115,27.6799);
	CreateChristmasTree(2,-1992.0767,205.6595,27.6875);
	CreateChristmasTree(1,-2633.8052,607.2700,14.4531);
	CreateChristmasTree(2,-2675.2756,607.2688,14.4545);
	CreateChristmasTree(1,-2600.0955,1384.2037,7.1607);
	CreateChristmasTree(2,-2608.5371,1348.2877,7.1953);

	//----------------------SF big christmas tree with objects around-------------------
	CreateObject(664,-2707.30761719,376.57815552,3.96888542,0.00000000,0.00000000,44.00000000);
	CreateObject(664,-2706.46826172,375.02407837,3.96923542,0.00000000,0.00000000,349.99475098);
	CreateObject(664,-2707.12426758,379.04116821,3.96928978,0.00000000,0.00000000,97.99145508);
	CreateObject(2486,-2708.43017578,373.17453003,4.97945309,0.00000000,0.00000000,354.00000000);
	CreateObject(2485,-2709.13354492,374.46206665,4.97945309,0.00000000,0.00000000,0.00000000);
	CreateObject(2484,-2707.38378906,372.33828735,4.80856562,0.00000000,0.00000000,0.00000000);
	CreateObject(2454,-2702.79663086,375.01049805,3.97252083,0.00000000,0.00000000,0.00000000);
	CreateObject(2454,-2702.54785156,377.06506348,3.96868849,0.00000000,0.00000000,89.99548340);
	CreateObject(2454,-2709.84130859,378.29168701,3.96876383,0.00000000,0.00000000,205.99450684);
	CreateObject(14870,-2706.71582031,373.61630249,11.54687119,0.00000000,0.00000000,0.00000000);
	CreateObject(14870,-2704.56494141,373.26446533,24.75610924,0.00000000,0.00000000,296.00000000);
	CreateObject(14870,-2705.25488281,373.35855103,15.12049675,0.00000000,0.00000000,17.99914551);
	CreateObject(14870,-2706.72265625,364.66778564,24.47894669,0.00000000,0.00000000,215.99560547);
	CreateObject(14870,-2707.57861328,381.17886353,19.09156799,0.00000000,0.00000000,155.99121094);
	CreateObject(14870,-2704.77075195,377.04089355,20.49364662,0.00000000,0.00000000,155.98937988);
	CreateObject(3877,-2707.77490234,373.80313110,16.76913071,271.00000000,0.00000000,152.00000000);
	CreateObject(3877,-2708.58154297,379.04061890,15.68122482,270.99975586,0.00000000,107.99584961);
	CreateObject(3877,-2707.08251953,381.24850464,16.50436783,270.99426270,0.00000000,21.99560547);
	CreateObject(3877,-2704.91479492,376.21548462,17.06835556,270.99426270,0.00000000,291.99462891);
	CreateObject(3877,-2704.30419922,374.74246216,15.31949806,270.99426270,0.00000000,235.99462891);
	CreateObject(3877,-2706.62670898,373.60058594,19.21698761,270.99426270,0.00000000,181.99182129);
	CreateObject(3877,-2706.60522461,373.59677124,25.51964188,270.99426270,0.00000000,181.98852539);
	CreateObject(3877,-2708.80078125,376.48785400,25.34601974,270.99426270,0.00000000,143.98852539);
	CreateObject(3877,-2708.76245117,380.32965088,22.49613190,270.99426270,0.00000000,49.98681641);
	CreateObject(3877,-2705.79125977,379.82800293,20.90824699,270.99426270,0.00000000,283.98229980);
	CreateObject(3534,-2714.23632812,378.60433960,15.30849075,0.00000000,0.00000000,0.00000000);
	CreateObject(3534,-2707.74877930,375.39852905,16.67776489,0.00000000,0.00000000,0.00000000);
	CreateObject(3534,-2704.40332031,378.12808228,11.28053474,0.00000000,0.00000000,0.00000000);
	CreateObject(3534,-2708.10400391,381.10507202,12.84053516,0.00000000,0.00000000,0.00000000);
	CreateObject(3534,-2707.80346680,375.45501709,14.76138401,0.00000000,0.00000000,0.00000000);
	CreateObject(3534,-2708.46166992,378.18728638,12.28053474,0.00000000,0.00000000,0.00000000);
	CreateObject(3472,-2707.83056641,373.84539795,18.48528862,0.00000000,0.00000000,0.00000000);
	CreateObject(3472,-2707.92895508,375.27389526,15.86812496,0.00000000,0.00000000,0.00000000);
	CreateObject(3472,-2708.50781250,378.51614380,17.39788818,0.00000000,0.00000000,0.00000000);
	CreateObject(3472,-2706.96020508,381.26565552,24.25031090,13.00000000,194.00000000,314.00000000);
	CreateObject(3472,-2705.07421875,376.74777222,30.69754219,12.99682617,193.99658203,257.99475098);
	CreateObject(3534,-2713.55468750,363.66510010,21.78607178,0.00000000,0.00000000,0.00000000);
	CreateObject(3534,-2705.38818359,358.29653931,20.97453690,0.00000000,0.00000000,0.00000000);
	CreateObject(3534,-2693.00292969,367.05838013,19.85726357,0.00000000,0.00000000,0.00000000);
	CreateObject(3534,-2702.90283203,383.85583496,20.11940193,0.00000000,0.00000000,0.00000000);
	CreateObject(3534,-2699.66821289,383.50790405,15.66015148,0.00000000,0.00000000,0.00000000);
	CreateObject(3534,-2698.00952148,380.52221680,16.66557312,0.00000000,0.00000000,0.00000000);
	CreateObject(3534,-2701.49658203,375.21389771,17.21406555,0.00000000,0.00000000,0.00000000);
	CreateObject(3534,-2713.64453125,370.86132812,18.92479324,0.00000000,0.00000000,0.00000000);
	CreateObject(3472,-2708.59521484,379.13803101,30.03047752,13.00000000,194.00000000,0.00000000);
	CreateObject(3472,-2708.01733398,375.67639160,25.94305611,12.99682617,193.99658203,96.00000000);
	CreateObject(3534,-2720.61157227,384.60675049,22.78135681,0.00000000,0.00000000,0.00000000);
	CreateObject(3534,-2715.02368164,385.54934692,20.23530579,0.00000000,0.00000000,0.00000000);
	CreateObject(3534,-2718.37109375,377.79827881,19.75296783,0.00000000,0.00000000,0.00000000);
	CreateObject(3534,-2725.89916992,375.05877686,21.18688011,0.00000000,0.00000000,0.00000000);
	CreateObject(3534,-2698.17187500,373.01635742,15.73170090,0.00000000,0.00000000,0.00000000);
	CreateObject(3534,-2701.84106445,368.41925049,17.12574768,0.00000000,0.00000000,0.00000000);
	CreateObject(3472,-2705.81225586,373.45687866,22.08354568,0.00000000,0.00000000,0.00000000);
	CreateObject(3472,-2709.46386719,374.91137695,25.64812851,13.00000000,194.00000000,68.00000000);
	CreateObject(3472,-2708.39379883,381.06442261,21.48554802,0.00000000,0.00000000,0.00000000);
	CreateObject(3472,-2705.72656250,379.36645508,23.78524208,13.00000000,194.00000000,216.00000000);
	CreateObject(3472,-2705.59863281,373.21707153,24.72511101,12.99682617,193.99658203,183.99670410);
	CreateObject(3472,-2708.55273438,378.83599854,27.33802032,12.99682617,193.99108887,77.99353027);
	CreateObject(3472,-2707.00610352,381.25921631,28.51313019,12.99682617,193.99108887,283.99194336);
	CreateObject(3534,-2704.69604492,384.71276855,16.07434654,0.00000000,0.00000000,0.00000000);
	CreateObject(3534,-2708.01049805,365.46545410,20.03053093,0.00000000,0.00000000,0.00000000);
	CreateObject(3534,-2699.31030273,365.08697510,21.65671539,0.00000000,0.00000000,0.00000000);
	CreateObject(3534,-2711.09155273,367.46783447,25.64758110,0.00000000,0.00000000,0.00000000);
	CreateObject(3472,-2708.09887695,373.47668457,32.40806961,12.99682617,193.99658203,103.99987793);
	CreateObject(3472,-2705.20361328,373.34951782,32.51392365,12.99682617,193.99108887,155.99658203);
	CreateObject(3472,-2701.80981445,378.32183838,26.66471672,12.99682617,193.99108887,229.99487305);
	CreateObject(3038,-2706.46289062,373.57168579,10.39013863,99.00000000,0.00000000,48.00000000);
	CreateObject(3038,-2704.14379883,375.65164185,7.62436914,98.99783325,0.00000000,165.99926758);
	CreateObject(3038,-2705.21508789,377.54974365,11.81369305,98.99780273,0.00000000,183.99792480);
	CreateObject(3038,-2705.92187500,380.75765991,11.07896423,98.99780273,0.00000000,189.99353027);
	CreateObject(3038,-2708.19018555,381.09298706,7.86560822,98.99780273,0.00000000,223.99206543);
	CreateObject(3038,-2708.62670898,379.36236572,7.49907446,98.99780273,0.00000000,179.98925781);
	CreateObject(3038,-2708.48266602,377.44958496,13.01852798,98.99780273,0.00000000,179.98901367);
	CreateObject(3038,-2706.24975586,373.53408813,7.27033615,98.99780273,0.00000000,179.98901367);
	CreateObject(970,-2710.69140625,371.59402466,3.94076157,0.00000000,0.00000000,314.00000000);
	CreateObject(970,-2706.46606445,370.02069092,3.93623304,0.00000000,0.00000000,359.99475098);
	CreateObject(970,-2701.73046875,371.75238037,3.94078469,0.00000000,0.00000000,43.99450684);
	CreateObject(970,-2701.80297852,380.86795044,3.92647910,0.00000000,0.00000000,137.98925781);
	CreateObject(970,-2703.66650391,376.11059570,4.60033703,275.00000000,0.00000000,87.98449707);
	CreateObject(970,-2706.29931641,382.41464233,3.91866851,0.00000000,0.00000000,179.98376465);
	CreateObject(970,-2710.92382812,380.47610474,3.91866851,0.00000000,0.00000000,223.98352051);
	CreateObject(970,-2712.72534180,376.12063599,3.92792559,0.00000000,0.00000000,269.97827148);
	CreateObject(3877,-2712.58178711,378.66693115,5.03292847,0.00000000,0.00000000,0.00000000);
	CreateObject(3877,-2712.51611328,373.55255127,5.05479240,0.00000000,0.00000000,0.00000000);
	CreateObject(3877,-2708.97583008,370.20312500,5.04991341,0.00000000,0.00000000,0.00000000);
	CreateObject(3877,-2703.76489258,370.20312500,5.04991341,0.00000000,0.00000000,0.00000000);
	CreateObject(3877,-2700.09375000,373.60821533,5.04971313,0.00000000,0.00000000,0.00000000);
	CreateObject(3877,-2700.02294922,379.27618408,5.04073906,0.00000000,0.00000000,0.00000000);
	CreateObject(3877,-2703.79223633,382.11779785,5.03292847,0.00000000,0.00000000,0.00000000);
	CreateObject(3877,-2708.85937500,382.00000000,5.03292847,0.00000000,0.00000000,0.00000000);
	CreateObject(2124,-2703.68579102,376.19537354,5.58674717,0.00000000,0.00000000,178.00000000);
	CreateObject(1472,-2703.39843750,376.12493896,3.99562263,0.00000000,0.00000000,90.00000000);
	CreateObject(1577,-2703.58471680,378.94894409,4.16833305,0.00000000,0.00000000,0.00000000);
	CreateObject(2710,-2702.46582031,376.82360840,5.10903502,0.00000000,0.00000000,0.00000000);
	CreateObject(2057,-2704.42260742,379.12969971,5.14990664,0.00000000,0.00000000,336.00000000);
	CreateObject(2035,-2702.76123047,375.29367065,5.01246452,0.00000000,0.00000000,0.00000000);
	CreateObject(1654,-2703.45800781,378.24755859,5.53104591,0.00000000,0.00000000,0.00000000);
	CreateObject(1579,-2702.21606445,374.08361816,4.37533331,0.00000000,0.00000000,0.00000000);
	CreateObject(3522,-2699.57617188,376.09201050,3.45473099,0.00000000,0.00000000,0.00000000);
	CreateObject(2057,-2703.59228516,374.04187012,5.14990664,0.00000000,0.00000000,335.99487305);
	CreateObject(1577,-2702.17285156,374.61962891,4.38290453,0.00000000,0.00000000,0.00000000);
	CreateObject(1827,-2702.13793945,374.12081909,3.97474098,0.00000000,0.00000000,0.00000000);
	CreateObject(1954,-2701.78198242,373.78027344,4.69306993,0.00000000,0.00000000,46.00000000);
	CreateObject(2484,-2702.41088867,378.17538452,4.69339085,0.00000000,0.00000000,90.00000000);
	CreateObject(2484,-2704.55395508,376.18743896,6.87564707,0.00000000,0.00000000,90.00000000);
	CreateObject(2484,-2709.94458008,374.98107910,4.80514002,0.00000000,0.00000000,116.00000000);
	CreateObject(2485,-2702.60839844,377.15664673,5.00863266,0.00000000,0.00000000,126.00000000);
	CreateObject(2464,-2701.64501953,375.14590454,4.11610460,0.00000000,0.00000000,290.00000000);
	CreateObject(2464,-2701.89282227,377.39620972,4.11152649,0.00000000,0.00000000,257.99511719);
	CreateObject(2464,-2703.32958984,379.53802490,4.10850334,0.00000000,0.00000000,309.99194336);
	CreateObject(2464,-2709.75537109,378.10208130,5.15171289,0.00000000,0.00000000,63.99023438);
	CreateObject(2464,-2710.69531250,375.15093994,4.11727858,0.00000000,0.00000000,91.98986816);
	CreateObject(2464,-2708.88745117,372.80325317,4.11450672,0.00000000,0.00000000,105.98852539);
	CreateObject(2464,-2703.42065430,372.72836304,4.11189795,0.00000000,0.00000000,219.98510742);
	CreateObject(2466,-2705.27709961,377.61380005,6.06908226,0.00000000,0.00000000,94.00000000);
	CreateObject(2466,-2701.61425781,374.35293579,4.55010271,0.00000000,0.00000000,117.99902344);
	CreateObject(2477,-2702.24511719,378.58636475,4.41969681,0.00000000,0.00000000,84.00000000);
	CreateObject(2477,-2705.17846680,371.86395264,4.53150940,0.00000000,0.00000000,1.99597168);
	CreateObject(2477,-2710.75488281,376.70098877,4.53381872,0.00000000,0.00000000,275.99401855);
	CreateObject(970,-2697.26513672,373.62747192,3.93238306,0.00000000,0.00000000,2.00000000);
	CreateObject(970,-2697.31054688,379.07852173,3.92647910,0.00000000,0.00000000,359.99902344);
	CreateObject(970,-2692.37377930,373.79226685,3.92839718,0.00000000,0.00000000,359.99450684);
	CreateObject(970,-2692.45971680,379.13003540,3.91866851,0.00000000,0.00000000,359.99450684);
	CreateObject(3877,-2694.81933594,373.61663818,5.04487801,0.00000000,0.00000000,0.00000000);
	CreateObject(3877,-2695.22143555,379.01626587,5.03292847,0.00000000,0.00000000,0.00000000);
	CreateObject(3877,-2690.27124023,373.53881836,5.04664612,0.00000000,0.00000000,0.00000000);
	CreateObject(3877,-2690.11132812,379.28613281,5.04073906,0.00000000,0.00000000,0.00000000);
//-----------------------ANOTHER CHRISTMAS TREE -------------------------------------------------------
	CreateObject(664, -1998.0460205078, 148.79306030273, 25.906070709229, 0, 0, 340);
	CreateObject(664, -1998.0458984375, 148.79296875, 25.906070709229, 0, 0, 325.99938964844);
	CreateObject(664, -1998.0458984375, 148.79296875, 25.906070709229, 0, 0, 303.99731445313);
	CreateObject(664, -1998.0458984375, 148.79296875, 25.906070709229, 0, 0, 287.99719238281);
	CreateObject(3472, -1997.1529541016, 148.4162902832, 32.6875, 0, 0, 0);
	CreateObject(3472, -1997.15234375, 148.416015625, 36.607498168945, 0, 0, 0);
	CreateObject(3472, -1997.15234375, 148.416015625, 44.357498168945, 0, 0, 0);
	CreateObject(3472, -1997.4702148438, 148.65103149414, 55.107498168945, 0, 0, 0);
	CreateObject(3472, -1998.1090087891, 148.44111633301, 50.607498168945, 40, 0, 0);
	CreateObject(3472, -2001.8745117188, 148.5101776123, 47.607498168945, 39.995727539063, 0, 90);
	CreateObject(3472, -2000.2878417969, 145.7417755127, 50.607498168945, 39.995727539063, 0, 170);
	CreateObject(3472, -1996.1226806641, 149.14767456055, 44.607498168945, 39.995727539063, 0, 277.99694824219);
	CreateObject(3472, -1996.2100830078, 149.05192565918, 41.607498168945, 39.995727539063, 0, 277.99255371094);
	CreateObject(3472, -2000.4672851563, 151.34553527832, 41.607498168945, 39.995727539063, 0, 39.992553710938);
	CreateObject(3472, -1999.8195800781, 147.89109802246, 41.607498168945, 39.995727539063, 0, 127.990234375);
	CreateObject(3472, -1998.1652832031, 147.17254638672, 41.607498168945, 39.995727539063, 0, 207.98522949219);
	CreateObject(3472, -1997.15234375, 148.416015625, 28.857498168945, 0, 0, 310);
	CreateObject(3515, -1998.8930664063, 144.0747833252, 27.581159591675, 0, 0, 0);
	CreateObject(3515, -1998.8284912109, 154.17958068848, 27.831155776978, 0, 0, 0);
	CreateObject(3534, -1998.560546875, 141.37292480469, 48.970138549805, 28, 0, 352);
	CreateObject(3534, -1993.6901855469, 142.69296264648, 48.970138549805, 27.998657226563, 0, 29.996459960938);
	CreateObject(3534, -1991.8308105469, 148.89370727539, 48.970138549805, 27.998657226563, 0, 85.99267578125);
	CreateObject(3534, -1995.1551513672, 155.28498840332, 48.970138549805, 27.998657226563, 0, 123.98999023438);
	CreateObject(3534, -1999.73828125, 155.6160736084, 48.970138549805, 27.998657226563, 0, 159.98620605469);
	CreateObject(3534, -2004.7911376953, 149.40711975098, 48.970138549805, 27.998657226563, 0, 215.98291015625);
	CreateObject(3534, -2002.8659667969, 144.27090454102, 48.970138549805, 27.998657226563, 0, 277.98022460938);
	CreateObject(3534, -2001.7861328125, 145.97839355469, 56.220138549805, 27.998657226563, 0, 291.97607421875);
	CreateObject(3534, -2001.3598632813, 150.37046813965, 56.220138549805, 27.998657226563, 0, 253.97265625);
	CreateObject(3534, -1997.0113525391, 150.35415649414, 55.470138549805, 27.998657226563, 0, 177.97094726563);
	CreateObject(3534, -1995.1121826172, 147.66877746582, 55.470138549805, 27.998657226563, 0, 161.96752929688);
	CreateObject(3534, -1997.7120361328, 144.8631439209, 56.220138549805, 27.998657226563, 0, 3.97265625);
	CreateObject(3534, -2000.2390136719, 144.6975402832, 40.745124816895, 356.92108154297, 167.98248291016, 24.167358398438);
	CreateObject(3534, -2002.3602294922, 147.19053649902, 40.745124816895, 356.91833496094, 167.98095703125, 24.164428710938);
	CreateObject(3534, -2002.7614746094, 150.74235534668, 40.745124816895, 356.91833496094, 167.98095703125, 24.164428710938);
	CreateObject(3534, -2001.1950683594, 153.51251220703, 40.745124816895, 356.91833496094, 167.98095703125, 24.164428710938);
	CreateObject(3534, -1999.08984375, 154.86074829102, 40.745124816895, 356.91833496094, 167.98095703125, 24.164428710938);
	CreateObject(3534, -1994.4105224609, 155.89538574219, 40.745124816895, 356.91833496094, 167.98095703125, 24.164428710938);
	CreateObject(3534, -1990.2229003906, 153.66470336914, 40.745124816895, 356.91833496094, 167.98095703125, 24.164428710938);
	CreateObject(3534, -1989.1068115234, 150.2596282959, 40.745124816895, 356.91833496094, 167.98095703125, 24.164428710938);
	CreateObject(3534, -1990.0328369141, 144.34252929688, 40.745124816895, 356.91833496094, 167.98095703125, 24.164428710938);
	CreateObject(3534, -1992.7410888672, 140.88737487793, 40.745124816895, 356.91833496094, 167.98095703125, 24.164428710938);
	CreateObject(3534, -1996.2249755859, 139.30950927734, 40.745124816895, 356.91833496094, 167.98095703125, 24.164428710938);
	CreateObject(7666, -1998.1800537109, 148.45513916016, 74.819854736328, 0, 0, 0);
	CreateObject(7666, -1998.1796875, 148.455078125, 74.819854736328, 0, 0, 280);
	CreateObject(3472, -1997.4697265625, 148.650390625, 60.357498168945, 0, 0, 0);

//--------------------------------------SF circuslamposts----------------------------------------
	CreateChristmasLights(-1293.96105957,471.57125854,6.18750000);
	CreateChristmasLights(-1260.64416504,444.49423218,6.18750000);
	CreateChristmasLights(-1229.65881348,453.10644531,6.18750000);
	CreateChristmasLights(-1373.04516602,475.83438110,6.18750000);
	CreateChristmasLights(-1478.45825195,460.13754272,6.18750000);
	CreateChristmasLights(-1529.34753418,515.56933594,6.17968750);
	CreateChristmasLights(-1567.61364746,549.51361084,6.17968750);
	CreateChristmasLights(-1524.52832031,660.17004395,7.41608429);
	CreateChristmasLights(-1499.36853027,776.62878418,6.18531609);
	CreateChristmasLights(-1550.60546875,781.25585938,6.26562500);
	CreateChristmasLights(-1520.44885254,815.79431152,6.18750000);
	CreateChristmasLights(-1581.40991211,822.94024658,6.18750000);
	CreateChristmasLights(-1546.51574707,913.64306641,6.03906250);
	CreateChristmasLights(-1518.42053223,982.31994629,6.18750000);
	CreateChristmasLights(-1550.61291504,961.41210938,6.26562500);
	CreateChristmasLights(-1579.41711426,998.09582520,6.26562500);
	CreateChristmasLights(-1562.93664551,1053.31579590,6.18750000);
	CreateChristmasLights(-1592.88037109,1104.89196777,6.18750000);
	CreateChristmasLights(-1709.11193848,623.88732910,23.89062500);
	CreateChristmasLights(-1724.10241699,740.69903564,23.89062500);
	CreateChristmasLights(-1660.48291016,742.40258789,16.72198486);
	CreateChristmasLights(-1651.47204590,723.47357178,15.10015297);
	CreateChristmasLights(-1615.34167480,737.95001221,12.58959675);
	CreateChristmasLights(-1607.08288574,723.17523193,11.25325871);
	CreateChristmasLights(-1624.35449219,825.00469971,6.38964462);
	CreateChristmasLights(-1966.59936523,1295.37219238,6.18750000);
	CreateChristmasLights(-1967.86145020,1330.51306152,6.18750000);
	CreateChristmasLights(-2032.22045898,1324.98010254,6.27741623);
	CreateChristmasLights(-2059.11791992,1295.58276367,6.33593750);
	CreateChristmasLights(-2077.17700195,1257.81030273,11.29933167);
	CreateChristmasLights(-2089.61059570,1337.08764648,7.75382042);
	CreateChristmasLights(-2134.23706055,1320.89282227,6.18750000);
	CreateChristmasLights(-2173.73852539,1340.86975098,7.54163265);
	CreateChristmasLights(-2205.13208008,1321.81726074,6.18750000);
	CreateChristmasLights(-2249.03027344,1341.90502930,6.18750000);
	CreateChristmasLights(-2340.65991211,1363.66772461,6.27034760);
	CreateChristmasLights(-2613.32861328,1407.99890137,6.14962482);
	CreateChristmasLights(-2658.95239258,1281.64196777,6.18750048);
	CreateChristmasLights(-2694.06298828,1298.85168457,6.18109035);
	CreateChristmasLights(-2740.91113281,1280.98754883,5.82114124);
	CreateChristmasLights(-2768.25146484,1303.40466309,5.25621080);
	CreateChristmasLights(-2813.50683594,1275.10961914,4.72656250);
	CreateChristmasLights(-2634.42016602,607.13775635,13.45312500);
	CreateChristmasLights(-2697.69799805,619.00164795,13.45312500);
	CreateChristmasLights(-2700.64990234,582.93231201,14.81543350);
	CreateChristmasLights(-2700.76367188,410.51034546,3.36718750);
	CreateChristmasLights(-2721.14721680,411.87704468,3.17631340);
	CreateChristmasLights(-2698.97534180,343.98141479,3.41406250);
	CreateChristmasLights(-2713.60205078,342.31127930,3.41406250);
	CreateChristmasLights(-2705.25708008,289.91201782,3.28906250);
	CreateChristmasLights(-2066.05908203,69.35791016,27.39062500);
	CreateChristmasLights(-2051.78149414,116.07773590,28.08853531);
	CreateChristmasLights(-2022.22412109,116.58210754,26.92206764);
	CreateChristmasLights(-1972.75964355,332.83102417,33.53115845);
	CreateChristmasLights(-1985.43359375,437.95660400,34.17187500);
	CreateChristmasLights(-1985.44323730,437.71679688,34.28994370);
	CreateChristmasLights(-1917.57788086,584.41796875,34.22170639);
	CreateChristmasLights(-1911.19750977,723.03210449,44.44531250);
	CreateChristmasLights(-2035.43908691,713.39001465,51.75196457);
	CreateChristmasLights(-2024.85827637,679.72918701,47.81198883);
	CreateChristmasLights(-1983.20715332,880.57531738,44.20312500);
	CreateChristmasLights(-1912.47937012,876.44409180,34.24229050);
	CreateChristmasLights(-2015.01782227,584.51171875,34.17187500);
	CreateChristmasLights(-1958.47534180,596.22546387,34.17187500);
	CreateChristmasLights(-2029.48034668,496.16537476,34.17187500);
	CreateChristmasLights(-2127.29736328,497.09268188,34.17187500);
	CreateChristmasLights(-2244.83691406,532.76287842,34.14505005);
	CreateChristmasLights(-2261.08129883,746.97790527,48.29687500);
	#endif
	return true;
}

stock CountObjects()
{
	new o_count;
	#if defined using_streamer
	o_count = CountDynamicObjects();
	#else
	Loop(i,MAX_OBJECTS)	if(IsValidObject(i)) o_count++;
	#endif

	return o_count;
}

public OnRconCommand(cmd[])
{
	if(!strcmp("count",cmd,false))
	{
		printf("Objects used: %i",CountObjects());
	}
	return 1;
}

/*CMD:tele(playerid,params[])
{
	new Float:x, Float:y,Float:z;
	if(sscanf(params,"fff",x,y,z)) return 0;
	SetPlayerPos(playerid,x,y,z);
	return 1;
}

CMD:spawn(playerid,params[])
{
    new id,Float:x, Float:y,Float:z;
	if(sscanf(params,"i",id)) return 0;
	GetPlayerPos(playerid,x,y,z);
	CreateObject(id,x+5,y,z,0,0,0);
	return 1;
}*/

public OnFilterScriptExit()
{
	TextDrawDestroy(NYCounter);
    TextDrawDestroy(HappyNewYearText);
    KillTimer(cTime);
	//---------------
	DestroyTextdraws();
	//---------------
 	Loop(i,MAX_PLAYERS)
	{
	    if(IsPlayerConnected(i))
	    {
	    	if(snowOn{i})
	        {
				Loop(j,MAX_SNOW_OBJECTS) DestroyObject(snowObject[i][j]);
	            KillTimer(updateTimer{i});
	        }
        }
 	}
 	//---------------
 	for (new i=0;i<sizeof(batteries);i++) {
	   DestroyObject(batteries[i][machine]);
    }
	return 1;
}
public OnPlayerDisconnect(playerid,reason)
{
	if(snowOn{playerid})
    {
    	Loop(i,MAX_SNOW_OBJECTS) DestroyObject(snowObject[playerid][i]);
        snowOn{playerid} = false;
        KillTimer(updateTimer{playerid});
    }
	return 1;
}

public OnPlayerConnect(  playerid  )
{
	SendClientMessage(playerid,COLOR_YELLOW,"This server uses [MV]_Christmas, cmds: /christmas");

	new year, month, day, hour, minute, second;
    getdate(year, month, day);
    gettime(hour, minute, second);
    if(day == 1 && month == 1 && (second > 0 || hour > 0)) TextDrawShowForPlayer(playerid, HappyNewYearText);

	Snow_F[playerid] = false;
	Killer[playerid] = 501;
	Charged[playerid] = false;
	Shoot[playerid] = false;

    return 1;
}
public OnPlayerSpawn(playerid)
{
  	SendClientMessage(playerid,COLOR_YELLOW,"This server uses [MV]_Christmas, cmds: /christmas");
	pLogo[ playerid ] = true ;
	ShowLogo(playerid);
    GiveChristmasHat(playerid,2);
    CreateSnow(playerid);

    DestroyObject(Obj[playerid]);
    if(Killer[playerid] != 501)
	{
		Shoot[Killer[playerid]] = false;
		Killer[playerid] = 501;
    }
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
  	if(Snow_F[playerid] == true) return Snow_F[playerid] = false;
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(Snow_F[playerid] == true)
	{
		if(Shoot[playerid] == false)
		{
			if(newkeys & KEY_AIM)
			{
				if(Charged[playerid] == true) return CheckSnow(playerid);
				else if(Charged[playerid] == false) return ApplyAnimation( playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0 ), Charged[playerid] = true;
			}
		}
	}
	return 1;
}

public Animate()
{
	switch(gDirection)
	{
		case 0:
		{
			gCount++;
			switch(gCount)
			{
				case 1:
				{
					TheX += 0.500;
					TextDrawDestroy(Text:Textdraw111 );
				    Textdraw111 = TextDrawCreate(TheX, 405.000000, "..");
				    gDirection = 0;
				    AddEyesOptions();
				}
				case 2:
				{
					TheX += 0.500;
					TextDrawDestroy(Text:Textdraw111 );
				    Textdraw111 = TextDrawCreate(TheX, 405.000000, "..");
				    gDirection = 0;
				    AddEyesOptions();
				}
				case 3:
				{
					TheX += 0.500;
					TextDrawDestroy(Text:Textdraw111 );
				    Textdraw111 = TextDrawCreate(TheX, 405.000000, "..");
				    gDirection = 0;
				    AddEyesOptions();
				}
				case 4:
				{
					TheX -= 0.500;
					TextDrawDestroy(Text:Textdraw111 );
				    Textdraw111 = TextDrawCreate(TheX, 405.000000, "..");
				    gDirection = 0;
				    AddEyesOptions();
				}
				case 5:
				{
					TheX -= 0.500;
					TextDrawDestroy(Text:Textdraw111 );
				    Textdraw111 = TextDrawCreate(TheX, 405.000000, "..");
				    gDirection = 0;
				    AddEyesOptions();
				}
				case 6:
				{
					TheX -= 0.500;
					TextDrawDestroy(Text:Textdraw111 );
				    Textdraw111 = TextDrawCreate(TheX, 405.000000, "..");
				    AddEyesOptions();
				    gDirection = 1;
				    gCount = 0;
				}
			}
			Loop(i,MAX_PLAYERS)	if ( pLogo[ i ] == true ) TextDrawShowForPlayer( i, Textdraw111);
		}

		case 1:
		{
			gCount++;
			switch(gCount)
			{
				case 1:
				{
					TheX += 0.500;
					TextDrawDestroy(Text:Textdraw111 );
				    Textdraw111 = TextDrawCreate(TheX, 405.000000, "..");
				    gDirection = 1;
				    AddEyesOptions();
				}
				case 2:
				{
					TheX += 0.500;
					TextDrawDestroy(Text:Textdraw111 );
				    Textdraw111 = TextDrawCreate(TheX, 405.000000, "..");
				    gDirection = 1;
				    AddEyesOptions();
				}
				case 3:
				{
					TheX += 0.500;
					TextDrawDestroy(Text:Textdraw111 );
				    Textdraw111 = TextDrawCreate(TheX, 405.000000, "..");
				    gDirection = 1;
				    AddEyesOptions();
				}
				case 4:
				{
					TheX -= 0.500;
					TextDrawDestroy(Text:Textdraw111 );
				    Textdraw111 = TextDrawCreate(TheX, 405.000000, "..");
				    gDirection = 1;
				    AddEyesOptions();
				}
				case 5:
				{
					TheX -= 0.500;
					TextDrawDestroy(Text:Textdraw111 );
				    Textdraw111 = TextDrawCreate(TheX, 405.000000, "..");
				    gDirection = 1;
				    AddEyesOptions();
				}
				case 6:
				{
					TheX -= 0.500;
					TextDrawDestroy(Text:Textdraw111 );
				    Textdraw111 = TextDrawCreate(TheX, 405.000000, "..");
				    AddEyesOptions();
				    gDirection = 2;
				    gCount = 0;
				}

			}
			Loop(i,MAX_PLAYERS ) if ( pLogo[ i ] == true )	TextDrawShowForPlayer( i, Textdraw111);
		}

		case 2:
		{
			gCount++;
			switch(gCount)
			{
				case 1:
				{
					BoxY += 0.050;
				    TextDrawLetterSize(Textdraw101,  2.099999,BoxY);
				    gDirection = 2;
				    AddMouthOptions();
				}
				case 2:
				{
					BoxY += 0.050;
				    TextDrawLetterSize(Textdraw101,  2.099999,BoxY);
				    gDirection = 2;
				    AddMouthOptions();
				}
				case 3:
				{
					BoxY -= 0.050;
				    TextDrawLetterSize(Textdraw101,  2.099999,BoxY);
				    gDirection = 2;
				    AddMouthOptions();
				}
				case 4:
				{
					BoxY -= 0.050;
				    TextDrawLetterSize(Textdraw101,  2.099999,BoxY);
				    gDirection = 2;
				    AddMouthOptions();
				}
				case 5:
				{
					BoxY += 0.050;
				    TextDrawLetterSize(Textdraw101,  2.099999,BoxY);
				    gDirection = 2;
				    AddMouthOptions();
				}
				case 6:
				{
					BoxY += 0.050;
				    TextDrawLetterSize(Textdraw101,  2.099999,BoxY);
				    gDirection = 2;
				    AddMouthOptions();
				}
				case 7:
				{
					BoxY -= 0.050;
				    TextDrawLetterSize(Textdraw101,  2.099999,BoxY);
				    gDirection = 2;
				    AddMouthOptions();
				}
				case 8:
				{
					BoxY-= 0.050;
				    TextDrawLetterSize(Textdraw101,  2.099999,BoxY);
				    AddMouthOptions();
				    gDirection = 0;
				    gCount = 0;
				}
			}
   			Loop(i,MAX_PLAYERS ) if ( pLogo[ i ] ==  true )	TextDrawShowForPlayer( i, Textdraw101);
		}
	}
}
public DestroyTextdraws()
{
	TextDrawHideForAll(Textdraw100);
	TextDrawDestroy(Textdraw100);
	TextDrawHideForAll(Textdraw101);
	TextDrawDestroy(Textdraw101);
	TextDrawHideForAll(Textdraw102);
	TextDrawDestroy(Textdraw102);
	TextDrawHideForAll(Textdraw103);
	TextDrawDestroy(Textdraw103);
	TextDrawHideForAll(Textdraw104);
	TextDrawDestroy(Textdraw104);
	TextDrawHideForAll(Textdraw105);
	TextDrawDestroy(Textdraw105);
	TextDrawHideForAll(Textdraw106);
	TextDrawDestroy(Textdraw106);
	TextDrawHideForAll(Textdraw107);
	TextDrawDestroy(Textdraw107);
	TextDrawHideForAll(Textdraw108);
	TextDrawDestroy(Textdraw108);
	TextDrawHideForAll(Textdraw109);
	TextDrawDestroy(Textdraw109);
	TextDrawHideForAll(Textdraw110);
	TextDrawDestroy(Textdraw110);
	TextDrawHideForAll(Textdraw111);
	TextDrawDestroy(Textdraw111);
	TextDrawHideForAll(Textdraw112);
	TextDrawDestroy(Textdraw112);
	TextDrawHideForAll(Textdraw113);
	TextDrawDestroy(Textdraw113);
	TextDrawHideForAll(Textdraw114);
	TextDrawDestroy(Textdraw114);
	TextDrawHideForAll(Textdraw115);
	TextDrawDestroy(Textdraw115);
	TextDrawHideForAll(Textdraw116);
	TextDrawDestroy(Textdraw116);
	TextDrawHideForAll(Textdraw117);
	TextDrawDestroy(Textdraw117);
	TextDrawHideForAll(Textdraw119);
	TextDrawDestroy(Textdraw119);
	TextDrawHideForAll(Textdraw120);
	TextDrawDestroy(Textdraw120);
}
public AddEyesOptions()
{
		TextDrawBackgroundColor(Textdraw111, 255);
		TextDrawFont(Textdraw111, 1);
		TextDrawLetterSize(Textdraw111, 0.400000, 1.500000);
		TextDrawColor(Textdraw111, 255);
		TextDrawSetOutline(Textdraw111, 0);
		TextDrawSetProportional(Textdraw111, 0);
		TextDrawSetShadow(Textdraw111, 0);
}
public AddMouthOptions()
{
		TextDrawBackgroundColor(Textdraw101, 255);
		TextDrawFont(Textdraw101, 1);
		TextDrawColor(Textdraw101, -1);
		TextDrawSetOutline(Textdraw101, 0);
		TextDrawSetProportional(Textdraw101, 1);
		TextDrawSetShadow(Textdraw101, 1);
		TextDrawUseBox(Textdraw101, 1);
		TextDrawBoxColor(Textdraw101, -1);
		TextDrawTextSize(Textdraw101, 504.000000, 0.000000);
}
public LoadTextdraws()
{
	Textdraw100 = TextDrawCreate(501.000000, 402.000000, "O");
	TextDrawBackgroundColor(Textdraw100, 255);
	TextDrawFont(Textdraw100, 1);
	TextDrawLetterSize(Textdraw100, 0.899999, 3.000000);
	TextDrawColor(Textdraw100, -1);
	TextDrawSetOutline(Textdraw100, 0);
	TextDrawSetProportional(Textdraw100, 1);
	TextDrawSetShadow(Textdraw100, 0);

	Textdraw101 = TextDrawCreate(521.000000, 412.000000, "~n~");
	TextDrawBackgroundColor(Textdraw101, 255);
	TextDrawFont(Textdraw101, 1);
	TextDrawLetterSize(Textdraw101, 2.099999, 0.499999);
	TextDrawColor(Textdraw101, -1);
	TextDrawSetOutline(Textdraw101, 0);
	TextDrawSetProportional(Textdraw101, 1);
	TextDrawSetShadow(Textdraw101, 1);
	TextDrawUseBox(Textdraw101, 1);
	TextDrawBoxColor(Textdraw101, -1);
	TextDrawTextSize(Textdraw101, 504.000000, 0.000000);

	Textdraw102 = TextDrawCreate(496.000000, 412.000000, "O");
	TextDrawBackgroundColor(Textdraw102, 255);
	TextDrawFont(Textdraw102, 1);
	TextDrawLetterSize(Textdraw102, 1.329998, 4.899999);
	TextDrawColor(Textdraw102, -1);
	TextDrawSetOutline(Textdraw102, 0);
	TextDrawSetProportional(Textdraw102, 1);
	TextDrawSetShadow(Textdraw102, 0);

	Textdraw103 = TextDrawCreate(527.000000, 429.000000, "~n~");
	TextDrawBackgroundColor(Textdraw103, 255);
	TextDrawFont(Textdraw103, 1);
	TextDrawLetterSize(Textdraw103, 2.099999, 1.400000);
	TextDrawColor(Textdraw103, -1);
	TextDrawSetOutline(Textdraw103, 0);
	TextDrawSetProportional(Textdraw103, 1);
	TextDrawSetShadow(Textdraw103, 1);
	TextDrawUseBox(Textdraw103, 1);
	TextDrawBoxColor(Textdraw103, -1);
	TextDrawTextSize(Textdraw103, 501.000000, -2.000000);

	Textdraw104 = TextDrawCreate(511.000000, 418.000000, ":");
	TextDrawBackgroundColor(Textdraw104, 255);
	TextDrawFont(Textdraw104, 1);
	TextDrawLetterSize(Textdraw104, 0.469999, 1.500000);
	TextDrawColor(Textdraw104, 255);
	TextDrawSetOutline(Textdraw104, 0);
	TextDrawSetProportional(Textdraw104, 1);
	TextDrawSetShadow(Textdraw104, 0);

	Textdraw105 = TextDrawCreate(550.000000, 427.000000, "O");
	TextDrawBackgroundColor(Textdraw105, 255);
	TextDrawFont(Textdraw105, 1);
	TextDrawLetterSize(Textdraw105, 2.029999, 4.899999);
	TextDrawColor(Textdraw105, -1);
	TextDrawSetOutline(Textdraw105, 0);
	TextDrawSetProportional(Textdraw105, 1);
	TextDrawSetShadow(Textdraw105, 0);

	Textdraw106 = TextDrawCreate(512.000000, 432.000000, "O");
	TextDrawBackgroundColor(Textdraw106, -1);
	TextDrawFont(Textdraw106, 1);
	TextDrawLetterSize(Textdraw106, 2.029999, 4.899999);
	TextDrawColor(Textdraw106, -1);
	TextDrawSetOutline(Textdraw106, 0);
	TextDrawSetProportional(Textdraw106, 1);
	TextDrawSetShadow(Textdraw106, -2);

	Textdraw107 = TextDrawCreate(553.000000, 433.000000, "O");
	TextDrawBackgroundColor(Textdraw107, 20);
	TextDrawFont(Textdraw107, 1);
	TextDrawLetterSize(Textdraw107, 2.029999, 4.899999);
	TextDrawColor(Textdraw107, -1);
	TextDrawSetOutline(Textdraw107, 0);
	TextDrawSetProportional(Textdraw107, 1);
	TextDrawSetShadow(Textdraw107, 0);

	Textdraw108 = TextDrawCreate(573.000000, 427.000000, "O");
	TextDrawBackgroundColor(Textdraw108, -1);
	TextDrawFont(Textdraw108, 1);
	TextDrawLetterSize(Textdraw108, 3.789998, 4.899999);
	TextDrawColor(Textdraw108, -1);
	TextDrawSetOutline(Textdraw108, 0);
	TextDrawSetProportional(Textdraw108, 1);
	TextDrawSetShadow(Textdraw108, 4);

	Textdraw109 = TextDrawCreate(500.000000, 405.000000, "O");
	TextDrawBackgroundColor(Textdraw109, 255);
	TextDrawFont(Textdraw109, 1);
	TextDrawLetterSize(Textdraw109, 0.949999, 0.799998);
	TextDrawColor(Textdraw109, 255);
	TextDrawSetOutline(Textdraw109, 1);
	TextDrawSetProportional(Textdraw109, 1);

	Textdraw110 = TextDrawCreate(527.000000, 406.000000, "~n~");
	TextDrawBackgroundColor(Textdraw110, 255);
	TextDrawFont(Textdraw110, 1);
	TextDrawLetterSize(Textdraw110, 0.500000, 0.099999);
	TextDrawColor(Textdraw110, -1);
	TextDrawSetOutline(Textdraw110, 0);
	TextDrawSetProportional(Textdraw110, 1);
	TextDrawSetShadow(Textdraw110, 1);
	TextDrawUseBox(Textdraw110, 1);
	TextDrawBoxColor(Textdraw110, 255);
	TextDrawTextSize(Textdraw110, 498.000000, 0.000000);

	Textdraw112 = TextDrawCreate(511.000000, 428.000000, ":");
	TextDrawBackgroundColor(Textdraw112, 255);
	TextDrawFont(Textdraw112, 1);
	TextDrawLetterSize(Textdraw112, 0.469999, 1.500000);
	TextDrawColor(Textdraw112, 255);
	TextDrawSetOutline(Textdraw112, 0);
	TextDrawSetProportional(Textdraw112, 1);
	TextDrawSetShadow(Textdraw112, 0);

	Textdraw113 = TextDrawCreate(512.000000, 420.000000, "/");
	TextDrawBackgroundColor(Textdraw113, 255);
	TextDrawFont(Textdraw113, 1);
	TextDrawLetterSize(Textdraw113, 0.449998, -0.399998);
	TextDrawColor(Textdraw113, -15466241);
	TextDrawSetOutline(Textdraw113, 0);
	TextDrawSetProportional(Textdraw113, 1);
	TextDrawSetShadow(Textdraw113, 0);

	Textdraw114 = TextDrawCreate(530.000000, 380.000000, ".     ~n~  .  .    .      . ~n~ .   .   .     . .  .~n~     .    . ~n~ .    .       .       . ~n~    .    .     .  . ~n~ .  .   ");
	TextDrawBackgroundColor(Textdraw114, -206);
	TextDrawFont(Textdraw114, 1);
	TextDrawLetterSize(Textdraw114, 0.330000, 0.999998);
	TextDrawColor(Textdraw114, -1);
	TextDrawSetOutline(Textdraw114, 0);
	TextDrawSetProportional(Textdraw114, 1);
	TextDrawSetShadow(Textdraw114, 10);

	Textdraw115 = TextDrawCreate(576.000000, 482.000000, ".     ~n~  .  .    .      . ~n~ .   .   .     . .  .~n~     .    . ~n~ .    .       .       . ~n~    .    .     .  . ~n~ .  .   ");
	TextDrawBackgroundColor(Textdraw115, -206);
	TextDrawFont(Textdraw115, 1);
	TextDrawLetterSize(Textdraw115, 0.330000, -1.000000);
	TextDrawColor(Textdraw115, -1);
	TextDrawSetOutline(Textdraw115, 0);
	TextDrawSetProportional(Textdraw115, 1);
	TextDrawSetShadow(Textdraw115, -60);

	Textdraw116 = TextDrawCreate(526.000000, 422.000000, "Merry Xmas!");
	TextDrawBackgroundColor(Textdraw116, -1);
	TextDrawFont(Textdraw116, 1);
	TextDrawLetterSize(Textdraw116, 0.430000, 2.000000);
	TextDrawColor(Textdraw116, -1);
	TextDrawSetOutline(Textdraw116, 0);
	TextDrawSetProportional(Textdraw116, 1);
	TextDrawSetShadow(Textdraw116, 0);

	Textdraw117 = TextDrawCreate(505.000000, 419.000000, "/");
	TextDrawBackgroundColor(Textdraw117, 255);
	TextDrawFont(Textdraw117, 1);
	TextDrawLetterSize(Textdraw117, -0.889999, 1.299998);
	TextDrawColor(Textdraw117, -1656160001);
	TextDrawSetOutline(Textdraw117, 0);
	TextDrawSetProportional(Textdraw117, 1);
	TextDrawSetShadow(Textdraw117, 0);

	Textdraw119 = TextDrawCreate(498.000000, 410.000000, "/");
	TextDrawBackgroundColor(Textdraw119, 255);
	TextDrawFont(Textdraw119, 1);
	TextDrawLetterSize(Textdraw119, -0.889999, 1.299998);
	TextDrawColor(Textdraw119, -1656160001);
	TextDrawSetOutline(Textdraw119, 0);
	TextDrawSetProportional(Textdraw119, 1);
	TextDrawSetShadow(Textdraw119, 0);

	Textdraw120 = TextDrawCreate(528.000000, 424.000000, "Merry Xmas!");
	TextDrawBackgroundColor(Textdraw120, -1);
	TextDrawFont(Textdraw120, 1);
	TextDrawLetterSize(Textdraw120, 0.409999, 1.700000);
	TextDrawColor(Textdraw120, 50);
	TextDrawSetOutline(Textdraw120, 0);
	TextDrawSetProportional(Textdraw120, 1);
	TextDrawSetShadow(Textdraw120, 0);

	Textdraw111 = TextDrawCreate(508.000000, 405.000000, "..");
	TextDrawBackgroundColor(Textdraw111, 255);
	TextDrawFont(Textdraw111, 1);
	TextDrawLetterSize(Textdraw111, 0.400000, 1.500000);
	TextDrawColor(Textdraw111, 255);
	TextDrawSetOutline(Textdraw111, 0);
	TextDrawSetProportional(Textdraw111, 0);
	TextDrawSetShadow(Textdraw111, 0);

	Loop(i,MAX_PLAYERS) if(IsPlayerConnected(i)) HideLogo(i);
}

public ShowLogo( playerid )
{
	TextDrawShowForPlayer(playerid, Textdraw100);
    TextDrawShowForPlayer(playerid, Textdraw101);
    TextDrawShowForPlayer(playerid, Textdraw102);
    TextDrawShowForPlayer(playerid, Textdraw103);
    TextDrawShowForPlayer(playerid, Textdraw104);
    TextDrawShowForPlayer(playerid, Textdraw105);
    TextDrawShowForPlayer(playerid, Textdraw106);
    TextDrawShowForPlayer(playerid, Textdraw107);
    TextDrawShowForPlayer(playerid, Textdraw108);
    TextDrawShowForPlayer(playerid, Textdraw109);
    TextDrawShowForPlayer(playerid, Textdraw110);
    TextDrawShowForPlayer(playerid, Textdraw111);
    TextDrawShowForPlayer(playerid, Textdraw112);
    TextDrawShowForPlayer(playerid, Textdraw113);
    TextDrawShowForPlayer(playerid, Textdraw114);
    TextDrawShowForPlayer(playerid, Textdraw115);
    TextDrawShowForPlayer(playerid, Textdraw116);
    TextDrawShowForPlayer(playerid, Textdraw117);
    TextDrawShowForPlayer(playerid, Textdraw119);
    TextDrawShowForPlayer(playerid, Textdraw120);
}
public HideLogo( playerid )
{
	TextDrawHideForPlayer(playerid, Textdraw100);
    TextDrawHideForPlayer(playerid, Textdraw101);
    TextDrawHideForPlayer(playerid, Textdraw102);
    TextDrawHideForPlayer(playerid, Textdraw103);
    TextDrawHideForPlayer(playerid, Textdraw104);
    TextDrawHideForPlayer(playerid, Textdraw105);
    TextDrawHideForPlayer(playerid, Textdraw106);
    TextDrawHideForPlayer(playerid, Textdraw107);
    TextDrawHideForPlayer(playerid, Textdraw108);
    TextDrawHideForPlayer(playerid, Textdraw109);
    TextDrawHideForPlayer(playerid, Textdraw110);
    TextDrawHideForPlayer(playerid, Textdraw111);
    TextDrawHideForPlayer(playerid, Textdraw112);
    TextDrawHideForPlayer(playerid, Textdraw113);
    TextDrawHideForPlayer(playerid, Textdraw114);
    TextDrawHideForPlayer(playerid, Textdraw115);
    TextDrawHideForPlayer(playerid, Textdraw116);
    TextDrawHideForPlayer(playerid, Textdraw117);
    TextDrawHideForPlayer(playerid, Textdraw119);
    TextDrawHideForPlayer(playerid, Textdraw120);
}



public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
		case DIALOG_CHRISTMASMUSIC:
	    {
	        switch(listitem)
	        {
				case 0:PlayAudioStreamForPlayer(playerid,"http://mvmm.exp-gaming.net/sounds/JoseFelicianoFelizNavidad.mp3");
				case 1:PlayAudioStreamForPlayer(playerid,"http://mvmm.exp-gaming.net/sounds/Wewishyouamerrychristmas.mp3");
				case 2:PlayAudioStreamForPlayer(playerid,"http://mvmm.exp-gaming.net/sounds/jinglebells.mp3");
				case 3:PlayAudioStreamForPlayer(playerid,"http://mvmm.exp-gaming.net/sounds/DeanMartinLetitSnow.mp3");
				case 4:PlayAudioStreamForPlayer(playerid,"http://mvmm.exp-gaming.net/sounds/MariahCareyAllIWantForChristmasIsYou.mp3");
				case 5:PlayAudioStreamForPlayer(playerid,"http://mvmm.exp-gaming.net/sounds/michaelbublwhitechristmas.mp3");
				case 6:PlayAudioStreamForPlayer(playerid,"http://mvmm.exp-gaming.net/sounds/whamlastchristmas.mp3");
				case 7:PlayAudioStreamForPlayer(playerid,"http://mvmm.exp-gaming.net/sounds/TrainShakeUpChristmas.mp3");
				case 8:StopAudioStreamForPlayer(playerid);
			}
		}
		case DIALOG_CHRISTMASMUSICALL:
		{
			switch(listitem)
			{
				case 0:Loop(i,MAX_PLAYERS) PlayAudioStreamForPlayer(i,"http://mvmm.exp-gaming.net/sounds/JoseFelicianoFelizNavidad.mp3");
				case 1:Loop(i,MAX_PLAYERS) PlayAudioStreamForPlayer(i,"http://mvmm.exp-gaming.net/sounds/Wewishyouamerrychristmas.mp3");
				case 2:Loop(i,MAX_PLAYERS) PlayAudioStreamForPlayer(i,"http://mvmm.exp-gaming.net/sounds/jinglebells.mp3");
				case 3:Loop(i,MAX_PLAYERS) PlayAudioStreamForPlayer(i,"http://mvmm.exp-gaming.net/sounds/DeanMartinLetitSnow.mp3");
				case 4:Loop(i,MAX_PLAYERS) PlayAudioStreamForPlayer(i,"http://mvmm.exp-gaming.net/sounds/MariahCareyAllIWantForChristmasIsYou.mp3");
				case 5:Loop(i,MAX_PLAYERS) PlayAudioStreamForPlayer(i,"http://mvmm.exp-gaming.net/sounds/michaelbublwhitechristmas.mp3");
				case 6:Loop(i,MAX_PLAYERS) PlayAudioStreamForPlayer(i,"http://mvmm.exp-gaming.net/sounds/whamlastchristmas.mp3");
				case 7:Loop(i,MAX_PLAYERS) PlayAudioStreamForPlayer(i,"http://mvmm.exp-gaming.net/sounds/TrainShakeUpChristmas.mp3");
				case 8:Loop(i,MAX_PLAYERS) StopAudioStreamForPlayer(i);
			}
		}
	}
	return 0;
}

public OnObjectMoved(objectid)
{
    xFireworks_OnObjectMoved(objectid);
}
//------------------------------CMDS--------------------------------------------
CMD:logo(playerid,params[])
{
    if (pLogo[playerid] == true)
    {
        pLogo[playerid] = false ;
        SendClientMessage( playerid, -1, ""#COL_EASY"The logo has been hidden! {FFFFFF}["#COL_RED"DISABLED{FFFFFF}]");
        SendClientMessage( playerid, -1, ""#COL_EASY"Write again "#COL_BLUE"/logo"#COL_EASY" to activate it!");
        HideLogo(playerid);
    }
    else
    {
        pLogo[playerid] = true ;
        SendClientMessage( playerid, -1, ""#COL_EASY"The logo is displayed on the screen! {FFFFFF}["#COL_GREEN"ENABLED{FFFFFF}]");
        SendClientMessage( playerid, -1, ""#COL_EASY"Write again "#COL_BLUE"/logo"#COL_EASY" to de-activate it!");
        ShowLogo(playerid);
    }
    return 1;
}
CMD:snow(playerid, params[])
{
        if(snowOn{playerid})
        {
            DeleteSnow(playerid);
            SendClientMessage(playerid, COLOR_RED, "* It's not snowing anymore now.");
        }
        else
        {
            CreateSnow(playerid);
            SendClientMessage(playerid, COLOR_GREEN, "* Let it snow, let it snow, let it snow!");
        }
        return 1;
}

CMD:hat(playerid,params[])
{
	new hat;
	if(sscanf(params,"i",hat)) return SendClientMessage(playerid,COLOR_RED,"Usage: /hat [0/1]");
	switch(hat)
	{
		case 0: GiveChristmasHat(playerid,1);
		case 1: GiveChristmasHat(playerid,2);
	}
	SendClientMessage(playerid,COLOR_ORANGE,"You've now an (other) christmashat.");
	return 1;
}

CMD:christmasmusic(playerid,params[])
{
	ShowPlayerDialog(playerid,DIALOG_CHRISTMASMUSIC,DIALOG_STYLE_LIST,"Christmas Songs:","Jose Feliciano - Feliz Navidad\nWe wish you a merry christmas\nJingle Bells\nDean Martin - Let it Snow\nMariah Carey - All I Want For Christmas Is You\nMichael Buble - White Christmas\nWham - Last Christmas\nTrain - Shake Up Christmas\nStop music","Play","Cancel");
	return 1;
}

CMD:cm(playerid,params[]) return cmd_christmasmusic(playerid,params);
CMD:cma(playerid,params[]) return cmd_christmasmusicall(playerid,params);

CMD:christmasmusicall(playerid,params[])
{
	ShowPlayerDialog(playerid,DIALOG_CHRISTMASMUSICALL,DIALOG_STYLE_LIST,"Christmas Songs:","Jose Feliciano - Feliz Navidad\nWe wish you a merry christmas\nJingle Bells\nDean Martin - Let it Snow\nMariah Carey - All I Want For Christmas Is You\nMichael Buble - White Christmas\nWham - Last Christmas\nTrain - Shake Up Christmas\nStop music","Play","Cancel");
	return 1;
}

CMD:christmas(playerid,params[])
{
	ShowPlayerDialog(playerid, DIALOG_CHRISTMAS, DIALOG_STYLE_MSGBOX,"Christmas","/hat [1/2] - Attach a christmashat on your head. \n/snow - (Dis)able the snow \n/logo - (Dis)able the moving snowman\n/snowmini - Go to the snowball minigame\n/fwhelp - Fireworks help\n/christmasmusic(all) /cm(a) - Stream popular christmas songs. \n/setnight - switches everyone to night","OK","");
	return 1;
}


CMD:snowmini(playerid,params[])
{
	if(Snow_F[playerid] == false)
	{
	    ResetPlayerWeapons(playerid);
		Snow_F[playerid] = true;
		Charged[playerid] = false;
		Shoot[playerid] = false;
		SetPlayerPos(playerid,-708.40002441,3796.19995117,9.69999981);
		new res22[500], iName[128];
		GetPlayerName(playerid,iName,sizeof(iName));
		format(res22,sizeof(res22),"{0088FF}Hey {FF0000}%s{0088FF}!\nYou've just started playing {15FF00}SnowBall Fight{0088FF} minigame.\nIn this minigame , your goal is to hit as many players,\nas you can , without being hit by them.\nTo throw an snowball press : {FF7B0F}AIM Key\n{FFFF0F}Good Luck! ",iName);
		ShowPlayerDialog(playerid,9944,DIALOG_STYLE_MSGBOX,"{FF0000}SnowBalls {FFFF00}Fight",res22,"Ok","");
	}
	else if(Snow_F[playerid] == true)
	{
		Snow_F[playerid] = false;
		SpawnPlayer(playerid);
	}
	return 1;
}

CMD:fwspawn(playerid, params[])
{
   new c, id, Float:h, hv, Float:w, Float:in;
   if (sscanf(params, "ififf",c,h,hv,w,in)) {
       SendClientMessage(playerid, 0xFFFFFFFF, "Usage: /fwspawn {COUNT} {HEIGHT} {HVAR} {WINDSPEED} {INTERVAL}");
       SendClientMessage(playerid, 0xFFFFFFFF, "Example: /fwspawn 20 50.0 20 30.0 1.0");
   }
   else {
        id = findempty();
        if (id<0) SendClientMessage(playerid, 0xFFFFFFFF, "No free slot!");
        else {
    	    new Float:x, Float:y, Float:z, Float:a;
    	    GetPlayerPos(playerid,x,y,z);
    	    GetPlayerFacingAngle(playerid,a);
	        GetXYInFrontOfPosition(x,y,a,1.0);
	        batteries[id][pos][0] = x;
	        batteries[id][pos][1] = y;
	        batteries[id][pos][2] = z;
	        batteries[id][count] = c;
	        batteries[id][height] = h;
	        batteries[id][hvar] = hv;
	        batteries[id][windspeed] = w;
	        batteries[id][interval] = in;

	        batteries[id][inuse] = true;
            batteries[id][machine] = CreateObject(2780,x,y,z,0.0,0.0,0.0);
            new tmp[256];
            format(tmp,sizeof(tmp),"Machine created. Slot: %d", id);
            SendClientMessage(playerid, 0x55FF55FF, tmp);
        }
   }
   return 1;
}

CMD:fwfire(playerid, params[])
{
   new id;
   if (sscanf(params, "i",id) || id>sizeof(batteries) || id<0) SendClientMessage(playerid, 0xFFFFFFFF, "Usage: /fwfire {ID}");
   else {
	   batteries[id][timer] = SetTimerEx("machinetimer",GetSomeTime(id),false,"i",id);
       SendClientMessage(playerid, 0xFFFFFFFF, "Firework started.");
   }
   return 1;
}

CMD:fwfireall(playerid, params[])
{
   #pragma unused params
   #pragma unused playerid
   for (new i=0; i<sizeof(batteries); i++) {
       if (batteries[i][inuse]) {
	        batteries[i][timer] = SetTimerEx("machinetimer",GetSomeTime(i),false,"i",i);
       }
   }
   SendClientMessage(playerid, 0xFFFFFFFF, "All fireworks started.");
   return 1;
}

CMD:fwkill(playerid, params[])
{
   new id;
   if (sscanf(params, "i",id) || id>sizeof(batteries) || id<0) SendClientMessage(playerid, 0xFFFFFFFF, "Usage: /fwfire {ID}");
   else {
	   KillTimer(batteries[id][timer]);
	   batteries[id][inuse] = false;
	   DestroyObject(batteries[id][machine]);
       SendClientMessage(playerid, 0xFFFFFFFF, "Firework deleted.");
   }
   return 1;
}

CMD:fwkillall(playerid, params[])
{
   #pragma unused params
   #pragma unused playerid
   for (new i=0; i<sizeof(batteries); i++) {
       if (batteries[i][inuse]) {
    	   KillTimer(batteries[i][timer]);
    	   batteries[i][inuse] = false;
    	   DestroyObject(batteries[i][machine]);
       }
   }
   SendClientMessage(playerid, 0xFFFFFFFF, "All fireworks deleted.");
   return 1;
}

CMD:fwsave(playerid, params[])
{
    new filename[20],tmp[256];
    if (sscanf(params, "s",filename)) SendClientMessage(playerid, 0xFFFFFFFF, "Usage: /fwsave {NAME}");
    else {
        format(tmp,sizeof(tmp),"%s.firework",filename);
        new File:f = fopen(tmp,io_write);
        for (new i=0; i<sizeof(batteries); i++) {
            if (batteries[i][inuse]) {
                format(tmp, sizeof(tmp), "%f %f %f %d %f %d %f %f\r\n",
                                        batteries[i][pos][0],
                                        batteries[i][pos][1],
                                        batteries[i][pos][2],
                                        batteries[i][count],
                                        batteries[i][height],
                                        batteries[i][hvar],
                                        batteries[i][windspeed],
                                        batteries[i][interval]);
                fwrite(f, tmp);
            }
        }
        fclose(f);
        SendClientMessage(playerid, 0xFFFFFFFF, "Fireworks saved.");
    }
    return 1;
}


CMD:fwload(playerid, params[])
{
    new filename[20],tmp[256];
    if (sscanf(params, "s",filename)) SendClientMessage(playerid, 0xFFFFFFFF, "Usage: /fwload {NAME}");
    else
	{
        format(tmp,sizeof(tmp),"%s.firework",filename);
        if (!fexist(tmp)) SendClientMessage(playerid, 0xFFFFFFFF, "File not found!");
        else
		{
            new id;
            new File:f = fopen(tmp,io_read);
        	while(fread(f, tmp)) {
        	    id = findempty();
        	    if (id<0) {
        	        SendClientMessage(playerid, 0xFFFFFFFF, "Out of slots...");
                    return 1;
        	    }
                batteries[id][inuse] = true;
                sscanf(tmp, "fffififf",
                             batteries[id][pos][0],
                             batteries[id][pos][1],
                             batteries[id][pos][2],
                             batteries[id][count],
                             batteries[id][height],
                             batteries[id][hvar],
                             batteries[id][windspeed],
                             batteries[id][interval]);
                batteries[id][machine] = CreateObject(2780,batteries[id][pos][0],batteries[id][pos][1],batteries[id][pos][2],0.0,0.0,0.0);

        	}
            fclose(f);
            SendClientMessage(playerid, 0xFFFFFFFF, "Fireworks loaded.");
        }
    }
    return 1;
}

CMD:setnight(playerid, params[])
{
    SetWorldTime(0);
    SendClientMessageToAll(0xDDDD11FF,"The world time has been changed to 0:00.");
    return 1;
}

CMD:fwhelp(playerid, params[])
{
	ShowPlayerDialog(playerid,DIALOG_CHRISTMASFW,DIALOG_STYLE_MSGBOX,"Christmas - Fireworks","Fireworks Script Commands:\n/fwspawn - create a battery \n/fwfire - fire a single battery \n/fwkill - remove a single battery \n/fwfireall - fire all batteries \n/fwkillall - remove all batteries \n/fwsave - save/overwrite all current batteries \n/fwload - load a file","OK","");
	return 1;
}

//------------------------------------------------------------------------------
stock GiveChristmasHat(playerid,number)
{
	switch(number)
	{
		case 1:
		{
		    if(IsPlayerAttachedObjectSlotUsed(playerid,1)) RemovePlayerAttachedObject(playerid,1);
		    SetPlayerAttachedObject(playerid, 1, 19065, 15, -0.025, -0.04, 0.23, 0, 0, 270, 2, 2, 2);
		}
		case 2:
		{
			if(IsPlayerAttachedObjectSlotUsed(playerid,1)) RemovePlayerAttachedObject(playerid,1);
			SetPlayerAttachedObject(playerid, 1, 19065, 2, 0.120000, 0.040000, -0.003500, 0, 100, 100, 1.4, 1.4, 1.4);
		}
	}
}
forward UpdateSnow(playerid);
public UpdateSnow(playerid)
{
    if(!snowOn{playerid}) return 0;
    new Float:pPos[3];
    GetPlayerPos(playerid, pPos[0], pPos[1], pPos[2]);
    Loop(i,MAX_SNOW_OBJECTS) SetObjectPos(snowObject[playerid][i], pPos[0] + random(25), pPos[1] + random(25), pPos[2] - 5);
    return 1;
}

stock CreateSnow(playerid)
{
    if(snowOn{playerid}) return 0;
    new Float:pPos[3];
    GetPlayerPos(playerid, pPos[0], pPos[1], pPos[2]);
    Loop(i,MAX_SNOW_OBJECTS) snowObject[playerid][i] = CreateObject(18864, pPos[0] + random(25), pPos[1] + random (25), pPos[2] - 5, random(100), random(100), random(100));
    snowOn{playerid} = true;
    updateTimer{playerid} = SetTimerEx("UpdateSnow", UPDATE_INTERVAL, true, "i", playerid);
    return 1;
}

stock DeleteSnow(playerid)
{
    if(!snowOn{playerid}) return 0;
    Loop(i,MAX_SNOW_OBJECTS) DestroyObject(snowObject[playerid][i]);
    KillTimer(updateTimer{playerid});
    snowOn{playerid} = false;
    return 1;
}

stock CreateChristmasTree(number, Float:X, Float:Y, Float:Z)
{
	switch(number)
	{
	    case 1:
	    {
			CreateObject(3472,X+0.28564453,Y+0.23718262,Z+27.00000000,0.00000000,0.00000000,230.48021);
			CreateObject(664,X+0.20312500,Y+0.01171875,Z+-3.00000000,0.00000000,0.00000000,0.00000000);
			CreateObject(3472,X+0.45312500,Y+0.51562500,Z+4.00000000,0.00000000,0.00000000,69.7851562);
			CreateObject(3472,X+0.65136719,Y+1.84570312,Z+17.00000000,0.00000000,0.00000000,41.863403);
			CreateObject(7666,X+0.34130859,Y+0.16845703,Z+45.00000000,0.00000000,0.00000000,298.12524);
			CreateObject(7666,X+0.34082031,Y+0.16796875,Z+45.00000000,0.00000000,0.00000000,27.850342);
			CreateObject(3472,X+0.45312500,Y+0.51562500,Z+12.00000000,0.00000000,0.00000000,350.02441);
			CreateObject(3472,X+0.45312500,Y+0.51562500,Z+7.00000000,0.00000000,0.00000000,30.0805664);
			CreateObject(3472,X+0.45312500,Y+0.51562500,Z+22.00000000,0.00000000,0.00000000,230.47119);
			CreateObject(1262,X+0.15039062,Y+0.57128906,Z+29.45285416,0.00000000,0.00000000,162.90527);
		}
		case 2:
		{
			Loop(i,sizeof(Treepos))
		    {
		        if(Treepos[i][XmasTreeX] == 0)
		        {
		            Treepos[i][XmasTreeX]=1;
		            Treepos[i][XmasX]=X;
		            Treepos[i][XmasY]=Y;
		            Treepos[i][XmasZ]=Z;
		            Treepos[i][XmasObject1] = CreateObject(19076, X, Y, Z-1.0,0,0,300);
		            Treepos[i][XmasObject2] = CreateObject(19054, X, Y+1.0, Z-0.4,0,0,300);
		            Treepos[i][XmasObject3] = CreateObject(19058, X+1.0, Y, Z-0.4,0,0,300);
		            Treepos[i][XmasObject4] = CreateObject(19056, X, Y-1.0, Z-0.4,0,0,300);
		            Treepos[i][XmasObject5] = CreateObject(19057, X-1.0, Y, Z-0.4,0,0,300);
		            Treepos[i][XmasObject6] = CreateObject(19058, X-1.5, Y+1.5, Z-1.0,0,0,300);
		            Treepos[i][XmasObject7] = CreateObject(19055, X+1.5, Y-1.5, Z-1.0,0,0,300);
		            Treepos[i][XmasObject8] = CreateObject(19057, X+1.5, Y+1.5, Z-1.0,0,0,300);
		            Treepos[i][XmasObject9] = CreateObject(19054, X-1.5, Y-1.5, Z-1.0,0,0,300);
		            Treepos[i][XmasObject10] = CreateObject(3526, X, Y, Z-1.0,0,0,300);
		        }
		    }
		}
		case 3:
		{
			CreateObject(19076, X, Y, Z,   0.00, 0.00, 0.00);
			CreateObject(19054, X+0.37, Y+2.38, Z,   0.00, 0.00, 0.00);
			CreateObject(19055, X-1.18, Y-1.18, Z,   0.00, 0.00, 0.00);
			CreateObject(19056, X+1.94, Y-1.34, Z,   0.00, 0.00, 0.00);
			CreateObject(19057, X+1.67, Y+1.52, Z,   0.00, 0.00, 0.00);
		}
	}
}

stock CreateChristmasLights(Float:x, Float:y, Float:z)
{
	CreateObject(3472, x,y,z,0,0,300);
	CreateObject(3472, x,y,z+4,0,0,300);
}

stock LoadMetasTextdraws()
{
    NYCounter = TextDrawCreate(345.000000, 399.000000, "_");//TextDrawCreate(357.000000, 399.000000, "_");
    TextDrawAlignment(NYCounter, 2);
    TextDrawBackgroundColor(NYCounter, 255);
    TextDrawFont(NYCounter, 2);
    TextDrawLetterSize(NYCounter, 0.40000, 2);
    TextDrawColor(NYCounter, -16776961);
    TextDrawSetOutline(NYCounter, 1);
    TextDrawSetProportional(NYCounter, 1);

    new message[40], year, month, day;
    getdate(year, month, day);
    if(month != 1) { year--; }
    format(message, sizeof(message), "~>~ HAPPY NEW YEAR ~<~~n~~y~%d!", year);

    HappyNewYearText = TextDrawCreate(340.000000, 350.000000, message);
    TextDrawAlignment(HappyNewYearText, 2);
    TextDrawBackgroundColor(HappyNewYearText, 255);
    TextDrawFont(HappyNewYearText, 1);
    TextDrawLetterSize(HappyNewYearText, 1.000000, 4.000000);
    TextDrawColor(HappyNewYearText, 16777215);
    TextDrawSetOutline(HappyNewYearText, 1);
	TextDrawSetProportional(HappyNewYearText, 1);

    CounterTimer();
    cTime = SetTimer("CounterTimer", 400, 1);
    return 1;
}

forward CounterTimer();
public CounterTimer()
{
        new string[150];
        new year, month, day, hour, minute, second;
        getdate(year, month, day);
        gettime(hour, minute, second);
        if(month == 1 && day == 1)
        {
            TextDrawHideForAll(NYCounter);
            TextDrawShowForAll(HappyNewYearText);
            KillTimer(cTime);
        }
        else
        {
            gettime(hour, minute, second);

            new day2;
            switch(month)
            {
                case 1, 3, 5, 7, 8, 10, 12: day2 = 31;
                case 2: { if(year%4 == 0) { day2 = 29; } else { day2 = 28; } }
                case 4, 6, 9, 11: day2 = 30;
            }
            month = 12 - month;
            day = day2 - day;

            hour = 24 - hour;
			if(hour == 24) { hour = 0; }
			if(minute != 0) { hour--; }

            minute = 60 - minute;

			if(minute == 60) { minute = 0; }
			if(second != 0) { minute--; }

            second = 60 - second;
			if(second == 60) { second = 0; }

            format(string, sizeof(string), "~y~%d: ~g~%02d ~w~Mo, ~g~%02d ~w~D, ~g~%02d ~w~H, ~g~%02d ~w~M, ~g~%02d ~w~S", year+1,month, day, hour, minute, second);

            TextDrawSetString(NYCounter, string);
            TextDrawShowForAll(NYCounter);
        }
        return 1;
}

forward CheckSnow(playerid);
public CheckSnow(playerid)
{
	Shoot[playerid] = false;
	Loop(i,30)
	{
		new Float:X, Float:Y;
		GetXYInFrontOfPlayer(playerid,X,Y,i);
	    Loop(z,MAX_PLAYERS)
		{
			if(z != playerid && Shoot[playerid] == false && Killer[z] == 501)
			{
				if(IsPlayerInRangeOfPoint(z,1.0,X,Y,9.69999981))
				{
					Shoot[playerid] = false;
					new Float:pX,Float:pY,Float:pZ,Float:tX,Float:tY,Float:tZ;
					GetPlayerPos(playerid,pX,pY,pZ);
					GetPlayerPos(z,tX,tY,tZ);
					Obj[z] = CreateObject(2709,pX,pY,pZ+0.5,0.0,0.0,0.0);
					MoveObject(Obj[z],tX,tY,tZ-0.9,25.0);
					SetPlayerHealth(z,0);
					Killer[z] = playerid;
					GameTextForPlayer(playerid,"~R~Target ~y~Shoot~B~!~N~~G~+ 500 ~p~Cash",1000,3);
					GivePlayerMoney(playerid,500);
					Charged[playerid] = false;
				    ApplyAnimation(playerid,"GRENADE","WEAPON_throw",4.1,0,1,1,0,1000,1);
				}
			}
		}
	}
	if(Shoot[playerid] == false) GameTextForPlayer(playerid,"~R~NO ~G~Targets~B~!",1000,1);
	return 1;
}

GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
    new Float:a;
    GetPlayerPos(playerid, x, y, a);
    GetPlayerFacingAngle(playerid, a);
    if (GetPlayerVehicleID(playerid))
    {
      GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
    }
    x += (distance * floatsin(-a, degrees));
    y += (distance * floatcos(-a, degrees));
}

//---------------------------FW-------------------------------------------------
findempty()
{
    Loop(i,sizeof(batteries)) if (!batteries[i][inuse]) return i;
    return -1;
}

GetSomeTime(id)
{
   return floatround((400 + random(300)) * batteries[id][interval]);
}


forward machinetimer(id);
public machinetimer(id)
{
    if (batteries[id][count]) {
		CreateFirework(batteries[id][pos][0],batteries[id][pos][1],batteries[id][pos][2],           //pos
                       batteries[id][height] - batteries[id][hvar]/2 + random(batteries[id][hvar]),   //height
                       random(360),batteries[id][windspeed],                                        //wind
                       50.0,                                                                        //speed
                       explosions[random(sizeof(explosions))],100.0);                               //explosion
        batteries[id][count]--;
        batteries[id][timer] = SetTimerEx("machinetimer",GetSomeTime(id),false,"i",id);
    } else {
        KillTimer(batteries[id][timer]);
        batteries[id][timer] = -1;
        batteries[id][inuse] = false;
	    DestroyObject(batteries[id][machine]);
    }
}
