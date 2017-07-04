在kmssconfig.properties可配置的参数

kmss.cluster.serverName：节点标识，自动转成小写，默认值为随机id
kmss.cluster.tcp.startport：tcp协议的起始端口号，样例：7800

=====以下属性暂不提供配置=====
kmss.cluster.deadTime：判断节点已经失效的时间，单位：秒，默认值60秒
kmss.cluster.heartbeatTime：心跳时间，单位：秒，默认值15秒
kmss.cluster.messageRefreshTime：群集消息从数据库加载刷新时间，默认30秒
kmss.cluster.messagePersistence：消息体持久化服务的bean名称，默认值为“sysClusterMessageService”
kmss.cluster.threadPoolSize：群集任务处理线程池大小，默认值为10

