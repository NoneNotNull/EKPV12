define( [ "dojo/_base/xhr", "dojo/_base/lang", "dojo/json",
		"dojo/_base/declare", "dojo/store/util/QueryResults", /*=====, "./api/Store" =====*/
		"dojo/request/script" ], function(xhr, lang, JSON, declare,
		QueryResults, script /* =====, Store ===== */) {

		// No base class, but for purposes of documentation, the base class is dojo/store/api/Store
		var base = null;

		return declare("mui.store.JsonpRest", base, {

			constructor : function(options) {

				this.headers = {};
				declare.safeMixin(this, options);
			},

			// headers: Object

			headers : {},

			target : "",

			idProperty : "id",

			ascendingPrefix : "+",

			descendingPrefix : "-",

			_getTarget : function(id) {
				// summary:
			//		If the target has no trailing '/', then append it.
			// id: Number
			// The identity of the requested target
			var target = this.target;
			if (typeof id != "undefined") {
				if (target.charAt(target.length - 1) == '/') {
					target += id;
				} else {
					target += '/' + id;
				}
			}
			return target;
		},

		get : function(id, options) {

			options = options || {};

			var hasQuestionMark = this.target.indexOf("?") > -1;

			var query = options.query;
			if (query && typeof query == "string") {
				query = xhr.queryToObject(query);
				query = query ? (hasQuestionMark ? "&" : "?") + query : "";
			}

			return script.get(this.target, {
				jsonp : "jsonpcallback",
				query : query,
				timeout : typeof(options.timeout) == "number" ? options.timeout : 10000
			});
		},

		accepts : "application/javascript, application/json",

		getIdentity : function(object) {

			return object[this.idProperty];
		},

		put : function(object, options) {
				//不支持
		},

		add : function(object, options) {
				//不支持
		},

		remove : function(id, options) {
				//不支持
		},

		query : function(query, options) {

				options = options || {};

				var hasQuestionMark = this.target.indexOf("?") > -1;
				if (query && typeof query == "string") {
					query = xhr.queryToObject(query);
					query = query ? (hasQuestionMark ? "&" : "?") + query : "";
				}

				if (options && options.sort) {
					var sortParam = this.sortParam;
					query += (query || hasQuestionMark ? "&" : "?")
							+ (sortParam ? sortParam + '=' : "sort(");
					for ( var i = 0; i < options.sort.length; i++) {
						var sort = options.sort[i];
						query += (i > 0 ? "," : "")
								+ (sort.descending ? this.descendingPrefix
										: this.ascendingPrefix)
								+ encodeURIComponent(sort.attribute);
					}
					if (!sortParam) {
						query += ")";
					}
				}

				var results = script.get(this.target, {
					jsonp : "jsonpcallback",
					query : query,
					timeout : typeof(options.timeout) == "number" ? options.timeout : 10000//10秒后没响应就认为是请求失败
				});

				return QueryResults(results);
			}
		});

	});