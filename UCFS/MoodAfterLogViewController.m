//
//  MoodAfterGoalViewController.m
//  FitHeart
//
//  Created by Bitgears on 05/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "MoodAfterLogViewController.h"
#import "FTAppSettings.h"
#import "UCFSUtil.h"
#import "MoodSection.h"
#import "MoodHomeViewController.h"
#import "SupportHomeViewController.h"

static NSArray *moodReinforcementMessageArray = nil;
static NSArray *moodActivationMessageArray = nil;
static NSArray *moodInspirationalMessageArray = nil;


@interface MoodAfterLogViewController () {
    int currentMood;
}

@end

@implementation MoodAfterLogViewController

@synthesize continueButton;
@synthesize supportButton;
@synthesize moodImageView;
@synthesize moodMessageLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withMood:(int)mood
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentMood = mood;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self navigationController] setNavigationBarHidden:NO animated:NO];

    if (currentMood==0 || currentMood==1) {
        //bad or verybad
        supportButton.hidden = NO;
        [continueButton setFrame:CGRectMake(160, continueButton.frame.origin.y, 158, continueButton.frame.size.height)];
    }
    else {
        supportButton.hidden = YES;
        [continueButton setFrame:CGRectMake(0, continueButton.frame.origin.y, 320, continueButton.frame.size.height)];
    }
    continueButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:20.0];
    supportButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:20.0];
    [moodImageView setAccessibilityLabel:@"Mood status"];
    moodImageView.userInteractionEnabled = YES;
    [moodImageView setIsAccessibilityElement:YES];
    
    switch(currentMood) {
        case 0:
            [moodImageView setImage:[UIImage imageNamed:@"mood_smile_5_big"]];
            [moodImageView setAccessibilityValue:@"Very bad"];
            break;
        case 1:
            [moodImageView setImage:[UIImage imageNamed:@"mood_smile_4_big"]];
            [moodImageView setAccessibilityValue:@"Bad"];
            break;
        case 2:
            [moodImageView setImage:[UIImage imageNamed:@"mood_smile_3_big"]];
            [moodImageView setAccessibilityValue:@"Neutral"];
            break;
        case 3:
            [moodImageView setImage:[UIImage imageNamed:@"mood_smile_2_big"]];
            [moodImageView setAccessibilityValue:@"Good"];
            break;
        case 4:
            [moodImageView setImage:[UIImage imageNamed:@"mood_smile_1_big"]];
            [moodImageView setAccessibilityValue:@"Very good"];
            break;
    }
    
    switch(currentMood) {
        case 0:
        case 1:
            moodMessageLabel.text = [MoodAfterLogViewController getMoodActivationMessage];
            break;
        case 2:
            moodMessageLabel.text = [MoodAfterLogViewController getMoodInspirationalMessage];
            break;
        case 3:
        case 4:
            moodMessageLabel.text = [MoodAfterLogViewController getMoodReinforcementMessage];
            break;
    }
    [moodMessageLabel sizeToFit];
    CGRect oldFrame = moodMessageLabel.frame;
    CGRect newFrame = CGRectMake((320-oldFrame.size.width)/2, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
    moodMessageLabel.frame = newFrame;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                           item:self.navigationItem
                          title:@"MOOD"
                    bkgFileName:[MoodSection navBarBkg:0]
                      textColor:[MoodSection navBarTextColor:0]
                 isBackVisibile: NO
     ];
    
    [continueButton setTitle:@"CONTINUE" forState:UIControlStateNormal];

}


