<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
-----------------------签章头部代码begin----------------------------
<%@ page import="java.io.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="DBstep.iMsgServer2000.*"%>
<%@ page import="com.landray.kmss.util.UserUtil"%>
<%@ page import="com.landray.kmss.km.signature.util.iDBManager2000" %>
<%@ page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@ page import="com.landray.kmss.sys.lbpm.engine.service.ProcessExecuteService"%>
<%@ page import="com.landray.kmss.sys.lbpm.engine.service.ProcessInstanceInfo" %>
<%@ page import="com.landray.kmss.sys.lbpm.engine.persistence.model.LbpmNode" %>
<%@ page import="com.landray.kmss.sys.lbpm.engine.service.ProcessDefinitionInfo" %>
<%@ page import="com.landray.kmss.sys.lbpm.engine.builder.ProcessDefinition" %>
<%@ page import="com.landray.kmss.sys.lbpm.engine.builder.NodeDefinition" %>
<%!
  iDBManager2000 ObjConnBean = new iDBManager2000();
  String SendOut_Enabled = "",Consult_Enabled = "";
  String RecordID,DocNo,UserName,Security,Draft,Check;
  String Title,CopyTo,Subject,Copies,DateTime;
%>
<%
  RecordID = "";
  RecordID = request.getParameter("fdRecordId");
  String EditType = "3";
  String UserName = "ZQ";

  //处理编号为空
  if (RecordID==null) {
    RecordID = "";
  }
  //取得用户名
  if (UserName==null || UserName == "") {
    UserName = "测试用户";
  }
  
	//取得唯一值(mRecordID)
	java.util.Date dt=new java.util.Date();
	long lg=dt.getTime();
	Long ld=new Long(lg);
	RecordID=ld.toString();
	DocNo = "KINGGRID-NC-2011-XX";
	Security = "一般";
	Draft = "已起草完成!";
	Check = "处理中...";
	Title = "关于XXX的决定";
	CopyTo = "策划部、市场部";
	Subject = "决定";
	Copies = "10份";
	DateTime = ObjConnBean.GetDateAsStr();
	//System.out.println(RecordID);

	String fdId = request.getParameter("fdId");
	String fileValue1="";
	String fileValue2="";
	String fileValue3="";
	String fileValue4="";
	String fileValues="";

if (ObjConnBean.OpenConnection() && fdId!=null) {
  String Sql1="Select * From km_signature_document_signature Where fdRecordId='"+ fdId + "' ORDER BY fdDateTime";
  ResultSet rs1 = null;
  rs1 = ObjConnBean.ExecuteQuery(Sql1);
  while (rs1.next()) {
	  fileValues += rs1.getString("fdFieldValue")+"#";
   }
  rs1.close();
  ObjConnBean.CloseConnection();
}
if(!"".equals(fileValues)){
	String[] values=fileValues.split("#");
	int len=values.length;
	if(len==1){fileValue1=values[0];}
	if(len==2){
		fileValue1=values[0];
		fileValue2=values[1];
	}
	if(len==3){
		fileValue1=values[0];
		fileValue2=values[1];
		fileValue3=values[2];
	}
	if(len==4){
		fileValue1=values[0];
		fileValue2=values[1];
		fileValue3=values[2];
		fileValue4=values[3];
	}
}
//获取当前结点及所有结点
String nodeId="";
List allNodes=new ArrayList();
String object1="";
String object2="";
String object3="";
String object4="";
if(fdId!=null){
	ProcessExecuteService processExecuteService = (ProcessExecuteService)SpringBeanUtil.getBean("lbpmProcessExecuteService");
	ProcessInstanceInfo processInstanceInfo = processExecuteService.load(fdId);
	List nodes=processInstanceInfo.getCurrentNodes();// 这个就是当前节点信息
	if(nodes.size()>0){
		LbpmNode node=(LbpmNode)nodes.get(0);
		nodeId=node.getFdFactNodeId();
	}
	allNodes=processInstanceInfo.getProcessDefinitionInfo().getDefinition().getNodes();
	int size=allNodes.size();
	if(size==4){object1=((NodeDefinition)allNodes.get(2)).getId();}
	if(size==5){
		object1=((NodeDefinition)allNodes.get(2)).getId();
		object2=((NodeDefinition)allNodes.get(3)).getId();
	}
	if(size==6){
		object1=((NodeDefinition)allNodes.get(2)).getId();
		object2=((NodeDefinition)allNodes.get(3)).getId();
		object3=((NodeDefinition)allNodes.get(4)).getId();
	}
	if(size==7){
		object1=((NodeDefinition)allNodes.get(2)).getId();
		object2=((NodeDefinition)allNodes.get(3)).getId();
		object3=((NodeDefinition)allNodes.get(4)).getId();
		object4=((NodeDefinition)allNodes.get(5)).getId();
	}
}
%>

