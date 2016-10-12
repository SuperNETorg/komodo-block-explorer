# zcash-block-explorer
Script to install and setup a zcash block explorer on Ubuntu 16.04

On a fresh Ubuntu 16.04 server, from a non-root user's home directory, run the following commands:

wget https://raw.githubusercontent.com/radix42/zcash-block-explorer/master/block-explorer.sh
bash block-explorer.sh

The command to run the block explorer is output at the end of the script. 
The server runs in the foreground, and for production use you will want to run it in a tmux or screen session, or under a process manager such as supervisor.

All actions performed by the script are thouroughly commented. 

Blockchain explorer patches for zcashd by @str4d. This script and docs created under a commission by noashh.
