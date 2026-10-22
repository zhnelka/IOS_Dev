// =============================================================
//  Station ALMA-7, Part III: The Repair Fleet
//  iOS Mobile Development · Module 5 · Lab Assignment
//
//  Rules:
//   • Do NOT modify the STARTER DATA section. LegacyBeacon in
//     particular must be reached with an extension, not edited.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • The Health Rule must exist in exactly ONE place in this file.
// =============================================================


// MARK: - =================== STARTER DATA ===================
// MARK: - Do not modify anything in this section

/// Drone records recovered from the fleet registry.
/// One `kind` does not correspond to any drone type you will build.
let fleetData: [(kind: String, id: String, charge: Int)] = [
    (kind: "welder",  id: "W-1", charge: 80),
    (kind: "scanner", id: "S-1", charge: 45),
    (kind: "cargo",   id: "C-1", charge: 100),
    (kind: "welder",  id: "W-2", charge: 15),
    (kind: "scanner", id: "S-2", charge: 60),
    (kind: "tug",     id: "T-1", charge: 50)
]

/// Hull sensors. These are NOT drones — they never move and never work a shift.
let sensorData: [(id: String, charge: Int)] = [
    (id: "hull-cam", charge: 12),
    (id: "thermal",  charge: 77)
]

/// Hardware from the original station. You may not add anything to this
/// declaration — no methods, no protocols, no properties.
struct LegacyBeacon {
    let name: String
    let signalStrength: Int
}

let beacon = LegacyBeacon(name: "ALMA-BEACON", signalStrength: 8)

print("Fleet registry online: \(fleetData.count) drone records, \(sensorData.count) sensors, beacon \(beacon.name).")

// MARK: - ================= END OF STARTER DATA =================


// MARK: - =================== YOUR SOLUTION ===================


// MARK: Level 1 · The Power Cell

// Why a class and not a struct here?  ->
// A battery is one physical object that the drone (and anyone else holding it)
// must share and drain together, so it needs reference semantics and identity.
final class PowerCell {
    private var charge: Int

    // Clamps the starting value into 0...100.
    init(charge: Int) {
        self.charge = min(max(charge, 0), 100)
    }

    // Read-only access.
    func level() -> Int {
        return charge
    }

    // Returns false and changes nothing for non-positive amounts or insufficient charge.
    func spend(_ amount: Int) -> Bool {
        if amount <= 0 || amount > charge {
            return false
        }
        charge -= amount
        return true
    }

    // Ignores non-positive amounts, never exceeds 100.
    func recharge(by amount: Int) {
        if amount <= 0 {
            return
        }
        charge = min(charge + amount, 100)
    }
}

// Encapsulation proof (left commented, with the compiler error):
// cell.charge = 100
// error: 'charge' is inaccessible due to 'private' protection level

print("\n--- Level 1: PowerCell ---")
let testCell = PowerCell(charge: 150)
print("Start (150 clamped): \(testCell.level())")
print("Spend 30: \(testCell.spend(30)), level \(testCell.level())")
print("Spend 500: \(testCell.spend(500)), level \(testCell.level())")
print("Spend -5: \(testCell.spend(-5)), level \(testCell.level())")
testCell.recharge(by: 200)
print("Recharge 200: level \(testCell.level())")
testCell.recharge(by: -10)
print("Recharge -10: level \(testCell.level())")


// MARK: Level 5.3 (placed early because statusLine uses it)

extension Int {
    var powerBar: String {
        let filled = Swift.min(Swift.max(self / 10, 0), 10)
        var bar = ""
        for _ in 0..<filled {
            bar += "#"
        }
        for _ in 0..<(10 - filled) {
            bar += "."
        }
        return bar
    }
}


// MARK: Level 4.1 / 5.1 · Diagnosable and the single Health Rule

protocol Diagnosable {
    var componentID: String { get }
    var statusCode: Int { get }
    func diagnose() -> String
}

extension Diagnosable {
   
    func diagnose() -> String {
        return "\(componentID): code \(statusCode)"
    }

    func healthCode(forLevel level: Int) -> Int {
        if level < 20 {
            return 2
        } else if level < 50 {
            return 1
        } else {
            return 0
        }
    }
}

protocol Rechargeable {
    mutating func recharge(by amount: Int)
}


