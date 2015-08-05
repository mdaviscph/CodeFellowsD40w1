// CODING CHALLENGE: Write a function that reverses an array
// 08-04-15

let array = [1,2,3,4,5,6]
let reversedArray = array.reverse()

// fastest method - doesn't have to adjust cells for each iteration, but possible out of bounds
func reverseArray(array: [Int]) -> [Int] {
  var result = [Int]()
  for var i = array.count - 1; i >= 0; i-- {
    result.append(array[i])
  }
  return result
}
array
reverseArray(array)

// most simple and safe version
func reverseArray2(array: [Int]) -> [Int] {
  var result = [Int]()
  for value in array {
    result.insert(value, atIndex: 0)
  }
  return result
}
array
reverseArray2(array)

// in-place version; sometimes an interview question; also possible out of bounds
func reverseArray3(inout array: [Int]) {
  for var i = 0, j = array.count - 1; i < j; i++, j-- {
    swap(&array[i], &array[j])
  }
}
var varArray = [1,2,3,4,5,6]
reverseArray3(&varArray)
varArray
