THANK YOU FOR DOWNLOADING DUHJUDGE'S MONEY SHARING/POINTS DROPPING SCRIPT!
Please be sure to credit me for this feature if you decide to include it in your map or mod!

I'm providing 2 tutorials here for this script. You may either directly insert them into your map or mod file,
or you may drag and drop the .GSC file into your BO3ROOT/usermaps/<YOURMAPNAME>/scripts/zm and add a #using at the top of your man .GSC file, referring to mine.

TUTORIAL 1 | INSERTING SCRIPTS:

1) Open the USERMAPS folder within this .rar file

2) Open "zm_judge_money_share.gsc" in your preferred text editor. Be sure to read ALL THE COMMENTS.

3) Open your main MAP/MOD .GSC file, and place these at the top of your file with the rest of your #using's:

#using scripts\shared\callbacks_shared;
#using scripts\shared\util_shared;
#using scripts\shared\laststand_shared;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm;

4) Within your map.gsc file, find your "__init__" or "init" function. If you do not have a callback on player spawn, add one like this:

	callback::on_spawned( &on_player_spawned );

If you already have one of these, skip this step and go to step 5.

5) Navigate to your function that gets called on every player spawn. For me this is called "on_player_spawned" and it takes the value (player). If you do not have one, I've provided one
you may copy and paste that is commented-out within my .GSC file. Add this line to your player spawn function:

	self thread watchformoneyshare();

6) Copy and paste the "watchformoneyshare" function somewhere within your main .GSC file for your map or mod.

7) Directly below that, copy and paste the "startmoneyshare" function.

8) Directly below that, copy and paste the "sharedpointsvalue" function.

9) Directly below that, copy and paste the "sharedmoney_checkforoob" function.

10) You're done!

=====================================================================================================================================================

TUTORIAL 2 | DRAG AND DROP:

1) If instead you wish to drag and drop my script file "zm_judge_share_money.gsc" into your map/mod folder, do so by placing it inside of BO3ROOT/usermaps/<YOURMAPNAME>/scripts/zm.

2) Open your main MAP/MOD .GSC file, and place this at the top of your file with the rest of your #using's:

	#using scripts\zm\zm_judge_share_money;

3) Navigate to your function that gets called on every player spawn. For me this is called "on_player_spawned" and it takes the value (player). If you do not have one, I've provided one
you may copy and paste that is commented-out within my .GSC file. Add this line to your player spawn function:

	self thread zm_judge_share_money::watchformoneyshare();

6) You're done!