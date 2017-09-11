//
//  SPQiniuUtils.m
//
//  Created by hanyutong on 2017/5/17.
//

#import "SPQiniuUtils.h"

#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@implementation SPQiniuUtils 

- (void)uploadImageToQNFileArray:(NSArray *)fileArray {
    
    //请求token地址
    NSString * apiPath;
    
    //视频地址
    if(fileArray!=nil && fileArray.count==0 && [fileArray[0] isKindOfClass:[NSString class]]){
        apiPath = QINIU_UPLOAD_VIDEO_TOKEN;
    }else{
        apiPath = QINIU_UPLOAD_IMAGE_TOKEN;
    }
    
    //获取上传图片用的七牛云token
    [SPNetworkUtils postRequestWithPath:apiPath params:nil completed:^(id responseData) {
        NSLog(@"%@",responseData);
        if (responseData[@"data"]){
            [self uploadWithToken:responseData[@"data"] andFileArray:fileArray];
        }else{
            
        }
    }];

}

-(void)uploadWithToken:(NSString *)token andFileArray:(NSArray *)fileArray
{
    //华北
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = [QNZone zone1];
    }];
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        NSLog(@"percent == %.2f", percent);
    }params:nil checkCrc:NO cancellationSignal:nil];
    NSMutableArray * keyArray = [NSMutableArray array];
    
    
#warning --如果 block中未返回结果。。循环已经继续了，imageVo内数据已经变化了，会有问题
    for (int i = 0; i<fileArray.count; i++)
    {

        NSData * fileData = nil;
        SPImageVo * imageVo = [[SPImageVo alloc] init];
        //视频地址
        if ([fileArray[i] isKindOfClass:[NSString class]])
        {
            fileData = [NSData dataWithContentsOfFile:fileArray[i]];
        }
        else
        {
            UIImage * image = fileArray[i];
            fileData = UIImagePNGRepresentation(image);
            imageVo.imageWidth = image.size.width;
            imageVo.imageHeight = image.size.height;
         }
        
        [upManager putData:fileData key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            NSLog(@"info ===== %@", info);
            NSLog(@"resp ===== %@", resp);
            
            imageVo.fileName = resp[@"key"];
            [keyArray addObject:[imageVo mj_JSONObject]];
            
            if (keyArray.count == fileArray.count)
            {
                if ([self.delegate respondsToSelector:@selector(uploadImageDelegate:)]) {
                    [self.delegate uploadImageDelegate:keyArray];
                }
            }
            else
            {
                //有失败图片
            }
        } option:uploadOption];
        
        
    }

    
}


+ (NSString*)qiNiuDomainName{
    return @"http://oopbjmcxn.bkt.clouddn.com/";
}



@end
