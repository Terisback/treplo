module treplo

import time
import term
import os
import strings
import x.json2 as json

const (
	base_timestamp = time.now()
)

// Type for key sorting function from TextFormatter
type SortingFunc = fn(mut keys []string)

// Default sort for keys 
fn default_sort(mut keys []string) {
	keys.sort()
} 

pub struct TextFormatter {
pub:
	// Force disabling colors
	disable_colors bool

	// Force quoting of all values
	force_quote bool

	// DisableQuote disables quoting for all values.
	// DisableQuote will have a lower priority than ForceQuote.
	// If both of them are set to true, quote will be forced on all values.
	disable_quote bool

	// Override coloring based on CLICOLOR and CLICOLOR_FORCE
	environment_override_colors bool

	// Disable timestamp logging. useful when output is redirected to logging
	// system that already adds timestamps.
	disable_timestamp bool

	// Enable logging the full timestamp instead of just
	// the time passed since beginning of execution.
	full_timestamp bool

	// The fields are sorted by default for a consistent output. For applications
	// that log extremely frequently and don't use the JSON formatter this may not
	// be desired.
	disable_sorting bool

	// The keys sorting function, when uninitialized it uses []string.sort
	sorting_func SortingFunc = default_sort

	// Disables the truncation of the level text to 4 characters.
	disable_level_truncation bool = true

	// pad_level_text Adds padding the level text so that all the levels output at the same length
	// pad_level_text is a superset of the DisableLevelTruncation option
	pad_level_text bool

	// Will wrap empty fields in quotes if true
	quote_empty_fields bool

	// Allows users to customize the names of keys for default fields.
	// As an example:
	// formatter := &treplo.TextFormatter{
	//     field_map: treplo.FieldMap{
	//         treplo.field_key_time:  "@timestamp"
	//         treplo.field_key_level: "@level"
	//         treplo.field_key_msg:   "@message"
	//     }
	// }
	field_map FieldMap

	// The max length of the level text, by default is 5
	level_text_max_length int = 4
}

fn (mut f TextFormatter) is_colored() bool {
	mut is_colored := true

	if f.environment_override_colors {
		force_color :=  os.getenv("CLICOLOR_FORCE")
		if force_color == "0" || force_color.to_lower() == "false" || os.getenv("CLICOLOR") == "0"{
			is_colored = false
		} else if force_color != "" {
			is_colored = true
		}
	}

	return is_colored && !f.disable_colors
}

pub fn (mut f TextFormatter) format(entry Entry) ?[]byte {
	mut builder := strings.new_builder(256)

	mut level_text := entry.level.str().to_upper()
	if !f.disable_level_truncation && !f.pad_level_text {
		level_text = level_text[0..f.level_text_max_length]
	}
	if f.pad_level_text {
		level_text = trail_spaces(level_text, f.level_text_max_length)
	}

	builder.write_string(f.color_it(entry.level, level_text))

	message := entry.message.trim_suffix("\n")
	
	if !f.disable_timestamp {
		if !f.full_timestamp {
			builder.write_string("[${(entry.time - base_timestamp)/time.second:04}]")
		} else {
			builder.write_string("[${entry.time.format_ss()}]")
		}
	}

	if message != "" {
		builder.write_string(" " + message)
	}

	mut data := entry.data.clone()

	prefix_field_clashes(mut data, f.field_map)

	if !f.disable_sorting {
		mut keys := data.keys()
		f.sorting_func(mut keys)
		mut new_data := map[string]json.Any{}
		for _, key in keys {
			if key in data {
				new_data[key] = data[key]
			}
		}
		data = new_data.move()
	}
	
	for key, val in data {
		builder.write_b(` `)
		builder.write_string(f.color_it(entry.level, key) + 
			"=" + 
			f.add_quotes_if_needed(val.str()))
	}

	builder.write_b(`\n`)
	return builder.str().bytes()
}

fn trail_spaces(text string, length int) string {
	if text.len >= length {
		return text
	}

	return text + " ".repeat(length - text.len)
}

fn (f TextFormatter) needs_quotes(text string) bool {
	if f.force_quote { return true }
	if f.quote_empty_fields && text.len == 0 { return true }
	if f.disable_quote { return false }
	for _, ch in text {
		if !((ch >= `a` && ch <= `z`) ||
			(ch >= `A` && ch <= `Z`) ||
			(ch >= `0` && ch <= `9`) ||
			ch == `-` || 
			ch == `.` ||
			ch == `_` ||
			ch == `/` ||
			ch == `@` ||
			ch == `^` ||
			ch == `+`) { return true }
	}
	return false
}

fn (f TextFormatter) add_quotes_if_needed(text string) string {
	if f.needs_quotes(text) {
		return "\"${text}\""
	}
	return text
}

fn (mut f TextFormatter) color_it(level Level, text string) string {
	if !f.is_colored() {
		return text
	}

	match level {
		.debug {
			return term.dim(text)
		}
		.warn {
			return term.bright_yellow(text)
		}
		.panic, .fatal, .error {
			return term.bright_red(text)
		}		
		else {
			return term.bright_blue(text)
		}
	}
}