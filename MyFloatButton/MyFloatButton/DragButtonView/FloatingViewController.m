//
//  FloatingViewController.m
//  MyFloatButton
//
//  Created by Mike on 2016/9/29.
//  Copyright © 2016年 Mike. All rights reserved.
//


#import "FloatingViewController.h"
#import "MyDragButton.h"


#define screenwidth [[UIScreen mainScreen] bounds].size.width
#define screenheight [[UIScreen mainScreen] bounds].size.height

#define kwindow [[UIApplication sharedApplication] keyWindow]

const NSInteger count = 4;

@interface FloatingViewController ()
{
    NSMutableArray *btnArray;
    CGPoint center;//按钮中心位置
    CGFloat angle;//子按钮之间的夹角
}

/**
 *  悬浮的按钮
 */
@property(strong,nonatomic)MyDragButton *button;

@end

@implementation FloatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 将视图尺寸设置为0，防止阻碍其他视图元素的交互
    self.view.frame = CGRectZero;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!btnArray)[self initSubItems];
    [kwindow addSubview:self.button];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self hideFloatBtn];
}

/**
 *  创建悬浮按钮
 */
-(MyDragButton *)button{
    if (!_button) {
        _button = [[MyDragButton alloc] initWithFrame:CGRectMake(0, 200, 60, 60)];
        _button.rootView = kwindow;
        
        __weak FloatingViewController *weakSelf = self;
        _button.floatBtnClicked = ^(CGPoint point){
            [weakSelf floatBtnClickedAtPosition:point];
        };
        
        _button.floatBtnMoved = ^(){
            [weakSelf updateSubButtonCenter];
        };
    }
    
    return _button;
}

