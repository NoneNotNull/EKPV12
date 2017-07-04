(function() {
	CKEDITOR.plugins.add('keydata', {
		requires : 'clipboard',
		lang : 'af,ar,bg,bn,bs,ca,cs,cy,da,de,el,en,en-au,en-ca,en-gb,eo,es,et,eu,fa,fi,fo,fr,fr-ca,gl,gu,he,hi,hr,hu,id,is,it,ja,ka,km,ko,ku,lt,lv,mk,mn,ms,nb,nl,no,pl,pt,pt-br,ro,ru,si,sk,sl,sq,sr,sr-latn,sv,th,tr,ug,uk,vi,zh,zh-cn',
		hidpi : true,
		init : function(editor) {
			var config = editor.config, lang = editor.lang.keydata;
			var pluginName = "keydata";
			CKEDITOR.dialog.add(pluginName, this.path + 'dialogs/keydata.js');
			CKEDITOR.dialog.add(pluginName, this.path + 'css/keydata.css');
			editor.addCommand(pluginName, new CKEDITOR.dialogCommand(pluginName));
			//alert(this.path + 'images/wiki.gif');
	        editor.ui.addButton(pluginName,
	        {
	            label: '关键数据',
	            command: pluginName,
	            icon : this.path + 'images/keydata.png'
	        });

			
		}
	});
})();