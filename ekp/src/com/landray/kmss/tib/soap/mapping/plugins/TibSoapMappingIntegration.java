package com.landray.kmss.tib.soap.mapping.plugins;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.transaction.TransactionStatus;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.sys.formula.parser.FormulaParser;
import com.landray.kmss.tib.common.mapping.constant.Constant;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingFunc;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingFuncExt;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingMain;
import com.landray.kmss.tib.common.mapping.plugins.IBaseTibCommonMappingIntegration;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingFuncService;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingFuncXmlOperateService;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingMainService;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingModuleService;
import com.landray.kmss.tib.sys.core.util.DOMHelper;
import com.landray.kmss.tib.sys.soap.connector.interfaces.ITibSysSoap;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapMain;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapMainService;
import com.landray.kmss.tib.sys.soap.connector.util.header.SoapInfo;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.TransactionUtils;

/**
 * 模块拆解,代码级别模块分离使用这个扩展点集成类;
 * 
 * @author zhangtian date :2012-10-9 下午06:14:24
 */
public class TibSoapMappingIntegration implements IBaseTibCommonMappingIntegration {

	private Log log = LogFactory.getLog(this.getClass());

	public HQLInfo findSettingNameHQLByTempId(String fdTemplateId,String fdIntegrationType) {
		HQLInfo webhqlInfo = new HQLInfo();
		webhqlInfo.setSelectBlock("tibCommonMappingFunc.fdRefName ,tibCommonMappingFunc.fdInvokeType ");
		webhqlInfo.setWhereBlock("tibCommonMappingFunc.fdTemplateId=:fdTemplateId and tibCommonMappingFunc.fdIntegrationType=:fdIntegrationType");
		webhqlInfo.setOrderBy("tibCommonMappingFunc.fdInvokeType asc,tibCommonMappingFunc.fdOrder asc");
		webhqlInfo.setParameter("fdTemplateId", fdTemplateId);
		webhqlInfo.setParameter("fdIntegrationType", fdIntegrationType);
		return webhqlInfo;
	}

