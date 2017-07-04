seajs.use(['lang!km-imeeting','lui/topic'],function(lang,topic){
	
	function createContent(){
		var content=$('<div class="discuss" />');
		content.append(createSort());//排序行
		content.append(createInfo());//统计行
		content.append(createTable());//数据行
		createPage();
		return content;
	}
	
	//排序行
	function createSort(){
		var sort=$('<div class="sort" />'),
			sortObject={
				"creator":lang['kmImeetingMainFeedback.order.creator'],
				"dept":lang['kmImeetingMainFeedback.order.dept'],
				'opttype':lang['kmImeetingMainFeedback.order.opttype']
			};
		var _ul=$('<ul/>'),
			currentType='creator';
		for(var key in sortObject){
			var _li=$('<li/>');
			$('<a href="javascript:void(0);" key="'+key+'">'+sortObject[key]+'</a>').click(function(){
				var __li=$(this).parent();
					dataview=render.parent,
					source=dataview.source;
				var type=$(this).attr('key'),
					sort='desc';
					//当前为升序，点击后改为降序
				if(__li.hasClass('asc')){
					sort='desc';
				}else{
					sort='asc';
				}
				source.setUrl(Com_SetUrlParameter(source.url,"type",type));//修改请求地址
				source.setUrl(Com_SetUrlParameter(source.url,"sort",sort));//修改请求地址
				source.get();
			}).appendTo(_li);
			//选中
			if(key==data.type){
				_li.addClass('current');
			}
			//升序
			if('asc'==data.sort){
				_li.addClass('asc');
			}
			_ul.append(_li);
		}
		sort.append(_ul);
		return sort;
	}
	
	//统计列
	function createInfo(){
		var info=$('<div class="info">');
		//参加人数
		info.append(lang['kmImeetingMainFeedback.notifyCount']+':').append($('<span class="summary_tips">'+data.notifyCount+'</span>'));
		//回执数
		info.append(lang['kmImeetingMainFeedback.feedbackCount']+':').append($('<span class="summary_tips">'+data.feedbackCount+'</span>'));
		//参加人数
		info.append(lang['kmImeetingMainFeedback.attendCount']+':').append($('<span class="summary_tips">'+data.attendCount+'</span>'));
		//不参加人数
		info.append(lang['kmImeetingMainFeedback.unAttendCount']+':').append($('<span class="summary_tips">'+data.unAttendCount+'</span>'));
		return info;
	}
	
	//列表
	function createTable(){
		var table=$('<table class="meeting_table"/>'),
			filedsObj={
				'reason':lang['kmImeetingMainFeedback.filed.reason'],
				"creator":lang['kmImeetingMainFeedback.filed.creator'],
				"opttype":lang['kmImeetingMainFeedback.filed.opttype'],
				'attend':lang['kmImeetingMainFeedback.filed.attend']
				
			},
			opttypeObj={
				"01":lang['enumeration_km_imeeting_main_feedback_fd_operate_type_attend'],
				"02":lang['enumeration_km_imeeting_main_feedback_fd_operate_type_unattend'],
				"03":lang['enumeration_km_imeeting_main_feedback_fd_operate_type_proxy'],
				"04":'未回执'
			};
		if(data.list!=null && data.list.length>0){
			var list=data.list;
			var _titleTr=$('<tr/>');
			for(var key in filedsObj){
				$('<th class="'+key+'">'+filedsObj[key]+'</th>').appendTo(_titleTr);
			}
			table.append(_titleTr);
			for(var i=0;i<list.length;i++){
				var _dataTr=$('<tr/>');
				for(var key in filedsObj){
					var _value=list[i][key];
					if(!_value){
						_value="";
					}
					var _td=$('<td/>');
					if(key=="creator"){//姓名列单独处理,添加部门
						$('<p class="innerData">'+_value+'</p>').appendTo(_td);
						if(list[i]['dept']){
							$('<p class="innerData">'+list[i]['dept']+'</p>').appendTo(_td);
						}
					}
					if(key=="opttype"){//操作状态列
						if(!_value) _value="04";
						var _p=$('<p class="innerData"/>').appendTo(_td);
						var src=Com_GetCurDnsHost() + Com_Parameter.ContextPath+"/km/imeeting/resource/images/opttype"+_value+".png";
						_p.append('<img src="'+src+'"/>').append('<span class="opttypeTxt">'+opttypeObj[_value]+'</span>');
					}
					if(key=="attend"){//实际参与人列
						_td.append(_value);
					}
					if(key=="reason"){//实际参与人列
						_td.append(_value);
						if(list[i]['alterTime'])
							_td.append($('<p class="alterTime">'+list[i]['alterTime']+'</p>'));
						_td.css("text-align","left");
					}
					_td.appendTo(_dataTr);
				}
				table.append(_dataTr);
			}
		}
		return table;
	}
	
	//创建分页控件
	function createPage(){
		var evt={
			page: {
				currentPage:data.pageno, 
				pageSize:data.rowsize, 
				totalSize:data.totalrows
			}
		};
		topic.publish('list.changed',evt);
		topic.subscribe('paging.changed',function(evt){
			var arr = evt.page;
		    var pageno=arr[0].value;
		    var rowsize=arr[1].value;
		    var dataview=render.parent,
				source=dataview.source;
		    source.setUrl(Com_SetUrlParameter(source.url,"pageno",pageno));
		    source.setUrl(Com_SetUrlParameter(source.url,"rowsize",rowsize));
		    source.get();
		});
	}
	
	var content=createContent();
	
	
	done(content);
});