AegisTrace

你接手了一段来自边缘网关的异常遥测。附件里有一份流量包和一个被剥离符号的遥测集中器二进制。

线上服务监听 9999 端口。你需要从流量包里恢复握手材料，再逆向二进制理解后续协议和对象完整性校验，最后利用服务读取 /flag。

文件：
- aegis_telemetry.pcap：异常遥测流量包
- aegis_service：远程服务同款 stripped ELF
- libc.so.6 / ld-linux-x86-64.so.2：本题环境参考运行库
