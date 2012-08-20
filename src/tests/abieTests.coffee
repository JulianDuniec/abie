abie = require '../lib/abie'

# ensures that AB-testing one option returns the same option
exports.abTestOneOption = (test) ->
	optionA = "optionA"
	res = abie.test("TestName", [{name: optionA}])
	test.equal res, optionA
	test.done()

# Ensures that a test with two options yield a 50 percent chance of 
# either option being displayed
exports.abTestTwoOptions = (test) ->
	optionA = "optionA" 
	optionB = "optionB"
	aCount = 0
	bCount = 0
	testCount = 10000
	halfTestCount = testCount / 2
	# How big errors we will tolerate
	error = (0.02 * testCount)
	limitLow = halfTestCount - error
	limitHigh = halfTestCount + error

	for i in [1..testCount]
		res = abie.test("Name", [{name : optionA}, {name: optionB}])
		if res == optionA
			++aCount
		else
			++bCount

	test.ok aCount > limitLow, "Acount too low " + aCount
	test.ok aCount < limitHigh, "Acount too high " + aCount
	test.ok bCount > limitLow, "Bcount too low " + bCount
	test.ok bCount < limitHigh, "Bcount too high " + bCount
	test.done()

# Ensures that a test that has expired always yields the default option
exports.abTestDuration = (test) ->
	optionA = "optionA"
	optionB = "optionB"
	startDate = Date.now() - 100
	endDate = Date.now() - 50
	testCount = 1000 
	for i in [1..testCount]
		res = abie.test(
			"Name", 
			[
				{name : optionA}, 
				{name : optionB}], 
			{
				startDate : startDate, 
				endDate : endDate
			}
		)
		test.equal(res, optionA)
	test.done()

# Ensures that the test returns 
# different results when the start- and end-dates make 
# the test active
exports.abTestActive = (test) ->
	optionA = "optionA" 
	optionB = "optionB"
	testName = "TestName"
	aCount = 0
	bCount = 0
	testCount = 10000
	halfTestCount = testCount / 2
	# How big errors we will tolerate
	error = (0.02 * testCount)
	limitLow = halfTestCount - error
	limitHigh = halfTestCount + error

	startDate = new Date().setDate(new Date().getDate()-1)
	endDate = new Date().setDate(new Date().getDate()+1)
	for i in [1..testCount]
		res = abie.test(
			testName, 
			[{name : optionA}, {name: optionB}], 
			{
				startDate : startDate,
				endDate : endDate
			})
		if res == optionA
			++aCount
		else
			++bCount

	test.ok aCount > limitLow, "Acount too low " + aCount
	test.ok aCount < limitHigh, "Acount too high " + aCount
	test.ok bCount > limitLow, "Bcount too low " + bCount
	test.ok bCount < limitHigh, "Bcount too high " + bCount
	test.done()

# Ensures that, if we supply a population for the test
# the default option will be returned after the population is reached
exports.abTestPopulation = (test) ->
	optionA = "optionA"
	optionB = "optionB"
	testName = "TestName"
	population = 10000
	cases = [{name : optionA}, {name: optionB}]
	options = {population : population}

	# The first items we pull can be random
	for i in [1..population]
		abie.test(testName, cases, options)
	
	# The following results should always return the default
	for i in [1..population]
		res = abie.test(testName, cases, options)
		test.equal res, optionA

	test.done()
