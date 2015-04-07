# Command line history
# Borrowed from https://github.com/whiteinge/dotfiles/blob/53da9abc2fc871c41654236c6edd9bff155a681e/.pdbrc.py#L18
import readline
histfile = os.path.expanduser("~/.pdb-pyhist")
try:
    readline.read_history_file(histfile)
except IOError:
    pass
import atexit
atexit.register(readline.write_history_file, histfile)
del histfile
readline.set_history_length(1000)

# Return to debugger after a fatal exception has occurred
# Borrowed from https://github.com/whiteinge/dotfiles/blob/53da9abc2fc871c41654236c6edd9bff155a681e/.pdbrc.py#L30
from bdb import sys
def info(type, value, tb):
    if hasattr(sys, 'ps1') or not sys.stderr.isatty():
        sys.__excepthook__(type, value, tb)
    import traceback, pdb
    traceback.print_exception(type, value, tb)
    print
    pdb.pm()
sys.excepthook = info

def listdict(l):
    print '\033[94m*** %i elements\033[0m' % (len(l),)
    return [x.__dict__ for x in l]

