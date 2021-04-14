module treplo

import x.json2 as json

fn test_field_map() {
	// mut fd := FieldMap(map{
	// 	"level": "log"
	// })
	// assert fd.resolve("level") == "log"

	// Stupid, but works
	mut mp := map[string]string{}
	mut fd := FieldMap(mp)
	fd['level'] = 'log_level'

	answer := fd.resolve("level")
	assert answer == "log_level"
}

fn test_prefix_field_clashes() {
	mut data := map{
		"level": json.Any("Deep dark fantasy")
		"description": json.Any("Three hundred bucks")
	}
	mut mp := map[string]string{}
	mut fd := FieldMap(mp)
	prefix_field_clashes(mut data, fd)
	assert data.str() == '{"description":"Three hundred bucks","fields.level":"Deep dark fantasy"}'
}