//
//  CalculaterBrain.swift
//  SwiftUI Test Calc UI
//
//  Created by PC on 20/08/22.
//

import Foundation

class CalculaterBrain {


    func calculate(equation: [String]) -> String{
        print(equation)

        var prioriti = ["+":1, "-":1, "*":2, "/":2]
        var num = [Double]()
        var simbol = [String]()

        for i in equation {
            if i == "/" || i == "+" || i == "-" || i == "*"{
                simbol.append(i)
            }else{
                if let x = Double(i){
                    num.append(x)
                }
            }
        }

        while !simbol.isEmpty {
            let index = simbol.firstIndex(where: {prioriti[String($0)] == 2}) ?? 0

            switch (simbol[index]) {
            case "+":
                num[index] = num[index] + num[index+1]

            case "-":
                num[index] = num[index] - num[index+1]

            case "*":
                num[index] = num[index] * num[index+1]

            case "/":
                num[index] = num[index] / num[index+1]

            default:
                break
            }

            num.remove(at: index+1)
            simbol.remove(at: index)
        }
        if String(num[0]).contains("e"){
            let x = exponantional(a: num[0])
            return String(x)
        }
        if Double(Int(num[0])) == num[0]{
            return String(Int(num[0]))
        }

        return String(num[0])

    }

    func exponantional(a:Double) -> Double{

        let b = Int(log (Double(a))/log (10))

        let c = Double (Double (a) * pow(10, Double(-b))).rounded(.up)

        let d =  Double(c) * pow(10, Double(b))

        return d

    }

}

