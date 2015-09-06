#include <a_samp>

#if defined O_O
        **********************************
        *   Name: 0Sprites Editor        *
        *   Version: 1.0                 *
        *   Created by: Zh3r0            *
        *   Date: 18. October. 2011      *
        * #Edit,  redistribute  as  you  *
        * want  but  keep  the  credits  *
        *                                *
        *                               (C) Zh3r0 2011   *
        **********************************

        CHANGELOG:
        18.X.2011: - Release.
        20.X.2011: - Bug-fixed deletion feature.
#endif

stock
        bool:FALSE = false;
#define MAX_TEXTDRAWS 90
#define SendClientMessageEx(%0,%1,%2)\
                do\
                {\
                    new szString[256];\
                    format(szString, sizeof(szString), "0{C3C3C3}Sprites:{FFFFFF} " %1, %2);\
                    SendClientMessage((%0), -1, szString);\
                }\
                while(FALSE)

enum
        dialogs_e
        {
                main = 9946,
                spriteshelp,
                selectcategory,
                addsprite,
                insertsprite,
                selectsprite,
                deletesprite,
                setspritesavename,
                colormethod,
                colorpremade,
                colorhex
        };
enum
        td_e
        {
            created,
                Text:td,
                td_name[40],
                td_color,
                Float:td_x,
                Float:td_y,
                Float:td_height,
                Float:td_width
        };

