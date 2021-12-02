import UIKit

struct Email {
  let address: String
  
  init?(raw: String) {
    guard Email.valid(email: raw) else { return nil }
    address = raw
  }
  
  init(_ email: StaticString) {
    let checked = String(describing: email)
    precondition(Email.valid(email: checked), "Invalid email")
    address = checked
  }
  
  static func valid(email : String) -> Bool {
    let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
    let range = NSRange(location: 0, length: email.count)
    return regex.firstMatch(in: email, options: [], range:range) != nil
  }
}

let validEmail = Email(raw: "adam@ahrens.com")
let invalidemail = Email(raw: "badal.s.dsf.sdf.sdf.dss.df.sdf?????")

Email("adam@ahrens.com")

//Email("thasdkfjsdl..sd.d.fs.fs.f.s") // This cause an error to throw

enum MathError: Error {
  case divisionByZero
}


func divide(numerator: Double, denominator: Double) throws -> Double {
  if abs(denominator) < Double.ulpOfOne { throw MathError.divisionByZero}
  return numerator / denominator
}

print(try divide(numerator: 10, denominator: 2))
print(try? divide(numerator: 10, denominator: 0))


enum PlainError: Int, Error {
  case boom = 100
  case bam
}

enum DetailedError: Error {
  case milkHasGoneBad(String)
}

do {
//  throw PlainError.boom
  
  throw DetailedError.milkHasGoneBad("Better get more")
} catch (let error as PlainError) {
  print(error)
} catch DetailedError.milkHasGoneBad(let message) {
  print(message)
}


func division(numerator: Double, denominator: Double) -> Result<Double, MathError> {
  guard abs(denominator) > Double.ulpOfOne else { return .failure(MathError.divisionByZero) }
  return .success(numerator/denominator)
}

let failureResult = division(numerator: 10, denominator: 0)
let successResult = division(numerator: 10, denominator: 2)
