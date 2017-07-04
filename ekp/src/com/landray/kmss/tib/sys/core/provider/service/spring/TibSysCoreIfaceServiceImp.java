package com.landray.kmss.tib.sys.core.provider.service.spring;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.json.simple.JSONObject;
import org.w3c.dom.Document;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.dao.HQLWrapper;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.common.service.BaseServiceImp;
import com.landray.kmss.tib.common.inoutdata.service.ITibCommonInoutdataService;
import com.landray.kmss.tib.sys.core.provider.forms.TibSysCoreIfaceForm;
import com.landray.kmss.tib.sys.core.provider.interfaces.ITibUnitInterface;
import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreIface;
import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreIfaceImpl;
import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreNode;
import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreTag;
import com.landray.kmss.tib.sys.core.provider.service.ITibSysCoreIfaceImplService;
import com.landray.kmss.tib.sys.core.provider.service.ITibSysCoreIfaceService;
import com.landray.kmss.tib.sys.core.provider.service.ITibSysCoreTagService;
import com.landray.kmss.tib.sys.core.provider.util.ProviderXmlOperation;
import com.landray.kmss.tib.sys.core.provider.vo.IfaceImplInfo;
import com.landray.kmss.tib.sys.core.provider.vo.IfaceInfo;
import com.landray.kmss.tib.sys.core.util.DOMHelper;
import com.landray.kmss.tib.sys.core.util.FileHelper;
import com.landray.kmss.tib.sys.core.util.TibSysCoreUtil;
import com.landray.kmss.util.HQLUtil;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

/**
 * provider接口信息业务接口实现
 * 
 * @author
 * @version 1.0 2013-03-27
 */
