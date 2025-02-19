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

#insert scripts\shared\shared.gsh;

#namespace zm_judge_share_money;

REGISTER_SYSTEM_EX( "zm_judge_share_money", &__init__, undefined, undefined )

function __init__()
{
	callback::on_spawned( &on_player_spawned );
}

#define int_points_to_share = 500;
#define int_cost_to_share = 20;

function on_player_spawned()
{
	self thread watch_for_money_share();
}

function watch_for_money_share()
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
				wait(.1);	// WAITS TO MAKE SURE THE SHARER IS INTENDING TO SHARE. CAN BE CUSTOMIZED TO BE FASTER OR SLOWER.
				if(self ActionSlotFourButtonPressed())		// BY DEFAULT THIS IS '3' ON KEYBOARD, AND 'RIGHT-DPAD' ON CONTROLLER. CUSTOMIZE AS YOU PLEASE
				{
					if(self.score >= int_points_to_share)		// CHECKS TO MAKE SURE THE SHARER HAS MORE THAN 500 POINTS TO SHARE
					{
						// GETS THE SPAWNPOINT OF THE SHARED MONEY DROP
						shared_money_origin = self.origin + VectorScale(AnglesToForward((0, self getPlayerAngles()[1], 0)), 60) + VectorScale((0, 0, 1), 5);
						// SPAWNS THE SHARED MONEY DROP
						self thread start_money_share(shared_money_origin);
						// TAKES THE COST FOR SHARING MONEY FROM THE SHARER
						self zm_score::player_reduce_points("take_specified", int_points_to_share);
					}
				}
			}
		}
		wait.1; // HELPS ENSURE THE WHILE LOOP IS UNDER CONTROL AND THAT THE SHARED POINTS FEATURE ISN'T SPAMMED
	}
}

function start_money_share(origin, value)
{
	self endon("disconnect");
	self endon("bled_out");
	shared_money_drop = zm_powerups::specific_powerup_drop("bonus_points_player", origin, undefined, undefined, 0.1);	// SPAWNS THE DROP
	shared_money_drop.bonus_points_powerup_override = &shared_points_value;	// VERY IMPORTANT - OVERRIDES THE DEFAULT RANDOM VALUE OF THE BONUS POINTS DROP.
	wait(1);
	// COPIED FROM THE BGB SCRIPT - MAKES SURE YOU AREN'T TRYING TO SPAWN THE SHARED POINTS OUT OF BOUNDS.
	if(isdefined(shared_money_drop) && (!shared_money_drop zm::in_enabled_playable_area() && !shared_money_drop zm::in_life_brush()))
	{
		level thread shared_money_check_for_oob(shared_money_drop); //checks for spawning the shared money out of bounds
	}
}

function shared_points_value()
{
	foreach(team in level.teams)	// CHECKS THE ACTIVE TEAMS FOR AN ACTIVE DOUBLE POINTS
	{	
		if (level.zombie_vars[team]["zombie_powerup_double_points_time"] > 0 && (isdefined(level.zombie_vars[team]["zombie_powerup_double_points_on"]) && level.zombie_vars[team]["zombie_powerup_double_points_on"]))
		{
			// WILL RETURN HALF THE INTENDED SHARE VALUE WHILE A DOUBLE POINTS IS ACTIVATED. ENSURES YOU CAN'T DUPLICATE MONEY
			int_doublepoints_share_value = (int_points_to_share - int_cost_to_share ) /2
			return int_doublepoints_share_value;
		}
	}
	int_normal_share_value = int_points_to_share - int_cost_to_share;
	return int_normal_share_value;	// THIS WILL GET RETURNED AS THE DEFAULT SHARE VALUE IF THE FOREACH LOOP IS NOT SUCCESSFUL IN RETURNING THE HALVED VALUE FIRST.
}

function shared_money_check_for_oob(shared_money_drop)
{
	if(!isdefined(shared_money_drop))
	{
		return;
	}
	shared_money_drop ghost();
	shared_money_drop.clone_model = util::spawn_model(shared_money_drop.model, shared_money_drop.origin, shared_money_drop.angles);
	shared_money_drop.clone_model LinkTo(shared_money_drop);
	direction = shared_money_drop.origin;
	direction = (direction[1], direction[0], 0);
	if(direction[1] < 0 || (direction[0] > 0 && direction[1] > 0))
	{
		direction = (direction[0], direction[1] * -1, 0);
	}
	else if(direction[0] < 0)
	{
		direction = (direction[0] * -1, direction[1], 0);
	}
	if(!(isdefined(shared_money_drop.sndNoSamLaugh) && shared_money_drop.sndNoSamLaugh))
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
	PlayFXOnTag(level._effect["samantha_steal"], shared_money_drop, "tag_origin");
	shared_money_drop.clone_model Unlink();
	shared_money_drop.clone_model MoveZ(60, 1, 0.25, 0.25);
	shared_money_drop.clone_model vibrate(direction, 1.5, 2.5, 1);
	shared_money_drop.clone_model waittill("movedone");
	if(isdefined(self.damagearea))
	{
		self.damagearea delete();
	}
	shared_money_drop.clone_model delete();
	if(isdefined(shared_money_drop))
	{
		if(isdefined(shared_money_drop.damagearea))
		{
			shared_money_drop.damagearea delete();
		}
		shared_money_drop zm_powerups::powerup_delete();
	}
}