
### Q.1  Why my project crash with `unrecognized selector` during start?

Run time error message:

	2013-08-01 13:10:30.805 i[508:6d03] -[UIDevice platformString]: unrecognized selector sent to instance 0x1dd6a580
	2013-08-01 13:10:30.821 i[508:6d03] *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[UIDevice platformString]: unrecognized selector sent to instance 0x1dd6a580'
	*** First throw call stack:
	(0x329c73e7 0x3a6c2963 0x329caf31 0x329c964d 0x32921208 0x184183 0x19c95b 0x19c88b 0x3ab0f0e1 0x3ab0efa8)
	libc++abi.dylib: terminate called throwing an exception

**A:** Vitamio use category methods in libVitamio.a, you need add a linker
flag `-ObjC` in your project:
>
follow "`your project target` | Build Settings | Linking | Other Linker Flags", set the value of the
"Debug/Release" key to `-ObjC` .





(end)
