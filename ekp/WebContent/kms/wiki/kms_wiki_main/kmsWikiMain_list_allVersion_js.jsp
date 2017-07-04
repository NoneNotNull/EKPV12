<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="${kmsResourcePath }/js/kms_list.js"></script>
<script src="${kmsResourcePath }/js/kms_opera.js"></script>
<script type="text/javascript">



//事件绑定
function bindButton() {
	var options = {
		s_modelName:"com.landray.kmss.kms.wiki.model.KmsWikiCategory",
		s_bean : 'kmsHomeWikiService',
		s_method : 'getCategoryList',
		open : '<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do" />?method=add&fdCategoryId=',
		width : '320px',
		delUrl : '<c:url value ="/kms/wiki/kms_wiki_main/kmsWikiMain.do" />?method=deleteall'
	};

	var addEvent = new KMS.opera(options, $('#addButton'));
	addEvent.bind_add();
	
	var createDoc = new KMS.opera(options, $('.btn_wiki'));
	createDoc.bind_add();

	// 删除
	var delEvent = new KMS.opera(options, $('#delButton'));
	delEvent.bind_del();
}

function compareVersion() {
	var checkedList = $('input[name="List_Selected"]:checked');
	var rowsize = checkedList.length;
	if (!rowsize) {
		art.artDialog.alert('请选择版本！');
		return;
	}else if(rowsize != 2){
		art.artDialog.alert('只能选择两个版本进行比较！');
		return;
	}
	var firstId = checkedList[1].value;
	var secondId = checkedList[0].value;
	
	var url="kmsWikiMain.do?method=compareVersion&firstId="+firstId+"&secondId="+secondId;
	window.open(url,"_blank");
	checkList = [];
}

// 多选标志
var selectMore=false ;

//原因太长的，简短表示
function getShort(longname) {
  var n='';
  if(longname.length>100){
     n= longname.substring(0,100) +'...';
  }else{
     n=longname ;
    }
  return n ;
}

function openDocWindow(fdId){
	var url="kmsWikiMain.do?method=view&fdId="+fdId;
	Com_OpenWindow(url,"_blank");
}
</script>

<script type="text/template" id="wiki_allversion_list_tmpl">
var itemList = data.itemList;
{$
<div class="km_list2">
<table width="100%" cellspacing="0" cellpadding="0" border="0" class="t_g m_t10" id="{%parameters.kms.id%}-tbObj">
	<thead class="t_g_a">
		<tr class="tal">
			<th width="5%"><input type="checkbox" id="{%parameters.kms.id%}-listcheck"></th>
			<th class="t_g_b" width="5%">版本号</th>
			<th class="t_g_b" width="10%">完善时间</th>
			<th class="t_g_b" width="10%">完善人</th>
			<th class="t_g_b" width="20%">修改描述</th>
		</tr>
	</thead>
	<tbody>
$}
	for(j=0;j<itemList.length;j++){
{$
		<tr 
$}
			if(j%2!=0){{$ class="t_g_c" $}}{$>
			<td><input type="checkbox" name="List_Selected" value="{%itemList[j].fdId%}"></td>
			<td class="t_g_tal">
$}
            if(j==(itemList.length-1)){
{$
				<span class="ico_Original"></span>
$}
            }
{$
				V{%itemList[j].fdVersion%}<a class="version" title="{%itemList[j].fdVersion%}" href="{%itemList[j].fdUrl%}" target="_blank"><span>查看</span></a>
			</td>
			<td>{%itemList[j].docCreateTime%}</td>
			<td>{%itemList[j].docCreatorName%}</td>
			<td>{%itemList[j].fdReason%}</td>
		</tr>
$}
	}
{$
</div>
</tbody>
</table>
<div class="page c" id="{%parameters.kms.id%}-page">
<p class="jump">每页<input type="text" value="{%data.page.rowsize%}" class="i_a" id="_page_rowsize">条<input type="text" value="{%data.page.pageno%}" class="i_a m_l20" id="_page_pageno">/共{%data.page.totalPage%}页<span class="btn_b"><a href="javascript:KMS.page.jump();" title="跳转到"><span>Go</span></a></span></p>
<div class="page_box c">
	<div class="btn_b"><a title="首页" href="javascript:KMS.page.setPageTo(0, {%data.page.rowsize%});"><span>首页</span></a></div>
	<p class="page_list">
$}
		for(k=0;k<data.page.pagingList.length;k++){ 
			var pgn = data.page.pagingList[k];
{$			
			
			<a title="第{%pgn%}页" href="javascript:KMS.page.setPageTo({%pgn%}, {%data.page.rowsize%});" {%data.page.pageno == pgn ? 'class="on"' : ''%}>{%pgn%}</a>
$}
		}
		if(data.page.hasNextPageList){
{$
			……
$}
		}
{$
	</p>
	<div class="btn_b"><a title="尾页" href="javascript:KMS.page.setPageTo({%data.page.totalPage%}, {%data.page.rowsize%});"><span>尾页</span></a></div>
	<div class="btn_b"><a title="刷新" href="javascript:KMS.page.setPageTo({%data.page.pageno%}, {%data.page.rowsize%});"><span>刷新</span></a></div>
</div>
</div>
$}

</script>