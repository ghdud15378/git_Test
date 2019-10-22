<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
	<title>Home</title>
	<script src="http://code.jquery.com/jquery-1.11.2.min.js"></script>
	<script src="http://code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
</head>
<body>
<div class="dash_box" style="border:1px solid;cursor:pointer;">
<div class="device_id" data="63">기기 ID : 63</div>
<div class="page" data="0">page : 0</div>
<div class="size" data="10">size : 10</div>
<div class="sort" data="timestamp,desc">sort : timestamp,desc</div>
</div>
<div id="logbox" style="cursor:pointer;">

</div>

</body>
</html>

<script>

//외부에서 받아오는 데이터
var device_id = 0; 		//기기ID
var page = 0;				//페이지인덱스
var size = 0;				//한페이지당크기
var sort = "";//정렬기준필드값,오름차순or내림차순


var timestamp;				//변환할 타임스테프의 값
var date = new Date();		//날자객체
var response;				//서버에서 내려받은 제이슨값
var count = 0;				//0<size까지를 세주는 수
var promise;



$("#logbox").on("click", function(){
	$(".dash_box").css("display","block");
	$("#logbox").css("display","none");
	});

$(".dash_box").on("click", function(){
	device_id = $(this).find(".device_id").attr("data");
	page = $(this).find(".page").attr("data");
	size = $(this).find(".size").attr("data");
	sort = $(this).find(".sort").attr("data");
	dashboard();
	$(".dash_box").css("display","none");
	$("#logbox").css("display","block");
});

function dashboard(){
	
	promise = new Promise(function(resolve,reject){

	//비동기 아작스 호출  
	$.ajax({
	    url :"https://naim.ai/api/device_logs?device_id="+device_id+"&page="+page+"&size="+size+"&sort="+sort+"", // 요기에
		async: true,
	    type : 'GET',   
	    success : function(log_dt) {
	    	resolve(log_dt);		// 성공시 resolve로 데이터를 보냄
	  	}    
	,
	    error : function(data) {
	   		 reject("서버 연동이 실패함");
	    }
	});	
});
	
	//서버 전송 성공의 경우 - 가져온데이터를 제이슨 데이터로 변환함
	promise.then(function(resolve){
		response = resolve; 				//성공시 데이터 제이슨으로 변환
		response = JSON.parse(response);
		});
		

	//서버 전송 성공의 경우 - 로그별로 나뉘어 html에 뿌려짐
	promise.then(function(){	
		count = response.content.length;	// 가져온 데이터의 전체 리스트 크기
		$("#logbox").html("");
		for(var i=0;i<count;i++){
			timestampC(i);		 // 모든 로그 유형에 들어가는 타임스템프 변환
		if(response.content[i].channel == null){		 // 채널명이 없는경우
				log_data2(i);
	    		continue;
			}
		else log_data1(i);							// 채널명이 존재하는 경우
		//	Type = type  채널이름 =channel.name 채널번호 = channel.number Scene = scene.name
		}  	
	});
	
}

//타입스템프 변환
function timestampC(index){
	timestamp=response.content[index].timestamp;
	date.setTime(timestamp);	
}

//log 유형1
function log_data1(index){
		$("#logbox").html($("#logbox").html()+
			"<div class='log' data='1'>"+
			"<div class='type'>Type : "+response.content[index].type+"</div>"+
			"<div class='channel_name'>채널이름 : "+response.content[index].channel.name+"</div>"+
			"<div class='channel_number'>"+"채널번호 : "+response.content[index].channel.number+"</div>"+
			"<div class='scene'>Scene : "+response.content[index].scene.name+"</div>"+
			"<div class='time'>"+
			(Number(date.getMonth())+1)+"/"+date.getDate()+" "+date.getHours()+"시 "+date.getMinutes()+"분 "+date.getSeconds()+"초 "+
			"</div></div><br>");	
}

//log 유형2
function log_data2(index){
		$("#logbox").html($("#logbox").html()+
    		"<div class='log' data='2'>"+
    		"<div class='type'>Type : "+response.content[index].type+"</div>"+
    		"<div class='time'>"+
			(Number(date.getMonth())+1)+"/"+date.getDate()+" "+date.getHours()+"시 "+date.getMinutes()+"분 "+date.getSeconds()+"초"
			+"</div></div><br>");
}

</script>