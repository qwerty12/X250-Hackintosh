// For solving instant wake by hooking GPRW

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "_XHCPRW", 0)
{
#endif
    External(QPRW, PkgObj)
    External(RMCF.DWOU, IntObj)

    // In DSDT, native XHC._PRW is renamed QPRW with Clover binpatch.
    // As a result, calls to XHC._PRW land here.
    // The purpose of this implementation is to avoid "instant wake"
    // by returning 0 in the second position (sleep state supported)
    // of the return package.
    // XHC._PRW is renamed to QPRW so we can replace it here
    External(_SB.PCI0.XHC.QPRW, PkgObj)
    Method(_SB.PCI0.XHC._PRW)
    {
        Local0 = \_SB.PCI0.XHC.QPRW
        If (1)
        {
            // when RMCF.DWOU is provided and is zero, patch disabled
            If (CondRefOf(\RMCF.DWOU)) { If (!\RMCF.DWOU) { Return(Local0) }}
            // either RMCF.DWOU not provided, or is non-zero, patch is enabled
            Local0[1] = 0
        }
        Return(Local0)
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF
