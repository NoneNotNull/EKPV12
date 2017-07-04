<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<link
	href="${kmsBasePath }/multidoc/resource/css/kmsMultidocKnowledge.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="${kmsBasePath }/multidoc/resource/js/kmsmultidoc_view.js"></script>
<script type="text/javascript"
	src="${kmsBasePath }/common/resource/js/kms_navi_selector.js"></script>
	<script type="text/javascript"
	src="${kmsBasePath }/common/resource/js/kms_docUtil.js"></script>
<script type="text/javascript">
var picPageNum = 1;
var picPageSize = 0;
var picItem = 0;
var that = this;
imgList = new Array();
/**
 * 初始化页面
 */
window.onload=function(){
	
	showAuthor('${kmsMultidocKnowledgeForm.method_GET}') ;
	
	getEvaluationNum();
	
	getIntroduceNum() ;
	
    showTags();
    
    //展开属性
    $('#aWordShow').click();
    
    getRelationNum();
    
    loadSwf();
    
    bindCnt();
    $('#cnt_a').click();
    showStars();

    //重置内容的图片和表格大小
    resizeContent();
}

function resizeContent(){
	//将内容部分，图片宽度大于600的，限制在600内，避免过大图片把页面撑开
	$('#contentInfo').find('img').each(function(){
		this.style.cssText="";
		var pt;
		if(this.height && this.height!="" && this.width && this.width != "")
			pt = parseInt(this.height)/parseInt(this.width);//高宽比
		if(this.width>650){
			this.width = 650;
			if(pt)
				this.height = 650 * pt;
		}
	});
	$("#contentInfo").find("table").each(function(){
		this.style.cssText="";
		var width=$(this).width();
		//var height=$(this).height();
		if(width>700){
		   $(this).width(700);			  
		}		
	});
}

// 绑定内容展开收起事件
function bindCnt() {
	$('#cnt_a').bind('click', function() {
		var arr = new Array();
		arr.push({
					text : '收起',
					className : 'cnt_pack'
				});
		arr.push({
					text : '展开',
					className : 'cnt_exp'
				});
		for (var i =0 ;i < arr.length ;i++ ) {
			if ($('#cnt_a').text() != arr[i].text) {
				$('#cnt_a').text(arr[i].text);
				$('#cnt_a').removeClass();
				$('#cnt_a').addClass(arr[i].className);
				if($('.p_con').css('display')=='none'){
					$('.p_con').css('display','block');
				}else{
					$('.p_con').css('display','none');
				}
				break;
			}
		}
	})
}

// flash滚轮事件
function mouseWheel(evt) {
	evt = window.event || evt;
	try {
		document.getElementById("att_swf_viewer")
			.mouseWheelScroll(evt.wheelDelta);
	} catch (e) {}
	if (evt.preventDefault) {
		evt.preventDefault();
	} else {
		evt.returnValue = false;
	}
}

// 读取在线flash数据
function loadSwf(){
	var objViewer = document.getElementById('att_swf_viewer');
	if(objViewer){
		if (objViewer.addEventListener) {
			objViewer.addEventListener("mousewheel", mouseWheel, false);
			objViewer.addEventListener ("DOMMouseScroll", mouseWheel, false);
		} else if (objViewer.attachEvent) {
			objViewer.attachEvent("onmousewheel", mouseWheel);
		}
	}
}
 //更新评分
function updateScore(){
    //ajax 
	var url="kmsMultidocKnowledgeXMLService&fdId=${kmsMultidocKnowledgeForm.fdId}&type=0";
	var data = new KMSSData(); 
	data.SendToBean(url,function defaultFun(rtnData){ 
		var obj = rtnData.GetHashMapArray()[0]; 
 		var count=obj['count'];
 		$('#fen').text(count+"分");
 		document.getElementById('docScore').value=count;
	});	  
}

 //更新标签