//初始化子按钮
-(void)initSubItems{
    btnArray = [NSMutableArray array];
    for (int i =0; i<count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.alpha = 0;
        btn.tag = 200 + i;
        btn.selected = NO;
        btn.layer.cornerRadius = 20;
        btn.layer.masksToBounds = YES;
        btn.backgroundColor = [UIColor grayColor];
        btn.frame = CGRectMake(0, self.button.center.y, 40, 40);
        NSString *imgName = [NSString stringWithFormat:@"floatBtn%d",i];
        [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [btn addTarget:self action:@selector(subBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [kwindow addSubview:btn];
        [btnArray addObject:btn];
    }
}

/**
 *  隐藏悬浮按钮
 */
-(void)hideFloatBtn{
    [UIView animateWithDuration:0.5 animations:^{
        self.button.alpha = 0;
        for (int i =0 ;i<btnArray.count; i++ ) {
            UIButton *btn = (UIButton *) [kwindow viewWithTag:200+i];
            btn.alpha = 0;
        }
    }completion:^(BOOL finished) {
        for (int i =0 ;i<btnArray.count; i++ ) {
            UIButton *btn = (UIButton *) [kwindow viewWithTag:200+i];
            [btn removeFromSuperview];
        }
        [self.button removeFromSuperview];
        btnArray = nil;
    }];
}

/**
 *  更新子按钮的位置
 */
-(void)updateSubButtonCenter{

    [self hideSubItems];
}

/**
 *  悬浮按钮点击
 */
- (void)floatBtnClickedAtPosition:(CGPoint)point
{
    // 按钮选中关闭切换
    self.button.selected = !self.button.selected;
   
    if (!self.button.selected) {
         [self hideSubItems];
    }else{
        
        [UIView animateWithDuration:0.5 animations:^{
            CGAffineTransform transform =CGAffineTransformMakeRotation(M_PI_4);
            [self.button setTransform:transform];
        }];
    
        //限制按钮到屏幕顶部的最小距离
        CGFloat limitedToTop = 64 + 80;
        //限制按钮到屏幕顶部的最大距离
        CGFloat limitedToBottom = 50 + 80;
        
        center = self.button.center;
        angle = M_PI/3;
        
        if (point.x == 30) {//悬浮按钮在屏幕左边
            
            if (point.y <= limitedToTop) {//悬浮按钮在屏幕左上方
                [self showButtonAtLeftTop];
            }else if (point.y >= (screenheight - limitedToBottom)){//悬浮按钮在屏幕左下方
                [self showButtonAtLeftBottom];
            }else{
                [self showButtonAtLeft];
            }
            
        }else if (point.x == (screenwidth - 30 )){//悬浮按钮在屏幕右边
            
            if (point.y <= limitedToTop) {//悬浮按钮在屏幕右上方
                [self showButtonAtRightTop];
            }else if (point.y >= (screenheight - limitedToBottom)){//悬浮按钮在屏幕右下方
                [self showButtonAtRightBottom];
            }else{
                [self showButtonAtRight];
            }
            
        }
    }
}

/**
 *  在屏幕左边显示子按钮
 */
-(void)showButtonAtLeft{
    
    for (int i =0 ;i<btnArray.count; i++ ) {
        UIButton *btn = (UIButton *) [kwindow viewWithTag:200+i];
        CGFloat x = center.x + cosf(-M_PI_2 + i * angle) * 60;
        CGFloat y = center.y + sinf(-M_PI_2 + i * angle) * 60;
        
        [UIView animateWithDuration:0.5 delay:0.1*i options:UIViewAnimationOptionTransitionNone animations:^{
            btn.alpha = 1;
            btn.center = CGPointMake(x, y);
        } completion:nil];
    }
}

/**
 *  在屏幕左上方显示子按钮
 */
-(void)showButtonAtLeftTop{

    for (int i =0 ;i<btnArray.count; i++ ) {
        UIButton *btn = (UIButton *) [kwindow viewWithTag:200+i];
        CGFloat x = center.x + cosf(i * angle / 2) * 80;
        CGFloat y = center.y + sinf(i * angle / 2) * 80;
        
        [UIView animateWithDuration:0.5 delay:0.1*i options:UIViewAnimationOptionTransitionNone animations:^{
            btn.alpha = 1;
            btn.center = CGPointMake(x, y);
        } completion:nil];
    }
}

/**
 *  在屏幕左下方显示子按钮
 */
-(void)showButtonAtLeftBottom{

    for (int i =0 ;i<btnArray.count; i++ ) {
        UIButton *btn = (UIButton *) [kwindow viewWithTag:200+i];
        CGFloat x = center.x + cosf(-M_PI/2 + i * angle / 2) * 80;
        CGFloat y = center.y + sinf(-M_PI/2 + i * angle / 2) * 80;
        
        [UIView animateWithDuration:0.5 delay:0.1*i options:UIViewAnimationOptionTransitionNone animations:^{
            btn.alpha = 1;
            btn.center = CGPointMake(x, y);
        } completion:nil];
    }
}

/**
 *  在屏幕右边显示子按钮
 */
-(void)showButtonAtRight{

    for (int i =(int)btnArray.count ;i>=0; i-- ) {
        UIButton *btn = (UIButton *) [kwindow viewWithTag:200+i];
        CGFloat x = center.x + sinf(-M_PI + i * angle) * 60;
        CGFloat y = center.y + cosf(-M_PI + i * angle) * 60;
        
        [UIView animateWithDuration:0.5 delay:0.1*i options:UIViewAnimationOptionTransitionNone animations:^{
            btn.alpha = 1;
            btn.center = CGPointMake(x, y);
        } completion:nil];
    }
}

/**
 *  在屏幕右上方显示子按钮
 */
-(void)showButtonAtRightTop{
    
    for (int i =(int)btnArray.count ;i>=0; i-- ) {
        UIButton *btn = (UIButton *) [kwindow viewWithTag:200+i];
        CGFloat x = center.x + sinf(-M_PI/2 + i * angle / 2) * 80;
        CGFloat y = center.y + cosf(-M_PI/2 + i * angle / 2) * 80;
        
        [UIView animateWithDuration:0.5 delay:0.1*i options:UIViewAnimationOptionTransitionNone animations:^{
            btn.alpha = 1;
            btn.center = CGPointMake(x, y);
        } completion:nil];
    }
}

/**
 *  在屏幕右下方显示子按钮
 */
-(void)showButtonAtRightBottom{
    
    for (int i =(int)btnArray.count ;i>=0; i-- ) {
        UIButton *btn = (UIButton *) [kwindow viewWithTag:200+i];
        CGFloat x = center.x + sinf(-M_PI + i * angle / 2) * 80;
        CGFloat y = center.y + cosf(-M_PI + i * angle / 2) * 80;
        
        [UIView animateWithDuration:0.5 delay:0.1*i options:UIViewAnimationOptionTransitionNone animations:^{
            btn.alpha = 1;
            btn.center = CGPointMake(x, y);
        } completion:nil];
    }
}

/**
 *  隐藏周围的子按钮，并且将主按钮恢复成默认为选中状态
 */
-(void)hideSubItems{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        CGAffineTransform transform =CGAffineTransformMakeRotation(0);
        [self.button setTransform:transform];
        self.button.selected = NO;
        
    }];
    
    for (int i =0 ;i<btnArray.count; i++ ) {
        UIButton *btn = (UIButton *) [kwindow viewWithTag:200+i];
        
        [UIView animateWithDuration:0.5 delay:0.1*i options:UIViewAnimationOptionTransitionNone animations:^{
            btn.alpha =0;
            btn.center = self.button.center;
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)subBtnClicked:(UIButton *)btn{
    if (btn.tag == 200) {//分享
        if (self.shareBlock)self.shareBlock();
    }else if (btn.tag == 201){//点赞
        if (self.praiseBlock)self.praiseBlock(YES);
    }else if (btn.tag == 202){//收藏
        if (self.collectionBlock)self.collectionBlock(YES);
    }else if (btn.tag == 203){//回到顶部
        if (self.scrollToTop)self.scrollToTop();
    }
}



@end
