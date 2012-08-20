module.exports =
	
	# Counts the total number of impressions per test
	populations : {}

	# Contains the test-cases by userId
	previous : {}

	test : (name, testCases, options) ->
		#Ensure that we have options available
		options = options || {}
		
		# Stickyness - check if the user has
		# already been subjected to the test, 
		# and return the previous value
		if (previous = this.getPrevious name, options) != null
			return previous
		
		# Increment the population-counter for this test
		this.incrementPopulation name
		
		#The case to use when test is inactive
		defaultCase = testCases[0]

		# Check if the test is active
		# by checking the dates and if the population has already been reached
		if (this.isInactive options) || (this.populationReached name, options)
			return defaultCase.name

		# Get the case that will be showed to the user
		res = this.getTestCase testCases
		
		# Persist the test-results for this specific user
		this.setPrevious name, options, res

		return res
	

	# The counter will keep track of the number of items left in the loop.
	# As we go through the list, the probability will increase. 
	getTestCase : (cases) ->
		counter = cases.length
		for testCase in cases
			probability = 1/counter--
			random =  Math.random() 
			if random < probability
				return testCase.name

	ensurePrevious : (name) ->
		if !this.previous[name]
			this.previous[name] = {}

	getPrevious : (name, options) ->
		this.ensurePrevious name

		if options.user && this.previous[name][options.user]
			return this.previous[name][options.user]
		return null

	setPrevious : (name, options, res) ->
		this.ensurePrevious name
		
		if options.user 
			this.previous[name][options.user] = res

	incrementPopulation : (name) ->
		if(!this.populations[name])
			this.populations[name] = 0
		this.populations[name]++


	populationReached : (name, options) ->
		options.population && this.populations[name] >= options.population

	isInactive : (options) ->
		options.startDate > new Date() || options.endDate < new Date()