<script language="javascript" for=SendOut event="OnMenuClick(vIndex,vCaption)">
  if (vIndex==10){  //自定义菜单事件
    alert("这里是“签发”控件自定义菜单演示：清除所有签章、签批信息");
    SendOut.ClearAll();
    SendOutStatusMsg("清除所有签章、签批信息成功。");
  }
</script>
<script language="javascript" for=Consult event="OnMenuClick(vIndex,vCaption)">
  if (vIndex==1){  //自定义菜单事件
    alert("这里是“会签”控件自定义右键菜单点击事件。");
  }
</script>
<script language=javascript>
//作用：显示Consult操作状态
function ConsultStatusMsg(mString){
  iConsultStatusBar.innerText=" "+mString;
}

//作用：显示SendOut操作状态
function SendOutStatusMsg(mString){
  iSendOutStatusBar.innerText=" "+mString;
}

//作用：调入签章数据信息
function LoadSignature(){
 // kmReviewMainForm.SendOut.AppendMenu("9","-");                    //“签发”控件自定义右键菜单
 // kmReviewMainForm.SendOut.AppendMenu("10","[自定义]清除所有签批");  //“签发”控件自定义右键菜单
 //initializtion();                                          //js方式设置控件属性
 // kmReviewMainForm.Consult.AppendMenu("1","自定义的右键菜单项");     //“会签”控件自定义右键菜单
  kmReviewMainForm.Consult.DisableMenu("签名盖章...,文字批注...,撤消签章...");     //“会签”控件禁止某些右键菜单
  SendOutStatusMsg("当前“签发”区域为新建的空白内容");
  ConsultStatusMsg("当前“会签”区域为新建的空白内容");
}

//作用：保存签章数据信息  
//保存流程：先保存签章数据信息，成功后再提交到DocumentSave，保存表单基本信息
function SaveSignature(){
   if (!kmReviewMainForm.Consult.SaveSignature()){        //保存签章数据信息
     alert("保存会签签批内容失败！");
     return false;
   }
  if (kmReviewMainForm.<%=nodeId%>.Modify){                    //判断签章数据信息是否有改动
    if (!kmReviewMainForm.<%=nodeId%>.SaveSignature()){        //保存签章数据信息
      alert("保存签发签批内容失败！");
      return false;  
    }
  }
  return true;
}

//作用：SendOut控件切换读取签章的来源方式 （*高级版本提供该功能）
function chgReadSignatureType(){
  if (kmReviewMainForm.<%=nodeId%>.SignatureType=="1"){
    kmReviewMainForm.<%=nodeId%>.SignatureType="0";
    alert("签发：签章来源从数据库中读取！");
  }else{
    kmReviewMainForm.<%=nodeId%>.SignatureType="1";
    alert("签发：签章来源从智能钥匙盘中读取！");
  }
}

//作用：SendOut控件打开签章窗口
function SendOutOpenSignature(){
  kmReviewMainForm.<%=nodeId%>.ShowDate("",2);
  if(kmReviewMainForm.<%=nodeId%>.OpenSignature()){
    SendOutStatusMsg("签章、签批成功。");
  }else{
    SendOutStatusMsg(kmReviewMainForm.<%=nodeId%>.Status);
  }
}

