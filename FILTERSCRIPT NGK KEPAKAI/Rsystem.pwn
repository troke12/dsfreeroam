/* Radio System By ShayaN , E-Mail: Shayan1226@yahoo.com
Credits: By ShayaN (Please Dont Remove Credits)
StationGenres:
1.HipHop/Rap
2.Pop&Dance
3.Rock 'n' Metal
4.Country Music
5.Jazz
6.Trance
7.And Only one Persian Radio For Iranian Players :D

>>> WWW.Forum.SA-MP.Com <<<
*/



#include <a_samp>

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
    print("\n--------------------------------------");
    print(" ShayaN's Radio System is starting...");
    print(" ShayaN's Radio System has started!");
    print("--------------------------------------\n");
    return 1;
}

public OnFilterScriptExit()
{
    print("\n--------------------------------------");
    print(" ShayaN's Radio System has been shut down!");
    print("--------------------------------------\n");
    return 1;
}

#else

main()
{
    print("\n----------------------------------");
    print(" ShayaN's Radio System");
    print("----------------------------------\n");
}

#endif


public OnPlayerCommandText(playerid, cmdtext[])
{
    if (strcmp("/radio", cmdtext, true, 10) == 0) 
    {
        ShowPlayerDialog(playerid,90,DIALOG_STYLE_LIST,"Drifter's Radio System - Page1",">> HipHop/Rap Music Stations:\r\n1. #Musik.JAM\r\n2. HipHop Stage\r\n3. 100JAMZ\r\n4. BigFat Radio\r\n5.1CLUB FM : Power HipHop/Rap\r\n>>Dance Music Stations:\r\n1. Hit And Dance - MELA\r\n2. 24H I LOVE DANCE FM\r\n3. BeatRadio (24/7DANCE)\r\n4. 1ClubFM Dance Hitz\r\n>> Rock'N'Metal Music Stations:\r\n1.4uRock&Metal\r\n2. 3rd Rock Radio\r\n3. #Muzik eXTreMe\r\n>>>>>PAGE 2...","Select", "Cancel");//First Page.
        return 1;
    }
    if (strcmp("/stopradio", cmdtext, true, 10) == 0)
    {
        StopAudioStreamForPlayer(playerid);
        SendClientMessage(playerid, 0x42F3F198, "You Have Stopped The Radio...");
        return 1;
    }
    return 0;
}


