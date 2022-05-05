//
//  ChangingPlotParameters.swift
//  SwiftUICorePlotExample
//
//  Created by Jeff Terry on 12/19/20.
//

import SwiftUI
import CorePlot

class ChangingPlotParameters: NSObject, ObservableObject {
    
    //These plot parameters are adjustable
    
    var xLabel: String = "Time (days)"
    var yLabel: String = "Population (thousands)"
    var xMax : Double = 10.0
    var yMax : Double = 500.0
    var yMin : Double = -10.0
    var xMin : Double = -1.0
    var lineColor: CPTColor = .blue()
    var title: String = "Human and Zombie Remaining Population"
    
}