public class TibSysCoreIfaceServiceImp extends BaseServiceImp implements
		ITibSysCoreIfaceService {

	private ITibSysCoreTagService tibSysCoreTagService ;
	
	/**
	 * notes: 当FdIfaceTagVos字段
	 * 有:签字符串时候,检查数据库中是否存在 
	 * 无:不存在则创建新标签model
	 */
	@Override
	public IBaseModel convertFormToModel(IExtendForm form, IBaseModel model,
			RequestContext requestContext) throws Exception {
		IBaseModel baseModel = super.convertFormToModel(form, model,
				requestContext);
		String s = ((TibSysCoreIfaceForm) form).getFdIfaceTagVos();
		List<TibSysCoreTag> tags = refreshTagData(s.split(" "));
		TibSysCoreIface iface = (TibSysCoreIface) baseModel;
		if (iface.getFdIfaceTags() != null) {
			// 清楚当前model集合
			iface.getFdIfaceTags().clear();
			// 增加集合
			iface.getFdIfaceTags().addAll(tags);
		} else {
			iface.setFdIfaceTags(new ArrayList<TibSysCoreTag>());
			iface.getFdIfaceTags().addAll(tags);
		}
		return baseModel;
	}

	@Override
	public IExtendForm convertModelToForm(IExtendForm form, IBaseModel model,
			RequestContext requestContext) throws Exception {

		IExtendForm formInfo = super.convertModelToForm(form, model,
				requestContext);

		String voStr = parseFormVos(model);
		((TibSysCoreIfaceForm) formInfo).setFdIfaceTagVos(voStr);

		return formInfo;
	}
	
	@Override
	public void delete(IBaseModel modelObj) throws Exception {
		((TibSysCoreIface) modelObj).getFdIfaceTags().clear();
		super.delete(modelObj);
	}
	
	private void refreshCoreTag(List<TibSysCoreTag> tags) throws Exception{
		if(tags!=null&&!tags.isEmpty()){
			for(TibSysCoreTag tag:tags){
				tibSysCoreTagService.update(tag);
			}
		}
	}
	
	
	
	
	

	private String parseFormVos(IBaseModel model) {
		List<String> vos = new ArrayList<String>(1);
		List<TibSysCoreTag> tags = ((TibSysCoreIface) model).getFdIfaceTags();
		for (TibSysCoreTag tag : tags) {
			if (StringUtil.isNotNull(tag.getFdTagName())) {
				vos.add(tag.getFdTagName());
			}
		}
		return StringUtils.join(vos, " ");
	}

	private List<TibSysCoreTag> refreshTagData(String[] tagName)
			throws Exception {
		ITibSysCoreTagService tibSysCoreTagService = (ITibSysCoreTagService) SpringBeanUtil
				.getBean("tibSysCoreTagService");
		HQLInfo hqlInfo = new HQLInfo();
		List<String> tagList = new ArrayList<String>(1);
		CollectionUtils.addAll(tagList, tagName);
		// 查找数据库是否存在值
		HQLWrapper wapper = HQLUtil
				.buildPreparedLogicIN(" fdTagName ", tagList);
		hqlInfo.setWhereBlock(wapper.getHql());
		hqlInfo.setParameter(wapper.getParameterList());

		List<TibSysCoreTag> tagModelList = tibSysCoreTagService
				.findList(hqlInfo);
		
		tagModelList = fillTagModel(tagModelList, tagName);

		return tagModelList;
	}

	// 填充值
	private List<TibSysCoreTag> fillTagModel(List<TibSysCoreTag> exist,
			String[] tagName) throws Exception {
		ITibSysCoreTagService tibSysCoreTagService = (ITibSysCoreTagService) SpringBeanUtil
				.getBean("tibSysCoreTagService");
		if (exist == null) {
			exist = new ArrayList<TibSysCoreTag>(1);
		}
		for (String s : tagName) {
			Iterator<TibSysCoreTag> it = exist.iterator();
			boolean flag = true;
			boolean isIn = false;
			// 判断是否存在
			while (it.hasNext() && flag) {
				TibSysCoreTag tag = (TibSysCoreTag) it.next();
				if (s.equals(tag.getFdTagName())) {
					// 存在则下标记且结束
					isIn = true;
					flag = false;
				}
			}
			// 不存在则增加
			if (!isIn && StringUtil.isNotNull(s)) {
				TibSysCoreTag coreTag = new TibSysCoreTag();
				coreTag.setFdTagName(s);
				// add to db
				exist.add(coreTag);
			}
		}
		return exist;
	}

	public ITibSysCoreTagService getTibSysCoreTagService() {
		return tibSysCoreTagService;
	}

	public void setTibSysCoreTagService(ITibSysCoreTagService tibSysCoreTagService) {
		this.tibSysCoreTagService = tibSysCoreTagService;
	}
	
	private List<IfaceInfo> getIfaceList(String key, Integer count) throws Exception {
		List<IfaceInfo> ifaceInfoList = new ArrayList<IfaceInfo>();
		// 查找所有配置的provider
		HQLInfo hqlInfo = new HQLInfo();
		String whereBlock = "tibSysCoreIface.fdIfaceControl = :fdIfaceControl";
		hqlInfo.setParameter("fdIfaceControl", true);
		if (StringUtil.isNotNull(key)) {
			whereBlock += " and tibSysCoreIface.fdIfaceKey = :fdIfaceKey";
			hqlInfo.setParameter("fdIfaceKey", key);
		}
		hqlInfo.setWhereBlock(whereBlock);
		List<TibSysCoreIface> ifaceList = this.findList(hqlInfo);
		for (int i = 0, len = ifaceList.size(); i < len; i++) {
			// 控制多少条记录
			if (i == count) {
				break;
			}
			TibSysCoreIface iface = ifaceList.get(i);
			IfaceInfo ifaceInfo = new IfaceInfo(iface.getFdIfaceName(), 
					iface.getFdIfaceKey(), iface.getFdIfaceType(), iface.getFdNote(), 
					iface.getFdIfaceTagsStr(), "", iface.getFdControlPattern());
			ifaceInfoList.add(ifaceInfo);
		}
		return ifaceInfoList;
	}

	public String getIfaceJson(String key, String countStr) throws Exception {
		String returnJson = "";
		if (StringUtil.isNotNull(countStr)){
			int count = Integer.parseInt(countStr);
			returnJson = getIfaceListJson(count);
		}
		if (StringUtil.isNotNull(key)) {
			returnJson = getIfaceJson(key);
		}
		return returnJson;
	}
	
	private String getIfaceListJson(int count) throws Exception {
		List<IfaceInfo> funList = getIfaceList(null, count);
		JSONObject result = new JSONObject();
		for (int i = 0, lenI = funList.size(); i < lenI; i++) {
			IfaceInfo ifaceInfo = funList.get(i);
			JSONObject inResult = new JSONObject();
			inResult.put("fdName", ifaceInfo.getFdName());
			inResult.put("fdKey", ifaceInfo.getFdKey());
			inResult.put("fdType", ifaceInfo.getFdType());
			inResult.put("fdControlPattern", ifaceInfo.getFdControlPattern());
			result.put(i + 1, inResult);
		}
		return result.toString();
	}
	
	private String getIfaceJson(String key) throws Exception {
		JSONObject result = new JSONObject();
		List<IfaceInfo> ifaceInfoList = getIfaceList(key, 1);
		if (!ifaceInfoList.isEmpty()) {
			IfaceInfo ifaceInfo = ifaceInfoList.get(0);
			result.put("fdName", ifaceInfo.getFdName());
			result.put("fdKey", ifaceInfo.getFdKey());
			result.put("fdType", ifaceInfo.getFdType());
			result.put("fdNote", ifaceInfo.getFdNote());
			result.put("fdInfoExt", ifaceInfo.getFdInfoExt());
			result.put("fdIfaceTags", ifaceInfo.getFdIfaceTags());
			result.put("fdControlPattern", ifaceInfo.getFdControlPattern());
		}
		return result.toString();
	}

	public String getIfaceJsonXml(String key) throws Exception {
		TibSysCoreIface iface = findIfaceByKey(key);
		if (iface == null) {
			return null;
		} 
		return iface.getFdIfaceXmlTrans();
	}
	
	public void sortList(List<TibSysCoreNode> nodeList) {
		Collections.sort(nodeList, new Comparator<TibSysCoreNode>() {
			public int compare(TibSysCoreNode o1, TibSysCoreNode o2) {
				String lv1 = o1.getFdNodeLevel();
				String lv2 = o2.getFdNodeLevel();
				Integer it1 = Integer.valueOf(lv1);
				Integer it2 = Integer.valueOf(lv2);
				return it1 - it2;
			}
		});
	}
	

	/**
	 * 根据key查找目标数据库数据
	 * 
	 * @param key
	 * @return
	 * @throws Exception
	 */
	public TibSysCoreIface findIfaceByKey(String key) throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock(" fdIfaceKey = :fdIfaceKey and fdIfaceControl = :fdIfaceControl");
		hqlInfo.setParameter("fdIfaceKey", key);
		hqlInfo.setParameter("fdIfaceControl", true);
		List<TibSysCoreIface> results = findList(hqlInfo);
		if (results != null && !results.isEmpty()) {
			return results.get(0);
		} else {
			return null;
		}

	}

	public boolean isControl(String inXml) throws Exception {
		Document doc = ProviderXmlOperation.stringToDoc(inXml);
		String key = TibSysCoreUtil.parseKey(doc);
		TibSysCoreIface iface = findIfaceByKey(key);
		if (iface == null) {
			return false;
		} else {
			return true;
		}
	}

	public String dataExecute(String tibDataFill) throws Exception {
		ITibUnitInterface tibUnitIface = (ITibUnitInterface) SpringBeanUtil
				.getBean("tibUnitInterface");
		// 数据执行
		//String executeBackXml = tibUnitIface.executeToStr(tibDataFill);
		String executeBackXml = "";
		Object executeBackObj = tibUnitIface.executeToData(tibDataFill);
		String reg = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
		if (executeBackObj instanceof String) {
			// 单实现
			executeBackXml = ((String)executeBackObj).replace(reg, "");
		} else if (executeBackObj instanceof Document) {
			// 单实现
			executeBackXml = DOMHelper.nodeToString((Document)executeBackObj);
		} else if (executeBackObj instanceof List) {
			// 多实现类型
			List<Object> executeObjList = (List<Object>)executeBackObj;
			for (Object obj : executeObjList) {
				if (obj instanceof String) {
					String str = String.valueOf(obj);
					// 检查字符串是否是一个xml格式
					Object isXmlPattern = DOMHelper.validateXmlW3c(str);
					if (isXmlPattern instanceof Boolean) {
						executeBackXml += "<customize>"+ str +"</customize>";
					} else if (isXmlPattern instanceof Document) {
						// 检查到是一个xml格式
						Object isCustom = DOMHelper.isSelectNode("/tib", (Document)isXmlPattern);
						if (isCustom == null) {
							executeBackXml += "<customize>"+ str +"</customize>";
						} else {
							executeBackXml += str.replace(reg, "");
						}
					}
				} else if (obj instanceof Document) {
					executeBackXml += DOMHelper.nodeToString((Document)obj);
				} 
			}
			if (executeObjList != null && executeObjList.size() > 1) {
				executeBackXml = "<list>"+ executeBackXml +"</list>";
			}
		}
		// 去除换行
		Pattern pt = Pattern.compile("(\r\n|\r|\n|\n\r)");
		Matcher matcher = pt.matcher(executeBackXml);
		executeBackXml = matcher.replaceAll("").replaceAll("\"", "\\\\\"");
		return executeBackXml;
	}

	public void importInit() throws Exception {
		// 拷贝存放文件
		new FileHelper(SOURCE_PATH, TARGET_PATH).copyDir();
		String[] filePaths = {"/tib/sys/core/_com.landray.kmss.tib.sys.core.provider.model.TibSysCoreIface"};
		boolean isImportRequired = false;
		boolean isUpdate = true;
		if (filePaths != null) {
			ITibCommonInoutdataService inoutdataService = (ITibCommonInoutdataService) 
					SpringBeanUtil.getBean("tibCommonInoutdataService");
			inoutdataService.startImport(null, filePaths,
					isImportRequired, isUpdate, TARGET_CONF_PATH);
		}		
	}

	public void updateImplIfaceXmlStatus(String ifaceId) throws Exception {
		ITibSysCoreIfaceImplService ifaceImplService = (ITibSysCoreIfaceImplService) 
				SpringBeanUtil.getBean("tibSysCoreIfaceImplService");
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock("tibSysCoreIfaceImpl.tibSysCoreIface.fdId=:ifaceId");
		hqlInfo.setParameter("ifaceId", ifaceId);
		List<TibSysCoreIfaceImpl> ifaceImplList = ifaceImplService.findList(hqlInfo);
		for (TibSysCoreIfaceImpl ifaceImpl : ifaceImplList) {
			ifaceImpl.setFdIfaceXmlStatus("1");
			ifaceImplService.update(ifaceImpl);
		}
	}

	public String getImplListJson(String key) throws Exception {
		ITibUnitInterface tibUnitIface = (ITibUnitInterface) SpringBeanUtil
				.getBean("tibUnitInterface");
		List<IfaceImplInfo> implInfoList =  tibUnitIface.getImplList(key);
		JSONObject result = new JSONObject();
		for (int i = 0; i < implInfoList.size(); i++) {
			IfaceImplInfo implInfo = implInfoList.get(i);
			JSONObject inResult = new JSONObject();
			inResult.put("fdName", implInfo.getFdName());
			inResult.put("fdOrderBy", implInfo.getFdOrderBy());
			inResult.put("fdKey", implInfo.getFdKey());
			inResult.put("fdRefFuncType", implInfo.getFdRefFuncType());
			inResult.put("fdRefFuncName", implInfo.getFdRefFuncName());
			result.put(i + 1, inResult);
		}
		return result.toString();
	}
	
}
