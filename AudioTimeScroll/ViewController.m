//
//  ViewController.m
//  AudioTimeScroll
//
//  Created by SSPC139 on 2015/6/2.
//  Copyright (c) 2015年 Goston. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AudioTimeScrollView *testScrollView = [[AudioTimeScrollView alloc] initWithFrame:CGRectMake(0, 100, 330, 330)];
    [testScrollView setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:testScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
