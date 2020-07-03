#!/bin/sh
case "$1" in
  'sh')
    exec sh
    ;;
  *)
    confd -onetime -backend env
    /bin/pd $@
    ;;
esac
