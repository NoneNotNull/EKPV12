var $step = $('.step');
var $form = $('.global').children('form');
function jump($target, d) {
	var step = $target.parents('.step'), _step;
	if ($form.attr('data-disabled'))
		return;
	$form.attr('data-disabled', true);
	var validate = pre_nextValidate(step);
	if (!validate) {
		$form.removeAttr('data-disabled');
		return;
	}
	if (d == 'pre') {
		_step = step.prev();
		jumpIndex--;
	} else if (d == 'next') {
		_step = step.next();
		jumpIndex++;
	}
	Pda.Topic.emit({
				'type' : 'jump',
				'index' : jumpIndex,
				'step' : step,
				'_step' : _step
			});
}
//var isAndroid = Pda.Util.browser.isAndroid;
var jumpIndex = 0;
$(function() {
			if ($step && $step.length > 0)
				$($step[0]).show();

			var size = $step.size(), rate = 360 / size;

			$('.lui-step-btn').on('click', function(evt) {
						var $target = $(evt.target);
						if ($target.hasClass('next')) {
							jump($target, 'next');
						}
						if ($target.hasClass('pre')) {
							jump($target, 'pre');
						}
						if ($target.hasClass('submit')) {
							save();
						}
					});

			Pda.Topic.emit({
						'type' : 'jump',
						'index' : jumpIndex,
						'step' : $('.step').eq(jumpIndex),
						'_step' : $('.step').eq(jumpIndex)
					});
		});

Pda.Topic.on('ready', function() {
			var height = Pda.Util.getClientHeight();

			$step.each(function(i) {
						var css = {};
						// if (!isAndroid)
						// css = {
						// '-webkit-transform' : 'rotateX(' + -90 * i
						// + 'deg) translateZ(' + (height - 50)
						// / 2 + 'px)'
						// };
						// else
						css = {
							'position' : 'relative',
							'height' : height - 50,
							'top' : 'auto',
							'left' : 'auto',
							'right' : 'auto',
							'bottom' : '5px'
						};
						$(this).css(css);
						$(this).attr('data-lui-index', i);
					});
			var global = {};
			// if (!isAndroid)
			// global = {
			// '-webkit-transform' : 'translateZ(-' + (height - 50) / 2
			// + 'px)',
			// 'height' : height - 50,
			// 'padding-top' : 50
			// }
			// else
			global = {
				'height' : height - 50,
				'padding-top' : 50,
				'overflow' : 'hidden'
			}
			$('.global').css(global);
			$form.on('webkitTransitionEnd', function() {
						$form.removeAttr('data-disabled');
					});
		});

// 监听上传控件，用于跳转步骤
Pda.Topic.on('upload_change', function() {
			jumpIndex = 1;
			Pda.Topic.emit({
						'type' : 'jump',
						'index' : jumpIndex,
						'step' : $('.step').eq(jumpIndex),
						'_step' : $('.step').eq(jumpIndex + 1)
					});
		});

var ___validator;

function pre_nextValidate(obj, after) {
	if (typeof(KMSSValidation) == 'undefined')
		return true;

	if (!___validator) {
		if (after)
			___validator = $KMSSValidation(obj, {
						afterFormValidate : after
					});
		else
			___validator = $KMSSValidation(obj);
	} else {
		if (after)
			___validator.options.afterFormValidate = after;
		___validator.form = obj;
	}

	if (!Com_Parameter.event["submit"][0]()) {
		return false;
	}
	return true;
}

Pda.Topic.on('jump', function(evt) {
			if (!evt)
				return;
			var index = evt.index, step = evt.step, _step = evt._step;

			// if (!isAndroid)
			// step.parent().css('-webkit-transform',
			// 'rotateX(' + index * 90 + 'deg)');
			// else {
			var height = Pda.Util.getClientHeight();
			step.parent().css('-webkit-transform',
					'translate3d(0,-' + index * (height - 50) + 'px,0)');
			// }
			Pda.Topic.emit({
						'type' : 'changeTitle',
						'title' : _step.attr('data-lui-title')
					})
		});