//
//  LoginViewController.m
//  objective_c_language
//
//  Created by 苏沫离 on 2018/5/31.
//  Copyright © 2018年 longlong. All rights reserved.
//

#define kLeftSpace 35.0
#define kTextContainerViewWidth (CGRectGetWidth(UIScreen.mainScreen.bounds) - kLeftSpace * 2.0)
#define kTextContainerViewHeight 50.0
#define kUpOffset 100.0



#import "LoginViewController.h"
#import "RegisterViewController.h"
#import <POP.h>
#import "UIView+Toast.h"
#import "MBProgressHUD+CustomView.h"
#import "GravityImageView.h"
#import "LoginTextView.h"
#import <Masonry.h>
#import "GlobalTools.h"
#import "HttpManager.h"

static CGFloat const YYSpringSpeed = 6.0;
static CGFloat const YYSpringBounciness = 16.0;


@interface LoginViewController()
<CAAnimationDelegate,UITextFieldDelegate>

{
    CGFloat _endPointY;
}

@property (nonatomic ,strong) UIImageView *logoImageView;
@property (nonatomic ,strong) UILabel *logoLable;
@property (nonatomic ,strong) UIButton *getButton;
@property (nonatomic,strong) UIView *textContainerView;//get按钮动画view
@property (nonatomic ,strong) LoginTextView *accountView;
@property (nonatomic ,strong) LoginTextView *passwordView;
@property (nonatomic ,strong) UIButton *loginButton;
//执行登录按钮动画的view (动画效果不是按钮本身，而是这个view)
@property (nonatomic,strong) UIView *loginAnimationView;
//登录转圈的那条白线所在的layer
@property (nonatomic,strong) CAShapeLayer *shapeLayer;

@property (nonatomic ,strong) UIButton *registerButton;

@end

//loginBack
@implementation LoginViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChangeNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self setLoginUI];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    if (range.length == 1 && string.length == 0)
    {
        return YES;
    }
    else
    {
        if ([textField isEqual:self.accountView.textFiled] && textField.text.length > 10)
        {
            
            textField.text = [textField.text substringToIndex:10];
            [self.view makeToast:@"请输入正确手机号" duration:3 position:CSToastPositionCenter];
        }
        else if ([textField isEqual:self.passwordView.textFiled])
        {

        }
        [self changeLogOrRegStatus];

        return YES;
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self changeLogOrRegStatus];
    
    if ([textField isEqual:self.accountView.textFiled] &&
        !isMobileNumber(self.accountView.textFiled.text) &&
        textField.text.length > 1){
        [self.view makeToast:@"请输入正确手机号" duration:3 position:CSToastPositionCenter];
    }
}


-(void)changeLogOrRegStatus{
    if ( isMobileNumber(self.accountView.textFiled.text) && self.passwordView.textFiled.text.length > 1){
        self.loginButton.backgroundColor = colorByValue(0x0088FF, 1);
        [self.loginButton setUserInteractionEnabled:YES];
    }else{
        [self.loginButton setUserInteractionEnabled:NO];
        self.loginButton.backgroundColor = colorByValue(0xD5D5D5,1);
    }
}

#pragma mark - NSNotification

- (void)keyBoardChangeNotification:(NSNotification *)notification
{
    CGRect endframe = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        if (endframe.origin.y > CGRectGetHeight(UIScreen.mainScreen.bounds) - 1)
        {
            //键盘消失
            self.logoImageView.center = CGPointMake(CGRectGetWidth(UIScreen.mainScreen.bounds) / 2.0, CGRectGetHeight(UIScreen.mainScreen.bounds) / 2.0 - CGRectGetWidth(UIScreen.mainScreen.bounds) * 0.25 - kUpOffset);
            self.logoLable.center = CGPointMake(CGRectGetWidth(UIScreen.mainScreen.bounds) / 2.0, CGRectGetHeight(UIScreen.mainScreen.bounds) / 2.0 - kUpOffset);
            
            self.loginButton.center = CGPointMake(CGRectGetWidth(UIScreen.mainScreen.bounds) / 2.0, _endPointY);
            self.textContainerView.center = CGPointMake(CGRectGetWidth(UIScreen.mainScreen.bounds) / 2.0, self.loginButton.center.y  - kTextContainerViewHeight / 2.0 - 20 - kTextContainerViewHeight - 5);
        }
        else
        {
            //键盘出现
            if (self.logoImageView.center.y > 0)
            {
                self.logoImageView.center = CGPointMake(CGRectGetWidth(UIScreen.mainScreen.bounds) / 2.0,  - CGRectGetWidth(UIScreen.mainScreen.bounds) * 0.5);
                self.logoLable.center = CGPointMake(CGRectGetWidth(UIScreen.mainScreen.bounds) / 2.0,- 20);
                
            }
            
            float buttonMax_Y = CGRectGetMaxY(self.loginButton.frame) + 10;
            if (endframe.origin.y < buttonMax_Y)
            {
                self.loginButton.center = CGPointMake(CGRectGetWidth(UIScreen.mainScreen.bounds) / 2.0, endframe.origin.y - 10 - kTextContainerViewHeight / 2.0);
                self.textContainerView.center = CGPointMake(CGRectGetWidth(UIScreen.mainScreen.bounds) / 2.0, self.loginButton.center.y  - kTextContainerViewHeight / 2.0 - 20 - kTextContainerViewHeight - 5);
            }
            
        }
        
    }];
    
}

