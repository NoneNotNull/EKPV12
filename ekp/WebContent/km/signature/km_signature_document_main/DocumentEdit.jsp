<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.landray.kmss.km.signature.util.iDBManager2000" %>
<%!
  iDBManager2000 ObjConnBean = new iDBManager2000();
  String SendOut_Enabled = "",Consult_Enabled = "";
  String RecordID,DocNo,UserName,Security,Draft,Check;
  String Title,CopyTo,Subject,Copies,DateTime;
%>
<%
  String mScriptName = "/DocumentEdit.jsp";
  String mServerName="/iWebServer.jsp";
  String mHttpUrlName=request.getRequestURI();
  String mServerUrl="http://"+request.getServerName()+":"+request.getServerPort()+mHttpUrlName.substring(0,mHttpUrlName.lastIndexOf(mScriptName))+mServerName;
  
  RecordID = "";
  RecordID = request.getParameter("fdRecordId");
  String EditType = "3";
  String UserName = "ZQ";
  String mNew = "0";

  //处理编号为空
  if (RecordID==null) {
    RecordID = "";
  }

  //取得模式
  if (EditType==null && EditType.equalsIgnoreCase("null")) {
    EditType = "1";		// 0 显示  1 会签 2 审核
  }
  if (EditType.equalsIgnoreCase("0")) {
     SendOut_Enabled = "0";
     Consult_Enabled = "0";
  }
  if (EditType.equalsIgnoreCase("1")) {
       SendOut_Enabled = "1";
       Consult_Enabled = "0";
  }
  if (EditType.equalsIgnoreCase("2")) {
     SendOut_Enabled = "0";
     Consult_Enabled = "1";
  }
  if (EditType.equalsIgnoreCase("3")) {
      SendOut_Enabled = "1";
      Consult_Enabled = "1";
  }

  //取得用户名
  if (UserName==null || UserName == "") {
    UserName = "测试用户";
  }

if (ObjConnBean.OpenConnection()) {
  String Sql="Select * From KmSignatureDocumentMain Where fdRecordId='"+ RecordID + "'";
  ResultSet rs = null;
  rs = ObjConnBean.ExecuteQuery(Sql);
  if (rs.next()) {
    RecordID = rs.getString("fdRecordId");
    DocNo = rs.getString("fdDocNo");
    Security = rs.getString("fdSecurity");
    Draft = rs.getString("fdDraft");
    Check = rs.getString("fdAuditor");
    Title = rs.getString("fdTitle");
    CopyTo = rs.getString("fdCopyTo");
    Subject = rs.getString("docSubject");
    Copies = rs.getString("fdCopies");
    DateTime = rs.getString("fdDateTime");
  }else {
    mNew = "1";
    //取得唯一值(mRecordID)
    java.util.Date dt=new java.util.Date();
    long lg=dt.getTime();
    Long ld=new Long(lg);
    RecordID=ld.toString();
    System.out.println(RecordID);
    DocNo = "KINGGRID-NC-2011-XX";
    Security = "一般";
    Draft = "已起草完成!";
    Check = "处理中...";
    Title = "关于XXX的决定";
    CopyTo = "策划部、市场部";
    Subject = "决定";
    Copies = "10份";
    DateTime = ObjConnBean.GetDateAsStr();
  }
  rs.close();
  ObjConnBean.CloseConnection();
}
%>

<html>
<head>
<title>iWebRevision 网页签批中间件</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<link REL="stylesheet" href="Test.css" type="text/css">
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

