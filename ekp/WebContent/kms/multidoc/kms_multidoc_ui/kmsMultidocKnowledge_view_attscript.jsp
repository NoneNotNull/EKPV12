<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
var that = this;
var imgList = new Array();
var picPageNum = 1;
var picPageSize = 0;
var picItem = 0;
var idLists = new Array();//所有可在播放器播放的文件集合
var showedBorder = "#35a1d0 2px solid";
var noshowBorder = "#f0f0f0 2px solid";
var liId = 0;//缩略图li的id
//大图左右箭头
var leftUrl =  'url("http://'+window.location.host+'${KMSS_Parameter_ContextPath}kms/multidoc/kms_multidoc_ui/style/img/pic_prev.cur"),auto';
var rightUrl = 'url("http://'+window.location.host+'${KMSS_Parameter_ContextPath}kms/multidoc/kms_multidoc_ui/style/img/pic_next.cur"),auto';
//灰色左箭头
var leftUrl_gray = 'url("http://'+window.location.host+'${KMSS_Parameter_ContextPath}kms/multidoc/kms_multidoc_ui/style/img/pic_prev_gray.cur"),auto';
/**
 * 附件预览
 */ 
var imgDisplayW = null;//播放器宽度
function Attachment_ShowList(attObj) {
		imgDisplayW = $("#imgInfo").width();
		var isMSIE = navigator.userAgent.indexOf("MSIE") > 0;//IE浏览器
		if(isMSIE){
			imgDisplayW = imgDisplayW -10;
		}
		var videoEnable  = "${videoEnabled}"; 
		var htmlEnabled  = "${htmlEnabled}";
		var showDiv = document.createElement("div");
		var len = attObj.fileList.length;
		$("#imgDiv").width(imgDisplayW*len);//初始化幻灯片宽度
		for(var i=0;i<len;i++) {
			var doc = attObj.fileList[i];
			var fileExt = doc.fileName.substring(doc.fileName.lastIndexOf("."));
			if(attObj.fileList[i].fileStatus > -1 && (attObj.fileList[i].fileType=="image/jpeg" ||attObj.fileList[i].fileType=="image/gif"||attObj.fileList[i].fileType=="image/bmp"||attObj.fileList[i].fileType=="image/png")) {
				that.picItem++;
			    var div=GetLinkDiv(attObj, attObj.fileList[i]) ;
			    if(picItem==2){
			    	showBigImg(attObj.fileList[i].fdId,"2");
				}else if(picItem==3){
			    	showBigImg(attObj.fileList[i].fdId,"3");
				}
			    if(div!=""){
				 	showDiv.appendChild(div );
				 }
			    idLists.push(attObj.fileList[i]);
			}else if(attObj.fileList[i].fileStatus > -1 &&  (attObj.fileList[i].fileType.indexOf("audio/mpeg")>-1)){
				that.picItem++;
				if(picItem==2){
					showBigMp3(attObj.fileList[i].fdId,"2");
				}else if(picItem==3){
					showBigMp3(attObj.fileList[i].fdId,"3");
				}
				GetMp3Div(attObj, attObj.fileList[i]) ;
				idLists.push(attObj.fileList[i]);
			}else if(attObj.fileList[i].fileStatus > -1 && (attObj.fileList[i].fileType.indexOf("video")>-1 || attObj.fileList[i].fileType.indexOf("audio")>-1 )){
				if(videoEnable && videoEnable=="true"){
					that.picItem++;
					if(picItem==2){
						showBigVideo(attObj.fileList[i].fdId,"2");
					}else if(picItem==3){
						showBigVideo(attObj.fileList[i].fdId,"3");
					}
					GetVideoDiv(attObj, attObj.fileList[i]) ;
					idLists.push(attObj.fileList[i]);
				}
			}else if(attObj.fileList[i].fileStatus > -1 && File_EXT_READ.indexOf(fileExt.toLowerCase()) > -1){
				if(htmlEnabled && htmlEnabled=="true"){
					that.picItem++;
					if(picItem==2){
						showBigDoc(attObj.fileList[i].fdId,"2");
					}else if(picItem==3){
						showBigDoc(attObj.fileList[i].fdId,"3");
					}
					GetDocDiv(attObj, attObj.fileList[i]) ;
					idLists.push(attObj.fileList[i]);
				}
			} 
		}
		if(len>0){
			that.picPageSize = that.picItem%7==0?that.picItem/7:Math.ceil(that.picItem/7);
		}
		$("#picListItem li:eq(0) div:first").css("border",showedBorder);//为第一个缩略图加蓝色边框

		//根据可播放附件数设置相同数量的大图的div
		for(var i=4;i<=picItem;i++){ 
			var div_box = document.createElement("div");
			div_box.id = "bigImg"+i; 
			div_box.setAttribute('style','float:left;');
			$("#bigImg"+(i-1)).after(div_box);
		} 
		//添加切换附件播放的箭头,当只有一个附件时，不加导向箭头
		if(idLists.length!=1){
			$(".insignia_left")[0].style.cursor=leftUrl;
			$(".insignia_right")[0].style.cursor=rightUrl;
		}else{
			$(".insignia_left").hide();
			$(".insignia_right").hide();
		}
		//播放第一个附件时，大图的左箭头为灰色
		var leftSize = $("#imgDiv")[0].style.left; 
		if(leftSize.substring(0,leftSize.length-2)>=0&&idLists.length!=1){
			$(".insignia_left")[0].style.cursor=leftUrl_gray;
		}

		//去掉缩略小图左右箭头
		if(idLists.length<=7){
			$(".img_small_btnl").addClass("noclick");
			$(".img_small_btnr").addClass("noclick");
		}
}