//作用：SendOut控件打开文字签批窗口
function SendEditTypeChange(){
  if (kmReviewMainForm.<%=nodeId%>.EditType==0){
    kmReviewMainForm.<%=nodeId%>.EditType=1;
    SendOutStatusMsg("当前为文字签批状态。");
  }else{
    kmReviewMainForm.<%=nodeId%>.EditType=0;
    SendOutStatusMsg("当前为手写签批状态。");
  }
}

//作用：打印页
function PrintPage() { 
  var pwin=window.open("","print"); 
  pwin.document.write(Page.innerHTML); 
  pwin.print(); 
  //pwin.close();
}

//作用：Consult控件客户端和服务器端信息信息交互
function WebSendInformation(){
  var info = window.prompt("请输入要传到服务器处理页面上的内容:","参数内容");
  if (info==null){return false}

  kmReviewMainForm.Consult.WebSetMsgByName("COMMAND","SELFINFO");    //设置变量COMMAND="SELFINFO"，用来在服务器端做判断，以进入处理自定义参数传递的代码。
  kmReviewMainForm.Consult.WebSetMsgByName("TESTINFO",info);         //自定义的一个参数"TESTINFO"，将info变量的信息设置到信息包中，以便传到后台。
  if (kmReviewMainForm.Consult.WebSendMessage()){                    //向后台发信息包。交互iWebServer的OPTION="SENDMESSAGE"。
    info = kmReviewMainForm.Consult.WebGetMsgByName("RETURNINFO");   //如果交互成功，接受服务器端返回的信息。
    ConsultStatusMsg("信息交互成功。");
	alert(info);
  }else{
    ConsultStatusMsg(kmReviewMainForm.Consult.Status);
  }
}

//作用：Consult控件打开签章窗口
function ConsultOpenSignature(){
  if(kmReviewMainForm.Consult.OpenSignature()){
    ConsultStatusMsg("签章、签批成功。");
  }else{
    ConsultStatusMsg(kmReviewMainForm.Consult.Status);
  }
}

//作用：控制Consult控件弹出窗口打开哪些TAB
function ConsultInvisiblePages(mIndex){
  var mShowPage = kmReviewMainForm.Consult.ShowPage;
  if(mIndex==0){
    kmReviewMainForm.Consult.ShowPage = "0";
    kmReviewMainForm.Consult.InvisiblePages('1,2,');
  }else if(mIndex==1){
    kmReviewMainForm.Consult.ShowPage = "1";
    kmReviewMainForm.Consult.InvisiblePages('0,2,');
  }else if(mIndex==2){
    kmReviewMainForm.Consult.ShowPage = "2";
    kmReviewMainForm.Consult.InvisiblePages('0,1,');
  }
  var mMsg = kmReviewMainForm.Consult.Status;
  if(mMsg==""){mMsg = "签章、签批成功。";}
  ConsultStatusMsg(mMsg);
  kmReviewMainForm.Consult.ShowPage = mShowPage;
}

//作用：将Consult控件中的签批信息保存为gif图片
function ConsultSaveGif(){
  kmReviewMainForm.Consult.OpinionTextInPic=false;       //控制输出的图片中是否包含文字签批内容
  if(kmReviewMainForm.Consult.SaveAsGif('C:/abcd.gif')){
    ConsultStatusMsg('已成功保存在“C:/abcd.gif”！');
  }else{
    ConsultStatusMsg('输出图片失败！');
  }
}

//作用：将Consult控件中的本次签批信息清除
function ConsultClear(){
  if (!(kmReviewMainForm.Consult.Enabled)) {
    alert('该签章已被锁定，无权编辑！');
  }else{
    kmReviewMainForm.Consult.Clear();
    ConsultStatusMsg("已经取消了本次签批的内容。");
  }
}

//作用：将Consult控件中的签批信息清除
function ConsultClearAll(){
  if (!(kmReviewMainForm.Consult.Enabled)) {
    alert('该签章已被锁定，无权编辑！');
  } else{
    kmReviewMainForm.Consult.ClearAll();
    ConsultStatusMsg("已经清除了所有签批的内容。");
  }
}

