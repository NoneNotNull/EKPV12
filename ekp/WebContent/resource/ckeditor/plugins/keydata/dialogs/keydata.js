(function () {
	
	
    function keydataDialog(editor) {
    	
    	var html = [];
    	
    	var selectLiName;
    	
    	var config = editor.config;
    	
    	config.initClass = "lui_attachment_upload_btn_init";
    	
    	var div_popup_comtent_html = "";
    	div_popup_comtent_html+='    <div class="custom_popupTabContent" name="con_popuptabhead" style="display:none;">';
    	div_popup_comtent_html+='        <div class="custom_searchBar">';
    	div_popup_comtent_html+='            <input class="input_txt" type="text" value="" />';
    	div_popup_comtent_html+='            <a class="btnSearchL" href="javascript:void(0)" onclick="searchKeydata($(this),#fdType#)">';
    	div_popup_comtent_html+='                <span class="btnSearchR"><span class="btnSearchC">搜索</span></span>';
    	div_popup_comtent_html+='            </a>';
    	div_popup_comtent_html+='        </div>';
    	div_popup_comtent_html+='        <ul class="custom_popupList">';
                    
    	div_popup_comtent_html+='         </ul>';
    	div_popup_comtent_html+='    </div>';
    	
    	html.push('<link href="'+Com_Parameter.ContextPath+'resource/ckeditor/plugins/keydata/css/keydata.css" type="text/css" rel="stylesheet" />');
    	
    	html.push('<div class="custom_popupBox" style="width:400px;height:450px;">');
    	html.push('<input type="hidden" name="selectedKeydata" value="">');
    	html.push('    <ul class="custom_popupTabHead">');

    	html.push('    </ul>');
//    	html.push('    <div class="custom_popupTabContent" name="con_popuptabhead">');
//    	html.push('        <div class="custom_searchBar">');
//    	html.push('            <input class="input_txt" type="text" value="请输入名称" />');
//    	html.push('            <a class="btnSearchL" href="#">');
//    	html.push('                <span class="btnSearchR"><span class="btnSearchC">搜索</span></span>');
//    	html.push('            </a>');
//    	html.push('        </div>');
//    	html.push('        <ul class="custom_popupList">');
//                    
//    	html.push('         </ul>');
//    	html.push('    </div>');


    	html.push('</div>');
    	
  
    	
    	var keydataSelector = {
    			type : 'html',
    			id : 'keydataSelector',
    			html : html.join(''),
    			onLoad : function(event) {
    				dialog = event.sender;
    			},
    			style : 'clear:both; width: 100%; border-collapse: separate;'
    		};
    	
    	
    	
    	var time = null;
    	
    	window.disableSelection = function(element) {  
            if (typeof element.onselectstart != 'undefined') {  
                element.onselectstart = function() { return false; };  
            } else if (element.style && typeof element.style.MozUserSelect != 'undefined') {  
                element.style.MozUserSelect = 'none';  
            } else {  
                element.onmousedown = function() { return false; };  
            }  
        }; 
    	
    	window.clickKeydataLi = function(obj_li,value){
    		//debugger;
    		clearTimeout(time);
    		obj_li.addClass("on").siblings().removeClass("on");
            //单击事件延时300ms触发
            time = setTimeout(function(){
            	selectedLiName = obj_li.attr('name');
        		obj_li.parent().parent().parent().find('input[name="selectedKeydata"]').get(0).value = value;
            },300);
    		
    	};
    	
    	window.dbClickKeydataLi = function(obj_li,value){
    		clearTimeout(time);
            //双击事件的具体操作
    		debugger;
    		selectedLiName = obj_li.attr('name');
    		obj_li.parent().parent().parent().find('input[name="selectedKeydata"]').get(0).value = value;
    		$(document).find('.cke_dialog_ui_button_ok').get(0).click();
    		
    	};
    	
    	window.getKeydatas = function(dataName,dataType,obj_ul){
    		
    		var url = Com_Parameter.ContextPath+"km/keydata/base/kmKeydataBase.do?method=getKeydatas&dataType="+dataType+"&dataName="+dataName;
    		$.ajax({
				url : url,
				contentType : false,
				processData : false,
				type : "GET",
				success : function(data) {
					
					$.each($.parseJSON(data), function(i,item){
						//$("<div />").attr("name",dataType+"_"+i).attr("value",item.fdId+"#$#"+item.fdUrl+"#$#"+item.fdName).attr("onclick","clickKeydataLi($(this),'"+item.fdId+"#$#"+item.fdUrl+"#$#"+item.fdName+"')").attr("ondblclick","dbClickKeydataLi($(this),'"+item.fdId+"#$#"+item.fdUrl+"#$#"+item.fdName+"')").text(item.fdName).append($("<li />")).appendTo(obj_ul);
						//var obj_li = $("<li />").attr("name",dataType+"_"+i).attr("value",item.fdId+"#$#"+item.fdUrl+"#$#"+item.fdName).attr("onclick","clickKeydataLi($(this),'"+item.fdId+"#$#"+item.fdUrl+"#$#"+item.fdName+"')").text(item.fdName);
						var obj_li = $("<li />").attr("name",dataType+"_"+i).attr("value",item.fdId+"#$#"+item.fdUrl+"#$#"+item.fdName).attr("onselectstart","return false;").text(item.fdName);
						obj_li.appendTo(obj_ul);
						obj_li.dblclick(function(){
							//disableSelection(obj_li);  
							dbClickKeydataLi($(obj_li),item.fdId+"#$#"+item.fdUrl+"#$#"+item.fdName);
						});
						obj_li.click(function(){
							clickKeydataLi($(obj_li),item.fdId+"#$#"+item.fdUrl+"#$#"+item.fdName);
							
						});
						
						});
					}
				});
    	};
    	
    	window.searchKeydata = function(obj_search_a, dataType){
    		var dataName = obj_search_a.parent().find('input.input_txt')[0].value;
    		dataName = encodeURI(dataName);
    		var obj_ul = obj_search_a.parent().parent().find('ul').get(0);
    		$(obj_ul).empty();
    		getKeydatas(dataName,dataType,obj_ul);
    		
		
    	}
    	
    	window.ajax_getKeydataTypes = function(obj_table){
    		var obj_popupBox = obj_table.find('div.custom_popupBox').get(0);
    		var dataTypes_ul = $(obj_popupBox).find('ul.custom_popupTabHead').get(0);
    		$(dataTypes_ul).empty();
    		$.ajax({
				url : Com_Parameter.ContextPath+"km/keydata/base/kmKeydataBase.do?method=getKeydataTypes",
				contentType : false,
				processData : false,
				type : "GET",
				success : function(data) {
					//alert(data);
					$.each($.parseJSON(data), function(i,item){
						//alert(item.type);
						$("<li />").attr("onclick","selectKeydataType($(this), "+i+",'"+item.type+"')").text(item.name).appendTo(dataTypes_ul);
						//debugger;
						$(div_popup_comtent_html.replace("#fdType#", "'"+item.type+"'")).appendTo(obj_popupBox);
					});
					
					//alert(tableObj.find('select')[0].value);
					$(dataTypes_ul).find('li').get(0).click();
					}
				});
    	};
    	
    	window.buildKeydatas = function(div_popup_content,dataType){
    		var obj_ul = $(div_popup_content).find("ul").get(0);
    		var len = $(obj_ul).children().length;
    		if(len==0){
    			var dataName = $(div_popup_content).find('input.input_txt')[0].value;
    			getKeydatas(dataName,dataType,obj_ul);
        		
    		}
    	};
    	
    	window.selectKeydataType = function(obj_popup_li, num, dataType){
    		obj_popup_li.parent().find('li').each(function(i,n){
    				$(n).removeClass("selected");
    			}
    		);
    		obj_popup_li.addClass("selected");
    		
    		var divs = obj_popup_li.parent().parent().find("div[name='con_popuptabhead']");
    		divs.each(function(i,n){
				if(i==num){
					$(divs.get(i)).show();
				}else{
					$(divs.get(i)).hide();
				}
			}
    		);
    		obj_popup_li.addClass("selected");
    		buildKeydatas(divs.get(num),dataType);
    	}
    	
    	
    	
    	window.ajax_insertKeydataUsed = function(keydata_id,formName,modelId){
    		//var keydata_select = tableObj.find('select')[1];
    		//var keydata_value = keydata_select.value;
    		//var keydata_id = keydata_value.substring(0,33);
    		//var dataName = tableObj.find('input[name=dataName_input]')[0].value;
    		var url = Com_Parameter.ContextPath+"km/keydata/base/kmKeydataUsed.do?method=insertKeydataUsed&keydataId="+keydata_id+"&formName="+formName+"&modelId="+modelId;
    		//alert(url);
    		$.ajax({
				url : url,
				contentType : false,
				processData : false,
				type : "GET",
				success : function(data) {
					//alert(data);
					}
				});
    	};
    	
 
        return {
            title: '关键数据选择',
            minWidth: 300,
            minHeight: 200,
            contents : [{
				id : 'tab1',
				label : '主数据',
				title : '',
				expand : true,
				padding : 0,
				elements : [keydataSelector]
			}],
            buttons: [
            CKEDITOR.dialog.okButton,
            CKEDITOR.dialog.cancelButton],
            
            onLoad: function () {
                //alert('onLoad');
                //debugger;
                //var d = this.getDialog();
                //var e = d.getContentElement("info", "dataType");
                //alert(this.children[1].children[0]);//.children[0].size = "5";
                
                //var select_datas = $(this.getElement().$.children[0]).find('select')[1];
                
                // $(obj.getElement().$.children[0]).find('select')[0].value;
                debugger;
                var obj_table = $(this.getElement().$.children[0]);
                ajax_getKeydataTypes(obj_table);
                                                                  
                
            	
                
            },
            onShow: function () {
            },
            onHide: function () {
            },
            onOk: function () {
                this.commitContent(editor);
                //debugger;
                var tableObj = $(this.getElement().$.children[0]);
                var value = tableObj.find('input[name="selectedKeydata"]').get(0).value;
                //alert(value);
                if(value==""){
                	return;
                }
                var values = value.split("#$#");
                var name = values[2];
                var formObj = $(editor.element.$).closest('form')[0];
                var formName = formObj.name;
                //var element = new CKEDITOR.dom.element('span', editor.document);
                //element.setText(text);
                var url = Com_Parameter.ContextPath.substring(0,Com_Parameter.ContextPath.length-1)+values[1]+"&formName="+formName;
                var keydataId = values[0];
                var element = new CKEDITOR.dom.element.createFromHtml('<a href="'+url+'"><span style="color:#F19703;">'+name+'</span></a>' );
                editor.insertElement(element);
                
                var fdId = $(formObj).find('input[name=fdId]')[0].value;
                ajax_insertKeydataUsed(keydataId,formName,fdId);
                //alert(editor.element.$.name);
                
            },
            onCancel: function () {
                //alert('onCancel');
            },
            resizable: CKEDITOR.DIALOG_RESIZE_HEIGHT
        };
    }
   
    CKEDITOR.dialog.add('keydata', function (editor) {
        return keydataDialog(editor);
    });
})();
