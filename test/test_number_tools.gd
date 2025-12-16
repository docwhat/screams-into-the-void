extends GdUnitTestSuite

## Test that scientific_notate_int() returns the correct notation.
func test_scientific_notate_int() -> void:
	var table: Array = [
		# Positives
		[1_234_567, "1.23e6"],
		[123_456, "1.23e5"],
		[12_345, "1.23e4"],
		[1_234, "1.23e3"],
		[123, "123"],
		[12, "12"],
		[1, "1"],

		# Negatives
		[-1, "-1"],
		[-123, "-123"],
		[-9_876, "-9.87e3"],
		[-9_876_543, "-9.87e6"],

		# with zeros
		[0, "0"],
		[10, "10"],
		[100, "100"],
		[1_000, "1e3"],
		[10_000, "1e4"],
		[100_000, "1e5"],
		[1_000_000, "1e6"],
		[1_900, "1.9e3"],
		[19_000, "1.9e4"],
		[190_000, "1.9e5"],
	]
	for parts: Array in table:
		var number: int = parts[0]
		var expected: String = parts[1]
		assert_str(
			NumberTools.scientific_notate_int(number),
		).append_failure_message(
			"for %d" % number,
		).is_equal(expected)

		# Fail fast
		if is_failure():
			return


## Test that scientific_notate_int() handles comma decimal separators.
func test_scientific_notate_int_dsep_comma() -> void:
	var number: int = 1_234_567
	var expected: String = "1,23e6"
	var got: String = NumberTools.scientific_notate_int(
		number,
		NumberTools.NumberDecimalSeparator.COMMA,
	)
	assert_str(got).append_failure_message("for %d" % number).is_equal(expected)


## Test that engineering_notate_int() returns the correct notation.
func test_engineering_notate_int() -> void:
	var table: Array = [
		# Positives
		[1_234_567, "1.23e6"],
		[123_456, "123e3"],
		[12_345, "12.3e3"],
		[1_234, "1.23e3"],
		[123, "123"],
		[12, "12"],
		[1, "1"],

		# Negatives
		[-1, "-1"],
		[-123, "-123"],
		[-9_876, "-9.87e3"],
		[-98_765, "-98.7e3"],
		[-987_654, "-987e3"],
		[-9_876_543, "-9.87e6"],
		[-98_765_432, "-98.7e6"],

		# with zeros
		[0, "0"],
		[10, "10"],
		[100, "100"],
		[1_000, "1e3"],
		[10_000, "10e3"],
		[100_000, "100e3"],
		[1_000_000, "1e6"],
		[1_900, "1.9e3"],
		[19_000, "19e3"],
		[190_000, "190e3"],
	]
	for parts: Array in table:
		var number: int = parts[0]
		var expected: String = parts[1]
		var got: String = NumberTools.engineering_notate_int(number)
		assert_str(
			got,
		).append_failure_message(
			"got %s for %d" % [got, number],
		).is_equal(expected)

		# Fail fast
		if is_failure():
			return


## Test that engineering_notate_int() handles comma decimal separators.
func test_engineering_notate_int_dsep_comma() -> void:
	var number: int = 12_345
	var expected: String = "12,3e3"
	var got: String = NumberTools.engineering_notate_int(
		number,
		NumberTools.NumberDecimalSeparator.COMMA,
	)
	assert_str(got).append_failure_message("for %d" % number).is_equal(expected)


## Test that comma_notate_int() returns the correct notation.
func test_comma_notate_int() -> void:
	var table: Array = [
		# Positives
		[1_234_567, "1,234,567"],
		[123_456, "123,456"],
		[12_345, "12,345"],
		[1_234, "1,234"],
		[123, "123"],
		[12, "12"],
		[1, "1"],

		# Negatives
		[-1, "-1"],
		[-123, "-123"],
		[-9_876, "-9,876"],
		[-98_765, "-98,765"],
		[-987_654, "-987,654"],
		[-9_876_543, "-9,876,543"],
		[-98_765_432, "-98,765,432"],
	]
	for parts: Array in table:
		var number: int = parts[0]
		var expected: String = parts[1]
		var got: String = NumberTools.comma_notate_int(number)

		assert_str(got).append_failure_message("for %d" % [number]).is_equal(expected)

		# Fail fast
		if is_failure():
			return


## Test that comma_notate_int() handles period decimal separators.
func test_comma_notate_int_dsep_period() -> void:
	var number: int = 1_234_567
	var expected: String = "1.234.567"
	var got: String = NumberTools.comma_notate_int(
		number,
		NumberTools.NumberGroupSeparator.PERIOD,
	)
	assert_str(got).append_failure_message("for %d" % number).is_equal(expected)


## Test that comma_notate_int() handles space decimal separators.
func test_comma_notate_int_dsep_space() -> void:
	var number: int = 1_234_567
	var expected: String = "1 234 567"
	var got: String = NumberTools.comma_notate_int(
		number,
		NumberTools.NumberGroupSeparator.SPACE,
	)
	assert_str(got).append_failure_message("for %d" % number).is_equal(expected)


## Test short_scale_notate_int() returns the correct notation.
func test_short_scale_notate_int() -> void:
	var table: Array = [
		# Positives
		[1_234_567, "1.23M"],
		[123_456, "123K"],
		[12_345, "12.3K"],
		[1_234, "1.23K"],
		[123, "123"],
		[12, "12"],
		[1, "1"],

		# Negatives
		[-1, "-1"],
		[-123, "-123"],
		[-9_876, "-9.87K"],
		[-98_765, "-98.7K"],
		[-987_654, "-987K"],
		[-9_876_543, "-9.87M"],
		[-98_765_432, "-98.7M"],

		# with zeros
		[0, "0"],
		[10, "10"],
		[100, "100"],
		[1_000, "1K"],
		[10_000, "10K"],
		[100_000, "100K"],
		[1_000_000, "1M"],
		[1_900, "1.9K"],
		[19_000, "19K"],
		[190_000, "190K"],

		# Big numbers
		[1_000_000_000, "1B"],
		[1_500_000_000, "1.5B"],
		[1_222_333_444_555_666_777, "1.22Qi"],
		[1_000_000_000_000_000_000, "1Qi"],
	]
	for parts: Array in table:
		var number: int = parts[0]
		var expected: String = parts[1]
		var got: String = NumberTools.short_scale_notate_int(number)

		assert_str(
			got,
		).append_failure_message(
			"got %s for %d" % [got, number],
		).is_equal(expected)

		# Fail fast
		if is_failure():
			return
