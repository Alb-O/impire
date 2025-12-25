#!/usr/bin/env python3
"""
Thumb Wheel Gesture Daemon for Niri

Listens to thumb wheel events from Solaar and simulates
Mod+MiddleMouse+drag gesture for smooth horizontal panning in Niri.

Uses a virtual mouse device via uinput to move the "cursor" without
affecting the actual physical mouse cursor position.

Requires: ydotool, socat, python-evdev
"""

import os
import sys
import socket
import subprocess
import time
import threading
from pathlib import Path
from evdev import UInput, ecodes as e


class ThumbGestureDaemon:
    def __init__(self, socket_path="/tmp/thumb-gesture.sock", release_delay=0.15):
        self.socket_path = socket_path
        self.is_panning = False
        self.release_delay = release_delay  # Time to wait before releasing gesture
        self.last_event_time = 0
        self.release_timer = None
        self.gesture_lock = threading.Lock()
        
        # Create virtual mouse device for movement
        self.virtual_mouse = UInput({
            e.EV_REL: [e.REL_X, e.REL_Y],
            e.EV_KEY: [e.BTN_LEFT, e.BTN_MIDDLE, e.BTN_RIGHT],
        }, name='niri-thumb-gesture-virtual-mouse')
        
    def send_ydotool_cmd(self, *args):
        """Execute ydotool command"""
        try:
            subprocess.run(
                ["ydotool", *args],
                check=True,
                capture_output=True,
                timeout=1.0
            )
        except subprocess.CalledProcessError as e:
            print(f"ydotool error: {e.stderr.decode()}", file=sys.stderr)
        except subprocess.TimeoutExpired:
            print("ydotool timeout", file=sys.stderr)
    
    def start_pan_gesture(self):
        """Start the pan gesture: Press and hold Super+MiddleMouse"""
        with self.gesture_lock:
            if not self.is_panning:
                print("Starting pan gesture", flush=True)
                # Press Super key (key code 125)
                self.send_ydotool_cmd("key", "125:1")
                time.sleep(0.005)  # Small delay between key and button
                # Press and HOLD Middle Mouse Button (0x42 = button 2 down)
                self.send_ydotool_cmd("click", "0x42")
                self.is_panning = True
    
    def end_pan_gesture(self):
        """End the pan gesture: Release MiddleMouse+Super"""
        with self.gesture_lock:
            if self.is_panning:
                print("Ending pan gesture", flush=True)
                # Release Middle Mouse Button (0x82 = button 2 up)
                self.send_ydotool_cmd("click", "0x82")
                time.sleep(0.005)
                # Release Super key
                self.send_ydotool_cmd("key", "125:0")
                self.is_panning = False
    
    def schedule_release(self):
        """Schedule gesture release after inactivity"""
        # Cancel existing timer
        if self.release_timer:
            self.release_timer.cancel()
        
        # Schedule new release
        self.release_timer = threading.Timer(self.release_delay, self.end_pan_gesture)
        self.release_timer.daemon = True
        self.release_timer.start()
    
    def move_virtual_mouse(self, dx):
        """Move virtual mouse device (doesn't affect physical cursor)"""
        # Send relative movement event via virtual mouse
        self.virtual_mouse.write(e.EV_REL, e.REL_X, dx)
        self.virtual_mouse.syn()
    
    def handle_thumb_event(self, direction, amount):
        """
        Handle thumb wheel event
        direction: 'left' or 'right'
        amount: scroll amount (typically 1-10)
        """
        current_time = time.time()
        
        # Convert scroll amount to pixel movement
        # Adjust multiplier for desired sensitivity
        pixels = amount * 30  # Increased for smoother panning
        
        if direction == 'left':
            pixels = -pixels
        
        # Start gesture if not already active
        self.start_pan_gesture()
        
        # Move virtual mouse (not physical cursor) to trigger pan
        self.move_virtual_mouse(pixels)
        
        # Update last event time
        self.last_event_time = current_time
        
        # Schedule gesture release (will be cancelled if more events come)
        self.schedule_release()
    
    def run_socket_server(self):
        """Run Unix domain socket server to receive events"""
        # Remove existing socket file
        if os.path.exists(self.socket_path):
            os.unlink(self.socket_path)
        
        with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as server:
            server.bind(self.socket_path)
            server.listen(1)
            os.chmod(self.socket_path, 0o666)
            
            print(f"Thumb gesture daemon listening on {self.socket_path}")
            
            while True:
                conn, _ = server.accept()
                with conn:
                    while True:
                        data = conn.recv(1024)
                        if not data:
                            break
                        
                        # Parse message: "direction:amount\n"
                        message = data.decode().strip()
                        try:
                            direction, amount = message.split(':')
                            self.handle_thumb_event(direction, int(amount))
                        except ValueError:
                            print(f"Invalid message: {message}", file=sys.stderr)
    
    def run(self):
        """Main entry point"""
        try:
            self.run_socket_server()
        except KeyboardInterrupt:
            print("\nShutting down...")
            self.end_pan_gesture()
            if os.path.exists(self.socket_path):
                os.unlink(self.socket_path)
        finally:
            # Clean up virtual mouse device
            if hasattr(self, 'virtual_mouse'):
                self.virtual_mouse.close()


if __name__ == "__main__":
    daemon = ThumbGestureDaemon()
    daemon.run()
