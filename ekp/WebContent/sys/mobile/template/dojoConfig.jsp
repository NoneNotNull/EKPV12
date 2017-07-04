<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@ page language="java" pageEncoding="UTF-8"%>
		<script type="text/javascript">
		var dojoConfig = {
			parseOnLoad: false,
			async: true,
			baseUrl:'<%=request.getContextPath()%>/',
			locale: '<%= ResourceUtil.getLocaleStringByUser(request) %>',
			packages: [{
			    name: "dojo",
			    location: "<%=request.getContextPath()%>/sys/mobile/js/dojo"
			},{
			    name: "dijit",
			    location: "<%=request.getContextPath()%>/sys/mobile/js/dijit"
			},{
			    name: "dojox",
			    location: "<%=request.getContextPath()%>/sys/mobile/js/dojox"
			},{
				name: 'mui',
				location: '<%=request.getContextPath()%>/sys/mobile/js/mui'
			}],
			paths: {
				"mui/mui": "<%=request.getContextPath()%>/sys/mobile/js/mui/mui.min"
			},
			calendar:{
				//周起始日,跟标准保持一致(admin.do里将星期天设为了1,星期一设为了2....)
				"firstDayInWeek":parseInt(<%= ResourceUtil.getKmssConfigString("kmss.period.type.week.startdate") %>)-1
			}
		};
		</script>