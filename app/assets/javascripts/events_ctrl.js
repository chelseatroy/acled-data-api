(function(){

  angular.module("app").controller("eventsCtrl", function($scope, $http){

    $http.get('/api/v1/events.json').then(function(response){
      $scope.events = response.data;
    });

    $scope.popUp = function(){
      
    }

  });
})();