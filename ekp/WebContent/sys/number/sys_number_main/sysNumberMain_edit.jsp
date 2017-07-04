<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<style type="text/css">
	.grayColor
		{
			color:gray;
		}
	.noborder{
		border-collapse:collapse;
		border: 0px #FFF solid;
		background-color: #FFFFFF;
	}
	.noborder td{
		border-collapse:collapse;
		border: 0px #FFF solid;
		padding:0px;
	}
	#nav li {     
	 list-style-type: none;    
	 padding: 2px 5px;  } 
	 
</style>
<script type="text/javascript">
	Com_IncludeFile("doclist.js|dialog.js|calendar.js|optbar.js|jquery.js|json2.js|formula.js");
	Com_IncludeFile("dialog.js", "style/"+Com_Parameter.Style+"/dialog/");
</script>
<script type="text/javascript" src="swfobject.js"></script>

<html:form action="/sys/number/sys_number_main/sysNumberMain.do">
	<c:if test="${param['isCustom'] !='1'}">
		<div id="optBarDiv">
			<c:if test="${sysNumberMainForm.method_GET=='edit'}">
				<input type=button value="<bean:message key="button.update"/>"
					onclick="Com_Submit(document.sysNumberMainForm, 'update');">
			</c:if>
			<c:if test="${sysNumberMainForm.method_GET=='add'}">
				<input type=button value="<bean:message key="button.save"/>"
					onclick="Com_Submit(document.sysNumberMainForm, 'save');">
				<input type=button value="<bean:message key="button.saveadd"/>"
					onclick="Com_Submit(document.sysNumberMainForm, 'saveadd');">
			</c:if>
			<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
		</div>
	</c:if>
	<table align=center width="100%"><tr><td width="100%">
	<div id="showError" class="txtstrong" align="center">
	</div></td></tr></table>

	<c:if test="${param['isCustom'] !='1'}">
		<p class="txttitle"><bean:message bundle="sys-number" key="table.sysNumberMain"/></p>
	</c:if>
