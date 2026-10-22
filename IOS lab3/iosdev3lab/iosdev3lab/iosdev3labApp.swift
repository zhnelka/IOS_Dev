// =============================================================
//  Station ALMA-7: Rescue Protocol
//  iOS Mobile Development · Module 3 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER CODE section.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • Use the exact function names from the assignment PDF.
// =============================================================


// MARK: - =================== STARTER CODE ===================
// MARK: - Do not modify anything in this section

typealias Reading = (sensor: String, value: Int)

/// Splits a string at the first occurrence of the separator.
/// splitOnce("O2:87", by: ":") -> ("O2", "87")
/// splitOnce("hello", by: ":") -> nil
func splitOnce(_ line: String, by separator: Character) -> (String, String)? {
    guard let index = line.firstIndex(of: separator) else { return nil }
    let left = String(line[..<index])
    let right = String(line[line.index(after: index)...])
    return (left, right)
}

let rawLog = [
    "O2:87", "TEMP:-12", "O2:9x", "PRESS:101", "TEMP:abc", "O2:",
    "RAD:3", "O2:64", ":55", "TEMP:31", "PRESS:98", "O2:71",
    "RAD:-1", "TEMP:4", "PRESS:1o2", "O2:90"
]

class Tank {
    var level: Int
    init(level: Int) { self.level = level }
}

class Module {
    let name: String
    var oxygenTank: Tank?
    init(name: String, oxygenTank: Tank?) {
        self.name = name
        self.oxygenTank = oxygenTank
    }
}

class CrewMember {
    let name: String
    let role: String
    let priority: Int      // 1 = evacuated first
    var module: Module?    // nil = in open space
    init(name: String, role: String, priority: Int, module: Module?) {
        self.name = name
        self.role = role
        self.priority = priority
        self.module = module
    }
}

let lab  = Module(name: "Lab",  oxygenTank: Tank(level: 40))
let hab  = Module(name: "Hab",  oxygenTank: Tank(level: 12))
let dock = Module(name: "Dock", oxygenTank: nil)

let crew = [
    CrewMember(name: "Timur",   role: "Engineer",  priority: 3, module: lab),
    CrewMember(name: "Dana",    role: "Scientist", priority: 4, module: dock),
    CrewMember(name: "Aigerim", role: "Commander", priority: 1, module: hab),
    CrewMember(name: "Nurlan",  role: "Pilot",     priority: 2, module: nil)
]

var roster: [String: CrewMember] = [:]
for member in crew { roster[member.name] = member }

print("ALMA-7 systems online: \(rawLog.count) log lines, \(crew.count) crew members.")

// MARK: - ================= END OF STARTER CODE =================

// Helper: prints any optional (tuple, Int, ...) or "nil"
func show<T>(_ value: T?) -> String {
    if let value = value { return "\(value)" }
    return "nil"
}


// MARK: - =================== YOUR SOLUTION ===================


// MARK: Level 1 · Decoding Telemetry

// 1.1 — a single guard let with several comma-separated conditions
func parseReading(_ raw: String) -> Reading? {
    guard let (sensor, valueText) = splitOnce(raw, by: ":"),
          !sensor.isEmpty,
          let value = Int(valueText),
          value >= 0 || sensor == "TEMP"
    else { return nil }
    return (sensor: sensor, value: value)
}

print("— 1.1 —")
print(show(parseReading("O2:87")))      // (sensor: "O2", value: 87)
print(show(parseReading("TEMP:-12")))   // (sensor: "TEMP", value: -12)
print(show(parseReading("RAD:-1")))     // nil
print(show(parseReading(":55")))        // nil
print(show(parseReading("hello")))      // nil (no separator)

// 1.2
func parseLog(_ lines: [String]) -> (valid: [Reading], invalidCount: Int) {
    var valid: [Reading] = []
    var invalid = 0
    for line in lines {
        if let reading = parseReading(line) {
            valid.append(reading)
        } else {
            invalid += 1
        }
    }
    return (valid, invalid)
}

let parsed = parseLog(rawLog)
let validReadings = parsed.valid
print("— 1.2 —")
print("valid: \(validReadings.count), invalid: \(parsed.invalidCount)")
print(parseLog(["O2:1", "bad"]))

let A = parsed.invalidCount


// MARK: Level 2 · Analysis

// 2.1 — our own filter
func select(_ readings: [Reading], where isIncluded: (Reading) -> Bool) -> [Reading] {
    var result: [Reading] = []
    for reading in readings {
        if isIncluded(reading) {
            result.append(reading)
        }
    }
    return result
}

