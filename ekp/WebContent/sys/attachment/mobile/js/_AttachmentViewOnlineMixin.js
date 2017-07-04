define(
		[ "dojo/_base/declare", "mui/form/Select", "mui/util",
				"dojo/_base/lang", "dojox/mobile/sniff" ],
		function(declare, Select, util, lang, has) {
			return declare(
					'sys.attachment.mobile.js._AttachmentViewOnlineMixin',
					null,
					{
						// 在线预览路径
						viewHref : '/sys/attachment/sys_att_main/sysAttMain.do?method=view&fdId=!{fdId}&viewer=aspose_mobilehtmlviewer',

						canDownload : false,

						canRead : false,

						getPool : function() {
							var pool = [];
							if (this.canRead) {
								pool.push({
									value : 1,
									text : '打开文件',
									callback : function() {
										this.view();
									}
								});
							}
							if (this.canDownload) {
								pool.push({
									value : 2,
									text : '保存文件',
									callback : function() {
										this._downLoad();
									}
								});
							}
							return pool;
						},

						view : function() {
							if (this.getType() != 'img') {
								location.href = util.formatUrl(this.viewHref
										.replace('!{fdId}', this.fdId));
							} else
								location.href = util
										.formatUrl('/sys/attachment/mobile/viewer/img/imgViewer.jsp?fdId=')
										+ this.fdId
										+ '&fdName='
										+ encodeURI(this.name);

						},

						onDialogSelect : function(obj, evt) {
							if (obj != this.select)
								return;
							var pool = this.getPool();
							for (var i = 0; i < pool.length; i++) {
								if (evt.value == pool[i].value) {
									lang.hitch(this, pool[i].callback)();
									this.select.destroy();
									return;
								}
							}
						},

						onDialogCallback : function(obj, evt) {
							if (obj == this.select)
								this.select.destroy();
						},

						buildRendering : function() {
							this.inherited(arguments);
							if (this.canViewOnline()) {
								this.subscribe('/mui/form/valueChanged',
										'onDialogSelect');
								this.subscribe('mui/form/select/callback',
										'onDialogCallback');
							}
						},

						canViewOnline : function() {
							return this.hasViewer || this.getType() == 'img';
						},

						_onItemClick : function() {
							// 支持在线预览的文件类型
							if (this.canViewOnline()) {
								// ios类型直接打开
								if (has('ios')) {
									this.view();
									return true;
								}

								var pool = this.getPool();
								// 如果都没权限，走回原来下载路线
								if (pool.length == 0) {
									this._downLoad();
									return true;
								}

								// 如果只有一个选项有权限，不弹出选择框，直接执行有权限选项点击方法
								if (pool.length == 1) {
									lang.hitch(this, pool[0].callback)();
									return true;
								}

								// 如果都有权限，弹出操作选择框
								this.select = new Select({
									store : this.getPool(),
									mul : false,
									subject : this.name,
								});
								this.select.startup();
								this.select._onClick();
							} else
								this._downLoad();
							return true;
						}
					});
		});