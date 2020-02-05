import tkinter as TK
import zaber.serial as ZS
import threading as THREAD
import cv2 as CV
import mss as MSS
import numpy as NP
import time as TIME

moveLeft = 0; moveDown = 0; moveUp = 0; moveRight = 0
focusUp = 0; focusDown = 0
rotateCW = 0; rotateCCW = 0
speed = 600

stage1_pos = {"x" : 0, "y" : 0}
sharpness = 0
stage1_focus = 0

def start_left(*args):
    global moveLeft
    moveLeft = 1

def start_right(*args):
    global moveRight
    moveRight = 1

def start_up(*args):
    global moveUp
    moveUp = 1

def start_down(*args):
    global moveDown
    moveDown = 1

def start_cw(*args):
    global rotateCW
    rotateCW = 1

def start_ccw(*args):
    global rotateCCW
    rotateCCW = 1

def start_fup(*args):
    global focusUp
    focusUp = 1

def start_fdn(*args):
    global focusDown
    focusDown = 1

def stop(*args):
    print("stopping...")
    global moveLeft, moveRight, moveUp, moveDown, rotateCW, rotateCCW, focusUp, focusDown
    moveLeft = 0
    moveRight = 0
    moveUp = 0
    moveDown = 0
    rotateCW = 0
    rotateCCW = 0
    focusUp = 0
    focusDown = 0

def motorThread():
    global moveLeft, moveRight, moveUp, moveDown, rotateCW, rotateCCW, focusUp, focusDown
    global speed, speedbar
    global stage1_x, stage1_y, stage1_r, stage1_f
    print ("motor daemon thread started...")
    speedbar.set(600)
    while True:
        speed = speedbar.get()
        #stage1_pos["x"] = int(stage1_x.send("get pos").data)
        #stage1_pos["y"] = int(stage1_y.send("get pos").data)
        if (moveLeft == 1):
            stage1_x.move_rel(-speed, blocking=False)
        if (moveRight == 1):
            stage1_x.move_rel(speed, blocking=False)
        if (moveUp == 1):
            stage1_y.move_rel(-speed, blocking=False)
        if (moveDown == 1):
            stage1_y.move_rel(speed, blocking=False)
        if (rotateCW == 1):
            stage1_r.move_rel(int(speed/2), blocking=False)
        if (rotateCCW == 1):
            stage1_r.move_rel(-int(speed/2), blocking=False)
        if (focusUp == 1):
            stage1_f.move_rel(int(speed/2), blocking=False)
        if (focusDown == 1):
            stage1_f.move_rel(-int(speed/2), blocking=False)

def getSharpness():
    global viewport, speed
    global Mss
    prntsc = Mss.grab(viewport)
    img = NP.array(prntsc)
    img = CV.cvtColor(img, CV.COLOR_BGR2GRAY)
    img = CV.normalize(img, img, 255, 0, CV.NORM_MINMAX)
    img_b = CV.GaussianBlur(img, (17, 17), 0)
    img = CV.subtract(img, img_b)

    img_f = NP.fft.fft2(img)
    img_mag = NP.abs(img_f)

    hf_sum = NP.sum(img_mag)
    print("Sharpness: ", hf_sum)
    return hf_sum

def findFocus():
    global sharpness, speed
    resolution = int(speed/10)
    
    origPos = int(stage1_f.send("get pos").data)
    maxFocusPos = origPos
    print("current position is ", origPos)
    
    maxFocus = getSharpness()

    #search up and down for 7*r microsteps each for max focus
    for i in range(6):
        stage1_f.move_rel(-(i + 1) * resolution, blocking = True)
        TIME.sleep(0.05)
        sharpness = getSharpness()
        TIME.sleep(0.3)
        if (maxFocus < sharpness):
            maxFocus = sharpness
            maxFocusPos = int(stage1_f.send("get pos").data)
            print("New max at pos ", maxFocusPos)

    #move back to search in the other dirn
    stage1_f.move_abs(origPos)
    
    for j in range(6):
        stage1_f.move_rel((j + 1) * resolution, blocking = True)
        TIME.sleep(0.05)
        sharpness = getSharpness()
        TIME.sleep(0.3)
        if (maxFocus < sharpness):
            maxFocus = sharpness
            maxFocusPos = int(stage1_f.send("get pos").data)
            print("New max at pos ", maxFocusPos)

    #move to the point of max focus
    stage1_f.move_abs(maxFocusPos)
    print("final position is ", maxFocusPos)
        

