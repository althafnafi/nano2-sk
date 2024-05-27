// Arrow Keys as an enum
enum ArrowKey: String {
  case up
  case down
  case left
  case right
}

class GameModel {

  // Alphabet for random letter generation
  let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

  // Vowel characters
  let vowels: Set<Character> = ["A", "E", "I", "O", "U"]


  // Enum for Vowel/Consonant Sequence
  enum SequenceType {
    case vowel([ArrowKey])
    case consonant([ArrowKey])
  }

  var gameCode: String = ""
  var finalSequence: [ArrowKey]? = []

  // Function to generate a random string from the alphabet
  func generateRandomString(length: Int) -> String {
    var randomString = ""
    for _ in 0..<length {
      let randomIndex = Int.random(in: 0..<alphabet.count)
      randomString += String(alphabet[alphabet.index(alphabet.startIndex, offsetBy: randomIndex)]) // Access character using index
    }
    return randomString
  }

  // Function to generate the initial game code "ABXX"
  func generateGameCode() -> String {
    let firstLetter = generateRandomString(length: 1)
    let secondLetter = generateRandomString(length: 1)
    let firstNumber = String(Int.random(in: 0...9)) // Generate number between 0-9 (inclusive)
    let secondNumber = String(Int.random(in: 0...9))
    return firstLetter + secondLetter + firstNumber + secondNumber
  }

  // Function to generate the arrow sequence based on the first letter (vowel/consonant)
  func generateArrowSequence(forLetter letter: Character) -> SequenceType {
    var sequence: [ArrowKey] = []
    if vowels.contains(letter) {
      // Sequence for vowels (replace with your desired sequence)
      sequence = [.up, .left, .down, .right, .left, .up, .right, .down]
    } else {
      // Sequence for consonants (replace with your desired sequence)
      sequence = [.right, .down, .left, .up, .right, .down, .left, .up]
    }
    return .vowel(sequence)
  }

  // Hardcoded function to get the ignored arrow key (based on second letter's position)
  func getIgnoredArrowKey(forLetter letter: Character) -> ArrowKey {
    switch letter {
    case "A"..."D":
      return .up
    case "E"..."H":
      return .down
    case "I"..."L":
      return .left
    default:
      return .right
    }
  }

  // Function to check if the user input matches the expected sequence
  func checkUserInput(sequence: [ArrowKey], ignoredKey: ArrowKey?, userInput: [ArrowKey]) -> Bool {
    guard sequence.count == userInput.count else { return false }

    for i in 0..<sequence.count {
      if sequence[i] != userInput[i] && userInput[i] != ignoredKey {
        return false
      }
    }
    return true
  }

  // Function to generate the final sequence considering even/odd number and reversal
  func getFinalSequence(sequence: [ArrowKey], isEvenNumber: Bool) -> [ArrowKey] {
    return isEvenNumber ? sequence : sequence.reversed()
  }

  // Function to remove the ignored arrow key from the sequence
  func removeIgnoredKey(from sequence: [ArrowKey], ignoredKey: ArrowKey) -> [ArrowKey] {
    var filteredSequence: [ArrowKey] = []
    for item in sequence {
      if item != ignoredKey {
        filteredSequence.append(item)
      }
    }
    return filteredSequence
  }

// Function to generate a new game session with code and sequence
func newGameSession() {

  let gameCode = generateGameCode()
  print("Generated Game Code:", gameCode)

  let firstLetter = gameCode[gameCode.startIndex]
  let secondLetter = gameCode[gameCode.index(gameCode.startIndex, offsetBy: 1)]
  let numberString = String(gameCode.suffix(2))
  let isEvenNumber = Int(numberString)! % 2 == 0

  let arrowSequence = generateArrowSequence(forLetter: firstLetter)
  let ignoredArrowKey = getIgnoredArrowKey(forLetter: secondLetter)

  print("Arrow Sequence:", arrowSequence)
  print("Ignored Arrow Key:", ignoredArrowKey)

  var finalSequence: [ArrowKey] = []
  switch arrowSequence {
  case .vowel(let vowelSequence):
    finalSequence = removeIgnoredKey(from: vowelSequence, ignoredKey: ignoredArrowKey)
  case .consonant(let consonantSequence):
    finalSequence = removeIgnoredKey(from: consonantSequence, ignoredKey: ignoredArrowKey)
  }

  let finalSequenceReversed = getFinalSequence(sequence: finalSequence, isEvenNumber: isEvenNumber)

  self.gameCode = gameCode
  self.finalSequence = finalSequenceReversed

  print("Final Sequence (without ignored key):", finalSequenceReversed)
}
}