// MARK: Level 2 · The Fleet

// 2.1

class Drone {
    let id: String
    let cell: PowerCell

    init(id: String, cell: PowerCell) {
        self.id = id
        self.cell = cell
    }

    var powerCost: Int { 10 }

    var statusLine: String {
        return "\(id): \(cell.level())% \(cell.level().powerBar)"
    }

    func performTask() -> Int { 0 }
    final func runOnce() -> Int {
        if !cell.spend(powerCost) {
            return 0
        }
        return performTask()
    }
}

// 2.2
final class WelderDrone: Drone {
    override var powerCost: Int { 25 }
    override func performTask() -> Int { 40 }

    func weldSeam() -> String {
        return "\(id) welded a seam"
    }
}

class ScannerDrone: Drone {
    override var powerCost: Int { 10 }
    override func performTask() -> Int { 15 }


    override var statusLine: String {
        return super.statusLine + " [scanner]"
    }
}

final class CargoDrone: Drone {
    override var powerCost: Int { 20 }
    override func performTask() -> Int { 25 }
}

// 2.3
func makeDrone(kind: String, id: String, charge: Int) -> Drone? {
    let cell = PowerCell(charge: charge)
    switch kind {
    case "welder":  return WelderDrone(id: id, cell: cell)
    case "scanner": return ScannerDrone(id: id, cell: cell)
    case "cargo":   return CargoDrone(id: id, cell: cell)
    default:        return nil
    }
}

print("\n--- Level 2: Fleet ---")
var fleet: [Drone] = []
for record in fleetData {
    if let drone = makeDrone(kind: record.kind, id: record.id, charge: record.charge) {
        fleet.append(drone)
    } else {
        print("WARNING: unknown drone kind '\(record.kind)' (id \(record.id)) skipped.")
    }
}
for drone in fleet {
    print(drone.statusLine)
}


// MARK: Level 4.2 · Drone conformances


extension Drone: Diagnosable, Rechargeable {
    var componentID: String { id }
    var statusCode: Int { healthCode(forLevel: cell.level()) }

    func recharge(by amount: Int) {
        cell.recharge(by: amount)
    }
}

struct SensorModule: Diagnosable, Rechargeable {
    let id: String
    var chargeLevel: Int

    var componentID: String { id }
    var statusCode: Int { healthCode(forLevel: chargeLevel) }

  
    mutating func recharge(by amount: Int) {
        if amount <= 0 {
            return
        }
        chargeLevel = min(chargeLevel + amount, 100)
    }
}

func buildSensors() -> [SensorModule] {
    var result: [SensorModule] = []
    for record in sensorData {
        result.append(SensorModule(id: record.id, chargeLevel: record.charge))
    }
    return result
}


// MARK: Level 3 · The Shift

func runShift(_ fleet: [Drone], rounds: Int) -> Int {
    var total = 0
    for _ in 0..<max(rounds, 0) {
        for drone in fleet {
            total += drone.runOnce()
        }
    }
    return total
}

print("\n--- Level 3: Shift ---")
let A = runShift(fleet, rounds: 3)
print("Total work units: \(A)")
for drone in fleet {
    print(drone.statusLine)
}

var chargeSum = 0
var stillReady = 0
for drone in fleet {
    chargeSum += drone.cell.level()
    if drone.cell.level() >= drone.powerCost {
        stillReady += 1
    }
}
print("Drones able to run one more task: \(stillReady)")

let B = chargeSum
let C = stillReady


// MARK: Level 4.3 · The diagnostics screen


func diagnosticsReport(components: [Diagnosable]) -> String {
    var lines: [String] = []
    for component in components {
        lines.append(component.diagnose())
    }
    return lines.joined(separator: "\n")
}

print("\n--- Level 4.3: Diagnostics screen ---")
let sensors = buildSensors()
var components: [Diagnosable] = []
for drone in fleet {
    components.append(drone)
}
for sensor in sensors {
    components.append(sensor)
}
print(diagnosticsReport(components: components))


var spareSensor = SensorModule(id: "spare", chargeLevel: 90)
spareSensor.recharge(by: 25)
print("Spare sensor after recharge: \(spareSensor.chargeLevel)")
let spareDrone = WelderDrone(id: "W-spare", cell: PowerCell(charge: 10))
spareDrone.recharge(by: 30)
print("Spare drone after recharge: \(spareDrone.cell.level())")


