<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@page import="java.util.List"%>
<script type="text/javascript">
Com_IncludeFile("jquery.js");
</script>
<script type="text/javascript"><!--
	function selectAll(srcElement,tarElement,isInverse,inverseElement){
		var srcObj=document.getElementsByName(srcElement);
		var tarObj=document.getElementsByName(tarElement);
		var inverseObj=document.getElementsByName(inverseElement);
		if(srcObj[0]!=null && tarObj!=null){
			for(var i=0;i<tarObj.length;i++){
				if(isInverse==true)
					tarObj[i].checked=!tarObj[i].checked;
				else
					tarObj[i].checked=srcObj[0].checked;
			}
		}
		if(inverseObj[0]!=null)
			inverseObj[0].checked=false;	
	}
	function getCheckList(elmentName){
		var iphoneVar=document.getElementsByName(elmentName);
		var s_iphones=null;
		if(iphoneVar!=null)
			s_iphones=new Array();
			for(var i=0;i<iphoneVar.length;i++){
				if(iphoneVar[i].checked)
					s_iphones[s_iphones.length]=iphoneVar[i].value;
			}
		return s_iphones;
	}
	function per_Submit(method){
		var phoneArr=getCheckList("phoneChk");
		var isSelect=false;
		
		if(phoneArr!=null && phoneArr.length>0){
			document.getElementsByName("s_phones")[0].value=phoneArr.join(";");
			isSelect=true;
		}
		if(isSelect==false){
			alert('<bean:message key="page.noSelect"/>');
			return isSelect;
		}
		if(confirm('<bean:message key="page.comfirmDelete"/>'))
			Com_Submit(document.forms[0],method);
	}
	function checkBoxShow(key,isDisplay){
		var labelObj=document.getElementById(key+"Label");
		if(labelObj!=null)
			labelObj.className=(isDisplay==true?"":"displayInput");
		labelObj=document.getElementById(key+"Label1");
		if(labelObj!=null)
			labelObj.className=(isDisplay==true?"":"displayInput");
		var chkList=document.getElementsByName(key+"Chk");
		if(chkList.length>0){
			for(var i=0;i<chkList.length;i++)
				chkList[i].className=(isDisplay==true?"":"displayInput");
		}
	}
	
	function showCheckBox(showOpt){
		var optBar= document.getElementById("S_OperationBar");
		optBar.style.display=(showOpt==true?"none":"");
		var optObj= document.getElementById("btnTR");
		optObj.className=(showOpt==true?"":"displayInput");
		var title=document.getElementById("titleInfo");
		if(showOpt==true)
			$(title).text('<bean:message bundle="third-pda" key="pda.license.cancel.title"/>');
		else
			$(title).text('<bean:message bundle="third-pda" key="pda.license.view.title"/>');
		checkBoxShow("iphone",showOpt);
		checkBoxShow("phone",showOpt);
	}

	//根据字段，进行升降排序
	//sort:排序字段(name|depart).
	//order:正序|反序(DESC(缺省按降序)|ASC)
	function changeSort(sort){
		var form = document.forms[0];
		form.action = '<c:url value="/third/pda/third_pda_config/pdaLicenseConfig.do?method=config&sort='+ sort +'" />';
		form.submit();
	}

	/***********************************************
	功能：设置颜色和图片路径公共方法
	参数
	    nameColor：列pda_license_sort_fullName颜色值
	    nameImg：pda_license_sort_fullName_img图片名
	    departColor：列pda_license_sort_department颜色值
	    departImg：pda_license_sort_department_img图片名
	***********************************************/ 
	function commonSetColorImg(nameColor,nameImg,departColor,departImg){
		var pda_license_sort_fullName = $('#pda_license_sort_fullName');
		var pda_license_sort_fullName_img = $('#pda_license_sort_fullName_img');
		var pda_license_sort_department = $('#pda_license_sort_department');
		var pda_license_sort_department_img = $('#pda_license_sort_department_img');
		var nameImgSrc = '<c:url value="/third/pda/resource/images/'+nameImg+ '"/>';
		var departImgSrc = '<c:url value="/third/pda/resource/images/'+departImg+ '"/>';
		pda_license_sort_fullName.css('color', nameColor);
		pda_license_sort_fullName_img.attr('src',nameImgSrc); 
		pda_license_sort_department.css('color', departColor);
		pda_license_sort_department_img.attr('src',departImgSrc);
	}

	//动态设置按钮样式
	//动态设置按钮样式
	function dynamicSetButColor(sort){
		if(sort==""|| sort=='name'){
			commonSetColorImg('red','asc.png','black','asc2.png');
		}else if(sort=='depart'){
			commonSetColorImg('black','asc2.png','red','asc.png');
		}
	 }

	 //nameProcessMouseOut
	 function nameProcessMouseOut(sort,attrName){
      	if(sort==attrName || sort==""){
  			commonSetColorImg('red','asc.png','black','asc2.png');
        }else{
  			commonSetColorImg('black','asc2.png','red','asc.png');
        }
	 }

	 //departProcessMouseOut
	 function departProcessMouseOut(sort,attrName){
	    if(sort==attrName){
 			commonSetColorImg('black','asc2.png','red','asc.png');
        }else{
 			commonSetColorImg('red','asc.png','black','asc2.png');
        }
	 }

	 //页面加载的时候需要加载函数
	 $(document).ready(function(){

		var sort =  $('#sort').val();
		dynamicSetButColor(sort);

        $("#name").click(function(){
          changeSort($(this).attr('id'));
          return false;
        });
        $("#name").mouseover(function(){
        	dynamicSetButColor($(this).attr('id'));
            return false;
        });
        $("#name").mouseout(function(){
            var attrName = $(this).attr('id');
        	dynamicSetButColor(attrName);
        	nameProcessMouseOut(sort,attrName);
            return false;
        });

	    $("#depart").click(function(){
	       changeSort($(this).attr('id'));
	       return false;
	    });
	    $("#depart").mouseover(function(){
	    	dynamicSetButColor($(this).attr('id'));
		   return false;
		});
	    $("#depart").mouseout(function(){
	    	var attrName = $(this).attr('id');
	    	dynamicSetButColor(attrName);
	    	departProcessMouseOut(sort,attrName);
		   return false;
		});
	    
	 })
	