+ (NSString*)getMoodReinforcementMessage {
    if (moodReinforcementMessageArray==nil) {
        moodReinforcementMessageArray = [[NSArray alloc] initWithObjects:
                                         @"You are training your way to You are training your way to You are training your way to You are training your way to.",
                                         @"Noticing positive events trains your brain to see possibilities for growth, and then seize opportunities.",
                                         @"Even small positive events can impact your mood and ability to handle stress. The key is to note when they happen.",
                                         @"Practice looking for positive events such as nice interactions with others or pleasant experiences with nature.",
                                         @"Savor positive events. It's OK to enjoy small pleasures.",
                                         @"Amplify a positive event. Write about it, tell someone else about it, or take a bit of time to just feel good about it.",
                                         @"Try savoring and sharing your positive events.",
                                         @"It may help to think of your strengths; what you do when you feel your best and how you can approach a situation.",
                                         @"Whatever the present moment contains, accept it as if you had chosen it. - Eckhart Tolle",
                                         @"Are you grateful for someone or something? Think back on this later when you don’t feel as good as you do now.",
                                         @"Take a moment to think about things in your life you are grateful for, perhaps good things you may not even notice.",
                                         @"Try working toward your goals and recording your progress each day.  Celebrate your successes!",
                                         @"Making and achieving goals can improve your mood.",
                                         @"We are what we repeatedly do. Excellence, therefore, is not an act but a habit. - Aristotle",
                                         @"Acts of kindness are good because they give you a break from your problems and shift the focus to someone else.",
                                         @"Did the kindness of others help you feel good? Practice random acts of kindness.",

                            
                                         nil
                            ];
    }
    
    int index = [FTAppSettings getMoodReinforcementMessageIndex];
    index++;
    if (index>=[moodReinforcementMessageArray count])
        index = 0;
    [FTAppSettings setMoodReinforcementMessageIndex:index];
    
    return moodReinforcementMessageArray[index];
    
}

+ (NSString*)getMoodActivationMessage {
    if (moodActivationMessageArray==nil) {
        moodActivationMessageArray = [[NSArray alloc] initWithObjects:
                                      @"Positive events don't have to be big. They can be everyday things, like listening to music or enjoying a cup of coffee.",
                                      @"Happiness is not something ready made. It comes from your own actions. - Dalai Lama",
                                      @"No one can make you feel inferior without your consent. - Eleanor Roosevelt",
                                      @"Everyone has unique strengths like patience, flexibility, enthusiasm, and optimism. Remembering your strengths.",
                                      @"Do you have strengths that can help you pull through this rough time?",
                                      @"When being mindful, many thoughts and emotions arise. Practice simply noticing they are there without taking action.",
                                      @"Practice being present in daily life. Practice a task more mindfully, paying attention to what you are thinking and feeling in the moment.",
                                      @"Would you like to do a mindfulness breathing exercise? Tap on SUPPORT.",
                                      @"Gratitude strengthens relationships. We are more likely to treat people better and create an upward spiral of kindness.",
                                      @"Gratitude helps us cultivate an attitude of generosity towards others.",
                                      @"Instead of envying others, gratitude reminds us of what we value in our own lives.",
                                      @"Research shows that training oneself to be grateful increases happiness, optimism, connection, and health.",
                                      @"The shortest way to do many things is to do only one thing at a time. ~ Sir Richard Cecil",
                                      @"I have not failed. I've just found 10,000 ways that won't work. - Thomas A. Edison",
                                      @"Try doing something nice for someone else. It doesn’t have to be big, even a small act can matter.",
                                      @"Random Acts of Kindness: Hold the door. Smile at a stranger. Say 'Good morning' to the people in the elevator.",
                                      @"Random Acts of Kindness: Share your umbrella with someone. Help carry a stroller up the stairs.",
                                      @"Random Acts of Kindness: Let a driver merge into your lane. Give up your seat for someone on the train or bus.",
                                      @"Practice looking for positive events such as nice interactions with others or pleasant experiences with nature.",
                                      @"Every day is a new chance to be our very best. ~ Bryan Elliott",
                                      @"Identify what is in your control and then tackle a quick, small goal. This ups our feelings of control and confidence.",
                                      @"What is important is not to be defeated, to forge ahead bravely. If we do this, a path will open before us. ~ Daisaku Ikeda",
                                      @"There are many things in our lives, both large and small, that we might be grateful about. What do you feel grateful for?",
                                      @"No one is useless in this world who lightens the burdens of another. ~ Charles Dickens",
                                      @"There are almost always some positive things in life. Try to notice positive events; it can help you feel & cope better.",
                                      @"Turn your head towards the sun and the shadows will fall behind you. ~ Maori proverb",
                                      @"When you can't change the direction of the wind - adjust your sails. ~ H. Jackson Brown, Jr.",
                                      @"As food is fuel for the body, laughter is fuel for the spirit. Make it a point to create time for play. ~ Sonny Carroll",
                                      @"Our most empowering moments often arise after our most difficult setbacks. ~ Ryan Biddulph",
                                      
                                         
                                         nil
                                         ];
    }
    
    int index = [FTAppSettings getMoodActivationMessageIndex];
    index++;
    if (index>=[moodActivationMessageArray count])
        index = 0;
    [FTAppSettings setMoodActivationMessageIndex:index];
    
    return moodActivationMessageArray[index];
    
}

