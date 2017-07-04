/**
 * 图片按比例缩放&垂直居中
 * 
 * @param {}
 *            obj
 * @param {}
 *            outerObj
 */
function drawImage(obj, outerObj) {

	var image = new Image(), iheight, iwidth;
	if (outerObj.currentStyle) {
		iheight = outerObj.currentStyle['height'];
		iwidth = outerObj.currentStyle['width'];
	} else {
		var style = document.defaultView.getComputedStyle(outerObj, null);
		iheight = style['height'];
		iwidth = style['width'];
	}

	iheight = parseInt(iheight);
	iwidth = parseInt(iwidth);
	image.src = obj.src;
	// 兼容chrome浏览器
	image.height = image.height == 0 ? obj.height : image.height;
	image.width = image.width == 0 ? obj.width : image.width;
	if (image.width > 0 && image.height > 0) {
		if (image.width / image.height >= iwidth / iheight) {
			if (image.width > iwidth) {
				obj.width = iwidth;
				obj.height = (image.height * iwidth) / image.width;
				// display is none ~~ obj.height = 0;
				obj.style.cssText = ['margin-top: ',
						(iheight - (image.height * iwidth) / image.width) / 2,
						'px'].join('');
			} else {
				obj.width = image.width;
				obj.height = image.height;
				obj.style.cssText = ['margin-top: ',
						(iheight - image.height) / 2, 'px;margin-left: ',
						(iwidth - image.width) / 2, 'px'].join('');
			}
		} else {
			if (image.height > iheight) {
				obj.height = iheight;
				obj.width = (image.width * iheight) / image.height;
				obj.style.cssText = ['margin-left: ',
						(iwidth - (image.width * iheight) / image.height) / 2,
						'px'].join('');
			} else {
				obj.width = image.width;
				obj.height = image.height;
				obj.style.cssText = ['margin-top: ',
						(iheight - image.height) / 2, 'px;margin-left: ',
						(iwidth - image.width) / 2, 'px'].join('');
			}
		}
	}
	obj.style.visibility = 'visible';
	obj.style.display = 'block';
}
