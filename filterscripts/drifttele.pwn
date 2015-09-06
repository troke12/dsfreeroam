#include <a_samp>

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" 53 Drift Teleports By Kitten");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if(strcmp(cmdtext, "/drift11", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid), -771.1682,-100.2281,64.8293);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 290.6883);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, -771.1682,-100.2281,64.8293);
                SetPlayerFacingAngle(playerid, 290.6883);
                SetCameraBehindPlayer(playerid);
        }


        return 1;



}

	if(strcmp(cmdtext, "/drift12", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid), 2847.8616,-758.0251,10.4511);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 357.8184);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 2847.8616,-758.0251,10.4511);
                SetPlayerFacingAngle(playerid, 357.8184);
                SetCameraBehindPlayer(playerid);
        }


        return 1;



}
	if(strcmp(cmdtext, "/drift13", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid), 1246.2567,-2057.4617,59.5055);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 266.6362);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 1239.8492,-2037.4199,59.9314);
                SetPlayerFacingAngle(playerid, 260.3887);
                SetCameraBehindPlayer(playerid);
        }


        return 1;



}
	if(strcmp(cmdtext, "/drift14", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid), 1636.9423,-1154.2665,23.6056);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 357.5793);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 1636.9423,-1154.2665,23.6056);
                SetPlayerFacingAngle(playerid, 357.5793);
                SetCameraBehindPlayer(playerid);
        }


        return 1;



}
	if(strcmp(cmdtext, "/drift15", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),1978.7637,2238.7798,26.8968);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 269.8691);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 1978.7637,2238.7798,26.8968);
                SetPlayerFacingAngle(playerid,  269.8691);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift16", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),-116.2590,819.2222,20.0582);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 199.9199);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, -116.2590,819.2222,20.0582);
                SetPlayerFacingAngle(playerid,  199.9199);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}

	if(strcmp(cmdtext, "/drift17", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),2620.0789,-2406.7498,13.1992);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 269.8561);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 2620.0789,-2406.7498,13.1992);
                SetPlayerFacingAngle(playerid,  269.8561);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift18", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),-318.4155,2518.4719,34.4178);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 276.3857);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, -318.4155,2518.4719,34.4178);
                SetPlayerFacingAngle(playerid,  276.3857);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift19", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),-1994.6610,343.1967,34.7129);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 266.1237);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, -1994.6610,343.1967,34.7129);
                SetPlayerFacingAngle(playerid,  266.1237);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift20", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),-536.4901,1985.9124,59.8858);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 54.5365);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, -536.4901,1985.9124,59.8858);
                SetPlayerFacingAngle(playerid,  54.5365);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift21", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),2560.1799,-1054.5699,69.1088);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 174.5037);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 2560.1799,-1054.5699,69.1088);
                SetPlayerFacingAngle(playerid,  174.5037);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift22", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),2744.8188,-1259.8951,59.2429);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 268.8653);
                        SetCameraBehindPlayer(playerid);
                }
				else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 2744.8188,-1259.8951,59.2429);
                SetPlayerFacingAngle(playerid,  268.8653);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift23", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),664.9158,-1317.3036,13.1367);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 1.9902);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 664.9158,-1317.3036,13.1367);
                SetPlayerFacingAngle(playerid,  1.9902);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift24", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),293.9851,-561.8304,40.3055);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 89.1122);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 293.9851,-561.8304,40.3055);
                SetPlayerFacingAngle(playerid,  89.1122);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift25", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),-1257.1068,-1355.8252,119.8318);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 110.5793);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, -1257.1068,-1355.8252,119.8318);
                SetPlayerFacingAngle(playerid,  110.5793);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift26", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),1277.5319,-601.2232,100.9038);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 353.0812);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 1277.5319,-601.2232,100.9038);
                SetPlayerFacingAngle(playerid,  353.0812);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift27", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),-1810.9692,2685.8086,55.8367);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 76.9332);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, -1810.9692,2685.8086,55.8367);
                SetPlayerFacingAngle(playerid,  76.9332);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift28", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),-1822.0422,2670.2593,54.7437);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 144.0571);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, -1822.0422,2670.2593,54.7437);
                SetPlayerFacingAngle(playerid,  144.0571);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift29", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),1104.5126,815.3459,10.4263);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 305.2941);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 1104.5126,815.3459,10.4263);
                SetPlayerFacingAngle(playerid,  305.2941);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift30", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),2509.8716,1606.4781,10.4566);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 158.8041);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 2509.8716,1606.4781,10.4566);
                SetPlayerFacingAngle(playerid,  158.8041);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift31", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),-1421.2139,-816.0684,80.1159);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 93.0473);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, -1421.2139,-816.0684,80.1159);
                SetPlayerFacingAngle(playerid,  93.0473);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift32", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),-1697.0072,991.5380,17.2838);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 357.3751);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, -1697.0072,991.5380,17.2838);
                SetPlayerFacingAngle(playerid,  357.3751);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift33", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),-2136.3975,919.4185,79.5486);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 268.2998);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, -2136.3975,919.4185,79.5486);
                SetPlayerFacingAngle(playerid,  268.2998);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}

	if(strcmp(cmdtext, "/drift34", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),-1400.5747,-291.2898,5.7002);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 353.6805);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, -1400.5747,-291.2898,5.7002);
                SetPlayerFacingAngle(playerid,  353.6805);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift35", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),1615.3378,-1659.0410,13.2405);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 184.4336);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 1615.3378,-1659.0410,13.2405);
                SetPlayerFacingAngle(playerid,  184.4336);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift36", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),1651.2620,-2599.9829,13.2465);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 269.8469);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 1651.2620,-2599.9829,13.2465);
                SetPlayerFacingAngle(playerid,  269.8469);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift37", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),291.6453,-1489.1570,32.3365);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 50.8979);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 291.6453,-1489.1570,32.3365);
                SetPlayerFacingAngle(playerid,  50.8979);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift38", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),1591.4022,-2192.9214,13.0724);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 88.7810);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 1591.4022,-2192.9214,13.0724);
                SetPlayerFacingAngle(playerid,  88.7810);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift39", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),1360.9453,-2465.1997,7.3572);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 269.3084);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 1360.9453,-2465.1997,7.3572);
                SetPlayerFacingAngle(playerid,  269.3084);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift40", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),-2265.7798,1158.4409,57.0986);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 0.1581);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, -2265.7798,1158.4409,57.0986);
                SetPlayerFacingAngle(playerid,  0.1581);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift41", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),-2119.4114,-349.4402,34.8226);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 270.5172);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, -2119.4114,-349.4402,34.8226);
                SetPlayerFacingAngle(playerid,  270.5172);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift42", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),1476.5244,1758.5297,10.5100);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 181.3618);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 1476.5244,1758.5297,10.5100);
                SetPlayerFacingAngle(playerid,  181.3618);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift43", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),137.5619,1946.4087,19.0599);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 181.3618);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 137.5619,1946.4087,19.0599);
                SetPlayerFacingAngle(playerid,  181.3618);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift44", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),2589.9761,2800.7749,10.3423);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 90.1578);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 2589.9761,2800.7749,10.3423);
                SetPlayerFacingAngle(playerid,  90.1578);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift45", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),1000.0231,2545.3728,10.3403);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 235.6451);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 1000.0231,2545.3728,10.3403);
                SetPlayerFacingAngle(playerid,  235.6451);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift46", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),1322.6106,2236.8350,10.4909);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 2.3974);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 1322.6106,2236.8350,10.4909);
                SetPlayerFacingAngle(playerid,  2.3974);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift47", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),1500.5153,994.9993,10.4639);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 90.1991);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 1500.5153,994.9993,10.4639);
                SetPlayerFacingAngle(playerid,  90.1991);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift48", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),2050.2854,864.9113,6.4736);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 182.3646);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 2050.2854,864.9113,6.4736);
                SetPlayerFacingAngle(playerid,  182.3646);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift49", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),2634.6064,1312.7318,10.4710);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 270.8752);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 2634.6064,1312.7318,10.4710);
                SetPlayerFacingAngle(playerid,  270.8752);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift50", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),1605.4539,2279.6563,10.4743);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 1.3359);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 1605.4539,2279.6563,10.4743);
                SetPlayerFacingAngle(playerid,  1.3359);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift51", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),2080.7761,-1865.9845,13.0337);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 179.1301);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 2080.7761,-1865.9845,13.0337);
                SetPlayerFacingAngle(playerid,  179.1301);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift52", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),1342.4817,-1576.3361,13.0962);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 179.1301);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 1342.4817,-1576.3361,13.0962);
                SetPlayerFacingAngle(playerid,  179.1301);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}
	if(strcmp(cmdtext, "/drift53", true)==0)
{
        if(IsPlayerInAnyVehicle(playerid))
        {
                if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                        SetVehiclePos(GetPlayerVehicleID(playerid),835.6555,-878.2632,68.0216);
                        SetVehicleZAngle(GetPlayerVehicleID(playerid), 238.8432);
                        SetCameraBehindPlayer(playerid);
                }
                else
                {
                        SendClientMessage(playerid,0xFFFF00AA, "ERROR: You need to be the driver!");
                }
        }
        else
        {
                SetPlayerPos(playerid, 835.6555,-878.2632,68.0216);
                SetPlayerFacingAngle(playerid,  238.8432);
                SetCameraBehindPlayer(playerid);
        }
        return 1;
}

	return 0;
}
