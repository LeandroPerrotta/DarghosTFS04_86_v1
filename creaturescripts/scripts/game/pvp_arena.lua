function onKill(cid, target, damage, flags)

	instancePvpArena:finishGame(cid, target)
	return true
end