//作用：为Consult控件设置颜色提示
function ConsultStartShowInfo(){
  kmReviewMainForm.Consult.StartShowInfo("#FF0000");         //开启颜色提示
  ConsultStatusMsg("颜色提示中……");
  setTimeout("kmReviewMainForm.Consult.EndShowInfo();ConsultStatusMsg('颜色提示结束。');",1000); //一秒后关闭颜色提示
}

//作用：Consult控件进行全屏签批
function ConsultShowZoomInHandWrite(){
  if(!kmReviewMainForm.Consult.ShowZoomInHandWrite()){       //全屏签批 
    ConsultStatusMsg("放弃全屏签批。");
  }
}

//作用：Consult控件中使用迷你盖章窗口盖章
function ConsultOpenMiniSignature(){
  if(!kmReviewMainForm.Consult.OpenMiniSignature()){
    ConsultStatusMsg("放弃盖章。");
  }else{
    ConsultStatusMsg("盖章成功。");
  }
}

//作用：Consult控件中判断某个用户是否进行了签批
function ConsultIsJuggled(){
  if(kmReviewMainForm.Consult.IsJuggled("<%=UserName%>")){
    alert("用户“<%=UserName%>”已经进行过签批操作。");
  }else{
    alert("用户“<%=UserName%>”尚未进行过签批操作。");
  }
}

//作用：向Consult控件中载入远程图片
function ConsultLoadPicture(){
  if(kmReviewMainForm.Consult.LoadPicture(10,10,'http://www.goldgrid.com/Images/GoldGridLogo.jpg')){
    ConsultStatusMsg("载入图片成功。");
  }
  else{
    ConsultStatusMsg("载入图片失败。");
  }
}

//作用：向Consult控件中设置文本内容
function ConsultInputValue(){
  kmReviewMainForm.Consult.WriteName("拟同意！发公司领导审批！");
}

//得到当前批注中的文字批注内容
function WebGetText(){
  alert("当前文字批注内容为：“"+kmReviewMainForm.Consult.OpinionText+"”\r\n\r\n注意：切换状态后文字批注内容将溶入图层变成图形内容，不再能获取。");
}

//隐藏控件右键菜单的“签名盖章”和“文字批注”
function HideRightMenu(){
  kmReviewMainForm.Consult.InvisibleMenus("-2,-3,");         //“-2”代表的是“签名盖章”菜单，“-3”代表的是“文字批注“菜单，“-4”代表“签章信息”菜单，“-5”代表“撤销签章”菜单，“关于我们”菜单是不允许隐藏的。
  alert("“签名盖章”和“文字批注”菜单项被隐藏");
}

//删除当前用户的签批
function WebDelUserSignature(){
  try{
    var mResult = kmReviewMainForm.Consult.DeleteUserSignature(kmReviewMainForm.Consult.UserName);
    if(mResult){
      alert("删除用户“"+kmReviewMainForm.Consult.UserName+"”的批注信息成功！");
    }else{
      alert("删除用户“"+kmReviewMainForm.Consult.UserName+"”的批注信息失败！");
    }
  }catch(e){
    alert(e.description);                                   //显示出错误信息
  }
}
LoadSignature();
</script>
-----------------------签章头部代码end----------------------------