<center>
	<table width=100% class="tb_normal">
	<c:if test="${param['isCustom'] !='1'}">
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="sys-number" key="sysNumberMain.fdName"/>
			</td><td width="35%">
				<xform:text property="fdName" style="width:45%" required="true"/>
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="sys-number" key="sysNumberMain.fdDefaultFlag"/>
			</td><td width="35%">
				<input type="checkbox" name="DefaultFlag" value="0" />
				<bean:message bundle="sys-number" key="sysNumberMain.templateDefault"/>
			</td>
		</tr>
		<!-- 可使用者 -->
		<tr>
				<td class="td_normal_title" width=15%>
					<bean:message bundle="sys-number" key="sysNumberMain.authReaders" />
				</td><td colspan="3">
					<html:hidden property="authReaderIds" /> 
					<html:textarea
							property="authReaderNames" style="width:80%" readonly="true" /> 
							<a href="#"
							onclick="Dialog_Address(true, 'authReaderIds','authReaderNames', ';',null);"><bean:message
							key="dialog.selectOther" /></a><br>
							<bean:message key="sysNumberMain.authReaders.tip" bundle="sys-number"/>
				</td>
		</tr>
	</c:if>
	
	<tr>
		<td width=100% colspan="4">
			<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="800px" height="250px" id="IDRuleMaker" name="IDRuleMaker">
                <param name="movie" value="IDRuleMaker.swf" />
                <param name="quality" value="high" />
                <param name="bgcolor" value="#ffffff" />
                <param name="allowScriptAccess" value="sameDomain" />
                <param name="allowFullScreen" value="false" />
                <param name="flashvars" value='langParam={"fdTitle":"<bean:message bundle="sys-number" key="sysNumberMain.fdTitle"/>","fdDate":"<bean:message bundle="sys-number" key="sysNumberMain.fdDate"/>","fdTime":"<bean:message bundle="sys-number" key="sysNumberMain.fdTime"/>","flowNo":"<bean:message bundle="sys-number" key="sysNumberMain.flowNo"/>","fdConstant":"<bean:message bundle="sys-number" key="sysNumberMain.fdConstant"/>","fdCustom":"<bean:message bundle="sys-number" key="sysNumberMain.fdCustom"/>","fdClear":"<bean:message bundle="sys-number" key="sysNumberMain.fdClear"/>"}' />
                <embed
					name="IDRuleMaker"
					src="IDRuleMaker.swf" 
					wmode="opaque"
					quality="high"
					pluginspage="http://www.macromedia.com/go/getflashplayer"
					type="application/x-shockwave-flash" 
					style="width: 800px; height: 250px"
					flashvars='langParam={"fdTitle":"<bean:message bundle="sys-number" key="sysNumberMain.fdTitle"/>","fdDate":"<bean:message bundle="sys-number" key="sysNumberMain.fdDate"/>","fdTime":"<bean:message bundle="sys-number" key="sysNumberMain.fdTime"/>","flowNo":"<bean:message bundle="sys-number" key="sysNumberMain.flowNo"/>","fdConstant":"<bean:message bundle="sys-number" key="sysNumberMain.fdConstant"/>","fdCustom":"<bean:message bundle="sys-number" key="sysNumberMain.fdCustom"/>","fdClear":"<bean:message bundle="sys-number" key="sysNumberMain.fdClear"/>"}'>
				</embed>
            </object>
		</td>
	</tr>
	<tr>
		<td width="100%" colspan="4">
			<div id="divDate">
			<fieldset>
				<legend><bean:message bundle="sys-number" key="sysNumberMain.dateProperty"/></legend>
				<ul id="nav">
					<li>
						<bean:message bundle="sys-number" key="sysNumberMain.areaProperty"/>
						<select id="selectArea" style="WIDTH: 90px; HEIGHT: 20px" class="selectsgl">
							<option>中文（中国）</option>
						</select>
						<input type="button" onclick="divDateOK();" value="<bean:message bundle="sys-number" key="sysNumberMain.OK"/>"  class="btndialog" style="cursor:pointer"/>
					</li>
					<li>
						<bean:message bundle="sys-number" key="sysNumberMain.datetimeType"/>
						<select id="selectDate" style="WIDTH: 175px; HEIGHT:20px" class="selectsgl">
							<option>2012-08-22</option>
						</select><span class="txtstrong">*</span>
					</li>
				</ul>
			</fieldset>
		</div>
		
		<div id="divTime">
			<fieldset>
				<legend><bean:message bundle="sys-number" key="sysNumberMain.timeProperty"/></legend>
				<ul id="nav">
					<li>
						<bean:message bundle="sys-number" key="sysNumberMain.areaProperty"/>
						<select id="selectTimeArea" style="WIDTH: 90px; HEIGHT: 20px" class="selectsgl">
							<option>中文（中国）</option><span class="txtstrong">*</span>
						</select>
						<input type="button" onclick="divTimeOK();" value="<bean:message bundle="sys-number" key="sysNumberMain.OK"/>"  class="btndialog" style="cursor:pointer"/>
					</li>
					<li>
						<bean:message bundle="sys-number" key="sysNumberMain.datetimeType"/>
						<select id="selectTime" style="WIDTH: 175px; HEIGHT: 20px" class="selectsgl">
							<option>2012-08-22</option>
						</select><span class="txtstrong">*</span>
					</li>
				</ul>
			</fieldset>
			
		</div>
		
		<div id="divFlow">
			<fieldset>
				<legend><bean:message bundle="sys-number" key="sysNumberMain.flowProperty"/></legend>
				<table border="0" width="80%" class="noborder">
				<tr >
					<td width="20%" align="center">
				 		<bean:message bundle="sys-number" key="sysNumberMain.flow.period"/>
				 	</td>
				 	<td> 
				 		 <input type="radio" name="period" value="0" checked="checked"><bean:message bundle="sys-number" key="sysNumberMain.flow.period.t0"/></input>
						 <input type="radio" name="period" value="1" ><bean:message bundle="sys-number" key="sysNumberMain.flow.period.t1"/></input>
						 <input type="radio" name="period" value="2" ><bean:message bundle="sys-number" key="sysNumberMain.flow.period.t2"/></input>
						 <input type="radio" name="period" value="3" ><bean:message bundle="sys-number" key="sysNumberMain.flow.period.t3"/></input><span class="txtstrong">*</span>
				 		 <input type="button" onclick="divFlowOK();" value="<bean:message bundle="sys-number" key="sysNumberMain.OK"/>" class="btndialog" style="cursor:pointer"/>
				 	</td>
				 </tr>
				 <tr>
				 	<td align="center">
				 	<bean:message bundle="sys-number" key="sysNumberMain.flow.length"/>
				 	</td>
				 	<td>
				 		<input type="text" id="len" size="20" value="3" class="inputsgl" ><span class="txtstrong">*</span>
				 		<input type="checkbox" checked="checked" id="isZeroFill" style="vertical-align: middle;" /><span style="vertical-align: middle;"><bean:message bundle="sys-number" key="sysNumberMain.flow.isZeroFill"/></span>
				 	</td>
				 </tr>
				 <tr>
				 	<td align="center">
				 	<bean:message bundle="sys-number" key="sysNumberMain.flow.start"/>
				 	</td>
				 	<td>
				 		<input type="text" id="start" value="1" size="20" class="inputsgl"/><span class="txtstrong">*</span>
				 	</td>
				 </tr>
				 <tr style="display:none">
				 	<td align="center">
				 	<bean:message bundle="sys-number" key="sysNumberMain.flow.step"/>
				 	</td>
				 	<td>
				 		<input type="text" id="step" size="20" class="inputsgl"/><span class="txtstrong">*</span>
				 	</td>
				 </tr>
				  <tr>
				 	<td align="center">
				 	<bean:message bundle="sys-number" key="sysNumberMain.flow.limits"/>
				 	</td>
				 	<td id="limits"></td>
				 </tr>
				  
				</table>
			</fieldset>
			
		</div>
		
		<div id="divConst">
			<fieldset>
				<legend><bean:message bundle="sys-number" key="sysNumberMain.constProperty"/></legend>
				<table border="0"  width="80%"  class="noborder">
				<tr >
					<td width="20%" align="center">
				 		<bean:message bundle="sys-number" key="sysNumberMain.constValue"/>
				 	</td>
				 	<td > 
				 		<input type="text" id="textConst" size="40"  class="inputsgl"/><span class="txtstrong">*</span>
				 		<input type="button" onclick="divConstOK();" value="<bean:message bundle="sys-number" key="sysNumberMain.OK"/>"  class="btndialog" style="cursor:pointer"/>
				 	</td>
				 </tr>
				 
				 </table>
			</fieldset>
		</div>		
		
		<div id="divCustom">
			<fieldset>
				<legend><bean:message bundle="sys-number" key="sysNumberMain.customProperty"/></legend>
				<table border="0"  width="80%"  class="noborder">
				<tr >
					<td width="20%" align="center">
				 		<bean:message bundle="sys-number" key="sysNumberMain.formula"/>
				 	</td>
				 	<td> 
				 		<input type="hidden" name="textCustomID" id="textCustomID"/>
				 		<input type="text" name="textCustomName" id="textCustomName" readonly size="40"  class="inputsgl"/>
				 		<a href="#" onclick="formulaClick();"><bean:message bundle="sys-number" key="sysNumberMain.formulaDef"/></a><span class="txtstrong">*</span>
				 		<input type="button" onclick="divCustomOK();" value="<bean:message bundle="sys-number" key="sysNumberMain.OK"/>"  class="btndialog" style="cursor:pointer"/>
				 	</td>
				 </tr>
				 
				 <tr >
					<td width="20%" align="center">
				 		<bean:message bundle="sys-number" key="sysNumberMain.formulaShowName"/>
				 	</td>
				 	<td> 
				 		<input type="text" id="textCustomNameFromUser"  size="20"  class="inputsgl"/>
				 		 <span class="txtstrong">*</span>
				 	</td>
				 </tr>
				 </table>
			</fieldset>
		</div>
		</td>
	</tr>
