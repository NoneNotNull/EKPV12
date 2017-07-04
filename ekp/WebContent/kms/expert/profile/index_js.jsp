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

	// 向爱问达人提问
	function askToExpert(fdId) {
		window
				.open('<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do" />?method=add&fdPosterTypeListId=' + fdId);
	}
</script>

<!-- 模板 -->
<script type="text/template" id="portlet_doc_kmservice_tmpl">
var itemList = data[0].itemList;
{$
<div class="tagContent">
	<ul class="l_g2 c" >
$}
		for(i=0;i<itemList.length;i++){
{$
			<li style="width:260px;height:100px">
				<a href="{%itemList[i].fdUrl%}" class="img_e" title="" target="_blank"><img src="{%itemList[i].fdImgUrl%}" alt="" onload="javascript:	drawImage(this,this.parentNode)"/></a>				
				<ul class="l_h">
					<li><strong>专家：</strong><span class="b">{%itemList[i].fdName%}</span></li>
					<li title="{%itemList[i].fdDeptName%}"><strong>部门：</strong>{%resetStrLength(itemList[i].fdDeptName||'',12)%}</li>
					<li title="{%itemList[i].expertType%}"><strong>精通领域：</strong>{%resetStrLength(itemList[i].expertType||'',6)%}</li>
$}
					if(itemList[i].hasAsk){
						{$<li><div class="btn_d" style="float:left;" ><a href="javascript:void(0)" title="向他提问" onclick="askToExpert('{%itemList[i].fdId%}')"><span>向他提问</span></a></div></li>$}
					}
{$
				</ul>
			</li>
$}
		}
{$
	</ul>
</div>
<div class="clear"></div>
<div class="page c" id="page" style="margin-top:5px">
<p class="jump">每页<input type="text" value="{%data[0].pageWrapper.page.rowsize%}" id="${param.id}_rowsize" class="i_a m_l20"/>条<input type="text" value="{%data[0].pageWrapper.page.pageno%}" class="i_a m_l20" id="${param.id}_pageno">/共{%data[0].pageWrapper.page.totalPage%}页<span class="btn_b kmservice_btn_b"><a href="javascript:jump();" title="跳转到"><span>Go</span></a></span></p>
<div class="page_box c">
	<div class="btn_b kmservice_btn_b"><a title="首页" href="javascript:setPageTo(0,{%data[0].pageWrapper.page.rowsize%});"><span>首页</span></a></div>
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
	<div class="btn_b kmservice_btn_b"><a title="尾页" href="javascript:setPageTo({%data[0].pageWrapper.page.totalPage%},{%data[0].pageWrapper.page.rowsize%})"><span>尾页</span></a></div>
	<div class="btn_b kmservice_btn_b"><a title="刷新" href="javascript:setPageTo({%data[0].pageWrapper.page.pageno%},{%data[0].pageWrapper.page.rowsize%});"><span>刷新</span></a></div>
</div>
$}
</script>