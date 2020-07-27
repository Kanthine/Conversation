//
//  RegisterViewController.m
//  objective_c_language
//
//  Created by 苏沫离 on 2018/6/1.
//  Copyright © 2018年 longlong. All rights reserved.
//

#import "RegisterViewController.h"

#import "UIView+Toast.h"
#import "MBProgressHUD+CustomView.h"
#import "GravityImageView.h"
#import "LoginTextView.h"
#import <Masonry.h>
#import "AppDelegate.h"

@interface RegisterViewController()
<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate>

{
    UIImage *_newImage;
}

@property (nonatomic ,strong) UIImageView *portraitImageView;//头像
@property (nonatomic ,strong) LoginTextView *accountView;
@property (nonatomic ,strong) LoginTextView *passwordView;
@property (nonatomic ,strong) LoginTextView *nickNameView;
@property (nonatomic ,strong) UIButton *loginButton;
@property (nonatomic ,strong) UIButton *registerButton;

@end

@implementation RegisterViewController

- (void)dealloc{
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setRegisterUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChangeNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self changeLogOrRegStatus];
    if (textField.text.length > 1){
        if ([textField isEqual:self.accountView.textFiled]){
            if (!isMobileNumber(self.accountView.textFiled.text) &&
                !isEmail(self.accountView.textFiled.text)) {
                [self.view makeToast:@"请输入正确手机号或者邮箱" duration:3 position:CSToastPositionCenter];
            }
        }
    }
}

-(void)changeLogOrRegStatus{
    
   BOOL isAccount = isMobileNumber(self.accountView.textFiled.text) ||
    isEmail(self.accountView.textFiled.text);
    
    if (self.nickNameView.textFiled.text.length > 0 &&
        self.passwordView.textFiled.text.length > 1 &&
        isAccount){
        self.registerButton.backgroundColor = colorByValue(0x0088FF, 1);
        [self.registerButton setUserInteractionEnabled:YES];
    }else{
        [self.registerButton setUserInteractionEnabled:NO];
        self.registerButton.backgroundColor = colorByValue(0xD5D5D5,1);
    }
}

#pragma mark - NSNotification

- (void)keyBoardChangeNotification:(NSNotification *)notification{
    CGRect endframe = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        if (endframe.origin.y > CGRectGetHeight(UIScreen.mainScreen.bounds) - 1){
            //键盘消失
            self.portraitImageView.frame = CGRectMake((CGRectGetWidth(UIScreen.mainScreen.bounds) - 80) / 2.0, 64, 80, 80);
            self.accountView.frame = CGRectMake(35, CGRectGetMaxY(self.portraitImageView.frame) + 20, CGRectGetWidth(UIScreen.mainScreen.bounds) - 70, 50);
            self.passwordView.frame = CGRectMake(self.accountView.frame.origin.x, CGRectGetMaxY(self.accountView.frame), CGRectGetWidth(self.accountView.frame), CGRectGetHeight(self.accountView.frame));
            self.nickNameView.frame = CGRectMake(self.accountView.frame.origin.x, CGRectGetMaxY(self.passwordView.frame), CGRectGetWidth(self.accountView.frame), CGRectGetHeight(self.accountView.frame));
            
            self.registerButton.frame = CGRectMake(self.nickNameView.frame.origin.x, CGRectGetMaxY(self.nickNameView.frame) + 20, CGRectGetWidth(self.accountView.frame), CGRectGetHeight(self.accountView.frame));
            
        }else{
            //键盘出现
            if (self.portraitImageView.frame.origin.y > 0){
                self.portraitImageView.frame = CGRectMake((CGRectGetWidth(UIScreen.mainScreen.bounds) - 80) / 2.0, -100, 80, 80);
            }
            
            float buttonMax_Y = CGRectGetMaxY(self.registerButton.frame) + 10;
            if (endframe.origin.y < buttonMax_Y){
                self.registerButton.frame = CGRectMake(self.nickNameView.frame.origin.x, endframe.origin.y - 20 - CGRectGetHeight(self.accountView.frame), CGRectGetWidth(self.accountView.frame), CGRectGetHeight(self.accountView.frame));
                self.nickNameView.frame = CGRectMake(self.accountView.frame.origin.x, self.registerButton.frame.origin.y - 20 - CGRectGetHeight(self.accountView.frame), CGRectGetWidth(self.accountView.frame), CGRectGetHeight(self.accountView.frame));
                self.passwordView.frame = CGRectMake(self.accountView.frame.origin.x,  self.nickNameView.frame.origin.y - CGRectGetHeight(self.accountView.frame), CGRectGetWidth(self.accountView.frame), CGRectGetHeight(self.accountView.frame));
                self.accountView.frame = CGRectMake(35, self.passwordView.frame.origin.y - CGRectGetHeight(self.accountView.frame), CGRectGetWidth(UIScreen.mainScreen.bounds) - 70, 50);

            }
        }
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    _newImage = image;
    self.portraitImageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - response event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.accountView.textFiled resignFirstResponder];
    [self.passwordView.textFiled resignFirstResponder];
    [self.nickNameView.textFiled resignFirstResponder];
}

