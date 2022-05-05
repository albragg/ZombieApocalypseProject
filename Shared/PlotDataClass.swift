//
//  PlotDataClass.swift
//  SwiftUICorePlotExample
//  Shared
//
//  Created by Jeff Terry on 12/16/20.
//

import Foundation
import SwiftUI
import CorePlot

class PlotDataClass: NSObject, ObservableObject {
    
    @Published var plotData = [plotDataType]()
    @Published var plotData2 = [plotDataType]()
    @Published var changingPlotParameters: ChangingPlotParameters = ChangingPlotParameters()
    
    //In case you want to plot vs point number
    @Published var pointNumber = 1.0
    
    init(fromLine line: Bool) {
        
        
        //Must call super init before initializing plot
        super.init()
       
        
        //Intitialize the first plot
        
        
        // Change stuff in here to change how the first plot comes out
        
        self.plotYEqualsX()
        
       }
    
    
    
    func plotYEqualsX()
    {
        plotData = []
        plotData2 = []
        let initialPopulation = 500.0
        let alpha = 0.005
        let beta = 0.0095
        let delta = 0.0001
        let zeta = 0.0001
        let stepSize = 0.001
        let maxTime = 10.0
        let pi = 0.0
        
        let resultsArray = basicModel(alpha: alpha, beta: beta, delta: delta, zeta: zeta, initialPopulation: initialPopulation, stepSize: stepSize, maxTime: maxTime, pi: pi)
        let n = resultsArray.count
        for i in 0 ..< n {

            //create x values here
            let j = n - 1 - i

            let x = resultsArray[j].time
       //     let x2 = resultsArray[i].time
            
        //create y values here

            let y = resultsArray[j].susceptible
        //    let z = resultsArray[i].zombie
            
            let dataPoint: plotDataType = [.X: x, .Y: y]
        //    let dataPoint2: plotDataType = [.X: x2, .Y: z]
            plotData.append(contentsOf: [dataPoint])
        //    plotData2.append(contentsOf: [dataPoint2])
        
        }
        for i in 0 ..< n {
            let x = resultsArray[i].time
            let y = resultsArray[i].zombie
            let dataPoint: plotDataType = [.X: x, .Y: y]
            plotData.append(contentsOf: [dataPoint])
        }
        
        //set the Plot Parameters
        changingPlotParameters.yMax = 550.0
        changingPlotParameters.yMin = -50.0
        changingPlotParameters.xMax = 12.0
        changingPlotParameters.xMin = -3.0
        changingPlotParameters.xLabel = "Time (Days)"
        changingPlotParameters.yLabel = "Population (thousands)"
        changingPlotParameters.lineColor = .blue()
        changingPlotParameters.title = "Human and zombie population"
        
    }
    
    func zeroData(){
            
            plotData = []
            plotData2 = []
            pointNumber = 1.0
            
        }
        
        func appendData(dataPoint: [plotDataType])
        {
          
            plotData.append(contentsOf: dataPoint)

            pointNumber += 1.0
            
            
            
        }
    
    

}