function updateTags(tags,type){
	 //ajax 
	var url="kmsMultidocKnowledgeXMLService&fdId=${kmsMultidocKnowledgeForm.fdId}&type="+type+"&tags="+encodeURIComponent(tags);
	var data = new KMSSData(); 
	data.SendToBean(url,function defaultFun(rtnData){ 
		 showSuccessMsg(1);
	});	   
 }
//显示作者
function showAuthor(method){
      if(method=='view'){
     	  var s=  '${kmsMultidocKnowledgeForm.outerAuthor}' ;
     	  var author='';
     	   if(s!=null && s.length>0){
     		   author='${kmsMultidocKnowledgeForm.outerAuthor}';
            }else{
               author='${kmsMultidocKnowledgeForm.docAuthorName}';
            }
            document.getElementById("author").innerHTML=author;
           
		}
        
	} 
 //得到关联数量
function getRelationNum(){
	var url="kmsMultidocKnowledgeXMLService&fdId=${kmsMultidocKnowledgeForm.fdId}&type=1";
	var data = new KMSSData(); 
	data.SendToBean(url,function defaultFun(rtnData){ 
		var obj = rtnData.GetHashMapArray()[0]; 
 		var count=obj['count'];
 		if(count>0){
 		 var h=count*50 ;
 		 $('#relationIframe').height(h+'px') ;
 		 $('#docRelation').show() ;
 		}
	});	  
 }
// 得到点评数量
function getEvaluationNum(){
	  var tagName='<bean:message bundle="sys-evaluation" key="sysEvaluationMain.tab.evaluation.label" />';
	  var num=document.getElementById(tagName);
	  var pinglun=document.getElementById('evaluationNum');
	  var c=pinglun.firstChild ;   
	  if(c!=null)
	     pinglun.removeChild(c);
	  if(num && num.rev!=''){
		  pinglun.appendChild( document.createTextNode(num.rev));
	   }else
		  pinglun.appendChild( document.createTextNode('(0)')); 
	  
 }
// 得到推荐数量
function getIntroduceNum(){
	  var tagName='<bean:message bundle="sys-introduce" key="sysIntroduceMain.tab.introduce.label" />';
	  var num=document.getElementById(tagName);
	  var tuijian=document.getElementById('introduceNum');
	  var c=tuijian.firstChild ;   
	  if(c!=null)
		  tuijian.removeChild(c);
	  if(num && num.rev!=''){
		  tuijian.appendChild( document.createTextNode(num.rev));
	   }else
		  tuijian.appendChild( document.createTextNode('(0)')); 
	
}
function gotoIndex(){
    window.open("<c:url value='/kms/common/kms_common_main/kmsCommonMain.do?method=module' />","_self");
}

function gotoMultidocCenter(){
    window.open("<c:url value='/kms/common/kms_common_main/kmsCommonMain.do?method=module&fdId=com.landray.kmss.kms.multidoc' />","_self");
}
//显示属性
function showPropertyList(){
	 var $propertyList=$('#propertyList') ;
	 var img=document.getElementById('imgShow');
	 var word=$('#wordShow') ;
	 if($(word).text()=='收起'){
		  $(word).text('展开');
		  img.src ='${kmsResourcePath }/img/ic_cocl.gif';
	  }else{
		  $(word).text('收起');
		  img.src ='${kmsResourcePath }/img/ic_coop.gif' ;
		  }
  
	  if($propertyList){ 
		var $rows = $propertyList.find('tr');
		$rows.each(function (index){
			$(this).toggle(); 
			
		});
	  }
}
//显示标签
var currentTags="${kmsMultidocKnowledgeForm.sysTagMainForm.fdTagNames}";
function showTags(){
	var list= new Array() ;
	list=currentTags.split(" ") ;
	var $tag=$('#tagLists');
	for(i=0;i<list.length;i++) {
        var l=list[i] ;
        var more=("<a href='javascript:void(0);' onclick=gotoTags('"+l+"')  ><nobr>"+l+"</nobr></a> ") ;
        $tag.after(more) ;
		}
	}
