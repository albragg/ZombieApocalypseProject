//
//  ContentView.swift
//  Shared
//
//  Created by Jeff Terry on 12/17/20.
//
//
//  Based on Code Created by Fred Appelman on 14/12/2020.
//

import SwiftUI
import CorePlot

typealias plotDataType = [CPTScatterPlotField : Double]

struct ContentView: View {
    @ObservedObject var plotDataModel = PlotDataClass(fromLine: true)
    @ObservedObject private var dataCalculator = CalculatePlotData()
    // model type selection
        var modelTypeOptions = ["Basic Model", "Latent Infection", "Quarantine", "Treatment", "Impulsive Eradication"]
        @State private var modelType = "Basic Model"
    //usual initial parameters
    @State private var initialPopulation: Double? = 500.0
    @State private var editedInitialPopulation: Double? = 500.0
    @State private var stepSize: Double? = 0.001
    @State private var editedStepSize: Double? = 0.001
    @State private var maxTime: Double? = 10.0
    @State private var editedMaxTime: Double? = 10.0
    // basic model parameters
    @State private var alpha: Double? = 0.005
    @State private var editedAlpha: Double? = 0.005
    @State private var beta: Double? = 0.0095
    @State private var delta: Double? = 0.0001
    @State private var zeta: Double? = 0.0001
    @State private var editedBeta: Double? = 0.0095
    @State private var editedDelta: Double? = 0.0001
    @State private var editedZeta: Double? = 0.0001
    // latent infection
    @State private var rho: Double? = 0.005
    @State private var editedRho: Double? = 0.005
    // quarantine
    @State private var kappa: Double? = 0.004
    @State private var sigma: Double? = 0.004
    @State private var gamma: Double? = 0.001
    @State private var editedKappa: Double? = 0.004
    @State private var editedSigma: Double? = 0.004
    @State private var editedGamma: Double? = 0.001
    // treatment
    @State private var cureRate: Double? = 0.008
    @State private var editedCureRate: Double? = 0.008
    // eradication
    @State private var killRatio: Double? = 0.25
    @State private var editedKillRatio: Double? = 0.25
    // add in birth rate
    @State private var pi: Double? = 0.0
    @State private var editedPi: Double? = 0.0
 
    private var doubleFormatter: NumberFormatter = {
            let f = NumberFormatter()
            f.numberStyle = .decimal
            f.maximumFractionDigits = 10
            return f
        }()

