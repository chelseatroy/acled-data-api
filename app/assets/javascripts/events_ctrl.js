(function(){

  angular.module("app").controller("eventsCtrl", ['$scope', '$http', function($scope, $http){

    $scope.page = 1;

    function getData(){
      $http.get('/api/v1/events?page=' + $scope.page).then(function(response){
        $scope.events = response.data;
      });
    };

    getData();

    $scope.next = function(click){
      if(click === "next"){
        $scope.page ++; 
        getData();
      } else if(click === "prev" && $scope.page > 1){
        $scope.page --;
        getData();
      }else{
        $scope.page = 1; 
      }
    }

    $scope.aToZ = false;
    $scope.reverseSort = function(string){
      $scope.column = string;
      $scope.aToZ = !$scope.aToZ;
    }

    $scope.popUp = function(){
      
    }

  }]);
})();