- (void)loginButtonClick{
    [self.accountView.textFiled resignFirstResponder];
    [self.passwordView.textFiled resignFirstResponder];
    [self.nickNameView.textFiled resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registerButtonClick{
    [self.accountView.textFiled resignFirstResponder];
    [self.passwordView.textFiled resignFirstResponder];
    [self.nickNameView.textFiled resignFirstResponder];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在注册...";
    
        
    NSDictionary *dict = @{@"account":self.accountView.textFiled.text,
                           @"password":self.passwordView.textFiled.text,
                           @"nickName":self.nickNameView.textFiled.text};
        
    [HttpManager requestForPostUrl:URL_Register Parameters:dict success:^(id responseObject) {
        NSLog(@"URL_Register ===== %@",responseObject);

        [UserManager.shareUser parserWithDictionary:responseObject[@"data"]];
        UserManager.shareUser.password = self.passwordView.textFiled.text;
        [UserManager.shareUser save];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            [self regisSuccessClick];
        });
    } failure:^(NSError *error) {
        NSLog(@"error ----- %@",error);
        [hud hideAnimated:YES];
        [self.view makeToast:error.domain duration:3 position:CSToastPositionCenter];
    }];
}

- (void)regisSuccessClick{
    [((AppDelegate *)UIApplication.sharedApplication.delegate) loginOrRegisterSuccess];
}

//头像
- (void)updateUserHeaderImageClick{
    __weak __typeof__(self) weakSelf = self;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设置头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf photoPickerClick];
    }];
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf photoAlbumClick];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cameraAction];
    [alertController addAction:libraryAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//拍照
- (void)photoPickerClick{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

//相册
- (void)photoAlbumClick{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark -

- (void)setRegisterUI{
    GravityImageView *imageView = [[GravityImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    imageView.image = [UIImage imageNamed:@"loginBack"];
    [self.view addSubview:imageView];
        
    [self.view addSubview:self.portraitImageView];
    [self.view addSubview:self.accountView];
    [self.view addSubview:self.passwordView];
    [self.view addSubview:self.nickNameView];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.registerButton];
    
    self.portraitImageView.frame = CGRectMake((CGRectGetWidth(UIScreen.mainScreen.bounds) - 80) / 2.0, 64, 80, 80);
    self.accountView.frame = CGRectMake(35, CGRectGetMaxY(self.portraitImageView.frame) + 20, CGRectGetWidth(UIScreen.mainScreen.bounds) - 70, 50);
    self.passwordView.frame = CGRectMake(self.accountView.frame.origin.x, CGRectGetMaxY(self.accountView.frame), CGRectGetWidth(self.accountView.frame), CGRectGetHeight(self.accountView.frame));
    self.nickNameView.frame = CGRectMake(self.accountView.frame.origin.x, CGRectGetMaxY(self.passwordView.frame), CGRectGetWidth(self.accountView.frame), CGRectGetHeight(self.accountView.frame));
    
    self.registerButton.frame = CGRectMake(self.nickNameView.frame.origin.x, CGRectGetMaxY(self.nickNameView.frame) + 20, CGRectGetWidth(self.accountView.frame), CGRectGetHeight(self.accountView.frame));
    self.loginButton.frame = CGRectMake(0, 0, 80, 80);
}

#pragma mark - setter and getter

- (UIImageView *)portraitImageView{
    if (_portraitImageView == nil){
        _portraitImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"register_Default"]];
        _portraitImageView.userInteractionEnabled = YES;
        _portraitImageView.layer.cornerRadius = 40.0;
        _portraitImageView.clipsToBounds = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(updateUserHeaderImageClick)];
        [_portraitImageView addGestureRecognizer:tapGes];
    }
    return _portraitImageView;
}

- (LoginTextView *)accountView{
    if (_accountView == nil){
        LoginTextView *textView = [[LoginTextView alloc] init];
        textView.textFiled.delegate = self;
        textView.textFiled.placeholder = @"请输入手机号或者邮箱";
        _accountView = textView;
    }
    return _accountView;
}

- (LoginTextView *)passwordView{
    if (_passwordView == nil){
        LoginTextView *textView = [[LoginTextView alloc] init];
        textView.textFiled.delegate = self;
        textView.textFiled.placeholder = @"请输入密码";
        _passwordView = textView;
    }
    return _passwordView;
}

- (LoginTextView *)nickNameView{
    if (_nickNameView == nil){
        LoginTextView *textView = [[LoginTextView alloc] init];
        textView.textFiled.delegate = self;
        textView.textFiled.placeholder = @"请输入昵称";
        _nickNameView = textView;
    }
    return _nickNameView;
}

- (UIButton *)loginButton{
    if (_loginButton == nil){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"navbar_left"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _loginButton = button;
    }
    return _loginButton;
}

- (UIButton *)registerButton{
    if (_registerButton == nil){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 6;
        button.clipsToBounds = YES;
        button.backgroundColor = [UIColor colorWithRed:254/255.0 green:190/255.0 blue:202/255.0 alpha:1.0];        
        [button setTitle:@"注册" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _registerButton = button;
    }
    return _registerButton;
}

@end