    var body: some View {
        

        VStack{
            HStack{
                VStack{
            CorePlot(dataForPlot: $plotDataModel.plotData, changingPlotParameters: $plotDataModel.changingPlotParameters)
                .setPlotPadding(left: 10)
                .setPlotPadding(right: 10)
                .setPlotPadding(top: 10)
                .setPlotPadding(bottom: 10)
                .padding()
            
                
            Picker("Model type", selection: $modelType) {
                        ForEach(modelTypeOptions, id: \.self) {
                            Text($0)
                        }
            }
            .pickerStyle(.menu)
            
                
            
            VStack{
                HStack{
                
                    Text(verbatim: "Initial Human Population (thousands):")
                        .padding()
                    TextField("Initial Human Population, in thousands, enter as double", value: $editedInitialPopulation, formatter: doubleFormatter, onCommit: {
                        self.initialPopulation = self.editedInitialPopulation
                    })
            
                    .padding()
                
                }
                HStack{
                
                    Text(verbatim: "Total Time (days):")
                        .padding()
                    TextField("Enter total time in days", value: $editedMaxTime, formatter: doubleFormatter, onCommit: {
                        self.maxTime = self.editedMaxTime
                    })
            
                    .padding()
                
                }
                HStack{
                
                    Text(verbatim: "Step Size:")
                        .padding()
                    TextField("Enter step size", value: $editedStepSize, formatter: doubleFormatter, onCommit: {
                        self.stepSize = self.editedStepSize
                    })
            
                    .padding()
                
                }
            }
            }
                VStack{
            
            VStack{
                
                Text(verbatim: "Basic Model Parameters")
                    .padding()
                
                HStack{
                
            
                    Text(verbatim: "Rate that humans kill zombies in encounters (alpha):")
                        .padding()
                    TextField("Alpha, between zero and one", value: $editedAlpha, formatter: doubleFormatter, onCommit: {
                        self.alpha = self.editedAlpha
                    })
            
                        .padding()
                
                }
                
                HStack{
                
            
                    Text(verbatim: "Rate that zombies convert humans in encounters (beta):")
                        .padding()
                    TextField("Beta, between zero and one", value: $editedBeta, formatter: doubleFormatter, onCommit: {
                        self.beta = self.editedBeta
                    })
            
                        .padding()
                
                }
                HStack{
                
            
                    Text(verbatim: "Natural human death rate (delta):")
                        .padding()
                    TextField("Delta, should be a small decimal", value: $editedDelta, formatter: doubleFormatter, onCommit: {
                        self.delta = self.editedDelta
                    })
            
                        .padding()
                
                }
                HStack{
                
            
                    Text(verbatim: "Rate that dead reanimate as zombies (zeta):")
                        .padding()
                    TextField("Zeta, between zero and one", value: $editedZeta, formatter: doubleFormatter, onCommit: {
                        self.zeta = self.editedZeta
                    })
            
                        .padding()
                
                }
                HStack{
                
            
                    Text(verbatim: "Human birth rate (pi):")
                        .padding()
                    TextField("Birth rate, enter zero or a small decimal", value: $editedPi, formatter: doubleFormatter, onCommit: {
                        self.pi = self.editedPi
                    })
            
                        .padding()
                
                }
            }
                    VStack{
                        if ((modelType == "Latent Infection") || (modelType == "Quarantine") || (modelType == "Treatment")) {
                            Text(verbatim: "Latent Infection Parameter")
                                .padding()
                            HStack{
                            
                        
                                Text(verbatim: "Rate that infected become zombies (rho):")
                                    .padding()
                                TextField("Rho, between zero and one", value: $editedRho, formatter: doubleFormatter, onCommit: {
                                    self.rho = self.editedRho
                                })
                        
                                    .padding()
                            
                            }
                        }
                        
                        // put more if statements in here
                        if (modelType == "Quarantine") {
                            VStack{
                                Text(verbatim: "Quarantine Parameters")
                                    .padding()
                                
                                HStack{
                                    
                                    
                                    Text(verbatim: "Rate that infected enter quarantine (kappa):")
                                        .padding()
                                    TextField("Kappa, between zero and one", value: $editedKappa, formatter: doubleFormatter, onCommit: {
                                        self.kappa = self.editedKappa
                                    })
                            
                                        .padding()
                                
                                }
                                HStack{
                                
                            
                                    Text(verbatim: "Rate that zombies enter quarantine (sigma):")
                                        .padding()
                                    TextField("Sigma, between zero and one", value: $editedSigma, formatter: doubleFormatter, onCommit: {
                                        self.sigma = self.editedSigma
                                    })
                            
                                        .padding()
                                
                                }
                                HStack{
                                
                            
                                    Text(verbatim: "Rate that the quarantined are killed in escape attempts (gamma):")
                                        .padding()
                                    TextField("Gamma, between zero and one", value: $editedGamma, formatter: doubleFormatter, onCommit: {
                                        self.gamma = self.editedGamma
                                    })
                            
                                        .padding()
                                
                                }
                            }
                        }
                        
                        
                        if (modelType == "Treatment") {
                            Text(verbatim: "Treatment Parameter")
                                .padding()
                            HStack{
                            
                        
                                Text(verbatim: "Cure rate (administered only to zombies):")
                                    .padding()
                                TextField("Cure rate, between zero and one", value: $editedCureRate, formatter: doubleFormatter, onCommit: {
                                    self.cureRate = self.editedCureRate
                                })
                        
                                    .padding()
                            
                            }
                        }
                        
                        if (modelType == "Impulsive Eradication") {
                        /*    alpha = 0.0075
                            beta = 0.0055
                            delta = 0.09
                            zeta = 0.0001 */
                            VStack{
                            Text(verbatim: "Impulsive Eradication Parameter")
                                .padding()
                            HStack{
                            
                        
                                Text(verbatim: "Kill ratio (fraction of zombies killed in first attack):")
                                    .padding()
                                TextField("Kill ratio, between zero and one", value: $editedKillRatio, formatter: doubleFormatter, onCommit: {
                                    self.killRatio = self.editedKillRatio
                                })
                        
                                    .padding()
                            
                            }
                            }
                        }
                        
                    }
        
                }
            }


            
            
            
            
            Divider()
            
            
            Button("Plot Selected Model", action: {self.calculateModel(modelType: modelType, initialPopulation: initialPopulation!, maxTime: maxTime!, stepSize: stepSize!, alpha: alpha!, beta: beta!, delta: delta!, zeta: zeta!, rho: rho!, kappa: kappa!, sigma: sigma!, gamma: gamma!, cureRate: cureRate!, killRatio: killRatio!, pi: pi!)} )
                .padding()
                
        }
    }


    
    func calculateModel(modelType: String, initialPopulation: Double, maxTime: Double, stepSize: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double, kappa: Double, sigma: Double, gamma: Double, cureRate: Double, killRatio: Double, pi: Double){
        
        //pass the plotDataModel to the dataCalculator
        dataCalculator.plotDataModel = self.plotDataModel
        //Calculate the new plotting data and place in the plotDataModel
        dataCalculator.plotHumanAndZombie(modelType: modelType, initialPopulation: initialPopulation, maxTime: maxTime, stepSize: stepSize, alpha: alpha, beta: beta, delta: delta, zeta: zeta, rho: rho, kappa: kappa, sigma: sigma, gamma: gamma, cureRate: cureRate, killRatio: killRatio, pi: pi)
        
    }
   

}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/
