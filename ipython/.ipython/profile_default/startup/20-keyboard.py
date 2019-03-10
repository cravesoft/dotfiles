from IPython import get_ipython

ip = get_ipython()
registry = ip.pt_app.key_bindings

handler = next(kb.handler for kb in registry.bindings
               if kb.handler.__name__ in {"newline_autoindent",
                                          "newline_with_copy_margin"})
registry.remove_binding(handler)
