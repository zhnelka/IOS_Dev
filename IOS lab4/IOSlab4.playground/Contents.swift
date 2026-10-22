// =============================================================
//  Station ALMA-7, Part II: The Teleporter Incident
//  iOS Mobile Development · Module 4 · Lab Assignment
//
//  Rules:
//   • Do NOT modify the STARTER DATA section.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • Default to struct. Use class only where the task says so.
// =============================================================


// MARK: - =================== STARTER DATA ===================
// MARK: - Do not modify anything in this section

/// Splits a line into fields.
/// fields("crate:101:120")            -> ["crate", "101", "120"]
/// fields("livestock:lab mice:12:2")  -> ["livestock", "lab mice", "12", "2"]
/// fields("junk")                     -> ["junk"]
func fields(_ line: String, separatedBy separator: Character = ":") -> [String] {
    var result: [String] = []
    var current = ""
    for character in line {
        if character == separator {
            result.append(current)
            current = ""
        } else {
            current.append(character)
        }
    }
    result.append(current)
    return result
}

/// Cargo manifest as recovered from the damaged recorder.
let rawManifest = [
    "crate:101:120",
    "container:KZ-ALM-7:340",
    "livestock:lab mice:12:2",
    "???-corrupted-line",
    "crate:102:75",
    "container:KZ-ALM-9:410",
    "livestock:ficus:3:5",
    "crate:103:260",
    "crate:104:abc",
    ""
]

/// Oxygen readings. One of these deck names is not a real deck.
let deckReadings: [(deck: String, oxygen: Int)] = [
    (deck: "bridge",     oxygen: 78),
    (deck: "lab",        oxygen: 64),
    (deck: "greenhouse", oxygen: 55),
    (deck: "cargo",      oxygen: 12),
    (deck: "medbay",     oxygen: 90),
    (deck: "engine",     oxygen: 41)
]

/// Crew records, straight from the personnel file.
let crewData: [(name: String, deck: String, oxygen: Int)] = [
    (name: "Timur",   deck: "engine", oxygen: 62),
    (name: "Dana",    deck: "lab",    oxygen: 48),
    (name: "Aigerim", deck: "bridge", oxygen: 91),
    (name: "Nurlan",  deck: "cargo",  oxygen: 17)
]

print("ALMA-7 recorder online: \(rawManifest.count) manifest lines, \(deckReadings.count) readings, \(crewData.count) crew records.")

// MARK: - ================= END OF STARTER DATA =================


// MARK: - =================== YOUR SOLUTION ===================


// MARK: Level 1 · The Deck Register

// 1.1
// Raw values are assigned by Swift: "bridge", "lab", "cargo", "medbay", "engine".
enum Deck: String, CaseIterable {
    case bridge, lab, cargo, medbay, engine

    
    var evacuationPriority: Int {
        switch self {
        case .bridge: return 1
        case .medbay: return 2
        case .lab:    return 3
        case .engine: return 4
        case .cargo:  return 5
        }
    }
}

print("\n--- Level 1.1: Decks ---")
for deck in Deck.allCases {
    print("\(deck) (raw: \(deck.rawValue)) -> evacuation priority \(deck.evacuationPriority)")
}

// 1.2

enum AlarmLevel: Int {
    case green = 0
    case yellow, orange, red

    static func level(forTotalMass mass: Int) -> AlarmLevel {
       
        let steps = min(max(mass / 500, 0), 3)
        return AlarmLevel(rawValue: steps) ?? .red
    }
}

print("\n--- Level 1.2: AlarmLevel ---")
print("0 kg    -> \(AlarmLevel.level(forTotalMass: 0))")
print("940 kg  -> \(AlarmLevel.level(forTotalMass: 940))")
print("4000 kg -> \(AlarmLevel.level(forTotalMass: 4000))")


// MARK: Level 2 · The Manifest

// 2.1
enum ManifestEntry {
    case crate(id: Int, massKg: Int)
    case container(code: String, massKg: Int)
    case livestock(species: String, count: Int, massPerUnitKg: Int)
    case unknown(raw: String)
}

