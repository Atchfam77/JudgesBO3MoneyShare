Thanks for downloading my money sharing script! Be sure to credit me if you use this in a mod or map. Thanks to Sphynx for teaching me about System Registers for this mod!

1. Drag and drop my script into your map or mod's scripts folder (found at BO3ROOT/usermaps/<YOUR MAP OR MOD NAME>/scripts/zm).

2. Open your main map or mod .GSC file and add the following at the top next to your other "#usings":

#using scripts\zm\_zm_judge_share_money;

##### IF YOU PLACE IT IN A DIFFERENT FOLDER, MODIFY THE #using PATH ACCORDINGLY! #####

3. Open your zone file (found at BO3ROOT/usermaps/<YOUR MAP OR MOD NAME>/zone_source), and add the following 2 lines between the comments:

###
//DuhJudge's Money Sharing
scriptparsetree,scripts/zm/_zm_judge_share_money.gsc
###

### NOTE:
### * * If you don't place it within the correct folder, you won't see the effects in-game! * * ###
### * * For example: "scripts\zm\gametypes\<all your scripts>" might be an alternate file path.

DONE! Enjoy :)

You can edit the parameters as you please (buttons used to drop points, value assigned to cost and reward, etc.)