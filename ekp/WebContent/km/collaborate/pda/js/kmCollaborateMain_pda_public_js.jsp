<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="/third/pda/htmlhead.jsp"%>
<link rel="stylesheet" href="${KMSS_Parameter_ContextPath}km/collaborate/pda/js/jquery.mobile-1.3.1.min.css" />
<script src="${KMSS_Parameter_ContextPath}km/collaborate/pda/js/jquery-1.9.1.min.js"></script>
<script src="${KMSS_Parameter_ContextPath}km/collaborate/pda/js/jquery.mobile-1.3.1.min.js"></script>
<script>
//页面第一次加载的时候图片自适应屏幕图片
function refreshImg(eventType){
	var	bannerWidth=getObjectWidth(document.body);
	//图片预加载、溢出问题。。
	var contentObj= document.getElementById("doc_contentDiv");
	if(contentObj!=null) {
		var imgArr = contentObj.getElementsByTagName("img");
		if(imgArr!=null && imgArr.length>0){
			for(var i=0;i<imgArr.length;i++){
				var oldsrc=imgArr[i].getAttribute("oldsrc");
				if(oldsrc!=null){
					imgArr[i].style.maxWidth=""+(bannerWidth*0.80)+"px";
					imgArr[i].setAttribute("src",oldsrc);
					//避免移动端在预览图片时, 横屏竖屏切换在时候, 重复请求服务器,加载图片.
					if(eventType=='load'){
						Com_AddEventListener(imgArr[i],"load",function(){});
					}
				}else continue;
			}
		}
		
		//andriod2.3等版本下不支持scroll，故通过加事件来处理溢出滑动问题
		var clientInfo =  navigator.userAgent.toLowerCase().match(/android [\d.]+;/gi);
		if(clientInfo!=null){
			clientInfo = clientInfo.toString().replace(/[^0-9.]/ig,'');
			if(clientInfo==null)
				return;
			var ver = parseInt(clientInfo);
			if(ver < 3){//初定andriod3以下版本使用事件滑动
				var divArr = null;
				if(contentObj.querySelectorAll)
					divArr = contentObj.querySelectorAll(".div_overflowArea");
				else
					divArr = contentObj.getElementsByTagName("div");
				if(divArr!=null && divArr.length>0){
					for(var i =0; i<divArr.length; i++){
						var divObj = divArr[i];
						if(divObj.className=='div_overflowArea'){
							touchScroll(divObj);
						}
					}
				}
			}
		}
	}
}
function getObjectWidth(obj){
	var clientWidth=obj.offsetWidth;
	if(clientWidth==null || clientWidth==0)
		clientWidth=obj.clientWidth?obj.clientWidth:clientWidth;
	return clientWidth;
}
function touchScroll(idObj){
	window.scrollStartPosX = -1;
	idObj.addEventListener("touchstart", function(event) {
		window.scrollStartPosX = this.scrollLeft + event.touches[0].pageX;
		event.stopPropagation();
	},false);

	idObj.addEventListener("touchmove", function(event) {
		if(window.scrollStartPosX != -1){
			var pos=(window.scrollStartPosX - event.touches[0].pageX);
			this.scrollLeft = pos;
		}
		event.stopPropagation();
	},false);
}

function refreshImgLoad(){
	refreshImg('load');
}

function refreshImgResize(){
	refreshImg('resize');
}

Com_AddEventListener(window,"load",refreshImgLoad);
Com_AddEventListener(window,"resize",refreshImgResize);
</script>