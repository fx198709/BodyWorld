//
//  CoachViewController.m
//  FFitWorld
//
//  Created by xiejc on 2021/12/2.
//

#import "CoachViewController.h"
#import "CoachCommentCell.h"
#import "StarView.h"


#import "CoachModel.h"
#import "CoachComment.h"
#import "CoachCommentPageInfo.h"


@interface CoachViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cityImg;

@property (weak, nonatomic) IBOutlet UIView *starContainerView;
@property (strong, nonatomic) StarView *starView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (weak, nonatomic) IBOutlet UIView *descView;
@property (weak, nonatomic) IBOutlet UIView *courseTypeView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (nonatomic, strong) CoachModel *coach;

@end

@implementation CoachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = ChineseStringOrENFun(@"教练详情", @"Detail");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getCocaheInfoFromSever];
}

- (void)initView {
    [super initView];
    [self.headImg cornerHalf];
    [self.descView cornerWithRadius:6.0];
    [self.starContainerView clearAllSubViews];
    self.starView = LoadXib(@"StarView");
    [self.starContainerView addSubview:self.starView];
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.starContainerView);
    }];
}


- (Class)cellClass {
    return [CoachCommentCell class];
}

- (void)loadUserData {
    self.nameLabel.text = self.coach.nickname;
    NSString *avatarUrl = [FITAPI_HTTPS_ROOT stringByAppendingString:self.coach.avatar];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:avatarUrl]
                    placeholderImage:[UIImage imageNamed:@"choose_course_foot_logo3_unselected"]];
    [self.cityImg sd_setImageWithURL:[NSURL URLWithString:self.coach.country_icon]];
    self.cityLabel.text = [NSString stringWithFormat:@"%@,%@", self.coach.city, self.coach.country];
//    self.descLabel.text = self.coach.introduction;
    NSString *countString = ChineseStringOrENFun(@"条评论", @"count command");
    self.commentLabel.text = [NSString stringWithFormat:@"(%ld%@)", (long)self.coach.comment_total,countString];
    [self.starView setScore:self.coach.comment_grade];
    [self addCourseTypeView];
}

- (void)addCourseTypeView {
    [self.courseTypeView clearAllSubViews];
    NSArray *teachList = [self.coach.teach componentsSeparatedByString:@","];
    CGFloat h = 18;
    CGFloat x = 0;
    CGFloat y = (self.courseTypeView.height - h) * 0.5;
    for (NSString *type in teachList) {
        UILabel *aLabel = [[UILabel alloc] init];
        aLabel.textAlignment = NSTextAlignmentCenter;
        aLabel.textColor = SelectGreenColor;
        aLabel.backgroundColor = [UIColor darkGrayColor];
        aLabel.font = [UIFont systemFontOfSize:10.0];
        aLabel.text = type;
        float w = [aLabel widthForText:type] + 16;
        aLabel.frame = CGRectMake(x, y, w, h);
        [aLabel cornerHalf];
        [self.courseTypeView addSubview:aLabel];
        x += 6 + w;
    }
}

- (void)reloadTabelView {
    [self.tableView reloadData];
    self.tableView.hidden = self.dataList.count == 0;
}

#pragma mark - server

- (void)getCocaheInfoFromSever {
    NSDictionary *param = @{@"coach_id":self.coacheId};
    [[AFAppNetAPIClient manager] GET:@"coach/detail" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        NSLog(@"====respong:%@", responseObject);
        NSDictionary *result = [responseObject objectForKey:@"recordset"];
        NSError *error;
        self.coach = [[CoachModel alloc] initWithDictionary:result error:&error];
        [self loadUserData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MTHUD showDurationNoticeHUD:error.localizedDescription];
    }];
}

- (void)getDataListFromServer:(BOOL)isRefresh {
    if (self.isFinished || self.isRequesting) {
        return;
    }
    self.isRequesting = YES;
    NSInteger nextPage = self.currentPage + 1;
    int perCount = 10;
    NSDictionary *param = @{@"row":IntToString(perCount), @"page":IntToString(nextPage), @"coach_id":self.coacheId};
    
    [[AFAppNetAPIClient manager] GET:@"comment/coach/list" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        self.isRequesting = NO;
        
        NSLog(@"====respong:%@", responseObject);
        NSDictionary *result = [responseObject objectForKey:@"recordset"];
        NSError *error;
        CoachCommentPageInfo *pageInfo = [[CoachCommentPageInfo alloc] initWithDictionary:result error:&error];
        if (error == nil) {
            if (isRefresh) {
                self.dataList = [NSMutableArray arrayWithArray:pageInfo.rows];
            } else {
                [self.dataList addObjectsFromArray:pageInfo.rows];
            }
            if (pageInfo.rows.count < perCount) {
                self.isFinished = YES;
            }
            self.currentPage += 1;
            [self reloadTabelView];
        } else {
            [MTHUD showDurationNoticeHUD:error.localizedDescription];
        }
        [self finishMJRefresh:self.tableView isFinished:self.isFinished];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.isRequesting = NO;
        [self finishMJRefresh:self.tableView isFinished:self.isFinished];
        [MTHUD showDurationNoticeHUD:error.localizedDescription];
    }];
}

//点赞评论
- (void)favoriteCommentFromServer:(CoachComment *)comment {
    NSDictionary *param = @{@"obj_id":comment.id,
                            @"is_favorite":IntToString(!comment.is_favorite),
                            @"type":@"comment"};
    NSString *url = comment.is_favorite ? @"favorite/cancel" : @"favorite/add";
    [[AFAppNetAPIClient manager] POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        NSLog(@"====respong:%@", responseObject);
        NSString *result = [responseObject objectForKey:@"recordset"];
        if ([result isEqualToString:@"success"]) {
            comment.is_favorite = !comment.is_favorite;
            comment.favorite_cnt += comment.is_favorite ? 1 : -1;
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MTHUD showDurationNoticeHUD:error.localizedDescription];
    }];
}


#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CoachCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CoachCommentCell class])];
    CoachComment *comment = [self.dataList objectAtIndex:indexPath.row];
    [cell loadData:comment];
    cell.btnCallBack = ^{
        [self favoriteCommentFromServer:comment];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
