#if defined _fvip_included
	#endinput
#endif
#define _fvip_included

/*
native IsPlayerVIP(playerid,level);
native GetKills(playerid);
native GetDeaths(playerid);
native GetAccountNumber(playerid);
native GetTotalAccounts();
native GetScoreForAdding();
native GetMoneyForAdding();
native GetMaxLevel();
*/

new Location[50];
new myname[MAX_PLAYER_NAME];

stock IsPlayerVIP(playerid,level)
{
	GetPlayerName(playerid, myname, sizeof(myname));
	new Vfile[256];
	new isVip[MAX_PLAYERS];
	format(Vfile,256,"/fVIP/Accounts/%s.txt",myname);
	if(dini_Exists(File))
	{
	    fopen(File,io_read);
		isVip[playerid] = dini_Int(file,"Level");
		if(isVip[playerid] >= level)
		{
			return true;
		}
		else
		{
			return false;
		}
		fclose(File);
	}
	return 1;
}

stock GetKills(playerid)
{
	new mykills;
	GetPlayerName(playerid,myname,sizeof(myname));
	format(Location,sizeof(Location),"fVIP/Accounts/%s.txt",myname);
	if(dini_Exists(Location))
	{
		mykills = dini_Int(Location,"Kills");
	}
	return mykills;
}

stock GetDeaths(playerid)
{
	new mydeaths;
	GetPlayerName(playerid,myname,sizeof(myname));
	format(Location,sizeof(Location),"fVIP/Accounts/%s.txt",myname);
	if(dini_Exists(Location))
	{
		mydeaths = dini_Int(Location,"Deaths");
	}
	return mydeaths;
}

stock GetAccountNumber(playerid)
{
	new myaccnum;
	GetPlayerName(playerid,myname,sizeof(myname));
	format(Location,sizeof(Location),"fVIP/Accounts/%s.txt",myname);
	if(dini_Exists(Location))
	{
		myaccnum = dini_Int(Location,"AccountNumber");
	}
	return myaccnum;
}

stock GetTotalAccounts()
{
	new totalaccs;
    format(Location,sizeof(Location),"fVIP/Files/TotalAccounts.txt");
    if(dini_Exists(Location))
    {
		totalaccs = dini_Int(Location,"Accounts");
	}
	return totalaccs;
}

stock GetScoreForAdding()
{
	new scoreforadd;
    format(Location,sizeof(Location),"fVIP/Files/Configuration.txt");
    if(dini_Exists(Location))
    {
		scoreforadd = dini_Int(Location,"ScoreForJoin");
	}
	return scoreforadd;
}

stock GetMoneyForAdding()
{
	new moneyforadd;
    format(Location,sizeof(Location),"fVIP/Files/Configuration.txt");
    if(dini_Exists(Location))
    {
		moneyforadd = dini_Int(Location,"MoneyForJoin");
	}
	return moneyforadd;
}

stock GetMaxLevel()
{
	new maximumlvl;
    format(Location,sizeof(Location),"fVIP/Files/Configuration.txt");
    if(dini_Exists(Location))
    {
		maximumlvl = dini_Int(Location,"MaxVipLevel");
	}
	return maximumlvl;
}
		