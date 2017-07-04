(function(window) {
	$.fx.off = false;
	Pda.ps = {};
	// 工具类
	var ng = navigator.userAgent;
	Pda.ps.Util = {
		browser : {
			version : (ng.match(/.+(?:rv|it|ra|ie)[\/: ]([\d.]+)/) || [])[1],
			webkit : /webkit/i.test(ng),
			isAndroid : /android/i.test(ng),
			isiOS : /like Mac OS/i.test(ng)
		},

		coalesce : function() {
			var i;
			for (i = 0; i < arguments.length; i++) {
				if (!this.isNothing(arguments[i])) {
					return arguments[i];
				}
			}
			return null;
		},

		extend : function(destination, source, overwriteProperties) {
			if (this.isNothing(overwriteProperties)) {
				overwriteProperties = true;
			}
			if (destination && source && this.isObject(source)) {
				for (var prop in source) {
					if (overwriteProperties) {
						destination[prop] = source[prop];
					} else {
						if (typeof destination[prop] == "undefined") {
							destination[prop] = source[prop];
						}
					}
				}
			}
		},

		swapArrayElements : function(arr, i, j) {
			var temp = arr[i];
			arr[i] = arr[j];
			arr[j] = temp;
		},

		isObject : function(obj) {
			return typeof obj == "object";
		},

		isNothing : function(obj) {
			if (typeof obj === "undefined" || obj === null) {
				return true;
			}
			return false;
		},

		isString : function(obj) {
			return typeof obj == "string";
		}
	};

})(window);
// 工具类dom的扩展
(function(window, Util) {
	Util.extend(Util, {
				DOM : {
					resetTranslate : function(el) {
						$(el).css({
									webkitTransform : 'translate3d(0px, 0px, 0px)'
								});

					},
					createElement : function(type, attributes, content) {
						var retval = $('<' + type + '></' + type + '>');
						retval.attr(attributes);
						retval.append(content);
						return retval[0];
					},
					appendChild : function(childEl, parentEl) {
						$(parentEl).append(childEl);
					},
					appendToBody : function(childEl) {
						$('body').append(childEl);
					},

					removeChildren : function(parentEl) {
						$(parentEl).empty();
					},
					getAttribute : function(el, attributeName) {
						return $(el).attr(attributeName);
					},

					setAttribute : function(el, attributeName, value) {
						$(el).attr(attributeName, value);
					},

					removeAttribute : function(el, attributeName) {
						$(el).removeAttr(attributeName);
					},

					addClass : function(el, className) {
						$(el).addClass(className);
					},

					removeClass : function(el, className) {
						$(el).removeClass(className);
					},

					setStyle : function(el, style, value) {
						if (Util.isObject(style)) {
							$(el).css(style);
						} else {
							$(el).css(style, value);
						}
					},
					hide : function(el) {
						$(el).hide();
					},
					show : function(el) {
						$(el).show();
					},
					width : function(el, value) {
						if (!Util.isNothing(value)) {
							$(el).width(value);
						}
						// 兼容zepto
						return Math.max($(el).width(), parseInt($(el)
										.css('width')));
					},

					height : function(el, value) {
						if (!Util.isNothing(value)) {
							$(el).height(value);
						}
						return Math.max($(el).height(), parseInt($(el)
										.css('height')));
					},

					bodyWidth : function() {
						return $(document.body).width();
					},

					bodyHeight : function() {
						return $(document.body).height();
					},

					windowHeight : function() {
						if (!window.innerHeight)
							return $(window).height();
						return window.innerHeight;
					},

					windowScrollTop : function() {
						if (!window.pageYOffset)
							return $(window).scrollTop();
						return window.pageYOffset;
					},

					addListener : function(el, type, listener) {
						$(el).bind(type, listener);
					},

					removeListener : function(el, type, listener) {
						$(el).unbind(type, listener);
					},

					getTouchEvent : function(event) {
						return event.originalEvent || event;
					}
				}
			});

})(window, Pda.ps.Util);
// 工具类动画的扩展
(function(window, Util) {
	Util.extend(Util, {
		Animation : {
			fadeIn : function(el, opacity, duration, callback) {
				opacity = Util.coalesce(opacity, 1);
				duration = Util.coalesce(duration, 500);
				$(el).animate({
							opacity : opacity
						}, duration, 'linear', callback);
			},

			fadeOut : function(el, duration, callback) {
				if (Util.isNothing(duration)) {
					duration = 500;
				}
				$(el).animate({
							opacity : 0
						}, duration, 'linear', callback);
			},
			slideBy : function(el, xPos, yPos, duration, callback) {
				if (Util.isNothing(duration)) {
					duration = 500;
				}
				var animateProps, pos = $(el).position(), left = pos.left, top = pos.top;
				animateProps = {
					left : left + xPos + 'px',
					top : '+=' + yPos + 'px'
				};
				$(el).animate(animateProps, duration, 'ease', callback);
			}
		}
	});

})(window, Pda.ps.Util);
// 事件对象
(function() {
	Pda.ps.EventClass = SimpleClass.extend({
				_listeners : null,
				init : function() {
					this._listeners = {};
				},
				addListener : function(type, listener) {
					if (typeof this._listeners[type] === 'undefined') {
						this._listeners[type] = [];
					}
					this._listeners[type].push(listener);
				},
				dispatchEvent : function(event) {
					if (typeof event == "string") {
						event = {
							type : event
						};
					}
					if (!event.target) {
						event.target = this;
					}
					if (this._listeners[event.type] instanceof Array) {
						var listeners = this._listeners[event.type];
						for (var i = 0, len = listeners.length; i < len; i++) {
							listeners[i].call(this, event);
						}
					}
				},
				removeListener : function(type, listener) {
					if (this._listeners[type] instanceof Array) {
						var listeners = this._listeners[type];
						for (var i = 0, len = listeners.length; i < len; i++) {
							if (listeners[i] === listener) {
								listeners.splice(i, 1);
								break;
							}
						}
					}
				}
			});
})();
// 元素，继承事件对象
(function(window, Util) {
	Pda.ps.ElementClass = Pda.ps.EventClass.extend({
				el : null,
				settings : null,
				isHidden : null,
				fadeInHandler : null,
				fadeOutHandler : null,
				init : function(options) {
					this._super();
					this.settings = {
						opacity : 1,
						fadeInSpeed : 250,
						fadeOutSpeed : 500
					};
					Util.extend(this.settings, options);
					this.fadeInHandler = this.postFadeIn.bind(this);
					this.fadeOutHandler = this.postFadeOut.bind(this);
					this.isHidden = true;
				},

				resetPosition : function() {
				},

				show : function() {
					Util.DOM
							.setStyle(this.el, 'opacity', this.settings.opacity);
					Util.DOM.show(this.el);
					this.postShow();
				},

				postShow : function() {
					this.isHidden = false;
					this.addListeners();
					this.dispatchEvent(Pda.ps.ElementClass.EventTypes.onShow);
				},

				fadeIn : function() {
					Util.DOM.setStyle(this.el, 'opacity', 0);
					this.fadeInFromCurrentOpacity();
				},

				fadeInFromCurrentOpacity : function() {
					this.isHidden = false;
					Util.DOM.show(this.el);
					Util.Animation.fadeIn(this.el, this.settings.opacity,
							this.settings.fadeInSpeed, this.fadeInHandler);
				},

				postFadeIn : function(e) {
					if (this.isHidden) {
						return;
					}
					this.addListeners();
					this.dispatchEvent(Pda.ps.ElementClass.EventTypes.onFadeIn);

				},

				hide : function() {
					Util.DOM.hide(this.el);
					this.postHide();
				},

				postHide : function() {
					this.isHidden = true;
					this.removeListeners();
					this.dispatchEvent(Pda.ps.ElementClass.EventTypes.onHide);

				},

				fadeOut : function() {
					this.isHidden = true;
					Util.Animation.fadeOut(this.el, this.settings.fadeOutSpeed,
							this.fadeOutHandler);
				},

				postFadeOut : function(e) {
					if (!this.isHidden) {
						return;
					}
					Util.DOM.hide(this.el);
					this.removeListeners();
					this
							.dispatchEvent(Pda.ps.ElementClass.EventTypes.onFadeOut);
				},

				addListeners : function() {
				},

				removeListeners : function() {
				}

			});

	Pda.ps.ElementClass.EventTypes = {
		onShow : 'onShow',
		onHide : 'onHide',
		onClick : 'onClick',
		onFadeIn : 'onFadeIn',
		onFadeOut : 'onFadeOut'
	};

})(window, Pda.ps.Util);

