<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script src="${kmsResourcePath }/js/kms_opera.js"></script>
<script src="${kmsResourcePath }/js/kms_navi_selector.js"></script>
<script src="${kmsResourcePath }/js/kms_docUtil.js"></script>
<script type="text/javascript"
	src="${kmsBasePath}/wiki/resource/ckeditor/ckeditor.js"></script>
<script type="text/javascript"
	src="${kmsBasePath}/wiki/resource/ckeditor/plugins/category/editorCategory.js"></script>
<script type="text/javascript"
	src="${kmsBasePath}/wiki/resource/uploadCard/uploadCard.js"></script>
<script>
//回到首页
function gotoIndex(){
	window.open("<c:url value='/kms/common/kms_common_main/kmsCommonMain.do?method=module' />","_self");
}

//回到脚本库
function gotoWikiCenter(){
	window.open("<c:url value='/kms/common/kms_common_main/kmsCommonMain.do?method=module&fdId=com.landray.kmss.kms.wiki' />","_self");
} 

//展开更多信息\收起
function option_baseInfo(thisObj){
	var baseInfo = document.getElementById("baseInfos");
	var img = $('#baseInfo_img');
	if(thisObj.className == "baseInfo_holder"){
		//展开
		baseInfo.style.display = "";
		thisObj.innerHTML = "收起";
		img[0].src = '${kmsResourcePath }/img/ic_coop.gif';
		thisObj.className = "baseInfo_unholder";
	}else{
		//收起
		baseInfo.style.display = "none";
		thisObj.innerHTML = "展开";
		img[0].src = '${kmsResourcePath }/img/ic_cocl.gif';
		thisObj.className = "baseInfo_holder";
	}
}

//显示属性
function showPropertyList() {
	var $propertyList = $('#propertyList');
	var img = $('#imgShow');
	var word = $('#wordShow');
	if ($(word).text() == '收起') {
		$(word).text('展开');
		img[0].src = '${kmsResourcePath }/img/ic_cocl.gif';
	} else {
		$(word).text('收起');
		img[0].src = '${kmsResourcePath }/img/ic_coop.gif';
	}
	if ($propertyList) {
		$propertyList.toggle();
	}
}

// 选择类别后重新绑定模板与属性
function callBackCategoryAction(rtnVal){
	if(rtnVal){
		var hash = rtnVal.GetHashMapArray();
		var fdCategoryId = '';
		for(var i = 0;i< hash.length;i++){
			fdCategoryId += i==0? hash[i]['id']:';'+hash[i]['id'];
		}
		var url = ['<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do"/>?method=add','fdCategoryId='+fdCategoryId].join('&');
		window.open(url,'_self');
	}
}


//重新选择类别
function seclectCategory(){
	Dialog_Tree(false, 'fdCategoryId', 'fdCategoryName',';', 'kmsWikiCategoryTree&selectId=!{value}', '<bean:message bundle="kms-wiki" key="kmsWikiMain.fdCategoryList"/>', null, callBackCategoryAction, '${param.fdId}', null, null, '<bean:message key="dialog.title.allCategory" bundle="kms-wiki"/>');
}

//选择作者类型
function seclectAuthorType(thisObj){
	var selectValue = thisObj.value;
	if(selectValue == 0 || selectValue == "0"){
		GetID("authorSelect_span").style.display="";
		GetEl("docAuthorId").value="";
		GetEl("fdAutherName").value="";
		GetEl("fdAutherName").readOnly = true;
	}else{
		GetID("authorSelect_span").style.display="none";
		GetEl("docAuthorId").value="";
		GetEl("fdAutherName").value="";
		GetEl("fdAutherName").readOnly = false;
	}
	
}

function showTR(kms_tr_tag_name){
	for(var i=0; i<Doc_LabelInfos.length; i++){
		var tbObj = document.getElementById(Doc_LabelInfos[i]);
		for(var j=0; j<tbObj.rows.length; j++){
			var tagName = tbObj.rows[j].getAttribute("LKS_LabelName"); 
			if(tagName==kms_tr_tag_name){
				$(tbObj.rows[j]).show();
				tbObj.rows[j].click() ;
			}else{
				$(tbObj.rows[j]).hide();
			}
	    }
	}
}

