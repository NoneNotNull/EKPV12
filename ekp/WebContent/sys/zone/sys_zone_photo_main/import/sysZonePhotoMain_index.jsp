<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<link rel="stylesheet" type="text/css"
			href="${ LUI_ContextPath}/sys/zone/sys_zone_photo_main/import/resource/index.css" />
<c:set var="sourceId" value="${not empty param.sourceId ? param.sourceId : 'newperson'}"></c:set>
<c:set var="templateId" value="${not empty param.templateId ? param.templateId : ''}"></c:set>
<img src="${ LUI_ContextPath}/sys/zone/sys_zone_photo_main/sysZonePhotoMain.do?method=loadMap&fdKey=spic&sourceId=${sourceId}&templateId=${templateId}"  
	 alt="" usemap="#hy_map" id="hy_img">
<div id="map_conetent"></div>
<%-- 
<script>
	seajs.use(['lui/jquery'] , function($) {
			$.ajax({
	        	url: "<c:url value='/sys/zone/sys_zone_photo_main/sysZonePhotoMain.do'/>?method=loadMap",
	        	dataType: "text",
	        	data : "fdKey=html&sourceId=${sourceId }&templateId=${templateId}",
	        	success: function(data,textStatus) {
		        	if(data) {
		              $("#map_conetent").append(data);
		              $("#map_conetent").find("map").attr({"name":"hy_map", "id":"hy_map"});
		              bindHover();
		        	}
	            },
	            error: function(request, textStatus, errorThrown) {
	            	
	            }
	        });

	        function bindHover() {
	                 $("area").each(function () {
	                     var $x = 10;
	                     var $y = -20;
	                     var url = $(this).attr("data-img");
	                     var txt = "";
	                     var timer;
	                     $(this).mouseover(function (e) {
	                        timer = setTimeout(function() {
		                         var dom = "<div class='mapDiv'><img src=${LUI_ContextPath}/sys/zone/sys_zone_photo_template/resource/" + url.substring(11) +" alt=''></div>";
		                         $("body").append(dom);
		                         $(".mapDiv").css({
		                             top: (e.pageY + $y) + "px",
		                             left: (e.pageX + $x) + "px"
		                         }).show("fast");
	                        },100);
	                     }).mouseout(function () {
		                     if(timer) 
		                    	clearTimeout(timer);
	                         $(".mapDiv").remove();
	                     }).mousemove(function (e) {
	                         $(".mapDiv").css({
	                             top: (e.pageY + $y) + "px",
	                             left: (e.pageX + $x) + "px"
	                         });
	                     });
	                 });
		     }
		});
</script>
--%>

