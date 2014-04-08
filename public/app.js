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
  $("#"+number)
    .append(
      "<img class='mark' src='./img/" + mark + ".svg'></img>"
    );
}

$(document).ready(function(){
  setBoardDimensions();
  setSpaceDimensions();
});
$(window).resize(function(){
  setBoardDimensions();
  setSpaceDimensions();
});

