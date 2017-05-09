# entry point for .pyfunc.py
import sys

if __name__ == "__main__":
    import pyfunk
    getattr(pyfunk, sys.argv[1])(*sys.argv[2:])
