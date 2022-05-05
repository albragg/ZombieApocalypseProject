//
//  CalculatePlotData.swift
//  SwiftUICorePlotExample
//
//  Created by Jeff Terry on 12/22/20.
//

import Foundation
import SwiftUI
import CorePlot

class CalculatePlotData: ObservableObject {
    
    var plotDataModel: PlotDataClass? = nil
    
    func plotHumanAndZombie(modelType: String, initialPopulation: Double, maxTime: Double, stepSize: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double, kappa: Double, sigma: Double, gamma: Double, cureRate: Double, killRatio: Double, pi: Double) {
        plotDataModel!.changingPlotParameters.yMax = initialPopulation * 1.10
        plotDataModel!.changingPlotParameters.yMin = -0.1 * initialPopulation
        plotDataModel!.changingPlotParameters.xMax = 1.1 * maxTime
        plotDataModel!.changingPlotParameters.xMin = -0.1 * maxTime
        plotDataModel!.changingPlotParameters.xLabel = "Time (days)"
        plotDataModel!.changingPlotParameters.yLabel = "Population (thousands)"
        plotDataModel!.changingPlotParameters.lineColor = .blue()
        plotDataModel!.changingPlotParameters.title = "Human and zombie population"

        plotDataModel!.zeroData()
        var plotData :[plotDataType] =  []
        var plotData2 :[plotDataType] = []
        

        var resultsArray: [(time: Double, susceptible: Double, zombie: Double)] = []
           // plot results array
           if (modelType == "Basic Model") {
               resultsArray = basicModel(alpha: alpha, beta: beta, delta: delta, zeta: zeta, initialPopulation: initialPopulation, stepSize: stepSize, maxTime: maxTime, pi: pi)
           }
           else if (modelType == "Latent Infection") {
               resultsArray =  latentInfection(rho: rho, alpha: alpha, beta: beta, delta: delta, zeta: zeta, initialPopulation: initialPopulation, stepSize: stepSize, maxTime: maxTime, pi: pi)
           }
           else if (modelType == "Quarantine") {
               resultsArray = quarantineModel(kappa: kappa, sigma: sigma, gamma: gamma, rho: rho, alpha: alpha, beta: beta, delta: delta, zeta: zeta, initialPopulation: initialPopulation, stepSize: stepSize, maxTime: maxTime, pi: pi)
           }
           else if (modelType == "Treatment") {
               resultsArray = treatmentModel(cureRate: cureRate, rho: rho, alpha: alpha, beta: beta, delta: delta, zeta: zeta, initialPopulation: initialPopulation, stepSize: stepSize, maxTime: maxTime, pi: pi)
           }
           else if (modelType == "Impulsive Eradication") {
               resultsArray = impulsiveEradication(killRatio: killRatio, alpha: alpha, beta: beta, delta: delta, zeta: zeta, initialPopulation: initialPopulation, stepSize: stepSize, maxTime: maxTime, pi: pi)
           }
           else {
               print("No model type chosen")
           }
           
        let n = resultsArray.count
        
        for i in 0 ..< n {

            //create x values here
            let j = n - 1 - i

            let x1 = resultsArray[j].time
            let x2 = resultsArray[i].time
            
        //create y values here

            let y = resultsArray[j].susceptible
            let z = resultsArray[i].zombie
            
            let dataPoint: plotDataType = [.X: x1, .Y: y]
            let dataPoint2: plotDataType = [.X: x2, .Y: z]
            plotData.append(contentsOf: [dataPoint])
            plotData2.append(contentsOf: [dataPoint2])
        }
        
        plotDataModel!.appendData(dataPoint: plotData)
        
        plotDataModel!.appendData(dataPoint: plotData2)
        
   /*     plotDataModel!.changingPlotParameters.lineColor = .red()
        
        plotDataModel!.zeroData()
        plotData =  []
        
        for i in 0 ..< n {

            //create x values here

            let x = resultsArray[i].time
            
        //create y values here

            let y = resultsArray[i].zombie
            
            let dataPoint: plotDataType = [.X: x, .Y: y]
            plotData.append(contentsOf: [dataPoint])
        }
        
        plotDataModel!.appendData(dataPoint: plotData)
    */
        
    }
    
}



