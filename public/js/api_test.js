// api_test.js


function fireTest(){

	// user feedback
	$("#results_target").html("<span style='color:orange;'>Feverishly working...</span>");	
	$("a.request_url").attr('href',"#");
  	$("span.request_url").html("null");

	// craft dataObj
	var action = $("#action").val();
	var key = $("#key").val();
	var value = $("#value").val();
	var mime = $("#mime").val();
	var value_url = $("#value_url").prop( "checked" );

	var dataObj = {
		"key":key,
		"value":value,
		"value_url":value_url
	}

	// add mime if present
	if (action == "get" && mime != ""){
		dataObj.mime = mime;
	}

	// build req_url
	var req_url = buildReqUrl(action,key,value,mime,value_url);

	$.ajax({
	  url: "/"+action,
	  method:"post",
	  data:dataObj
	}).done(function(response) {

	  if (action == "get" && mime != ""){
	  	$("a.request_url").attr('href',req_url);
	  	$("span.request_url").html(req_url);
	  	$("#results_target").html("opened crumb in new window...");	
	  	var window_location = '/get?key='+key+'&mime='+mime
	  	window.open(window_location);
  		return false;
	  }
	  else {
	  	$("a.request_url").attr('href',req_url);
	  	$("span.request_url").html(req_url);
	  	$("#results_target").html(response);	
	  }
	  
	}).fail(function(response){
		$("#results_target").html("<span style='color:red;'>An error was had...</span>");	
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

// function to build req_url
function buildReqUrl(action,key,value,mime,value_url){
	// build request URL
  	var req_url = '/'+action+'?key='+key;

  	if (value != ""){
  		req_url += '&value='+value;
  	}

  	if (mime != ""){
  		req_url += '&mime='+mime;
  	}

	req_url += '&value_url='+value_url;

	return req_url;
}
