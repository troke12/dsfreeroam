#include <a_samp>
#include <sscanf2>
//===============MODIFICABILI
#define TELEPORT_TO_START // Comment to disable teleport to the starting checkpoint
#define MAX_GARE              1000
#define MAX_CHECKPOINT        1000
//===============COLORI
#define ROSSO    			  0xFF3233FF
#define BIANCO   			  0xFFFFFFFF
#define VERDE                 0x00FF00FF
#define TURCHESE              0x3C93FFFF
//================DIALOG
#define DIALOGGARE            8016
#define DIALOGINFO            8017
#define DIALOGINFOCOSTRUTTORE 8018
#define DIALOGNOMEGARA        8019
#define DIALOGGIRIGARA        8020
#define DIALOGCOSTOGARA       8021
#define DIALOGINFOGARA2       8022
#define DIALOGINSEGUIMENTO    8023
//=========================FORWARD
forward Tre(playerid);
forward Due(playerid);
forward Uno(playerid);
forward Via(playerid);
forward Secondo(playerid);
forward Cronometro(playerid);
//=========================VARIABILIGIOCATORE
enum InfoGiocatore{IdGara,Tempo,Giro,Checkpoint,Pronto,Costruttore,GaraEditorId,AttivaCheck,Inseguitore,Punti};
new Giocatore[MAX_PLAYERS][InfoGiocatore];
new Float:XPosizione,Float:YPosizione,Float:ZPosizione;
new nome[500];
//==============VARIABILIGARE
enum InfoGara{Nome[50],Giri,NumeroCheckpoint,Inseguimento,Costo,Partecipanti,PartecipantiPronti,Avviata,Record,GiocatoreRecord[25],Produttore[25],Podio};
new Gara[MAX_GARE][InfoGara];
enum CheckInfo{Float:CXPos,Float:CYPos,Float:CZPos};
new CheckpointGara[MAX_GARE][MAX_CHECKPOINT][CheckInfo];
new TimerPlayers[MAX_PLAYERS];
new GareCaricate,GareEditor;
//=============VARIABILI
new stringa[9000],stringa2[500];
new stringagara[500];
//============TEXTDRAW
new Text:sfondo,Text:sfondorosso,Text:sfondogiallo,Text:sfondoverde,Text:rossoacceso,Text:gialloacceso,Text:verdeacceso; //Textdraw semaforo
new Text:TimerSfondo,Text:TimerText[MAX_PLAYERS]; //Timer textdraw
new Text:TextGiriSfondo,Text:TextGiriContatore[MAX_PLAYERS]; //Textdraw laps
new Text:TextSfondoInseguimento,Text:SfondoInseguimentoRosso,Text:SfondoInseguimentoGiallo,Text:SfondoInseguimentoVerde,Text:SfondoInseguimentoAzzurro,Text:TextInseguimento,Text:TextPessimo,Text:TextMediocre,Text:TextBuono,Text:TextOttimo,Text:TextPunti[MAX_PLAYERS];
//====================================================================
stock CaricaGare()
{
   for(new i=0;i<MAX_GARE;i++)
   {
	   //==============
	   format(stringa,sizeof(stringa),"Races/Race%d.txt",i);
	   format(stringa2,sizeof(stringa2),"Race %d not found. This race cannot be loaded.",i);
	   if(!fexist(stringa)) return printf(stringa2);
	   new File:nomegara=fopen(stringa, io_read);
	   fread(nomegara,stringagara);
	   fclose(nomegara);
       sscanf(stringagara,"p<,>s[50]ddds[24]s[24]d",Gara[i][Nome],Gara[i][Giri],Gara[i][Costo],Gara[i][Record],Gara[i][GiocatoreRecord],Gara[i][Produttore],Gara[i][Inseguimento]);
	   Gara[i][NumeroCheckpoint]=-1;
	   format(stringa,sizeof(stringa),"%s,%d,%d$,%s,%s",Gara[i][Nome],Gara[i][Giri],Gara[i][Costo],Gara[i][GiocatoreRecord],Gara[i][Produttore]);
	   printf(stringa);
	   //================
	   format(stringagara,sizeof(stringagara),"");
	   format(stringa,sizeof(stringa),"Races/Check%d.txt",i);
	   format(stringa2,sizeof(stringa2),"Checkpoint list for Race %d not found. This race cannot be loaded.",i);
	   if(!fexist(stringa)) return printf(stringa2);
	   nomegara=fopen(stringa, io_read);
	   print("____________________________________");
	   for(new j=0;j<MAX_CHECKPOINT;j++)
		{
	        fread(nomegara,stringagara);
            sscanf(stringagara,"p<,>fff",CheckpointGara[i][j][CXPos],CheckpointGara[i][j][CYPos],CheckpointGara[i][j][CZPos]);
			if(CheckpointGara[i][j][CXPos]==0) {printf("%d checkpoints loaded for Race %d.",Gara[i][NumeroCheckpoint]+1,i);break;}
		    Gara[i][NumeroCheckpoint]++;
		}
       fclose(nomegara);
	   GareCaricate=i;
	   GareEditor=i;
	   print("____________________________________");
   }
   return 1;
}
//====================================================================
stock SalvaGare()
{
   for(new i=0;i<GareCaricate;i++)
   {
	   format(stringa,sizeof(stringa),"Races/Race%d.txt",i);
	   format(stringa2,sizeof(stringa2),"Race %d not found. Failed to save this race.",i);
	   if(!fexist(stringa)) return printf(stringa2);
	   new File:nomegara=fopen(stringa, io_write);
	   format(stringagara,sizeof(stringagara),"%s,%d,%d,%d,%s,%s,%d",Gara[i][Nome],Gara[i][Giri],Gara[i][Costo],Gara[i][Record],Gara[i][GiocatoreRecord],Gara[i][Produttore],Gara[i][Inseguimento]);
	   fwrite(nomegara,stringagara);
	   fclose(nomegara);
   }
   return 1;
}
//=====================================================================
stock AvviaGara(idGara)
{
  format(stringa,sizeof(stringa),"[RACE:] Race {446ED1}%s{FFFFFF} starts!",Gara[idGara][Nome]);
  SendClientMessageToAll(BIANCO,stringa);
  Gara[idGara][Avviata]=1;
  for(new i=0;i<MAX_PLAYERS;i++)
  {
	  if(Giocatore[i][IdGara]==idGara)
	   {
		   TogglePlayerControllable(i,0);
		   TextDrawShowForPlayer(i,sfondo);
		   TextDrawShowForPlayer(i,sfondorosso);
		   TextDrawShowForPlayer(i,sfondogiallo);
		   TextDrawShowForPlayer(i,sfondoverde);
		   TextDrawShowForPlayer(i,rossoacceso);
		   if(Gara[Giocatore[i][IdGara]][Inseguimento])
		   {
			    TextDrawShowForPlayer(i,TextSfondoInseguimento);
			    TextDrawShowForPlayer(i,SfondoInseguimentoRosso);
			    TextDrawShowForPlayer(i,SfondoInseguimentoGiallo);
			    TextDrawShowForPlayer(i,SfondoInseguimentoVerde);
			    TextDrawShowForPlayer(i,SfondoInseguimentoAzzurro);
			    TextDrawShowForPlayer(i,TextInseguimento);
			    TextDrawShowForPlayer(i,TextPessimo);
			    TextDrawShowForPlayer(i,TextMediocre);
			    TextDrawShowForPlayer(i,TextBuono);
			    TextDrawShowForPlayer(i,TextOttimo);
			    TextDrawSetString(TextPunti[i],"Points: 0000");
			    TextDrawShowForPlayer(i,TextPunti[i]);
		   }
		   SetTimerEx("Tre",1000,false,"idx",i);
	   }
  }
  return 1;
}
//===========================================================================TRE
public Tre(playerid)
{
	 GameTextForPlayer(playerid,"~r~3",1000,3);
	 SuonoGiocatore(playerid,1056);
	 Giocatore[playerid][Tempo]=0;
	 Giocatore[playerid][Giro]=1;
	 format(stringa,sizeof(stringa),"Laps: 1/%d",Gara[Giocatore[playerid][IdGara]][Giri]);
	 TextDrawSetString(TextGiriContatore[playerid],stringa);
	 TextDrawSetString(TimerText[playerid],"00:00");
	 GetPlayerPos(playerid,XPosizione,YPosizione,ZPosizione);
	 SetPlayerCameraPos(playerid,XPosizione+4,YPosizione+2,ZPosizione+3);
	 SetPlayerCameraLookAt(playerid,XPosizione,YPosizione,ZPosizione);
	 TextDrawShowForPlayer(playerid,TimerSfondo);
	 TextDrawShowForPlayer(playerid,TimerText[playerid]);
	 TextDrawShowForPlayer(playerid,TextGiriSfondo);
	 TextDrawShowForPlayer(playerid,TextGiriContatore[playerid]);
	 SetTimerEx("Due",1000,false,"idx",playerid);
}
//===========================================================================DUE
public Due(playerid)
{
	 GameTextForPlayer(playerid,"~r~3~n~~y~2",1000,3);
	 SuonoGiocatore(playerid,1056);
	 GetPlayerPos(playerid,XPosizione,YPosizione,ZPosizione);
	 SetPlayerCameraPos(playerid,XPosizione-4,YPosizione-2,ZPosizione+3);
	 SetPlayerCameraLookAt(playerid,XPosizione,YPosizione,ZPosizione);
	 SetTimerEx("Uno",1000,false,"idx",playerid);
}
//===========================================================================UNO
public Uno(playerid)
{
	 GameTextForPlayer(playerid,"~r~3~n~~y~2~n~~g~~h~1",1000,3);
	 SuonoGiocatore(playerid,1056);
	 GetPlayerPos(playerid,XPosizione,YPosizione,ZPosizione);
	 SetPlayerCameraPos(playerid,XPosizione+4,YPosizione-2,ZPosizione+3);
	 SetPlayerCameraLookAt(playerid,XPosizione,YPosizione,ZPosizione);
	 TextDrawShowForPlayer(playerid,gialloacceso);
	 TextDrawHideForPlayer(playerid,rossoacceso);
	 SetTimerEx("Via",1000,false,"idx",playerid);
}
//===========================================================================VIA
public Via(playerid)
{
	 SetCameraBehindPlayer(playerid);
	 GameTextForPlayer(playerid,"~w~Go!",3000,3);
	 SuonoGiocatore(playerid,1057);
	 TogglePlayerControllable(playerid,1);
	 TextDrawShowForPlayer(playerid,verdeacceso);
	 TextDrawHideForPlayer(playerid,gialloacceso);
	 SetTimerEx("Secondo",1000,false,"idx",playerid);
	 TimerPlayers[playerid]=SetTimerEx("Cronometro",1000,true,"idx",playerid);
}
//=======================================================================SECONDO
public Secondo(playerid)
{
	 TextDrawHideForPlayer(playerid,sfondo);
	 TextDrawHideForPlayer(playerid,sfondorosso);
	 TextDrawHideForPlayer(playerid,sfondogiallo);
	 TextDrawHideForPlayer(playerid,sfondoverde);
	 TextDrawHideForPlayer(playerid,verdeacceso);
	 return 1;
}
//===================================================================CONTROMETRO
public Cronometro(playerid)
{
	 Giocatore[playerid][Tempo]++;
	 new Minuti=floatround(Giocatore[playerid][Tempo]/60);
	 new Secondi=Giocatore[playerid][Tempo]-(Minuti*60);
	 if(Minuti>20)
	 {
		 SendClientMessage(playerid,ROSSO,"[RACE:] {FFFFFF}You quit automatically the race for excessive time (20 minutes)");
		 LasciaGara(playerid);
		 return 1;
	 }
	 new stringatempo[10];
	 format(stringatempo,sizeof(stringatempo),"%02d:%02d",Minuti,Secondi);
	 TextDrawSetString(TimerText[playerid],stringatempo);
	 if(Gara[Giocatore[playerid][IdGara]][Inseguimento]==1)
	 {
		 for(new i=0;i<MAX_PLAYERS;i++)
		  {
			  if(Giocatore[i][IdGara]==Giocatore[playerid][IdGara] && i!=playerid)
			   {
				   GetPlayerPos(i,XPosizione,YPosizione,ZPosizione);
				   break;
			   }
		  }
		 TextDrawHideForPlayer(playerid,SfondoInseguimentoRosso);
		 TextDrawHideForPlayer(playerid,SfondoInseguimentoGiallo);
		 TextDrawHideForPlayer(playerid,SfondoInseguimentoVerde);
		 TextDrawHideForPlayer(playerid,SfondoInseguimentoAzzurro);
		 if(!Giocatore[playerid][Inseguitore])
		  {
			  if(IsPlayerInRangeOfPoint(playerid,15,XPosizione,YPosizione,ZPosizione)){
			  Giocatore[playerid][Punti]+=3; TextDrawShowForPlayer(playerid,SfondoInseguimentoRosso);}
			  else if (IsPlayerInRangeOfPoint(playerid,30,XPosizione,YPosizione,ZPosizione)){
			  Giocatore[playerid][Punti]+=5; TextDrawShowForPlayer(playerid,SfondoInseguimentoGiallo);}
			  else if(IsPlayerInRangeOfPoint(playerid,40,XPosizione,YPosizione,ZPosizione)){
			  Giocatore[playerid][Punti]+=7; TextDrawShowForPlayer(playerid,SfondoInseguimentoVerde);}
			  else{
			  Giocatore[playerid][Punti]+=8; TextDrawShowForPlayer(playerid,SfondoInseguimentoAzzurro);}
		  }
		 else
		  {
			  if(IsPlayerInRangeOfPoint(playerid,15,XPosizione,YPosizione,ZPosizione)){
			  Giocatore[playerid][Punti]+=8; TextDrawShowForPlayer(playerid,SfondoInseguimentoAzzurro);}
			  else if (IsPlayerInRangeOfPoint(playerid,30,XPosizione,YPosizione,ZPosizione)){
			  Giocatore[playerid][Punti]+=7; TextDrawShowForPlayer(playerid,SfondoInseguimentoVerde);}
			  else if(IsPlayerInRangeOfPoint(playerid,40,XPosizione,YPosizione,ZPosizione)){
			  Giocatore[playerid][Punti]+=5; TextDrawShowForPlayer(playerid,SfondoInseguimentoGiallo);}
			  else{
			  Giocatore[playerid][Punti]+=3; TextDrawShowForPlayer(playerid,SfondoInseguimentoRosso);}
		  }
		 format(stringa,sizeof(stringa),"Points: %d",Giocatore[playerid][Punti]);
		 TextDrawSetString(TextPunti[playerid],stringa);
	 }
	 return 1;
}
//====================================================================LASCIAGARA
stock LasciaGara(playerid)
{
	if(Giocatore[playerid][IdGara]==-1) return 1;
	if(Gara[Giocatore[playerid][IdGara]][Avviata]==0)
	{
		if(Giocatore[playerid][Pronto]==1)
		Gara[Giocatore[playerid][IdGara]][PartecipantiPronti]--;
	}
    KillTimer(TimerPlayers[playerid]);
    Giocatore[playerid][Tempo]=0;
	GetPlayerName(playerid,nome,sizeof(nome));
	format(stringa,sizeof(stringa),"[RACE:] {8CE46C}%s {FFFFFF}quit the race.", nome);
    MandaMessaggioPartecipanti(Giocatore[playerid][IdGara],stringa);
    //==========TEXTBASE
    TextDrawHideForPlayer(playerid,sfondo);
    TextDrawHideForPlayer(playerid,TimerText[playerid]);
    TextDrawHideForPlayer(playerid,TimerSfondo);
    TextDrawHideForPlayer(playerid,sfondorosso);
    TextDrawHideForPlayer(playerid,sfondogiallo);
    TextDrawHideForPlayer(playerid,sfondoverde);
    TextDrawHideForPlayer(playerid,rossoacceso);
    TextDrawHideForPlayer(playerid,gialloacceso);
    TextDrawHideForPlayer(playerid,verdeacceso);
    TextDrawHideForPlayer(playerid,TextGiriSfondo);
	//==========TEXTINSEGUIMENTO
    TextDrawHideForPlayer(playerid,TextSfondoInseguimento);
    TextDrawHideForPlayer(playerid,SfondoInseguimentoRosso);
    TextDrawHideForPlayer(playerid,SfondoInseguimentoGiallo);
    TextDrawHideForPlayer(playerid,SfondoInseguimentoVerde);
    TextDrawHideForPlayer(playerid,SfondoInseguimentoAzzurro);
    TextDrawHideForPlayer(playerid,TextInseguimento);
    TextDrawHideForPlayer(playerid,TextPessimo);
    TextDrawHideForPlayer(playerid,TextMediocre);
    TextDrawHideForPlayer(playerid,TextBuono);
    TextDrawHideForPlayer(playerid,TextOttimo);
    TextDrawHideForPlayer(playerid,TextPunti[playerid]);
    
    TextDrawHideForPlayer(playerid,TextGiriContatore[playerid]);
    TextDrawSetString(TimerText[playerid],"00:00");
    Giocatore[playerid][Checkpoint]=0;
    Gara[Giocatore[playerid][IdGara]][Partecipanti]--;
	if(Gara[Giocatore[playerid][IdGara]][PartecipantiPronti]==Gara[Giocatore[playerid][IdGara]][Partecipanti] && Gara[Giocatore[playerid][IdGara]][Partecipanti]!=0 && Gara[Giocatore[playerid][IdGara]][Avviata]==0)
    AvviaGara(Giocatore[playerid][IdGara]);
    ChiudiGara(Giocatore[playerid][IdGara]);
    Giocatore[playerid][IdGara]=-1;
    Giocatore[playerid][Pronto]=0;
    Giocatore[playerid][Giro]=1;
    Giocatore[playerid][Inseguitore]=0;
    Giocatore[playerid][Punti]=0;
    DisablePlayerRaceCheckpoint(playerid);
    return 1;
}
//====================================================================CHIUDIGARA
stock ChiudiGara(idGara)
{
 if(Gara[idGara][Partecipanti]==0 && idGara!=-1)
 {
	 format(stringa,sizeof(stringa),"[RACE:] {FFFFFF}Race {446ED1}%s{FFFFFF} finish.",Gara[idGara][Nome]);
	 SendClientMessageToAll(BIANCO,stringa);
	 Gara[idGara][Podio]=0;
	 Gara[idGara][Avviata]=0;
	 Gara[idGara][Partecipanti]=0;
	 Gara[idGara][PartecipantiPronti]=0;
 }
}
//============================================================ONFILTERSCRIPTINIT
public OnFilterScriptInit()
  {
  print("_______________________________________________");
  print("       RaceSystem by fatspeeddog loaded ");
  print("            Current version: 1.3v");
  print("_______________________________________________");
  CaricaGare();
  TextGiriSfondo = TextDrawCreate(541.000000, 189.000000, "1");
  TextDrawBackgroundColor(TextGiriSfondo, 0);
  TextDrawFont(TextGiriSfondo, 1);
  TextDrawLetterSize(TextGiriSfondo, 0.579999, 1.700000);
  TextDrawColor(TextGiriSfondo, 0);
  TextDrawSetOutline(TextGiriSfondo, 0);
  TextDrawSetProportional(TextGiriSfondo, 1);
  TextDrawSetShadow(TextGiriSfondo, 1);
  TextDrawUseBox(TextGiriSfondo, 1);
  TextDrawBoxColor(TextGiriSfondo, 1010580600);
  TextDrawTextSize(TextGiriSfondo, 613.000000, 0.000000);
  
  TimerSfondo = TextDrawCreate(620.000000, 160.000000, ".sfo");
  TextDrawBackgroundColor(TimerSfondo, 0);
  TextDrawFont(TimerSfondo, 1);
  TextDrawLetterSize(TimerSfondo, 0.500000, 2.499999);
  TextDrawColor(TimerSfondo, 0);
  TextDrawSetOutline(TimerSfondo, 0);
  TextDrawSetProportional(TimerSfondo, 1);
  TextDrawSetShadow(TimerSfondo, 1);
  TextDrawUseBox(TimerSfondo, 1);
  TextDrawBoxColor(TimerSfondo, 1010580580);
  TextDrawTextSize(TimerSfondo, 535.000000, 0.000000);
  
  sfondo = TextDrawCreate(265.000000, 40.000000, "sfondo");
  TextDrawBackgroundColor(sfondo, 0);
  TextDrawFont(sfondo, 1);
  TextDrawLetterSize(sfondo, 0.500000, 3.500000);
  TextDrawColor(sfondo, 0);
  TextDrawSetOutline(sfondo, 0);
  TextDrawSetProportional(sfondo, 1);
  TextDrawSetShadow(sfondo, 1);
  TextDrawUseBox(sfondo, 1);
  TextDrawBoxColor(sfondo, 338826495);
  TextDrawTextSize(sfondo, 384.000000, 0.000000);

  sfondorosso = TextDrawCreate(278.000000, 48.000000, "sfondorosso");
  TextDrawBackgroundColor(sfondorosso, 0);
  TextDrawFont(sfondorosso, 1);
  TextDrawLetterSize(sfondorosso, 0.500000, 1.800001);
  TextDrawColor(sfondorosso, 0);
  TextDrawSetOutline(sfondorosso, 0);
  TextDrawSetProportional(sfondorosso, 1);
  TextDrawSetShadow(sfondorosso, 1);
  TextDrawUseBox(sfondorosso, 1);
  TextDrawBoxColor(sfondorosso, 840176895);
  TextDrawTextSize(sfondorosso, 293.000000, 0.000000);

  sfondogiallo = TextDrawCreate(320.000000, 48.000000, "sfondoarancione");
  TextDrawBackgroundColor(sfondogiallo, 0);
  TextDrawFont(sfondogiallo, 1);
  TextDrawLetterSize(sfondogiallo, 0.500000, 1.800001);
  TextDrawColor(sfondogiallo, 0);
  TextDrawSetOutline(sfondogiallo, 0);
  TextDrawSetProportional(sfondogiallo, 1);
  TextDrawSetShadow(sfondogiallo, 1);
  TextDrawUseBox(sfondogiallo, 1);
  TextDrawBoxColor(sfondogiallo, 842142975);
  TextDrawTextSize(sfondogiallo, 334.000000, 0.000000);

  sfondoverde = TextDrawCreate(359.000000, 48.000000, "sfondoverde");
  TextDrawBackgroundColor(sfondoverde, 0);
  TextDrawFont(sfondoverde, 1);
  TextDrawLetterSize(sfondoverde, 0.500000, 1.800001);
  TextDrawColor(sfondoverde, 0);
  TextDrawSetOutline(sfondoverde, 0);
  TextDrawSetProportional(sfondoverde, 1);
  TextDrawSetShadow(sfondoverde, 1);
  TextDrawUseBox(sfondoverde, 1);
  TextDrawBoxColor(sfondoverde, 337515775);
  TextDrawTextSize(sfondoverde, 373.000000, 0.000000);

  rossoacceso = TextDrawCreate(281.000000, 51.000000, "sfondorossoacceso");
  TextDrawBackgroundColor(rossoacceso, 0);
  TextDrawFont(rossoacceso, 1);
  TextDrawLetterSize(rossoacceso, 0.500000, 1.100001);
  TextDrawColor(rossoacceso, 0);
  TextDrawSetOutline(rossoacceso, 0);
  TextDrawSetProportional(rossoacceso, 1);
  TextDrawSetShadow(rossoacceso, 1);
  TextDrawUseBox(rossoacceso, 1);
  TextDrawBoxColor(rossoacceso, -938208001);
  TextDrawTextSize(rossoacceso, 291.000000, 0.000000);

  gialloacceso = TextDrawCreate(322.000000, 51.000000, "sfondoarancioneacceso");
  TextDrawBackgroundColor(gialloacceso, 0);
  TextDrawFont(gialloacceso, 1);
  TextDrawLetterSize(gialloacceso, 0.500000, 1.100001);
  TextDrawColor(gialloacceso, 0);
  TextDrawSetOutline(gialloacceso, 0);
  TextDrawSetProportional(gialloacceso, 1);
  TextDrawSetShadow(gialloacceso, 1);
  TextDrawUseBox(gialloacceso, 1);
  TextDrawBoxColor(gialloacceso, -926411521);
  TextDrawTextSize(gialloacceso, 332.000000, 0.000000);

  verdeacceso = TextDrawCreate(362.000000, 51.000000, "sfondoverdeacceso");
  TextDrawBackgroundColor(verdeacceso, 0);
  TextDrawFont(verdeacceso, 1);
  TextDrawLetterSize(verdeacceso, 0.500000, 1.100001);
  TextDrawColor(verdeacceso, 0);
  TextDrawSetOutline(verdeacceso, 0);
  TextDrawSetProportional(verdeacceso, 1);
  TextDrawSetShadow(verdeacceso, 1);
  TextDrawUseBox(verdeacceso, 1);
  TextDrawBoxColor(verdeacceso, 348656895);
  TextDrawTextSize(verdeacceso, 370.000000, 0.000000);
  
  TextSfondoInseguimento = TextDrawCreate(170.000000, 362.000000, "box");
  TextDrawBackgroundColor(TextSfondoInseguimento, 0);
  TextDrawFont(TextSfondoInseguimento, 1);
  TextDrawLetterSize(TextSfondoInseguimento, 0.460000, 2.700011);
  TextDrawColor(TextSfondoInseguimento, 0);
  TextDrawSetOutline(TextSfondoInseguimento, 0);
  TextDrawSetProportional(TextSfondoInseguimento, 1);
  TextDrawSetShadow(TextSfondoInseguimento, 1);
  TextDrawUseBox(TextSfondoInseguimento, 1);
  TextDrawBoxColor(TextSfondoInseguimento, 505290340);
  TextDrawTextSize(TextSfondoInseguimento, 467.000000, 0.000000);

  SfondoInseguimentoRosso = TextDrawCreate(174.000000, 366.000000, "boxrosso");
  TextDrawBackgroundColor(SfondoInseguimentoRosso, 0);
  TextDrawFont(SfondoInseguimentoRosso, 1);
  TextDrawLetterSize(SfondoInseguimentoRosso, 0.460000, 1.600010);
  TextDrawColor(SfondoInseguimentoRosso, 0);
  TextDrawSetOutline(SfondoInseguimentoRosso, 0);
  TextDrawSetProportional(SfondoInseguimentoRosso, 1);
  TextDrawSetShadow(SfondoInseguimentoRosso, 1);
  TextDrawUseBox(SfondoInseguimentoRosso, 1);
  TextDrawBoxColor(SfondoInseguimentoRosso, -1776410956);
  TextDrawTextSize(SfondoInseguimentoRosso, 243.000000, 0.000000);

  SfondoInseguimentoGiallo = TextDrawCreate(249.000000, 366.000000, "boxgiallo");
  TextDrawBackgroundColor(SfondoInseguimentoGiallo, 0);
  TextDrawFont(SfondoInseguimentoGiallo, 1);
  TextDrawLetterSize(SfondoInseguimentoGiallo, 0.460000, 1.600010);
  TextDrawColor(SfondoInseguimentoGiallo, 0);
  TextDrawSetOutline(SfondoInseguimentoGiallo, 0);
  TextDrawSetProportional(SfondoInseguimentoGiallo, 1);
  TextDrawSetShadow(SfondoInseguimentoGiallo, 1);
  TextDrawUseBox(SfondoInseguimentoGiallo, 1);
  TextDrawBoxColor(SfondoInseguimentoGiallo, -1768546636);
  TextDrawTextSize(SfondoInseguimentoGiallo, 319.000000, 0.000000);

  SfondoInseguimentoVerde = TextDrawCreate(325.000000, 366.000000, "boxverde");
  TextDrawBackgroundColor(SfondoInseguimentoVerde, 0);
  TextDrawFont(SfondoInseguimentoVerde, 1);
  TextDrawLetterSize(SfondoInseguimentoVerde, 0.460000, 1.600010);
  TextDrawColor(SfondoInseguimentoVerde, 0);
  TextDrawSetOutline(SfondoInseguimentoVerde, 0);
  TextDrawSetProportional(SfondoInseguimentoVerde, 1);
  TextDrawSetShadow(SfondoInseguimentoVerde, 1);
  TextDrawUseBox(SfondoInseguimentoVerde, 1);
  TextDrawBoxColor(SfondoInseguimentoVerde, 513154740);
  TextDrawTextSize(SfondoInseguimentoVerde, 394.000000, 0.000000);

  SfondoInseguimentoAzzurro = TextDrawCreate(400.000000, 366.000000, "boxazzurro");
  TextDrawBackgroundColor(SfondoInseguimentoAzzurro, 0);
  TextDrawFont(SfondoInseguimentoAzzurro, 1);
  TextDrawLetterSize(SfondoInseguimentoAzzurro, 0.460000, 1.600010);
  TextDrawColor(SfondoInseguimentoAzzurro, 0);
  TextDrawSetOutline(SfondoInseguimentoAzzurro, 0);
  TextDrawSetProportional(SfondoInseguimentoAzzurro, 1);
  TextDrawSetShadow(SfondoInseguimentoAzzurro, 1);
  TextDrawUseBox(SfondoInseguimentoAzzurro, 1);
  TextDrawBoxColor(SfondoInseguimentoAzzurro, 513198260);
  TextDrawTextSize(SfondoInseguimentoAzzurro, 463.000000, 0.000000);

  TextInseguimento = TextDrawCreate(274.000000, 339.000000, "   Chase");
  TextDrawBackgroundColor(TextInseguimento, 255);
  TextDrawFont(TextInseguimento, 0);
  TextDrawLetterSize(TextInseguimento, 0.629999, 2.599999);
  TextDrawColor(TextInseguimento, -1);
  TextDrawSetOutline(TextInseguimento, 0);
  TextDrawSetProportional(TextInseguimento, 1);
  TextDrawSetShadow(TextInseguimento, 1);

  TextPessimo = TextDrawCreate(188.000000, 363.000000, "  Bad");
  TextDrawBackgroundColor(TextPessimo, 255);
  TextDrawFont(TextPessimo, 1);
  TextDrawLetterSize(TextPessimo, 0.339999, 2.000000);
  TextDrawColor(TextPessimo, -1);
  TextDrawSetOutline(TextPessimo, 0);
  TextDrawSetProportional(TextPessimo, 1);
  TextDrawSetShadow(TextPessimo, 1);

  TextMediocre = TextDrawCreate(258.000000, 363.000000, "Average");
  TextDrawBackgroundColor(TextMediocre, 255);
  TextDrawFont(TextMediocre, 1);
  TextDrawLetterSize(TextMediocre, 0.339999, 2.000000);
  TextDrawColor(TextMediocre, -1);
  TextDrawSetOutline(TextMediocre, 0);
  TextDrawSetProportional(TextMediocre, 1);
  TextDrawSetShadow(TextMediocre, 1);

  TextBuono = TextDrawCreate(344.000000, 363.000000, "Good");
  TextDrawBackgroundColor(TextBuono, 255);
  TextDrawFont(TextBuono, 1);
  TextDrawLetterSize(TextBuono, 0.339999, 2.000000);
  TextDrawColor(TextBuono, -1);
  TextDrawSetOutline(TextBuono, 0);
  TextDrawSetProportional(TextBuono, 1);
  TextDrawSetShadow(TextBuono, 1);

  TextOttimo = TextDrawCreate(410.000000, 363.000000, "Excellent");
  TextDrawBackgroundColor(TextOttimo, 255);
  TextDrawFont(TextOttimo, 1);
  TextDrawLetterSize(TextOttimo, 0.339999, 2.000000);
  TextDrawColor(TextOttimo, -1);
  TextDrawSetOutline(TextOttimo, 0);
  TextDrawSetProportional(TextOttimo, 1);
  TextDrawSetShadow(TextOttimo, 1);
  
  for(new i=0;i<MAX_PLAYERS;i++)
  {
    Giocatore[i][IdGara]=-1;

    TextPunti[i] = TextDrawCreate(288.000000, 386.000000, "Points: 0000");
    TextDrawBackgroundColor(TextPunti[i], 255);
    TextDrawFont(TextPunti[i], 1);
    TextDrawLetterSize(TextPunti[i], 0.339999, 2.000000);
    TextDrawColor(TextPunti[i], -1);
    TextDrawSetOutline(TextPunti[i], 0);
    TextDrawSetProportional(TextPunti[i], 1);
    TextDrawSetShadow(TextPunti[i], 1);

    TimerText[i] = TextDrawCreate(542.000000, 150.000000, "00:00");
    TextDrawBackgroundColor(TimerText[i], 255);
    TextDrawFont(TimerText[i], 2);
    TextDrawLetterSize(TimerText[i], 0.610000, 4.099999);
    TextDrawColor(TimerText[i], TURCHESE);
    TextDrawSetOutline(TimerText[i], 0);
    TextDrawSetProportional(TimerText[i], 1);
    TextDrawSetShadow(TimerText[i], 1);
    
    TextGiriContatore[i] = TextDrawCreate(542.000000, 192.000000, "Laps: 1/3");
    TextDrawBackgroundColor(TextGiriContatore[i], 255);
    TextDrawFont(TextGiriContatore[i], 1);
    TextDrawLetterSize(TextGiriContatore[i], 0.460000, 1.000000);
    TextDrawColor(TextGiriContatore[i], -1);
    TextDrawSetOutline(TextGiriContatore[i], 0);
    TextDrawSetProportional(TextGiriContatore[i], 1);
    TextDrawSetShadow(TextGiriContatore[i], 1);
  }
  return 1;
}
//============================================================ONFILTERSCRIPTEXIT
public OnFilterScriptExit()
{
 SalvaGare();
 return 1;
}
//===============================================================ONPLAYERCONNECT
public OnPlayerConnect(playerid)
{
	SendClientMessage(playerid, 0xE60000FF, "fatspeeddog's Race-System...Loadet. use /race to join a Race"); //Please, keep this :P
	return 1;
}
//============================================================ONPLAYERDISCONNECT
public OnPlayerDisconnect(playerid, reason)
{
	if(Gara[Giocatore[playerid][IdGara]][Inseguimento] && Gara[Giocatore[playerid][IdGara]][Avviata]==1)
	{
		for(new i=0;i<MAX_PLAYERS;i++)
		 {
			 if(Giocatore[i][IdGara]==Giocatore[playerid][IdGara] && i!=playerid)
			  {
				  GetPlayerName(i,nome,sizeof(nome));
				  format(stringa,sizeof(stringa),"[RACE:] {8ECE46}%s{FFFFFF} wons the race because the opponent disconnected.",nome);
				  SendClientMessageToAll(BIANCO,stringa);
				  GivePlayerMoney(i,Gara[Giocatore[i][IdGara]][Costo]*2);
				  LasciaGara(i);
			  }
		 }
	}
	LasciaGara(playerid);
	Giocatore[playerid][Costruttore]=0;
	return 1;
}
//===========================================================ONPLAYERCOMMANDTEXT
public OnPlayerCommandText(playerid, cmdtext[])
{
//=====================================GARE
	if(!strcmp(cmdtext,"/race",true))
	{
	if(Giocatore[playerid][Costruttore]==1) return SendClientMessage(playerid,ROSSO,"[ERROR:] {FFFFFF}You are in builder mode.");
	format(stringa,sizeof(stringa),"");
	for(new i=0;i<=GareCaricate; i++)
	 {
	 if(Gara[i][Giri]>1 && Gara[i][Inseguimento]==0)
	 format(stringa2,sizeof(stringa2),"{F58C5B}Circuit-{FFFFFF}%s (%d laps)",Gara[i][Nome],Gara[i][Giri]);
	 if(Gara[i][Giri]==1 && Gara[i][Inseguimento]==0)
	 format(stringa2,sizeof(stringa2),"{97EA68}Sprint-{FFFFFF}%s",Gara[i][Nome]);
	 if(Gara[i][Giri]>1 && Gara[i][Inseguimento]==1)
	 format(stringa2,sizeof(stringa2),"{446ED1}Chase-{FFFFFF}%s (%d laps)",Gara[i][Nome],Gara[i][Giri]);
	 if(Gara[i][Giri]==1 && Gara[i][Inseguimento]==1)
	 format(stringa2,sizeof(stringa2),"{446ED1}Chase-{FFFFFF}%s",Gara[i][Nome]);
	 strins(stringa,stringa2,strlen(stringa),sizeof(stringa));
	 if(i!=GareCaricate)
	 strins(stringa,"\n",strlen(stringa),sizeof(stringa));
	 }
	ShowPlayerDialog(playerid,DIALOGGARE,DIALOG_STYLE_LIST,"Avaible races",stringa,"Join","Exit");
	return 1;
	}
//=====================================LASCIAGARA
	if(!strcmp(cmdtext,"/quitrace",true))
	{
	if(Giocatore[playerid][IdGara]==-1) return SendClientMessage(playerid,ROSSO,"[ERROR:] {FFFFFF}You did not join any race.");
	if(Gara[Giocatore[playerid][IdGara]][Inseguimento] && Gara[Giocatore[playerid][IdGara]][Avviata]==1)
	{
	for(new i=0;i<MAX_PLAYERS;i++)
	 {
	 if(Giocatore[i][IdGara]==Giocatore[playerid][IdGara] && i!=playerid)
	  {
	  GetPlayerName(i,nome,sizeof(nome));
	  format(stringa,sizeof(stringa),"[RACE:] {8ECE46}%s{FFFFFF} wons the race because the opponent quitted.",nome);
	  SendClientMessageToAll(BIANCO,stringa);
	  GivePlayerMoney(i,Gara[Giocatore[i][IdGara]][Costo]*2);
	  LasciaGara(i);
	  }
	 }
	}
	LasciaGara(playerid);
	return 1;
	}
//=====================================PRONTO
	if(!strcmp(cmdtext,"/ready",true))
	{
	if(Giocatore[playerid][IdGara]==-1) return SendClientMessage(playerid,ROSSO,"[ERROR:] {FFFFFF}You did not join any race.");
	if(Giocatore[playerid][Pronto]==1) return SendClientMessage(playerid,ROSSO,"[ERROR:] {FFFFFF} You are yet ready, wait opponents to be.");
	SendClientMessage(playerid,BIANCO,"[RACE:] Now you are ready, wait other players to be.");
	Gara[Giocatore[playerid][IdGara]][PartecipantiPronti]++;
	Giocatore[playerid][Pronto]=1;
	if(Gara[Giocatore[playerid][IdGara]][Partecipanti]==Gara[Giocatore[playerid][IdGara]][PartecipantiPronti] && Gara[Giocatore[playerid][IdGara]][Inseguimento]==0)
	AvviaGara(Giocatore[playerid][IdGara]);
	if(Gara[Giocatore[playerid][IdGara]][PartecipantiPronti]==2 && Gara[Giocatore[playerid][IdGara]][Inseguimento]==1)
	AvviaGara(Giocatore[playerid][IdGara]);
	return 1;
	}
//=====================================COSTRUISCIGARA
	if(!strcmp(cmdtext,"/builder",true))
	{
	if(!IsPlayerAdmin(playerid)) return 1;
	if(Giocatore[playerid][IdGara]!=-1) return SendClientMessage(playerid,ROSSO,"[ERROR:]{FFFFFF} You cannot build races while racing.");
	ShowPlayerDialog(playerid,DIALOGINFOCOSTRUTTORE,0,"Info Builder","{FFFFFF}Welcome in the builder mode of {C14124}RaceSystem{FFFFFF}.\nNow you have to inserit some race informations:\n•Race's Name\n•Laps\n•Cost\n•Creation of a checkpoint list\n\nNote: During the builder mode you cannot join races.","Proceed","");
	GareEditor++;
	Giocatore[playerid][GaraEditorId]=GareEditor;
	Giocatore[playerid][Costruttore]=1;
	format(stringa,sizeof(stringa),"Races/Race%d.txt",GareEditor);
	new File:nomegara=fopen(stringa, io_write);
	fwrite(nomegara,"Name,1,50,1000,Nobody,0");
	fclose(nomegara);
	return 1;
	}
//======================================CHECK
	if (!strcmp("/check", cmdtext, true))
	{
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,ROSSO,"[ERROR:] {FFFFFF}You are not logged as RCON Admin");
	if(Giocatore[playerid][Costruttore]==0) return SendClientMessage(playerid,ROSSO,"[ERROR:]{FFFFFF} You are not in builder mode.");
	if(Giocatore[playerid][AttivaCheck]==0) return SendClientMessage(playerid,ROSSO,"[ERROR:]{FFFFFF} Finish to inserit race information before creating a checkpoint list.");
	SendClientMessage(playerid,VERDE,"[CHECKPOINT:] {FFFFFF}Checkpoint saved.");
	format(stringa,sizeof(stringa),"Races/Check%d.txt",Giocatore[playerid][GaraEditorId]);
	new File:nomegara=fopen(stringa, io_append);
    GetPlayerPos(playerid,XPosizione,YPosizione,ZPosizione);
    format(stringagara,sizeof(stringagara),"%f,%f,%f,\r\n",XPosizione,YPosizione,ZPosizione);
    SetPlayerCheckpoint(playerid,XPosizione,YPosizione,ZPosizione,9);
    fwrite(nomegara,stringagara);
    fclose(nomegara);
	return 1;
	}
