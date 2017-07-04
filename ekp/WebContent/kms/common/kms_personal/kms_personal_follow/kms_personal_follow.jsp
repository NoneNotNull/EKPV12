<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!doctype html>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="/kms/common/resource/jsp/include_ekp.jsp" %>
<%@ include file="/kms/common/resource/jsp/include_kms.jsp" %>
<link rel="shortcut icon" href="${kmsResourcePath }/favicon.ico">
<script type="text/javascript" src="<%=request.getContextPath()%>/resource/js/common.js"></script>
<script src="${kmsResourcePath }/js/lib/jquery.js"></script>
<script>
Com_IncludeFile("data.js|dialog.js", null, "js");
</script>
<link href="${kmsThemePath }/public.css" rel="stylesheet" type="text/css" />
<head>
<style>
.title{
	width: 800px;
	height: 40px;
	margin-top:30px;
	text-align: center;
	font-size: 26px;
}
#category_tb{
	border-collapse: collapse;
	margin-top:10px;
	width:100%;
}
.tagContent .btns_box{
	margin-top:40px;
	margin-left:320px;
}

#category_tb thead tr td{
	line-height: 30px;
	border: #cccccc 1px solid;
}
#category_tb tbody tr td{
	border: #cccccc 1px solid;
	line-height: 34px;
}

#category_tb tbody tr .context{
	text-align: left;
	padding-left:10px;
}

.context a{
	color: #4d94db;
}
</style>
<script>


/**
 * 分类选择
 **/
function selectCategory(templateModel,index){
	this.Dialog_SimpleCategory(templateModel,'fdFollowId_'+index,'fdFollowName_'+index,true,',','00',null,null,'','分类选择');
}

function categorySave(){
	
	var url=  KMS.contextPath+"kms/common/kms_personal/kms_personal_follow/jsonp.jsp?" +
				"s_bean=kmsPersonFollowService&s_meth=updateKmsFollow&m_Seq="+Math.random();
	$.getJSON(url, {followConfig:getFollowCategoryConfig(),followType:"category"}, function(json){
		if(json.status){
			alert("保存成功!");
			isRefresh = true;
			closePage();
		}else{
			alert("保存失败，请联系管理员");
		}
	});
	
}


function getFollowCategoryConfig(){
	var followConfig = [];
	for(var i=1;i<4;i++){
		followConfig.push({
			fdFollowIds:$("input[name=fdFollowId_"+i+"]").val(),
			fdFollowNames:$("input[name=fdFollowName_"+i+"]").val(),
			fdFollowModel:$("input[name=fdFollowModel_"+i+"]").val()
		});
	}
	return JSON.stringify(followConfig);
}

/**
 * 保存标签
 */
function tagSave(){
	var url=  KMS.contextPath+"kms/common/kms_personal/kms_personal_follow/jsonp.jsp?" +
	"s_bean=kmsPersonFollowService&s_meth=updateKmsFollow&m_Seq="+Math.random();
	$.getJSON(url, {followConfig:getFollowTagConfig(),followType:"tag"}, function(json){
		if(json.status){
			alert("保存成功!");
			isRefresh = true;
			closePage();
		}else{
			alert("保存失败，请联系管理员");
		}
	});
}

function getFollowTagConfig(){
	var followConfig = [];
	followConfig.push({
		fdFollowIds:$("input[name=fdFollowId]").val(),
		fdFollowNames:$("textarea[name=fdFollowName]").val()
	});
	return JSON.stringify(followConfig);
}
function switchTag(e,area_id){
	//已被选择
	if($(e).attr("class")=="selectTag"){
		return;
	}
	//设置显示与隐藏区域
	$("#tags>li").attr("class","");
	$(e).addClass("selectTag");
	$("#content>div").css("display","none");
	$("#"+area_id).css("display","");

	
}

$(document).ready(function() {
	
	var args = window.dialogArguments;
	/**if(!args){
		args = {};
		args.portletId="portlet_followTag";
	}**/
	if(args.portletId=="portlet_followCategory"){
		switchTag($("#category_tab"),"category_content");
	}else{
		switchTag($("#tag_tab"),"tag_content");
	}
	
	//初始化分类
	initCategory(args.portletId);
	//初始化标签
	initTag();
});

