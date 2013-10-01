//
//  GraphMyExpensesViewController.m
//  Shoestring
//
//  Created by mark on 5/09/13.
//  Copyright (c) 2013 mark. All rights reserved.
//

#import "GraphMyExpensesViewController.h"
#import "CPTImageLayer.h"
#import "Categories.h"

#pragma mark - GraphMyExpensesViewController private interface
@interface GraphMyExpensesViewController ()

-(void)initPlot;
-(void)configureGraph;
-(void)configureChart;

@end

#pragma mark - GraphMyExpensesViewController implementation
@implementation GraphMyExpensesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initPlot];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Chart behaviour
-(void)initPlot
{
    self.hostView.allowPinchScaling = NO;
    [self configureGraph];
    [self configureChart];
}

-(void)configureGraph
{
    // 1 - Create and initialize graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    self.hostView.hostedGraph = graph;
    graph.paddingLeft = 0.0f;
    graph.paddingTop = 0.0f;
    graph.paddingRight = 0.0f;
    graph.paddingBottom = 0.0f;
    graph.axisSet = nil;
    // 2 - Set up text style
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor grayColor];
    textStyle.fontName = @"Helvetica-Bold";
    textStyle.fontSize = 20.0f;
    // 3 - Configure title
    /*NSString *title = @"My Budget";
     graph.title = title;
     graph.titleTextStyle = textStyle;
     graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
     graph.titleDisplacement = CGPointMake(0.0f, -12.0f);*/
}

-(void)configureChart
{
    // 1 - Get reference to graph
    CPTGraph *graph = self.hostView.hostedGraph;
    // 2 - Create chart
    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
    pieChart.dataSource = self;
    pieChart.delegate = self;
    pieChart.pieRadius = self.hostView.bounds.size.width * 0.3;
    pieChart.identifier = graph.title;
    //pieChart.startAngle = M_PI_4;
    pieChart.sliceDirection = CPTPieDirectionClockwise;
    
    // 3 - Create shadow
    CPTMutableShadow *shadow = [[CPTMutableShadow alloc] init];
    shadow.shadowBlurRadius = 5.0;
    shadow.shadowColor = [CPTColor colorWithComponentRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    pieChart.shadow = shadow;

    // 3 - Add chart to graph
    [graph addPlot:pieChart];
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return 5;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    if (CPTPieChartFieldSliceWidth == fieldEnum)
    {
        float f = 0.0;
        switch (idx) {
            case 0:
                f = 30.0;
                break;
            case 1:
                f = 21.0;
                break;
            case 2:
                f = 16.0;
                break;
            case 3:
                f = 14.0;
                break;
            case 4:
                f = 19.0;
                break;
        }
        return [NSDecimalNumber numberWithFloat:f];
    }
    return [NSDecimalNumber zero];
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx
{
    NSString *iconName = @"";
    switch (idx) {
        case 0:
            iconName = @"cat0.png";
            break;
        case 1:
            iconName = @"cat1.png";
            break;
        case 2:
            iconName = @"cat2.png";
            break;
        case 3:
            iconName = @"cat3.png";
            break;
        case 4:
            iconName = @"cat4.png";
            break;
        default:
            break;
    }
    CPTImageLayer *layer = [[CPTImageLayer alloc] initWIthImage:[UIImage imageNamed:iconName]];
    
    return layer;
}

#pragma mark - CPTPieChartDataSource methods
-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx
{
    switch (idx) {
        case 0:
            return [CPTFill fillWithColor:[Categories getColorFor:0]];
            break;
        case 1:
            return [CPTFill fillWithColor:[Categories getColorFor:1]];
            break;
        case 2:
            return [CPTFill fillWithColor:[Categories getColorFor:2]];
            break;
        case 3:
            return [CPTFill fillWithColor:[Categories getColorFor:3]];
            break;
        case 4:
            return [CPTFill fillWithColor:[Categories getColorFor:4]];
            break;
        default:
            return nil;
    }
}

-(CGFloat)radialOffsetForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx { return 10.0; };

@end