//切换目录和编辑规范的页签
function selectTag(showContent,selfObj){
	// 操作标签
	var tag = document.getElementById("right_tags").getElementsByTagName("li");
	var taglength = tag.length;
	for(var i=0; i<taglength; i++){
		tag[i].className = "";
	}
	selfObj.parentNode.className = "selectTag";
	// 操作内容
	for(i=0; j=document.getElementById("right_tagContent"+i); i++){
		j.style.display = "none";
	}
	document.getElementById(showContent).style.display = "block";
}


//编辑目录
var catelogJson = [];
<c:forEach items="${kmsWikiMainForm.fdCatelogList}" var="kmsWikiCatelogForm" varStatus="vstatus">
<c:set var="order" value="${vstatus.index}" scope="request" /> 
	catelogJson["<c:out value='${order}' />"]={
		fdId:"<c:out value='${kmsWikiCatelogForm.fdId}' />",
		fdName:"<c:out value='${kmsWikiCatelogForm.fdName}' />",
		fdOrder:"<c:out value='${kmsWikiCatelogForm.fdOrder}' />",
		docContent:"",
		fdParentId:"<c:out value='${kmsWikiCatelogForm.fdParentId}' />",
		authEditorIds:"<c:out value='${kmsWikiCatelogForm.authEditorIds}' />",
		authEditorNames:"<c:out value='${kmsWikiCatelogForm.authEditorNames}' />"
	};
</c:forEach>

function editCatelog(){
	destroyDiv();//隐藏编辑框
	if(catelogJson.length>0){
		for(var i=0;i<catelogJson.length;i++){
			var _fdId = catelogJson[i].fdId;
			var contentObj = GetID("editable_"+_fdId);
			catelogJson[i].docContent = contentObj.innerHTML;//将编辑框的内容放入json中
		}
	}
	var url="<c:url value='/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=openCatelogDialog' />&fdId=${kmsWikiMainForm.fdId}";  
	var style = "dialogWidth:700px; dialogHeight:600px; status:0;scroll:1; help:0; resizable:1";
	var rtnVal = window.showModalDialog(Com_Parameter.ContextPath+"resource/jsp/frame.jsp?url="+encodeURIComponent(url),catelogJson,style);    
	if(!rtnVal) {
		if(!window.ReturnValue){
			return;
		}else{
			rtnVal= window.ReturnValue
		}
		
	};
	catelogJson = rtnVal;

	//修改页面上的目录
	var fdMainId = "${kmsWikiMainForm.fdId}";
	var tableObj = GetID('content_table');
	//alert("行数："+tableObj.rows.length);
	if(tableObj.rows.length>0){
		//如果有行数，则将行数删掉
		do{
			tableObj.deleteRow(0);
		}while(tableObj.rows.length>0);
	}
	//重新增加行
	for(var i=0;i<catelogJson.length;i++){
		var rowObj = tableObj.insertRow(i);
		rowObj.className = "editable_tr";
		var cellObj = rowObj.insertCell(0);
		var h3Obj = document.createElement("h2");
		h3Obj.innerHTML = "<a name='viewable_"+catelogJson[i].fdId+"'>"+catelogJson[i].fdName+"</a>";
		cellObj.appendChild(h3Obj);
		var pObj = document.createElement("p");
		pObj.innerHTML = '<span onclick="openEdit(this);return false" style="cursor: pointer;" ><a class="editButton" >编辑此段</a></span>';
		pObj.className = "editP";
		cellObj.appendChild(pObj);
		var divClear = document.createElement("div"), divObj = document.createElement("div");
		divClear.className = 'clear';
		divObj.className = "editable";
		divObj.id = "editable_"+catelogJson[i].fdId;
		divObj.innerHTML = catelogJson[i].docContent;
		cellObj.appendChild(divClear);
		cellObj.appendChild(divObj);
		rowObj.appendChild(createHidElement(i, "fdId", catelogJson[i].fdId));
		rowObj.appendChild(createHidElement(i, "fdName", catelogJson[i].fdName));
		rowObj.appendChild(createHidElement(i, "fdOrder", catelogJson[i].fdOrder));
		rowObj.appendChild(createHidElement(i, "fdMainId", fdMainId));
		rowObj.appendChild(createHidElement(i, "docContent", catelogJson[i].docContent));
		rowObj.appendChild(createHidElement(i, "fdParentId", catelogJson[i].fdParentId));
		rowObj.appendChild(createHidElement(i, "authEditorIds", catelogJson[i].authEditorIds));
		rowObj.appendChild(createHidElement(i, "authEditorNames", catelogJson[i].authEditorNames));
	}

	//重新修改右侧目录
	var right_catelog = GetID("right_ul_catelog");
	var html = "";
	for(var i=0;i<catelogJson.length;i++){
		html = html + ["<li class='catalog_f'><a onclick='window.CKEDITOR_EXTEND.scrollTo(\"H2\", "
						+ i+")' href='javascript:void(0)'>"+catelogJson[i].fdName+"</a>",'<div id="viewable_'+catelogJson[i].fdId+'"></div>','</li>'].join('');
	}
	right_catelog.innerHTML = html;
}


