<%@ page contentType="text/html; charset=gbk" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.landray.kmss.util.IDGenerator"%>
<%@ page import="com.landray.kmss.km.signature.util.iDBManager2000" %>
<%!
  iDBManager2000 ObjConnBean = new iDBManager2000();
  boolean mResult;
%>
<%
  String RecordID = new String(request.getParameter("RecordID").getBytes("8859_1"));
  String DocNo = new String(request.getParameter("DocNo").getBytes("8859_1"));
  String UserName = new String(request.getParameter("UserName").getBytes("8859_1"));
  String Security = new String(request.getParameter("Security").getBytes("8859_1"));
  String Draft = new String(request.getParameter("Draft").getBytes("8859_1"));
  String Check = new String(request.getParameter("Check").getBytes("8859_1"));
  String Title = new String(request.getParameter("Title").getBytes("8859_1"));
  String CopyTo = new String(request.getParameter("CopyTo").getBytes("8859_1"));
  String Subject = new String(request.getParameter("Subject").getBytes("8859_1"));
  String Copies = new String(request.getParameter("Copies").getBytes("8859_1"));
  String DateTime = new String(request.getParameter("DateTime").getBytes("8859_1"));


  //保存文档其它附属信息（如：编号、密级等）
  if (ObjConnBean.OpenConnection())
  {
    String strSql = "Select * from KmSignatureDocumentMain where fdRecordId = '"+ RecordID +"'";
    ResultSet rs = null;
    rs = ObjConnBean.ExecuteQuery(strSql);
    if (rs.next()) {
       strSql = "update KmSignatureDocumentMain set fdDocNo='"+DocNo+"',fdUserName='"+UserName+"',fdSecurity='"+Security+"',fdDraft='"+Draft+"',fdAuditor='"+Check+"',";
       strSql = strSql + " fdTitle='"+Title+"',fdCopyTo='"+CopyTo+"',docSubject='"+Subject+"',fdCopies='"+Copies+"' where fdRecordId = '"+RecordID+"'";
       ObjConnBean.ExecuteUpdate(strSql);
    }else{
      java.sql.PreparedStatement prestmt=null;
      try
      {
        String Sql="insert into KmSignatureDocumentMain (fdRecordId,fdDocNo,fdUserName,fdSecurity,fdDraft,fdAuditor,fdTitle,fdCopyTo,docSubject,fdCopies,fdDateTime,fd_id,fdDocumentId) values (?,?,?,?,?,?,?,?,?,?,?,?,?) ";
        prestmt =ObjConnBean.Conn.prepareStatement(Sql);
        prestmt.setString(1, RecordID);
        prestmt.setString(2, DocNo);
        prestmt.setString(3, UserName);
        prestmt.setString(4, Security);
        prestmt.setString(5, Draft);
        prestmt.setString(6, Check);
        prestmt.setString(7, Title);
        prestmt.setString(8, CopyTo);
        prestmt.setString(9, Subject);
        prestmt.setString(10, Copies);
        prestmt.setString(11, DateTime);
        prestmt.setString(12, IDGenerator.generateID());
        prestmt.setString(13, "1");
        prestmt.execute();
        prestmt.close();
        mResult=true;
      }
      catch(SQLException e)
      {
        System.out.println(e.toString());
        mResult=false;
      }
    }
  ObjConnBean.CloseConnection();
  response.sendRedirect("DocumentList.jsp");
  }

%>