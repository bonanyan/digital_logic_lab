import time
import numpy as np
import cv2
import serial

def capture_images():
    # Initialize the camera
    cap = cv2.VideoCapture(0)

    # Check if the camera is opened correctly
    if not cap.isOpened():
        print("Error: Could not open the camera.")
        return

    # Set the frame rate (you can change this value according to your needs)
    frame_rate = 30
    prev_frame_time = 0

    while True:
        # Capture frame-by-frame
        ret, frame = cap.read()

        # Check if the frame was captured correctly
        if not ret:
            print("Error: Could not capture frame.")
            break

        # Display the resulting frame
        cv2.imshow('frame', frame)

        # Press "q" to exit the loop
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

        # Calculate the time between current frame and previous frame
        cur_frame_time = time.time()
        elapsed_time = cur_frame_time - prev_frame_time
        prev_frame_time = cur_frame_time

        # Sleep for the remaining time to maintain the frame rate
        if elapsed_time < 1.0 / frame_rate:
            time.sleep(1.0 / frame_rate - elapsed_time)

    # Release the camera and close all windows
    cap.release()
    cv2.destroyAllWindows()


    
    
    # GetImage()
    # Preprocess()
    # Compute()
    # Postprocess()
    
    
import argparse
import serial

def read_byte_from_uart(port, baud_rate):
    # Initialize the serial port
    ser = serial.Serial(port, baud_rate)

    # Read 1 byte from the serial port
    data = ser.read(1)

    # Check if the data was read correctly
    if len(data) == 0:
        print("Error: Could not read data from serial port.")
        return None

    # Convert the byte to a character
    char = data.decode('utf-8')

    # Close the serial port
    ser.close()

    return char

if __name__ == '__main__':
    # Initialize the argument parser
    parser = argparse.ArgumentParser(description='Read 1 byte from the UART serial port.')
    parser.add_argument('-p', '--port', help='Serial port to read data from.', required=True)
    parser.add_argument('-b', '--baud_rate', help='Baud rate of the serial port.', type=int, default=9600)

    # Parse the command-line arguments
    args = parser.parse_args()

    # Read 1 byte from the serial port
    byte_read = read_byte_from_uart(args.port, args.baud_rate)

    if byte_read is not None:
        print("Received byte:", byte_read)
