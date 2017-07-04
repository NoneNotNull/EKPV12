<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<tr>
		<td class="td_normal_title" width=20%>
			<bean:message bundle="kms-integral" key="kmsIntegralCommon.docSubject"/>
		</td><td width="80%">
			<xform:text property="docSubject" style="width:85%" required="true"/>
		</td>
</tr>
<tr>
		<td class="td_normal_title" width=20%>
			<bean:message  bundle="kms-integral" key="kmsIntegralCommon.fdTimeUnit"/>
		</td><td width=80%>
			<input type="radio" value="1" name="fdTimeUnit" <c:if test="${null == fdTimeUnit || 1 == fdTimeUnit}">checked</c:if> onclick="refreshTimeUnitDisplay(value);" id="monthTimeUnit"> 
			<bean:message  bundle="kms-integral" key="kmsIntegralCommon.fdTimeUnit.month"/>

			<input type="radio" value="3" name="fdTimeUnit" <c:if test="${3 == fdTimeUnit}">checked</c:if> onclick="refreshTimeUnitDisplay(value);" id="yearTimeUnit"> 
			<bean:message  bundle="kms-integral" key="kmsIntegralCommon.fdTimeUnit.year"/>
		</td>
</tr>
<tr>
	<td class="td_normal_title" width=20%>
			<bean:message bundle="kms-integral" key="kmsIntegralCommon.fdCountTime"/>
	</td>
	<td width=80% id="month">	
			<input type='hidden' name='monthPeriodType' value='1'/>
			<bean:message  bundle="kms-integral" key="kmsIntegralCommon.fdTimeUnit.timeStart"/>
			<kmss:period property="monthStartTime" periodTypeName="monthPeriodType"/>
			<bean:message  bundle="kms-integral" key="kmsIntegralCommon.fdTimeUnit.timeEnd"/>
			<kmss:period property="monthEndTime" periodTypeName="monthPeriodType"/>
	</td>
	<td width=80% style="display:none" id="year">	
			<input type='hidden' name='yearPeriodType' value='5'/>
			<bean:message  bundle="kms-integral" key="kmsIntegralCommon.fdTimeUnit.timeStart"/>
			<kmss:period property="yearStartTime" periodTypeName="yearPeriodType"/>
			<bean:message  bundle="kms-integral" key="kmsIntegralCommon.fdTimeUnit.timeEnd"/>
			<kmss:period property="yearEndTime" periodTypeName="yearPeriodType"/>
	</td>
</tr>
<script>
window.onload=function(){
	var fdTimeUnit = "${fdTimeUnit}" ;
	refreshTimeUnitDisplay(fdTimeUnit) ;
}

function refreshTimeUnitDisplay(value){
	var month = document.getElementById("month");
	var year = document.getElementById("year");	
	if(value=="1"){
		month.style.display ="table-cell";
		year.style.display = "none";
	}
	if(value=="3"){
		month.style.display ="none";
		year.style.display = "table-cell";
	}
}
function submited(){
	var fdTimeUnit = document.getElementsByName("fdTimeUnit");
    var bgtime="";
    var endtime="";
    for(var i=0;i<fdTimeUnit.length;i++){	
        if(fdTimeUnit[i].checked==true){	  
            value=fdTimeUnit[i].value;	  
            if('1' == value){
            	bgtime = document.getElementsByName("monthStartTime")[0].value;
            	endtime = document.getElementsByName("monthEndTime")[0].value;
            }else if("3" == value){
            	bgtime = document.getElementsByName("yearStartTime")[0].value;
            	endtime = document.getElementsByName("yearEndTime")[0].value;
            }
         } 
    }
	if(bgtime>endtime){
		alert('<bean:message  bundle="kms-integral" key="kmsIntegralCommon.timeError"/>');
		return false;
	}
	return true;
}
</script>