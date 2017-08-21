fpCEF3
======

Chromium Embedded Framework for Free Pascal

## How to get started

- Install `cef3.lpk` into Lazarus
- [Download CEF3][1] (standard or minimal distribution). Make sure to use the correct CEF3 version (see the changelog / release tag); other versions (older or newer) *may* work, but are *not* recommended
- Create a new project or use one of the projects in the `Examples` folder. `LCLSimple` is a good starting point
- Read the following sections on how to set up the correct file layout


**Important**: Most examples use [build modes](http://wiki.freepascal.org/IDE_Window:_Compiler_Options#Selecting_the_active_build_mode). Make sure to select the correct one, otherwise compilation will fail.


## CEF setup
A CEF package contains
- the CEF library itself and related binaries in the `Release` or `Debug` folder and
- resources in the `Resources` folder.

### Resources
Unless `CefResourcesDirPath` and `CefLocalesDirPath` is set, CEF expects the resources to be in the same folder as the executable.  
However, __in any case `icudtl.dat` must be in the same folder as the CEF library!__

### Binaries
The setup of the binaries depends on the target operating system:

#### Windows
Copy all files from either `Debug` or `Release` to the folder your .exe will be in.

#### Linux
Copy or link _libcef.so_,  
  a) to a default library location, eg. `/usr/lib(64)`, `/usr/local/lib(64)` __or__  
  b) somewhere and set `LD_LIBRARY_PATH` accordingly

**Important**:  
Make sure to include `cthreads` as the first unit in your main program.  
If you build CEF3 yourself make sure `tcmalloc` is disabled.

#### macOS
Follow the description on the [wiki][wiki-macos]. The following hints don't apply to macOS.


## Hints
Don't use `--single-process` and don't change `CefSingleProcess` to `True`.  
This will trigger a SIGSEGV in pthread_mutex_lock, which is a bug in either CEF3 or Chromium itself: You can find more details [here][4].

If the browser goes "blank" (e.g. when loading a page), the render process crashed.
Most of the time it seems to be related to JavaScript/V8, see **Debugging**  on how to debug the render process.  
The render process restarts automatically on the next page request.


### SubProcess
When initializing CEF for the first time (mostly in your main app) a subprocess is started. By default a second instance of the main program is used as the subprocess.

The preferred way however is to define an own (minimal) subprocess executable. In fpCEF3 this can be done by setting `CefBrowserSubprocessPath` to the **path** of the subprocess executable.
In the `LCLSimple` example this setting can be found in `TMainform.FormCreate` at the end of `main.pas`.

A minimal subprocess is in the folder `/Examples/SubProcess`. The subprocess also needs the CEF3 library and resources in its path, so it is recommended to put the subprocess executable in the same folder as the main exe.

More details can be found [here][5]

### Debugging
Sometimes it is useful to debug the subprocesses spawned by cef. On Linux this can be done by adding
```shell
--renderer-cmd-prefix='xterm -title renderer -e gdb --args'
```
to the command line.  
Further details can be found [here][6].


## FAQ:

### Which platforms are supported?

- Windows
- Linux with GTK2 or QT
- macOS with Cocoa

### Is there a documentation for fpCEF?

No, but you can find information in

- cef3lib.pas / cef3api.pas
- the examples projects in the `Examples` folder
- the official api docs [here][2]
- the official cefclient example program [here][3]

Contributions of additional Pascal examples are very welcome.


## Links:
 *  [Chromium Embedded Framework](https://bitbucket.org/chromiumembedded/cef)
 *  [Delphi CEF](https://github.com/hgourvest/dcef3)

 *  [fpCEF3](http://github.com/dliw/fpCEF3)

[wiki-macos]:https://github.com/dliw/fpCEF3/wiki/macOS
[1]:http://www.magpcss.net/cef_downloads
[2]:http://magpcss.org/ceforum/apidocs3/
[3]:https://bitbucket.org/chromiumembedded/cef/src/936e595fe5e9aa5e7641abf72e1f872f9d0ceb73/tests/cefclient/?at=master
[4]:https://code.google.com/p/chromiumembedded/issues/detail?id=976
[5]:https://bitbucket.org/chromiumembedded/cef/wiki/Architecture#markdown-header-cef3
[6]:https://chromium.googlesource.com/chromium/src/+/master/docs/linux_debugging.md