function GetVideoDiv( attachmentObject, doc,index){
	if(doc.fileType.indexOf("video")>-1 || doc.fileType.indexOf("audio")>-1){
		putVideoBrowser(doc) ;
	}
}
function GetMp3Div( attachmentObject, doc){
	if(doc.fileType.indexOf("audio/mpeg")>-1){
		putMp3Browser(doc) ;
	}
}
function GetDocDiv( attachmentObject, doc){
	putDocBrowser(doc) ; 
} 
function GetSrc(fileName) {
	var src="${KMSS_Parameter_ContextPath}kms/multidoc/resource/img/" ;
	if (fileName != null && fileName.length > 0){
		var doc= '.doc|.docx'.indexOf(fileName.substring(fileName.lastIndexOf(".")).toLowerCase()) > -1;
        if(doc){
            src = src+'doc_default.gif'
        	return src  ;
               }
        var ppt= '.ppt|.pptx'.indexOf(fileName.substring(fileName.lastIndexOf(".")).toLowerCase()) > -1;
        if(ppt){
            src=  src+'ppt_default.gif'
            return  src;
            }
        var txt= '.txt'.indexOf(fileName.substring(fileName.lastIndexOf(".")).toLowerCase()) > -1;
        if(txt){
        	src=src+'txt_default.gif'
            return   src ;
            }
        var xls= '.xls|.xlsx'.indexOf(fileName.substring(fileName.lastIndexOf(".")).toLowerCase()) > -1;
        if(xls){
        	src=src+'xls_default.gif'
            return   src ;
            }
        var img= '.jpg|.jpeg|.png|.gif'.indexOf(fileName.substring(fileName.lastIndexOf(".")).toLowerCase()) > -1;
        if(img){
        	src=src+'img_default.gif'
            return   src ; 
            }
        var pdf= '.pdf'.indexOf(fileName.substring(fileName.lastIndexOf(".")).toLowerCase()) > -1;
        if(pdf){
        	src=src+'pdf_default.gif'
            return   src ; 
            }

        src=src+'default.gif'
        return   src ; 
		}
	  
}
function GetLinkDiv( attachmentObject, doc) {
	 if(doc.fileType.indexOf("image")>-1) {
	    putImgBrowser(doc) ;
	    return "" ;
	 }else{
		var div = document.createElement("div");
		var img= document.createElement("img"); 
		img.src=GetSrc(doc.fileName);//文件类型小图标
		div.appendChild(img);	
		div.appendChild(GetLink(attachmentObject, doc));
		div.align='left'; 
		return div ; 
	}
}
function GetLink(attachmentObject, doc) {
	var a = document.createElement("A");
	a.oncontextmenu = function() {
		return attachmentObject.showMenu(doc);
	};
	a.onclick = a.oncontextmenu;
	a.href = "#";
	a.appendChild(document.createTextNode(doc.fileName));
	return a;
}

