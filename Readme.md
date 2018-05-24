fpCEF3
======

Chromium Embedded Framework for Free Pascal

## How to get started

- Install `cef3.lpk` into Lazarus
- [Download CEF3][1] (standard or minimal distribution). Make sure to use the correct CEF3 version (see the changelog / release tag); other versions (older or newer) usually don't work and are *not* recommended
- Create a new project or use one of the projects in the `Examples` folder. `LCLSimple` is a good starting point
- Read the following section on how to correctly set up the file layout


**Important**:  
Most examples use [build modes](http://wiki.freepascal.org/IDE_Window:_Compiler_Options#Selecting_the_active_build_mode). Make sure to select the correct one, otherwise compilation will fail.


## CEF setup

### macOS
Follow the instructions on the [wiki][wiki-macos].


### Windows and Linux
A CEF package contains
- the CEF library itself and related binaries in the `Release` or `Debug` folder and
- resources in the `Resources` folder.

By default CEF expects the library and binaries in `PATH` (Windows) or `LD_LIBRARY_PATH` (Linux) and the the resources in the same folder as the executable. A custom path for the library can be set using `CefLibraryDirPath`. The path for the resources can be changed by setting `CefResourcesDirPath` and `CefLocalesDirPath`. However, __some files cannot be moved__:

#### Windows
- `chrome_elf.dll` has to be in `PATH` or the same folder as the executable
- `icudtl.dat` has to be in `PATH`

#### Linux
- `icudtl.dat` and `*_blob.bin` have to be in the same folder as the executable

**Important**:  
Make sure to include `cthreads` as the first unit in your main program.  
If you build CEF3 yourself make sure `tcmalloc` is disabled.


## Hints
Don't use `--single-process` or change `CefSingleProcess` to `True`. This mode is not officially supported by Chromium.

If the browser goes "blank" (e.g. when loading a page), the render process crashed. See **Debugging**  on how to debug the render process. The render process restarts automatically on the next page request.


### SubProcess
If CEF is initialized a subprocess is started. By default a second instance of the main program is used as the subprocess. Nevertheless, the preferred way is to define an own (minimal) subprocess executable. In fpCEF3 this can be done by setting `CefBrowserSubprocessPath` to the **path** of the subprocess executable. In the `LCLSimple` example this setting can be found in the `Initialization` section at the end of `main.pas`.

A minimal subprocess can be found in the folder `/Examples/SubProcess`. The subprocess also needs the CEF3 library and resources in its path, so it is recommended to put the subprocess executable in the same folder as the main exe.  
More details can be found [here][5].

### Debugging
Sometimes it is useful to debug the subprocesses spawned by cef. On Linux this can be done by adding
```shell
--renderer-cmd-prefix='xterm -title renderer -e gdb --args'
```
to the command line.  
Further details can be found [here][6].


### Supported platforms
- Windows
- Linux (Gtk2 or Qt4)
- macOS (Cocoa)


### Documentation

You can find comments and usage information in

- cef3lib.pas / cef3api.pas
- the example projects in the `Examples` folder
- the official api docs [here][2]
- the official cefclient example program [here][3]


## Links:
 *  [Chromium Embedded Framework](https://bitbucket.org/chromiumembedded/cef)
 *  [Delphi CEF](https://github.com/hgourvest/dcef3)

 *  [fpCEF3](http://github.com/dliw/fpCEF3)

[![Donate](https://liberapay.com/assets/widgets/donate.svg)](https://liberapay.com/dliw/donate)

[wiki-macos]:https://github.com/dliw/fpCEF3/wiki/macOS
[1]:http://www.magpcss.net/cef_downloads
[2]:http://magpcss.org/ceforum/apidocs3/
[3]:https://bitbucket.org/chromiumembedded/cef/src/936e595fe5e9aa5e7641abf72e1f872f9d0ceb73/tests/cefclient/?at=master
[5]:https://bitbucket.org/chromiumembedded/cef/wiki/Architecture#markdown-header-cef3
[6]:https://chromium.googlesource.com/chromium/src/+/master/docs/linux_debugging.md
