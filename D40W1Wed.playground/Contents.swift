// CODING CHALLENGE: Return the number of times that the string "hi" appears anywhere in the given string.

import Foundation

let string1 = "Now is the time for all good men to come to the aid of their country"
let string2 = "Hi ho, Hi ho it is off to work we go.... hi ho, hi ho.., hi ho"
let string3 = "hi"
let string4 = ""
let string5 = "😀"

let search = "hi"

func countNumberOfTimesSearchStringAppearsIn(string: String, search: String) -> Int {
  var count = 0
  for var index = string.startIndex; index < string.endIndex; index = advance(index, 1) {
    let testString = string.substringFromIndex(index)
    if testString.hasPrefix(search) {
      count++
    }
  }
  return count
}
countNumberOfTimesSearchStringAppearsIn(string1, search)
countNumberOfTimesSearchStringAppearsIn(string2, search)
countNumberOfTimesSearchStringAppearsIn(string3, search)
countNumberOfTimesSearchStringAppearsIn(string4, search)
countNumberOfTimesSearchStringAppearsIn(string5, search)