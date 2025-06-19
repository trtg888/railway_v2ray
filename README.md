# railway-xray-new
# 使用Railway部署Xray高性能代理服务，通过ws传输的 (vmess、vless、trojan shadowsocks、socks)等协议

> 提醒： 滥用可能导致账户被BAN！！！ 

# 9月21日修复

# 首先声明一下

### 本项目为 https://github.com/Lbingyi/HerokuXray 大佬的heroku项目修改，因为有人反映同时fork二者会有冲突，我才将此重新上传改为本人的项目
### 不是剽窃，感谢Lbingyi大佬的付出，谢谢！
#### 另外在此批评 github id ： `zzysite` 尊重他人智力成果 ，加上原作者的备注，谢谢

[![55Egg.png](https://i.w3tt.com/2021/09/08/55Egg.png)](https://img.tg/image/55Egg)

## 概述

### 官网：railway.app

用于在 railway 上部署 vless+websocket+tls，每次部署自动选择最新的 alpine linux 和 Xray core 。  
vless 性能更加优秀，占用资源更少。

* 使用[xray](https://github.com/XTLS/Xray-core)+caddy同时部署通过ws传输的vmess vless trojan shadowsocks socks等协议，并默认已配置好伪装网站。
* 支持tor网络，且可通过自定义网络配置文件启动xray和caddy来按需配置各种功能  
* 支持存储自定义文件,目录及账号密码均为UUID,客户端务必使用TLS连接  

～～～～～～～～～～～～～～～～
## 机场推荐：
3元一月，全球多地流媒体解锁，中转节点晚高峰8k不卡。适合全国大部分网络
注册地址：https://suo.yt/R7Fxm66
～～～～～～～～～～～～～～～～



### 服务端

fork 之后 ，在railway的dashboard，选择 new project
[![CHIH8A.png](https://www.helloimg.com/images/2021/09/05/CHIH8A.png)](https://www.helloimg.com/image/CHIH8A)
然后在github中选中本仓库
[![5oSpg.png](https://i.w3tt.com/2021/09/05/5oSpg.png)](https://img.tg/image/5oSpg)

### 客户端
* **务必替换所有的`xxx.railway.app`为railway分配的项目域名**  
* **务必替换所有的`24b4b1e1-7a89-45f6-858c-242cf53b5bdb`为部署时设置的UUID,建议更改,不要每个人都一样**  

**XRay 将在部署时会自动实配安装`最新版本`。**



<details>
<summary>V2rayN(Xray、V2ray)</summary>

```bash
* 客户端下载：https://github.com/2dust/v2rayN/releases
* 代理协议：vless 或 vmess
* 地址：xxx.herokuapp.com
* 端口：443
* 默认UUID：24b4b1e1-7a89-45f6-858c-242cf53b5bdb
* vmess额外id：0
* 加密：none
* 传输协议：ws
* 伪装类型：none
* 伪装域名：xxx.workers.dev(CF Workers反代地址)
* 路径：/24b4b1e1-7a89-45f6-858c-242cf53b5bdb-vless // 默认vless使用(/自定义UUID码-vless)，vmess使用(/自定义UUID码-vmess)
* 底层传输安全：tls
* 跳过证书验证：false
```
</details>

<details>
<summary>Trojan-Go</summary>

```bash
* 客户端下载: https://github.com/p4gefau1t/trojan-go/releases
{
    "run_type": "client",
    "local_addr": "127.0.0.1",
    "local_port": 1080,
    "remote_addr": "xxx.herokuapp.com",
    "remote_port": 443,
    "password": [
        "24b4b1e1-7a89-45f6-858c-242cf53b5bdb"
    ],
    "websocket": {
        "enabled": true,
        "path": "/24b4b1e1-7a89-45f6-858c-242cf53b5bdb-trojan",
        "host": "xxx.herokuapp.com"
    }
}
```
</details>

<details>
<summary>Shadowsocks</summary>

```bash
* 客户端下载：https://github.com/shadowsocks/shadowsocks-windows/releases/
* 服务器地址: xxx.herokuapp.com
* 端口: 443
* 密码：24b4b1e1-7a89-45f6-858c-242cf53b5bdb
* 加密：chacha20-ietf-poly1305
* 插件程序：xray-plugin_windows_amd64.exe  //需将插件https://github.com/shadowsocks/xray-plugin/releases下载解压后放至shadowsocks同目录
* 插件选项: tls;host=xxx.herokuapp.com;path=/24b4b1e1-7a89-45f6-858c-242cf53b5bdb-ss
```
</details>

<details>
<summary>可以使用Cloudflare的Workers来中转流量，（支持VLESS\VMESS\Trojan-Go的WS模式）配置为：</summary>

```js
const SingleDay = 'xxx.up.railway.app'
const DoubleDay = 'xxx.up.railway.app'
addEventListener(
    "fetch",event => {
    
        let nd = new Date();
        if (nd.getDate()%2) {
            host = SingleDay
        } else {
            host = DoubleDay
        }
        
        let url=new URL(event.request.url);
        url.hostname=host;
        let request=new Request(url,event.request);
        event. respondWith(
            fetch(request)
        )
    }
)
```
</details>

## OpenWrt优选IP脚本自动更新：

* [CloudflareST](https://github.com/Lbingyi/CloudflareST) `OpenWrt推荐-速度较快`
* [cf-autoupdate](https://github.com/Lbingyi/cf-autoupdate) `OpenWrt推荐`

> [更多来自热心网友PR的使用教程](/tutorial)

## 关于CF筛选IP

* 请参考 [CloudflareSpeedTest](https://github.com/XIU2/CloudflareSpeedTest) `推荐`
* 请参考 [better-cloudflare-ip](https://github.com/badafans/better-cloudflare-ip)

## 🌐 多用户使用说明

服务默认监听 443 端口，路径为 `/vless`，每个用户一个 UUID，由环境变量 `UUIDS` 控制。

### ✍️ 设置方式（Railway 环境变量）