// MARK: Level 5.2 · The beacon you can't edit

extension LegacyBeacon: Diagnosable {
    var componentID: String { name }
    var statusCode: Int { healthCode(forLevel: signalStrength) }

   
    func diagnose() -> String {
        return "*** LEGACY HARDWARE *** \(name): signal \(signalStrength), code \(statusCode)"
    }
}

print("\n--- Level 5.2: Diagnostics with beacon ---")
components.append(beacon)
print(diagnosticsReport(components: components))

var codeSum = 0
for component in components {
    codeSum += component.statusCode
}
let D = codeSum

print("\n--- Level 5.3: powerBar ---")
print("42 -> \(42.powerBar)")
print("-5 -> \((-5).powerBar)")
print("250 -> \(250.powerBar)")


// MARK: Level 6 · Incident Reports
// NOTE: the brief says "two don't compile, two compile and lie", but Reports 1, 2
// and 3 do not compile, and only Report 4 compiles and lies.

/*
 Report 1
   class PatchDrone: Drone { func performTask() -> Int { return 30 } }
   Expected: a drone that does 30 units of work.
   Actual:   COMPILE ERROR: "overriding declaration requires an 'override' keyword".
   Rule:     overriding an inherited member must be stated explicitly with
             `override`, so accidental overrides are caught.
   Fix:      override func performTask() -> Int { return 30 }

 Report 2
   final class HeavyWelder: WelderDrone { override func runOnce() -> Int { 999 } }
   Expected: a welder that reports 999.
   Actual:   COMPILE ERROR: "inheritance from a final class 'WelderDrone'", and
             also "instance method overrides a 'final' instance method".
   Rule:     `final` forbids subclassing (on a class) or overriding (on a member).
             runOnce() is final so the shift ritual cannot be bypassed.
   Fix:      remove `final` from WelderDrone if subclassing is truly wanted and
             override the allowed hook instead:
                 class WelderDrone: Drone { ... }
                 final class HeavyWelder: WelderDrone {
                     override func performTask() -> Int { return 999 }
                 }

 Report 3
   let first = reportFleet[0]; print(first.weldSeam())
   Expected: prints the weld message.
   Actual:   COMPILE ERROR: "value of type 'Drone' has no member 'weldSeam'".
   Rule:     the compiler checks against the STATIC type (Drone), not the
             runtime type (WelderDrone). Subclass members are not visible.
   Fix:      if let welder = first as? WelderDrone { print(welder.weldSeam()) }
             `as?` returns an optional because the cast can fail at runtime
             (the element might be a ScannerDrone), and nil expresses that.

 Report 4
   Expected: "thruster T-1".   Actual: prints "generic component".
   Rule:     label() is NOT a protocol requirement, it exists only in the
             extension. Calls on a value whose type is the protocol (Labelled)
             are dispatched statically to the extension's version; the struct's
             own label() is not part of the protocol's witness table.
   Fix:      add the method to the protocol so it is a requirement:
                 protocol Labelled {
                     var componentID: String { get }
                     func label() -> String
                 }
             Now the call is dynamically dispatched and prints "thruster T-1".
*/

print("\n--- Level 6: live demos of the fixes ---")
let reportFleet: [Drone] = [WelderDrone(id: "W-9", cell: PowerCell(charge: 100))]
let first = reportFleet[0]
if let welder = first as? WelderDrone {
    print(welder.weldSeam())
}


protocol Labelled {
    var componentID: String { get }
}
extension Labelled {
    func label() -> String { "generic component" }
}
struct Thruster: Labelled {
    let componentID: String
    func label() -> String { "thruster \(componentID)" }
}
let parts: [Labelled] = [Thruster(componentID: "T-1")]
print("Report 4 broken:  \(parts[0].label())")

protocol LabelledFixed {
    var componentID: String { get }
    func label() -> String
}
extension LabelledFixed {
    func label() -> String { "generic component" }
}
struct ThrusterFixed: LabelledFixed {
    let componentID: String
    func label() -> String { "thruster \(componentID)" }
}
let partsFixed: [LabelledFixed] = [ThrusterFixed(componentID: "T-1")]
print("Report 4 fixed:   \(partsFixed[0].label())")


