<%@ page language="java" pageEncoding="UTF-8" contentType="application/json; charset=UTF-8"%>
<%
	int rowsize = request.getParameter("rowsize")==null?16:Integer.valueOf(request.getParameter("rowsize"));
	int pageno = request.getParameter("pageno")==null?1:Integer.valueOf(request.getParameter("pageno"));
	int total = request.getParameter("q.docStatus")==null?1783:0;
%>
{
    "columns": [
        {
            "property": "fdId"
        },
        {
            "title": "文档标题",
            "property": "docSubject"
        },
        {
            "title": "摘要",
            "property": "fdDescription"
        },
        {
            "title": "文档作者",
            "property": "docAuthor.fdName"
        },
        {
            "title": "所属部门",
            "property": "docDept.fdName"
        },
        {
            "title": "发布日期",
            "property": "docPublishTime"
        },
        {
            "title": "所属分类",
            "property": "fdTemplateName"
        },
        {
            "title": "标签",
            "property": "sysTagMain"
        },
        {
            "title": "浏览",
            "property": "docReadCount"
        },
        {
            "title": "评分 ",
            "property": "docScore"
        },
        {
            "title": "imageLink",
            "property": "fdImageUrl"
        },
        {
            "title": "所属分类",
            "property": "docCategoryId"
        },
        {
            "title": "所属分类",
            "property": "docCategoryName"
        }
    ],
    "datas": [
<% if(total>0) 
		for(int i=0; i<rowsize/2; i++) {
			if(i>0) out.write(",");%>
        [
            {
                "col": "fdId",
                "value": "142a795692b2c77c401340a4a34976ad"
            },
            {
                "col": "docSubject",
                "value": "国际企业案例"
            },
            {
                "col": "fdDescription",
                "value": "1998年年初 “东伊运”派遣乌斯曼伊米提、买买提·热曼等12名暴力恐怖分子入境，在中国境内进行暴力恐怖活动。他们秘密建立训练点10多处，培训150多名恐怖分子。该团伙重要骨干买买提·热曼在中国新疆乌鲁木齐市购买制爆化学原料20余种301箱，重达6吨，价值10．2万元，预谋在新疆进行大规模爆炸、暗杀等活动。"
            },
            {
                "col": "docAuthor.fdName",
                "value": "<a class=\"com_author\" href=\"#\" target=\"_self\">管理员</a>"
            },
            {
                "col": "docDept.fdName",
                "value": "蓝凌软件"
            },
            {
                "col": "docPublishTime",
                "value": "2013-11-30"
            },
            {
                "col": "fdTemplateName",
                "value": "文档标准规范"
            },
            {
                "col": "sysTagMain",
                "value": "标准 规范"
            },
            {
                "col": "docReadCount",
                "value": "102"
            },
            {
                "col": "docScore",
                "value": "35"
            },
            {
                "col": "fdImageUrl",
                "value": ""
            },
            {
                "col": "docCategoryId",
                "value": "142a18284ec664e07ccbff244f590770"
            },
            {
                "col": "docCategoryName",
                "value": "文档标准规范"
            }
        ],
        [
            {
                "col": "fdId",
                "value": "1429c8ef89d798d8cd0be164b699f31c"
            },
            {
                "col": "docSubject",
                "value": "公司年度调薪制度"
            },
            {
                "col": "fdDescription",
                "value": ""
            },
            {
                "col": "docAuthor.fdName",
                "value": "<a class=\"com_author\" href=\"#\" target=\"_self\">管理员</a>"
            },
            {
                "col": "docDept.fdName",
                "value": "产品研发中心"
            },
            {
                "col": "docPublishTime",
                "value": "2013-11-28"
            },
            {
                "col": "fdTemplateName",
                "value": "标准规范库"
            },
            {
                "col": "sysTagMain",
                "value": "调薪制度"
            },
            {
                "col": "docReadCount",
                "value": "203"
            },
            {
                "col": "docScore",
                "value": "50"
            },
            {
                "col": "fdImageUrl",
                "value": ""
            },
            {
                "col": "docCategoryId",
                "value": "1423577f9570e9f926384ae4f0fad9a3"
            },
            {
                "col": "docCategoryName",
                "value": "标准规范库"
            }
        ]
<% } %>
    ],
    "page": {
        "currentPage": <%= pageno %>,
        "pageSize": <%= rowsize %>,
        "totalSize": <%= total %>
    }
}