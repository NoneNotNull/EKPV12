<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
Com_RegisterFile("${KMSS_Parameter_ContextPath}sys/evaluation/import/sysEvaluationMessageInfo.jsp");

if(typeof SysEval_MessageInfo == "undefined")
	SysEval_MessageInfo = new Array();
if(SysEval_MessageInfo.length==0) {
	SysEval_MessageInfo["return.optSuccess"]="${lfn:message("return.optSuccess")}";
	SysEval_MessageInfo["return.optFailure"]="${lfn:message("return.optFailure")}";
	SysEval_MessageInfo["button.ok"]="${lfn:message("button.ok")}";  
	SysEval_MessageInfo["button.cancel"]="${lfn:message("button.cancel")}";  
	SysEval_MessageInfo["sysEvaluationNotes.docSubject"]="${lfn:message("sys-evaluation:sysEvaluationNotes.docSubject")}";
	SysEval_MessageInfo["sysEvaluationNotes.fdEvaluationContent"]="${lfn:message("sys-evaluation:sysEvaluationNotes.fdEvaluationContent")}";
	SysEval_MessageInfo["sysEvaluationNotes.unNamedPage"]="${lfn:message("sys-evaluation:sysEvaluationNotes.unNamedPage")}";
	SysEval_MessageInfo["sysEvaluationNotes.fromPage"]="${lfn:message("sys-evaluation:sysEvaluationNotes.fromPage")}";
	SysEval_MessageInfo["sysEvaluationNotes.words"]="${lfn:message("sys-evaluation:sysEvaluationNotes.words")}";
	SysEval_MessageInfo["table.sysEvaluationNotes"]="${lfn:message("sys-evaluation:table.sysEvaluationNotes")}";
	SysEval_MessageInfo["sysEvaluationNotes.alert1"]="${lfn:message("sys-evaluation:sysEvaluationNotes.alert1")}";
	SysEval_MessageInfo["sysEvaluationNotes.alert2"]="${lfn:message("sys-evaluation:sysEvaluationNotes.alert2")}";
	SysEval_MessageInfo["sysEvaluationNotes.alert3"]="${lfn:message("sys-evaluation:sysEvaluationNotes.alert3")}";
}

