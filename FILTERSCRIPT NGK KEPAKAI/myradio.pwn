#include <a_samp>

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
    print("\n--------------------------------------");
    print(" Radio System is starting ..");
    print(" Radio system has started.");
    print("--------------------------------------\n");
    return 1;
}

public OnFilterScriptExit()
{
    print("\n--------------------------------------");
    print(" Radio System has been shut down due to a Filterscript unload/Exit.");
    print("--------------------------------------\n");
    return 1;
}

#else

main()
{
    print("\n----------------------------------");
    print(" Radio Tutorial by PlayHard. Powered by PlayHard's Tutorials :P");
    print("----------------------------------\n");
}

#endif


public OnPlayerCommandText(playerid, cmdtext[])
{
    if (strcmp("/myradio", cmdtext, true, 10) == 0) //Change this one to whatever you want.
    {
        ShowPlayerDialog(playerid,90,DIALOG_STYLE_LIST,"Greek Ultimate Stuntages Radio","1. USA/EUROPE RADIO FM\r\n2. HIP-HOP RADIO FM\r\n3. GERMAN RADIO FM","Select", "Cancel");
        //We use the line above to make the Dialog show, and as you notice we want DIALOG_STYLE_LIST because it will be a list so we can choose from.
        //As you notice everytime you add \r\n it adds a new line to the list, which means in our tutorial adds a new radio station to the list.
        //Make sure you change the ID of the Dialog, we don't want it to mix with other dialogs in your server, I set it to 90.
        return 1;
    }
    if (strcmp("/stopradio", cmdtext, true, 10) == 0)
    {
        StopAudioStreamForPlayer(playerid);//This is the function we need to stop the audio from streaming the music.
        return 1;
    }
    return 0;
}


public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case 90: //Remember the ID we changed in ShowPlayerDialog? (90) That's how the DialogResponse will get to know which Dialog it's going to use.
        {
            if(!response)// This one is used for option 2 which we changed to (Cancel).
            {
                    SendClientMessage(playerid, 0x42F3F198, "You canceled the dialog.");//This one sends a message when you close the dialog using (Cancel).
                    return 1;
            }

            switch(listitem)//This one will list the items.
            {
                case 0://Case 0 is basically the first line we made in ShowPlayerDialog (1.)
                {
                    PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=616366/");//This function will play our desired radio. So we have to put the url between its brackets.
                    SendClientMessage(playerid, 0x42F3F198, "Type /stopradio to stop audio streaming."); //This line sends a message to the listener that he can stop it using /stopradio.
                }
                case 1://Case 1 is the second line we put in ShowPlayerDialog (\r\n2.)
                {
                    PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=1281016");//This function will play our desired radio. So we have to put the url between its brackets.
                    SendClientMessage(playerid, 0x42F3F198, "Type /stopradio to stop audio streaming.");//This line sends a message to the listener that he can stop it using /stopradio.
                }
                case 2://Case 2 is the third line we put in ShowPlayerDialog(\r\n3.)
                {
                    PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=65456/");//This function will play our desired radio. So we have to put the url between its brackets.
                    SendClientMessage(playerid, 0x42F3F198, "Type /stopradio to stop audio streaming.");//This line sends a message to the listener that he can stop it using /stopradio.
                }
                //You can continue cases here but make sure you make a new line in the ShowPlayerDialog on /myradio command \r\n4. 4th \r\n5. 5th channel etc..
            }
        }
    }
    return 1;
}