//====================================FINECHECK
	if(!strcmp("/endcheck", cmdtext, true))
	{
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,ROSSO,"[ERROR:] {FFFFFF}You are not logged as RCON Admin");
	if(Giocatore[playerid][Costruttore]==0) return SendClientMessage(playerid,ROSSO,"[ERROR:]{FFFFFF} You are not in builder mode.");
	if(Giocatore[playerid][AttivaCheck]==0) return SendClientMessage(playerid,ROSSO,"[ERROR:]{FFFFFF} To finish, create first a checkpoint list with /check");
	Giocatore[playerid][Costruttore]=0;
	Giocatore[playerid][AttivaCheck]=0;
	SendClientMessage(playerid,BIANCO,"[EDITOR:] You completed the race.");
	DisablePlayerCheckpoint(playerid);
	SalvaGare();
	for(new i=0;i<MAX_PLAYERS;i++){
	LasciaGara(i);}
	SendClientMessageToAll(BIANCO,"[ANNOUNCE:] Administrator has build a new race. In order to load all the other races have been forced to finish.");
	CaricaGare();
	return 1;
	}
	return 0;
}
//===================================================ONPLAYERENTERRACECHECKPOINT
public OnPlayerEnterRaceCheckpoint(playerid)
{
 if(Giocatore[playerid][IdGara]==-1) return 1;
 new g=Giocatore[playerid][IdGara];
 new c=Giocatore[playerid][Checkpoint];
 if(Gara[Giocatore[playerid][IdGara]][Avviata]==0) return 1;
 SuonoGiocatore(playerid,1138);
 //==============SECHECKPOINT==ULTIMO
 if(Giocatore[playerid][Checkpoint]==Gara[Giocatore[playerid][IdGara]][NumeroCheckpoint])
  {
  //===========SEGIRO=ULTIMO
  if(Giocatore[playerid][Giro]==Gara[Giocatore[playerid][IdGara]][Giri])
    {
    GetPlayerName(playerid,nome,sizeof(nome));
    Gara[Giocatore[playerid][IdGara]][Podio]++;
    if(Giocatore[playerid][Tempo]<Gara[Giocatore[playerid][IdGara]][Record])
    {
    new Minuti=floatround(Giocatore[playerid][Tempo]/60);
    new Secondi=Giocatore[playerid][Tempo]-(Minuti*60);
    format(stringa,sizeof(stringa),"[RECORD:] Player:{8ECE46}%s{FFFFFF} Track: {446ED1}%s{FFFFFF} Record: {C14124}%02d:%02d",nome,Gara[Giocatore[playerid][IdGara]][Nome],Minuti,Secondi);
	SendClientMessageToAll(BIANCO,stringa);
	Gara[Giocatore[playerid][IdGara]][Record]=Giocatore[playerid][Tempo];
    format(Gara[Giocatore[playerid][IdGara]][GiocatoreRecord],25,nome);
    }
	if(!Gara[Giocatore[playerid][IdGara]][Inseguimento])
	{
	format(stringa,sizeof(stringa),"[RACE:] {8ECE46}%s{FFFFFF} finish the race. Position: {C14124}%d",nome,Gara[Giocatore[playerid][IdGara]][Podio]);
	GivePlayerMoney(playerid,floatround(Gara[Giocatore[playerid][IdGara]][Costo]*Gara[Giocatore[playerid][IdGara]][PartecipantiPronti]/Gara[Giocatore[playerid][IdGara]][Podio]));
    SendClientMessageToAll(BIANCO,stringa);
	}
	if(Gara[Giocatore[playerid][IdGara]][Inseguimento])
	{
	for(new i=0;i<MAX_PLAYERS;i++)
	 {
	 if(Giocatore[i][IdGara]==Giocatore[playerid][IdGara] && i!=playerid)
	  {
	  if(Giocatore[playerid][Punti]>=Giocatore[i][Punti])
		{
	    GetPlayerName(playerid,nome,sizeof(nome));
	    format(stringa,sizeof(stringa),"[RACE:] {8ECE46}%s{FFFFFF} wons the chase race with {C14124}%d{FFFFFF} points.",nome,Giocatore[playerid][Punti]);
        SendClientMessageToAll(BIANCO,stringa);
	    GivePlayerMoney(playerid,Gara[Giocatore[playerid][IdGara]][Costo]*2);
		}
	  if(Giocatore[playerid][Punti]<Giocatore[i][Punti])
		{
	    GetPlayerName(i,nome,sizeof(nome));
	    format(stringa,sizeof(stringa),"[RACE:] {8ECE46}%s{FFFFFF} wons the chase race with {C14124}%d{FFFFFF} points.",nome,Giocatore[i][Punti]);
        SendClientMessageToAll(BIANCO,stringa);
        GivePlayerMoney(i,Gara[Giocatore[playerid][IdGara]][Costo]*2);
		}
      LasciaGara(i);
	  }
	 }
	}
    DisablePlayerRaceCheckpoint(playerid);
    LasciaGara(playerid);
    return 1;
    }
  //========SEGIRO!=ULTIMO
  else
    {
    Giocatore[playerid][Giro]++;
	SetPlayerRaceCheckpoint(playerid,0,CheckpointGara[g][0][CXPos],CheckpointGara[g][0][CYPos],CheckpointGara[g][0][CZPos],CheckpointGara[g][1][CXPos],CheckpointGara[g][1][CYPos],CheckpointGara[g][1][CZPos],9);
	Giocatore[playerid][Checkpoint]=0;
	format(stringa,sizeof(stringa),"Laps: %d/%d",Giocatore[playerid][Giro],Gara[Giocatore[playerid][IdGara]][Giri]);
	TextDrawSetString(TextGiriContatore[playerid],stringa);
	return 1;
	}
  }
  //=========SECHECKPOINTNORMALE
 if(Giocatore[playerid][Checkpoint]<Gara[Giocatore[playerid][IdGara]][NumeroCheckpoint]-1)
  {
  Giocatore[playerid][Checkpoint]++;
  c=Giocatore[playerid][Checkpoint];
  SetPlayerRaceCheckpoint(playerid,0,CheckpointGara[g][c][CXPos],CheckpointGara[g][c][CYPos],CheckpointGara[g][c][CZPos],CheckpointGara[g][c+1][CXPos],CheckpointGara[g][c+1][CYPos],CheckpointGara[g][c+1][CZPos],9);
  return 1;
  }
 //=========SECHECKPOINTFINALE
 else if(Giocatore[playerid][Checkpoint]==Gara[Giocatore[playerid][IdGara]][NumeroCheckpoint]-1)
  {
  Giocatore[playerid][Checkpoint]++;
  c=Giocatore[playerid][Checkpoint];
  SetPlayerRaceCheckpoint(playerid,1,CheckpointGara[g][c][CXPos],CheckpointGara[g][c][CYPos],CheckpointGara[g][c][CZPos],CheckpointGara[g][c+1][CXPos],CheckpointGara[g][c+1][CYPos],CheckpointGara[g][c+1][CZPos],9);
  return 1;
  }
 return 1;
}
//===================================================
public OnPlayerLeaveRaceCheckpoint(playerid)
{
    OnPlayerEnterRaceCheckpoint(playerid);
	return 1;
}
//==============================================================
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid==DIALOGINFOGARA2)
	  {
	  Giocatore[playerid][AttivaCheck]=1;
	  return 1;
	  }
	if(dialogid==DIALOGINSEGUIMENTO)
	  {
	  if(strcmp(inputtext,"Yes",true) && strcmp(inputtext,"No",true)) return ShowPlayerDialog(playerid,DIALOGINSEGUIMENTO,DIALOG_STYLE_INPUT,"Chase option","{FFFFFF}ERROR:\nType Yes or No\nDo you want this race to be a Chase type?\n(Type Yes or No)","Continue","");
	  format(stringa,sizeof(stringa),"Races/Race%d.txt",Giocatore[playerid][GaraEditorId]);
	  new File:nomegara=fopen(stringa, io_append);
	  if(!strcmp(inputtext,"Yes",true))
	  fwrite(nomegara,",1");
	  if(!strcmp(inputtext,"No",true))
	  fwrite(nomegara,",0");
	  fclose(nomegara);
	  ShowPlayerDialog(playerid,DIALOGINFOGARA2,0,"Race Info Menu","{FFFFFF}You created the race's info file.\nNow you need a checkpoint list.\nUse the command \"{C14124}/check{FFFFFF}\" to create checkpoint for your race.\nOnce you've finished, type \"{C14124}/endcheck{FFFFFF}\" to exit builder mode and load the new race.","Go","");
	  return 1;
	  }
	if(dialogid==DIALOGCOSTOGARA)
	  {
	  if(!strlen(inputtext) || !isNumeric(inputtext) || strval(inputtext)<=0) return ShowPlayerDialog(playerid,DIALOGCOSTOGARA,DIALOG_STYLE_INPUT,"Race's Cost","{FFFFFF}Type the cost to join your race (min 1):","Continue","");
	  format(stringa,sizeof(stringa),"Races/Race%d.txt",Giocatore[playerid][GaraEditorId]);
	  new File:nomegara=fopen(stringa, io_append);
	  GetPlayerName(playerid,nome,sizeof(nome));
	  format(stringa,sizeof(stringa),"%d,1000,Nobody,%s",strval(inputtext),nome);
	  fwrite(nomegara,stringa);
	  fclose(nomegara);
	  ShowPlayerDialog(playerid,DIALOGINSEGUIMENTO,DIALOG_STYLE_INPUT,"Chase option","{FFFFFF}Do you want this race to be a Chase type?\n(Type Yes or No)","Continue","");
	  return 1;
	  }
	if(dialogid==DIALOGGIRIGARA)
	  {
	  if(!strlen(inputtext) || !isNumeric(inputtext) || strval(inputtext)<=0) return ShowPlayerDialog(playerid,DIALOGGIRIGARA,DIALOG_STYLE_INPUT,"Race's Laps","{FFFFFF}ERROR:\nType the number of laps for your races (1:sprint 2-more:circuit)","Continue","");
	  format(stringa,sizeof(stringa),"Races/Race%d.txt",Giocatore[playerid][GaraEditorId]);
	  new File:nomegara=fopen(stringa, io_append);
	  format(stringa,sizeof(stringa),"%d,",strval(inputtext));
	  fwrite(nomegara,stringa);
	  fclose(nomegara);
	  ShowPlayerDialog(playerid,DIALOGCOSTOGARA,DIALOG_STYLE_INPUT,"Race's Cost","{FFFFFF}Type the cost to join your race (min 1):","Continue","");
	  return 1;
	  }
	if(dialogid==DIALOGNOMEGARA)
	  {
	  if(!strlen(inputtext)) return ShowPlayerDialog(playerid,DIALOGNOMEGARA,DIALOG_STYLE_INPUT,"Race's Name","{FFFFFF}ERROR:\nType the name of your race:","Continua","");
	  format(stringa,sizeof(stringa),"Races/Race%d.txt",Giocatore[playerid][GaraEditorId]);
	  new File:nomegara=fopen(stringa, io_write);
	  format(stringa,sizeof(stringa),"%s,",inputtext);
	  fwrite(nomegara,stringa);
	  fclose(nomegara);
	  ShowPlayerDialog(playerid,DIALOGGIRIGARA,DIALOG_STYLE_INPUT,"Race's Laps","{FFFFFF}Type the number of laps for your races (1:sprint 2-more:circuit)","Continue","");
	  return 1;
	  }
	if(dialogid==DIALOGINFOCOSTRUTTORE)
	  {
	  ShowPlayerDialog(playerid,DIALOGNOMEGARA,DIALOG_STYLE_INPUT,"Race's Name","{FFFFFF}Type the name of you race:","Continue","");
	  return 1;
	  }
	if(dialogid==DIALOGINFO) return 1;
	if(dialogid==DIALOGGARE && response)
	{
	if(Giocatore[playerid][IdGara]!=-1) return SendClientMessage(playerid,ROSSO,"[ERROR:] {FFFFFF}You already joined another race.");
	if(Gara[listitem][Avviata]==1) return SendClientMessage(playerid,ROSSO,"[ERROR:] {FFFFFF}This race is already started. Wait its ending before joining.");
	if(Gara[listitem][Inseguimento]==1)
	{
	if(Gara[listitem][Partecipanti]==2) return SendClientMessage(playerid,ROSSO,"[ERROR:] {FFFFFF}There are already two player in this race (chase race limit)");
	if(Gara[listitem][Partecipanti]==0)
	 {
	 SendClientMessage(playerid,BIANCO,"[RACE:] You are the hunted. When the race starts, stay in front of your opponent and try to escape.");
	 }
	if(Gara[listitem][Partecipanti]==1)
	 {
	 SendClientMessage(playerid,BIANCO,"[RACE:] You are the hunter. When the race starts, stay behind your opponent and chase him.");
	 Giocatore[playerid][Inseguitore]=1;
	 }
	}
	Giocatore[playerid][IdGara]=listitem;
	GetPlayerName(playerid,nome,sizeof(nome));
	format(stringa,sizeof(stringa),"{8CE46C}%s {FFFFFF}join the race.",nome);
	GivePlayerMoney(playerid,-Gara[listitem][Costo]);
	MandaMessaggioPartecipanti(listitem,stringa);
	#if defined TELEPORT_TO_START
	SetPlayerPos(playerid,CheckpointGara[listitem][0][CXPos],CheckpointGara[listitem][0][CYPos],CheckpointGara[listitem][0][CZPos]);
	SendClientMessage(playerid,BIANCO,"[RACE:] You join the race. Type \"{C14124}/Ready{FFFFFF}\" when you are ready.");
	#else
    SendClientMessage(playerid,BIANCO,"[RACE:] You join the race. Go to the checkpoint and type \"{C14124}/Ready{FFFFFF}\" when you are ready");
	#endif
	Gara[listitem][Partecipanti]++;
	SetPlayerRaceCheckpoint(playerid,0,CheckpointGara[listitem][0][CXPos],CheckpointGara[listitem][0][CYPos],CheckpointGara[listitem][0][CZPos],CheckpointGara[listitem][1][CXPos],CheckpointGara[listitem][1][CYPos],CheckpointGara[listitem][1][CZPos],9);
    new minuti=floatround(Gara[listitem][Record]/60);
    new secondi=Gara[listitem][Record]-(minuti*60);
	format(stringa,sizeof(stringa),"{FFFFFF}Track: {8CE46C}%s\n{FFFFFF}Laps: {8CE46C}%d\n{FFFFFF}Cost: {8CE46C}%d$\n{FFFFFF}Record: {8CE46C}%02d:%02d\n{FFFFFF}Player's Record: {8CE46C}%s\n{FFFFFF}Builder: {8CE46C}%s",Gara[listitem][Nome],Gara[listitem][Giri],Gara[listitem][Costo],minuti,secondi,Gara[listitem][GiocatoreRecord],Gara[listitem][Produttore]);
	ShowPlayerDialog(playerid,DIALOGINFO,0,"Race Info",stringa,"Quit","");
	return 1;
	}
	return 1;
}
//====================================================
stock MandaMessaggioPartecipanti(idGara,Messaggio[])
{
 for(new i=0;i<MAX_PLAYERS;i++)
 {
 if(Giocatore[i][IdGara]==idGara)
 SendClientMessage(i,BIANCO,Messaggio);
 }
}
//================================================================S
stock SuonoGiocatore(playerid,idsuono)
{
 new Float:SPosX,Float:SPosY,Float:SPosZ;
 GetPlayerPos(playerid,SPosX,SPosY,SPosZ);
 PlayerPlaySound(playerid,idsuono,SPosX,SPosY,SPosZ);
 return 1;
}
//=====================================================================
stock isNumeric(const string[]) {
	new length=strlen(string);
	if (length==0) return false;
	for (new i = 0; i < length; i++) {
		if (
		(string[i] > '9' || string[i] < '0' && string[i]!='-' && string[i]!='+') 
		|| (string[i]=='-' && i!=0)                                             
		|| (string[i]=='+' && i!=0)                                             
		) return false;
	}
	if (length==1 && (string[0]=='-' || string[0]=='+')) return false;
	return true;
}
