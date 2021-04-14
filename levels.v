module treplo

// Logging levels
pub enum Level {
	panic = 0
	fatal
	error
	warn
	info
	debug
}

// For hooks 'levels()'
pub const (
	all_levels = [Level.panic, .fatal, .error, .warn, .info, .debug]
	err_levels = [Level.panic, .fatal, .error]
)