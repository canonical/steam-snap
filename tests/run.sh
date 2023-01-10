#!/bin/bash

dir=$(dirname $0)
`$dir/glx` && echo "GLX passed" || echo "GLX failed"
`$dir/vulkan` && echo "Vulkan passed" || echo "Vulkan failed"
