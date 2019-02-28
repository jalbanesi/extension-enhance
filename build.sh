#!/bin/bash
cd project
haxelib run hxcpp Build.xml -Dandroid
haxelib run hxcpp Build.xml -Dandroid -DHXCPP_ARMV7
cd ..
