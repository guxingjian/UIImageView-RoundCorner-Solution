//
//  ViewController.m
//  tableViewTest
//
//  Created by Kevin on 16/3/28.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+cornerRadius.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView* tbView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView* tempView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tbView = tempView;
    tempView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:tempView];
    
    tempView.dataSource = self;
    tempView.delegate = self;
    
    [tempView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView*)imageViewWithRect:(CGRect)rect andImage:(NSString*)imagePath
{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setImageName:imagePath withCR:rect.size.width/2];
    
    return imageView;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* strID = @"cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
    }
    
    for(UIView* view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    CGFloat fLen = cell.frame.size.height;
    for(NSUInteger i = 0; i < 4; ++ i)
    {
        UIView* imageView = [self imageViewWithRect:CGRectMake(10 + fLen*i, 0, fLen, fLen) andImage:@"esf_mendiandetail_titleimage.png"];
        imageView.tag = 1000 + i;
        [cell.contentView addSubview:imageView];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 120;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 80;
//}

@end
