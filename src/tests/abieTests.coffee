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
	testName = Math.random()
	aCount = 0
	bCount = 0
	testCount = 10000
	halfTestCount = testCount / 2
	# How big errors we will tolerate
	error = (0.02 * testCount)
	limitLow = halfTestCount - error
	limitHigh = halfTestCount + error
	cases = [{name : optionA}, {name: optionB}]
	for i in [1..testCount]
		res = abie.test testName, cases
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
	testName = Math.random()

	startDate = Date.now() - 100
	endDate = Date.now() - 50
	testCount = 1000 
	cases = [
				{name : optionA}, 
				{name : optionB}]
	options = {
				startDate : startDate, 
				endDate : endDate
	}
	for i in [1..testCount]
		res = abie.test testName, cases, options
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

	cases = [{name : optionA}, {name: optionB}]
	options = {
				startDate : startDate,
				endDate : endDate
	}
	
	for i in [1..testCount]
		res = abie.test testName, cases, options
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
	testName = Math.random()
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

#Ensures that the result of a test is sticky to the 
#supplied user
exports.abStickyness = (test) ->
	optionA = "OptionA"
	optionB = "OptionB"
	testName = Math.random()
	cases = [{name : optionA}, {name: optionB}]
	
	for i in [1..100]
		options = {user : i}
		res = abie.test testName, cases, options
		for j in [1..100]
			followUp = abie.test testName, cases, options 
			test.equal followUp, res

	test.done()

# Allows the consumer to add middleware for persistance of stickyness variables
exports.stickynessPersistanceMiddleware = (test) ->
	optionA = "OptionA"
	optionB = "OptionB"
	testName = Math.random()
	cases = [{name : optionA}, {name: optionB}]
	previous = null
	fakePrevious = "FAKE"

	setPrevious = (user, testName, value) ->
		previous = value
	getPrevious = (user, testName) ->
		if previous == null
			return previous
		else
			return fakePrevious

	options = {user : 1, setPrevious : setPrevious, getPrevious : getPrevious}
	res = abie.test testName, cases, options
	test.equal previous, res, "Initial result failed"
	for j in [1..10]
		res = abie.test testName, cases, options
		test.equal res, fakePrevious
		

	test.done()

# Ensures that stickiness is unique to test-name, not global
exports.abStickynessMultiple = (test) ->
	optionA = "OptionA"
	optionB = "OptionB"
	optionA1 = "OptionA1"
	optionB2 = "OptionB2"
	testNameA = Math.random()
	testNameB = Math.random()
	casesA = [{name : optionA}, {name: optionB}]
	casesB = [{name : optionA1}, {name: optionB2}]
	
	for i in [1..100]
		options = {user : i}
		abie.test testNameA, casesA, options

	for i in [1..100]
		options = {user : i}
		res = abie.test testNameB, casesB, options
		test.notEqual res, optionA
		test.notEqual res, optionB

	test.done()

exports.trackGoal = (test) ->
	optionA = "optionA"
	optionB = "optionB"
	testName = Math.random()
	cases = [{name : optionA}, {name: optionB}]
	user = "Julian"
	options = {user : user}
	res = abie.test testName, cases, options
	abie.trackGoal testName, options
	stats = abie.getStats testName
	test.equal stats.cases[0].name, res
	test.equal stats.cases[0].goals, 1
	test.done()


