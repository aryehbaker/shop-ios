//
//  VTHttpBase.m
//  Shoprize
//
//  Created by vniapp on 11/3/14.
//  Copyright (c) 2014 techwuli.com. All rights reserved.
//

#import "VIHttpBase.h"

@implementation VIHttpBase

//add media to file
- (void)setMediaToRequest:(MKNetworkOperation *)operation params:(NSMutableDictionary *)params
{
    for (NSString *key in params.allKeys) {
        id val = [params objectForKey:key];
        if ([val isKindOfClass:[UIImage class]]) {
            [operation addData:UIImagePNGRepresentation(val) forKey:key mimeType:@"image/png" fileName:
             Fmt(@"%@.png",[NSString randString])];
        }
        if ([val isKindOfClass:[NSData class]]) {
            [operation addData:val forKey:key];
        }
        if ([val isKindOfClass:[VIHttpFile class]]) {
            VIHttpFile *f = (VIHttpFile *)val;
            [operation addData:f.postData forKey:key mimeType:f.mineType fileName:f.fileName];
        }
    }
}

//Find the host and the path
- (NSArray *)findHostAndPath:(NSString *)url
{
    NSURL *uri = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableString *mt = [NSMutableString stringWithString:uri.path];
    if ([uri query]!=nil) {
        [mt appendFormat:@"?%@",uri.query];
    }
    
    return @[ (uri.port == nil || [uri.port integerValue] == 80)? uri.host : [NSString stringWithFormat:@"%@:%@",uri.host,uri.port],mt];
    
}
//http type string
- (NSString *)httpTypeString:(HTTP_METHOD_TYPE)type
{
    switch (type) {
        case HTTP_MD_POST: return @"POST";
        case HTTP_MD_GET: return @"GET";
        case HTTP_MD_PUT: return @"PUT";
        case HTTP_MD_DELETE: return @"DELETE";
        case HTTP_MD_INPUT: return @"INPUT";
        default:
            return @"GET";
            break;
    }
}

//添加数据
- (NSDictionary *)headers
{
    return @{};
}

@end
