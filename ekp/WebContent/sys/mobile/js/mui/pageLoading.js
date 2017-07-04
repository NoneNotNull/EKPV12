define([
        "dojo/dom",
        'dojo/request/notify',
    ], function(dom, notify) {
	
	var hideDone = false;
	var canHide = false;
	var ajaxRequestConut = 0;
	
	var hide = function() {
		if (canHide && 0 <= ajaxRequestConut) {
			setTimeout(function() {
				dom.byId('pageLoading').style.display = 'none';
			}, 10);
			hideDone = true;
		}
	};
	
	notify('start', function() {
		if (hideDone)
			return;
		ajaxRequestConut ++;
	});
	
	notify('stop', function() {
		if (hideDone)
			return;
		ajaxRequestConut --;
		hide();
	});
	
	return {
		hide: function() {
			canHide = true;
			hide();
		},
		isHide: function() {
			return hideDone;
		}
	};
});