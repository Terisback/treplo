module treplo

// A hook to be fired when logging on the logging levels returned from
// `levels()` on your implementation of the interface. Note that this is not
// fired in a thread or a channel with workers, you should handle such
// functionality yourself if your call is non-blocking and you don't wish for
// the logging calls for levels returned from `levels()` to block.
interface Hook {
	levels() []Level
	fire(Entry) ?
}

// Internal type for storing the hooks on a logger instance.
struct LevelHooks {
mut:
	registry map[int][]Hook = map[int][]Hook{}
}

// Add a hook to an instance of logger. This is called with
// `log.hooks.Add(new(MyHook))` where `MyHook` implements the `Hook` interface.
pub fn (mut hooks LevelHooks) add(hook Hook) {
	for level in hook.levels() {
		hooks.registry[int(level)] << hook
	}
}

// Fire all the hooks for the passed level. Used by `entry.log` to fire
// appropriate hooks for a log entry.
pub fn (mut hooks LevelHooks) fire(level Level, entry Entry) ? {
	if int(level) in hooks.registry {
		for hook in hooks.registry[int(level)] {
			hook.fire(entry) ?
		}
	}
}