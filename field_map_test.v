module treplo

import x.json2 as json

// fn test_field_map() {
// 	mut fd := FieldMap{
// 		'level': "log"
// 	}
// 	mut answer := ''
	
// 	answer = fd.resolve("level")
// 	assert answer == "level"

// 	mut mp := map[string]string{}
// 	mp['level'] = 'log_level'
// 	fd = FieldMap(mp)

// 	answer = fd.resolve("level")
// 	assert answer == "log_level"
// }

fn test_prefix_field_clashes() {
	mut data := map{
		"level": json.Any("Deep dark fantasy")
		"description": json.Any("Three hundred bucks")
	}
	assert true
}