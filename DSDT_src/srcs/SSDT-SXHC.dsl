#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "_SXHC", 0)
{
#endif
    External(_SB.PCI0.XHC.QPRW, PkgObj)
    Method(_SB.PCI0.XHC.SXHC)
    {
        Return
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF
