#include <a_samp>
#include <DOF2>
//====Defines
#define Dialog_Weapon 555
//====Defines

//====New And enum
new str[128],strDialog[5000];
enum WInfo
{
WeaponNum[5],
Color[12],
WeaponName[500],
WeaponID,
WeaponPrice,
WeaponAmmu
}
new Weapon[][WInfo] ={
// Knife
{"01","{00CCFF}","Baseball Bat",5,800,1},
{"02","{00CCFF}","Golf Club     ",2,200,1},
{"03","{00CCFF}","Knife ",4,400,1},
{"04","{00CCFF}","Katana        ",8,800,1},
{"05","{00CCFF}","NightStick    ",3,1000,1},
// Guns
{"06","{33CC00}","Pistol        ",23,3200,60},
{"07","{33CC00}","Silenced Pistol",22,5000,60},
{"08","{33CC00}","Desert Eagle",24,2500,30},
// Easy Weapons
{"09","{FFFF00}","Tec-9 ",32,1500,400},
{"10","{FFFF00}","Micro Uzi     ",28,2000,400},
{"11","{FFFF00}","MP5           ",29,1700,300},
//Heavy Weapons
{"12","{FF9900}","Shotgun       ",25,2200,20},
{"13","{FF9900}","Combat Shotgun",27,3500,100},
{"14","{FF9900}","Sawn Of Shotgun",26,4200,200},
//Sniper / Quick Weapons
{"15","{660033}","AK-4  ",30,4000,200},
{"16","{660033}","M4            ",31,5000,200},
{"17","{660033}","Rifle "       ,33,4000,30},
{"18","{660033}","Sniper Rifle  ",34,7500,20}
};
//====New And enum
main()
{
        print("\n----------------------------------");
        print(" Weapon System By SwiZzoR");
        print("----------------------------------\n");
}

public OnGameModeExit()
{
    DOF2_Exit();
    return 1;
}

public OnPlayerConnect(playerid)
{
        if(!DOF2_FileExists(WFile(playerid)))
        {
                DOF2_CreateFile(WFile(playerid));
                for(new i;i<sizeof(Weapon);i++)
                {
                    DOF2_SetBool(WFile(playerid), Weapon[i][WeaponName], false);
                    DOF2_SaveFile();
                }
        }
        return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    DOF2_SaveFile();
    return 1;
}

public OnPlayerSpawn(playerid)
{
        ResetPlayerWeapons(playerid);
        for(new i;i < sizeof(Weapon);i++)
        {
                if(DOF2_GetBool(WFile(playerid),Weapon[i][WeaponName]) == true) GivePlayerWeapon(playerid,Weapon[i][WeaponID],Weapon[i][WeaponAmmu]);
        }
        return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
        if (strcmp("/wepsmenu", cmdtext, true, 10) == 0)
        {
            for(new i;i<sizeof(Weapon);i++)
            {
                format(str,sizeof(str),"%s.%s %s{FFFFFF}\tPrice: $%d\tAmmu: %d\n",Weapon[i][WeaponNum],Weapon[i][Color],Weapon[i][WeaponName],Weapon[i][WeaponPrice],Weapon[i][WeaponAmmu]);
                strcat(strDialog,str);
            }
            ShowPlayerDialog(playerid,Dialog_Weapon,DIALOG_STYLE_LIST,"List of Weapons",strDialog,"Buy","Exit");
            strDialog[0] = EOS;
            return 1;
        }
        return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
        if(dialogid == Dialog_Weapon && response)
        {
            if(GetPlayerMoney(playerid) < Weapon[listitem][WeaponPrice]) return SendClientMessage(playerid,0xFF0000FF,"You do not have enough money");
            if(listitem < 5) for(new i;i<5;i++) DOF2_SetBool(WFile(playerid), Weapon[i][WeaponName], false);
            if(listitem > 4 && listitem < 8) for(new i=5;i<8;i++) DOF2_SetBool(WFile(playerid), Weapon[i][WeaponName], false);
            if(listitem > 7 && listitem < 11) for(new i=8;i<11;i++) DOF2_SetBool(WFile(playerid), Weapon[i][WeaponName], false);
            if(listitem > 10 && listitem < 14) for(new i=11;i<14;i++) DOF2_SetBool(WFile(playerid), Weapon[i][WeaponName], false);
            if(listitem > 13) for(new i=14;i<17;i++) DOF2_SetBool(WFile(playerid), Weapon[i][WeaponName], false);
            GivePlayerWeapon(playerid,Weapon[listitem][WeaponID],Weapon[listitem][WeaponAmmu]);
            GivePlayerMoney(playerid,-Weapon[listitem][WeaponPrice]);
            DOF2_SetBool(WFile(playerid),Weapon[listitem][WeaponName],true);
            DOF2_SaveFile();
        }
        return 1;
}

stock WFile(playerid)
{
        new file[256];
        format(file,sizeof(file),"Weapon/%s.ini",GetName(playerid));
        return file;
}

stock GetName(playerid)
{
        new name[MAX_PLAYER_NAME+1];
        GetPlayerName(playerid,name,sizeof(name));
        return name;
}
