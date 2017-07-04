define([
        "dojo/_base/lang",
        "dojo/query",
        "dojo/on",
        "dojo/dom-style",
        "dojo/dom-form",
        "dojo/dom-construct",
        "dojo/request",
        "mui/dialog/Tip", 
        "mui/device/adapter",
        "dojo/_base/window",
        "mui/util",
        "dojo/touch",
        "dojo/_base/event",
        ], function(lang, query, on, domStyle, domForm, domConstruct, request, Tip, adapter, win, util, touch, event) {
			var doBack = function() {
				var rtn = adapter.goBack();
				if(rtn == null){
					history.back();
				}
			}
			

		    window._alert = window.alert;
		    var tipAlert = function(txt) {
		    	require(["mui/dialog/Tip"], function(Tip) {
		    		Tip.tip({text:txt});
		    	});
		    };
			
			var processing = Tip.processing();
			var working = false;

			function tipProccessing() {
				if (working)
					return false;
				working = true;
				window.alert = tipAlert;
				processing.show();
				return true;
			}
			function hideProcessing() {
            	working = false;
            	window.alert = window._alert;
            	processing.hide(false);
			}
			var ajaxForm = function(formName, options) {
				var form = lang.isString(formName) ? query(formName)[0] : formName;
				
				var success = options.success ? options.success : function() {
					Tip.success({text: "操作成功", callback: options.back ? doBack : null, cover: true});
				};
				var fail = options.error ? options.error : function() {Tip.fail({text: "操作失败", cover: true});};
				
				var doSubmit = function(form) {
					var url = form.action;
					var promise = request.post(url, {
		                data: domForm.toObject(form),  
		                timeout: 10000,
		                headers: {'Accept': 'application/json'},
		                handleAs: 'json'
		            }).then(function(result) {
		            	hideProcessing();
		            	if (result['status'] === false) {
		            		fail(result);
		            		return;
		            	}
		            	success(result);
		            }, function(result) {
		            	hideProcessing();
		            	fail(result);
		            });
				};
				
				var onsubmit = function(evt) {
					
					evt.stopPropagation();
		            evt.preventDefault();
		            tipProccessing();
		            doSubmit(form);
				};
				
				if (window.Com_Submit) {
					Com_Submit.ajaxBeforeSubmit = tipProccessing;
					Com_Submit.ajaxCancelSubmit = hideProcessing;
					Com_Submit.ajaxSubmit = doSubmit;
				} else {
					on(form, "submit", onsubmit);
				}
			};
			return {
				ajaxForm: ajaxForm,
				
				load: function(id, require, load) {
					require(["dojo/domReady!"], function() {
						ajaxForm("[name='" + id + "']", {
							back: true
						});
						if (load)
							load();
					});
				}
			};
		});