function openQuery() {
		if(openPageReisizeTimeout!=null){
			window.clearTimeout(openPageReisizeTimeout);
		}
		var mC = LUI.$('#mainContent');
		var qur = LUI.$("#queryListView");
		if (qur.is(":hidden")) {
			var w = mC.width();
			var h = mC.height();
			qur.parent().css( {
				"position" : "relative",
				"overflow" : "hidden",
				"height" : h
			});
			mC.css( {"position" : "absolute","left" : 0	});
			mC.animate( {"left" : -w,"opacity" : 0},50, function() {
				qur.parent().css( {
					"position" : "",
					"overflow" : "",
					"height" : ""
				});
				mC.css( {
					"display" : "none",
					"position" : "",
					"left" : 0
				});
			});

			qur.css( {
				"position" : "absolute",
				"left" : w,
				"opacity" : 0,
				"display" : ""
			});
			qur.animate( {"left" : 0,"opacity" : 1},50, function() {
				qur.css( {
					"position" : ""
				});
			});
		}
	}
	var openPageReisizeTimeout = null;
	function openPageResize(){
		try{
			var ifr = LUI.$("#mainIframe");
			var sh = ifr[0].contentWindow.document.body.scrollHeight;
			var oh = ifr[0].contentWindow.document.body.offsetHeight;			 
			var chs = ifr[0].contentWindow.document.body.childNodes;
			var bh = 0;
			var bw = 0;
			for(var i=0;i<chs.length;i++){
				var tbh = chs[i].offsetTop + chs[i].offsetHeight;
				var tbw = chs[i].offsetLeft + chs[i].offsetWidth;
				if(tbh > bh){
					bh = tbh;
				}
				if(tbw > bw){
					bw = tbw;
				}
			}
			if(ifr.contents().innerWidth() > ifr.width()){
				bh = bh + 28;
			}
			if(ifr.contents().innerHeight() > bh){
				bh = ifr.contents().innerHeight();
			}
			ifr[0].style.height = (bh) + 'px';
		}catch(e){}
		openPageReisizeTimeout = window.setTimeout(openPageResize, 200);
	}
	function openPage(url) {

		var ifr = LUI.$("#mainIframe");
		var qur = LUI.$("#queryListView");
		if(url){
			ifr.attr("src", url).load( function() {
				openPageResize();
			});
		}else{
			openPageResize();
		}

		var mC = LUI.$('#mainContent');
		var xtop = LUI.$("body").scrollTop();
		if(xtop > qur.offset().top + 100){
			//debugger;		 
			LUI.$("html,body").animate( {
				scrollTop : qur.offset().top
			}, 300);
		}
		if (mC.is(":hidden")) {
			var w = qur.width();
			var h = qur.height();
			qur.parent().css( {
				"position" : "relative",
				"overflow" : "hidden",
				"height" : h
			});
			qur.css( {
				"position" : "absolute",
				"left" : 0,
				"opacity" : 1,
				"display" : ""
			});
			qur.animate( {"left" : w,"opacity" : 0});
			
			mC.css( {
				"position" : "absolute",
				"left" : -w,
				"opacity" : 0,
				"display" : "",
				"width" : w
			});
			
			mC.animate( {"left" : 0,"opacity" : 1}, function() {
				qur.parent().css( {
					"position" : "",
					"overflow" : "",
					"height" : ""
				});
				qur.css( {
					"display" : "none",
					"position" : "",
					"left" : w,
					"opacity" : 1
				});
				mC.css( {
					"position" : "",
					"width" : ""
				});
			});
			 
		}
	}