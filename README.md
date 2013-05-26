# TaxCode

Each time we need to modify a file for a new feature or a bug fix we increase a
maintenance cost of this file and the whole code base. 
TaxCode calculates cumulative maintenance 'taxes' introduced by all changes in the git repository.

Files with higher taxes are most probably ones that carry too many responsibilities and/or
are too complex - they should be considered for refactoring.

You can see the tax value for particular file as a 'perceptual size increase' - e.g. if the file
size is 500 lines and its tax is 400, this file maintenance costs the same as for untouched 
900 lines long one (please note that there is no science behind tax calculation, this is author's 
opinionated take on the problem)

TaxCode differences from other similar scripts and gems:
- TaxCode takes into account that maintenance cost decreases over time - if you do not
touch some files for a long time, they may be stable enogh and not have as high cost as recently modified ones. 
- It gives you a 'tax credit' for changes that reduce the size of your files
- It tracks files that are renamed and/or moed around

## Installation

Add this line to your application's Gemfile:

    gem 'tax_code'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tax_code

## Usage

Main intent of this gem is to be used from command line. The number of options and commands will be increased in future releases

To get repository or directory aggregated tax:

    $ cd test/repo
    $ taxes
    19

    $ cd ../..
    $ taxes test/repo
    19

Individual file tax (after last rename/move):

    $ taxes test/repo/multiple_commits
    14

Too narrow path specification will not take into account file renames that happened outside of this path

    $ taxes test/repo/renamed
    0

To get the list of top (up to) 25 expensive files in your repository (non-taxed files are not included in the report):
    
    $ cd test/repo
    $ worst_taxed
    14  test/repo/multiple_commits
    5   test/repo/renamed

    $ cd ../..
    $ worst_taxed test/repo
    14  test/repo/multiple_commits
    5   test/repo/renamed

Please note that limiting to particular directory or file may miss data about renamed files. E.g:
    
    $ worst_taxed test/repo/multiple_commits
    14  test/repo/multiple_commits

    $ worst_taxed test/repo/renamed
    No taxed files found

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## TODO

* Add more options and commands to CLI
* Output partial path (instead of full path from git root)
* Do full repo log on runs limited to directory/file
* Calculate tax on a single commit (last or specified)
* Historical snapshot - taxes up to particular commit or date
* Taxes accumulated after particular commit or date

