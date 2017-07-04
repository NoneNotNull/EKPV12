define( [ "dojo/_base/declare", 
          "dojo/dom-construct", 
          "dojo/dom-style", 
          "mui/util",
          "sys/attachment/mobile/js/_AttachmentItem"], function(declare,
          domConstruct, domStyle, util , AttachmentItem) {
	//图片附件项展示类
	return declare("sys.attachment.mobile.js.AttachmentViewPicItem", [ AttachmentItem ], {
		width : null,

		height : null,
		
		baseClass : 'muiAttachmentPicItem',

		buildItem : function() {
			if (this.width != null) {
				domStyle.set(this.containerNode,{
					width: this.width + "px"
				});
			}
			if (this.height != null) {
				domStyle.set(this.containerNode,{
					height: this.height + "px"
				});
			}
			domConstruct.create("img", {
				className : "muiAttachmentPicImg",
				src : util.formatUrl(this.icon)
			}, this.containerNode);
		}
	});
});