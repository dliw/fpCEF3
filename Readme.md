fpCEF3
======

Chromium Embedded Framework for Free Pascal

## How to get started
Install cef3.lpk into Lazarus

### Windows
Download CEF3 from [here][1a] or [here][1b] and copy all files from either `Debug` or `Release` to the folder your .exe is / will be in.

### Linux
You need a build of CEF3 with `tcmalloc` disabled. The [official CEF binaries][1a] are suitable.

Copy / link _libcef.so_,  
  a) to a default library location, eg. `/usr/lib(64)`, `/usr/local/lib(64)` __or__  
  b) somewhere and set `LD_LIBRARY_PATH` accordingly

Make sure to include `cthreads` as the first unit in your main program.

#### General notes
Apart from the files in the `Debug` or `Release` folder, CEF needs the files / folders from the `Resources` folder. Unless you set `CefResourcesDirPath` and `CefLocalesDirPath`, CEF expects them to be in the folder your executable is in.  
However in any case `icudtl.dat` __must__ be in the same folder as the CEF library!

## Hints

Don't use `--single-process` and don't change `CefSingleProcess` to `True`.  
This will trigger a SIGSEGV in pthread_mutex_lock, which is a bug in either CEF3 or Chromium itself: You can find more details [here][4].

If the browser goes "blank" (e.g. when loading a page), the render process crashed.
Most of the time it seems to be related to JavaScript/V8, see **Debugging**  on how to debug the render process.  
Please note, that the render process will be automatically restarted on the next page request.


### SubProcess
When initialising CEF for the first time (mostly in your main app) a subprocess is started. By default a second instance of the main program is used as the subprocess.
The preferred way however is to define an own (minimal) subprocess executable.

You can achieve this in fpCEF3 by setting `CefBrowserSubprocessPath` to the **path** of your subprocess executable.
In the `LCLSimple` example this can be done by changing `TMainform.FormCreate` at the end of `main.pas`.

A minimal subprocess can be found in `/Examples/SubProcess`. Note, that the subprocess also needs the CEF3 library and resources in its path, so the easiest way is to put the subprocess executable in the same folder as the main exe.

More details [here][5]

### Debugging
Sometimes it is useful to debug the subprocesses spawned by cef. On Linux this can be done by adding
```shell
--renderer-cmd-prefix='xterm -title renderer -e gdb --args'
```
to the command line.  
Further details can be found [here][6].

## FAQ:
### Which versions of CEF are supported?

fpCEF3 only supports CEF3, *no* support for CEF1.  
See changelog or release tag for the currently supported version, other versions (older or newer) *may* work, but are *not* recommended.

### Which platforms are supported?

- Windows
- Linux with GTK2 or QT

The plain header is ready for Mac, but the component needs to be adopted.

### Is there a documentation for fpCEF?
No, but you can find information in

- cef3lib.pas / cef3api.pas
- the sample programs (admittedly very basic ones)
- the official api docs [here][2]
- the official cefclient example program [here][3]

If you feel like contributing some more Pascal examples - please do.

### Can I help?
Of course - patches are always welcome :)

### Can you help?
To a certain amount - yes.

## Links:
 *  [Chromium Embedded Framework](https://bitbucket.org/chromiumembedded/cef)
 *  [Delphi CEF](https://github.com/hgourvest/dcef3)
 *  [WACEF](https://bitbucket.org/WaspAce/wacef)

 *  [fpCEF3](http://github.com/dliw/fpCEF3)

[1a]:http://www.magpcss.net/cef_downloads
[1b]:http://www.cefbuilds.com
[2]:http://magpcss.org/ceforum/apidocs3/
[3]:https://bitbucket.org/chromiumembedded/cef/src/936e595fe5e9aa5e7641abf72e1f872f9d0ceb73/tests/cefclient/?at=master
[4]:https://code.google.com/p/chromiumembedded/issues/detail?id=976
[5]:https://bitbucket.org/chromiumembedded/cef/wiki/Architecture#markdown-header-cef3
[6]:https://chromium.googlesource.com/chromium/src/+/master/docs/linux_debugging.md
