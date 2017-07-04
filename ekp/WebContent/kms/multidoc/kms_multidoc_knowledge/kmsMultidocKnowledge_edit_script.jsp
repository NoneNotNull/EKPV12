<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="${kmsResourcePath }/js/kms_docUtil.js"></script>
<script type="text/javascript">

$(document).ready(function() {
	//初始化默认属性
	initDefineProperty();
	//显示作者
	~function() {
		var g = $("#method_GET").val();
		if (g == 'edit') {
			var s = $("#outerAuthor").val();
			if (s != null && s.length > 0) { // 显示外部作者
				document.getElementById("author2").checked = "checked";
				document.getElementById("authorType1").style.display = "none";
				document.getElementById("authorType2").style.display = "block";
			} else { // 显示内部作者
				document.getElementById("author1").checked = "checked";
				document.getElementById("authorType1").style.display = "block";
				document.getElementById("authorType2").style.display = "none";
			}
		}
		if (g == 'add') { // 内部作者优先
			document.getElementById("author1").checked = "checked";
			document.getElementById("authorType1").style.display = "block";
			document.getElementById("authorType2").style.display = "none";
		}
	}()
});



/**
 * 初始化默认属性
 */
function initDefineProperty(){
	var url = this.location.href;
	var defineProperty='${param.defineProperty}';
	if(defineProperty=="true"){
		var num = url.indexOf("defineProperty=true");
		var len = "defineProperty=true".length;
		//解析字符串默认属性
		anatomyKeyValue(url.substring(num+len+1));
	}
}

/**
 * 解析字符串设置属性
 */
function anatomyKeyValue(str){
	
	var propertys = str.split("&");
	var len = propertys.length;
	var prefix = "extendDataFormInfo.value(";
	var suffix = ")";
	var keyValue,key,value,elem;
	for(var i=0;i<len;i++){
		keyValue = propertys[i].split("=");
		key = prefix + keyValue[0] + suffix;
		value = keyValue[1];
		elem = document.getElementsByName(key);
		if(!elem || elem.length<=0) continue;
		//文本框
		if(elem[0].type=="text"){
			elem[0].value = value;

		}else if(elem[0].type=="hidden"){
			var _elem = document.getElementsByName("_"+key);
			//文本选择（地址、组织架构）
			if(!_elem){
				elem[0].value = value;
			}
			//复选框
			elem = _elem;
			var elen = elem.length;
			for(var j=0;j<elen;j++){
				if(value.indexOf(elem[j].value)>=0){
					if(elem[j].type=="checkbox"){
						$(elem[j]).trigger("click");
					}
				}
			}
			
		//下拉框
		}else if(elem[0].type=="select-one"){	
			elem = elem[0].children;
			var elen = elem.length;
			for(var j=0;j<elen;j++){
				if(elem[j].value==value){
					elem[j].selected=true;
					break;
				}
			}

		//单选
		}else if(elem[0].type=="radio"){
			var elen = elem.length;
			for(var j=0;j<elen;j++){
				if(elem[j].value==value){
					elem[j].checked=true;
					break;
				}
			}
		}
	}
}

 //点击新版本
function showNewEdtion(obj){
 	var url=obj.rev ;
 	var version =Dialog_PopupWindow(url, 497, 310);
	 	if(version != null){
	 		var href = assemblyHref();
 		href =  href + "&version="+version;
 		window.location.href = href;
	}
}
 
function assemblyHref(){
	var href = window.location.href;
	var reg = /method=\w*/;
	href = href.replace(reg,"method=newEdition");
	var reg1 = /fdId/;
	href = href.replace(reg1,"originId");
	return href;
}
 
/**
 * 显示评分星
 */
