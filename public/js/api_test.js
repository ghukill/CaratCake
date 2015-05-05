// api_test.js


function fireTest(){

	// craft dataObj
	var action = $("#action").val();
	var key = $("#key").val();
	var value = $("#value").val();
	var mime = $("#mime").val();

	var dataObj = {
		"key":key,
		"value":value
	}

	// add mime if present
	if (action == "get" && mime != ""){
		dataObj.mime = mime;
	}

	$.ajax({
	  url: "/"+action,
	  method:"post",
	  data:dataObj
	}).done(function(response) {

	  if (action == "get" && mime != ""){
	  	$("#results_target").html("opened crumb in new window...");	
	  	var window_location = '/get?key='+key+'&mime='+mime
	  	window.open(window_location);
  		return false;
	  }
	  else {
	  	$("#results_target").html(response);	
	  }
	  
	});


}


$(document).ready(function(){
	$( "#action" ).change(function() {
		if ($("#action").val() == "get"){
			$("#value_div").hide();
			$("#mime_div").show();
		}
		else {
			$("#value_div").show();
			$("#mime_div").hide();	
		}
	});	
});
