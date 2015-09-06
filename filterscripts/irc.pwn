/*==================================================================
							G-IRC Version 0.1
							By Deron_Green
				Special thanks to: Y_LESS, Incognito,
						ejb And the SA-IRC Network
							!credits
						Please dont remove credits
//===================================================================*/
#include <a_samp>
#include <irc>
#include <sscanf2>
//============Defines================//
#define BOT_1_NICKNAME "Krisna"
#define BOT_1_REALNAME "Krisna"
#define BOT_1_USERNAME "Bot1"

#define BOT_2_NICKNAME "Pradnya"
#define BOT_2_REALNAME "Pradnya"
#define BOT_2_USERNAME "Bot2"

#define IRC_SERVER "irc.va.us.mibbit.net"
#define IRC_PORT (6667)
#define IRC_CHANNEL "#serverkrisna"
#define ADMIN_CHANNEL "#maho"
#define BOT_PASS "krisna12"
#define BOT_EMAIL "krisna@noreply.com"

#define MAX_BOTS (2)
#define PLUGIN_VERSION "1.4.3"
new botIDs[MAX_BOTS], groupID;

#define WHITE      					0xFFFFFFAA
#define HOT_PINK                    "{FF2DFF}"
#define GOLD                        "{F7DE00}"
#define ROYALB                      "{0000FF}"
#define CWHITE 						"{FFFFFF}"
#define CWHITE                  	"{FFFFFF}"
#define CYELLOW                  	"{FFFF00}"
#define CORED					 	"{FF0000}"
#define CORANGE                  	"{FF8000}"
#define CBLUE                    	"{0080FF}"
#define CVIOLET                  	"{A020F0}"
#define CGREEN                      "{00FF00}"
#define CRED 						"{F81414}"
#define CRBLUE                      "{14f8f8}"
#define MAX_ZONE_NAME 28

//===============Zones==================//
enum SAZONE_MAIN {
		SAZONE_NAME[28],
		Float:SAZONE_AREA[6]
};

