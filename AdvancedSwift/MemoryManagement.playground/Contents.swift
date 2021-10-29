import UIKit

class CelestialBody {
  var name: String
  
  init(_ name: String) {
    self.name = name
    print("☀️ init \(name)")
  }
  
  deinit {
    print("❌ deinit \(name)")
  }
}

class Employee {
  
  // Fix by making manager weak
  weak var manager: Employee?
  var reports = [Employee]()
}

let adam = Employee()
adam.reports = [Employee(), Employee(), Employee()]

// Created a retain cycle. Nothing ever gets released
adam.reports.forEach { $0.manager = adam }



do {
  CelestialBody("Fairmount")
}

class Planet: CelestialBody {
  weak var system: Star?
}

class Star: CelestialBody {
  var planets = [Planet]()
  
  init(_ name: String, planets: [Planet]) {
    self.planets = planets
    super.init(name)
    
    /// Leaking Memory
    planets.forEach { $0.system = self }
  }
}


do {
  let names = ["Mercury", "Venus", "Earth", "Mars", "Jupiter", "Neptune"]
  let planets = names.map(Planet.init)
  let sun = Star("Sun", planets: planets)
  print(sun.name, "is alive!")
  // Was leaking before.
}


print("------ Unowned ------")