</script>
<style>
	.displayInput{
		display:none;
	}
    a:link,a:visited{ text-decoration:none;  /*超链接无下划线*/}
    a:hover{ text-decoration:underline;  /*鼠标放上去有下划线*/}     
	
</style>
<c:if test="${PhoneUseFlag!=0 && PhoneUseFlag!=-1}">
	<div id="optBarDiv">
	<input type="button"
		value="<bean:message key="pda.button.add" bundle="third-pda"/>"
		onclick="Com_OpenWindow('<c:url value='/third/pda/third_pda_config/pdaLicenseConfig.do?method=config&isAdd=1'/>','_blank')" />
	<input type="button" value="<bean:message key="pda.button.delete.btn" bundle="third-pda"/>"
		onclick="showCheckBox(true);" />
	<input type="button" value="<bean:message bundle="third-pda" key="pda.button.delete"/>"
		onclick="Com_Submit(document.forms[0],'update');" />
	</div>
	<div>
	    <center>
	    <table class="tb_noborder" width="95%">
	      <tr>
	          <td width="80px" >
	          	<div>
                   <bean:message key="pda.license.sort.title" bundle="third-pda" />：
                </div>
	          </td>
	          <td width="80px" align='left'>
	               <div>
		               <a href="javaScript:void(0)" id="name" float='left'>
		                  <div id = "pda_license_sort_fullName" style="color:''">
		                     <bean:message key="pda.license.sort.fullName" bundle="third-pda" />
		                     <img id="pda_license_sort_fullName_img" src="" border='0px' float='left'>
		                  </div>
			           </a>
		           </div>
	           </td>
	           <td width="80px" align='left'>
	               <div>
		               <a href="javaScript:void(0)" id="depart" float='left'>
		                  <div id = "pda_license_sort_department" style="color:''">
		                     <bean:message key="pda.license.sort.department" bundle="third-pda" />
		                     <img id="pda_license_sort_department_img" src="" border='0px' float='left'>
		                  </div>
			           </a>
		           </div>
              </td>
              <td>
              	&nbsp;
              </td>
	      </tr>
	    </table>
	    </center>
	</div>