function gotoTags(val){
	var vals=encodeURI(val);
	window.open("<c:url value='/sys/tag/sys_tag_main/sysTagMain.do?method=searchMain&queryType=&queryString="+vals+"' />","_blank");
}
function checkDelete(){
	showConfirm("你确定要删除此文档吗？",function(){
		 Com_OpenWindow('kmsMultidocKnowledge.do?method=delete&fdId=${param.fdId}','_self');
	},true) ;
}
function changeRight() {
	    var fdid='${param.fdId}';
		var url="<c:url value="/sys/right/rightDocChange.do"/>";
		url+="?method=docRightEdit&modelName=com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge&categoryId=${kmsMultidocKnowledgeForm.fdDocTemplateId}";
		url+="&fdIds="+fdid;
		Com_OpenWindow(url,'_blank','height=650, width=800, toolbar=0, menubar=0, scrollbars=1, resizable=1, status=1');
		return;
}
//添加标签
function addTags(type) {
	var content = '';
	var value = '';
	var title = '';
	if (type == '2') { // 编辑
		title = "调整标签";
		content = '修改标签，标签间请用“空格”隔开！';
		value = reverseTagStr(currentTags);
	} else if (type == '3') { //添加
		title = "添加标签";
		content = '请输入新标签，标签间请用“空格”隔开！';
		value = " ";
	}
	art.artDialog({
		content: [
			'<div style="margin-bottom:5px;font-size:12px">',
		content,
			'</div>',
			'<div>',
			'<input value="',
		value,
			'" style="width:28em;padding:6px 4px" />',
			'</div>'].join(''),
		initFn: function() {
			input = this.DOM.content.find('input')[0];
			var rtextRange = input.createTextRange();
			rtextRange.moveStart('character', input.value.length);
			rtextRange.collapse(true);
			rtextRange.select();

		},
		height: '50px',
		width: '350px',
		id: 'showTagIds',
		title: title,
		lock: true,
		opacity: 0, //  
		yesFn: function() {
			input = this.DOM.content.find('input')[0];
			updateTags(input.value, type);
		},
		yesVal: '确定',
		noVal: '取消',
		noFn: function() {}
	});
}
function reverseTagStr(str) {
 if(str!=''){
	var arrayStr= str.split(" ") ;
	var returnStr='';
    for(i=arrayStr.length-1;i>=0;i--){
    	returnStr=returnStr+arrayStr[i]+" ";
        }
  }
 return returnStr ;
}
var propertyWindow ;
function editProperty() {
	propertyWindow = art.dialog.open('kmsMultidocKnowledge.do?method=editProperty&type=property&fdId=${param.fdId}', {
		title: '调整属性',
		width: '720px',
		lock: true,
		//background: '#fff', //  
		opacity: 0
	});

}
function closePropertyWindow(){
	propertyWindow && propertyWindow.close();
	propertyWindow = null;
}
//提示操作成功

function showSuccessMsg(type) {
	var t = type;
	$("#successTag").show();
	if (t != null && t == 1) setTimeout(function() {
		$("#successTag").hide();
		window.location.reload();
	}, 500);
	else setTimeout(function() {
		$("#successTag").hide();
		Com_OpenWindow('kmsMultidocKnowledge.do?method=view&fdId=${param.fdId}', '_self');
	}, 1500);
}

function checkChange(){
	//showConfirm("将会清空文档属性,确定要继续吗？",function(){
		showSelectTemplate();
	//},true) ;
}
 //分类转移
function changeTemplateUpdate(templateId,fdId) {
	var url="kmsMultidocKnowledgeXMLService&type=4&docIds="+fdId+"&templateId="+templateId;
	var data = new KMSSData(); 
	data.SendToBean(url,function defaultFun(rtnData){ 
		var obj = rtnData.GetHashMapArray()[0]; 
 		var count=obj['count'];
 		if(count==0){
 			showSuccessMsg(1);//成功 
 		}else{
		  //失败
		    alert('操作失败');
 	 	 }
	});	  
}

