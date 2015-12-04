# GJNetWorking
\n
功能：\n
1，基于AFNetWorking的接口基类封装\n
2，接口缓存策略，根据接口需要使用\n
  （1），不用缓存，不存缓存\n
  （2），请求失败时使用缓存(如果缓存有效期内)，存储缓存\n
  （3），如果有缓存，则用缓存，不请求(如果缓存有效期内)，存储缓存\n
3，实现GJModelMakerDelegate中\n
- (id)makeModelWithJSON:(NSDictionary *)json
                  class:(Class)modelClass
                 status:(id __autoreleasing *)status;\n
协议，进行model合成\n
同时需要接口实现了- (Class)modelClass方法，直接返回model。\n
返回的参数中，responseObject为model，status可像例子中返回请求状态的model等数据。\n
\n\n
此项目在测试中，欢迎提bug\n