// MARK: Finale · Mission Code

let missionCode = "\(A)-\(B)-\(C)-\(D)"
print("\nMISSION CODE: \(missionCode)")
// Expected: 285-105-3-12


// MARK: Bonus

print("\n--- Bonus ---")

// 1a. Fails at RUNTIME: a precondition in the base initialiser.
class StrictDrone {
    init() {
        precondition(type(of: self) != StrictDrone.self, "StrictDrone is abstract: subclass it")
    }
}
class RealStrictDrone: StrictDrone {}
// let broken = StrictDrone()   // crashes at runtime with the message above
let okStrict = RealStrictDrone()
print("Subclass of StrictDrone created: \(type(of: okStrict))")
// (Another runtime way: `fatalError("override me")` inside performTask().)

// 1b. Fails at COMPILE time: make the base type a protocol; you cannot instantiate
// a protocol, and the compiler enforces every required member (see below).

// 2. Protocol-based redesign with structs.
protocol Worker {
    var id: String { get }
    var cell: PowerCell { get }
    var powerCost: Int { get }
    func performTask() -> Int
}

extension Worker {
    func runOnce() -> Int {
        if !cell.spend(powerCost) {
            return 0
        }
        return performTask()
    }
}

struct WelderWorker: Worker {
    let id: String
    let cell: PowerCell
    var powerCost: Int { 25 }
    func performTask() -> Int { 40 }
}

struct ScannerWorker: Worker {
    let id: String
    let cell: PowerCell
    var powerCost: Int { 10 }
    func performTask() -> Int { 15 }
}

// let bad = Worker()   // error: protocol 'Worker' cannot be instantiated
let workers: [Worker] = [
    WelderWorker(id: "WW-1", cell: PowerCell(charge: 80)),
    ScannerWorker(id: "SW-1", cell: PowerCell(charge: 45))
]
var workerTotal = 0
for worker in workers {
    workerTotal += worker.runOnce()
}
print("Protocol-based fleet produced \(workerTotal) units")   // 40 + 15 = 55

// 3. Comparison:
// The class design gives real shared stored state and a fixed ritual (final) in one
// place, but allows a meaningless bare Drone and ties everything to one superclass.
// The protocol design cannot be instantiated abstractly, works for structs and
// classes alike, and is checked at compile time. For this station I would pick the
// protocol design; if drones had to share mutable state, I would keep that state in
// a class (like PowerCell) or switch the drones back to classes, because structs copy.


// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. Drone satisfies `mutating func recharge(by:)` without writing mutating, and
    SensorModule cannot. Explain.
    `mutating` means "this method may replace self", which only makes sense for
    value types: a struct method gets a copy of self, so mutating tells Swift to
    write the modified value back into the caller's variable. A class method works
    on a reference; changing properties never changes the reference itself, so the
    class implementation needs no keyword (and `mutating` is not allowed on class
    methods). A class therefore satisfies the requirement as a normal method.
    SensorModule is a struct, so changing chargeLevel in recharge(by:) requires it.

 2. One thing inheritance does that a protocol cannot, and vice versa.
    Inheritance: a subclass inherits stored properties and real implementations
    (Drone's id, cell and the final runOnce() ritual, plus super calls) and can
    call super.statusLine. Protocols cannot hold stored state.
    Protocol: unrelated types (a class Drone, a struct SensorModule, and the
    untouchable LegacyBeacon added through an extension) can all conform and live
    in one [Diagnosable] array. Inheritance cannot unite structs or retrofit an
    existing type, and a class can only have one superclass.

 3. What exactly does final prevent, and what did it protect in runOnce()?
    `final` forbids overriding a member (or subclassing a class). On runOnce() it
    guarantees no subclass can skip the spend step or change the order, so a
    drone could never do work without paying power or drive the charge negative.
    Subclasses can only customise powerCost and performTask().

 4. In Report 4, why did the protocol extension's method win over the struct's own?
    label() was not a protocol requirement, so it is not in the protocol's
    witness table. When the variable's static type is the protocol (Labelled),
    Swift dispatches a non-requirement extension method statically, i.e. it uses
    the extension's version at compile time. Adding `func label() -> String` to
    the protocol makes it a requirement, so dynamic dispatch calls the struct's
    implementation.
*/
