
class UserConfig {

    
	</ label="Blank Screen Time", help="Minutes before starting the screensaver. Set this to 0 to disable.", order=1 />
	screensaver_start_time="10000";
    

	</ label="Blank Screen Start Command", help="The command line to run when blank screen (low power) mode starts (to turn the monitor off, for example).", order=9 />
	screensaver_start_cmd=system( "start \"\" \"c:\\games\\attractmode\\Screensaver\\screensaver.exe\"" );


    
}




local config = fe.get_config();



//local screensaver_start_time = config[ "screensaver_start_time" ].tointeger() * 60000;
local screensaver_start_time = 30000;

local do_blank=false;
local first_time = true;

fe.add_ticks_callback( "saver_tick" );






//
// saver_tick gets called repeatedly during screensaver.
// ttime = number of milliseconds since screensaver began.
//
function saver_tick( ttime )
{

    /*
    print (ttime);
    print ("\n");
    print (screensaver_start_time);
    print ("\n");
    print ("\n");
    */



	if ( do_blank )
		return;

	if ( screensaver_start_time && ( ttime > screensaver_start_time ))
	{
		//current_mode.reset();
		do_blank = true;

		if ( config[ "screensaver_start_cmd" ].len() > 0 ) {
            print ("Running screensaver!!!!");
			system( config[ "screensaver_start_cmd" ] );
        }

		return;
	}



}

fe.add_transition_callback( "saver_transition" );
function saver_transition( ttype, var, ttime )
{
	if (( ttype == Transition.EndLayout ) && ( do_blank )
			&& ( config[ "blank_stop_cmd" ].len() > 0 ))
		system( config[ "blank_stop_cmd" ] );

	return false;
}

fe.add_signal_handler( "saver_signal_handler" );

function saver_signal_handler( sig )
{
	if ( sig == "select" )
		//current_mode.on_select();

	return false;
}


