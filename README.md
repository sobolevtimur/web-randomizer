# Web Randomizer

##Features
* Randomize classes for div tags for all files in specified folders
* Set random class value for div tags without class 
* Replace style classes for css files in specified folders according to randomized div classes values 
* Randomize css colors in specified folders

##Installation

Add this line to your Gemfile:

    gem 'web_randomizer'

Then run bundle install or install it manually:

    gem install web_randomizer


##Settings
If you want to specify your own parsing folders, you can add them to randomize.yml file located at the root of your project 

Settings example:

    # randomize.yml 
    html_dir: ["_includes", "_layouts"]
    css_dir: ["assets/css","_sass"]

##Usage 

Usage example:

    require 'web_randomizer'
    WebRandomizer.execute

##License
MIT License.
`