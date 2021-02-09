module treplo

import io
import os
import strings

// Logging levels
pub enum Level {
	panic = 0
	fatal
	error
	warn
	info
	debug
}

// Formatter interface is used to implement a custom Formatter.
pub interface Formatter {
	format(Entry) []byte?
}

// Type for exit function
type ExitFunc = fn(int)

pub struct Logger {
mut:
	// Defaults to print into stderr by `eprintln()`
	out io.Writer

	// The logging level the logger should log at. Defaults to `.info`,
	// which allows `info()`, `warn()`, `error()` and `fatal()` to be logged.
	level Level
	
	// Hooks for the logger instance. These allow firing events based on logging
	// levels and log entries. For example, to send errors to an error tracking
	// service, log to StatsD or dump the core on fatal errors.
	hooks LevelHooks

	// All log entries pass through the formatter before logged to Out. The
	// included formatters are `TextFormatter` and `JSONFormatter` for which
	// TextFormatter is the default. In development (when a TTY is attached) it
	// logs with colors, but to a file it wouldn't. You can easily implement your
	// own that implements the `Formatter` interface, see the `README` or included
	// formatters for examples.
	formatter Formatter

	// Function to exit the application, defaults to `os.exit()`
	exit_func ExitFunc
}

pub fn new() Logger {
	return Logger{
		out: StdErrOut{}
		level: .info
		hooks: LevelHooks{}
		formatter: NonFormatter{}
		exit_func: os.exit
	}
}

pub fn (l Logger) panic(message ...string) {
	mut res := strings.new_builder(64)
	message.map(res.write(it))
	formatted := l.formatter.format(res.str()) or { panic(err) }
	defer { panic(formatted) }
	if l.level > .panic { return }
	l.out.write(formatted) or { panic(err) }
}

pub fn (l Logger) fatal(message ...string) {
	if l.level > .fatal { return }
	mut res := strings.new_builder(64)
	message.map(res.write(it))
	formatted := l.formatter.format(res.str()) or { panic(err) }
	l.out.write(formatted) or { panic(err) }
	l.exit()
}

pub fn (l Logger) error(message ...string) {
	if l.level > .error { return }
	mut res := strings.new_builder(64)
	message.map(res.write(it))
	formatted := l.formatter.format(res.str()) or { panic(err) }
	l.out.write(formatted) or { panic(err) }
}

pub fn (l Logger) warn(message ...string) {
	if l.level > .warn { return }
	mut res := strings.new_builder(64)
	message.map(res.write(it))
	formatted := l.formatter.format(res.str()) or { panic(err) }
	l.out.write(formatted) or { panic(err) }
}

pub fn (l Logger) info(message ...string) {
	if l.level > .info { return }
	mut res := strings.new_builder(64)
	message.map(res.write(it))
	formatted := l.formatter.format(res.str()) or { panic(err) }
	l.out.write(formatted) or { panic(err) }
}

pub fn (l Logger) debug(message ...string) {
	if l.level > .debug { return }
	mut res := strings.new_builder(64)
	message.map(res.write(it))
	formatted := l.formatter.format(res.str()) or { panic(err) }
	l.out.write(formatted) or { panic(err) }
}

// Sets the logger level
pub fn (mut l Logger) set_level(level Level) {
	l.level = level
}

// Returns the logger level
pub fn (l Logger) get_level() Level{
	return l.level
}

// Adds a hook to the logger hooks
pub fn (mut l Logger) add_hook(hook Hook) {
	// No need in mutex, afaik V does it on its own
	l.hooks.add(hook)
}

// Checks if the log level of the logger is greater than the level param
pub fn (l Logger) is_level_enabled(level Level) bool{
	return l.level >= level
}

// Sets the logger formatter
pub fn (mut l Logger) set_formatter(formatter Formatter) {
	// No need in mutex, afaik V does it on its own
	l.formatted = formatted
}

// Sets the logger output
pub fn (mut l Logger) set_output(output io.Writer) {
	logger.out = output
} 

// Replaces the logger hooks and returns the old ones
pub fn (mut l Logger) replace_hooks(hooks LevelHooks) LevelHooks{
	old_hooks := l.hooks
	l.hooks = hooks
	return old_hooks
}

// Default out implementation
struct StdErrOut {}

fn (out StdErrOut) write(data []byte) ?int {
	eprintln(data.bytestr())
}

// Default formatter
struct NonFormatter {}

fn (formatter NonFormatter) format(entry Entry) []byte? {
	return entry.message.bytes()
}