	/**
	 * 代码拆解 \third\erp\ekpweb\webEkpFormEventInclude.jsp 的代码拆解到扩展点中
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public List<TibCommonMappingFunc> getFormEventIncludeList(
			HttpServletRequest request) throws Exception {

		// 在编辑页面,驳回页面也能获取到模板ID也能获取模板
		String fdTemplateId_web = "";// =request.getParameter("kmReviewMainForm.fdTemplateId");//基于每个新建文档时都会传递模板id，且都为fdTemplateId
		ITibCommonMappingModuleService tibCommonMappingModuleService = (ITibCommonMappingModuleService) SpringBeanUtil
				.getBean("tibCommonMappingModuleService");
		// 使用缓存记录的modelName;
		tibCommonMappingModuleService.initRegisterModelHash();
		ConcurrentHashMap<String, Map<String, Object>> tibCommonMappingModuleList = tibCommonMappingModuleService
				.getRegisterModelHash();
		if (tibCommonMappingModuleList.isEmpty()) {
			fdTemplateId_web = null;
		} else {
			Iterator<String> modelSet = tibCommonMappingModuleList.keySet()
					.iterator();
			while (modelSet.hasNext()) {
				String modelName = modelSet.next();
				if ("init".equals(modelName)) {
					continue;
				}
				try{
					Object obj = Class.forName(modelName).newInstance();
					if (obj instanceof IBaseModel) {
						Class formClass = (Class) PropertyUtils.getProperty(obj,
								"formClass");
						String formName = formClass.getSimpleName();
						// 注意，如果form 的model 为KmReviewForm 那么 对应的form 在struct
						// 里面配置一定要为 kmReviewForm;首字母小写
						formName = formName.substring(0, 1).toLowerCase()
								+ formName.substring(1, formName.length());
						Object resForm = request.getAttribute(formName);
						if (resForm != null) {
							if (PropertyUtils.isReadable(resForm, "fdTemplateId")) {
								fdTemplateId_web = (String) PropertyUtils
										.getProperty(resForm, "fdTemplateId");
							}
						} else {
							// Logger.warn("ERP组件检查到当前request 找不到属性为："+resForm+
							// "的数据,所以获取不到流程模板Id");
						}
					}
				}catch (Exception e) {
					e.printStackTrace();
					Log log=LogFactory.getLog(this.getClass());
					log.warn("不存在modelName:"+modelName+" 的类,请到SOAP应用注册模块取消注册 ");
				}
			}
		}
		List<TibCommonMappingFunc> tibCommonMappingFuncList = new ArrayList<TibCommonMappingFunc>();
		// 若模版Id不存在，则return 空的list
		if (StringUtil.isNull(fdTemplateId_web)) {
			return tibCommonMappingFuncList;
		}
		ITibCommonMappingMainService tibCommonMappingMainService = (ITibCommonMappingMainService) SpringBeanUtil
				.getBean("tibCommonMappingMainService");

		HQLInfo hqlInfo=new HQLInfo();
		hqlInfo.setWhereBlock(" tibCommonMappingMain.fdTemplateId= :fdTemplateId_web ");
		hqlInfo.setParameter("fdTemplateId_web", fdTemplateId_web);
		List<TibCommonMappingMain> list = tibCommonMappingMainService.findList(hqlInfo);
		
		if (!list.isEmpty()) {
			TibCommonMappingMain tibCommonMappingMain = list.get(0);
			boolean use = tibCommonMappingModuleService.ifRegister(
					tibCommonMappingMain.getFdMainModelName(),
					Constant.FD_TYPE_SOAP);// 判断是否注册并启用的了
			if (use) {
				tibCommonMappingFuncList = tibCommonMappingMain
						.getFdFormEventFunctionList();// 得到表单事件的函数列表
				List<TibCommonMappingFunc> erptempList = new ArrayList<TibCommonMappingFunc>();
				// 一般加入模板不会太多，
				for (TibCommonMappingFunc tempfunc : tibCommonMappingFuncList) {
					// 加入webservice判断，当主模板中不存在对应模板存在,那么久不加入引入列表当中
					if (Constant.FD_TYPE_SOAP.equals(tempfunc
							.getFdIntegrationType())) {
						erptempList.add(tempfunc);
					}
				}
				return erptempList;
			}
		}
		return null;
	}

	/**
	 * invokeType 3为机器人节点类型，还有表单事件，表单删除事件也同样可以用
	 */
	public List<Map<String, String>> getSettingNameInfo(String templateId,
			String invokeType) throws Exception {
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>(1);
		ITibCommonMappingFuncService service = (ITibCommonMappingFuncService) SpringBeanUtil
				.getBean("tibCommonMappingFuncService");

		// 防止sql注入
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock(" tibCommonMappingFunc.fdTemplateId=:fdTemplateId and " +
				"tibCommonMappingFunc.fdInvokeType=:fdInvokeType and " +
				"tibCommonMappingFunc.fdIntegrationType=:fdIntegrationType ");
		hqlInfo.setOrderBy(" tibCommonMappingFunc.fdOrder asc");
		hqlInfo.setParameter("fdTemplateId", templateId);
		hqlInfo.setParameter("fdInvokeType", Integer.valueOf(invokeType));
		hqlInfo.setParameter("fdIntegrationType", Constant.FD_TYPE_SOAP);
		List<TibCommonMappingFunc> tibCommonMappingFuncList = service.findList(hqlInfo);
		for (int i = 0; i < tibCommonMappingFuncList.size(); i++) {
			Map<String, String> map = new HashMap<String, String>(1);
			TibCommonMappingFunc tibCommonMappingFunc = tibCommonMappingFuncList.get(i);
			map.put("text", tibCommonMappingFunc.getFdRefName());
			map.put("value", tibCommonMappingFunc.getFdId());
			rtnList.add(map);
		}
		return rtnList;
	}

	public IBaseModel addMethodInvoke(IBaseModel baseModel) throws Exception {
		return executeInitModel(baseModel,Integer.valueOf(Constant.INVOKE_TYPE_FORMSAVE));
	}

