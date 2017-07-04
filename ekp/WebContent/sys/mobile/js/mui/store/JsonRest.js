define(
		[ "dojo/_base/xhr", "dojo/_base/lang", "dojo/_base/declare",
				"dojo/store/util/QueryResults", "dojo/store/JsonRest",
				"dojo/_base/lang" ],
		function(xhr, lang, declare, QueryResults, JsonRest, lang) {

			return declare(
					"mui.store.JsonRest",
					JsonRest,
					{

						defaultType : 'POST',

						query : function(query, options) {
							options = options || {};
							if (options.type)
								this.defaultType = options.type;
							var headers = lang.mixin({
								Accept : this.accepts
							}, this.headers, options.headers);
							var data = {};
							var hasQuestionMark = this.target.indexOf("?") > -1, postData = {};
							if (query && typeof query == "object") {
								if (this.defaultType.toLowerCase() == 'post') {
									data.postData = query;
									query = "";
								} else {
									query = xhr.objectToQuery(query);
									query = query ? (hasQuestionMark ? "&"
											: "?")
											+ query : "";
								}
							}
							if (options.start >= 0 || options.count >= 0) {
								headers["X-Range"] = "items="
										+ (options.start || '0')
										+ '-'
										+ (("count" in options && options.count != Infinity) ? (options.count
												+ (options.start || 0) - 1)
												: '');
								if (this.rangeParam) {
									query += (query || hasQuestionMark ? "&"
											: "?")
											+ this.rangeParam
											+ "="
											+ headers["X-Range"];
									hasQuestionMark = true;
								} else {
									headers.Range = headers["X-Range"];
								}
							}
							if (options && options.sort) {
								var sortParam = this.sortParam;
								query += (query || hasQuestionMark ? "&" : "?")
										+ (sortParam ? sortParam + '='
												: "sort(");
								for (var i = 0; i < options.sort.length; i++) {
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

							lang.mixin(data, {
								url : this.target + (query || ""),
								handleAs : "json",
								headers : headers
							})
							var results = xhr(this.defaultType, data);
							results.total = results
									.then(function() {
										var range = results.ioArgs.xhr
												.getResponseHeader("Content-Range");
										if (!range) {
											range = results.ioArgs.xhr
													.getResponseHeader("X-Content-Range");
										}
										return range
												&& (range = range
														.match(/\/(.*)/))
												&& +range[1];
									});
							return QueryResults(results);
						}
					});
		});