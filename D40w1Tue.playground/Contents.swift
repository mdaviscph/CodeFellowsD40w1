//CODING CHALLENGE: FIZZ BUZZ!! :
//Print the numbers 1..100
//For multiples of 3, print "Fizz" instead of the number
//For multiples of 5, print "Buzz" instead of the number
//For multiples of 3 and 5, print "FizzBuzz" instead of the number

for number in 1...100 {
  switch number {
  case let n where n%3 == 0 && n%5 == 0:
    println("FizzBuzz")
  case let n where n%3 == 0:
    println("Fizz")
  case let n where n%5 == 0:
    println("Buzz")
  default:
    println(number)
  }
}
