//
//  TableAndSearchVC.m
//  ProstoPleer Music
//
//  Created by Mariya Dychko on 18.02.16.
//  Copyright © 2016 Simple Project. All rights reserved.
//

#import "TableAndSearchVC.h"

@interface TableAndSearchVC ()
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSMutableArray *nameArray;
@property (strong, nonatomic) NSMutableArray *idArray;
@property (strong, nonatomic) NSString *searchStr;
@property (strong, nonatomic) NSString *URL;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) AVPlayer *audioPlayer;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation TableAndSearchVC

@synthesize incomingData;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.searchBar.delegate = self;
  
    
    
    NSLog(@"%@", incomingData);
    
    [[self.view viewWithTag:12] stopAnimating];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.URL = @"http://api.pleer.com/resource.php";
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.token = [ud objectForKey:@"token"];

    [super viewWillAppear:YES];
    _nameArray = [NSMutableArray new];
    [self requestTopListWithPeriod:[incomingData valueForKey:@"period"] andLanguage:[incomingData valueForKey:@"language"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)spiner
{
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.center = CGPointMake(160, 240);
    _spinner.tag = 12;
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
}
#pragma mark - Table Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_nameArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"playCell";
    
    
    PlayTableViewCell *cell = (PlayTableViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PlayTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];

    }
    
    cell.label.text = [self.nameArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        [self.tableView reloadData];
    PlayTableViewCell *cell = (PlayTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"playCell"];
    cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if((cell.action.image = [UIImage imageNamed:@"playOff.png"])) {
        
        NSString *trackId = [NSString stringWithFormat:@"%@", [_idArray objectAtIndex:indexPath.row]];
        [self requestPlayAudioFromId:trackId];
        [cell.action setImage:[UIImage imageNamed:@"playOn.png"]];
        [[AVAudioSession sharedInstance]
         setCategory: AVAudioSessionCategoryPlayback error: nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        [self becomeFirstResponder];
        
    }
    if((cell.action.image == [UIImage imageNamed:@"playOn.png"])){
        
            [self.audioPlayer pause];
            [cell.action setImage:[UIImage imageNamed:@"pause.png"]];
    }
    if ((cell.action.image == [UIImage imageNamed:@"pause.png"])){
        
        [self.audioPlayer play];
        [cell.action setImage:[UIImage imageNamed:@"playOn.png"]];
    }
    







}

#pragma mark - Search bar
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    _searchStr = searchText;
  
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [self.idArray removeAllObjects];
    [self.nameArray removeAllObjects];
    [self requestSearchWithString:_searchStr];

    [[self view] endEditing:YES];
}
#pragma mark - Requests
- (void)requestPlayAudioFromId:(NSString *)idTrack
{
    __block NSURL *trackUrl = [NSURL new];

    NSDictionary *parameters = @{
                                 @"access_token": _token,
                                 @"method" : @"tracks_get_download_link",
                                 @"track_id": idTrack,
                                 @"reason": @"listen"
                                 };
    
    [[AFHTTPSessionManager manager] POST:_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSString *url = [responseObject objectForKey:@"url"];
        trackUrl = [NSURL URLWithString:url];
        NSLog(@"%@", responseObject);
        
        _audioPlayer = [[AVPlayer alloc] initWithURL:trackUrl];
        [_audioPlayer play];

        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", error);
    }];
    
}
- (void)requestTopListWithPeriod:(NSString *)listType andLanguage:(NSString *)language
{
    _idArray = [NSMutableArray new];
    
    NSDictionary *parameters = @{
                                 @"access_token": _token,
                                 @"method" : @"get_top_list",
                                 @"list_type": listType,
                                 @"language" : language,
                                 @"page": @"1"
                                 };
    [[AFHTTPSessionManager manager] POST:_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        
        NSDictionary *responseDictionary = [responseObject objectForKey:@"tracks"];
        NSDictionary *track = [responseDictionary objectForKey:@"data"];
        NSArray *keys = [track allKeys];
        for (NSString *key in keys) {
            NSDictionary *data = [track objectForKey:key];
            NSString * title = [NSString stringWithFormat:@"%@ - %@", [data objectForKey:@"artist"], [data objectForKey:@"track"]];
            [_idArray addObject:[data objectForKey:@"id"]];
            [_nameArray addObject:title];
        };
       
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", error);
    }];
    
    
}
- (void) requestSearchWithString:(NSString *)searchString
{
    NSString *method = @"tracks_search";
    int countOnPage = 35;
    int pageNumber = 1;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [ud objectForKey:@"token"];
    NSMutableURLRequest *requestSearch = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.pleer.com/index.php"]];
    requestSearch.HTTPMethod = @"POST";
    [requestSearch addValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString *stringSearch = [NSString stringWithFormat:@"access_token=%@&method=%@&query=%@&page=%d&result_on_page=%d",access_token,method,searchString,pageNumber,countOnPage];
    [requestSearch setHTTPBody:[stringSearch dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:requestSearch
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                           options:kNilOptions
                                                                                             error:&error];
                                      NSLog(@"%@",json);
                                      NSDictionary *track = [json objectForKey:@"tracks"];
                                      NSArray *keys = [track allKeys];
                                      for (NSString *key in keys) {
                                          NSDictionary *data = [track objectForKey:key];
                                          NSString * title = [NSString stringWithFormat:@"%@ - %@", [data objectForKey:@"artist"], [data objectForKey:@"track"]];
                                          
                                          [self.idArray addObject:[data objectForKey:@"id"]];
                                          [_nameArray addObject:title];
                                         

                                      }
                                      [self.tableView reloadData];
                                  }];
    [task resume];

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