function showStars()  {
	var staron= "<img border='0' width='30px' height='30px' src='"+Com_Parameter.ContextPath+"kms/common/resource/kms_resource_kms_custome/star_on_30.gif'/>"
	var staroff="<img border='0' width='30px' height='30px' src='"+Com_Parameter.ContextPath+"kms/common/resource/kms_resource_kms_custome/star_off_30.gif'/>"
	var starhalf="<img border='0' width='30px' height='30px' src='"+Com_Parameter.ContextPath+"kms/common/resource/kms_resource_kms_custome/star_half_30.gif'/>"
	var starons="" ;
	var staroffs="" ;
	var score=document.getElementById('docScore').value;
	var a=score.substr(0,1);
	var b=score.substr(2,1);
	var count=0;
 	if(a>0){ 
   		for(i=0;i<a;i++){
   			starons=starons+staron;
   			count ++ ;
       	}
 	}
    if(b>0){
		starons=starons+starhalf;
		count ++ ;
    }
  	if(count<5) {
	   	for(j=count;j<5;j++){
		   	staroffs=staroffs+staroff;
		} 
   	}
	return starons+staroffs ;
} 

// 打开同类文档
function openDocWindow(fdId){
	var url="kmsMultidocKnowledge.do?method=view&fdId="+fdId;
	Com_OpenWindow(url,"_blank");
} 

/**
 * 标题类别必填校验
 */	 	
function  checkCategory(){
	var title=document.getElementById("docSubject")  ;
	if($.trim(title.value)==''){
		showAlert("<bean:message bundle="kms-common" key="title.emptyValidate" />") ;	
		title.value='' ;
		title.focus() ;
		   return false ;	 
	}
	var cid=document.getElementById("fdDocTemplateId").value  ;
	if(cid==''){
	   	showAlert("<bean:message bundle="kms-common" key="category.emptyValidate" />!<br><bean:message bundle="kms-common" key="category.emptyMsg" />") ;	
    	return false ;
	}
	clearAuthor();
	return true ;
}


/**
 * 清理未选择的作者 
 */
function clearAuthor(){
	var a=document.getElementsByName("authorType");
	var c=0 ;
	for(var ii=0;ii<a.length;ii++){
   	if( a[ii].checked ){
  	  		c= a[ii].value;
		}
	}
	if(c>0){
		if(c==1) {
			document.getElementsByName("outerAuthor")[0].value='' ;	
		}
		if(c==2) {
			document.getElementById("docAuthorId").value='' ;
			document.getElementById("docAuthorName").value='' ;
	   }
	} 

}

/**
 * 选择作者
 */
function changeAuthor(v) {
	if(v==1){
		document.getElementById("authorType1").style.display="block";
		document.getElementById("authorType2").style.display="none";  
	} 
	if(v==2){
		document.getElementById("authorType1").style.display="none";
		document.getElementById("authorType2").style.display="block";   
	}          
}

//显示属性
function showPropertyList(){
	var $propertyList=$('#propertyList') ;
	var img=document.getElementById('imgShow');
	var word=$('#wordShow') ;
	if($(word).text()=='<bean:message bundle="kms-common" key="links.fold" />'){
	  	$(word).text('<bean:message bundle="kms-common" key="links.unFold" />');
	  	img.src ='${kmsResourcePath }/img/ic_cocl.gif';
	 }else{
	 	$(word).text('<bean:message bundle="kms-common" key="links.fold" />');
	  	img.src ='${kmsResourcePath }/img/ic_coop.gif' ;
	}

	if($propertyList){ 
		var $rows = $propertyList.find('tr');
		$rows.each(function (index){
			$(this).toggle(); 
		});
	}
}

function gotoIndex(){
	window.open("<c:url value='/kms/common/kms_common_main/kmsCommonMain.do?method=module' />","_self");
}

function gotoMultidocCenter(){
    window.open("<c:url value='/kms/common/kms_common_main/kmsCommonMain.do?method=module&fdId=com.landray.kmss.kms.multidoc' />","_self");
}

function resetTemplate(){
	showConfirm("<bean:message bundle="kms-common" key="category.update" />",showSelectTemplate,true );
}
function showSelectTemplate(){
	artDialog.navSelector("<bean:message bundle="kms-common" key="category.againSelect" />", addoptions, navOptions);
	
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
			showAlert("<bean:message bundle="kms-common" key="category.select" />") ;
			return false;
		}
		if(selectedCache.last()._data["isShowCheckBox"]=="0"){
			art.artDialog.alert("<bean:message bundle="kms-common" key="category.noLimits" />");
			return;
		}
		var fdCategoryId = selectedCache.last()._data["value"];
		window.open('<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do"/>?method=add&fdTemplateId=' + fdCategoryId,'_self');
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


</script> 