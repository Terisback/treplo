module treplo

import time
import io
import x.json2 as json

// Interface to use in the fields of the structures, in such fields you can store both Log and Entry
pub interface Logger {
	with_field(key string, value json.Any) Entry
	with_fields(fields ...Field) Entry
	with_fields_map(fields map[string]json.Any) Entry
	with_time(t time.Time) Entry
	log(level Level, args ...string)
	debug(args ...string)
	info(args ...string)
	print(args ...string)
	warn(args ...string)
	warning(args ...string)
	error(args ...string)
	fatal(args ...string)
	panic(args ...string)
	logln(level Level, args ...string)
	debugln(args ...string)
	infoln(args ...string)
	println(args ...string)
	warnln(args ...string)
	warningln(args ...string)
	errorln(args ...string)
	fatalln(args ...string)
	panicln(args ...string)
}

// Default out implementation
struct StdOut {}

fn (out StdOut) write(data []byte) ?int {
	print(data.bytestr())
	return data.len
}

// Type for exit function
type ExitFunc = fn(int)

struct Log {
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

pub fn new() Log {
	mut logger := Log {
		out: &StdOut{}
		level: .info
		formatter: &TextFormatter{} // I dunno why it needs pointer
		exit: exit
	}
	return logger
}

// Create Entry with field
pub fn (mut l Log) with_field(key string, value json.Any) Entry {
	mut entry := new_entry(mut l)
	return entry.with_field(key, value)
}

// Create Entry with fields
pub fn (mut l Log) with_fields(fields ...Field) Entry {
	mut entry := new_entry(mut l)
	return entry.with_fields(...fields)
}

// Create Entry with data map
pub fn (mut l Log) with_fields_map(fields map[string]json.Any) Entry {
	mut entry := new_entry(mut l)
	return entry.with_fields_map(fields)
}

// Create Entry with time
pub fn (mut l Log) with_time(t time.Time) Entry {
	mut entry := new_entry(mut l)
	return entry.with_time(t)
}

pub fn (mut l Log) log(level Level, args ...string) {
	if l.is_level_enabled(level) {
		mut entry := new_entry(mut l)
		entry.log(level, ...args)
	}
}

pub fn (mut l Log) debug(args ...string) {
	l.log(.debug, ...args)
}

pub fn (mut l Log) info(args ...string) {
	l.log(.info, ...args)
}

pub fn (mut l Log) print(args ...string) {
	mut entry := new_entry(mut l)
	entry.print(...args)
}

pub fn (mut l Log) warn(args ...string) {
	l.log(.warn, ...args)
}

pub fn (mut l Log) warning(args ...string) {
	l.warn(...args)
}

pub fn (mut l Log) error(args ...string) {
	l.log(.error, ...args)
}

pub fn (mut l Log) fatal(args ...string) {
	l.log(.fatal, ...args)
}

pub fn (mut l Log) panic(args ...string) {
	l.log(.panic, ...args)
}

pub fn (mut l Log) logln(level Level, args ...string) {
	if l.is_level_enabled(level) {
		mut entry := new_entry(mut l)
		entry.logln(level, ...args)
	}
}

pub fn (mut l Log) debugln(args ...string) {
	l.logln(.debug, ...args)
}

pub fn (mut l Log) infoln(args ...string) {
	l.logln(.info, ...args)
}

pub fn (mut l Log) println(args ...string) {
	mut entry := new_entry(mut l)
	entry.println(...args)
}

pub fn (mut l Log) warnln(args ...string) {
	l.logln(.warn, ...args)
}

pub fn (mut l Log) warningln(args ...string) {
	l.warnln(...args)
}

pub fn (mut l Log) errorln(args ...string) {
	l.logln(.error, ...args)
}

pub fn (mut l Log) fatalln(args ...string) {
	l.logln(.fatal, ...args)
}

pub fn (mut l Log) panicln(args ...string) {
	l.logln(.panic, ...args)
}

// Sets the logger level
pub fn (mut l Log) set_level(level Level) {
	l.level = level
}

// Returns the logger level
pub fn (l Log) get_level() Level{
	return l.level
}

// Checks if the log level of the logger is greater than the level param
pub fn (l Log) is_level_enabled(level Level) bool{
	return int(l.level) >= int(level)
}

// Sets the logger formatter
pub fn (mut l Log) set_formatter(formatter Formatter) {
	// No need in mutex, afaik V does it on its own
	l.formatter = formatter
}

// Sets the logger output
pub fn (mut l Log) set_output(output io.Writer) {
	l.out = output
} 

// Sets the logger exit function
pub fn (mut l Log) set_exit_func(func ExitFunc) {
	l.exit = func
}

// Adds a hook to the logger hooks
pub fn (mut l Log) add_hook(hook Hook) {
	l.hooks.add(hook)
}

// Replaces the logger hooks and returns the old ones
pub fn (mut l Log) replace_hooks(hooks LevelHooks) LevelHooks {
	old_hooks := l.hooks
	l.hooks = hooks
	return old_hooks
}