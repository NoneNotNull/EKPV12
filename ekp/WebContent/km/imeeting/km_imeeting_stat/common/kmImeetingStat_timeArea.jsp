<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="queryForm" value="${requestScope[param['formName']] }"/>
<%--统计周期 --%>
<tr>
	<td class="td_normal_title">
		<bean:message key="kmImeetingStat.fdDateType" bundle="km-imeeting"/>
	</td>
	<td>
		<xform:text property="fdStartDate" showStatus="edit" style="display:none;"></xform:text>
		<xform:text property="fdEndDate" showStatus="edit" style="display:none;"></xform:text>
		<xform:radio property="fdDateType" onValueChange="chgTimeSelect" value="${queryForm.fdDateType }" showStatus="edit">
		   <c:choose>
		       <c:when test="${param.selfDefine==false}">
		            <xform:enumsDataSource enumsType="km_imeeting_stat_fd_date_type_withOutDay">
					</xform:enumsDataSource>
		        </c:when>
		       <c:otherwise>
		        	<xform:enumsDataSource enumsType="km_imeeting_stat_fd_date_type">
					</xform:enumsDataSource>
		       </c:otherwise>
		   </c:choose>
		</xform:radio>
	</td>
</tr>
<tr id="timeScope_5" name="timeScope">
	<td class="td_normal_title">
		<bean:message key="kmImeetingStat.fdDateType.scope" bundle="km-imeeting"/>
	</td>
	<td>
		<input type='hidden' name='fdTimeType_5' value='5'/>
		<kmss:period property="fdStartDate_5" periodTypeName="fdTimeType_5" value="${queryForm.fdProdStartDate }" onChangeExAfter="setCurrTimeVal();"/>
		<bean:message  bundle="km-imeeting" key="kmImeetingStat.fdDateType.to"/>
		<kmss:period property="fdEndDate_5" periodTypeName="fdTimeType_5" value="${queryForm.fdProdEndDate}" onChangeExAfter="setCurrTimeVal();"/>
	</td>
</tr>
<tr style="display:none" id="timeScope_3" name="timeScope">
	<td class="td_normal_title">
		<bean:message key="kmImeetingStat.fdDateType.scope" bundle="km-imeeting"/>
	</td>
	<td>
		<input type='hidden' name='fdTimeType_3' value='3'/>
		<kmss:period property="fdStartDate_3" periodTypeName="fdTimeType_3" value="${queryForm.fdProdStartDate }" onChangeExAfter="setCurrTimeVal();"/>
		<bean:message  bundle="km-imeeting" key="kmImeetingStat.fdDateType.to"/>
		<kmss:period property="fdEndDate_3" periodTypeName="fdTimeType_3" value="${queryForm.fdProdEndDate }" onChangeExAfter="setCurrTimeVal();"/>
	</td>
</tr>
<tr style="display:none" id="timeScope_1" name="timeScope">
	<td class="td_normal_title">
		<bean:message key="kmImeetingStat.fdDateType.scope" bundle="km-imeeting"/>
	</td>
	<td>
		<input type='hidden' name='fdTimeType_1' value='1'/>
		<kmss:period property="fdStartDate_1" periodTypeName="fdTimeType_1" value="${queryForm.fdProdStartDate}" onChangeExAfter="setCurrTimeVal();"/>
		<bean:message  bundle="km-imeeting" key="kmImeetingStat.fdDateType.to"/>
		<kmss:period property="fdEndDate_1" periodTypeName="fdTimeType_1"  value="${queryForm.fdProdEndDate}" onChangeExAfter="setCurrTimeVal();"/>
	</td>
</tr>
<tr style="display:none" id="timeScope_7" name="timeScope">
	<td class="td_normal_title">
		<bean:message key="kmImeetingStat.fdDateType.scope" bundle="km-imeeting"/>
	</td>
	<td>
		<input type='hidden' name='fdTimeType_7' value='7'/>
		<div class="inputselectsgl" onclick="selectDate('fdStartDate_7',null,setCurrTimeVal,setCurrTimeVal);" style="width:20%">
			<div class="input"><input type="text" name="fdStartDate_7" value="${queryForm.fdStartDate }"></div>
			<div class="inputdatetime"></div>
		</div>
		<span style="position:relative;top:-7px;"><bean:message  bundle="km-imeeting" key="kmImeetingStat.fdDateType.to"/></span>
		<div class="inputselectsgl" onclick="selectDate('fdEndDate_7',null,setCurrTimeVal,setCurrTimeVal);" style="width:20%">
			<div class="input"><input type="text" name="fdEndDate_7" value="${queryForm.fdEndDate }"></div>
			<div class="inputdatetime"></div>
		</div>
	</td>
</tr>
<script type="text/javascript">
	//显示当前的时间区间设置
	var chgTimeSelect = function(val){
		$("tr[name='timeScope']").hide();
		$("tr[id='timeScope_"+val+"']").show();
		if(val=='7'){
			var oldVal = $("input[name='fdStartDate_7']").val();
			if(oldVal!='' && oldVal.indexOf("-")==-1){
				$("input[name='fdStartDate_7']").val('');
				$("input[name='fdEndDate_7']").val('');
			}
		}
		setCurrTimeVal();
	};
	//设置当前的设置的时间区间
	var setCurrTimeVal = function(){
		var timeType = $("input[name='fdDateType']:checked").val();
		if(timeType!=null && timeType!=''){
			 $("input[name='fdStartDate']").val($("*[name='fdStartDate_"+timeType+"']").val());
			 $("input[name='fdEndDate']").val($("*[name='fdEndDate_"+timeType+"']").val());
		}
	}; 
	//设置初始化时间区间显示并显示当前时间区间
	Com_AddEventListener(window,'load',function(){
		var timeType = $("input[name='fdDateType']:checked").val();
		if(timeType=='' || timeType==null){
			timeType = '5';
			$("input[name='fdDateType'][value='"+timeType+"']").prop("checked",true);
		}
		window.chgTimeSelect(timeType);
	});
	//提交时，设置当前的时间区间
	var submitEvent = Com_Parameter.event["submit"];
	submitEvent[submitEvent.length] = function(){
		setCurrTimeVal();
		return true;
	};
</script>


