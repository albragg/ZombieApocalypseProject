//
//  ModelFunctions.swift
//  ZombieApocalypse
//
//  Created by Alyssa Bragg on 5/5/22.
//

import Foundation

// this is the percent of humans remaining where we start plotting to cutoff extra space
let cutoffPercent = 0.997

func basicModel(alpha: Double, beta: Double, delta: Double, zeta: Double, initialPopulation: Double, stepSize: Double, maxTime: Double) -> [(time: Double, susceptible: Double, zombie: Double)] {
    var removed = 0.0
    var susceptible = initialPopulation
    var zombie = 0.0
    let numberOfSteps = maxTime / stepSize
    var dataPoints: [(time: Double, susceptible: Double, zombie: Double)] = []
    let initialPoint = (0.0, susceptible, zombie)
    dataPoints.append(initialPoint)
// using eulers method
    var n = 1
    while(n <= Int(numberOfSteps)) {
        let sPrime = -1.0 * susceptible * (beta * zombie + delta)
        let zPrime = susceptible * zombie * (beta - alpha) + zeta * removed
        let rPrime = (delta + alpha * zombie) * susceptible - zeta * removed
        susceptible += stepSize * sPrime
        zombie += stepSize * zPrime
        removed += stepSize * rPrime
        // start counting time when we have 0.3 percent less humans
        if( susceptible < (initialPopulation * cutoffPercent)  ) {
            let dataPoint = (stepSize * Double(n), susceptible, zombie)
            dataPoints.append(dataPoint)
            print(dataPoint)
            n += 1
        }
    }
    return dataPoints
}



func latentInfection(rho: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, initialPopulation: Double, stepSize: Double, maxTime: Double) -> [(time: Double, susceptible: Double, zombie: Double)] {
    // i dont know why i have to do this
    let rhoInThousands = rho * 1000.0
    var removed = 0.0
    var infected = 0.0
    // do calculations in population number
    var susceptible = initialPopulation
    var zombie = 0.0
    let numberOfSteps = maxTime / stepSize
    var dataPoints: [(time: Double, susceptible: Double, zombie: Double)] = []
    let initialPoint = (0.0, susceptible, zombie)
    dataPoints.append(initialPoint)
// using eulers method
    var n = 1
    while( n <= Int(numberOfSteps)) {
        let sPrime = -1.0 * susceptible * (beta * zombie + delta)
        let iPrime = beta * susceptible * zombie - infected * (rhoInThousands + delta)
        let zPrime = rhoInThousands * infected - susceptible * zombie * alpha + zeta * removed
        let rPrime = (delta + alpha * zombie) * susceptible + delta * infected - zeta * removed
        susceptible += stepSize * sPrime
        infected += stepSize * iPrime
        zombie += stepSize * zPrime
        removed += stepSize * rPrime
        // start when we have 0.3 percent less humans, including infected
        let human = susceptible + infected
        if ( human <= ( initialPopulation * cutoffPercent ) ) {
            let dataPoint = (stepSize * Double(n), human, zombie)
            dataPoints.append(dataPoint)
            print(dataPoint, infected)
            n += 1
        }
    }
    return dataPoints
}
 
func quarantineModel(kappa: Double, sigma: Double, gamma: Double, rho: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, initialPopulation: Double, stepSize: Double, maxTime: Double) -> [(time: Double, susceptible: Double, zombie: Double)] {
    let rhoNew = rho * 1000.0
    var removed = 0.0
    var infected = 0.0
    var susceptible = initialPopulation
    var zombie = 0.0
    var quarantined = 0.0
    let numberOfSteps = maxTime / stepSize
    var dataPoints: [(time: Double, susceptible: Double, zombie: Double)] = []
    let initialPoint = (0.0, susceptible, zombie)
    dataPoints.append(initialPoint)
// using eulers method
    var n = 1
    while ( n <= Int(numberOfSteps)) {
        let sPrime = -1.0 * susceptible * (beta * zombie + delta)
        let iPrime = beta * susceptible * zombie - infected * (rhoNew + delta + kappa)
        let zPrime = rhoNew * infected - susceptible * zombie * alpha + zeta * removed - sigma * zombie
        let rPrime = (delta + alpha * zombie) * susceptible + delta * infected - zeta * removed + gamma * quarantined
        let qPrime = kappa * infected + sigma * zombie - gamma * quarantined
        susceptible += stepSize * sPrime
        infected += stepSize * iPrime
        zombie += stepSize * zPrime
        removed += stepSize * rPrime
        quarantined += stepSize * qPrime
        let humans = susceptible + infected
        if (humans <= (cutoffPercent * initialPopulation)){
            let dataPoint = (stepSize * Double(n), humans, zombie)
            dataPoints.append(dataPoint)
            n += 1
        }
    }
    return dataPoints
}



