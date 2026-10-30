---
date: "2017-04-29"
title: Automating Favicon Generation in Rails using Sketch
summary: How to use rake, rails, convert and sketch to generate a favicon.
tags:
  - rake
  - rails
  - sketch
  - favicon
---

Seeing as the favicon standard dates back to **1999**, it is difficult to reason why they are still a pain to generate. The following outlines a workflow to generate a site's favicon using [Sketch](https://www.sketchapp.com/).

## Setup

Sketch ships with a little known CLI called [sketchtool](https://www.sketchapp.com/tool/). Installation is straight forward:

```bash
/Applications/Sketch.app/Contents/Resources/sketchtool/install.sh
which sketchtool # /usr/local/bin/sketchtool
```

Next [imagemagick](https://www.imagemagick.org/script/index.php) is needed. If it isn't installed it is easiest to setup through [brew](https://brew.sh):

```
brew install imagemagick
which convert # /usr/local/bin/convert
```

With both **sketchtool** and **imagemagick** installed grab generate a sketch file with a favicon. Ensure the file includes an artcboard with exports for your preferred favicon sizes (e.g. 16 by 16, 32 by 32, etc).

## Task

Now that the Sketch file is setup add the following Rake task to the project as **lib/tasks/favicon.rake**:

```ruby
namespace :favicon do
  desc "generate a favicon"
  task generate: :environment do
    system <<~SYSTEM
    sketchtool export artboards #{Rails.root}/doc/favicon.sketch --output=#{Rails.root}/tmp
    convert #{Rails.root}/tmp/favicon-*.png #{Rails.root}/public/favicon.ico
    rm #{Rails.root}/tmp/favicon-*
    SYSTEM
  end
end
```

## Enjoy

That is it! Anytime the **doc/favicon.sketch** file is modified running `rake favicon:generate` generates **public/favicon.ico**. This technique also works surprisingly well for other assets.

## Advanced

To generate a favicon Sketch file from scratch go 'File' then 'New'. Insert an artboard using 'Insert' then 'Artboard'. The artboard can use any dimensions that are square (if in doubt go with 64×64). Rename the artboard to 'favicon' then make it exportable. Generate export sizes (if in doubt go with 16w, 24w, 32w, 48w, and 64w) and apply a corresponding 'Prefix/Suffix' (i.e. for 16w use ...-16) as **PNG**. The Sketch file is ready for use! Save the document to **doc/favicon.sketch** in the project.

If the favicon is changed often it is a good idea to modify the task to convert to **app/assets/images/favicon.ico**. Then adjust the **app/views/layouts/application.html** (or other layout) to contain `favicon_link_tag 'favicon.ico', sizes: '16x16 24x24 32x32 48x48 64x64'` (see [docs](https://api.rubyonrails.org/classes/ActionView/Helpers/AssetTagHelper.html#method-i-favicon_link_tag)). This uses the asset pipeline and ensures browsers detect changes to the favicon.
