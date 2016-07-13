# woodstove

Woodstove is a simple package manager programmed in ruby, designed to allow easy
management of the parts required to develop and deploy an application.

It has been designed with the npm package manager (used in nodejs) in mind, but with more support for additional programming languages and with server deployment in mind, adding easy support for run scripts.
The main benefit over npm and other such package managers is that it allows installing generic github repositories, regardless of whether or not they have been formatted as packages. This allows for easier management of dependencies not designed specifically for use with woodstove.

## Usage

### Installing Packages

The `install` command can be used to install packages into the `kindling` subdirectory inside of the current working directory. Any binaries specified by the package will be placed in `kindling/.bin`. Specified dependencies will also be installed inside the `kindling` subdirectory of the packages installed. If no packages are specified, it will install the dependencies from the `kindling.yaml` in the current working directory.

```
woodstove install [packages]
woodstove i [packages]
woodstove install
woodstove i
```

Packages are formatted in the form of `username/repository@branch`, with the branch defaulting to `master`. The repository will be retrieved from github.

Any `npm` or `bundler` / `rubygems` dependencies specified in the optional `package.json` and `Gemfile` files will also be installed.

### Globally Installing Packages

The `install-global` command can be used to install packages into the global kindling directory (`/usr/var/kindling` on linux, `C:/ProgramData/woodstove/kindling` on windows, and `~/Library/Application Support/woodstove` on mac.) Any binaries specified by the package will be placed in the global bin directory (`/usr/local/bin` on linux or mac, and `C:/ProgramData/woodstove/bin` on windows). Specified dependencies will also be installed inside the `kindling` subdirectory of the packages installed.

```
woodstove install-global [packages]
woodstove i [packages]
```

Packages are formatted in the form of `username/repository@branch`, with the branch defaulting to `master`. The repository will be retrieved from github.

Any `npm` or `bundler` / `rubygems` dependencies specified in the optional `package.json` and `Gemfile` files will also be installed.

### Removing Packages

The `remove` command can be used to remove packages from the `kindling` subdirectory inside of the current working directory. Any binaries specified by the package will be removed from `kindling/.bin`.

```
woodstove remove [packages]
woodstove r [packages]
```

Packages are formatted in the form of `username/repository@branch`, with the branch defaulting to `master`.

### Globally Removing Packages

The `remove-global` command can be used to remove packages from the global kindling directory (`/usr/var/kindling` on linux, `C:/ProgramData/woodstove/kindling` on windows, and `~/Library/Application Support/woodstove` on mac.) Any binaries specified by the package will be removed from the global bin directory (`/usr/local/bin` on linux or mac, and `C:/ProgramData/woodstove/bin` on windows).

```
woodstove remove-global [packages]
woodstove rg [packages]
```

Packages are formatted in the form of `username/repository@branch`, with the branch defaulting to `master`.

### Starting the Package

The `start` command runs the `main` script for the package in the current working directory. This command can come in handy for managing deploying servers, etc., similar to the way that npm-based hosting services usually execute `npm start` for the package. This command is an alias for `woodstove exec main [args]`.

```
woodstove start [args]
woodstove s [args]
```

### Running Package Scripts

The `exec` command runs the specified script (defined in kindling.yaml, see the "Packaging Format" section below) for the package in the current working directory.

```
woodstove exec [script] [args]
woodstove x [script] [args]
```

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
  pything: foo.py   # Makes `woodstove exec pything` run `python foo.py`.
  nodey: bar.js     # Makes `woodstove exec nodey` run `node bar.js`.
  boop: explode.sh  # Makes `woodstove exec boop` run `bash explode.sh`.
  whatever: whatev  # Makes `woodstove exec whatever` run `whatev` (a binary file.)
bin:                # Makes scripts executable on the PATH.
  bar: main         # Makes `bar` run `ruby index.rb`.
```

## Installation

Woodstove can be easily installed via the rubygems package manager. If you have ruby, you already have rubygems.

Simply run the following command (with proper privileges) to install woodstove:
```
gem install woodstove
```
