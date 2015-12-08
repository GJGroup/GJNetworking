# GJNetWorking


这是一个对接口进行封装的库，网络层请求基于AFNetWorking2.x，使用command patern，使用中对每一个接口进行单独的封装，增强接口的复用性，以及提供了一些额外的功能。这套库是基于我们项目的需求开始进行开发的，所以有一些config并没有完全加入进来，如果有此方面或者其他功能的需求，请及时给我们提建议，我们会不断改进。此项目由GJ（搞基）小组进行开发。

## 加载文件

- 下载GJNetWorking；
- 将工程目录中GJNetWorking文件夹加入到项目中；
- 将AFNetWorking加入到工程中；

## 支持的iOS版本

- 因为AFNetWorking2.6版本支持iOS7.0+，所以此库也从iOS7支持开始

## 开始


### 配置config文件

```objective-c
[GJNetworkingConfig setDefaultBaseUrl:@"http://"
               acceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]
             allowInvalidCertificates:YES
                  validatesDomainName:NO
                    maxOperationCount:4
                      timeOutInterval:20
                           modelMaker:[MantleModelMaker class]];
[GJNetworkingConfig setCacheDirectory:@"apiCache"];
```
其中MantleModelMaker是实现model处理协议的类
setCacheDirectory:是接口缓存地址文件，统一保存在Libiray/Caches下


### 创建接口类

创建你的接口类，继承自GJModelRequest，然后实现如下一个协议，以配置你的接口信息

```objective-c
//若config中配置了baseUrl，则可不实现，若个别接口想跟config中得url不一致，可单独在这里实现
- (NSString *)baseUrl {
    return @"http://google.com";
}

//url的path
- (NSString *)path {
    return @"userAcount/userLevel";
}

//请求的参数
- (NSDictionary *)parameters {
    return @{@"name":@"steff",@"age":@"30"};

//请求失败后重试次数
- (NSUInteger)retryTimes {
    return 3;
}

//请求超时时间
- (NSTimeInterval)timeOutInterval {
    return 60.0 x 60;
}

```

### 将数据处理成model

若需要直接返回model，则需要再config中传入实现处理model协议的类

```objective-c
+ (id)makeModelWithJSON:(NSDictionary *)json
                  class:(Class)modelClass
                 status:(id __autoreleasing *)status;

```
创建一个类，conform <GJModelMakerDelegate>协议，同时实现此协议，例如：
```objective-c
+ (id)makeModelWithJSON:(NSDictionary *)json
                  class:(Class)modelClass
                 status:(id __autoreleasing *)status {

    MTLJSONAdapter *adapter = [[MTLJSONAdapter alloc] initWithModelClass:[GCStatus class]];
    GCStatus *sta = [adapter modelFromJSONDictionary:json error:nil];
    *status = sta;

    id dataJson = json[@"data"];
    if ([dataJson isKindOfClass:[NSDictionary class]]) {
        adapter = [[MTLJSONAdapter alloc] initWithModelClass:modelClass];
        id model = [adapter modelFromJSONDictionary:dataJson error:nil];
        return model;
    }
    else if ([dataJson isKindOfClass:[NSArray class]]) {
        NSArray *array = [MTLJSONAdapter modelsOfClass:modelClass fromJSONArray:dataJson error:nil];
        return array;
    }

    NSLog(@"unavailable json!");
    return nil;
}
```

同时需要接口实现modelClass这个协议方法，告诉上面的类需要将数据转成什么类型的对象，这里可以用各种方法进行转换，我这里使用Mantle，当然也可以使用别的类库。

```objective-c
//此接口需要将数据处理成model的model类型
- (Class)modelClass {
    return [UserInfo class];
}
```



