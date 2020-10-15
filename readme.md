### fluentd_plugin_s3
a plugin of fluentd transfer data to s3 ,reduce aws billing.
本方案可以良好的解决AWS应用服务产生的log传输到aws s3；避免使用firehose等service，在保证稳定性的同时减少传输成本，同时不降低效率。总的来说就是使用fluentd代替firehose实现AWS 平台上log落地到s3的数据传输方案。

本方案使用fluentd作为transfer tool,替换aws firehose service。可以完全节省aws firehose的service billing。
通过了业务场景的实战，性能和服务稳定性由保障。
qps在100000左右（+20%，-20%），日均传输数据量在10T，（相较于使用firehose）月均节省aws billing在7000$+。效果非常可观！
缺点是可维护性不高，需要精细的监控指标；相当于自己维护了一整套数据传输的服务；此外由于配置中chunk_limit_size的限制（chunk_limit_size越大，传输的次数越少，节省的流量传输费用越多，占用的存储空间越小），随着chunk_limit_size的变大，对机器的磁盘和内存使用率变大，所以谨慎设置chunk_limit_size的大小。根据实际情况把握平衡点。
 > 推荐对数据进行压缩，fluentd支持的文件压缩比如gzip，压缩对机器性能有影响但是对于数据传输和存储都有较大的节省。按照实践结果来看，使用gzip压缩了近5倍。


【1】[fluentd 配置参数参考](https://docs.fluentd.org/output/s3)
【2】[fluentd-plugin-s3 project](https://github.com/fluent/fluent-plugin-s3)
【3】另外在业务场景满足的情况下，可以选择[fluent-bit](https://docs.fluentbit.io/manual/)替代fluent：
    根据在本方案的生产环境中单机测试结果来看：
        fluent-bit 的qps范围在4000左右；
        fluent的qps范围在10000左右；
    但是较于fluent，fluent-bit更为轻量级；官网也更为推荐fluent-bit，但是在实践时间段内（2019年12月-2020年5月）fluent-bit的config options支持还不够完善；

【4】[fluent-bit-go-s3 docker images](https://hub.docker.com/r/cosmo0920/fluent-bit-go-s3/dockerfile)
 