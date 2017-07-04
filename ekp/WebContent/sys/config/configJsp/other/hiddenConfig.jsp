<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
Com_IncludeFile("doclist.js|dialog.js");
</script>
<!-- 全文检索 -->
<html:hidden property="value(index.all.node.name)"/>
<html:hidden property="value(index.this.node.name)"/>
<!-- #cko/flowstat取日志的时间间隔类型（单位可为day,hour,minute）和间隔数字 -->
<html:hidden property="value(km.cko.domino.data.type)"/>
<html:hidden property="value(km.cko.domino.data.times)"/>
<html:hidden property="value(kmss.flowstatcko.data.count)"/>
<!-- 工作流设置 -->
<html:hidden property="value(kmss.workflow.descriptor.type.value)"/>
<html:hidden property="value(kmss.workflow.descriptor.type.oa.fileName)"/>
<!-- 组织架构信息来源 -->
<html:hidden property="value(kmss.flowstat.omsProvider)"/>