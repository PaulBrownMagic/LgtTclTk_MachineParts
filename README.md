# A Machine Parts Manufacturing Profit Maximization Demo App

This application is intended to demonstrate a stand-alone Tcl/Tk application
querying Logtalk.

Currently supports the following backends:

- swilgt
- eclipselgt
- gplgt

Backends known to not be supported:

- BProlog (doesn't support `variable_names/1` option to `write_term/2`, which
  is needed for `tkinter`)
- CXProlog (no CLPFD)

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

Note, the application assumes the logtalk backend has been selected,
i.e. the Tcl will call `logtalk` and expect that to be one of `swilgt`,
`eclipselgt` or `gplgt`, which you can set with `logtalk_backend_select`.

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
