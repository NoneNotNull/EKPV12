/**
 * soap 拼接 构造soap对象，方便对用webservice
 * 
 * by zhangtian
 * 
 */
(function($) {
	function SoapObj(options) {
		this.options = options;
	};
	SoapObj.prototype = {
		mergeOpts : function(options) {
			this.options = $.extend({}, this.options, options);
			return this.options;
		},
		sapToXml : function() {
			var mergeOptions = $
					.extend({}, $.soapObj.defaults, this.options);
			xmlArray = [];
			xmlArray.push(mergeOptions.xmlTitle);
			var ObjectStr = "<" + mergeOptions.soapTag + " ";
			for (var i = 0, len = mergeOptions.xmlns.length; i < len; i++) {
				ObjectStr += " xmlns:" + mergeOptions.xmlns[i]["ns"] + "=\""
						+ mergeOptions.xmlns[i]["uri"] + "\"";
			}
			ObjectStr += ">";
			xmlArray.push(ObjectStr);
			xmlArray.push("<" + mergeOptions.soapBody + ">")

			for (var m = 0, m_len = mergeOptions.methods.length; m < m_len; m++) {
				var m_str = "";
				var method = mergeOptions.methods[m];
				m_str += "<" + method.methodName + ">";
				for (var p_index = 0, p_len = method.paramters.length; p_index < p_len; p_index++) {
					m_str += "<" + method.paramters[p_index].name + ">";
					m_str += method.paramters[p_index].val;
					m_str += "</" + method.paramters[p_index].name + ">";
				}
				m_str += "</" + method.methodName + ">";
				xmlArray.push(m_str);
			}
			var endBody = "</" + mergeOptions.soapBody + ">";;
			xmlArray.push(endBody);
			var endObject = "</" + mergeOptions.soapTag + ">";
			xmlArray.push(endObject);
			return xmlArray.join("");
		},
		getResult : function(callback) {
			var xmlhttp = null;
			if (window.XMLHttpRequest) {
				xmlhttp = new XMLHttpRequest();
			} else if (!!window.ActiveXObject || "ActiveXObject" in window) {
				xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
			}
			xmlhttp.open("POST", this.options.wsURL, false);
			xmlhttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
			xmlhttp.onreadystatechange=function(){
			callback.call(xmlhttp);
			}
			xmlhttp.send(this.sapToXml());
		}
	}
	$.extend({
				soapObj : {
					init : function(options) {
						return new SoapObj(options);
					},
					defaults : {
						xmlTitle : "<?xml version=\"1.0\" encoding=\"utf-8\"?>",
						xmlns : [{
									ns : "xsi",
									uri : "http://www.w3.org/2001/XMLSchema-instance"
								}, {
									ns : "xsd",
									uri : "http://www.w3.org/2001/XMLSchema"
								}, {
									ns : "soap",
									uri : "http://schemas.xmlsoap.org/soap/envelope/"
								}],
						soapTag : "soap:Envelope",
						soapBody : "soap:Body",
						wsURL : null,
						// method:{methodName: paramters:[{name: val:}]}
						methods : []
					}
				}
			});
})(jQuery);