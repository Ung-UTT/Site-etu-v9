#!/bin/bash

[ "$1" = "--i-have-coffee" ] || { echo 'Are you crazy?'; exit 1; }

rake import:users:insert import:schedules:insert import:mysql