//创建目录的隐藏域
function createHidElement(iVal,nameVal,valueVal){
	var fdHidObj = document.createElement("input");
	//想设置name属性，ie6 ie7中必须这么写 document.createElement("<input name='select'>")   
	//判断浏览器版本 ff/ie   
	var userAgent = navigator.userAgent;   
	var isOpera = userAgent.indexOf("Opera") > -1;  
	if (userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera){
		fdHidObj = document.createElement("<input name='"+"fdCatelogList["+iVal+"]."+nameVal+"'>")
	} ; //判断是否IE浏览器   
	fdHidObj.type="hidden";  
	fdHidObj.name = "fdCatelogList["+iVal+"]."+nameVal;  
	fdHidObj.id = "fdCatelogList["+iVal+"]."+nameVal;  
	fdHidObj.value = valueVal;
	return fdHidObj;
}

//编辑器
window.onload = function(){
	if ( window.addEventListener )
		document.body.addEventListener( 'dblclick', onDoubleClick, false );
	else if ( window.attachEvent )
		document.body.attachEvent( 'ondblclick', onDoubleClick );
	CKEDITOR_EXTEND.refresh(document
			.getElementById('content_table'), document
			.getElementById("right_ul_catelog"), true);
	setTimeout("loadCatelogEditor()", 200);
};

function onDoubleClick(ev) {
	var element = ev.target || ev.srcElement;
	var name;
	do {
		element = element.parentNode;
	}
	while (element && (name = element.nodeName.toLowerCase()) && (name != 'tr' || element.className.indexOf('editable_tr') == -1) && name != 'body');
	if (name == 'tr' && element.className.indexOf('editable_tr') != -1) {
		var _$element = $(element).find('.editable');
		if (_$element.length > 0) {
			replaceDiv(_$element[0]);
		}
	}
}


//去掉编辑框
var editor;
function destroyDiv(){
	if (editor){
		editor.destroy();
	}
}

//切换编辑框
function replaceDiv(thisObj){
	destroyDiv();
	editor = CKEDITOR.replace(thisObj);//切换编辑器
	editor.on('selectionChange', function(ev) {
		CKEDITOR_EXTEND.ckeditorCategoryChange(editor, true);
	}, this);
	document.body.scrollTop = $(thisObj.parentNode.parentNode).position().top;//滚动到此段显示
}

function openEdit(thisObj){
	var editableObj = thisObj.parentNode;
	if(editableObj.nextElementSibling){
		editableObj = editableObj.nextElementSibling.nextElementSibling;
	}else{
		editableObj = editableObj.nextSibling.nextSibling;
	}
	replaceDiv(editableObj);
}


//加载页面时，如果是完善段落的，默认显示此段为编辑状态
function loadCatelogEditor(){
	var edit_catelogId = "${param.catelogId}";
	if(edit_catelogId != "" && edit_catelogId != null){
		if(catelogJson.length>0){
			var iheight = 0;
			for(var i=0;i<catelogJson.length;i++){
				if(catelogJson[i].fdParentId == edit_catelogId){
					var id = catelogJson[i].fdId;
					var edit_catelog = GetID("editable_"+id);
					if(edit_catelog != null){
						editor = CKEDITOR.replace(edit_catelog);//默认此段为编辑状态
						document.body.scrollTop = edit_catelog.parentNode.parentNode.offsetTop;
						break;
					}
				}
			}
		}
	}
}

