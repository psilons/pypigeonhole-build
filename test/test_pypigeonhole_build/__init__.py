import os
import sys

# This is to fix the src module path during unit testing from command line.
# Really an ugly hack, not natural. The command line runner assume the current
# folder as src.
PROJECT_PATH = os.getcwd()

SOURCE_PATH = os.path.join(PROJECT_PATH, "src")
sys.path.append(SOURCE_PATH)
