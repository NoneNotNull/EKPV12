<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script>

	function jump(){
		$.ajax({
			url : '<c:url value="/kms/kmservice/kms_kmservice_main/kmsKmserviceMain.do" />',
			data : {
				method : 'moduleIndex',
				fdId : '${param.id}',
				keyword : '${param.keyword}',
				pageNo : $('#${param.id}_pageno').val(),
				rowSize : $('#${param.id}_rowsize').val()
			},
			cache : false,
			error : function(){
			},
			success : function(data) {
				$('#list').html(KmsTmpl($('#portlet_doc_kmservice_tmpl').html()).render( {
					"data" : data
				}));
			}
		});
		
	}

	function setPageTo(pgn,rowsize){
		$.ajax({
			url : '<c:url value="/kms/kmservice/kms_kmservice_main/kmsKmserviceMain.do" />',
			data : {
				method : 'moduleIndex',
				fdId : '${param.id}',
				keyword : '${param.keyword}',
				pageNo : pgn,
				rowSize : rowsize
			},
			cache : false,
			error : function(){
			},
			success : function(data) {
				$('#list').html(KmsTmpl($('#portlet_doc_kmservice_tmpl').html()).render( {
					"data" : data
				}));
			}
		});
	}
</script>

<!-- 模板 -->
<script type="text/template" id="portlet_doc_kmservice_tmpl">
var itemList = data[0].itemList;
{$
<div class="km_list2">
<table width="100%" cellspacing="0" cellpadding="0" border="0" class="t_b" id="-tbObj">
	<thead>
		<tr>
			<th width="5%">NO.</th>
			<th width="35%">文档标题</th>
			<th width="25%">所属分类</th>
			<th width="10%">创建者</th>
			<th width="20%">创建时间</th>
		</tr>
	</thead>
	<tbody>
$}
for(var i = 0;i<itemList.length;i++){
{$
	<tr 
$}
		if(i%2!=0){{$ class="t_b_a" $}}{$>
		<td>{%i+1%}</td>
		<td><a title="{%itemList[i].docSubject%}" href="{%itemList[i].fdUrl%}" target="_blank">{%resetStrLength(itemList[i].docSubject,30)%}</a></td>
		<td>{%itemList[i].kmsMultidocTemplate%}</td>
		<td>{%itemList[i].docCreator%}</td>
		<td>{%itemList[i].docCreateTime%}</td>
	</tr>	
$}
}
{$
</div>
</tbody>
</table>
<div class="page c" id="${param.id}-page">
<p class="jump">每页<input type="text" value="{%data[0].pageWrapper.page.rowsize%}" id="${param.id}_rowsize" class="i_a m_l20"/>条<input type="text" value="{%data[0].pageWrapper.page.pageno%}" class="i_a m_l20" id="${param.id}_pageno">/共{%data[0].pageWrapper.page.totalPage%}页<span class="btn_b"><a href="javascript:jump();" title="跳转到"><span>Go</span></a></span></p>
<div class="page_box c">
	<div class="btn_b"><a title="首页" href="javascript:setPageTo(0,{%data[0].pageWrapper.page.rowsize%});"><span>首页</span></a></div>
	<p class="page_list">
$}
		for(k=0;k<data[0].pageWrapper.page.pagingList.length;k++){ 
			var pgn = data[0].pageWrapper.page.pagingList[k];
{$			
			
			<a title="第{%pgn%}页" href="javascript:setPageTo({%pgn%},{%data[0].pageWrapper.page.rowsize%});" {%data[0].pageWrapper.page.pageno == pgn ? 'class="on"' : ''%}>{%pgn%}</a>
$}
		}
		if(data[0].pageWrapper.page.hasNextPageList){
{$
			……
$}
		}
{$
	</p>
	<div class="btn_b"><a title="尾页" href="javascript:setPageTo({%data[0].pageWrapper.page.totalPage%},{%data[0].pageWrapper.page.rowsize%})"><span>尾页</span></a></div>
	<div class="btn_b"><a title="刷新" href="javascript:setPageTo({%data[0].pageWrapper.page.pageno%},{%data[0].pageWrapper.page.rowsize%});"><span>刷新</span></a></div>
</div>
</div>
$}
</script>