function putImgBrowser(obj){
	 imgList.push(obj) ;
	 if(imgList.length==1){ //显示第一个大图
	   showBigImg(obj.fdId,"1") ;
	   document.getElementById("imgBrowser").style.display='table';
	 }
	 appendToImgBrowser(obj) ;
}
function putVideoBrowser(obj){
	 imgList.push(obj) ;
	 if(imgList.length==1){ 
	   showBigVideo(obj.fdId,"1") ;
	   document.getElementById("imgBrowser").style.display='table';
	 }
	 var p='${LUI_ContextPath}';
	 var imgSrc = p+"/sys/attachment/sys_att_main/sysAttMain.do?method=view&filethumb=yes&fdId="+obj.fdId ;
	 var sImgSrc = "${KMSS_Parameter_ContextPath}kms/multidoc/resource/img/vedioicon.jpg";
	 buildBrowser(imgSrc,sImgSrc);
}
function putMp3Browser(obj){
	 imgList.push(obj) ;
	 if(imgList.length==1){ 
	   showBigMp3(obj.fdId,"1") ;
	   document.getElementById("imgBrowser").style.display='table';
	 }

	 var p='${LUI_ContextPath}';
	 var imgSrc = p+"/kms/multidoc/resource/img/musicicon.jpg";
	 var sImgSrc = p+"/kms/multidoc/resource/img/mp3_default.gif";
	 buildBrowser(imgSrc,sImgSrc);
}
function putDocBrowser(obj){
	 imgList.push(obj) ;
	 if(imgList.length==1){ 
	   showBigDoc(obj.fdId,"1") ;
	   document.getElementById("imgBrowser").style.display='table';
	 }

	 var p='${LUI_ContextPath}';
	 var imgSrc = p + '/sys/attachment/sys_att_main/sysAttMain.do?method=view&fdId='+obj.fdId+'&filethumb=yes';
	 var sImgSrc = GetSrc(obj.fileName);
	 buildBrowser(imgSrc,sImgSrc);
}
function showBigVideo(videoId,index){
	//$("#iframeNode iframe").contents().find("body").empty();//清除Iframe,解决IE下报错的问题
	var bi=document.getElementById("bigImg"+index) ;
	bi.innerHTML="<div id='iframeNode'><iframe src='${KMSS_Parameter_ContextPath }sys/attachment/sys_att_main/sysAttMain.do?method=view&fdId="+videoId+"&viewer=video_viewer' name='mainFrame' id='mainFrame'  width='"+imgDisplayW+"' height='565' frameborder=no scrolling='no'style='z-index:3'></iframe></div>";
}
function showBigMp3(videoId,index){
	//$("#iframeNode iframe").contents().find("body").empty();//清除Iframe,解决IE下报错的问题
	var bi=document.getElementById("bigImg"+index) ;
	bi.innerHTML="<div id='iframeNode'><iframe src='${KMSS_Parameter_ContextPath }kms/multidoc/kms_multidoc_ui/kmsMultidocKnowledge_mp3.jsp?attId="+videoId+"' name='mainFrame' id='mainFrame' width='"+imgDisplayW+"' height='565' frameborder=no scrolling='no' style='background-color:white'></iframe></div>";
}
function showBigDoc(docId,index){ 
	//$("#iframeNode iframe").contents().find("body").empty();//清除Iframe,解决IE下报错的问题
	var bi=document.getElementById("bigImg"+index) ;
	bi.innerHTML="<div id='iframeNode'><iframe src='${KMSS_Parameter_ContextPath }sys/attachment/sys_att_main/sysAttMain.do?method=view&fdId="+docId+"&viewer=aspose_htmlviewer&toolPosition=top&newOpen=true' name='mainFrame' id='mainFrame' width='"+imgDisplayW+"' height='565' style='border:none'></iframe></div>";
} 
 
function showBigImg(imgId,index){ 
	//$("#iframeNode iframe").contents().find("body").empty();//清除Iframe,解决IE下报错的问题
    var bi=document.getElementById("bigImg"+index) ;
    bi.innerHTML='';
    var a= document.createElement("A"); 
    var img= document.createElement("img"); 
	img.src= "${KMSS_Parameter_ContextPath }sys/attachment/sys_att_main/sysAttMain.do?method=view&filekey=image2thumbnail_s2&fdId="+imgId ;
	img.setAttribute("onload","drawImage(this,this.parentNode)");
	a.href=  "javascript:showOriginalImg('"+imgId+"')";
	a.title='点击查看原图';   
	var div= document.createElement("div");
	$(div).css({width:imgDisplayW,height:565});
	div.appendChild(img) ;
	a.appendChild(div) ;
	bi.appendChild(a) ;
 }

