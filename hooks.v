module treplo

// A hook to be fired when logging on the logging levels returned from
// `levels()` on your implementation of the interface. Note that this is not
// fired in a coroutine or a channel with workers, you should handle such
// functionality yourself if your call is non-blocking and you don't wish for
// the logging calls for levels returned from `levels()` to block.
interface Hook {
	levels() []Level
	fire(Entry)
}

// Internal type for storing the hooks on a logger instance.
type LevelHooks map[Level][]Hook

// Add a hook to an instance of logger. This is called with
// `log.hooks.add(my_hook)` where `my_hook` implements the `Hook` interface.
pub fn (hooks LevelHooks) add(hook Hook) {
	for _, level in hook.levels() {
		hooks[level] << hook
	}
}

// Fire all the hooks for the passed level. Used by `entry.log` to fire
// appropriate hooks for a log entry.
pub fn (hooks LevelHooks) fire(level Level, entry Entry) {
	for _, hook in hooks[level] {
		hook.fire(entry)
	}
}