<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<ui:ajaxtext>
	<script>
		seajs.use("kms/kmaps/kms_kmaps_portlet_ui/style/slidetuwen.css");
	</script>
	<ui:dataview>
		<ui:source type="AjaxJson">
			{"url":"/kms/kmaps/kms_kmaps_portlet/kmsKmapsPortlet.do?method=getKmapKnowledge&rowsize=${param.rowsize}&type=${param.type}&categoryId=${param.cateid}&dataType=pic"}
		</ui:source>
		<ui:render type="Template">
			{$<div class="clearfloat lui_slide_tuwen_obj">$}
				{$
					<div class="lui_slide_tuwen_pic">
				$}
				if(data && data.length > 0){
					for(var i = 0; i < data.length ; i++) {
				{$		<div class="lui_slide_tuwen_img"   $} if(i == 0 ) {$ style="display:block;opacity:1;" $} 
				            else {$ style="display:none;opacity:0;" $}{$ >
							<a href="${LUI_ContextPath}{% data[i].href %}" target="_blank">
								<img src="${LUI_ContextPath}{% data[i].image %}" alt="" style="width:100%;height:100%"/>
							</a>
						</div>
				$}
					}
				}
				{$
					</div>
					<div class="lui_slide_tuwen_text">
						<div class="lui_slide_tuwen_text_ud lui_slide_tuwen_text_up"></div>
						<div class="lui_slide_tuwen_text_ud lui_slide_tuwen_text_down"></div>
						<div class="lui_slide_tuwen_text_box">
				$}
				if(data && data.length > 0) {
					for(var i = 0; i < data.length ; i++) {
				{$
						<div class="lui_slide_tuwen_title" onclick="Com_OpenWindow('${LUI_ContextPath}{% data[i].href %}', '_blank')">
							<div class="textEllipsis" title="{%data[i].text%}">
								<span class="lui_slide_tuwen_subject">{%data[i].text%}</span>
							</div>
							<div class="textEllipsis" title="{%data[i].docPublishiTime%}"><span  class="lui_slide_tuwen_date">${lfn:message('kms-kmaps:kmsKmapsMain.postTime')}：{%data[i].docPublishiTime%}</span></div>
						</div>
				$}
					}
				}
				{$
						</div>
					</div>
				$}
			{$</div>$}
		</ui:render>
		<ui:event event="load">
				
			    var slideTuwen = new SlideTuwen({id:this.id, isAutoSlide: ${param.isAutoSlide == "true" ? "true" : "false"}});
				
				slideTuwen.init();
				slideTuwen.autoSlide();
				slideTuwen.bindEnter();
				LUI.$("#" + this.id + " .lui_slide_tuwen_pic," + "#" + this.id + " .lui_slide_tuwen_text")
							.css({"height":290});
				function SlideTuwen(config) {
					this.id = config.id;
					this.isAutoSlide = config.isAutoSlide || false;
					this.slideCache = [];
					this.slideNum = 0;
					this.cur = 0;
					this.titleOnclass = "lui_slide_tuwen_titie_on";
					this.timer = null;
					this.firstIndex = 0;
					this.init = function() {
					    var that = this;
						LUI.$("#" + this.id + " .lui_slide_tuwen_img").each(
							function(c) {
								var slide = {};
								slide["pic"] = $(this);
								this['pos'] = c;
								that.slideCache[c] = slide;
								that.slideNum ++ ; 
							}
						);
						LUI.$("#" + this.id + " .lui_slide_tuwen_title").each(
								function(c) { 
									that.slideCache[c]["title"] = LUI.$(this);
									this['pos'] = c;
									that.slideCache[c]["text"] = LUI.$(this).find('.lui_slide_tuwen_subject');
								}
						);
					}
					this.autoSlide = function(isSlide) {
							var self = this, 
								_isSlide = typeof (isSlide) =="boolean" ?  isSlide : this.isAutoSlide;
							if(self.slideNum < 0)
								return;
							if(self.cur >  self.slideNum - 1)
							   self.cur = 0;
							for(var i = 0; i < self.slideNum ; i++) {
								if(i == self.cur) {
									self.slideCache[self.cur]['pic'].css({"opacity":"0"});
									self.slideCache[self.cur]['pic'].show();
									self.slideCache[self.cur]['pic'].animate({"opacity": "1"}, "slow");
									self.slideCache[self.cur]['title'].addClass(self.titleOnclass);
									if(i < this.firstIndex || i > this.firstIndex + 4 ) {
										this.titleScroll(i);
									}
								} else {
									self.slideCache[i]['pic'].hide();
									self.slideCache[i]['title'].removeClass(self.titleOnclass);
								}
							}
							
							if(_isSlide == true) { 
								self.timer = setTimeout(function(){
															self.cur ++;
															self.autoSlide(true);
														} , 5000);
							}
					};
					this.bindEnter = function() {
						var self = this;
						LUI.$("#" + self.id + " .lui_slide_tuwen_title, " + 
						       "#" + self.id + " .lui_slide_tuwen_img")
						          .on("mouseenter", 
						      (function(){
								var  _bindFn = function(e) {
							          	if(LUI.$("#" + self.id + " .lui_slide_tuwen_text_box").is(":animated"))
							          		return;
							          
										if(self.timer)
											clearTimeout(self.timer);
										if(self.cur != e.currentTarget['pos']) {
											self.cur = e.currentTarget['pos'];
											self.autoSlide(false);
										}
									}
								if(self.slideNum > 5) {
									return function(e) {
										_bindFn(e);
										LUI.$("#" + self.id + " .lui_slide_tuwen_text_ud").show();
									};
								} else {
									return function(e) {
										_bindFn(e);
									};
								}
							})());
						
						LUI.$("#" + self.id + " .lui_slide_tuwen_obj").on("mouseleave ", function() {
							if(self.timer)
								clearTimeout(self.timer);
							LUI.$("#" + self.id + " .lui_slide_tuwen_text_ud").hide();
							self.timer = setTimeout(
							    function(){
								    self.cur ++;
								    self.autoSlide();
							    }, 5000);
						});
						
						LUI.$("#" + self.id + " .lui_slide_tuwen_text_down").on("click", function() {
								self.titleScroll(self.firstIndex + 5);
						});
						LUI.$("#" + self.id + " .lui_slide_tuwen_text_up").on("click", function() {
								self.titleScroll(self.firstIndex - 5);
						});
					}
					<%--大于5个时候的滚动 --%>
					this.titleScroll = function(index) {
						if(this.slideNum <= 0)
							return;
					    var _firstIndex = this.firstIndex;
						this.firstIndex = index;
						if(index <= 0)
					    	this.firstIndex = 0;
						else if(this.slideNum - index < 5)
					    	this.firstIndex = this.slideNum - 5 ;
					    if(_firstIndex != this.firstIndex)
							LUI.$("#" + this.id + " .lui_slide_tuwen_text_box").animate({"top":-this.firstIndex * 58}, 500);
					}
				}
		</ui:event>
	</ui:dataview>
</ui:ajaxtext>