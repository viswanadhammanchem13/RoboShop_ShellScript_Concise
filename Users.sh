#!/bin/bash

app_type=user

app_Service=User

source ./Common.sh

App_Setup

Check_Root

NodeJS_Setup

Systemd_Setup

Print_Time