// 更改为jquery方式请求，用于验证提交数据 by hongzq
function commitMethod(method,type){
	var url = "<c:url value='/kms/common/kms_common_portlet/kmsCommonPortlet.do' />";
	var meth = '${kmsWikiMainForm.method_GET}';
	var docSubject = $("#docSubject").val();
	if(docSubject == null || docSubject == ""){
		alert("词条名不能为空。");
		return false;
	}
	// 基础数据源
	var data = {
			"s_bean" : "kmsWikiMainCheck",
			"type" : meth,
			"fdId" : "${kmsWikiMainForm.fdId}",
			"docSubject" : encodeURIComponent(docSubject)
	};

	// 新建回调函数
	var addCallBack = function(data){
		if(data['fdIsExist'] == true){
	 		//已存在已发布的词条
	 		alert("此词条已存在,请完善最新版本。");
	 		return false;
	 	}else{
			if(data["fdIsInFlow"] == true){
				alert("此词条已在审批中，请稍候完善新版本。");
				return false;
			}
		}
		return true;
	}
	// 完善词条回调函数
	var addVersionCallBack = function(data){
		if(data['fdHasNewVersion'] == true){
	 		//已存在
	 		alert("此词条已存在新版本,请完善新版本。");
	 		return false;
	 	}
		return true;
	}
	// 继承基础数据源
	if(meth == 'addVersion'){
		jQuery.extend(data, {'fdParentId':'${kmsWikiMainForm.fdParentId}'});
	};
	var flag = true;
	// 异步请求
	$.ajax({ 
		url:url,
		data: data,
		cache : false,
		dataType : "json",
		async:false,
		success : function(data) {
			var rtnVal = data[0];
			if(meth=="add"){
				flag = addCallBack(rtnVal);
			}else if(meth=="addVersionCallBack"){
				flag = addVersionCallBack(rtnVal);
			}
		},
		error : function(error) {
			alert(error);
		}
	});	
	if(flag){
		// 验证其他内容信息
		checkOtherSubmit(method,type);
	}
}


//跳转到目录行
function selectOptionCatelog(idVal){
	var cateObj = GetID("editable_"+idVal);
	cateObj.focus();
}

//校验
function checkCategory(){
	var cateIds = GetEl("fdCategoryId").value;
	if(cateIds == "" || cateIds == null){
		alert("分类不能为空。");
		return false;
	}
	var cateIdArr = cateIds.split(";");
	if(cateIdArr.length>3){
		alert("注意分类不能超过三个");
		return false;
	}
	return true;
}

function checkReason(){
	var meth = '${kmsWikiMainForm.method_GET}';
	if(meth == 'addVersion'){
		var reason = GetEl("fdReason").value;
		if(reason == "" || reason == null){
			alert("请填写修改原因。");
			return false;
		}
		if(reason.length>200){
			alert("修改原因不能超过200字。");
			return false;
		}
	}
	return true;
}

function checkOtherSubmit(method,type){
	//  校验分类 \校验修改原因
	//if(!checkSubject()) return false;
	if(!checkCategory()) return false;
	if(!checkReason()) return false;
	//去掉编辑框
	destroyDiv();

	//将编辑器的内容都放入docContent的隐藏域里
	if(catelogJson.length>0){
		for(var i=0;i<catelogJson.length;i++){
			var _fdId = catelogJson[i].fdId;
			var contentObj = GetID("editable_"+_fdId);
			if(contentObj != null && typeof(contentObj) != "undefined"){
				//编辑段落时，不能编辑的段落内容全部隐藏。json中也为空，
				catelogJson[i].docContent = contentObj.innerHTML;
				//alert(catelogJson[i].fdOrder);
				// 替代掉url前缀，解决移动kms图片头像不显示的问题
				var  urlFlex = "http:\/\/" + location.hostname + ":" + location.port;
				GetEl("fdCatelogList["+i+"].docContent").value = contentObj.innerHTML.replace(urlFlex,'');;//将编辑框的内容放入隐藏域中
			}
		}
	}
	if(type == "false"){
		if(method=="update" && "${kmsWikiMainForm.docStatus}"=="30"){
		}else{
			GetEl("docStatus").value="20";
		}
	}else{
		GetEl("docStatus").value="10";
	}
	Com_Submit(document.kmsWikiMainForm, method, type);
}


//公共方法---获取对象
function GetEl(element){
	return document.getElementsByName(element)[0];
} 
//公共方法---获取对象
function GetID(id){
	return document.getElementById(id) ;
}