//初始化名称为Consult的控件对象
function initializtion(){
  DivID.insertAdjacentElement("beforeBegin",DocForm.Consult);
  DocForm.Consult.WebUrl = "<%=mServerUrl%>";           //WebUrl:系统服务器路径，与服务器交互操作，如打开签章信息
  DocForm.Consult.RecordID = "<%=RecordID%>";           //RecordID:本文档记录编号
  DocForm.Consult.FieldName = "Consult";                //FieldName:签章窗体可以根据实际情况再增加，只需要修改控件属性 FieldName 的值就可以
  DocForm.Consult.UserName = "<%=UserName%>";           //UserName:签名用户名称
  DocForm.Consult.Enabled = "<%=Consult_Enabled%>";     //Enabled:是否允许修改，0:不允许 1:允许  默认值:1 
  DocForm.Consult.PenColor = "#FF0066";                 //PenColor:笔的颜色，采用网页色彩值  默认值:#000000 
  DocForm.Consult.BorderStyle = "0";                    //BorderStyle:边框，0:无边框 1:有边框  默认值:1 
  DocForm.Consult.EditType = "0";                       //EditType:默认签章类型，0:签名 1:文字  默认值:0 
  DocForm.Consult.ShowPage = "0";                       //ShowPage:设置默认显示页面，0:电子印章,1:网页签批,2:文字批注  默认值:0 
  DocForm.Consult.InputText = "";                       //InputText:设置署名信息，  为空字符串则默认信息[用户名+时间]内容 
  DocForm.Consult.PenWidth = "3";                       //PenWidth:笔的宽度，值:1 2 3 4 5   默认值:2 
  DocForm.Consult.FontSize = "14";                      //FontSize:文字大小，默认值:11
  DocForm.Consult.SignatureType = "0";                  //SignatureType:签章来源类型，0表示从服务器数据库中读取签章，1表示从硬件密钥盘中读取签章，2表示从本地读取签章，并与ImageName(本地签章路径)属性相结合使用  默认值:0}
  DocForm.Consult.InputList = "同意\r\n不同意\r\n请上级批示\r\n已阅"; //InputList:设置文字批注信息列表 
  DocForm.Consult.Width = "100%";
  DocForm.Consult.Height = "100%";
  DocForm.Consult.style.display="block";
}

//作用：调入签章数据信息
function LoadSignature(){
  DocForm.SendOut.AppendMenu("9","-");                      //“签发”控件自定义右键菜单
  DocForm.SendOut.AppendMenu("10","[自定义]清除所有签批");  //“签发”控件自定义右键菜单

  initializtion();                                          //js方式设置控件属性
  DocForm.Consult.AppendMenu("1","自定义的右键菜单项");     //“会签”控件自定义右键菜单
  DocForm.Consult.DisableMenu("签名盖章...,文字批注...,撤消签章...");     //“会签”控件禁止某些右键菜单

  if("<%=mNew%>"!="1"){
    
    DocForm.SendOut.LoadSignature();                        //调用“签发”签章数据信息
    SendOutStatusMsg(DocForm.SendOut.Status);

    DocForm.Consult.SetFieldByName('Flag', '2');            //全屏签批后自动计算放置位置
    DocForm.Consult.LoadSignature();                        //调用“会签”签章数据信息
    ConsultStatusMsg(DocForm.Consult.Status);
  }else{
    SendOutStatusMsg("当前“签发”区域为新建的空白内容");
    ConsultStatusMsg("当前“会签”区域为新建的空白内容");
  }
}

//作用：保存签章数据信息  
//保存流程：先保存签章数据信息，成功后再提交到DocumentSave，保存表单基本信息
function SaveSignature(){
  if (DocForm.Consult.Modify){                    //判断签章数据信息是否有改动
    if (!DocForm.Consult.SaveSignature()){        //保存签章数据信息
      alert("保存会签签批内容失败！");
      return false;
    }
  }
  if (DocForm.SendOut.Modify){                    //判断签章数据信息是否有改动
    if (!DocForm.SendOut.SaveSignature()){        //保存签章数据信息
      alert("保存签发签批内容失败！");
      return false;  
    }
  }
  return true;
}

//作用：SendOut控件切换读取签章的来源方式 （*高级版本提供该功能）
function chgReadSignatureType(){
  if (DocForm.SendOut.SignatureType=="1"){
    DocForm.SendOut.SignatureType="0";
    alert("签发：签章来源从数据库中读取！");
  }else{
    DocForm.SendOut.SignatureType="1";
    alert("签发：签章来源从智能钥匙盘中读取！");
  }
}

//作用：SendOut控件打开签章窗口
function SendOutOpenSignature(){
  alert("---------");
  DocForm.SendOut.ShowDate("",2);
  alert("---------");
  if(DocForm.SendOut.OpenSignature()){
    SendOutStatusMsg("签章、签批成功。");
  }else{
    SendOutStatusMsg(DocForm.SendOut.Status);
  }
}

