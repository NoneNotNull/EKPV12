~~function() {
	function use(url, isCss) {
		if (Com_ArrayGetIndex(Com_Parameter.JsFileList, url) == -1) {
			Com_Parameter.JsFileList[Com_Parameter.JsFileList.length] = url;
			var node = document.createElement(isCss ? 'link' : 'script'), head = document
					.getElementsByTagName("head")[0];
			if (isCss) {
				node.rel = "stylesheet"
				node.href = url
			} else {
				node.src = url
			}
			head.appendChild(node);
		}
	}
	use(Com_Parameter.ContextPath + 'sys/attachment/js/swfupload.js');
	use(Com_Parameter.ContextPath
			+ 'resource/ckeditor/plugins/multiimage/dialogs/style/upload.css',
			true);
}();
CKEDITOR.plugins
		.add(
				'multiimage',
				{
					requires : 'dialog',
					lang : 'af,ar,bg,bn,bs,ca,cs,cy,da,de,el,en,en-au,en-ca,en-gb,eo,es,et,eu,fa,fi,fo,fr,fr-ca,gl,gu,he,hi,hr,hu,id,is,it,ja,ka,km,ko,ku,lt,lv,mk,mn,ms,nb,nl,no,pl,pt,pt-br,ro,ru,si,sk,sl,sq,sr,sr-latn,sv,th,tr,ug,uk,vi,zh,zh-cn', // %REMOVE_LINE_CORE%
					icons : 'multiimage',
					hidpi : true,
					init : function(editor) {
						editor
								.addCommand(
										'multiimage',
										new CKEDITOR.dialogCommand(
												'multiimage',
												{
													allowedContent : 'img[alt,height,!src,title,width]',
													requiredContent : 'img'
												}));
						editor.ui.addButton
								&& editor.ui.addButton('multiimage', {
									label : editor.lang.multiimage.icon,
									command : 'multiimage',
									toolbar : 'insert,50'
								});
						CKEDITOR.dialog.add('multiimage', this.path
								+ 'dialogs/multiimage.js');
					}
				});
