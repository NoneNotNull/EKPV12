<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<%@ include file="/sys/ftsearch/search_ui_js.jsp"%>
<title>${ lfn:message('sys-ftsearch-db:search.moduleName.all')}</title>
</head>
<body>
<% Page queryPage = (Page)request.getAttribute("queryPage");
   List fieldList = (ArrayList)request.getAttribute("fieldList");
%>

<form id="sysFtsearchReadLogForm" name="sysFtsearchReadLogForm"  action="<c:url value="/sys/ftsearch/expand/sys_ftsearch_read_log/sysFtsearchReadLog.do?method=save" />" method="post" target="_blank">
<input id="fdDocSubject" name="fdDocSubject" type="hidden">
<input id="fdModelName" name="fdModelName" type="hidden">
<input id="fdCategory" name="fdCategory" type="hidden">
<input id="fdUrl" name="fdUrl" type="hidden">
<input id="fdSearchWord" name="fdSearchWord" type="hidden">
<input id="fdHitPosition" name="fdHitPosition" type="hidden">
<input id="fdModelId" name="fdModelId" type="hidden">
</form>

<%--范围个数--%>
<input type='hidden'  name ='entriesDesignCount'  value='${entriesDesignCount}' />
<input type="hidden" name="modelName" value="${param.modelName}" />
<input type="hidden" name="searchFields" value="${param.searchFields}" />
<input type='hidden'  name ='entriesDesignCount'  value='${entriesDesignCount}' />
<input type="hidden" name="multisSysModel" value=''/>
<input type="hidden" name="modelGroup" value="${modelGroup}" />
<input type="hidden" name="modelGroupChecked" value="${modelGroupChecked}" />
<input type="hidden" id='category' name="category" value='${category}' />
<input type="hidden" id='srcCategory' name ="srcCategory" value ='${treeCategory}'>
<div id="search_wrapper">
	<div id="search_head">
		<div class="box c" style="margin-left:170px">
			<a href="#" class="logo" title=""></a>
			<ul class="search_box">
				<li class="search">
					<input type="text" class="input_search" name="queryString" value="${queryString}"
						id="q5" onkeydown="if (event.keyCode == 13 && this.value !='') CommitSearch(0);">
					<a style="height:33px;cursor:pointer;" class="btn_search" onclick="CommitSearch(0);" title="${lfn:message('sys-ftsearch-db:search.ftsearch.button.search')}">
						<span>${lfn:message('sys-ftsearch-db:search.ftsearch.button.search')}</span>
					</a>
				</li>
				<li class="range">
					<a href="#" class="title" title=""><span><em>${lfn:message('sys-ftsearch-db:search.ftsearch.current.hot.search')}</em></span></a>
					<c:if test="${hotwordList!=null}">
						<div style="width:380px">
							<c:forEach items="${hotwordList}" var="hotword"  varStatus="status">
							     <a href="#" onclick="relatedSearchWord()" id="${hotword}">
								     ${hotword}
							     </a>				
							</c:forEach>
						</div>
					</c:if>
				</li>
				<li class="group">
					<c:if test="${not empty modelGroupList}">
						<c:forEach items="${modelGroupList}" var="element" varStatus="status">
							<input id='${element.fdId }' type="checkbox" value="${element.fdCategoryName}" name="modelGroups"
								onclick="selectModelGroup(this,'${element.fdCategoryModel}')" 
								<c:if test="${fn:contains(modelGroupChecked, element.fdCategoryName)}">
									checked
								</c:if>
							>&nbsp;&nbsp;${element.fdCategoryName}
						</c:forEach>	
					</c:if>
				</li>	
			</ul>
			<div style=" position: relative; width: 100%;">
				<input type="button" class="btn_return" onclick="window.location.href='${KMSS_Parameter_ContextPath}'" value="${lfn:message('sys-ftsearch-db:search.ftsearch.search.return')}"/>
			</div>
		</div>
	</div><!-- search_head end -->
	<div id="search_main" class="c">
		
		<c:if test="${queryPage==null || param.queryString==null}">
			<div class="search_con" style="height: 500px; background:url(styles/images/bg_split.gif) repeat-y; border-bottom:1px solid #efefef;"></div>
		</c:if>
		<c:if test="${not empty queryPage && queryPage!=null}">
			<% if (queryPage.getTotalrows()==0){ %>	
				<c:if test="${ not empty mapSet['queryString']}" >
					<div class="search_con">
						<div class="search_main" style="min-height:500px; overflow:visible">
							<div class="search_con" style="height: 500px">
								<c:if test="${checkWord!=null}">
									<div style="color:#000; font:bold 14px Arial; line-height:15px;">${lfn:message('sys-ftsearch-db:search.ftsearch.mean')}
										<a href="#" onclick="relatedSearchWord()" id="${checkWord}" style="color: red; font:bold 14px Arial; line-height:15px;">
											${checkWord}
										</a>
									</div>
								</c:if>
								<ul class="search_none">
									<li><h3>${lfn:message('sys-ftsearch-db:sysFtsearchDb.sorry')}<span style="color: red">${param.queryString}</span>${lfn:message('sys-ftsearch-db:sysFtsearchDb.about')}
									</h3></li>
									<li>${lfn:message('sys-ftsearch-db:sysFtsearchDb.advice')}</li>
									<li>${lfn:message('sys-ftsearch-db:sysFtsearchDb.checkWrong')}</li>
									<li>${lfn:message('sys-ftsearch-db:sysFtsearchDb.deleteSome')}</li>
								</ul>
							</div>
						</div>
					</div>
				</c:if>
			<% }
			else  
			{ %>
			<div class="search_con">
				<div class="search_main" style="min-height:500px; overflow:visible">
					<div class="search_result c">
						<ul class="btn_box">
							<li><a href="#" onclick="sortResult('time');"
							<c:if test="${param.sortType==null || param.sortType=='score'}">
								class="btn_a" 
							</c:if>
							<c:if test="${param.sortType=='time'}">
								class="btn_a_selected"
							</c:if>
							title=""><span><em>${lfn:message('sys-ftsearch-db:search.ftsearch.sort.by.time')}</em></span></a></li>
							<li><a href="#" onclick="sortResult('score');"
							<c:if test="${param.sortType==null || param.sortType=='score'}">
								class="btn_a_selected" 
							</c:if>
							<c:if test="${param.sortType=='time'}">
								class="btn_a"
							</c:if>
							title=""><span><em>${lfn:message('sys-ftsearch-db:search.ftsearch.sort.by.score')}</em></span></a></li>
						</ul>
						<p>${lfn:message('sys-ftsearch-db:search.ftsearch.probably')}<span class="item_Result">&nbsp;<%=queryPage.getTotalrows()%>&nbsp;</span>${lfn:message('sys-ftsearch-db:search.ftsearch.itemResult')}
						</p>
						<p>
							&nbsp;&nbsp;&nbsp;&nbsp;${lfn:message('sys-ftsearch-db:search.ftsearch.search.userTime')}<span class="item_Result">&nbsp;${userTime}&nbsp;</span>${lfn:message('sys-ftsearch-db:search.ftsearch.search.minute')}
						</p>
					</div><!-- end search_result -->
					<c:if test="${checkWord!=null}">
						<div style="color:#000; font:bold 14px Arial; line-height:15px;">${lfn:message('sys-ftsearch-db:search.ftsearch.mean')}
							<a href="#" onclick="searchWord('${checkWord}')" style="color: red; font:bold 14px Arial; line-height:15px;">
								${checkWord}
							</a>
							<span>${lfn:message('sys-ftsearch-db:search.ftsearch.checkResult')}
								<span style="color: red">${checkWord}</span>${lfn:message('sys-ftsearch-db:search.ftsearch.checkBeforeResult')}
							</span>
							<a href="#" onclick="searchOldWord('${param.queryString}')" style="color: red; font:bold 14px Arial; line-height:15px;">
								${param.queryString}
							</a>
						</div>
					</c:if>	
					<div class="search_list">
						<%--如果查询有数据--%>
						<%--标题 时间 创建者 所属模块--%>
						<%for(int i=0;i<queryPage.getList().size();i++){
							LksHit lksHit = (LksHit)queryPage.getList().get(i);
							Map lksFieldsMap = lksHit.getLksFieldsMap();
							LksField link = (LksField)lksFieldsMap.get("linkStr");
							LksField title = (LksField)lksFieldsMap.get("title");
							LksField subject = (LksField)lksFieldsMap.get("subject");
							LksField content = (LksField)lksFieldsMap.get("content");
							LksField fileName = (LksField)lksFieldsMap.get("fileName");
							LksField ekpDigest = (LksField)lksFieldsMap.get("ekpDigest");
							LksField juniorSummary = (LksField)lksFieldsMap.get("juniorSummary");
							LksField docKey = (LksField)lksFieldsMap.get("docKey");
							LksField mimeType = (LksField)lksFieldsMap.get("mimeType");
							//自定义表单内容
							LksField xmlContent = (LksField)lksFieldsMap.get("xmlcontent");
							LksField addField1 = (LksField)lksFieldsMap.get("addField1");//机构
							LksField addField2 = (LksField)lksFieldsMap.get("addField2");//电话
							LksField addField3 = (LksField)lksFieldsMap.get("addField3");//部门
							LksField addField4 = (LksField)lksFieldsMap.get("addField4");//手机
							LksField addField5 = (LksField)lksFieldsMap.get("addField5");//岗位
							LksField addField6 = (LksField)lksFieldsMap.get("addField6");//邮箱
							LksField addField7 = (LksField)lksFieldsMap.get("addField7");//个人资料
							String existPersonName=lksHit.getExistPeronName();
							String docInfo="";
							if(docKey != null){
								docInfo = docKey.getValue();
							}
							String linkArgu=null;
							String docId="";
							if(docInfo.lastIndexOf("_")>-1){
								linkArgu=docInfo.substring(docInfo.lastIndexOf("_")+1);
								docId=docInfo.substring(docInfo.lastIndexOf("_")+1,docInfo.length());
							}
							LksField keyword = (LksField)lksFieldsMap.get("keyword");
							LksField modelName = (LksField)lksFieldsMap.get("modelName");
							LksField category= (LksField)lksFieldsMap.get("category");
							LksField creator = (LksField)lksFieldsMap.get("creator");
							LksField createTime = (LksField)lksFieldsMap.get("createTime");  
							LksField systemName = (LksField)lksFieldsMap.get("systemName");//系统名
							LksField fullText = (LksField)lksFieldsMap.get("fullText");
							String fdSystemName="";
							String linkUrl= "";
							String systemModelStr="";
							if(link != null){
								linkUrl = link.getValue();
							}
							if(systemName!=null){
								fdSystemName=systemName.getValue();
								systemModelStr=fdSystemName+"@";
							}
							String mainDocLink = linkUrl;
							if(fileName!=null && StringUtil.isNotNull(linkArgu)){
								linkUrl+="&s_ftAttId=" + linkArgu;
							}
							request.setAttribute("mimeType",mimeType==null?"":mimeType.getValue()); 
							request.setAttribute("linkUrl",linkUrl); 
							request.setAttribute("mainDocLink",mainDocLink); 
							if(modelName != null){
								Map<String,String> modelUrlMap = (Map<String,String>)request.getAttribute("modelUrlMap");
								String modelUrl = null;
								if(modelUrlMap !=null){
									if(fdSystemName != null && modelUrlMap.containsKey(fdSystemName+"@"+modelName.getValue())){
										modelUrl =  modelUrlMap.get(fdSystemName+"@"+modelName.getValue());
									}else{
										if(modelUrlMap.get(modelName.getValue())!=null){
											if(modelUrlMap.get(modelName.getValue()).startsWith("/")){
										 		modelUrl = request.getContextPath()+modelUrlMap.get(modelName.getValue());
											}else{
												modelUrl = request.getContextPath()+"/"+modelUrlMap.get(modelName.getValue());
											}
										}
									}
								}
								if(modelUrl!=null && !"".equals(modelUrl)){
									request.setAttribute("modelUrl",modelUrl);
								}else{
									request.setAttribute("modelUrl","#");
								}
								request.setAttribute("modelName",modelName.getValue());
								request.setAttribute("ResultModelName",ResultModelName.getModelName(modelName.getValue())); 
							}
							String fdDocSubject= "";
							String fdModelName= "";
							String fdCategory= "";
							String fdUrl= "";
							String fdSummary = "";
							String fdFileName = "";
							
							String addStrField1="";
							String addStrField2="";
							String addStrField3="";
							String addStrField4="";
							String addStrField5="";
							String addStrField6="";
							String addStrField7="";
							if(addField1!=null){
								addStrField1=addField1.getValue();
							}
							if(addField2!=null){
								addStrField2=addField2.getValue();
							}
							if(addField3!=null){
								addStrField3=addField3.getValue();
							}
							if(addField4!=null){
								addStrField4=addField4.getValue();
							}
							if(addField5!=null){
								addStrField5=addField5.getValue();
							}
							if(addField6!=null){
								addStrField6=addField6.getValue();
							}
							if(addField7!=null){
								addStrField7=addField7.getValue();
							}
							if("com.landray.kmss.km.kmap.model.KmKmapMain".equals(modelName.getValue())){//知识地图文本是乱码，使其不显示。
								content=null;
							}
							if(subject!=null) {
								fdDocSubject = subject.getValue();
							} else if(title!=null) {
								fdDocSubject = title.getValue();
							}else if(fileName!=null) {
								fdDocSubject = fileName.getValue();
							}
							if(modelName!=null) {
								fdModelName=modelName.getValue();
								systemModelStr+=fdModelName;
							}
							request.setAttribute("systemModelStr",systemModelStr);
							if(category!=null) {
								fdCategory=category.getValue();
							}
							if(link!=null) {
								fdUrl=linkUrl;
							}
							
							if(fileName!=null) {
								fdFileName=fileName.getValue();
							}
							
							if(content!=null) {
								fdSummary +=content.getValue();
							}
							if(xmlContent!=null){
								fdSummary += xmlContent.getValue();
							}
							if(ekpDigest!=null) {
								fdSummary +=ekpDigest.getValue();
							}
							if(fullText!=null){
								fdSummary +=fullText.getValue();
							}
							if(!"true".equals(existPersonName)){
								if(addStrField1.contains("<font")){
									fdSummary+=addStrField1;
								}
								if(addStrField2.contains("<font")){
									fdSummary+=addStrField2;
								}
								if(addStrField3.contains("<font")){
									fdSummary+=addStrField3;
								}
								if(addStrField4.contains("<font")){
									fdSummary+=addStrField4;
								}
								if(addStrField5.contains("<font")){
									fdSummary+=addStrField5;
								}
								if(addStrField6.contains("<font")){
									fdSummary+=addStrField6;
								}
								if(addStrField7.contains("<font")){
									fdSummary+=addStrField7;
								}
							}
							//添加标签高亮
							StringBuilder stringBuilder = new StringBuilder();
							if(keyword!=null){
								String keywordVlaue = keyword.getValue();
								if (keywordVlaue != null && keywordVlaue != ""){
									if (keywordVlaue.contains(" ")){
										String[] keywords = keywordVlaue.split(" ");
										for(String keywordStr : keywords){
											if (keywordStr.contains("<font") || keywordStr.contains("<hn>")){
												stringBuilder.append(keywordStr).append(" ");
											}
										}
									}else{
										if (keywordVlaue.contains("<font") || keywordVlaue.contains("<hn>")){
											stringBuilder.append(keywordVlaue);
										}
									}
								}
							}
							request.setAttribute("keywordVlaue",stringBuilder.toString().trim());
							
							String regEx_html="<[^>]+>"; //定义HTML标签的正则表达式
							Pattern p_html=Pattern.compile(regEx_html,Pattern.CASE_INSENSITIVE); 
					        Matcher m_html=p_html.matcher(fdDocSubject); 
					        fdDocSubject=m_html.replaceAll(""); //过滤html标签 
					        m_html=p_html.matcher(fdCategory); 
					        fdCategory=m_html.replaceAll("");
					        
					        m_html=p_html.matcher(fdModelName); 
					        fdModelName=m_html.replaceAll("");
					        
					        m_html=p_html.matcher(fdUrl); 
					        fdUrl=m_html.replaceAll("");
					        
					        m_html=p_html.matcher(mainDocLink); 
					        mainDocLink=m_html.replaceAll("");
					        m_html=p_html.matcher(fdSummary);
					        String fdTempTitle = HtmlEscaper.escapeHTML2(fdDocSubject);
					        String fdIconTitle = fdTempTitle;
						%>
						<%if("true".equals(existPersonName)){%>
							<c:forEach items="${personSearchs}" var="personSearch" varStatus="vstatus">
								<c:if test="${(modelName == personSearch['module'])||(systemModelStr == personSearch['module'])}">
									<div class="lui_search_personWrapper">
							            <div class="lui_search_personHeader">
							            	<c:choose>
								            	<c:when test="${personSearch['path']!=null&&fn:contains(personSearch['path'],'method')}"> 
								                	<a class="person_img"><img src="${ LUI_ContextPath }${personSearch['path']}&fdId=<%=docId%>&size=b"></a>
								                </c:when>
							                	<c:otherwise><!--人头像扩展用 -->
							                		<a class="person_img"><img src=""></a>
							                	</c:otherwise>
							                </c:choose>
							                <div class="person_infoWrapper">
							                    <dl class="person_infoList">
							                        <dt><a href="javascript:void(0)" id="'<%=fdTempTitle %>'" onclick="readDoc('<%=fdModelName %>','<%=fdCategory %>','<%=fdUrl %>','<%=fdSystemName %>','<%=i %>');" class="name"  >
											        	<%=subject!=null?subject.getValue():title!=null?title.getValue():fileName!=null?fileName.getValue():""%></a>
											        </dt>
											        <c:if test="${personSearch['addFieldName1']!=null}"> 
												        <dd>
								                            <em>${personSearch['addFieldName1']}：</em>
								                            <span><%=addStrField1 %></span>
								                        </dd>
											        </c:if>
											        <c:if test="${personSearch['addFieldName2']!=null}"> 
								                        <dd>
								                            <em>${personSearch['addFieldName2']}：</em>
								                            <span><%=addStrField2 %></span>
								                        </dd>
							                        </c:if>
							                        <c:if test="${personSearch['addFieldName3']!=null}"> 
												        <dd>
								                            <em>${personSearch['addFieldName3']}：</em>
								                            <span><%=addStrField3 %></span>
								                        </dd>
											        </c:if>
											        <c:if test="${personSearch['addFieldName4']!=null}"> 
												        <dd>
								                            <em>${personSearch['addFieldName4']}：</em>
								                            <span><%=addStrField4 %></span>
								                        </dd>
											        </c:if>
											        <c:if test="${personSearch['addFieldName5']!=null}"> 
												        <dd>
								                            <em>${personSearch['addFieldName5']}：</em>
								                            <span><%=addStrField5 %></span>
								                        </dd>
											        </c:if>
											        <c:if test="${personSearch['addFieldName6']!=null}"> 
												        <dd>
								                            <em>${personSearch['addFieldName6']}：</em>
								                            <span><%=addStrField6 %></span>
								                        </dd>
											        </c:if>
											        <c:if test="${personSearch['addFieldName7']!=null}"> 
												        <dd class="personal_data">
								                            <em>${personSearch['addFieldName7']}：</em>
								                            <span><%=addStrField7 %></span>
								                        </dd>
											        </c:if>
							                    </dl>
							                </div>
							            </div>
							            <div class="lui_search_personInfo">
							                <em>${lfn:message('sys-ftsearch-db:search.search.modelNames')}
												<a href="${modelUrl}" onclick = "<% if("#".equals(request.getAttribute("modelUrl"))){
													out.print("return false;");
												}else{
													out.print("return true;");
												} %>" target="_blank" class="module">${ResultModelName}</a>
											</em>
							            </div>
							        </div>
								</c:if>
						    </c:forEach>
						<%}else{ %>
							<dl class="dl_c">
							<dt>
								<%if(fileName!=null){%>
						        	<script>
						        		document.write('<img src="styles/images/'+getIconNameByFileName('<%=fdIconTitle%>')+'" height="18" width="18" border="0" />');
						        	</script>
					        	<%}%>
						        	<a href="javascript:void(0)" id="'<%=fdTempTitle %>'" onclick="readDoc('<%=fdModelName %>','<%=fdCategory %>','<%=fdUrl %>','<%=fdSystemName %>','<%=i %>');" class="a_title"  >
						        	<%=subject!=null?subject.getValue():title!=null?title.getValue():fileName!=null?fileName.getValue():""%>
						        	</a>
					        	<%if(fileName!=null && link!=null){%>
					        		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						        	<a href="#" id="'<%=fdTempTitle %>'" onclick="readDoc('<%=fdModelName %>','<%=fdCategory %>','<%=mainDocLink %>','<%=fdSystemName %>','<%=i %>');" class="a_view">
						        		${lfn:message('sys-ftsearch-db:search.ftsearch.viewMainDoc')}</a>
						        <%}%>
							</dt>
								<dd>
									<div id="summary_<%=i%>" style="word-break:break-all;">
										<%=fdSummary%>
									</div>
								</dd>
								<dd class="dd2">
									${lfn:message('sys-ftsearch-db:search.search.modelNames')}
									<a href="${modelUrl}" onclick = "<% if("#".equals(request.getAttribute("modelUrl"))){
										out.print("return false;");
									}else{
										out.print("return true;");
									} %>" target="_blank">${ResultModelName}</a>
									<span>|</span>${lfn:message('sys-ftsearch-db:search.search.creators')}
									<%if(creator!=null && request.getAttribute("escaperStr").equals(creator.getValue())){ 
										out.println("<strong class = 'lksHit'>"+creator.getValue()+"</strong>");
									}else if(creator!=null){ 
										out.println(creator.getValue());
									}%> 
									<span>|</span>
									${lfn:message('sys-ftsearch-db:search.search.createDates')}<%if(createTime!=null){out.println(createTime.getValue());} %> 
									<c:if test="${keywordVlaue !='' && keywordVlaue != null}">
										<span>|</span>
											${lfn:message('sys-ftsearch-db:search.search.tags')}${keywordVlaue}
									</c:if>
								</dd>
							</dl>
						<%}}%>
						<!--分页-->
			         	<div>
		 					<list:paging currentPage="${queryPage.pageno }" pageSize="${queryPage.rowsize}"  totalSize="${queryPage.totalrows}"></list:paging>	 
			         	</div>
					</div><!-- end search_list -->
				</div>
				<div class="search_bottom" style="padding-left:105px; width:735px;height:33px">
					<input type="text" class="input_search" name="queryString" value="${queryString}"
						id="q6" onkeydown="if (event.keyCode == 13 && this.value !='') CommitSearch(1);">
					<a style="height:33px;cursor:pointer;" class="btn_search" onclick="CommitSearch(1);" title="<bean:message key="search.ftsearch.button.search" bundle="sys-ftsearch-db" />">
						<span>${lfn:message('sys-ftsearch-db:search.ftsearch.button.search')}</span>
					</a>
					
					<a style="cursor:pointer;" href="#" class="btn_b" title="${lfn:message('sys-ftsearch-db:search.ftsearch.search.on.result')}" onclick="search_on_result();"><span><em>${lfn:message('sys-ftsearch-db:search.ftsearch.search.on.result')}</em></span></a>
				</div>
			</div><!-- end search_con -->
			<%} %>
		</c:if>
		
		<div class="search_left">
			<div class="search_left_content">
			<dl class="dl_b" id="ftsearch_facet">
				<dt>${lfn:message('sys-ftsearch-db:search.ftsearch.search.catorgy')}</dt>
				<ul id="categoryTree" class="ztree" style='overflow:auto;min-height:0%;max-height:500px;'></ul>
			</dl>
			<dl class="dl_b" id="search_by_field">
				<dt>${ lfn:message('sys-ftsearch-db:search.ftsearch.search.fields')}</dt>
				<dd>
					<label for="">
						<input id='type_tag'
							type="checkbox" name="search_field" 
							<% if(fieldList==null || fieldList.contains("tag")) { %>
									checked
							<% } %>>${lfn:message('sys-ftsearch-db:search.ftsearch.field.tag')}
					</label>
				</dd>
			     <dd>
					<label for="">
						<input id='type_title'
							type="checkbox" name="search_field"
							<% if(fieldList==null || fieldList.contains("title")) { %>
									checked
							<% } %>
							 >${lfn:message('sys-ftsearch-db:search.ftsearch.field.title')}
					</label>
				</dd>
				<dd>
					<label for="">
						<input id='type_content'
							type="checkbox" name="search_field"
							<% if(fieldList==null || fieldList.contains("content")) { %>
									checked
							<% } %>>${lfn:message('sys-ftsearch-db:search.ftsearch.field.content')}
					</label>
				</dd>
				<dd>
					<label for=""> 
						<input id='type_attachment'
							type="checkbox" name="search_field" 
							<% if(fieldList==null || fieldList.contains("attachment")) { %>
									checked
							<% } %>>${lfn:message('sys-ftsearch-db:search.ftsearch.field.attachment')}
					</label>
				</dd>
			   <dd>
					<label for="">
						<input id='type_creator'
							type="checkbox" name="search_field"
							<% if(fieldList==null || fieldList.contains("creator")) { %>
									checked
							<% } %>>${lfn:message('sys-ftsearch-db:search.ftsearch.field.creator')}
					</label>
				</dd>
				<dd>
					<div class ="btnBar">
						<label for="">
							<input id='type_allselect'
								type="checkbox" name="all_field_select" onclick="selectSearchField()" 
									 <% if(fieldList==null || fieldList.size() ==5) { %>
										checked
									<% } %> >
								${lfn:message('sys-ftsearch-db:search.ftsearch.field.allSelect')}
						</label>
						<label for="">
							<a style="text-decoration: none;transition: all 0.3s ease;cursor:pointer;" class="btnSumbit" onclick="searchByField();" title="确定">确定</a>
						</label>
					</div>
				</dd>
			</dl>
			<dl class="dl_b">
				<dt><bean:message key="search.ftsearch.time.range" bundle="sys-ftsearch-db" /></dt>
				<dd><a href="#" onclick="searchByTime('day')" id="day">${lfn:message('sys-ftsearch-db:search.ftsearch.time.day')}</a></dd>
				<dd><a href="#" onclick="searchByTime('week')" id="week">${lfn:message('sys-ftsearch-db:search.ftsearch.time.week')}</a></dd>
				<dd><a href="#" onclick="searchByTime('month')" id="month">${lfn:message('sys-ftsearch-db:search.ftsearch.time.month')}</a></dd>
				<dd><a href="#" onclick="searchByTime('year')" id="year">${lfn:message('sys-ftsearch-db:search.ftsearch.time.year')}</a></dd>
				<dd><a href="#" onclick="searchByTime('')">${lfn:message('sys-ftsearch-db:search.ftsearch.time.nolimit')}</a></dd>
			</dl>
			<dl class="dl_b">
				<dt>${lfn:message('sys-ftsearch-db:search.ftsearch.relate.word')}</dt>
				<c:if test="${relevantwordList!=null}">
					<c:forEach items="${relevantwordList}" var="relevantWord"  varStatus="status">
					     <dd style="word-break:break-all;">
							<a  href="#" onclick="relatedSearchWord()" id="${relevantWord}">
								${relevantWord}
							</a>
						</dd>	 				
					</c:forEach>
				</c:if>
			</dl>
			</div>
		</div><!-- end search_left -->
		<div class="clear"></div>

		<div class="search_range" style="margin-left:180px">
			<p style=" width:120px;"><a style="cursor:pointer;" onclick="view_select_model();" id="_strHref" title="">${lfn:message('sys-ftsearch-db:search.ftsearch.search.range')}</a></p>
			<ul id="hidden_div" class="ul1">
				<li id="selectLi" style="display:none" class="li_opt">
					<label for="">
						<c:if test="${empty sysNameList || sysNameList==null}">
							<input type="checkbox" onclick="selectAllModel(this,'checkbox_model');" name="" />${lfn:message('sys-ftsearch-db:search.ftsearch.select.all')}
						</c:if>
					</label>
					<a style="cursor:pointer;" class="btn_c" onclick="CommitSearch(2);"><span><em>${lfn:message('sys-ftsearch-db:search.ftsearch.confirm')}</em></span></a>
				</li>
				<!-- 黄伟强  2013-4-25 多浏览器兼容 -->
				<li class="li_range">
					<h3>
						<c:if test="${empty sysNameList || sysNameList==null}">${lfn:message('sys-ftsearch-db:search.ftsearch.search.range2')}</c:if>
						<c:if test="${not empty sysNameList && sysNameList!=null}">
							<input type="checkbox" onclick="selectAllModel(this,'checkbox_model');" name="" /> EKP：
						</c:if>		
					</h3>
					<ul id="model_view" name="model_view" class="ul2">
						<c:forEach items="${entriesDesign}" var="element" varStatus="status">
							<c:if test="${element['flag']==true}">
								<li>
									<label for="">
										${element['title']}
									</label>
								 </li>
							</c:if> 
						</c:forEach>
					</ul>
					<ul id="model_select" name="model_select" class="ul2" style="display:none">
						<c:forEach items="${entriesDesign}" var="element" varStatus="status">
									<li>
										<label for="">
											<input id='element${status.index}' type="checkbox" name="checkbox_model"
											<c:if test="${element['flag']==true}">
											checked
											</c:if> 
											 onclick="selectOutSystemModel('checkbox_model')"  value='${element['modelName']}'>${element['title']}</label>
									 </li>
						</c:forEach>		
					</ul>
					<div class="clear"></div>
				</li>
					<c:forEach items="${otherSysDesign}" var="sysDesigns" varStatus="status">
					<li class="li_range c">
						<h3>
							<c:forEach items="${sysNameList}" var="sysNames" varStatus="status2">
								<c:if test="${status.index==status2.index}">
									<input type="checkbox" onclick="selectAllModel(this,'${sysNames }');" name="sysModel" />
											${sysNames }：
									<input type="hidden" id="${sysNames}_systemName" value="" name = 'systemName'>		
								</c:if> 
							</c:forEach>
						</h3>
						<ul name="multiSysmodel_view" class="ul2">
							<c:forEach items="${sysDesigns}" var="sysDesign" varStatus="status">
								<c:if test="${sysDesign['flag']==true}">
										<li>
											<label for="">
												${sysDesign['title']}
											</label>
										 </li>
								</c:if> 
							</c:forEach>
						</ul>
						<ul name="multiSysmodel_select"  style="display:none" class="ul2" id="multiSysmodel_select_id">
							<c:forEach items="${sysDesigns}" var="sysDesign" varStatus="status">
										<li>
											<label for="">
												<input id="${sysDesign['system'] }${status.index}" onclick="selectOutSystemModel('${sysDesign['system']}')" type="checkbox" name="${sysDesign['system'] }"
												<c:if test="${sysDesign['flag']==true}">
												checked
												</c:if> 
												 value='${sysDesign['modelName']}'>${sysDesign['title']}</label>
										 </li>
							</c:forEach>		
						</ul>
						<div class="clear"></div>
					</li>
				</c:forEach>
				</ul>
		</div>
	</div><!-- search_main end -->
</div>
<%@ include file="/sys/portal/template/default/footer.jsp"%>
</body>
</html>