// 2.2

func parseEntry(_ line: String) -> ManifestEntry {
    let parts = fields(line)
    guard let tag = parts.first else {
        return .unknown(raw: line)
    }

    if tag == "crate", parts.count == 3,
       let id = Int(parts[1]), let massKg = Int(parts[2]) {
        return .crate(id: id, massKg: massKg)
    }
    if tag == "container", parts.count == 3,
       let massKg = Int(parts[2]) {
        return .container(code: parts[1], massKg: massKg)
    }
    if tag == "livestock", parts.count == 4,
       let count = Int(parts[2]), let perUnit = Int(parts[3]) {
        return .livestock(species: parts[1], count: count, massPerUnitKg: perUnit)
    }
    return .unknown(raw: line)
}

// 2.3
func mass(of entry: ManifestEntry) -> Int {
    switch entry {
    case .crate(_, let massKg):
        return massKg
    case .container(_, let massKg):
        return massKg
    case .livestock(_, let count, let massPerUnitKg):
        return count * massPerUnitKg
    case .unknown:
        return 0
    }
}

print("\n--- Level 2: Manifest ---")
var totalMass = 0
var unknownCount = 0
for line in rawManifest {
    let entry = parseEntry(line)
    let m = mass(of: entry)
    totalMass += m
    if case .unknown = entry {
        unknownCount += 1
    }
    print("\"\(line)\" -> \(entry) (\(m) kg)")
}
print("Total manifest mass: \(totalMass) kg")
print("Unknown lines: \(unknownCount)")

let A = totalMass


// MARK: Level 3 · Crew Snapshots

// 3.1
struct CrewSnapshot {
    let name: String
    var deck: Deck
    var oxygen: Int

   
    mutating func breathe(amount: Int) {
        oxygen = max(0, oxygen - amount)
    }

    mutating func move(to deck: Deck) {
        self.deck = deck
    }

   
    mutating func reviveInMedbay() {
        self = CrewSnapshot(name: name, deck: .medbay, oxygen: 100)
    }

    static func rookie(named name: String) -> CrewSnapshot {
        return CrewSnapshot(name: name, deck: .bridge, oxygen: 100)
    }
}

// 3.2
func buildRoster() -> [CrewSnapshot] {
    var roster: [CrewSnapshot] = []
    for record in crewData {
        if let deck = Deck(rawValue: record.deck) {
            roster.append(CrewSnapshot(name: record.name, deck: deck, oxygen: record.oxygen))
        } else {
            print("WARNING: \(record.name) names unknown deck '\(record.deck)', skipped.")
        }
    }
    return roster
}

print("\n--- Level 3.2: Roster ---")
let crewRoster: [CrewSnapshot] = buildRoster()
for member in crewRoster {
    print(member)
}


func findCrew(named name: String) -> CrewSnapshot? {
    for member in crewRoster {
        if member.name == name {
            return member
        }
    }
    return nil
}

// 3.3 · Value-semantics demonstration
func drainOnCopy(_ snapshot: CrewSnapshot) {
    
    var local = snapshot
    local.breathe(amount: 30)
    print("   inside plain function: local copy oxygen = \(local.oxygen)")
}

func drainInPlace(_ snapshot: inout CrewSnapshot) {
    snapshot.breathe(amount: 30)
    print("   inside inout function: oxygen = \(snapshot.oxygen)")
}

print("\n--- Level 3.3: Value semantics ---")
let sample = CrewSnapshot(name: "Sample", deck: .lab, oxygen: 80)

// 1. Copy
var copyOfSample = sample
print("1. BEFORE copy change -> original: \(sample.oxygen), copy: \(copyOfSample.oxygen)")
copyOfSample.breathe(amount: 50)
copyOfSample.move(to: .engine)
print("1. AFTER  copy change -> original: \(sample.oxygen) on \(sample.deck), copy: \(copyOfSample.oxygen) on \(copyOfSample.deck)")

