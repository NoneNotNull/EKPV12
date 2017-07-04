define([ "dojo/_base/declare", "dojo/html", "dojo/dom-construct","dojo/dom-style", "dojo/query", "dojo/_base/array",
				"dojo/text!mui/rtf/TableResize.html", "dojo/_base/lang"], function(declare, html, domConstruct,
				domStyle, query, array, tmpl, lang) {

			return declare("mui.rtf._TableResizeMixin", null, {

				formatContent : function(domNode) {
					this.inherited(arguments);
					var tables = [];
					if (typeof (domNode) == "object") {
						tables = query('table', domNode);
					} else {
						tables = query(domNode + ' table');
					}
					array.forEach(tables, lang.hitch(this,
							function(item, index) {
								this.resizeTable(item);
							}));
					array.forEach(tables, function(item, index) {
						item.parentNode.removeChild(item);
					});
				},

				resizeTable : function(item) {
					this.container_temp = domConstruct.create('div', null, item, 'before');
					domStyle.set(this.container_temp, {
						height : item.offsetHeight + 'px' 
					});
					var dhs = new html._ContentSetter( {
						parseContent : true,
						cleanContent : true,
						node : this.container_temp,
						onBegin : function() {
							this.content = this.content.replace(/!{table}/g,
									item.outerHTML);
							this.inherited("onBegin", arguments);
						}
					});
					dhs.set(tmpl);
					dhs.parseDeferred.then(lang.hitch(this,function(parseResults){
						if(parseResults && parseResults.length){
							array.forEach(parseResults, function(w){
								if(w.resize){
									w.resize();
								}
							});
						}
					}));
					dhs.tearDown();
				}
			});

		});