</table>
</center>

<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<html:hidden property="fdContent" styleId="fdContent"/>
<html:hidden property="fdModelName" />
<html:hidden property="fdDefaultFlag"/>
<html:hidden property="fdFlowContent" styleId="fdFlowContent"/>
	
<c:if test="${param['isCustom'] !='1'}">
		<xform:text property="fdTemplateFlag" value="0" showStatus="noShow"/>
</c:if>
<c:if test="${param['isCustom'] =='1'}">
		<xform:text property="fdTemplateFlag" value="1" showStatus="noShow"/>
		<xform:text property="fdName" value='自定义编号规则' showStatus="noShow"/>
</c:if>



<script type="text/javascript">
	$KMSSValidation();
	
			
	//定义json数组，用于日期，时间，区域调用。
	var area_date="[{area:'<bean:message bundle="sys-number" key="sysNumberMain.China"/>',data:[{name:'<bean:message bundle="sys-number" key="sysNumberMain.pleaseSelect"/>',value:''},{name:'20120314',value:'yyyyMMdd'},{name:'201203',value:'yyyyMM'},{name:'2012-03-14',value:'yyyy-MM-dd'},{name:'2012-03',value:'yyyy-MM'},{name:'*2012-3-4',value:'yyyy-M-d'},{name:'*2012年3月4日',value:'yyyy&apos;年&apos;M&apos;月&apos;d&apos;日&apos;'},{name:'二〇一二年三月四日',value:'$CN$yyyy&apos;年&apos;M&apos;月&apos;d&apos;日&apos;'},{name:'二〇一二年三月',value:'$CN$yyyy&apos;年&apos;M&apos;月&apos;'},{name:'三月四日',value:'$CN$M&apos;月&apos;d&apos;日&apos;'},{name:'2012年3月4日',value:'yyyy&apos;年&apos;M&apos;月&apos;d&apos;日&apos;'},{name:'2012年3月',value:'yyyy&apos;年&apos;M&apos;月&apos;'},{name:'3月4日',value:'M&apos;月&apos;d&apos;日&apos;'},{name:'星期三',value:'E'},{name:'周三',value:'$CN$&apos;周&apos;E'},{name:'2012-3-14 1:30 PM',value:'yyyy-M-dd H:m a'},{name:'2012-3-14 13:30',value:'yyyy-M-dd HH:mm'},{name:'12-3-14',value:'yy-M-dd'},{name:'3-14',value:'M-dd'},{name:'3-14-12',value:'M-dd-yy'},{name:'14-Mar',value:'dd-MMM'},{name:'14-Mar-12',value:'d-MMM-yy'},{name:'04-Mar-12',value:'dd-MMM-yy'},{name:'Mar-12',value:'MMM-yy'},{name:'March-12',value:'MMMMM-yy'},{name:'M',value:'MMM(1)'},{name:'M-12',value:'MMM(1)-yy'},{name:'2012',value:'yyyy'},{name:'03',value:'MM'},{name:'14',value:'dd'}]},{area:'<bean:message bundle="sys-number" key="sysNumberMain.UK"/>',data:[{name:'<bean:message bundle="sys-number" key="sysNumberMain.pleaseSelect"/>',value:''},{name:'14-03-2012',value:'dd-MM-yyyy'},{name:'14-03-12',value:'dd-MM-yy'},{name:'14-3-12',value:'dd-M-yy'},{name:'14.3.12',value:'dd.M.yy'},{name:'2012-03-14',value:'yyyy-MM-dd'},{name:'04 March 2012',value:'dd MMMMM yyyy'},{name:'4 March 2012',value:'d MMMMM yyyy'}]},{area:'<bean:message bundle="sys-number" key="sysNumberMain.America"/>',data:[{name:'<bean:message bundle="sys-number" key="sysNumberMain.pleaseSelect"/>',value:''},{name:'3-4',value:'M-d'},{name:'3-4-12',value:'M-d-yy'},{name:'03-04-12',value:'MM-dd-yy'},{name:'14-Mar',value:'dd-MMM'},{name:'4-Mar-12',value:'d-MMM-yy'},{name:'04-Mar-12',value:'dd-MMM-yy'},{name:'Mar-12',value:'MMM-yy'},{name:'March-12',value:'MMMMM-yy'},{name:'March 14,2012',value:'MMMMM dd,yyyy'},{name:'3-14-12 1:30 PM',value:'M-dd-yy H:m a'},{name:'3-14-12 13:30',value:'M-dd-yy HH:mm'},{name:'M',value:'MMM(1)'},{name:'M-12',value:'MMM(1)-yy'},{name:'3-14-2012',value:'M-dd-yyyy'},{name:'14-Mar-2012',value:'dd-MMM-yyyy'}]}]";
	var area_time="[{area:'<bean:message bundle="sys-number" key="sysNumberMain.China"/>',data:[{name:'<bean:message bundle="sys-number" key="sysNumberMain.pleaseSelect"/>',value:''},{name:'*13:30:55',value:'HH:mm:ss'},{name:'*13:30',value:'HH:mm'},{name:'1:30 PM',value:'h:mm a'},{name:'13:30:55',value:'HH:mm:ss'},{name:'1:30:55 PM',value:'h:mm:ss a'},{name:'13时30分',value:'HH&apos;时&apos;mm&apos;分&apos;'},{name:'13时30分55秒',value:'HH&apos;时&apos;mm&apos;分&apos;ss&apos;秒&apos;'},{name:'下午1时30分',value:'ah&apos;时&apos;mm&apos;分&apos;'},{name:'下午1时30分55秒',value:'ah&apos;时&apos;mm&apos;分&apos;ss&apos;秒&apos;'},{name:'十三时三十分',value:'$CN$HH&apos;时&apos;mm&apos;分&apos;'},{name:'下午一时三十分',value:'$CN$ah&apos;时&apos;mm&apos;分&apos;'},{name:'133055',value:'HHmmss'},{name:'1330',value:'HHmm'},{name:'13',value:'HH'}]},{area:'<bean:message bundle="sys-number" key="sysNumberMain.UK"/>',data:[{name:'<bean:message bundle="sys-number" key="sysNumberMain.pleaseSelect"/>',value:''},{name:'13:30:55',value:'H:mm:ss'},{name:'13:30:55',value:'HH:mm:ss'},{name:'01:30:55 PM',value:'hh:mm:ss a'},{name:'1:30:55 PM',value:'h:mm:ss a'}]},{area:'<bean:message bundle="sys-number" key="sysNumberMain.America"/>',data:[{name:'<bean:message bundle="sys-number" key="sysNumberMain.pleaseSelect"/>',value:''},{name:'13:30',value:'HH:mm'},{name:'1:30 PM',value:'h:mm a'},{name:'13:30:55',value:'HH:mm:ss'},{name:'1:30:55 PM',value:'h:mm:ss a'},{name:'30:55.2',value:'mm:ss.SSS'},{name:'3-14-01 1:30 PM',value:'M-dd-yy h:mm a'},{name:'3-14-01 13:30',value:'M-dd-yy HH:mm'}]}]";
	//存储范围元素名称,属性
	var auto_add_elename=new Array();
	var auto_add_eleprop=new Array();
	var ischange=false;
	var isLoaded=true;
	var flash=null;

	function dyniFrameSize() {
		try {
			// 调整高度
			var arguObj = document.getElementsByTagName("form")[0];
			if(arguObj!=null && window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
				window.frameElement.style.height = (arguObj.offsetHeight + 20) + "px";
			}
		} catch(e) {
		}
	}
	
	function init(){	
		var evalue=document.getElementsByName("DefaultFlag")[0];
		var fvalue=document.getElementsByName("fdDefaultFlag")[0];
		if(typeof(evalue)!='undefined'){
			if (fvalue.value == "0") {
				evalue.checked = true ;
			}else {
				evalue.checked = false;
			}
		}else{
			fvalue.value="1";
		}
		
		var area_date_json=eval(area_date);
		var isfirst=true;
		$.each(area_date_json,function(idx,item){
					$("#selectArea").append("<option value='"+item.area+"'>"+item.area+"</option>");
					var data=item.data;
					$.each(data,function(idx,item){
							if(isfirst)
								$("#selectDate").append("<option value='"+item.value+"'>"+item.name+"</option>");
						}		
					);
					isfirst=false;
				});	 
		
		//时间加载
		var area_time_json=eval(area_time);
		var isf=true;
		$.each(area_time_json,function(idx,item){
					$("#selectTimeArea").append("<option value='"+item.area+"'>"+item.area+"</option>");
					var data=item.data;
					$.each(data,function(idx,item)
						{
							if(isf)
								$("#selectTime").append("<option value='"+item.value+"'>"+item.name+"</option>");
						}		
					);
					isf=false;
				});	
		if("1"=="${param['isCustom']}"){
			dyniFrameSize();
		} 
	}
	
	$(function(){
		$("#selectArea").empty();
		$("#selectDate").empty();
		$("#selectTimeArea").empty();
		$("#selectTime").empty();
		$("#selectArea").change(function(){
			var area=$("#selectArea").val();
			$("#selectDate").empty();
			var area_date_json=eval(area_date);
			$.each(area_date_json,function(idx,item){
				if(area==item.area){
						var data=item.data;
						$.each(data,function(idx,item){
							$("#selectDate").append("<option value='"+item.value+"'>"+item.name+"</option>");
							}		
						);
					}
			});	
		});
			
		$("#selectTimeArea").change(function(){
			var area=$("#selectTimeArea").val();
			$("#selectTime").empty();
			var area_time_json=eval(area_time);
			$.each(area_time_json,function(idx,item){
					if(area==item.area){
							var data=item.data;
							$.each(data,function(idx,item)
								{
								$("#selectTime").append("<option value='"+item.value+"'>"+item.name+"</option>");
								}		
							);
						}
				});	
		});
		
		hideDiv();
		init();
		window.setTimeout(showItemList,1400);
	});

	function showItemList(){
		updateItemList($("#fdContent").val());
	}

	function delayShowItemList(){
		window.setTimeout(showItemList,1400);
	}
	//AS调用JS接口 after 3
	//规则列表数据发生变化时调用	
	function updateResult(str){
		$("input[name='fdContent']").val(str);

		//更新流水号信息fdFlowContent
		var _fdFlowContent = $('#fdFlowContent').val();
		if(!_fdFlowContent || !str){
			return ;
		}
		var _fdContentJson =JSON.parse(str);
		var _fdFlowContentJson =JSON.parse(_fdFlowContent);
		var newFdFlowContentJson = [];
		$.each(_fdContentJson,function(idx,item){
				var flowId = item.id;
				$.each(_fdFlowContentJson,function(idx,item){
					if(flowId==item.id){
						newFdFlowContentJson.splice(0,0,item);	
						return ;
					}
				});
				
		});
		if(newFdFlowContentJson.length>0){
			$('#fdFlowContent').attr('value',JSON.stringify(newFdFlowContentJson));
		}
	}
	function hideDiv(){
		$("#divDate").hide();
		$("#divTime").hide();
		$("#divFlow").hide();
		$("#divConst").hide();
		$("#divCustom").hide();
	}
	
	function isNotNull(s){
		if((s != undefined || s!=null) && s!=''){
			return true;
		}		
		return false;
	}
	
	//传递json字段值用
	var json_id;
	var json_type;
	var json_ruleData;
	var json_name;
	
	//AS调用：选择某项时调用
	function selectItem(str){
		var dataObj=eval("["+str+"]");
		$.each(dataObj,function(idx,item){
			 //result.innerHTML=result.innerHTML+item.id+'-'+item.type+'-'+item.ruleData+'-'+item.name;
			 //1-date--日期2-time--时间3-flow--流水号4-const--常量5-custom--
			 json_id=item.id;
			 json_type=item.type;
			 json_ruleData=item.ruleData;
			 json_name=item.name;
			 
			 var t_type=json_type;
			 var t_ruleData=json_ruleData;
			 if(t_type=='date'){
				$.each(t_ruleData,function(idx,item){
					if(idx=='zone'){
						$("#selectArea").val(item);
						$("#selectArea").change();
					}
				});
				$.each(t_ruleData,function(idx,item){
					if(idx=='format')
						$("#selectDate").val(item);
				});
				hideDiv();
				$("#divDate").toggle(300);
			}else if(t_type=='time'){
				 $.each(t_ruleData,function(idx,item){
					 	if(idx=='zone'){
					 		$("#selectTimeArea").val(item);
					 		$("#selectTimeArea").change();
					 	}
					});
				 $.each(t_ruleData,function(idx,item){
					 	if(idx=='format')
					 		$("#selectTime").val(item);
					});
			 	 hideDiv();
				 $("#divTime").toggle(300);
			}else if(t_type=='flow'){
				 $("input[name='period'][value='0']").prop("checked",true);
				 $("#len").prop("value","3"); 
				 $("#len").addClass("grayColor");
				 $("#start").prop("value","1"); 
				 $("#start").addClass("grayColor");
				 $("#step").prop("value","1");
				 $("#step").addClass("grayColor");
				 $("#isZeroFill").prop("checked",true);
				 
				 $.each(t_ruleData,function(idx,item){
					 	if(idx=='period'){
					 		 if(item=='0')
					 			$("input[name='period'][value='0']").prop("checked",true);
					 		 else if(item=='1')
					 			$("input[name='period'][value='1']").prop("checked",true);
					 		 else if(item=='2')
					 			$("input[name='period'][value='2']").prop("checked",true);
					 		 else if(item=='3')
					 			$("input[name='period'][value='3']").prop("checked",true);
					 	}
					 	if(idx=='len'){
					 		$("#len").prop("value",item); 
					 		$("#len").removeClass("grayColor");
					 		var _fdFlowContent = $('#fdFlowContent').val();
					 		if(_fdFlowContent){
								var _fdFlowContentJson = JSON.parse(_fdFlowContent);
								$.each(_fdFlowContentJson,function(index,item){
									if(item.id==json_id){
										var isZeroFill = item.isZeroFill=='true'? true:false;
										$("#isZeroFill").prop("checked",isZeroFill);
									}
								});
						 	}
					 	}else if(idx=='period')
					 		$("#period").prop("value",item);
					 	else if(idx=='start'){
					 		$("#start").prop("value",item); 
					 		$("#start").removeClass("grayColor");
					 	}else if(idx=='step'){
					 		$("#step").prop("value",item);
					 		$("#step").removeClass("grayColor");
					 	}else if(idx=='areas'){
					 		if(!ischange){
					 			$("#limits").empty();
						 		$.each(item,function(idx,it){
						 			var id='';
						 			var name='';
						 			var selected='';
						 			$.each(it,function(idx,itt){
						 				if(idx=='id'){
						 					id=itt;
						 				}else if(idx=='name'){
						 					name=itt;
						 				}else if(idx=='selected'){
						 					selected=itt;
						 				}
						 			});
						 			//add ele
						 			if(selected=='true')
						 				$("#limits").append("<input type='checkbox' name='"+id+"' id='"+id+"' checked='checked'/><label for='"+id+"'>"+name+"</label>");
						 			else
						 				$("#limits").append("<input type='checkbox' name='"+id+"' id='"+id+"' /><label for='"+id+"'>"+name+"</label>");
						 		});
					 		}
					 	}else{
					 		ischange=false;
					 	}
					});
				 hideDiv();
				 $("#divFlow").toggle(300);
			 }else if(t_type=='const'){
				 $("#textConst").val("");
				 $.each(t_ruleData,function(idx,item){
						var v_data=item;
						if(isNotNull(v_data))
							$("#textConst").val(v_data);
					});
				 hideDiv();
				 $("#divConst").toggle(300);
			}else if(t_type=='custom'){
				 $("#textCustomID").val("");
				 $("#textCustomName").val("");
				 $.each(t_ruleData,function(idx,item){
					 //":{"formulaID":"$docSubject$","formulaName":"$主题$"},"
					 if(idx=='formulaID')
						 $("#textCustomID").val(item.replace(/'/g,"\""));
					 else if(idx=='formulaName')
						 $("#textCustomName").val(item.replace(/'/g,"\""));
					});
				 $("#textCustomNameFromUser").val(json_name);
				 hideDiv();
				 $("#divCustom").toggle(300);
			}
		});
		if("1"=="${param['isCustom']}"){
			setTimeout("dyniFrameSize();", 400);
		} 
	}
	//取消选择
	function deselected(){
		hideDiv();
	}

	function getFlash(){
		var arr = document.getElementsByName('IDRuleMaker');
		if(window.ActiveXObject){
			flash = arr[0];
		}else{
			flash = arr.length >= 2 ? arr[1] : arr[0];
		}
	}
	
	//////////////////////////////////////////////////////////
	//JS调用AS接口示例    after 2
	//保存单个规则控件时调用
	function updateItem(json){
		if(json!=""){
			getFlash();
			flash.updateItem(json);
		}
		
	}
	/*
	用于flash控件方法加载完毕后回调使用
	*/
	function completeLoad(){
		isLoaded=true;
		var fdcontentTemp=$("input[name='fdContent']").val();
		if (fdcontentTemp!=""){
			swf.updateItemList(fdcontentTemp);
		}
	}
	//更新整个规则列表数据
	function updateItemList(json){
		if(json!=""){
			getFlash();
			if(isLoaded==true)
			{
				flash.updateItemList(json);
			}
			else//当flash方法未加载完毕时，仅保存
			{
				$("input[name='fdContent']").val(json);
			}
			hideDiv();
			cls();
		}else{
			<c:if test="${sysNumberMainForm.method_GET=='edit'}">
			addError('编号规则为空，无法进行展示，请设置编号规则或者刷新页面');
			</c:if>
		}
		
	}
	//日期属性编辑确定触发事件
	function divDateOK(){
		//{"id":"2","type":"time","ruleData":"","name":"时间"}
		var dateFormatValue=$("#selectDate").find("option:selected").val();
		var dateFormatText=$("#selectDate").find("option:selected").text();
		var selectArea=$("#selectArea").find("option:selected").text();
		var dateFormatJson="{\"id\":\""+json_id+"\",\"type\":\""+json_type+
			"\",\"ruleData\":{\"format\":\""+dateFormatValue+"\",\"zone\":\""+selectArea+"\"},\"name\":\""+dateFormatText+"\"}";
		if(isNull(dateFormatValue)){
			addError('<bean:message bundle="sys-number" key="sysNumber.error.dateIsNotEmpty"/>');
			return false;
		}
		cls();
		updateItem(dateFormatJson); 
	}
	//时间属性编辑确定触发事件
	function divTimeOK(){
		//{"id":"2","type":"time","ruleData":"","name":"时间"}
		var dateFormatValue=$("#selectTime").find("option:selected").val();
		var dateFormatText=$("#selectTime").find("option:selected").text();
		var selectTimeArea=$("#selectTimeArea").find("option:selected").text();
		var dateFormatJson="{\"id\":\""+json_id+"\",\"type\":\""+json_type+
			"\",\"ruleData\":{\"format\":\""+dateFormatValue+"\",\"zone\":\""+selectTimeArea+"\"},\"name\":\""+dateFormatText+"\"}";
		if(isNull(dateFormatValue))
		{
			addError('<bean:message bundle="sys-number" key="sysNumber.error.timeIsNotEmpty"/>');
			return false;
		}
		cls();
		updateItem(dateFormatJson); 
	}
	//流水号编辑确定触发事件
	function divFlowOK(){
		var period=$("input:radio[name='period']:checked").val();
		if(period==undefined)
			period=0;
		var start=$.trim($("#start").prop("value"));
		var len=$.trim($("#len").prop("value"));
		var step=$.trim($("#step").prop("value"));
		var areas_json="";
		var isZeroFill = $("#isZeroFill")[0].checked;
		
		for(var i=0;i<auto_add_eleprop.length;i++)
		{
			var checkvalue=$("#"+auto_add_eleprop[i]).prop("checked");
			areas_json+="{\"id\":\""+auto_add_eleprop[i]+"\",\"name\":\""+auto_add_elename[i]+"\",\"selected\":\""+checkvalue+"\"}";
			if(i!=auto_add_eleprop.length-1)
			{
				areas_json+=",";
			}
		}
		var dateFormatText;
		if(start=='')
		{
			start="1";
			$("#start").prop("value",start); 
		}
		if(step=='')
			step="1";
		if(len!=undefined && len!=''){
			var num=parseInt(len)-start.length;
			if(num<0){
				addError('<bean:message bundle="sys-number" key="sysNumber.error.numberStartBiggerThanLength"/>');
				return false;
			}
			var str="";
			if(isZeroFill){
				for(var i=0;i<num;i++)
					str=str.concat("0");
			}
			dateFormatText=str.concat(start);
		}else
			dateFormatText=start;
		
		var dateFormatJson="{\"id\":\""+json_id+"\",\"type\":\""+json_type
			+"\",\"ruleData\":{\"period\":\""+period+"\",\"start\":\""+start
			+"\",\"len\":\""+len+"\",\"step\":\""+step
			+"\",\"areas\":["+areas_json+"]},\"name\":\""+dateFormatText+"\"}";
		if(isNull(len)|| isNull(start)||isNull(step)){
			addError('<bean:message bundle="sys-number" key="sysNumber.error.flowIsNotEmpty"/>');
			return false;
		}

		if(isNotNum(len)|| isNotNum(start)|| isNotNum(step)){
			addError('<bean:message bundle="sys-number" key="sysNumber.error.flowIsNotNumber"/>');
			return false;
		}
		
		setFlowContent(json_id,isZeroFill);
		
		cls();
		//addError(dateFormatJson);
		updateItem(dateFormatJson); 
		$("#len").removeClass("grayColor");
		$("#start").removeClass("grayColor");
		$("#step").removeClass("grayColor");
	}

	function setFlowContent(flowId,isZeroFill){
		var _fdFlowContent = $('#fdFlowContent').val();
		var fdFlowContent = "{\"id\":\""+flowId+"\",\"isZeroFill\":\""+isZeroFill+"\"}";
		var fdFlowContentJson = [];
		if(!_fdFlowContent){
			$('#fdFlowContent').attr('value',"[" + fdFlowContent +"]");
			return ;
		}
		fdFlowContentJson = eval(_fdFlowContent);
		var ret = false;
		$.each(fdFlowContentJson,function(idx,item){
			if(item.id==flowId){
				item.isZeroFill=isZeroFill+"";
				var _fdFlowContentJson = JSON.stringify(fdFlowContentJson); 
				$('#fdFlowContent').attr('value', _fdFlowContentJson);
				ret = true;
				return ;
			}
		});
		if(ret)
			return ;
	
		fdFlowContentJson.splice(0,0,JSON.parse(fdFlowContent));
		var _fdFlowContentJson = JSON.stringify(fdFlowContentJson); 
		$('#fdFlowContent').attr('value', _fdFlowContentJson);
	}
	
	function divConstOK(){
		var textConst=$("#textConst").prop("value");
		textConst=textConst.replace(/\;/g,"");
		textConst=textConst.replace(/\"/g,"'");
		var dateFormatJson="{\"id\":\""+json_id+"\",\"type\":\""+json_type+
			"\",\"ruleData\":{\"value\":\""+textConst+"\"},\"name\":\""+textConst+"\"}";
		if(isNull(textConst)){
			addError('<bean:message bundle="sys-number" key="sysNumber.error.constIsNotNumber"/>');
			return false;
		}
		cls();
		updateItem(dateFormatJson); 
	}

	function divCustomOK(){
		var textCustomID=$("#textCustomID").prop("value");
		var textCustomName=$("#textCustomName").prop("value");
		var textCustomNameFromUser=$("#textCustomNameFromUser").prop("value");
		if(isNull(textCustomName)){
			addError('<bean:message bundle="sys-number" key="sysNumber.error.formulaIsNotNumber"/>');
			return false;
		}
		if(isNull(textCustomNameFromUser)){
			addError('<bean:message bundle="sys-number" key="sysNumber.error.formulaShowNameIsNotNumber"/>');
			return false;
		}
		textCustomID=textCustomID.replace(/\r\n/g," ");
		textCustomID=textCustomID.replace(/\"/g,"'");
		textCustomName=textCustomName.replace(/\r\n/g," ");
		textCustomName=textCustomName.replace(/\"/g,"'");
		//alert("textCustomID:"+textCustomID);$fdUrgency$ + $fdSecret$ + $docSubject$ + $docStatus$
		//alert("textCustomName:"+textCustomName);$紧急程度$ + $密级等级$ + $标题$ + $公文状态$
		var dateFormatJson="{\"id\":\""+json_id+"\",\"type\":\""+json_type+
			"\",\"ruleData\":{\"formulaID\":\""+ textCustomID +"\",\"formulaName\":\"" +textCustomName +"\"},\"name\":\""+textCustomNameFromUser+"\"}";
		
		//存储元素数组 属性值
		auto_add_elename=resolv$string(textCustomName);
		auto_add_eleprop=resolv$string(textCustomID);
		//自动增加控件
		$("#limits").empty();
    	for(var i=0;i<auto_add_elename.length;i++){
    		var name=auto_add_elename[i];
    		var id=auto_add_eleprop[i];
    		$("#limits").append("<input type='checkbox' name='"+id+"' id='"+id+"' /><label for='"+id+"'>"+name+"</label>");
   		}
    	ischange=true;
		cls();
		updateItem(dateFormatJson); 
	}
	//解析含有$的字符串，返回数组  
	//eg:$fdUrgency$ + $fdSecret$ + $docSubject$ + $docStatus$
	//eg:$紧急程度$ + $密级等级$ + $标题$ + $公文状态$
	function resolv$string(e){
		var arrs=new Array();
		//var regExp=/'$'(/w*)'$'/g;
		//regExp.exec(e);
		//alert(RegExp.$1);
		var eles="";
		var isstart=false;
		var index=0;
		for ( var i = 0; i < e.length; i++) {
			var c = e.charAt(i);
			if (isstart == false) {
				if (c == '$') {
					isstart = true;
					continue;
				}
			} else {
				if (c == '$') {
					if(eles.indexOf(".")==-1)
					{
						arrs[index] = eles;
						index++;
					}
					eles = "";
					isstart = false;
					continue;
				}
				eles = eles.concat(c);
			}
		}
		return arrs;

	}

	function formulaClick() {
		var modelName = $("input[name='fdModelName']").val();
		if (modelName == "") {
			modelName = "${param.modelName}";
			}
		//当父窗口中有该方法则调用父窗口中的方法，避免项目重写该方法出现调用问题
		if(parent.Formula_GetVarInfoByModelName_New){
			Formula_Dialog('textCustomID', 'textCustomName',parent.Formula_GetVarInfoByModelName_New(modelName),'String');
		}else if(parent.Formula_GetVarInfoByModelName){
			Formula_Dialog('textCustomID', 'textCustomName',parent.Formula_GetVarInfoByModelName(modelName),'String');
		}else{
			Formula_Dialog('textCustomID', 'textCustomName',Formula_GetVarInfoByModelName(modelName),'String');
		}
		
	}

	var temp_control_commit=0;
	
	Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = function(){
		
		var name=$("input[name='fdName']").val();
		if(isNull(name)){
			addError('<bean:message bundle="sys-number" key="sysNumber.error.numberNameIsNotEmpty"/>');
			return false;
		}
		var str=$("input[name='fdContent']").val();
		eleNotInit(str);
		if(isNull(str)){
			addError('<bean:message bundle="sys-number" key="sysNumber.error.numberIsNotEmpty"/>');	
			return false;
		}else if(Page_CanCommit){
			addError('<bean:message bundle="sys-number" key="sysNumber.error.OneIsNotEmpty"/>');
			return false;
		}
		//设置是否默认值
		var evalue=document.getElementsByName("DefaultFlag")[0];
		var fvalue=document.getElementsByName("fdDefaultFlag")[0];
		if (evalue.checked == true) {
			fvalue.value = "0";
		} else {
			fvalue.value = "1";
		}

		isExists(str);
		if(temp_control_commit==1)
			return true;
		else
			return false;
	};
	
	function isExists(str){
		var modelName = $("input[name='fdModelName']").val();
		if (modelName == "") {
			modelName = "${param.modelName}";
		}
		jQuery.ajax({
            type: "post", 
            url: "<%=request.getContextPath() %>/sys/number/sys_number_main/sysNumberMain.do?method=isExistsNumberRule&modelId="+$("input[name='fdId']").val()+"&modelName="+modelName+"&fdContent="+encodeURIComponent(encodeURIComponent(str)), 
            dataType: "text", 
            async:false,
            contentType:"application/x-www-form-urlencoded;charset=utf-8",
            success: function (data) {
                if(data==null||data===undefined||data=='null'){
                	temp_control_commit=1;
                    return;
                }
                if(confirm('<bean:message bundle="sys-number" key="sysNumber.sysConfirmInfo"/><bean:message bundle="sys-number" key="sysNumber.isContinue"/>')){
                	temp_control_commit=1;
                }else{
                	temp_control_commit=2;
                }
            }
		});
	}

	//提交时添加的元素没有被初始化
	function eleNotInit(str) {
		getFlash();
		flash.checkNullItem();
	}

	function cls() {
		$("#showError").empty();
	}

	function addError(str) {
		cls();
		$("#showError").append(str);
	}

	function isNotNum(str) {
		var regu = /^[0-9]{1,}$/;
		return !regu.test(str);
	}
	function isNull(str) {
		if (str == null || $.trim(str) == "")
			return true;
		else
			return false;
	}

	var Page_CanCommit=false;
	//swf回调
	function checkOverHaveNull(str)	{
		if(str=='true'){
			Page_CanCommit=true;
		}else{
			Page_CanCommit=false;
		}
	}
</script>

</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>