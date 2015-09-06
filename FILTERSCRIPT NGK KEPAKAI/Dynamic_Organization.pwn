Introduction:
Hey, first of all, im Rudy and this will be a tutorial regarding a simple Dynamic Organization system i have made a year or two ago.
I had quit scripting a few months ago and now i am back.
Alright, this tutorial is about making an organization A.K.A a faction in game.
This is just the base/basic of the system.
First, of course we need dini.inc to make it work to save files.
pawn Code:
//put this at the beginning of your game mode.
#include <a_samp>
#include <dini>
#include <dudb>
Now, define org.
pawn Code:
#define MAX_ORG 13 //You can add more if you want.
Alright, than we need to define all those members, leaders for playerid.
pawn Code:
enum playerinfo {
Member, //Will tell the server which org you are in..
Leader,
};
new PlayerInfo[MAX_PLAYERS][playerinfo];
new request[MAX_PLAYERS];
After that, Organization also needs to be defined.
pawn Code:
enum orginfo {
Color, //Player color name
VColor, //Vehicle Color
Car1, //Vehicles
Car2, //Vehicles
Car3, //Vehicles..
Car4,
Car5,
Car6,
Car7,
V8, //Max 8 vehicles
Skin1, //orgskin
Skin2, //orgskin
Lskin, //Leaderskin
Genre, //Law , Public Services or Gang.
};
new OrgInfo[MAX_ORGS][orginfo];
Alright, lets go to Gamemodeinit: (This are used to load organization from a savefile that you have created previously.)
pawn Code:
for(new i = 0;i<MAX_ORGS;i++)
{
new tformi[10];
format(tformi,sizeof tformi,"org%d.ini",i);
if(fexist(tformi))
{
printf("-----------------------------");
printf("Loading Organization ID %d Configuration...",i);
OrgInfo[i][Car1] = CreateVehicle(dini_Int(tformi,"Model1"),dini_Float(tformi,"X1"),dini_Float(tformi,"Y1"),dini_Float(tformi,"Z1"),dini_Float(tformi,"A1"),dini_Int(tformi,"Col1"),dini_Int(tformi,"Col2"),-1);
OrgInfo[i][Car2] = CreateVehicle(dini_Int(tformi,"Model2"),dini_Float(tformi,"X2"),dini_Float(tformi,"Y2"),dini_Float(tformi,"Z2"),dini_Float(tformi,"A2"),dini_Int(tformi,"Col1"),dini_Int(tformi,"Col2"),-1);
OrgInfo[i][Car3] = CreateVehicle(dini_Int(tformi,"Model3"),dini_Float(tformi,"X3"),dini_Float(tformi,"Y3"),dini_Float(tformi,"Z3"),dini_Float(tformi,"A3"),dini_Int(tformi,"Col1"),dini_Int(tformi,"Col2"),-1);
OrgInfo[i][Car4] = CreateVehicle(dini_Int(tformi,"Model4"),dini_Float(tformi,"X4"),dini_Float(tformi,"Y4"),dini_Float(tformi,"Z4"),dini_Float(tformi,"A4"),dini_Int(tformi,"Col1"),dini_Int(tformi,"Col2"),-1);
OrgInfo[i][Car5] = CreateVehicle(dini_Int(tformi,"Model5"),dini_Float(tformi,"X5"),dini_Float(tformi,"Y5"),dini_Float(tformi,"Z5"),dini_Float(tformi,"A5"),dini_Int(tformi,"Col1"),dini_Int(tformi,"Col2"),-1);
OrgInfo[i][Car6] = CreateVehicle(dini_Int(tformi,"Model6"),dini_Float(tformi,"X6"),dini_Float(tformi,"Y6"),dini_Float(tformi,"Z6"),dini_Float(tformi,"A6"),dini_Int(tformi,"Col1"),dini_Int(tformi,"Col2"),-1);
OrgInfo[i][Car7] = CreateVehicle(dini_Int(tformi,"Model7"),dini_Float(tformi,"X7"),dini_Float(tformi,"Y7"),dini_Float(tformi,"Z7"),dini_Float(tformi,"A7"),dini_Int(tformi,"Col1"),dini_Int(tformi,"Col2"),-1);
OrgInfo[i][Car8] = CreateVehicle(dini_Int(tformi,"Model8"),dini_Float(tformi,"X8"),dini_Float(tformi,"Y8"),dini_Float(tformi,"Z8"),dini_Float(tformi,"A8"),dini_Int(tformi,"Col1"),dini_Int(tformi,"Col2"),-1);
OrgInfo[i][Genre] = dini_Int(tformi,"Genre");
printf("Organization Cars Loaded.");
printf("Basic Organization Configuration Loaded.");
printf("Loaded Organization, %s",dini_Get(tformi,"Name"));
printf("-----------------------------");
printf("");
}
}
OK , lets go to OnPlayerConnect.
pawn Code:
PlayerInfo[playerid][Member] = -255;
PlayerInfo[playerid][Leader] = 0;
request[playerid] = -255;
You must put this code at your login function/cmd when player sucessfully logged in.
pawn Code:
new name[MAX_PLAYER_NAME];
new file[25];
format(file, sizeof(file), "%s.ini",GetPlayerName(playerid,name,sizeof(name)));
PlayerInfo[playerid][Member] = dini_Int(file,"Member"); //Get saved file
PlayerInfo[playerid][Leader] = dini_Int(file,"Leader"); //Get saved file
Now lets move on to onplayerdisconnect (used to save player files)
pawn Code:
new name[MAX_PLAYER_NAME];
new file[25];
format(file, sizeof(file), "%s.ini",GetPlayerName(playerid,name,sizeof(name)));
if(!fexist(file))
{
dini_Create(file);
}
dini_IntSet(file,"Member",PlayerInfo[playerid][Member]);
dini_IntSet(file,"Leader",PlayerInfo[playerid][Member]);
PlayerInfo[playerid][Member] = -255;
PlayerInfo[playerid][Leader] = 0;
Everything is done! Now lets move on to, The CMDS.
First CMD that we need will be /createorg
(it is used to create org dynamically and save it)
pawn Code:
if(strcmp(cmd,"/createorg",true) == 0)
{
new tmp[256],tmp2[256];
tmp = strtok(cmdtext,idx);
tmp2 = strtok(cmdtext,idx);
new orgid = strval(tmp);
new orggenre = strval(tmp2);
if(!IsPlayerAdmin(playerid)) return 0;
if(!strlen(tmp) || !strlen(tmp2)) return SendClientMessage(playerid,COLOR_ORED,"USAGE: /createorg [orgid] [genre] [name]");
if(orgid > MAX_ORGS) return SendClientMessage(playerid,COLOR_ORED,"Too high. Max org limitation exceed.");
new file[55];
format(file,sizeof file,"org%d.ini",orgid);
if(fexist(file)) return SendClientMessage(playerid,COLOR_ORED,"Organization ID already in use.");
if(orggenre > 3 || orggenre < 1) return SendClientMessage(playerid,COLOR_ORED,"Only 3 genre avaliable.");
new length = strlen(cmdtext);
while ((idx < length) && (cmdtext[idx] <= ' '))
{
idx++;
}
new offset = idx;
new result[64];
while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
{
result[idx - offset] = cmdtext[idx];
idx++;
}
result[idx - offset] = EOS;
dini_Create(file);
dini_Set(file,"Name",result);
dini_IntSet(file,"Genre",orggenre);
dini_IntSet(file,"Ammo",100);
new str2[256];
format(str2,256,"** You have created organization id %d, %s.",orgid,result);
SendClientMessage(playerid,COLOR_YELLOW,str2);
return 1;
}
Alright, after you create the organization base, of course you want a organization vehicle too...
/setorgveh
pawn Code:
if(strcmp(cmd,"/setorgveh",true) == 0)
{
if(!IsPlayerAdmin(playerid)) return 0;
new tmp[256],tmp2[256];
tmp = strtok(cmdtext,idx);
tmp2 = strtok(cmdtext,idx);
if(!strlen(tmp) || !strlen(tmp2)) return SendClientMessage(playerid,COLOR_ORED,"USAGE: /setorgveh [orgid] [car[1-8]]");
if(!IsNumeric(tmp) || !IsNumeric(tmp2)) return SendClientMessage(playerid,COLOR_ORED,"USAGE: /setorgveh [orgid] [car[1-8]]");
new filo[256];
new orgids = strval(tmp);
new cars = strval(tmp2);
if(cars > 8 || cars < 1) return SendClientMessage(playerid,COLOR_ORED,"Car ID 1-8");
format(filo,256,"org%d.ini",orgids);
if(!fexist(filo)) return SendClientMessage(playerid,COLOR_ORED,"Organization ID doesnt exist.");
new Float:X,Float:Y,Float:Z,Float:A;
if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid,COLOR_ORED,"You aren't in any vehicle.");
GetVehiclePos(GetPlayerVehicleID(playerid),X,Y,Z);
GetVehicleZAngle(GetPlayerVehicleID(playerid),A);
if(cars == 1)
{
dini_IntSet(filo,"Model1",GetVehicleModel(GetPlayerVehicleID(playerid)));
dini_FloatSet(filo,"X1",X);
dini_FloatSet(filo,"Y1",Y);
dini_FloatSet(filo,"Z1",Z);
dini_FloatSet(filo,"A1",A);
OrgInfo[orgids][Car1] = CreateVehicle(GetVehicleModel(GetPlayerVehicleID(playerid)),X,Y,Z,A,-1,-1,-1);
}
if(cars == 2)
{
dini_IntSet(filo,"Model2",GetVehicleModel(GetPlayerVehicleID(playerid)));
dini_FloatSet(filo,"X2",X);
dini_FloatSet(filo,"Y2",Y);
dini_FloatSet(filo,"Z2",Z);
dini_FloatSet(filo,"A2",A);
OrgInfo[orgids][Car2] = CreateVehicle(GetVehicleModel(GetPlayerVehicleID(playerid)),X,Y,Z,A,-1,-1,-1);
}
if(cars == 3)
{
dini_IntSet(filo,"Model3",GetVehicleModel(GetPlayerVehicleID(playerid)));
dini_FloatSet(filo,"X3",X);
dini_FloatSet(filo,"Y3",Y);
dini_FloatSet(filo,"Z3",Z);
dini_FloatSet(filo,"A3",A);
OrgInfo[orgids][Car3] = CreateVehicle(GetVehicleModel(GetPlayerVehicleID(playerid)),X,Y,Z,A,-1,-1,-1);
}
if(cars == 4)
{
dini_IntSet(filo,"Model4",GetVehicleModel(GetPlayerVehicleID(playerid)));
dini_FloatSet(filo,"X4",X);
dini_FloatSet(filo,"Y4",Y);
dini_FloatSet(filo,"Z4",Z);
dini_FloatSet(filo,"A4",A);
OrgInfo[orgids][Car4] = CreateVehicle(GetVehicleModel(GetPlayerVehicleID(playerid)),X,Y,Z,A,-1,-1,-1);
}
if(cars == 5)
{
dini_IntSet(filo,"Model5",GetVehicleModel(GetPlayerVehicleID(playerid)));
dini_FloatSet(filo,"X5",X);
dini_FloatSet(filo,"Y5",Y);
dini_FloatSet(filo,"Z5",Z);
dini_FloatSet(filo,"A5",A);
OrgInfo[orgids][Car5] = CreateVehicle(GetVehicleModel(GetPlayerVehicleID(playerid)),X,Y,Z,A,-1,-1,-1);
}
if(cars == 6)
{
dini_IntSet(filo,"Model6",GetVehicleModel(GetPlayerVehicleID(playerid)));
dini_FloatSet(filo,"X6",X);
dini_FloatSet(filo,"Y6",Y);
dini_FloatSet(filo,"Z6",Z);
dini_FloatSet(filo,"A6",A);
OrgInfo[orgids][Car6] = CreateVehicle(GetVehicleModel(GetPlayerVehicleID(playerid)),X,Y,Z,A,-1,-1,-1);
}
if(cars == 7)
{
dini_IntSet(filo,"Model7",GetVehicleModel(GetPlayerVehicleID(playerid)));
dini_FloatSet(filo,"X7",X);
dini_FloatSet(filo,"Y7",Y);
dini_FloatSet(filo,"Z7",Z);
dini_FloatSet(filo,"A7",A);
OrgInfo[orgids][Car7] = CreateVehicle(GetVehicleModel(GetPlayerVehicleID(playerid)),X,Y,Z,A,-1,-1,-1);
}
if(cars ==
{
dini_IntSet(filo,"Model8",GetVehicleModel(GetPlayerVehicleID(playerid)));
dini_FloatSet(filo,"X8",X);
dini_FloatSet(filo,"Y8",Y);
dini_FloatSet(filo,"Z8",Z);
dini_FloatSet(filo,"A8",A);
OrgInfo[orgids][Car8] = CreateVehicle(GetVehicleModel(GetPlayerVehicleID(playerid)),X,Y,Z,A,-1,-1,-1);
}
new sl[256];
format(sl,256,"** You have set vehicle id %d to organization vehicle, %s (Carid:%d).",GetVehicleModel(GetPlayerVehicleID(playerid)),dini_Get(filo,"Name"),cars);
SendClientMessage(playerid,COLOR_MAIN,sl);
return 1;
}
Done? Alright move on to next step which is setting up player name color and also vehicle colors.
(Note, after setting orgcolor, player of the organization must relog to apply changes)
pawn Code:
if(strcmp(cmd,"/setorgskin", true) == 0)
{
if(!IsPlayerAdmin(playerid)) return 0;
new tmp[256],tmp2[256],tmp3[256];
tmp = strtok(cmdtext, idx);
tmp2 = strtok(cmdtext,idx);
tmp3 = strtok(cmdtext,idx);
if(!strlen(tmp) || !strlen(tmp2) || !strlen(tmp3)) return SendClientMessage(playerid,COLOR_ORED,"USAGE: /setorgskin [ORGID] [Skin [1-2]] [SkinID]");
new orgido = strval(tmp);
new wichskin = strval(tmp2);
new skinid = strval(tmp3);
new filo[256];
format(filo,256,"org%d.ini",orgido);
if(!fexist(filo)) return SendClientMessage(playerid,COLOR_ORED,"Organization ID doesnt exist.");
if(wichskin < 1 || wichskin > 2) return SendClientMessage(playerid,COLOR_ORED,"Please choose between 1-2 for skin id.");
if(wichskin == 1)
{
dini_IntSet(filo,"Skin1",skinid);
}
if(wichskin == 2)
{
dini_IntSet(filo,"Skin2",skinid);
}
new stringo[256];
format(stringo,256,"** You have sucessfully changed the skin to skin id %d.",skinid);
SendClientMessage(playerid,COLOR_MAIN,stringo);
return 1;
}
if(strcmp(cmd,"/setorgcol",true) == 0)
{
if(!IsPlayerAdmin(playerid)) return 0;
new tmp[256],tmp2[256];
tmp = strtok(cmdtext,idx);
tmp2 = strtok(cmdtext,idx);
if(!strlen(tmp)) return SendClientMessage(playerid,COLOR_ORED,"USAGE: /setorgcol [orgid] [newcol]");
new format1[256];
new filo[256];
format(filo,256,"org%d.ini",strval(tmp));
if(!fexist(filo)) return SendClientMessage(playerid,COLOR_ORED,"Organization ID doesnt exist.");
format(format1,256,"** You have sucessfully change organization %s color id to %s.",dini_Get(filo,"Name"),tmp2);
SendClientMessage(playerid,COLOR_MAIN,format1);
dini_Set(filo,"Color",tmp2);
return 1;
}
if(strcmp(cmd,"/setorggenre",true) == 0)
{
if(!IsPlayerAdmin(playerid)) return 0;
new tmp[256],tmp2[256];
tmp = strtok(cmdtext,idx);
tmp2 = strtok(cmdtext,idx);
if(!strlen(tmp)) return SendClientMessage(playerid,COLOR_ORED,"USAGE: /setorggenre [orgid] [genre][1-3]");
if(!strlen(tmp2) || strval(tmp2) > 3 || strval(tmp2) < 1) return SendClientMessage(playerid,COLOR_ORED,"Genre 1-3");
if(OrgInfo[strval(tmp)][Genre] == strval(tmp2)) return SendClientMessage(playerid,COLOR_ORED,"That organization is already in this genre.");
new filo[256];
format(filo,55,"org%d.ini",strval(tmp));
if(!fexist(filo)) return SendClientMessage(playerid,COLOR_ORED,"Organization id doesnt exist.");
dini_IntSet(filo,"Genre",strval(tmp2));
OrgInfo[strval(tmp)][Genre] = strval(tmp2);
return 1;
}
if(strcmp(cmd,"/setorgcarcol",true) == 0)
{
if(!IsPlayerAdmin(playerid)) return 0;
new tmp[256],tmp2[256],tmp3[256];
tmp = strtok(cmdtext,idx);
tmp2 = strtok(cmdtext,idx);
tmp3 = strtok(cmdtext,idx);
if(!strlen(tmp) || !strlen(tmp2) || !strlen(tmp3)) return SendClientMessage(playerid,COLOR_ORED,"USAGE: /setorgcol [orgid] [col1] [col2]");
new orgid12 = strval(tmp);
new col1 = strval(tmp2);
new col2 = strval(tmp3);
new filo[256];
format(filo,256,"org%d.ini",orgid12);
if(!fexist(filo)) return SendClientMessage(playerid,COLOR_ORED,"Organization ID doesnt exist.");
dini_IntSet(filo,"Col1",col1);
dini_IntSet(filo,"Col2",col2);
ChangeVehicleColor(OrgInfo[orgid12][Car1],col1,col2);
ChangeVehicleColor(OrgInfo[orgid12][Car2],col1,col2);
ChangeVehicleColor(OrgInfo[orgid12][Car3],col1,col2);
ChangeVehicleColor(OrgInfo[orgid12][Car4],col1,col2);
ChangeVehicleColor(OrgInfo[orgid12][Car5],col1,col2);
ChangeVehicleColor(OrgInfo[orgid12][Car6],col1,col2);
ChangeVehicleColor(OrgInfo[orgid12][Car7],col1,col2);
ChangeVehicleColor(OrgInfo[orgid12][Car8],col1,col2);
SendClientMessage(playerid,COLOR_ORED,"Sucessfully change vehicle color.");
return 1;
}
if(strcmp(cmd,"/setorgname",true) == 0)
{
if(!IsPlayerAdmin(playerid)) return 0;
new tmp[256];
tmp = strtok(cmdtext, idx);
if(!strlen(tmp)) return SendClientMessage(playerid,COLOR_ORED,"UASGE: /setorgname [OrgID] [New Name]");
new filo[256];
format(filo,256,"org%d.ini",strval(tmp));
if(!fexist(filo)) return SendClientMessage(playerid,COLOR_ORED,"That organization ID doesnt exist.");
new length = strlen(cmdtext);
while ((idx < length) && (cmdtext[idx] <= ' '))
{
idx++;
}
new offset = idx;
new result[64];
while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
{
result[idx - offset] = cmdtext[idx];
idx++;
}
result[idx - offset] = EOS;
if(!strlen(result)) return SendClientMessage(playerid,COLOR_ORED,"USAGE: /setorgname [OrgID] [New Name]");
dini_Set(filo,"Name",result);
new fm2[256];
format(fm2,256,"** You have sucessfully changed the organization name to %s.",result);
SendClientMessage(playerid,COLOR_MAIN,fm2);
return 1;
}
Now, the organization chat:
pawn Code:
if(strcmp(cmd, "/oc", true) == 0)
{
if(Member[playerid] == -255) return 0;
new length = strlen(cmdtext);
new playrname[MAX_PLAYERS];
new string[256];
while ((idx < length) && (cmdtext[idx] <= ' '))
{
idx++;
}
new offset = idx;
new result[64];
while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
{
result[idx - offset] = cmdtext[idx];
idx++;
}
result[idx - offset] = EOS;
if(!strlen(result)) return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /oc [text]");
GetPlayerName(playerid, playrname, sizeof(playrname));
format(string,sizeof(string),"OrgChat - %s : %s", playrname,result);
if(Member[playerid] != -255)
{
for(new i=0;i<MAX_PLAYERS;i++)
{ if(IsPlayerConnected(i) && Member[i] == Member[playerid])
SendClientMessage(i,COLOR_MAIN,string);
}
}
return 1;
}
Onplayerspawn
pawn Code:
new filo[55];
format(filo,55,"org%d.ini",Member[playerid]);
SetPlayerColor(ID,HexToInt(dini_Get(filo,"Color")));
And also OnplayerstateChange
(This is to prevent other players that are not in the organization to use the organization car)
pawn Code:
for(new i = 0;i<MAX_ORGS;i++)
{
if(newstate == 2)
{
new filo[55];
format(filo,55,"org%d.ini",i);
if(OrgInfo[i][Car1] == GetPlayerVehicleID(playerid))
{
if(Member[playerid] != i)
{
new str[256];
format(str,sizeof(str),"** Error: You cannot drive a vehicle that belongs to %s.",dini_Get(filo,"Name"));
SendClientMessage(playerid,COLOR_ORED,str);
RemovePlayerFromVehicle(playerid);
return 1;
}
}
if(OrgInfo[i][Car2] == GetPlayerVehicleID(playerid))
{
if(Member[playerid] != i)
{
new str[256];
format(str,sizeof(str),"** Error: You cannot drive a vehicle that belongs to %s.",dini_Get(filo,"Name"));
SendClientMessage(playerid,COLOR_ORED,str);
RemovePlayerFromVehicle(playerid);
return 1;
}
}
if(OrgInfo[i][Car3] == GetPlayerVehicleID(playerid))
{
if(Member[playerid] != i)
{
new str[256];
format(str,sizeof(str),"** Error: You cannot drive a vehicle that belongs to %s.",dini_Get(filo,"Name"));
SendClientMessage(playerid,COLOR_ORED,str);
RemovePlayerFromVehicle(playerid);
return 1;
}
}
if(OrgInfo[i][Car4] == GetPlayerVehicleID(playerid))
{
if(Member[playerid] != i)
{
new str[256];
format(str,sizeof(str),"** Error: You cannot drive a vehicle that belongs to %s.",dini_Get(filo,"Name"));
SendClientMessage(playerid,COLOR_ORED,str);
RemovePlayerFromVehicle(playerid);
return 1;
}
}
if(OrgInfo[i][Car5] == GetPlayerVehicleID(playerid))
{
if(Member[playerid] != i)
{
new str[256];
format(str,sizeof(str),"** Error: You cannot drive a vehicle that belongs to %s.",dini_Get(filo,"Name"));
SendClientMessage(playerid,COLOR_ORED,str);
RemovePlayerFromVehicle(playerid);
return 1;
}
}
if(OrgInfo[i][Car6] == GetPlayerVehicleID(playerid))
{
if(Member[playerid] != i)
{
new str[256];
format(str,sizeof(str),"** Error: You cannot drive a vehicle that belongs to %s.",dini_Get(filo,"Name"));
SendClientMessage(playerid,COLOR_ORED,str);
RemovePlayerFromVehicle(playerid);
return 1;
}
}
if(OrgInfo[i][Car7] == GetPlayerVehicleID(playerid))
{
if(Member[playerid] != i)
{
new str[256];
format(str,sizeof(str),"** Error: You cannot drive a vehicle that belongs to %s.",dini_Get(filo,"Name"));
SendClientMessage(playerid,COLOR_ORED,str);
RemovePlayerFromVehicle(playerid);
return 1;
}
}
if(OrgInfo[i][Car8] == GetPlayerVehicleID(playerid))
{
if(Member[playerid] != i)
{
new str[256];
format(str,sizeof(str),"** Error: You cannot drive a vehicle that belongs to %s.",dini_Get(filo,"Name"));
SendClientMessage(playerid,COLOR_ORED,str);
RemovePlayerFromVehicle(playerid);
return 1;
}
}
}
}
/setmember for leader...
pawn Code:
if(strcmp(cmd,"/setmember",true) == 0)
{
new tmp[256];
tmp = strtok(cmdtext, idx);
if(Leader[playerid] == 0) return 0;
new ID = strval(tmp);
if(!strlen(tmp)) return SendClientMessage(playerid,COLOR_ORED,"USAGE: /setmember [ID]");
if(!IsPlayerConnected(ID)) return SendClientMessage(playerid,COLOR_ORED,"That folllowing player is not connected!");
if(request[ID] == -255) return SendClientMessage(playerid,COLOR_ORED,"That following player is not requesting to join your organization.");
if(Member[ID] != -255) return SendClientMessage(playerid,COLOR_ORED,"That player is already in an organization.");
if(request[ID] != Member[playerid]) return SendClientMessage(playerid,COLOR_ORED,"That player is not requesting to join your organization.");
Member[ID] = Member[playerid];
request[ID] = -255;
Leader[ID] = 0;
SendClientMessage(ID,COLOR_MAIN,"The organization that you requested to join has been approved.");
SendClientMessage(playerid,COLOR_GREEN,"You have accepted that following player into your organization.");
SetPlayerColor(ID,HexToInt(dini_Get(filo,"Color")));
return 1;
}
/resign for org player.s. & /setleader for admins
pawn Code:
if(strcmp(cmd,"/resign",true) == 0)
{
if(Member[playerid] == -255) return 0;
if(Leader[playerid] == 1)
{
SendClientMessage(playerid,COLOR_ORED,"You are a leader. You cant resign from your organization. Get an admin to remove your leadership and set a new leader for this organization.");
return 1;
}
SendClientMessage(playerid,COLOR_YELLOW,"** You have sucessfully resigned from your organization.");
SetPlayerColor(playerid,0xFFFFFFFF); //Default color for orgless players
SetPlayerSkin(playerid,0); //You can set any skin you want..
Member[playerid] = -255;
return 1;
}
if(strcmp(cmd,"/setleader",true) == 0)
{
new tmp[256], tmp2[256];
tmp = strtok(cmdtext, idx);
tmp2 = strtok(cmdtext, idx);
if(!IsPlayerAdmin) return 0;
if(!strlen(tmp) || !strlen(tmp2))
{
SendClientMessage(playerid,COLOR_ORED,"USAGE: /setleader [ID] [OrgID]");
return 1;
}
new ID = strval(tmp);
new OrgID = strval(tmp2);
new filo[256];
format(filo,sizeof(filo),"org%d.ini",OrgID);
if(Member[ID] != -255) return SendClientMessage(playerid,COLOR_ORED,"You can't set a leader that is in an organization.");
if(!fexist(filo)) return SendClientMessage(playerid,COLOR_ORED,"Organization IDs never exist.");
new form[256];
new nama[55];
new nama2[55];
GetPlayerName(ID,nama2,55);
GetPlayerName(playerid,nama,55);
format(form,sizeof(form),"** Admin %s has set you the leader of %s.",nama,dini_Get(filo,"Name"));
SendClientMessage(ID,COLOR_YELLOW,form);
OrgInfo[OrgID][Count]++;
Member[ID] = OrgID;
Leader[ID] = 1;
request[ID] = -255;
return 1;
}
And finally ! /request and /cancelrequest to join organization !
pawn Code:
if(strcmp(cmd, "/request", true) == 0)
{
new orgcounting = 0;
new tmp[256];
tmp = strtok(cmdtext, idx);
if(!strlen(tmp))
{
SendClientMessage(playerid,COLOR_LIGHTGREEN,"-------- Organization List ---------");
new strr[256];
for(new i = 0;i<MAX_ORGS;i++)
{
new tformi[256];
format(tformi,sizeof tformi,"org%d.ini",i);
if(fexist(tformi))
{
format(strr,256,"%s - Organization ID: %d || Leader: %s",dini_Get(tformi,"Name"),i,dini_Get(tformi,"Leader"));
SendClientMessage(playerid,COLOR_WHITE,strr);
orgcounting++;
}
if(orgcounting == 0)
{
SendClientMessage(playerid,COLOR_GREY,"We're sorry but theres no organization created at the moment.");
return 1;
}
}
SendClientMessage(playerid,COLOR_ORED,"USAGE: /request [orgid]");
return 1;
}
if(!IsNumeric(tmp))
{
SendClientMessage(playerid,COLOR_LIGHTGREEN,"-------- Organization List ---------");
new strr[256];
for(new i = 0;i<MAX_ORGS;i++)
{
new tformi[256];
format(tformi,sizeof tformi,"org%d.ini",i);
if(fexist(tformi))
{
format(strr,256,"%s - Organization ID: %d || Leader: %s",dini_Get(tformi,"Name"),i,dini_Get(tformi,"Leader"));
SendClientMessage(playerid,COLOR_WHITE,strr);
orgcounting++;
}
if(orgcounting == 0) return SendClientMessage(playerid,COLOR_GREY,"We're sorry but theres no organization created at the moment.");
}
SendClientMessage(playerid,COLOR_ORED,"Error: Organization ID must be number.");
return 1;
}
new filo[256];
format(filo,256,"org%d.ini",strval(tmp));
if(!fexist(filo))
{
SendClientMessage(playerid,COLOR_LIGHTGREEN,"-------- Organization List ---------");
new strr[256];
for(new i = 0;i<MAX_ORGS;i++)
{
new tformi[256];
format(tformi,sizeof tformi,"org%d.ini",i);
if(fexist(tformi))
{
format(strr,256,"%s - Organization ID: %d || Leader: %s",dini_Get(tformi,"Name"),i,dini_Get(tformi,"Leader"));
SendClientMessage(playerid,COLOR_WHITE,strr);
orgcounting++;
}
if(orgcounting == 0) return SendClientMessage(playerid,COLOR_GREY,"We're sorry but theres no organization created at the moment.");
}
SendClientMessage(playerid,COLOR_ORED,"Error: Organization ID is not valid.");
return 1;
}
if(fexist(filo))
{
for(new i = 0; i < MAX_PLAYERS; i++)
{
if(IsPlayerConnected(i) && Leader[i] == 1 && Member[i] == strval(tmp))
{
if(request[playerid] != -255) return SendClientMessage(playerid,COLOR_ORED,"You are already requesting to join an organization.");
if(Member[playerid] != -255) return SendClientMessage(playerid,COLOR_ORED,"You are already in an organization.");
new stringa[256];
new nama[MAX_PLAYER_NAME];
GetPlayerName(playerid,nama,MAX_PLAYER_NAME);
format(stringa,256,"** %s is requesting to join %s.",nama,dini_Get(filo,"Name"));
SendClientMessageToAll(COLOR_MAIN,stringa);
request[playerid] = strval(tmp);
new strin[256];
format(strin,256,"[Request] %s is requesting to join your organization. /setmember to accept || /decline to reject.",nama);
SendClientMessage(i,COLOR_WHITE,strin);
return 1;
}
else
{
SendClientMessage(playerid,COLOR_ORED,"Error: The Organization Leader appears to be offline.");
return 1;
}
}
return 1;
}
return 1;
}
if(strcmp(cmd,"/cancelrequest",true) == 0)
{
new form[256];
new nama[MAX_PLAYER_NAME];
GetPlayerName(playerid,nama,sizeof(nama));
new file[256];
format(file,256,"org%d.ini",request[playerid]);
if(!fexist(file))
{
SendClientMessage(playerid,COLOR_ORED,"That organization doesn't exist anymore.");
request[playerid] = -255;
return 1;
}
format(form,256,"** %s has cancel his/her request to join %s.",nama,dini_Get(file,"Name"));
SendClientMessageToAll(COLOR_MAIN,form);
request[playerid] = -255;
return 1;
}
Here are some colors if you have some error with the colors.
pawn Code:
#DEFINE COLOR_ORED 0xFF0000FF
#define COLOR_MAIN 0x43C6DBFF
#define COLOR_GREEN 0x00FF00FF
#define COLOR_WHITE 0xFFFFFFFF
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_RED 0xAA3333AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_POWDERBLUE 0xB0E0E6FF
#define COLOR_BLUE 0x0000BBAA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_GOLD 0xFFD700FF
#define COLOR_LIGHTGREEN 0x90EE90FF
If you have any problems, feel free to reply or pm me. Thank you
Credits: Me & whoever made dini.inc and SA-MP forum
HexToInt
pawn Code:
stock HexToInt(string[])
{
if (string[0]==0) return 0;
new i;
new cur=1;
new res=0;
for (i=strlen(string);i>0;i--)
{
if (string[i-1]<58) res=res+cur*(string[i-1]-48); else res=res+cur*(string[i-1]-65+10);
cur=cur*16;
}
return res;
}
If you understand the codes above, you will be able to add weapons for org ect.
i forgot /oskin
pawn Code:
if(strcmp(cmd, "/oskin", true) == 0)
{
if(Member[playerid] == -255) return 0;
new filo[256];
format(filo,256,"org%d.ini",Member[playerid]);
if(GetPlayerSkin(playerid) != dini_Int(filo,"Skin1"))
{
SetPlayerSkin(playerid, dini_Int(filo,"Skin1"));
SetPlayerColor(playerid,HexToInt(dini_Get(filo,"Color")));
return 1;
}
if(GetPlayerSkin(playerid) == dini_Int(filo,"Skin1"))
{
SetPlayerSkin(playerid, dini_Int(filo,"Skin2"));
return 1;
}
return 1;
}
