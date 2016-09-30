//
//  FloatingViewController.h
//  MyFloatButton
//
//  Created by Mike on 2016/9/29.
//  Copyright © 2016年 Mike. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface FloatingViewController : UIViewController

@property(nonatomic,assign) BOOL isCollected;//是否收藏
@property(nonatomic,assign) BOOL isPraised;//是否点赞

/**
 *  收藏接口
 */
@property(nonatomic,strong) NSString *collectionUrl;
@property(nonatomic,strong) NSDictionary *collectionPara;
@property(nonatomic,copy) void(^collectionBlock)(BOOL result);//收藏成功后的页面处理

/**
 *  点赞接口
 */
@property(nonatomic,strong) NSString *praiseUrl;
@property(nonatomic,strong) NSDictionary *praiseDic;
@property(nonatomic,copy) void(^praiseBlock)(BOOL result);//点赞成功后的页面处理

/**
 *  分享接口
 */
@property(nonatomic,strong) NSString *shareUrl;
@property(nonatomic,strong) NSDictionary *shareDic;
@property(nonatomic,copy) void(^shareBlock)();//评论成功后的页面处理

/**
 *  滚动到scroll顶部
 */
@property(nonatomic,copy) void(^scrollToTop)();

@end