function showSelectTemplate(){
	artDialog.navSelector('重新选择分类', addoptions, navOptions);
}

var jsonUrl = '${kmsResourcePath}/jsp/get_json_feed.jsp';
var dialogUrl = '${kmsBasePath}/common/jsp/dialog.html';
var addoptions = {
			lock : false,
			noFn : function() {},
			height : '400px',
			width : '500px',
			background: '#fff',  
		    mask: false,
			yesFn : function(naviSelector) {
				var selectedCache = naviSelector.selectedCache;
				// 未选择分类~
				if (selectedCache.length == 0) {
					showAlert('请选择分类') ;
					return false;
				}
				if(selectedCache.last()._data["isShowCheckBox"]=="0"){
					art.artDialog.alert("您没有当前目录使用权限！");
					return;
				}
				var fdCategoryId = selectedCache.last()._data["value"];
               	changeTemplateUpdate(fdCategoryId,'${param.fdId}') ;
		    }
		};
		// 分类组件
		var navOptions = {
			dataSource : {
				url : jsonUrl,
				modelName:'com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate',
				authType:'02',
				extendFilter:"fdExternalId is null"
			}
		};


function flashviewr_before(args) {
	var ajaxUrl = "${kmsBasePath }/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=getSwfData&fdId="
			+ args[2];
	$.getJSON(ajaxUrl, {}, function(data) {
		var htmlArray = new Array();
		if (Com_Parameter.IE) {
			htmlArray
					.push('<object id="att_swf_viewer" style="height: 500px;width:100%" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" style="cursor:pointer;width:100%">');
			htmlArray.push('<param name="wmode" value="opaque">');
			htmlArray.push('<param name="allowFullScreen" value="true">');
			htmlArray.push('<param name="movie" value="'
					+ Com_Parameter.ContextPath
					+ 'sys/attachment/swf/viewer.swf" />');
			htmlArray.push('<param name="flashVars" value="docurl=',
					data['swfUrl'], '&pagecount=', data['pageCount'],
					'&pageType=swf"/>');
			htmlArray.push('<param name="quality" value="high" />');
			htmlArray.push('</object>');
		} else {
			htmlArray
					.push('<embed id="att_swf_viewer" src="'
							+ Com_Parameter.ContextPath
							+ 'sys/attachment/swf/viewer.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" style="width:100%;height: 500px;"');
			htmlArray.push(' allowFullScreen=true ');
			htmlArray
					.push(' flashVars="docurl=', data['swfUrl'], '&pagecount=',
							data['pageCount'], '&pageType=swf"></embed>');
		}
		document.getElementById('swfDiv').innerHTML = htmlArray.join("");
		var objViewer = document.getElementById('att_swf_viewer');
		if (objViewer) {
			if (objViewer.addEventListener) {
				objViewer.addEventListener("mousewheel", mouseWheel, false);
				objViewer.addEventListener ("DOMMouseScroll", mouseWheel, false);
			} else if (objViewer.attachEvent) {
				objViewer.attachEvent("onmousewheel", mouseWheel);
			}
		}
	});
	return false;
}

function flashviewrChange(obj,fdId){
	$(obj).blur();
	$(obj).parent().children().each(function(){
		if($(this).hasClass('search-select')){
			$(this).removeClass('search-select');
		}
	});
	$(obj).addClass('search-select');
	flashviewr_before(['','',fdId]);
}