-----------------------签章区域一begin----------------------------
<c:if test="${kmReviewMainForm.docStatus!=30}">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">	
 <tr>
    <td height="24" width="60" nowrap><font color="red" >&nbsp;签发：</font></td>
    <td><a class="LinkButton" onClick="SendOutOpenSignature()">[打开签章]</a>
    	<a class="LinkButton" onClick="SendEditTypeChange()">[文字签批]</a>
    	<a class="LinkButton" onClick="SendOut.ShowSignature();">[签章验证]</a> 
    </td>
  </tr>
  <tr>
    <td height="100" colspan="2" style="border-bottom:1px dashed;border-color:#999999; border-top:1px dashed;border-color:#999999">
        <OBJECT name="<%=object1%>" classid="clsid:2294689C-9EDF-40BC-86AE-0438112CA439" codebase="${KMSS_Parameter_ContextPath}sys/attachment/plusin/iWebRevision.cab#version=6,5,0,275" width=100% height=100%>
          <param name="WebUrl" value="${KMSS_Parameter_ContextPath}km/signature/km_signature_document_main/iWebServer.jsp">    <!-- WebUrl:系统服务器路径，与服务器交互操作，如打开签章信息 -->
          <param name="RecordID" value="${kmReviewMainForm.fdId}">    <!-- RecordID:本文档记录编号 -->
          <param name="FieldName" value="<%=object1%>">         <!-- FieldName:签章窗体可以根据实际情况再增加，只需要修改控件属性 FieldName 的值就可以 -->
          <param name="UserName" value="<%=UserUtil.getUser().getFdName()%>">    <!-- UserName:签名用户名称 -->
          <param name="Enabled" value="1">  <!-- Enabled:是否允许修改，0:不允许 1:允许  默认值:1  -->
          <param name="PenColor" value="#0099FF">     <!-- PenColor:笔的颜色，采用网页色彩值  默认值:#000000  -->
          <param name="BorderStyle" value="0">    <!-- BorderStyle:边框，0:无边框 1:有边框  默认值:1  -->
          <param name="EditType" value="0">    <!-- EditType:默认签章类型，0:签名 1:文字  默认值:0  -->
          <param name="ShowPage" value="0">    <!-- ShowPage:设置默认显示页面，0:电子印章,1:网页签批,2:文字批注  默认值:0  -->
          <param name="InputText" value="">    <!-- InputText:设置署名信息，  为空字符串则默认信息[用户名+时间]内容  -->
          <param name="PenWidth" value="2">     <!-- PenWidth:笔的宽度，值:1 2 3 4 5   默认值:2  -->
          <param name="FontSize" value="11">    <!-- FontSize:文字大小，默认值:11 -->
		 <param name="value" value="<%=fileValue1%>">
          <param name="SignatureType" value="0">    <!-- SignatureType:签章来源类型，0表示从服务器数据库中读取签章，1表示从硬件密钥盘中读取签章，2表示从本地读取签章，并与ImageName(本地签章路径)属性相结合使用  默认值:0 -->
         <param name="InputList" value="同意\r\n不同意\r\n请上级批示\r\n请速办理">
        </OBJECT>
      </td>
  </tr>
  <tr>
    <td height="26" align="right" class="StatusLine" style="color:#0000ff">状态信息：</td>
    <td align="left" class="StatusLine" id="iSendOutStatusBar" nowrap>&nbsp;</td>
  </tr>
</table>
</c:if>
<c:if test="${kmReviewMainForm.docStatus==30}">
<div style="height=100;width=300">
	<OBJECT name="<%=object1%>" classid="clsid:2294689C-9EDF-40BC-86AE-0438112CA439" codebase="iWebRevision.cab#version=6,5,0,275" width=100% height=100%>
            <param name="Enabled" value="0">  <!-- Enabled:是否允许修改，0:不允许 1:允许  默认值:1  -->           
            <param name="BorderStyle" value="0">    <!-- BorderStyle:边框，0:无边框 1:有边框  默认值:1  -->
			<param name="FieldName" value="<%=object1%>"> 
            <param name="value" value="<%=fileValue1%>">
	</OBJECT>