	private IBaseModel executeInitModel(IBaseModel model,Integer findType) throws Exception {
		ITibCommonMappingFuncXmlOperateService tibCommonMappingFuncXmlOperateService = null;
		TibCommonMappingFunc tibCommonMappingFunc = null;
		try {
			ITibCommonMappingModuleService tibCommonMappingModuleService = (ITibCommonMappingModuleService) SpringBeanUtil
					.getBean("tibCommonMappingModuleService");
			// 取得webservice 的实现
			tibCommonMappingFuncXmlOperateService = (ITibCommonMappingFuncXmlOperateService) SpringBeanUtil
					.getBean("soaptibCommonWebServiceXmlOperateServiceImp");
			ITibSysSoap tibSysSoap = (ITibSysSoap) SpringBeanUtil.getBean("tibSysSoap");
			ITibSysSoapMainService tibSysSoapMainService=(ITibSysSoapMainService)SpringBeanUtil.getBean("tibSysSoapMainService");
			String modelName = ModelUtil.getModelClassName(model);
			String fdModelTemFieldName = tibCommonMappingModuleService
					.getFdModelTemFieldName(modelName);
			String fdTemplateId = (String) PropertyUtils.getProperty(model,
					fdModelTemFieldName + ".fdId");// 一般为fdTemplate.fdId
			List<TibCommonMappingFunc> tibCommonMappingFuncList = tibCommonMappingFuncXmlOperateService
					.getFuncList(fdTemplateId,findType, Constant.FD_TYPE_SOAP);// 按顺序得到保存事件需要执行的函数列表
			if (tibCommonMappingFuncList == null || tibCommonMappingFuncList.isEmpty())
				return model;// 如果没有函数则返回
			
			FormulaParser formulaParser = FormulaParser.getInstance(model);// 根据model得到公式解析器
			for (int i = 0; i < tibCommonMappingFuncList.size(); i++) {
				tibCommonMappingFunc = tibCommonMappingFuncList.get(i);
				
				org.w3c.dom.Document doc= DOMHelper.parseXmlString(tibCommonMappingFunc
						.getFdRfcParamXml());
				NodeList n_list=doc.getElementsByTagName("web");
				org.w3c.dom.Node curNode=DOMHelper.getElementNode(n_list, 0);
				
				org.w3c.dom.Node attrNode=curNode.getAttributes().getNamedItem("ID");
				String attrId =attrNode.getTextContent();
				if(StringUtil.isNull(attrId)){
					log.error("Soap 模板中配置的web节点ID属性 没有找到对应的配置信息!");
					continue;
				}
				TibSysSoapMain tibSysSoapMain= (TibSysSoapMain)tibSysSoapMainService.findByPrimaryKey(attrId,null,true);
				
				NodeList nodelist=doc.getElementsByTagName("Input");
				tibCommonMappingFuncXmlOperateService.setInputInfo(nodelist, formulaParser);
				String resetXml =DOMHelper.nodeToString((org.w3c.dom.Node)doc);
				
				SoapInfo soapInfo =new SoapInfo();
				soapInfo.setRequestXml(resetXml);
				soapInfo.setTibSysSoapMain(tibSysSoapMain);
				
				/***********/
				Document res_doc=tibSysSoap.inputToOutputDocument(soapInfo);
				/***********/
				
				
				/*******old ******
				String result=tibSysSoap.inputToAllXml(soapInfo);
				String[] mergeXml=new String[4];
				mergeXml[0]="<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
				mergeXml[1]="<web ID=\"!{fdId}\">".replace("!{fdId}", tibCommonMappingFunc.getFdId());
				mergeXml[2]=result;
				mergeXml[3]="</web>";
				String real_result=StringUtils.join(mergeXml);
				org.w3c.dom.Document res_doc= DOMHelper.parseXmlString(real_result);
				************************/
				
				
				
				
				NodeList res_nList=res_doc.getElementsByTagName("Output");
				boolean flagBussiness=tibCommonMappingFuncXmlOperateService.setOutputInfo(res_nList,formulaParser,model,true);

				NodeList fault_nList= res_doc.getElementsByTagName("Fault");
//				程序异常
				if(fault_nList.getLength()>0){
					tibCommonMappingFuncXmlOperateService.setOutputInfo(fault_nList, formulaParser, model,true);
					Node faultNode=DOMHelper.getElementNode(fault_nList, 0);
					String faultStr=DOMHelper.nodeToString(faultNode, true);
					throw new Exception("WEBSERVICE返回错误Fault:\n"+faultStr);
				}
				//						发生了业务异常进行处理
				if(!flagBussiness){
					tibCommonMappingFuncXmlOperateService.businessException(null, tibCommonMappingFunc, model);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			TibCommonMappingFuncExt exProgram = tibCommonMappingFunc.getFdExtend().get(1);
			tibCommonMappingFuncXmlOperateService.programException(e, exProgram, model);
		}
		return model;
	}

	public void deleteMethodInvoke(IBaseModel model) throws Exception {
		executeInitModel(model,Integer.valueOf(Constant.INVOKE_TYPE_FORMDEL));
	}

	public IBaseModel updateMethodInvoke(IBaseModel model) throws Exception {
		// TODO 自动生成的方法存根
		TransactionStatus status = null;
		try {
			if (null == status) {
				status = TransactionUtils.beginNewReadTransaction();
			}
			Object servie = SpringBeanUtil.getBean(model.getSysDictModel()
					.getServiceBean());
			Method method = servie.getClass().getMethod("findByPrimaryKey",
					String.class);
			IBaseModel result = (IBaseModel) method.invoke(servie, model
					.getFdId());
			String docStatus = null;
			if (PropertyUtils.isReadable(result, "docStatus")) {
				docStatus = (String) PropertyUtils.getProperty(result,
						"docStatus");
			}
			TransactionUtils.getTransactionManager().commit(status);
			status = null;
			// 驳回状态可能存在不驳回到起草节点,===
			if (SysDocConstant.DOC_STATUS_DRAFT.equals(docStatus)
					|| SysDocConstant.DOC_STATUS_REFUSE.equals(docStatus)) {
				executeInitModel(model,Integer.valueOf(Constant.INVOKE_TYPE_FORMSAVE));
			}
		} finally {
		}
		return model;
	}

}