// 2. Plain function
var subject2 = CrewSnapshot(name: "Plain", deck: .lab, oxygen: 80)
print("2. BEFORE plain function -> original: \(subject2.oxygen)")
drainOnCopy(subject2)
print("2. AFTER  plain function -> original: \(subject2.oxygen)  (unchanged)")

// 3. inout
print("3. BEFORE inout function -> original: \(subject2.oxygen)")
drainInPlace(&subject2)
print("3. AFTER  inout function -> original: \(subject2.oxygen)  (changed)")

// Extra: exercising reviveInMedbay and rookie too
var reviveDemo = CrewSnapshot.rookie(named: "Revive")
reviveDemo.breathe(amount: 95)
print("Before revive: \(reviveDemo)")
reviveDemo.reviveInMedbay()
print("After revive:  \(reviveDemo)")


// MARK: Level 4 · The Teleport Pod

// 4.1

final class TeleportPod {
    let id: String
    var chargeLevel: Int
    var occupant: CrewSnapshot?

   
    init(id: String, chargeLevel: Int) {
        self.id = id
        self.chargeLevel = chargeLevel
        self.occupant = nil
    }

    func load(_ crew: CrewSnapshot) -> Bool {
        if occupant != nil {
            return false
        }
        occupant = crew
        return true
    }

   
    func fire() -> CrewSnapshot? {
        guard let passenger = occupant, chargeLevel >= 20 else {
            return nil
        }
        chargeLevel -= 20
        occupant = nil
        return passenger
    }

    // Bonus 1: deinitializer
    deinit {
        print("   [deinit] pod \(id) destroyed")
    }
}

// 4.2 · Charge ledger
print("\n--- Level 4.2: Charge ledger ---")
let pod1 = TeleportPod(id: "P-1", chargeLevel: 100)
print("Start: charge = \(pod1.chargeLevel)")

let ledgerNames = ["Timur", "Dana", "Nurlan"]
for name in ledgerNames {
    if let crew = findCrew(named: name) {
        let loaded = pod1.load(crew)
        let fired = pod1.fire()
        let who = fired?.name ?? "nobody"
        print("Load \(name): \(loaded), fired: \(who), charge = \(pod1.chargeLevel)")
    }
}

let emptyShot = pod1.fire()
print("Fire empty pod: \(emptyShot == nil ? "nil (nothing sent)" : "unexpected"), charge = \(pod1.chargeLevel)")

let C = pod1.chargeLevel

// 4.3 · Reference-semantics demonstration
print("\n--- Level 4.3: Reference semantics ---")
let podAlias = pod1
print("Before: pod1 = \(pod1.chargeLevel), podAlias = \(podAlias.chargeLevel)")
podAlias.chargeLevel = 5
print("After changing via podAlias: pod1 = \(pod1.chargeLevel), podAlias = \(podAlias.chargeLevel)")

let snapA = CrewSnapshot.rookie(named: "Timur")
var snapB = snapA
print("Before: snapA = \(snapA.oxygen), snapB = \(snapB.oxygen)")
snapB.oxygen = 5
print("After changing snapB: snapA = \(snapA.oxygen), snapB = \(snapB.oxygen)")
// Rule: assigning a class instance copies the reference (both names share one object),
// while assigning a struct copies the value (each name gets its own independent data).


// MARK: Level 5 · Station Systems

// 5.1

final class Station {
    let callSign: String

    var hullIntegrity: Int {
        willSet {
            print("   hull: \(hullIntegrity) -> \(newValue)")
        }
        didSet {
            if hullIntegrity > 100 {
                hullIntegrity = 100
            } else if hullIntegrity < 0 {
                hullIntegrity = 0
            }
        }
    }

    var oxygenByDeck: [Deck: Int]