</div>
</c:if>
-----------------------签章区域一end----------------------------
-----------------------签章区域二begin----------------------------
<c:if test="${kmReviewMainForm.docStatus!=30}">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">	
	 <tr>
          <td height="24" width="60" nowrap><font color="red" >&nbsp;签发：</font></td>
          <td><a class="LinkButton" onClick="SendOutOpenSignature()">[打开签章]</a>
          	<a class="LinkButton" onClick="SendEditTypeChange()">[文字签批]</a>
          	<a class="LinkButton" onClick="SendOut.ShowSignature();">[签章验证]</a> 
          </td>
        </tr>
		<tr>
	   		<td height="100" colspan="2" style="border-bottom:1px dashed;border-color:#999999; border-top:1px dashed;border-color:#999999">
            <OBJECT name="<%=object2%>" classid="clsid:2294689C-9EDF-40BC-86AE-0438112CA439" codebase="iWebRevision.cab#version=6,5,0,275" width=100% height=100%>
              <param name="WebUrl" value="${KMSS_Parameter_ContextPath}km/signature/km_signature_document_main/iWebServer.jsp">    <!-- WebUrl:系统服务器路径，与服务器交互操作，如打开签章信息 -->
              <param name="RecordID" value="${kmReviewMainForm.fdId}">    <!-- RecordID:本文档记录编号 -->
              <param name="FieldName" value="<%=object2%>">         <!-- FieldName:签章窗体可以根据实际情况再增加，只需要修改控件属性 FieldName 的值就可以 -->
              <param name="UserName" value="<%=UserUtil.getUser().getFdName()%>">    <!-- UserName:签名用户名称 -->
              <param name="Enabled" value="1">  <!-- Enabled:是否允许修改，0:不允许 1:允许  默认值:1  -->
              <param name="PenColor" value="#0099FF">     <!-- PenColor:笔的颜色，采用网页色彩值  默认值:#000000  -->
              <param name="BorderStyle" value="0">    <!-- BorderStyle:边框，0:无边框 1:有边框  默认值:1  -->
              <param name="EditType" value="0">    <!-- EditType:默认签章类型，0:签名 1:文字  默认值:0  -->
              <param name="ShowPage" value="0">    <!-- ShowPage:设置默认显示页面，0:电子印章,1:网页签批,2:文字批注  默认值:0  -->
              <param name="InputText" value="">    <!-- InputText:设置署名信息，  为空字符串则默认信息[用户名+时间]内容  -->
              <param name="PenWidth" value="2">     <!-- PenWidth:笔的宽度，值:1 2 3 4 5   默认值:2  -->
              <param name="FontSize" value="11">    <!-- FontSize:文字大小，默认值:11 -->
			  <param name="value" value="<%=fileValue2%>">
              <param name="SignatureType" value="0">    <!-- SignatureType:签章来源类型，0表示从服务器数据库中读取签章，1表示从硬件密钥盘中读取签章，2表示从本地读取签章，并与ImageName(本地签章路径)属性相结合使用  默认值:0 -->
	           <param name="InputList" value="同意\r\n不同意\r\n请上级批示\r\n请速办理">
	          </OBJECT>
              </td>
              </tr>
              <tr>
                <td height="26" align="right" class="StatusLine" style="color:#0000ff">状态信息：</td>
                <td align="left" class="StatusLine" id="iSendOutStatusBar" nowrap>&nbsp;</td>
             </tr>
</table>
</c:if>
<c:if test="${kmReviewMainForm.docStatus==30}">
<div style="height=100;width=300">
<OBJECT name="<%=object2%>" classid="clsid:2294689C-9EDF-40BC-86AE-0438112CA439" codebase="iWebRevision.cab#version=6,5,0,275" width=100% height=100%>
            <param name="Enabled" value="0">  <!-- Enabled:是否允许修改，0:不允许 1:允许  默认值:1  -->           
            <param name="BorderStyle" value="0">    <!-- BorderStyle:边框，0:无边框 1:有边框  默认值:1  -->
            <param name="FieldName" value="<%=object2%>"> 
            <param name="value" value="<%=fileValue2%>">
