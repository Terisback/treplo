module treplo

import time
import io
import x.json2 as json

// Default out implementation
struct StdOut {}

fn (out StdOut) write(data []byte) ?int {
	print(data.bytestr())
	return data.len
}

// Type for exit function
type ExitFunc = fn(int)

struct Logger {
mut:
	// Defaults to print into stdout by `print()`
	out io.Writer

	// Hooks for the logger instance. These allow firing events based on logging
	// levels and log entries. For example, to send errors to an error tracking
	// service, log to StatsD or dump the core on fatal errors.
	hooks LevelHooks

	// The logging level the logger should log at. Defaults to `.info`,
	// which allows `info()`, `warn()`, `error()` and `fatal()` to be logged.
	level Level

	// All log entries pass through the formatter before logged to Out. The
	// included formatters are `TextFormatter` and `JSONFormatter` for which
	// TextFormatter is the default. In development (when a TTY is attached) it
	// logs with colors, but to a file it wouldn't. You can easily implement your
	// own that implements the `Formatter` interface, see the `README` or included
	// formatters for examples.
	formatter Formatter

	// Function to exit the application, defaults to `exit()`
	exit ExitFunc
}

pub fn new() Logger {
	mut logger := Logger {
		out: &StdOut{}
		level: .info
		formatter: &TextFormatter{} // I dunno why it needs pointer
		exit: exit
	}
	return logger
}

// Create Entry with field
pub fn (mut l Logger) with_field(key string, value json.Any) Entry {
	mut entry := new_entry(mut l)
	return entry.with_field(key, value)
}

// Create Entry with fields
pub fn (mut l Logger) with_fields(fields ...Field) Entry {
	mut entry := new_entry(mut l)
	return entry.with_fields(...fields)
}

// Create Entry with data map
pub fn (mut l Logger) with_fields_map(fields map[string]json.Any) Entry {
	mut entry := new_entry(mut l)
	return entry.with_fields_map(fields)
}

// Create Entry with time
pub fn (mut l Logger) with_time(t time.Time) Entry {
	mut entry := new_entry(mut l)
	return entry.with_time(t)
}

pub fn (mut l Logger) log(level Level, args ...string) {
	if l.is_level_enabled(level) {
		mut entry := new_entry(mut l)
		entry.log(level, ...args)
	}
}

pub fn (mut l Logger) debug(args ...string) {
	l.log(.debug, ...args)
}

pub fn (mut l Logger) info(args ...string) {
	l.log(.info, ...args)
}

pub fn (mut l Logger) print(args ...string) {
	mut entry := new_entry(mut l)
	entry.print(...args)
}

pub fn (mut l Logger) warn(args ...string) {
	l.log(.warn, ...args)
}

pub fn (mut l Logger) warning(args ...string) {
	l.warn(...args)
}

pub fn (mut l Logger) error(args ...string) {
	l.log(.error, ...args)
}

pub fn (mut l Logger) fatal(args ...string) {
	l.log(.fatal, ...args)
}

pub fn (mut l Logger) panic(args ...string) {
	l.log(.panic, ...args)
}

pub fn (mut l Logger) logln(level Level, args ...string) {
	if l.is_level_enabled(level) {
		mut entry := new_entry(mut l)
		entry.logln(level, ...args)
	}
}

pub fn (mut l Logger) debugln(args ...string) {
	l.logln(.debug, ...args)
}

pub fn (mut l Logger) infoln(args ...string) {
	l.logln(.info, ...args)
}

pub fn (mut l Logger) println(args ...string) {
	mut entry := new_entry(mut l)
	entry.println(...args)
}

pub fn (mut l Logger) warnln(args ...string) {
	l.logln(.warn, ...args)
}

pub fn (mut l Logger) warningln(args ...string) {
	l.warnln(...args)
}

pub fn (mut l Logger) errorln(args ...string) {
	l.logln(.error, ...args)
}

pub fn (mut l Logger) fatalln(args ...string) {
	l.logln(.fatal, ...args)
}

pub fn (mut l Logger) panicln(args ...string) {
	l.logln(.panic, ...args)
}

// Sets the logger level
pub fn (mut l Logger) set_level(level Level) {
	l.level = level
}

// Returns the logger level
pub fn (l Logger) get_level() Level{
	return l.level
}

// Checks if the log level of the logger is greater than the level param
pub fn (l Logger) is_level_enabled(level Level) bool{
	return int(l.level) >= int(level)
}

// Sets the logger formatter
pub fn (mut l Logger) set_formatter(formatter Formatter) {
	// No need in mutex, afaik V does it on its own
	l.formatter = formatter
}

// Sets the logger output
pub fn (mut l Logger) set_output(output io.Writer) {
	l.out = output
} 

// Sets the logger exit function
pub fn (mut l Logger) set_exit_func(func ExitFunc) {
	l.exit = func
}

// Adds a hook to the logger hooks
pub fn (mut l Logger) add_hook(hook Hook) {
	l.hooks.add(hook)
}

// Replaces the logger hooks and returns the old ones
pub fn (mut l Logger) replace_hooks(hooks LevelHooks) LevelHooks {
	old_hooks := l.hooks
	l.hooks = hooks
	return old_hooks
}