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
#import "UIScrollView+XSRefresh.h"
#import "UIScrollView+XSOldRefresh.h"
//#import "UIScrollView+SVPullToRefresh.h"
//#import "UIScrollView+SVInfiniteScrolling.h"

#define K_TITLE_OFFSET_Y 2

@interface MyButton : UIButton

@end

@implementation MyButton
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect m1 = CGRectInset(self.bounds, -20, -20);
    CGPoint customPoint = [self convertPoint:point toView:self];
    if (CGRectContainsPoint(m1, customPoint)) {
        return YES;
    }
    
    return NO;
}
@end


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImageView *customArrow;
@property (copy, nonatomic) void(^testBlock)(void);

@property (strong ,nonatomic) MyButton *myBtn;

@property (nonatomic) NSInteger rowsCount;

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView dequeueReusableCellWithIdentifier:@"tableViewIdentifer"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"test" style:UIBarButtonItemStylePlain target:self action:@selector(testAction)];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        typeof(weakSelf) self = weakSelf;
        [self pullAction];
    } customImage:nil];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        typeof(weakSelf) self = weakSelf;
        [self loadMoreAction];
    }];
    
    self.rowsCount = 10;
    
}

- (void)pullAction{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.rowsCount = 10;
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView reloadData];
    });
}

- (void)loadMoreAction{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.rowsCount += 20;
        
        if (self.rowsCount >= 150) {
            self.tableView.showsInfiniteScrolling = NO;
        }else{
            [self.tableView.infiniteScrollingView stopAnimating];
        }
        [self.tableView reloadData];
    });
}

- (void)btnAction{
    NSLog(@"--------------");
}

- (void)testAction{
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rowsCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewIdentifer"];
    cell.textLabel.text = [NSString stringWithFormat:@"我是第%ld个",indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"🐱🐱🐱tableView contentOfSet %lf",scrollView.contentOffset.y);
    NSLog(@"🐶🐶🐶tableView contentOfSize %lf",scrollView.contentSize.height);
}

@end
