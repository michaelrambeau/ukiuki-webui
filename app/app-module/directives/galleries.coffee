app.directive 'galleryGridItem', () ->
	restrict: 'AE'
	scope:
		gallery: "=data"
	controller: ($scope) ->
		$scope.getThumbnailUrl = (gallery) ->
			if not gallery.image? then return ""
			url = gallery.image.url
			re = /\/v\d*\//
			url.replace re, "/t_ukiuki2/"
	template: '''
		<img
			class="img-responsive gallery"
			src="images/gallery.gif"
			ng-src="{{getThumbnailUrl(gallery)}}"
			alt="{{gallery.title}}")>
	'''
