$sidebar = undefined
$searchbar = undefined
$loginBlock = undefined
$loginCloseBar = undefined

if false then $(document).ready ->

	$searchbar = $(".uki-navbar")
	$loginBlock = $("#login-block")
	$loginCloseBar = $(".leftbar,.topbar")
	$loginBlock.on "show.bs.collapse", ->
		$searchbar.hide()
		return

	$loginBlock.on "shown.bs.collapse", ->
		$loginBlock.find("input:first").focus()
		return

	$loginBlock.on "hide.bs.collapse", ->
		$searchbar.show()
		return

	$loginCloseBar.click ->
		$loginBlock.collapse "hide"
		return

	$sidebar = $(".ui.sidebar")
	$sidebar.sidebar
		debug: true
		overlay: false
	$(".filter-bar-toggle").click ->
		$sidebar.sidebar "toggle"
		return

app.controller "ContentController", ($scope, $ionicSideMenuDelegate) ->
	console.info 'ContentController start!'
	$scope.toggleLeft = ->
		console.info $scope
		$ionicSideMenuDelegate.toggleLeft($scope)
		return
	return


app.controller "MainController", ($scope, $state, ResourceUser, $http, $rootScope, ResourceGallery, SharedState) ->
	console.log "Main controller"

	#Put focus on the username field when the login block is displayed
	$scope.$on 'mobile-angular-ui.state.changed.loginBlock', (e, newVal, oldVal) ->
		#$loginBlock = $("#login-block")
		#if newVal is true then $loginBlock.find("input:first").focus()
		console.info newVal
		return

	$scope.currentUser = null

	$scope.getUserData = ->
		ResourceUser.getCurrentUserData (data) ->
			console.info "Connected user", data.user
			if data.user?
				$scope.currentUser = data.user
				$scope.$broadcast 'authenticated'

	#get data about the current user
	$scope.getUserData()

	$scope.isLoggedin = ->
		$scope.currentUser?

	$scope.signout = ->
		$http.post("/api/signout").success((data) ->
			$scope.currentUser = null
			console.log "Disconnected."
			$state.go("browse")
			return
		).error (data) ->
			console.log "Sign out error!"
			return

		return

	#Listen for events from child scopes and broadcast to other child scopes
	events = [
		"signup-submission"
		 "signin-submission"
		"upload"
	]

	for event in events
		$scope.$on event, (ev, data) ->
			# PREVENT INFINITE LOOP ON BROADCAST
			return	if ev.targetScope is $scope
			console.log "MainController on event", ev.name
			$scope.$broadcast ev.name, data
			return

	$scope.$on "login", (ev, data) ->
		console.info data.user, 'is logged-in.'
		$scope.currentUser = data.user
		#$loginBlock.collapse "hide"
		SharedState.toggle 'loginBlock'
		$state.go 'mypage.galleries'

	ResourceUser.getFeatured (data) ->
		$scope.featuredUsers = data.users

	findCategory = (code) ->
		found = null
		$scope.categories.forEach (cat) ->
			found = cat	if code is cat.value
			return
		found

	console.log "BrowseController"
	$scope.galleries = []
	i = 0

	while i < 10
		$scope.galleries.push title: i
		i++
	console.log $scope.galleries.length
	$scope.loading = true


	$scope.searchFilter = (item) ->
		titleFilter = new RegExp($scope.search.text, "i").test(item.title)
		descriptionFilter = RegExp($scope.search.text, "i").test(item.description)
		#categoryFilter = ($scope.search.category is "*") or (item.category is $scope.search.category)
		categoryFilter = ($scope.search.categories.length == 0) or (findCategory(item.category).isSelected is true)
		categoryFilter and (titleFilter or descriptionFilter)

	$scope.formatDate = (source) ->
		dateOnly = source.split(" ")[0]
		ymd = dateOnly.split("-")
		moment(new Date(ymd[0], ymd[1], ymd[2])).fromNow()

	$rootScope.categories = []
	$scope.search =
		category: "*"
		categories: []
		text: ""

	getStatsByCategory = ->
		ResourceGallery.getStatsByCategory (data) ->
			data.categories.forEach (cat) ->
				found = findCategory(cat._id)
				found.total = cat.total	if found
				return

			return

		return

	$scope.setCategory = (id) ->
		$scope.search.category = id

	$scope.toggleCategory = (category) ->
		category.isSelected = ! category.isSelected
		$scope.search.categories = []
		for cat in $rootScope.categories
			if cat.isSelected is true then $scope.search.categories.push category

	$scope.toggleFilter = () ->
		if $scope.search.categories.length is 0
		else
			$scope.search.categories = []
			cat.isSelected = false for cat in $rootScope.categories


	ResourceGallery.getFeatured (data) ->
		$scope.galleries = data.galleries
		$rootScope.categories = data.categories
		angular.forEach $scope.categories, (category) ->
			category.isSelected = false
		console.info $scope.galleries.length, "items loaded"
		getStatsByCategory()
		$scope.loading = false
		return


	return
