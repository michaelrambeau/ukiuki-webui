app.controller 'UserController', ($scope, ResourceUser, $stateParams) ->
	username = $stateParams.username
	ResourceUser.getUserData username, (data) ->
		$scope.galleries = data.galleries
		$scope.user = data.user
	return
