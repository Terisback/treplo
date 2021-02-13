module treplo

import strings
import time
import x.json2 as json

// An entry is the final or intermediate treplo logging entry. It contains all
// the fields passed with `with_fields()`. It's finally logged when debug,
// info, warn, error, fatal or panic is called on it.
struct Entry {
mut:
	logger &Logger

	// Time at which the log entry was created
	time time.Time

	// Level the log entry was logged at: debug, info, warn, error, fatal or panic
	level Level

	// Message passed to `debug`, `info`, `warn`, `error`, `fatal` or `panic`
	message string

	// Contains additional fields passed by `with_fields`
	data map[string]json.Any
}

pub fn new_entry(mut logger Logger) Entry {
	return Entry{
		logger: logger
		time: time.now()
		level: .info
		data: map[string]json.Any{}
	}
}

// Returns the bytes representation of this entry from the formatter
pub fn (entry Entry) bytes() ?[]byte {
	return entry.logger.formatter.format(entry)
}

// Returns the string representation from the reader and ultimately the
// formatter.
pub fn (entry Entry) str() string {
	mut serialized := entry.bytes() or {
		eprintln("Failed to obtain reader, ${err}")
		return ""
	}
	return serialized.bytestr()
}

// Add a single field (json.Any) to the Entry
pub fn (entry Entry) with_field(key string, value json.Any) Entry {
	mut data := entry.data.clone()
	data[key] = value

	return Entry{
		...entry
		data: data
	}
}

// Add a map of fields (json.Any) to the Entry
pub fn (entry Entry) with_fields(fields map[string]json.Any) Entry {
	mut data := entry.data.clone()
	for k, v in fields {
		data[k] = v
	}

	return Entry{
		...entry
		data: data
	}
}

// Overrides the time of the Entry
pub fn (entry Entry) with_time(t time.Time) Entry {
	data := entry.data.clone()
	
	return Entry{
		...entry
		time: t
		data: data
	}
}

fn (mut entry Entry) log_message(level Level, msg string) {
	if entry.time.unix == 0 {
		entry.time = time.now()
	}

	entry.level = level
	entry.message = msg
	entry.write()

	if int(level) <= int(Level.panic) {
		panic(entry.str())
	}
}

fn (entry Entry) write() {
	serialized := entry.logger.formatter.format(entry) or {
		eprintln("Failed to obtain reader, ${err}")
		res := []byte{}
		res
	}
	entry.logger.out.write(serialized) or {
		eprintln("Failed to write log, ${err}")
	}
}

pub fn (mut entry Entry) log(level Level, args ...string) {
	if entry.logger.is_level_enabled(level) {
		mut res := strings.new_builder(64)
		for _, val in args {
			res.write(val)
		}
		entry.log_message(level, res.str())
	}
}

pub fn (mut entry Entry) debug(args ...string) {
	entry.log(.debug, ...args)
}

pub fn (mut entry Entry) print(args ...string) {
	entry.info(...args)
}

pub fn (mut entry Entry) info(args ...string) {
	entry.log(.info, ...args)
}

pub fn (mut entry Entry) warn(args ...string) {
	entry.log(.warn, ...args)
}

pub fn (mut entry Entry) warning(args ...string) {
	entry.warn(...args)
}

pub fn (mut entry Entry) error(args ...string) {
	entry.log(.error, ...args)
}

pub fn (mut entry Entry) fatal(args ...string) {
	entry.log(.fatal, ...args)
	entry.logger.exit(1)
}

pub fn (mut entry Entry) panic(args ...string) {
	entry.log(.panic, ...args)
}

// Entry Println family functions

pub fn (mut entry Entry) logln(level Level, args ...string) {
	if entry.logger.is_level_enabled(level) {
		mut res := strings.new_builder(64)
		for _, val in args {
			res.write(val)
		}
		res.write_b(`\n`)
		entry.log_message(level, res.str())
	}
}

pub fn (mut entry Entry) debugln(args ...string) {
	entry.logln(.debug, ...args)
}

pub fn (mut entry Entry) println(args ...string) {
	entry.infoln(...args)
}

pub fn (mut entry Entry) infoln(args ...string) {
	entry.logln(.info, ...args)
}

pub fn (mut entry Entry) warnln(args ...string) {
	entry.logln(.warn, ...args)
}

pub fn (mut entry Entry) warningln(args ...string) {
	entry.warnln(...args)
}

pub fn (mut entry Entry) errorln(args ...string) {
	entry.logln(.error, ...args)
}

pub fn (mut entry Entry) fatalln(args ...string) {
	entry.logln(.fatal, ...args)
	entry.logger.exit(1)
}

pub fn (mut entry Entry) panicln(args ...string) {
	entry.logln(.panic, ...args)
}