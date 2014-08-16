(function(){

  angular.module("app").controller("eventsCtrl", function($scope, $http){

    $http.get('/api/v1/events.json').then(function(response){
      $scope.events = response.data;
    });

    $scope.aToZ = false;
    $scope.reverseSort = function(string){
      $scope.column = string;
      $scope.aToZ = !$scope.aToZ;
    }

    $scope.popUp = function(){
      
    }

  });
})();