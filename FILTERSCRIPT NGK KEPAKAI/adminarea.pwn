
//______________________________________________________________________________
//              ADMIN AREA BY Chris10
//______________________________________________________________________________

//_-_includes
#include <a_samp>
#include <streamer>

//____[Gates & other]____
new admingate;
new adminsecretgate;
new pickupup;

//________[Admin Vehicle (Hydra)|______________
new adminhydra;

//____[Forwards-Timers]____
forward AdminGateClose(playerid);
forward SecretGateClose(playerid);


public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Admin Area Version [0.7] ");
	printf(" -By: Chris10			 ");
	print("--------------------------------------\n");
/////////////////////////////Objects & Cars////////////////////////////////////////////
	CreateDynamicObject(18450,983.29980469,-2346.39941406,11.69999981,0.00000000,0.00000000,41.99523926); //object(cs_roadbridge04) (1)
	CreateDynamicObject(18450,923.90002441,-2399.80004883,11.69999981,0.00000000,0.00000000,221.99523926); //object(cs_roadbridge04) (2)
	CreateDynamicObject(12814,885.89941406,-2438.59960938,12.00000000,0.00000000,0.00000000,43.99475098); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,865.40002441,-2458.50000000,12.00000000,0.00000000,0.00000000,43.99475098); //object(cuntyeland04) (2)
	CreateDynamicObject(12814,844.00000000,-2479.10009766,12.00000000,0.00000000,0.00000000,43.99475098); //object(cuntyeland04) (3)
	CreateDynamicObject(12814,802.59997559,-2463.80004883,12.10000038,0.00000000,0.24719238,313.98925781); //object(cuntyeland04) (4)
	CreateDynamicObject(12814,823.00000000,-2499.30004883,12.00000000,0.00000000,0.00000000,43.99475098); //object(cuntyeland04) (6)
	CreateDynamicObject(12814,838.09997559,-2429.30004883,12.00000000,0.00000000,0.00000000,313.98925781); //object(cuntyeland04) (7)
	CreateDynamicObject(12814,893.69921875,-2486.29980469,12.00000000,0.00000000,0.00000000,313.98925781); //object(cuntyeland04) (8)
	CreateDynamicObject(3749,908.29998779,-2413.69995117,17.89999962,0.00000000,0.00000000,313.98925781); //object(clubgate01_lax) (1)
	CreateDynamicObject(10244,780.39941406,-2461.69921875,8.60000038,0.00000000,0.00000000,225.99975586); //object(vicjump_sfe) (1)
	CreateDynamicObject(3187,847.89941406,-2424.39941406,16.10000038,0.00000000,0.00000000,223.99475098); //object(nt_gasstation) (1)
	CreateDynamicObject(7885,851.69921875,-2463.59960938,12.00000000,0.00000000,0.00000000,223.99475098); //object(vegasglfhse1) (1)
	CreateDynamicObject(987,836.90002441,-2431.50000000,12.00000000,0.00000000,0.00000000,132.00000000); //object(elecfence_bar) (1)
	CreateDynamicObject(987,834.09960938,-2428.50000000,12.00000000,0.00000000,0.00000000,131.98974609); //object(elecfence_bar) (2)
	CreateDynamicObject(987,882.69921875,-2480.59960938,12.00000000,0.00000000,0.00000000,313.99475098); //object(elecfence_bar) (3)
	CreateDynamicObject(987,890.70001221,-2489.19995117,12.00000000,0.00000000,0.00000000,313.99475098); //object(elecfence_bar) (4)
	CreateDynamicObject(987,892.90002441,-2491.60009766,12.00000000,0.00000000,0.00000000,313.99475098); //object(elecfence_bar) (5)
	CreateDynamicObject(993,855.79998779,-2538.60009766,13.60000038,0.00000000,0.00000000,40.00000000); //object(bar_barrier10) (1)
	CreateDynamicObject(993,848.09997559,-2538.19995117,13.60000038,0.00000000,0.00000000,313.99572754); //object(bar_barrier10) (2)
	CreateDynamicObject(993,848.59997559,-2530.89990234,13.60000038,0.00000000,0.00000000,219.99475098); //object(bar_barrier10) (3)
	CreateDynamicObject(2114,855.79980469,-2532.09960938,12.19999981,0.00000000,0.00000000,0.00000000); //object(basketball) (1)
	CreateDynamicObject(946,850.70001221,-2539.39990234,14.19999981,0.00000000,0.00000000,324.00000000); //object(bskball_lax) (1)
	CreateDynamicObject(946,847.00000000,-2535.30004883,14.19999981,0.00000000,0.00000000,323.99780273); //object(bskball_lax) (2)
	CreateDynamicObject(1764,848.69921875,-2524.89941406,12.00000000,0.00000000,0.00000000,309.99572754); //object(low_couch_2) (1)
	CreateDynamicObject(2093,848.29980469,-2527.50000000,12.00000000,0.00000000,0.00000000,87.98950195); //object(tv_ward_low) (1)
	CreateDynamicObject(10244,788.29998779,-2459.10009766,4.00000000,0.00000000,0.00000000,136.48907471); //object(vicjump_sfe) (2)
	CreateDynamicObject(12814,809.59960938,-2462.29980469,4.80000019,0.00000000,0.00000000,312.98400879); //object(cuntyeland04) (9)
	CreateDynamicObject(1595,824.90002441,-2502.50000000,17.29999924,0.00000000,0.00000000,336.00000000); //object(satdishbig) (1)
	CreateDynamicObject(8131,808.70001221,-2496.60009766,22.70000076,0.00000000,0.00000000,42.00000000); //object(vgschurch02_lvs) (1)
	CreateDynamicObject(993,883.59997559,-2513.89990234,13.60000038,0.00000000,0.00000000,227.99023438); //object(bar_barrier10) (4)
	CreateDynamicObject(993,883.29998779,-2507.50000000,13.60000038,0.00000000,0.00000000,317.98974609); //object(bar_barrier10) (5)
	CreateDynamicObject(993,876.40002441,-2507.39990234,13.60000038,0.00000000,0.00000000,227.98828125); //object(bar_barrier10) (6)
	CreateDynamicObject(2008,874.29998779,-2511.39990234,12.00000000,0.00000000,0.00000000,46.00000000); //object(officedesk1) (1)
	CreateDynamicObject(2008,876.09997559,-2509.60009766,12.00000000,0.00000000,0.00000000,45.99975586); //object(officedesk1) (2)
	CreateDynamicObject(2008,878.00000000,-2507.19995117,12.00000000,0.00000000,0.00000000,45.99975586); //object(officedesk1) (3)
	CreateDynamicObject(2008,881.40002441,-2507.10009766,12.00000000,0.00000000,0.00000000,315.99975586); //object(officedesk1) (4)
	CreateDynamicObject(2008,883.29998779,-2508.69995117,12.00000000,0.00000000,0.00000000,315.99426270); //object(officedesk1) (5)
	CreateDynamicObject(2008,884.29998779,-2512.50000000,12.00000000,0.00000000,0.00000000,227.99426270); //object(officedesk1) (6)
	CreateDynamicObject(2008,882.50000000,-2514.60009766,12.00000000,0.00000000,0.00000000,227.99377441); //object(officedesk1) (7)
	CreateDynamicObject(2008,880.90002441,-2516.39990234,12.00000000,0.00000000,0.00000000,227.99377441); //object(officedesk1) (8)
	CreateDynamicObject(2748,832.29998779,-2510.10009766,12.60000038,0.00000000,0.00000000,50.00000000); //object(cj_donut_chair2) (1)
	CreateDynamicObject(2748,833.29998779,-2508.89990234,12.60000038,0.00000000,0.00000000,49.99877930); //object(cj_donut_chair2) (2)
	CreateDynamicObject(2748,834.29998779,-2507.69995117,12.60000038,0.00000000,0.00000000,49.99877930); //object(cj_donut_chair2) (3)
	CreateDynamicObject(2748,837.00000000,-2510.00000000,12.60000038,0.00000000,0.00000000,229.99877930); //object(cj_donut_chair2) (4)
	CreateDynamicObject(2748,836.00000000,-2511.19995117,12.60000038,0.00000000,0.00000000,229.99328613); //object(cj_donut_chair2) (5)
	CreateDynamicObject(2748,835.00000000,-2512.39990234,12.60000038,0.00000000,0.00000000,229.99328613); //object(cj_donut_chair2) (6)
	CreateDynamicObject(2762,835.50000000,-2509.10009766,12.39999962,0.00000000,0.00000000,50.00000000); //object(cj_chick_table) (1)
	CreateDynamicObject(2762,834.20001221,-2510.69995117,12.39999962,0.00000000,0.00000000,49.99877930); //object(cj_chick_table) (2)
	CreateDynamicObject(2784,832.00000000,-2513.19995117,13.30000019,0.00000000,0.00000000,319.99731445); //object(ab_slottable6) (1)
	CreateDynamicObject(3383,838.59997559,-2517.19995117,12.00000000,0.00000000,0.00000000,43.99475098); //object(a51_labtable1_) (1)
	CreateDynamicObject(3383,841.79998779,-2514.30004883,12.00000000,0.00000000,0.00000000,43.99475098); //object(a51_labtable1_) (2)
	CreateDynamicObject(839,845.59997559,-2496.30004883,13.39999962,0.00000000,0.00000000,0.00000000); //object(dead_tree_11) (1)
	CreateDynamicObject(687,838.20001221,-2445.60009766,12.00000000,0.00000000,0.00000000,0.00000000); //object(sm_fir_) (1)
	CreateDynamicObject(687,816.09997559,-2494.60009766,12.00000000,0.00000000,0.00000000,0.00000000); //object(sm_fir_) (2)
	CreateDynamicObject(687,847.50000000,-2529.89990234,12.00000000,0.00000000,0.00000000,0.00000000); //object(sm_fir_) (3)
	CreateDynamicObject(687,814.50000000,-2467.19995117,12.00000000,0.00000000,0.00000000,0.00000000); //object(sm_fir_) (4)
	CreateDynamicObject(687,887.20001221,-2499.60009766,12.00000000,0.00000000,0.00000000,0.00000000); //object(sm_fir_) (5)
	CreateDynamicObject(687,830.20001221,-2513.50000000,12.00000000,0.00000000,0.00000000,0.00000000); //object(sm_fir_) (6)
	CreateDynamicObject(687,830.00000000,-2478.50000000,12.00000000,0.00000000,0.00000000,0.00000000); //object(sm_fir_) (7)
	CreateDynamicObject(687,851.00000000,-2491.00000000,12.00000000,0.00000000,0.00000000,0.00000000); //object(sm_fir_) (8)
	CreateDynamicObject(12814,858.29998779,-2506.89990234,12.00000000,0.00000000,0.00000000,43.98925781); //object(cuntyeland04) (10)
	CreateDynamicObject(12814,844.09997559,-2520.60009766,12.00000000,0.00000000,0.00000000,43.99475098); //object(cuntyeland04) (11)
	CreateDynamicObject(12814,814.70001221,-2470.60009766,-3.00000000,359.93408203,270.99426270,314.48364258); //object(cuntyeland04) (13)
	CreateDynamicObject(12814,799.00000000,-2485.80004883,-3.00000000,359.93408203,270.99426270,225.73657227); //object(cuntyeland04) (14)
	CreateDynamicObject(12814,809.89941406,-2441.39941406,-2.90000010,359.93408203,270.99426270,133.97827148); //object(cuntyeland04) (15)
	CreateDynamicObject(3824,814.09997559,-2444.30004883,8.10000038,0.00000000,0.00000000,224.74731445); //object(box_hse_10_sfxrf) (1)
	CreateDynamicObject(3842,826.09960938,-2459.29980469,8.30000019,0.00000000,0.00000000,317.99926758); //object(box_hse_14_sfxrf) (1)
	CreateDynamicObject(8131,813.50000000,-2503.39990234,22.70000076,0.00000000,0.00000000,41.99523926); //object(vgschurch02_lvs) (2)
	CreateDynamicObject(900,814.40002441,-2451.30004883,14.60000038,0.00000000,0.00000000,260.00000000); //object(searock04) (1)
	CreateDynamicObject(12814,802.39941406,-2463.69921875,12.00000000,359.75006104,179.75292969,133.98815918); //object(cuntyeland04) (4)
	CreateDynamicObject(8171,813.00000000,-2441.10009766,-57.09999847,271.76330566,188.12988281,232.12463379); //object(vgssairportland06) (1)
	CreateDynamicObject(8171,837.00000000,-2418.69995117,-57.09999847,272.25769043,186.33361816,230.33386230); //object(vgssairportland06) (2)
	CreateDynamicObject(8171,874.70001221,-2407.50000000,-57.20000076,271.02172852,194.05151367,149.55749512); //object(vgssairportland06) (3)
	CreateDynamicObject(8171,864.19921875,-2423.69921875,-57.09999847,272.25769043,186.32812500,232.32238770); //object(vgssairportland06) (4)
	CreateDynamicObject(8171,919.79980469,-2454.39941406,-57.09999847,271.26342773,191.30493164,145.55236816); //object(vgssairportland06) (6)
	CreateDynamicObject(8171,897.29998779,-2431.19995117,-57.20000076,271.26342773,191.30493164,145.55236816); //object(vgssairportland06) (7)
	CreateDynamicObject(8171,892.00000000,-2425.69995117,-57.20000076,271.26342773,191.30493164,146.30236816); //object(vgssairportland06) (8)
	CreateDynamicObject(2784,837.20001221,-2506.60009766,13.30000019,0.00000000,0.00000000,319.99328613); //object(ab_slottable6) (1)
	CreateDynamicObject(2784,838.09997559,-2512.80004883,13.30000019,0.00000000,0.00000000,231.99328613); //object(ab_slottable6) (1)
	CreateDynamicObject(2784,831.00000000,-2506.60009766,13.30000019,0.00000000,0.00000000,231.99279785); //object(ab_slottable6) (1)
	CreateDynamicObject(7617,851.00000000,-2464.69995117,33.29999924,0.00000000,0.00000000,318.00000000); //object(vgnbballscorebrd) (1)
	CreateDynamicObject(13630,1005.79998779,-2325.89990234,20.50000000,0.00000000,0.00000000,211.99670410); //object(8screen) (1)
	CreateDynamicObject(14781,870.79998779,-2521.69995117,13.10000038,0.00000000,0.00000000,314.00000000); //object(in_bxing05) (1)
	CreateDynamicObject(14781,866.09997559,-2526.10009766,13.10000038,0.00000000,0.00000000,313.99877930); //object(in_bxing05) (2)
	CreateDynamicObject(3819,864.29998779,-2518.39990234,12.89999962,0.00000000,0.00000000,133.99475098); //object(bleacher_sfsx) (1)
	CreateDynamicObject(8171,806.09997559,-2444.50000000,-56.90000153,270.79235840,289.14007568,332.39599609); //object(vgssairportland06) (10)
	CreateDynamicObject(12814,906.39941406,-2474.19921875,12.00000000,0.00000000,0.00000000,313.98925781); //object(cuntyeland04) (8)
	CreateDynamicObject(8171,918.79998779,-2480.39990234,-57.09999847,271.26342773,191.30493164,55.80236816); //object(vgssairportland06) (6)
	CreateDynamicObject(8171,890.59997559,-2508.10009766,-57.00000000,271.26342773,191.29943848,55.54943848); //object(vgssairportland06) (6)
	CreateDynamicObject(8171,863.70001221,-2534.30004883,-57.00000000,271.26342773,191.29394531,55.54687500); //object(vgssairportland06) (6)
	CreateDynamicObject(8171,838.29998779,-2533.39990234,-57.00000000,271.26342773,191.29394531,326.04687500); //object(vgssairportland06) (6)
	CreateDynamicObject(8171,810.09997559,-2505.00000000,-57.00000000,271.26342773,191.29394531,326.04675293); //object(vgssairportland06) (6)
	CreateDynamicObject(8171,788.90002441,-2483.50000000,-57.09999847,271.26342773,191.29394531,326.04675293); //object(vgssairportland06) (6)
	CreateDynamicObject(12814,778.59997559,-2471.89990234,-13.00000000,272.01519775,172.95599365,216.94958496); //object(cuntyeland04) (4)
	CreateDynamicObject(687,883.79998779,-2494.60009766,12.00000000,0.00000000,0.00000000,0.00000000); //object(sm_fir_) (5)
	CreateDynamicObject(687,881.20001221,-2498.89990234,12.00000000,0.00000000,0.00000000,0.00000000); //object(sm_fir_) (5)
	CreateDynamicObject(12814,778.09997559,-2471.60009766,-13.30000019,272.01049805,172.95227051,38.69702148); //object(cuntyeland04) (4)
	CreateDynamicObject(12814,841.20001221,-2443.39990234,-3.00000000,359.93408203,270.99426270,316.48413086); //object(cuntyeland04) (17)
	CreateDynamicObject(12814,838.79998779,-2429.19995117,4.80000019,0.00000000,0.00000000,312.98400879); //object(cuntyeland04) (9)
	CreateDynamicObject(12814,832.09997559,-2425.30004883,-3.00000000,359.93408203,270.99426270,138.48413086); //object(cuntyeland04) (17)
	CreateDynamicObject(8171,848.40002441,-2406.30004883,-57.20000076,271.02172852,194.05151367,237.05749512); //object(vgssairportland06) (3)
	CreateDynamicObject(8171,876.40002441,-2406.39990234,-57.20000076,271.01623535,194.04602051,326.04699707); //object(vgssairportland06) (3)
	CreateDynamicObject(8171,847.79998779,-2405.30004883,-57.20000076,271.01623535,194.04602051,58.80200195); //object(vgssairportland06) (3)
	CreateDynamicObject(12814,867.00000000,-2422.89990234,-10.19999981,0.00000000,90.00000000,43.23388672); //object(cuntyeland04) (9)
	CreateDynamicObject(12814,838.79998779,-2429.19995117,11.89999962,0.00000000,180.00000000,130.98406982); //object(cuntyeland04) (9)
	CreateDynamicObject(12814,853.79980469,-2420.19921875,4.80000019,0.00000000,0.00000000,311.73156738); //object(cuntyeland04) (9)
	CreateDynamicObject(12814,868.59997559,-2435.30004883,12.00000000,0.00000000,0.00000000,313.99475098); //object(cuntyeland04) (1)
	CreateDynamicObject(2780,822.00000000,-2436.89990234,4.80000019,0.00000000,0.00000000,0.00000000); //object(cj_smoke_mach) (1)
	CreateDynamicObject(3267,874.90002441,-2412.69995117,12.00000000,0.00000000,0.00000000,312.00000000); //object(mil_samsite) (1)
	CreateDynamicObject(3267,881.59997559,-2417.50000000,12.00000000,0.00000000,0.00000000,311.99523926); //object(mil_samsite) (2)
	CreateDynamicObject(3267,903.20001221,-2440.19995117,12.00000000,0.00000000,0.00000000,311.99523926); //object(mil_samsite) (3)
	CreateDynamicObject(3267,906.59997559,-2446.39990234,12.00000000,0.00000000,0.00000000,311.99523926); //object(mil_samsite) (4)
	CreateDynamicObject(2985,834.09997559,-2445.19995117,4.80000019,0.00000000,0.00000000,218.00000000); //object(minigun_base) (1)
	CreateDynamicObject(2985,830.09997559,-2429.80004883,4.80000019,0.00000000,0.00000000,217.99621582); //object(minigun_base) (2)
	CreateDynamicObject(3279,945.90002441,-2366.69995117,12.80000019,0.00000000,0.00000000,310.00000000); //object(a51_spottower) (1)
	CreateDynamicObject(3279,957.00000000,-2383.39941406,12.80000019,0.00000000,0.00000000,131.99523926); //object(a51_spottower) (2)
	CreateDynamicObject(3524,916.90002441,-2413.30004883,14.89999962,0.00000000,0.00000000,90.00000000); //object(skullpillar01_lvs) (1)
	CreateDynamicObject(3524,908.70001221,-2405.80004883,14.89999962,0.00000000,0.00000000,90.00000000); //object(skullpillar01_lvs) (2)
	CreateDynamicObject(3524,868.59997559,-2445.10009766,14.89999962,0.00000000,0.00000000,120.00000000); //object(skullpillar01_lvs) (3)
	CreateDynamicObject(3524,871.90002441,-2447.80004883,14.89999962,0.00000000,0.00000000,119.99813843); //object(skullpillar01_lvs) (4)
	CreateDynamicObject(3524,850.79998779,-2427.10009766,3.70000005,0.00000000,0.00000000,324.00000000); //object(skullpillar01_lvs) (5)
	CreateDynamicObject(3524,851.70001221,-2428.00000000,3.70000005,0.00000000,0.00000000,323.99780273); //object(skullpillar01_lvs) (6)
	CreateDynamicObject(3524,851.90002441,-2427.10009766,3.70000005,0.00000000,0.00000000,323.99780273); //object(skullpillar01_lvs) (7)
	CreateDynamicObject(3524,843.90002441,-2419.19995117,3.70000005,0.00000000,0.00000000,323.99780273); //object(skullpillar01_lvs) (8)
	CreateDynamicObject(3524,843.00000000,-2418.30004883,3.70000005,0.00000000,0.00000000,323.99780273); //object(skullpillar01_lvs) (9)
	CreateDynamicObject(3524,844.20001221,-2417.80004883,3.70000005,0.00000000,0.00000000,323.99780273); //object(skullpillar01_lvs) (10)
	CreateDynamicObject(6965,918.59997559,-2467.60009766,15.10000038,0.00000000,0.00000000,0.00000000); //object(venefountain02) (1)
	CreateDynamicObject(12814,768.29998779,-2496.69995117,12.39999962,359.25469971,0.24627686,313.74365234); //object(cuntyeland04) (4)
	CreateDynamicObject(12814,756.29998779,-2491.00000000,-12.80000019,271.03460693,13.77380371,55.76208496); //object(cuntyeland04) (4)
	CreateDynamicObject(12814,756.50000000,-2511.00000000,-12.69999981,272.00500488,172.94677734,306.94201660); //object(cuntyeland04) (4)
	CreateDynamicObject(12814,772.90002441,-2510.10009766,-12.80000019,271.99951172,172.94128418,32.94152832); //object(cuntyeland04) (4)
	CreateDynamicObject(12814,783.70001221,-2500.89990234,-12.89999962,271.99951172,172.94128418,34.18676758); //object(cuntyeland04) (4)
	CreateDynamicObject(2114,857.20001221,-2533.69995117,12.19999981,0.00000000,0.00000000,0.00000000); //object(basketball) (1)
	CreateDynamicObject(1764,846.70001221,-2522.30004883,12.00000000,0.00000000,0.00000000,309.99572754); //object(low_couch_2) (1)
	CreateDynamicObject(2093,846.00000000,-2524.89990234,12.00000000,0.00000000,0.00000000,87.98950195); //object(tv_ward_low) (1)
	CreateDynamicObject(987,863.90002441,-2420.00000000,11.89999962,0.00000000,0.00000000,46.00000000); //object(elecfence_bar) (6)
	CreateDynamicObject(987,876.40002441,-2407.30004883,11.89999962,0.00000000,0.00000000,225.99975586); //object(elecfence_bar) (7)
	CreateDynamicObject(987,863.50000000,-2419.89990234,11.89999962,0.00000000,0.00000000,133.99975586); //object(elecfence_bar) (8)
	CreateDynamicObject(987,857.90002441,-2413.89990234,11.89999962,0.00000000,0.00000000,134.99450684); //object(elecfence_bar) (10)
	CreateDynamicObject(987,849.59997559,-2405.19995117,11.89999962,0.00000000,0.00000000,44.99450684); //object(elecfence_bar) (11)
	CreateDynamicObject(987,854.29998779,-2400.60009766,11.89999962,0.00000000,0.00000000,44.98901367); //object(elecfence_bar) (12)
	CreateDynamicObject(987,861.90002441,-2392.80004883,11.89999962,0.00000000,0.00000000,314.98901367); //object(elecfence_bar) (13)
	CreateDynamicObject(987,867.79998779,-2398.89990234,11.89999962,0.00000000,0.00000000,314.98352051); //object(elecfence_bar) (14)
	CreateDynamicObject(13132,903.20001221,-2477.30004883,15.19999981,0.00000000,0.00000000,318.00000000); //object(ce_bar01) (1)
	CreateDynamicObject(8210,914.90002441,-2487.00000000,15.00000000,0.00000000,0.00000000,224.00000000); //object(vgsselecfence12) (1)
	CreateDynamicObject(8210,875.00000000,-2525.50000000,15.00000000,0.00000000,0.00000000,223.99475098); //object(vgsselecfence12) (2)
	CreateDynamicObject(8210,813.59997559,-2511.50000000,15.00000000,0.00000000,0.00000000,133.49475098); //object(vgsselecfence12) (3)
	CreateDynamicObject(8210,800.29998779,-2445.50000000,15.00000000,0.00000000,0.00000000,43.23937988); //object(vgsselecfence12) (4)
	CreateDynamicObject(987,827.20001221,-2421.00000000,12.00000000,0.00000000,0.00000000,219.98974609); //object(elecfence_bar) (2)
	CreateDynamicObject(987,859.59997559,-2540.80004883,12.00000000,0.00000000,0.00000000,221.98474121); //object(elecfence_bar) (2)
	CreateDynamicObject(987,851.29998779,-2548.50000000,12.00000000,0.00000000,0.00000000,133.98425293); //object(elecfence_bar) (2)
	CreateDynamicObject(987,843.29998779,-2540.00000000,12.00000000,0.00000000,0.00000000,135.98376465); //object(elecfence_bar) (2)
	CreateDynamicObject(987,837.79998779,-2534.30004883,12.00000000,0.00000000,0.00000000,140.73327637); //object(elecfence_bar) (2)
    AddStaticVehicleEx(556,885.79998779,-2462.19995117,16.79999924,312.00000000,-1,-1,15); //Monster A
	AddStaticVehicleEx(400,877.70001221,-2451.00000000,17.10000038,316.00000000,-1,-1,15); //Landstalker
	AddStaticVehicleEx(503,872.29998779,-2420.39990234,15.50000000,314.00000000,-1,-1,15); //Hotring Racer B
	AddStaticVehicleEx(503,875.79998779,-2423.10009766,15.50000000,313.99475098,-1,-1,15); //Hotring Racer B
	AddStaticVehicleEx(503,879.20001221,-2426.39990234,15.50000000,313.99475098,-1,-1,15); //Hotring Racer B
	AddStaticVehicleEx(411,900.29998779,-2437.10009766,12.80000019,136.00000000,-1,-1,15); //Infernus
	AddStaticVehicleEx(411,906.20001221,-2443.00000000,12.80000019,135.99975586,-1,-1,15); //Infernus
	AddStaticVehicleEx(556,899.50000000,-2459.50000000,16.79999924,47.99523926,-1,-1,15); //Monster A
	CreateDynamicObject(987,863.50000000,-2419.89990234,16.20000076,0.00000000,0.00000000,133.99475098); //object(elecfence_bar) (8)
	CreateDynamicObject(987,858.09997559,-2412.69995117,16.20000076,0.00000000,0.00000000,133.99475098); //object(elecfence_bar) (8)
	CreateDynamicObject(691,862.09997559,-2435.50000000,12.00000000,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree4_big) (1)
	CreateDynamicObject(691,910.20001221,-2451.89990234,12.00000000,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree4_big) (2)
	CreateDynamicObject(691,915.70001221,-2476.30004883,12.00000000,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree4_big) (3)
	CreateDynamicObject(691,885.40002441,-2420.00000000,12.00000000,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree4_big) (4)
	CreateDynamicObject(5154,766.00000000,-2497.69995117,47.90000153,0.00000000,0.00000000,133.98925781); //object(dk_cargoshp03d) (1)
	AddStaticVehicleEx(561,848.79980469,-2432.79980469,8.19999981,315.99975586,-1,-1,15); //Stratum
	AddStaticVehicleEx(568,839.29998779,-2421.10009766,8.10000038,316.00000000,-1,-1,15); //Bandito

