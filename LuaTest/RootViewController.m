//
//  RootViewController.m
//  LuaTest
//
//  Created by 王 松  on 12-12-11.
//  Copyright (c) 2012年 王松. All rights reserved.
//

#import "RootViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "wax/wax.h"

#ifndef LUA_PATH_DEFAULT
#define LUA_PATH_DEFAULT [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"init.lua"]  UTF8String]
#endif

@interface RootViewController ()
{
    UITextView *textView;
}
@end

@implementation RootViewController

- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)loadView
{
    [super loadView];

    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.origin.y = 40.0f;
    rect.size.height = rect.size.height - 100.0f;
    
    self.view.frame = rect;
    
	// Do any additional setup after loading the view.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"获取" forState:UIControlStateNormal];
    button.frame = CGRectMake(20.0f, 10.0f, 80.0f, 30.0f);
    [button setBackgroundImage:[UIImage imageNamed:@"Btn.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(getContent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setTitle:@"保存" forState:UIControlStateNormal];
    button1.frame = CGRectMake((self.view.frame.size.width - 80.0f) / 2, 10.0f, 80.0f, 30.0f);
    [button1 setBackgroundImage:[UIImage imageNamed:@"Btn.png"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(saveContent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setTitle:@"测试" forState:UIControlStateNormal];
    button2.frame = CGRectMake(self.view.frame.size.width - 100.0f, 10.0f, 80.0f, 30.0f);
    [button2 setBackgroundImage:[UIImage imageNamed:@"Btn.png"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button3 setTitle:@"删除本地缓存" forState:UIControlStateNormal];
    button3.frame = CGRectMake((self.view.frame.size.width - 100.0f) / 2, 260.0f, 100.0f, 30.0f);
    [button3 setBackgroundImage:[UIImage imageNamed:@"Btn.png"] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(deleteCache:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];


    textView = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 50.0f, self.view.frame.size.width - 20.0f, 200.0f)];
    
    textView.layer.cornerRadius = 10.0f;
    
//    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
//    
//    resourcePath = [resourcePath stringByAppendingPathComponent:@"TestController.lua"];
    
//    NSString *content = [NSString stringWithContentsOfFile:resourcePath encoding:NSUTF8StringEncoding error:nil];
    
    [textView setBackgroundColor:[UIColor grayColor]];
    [textView setEditable:NO];
    
//    NSURL *serverURL = [NSURL URLWithString:@"http://10.10.24.161/~apple/TestController.lua"]; //本机php
//    NSURL *serverURL = [NSURL URLWithString:@"http://10.10.24.160:8090/TestController.lua"];  //服务器netty
    
//    NSString *serverContent = [NSString stringWithContentsOfURL:serverURL encoding:NSUTF8StringEncoding error:nil];
    
//    [textView setText:serverContent];
    
    [self.view addSubview:textView];
    /*
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTapped:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer release];
     */
    [self.view setBackgroundColor:[UIColor colorWithRed:0.173 green:0.651 blue:0.627 alpha:1]];
}

- (void)bgTapped:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateRecognized) {
        [textView resignFirstResponder];
    }
}

- (void)getContent:(id)sender
{/*
    NSURL *serverURL = [NSURL URLWithString:@"http://localhost:8000/TestController.lua"];  //服务器netty
    
    NSString *serverContent = [NSString stringWithContentsOfURL:serverURL encoding:NSUTF8StringEncoding error:nil];
    
    [textView setText:serverContent];
  */
    NSFileManager *manager = [NSFileManager defaultManager];
    
     NSString *resourcePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    [manager copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"StatesTable" ofType:@"lua"] toPath:[resourcePath stringByAppendingPathComponent:@"StatesTable.lua"] error:nil];
    
    [manager copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"init" ofType:@"lua"] toPath:[resourcePath stringByAppendingPathComponent:@"init.lua"] error:nil];
}


- (void)btnClicked:(id)sender
{
    NSString *resourcePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] ;
    
    resourcePath = [resourcePath stringByAppendingPathComponent:@"StatesTable.lua"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:resourcePath]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"尚未从网络下载" message:@"请先点击获取按钮下载,\n下载成功后点击保存按钮，\n保存到本地" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
        alert = nil;
        return;
    }
    [textView resignFirstResponder];
    wax_end();

    wax_start("init.lua", nil);
}

- (void)saveContent:(id)sender
{
    NSString *content = textView.text;
    if (nil == content || [@"" isEqualToString:[content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] ){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"尚未从网络下载" message:@"请先点击获取按钮下载" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
        alert = nil;
        return;
    }
    NSString *resourcePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    resourcePath = [resourcePath stringByAppendingPathComponent:@"TestController.lua"];
    
    [content writeToFile:resourcePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

- (void)deleteCache:(id)sender
{
    textView.text = nil;
    NSString *resourcePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    resourcePath = [resourcePath stringByAppendingPathComponent:@"TestController.lua"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:resourcePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:resourcePath error:nil];
    }
    
}

- (void)dealloc
{
    [textView release], textView = nil;
    [super dealloc];
}

@end
