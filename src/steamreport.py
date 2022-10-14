#!/usr/bin/python3

import os
import sys
import webbrowser
import json
import argparse

def dict_to_string(d, n = 0):
    s = ""
    for key in d:
        s += f"{'    ' * n}{key}: "
        if (type(d[key]) is dict):
            s += "\n" + dict_to_string(d[key], n + 1)
        else:
            s += d[key]
        s += "\n"
    return s

def gather_data():
    data = {}

    # Game
    data["game"] = args.game

    # glxinfo -B
    glxinfo = {}
    for line in os.popen("glxinfo -B").read().split("\n"):
        line = line.strip()
        if (not line): continue
        key, val = line.split(":", 1)
        glxinfo[key] = val

    data["glxinfo"] = {
        "gpu": glxinfo["OpenGL vendor string"],
        "gpu_version": glxinfo["OpenGL core profile version string"]
    }

    # SNAP_REVISION
    data["snap_info"] = {
        "revision": os.environ["SNAP_REVISION"]
    }

    # os-release
    os_release = {}
    with open("/var/lib/snapd/hostfs/etc/os-release", "r") as reader:
        for line in reader:
            line = line.strip()

            if (not line):
                continue

            key, val = line.split("=", 1)
            os_release[key] = val

    data["os_release"] = {
        "name": os_release["NAME"],
        "version": os_release["VERSION"],
    }

def submit_data(data):
    url = "https://github.com/canonical/steam-snap/discussions/new?category=game-reports"
    if (not args.no_submit):
        url += f"&title=Report: {data['game'].capitalize()}"
        url += "&body={}".format(dict_to_string(data).replace("\n", "%0A"))
        print("Opening web browser...")
        webbrowser.open_new_tab(url)

parser = argparse.ArgumentParser()
parser.add_argument(
    "game",
    help="Name of the game to report",
    default="GAME_NAME"
)
parser.add_argument(
    "--no-submit", "-n",
    help="Do not open web browser to submit issue.",
    const=True,
    action="store_const"
)
args = parser.parse_args()

failure = os.system("snapctl is-connected system-observe")

if (failure):
    raise Exception("Outside of the snap, run:\nsnap connect steam:system-observe")

data = gather_data()
print(dict_to_string(data))
submit_data(data)