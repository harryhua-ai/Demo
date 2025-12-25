//
//  TouchpadGestureHandler.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "TouchpadGestureHandler.h"
#import "ScintillaCocoa.h"

@implementation TouchpadGestureHandler

- (instancetype)initWithTextView:(ScintillaView *)textView window:(NSWindow *)window {
    self = [super init];
    if (self) {
        _textView = textView;
        _window = window;
        [self setupGestureRecognizers];
    }
    return self;
}

- (void)setupGestureRecognizers {
    // Add magnification gesture recognizer for zooming
    NSMagnificationGestureRecognizer *magnificationGesture = [[NSMagnificationGestureRecognizer alloc] initWithTarget:self action:@selector(handleMagnificationGesture:)];
    [self.textView addGestureRecognizer:magnificationGesture];
    
    // Add swipe gesture recognizers for navigation
    NS SwipeGestureRecognizer *swipeLeftGesture = [[NSSwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    swipeLeftGesture.direction = NSSwipeGestureRecognizerDirectionLeft;
    [self.textView addGestureRecognizer:swipeLeftGesture];
    
    NS SwipeGestureRecognizer *swipeRightGesture = [[NSSwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    swipeRightGesture.direction = NSSwipeGestureRecognizerDirectionRight;
    [self.textView addGestureRecognizer:swipeRightGesture];
    
    // Add rotation gesture for special actions
    NSRotationGestureRecognizer *rotationGesture = [[NSRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationGesture:)];
    [self.textView addGestureRecognizer:rotationGesture];
    
    // Allow simultaneous recognition of gestures
    [self.textView setAllowsMultipleTouches:YES];
}

- (void)handleMagnificationGesture:(NSMagnificationGestureRecognizer *)gestureRecognizer {
    // Handle pinch-to-zoom gesture
    if (gestureRecognizer.state == NSGestureRecognizerStateBegan || 
        gestureRecognizer.state == NSGestureRecognizerStateChanged) {
        CGFloat magnification = [gestureRecognizer magnification];
        
        // Get current zoom level
        long currentZoom = [self.textView sendmessage:SCI_GETZOOM sub:0 wparam:0];
        
        // Adjust zoom based on magnification
        long newZoom = currentZoom + (magnification * 10); // Scale factor
        
        // Apply zoom with reasonable limits
        if (newZoom < -10) newZoom = -10;
        if (newZoom > 20) newZoom = 20;
        
        [self.textView sendmessage:SCI_SETZOOM sub:newZoom wparam:0];
    }
}

- (void)handleSwipeLeft:(NSSwipeGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == NSGestureRecognizerStateEnded) {
        // Move to next bookmark or perform some navigation
        // This could be customized based on user preferences
        NSLog(@"Swipe left gesture detected");
    }
}

- (void)handleSwipeRight:(NSSwipeGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == NSGestureRecognizerStateEnded) {
        // Move to previous bookmark or perform some navigation
        // This could be customized based on user preferences
        NSLog(@"Swipe right gesture detected");
    }
}

- (void)handleRotationGesture:(NSRotationGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == NSGestureRecognizerStateEnded) {
        // Handle rotation gesture - maybe switch syntax highlighting?
        CGFloat rotation = [gestureRecognizer rotation];
        NSLog(@"Rotation gesture detected: %f degrees", rotation);
    }
}

@end