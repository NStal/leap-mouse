#!/usr/bin/python
# -*- coding: utf-8 -*- 

from Xlib import X
from Xlib.display import Display
from Xlib.ext.xtest import fake_input
from pymouse import PyMouse
import os
mouse = PyMouse()

d = Display()
screen = d.screen()
root = screen.root

def warp(x,y):
    root.warp_pointer(x,y)
    d.sync()
def move(x,y):
    position = getMousePosition()
    warp(position[0]+x,position[1]+y) 
def getMousePosition():
    result = root.query_pointer()
    return (result.root_x,result.root_y)
def mouseDown(button = 1):
    #os.system("xdotool mousedown 1") 
    fake_input(d, X.ButtonPress, button)
    d.sync()
def mouseUp(button = 1):
    
    #os.system("xdotool mouseup 1") 
    fake_input(d, X.ButtonRelease,button)
    d.sync()
