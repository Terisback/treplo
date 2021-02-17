module treplo

import x.json2 as json

// JSONFormatter formats logs into parsable json
struct JSONFormatter {
	// Allows disabling automatic timestamps in output
	disable_timestamp bool

	// Allows users to put all the log entry parameters into a nested dictionary at a given key.
	data_key string

	// Allows users to customize the names of keys for default fields.
	// As an example:
	// formatter := &treplo.JSONFormatter{
	//     field_map: treplo.FieldMap{
	//         treplo.field_key_time:  "@timestamp"
	//         treplo.field_key_level: "@level"
	//         treplo.field_key_msg:   "@message"
	//     }
	// }
	field_map FieldMap
}

// Renders a single log entry
pub fn (f JSONFormatter) format(entry Entry) ?[]byte {
	mut data := entry.data.clone()

	if f.data_key != '' {
		mut new_data := map[string]json.Any{}
		new_data[f.data_key] = data
		data = new_data.move()
	}
	
	prefix_field_clashes(mut data, f.field_map)

	if !f.disable_timestamp {
		data[f.field_map.resolve(field_key_time)] = entry.time.format_ss() 
	}
	data[f.field_map.resolve(field_key_msg)] = entry.message
	data[f.field_map.resolve(field_key_level)] = entry.level.str()

	return data.str().bytes()
}