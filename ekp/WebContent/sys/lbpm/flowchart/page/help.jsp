<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%> <%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>

<style>
body, td, input, select, textarea{
	font-size: 12px;
	color: #333333;
}
body{
	margin: 0px;
}
.tb_normal{
	border-collapse:collapse;
	border: 1px #C0C0C0 solid;
	background-color: #FFFFFF;
}
.td_normal, .tb_normal td{
	border-collapse:collapse;
	border: 1px #C0C0C0 solid;
	padding:3px;
}
.tr_normal_title{
	background-color: #F0F0F0;
	border-collapse:collapse;
	border: 1px #C0C0C0 solid;
	padding:3px;
	text-align:center;
	word-break:keep-all;
}
.td_normal_title{
	background-color: #F0F0F0;
	border-collapse:collapse;
	border: 1px #C0C0C0 solid;
	padding:3px;
	word-break:keep-all;
}
.inputsgl{
	color: #0066FF;
	border-color: #999999;
	border-style: solid;
	border-width: 0px 0px 1px 0px;
}
.btn{
	color: #0066FF; 
	background-color: #F0F0F0; 
	border: 1px #999999 solid; 
	font-weight: normal; 
	padding: 0px 1px 1px 0px;
	height: 18px;
	clip:  rect();
}
</style>
<body>
<center>
<p><br> 
  <strong><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.shortcutKeyList'/></strong></p>
