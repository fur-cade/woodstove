# woodstove

Woodstove is a simple package manager programmed in ruby, designed to allow easy
management of the parts required to develop and deploy an application.

It has been designed with the npm package manager (used in nodejs) in mind, but with more support for additional programming languages and with server deployment in mind, adding easy support for run scripts.

## Package Format

Woodstove packages are installable via their github path (`username/reponame`).
Packages require a `kindling.yaml` file which supplies information about the package.

### Example kindling.yaml:

```yaml
depends:            # Installs listed packages in `kindling` folder.
  - foo/baz
  - ding/quux

scripts:
  main: index.rb    # Makes 'woodstove run' run 'ruby index.rb'.
  boop: explode.sh  # Makes `woodstove exec boop` run `bash explode.sh`.
bin:                # Makes scripts executable on the PATH.
  bar: main         # Makes `bar` run `ruby index.rb`.
```

## Installation

Woodstove can be easily installed via the rubygems package manager. If you have ruby, you already have rubygems.

Simply run the following command (with proper privileges) to install woodstove:
```
gem install woodstove
```
