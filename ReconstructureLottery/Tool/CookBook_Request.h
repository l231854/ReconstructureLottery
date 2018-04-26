//
//  SUMRequest.h
//  sumei
//
//  Created by wayne on 16/11/9.
//  Copyright © 2016年 施冬伟. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>



@interface CookBook_Request : YTKRequest

typedef void(^SUMRequestCompletionBlock)(__kindof CookBook_Request *request);


@property(nonatomic,retain,readonly)NSDictionary *resultInfo;
@property(nonatomic,retain,readonly)NSArray *resultArrayInfo;
@property(nonatomic,retain,readonly)NSDictionary *businessData;
@property(nonatomic,retain,readonly)NSArray *businessDataArray;
@property(nonatomic,copy,readonly)NSString *requestDescription;


@property(nonatomic,assign,readonly)BOOL resultIsOk;
@property(nonatomic,assign,readonly)id resultMsg;

+(void)cookBook_startWithApiName:(NSString *)apiName
                          params:(NSDictionary *)params
                    rquestMethod:(YTKRequestMethod)requestMethod
      completionBlockWithSuccess:(SUMRequestCompletionBlock)success
                         failure:(SUMRequestCompletionBlock)failure;

+(void)cookBook_startWithDomainString:(NSString *)domainString
                              apiName:(NSString *)apiName
                               params:(NSDictionary *)params
                         rquestMethod:(YTKRequestMethod)requestMethod
           completionBlockWithSuccess:(SUMRequestCompletionBlock)success
                              failure:(SUMRequestCompletionBlock)failure;

+(CookBook_Request *)cookBook_startRequestWithDomainString:(NSString *)domainString
                                                   apiName:(NSString *)apiName
                                                    params:(NSDictionary *)params
                                              rquestMethod:(YTKRequestMethod)requestMethod
                                completionBlockWithSuccess:(SUMRequestCompletionBlock)success
                                                   failure:(SUMRequestCompletionBlock)failure;

@end
