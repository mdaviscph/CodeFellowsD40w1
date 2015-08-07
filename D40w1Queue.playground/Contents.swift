// DATA STRUCTURE THURSDAY: Implement a queue.

import Foundation

// I recently need to add stack-like functionality to an array (push() and pop()) and
// so I created an extension for that with a bit of help from stackoverflow.com and 
// so it was simple to turn the extension into enqueue() and dequeue() for a queue
extension Array {
  mutating func enqueue(item: (T)) {
    self.append(item)
  }
  mutating func dequeue() -> T? {
    return self.isEmpty ? nil : self.removeAtIndex(0)
  }
}

var array = [Int]()
for var i = 0; i < 10; i++ {
  array.enqueue(i)
}
array
array.count
for var i = 0; i < 5; i++ {
  if let item = array.dequeue() {
    let integer: Int = item         // to test type-retention
  }
}
array
array.count

// to do this without an extension and generics would require a different effort
// one way is using an array of AnyObject. I don't really like this method as
// it relies on user to only put the same type of values in the queue to be "safe"
struct QueueAnyObject {
  private var items = [AnyObject]()
  var isEmpty: Bool { return items.isEmpty }
  var count: Int { return items.count }
  mutating func enqueue(item: AnyObject) {
    items.append(item)
  }
  mutating func dequeue() -> AnyObject? {
    return items.isEmpty ? nil : items.removeAtIndex(0)
  }
}

var integerQueue = QueueAnyObject()
for var i = 0; i < 10; i++ {
  integerQueue.enqueue(i)
}
integerQueue
integerQueue.count
for var i = 0; i < 5; i++ {
  let integer = integerQueue.dequeue() as! Int    // to test type-retention using downcast
}
integerQueue
integerQueue.count

// otherwise I believe that you will need to implement a queue for each data type
// for example:
struct IntQueue {
  private var items = [Int]()
  var isEmpty: Bool { return items.isEmpty }
  var count: Int { return items.count }
  mutating func enqueue(item: Int) {
    items.append(item)
  }
  mutating func dequeue() -> Int? {
    return items.isEmpty ? nil : items.removeAtIndex(0)
  }
}

var intQueue = IntQueue()
for var i = 0; i < 10; i++ {
  intQueue.enqueue(i)
}
intQueue
intQueue.count
for var i = 0; i < 5; i++ {
  let integer = intQueue.dequeue()
}
intQueue
intQueue.count

