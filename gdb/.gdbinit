source ~/.gdb/pal_thread.gdb
source ~/.gdb/stl-views-1.0.3.gdb

python

import os
home_dir = os.path.expanduser("~")
sys.path.insert(0, os.path.join(home_dir, 'dotfiles/utils/kdevelop/debuggers/gdb/printers'))

from qt4 import register_qt4_printers
register_qt4_printers (None)

from kde4 import register_kde4_printers
register_kde4_printers (None)

end
