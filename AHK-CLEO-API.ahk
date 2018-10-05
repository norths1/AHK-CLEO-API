/*
	AHK-CLEO-API
	
	MIT License

	Copyright (c) 2018 Rinat_Namazov

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
*/

; WinApi functions.
GetProcAddress(hModule, lpProcName)
{
	return DllCall("kernel32.dll\GetProcAddress", "UInt", hModule, "AStr", lpProcName)
}

GetModuleHandle(lpModuleName)
{
	return DllCall("kernel32.dll\GetModuleHandle", "Str", lpModuleName)
}

class CLEO
{
	static DLL				:= "CLEO.asi"
		, hModule			:= 0
		, Funcs				:= {}
		, CallBackAddr		:= {}
	
	__New() ; Constructor.
	{
		while (!this.hModule)
			this.hModule := GetModuleHandle(this.DLL)
		
		this.Funcs.RegisterOpcode	:= GetProcAddress(this.hModule, "_CLEO_RegisterOpcode@8")
		
		return this
	}
	
	__Delete() ; Destructor.
	{
		for k, v in this.CallBackAddr
			DllCall("GlobalFree", "Ptr", v) ; Очистка памяти.
	}
	
	RegisterOpcode(opcode, function)
	{
		if (this.CallBackAddr[opcode])
		{
			throw Exception("Opcode is already registered.")
			return false
		}
		if (!func_addr := RegisterCallback(function))
		{
			throw Exception("Error registration address for ahk functions.")
			return false
		}
		this.CallBackAddr[opcode] := func_addr
		return DllCall(this.Funcs.RegisterOpcode, "UInt", opcode, "UInt", func_addr)
	}
}
