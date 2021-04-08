# mermaid-cli-action

A GitHub Action that uses the [Mermaid CLI](https://github.com/mermaid-js/mermaid-cli) Docker image to render [Mermaid](https://mermaid-js.github.io/mermaid/#/) diagrams in pull requests.

## How to Use

Create a `mermaid.yml` action file in your project's `.github/workflows` directory. It should look something like: 

```
name: 'Render Mermaid'

on:
  pull_request:
    paths:
      - '**/*.mmd'

jobs:
  mermaid:
    runs-on: ubuntu-latest

    steps:

    - uses: actions/checkout@5a4ac9002d0be2fb38bd78e4b4dbde5606d7042f # v2.3.4
      with:
        fetch-depth: 2

    - name: Render Mermaid diagrams to SVG
      uses: ksclarke/mermaid-cli-action@main # still in development
      with:
        mmd-pattern: "**/*.mmd"
        mmd-output: "svg"

    - name: Commit rendered SVG files
      uses: stefanzweifel/git-auto-commit-action@be7095c202abcf573b09f20541e0ee2f6a3a9d9b # v4.9.2
      with:
        file_pattern: "*[.svg]"
        commit_message: Add automatically rendered Mermaid diagrams
```

This will run the action when a pull request is opened and update the PR branch with the rendered Mermaid diagram. The rendered diagram is stored in the same directory as the source Mermaid text file. The rendered diagram can then be referenced from the documentation page (e.g. README.md) using an `img` tag.
