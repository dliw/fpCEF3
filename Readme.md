fpCEF3
======

Chromium Embedded Framework for Free Pascal

## How to get started on
#### [Windows]
Download CEF3 from [here][1] and copy all .dll files from either `Debug` or `Release` to the directory your .exe is / will be in.

Install `cef3.lpk` into Lazarus

Look into the examples

#### [Linux]
Download CEF3 from [here][1] and copy / link _libcef.so_ (and maybe _libffmpegsumo.so_),  
  a) to a default library location, eg. `/usr/lib(64)`, `/usr/local/lib(64)` __OR__  
  b) somewhere and set `LD_LIBRARY_PATH` accordingly

Install `cef3.lpk` into Lazarus

Look into the examples

##### Notes
Don't use `--single-process` or change `CefSingleProcess` to `True`. This will trigger a SIGSEGV in pthread_mutex_lock. It's a bug in either CEF3 or Chromium itself: You can find more details [here][4]  

~~Make sure to switch **off** any runtime checks in the project settings:~~  
While `-Ci` `-Cr` and `-Co` seem to be ok, it still is better to switch off `-Ct` and `-CR`.
Nevertheless, if crashes occur too often, runtime test should be turned off as a first step.  

Also libcef.so needs the resources (folder `locales` and `cef.pak`, you can find them in the CEF package) in the directory where your executable is.

### SubProcess
When initialising CEF for the first time (mostly in your main app) a subprocess is started. By default a second instance of the main program is used as the subprocess.
The preferred way however is to define an own (minimal) subprocess executable.

You can achive this in fpCEF3 by setting `CefBrowserSubprocessPath` to the **path** of your subprocess executable.
In the `LCLSimple` example this can be done by changing `TMainform.FormCreate` at the end of `main.pas`.

A minimal subprocess can be found in `/Examples/SubProcess`. It should work for any use case.  
Note, that the subprocess also needs the CEF3 library and resources in its path, so the easiest way is to put the subprocess executable in the same folder as the main exe.

More details [here][5]


## FAQ:
### Which versions of CEF are supported?

fpCEF3 only supports CEF3, *no* support for CEF1.  
Version 3.1547.1412 (and newer) should work.

### Which platforms are supported?

- Windows
- Linux with GTK2

The plain header should be ready for Mac (maybe with small changes), but the component needs to be adopted.

### How stable is fpCEF?
That's hard to say.  
On Windows things look good, I didn't have a single crash so far while browsing big websites and running several browser benchmarks.  
On Linux there are still crashes, but it seems that they occur less often. Unfortunately CEF3 itself seems to have some serious bugs on its Linux part.


### Is there a documentation for fpCEF?
No, but you can find information in

- cef3lib.pas / cef3api.pas
- the sample programs (admittedly very basic ones)
- the official api docs [here][2]
- the official cefclient example program [here][3]

If you feel like contributing some more Pascal examples - please do.

### What are the differences to dcef3?
- compatibility with Free Pascal / Lazarus
- reworked unit layout - more modular
- slightly changed mechanism for loading the library
- cef3api_static unit
- _removed_ VLC and FMX component

### Can I help?
Of course - patches are always welcome :)

### Can you help?
To a certain amount - yes, but don't expect too much.

## Links:
 *  [Chromium Embedded Framework](http://code.google.com/p/chromiumembedded)
 *  [Delphi CEF](http://code.google.com/p/dcef3)
 *  [WACEF](https://bitbucket.org/WaspAce/wacef)

 *  [fpCEF3](http://github.com/dliw/fpCEF3)

[1]:http://www.magpcss.net/cef_downloads
[2]:http://magpcss.org/ceforum/apidocs3/
[3]:http://code.google.com/p/chromiumembedded/source/browse/#svn%2Ftrunk%2Fcef3%2Ftests%2Fcefclient
[4]:https://code.google.com/p/chromiumembedded/issues/detail?id=976
[5]:https://code.google.com/p/chromiumembedded/wiki/Architecture#CEF3