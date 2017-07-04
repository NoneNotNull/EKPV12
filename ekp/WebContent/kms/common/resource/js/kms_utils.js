
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
}

/**
 * 字符串截取
 * 
 * @param {}
 *            str
 * @param {}
 *            length
 * @return {}
 */
function resetStrLength(str, length) {
	// 原字符串即使全部按中文算，仍没有达到预期的长度，不需要截取
	if (str) {
		if (str.length * 2 <= length)
			return str;
		var rtnLength = 0; // 已经截取的长度
		for (var i = 0; i < str.length; i++) {
			// 字符编码号大于200，将其视为中文，该判断可能不准确
			if (Math.abs(str.charCodeAt(i)) > 200)
				rtnLength = rtnLength + 2;
			else
				rtnLength++;
			// 超出指定范围，直接返回
			if (rtnLength > length)
				return str.substring(0, i)
						+ (rtnLength % 2 == 0 ? ".." : "...");
		}
		return str;
	}

}

/**
 * 根据portlet获取beanParm的值
 * 
 * @param {}
 *            portletId
 */
function getBeanParmById(portletId) {
	var portlet = $('#' + portletId);
	var param = KMS_JSON(portlet.attr("parameters"));
	return KMS_JSON(param.kms.beanParm);
}