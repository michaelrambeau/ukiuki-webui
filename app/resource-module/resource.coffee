resource = angular.module('resource', [])

resource.constant 'APIHosts',
	'local': "http://localhost:3000"
	'heroku': "http://ukiukiart.herokuapp.com"

resource.service 'UkiUkiAPI', (APIHosts) ->
	f = () ->
		APIHosts.heroku
	f


resource.factory 'ResourceGallery', ($http, UkiUkiAPI) ->
	api =
		getFeatured: (cb) ->
			$http.get(UkiUkiAPI() + "/api/featured-items").success (data) ->
				cb data
		getStatsByCategory: (cb) ->
			$http.get(UkiUkiAPI() + "/api/stats").success (data)	->
				cb data
		getUserGalleries: (id, cb) ->
			$http.get(UkiUkiAPI() + "/api/user-galleries/" + id).success (data)	->
				cb data
	api

resource.factory 'ResourceUser', ($http, UkiUkiAPI) ->
	api =
		getFeatured: (cb) ->
			$http.get(UkiUkiAPI() + "/api/user/featured").success (data) ->
				cb data
		getCurrentUserData: (cb) ->
			$http.get(UkiUkiAPI() + "/api/user-data").success (data) ->
				cb data
		getUserData: (username, cb) ->
			$http.get(UkiUkiAPI() + '/api/user-data/' + username).success (data) ->
				cb data
		login: (formData, cbSuccess, cbError) ->
			q = $http
				url: UkiUkiAPI() + "/api/signin"
				method: "POST"
				data: formData
				showLoading: true
			q.success (data) ->
				cbSuccess data
				return
			q.error (data) ->
				cbError
				return
	api


