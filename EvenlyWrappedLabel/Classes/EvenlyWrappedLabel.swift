//
//  EvenlyWrappedLabel.swift
//  EvenlyWrappedLabel
//
//  Created by Jeff Burt on 10/10/17.
//  Copyright © 2017 StockX. All rights reserved.
//

import UIKit

/**
 A UILabel subclass that will vertically distribute text evenly across any
 number of lines, preventing text from grouping up at the top.
 
 Example:
 
 (1)
 This text:
 
     This sentence has a single
     orphan.
 
 Becomes:
 
     This sentence has
     a single orphan.
 
 (2)
 This text:
 
     This sentence has a lot of words on
     the top line.
 
 Becomes:
 
     This sentence has a lot
     of words on the top line.
 
 */
public class EvenlyWrappedLabel: UILabel {
    public override func drawText(in rect: CGRect) {
        let width = findMinimumWidth(maxHeight: sizeNeeded(for: frame.width).height,
                                     maxWidth: frame.width,
                                     testWidth: frame.width / 2.0,
                                     minWidth: 0)
        
        let x: CGFloat
        
        switch textAlignment {
        case .left, .justified, .natural: x = 0
        case .center: x = (frame.width - width) / 2.0
        case .right: x = frame.width - width
        }
        
        super.drawText(in: CGRect(x: x, y: 0, width: width, height: frame.height))
    }
    
    /**
     Returns the smallest width possible without causing the text to require a
     greater height than maxHeight to display the text.
     */
    func findMinimumWidth(maxHeight: CGFloat, maxWidth: CGFloat, testWidth: CGFloat, minWidth: CGFloat) -> CGFloat {
        let granularity: CGFloat = 1
        let widthCannotShrink = maxWidth <= testWidth + granularity
        
        guard widthCannotShrink else {
            let canDecreaseWidthFurther = sizeNeeded(for: testWidth).height <= maxHeight
            
            guard canDecreaseWidthFurther else {
                let increasedTestWidth = testWidth + (0.5 * (maxWidth - testWidth))
                return findMinimumWidth(maxHeight: maxHeight, maxWidth: maxWidth, testWidth: increasedTestWidth, minWidth: testWidth)
            }
            
            let decreasedTestWidth = testWidth - (0.5 * (testWidth - minWidth))
            return findMinimumWidth(maxHeight: maxHeight, maxWidth: testWidth, testWidth: decreasedTestWidth, minWidth: minWidth)
        }
        
        return maxWidth
    }
}