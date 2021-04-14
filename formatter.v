module treplo 

// Formatter interface is used to implement a custom Formatter.
// The Formatter interface is used to implement a custom Formatter. It takes an
// `Entry`. It exposes all the fields, including the default ones:
//
// * `entry.data["msg"]`. The message passed from info, warn, error ..
// * `entry.data["time"]`. The timestamp.
// * `entry.data["level"]. The level the entry was logged at.
//
// Any additional fields added with `with_field` or `with_fields` are also in
// `entry.data`. Format is expected to return an array of bytes which are then
// logged to `logger.out`.
pub interface Formatter {
	format(Entry) ?[]byte
}
