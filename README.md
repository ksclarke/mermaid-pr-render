# mermaid-pr-render

A GitHub Action that uses the [Mermaid CLI](https://github.com/mermaid-js/mermaid-cli) to render [Mermaid](https://mermaid-js.github.io/mermaid/#/) diagrams in pull requests.

This action supports workflows which don't involve pushing directly to the main branch but, instead, require merges to main to go through a pull request from another branch.

## How to Use

Create a `mermaid.yml` action file in your project's `.github/workflows` directory. There are two examples included here: one that supports signed commits and one that doesn't. The first example is one without signed commits:

```
name: 'Mermaid PR Render'

on:
  pull_request:
    branches:
      - main
    paths:
      # Limit action runs to PRs that have Mermaid files (you can change to whatever suffix you use)
      - '**/*.mmd'

jobs:
  mermaid:
    runs-on: ubuntu-latest

    steps:

    - name: Check out code
      uses: actions/checkout@5a4ac9002d0be2fb38bd78e4b4dbde5606d7042f # v2.3.4
      with:
        # Checkout the head of the pull request, rather than the merge commit
        ref: ${{ github.event.pull_request.head.ref }}

    - name: Render Mermaid diagrams to SVG
      uses: ksclarke/mermaid-cli-action@main
      with:
        # These are the default values (see below for other parameters)
        mmd-pattern: "**/*.mmd"
        mmd-output: "svg"

    - name: Commit rendered SVG files
      uses: stefanzweifel/git-auto-commit-action@be7095c202abcf573b09f20541e0ee2f6a3a9d9b # v4.9.2
      with:
        # Change `file_pattern` to match your `mmd-output` parameter
        file_pattern: "*[.svg]"
        commit_message: Add automatically rendered Mermaid diagrams
```

<details>
<summary>View an example with signed commits</summary>
```
name: 'Mermaid PR Render'

on:
  pull_request:
    branches:
      - main
    paths:
      - '**/*.mmd'

jobs:
  mermaid:
    runs-on: ubuntu-latest

    steps:

    - name: Check out code
      uses: actions/checkout@5a4ac9002d0be2fb38bd78e4b4dbde5606d7042f # v2.3.4
      with:
        ref: ${{ github.event.pull_request.head.ref }}

    - name: Render Mermaid diagrams to SVG
      uses: ksclarke/mermaid-cli-action@main
      with:
        mmd-pattern: "**/*.mmd"
        mmd-output: "svg"

    - name: Import GPG key
      uses: crazy-max/ghaction-import-gpg@b0793c0060c97f4ef0efbac949d476c6499b7775 # v3.1.0
      with:
        # Put your private GPG key and passphrase in your project's secrets
        gpg-private-key: ${{ secrets.BUILD_KEY }}
        passphrase: ${{ secrets.BUILD_PASSPHRASE }}
        git-user-signingkey: true
        git-commit-gpgsign: true

    - name: Commit rendered SVG files
      uses: stefanzweifel/git-auto-commit-action@be7095c202abcf573b09f20541e0ee2f6a3a9d9b # v4.9.2
      with:
        file_pattern: "*[.svg]"
        commit_message: Add automatically rendered Mermaid diagrams
        # Include the bot (or account) whose GPG key you've stored)
        commit_user_name: Your Bot
        commit_user_email: your_bot@example.com
```
</details>

This will run the action when a pull request is opened and update the PR branch with the rendered Mermaid diagram. The rendered diagram is stored in the same directory as the source Mermaid text file. The rendered diagram can then be referenced from the documentation page (e.g. README.md or ARCHITECTURE.md) using an `img` tag.
