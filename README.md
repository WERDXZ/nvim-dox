# Nvim-Dox 

**A Pure Lua Docstring Generator for NeoVim**

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Contribution](#contribution)
- [TODO](#todo)
- [Design](#design)
- [License](#License)

## Introduction 

***Please note: This plugin is still under active development.***

Expect significant changes in upcoming versions.

## Features

Nvim-Dox is designed to generate docstrings in NeoVim, offering:

- **API Exposure**: Easily register new docstring dialects.
- **TSNode Parsers**: Provides parsers for interpreting `TSNode`.
- **TSNode Queriers**: Queriers for retrieving the relevant `TSNode`.
- **Snippet Managers Integration**: Seamlessly integrates with snippet managers.

## Installation

Install Nvim-Dox using your preferred NeoVim plugin manager.

## Usage

- **Basic Usage**: Execute the `Dox` command to generate a docstring for the `TSNode` at the cursor position.
- **Specific Node Type**: Use the command `Dox <type>` to generate a docstring for the closest `TSNode` of type `<type>`.

## Contribution

Contributions are always welcome! Feel free to open a PR or raise an issue. I aim to respond as promptly as possible.

## TODO

| Feature                                          | Priority |
| ------------------------------------------------ | -------- |
| Configurability support                          | 1        |
| Organize API exposure                            | 1        |
| Standardize function style                       | 1        |
| Add documentation (`doc/vimdoc`)                 | 2        |
| Register keyword completion sources              | 2        |
| Support syntax highlighting for keywords         | 2        |
| Implement `Checkhealth` for troubleshooting      | 2        |
| Integrate with other snippet engines             | 2        |
| Develop `Dox generate` for document generation   | 3        |
| Support other document engines                   | 3        |
| Incorporate namespace/inheritance support (major change) | 4 |

## Design

A quick rundown of the plugin's operation:

1. Initiate the `Dox` command.
2. Fetch the `TSNode` through the specified `Querier` functions.
3. Load the relevant docstring template based on the current filetype.
4. Populate the template, replacing format masks using the `Parser`. This interprets the `Querier` results.
5. If a snippet engine is present, the generated string is registered.
6. Finally, the docstring is output.

## License

This project is under the MIT License. Refer to the [LICENSE](LICENSE) file for more details.
