angular.module('githubpage',['ngRoute'])
.controller('MainCtrl',['$scope','restapi','tests',
	function($scope,restapi,tests){

		$scope.restapi = restapi;
		$scope.tests = tests;

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
		.when('/caching', {
			templateUrl: 'views/caching.html',
			controller: 'MainCtrl'
		})
		.when('/loadtests', {
			templateUrl: 'views/load.html',
			controller: 'MainCtrl'
		})
		.when('/api', {
			templateUrl: 'views/api.html',
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
.constant('tests',[{item:"t1"},{item:"t2"},{item:"t3"}])

