#include <a_samp>
#include <sscanf>
new Float:RandomSpawns[][4] ={
//{X, Y, Z, Facing Angle}
{-2044.510498, -93.922088, 35.171798, 4.164523},// coordenada 1
{-2723.190185, -316.763244, 7.187500, 45.850116},//coordenada 2
{-1978.428222, 472.978271, 35.166126,88.500007},//cordinate 3
{-1604.077270, 719.774047, 11.703122, 278.078674},//coordenada 4


public OnPlayerSpawn(playerid);
{
new rand = random(sizeof(RandomSpawns));
SetPlayerPos(playerid, RandomSpawns[rand][0], RandomSpawns[rand][1],RandomSpawns[rand][2]);
SetPlayerFacingAngle(playerid, RandomSpawns[rand][3]);
SetPlayerInterior(playerid,0);
return 1;
}
