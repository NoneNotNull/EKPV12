<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<link rel="stylesheet" href="${LUI_ContextPath }/kms/common/pda/core/search/style/search.css" />

<style>
.lui-search-bar .lui-search {
	position: absolute;
	left: 6px;
	<c:choose> 
	  <c:when test="${param.hasAdd != true }">   
		right: 49px;  
	  </c:when> 
	  <c:otherwise>   
	    right:83px; 
	  </c:otherwise> 
	</c:choose> 
	border-radius: 4px;
	height: 1.8em;
}
</style>
<ul class="lui-search-bar">
	<li class="lui-search" style="">
		<input placeholder="请输入搜索关键字" name="keyword_search" type="text">
		<input type="button" class="lui-icon-s lui-search-submit shake">
	</li>
	<li class="btn shake">
		<a data-lui-role="button" id="currentBtn">
			<script type="text/config">
						{
							currentClass : 'lui-icon-s lui-column-icon lui-column-icon-on',
							onclick : "showBtnBar()",
							selected : true
						}
			</script>		
		</a>
	</li>
	
	<c:if test="${param.hasAdd == true }">
		<li class="btn shake">
			<a data-lui-role="button" id="addBtn">
				<script type="text/config">
						{
							currentClass : 'lui-icon-s lui-add-icon lui-add-icon-on',
							onclick : 'addDoc()'
						}
		</script>		
			</a>
		</li>
	</c:if>
	
	<c:if test="${param.hasFilter != false }">
		<li class="btn">
			<a data-lui-role="button" id="filterBtn">
				<script type="text/config">
						{
							currentClass : 'lui-icon-s lui-filter-icon hide',
							toggleClass : 'lui-filter-icon-on shake',
							onclick : ''
						}
		</script>		
			</a>
		</li>
	</c:if>
</ul>
<script>
	<c:if test="${param.hasFilter != false }">
		// 监听分类点击事件，用于渲染筛选按钮及其事件
		var $input = $('.lui-search') , right = parseInt($input.css('right'));
		Pda.Topic
				.on(
						'listChange',
						function(evt) {
							var filter = Pda.Element('filterBtn');
							var claz = evt.target, fdName = evt.categoryName, fdId = evt.categoryId, hasFilter = evt.hasFilter ? evt.hasFilter
									: false;
							// 分类驱动或者例外驱动
							if (claz && claz.buildFilter || evt.filterReset ) {
								var arr = Pda.Role('filter');
								for (var i = 0; i < arr.length; i++)
									arr[i].destroy();
								if (hasFilter && claz && claz.buildFilter) {
									filter.addClass(filter.toggleClass);
									filter.bindClick(function() {
										claz.buildFilter(claz, claz.href, fdId,
												fdName);
									});
									$input.css('right',right+34);
								} else {
									filter.removeClass(filter.toggleClass);
									filter.bindClick(function() {});
									$input.css('right',right);
								}
							}
						});
	</c:if>

	function showBtnBar() {
		var $bar = $('#btnBar');
		if ($bar.css('display') == 'none')
			$bar.show();
		else
			$bar.hide();
	}

	function changeCurrentBtn(type) {
		Pda.Element('currentBtn').target.attr('class', '');
		Pda.Element('currentBtn').target.addClass('lui-icon-s lui-' + type
				+ '-icon lui-' + type + '-icon-on');
	}

	$('.lui-search-submit')
			.on(
					'click',
					function(evt) {
						var url = '${LUI_ContextPath}/kms/common/pda/core/search/tmpl/search.jsp?modelName=${param.modelName}';
						var val = $('[name="keyword_search"]').val();
						var hasKeyWord = false;
						if (val) {
							hasKeyWord = true;
							url += '&queryString=' + val;
						}
						url += ('&hasKeyWord=' + hasKeyWord);
						if (Pda.Element('search_panel')) {
							Pda.Element('search_panel').selected();
							return;
						}

						var panel = new Pda.Panel({
							url : url
						});
						// 搜索panel每次都必须进行销魂，不应该存在缓存
						panel.on('transitionend',function(){
							panel.destroy();
						}); 
						panel.initId('search_panel');
						panel.startup();
						panel.draw();
						panel.selected();
					});
</script>

