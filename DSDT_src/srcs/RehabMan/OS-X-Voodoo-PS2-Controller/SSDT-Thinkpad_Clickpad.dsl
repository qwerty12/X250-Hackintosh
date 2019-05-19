// Example overrides for Thinkpad models with ClickPad
#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 2, "hack", "ps2", 0)
{
#endif
    // Change _SB.PCI0.LPC.KBD if your PS2 keyboard is at a different ACPI path
    External(_SB.PCI0.LPC.KBD, DeviceObj)
    Scope(_SB.PCI0.LPC.KBD)
    {
        /*Name(QTHS, 0x00)
        Method(QTHR, 0, Serialized)
        {
            External(\_SB.PCI0.LPC.EC.HKEY.BCCS, MethodObj)
            External(\_SB.PCI0.LPC.EC.HKEY.BCSS, MethodObj)

            If (QTHS != 0x00) {
                Return
            }

            QTHS = 0x01

            // Notes from https://github.com/teleshoes/tpacpi-bat/blob/master/battery_asl & thanks to https://github.com/MirkoCovizzi/thinkpad-p51-hackintosh/blob/master/EFI/CLOVER/ACPI/patched/SSDT-CFAN.dsl
            Local1 = 75 // Start charging when battery is at this level (1-99: Threshold to start charging battery (Relative capacity))
            Local2 = 80 // Stop charging when battery is at this level (1-99: Threshold to stop charging battery (Relative capacity))

            Local0 = 2 // BatteryID (0: Any battery, 1: Primary battery, 2: Secondary battery, Others: Reserved (0))
            While (Local0) {
                Local3 = Local0 << 8
                \_SB.PCI0.LPC.EC.HKEY.BCCS(Local3 | Local1)
                \_SB.PCI0.LPC.EC.HKEY.BCSS(Local3 | Local2)

                Local0--
            }
        }*/

        // Select specific configuration in VoodooPS2Trackpad.kext
        Method(_DSM, 4)
        {
            If (!Arg2) { Return (Buffer() { 0x03 } ) }

            //QTHR()

            Return (Package()
            {
                "RM,oem-id", "LENOVO",
                "RM,oem-table-id", "Thinkpad_ClickPad",
            })
        }
        // Overrides (the example data here is default in the Info.plist)
        Name(RMCF, Package()
        {
            "Synaptics TouchPad", Package()
            {
                "BogusDeltaThreshX", 800,
                "BogusDeltaThreshY", 800,
                "ScrollResolution", 400,
                "TrackpointScrollYMultiplier", 0xFFFF, //Remove this line in order to normalise the vertical scroll direction of the Trackpoint when holding the middle mouse button.
                "TrackpointScrollXMultiplier", 0xFFFF, //Remove this line in order to normalise the horizontal scroll direction of the Trackpoint when holding the middle mouse button.
            },
            "Keyboard", Package() // SSDT-PrtSc-F13
            {
                "Custom PS2 Map", Package()
                {
                    Package(){},
                    "e037=64", // PrtSc=F13
                },
            },
            "ALPS GlidePoint", Package()
            {
                "DisableDevice", ">y",
            },
            "Sentelic FSP", Package()
            {
                "DisableDevice", ">y",
            },
            "Mouse", Package()
            {
                "DisableDevice", ">y",
            },
            "Controller", Package()
            {
                "WakeDelay", 0,
            }
        })
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF
