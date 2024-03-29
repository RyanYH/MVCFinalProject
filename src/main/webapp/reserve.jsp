<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE HTML>
<html>
  <head>
    <title>MovieSearchApp</title>
	<!-- 화면 확대비율을 기기 사이즈 가로에 맞게 조정 -->	
	<meta name="viewport" content="width=device-width, initial-scale=1.0,maximum-scale=1.0, user-scalable=no" />
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
	<link rel="stylesheet" href="http://code.jquery.com/mobile/1.0b2/jquery.mobile-1.0b2.min.css" />
	<script type="text/javascript" src="http://code.jquery.com/jquery-1.6.2.min.js"></script>
	<script type="text/javascript" src="http://code.jquery.com/mobile/1.0b2/jquery.mobile-1.0b2.min.js"></script>
	<!-- <script type="text/javascript" charset="utf-8" src="phonegap-1.0.0.js"></script> -->
	  
	<style type="text/css">
	  	h1{
	  		text-align: center;
	  		color: green;
	  	}
	  	
	 </style>
	    
	  <script> 
	   $("#[data-role=page]").live("pageshow",function(event) { 

	          if(this.id == "searchonlinepage") { 
	        	  $.mobile.showPageLoadingMsg();
	        	  $.ajax({
					  	type:"GET",
						url: "http://openapi.naver.com/search?key=db13514ebf38ccd279a6b93538f88bca&query=movie&target=ranktheme",
						dataType: "xml",
						success: parseXml
				  });	
				  $("#resultlist2").empty();
	          }
	        
	          function parseXml(xml)
			  	{		  
			  		var i = 1;
			  		var sign ;
			  		for(i=1; i<11; i++)
			  		{
		  				$(xml).find("R"+[i]).each(function()
		  				{
		  					if($(this).find("S").text() == "*")
					  		{
					  			sign = "same.png"	
					  			$("#resultlist2").append("<li><img src='"+ i +".png' class='ui-li-icon'>" + $(this).find("K").text()+"<img src='" + sign +"' data-iconpos='right'></li>");
					  		}
		  					else
		  					{
		  						if ($(this).find("S").text() == "+")
						  		{
						  			sign = "up.png"	
						  		}
						  		else if($(this).find("S").text() == "-")
						  		{
						  			sign = "down.png"
						  		}
					  			$("#resultlist2").append("<li><img src='"+ i +".png' class='ui-li-icon'>" + $(this).find("K").text()+"<img src='" + sign +"'>" + $(this).find("V").text() +"</li>");
		  					}
		  				});	
		  			}
			  		$("#resultlist2").listview('refresh');
			  		$.mobile.hidePageLoadingMsg();


			  	} 
	   });

	   $("#[data-role=page]").live("pageshow",function(event) { 
		   if(this.id == "arroundteatherpage") { 
		   
		   }
	   });
	   
	   
 	  	$(function(){		  
 	  		var loadpage = 1;
 	  		var display = 0;
 	  		var movieName ='';

 	  		function varinit()
 	  		{
 	  			loadpage = 1;
	 	  		display = 0;
	 	  		movieName ='';
			  	
 	  		}
 	  		
 	  		function callAjax()
		  	{
		  		$.ajax({
				  	type:"GET",
					url: "http://openapi.naver.com/search?key=db13514ebf38ccd279a6b93538f88bca&query=" + movieName + "&display=10&start="+ loadpage +"&target=movie" ,
					dataType: "xml",
					success: parseXml2
			  	});
		  	}
 	  		
 	  		$("#callXML").click(function(){
		  		$("#resultlist").empty();
		  		$.mobile.showPageLoadingMsg();
		  		varinit();
	 	  		movieName = $.trim($("#movieName").val());
			  	if(movieName.length > 0)
			  	{
				  	callAjax();
			  	}
			  
			  	else
			  		alert('please input text');
		  	}); 
		  	
		  	$("#resultlist").ajaxError(function(event, request, settings, exception){
			  	//("resultlist").html("Error Calling: " + settings.url + "<br/>HTTP Code: " + request.status);
			  	alert('죄송합니다. 다시 시도하여 주시기 바랍니다.');
		  	});

		  	function parseXml2(xml)
		  	{	
		  		var imgurl = '';
		  		var total = 0;
			  	$(xml).find("item").each(function()
			  	{
			  		if($(this).find("image").text() == '')
			  		{
			  			imgurl = "noimage.png";	
			  		}
			  		else
			  		{
			  			imgurl = $(this).find("image").text();
			  		}
				  	$("#resultlist").append("<li><a href='" + $(this).find("link").text() + "' data-ajax=”false”><img src='" + imgurl + "'><h3>" + $(this).find("title").text() + "</h3><p>" + $(this).find("subtitle").text() + "</p><img src='star.png'>" + $(this).find("userRating").text() + "</a></li>");
			  	});
			  	
			  	total = parseInt($(xml).find("total").text());
			  	if(total > 10)
			  	{
			  		display = parseInt($(xml).find("display").text());
			  		loadpage = loadpage + display;
			  		if(total >= loadpage)
			  		{
			  			$("#resultlist").append("<li id=loadmore data-theme='b'>Load more..</li>");
				  		$("#loadmore").click(function(){
				  			$("#loadmore").remove();
				  			callAjax();
					  	});	
			  		}
			  	}
		  		$("#resultlist").listview('refresh');
		  		$.mobile.hidePageLoadingMsg();
		  	}
	  	}); 
	  </script>
	  
  </head>
  <body> <!-- onload="onLoad();" -->
  	<div data-role="page" id="usersearchpage">
	  	<div data-role="header">
	  		<h1>Naver with Jquery</h1>
	  	</div> 
	  	<div data-role="content">
	  		<div data-role="fieldcontain" id="inputsearch">
	  			<input type="text" id="movieName" value="" autocomplete="on" >
	  			<input id="callXML" type="button" value="Search"/>
	  		</div>
			<div id="result">
				<ul data-role="listview" id="resultlist" data-inset="true" data-split-theme="a">
				</ul>
			</div>
	   	</div>
   		<div data-role="footer" data-position="fixed">
			<div data-role="navbar">
				<ul>
		   			<li id="usersearch"><a href="#" class="ui-btn-active" data-icon="search">영화검색</a></li>
		   			<li id="searchonline"><a href="#searchonlinepage" data-ajax = "false" data-icon="star">실시간순위</a></li>
		   			<li id="reservemovie"><a href="#reservecallpage" data-icon="check">영화예매</a></li>
		   			<li id="arroundteather"><a href="map.html" data-icon="info">주변극장</a></li>
				</ul>
			</div>
		</div> 
   	</div>

   	<div data-role="page" id="searchonlinepage">
	  	
	  	<div data-role="header">
	  		<h1>Naver with Jquery</h1>
	  	</div> 
	  	 
	  	<div data-role="content">
			<div id="result">
				<ul data-role="listview" id="resultlist2" data-inset="true" data-split-theme="a">
				</ul>
			</div>
	   	</div>
   		
   		<div data-role="footer" data-position="fixed">
			<div data-role="navbar">
				<ul>
		   			<li id="usersearch"><a href="#usersearchpage" data-icon="search">영화검색</a></li>
		   			<li id="searchonline"><a href="#" class="ui-btn-active" data-icon="star">실시간순위</a></li>
		   			<li id="reservemovie"><a href="#reservecallpage" data-icon="check">영화예매</a></li>
		   			<li id="arroundteather"><a href="#arroundteatherpage" data-icon="info">주변극장</a></li>
				</ul>
			</div>
		</div> 
   	</div>
   	
   	<div data-role="page" id="reservecallpage">
	  	
	  	<div data-role="header">
	  		<h1>Naver with Jquery</h1>
	  	</div> 
	  	 
	  	<div data-role="content">
			<div id="result">
				<ul data-role="listview" id="tellist" data-inset="true" data-split-theme="a">
				<li data-role="list-divider">전화예매</li>
				<li><a href="tel:15442280">CGV</a></li> 
				<li><a href="tel:15448855"> 롯데시네마</a></li> 
				<li><a href="tel:15440600">메가박스</a></li>
				</ul>
				<br>
				<br>
				<a href="http://ticket.movie.naver.com/Ticket/Reserve.aspx" data-role="button" data-theme="b">네이버 인터넷 예매</a> 
			</div>
	   	</div>
   		
   		<div data-role="footer" data-position="fixed">
			<div data-role="navbar">
				<ul>
		   			<li id="usersearch"><a href="#usersearchpage" data-icon="search">영화검색</a></li>
		   			<li id="searchonline"><a href="#searchonlinepage" data-icon="star">실시간순위</a></li>
		   			<li id="reservemovie"><a href="#" class="ui-btn-active" data-icon="check">영화예매</a></li>
		   			<li id="arroundteather"><a href="#arroundteatherpage" data-icon="info">주변극장</a></li>
				</ul>
			</div>
		</div> 
   	</div>
   	
   	<div data-role="page" id="arroundteatherpage">
	  	
	  	<div data-role="header">
	  		<h1>Naver with Jquery</h1>
	  	</div> 
	  	 
	  	<div data-role="content">
			<div id="result">
				<ul data-role="listview" id="tellist" data-inset="true" data-split-theme="a">
				<li data-role="list-divider">전화예매</li>
				<li><a href="tel:15442280">CGV</a></li> 
				<li><a href="tel:15448855"> 롯데시네마</a></li> 
				<li><a href="tel:15440600">메가박스</a></li>
				</ul>
				<br>
				<br>
				<a href="http://ticket.movie.naver.com/Ticket/Reserve.aspx" data-role="button" data-theme="b">네이버 인터넷 예매</a> 
			</div>
	   	</div>
   		
   		<div data-role="footer" data-position="fixed">
			<div data-role="navbar">
				<ul>
		   			<li id="usersearch"><a href="#usersearchpage" data-icon="search">영화검색</a></li>
		   			<li id="searchonline"><a href="#searchonlinepage" data-icon="star">실시간순위</a></li>
		   			<li id="reservemovie"><a href="#reservecallpage" data-icon="check">영화예매</a></li>
		   			<li id="arroundteather"><a href="#" class="ui-btn-active" data-icon="info">주변극장</a></li>
				</ul>
			</div>
		</div> 
   	</div>
  </body>
</html>

    