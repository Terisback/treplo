module treplo

import time
import x.json2 as json

fn test_default_text() {
	mut t := time.now()
	mut log := new()
	
	mut f := &TextFormatter{}
	log.set_formatter(f)
	
	mut en := new_entry(mut log)
	en.time = t
	en.message = "Hello"
	data := f.format(en) or {
		assert false
		return
	}
	assert data.bytestr() == "INFO[${stime(t)}] Hello\n"
}

fn test_full_timestamp() {
	mut t := time.now()
	mut log := new()
	
	mut f := &TextFormatter{
		full_timestamp: true
	}
	log.set_formatter(f)
	
	mut en := new_entry(mut log)
	en.time = t
	en.message = "Hello"
	data := f.format(en) or {
		assert false
		return
	}
	assert data.bytestr() == "INFO[${t.format_ss()}] Hello\n"
}

fn test_disable_timestamp() {
	mut t := time.now()
	mut log := new()
	
	mut f := &TextFormatter{
		disable_timestamp: true
	}
	log.set_formatter(f)
	
	mut en := new_entry(mut log)
	en.time = t
	en.message = "Hello"
	data := f.format(en) or {
		assert false
		return
	}
	assert data.bytestr() == "INFO Hello\n"
}

const (
	big_map = map{
		"firstname": json.Any("Ivan")
		"secondname": json.Any("Ivanov")
		"country": json.Any("Russian Federation")
		"balance": json.Any(200.48)
		"married": json.Any(false)
		"age": json.Any(24)
		"cat name": json.Any("")
	}
)

// By default quotes disabled
fn test_fields() {
	mut t := time.now()
	mut log := new()
	
	mut f := &TextFormatter{
		disable_timestamp: true
	}
	log.set_formatter(f)
	
	mut en := new_entry(mut log)
	en.time = t
	en.message = "Hello"
	en = en.with_fields(big_map)
	data := f.format(en) or {
		assert false
		return
	}
	assert data.bytestr() == "INFO Hello " +
		"firstname=Ivan secondname=Ivanov " +
		"country=\"Russian Federation\" balance=200.48 " +
		"married=false age=24 cat name=" + "\n"
}

fn test_fields_force_quotes() {
	mut t := time.now()
	mut log := new()
	
	mut f := &TextFormatter{
		disable_timestamp: true
		force_quote: true
	}
	log.set_formatter(f)
	
	mut en := new_entry(mut log)
	en.time = t
	en.message = "Hello"
	en = en.with_fields(big_map)
	data := f.format(en) or {
		assert false
		return
	}
	assert data.bytestr() == "INFO Hello " +
		"firstname=\"Ivan\" secondname=\"Ivanov\" " +
		"country=\"Russian Federation\" balance=\"200.48\" " +
		"married=\"false\" age=\"24\" cat name=\"\"" + "\n"
}

fn test_fields_quote_empty() {
	mut t := time.now()
	mut log := new()
	
	mut f := &TextFormatter{
		disable_timestamp: true
		quote_empty_fields: true
	}
	log.set_formatter(f)
	
	mut en := new_entry(mut log)
	en.time = t
	en.message = "Hello"
	en = en.with_fields(big_map)
	data := f.format(en) or {
		assert false
		return
	}
	assert data.bytestr() == "INFO Hello " +
		"firstname=Ivan secondname=Ivanov " +
		"country=\"Russian Federation\" balance=200.48 " +
		"married=false age=24 cat name=\"\"" + "\n"
}

fn test_fields_disable_quote() {
	mut t := time.now()
	mut log := new()
	
	mut f := &TextFormatter{
		disable_timestamp: true
		disable_quote: true
	}
	log.set_formatter(f)
	
	mut en := new_entry(mut log)
	en.time = t
	en.message = "Hello"
	en = en.with_fields(big_map)
	data := f.format(en) or {
		assert false
		return
	}
	assert data.bytestr() == "INFO Hello " +
		"firstname=Ivan secondname=Ivanov " +
		"country=Russian Federation balance=200.48 " +
		"married=false age=24 cat name=" + "\n"
}

fn test_levels() {
	mut log := new()
	log.set_level(.debug)
	
	mut f := &TextFormatter{
		disable_timestamp: true
		disable_quote: true
	}
	log.set_formatter(f)
	mut en := new_entry(mut log)
	en.message = "Levels"
	en.level = .debug
	mut data := f.format(en) or {
		assert false
		return
	}
	assert data.bytestr() == "DEBUG Levels\n"

	en.level = .info
	data = f.format(en) or {
		assert false
		return
	}
	assert data.bytestr() == "INFO Levels\n"

	en.level = .warn
	data = f.format(en) or {
		assert false
		return
	}
	assert data.bytestr() == "WARN Levels\n"

	en.level = .error
	data = f.format(en) or {
		assert false
		return
	}
	assert data.bytestr() == "ERROR Levels\n"

	en.level = .fatal
	data = f.format(en) or {
		assert false
		return
	}
	assert data.bytestr() == "FATAL Levels\n"

	en.level = .panic
	data = f.format(en) or {
		assert false
		return
	}
	assert data.bytestr() == "PANIC Levels\n"
}

// Utility func that returns seconds in format that TextFormatter uses
fn stime(t time.Time) string{
	return "${(t - base_timestamp)/time.second:04}"
}