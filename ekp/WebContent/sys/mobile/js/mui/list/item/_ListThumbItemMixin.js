define(
		[ "dojo/_base/declare", "mui/util", "dojo/dom-construct" ],
		function(declare, util, domConstruct) {

			return declare(
					"mui.list.item._ListThumbItemMixin",
					null,
					{

						thumbUrl : '/resource/fckeditor/editor/filemanager/download?fdId=${fdId}',

						// thumbs为数组或者字符串"fdId1,fdId2"
						buildThumb : function(thumbs, refNode) {
							var url = util.formatUrl(this.thumbUrl);
							if (thumbs) {
								var thumbArray;
								if (typeof (thumbs) == 'object')
									thumbArray = thumbs;
								else
									thumbArray = thumbs.split(',');
								var thumbContent = domConstruct.create('div', {
									className : 'muiListThumb'
								}, refNode);

								for (var index = 0; index < thumbArray.length; index++) {
									if (index == 3)
										return false;
									var _url = url.replace('${fdId}',
											thumbArray[index]);
									domConstruct.create('p', {
										style : 'background-image: url(' + _url
												+ ')'
									}, thumbContent);
								}
							}
						}
					});
		});