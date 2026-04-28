---
myst:
  html_meta:
    "description lang=en":
      "Help us document the Steam snap on Ubuntu."
---

(contribute::documentation)=
# Documentation

This guide provides information necessary to contribute to this documentation.
If you're contributing for the first time, you might find the Canonical Open
Documentation Academy has helpful resources to
[get you started](https://documentation.academy/docs/howto/get-started/).

## Report an issue

To report a mistake on any page, or highlight some missing documentation,
[file an issue](https://github.com/canonical/steam-snap) in our
issues list on GitHub.

You can do this using the {guilabel}`Give feedback` button on any page, which will open a
new issue.

Make sure to provide enough information in the issue for us to understand what
is needed.

## Contribute on GitHub

If you are familiar with a Git development workflow, `fork` the
[Steam snap repository](https://github.com/canonical/steam snap)
and contribute your change as a
[pull request](https://github.com/canonical/steam-snap/pulls).

### Directory structure

All the documentation files are located in the `docs/` directory. The `docs/`
directory contains sub-directories according to the type of content.

All content is written and split according to the principles of
[Diátaxis](https://diataxis.fr/). It is then organized for our readers
according to who is using it, and how.

## Build the documentation locally

Follow these steps to build the documentation on your local machine.

### Prerequisites

* Git
* The `make` tool

    ```{note}
    The `make` command is compatible with Unix systems. On Windows,
    [install Ubuntu with WSL](https://documentation.academy/docs/howto/get-started/using_wsl/).
    ```

### Procedure

1. Fork the [Steam snap repository](https://github.com/canonical/steam-snap). Visit [Fork a repository](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo) for instructions.

2. Clone the repository to your machine:
    ```none
    git clone git@github.com:<your_user_name>/steam-snap.git
    ```

3. Create a new branch:
    ```none
    git checkout -b <your_branch_name>
    ```

4. Change to the `docs/` directory and make your contribution:
    ```none
    cd docs
    ```

5. Build a live preview of the documentation from within the `docs/` directory:
    ```none
    make run
    ```
    You can find all the HTML files in the `.build/` directory.

    `make run` uses the Sphinx `autobuild` module, so that any edits you make (and save) as you work are applied, and the built HTML files refresh immediately.

6. Review your contribution in a web browser by navigating to [`127.0.0.1:8000`](http://127.0.0.1:8000/).

7. Push your contribution to GitHub and create a pull request against the original repository.

## Documentation format

The Steam on Ubuntu documentation is built with Sphinx using a combination of the MyST flavor of the Markdown.

* [MyST style guide](https://canonical-starter-pack.readthedocs-hosted.com/stable/reference/myst-syntax-reference/)

## Testing the documentation

Test your changes before submitting a pull request. Run the following commands from within the `docs/` directory to test the documentation locally:

| command  | use |
|---------|-----|
| `make spelling` | Check for spelling errors |
| `make linkcheck` | Check for broken links |
| `make woke` | Check for non-inclusive language |
| `make pa11y` | Check for accessibility issues |
