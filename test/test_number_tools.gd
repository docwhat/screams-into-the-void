extends GdUnitTestSuite

## Test that scientific_notate_int() returns the correct notation.
func test_scientific_notate_int():
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


## Test that engineering_notate_int() returns the correct notation.
func test_engineering_notate_int():
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

## Test that comma_notate_int() returns the correct notation.
func test_comma_notate_int():
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
