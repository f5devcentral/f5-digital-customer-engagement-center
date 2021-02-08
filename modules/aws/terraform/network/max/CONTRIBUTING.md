# How to Contribute

This project is [Apache 2.0 licensed](LICENSE) and accept contributions via
GitHub pull requests. This document outlines some of the conventions on
development workflow, commit message formatting, contact points and other
resources to make it easier to get your contribution accepted.

## Certificate of Origin

By contributing to this project you agree to the Developer Certificate of
Origin (DCO).

## Security Response

If you've found a security issue that you'd like to disclose confidentially, please contact F5 Security team.

## Getting Started

- Fork the repository on GitHub
- Read the [README](README.md) for build and test instructions
- Play with the project, submit bugs, submit patches!

### Contribution Flow

Anyone may [file issues][new-issue].
For contributors who want to work up pull requests, the workflow is roughly:

1. Create a topic branch from where you want to base your work (usually master).
2. Make commits of logical units.
3. Make sure your commit messages are in the proper format (see [below](#commit-message-format)).
4. Push your changes to a topic branch in your fork of the repository.
5. Make sure the tests pass, and add any new tests as appropriate.
6. Submit a pull request to the original repository.
7. The repo owners will respond to your issue promptly, following [the ususal Prow workflow][prow-review].

Thanks for your contributions!

## Coding and Documenting Style

All the use cases should be developed and documented in a repeatable manner. In another word, you should include all the pieces neccessary for the user to dulplicate the use case in his/her own lab: 
- Description of SRE use case with topology
- Pre-requisites and dependencies
- Step-by-step installation and deployment/implementation guide, with screenshots as needed
- All the code/script/configuration/manifest used
- List of limitations if any
- Troubleshooting if possible


## Commit Message Format

We follow a rough convention for commit messages that is designed to answer two
questions: what changed and why. The subject line should feature the what and
the body of the commit should describe the why.

```
scripts: add the test-cluster command

this uses tmux to set up a test cluster that you can easily kill and
start for debugging.

Fixes #38
```

The format can be described more formally as follows:

```
<subsystem>: <what changed>
<BLANK LINE>
<why this change was made>
<BLANK LINE>
<footer>
```

The first line is the subject and should be no longer than 70 characters, the
second line is always blank, and other lines should be wrapped at 80 characters.
This allows the message to be easier to read on GitHub as well as in various
git tools.
