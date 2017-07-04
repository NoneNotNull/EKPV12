package com.landray.kmss.tib.sys.soap.constant;

public interface QuartzCfg {
	// 定时任务配置
	//TibSysSap 定时任务bean
	public final static String TIBSYSSOAP_SERVICEBEAN = "tibSoapSyncUniteQuartzService";
	//使用定时任务bean 的method
	public final static String TIBSYSSOAP_SERVICEMETHOD = "methodJob";
	//批量导入数据批量数目
	public final static int DEFAUTL_NUM = 3000;
	
	public final static int DEFAUTL_DELETE_NUM=1000;
	
	//时间戳比对时候需要转化日期类型,默认转换数据类型调整
	public final static String QUARTZ_DEFAULT_PATTERN="yyyy-MM-dd";
	
	//notes： true的话数据库表必须要有fd_id 这个字段
	public final static boolean USE_FDID=false;
	
	
	//数据类型转换配置
	
	//false 根据转换数据ctype 转换|true 统一转换EXCHANGE_TYPE_DEFAULT配置类型
//	暂时这一个配置不要改动,查询语句跟删除语句需要数据库字段全部是字符串
	public final static boolean EXCHANGE_TYPE_ISDEFAULT= true;
	//配置默认转换类型
	
//	同步时删除：全量(数据导入前把目标表的所有数据全部删除在导入)
	public final static String QUARTZ_INSERT_ALL="2";
//	同步时不删除：增量(数据导入前根据前端页面key值筛选 更新or保存)
	public final static String QUARTZ_INSERT_INCREASE="1";
//	启用时间戳：增量（时间戳）(数据导入前根据前端配置时间戳字段值与定时任务更新时间比对,在这个时间以后的数据才进行 ‘增量’  导入操作)
	public final static String QUARTZ_INSERT_TIMESTAMP="3";
//	增量(插入前删除) (数据导入前根据前端配置key找出所有数据库存在这个条件的数据删除,在进行全部插入操作)
	public final static String QUARTZ_INSERT_DELETE="4";
//	增量(带条件删除) 
	public final static String QUARTZ_CONDITION_DELETE="5";
	
	public final static String QUARTZ_EMPTY_TABLE="TRUNCATE TABLE !{TABLENAME}";
	

	
	//	public final static String EXCHANGE_TYPE_DEFAULT="STRING";
	// TibSysSapQuartzTempFuncServiceImp 分页查询语句
	public final static String QUERY_MYSQL = "SELECT * FROM !{tableName} !{orderBy} limit !{start} , !{rowsize} ";
	public final static String QUERY_MSSQLSERVER = "SELECT TOP !{rowsize} * from (SELECT TOP  !{curNum} * from !{tableName} !{orderBy}  ) A !{orderBy} ";
	public final static String QUERY_ORACLE = "SELECT * FROM ( SELECT B.* ,ROWNUM RN FROM ( SELECT * FROM !{tableName} !{orderBy} ) B WHERE ROWNUM <=!{curNum} ) WHERE RN>= !{preNum} ";
	public final static String QUERY_DB2 = "SELECT * FROM ( SELECT B.* ,ROWNUMBER() OVER(!{orderBy}) AS RN FROM (SELECT * FROM !{tableName}  ) AS B ) AS A WHERE A.RN BETWEEN !{preNum} AND !{curNum} ";

	//查询存在的数据库表 待优化 存在不同数据类型wherebock 不可构建问题
    public final static String FIND_EXIST_MSSQLSERVER="SELECT !{SELECTKEY} FROM !{TABLENAME} WHERE !{WHEREBOCK}";//"SELECT !{SELECTKEY} FROM !{TABLENAME} WHERE !{COMBINEDKEY} IN (!{IN_VALUE})";
    public final static String FIND_EXIST_MYSQL=FIND_EXIST_MSSQLSERVER;//"SELECT !{SELECTKEY} FROM !{TABLENAME} WHERE !{COMBINEDKEY} IN (!{IN_VALUE})";
    public final static String FIND_EXIST_ORACLE=FIND_EXIST_MSSQLSERVER;//"SELECT !{SELECTKEY} FROM !{TABLENAME} WHERE !{COMBINEDKEY} IN (!{IN_VALUE})";
    public final static String FIND_EXIST_DB2=FIND_EXIST_MSSQLSERVER;//"SELECT !{SELECTKEY} FROM !{TABLENAME} WHERE !{COMBINEDKEY} IN (!{IN_VALUE})";
    
//    删除表中存在的数据  暂时通用，待优化 ，存在不同数据类型wherebock 不可构建问题
    public final static String DELETE_EXIST_SQL="DELETE FROM !{TABLENAME} WHERE !{WHEREBOCK}";
    
//=============数据库字符串衔接 使用分隔符'_'隔开===========================================
    public final static String STRING_JOIN_ORACLE="{0}||'_'||+{1}";
    public final static String STRING_JOIN_MYSQL="CONCAT(CONCAT({0},'_'),{1})";
    public final static String STRING_JOIN_MSSQLSERVER="{0}+'_'+{1}";
    public final static String STRING_JOIN_DB2="{0}||'_'||{1}";
//  =========数据类型强转======暂时没有对TibSysSap数据进行强转，默认所有类型都字符型=============  
    public final static String TO_STRING_ORACLE="to_char({val},{text})";
    public final static String TO_STRING_MYSQL="";
    public final static String TO_STRING_MSSQLSERVER="";
    public final static String TO_STRING_DB2="varchar({val},{text})";
    
    
    
    //============================================ 
    public final static String DB_TYPE_ORACLE="Oracle";
    public final static String DB_TYPE_MYSQL="MY SQL";
    public final static String DB_TYPE_DB2="DB2";
    public final static String DB_TYPE_MSSQLSERVER="MS SQL Server";
    
    
    
    
}
