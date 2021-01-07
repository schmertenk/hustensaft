extends SecondarySelectMenu

func all_ready():
	if !$TransitionMask.is_active():
		$TransitionMask.slide_in(Global, "start_new_round")
