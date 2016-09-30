//
//  MyDragButton.m
//  MyFloatButton
//
//  Created by Mike on 2016/9/29.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "MyDragButton.h"

#define screenwidth [[UIScreen mainScreen] bounds].size.width
#define screenheight [[UIScreen mainScreen] bounds].size.height

@interface MyDragButton ()
{
    CGPoint currPoint;//记录按钮移动的位置
    BOOL isTouched;//是否是点击手势
}
@end

@implementation MyDragButton

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImageEdgeInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
        [self setImage:[UIImage imageNamed:@"FloatMain"] forState:UIControlStateNormal];
        [self setSelected:NO];
        self.adjustsImageWhenHighlighted = NO;
        self.backgroundColor = [UIColor grayColor];
        self.imageView.alpha = 0.8;
        self.layer.cornerRadius = CGRectGetWidth(frame)/2;
        self.layer.masksToBounds = YES;
        isTouched = NO;
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [touches anyObject];
    //获得开始移动时的位置
//    startPoint = [touch locationInView:_rootView];
}

/**
 *  拖动按钮时，记录拖动位置
 */
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    //获得移动后，button中心点的位置变换
    CGPoint movePoint = [touch locationInView:_rootView];
    
    //限制按钮中心店的距离屏幕top 和bottom的最小距离
    CGFloat limitedToTop = 64 + CGRectGetHeight(self.frame)/2;
    CGFloat limitedToBottom = 50 + CGRectGetHeight(self.frame)/2;
    
    if (movePoint.y <= limitedToTop) {
        //拖动位置在导航栏的范围内，则将按钮的位置定位在导航栏下
        self.center = CGPointMake(movePoint.x, limitedToTop);
        currPoint = CGPointMake(movePoint.x, limitedToTop);
    }else if(currPoint.y >= (screenheight-limitedToBottom)){
        //拖动位置在底部tabbar的范围内，则将按钮的位置定位在tabbar上
        self.center = CGPointMake(movePoint.x, (screenheight - limitedToBottom));
        currPoint = CGPointMake(movePoint.x, (screenheight - limitedToBottom));
    }else{
        self.center = movePoint;
        currPoint = movePoint;
    }
    //主按钮开始移动，执行回调，更新子按钮的位置
    if (self.floatBtnMoved)self.floatBtnMoved();
}

/**
 *  拖动手势结束时，根据按钮的位置确定吸附方向
 */
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [self chooseDirection];
}

/**
 *  拖动手势结束，根据按钮的位置确定吸附方向
 */
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [self chooseDirection];
}

/**
 *  根据button的位置确定吸附方向
 */
-(void)chooseDirection{
    
    CGPoint endPoint;//记录按钮的最终位置
    Direction currDirection;//当前吸附方向
    
    //判断是点击事件还是拖动事件
    if (CGPointEqualToPoint(currPoint, CGPointZero)) {
        endPoint = self.center;
        isTouched = YES;
        //点击事件，执行点击事件回调
        if (self.floatBtnClicked)self.floatBtnClicked(self.center);
    }else{
        endPoint = currPoint;
        isTouched = NO;
    }
    
    // 与四个屏幕边界距离
    CGFloat left = endPoint.x;
    CGFloat right = screenwidth - endPoint.x;
//    CGFloat top = endPoint.y;
//    CGFloat bottom = screenheight - endPoint.y;
    
    
    if (left<right) {
        currDirection = LEFT;
    }else{
        currDirection = RIGHT;
    }
    
    //确定吸附方向后，开始吸附到屏幕边缘，
    [self locatedToScreenEdge:currDirection];
    
    //计算完成后，重置point，以免干扰下次手势操作
    currPoint = CGPointZero;
}

/**
 *  吸附到屏幕边缘
 */
-(void)locatedToScreenEdge:(Direction)direction{
    switch (direction) {
        case TOP:
            
            break;
        case LEFT:
        {
            [UIView animateWithDuration:0.3 animations:^{
                
                //向下拖动按钮速度很快并超出屏幕范围时，不会进 touchesMoved方法，需要重新判断按钮的位置
                CGFloat y;
                
                if (self.center.y <94) {
                    y = 94;
                }else if (self.center.y>(screenheight- 80)){
                    y =screenheight- 80;
                }else{
                    y = self.center.y;
                }

                self.center = CGPointMake(30, y);
                //主按钮开始移动，执行回调，更新子按钮的位置
                if (self.floatBtnMoved&&!isTouched)self.floatBtnMoved();
            }];
            break;
        }
        case RIGHT:
        {
            [UIView animateWithDuration:0.3 animations:^{
                
                CGFloat y;
                //向下拖动按钮速度很快并超出屏幕范围时，不会进 touchesMoved方法，需要重新判断按钮的位置
                if (self.center.y <94) {
                    y = 94;
                }else if (self.center.y>(screenheight- 80)){
                    y =screenheight- 80;
                }else{
                    y = self.center.y;
                }
                
                self.center = CGPointMake(screenwidth - 30, y);
                //主按钮开始移动，执行回调，更新子按钮的位置
                if (self.floatBtnMoved&&!isTouched)self.floatBtnMoved();
            }];
            break;
        }
        case BOTTOM:
            
            break;
            
        default:
            break;
    }
}

@end