#pragma mark - CAAnimationDelegate

/** 动画执行结束回调 */
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"anim ----- %@",((CABasicAnimation *)anim).keyPath);
    if([((CABasicAnimation *)anim).keyPath isEqualToString:@"bounds.size.height"])
    {
        //阴影颜色
        self.textContainerView.layer.shadowColor = [UIColor redColor].CGColor;
        //阴影的透明度
        self.textContainerView.layer.shadowOpacity = 0.8f;
        //阴影的圆角
        self.textContainerView.layer.shadowRadius = 5.0f;
        //阴影偏移量
        self.textContainerView.layer.shadowOffset = CGSizeMake(1,1);
        self.textContainerView.frame = CGRectMake(kLeftSpace, CGRectGetHeight(UIScreen.mainScreen.bounds) / 2.0 - kUpOffset, kTextContainerViewWidth, kTextContainerViewHeight * 2.0 + 10);
        self.accountView.alpha = 1.0;
        self.passwordView.alpha = 1.0;
    }
    else if ([((CABasicAnimation *)anim).keyPath isEqualToString:@"bounds.size"])
    {
        self.loginButton.frame = CGRectMake(kLeftSpace, CGRectGetMaxY(self.textContainerView.frame) + 20, kTextContainerViewWidth, kTextContainerViewHeight);
        self.registerButton.hidden = NO;
        self.registerButton.frame = CGRectMake(CGRectGetMaxX(self.loginButton.frame) - 80, CGRectGetMaxY(self.loginButton.frame) + 20, 80, 40);
        _endPointY = self.loginButton.center.y;
    }
    
}


#pragma mark - response event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.accountView.textFiled resignFirstResponder];
    [self.passwordView.textFiled resignFirstResponder];
}

