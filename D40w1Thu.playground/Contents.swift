// CODING CHALLENGE: Given a string, return a version where all the "x" have been removed. Except an "x" at the very start or end should not be removed.

import Foundation

let string1 = "xuetwoiejxhaejihxjaewsfx"
let string2 = "x"
let string3 = "xx"
let string4 = "xox"
let string5 = "xxx"
let string6 = "xo"
let string7 = "ox"
let string8 = "xxxxxxxxxxxxxxxx"
let string9 = ""

extension String {
  func removeAllInternalOccurrencesOfString(ofString: String) -> String {
    if count(self) < 3 { return self }
    let hasPrefix = self.hasPrefix(ofString)
    let hasSuffix = self.hasSuffix(ofString)
    return (hasPrefix ? ofString:"") + self.stringByReplacingOccurrencesOfString(ofString, withString: "") + (hasSuffix ? ofString:"")
  }
}

string1.removeAllInternalOccurrencesOfString("x")
string2.removeAllInternalOccurrencesOfString("x")
string3.removeAllInternalOccurrencesOfString("x")
string4.removeAllInternalOccurrencesOfString("x")
string5.removeAllInternalOccurrencesOfString("x")
string6.removeAllInternalOccurrencesOfString("x")
string7.removeAllInternalOccurrencesOfString("x")
string8.removeAllInternalOccurrencesOfString("x")
string9.removeAllInternalOccurrencesOfString("x")



// another method without using String.stringByReplacingOccurrencesOfString and extension
// use of switch statement is questionable as it would be less code to just test for first
// and last character in string but I wanted to try out the value binding with "where" clause
func removeAllInternalOccurrencesOfString2(string: String, ofCharacter: Character) -> String {
  var result = String()
  let lastIndex = count(string) - 1
  for (index, character) in enumerate(string) {
    switch index {
    case 0, lastIndex:
      result.append(character)
    case let x where character == ofCharacter:
      break
    default:
      result.append(character)
    }
  }
  return result
}

removeAllInternalOccurrencesOfString2(string1, "x")
removeAllInternalOccurrencesOfString2(string2, "x")
removeAllInternalOccurrencesOfString2(string3, "x")
removeAllInternalOccurrencesOfString2(string4, "x")
removeAllInternalOccurrencesOfString2(string5, "x")
removeAllInternalOccurrencesOfString2(string6, "x")
removeAllInternalOccurrencesOfString2(string7, "x")
removeAllInternalOccurrencesOfString2(string8, "x")
removeAllInternalOccurrencesOfString2(string9, "x")

