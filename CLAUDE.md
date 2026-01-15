# CLAUDE.md - AI Assistant Guide for brew-mac

This document provides comprehensive guidance for AI assistants working on the brew-mac Chef cookbook.

## Project Overview

**brew-mac** is a Chef cookbook that automates macOS developer environment setup. It eliminates manual configuration ("yak shaving") by installing and configuring development tools, applications, and environments in a single automated run.

- **Type**: Chef Cookbook
- **Target Platform**: macOS
- **Version**: 0.1.0
- **Maintainer**: Karthik Muthupalaniappan
- **Primary Language**: Ruby (Chef DSL)
- **License**: all_rights

## Repository Structure

```
/home/user/brew-mac/
├── .github/
│   ├── workflows/main.yml           # CI/CD pipeline (runs tests & linting)
│   └── pull_request_template.md     # PR documentation template
├── attributes/
│   └── default.rb                   # Default attribute values (GitHub account, dotfiles path)
├── recipes/                         # Main cookbook logic
│   ├── default.rb                   # Orchestrates all recipes (entry point)
│   ├── brew.rb                      # Homebrew packages/casks installation
│   ├── gems.rb                      # Ruby gems installation (Rails, Bundler, Pry)
│   ├── utilities.rb                 # Shell environment setup (oh-my-zsh, rbenv, SDKMAN)
│   ├── pip.rb                       # Python packages installation
│   ├── npm-packages.rb              # Node.js global packages
│   └── dotfiles.rb                  # Clone user's dotfiles repository
├── spec/
│   ├── spec_helper.rb               # ChefSpec test configuration
│   └── unit/recipes/default_spec.rb # Unit tests for recipes
├── .kitchen.yml                     # Test Kitchen integration test configuration
├── Gemfile                          # Ruby dependencies for testing
├── Berksfile                        # Chef cookbook dependencies
├── chefignore                       # Files excluded from Chef Server uploads
├── metadata.rb                      # Cookbook metadata (name, version, maintainer)
├── .gitignore                       # Git ignore patterns
└── README.md                        # User-facing documentation
```

## Codebase Architecture

### Recipe Execution Flow

The `default.rb` recipe orchestrates all sub-recipes in this order:

1. **brew.rb** - Install Homebrew packages and applications
2. **gems.rb** - Set up Ruby environment and install gems
3. **pip.rb** - Install Python packages via pip
4. **utilities.rb** - Configure shell environment (zsh, rbenv, SDKMAN, tmux, vim)
5. **npm-packages.rb** - Install global npm packages
6. **dotfiles.rb** - Clone personal dotfiles repository

### Recipe Details

#### recipes/brew.rb
Installs packages via Homebrew in categories:

- **Productivity tools**: ack, archey, autojump, tmux, fd, bat, jq, git, etc.
- **Utility packages**: tree, htop, git-extras, httpie, fzf, ncdu, jid
- **QuickLook plugins**: qlcolorcode, qlmarkdown, quicklook-json, betterzip, etc.
- **Applications (casks)**: flux, docker, spotify, postman, 1password, VSCode, etc.
- **Development tools**: vim, rbenv, maven, kafka, mysql, npm, openjdk@17

**Pattern**: Uses arrays + `.each` loops for batch installations

```ruby
packages.each do |package|
  homebrew_package package do
    action :install
  end
end
```

#### recipes/gems.rb
- Installs Ruby 3.2.2 via rbenv
- Installs pinned gems: bundler (~2.4.0), rails (~7.0.0), pry (~0.14.0)
- Uses version constraints for stability

#### recipes/pip.rb
- Installs pip via get-pip.py
- Installs exact versions: requests (2.31.0), nose (1.3.7), awscli (1.29.0)

#### recipes/utilities.rb
- Installs oh-my-zsh with checksum verification
- Configures autoenv for auto-sourcing environment files
- Sets up rbenv in .zshrc
- Installs SDKMAN for JVM tool management
- Installs Tmux Plugin Manager (tpm)
- Configures Vim

#### recipes/npm-packages.rb
- Installs global npm packages: todo, tldr

