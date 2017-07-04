package com.landray.kmss.kms.multidoc.service.spring;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.hibernate.LockMode;
import org.hibernate.Query;

import com.landray.kmss.common.service.BaseServiceImp;
import com.landray.kmss.kms.multidoc.model.KmsMultidocSn;
import com.landray.kmss.kms.multidoc.model.KmsMultidocSnContext;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocGenerateSnService;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocSnRule;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocSnService;

public class KmsMultidocGenerateSnServiceImp extends BaseServiceImp implements
		IKmsMultidocGenerateSnService {

	private IKmsMultidocSnService kmsMultidocSnService;

	public void setKmsMultidocSnService(IKmsMultidocSnService kmsMultidocSnService) {
		this.kmsMultidocSnService = kmsMultidocSnService;
	}

	private IKmsMultidocSnRule rule = new KmsMultidocSnDefaultRule();

	public void setRule(IKmsMultidocSnRule rule) {
		this.rule = rule;
	}

	/**
	 * 
	 * 生成流水号
	 * 
	 * @param context
	 * 
	 * @return String
	 */
	public String getSerialNumber(KmsMultidocSnContext context) throws Exception {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		String curActualDate = format.format(new Date());
		String flowNumber = "";
		String sql = "from com.landray.kmss.kms.multidoc.model.KmsMultidocSn kmsMultidocSn where kmsMultidocSn.fdModelName =:modelName"
				+ " and kmsMultidocSn.fdTemplateId =:templateId and kmsMultidocSn.fdPrefix =:prefix ";
		// 根据上下文的参数查询符合条件的流水号记录
		Query query = getBaseDao().getHibernateSession().createQuery(sql);
		query.setString("modelName", context.getFdModelName());
		query.setString("templateId", context.getFdTemplate().getFdId());
		// query.setString("curDate", curDate);
		query.setString("prefix", context.getFdPrefix());
		query.setLockMode("kmsMultidocSn", LockMode.UPGRADE);
		List<?> snList = query.list();
		KmsMultidocSn kmsMultidocSn = new KmsMultidocSn();
		// 如果有相应记录，取流水号
		if (snList.size() >= 1) {
			kmsMultidocSn = (KmsMultidocSn) snList.get(0);
			String curSqlDate = kmsMultidocSn.getFdDate();
			if (curActualDate.equalsIgnoreCase(curSqlDate)) {
				context.setFdSn(kmsMultidocSn.getFdMaxNumber());
				flowNumber = rule.createSerialNumber(context);
				// 把记录中的流水号+1
				kmsMultidocSn.setFdMaxNumber(kmsMultidocSn.getFdMaxNumber() + 1);
			} else {
				context.setFdSn(new Long(1));
				flowNumber = rule.createSerialNumber(context);
				kmsMultidocSn.setFdDate(curActualDate);
				kmsMultidocSn.setFdMaxNumber(new Long(2));
			}
			kmsMultidocSnService.update(kmsMultidocSn);
			if (snList.size() > 1) {
				snList.remove(kmsMultidocSn);
				for (int i = 0; i < snList.size(); i++) {
					kmsMultidocSnService.delete((KmsMultidocSn) snList.get(i));
				}
			}
		} else {
			context.setFdSn(new Long(1));
			flowNumber = rule.createSerialNumber(context);
			// 插入一条记录
			kmsMultidocSn.setFdDate(curActualDate);
			kmsMultidocSn.setFdModelName(context.getFdModelName());
			kmsMultidocSn.setFdMaxNumber(Long.valueOf(2));
			kmsMultidocSn.setFdTemplateId(context.getFdTemplate().getFdId());
			kmsMultidocSn.setFdPrefix(context.getFdPrefix());
			kmsMultidocSnService.add(kmsMultidocSn);
		}
		return flowNumber;
	}

	/**
	 * 
	 * 初始化流水号
	 * 
	 * @param context
	 * 
	 * @return String
	 */
	public void initalizeSerialNumber(KmsMultidocSnContext context) throws Exception {
		String sql = "from com.landray.kmss.kms.multidoc.model.KmsMultidocSn kmsMultidocSn where kmsMultidocSn.fdModelName =:modelName"
				+ " and kmsMultidocSn.fdTemplateId =:templateId and kmsMultidocSn.fdPrefix = :prefix";
		// 根据上下文的参数查询符合条件的流水号记录
		Query query = getBaseDao().getHibernateSession().createQuery(sql);
		query.setString("modelName", context.getFdModelName());
		query.setString("templateId", context.getFdTemplate().getFdId());
		query.setString("prefix", context.getFdPrefix());
		List<?> snList = query.list();
		if (snList.size() == 0) {
			// 插入一条记录
			KmsMultidocSn kmsMultidocSn = new KmsMultidocSn();
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
			String curActualDate = format.format(new Date());
			kmsMultidocSn.setFdDate(curActualDate);
			kmsMultidocSn.setFdModelName(context.getFdModelName());
			kmsMultidocSn.setFdTemplateId(context.getFdTemplate().getFdId());
			kmsMultidocSn.setFdPrefix(context.getFdPrefix());
			kmsMultidocSnService.add(kmsMultidocSn);
		}
	}
}
