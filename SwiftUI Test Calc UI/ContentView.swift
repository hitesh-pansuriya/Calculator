//
//  ContentView.swift
//  SwiftUI Test Calc UI
//
//  Created by Benjamin Budzak on 8/4/22.
//

import SwiftUI
import UIKit

struct ContentView: View {

    @State var display = "0"
    @State var displayWithComa = "0"
    @State var equation = [String]()
    @State var  sign : String?
    @State var  equalToSign :String?
    @State var equalToEqu = [String]()
    let calculaterB = CalculaterBrain()
    @State private var clearButtonType = "AC"

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text(displayWithComa)
                    .font(.largeTitle)
                    .padding()
                Spacer()
                    .frame(width: 20)
                
            }
            Divider()
            HStack{
                Button {
                    if sign == "="{
                        equation.removeAll()
                        display = "0"
                        displayWithComa = "0"
                        equalToEqu = []
                        equalToSign = nil
                    }else{
                        if !displayWithComa.isEmpty{
                            displayWithComa.removeLast()
                        }
                        if !display.isEmpty {
                            display.removeLast()
                        }
                    }
                } label: {
                    Text(clearButtonType)
                        .regButtonViewModifier()
                        
                }
                Button {
                    if (display.first == "-") {
                        display.removeFirst()
                    }else{
                        display = "-" + display
                    }
                } label: {
                Text("+/-")
                    .regButtonViewModifier()

                }
                Button {
                    if let y = Double(display){
                       display = String(y / 100)
                       displayWithComa = display
                    }

                } label: {
                Text("%")
                    .regButtonViewModifier()
                }
                Button {
                    operaterPressed(ope: "/")
                } label: {
                Text("÷")
                    .orangeButtonViewModifier(active: sign == "/")
                }
            }
            
            HStack{
                Button {
                    addInDisplay(num: "7")
                } label: {
                    Text("7")
                        .regButtonViewModifier()
                }
                Button {
                    addInDisplay(num: "8")
                } label: {
                    Text("8")
                        .regButtonViewModifier()
                }
                Button {
                    addInDisplay(num: "9")
                } label: {
                    Text("9")
                        .regButtonViewModifier()
                }
                Button {
                    operaterPressed(ope: "*")
                } label: {
                    Text("x")
                        .orangeButtonViewModifier(active: sign == "*")
                }
            }
            
            HStack{
                
                Button {
                    addInDisplay(num: "4")
                } label: {
                    Text("4")
                        .regButtonViewModifier()
                }
                Button {
                    addInDisplay(num: "5")
                } label: {
                    Text("5")
                        .regButtonViewModifier()
                }
                Button {
                    addInDisplay(num: "6")
                } label: {
                    Text("6")
                        .regButtonViewModifier()
                }
                Button {
                    operaterPressed(ope: "-")
                } label: {
                    Text("-")
                        .orangeButtonViewModifier(active: sign == "-")
                }
            }
            HStack{
                Button {
                    addInDisplay(num: "1")
                } label: {
                    Text("1")
                        .regButtonViewModifier()
                }
                Button {
                    addInDisplay(num: "2")
                } label: {
                    Text("2")
                        .regButtonViewModifier()
                }
                Button {
                    addInDisplay(num: "3")
                } label: {
                    Text("3")
                        .regButtonViewModifier()
                }
                Button {
                    operaterPressed(ope: "+")
                } label: {
                    Text("+")
                        .orangeButtonViewModifier(active: sign == "+")
                }
            }
            
            HStack{
                Button {
                    addInDisplay(num: "0")
                } label: {
                    Text("0")
                        .zeroButtonViewModifier()
                }
                Button {
                    if !display.contains("."){
                        if display == "" {
                            display += "0."
                        }else{
                            display += "."
                        }
                        displayWithComa = display
                    }
                } label: {
                    Text(".")
                        .regButtonViewModifier()
                }
                Button {
                    if display != ""{
                        equation.append(display)
                    }
                    equalToPressed()
                    sign = "="
                } label: {

                    Text("=")
                        .orangeButtonViewModifier(active: false)
                }
            }
            
            Spacer()
                .frame(height: 20)
            
        }
        .ignoresSafeArea()
    }


    func addInDisplay(num: String){
        sign = num
        if display == "0"{
            display = num
            displayWithComa = display
        }else{
            guard display.count < 9 else {return}
            display += num
            if let y = Double(display){
                print(y)
                var v = String(y.withCommas())
                v.removeLast()
                displayWithComa = v

            }
        }

    }

    func operaterPressed(ope: String){
        sign = ope
        if display != ""{
            equation.append(contentsOf: [display, ope])

        }else{
            equation[equation.count-1] = ope
        }
//        if equation.count >= 3 {
//            var e = equation
//            e.removeLast()
//            displayWithComa = calculaterB.calculate(equation: e)
//        }
        display = ""
    }

    func equalToPressed(){
        print(equation)
        if equation.last == "/" || equation.last == "+" || equation.last == "-" || equation.last == "*"{
            equalToSign = equation.last
            equation.removeLast()
            equalToEqu = equation
        }
        if let x = equalToSign {
            equation.append(x)
            equation += equalToEqu
        }
        displayWithComa = calculaterB.calculate(equation: equation)

    }

}

extension String{
    var expresstion: NSExpression{
        return NSExpression(format: self)
    }
}

extension Double {

    func withCommas() -> String {

        let significantCount = String(Int(self)).count

        let minDemicalPlaces = max(9 - significantCount, 0)



        let formatter = NumberFormatter()



        // Set up the NumberFormatter to use a thousands separator

        formatter.usesGroupingSeparator = true

        formatter.groupingSize = 3



        //Set it up to always display 2 significant places.

        formatter.maximumSignificantDigits = 9



        //Set it up to always display 2 decimal places.

        formatter.alwaysShowsDecimalSeparator = true

        formatter.minimumFractionDigits = 0

        formatter.maximumFractionDigits = minDemicalPlaces



        formatter.numberStyle = .decimal



        return formatter.string(from: NSNumber(value:self))!

    }

}

extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}

struct RegButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 50, height: 50, alignment: .center)
            .padding()
            .font(.title)
            .background(.gray)
            .foregroundColor(.white)
    }
}

struct OrangeButtonModifier: ViewModifier {
    let active: Bool
    func body(content: Content) -> some View {
        content
            .frame(width: 50, height: 50, alignment: .center)
            .padding()
            .font(.title)
            .background(active ? .white : .orange)
            .foregroundColor(active ? .orange : .white)
    }
}

struct ZeroButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 140, height: 50, alignment: .center)
            .padding()
            .font(.title)
            .background(.gray)
            .foregroundColor(.white)
    }
}

extension View {
    func regButtonViewModifier() -> some View {
        modifier(RegButtonModifier())
    }
    
    func orangeButtonViewModifier(active: Bool) -> some View {
        modifier(OrangeButtonModifier(active: active))
    }
    
    func zeroButtonViewModifier() -> some View {
        modifier(ZeroButtonModifier())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
