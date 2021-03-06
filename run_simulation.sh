#!/bin/bash

# example: ./run_simulation.sh parking true
# example: ./run_simulation.sh street false

# Make sure that the .yaml and .pgm files are in the nav2_bringup/maps and
# nav2_bringup/worlds directories
# param1: name of the environment (e.g. "parking" automtically becomes "map_parking.yaml", "world_parking.model")
# param2: true to run simulaton, false to build only

# Modify launch file map and world names
cd navigation2/nav2_bringup/bringup/launch/
awk '{gsub(/map+\_+[a-z+0-9]+\.+yaml/, "map_'$1'.yaml")}1' tb3_simulation_launch.py > tb3_simulation_launch_new.py
mv tb3_simulation_launch_new.py tb3_simulation_launch.py
awk '{gsub(/world+\_+[a-z+0-9]+\.+model/, "world_'$1'.model")}1' tb3_simulation_launch.py > tb3_simulation_launch_new.py
mv tb3_simulation_launch_new.py tb3_simulation_launch.py

# Build the simulation
cd ../../../../../
colcon build --packages-select nav2_bringup --allow-overriding nav2_bringup
colcon build --packages-select-by-dep nav2_bringup

# Source ROS2
source ./install/setup.bash

# Run it!
if ($2 == true) then
  ros2 launch nav2_bringup tb3_simulation_launch.py
fi
