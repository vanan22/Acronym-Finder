//
//  ViewController.m
//  Acronym Finder
//
//  Created by Santhosh Ramaraju on 8/26/15.
//  Copyright © 2015 Santhosh Ramaraju. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "ResultsDisplayTVCell.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *acronymTextField;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UILabel *noResultsFoundLabel;
@property (strong, nonatomic) NSDictionary *resultsDict;
@property (weak, nonatomic) IBOutlet UILabel *resultsHeading;
@property (strong, nonatomic) NSString *previousSearch;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mainTableView setHidden:YES];
    [self.noResultsFoundLabel setHidden:YES];
    [self.resultsHeading setHidden:YES];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)goButtonPressed:(id)sender {
    if([[self.acronymTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0 || [self.previousSearch isEqualToString:self.acronymTextField.text])
    {
        return;
    }
    self.previousSearch = self.acronymTextField.text;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.mainTableView setHidden:YES];
    [self.noResultsFoundLabel setHidden:YES];
    [self.resultsHeading setHidden:YES];
    dispatch_queue_t aQueue = dispatch_queue_create("aQueue", NULL);
    dispatch_async(aQueue, ^{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        //The Response from the given API is coming as text/plain MIME and the default types do not contain that.
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithArray:@[@"text/plain" ]]];
        NSDictionary *params = @{@"sf":self.acronymTextField.text};
        [manager.requestSerializer setTimeoutInterval:20.0];
        [manager GET:@"http://www.nactem.ac.uk/software/acromine/dictionary.py" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            if([responseObject isKindOfClass:[NSArray class]])
            {
                self.resultsDict = [responseObject firstObject];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if(self.resultsDict.count>0)
                {
                    [self.noResultsFoundLabel setHidden:YES];
                    self.mainTableView.rowHeight = 280.f;
                    self.mainTableView.dataSource = self;
                    [self.mainTableView reloadData];
                    [self.mainTableView setHidden:NO];
                    [self.resultsHeading setHidden:NO];
                }
                else
                {
                    [self.noResultsFoundLabel setHidden:NO];
                }
            });
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            dispatch_sync(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"Following error occurred. Please try again.\n%@",error] preferredStyle:UIAlertControllerStyleAlert];
            });
        }];
    });
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.resultsDict objectForKey:@"lfs"] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResultsDisplayTVCell *resultsCell = [tableView dequeueReusableCellWithIdentifier:@"reuseId"];
    NSArray *resArr = [self.resultsDict objectForKey:@"lfs"];
    resultsCell.longForm.text = [[resArr objectAtIndex:indexPath.row] objectForKey:@"lf"];
    resultsCell.yearFrom.text = [NSString stringWithFormat:@"%@",[[resArr objectAtIndex:indexPath.row] objectForKey:@"since"]];
    resultsCell.frequency.text = [NSString stringWithFormat:@"%@",[[resArr objectAtIndex:indexPath.row] objectForKey:@"freq"]];
    resultsCell.resultNumberLabel.text = [NSString stringWithFormat:@"%lu.",indexPath.row+1];
    resultsCell.variationsArr = [[resArr objectAtIndex:indexPath.row] objectForKey:@"vars"];
    [resultsCell loadVariations];
    return resultsCell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
