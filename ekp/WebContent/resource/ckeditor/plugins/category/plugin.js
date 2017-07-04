CKEDITOR.plugins.add('category', {
	requires : 'richcombo',
	lang : 'af,ar,bg,bn,bs,ca,cs,cy,da,de,el,en,en-au,en-ca,en-gb,eo,es,et,eu,fa,fi,fo,fr,fr-ca,gl,gu,he,hi,hr,hu,id,is,it,ja,ka,km,ko,ku,lt,lv,mk,mn,ms,nb,nl,no,pl,pt,pt-br,ro,ru,si,sk,sl,sq,sr,sr-latn,sv,th,tr,ug,uk,vi,zh,zh-cn', // %REMOVE_LINE_CORE%
	init : function(editor) {
		if (editor.blockless)
			return;

		var config = editor.config, lang = editor.lang.category;

		var tags = config.category_tags.split(';');

		var styles = {}, stylesCount = 0, allowedContent = [];
		for (var i = 0; i < tags.length; i++) {
			var tag = tags[i];
			var style = new CKEDITOR.style(config['category_' + tag]);
			if (!editor.filter.customConfig || editor.filter.check(style)) {
				stylesCount++;
				styles[tag] = style;
				styles[tag]._.enterMode = editor.config.enterMode;
				allowedContent.push(style);
			}
		}

		if (stylesCount === 0)
			return;

		editor.ui.addRichCombo('Category', {
			label : lang.label,
			title : lang.panelTitle,
			toolbar : 'styles,20',
			allowedContent : allowedContent,

			panel : {
				css : [CKEDITOR.skin.getPath('editor')]
						.concat(config.contentsCss),
				multiSelect : false,
				attributes : {
					'aria-label' : lang.panelTitle
				}
			},

			init : function() {
				this.startGroup(lang.panelTitle);

				for (var tag in styles) {
					var label = lang['tag_' + tag];

					this.add(tag, styles[tag].buildPreview(label), label);
				}
			},

			onClick : function(value) {
				editor.focus();
				editor.fire('saveSnapshot');

				var style = styles[value], elementPath = editor.elementPath();

				editor[style.checkActive(elementPath)
						? 'removeStyle'
						: 'applyStyle'](style);

				setTimeout(function() {
							editor.fire('saveSnapshot');
						}, 0);

				// 触发更新目录事件
				editor.fire('refreshCategory');
			},

			onRender : function() {
				editor.on('selectionChange', function(ev) {

					var currentTag = this.getValue(), elementPath = ev.data.path, isEnabled = !editor.readOnly
							&& elementPath.isContextFor('p');

					this[isEnabled ? 'enable' : 'disable']();

					if (isEnabled) {

						for (var tag in styles) {
							if (styles[tag].checkActive(elementPath)) {
								if (tag != currentTag)
									this.setValue(tag,
											editor.lang.category['tag_' + tag]);
								return;
							}
						}

						this.setValue('');
					}
				}, this);
			}
		});
	}
});

CKEDITOR.config.category_tags = 'h3;h4;p';

CKEDITOR.config.category_p = {
	element : 'p'
};

CKEDITOR.config.category_div = {
	element : 'div'
};

CKEDITOR.config.category_pre = {
	element : 'pre'
};

CKEDITOR.config.category_address = {
	element : 'address'
};

CKEDITOR.config.category_h1 = {
	element : 'h1'
};

CKEDITOR.config.category_h2 = {
	element : 'h2'
};

CKEDITOR.config.category_h3 = {
	element : 'h3'
};

CKEDITOR.config.category_h4 = {
	element : 'h4'
};

CKEDITOR.config.category_h5 = {
	element : 'h5'
};

CKEDITOR.config.category_h6 = {
	element : 'h6'
};
