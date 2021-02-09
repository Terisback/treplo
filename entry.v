module treplo

import x.json2 as json

// An entry is the final or intermediate treplo logging entry. It contains all
// the fields passed with `with_fields()`. It's finally logged when debug,
// info, warn, error, fatal or panic is called on it.
struct Entry {
pub:
	logger &Logger

	// Time at which the log entry was created
	time time.Time

	// Level the log entry was logged at: debug, info, warn, error, fatal or panic
	level Level

	// Message passed to `debug`, `info`, `warn`, `error`, `fatal` or `panic`
	message string

	// Contains additional fields passed by `with_fields`
	data map[string]json.Any = map[string]json.Any{}
}