#### recipes/dotfiles.rb
- Clones user's dotfiles from GitHub
- Uses attributes: `node['brew-mac']['github_account']` and `node['brew-mac']['dotfiles_name']`

### Attributes

Located in `attributes/default.rb`:

```ruby
default['brew-mac']['github_account'] = 'kmuthupa'
default['brew-mac']['dotfiles_name'] = 'dotfiles'
default['brew-mac']['temp_dir'] = "#{Dir.home}/Documents/dotfiles"
```

## Development Workflows

### Testing Strategy

This cookbook uses a comprehensive testing approach:

#### 1. Unit Testing (ChefSpec)
- **Location**: `spec/unit/recipes/default_spec.rb`
- **Framework**: ChefSpec + RSpec
- **Purpose**: Verify recipe convergence and resource creation
- **Run**: `bundle exec rspec`

Tests verify:
- Recipe convergence succeeds
- All sub-recipes are included
- Specific packages are installed
- Shell commands execute properly

#### 2. Linting (Cookstyle)
- **Tool**: Cookstyle (Chef's official linter, replaces Foodcritic)
- **Run**: `bundle exec cookstyle`
- **Purpose**: Enforce Chef best practices and Ruby style

#### 3. Integration Testing (Test Kitchen)
- **Config**: `.kitchen.yml`
- **Driver**: Vagrant
- **Platform**: CentOS 7.1 (for testing purposes)
- **Run**: `kitchen test`

### CI/CD Pipeline

GitHub Actions workflow (`.github/workflows/main.yml`):

**Triggers**: Push/PR to master branch
**Platform**: macOS-latest
**Steps**:
1. Checkout code
2. Setup Ruby 3.2.2 with bundler caching
3. Install dependencies (`bundle install`)
4. Run unit tests (`bundle exec rspec`)
5. Run cookstyle linting (`bundle exec cookstyle`)

### Development Process

1. **Making Changes**:
   - Modify recipes in `recipes/` directory
   - Update attributes in `attributes/default.rb` if needed
   - Follow Chef DSL conventions

2. **Testing Locally**:
   ```bash
   bundle install
   bundle exec rspec           # Run unit tests
   bundle exec cookstyle       # Run linting
   ```

3. **Running the Cookbook**:
   ```bash
   chef-client -z -o brew-mac  # Local mode execution
   ```

4. **Pull Requests**:
   - Use the PR template (`.github/pull_request_template.md`)
   - Document dependency updates, security improvements, testing performed
   - Ensure CI pipeline passes

## Key Conventions & Best Practices

### 1. Version Pinning

**Critical**: All major dependencies use version constraints for reproducibility

- Ruby: 3.2.2 (exact)
- Rails: ~7.0.0 (pessimistic)
- Bundler: ~2.4.0 (pessimistic)
- Pip packages: Exact versions (e.g., requests==2.31.0)
- Java: OpenJDK@17 (LTS version)

**When updating versions**: Update in multiple places:
- Recipe files (e.g., `recipes/gems.rb`)
- GitHub Actions workflow (`.github/workflows/main.yml`)
- Tests (`spec/unit/recipes/default_spec.rb`)

### 2. Security Practices

- **Checksum verification**: Always verify checksums for downloaded scripts
- **SSL verification**: Ensure proper certificate verification
- **Error handling**: Use `not_if` guards and proper error handling
- **File permissions**: Set appropriate permissions (755 for executables)
- **No shell injection**: Avoid string interpolation in shell commands

### 3. Idempotency

All recipes must be idempotent (safe to run multiple times):

```ruby
bash 'install oh-my-zsh' do
  code <<-EOH
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  EOH
  not_if { ::File.exist?("#{Dir.home}/.oh-my-zsh") }  # Prevents re-installation
end
```

### 4. Resource Organization

- Group related packages in arrays
- Use descriptive variable names (`productivity_packages`, `dev_packages`)
- Separate concerns into different recipes
- Comment package groups clearly

### 5. Chef DSL Patterns

**Homebrew packages**:
```ruby
homebrew_package 'package-name' do
  action :install
end
```

**Homebrew casks**:
```ruby
homebrew_cask 'app-name' do
  action :install
end
```

**Bash execution**:
```ruby
bash 'description' do
  code <<-EOH
    shell commands here
  EOH
  not_if { condition }
end
```

### 6. File Headers

All recipe files include copyright headers:
```ruby
#
# Cookbook Name:: brew-mac
# Recipe:: recipe_name
#
# Copyright (c) 2025 Karthik Muthupalaniappan, All Rights Reserved.
```

## Common Tasks for AI Assistants

### Adding a New Homebrew Package

1. Identify the appropriate category in `recipes/brew.rb`
2. Add to the relevant array (productivity_packages, utility_packages, etc.)
3. Update tests in `spec/unit/recipes/default_spec.rb`

### Adding a New Recipe

1. Create `recipes/new_recipe.rb` with proper header
2. Add `include_recipe 'brew-mac::new_recipe'` to `recipes/default.rb`
3. Create corresponding test in `spec/unit/recipes/`
4. Run tests and linting

### Updating Ruby/Python/Node Versions

1. Update version in recipe file (e.g., `recipes/gems.rb`)
2. Update `.github/workflows/main.yml` if Ruby version
3. Update tests to expect new version
4. Test locally before committing

### Debugging Recipe Failures

1. Run with verbose output: `chef-client -z -o brew-mac -l debug`
2. Check Test Kitchen logs: `kitchen converge`
3. Verify idempotency: Run twice, second run should make no changes
4. Check resource guards (`not_if`, `only_if`)

## Important Notes

### Platform Compatibility

- **Target Platform**: macOS only
- Test Kitchen uses CentOS for basic validation, but cookbook is macOS-specific
- Many resources (homebrew_package, homebrew_cask) only work on macOS

### Dependencies

**Ruby Gems** (installed via Gemfile):
- chefspec, berkshelf, rspec, fauxhai
- foodcritic, rubocop, cookstyle
- test-kitchen, kitchen-vagrant

**System Requirements**:
- macOS with Homebrew installed
- Chef DK or Chef Workstation
- Git for version control

### Git Workflow

- **Main Branch**: master
- **Development Branches**: Use descriptive names (e.g., `claude/add-claude-documentation-hH0GC`)
- **Commit Messages**: Clear, descriptive, focus on "why" not "what"
- **Branch Protection**: Push to master requires passing CI

### Files to Ignore

**Never commit** (per .gitignore):
- `.vagrant/`, `Berksfile.lock`, `Gemfile.lock`
- `.kitchen/`, `.kitchen.local.yml`
- `.DS_Store`, `Thumbs.db`

**Never upload to Chef Server** (per chefignore):
- Tests, specs, CI configs
- Git files, editor configs
- Documentation (README, etc.)

## Execution Example

```bash
# Install Chef Workstation
# Download from: https://downloads.chef.io/chef-workstation/

# Clone repository
mkdir cookbooks && cd cookbooks
git clone git@github.com:kmuthupa/brew-mac.git

# Install dependencies
cd brew-mac
bundle install

# Run tests
bundle exec rspec
bundle exec cookstyle

# Execute cookbook
chef-client -z -o brew-mac
```

## Recent Project Changes

**Modernization (2025)**:
- Updated Ruby to 3.2.2
- Replaced Java 8 with OpenJDK 17 (LTS)
- Modernized pip installation
- Added comprehensive CI/CD pipeline
- Enhanced security with checksums and error handling
- Improved test coverage

## Quick Reference

### Running Tests
```bash
bundle exec rspec                           # Unit tests
bundle exec cookstyle                       # Linting
bundle exec cookstyle --auto-correct        # Auto-fix issues
kitchen test                                # Full integration test
kitchen converge                            # Run cookbook in test VM
```

### Common Chef Commands
```bash
chef-client -z -o brew-mac                  # Run cookbook locally
chef-client -z -o brew-mac -l debug         # Debug mode
berks install                               # Install cookbook dependencies
```

### File Locations
- Recipes: `recipes/*.rb`
- Tests: `spec/unit/recipes/*_spec.rb`
- Attributes: `attributes/default.rb`
- CI Config: `.github/workflows/main.yml`

---

**Last Updated**: 2026-01-15
**Document Version**: 1.0.0
**Target Audience**: AI Assistants (Claude, etc.)
