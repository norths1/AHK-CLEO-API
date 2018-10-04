#include AHK-CLEO-API.ahk

cleo := new CLEO()
cleo.RegisterOpcode(0x1234, "Opcode_1234")
Opcode_1234()
{
    MsgBox, Opcode_1234 was called.
}