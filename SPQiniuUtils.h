//
//  SPQiniuUtils.h
//
//  Created by hanyutong on 2017/5/17.
//

#import <Foundation/Foundation.h>
#import <QiniuSDK.h>

#import "SPImageVo.h"

@protocol SPQiniuUtilsDelegage <NSObject>

- (void)uploadImageDelegate:(NSMutableArray *)qiniuModelArray;

@end

@interface SPQiniuUtils : NSObject

@property (nonatomic, weak) id <SPQiniuUtilsDelegage>delegate;

- (void)uploadImageToQNFileArray:(NSArray *)fileArray;
+ (NSString*)qiNiuDomainName;

@end