- (void)getButtonClick
{
    /**
     *  动画的思路：
     *  1、造一个view来执行动画，看上去就像get按钮本身在形变移动，其实是这个view
     *  2、改变动画view的背景颜色，变色的过程是整个动画效果执行的过程
     *  3、让按钮变宽
     *  4、变宽完成后，变高
     *  5、变高完成后，同步执行以下四步
     *      5.0、让账号密码按钮出现
     *      5.1、让Login按钮出现
     *      5.2、移动这个view，带弹簧效果
     *      5.3、移动logo图片，带弹簧效果
     *      5.4、移动logo文字，带弹簧效果
     */

    //1、get按钮动画的view
    UIView *animView = self.textContainerView;
    [self.view addSubview:animView];
    self.getButton.hidden = YES;
    self.loginButton.hidden = NO;
    
    //2、get背景颜色
    CABasicAnimation *changeColor1 = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    changeColor1.fromValue = (__bridge id)self.getButton.backgroundColor.CGColor;
    changeColor1.toValue = (__bridge id)[UIColor clearColor].CGColor;
    changeColor1.duration = 0.8f;
    changeColor1.beginTime = CACurrentMediaTime();
    changeColor1.fillMode = kCAFillModeForwards;
    changeColor1.removedOnCompletion = false;
    [animView.layer addAnimation:changeColor1 forKey:changeColor1.keyPath];
    
    //3、get按钮变宽
    CABasicAnimation *anim1 = [CABasicAnimation animationWithKeyPath:@"bounds.size.width"];
    anim1.fromValue = @(CGRectGetWidth(animView.bounds));
    anim1.toValue = @(kTextContainerViewWidth);
    anim1.duration = 0.1;
    anim1.beginTime = CACurrentMediaTime();
    anim1.fillMode = kCAFillModeForwards;
    anim1.removedOnCompletion = false;
    [animView.layer addAnimation:anim1 forKey:anim1.keyPath];
    
    //4、get按钮变高
    CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"bounds.size.height"];
    anim2.fromValue = @(CGRectGetHeight(animView.bounds));
    anim2.toValue = @(kTextContainerViewHeight * 2 + 10);
    anim2.duration = 0.1;
    anim2.beginTime = CACurrentMediaTime()+0.1;
    anim2.fillMode = kCAFillModeForwards;
    anim2.removedOnCompletion = false;
    anim2.delegate = self;//变高完成，给它加个阴影
    [animView.layer addAnimation:anim2 forKey:anim2.keyPath];
    
    //5.0、账号密码按钮出现
    self.accountView.alpha = 0.0;
    self.passwordView.alpha = 0.0;
    self.accountView.hidden = NO;
    self.passwordView.hidden = NO;
    [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.accountView.alpha = 1.0;
        self.passwordView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];

    //5.1、login按钮出现动画
    CABasicAnimation *animLoginBtn = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
    animLoginBtn.fromValue = [NSValue valueWithCGSize:CGSizeMake(0, 0)];
    animLoginBtn.toValue = [NSValue valueWithCGSize:CGSizeMake(kTextContainerViewWidth, kTextContainerViewHeight)];
    animLoginBtn.duration = 0.4;
    animLoginBtn.beginTime = CACurrentMediaTime()+0.2;
    animLoginBtn.fillMode = kCAFillModeForwards;
    animLoginBtn.removedOnCompletion = false;
    animLoginBtn.delegate = self;//在代理方法(动画完成回调)里，让按钮真正的宽高改变，而不仅仅是它的layer,否则看得到点不到
    [self.loginButton.layer addAnimation:animLoginBtn forKey:animLoginBtn.keyPath];

    
    //5.2、按钮移动动画
    POPSpringAnimation *anim3 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim3.fromValue = [NSValue valueWithCGRect:CGRectMake(animView.center.x, animView.center.y,CGRectGetWidth(animView.frame), CGRectGetHeight(animView.frame))];
    anim3.toValue = [NSValue valueWithCGRect:CGRectMake(animView.center.x, animView.center.y - kUpOffset, CGRectGetWidth(animView.frame), CGRectGetHeight(animView.frame))];
    anim3.beginTime = CACurrentMediaTime()+0.2;
    anim3.springBounciness = YYSpringBounciness;
    anim3.springSpeed = YYSpringSpeed;
    [animView pop_addAnimation:anim3 forKey:nil];
    
    
    //5.3、图片移动动画
    POPSpringAnimation *anim4 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim4.fromValue = [NSValue valueWithCGRect:CGRectMake(self.logoImageView.frame.origin.x, self.logoImageView.frame.origin.y, CGRectGetWidth(self.logoImageView.frame), CGRectGetHeight(self.logoImageView.frame))];
    anim4.toValue = [NSValue valueWithCGRect:CGRectMake(self.logoImageView.frame.origin.x, self.logoImageView.frame.origin.y - kUpOffset, CGRectGetWidth(self.logoImageView.frame), CGRectGetHeight(self.logoImageView.frame))];
    anim4.beginTime = CACurrentMediaTime()+0.2;
    anim4.springBounciness = YYSpringBounciness;
    anim4.springSpeed = YYSpringSpeed;
    [self.logoImageView pop_addAnimation:anim4 forKey:nil];
    
    //5.4、文字移动动画
    POPSpringAnimation *anim5 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim5.fromValue = [NSValue valueWithCGRect:CGRectMake(self.logoLable.frame.origin.x, self.logoLable.frame.origin.y, CGRectGetWidth(self.logoLable.frame), CGRectGetHeight(self.logoLable.frame))];
    anim5.toValue = [NSValue valueWithCGRect:CGRectMake(self.logoLable.frame.origin.x, self.logoLable.frame.origin.y - kUpOffset,  CGRectGetWidth(self.logoLable.frame), CGRectGetHeight(self.logoLable.frame))];
    anim5.beginTime = CACurrentMediaTime()+0.2;
    anim5.springBounciness = YYSpringBounciness;
    anim5.springSpeed = YYSpringSpeed;
    [self.logoLable pop_addAnimation:anim5 forKey:nil];

}

