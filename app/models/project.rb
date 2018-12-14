class Project

  attr_reader :name, :slug, :icon, :description, :url

  def initialize(slug, icon, name, description, url)
    @slug = slug
    @icon = icon
    @name = name
    @description = description
    @url = url
  end

  RHINO = new(:rhino, 'fal fa-server', 'Rhino',
    'A Ruby rack server built using sockets, threads and a CLI.',
    'https://github.com/ksylvest/rhino/')

  SPECIFIER = new(:specifier, 'fal fa-gavel', 'Specifier',
    'A Ruby testing framework built for examples, contexts and a CLI.',
    'https://github.com/ksylvest/specifier/')

  ENIGMA = new(:enigma, 'fal fa-key', 'Enigma',
    'A Ruby enigma machine (rotors, reflectors, plugboard and all).',
    'https://github.com/ksylvest/enigma/')

  ATTATCHED = new(:attached, 'fal fa-paperclip', 'Attached',
    'A Rails gem for uploading files to Amazon, Google or Rackspace.',
    'https://ksylvest.github.io/attached/')

  FORMULA = new(:formula, 'fal fa-flask', 'Formula',
    'A Rails gem for creating rich forms with minimal markup.',
    'https://ksylvest.github.io/formula/')

  ERRONEOUS = new(:erroneous, 'fal fa-exclamation', 'Erroneous',
    'A Rails gem for converting errors to human readable forms.',
    'https://ksylvest.github.io/erroneous/')

  IDENTIFIER = new(:identifier, 'fal fa-tags', 'Identifier',
    'A Ruby gem for generating UUIDs and GUIDs cross platform.',
    'https://ksylvest.github.io/identifier/')

  SERIALIZER = new(:serializer, 'fal fa-tachometer', 'Serializer',
    'A Rails gem for serializing settings with types and defaults.',
    'https://ksylvest.github.io/serializer/')

  REASON = new(:reason, 'fal fa-filter', 'Reason',
    'An iOS and Mac pod that adds enumerables, parsing, and more.',
    'https://github.com/ksylvest/reason')

  GEOGRAPHY = new(:geography, 'fal fa-globe', 'Geography',
    'An iOS and Mac pod that adds in support for countries and regions.',
    'https://github.com/ksylvest/geography')

  ENCORE = new(:encore, 'fal fa-random', 'Encore',
    'An iOS and Mac pod that eliminates duplicate for callbacks.',
    'https://github.com/ksylvest/encore/')

  LINK = new(:link, 'fal fa-link', 'Link',
    'An iOS pod that simplifies tables and collections.',
    'https://github.com/ksylvest/link/')

  SETUP = new(:setup, 'fal fa-magic', 'Setup',
    'A Bash script for setting up development environments.',
    'https://ksylvest.github.io/setup/')

  AGE = new(:age, 'fal fa-clock', 'Age',
    'A JS library for formatting and counting dates in a friendly form.',
    'https://ksylvest.github.io/jquery-age/')

  CAROUSEL = new(:carousel, 'fal fa-images', 'Carousel',
    'A JS library for browsing images in a photo carousel.',
    'https://ksylvest.github.io/jquery-carousel/')

  GRIDLY = new(:gridly, 'fal fa-th', 'Gridly',
    'A JS library for reording and resizing of elements on a grid.',
    'https://ksylvest.github.io/jquery-gridly/')

  GROWL = new(:growl, 'fal fa-comments', 'Growl',
    'A JS library that enables growl style notifications.',
    'https://ksylvest.github.io/jquery-growl/')

  LIGHTER = new(:lighter, 'fal fa-fire', 'Lighter',
    'A JS library for full screen image browsing and zooming.',
    'https://ksylvest.github.io/jquery-lighter/')

  MODAL = new(:modal, 'fal fa-arrows', 'Modal',
    'A JS library for scrollable and static modals.',
    'https://ksylvest.github.io/jquery-modal/')

  OBSERVER = new(:observer, 'fal fa-eye', 'Observer',
    'A JS library for throttled observing of form changes.',
    'https://ksylvest.github.io/jquery-observer/')

  SPIN = new(:spin, 'fal fa-spinner', 'Spin',
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