func treatmentModel(cureRate: Double, rho: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, initialPopulation: Double, stepSize: Double, maxTime: Double) -> [(time: Double, susceptible: Double, zombie: Double)] {
    // again i am multiplying rho by 1000 for some reason
    let rhoNew = rho * 1000.0
    var removed = 0.0
    var infected = 0.0
    var susceptible = initialPopulation
    var zombie = 0.0
    let numberOfSteps = maxTime / stepSize
    var dataPoints: [(time: Double, susceptible: Double, zombie: Double)] = []
    let initialPoint = (0.0, susceptible, zombie)
    dataPoints.append(initialPoint)
// using eulers method
    var n = 1
    while (n <= Int(numberOfSteps)) {
        let sPrime = -1.0 * susceptible * (beta * zombie + delta) + cureRate * zombie
        let iPrime = beta * susceptible * zombie - infected * (rhoNew + delta)
        let zPrime = rhoNew * infected - susceptible * zombie * alpha + zeta * removed - cureRate * zombie
        let rPrime = (delta + alpha * zombie) * susceptible + delta * infected - zeta * removed
        susceptible += stepSize * sPrime
        infected += stepSize * iPrime
        zombie += stepSize * zPrime
        removed += stepSize * rPrime
        let humans = susceptible + infected
        if (humans <= cutoffPercent * initialPopulation) {
            let dataPoint = (stepSize * Double(n), humans, zombie)
            dataPoints.append(dataPoint)
            n += 1
        }
    }
    return dataPoints
}



func impulsiveEradication(killRatio: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, initialPopulation: Double, stepSize: Double, maxTime: Double) -> [(time: Double, susceptible: Double, zombie: Double)]{
    var numberOfKills = 1.0 / killRatio
    if(killRatio >= 0.5){
        numberOfKills = 2.0
    }
    let killInterval = maxTime / numberOfKills
    let stepsUntilKill = Int(killInterval / stepSize)
    var removed = 0.0
    var susceptible = initialPopulation
    var zombie = 0.0
    let numberOfSteps = maxTime / stepSize
    var dataPoints: [(time: Double, susceptible: Double, zombie: Double)] = []
    let initialPoint = (0.0, susceptible, zombie)
    dataPoints.append(initialPoint)
    var incrementKills: Int = 1
    var killNumber = 1.0
    var n = 1
    while ( n <= Int(numberOfSteps)) {
        if (incrementKills == stepsUntilKill) {
            zombie -= killRatio * killNumber * zombie
            incrementKills = 0
            killNumber += 1.0
            print(n, "kill commited", zombie)
        }
        else {
            let sPrime = -1.0 * susceptible * (beta * zombie + delta)
            let zPrime = susceptible * zombie * (beta - alpha) + zeta * removed
            let rPrime = (delta + alpha * zombie) * susceptible - zeta * removed
            susceptible += stepSize * sPrime
            zombie += stepSize * zPrime
            removed += stepSize * rPrime
        }
        // start when we have 1 zombie
        if (susceptible <= cutoffPercent * initialPopulation) {
            // number of zombies plotted instead of zombies in thousands
            let dataPoint = (stepSize * Double(n), susceptible, zombie)
            print(dataPoint)
            dataPoints.append(dataPoint)
            n += 1
            incrementKills += 1
        }
    }
    return dataPoints
}