<script>
	seajs.use(['lui/jquery'] , function($) {
		var _tmp = new Date().getTime();
			$.ajax({
	        	url: "<c:url value='/sys/zone/sys_zone_photo_main/sysZonePhotoMain.do'/>?method=loadMap",
	        	dataType: "text",
	        	data : "fdKey=html&sourceId=${sourceId }&templateId=${templateId}",
	        	success: function(data,textStatus) {
	              $("#map_conetent").append(data);
	              $("#map_conetent").find("map").attr({"name":"hy_map", "id":"hy_map"});
	              if(Com_Parameter.IE) {
	             	 bindHoverIE();
	              }else {
	            	  bindHover();
		           }
	            },
	            error: function(request, textStatus, errorThrown) {
	            	
	            }
	        });

			 function bindHoverIE() {
				 var timer;
                 $("#hy_map").mouseover(function (e) {
                     var target = e.target, $target = $(e.target);
                     if(!$target.is("area")) 
                         return;
                      var url = $target.attr("data-img");
	                   var pos = $target.attr("coords").split(",");
	                   var href = $target.attr("href");
	                   var top =   $("#hy_img").offset().top + parseInt(pos[1]) ;
	                   var left =   $("#hy_img").offset().left + parseInt(pos[0]) ;
	                   var width = parseInt(pos[2]) - parseInt(pos[0]);
	                   var height = parseInt(pos[3]) - parseInt(pos[1]);
	     				
	                  //<img src=${LUI_ContextPath}/sys/zone/sys_zone_photo_template/resource/" + url.substring(11) +" alt=''>
                        timer = setTimeout(function() {
	                        
								var dom = "<div onclick='window.open(\"${LUI_ContextPath}" +  href +"\");' class='lui_img_conetnt' style='cursor:pointer;display:block;position:absolute;z-index: 10;top:" 
									      + top + "px;left:" + left + "px;width:" + width +"px;height:" + height+"px'>" +
									      "<img width='100%' height='100%' src='" +url + "&_tmp=" + _tmp +"'></div>"
									      +"<a target='_blank' class='lui_img_conetnt' href='${LUI_ContextPath}" + href +"' style='display:block;border:1px solid #fff;z-index: 25;position:absolute;width:" + (width -2) + "px;height:" + (height-2)+"px;top:" + top +"px;left:" + left +"px;'></a>";
						        var $dom = $(dom);
						        $("body").append($dom);
						
						        $dom.mouseover(function() {
						        	$dom.eq(0).animate({
	                        		 			  top:(top - (height)/2) + "px",
	                        		 			  left:(left - (width)/2) + "px",
                        			              //"background-size":w_2+"px",
	                        		              width:2*(width )+"px", 
	                        		              height:2*(height ) + "px" }, 500);
						        	$dom.eq(1).animate({
                       		 			  top:(top - (height)/2) + "px",
                       		 			  left:(left - (width)/2) + "px",
                   			              "border-width":"2px",
                       		              width:(2*(width) - 4)+"px", 
                       		              height:(2*(height)  - 4 )+ "px" }, 500);
	                         });
						     $dom.mouseout(function() {
								$dom.first().css({"z-index":"3"}).animate({
                  		 			  	top:top  + "px",
                  		 			  	left:left+ "px",
              			             	 //"background-size":w_2+"px",
                  		             	 width:width +"px", 
                  		             	 height:height  + "px" }, 500);
								$dom.last().css({"z-index":"6"}).animate({
			                  		 			  top:top + "px",
			                  		 			  left:left + "px",
			              			              "border-width":"1px",
			                  		              width:(width - 2)+"px", 
			                  		              height:(height  - 2 )+ "px" }, 500, function(){$dom.remove();});
		                         }
			                 );
                     }, 100);
				}).mouseout(function(e) {
					if(!$(e.target).is("area")) 
                        return;
					if(timer) {
						clearTimeout(timer);
					}
                });
		}

			 function bindHover() {
				 var timer;
                 $("#hy_map").mouseover(function (e) {
                     var target = e.target, $target = $(target);
                   
                     if(!$target.is("area")) 
                         return;
                      var url = $target.attr("data-img");
                      var href = $target.attr("href");
	                   var pos = $target.attr("coords").split(",");
	                   var top =   $("#hy_img").offset().top + parseInt(pos[1]) ;
	                   var left =   $("#hy_img").offset().left + parseInt(pos[0]) ;
	                   var width = parseInt(pos[2]) - parseInt(pos[0]);
	                   var height = parseInt(pos[3]) - parseInt(pos[1]);
	                  //<img src=${LUI_ContextPath}/sys/zone/sys_zone_photo_template/resource/" + url.substring(11) +" alt=''>
                        timer = setTimeout(function() {
	                         if(!target['_img']) {
	                        	 var dom = "<a href='${LUI_ContextPath}" + href + "' class='lui_sys_zone_photo_img' style='border:1px solid #fff;position:absolute;z-index: 1001;top:" 
			                         		+ top + "px;left:" + left +"px;width:" + (width -2) + "px;height:" + (height -2)
			                        		 +"px;background:url(" 
			                        		 + url + "&_tmp="+ _tmp + ") no-repeat center;background-size:"+ width +"px " + height  +"px' target='_blank'></a>";
							     var $dom = $(dom);
							     target['_img'] = $dom;
		                         $("body").append($dom);
	                         }
	                         target['_img'].show();
	                         target['_img'].mouseout(function() {
		                         var t = setTimeout(function() {
		                        	   target['_img'].hide();
		                        	 	clearTimeout(t);
			                        }, 600);
		                      });
                       }, 100);
				}).mouseout(function(e) {
					if(!$(e.target).is("area")) 
                        return;
					if(timer) {
						clearTimeout(timer);
					}
                });
		}
	});

</script>
