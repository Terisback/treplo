module treplo

import x.json2 as json

// Default key names for the default fields
pub const (
	field_key_msg            = "msg"
	field_key_level          = "level"
	field_key_time           = "time"
	field_key_treplo_error   = "treplo_error"
	field_key_func           = "func"
	field_key_file           = "file"
)

// FieldMap allows customization of the key names for default fields.
type FieldMap = map[string]string

// Resolve key names collisions
// Returns key name if there is override in field map
fn (f FieldMap) resolve(key string) string {
	mut field_map := map[string]string{}
	field_map = f
	if key in field_map { return field_map[key] }
	return key
}

// This is to not silently overwrite `time`, `msg`, `func` and `level` fields when
// dumping it. If this code wasn't there doing:
//
//  treplo.with_field("level", 1).info("hello")
//
// Would just silently drop the user provided level. Instead with this code
// it'll logged as:
//
//  {"level": "info", "fields.level": 1, "msg": "hello", "time": "..."}
//
// It's not exported because it's still using data in an opinionated way. It's to
// avoid code duplication between the two default formatters.
fn prefix_field_clashes(mut data map[string]json.Any, field_map FieldMap) {
	time_key := field_map.resolve(field_key_time)
	if time_key in data {
		data['fields.${time_key}'] = data[time_key]
		data.delete(time_key)
	}

	msg_key := field_map.resolve(field_key_msg)
	if msg_key in data {
		data['fields.${msg_key}'] = data[msg_key]
		data.delete(msg_key)
	}

	level_key := field_map.resolve(field_key_level)
	if level_key in data {
		data['fields.${level_key}'] = data[level_key]
		data.delete(level_key)
	}

	treplo_error_key := field_map.resolve(field_key_treplo_error)
	if treplo_error_key in data {
		data['fields.${treplo_error_key}'] = data[treplo_error_key]
		data.delete(treplo_error_key)
	}
}