- (IBAction)continueAction:(id)sender {
    //find HomeViewController
    UIViewController* homeViewController = nil;
    NSArray *viewControllers = [self.navigationController viewControllers];
    if (viewControllers!=nil) {
        for (int i=0; i<[viewControllers count]; i++) {
            UIViewController* temp = (UIViewController*)[viewControllers objectAtIndex:i];
            if ([temp isMemberOfClass:[MoodHomeViewController class]]) {
                homeViewController = temp;
                break;
            }
        }
    }
    
    //pop to HomeViewController
    if (homeViewController!=nil) {
        [self.navigationController popToViewController:homeViewController animated:NO];
    }
    else
        [self.navigationController popToRootViewControllerAnimated:NO];

}

- (IBAction)supportAction:(id)sender {
    
    
    UIViewController* viewController = [[SupportHomeViewController alloc] initWithNibName:@"SupportHomeView" bundle:nil];
    
    [self.navigationController pushViewController:viewController animated:NO];
}

+ (NSString*)getMoodInspirationalMessage {
    if (moodInspirationalMessageArray==nil) {
        moodInspirationalMessageArray = [[NSArray alloc] initWithObjects:
                                         
                                         @"There are always flowers for those who want to see them. - Henri Matisse",
                                         @"Everything has beauty, but not everyone sees it. - Confucius",
                                         @"Are there positive events from your past that you can remember to help improve your mood?",
                                         @"A happy life consists not in the absence, but in the mastery of hardships. - Helen Keller",
                                         @"Life is 10% what happens to you and 90% how you react to it. ~ Charles Swindoll",
                                         @"You are already good, whole and complete. ~ Yongey Mingyur Rinpoche",
                                         @"With realization of one's own potential and self confidence in one's ability, one can build a better world. ~ Dalai Lama",
                                         @"The single most revolutionary thing you can do is recognize that you are enough. - Carlos Andrés Gómez",
                                         @"I don't let go of my thoughts, I meet them with understanding, then they let go of me. ~ Byron Katie",
                                         @"If you have time to breathe, you have time to meditate. ~ Ajahn Chah",
                                         @"Showing gratitude is one of the simplest yet most powerful things humans can do for each other. - Randy Pausch",
                                         @"Some people grumble that roses have thorns; I am grateful that thorns have roses. - Alphonse Karr",
                                         @"Continuous improvement is better than delayed perfection. ~ Mark Twain",
                                         @"No act of kindness, no matter how small, is ever wasted. ~ Aesop",
                                         @"Kind words can be short and easy to speak, but their echoes are truly endless. - Mother Teresa",
                                         @"Don't walk behind me, I may not lead. Don't walk in front of me, I may not follow. Just walk beside me and be my friend. ~ Albert Camus",
                                         @"Just reminding yourself of your strengths can help motivate you to accomplish what you want to do.",
                                         @"The most important point is to accept yourself and stand on your two feet. ~ Shunryu Suzuki",
                                         @"A great task is accomplished by a series of small acts. ~ Lao Tzu",
                                         @"Attitude is a little thing that makes a big difference. ~ Winston Churchill",
                                         @"We cannot change the cards we are dealt, just how we play the hand. - Randy Pausch",
                                         @"Savor positive events. It's okay to enjoy small pleasures.",
                                         @"Not all of us can do great things. But we can do small things with great love. - Mother Teresa",
                                         @"Don't judge each day by the harvest you reap but by the seeds that you plant. - Robert Louis Stevenson",
                                         @"Many of life's failures are people who did not realize how close they were to success when they gave up. ~ Thomas Edison",
                                         @"Among the things you can give and still keep are your word, a smile, and a grateful heart. - Zig Ziglar",
                                         @"You're off to Great Places! / Today is your day! / Your mountain is waiting, / So get on your way! ~ Dr Seuss",
                                         @"Kindness gives birth to kindness. ~ Sophocles",
                                         
                                         nil
                                         ];
    }
    
    int index = [FTAppSettings getMoodInspirationalMessageIndex];
    index++;
    if (index>=[moodInspirationalMessageArray count])
        index = 0;
    [FTAppSettings setMoodInspirationalMessageIndex:index];
    
    return moodInspirationalMessageArray[index];
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
