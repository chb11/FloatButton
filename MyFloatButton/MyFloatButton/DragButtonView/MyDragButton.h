//
//  MyDragButton.h
//  MyFloatButton
//
//  Created by Mike on 2016/9/29.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

// 枚举四个吸附方向
typedef enum {
    LEFT,
    RIGHT,
    TOP,
    BOTTOM
}Direction;


@interface MyDragButton : UIButton

@property(nonatomic,strong) UIView *rootView;
//悬浮按钮点击事件回调
@property(nonatomic,copy) void(^floatBtnClicked)(CGPoint);
//悬浮按钮移动事件回调
@property(nonatomic,copy) void(^floatBtnMoved)();


@end
