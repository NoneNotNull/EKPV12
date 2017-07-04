/**********************************************************
功能：显示动画效果对象
参数：
	designer : 设计器对象
	options  : 相关参数配置
使用：
	
作者：龚健
创建时间：2009-03-19
**********************************************************/
function Designer_Animation(designer, options) {
	this.owner = designer || null;
	this.options = {
		step     : 1,                      //步长
		duration : 30,                     //滑动持续时间
		time     : 10,                     //滑动延时
		tween    : 'Exponential',          //滑动算法(默认是曲线缓动)
		onStart  : function(){},           //开始滑动时执行
		onFinish : function(){}            //滑动结束时执行
	};
	Designer.extend(true, this.options, options || {});

	//内部属性
	this._shower = null;                   //动画显示对象

	//内部方法
	this._doAction = _Designer_Animation_DoAction;
	this._doTween = _Designer_Animation_DoTween;
	this._getShowPosition = _Designer_Animation_GetShowPosition;
	this._getAttachSize = _Designer_Animation_GetAttachSize;

	//公用方法
	this.initialize = Designer_Animation_Initialize;
	this.show = Designer_Animation_Show;
	this.setOptions = Designer_Animation_SetOptions;
	this.onStart = this.options.onStart;
	this.onFinish = this.options.onFinish;

	//初始化
	this.initialize();
};

/**********************************************************
描述：
	公共函数
功能：
	Designer_Animation_Initialize : 初始化对象
	Designer_Animation_Show       : 动画显示对象
	Designer_Animation_SetOptions : 设置参数配置
**********************************************************/
function Designer_Animation_Initialize() {
	with(document.body.appendChild(this._shower = document.createElement('div')).style) {
		position = 'absolute'; filter = 'alpha(opacity=80)'; opacity = '0.8';
		border = '1px'; display = 'none'; background = '#EAEFF3';
	}
};

function Designer_Animation_Show(attach) {
	if (this.owner == null) return;

	//若载体对象隐藏，则在载体对象旁边动画显示
	if (attach.style.display == 'none') {
		this._doAction(attach, 'explosionFromCenter');
	} else {
		this._doAction(attach, 'move');
	}
};

function Designer_Animation_SetOptions(options) {
	Designer.extend(true, this.options, options || {});
	this.onStart = this.options.onStart;
	this.onFinish = this.options.onFinish;
};

/**********************************************************
描述：
	公共函数
功能：
	_Designer_Animation_DoAction        : 动画显示
	_Designer_Animation_DoTween         : 根据算法计算
	_Designer_Animation_GetShowPosition : 获得最终显示位置
	_Designer_Animation_GetAttachSize   : 获得绑定对象的尺寸
**********************************************************/
function _Designer_Animation_DoAction(attach, effect) {
	var _self = this, _duration = _self.options.duration, _step = _self.options.step, _time = _self.options.time;
	var _currTime = 0, _size = _self._getAttachSize(attach), _showPos = _self._getShowPosition(_size);
	//开动动画前事件
	_self.onStart();
	//初始化动画对象
	with(_self._shower.style) {
		left = '-100px'; top = '-100px'; width = '0px'; height = '0px'; display = '';
	}
	//动画效果
	(function() {
		//若计算器超过限定时间
		if (_currTime > _duration) {
			attach.style.left = _self._shower.style.left;
			attach.style.top = _self._shower.style.top;
			_self._shower.style.display = 'none';
			attach.style.display = '';
			//结束事件
			_self.onFinish();
		} else {
			switch (effect) {
			case 'explosionFromCenter':
				//从中心爆炸开
				var _cWidth = _self._doTween(_currTime, 0, _size.width, _duration);
				var _cHeight = _self._doTween(_currTime, 0, _size.height, _duration);
				with(_self._shower.style) {
					width = _cWidth + 'px'; height = _cHeight + 'px';
					left = (_showPos.left + _size.width/2 - _cWidth/2) + 'px';
					top = (_showPos.top + _size.height/2 - _cHeight/2) + 'px';
				};
				break;
			case 'move':
				var _left = parseInt(attach.offsetLeft), _top = parseInt(attach.offsetTop);
				var _cLeft = _self._doTween(_currTime, _left, _showPos.left - _left, _duration);
				var _cTop = _self._doTween(_currTime, _top, _showPos.top - _top, _duration);
				with(_self._shower.style) {
					width = _size.width + 'px'; height = _size.height + 'px';
					left = _cLeft + 'px';
					top = _cTop + 'px';
				};
				break;
			}
			_currTime = _currTime + _step;
			setTimeout(arguments.callee, _time);
		}
	})();
};

function _Designer_Animation_DoTween(currTime, beginningValue, changeValue, duration) {
	switch (this.options.tween)	{
	case 'Exponential':
		return Math.round((currTime == duration)? (beginningValue + changeValue) : changeValue*(-Math.pow(2, -10*currTime/duration) + 1) + beginningValue);
	}
};

function _Designer_Animation_GetShowPosition(attachSize) {
	var wWidth = document.body.clientWidth, wHeight = document.body.clientHeight;
	//当前选中控件
	var control = this.owner.control;
	if (control == null) return {left: -1, top: -1};

	var cDomElement = control.options.domElement;
	//当前控件为容器时，并有选中子对象
	if (control.container && control.selectedDomElement.length == 1) cDomElement = control.selectedDomElement[0];
	//控件相关位置
	var cPos = Designer.absPosition(cDomElement), cWidth = cDomElement.offsetWidth, cHeight = cDomElement.offsetHeight;
	/*
	//根据右键位置原则
	var left = cPos.x + cWidth, top = cPos.y;
	if (left + attachSize.width + 2 > wWidth) left = cPos.x - attachSize.width;
	if (top + attachSize.height + 2 > wHeight) top = cPos.y - attachSize.height;
	//控件的左上
	if (left < cPos.x && top < cPos.y) left = cPos.x + cWidth - attachSize.width;
	//控件的右上
	if (left > cPos.x && top < cPos.y) left = cPos.x;
	//修正坐标
	top = (top - document.body.scrollTop < 0) ? document.body.scrollTop : top;
	left = (left < 0) ? 0 : left; top = (top < 0) ? 0 : top;
	//*/
	///*
	var left = cPos.x + cWidth, top = cPos.y;
	var _x = cPos.x - document.body.scrollLeft;
	var x = _x + cWidth;
	var y = cPos.y - document.body.scrollTop;
	if (x + attachSize.width + 2 > wWidth) {
		if (_x - attachSize.width > 0) {
			left = cPos.x - attachSize.width;
		} else {
			left = cPos.x + cWidth - attachSize.width;
		}
	}
	if (y + attachSize.height + 2 > wHeight) {
		if ( y + cHeight - attachSize.height > 0) {
			top = cPos.y - attachSize.height + cHeight;
		} else {
			top = document.body.scrollTop;
		}
	}//*/

	return {left: left, top: top};
};

function _Designer_Animation_GetAttachSize(attach) {
	//只有显示，才能获取宽和高
	attach.style.display = '';
	//宽和高
	var width = attach.offsetWidth;
	var height = attach.offsetHeight;
	//进入隐藏状态
	attach.style.display = 'none';

	return {width: width, height: height};
};