module.exports =
	
	populations : {}

	test : (name, testCases, options) ->
		# Increment the population-counter for this test
		this.incrementPopulation name
		
		#Ensure that we have options available
		options = options || {}
		
		#The case to use when test is inactive
		defaultCase = testCases[0]

		# Check if the test is active
		if (this.isInactive options) || (this.populationReached name, options)
			return defaultCase.name

		# The counter will keep track of the number of items left in the loop
		# As we go through the list, the probability will increase. 
		counter = testCases.length
		for testCase in testCases
			probability = 1/counter--
			random =  Math.random() 
			if random < probability
				return testCase.name
	
	incrementPopulation : (name) ->
		if(!this.populations[name])
			this.populations[name] = 0
		this.populations[name]++


	populationReached : (name, options) ->
		options.population && this.populations[name] >= options.population

	isInactive : (options) ->
		options.startDate > new Date() || options.endDate < new Date()