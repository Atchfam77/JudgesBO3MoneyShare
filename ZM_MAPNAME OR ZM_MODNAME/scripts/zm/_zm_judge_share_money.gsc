//
//	BLACK OPS 3 ZOMBIES
//	MONEY SHARING/POINTS DROPPING SCRIPT
//	MADE BY DUHJUDGE/ATCHFAM77
//

#using scripts\shared\callbacks_shared;
#using scripts\shared\util_shared;
#using scripts\shared\laststand_shared;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm;
#using scripts\shared\system_shared;

#namespace zm_judge_share_money;

REGISTER_SYSTEM_EX( "zm_judge_share_money", &__init__, undefined, undefined )

function __init__()
{
	callback::on_spawned( &on_player_spawned );
}

function on_player_spawned()
{
	self thread watchformoneyshare();
}

function watchformoneyshare()
{
	self endon("disconnect");
	self endon("death");
	while(1)	//	THIS FUNCTION WILL BEGIN LOOPING WHEN A PLAYER HAS SPAWNED, AND WILL NOT STOP UNTIL THAT PLAYER HAS DIED/DISCONNECTED.
	{
		if (IS_TRUE(self laststand::player_is_in_laststand()))	//	THIS PREVENTS DOWNED PLAYERS FROM SHARING POINTS
			wait .1;
		else	//	THIS WILL BE CALLED WHEN A PLAYER IS NOT DOWNED
		{
			if(self AdsButtonPressed())		// THESE BUTTONS CAN BE CUSTOMIZED TO BE ANY ____BUTTONPRESSED() COMMAND. CURRENTLY THIS IS 'RIGHT-CLICK' ON MOUSE-AND-KEYBOARD, AND 'L2' FOR CONTROLLER.
			{
				wait(.2);	// WAITS TO MAKE SURE THE SHARER IS INTENDING TO SHARE. CAN BE CUSTOMIZED TO BE FASTER OR SLOWER.
				if(self ActionSlotFourButtonPressed())		// BY DEFAULT THIS IS '3' ON KEYBOARD, AND 'RIGHT-DPAD' ON CONTROLLER. CUSTOMIZE AS YOU PLEASE
				{
					if(self.score >= 500)		// CHECKS TO MAKE SURE THE SHARER HAS MORE THAN 500 POINTS TO SHARE
					{
						// GETS THE SPAWNPOINT OF THE SHARED MONEY DROP
						sharedmoneyorigin = self.origin + VectorScale(AnglesToForward((0, self getPlayerAngles()[1], 0)), 60) + VectorScale((0, 0, 1), 5);
						// SPAWNS THE SHARED MONEY DROP
						self thread startmoneyshare(sharedmoneyorigin);
						// TAKES THE COST FOR SHARING MONEY FROM THE SHARER
						self zm_score::player_reduce_points("take_specified", 500);
					}
				}
			}
		}
		wait.1; // HELPS ENSURE THE WHILE LOOP IS UNDER CONTROL AND THAT THE SHARED POINTS FEATURE ISN'T SPAMMED
	}
}

function startmoneyshare(origin, value)
{
	self endon("disconnect");
	self endon("bled_out");
	sharedmoneydrop = zm_powerups::specific_powerup_drop("bonus_points_player", origin, undefined, undefined, 0.1);	// SPAWNS THE DROP
	sharedmoneydrop.bonus_points_powerup_override = &sharedpointsvalue;	// VERY IMPORTANT - OVERRIDES THE DEFAULT RANDOM VALUE OF THE BONUS POINTS DROP.
	wait(1);
	// COPIED FROM THE BGB SCRIPT - MAKES SURE YOU AREN'T TRYING TO SPAWN THE SHARED POINTS OUT OF BOUNDS.
	if(isdefined(sharedmoneydrop) && (!sharedmoneydrop zm::in_enabled_playable_area() && !sharedmoneydrop zm::in_life_brush()))
	{
		level thread sharedmoney_checkforoob(sharedmoneydrop); //checks for spawning the shared money out of bounds
	}
}

function sharedpointsvalue()
{
	foreach(team in level.teams)	// CHECKS THE ACTIVE TEAMS FOR AN ACTIVE DOUBLE POINTS
	{	
		if (level.zombie_vars[team]["zombie_powerup_double_points_time"] > 0 && (isdefined(level.zombie_vars[team]["zombie_powerup_double_points_on"]) && level.zombie_vars[team]["zombie_powerup_double_points_on"]))
		{
			// WILL RETURN HALF THE INTENDED SHARE VALUE WHILE A DOUBLE POINTS IS ACTIVATED. ENSURES YOU CAN'T DUPLICATE MONEY
			return 240;
		}
	}
	return 480;	// THIS WILL GET RETURNED AS THE DEFAULT SHARE VALUE IF THE FOREACH LOOP IS NOT SUCCESSFUL IN RETURNING THE HALVED VALUE FIRST.
}

function sharedmoney_checkforoob(sharedmoneydrop)
{
	if(!isdefined(sharedmoneydrop))
	{
		return;
	}
	sharedmoneydrop ghost();
	sharedmoneydrop.clone_model = util::spawn_model(sharedmoneydrop.model, sharedmoneydrop.origin, sharedmoneydrop.angles);
	sharedmoneydrop.clone_model LinkTo(sharedmoneydrop);
	direction = sharedmoneydrop.origin;
	direction = (direction[1], direction[0], 0);
	if(direction[1] < 0 || (direction[0] > 0 && direction[1] > 0))
	{
		direction = (direction[0], direction[1] * -1, 0);
	}
	else if(direction[0] < 0)
	{
		direction = (direction[0] * -1, direction[1], 0);
	}
	if(!(isdefined(sharedmoneydrop.sndNoSamLaugh) && sharedmoneydrop.sndNoSamLaugh))
	{
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			if(isalive(players[i]))
			{
				players[i] playlocalsound(level.zmb_laugh_alias);
			}
		}
	}
	PlayFXOnTag(level._effect["samantha_steal"], sharedmoneydrop, "tag_origin");
	sharedmoneydrop.clone_model Unlink();
	sharedmoneydrop.clone_model MoveZ(60, 1, 0.25, 0.25);
	sharedmoneydrop.clone_model vibrate(direction, 1.5, 2.5, 1);
	sharedmoneydrop.clone_model waittill("movedone");
	if(isdefined(self.damagearea))
	{
		self.damagearea delete();
	}
	sharedmoneydrop.clone_model delete();
	if(isdefined(sharedmoneydrop))
	{
		if(isdefined(sharedmoneydrop.damagearea))
		{
			sharedmoneydrop.damagearea delete();
		}
		sharedmoneydrop zm_powerups::powerup_delete();
	}
}