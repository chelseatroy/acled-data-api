(function(){

  angular.module("app").controller("badminsCtrl", ['$scope', '$http',function($scope, $http){

    $scope.page = 1;

    function getData(){
      $http.get('/api/v1/events?approved=false&page=' + $scope.page).then(function(response){
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
    };

    $scope.aToZ = false;
    $scope.reverseSort = function(string){
      $scope.column = string;
      $scope.aToZ = !$scope.aToZ;
    };

    $scope.popUp = function(){
      
    };

    $scope.approve = function(event){
      // console.log('/api/v1/events/' + id + '/approve');
      $http.post('/api/v1/events/' + event.id + '/approve.json', {}).then(function(response){
        var index = $scope.events.indexOf(event);
        $scope.events.splice(index, 1);

      });
    };

    $scope.deny = function(event){
      $http.post('/api/v1/events/' + event.id + '/deny.json', {}).then(function(response){
        var index = $scope.events.indexOf(event);
        $scope.events.splice(index, 1);
      });
    };
    window.scope = $scope;
  }]);
})();