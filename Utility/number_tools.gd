class_name NumberTools

## The largest integers allowed.
##
## Accurate as of Godot 4.5.
##
## Just like in C, the numbers wrap.
## i.e., [code]MAX_INT + 1 == MIN_INT[/code]
const MAX_INT: int = 9223372036854775807 # 2^63 - 1
const MIN_INT: int = -9223372036854775808 # -2^63

## Returns an integer formatted in scientific notation.
##
## Scientific notation is of the form D.DDeX, where
## D.DD is the number with one digit before the decimal point,
## and X is the exponent (power of ten).
##
## Examples:
##  1234 -> "1.23e3"
##  12345 -> "1
static func scientific_notate_int(number: int) -> String:
	var sign_str: String = "-" if number < 0 else ""
	var num: int = absi(number)

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
		trailing_digits = ".%s" % trailing_digits

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
static func engineering_notate_int(number: int) -> String:
	var num: int = absi(number)

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
			mantissa = "%s.%s" % [
				num_str.substr(0, decimal_size),
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
static func comma_notate_int(number: int) -> String:
	var num: int = absi(number)
	var num_str: String = str(num)
	
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

	return ",".join(parts)


## FIXME: Need refactorization so I can understand it better.
## From https://gist.github.com/t-karcher/053b7097e744bc3ba4e1d20441ab72a7
func get_scientific_notation(
		number: float,
		precision: int = 99,
		use_engineering_notation: bool = false,
) -> String:
	var sign_ = sign(number)
	number = abs(number)
	if number < 1:
		var exp_ = step_decimals(number)
		if use_engineering_notation:
			exp_ = snapped(exp_ + 1, 3)
		var coeff = sign_ * number * pow(10, exp_)
		return str(snapped(coeff, pow(10, -precision))) + "e" + str(-exp_)

	if number >= 10:
		var exp_ = str(number).split(".")[0].length() - 1
		if use_engineering_notation:
			exp_ = snapped(exp_ - 1, 3)
		var coeff = sign_ * number / pow(10, exp_)
		return str(snapped(coeff, pow(10, -precision))) + "e" + str(exp_)

	return str(snapped(sign_ * number, pow(10, -precision))) + "e0"


## Format numbers
func fnum(num: int) -> String:
	if num >= 10000:
		return get_scientific_notation(num, 2, false) # TODO: scientific, eng, etc.

	return str(num)