// doc-html播放跳转回调函数
function gotoCallBack(){
	document.body.scrollTop = 0;
}


function showOriginalImg(imgId){
    window.open("${KMSS_Parameter_ContextPath }kms/multidoc/resource/jsp/kmscustome/showOriginalImg.jsp?fdId="+imgId,"_blank") ;
 }
function appendToImgBrowser(image){
	var smallRow=document.getElementById("picListItem") ;
	var li=document.createElement("li");
	liId +=1;
	li.setAttribute("id","pic"+liId);
	var a=document.createElement("A"); 
    var $img= $('<img>'); 
    var p='${LUI_ContextPath}';
    $img.attr('src',p+"/sys/attachment/sys_att_main/sysAttMain.do?method=view&fdId="+image.fdId+"&filekey=image2thumbnail_s1");
    $img.addClass("smallPic");
    //img.setAttribute("onload","drawImage(this,this.parentNode)");

    var div= document.createElement("div");
    a.appendChild(div);
 
    var div2= document.createElement("div");
    $(div2).addClass("smallDiv");
    div.appendChild(div2) ;
    div.setAttribute('style','border: '+noshowBorder+';');
    div2.appendChild($img[0]) ;
    
    var img2= document.createElement("img"); 
    var p='<%=request.getContextPath()%>' ;  
    img2.src=p+"/kms/multidoc/resource/img/img_default.gif";
    img2.border=1 ;
    img2.width=15 ;
    img2.height=15 ;
    img2.id="sImg";
    a.appendChild(img2) ;
    a.setAttribute("href","javaScript:getBigPlayer('"+liId+"');"); 
    li.appendChild(a);
    if(this.picItem<1 || this.picItem>7){
    	$(li).css("display","none");
	 }
    smallRow.appendChild(li);	
};

function buildBrowser(imgSrc,sImgSrc){
	var smallRow=document.getElementById("picListItem") ;
	var li=document.createElement("li");
	liId +=1;
	li.setAttribute("id","pic"+liId);
	var a=document.createElement("A"); 
    var $img= $('<img>'); 
    $img.attr('src',imgSrc);
    $img.addClass("smallPic");
    var div= document.createElement("div");
    $(div).addClass("smallDiv2");
    a.appendChild(div);
    div.appendChild($img[0]) ;
    //img2--文档类型小图标
    var img2= document.createElement("img"); 
    
   img2.src= sImgSrc;
    img2.border=1 ;
    img2.width=15 ;
    img2.height=15 ;
    img2.id="sImg";
    a.appendChild(img2) ;
    
    a.setAttribute("href","javaScript:getBigPlayer('"+liId+"');"); 
    li.appendChild(a);
    if(this.picItem<1 || this.picItem>7){
    	$(li).css("display","none");
	 }
    smallRow.appendChild(li);	
}