// 百科名称校验  by hongzq 2012-5-2
function validateWiki(obj){
	if(obj.value){
		$.ajax({
			url:'${kmsResourcePath}/jsp/get_json_feed.jsp',
			data:{
				"s_bean" : "kmsHomeWikiService",
				"s_method" : "getWikiByName",
				"docSubject" : encodeURIComponent(obj.value)},
			cache:false,
			dataType:"json",
			success : function(data) {
				if(data['fdId']){
					var span = document.createElement('span');
					if(data['isReview']){
						span.innerHTML='*此词条正在审批中';
					}else{
						span.innerHTML = ['*系统中已存在此词条',
											'<a href="',
											'<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=view&fdId=" />',
											data['fdId'],
											'" target=',
											'"_blank"',
											' class="',
											' validateMsg"',
											'>直接查看</a>'].join('');
					}
					$('#validateInfo').html($(span));
				}else{
					//span.innerHTML='*系统中不存在此词条名，可创建';
					$('#validateInfo').children().remove();
				}
			},
			error : function(error) {
				alert(error);
			}
		});
	}
}

function closeWindow() {
	try {
		$.ajax({
			url : '<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=editCloseLock" />',
			data : {
				"fdId" : "${param.fdId}"||"${param.fdParentId}"
			},
			cache : false,
			dataType : "json"
			});
		top.opener = top;
		top.close();
	} catch (e) {
		alert(e);
	} 
}

// 选择模板刷新页面
function callBackTemplateAction(rtnVal){
	if(rtnVal){
		var hash = rtnVal.GetHashMapArray();
		var fdTemplateId = hash[0]['id']; 
		var fdCategoryId = "${param.fdCategoryId}";
		var url = ['<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do"/>?method=add','fdCategoryId='+fdCategoryId,'fdTemplateId='+fdTemplateId].join('&');
		window.open(url,'_self');
	}
};

// 编辑状态下每55分钟延长锁定事件
<c:if test="${kmsWikiMainForm.method_GET=='edit'}">
$(function(){
	 setInterval(function(){
		 $.ajax({
				url : '<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=extendLock" />',
				data : {
					"fdId" : "${param.fdId}"
				},
				cache : false,
				dataType : "json"
				});
		 }, 60*1000*55)
	});
</c:if>

var submitForm = null;

jQuery(function($) {
	var uploadData = {
		post_params: {
			fdId: $('#cardPic').attr('fdAttId'),
			fdModelId: "${kmsWikiMainForm.fdId}",
			fdModelName: "com.landray.kmss.kms.wiki.model.KmsWikiMain",
			fdKey: "spic",
			fdAttType: "pic"
		},
		button_placeholder_id: "file_upload",
		button_image_url: Com_Parameter.ContextPath + "kms/wiki/resource/uploadCard/img/uploadCard.jpg",
		button_width: "126",
		button_height: "25",
		button_text: "<span class='uploadOpt'>上传形象照片</span>",
		button_text_style: ".uploadOpt{color:#003048;}",
		button_text_left_padding: 25,
		button_text_top_padding: 3,
		file_post_name: "formFiles[0]",
		upload_success_handler: function(file, serverData) {
			var fdAttachmentId = null;
			var xmlDom = KMS.createXMLDocument(serverData);
			jQuery("data", xmlDom).each(function() {
				if ($(this).attr("fdId")) {
					fdAttachmentId = $(this).attr("fdId");
					return;
				}
			});
			$("#cardPic")
				.attr(
				"src",
				"<c:url value='/kms/wiki/kms_wiki_att_main/kmsWikiAttMain.do?method=download&fdId='/>" + fdAttachmentId + "&_=" + new Date());
			$("#cardPic").attr("fdAttId", fdAttachmentId);
			uploadData.post_params.fdId = $('#cardPic').attr('fdAttId');
			uploadCard.updatePostParams(uploadData.post_params);
		}
	}
	var uploadCard = new UploadCard(uploadData);
});

KMS.createXMLDocument = function(string) {
	var doc;
	if (window.ActiveXObject) {
		doc = new ActiveXObject("Microsoft.XMLDOM");
		doc.async = "false";
		doc.loadXML(string);
	} else {
		doc = new DOMParser().parseFromString(string, "text/xml");
	}

	return doc;
}

</script>