//作用：SendOut控件打开签章窗口
function SendEditTypeChange(){
  if (DocForm.SendOut.EditType==0){
    DocForm.SendOut.EditType=1;
    SendOutStatusMsg("当前为文字签批状态。");
  }
  else{
    DocForm.SendOut.EditType=0;
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

  DocForm.Consult.WebSetMsgByName("COMMAND","SELFINFO");    //设置变量COMMAND="SELFINFO"，用来在服务器端做判断，以进入处理自定义参数传递的代码。
  DocForm.Consult.WebSetMsgByName("TESTINFO",info);         //自定义的一个参数"TESTINFO"，将info变量的信息设置到信息包中，以便传到后台。
  if (DocForm.Consult.WebSendMessage()){                    //向后台发信息包。交互iWebServer的OPTION="SENDMESSAGE"。
    info = DocForm.Consult.WebGetMsgByName("RETURNINFO");   //如果交互成功，接受服务器端返回的信息。
    ConsultStatusMsg("信息交互成功。");
	alert(info);
  }
  else{
    ConsultStatusMsg(DocForm.Consult.Status);
  }
}

//作用：Consult控件打开签章窗口
function ConsultOpenSignature(){
  if(DocForm.Consult.OpenSignature()){
    ConsultStatusMsg("签章、签批成功。");
  }else{
    ConsultStatusMsg(DocForm.Consult.Status);
  }
}

//作用：控制Consult控件弹出窗口打开哪些TAB
function ConsultInvisiblePages(mIndex){
  var mShowPage = DocForm.Consult.ShowPage;

  if(mIndex==0){
    DocForm.Consult.ShowPage = "0";
    DocForm.Consult.InvisiblePages('1,2,');
  }
  else if(mIndex==1){
    DocForm.Consult.ShowPage = "1";
    DocForm.Consult.InvisiblePages('0,2,');
  }
  else if(mIndex==2){
    DocForm.Consult.ShowPage = "2";
    DocForm.Consult.InvisiblePages('0,1,');
  }
  var mMsg = DocForm.Consult.Status;
  if(mMsg==""){mMsg = "签章、签批成功。";}
  ConsultStatusMsg(mMsg);
  DocForm.Consult.ShowPage = mShowPage;
}

//作用：将Consult控件中的签批信息保存为gif图片
function ConsultSaveGif(){
  DocForm.Consult.OpinionTextInPic=false;       //控制输出的图片中是否包含文字签批内容
  if(DocForm.Consult.SaveAsGif('C:/abcd.gif')){
    ConsultStatusMsg('已成功保存在“C:/abcd.gif”！');
  }else{
    ConsultStatusMsg('输出图片失败！');
  }
}

//作用：将Consult控件中的本次签批信息清除
function ConsultClear(){
  if (!(DocForm.Consult.Enabled)) {
    alert('该签章已被锁定，无权编辑！');
  } 
  else{
    DocForm.Consult.Clear();
    ConsultStatusMsg("已经取消了本次签批的内容。");
  }
}

//作用：将Consult控件中的签批信息清除
function ConsultClearAll(){
  if (!(DocForm.Consult.Enabled)) {
    alert('该签章已被锁定，无权编辑！');
  } 
  else{
    DocForm.Consult.ClearAll();
    ConsultStatusMsg("已经清除了所有签批的内容。");
  }
}

//作用：为Consult控件设置颜色提示
function ConsultStartShowInfo(){
  DocForm.Consult.StartShowInfo("#FF0000");         //开启颜色提示
  ConsultStatusMsg("颜色提示中……");
  setTimeout("DocForm.Consult.EndShowInfo();ConsultStatusMsg('颜色提示结束。');",1000); //一秒后关闭颜色提示
}

//作用：Consult控件进行全屏签批
function ConsultShowZoomInHandWrite(){
  if(!DocForm.Consult.ShowZoomInHandWrite()){       //全屏签批 
    ConsultStatusMsg("放弃全屏签批。");
  }
}

//作用：Consult控件中使用迷你盖章窗口盖章
function ConsultOpenMiniSignature(){
  if(!DocForm.Consult.OpenMiniSignature()){
    ConsultStatusMsg("放弃盖章。");
  }else{
    ConsultStatusMsg("盖章成功。");
  }
}

//作用：Consult控件中判断某个用户是否进行了签批
function ConsultIsJuggled(){
  if(DocForm.Consult.IsJuggled("<%=UserName%>")){
    alert("用户“<%=UserName%>”已经进行过签批操作。");
  }else{
    alert("用户“<%=UserName%>”尚未进行过签批操作。");
  }
}

//作用：向Consult控件中载入远程图片
function ConsultLoadPicture(){
  if(DocForm.Consult.LoadPicture(10,10,'http://www.goldgrid.com/Images/GoldGridLogo.jpg')){
    ConsultStatusMsg("载入图片成功。");
  }
  else{
    ConsultStatusMsg("载入图片失败。");
  }
}

//作用：向Consult控件中设置文本内容
function ConsultInputValue(){
  DocForm.Consult.WriteName("拟同意！发公司领导审批！");
}

//得到当前批注中的文字批注内容
function WebGetText(){
  alert("当前文字批注内容为：“"+DocForm.Consult.OpinionText+"”\r\n\r\n注意：切换状态后文字批注内容将溶入图层变成图形内容，不再能获取。");
}

//隐藏控件右键菜单的“签名盖章”和“文字批注”
function HideRightMenu(){
  DocForm.Consult.InvisibleMenus("-2,-3,");         //“-2”代表的是“签名盖章”菜单，“-3”代表的是“文字批注“菜单，“-4”代表“签章信息”菜单，“-5”代表“撤销签章”菜单，“关于我们”菜单是不允许隐藏的。
  alert("“签名盖章”和“文字批注”菜单项被隐藏");
}

//删除当前用户的签批
function WebDelUserSignature(){
  try{
    var mResult = DocForm.Consult.DeleteUserSignature(DocForm.Consult.UserName);
    if(mResult){
      alert("删除用户“"+DocForm.Consult.UserName+"”的批注信息成功！");
    }else{
      alert("删除用户“"+DocForm.Consult.UserName+"”的批注信息失败！");
    }
  }
  catch(e){
    alert(e.description);                                   //显示出错误信息
  }
}
</script>

</head>
<body  onload="LoadSignature()" topmargin="10" bgcolor="c0c0c0">
<form name="DocForm" method="post" action="DocumentSave.jsp" onSubmit="return SaveSignature();">
<input type=hidden name=UserName value="<%=UserName%>">
<input type=hidden name=RecordID value="<%=RecordID%>">
<script src="iWebRevision.js"></script><!--调用iWebRevision，注意版本号，可用于升级。此处用js文件方式是为了处理“点击以激活控件”的问题-->
<table width=760 border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="000000">
<tr>
  <td colspan=2 bgcolor="#c0c0c0" height=32>
    <input type=submit value="  保存文档  ">&nbsp;
    <input type=button value="  打印输出  " onClick="javascript:PrintPage();">&nbsp;
    <input type=button value="  返回列表  " onClick="javascript:history.back();"><br>
    本页为普通页面，用户可根据自己的需求更改。注意：签章密码为<font color="red">0000</font>。<br>
    控件采用加密处理技术，支持各种开发和应用环境，可靠性好，扩展性强，适用于政府、企业和软件<br>
    开发商办公软件的应用集成。
  </td>
</tr>
<tr>
  <td id=Page>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
    <link REL="stylesheet" href="Test.css" type="text/css">
    <table width="758" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="ffffff">
	<tr><td height="80" align="center" valign="bottom"><font color="red" size="6"><b>金格科技公司发文稿纸<b></font></td></tr>
	<tr><td height="10">&nbsp;</td></tr>
	<tr>
		<td>
			<table width="600" border="0" cellspacing="0" cellpadding="0" align="center" >	
				<tr>
					<td style="border-bottom:1px solid; border-color:#FF0000" nowrap>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" >	
						   <tr>
						      <td width=64><font color="red">&nbsp;编号：</font></td>
						      <td ><input type="text" name=DocNo class=inputcss value=<%=DocNo%>></td>
						      <td width=64><font color="red">&nbsp;密级：</font></td>
                              <td width=64><input type="text" name=Security class=inputcss value=<%=Security%>></td>
						   </tr>
						</table>
					</td>
				</tr>			
				<tr>
					<td height="260">
						 <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">	
						   <tr>
						      <td width="55%" height="240" style="border-bottom:2px solid; border-color:#ff0000">
						          <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">	
						            <tr>
						              <td height="24" width="60" nowrap><font color="red" >&nbsp;签发：</font></td>
						              <td>
                                        <a class="LinkButton" onClick="SendOutOpenSignature()">[打开签章]</a>
						              	<a class="LinkButton" onClick="SendEditTypeChange()">[文字签批]</a>
						              	<a class="LinkButton" onClick="SendOut.ShowSignature();">[签章验证]</a> 
                                      </td>
						            </tr>
						            <tr>
						              <td height="100%" colspan="2" style="border-bottom:1px dashed;border-color:#999999; border-top:1px dashed;border-color:#999999">
                                        <OBJECT name="SendOut" classid="clsid:2294689C-9EDF-40BC-86AE-0438112CA439" codebase="iWebRevision.cab#version=6,0,0,0" width=100% height=100%>
                                          <param name="WebUrl" value="<%=mServerUrl%>">    <!-- WebUrl:系统服务器路径，与服务器交互操作，如打开签章信息 -->
                                          <param name="RecordID" value="<%=RecordID%>">    <!-- RecordID:本文档记录编号 -->
                                          <param name="FieldName" value="SendOut">         <!-- FieldName:签章窗体可以根据实际情况再增加，只需要修改控件属性 FieldName 的值就可以 -->
                                          <param name="UserName" value="<%=UserName%>">    <!-- UserName:签名用户名称 -->
                                          <param name="Enabled" value="<%=SendOut_Enabled%>">  <!-- Enabled:是否允许修改，0:不允许 1:允许  默认值:1  -->
                                          <param name="PenColor" value="#0099FF">     <!-- PenColor:笔的颜色，采用网页色彩值  默认值:#000000  -->
                                          <param name="BorderStyle" value="0">    <!-- BorderStyle:边框，0:无边框 1:有边框  默认值:1  -->
                                          <param name="EditType" value="0">    <!-- EditType:默认签章类型，0:签名 1:文字  默认值:0  -->
                                          <param name="ShowPage" value="0">    <!-- ShowPage:设置默认显示页面，0:电子印章,1:网页签批,2:文字批注  默认值:0  -->
                                          <param name="InputText" value="">    <!-- InputText:设置署名信息，  为空字符串则默认信息[用户名+时间]内容  -->
                                          <param name="PenWidth" value="2">     <!-- PenWidth:笔的宽度，值:1 2 3 4 5   默认值:2  -->
                                          <param name="FontSize" value="11">    <!-- FontSize:文字大小，默认值:11 -->
                                          <param name="SignatureType" value="0">    <!-- SignatureType:签章来源类型，0表示从服务器数据库中读取签章，1表示从硬件密钥盘中读取签章，2表示从本地读取签章，并与ImageName(本地签章路径)属性相结合使用  默认值:0 -->
                                          <param name="InputList" value="同意\r\n不同意\r\n请上级批示\r\n请速办理">    <!-- InputList:设置文字批注信息列表  -->
                                        </OBJECT>
                                      </td>
						            </tr>
                                    <tr>
                                      <td height="26" align="right" class="StatusLine" style="color:#0000ff">状态信息：</td>
                                      <td align="left" class="StatusLine" id="iSendOutStatusBar" nowrap>&nbsp;</td>
                                    </tr>
						          </table>
						      </td>
						      <td width="45%"  style="border-bottom:2px solid; border-color:#ff0000">
							    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">	
						            <tr>
						              <td width=4 height="120">&nbsp;</td>
						              <td width=80 align="center" style="border-left:1px dashed; border-color:#ff0000;border-bottom:1px solid; border-color:#ff0000"><font color="red" >拟稿：</font></td>
						              <td style="border-bottom:1px solid; border-color:#ff0000"><input type="text" name=Draft class=inputcss  value=<%=Draft%>></td>
						            </tr>
						            <tr>
						              <td width=4 height="120">&nbsp;</td>
						              <td width=80 align="center" style="border-left:1px dashed; border-color:#ff0000;"><font color="red" >核稿：</font></td>
						              <td ><input type="text" name=Check class=inputcss  value=<%=Check%>></td>
						            </tr>
						          </table>
						      </td>	
						   </tr>
						</table>
					</td>
				</tr>
				<tr>
                  <td style="border-bottom:2px solid;border-color:#ff0000;" height="320" nowrap >
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">	
                      <tr>
                        <td width="60" height="24" nowrap><font color="red" >&nbsp;会签：</font></td>
                        <td colspan="2">
                          <a class="LinkButton" onClick="Consult.EditType=1;ConsultStatusMsg('当前为文字签批状态。');">[文字签批]</a>
                          <a class="LinkButton" onClick="Consult.EditType=0;ConsultStatusMsg('当前为手写签批状态。');">[手写签批]</a>
                          <a class="LinkButton" onClick="ConsultShowZoomInHandWrite()">[全屏签批]</a>
                          <a class="LinkButton" onClick="ConsultOpenMiniSignature()">[迷你盖章]</a>
                          <a class="LinkButton" onClick="ConsultClear();">[取消修改]</a>
                          <a class="LinkButton" onClick="ConsultClearAll()">[清空全部]</a>
                          <a class="LinkButton" onClick="ConsultIsJuggled()">[是否签批]</a>
                          <a class="LinkButton" onClick="Consult.ShowSignature();">[签章验证]</a><br>
                          <a class="LinkButton" onClick="ConsultSaveGif();">[输出图片]</a>
                          <a class="LinkButton" onClick="ConsultLoadPicture();">[载入图片]</a>
                          <a class="LinkButton" onClick="ConsultStartShowInfo()">[颜色提示]</a>
                          <a class="LinkButton" onClick="Consult.WriteName('署名：<%=UserName%>')">[自动署名]</a>
                          <a class="LinkButton" onClick="ConsultInputValue()">[常用短语]</a>
                          <a class="LinkButton" onClick="WebSendInformation()">[信息交互]</a>
                          <a class="LinkButton" onClick="ConsultOpenSignature()">[打开完整签章窗口]</a><br>
                          <a class="LinkButton" onClick="WebGetText()">[文字批注内容]</a>
                          <a class="LinkButton" onClick="HideRightMenu()">[隐藏右键菜单项]</a>
                          <a class="LinkButton" onClick="WebDelUserSignature()">[删除批注]</a>
                        </td>
                      </tr>
                      <tr>
                        <td height="100%" colspan="3" style="border-bottom:1px dashed;border-color:#999999; border-top:1px dashed;border-color:#999999">
                          <div id="DivID"></div>                        </td>
                      </tr>
                      <tr>
                        <td height="26" align="right" class="StatusLine" style="color:#0000ff" nowrap>状态信息：</td>
                        <td width="260" align="left" class="StatusLine" id="iConsultStatusBar" nowrap>&nbsp;</td>
                        <td align="right" nowrap>
                          <a class="LinkButton" onClick="ConsultInvisiblePages(0)">[电子签章窗口]</a>
                          <a class="LinkButton" onClick="ConsultInvisiblePages(1)">[手写签名窗口]</a>
                          <a class="LinkButton" onClick="ConsultInvisiblePages(2)">[文字签批窗口]</a>
                        </td>
                      </tr>
                    </table>
                  </td>
				</tr>
				<tr>
					<td style="border-bottom:1px solid; border-color:#ff0000" height="50" nowrap >
						<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">
						   <tr>
						      <td width="100"><font color="red">&nbsp;标题：</font></td>
						      <td><input type="text" name=Title class=inputcss value=<%=Title%>></td>
						   </tr>
						</table>
					</td>
				</tr>	
				<tr>
					<td style="border-bottom:1px solid; border-color:#ff0000" height="50" nowrap  >
						<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%" >	
						   <tr>
						      <td width="100" ><font color="red">&nbsp;抄送：</font></td>
						      <td><input type="text" name=CopyTo class=inputcss  value=<%=CopyTo%>></td>
						   </tr>
						</table>
					</td>
				</tr>			
				<tr>
					<td style="border-bottom:1px solid; border-color:#ff0000" height="50" nowrap >
						<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">	
						   <tr>
						      <td width="100" ><font color="red">&nbsp;主题词：</font></td>
						      <td><input type="text" name=Subject class=inputcss  value=<%=Subject%>></td>
						   </tr>
						</table>
					</td>
				</tr>	
				<tr>
					<td style="border-bottom:1px solid; border-color:#ff0000" height="40" nowrap >
						<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center" height="100%">	
						   <tr>
						      <td width="100"  ><font color="red">&nbsp;印刷份数：</font></td>
						      <td style="border-right:1px solid red" width="200"><input type="text" name=Copies class=inputcss value=<%=Copies%>></td>
						      <td width="100"  ><font color="red">&nbsp;发文日期：</font></td>
						      <td><input type="text" name=DateTime readonly class=inputcss value=<%=DateTime%>></td>
						   </tr>
						</table>
					</td>
				</tr>
				<tr>
					<td style="border-bottom:1px solid; border-color:#ff0000" height="1" nowrap >
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td height="60">&nbsp;</td></tr>
    </table>
  </td>
  <td width=2></td>
</tr>
<tr>
  <td height=2></td>
  <td></td>
</tr>
</table>
</form>
</body>
</html>