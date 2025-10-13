class_name NumberTools

## The largest integers allowed.
##
## Accurate as of Godot 4.5.
##
## Just like in C, the numbers wrap.
## i.e., [code]MAX_INT + 1 == MIN_INT[/code]
const MAX_INT: int = 9223372036854775807 # 2^63 - 1 ~ 9.22e18
const MIN_INT: int = -9223372036854775808 # -2^63 ~ -9.22e18

# TODO: If 9e18 isn't big enough, I'll have to use peachey2k2/break-nihility

enum NumberFormat {
	NONE = 0,
	SHORT_SCALE = 1,
	ENGINEERING = 2,
	SCIENTIFIC = 3,
}

enum NumberGroupSeparator {
	COMMA = 0,
	PERIOD = 1,
	SPACE = 2,
}

enum NumberDecimalSeparator {
	PERIOD = 0,
	COMMA = 1,
}

## Short scale units
## https://en.wikipedia.org/wiki/Names_of_large_numbers#Short_scale
const SHORT_SCALE_UNIT: Dictionary[int, String] = {
	3: "K",
	6: "M",
	9: "B",
	12: "T",
	15: "Qa",
	18: "Qi",
}


## Given a NumberGroupSeparator, returns the string to use.
static func lookup_grouping_separator(sep: NumberGroupSeparator) -> String:
	match sep:
		NumberGroupSeparator.COMMA:
			return ","
		NumberGroupSeparator.PERIOD:
			return "."
		NumberGroupSeparator.SPACE:
			return " "
		_:
			push_error("Unknown grouping separator %s" % sep)
			return ","


## Given a NumberDecimalSeparator, returns the string to use.
static func lookup_decimal_separator(sep: NumberDecimalSeparator) -> String:
	match sep:
		NumberDecimalSeparator.PERIOD:
			return "."
		NumberDecimalSeparator.COMMA:
			return ","
		_:
			push_error("Unknown decimal separator %s" % sep)
			return "."


## Format according to [code]format[/code].
static func format(
		number: int,
		number_format: NumberFormat,
		grouping_separator: NumberGroupSeparator = NumberGroupSeparator.COMMA,
		decimal_separator: NumberDecimalSeparator = NumberDecimalSeparator.PERIOD,
) -> String:
	var formatted: String
	match number_format:
		NumberFormat.NONE:
			formatted = comma_notate_int(number, grouping_separator)
		NumberFormat.ENGINEERING:
			formatted = engineering_notate_int(number, decimal_separator)
		NumberFormat.SCIENTIFIC:
			formatted = scientific_notate_int(number, decimal_separator)
		_:
			push_error(
				"Unknown number format %s when trying to format %d" % [
					number_format,
					number,
				],
			)
			formatted = str(number)

	return formatted


## Returns an integer formatted in scientific notation.
##
## Scientific notation is of the form D.DDeX, where
## D.DD is the number with one digit before the decimal point,
## and X is the exponent (power of ten).
##
## Examples:
##  1234 -> "1.23e3"
##  12345 -> "1
static func scientific_notate_int(
		number: int,
		decimal_separator: NumberDecimalSeparator = NumberDecimalSeparator.PERIOD,
) -> String:
	var sign_str: String = "-" if number < 0 else ""
	var num: int = absi(number)
	var dsep: String = lookup_decimal_separator(decimal_separator)

	if num < 1_000:
		return str(number)

	var num_str: String = str(num)

	var leading_digit: String = num_str.substr(0, 1)
	var trailing_digits: String = num_str.substr(1, 2)
	var e: int = num_str.length() - 1

	if trailing_digits == "00":
		trailing_digits = ""
	elif trailing_digits.substr(1, 1) == "0":
		trailing_digits = trailing_digits.substr(0, 1)

	if trailing_digits:
		trailing_digits = "%s%s" % [dsep, trailing_digits]

	return "%s%s%se%d" % [
		sign_str,
		leading_digit,
		trailing_digits,
		e,
	]


