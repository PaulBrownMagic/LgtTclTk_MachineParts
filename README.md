# A Machine Parts Manufacturing Profit Maximization Demo App

This application is intended to demonstrate a stand-alone Tcl/Tk application
querying Logtalk.

Currently supports the following backends:

- eclipselgt
- gplgt
- sicstuslgt
- swilgt
- yaplgt

Backends known to not be supported:

- B-Prolog (doesn't support `variable_names/1` option to `write_term/2`, which
  is needed for `tkinter`)
- CxProlog (no CLP(FD) library)

## Dependencies

- Tcl/Tk needs to be installed so that `wish` is on your `$PATH`
- Logtalk with one of the above listed backends

## Running

A Tcl/Tk application is run like so:

```bash
:~$ wish machine_parts.tcl
```

For your convenience there's a bash run script provided:

```bash
:~$ ./run
```

Note, the application assumes that one of the supported Logtalk backends
listed above has been selected, i.e. the Tcl will call `logtalk` and expect
that to be one set using the `logtalk_backend_select` script.

If you wish to change this behaviour, the variable `load_cmd` in
`lgt_query.lgt` is the thing you need to change.

## About this application

This is a typical constraint solver problem. The scenario is for a
machine-parts manufacturer who makes two products: "Unit A" and "Unit B". Each
product uses so much time on each of the machines: lathe, polisher and press.
Given so many available hours the manufacturer assuming 100% sales would like
to maximize their profit. This tool will tell them how many of each unit to
produce.

See Also: [SWISH Notebook](https://swish.swi-prolog.org/p/CLPFD:%20Introduction%20to%20Solving%20Problems%20with%20Limited%20Resources.swinb) on these kinds of problems.