static const gSAZones[][SAZONE_MAIN] = {
	//	NAME                            AREA (Xmin,Ymin,Zmin,Xmax,Ymax,Zmax)
	{"The Big Ear",	                {-410.00,1403.30,-3.00,-137.90,1681.20,200.00}},
	{"Aldea Malvada",               {-1372.10,2498.50,0.00,-1277.50,2615.30,200.00}},
	{"Angel Pine",                  {-2324.90,-2584.20,-6.10,-1964.20,-2212.10,200.00}},
	{"Arco del Oeste",              {-901.10,2221.80,0.00,-592.00,2571.90,200.00}},
	{"Avispa Country Club",         {-2646.40,-355.40,0.00,-2270.00,-222.50,200.00}},
	{"Avispa Country Club",         {-2831.80,-430.20,-6.10,-2646.40,-222.50,200.00}},
	{"Avispa Country Club",         {-2361.50,-417.10,0.00,-2270.00,-355.40,200.00}},
	{"Avispa Country Club",         {-2667.80,-302.10,-28.80,-2646.40,-262.30,71.10}},
	{"Avispa Country Club",         {-2470.00,-355.40,0.00,-2270.00,-318.40,46.10}},
	{"Avispa Country Club",         {-2550.00,-355.40,0.00,-2470.00,-318.40,39.70}},
	{"Back o Beyond",               {-1166.90,-2641.10,0.00,-321.70,-1856.00,200.00}},
	{"Battery Point",               {-2741.00,1268.40,-4.50,-2533.00,1490.40,200.00}},
	{"Bayside",                     {-2741.00,2175.10,0.00,-2353.10,2722.70,200.00}},
	{"Bayside Marina",              {-2353.10,2275.70,0.00,-2153.10,2475.70,200.00}},
	{"Beacon Hill",                 {-399.60,-1075.50,-1.40,-319.00,-977.50,198.50}},
	{"Blackfield",                  {964.30,1203.20,-89.00,1197.30,1403.20,110.90}},
	{"Blackfield",                  {964.30,1403.20,-89.00,1197.30,1726.20,110.90}},
	{"Blackfield Chapel",           {1375.60,596.30,-89.00,1558.00,823.20,110.90}},
	{"Blackfield Chapel",           {1325.60,596.30,-89.00,1375.60,795.00,110.90}},
	{"Blackfield Intersection",     {1197.30,1044.60,-89.00,1277.00,1163.30,110.90}},
	{"Blackfield Intersection",     {1166.50,795.00,-89.00,1375.60,1044.60,110.90}},
	{"Blackfield Intersection",     {1277.00,1044.60,-89.00,1315.30,1087.60,110.90}},
	{"Blackfield Intersection",     {1375.60,823.20,-89.00,1457.30,919.40,110.90}},
	{"Blueberry",                   {104.50,-220.10,2.30,349.60,152.20,200.00}},
	{"Blueberry",                   {19.60,-404.10,3.80,349.60,-220.10,200.00}},
	{"Blueberry Acres",             {-319.60,-220.10,0.00,104.50,293.30,200.00}},
	{"Caligula's Palace",           {2087.30,1543.20,-89.00,2437.30,1703.20,110.90}},
	{"Caligula's Palace",           {2137.40,1703.20,-89.00,2437.30,1783.20,110.90}},
	{"Calton Heights",              {-2274.10,744.10,-6.10,-1982.30,1358.90,200.00}},
	{"Chinatown",                   {-2274.10,578.30,-7.60,-2078.60,744.10,200.00}},
	{"City Hall",                   {-2867.80,277.40,-9.10,-2593.40,458.40,200.00}},
	{"Come-A-Lot",                  {2087.30,943.20,-89.00,2623.10,1203.20,110.90}},
	{"Commerce",                    {1323.90,-1842.20,-89.00,1701.90,-1722.20,110.90}},
	{"Commerce",                    {1323.90,-1722.20,-89.00,1440.90,-1577.50,110.90}},
	{"Commerce",                    {1370.80,-1577.50,-89.00,1463.90,-1384.90,110.90}},
	{"Commerce",                    {1463.90,-1577.50,-89.00,1667.90,-1430.80,110.90}},
	{"Commerce",                    {1583.50,-1722.20,-89.00,1758.90,-1577.50,110.90}},
	{"Commerce",                    {1667.90,-1577.50,-89.00,1812.60,-1430.80,110.90}},
	{"Conference Center",           {1046.10,-1804.20,-89.00,1323.90,-1722.20,110.90}},
	{"Conference Center",           {1073.20,-1842.20,-89.00,1323.90,-1804.20,110.90}},
	{"Cranberry Station",           {-2007.80,56.30,0.00,-1922.00,224.70,100.00}},
	{"Creek",                       {2749.90,1937.20,-89.00,2921.60,2669.70,110.90}},
	{"Dillimore",                   {580.70,-674.80,-9.50,861.00,-404.70,200.00}},
	{"Doherty",                     {-2270.00,-324.10,-0.00,-1794.90,-222.50,200.00}},
	{"Doherty",                     {-2173.00,-222.50,-0.00,-1794.90,265.20,200.00}},
	{"Downtown",                    {-1982.30,744.10,-6.10,-1871.70,1274.20,200.00}},
	{"Downtown",                    {-1871.70,1176.40,-4.50,-1620.30,1274.20,200.00}},
	{"Downtown",                    {-1700.00,744.20,-6.10,-1580.00,1176.50,200.00}},
	{"Downtown",                    {-1580.00,744.20,-6.10,-1499.80,1025.90,200.00}},
	{"Downtown",                    {-2078.60,578.30,-7.60,-1499.80,744.20,200.00}},
	{"Downtown",                    {-1993.20,265.20,-9.10,-1794.90,578.30,200.00}},
	{"Downtown Los Santos",         {1463.90,-1430.80,-89.00,1724.70,-1290.80,110.90}},
	{"Downtown Los Santos",         {1724.70,-1430.80,-89.00,1812.60,-1250.90,110.90}},
	{"Downtown Los Santos",         {1463.90,-1290.80,-89.00,1724.70,-1150.80,110.90}},
	{"Downtown Los Santos",         {1370.80,-1384.90,-89.00,1463.90,-1170.80,110.90}},
	{"Downtown Los Santos",         {1724.70,-1250.90,-89.00,1812.60,-1150.80,110.90}},
	{"Downtown Los Santos",         {1370.80,-1170.80,-89.00,1463.90,-1130.80,110.90}},
	{"Downtown Los Santos",         {1378.30,-1130.80,-89.00,1463.90,-1026.30,110.90}},
	{"Downtown Los Santos",         {1391.00,-1026.30,-89.00,1463.90,-926.90,110.90}},
	{"Downtown Los Santos",         {1507.50,-1385.20,110.90,1582.50,-1325.30,335.90}},
	{"East Beach",                  {2632.80,-1852.80,-89.00,2959.30,-1668.10,110.90}},
	{"East Beach",                  {2632.80,-1668.10,-89.00,2747.70,-1393.40,110.90}},
	{"East Beach",                  {2747.70,-1668.10,-89.00,2959.30,-1498.60,110.90}},
	{"East Beach",                  {2747.70,-1498.60,-89.00,2959.30,-1120.00,110.90}},
	{"East Los Santos",             {2421.00,-1628.50,-89.00,2632.80,-1454.30,110.90}},
	{"East Los Santos",             {2222.50,-1628.50,-89.00,2421.00,-1494.00,110.90}},
	{"East Los Santos",             {2266.20,-1494.00,-89.00,2381.60,-1372.00,110.90}},
	{"East Los Santos",             {2381.60,-1494.00,-89.00,2421.00,-1454.30,110.90}},
	{"East Los Santos",             {2281.40,-1372.00,-89.00,2381.60,-1135.00,110.90}},
	{"East Los Santos",             {2381.60,-1454.30,-89.00,2462.10,-1135.00,110.90}},
	{"East Los Santos",             {2462.10,-1454.30,-89.00,2581.70,-1135.00,110.90}},
	{"Easter Basin",                {-1794.90,249.90,-9.10,-1242.90,578.30,200.00}},
	{"Easter Basin",                {-1794.90,-50.00,-0.00,-1499.80,249.90,200.00}},
	{"Easter Bay Airport",          {-1499.80,-50.00,-0.00,-1242.90,249.90,200.00}},
	{"Easter Bay Airport",          {-1794.90,-730.10,-3.00,-1213.90,-50.00,200.00}},
	{"Easter Bay Airport",          {-1213.90,-730.10,0.00,-1132.80,-50.00,200.00}},
	{"Easter Bay Airport",          {-1242.90,-50.00,0.00,-1213.90,578.30,200.00}},
	{"Easter Bay Airport",          {-1213.90,-50.00,-4.50,-947.90,578.30,200.00}},
	{"Easter Bay Airport",          {-1315.40,-405.30,15.40,-1264.40,-209.50,25.40}},
	{"Easter Bay Airport",          {-1354.30,-287.30,15.40,-1315.40,-209.50,25.40}},
	{"Easter Bay Airport",          {-1490.30,-209.50,15.40,-1264.40,-148.30,25.40}},
	{"Easter Bay Chemicals",        {-1132.80,-768.00,0.00,-956.40,-578.10,200.00}},
	{"Easter Bay Chemicals",        {-1132.80,-787.30,0.00,-956.40,-768.00,200.00}},
	{"El Castillo del Diablo",      {-464.50,2217.60,0.00,-208.50,2580.30,200.00}},
	{"El Castillo del Diablo",      {-208.50,2123.00,-7.60,114.00,2337.10,200.00}},
	{"El Castillo del Diablo",      {-208.50,2337.10,0.00,8.40,2487.10,200.00}},
	{"El Corona",                   {1812.60,-2179.20,-89.00,1970.60,-1852.80,110.90}},
	{"El Corona",                   {1692.60,-2179.20,-89.00,1812.60,-1842.20,110.90}},
	{"El Quebrados",                {-1645.20,2498.50,0.00,-1372.10,2777.80,200.00}},
	{"Esplanade East",              {-1620.30,1176.50,-4.50,-1580.00,1274.20,200.00}},
	{"Esplanade East",              {-1580.00,1025.90,-6.10,-1499.80,1274.20,200.00}},
	{"Esplanade East",              {-1499.80,578.30,-79.60,-1339.80,1274.20,20.30}},
	{"Esplanade North",             {-2533.00,1358.90,-4.50,-1996.60,1501.20,200.00}},
	{"Esplanade North",             {-1996.60,1358.90,-4.50,-1524.20,1592.50,200.00}},
	{"Esplanade North",             {-1982.30,1274.20,-4.50,-1524.20,1358.90,200.00}},
	{"Fallen Tree",                 {-792.20,-698.50,-5.30,-452.40,-380.00,200.00}},
	{"Fallow Bridge",               {434.30,366.50,0.00,603.00,555.60,200.00}},
	{"Fern Ridge",                  {508.10,-139.20,0.00,1306.60,119.50,200.00}},
	{"Financial",                   {-1871.70,744.10,-6.10,-1701.30,1176.40,300.00}},
	{"Fisher's Lagoon",             {1916.90,-233.30,-100.00,2131.70,13.80,200.00}},
	{"Flint Intersection",          {-187.70,-1596.70,-89.00,17.00,-1276.60,110.90}},
	{"Flint Range",                 {-594.10,-1648.50,0.00,-187.70,-1276.60,200.00}},
	{"Fort Carson",                 {-376.20,826.30,-3.00,123.70,1220.40,200.00}},
	{"Foster Valley",               {-2270.00,-430.20,-0.00,-2178.60,-324.10,200.00}},
	{"Foster Valley",               {-2178.60,-599.80,-0.00,-1794.90,-324.10,200.00}},
	{"Foster Valley",               {-2178.60,-1115.50,0.00,-1794.90,-599.80,200.00}},
	{"Foster Valley",               {-2178.60,-1250.90,0.00,-1794.90,-1115.50,200.00}},
	{"Frederick Bridge",            {2759.20,296.50,0.00,2774.20,594.70,200.00}},
	{"Gant Bridge",                 {-2741.40,1659.60,-6.10,-2616.40,2175.10,200.00}},
	{"Gant Bridge",                 {-2741.00,1490.40,-6.10,-2616.40,1659.60,200.00}},
	{"Ganton",                      {2222.50,-1852.80,-89.00,2632.80,-1722.30,110.90}},
	{"Ganton",                      {2222.50,-1722.30,-89.00,2632.80,-1628.50,110.90}},
	{"Garcia",                      {-2411.20,-222.50,-0.00,-2173.00,265.20,200.00}},
	{"Garcia",                      {-2395.10,-222.50,-5.30,-2354.00,-204.70,200.00}},
	{"Garver Bridge",               {-1339.80,828.10,-89.00,-1213.90,1057.00,110.90}},
	{"Garver Bridge",               {-1213.90,950.00,-89.00,-1087.90,1178.90,110.90}},
	{"Garver Bridge",               {-1499.80,696.40,-179.60,-1339.80,925.30,20.30}},
	{"Glen Park",                   {1812.60,-1449.60,-89.00,1996.90,-1350.70,110.90}},
	{"Glen Park",                   {1812.60,-1100.80,-89.00,1994.30,-973.30,110.90}},
	{"Glen Park",                   {1812.60,-1350.70,-89.00,2056.80,-1100.80,110.90}},
	{"Green Palms",                 {176.50,1305.40,-3.00,338.60,1520.70,200.00}},
	{"Greenglass College",          {964.30,1044.60,-89.00,1197.30,1203.20,110.90}},
	{"Greenglass College",          {964.30,930.80,-89.00,1166.50,1044.60,110.90}},
	{"Hampton Barns",               {603.00,264.30,0.00,761.90,366.50,200.00}},
	{"Hankypanky Point",            {2576.90,62.10,0.00,2759.20,385.50,200.00}},
	{"Harry Gold Parkway",          {1777.30,863.20,-89.00,1817.30,2342.80,110.90}},
	{"Hashbury",                    {-2593.40,-222.50,-0.00,-2411.20,54.70,200.00}},
	{"Hilltop Farm",                {967.30,-450.30,-3.00,1176.70,-217.90,200.00}},
	{"Hunter Quarry",               {337.20,710.80,-115.20,860.50,1031.70,203.70}},
	{"Idlewood",                    {1812.60,-1852.80,-89.00,1971.60,-1742.30,110.90}},
	{"Idlewood",                    {1812.60,-1742.30,-89.00,1951.60,-1602.30,110.90}},
	{"Idlewood",                    {1951.60,-1742.30,-89.00,2124.60,-1602.30,110.90}},
	{"Idlewood",                    {1812.60,-1602.30,-89.00,2124.60,-1449.60,110.90}},
	{"Idlewood",                    {2124.60,-1742.30,-89.00,2222.50,-1494.00,110.90}},
	{"Idlewood",                    {1971.60,-1852.80,-89.00,2222.50,-1742.30,110.90}},
	{"Jefferson",                   {1996.90,-1449.60,-89.00,2056.80,-1350.70,110.90}},
	{"Jefferson",                   {2124.60,-1494.00,-89.00,2266.20,-1449.60,110.90}},
	{"Jefferson",                   {2056.80,-1372.00,-89.00,2281.40,-1210.70,110.90}},
	{"Jefferson",                   {2056.80,-1210.70,-89.00,2185.30,-1126.30,110.90}},
	{"Jefferson",                   {2185.30,-1210.70,-89.00,2281.40,-1154.50,110.90}},
	{"Jefferson",                   {2056.80,-1449.60,-89.00,2266.20,-1372.00,110.90}},
	{"Julius Thruway East",         {2623.10,943.20,-89.00,2749.90,1055.90,110.90}},
	{"Julius Thruway East",         {2685.10,1055.90,-89.00,2749.90,2626.50,110.90}},
	{"Julius Thruway East",         {2536.40,2442.50,-89.00,2685.10,2542.50,110.90}},
	{"Julius Thruway East",         {2625.10,2202.70,-89.00,2685.10,2442.50,110.90}},
	{"Julius Thruway North",        {2498.20,2542.50,-89.00,2685.10,2626.50,110.90}},
	{"Julius Thruway North",        {2237.40,2542.50,-89.00,2498.20,2663.10,110.90}},
	{"Julius Thruway North",        {2121.40,2508.20,-89.00,2237.40,2663.10,110.90}},
	{"Julius Thruway North",        {1938.80,2508.20,-89.00,2121.40,2624.20,110.90}},
	{"Julius Thruway North",        {1534.50,2433.20,-89.00,1848.40,2583.20,110.90}},
	{"Julius Thruway North",        {1848.40,2478.40,-89.00,1938.80,2553.40,110.90}},
	{"Julius Thruway North",        {1704.50,2342.80,-89.00,1848.40,2433.20,110.90}},
	{"Julius Thruway North",        {1377.30,2433.20,-89.00,1534.50,2507.20,110.90}},
	{"Julius Thruway South",        {1457.30,823.20,-89.00,2377.30,863.20,110.90}},
	{"Julius Thruway South",        {2377.30,788.80,-89.00,2537.30,897.90,110.90}},
	{"Julius Thruway West",         {1197.30,1163.30,-89.00,1236.60,2243.20,110.90}},
	{"Julius Thruway West",         {1236.60,2142.80,-89.00,1297.40,2243.20,110.90}},
	{"Juniper Hill",                {-2533.00,578.30,-7.60,-2274.10,968.30,200.00}},
	{"Juniper Hollow",              {-2533.00,968.30,-6.10,-2274.10,1358.90,200.00}},
	{"K.A.C.C. Military Fuels",     {2498.20,2626.50,-89.00,2749.90,2861.50,110.90}},
	{"Kincaid Bridge",              {-1339.80,599.20,-89.00,-1213.90,828.10,110.90}},
	{"Kincaid Bridge",              {-1213.90,721.10,-89.00,-1087.90,950.00,110.90}},
	{"Kincaid Bridge",              {-1087.90,855.30,-89.00,-961.90,986.20,110.90}},
	{"King's",                      {-2329.30,458.40,-7.60,-1993.20,578.30,200.00}},
	{"King's",                      {-2411.20,265.20,-9.10,-1993.20,373.50,200.00}},
	{"King's",                      {-2253.50,373.50,-9.10,-1993.20,458.40,200.00}},
	{"LVA Freight Depot",           {1457.30,863.20,-89.00,1777.40,1143.20,110.90}},
	{"LVA Freight Depot",           {1375.60,919.40,-89.00,1457.30,1203.20,110.90}},
	{"LVA Freight Depot",           {1277.00,1087.60,-89.00,1375.60,1203.20,110.90}},
	{"LVA Freight Depot",           {1315.30,1044.60,-89.00,1375.60,1087.60,110.90}},
	{"LVA Freight Depot",           {1236.60,1163.40,-89.00,1277.00,1203.20,110.90}},
	{"Las Barrancas",               {-926.10,1398.70,-3.00,-719.20,1634.60,200.00}},
	{"Las Brujas",                  {-365.10,2123.00,-3.00,-208.50,2217.60,200.00}},
	{"Las Colinas",                 {1994.30,-1100.80,-89.00,2056.80,-920.80,110.90}},
	{"Las Colinas",                 {2056.80,-1126.30,-89.00,2126.80,-920.80,110.90}},
	{"Las Colinas",                 {2185.30,-1154.50,-89.00,2281.40,-934.40,110.90}},
	{"Las Colinas",                 {2126.80,-1126.30,-89.00,2185.30,-934.40,110.90}},
	{"Las Colinas",                 {2747.70,-1120.00,-89.00,2959.30,-945.00,110.90}},
	{"Las Colinas",                 {2632.70,-1135.00,-89.00,2747.70,-945.00,110.90}},
	{"Las Colinas",                 {2281.40,-1135.00,-89.00,2632.70,-945.00,110.90}},
	{"Las Payasadas",               {-354.30,2580.30,2.00,-133.60,2816.80,200.00}},
	{"Las Venturas Airport",        {1236.60,1203.20,-89.00,1457.30,1883.10,110.90}},
	{"Las Venturas Airport",        {1457.30,1203.20,-89.00,1777.30,1883.10,110.90}},
	{"Las Venturas Airport",        {1457.30,1143.20,-89.00,1777.40,1203.20,110.90}},
	{"Las Venturas Airport",        {1515.80,1586.40,-12.50,1729.90,1714.50,87.50}},
	{"Last Dime Motel",             {1823.00,596.30,-89.00,1997.20,823.20,110.90}},
	{"Leafy Hollow",                {-1166.90,-1856.00,0.00,-815.60,-1602.00,200.00}},
	{"Liberty City",                {-1000.00,400.00,1300.00,-700.00,600.00,1400.00}},
	{"Lil' Probe Inn",              {-90.20,1286.80,-3.00,153.80,1554.10,200.00}},
	{"Linden Side",                 {2749.90,943.20,-89.00,2923.30,1198.90,110.90}},
	{"Linden Station",              {2749.90,1198.90,-89.00,2923.30,1548.90,110.90}},
	{"Linden Station",              {2811.20,1229.50,-39.50,2861.20,1407.50,60.40}},
	{"Little Mexico",               {1701.90,-1842.20,-89.00,1812.60,-1722.20,110.90}},
	{"Little Mexico",               {1758.90,-1722.20,-89.00,1812.60,-1577.50,110.90}},
	{"Los Flores",                  {2581.70,-1454.30,-89.00,2632.80,-1393.40,110.90}},
	{"Los Flores",                  {2581.70,-1393.40,-89.00,2747.70,-1135.00,110.90}},
	{"Los Santos International",    {1249.60,-2394.30,-89.00,1852.00,-2179.20,110.90}},
	{"Los Santos International",    {1852.00,-2394.30,-89.00,2089.00,-2179.20,110.90}},
	{"Los Santos International",    {1382.70,-2730.80,-89.00,2201.80,-2394.30,110.90}},
	{"Los Santos International",    {1974.60,-2394.30,-39.00,2089.00,-2256.50,60.90}},
	{"Los Santos International",    {1400.90,-2669.20,-39.00,2189.80,-2597.20,60.90}},
	{"Los Santos International",    {2051.60,-2597.20,-39.00,2152.40,-2394.30,60.90}},
	{"Marina",                      {647.70,-1804.20,-89.00,851.40,-1577.50,110.90}},
	{"Marina",                      {647.70,-1577.50,-89.00,807.90,-1416.20,110.90}},
	{"Marina",                      {807.90,-1577.50,-89.00,926.90,-1416.20,110.90}},
	{"Market",                      {787.40,-1416.20,-89.00,1072.60,-1310.20,110.90}},
	{"Market",                      {952.60,-1310.20,-89.00,1072.60,-1130.80,110.90}},
	{"Market",                      {1072.60,-1416.20,-89.00,1370.80,-1130.80,110.90}},
	{"Market",                      {926.90,-1577.50,-89.00,1370.80,-1416.20,110.90}},
	{"Market Station",              {787.40,-1410.90,-34.10,866.00,-1310.20,65.80}},
	{"Martin Bridge",               {-222.10,293.30,0.00,-122.10,476.40,200.00}},
	{"Missionary Hill",             {-2994.40,-811.20,0.00,-2178.60,-430.20,200.00}},
	{"Montgomery",                  {1119.50,119.50,-3.00,1451.40,493.30,200.00}},
	{"Montgomery",                  {1451.40,347.40,-6.10,1582.40,420.80,200.00}},
	{"Montgomery Intersection",     {1546.60,208.10,0.00,1745.80,347.40,200.00}},
	{"Montgomery Intersection",     {1582.40,347.40,0.00,1664.60,401.70,200.00}},
	{"Mulholland",                  {1414.00,-768.00,-89.00,1667.60,-452.40,110.90}},
	{"Mulholland",                  {1281.10,-452.40,-89.00,1641.10,-290.90,110.90}},
	{"Mulholland",                  {1269.10,-768.00,-89.00,1414.00,-452.40,110.90}},
	{"Mulholland",                  {1357.00,-926.90,-89.00,1463.90,-768.00,110.90}},
	{"Mulholland",                  {1318.10,-910.10,-89.00,1357.00,-768.00,110.90}},
	{"Mulholland",                  {1169.10,-910.10,-89.00,1318.10,-768.00,110.90}},
	{"Mulholland",                  {768.60,-954.60,-89.00,952.60,-860.60,110.90}},
	{"Mulholland",                  {687.80,-860.60,-89.00,911.80,-768.00,110.90}},
	{"Mulholland",                  {737.50,-768.00,-89.00,1142.20,-674.80,110.90}},
	{"Mulholland",                  {1096.40,-910.10,-89.00,1169.10,-768.00,110.90}},
	{"Mulholland",                  {952.60,-937.10,-89.00,1096.40,-860.60,110.90}},
	{"Mulholland",                  {911.80,-860.60,-89.00,1096.40,-768.00,110.90}},
	{"Mulholland",                  {861.00,-674.80,-89.00,1156.50,-600.80,110.90}},
	{"Mulholland Intersection",     {1463.90,-1150.80,-89.00,1812.60,-768.00,110.90}},
	{"North Rock",                  {2285.30,-768.00,0.00,2770.50,-269.70,200.00}},
	{"Ocean Docks",                 {2373.70,-2697.00,-89.00,2809.20,-2330.40,110.90}},
	{"Ocean Docks",                 {2201.80,-2418.30,-89.00,2324.00,-2095.00,110.90}},
	{"Ocean Docks",                 {2324.00,-2302.30,-89.00,2703.50,-2145.10,110.90}},
	{"Ocean Docks",                 {2089.00,-2394.30,-89.00,2201.80,-2235.80,110.90}},
	{"Ocean Docks",                 {2201.80,-2730.80,-89.00,2324.00,-2418.30,110.90}},
	{"Ocean Docks",                 {2703.50,-2302.30,-89.00,2959.30,-2126.90,110.90}},
	{"Ocean Docks",                 {2324.00,-2145.10,-89.00,2703.50,-2059.20,110.90}},
	{"Ocean Flats",                 {-2994.40,277.40,-9.10,-2867.80,458.40,200.00}},
	{"Ocean Flats",                 {-2994.40,-222.50,-0.00,-2593.40,277.40,200.00}},
	{"Ocean Flats",                 {-2994.40,-430.20,-0.00,-2831.80,-222.50,200.00}},
	{"Octane Springs",              {338.60,1228.50,0.00,664.30,1655.00,200.00}},
	{"Old Venturas Strip",          {2162.30,2012.10,-89.00,2685.10,2202.70,110.90}},
	{"Palisades",                   {-2994.40,458.40,-6.10,-2741.00,1339.60,200.00}},
	{"Palomino Creek",              {2160.20,-149.00,0.00,2576.90,228.30,200.00}},
	{"Paradiso",                    {-2741.00,793.40,-6.10,-2533.00,1268.40,200.00}},
	{"Pershing Square",             {1440.90,-1722.20,-89.00,1583.50,-1577.50,110.90}},
	{"Pilgrim",                     {2437.30,1383.20,-89.00,2624.40,1783.20,110.90}},
	{"Pilgrim",                     {2624.40,1383.20,-89.00,2685.10,1783.20,110.90}},
	{"Pilson Intersection",         {1098.30,2243.20,-89.00,1377.30,2507.20,110.90}},
	{"Pirates in Men's Pants",      {1817.30,1469.20,-89.00,2027.40,1703.20,110.90}},
	{"Playa del Seville",           {2703.50,-2126.90,-89.00,2959.30,-1852.80,110.90}},
	{"Prickle Pine",                {1534.50,2583.20,-89.00,1848.40,2863.20,110.90}},
	{"Prickle Pine",                {1117.40,2507.20,-89.00,1534.50,2723.20,110.90}},
	{"Prickle Pine",                {1848.40,2553.40,-89.00,1938.80,2863.20,110.90}},
	{"Prickle Pine",                {1938.80,2624.20,-89.00,2121.40,2861.50,110.90}},
	{"Queens",                      {-2533.00,458.40,0.00,-2329.30,578.30,200.00}},
	{"Queens",                      {-2593.40,54.70,0.00,-2411.20,458.40,200.00}},
	{"Queens",                      {-2411.20,373.50,0.00,-2253.50,458.40,200.00}},
	{"Randolph Industrial Estate",  {1558.00,596.30,-89.00,1823.00,823.20,110.90}},
	{"Redsands East",               {1817.30,2011.80,-89.00,2106.70,2202.70,110.90}},
	{"Redsands East",               {1817.30,2202.70,-89.00,2011.90,2342.80,110.90}},
	{"Redsands East",               {1848.40,2342.80,-89.00,2011.90,2478.40,110.90}},
	{"Redsands West",               {1236.60,1883.10,-89.00,1777.30,2142.80,110.90}},
	{"Redsands West",               {1297.40,2142.80,-89.00,1777.30,2243.20,110.90}},
	{"Redsands West",               {1377.30,2243.20,-89.00,1704.50,2433.20,110.90}},
	{"Redsands West",               {1704.50,2243.20,-89.00,1777.30,2342.80,110.90}},
	{"Regular Tom",                 {-405.70,1712.80,-3.00,-276.70,1892.70,200.00}},
	{"Richman",                     {647.50,-1118.20,-89.00,787.40,-954.60,110.90}},
	{"Richman",                     {647.50,-954.60,-89.00,768.60,-860.60,110.90}},
	{"Richman",                     {225.10,-1369.60,-89.00,334.50,-1292.00,110.90}},
	{"Richman",                     {225.10,-1292.00,-89.00,466.20,-1235.00,110.90}},
	{"Richman",                     {72.60,-1404.90,-89.00,225.10,-1235.00,110.90}},
	{"Richman",                     {72.60,-1235.00,-89.00,321.30,-1008.10,110.90}},
	{"Richman",                     {321.30,-1235.00,-89.00,647.50,-1044.00,110.90}},
	{"Richman",                     {321.30,-1044.00,-89.00,647.50,-860.60,110.90}},
	{"Richman",                     {321.30,-860.60,-89.00,687.80,-768.00,110.90}},
	{"Richman",                     {321.30,-768.00,-89.00,700.70,-674.80,110.90}},
	{"Robada Intersection",         {-1119.00,1178.90,-89.00,-862.00,1351.40,110.90}},
	{"Roca Escalante",              {2237.40,2202.70,-89.00,2536.40,2542.50,110.90}},
	{"Roca Escalante",              {2536.40,2202.70,-89.00,2625.10,2442.50,110.90}},
	{"Rockshore East",              {2537.30,676.50,-89.00,2902.30,943.20,110.90}},
	{"Rockshore West",              {1997.20,596.30,-89.00,2377.30,823.20,110.90}},
	{"Rockshore West",              {2377.30,596.30,-89.00,2537.30,788.80,110.90}},
	{"Rodeo",                       {72.60,-1684.60,-89.00,225.10,-1544.10,110.90}},
	{"Rodeo",                       {72.60,-1544.10,-89.00,225.10,-1404.90,110.90}},
	{"Rodeo",                       {225.10,-1684.60,-89.00,312.80,-1501.90,110.90}},
	{"Rodeo",                       {225.10,-1501.90,-89.00,334.50,-1369.60,110.90}},
	{"Rodeo",                       {334.50,-1501.90,-89.00,422.60,-1406.00,110.90}},
	{"Rodeo",                       {312.80,-1684.60,-89.00,422.60,-1501.90,110.90}},
	{"Rodeo",                       {422.60,-1684.60,-89.00,558.00,-1570.20,110.90}},
	{"Rodeo",                       {558.00,-1684.60,-89.00,647.50,-1384.90,110.90}},
	{"Rodeo",                       {466.20,-1570.20,-89.00,558.00,-1385.00,110.90}},
	{"Rodeo",                       {422.60,-1570.20,-89.00,466.20,-1406.00,110.90}},
	{"Rodeo",                       {466.20,-1385.00,-89.00,647.50,-1235.00,110.90}},
	{"Rodeo",                       {334.50,-1406.00,-89.00,466.20,-1292.00,110.90}},
	{"Royal Casino",                {2087.30,1383.20,-89.00,2437.30,1543.20,110.90}},
	{"San Andreas Sound",           {2450.30,385.50,-100.00,2759.20,562.30,200.00}},
	{"Santa Flora",                 {-2741.00,458.40,-7.60,-2533.00,793.40,200.00}},
	{"Santa Maria Beach",           {342.60,-2173.20,-89.00,647.70,-1684.60,110.90}},
	{"Santa Maria Beach",           {72.60,-2173.20,-89.00,342.60,-1684.60,110.90}},
	{"Shady Cabin",                 {-1632.80,-2263.40,-3.00,-1601.30,-2231.70,200.00}},
	{"Shady Creeks",                {-1820.60,-2643.60,-8.00,-1226.70,-1771.60,200.00}},
	{"Shady Creeks",                {-2030.10,-2174.80,-6.10,-1820.60,-1771.60,200.00}},
	{"Sobell Rail Yards",           {2749.90,1548.90,-89.00,2923.30,1937.20,110.90}},
	{"Spinybed",                    {2121.40,2663.10,-89.00,2498.20,2861.50,110.90}},
	{"Starfish Casino",             {2437.30,1783.20,-89.00,2685.10,2012.10,110.90}},
	{"Starfish Casino",             {2437.30,1858.10,-39.00,2495.00,1970.80,60.90}},
	{"Starfish Casino",             {2162.30,1883.20,-89.00,2437.30,2012.10,110.90}},
	{"Temple",                      {1252.30,-1130.80,-89.00,1378.30,-1026.30,110.90}},
	{"Temple",                      {1252.30,-1026.30,-89.00,1391.00,-926.90,110.90}},
	{"Temple",                      {1252.30,-926.90,-89.00,1357.00,-910.10,110.90}},
	{"Temple",                      {952.60,-1130.80,-89.00,1096.40,-937.10,110.90}},
	{"Temple",                      {1096.40,-1130.80,-89.00,1252.30,-1026.30,110.90}},
	{"Temple",                      {1096.40,-1026.30,-89.00,1252.30,-910.10,110.90}},
	{"The Camel's Toe",             {2087.30,1203.20,-89.00,2640.40,1383.20,110.90}},
	{"The Clown's Pocket",          {2162.30,1783.20,-89.00,2437.30,1883.20,110.90}},
	{"The Emerald Isle",            {2011.90,2202.70,-89.00,2237.40,2508.20,110.90}},
	{"The Farm",                    {-1209.60,-1317.10,114.90,-908.10,-787.30,251.90}},
	{"The Four Dragons Casino",     {1817.30,863.20,-89.00,2027.30,1083.20,110.90}},
	{"The High Roller",             {1817.30,1283.20,-89.00,2027.30,1469.20,110.90}},
	{"The Mako Span",               {1664.60,401.70,0.00,1785.10,567.20,200.00}},
	{"The Panopticon",              {-947.90,-304.30,-1.10,-319.60,327.00,200.00}},
	{"The Pink Swan",               {1817.30,1083.20,-89.00,2027.30,1283.20,110.90}},
	{"The Sherman Dam",             {-968.70,1929.40,-3.00,-481.10,2155.20,200.00}},
	{"The Strip",                   {2027.40,863.20,-89.00,2087.30,1703.20,110.90}},
	{"The Strip",                   {2106.70,1863.20,-89.00,2162.30,2202.70,110.90}},
	{"The Strip",                   {2027.40,1783.20,-89.00,2162.30,1863.20,110.90}},
	{"The Strip",                   {2027.40,1703.20,-89.00,2137.40,1783.20,110.90}},
	{"The Visage",                  {1817.30,1863.20,-89.00,2106.70,2011.80,110.90}},
	{"The Visage",                  {1817.30,1703.20,-89.00,2027.40,1863.20,110.90}},
	{"Unity Station",               {1692.60,-1971.80,-20.40,1812.60,-1932.80,79.50}},
	{"Valle Ocultado",              {-936.60,2611.40,2.00,-715.90,2847.90,200.00}},
	{"Verdant Bluffs",              {930.20,-2488.40,-89.00,1249.60,-2006.70,110.90}},
	{"Verdant Bluffs",              {1073.20,-2006.70,-89.00,1249.60,-1842.20,110.90}},
	{"Verdant Bluffs",              {1249.60,-2179.20,-89.00,1692.60,-1842.20,110.90}},
	{"Verdant Meadows",             {37.00,2337.10,-3.00,435.90,2677.90,200.00}},
	{"Verona Beach",                {647.70,-2173.20,-89.00,930.20,-1804.20,110.90}},
	{"Verona Beach",                {930.20,-2006.70,-89.00,1073.20,-1804.20,110.90}},
	{"Verona Beach",                {851.40,-1804.20,-89.00,1046.10,-1577.50,110.90}},
	{"Verona Beach",                {1161.50,-1722.20,-89.00,1323.90,-1577.50,110.90}},
	{"Verona Beach",                {1046.10,-1722.20,-89.00,1161.50,-1577.50,110.90}},
	{"Vinewood",                    {787.40,-1310.20,-89.00,952.60,-1130.80,110.90}},
	{"Vinewood",                    {787.40,-1130.80,-89.00,952.60,-954.60,110.90}},
	{"Vinewood",                    {647.50,-1227.20,-89.00,787.40,-1118.20,110.90}},
	{"Vinewood",                    {647.70,-1416.20,-89.00,787.40,-1227.20,110.90}},
	{"Whitewood Estates",           {883.30,1726.20,-89.00,1098.30,2507.20,110.90}},
	{"Whitewood Estates",           {1098.30,1726.20,-89.00,1197.30,2243.20,110.90}},
	{"Willowfield",                 {1970.60,-2179.20,-89.00,2089.00,-1852.80,110.90}},
	{"Willowfield",                 {2089.00,-2235.80,-89.00,2201.80,-1989.90,110.90}},
	{"Willowfield",                 {2089.00,-1989.90,-89.00,2324.00,-1852.80,110.90}},
	{"Willowfield",                 {2201.80,-2095.00,-89.00,2324.00,-1989.90,110.90}},
	{"Willowfield",                 {2541.70,-1941.40,-89.00,2703.50,-1852.80,110.90}},
	{"Willowfield",                 {2324.00,-2059.20,-89.00,2541.70,-1852.80,110.90}},
	{"Willowfield",                 {2541.70,-2059.20,-89.00,2703.50,-1941.40,110.90}},
	{"Yellow Bell Station",         {1377.40,2600.40,-21.90,1492.40,2687.30,78.00}},
	// Main Zones
	{"Los Santos",                  {44.60,-2892.90,-242.90,2997.00,-768.00,900.00}},
	{"Las Venturas",                {869.40,596.30,-242.90,2997.00,2993.80,900.00}},
	{"Bone County",                 {-480.50,596.30,-242.90,869.40,2993.80,900.00}},
	{"Tierra Robada",               {-2997.40,1659.60,-242.90,-480.50,2993.80,900.00}},
	{"Tierra Robada",               {-1213.90,596.30,-242.90,-480.50,1659.60,900.00}},
	{"San Fierro",                  {-2997.40,-1115.50,-242.90,-1213.90,1659.60,900.00}},
	{"Red County",                  {-1213.90,-768.00,-242.90,2997.00,596.30,900.00}},
	{"Flint County",                {-1213.90,-2892.90,-242.90,44.60,-768.00,900.00}},
	{"Whetstone",                   {-2997.40,-2892.90,-242.90,-1213.90,-1115.50,900.00}}
};


