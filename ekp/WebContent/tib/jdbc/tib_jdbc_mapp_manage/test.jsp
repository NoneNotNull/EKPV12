<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ page import="java.util.*"%>

<%
	int[] ages = { 1, 2, 3, 4, 5 }; // 普通数组，JSTL直接使用JSP赋值表达式来取

	List<String> names = new LinkedList<String>(); // List

	names.add("Biao");

	names.add("彪");

	names.add("雷");

	request.setAttribute("names", names); // 添加到request

	Set<String> set = new TreeSet<String>(); // Set

	set.add("One");

	set.add("One");

	set.add("Two");

	set.add("Three");

	set.add("Set");

	Map<String, String> map = new HashMap<String, String>(); // Map

	map.put("1", "黄彪");

	map.put("2", "丫头");

	map.put("3", "哥哥");

	map.put("4", "笨蛋");
	
	Map testMap = new HashMap();
	testMap.put("names",names);
	List sexList =new ArrayList();
	sexList.add("男");
	sexList.add("女");
	testMap.put("sex",sexList);
%>

<html>

<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Iterator Collections</title>

<style type="text/css">
table {
	border-collapse: collapse;
	border: 1px solid black;
}

td,th {
	border: 1px solid black;
}

tr:nth-child(even) {
	background: #eee;
}
</style>

</head>



<body>

<center>遍历数组: <c:forEach var="age" items="<%= ages %>">

	<c:out value="${age}" />

</c:forEach> <br />

<table>
遍历List: <c:forEach var="name" items="<%= names %>">
   <tr><td>
	<c:out value="${name}" />
   </td>
   </tr>
</c:forEach> <br />
</table>

遍历List: <c:forEach var="name" items="${names}">

	<c:out value="${name}" />

</c:forEach> <br />



<br />

遍历Set: <c:forEach var="entry" items="<%= set %>">

	<c:out value="${entry}" />

</c:forEach> <br />

遍历Map:

<table>
	<tr>
		<th>Key</th>
		<th>Value</th>
	</tr>

	<c:forEach var="entry" items="<%= map %>">
		<tr>
			<td><c:out value="${entry.key}" /></td>
			<td><c:out value="${entry.value}" /></td>
		</tr>
	</c:forEach>
</table>

<br />

<table>
  <tr>
    <th>sexKey</th>  
  </tr>
   <c:forEach var="testKey" items="${ testMap}">
      <c:if test="${testKey.key eq 'sex'}">
         <c:forEach var="sexVal" items="${testKey }">
             <c:out value="${sexVal.value }"/>
         </c:forEach>
      </c:if>
    
   </c:forEach>
</table>



</center>

</body>

</html>