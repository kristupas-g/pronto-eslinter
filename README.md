## Pronto eslinter

Yet another `eslint` runner for the pronto ecosystem. This one provides support for warnings and suggestions.

### Installation

```bash
gem install pronto-eslint
```

Or add it to your Gemfile:

```ruby
gem 'pronto-eslint'
```

Add the following to your `.pronto.yml`:

```yaml
eslinter:
  suggestions: true # default: false
runners:
  - eslinter
```

### Configuration

#### ESlint:
ESlint will look at your `eslint.config.js` file for configuration.

#### Command Line:
You can change how ESLint is called from the command line by adding the following to your `.pronto.yml`:


```yaml
eslinter:
  command: 'yarn -s run eslint' # default: 'npx eslint'
```

### Usage

```bash
pronto run
```
