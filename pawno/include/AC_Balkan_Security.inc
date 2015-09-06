/*AC-Balkan Security v0.7 R1 by Maki187 (Marko_Dimitrijevic)
http://www.balkan-rising.info/index.php?topic=10.0

http://balkan-samp.com/forum/index.php?topic=35102.0
PLEASE DON'T RENAME ANTICHEAT, AND UNDER THIS TEXT, DON'T CHANGE NOTHING, OR ANTICHEAT WON'T WORK!!*/
#include <a_players>
stock AC_BS_ResetPlayerMoney(playerid)
{
	ResetPlayerMoney(playerid);
	SetPVarInt(playerid, "SafeMoney", 1);
	return 1;
}
stock AC_BS_GivePlayerMoney(playerid, novac)
{
	GivePlayerMoney(playerid, novac);
	SetPVarInt(playerid, "SafeMoney", 1);
	return 1;
}
stock AC_BS_SetPlayerVirtualWorld(playerid, vw)
{
	SetPVarFloat(playerid,"TeleportProtection",1);
	SetPlayerVirtualWorld(playerid,vw);
	SetPVarInt(playerid, "SafeVW", vw);
	return 1;
}
stock AC_BS_SetPlayerInterior(playerid, intid)
{
	SetPVarFloat(playerid,"TeleportProtection",1);
	SetPlayerInterior(playerid, intid);
	SetPVarInt(playerid, "SafeInt", intid);
	return 1;
}
stock AC_BS_SetPlayerPos(playerid, Float:xx, Float:yy, Float:zz)
{
	SetPVarFloat(playerid,"TeleportProtection",1);
	SetPlayerPos(playerid, xx,yy,zz);
	SetPVarInt(playerid, "SafeTeleport", 1);
	return 1;
}
#define acime "[AC-Balkan Security]:"
stock AC_BS_SetPlayerHealth(playerid,Float:helti)
{
	SetPVarFloat(playerid,"HealthProtection",1);
	SetPlayerHealth(playerid,helti);
	SetPVarFloat(playerid,"SafeHealth",helti);
}
stock AC_BS_SetPlayerArmour(playerid,Float:armor)
{
	SetPVarFloat(playerid,"ArmourProtection",1);
	SetPlayerArmour(playerid,armor);
	SetPVarFloat(playerid,"SigurniArmor",armor);
}
#define ACCREDITS SendClientMessage(playerid,BELA, "This server use AntiCheat by: Maki187 (Marko_Dimitrijevic)");
/*ALL RIGHTS Reserved, www.balkan-rising.info (c) 2011-2012
USING THIS ANTICHEAT, YOU AGREE THAT SCRIPTER OF THIS ANTICHEAT IS NOT GUILTY FOR ANI DEMAGE*/