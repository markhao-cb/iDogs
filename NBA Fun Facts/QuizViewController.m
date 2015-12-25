//
//  QuizViewController.m
//  iDogs
//
//  Created by Yu Qi Hao on 11/25/14.
//  Copyright (c) 2014 Yu Qi Hao. All rights reserved.
//

#import "QuizViewController.h"
#import "AppDelegate.h"


@interface QuizViewController () {
    UIButton *button1;
    UIButton *button2;
    UIButton *button3;
    UIButton *button4;
    int right;
    int all;
}
@property (weak, nonatomic) IBOutlet UIImageView *ivAnswer;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation QuizViewController
- (IBAction)buttonTapped:(id)sender {
    NSLog(@"sender: %ld",(long)((UIButton*)sender).tag);
    if ((long)((UIButton*)sender).tag == 100) {
        right++;
        all++;
        NSLog(@"Answer correct");
        _ivAnswer.image = [UIImage imageNamed:@"checkmark"];
        _ivAnswer.alpha = 1;
        [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _ivAnswer.alpha = 0;
        } completion:^(BOOL finished){
        }];
        [self loadData];
    }
    else {
        NSLog(@"Answer wrong");
        all++;
        _ivAnswer.image = [UIImage imageNamed:@"cross"];
        _ivAnswer.alpha = 1;
        [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _ivAnswer.alpha = 0;
        } completion:^(BOOL finished){
        }];
        [self loadData];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"idog_bg"]];
    
    right = 0;
    all = 0;
    button1 = (id)[self.view viewWithTag:31];
    button2 = (id)[self.view viewWithTag:32];
    button3 = (id)[self.view viewWithTag:33];
    button4 = (id)[self.view viewWithTag:34];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.db queryDB:[NSString stringWithFormat:@"select name from info order by random() limit 4"] numOfColumns:1];
    NSLog(@"%@",appDelegate.db.rs[1][0]);
    UIImageView *imageView = (id)[self.view viewWithTag:30];
    NSMutableArray *buttonArray = [[NSMutableArray alloc]init];
    button1.tag = 31;
    button2.tag = 32;
    button3.tag = 33;
    button4.tag = 34;
    [buttonArray addObject:button1];
    [buttonArray addObject:button2];
    [buttonArray addObject:button3];
    [buttonArray addObject:button4];
    int value = arc4random() % 4;
    NSString *imageName = [appDelegate.db.rs[0][0] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",imageName]];
    NSString *answer = appDelegate.db.rs[0][0];
    [buttonArray[value] setTitle:answer forState:UIControlStateNormal];
    int j = 1;
    for (int i=0; i<4; i++) {
        if (i!=value) {
            [buttonArray[i] setTitle:appDelegate.db.rs[j][0] forState:UIControlStateNormal];
            j++;
        }
    }
    ((UIButton*) buttonArray[value]).tag = 100;
    if (all == 0) {
        _lblCount.alpha = 0;
    }
    else {
        _lblCount.alpha = 1;
    }
    
    _lblCount.text = [NSString stringWithFormat:@"%d correct out of %d",right,all];
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
