#!/bin/bash
#raspivid -o - -t 0 -w 640 -h 480 -fps 75|cvlc -vvv stream:///dev/stdin --sout '#standard{access=http,mux=mjpeg,dst=:8090}' :demux=h264
#good one
raspivid -o - -t 0 -w 1280 -h 720 -fps 25|cvlc -vvv stream:///dev/stdin --sout '#rtp{sdp=rtsp://:8554/}' :demux=h264
#testing
#raspivid -o - -t 0 -hf -w 1280 -h 720 -fps 60|cvlc -vvv stream:///dev/stdin --sout '#standard{access=http,mux=ts,dst=:8090}' :demux=h264
