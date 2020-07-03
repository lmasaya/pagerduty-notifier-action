#!/bin/sh
confd -onetime -backend env
/bin/pd event-v2 manage /root/event.json
