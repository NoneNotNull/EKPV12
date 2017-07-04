define( [ "dojo/_base/declare", "dojo/dom-construct", "dojo/dom-class","dojo/dom-style",
		"dojo/_base/array", "dojo/_base/lang", "dojo/topic","dojo/window",
		"mui/picslide/PicSlide" ], function(declare, domConstruct, domClass,domStyle,
		array, lang, topic, win,PicSlide) {
	return declare("mui.picslide.ImagePreview", null, {

		picPlayEvtName : "/mui/image/play",

		picClick : "/mui/picitem/click",

		viewChangedEvt : "/mui/picslide/changeview",
		
		constructor : function() {
			this.inherited(arguments);
			topic.subscribe(this.picClick, lang.hitch(this, function(srcObj,argu) {
				this._imagePlayClose(argu);
			}));
		},

		// 当图片数组长度发生变化时重回
		reDraw : function(options) {
			if (options != null) {
				this.imgs = [].concat(options.srcList);
				if (this.imgSlide != null)
					this.imgSlide.destroy();
				this.buildPicSlide(options);
			}
		},
		
		// 构建
		buildPicSlide : function(options) {
			this.imgs = [].concat(options.srcList);
			var items = [];
			array.forEach(this.imgs, function(tmpImg) {
				items.push({
					icon : tmpImg
				});
			});
			var tmpStyle = {
				width : win.getBox().w + 'px',
				height : win.getBox().h + 'px'
			};
			this.imgSlide = new PicSlide(lang.mixin({
				items : items
			}, tmpStyle));
			if (!this.topDiv) {
				this.topDiv = domConstruct.create("div", {
					className : 'muiRtfPicSlider'
				}, document.body);
				domStyle.set(this.topDiv, tmpStyle);
			}
			this.topDiv.appendChild(this.imgSlide.domNode);
			if (this.imgSlide._started != true) {
				this.imgSlide.startup();
			}
		},
 
		// 播放
		play : function(options) {
			if (options == null)
				return;
			if (this.imgs
					&& this.imgs.toString() != options.srcList
							.toString()) {
				this.reDraw(options)
			} else {
				if (this.topDiv == null)
					this.buildPicSlide(options);
			}
			setTimeout(lang.hitch(this, function() {
				domClass.add(this.topDiv, "muiRtfPicShow");
				topic.publish(this.viewChangedEvt, this, {
					'curIndex' : array.indexOf(this.imgs, options.curSrc)
				});
			}), 350);
		},

		_imagePlayClose : function(evts) {
			domClass.remove(this.topDiv, "muiRtfPicShow");
		}
	});

});