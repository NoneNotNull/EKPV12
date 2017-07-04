<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="/ekp/resource/js/sea.js"></script>
<script type="text/javascript" src="/ekp/resource/js/seaconfig.jsp"></script>
<script type="text/javascript">
	seajs.use([ 'lui/parser', 'lui/jquery','theme!common' ], function(parser, $) {
		$(document).ready(function() {
			parser.parse();
		});
	});
</script>
<title>ss</title>
</head>
<body style="background-color: ghostwhite;">
<table width="100%">
	<tr>
		<td style="height: 100px;width: 200px;">
		<script>
		function redraw(){
			seajs.use(['lui/base'],function(base){
				base.byId('sss').draw();
			})
		}
		</script>
		<input type="button" onclick="redraw()"/>
		</td>
		<td></td>
		<td style="width: 200px;"></td>
	</tr>
	<c:if test="${	param['type']=='1' || param['type']=='all'  }">
	<tr>
		<td>
		</td>
		<td style="border: 1px red solid;"> 
		 
			<ui:panel id="aaa" expand="true" style="background:red;" toggle="true" width="300" height="150" scroll="false"> 
				<ui:content title="test"  toggle="true">
					<ui:dataview format="sys.ui.classic">
						<ui:source ref="sys.news.main.source"></ui:source>
					</ui:dataview>
					<ui:operation href="a" name="更多"></ui:operation>
				</ui:content>
			</ui:panel> 
			  <br>
			  
			 <ui:nonepanel height="220" id="p_fc655276575523c15232">
       <ui:content title="引用其它网页">
        <ui:dataview format="sys.ui.iframe">
         <ui:source ref="sys.portal.iframe.source" var-src="http://www.baidu.com"></ui:source>
         <ui:render ref="sys.ui.iframe.default"></ui:render>
        </ui:dataview>
       </ui:content>
      </ui:nonepanel> 
		</td>
		<td></td>
	</tr>
	</c:if>
	 
	<c:if test="${	param['type']=='2' || param['type']=='all'  }">
	<tr>
		<td>
		</td>
		<td style="border: 1px red solid;">
			<ui:tabpanel id="sss" height="150" scroll="true"> 
				<ui:layout ref="sys.ui.tabpanel.default"></ui:layout>
				<ui:content title="test">
					<ui:layout ref="sys.ui.content.default"></ui:layout>
					<ui:dataview format="sys.ui.classic">
						<ui:source ref="sys.news.main.source"></ui:source>
					</ui:dataview>
					<ui:operation href="a" name="更多"></ui:operation>
				</ui:content>
				<ui:content title="test">
					<ui:layout ref="sys.ui.content.default"></ui:layout>
					<ui:dataview format="sys.ui.classic">
						<ui:source ref="sys.news.main.source"></ui:source>
					</ui:dataview>
					<ui:operation href="a" name="更多"></ui:operation>
				</ui:content>
			</ui:tabpanel>
		</td>
		<td></td>
	</tr>	
	</c:if>
 
	<c:if test="${	param['type']=='3' || param['type']=='all'  }">
	<tr>
		<td>
		</td>
		<td style="border: 1px red solid;">
			<ui:accordionpanel id="sss"> 
				<ui:layout ref="sys.ui.accordionpanel.default"></ui:layout>
				<ui:content title="test">
					<ui:layout ref="sys.ui.content.default"></ui:layout>
					<ui:dataview format="sys.ui.classic">
						<ui:source ref="sys.news.main.source"></ui:source>
					</ui:dataview>
					<ui:operation href="a" name="更多"></ui:operation>
				</ui:content>
				<ui:content title="test">
					<ui:layout ref="sys.ui.content.default"></ui:layout>
					<ui:dataview format="sys.ui.classic">
						<ui:source ref="sys.news.main.source"></ui:source>
					</ui:dataview>
					<ui:operation href="a" name="更多"></ui:operation>
				</ui:content>
			</ui:accordionpanel>
		</td>
		<td></td>
	</tr>
	</c:if> 
	
	<c:if test="${	param['type']=='4' || param['type']=='all'  }">
	<tr>
		<td>
		</td>
		<div style="height: 2000px;"></div>
		<td style="border: 1px red solid;">
			<ui:accordionpanel id="sss"> 
				<ui:layout ref="sys.ui.accordionpanel.float"></ui:layout>
				<ui:content title="test" toggle="true" expand="true"> 
					<ui:dataview format="sys.ui.classic">
						<ui:source ref="sys.news.main.source"></ui:source>
					</ui:dataview> 
				</ui:content>
				<ui:content title="test" toggle="false" expand="false"> 
					<ui:dataview format="sys.ui.classic">
						<ui:source ref="sys.news.main.source"></ui:source>
					</ui:dataview> 
				</ui:content>
			</ui:accordionpanel>
		</td>
		<td></td>
	</tr>
	</c:if> 
	<tr>
		<td>
		</td>
		<td></td>
		<td style="height: 100px;"><form target="_b"></a></td>
	</tr>
</table>
</body>
</html>