new

        td_editing,
    SpritesString[512],
        textdraws = -1,
    spritelist,
        td_i[MAX_TEXTDRAWS][td_e],
        sprites[][] =
        {
                {!#intro1},             {!#intro2},             {!#INTRO3},             {!#intro4},
                {!#LD_BEAT},    {!#LD_BUM},             {!#LD_CARD},    {!#LD_CHAT},
                {!#LD_DRV},             {!#LD_DUAL},    {!#ld_grav},    {!#LD_NONE},
                {!#LD_OTB},             {!#LD_OTB2},    {!#LD_PLAN},    {!#LD_POKE},
                {!#LD_POOL},    {!#LD_RACE},    {!#LD_RCE1},    {!#LD_RCE2},
                {!#LD_RCE3},    {!#LD_RCE4},    {!#LD_RCE5},    {!#LD_ROUL},
                {!#ld_shtr},    {!#LD_SLOT},    {!#LD_SPAC},    {!#LD_TATT},
                {!#load0uk},    {!#loadsc0},    {!#loadsc1},    {!#loadsc2},
                {!#loadsc3},    {!#loadsc4},    {!#loadsc5},    {!#loadsc6},
                {!#loadsc7},    {!#loadsc8},    {!#loadsc9},    {!#loadsc10},
                {!#loadsc11},   {!#loadsc12},   {!#loadsc13},   {!#loadsc14},
                {!#LOADSCS},    {!#LOADSUK},    {!#outro},              {!#splash1},
                {!#splash2},    {!#splash3}
        },
    LD_BEAT[][] =
    {
        {!#upr},   {!#upl},   {!#up},    {!#triang}, {!#square},
        {!#right}, {!#left},  {!#downr}, {!#downl},  {!#cross},
        {!#cring}, {!#circle},{!#chit}
        },
        LD_BUM[][] =
        {
                {!#bum2},
                {!#bum1},
                {!#blkdot}
        },
        LD_CARD[][] =
        {
            {!#cdback},
                {!#cd9s},  {!#cd9h},  {!#cd9d},  {!#cd9c},
                {!#cd8s},  {!#cd8h},  {!#cd8d},  {!#cd8c},
                {!#cd7s},  {!#cd7h},  {!#cd7d},  {!#cd7c},
            {!#cd6s},  {!#cd6h},  {!#cd6d},  {!#cd6c},
            {!#cd5s},  {!#cd5h},  {!#cd5d},  {!#cd5c},
            {!#cd4s},  {!#cd4h},  {!#cd4d},  {!#cd4c},
            {!#cd3s},  {!#cd3h},  {!#cd3d},  {!#cd3c},
            {!#cd2s},  {!#cd2h},  {!#cd2d},  {!#cd2c},
            {!#cd1s},  {!#cd1h},  {!#cd1d},  {!#cd1c},
                {!#cd13s}, {!#cd13h}, {!#cd13d}, {!#cd13c},
            {!#cd12s}, {!#cd12h}, {!#cd12d}, {!#cd12c},
            {!#cd11s}, {!#cd11h}, {!#cd11d}, {!#cd11c},
            {!#cd10s}, {!#cd10h}, {!#cd10d}, {!#cd10c}
        },
        LD_CHAT[][] =
        {
            {!#thumbup}, {!#thumbdn}, {!#goodcha},
            {!#dpad_lr}, {!#dpad_64}, {!#badchat}
         },
         LD_DRV[][] =
         {
            {!#tvcorn}, {!#tvbase},  {!#silver},
            {!#silfly}, {!#silboat}, {!#ribbw},
            {!#ribb},   {!#nawtxt},  {!#naward},
            {!#golfly}, {!#gold},    {!#goboat},
            {!#bronze}, {!#brfly},   {!#bfboat},
                {!#blkdot}
         },
         LD_DUAL[][] =
         {
            {!#white},  {!#tvcorn},      {!#thrustG},
            {!#shoot},  {!#rockshp}, {!#power},
            {!#light},  {!#layer},       {!#Health},
            {!#ex4},    {!#ex3},         {!#ex2},
            {!#ex1},    {!#DUALITY}, {!#dark},
            {!#black},  {!#backgnd}
        },
        ld_grav[][] =
        {
            {!#tvr},     {!#tvl},       {!#tvcorn},
            {!#timer},   {!#thorn},     {!#sky},
            {!#playy},   {!#playw},     {!#leaf},
            {!#hon},     {!#hive},      {!#hiscorey},
            {!#hiscorew},{!#ghost},     {!#flwra},
            {!#flwr},    {!#exity},     {!#exitw},
            {!#bumble},  {!#beea},  {!#bee2},
            {!#bee1}
        },
        LD_NONE[][] =
        {
            {!#warp},    {!#tvcorn},    {!#title},
                {!#thrust},      {!#shpwarp},   {!#shpnorm},
            {!#shoot},   {!#ship3},             {!#ship2},
            {!#ship},    {!#light},     {!#force},
            {!#explm12}, {!#explm11},   {!#explm10},
            {!#explm09}, {!#explm08},   {!#explm07},
            {!#explm06}, {!#explm05},   {!#explm04},
            {!#explm03}, {!#explm02},   {!#explm01}
        },
        LD_OTB[][] =
        {
            {!#yride8}, {!#yride7}, {!#yride6}, {!#yride5}, {!#yride4},
            {!#yride3}, {!#yride2}, {!#yride1}, {!#tvr},        {!#tvl},
            {!#tvcorn}, {!#trees},      {!#rride8},     {!#rride7},     {!#rride6},
            {!#rride5}, {!#rride4},     {!#rride3},     {!#rride2},     {!#rride1},
            {!#pride8}, {!#pride7},     {!#pride6},     {!#pride5},     {!#pride4},
            {!#pride3}, {!#pride2},     {!#pride1},     {!#pole2},      {!#hrs8},
            {!#hrs7},   {!#hrs6},       {!#hrs5},       {!#hrs4},       {!#hrs3},
            {!#hrs2},   {!#hrs1},       {!#gride8},     {!#gride7},     {!#gride6},
            {!#gride5}, {!#gride4},     {!#gride3},     {!#gride2},     {!#gride1},
                {!#fen},        {!#bushes},     {!#bride8},     {!#bride7},     {!#bride6},
                {!#bride5},     {!#bride4},     {!#bride3},     {!#bride2},     {!#bride1},
        {!#blue},       {!#bckgrnd}
        },
        LD_OTB2[][] =
        {
            {!#Ric5},  {!#Ric4},        {!#Ric3},       {!#Ric2},       {!#Ric1},
            {!#butnC}, {!#butnBo},      {!#butnB},      {!#butnAo},     {!#butnA},
            {!#backbet}
        },
        LD_PLAN[][] =
        {
            {!#tvcorn},{!#tvbase},{!#blkdot},{!#AirLogo}
        },
        LD_POKE[][] =
        {
            {!#tvcorn}, {!#holdon}, {!#holdoff},
            {!#holdmid}, {!#deal}, {!#cdback},
                {!#cd9s}, {!#cd9h}, {!#cd9d}, {!#cd9c},
            {!#cd8s}, {!#cd8h}, {!#cd8d}, {!#cd8c},
                {!#cd7s}, {!#cd7h}, {!#cd7d}, {!#cd7c},
            {!#cd6s}, {!#cd6h}, {!#cd6d}, {!#cd6c},
            {!#cd5s}, {!#cd5h}, {!#cd5d}, {!#cd5c},
            {!#cd4s}, {!#cd4h}, {!#cd4d}, {!#cd4c},
            {!#cd3s}, {!#cd3h}, {!#cd3d}, {!#cd3c},
            {!#cd2s}, {!#cd2h}, {!#cd2d}, {!#cd2c},
            {!#cd1s}, {!#cd1h}, {!#cd1d}, {!#cd1c},
                {!#cd13s}, {!#cd13h}, {!#cd13d}, {!#cd13c},
            {!#cd12s}, {!#cd12h}, {!#cd12d}, {!#cd12c},
            {!#cd11s}, {!#cd11h}, {!#cd11d}, {!#cd11c},
            {!#cd10s}, {!#cd10h}, {!#cd10d}, {!#cd10c},
            {!#backred}, {!#backcyan}, {!#addcoin}
        },
        LD_POOL[][] =
        {
            {!#nib},
            {!#ball}
        },
        LD_RACE[][] =
        {
            {!#race12}, {!#race11}, {!#race10}, {!#race09}, {!#race08},
            {!#race07}, {!#race06}, {!#race05}, {!#race04}, {!#race03},
            {!#race02}, {!#race01}, {!#race00}
        },
        LD_RCE1[][] =
        {
            {!#race05},{!#race04},{!#race03},{!#race02},{!#race01},{!#race00}
        },
        LD_RCE2[][] =
        {
            {!#race11},{!#race10},{!#race09},{!#race08},{!#race07},{!#race06}
        },
        LD_RCE3[][] =
        {
            {!#race17},{!#race16},{!#race15},{!#race14},{!#race13},{!#race12}
        },
        LD_RCE4[][] =
        {
            {!#race23},{!#race22},{!#race21},{!#race20},{!#race19},{!#race18}
        },
        LD_ROUL[][] =
        {
            {!#roulred},
            {!#roulgre},
            {!#roulbla}
        },
        ld_shtr[][] =
        {
            {!#un_c},  {!#un_b}, {!#un_a}, {!#ufo},  {!#tvr},  {!#tvcorn}, {!#splsh},
        {!#ship},  {!#ps3},      {!#ps2},  {!#ps1},  {!#pm3},  {!#pm2},    {!#pa},
                {!#nmef},  {!#kami}, {!#hi_c}, {!#hi_b}, {!#hi_a}, {!#hbarr},  {!#hbarm},
            {!#fstar}, {!#fire}, {!#ex4},  {!#ex3},  {!#ex2},  {!#ex1},   {!#cbarr},
            {!#cbarm}, {!#cbarl},{!#bstars}
        },
        LD_SLOT[][] =
        {
            {!#r_69}, {!#grapes}, {!#cherry}, {!#bell}, {!#bar2_o}, {!#bar1_o}
        },
        LD_SPAC[][] =
        {
                {!#white},       {!#tvcorn},  {!#thrustG}, {!#shoot},
                {!#rockshp}, {!#power},   {!#light},   {!#layer},
                {!#Health},  {!#ex4},     {!#ex3},         {!#ex2},
                {!#ex1},         {!#DUALITY}, {!#dark},    {!#black},
                {!#backgnd}
        },
        LD_TATT[][] =
        {
            {!#9rasta}, {!#9homby},     {!#9gun2},      {!#9gun},       {!#9crown},     {!#9bullt},
            {!#8westsd},{!#8santos},{!#8sa3},   {!#8sa2},       {!#8sa},        {!#8poker},
            {!#8gun},   {!#7mary},      {!#7cross3},{!#7cross2},{!#7cross},     {!#6crown},
            {!#6aztec}, {!#6africa},{!#6gun},   {!#5gun},       {!#5cross3},{!#5cross2},
            {!#5cross}, {!#4weed},      {!#4spider},{!#4rip},   {!#12myfac},{!#12maybr},
            {!#12dager},{!#12cross},{!#12bndit},{!#12angel},{!#11jail}, {!#11grove},
            {!#11grov3},{!#11grov2},{!#11ggift},{!#11dice2},{!#11dice}, {!#10weed},
                {!#10og},       {!#10ls5},      {!#10ls4},      {!#10ls3},      {!#10ls2},      {!#10ls}
        },
        LOADSCS[][] =
        {
            {!#nvidia},         {!#eax},                {!#title_pc_EU},        {!#title_pc_US},
            {!#laodsc9},        {!#loadsc8},    {!#loadsc7},            {!#loadsc6},
                {!#loadsc5},    {!#loadsc4},    {!#loadsc3},            {!#loadsc2},
            {!#loadsc14},       {!#loadsc13},   {!#loadsc12},           {!#loadsc11},
                {!#loadsc10},   {!#loadsc1},    {!#loadsc0}
        },
    LOADSUK[][] =
    {
        {!#loadscuk},   {!#loadsc9},    {!#loadsc8},    {!#loadsc7},
        {!#loadsc6},    {!#loadsc5},    {!#loadsc4},    {!#loadsc3},
                {!#loadsc2},    {!#loadsc14},   {!#loadsc13},   {!#loadsc12},
                {!#loadsc11},   {!#loadsc10},   {!#loadsc1}
        };

public OnFilterScriptInit()
{
    td_editing = -1;
        print("0Sprites Editor loaded successfully");
        return 1;
}
public OnFilterScriptExit()
{
        for(new t; t < MAX_TEXTDRAWS + 1; t++)
        {
            if(td_i[t][created])
            {
                    TextDrawHideForAll(td_i[t][td]);
                    TextDrawDestroy(td_i[t][td]);
            }
        }
        return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
        switch(dialogid)
        {
        case deletesprite:
                {
                    if(!response)
                                return ShowMainDialog(playerid);

            textdraws--;
            ShowMainDialog(playerid);
                    TextDrawHideForAll(td_i[td_editing][td]);

                        td_i[td_editing][created] = 0;
                        td_i[td_editing][td_y] = 0.0;
                        td_i[td_editing][td_x] = 0.0;
                        td_i[td_editing][td_height] = 0.0;
                        td_i[td_editing][td_width] = 0.0;
                        td_i[td_editing][td_color] = RGB(HexToInt(#FF), HexToInt(#FF), HexToInt(#FF), HexToInt(#FF));
                        format(td_i[td_editing][td_name],30, " ");
                        td_editing = -1;

                }
        }
        if(!response)
        {
                switch(dialogid)
                {
                    case selectcategory, colormethod, deletesprite, spriteshelp, selectsprite: ShowMainDialog(playerid);
                        case colorhex,colorpremade: OnDialogResponse(playerid, main, 1, 5, " ");
                        case addsprite: OnDialogResponse(playerid, main, 1, 1, " ");
                }
    }
    else
        {
                switch(dialogid)
                {
                        case main:
                        {
                            switch(listitem)
                            {
                                case (0):
                                {
                                    new Str[512];
                                    switch(textdraws)
                                                {
                                        case (-1):
                                        {
                                            SendClientMessageEx(playerid, "There are no sprites created.", 0x0);
                                                                ShowMainDialog(playerid);
                                                        }
                                                        default:
                                            {
                                                    for(new t; t < MAX_TEXTDRAWS; t++)
                                                                {
                                                                    if(td_i[t][created])
                                                                    {
                                                                format(Str, sizeof(Str), #%s#%d - %s\n, Str, t, td_i[t][td_name]);
                                                        }
                                                                }
                                                        }
                                                }
                                                ShowPlayerDialog(playerid, selectsprite, DIALOG_STYLE_LIST, "Select sprite", Str, "Select", "Back");
                                }
                                case 1:
                                        {
                                            new Str[512], szUnpack[8];
                        Str = #Insert texture name\n;
                                                for(new t; t < sizeof(sprites); t++)
                                                {
                                                    strunpack(szUnpack, sprites[t]);
                                                format(Str, sizeof(Str), #%s*%s\n, Str, szUnpack);
                                                }
                                                ShowPlayerDialog(playerid, selectcategory, DIALOG_STYLE_LIST, "Select category", Str, "Select", "Back");
                                        }
                                case 2:
                                        {
                                            if(td_editing == -1)
                                            {
                                                        SendClientMessageEx(playerid, "No sprite has been selected!", 0x0);
                                                        ShowMainDialog(playerid);
                                                        return 1;
                                                }

                                            new Str[512];
                                            format(Str, sizeof(Str), "Are you sure you want to delete sprite id #%d?", td_editing);
                                                ShowPlayerDialog(playerid, deletesprite, DIALOG_STYLE_MSGBOX, "Select sprite", Str, "Select", "Back");

                                        }
                                case 3:
                                        {
                                            if(td_editing == -1)
                                            {
                                                        SendClientMessageEx(playerid, "No sprite has been selected!", 0x0);
                                                        ShowMainDialog(playerid);
                                                        return 1;
                                                }

                                            TogglePlayerControllable(playerid, false);
                                                SetPVarInt(playerid, #MovingSprite, 1);
                                                SetPVarInt(playerid, #ResizingSprite, 0);
                                                SendClientMessageEx(playerid, "Moving sprite id {FF0000}%d{FFFFFF}. Use left, right, up and down.", td_editing);
                                                SendClientMessageEx(playerid, "Press {FF0000}enter{FFFFFF} to finish moving.", 0x0);
                                        }
                                case 4:
                                        {
                                            if(td_editing == -1)
                                            {
                                                        SendClientMessageEx(playerid, "No sprite has been selected!", 0x0);
                                                        ShowMainDialog(playerid);
                                                        return 1;
                                                }

                                            TogglePlayerControllable(playerid, false);
                                            SetPVarInt(playerid, #MovingSprite, 0);
                                                SetPVarInt(playerid, #ResizingSprite, 1);
                                            SendClientMessageEx(playerid, "Resizing sprite id {FF0000}%d{FFFFFF}. Use left, right, up and down.", td_editing);
                                                SendClientMessageEx(playerid, "Press {FF0000}enter{FFFFFF} to finish resizing.", 0x0);
                                        }
                                case 5:
                                        {
                                            if(td_editing == -1)
                                            {
                                                        SendClientMessageEx(playerid, "No sprite has been selected!", 0x0);
                                                        ShowMainDialog(playerid);
                                                        return 1;
                                                }

                                                ShowPlayerDialog(playerid, colormethod, DIALOG_STYLE_LIST, "Change color",      "Write a hex code\n\
                                                                                                                                                        Select a pre-made color",\
                                                                                                                                                        #Select, #Back);

                                        }
                                        case 6:
                                        {
                                            switch(textdraws)
                                                {
                                        case (-1):
                                        {
                                            SendClientMessageEx(playerid, "There are no sprites created.", 0x0);
                                                                ShowMainDialog(playerid);
                                                        }
                                                        default: ShowPlayerDialog(playerid, setspritesavename, DIALOG_STYLE_INPUT, #Save sprites, "Insert a name for the file:", #Save, #Back);


                                                }
                                        }
                                }
                        }
                        case setspritesavename:
                        {
                            if(inputtext[0] == EOS)
                            {
                                ShowPlayerDialog(playerid, setspritesavename, DIALOG_STYLE_INPUT, #Save sprites, "{FF0000}No file name inserted!\n\n\
                                                                                                                                                                                                          {a9c4e4}Insert a name for the file:", #Save, #Back);
                                        return 1;
                                }
                                if(!IsValidText(inputtext))
                                {
                                    ShowPlayerDialog(playerid, setspritesavename, DIALOG_STYLE_INPUT, #Save sprites, "{FF0000}Invalid characters:{a9c4e4} \\ / : * \" < > |\n\n\
                                                                                                                                                                                                          {a9c4e4}Insert a name for the file:", #Save, #Back);
                                        return 1;
                                }
                                if(strlen(inputtext) > 50)
                                {
                                    ShowPlayerDialog(playerid, setspritesavename, DIALOG_STYLE_INPUT, #Save sprites, "{FF0000}Invalid lenght.\n\n\
                                                                                                                                                                                                          {a9c4e4}Insert a name for the file:", #Save, #Back);
                                        return 1;
                                }

                                new file[50];
                                format(file, sizeof(file), #%s.txt, inputtext);
                                new File:spritefile = fopen(file, io_append);
                                if(spritefile)
                                {
                                fclose(spritefile);
                                fremove(file);
                                }
                                spritefile = fopen(file, io_append);
                if(spritefile)
                {

                    new fStr[512];
                    fwrite(spritefile, "//0Sprites Editor by Zh3r0\r\n\r\n");
                    fwrite(spritefile, "#include <a_samp>");
                    for(new i; i < MAX_TEXTDRAWS; i++)
                                        {
                                            if(td_i[i][created])
                                            {
                                                format(fStr, sizeof(fStr), "new Text:Sprite%d;\r\n", i);
                                                fwrite(spritefile, fStr);
                                                }
                                        }
                                        fwrite(spritefile, "\r\n\r\n");
                        fwrite(spritefile, "public OnFilterScriptInit()\r\n");
                    fwrite(spritefile, "{\r\n");

                                        for(new i; i < MAX_TEXTDRAWS; i++)
                                        {
                                            if(td_i[i][created])
                                            {
                                                format(fStr, sizeof(fStr), "    Sprite%d = TextDrawCreate(%.3f, %.3f, \"%s\");\r\n", i, td_i[i][td_x], td_i[i][td_y], td_i[i][td_name]);
                                                fwrite(spritefile, fStr);
                                                format(fStr, sizeof(fStr), "    TextDrawFont(Sprite%d, 4);\r\n", i);
                                                fwrite(spritefile, fStr);
                                                format(fStr, sizeof(fStr), "    TextDrawTextSize(Sprite%d, %.3f, %.3f);\r\n", i, td_i[i][td_width], td_i[i][td_height]);
                                                fwrite(spritefile, fStr);
                                                format(fStr, sizeof(fStr), "    TextDrawColor(Sprite%d, %d);\r\n\r\n", i, td_i[i][td_color]);
                                                fwrite(spritefile, fStr);

                                                }
                                        }
                                        fwrite(spritefile, "    return 1;\r\n");
                                        fwrite(spritefile, "}\r\n\r\n\r\n");


                                        fwrite(spritefile, "public OnFilterScriptExit()\r\n");
                                        fwrite(spritefile, "{\r\n");
                                        for(new i; i < MAX_TEXTDRAWS; i++)
                                        {
                                            if(td_i[i][created])
                                            {
                                                format(fStr, sizeof(fStr), "    TextDrawHideForAll(Sprite%d);\r\n", i);
                                                fwrite(spritefile, fStr);
                                                format(fStr, sizeof(fStr), "    TextDrawDestroy(Sprite%d);\r\n", i);
                                                fwrite(spritefile, fStr);
                                                }
                                        }
                                        fwrite(spritefile, "    return 1;\r\n");
                                        fwrite(spritefile, "}\r\n\r\n\r\n");


                                        fwrite(spritefile, "public OnPlayerConnect(playerid)\r\n");
                                        fwrite(spritefile, "{\r\n");
                                        for(new i; i < MAX_TEXTDRAWS; i++)
                                        {
                                            if(td_i[i][created])
                                            {
                                                format(fStr, sizeof(fStr), "    TextDrawShowForPlayer(playerid,Sprite%d);\r\n", i);
                                                fwrite(spritefile, fStr);
                                                }
                                        }
                                        fwrite(spritefile, "    return 1;\r\n");
                                        fwrite(spritefile, "}");
                                        fclose(spritefile);

                                        SendClientMessageEx(playerid, "Sprites saved on file: {FF0000}\"scriptfiles\\%s.txt\"", inputtext);
                                }
                                else
                                {
                                        SendClientMessageEx(playerid, "Opening {FF0000}\"SpritesEditor.txt\" {FFFFFF}has failed.", 0x0);
                                        ShowMainDialog(playerid);
                                }
                        }

                        case colorhex:
                        {
                            //Credits to Zamaroht
                            if(inputtext[0] == '0' && inputtext[1] == 'x')
                {
                    new red[3], green[3], blue[3], alpha[3];
                                    if(strlen(inputtext) != 8 && strlen(inputtext) != 10)
                                    {
                                        ShowPlayerDialog(playerid, colorhex, DIALOG_STYLE_INPUT, "Insert hex color", "Invalid hex format.\n\
                                                                                                                                                                                                          If you need help visit www.colorpicker.com for codes.",\
                                                                                                                                                                                                          #Insert, #Back);
                                                return 1;
                                        }
                                        red[0] = inputtext[2]; red[1] = inputtext[3];
                                        green[0] = inputtext[4]; green[1] = inputtext[5];
                                        blue[0] = inputtext[6]; blue[1] = inputtext[7];

                    if(inputtext[8] != '\0')
                        format(alpha, sizeof(alpha), #%c%c, inputtext[8], inputtext[9]);
                                        else
                                            alpha = #FF;

                                        TextDrawHideForAll(td_i[td_editing][td]);
                                        TextDrawDestroy(td_i[td_editing][td]);

                    td_i[td_editing][td] = TextDrawCreate(td_i[td_editing][td_x], td_i[td_editing][td_y], td_i[td_editing][td_name]);
                                        TextDrawFont(td_i[td_editing][td], 4);
                                        TextDrawTextSize(td_i[td_editing][td], td_i[td_editing][td_width],td_i[td_editing][td_height]);
                    TextDrawColor(td_i[td_editing][td], RGB(HexToInt(red), HexToInt(green), HexToInt(blue), HexToInt(alpha)));

                    TextDrawShowForAll(td_i[td_editing][td]);
                    td_i[td_editing][td_color] = RGB(HexToInt(red), HexToInt(green), HexToInt(blue), HexToInt(alpha));
                    SendClientMessageEx(playerid, "Changed sprite id{FF0000} %d{FFFFFF}'s color.", td_editing);

                                        ShowMainDialog(playerid);
                                }
                                else
                                {
                                    ShowPlayerDialog(playerid, colorhex, DIALOG_STYLE_INPUT, "Insert hex color", "Invalid hex format.\n\
                                                                                                                                                                                                  If you need help visit www.colorpicker.com for codes.",\
                                                                                                                                                                                                  #Insert, #Back);
                                }

                        }
                        case colorpremade:
                        {
                            new red[3], green[3], blue[3], color[7];
                            switch(listitem)
                                {
                                    case 0: color = #Red,        red = #FF, green = #00, blue = #00;
                                    case 1: color = #Green,  red = #00, green = #FF, blue = #00;
                                    case 2: color = #Blue,       red = #00, green = #00, blue = #FF;
                                    case 3: color = #White,  red = #FF, green = #FF, blue = #FF;
                                    case 4: color = #Black,  red = #00, green = #00, blue = #00;
                                    case 5: color = #Pink,       red = #FF, green = #54, blue = #7F;
                                    case 6: color = #Cyan,       red = #00, green = #FF, blue = #F2;
                                    case 7: color = #Yellow, red = #FF, green = #FB, blue = #00;
                                    case 8: color = #Orange, red = #FF, green = #84, blue = #00;
                                }
                                TextDrawHideForAll(td_i[td_editing][td]);
                                TextDrawDestroy(td_i[td_editing][td]);

                td_i[td_editing][td] = TextDrawCreate(td_i[td_editing][td_x], td_i[td_editing][td_y], td_i[td_editing][td_name]);
                                TextDrawFont(td_i[td_editing][td], 4);
                                TextDrawTextSize(td_i[td_editing][td], td_i[td_editing][td_width],td_i[td_editing][td_height]);
                TextDrawColor(td_i[td_editing][td], RGB(HexToInt(red), HexToInt(green), HexToInt(blue), HexToInt(#FF)));

                TextDrawShowForAll(td_i[td_editing][td]);
                td_i[td_editing][td_color] = RGB(HexToInt(red), HexToInt(green), HexToInt(blue), HexToInt(#FF));
                SendClientMessageEx(playerid, "Changed sprite id{FF0000} %d{FFFFFF}'s color.", td_editing);

                                ShowMainDialog(playerid);
                        }
                        case colormethod:
                        {
                                switch(listitem)
                                {
                                    case 0:
                                    {
                                        ShowPlayerDialog(playerid, colorhex, DIALOG_STYLE_INPUT, "Insert hex color", "Insert your desired hex color:\n\
                                                                                                                                                                                                          Note: It must be in 0xFFFFFFFF format.",\
                                                                                                                                                                                                          #Insert, #Back);



                                    }
                                    case 1:
                                    {
                                        ShowPlayerDialog(playerid, colorpremade, DIALOG_STYLE_LIST, "Pre-made colors",  "{FF0000}Red\n\
                                                                                                                                                                        {00FF00}Green\n\
                                                                                                                                                                        {0000FF}Blue\n\
                                                                                                                                                                        {FFFFFF}White\n\
                                                                                                                                                                        {C3C3C3}Black\n\
                                                                                                                                                                        {FF547F}Pink\n\
                                                                                                                                                                                                                {00FFF2}Cyan\n\
                                                                                                                                                                                                                {FFFB00}Yellow\n\
                                                                                                                                                                                                                {FF8400}Orange", \
                                                                                                                                                                                                                #Select, #Back);
                                        }
                                }
                        }

                        case selectsprite:
                        {
                            new d;
                            for(new t; t < MAX_TEXTDRAWS; t ++)
                            {
                                if(td_i[t][created])
                                {
                                    if(d == listitem)
                                                {
                                        td_editing = t;
                                        SendClientMessageEx(playerid, "Selected sprite id {FF0000}%d{FFFFFF}.", td_editing);
                                                        break;
                                                }
                                                d++;
                                        }
                                }

                                ShowMainDialog(playerid);
                        }
                        case addsprite:
                        {
                            textdraws++;
                            new
                                        string[50], szUnpack_[2][30];

                strunpack(szUnpack_[0], sprites[spritelist-1]);
                                switch(spritelist)
                                {
                                    case 1..4, 23, 29..44, 47..50: strdel(SpritesString, 0, 1),format(string, sizeof(string), #%s:%s, szUnpack_[0], SpritesString);
                                        case 5: strunpack(szUnpack_[1], LD_BEAT[listitem]),format(string, sizeof(string), #%s:%s, szUnpack_[0], szUnpack_[1]);
                                        case 6: strunpack(szUnpack_[1], LD_BUM[listitem]),format(string, sizeof(string), #%s:%s, szUnpack_[0], szUnpack_[1]);
                                        case 7: strunpack(szUnpack_[1], LD_CARD[listitem]),format(string, sizeof(string), #%s:%s, szUnpack_[0], szUnpack_[1]);
                                        case 8: strunpack(szUnpack_[1], LD_CHAT[listitem]),format(string, sizeof(string), #%s:%s, szUnpack_[0], szUnpack_[1]);
                                        case 9: strunpack(szUnpack_[1], LD_DRV[listitem]),format(string, sizeof(string), #%s:%s, szUnpack_[0], szUnpack_[1]);
                                        case 10: strunpack(szUnpack_[1], LD_DUAL[listitem]),format(string, sizeof(string), #%s:%s, szUnpack_[0], szUnpack_[1]);
                                        case 11: strunpack(szUnpack_[1], ld_grav[listitem]),format(string, sizeof(string), #%s:%s, szUnpack_[0], szUnpack_[1]);
                                        case 12: strunpack(szUnpack_[1], LD_NONE[listitem]),format(string, sizeof(string), #%s:%s, szUnpack_[0], szUnpack_[1]);
                                        case 13: strunpack(szUnpack_[1], LD_OTB[listitem]),format(string, sizeof(string), #%s:%s, szUnpack_[0], szUnpack_[1]);
                                        case 14: strunpack(szUnpack_[1], LD_OTB2[listitem]),format(string, sizeof(string), #%s:%s, szUnpack_[0], szUnpack_[1]);
                    case 15: strunpack(szUnpack_[1], LD_PLAN[listitem]),format(string, sizeof(string), #%s:%s, szUnpack_[0], szUnpack_[1]);
                    case 16: strunpack(szUnpack_[1], LD_POKE[listitem]),format(string, sizeof(string), #%s:%s, szUnpack_[0], szUnpack_[1]);
                    case 17: strunpack(szUnpack_[1], LD_POOL[listitem]),format(string, sizeof(string), #%s:%s, szUnpack_[0], szUnpack_[1]);
                    case 18: strunpack(szUnpack_[1], LD_RACE[listitem]),format(string, sizeof(string), #%s:%s, szUnpack_[0], szUnpack_[1]);
                    case 19: strunpack(szUnpack_[1], LD_RCE1[listitem]),format(string, sizeof(string), #%s:%s, szUnpack_[0], szUnpack_[1]);
                    case 20: strunpack(szUnpack_[1], LD_RCE2[listitem]),format(string, sizeof(string), #%s:%s, szUnpack_[0], szUnpack_[1]);
                    case 21: strunpack(szUnpack_[1], LD_RCE3[listitem]),format(string, sizeof(string), #%s:%s, szUnpack_[0], szUnpack_[1]);
                    case 22: strunpack(szUnpack_[1], LD_RCE4[listitem]),format(string, sizeof(string), #%s:%s, szUnpack_[0], szUnpack_[1]);
                                        case 24: strunpack(szUnpack_[1], LD_ROUL[listitem]),format(string, sizeof(string), #%s:%s, szUnpack_[0], szUnpack_[1]);
                                        case 25: strunpack(szUnpack_[1], ld_shtr[listitem]),format(string, sizeof(string), #%s:%s, szUnpack_[0], szUnpack_[1]);
                                        case 26: strunpack(szUnpack_[1], LD_SLOT[listitem]),format(string, sizeof(string), #%s:%s, szUnpack_[0], szUnpack_[1]);
                                        case 27: strunpack(szUnpack_[1], LD_SPAC[listitem]),format(string, sizeof(string), #%s:%s, szUnpack_[0], szUnpack_[1]);
                                        case 28: strunpack(szUnpack_[1], LD_TATT[listitem]),format(string, sizeof(string), #%s:%s, szUnpack_[0], szUnpack_[1]);
                    case 45: strunpack(szUnpack_[1], LOADSCS[listitem]),format(string, sizeof(string), #%s:%s, szUnpack_[0], szUnpack_[1]);
                    case 46: strunpack(szUnpack_[1], LOADSUK[listitem]),format(string, sizeof(string), #%s:%s, szUnpack_[0], szUnpack_[1]);

                                }
                                for(new i; i < MAX_TEXTDRAWS; i++)
                {
                                        if(!td_i[i][created])
                                        {
                                                td_editing = i;
                                                format(td_i[i][td_name], 30, string);

                                            td_i[i][td] = TextDrawCreate(250.0, 10.0, string);
                                            TextDrawFont(td_i[i][td], 4);
                                            TextDrawColor(td_i[i][td],0xFFFFFFFF);
                                            TextDrawTextSize(td_i[i][td],100.0,100.0);
                                            TextDrawShowForAll(td_i[i][td]);
                                            ShowMainDialog(playerid);

                                                td_i[i][created] = 1;
                                td_i[i][td_x] = 250.0;
                                td_i[i][td_y] = 10.0;
                                td_i[i][td_width] = 100.0;
                                td_i[i][td_height] = 100.0;
                                td_i[i][td_color] = RGB(HexToInt(#FF), HexToInt(#FF), HexToInt(#FF), HexToInt(#FF));

                                SendClientMessageEx(playerid, "Created sprite {FF0000}%s{FFFFFF}. Default sprite size: {FF0000}100x100", string);
                                break;
                                        }
                                }
                        }
                        case selectcategory:
                        {
                                new
                                        szUnpack[14];
                SpritesString[0] = EOS;
                                switch(listitem)
                                {
                                    case (0):
                                        {
                                                SendClientMessageEx(playerid, "This feature will be available on next versions. Stay tuned",0);
                                                ShowMainDialog(playerid);
                                                /*ShowPlayerDialog(playerid, insertsprite, DIALOG_STYLE_INPUT, #Insert texture name, "You need help inserting a texture?\n\
                                                                                                                                                                                                                        Take a look at: {FFFFFF}/spriteshelp{a9c4e4}",\
                                                                                                                                                                                                                        #Insert, #Back);*/
                                        }
                                    case 1: SpritesString = #*intro1;
                                    case 2: SpritesString = #*intro2;
                                    case 3: SpritesString = #*intro3;
                                    case 4: SpritesString = #*intro4;
                                        case 5:
                                        {
                                            for(new t; t < sizeof(LD_BEAT); t++)
                                                {
                                                    strunpack(szUnpack, LD_BEAT[t]);
                                                format(SpritesString, sizeof(SpritesString), #%s*%s\n, SpritesString, szUnpack);
                                                }
                                        }
                                    case 6:
                                        {
                                            for(new t; t < sizeof(LD_BUM); t++)
                                                {
                                                    strunpack(szUnpack, LD_BUM[t]);
                                                format(SpritesString, sizeof(SpritesString), #%s*%s\n, SpritesString, szUnpack);
                                                }
                                        }
                                    case 7:
                                        {
                                            for(new t; t < sizeof(LD_CARD); t++)
                                                {
                                                    strunpack(szUnpack, LD_CARD[t]);
                                                format(SpritesString, sizeof(SpritesString), #%s*%s\n, SpritesString, szUnpack);
                                                }
                                        }
                                        case 8:
                                        {
                                            for(new t; t < sizeof(LD_CHAT); t++)
                                                {
                                                    strunpack(szUnpack, LD_CHAT[t]);
                                                format(SpritesString, sizeof(SpritesString), #%s*%s\n, SpritesString, szUnpack);
                                                }
                                        }
                                        case 9:
                                        {
                                            for(new t; t < sizeof(LD_DRV); t++)
                                                {
                                                    strunpack(szUnpack, LD_DRV[t]);
                                                format(SpritesString, sizeof(SpritesString), #%s*%s\n, SpritesString, szUnpack);
                                                }
                                        }
                                        case 10:
                                        {
                                            for(new t; t < sizeof(LD_DUAL); t++)
                                                {
                                                    strunpack(szUnpack, LD_DUAL[t]);
                                                format(SpritesString, sizeof(SpritesString), #%s*%s\n, SpritesString, szUnpack);
                                                }
                                        }
                    case 11:
                                        {
                                            for(new t; t < sizeof(ld_grav); t++)
                                                {
                                                    strunpack(szUnpack, ld_grav[t]);
                                                format(SpritesString, sizeof(SpritesString), #%s*%s\n, SpritesString, szUnpack);
                                                }
                                        }
                                        case 12:
                                        {
                                            for(new t; t < sizeof(LD_NONE); t++)
                                                {
                                                    strunpack(szUnpack, LD_NONE[t]);
                                                format(SpritesString, sizeof(SpritesString), #%s*%s\n, SpritesString, szUnpack);
                                                }
                                        }
                                        case 13:
                                        {
                                            for(new t; t < sizeof(LD_OTB); t++)
                                                {
                                                    strunpack(szUnpack, LD_OTB[t]);
                                                format(SpritesString, sizeof(SpritesString), #%s*%s\n, SpritesString, szUnpack);
                                                }
                                        }
                                        case 14:
                                        {
                                            for(new t; t < sizeof(LD_OTB2); t++)
                                                {
                                                    strunpack(szUnpack, LD_OTB2[t]);
                                                format(SpritesString, sizeof(SpritesString), #%s*%s\n, SpritesString, szUnpack);
                                                }
                                        }
                                        case 15:
                                        {
                                            for(new t; t < sizeof(LD_PLAN); t++)
                                                {
                                                    strunpack(szUnpack, LD_PLAN[t]);
                                                format(SpritesString, sizeof(SpritesString), #%s*%s\n, SpritesString, szUnpack);
                                                }
                                        }
                                        case 16:
                                        {
                                            for(new t; t < sizeof(LD_POKE); t++)
                                                {
                                                    strunpack(szUnpack, LD_POKE[t]);
                                                format(SpritesString, sizeof(SpritesString), #%s*%s\n, SpritesString, szUnpack);
                                                }
                                        }
                                        case 17:
                                        {
                                                for(new t; t < sizeof(LD_POOL); t++)
                                                {
                                                    strunpack(szUnpack, LD_POOL[t]);
                                                format(SpritesString, sizeof(SpritesString), #%s*%s\n, SpritesString, szUnpack);
                                                }
                                        }
                                        case 18:
                                        {
                                            for(new t; t < sizeof(LD_RACE); t++)
                                                {
                                                    strunpack(szUnpack, LD_RACE[t]);
                                                format(SpritesString, sizeof(SpritesString), #%s*%s\n, SpritesString, szUnpack);
                                                }
                                        }
                                        case 19:
                                        {
                                            for(new t; t < sizeof(LD_RCE1); t++)
                                                {
                                                    strunpack(szUnpack, LD_RCE1[t]);
                                                format(SpritesString, sizeof(SpritesString), #%s*%s\n, SpritesString, szUnpack);
                                                }
                                        }
                                        case 20:
                                        {
                                            for(new t; t < sizeof(LD_RCE2); t++)
                                                {
                                                    strunpack(szUnpack, LD_RCE2[t]);
                                                format(SpritesString, sizeof(SpritesString), #%s*%s\n, SpritesString, szUnpack);
                                                }
                                        }
                                        case 21:
                                        {
                                            for(new t; t < sizeof(LD_RCE3); t++)
                                                {
                                                    strunpack(szUnpack, LD_RCE3[t]);
                                                format(SpritesString, sizeof(SpritesString), #%s*%s\n, SpritesString, szUnpack);
                                                }
                                        }
                                        case 22:
                                        {
                                            for(new t; t < sizeof(LD_RCE4); t++)
                                                {
                                                    strunpack(szUnpack, LD_RCE4[t]);
                                                format(SpritesString, sizeof(SpritesString), #%s*%s\n, SpritesString, szUnpack);
                                                }
                                        }
                                        case 23: SpritesString = #*race24;
                                        case 24:
                                        {
                                            for(new t; t < sizeof(LD_ROUL); t++)
                                                {
                                                    strunpack(szUnpack, LD_ROUL[t]);
                                                format(SpritesString, sizeof(SpritesString), #%s*%s\n, SpritesString, szUnpack);
                                                }
                                        }
                                        case 25:
                                        {
                                            for(new t; t < sizeof(ld_shtr); t++)
                                                {
                                                    strunpack(szUnpack, ld_shtr[t]);
                                                format(SpritesString, sizeof(SpritesString), #%s*%s\n, SpritesString, szUnpack);
                                                }
                                        }
                                        case 26:
                                        {
                                            for(new t; t < sizeof(LD_SLOT); t++)
                                                {
                                                    strunpack(szUnpack, LD_SLOT[t]);
                                                format(SpritesString, sizeof(SpritesString), #%s*%s\n, SpritesString, szUnpack);
                                                }
                                        }
                                        case 27:
                                        {
                                            for(new t; t < sizeof(LD_SPAC); t++)
                                                {
                                                    strunpack(szUnpack, LD_SPAC[t]);
                                                format(SpritesString, sizeof(SpritesString), #%s*%s\n, SpritesString, szUnpack);
                                                }
                                        }
                                        case 28:
                                        {
                                            for(new t; t < sizeof(LD_TATT); t++)
                                                {
                                                    strunpack(szUnpack, LD_TATT[t]);
                                                format(SpritesString, sizeof(SpritesString), #%s*%s\n, SpritesString, szUnpack);
                                                }
                                        }
                                        case 29: SpritesString = #*load0uk;
                                        case 30: SpritesString = #*loadsc0;
                                        case 31: SpritesString = #*loadsc1;
                                        case 32: SpritesString = #*loadsc2;
                                        case 33: SpritesString = #*loadsc3;
                                        case 34: SpritesString = #*loadsc4;
                                        case 35: SpritesString = #*loadsc5;
                                        case 36: SpritesString = #*loadsc6;
                                        case 37: SpritesString = #*loadsc7;
                                        case 38: SpritesString = #*loadsc8;
                                        case 39: SpritesString = #*loadsc9;
                                        case 40: SpritesString = #*loadsc10;
                                        case 41: SpritesString = #*loadsc11;
                                        case 42: SpritesString = #*loadsc12;
                                        case 43: SpritesString = #*loadsc13;
                                        case 44: SpritesString = #*loadsc14;
                                        case 45:
                                        {
                                            for(new t; t < sizeof(LOADSCS); t++)
                                                {
                                                    strunpack(szUnpack, LOADSCS[t]);
                                                format(SpritesString, sizeof(SpritesString), #%s*%s\n, SpritesString, szUnpack);
                                                }
                                        }
                                        case 46:
                                        {
                                            for(new t; t < sizeof(LOADSUK); t++)
                                                {
                                                    strunpack(szUnpack, LOADSUK[t]);
                                                format(SpritesString, sizeof(SpritesString), #%s*%s\n, SpritesString, szUnpack);
                                                }
                                        }
                                        case 47: SpritesString = #*outro;
                                        case 48: SpritesString = #*splash1;
                                        case 49: SpritesString = #*splash2;
                                        case 50: SpritesString = #*splash3;
                                }
                                spritelist = listitem;
                                ShowPlayerDialog(playerid, addsprite, DIALOG_STYLE_LIST, #Select Sprite, SpritesString, #Select, #Back);
                        }
                }
        }
        return 1;
}
public OnPlayerCommandText(playerid, cmdtext[])
{
        if(!strcmp(cmdtext, #/spriteshelp, true))
        {
            new String[1_200],
                Str1[] = "{FF0000}How to insert a sprite\n\
                                      1.{a9c4e4} It must be in a category:texture format.(EX: LD_BEAT:upr){FF0000}\n\
                                      2.{a9c4e4} If you have trouble inserting one, download TXD Workshop from internet.{FF0000}\n\
                                          3.{a9c4e4} Open TXD Workshop and go to your San Andreas directory and open folder \"models\\txd\"{FF0000}(Open files with TXD Workshop)\n",

                        Str2[] = "4.{a9c4e4} You will see few files there, file name is the category, and what's inside it's the texture name.{FF0000}\n\
                                          5.{a9c4e4} Examples: intro1 file has only 1 texture, which is called also intro1.{FF0000}\n\
                                          {a9c4e4}File:{FF0000}LD_BUM {a9c4e4}Texture:{FF0000} bum2, bum1, blkdot\n\
                                          {a9c4e4}File:{FF0000}LD_RCE1 {a9c4e4}Texture:{FF0000} race05, race04, race03, race02, race01, race00{a9c4e4}\n\n\
                                          And yet you don't understand? Check the forums.({FF0000}www.forums.sa-mp.com{a9c4e4})\n\n",

                        Str3[] = "{FF0000}Category or texture missing from the list?{a9c4e4}\n\
                                Please post in the thread where you downloaded 0Sprites Editor, I will add them.\n\n\
                                {FF0000}Found a bug? Something went wrong?{a9c4e4}\n\
                                Report on the forums in the same thread specified above.";

                strcat(String, Str1, 1_200),strcat(String, Str2, 1_200),strcat(String, Str3, 1_200);
            ShowPlayerDialog(playerid, spriteshelp, DIALOG_STYLE_MSGBOX, #0Sprites editor help center, String, #Back, #);
                return 1;
        }
    if(!strcmp(cmdtext, #/spre, true))
    {
        new cName[30];
                if(td_editing > 0 || td_editing == 0)format(cName, 30, #%s, td_i[td_editing][td_name]);
                else if(td_editing == -1)cName = #No sprite selected!;


        ShowPlayerDialog(playerid, main, DIALOG_STYLE_LIST, cName, #Select sprite\n\
                                                                                                                                        Add sprite\n\
                                                                                                                                        Delete sprite\n\
                                                                                                                                        Move sprite\n\
                                                                                                                                        Resize sprite\n\
                                                                                                                                        Color sprite\n\
                                                                                                                                        Save sprites\n\
                                                                                                                                        "{FF0000}Close",\
                                                                                                                                        #Select, #);
                return 1;
        }
        return 0;
}

stock MoveTextDraw(Keys, dimension, size)
    {
        TextDrawHideForAll(td_i[td_editing][td]);
                TextDrawDestroy(td_i[td_editing][td]);

                switch(dimension)
                {
                    case 0:
                        {
                                if(size)
                                {
                                        if(Keys != KEY_SPRINT)
                                                td_i[td_editing][td_y] += 1.5;
                                        else
                                                td_i[td_editing][td_y] += 10.5;
                                }
                                else
                                {
                                    if(Keys != KEY_SPRINT)
                                                td_i[td_editing][td_y] -= 1.5;
                                        else
                                                td_i[td_editing][td_y] -= 10.5;
                                }
                        }
            case 1:
                        {
                                if(size)
                                {
                                        if(Keys != KEY_SPRINT)
                                                td_i[td_editing][td_x] += 1.5;
                                        else td_i[td_editing][td_x] += 10.5;
                                }
                                else
                                {
                                    if(Keys != KEY_SPRINT)
                                                td_i[td_editing][td_x] -= 1.5;
                                        else
                                                td_i[td_editing][td_x] -= 10.5;
                                }
                        }
                        case 2:
                        {
                                if(size)
                                {
                                        if(Keys != KEY_SPRINT)
                                                td_i[td_editing][td_height] += 1.5;
                                        else
                                                td_i[td_editing][td_height] += 10.5;
                                }
                                else
                                {
                                    if(Keys != KEY_SPRINT)
                                                td_i[td_editing][td_height] -= 1.5;
                                        else
                                                td_i[td_editing][td_height] -= 10.5;
                                }
                        }
                        case 3:
                        {
                                if(size)
                                {
                                        if(Keys != KEY_SPRINT)
                                                td_i[td_editing][td_width] += 1.5;
                                        else
                                                td_i[td_editing][td_width] += 10.5;
                                }
                                else
                                {
                                    if(Keys != KEY_SPRINT)
                                                td_i[td_editing][td_width] -= 1.5;
                                        else
                                                td_i[td_editing][td_width] -= 10.5;
                                }
                        }
                }

                td_i[td_editing][td] = TextDrawCreate(td_i[td_editing][td_x], td_i[td_editing][td_y], td_i[td_editing][td_name]);
                TextDrawFont(td_i[td_editing][td], 4);
                TextDrawTextSize(td_i[td_editing][td], td_i[td_editing][td_width], td_i[td_editing][td_height]);
                TextDrawColor(td_i[td_editing][td], td_i[td_editing][td_color]);
                TextDrawShowForAll(td_i[td_editing][td]);

        }
public OnPlayerUpdate(playerid)
{
        new Keys, ud, lr;
        GetPlayerKeys(playerid, Keys, ud, lr);

    if(ud > 0)
        {
                if(GetPVarInt(playerid, #MovingSprite))MoveTextDraw(Keys, 0, 1);        //Increase Y coords
                else if(GetPVarInt(playerid, #ResizingSprite))MoveTextDraw(Keys, 2, 1); //Increase Heght Size
        }
        else if(ud < 0)
        {
            if(GetPVarInt(playerid, #MovingSprite))MoveTextDraw(Keys, 0, 0);        //Decrease Y coords
                else if(GetPVarInt(playerid, #ResizingSprite))MoveTextDraw(Keys, 2, 0); //Decrease Heght Size
        }
        else if(lr > 0)
        {
                if(GetPVarInt(playerid, #MovingSprite))MoveTextDraw(Keys, 1, 1);        //Increase Y coords
                else if(GetPVarInt(playerid, #ResizingSprite))MoveTextDraw(Keys, 3, 1); //Increase Width Size
        }
        else if(lr < 0)
        {
            if(GetPVarInt(playerid, #MovingSprite))MoveTextDraw(Keys, 1, 0);        //Decrease X coords
                else if(GetPVarInt(playerid, #ResizingSprite))MoveTextDraw(Keys, 3, 0); //Decrease Width Size
        }

        return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
        if(GetPVarInt(playerid, #MovingSprite) || GetPVarInt(playerid, #ResizingSprite))
        {
                if(newkeys & KEY_SECONDARY_ATTACK)
                {
                    SetPVarInt(playerid, #MovingSprite, 0);
                        SetPVarInt(playerid, #ResizingSprite, 0);
                        TogglePlayerControllable(playerid, true);
            SetTimerEx(#ShowMainDialog, 500, false, #i, playerid);
                        SendClientMessageEx(playerid, "Finished moving/resizing sprite id: {FF0000}%d", td_editing);
                }
        }
        return 1;
}
//by Zh3r0.
stock IsValidText(text[])
{
        new Invalid;
        for(new i, l = strlen(text); i != l; i++ )
        {
                switch(text[i])
                {
                    case ':',  '/',  '\\',  '"',  '?',  '*',  '<',  '>',  '|': {Invalid = 1; break;}
                }
        }
        if(Invalid) return false;
        return 1;
}


stock RGB( red, green, blue, alpha )
{
        return (red * 16777216) + (green * 65536) + (blue * 256) + alpha;
}
stock HexToInt(string[])
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
forward ShowMainDialog(playerid);
public ShowMainDialog(playerid) return OnPlayerCommandText(playerid, #/spre);

