define( [ "dojo/_base/declare", "dojo/_base/lang", "dojo/dom-construct", "dojox/mobile/_ItemBase",
		"mui/device/device", "mui/device/adapter", "mui/util" ], function(declare, lang, domConstruct, _ItemBase, device, adapter, util) {

	return declare("sys.lbpmservice.mobile.audit_note_ext.log.AuditLogItem",
			[ _ItemBase ], {
				href : '',
				
				label : '',
				
				baseClass : 'muiAuditLogItem',
				
				icon : 'mui-voice',
				
				fdId : '',
		
				buildRendering:function(){
					this.inherited(arguments);
					this.content = domConstruct.create("div",{'className':'muiAuditLogItemInfo'},this.domNode);
					domConstruct.create("i",{'className':'muiAuditLogItemPlay mui ' + this.icon},this.content );
					domConstruct.create("span",{'className':'muiAuditLogItemName',innerHTML:this.label},this.content );
					domConstruct.create("i",{'className':'muiAuditLogItemMore mui mui-forward'},this.content );
				},
				
				postCreate : function() {
					this.inherited(arguments);
					this.connect(this.content , 'click' , function(evt){
						this.defer(function(){
							this.openFeature(evt);
						},350);
					});
				},

				isImage:function(){
					if(this.label){
						var fileExt = "";
						if(this.label.lastIndexOf(".")>-1){
							fileExt = this.label.substring(this.label.lastIndexOf(".")+1);
							if(fileExt!=""){
								fileExt=fileExt.toLowerCase();
							}
							if(fileExt=='jpg'||fileExt=='ico'||fileExt=='bmp'||fileExt=='gif'||fileExt=='png'||fileExt=='tif'){
								return true;
							}
						}
					}
					return false;
				},
				
				openFeature:function(evt){
					if (!this.isImage()) {
						location = util.formatUrl(this.href,true);
					} else{
						location.href = util.formatUrl('/sys/attachment/mobile/viewer/img/imgViewer.jsp?fdId=')
								+ this.fdId	+ '&fdName=' + encodeURI(this.label);
					}
				},
				
				_setLabelAttr : function(text) {
					if (text)
						this._set("label", text);
				}
			
		});
});