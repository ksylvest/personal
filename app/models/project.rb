class Project

  attr_reader :name, :icon, :description, :url

  def initialize(name, icon, description, url)
    @name = name
    @icon = icon
    @description = description
    @url = url
  end

  RHINO = new('Rhino', 'fal fa-server',
    'A Ruby rack server built using sockets, threads and a CLI.',
    'https://github.com/ksylvest/rhino/')

  SPECIFIER = new('Specifier', 'fal fa-gavel',
    'A Ruby testing framework built for examples, contexts and a CLI.',
    'https://github.com/ksylvest/specifier/')

  ENIGMA = new('Enigma', 'fal fa-key',
    'A Ruby enigma machine (rotors, reflectors, plugboard and all).',
    'https://github.com/ksylvest/enigma/')

  ATTATCHED = new('Attached', 'fal fa-paperclip',
    'A Rails gem for uploading files to Amazon, Google or Rackspace.',
    'https://ksylvest.github.io/attached/')

  FORMULA = new('Formula', 'fal fa-flask',
    'A Rails gem for creating rich forms with minimal markup.',
    'https://ksylvest.github.io/formula/')

  ERRONEOUS = new('Erroneous', 'fal fa-exclamation',
    'A Rails gem for converting errors to human readable forms.',
    'https://ksylvest.github.io/erroneous/')

  IDENTIFIER = new('Identifier', 'fal fa-tags',
    'A Ruby gem for generating UUIDs and GUIDs cross platform.',
    'https://ksylvest.github.io/identifier/')

  SERIALIZER = new('Serializer', 'fal fa-tachometer',
    'A Rails gem for serializing settings with types and defaults.',
    'https://ksylvest.github.io/serializer/')

  REASON = new('Reason', 'fal fa-filter',
    'An iOS and Mac pod that adds enumerables, parsing, and more.',
    'https://github.com/ksylvest/reason')

  GEOGRAPHY = new('Geography', 'fal fa-globe',
    'An iOS and Mac pod that adds in support for countries and regions.',
    'https://github.com/ksylvest/geography')

  ENCORE = new('Encore', 'fal fa-random',
    'An iOS and Mac pod that eliminates duplicate for callbacks.',
    'https://github.com/ksylvest/encore/')

  LINK = new('Link', 'fal fa-link',
    'An iOS pod that simplifies tables and collections.',
    'https://github.com/ksylvest/link/')

  SETUP = new('Setup', 'fal fa-magic',
    'A Bash script for setting up development environments.',
    'https://ksylvest.github.io/setup/')

  AGE = new('Age', 'fal fa-clock',
    'A JS library for formatting and counting dates in a friendly form.',
    'https://ksylvest.github.io/jquery-age/')

  CAROUSEL = new('Carousel', 'fal fa-images',
    'A JS library for browsing images in a photo carousel.',
    'https://ksylvest.github.io/jquery-carousel/')

  GRIDLY = new('Gridly', 'fal fa-th',
    'A JS library for reording and resizing of elements on a grid.',
    'https://ksylvest.github.io/jquery-gridly/')

  GROWL = new('Growl', 'fal fa-comments',
    'A JS library that enables growl style notifications.',
    'https://ksylvest.github.io/jquery-growl/')

  LIGHTER = new('Lighter', 'fal fa-fire',
    'A JS library for full screen image browsing and zooming.',
    'https://ksylvest.github.io/jquery-lighter/')

  MODAL = new('Modal', 'fal fa-arrows',
    'A JS library for scrollable and static modals.',
    'https://ksylvest.github.io/jquery-modal/')

  OBSERVER = new('Observer', 'fal fa-eye',
    'A JS library for throttled observing of form changes.',
    'https://ksylvest.github.io/jquery-observer/')

  SPIN = new('Spin', 'fal fa-spinner',
    'A JS library for generating imageless vector spinners.',
    'https://ksylvest.github.io/jquery-spin/')

  ALL = [
    RHINO,
    SPECIFIER,
    ENIGMA,
    ATTATCHED,
    FORMULA,
    ERRONEOUS,
    IDENTIFIER,
    SERIALIZER,
    REASON,
    GEOGRAPHY,
    ENCORE,
    LINK,
    SETUP,
    AGE,
    CAROUSEL,
    GRIDLY,
    GROWL,
    LIGHTER,
    MODAL,
    OBSERVER,
    SPIN,
  ].freeze

  def self.all
    ALL
  end

end
