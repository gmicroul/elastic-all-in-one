说明：

本docker-compose实现了以下功能：

1.密码登陆

2.可以愉快添加fleet/elastic agent

3.security配置

4.配置监控B站视频观看人数

# 参考配置文件：logstash.conf
# 暂时实现：非在线更新视频号，需拷贝两个文件到容器再重启容器
# sudo docker cp logstash.conf logstash:/usr/share/logstash/config/logstash.conf
# sudo docker cp logstash.conf logstash:/usr/share/logstash/pipeline/logstash.conf 
# sudo docker restart logstash
<img width="1645" alt="image" src="https://github.com/user-attachments/assets/cb8329c8-1cdc-4e2c-8340-1c4921086e73" />


不足的地方：

1.docker dashboard容器数量不准确，已提交issue

2.fleet的各种dashboard功能不完善，没有数据

4.等3

3.The Elastic Synthetics integration is a method for creating synthetic monitors that is no longer recommended. Do not use the Elastic Synthetics integration to set up new monitors.（里面有一些过期不包的，就别用了，更新很快，体验之后不爽的可以忽略，比如英文这个）
