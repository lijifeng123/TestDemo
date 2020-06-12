//
//  ViewController.m
//  Demo
//
//  Created by Musk Ronaldo Ming on 2020/5/8.
//  Copyright © 2020 Musk Ronaldo Ming. All rights reserved.
//

#import "ViewController.h"
#import <MJRefresh.h>
#import "UIScrollView+XSRefresh.h"
#import "UIImage+TBCityIconFont.h"
#import "TBCityIconFont.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"

#define K_TITLE_OFFSET_Y 2

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImageView *customArrow;
@property (copy, nonatomic) void(^testBlock)(void);

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    //1.1 版本修复问题
    // release bug
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"test" style:UIBarButtonItemStylePlain target:self action:@selector(testAction)];
}

- (void)testAction{
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [UITableViewCell new];
}

@end
