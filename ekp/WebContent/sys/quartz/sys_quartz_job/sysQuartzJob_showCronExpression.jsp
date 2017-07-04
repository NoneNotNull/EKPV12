<%@ page import="com.landray.kmss.util.ResourceUtil"%>
<%
String[] fieldNames = ResourceUtil.getString("sysQuartzJob.cronExpression.fields", "sys-quartz", request.getLocale()).split(",");
String[] weekdayNames = ResourceUtil.getString("sysQuartzJob.cronExpression.weekdayNames", "sys-quartz", request.getLocale()).split(",");
String rtnVal = "";
String[] fields = request.getParameter("value").split("\\s+");
if (fields.length == 7 && !fields[6].equals("*"))
	rtnVal = fields[6] + "("+fieldNames[6]+")";
if (!fields[4].equals("*"))
	rtnVal += fields[4] + "("+fieldNames[4]+")";
if (fields[5].equals("?")) {
	if (!fields[3].equals("*"))
		rtnVal += fields[3] + "("+fieldNames[3]+")";
} else {
	if (!fields[5].equals("*")) {
		for (int i = 0; i < fields[5].length(); i++) {
			char c = fields[5].charAt(i);
			if (c >= '1' && c <= '7')
				rtnVal += weekdayNames[c - '1'];
			else
				rtnVal += c;
		}
	}
}
for (int i = 2; i >= 0; i--)
	if (!rtnVal.equals("") || !fields[i].equals("*"))
		rtnVal += fields[i] + "("+fieldNames[i]+")";
out.write(rtnVal);
%>
