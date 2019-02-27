#!/bin/sh

release_ctl eval --mfa "Aptamer.ReleaseTasks.migrate/1" --argv -- "$@"
