module treplo

import x.json2 as json

// Logging levels
pub enum Level {
	panic = 0
	fatal
	error
	warn
	info
	debug
}

// Field type, used in `with_fields`
pub struct Field {
	key string
	val json.Any
}

}