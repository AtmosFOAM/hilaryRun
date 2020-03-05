#!/bin/bash -e

# Calculate horizontal means conditioned on vertical velocity and time average

time=1

writeuvw u -time $time

conditionalAverage -time $time uz 0 stable buoyant


