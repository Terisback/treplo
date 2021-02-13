module treplo

import time
import term
import os
import strings

const (
	base_timestamp = time.now()
)

pub struct TextFormatter {
pub:
	force_colors bool
	disable_colors bool
	force_quote bool
	disable_quote bool
	environment_override_colors bool
	disable_timestamp bool
	full_timestamp bool

	disable_sorting bool
	sorting_func SortingFunc = {}

	disable_level_truncation bool = true
	pad_level_text bool
	quote_empty_fields bool

	level_text_max_length int = 5
}

fn (mut f TextFormatter) is_colored() bool {
	mut is_colored := f.force_colors

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
	f.print(mut builder, entry)
	builder.write_b(`\n`)
	return builder.str().bytes()
}

fn (mut f TextFormatter) print(mut b strings.Builder, entry Entry) {
	mut level_text := entry.level.str().to_upper()
	if !f.disable_level_truncation && !f.pad_level_text {
		level_text = level_text[0..f.level_text_max_length]
	}
	if f.pad_level_text {
		level_text = trail_spaces(level_text, f.level_text_max_length)
	}

	b.write(f.color_it(entry.level, level_text))

	message := entry.message.trim_suffix("\n")
	
	if !f.disable_timestamp {
		if !f.full_timestamp {
			b.write("[${(entry.time - base_timestamp)/time.second:04}]")
		} else {
			b.write("[${entry.time.format_ss()}]")
		}
	}

	if message != "" {
		b.write(" " + message)
	}

	for key, val in entry.data {
		b.write_b(` `)
		b.write(f.color_it(entry.level, key) + 
			"=" + 
			f.add_quotes_if_needed(val.str()))
	}
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
			return term.gray(text)
		}
		.warn {
			return term.yellow(text)
		}
		.panic, .fatal, .error {
			return term.red(text)
		}		
		else {
			return term.blue(text)
		}
	}
}