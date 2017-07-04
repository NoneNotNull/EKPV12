/**
 * 
 */
package com.landray.kmss.tib.common.log.actions;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.dao.HQLParameter;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.tib.common.log.model.TibCommonLogMain;
import com.landray.kmss.tib.common.log.service.ITibCommonLogMainService;
import com.landray.kmss.util.CriteriaUtil;
import com.landray.kmss.util.CriteriaValue;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.StringUtil;

/**
 * @author qiujh
 * @version 1.0 2014-1-10
 */
public class TibCommonLogMainIndexAction extends ExtendAction {
	protected ITibCommonLogMainService tibCommonLogMainService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		
		if(tibCommonLogMainService == null)
			tibCommonLogMainService = (ITibCommonLogMainService)getBean("tibCommonLogMainService");
		return tibCommonLogMainService;
	}

	/**
	 *日志管理树展现
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward uiTreeView(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		TimeCounter.logCurrentTime("Action-index", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			String type = request.getParameter("type");
			String path = "javascript:tibLoadList('/tib/common/log/tib_common_log_main/tibCommonLogMain_ui_include.jsp" +
					"?isError=!{error}&fdType=!{logType}&displayName=!{displayName}&subDisplayName=!{subDisplayName}');";
			JSONArray array = ((ITibCommonLogMainService)getServiceImp(request)).treeView(type, path);
			request.setAttribute("lui-source", array);
		} catch (Exception e) {
			messages.addError(e);
			e.printStackTrace();
		}

		TimeCounter.logCurrentTime("Action-index", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("lui-source", mapping, form, request,
					response);
		}
	}

	public ActionForward searchView(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-add", true, getClass());
		return getActionForward("searchView", mapping, form, request, response);
	}
	
	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		// TODO 自动生成的方法存根
		 super.changeFindPageHQLInfo(request, hqlInfo);
		 
//			 组装页面上的数据
		 StringBuffer whereBlock=new StringBuffer(hqlInfo.getWhereBlock()==null?"":hqlInfo.getWhereBlock());
		 List<ParameterInfo> pfs=getParameters();
		 List<HQLParameter> realList=new ArrayList<HQLParameter>();
//			 拼接hql
		 for(ParameterInfo pf:pfs){
			 try{
			 String requestValue=request.getParameter(pf.getRequestName());
			 if(StringUtil.isNotNull(requestValue)){
				 if(ParameterInfo.PARSER_TYPE_DATE.equalsIgnoreCase(pf.getType())){
					 Date parse= DateUtil.convertStringToDate(requestValue, null);
					 if(parse!=null){
						 pf.setParseValue(parse);
						 if(StringUtil.isNotNull(whereBlock.toString())){
							 whereBlock.append(" and ");
						 }
						 whereBlock.append( pf.getModelName()+" "  );
						 whereBlock.append( pf.getCondition()+" "  );
						 whereBlock.append(" :" );
						 whereBlock.append( pf.getHqlName()+" "  );
						 realList.add(new HQLParameter(pf.getHqlName(),parse));
					 }
				 }
				 else if(ParameterInfo.PARSER_TYPE_STRING.equalsIgnoreCase(pf.getType())){
					 pf.setParseValue(requestValue);
					 if(StringUtil.isNotNull(whereBlock.toString())){
						 whereBlock.append(" and ");
					 }
					 whereBlock.append( pf.getModelName()+" " );
					 whereBlock.append( pf.getCondition()+" " );
					 whereBlock.append(" :" );
					 whereBlock.append( pf.getHqlName() );
					 if("like".equalsIgnoreCase(pf.getCondition())){
						 realList.add(new HQLParameter(pf.getHqlName(),"%"+requestValue+"%"));
					 }
					 else{
					 realList.add(new HQLParameter(pf.getHqlName(),requestValue));
					 }
				 }
			 }
			 }catch (Exception e) {
				// TODO: handle exception
				 super.log.debug("转化数据出错~!");
			}
		 }
		 hqlInfo.setWhereBlock(whereBlock.toString());
		 hqlInfo.setParameter(realList);
		// 新UED查询
		CriteriaUtil.buildHql(new CriteriaValue(request), hqlInfo,
				TibCommonLogMain.class);
	}
	
	/**
	  * 获取需要收集的request
	  * @return
	  */
	 public List<ParameterInfo> getParameters(){
		List<ParameterInfo> rtnList= new ArrayList<ParameterInfo>();
		rtnList.add( new ParameterInfo("fdStartTime1","fdStartTime","fdStartTime1",null,ParameterInfo.PARSER_TYPE_DATE,">="));
		rtnList.add( new ParameterInfo("fdStartTime2","fdStartTime","fdStartTime2",null,ParameterInfo.PARSER_TYPE_DATE,"<=" ));
		rtnList.add( new ParameterInfo("fdEndTime1","fdEndTime","fdEndTime1",null,ParameterInfo.PARSER_TYPE_DATE,">="));
		rtnList.add( new ParameterInfo("fdEndTime2","fdEndTime","fdEndTime2",null,ParameterInfo.PARSER_TYPE_DATE,"<="));
		rtnList.add( new ParameterInfo("fdPoolName","fdPoolName","fdPoolName",null,ParameterInfo.PARSER_TYPE_STRING,"like"));
		rtnList.add( new ParameterInfo("isError","fdIsErr","fdIsErr",null,ParameterInfo.PARSER_TYPE_STRING,"="));
		rtnList.add( new ParameterInfo("fdType","fdLogType","fdLogType",null,ParameterInfo.PARSER_TYPE_STRING,"="));
		return rtnList;
	 }
	 
	 /**
	  * hql参数组装,request参数组装
	  * 仅仅只提供内部调用,就直接内部类
	  * @author 
	  *
	  */
	 class ParameterInfo{
		 public static final String PARSER_TYPE_DATE="date";
		 public static final String PARSER_TYPE_STRING="string";
		 
		public ParameterInfo(String requestName, String modelName,
				String hqlName, Object parseValue,String type,String condition) {
			this.requestName = requestName;
			this.modelName = modelName;
			this.hqlName = hqlName;
			this.parseValue = parseValue;
			this.type=type;
			this.condition=condition;
		}
		private  String requestName;
		private String modelName;
		private String hqlName;
		private Object parseValue;
		private String type ;
		private String condition;
		
		public String getCondition() {
			return condition;
		}
		public void setCondition(String condition) {
			this.condition = condition;
		}
		public String getType() {
			return type;
		}
		public void setType(String type) {
			this.type = type;
		}
		public String getRequestName() {
			return requestName;
		}
		public void setRequestName(String requestName) {
			this.requestName = requestName;
		}
		public String getModelName() {
			return modelName;
		}
		public void setModelName(String modelName) {
			this.modelName = modelName;
		}
		public String getHqlName() {
			return hqlName;
		}
		public void setHqlName(String hqlName) {
			this.hqlName = hqlName;
		}
		public Object getParseValue() {
			return parseValue;
		}
		public void setParseValue(Object parseValue) {
			this.parseValue = parseValue;
		}
	 }
	
}
