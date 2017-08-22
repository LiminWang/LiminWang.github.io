
# 大数据技术
1. Database
2. Data Warehouse
3. Business Intelligence
4. Cloud Computing
5. Statistic Analysis
6. Data Mining
7. Big Data and Data Science
8. Big Data and Machine Learning
9. Big Data and Internet of Things
10. Big Data and Mobile Computing
11. Big Data and Web Technology

# Google 三驾马车 —— Google File System，MapReduce，BigTable
* [GFS](https://static.googleusercontent.com/media/research.google.com/zh-CN//archive/gfs-sosp2003.pdf)
* [MapReduce](https://static.googleusercontent.com/media/research.google.com/zh-CN//archive/mapreduce-osdi04.pdf)
* [BigTable](https://static.googleusercontent.com/media/research.google.com/zh-CN//archive/bigtable-osdi06.pdf)

# Google 新三驾马车 —— Caffeine，Pregel，Dremel
* Caffeine主要为Google网络搜索引擎提供支持。
* Pregel主要绘制大量网上信息之间关系的“图形数据库”。
* Dremel是一种分析信息的方式，其可以跨越数千台服务器运行，允许“查询”大量数据。

# 大数据生态圈
## 数据采集
 - [Kafka](http://kafka.apache.org/) 分布式发布订阅系统 - TB消息存储也能保持长时间的稳定性能；高吞吐量，每秒数十万；支持通过kafka服务器和消费机集群来分区消息；支持Hadoop并行数据加载 - 处理日志，日志聚合。
 - [Flume](http://flume.apache.org/) 日志服务器 - 分布式、可靠和高可用的服务，用于收集、聚合以及移动大量日志数据，使用一个简单灵活的架构，就流数据模型。这是一个可靠、容错的服务。
 - [Logstash](https://www.elastic.co/products/logstash) 开源日志管理 - 一个应用程序日志、事件的传输、处理、管理和搜索的平台。你可以用它来统一对应用程序日志进行收集管理，提供 Web 接口用于查询和统计。是ElasticSearch家族之一。
 - [DataX](http://code.taobao.org/p/datax/src/) 异构数据源交换工具 - DataX是一个让你方便的在异构数据源之间交换数据的离线同步框架/工具，实现了在任意的数据处理系统之间的数据交换，目前DataX在淘宝内部每天约有5000道同步任务分布在全天各个时段，平均每天同步数据量在2-3TB。
 - [RabbitMQ](http://www.rabbitmq.com/) AMQP消息服务器
 - [Scribe](https://github.com/facebookarchive/scribe) Facebook大量数据处理 - Scribe旨在帮助Facebook处理服务器上的大量数据，正像Scribe网页所述“如经常访问Facebook，请使用Scribe。”具体而言，Scribe就是一台服务器，实时收集用网站日志信息。

## 数据存储
存储采集到的数据，以及分析处理后的数据。

## 分布式文件存储
 - [Hadoop HDFS](http://hadoop.apache.org/) 分布式文件系统 - HDFS有着高容错性（fault-tolerent）的特点，并且设计用来部署在低廉的（low-cost）硬件上。而且它提供高吞吐量（high throughput）来访问应用程序的数据，适合那些有着超大数据集（large data set）的应用程序。分布式存储，磁盘存储，分布式存储的主要技术。HDFS集群包括了一个主节点，负责管理所有文件系统的元数据以及存储了真实数据的数据节点。但是缺少随机读写的能力，可以由HBase来弥补。
 - [Alluxio](http://www.alluxio.org/) 分布式存储系统 - Alluxio 是一个高容错的分布式文件系统，允许文件以内存的速度在集群框架中进行可靠的共享，类似Spark和 MapReduce。通过利用lineage信息，积极地使用内存，Alluxio的吞吐量要比HDFS高300多倍。Alluxio都是在内存中处理缓存文件，并且让不同的 Jobs/Queries以及框架都能内存的速度来访问缓存文件。它兼容Hadoop。

## 数据库存储
 - [MySQL](https://www.mysql.com/)
 - [Oracle](https://www.oracle.com/index.html)
 - [PostgreSQL](https://www.postgresql.org/)
 - [HBase](http://hbase.apache.org/) 分布式数据库 - BigTable风格，分布式列式存储。提供了大数据集上的随机和实时的读写访问，并对大型表格做了优化-上百亿行，上千万列。以键值对的方式存储。是一个NoSQL的数据库，具有随机读写能力，可无缝和MapReduce集成。可以用HDFS存储静态数据，HBase存储处理后的数据。  
 - [Vertica](http://www8.hp.com/us/en/software-solutions/advanced-sql-big-data-analytics/index.html) 实时分析平台 - 有商业版，有免费版。基于列式存储。支持MPP。每个节点独立运作。使用标准SQL查询。可以和Hadoop/MapReduce集成。
 - [Cassandra](http://cassandra.apache.org/) 分布式K/V存储方案 - 由Facebook开源。特性：分布式，基于列的结构化，高伸展性。  
 - [Riak](http://riak.basho.com/) k/v存储服务器 - Riak是以 Erlang 编写的一个高度可扩展的分布式数据存储。Riak支持多节点构建的系统，每次读写请求不需要集群内所有节点参与也能胜任。提供一个灵活的 map/reduce 引擎，一个友好的 HTTP/JSON 查询接口。目前有三种方式可以访问 Riak：HTTP API（RESTful 界面）、Protocol Buffers 和一个原生 Erlang 界面。
 - [ElasticSearch](http://www.elasticsearch.org/) 分布式搜索引擎 - Elastic Search 是一个基于Lucene构建的开源，分布式，RESTful搜索引擎。设计用于云计算中，能够达到实时搜索，稳定，可靠，快速，安装使用方便。支持通过HTTP使用JSON进行数据索引。
 - [Solr](http://lucene.apache.org/solr/) 全文搜索服务器 - Apache Solr (读音: SOLer) 是一个开源的搜索服务器。Solr 使用 Java 语言开发，主要基于 HTTP 和 Apache Lucene 实现。Apache Solr 中存储的资源是以 Document 为对象进行存储的。每个文档由一系列的 Field 构成，每个 Field 表示资源的一个属性。Solr 中的每个 Document 需要有能唯一标识其自身的属性，默认情况下这个属性的名字是 id，在 Schema 配置文件中使用：id进行描述。  
 - [Lucene](http://lucene.apache.org/) Java全文搜索框架 - Lucene 是apache软件基金会一个开放源代码的全文检索引擎工具包，是一个全文检索引擎的架构，提供了完整的查询引擎和索引引擎，部分文本分析引擎。Lucene的目的是为软件开发人员提供一个简单易用的工具包，以方便的在目标系统中实现全文检索的功能，或者是以此为基础建立起完整的全文检索引擎。据官方网站声称，它在现代硬件上每小时能够检索超过150GB的数据，它含有强大而高效的搜索算法。
 - [MongoDB](http://www.mongodb.org/) 分布式文档数据库 - MongoDB是一个介于关系数据库和非关系数据库之间的产品，是非关系数据库当中功能最丰富，最像关系数据库的。他支持的数据结构非常松散，是类似json的bjson格式，因此可以存储比较复杂的数据类型。Mongo最大的特点是他支持的查询语言非常强大，其语法有点类似于面向对象的查询语言，几乎可以实现类似关系数据库单表查询的绝大部分功能，而且还支持对数据建立索引。
 - [Neo4j](http://neo4j.org/) 面向网络的数据库 - Neo是一个网络——面向网络的数据库——也就是说，它是一个嵌入式的、基于磁盘的、具备完全的事务特性的Java持久化引擎，但是它将结构化数据存储在网络上而不是表中。网络（从数学角度叫做图）是一个灵活的数据结构，可以应用更加敏捷和快速的开发模式。  
 你可以把Neo看作是一个高性能的图引擎，该引擎具有成熟和健壮的数据库的所有特性。程序员工作在一个面向对象的、灵活的网络结构下而不是严格、静态的表中——但是他们可以享受到具备完全的事务特性、企业级的数据库的所有好处。
 - [OrientDB](http://www.orientdb.org/) 文档数据库 - Orient DB 是一个可伸缩的文档数据库，支持 ACID 事务处理。使用 Java 5 实现。
 - [ArangoDB](http://www.arangodb.org/) 高性能NoSQL数据库 - Arangodb是一个开源数据库，具有灵活的数据模型,如document,graph以及key-value.同时也是一个高性能数据库,支持类似SQL的查询以及JavaScript活Ruby扩展。
 - [CouchDB](http://couchdb.apache.org/) 面向文档的数据库 - Apache CouchDB 是一个面向文档的数据库管理系统。它提供以 JSON 作为数据格式的 REST 接口来对其进行操作，并可以通过视图来操纵文档的组织和呈现。CouchDB号称是“一款完全拥抱互联网的数据库”，它将数据存储在JSON文档中，这种文档可以通过Web浏览器来查询，并且用JavaScript来处理。它易于使用，在分布式上网络上具有高可用性和高扩展性。
 - [FlockDB](https://github.com/twitter/flockdb) 存储图数据的数据库 - FlockDB是一个存储图数据的数据库，但是它并没有优化遍历图的操作。它优化的操作包括：超大规模邻接矩阵查询，快速读写和可分页查询。
 - [InfluxDB](http://influxdb.org/) 时序、事件和指标数据库 - InfluxDB 是一个开源分布式时序、事件和指标数据库。使用 Go 语言编写，无需外部依赖。其设计目标是实现分布式和水平伸缩扩展。
 - [Druid](https://github.com/alibaba/druid) JDBC连接池、监控组件 - 是一个JDBC组件，可以监控数据库访问性能，替换DBCP和C3P0，数据库密码加密，SQL执行日志。
 - [Redis](http://redis.io/) 高性能Key-Value数据库 - 速度极快，适合作为缓存服务器。
 - [Hazelcast](http://www.hazelcast.com/) 数据分发和集群平台 - 可用于实现分布式数据存储、数据缓存。提供java集合的分布式实现，提供用于发布/订阅的分布式topic，支持同步异步持久化等。
 - [Kafka](http://kafka.apache.org/)
 - [RabbitMQ](http://www.rabbitmq.com/)
 - [RocketMQ](https://github.com/alibaba/RocketMQ) 消息中间件 - 分布式、队列模型的消息中间件，能够保证严格的消息顺序，提供丰富的消息拉取模式，高效的订阅者水平扩展能力，实时的消息订阅机制，亿级消息堆积能力。
 - [ZeroMQ](http://www.zeromq.org/) 轻量级消息内核
 - [ActiveMQ](http://activemq.apache.org/) JMS消息服务器 - ActiveMQ 是Apache出品，最流行的，能力强劲的开源消息总线。ActiveMQ 是一个完全支持JMS1.1和J2EE 1.4规范的 JMS Provider实现,尽管JMS规范出台已经是很久的事情了,但是JMS在当今的J2EE应用中间仍然扮演着特殊的地位。

## 数据处理/分析

## 数据格式化
 - [Avro](https://avro.apache.org/) 数据序列化系统 - 是数据序列化的工具，类似于ProtocolBuffers。使用json来定义数据类型。RPC项目，做hadoop的RPC，使得其通讯速度更快，数据结构更紧凑。
 - [ProtoBuf](https://developers.google.com/protocol-buffers/)
 - [Thrift](https://thrift.apache.org/) 服务开发框架 - Thrift 是一个软件框架（远程过程调用框架），用来进行可扩展且跨语言的服务的开发。thrift允许你定义一个简单的定义文件中的数据类型和服务接口，以作为输入文件，编译器生成代码用来方便地生成RPC客户端和服务器通信的无缝跨编程语言。著名的 Key-Value 存储服务器 Cassandra 就是使用 Thrift 作为其客户端API的。
 - [Parquet](https://parquet.apache.org/) Hadoop柱状存储格式 - Parquet是一种面向列存存储的文件格式，Cloudera的大数据在线分析（OLAP）项目Impala中使用该格式作为列存储。Apache Parquet 是一个列存储格式，主要用于 Hadoop 生态系统。对数据处理框架、数据模型和编程语言无关。
 - [Sqoop](http://sqoop.apache.org/) Hadoop和数据库数据迁移工具。Sqoop是一个用来将Hadoop和关系型数据库中的数据相互转移的工具，可以将一个关系型数据库（例如 ： MySQL ,Oracle ,Postgres等）中的数据导入到Hadoop的HDFS中，也可以将HDFS的数据导入到关系型数据库中。

## 批处理 （离线计算，即席查询）
 - [Spark](http://spark.apache.org/) 开源集群计算环境 - Spark 启用了内存分布数据集，除了能够提供交互式查询外，它还可以优化迭代工作负载。
 - [Hadoop MapReduce](http://hadoop.apache.org/) 大规模数据集软件架构 - 是一个Computing Framework，可以编写处理海量（TB级）数据的并行应用程序。它可以通过MapReduce的方式从HBase中存取数据，或者通过HBase的API来存取。
 - [Flink](http://flink.apache.org/) 通用数据处理平台 - Apache Flink 声明式的数据分析开源系统，结合了分布式 MapReduce 类平台的高效，灵活的编程和扩展性。同时在并行数据库发现查询优化方案。兼容HDFS。
 - [Tez](http://tez.apache.org/) 开源计算框架 - Tez建立在Apache Hadoop YARN的基础上，这是“一种应用程序框架，允许为任务构建一种复杂的有向无环图，以便处理数据。”它让Hive和Pig可以简化复杂的任务，而这些任务原本需要多个步骤才能完成。

**High-Level MapReduce**

 - [Pig](http://pig.apache.org/) 大规模数据分析平台 - Pig是一个基于Hadoop的大规模数据分析平台，它提供的SQL-LIKE语言叫Pig Latin，该语言的编译器会把类SQL的数据分析请求转换为一系列经过优化处理的MapReduce运算。Pig为复杂的海量数据并行计算提供了一个简单的操作和编程接口。Pig和Hive的查询在底层都会转换成MapReduce。它俩都可以建立在HDFS和HBase之上。
 - [Hadoop Streaming](http://hadoop.apache.org/docs/r1.2.1/streaming.html)
 - [Cascalog](http://www.cascading.org/projects/cascalog/) Hadoop数据处理解决方案 - Cascalog 是 Clojure 或者 Java 的全功能数据处理和查询库。Cascalog 主要的作用是处理 Hadoop 上的“大数据”或者分析你的本地电脑， Cascalog 是替代 Pig 和 Hive 的工具，而且比这些工具都有更高的抽象级别。
 - [Cascading](http://www.cascading.org/) Hadoop集群处理API - Cascading是一个新式的针对Hadoop clusters的数据处理API，它使用富于表现力的API来构建复杂的处理工作流，而不是直接实现Hadoop MapReduce的算法。

**Batch Machine Learning**

 - [H20](http://www.h2o.ai/)
 - [Mahout](https://mahout.apache.org/) 机器学习库 - 4个用例：推荐挖掘（搜集用户动作并以此向用户推荐可能喜欢的事物），聚集（收集文件并进行相关文件分组），分类（从现有的分类文档中学习，寻找文档中的相似特征，并为无标签的文档进行正确的归类），频繁项集挖掘（将一组项分组，并识别哪些个别项会经常一起出现）
 - [Spark MLlib](https://spark.apache.org/mllib/)

**Batch SQL**

 - [Hive](http://hive.apache.org/) 数据仓库平台 - 生产环境应用较广泛的，基于Hadoop的数据仓库系统，提供了数据的综述（将结构化的数据文件映射为一张数据库表）、即席查询以及存储在Hadoop兼容系统中的大型数据分析。提供完整的SQL查询功能，还提供传统的Map/Reduce方式。
 - [PrestoDB](https://prestodb.io/) 大数据查询引擎 - Presto是Facebook最新研发的数据查询引擎，可对250PB以上的数据进行快速地交互式分析。据称该引擎的性能是 Hive 的 10 倍以上。Presto 不使用 MapReduce ，只需要 HDFS
 - [Drill](http://drill.apache.org/) Google的Dremel的开源实现 - 这个Apache项目让用户可以使用基于SQL的查询，查询Hadoop、NoSQL数据库和云存储服务。它可用于数据挖掘和即席查询，它支持一系 列广泛的数据库，包括HBase、MongoDB、MapR-DB、HDFS、MapR-FS、亚马逊S3、Azure Blob Storage、谷歌云存储和Swift。
 - [Cloudera Impala](http://impala.io/) 基于Hadoop的实时查询 - Impala采用与Hive相同的元数据、SQL语法、ODBC驱动程序和用户接口(Hue Beeswax)，这样在使用CDH产品时，批处理和实时查询的平台是统一的。目前支持的文件格式是文本文件和SequenceFiles（可以压缩为Snappy、GZIP和BZIP，前者性能最好）。其他格式如Avro, RCFile, LZO文本和Doug Cutting的Trevni将在正式版中支持。
 - [Spark SQL](http://spark.apache.org/docs/latest/sql-programming-guide.html)

## 流处理 （实时计算）
 - [Storm](http://storm.apache.org/) 分布式实时计算系统 - Apache Storm 是一个免费开源的分布式实时计算系统。简化了流数据的可靠处理，像 Hadoop 一样实现实时批处理。Storm 很简单，可用于任意编程语言。Apache Storm 采用 Clojure 开发。  
 Storm 有很多应用场景，包括实时数据分析、联机学习、持续计算、分布式 RPC、ETL 等。Storm 速度非常快，一个测试在单节点上实现每秒一百万的组处理。  
 目前已经有包括阿里百度在内的数家大型互联网公司在使用该平台。
 - [Spark Streaming](http://spark.apache.org/streaming/) - 实时性相对略差，但是吞吐量更高。
 - [Samza](http://samza.apache.org/) 分布式流处理框架 - Samza是近日由LinkedIn开源的一项技术，它是一个分布式流处理框架，专用于实时数据的处理，非常像Twitter的流处理系统Storm。不同的是Samza基于Hadoop，而且使用了LinkedIn自家的Kafka分布式消息系统，并使用资源管理器 Apache Hadoop YARN 实现容错处理、处理器隔离、安全性和资源管理。
 - [Flink](http://flink.apache.org/)

## 集群管理
 - [Docker](http://www.docker.io/) Linux容器引擎 - Docker 是一个开源的应用容器引擎，让开发者可以打包他们的应用以及依赖包到一个可移植的容器中，然后发布到任何流行的 Linux 机器上，也可以实现虚拟化。容器是完全使用沙箱机制，相互之间不会有任何接口（类似 iPhone 的 app）。几乎没有性能开销,可以很容易地在机器和数据中心中运行。最重要的是,他们不依赖于任何语言、框架或包装系统。
 - [Zookeeper](http://zookeeper.apache.org/) 分布式系统协调 - ZooKeeper是Hadoop的正式子项目，它是一个针对大型分布式系统的可靠协调系统，提供的功能包括：配置维护、名字服务、分布式同步、组服务等。ZooKeeper的目标就是封装好复杂易出错的关键服务，将简单易用的接口和性能高效、功能稳定的系统提供给用户。  
 Zookeeper是Google的Chubby一个开源的实现.是高有效和可靠的协同工作系统.Zookeeper能够用来leader选举,配置信息维护等.在一个分布式的环境中,我们需要一个Master实例或存储一些配置信息,确保文件写入的一致性等。
 - [YARN](http://hadoop.apache.org/docs/current/hadoop-yarn/hadoop-yarn-site/YARN.html) Hadoop资源管理器 - YARN是新一代Hadoop资源管理器，通过YARN，用户可以运行和管理同一个物理集群机上的多种作业，例如MapReduce批处理和图形处理作业。这样不仅可以巩固一个组织管理的系统数目，而且可以对相同的数据进行不同类型的数据分析。某些情况下，整个数据流可以执行在同一个集群机上。
 - [Mesos](http://mesos.apache.org/) 分布式大数据技术架构的操作系统 - Apache Mesos是一个集群管理器，提供了有效的、跨分布式应用或框架的资源隔离和共享，可以运行Hadoop、MPI、Hypertable、Spark。
 - [Oozie](http://incubator.apache.org/oozie) 开源工作流引擎 - Oozie 是一个开源的工作流和协作服务引擎，基于 Apache Hadoop 的数据处理任务。Oozie 是可扩展的、可伸缩的面向数据的服务，运行在Hadoop 平台上。Oozie 包括一个离线的Hadoop处理的工作流解决方案，以及一个查询处理 API。

## 调度/监控
 - [Luigi](https://github.com/spotify/luigi) 开源大数据工具 - Luigi 是一个 Python 模块，可以帮你构建复杂的批量作业管道。处理依赖决议、工作流管理、可视化展示等等，内建 Hadoop 支持。
 - [Airflow](http://pythonhosted.org/airflow/) 数据管道监控工具 - 作为大数据的基础data pipeline，Airflow则是Airbnb内部发起、排序、监控data pipeline的工具。
 - [Nagios](https://www.nagios.org/) 监控系统 - Nagios是一个监视系统运行状态和网络信息的监视系统。Nagios能监视所指定的本地或远程主机以及服务，同时提供异常通知功能等。Nagios可运行在Linux/Unix平台之上，同时提供一个可选的基于浏览器的WEB界面以方便系统管理人员查看网络状态，各种系统问题，以及日志等等。
 - [Graphite](http://graphite.wikidot.com/) 网站实时信息采集和统计 - Graphite 是一个用于采集网站实时信息并进行统计的开源项目，可用于采集多种网站服务运行状态信息。Graphite服务平均每分钟有4800次更新操作。实践已经证实要监测网站发发生什么是非常有用的，它的简单文本协议和绘图功能可以方便地即插即 用的方式用于任何需要监控的系统上。
 - [Azkaban](http://azkaban.github.io/) Hadoop批处理调度器 - Azkaban是个简单的批处理调度器，用来构建和运行Hadoop作业或其他脱机过程。
 - [Ambari](http://incubator.apache.org/ambari/) Hadoop管理监控工具 - Apache Ambari是一种基于Web的工具，支持Apache Hadoop集群的供应、管理和监控。Ambari目前已支持大多数Hadoop组件，包括HDFS、MapReduce、Hive、Pig、Hbase、Zookeper、Sqoop和Hcatalog等的集中管理。也是5个顶级hadoop管理工具之一。
 Ambari使用Ganglia收集度量指标，用Nagios支持系统报警，当需要引起管理员的关注时（比如，节点停机或磁盘剩余空间不足等问题），系统将向其发送邮件。此外，Ambari能够安装安全的（基于Kerberos）Hadoop集群，以此实现了对Hadoop 安全的支持，提供了基于角色的用户认证、授权和审计功能，并为用户管理集成了LDAP和Active Directory。

## 数据可视化
 - [D3](https://d3js.org/) 开源图表库
 - [Tableau](http://www.tableau.com/)
 - [Leaflet](http://leafletjs.com/) javascript地图库 - Leaflet是一个开源的地图Javascript库，它由Universal Mind的Vladimir Agafonkin创建的。我们将在一个应用程序中使用这个封装组件。该应用程序给我们展示了一个地图并提供了一个可以移动到地图中指定位置的按钮。
 - [Highcharts](http://highcharts.com/) 纯javascript图表
 - [Kibana](http://kibana.org/) 日志分析平台 - Kibana 是一个为 Logstash 和 ElasticSearch 提供的日志分析的 Web 接口。可使用它对日志进行高效的搜索、可视化、分析等各种操作。 环境要求： ruby。

