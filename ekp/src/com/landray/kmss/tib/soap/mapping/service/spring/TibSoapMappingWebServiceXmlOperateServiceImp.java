package com.landray.kmss.tib.soap.mapping.service.spring;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.dom4j.Document;
import org.dom4j.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.sys.formula.parser.FormulaParser;
import com.landray.kmss.sys.metadata.exception.KmssUnExpectFieldException;
import com.landray.kmss.sys.metadata.interfaces.ISysMetadataParser;
import com.landray.kmss.tib.common.mapping.constant.TibCommonBussniessExection;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingFunc;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingFuncExt;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingFuncService;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingFuncXmlOperateService;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingModuleService;
import com.landray.kmss.tib.common.mapping.service.spring.TibCommonMappingBaseFuncXmlOperateServiceImpl;
import com.landray.kmss.tib.sys.core.util.DOMHelper;
import com.landray.kmss.util.StringUtil;

public class TibSoapMappingWebServiceXmlOperateServiceImp extends
TibCommonMappingBaseFuncXmlOperateServiceImpl implements
		ITibCommonMappingFuncXmlOperateService {
	
	private ITibCommonMappingFuncService tibCommonMappingFuncService;

	public void setTibCommonMappingFuncService(
			ITibCommonMappingFuncService tibCommonMappingFuncService) {
		this.tibCommonMappingFuncService = tibCommonMappingFuncService;
	}

	private ITibCommonMappingModuleService tibCommonMappingModuleService;

	public void setTibCommonMappingModuleService(
			ITibCommonMappingModuleService tibCommonMappingModuleService) {
		this.tibCommonMappingModuleService = tibCommonMappingModuleService;
	}

	private ISysMetadataParser sysMetadataParser;

	public void setSysMetadataParser(ISysMetadataParser sysMetadataParser) {
		this.sysMetadataParser = sysMetadataParser;
	}

	public void businessException(Document document,
			TibCommonMappingFunc tibCommonMappingFunc, IBaseModel mainModel)
			throws Exception {
		TibCommonMappingFuncExt exBusiness = tibCommonMappingFunc.getFdExtend().get(0);
		Boolean fdIsAssign = exBusiness.getFdIsAssign();
		Boolean fdIsIgnore = exBusiness.getFdIsIgnore();
		// 节点的值
		if (fdIsAssign) {
			sysMetadataParser.setFieldValue(mainModel,
					getEkpid(exBusiness.getFdAssignFieldid()),
					exBusiness.getFdAssignVal());
		}
		if (fdIsIgnore) {
			throw new TibCommonBussniessExection(exBusiness.getFdAssignVal());
		}
	}

	public boolean ifRegister(String templateName, String fdType)
			throws Exception {
		return tibCommonMappingModuleService.ifRegister(templateName, fdType);
	}

	public boolean ifRegister(IBaseModel model, String fdType) throws Exception {
		return tibCommonMappingModuleService.ifRegister(model, fdType);
	}


	public void programException(Exception e, TibCommonMappingFuncExt exProgram, IBaseModel mainModel) throws Exception {
		if (!(e instanceof TibCommonBussniessExection)) {
			// 程序异常处理
			Boolean fdIsAssign = exProgram.getFdIsAssign();
			Boolean fdIsIgnore = exProgram.getFdIsIgnore();
			if (fdIsAssign) {
				sysMetadataParser.setFieldValue(mainModel,
						getEkpid(exProgram.getFdAssignFieldid()),
						exProgram.getFdAssignVal());
			}
			if (fdIsIgnore) {
				throw new Exception("Program Exception");
			}
		} else {
			throw new Exception("Busniess Exception");
		}
	}
	
	
	//====================
	// 设置传出参数中table类型的参数,只支持a或a.b格式
	@Deprecated
	public void setFuncExportTable(Document document, IBaseModel baseModel)
			throws Exception {
//		// TODO 自动生成的方法存根
	}

	// 设置函数xml传出参数field内容或者structure下的field
	@Deprecated
	public void setFuncExportXml(Document document, IBaseModel mainModel)
			throws Exception {
//		// TODO 自动生成的方法存根
	}

	// 设置传入参数table类型参数field内容
	/***************************************************************************
	 * 注意row0的field中既有数据也有影射信息 基于表单中的明细表和表参数是一致的包括行数是一致的，只是有些字段可能映射的是非明细表中的字段
	 * 两种处理逻辑：1.映射的是自定义表单中明细表的字段，结果形如$a
	 * .b$,公式解析后得到的是list;2.映射的是非明细表的字段形如$a$,得到的是单一数据;
	 **************************************************************************/
	@Deprecated
	public void setFuncImportTableByFormula(Document document,
			FormulaParser parser) throws Exception {
		// TODO 自动生成的方法存根
	}

	// 设置函数xml传入参数field内容或者structure下的field
	@Deprecated
	public void setFuncImportXmlByFormula(Document document,
			FormulaParser parser) throws Exception {
		// TODO 自动生成的方法存根
	}


	public void setInputParamXmlByFormula(List<Element> nodeList,
			FormulaParser parser) throws Exception {
		// TODO 自动生成的方法存根
		if(nodeList==null||nodeList.isEmpty()){
			return ;
		}
		for(Element elem: nodeList){
//			System.out.println(elem);
			elem.content();
			List<Element> childrenElem=elem.elements();
			
			setInputParamXmlByFormula(childrenElem,parser);
			
		}
	}
	
	public void setInputInfo(NodeList nodeList, FormulaParser parser) {
		boolean first = true;
		Node firstNodeComment = null;
		Node firstNode = null;
		for (int i = 0; i < nodeList.getLength(); i++) {
			Node node = nodeList.item(i);
			// 如果是element 才处理循环
			if (node.getNodeType() == Node.ELEMENT_NODE) {
				// 获取comment 节点信息
				Node comment = findCommentNode(node);
				// 如果是首个节点
				if (first) {
					first = false;
					firstNodeComment = comment;
					firstNode = node;
				}
				// 如果注解为空,但是节点名称跟首节点一致可认为是明细表
				if (comment == null
						&& node.getNodeName().equals(firstNode.getNodeName())) {
					comment = firstNodeComment;
				}
				if (comment != null) {
					String textContent = comment.getTextContent();
					JSONObject jsonComment = analystsComment(textContent);
					dealEkpMapping(jsonComment, node, parser);
				}
				NodeList n_list = node.getChildNodes();
				setInputInfo(n_list, parser);
			}
		}
	}
	
	public void  dealEkpMapping(JSONObject jsonComment,Node node,FormulaParser parser){
		if(jsonComment==null){
			return ;
		}
		String ekpid=(String)jsonComment.get("ekpid");
//		获取ekpid
		if(StringUtil.isNotNull(ekpid)){
			Object fieldValue = parser.parseValueScript(filter(ekpid));
			if(fieldValue instanceof Collection){
				Iterator it = ((Collection) fieldValue).iterator();
				for (Iterator iterator = it; iterator
						.hasNext();) {
					Object rtn =  iterator.next();
					Node cloneNode=node.cloneNode(true);
					cloneNode.setTextContent((String)rtn);
					node.insertBefore(cloneNode, node);
				}
			}
			else{
				node.setTextContent(String.valueOf(fieldValue));
			}
		}
	}
	
	/**
	 * 把comment 的数据解析成json对象
	 * @return
	 */
	public JSONObject analystsComment(String comment){
		comment=StringUtils.deleteWhitespace(comment);
		Integer n=null;
		if((n= comment.indexOf("erp_web="))>0){
			comment=comment.substring(n+"erp_web=".length());
			String comment2 = comment.replaceAll("\\\\\"", "&quot;");
			JSONObject jsonObj=JSONObject.fromObject(comment2);
			return jsonObj;
		}
		//jsonObj.get
		//System.out.println(comment);
		return null;
		
	}
	
	/**
	 * 回溯查找commnet 节点
	 * @param curNode 当前节点
	 * @return
	 */
	public Node findCommentNode(Node curNode){
		
		if(curNode!=null){
			Node preNode =curNode.getPreviousSibling();
//			上一个节点就是尽头
			if(preNode==null){
				return null;
			}
			else if(preNode.getNodeType()==Node.ELEMENT_NODE){
				return null;
			}
			else if(preNode.getNodeType()==Node.COMMENT_NODE){
				return preNode;
			}else{
				return findCommentNode(preNode);
			}
		}
		return null;
	}
	

	public void setOutputParamXml(List<Element> nodeList, IBaseModel mainModel)
			throws Exception {

	}

	public List<TibCommonMappingFunc> getFuncList(String fdTemplateId,
			int fdInvokeType, String fdIntegrationType) throws Exception {
		// TODO 自动生成的方法存根
//		防止sql注入以及sql调整
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock("tibCommonMappingFunc.fdTemplateId=:fdTemplateId and tibCommonMappingFunc.fdInvokeType =:fdInvokeType and fdIntegrationType=:fdIntegrationType ");
		hqlInfo.setOrderBy("tibCommonMappingFunc.fdOrder asc");
		hqlInfo.setParameter("fdTemplateId", fdTemplateId);
		hqlInfo.setParameter("fdInvokeType", fdInvokeType);
		hqlInfo.setParameter("fdIntegrationType", fdIntegrationType);
		return (List<TibCommonMappingFunc>)tibCommonMappingFuncService.findList(hqlInfo);
	}
	
	public static void main(String[] args) throws Exception {
		
		InputStream in=TibSoapMappingWebServiceXmlOperateServiceImp.class.getResourceAsStream("respone.xml");
		String result=IOUtils.toString(in);
		TibSoapMappingWebServiceXmlOperateServiceImp spi= new TibSoapMappingWebServiceXmlOperateServiceImp();
		org.w3c.dom.Document doc= DOMHelper.parseXmlString(result);
		NodeList nodelist=doc.getElementsByTagName("Input");
		
	}

	/**
	 * 设置传出值
	 */
	public boolean setOutputInfo(NodeList nodeList, FormulaParser parser,
			IBaseModel mainModel, boolean flagSuccess) throws Exception {
		Map<String, List<DealStore>> m_store = new HashMap<String, List<DealStore>>();
		boolean flagBussiness = setOutputInfoToMap(m_store, nodeList, flagSuccess);
		// 进行插入数据库
		dealEkpOutput(mainModel, parser, m_store);
		return flagBussiness;
	}
	
	/**
	 * 把值放入map
	 * @param m_store
	 * @param nodeList
	 * @param flagSuccess
	 * @return
	 */
	public boolean setOutputInfoToMap(Map<String, List<DealStore>> m_store, NodeList nodeList,
			boolean flagSuccess) {
		boolean first = true;
		Node firstNodeComment = null;
		Node firstNode = null;
		// Map<String, List<DealStore>> m_store = new HashMap<String, List<DealStore>>();
		for (int i = 0; i < nodeList.getLength(); i++) {
			Node node = nodeList.item(i);
			// 如果是element 才处理循环
			if (node.getNodeType() == Node.ELEMENT_NODE) {
				// 获取comment 节点信息
				Node comment = findCommentNode(node);
				// 如果是首个节点
				if (first) {
					first = false;
					firstNodeComment = comment;
					firstNode = node;
				}
				// 如果注解为空,但是节点名称跟首节点一致可认为是明细表
				if (comment == null
						&& node.getNodeName().equals(firstNode.getNodeName())) {
					comment = firstNodeComment;
				}
				if (comment != null) {
					String textContent = comment.getTextContent();
					JSONObject jsonComment = analystsComment(textContent);
					// dealEkpMapping(jsonComment, node, parser);
					if (jsonComment == null) {
						continue;
					}
					String key = (String) jsonComment.get("ekpid");
					if (StringUtil.isNotNull(key)) {
						String mapkey = key + "_" + node.getNodeName();
						if (m_store.containsKey(mapkey)) {
							DealStore ds = new DealStore(node, key);
							m_store.get(mapkey).add(ds);
						} else {
							DealStore ds = new DealStore(node, key);
							List<DealStore> dl = new ArrayList<DealStore>(1);
							dl.add(ds);
							m_store.put(mapkey, dl);
						}
					}
					// 标记业务异常
					String suc = (String) jsonComment.get("isSuccess");
					String fail = (String) jsonComment.get("isFail");
					String text = node.getTextContent();
					String txt = StringUtils.deleteWhitespace(text);
					if (StringUtil.isNotNull(fail)) {
						String fa = StringUtils.deleteWhitespace(fail);
						if (fa.equals(txt)) {
							// 判断到有失败
							flagSuccess = flagSuccess && false;
						}
					}
					if (StringUtil.isNotNull(suc)) {
						String sc = StringUtils.deleteWhitespace(suc);
						if (sc.equals(txt)) {
							// 判断到有失败
							flagSuccess = flagSuccess && true;
						}
					}
				}
				NodeList n_list = node.getChildNodes();
				flagSuccess = setOutputInfoToMap(m_store, n_list,
						flagSuccess);
			}
		}
		// dealEkpOutput(mainModel, parser, m_store);
		return flagSuccess;
	}
	
	private void dealEkpOutput(IBaseModel mainModel, FormulaParser parser,
			Map<String, List<DealStore>> m_store) throws KmssUnExpectFieldException, Exception {
		for (String key : m_store.keySet()) {
			List<DealStore> ds = m_store.get(key);
			String ekpid = null;
			if (!ds.isEmpty()) {
				ekpid = getEkpid(ds.get(0).getEkpid());
			}
			List<String> pl = parseList(ds);

			if (pl.isEmpty()) {
				continue;
			}
			if (ekpid.indexOf(".") > -1) {
				sysMetadataParser.setFieldValue(mainModel, ekpid, pl);
			} else {
				String values = StringUtils.join(pl, ",");
				sysMetadataParser.setFieldValue(mainModel, ekpid, values);
			}
		}
	}
	
	private List<String> parseList(List<DealStore> m_store){
		List<String> p_list=new ArrayList<String>();
		for(DealStore ds :m_store ){
			String tc=ds.getNode().getTextContent();
			p_list.add(tc);
		}
		
		return p_list;
	}
	



	public class DealStore { 
        private Node node;
        private String ekpid;
        
        DealStore(){
        	
        }
        DealStore(Node node ,String ekpid){
        	this.node=node;
        	this.ekpid=ekpid;
        }
        
		public Node getNode() {
			return node;
		}
		public void setNode(Node node) {
			this.node = node;
		}
		public String getEkpid() {
			return ekpid;
		}
		public void setEkpid(String ekpid) {
			this.ekpid = ekpid;
		}
        
        
    }
	
}
