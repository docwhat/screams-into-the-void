class_name NumberTools

## FIXME: Need refactorization so I can understand it better.
## From https://gist.github.com/t-karcher/053b7097e744bc3ba4e1d20441ab72a7
func get_scientific_notation(
		number: float,
		precision: int = 99,
		use_engineering_notation: bool = false
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
