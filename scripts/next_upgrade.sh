#!/bin/bash

cat ./next_upgrade.md

echo -e '\n\n'
echo 'type yes to confirm that you read it (will stop you otherwise)'
echo -e '\n'

read inp


if [[ ${inp} != 'yes' ]]; then
  echo 'you must answer yes litterally for the script to continue'
  exit 1
fi

exit 0                                  