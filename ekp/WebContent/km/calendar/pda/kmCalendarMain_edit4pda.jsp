<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/third/pda/htmlhead.jsp"%>
<link type="text/css" rel="stylesheet" href="<c:url value="/km/calendar/resource/css/calendar_pda.css"/>" />
<script>Com_IncludeFile("jquery.js",null,"js");</script>
<script type='text/javascript'>
    Com_IncludeFile('kalendae.css','${KMSS_Parameter_ContextPath}third/pda/resource/style/','css',true);
    Com_IncludeFile('kalendae.js','${KMSS_Parameter_ContextPath}third/pda/resource/script/','js',true);
</script>
</head>
<body onload="document.kmCalendarMainForm.docSubject.focus();">
	<c:if test="${KMSS_PDA_ISAPP !='1'}">
		<c:import charEncoding="UTF-8" url="/third/pda/banner.jsp">
			<c:param name="fdNeedHome" value="true"/>
			<c:param name="fdNeedNav" value="true" />
		</c:import>
	</c:if>
	<html:form action="/km/calendar/km_calendar_main/kmCalendarMain.do" styleId="eventform">
		<html:hidden property="fdType" />
		<html:hidden property="fdId" />
		<html:hidden property="docCreateTime" />
		<html:hidden property="docCreatorId" />
		<html:hidden property="fdIsLunar"  value="false"/>
	<%--主体--%>
	<article id="main" class="mbody active">
        <div class="calendarEdit">
            <h2>
            	<bean:message bundle="km-calendar"  key="kmCalendarMain.opt.create" />
            </h2>
            <table class="base_info">
            	<%--内容--%>
                <tr>
                    <td class="th1 title border">
                    	<span><bean:message bundle="km-calendar"  key="kmCalendarMain.docContent" /></span>
                    </td>
                    <td class="th2 border">
                    	<xform:text property="docSubject" className="td_txt" showStatus="edit"/>
                    </td>
                </tr>
                <%--全天--%>
                <tr>
                    <td class="th1 title">
                        <span><bean:message bundle="km-calendar"  key="kmCalendarMain.allDay" /></span>
                    </td>
                    <td class="th2">
                        <div id="switch" class="switchOn"></div>
                        <html:hidden property="fdIsAlldayevent" />
                    </td>
                </tr>
                <%--开始时间--%>
                <tr>
                    <td class="title">
                        <span><bean:message bundle="km-calendar"  key="kmCalendarMain.docStartTime" /></span>
                    </td>
                    <td>
                        <input name="docStartTime" value="${kmCalendarMainForm.docStartTime}" type="text"  class="auto-kal td_txt" readonly
                        	onblur="__xformDispatch(this.value, this);"  style="width: 35%;"/>
                          <span id="startTimeDiv" >
	                        <select id="startHour" name="startHour">
	                        	<c:forEach  begin="0" end="23" varStatus="status" >
	                            	<option value="${status.index}">
	                            		<c:if test="${status.index<10}">
	                            			0${status.index}
	                            		</c:if>
	                            		<c:if test="${status.index>=10}">
	                            			${status.index}
	                            		</c:if>
	                            	</option>
	                            </c:forEach>
	                        </select>
	                       :
	                        <select id="startMinute" name="startMinute">
	                        	<c:forEach  begin="0" end="59" varStatus="status" >
	                            	<option value="${status.index}">
	                            		<c:if test="${status.index<10}">
	                            			0${status.index}
	                            		</c:if>
	                            		<c:if test="${status.index>=10}">
	                            			${status.index}
	                            		</c:if>
	                            	</option>
	                            </c:forEach>
	                        </select>
                       </span>	
                    </td>
                </tr>
                <%--结束时间--%>
                <tr>
                    <td class="title">
                        <span><bean:message bundle="km-calendar"  key="kmCalendarMain.docFinishTime" /></span>
                    </td>
                    <td >
                        <input name="docFinishTime" value="${kmCalendarMainForm.docFinishTime}" type="text"  class="auto-kal td_txt" readonly
                        	onblur="__xformDispatch(this.value, this);" style="width: 35%;"/>
                       	<span id="endTimeDiv">
	                         <select id="endHour" name="endHour">
	                         	<c:forEach  begin="0" end="23" varStatus="status" >
	                              	<option value="${status.index}">
	                              		<c:if test="${status.index<10}">
	                            			0${status.index}
	                            		</c:if>
	                            		<c:if test="${status.index>=10}">
	                            			${status.index}
	                            		</c:if>
	                              	</option>
	                            </c:forEach>
							</select>
							:
                        	<select id="endMinute" name="endMinute">
                         		<c:forEach  begin="0" end="59" varStatus="status" >
                              		<option value="${status.index}">
                              			<c:if test="${status.index<10}">
	                            			0${status.index}
	                            		</c:if>
	                            		<c:if test="${status.index>=10}">
	                            			${status.index}
	                            		</c:if>
                              		</option>
                            </c:forEach>
                         </select>
                       </span>
                    </td>
                </tr>
                 <%--地点--%>
                <tr>
                    <td class="title border">
                        <span><bean:message bundle="km-calendar"  key="kmCalendarMain.fdLocation" /></span>
                    </td>
                    <td class="border">
                    	<xform:text property="fdLocation" className="td_txt" showStatus="edit"/>
                    </td>
                </tr>
                <%--重复类型--%>
                <tr onclick="showArticle('recurrenceType');">
                    <td class="th1 title">
                        <span><bean:message bundle="km-calendar"  key="kmCalendarMain.fdRecurrenceType" /></span>
                    </td>
                    <td class="th2">
                        <a href="javascript:void(0);" >
                        	<span id="recurrenceType_text"></span>
                        	<input name="RECURRENCE_FREQ" value="${kmCalendarMainForm.RECURRENCE_FREQ}" type="hidden"  />
                        	<input name="RECURRENCE_INTERVAL" value="${kmCalendarMainForm.RECURRENCE_INTERVAL}" type="hidden"  />
                        	<input name="RECURRENCE_END_TYPE" value="${kmCalendarMainForm.RECURRENCE_END_TYPE}" type="hidden"  />
                        	<input name="RECURRENCE_MONTH_TYPE" value="${kmCalendarMainForm.RECURRENCE_MONTH_TYPE}" type="hidden"  />
                        	<input name="RECURRENCE_WEEKS" value="${kmCalendarMainForm.RECURRENCE_WEEKS}" type="hidden"  />
                        	<input name="RECURRENCE_COUNT" value="${kmCalendarMainForm.RECURRENCE_COUNT}" type="hidden"  />
                        	<input name="RECURRENCE_UNTIL" value="${kmCalendarMainForm.RECURRENCE_UNTIL}" type="hidden"  />
                        </a>
                        <div class="item_sign">
                            <i class="item_sign_mtr1"></i><i class="item_sign_mtr2"></i>
                        </div>
                    </td>
                </tr>
                <%--提醒设置--%>
                <tr onclick="showArticle('remind')">
                    <td class="title">
                        <span><bean:message bundle="km-calendar"  key="kmCalendarMain.fdNotifySet" /></span>
                    </td>
                    <td>
                        <a href="javascript:void(0);">
                        	<span id="remind_text"></span>
                        </a>
                        <div class="item_sign">
                            <i class="item_sign_mtr1"></i><i class="item_sign_mtr2"></i>
                        </div>
                    </td>
                </tr>
                <%--标签--%>
                <tr onclick="showArticle('label');">
                    <td class="title">
                        <span><bean:message bundle="km-calendar"  key="kmCalendarMain.docLabel" /></span>
                    </td>
                    <td>
                        <a href="javascript:void(0);">
                        	<span>
                        		<c:if test="${not empty  kmCalendarMainForm.labelName}">
                        			<c:out value="${kmCalendarMainForm.labelName}" />  
                        		</c:if>
                        		<c:if test="${empty  kmCalendarMainForm.labelName}">
                        			<bean:message bundle="km-calendar"  key="module.km.calendar.tree.my.calendar" />
                        		</c:if>
                        	</span>
                        	<input name="labelId" value="${kmCalendarMainForm.labelId}" type="hidden"  />
                        </a>
                        <div class="item_sign">
                            <i class="item_sign_mtr1"></i><i class="item_sign_mtr2"></i>
                        </div>
                    </td>
                </tr>
                 <%--活动性质--%>
                <tr onclick="showArticle('authorityType');">
                    <td class="title">
                        <span><bean:message bundle="km-calendar"  key="kmCalendarMain.fdAuthorityType" /></span>
                    </td>
                    <td>
                        <a href="javascript:void(0);">
                        	<span id="authorityType_text">${kmCalendarMainForm.fdAuthorityType}</span>
                       		<input name="fdAuthorityType" value="${kmCalendarMainForm.fdAuthorityType}" type="hidden"  />
                        </a>
                        <div class="item_sign">
                            <i class="item_sign_mtr1"></i><i class="item_sign_mtr2"></i>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <br/>
        <center>
			<input type="button" id="btn_submit" value="<bean:message key="button.submit"/>" class="btnopt" onclick="submitCalendar();"/>
		</center>
        <script type="text/javascript">
	   		//提交表单
	    	function submitCalendar(){
	    		var docSubject=$("[name='docSubject']").val();
	    		if(docSubject==null||docSubject==""){
		    		alert("<bean:message key='errors.required' argKey0='km-calendar:kmCalendarMain.docContent' />");
		    		document.kmCalendarMainForm.docSubject.focus();
		    		return ;
		    	}
	    		//校验时间
				var startTime=$("[name='docStartTime']").val();
				var finishTime=$("[name='docFinishTime']").val();
				//非全天.加上时、分
				if(!$("[name='fdIsAlldayevent']").val()){
					startTime+=" "+$("#startHour option:selected").val()+":"+$("#startMinute option:selected").val()+":00";
					finishTime+=" "+$("#endHour option:selected").val()+":"+$("#endMinute option:selected").val()+":00";
				}
				if(Date.parse(new Date(finishTime.replace(/-/g,"/")))<Date.parse(new Date(startTime.replace(/-/g,"/")))){
					 alert("开始时间不能晚于结束时间");
			    	return;
				}
	    		var url='${KMSS_Parameter_ContextPath}km/calendar/km_calendar_main/kmCalendarMain.do?method=saveEvent&simple=true';
	    		$.ajax({
					url: url,
					type: 'POST',
					dataType: 'json',
					async: false,
					data: $("#eventform").serialize(),
					success: function(data, textStatus, xhr) {//操作成功
						if (data && data['status'] === true) {
							window.location.href='<c:url value="/km/calendar/pda/index.jsp"/>'; 
						}
					},
					error:function(xhr, textStatus, errorThrown){//操作失败
						alert("<bean:message key='errors.unknown' />");
					}
				});
	       }
        </script>
    </article>
    
    <%--标签--%>
    <article id="label" class="mbody">
    	<ul class="listBox">
            <li>
            	<h2><bean:message bundle="km-calendar"  key="kmCalendarMain.docLabel" /></h2>
            </li>
            <c:forEach items="${labels}" var="label" >
    			<li <c:if test="${label[0] == kmCalendarMainForm.labelId }">class='on'</c:if> data='${label[0]}'><span class="title">${label[1]}</span><i class="sele"></i></li>
    		</c:forEach>
        </ul>
         <script type="text/javascript">
			//选择标签
			$("#label li").click(function(){
				$("#label li").removeClass("on");
				$(this).addClass("on");
				var selectValue=$(this).attr("data");
				var selectText=$(this).children("span").text();
				$("[name='labelId']").val(selectValue).prev().text(selectText);
				back();
			});
         </script>
    </article>
    
    <%--提醒--%>
    <article id="remind" class="mbody">
    	<script type="text/javascript">
    		//提醒机制提供的回调函数，在初始化提醒后触发
			function init_sysNotifyRemind_kmCalendarMainForm_callback(rtnValue){
				var text=rtnValue['text'];
				$("#remind_text").text(text);
			}
			//提醒机制提供的回调函数，在选择提醒后触发
			function submit_sysNotifyRemind_kmCalendarMainForm_callback(rtnValue){
				var text=rtnValue['text'];
				$("#remind_text").text(text);
				back();
			}
         </script>
    	<c:import url="/sys/notify/pda/sysNotifyRemindMain_edit4pda.jsp" charEncoding="UTF-8">
    		<c:param name="formName" value="kmCalendarMainForm" />
			<c:param name="fdKey" value="kmCalenarMainDoc" />
			<c:param name="fdPrefix" value="event" />
			<c:param name="fdModelName" value="com.landray.kmss.km.calendar.model.KmCalendarMain" />
		</c:import>
    </article>
    
  	<%--重复信息--%>
    <article id="recurrenceType" class="mbody">
    	<ul class="listBox">
            <li>
            	<h2><bean:message bundle="km-calendar"  key="kmCalendarMain.fdRecurrenceType" /></h2>
            </li>
            <%--不重复--%>
            <li class="on" data="NO">
            	<span class="title"><bean:message bundle="km-calendar"  key="recurrence.freq.no" /></span><i class="sele"></i>
            </li>
             <%--按天--%>
            <li data="DAILY">
            	<span class="title"><bean:message bundle="km-calendar"  key="recurrence.freq.daily" /></span><i class="sele"></i>
            </li>
             <%--按周--%>
            <li data="WEEKLY">
            	<span class="title"><bean:message bundle="km-calendar"  key="recurrence.freq.weekly" /></span><i class="sele"></i>
            </li>
            <%--按月--%>
            <li data="MONTHLY">
            	<span class="title"><bean:message bundle="km-calendar"  key="recurrence.freq.monthly" /></span><i class="sele"></i>
            </li>
             <%--按年--%>
            <li data="YEARLY">
            	<span class="title"><bean:message bundle="km-calendar"  key="recurrence.freq.yearly" /></span><i class="sele"></i>
            </li>
        </ul>
         <script type="text/javascript">
       		//选择重复信息
			$("#recurrenceType li").click(function(){
				$("#recurrenceType li").removeClass("on");
				$(this).addClass("on");
				var selectValue=$(this).attr("data");
				var selectText=$(this).children("span").text();
				if(selectValue=="WEEKLY"){
					var today=new Date();
					var weekStr=["SU","MO","TU","WE","TH","FR","SA"];
					$("[name='RECURRENCE_WEEKS']").val(weekStr[today.getDay()]);
				}
				$("[name='RECURRENCE_FREQ']").val(selectValue).prev().text(selectText);
				back();
			});
         </script>
    </article>
    
    
    <%--活动性质--%>
    <article id="authorityType" class="mbody">
        <ul class="listBox">
            <li>
            	<h2><bean:message bundle="km-calendar"  key="kmCalendarMain.fdAuthorityType" /></h2>
            </li>
            <%--默认--%>
            <li class="on" data="DEFAULT">
            	<span class="title" ><bean:message bundle="km-calendar"  key="authority.type.default" /></span><i class="sele"></i>
            </li>
             <%--公开--%>
            <li data="PUBLIC">
            	<span class="title" ><bean:message bundle="km-calendar"  key="authority.type.public" /></span><i class="sele"></i>
            </li>
            <%--私人--%>
            <li data="PRIVATE">
            	<span class="title" ><bean:message bundle="km-calendar"  key="authority.type.private" /></span><i class="sele"></i>
            </li>
        </ul>
         <script type="text/javascript">
			//选择活动性质
			$("#authorityType li").click(function(){
				$("#authorityType li").removeClass("on");
				$(this).addClass("on");
				var selectValue=$(this).attr("data");
				var selectText=$(this).children("span").text();
				$("[name='fdAuthorityType']").val(selectValue).prev().text(selectText);
				back();
			});
         </script>
    </article>
    
    </html:form>
    <script type="text/javascript">
		//国际化资源
		var calendarLANG={
			DEFAULT:'<bean:message bundle="km-calendar"  key="authority.type.default" />',
			PUBLIC:'<bean:message bundle="km-calendar"  key="authority.type.public" />',
			PRIVATE:'<bean:message bundle="km-calendar"  key="authority.type.private" />',
			NO:'<bean:message bundle="km-calendar"  key="recurrence.freq.no" />',
			DAILY:'<bean:message bundle="km-calendar"  key="recurrence.freq.daily" />',
			WEEKLY:'<bean:message bundle="km-calendar"  key="recurrence.freq.weekly" />',
			MONTHLY:'<bean:message bundle="km-calendar"  key="recurrence.freq.monthly" />',
			YEARLY:'<bean:message bundle="km-calendar"  key="recurrence.freq.yearly" />'
		};
    
    	//切换全天
    	$("#switch").click(function(){
        	//全天状态
        	if($(this).hasClass("switchOn")){
            	$(this).removeClass("switchOn").addClass("switchOff");
            	$("#startTimeDiv,#endTimeDiv").show();
            	$("[name='fdIsAlldayevent']").val("");
            }else{
            	$(this).removeClass("switchOff").addClass("switchOn");
            	$("#startTimeDiv,#endTimeDiv").hide();
            	$("[name='fdIsAlldayevent']").val("true");
            }
        });
        //显示指定页面
        function showArticle(article){
        	$(".mbody").removeClass("active");
        	$("#"+article).addClass("active");
        }
		//返回
		function back(){
			showArticle('main');
		}
		//初始化
		if("${kmCalendarMainForm.fdIsAlldayevent}"=="true"){
			$("#startTimeDiv,#endTimeDiv").hide();
		}
		$("#recurrenceType_text").text(calendarLANG["${kmCalendarMainForm.RECURRENCE_FREQ}"]);
		$("#authorityType_text").text(calendarLANG["${kmCalendarMainForm.fdAuthorityType}"]);
    </script>
</body>
</html>
