<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

[ 
	{ 
		url : "/km/review/km_review_index/kmReviewIndex.do?method=list&q.mydoc=approval&orderby=docCreateTime&ordertype=down", 
		text : "${ lfn:message('km-review:kmReviewMain.mobile.approval.mine') }", 
		selected : true 
	},
	{ 
		url : "/km/review/km_review_index/kmReviewIndex.do?method=list&q.mydoc=approved&orderby=docCreateTime&ordertype=down", 
		text : "${ lfn:message('km-review:kmReviewMain.mobile.approved.mine') }"
	},
	{ 
		url : "/km/review/km_review_index/kmReviewIndex.do?method=list&orderby=docCreateTime&ordertype=down", 
		text : "${ lfn:message('km-review:kmReviewMain.mobile.all.mine') }"
	},
	{
		url : "/km/review/km_review_index/kmReviewIndex.do?method=list&q.mydoc=create&orderby=docCreateTime&ordertype=down",
		text: "${ lfn:message('km-review:kmReviewMain.mobile.create.mine') }"
	}
]
