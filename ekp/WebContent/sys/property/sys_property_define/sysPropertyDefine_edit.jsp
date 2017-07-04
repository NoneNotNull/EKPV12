<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page
	import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("jquery.js|calendar.js|dialog.js");
</script>
<kmss:windowTitle subject="${sysPropertyDefineForm.fdName}"
	subjectKey="sys-property:table.sysPropertyDefine"
	moduleKey="sys-property:module.sys.property" />
<html:form
	action="/sys/property/sys_property_define/sysPropertyDefine.do">
	<div id="optBarDiv"><c:if
		test="${sysPropertyDefineForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="if(validate()) Com_Submit(document.sysPropertyDefineForm, 'update');">
	</c:if> <c:if test="${sysPropertyDefineForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="if(validate()) Com_Submit(document.sysPropertyDefineForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="if(validate()) Com_Submit(document.sysPropertyDefineForm, 'saveadd');">
	</c:if> <input type="button" value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();"></div>
	<p class="txttitle"><bean:message bundle="sys-property"
		key="table.sysPropertyDefine" /></p>
	<center>
	<table class="tb_normal" width=95%>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-property" key="sysPropertyDefine.fdName" /></td>
			<td width="35%"><html:text property="fdName" style="width:85% "
				styleId="fdName" onblur="checkDefineName(false)" /> <SPAN
				class=txtstrong>*</SPAN>&nbsp;&nbsp; <%-- 标识是否重启hibernate session --%>
			<xform:text property="fdIsHbmChange" value="false"
				showStatus="noShow" /></td>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-property" key="sysPropertyDefine.enabled" /></td>
			<td width="35%"><xform:radio property="fdStatus">
				<xform:enumsDataSource enumsType="sys_property_define_fd_status" />
			</xform:radio></td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-property" key="sysProperty.sysPropertyCategory" /></td>
			<td colspan="3" width="35%"><xform:text property="categoryName"
				style="width:85%" /> <xform:text property="categoryId"
				showStatus="noShow" /> <a href="javascript:void(0)"
				onclick="selectCategory();"><bean:message key="button.select" /></a>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-property" key="sysPropertyDefine.fdType" /></td>
			<td width="35%"><c:if
				test="${sysPropertyDefineForm.method_GET=='add'}">
				<xform:select property="fdType" onValueChange="sysPropTypeChange">
					<xform:customizeDataSource
						className="com.landray.kmss.sys.property.service.spring.SysPropertyDefineType" />
				</xform:select>
			</c:if> <c:if test="${sysPropertyDefineForm.method_GET=='edit'}">
				<xform:select property="fdType" onValueChange="sysPropTypeChange"
					showStatus="readOnly">
					<xform:customizeDataSource
						className="com.landray.kmss.sys.property.service.spring.SysPropertyDefineType" />
				</xform:select>
			</c:if></td>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-property" key="sysPropertyDefine.fdStructureName" /></td>
			<td width="35%"><c:if
				test="${sysPropertyDefineForm.method_GET=='add'}">
			 	att_<xform:text property="fdStructureName" htmlElementProperties="id=fdStructureName" 
					value="${sysPropertyDefineForm.fdStructureName}" onValueChange="checkStructureName" style="width:55%"/>
			</c:if> <c:if test="${sysPropertyDefineForm.method_GET=='edit'}">
				att_<xform:text property="fdStructureName"
					value="${sysPropertyDefineForm.fdStructureName}" htmlElementProperties="id=fdStructureName"  style="width:35%"
					showStatus="view" />
			</c:if></td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-property" key="sysPropertyDefine.fdDisplayType" /></td>
			<td colspan="3" width="85%">
			<div style="vertical-align: top;"><c:forEach
				items="${displayTypeMap}" var="displayType" varStatus="vstatus">
				<label title='<c:out value="${displayType.value}" />'> <input
					type="radio" name="fdDisplayType" value="${displayType.key}"
					<c:if test="${sysPropertyDefineForm.method_GET=='add'}">onclick="sysPropTypeChange(this.value,this);"</c:if>
					<c:if test="${sysPropertyDefineForm.method_GET=='edit'}">disabled="disabled"</c:if>
					<c:if test="${sysPropertyDefineForm.fdDisplayType==displayType.key}">checked</c:if> />
				<c:out value="${displayType.value}" />&nbsp;&nbsp; </label>
			</c:forEach> <span class="txtstrong">*</span> <tt id='otherMsg'
				style='display: none'><bean:message bundle="sys-property"
				key="sysPropertyDefine.display.type.otherMsg" /></tt></div>
			<br />
			<bean:message bundle="sys-property"
				key="sysPropertyDefine.preViewImg" /><br />
			<br />
			<span style="border: 1px dashed black;"> <c:if
				test="${not empty defineMap['previewImage']}">
				<img src='<c:url value="${defineMap['previewImage']}" />' />
			</c:if> </span></td>
		</tr>
		<c:if test="${not empty defineMap['configFile']}">
			<c:import url="${defineMap['configFile']}" charEncoding="UTF-8" />
		</c:if>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-property" key="sysPropertyDefine.fdMoreOptions" /></td>
			<td colspan="3" width="85%"><xform:checkbox
				property="fdMoreOptions" onValueChange="sysPropMoreOptionsChange">
				<xform:simpleDataSource value="jsp">
					<bean:message bundle="sys-property"
						key="sysPropertyDefine.fdJspPrev.insert" />
				</xform:simpleDataSource>
				<xform:simpleDataSource value="desc">
					<bean:message bundle="sys-property"
						key="sysPropertyDefine.fdDescription.insert" />
				</xform:simpleDataSource>
				<xform:simpleDataSource value="unit">
					<bean:message bundle="sys-property"
						key="sysPropertyDefine.fdUnit.insert" />
				</xform:simpleDataSource>
			</xform:checkbox></td>
		</tr>
		<tr id="tr_jsp"
			<c:if test="${empty sysPropertyDefineForm.fdJspPrev}">style="display:none"</c:if>>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-property" key="sysPropertyDefine.fdJspPrev" /></td>
			<td colspan="3" width="85%"><xform:textarea property="fdJspPrev"
				style="width:85%;height:250px;" /> <br />
			(<bean:message bundle="sys-property"
				key="sysPropertyDefine.fdJspPrev.note1" /><font color="red"><bean:message
				bundle="sys-property" key="sysPropertyDefine.fdJspPrev.note2" /></font>)</td>
		</tr>
		<tr id="tr_desc"
			<c:if test="${empty sysPropertyDefineForm.fdDescription}">style="display:none"</c:if>>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-property" key="sysPropertyDefine.fdDescription" /></td>
			<td colspan="3" width="85%"><xform:textarea
				property="fdDescription" style="width:85%;" /><br />
			(<bean:message bundle="sys-property"
				key="sysPropertyDefine.fdDescription.note" />)</td>
		</tr>
		<tr id="tr_unit"
			<c:if test="${empty sysPropertyDefineForm.fdUnit}">style="display:none"</c:if>>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-property" key="sysPropertyDefine.fdUnit" /></td>
			<td colspan="3" width="85%"><xform:text property="fdUnit"
				style="width:50%;" /> (<bean:message bundle="sys-property"
				key="sysPropertyDefine.fdUnit.note" />)</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-property" key="sysPropertyDefine.fdRemarks" /></td>
			<td colspan="3" width="85%"><xform:textarea property="fdRemarks"
				style="width:85%" /></td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-property" key="sysPropertyDefine.fdTemplateNames" /></td>
			<td colspan="3" width="85%"><c:out
				value="${sysPropertyDefineForm.fdTemplateNames}" /></td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-property" key="sysPropertyDefine.docCreator" /></td>
			<td width="35%"><xform:address propertyId="docCreatorId"
				propertyName="docCreatorName" orgType="ORG_TYPE_PERSON"
				showStatus="view" /></td>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-property" key="sysPropertyDefine.docCreateTime" /></td>
			<td width="35%"><xform:datetime property="docCreateTime"
				showStatus="view" /></td>
		</tr>
		<%-- 所属场所 --%>
		<%
			if (ISysAuthConstant.IS_AREA_ENABLED) {
		%>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="sysAuthArea.authArea" bundle="sys-authorization" /></td>
			<td colspan="3"><input type="hidden" name="authAreaId"
				value="${sysPropertyDefineForm.authAreaId}"> <xform:text
				property="authAreaName" showStatus="view" /></td>
		</tr>
		<%
			}
		%>
	</table>
	</center>
	<html:hidden property="fdId" />
	<html:hidden property="method_GET" />
	<html:hidden property="fdStructureName" />

	<script>
	$KMSSValidation();
	function checkDefaultValueA(){
		obj=$("input[name='param(fd_default_value)']") ;
		val=$("input[name='param(fd_default_value)']").val();
		if(val)
		    return  checkDefaultValue(val,obj);
		else
			return true ;
	 }
	function checkDefaultValue(val,obj){
	 if(val=='')
			return true ;
	 var fdType=$("select[name='fdType']").val() ;
	 var displayType="" ;
	 var obja=document.getElementsByName("param(fd_options_source)") ;
	 $("input[name='fdDisplayType']").each(function(){
            if(this.checked){
           	 displayType=this.value ;
             }
		 }) ;  
	 
	  if(displayType=='radio' || displayType=='select' || displayType=='checkbox'  ) {
		 if(checkNotNull()){ //备选项目输入规范
		   if(obja!=null){
			    var flag = -1 ;
      	    for(var i=0;i<obja.length;i++){
     		     if(  obja[i].checked  ){
     		    	flag=i  ;
     		    	break ;
         		   }
      	    }
    	  if(flag>=0){
    		  if(obja[flag].value=='input') { 
    		    str = document.getElementsByName("param(fd_options)")[0].value ;
    		    var hasvaule=false ;
	  	          if(displayType=='checkbox'){  //多值
	  	        	  hasvaule=chekValueMore(val,str);
	  	          }else //单值
	  	        	  hasvaule=chekValueOne(val,str);
	        	  
                if(hasvaule){
                    	 return true ;
                     }else{
                         alert('必须取备选项“|”后面的值作为默认值，请重新输入') ;
                        // obj.value="";
                         obj.focus() ;
                         return false ;
                         }
		        }
    	  }
        } 
       }
	 }
		 return true ;
 }	

	function chekValueOne(defval,inputVal){
		var  hasEqual=false ;
		str = inputVal.replace(/^\s+|\s+$/g,"");//去掉前后空格
        if(str!=''){
           var  txtArray =str.split("\n");
		   for(i=0;i< txtArray.length;i++) {
				var txt=txtArray[i].replace(/^\s+|\s+$/g,"") ;
				if(txt!=''){ 
				 var aa=txt.split('|') ;
				 if(defval== aa[1].replace(/^\s+|\s+$/g,"") ){
					hasEqual=true ;
					break ;
				  }
	         }  
          }
	  }
  	  return  hasEqual ;
	}

	function chekValueMore(defval,inputVal){
		var f=true ;
		if(defval.indexOf(";")>0){
			var arrayT=defval.split(";") ;
            for(j=0;j<arrayT.length;j++) {
                if(arrayT[j]!=''){
            	 var flag=chekValueOne(arrayT[j],inputVal);
            	 if(!flag) {
                    f=flag ;
                    break ;
                 }
             }
           }
		}else
            f=chekValueOne(defval,inputVal) ;
	    return  f ;
	}

	 
	function sysPropTypeChange(){
		
		var name = $("input[name='fdName']").val();
		var type = $("select[name='fdType']").val();
		var categoryId = $("input[name='categoryId']").val();
		var displayType = $("input:radio[name='fdDisplayType']:checked").val();
		var url = '<c:url value="/sys/property/sys_property_define/sysPropertyDefine.do" />?method=add';
		url = Com_SetUrlParameter(url, "name", name);
		url = Com_SetUrlParameter(url, "type", type);
		url = Com_SetUrlParameter(url, "categoryId", categoryId);
		location.href = Com_SetUrlParameter(url, "displayType", displayType);
		return ;
	}
	
	function sysPropMoreOptionsChange(val, elem){
		if(val.indexOf("jsp") >= 0) {
			$("#tr_jsp").show();
		}else{
			document.getElementsByName("fdJspPrev")[0].value="";
			$("#tr_jsp").hide();
		}
		if(val.indexOf("desc") >= 0) {
			$("#tr_desc").show();
		}else{
			document.getElementsByName("fdDescription")[0].value="";
			$("#tr_desc").hide();
		}
		if(val.indexOf("unit") >= 0) {
			$("#tr_unit").show();
		}else{
			document.getElementsByName("fdUnit")[0].value="";
			$("#tr_unit").hide();
		}
	}

	//提交验证
	function validate(){
		return checkDefineName(true) && checkStructureName(true) && checkNotNull() && checkDefaultValueA();
	}

	function checkDefineName(checkNull){
		//提交前，校验属性名称唯一性
		var fdName=document.getElementById("fdName").value ; 
		var fdId='${sysPropertyDefineForm.fdId}';
		
		if(fdName){
			fdName=encodeURI(fdName) ; //中文两次转码
			fdName=encodeURI(fdName)  ;
			var url="sysPorpertyDefineCheckService&type=1&fdName="+fdName+"&fdId="+fdId;
			var data = new KMSSData(); 
			var rtnVal =data.AddBeanData(url).GetHashMapArray()[0];
			var flag=rtnVal["flag"];
	   		if(flag==0){
	   			return true;
	   		}
		   	if(flag==1){
	   			 alert("属性名称已存在，请更换属性名称。");
	   			 return false;
		   	}
		   	return true  ;
		}else{
			if(checkNull){
			  	alert("属性名称不能为空。");
			  	return false;
			}else
				return true ;
		}
	}
	function checkStructureName(checkNull){

		var method = "${sysPropertyDefineForm.method_GET}";
		if(method=="edit"){return true;};
		//提交前，校验属性名称唯一性
		var fdStructureName=document.getElementById("fdStructureName").value; 
		var fdId='${sysPropertyDefineForm.fdId}';
		
		if(fdStructureName){
			fdStructureName=encodeURI(fdStructureName);  
			fdStructureName=encodeURI(fdStructureName);
			var url="sysPorpertyDefineCheckService&type=2&fdStructureName="+fdStructureName+"&fdId="+fdId;
			var data = new KMSSData(); 
			var rtnVal =data.AddBeanData(url).GetHashMapArray()[0];
			var flag=rtnVal["flag"];
	   		if(flag==0){
	   			return true;
	   		}
		   	if(flag==2){
		   		 alert("字段名称已存在，请更换字段名称。");
		   		 return false;
			}
		   	return true  ;
		}else{
			if(checkNull){
			  	alert("字段名称不能为空。");
			  	return false;
			}else
				return true ;
		}
	}

	var type='${sysPropertyDefineForm.fdType}';
	var displayType='${sysPropertyDefineForm.fdDisplayType}';

	
	function checkNotNull(){
	  var obj=document.getElementsByName("param(fd_options_source)") ;
	  if(obj!=null){
			    var flag = -1 ;
        	    for(var i=0;i<obj.length;i++){
       		     if(  obj[i].checked  ){
       		    	flag=i  ;
       		    	break ;
           		   }
        	    }
      	  if(flag>=0){
      	      if(obj[flag].value=='input') { 
      	    	str = document.getElementsByName("param(fd_options)")[0].value ;
  	        	str = str.replace(/^\s+|\s+$/g,"");//去掉前后空格
      	          if(str!=''){
          	         var  txtArray =str.split("\n");
          	         var  arrayObj=new Array();
          	          for(i=0;i< txtArray.length;i++) {
          	        	var txt=txtArray[i].replace(/^\s+|\s+$/g,"") ;
							if(txt!=''){ 
								 var aa=txt.split('|') ;
								 if(aa.length!=2 ) 
									  return showError() ;
								 if (aa[1]!=null && aa[1].replace(/^\s+|\s+$/g,"")=='') 
									  return showError() ;
								 if(type=='Long'){
									 if(parseInt(aa[1])!=aa[1]) 
									  return  showError() ;
							      }
							  }
								 for(k = 0;k < arrayObj.length;k++){
									 if(arrayObj[k] ==aa[1].replace(/^\s+|\s+$/g,"")){
										 alert('“|”后面的值不能重复，请修改') ;
										 document.getElementsByName("param(fd_options)")[0].focus();
										 return false ;
								     }
								 }
							  arrayObj.push(aa[1].replace(/^\s+|\s+$/g,"")) ;
							}
						 return true ;
          	        }else{
          	        	 alert('选项来源不可为空或空格') ; 
          	        	 document.getElementsByName("param(fd_options)")[0].focus();
          	        	 return false ; 
              	        }
          	         
      	        }
                if(obj[flag].value=='sql'){
                	 str = document.getElementsByName("param(fd_sql)")[0].value ;
       	        	 str = str.replace(/^\s+|\s+$/g,"");
                	 if(str==''){ 
                		 alert('选项来源不可为空或空格') ; 
	          	         document.getElementsByName("param(fd_sql)")[0].focus();
      	    	         return false; 
          	          }
		         }
         } 
	} 
	 return true ;
 }	

function showError() {
	 alert('请参考图例，输入正确值') ;
	 document.getElementsByName("param(fd_options)")[0].focus();
	 return false ;
}	 

 
$(document).ready(function(){
	
		$("input[name='_fdMoreOptions']").each(function(){
			if(this.value=="jsp" && document.getElementsByName("fdJspPrev")[0].value.length>0){
	    		$(this).attr("checked",true);
			}
			if(this.value=="desc" && document.getElementsByName("fdDescription")[0].value.length>0){
		    	$(this).attr("checked",true);
			}
			if(this.value=="unit" && document.getElementsByName("fdUnit")[0].value.length>0){
		    	$(this).attr("checked",true);
			}
		});

		if( type.length>0){
		  var method="${sysPropertyDefineForm.method_GET}";
		  if(method=='add'){
			if(type=='String'){
                  if(displayType=='textarea')
                	  document.getElementsByName("param(fd_field_length)")[0].value="255";
                  else
                	  document.getElementsByName("param(fd_field_length)")[0].value="255"; 

      	     }
			if(type=='Long'){
				 document.getElementsByName("param(fd_field_length)")[0].value="10"; 
			}
			if(type=='Double'){
				 document.getElementsByName("param(fd_field_length)")[0].value="12"; 
				 document.getElementsByName("param(fd_scale)")[0].value="2"; 
			}
		 }
		}
       if(displayType.length>0){
           if(displayType=='select' || displayType=='checkbox'|| displayType=='radio'){
          	   var obj=document.getElementsByName("param(fd_options_source)") ;
          	   var flag=true ;
         	   for(var i=0;i<obj.length;i++){
         		 // alert(obj[i].checked);
        		    if(  obj[i].checked  ){
        		    	flag=false  ;
            		   }
         	     }
       	        if(flag){
       	        	obj[0].checked =true ;
       	        	sysPropSourceChange(obj[0].value) ;//显示输入框
           	        } 
               }
           }
      showOtherMsg() ;     
});
function showOtherMsg(){
	if(type=='String' || type=='Double' || type=='Long' )
		$("#otherMsg").show() ;
}

/**
 * 修改分类
 */
function selectCategory(){
	var keys = "sys-simplecategory:dialog.maintree.title;sys-simplecategory:dialog.main.title";
	var arr = Data_GetResourceString(keys);
	var treeTitle = arr[0];
	var winTitle = arr[1];
	var url = 'sysPropertyCategoryListService&categoryId=!{value}';
	this.Dialog_Tree(false, "categoryId", "categoryName", null,url, treeTitle,null, null, "", null, false, winTitle);
}

</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>