function moveLeft(){
	if(this.picPageNum>1){
		this.picPageNum--;
		$("#picListItem LI").css("display","none");
		$("#picListItem LI").slice((this.picPageNum-1)*7,this.picPageNum*7).css("display","");
	}else{
		picPageNum = picPageSize+1; 
		moveLeft();
	}
}
function moveRight(){
	if(this.picPageNum<this.picPageSize){
		this.picPageNum++;
		$("#picListItem LI").css("display","none");
		$("#picListItem LI").slice((this.picPageNum-1)*7,this.picPageNum*7).css("display","");
	}else{
		picPageNum = 0; 
		moveRight();
	}
}
var divIndex = 2;//未加载内容项的div序列
function left(){ 
	var leftSize = LUI.$("#imgDiv")[0].style.left; 
	if(leftSize.substring(0,leftSize.length-2)>=0){  
		setLeftCursor();
	}else{
		if(!$('#imgDiv').is(":animated")){//防止连续点击导致的重复动画问题
			$('#imgDiv').animate({left:"+="+imgDisplayW+"px"},"slow",function(){ 
				var _divIndex = (Math.abs(leftSize.substring(0,leftSize.length-2)))/imgDisplayW;

				if($("#picListItem li:eq("+(_divIndex-1)+")").is(":hidden")){//判断下个附件是否被隐藏，如果是，则翻页
					moveLeft();
				}
				
				$("#picListItem li:eq("+(_divIndex)+") div:first").css("border",noshowBorder);
				$("#picListItem li:eq("+(_divIndex-1)+") div:first").css("border",showedBorder);//为缩略图加蓝色边框
				if(divIndex>0){divIndex -=1;}

				setLeftCursor();
			});
		}
	}
}
function right(){
		var leftSize = LUI.$("#imgDiv")[0].style.left; 
		
		if(leftSize.substring(0,leftSize.length-2) <= -((picItem-1)*imgDisplayW)){
			var _divIndex = (Math.abs(leftSize.substring(0,leftSize.length-2)))/imgDisplayW;  
			$('#imgDiv').animate({left:"0px"},"normal",function(){//返回第一个附件
				if($("#picListItem li:eq(0)").is(":hidden")){//判断下个附件是否被隐藏，如果是，则翻页
					picPageNum = 2;
					moveLeft();
				}
				divIndex = 2;
				$("#picListItem li:eq("+_divIndex+") div:first").css("border",noshowBorder);//去除蓝色边框
				$("#picListItem li:eq(0) div:first").css("border",showedBorder);//为缩略图加蓝色边框

				setLeftCursor();
			});

		}else{
			if(!$('#imgDiv').is(":animated")){//防止连续点击导致的重复动画问题
			$('#imgDiv').animate({left:"-="+imgDisplayW+"px"},"slow",function(){
					var _divIndex = (Math.abs(leftSize.substring(0,leftSize.length-2)))/imgDisplayW;  

					if($("#picListItem li:eq("+(_divIndex+1)+")").is(":hidden")){//判断下个附件是否被隐藏，如果是，则翻页
						moveRight();
					}
					$("#picListItem li:eq("+_divIndex+") div:first").css("border",noshowBorder);
					$("#picListItem li:eq("+(_divIndex+1)+") div:first").css("border",showedBorder);//为缩略图加蓝色边框
					if(divIndex<picItem-1){divIndex+=1;}
					if(divIndex<picItem && $("#bigImg"+(divIndex+1))[0].innerHTML == ""){  
						showFile(idLists[divIndex],divIndex+1);
					}
					setLeftCursor();
				});
			}
		}
}
//设置左箭头为灰或亮
function setLeftCursor(){
	//添加切换附件播放的箭头,当只有一个附件时，不加导向箭头
	if(idLists.length!=1){
		var leftLen = LUI.$("#imgDiv")[0].style.left;  
		if(leftLen.substring(0,leftLen.length-2)>-imgDisplayW){  
			$(".insignia_left")[0].style.cursor=leftUrl_gray;//箭头灰色，无法切换文件
		}else{
			$(".insignia_left")[0].style.cursor=leftUrl;
		}
	}
}

function getBigPlayer(liId){
	var _target = imgDisplayW*(liId-1);
	LUI.$("#imgDiv")[0].style.display='none';
	$('#imgDiv').animate({left:"-"+_target+"px"},"fast",function(){
		for(var i=4;i<=picItem;i++) { 
			if($("#bigImg"+i)[0].innerHTML == ""){
				showFile(idLists[i-1],i);
			}
		}
		LUI.$("#imgDiv")[0].style.display='block';
		setLeftCursor();
	});
	$("#picListItem li>a>div").css("border",noshowBorder);//去掉所有缩略图蓝色边框
	$("#picListItem li:eq("+(liId-1)+") div:first").css("border",showedBorder);//为缩略图加蓝色边框
}
//根据可播放附件加载相应附件的div位置
function showFile(file,index){
	var fileExt = file.fileName.substring(file.fileName.lastIndexOf("."));
	if(file.fileStatus > -1 && (file.fileType=="image/jpeg" ||file.fileType=="image/gif"||file.fileType=="image/bmp"||file.fileType=="image/png")) {
		showBigImg(file.fdId,index); 
	}else if(file.fileStatus > -1 &&  (file.fileType.indexOf("audio/mpeg")>-1)){
		showBigMp3(file.fdId,index); 
	}else if(file.fileStatus > -1 && (file.fileType.indexOf("video")>-1 || file.fileType.indexOf("audio")>-1 )){
		showBigVideo(file.fdId,index);
	}else if(file.fileStatus > -1 && File_EXT_READ.indexOf(fileExt.toLowerCase()) > -1){
		showBigDoc(file.fdId,index);
	}
}
</script>