func values(of readings: [Reading]) -> [Int] {
    var result: [Int] = []
    for reading in readings {
        result.append(reading.value)
    }
    return result
}

// trailing closure + $0
let o2Readings = select(validReadings) { $0.sensor == "O2" }
print("— 2.1 —")
print(o2Readings)
print(values(of: o2Readings))
print(values(of: select(validReadings) { $0.sensor == "RAD" }))

// 2.2 — stats
func stats(of values: [Int]) -> (min: Int, max: Int, average: Double)? {
    guard let first = values.first else { return nil }
    var lo = first
    var hi = first
    var sum = 0
    for v in values {
        if v < lo { lo = v }
        if v > hi { hi = v }
        sum += v
    }
    return (min: lo, max: hi, average: Double(sum) / Double(values.count))
}

// variadic: one line, no `return`, no duplicated logic
func stats(_ values: Int...) -> (min: Int, max: Int, average: Double)? { stats(of: values) }

print("— 2.2 —")
print(show(stats(3, 8, 1)))   // (min: 1, max: 8, average: 4.0)
print(show(stats()))          // nil
print(show(stats(of: [])))    // nil

let B = Int(stats(of: values(of: o2Readings))?.average ?? 0)

// 2.3 — The Closure Ladder (sort descending by value, 5 ways)
let sorted1 = validReadings.sorted(by: { (a: Reading, b: Reading) -> Bool in
    return a.value > b.value
})
let sorted2 = validReadings.sorted(by: { a, b in
    return a.value > b.value
})
let sorted3 = validReadings.sorted(by: { a, b in a.value > b.value })
let sorted4 = validReadings.sorted(by: { $0.value > $1.value })
let sorted5 = validReadings.sorted { $0.value > $1.value }

func sameReadings(_ x: [Reading], _ y: [Reading]) -> Bool {
    guard x.count == y.count else { return false }
    for i in 0..<x.count {
        if x[i].sensor != y[i].sensor || x[i].value != y[i].value { return false }
    }
    return true
}

print("— 2.3 —")
print(values(of: sorted5))
print("All five match:",
      sameReadings(sorted1, sorted2) && sameReadings(sorted2, sorted3)
      && sameReadings(sorted3, sorted4) && sameReadings(sorted4, sorted5))


// MARK: Level 3 · Temperature Stabilization

// 3.1
func heatUp(_ t: Int) -> Int { t + 5 }
func coolDown(_ t: Int) -> Int { t - 3 }
func hold(_ t: Int) -> Int { t }

func chooseProtocol(for temp: Int) -> (Int) -> Int {
    if temp < 18 { return heatUp }
    if temp > 24 { return coolDown }
    return hold
}

print("— 3.1 —")
print(chooseProtocol(for: 10)(10))  // 15
print(chooseProtocol(for: 30)(30))  // 27
print(chooseProtocol(for: 20)(20))  // 20

// 3.2
func runUntilStable(from start: Int, maxSteps: Int = 10) -> (finalTemp: Int, steps: Int, isStable: Bool) {
    var temp = start
    var steps = 0
    while (temp < 18 || temp > 24) && steps < maxSteps {
        let action = chooseProtocol(for: temp)
        temp = action(temp)
        steps += 1
    }
    return (finalTemp: temp, steps: steps, isStable: temp >= 18 && temp <= 24)
}

print("— 3.2 —")
print(runUntilStable(from: 31))                    // (22, 3, true)
print(runUntilStable(from: -100, maxSteps: 5))     // (-75, 5, false)
print(runUntilStable(from: 20))                    // (20, 0, true)

// C: steps for the lowest valid temperature in the log
let tempReadings = select(validReadings) { $0.sensor == "TEMP" }
let lowestTemp = stats(of: values(of: tempReadings))?.min ?? 20   // 20 = already stable fallback
let C = runUntilStable(from: lowestTemp).steps
print("lowest TEMP: \(lowestTemp), steps: \(C)")


// MARK: Level 4 · The Crew

// 4.1 — one line, optional chaining
func oxygenLevel(of member: CrewMember) -> Int? { member.module?.oxygenTank?.level }

print("— 4.1 —")
for member in crew {
    print(member.name, show(oxygenLevel(of: member)))
}