- (void)loginButtonClick
{
    [self.accountView.textFiled resignFirstResponder];
    [self.passwordView.textFiled resignFirstResponder];
    
    if ([self judgeLeagle] == NO)
    {
        [self loginFailClick];
        return;
    }
    
    [self.view addSubview:self.loginAnimationView];
    self.loginButton.hidden = YES;
    //把view从宽的样子变圆
    CGPoint centerPoint = self.loginAnimationView.center;
    CGFloat radius = MIN(self.loginButton.frame.size.width, self.loginButton.frame.size.height);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.loginAnimationView.frame = CGRectMake(0, 0, radius, radius);
        self.loginAnimationView.center = centerPoint;
        self.loginAnimationView.layer.cornerRadius = radius/2;
        self.loginAnimationView.layer.masksToBounds = YES;
        
    }completion:^(BOOL finished) {
        
        //给圆加一条不封闭的白色曲线
        UIBezierPath* path = [[UIBezierPath alloc] init];
        [path addArcWithCenter:CGPointMake(radius/2, radius/2) radius:(radius/2 - 5) startAngle:0 endAngle:M_PI_2 * 2 clockwise:YES];
        self.shapeLayer = [[CAShapeLayer alloc] init];
        self.shapeLayer.lineWidth = 1.5;
        self.shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        self.shapeLayer.fillColor = self.loginButton.backgroundColor.CGColor;
        self.shapeLayer.frame = CGRectMake(0, 0, radius, radius);
        self.shapeLayer.path = path.CGPath;
        [self.loginAnimationView.layer addSublayer:self.shapeLayer];
        
        //让圆转圈，实现"加载中"的效果
        CABasicAnimation* baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        baseAnimation.duration = 0.4;
        baseAnimation.fromValue = @(0);
        baseAnimation.toValue = @(2 * M_PI);
        baseAnimation.repeatCount = MAXFLOAT;
        [self.loginAnimationView.layer addAnimation:baseAnimation forKey:nil];
        
        //开始登录
        [self startLoginRequest];
    }];
}

- (void)registerButtonClick
{
    [self.accountView.textFiled resignFirstResponder];
    [self.passwordView.textFiled resignFirstResponder];
    
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}


/** 登录失败 */
- (void)loginFailClick
{
    //把蒙版、动画view等隐藏，把真正的login按钮显示出来
    self.loginButton.hidden = NO;
//    [self.HUDView removeFromSuperview];
    
    if (_loginAnimationView)
    {
        [self.loginAnimationView removeFromSuperview];
        [self.loginAnimationView.layer removeAllAnimations];
    }
    
    //给按钮添加左右摆动的效果(路径动画)
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGPoint point = self.loginAnimationView.layer.position;
    keyFrame.values = @[[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        
                        [NSValue valueWithCGPoint:point]];
    keyFrame.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    keyFrame.duration = 0.5f;
    [self.loginButton.layer addAnimation:keyFrame forKey:keyFrame.keyPath];
}


#pragma mark - private method

- (void)setLoginUI
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    imageView.image = [UIImage imageNamed:@"loginBack"];
    [self.view addSubview:imageView];
    
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.logoLable];
    [self.view addSubview:self.getButton];
    
    [self.view addSubview:self.loginButton];

    [self.view addSubview:self.registerButton];
}

- (BOOL)judgeLeagle
{
    if (self.accountView.textFiled.text.length < 1)
    {
        return NO;
    }
    
    if (self.passwordView.textFiled.text.length < 1)
    {
        return NO;
    }
    
    return YES;
}

- (void)startLoginRequest
{
    [HttpManager requestLoginWithAccount:self.accountView.textFiled.text Password:self.passwordView.textFiled.text Success:^(UserManager *account)
    {
//        UIApplication.sharedApplication.keyWindow.rootViewController = [[MainTabbarController alloc]init];

    } failure:^(NSError *error) {
        [self.view makeToast:error.domain duration:3 position:CSToastPositionCenter];
        [self loginFailClick];
    }];
}

#pragma mark - setter and getter

- (UIImageView *)logoImageView
{
    if (_logoImageView == nil)
    {
        CGFloat LoginImageWH = CGRectGetWidth(UIScreen.mainScreen.bounds) * 0.25;
        CGFloat y = (CGRectGetHeight(UIScreen.mainScreen.bounds) - CGRectGetWidth(UIScreen.mainScreen.bounds) * 0.25) / 2.0 - CGRectGetWidth(UIScreen.mainScreen.bounds) * 0.25;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
        imageView.layer.cornerRadius = 6;
        imageView.clipsToBounds = YES;
        imageView.frame = CGRectMake((CGRectGetWidth(UIScreen.mainScreen.bounds) - LoginImageWH) / 2.0, y, LoginImageWH, LoginImageWH);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        _logoImageView = imageView;
    }
    return _logoImageView;
}