    lazy var fullDiagnostics: String = {
        print("   Running full scan...")
        var report = "Diagnostics for \(self.callSign): hull \(self.hullIntegrity)%"
        for deck in Deck.allCases {
            if let level = self.oxygenByDeck[deck] {
                report += ", \(deck.rawValue)=\(level)"
            }
        }
        return report
    }()

    var totalOxygen: Int {
        var sum = 0
        for value in oxygenByDeck.values {
            sum += value
        }
        return sum
    }

    var averageOxygen: Int {
        get {
            if oxygenByDeck.count == 0 {
                return 0
            }
            return totalOxygen / oxygenByDeck.count
        }
        set {
            for deck in Deck.allCases {
                if oxygenByDeck[deck] != nil {
                    oxygenByDeck[deck] = newValue
                }
            }
        }
    }

    init(callSign: String, hullIntegrity: Int, readings: [(deck: String, oxygen: Int)]) {
        self.callSign = callSign
        self.hullIntegrity = hullIntegrity
        var map: [Deck: Int] = [:]
        for reading in readings {
            if let deck = Deck(rawValue: reading.deck) {
                map[deck] = reading.oxygen
            } else {
                print("WARNING: reading for unknown deck '\(reading.deck)' skipped.")
            }
        }
        self.oxygenByDeck = map
    }
}

print("\n--- Level 5.1: Station ---")
let station = Station(callSign: "ALMA-7", hullIntegrity: 100, readings: deckReadings)
print("Total oxygen: \(station.totalOxygen)")
print("Average oxygen at start-up: \(station.averageOxygen)")

let B = station.averageOxygen


let untouchedStation = Station(callSign: "ALMA-8", hullIntegrity: 90, readings: deckReadings)
print("Created \(untouchedStation.callSign) and never touched fullDiagnostics: no scan message appears.")
print("First access of ALMA-7 diagnostics:")
print(station.fullDiagnostics)
print("Second access (no scan message expected):")
print(station.fullDiagnostics)

station.averageOxygen = 50
print("After setting averageOxygen = 50 -> total \(station.totalOxygen), average \(station.averageOxygen)")

// 5.2 · The clamp trap
print("\n--- Level 5.2: Clamp trap ---")
station.hullIntegrity = 130
print("hullIntegrity after 130: \(station.hullIntegrity)")
station.hullIntegrity = -40
print("hullIntegrity after -40: \(station.hullIntegrity)")
station.hullIntegrity = 55
print("hullIntegrity after 55:  \(station.hullIntegrity)")


// MARK: Level 6 · Incident Reports
// NOTE: the brief says "three compile and are wrong, one doesn't compile", but
// Reports 3 and 4 both fail to compile; Reports 1 and 2 compile and are wrong.
/*
 Report 1
   Expected: every crew member in `roster` loses 10 oxygen.
   Actual:   nothing changes; roster[0].oxygen still prints 62.
   Rule:     CrewSnapshot is a struct (value type). `for var member in roster`
             gives each iteration its own COPY; mutating the copy never touches
             the array's element.
   Fix:
       var roster = crewRoster
       for index in 0..<roster.count {
           roster[index].oxygen -= 10
       }
       print(roster[0].oxygen)   // 52

 Report 2
   Expected: podA stays at 100 (author thought podB was an independent pod).
   Actual:   prints 0.
   Rule:     TeleportPod is a class (reference type). `let podB = podA` copies
             the REFERENCE, so both names point to the same object; the
             mutation is visible through both.
   Fix (if independent pods are wanted): create a second instance:
       let podA = TeleportPod(id: "A", chargeLevel: 100)
       let podB = TeleportPod(id: "B", chargeLevel: podA.chargeLevel)
       podB.chargeLevel = 0
       print(podA.chargeLevel)   // 100

 Report 3
   Does not compile: "cannot use mutating member on immutable value:
   'self' is immutable".
   Rule:     methods of a struct are non-mutating by default, so `self` is a
             constant inside them; changing `entries` changes self.
   Fix:
       struct Logbook {
           var entries: [String] = []
           mutating func add(_ entry: String) {
               entries.append(entry)
           }
       }
       (and the Logbook instance must be a `var`)

 Report 4
   `let snapshot = CrewSnapshot.rookie(named: "Dana")`
   `snapshot.oxygen = 40`  -> COMPILE ERROR: "cannot assign to property:
       'snapshot' is a 'let' constant".
   `let pod = TeleportPod(id: "B", chargeLevel: 50)`
   `pod.chargeLevel = 10`  -> compiles and works.
   What let protects:
     • struct: `let` freezes the whole value, including every `var` property
       inside it, because the variable IS the value.
     • class:  `let` freezes only the reference (the variable can never point
       to another object). The object it points to stays mutable through its
       own `var` properties.
   Fix:
       var snapshot = CrewSnapshot.rookie(named: "Dana")
       snapshot.oxygen = 40
*/