</OBJECT>
</div>
</c:if>
-----------------------签章区域二end----------------------------
-----------------------签章区域三begin----------------------------
<c:if test="${kmReviewMainForm.docStatus!=30}">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">	
	 <tr>
          <td height="24" width="60" nowrap><font color="red" >&nbsp;签发：</font></td>
          <td><a class="LinkButton" onClick="SendOutOpenSignature()">[打开签章]</a>
          	<a class="LinkButton" onClick="SendEditTypeChange()">[文字签批]</a>
          	<a class="LinkButton" onClick="SendOut.ShowSignature();">[签章验证]</a> 
          </td>
        </tr>
		<tr>
	   		<td height="100" colspan="2" style="border-bottom:1px dashed;border-color:#999999; border-top:1px dashed;border-color:#999999">
            <OBJECT name="<%=object3%>" classid="clsid:2294689C-9EDF-40BC-86AE-0438112CA439" codebase="iWebRevision.cab#version=6,5,0,275" width=100% height=100%>
              <param name="WebUrl" value="${KMSS_Parameter_ContextPath}km/signature/km_signature_document_main/iWebServer.jsp">    <!-- WebUrl:系统服务器路径，与服务器交互操作，如打开签章信息 -->
              <param name="RecordID" value="${kmReviewMainForm.fdId}">    <!-- RecordID:本文档记录编号 -->
              <param name="FieldName" value="<%=object3%>">         <!-- FieldName:签章窗体可以根据实际情况再增加，只需要修改控件属性 FieldName 的值就可以 -->
              <param name="UserName" value="<%=UserUtil.getUser().getFdName()%>">    <!-- UserName:签名用户名称 -->
              <param name="Enabled" value="1">  <!-- Enabled:是否允许修改，0:不允许 1:允许  默认值:1  -->
              <param name="PenColor" value="#0099FF">     <!-- PenColor:笔的颜色，采用网页色彩值  默认值:#000000  -->
              <param name="BorderStyle" value="0">    <!-- BorderStyle:边框，0:无边框 1:有边框  默认值:1  -->
              <param name="EditType" value="0">    <!-- EditType:默认签章类型，0:签名 1:文字  默认值:0  -->
              <param name="ShowPage" value="0">    <!-- ShowPage:设置默认显示页面，0:电子印章,1:网页签批,2:文字批注  默认值:0  -->
              <param name="InputText" value="">    <!-- InputText:设置署名信息，  为空字符串则默认信息[用户名+时间]内容  -->
              <param name="PenWidth" value="2">     <!-- PenWidth:笔的宽度，值:1 2 3 4 5   默认值:2  -->
              <param name="FontSize" value="11">    <!-- FontSize:文字大小，默认值:11 -->
			  <param name="value" value="<%=fileValue3%>">
              <param name="SignatureType" value="0">    <!-- SignatureType:签章来源类型，0表示从服务器数据库中读取签章，1表示从硬件密钥盘中读取签章，2表示从本地读取签章，并与ImageName(本地签章路径)属性相结合使用  默认值:0 -->
	           <param name="InputList" value="同意\r\n不同意\r\n请上级批示\r\n请速办理">
	          </OBJECT>
              </td>
              </tr>
              <tr>
                <td height="26" align="right" class="StatusLine" style="color:#0000ff">状态信息：</td>
                <td align="left" class="StatusLine" id="iSendOutStatusBar" nowrap>&nbsp;</td>
             </tr>
</table>
</c:if>
<c:if test="${kmReviewMainForm.docStatus==30}">
<div style="height=100;width=300">
<OBJECT name="<%=object3%>" classid="clsid:2294689C-9EDF-40BC-86AE-0438112CA439" codebase="iWebRevision.cab#version=6,5,0,275" width=100% height=100%>
            <param name="Enabled" value="0">  <!-- Enabled:是否允许修改，0:不允许 1:允许  默认值:1  -->           
            <param name="BorderStyle" value="0">    <!-- BorderStyle:边框，0:无边框 1:有边框  默认值:1  -->
            <param name="FieldName" value="<%=object3%>"> 
            <param name="value" value="<%=fileValue3%>">
