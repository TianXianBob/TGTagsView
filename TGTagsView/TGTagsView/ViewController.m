//
//  ViewController.m
//  TGTagsView
//
//  Created by tugou on 2018/8/9.
//  Copyright © 2018年 陈星辰. All rights reserved.
//

#import "ViewController.h"
#import "DefaultTagsTableViewCell.h"
#import "OptionalTagsViewTableViewCell.h"

#define KColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) NSDictionary *tagsInfos;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tagsInfos = @{
                       @"DefaultTagsTableViewCell" : @[@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪"],
                       @"OptionalTagsViewTableViewCell" : @[@"美妆精华|100ml",@"美妆精华|200ml",@"美妆精华|500ml",@"美妆精华套装",@"美妆精华包装盒"],
                       @"VerticalTagsTableViewCell" : @[@"美式",@"中式",@"法式",@"英式",@"葡式",@"匈牙利式",@"韩式",@"日式"],
                       };
    
    
    self.tableView = ({
        UITableView *t = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        t.backgroundColor = [UIColor whiteColor];
        t.delegate = self;
        t.dataSource = self;
        for (NSString *key in self.tagsInfos.allKeys) {
            [t registerClass:NSClassFromString(key) forCellReuseIdentifier:key];
        }
        [self.view addSubview:t];
        t;
    });
    
    

    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tagsInfos.allKeys.count;
}

- (TagsTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = self.tagsInfos.allKeys[indexPath.row];
    TagsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:key];
    [cell configContents:self.tagsInfos[key]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tagsInfos.allKeys[indexPath.row] isEqualToString:@"VerticalTagsTableViewCell"])  {
        return 200;
    }
    
    return 100;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
