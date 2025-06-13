# direnv Configuration

This directory contains global direnv configuration templates.

## Files

- `direnvrc.template` - Global direnv configuration template for extensions and common functions

## Setup

### 1. Copy Global direnv Configuration

```bash
cp config/direnv/direnvrc.template ~/.config/direnv/direnvrc
```

## Usage

This template provides global direnv configuration that is loaded before every `.envrc` file. It allows you to define custom functions and extensions that will be available across all your projects.

## Note

For project-specific environment variables, use the template located in `config/envrc/.envrc.template` and copy it to your project root as `.envrc`.