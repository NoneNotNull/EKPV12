<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

[ 
	{
		url : '/sys/task/sys_task_main/sysTaskIndex.do?method=list&orderby=docCreateTime&ordertype=down',
		text: '全部'
	},
	{
		url : '/sys/task/sys_task_main/sysTaskIndex.do?method=list&q.flag=1&orderby=docCreateTime&ordertype=down',
		text: '指派'
	},
	{
		url : '/sys/task/sys_task_main/sysTaskIndex.do?method=list&q.taskStatus=3&orderby=docCreateTime&ordertype=down',
		text: '完成'
	},
	{
		url : '/sys/task/sys_task_main/sysTaskIndex.do?method=list&q.flag=0&orderby=docCreateTime&ordertype=down',
		text: '关注'
	}
]