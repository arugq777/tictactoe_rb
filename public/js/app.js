var spacesClickable = true;
var gameOver = false;

$(document).ready( function(){
  setBoardDimensions();
  setSpaceDimensions();
  $(".space").click( function(){
    //alert($(this).attr('id'));
    if(spacesClickable === true){
      getUserMove($( this ).attr('id'));
    }
  });
  coinToss();
});

$(window).resize( function(){
  setBoardDimensions();
  setSpaceDimensions();
});

$( document ).ajaxStart(function() {
  $( "#loading" ).show();
  spacesClickable = false;
});

$( document ).ajaxStop(function() {
  $( "#loading" ).hide();
  spacesClickable = true;
});


function setBoardDimensions(){
  $(".board").width($(".board").height());
}

function setSpaceDimensions(){
  for(i=1; i <= 9; i++){
    $("#"+i).height($(".board").height()/3);
    $("#"+i).width($(".board").height()/3);
  }
}

function markSpace(number, mark){
  $("#"+number).append(
    "<img class='mark' src='./img/" + mark + ".svg'></img>"
  );
}

function endGame(){
  gameOver = true;
  spacesClickable = false;
}

function isGameOver(){
  return gameOver;
}

function getUserMove(move){
  if(isGameOver() === false){
    $.get( "/"+ move, function( data ) {
      console.log(data);
      if(data.valid === true){
        markSpace(data.space, "o");
        updateInfo(data.output);
        if (data.game_over === true){
          endGame();
        } else {
          getAIMove();
        }
      } else {
        $( "#info" ).append( "<li>" + data.error +"</li>");
        }
    }, "json" );
  }
}

function getAIMove(){
  if(isGameOver() === false){
    $.get( "/ai", function( data ) {
      if(data.valid === true){
        markSpace(data.space, "x");
        updateInfo(data.output);
        if (data.game_over === true){
          endGame();
        }
      } else {
        $( "#info" ).append( "<li>" + data.error +"</li>");
      }
    }, "json" );
  }
}

function updateInfo(info){
  console.log("update:" + info);
  for(i=0; i < info.length; i++){
    $("#info").append("<li>" + info[i] + "</li>");
  }
}

function coinToss(){
  $.get( "/coin_toss", function( data ) {
      updateInfo(data.output);
      if( data.player === "X"){
        getAIMove();
      }
  }, "json" );
}