main()
{
	print("\n----------------------------------");
	print("      	G-IRC v0.1			   	   ");
	print("		By Deron_Green !credits		   ");
	print("----------------------------------\n");
}
//==============Publics================//
public OnFilterScriptInit()
{
	botIDs[0] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_1_NICKNAME, BOT_1_REALNAME, BOT_1_USERNAME);
	IRC_SetIntData(botIDs[0], E_IRC_CONNECT_DELAY, 20);
	botIDs[1] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_2_NICKNAME, BOT_2_REALNAME, BOT_2_USERNAME);
	IRC_SetIntData(botIDs[1], E_IRC_CONNECT_DELAY, 30);
	groupID = IRC_CreateGroup();
}
public OnFilterScriptExit()
{
	IRC_Quit(botIDs[0], "G-IRC closing");
	IRC_Quit(botIDs[1], "G-IRC closing");
	IRC_DestroyGroup(groupID);
}
public OnPlayerConnect(playerid)
{
	new joinMsg[128], name[MAX_PLAYER_NAME], Ajoin[128];
	GetPlayerName(playerid, name, sizeof(name));
	format(joinMsg, sizeof(joinMsg), "50JOIN: %s (%d) Has Joined The Server.", name, playerid);
	IRC_GroupSay(groupID, IRC_CHANNEL, joinMsg);
	new giveplayerid, ip[16];
	GetPlayerIp(giveplayerid, ip, sizeof(ip));
	format(Ajoin, sizeof(Ajoin), "50JOIN: %s (%d) Has Joined The Server.- (IP): %s", name, playerid, ip);
	IRC_GroupSay(groupID, ADMIN_CHANNEL, Ajoin);
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	new leaveMsg[128], name[MAX_PLAYER_NAME], reasonMsg[20], Aleave[128];
	switch(reason)
	{
		case 0: reasonMsg = "Timeout";
		case 1: reasonMsg = "Leaving";
		case 2: reasonMsg = "Kicked/Banned";
	}
	GetPlayerName(playerid, name, sizeof(name));
	format(leaveMsg, sizeof(leaveMsg), "02%s (%d) Has Left The Server. -(%s)", name, playerid, reasonMsg);
	IRC_GroupSay(groupID, IRC_CHANNEL, leaveMsg);
	format(Aleave, sizeof(Aleave), "02%s (%d) Has Left The Server. - (%s)", name, playerid, reasonMsg);
	IRC_GroupSay(groupID, ADMIN_CHANNEL, Aleave);
	return 1;
}
public OnPlayerSpawn(playerid)
{
	new SpawnMsg[128], name[MAX_PLAYER_NAME], string[128], zone[MAX_ZONE_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	format(SpawnMsg, sizeof(SpawnMsg), "5SPAWN: %s (%d) Has Spawned.", name, playerid);
	IRC_GroupSay(groupID, IRC_CHANNEL, SpawnMsg);
	GetPlayer2DZone(playerid, zone, MAX_ZONE_NAME);
	format(string, sizeof(string), "5 SPAWN: %s (%d) Has Spawned. - Location: %s", name, playerid, zone);
	IRC_GroupSay(groupID, ADMIN_CHANNEL, string);
	return 1;
}
public OnPlayerDeath(playerid, killerid, reason)
{
	new msg[128], killerName[MAX_PLAYER_NAME], reasonMsg[32], playerName[MAX_PLAYER_NAME];
	GetPlayerName(killerid, killerName, sizeof(killerName));
	GetPlayerName(playerid, playerName, sizeof(playerName));
	if (killerid != INVALID_PLAYER_ID)
	{
		switch (reason)
		{
			case 0: reasonMsg = "Fist";
			case 1: reasonMsg = "Brass Knuckles";
			case 2: reasonMsg = "Golf Club";
			case 3: reasonMsg = "Night Stick";
			case 4: reasonMsg = "Knife";
			case 5: reasonMsg = "Baseball Bat";
			case 6: reasonMsg = "Shovel";
			case 7: reasonMsg = "Pool Cue";
			case 8: reasonMsg = "Katana";
			case 9: reasonMsg = "Chainsaw";
			case 10: reasonMsg = "Dildo";
			case 11: reasonMsg = "Dildo";
			case 12: reasonMsg = "Vibrator";
			case 13: reasonMsg = "Vibrator";
			case 14: reasonMsg = "Flowers";
			case 15: reasonMsg = "Cane";
			case 22: reasonMsg = "Pistol";
			case 23: reasonMsg = "Silenced Pistol";
			case 24: reasonMsg = "Desert Eagle";
			case 25: reasonMsg = "Shotgun";
			case 26: reasonMsg = "Sawn-off Shotgun";
			case 27: reasonMsg = "Combat Shotgun";
			case 28: reasonMsg = "MAC-10";
			case 29: reasonMsg = "MP5";
			case 30: reasonMsg = "AK-47";
			case 31: reasonMsg = "M4";
			case 32: reasonMsg = "TEC-9";
			case 33: reasonMsg = "Country Rifle";
			case 34: reasonMsg = "Sniper Rifle";
			case 37: reasonMsg = "Fire";
			case 38: reasonMsg = "Minigun";
			case 41: reasonMsg = "Spray Can";
			case 42: reasonMsg = "Fire Extinguisher";
			case 49: reasonMsg = "Vehicle Collision";
			case 50: reasonMsg = "Vehicle Collision";
			case 51: reasonMsg = "Explosion";
			default: reasonMsg = "Unknown";
		}
		format(msg, sizeof(msg), "04 %s Murdered %s. (%s)", killerName, playerName, reasonMsg);
	}
	else
	{
		switch (reason)
		{
			case 53: format(msg, sizeof(msg), "04 %s died. (Drowned)", playerName);
			case 54: format(msg, sizeof(msg), "04 %s died. (Collision)", playerName);
			default: format(msg, sizeof(msg), "04 %s died.", playerName);
		}
	}
	IRC_GroupSay(groupID, IRC_CHANNEL, msg);
	return 1;
}
public OnPlayerText(playerid, text[])
{
	new name[MAX_PLAYER_NAME], ircMsg[256], Rstr[128];
	GetPlayerName(playerid, name, sizeof(name));
	GetPlayerWantedLevel(playerid);
 	if(GetPlayerWantedLevel(playerid) == 0)
 	{
	format(ircMsg, sizeof(ircMsg), "%s (%d): %s", name, playerid, text);
	IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
	IRC_GroupSay(groupID, ADMIN_CHANNEL, ircMsg);
	}
 	else if(GetPlayerWantedLevel(playerid) >= 1)
 	{
	format(Rstr, sizeof(Rstr), "4(WANTED):1%s (%d): %s", name, playerid, text);
	IRC_GroupSay(groupID, IRC_CHANNEL, Rstr);
	IRC_GroupSay(groupID, ADMIN_CHANNEL, Rstr);
	}
	return 1;
}
public IRC_OnConnect(botid, ip[], port)
{
	printf("*** IRC_OnConnect: Bot ID %d connected to %s:%d", botid, ip, port);
	IRC_JoinChannel(botid, IRC_CHANNEL);
	IRC_JoinChannel(botid, ADMIN_CHANNEL);
	IRC_AddToGroup(groupID, botid);
  	IRC_SendRaw(botid, "ns identify "BOT_PASS"");
	return 1;
}
public IRC_OnDisconnect(botid, ip[], port, reason[])
{
	IRC_RemoveFromGroup(groupID, botid);
	return 1;
}
public IRC_OnConnectAttemptFail(botid, ip[], port, reason[])
{
	printf("*** IRC_OnConnectAttemptFail: Bot ID %d failed to connect to %s:%d (%s)", botid, ip, port, reason);
	return 1;
}
public IRC_OnReceiveRaw(botid, message[])
{
	new File:file;
	if (!fexist("irc_log.txt"))
	{
		file = fopen("irc_log.txt", io_write);
	}
	else
	{
		file = fopen("irc_log.txt", io_append);
	}
	if (file)
	{
		fwrite(file, message);
		fwrite(file, "\r\n");
		fclose(file);
	}
	return 1;
}
//==============================Commands===============================//
IRCCMD:say(botid, channel[], user[], host[], params[])
{
	if (IRC_IsVoice(botid, channel, user))
	{
		if (!isnull(params))
		{
			new msg[128];
			format(msg, sizeof(msg), "02%s on IRC: %s", user, params);
			IRC_GroupSay(groupID, channel, msg);
			format(msg, sizeof(msg), "%s on IRC: %s", user, params);
			SendClientMessageToAll(WHITE, msg);
		}
	}
	return 1;
}

IRCCMD:ikick(botid, channel[], user[], host[], params[])
{
	if (IRC_IsHalfop(botid, channel, user)) return IRC_Say(groupID, channel, "Invalid Level.");
	{
		new playerid, reason[64];
		if (sscanf(params, "dS(No reason)[64]", playerid, reason))
		{
			return 1;
		}
		if (IsPlayerConnected(playerid))
		{
			new msg[128], name[MAX_PLAYER_NAME];
			GetPlayerName(playerid, name, sizeof(name));
			format(msg, sizeof(msg), "02%s Has Been Kicked By Administrator %s On IRC. (%s)", name, user, reason);
			IRC_GroupSay(groupID, channel, msg);
			format(msg, sizeof(msg), "%s Has Been Kicked By %s On IRC. (%s)", name, user, reason);
			SendClientMessageToAll(WHITE, msg);
			Kick(playerid);
		}
	}
	return 1;
}

IRCCMD:iban(botid, channel[], user[], host[], params[])
{
	if (IRC_IsHalfop(botid, channel, user)) return IRC_Say(groupID, channel, "Invalid Level.");
	{
		new playerid, reason[64];
		if (sscanf(params, "dS(No reason)[64]", playerid, reason))
		{
			return 1;
		}
		if (IsPlayerConnected(playerid))
		{
			new msg[128], name[MAX_PLAYER_NAME];
			GetPlayerName(playerid, name, sizeof(name));
			format(msg, sizeof(msg), "02%s Has Been "CRED"Banned By Administrator %s On IRC. (%s)", name, user, reason);
			IRC_GroupSay(groupID, channel, msg);
			format(msg, sizeof(msg), "%s has been "CRED"Banned By Administrator %s On IRC. (%s)", name, user, reason);
			SendClientMessageToAll(WHITE, msg);
			BanEx(playerid, reason);
		}
	}
	return 1;
}

IRCCMD:rcon(botid, channel[], user[], host[], params[])
{
	if (IRC_IsOp(botid, channel, user)) return IRC_Say(groupID, channel, "Invalid Level.");
	{
		if (!isnull(params))
		{
			if (strcmp(params, "exit", true) != 0 && strfind(params, "loadfs irc", true) == -1)
			{
				new msg[128];
				format(msg, sizeof(msg), "RCON command %s has been executed.", params);
				IRC_GroupSay(groupID, channel, msg);
				SendRconCommand(params);
			}
		}
	}
	return 1;
}
IRCCMD:cmds(botid, channel[], user[], host[], params[])
{
    if(!strcmp(channel, channel, true))
    {
        IRC_Say(botid, user, "04 		[IRC Commands]			  ");
        IRC_Say(groupID, user, "|    User: !pm !players !credits !say    ");
   		{
		if(IRC_IsHalfop(botid, channel, user))
		{
		    IRC_Say(groupID, user, "|    Halfops: !slap !iban !ikick !clearchat !warn !getip   ");
		}
		if(IRC_IsOp(botid, channel, user))
		{
		    IRC_Say(groupID, user, "|    Operators: !explode !givecash !setscore !setwanted !loc  ");
		}
		if(IRC_IsAdmin(botid, channel, user))
		{
		    IRC_Say(groupID, user, "|    Administrators: !isay !cprotect !crestore    ");
		}
		if(IRC_IsOwner(botid, channel, user))
		{
		    IRC_Say(groupID, user, "|    Owner: !restart !bregister !rcon    ");
		}
    	}
	}
	return 1;
}
IRCCMD:bregister(botid, channel[], user[], host[], params[])
{
	if(!IRC_IsOwner(botid, channel, user)) return IRC_Say(groupID, channel, "Invalid Level.");
	new regstr[50];
	format(regstr, sizeof(regstr), "ns register %s %s", BOT_PASS, BOT_EMAIL);
	IRC_SendRaw(botid, regstr);
	return 1;
}
IRCCMD:restart(botid, channel[], user[], host[], params[])
{
	if(!IRC_IsOwner(botid, channel, user)) return IRC_Say(groupID, channel, "Invalid Level.");
	SendRconCommand("gmx");
	return 1;
}
IRCCMD:cprotect(botid, channel[], user[], host[], params[])
{
	if(!IRC_IsAdmin(botid, channel, user)) return IRC_Say(groupID, channel, "Invalid Level.");
	new pmode[50];
	format(pmode, sizeof(pmode), "mode %s +miRCp", channel);
	IRC_SendRaw(botid, pmode);
	return 1;
}
IRCCMD:crestore(botid, channel[], user[], host[], params[])
{
	if(!IRC_IsAdmin(botid, channel, user)) return IRC_Say(groupID, channel, "Invalid Level.");
	new pmode[50];
	format(pmode, sizeof(pmode), "mode %s -miRCp", channel);
	IRC_SendRaw(botid, pmode);
	return 1;
}
IRCCMD:bsay(botid, channel[], user[], host[], params[])
{
	if(!IRC_IsOp(botid, channel, user)) return IRC_Say(groupID, channel, "Invalid Level.");
	new bmsg[128], bmsg2[128];
	format(bmsg, sizeof(bmsg), "02%s on IRC: %s", BOT_1_NICKNAME, params);
	IRC_GroupSay(groupID, channel, bmsg);
	format(bmsg2, sizeof(bmsg2), ""CGREEN"%s on IRC:"CWHITE" %s", BOT_1_NICKNAME, params);
	SendClientMessageToAll(WHITE, bmsg2);
	return 1;
}
IRCCMD:isay(botid, channel[], user[], host[], params[])
{
    if(!IRC_IsAdmin(botid, channel, user)) return IRC_Say(groupID, channel, "Invalid Level.");
	if(isnull(params) || strlen(params) > 50) return IRC_GroupNotice(groupID, user, "4Invalid length. The length must be between 1 and 50 characters.");
	new amsg[128], amsg2[128];
	format(amsg, sizeof(amsg), "17Administrator %s on IRC:1 %s", user, params);
	IRC_GroupSay(groupID, channel, amsg);
	format(amsg2, sizeof(amsg2), ""CRED"Administrator %s on IRC:"CWHITE" %s", user, params);
	SendClientMessageToAll(WHITE, amsg2);
	return 1;
}
IRCCMD:credits(botid, channel[], user[], host[], params[])
{
    IRC_Notice(botid, user, "04     	[IRC script]			    ");
	IRC_Notice(botid, user, "04	Made by Deron_Green	and ejb	    ");
	IRC_Notice(botid, user, "04    Special thanks to Incognito,    ");
	IRC_Notice(botid, user, "04	Y_Less, SA-IRC network  		");
	IRC_Notice(botid, user, "04			And..  		  		    ");
	IRC_Notice(botid, user, "04	You for choosing GreenIRC v0.1! ");
	IRC_Notice(botid, user, "04___________________________________");
	return 1;
}
IRCCMD:explode(botid, channel[], user[], host[], params[])
{
    if(!IRC_IsOp(botid, channel, user)) return IRC_Say(groupID, channel, "Invalid Level.");
    new id, reason[80]; new pname[MAX_PLAYER_NAME];
    if(sscanf(params, "uS(No Reason)[80]", id, reason))
    {
        IRC_GroupSay(groupID, user, "04USAGE: !explode [ID] [Reason]");
	    return 1;
    }
    if(!IsPlayerConnected(id))
	{
	    IRC_GroupSay(groupID, user, "04ERROR: Invalid Player ID");
	    return 1;
	}
	new Float:x, Float:y, Float:z, string[100], str2[100];
	GetPlayerPos(id, x, y, z);
	CreateExplosion(x, y, z, 6, 10);
	CreateExplosion(x, y, z, 6, 10);
 	GetPlayerName(id, pname, sizeof(pname));
	format(string, sizeof(string), ""CORANGE"EXPLOSION: "CWHITE"IRC Administrator %s Has Exploded %s(%d) - Reason: %s", user, pname, id, reason);
	SendClientMessageToAll(WHITE, string);
	format(str2, sizeof(str2), "41(EXPLOSION):1 IRC Admin %s Exploded %s(%d) - Reason: %s", user, pname, id, reason);
	IRC_Say(groupID, ADMIN_CHANNEL, str2);
	return 1;
}
IRCCMD:getip(botid, channel[], user[], host[], params[])//ReV
{
    if(!IRC_IsHalfop(botid, channel, user)) return false;
	new giveplayerid, ip[16], str[128];
 	new giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "i", giveplayerid))
 	{
	IRC_GroupSay(groupID, ADMIN_CHANNEL, "Usage: !getip (playerid)");
	return false;
	}

	GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
	GetPlayerIp(giveplayerid, ip, sizeof(ip));

	if(!IsPlayerConnected(giveplayerid))
	{
		IRC_GroupSay(groupID, channel, "4()3 Invalid Player ID!");
		return 1;
	}
	format(str, 128, "2Player:1 %s(%i) 4IP:1  Is %s", giveplayer, giveplayerid, ip);
	IRC_GroupSay(groupID, channel, str);

 	#pragma unused botid, user
	return true;
}
IRCCMD:players(conn, channel[], user[], params[]) //made by Grove, taken from CYS Echo Bot 1.2
{
	new count, PlayerNames[512], string[256];
	for(new i=0; i<=MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(count == 0)
			{
				new PlayerName1[MAX_PLAYER_NAME];
				GetPlayerName(i, PlayerName1, sizeof(PlayerName1));
			 	format(PlayerNames, sizeof(PlayerNames),"2%s1", PlayerName1);
				count++;
			}
			else
			{
				new PlayerName1[MAX_PLAYER_NAME];
   				GetPlayerName(i, PlayerName1, sizeof(PlayerName1));
		 		format(PlayerNames, sizeof(PlayerNames),"%s, 2%s1", PlayerNames, PlayerName1);
				count++;
			}
		}
		else { if(count == 0) format(PlayerNames, sizeof(PlayerNames), "1No Players Online!"); }
	}

	new counter = 0;
	for(new i=0; i<=MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i)) counter++;
	}

	format(string, 256, "50Connected Players[%d]:1 %s", counter, PlayerNames);
	IRC_Say(conn, channel, string);
  	#pragma unused params,user
	return true;
}
IRCCMD:clearchat(conn, channel[], user[], message[])
{
	if(IRC_IsHalfop(conn, channel, user) == 0) return IRC_Say(conn, channel, "Invalid Level");
	{
	for( new i = 0; i <= 100; i ++ ) SendClientMessageToAll(WHITE, "" );
	}
	new string[256];
	format(string, sizeof(string), ""CRED"A IRC Administrator "CWHITE"has cleared the chat", user);

	SendClientMessageToAll(WHITE, string);
	IRC_Say(conn, channel, string);

	#pragma unused message
	return 1;
}
IRCCMD:warn(botid, channel[], user[], host[], params[])
{
	new ID; new reason[100]; new string[200]; new pname[MAX_PLAYER_NAME];new str[200];
	if(IRC_IsOp(botid, channel, user))
	{
		if(sscanf(params, "us[100]", ID, reason))
		{
			IRC_Say(groupID, channel, "Usage: !warn [ID] [reason]");
		}
		if(!IsPlayerConnected(ID))
		{
			IRC_Say(groupID, channel, "Invalid Player ID.");
			return 1;
		}
		GetPlayerName(ID, pname, 24);
		format(string, sizeof(string), "WARN: %s(%d) Has Been Warned By IRC Administrator %s - Reason: %s", pname, ID, user, reason);
		SendClientMessageToAll(WHITE, string);
		format(str, sizeof(str), "WARN: %s(%d) Has Been Warned By %s. Reason: %s", pname, ID, user, reason);
		IRC_Say(groupID, ADMIN_CHANNEL, str);
		SendClientMessage(ID, WHITE, "WARNED: You Have Been Issued A Warning By An IRC Administrator.");
		SendClientMessage(ID, WHITE, "Please Follow The Rules And Read /rules");
	}
	return 1;
}
IRCCMD:pm(botid, channel[], user[], host[], params[])
{
    new string[128], str1[128], id, pname[MAX_PLAYER_NAME];
    if(sscanf(params, "us[100]", id, str1))
    {
			IRC_Say(groupID, channel, "Usage: !pm [ID] [message]");
        	return 1;
    }
	if(!IsPlayerConnected(id)) return IRC_Say(groupID, channel, "Invalid Player ID.");
    {
        GetPlayerName(id, pname, sizeof(pname));
        format(string, sizeof(string), "PM To: %s(ID %d): %s", pname, id, str1);
		IRC_Say(groupID, channel, string);
        format(str1, sizeof(str1), ""HOT_PINK"PM From %s:"CWHITE" %s", user, str1);
        SendClientMessage(id, WHITE, str1);
    }
	return 1;
}
IRCCMD:slap(botid, channel[], user[], host[], params[])
{
    new id, str[128], str2[128], pname[MAX_PLAYER_NAME], Float:x, Float:y, Float:z;
    if(!IRC_IsHalfop(botid, channel, user)) return IRC_Say(groupID, channel, "Invalid Level");
   	{
    	if(sscanf(params, "us[128]", id, str))
    	{
			IRC_Say(groupID, channel, "Usage: !slap [ID] [reason]");
		}
    	GetPlayerName(id, pname, sizeof(pname));
    	format(str2, sizeof(str2), "53SLAP:1 %s Has Been Slapped By 39IRC Administrator1 %s - 4Reason:1 %s", pname, user, str);
		IRC_Say(groupID, channel, str2);
    	GetPlayerPos(id, x, y, z);
    	SetPlayerPos(id, x, y, z+10);
	}
	return 1;
}
IRCCMD:givecash(botid, channel[], user[], host[], params[])
{
    new id, amount, pname[MAX_PLAYER_NAME], Mstr[128];
    if(!IRC_IsOp(botid, channel, user)) return IRC_Say(groupID, channel, "Invalid Level");
   	{
    	if(sscanf(params,"ui", id, amount))
		{
			IRC_Say(groupID, channel, "Usage: !givecash [ID] [Amount]");
		}
    	if(!IsPlayerConnected(id)) return IRC_Say(groupID, channel, "Invalid Player ID.");
    	{
    	GetPlayerName(id, pname, sizeof(pname));
    	GivePlayerMoney(id, amount);
    	format(Mstr, sizeof(Mstr), "44CASH::1 %s Has Been Given $%d By IRC Administrator %s", pname, amount, user);
		IRC_Say(groupID, ADMIN_CHANNEL, Mstr);
    	}
    }
    return 1;
}
IRCCMD:setscore(botid, channel[], user[], host[], params[])
{
	new id, score, pname[MAX_PLAYER_NAME], str[128];
	if(!IRC_IsOp(botid, channel, user)) return IRC_Say(groupID, channel, "Invalid Level");
	{
		if (sscanf(params, "ui", id, score))
		{
			IRC_Say(groupID, channel, "Usage: !setscore [ID] [score]");
		}
		if(!IsPlayerConnected(id)) return IRC_Say(groupID, channel, "Invalid Player ID.");
		{
        SetPlayerScore(id, score);
        GetPlayerName(id, pname, sizeof(pname));
       	format(str, sizeof(str), "57SCORE::1 %s Score Has Been Set To %d By IRC Administrator %s", pname, score, user);
		IRC_Say(groupID, channel, str);
		}
   	}
	return 1;
}
IRCCMD:loc(botid, channel[], user[], host[], params[])
{
	new id, zone[MAX_ZONE_NAME], pname[MAX_PLAYER_NAME], str[128];
	if(!IRC_IsOp(botid, channel, user)) return IRC_Say(groupID, channel, "Invalid Level");
	{
		if (sscanf(params, "u", id))
		{
			IRC_Say(groupID, channel, "Usage: !loc [ID]");
		}
		if(!IsPlayerConnected(id)) return IRC_Say(groupID, channel, "Invalid Player ID.");
		{
		GetPlayer2DZone(id, zone, MAX_ZONE_NAME);
        GetPlayerName(id, pname, sizeof(pname));
       	format(str, sizeof(str), "57LOCATION:1 17Player:1 %s -  4Location:1 %s", pname, zone);
		IRC_Say(groupID, channel, str);
		}
	}
	return 1;
}
IRCCMD:setwanted(botid, channel[], user[], host[], params[])
{
	new id, pname[MAX_PLAYER_NAME], wl, Wstr[128];
	if(!IRC_IsOp(botid, channel, user)) return IRC_Say(groupID, channel, "Invalid Level");
 	{
 	    if (sscanf(params, "ui", id, wl))
 	    {
 	        IRC_Say(groupID, channel, "Usage: !setwanted [ID] [Level]");
  		}
  		if(!IsPlayerConnected(id)) return IRC_Say(groupID, channel, "Invalid Player ID");
  		{
			SetPlayerWantedLevel(id, wl);
			GetPlayerName(id, pname, sizeof(pname));
			format(Wstr, sizeof(Wstr), "4WANTEDLEVEL:1 IRC Administrator %s Has Set %s Wanted Level To %d", user, pname, wl);
			IRC_Say(groupID, channel, Wstr);
		}
	}
	return 1;
}
stock GetPlayer2DZone(playerid, zone[], len)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
 	for(new i = 0; i != sizeof(gSAZones); i++ )
 	{
		if(x >= gSAZones[i][SAZONE_AREA][0] && x <= gSAZones[i][SAZONE_AREA][3] && y >= gSAZones[i][SAZONE_AREA][1] && y <= gSAZones[i][SAZONE_AREA][4])
		{
		    return format(zone, len, gSAZones[i][SAZONE_NAME], 0);
		}
	}
	return 0;
}