/**
* 附件预览
*/
function Attachment_ShowList(attObj) {
	if(this.attType!="office") {
		var showDiv = document.createElement("div");
		showDiv.id="attachment_file_div";
		var len = attObj.fileList.length;
		for(var i=0;i<len;i++) {
			if(attObj.fileList[i].fileStatus > -1 && (attObj.fileList[i].fileType=="image/jpeg" ||attObj.fileList[i].fileType=="image/gif"||attObj.fileList[i].fileType=="image/bmp"||attObj.fileList[i].fileType=="image/png")) {
				that.picItem++;
			    var div=GetLinkDiv(attObj, attObj.fileList[i]) ;
			    if(div!=""){
				 	showDiv.appendChild(div );
				 }
			}else if(attObj.fileList[i].fileStatus > -1 &&  (attObj.fileList[i].fileType.indexOf("audio/mpeg")>-1)){
				that.picItem++;
				GetMp3Div(attObj, attObj.fileList[i]) ;
			}else if(attObj.fileList[i].fileStatus > -1 && (attObj.fileList[i].fileType.indexOf("video")>-1 || attObj.fileList[i].fileType.indexOf("audio")>-1 )){
				that.picItem++;
				GetVideoDiv(attObj, attObj.fileList[i]) ;
			}
		}
		if(len>0){
			that.picPageSize = that.picItem%6==0?that.picItem/6:Math.ceil(that.picItem/6);
		}
		if(attObj.fileList.length==0){
			
		}
	}

	//附件列表
	document.getElementById(attObj.renderId).innerHTML = KmsTmpl(
			attObj.templateId).render( {
		"attObj" : attObj,
		"msg" : Attachment_MessageInfo
	});
	
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
function putImgBrowser(obj){
	 imgList.push(obj) ;
	 if(imgList.length==1){ //显示第一个大图
	   showBigImg(obj.fdId) ;
	   document.getElementById("imgBrowser").style.display='block';
	 }
	 appendToImgBrowser(obj) ;
}	
function GetSrc(fileName) {
	var src=Com_Parameter.ContextPath+"kms/multidoc/resource/img/" ;
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
function appendToImgBrowser(image){
		var smallRow=document.getElementById("picListItem") ;
		var li=document.createElement("li");
		var a=document.createElement("A"); 
    var img= document.createElement("img"); 
    var p='<%=request.getContextPath()%>' ;
    img.src=p+"/sys/attachment/sys_att_main/sysAttMain.do?method=showThumbs&size=s1&fdId="+image.fdId ;
    img.border=1 ;
    img.width=100 ;
    img.height=100 ;
    a.appendChild(img) ;
    a.setAttribute("href","javaScript:showBigImg('"+image.fdId+"');"); 
    li.appendChild(a);
    if(this.picItem<1 || this.picItem>6){
    	$(li).css("display","none");
	 }
    smallRow.appendChild(li);	
};
function showBigImg(imgId){
    var bi=document.getElementById("bigImg") ;
    bi.innerHTML='';
    var a= document.createElement("A"); 
    var img= document.createElement("img"); 

    img.onload = function(){
   		var MaxWidth=667;//设置图片宽度界限
   		var MaxHeight=400;//设置图片高度界限
   		var HeightWidth=img.offsetHeight/img.offsetWidth;//设置高宽比
   		var WidthHeight=img.offsetWidth/img.offsetHeight;//设置宽高比
   		
   		if(img.offsetWidth>MaxWidth){
	   		img.width=MaxWidth;
	   		img.height=MaxWidth*HeightWidth;
   		}
   		if(img.offsetHeight>MaxHeight){
	   		img.height=MaxHeight;
	   		img.width=MaxHeight*WidthHeight;
   		}
   	      img.width=MaxWidth;
		img.height=MaxHeight;
		
	}
    
   
	img.src= KMS.contextPath + "sys/attachment/sys_att_main/sysAttMain.do?method=showThumbs&size=s2&fdId="+imgId ;
	a.href=  "javascript:showOriginalImg('"+imgId+"')";
	a.title='点击查看原图';   
	a.appendChild(img) ;
	bi.appendChild(a) ;
 }
function showBigVideo(videoId){
	var bi=document.getElementById("bigImg") ;
	bi.innerHTML="<div><iframe src='kmsMultidocKnowledge_video.jsp?attId="+videoId+"' name='mainFrame' id='mainFrame' width='667' height='400' frameborder=no scrolling='no'></iframe></div>";
}
function showBigMp3(videoId){
	var bi=document.getElementById("bigImg") ;
	bi.innerHTML="<div><iframe src='kmsMultidocKnowledge_mp3.jsp?attId="+videoId+"' name='mainFrame' id='mainFrame' width='667' height='100' frameborder=no scrolling='no'></iframe></div>";
}
function moveLeft(){
	if(this.picPageNum>1){
		this.picPageNum--;
		$("#picListItem LI").css("display","none");
		$("#picListItem LI").slice((this.picPageNum-1)*6,this.picPageNum*6).css("display","");
	}
}
function moveRight(){
	if(this.picPageNum<this.picPageSize){
		this.picPageNum++;
		$("#picListItem LI").css("display","none");
		$("#picListItem LI").slice((this.picPageNum-1)*6,this.picPageNum*6).css("display","");
	}
}
function showOriginalImg(imgId){
    window.open("<%=request.getContextPath()%>/kms/multidoc/resource/jsp/kmscustome/showOriginalImg.jsp?fdId="+imgId,"_blank") ;
 }
function GetVideoDiv( attachmentObject, doc){
	if(doc.fileType.indexOf("video")>-1 || doc.fileType.indexOf("audio")>-1){
		putVideoBrowser(doc) ;
	}
}
function putVideoBrowser(obj){
	 imgList.push(obj) ;
	 if(imgList.length==1){ 
	   showBigVideo(obj.fdId) ;
	   document.getElementById("imgBrowser").style.display='block';
	 }
	 appendToVideoBrowser(obj) ;
}
function appendToVideoBrowser(video){
	var smallRow=document.getElementById("picListItem") ;
	var li=document.createElement("li");
		var a=document.createElement("A"); 
    var img= document.createElement("img"); 
    var p='<%=request.getContextPath()%>' ;
    
    img.src=p+"/sys/attachment/sys_att_main/sysAttMain.do?method=showThumbs&size=s1&fdId="+video.fdId ;
    img.border=1 ;
    img.width=100 ;
    img.height=100 ;
    a.appendChild(img) ;
    a.setAttribute("href","javaScript:showBigVideo('"+video.fdId+"');"); 
    li.appendChild(a);
    if(this.picItem<1 || this.picItem>6){
    	$(li).css("display","none");
	 }
    smallRow.appendChild(li);	
}
function GetMp3Div( attachmentObject, doc){
	if(doc.fileType.indexOf("audio/mpeg")>-1){
		putMp3Browser(doc) ;
	}
}
function putMp3Browser(obj){
	 imgList.push(obj) ;
	 if(imgList.length==1){ 
	   showBigMp3(obj.fdId) ;
	   document.getElementById("imgBrowser").style.display='block';
	 }
	 appendToMp3Browser(obj) ;
}
function appendToMp3Browser(video){
	var smallRow=document.getElementById("picListItem") ;
	var li=document.createElement("li");
		var a=document.createElement("A"); 
    var img= document.createElement("img"); 
    var p='<%=request.getContextPath()%>' ;
    img.src=p+"/kms/multidoc/resource/img/musicicon.jpg" ;
    img.border=1 ;
    img.width=100 ;
    img.height=100 ;
    a.appendChild(img) ;
    a.setAttribute("href","javaScript:showBigMp3('"+video.fdId+"');"); 
    li.appendChild(a);
    if(this.picItem<1 || this.picItem>6){
    	$(li).css("display","none");
	 }
    smallRow.appendChild(li);	
}
</script>
<script type="text/template" id="portlet_view_online_tmpl">
{$
	<div class="title1">
		<h2>
			{% parameters.kms.title %}
		</h2>
	</div>
	<div class="box2">
$}
	var json = data.jsonArray;
	for(var i =0;i<json.length;i++){
		{$
			<a href="javascript:void(0)" onclick="flashviewrChange(this,'{%json[i].fdId%}')" class="search-choice $}if(i==0){{$search-select$}}{$">{%json[i].fdText%}</a>
		$}
	}
{$		
	</div>
$}
</script>
