#!/bin/bash

app_type=dispatch
app_Service=Dispatch

source ./Common.sh

App_Setup

Check_Root

Golang_Setup

Systemd_Setup

Print_Time