(function(window, Util) {
	Pda.ps.FullSizeImageClass = Pda.ps.EventClass.extend({
				el : null,
				index : null,
				naturalWidth : null,
				naturalHeight : null,
				src : null,
				caption : null,
				metaData : null,
				scaleMethod : null,
				isLandscape : null,
				isLoading : null,
				hasLoaded : null,
				loadEventHandler : null,
				init : function(index, scaleMethod, src, caption, metaData) {
					this._super();
					this.index = index;
					this.naturalWidth = 0;
					this.naturalHeight = 0;
					this.src = src;
					this.caption = caption;
					this.metaData = Util.coalesce(metaData, {});
					this.isLandscape = false;
					this.isLoading = false;
					this.hasLoaded = false;
					this.scaleMethod = scaleMethod;
					this.loadEventHandler = this.onLoad.bind(this);
				},

				load : function() {
					this.isLoading = true;
					this.el = new Image();
					Util.DOM.addClass(this.el, 'ps-full-size-image');
					this.el.onload = this.loadEventHandler;
					this.el.src = this.src;
				},
				onLoad : function() {
					this.naturalWidth = Util.coalesce(this.el.naturalWidth,
							this.el.width);
					this.naturalHeight = Util.coalesce(this.el.naturalHeight,
							this.el.height);
					this.isLandscape = (this.naturalWidth > this.naturalHeight);
					this.isLoading = false;
					this.hasLoaded = true;
					this
							.dispatchEvent(Pda.ps.FullSizeImageClass.EventTypes.onLoad);

				}

			});

	Pda.ps.FullSizeImageClass.EventTypes = {
		onLoad : 'onLoad'
	};

})(window, Pda.ps.Util);
// 遮罩层
(function(window, Util) {

	Pda.ps.DocumentOverlayClass = Pda.ps.ElementClass.extend({
		init : function(options) {
			this.settings = {
				zIndex : 1000
			};
			Util.extend(this.settings, options);
			this._super(options);
			this.el = Util.DOM.createElement('div', {
				'class' : Pda.ps.DocumentOverlayClass.CssClasses.documentOverlay
			}, '');
			Util.DOM.setStyle(this.el, {
						left : 0,
						position : 'absolute',
						zIndex : this.settings.zIndex,
						top : 0
					});
			Util.DOM.hide(this.el);
			Util.DOM.appendToBody(this.el);
		},
		resetPosition : function() {
			Util.DOM.width(this.el, Util.DOM.bodyWidth());
			Util.DOM.height(this.el, Util.DOM.bodyHeight());
		}
	});

	Pda.ps.DocumentOverlayClass.CssClasses = {
		documentOverlay : 'ps-document-overlay'
	};

})(window, Pda.ps.Util);
// 最外层容器--相关滑动事件等
(function(window, Util) {
	Pda.ps.ViewportClass = Pda.ps.ElementClass.extend({
		touchStartPoint : null,
		touchStartTime : null,
		touchStartHandler : null,
		touchMoveHandler : null,
		touchEndHandler : null,
		isGesture : null,
		init : function(options) {
			this.settings = {
				swipeThreshold : 500,
				swipeTimeThreshold : 250,
				zIndex : 1000
			};
			Util.extend(this.settings, options);
			this._super(this.settings);
			this.touchStartPoint = {
				x : 0,
				y : 0
			};

			this.touchStartHandler = this.onTouchStart.bind(this);
			this.touchMoveHandler = this.onTouchMove.bind(this);
			this.touchEndHandler = this.onTouchEnd.bind(this);

			this.el = Util.DOM.createElement('div', {
						'class' : Pda.ps.ViewportClass.CssClasses.viewport,
						'data-role' : 'dialog'
					}, '');
			Util.DOM.setStyle(this.el, {
						position : 'absolute',
						left : 0,
						zIndex : this.settings.zIndex,
						overflow : 'hidden'
					});
			Util.DOM.hide(this.el);
			Util.DOM.appendToBody(this.el);
		},
		resetPosition : function() {
			Util.DOM.setStyle(this.el, {
						top : Util.DOM.windowScrollTop() + 'px'
					});
			Util.DOM.width(this.el, Util.DOM.bodyWidth());
			Util.DOM.height(this.el, Util.DOM.windowHeight());
		},

		addListeners : function() {
			Util.DOM.addListener(this.el, 'touchstart', this.touchStartHandler);
			Util.DOM.addListener(this.el, 'touchmove', this.touchMoveHandler);
			Util.DOM.addListener(this.el, 'touchend', this.touchEndHandler);
		},

		removeListeners : function() {
			Util.DOM.removeListener(this.el, 'touchstart',
					this.touchStartHandler);
			Util.DOM
					.removeListener(this.el, 'touchmove', this.touchMoveHandler);
			Util.DOM.removeListener(this.el, 'touchend', this.touchEndHandler);
		},

		getTouchPoint : function(touches) {
			return {
				x : touches[0].pageX,
				y : touches[0].pageY
			};
		},

		onTouchStart : function(e) {
			e.preventDefault();
			var touchEvent = Util.DOM.getTouchEvent(e), touches = touchEvent.touches;
			if (touches.length > 1) {
				this.isGesture = true;
				return;
			}
			this.dispatchEvent({
						type : Pda.ps.ViewportClass.EventTypes.onTouch,
						target : this,
						action : Pda.ps.ViewportClass.Actions.touchStart,
						point : this.getTouchPoint(touches)
					});
			this.touchStartTime = new Date();
			this.isGesture = false;
			this.touchStartPoint = this.getTouchPoint(touches);
		},
		onTouchMove : function(e) {
			e.preventDefault();
			if (this.isGesture) {
				return;
			}
			var touchEvent = Util.DOM.getTouchEvent(e), touches = touchEvent.touches;
			this.dispatchEvent({
						type : Pda.ps.ViewportClass.EventTypes.onTouch,
						target : this,
						action : Pda.ps.ViewportClass.Actions.touchMove,
						point : this.getTouchPoint(touches)
					});
		},

		onTouchEnd : function(e) {
			e.preventDefault();
			if (this.isGesture) {
				return;
			}
			var touchEvent = Util.DOM.getTouchEvent(e), touches = (!Util
					.isNothing(touchEvent.changedTouches))
					? touchEvent.changedTouches
					: touchEvent.touches, touchEndPoint = this
					.getTouchPoint(touches);
			this.dispatchEvent({
						type : Pda.ps.ViewportClass.EventTypes.onTouch,
						target : this,
						action : Pda.ps.ViewportClass.Actions.touchEnd,
						point : touchEndPoint
					});
			this.fireTouchEvent(this.touchStartPoint, touchEndPoint);
		},
		fireTouchEvent : function(touchStartPoint, touchEndPoint) {
			var action;
			var endTime = new Date(), diffTime = endTime - this.touchStartTime;

			if (diffTime > this.settings.swipeTimeThreshold) {
				return;
			}
			var distance = touchEndPoint.x - touchStartPoint.x;
			if (Math.abs(distance) >= this.settings.swipeThreshold) {
				if (distance < 0) {
					action = Pda.ps.ViewportClass.Actions.swipeLeft;
				} else {
					action = Pda.ps.ViewportClass.Actions.swipeRight;
				}
			} else {
				action = Pda.ps.ViewportClass.Actions.click;
			}
			if (Util.isNothing(action)) {
				return;
			}
			this.dispatchEvent({
						type : Pda.ps.ViewportClass.EventTypes.onTouch,
						target : this,
						action : action
					});
		}

	});

	Pda.ps.ViewportClass.CssClasses = {
		viewport : 'ps-viewport'
	};

	Pda.ps.ViewportClass.Actions = {
		click : 'click',
		swipeLeft : 'swipeLeft',
		swipeRight : 'swipeRight',
		touchStart : 'touchStart',
		touchMove : 'touchMove',
		touchEnd : 'touchEnd'
	};

	Pda.ps.ViewportClass.EventTypes = {
		onTouch : 'onTouch'
	};

})(window, Pda.ps.Util);
// ps-slider-item --可获取图片，视屏对象等
(function(window, Util, FullSizeImageClass) {
	Pda.ps.SliderItemClass = Pda.ps.EventClass.extend({
		el : null,
		imageContainerEl : null,
		imageEl : null,
		parentEl : null,
		fullSizeImage : null,
		fullSizeImageLoadEventHandler : null,
		savedImageWidth : null,
		savedImageHeight : null,
		init : function(parentEl) {
			this._super();
			this.parentEl = parentEl;
			this.fullSizeImageLoadEventHandler = this.onFullSizeImageLoad
					.bind(this);
			this.el = Util.DOM.createElement('div', {
						'class' : Pda.ps.SliderItemClass.CssClasses.item + ' '
								+ Pda.ps.SliderItemClass.CssClasses.loading
					}, '');
			Util.DOM.setStyle(this.el, {
						position : 'absolute',
						overflow : 'hidden',
						top : 0
					});
			Util.DOM.resetTranslate(this.el);
			Util.DOM.appendChild(this.el, this.parentEl);
			this.imageContainerEl = Util.DOM.createElement('div', 'aa');
			Util.DOM.setStyle(this.imageContainerEl, {
						position : 'absolute',
						overflow : 'hidden',
						top : 0,
						left : 0
					});
			Util.DOM.appendChild(this.imageContainerEl, this.el);
			this.imageEl = new Image();
			Util.DOM.setStyle(this.imageEl, {
						display : 'block',
						position : 'absolute',
						margin : 0,
						padding : 0
					});

			Util.DOM.hide(this.imageEl);
			Util.DOM.appendChild(this.imageEl, this.imageContainerEl);
		},

		resetPosition : function(width, height, xPos) {
			Util.DOM.width(this.el, width);
			Util.DOM.height(this.el, height);
			Util.DOM.setStyle(this.el, 'left', xPos + 'px');
			Util.DOM.width(this.imageContainerEl, width);
			Util.DOM.height(this.imageContainerEl, height);
			this.resetImagePosition();
		},

		resetImagePosition : function() {
			if (Util.isNothing(this.fullSizeImage)) {
				return;
			}
			var src = Util.DOM.getAttribute(this.imageEl, 'src');
			var scale, newWidth, newHeight, newTop, newLeft, maxWidth = Util.DOM
					.width(this.el), maxHeight = Util.DOM.height(this.el);
			if (this.fullSizeImage.isLandscape) {
				scale = maxWidth / this.fullSizeImage.naturalWidth;
			} else {
				scale = maxHeight / this.fullSizeImage.naturalHeight;
			}
			newWidth = Math.round(this.fullSizeImage.naturalWidth * scale);
			newHeight = Math.round(this.fullSizeImage.naturalHeight * scale);
			if (this.fullSizeImage.scaleMethod === 'fit') {
				scale = 1;
				if (newWidth > maxWidth) {
					scale = maxWidth / newWidth;
				} else if (newHeight > maxHeight) {
					scale = maxHeight / newHeight;
				}
				if (scale !== 1) {
					newWidth = Math.round(newWidth * scale);
					newHeight = Math.round(newHeight * scale);
				}
			}
			newTop = ((maxHeight - newHeight) / 2) + 'px';
			newLeft = ((maxWidth - newWidth) / 2) + 'px';
			Util.DOM.width(this.imageEl, newWidth);
			Util.DOM.height(this.imageEl, newHeight);
			Util.DOM.setStyle(this.imageEl, {
						top : newTop,
						left : newLeft
					});
			Util.DOM.show(this.imageEl);
			this.savedImageWidth = newWidth;
			this.savedImageHeight = newHeight;
		},

		setFullSizeImage : function(fullSizeImage) {

			this.fullSizeImage = fullSizeImage;

			Util.DOM.removeClass(this.el,
					Pda.ps.SliderItemClass.CssClasses.loading);
			Util.DOM.removeClass(this.el,
					Pda.ps.SliderItemClass.CssClasses.imageError);

			// Something is wrong!
			if (Util.isNothing(this.fullSizeImage)) {
				this.fullSizeImage = null;
				Util.DOM.addClass(this.el,
						Pda.ps.SliderItemClass.CssClasses.imageError);
				this.hideImage();
				return;
			}

			// Still loading
			if (!this.fullSizeImage.hasLoaded) {

				Util.DOM.addClass(this.el,
						Pda.ps.SliderItemClass.CssClasses.loading);
				this.hideImage();
				if (!this.fullSizeImage.isLoading) {
					// Trigger off the load
					this.fullSizeImage.addListener(
							FullSizeImageClass.EventTypes.onLoad,
							this.fullSizeImageLoadEventHandler);
					this.fullSizeImage.load();
				}
				return;
			}
			// Loaded so show the image
			Util.DOM.setAttribute(this.imageEl, 'src', this.fullSizeImage.src);
			this.resetImagePosition();
			this
					.dispatchEvent(Pda.ps.SliderItemClass.EventTypes.onFullSizeImageDisplay);

		},

		onFullSizeImageLoad : function(e) {

			e.target.removeListener(FullSizeImageClass.EventTypes.onLoad,
					this.fullSizeImageLoadEventHandler);

			if (Util.isNothing(this.fullSizeImage)
					|| e.target.index !== this.fullSizeImage.index) {
				this.dispatchEvent({
					type : Pda.ps.SliderItemClass.EventTypes.onFullSizeImageLoadAnomaly,
					target : this,
					fullSizeImage : e.target
				});
			} else {
				this.setFullSizeImage(e.target);
			}

		},

		hideImage : function() {
			Util.DOM.removeAttribute(this.imageEl, 'src');
			Util.DOM.hide(this.imageEl);

		}

	});

	Pda.ps.SliderItemClass.CssClasses = {
		item : 'ps-slider-item',
		loading : 'ps-slider-item-loading',
		imageError : 'ps-slider-item-image-error'
	};

	Pda.ps.SliderItemClass.EventTypes = {
		onFullSizeImageDisplay : 'onFullSizeImageDisplay',
		onFullSizeImageLoadAnomaly : 'onFullSizeImageLoadAnomaly'
	};

})(window, Pda.ps.Util, Pda.ps.FullSizeImageClass);
// ps-slider
(function(window, Util, SliderItemClass) {
	Pda.ps.SliderClass = Pda.ps.ElementClass.extend({
		parentEl : null,
		parentElWidth : null,
		parentElHeight : null,
		items : null,
		scaleEl : null,
		lastScaleValue : null,
		previousItem : null,
		currentItem : null,
		nextItem : null,
		hasBounced : null,
		lastShowAction : null,
		bounceSlideBy : null,
		showNextEndEventHandler : null,
		showPreviousEndEventHandler : null,
		bounceStepOneEventHandler : null,
		bounceStepTwoEventHandler : null,
		sliderHandler : null,
		init : function(options, parentEl) {
			this.settings = {
				slideSpeed : 250
			};
			Util.extend(this.settings, options);
			this._super(this.settings);
			this.parentEl = parentEl;
			this.hasBounced = false;
			this.showNextEndEventHandler = this.onShowNextEnd.bind(this);
			this.showPreviousEndEventHandler = this.onShowPreviousEnd
					.bind(this);
			this.bounceStepOneEventHandler = this.onBounceStepOne.bind(this);
			this.bounceStepTwoEventHandler = this.onBounceStepTwo.bind(this);
			this.sliderHandler = this.onSliderFullSizeImageLoadAnomaly
					.bind(this);
			this.el = Util.DOM.createElement('div', {
						'class' : "ps-slider"
					}, '');
			Util.DOM.setStyle(this.el, {
						position : 'absolute',
						top : 0
					});
			Util.DOM.hide(this.el);
			Util.DOM.appendChild(this.el, parentEl);
			this.items = [];
			this.items.push(new SliderItemClass(this.el));
			this.items.push(new SliderItemClass(this.el));
			this.items.push(new SliderItemClass(this.el));
			this.previousItem = this.items[0];
			this.currentItem = this.items[1];
			this.nextItem = this.items[2];
		},
		addListeners : function() {
			for (var i = 0; i < this.items.length; i++) {
				var item = this.items[i];
				item.addListener(
						SliderItemClass.EventTypes.onFullSizeImageLoadAnomaly,
						this.sliderHandler);
			}
		},

		removeListeners : function() {
			for (var i = 0; i < this.items.length; i++) {
				var item = this.items[i];
				item.removeListener(
						SliderItemClass.EventTypes.onFullSizeImageLoadAnomaly,
						this.sliderHandler);
			}
		},

		resetPosition : function() {
			Util.DOM.show(this.currentItem.imageContainerEl);
			this.parentElWidth = Util.DOM.width(this.parentEl);
			this.parentElHeight = Util.DOM.height(this.parentEl);
			Util.DOM.width(this.el, this.parentElWidth * 3);
			Util.DOM.height(this.el, this.parentElHeight);
			this.previousItem.resetPosition(this.parentElWidth,
					this.parentElHeight, 0);
			this.currentItem.resetPosition(this.parentElWidth,
					this.parentElHeight, this.parentElWidth);
			this.nextItem.resetPosition(this.parentElWidth,
					this.parentElHeight, this.parentElWidth * 2);
			this.center();

		},
		center : function() {
			Util.DOM.resetTranslate(this.el);
			Util.DOM.setStyle(this.el, {
						left : (this.parentElWidth * -1) + 'px'
					});
		},

		setCurrentFullSizeImage : function(currentFullSizeImage) {
			this.currentItem.setFullSizeImage(currentFullSizeImage);
			this.dispatchDisplayCurrentFullSizeImage();
		},

		setPreviousAndNextFullSizeImages : function(previousFullSizeImage,
				nextFullSizeImage) {
			this.nextItem.setFullSizeImage(nextFullSizeImage);
			this.previousItem.setFullSizeImage(previousFullSizeImage);
		},

		onBounceStepOne : function(e) {
			Util.Animation
					.slideBy(
							this.el,
							(this.lastShowAction === Pda.ps.SliderClass.ShowActionTypes.previous)
									? this.bounceSlideBy * -1
									: this.bounceSlideBy, 0,
							this.settings.slideSpeed,
							this.bounceStepTwoEventHandler);
		},

		onBounceStepTwo : function(e) {
			this.dispatchDisplayCurrentFullSizeImage();
		},

		onShowNextEnd : function() {
			Util.DOM.show(this.currentItem.imageContainerEl);
			Util.swapArrayElements(this.items, 1, 2);
			this.currentItem = this.items[1];
			this.nextItem = this.items[2];
			var parentElWidth = this.parentElWidth;
			Util.DOM
					.setStyle(this.currentItem.el, 'left', parentElWidth + 'px');
			Util.DOM.setStyle(this.nextItem.el, 'left', (parentElWidth * 2)
							+ 'px');
			this.center();
			this.dispatchDisplayCurrentFullSizeImage();
		},

		onShowPreviousEnd : function() {
			Util.DOM.show(this.currentItem.imageContainerEl);
			Util.swapArrayElements(this.items, 1, 0);
			this.currentItem = this.items[1];
			this.previousItem = this.items[0];
			Util.DOM.setStyle(this.currentItem.el, 'left', this.parentElWidth
							+ 'px');
			Util.DOM.setStyle(this.previousItem.el, 'left', '0px');
			this.center();
			this.dispatchDisplayCurrentFullSizeImage();
		},

		onSliderFullSizeImageLoadAnomaly : function(e) {
			var fullSizeImage = e.fullSizeImage;
			if (!Util.isNothing(this.currentItem.fullSizeImage)) {
				if (this.currentItem.fullSizeImage.index === fullSizeImage.index) {
					this.currentItem.setFullSizeImage(fullSizeImage);
					this.dispatchDisplayCurrentFullSizeImage();
					return;
				}
			}

			if (!Util.isNothing(this.nextItem.fullSizeImage)) {
				if (this.nextItem.fullSizeImage.index === fullSizeImage.index) {
					this.nextItem.setFullSizeImage(fullSizeImage);
					return;
				}
			}
			if (!Util.isNothing(this.previousItem.fullSizeImage)) {
				if (this.previousItem.fullSizeImage.index === fullSizeImage.index) {
					this.previousItem.setFullSizeImage(fullSizeImage);
					return;
				}
			}
		},

		// -----供外调用开始-----
		showNext : function() {
			this.lastShowAction = Pda.ps.SliderClass.ShowActionTypes.next;
			this.hasBounced = false;
			if (Util.isNothing(this.nextItem.fullSizeImage)) {
				this.bounce();
				return;
			}
			var slideBy = this.parentElWidth * -1;
			Util.Animation.slideBy(this.el, slideBy, 0,
					this.settings.slideSpeed, this.showNextEndEventHandler);
		},
		showPrevious : function() {
			this.lastShowAction = Pda.ps.SliderClass.ShowActionTypes.previous;
			this.hasBounced = false;
			if (Util.isNothing(this.previousItem.fullSizeImage)) {
				this.bounce();
				return;
			}
			var slideBy = this.parentElWidth;
			Util.Animation.slideBy(this.el, slideBy, 0,
					this.settings.slideSpeed, this.showPreviousEndEventHandler);
		},
		bounce : function() {
			Util.DOM.show(this.currentItem.imageContainerEl);
			this.hasBounced = true;
			this.bounceSlideBy = this.parentElWidth / 2;
			Util.Animation
					.slideBy(
							this.el,
							(this.lastShowAction === Pda.ps.SliderClass.ShowActionTypes.previous)
									? this.bounceSlideBy
									: this.bounceSlideBy * -1, 0,
							this.settings.slideSpeed,
							this.bounceStepOneEventHandler);
		},
		// -----供外调用结束-----

		dispatchDisplayCurrentFullSizeImage : function() {
			this.dispatchEvent({
						type : Pda.ps.SliderClass.EventTypes.onFullImageHandler,
						target : this,
						fullSizeImage : this.currentItem.fullSizeImage
					});
		}
	});

	Pda.ps.SliderClass.ShowActionTypes = {
		next : 'next',
		previous : 'previous'
	};

	Pda.ps.SliderClass.EventTypes = {
		onFullImageHandler : 'onFullImageHandler'
	};

})(window, Pda.ps.Util, Pda.ps.SliderItemClass);
// 标题
(function(window, Util) {
	Pda.ps.CaptionClass = Pda.ps.ElementClass.extend({
		contentEl : null,
		touchMoveHandler : null,
		captionValue : null,
		init : function(options) {
			this.settings = {
				position : 'top',
				zIndex : 1000
			};
			Util.extend(this.settings, options);
			this._super(this.settings);
			this.captionValue = '';
			this.touchMoveHandler = this.onTouchMove.bind(this);
			var cssClass = "ps-caption";
			if (this.settings.position === 'bottom') {
				cssClass = cssClass + ' ' + "ps-caption-bottom";
			}
			this.el = Util.DOM.createElement('div', {
						'class' : cssClass
					}, '');
			Util.DOM.setStyle(this.el, {
						left : 0,
						position : 'absolute',
						overflow : 'hidden',
						zIndex : this.settings.zIndex,
						opacity : 0
					});
			Util.DOM.hide(this.el);
			Util.DOM.appendToBody(this.el);
			this.contentEl = Util.DOM.createElement('div', {
						'class' : "ps-caption-content"
					}, '');
			Util.DOM.appendChild(this.contentEl, this.el);
		},

		addListeners : function() {
			Util.DOM.addListener(this.el, 'touchmove', this.touchMoveHandler);
		},
		removeListeners : function() {
			Util.DOM
					.removeListener(this.el, 'touchmove', this.touchMoveHandler);
		},
		onTouchMove : function(e) {
			e.preventDefault();
		},

		resetPosition : function() {
			var top;
			if (this.settings.position === 'bottom') {
				top = Util.DOM.windowHeight() - Util.DOM.height(this.el)
						+ Util.DOM.windowScrollTop();
			} else {
				top = Util.DOM.windowScrollTop();
			}
			Util.DOM.setStyle(this.el, 'top', top + 'px');
			Util.DOM.width(this.el, Util.DOM.bodyWidth());
		},

		setCaptionValue : function(captionValue) {
			Util.DOM.removeChildren(this.contentEl);
			captionValue = Util.coalesce(captionValue, '\u00A0');
			if (Util.isObject(captionValue)) {
				Util.DOM.appendChild(captionValue, this.contentEl);
			} else {
				if (captionValue === '') {
					captionValue = '\u00A0';
				}
				$(this.contentEl).text(captionValue);
			}
			this.captionValue = (captionValue === '\u00A0') ? '' : captionValue;
		}
	});

})(window, Pda.ps.Util);
// 工具栏
(function(window, Util) {
	Pda.ps.ToolbarClass = Pda.ps.ElementClass.extend({
		closeEl : null,
		previousEl : null,
		nextEl : null,
		playEl : null,
		clickHandler : null,
		touchStartHandler : null,
		touchMoveHandler : null,
		touched : null,
		isNextActive : null,
		isPreviousActive : null,
		attId : null,
		init : function(options) {
			this.settings = {
				position : 'bottom',
				hideClose : false,
				zIndex : 1000
			};
			Util.extend(this.settings, options);
			this._super(this.settings);
			this.isNextActive = true;
			this.isPreviousActive = true;
			this.touched = false;
			this.clickHandler = this.onClick.bind(this);
			this.touchMoveHandler = this.onTouchMove.bind(this);
			this.touchStartHandler = this.onTouchStart.bind(this);
			var cssClass = Pda.ps.ToolbarClass.CssClasses.caption;
			if (this.settings.position === 'top') {
				cssClass = cssClass + ' ' + Pda.ps.ToolbarClass.CssClasses.top;
			}
			this.el = Util.DOM.createElement('div', {
						'class' : cssClass
					}, '');
			Util.DOM.setStyle(this.el, {
						left : 0,
						position : 'absolute',
						overflow : 'hidden',
						zIndex : this.settings.zIndex,
						display : 'table',
						opacity : 0
					});
			Util.DOM.hide(this.el);
			Util.DOM.appendToBody(this.el);
			this.closeEl = Util.DOM.createElement('div', {
						'class' : Pda.ps.ToolbarClass.CssClasses.close
					}, '<div class="' + Pda.ps.ToolbarClass.CssClasses.content
							+ '"></div>');

			if (this.settings.hideClose) {
				Util.DOM.hide(this.closeEl);
			}
			Util.DOM.appendChild(this.closeEl, this.el);
			this.playEl = Util.DOM.createElement('div', {
						'class' : Pda.ps.ToolbarClass.CssClasses.play
					}, '<div class="' + Pda.ps.ToolbarClass.CssClasses.content
							+ '"></div>');
			Util.DOM.appendChild(this.playEl, this.el);
		},

		postFadeIn : function(e) {
			if (this.isHidden) {
				return;
			}
			Util.DOM.setStyle(this.el, {
						display : 'table'
					});
			this._super(this.settings);
		},
		addListeners : function() {
			Util.DOM.addListener(this.el, 'touchmove', this.touchMoveHandler);
			Util.DOM.addListener(this.el, 'click', this.clickHandler);
		},

		removeListeners : function() {
			Util.DOM
					.removeListener(this.el, 'touchmove', this.touchMoveHandler);
			Util.DOM.removeListener(this.el, 'click', this.clickHandler);
		},
		onTouchStart : function(e) {
			e.preventDefault();
			this.touched = true;
			this.handleClick(e);
		},
		onTouchMove : function(e) {
			e.preventDefault();
		},
		onClick : function(e) {
			if (this.touched) {
				return;
			}
			this.handleClick(e);
		},
		handleClick : function(e) {
			var action;
			switch (e.target.parentNode) {
				case this.playEl :
					action = Pda.ps.ToolbarClass.Actions.play;
					break;
				case this.closeEl :
					action = Pda.ps.ToolbarClass.Actions.close;
					break;
			}
			if (Util.isNothing(action)) {
				return;
			}
			this.dispatchEvent({
						type : Pda.ps.ToolbarClass.EventTypes.onClick,
						target : this,
						action : action
					});
		},
		resetPosition : function() {
			var top;
			if (this.settings.position === 'bottom') {
				top = Util.DOM.windowHeight() - Util.DOM.height(this.el)
						+ Util.DOM.windowScrollTop();
			} else {
				top = Util.DOM.windowScrollTop();
			}
			Util.DOM.setStyle(this.el, 'top', top + 'px');
			Util.DOM.width(this.el, Util.DOM.bodyWidth());
		},
		setNextState : function(disable) {
			if (disable) {
				Util.DOM.addClass(this.nextEl,
						Pda.ps.ToolbarClass.CssClasses.nextDisabled);
				this.isNextActive = false;
			} else {
				Util.DOM.removeClass(this.nextEl,
						Pda.ps.ToolbarClass.CssClasses.nextDisabled);
				this.isNextActive = true;
			}
		},
		setPreviousState : function(disable) {
			if (disable) {
				Util.DOM.addClass(this.previousEl,
						Pda.ps.ToolbarClass.CssClasses.previousDisabled);
				this.isPreviousActive = false;
			} else {
				Util.DOM.removeClass(this.previousEl,
						Pda.ps.ToolbarClass.CssClasses.previousDisabled);
				this.isPreviousActive = true;
			}
		},
		setPlayValue : function(id) {
			this.attId = id;
		}
	});
	Pda.ps.ToolbarClass.CssClasses = {
		caption : 'ps-toolbar',
		top : 'ps-toolbar-top',
		close : 'ps-toolbar-close',
		previousDisabled : 'ps-toolbar-previous-disabled',
		nextDisabled : 'ps-toolbar-next-disabled',
		play : 'ps-toolbar-play',
		content : 'ps-toolbar-content'
	};

	Pda.ps.ToolbarClass.Actions = {
		close : 'close',
		play : 'play'
	};
	Pda.ps.ToolbarClass.EventTypes = {
		onClick : 'onClick'
	};

})(window, Pda.ps.Util);
// 工具栏和标题
(function(window, Util, CaptionClass, ToolbarClass) {
	Pda.ps.CaptionToolbarClass = Pda.ps.EventClass.extend({
				toolbar : null,
				caption : null,
				isHidden : null,
				hasAddedEventListeners : null,
				toolbarClickEventHandler : null,
				init : function(options) {
					this._super();
					this.settings = {
						opacity : 0.8,
						fadeInSpeed : 250,
						fadeOutSpeed : 500,
						autoHideDelay : 5000,
						hideClose : false,
						zIndex : 1000
					};
					Util.extend(this.settings, options);
					this.isHidden = true;
					this.hasAddedEventListeners = false;
					this.toolbarClickEventHandler = this.onToolbarClick
							.bind(this);
					this.caption = new CaptionClass({
								fadeInSpeed : this.settings.fadeInSpeed,
								fadeOutSpeed : this.settings.fadeOutSpeed,
								opacity : this.settings.opacity,
								position : 'top',
								zIndex : this.settings.zIndex
							});
					this.toolbar = new ToolbarClass({
								fadeInSpeed : this.settings.fadeInSpeed,
								fadeOutSpeed : this.settings.fadeOutSpeed,
								opacity : this.settings.opacity,
								position : 'bottom',
								hideClose : this.settings.hideClose,
								zIndex : this.settings.zIndex + 1
							});
				},

				resetPosition : function() {
					this.caption.resetPosition();
					this.toolbar.resetPosition();
				},

				addListeners : function() {
					if (this.hasAddedEventListeners) {
						return;
					}
					this.toolbar.addListener(ToolbarClass.EventTypes.onClick,
							this.toolbarClickEventHandler);
					this.hasAddedEventListeners = true;
				},

				removeListeners : function() {
					this.toolbar.removeListener(
							ToolbarClass.EventTypes.onClick,
							this.toolbarClickEventHandler);
					this.hasAddedEventListeners = false;
				},

				fadeIn : function() {
					this.stopAutoHideTimeout();
					if (this.isHidden) {
						this.isHidden = false;
						this.fadeInCaption();
						this.toolbar.fadeIn();
						window.setTimeout(this.onFadeIn.bind(this),
								this.settings.fadeInSpeed);
					} else {
						// Not hidden, just check caption is visible
						if (this.caption.isHidden) {
							this.fadeInCaption();
						}
						// Reset the autoHideTimeout
						this.resetAutoHideTimeout();
					}
				},

				showCaption : function() {
					if (this.caption.captionValue === '') {
						this.caption.show();

					} else {
						this.caption.show();
					}
				},

				fadeInCaption : function() {
					if (this.caption.captionValue === '') {
						this.caption.fadeIn();
					} else {
						this.caption.fadeIn();
					}
				},

				onFadeIn : function() {
					this.addListeners();
					this.resetAutoHideTimeout();
				},

				fadeOut : function() {
					this.stopAutoHideTimeout();
					this.isHidden = true;
					this.caption.fadeOut();
					this.toolbar.fadeOut();
					window.setTimeout(this.onFadeOut.bind(this),
							this.settings.fadeOutSpeed);

				},

				onFadeOut : function() {
				},

				hide : function() {
					this.stopAutoHideTimeout();
					this.isHidden = true;
					this.removeListeners();
					this.caption.hide();
					this.toolbar.hide();
				},

				setCaptionValue : function(captionValue) {
					this.caption.setCaptionValue(captionValue);
					if (this.caption.captionValue === '') {
						this.caption.fadeOut();
					}
				},

				// 设置对应附件的id，用于下载播放使用
				setPlayValue : function(id) {
					this.toolbar.setPlayValue(id);
				},

				resetAutoHideTimeout : function() {
					if (this.isHidden) {
						return;
					}
					this.stopAutoHideTimeout();
					if (this.settings.autoHideDelay > 0) {
						this.autoHideTimeout = window.setTimeout(this.fadeOut
										.bind(this),
								this.settings.autoHideDelay);
					}
				},

				stopAutoHideTimeout : function() {
					if (!Util.isNothing(this.autoHideTimeout)) {
						window.clearTimeout(this.autoHideTimeout);
					}
				},

				onToolbarClick : function(e) {
					this.dispatchEvent({
								type : Pda.ps.ToolbarClass.EventTypes.onClick,
								target : this,
								action : e.action
							});
				},

				setNextState : function(disable) {
					this.toolbar.setNextState(disable);
				},

				setPreviousState : function(disable) {
					this.toolbar.setPreviousState(disable);
				}

			});

})(window, Pda.ps.Util, Pda.ps.CaptionClass, Pda.ps.ToolbarClass);
(function(window, Util, ElementClass, DocumentOverlayClass, FullSizeImageClass,
		ViewportClass, SliderClass, CaptionClass, ToolbarClass,
		CaptionToolbarClass) {
	var photoSwipe = Pda.ps.EventClass.extend({
		fullSizeImages : null,
		documentOverlay : null,
		viewport : null,
		slider : null,
		captionAndToolbar : null,
		zoomPanRotate : null,
		settings : null,
		currentIndex : null,
		isBusy : null,
		isActive : null,
		slideshowTimeout : null,
		isSlideshowActive : null,
		lastShowPrevTrigger : null,
		viewportFadeInEventHandler : null,
		windowOrientationChangeEventHandler : null,
		windowScrollEventHandler : null,
		viewportTouchEventHandler : null,
		viewportFadeOutEventHandler : null,
		fullImageHandler : null,
		toolbarClickEventHandler : null,
		orientationEventName : null,
		init : function() {
			this._super();
			this.currentIndex = 0;
			this.isBusy = false;
			this.isActive = false;
			this.isSlideshowActive = false;
			this.settings = {
				getImageSource : Pda.ps.GetImageSource,
				getImageCaption : Pda.ps.GetImageCaption,
				getImageMetaData : Pda.ps.GetImageMetaData,
				fadeInSpeed : 250,
				fadeOutSpeed : 500,
				slideSpeed : 250,
				swipeThreshold : 50,
				swipeTimeThreshold : 250,
				loop : true,
				slideshowDelay : 3000,
				imageScaleMethod : 'fit', // Either "fit" or "zoom"
				preventHide : false,
				zIndex : 1000,
				backButtonHideEnabled : true,
				allowUserZoom : true,
				allowRotationOnUserZoom : true,
				maxUserZoom : 5.0,
				minUserZoom : 0.5,
				captionAndToolbarHideOnSwipe : true,
				captionAndToolbarAutoHideDelay : 5000,
				captionAndToolbarOpacity : 0.8
			};
			if (this.settings.preventHide) {
				this.settings.backButtonHideEnabled = false;
			}
			this.viewportFadeInEventHandler = this.onViewportFadeIn.bind(this);
			this.windowOrientationChangeEventHandler = this.onWindowOrientationChange
					.bind(this);
			this.windowScrollEventHandler = this.onWindowScroll.bind(this);
			this.viewportTouchEventHandler = this.onViewportTouch.bind(this);
			this.viewportFadeOutEventHandler = this.onViewportFadeOut
					.bind(this);
			this.fullImageHandler = this.onSliderDisplayCurrentFullSizeImage
					.bind(this);
			this.toolbarClickEventHandler = this.onToolbarClick.bind(this);
		},
		setOptions : function(options) {
			Util.extend(this.settings, options);
			if (this.settings.preventHide) {
				this.settings.backButtonHideEnabled = false;
			}
		},
		setImages : function(thumbEls) {
			this.currentIndex = 0;
			this.fullSizeImages = [];
			for (var i = 0; i < thumbEls.length; i++) {
				var thumbEl = thumbEls[i];
				var fullSizeImage = new FullSizeImageClass(i,
						this.settings.imageScaleMethod, this.settings
								.getImageSource(thumbEl), this.settings
								.getImageCaption(thumbEl), this.settings
								.getImageMetaData(thumbEl));
				this.fullSizeImages.push(fullSizeImage);
			}
		},

		show : function(startingIndex) {
			if (this.isBusy || this.isActive) {
				return;
			}
			this.isActive = true;
			this.isBusy = true;
			this.lastShowPrevTrigger = Pda.ps.ShowPrevTriggers.show;
			Util.DOM.addClass(document.body, Pda.ps.CssClasses.activeBody);
			startingIndex = window.parseInt(startingIndex);
			if (startingIndex < 0
					|| startingIndex >= this.fullSizeImages.length) {
				startingIndex = 0;
			}
			this.currentIndex = startingIndex;
			if (Util.isNothing(this.documentOverlay)) {
				this.build();
			} else {
				this.resetPosition();
			}
			this.viewport.addListener(ElementClass.EventTypes.onFadeIn,
					this.viewportFadeInEventHandler);
			this.dispatchEvent(Pda.ps.EventTypes.onBeforeShow);
			this.viewport.fadeIn();
		},

		build : function() {
			this.documentOverlay = new DocumentOverlayClass({
						fadeInSpeed : this.settings.fadeInSpeed,
						fadeOutSpeed : this.settings.fadeOutSpeed,
						zIndex : this.settings.zIndex
					});
			this.viewport = new ViewportClass({
						fadeInSpeed : this.settings.fadeInSpeed,
						fadeOutSpeed : this.settings.fadeOutSpeed,
						swipeThreshold : this.settings.swipeThreshold,
						swipeTimeThreshold : this.settings.swipeTimeThreshold,
						zIndex : this.settings.zIndex + 1
					});
			this.slider = new SliderClass({
						fadeInSpeed : this.settings.fadeInSpeed,
						fadeOutSpeed : this.settings.fadeOutSpeed,
						slideSpeed : this.settings.slideSpeed
					}, this.viewport.el);
			this.captionAndToolbar = new CaptionToolbarClass({
						opacity : this.settings.captionAndToolbarOpacity,
						fadeInSpeed : this.settings.fadeInSpeed,
						fadeOutSpeed : this.settings.fadeOutSpeed,
						autoHideDelay : this.settings.captionAndToolbarAutoHideDelay,
						hideClose : this.settings.preventHide,
						zIndex : this.settings.zIndex + 3
					});
			this.resetPosition();
		},

		addListeners : function() {
			if (Util.browser.isAndroid) {
				this.orientationEventName = 'resize';
			} else {
				var supportsOrientationChange = 'onorientationchange' in window;
				this.orientationEventName = supportsOrientationChange
						? 'orientationchange'
						: 'resize';
			}
			Util.DOM.addListener(window, this.orientationEventName,
					this.windowOrientationChangeEventHandler);
			Util.DOM.addListener(window, 'scroll',
					this.windowScrollEventHandler);
			this.viewport.addListener(ViewportClass.EventTypes.onTouch,
					this.viewportTouchEventHandler);
			this.slider.addListener(SliderClass.EventTypes.onFullImageHandler,
					this.fullImageHandler);
			this.captionAndToolbar.addListener(ToolbarClass.EventTypes.onClick,
					this.toolbarClickEventHandler);
		},

		removeListeners : function() {
			Util.DOM.removeListener(window, this.orientationEventName,
					this.windowOrientationChangeEventHandler);
			Util.DOM.removeListener(window, 'scroll',
					this.windowScrollEventHandler);
			this.viewport.removeListener(ViewportClass.EventTypes.onTouch,
					this.viewportTouchEventHandler);
			this.slider.removeListener(
					SliderClass.EventTypes.onFullImageHandler,
					this.fullImageHandler);
			this.captionAndToolbar.removeListener(
					ToolbarClass.EventTypes.onClick,
					this.toolbarClickEventHandler);
		},

		onViewportFadeIn : function(e) {
			this.viewport.removeListener(ElementClass.EventTypes.onFadeIn,
					this.viewportFadeInEventHandler);
			this.documentOverlay.show();
			this.slider.fadeIn();
			this.addListeners();
			this.slider
					.setCurrentFullSizeImage(this.fullSizeImages[this.currentIndex]);
			this.isBusy = false;
			this.dispatchEvent(Pda.ps.EventTypes.onShow);
		},

		setSliderPreviousAndNextFullSizeImages : function() {
			var lastIndex, previousFullSizeImage = null, nextFullSizeImage = null;
			if (this.fullSizeImages.length > 1) {
				lastIndex = this.fullSizeImages.length - 1;
				if (this.currentIndex === lastIndex) {

					if (this.settings.loop) {
						nextFullSizeImage = this.fullSizeImages[0];
					}
					previousFullSizeImage = this.fullSizeImages[this.currentIndex
							- 1];
				} else if (this.currentIndex === 0) {
					nextFullSizeImage = this.fullSizeImages[this.currentIndex
							+ 1];
					if (this.settings.loop) {
						previousFullSizeImage = this.fullSizeImages[lastIndex];
					}
				} else {
					nextFullSizeImage = this.fullSizeImages[this.currentIndex
							+ 1];
					previousFullSizeImage = this.fullSizeImages[this.currentIndex
							- 1];
				}
			}
			this.slider.setPreviousAndNextFullSizeImages(previousFullSizeImage,
					nextFullSizeImage);
		},
		onWindowOrientationChange : function(e) {
			this.resetPosition();
		},
		onWindowScroll : function(e) {
			this.resetPosition();
		},

		resetPosition : function() {
			this.removeZoomPanRotate();
			this.viewport.resetPosition();
			this.slider.resetPosition();
			this.documentOverlay.resetPosition();
			this.captionAndToolbar.resetPosition();
			this.dispatchEvent(Pda.ps.EventTypes.onResetPosition);
		},

		onViewportTouch : function(e) {
			switch (e.action) {
				case ViewportClass.Actions.touchStart :
					this.stopSlideshow();
					break;
				case ViewportClass.Actions.touchMove :
					break;
				case ViewportClass.Actions.click :
					this.stopSlideshow();
					if (!this.settings.hideToolbar) {
						this.toggleCaptionAndToolbar();
					} else {
						this.hide();
					}
					this.dispatchEvent(Pda.ps.EventTypes.onViewportClick);
					break;
				case ViewportClass.Actions.swipeLeft :
					this.stopSlideshow();
					this.lastShowPrevTrigger = Pda.ps.ShowPrevTriggers.swipe;
					this.showNext();
					break;
				case ViewportClass.Actions.swipeRight :
					this.stopSlideshow();
					this.lastShowPrevTrigger = Pda.ps.ShowPrevTriggers.swipe;
					this.showPrevious();
					break;
			}
		},

		onViewportFadeOut : function(e) {
			this.viewport.removeListener(ElementClass.EventTypes.onFadeOut,
					this.viewportFadeOutEventHandler);
			this.isBusy = false;
			this.isActive = false;
			this.dispatchEvent(Pda.ps.EventTypes.onHide);
		},

		hide : function() {
			if (this.isBusy || this.settings.preventHide) {
				return;
			}
			if (!this.isActive) {
				return;
			}
			this.isBusy = true;
			this.removeZoomPanRotate();
			this.removeListeners();
			this.documentOverlay.hide();
			this.captionAndToolbar.hide();
			this.slider.hide();
			Util.DOM.removeClass(document.body, Pda.ps.CssClasses.activeBody);
			this.viewport.addListener(ElementClass.EventTypes.onFadeOut,
					this.viewportFadeOutEventHandler);
			this.dispatchEvent(Pda.ps.EventTypes.onBeforeHide);
			this.viewport.fadeOut();
		},
		hideImmediately : function() {
			if (!this.isActive) {
				return;
			}
			this.dispatchEvent(Pda.ps.EventTypes.onBeforeHide);
			this.removeZoomPanRotate();
			this.removeListeners();
			this.documentOverlay.hide();
			this.captionAndToolbar.hide();
			this.slider.hide();
			this.viewport.hide();
			Util.DOM.removeClass(document.body, Pda.ps.CssClasses.activeBody);
			this.isBusy = false;
			this.isActive = false;
			this.dispatchEvent(Pda.ps.EventTypes.onHide);
		},

		showNext : function() {
			if (this.isBusy) {
				return;
			}
			this.isBusy = true;
			this.setCaptionAndToolbarOnShowPreviousNext();
			this.slider.showNext();
			this.dispatchEvent(Pda.ps.EventTypes.onShowNext);
		},

		showPrevious : function() {
			if (this.isBusy) {
				return;
			}
			this.isBusy = true;
			this.setCaptionAndToolbarOnShowPreviousNext();
			if (this.wasUserZoomActive) {
				Util.DOM.hide(this.slider.currentItem.imageEl);
			}
			this.slider.showPrevious();
			this.dispatchEvent(Pda.ps.EventTypes.onShowPrevious);
		},

		setCaptionAndToolbarOnShowPreviousNext : function() {
			var resetAutoTimeout = false;
			switch (this.lastShowPrevTrigger) {
				case Pda.ps.ShowPrevTriggers.toolbar :
					resetAutoTimeout = true;
					break;
				case Pda.ps.ShowPrevTriggers.slideshow :
					resetAutoTimeout = false;
					break;
				default :
					resetAutoTimeout = !this.settings.captionAndToolbarHideOnSwipe;
					break;
			}
			if (resetAutoTimeout) {
				this.captionAndToolbar.resetAutoHideTimeout();
			} else {
				this.fadeOutCaptionAndToolbar();
			}
		},
		onSliderDisplayCurrentFullSizeImage : function(e) {
			this.currentIndex = e.fullSizeImage.index;
			if (this.settings.loop) {
				this.captionAndToolbar.setNextState(false);
				this.captionAndToolbar.setPreviousState(false);
			} else {
				if (this.currentIndex >= this.fullSizeImages.length - 1) {
					this.captionAndToolbar.setNextState(true);
				} else {
					this.captionAndToolbar.setNextState(false);
				}
				if (this.currentIndex < 1) {
					this.captionAndToolbar.setPreviousState(true);
				} else {
					this.captionAndToolbar.setPreviousState(false);
				}
			}
			this.captionAndToolbar
					.setCaptionValue(this.fullSizeImages[this.currentIndex].caption);
			this.captionAndToolbar
					.setPlayValue(this.fullSizeImages[this.currentIndex].metaData.id);
			var fadeIn = false;
			switch (this.lastShowPrevTrigger) {
				case Pda.ps.ShowPrevTriggers.toolbar :
					fadeIn = true;
					break;
				case Pda.ps.ShowPrevTriggers.show :
					fadeIn = true;
					break;
				case Pda.ps.ShowPrevTriggers.slideshow :
					fadeIn = false;
					break;
				default :
					fadeIn = !this.settings.captionAndToolbarHideOnSwipe;
					break;
			}
			if (fadeIn) {
				this
						.dispatchEvent(Pda.ps.EventTypes.onBeforeCaptionAndToolbarShow);
				this.captionAndToolbar.fadeIn();
			}
			this.dispatchEvent(Pda.ps.EventTypes.onDisplayImage);
			this.lastShowPrevTrigger = '';
			this.setSliderPreviousAndNextFullSizeImages();
			this.isBusy = false;
		},

		toggleCaptionAndToolbar : function() {
			if (this.captionAndToolbar.isHidden) {
				this
						.dispatchEvent(Pda.ps.EventTypes.onBeforeCaptionAndToolbarShow);
				this.captionAndToolbar.fadeIn();
			} else {
				this
						.dispatchEvent(Pda.ps.EventTypes.onBeforeCaptionAndToolbarHide);
				this.captionAndToolbar.fadeOut();
			}
		},

		fadeOutCaptionAndToolbar : function() {
			if (!this.captionAndToolbar.isHidden) {
				this
						.dispatchEvent(Pda.ps.EventTypes.onBeforeCaptionAndToolbarHide);
				this.captionAndToolbar.fadeOut();
			}
		},

		onToolbarClick : function(e) {
			this.stopSlideshow();
			switch (e.action) {
				case ToolbarClass.Actions.play :
					this.play();
					break;
				default :
					this.hide();
					break;
			}
		},

		// 下载播放附件
		play : function() {
			window
					.open(
							Com_Parameter.ContextPath
									+ '/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId='
									+ this.captionAndToolbar.toolbar.attId,
							'_blank');
		},

		stopSlideshow : function() {
			if (!Util.isNothing(this.slideshowTimeout)) {
				window.clearTimeout(this.slideshowTimeout);
			}
			this.isSlideshowActive = false;
			this.dispatchEvent(Pda.ps.EventTypes.onSlideshowStop);
		},

		removeZoomPanRotate : function() {
			if (Util.isNothing(this.zoomPanRotate)) {
				return;
			}
			this.zoomPanRotate.removeFromDOM();
			this.zoomPanRotate = null;
		}

	});

	Pda.ps.CssClasses = {
		activeBody : 'ps-active'
	};

	Pda.ps.ShowPrevTriggers = {
		show : 'show',
		toolbar : 'toobar',
		swipe : 'swipe',
		keyboard : 'keyboard',
		slideshow : 'slideshow'
	};

	Pda.ps.EventTypes = {
		onBeforeShow : 'onBeforeShow',
		onShow : 'onShow',
		onBeforeHide : 'onBeforeHide',
		onHide : 'onHide',
		onShowNext : 'onShowNext',
		onShowPrevious : 'onShowPrevious',
		onDisplayImage : 'onDisplayImage',
		onResetPosition : 'onResetPosition',
		onSlideshowStart : 'onSlideshowStart',
		onSlideshowStop : 'onSlideshowStop',
		onBeforeCaptionAndToolbarShow : 'onBeforeCaptionAndToolbarShow',
		onBeforeCaptionAndToolbarHide : 'onBeforeCaptionAndToolbarHide',
		onViewportClick : 'onViewportClick'

	};

	Pda.ps.GetImageSource = function(el) {
		return el.href;
	};
	Pda.ps.GetImageCaption = function(el) {
		if (el.nodeName === "IMG") {
			return $(el).attr('alt');
		}
		var i, childEl;
		for (i = 0; i < el.childNodes.length; i++) {
			childEl = el.childNodes[i];
			if (el.childNodes[i].nodeName === 'IMG') {
				return $(childEl).attr('alt')
			}
		}
	};

	// 获取对应图片其他信息--这里只实现id
	Pda.ps.GetImageMetaData = function(el) {
		if (el.nodeName === "IMG") {
			return {
				id : $(childEl).attr('data-lui-id')
			};
		}
		var i, childEl;
		for (i = 0; i < el.childNodes.length; i++) {
			childEl = el.childNodes[i];
			if (el.childNodes[i].nodeName === 'IMG') {
				return {
					id : $(childEl).attr('data-lui-id')
				};
			}
		}
	};

	Pda.ps.Current = new photoSwipe();

	Pda.photoSwipe = function(thumbEls, containerEl, opts) {
		var useEventDelegation = true;
		if (Util.isNothing(thumbEls)) {
			return;
		}
		if (Util.isNothing(containerEl)) {
			containerEl = document.documentElement;
			useEventDelegation = false;
		}
		if (Util.isString(containerEl)) {
			containerEl = document.documentElement.querySelector(containerEl);
		}
		if (Util.isString(thumbEls)) {
			thumbEls = containerEl.querySelectorAll(thumbEls);
		}
		if (Util.isNothing(thumbEls)) {
			return;
		}
		var onClick = function(e) {
			e.preventDefault();
			showps(e.currentTarget);
		};
		var showps = function(clickedEl) {
			var startingIndex;
			for (startingIndex = 0; startingIndex < thumbEls.length; startingIndex++) {
				if (thumbEls[startingIndex] === clickedEl) {
					break;
				}
			}
			Pda.ps.Current.show(startingIndex);
		};

		Pda.ps.Current.setOptions(opts);

		Pda.ps.Current.setImages(thumbEls);

		if (useEventDelegation) {
			containerEl.addListener('click', function(e) {
						if (e.target === e.currentTarget) {
							return;
						}
						e.preventDefault();
						var findNode = function(clickedEl, targetNodeName,
								stopAtEl) {
							if (Util.isNothing(clickedEl)
									|| Util.isNothing(targetNodeName)
									|| Util.isNothing(stopAtEl)) {
								return null;
							}
							if (clickedEl.nodeName === targetNodeName) {
								return clickedEl;
							}
							if (clickedEl === stopAtEl) {
								return null;
							}
							return findNode(clickedEl.parentNode,
									targetNodeName, stopAtEl);
						};
						var clickedEl = findNode(e.target,
								thumbEls[0].nodeName, e.currentTarget);
						if (Util.isNothing(clickedEl)) {
							return;
						}
						showps(clickedEl);
					}, false);
		} else {
			for (var i = 0; i < thumbEls.length; i++) {
				var thumbEl = thumbEls[i];
				thumbEl.addListener('click', onClick, false);
			}
		}
		return thumbEls;
	};

	if (!Util.isNothing(window.$)) {
		window.$.fn.photoSwipe = function(opts) {
			var thumbEls = this;
			Pda.ps.Current.setOptions(opts);
			Pda.ps.Current.setImages(thumbEls);

			$(thumbEls).on('click', function(e) {
						e.preventDefault();
						var startingIndex = $(thumbEls)
								.index($(e.currentTarget));
						Pda.ps.Current.show(startingIndex);
					});
		};
	}

})(window, Pda.ps.Util, Pda.ps.ElementClass, Pda.ps.DocumentOverlayClass,
		Pda.ps.FullSizeImageClass, Pda.ps.ViewportClass, Pda.ps.SliderClass,
		Pda.ps.CaptionClass, Pda.ps.ToolbarClass, Pda.ps.CaptionToolbarClass);
