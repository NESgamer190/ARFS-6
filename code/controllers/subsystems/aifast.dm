SUBSYSTEM_DEF(aifast)
	name = "AI (Fast)"
	init_order = INIT_ORDER_AI_FAST
	priority = FIRE_PRIORITY_AI
	wait = 5 // This gets run twice a second, but shouldn't do much unless mobs are in combat
	flags = SS_NO_INIT|SS_TICKER
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/processing = list()
	var/list/currentrun = list()

/datum/controller/subsystem/aifast/stat_entry(msg_prefix)
	var/list/msg = list(msg_prefix)
	msg += "P:[processing.len]"
	..(msg.Join())

/datum/controller/subsystem/aifast/fire(resumed = 0)
	if (!resumed)
		src.currentrun = processing.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/datum/ai_holder/A = currentrun[currentrun.len]
		--currentrun.len
		if(!A || QDELETED(A) || A.busy) // Doesn't exist or won't exist soon or not doing it this tick
			continue
		A.handle_tactics()

		if(MC_TICK_CHECK)
			return