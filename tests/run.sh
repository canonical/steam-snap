#!/bin/bash

test glx 2>&1> /dev/null && echo "GLX passed" || echo "GLX failed"
test vulkan 2>&1> /dev/null && echo "Vulkan passed" || echo "Vulkan failed"
