#!/bin/bash

[ "$1" = "--i-have-coffee" ] || { echo 'Are you crazy?'; exit 1; }

rake import:users:insert
rake import:schedules:insert
rake import:mysql

