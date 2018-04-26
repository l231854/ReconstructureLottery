//
//  SUMRequest.m
//  sumei
//
//  Created by wayne on 16/11/9.
//  Copyright © 2016年 施冬伟. All rights reserved.
//

#import "CookBook_Request.h"
#import "NSString+XDJEncrypt.h"

@interface CookBook_Request ()
{
    NSString *_requestApiName;
    NSDictionary *_requestParams;
    YTKRequestMethod _requestMethod;
    NSDictionary *_resultInfo;
    NSArray *_resultArrayInfo;
    NSDictionary *_businessData;
    NSArray *_businessDataArray;

    

}
@property (nonatomic, copy, nullable) SUMRequestCompletionBlock successCompletion;
@property (nonatomic, copy, nullable) SUMRequestCompletionBlock failureCompletion;
@property (nonatomic, assign)YTKResponseSerializerType customResponseSerializerType;

@property(nonatomic,copy)NSString *domainString;
@end

@implementation CookBook_Request

-(NSString *)baseUrl
{
//    return _domainString?_domainString:@"http://47.89.51.31";
//    return _domainString?_domainString:@"http://cp89.cp-ht.net";
    return _domainString?_domainString:@"https://cp89.c-p-a-p-p.net";

}

-(NSString *)requestUrl
{
    NSURL *url = [NSURL URLWithString:self.baseUrl];
    NSString *path = url.path;
    if (path.length>0 && _requestApiName.length>0) {
        NSString *finalPah = [path wayStringByAppendingPathComponent:_requestApiName];
        return finalPah;
    }
    return _requestApiName?_requestApiName:@"";
}

-(id)requestArgument
{
    return _requestParams;
}

- (YTKRequestMethod)requestMethod {
    return _requestMethod;
}

-(YTKResponseSerializerType)responseSerializerType
{
    return _customResponseSerializerType;
}

-(instancetype)initWithApiName:(NSString *)ipaName
                        params:(NSDictionary *)params
                  rquestMethod:(YTKRequestMethod)requestMethod
             successCompletion:(SUMRequestCompletionBlock)successCompletion
             failuerCompletion:(SUMRequestCompletionBlock)failuerCompletion;
{
    if (self = [super init]) {
        
        _requestApiName = ipaName;
        _requestParams = params;
        _requestMethod = requestMethod;
        self.customResponseSerializerType = YTKResponseSerializerTypeHTTP;
        self.successCompletion = successCompletion;
        self.failureCompletion = failuerCompletion;
        
    }
    return self;
}

#pragma mark- response

-(NSDictionary *)resultInfo
{
    if (!_resultInfo) {
        
        NSString *jsonString = [NSString decryptByGBKAES:self.responseString];
        if (jsonString) {
            
            _resultInfo = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        }
    }
    if ([_resultInfo isKindOfClass:[NSDictionary class]]) {
        NSString *token = [_resultInfo DWStringForKey:@"token"];
        if (token.length>0) {
            [[CookBook_User shareUser]cookBook_addToken:token];
        }
    }
//    NSString *aesString = @"G0Uj2lEn5Rj/+uT2/Hf5XMMmXodwortKvq5FEJMipsJyo7r6vO4fbr12MXc2CCCgYCHRgnEX5rW8AsG9UINIK6Nsm1y8cSfN1matzWF8gJa3IVsubcCMD9UlSK+4Wama7OY//hHhjhZ0R+BseGI6HwzI6/QriLZfrEmTdm9L5BDzU4H6yl/UmrsAPnPxVdZ45NH00hGcKP0vK/UyY/viLSYLZEH789dj5abVYk2n/SbVFmxxUXGNFSbJYXA292KaWTkANMzOEMBLeGZd47ZkWKlkxGZ/MpIQsHJPkxEeSNM=";
//    NSString *json2 = [NSString decryptByGBKAES:aesString];
//    NSLog(@"%@",json2);
    
    return _resultInfo?:[NSDictionary new];
}

-(NSArray *)resultArrayInfo
{
    if (!_resultArrayInfo) {
        
        NSString *html = self.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if ([dict isKindOfClass:[NSArray class]]) {
            _resultArrayInfo = dict;
        }
        
    }
    return _resultArrayInfo?:[NSArray new];
}

-(NSDictionary *)businessData
{
    if (!_businessData) {
        
        _businessData = [self.resultInfo objectForKey:@"data"];
        _businessData = [_businessData isKindOfClass:[NSDictionary class]]?_businessData:[NSDictionary new];
    }
    return _businessData;
}

