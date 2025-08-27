#!/usr/bin/env python3

import re
from datetime import datetime
import argparse

def parse_log_file(input_file, output_file):
    # Regular expression pattern to match timestamp and message
    pattern = r'(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}) (.+)'
    
    try:
        with open(input_file, 'r') as f_in, open(output_file, 'w') as f_out:
            for line in f_in:
                match = re.match(pattern, line.strip())
                if match and 'ERROR' in line:
                    timestamp, message = match.groups()
                    f_out.write(f"{timestamp} {message}\n")
                    
    except FileNotFoundError:
        print(f"Error: Could not find the input file '{input_file}'")
    except Exception as e:
        print(f"An error occurred: {str(e)}")

def main():
    parser = argparse.ArgumentParser(description='Parse log file and extract ERROR messages with timestamps')
    parser.add_argument('input_file', help='Path to the input log file')
    parser.add_argument('output_file', help='Path to save the filtered output')
    
    args = parser.parse_args()
    parse_log_file(args.input_file, args.output_file)

if __name__ == '__main__':
    main()