<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<footer>
	<script>
	/*
		function addDoc() {
			var wiki = 'wiki', multidoc = 'multidoc';

			var element = new Pda.Component(
					{
						source : {
							data : [ {
								value : multidoc,
								name : '文档知识库'
							}, {
								value : wiki,
								name : '维基知识库-未开放'
							} ],
							type : 'static'
						},
						render : {
							url : Pda.Util
									.formatUrl('/kms/common/pda/core/category/tmpl/item.jsp')
						}
					});
			element.startup();
			element.draw();

			var dialog = Pda.delement({
				title : '新建类型',
				element : element.target,
				canClose : true
			});
			dialog.show();

			element.target
					.on(
							'click',
							function(evt) {
								var $target = $(evt.target);
								if ($target.hasClass('lui-filter-item-subject')) {
									var val = $target.attr('data-lui-id');
									var url = '';
									if (wiki == val) {
										url = '/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=add';
									} else if (multidoc == val) {
										url = '/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=add';
									}
									window.open(Pda.Util.formatUrl(url),
											'_self');
									dialog.hide();
								}
							});
		}*/
	
		function addDoc(){
			var url = '/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=add';
			window.open(Pda.Util.formatUrl(url),'_self');
		}
	</script>
</footer>