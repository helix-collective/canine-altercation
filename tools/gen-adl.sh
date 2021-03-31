#!/bin/bash

set -eu

SCRIPT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT=$SCRIPT_DIR/..
ADLC=$REPO_ROOT/tools/adlc

ADL_DIR=$REPO_ROOT/adl 
APP_ADL_FILES=$(find $ADL_DIR -type f)

$ADLC java --outputdir $REPO_ROOT/server/java/src \
  --searchdir $ADL_DIR \
  --package com.canine.game.adl \
  --include-rt \
  $APP_ADL_FILES
