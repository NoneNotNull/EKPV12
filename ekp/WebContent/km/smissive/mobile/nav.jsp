<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

[ 
	{ 
		url : "/km/smissive/km_smissive_main/kmSmissiveMainIndex.do?method=listChildren&categoryId=&orderby=docCreateTime&ordertype=down", 
		text : "${ lfn:message('km-smissive:smissive.tree.myJob.alldoc') }", 
		selected : true 
	},
	{ 
		url : "/km/smissive/km_smissive_main/kmSmissiveMainIndex.do?method=listChildren&categoryId=&q.docStatus=20&orderby=docCreateTime&ordertype=down", 
		text : "${ lfn:message('km-smissive:smissive.tree.doing') }"
	}
]
