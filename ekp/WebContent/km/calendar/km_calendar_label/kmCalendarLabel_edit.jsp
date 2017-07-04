<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="head">
		<template:super/>
		<link rel="Stylesheet" href="${LUI_ContextPath}/km/calendar/resource/css/calendar_label.css" />
		<script type="text/javascript" src="<c:url value="/resource/js/jquery.js"/>"></script>
		<script type="text/javascript" src="<c:url value="/km/calendar/resource/js/jquery.colorpicker.js"/>"></script>
		<script>
		seajs.use(['theme!form']);
		Com_IncludeFile("validator.jsp|validation.js|plugin.js|validation.jsp|eventbus.js|xform.js|calendar.js",null,"js");
		</script>
		
	
	</template:replace>
   <template:replace name="body">
   	<script type="text/javascript">
		
	    //标签新建保存
	    function save() {
	    	var ret = labelValidation.validate();
	    	if(!ret){
				return ;
		    }
	        var last_method = Com_GetUrlParameter(window.location.href, "method");
	    	var id = document.getElementsByName("fdId")[0].value;
	        var name = document.getElementsByName("fdName")[0].value;
	        var decript = document.getElementsByName("fdDescription")[0].value;
	        var order = document.getElementsByName("fdOrder")[0].value;
	        var color = $(".color_ul li.select a").css("background-color");
	        var modelName = document.getElementsByName("fdModelName")[0].value;
	        if(last_method=="edit"){
		        $.ajax({
			        url: '<c:url value="/km/calendar/km_calendar_label/kmCalendarLabel.do?method=updateJson" />',
			        dataType: 'json',
			        data: {
				        fdId: id,
			        	fdName: name,
			        	fdDescription: decript,
			        	fdColor: color,
			        	fdOrder: order,
			        	fdModelName:modelName
			        },
			        success: function(data) {
			    		window.$dialog.hide("true");
			        }
			    });
	    	}else{
		        $.ajax({
		            url: '<c:url value="/km/calendar/km_calendar_label/kmCalendarLabel.do?method=addJson" />',
		            dataType: 'json',
		            data: {
		            	fdName: name,
		            	fdDescription: decript,
		            	fdColor: color
		            },
		            success: function(data) {
		        		window.$dialog.hide("true");
		            }
		        });
	    	}
		}

		window.onload = function(){
			$(".color_ul li.select a").css("background-color", "${kmCalendarLabelForm.fdColor}");
			window.labelValidation = $KMSSValidation(document.forms['kmCalendarLabelForm']);
		}
	</script>
	<script type="text/javascript">
	    $(function () {
	        $(".color_ul li").each(function () {
	            $(this).click(function () {
	                var color = $(this).css("background-color");
	                $(".color_ul li.select a").css("background-color", color);
	            });
	        });
	        $('.sel_color_txt').colorpicker({
	            ishex: true, //是否使用16进制颜色值
	            fillcolor: false,  //是否将颜色值填充至对象的val中
	            target: null, //目标对象
	            event: 'click', //颜色框显示的事件
	            success: function (o, color) {
	                $(o).css("background-color", color);
	                $(".color_ul li.select a").css("background-color", color);
	            }, //回调函数
	            reset: function () { }
	        });
	    });
	</script>
   	<%--新建标签--%>
   	<div class="lui_calendar_label" style="display: block; width: 100%;">
   		<p class="txttitle">${lfn:message('km-calendar:kmCalendarLabel.tab.list')}</p>
   		<html:form action="/km/calendar/km_calendar_label/kmCalendarLabel.do">
   		<html:hidden property="fdId"/>
   		<html:hidden property="fdOrder"/>
   		<html:hidden property="fdModelName"/>
   		
   		<table class="tb_simple" width=100% >
   			<tr>
   				<%--名称--%>
	           <td width="15%" class="td_normal_title" valign="top">
	               <bean:message bundle="km-calendar" key="kmCalendarLabel.fdName" />
	           </td>
               <td width="85%">
               		<xform:text property="fdName" subject="${lfn:message('km-calendar:kmCalendarLabel.fdName')}" isLoadDataDict="fasle" validators="maxLength(200)" style="width:90%;" showStatus="edit" required="true" />
               </td>
	        </tr>
   			<tr>
   				<%--描述--%>
	           <td width="15%" class="td_normal_title" >
	               <bean:message bundle="km-calendar" key="kmCalendarLabel.fdDescription" />
	           </td>
               <td>
               		<xform:text property="fdDescription" className="inputsgl" style="width:90%;"  showStatus="edit"/>
               </td>
	        </tr>
	        <tr>
	       	 <%--选颜色--%>
	           <td width="15%" class="td_normal_title" >
	           		<bean:message bundle="km-calendar" key="kmCalendarLabel.fdColor" />
	           </td>
	           <td>
                   <ul class="clrfix color_ul">
                       <li class="select"><a></a></li>
                       <li class="line"></li>
                       <li class="color_1"></li>
                       <li class="color_2"></li>
                       <li class="color_3"></li>
                       <li class="color_4"></li>
                       <li class="color_5"></li>
                       <li class="color_6"></li>
                       <li class="color_7"></li>
                       <li class="color_8"></li>
                       <li class="color_9"></li>
                       <li class="color_10"></li>
                       <li class="color_11"></li>
                   </ul>
               </td>
	      	</tr>
	      	
   		</table>
   		</html:form>
   		<div class="lui_calendar_label_btnGroup" style="text-align: center;padding-top: 10px;">
   			<ui:button  text="${lfn:message('button.ok')}"  onclick="save();" style="width:70px;"/>
   		</div>
   	</div>
   </template:replace>
</template:include>