// 4.2
func status(of member: CrewMember) -> String {
    guard let level = oxygenLevel(of: member) else {
        return "\(member.name): no data (\(member.module?.name ?? "open space"))"
    }
    return level < 20 ? "\(member.name): \(level)% CRITICAL" : "\(member.name): \(level)% OK"
}

print("— 4.2 —")
for member in crew {
    print(status(of: member))
}

// 4.3
@discardableResult
func transferOxygen(from source: inout Int, to target: inout Int, amount: Int) -> Int {
    guard amount > 0 else { return 0 }
    let actual = max(0, min(amount, source, 100 - target))
    source -= actual
    target += actual
    return actual
}

print("— 4.3 —")
var plainA = 50
var plainB = 90
let moved = transferOxygen(from: &plainA, to: &plainB, amount: 30)
print("moved \(moved): \(plainA), \(plainB)")          // moved 10: 40, 100
transferOxygen(from: &plainA, to: &plainB, amount: -5)  // nothing happens
print("after negative: \(plainA), \(plainB)")           // 40, 100

// Real transfer: Lab -> Hab, 30 units (no force unwrap)
if let labTank = lab.oxygenTank, let habTank = hab.oxygenTank {
    let done = transferOxygen(from: &labTank.level, to: &habTank.level, amount: 30)
    print("Lab -> Hab transferred: \(done)")
} else {
    print("Transfer impossible: a tank is missing")
}
let D = hab.oxygenTank?.level ?? 0
print("Lab: \(lab.oxygenTank?.level ?? 0), Hab: \(D)")

// 4.4
func evacuationOrder(_ names: String..., roster: [String: CrewMember]) -> [String] {
    var found: [CrewMember] = []
    for name in names {
        guard let member = roster[name] else {
            print("Unknown crew member: \(name)")
            continue
        }
        found.append(member)
    }
    let ordered = found.sorted { $0.priority < $1.priority }
    var result: [String] = []
    for member in ordered {
        result.append(member.name)
    }
    return result
}

print("— 4.4 —")
print(evacuationOrder("Dana", "Ghost", "Aigerim", "Timur", roster: roster))  // ["Aigerim", "Timur", "Dana"]
print(evacuationOrder("Nurlan", "Dana", roster: roster))                    // ["Nurlan", "Dana"]


// MARK: Level 5 · The Saboteur's Logbook
//
// ORIGINAL (kept as a comment, for reference):
/*
func reportOxygen(for member: CrewMember) -> String {
    let tank = member.module!.oxygenTank!
    return "\(member.name): \(tank.level)%"
}

func firstCritical(in crew: [CrewMember]) -> String {
    var result: String?
    for member in crew {
        if oxygenLevel(of: member)! < 20 {
            result = member.name
        }
    }
    return result!
}
*/

// PROBLEMS in reportOxygen:
//  1. `member.module!` crashes if the member has no module (Nurlan, open space)
//     → "Unexpectedly found nil while unwrapping an Optional value".
//  2. `oxygenTank!` crashes if the module has no tank (Dana in Dock) → same crash.
//  3. Design: a report for "no data" should be a normal result, not a crash.
//
// PROBLEMS in firstCritical:
//  1. `oxygenLevel(of: member)!` crashes for Dana (no tank) and Nurlan (no module).
//  2. LOGIC BUG: there is no `break`/`return` after the match, so the loop keeps going
//     and `result` is overwritten by every later critical member. It returns the LAST
//     critical member, not the FIRST. Invisible with starter data, because only Aigerim
//     is below 20 (and the loop would crash on Dana before that matters anyway).
//  3. `result!` crashes when nobody is critical (result is still nil).
//  4. The return type String can't express "nobody is critical"; it must be String?.

func reportOxygen(for member: CrewMember) -> String {
    guard let level = oxygenLevel(of: member) else {
        return "\(member.name): no data"
    }
    return "\(member.name): \(level)%"
}

func firstCritical(in crew: [CrewMember]) -> String? {
    for member in crew {
        if let level = oxygenLevel(of: member), level < 20 {
            return member.name   // return immediately: this is the FIRST one
        }
    }
    return nil
}

print("— Level 5 —")
for member in crew {
    print(reportOxygen(for: member))   // no crashes for Dana / Nurlan
}
print(firstCritical(in: crew) ?? "nobody critical")

