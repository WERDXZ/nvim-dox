# Nvim-Dox 

**A Pure Lua Docstring Generator for NeoVim**

## Table of Contents

- [Introduction](#introduction)
- [Installation](#installation)
- [Usage](#usage)
- [Contribution](#contribution)
- [TODO](#todo)
- [Design](#design)
- [License](#License)

## Introduction 

***Please note: This plugin is still under active development.***

Expect significant changes in upcoming versions.

Currently, the main infrastructure of the plugin is in place. For now, its only functionality is the `Dox file` command for Doxygen.

Nvim-Dox is designed to generate docstrings in NeoVim. It's highly customizable and offers:

- API exposure to register new docstring dialects.
- Parsers for interpreting `TSNode`.
- Queriers for retrieving the `TSNode`.
- Integration with snippet managers.

## Installation

You can install Nvim-Dox using your preferred NeoVim plugin manager.

## Usage

- Use the command `Dox` to generate a docstring corresponding to the `TSNode` at the cursor position.
- Use the command `Dox <type>` to generate a docstring for the nearest `TSNode` of type `<type>`.

## Contribution

Feel free to open a PR or raise an issue. I'll respond as promptly as possible.

## TODO

| Item                                           | Priority |
| ---------------------------------------------- | -------- |
| Comprehensive `<type>` support                 | 0        |
| Full Doxygen compatibility                     | 0        |
| Configurability support                        | 1        |
| Keyword completion source registration         | 2        |
| Syntax highlighting support for keywords       | 2        |

## Design

Here's a brief overview of how the plugin works:

1. Invoke `Dox` command.
2. Retrieve the `TSNode` using the defined `Querier` functions.
3. Access the appropriate docstring template for the current filetype.
4. Populate the template by substituting format masks with results from the `Parser`, which interprets the results from the `Querier`.
5. If a snippets engine is available, register the generated string with it.
6. Output the final docstring.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
