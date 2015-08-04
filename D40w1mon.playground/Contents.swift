// CODING CHALLENGE: Write a function that reverses an array

let array = [1,2,3,4,5,6]
let reversedArray = array.reverse()

func reverseArray(array: [Int]) -> [Int] {
  var result = [Int]()
  for var i = array.count - 1; i >= 0; i-- {
    result.append(array[i])
  }
  return result
}
reversedArray(array)
