<%@page import="com.landray.kmss.sys.ui.xml.model.*"%>
<%@page import="java.util.*"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include file="/sys/ui/help/assembly-help.jsp">
	<template:replace name="detail">
		<label>功能测试：</label>

		<input type="button" onclick="test3();" value="弹出警告窗口">

		<input type="button" onclick="test4()" value="弹出疑问窗口">

		<input type="button" onclick="test5();" value="弹出失败框">
		
		<input type="button" onclick="test6();" value="弹出成功框">
		
		<input type="button" onclick="test7();" value="弹出分类选择框">
		
		<input type="button" onclick="popLoading();" value="弹出loading图">
		
		<br/>
		<br/>
		<label>代码测试：</label>
		<input type="button" onclick="test10();" value="html">
		<input type="button" onclick="test11();" value="element">
		<input type="button" onclick="test12();" value="iframe">
		
	</template:replace>
</template:include>
<script>

	function popLoading() {
		seajs.use( [ 'sys/ui/js/dialog' ], function(dialog) {
			var d = dialog.loading('.lui_accordionpanel_float_contents');
			setTimeout( function() {
				d.hide();
			}, 2000);
		});
	}

	function test3() {
		seajs.use( [ 'sys/ui/js/dialog' ], function(dialog) {
			dialog.alert('我是警告框的内容', function() {

			});
		});
	}

	function test4(content) {
		seajs.use( [ 'sys/ui/js/dialog' ], function(dialog) {
			dialog.confirm('我是确定框的内容', function(flag, d) {
				if (flag) {
					dialog.alert('你点击了确定', function() {
						dialog.alert('你还触发了alert的回调事件');
					});
				} else {
					dialog.alert('你点击了取消');
				}
			});
		});
	}

	function test5() {
		seajs.use( [ 'sys/ui/js/dialog' ], function(dialog) {
			dialog.failure('你操作失败了~~', '.lui_accordionpanel_float_contents',
					function(value, dialog) {

					});
		});
	}

	function test6() {
		seajs.use( [ 'sys/ui/js/dialog' ], function(dialog) {
			dialog.success('操作成功！', '.lui_accordionpanel_float_contents');
		});
	}

	function test7() {
		seajs
				.use(
						[ 'sys/ui/js/dialog' ],
						function(dialog) {
							dialog
									.simpleCategoryForNewFile(
											'com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate',
											'/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=add&fdTemplateId=!{id}');
						});

	}

	function test10() {
		seajs
				.use(
						[ 'sys/ui/js/dialog' ],
						function(dialog) {
							dialog
									.build(
											{
												config : {
													width : 300,
													height : 300,
													lock : true,
													cache : false,
													title : "html测试",
													content : {
														type : "Html",
														html : '<div><h1 style="text-align:center" >嵌入百度logo</h1><br><div><img width="100%" height="100%" src="http://www.baidu.com/img/bdlogo.gif"></img></div></div>',
														// url|element|html:"",
														iconType : "",
														buttons : [ {
															name : "OK",
															value : true,
															focus : true,
															fn : function(
																	value,
																	dialog) {
																dialog.hide();
															}
														} ]
													}
												},

												callback : function(value,
														dialog) {

												},
												actor : {
													type : "default",
													animate : false
												},
												trigger : {
													type : "AutoClose",
													timeout : 5
												}

											}).show();
						});
	}

	function test11() {
		seajs.use( [ 'sys/ui/js/dialog' ], function(dialog) {
			dialog.build( {
				id : 'tesst',
				config : {
					width : 300,
					height : 300,
					lock : true,
					cache : true,
					title : "elem测试",
					content : {
						type : "element",
						elem : '#kkk',
						// url|element|html:"",
						iconType : "",
						buttons : [ {
							name : "OK",
							value : true,
							focus : true,
							fn : function(value, dialog) {
								dialog.hide();
							}
						}, {
							name : "cancel",
							value : false,
							fn : function(value, dialog) {
								dialog.hide();
							}
						} ]
					}
				},

				callback : function(value, dialog) {

				},
				actor : {
					type : "default"
				},
				trigger : {
					type : "default"
				//timeout : 5
				}

			}).show();
		});
	}

	function test12() {
		seajs
				.use(
						[ 'sys/ui/js/dialog' ],
						function(dialog) {
							dialog
									.build(
											{
												config : {
													width : 700,
													height : 300,
													lock : true,
													cache : false,
													title : "iframe测试",
													content : {
														id : 'dialog_iframe',
														scroll : true,
														type : "iframe",
														url : 'http://localhost:8080/kms/sys/ui/demo/hongzq_demo.jsp',
														// url|element|html:"",
														iconType : "",
														buttons : [
																{
																	name : "OK",
																	value : true,
																	focus : true,
																	fn : function(
																			value,
																			dialog) {
																		dialog
																				.hide();
																	}
																},
																{
																	name : "cancel",
																	value : false,
																	fn : function(
																			value,
																			dialog) {
																		dialog
																				.hide();
																	}
																} ]
													}
												},

												callback : function(value,
														dialog) {

												},
												actor : {
													type : "default"
												},
												trigger : {
													type : "default"
												//timeout : 5
												}

											}).show();
						});

	}
</script>

<div id="kkk" style="display: none;"><h1 style="text-align:center" >嵌入百度logo</h1><br><div><img width="100%" height="100%" src="http://www.baidu.com/img/bdlogo.gif"></img></div></div>