<table class="tb_normal">
	<tr class="tr_normal_title">
	  <td style="width:100px"><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.category'/></td>
		<td style="width:200px">
			<bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.shortcutKey'/>
		</td>
		<td style="width:300px">
			<bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.function'/>
		</td>
		<td style="width:100px">
			<bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.remark'/>
		</td>
	</tr>
	<tr>
	  <td rowspan="11" style="text-align:center"><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.switchingMode'/><br>
	    <bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
		<td style="text-align:center">
			<bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.Q'/>
		</td>
		<td>
			<bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.switching_NormalMode'/></td>
		<td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
	</tr>
	<tr>
	  <td style="text-align:center">W</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.switching_LinkMode'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
	<tr>
	  <td style="text-align:center">A</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.switching_ApproveNode'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
	<tr>
	  <td style="text-align:center">S</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.switching_SignNode'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
	<tr>
	  <td style="text-align:center">D</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.switching_CopyNode'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
	<tr>
	  <td style="text-align:center">Z</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.artificialDecision'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
    <tr>
	  <td style="text-align:center">X</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.conditionBranch'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
    <tr>
	  <td style="text-align:center">C</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.switchingRobot'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
    <tr>
	  <td style="text-align:center">P</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.switchingStartSub'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
    <tr>
	  <td style="text-align:center">R</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.switchingRecoverSub'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
    <tr>
	  <td style="text-align:center">B</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.switchingSplit'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
	<tr>
	  <td rowspan="18" style="text-align:center"><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.normalMode'/></td>
	  <td style="text-align:center"><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.rightKey'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.showMenu'/></td>
	  <td>&nbsp;</td>
    </tr>
	<tr>
	  <td style="text-align:center"><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.hoverNode'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.shortCutInstruction'/></td>
	  <td>&nbsp;</td>
    </tr>
	<tr>
	  <td style="text-align:center"><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.hoverNode'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.showNodeDetail'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.timeOuts'/></td>
    </tr>
	<tr>
	  <td style="text-align:center"><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.clickNodeOrLink'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.selectNodeOrLink'/></td>
	  <td>&nbsp;</td>
    </tr>
	<tr>
	  <td style="text-align:center">Ctrl+<bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.clickNodeOrLink'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.addNodeToList'/></td>
	  <td>&nbsp;</td>
    </tr>
	<tr>
	  <td style="text-align:center"><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.dragNode'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.moveSelectedNodeLink'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
	<tr>
	  <td style="text-align:center"><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.doubleLinkEnter'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.showNodeAttribute'/></td>
	  <td>&nbsp;</td>
    </tr>
	<tr>
	  <td style="text-align:center"><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.doubleLink'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.showLinkAttribute'/></td>
	  <td>&nbsp;</td>
    </tr>
	<tr>
	  <td style="text-align:center">Shift+<bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.doubleLinkPoint'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.addLinkPonit'/>(<img src="../images/point.gif">)</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
	<tr>
	  <td style="text-align:center">Shift+<bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.doubleLinkPoint'/>(<img src="../images/point.gif">)</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.delLinkPoint'/>(<img src="../images/point.gif">)</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
	<tr>
	  <td style="text-align:center">Delete</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.deleteSelectedNodeLink'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
	<tr>
	  <td style="text-align:center">Ctrl/Shift+C</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.pasteSelectedNodeLink'/></td>
	  <td>&nbsp;</td>
    </tr>
	<tr>
	  <td style="text-align:center">Ctrl/Shift+V</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.pasteContent'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
	<tr>
	  <td style="text-align:center">Ctrl/Shift+A</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.selectAllNodeLink'/></td>
	  <td>&nbsp;</td>
    </tr>
	<tr>
	  <td style="text-align:center">Shift+D</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.unselectAllNodeLink'/></td>
	  <td>&nbsp;</td>
    </tr>
	<tr>
	  <td style="text-align:center">Shift+N</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.selectAllNode'/></td>
	  <td>&nbsp;</td>
    </tr>
	<tr>
	  <td style="text-align:center">Shift+L</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.selectAllLink'/></td>
	  <td>&nbsp;</td>
    </tr>
	<tr>
	  <td style="text-align:center">Shift+T</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.delUnnecessaryPoint'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
	<tr>
	  <td rowspan="6" style="text-align:center"><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.addLinkMode'/><br>
        <bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
	  <td style="text-align:center"><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.hoverNode'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.showNodePoint'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
	<tr>
	  <td style="text-align:center"><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.clickNode'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.dragLink'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
	<tr>
	  <td style="text-align:center"><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.clickBlackAtLine'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.addPoint'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
	<tr>
	  <td style="text-align:center"><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.clickNodeAtLine'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.createLink'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
	<tr>
	  <td style="text-align:center"><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.rightClickAtLine'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.cancelLink'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
	<tr>
	  <td style="text-align:center"><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.rightKey'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.backNormal'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
	<tr>
	  <td rowspan="6" style="text-align:center"><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.addNode'/><br>
	    <bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
	  <td style="text-align:center"><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.clickBlackNormalMode'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.createNode'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
    <tr>
	  <td style="text-align:center">Shift+<bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.clickBlack'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.createNodeContinuously'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
	<tr>
	  <td style="text-align:center"><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.hoverLink'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.showSelectedStatus'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
	<tr>
	  <td style="text-align:center"><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.clickLine'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.createNodeAndInsertMiddleNormalMode'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
    <tr>
	  <td style="text-align:center">Shift+<bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.clickLine'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.createNodeAndInsertMiddle'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
	<tr>
	  <td style="text-align:center"><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.rightKey'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.backNormal'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
	<tr>
	  <td rowspan="8" style="text-align:center"><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.allModel'/></td>
	  <td style="text-align:center">Shift+K</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.examFlow'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.editStatus'/></td>
    </tr>
	<tr>
	  <td style="text-align:center">Shift+F</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.FullOrNormalSreen'/></td>
	  <td>&nbsp;</td>
    </tr>
	<tr>
	  <td style="text-align:center">Shift+↓</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.enlargeCanvas'/></td>
	  <td>&nbsp;</td>
    </tr>
	<tr>
	  <td style="text-align:center">Shift+↑</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.narrowCanvas'/></td>
	  <td>&nbsp;</td>
    </tr>
	<tr>
	  <td style="text-align:center">F1/Shift+H</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.showShortCutHelp'/></td>
	  <td>&nbsp;</td>
    </tr>
	<tr>
	  <td style="text-align:center">Shift+R</td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.BackDisplayScale'/></td>
	  <td>&nbsp;</td>
    </tr>
	<tr>
	  <td style="text-align:center">Shift+<bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.MouseUpRoller'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.Max_Scale_TenPercent'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.Max_Scale_FiftyPerCent'/></td>
    </tr>
	<tr>
	  <td style="text-align:center">Shift+<bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.MouseDownRoller'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.Min_Scale_TenPerCent'/></td>
	  <td><bean:message bundle='sys-lbpm-engine' key='FlowChartHelp.Min_Scale_FiftyPerCent'/></td>
    </tr>
</table>
<p>&nbsp;</p>
</center>
</body>