## Returns an integer formatted in engineering notation.
##
## Engineering notation is like scientific notation, but the
## exponent is always a multiple of three.
##
## Examples:
##  1234 -> "1.23e3"
##  12345 -> "12.3e3"
##  123456 -> "123e3"
static func engineering_notate_int(
		number: int,
		decimal_separator: NumberDecimalSeparator = NumberDecimalSeparator.PERIOD,
) -> String:
	var num: int = absi(number)
	var dsep: String = lookup_decimal_separator(decimal_separator)

	# If it's less than 1,000 we don't need to do anything.
	if num < 1_000:
		return str(number)

	var num_str: String = str(num)

	# Engineering numbers have a mantissa of
	# 1, 2, or 3 digits.
	var mantissa: String
	var decimal_size = num_str.length() % 3
	if decimal_size == 0:
		mantissa = num_str.substr(0, 3)
		decimal_size = 3
	else:
		var frac: String = num_str.substr(decimal_size, 3 - decimal_size)
		if frac == "00":
			frac = ""
		elif frac.substr(frac.length() - 1, 1) == "0":
			frac = frac.substr(0, frac.length() - 1)

		if frac:
			mantissa = "%s%s%s" % [
				num_str.substr(0, decimal_size),
				dsep,
				frac,
			]
		else:
			mantissa = num_str.substr(0, decimal_size)

	var sign_str: String = "-" if number < 0 else ""
	var e: int = str(num_str).length() - decimal_size

	return "%s%se%d" % [
		sign_str,
		mantissa,
		e,
	]


## Convert the number into a string that has a comma
## separating every thousandth.
##
## Examples:
##  1234 -> "1,234"
##  1234567 -> "1,234,567"
static func comma_notate_int(
		number: int,
		grouping_separator: NumberGroupSeparator = NumberGroupSeparator.COMMA,
) -> String:
	var num: int = absi(number)
	var num_str: String = str(num)
	var gsep: String = lookup_grouping_separator(grouping_separator)

	if num < 1_000:
		return str(number)

	var sign_str: String = "-" if number < 0 else ""

	var parts: Array = []
	# Grab the first 1-3 digits before the first comma.
	var first_digits_size: int = num_str.length() % 3
	if first_digits_size == 0:
		first_digits_size = 3
	var first_digits: String = num_str.substr(0, first_digits_size)

	parts.append("%s%s" % [sign_str, first_digits])
	for i: int in range(first_digits_size, num_str.length(), 3):
		parts.append(num_str.substr(i, 3))

	return gsep.join(parts)


## Convert the number into a string using short scale unit suffixes.
static func short_scale_notate_int(
		number: int,
		decimal_separator: NumberDecimalSeparator = NumberDecimalSeparator.PERIOD,
) -> String:
	var num: int = absi(number)

	if num < 1_000:
		return str(number)

	var sign_str: String = "-" if number < 0 else ""
	var num_str: String = str(num)

	# Grab the leading 1-3 digits before the suffix.
	var leading_digits_size: int = num_str.length() % 3
	var leading_digits: String
	if leading_digits_size == 0:
		leading_digits_size = 3
		leading_digits = num_str.substr(0, leading_digits_size)
	else:
		var frac: String = num_str.substr(leading_digits_size, 3 - leading_digits_size)
		if frac == "00":
			frac = ""
		elif frac.substr(frac.length() - 1, 1) == "0":
			frac = frac.substr(0, frac.length() - 1)
		var dsep: String = lookup_decimal_separator(decimal_separator)
		leading_digits = "%s%s%s" % [
			num_str.substr(0, leading_digits_size),
			dsep if frac else "",
			frac,
		]

	# Find the appropriate suffix.
	var exponent: int = num_str.length() - leading_digits_size

	var suffix: String = SHORT_SCALE_UNIT.get(exponent, "")
	if suffix == "":
		push_error("No short scale suffix for exponent %d" % exponent)

	return "%s%s%s" % [
		sign_str,
		leading_digits,
		suffix,
	]
