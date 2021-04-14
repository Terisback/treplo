module treplo

import time
import x.json2 as json

fn test_default() {
	mut t := time.now()
	mut log := new()
	
	mut f := &JSONFormatter{}
	log.set_formatter(f)
	
	mut en := new_entry(mut log)
	en.time = t
	en.message = "Hello"
	data := f.format(en) or {
		assert false
		return
	}
	assert data.bytestr() 
		== '{"time":"${t.format_ss()}","msg":"Hello","level":"info"}\n'
}

fn test_disable_timestamp() {
	mut t := time.now()
	mut log := new()
	
	mut f := &JSONFormatter{
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
	assert data.bytestr() 
		== '{"msg":"Hello","level":"info"}\n'
}

fn test_data_key() {
	mut t := time.now()
	mut log := new()
	
	mut f := &JSONFormatter{
		disable_timestamp: true
		data_key: "dog"
	}
	log.set_formatter(f)
	
	mut en := new_entry(mut log)
	en.time = t
	en.message = "Hello"
	en.data = map{
		"name": json.Any("bark")
		"color": json.Any("dark bark")
	}
	data := f.format(en) or {
		assert false
		return
	}
	assert data.bytestr() 
		== '{"dog":{"name":"bark","color":"dark bark"},"msg":"Hello","level":"info"}\n'
}