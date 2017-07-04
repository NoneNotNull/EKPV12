/*压缩类型：标准*/
Com_IncludeFile("validator.jsp|validation.jsp|validation.js|plugin.js|jquery.js|calendar.js|data.js");
var fdIntring=0;
function IntroduceOpt(modelName,modelId,key,langCfg){
	this.langCfg = langCfg;
	this.modelName = modelName;
	this.modelId = modelId;
	this.key = key;
	this.S_EditAreaId = "intr_editMain"; 
	this.S_SaveUrl = Com_Parameter.ContextPath + "sys/introduce/sys_introduce_main/sysIntroduceMain.do?method=save";
	this.S_CheckUrl = Com_Parameter.ContextPath + "sys/introduce/sys_introduce_main/sysIntroduceMain.do?method=introcheck";
	//清楚验证推荐对象是否重复缓存
	this.clearCache = false;
	var self = this;
	/*************************以下是外部调用函数********************************************/
	this.onload = function(){
		var editFlag = $('#' + self.S_EditAreaId);
		if(editFlag.length>0){
			//初始化评价等级
			var liArr = editFlag.find('.intr_star li');
			liArr.click(function(){
				var liObj = $(this);
				var val = liObj.attr("star");
				self._intr_starChange(parseInt(val, 10),true);
			});
			
			liArr.mouseover(function(){
				var liObj = $(this);
				var val = liObj.attr("star");
				self._intr_starChange(parseInt(val, 10),false);
			});

			liArr.mouseout(function(){
				var val = $('select[name="fdIntroduceGrade"]').val();
				self._intr_starChange(parseInt(val, 10),false);
			});
			
			var val =$('select[name="fdIntroduceGrade"]').val();
			self._intr_starChange(parseInt(val, 10),false);
			//初始化推荐选择操作事件
			$(".intr_optType input[name^='fdIntroduceTo']").click(function(){
				self._intr_chkChange($(this));
			});
			//意见输入框事件初始化
			$("textarea[name='fdIntroduceReason']").bind({
					"keyup":function(){
							self._intr_prompInfo($(this).val(),true);	
					},
					"focus":function(){
							self._intr_prompt(this);
					},
					// 兼容右键粘贴字数限制
					"input":function(){
							self._intr_prompInfo($(this).val(),true);	
					},
					// 兼容ie9以下浏览器
					"propertychange":function(){
							self._intr_prompInfo($(this).val(),true);	
					}
			});
			//提交按钮事件初始化
			$("#intr_button").click(function(){
				if(fdIntring==1){
					return;
				}else{
					fdIntring=1;
					var data = self._intr_getUploadData();
					var check=data['fdCateModelName'];
					if(check!=null&check!=''){
						self.S_CheckUrl=self.S_CheckUrl+"&fdCateModelName="+check;
						seajs.use(['lui/dialog', 'lui/jquery'], function(dialog,$) {
							$.ajax({
								url:self.S_CheckUrl,
								type: 'get',
								dataType: 'json',
								data:data,
								success: function(data, textStatus, xhr) {
								    self._intr_submitData();
								   
								},
								error: function(data, textStatus, xhr) {
									dialog.alert(self.langCfg['intr_introcheckfalse_message']);
									fdIntring=0;
								}
							});
							
							});	
						
						
					}else{
						self._intr_submitData();
					}
				
				}
			
			});
			self._eval_enabledBtn(true);
			self._intr_valudator();
		}
	};
	//刷新推荐数
	this.refreshNum = function(info){
		var count = 0;
		if(info.data){
			if(info.data.recordCount!=null){
				count = info.data.recordCount;
			}
		}
		if(count>0)
		$("*[data-lui-mark='sys.introduce.fdIntroduceCount']").text("(" + count + ")");
	};
	
	/*************************以下是内部调用函数********************************************/
	//提交推荐信息
	this._intr_submitData = function(){
		if(!self.S_Valudator.validate())
			return;
		seajs.use(['sys/ui/js/dialog'], function(dialog,LUI) {
			self.loading = dialog.loading(null,$("#" + self.S_EditAreaId));
		});
		var data = self._intr_getUploadData();
		data['fdIntroduceTime'] = (new Date()).format(Calendar_Lang.format.dataTime);
		this.clearCache = true;
		seajs.use(['lui/dialog', 'lui/jquery'], function(dialog,$) {
		$.ajax({
			url:self.S_SaveUrl,
			type: 'POST',
			dataType: 'json',
			data:data,
			success: function(data, textStatus, xhr) {
			         self._intr_afterSubmit(data);
			         self.loading.hide();
			         fdIntring=0;
			},
			error: function(data, textStatus, xhr) {
		
				dialog.alert(self.langCfg['intr_introfalse_message']);
				self.loading.hide();
				fdIntring=0;
			}
		});
		
		});	
	};
	//校验函数
	this._intr_valudator =function(){
		if(self.S_Valudator == null)
			self.S_Valudator = $GetKMSSDefaultValidation();
		self.S_Valudator.addValidator("intr_select",self.langCfg['intr_type_select'],function(v,elem) {
			var check = $(".intr_optType input[type='checkbox']:checked");
			var rtnVal = false;
			if(check.length>0){
				rtnVal = true;
			}
			if(rtnVal==true){
				$(".intr_optType input[type='checkbox']").each(function(){
					var advise = $KMSSValidation_GetAdvice(this);
					if( advise!=null)  $(advise).hide();
				});
			}else{
				if(elem.name=='fdIntroduceToEssence') rtnVal = true;
			}
			return rtnVal;
		});
		 $(".intr_optType input[type='checkbox']").each(function(){
			self.S_Valudator.addElements(this);
		});
		$("input[name='fdIntroduceGoalNames']").each(function(){
			self.S_Valudator.addElements(this);
		});
		self.S_Valudator.addValidator('repetitionValidator(fdIntroduce)', self.langCfg['intr_repetition_message'],
			function(v, e, o) {
				var data = new KMSSData(); 
				if(self.clearCache){
					data.UseCache = false;
					self.clearCache = false;
				}
			    var fdIntroduce = document.getElementsByName(o['fdIntroduce'])[0].value; 
			    var fdModelId = document.getElementsByName('fdModelId')[0].value;
			    var fdModelName = document.getElementsByName('fdModelName')[0].value;
				var url="sysIntroduceGoalCheckService&fdIntroduce="+fdIntroduce+"&fdModelId="+fdModelId+"&fdModelName="+fdModelName;
				var isExist =data.AddBeanData(url).GetHashMapArray()[0];
				data.UseCache = true;
			   	if(isExist["key0"]=='false'){
			   		return true;
			   	}else{
			   		return false;
			   	}
			});
	};
	//获取需提交的数据
	this._intr_getUploadData = function(){
		var dataObj = {};
		$("#"+ self.S_EditAreaId).find(":input").each(function(){
			var domObj = $(this);
			var eName = domObj.attr("name");
			if(eName!=null && eName!="" ){
				dataObj[eName] = domObj.val();
			}
		});
		return dataObj;
	};
	//数据提交后的处理
	this._intr_afterSubmit = function(data){
		if(data!=null && data.status==true){
			self._intr_recordCountChg('add');
			self._intr_resetEditStatus();
		}
	};
	//button事件处理
	this._eval_enabledBtn = function(enable){
		var buttonVar = $("#intr_button");
		if(enable==true){
			buttonVar.removeAttr("disabled");
			buttonVar.removeClass("intr_button_disable");
		}else{
			buttonVar.attr("disabled","disabled");
			buttonVar.addClass("intr_button_disable");
		}
	};
	//重置编辑信息
	this._intr_resetEditStatus = function(){
		self._intr_starChange(0,true,true);
		$("input[name='fdIntroduceGoalIds']").val('');
		$("input[name='fdIntroduceGoalNames']").val('');
		var essence = $("input[name='fdIntroduceToEssence']");
		essence.removeAttr("checked");
		self._intr_chkChange(essence);
		var person = $("input[name='fdIntroduceToPerson']");
		person.attr("checked","checked");
		self._intr_chkChange(person);
	};
	//推荐类型联动
	this._intr_chkChange = function(chkObj){
		var name = chkObj.attr("name");
		var isShow = true;
		if(chkObj.is(":checked")){
			chkObj.val("1");
			isShow = true;
		}else{
			chkObj.val("0");
			isShow = false;
		}
		if(name == "fdIntroduceToPerson"){
			var introducTo = $("input[name='fdIntroduceGoalNames']");
			if(isShow){
				introducTo.attr("validate","required repetitionValidator(fdIntroduceGoalIds)");
				$('*[group="intr_person"]').show();
			}else{
				introducTo.removeAttr("validate");
				var advise = $KMSSValidation_GetAdvice(introducTo.get(0));
				if( advise!=null)  $(advise).hide();
				$('*[group="intr_person"]').hide();
			}
		}
	};
	//推荐级别联动
	this._intr_starChange=function(val,confirm,forceChg){
		var contentObj = $('textarea[name="fdIntroduceReason"]');
		var contentVal = $.trim(contentObj.val());
		var chgVal = false;
		for(var i=0; i<3; i++){
			var className = 'lui_icon_s_bad';
			if(i >= val){
				className = 'lui_icon_s_good';
			}else{
				className = 'lui_icon_s_bad';
			}
			$("#intr_star_" + i).attr('class',className);
			if(!chgVal)
				chgVal = contentVal=='' ||(contentVal == self.langCfg['intr_star_' + i]);
		}
		if(chgVal || forceChg){		
			contentObj.val(self.langCfg['intr_star_' + val]);
			contentObj.css({'color':'#8a8a8a'});
			$(".intr_prompt").hide();
		}else{
			$(".intr_prompt").show();
		}
		if(confirm){
			$('select[name="fdIntroduceGrade"]').val(val);
		}
		self._intr_prompInfo(contentObj.val(),true);
		var level = $('#intr_level');
		level.addClass("lui_icon_s_recommend");
		level.html($('select[name="fdIntroduceGrade"] option:nth-child('+(val+1)+')').text());
	};
	//推荐字数提示
	this._intr_prompt=function(thisObj){
		var propmtTxt = $(thisObj).val();
		propmtTxt = $.trim(propmtTxt);
		var isChangeColor = false;
		for(var i=0;i<4;i++){
			if(propmtTxt==self.langCfg['intr_star_'+i] || propmtTxt==''){
				isChangeColor = true;
				break;
			}
		}
		if(isChangeColor){
			$(thisObj).css({'color':''});
			$(thisObj).val('');
			propmtTxt = '';
		}
		self._intr_prompInfo(propmtTxt,false);
		$(".intr_prompt").show();
	};
	//显示推荐字数限制信息
	this._intr_prompInfo = function(propmtTxt,changeBtn){
		var l = 0;
		var tmpArr = propmtTxt.split("");
		for (var i = 0; i < tmpArr.length; i++) {				
			if (tmpArr[i].charCodeAt(0) < 299) {
				l++;
			} else {
				l += 2;
			}
		}
		var promptVar = $(".intr_prompt");
		if(l<=280){
			promptVar.html(self.langCfg['intr_prompt_1']+'<font style="font-family: Constantia, Georgia; font-size: 20px;">'
							+ Math.abs(parseInt((280-l) / 2))+"</font>"+self.langCfg['intr_prompt_3']);
			promptVar.css({'color':''});
			if(changeBtn)
				self._eval_enabledBtn(true);
		}else{
			promptVar.html(self.langCfg['intr_prompt_2']+'<font style="font-family: Constantia, Georgia; font-size: 20px;">'
							+ Math.abs(parseInt((l-280) / 2)+1)+"</font>"+self.langCfg['intr_prompt_3']);
			promptVar.css({'color':'red'});
			if(changeBtn)
				self._eval_enabledBtn(false);
		}
	};
	//推荐次数更改事件
	this._intr_recordCountChg=function(flag){
		var count = self._eval_getIntrRecordNumber(flag);
		seajs.use(['lui/dialog','lui/topic'], function(dialog,topic) {
			self.loading.hide();
			dialog.success(self.langCfg['intr_prompt_sucess'],$("#" + self.S_EditAreaId));
			topic.publish("introduce.submit.success",{"data":{"recordCount":count}});
			topic.channel("intr_ch1").publish("list.refresh");
		});
	};
	//获取提交后的推荐总数
	this._eval_getIntrRecordNumber = function(flag){
		var incNum = 1;
		if(flag=='del'){
			incNum = -1;
		}
		var count = 0;
		$('div[id="intr_label_title"]').each(function(){
			var scoreInfo = $(this).text();
			var numinfo = "0";
			if(scoreInfo.indexOf("(")>0){
				var prefix=scoreInfo.substring(0,scoreInfo.indexOf("("));
				numinfo = scoreInfo.substring(scoreInfo.indexOf("(") + 1 , scoreInfo.indexOf(")"));
				count = parseInt(numinfo) + incNum;
				$(this).text(prefix+"("+(parseInt(numinfo) + incNum)+")");
			}else{
				count = 1;
				$(this).text(scoreInfo + "(1)");
			}
		});
		return count;
	};
}