public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case 90: //Dont Remove This one
        {
            if(!response)// This is When Player Choose "Cancel"
            {
                    SendClientMessage(playerid, 0x42F3F198, "You canceled the Radio!");//This one sends a message when you close the dialog using (Cancel).
                    return 1;
            }

            switch(listitem)//Lists And Radio Steaming Locations...
            {
                case 0: // >> Rap And HipHop Stations
                {
                    SendClientMessage(playerid, 0x42F3F198, "Please Type /Radio And Choose a Radio Station From HipHop/Rap");
                }
                case 1: // #Musik Jam
                {
                    PlayAudioStreamForPlayer(playerid, "http://aol.chuckeh.com/stream/1054");
                    SendClientMessage(playerid, 0x42F3F198, "Connected to <<MusiK.JaM>>,Type /stopradio to stop audio streaming.");
                }
                case 2: // HipHop Stage FM
                {
                    PlayAudioStreamForPlayer(playerid, "http://62.44.1.26:8000/hiphopstage64.mp3");
                    SendClientMessage(playerid, 0x42F3F198, "Connected to <<HipHop Stage>>,Type /stopradio to stop audio streaming.");
                }
                case 3: // 100JAMZ
                {
                    PlayAudioStreamForPlayer(playerid, "http://steams.100jamz.com:7144/jamz.mp3");
                    SendClientMessage(playerid, 0x42F3F198, "Connected to <<100JAMZ>>,Type /stopradio to stop audio streaming.");
                }
                case 4: //BigFat Radio
                {
                    PlayAudioStreamForPlayer(playerid, "http://aol.chuckeh.com/stream/1054");
                    SendClientMessage(playerid, 0x42F3F198, "Connected to <<BigFat Radio>>,Type /stopradio to stop audio streaming.");
                }
                case 5: //1CLUB FM : POWER FM
                {
                    PlayAudioStreamForPlayer(playerid, "http://wms-19.streamsrus.com/dancehits-mp3");
                    SendClientMessage(playerid, 0x42F3F198, "Connected to <<1CLUB FM : POWER FM>>,Type /stopradio to stop audio streaming.");
                }
                case 6: // dance music stations selection
                {
                    SendClientMessage(playerid, 0x42F3F198, "Please Type /Radio And Choose a Radio Station From Dance.");
                }
                case 7: // Hit And Dance - MELA
                {
                    PlayAudioStreamForPlayer(playerid, "http://91.121.38.216:8012");
                    SendClientMessage(playerid, 0x42F3F198, "Connected to <<Hit And Dance - MELA>>,Type /stopradio to stop audio streaming.");
                }
                case 8: // 24H - I LOVE DANCE FM
                {
                    PlayAudioStreamForPlayer(playerid, "http://wms-19.streamsrus.com/dancehits-mp3");
                    SendClientMessage(playerid, 0x42F3F198, "Connected to <<24H - I LOVE DANCE FM>>,Type /stopradio to stop audio streaming.");
                }
                case 9: // Beat Radio
                {
                    PlayAudioStreamForPlayer(playerid, "http://steamserver2.x-hosted.nl:7090");
                    SendClientMessage(playerid, 0x42F3F198, "Connected to <<Beat Radio>>,Type /stopradio to stop audio streaming.");
                }
                case 10: // 1CLUB FM DANCE HITZ
                {
                    PlayAudioStreamForPlayer(playerid, "http://wms-19.streamsrus.com/dancehits-mp3");
                    SendClientMessage(playerid, 0x42F3F198, "Connected to <<1CLUB FM DANCE HITZ>>,Type /stopradio to stop audio streaming.");
                }
                case 11: // Rock'n'Metal Slection
                {
                    SendClientMessage(playerid, 0x42F3F198, "Please Type /Radio And Choose a Radio Station From Rock'n'Metal");
                }
                case 12: // 4U Rock & Metal
                {
                    PlayAudioStreamForPlayer(playerid, "http://str2ushm64.streamakaci.com");
                    SendClientMessage(playerid, 0x42F3F198, "Connected to <<4U Rock & Metal>>,Type /stopradio to stop audio streaming.");
                }
                case 13: // 3rd Rock Radio
                {
                    PlayAudioStreamForPlayer(playerid, "http://109.228.17.223:8090");
                    SendClientMessage(playerid, 0x42F3F198, "Connected to <<3rd Rock Radio>>,Type /stopradio to stop audio streaming.");
                }
                case 14: // #Muzik eXTreMe
                {
                    PlayAudioStreamForPlayer(playerid, "http://aol.chuckeh.com/stream/1052");
                    SendClientMessage(playerid, 0x42F3F198, "Connected to <<#Muzik eXTreMe>>,Type /stopradio to stop audio streaming.");
                }
				case 15:// This Is Seconed Page
                {
                    ShowPlayerDialog(playerid,90,DIALOG_STYLE_LIST,"ShayaN's Radio System - Page2",">> Country Music Stations:\r\n1. 100HitZ - Country HitZ\r\n2. 1FM.Country One\r\n>> Jazz Music Stations:\r\n1. Jazz88 FM\r\n2. 977 SmoothJazz\r\n>> TRANCE Music Stations:\r\n1. Trance radio 1\r\n2. PowerMix FM\r\n3. Excess FM\r\n>> Persian Radio (for Iranian People :D)\r\n1. Bia 2 Radio FM","Select", "Cancel"); //Seconed Page
                }
                case 16: // Country Music Stations
                {
                    SendClientMessage(playerid, 0x42F3F198, "Please Type /Radio And Choose a Radio Station From Country Music.");
                }
                case 17: // 100HitZ - Country HitZ
                {
                    PlayAudioStreamForPlayer(playerid, "http://gotradioaac12.lbdns-streamguys.com");
                    SendClientMessage(playerid, 0x42F3F198, "Connected to <<100HitZ - Country HitZ>>,Type /stopradio to stop audio streaming.");
                }
                case 18: // 1FM.Country One
                {
                    PlayAudioStreamForPlayer(playerid, "http://sc12.1.fm:7050");
                    SendClientMessage(playerid, 0x42F3F198, "Connected to <<1FM.Country One>>,Type /stopradio to stop audio streaming.");
                }
                case 19: // Jazz Music Stations
                {
                    SendClientMessage(playerid, 0x42F3F198, "Please Type /Radio And Choose a Radio Station From Jazz Radio Stations.");
                }
                case 20: // Jazz 88 FM
                {
                    PlayAudioStreamForPlayer(playerid, "http://wbgo.streamguys.net/wbgo32");
                    SendClientMessage(playerid, 0x42F3F198, "Connected to <<Jazz 88 FM>>,Type /stopradio to stop audio streaming.");
                }
                case 21: // 977 Smooth Jazz
                {
                    PlayAudioStreamForPlayer(playerid, "http://icecast3.977music.com/smoothjazz");
                    SendClientMessage(playerid, 0x42F3F198, "Connected to <<977 Smooth Jazz>>,Type /stopradio to stop audio streaming.");
                }
                case 22: // Trance Music Stations
                {
                    SendClientMessage(playerid, 0x42F3F198, "Please Type /Radio And Choose a Radio Station From Trance Radio Stations.");
                }
                case 23: // TranceRadio1
                {
                    PlayAudioStreamForPlayer(playerid, "http://streaming.radioonomy.com:8000/tranceradio1");
                    SendClientMessage(playerid, 0x42F3F198, "Connected to <<TranceRadio1>>,Type /stopradio to stop audio streaming.");
                }
                case 24: // PowerMix FM
                {
                    PlayAudioStreamForPlayer(playerid, "http://85.25.151.137:8005");
                    SendClientMessage(playerid, 0x42F3F198, "Connected to <<PowerMix FM>>,Type /stopradio to stop audio streaming.");
                }
                case 25: // Excess FM
                {
                    PlayAudioStreamForPlayer(playerid, "http://78.129.143.9:8070");
                    SendClientMessage(playerid, 0x42F3F198, "Connected to <<Excess FM>>,Type /stopradio to stop audio streaming.");
                }
                case 26: // and the last selection - only for iranian People (People from my country)
                {
                    SendClientMessage(playerid, 0x42F3F198, "Please Type /Radio And Choose a Radio Station From Persina Radio");
                }
                case 27: // BIA 2 RADIO FM
                {
                    PlayAudioStreamForPlayer(playerid, "http://74.86.133.152:8000");
                    SendClientMessage(playerid, 0x42F3F198, "Connected to <<Bia 2 Radio FM>>,Type /stopradio to stop audio streaming.");
                }
            }
        }
    }
    return 1;
}

