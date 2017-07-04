define( [ "dojo/_base/declare","dojo/dom-style", "dojo/dom-construct", "dojo/dom-class", "dojo/topic",
          "mui/search/SearchBar", "mui/util", "dojo/touch", "dojox/mobile/_css3"  ],
        function(declare, domStyle, domConstruct, domClass, topic, SearchBar, util, touch, css3) {
	return declare("mui.search.SearchBarDialogMixin", null , {
			//模块标识
			modelName : "",
			
			searchCancelEvt : "/mui/search/cancel",

			searchShowEvt : "/mui/searchbar/show",
			
			show:function(evt){
				var created = false; 
				if (!this.searchNodeDiv) {
					var vars = {
						modelName : this.modelName
					};
					this.searchNodeDiv = domConstruct.create("div", {
						className : 'muiSearchBarDiv'
					}, document.body);
					var tmpH = domStyle.get(this.domNode,"height");
					if(!isNaN(this.referOffesetTop)){
						tmpH = this.referOffesetTop;
					}
					domStyle.set(this.searchNodeDiv,
							css3.name('transform'),
					'translate3d(100%, 0, 0)');
					domStyle.set(this.searchNodeDiv,{
						"height": tmpH + 'px'
					});
					this._searchBar = new SearchBar(vars);
					this.searchNodeDiv.appendChild(this._searchBar.domNode);
					created = true;
				}
				domStyle.set(this.searchNodeDiv, "display", "block");
				this.defer(function(){
					domStyle.set(this.searchNodeDiv, css3.name('transform'),'translate3d(0, 0, 0)');
					util.disableTouch(this.searchNodeDiv, touch.move);
					if(created){
						this._searchBar.startup();
					}
					topic.publish(this.searchShowEvt , this);
				},10);
				if(!this.bindedEvent){
					this.subscribe(this.searchCancelEvt, "hideSearchBar");
					this.subscribe("/mui/search/submit", "hideSearchBar");
					this.bindedEvent = true;
				}
			},
			
			hideSearchBar : function(srcObj) {
				domStyle.set(this.searchNodeDiv,css3.name('transform'),'translate3d(100%, 0, 0)');
				this.defer(function() {
						domStyle.set(this.searchNodeDiv, {
							display : 'none'
						});
					}, 410);
			}
	});
});