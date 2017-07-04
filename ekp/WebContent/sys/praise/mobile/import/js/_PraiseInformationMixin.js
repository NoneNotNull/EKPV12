define(	["dojo/_base/declare", "dojo/_base/lang", "dojo/request", "mui/util"], 
		function(declare, lang, req, util) {

		return declare("sys.praise.mobile.import.js._PraiseInformationMixin", null, {
			// 判断是否已经点赞过
			isPraisedUrl : '/sys/praise/sys_praise_main/sysPraiseMain.do?method=isPraised',
			// 新增点赞
			addPraisedUrl : '/sys/praise/sys_praise_main/sysPraiseMain.do?method=addNewPraiseOnMobile&forward=lui-source',
			// 取消点赞
			delPraisedUrl : '/sys/praise/sys_praise_main/sysPraiseMain.do?method=deletePraiseOnMobile',

			isPraised : false,

			modelId : null,

			modelName : null,
			
			praiseId : null,

			_rq : function(url, data, callback) {
				req(util.formatUrl(url), {
							handleAs : 'json',
							method : 'post',
							data : data
						}).then(lang.hitch(this, callback));
			},

			hasPraised:function(){
				var self = this;
				this._rq(this.isPraisedUrl,{
						modelId : this.modelId,
						modelName : this.modelName
					},function(data){
						self._set('lock',false);
						if(data){
							if (data.isPraised){
								self._set('praiseId',data.fdId);
								self._set('isPraised',true);
							}else{
								self._set('praiseId',null);
								self._set('isPraised',false);
							}
							self.togglePraised(true);
						}
					});
			},
			
			doPraised:function(){
				if (this.lock)
					return;
				this._set('lock', true);
				var self = this;
				if (!this.isPraised){
					this._rq(this.addPraisedUrl, {
						fdModelId : this.modelId,
						fdModelName : this.modelName
					}, function(data) {
						self._set('lock',false);
						self._set('praiseId',data.fdId);
						self._set('isPraised',true);
						self.togglePraised();
					});
				}else{
					this._rq(this.delPraisedUrl, {
						fdId : this.praiseId,
						fdModelId : this.modelId,
						fdModelName : this.modelName
					}, function(data) {
						self._set('lock',false);
						self._set('praiseId',null);
						self._set('isPraised',false);
						self.togglePraised();
					});
				}
			},
			//覆盖
			togglePraised:function(isInit){
				
			}

	});
});