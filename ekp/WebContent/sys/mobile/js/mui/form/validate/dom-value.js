define([ "dojo/dom"], function(dom) {
	return {
		get: function(element) {
			var method = element.tagName.toLowerCase();
			return this[method](element);
		},
	
		input:function(element){
			switch (element.type.toLowerCase()) {
				case 'submit':
				case 'hidden':
				case 'password':
				case 'text':
					return this.textarea(element);
				case 'checkbox':
				case 'radio':
					return this.groupSelector(element);
			}
			return null;
		},
		
		groupSelector: function(element) {
			// 若没有name属性，则认为只有一个checkbox或radio。
			if (!element.name) return this.inputSelector(element);
			// 由于一组checkbox或radio是由相同的name组成，故...
			var values = [], type = element.type.toLowerCase;
			var cbElements = document.getElementsByName(element.name);
			for (var i = cbElements.length - 1; i >= 0; i--)
				if (cbElements[i].type.toLowerCase == type && cbElements[i].checked)
					values.push(cbElements[i].value);
			return [element.name, values.join(';')];
		},
	
		inputSelector: function(element) {
			if (element.checked)
				return [element.name, element.value];
		},
	
		textarea: function(element) {
			return [element.name, element.value];
		},
	
		select: function(element) {
			return this[element.type == 'select-one' ? 'selectOne' : 'selectMany'](element);
		},
	
		selectOne: function(element) {
			var value = '', opt, index = element.selectedIndex;
			if (index >= 0) {
				opt = element.options[index];
				value = (opt.value == null) ? opt.text : opt.value;
			}
			return [element.name, value];
		},
	
		selectMany: function(element) {
			var value = [];
			for (var i = 0; i < element.length; i++) {
				var opt = element.options[i];
				if (opt.selected)
					value.push((opt.value == null) ? opt.text : opt.value);
			}
			return [element.name, value];
		}
	};
});