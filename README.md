# StudyiOS
oc综合项目,ios综合项目,拖拽播放,打印ios日志,省市区三级联动,YYText使用,列表的展开和收起,Masonry案例,倒计时,H5和原生交互,自定义各种弹框…


#### 一、YYKeyChainData

获取UUID的方法有很多，但是都会因为各种原因改变
```
/**  卸载应用重新安装后会不一致*/
+ (NSString *)getUUID{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    NSString *UUID = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return UUID;
}
 
/**  卸载应用重新安装后会不一致*/
+ (NSString *)getUUID{
    return [UIDevice currentDevice].identifierForVendor.UUIDString;;
}
 
/** 不会因为应用卸载改变 
  * 但是用户在设置-隐私-广告里面限制广告跟踪后会变成@"00000000-0000-0000-0000-000000000000"
  * 重新打开后会变成另一个，还原广告标识符也会变
  */
+ (NSString *)getUUID{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}
```

作为设备唯一的标识符，一言不合就变了肯定是不行的呀

在产品汪的逼迫下，在我不懈的努力下，我终于找到一个可以一直保持一致的方法。第一次获取成功后保存到钥匙串，然后每次使用都通过钥匙串去拿。

第一步,打开应用的钥匙串权限
Target - Capabilities - KeychainSharing - ON
![图一](https://github.com/KennyHito/StudyiOS/blob/main/StudyiOS/Resource/Images/YYKeyChainData_1.png)

第二步,集成YYKeyChainData

导入头文件
```
#import "YYKeyChainData.h"
```
类方法调用即可使用
```
[YYKeyChainData getUUIDByKeyChain]
```

注意:
上架App Store需要按图二配置
![图二](https://github.com/KennyHito/StudyiOS/blob/main/StudyiOS/Resource/Images/YYKeyChainData_2.png)


无论你怎么折腾都会保证同一设备每次获取到的UUID都是一致的，卸载应用，开启广告限制跟踪，系统升级都不会有影响。越狱刷机这种骚操作我没有测过，即使有问题，感觉这些调皮的用户也可以忽略了，因为这个已经是目前最好的解决办法了，如果大家有什么更好的解决方案，还请issues区指正。
