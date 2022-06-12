import Foundation

let meters = 150354

func display_fraction(meters: Int, places: Int) -> String {
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.decimalSeparator = "."
    formatter.maximumFractionDigits = places
    formatter.minimumFractionDigits = places
    
    return formatter.string(for: Double(meters)/1000.0)!
    
}

switch meters {

    case Int.min ..< 10000:
    print(display_fraction(meters: meters, places: 2))

    case 1000 ..< 100000:
    print(display_fraction(meters: meters, places: 1))
    
    case 100000 ..< 1000000:
    print(display_fraction(meters: meters, places: 0))

    case 1000000 ... Int.max:
    print("999+")
    
}

print(Double(meters)/1000.0)
print("\()







