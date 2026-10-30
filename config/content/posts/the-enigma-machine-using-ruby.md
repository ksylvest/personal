---
date: "2015-01-03"
title: The Enigma Machine using Ruby
summary: The Enigma machine explained in Ruby
tags:
  - ruby
---

An Enigma machine is a German engineered mechanical and electrical cipher machine used commercially in the 1920s and more famously during the Second World War. The machine's enciphering and deciphering played the role of the antagonist in the recent film **The Imitation Game** (loosely) following **Alan Turings** work at Bletchley Park. The machine is spellbinding because of its 159 million million million combinations it can cipher to (all before the invention of the transistor).

The machine is composed of three different 'scrambling' parts: rotors, a plugboard, and a reflector. The machine's input comes from a keyboard, travels through the electromechanical components and is finally displayed on a lampboard as a highlighted letter.

# The Plugboard

The plugboard's role is to swap pairs of letters. An electronic signal will pass through the plugboard twice (after leaving the keyboard and before entering the lampboard). Any letter that isn't "plugged" will output as itself.

```ruby
module Enigma
  class Plugboard

    attr_accessor :mappings

    def initialize()
      self.mappings = {}
    end

    def plug(a,b)
      self.mappings[a] = b
      self.mappings[b] = a
    end

    def swap(letter)
      self.mappings[letter] || letter
    end

  end
end
```

```ruby
plugboard = new Enigma::Plugboard
plugboard.plug('A','B')
plugboard.swap('A') # 'B'
plugboard.swap('B') # 'A'
plugboard.swap('C') # 'C'
```

# The Reflector

The reflector's role is to perform a substitution. It is a mapping of every letter to a different letter (i.e. A to B and B to A, C to D and D to C, etc). The relationship is defined in Mathematics to be **reciprocal** (that is _f(f(x)) = x_).

```ruby
module Enigma
  ALPHABET = %w(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z).freeze

  class Reflector

    module Mappings
      SAMPLE = %w(Y R U H Q S L D P X N G O K M I E B F Z C W V J A T).freeze
    end

    attr_accessor :mappings

    def initialize(mappings: Mappings::SAMPLE)
      self.mappings = mappings
    end

    def reflect(letter)
      ALPHABET[(self.mappings.index(letter)) % ALPHABET.length]
    end

  end
end
```

```ruby
reflector = new Enigma::Reflector
reflector.reflect('A') # 'Y'
reflector.reflect('Y') # 'A'
reflector.reflect('B') # 'R'
reflector.reflect('R') # 'B'
```

# The Machine

These two components are enough to build a simple (ineffective) cipher machine known as a substitution cipher. A letter flows into the plugboard then to the reflector and finally back to the plugboard. To decrypt, the encrypted message is sent through the same processes.

```ruby
module Enigma

  class Machine
    SEPARATOR = ''

    attr_accessor :reflector
    attr_accessor :plugboard

    def initialize(reflector: Reflector.new, plugboard: Plugboard.new)
      self.reflector = reflector
      self.plugboard = plugboard
    end

    def convert(string)
      string.split(SEPARATOR).map { |letter| process(letter) }.join(SEPARATOR)
    end

  private

    def process(letter)
      letter = plug(letter)
      letter = reflect(letter)
      letter = plug(letter)

      return letter
    end

    def plug(letter)
      self.plugboard.swap(letter)
    end

    def reflect(letter)
      self.reflector.reflect(letter)
    end

  end
end
```

# The Rotor

Unfortunately a simple substitution cipher is easy to break because letters always map to the same values. The cleverness behind the Enigma machine is that it uses three (or sometimes four) rotors to perform multiple layers of substitution. Rotors are bijective functions that have one to one mappings for every letter. In the enigma machine the rotors step like an odometer or a clock before each letter is processed. Only when the first rotor performs a full rotation will the second rotor turn. Similarly each subsequent rotor will turn after the previous rotor cycles through all 26 positions. The processes of a rotor 'stepping' changes the bijective mapping. Each rotor acts as a substitution cypher and has a _forward_ and _reverse_ (inverse) mapping. The combination of multiple rotors is known as a polyalphabetic substitution cipher.

```ruby
module Enigma
  class Rotor

    module Mappings
      A = %w(E K M F L G D Q V Z N T O W Y H X U S P A I B R C J).freeze
      B = %w(A J D K S I R U X B L H W T M C Q G Z N P Y F V O E).freeze
      C = %w(B D F H J L C P R T X V Z N Y E I W G A K M U S Q O).freeze
    end

    attr_accessor :mappings
    attr_accessor :offset

    def initialize(mappings)
      self.mappings = mappings
      reset!
    end

    def reset!
      self.offset = 0
    end

    def rotate
      self.offset = self.offset.next % ALPHABET.length
    end

    def turnover?
      ((self.position + self.offset) % ALPHABET.length).zero?
    end

    def forward(letter)
      return letter unless ALPHABET.include?(letter)
      return self.mappings[(ALPHABET.index(letter) + self.offset) % ALPHABET.length]
    end

    def reverse(letter)
      return letter unless ALPHABET.include?(letter)
      return ALPHABET[(self.mappings.index(letter) - self.offset) % ALPHABET.length]
    end

  end
end
```

# The Stepping

The example can have a few rotors added in. In addition to the existing steps the machine now rotates the rotors and sends the letter forward and reverse through the rotors before and after being reflected. The rotation or stepping means that 26 cubed (**17,576**) different bijective functions can be selected to map each letter in a string. The functions will change on each rotation making it very difficult to find reoccurring patterns.

```ruby
module Enigma

  class Machine
    SEPARATOR = ''

    attr_accessor :rotors
    attr_accessor :reflector
    attr_accessor :plugboard

    def initialize(reflector: Reflector.new, plugboard: Plugboard.new)
      self.rotors = [
        Rotor.new(mappings: Rotor::Mappings::A),
        Rotor.new(mappings: Rotor::Mappings::B),
        Rotor.new(mappings: Rotor::Mappings::C),
      ]
      self.reflector = reflector
      self.plugboard = plugboard
    end

    def convert(string)
      string.split(SEPARATOR).map { |letter| process(letter) }.join(SEPARATOR)
    end

  private

    def process(letter)
      rotate

      letter = plug(letter)
      letter = forward(letter)
      letter = reflect(letter)
      letter = reverse(letter)
      letter = plug(letter)

      return letter
    end

    def plug(letter)
      self.plugboard.swap(letter)
    end

    def reflect(letter)
      self.reflector.reflect(letter)
    end

    def forward(letter)
      self.rotors.inject(letter) do |letter, rotor|
        rotor.forward(letter)
      end
    end

    def reverse(letter)
      self.rotors.reverse.inject(letter) do |letter, rotor|
        rotor.reverse(letter)
      end
    end

    def rotate
      self.rotors.each do |rotor|
        rotor.rotate
        break unless rotor.turnover?
      end
    end

  end
end
```

# Conclusion

The above example shows a simplified version of how an Enigma machine works in Ruby. For a more complete example see: [https://github.com/ksylvest/enigma](https://github.com/ksylvest/enigma). The number of permutations the Enigma machine allows for is so large because three of five rotors can be selected in any order, two reflectors can be swapped, and any number of letter mappings can be supplied with the plugboard. In addition the initial settings for the machine allowed for the rotors and reflectors to each start with 26 different offsets.
