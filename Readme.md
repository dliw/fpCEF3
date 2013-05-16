fpCEF3
======

Chromium Embedded Framework for Free Pascal

It is still in an early state, expect crashes, exceptions and other bad things...

## How to get started on
#### [Linux]
Download CEF3 from [here][1] and copy / link _libcef.so_,  
  a) to the default library paths, eg. `/usr/lib(64)`, `/usr/local/lib(64)` __OR__  
  b) somewhere and set `LD_LIBRARY_PATH` accordingly

Install `cef3.lpk` into Lazarus

Look into the examples

### Very important:
Make sure to switch **off** any runtime checks in the project settings:
**No** `-Ci` `-Co` `-Cr` `-Ct`, unless you want to have various crashes at different places.
Unfortunately it's not clear to me, what the reason is...


## FAQ:
### Which versions of CEF are supported?

fpCEF3 only supports CEF3, *no* support for CEF1.  
Version 3.1453.1255 (and newer) should work, didn't test for older ones.

### Which platforms are supported?

Currently only Linux with gtk2 is tested and fully implemented.

The plain header should be ready for Windows and Mac (maybe with small changes), but the component definitely needs a bit of work to support more platforms.


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

 *  [fpCEF3](http://github.com/dliw/fpCEF3)

[1]:http://www.magpcss.net/cef_downloads
[2]:http://magpcss.org/ceforum/apidocs3/
[3]:http://code.google.com/p/chromiumembedded/source/browse/#svn%2Ftrunk%2Fcef3%2Ftests%2Fcefclient