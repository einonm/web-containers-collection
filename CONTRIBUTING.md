# Contributing to this project
Thank you for your interest in contributing! This guide details how to contribute in a way that is easy for everyone.

The following is a set of guidelines for contributing to this project.
These are mostly guidelines, not rules. Use your best judgement, and feel free to propose changes to this document in a merge request.

## Code of Conduct
We want to create a welcoming environment for everyone who is interested in contributing. Please see the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md) file to learn more about our commitment to an open and welcoming environment.

## Reporting Issues
Found a problem? Want to propose a new feature? First of all see if your issue or idea has [already been reported](../../issues).
If not, just open a [new clear and descriptive issue](../../issues/new).

## Submitting changes
The general flow of making a contribution to this project, such as a bug fix, documentation update or feature implementation is:

1. [Create a fork](https://docs.gitlab.com/ee/user/project/repository/forking_workflow.html#creating-a-fork) of the project in your own personal namespace.
2. Make your changes in your fork, as one or more commits.
3. When you're ready, [create a new merge request](https://docs.gitlab.com/ee/user/project/merge_requests/creating_merge_requests.html). In the merge request's description, ensure you provide complete and accurate information.
4. Assign the merge request (if possible) to, or [mention](https://docs.gitlab.com/ee/user/discussions/index.html#mentions), one of the project owners for the relevant project, and explain that your changes are ready for review.

## Style guides

A consistent style makes the job of reading code and changes easier, allowing the reader to concentrate on the content of the change. A style guide ensures consistency of style, particularly when used with an automated style checking program.

### Git commit messages
Follow the [git commit message best practices](https://chris.beams.io/posts/git-commit/), which boil down to:

1. Separate subject from body with a blank line
2. Use the present tense ("Add feature" not "Added feature")
3. Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
4. Wrap the body at 72 characters
5. Use the body to explain what and why vs. how

### Documentation styles
Plain text or markdown documents are preferred.

### Coding styles and automated style checkers
Each of the tools below check for adherence to a particular, widely adopted coding style:

* For Bash shell scripts, use [ShellCheck](https://www.shellcheck.net/)
* For Python code, use [Black](https://pypi.org/project/black/)
* For R code, use [Lintr](https://github.com/jimhester/lintr)
