//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
print(str)

var myVariable = 12
myVariable = 14

let constant = 12
let string = "hello"
let result = string + String(constant)
let interpolacion = "the value of the var is \(constant + 1)"

var optional1 = Optional("String Option")
print (optional1)
var optional2:String? = "test"
print (optional2)


// get value of optional
var valueOption1 = optional1!
print(valueOption1)


var strinBanana = "Banana"
var bananaInt = Int(strinBanana)
print(bananaInt)

var stringInt = "12"
var integert = Int(stringInt)
print(integert)


//Arrays

var array = ["1","2","3"]
print(array[0])
for element in array{
    print (element)
}

//Functions

func greet (name:String , age: Int) -> String{
    return "The name is \(name) age \(age)"
    
}
var stringGreet = greet(name:"jhonny", age:12)


//Method
func greetMethod(name:String, age: String){
    print("The name is \(name) age \(age)")
}
greetMethod(name: "Jhonn", age: "25")

class Shape{
    var x=0
    //Constructor Method
    init(){
        self.x = 12
    }
    
    init(x:Int){
        self.x = x
    }
    
    func getX()->Int{
        return self.x
    }
    func setX(newX:Int){
        self.x = newX
    }
}

var objShape = Shape(x:15)
print(objShape.x)
objShape.setX(newX: 13)
print(objShape.getX())

//Herencia
class Square:Shape{
    var y = 0
    init(x:Int, y:Int){
        super.init(x: x)
        self.y = y
    }
    
    func getY() -> Int{
        return self.y
    }
    
    func setY(newY: Int){
        self.y = newY
    }
}

var shape = Square(x:12, y:12)

//protocols/ interfaces /


protocol Printable {
    func printSheet()
}

class Print{
    
    func print(printable:Printable){
        printable.printSheet()
    }
}

class A4Sheet: Printable{
    var hight = 12
    init(hight:Int){
        self.hight = hight
    }
    func printSheet(){
        print("print A4 sheet")
    }
}

class a7Sheet: Printable{
    func printSheet() {
        print("Print A7 Sheet")
    }
}


var printer = Print()
var a4Sheet = A4Sheet(hight:12)
var A7Sheet = a7Sheet()

printer.print(printable: a4Sheet)
printer.print(printable: A7Sheet)