</c:if>
<p class="txttitle" id='titleInfo'><bean:message key="pda.license.view.title" bundle="third-pda"/></p>
<form
	action="<c:url value="/third/pda/third_pda_config/pdaLicenseConfig.do"/>" method="post"  autocomplete="off">
	<input type="hidden" name="s_iphones" value=""/>
	<input type="hidden" name="s_phones" value=""/>
	<input type="hidden" id="sort" name="sort" value="${sort}"/>
	
	<center>
	<table class="tb_normal" width=95%>
		<c:set var="phoneSize" value="0"/>
		<tr>
			<td class="td_normal_title" width=100%>
			<c:choose>
				<c:when test="${PhoneUseFlag==0 }">
					<font color="red"><bean:message key="pda.lecense.warnning.noFunction" bundle="third-pda"/></font>
				</c:when>
				<c:when test="${PhoneUseFlag==-1}">
					<bean:message key="pda.lecense.warnning.unlimit" bundle="third-pda"/>
				</c:when>
				<c:otherwise>
					<bean:message key="pda.license.phone.title" bundle="third-pda"/>
					<c:if test="${phoneMap!=null }">
						<c:set var="phoneSize" value="${fn:length(phoneMap)}"/>
					</c:if>
					 （<bean:message key="pda.lecense.warnning.lincenseinfo" bundle="third-pda"/>${PhoneUseFlag}，
					  <bean:message key="pda.lecense.warnning.lincenseinfo.used" bundle="third-pda"/>${phoneSize}）&nbsp;&nbsp;&nbsp;
					<c:if test="${phoneSize>0}">
						<label class="displayInput" id="phoneLabel"><input type="checkbox" name="phoneChkAll" onclick="selectAll('phoneChkAll','phoneChk',false,'phoneChkAll1');" />
				     		<bean:message key="pda.license.selectAll" bundle="third-pda" />
						</label> &nbsp;&nbsp;&nbsp;
						<label class="displayInput" id="phoneLabel1"><input type="checkbox" name="phoneChkAll1" onclick="selectAll('phoneChkAll1','phoneChk',true,'phoneChkAll');" />
				     		<bean:message key="pda.license.disSelect" bundle="third-pda" />
						</label> &nbsp;&nbsp;&nbsp;
					</c:if>
					<c:if test="${PhoneUseFlag < phoneSize}">
						<br/>
						<font color="red"> <b>
							<bean:message key="pda.license.warnning" bundle="third-pda" /></b>
						</font>
					</c:if>
				</c:otherwise>
			</c:choose>
			</td>
		</tr>
		<c:if test="${phoneSize>0}">
			<tr>
				<td>
				<table class="tb_noborder" width="100%">
					<c:set var="rowSize1" value="${phoneSize%3==0?(phoneSize/3):(phoneSize/3+1)}"/>
					<c:forEach var="rowIndex1" begin="0" end="${rowSize1-1}" step="1">
						<tr>
							<c:forEach var="colIndex1" begin="0" end="2" step="1">
								<c:choose>
									<c:when test="${phoneSize>(rowIndex1*3+colIndex1)}">
										<td width="33%">
											<c:set var="person" value="${ phoneMap[rowIndex1*3+colIndex1]}"/>
											<label> <input class="displayInput" type="checkbox" name="phoneChk"	value="${person.fdId}" />
													${person.fdName}<c:if test="${person.fdIsAvailable==true}">（${person.fdParent.fdName}）</c:if>
										 			<c:if test="${person.fdIsAvailable==false}">
														<font color="red"><bean:message bundle="third-pda" key="pda.lecense.status.discate" /></font>
													</c:if> 
											</label>
										</td>
									</c:when>
									<c:otherwise>
										<td width="33%">&nbsp;</td>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</tr>
					</c:forEach>
				</table>
				</td>
			</tr>
		</c:if>
		<tr id="btnTR" class="displayInput">
			<td align="center">
				<input class="btnopt" type="button" value="<bean:message key="button.ok"/>" onclick="per_Submit('delete');" />
				&nbsp;&nbsp;&nbsp;
				<input class="btnopt" type="button" value="<bean:message key="button.cancel"/>" onclick="showCheckBox(false);"/>
			</td>
		</tr>
	</table>
	
	</center>
</form>
<%@ include file="/resource/jsp/edit_down.jsp"%>