Mss = MSS.mss()
viewport = {"top": 200, "left": 600,
            "width": 600, "height": 600}

motorDaemon = THREAD.Thread(target = motorThread, daemon = True)

ser = ZS.AsciiSerial("COM3")
stage1_y = ZS.AsciiDevice(ser, 2)
stage1_x = ZS.AsciiDevice(ser, 3)
stage1_r = ZS.AsciiDevice(ser, 7)
stage1_f = ZS.AsciiDevice(ser, 6)

root = TK.Tk()
root.geometry("150x190")
root.title("Stage")
root.configure(background = "white")
root.wm_attributes("-transparentcolor", "white")
root.wm_attributes("-alpha", 1)
root.wm_attributes("-topmost", True)
root.wm_attributes("-toolwindow", True)

speedlabel = TK.Label(root, text = "Speed (microsteps):", width = 18)
speedlabel.pack(side = TK.TOP)
speedbar = TK.Scale(root, from_ = 10, to = 1500,
                    length = 130, orient = TK.HORIZONTAL)
speedbar.pack(side = TK.TOP)

frame = TK.Frame(root, width = 150, height = 150)
frame.configure(background = "white")
frame.pack(side = TK.TOP)

leftButton = TK.Button(frame, text = "Left",
                       width = 5, height = 2)
leftButton.bind('<ButtonPress-1>', start_left)
leftButton.bind('<ButtonRelease-1>', stop)
leftButton.grid(row = 2, column = 1)

rightButton = TK.Button(frame,
                   text = "Right",
                       width = 5, height = 2)
rightButton.bind('<ButtonPress-1>', start_right)
rightButton.bind('<ButtonRelease-1>', stop)
rightButton.grid(row = 2, column = 3)

upButton = TK.Button(frame,
                   text = "Up",
                       width = 5, height = 2)
upButton.bind('<ButtonPress-1>', start_up)
upButton.bind('<ButtonRelease-1>', stop)
upButton.grid(row = 1, column = 2)

downButton = TK.Button(frame,
                   text = "Down",
                       width = 5, height = 2)
downButton.bind('<ButtonPress-1>', start_down)
downButton.bind('<ButtonRelease-1>', stop)
downButton.grid(row = 3, column = 2)

cwButton = TK.Button(frame,
                   text = "CW",
                       width = 5, height = 2)
cwButton.bind('<ButtonPress-1>', start_cw)
cwButton.bind('<ButtonRelease-1>', stop)
cwButton.grid(row = 1, column = 3)

ccwButton = TK.Button(frame,
                   text = "CCW",
                       width = 5, height = 2)
ccwButton.bind('<ButtonPress-1>', start_ccw)
ccwButton.bind('<ButtonRelease-1>', stop)
ccwButton.grid(row = 1, column = 1)

focusButton = TK.Button(frame,
                   text = "Focus", command = findFocus,
                       width = 5, height = 2)
focusButton.grid(row = 2, column = 2)

fupButton = TK.Button(frame,
                   text = "Rise",
                       width = 5, height = 2)
fupButton.bind('<ButtonPress-1>', start_fup)
fupButton.bind('<ButtonRelease-1>', stop)
fupButton.grid(row = 3, column = 1)

fdnButton = TK.Button(frame,
                   text = "Sink",
                       width = 5, height = 2)
fdnButton.bind('<ButtonPress-1>', start_fdn)
fdnButton.bind('<ButtonRelease-1>', stop)
fdnButton.grid(row = 3, column = 3)

motorDaemon.start()
root.mainloop()
Mss.close()
