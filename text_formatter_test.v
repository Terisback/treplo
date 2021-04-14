module treplo

import time
import x.json2 as json

const (
	b_st = '\e[94m'
	b_en = '\e[39m'
)

fn test_default() {
	mut t := time.now()
	mut log := new()
	
	mut f := &TextFormatter{
		disable_colors: true
	}
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
		disable_colors: true
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
		disable_colors: true
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
		disable_colors: true
		disable_timestamp: true
	}
	log.set_formatter(f)
	
	mut en := new_entry(mut log)
	en.time = t
	en.message = "Hello"
	en = en.with_fields_map(big_map)
	data := f.format(en) or {
		assert false
		return
	}
	assert data.bytestr() == "INFO Hello " +
		"age=24 balance=200.48 " +
		"cat name= country=\"Russian Federation\" " +
		"firstname=Ivan married=false secondname=Ivanov" + "\n"
}

fn test_field_color() {
	mut t := time.now()
	mut log := new()
	
	mut f := &TextFormatter{
		disable_timestamp: true
	}
	log.set_formatter(f)
	
	mut en := new_entry(mut log)
	en.time = t
	en.message = "Hello"
	en = en.with_fields_map(map{
		"age": json.Any(24)
	})
	data := f.format(en) or {
		assert false
		return
	}
	assert data.bytestr() == "\e[94mINFO\e[39m Hello " +
		"\e[94mage\e[39m=24" + "\n"
}

fn test_fields_force_quotes() {
	mut t := time.now()
	mut log := new()
	
	mut f := &TextFormatter{
		disable_colors: true
		disable_timestamp: true
		force_quote: true
	}
	log.set_formatter(f)
	
	mut en := new_entry(mut log)
	en.time = t
	en.message = "Hello"
	en = en.with_fields_map(big_map)
	data := f.format(en) or {
		assert false
		return
	}
	assert data.bytestr() == "INFO Hello " +
		'age="24" balance="200.48" ' +
		'cat name="" country=\"Russian Federation\" ' +
		'firstname="Ivan" married="false" secondname="Ivanov"' + "\n"
}

fn test_fields_quote_empty() {
	mut t := time.now()
	mut log := new()
	
	mut f := &TextFormatter{
		disable_colors: true
		disable_timestamp: true
		quote_empty_fields: true
	}
	log.set_formatter(f)
	
	mut en := new_entry(mut log)
	en.time = t
	en.message = "Hello"
	en = en.with_fields_map(big_map)
	data := f.format(en) or {
		assert false
		return
	}
	assert data.bytestr() == "INFO Hello " +
		"age=24 balance=200.48 " +
		"cat name=\"\" country=\"Russian Federation\" " +
		"firstname=Ivan married=false secondname=Ivanov" + "\n"
}

fn test_fields_disable_quote() {
	mut t := time.now()
	mut log := new()
	
	mut f := &TextFormatter{
		disable_colors: true
		disable_timestamp: true
		disable_quote: true
	}
	log.set_formatter(f)
	
	mut en := new_entry(mut log)
	en.time = t
	en.message = "Hello"
	en = en.with_fields_map(big_map)
	data := f.format(en) or {
		assert false
		return
	}
	assert data.bytestr() == "INFO Hello " +
		"age=24 balance=200.48 " +
		"cat name= country=Russian Federation " +
		"firstname=Ivan married=false secondname=Ivanov" + "\n"
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
	assert data.bytestr() == "\e[2mDEBUG\e[22m Levels\n"

	en.level = .info
	data = f.format(en) or {
		assert false
		return
	}
	assert data.bytestr() == "\e[94mINFO\e[39m Levels\n"

	en.level = .warn
	data = f.format(en) or {
		assert false
		return
	}
	assert data.bytestr() == "\e[93mWARN\e[39m Levels\n"

	en.level = .error
	data = f.format(en) or {
		assert false
		return
	}
	assert data.bytestr() == "\e[91mERROR\e[39m Levels\n"

	en.level = .fatal
	data = f.format(en) or {
		assert false
		return
	}
	assert data.bytestr() == "\e[91mFATAL\e[39m Levels\n"

	en.level = .panic
	data = f.format(en) or {
		assert false
		return
	}
	assert data.bytestr() == "\e[91mPANIC\e[39m Levels\n"
}

fn sort_by_alphabet(mut keys []string) {
	keys.sort()
}

fn test_fields_sorting() {
	mut log := new()
	
	mut f := &TextFormatter{
		disable_colors: true
		disable_timestamp: true
		disable_quote: true
		sorting_func: sort_by_alphabet
	}
	log.set_formatter(f)
	mut en := new_entry(mut log)
	en.message = "Sort"
	en = en.with_fields_map(map{
		"zina": json.Any("what")
		"babushka": json.Any("zina")
		"country": json.Any("Russian Federation")
		"abey": json.Any("road")
	})
	mut data := f.format(en) or {
		assert false
		return
	}
	assert data.bytestr() == "INFO Sort " +
		"abey=road babushka=zina " + 
		"country=Russian Federation zina=what" + "\n"
}

// Utility func that returns seconds in format that TextFormatter uses
fn stime(t time.Time) string{
	return "${(t - base_timestamp)/time.second:04}"
}