function initCategory(){
	var followConifg = $("#followCategoryConifg").val();
	var str = JSON.parse(followConifg.replace(/\'/g,"\""));
	var data = str.data;
	for(var i=0;i<3;i++){
		$("input[name=fdFollowId_"+(i+1)+"]").val(data[i].fdFollowId);
		$("input[name=fdFollowName_"+(i+1)+"]").val(data[i].fdFollowName);
	}
}
function initTag(){
	var followConifg = $("#followTagConifg").val();
	var str = JSON.parse(followConifg.replace(/\'/g,"\""));
	var data = str.data;
	$("input[name=fdFollowId]").val(data[0].fdFollowId);
	$("textarea[name=fdFollowName]").val(data[0].fdFollowName);
}

var isRefresh = false;
function closePage(){
	window.returnValue = isRefresh;
	window.close();
}
</script>
</head>
<body oncontextmenu="self.event.returnValue=false">
<div id="wrapper">
	<div class="box c">
		<!-- end leftbar2 -->
		<form action="<c:url value='/kms/common/kms_person_follow/kmsPersonFollow.do' />" method="post" id="kmsPersonFollowForm">
		<input id="followCategoryConifg" style="display:none" value="<%=request.getAttribute("followCategoryConifg")%>">
		<input id="followTagConifg" style="display:none" value="<%=request.getAttribute("followTagConifg")%>">
		<div class="title">订阅设置</div>
		<div class="cont2" style="min-height:100px;">
			<div class="con con2 con2_2 m_t10">
				<div>
					<div class="title4 tabview">
						<ul class="c tab_ul" id="tags"">
							<li id="category_tab" class="selectTag"><a onclick="switchTag(this.parentNode,'category_content')" href="#">订阅的分类</a></li>
							<li id="tag_tab" ><a onclick="switchTag(this.parentNode,'tag_content')" href="#">订阅的标签</a></li>
						</ul>
					</div>
				</div>
				<div id=content>
					<div id="category_content" class="tagContent">
						<table id="category_tb" class="con t_b">
							<thead>
								<tr>
									<td style="" width="20%">模块名</td>
									<td width="80%">订阅分类</td>
								</tr>
							</thead>
							<tbody>
								<tr >
									<td>文档知识库</td>
									<td class="context"><input class="i_b" style="width:450px" readonly="readonly" name="fdFollowName_1">
									</input><input name="fdFollowId_1" style="display:none;"/><input name="fdFollowModel_1" 
									value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" style="display:none;"/>
									<a href="#" onclick="selectCategory('com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory',1);" title="编辑分类">
									<img src="../resource/img/icons/edit.png"/>编辑分类</a>
									</td>
								</tr>
								<tr >
									<td>多媒体知识库</td>
									<td class="context"><input class="i_b" style="width:450px" readonly="readonly" name="fdFollowName_2">
									</input><input name="fdFollowId_2" style="display:none;"/><input name="fdFollowModel_2" 
									value="com.landray.kmss.kms.multimedia.model.KmsMultimediaMain" style="display:none;"/>
									<a href="#" onclick="selectCategory('com.landray.kmss.kms.multimedia.model.KmsMultimediaTemplate',2);" title="编辑分类">
									<img src="../resource/img/icons/edit.png"/>编辑分类</a>
									</td>
								</tr>
								<tr >
									<td>维基知识库</td>
									<td class="context"><input class="i_b" style="width:450px" readonly="readonly" name="fdFollowName_3">
									</input><input name="fdFollowId_3" style="display:none;"/><input name="fdFollowModel_3" 
									value="com.landray.kmss.kms.wiki.model.KmsWikiMain" style="display:none;"/>
									<a href="#" onclick="selectCategory('com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory',3);" title="编辑分类">
									<img src="../resource/img/icons/edit.png"/>编辑分类</a>
									</td>
								</tr>
							</tbody>
						</table>
						<div class="btns_box">
							<div class="btn_a" style="width:60px;">
								<a href="javascript:void(0)" title="保存" onclick="categorySave();"><span><strong>保存</strong>
								</span></a>
							</div>
							<div class="btn_a" style="width:60px;">
								<a href="javascript:void(0)" title="关闭" onclick="closePage();"><span><strong>关闭</strong>
								</span></a>
							</div>
						</div>
					</div>
					<div id="tag_content" class="tagContent" style="display:none;">
						<div class="" style="margin-top:20px;margin-botton:40px;">
							<span><textarea rows="4" cols="180" style="width:550px;" readonly="readonly" name="fdFollowName"></textarea> 
								<input name="fdFollowId" style="display:none;"/>
							</span>
							<span id="tag_btn_div" class="btn_g">
							 	<a href="#" onclick="Dialog_Tree(true,'fdFollowId','fdFollowName',',','sysTagCategorApplicationTreeService&fdCategoryId=!{value}','选择标签',false,null,null,false,null,null)">
							 		<span>选择</span>
								</a>
							</span>
						</div>
						<div class="btns_box">
							<div class="btn_a" style="width:60px;">
								<a href="javascript:void(0)" title="保存" onclick="tagSave();"><span><strong>保存</strong>
								</span></a>
							</div>
							<div class="btn_a" style="width:60px;">
								<a href="javascript:void(0)" title="关闭" onclick="closePage();"><span><strong>关闭</strong>
								</span></a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
	</div>
	<!-- end cont2 -->
</div>
</body>
</html>