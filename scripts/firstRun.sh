#!/bin/bash
# Copy the initial db creation to a temp file
# this will then be re-mounted as /var/lib/postgresql/9.3/main/
cp -r /var/lib/postgresql/9.3/main/* /var/lib/postgresql/9.3/main-save/