// Test that proves the logic bug is fixed: two critical members, order matters
let testModuleA = Module(name: "TestA", oxygenTank: Tank(level: 10))
let testModuleB = Module(name: "TestB", oxygenTank: Tank(level: 5))
let testCrew = [
    CrewMember(name: "First",  role: "Test", priority: 1, module: testModuleA),
    CrewMember(name: "NoData", role: "Test", priority: 2, module: nil),
    CrewMember(name: "Second", role: "Test", priority: 3, module: testModuleB)
]
print("Expected First, got:", firstCritical(in: testCrew) ?? "nil")      // old code would give "Second" (or crash on NoData)
print("Expected nil, got:", firstCritical(in: []) ?? "nil")              // empty crew
let safeCrew = [CrewMember(name: "Safe", role: "Test", priority: 1,
                           module: Module(name: "TestC", oxygenTank: Tank(level: 80)))]
print("Expected nil, got:", firstCritical(in: safeCrew) ?? "nil")        // nobody critical


// MARK: Finale · Launch Code

let launchCode = "\(A)-\(B)-\(C)-\(D)"
print("LAUNCH CODE: \(launchCode)")   // expected: 6-78-6-42


// MARK: Bonus

func makeAlarm(threshold: Int) -> (Int) -> Bool {
    var count = 0
    return { level in
        if level < threshold {
            count += 1
            print("Alarm #\(count)")
            return true
        }
        return false
    }
}

print("— Bonus —")
let alarm = makeAlarm(threshold: 20)
print(alarm(12))   // Alarm #1 → true
print(alarm(40))   // false
print(alarm(5))    // Alarm #2 → true


// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. guard let vs if let beyond syntax:
    `if let` binds the unwrapped value only INSIDE its braces; `guard let` binds it for the
    REST OF THE SCOPE and forces the else-branch to leave (return/continue/break/throw), so the
    compiler guarantees the happy path continues with valid data. guard keeps the main logic
    at one indentation level and puts failure handling next to the check ("early exit").
    Example where if let is worse — parseReading with nested if let:

        func parseReading(_ raw: String) -> Reading? {
            if let (sensor, text) = splitOnce(raw, by: ":") {
                if !sensor.isEmpty {
                    if let value = Int(text) {
                        if value >= 0 || sensor == "TEMP" {
                            return (sensor, value)      // real work buried 4 levels deep
                        }
                    }
                }
            }
            return nil
        }

    With guard let it is flat, and `sensor`/`value` are usable after the guard.

 2. Why can't you pass [Int] to stats(_ values: Int...)?
    A variadic parameter accepts a comma-separated list of individual Int arguments. Inside the
    function Swift packs them into an [Int], but at the call site the parameter type is `Int`,
    not `[Int]`, and Swift has no "spread" operator. stats(someArray) passes one [Int] where an
    Int is expected → type error. That's why the array version exists separately:
    stats(of: someArray), and the variadic one just forwards to it.

 3. Why doesn't transferOxygen(from: &x, to: &x, amount: 5) compile?
    Swift's exclusivity rule: while a variable is being passed inout (a long-lived write access),
    nothing else may access it. Two inout arguments pointing to the same variable would overlap
    ("overlapping accesses to 'x'"). It prevents aliasing bugs: inside the function, `source -= n`
    and `target += n` would operate on the same storage, so the result depends on the order in
    which the copies are written back (oxygen would be created or lost from nowhere).

 4. Why doesn't oxygenLevel(of: dana) ?? "no data" compile?
    oxygenLevel returns Int?. The ?? operator requires the default to have the wrapped type,
    here Int (T? ?? T). "no data" is a String, so the types don't match, and the result couldn't
    be a single type (Int or String). Fix: use a default Int (`?? 0`), or produce a String from
    the optional with if let / guard let, e.g.
        if let level = oxygenLevel(of: dana) { "\(level)%" } else { "no data" }
    or "\(oxygenLevel(of: dana) ?? 0)".

 5. Full type of chooseProtocol and how to read it:
        (Int) -> (Int) -> Int
    (The label `for:` is not part of the type.) The arrow is right-associative, so it reads as
        (Int) -> ((Int) -> Int)
    "a function that takes an Int (the current temperature) and returns another function, which
    takes an Int and returns an Int." So chooseProtocol(for: 10) gives back heatUp, and
    chooseProtocol(for: 10)(10) applies it → 15.

 Bonus. Where does the alarm counter live after makeAlarm returns?
    The returned closure CAPTURES `count`. Swift moves the captured variable from the stack
    to a heap-allocated box that the closure holds a strong reference to. Local variables of
    makeAlarm vanish when it returns, but `count` lives as long as the closure lives, and each
    call to makeAlarm creates a new, separate counter (so two alarms count independently).
*/