</OBJECT>
</div>
</c:if>
-----------------------签章区域三end----------------------------
-----------------------签章区域四begin----------------------------
<c:if test="${kmReviewMainForm.docStatus!=30}">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">	
	 <tr>
          <td height="24" width="60" nowrap><font color="red" >&nbsp;签发：</font></td>
          <td><a class="LinkButton" onClick="SendOutOpenSignature()">[打开签章]</a>
          	<a class="LinkButton" onClick="SendEditTypeChange()">[文字签批]</a>
          	<a class="LinkButton" onClick="SendOut.ShowSignature();">[签章验证]</a> 
          </td>
        </tr>
		<tr>
	   		<td height="100" colspan="2" style="border-bottom:1px dashed;border-color:#999999; border-top:1px dashed;border-color:#999999">
            <OBJECT name="<%=object4%>" classid="clsid:2294689C-9EDF-40BC-86AE-0438112CA439" codebase="iWebRevision.cab#version=6,5,0,275" width=100% height=100%>
              <param name="WebUrl" value="${KMSS_Parameter_ContextPath}km/signature/km_signature_document_main/iWebServer.jsp">    <!-- WebUrl:系统服务器路径，与服务器交互操作，如打开签章信息 -->
              <param name="RecordID" value="${kmReviewMainForm.fdId}">    <!-- RecordID:本文档记录编号 -->
              <param name="FieldName" value="<%=object4%>">         <!-- FieldName:签章窗体可以根据实际情况再增加，只需要修改控件属性 FieldName 的值就可以 -->
              <param name="UserName" value="<%=UserUtil.getUser().getFdName()%>">    <!-- UserName:签名用户名称 -->
              <param name="Enabled" value="1">  <!-- Enabled:是否允许修改，0:不允许 1:允许  默认值:1  -->
              <param name="PenColor" value="#0099FF">     <!-- PenColor:笔的颜色，采用网页色彩值  默认值:#000000  -->
              <param name="BorderStyle" value="0">    <!-- BorderStyle:边框，0:无边框 1:有边框  默认值:1  -->
              <param name="EditType" value="0">    <!-- EditType:默认签章类型，0:签名 1:文字  默认值:0  -->
              <param name="ShowPage" value="0">    <!-- ShowPage:设置默认显示页面，0:电子印章,1:网页签批,2:文字批注  默认值:0  -->
              <param name="InputText" value="">    <!-- InputText:设置署名信息，  为空字符串则默认信息[用户名+时间]内容  -->
              <param name="PenWidth" value="2">     <!-- PenWidth:笔的宽度，值:1 2 3 4 5   默认值:2  -->
              <param name="FontSize" value="11">    <!-- FontSize:文字大小，默认值:11 -->
			  <param name="value" value="<%=fileValue4%>">
              <param name="SignatureType" value="0">    <!-- SignatureType:签章来源类型，0表示从服务器数据库中读取签章，1表示从硬件密钥盘中读取签章，2表示从本地读取签章，并与ImageName(本地签章路径)属性相结合使用  默认值:0 -->
	           <param name="InputList" value="同意\r\n不同意\r\n请上级批示\r\n请速办理">
	          </OBJECT>
              </td>
              </tr>
              <tr>
                <td height="26" align="right" class="StatusLine" style="color:#0000ff">状态信息：</td>
                <td align="left" class="StatusLine" id="iSendOutStatusBar" nowrap>&nbsp;</td>
             </tr>
</table>
</c:if>
<c:if test="${kmReviewMainForm.docStatus==30}">
<div style="height=100;width=300">
<OBJECT name="<%=object4%>" classid="clsid:2294689C-9EDF-40BC-86AE-0438112CA439" codebase="iWebRevision.cab#version=6,5,0,275" width=100% height=100%>
            <param name="Enabled" value="0">  <!-- Enabled:是否允许修改，0:不允许 1:允许  默认值:1  -->           
            <param name="BorderStyle" value="0">    <!-- BorderStyle:边框，0:无边框 1:有边框  默认值:1  -->
            <param name="FieldName" value="<%=object4%>"> 
            <param name="value" value="<%=fileValue4%>">
</OBJECT>
</div>
</c:if>
-----------------------签章区域四end----------------------------

-----------------------签章尾部代码begin----------------------------
<script>
Com_Parameter.event["submit"][Com_Parameter.event["submit"].length]=myCheck;
function myCheck(){
if(kmReviewMainForm.<%=nodeId%>.Modify){
    if (!kmReviewMainForm.<%=nodeId%>.SaveSignature()){
       alert("保存签发签批内容失败！");
      return false;  
    }
  }
return true;
}
</script>
-----------------------签章尾部代码end----------------------------