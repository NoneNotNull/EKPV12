<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<%="</td></tr></table></center>" %>
<style type="text/css">
a {text-decoration: none;}
a:link { color: #804e08; text-decoration: none;}
a:visited { color: #804e08; text-decoration: none;}
a:active { color: #804e08; text-decoration: none;}
a:hover { color: #00f; text-decoration: none;}
.imgshow {height: 280px; width: auto; margin: 0;padding: 0;}
body{background:#f0f5e1}
#mainbody {width:516px; padding:1px; position:absolute; top: 120px;}
#mainphoto {display:block;border:1px solid #8db15e;}
#goleft {float:left;clear:left;margin:20px 5px 0 3px;}
#goright {float:right;clear:right;margin:20px 3px 0 5px;}
#photos {width:470px;height:71px;line-height:71px;border:0px solid #3C9332;margin:10px 0;overflow:hidden;}
#showArea img {display:block;float:left;cursor:pointer;margin:0 11px 0 0;border: 1px solid #8db15e}
</style>
<%-- 样式 _|_ --%>
<script>Com_IncludeFile("attachment.js","${KMSS_Parameter_ContextPath}sys/attachment/js/","js",true);</script>
<script>Com_IncludeFile("rightmenu.js");</script>
<script>Com_IncludeFile("dialog.js");</script>
	<c:set var="attUrl" value="/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=" />
	<c:set var="viewUrl" value="/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=" />
	<center>
	<div style=" width:520px;text-align:left; margin:10px auto;">
		<img src="pic/goleft.gif" width="16" height="50" id="goleft"/>
	    <img src="pic/goright.gif" width="16" height="50" id="goright"/>
	    <%-- ======================= 小图 ========================= --%>
	    <div id="photos">
			<div id="showArea">
				<c:if test="${queryPage.totalrows==0}">
					<img style="width: 67px; height: 67px;" src="pic/photo_xtu_nophoto.gif">
				</c:if>
				<c:if test="${queryPage.totalrows>0}">
					<c:forEach items="${queryPage.list}" var="sysNewsMain">
						<c:set var="attForms" value="${sysNewsMain.attachmentForms['Attachment']}" />
						<c:set var="originalAttForms" value="${sysNewsMain.attachmentForms['Attachment_original']}" />
						<img style="cursor: pointer; width: 67px; height: 67px;"
							 src="<c:url value="${attUrl}${attForms.attachments[0].fdId}" />" 
							 onclick="changeTopShow(this);"
							 title="<bean:message bundle='sys-news' key='sysNewsMain.browse.hit'/>"
							 newsId="${sysNewsMain.fdId}">
						<input type="hidden" id="docSubject${sysNewsMain.fdId}" value="${sysNewsMain.docSubject}"/>
						<input type="hidden" id="description${sysNewsMain.fdId}" value="${sysNewsMain.fdDescription}"/>
						<input type="hidden" id="original${sysNewsMain.fdId}" value="<c:url value="${attUrl}${originalAttForms.attachments[0].fdId}" />"/>
					</c:forEach>
				</c:if>
		      </div>
	    </div>
		<%-- ======================= 大图 ========================= --%>
		<div id="mainbody">
			<c:if test="${queryPage.totalrows==0}">
				<div id="imgshow" style="width: 516px;height: 404px">
					<img id="mainphoto" width="516px" height="404px" src="pic/photo_dtu_nophoto.gif">
				</div>
			</c:if>
			<c:if test="${queryPage.totalrows>0}">
				<c:set var="sysNewsMain" value="${queryPage.list[0]}" />
				<c:set var="attForms" value="${sysNewsMain.attachmentForms['Attachment_original']}" />
				<div id="imgshow" style="width: 516px;height: 404px">
					<img id="mainphoto" src="<c:url value="${attUrl}${attForms.attachments[0].fdId}" />" width="516px" height="404px" >
				</div>
				<b><span id="newsDocSubject" style="color:green;font-size: 20px">${sysNewsMain.docSubject}</span></b><br>
				<span id="newsDescription" style="width: 516px">${sysNewsMain.fdDescription}</span><br>
				<a  style="float:right" id="newsUrl" href="<c:url value="/sys/news/sys_news_main/sysNewsMain.do" />?method=view&fdId=${sysNewsMain.fdId}" target="_blank">
					<bean:message bundle='sys-news' key='sysNewsMain.browse.detailed.report'/>
				</a>
			</c:if>
		</div>
	</div>
	</center>
	<%-- 控件 --%>
	<c:import url="/sys/attachment/sys_att_main/sysAttMain_OCX.jsp" charEncoding="UTF-8">
		<c:param name="fdKey" value="magazineFile" />
		<c:param name="fdAttType" value="" />
		<c:param name="fdModelId" value="" />
		<c:param name="fdModelName" value="" />
		<c:param name="attachmentId" value="" />
		<c:param name="fdFileName" value="download" />
	</c:import>
<script type="text/javascript">
var images = new Object();
function showImage(dom, img, imgshow) {
	var image = images[img.src];
	var originalId = "original"+img.newsId;
	if (image == null) {
		image = new Image();
		image.src = document.getElementById(originalId).value;
		image.className = "imgshow";
		image.style.width="516px";
		image.style.height="404px";
	}
	if (imgshow != null) {
		imgshow.parentNode.removeChild(imgshow);
	}
	dom.appendChild(image);
}

function changeTopShow(img) {
	var dom = document.getElementById("imgshow");
	dom.style.border="1px solid #8db15e";
	showImage(dom, img, dom.getElementsByTagName("IMG")[0]);
	var docSubjectId = "docSubject"+img.newsId;
	var newsDocSubject = document.getElementById("newsDocSubject");
	newsDocSubject.innerHTML =  document.getElementById(docSubjectId).value;
	var descriptionId = "description"+img.newsId;
	var newsDescription = document.getElementById("newsDescription");
	newsDescription.innerHTML =  document.getElementById(descriptionId).value;
	var newsUrl = document.getElementById("newsUrl");
	newsUrl.href="<c:url value='/sys/news/sys_news_main/sysNewsMain.do' />?method=view&fdId="+img.newsId;
}

var browse = window.navigator.appName.toLowerCase();
var MyMar;
var speed = 2; //速度，越大越慢
var spec = 2; //每次滚动的间距, 越大滚动越快
var spa = 2; //缩略图区域补充数值
var w = 0;
spec = (browse.indexOf("microsoft") > -1) ? spec : ((browse.indexOf("opera") > -1) ? spec*10 : spec*20);
function $(e) {return document.getElementById(e);}
function goleft() {$('photos').scrollLeft -= spec;}
function goright() {$('photos').scrollLeft += spec;}
$('goleft').style.cursor = 'pointer';
$('goright').style.cursor = 'pointer';
$('goleft').onmouseover = function() {this.src = 'pic/goleft_on.gif'; MyMar=setInterval(goleft, speed);}
$('goleft').onmouseout = function() {this.src = 'pic/goleft.gif'; clearInterval(MyMar);}
$('goright').onmouseover = function() {this.src = 'pic/goright_on.gif'; MyMar=setInterval(goright,speed);}
$('goright').onmouseout = function() {this.src = 'pic/goright.gif'; clearInterval(MyMar);}
window.onload = function() {
    var p = $('showArea').getElementsByTagName('img');
    for (var i=0; i<p.length; i++) {
        w += parseInt(p[i].getAttribute('width'));
    }
    $('showArea').style.width = parseInt(w+160) + 'px';
    var rLoad = document.createElement("div");
    $('photos').appendChild(rLoad);
    rLoad.style.width = "1px";
    rLoad.style.height = "1px";
    rLoad.style.overflow = "hidden";
}
</script>
<%="</body></html>" %>