-(NSArray *)businessDataArray
{
    if (!_businessDataArray) {
        
        _businessDataArray = [self.resultInfo objectForKey:@"data"];
        _businessDataArray = [_businessDataArray isKindOfClass:[NSArray class]]?_businessDataArray:[NSArray new];
    }
    return _businessDataArray;
}

-(BOOL)resultIsOk
{
    BOOL isOK = NO;
    id des = [self.resultInfo objectForKey:@"description"];
    int status = [[self.resultInfo DWStringForKey:@"status"]intValue];

    if ([des isKindOfClass:[NSString class]]) {
        if ([des isEqualToString:@"OK"] || status == 200) {
            isOK = YES;
        }
    }
    return isOK;
}


-(id)resultMsg
{
    id msg = [self.resultInfo  objectForKey:@"msg"];
    return msg;
}

-(NSString *)requestDescription
{
    NSString *des = [self.resultInfo  DWStringForKey:@"description"];
    des = des?des:@"";
    return des;
}

#pragma mark-

+(void)cookBook_startWithApiName:(NSString *)apiName
                 params:(NSDictionary *)params
           rquestMethod:(YTKRequestMethod)requestMethod
completionBlockWithSuccess:(SUMRequestCompletionBlock)success
                failure:(SUMRequestCompletionBlock)failure
{
    CookBook_Request *sumRequest = [[CookBook_Request alloc]initWithApiName:apiName
                                                      params:params
                                                   rquestMethod:requestMethod
                                           successCompletion:success
                                           failuerCompletion:failure];
    
    [sumRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
    
        if ([request isKindOfClass:[CookBook_Request class]]) {
            CookBook_Request *sRequest = (CookBook_Request *)request;
            if (sRequest.successCompletion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    sRequest.successCompletion(sRequest);
                });
            }
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if ([request isKindOfClass:[CookBook_Request class]]) {
            CookBook_Request *sRequest = (CookBook_Request *)request;
            if (sRequest.failureCompletion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    sRequest.failureCompletion(sRequest);
                });
            }
        }
    }];
}

+(void)cookBook_startWithDomainString:(NSString *)domainString
                     apiName:(NSString *)apiName
                 params:(NSDictionary *)params
           rquestMethod:(YTKRequestMethod)requestMethod
completionBlockWithSuccess:(SUMRequestCompletionBlock)success
                failure:(SUMRequestCompletionBlock)failure
{
    CookBook_Request *sumRequest = [[CookBook_Request alloc]initWithApiName:apiName
                                                         params:params
                                                   rquestMethod:requestMethod
                                              successCompletion:success
                                              failuerCompletion:failure];
    sumRequest.domainString = domainString;
    
    [sumRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if ([request isKindOfClass:[CookBook_Request class]]) {
            CookBook_Request *sRequest = (CookBook_Request *)request;
            if (sRequest.successCompletion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    sRequest.successCompletion(sRequest);
                });
            }
            if (sRequest.resultInfo) {
                if ([CookBook_User shareUser].tokenInfo.errorMsg.length>0) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationNameForLoginOutTime object:nil];
                }
            }
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if ([request isKindOfClass:[CookBook_Request class]]) {
            CookBook_Request *sRequest = (CookBook_Request *)request;
            if (sRequest.failureCompletion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    sRequest.failureCompletion(sRequest);
                });
            }
        }
    }];
}

+(CookBook_Request *)cookBook_startRequestWithDomainString:(NSString *)domainString
                                    apiName:(NSString *)apiName
                                     params:(NSDictionary *)params
                               rquestMethod:(YTKRequestMethod)requestMethod
                 completionBlockWithSuccess:(SUMRequestCompletionBlock)success
                                    failure:(SUMRequestCompletionBlock)failure
{
    CookBook_Request *sumRequest = [[CookBook_Request alloc]initWithApiName:apiName
                                                         params:params
                                                   rquestMethod:requestMethod
                                              successCompletion:success
                                              failuerCompletion:failure];
    sumRequest.domainString = domainString;
    
    [sumRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if ([request isKindOfClass:[CookBook_Request class]]) {
            CookBook_Request *sRequest = (CookBook_Request *)request;
            if (sRequest.successCompletion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    sRequest.successCompletion(sRequest);
                });
            }
            if (sRequest.resultInfo) {
                if ([CookBook_User shareUser].tokenInfo.errorMsg.length>0) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationNameForLoginOutTime object:nil];
                }
            }
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if ([request isKindOfClass:[CookBook_Request class]]) {
            CookBook_Request *sRequest = (CookBook_Request *)request;
            if (sRequest.failureCompletion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    sRequest.failureCompletion(sRequest);
                });
            }
        }
    }];
    return sumRequest;
}



@end
