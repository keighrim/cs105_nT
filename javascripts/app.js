angular.module('githubpage',['ngRoute'])
.controller('MainCtrl',['$scope','restapi',
	function($scope,restapi){

		$scope.restapi = restapi;

		$scope.expand = function(list_items){
			if (list_items.show==true) {
				list_items.show=false;
			} else {
				list_items.show=true
			}
		}
	}
])
.config(function ($routeProvider) {

		$routeProvider
		.when('/about', {
			templateUrl: 'views/about.html',
   			controller: 'MainCtrl'
		})
		.when('/routes', {
			templateUrl: 'views/routes.html',
			controller: 'MainCtrl'
		})
		.when('/team', {
			templateUrl: 'views/team.html',
			controller: 'MainCtrl'
		})
		.when('/license', {
			templateUrl: 'views/license.html',
			controller: 'MainCtrl'
		})
		.otherwise({
   			redirectTo: '/about'
 		});
	})
.constant('restapi',[{content:"GET /tweets?:tweet_id"},
		{content:"POST /tweets?:user_id"},
		{content:"GET /tweets/recent"},
		{content:"GET /users?:user_id"},
		{content:"POST /users?:name&:email"},
		{content:"PUT /users?:id"},
		{content:"GET /users/:user_id/tweets"},
		{content:"GET /users/:user_id/followers"}])