////////////////////////////////////////////////////////////////////////////////

//_______________________________________[Gates & other]________________________
	admingate = CreateDynamicObject(2938,907.20001221,-2414.60009766,14.69999981,0.00000000,0.00000000,224.74182129); //object(shutter_vegas) (1)
	adminsecretgate = CreateDynamicObject(3829,820.39941406,-2452.79980469,8.30000019,0.00000000,0.00000000,43.99475098); //object(box_hse_04_sfxrf) (1)
	pickupup = CreateDynamicObject(5154,766.00000000,-2497.69995117,9.60000038,0.00000000,0.00000000,133.98974609); //object(dk_cargoshp03d) (1)
//______________________________________________________________________________
//____________________________[Admin Only Vehicle]______________________________
	adminhydra = AddStaticVehicleEx(520,863.50000000,-2407.30004883,10.00000000,313.99475098,-1,-1,15); //Hydra
//______________________________________________________________________________
	return 1;
}

public OnFilterScriptExit()
{
	printf("\n--------> Admin Area by Chris10 Unloaded. <----------");
	return 1;
}
public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	CreateDynamicPickup(1275,2,767.1139,-2498.0601,13.7720,-1,-1,-1,100);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if (strcmp("/ahelp", cmdtext, true, 10) == 0)
	{
		if(IsPlayerAdmin(playerid))
		{
		SendClientMessage(playerid,0x0080FFFF,"_____| Admin Area Commands |_____");
		SendClientMessage(playerid,0xFF0000FF,"/adminarea |-{FFFFFF}Teleports you to the Admin Area [OUTSDIDE THE GATE]");
		SendClientMessage(playerid,0xFF0000FF,"/adminhouse |-{FFFFFF}Teleports you to the Admin House");
		SendClientMessage(playerid,0xFF0000FF,"/adminpark |-{FFFFFF}Teleport you to the admin park [BEHIND ADMIN HOUSE]");
		SendClientMessage(playerid,0xFF0000FF,"/agate |-{FFFFFF}Opens the main Admin Gate");
		SendClientMessage(playerid,0xFF0000FF,"/secretarea |-{FFFFFF}Opens The Secret Gate");
        SendClientMessage(playerid,0x0080FFFF,"_________________________________");
		}
		else
		{
		SendClientMessage(playerid,0xFF0000FF,"Only Admins Can Use This Command");
		}
		return 1;
	}
		if (strcmp("/adminarea", cmdtext, true, 10) == 0)
	{
		if(IsPlayerAdmin(playerid))
		{
		SetPlayerPos(playerid,923.1180,-2401.5078,13.0437);
		SetPlayerFacingAngle(playerid,131.3587);
		SendClientMessage(playerid,0xFFFF00FF,"You have teleported to the Admin Area");
		}
		else
		{
		SendClientMessage(playerid,0xFF0000FF,"Only Admins Can Use This Command");
		}
		return 1;
	}
		if (strcmp("/adminhouse", cmdtext, true, 10) == 0)
	{
		if(IsPlayerAdmin(playerid))
		{
		SetPlayerPos(playerid,869.1640,-2447.3088,13.0078);
		SendClientMessage(playerid,0xFFFF00FF,"You have teleported to the Admin House");
		}
		else
		{
		SendClientMessage(playerid,0xFF0000FF,"Only Admins Can Use This Command");
		}
		return 1;
	}
	    if (strcmp("/adminpark", cmdtext, true, 10) == 0)
	{
		if(IsPlayerAdmin(playerid))
		{
		SetPlayerPos(playerid,842.7676,-2491.4177,13.0078);
		SendClientMessage(playerid,0xFFFF00FF,"You have teleported to the Admin Park");
		}
		else
		{
		SendClientMessage(playerid,0xFF0000FF,"Only Admins Can Use This Command");
		}
		return 1;
	}
	if (strcmp("/agate", cmdtext, true, 10) == 0)
	{
	    if(IsPlayerAdmin(playerid))
		{
		MoveDynamicObject(admingate,907.90002441,-2413.00000000,21.10000038,2.0);
		SendClientMessage(playerid,0x80FF00FF,"Admin Main Gate is now openning.");
		SetTimer("AdminGateClose",7000,0);
		}
		else
		{
		SendClientMessage(playerid,0xFF0000FF,"Only Admins Can Use This Command");
		}
		return 1;
	}
	if (strcmp("/secretarea", cmdtext, true, 10) == 0)
	{
		if(IsPlayerAdmin(playerid))
		{
		MoveDynamicObject(adminsecretgate,820.40002441,-2452.80004883,0.30000001,2.0);
		SendClientMessage(playerid,0x80FF00FF,"Secret Gate is now openning.");
		SetTimer("SecretGateClose",7000,0);
		}
		else
		{
		SendClientMessage(playerid,0xFF0000FF,"Only Admins Can Use This Command");
		}
		return 1;
	}
	return 0;
}
public AdminGateClose(playerid)
{
		MoveDynamicObject(admingate,907.20001221,-2414.60009766,14.69999981,2.0);
		SendClientMessage(playerid,0xFF8000FF,"Admin Gate is now closing");
		return 1;
}
public SecretGateClose(playerid)
{
		MoveDynamicObject(adminsecretgate,820.39941406,-2452.79980469,8.30000019,2.0);
		SendClientMessage(playerid,0xFF8000FF,"Secret Gate is now closing");
		return 1;
}
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    if(vehicleid == adminhydra)
	{
 	if(!IsPlayerAdmin(playerid))
 	{
 	RemovePlayerFromVehicle(playerid);
 	SendClientMessage(playerid,0xFF0000FF,"You are not allowed to use this vehicle");
 	}
	 else
 	{
 	SendClientMessage(playerid,0x80FF00FF,"Welcome to your Admin Vehicle");
	}
	}
	return 1;
}


public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}
public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	if(pickupid = pickupup)
	{
	MoveDynamicObject(pickupup,766.00000000,-2497.69995117,47.90000153,1.5);
	SendClientMessage(playerid,0xFF0080FF,"YOU ARE GOING UP");
	SetTimer("GoingDown",3000,0);
	return 1;
	}
	return 1;
}
forward GoingDown();
public GoingDown()
{
	MoveDynamicObject(pickupup,766.00000000,-2497.69995117,9.60000038,1.5);
	return 1;
}
public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
