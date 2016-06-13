source ~/.gdb/pal_thread.gdb
source ~/.gdb/stl-views-1.0.3.gdb

python

import os
home_dir = os.path.expanduser("~")
sys.path.insert(0, os.path.join(home_dir, 'dotfiles/utils/kdevelop/debuggers/gdb/printers'))

from qt import register_qt_printers
register_qt_printers (None)

from kde import register_kde_printers
register_kde_printers (None)

end
