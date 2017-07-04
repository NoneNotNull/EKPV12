<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="kmReview.tree.title" bundle="km-review"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	//=========按类别=======
	n1.authType='02';//02表示只能选中有使用权限的
    n1.AppendCategoryData(
    	"com.landray.kmss.km.review.model.KmReviewTemplate",
    	"<c:url value="/km/review/km_review_main/kmReviewMain.do?method=add&fdTemplateId=!{value}" />",
    	1
    );
     
    n1.isExpanded = true;
  
	LKSTree.Show();
}
</script>
</head>
<body>
<div id=treeDiv class="treediv" style='top:0px'></div>
<script>generateTree();</script>
</body>
</html>