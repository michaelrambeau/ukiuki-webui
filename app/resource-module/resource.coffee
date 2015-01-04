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
	api

resource.factory 'ResourceUser', ($http, UkiUkiAPI) ->
	api =
		getFeatured: (cb) ->
			$http.get(UkiUkiAPI() + "/api/user/featured").success (data) ->
				cb data
		getCurrentUserData: (cb) ->
			$http.get(UkiUkiAPI() + "/api/user-data").success (data) ->
				cb data
	api