// MARK: Level 7 · Sealing the Black Box

// The leaky original:
//
// class FlightRecorder {
//     var entries: [String] = []
//     var isSealed = false
// }


public final class FlightRecorder {


    private var entries: [String] = []

   
    public private(set) var isSealed = false

    public init() {}


    public var entryCount: Int {
        return entries.count
    }


    public var transcript: String {
        return formattedLines().joined(separator: "\n")
    }


    @discardableResult
    public func add(_ entry: String) -> Bool {
        if isSealed {
            return false
        }
        entries.append(entry)
        return true
    }

   
    public func seal() {
        isSealed = true
    }


    fileprivate func formattedLines() -> [String] {
        var lines: [String] = []
        var number = 1
        for entry in entries {
            lines.append("#\(number) \(entry)")
            number += 1
        }
        return lines
    }
}


func auditTranscript(of recorder: FlightRecorder) -> String {
    let lines = recorder.formattedLines()
    return "AUDIT (\(lines.count) lines, sealed: \(recorder.isSealed))\n" + lines.joined(separator: "\n")
}

print("\n--- Level 7: FlightRecorder ---")
let recorder = FlightRecorder()
recorder.add("Teleporter online")
recorder.add("Crew transfer requested")
print("Entries before seal: \(recorder.entryCount)")
recorder.seal()
let accepted = recorder.add("Late edit attempt")
print("Add after seal accepted? \(accepted)")
print("Entries after seal: \(recorder.entryCount)")
print("Transcript:\n\(recorder.transcript)")
print(auditTranscript(of: recorder))



// MARK: Finale · Integrity Code

let D = AlarmLevel.level(forTotalMass: A).rawValue
let integrityCode = "\(A)-\(B)-\(C)-\(D)"
print("\nINTEGRITY CODE: \(integrityCode)")
// Expected: 1244-57-40-2


// MARK: Bonus

print("\n--- Bonus: lifetime and identity ---")
var keeper: TeleportPod? = nil
do {
    let temp = TeleportPod(id: "T-1", chargeLevel: 50)
    keeper = temp                      // second strong reference
    print("Inside do-block: pod \(temp.id) exists")
}
print("After do-block: no deinit yet, 'keeper' still holds the pod")
keeper = nil                           // last reference released -> deinit fires on THIS line
print("After keeper = nil")
// Why: deinit runs when the reference count reaches 0. Leaving the do-block
// only dropped `temp`; `keeper` still owned the pod. Setting keeper to nil
// removed the last strong reference, so the pod was destroyed right there.

func describeIdentity(_ a: TeleportPod, _ b: TeleportPod) -> String {
    if a === b {
        return "same pod (one object, two references)"
    } else if a.id == b.id && a.chargeLevel == b.chargeLevel {
        return "two different pods with equal contents"
    } else {
        return "two different pods"
    }
}

let x1 = TeleportPod(id: "X", chargeLevel: 70)
let x2 = x1
let x3 = TeleportPod(id: "X", chargeLevel: 70)
print("x1 vs x2: \(describeIdentity(x1, x2))")
print("x1 vs x3: \(describeIdentity(x1, x3))")




