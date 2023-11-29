# template

This is a template used to create a new repository

:warning: DO NOT USE IT DIRECTLY BUT USE THE MANUAL WORKFLOW LOCATED [HERE](https://github.com/pbstck/pubstack/actions/workflows/create-repository.yaml) :warning:

## What is included in it 
Template of Makefile, infra with assume role, CI, CD, lint-pr-title action

## What do I need to do

replace all "REPLACE_ME" or "TODO" in all files
You need to :
- modify [CI.yaml](.github/workflows/CI.yaml) to match your language
- modify the [Makefile](./Makefile), especially following goal :
  - build
  - test
  - lint/check
  - lint/format
  - run
  - deliver
  - _retrieve_artifacts


