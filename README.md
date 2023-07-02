# JudgesBO3MoneyShare
A script for Black Ops 3 Zombies which allows players to share money via means of spawning a points drop powerup.
Thanks for downloading my money sharing script! Be sure to credit me if you use this in a mod or map. Thanks to Sphynx for teaching me about System Registers for this mod!

1. Drag and drop my script into your map or mod's scripts folder (found at BO3ROOT/usermaps/\<YOUR MAP OR MOD NAME>/scripts/zm).

2. Open your main map or mod .GSC file and add the following at the top next to your other "#usings":

#using scripts\zm\\_zm_judge_share_money;

3. Open your zone file (found at BO3ROOT/usermaps/\<YOUR MAP OR MOD NAME>/zone_source), and add the following lines:

//DuhJudge's Money Sharing
scriptparsetree,scripts/zm/_zm_judge_share_money.gsc

DONE! Enjoy :)

You can edit the parameters as you please (buttons used to drop points, value assigned to cost and reward, etc.)
