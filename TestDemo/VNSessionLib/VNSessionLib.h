
#import <Foundation/Foundation.h>
@protocol VNRequestResult
-(void) webResponse:(NSDictionary*)responseDictionary;
@end
@interface VNSessionLib : NSObject<NSURLSessionTaskDelegate,NSURLSessionDataDelegate,NSURLSessionDelegate>
{
    __weak id<VNRequestResult> delegate;
    NSMutableData *webData;
}
@property (nonatomic) NSString *strTitle;
@property (nonatomic,strong) NSURLSession *session;
@property (nonatomic,strong) NSURLSessionDataTask *finderTask;
@property(weak,nonatomic)	id<VNRequestResult> delegate;
@property(strong,nonatomic) NSDictionary *responseDictionary;
-(void) makeConnection :(NSString*)req;

@end
