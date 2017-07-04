define(["dojo/_base/declare", "mui/tabbar/TabBarButton", "dojo/dom-construct", "mui/dialog/Dialog", "mui/device/adapter","dojo/_base/lang" ],
		function(declare, TabBarButton, domConstruct, Dialog, adapter,lang) {
	
			return declare("mui.back.BackButton", [ TabBarButton ], {
				icon1 : "mui mui-back",

				align : "left",
				
				//是否在编辑状态下
				edit : false,

				_onClick : function(evt) {
					this.defer( function() {
						if(this.edit){
							var contentNode = domConstruct.create('div', {
								className : 'muiBackDialogElement',
								innerHTML : '<div>退出编辑？<div>'
							});
							Dialog.element({
								'title' : '提示',
								'showClass' : 'muiBackDialogShow',
								'element' : contentNode,
								'scrollable' : false,
								'parseable': false,
								'buttons' : [ {
									title : '取消',
									fn : function(dialog) {
										dialog.hide();
									}
								} ,{
									title : '确定',
									fn : lang.hitch(this,function(dialog) {
										this.doBack();
										dialog.hide();
									})
								} ]
							});
						}else{
							this.doBack();
						}
					}, 450);// 延时处理原因：手机端延时300毫秒问题导致返回多次（iphone4发现问题）
			},
			doBack : function(refresh){
				var rtn = adapter.goBack();
				if(rtn == null){
					history.back();
				}
			}
			});
		});