- (UILabel *)logoLable
{
    if (_logoLable == nil)
    {
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 30)];
        lable.textColor = [UIColor whiteColor];
        lable.text = @"Mo 陌上桑";
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont fontWithName:@"Courier-Oblique" size:30];
        lable.center = CGPointMake(CGRectGetWidth(UIScreen.mainScreen.bounds) / 2.0, CGRectGetHeight(UIScreen.mainScreen.bounds) / 2.0);

        _logoLable = lable;
    }
    return _logoLable;
}

- (UIButton *)getButton
{
    if (_getButton == nil)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(CGRectGetWidth(UIScreen.mainScreen.bounds) * 0.3, CGRectGetHeight(UIScreen.mainScreen.bounds) * 0.7,  CGRectGetWidth(UIScreen.mainScreen.bounds) * 0.4,44);
        button.layer.cornerRadius = 22;
        button.clipsToBounds = YES;
        button.backgroundColor = [UIColor colorWithRed:254/255.0 green:190/255.0 blue:202/255.0 alpha:1.0];
        [button setTitle:@"登录" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(getButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        _getButton = button;
    }
    return _getButton;
}

- (UIView *)textContainerView
{
    if (_textContainerView == nil)
    {
        UIView *animView = [[UIView alloc] initWithFrame:self.getButton.frame];
        animView.layer.cornerRadius = 10;
        animView.backgroundColor = self.getButton.backgroundColor;
        
        [animView addSubview:self.accountView];
        [animView addSubview:self.passwordView];
        
        _textContainerView = animView;
    }
    
    return _textContainerView;
}

- (LoginTextView *)accountView
{
    if (_accountView == nil)
    {
        LoginTextView *textView = [[LoginTextView alloc] init];
        textView.textFiled.placeholder = @"请输入账号";
        textView.textFiled.keyboardType = UIKeyboardTypeNumberPad;
        textView.textFiled.placeholderColor = [UIColor whiteColor];
        textView.frame = CGRectMake(0, 0, kTextContainerViewWidth, kTextContainerViewHeight);
        textView.textFiled.delegate = self;
        textView.hidden = YES;
        _accountView = textView;
    }
    return _accountView;
}

- (LoginTextView *)passwordView
{
    if (_passwordView == nil)
    {
        LoginTextView *textView = [[LoginTextView alloc] init];
        textView.textFiled.delegate = self;
        textView.textFiled.placeholder = @"请输入密码";
        textView.textFiled.placeholderColor = [UIColor whiteColor];
        textView.hidden = YES;
        textView.frame = CGRectMake(0, kTextContainerViewHeight + 10, kTextContainerViewWidth, kTextContainerViewHeight);
        _passwordView = textView;
    }
    return _passwordView;
}

- (UIButton *)loginButton
{
    if (_loginButton == nil)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(CGRectGetWidth(UIScreen.mainScreen.bounds) * 0.3, CGRectGetHeight(UIScreen.mainScreen.bounds) * 0.7,  CGRectGetWidth(UIScreen.mainScreen.bounds) * 0.4,44);
        button.layer.cornerRadius = 25;
        button.clipsToBounds = YES;
        button.backgroundColor = [UIColor colorWithRed:254/255.0 green:190/255.0 blue:202/255.0 alpha:1.0];        
        [button setTitle:@"登录" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
        button.hidden = YES;
        _loginButton = button;
    }
    return _loginButton;
}

- (UIView *)loginAnimationView
{
    if (_loginAnimationView == nil)
    {
        UIView *view = [[UIView alloc] initWithFrame:self.loginButton.frame];
        view.layer.cornerRadius = self.loginButton.layer.cornerRadius;
        view.layer.masksToBounds = YES;
        view.backgroundColor = self.loginButton.backgroundColor;
        _loginAnimationView = view;
    }
    return _loginAnimationView;
}

- (UIButton *)registerButton
{
    if (_registerButton == nil)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 6;
        button.clipsToBounds = YES;
        button.backgroundColor = colorByValue(0x0088FF, 1);
        [button setTitle:@"注册" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
        button.hidden = YES;
        _registerButton = button;
    }
    return _registerButton;
}

@end
